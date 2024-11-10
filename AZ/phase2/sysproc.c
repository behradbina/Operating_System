#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "stat.h"
#include "fs.h"
#include "file.h"
#include "fcntl.h"

#define MAXPATH 1024 

int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
// In sysproc.c or your own file

// Example system call
int sys_my_syscall(void)
{
  // This can be anything, such as printing a message
  // printf(1, "My system call was invoked!\n");
  return 0; // You can return any value, or multiple values
}


int sys_sort_syscalls()
{
  int pid;
  if (argint(0, &pid) < 0)
  {
    return -1; // Return error if pid is not provided
  }
  return sort_uniqe_procces(pid);
} 
int sys_get_most_invoked_syscalls()
{
  int pid;
  if (argint(0, &pid) < 0)
  {
    return -1; // Return error if pid is not provided
  }
  return get_max_invoked(pid);
} 

int sys_create_palindrom(void){
  long long int num = myproc()->tf->ecx;
  return make_create_palindrom(num);
}

int sys_list_all_processes(void)
{
   
}