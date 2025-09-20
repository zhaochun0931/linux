#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
#include <sys/socket.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <destination IP> <packet size>\n", argv[0]);
        exit(1);
    }

    const char *dest_ip = argv[1];
    int packet_size = atoi(argv[2]);

    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        perror("socket");
        exit(1);
    }

    // Enable Path MTU Discovery (force DF bit)
    int val = IP_PMTUDISC_DO;
    if (setsockopt(sock, IPPROTO_IP, IP_MTU_DISCOVER, &val, sizeof(val)) < 0) {
        perror("setsockopt(IP_MTU_DISCOVER)");
        close(sock);
        exit(1);
    }

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(33434); // arbitrary port (like traceroute)
    if (inet_pton(AF_INET, dest_ip, &addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sock);
        exit(1);
    }

    char *buf = malloc(packet_size);
    memset(buf, 'A', packet_size);

    printf("Sending %d bytes to %s with DF set...\n", packet_size, dest_ip);
    ssize_t sent = sendto(sock, buf, packet_size, 0, (struct sockaddr *)&addr, sizeof(addr));

    if (sent < 0) {
        perror("sendto");
    } else {
        printf("Sent %zd bytes successfully.\n", sent);
    }

    free(buf);
    close(sock);
    return 0;
}
