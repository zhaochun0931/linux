FROM ubuntu:22.04

# Install kernel build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libncurses-dev \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    git \
    wget \
    bc \
    cpio \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /kernel
