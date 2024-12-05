// testsortsyscalls.c
#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf(1, "Usage: get_mis_test <pid>\n");
        exit();
    }

    int pid = atoi(argv[1]);
    
    if (get_most_invoked_syscalls(pid) <0) {
        printf(1, "Error: getiing  the most system call unsuccessful %d\n", pid);
    } 

    exit();
}
