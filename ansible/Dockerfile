FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install required packages
RUN apt update && \
    apt install -y openssh-server sudo python3 iputils-ping sshpass vim ansible && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd

# Create ansible user
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    usermod -aG sudo ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    ssh-keygen -t rsa

# Expose SSH port
EXPOSE 22

# Start SSH by default
CMD ["/usr/sbin/sshd", "-D"]
