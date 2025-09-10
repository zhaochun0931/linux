openssl req -new -nodes -keyout ldap.key -out ldap.csr -config san.cnf
openssl x509 -req -in ldap.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ldap.crt -days 365 -extfile san.cnf -extensions req_ext



1️⃣ Create your CA
# Generate CA private key
openssl genrsa -out ca.key 4096

# Create self-signed CA certificate (valid 10 years)
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -out ca.crt \
  -subj "/C=US/ST=CA/L=SanFrancisco/O=MyOrg/OU=IT/CN=MyRootCA"


Now you have:
ca.key (CA private key)
ca.crt (CA cert, trusted root)





2️⃣ Generate Server Key + CSR with SAN

First, create an OpenSSL config file (san.cnf):

[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
C=US
ST=CA
L=SanFrancisco
O=MyOrg
OU=IT
CN=myserver.local

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = myserver.local
DNS.2 = localhost
IP.1  = 127.0.0.1


Now generate key + CSR:
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config san.cnf

3️⃣ Sign Server CSR with CA
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
  -CAcreateserial -out server.crt -days 825 -sha256 \
  -extensions req_ext -extfile san.cnf


You now have:
server.key (private key)
server.crt (signed by CA)
ca.crt (trust anchor)

4️⃣ Verify SANs
openssl x509 -in server.crt -text -noout | grep -A1 "Subject Alternative Name"


You should see DNS:myserver.local, DNS:localhost, IP:127.0.0.1.

5️⃣ Convert to PKCS#12 (Java needs this)
# Bundle key + cert into PKCS#12
openssl pkcs12 -export -in server.crt -inkey server.key \
  -certfile ca.crt -out server.p12 -name myserver \
  -password pass:changeit

6️⃣ Import into JKS Keystore & Truststore
# Create keystore from PKCS#12
keytool -importkeystore \
  -deststorepass changeit -destkeypass changeit \
  -destkeystore keystore.jks \
  -srckeystore server.p12 -srcstoretype PKCS12 \
  -srcstorepass changeit -alias myserver

# Import CA cert into truststore
keytool -import -trustcacerts -alias myCA \
  -file ca.crt -keystore truststore.jks \
  -storepass changeit -noprompt


✅ Now you have:

keystore.jks → contains server private key + cert

truststore.jks → contains CA cert (to trust clients signed by it)







keytool -importkeystore \
  -srckeystore keystore.jks \
  -destkeystore keystore.p12 \
  -srcstoretype JKS \
  -deststoretype PKCS12 \
  -srcstorepass changeit \
  -deststorepass changeit \
  -destkeypass changeit \
  -alias myserver



keytool -importkeystore \
  -srckeystore truststore.jks \
  -destkeystore truststore.p12 \
  -srcstoretype JKS \
  -deststoretype PKCS12 \
  -srcstorepass changeit \
  -deststorepass changeit


  

