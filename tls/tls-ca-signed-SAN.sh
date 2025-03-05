openssl genrsa -out ca.key

openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -out ca.crt -subj "/C=CN/ST=Shanghai/O=ORG/OU=ORG_UNIT/CN=myca"






openssl req -new -nodes -keyout ldap.key -out ldap.csr -config san.cnf
openssl x509 -req -in ldap.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ldap.crt -days 365 -extfile san.cnf -extensions req_ext



openssl x509 -in ldap.crt -noout -text | grep -A 1 "Subject Alternative Name"

