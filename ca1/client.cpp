#include "const.h"
using namespace std;

int set_up_player(char * ipaddr, int port)
{
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
    return server_fd;

}

void recieve_welcome_message(char buffer[], int sock, int buff_size)
{
    read(sock, buffer, buff_size);
    printf("%s", buffer);
}

void send_username(int player_fd, char buffer[], int buf_size, char username[]) {
    char s[BUFFER_SIZE] = "enter your name\n";
    command com = {CHOOSE_NAME, NOTCHOSEN};
    memset(buffer, 0, buf_size);
    write(1, s, strlen(s));
    read(0, buffer, buf_size);
    buffer[strcspn(buffer, "\n")] = 0;
    strncpy(com.sender, buffer, MAX_USERNAME_SIZE-1);
    com.sender[MAX_USERNAME_SIZE-1] = '\0';
    send(player_fd, &com, sizeof(com), 0);

    strncpy(username, com.sender, MAX_USERNAME_SIZE); // Copy com.sender to username
}

int choose_room(int player_fd)
{
    command com;

    int room_choice;
    int connection_status = FULLROOM;
    int room_port;

    while(!connection_status)
    {
        printf("Enter room number to join: ");
        scanf("%d", &room_choice);

        com.command_type = CHOOSE_ROOM;
        com.data = room_choice;  


        send(player_fd, &com, sizeof(com), 0);

        read(player_fd, &connection_status, sizeof(connection_status));
        
        if(connection_status == JOIN_SUCCESSFULLY)
        {
            read(player_fd, &room_port, sizeof(room_port));
            printf("Hello! port of the connected room : %d\n", room_port);
        }
    }
    
    printf("You are now in room number:%d!\n", room_choice);


    return room_port;
}

void disconnect_from_main_server(int player_fd)
{
    close(player_fd);
}

int connect_to_room(int room_port, char* ipaddr)
{
    int player_fd = set_up_player(ipaddr, room_port);
    return player_fd;
}

void wait_till_finding_opp(int sock)
{
    int game_started = 0;    
    do
    {
        game_started = 0;
        read(sock, &game_started, sizeof(game_started));
        
        if(game_started == GAME_START)
        {
            printf("Opponent found!\n");
            fflush(stdout);
        }
    }
    while(game_started != GAME_START);
}

void print_result_of_round(int result)
{
    if (result == WINNER)
    {
        printf("You won\n");
    }
    else if (result == LOSER)
    {
        printf("You lose\n");
    }
    else{
        printf("Equal\n");
    }
}

int setupBroadcastReceiver() 
{ 
    int opt =1;
    int udp_fd = socket(AF_INET, SOCK_DGRAM, 0);
    struct sockaddr_in addr; 
    addr.sin_family = AF_INET;
    addr.sin_port = htons(BROADCAST_PORT);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (setsockopt(udp_fd, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) == -1)
        perror("FAILED: Making socket reusable failed");
    if(setsockopt(udp_fd, SOL_SOCKET, SO_BROADCAST, &opt, sizeof(opt))== -1)
        perror("FAILED: Making socket reusable failed");
    /*if (setsockopt(udp_fd, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) == -1)
            perror("FAILED: Making socket reusable failed");*/
    
    if (bind(udp_fd, (struct sockaddr*)&addr, sizeof(addr)) == -1)
    {
        perror("failed to bind UDP receiver socket\n");
        close(udp_fd);
        exit(EXIT_FAILURE);
    }
    
    
    return udp_fd;
}

void receiveBroadcastMessages(int udp_fd) 
{ 
    char buffer[BUFFER_SIZE]; 

    while (1) 
    { 
        int recv_len = recvfrom(udp_fd, buffer, BUFFER_SIZE, 
                                0, NULL, NULL);

        if (recv_len > 0) 
        { 
            buffer[recv_len] = '\0';
            printf("Broadcast Message: %s\n", buffer); 
        } 
    } 
} 

int receive_broadcast_messages(int udp_fd) 
{ 
    int message; 

     
    int recv_len = recvfrom(udp_fd, &message, sizeof(message), 0, NULL, NULL);

    if (recv_len > 0) 
    { 
        printf("message is recieved!\n");
        return message;
    } 

    return NOTCHOSEN;
} 

int main(int argc, char* argv[]) 
{
    if (argc != 3) 
    {
        perror("Invalid Arguments. Usage: ./client.out {IP} {PORT}");
        exit(EXIT_FAILURE);
    }

    char* ipaddr = argv[1];
    int port = strtol(argv[2], NULL, 10);
    char buffer[BUFFER_SIZE] = {0};
    char username[MAX_USERNAME_SIZE];

    int player_fd = set_up_player(ipaddr, port);

    send_username(player_fd, buffer, BUFFER_SIZE, username);

    printf("'%s'\n", username);
 
    recieve_welcome_message(buffer, player_fd, BUFFER_SIZE);

    int room_port = choose_room(player_fd);
    disconnect_from_main_server(player_fd);
    player_fd = connect_to_room(room_port, ipaddr);

    wait_till_finding_opp(player_fd);

    int udp_fd = setupBroadcastReceiver();

    printf("udp_fd: %d\n", udp_fd);
    //int m = receive_broadcast_messages(udp_fd);
    //printf("m: %d\n", m);

    while (1) 
    {
        int message = NOTCHOSEN;
        command player_command = {NOTCHOSEN, NOTCHOSEN}; 
        int choice;
        read(player_fd, &message, sizeof(message));



        if(message == CHOOSE_RPS)
        {
            choice = NOTCHOSEN;
            printf("Choose rock 99 paper 100 sissors 101\n");
            scanf("%d", &choice);
            player_command.command_type = CHOOSE_RPS;
            player_command.data = choice;
            strncpy(player_command.sender ,username, MAX_USERNAME_SIZE);
            send(player_fd, &player_command, sizeof(player_command), 0);
        }

        /*if(message == INFORM_RESULT)
        {
            recv(player_fd, &result, sizeof(result), 0);
            print_result_of_round(result);
        }*/
        
    }

    close(player_fd);
    return 0;
}
