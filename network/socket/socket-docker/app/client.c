// client.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>

#define PORT "8080"
#define MAX_RETRIES 30
#define RETRY_SLEEP 1

int main() {
    int sock = -1;
    struct addrinfo hints, *res, *rp;
    int rc, attempt = 0;
    char buf[1024] = {0};

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;       // IPv4
    hints.ai_socktype = SOCK_STREAM; // TCP

    // Resolve service name "server" (Docker Compose service) to IP(s)
    rc = getaddrinfo("server", PORT, &hints, &res);
    if (rc != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rc));
        return 1;
    }

    // Try each returned addr; but we will retry if connection refused
    for (attempt = 1; attempt <= MAX_RETRIES; ++attempt) {
        for (rp = res; rp != NULL; rp = rp->ai_next) {
            sock = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
            if (sock < 0) continue;

            if (connect(sock, rp->ai_addr, rp->ai_addrlen) == 0) {
                // connected
                goto connected;
            }

            close(sock);
            sock = -1;
        }

        fprintf(stderr, "Attempt %d: server not ready yet, retrying in %d sec...\n", attempt, RETRY_SLEEP);
        sleep(RETRY_SLEEP);
    }

    freeaddrinfo(res);
    fprintf(stderr, "Failed to connect after %d attempts\n", MAX_RETRIES);
    return 2;

connected:
    freeaddrinfo(res);

    // Send message
    const char *msg = "Hello from client";
    if (send(sock, msg, (int)strlen(msg), 0) < 0) {
        perror("send");
        close(sock);
        return 3;
    }

    // Read reply
    ssize_t n = recv(sock, buf, sizeof(buf)-1, 0);
    if (n < 0) perror("recv");
    else {
        buf[n] = '\0';
        printf("Received from server: %s\n", buf);
    }

    close(sock);
    return 0;
}

