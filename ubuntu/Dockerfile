FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    vim \
    net-tools \
    iputils-ping \
    iproute2 \
    dnsutils \
    sudo \
    less \
    htop \
    procps \
    openssh-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd

# Only create user if not exists
RUN id -u ubuntu &>/dev/null || useradd -m -s /bin/bash ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu

USER root
CMD ["/usr/sbin/sshd", "-D"]
