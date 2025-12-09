package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func main() {
	// Load CA certificate
	caCert, _ := os.ReadFile("/certs/ca.crt")
	caPool := x509.NewCertPool()
	caPool.AppendCertsFromPEM(caCert)

	// Load client certificate
	clientCert, err := tls.LoadX509KeyPair("/certs/client.crt", "/certs/client.key")
	if err != nil {
		log.Fatal("Cannot load client cert:", err)
	}

	tlsConfig := &tls.Config{
		RootCAs:      caPool,
		Certificates: []tls.Certificate{clientCert},
	}

	client := &http.Client{
		Transport: &http.Transport{TLSClientConfig: tlsConfig},
	}

	resp, err := client.Get("https://server:8443")
	if err != nil {
		log.Fatal("Request failed:", err)
	}

	body, _ := io.ReadAll(resp.Body)
	fmt.Println("Client received:", string(body))
}

