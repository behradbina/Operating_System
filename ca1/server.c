#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <poll.h>
#include <unistd.h>
#include <map>
#include <thread>
#include <mutex>

typedef struct pollfd pollfd;

#define BUFFER_SIZE 1024
#define MAX_PLAYERS 2

std::mutex room_mutex;  // To protect shared resources (rooms)

struct Room {
    int room_fd;
    int player_count;
    int player_fds[MAX_PLAYERS];  // Store file descriptors of players
    std::string choices[MAX_PLAYERS];  // Store choices: "rock", "paper", "scissors"
};

// Global container for rooms
std::map<int, Room> rooms;  // room_fd -> Room
int num_rooms;

void start_room_game(Room& room) {
    char buffer[BUFFER_SIZE];

    // Send the game start signal to both players
    const char* start_msg = "Game started! Choose rock, paper, or scissors:\n";
    for (int i = 0; i < MAX_PLAYERS; ++i) {
        send(room.player_fds[i], start_msg, strlen(start_msg), 0);
    }

    // Wait for players to send choices within 10 seconds
    struct pollfd pfds[MAX_PLAYERS];
    for (int i = 0; i < MAX_PLAYERS; ++i) {
        pfds[i].fd = room.player_fds[i];
        pfds[i].events = POLLIN;
    }

    int result = poll(pfds, MAX_PLAYERS, 10000);  // 10 seconds timeout
    if (result <= 0) {
        // Timeout or error, both players lose if no response
        const char* timeout_msg = "Timeout! Both players lose.\n";
        for (int i = 0; i < MAX_PLAYERS; ++i) {
            send(room.player_fds[i], timeout_msg, strlen(timeout_msg), 0);
        }
        return;
    }

    for (int i = 0; i < MAX_PLAYERS; ++i) {
        if (pfds[i].revents & POLLIN) {
            recv(room.player_fds[i], buffer, BUFFER_SIZE, 0);
            room.choices[i] = std::string(buffer);  // Store the player's choice
        } else {
            room.choices[i] = "";  // Timeout case, no choice made
        }
    }

    // Game logic to determine the winner
    const char* result_msg;
    if (room.choices[0] == room.choices[1]) {
        result_msg = "Draw! Both players chose the same.\n";
    } else if (
        (room.choices[0] == "rock" && room.choices[1] == "scissors") ||
        (room.choices[0] == "scissors" && room.choices[1] == "paper") ||
        (room.choices[0] == "paper" && room.choices[1] == "rock")) {
        result_msg = "Player 1 wins!\n";
    } else {
        result_msg = "Player 2 wins!\n";
    }

    for (int i = 0; i < MAX_PLAYERS; ++i) {
        send(room.player_fds[i], result_msg, strlen(result_msg), 0);
    }
}

void handle_room(int room_fd) {
    Room& room = rooms[room_fd];

    // Wait until the room has two players
    while (room.player_count < MAX_PLAYERS) {
        // Busy waiting or use a condition variable (skipped for simplicity)
    }

    start_room_game(room);
}

int main(int argc, char* argv[]) {
    if (argc != 4) {
        perror("Invalid Arguments. Usage: ./server.out {IP} {PORT} {#Rooms}");
        exit(EXIT_FAILURE);
    }

    char* ipaddr = argv[1];
    int base_port = strtol(argv[2], NULL, 10);
    num_rooms = strtol(argv[3], NULL, 10);

    struct sockaddr_in server_addr, room_addr;
    int server_fd, opt = 1;

    // Setup Connector socket
    server_addr.sin_family = AF_INET;
    if (inet_pton(AF_INET, ipaddr, &(server_addr.sin_addr)) == -1)
        perror("FAILED: Input ipv4 address invalid");

    if ((server_fd = socket(PF_INET, SOCK_STREAM, 0)) == -1)
        perror("FAILED: Socket was not created");

    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1)
        perror("FAILED: Making socket reusable failed");

    server_addr.sin_port = htons(base_port);
    if (bind(server_fd, (struct sockaddr*)(&server_addr), sizeof(server_addr)) == -1)
        perror("FAILED: Bind unsuccessfull");

    if (listen(server_fd, 20) == -1)
        perror("FAILED: Listen unsuccessfull");

    printf("Connector running on %s:%d with %d rooms.\n", ipaddr, base_port, num_rooms);

    // Initialize rooms
    for (int i = 0; i < num_rooms; ++i) {
        int room_fd = socket(PF_INET, SOCK_STREAM, 0);
        room_addr.sin_family = AF_INET;
        room_addr.sin_addr.s_addr = server_addr.sin_addr.s_addr;
        room_addr.sin_port = htons(base_port + 1 + i);

        if (bind(room_fd, (struct sockaddr*)(&room_addr), sizeof(room_addr)) == -1)
            perror("FAILED: Room bind unsuccessful");

        if (listen(room_fd, 2) == -1)
            perror("FAILED: Room listen unsuccessful");

        // Create room instance
        Room room;
        room.room_fd = room_fd;
        room.player_count = 0;
        rooms[room_fd] = room;

        // Start room handler in a new thread
        std::thread(handle_room, room_fd).detach();
        printf("Room %d is ready on port %d.\n", i, base_port + 1 + i);
    }

    // Poll for new player connections
    std::vector<pollfd> pfds;
    pfds.push_back(pollfd{server_fd, POLLIN, 0});

    while (1) {
        if (poll(pfds.data(), pfds.size(), -1) == -1) {
            perror("Poll failed");
            continue;
        }

        for (size_t i = 0; i < pfds.size(); ++i) {
            if (pfds[i].revents & POLLIN) {
                // Handle new player connection
                struct sockaddr_in new_addr;
                socklen_t new_size = sizeof(new_addr);
                int new_fd = accept(server_fd, (struct sockaddr*)(&new_addr), &new_size);

                // Send list of rooms to player
                char room_list[BUFFER_SIZE] = "Available rooms:\n";
                for (const auto& [room_fd, room] : rooms) {
                    if (room.player_count < MAX_PLAYERS) {
                        char temp[50];
                        sprintf(temp, "Room %d on port %d\n", room_fd, ntohs(room_addr.sin_port));
                        strcat(room_list, temp);
                    }
                }
                send(new_fd, room_list, strlen(room_list), 0);
            }
        }
    }

    close(server_fd);
    return 0;
}
