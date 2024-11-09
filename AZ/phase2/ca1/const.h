#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <poll.h>
#include <unistd.h>
#include <map>
#include <iterator>
#include <thread>
#include <mutex>
#include <fcntl.h>
#include <string>
#include <cstring>
#include <iostream>
#include <csignal>
#include <unistd.h>

#define PORT              8080
#define MAX_ROOMS         5
#define MAX_PLAYERS       10
#define JOIN_SUCCESSFULLY 1
#define FULLROOM          0
#define BUFFER_SIZE       1024
#define GAME_START        1000
#define ROOM_PLAYER       2
#define ROCK              99
#define PAPER             100
#define SISSORS           101
#define NOTCHOSEN         -1
#define CHOOSE_ROOM       500
#define CHOOSE_NAME       501
#define UPDATE_NAME       502
#define WINNER            1
#define LOSER             -1
#define EQUAL             0
#define CHOOSE_RPS        199
#define INFORM_RESULT     1010
#define MAX_USERNAME_SIZE 20
#define BROADCAST_PORT    1024

struct command
{
    int command_type;
    int data;
    char sender[MAX_USERNAME_SIZE];
};

struct Client
{
    int player_fd_server;
    int player_fd_room;
    int scores;
    int room_number;
    std::string username;
};



void sendbroadcast_message(std::string message);
void set_non_blocking(int sock);
