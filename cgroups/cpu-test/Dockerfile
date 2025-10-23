FROM ubuntu:24.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y stress-ng sysstat && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]

