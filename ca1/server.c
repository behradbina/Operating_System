#include "const.h"

using namespace std;
typedef struct pollfd pollfd;
mutex room_mutex;

class Room;

map<int, Room> rooms;  // room_fd -> Room
int num_rooms;

class Room 
{
public:
    Room() : room_fd(-1), port(-1), player_count(0) 
    {  
        memset(player_fds, -1, sizeof(player_fds));
        memset(choices, NOTCHOSEN, sizeof(choices));
    }

    
    Room(int fd, int port) : room_fd(fd), port(port), player_count(0) 
    {
        memset(player_fds, -1, sizeof(player_fds));
        memset(choices, NOTCHOSEN, sizeof(choices));
    }

    int getRoomFd() const { return room_fd; }
    int getPort() const { return port; }
    int getPlayerCount() const { return player_count; }
    int getPlayerFd(int player_index) const { return player_fds[player_index]; }
    int getChoice(int player_index) const { return choices[player_index]; }
    bool isFull() const { return player_count >= ROOM_PLAYER; }

    bool isWinner(int choice1, int choice2)
    {
        if((choice1 == ROCK && choice2 == SISSORS) ||
            (choice1 == SISSORS && choice2 == PAPER) ||
            (choice1 == PAPER && choice2 == ROCK))
            return true;

        return false;
    }


    bool addPlayer(int player_fd) 
    {
        if (player_count < ROOM_PLAYER) {
            player_fds[player_count++] = player_fd;
            return true;
        }
        return false;
    }

    void setChoice(int player_index, int choice) 
    {
        if (player_index < ROOM_PLAYER) {
            choices[player_index] = choice;
        }
    }

    void sendToAll(const char* message) const 
    {
        for (int i = 0; i < player_count; ++i) {
            send(player_fds[i], message, strlen(message), 0);
        }
    }

    void startGame();

    void accept_players();
    

private:
    int room_fd;
    int port;
    int player_count;
    int player_fds[ROOM_PLAYER];
    int choices[ROOM_PLAYER];
};

void Room::startGame() 
{
    const char* start_msg = "Game started! Choose rock, paper, or scissors:\n";
    sendToAll(start_msg);

    int scores[ROOM_PLAYER] = {0, 0}; // Initialize scores for both players
    bool game_end = false;

    while (!game_end) 
    {
        memset(choices, NOTCHOSEN, sizeof(choices)); // Reset choices

        struct pollfd pfds[ROOM_PLAYER];

        for (int i = 0; i < player_count; ++i) 
        {
            pfds[i].fd = player_fds[i];
            pfds[i].events = POLLIN;
        }

        sendToAll("Choose rock (0), paper (1), or scissors (2):\n");

        int result = poll(pfds, player_count, 10000); // 10-second timeout
        
        if (result <= 0) 
        {
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

        // Determine round result
        int result_msg;
        if (choices[0] == choices[1]) 
        {
            result_msg = EQUAL;
            send(player_fds[0], &result_msg, sizeof(result_msg), 0);
            send(player_fds[1], &result_msg, sizeof(result_msg), 0);
        } 
        else if (isWinner(choices[0], choices[1]))
        {
            result_msg = WINNER;
            send(player_fds[0], &result_msg, sizeof(result_msg), 0);
            result_msg = LOSER;
            send(player_fds[1], &result_msg, sizeof(result_msg), 0);
            scores[0]++;
        } 
        else {
            result_msg = LOSER;
            send(player_fds[0], &result_msg, sizeof(result_msg), 0);
            result_msg = WINNER;
            send(player_fds[1], &result_msg, sizeof(result_msg), 0);
            scores[1]++;
        }
    }
}

void Room::accept_players()
{
    struct sockaddr_in new_addr;
    socklen_t new_size = sizeof(new_addr);
    int new_fd = accept(room_fd, (struct sockaddr*)(&new_addr), &new_size);
    set_non_blocking(new_fd);
    write(1, &new_fd, sizeof(new_fd));
}

bool addPlayerToRoom(int room_fd, int player_fd) 
{
    lock_guard<mutex> lock(room_mutex);
    Room& room = rooms[room_fd];
    return room.addPlayer(player_fd);
}

void set_non_blocking(int sock) 
{
    int flags = fcntl(sock, F_GETFL, 0);
    if (flags == -1) {
        perror("fcntl F_GETFL failed");
        exit(EXIT_FAILURE);
    }
    if (fcntl(sock, F_SETFL, flags | O_NONBLOCK) == -1) {
        perror("fcntl F_SETFL failed");
        exit(EXIT_FAILURE);
    }
}

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
    fflush(stdout);

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

        ;
        rooms.emplace(room_fd, Room (room_fd, base_port + 1 + i));
        printf("Room %d is ready on port %d.\n", i, base_port + 1 + i);
        
        fflush(stdout);
    }
    return server_fd;
}

int accept_client(int server_fd, vector<pollfd>& pfds)
{
    struct sockaddr_in new_addr;
    socklen_t new_size = sizeof(new_addr);
    int new_fd = accept(server_fd, (struct sockaddr*)(&new_addr), &new_size);
    set_non_blocking(new_fd);
    write(1, &new_fd, sizeof(new_fd));
    pfds.push_back(pollfd{new_fd, POLLIN, 0});
    return new_fd;
}

void send_available_rooms(int server_fd, int new_fd)
{
    char room_list[BUFFER_SIZE] = "Available rooms:\n";
    for (const auto& [room_fd, room] : rooms) {
        if (room.getPlayerCount() < ROOM_PLAYER) {
            char temp[50];
            sprintf(temp, "Room fd %d \n", room_fd);
            strcat(room_list, temp);
        }
    }
    send(new_fd, room_list, strlen(room_list), 0);
}

int search_socket(vector<pollfd>&ve, int sock)
{
    for (int i = 0; i < ve.size(); i++)
    {
        if(ve[i].fd == sock)
            return i;
    }
    
    return -1; 
}

int process_room_choice(int player_fd, int room_choice, int bytes_received, vector<pollfd>&ve) {
    int status = FULLROOM;
    if (bytes_received > 0 && !rooms[room_choice].isFull()) {
        if (addPlayerToRoom(room_choice, player_fd)) {
            status = JOIN_SUCCESSFULLY;
            send(player_fd, &status, sizeof(status), 0);
            
            printf("0\n");
            fflush(stdout);

            printf("Player fd: %d\n", player_fd); // Separate print
            printf("Room choice: %d\n", room_choice); // Separate print
            fflush(stdout);

            printf("Player %d joined Room %d\n", player_fd, room_choice);
            fflush(stdout);

            printf("1\n");
            fflush(stdout);

            int port = rooms[room_choice].getPort();
            send(player_fd, &port, sizeof(port), 0);//send room port to player

            printf("2\n");
            fflush(stdout);

            int index = search_socket(ve , player_fd);
            ve.erase(ve.begin() + index);

            if (rooms[room_choice].isFull()) 
            {
                printf("room is full\n");
                fflush(stdout);
                thread(&Room::startGame, &rooms[room_choice]).detach();
            }
            return 1;
        }
    }

    send(player_fd, &status, sizeof(status), 0);
    return 0;
}

int main(int argc, char* argv[]) 
{
    if (argc != 4) 
    {
        perror("Invalid Arguments. Usage: ./server.out {IP} {PORT} {#Rooms}");
        exit(EXIT_FAILURE);
    }

    char* ipaddr = argv[1];
    int base_port = strtol(argv[2], NULL, 10);
    num_rooms = strtol(argv[3], NULL, 10);

    int server_fd = set_up_connector(ipaddr,base_port,num_rooms);

    vector<pollfd> pfds;
    pfds.push_back(pollfd{server_fd, POLLIN, 0});

    while (1) 
    {
        if (poll(pfds.data(), pfds.size(), -1) == -1) {
            perror("Poll failed");
            continue;
        }
        
        for (size_t i = 0; i < pfds.size(); ++i) 
        {
            if (pfds[i].revents & POLLIN) 
            {
                if(pfds[i].fd == server_fd) // new user
                {
                    int new_fd = accept_client(server_fd, pfds);
                    send_available_rooms(server_fd, new_fd);
                    pfds.push_back(pollfd{new_fd, POLLIN, 0});
                }

                else // message from user
                {
                    command com = {NOTCHOSEN, NOTCHOSEN};
                    int bytes_recieved = recv(pfds[i].fd, &com, sizeof(com), 0);
                    int command_type = com.command_type;
                    int command_data = com.data;

                    if (command_type == CHOOSE_ROOM && 
                        rooms[command_data].getPlayerCount() < 2)
                    {
                        process_room_choice(pfds[i].fd, command_data, bytes_recieved, pfds);
                        printf("after proccess_room_choice\n");
                        fflush(stdout);
                    }
                }
            }
        }
    }

    close(server_fd);
    return 0;
}
