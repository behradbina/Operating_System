#include "const.h"

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

int choose_room(int sock)
{
    command com;

    int room_choice;
    int connection_status = FULLROOM;
    int room_port;

    do
    {
        printf("Enter room number to join: ");
        scanf("%d", &room_choice);

        com.command_type = CHOOSE_ROOM;
        com.data = room_choice;  


        send(sock, &com, sizeof(com), 0);

        read(sock, &connection_status, sizeof(connection_status));
        
        if(connection_status == JOIN_SUCCESSFULLY)
        {
            read(sock, &room_port, sizeof(room_port));
            printf("Hello!");
        }
        

    }
    while(! connection_status);
    
    printf("You are now in room number:%d!\n", room_choice);


    return room_port;
}

void wait_till_finding_opp(int sock)
{

    int game_started = 0;    

    do
    {
        game_started = 0;
        read(sock, &game_started, sizeof(game_started));
        
        if(game_started == GAME_START)
            printf("Opponent found!\n");
    }
    while(game_started != GAME_START);
    
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

    int player_fd = set_up_player(ipaddr, port);

    recieve_welcome_message(buffer, player_fd, BUFFER_SIZE);
    choose_room(player_fd);

    printf("infinite loop");

    while (1) 
    {
        memset(buffer, 0, BUFFER_SIZE);

        // Receive data from the server
        int recv_len = recv(player_fd, buffer, BUFFER_SIZE, 0);
        if (recv_len > 0) 
        {
            printf("Server: %s\n", buffer);
        }

        // Input player choice and send it to the server
        printf("Enter your choice (rock, paper, or scissors): ");
        fgets(buffer, BUFFER_SIZE, stdin);
        send(player_fd, buffer, strlen(buffer), 0);
    }

    close(player_fd);
    return 0;
}

