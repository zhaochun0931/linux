# Use Ubuntu 22.04 as the base
FROM ubuntu:22.04

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for the FRR repository
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    sudo \
    iproute2 \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Add FRR GPG key and repository
RUN curl -s https://deb.frrouting.org/frr/keys.gpg | tee /usr/share/keyrings/frrouting.gpg > /dev/null && \
    FRRVER="frr-stable" && \
    echo "deb [signed-by=/usr/share/keyrings/frrouting.gpg] https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER" | tee /etc/apt/sources.list.d/frr.list

# Install FRR
RUN apt-get update && apt-get install -y \
    frr \
    frr-pythontools \
    && rm -rf /var/lib/apt/lists/*

# Enable the BGP daemon
RUN sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons

# Start the FRR service and keep the container alive
CMD ["/usr/lib/frr/frrinit.sh", "start", "&&", "sleep", "infinity"]
# Note: Using ENTRYPOINT/CMD with a shell wrapper to handle FRR startup
ENTRYPOINT ["/bin/bash", "-c", "/usr/lib/frr/frrinit.sh start && tail -f /dev/null"]
