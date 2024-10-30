#include "const.h"
using namespace std;

int choice = NOTCHOSEN;
struct sockaddr_in broadcast_addr;
 // Signal handler for SIGALRM to set choice to NOTCHOSEN if timeout 
void handle_timeout(int sig) 
{ 
    if (sig == SIGALRM) 
    { 
        choice = NOTCHOSEN;
        printf("\nTime's up! Defaulting choice to NOTCHOSEN.\n");
        fflush(stdout); 
    } 
}

int scanInt()
{
    char buffer[BUFFER_SIZE]; 
    memset(buffer, 0, BUFFER_SIZE); 
    ssize_t bytesRead = read(STDIN_FILENO, buffer, BUFFER_SIZE - 1);
    if (bytesRead <= 0) 
    { 
        return 0;
    }
    int number = 0;
    bool isNegative = false;
    int i = 0; 
    if (buffer[0] == '-') 
    { 
        isNegative = true; i = 1; 
    }

    for (; i < bytesRead && buffer[i] >= '0' && buffer[i] <= '9'; ++i) 
    { 
        number = number * 10 + (buffer[i] - '0'); 
    }

    return isNegative ? -number : number; 
} 

int get_number()
{
    int x = NOTCHOSEN;
    signal(SIGALRM, handle_timeout);

    char buffer[BUFFER_SIZE];
    memset(buffer, 0, BUFFER_SIZE); // Clear the buffer

    // Set up the file descriptor set for select()
    fd_set read_fds;
    FD_ZERO(&read_fds);
    FD_SET(STDIN_FILENO, &read_fds); // Monitor stdin for input

    // Set up the timeout for 10 seconds
    struct timeval timeout;
    timeout.tv_sec = 10;
    timeout.tv_usec = 0;

    // Start the 10-second alarm
    alarm(10);

    // Use select() to wait for input on stdin
    int select_result = select(STDIN_FILENO + 1, &read_fds, NULL, NULL, &timeout);

    if (select_result > 0 && FD_ISSET(STDIN_FILENO, &read_fds)) {
        // Input is available, proceed with reading it
        ssize_t bytesRead = read(STDIN_FILENO, buffer, BUFFER_SIZE - 1);
        if (bytesRead > 0) {
            int number = 0;
            // Convert the input string to an integer
            for (int i = 0; i < bytesRead && buffer[i] >= '0' && buffer[i] <= '9'; ++i) {
                number = number * 10 + (buffer[i] - '0');
            }
            x = number; // Set x to the entered number
        }
    } else {
        // Timeout occurred or no input was detected, x remains NOTCHOSEN
        x = NOTCHOSEN;
    }

    // Cancel the alarm (if it hasn't triggered yet)
    alarm(0);
    fflush(stdin);
    return x;
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

    printString("Connected to server at :");printString(ipaddr);
    printString(" ");printInt(port);printString("\n");

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

int choose_room(int player_fd, char username[MAX_USERNAME_SIZE])
{
    command com;

    int room_choice;
    int connection_status = FULLROOM;
    int room_port;

    while(!connection_status)
    {
        printString("Enter room number to join: ");
        room_choice = scanInt();

        com.command_type = CHOOSE_ROOM;
        com.data = room_choice;  
        strncpy(com.sender, username, MAX_USERNAME_SIZE); 

        send(player_fd, &com, sizeof(com), 0);
        
        read(player_fd, &connection_status, sizeof(connection_status));

        if(connection_status == JOIN_SUCCESSFULLY)
        {
            read(player_fd, &room_port, sizeof(room_port));
            printString("Hello! port of the connected room : ");
            printInt(room_port);
            printString("\n");
        }
    }
    
    printString("You are now in room number: ");
    printInt(room_choice);
    printString("\n");

    return room_port;
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
            printString("Opponent found!\n");
            fflush(stdout);
        }
    }
    while(game_started != GAME_START);
}

int setupBroadcastReceiver() 
{ 
    int opt =1;
    int udp_fd = socket(AF_INET, SOCK_DGRAM, 0);
     
    broadcast_addr.sin_family = AF_INET;
    broadcast_addr.sin_port = htons(BROADCAST_PORT);
    broadcast_addr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (setsockopt(udp_fd, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) == -1)
        perror("FAILED: Making socket reusable failed");
        
    if(setsockopt(udp_fd, SOL_SOCKET, SO_BROADCAST, &opt, sizeof(opt))== -1)
        perror("FAILED: Making socket reusable failed");
    /*if (setsockopt(udp_fd, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)) == -1)
            perror("FAILED: Making socket reusable failed");*/
    
    if (bind(udp_fd, (struct sockaddr*)&broadcast_addr, sizeof(broadcast_addr)) == -1)
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
        int recv_len = recv(udp_fd, buffer, BUFFER_SIZE, 0);

        if (recv_len > 0) 
        { 
            buffer[recv_len] = '\0';
            printf("Broadcast Message: %s\n", buffer); 
        } 
    } 
} 

void receive_broadcast_messages(int udp_fd) 
{ 
    char message[BUFFER_SIZE]; 

     
    int recv_len = recvfrom(udp_fd, &message, BUFFER_SIZE, 0, NULL, NULL);

    if (recv_len > 0) 
    { 
        printString("broadcast message\n");
        printString(message);  
    } 
} 

int main(int argc, char* argv[]) 
{
    if (argc != 3) 
    {
        perror("Invalid Arguments. Usage: ./client.out {IP} {PORT}");
        exit(EXIT_FAILURE);
    }
    int max_sd;
    fd_set master_set, working_set;



    map<int, string> rps;
    rps[ROCK] = "rock";
    rps[PAPER] = "paper";
    rps[SISSORS] = "sissors";
    rps[NOTCHOSEN] = "No choose";
    int udp_fd = setupBroadcastReceiver();
    FD_ZERO(&master_set);
    max_sd = udp_fd;
    FD_SET(udp_fd, &master_set);

    char* ipaddr = argv[1];
    int port = strtol(argv[2], NULL, 10);
    char buffer[BUFFER_SIZE] = {0};
    char username[MAX_USERNAME_SIZE];

    int player_fd = set_up_player(ipaddr, port);
    int player_room_fd;
    
    send_username(player_fd, buffer, BUFFER_SIZE, username);
    recieve_welcome_message(buffer, player_fd, BUFFER_SIZE);
    
    while (1)
    { 
        int room_port = choose_room(player_fd, username);
        player_room_fd = connect_to_room(room_port, ipaddr);

        wait_till_finding_opp(player_room_fd);
        signal(SIGALRM, handle_timeout);

        int message = NOTCHOSEN;
        command player_command = {NOTCHOSEN, NOTCHOSEN}; 
        read(player_room_fd, &message, sizeof(message));
        
        choice = NOTCHOSEN;
        printString("Choose rock 99 paper 100 sissors 101\n");
        choice = get_number();
        player_command.command_type = CHOOSE_RPS;
        player_command.data = choice;
        strncpy(player_command.sender ,username, MAX_USERNAME_SIZE);
        send(player_room_fd, &player_command, sizeof(player_command), 0); 

        printf("choice: %d\n", choice);

        working_set = master_set;
        select(max_sd + 1, &working_set, NULL, NULL, NULL);

        for (int i = 0; i <= max_sd; i++) {
            if (FD_ISSET(i, &working_set)) {
                
                if (i == udp_fd)
                {
                    receive_broadcast_messages(udp_fd);
                } 
            }
        }

    }

    close(player_fd);
    close(player_room_fd);
    return 0;
}
