// server.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080

int main() {
    int server_fd, client_fd;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) { perror("socket"); exit(EXIT_FAILURE); }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
        perror("bind"); exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 3) < 0) { perror("listen"); exit(EXIT_FAILURE); }

    printf("Server listening on port %d...\n", PORT);

    client_fd = accept(server_fd, (struct sockaddr*)&address, (socklen_t*)&addrlen);
    if (client_fd < 0) { perror("accept"); exit(EXIT_FAILURE); }
    printf("Client connected\n");

    ssize_t r = recv(client_fd, buffer, sizeof(buffer)-1, 0);
    if (r > 0) {
        buffer[r] = '\0';
        printf("Received from client: %s\n", buffer);
    } else {
        perror("recv");
    }

    const char *reply = "Hello from server";
    send(client_fd, reply, strlen(reply), 0);

    close(client_fd);
    close(server_fd);
    return 0;
}

