// Command kronk-gate bridges the gate GPIO to MQTT.
// The doorbell button on GPIO27 publishes kronk/doorbell.
// UNLOCK on kronk/lock/set pulses the relay on GPIO17.
package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/warthog618/go-gpiocdev"
)

const (
	clientID = "kronk-gate"
	chip     = "gpiochip0"

	buttonPin = 27
	relayPin  = 17

	doorbellTopic  = "kronk/doorbell"
	lockSetTopic   = "kronk/lock/set"
	lockStateTopic = "kronk/lock/state"
	statusTopic    = "kronk/status"

	qos        = 1
	debounce   = 100 * time.Millisecond
	unlockHold = 3 * time.Second
)

func main() {
	broker := mustEnv("KRONK_BROKER")
	user := mustEnv("KRONK_MQTT_USER")
	pass := mustEnv("KRONK_MQTT_PASS")

	relay, err := gpiocdev.RequestLine(chip, relayPin, gpiocdev.AsOutput(0))
	if err != nil {
		log.Fatalf("relay GPIO%d: %v", relayPin, err)
	}
	defer relay.Close()

	// Capacity 1: an UNLOCK during a pulse is dropped, not queued.
	unlocks := make(chan struct{}, 1)

	opts := mqtt.NewClientOptions().
		AddBroker(broker).
		SetClientID(clientID).
		SetUsername(user).
		SetPassword(pass).
		SetAutoReconnect(true).
		SetConnectRetry(true).
		SetWill(statusTopic, "offline", qos, true).
		SetOnConnectHandler(func(c mqtt.Client) {
			log.Printf("connected to %s", broker)
			publish(c, statusTopic, true, "online")
			c.Subscribe(lockSetTopic, qos, func(_ mqtt.Client, m mqtt.Message) {
				if string(m.Payload()) != "UNLOCK" {
					return
				}
				select {
				case unlocks <- struct{}{}:
				default:
				}
			})
		}).
		SetConnectionLostHandler(func(_ mqtt.Client, err error) {
			log.Printf("connection lost: %v", err)
		})

	client := mqtt.NewClient(opts)
	if t := client.Connect(); t.Wait() && t.Error() != nil {
		log.Fatalf("connect %s: %v", broker, t.Error())
	}

	button, err := gpiocdev.RequestLine(chip, buttonPin,
		gpiocdev.WithPullUp,
		gpiocdev.WithFallingEdge,
		gpiocdev.WithDebounce(debounce),
		gpiocdev.WithEventHandler(func(gpiocdev.LineEvent) {
			log.Print("doorbell pressed")
			publish(client, doorbellTopic, false, "ding")
		}))
	if err != nil {
		log.Fatalf("button GPIO%d: %v", buttonPin, err)
	}
	defer button.Close()

	go func() {
		for range unlocks {
			unlock(client, relay)
		}
	}()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	<-sig

	client.Publish(statusTopic, qos, true, "offline").WaitTimeout(time.Second)
	client.Disconnect(250)
}

func unlock(client mqtt.Client, relay *gpiocdev.Line) {
	log.Print("unlocking")
	publish(client, lockStateTopic, true, "UNLOCKED")
	if err := relay.SetValue(1); err != nil {
		log.Printf("relay on: %v", err)
	}
	time.Sleep(unlockHold)
	if err := relay.SetValue(0); err != nil {
		log.Printf("relay off: %v", err)
	}
	publish(client, lockStateTopic, true, "LOCKED")
}

func publish(client mqtt.Client, topic string, retained bool, payload string) {
	t := client.Publish(topic, qos, retained, payload)
	go func() {
		if t.Wait(); t.Error() != nil {
			log.Printf("publish %s: %v", topic, t.Error())
		}
	}()
}

func mustEnv(key string) string {
	v := os.Getenv(key)
	if v == "" {
		log.Fatalf("missing env %s", key)
	}
	return v
}
