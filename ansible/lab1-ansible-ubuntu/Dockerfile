# Start with the official Ubuntu base
FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3 and clean up to keep the image small
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# The command to keep the container running for Ansible
CMD ["/bin/sh", "-c", "while true; do sleep 3600; done"]
