# create a private key
openssl genrsa -out server.key 2048


#If we want our certificate signed, we need a certificate signing request (CSR), create a CSR (domain.csr) from our existing private key, the important field is Common Name, # which should be the exact Fully Qualified Domain Name (FQDN) of our domain. A challenge password and An optional company name can be left empty
openssl req -key server.key -new -out server.csr















# or create both the private key and CSR with a single command
openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr











# Creating a Self-Signed Certificate, A self-signed certificate is a certificate that's signed with its own private key. 
# It can be used to encrypt data just as well as CA-signed certificates, but our users will be shown a warning that says the certificate isn't trusted.

# create a self-signed certificate (domain.crt) with our existing private key and CSR:
openssl x509 -signkey server.key -in server.csr -req -days 365 -out server.crt














# or just one command to create a cert and a private key in a single command, this command will create a temporary CSR. We still have the CSR information prompt, of course.
# We can create a self-signed certificate with just a private key:
openssl req -key server.key -new -x509 -days 365 -out server.crt


















# create a private key and a self-signed certificate with just a single command:
openssl req -nodes -x509 -newkey rsa:2048 -keyout tls.key -out tls.crt
openssl req -nodes -x509 -newkey rsa:4096 -sha3-256 -keyout tls.key -out tls.crt




openssl x509 -in tls.crt -text -noout





# test the self-signed cert

# First use openssl s_server to start a TLS/SSL test server on port 8443:

openssl s_server -accept 8443 -cert domain.crt -key domain.key






# Then open another terminal to use openssl s_client to connect to test server on port 8443:

openssl s_client -connect localhost:8443




openssl ciphers -s -tls1_3
openssl s_client -connect localhost:10334 -tls1_3




