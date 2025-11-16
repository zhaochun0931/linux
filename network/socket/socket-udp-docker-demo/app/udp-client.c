#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>

#define SERVER_NAME "udp-server"
#define PORT 5005
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    char buffer[BUFFER_SIZE];
    struct sockaddr_in servaddr;

    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);

    // Resolve Docker service name
    struct hostent *he = gethostbyname(SERVER_NAME);
    if (he == NULL) {
        perror("gethostbyname failed");
        exit(1);
    }
    memcpy(&servaddr.sin_addr, he->h_addr_list[0], he->h_length);

    for (int i = 0; i < 5; i++) {
        sprintf(buffer, "Hello from C client %d", i + 1);
        sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&servaddr, sizeof(servaddr));

        int n = recvfrom(sockfd, buffer, BUFFER_SIZE, 0, NULL, NULL);
        buffer[n] = '\0';
        printf("Received echo: %s\n", buffer);

        sleep(1);
    }

    close(sockfd);
    return 0;
}

