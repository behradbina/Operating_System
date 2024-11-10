#include "types.h"
#include "user.h"
//#include "syscall.h"
#include "stat.h"



int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf(2, "Usage: wrong number of inputs\n");
        exit();
    }
    printf(2,"try to make palindrome ... \n");
    int num = atoi(argv[1]);
    asm volatile (
        "movl %0, %%ebx\n"     
        :
        : "r" (num)
        : "%ebx"
    );

    
    asm volatile ("int $64");  

    if (create_palindrom(num) == 0) {
        printf(1, "successfully.\n");
    } else {
        printf(2, "Error.\n");
    }
    exit();
}
