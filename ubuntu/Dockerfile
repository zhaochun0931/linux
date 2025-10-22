FROM ubuntu:24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package index and install common tools
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Default working directory
WORKDIR /root

CMD ["/bin/bash"]

