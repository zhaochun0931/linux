openssl req -x509 -new -nodes -keyout myca.key -out myca.crt -subj "/C=US/ST=State/L=City/O=MyCA/OU=IT/CN=MyCA"



├── myca.crt
└── myca.key





openssl req -new -nodes -keyout ldap.key -out ldap.csr \
-subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=xiaomingldap.com"

├── myca.crt
├── myca.key
├── ldap.csr
└── ldap.key





openssl x509 -req -in ldap.csr -CA myca.crt -CAkey myca.key -CAcreateserial -out ldap.crt -days 365


├── myca.crt
├── myca.key
├── myca.srl
├── ldap.crt
├── ldap.csr
└── ldap.key




openssl verify -CAfile myca.crt ldap.crt
