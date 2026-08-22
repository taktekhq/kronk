// mDNS resolution for .local broker names. The static build cannot use
// the system resolver, so ping resolves homeassistant.local and the
// daemon does not. A one-shot multicast query fills the gap.
package main

import (
	"errors"
	"fmt"
	"log"
	"net"
	"net/url"
	"strings"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"golang.org/x/net/dns/dnsmessage"
)

const (
	// Multicast over WiFi drops, hence the resends.
	mdnsTries = 3
	mdnsWait  = time.Second
)

var mdnsGroup = &net.UDPAddr{IP: net.IPv4(224, 0, 0, 251), Port: 5353}

// openConn dials the broker, resolving .local names over mDNS. Runs on
// every connect attempt, so the IP can move between reconnects.
func openConn(uri *url.URL, options mqtt.ClientOptions) (net.Conn, error) {
	if uri.Scheme != "tcp" {
		return nil, fmt.Errorf("scheme %s unsupported", uri.Scheme)
	}
	host := uri.Hostname()
	if strings.HasSuffix(host, ".local") {
		ip, err := resolveMDNS(host)
		if err != nil {
			return nil, fmt.Errorf("mdns %s: %w", host, err)
		}
		log.Printf("resolved %s to %s", host, ip)
		host = ip.String()
	}
	return net.DialTimeout("tcp", net.JoinHostPort(host, uri.Port()), options.ConnectTimeout)
}

// resolveMDNS asks the multicast group for an A record. The query
// leaves from an ephemeral port, which marks it legacy (RFC 6762 §6.7),
// so the responder answers unicast straight back to this socket. No
// listening on port 5353, no clash with a local avahi.
func resolveMDNS(host string) (net.IP, error) {
	conn, err := net.ListenUDP("udp4", nil)
	if err != nil {
		return nil, err
	}
	defer conn.Close()

	name, err := dnsmessage.NewName(host + ".")
	if err != nil {
		return nil, err
	}
	query := dnsmessage.Message{
		Questions: []dnsmessage.Question{{
			Name:  name,
			Type:  dnsmessage.TypeA,
			Class: dnsmessage.ClassINET,
		}},
	}
	packed, err := query.Pack()
	if err != nil {
		return nil, err
	}

	buf := make([]byte, 1500)
	for range mdnsTries {
		if _, err := conn.WriteToUDP(packed, mdnsGroup); err != nil {
			return nil, err
		}
		conn.SetReadDeadline(time.Now().Add(mdnsWait))
		for {
			n, _, err := conn.ReadFromUDP(buf)
			if err != nil {
				break
			}
			var m dnsmessage.Message
			if m.Unpack(buf[:n]) != nil {
				continue
			}
			for _, ans := range m.Answers {
				a, ok := ans.Body.(*dnsmessage.AResource)
				if ok && strings.EqualFold(ans.Header.Name.String(), name.String()) {
					return net.IP(a.A[:]), nil
				}
			}
		}
	}
	return nil, errors.New("no answer")
}
