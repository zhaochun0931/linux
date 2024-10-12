# create a private key
openssl genrsa -out server.key



# create CSR
#If we want our certificate signed, we need a certificate signing request (CSR), create a CSR (domain.csr) from our existing private key, the important field is Common Name, which should be the exact Fully Qualified Domain Name (FQDN) of our domain. A challenge password and An optional company name can be left empty
openssl req -key server.key -new -out server.csr



# or just create both the private key and CSR with a single command
openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr

















# Creating a Self-Signed Certificate, A self-signed certificate is a certificate that's signed with its own private key. 
# It can be used to encrypt data just as well as CA-signed certificates, but our users will be shown a warning that says the certificate isn't trusted.

# create a self-signed certificate (domain.crt) with our existing private key and CSR:
openssl x509 -signkey server.key -in server.csr -req -days 365 -out server.crt




# Up till now, you have a private key and a self signed cert



















# or just one command to create a cert and a private key in a single command, this command will create a temporary CSR. We still have the CSR information prompt, of course.
# We can create a self-signed certificate with just a private key:
openssl req -x509 -nodes -newkey rsa:2048 -keyout server.key -out server.crt 
openssl req -x509 -nodes -newkey rsa -keyout server.key -out server.crt 


























# create a private key and a self-signed certificate with just a single command:
openssl req -x509 -nodes -newkey rsa:2048 -keyout server.key -out server.crt
openssl req -x509 -noenc -newkey rsa:2048 -keyout server.key -out server.crt
openssl req -x509 -nodes -newkey rsa:4096 -sha3-256 -keyout server.key -out server.crt



















