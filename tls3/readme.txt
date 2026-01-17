openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt -extensions v3_ca -extfile server.cnf



openssl x509 -in server.crt -text -noout
