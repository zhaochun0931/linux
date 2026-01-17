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
	caCert, err := os.ReadFile("ca.crt")
	if err != nil {
		log.Fatal(err)
	}

	caPool := x509.NewCertPool()
	caPool.AppendCertsFromPEM(caCert)

	tlsConfig := &tls.Config{
		ClientCAs:  caPool,
		ClientAuth: tls.RequireAndVerifyClientCert,
		MinVersion: tls.VersionTLS12,
    	MaxVersion: tls.VersionTLS12,
	}

	server := &http.Server{
		Addr:      ":8443",
		TLSConfig: tlsConfig,
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("Client certificate verified!")
		io.WriteString(w, "Hello from the mTLS Server!\n")
	})

	fmt.Println("Server listening on https://localhost:8443")
	log.Fatal(server.ListenAndServeTLS("server.crt", "server.key"))
}

