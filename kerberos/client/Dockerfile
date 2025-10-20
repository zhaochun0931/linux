FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user && \
    apt install iputils-ping netcat-openbsd -y && \
    apt-get clean

COPY krb5.conf /etc/krb5.conf

