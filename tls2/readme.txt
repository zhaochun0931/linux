openssl genpkey -algorithm RSA -out ca.key
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -config openssl-ca.cnf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365 -extensions req_ext -extfile openssl-san.cnf





openssl genpkey -algorithm RSA -out server.key
openssl req -new -key server.key -out server.csr -config openssl-san.cnf
openssl x509 -req -in server.csr -signkey server.key -out server.crt -days 365 -extensions req_ext -extfile openssl-san.cnf








