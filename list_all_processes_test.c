#include "types.h"
#include "user.h"
//#include "syscall.h"
#include "stat.h"



int main(int argc, char *argv[]) {
    if (argc != 1) {
        printf(2, "Usage: wrong number of inputs\n");
        exit();
    }
    printf(2,"try to make palindrome ... \n");

    if (list_all_processes() == 0) {
        printf(1, "successfully.\n");
    } else {
        printf(2, "Error.\n");
    }

    exit();
}
