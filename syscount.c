#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"
#define NUM_FORKS 5

int main(int argc, char* argv[]){
    int fd = open("temp_file.txt",O_CREATE|O_WRONLY);
    for (int i = 0; i < NUM_FORKS; i++){
        int pid = fork();
        if (pid == 0){
            while ((open("file_lock", O_CREATE  | O_WRONLY)) < 0) ;
    
            char* write_data = "Man Aminam!";
            int length = 11;

            write(fd,write_data,length);
            write(fd,"\n",1);
            
            unlink("file_lock");
            exit();
            
        }
    }
    
    while (wait() != -1);
    close(fd);

    get_total_syscalls();
    exit();
}