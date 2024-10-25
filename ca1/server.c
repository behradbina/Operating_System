#include "const.h"
#include <map>
#include <mutex>
#include <vector>
#include <string>
#include <thread>
#include <poll.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <cstring>
#include <fcntl.h>

using namespace std;

class Room {
public:
    Room(int fd, int port) : room_fd(fd), port(port), player_count(0) {
        memset(player_fds, -1, sizeof(player_fds));
        memset(choices, NOTCHOSEN, sizeof(choices));
    }

    int getRoomFd() const { return room_fd; }
    int getPort() const { return port; }
    int getPlayerCount() const { return player_count; }
    int getPlayerFd(int player_index) const { return player_fds[player_index]; }
    int getChoice(int player_index) const { return choices[player_index]; }
    bool isFull() const { return player_count >= ROOM_PLAYER; }

    bool addPlayer(int player_fd) {
        if (player_count < ROOM_PLAYER) {
            player_fds[player_count++] = player_fd;
            return true;
        }
        return false;
    }

    void setChoice(int player_index, int choice) {
        if (player_index < ROOM_PLAYER) {
            choices[player_index] = choice;
        }
    }

    void sendToAll(const char* message) const {
        for (int i = 0; i < player_count; ++i) {
            send(player_fds[i], message, strlen(message), 0);
        }
    }

    void startGame();

private:
    int room_fd;
    int port;
    int player_count;
    int player_fds[ROOM_PLAYER];
    int choices[ROOM_PLAYER];
};

// Room game logic
void Room::startGame() {
    char buffer[BUFFER_SIZE];
    const char* start_msg = "Game started! Choose rock, paper, or scissors:\n";
    sendToAll(start_msg);

    struct pollfd pfds[ROOM_PLAYER];
    for (int i = 0; i < player_count; ++i) {
        pfds[i].fd = player_fds[i];
        pfds[i].events = POLLIN;
    }

    int result = poll(pfds, player_count, 10000); // 10-second timeout
    if (result <= 0) {
        sendToAll("Timeout! Both players lose.\n");
        return;
    }

    for (int i = 0; i < player_count; ++i) {
        if (pfds[i].revents & POLLIN) {
            int choice;
            recv(player_fds[i], &choice, sizeof(choice), 0);
            setChoice(i, choice);
        }
    }

    const char* result_msg;
    if (choices[0] == choices[1]) {
        result_msg = "Draw! Both players chose the same.\n";
    } else if (
        (choices[0] == ROCK && choices[1] == SISSORS) ||
        (choices[0] == SISSORS && choices[1] == PAPER) ||
        (choices[0] == PAPER && choices[1] == ROCK)) {
        result_msg = "Player 1 wins!\n";
    } else {
        result_msg = "Player 2 wins!\n";
    }
    sendToAll(result_msg);
}

mutex room_mutex;
map<int, Room> rooms; // room_fd -> Room
int num_rooms;

// Helper function to add a new player to a room
bool addPlayerToRoom(int room_fd, int player_fd) {
    lock_guard<mutex> lock(room_mutex);
    Room& room = rooms[room_fd];
    return room.addPlayer(player_fd);
}

// Example usage of Room class in setup and handling functions
int set_up_connector(char *ipaddr, int base_port, int num_rooms) {
    struct sockaddr_in server_addr;
    int server_fd, opt = 1;

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(base_port);
    if (inet_pton(AF_INET, ipaddr, &(server_addr.sin_addr)) == -1)
        perror("FAILED: Input ipv4 address invalid");

    if ((server_fd = socket(PF_INET, SOCK_STREAM, 0)) == -1)
        perror("FAILED: Socket was not created");

    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1)
        perror("FAILED: Making socket reusable failed");

    if (bind(server_fd, (struct sockaddr*)(&server_addr), sizeof(server_addr)) == -1)
        perror("FAILED: Bind unsuccessfull");

    if (listen(server_fd, 20) == -1)
        perror("FAILED: Listen unsuccessfull");

    set_non_blocking(server_fd);
    printf("Connector running on %s:%d with %d rooms.\n", ipaddr, base_port, num_rooms);

    struct sockaddr_in room_addr;
    for (int i = 0; i < num_rooms; ++i) {
        int room_fd = socket(PF_INET, SOCK_STREAM, 0);
        room_addr.sin_family = AF_INET;
        room_addr.sin_addr.s_addr = server_addr.sin_addr.s_addr;
        room_addr.sin_port = htons(base_port + 1 + i);

        if (bind(room_fd, (struct sockaddr*)(&room_addr), sizeof(room_addr)) == -1)
            perror("FAILED: Room bind unsuccessful");

        if (listen(room_fd, 2) == -1)
            perror("FAILED: Room listen unsuccessful");

        Room room(room_fd, base_port + 1 + i);
        rooms[room_fd] = room;
        printf("Room %d is ready on port %d.\n", i, base_port + 1 + i);
    }
    return server_fd;
}

int process_room_choice(int player_fd, int room_choice, int bytes_received) {
    int status = FULLROOM;
    if (bytes_received > 0 && !rooms[room_choice].isFull()) {
        if (addPlayerToRoom(room_choice, player_fd)) {
            status = JOIN_SUCCESSFULLY;
            send(player_fd, &status, sizeof(status), 0);
            printf("Player %d joined Room %d\n", player_fd, room_choice);

            int port = rooms[room_choice].getPort();
            send(player_fd, &port, sizeof(port), 0);

            if (rooms[room_choice].isFull()) {
                thread(&Room::startGame, &rooms[room_choice]).detach();
            }
            return 1;
        }
    }
    send(player_fd, &status, sizeof(status), 0);
    return 0;
}
