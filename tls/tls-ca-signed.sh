openssl req -x509 -new -nodes -keyout ca.key -out ca.crt -subj "/C=US/ST=State/L=City/O=MyCA/OU=IT/CN=MyCA"



├── ca.crt
└── ca.key





openssl req -new -nodes -keyout ldap.key -out ldap.csr \
-subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=ldap.example.com"

├── ca.crt
├── ca.key
├── ldap.csr
└── ldap.key





openssl x509 -req -in ldap.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ldap.crt -days 365


├── ca.crt
├── ca.key
├── ca.srl
├── ldap.crt
├── ldap.csr
└── ldap.key




openssl verify -CAfile ca.crt ldap.crt







