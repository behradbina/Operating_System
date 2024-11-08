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

int sys_move_file(void)
{
  char *src_file, *dest_dir;
  struct inode *src_inode, *dest_dir_inode, *dest_inode;
  struct file *src_f, *dest_f;
  char dest_path[MAXPATH];
  char *filename;
  char buffer[512];
  int n;

  // Retrieve arguments from system call
  if (argstr(0, &src_file) < 0 || argstr(1, &dest_dir) < 0)
  {
    return -1;
  }

  // Open the source file
  cprintf("Moving file: src_file=%s, dest_dir=%s\n", src_file, dest_dir);
  src_inode = namei(src_file);
  if (src_inode == 0)
  {
    cprintf("Error: Source file not found.\n");
    return -1;
  }

  // Allocate a file structure for reading the source file
  src_f = filealloc();
  if (src_f == 0)
  {
    cprintf("Error: Could not allocate file structure for source.\n");
    return -1;
  }
  src_f->type = FD_INODE;
  src_f->ip = src_inode;
  src_f->off = 0;
  src_f->readable = 1;
  src_f->writable = 0;

  // Check if the destination directory exists
  dest_dir_inode = namei(dest_dir);
  if (!dest_dir_inode || dest_dir_inode->type != T_DIR)
  {
    cprintf("Error: Destination directory does not exist or is not a directory.\n");
    fileclose(src_f);
    return -1;
  }

  // Construct the destination file path and filename
  safestrcpy(dest_path, dest_dir, MAXPATH);
  if (dest_path[strlen(dest_path) - 1] != '/')
  {
    memmove(dest_path + strlen(dest_path), "/", 2); // Add "/"
  }
  filename = src_file;
  for (char *p = src_file; *p; p++)
  {
    if (*p == '/')
      filename = p + 1;
  }
  safestrcpy(dest_path + strlen(dest_path), filename, MAXPATH - strlen(dest_path));

  // Start a transaction to safely allocate inode
  begin_op();

  // Allocate a new inode for the destination file
  dest_inode = ialloc(dest_dir_inode->dev, T_FILE);
  if (!dest_inode)
  {
    cprintf("Error: Could not allocate inode for destination file.\n");
    fileclose(src_f);
    end_op();
    return -1;
  }

  ilock(dest_inode);
  dest_inode->nlink = 1;
  iupdate(dest_inode);

  // Allocate a file structure for writing to the destination file
  dest_f = filealloc();
  if (dest_f == 0)
  {
    cprintf("Error: Could not allocate file structure for destination.\n");
    fileclose(src_f);
    iunlockput(dest_inode);
    end_op();
    return -1;
  }
  dest_f->type = FD_INODE;
  dest_f->ip = dest_inode;
  dest_f->off = 0;
  dest_f->readable = 0;
  dest_f->writable = 1;

  // Link the new file inode to the directory
  if (dirlink(dest_dir_inode, filename, dest_inode->inum) < 0)
  {
    cprintf("Error: Could not link file in destination directory.\n");
    fileclose(src_f);
    fileclose(dest_f);
    iunlockput(dest_inode);
    end_op();
    return -1;
  }

  // Copy the contents from source file to destination file
  // (n = fileread(src_f, buffer, sizeof(buffer)));
  // cprintf("Bytes read: %d\n", n);

  // // Print the contents of the buffer as a string
  // cprintf("Buffer contents: %s\n", buffer);
  while ((n = fileread(src_f, buffer, sizeof(buffer))) > 0)
  {
    cprintf("Bytes read: %d\n", n);

    // Null-terminate the buffer just for safe printing as a string
    buffer[n] = '\0';

    // Print buffer contents (as hex if not null-terminated)
    cprintf("Buffer contents: ");
    cprintf("%s", buffer);
    cprintf("Bytes read: %d\n", n);
    int t = filewrite(dest_f, buffer, n);
    cprintf("Bytes read: %d\n", t);
    break;
    if (t != n)
    {
      cprintf("Error: Write to destination file failed.\n");
      fileclose(src_f);
      fileclose(dest_f);
      iunlockput(dest_inode);
      end_op();
      return -1;
    }
  }

  // Close files and release inodes
  cprintf("Error: Write to destination file failed.\n");
  fileclose(src_f);
  fileclose(dest_f);
  iunlockput(dest_inode);
  end_op();

  // Delete the source file after copying
  if (sys_unlink(src_file) < 0)
  {
    cprintf("Error: Failed to delete source file after moving.\n");
    return -1;
  }

  return 0; // Success
}

int sys_sort_syscalls()
{
  int pid;
  if (argint(0, &pid) < 0)
  {
    return -1; // Return error if pid is not provided
  }
  struct proc *p;
  int i, j;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
   
      for (i = 0; i < p->numsystemcalls - 1; i++)
      {
        for (j = i + 1; j < p->numsystemcalls; j++)
        {
          if (p->systemcalls[i] > p->systemcalls[j])
          {
            
            int temp = p->systemcalls[i];
            p->systemcalls[i] = p->systemcalls[j];
            p->systemcalls[j] = temp;
          }
        }
      }
      for (i = 0; i < p->numsystemcalls; i++)
      {
        cprintf("%d ", p->systemcalls[i]);
      }
      cprintf("\n");

      return 0; 
    }
  }
  return -1; 
}

void sys_create_palindrome(void)
{
  int num;
  asm volatile("movl %%ecx, %0": "=r"(num));
   
  int reverse = 0;

  int temp = num;
  while (temp > 0) 
  {
    reverse = reverse * 10 + (temp % 10); 
    temp /= 10; 
  }

  int palindrome = num;
  int multiplier = 1;

  while (reverse > 0) 
  {
    palindrome = palindrome * 10 + (reverse % 10);
    reverse /= 10;
  }

  cprintf("%d\n", palindrome); 
}
