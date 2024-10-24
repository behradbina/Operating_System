#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstdlib>
#include <unistd.h>
#include <cstring>

#define BUFFER_SIZE 1024

int main(int argc, char* argv[]) {
    if (argc != 3) {
        perror("Invalid Arguments. Usage: ./client.out {IP} {PORT}");
        exit(EXIT_FAILURE);
    }

    char* ipaddr = argv[1];
    int port = strtol(argv[2], NULL, 10);

    struct sockaddr_in server_addr;
    int server_fd;

    // Setup connection to Connector or Room
    server_addr.sin_family = AF_INET;
    if (inet_pton(AF_INET, ipaddr, &(server_addr.sin_addr)) == -1) {
        perror("FAILED: Invalid IPv4 address");
        exit(EXIT_FAILURE);
    }

    if ((server_fd = socket(PF_INET, SOCK_STREAM, 0)) == -1) {
        perror("FAILED: Socket was not created");
        exit(EXIT_FAILURE);
    }

    server_addr.sin_port = htons(port);
    if (connect(server_fd, (struct sockaddr*)(&server_addr), sizeof(server_addr)) != 0) {
        perror("FAILED: Connection failed");
        exit(EXIT_FAILURE);
    }

    printf("Connected to server at %s:%d\n", ipaddr, port);

    while (1) {
        char buffer[BUFFER_SIZE];
        memset(buffer, 0, BUFFER_SIZE);

        // Receive data from the server
        int recv_len = recv(server_fd, buffer, BUFFER_SIZE, 0);
        if (recv_len > 0) {
            printf("Server: %s\n", buffer);
        }

        // Input player choice and send it to the server
        printf("Enter your choice (rock, paper, or scissors): ");
        fgets(buffer, BUFFER_SIZE, stdin);
        send(server_fd, buffer, strlen(buffer), 0);
    }

    close(server_fd);
    return 0;
}
