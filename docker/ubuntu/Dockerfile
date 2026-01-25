FROM ubuntu:22.04

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /data

RUN apt-get update && apt-get install -y \
    openjdk-17-jdk netcat \
    && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
