#include "const.h"

using namespace std;
typedef struct pollfd pollfd;
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
        game_end = false;
        scores[ROOM_PLAYER] = {0};
        send_choose_rps = false;
        send_inform_message = false;
        recieved_messages = 0;
        //setup_broadcast_socket(); 
    }

    int getRoomFd() const { return room_fd; }
    int getPort() const { return port; }
    int getPlayerCount() const { return player_count; }
    int getPlayerFd(int player_index) const { return player_fds[player_index]; }
    int getChoice(int player_index) const { return choices[player_index]; }
    bool isFull() const { return player_count >= ROOM_PLAYER; }

    bool isWinner(int choice1, int choice2)
    {

        if (choice1 == NOTCHOSEN && choice2 != NOTCHOSEN)
        {
            return false;
        }
        if (choice1 != NOTCHOSEN && choice2 == NOTCHOSEN)
        {
            return true;
        }

        if((choice1 == ROCK && choice2 == SISSORS) ||
            (choice1 == SISSORS && choice2 == PAPER) ||
            (choice1 == PAPER && choice2 == ROCK))
            return true;

        return false;
    }

    void addPlayer(string username) 
    {
        printf("In addPlayer \n");
        fflush(stdout);
        struct sockaddr_in new_addr;
        socklen_t new_size = sizeof(new_addr);
        int new_fd = accept(room_fd, (struct sockaddr*)(&new_addr), &new_size);
        set_non_blocking(new_fd);
        
        if (player_count < ROOM_PLAYER) {
            player_fds[player_count] = new_fd;
            usernames.push_back(username);
            player_count++;
        }

        if(player_count ==ROOM_PLAYER)
        {
            sendToAll(GAME_START);
            continue_game();
        }
    }

    void setChoice(int player_index, int choice) 
    {
        if (player_index < ROOM_PLAYER) {
            choices[player_index] = choice;
        }
    }

    void sendToAll(int message)  
    {
        for (int i = 0; i < player_count; ++i) {
            send(player_fds[i], &message, sizeof(message), 0);
        }
    }
    
    int search_player(string username)
    {
        for (size_t i = 0; i < usernames.size(); i++)
        {
            if (username == usernames[i])
            {
                return i;
            }
            
        }
        
        printf("sth is wrong in search player\n");
        return -1;
    }
    //void setup_broadcast_socket();

    //void sendbroadcast_message(string message);
    void recieve_player_choices();
    void judge(int choice0, int choice1);
    void continue_game();


private:
    int room_fd;
    int port;
    
    int player_count;
    int player_fds[ROOM_PLAYER];
    int choices[ROOM_PLAYER];
    int scores[ROOM_PLAYER];
    int recieved_messages;

    vector<string> usernames;
    bool game_end;
    bool send_choose_rps;
    bool send_inform_message;

};

void Room::continue_game() 
{
    printf("here!");

    if(!send_choose_rps)
    {
        int message = CHOOSE_RPS;
        sendToAll(message);
        send_choose_rps = true;
    }
    else if(send_choose_rps)
    {
        printf("here2!");
        command com;
        recv(room_fd, &com, sizeof(com), 0);

        if (com.command_type == CHOOSE_RPS)
        {
            printf("here3!");
            int player_index = search_player(string(com.sender));
            choices[player_index] = com.data;
            recieved_messages ++;
        }
        
    }

    if(recieved_messages == ROOM_PLAYER)
    {   printf("here4!"); 
        judge(choices[0], choices[1]);
        recieved_messages = 0;
        send_choose_rps = false;
    }
}

void Room::judge(int choice0, int choice1)
{
    int result_msg;
        if (choice0 == choice1) 
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

void Room::recieve_player_choices()
{

}

int setup_broadcast_socket() 
{ 
    struct sockaddr_in broadcast_addr;
    int udp_broadcast_socket;
    int broadcast = 1;
    udp_broadcast_socket = socket(AF_INET, SOCK_DGRAM, 0); 
    if (udp_broadcast_socket == -1)
    {
        perror("Failed to create UDP broadcast socket");
        exit(EXIT_FAILURE); 
    } // Enable broadcasting
    if (setsockopt(udp_broadcast_socket, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(broadcast)) == -1)
    {
        perror("Failed to set broadcast option");
        close(udp_broadcast_socket); exit(EXIT_FAILURE); 
    } // Bind to any address on the broadcast port 

    if (setsockopt(udp_broadcast_socket, SOL_SOCKET, SO_REUSEPORT, &broadcast, sizeof(broadcast)) == -1)
        perror("FAILED: Making socket reusable failed");
    /*if (setsockopt(udp_broadcast_socket, SOL_SOCKET, SO_REUSEADDR, &broadcast, sizeof(broadcast)) == -1)
        perror("FAILED: Making socket reusable failed");*/
        
    struct sockaddr_in addr; addr.sin_family = AF_INET;
    addr.sin_port = htons(BROADCAST_PORT);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(udp_broadcast_socket, (struct sockaddr *)&addr, sizeof(addr)) == -1)
    { 
        perror("Failed to bind UDP socket to INADDR_ANY"); 
        close(udp_broadcast_socket); exit(EXIT_FAILURE); 
    } // Configure broadcast address 
    memset(&broadcast_addr, 0, sizeof(broadcast_addr)); 
    broadcast_addr.sin_family = AF_INET;
    broadcast_addr.sin_port = htons(BROADCAST_PORT);
    broadcast_addr.sin_addr.s_addr = inet_addr("127.255.255.255"); 

    return udp_broadcast_socket;
// Local network broadcast 
} 

/*void Room::sendbroadcast_message(string message)
{
     sendto(udp_broadcast_socket, message.c_str(), message.size(), 0,
      (struct sockaddr*)&broadcast_addr, sizeof(broadcast_addr)); 
}*/

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

int set_up_connector(char *ipaddr, int base_port, int num_rooms, vector<pollfd>& pfds, vector<pollfd>& room_socket) 
{
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

    for (int i = 0; i < num_rooms; ++i) 
    {
        int room_fd = socket(PF_INET, SOCK_STREAM, 0);

        room_addr.sin_family = AF_INET;
        room_addr.sin_addr.s_addr = server_addr.sin_addr.s_addr;
        room_addr.sin_port = htons(base_port + 1 + i);

        if (setsockopt(room_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1)
            perror("FAILED: Making socket reusable failed");

        if (bind(room_fd, (struct sockaddr*)(&room_addr), sizeof(room_addr)) == -1)
            perror("FAILED: Room bind unsuccessful");

        if (listen(room_fd, 2) == -1)
            perror("FAILED: Room listen unsuccessful");

        
        set_non_blocking(room_fd);
        rooms.emplace(room_fd, Room (room_fd, base_port + 1 + i));

        pfds.push_back({room_fd, POLLIN, 0});
        room_socket.push_back({room_fd, POLLIN, 0});

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

void process_room_choice(int player_fd, int room_choice, int bytes_received, vector<pollfd>&ve) 
{
    int status = JOIN_SUCCESSFULLY;
    send(player_fd, &status, sizeof(status), 0);
    
    int port = rooms[room_choice].getPort();
    send(player_fd, &port, sizeof(port), 0);//send room port to player

    int index = search_socket(ve , player_fd);
    ve.erase(ve.begin() + index);
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

    vector<pollfd> pfds;
    vector<pollfd> room_socket;

    map <int , string> cliets;

    int server_fd = set_up_connector(ipaddr,base_port,num_rooms,pfds, room_socket);
    setup_broadcast_socket();
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
                    //recv(new_fd, username, strlen(username), 0);
                    send_available_rooms(server_fd, new_fd);
                    pfds.push_back(pollfd{new_fd, POLLIN, 0});
                }

                else if (search_socket(room_socket, pfds[i].fd) != -1)
                {
                    printf("in the else if\n");
                    if (rooms[pfds[i].fd].isFull())
                    {
                        rooms[pfds[i].fd].continue_game();    
                    }
                    else
                        rooms[pfds[i].fd].addPlayer(cliets[pfds[i].fd]); 
                }
                
                else // message from user
                {
                    command com = {NOTCHOSEN, NOTCHOSEN,  ""};
                    int bytes_recieved = recv(pfds[i].fd, &com, sizeof(com), 0);
                    int command_type = com.command_type;
                    int command_data = com.data;
                    string sender = com.sender;

                    if (command_type == CHOOSE_NAME)
                    {
                        cliets.insert({pfds[i].fd, sender});
                    }
                    
                    if (command_type == CHOOSE_ROOM && 
                        rooms[command_data].getPlayerCount() < 2)
                    {
                        process_room_choice(pfds[i].fd, command_data, bytes_recieved, pfds);
                        printf("after proccess_room_choice\n");
                        fflush(stdout);
                    }
                    else if (rooms[command_data].getPlayerCount() == 2)
                    {
                        int status = FULLROOM; 
                        send(pfds[i].fd, &status, sizeof(status), 0);
                    }
                }
            }
        }
    }

    close(server_fd);
    return 0;
}

