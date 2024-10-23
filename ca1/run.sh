#!/bin/bash
gcc -o connector connector.c -lpthread
gcc -o player player.c
./connector
