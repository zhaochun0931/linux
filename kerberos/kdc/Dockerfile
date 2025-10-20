FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-kdc krb5-admin-server && \
    apt install iputils-ping netcat-openbsd -y && \
    apt-get clean

COPY krb5.conf /etc/krb5.conf
COPY kdc.conf /etc/krb5kdc/kdc.conf
COPY kadm5.acl /etc/krb5kdc/kadm5.acl

RUN krb5_newrealm <<EOF
adminpass
adminpass
EOF

# Create sample principals
RUN echo "addprinc -pw alicepass alice" | kadmin.local && \
    echo "addprinc -pw adminpass admin/admin" | kadmin.local && \
    echo "ktadd -k /etc/krb5.keytab host/kdc.example.com" | kadmin.local

CMD service krb5-kdc start && \
    service krb5-admin-server start && \
    tail -f /var/log/krb5kdc.log /var/log/kadmind.log

