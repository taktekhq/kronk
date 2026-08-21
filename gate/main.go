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
	pubTimeout = 5 * time.Second
	debounce   = 100 * time.Millisecond
	unlockHold = 3 * time.Second
)

// relayOwner is a single-slot semaphore. Whoever holds it owns the relay:
// an unlock pulse, or shutdown. An UNLOCK that finds it taken is dropped.
var relayOwner = make(chan struct{}, 1)

func main() {
	broker := mustEnv("KRONK_BROKER")
	user := mustEnv("KRONK_MQTT_USER")
	pass := mustEnv("KRONK_MQTT_PASS")

	relay, err := gpiocdev.RequestLine(chip, relayPin, gpiocdev.AsOutput(0))
	if err != nil {
		log.Fatalf("relay GPIO%d: %v", relayPin, err)
	}
	defer relay.Close()

	opts := mqtt.NewClientOptions().
		AddBroker(broker).
		SetClientID(clientID).
		SetUsername(user).
		SetPassword(pass).
		SetAutoReconnect(true).
		SetWriteTimeout(pubTimeout).
		SetWill(statusTopic, "offline", qos, true).
		SetOnConnectHandler(func(c mqtt.Client) {
			log.Printf("connected to %s", broker)
			// Subscribe first, the publishes below can block 5s each
			// and commands during that window would be lost.
			subscribe(c, relay)
			publish(c, statusTopic, qos, true, "online")
			// The relay idles low. Reconcile retained state left over
			// from dying mid-pulse. A reconnect during a pulse shows
			// LOCKED a moment early, the pulse ends on LOCKED anyway.
			publish(c, lockStateTopic, qos, true, "LOCKED")
			// Clear a retained command so the broker cannot replay it.
			publish(c, lockSetTopic, qos, true, "")
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
			// QoS 0, a ring replayed after an outage is a false ring.
			// Off the event loop, a slow socket must not block presses.
			go publish(client, doorbellTopic, 0, false, "ding")
		}))
	if err != nil {
		log.Fatalf("button GPIO%d: %v", buttonPin, err)
	}
	defer button.Close()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	<-sig

	// Take the relay: waits out an in-flight pulse, blocks new ones.
	relayOwner <- struct{}{}
	if err := relay.SetValue(0); err != nil {
		log.Printf("relay off: %v", err)
	}

	// 1s, not the usual 5s: shutdown must not hang on a dead socket,
	// and the will covers offline if this publish never lands.
	client.Publish(statusTopic, qos, true, "offline").WaitTimeout(time.Second)
	client.Disconnect(250)
}

func subscribe(client mqtt.Client, relay *gpiocdev.Line) {
	t := client.Subscribe(lockSetTopic, qos, func(_ mqtt.Client, m mqtt.Message) {
		// A retained UNLOCK would replay on every reconnect. Live only.
		if m.Retained() || string(m.Payload()) != "UNLOCK" {
			return
		}
		select {
		case relayOwner <- struct{}{}:
			go func() {
				defer func() { <-relayOwner }()
				unlock(client, relay)
			}()
		default:
			log.Print("unlock dropped, relay busy")
		}
	})
	go func() {
		t.Wait()
		if err := t.Error(); err != nil {
			log.Printf("subscribe %s: %v", lockSetTopic, err)
			return
		}
		// The token carries no error when the broker refuses with 0x80.
		if st, ok := t.(*mqtt.SubscribeToken); ok && st.Result()[lockSetTopic] >= 0x80 {
			log.Printf("subscribe %s: rejected 0x%x", lockSetTopic, st.Result()[lockSetTopic])
		}
	}()
}

// unlock pulses the relay. State follows the relay: nothing publishes
// until the pin actually changed.
func unlock(client mqtt.Client, relay *gpiocdev.Line) {
	log.Print("unlocking")
	if err := relay.SetValue(1); err != nil {
		log.Printf("relay on: %v", err)
		return
	}
	publish(client, lockStateTopic, qos, true, "UNLOCKED")
	time.Sleep(unlockHold)
	if err := relay.SetValue(0); err != nil {
		// Energized and stuck. Die: systemd restarts the daemon and
		// AsOutput(0) forces the pin low again.
		log.Fatalf("relay stuck on: %v", err)
	}
	publish(client, lockStateTopic, qos, true, "LOCKED")
}

func publish(client mqtt.Client, topic string, qos byte, retained bool, payload string) {
	t := client.Publish(topic, qos, retained, payload)
	if !t.WaitTimeout(pubTimeout) {
		log.Printf("publish %s: timeout", topic)
	} else if t.Error() != nil {
		log.Printf("publish %s: %v", topic, t.Error())
	}
}

func mustEnv(key string) string {
	v := os.Getenv(key)
	if v == "" {
		log.Fatalf("missing env %s", key)
	}
	return v
}
