FROM python:3

ENV DEBIAN_FRONTEND=noninteractive

# Install Python, pip, and common utilities
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    vim \
    net-tools \
    iputils-ping \
    iproute2 \
    dnsutils \
    sshpass \
    git \
    && pip3 install --no-cache-dir ansible \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /data
CMD ["/bin/bash"]

