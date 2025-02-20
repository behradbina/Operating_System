#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if (addr >= curproc->sz || addr + 4 > curproc->sz)
    return -1;
  *ip = *(int *)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if (addr >= curproc->sz)
    return -1;
  *pp = (char *)addr;
  ep = (char *)curproc->sz;
  for (s = *pp; s < ep; s++)
  {
    if (*s == 0)
      return s - *pp;
  }
  return -1;
}

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();

  if (argint(n, &i) < 0)
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
    return -1;
  *pp = (char *)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
  int addr;
  if (argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
extern int sys_my_syscall(void);
extern int sys_move_file(void);
extern int sys_sort_syscalls(void);
extern int sys_get_most_invoked_syscalls(void);
extern int sys_create_palindrom(void);
extern int sys_list_all_processes(void);
extern int sys_change_schedular_queue(void);
extern int sys_show_process_info(void);
extern int sys_set_proc_sjf_params(void);
extern int sys_get_total_syscalls(void);
extern int sys_test_recursive_lock(void);
extern char* sys_opensharedmem(void);
extern char* sys_closesharedmem(void);
static int (*syscalls[])(void) = {
    [SYS_fork] sys_fork,
    [SYS_exit] sys_exit,
    [SYS_wait] sys_wait,
    [SYS_pipe] sys_pipe,
    [SYS_read] sys_read,
    [SYS_kill] sys_kill,
    [SYS_exec] sys_exec,
    [SYS_fstat] sys_fstat,
    [SYS_chdir] sys_chdir,
    [SYS_dup] sys_dup,
    [SYS_getpid] sys_getpid,
    [SYS_sbrk] sys_sbrk,
    [SYS_sleep] sys_sleep,
    [SYS_uptime] sys_uptime,
    [SYS_open] sys_open,
    [SYS_write] sys_write,
    [SYS_mknod] sys_mknod,
    [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,
    [SYS_mkdir] sys_mkdir,
    [SYS_close] sys_close,
    [SYS_my_syscall] sys_my_syscall,
    [SYS_move_file] sys_move_file,
    [SYS_sort_syscalls] sys_sort_syscalls,
    [SYS_get_most_invoked_syscalls] sys_get_most_invoked_syscalls,
    [SYS_create_palindrom] sys_create_palindrom,
    [SYS_list_all_processes] sys_list_all_processes,
    [SYS_change_schedular_queue] sys_change_schedular_queue,
    [SYS_show_process_info] sys_show_process_info,
    [SYS_set_proc_sjf_params] sys_set_proc_sjf_params,
    [SYS_get_total_syscalls] sys_get_total_syscalls,
    [SYS_test_recursive_lock] sys_test_recursive_lock,
    [SYS_opensharedmem] sys_opensharedmem,
    [SYS_closesharedmem] sys_closesharedmem,
};

void syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  // struct cpu *c = mycpu();
  pushcli();               // Disable interrupts
  struct cpu *c = mycpu(); // Safe to call mycpu now
  popcli();
  num = curproc->tf->eax;
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
  {
    curproc->tf->eax = syscalls[num]();

    // if (num == SYS_open)
    // {
    //   c->weighted_syscall += 3; // Coefficient for open
    //    acquire_lock();
    //  // acquire(syscall_c.lock)
    //   global_syscall_count += 3;
    //    release_lock();
    // }
    // else if (num == SYS_write)
    // {
    //   c->weighted_syscall += 2; // Coefficient for write
    //   acquire_lock();
    //   global_syscall_count += 2;
    //    release_lock();
    // }
    // else
    // {
    //   c->weighted_syscall += 1; // Coefficient for all other calls
    //    acquire_lock();
    //   global_syscall_count += 1;
    //    release_lock();
    // }
  }
  else
  {
    cprintf("%d\n", num);
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
