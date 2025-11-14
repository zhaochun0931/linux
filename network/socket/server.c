#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};

    // 1. Create socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == 0) { perror("socket failed"); exit(EXIT_FAILURE); }

    // 2. Bind
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
        perror("bind failed"); exit(EXIT_FAILURE);
    }

    // 3. Listen
    if (listen(server_fd, 3) < 0) { perror("listen"); exit(EXIT_FAILURE); }
    printf("Server listening on port %d...\n", PORT);

    // 4. Accept
    new_socket = accept(server_fd, (struct sockaddr*)&address, (socklen_t*)&addrlen);
    printf("Connection accepted\n");

    // 5. Read/Write
    read(new_socket, buffer, 1024);
    printf("Message from client: %s\n", buffer);
    send(new_socket, "Hello from server", strlen("Hello from server"), 0);
    printf("Reply sent\n");

    close(new_socket);
    close(server_fd);
    return 0;
}

