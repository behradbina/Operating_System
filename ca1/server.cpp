#include "const.h"

using namespace std;
typedef struct pollfd pollfd;
class Room;

map<int, Room> rooms;  // room_fd -> Room
int num_rooms;
int udp_broadcast_socket;
struct sockaddr_in broadcast_addr;

class Room 
{
public:
    Room() : room_fd(-1), port(-1), player_count(0)
    {  
        memset(choices, NOTCHOSEN, sizeof(choices));
    }

    
    Room(int fd, int port) : room_fd(fd), port(port), player_count(0)                             
    {
        memset(choices, NOTCHOSEN, sizeof(choices));
        recieved_messages = 0;

        rps.insert({ROCK, "rock"});
        rps.insert({PAPER, "paper"});
        rps.insert({ROCK, "sissors"});
        rps.insert({NOTCHOSEN, "choosing nothing"});
    }

    int getRoomFd() const { return room_fd; }
    int getPort() const { return port; }
    int getPlayerCount() const { return player_count; }
    int getChoice(int player_index) const { return choices[player_index]; }
    bool isFull() const { return player_count >= ROOM_PLAYER; }
    void restart_room();
    void sendbroadcast_message(string message);
    void update_clients( vector<Client>&cl);
    bool isWinner(int choice1, int choice2);
    bool is_this_player_here(int fd);
    int addPlayer(Client &player, command com);
    void sendToAll(int message)  
    {
        for (int i = 0; i < player_count; ++i) {
            send(rooom_players[i].player_fd_room, &message, sizeof(message), 0);
        }
    }

    int search_player(int player_fd_r)
    {
        for (int i = 0; i < player_count; i++)
        {
            if (player_fd_r == rooom_players[i].player_fd_room)
            {
                return i;
            }
        }
        
        printString("sth is wrong in search player\n");
        return -1;
    }
     
    string judge(int choice0, int choice1);
    void continue_game(command com, int player_fd_r, vector<Client>&cl);


private:
    int room_fd;
    int port;
    
    int player_count;
    
    int choices[ROOM_PLAYER];
   
    int recieved_messages;
    map<int, string> rps;
    
    vector<Client> rooom_players;
};

bool Room::isWinner(int choice1, int choice2)
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

void Room::update_clients( vector<Client>&cl)
{
    for (int i = 0; i < ROOM_PLAYER; i++)
    {
        for (size_t i = 0; i <cl.size(); i++)
        {
            if (rooom_players[i].player_fd_server == cl[i].player_fd_server)
            {
                cl[i].scores += rooom_players[i].scores;
            }
               
        }
    }
    
    
}

void Room::continue_game(command com, int player_fd_r, vector<Client>&cl) 
{
    if (com.command_type == CHOOSE_RPS)
    {
        int player_index = search_player(player_fd_r);
        choices[player_index] = com.data;
        string temp (com.sender); 
        rooom_players[player_index].username = temp;
        recieved_messages ++;
    }
       
    if(recieved_messages == ROOM_PLAYER)
    {   
        string message = judge(choices[0], choices[1]);
        sendbroadcast_message(message);
        recieved_messages = 0;
        update_clients(cl);
        restart_room();
    }
}

int Room::addPlayer(Client &player, command com) 
{

    struct sockaddr_in new_addr;
    socklen_t new_size = sizeof(new_addr);
    int new_fd = accept(room_fd, (struct sockaddr*)(&new_addr), &new_size);
    set_non_blocking(new_fd);

    player.player_fd_room = new_fd;
    player.room_number = room_fd;

    if (player_count < ROOM_PLAYER) 
    {
    
        rooom_players.push_back(player);
        player_count++;
    }

    if(player_count == ROOM_PLAYER)
    {
        sendToAll(GAME_START);
        sendToAll(NOTCHOSEN);
        vector<Client>v;
        continue_game(com, -1, v);
    }
    
    return new_fd;
}

string Room::judge(int choice0, int choice1)
{
    string message;

    if (choice0 == choice1) 
    {
        message = rooom_players[0].username + " and " + rooom_players[1].username +
        " choose :" + rps[choice0] + "\n"; 
    } 
    else if (isWinner(choices[0], choices[1]))
    {
        message = rooom_players[0].username + " win by choosing " + rps[choice0] + " against " + rooom_players[1].username + "\n";
        rooom_players[0].scores ++;
        
    } 
    else {

        message = rooom_players[1].username + " win by choosing " + rps[choice1] + " against " + rooom_players[0].username + "\n";
        rooom_players[1].scores ++;     
    }

    return message;

}

void Room::restart_room()
{
    rooom_players.clear();
    recieved_messages = 0;
    player_count = 0;
}

void Room::sendbroadcast_message(string message)
{

     sendto(udp_broadcast_socket, message.c_str(), message.size(), 0,
      (struct sockaddr *)&broadcast_addr ,  sizeof(broadcast_addr)); 
}

bool Room::is_this_player_here(int fd)
{
    for (int i = 0; i < player_count; i++)
    {
        if (fd == rooom_players[i].player_fd_room)
        {
            return true;
        }
        
    }
    return false;
}


void printString(const char* str) 
{
     // Define a buffer size
    char buffer[BUFFER_SIZE]; // Clear the buffer using memset
    memset(buffer, 0, BUFFER_SIZE); // Copy the input string to the buffer
    size_t len = strlen(str);
    if (len >= BUFFER_SIZE) {
        len = BUFFER_SIZE - 1; // Truncate if the input is too long
    }
    strncpy(buffer, str, len); // Write the buffer to standard output
    write(STDOUT_FILENO, buffer, len);
}

void printInt(int number) 
{
    
    char buffer[BUFFER_SIZE]; // Clear the buffer using memset
    memset(buffer, 0, BUFFER_SIZE); // Handle negative numbers
    bool isNegative = (number < 0);
    if (isNegative) {
        number = -number; // Convert to positive for easier processing
    }

    // Convert integer to string by filling the buffer from the end
    int index = BUFFER_SIZE - 2; // Start at second-to-last position
    do {
        buffer[index--] = (number % 10) + '0'; // Get the last digit and convert to char
        number /= 10;
    } while (number > 0);

    // Add the negative sign if needed
    if (isNegative) {
        buffer[index--] = '-';
    }

    // Write the buffer to standard output, starting from the first non-empty position
    write(STDOUT_FILENO, &buffer[index + 1], BUFFER_SIZE - index - 2);
}



int search_player_in_room(int fd)
{
    for (auto myPair : rooms ) 
    {
        if (myPair.second.is_this_player_here(fd))
        {
            return myPair.second.getRoomFd();
        }
    }
    //printf("sth is wrong in search_player_in_room\n");
    return -1;
}

int setup_broadcast_socket() 
{ 
    
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

void sendbroadcast_message(string message)
{

     sendto(udp_broadcast_socket, message.c_str(), message.size(), 0,
      (struct sockaddr *)&broadcast_addr ,  sizeof(broadcast_addr)); 
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

    printString("Connector running on ");printString(ipaddr);printString(" :");
    printInt( base_port);printString("No of rooms:"); printInt(num_rooms);printString("\n");
    // printf("Connector running on %s:%d with %d rooms.\n", ipaddr, base_port, num_rooms);
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

        //printf("Room %d is ready on port %d.\n", i, base_port + 1 + i);
        printString("Room ");printInt(i);printString("is ready on port ");
        printInt(base_port + 1 + i);printString("\n");
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
    for (size_t i = 0; i < ve.size(); i++)
    {
        if(ve[i].fd == sock)
            return i;
    }
    
    return -1; 
}

int search_client_room(vector<Client>&ve, int player_sock)
{
    for (size_t i = 0; i < ve.size(); i++)
    {
        if(ve[i].player_fd_server == player_sock)
            return i;
    }
    
    return -1; 
}

int search_client(vector<Client>&ve, int sock)
{
    for (size_t i = 0; i < ve.size(); i++)
    {
        if(ve[i].player_fd_server == sock)
            return i;
    }
    
    return -1; 
}

int search_client_room_fd(vector<Client>&ve, int sock)
{
    for (size_t i = 0; i < ve.size(); i++)
    {
        if(ve[i].player_fd_room == sock)
            return i;
    }
    
    return -1; 
}

void process_room_choice(int player_fd, int room_choice, int bytes_received, vector<Client>&clients) 
{
    int status = JOIN_SUCCESSFULLY;

    if (rooms.count(room_choice) == 0)
    {
        status = FULLROOM;
        send(player_fd, &status, sizeof(status), 0);
        return;
    }
    if (rooms[room_choice].getPlayerCount() >= 2)
    {
        status = FULLROOM;
        send(player_fd, &status, sizeof(status), 0);
        return;
    }

    send(player_fd, &status, sizeof(status), 0);
    
    int port = rooms[room_choice].getPort();
    send(player_fd, &port, sizeof(port), 0);

    int player_index = search_client(clients, player_fd);
    clients[player_index].room_number = room_choice;
    
}

string inform_final_result(vector<Client>&ve)
{
    string final_result = "\nFinal result:\n";
    for (size_t i = 0; i < ve.size(); i++)
    {
        final_result += "Name " + ve[i].username + " score : " + to_string(ve[i].scores) + "\n";
    }
    
    return final_result;
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
    //char username[MAX_USERNAME_SIZE];
    vector<pollfd> pfds;
    vector<pollfd> room_socket;
    vector<Client> clients;
    map <int , Client> client_rooms; // room--> client 

    int server_fd = set_up_connector(ipaddr,base_port,num_rooms,pfds, room_socket);
    udp_broadcast_socket = setup_broadcast_socket();
    pfds.push_back(pollfd{server_fd, POLLIN, 0});
    pfds.push_back(pollfd{STDIN_FILENO, POLLIN, 0});

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

                else if (search_socket(room_socket, pfds[i].fd) != -1)
                {
                   
                    if (!rooms[pfds[i].fd].isFull())
                    {
                        command comm = {NOTCHOSEN, NOTCHOSEN};
                        int player_index = search_client_room(clients, pfds[i].fd);
                        int new_fd = rooms[pfds[i].fd].addPlayer(clients[player_index], comm); 
                        pfds.push_back(pollfd{new_fd, POLLIN, 0});
                    }
                    
                }
                
                else if (pfds[i].fd == STDIN_FILENO) // Check for end_game command 
                { 
                    char buffer[BUFFER_SIZE];
                    fgets(buffer, BUFFER_SIZE, stdin);

                    if (strncmp(buffer, "end_game", 8) == 0) 
                    {
                        string message = inform_final_result(clients);
                        sendbroadcast_message(message);
                        break;
                    }
                         
                }
                else // message from user
                {
                    command com = {NOTCHOSEN, NOTCHOSEN};
                    
                    int bytes_recieved = recv(pfds[i].fd, &com, sizeof(com), 0);
                    
                    int command_type = com.command_type;
                    int command_data = com.data;
                    char sender[MAX_USERNAME_SIZE];
                    strncpy(sender, com.sender, MAX_USERNAME_SIZE);
                    

                    if (command_type == CHOOSE_NAME)
                    {                    
                        clients.push_back({pfds[i].fd, NOTCHOSEN, 0, NOTCHOSEN,string(sender)});
                    }
                    
                    if (command_type == CHOOSE_ROOM)
                    {
                        process_room_choice(pfds[i].fd, command_data, bytes_recieved, clients);
                        //strncpy(username, sender, MAX_USERNAME_SIZE);    
                    }

                    if (command_type == CHOOSE_RPS)
                    {
                        int room_fd = search_player_in_room(pfds[i].fd);
                        rooms[room_fd].continue_game(com, pfds[i].fd, clients);
                    }
                    
                }
            }
        }
    }

    close(server_fd);
    return 0;
}
