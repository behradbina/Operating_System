#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define SHM_KEY 12345
#define LOCK_KEY 1

// Lock structure for synchronization
struct lock {
    int flag;
};

// Initialize lock
void lock_init(struct lock *lk) {
    lk->flag = 0;
}

// Acquire lock
void lock_acquire(struct lock *lk) {
    while (__sync_lock_test_and_set(&lk->flag, 1)) {
        // Spin-wait
    }
}

// Release lock
void lock_release(struct lock *lk) {
    __sync_lock_release(&lk->flag);
}

// Child process function
void compute_factorial(int n, int num_processes, int child_id, int *shared_mem,  int use_lock,int lock) {
   // printf(1,"hiiiiiii I%d\n",*shared_mem);
   
    for (int i = child_id + 1; i <= n; i += num_processes) {
        if (use_lock) {
            while(lock){
               
            }
             lock=1;
        }
       ( *shared_mem)=  (*shared_mem) *i;
//printf(1,"shared_mem is %d and i is %d\n", *shared_mem,i);
        //printf(1,",shared_mem is %d and i is %d\", *shared_mem,child_id);
        if (use_lock) {
            lock=0;
        }
//    // }
}
   printf(1, "Factorial of %d with %d processes: %d, address: %d\n", n, num_processes, *shared_mem,shared_mem);
    exit();
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf(1, "Usage: %s <number> <num_processes>\n", argv[0]);
        exit();
    }

    int n = atoi(argv[1]);
    int num_processes = atoi(argv[2]);
    int use_lock = 1; // Set to 0 to test without locking mechanism
     struct lock* lk;
     int lock=0;
    // Allocate shared memory
    char *shared_mem = opensharedmem(SHM_KEY);
    //char* lk_address=opensharedmem(1);
     

    if (shared_mem == 0 ) {
        printf(1, "Failed to allocate shared memory\n");
        exit();
    }

     *shared_mem = 1; // Initialize factorial result
   
    int pid;
    for (int i = 0; i < num_processes; i++) {
        pid = fork();
 //printf(1,"mehrad loves zakie \n");

        if (pid < 0) {
            printf(1, "Fork failed\n");
            exit();
        } else if (pid == 0) {
            // Child process
            compute_factorial(n, num_processes, i,(int*) shared_mem,  use_lock,lock);
        }
    }

    // Wait for child processes to finish
    for (int i = 0; i < num_processes; i++) {
        wait();
    }

    // Print the final result
   // printf(1, "Factorial of %d with %d processes: %d, address: %d\n", n, num_processes, *shared_mem,shared_mem);
 closesharedmem(SHM_KEY);
 ///closesharedmem(LOCK_KEY); 
   

    exit();
}