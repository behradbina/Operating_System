// testsortsyscalls.c
#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf(1, "Usage: testsortsyscalls <pid>\n");
        exit();
    }

    int pid = atoi(argv[1]);
    
    if (sort_syscalls(pid) < 0) {
        printf(1, "Error: Could not sort syscalls for pid %d\n", pid);
    } else {
        printf(1, "Syscalls for pid %d sorted successfully\n", pid);
    }

    exit();
}
