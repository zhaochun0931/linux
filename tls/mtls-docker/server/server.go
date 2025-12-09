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
	caCert, _ := os.ReadFile("/certs/ca.crt")
	clientCAPool := x509.NewCertPool()
	clientCAPool.AppendCertsFromPEM(caCert)

	tlsConfig := &tls.Config{
		ClientCAs:  clientCAPool,
		ClientAuth: tls.RequireAndVerifyClientCert,
	}

	server := &http.Server{
		Addr:      ":8443",
		TLSConfig: tlsConfig,
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "Hello from mTLS Server (Docker)!\n")
	})

	fmt.Println("Server running on https://server:8443 ...")
	log.Fatal(server.ListenAndServeTLS("/certs/server.crt", "/certs/server.key"))
}

