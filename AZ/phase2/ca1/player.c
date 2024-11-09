// player.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define TRUE 1
#define FALSE 0
#define JOIN_SUCCESSFULLY 1
#define FULLROOM 0 
#define BUFFER_SIZE 1024


int setup_player()
{
    int sock = 0;
    struct sockaddr_in serv_addr;
    
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) 
    {
        printf("Socket creation error\n");
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    
    
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) 
    {
        printf("Invalid address/ Address not supported\n");
        return -1;
    }
    
    if (connect(sock, (struct sockaddr*)&serv_addr,
     sizeof(serv_addr)) < 0) {
        printf("Connection Failed\n");
        return -1;
    }

    return sock;
}

void recieve_welcome_message(char buffer[], int sock, int buff_size)
{
    read(sock, buffer, buff_size);
    printf("%s", buffer);
}

int choose_room(int sock)
{
    int room_choice;
    int connection_status = FULLROOM;

    do
    {
        printf("Enter room number to join: ");
        scanf("%d", &room_choice);
        send(sock, &room_choice, sizeof(room_choice), 0);

        read(sock, &connection_status, sizeof(connection_status));
        
        if(connection_status == JOIN_SUCCESSFULLY)
            printf("Hello!");
        

    }
    while(! connection_status);
    
    printf("You are now in room number:%d!\n", room_choice);

    return room_choice;
}

int main() {
    
    
    char buffer[1024] = {0};
    int sock = setup_player(); 

    if(sock < 0)
        return -1;

    recieve_welcome_message(buffer, sock, BUFFER_SIZE);
    
    int room_number = choose_room(sock);
    //wait to find opp
    //start playing
    //send final score to connector
    
    while(1);


    close(sock);
    return 0;
}
