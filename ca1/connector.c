#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>

#define PORT 8080
#define MAX_ROOMS 5
#define MAX_PLAYERS 10
#define JOIN_SUCCESSFULLY 1
#define FULLROOM 0 


typedef struct 
{
    int room_id;
    int player_count;
} Room;

Room rooms[MAX_ROOMS];
int player_sockets[MAX_PLAYERS];
int current_players = 0;

void* handle_player(void* arg) 
{
    int player_fd = *(int*)arg;
    char buffer[1024] = {0};
    
    // Send the list of available rooms
    sprintf(buffer, "Available rooms:\n");
    for (int i = 0; i < MAX_ROOMS; i++) 
    {
        char room_info[50];

        sprintf(room_info, "Room %d: %d/2 players\n",
            rooms[i].room_id, rooms[i].player_count);
        
        strcat(buffer, room_info);
    }

    send(player_fd, buffer, strlen(buffer), 0);
    
    // Receive the player's chosen room
    int room_choice;
    int status;
    recv(player_fd, &room_choice, sizeof(room_choice), 0);

    if (room_choice < MAX_ROOMS && rooms[room_choice].player_count < 2) 
    {
        rooms[room_choice].player_count++;
        status = JOIN_SUCCESSFULLY;
        send(player_fd, &status, sizeof(status), 0);
    } 
    else 
    {
        status = FULLROOM;
        send(player_fd, &status, sizeof(status), 0);
        close(player_fd);
        pthread_exit(NULL);
    }
    
    
    while (rooms[room_choice].player_count < 2);

    send(player_fd, "Game started! Choose Rock, Paper, or Scissors:\n", 45, 0);

    recv(player_fd, buffer, sizeof(buffer), 0);

    printf("Player %d chose: %s\n", player_fd, buffer);
    
    close(player_fd);
    pthread_exit(NULL);
}

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    
    // Initialize rooms
    for (int i = 0; i < MAX_ROOMS; i++) {
        rooms[i].room_id = i;
        rooms[i].player_count = 0;
    }
    
    // Create socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket failed");
        exit(EXIT_FAILURE);
    }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind socket
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }
    
    // Listen for connections
    if (listen(server_fd, 3) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }
    printf("Connector listening on port %d\n", PORT);
    
    while (1) {
        if ((new_socket = accept(server_fd, (struct sockaddr*)&address, (socklen_t*)&addrlen)) < 0) {
            perror("Accept failed");
            exit(EXIT_FAILURE);
        }
        printf("New player connected!\n");
        pthread_t thread_id;
        pthread_create(&thread_id, NULL, handle_player, (void*)&new_socket);
    }
    
    return 0;
}
