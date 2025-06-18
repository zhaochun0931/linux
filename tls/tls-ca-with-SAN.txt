# this guide is working.





# generate ca
openssl genrsa -out ca.key
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -out ca.crt -subj "/C=CN/ST=Shanghai/O=ORG/OU=ORG_UNIT/CN=myca"



# Up till now, the ca.crt and the ca.key are successfully generated.







# generate server key

export SERVERNAME1=$(hostname)


export SERVERNAME1=name1
export SERVERNAME2=name2
export SERVERNAME3=name3
export SERVERNAME4=*.name


export SERVERNAME1=*.my-rabbit-nodes.rabbitmq-system.svc.local
export SERVERNAME2=my-rabbit.rabbitmq-system.svc.local




# Ensure that the wildcard character * is placed correctly. 
# It should only be at the beginning of the domain part, like *.example.com. It cannot be used for the top-level domain (e.g., *example.com is invalid).



openssl genrsa -out server.key

# generate the private key with password
openssl genrsa -out server.key -aes256



# cannot add the space between the "<" and the "(print" in above command

openssl req -new -sha256 -key server.key \
-subj "/C=CN/ST=Shanghai/O=ORG/OU=ORG_UNIT/CN=$SERVERNAME1" \
-reqexts SAN \
-config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:$SERVERNAME1,DNS:$SERVERNAME2,DNS:$SERVERNAME3,DNS:$SERVERNAME4,IP:10.211.55.14\n")) \
-out server.csr









# sign csr with the ca
openssl x509 -req -extfile <(printf "subjectAltName=DNS:$SERVERNAME1,DNS:$SERVERNAME2,DNS:$SERVERNAME3,DNS:$SERVERNAME4,IP:10.211.55.14") -days 365 \
-in server.csr \
-CA ca.crt -CAkey ca.key -CAcreateserial \
-out server.crt -sha256




├── ca.crt
├── ca.key
├── ca.srl
├── server.crt
├── server.csr
└── server.key


# Up till now, the tls.crt and the tls.key are successfully generated.






















