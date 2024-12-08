#include "types.h"
#include "stat.h"
#include "user.h"

// A simple function to simulate some work
void do_work(int duration) {
  //  cprintf("****************");
    int start = uptime();
    printf(1,"%d",start);
    while (uptime() - start < duration) {
        // Busy loop to simulate work
    }
    //cprintf("%d",uptime());
}

int main(int argc, char *argv[]) {
    int pid;
    int num_processes = 4; 
    int durations[] = {2000, 4000, 6000, 8000, 1000};
    if (argc < 3) {
        printf(1, "Usage: testsechduler <pid> <queue>\n");
        exit();
    }


   int pid_ = atoi(argv[1]);
   int new_q=atoi(argv[2]);
    
    for (int i = 0; i < num_processes; i++) {

        pid = fork();
      //  set_proc_sjf_params(pid,bursttime,confidence);
         
        if (pid == 0) {
            printf(1, "Process %d starting, duration: %d ticks\n", getpid(), durations[i]);
            do_work(durations[i]);
            printf(1, "Process %d finished\n", getpid());
            exit();
        } else if (pid < 0) {
            printf(1, "Fork failed\n");
            exit();
        }
    }
    change_schedular_queue(pid_,new_q);
   
        show_process_info();

    
    for (int i = 0; i < num_processes; i++) {
        wait();
    }

    printf(1, "All processes completed\n");
    exit();
}
