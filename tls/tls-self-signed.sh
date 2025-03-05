# Creating a Self-Signed Certificate, A self-signed certificate is a certificate that's signed with its own private key. 

1. create private key
2. create certificate signing request (CSR) from the private key, the important field is Common Name, which should be the exact Fully Qualified Domain Name (FQDN) of our domain
3. create a self-signed certificate with our existing private key and CSR


openssl genrsa -out server.key
openssl req -key server.key -new -out server.csr



# or just create both the private key and CSR with a single command
openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr



openssl x509 -signkey server.key -in server.csr -req -days 365 -out server.crt








# create a private key and a self-signed certificate with just a single command, this command will create a temporary CSR

openssl req -x509 -nodes -newkey rsa -keyout server.key -out server.crt
openssl req -x509 -nodes -newkey rsa:2048 -keyout server.key -out server.crt
openssl req -x509 -nodes -newkey rsa:4096 -keyout server.key -out server.crt



openssl req -x509 -nodes -newkey rsa \
-keyout ldap.key -out ldap.crt \
-subj "/C=US/ST=State/L=City/O=MyOrg/OU=IT/CN=ldap.example.com"
