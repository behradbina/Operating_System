#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct ptable_struct ptable;

static struct proc *initproc;



int nextpid = 1;
int global_syscall_count = 0;
int available=1;

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);




void pinit(void)
{
  initlock(&ptable.lock, "ptable");
 
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

struct proc *findproc(int pid)
{
  struct proc *p;

  // Acquire the process table lock to ensure thread safety.
  acquire(&ptable.lock);

  // Iterate over the process table to find the process with the matching pid.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      release(&ptable.lock); // Release the lock before returning.
      return p;
    }
  }

  // Release the lock if no process with the given pid is found.
  release(&ptable.lock);
  return 0;
}

int change_Q(int pid, int new_queue);
struct proc *
roundrobin();
struct proc *
fcfs(void);

// PAGEBREAK: 32
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;

  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->numsystemcalls = 0;
  p->sched_info.execution_time = 0;
  if (p->pid == 2 || p->pid == 1)
  {
    p->sched_info.queue = ROUND_ROBIN;
  }
  else 
  {
    p->sched_info.queue = FCFS;
  }
  p->age = 0;
  p->ticks = 0;
  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->sched_info.sjf.arrival_time = ticks;
  p->sched_info.sjf.confidence = 50;
  p->sched_info.sjf.burst_time = 2;
  p->sched_info.sjf.process_size = p->sz;
  p->start_time = ticks;
  p->consequtive_run = 0;

  if (p->pid != 0 && p->pid != 1 && p->pid != 2 )
  {
    // cprintf("pid : %d on cpu : %d \n" , p->pid, (int)mycpu()->apicid);
  }
  

  return p;
}

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  cprintf("pid : %d on cpu : %d \n" , np->pid, (int)mycpu()->apicid);

  release(&ptable.lock);

  if(pid==2 || pid == 1)
    set_level(pid, ROUND_ROBIN);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close ak open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.

unsigned int rand(void)
{
  // extern uint ticks; // Use system timer as a seed
  return (ticks * 1103515245 + 12345)%100; // A basic LCG formula
}

struct proc* short_job_first()
{
  struct proc* res=0;
  struct proc* p;
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++)
  {
    if((p->state != RUNNABLE) || (p->sched_info.queue!=SJF))
      continue;
    if(res == 0)
      res = p;
    if(p->sched_info.sjf.confidence > rand())
    {
      if(p->sched_info.sjf.burst_time < res->sched_info.sjf.burst_time)
        res = p;
    }
  }
  return res;
}

int set_level(int pid, int target_level)
{
  struct proc *p = findproc(pid);
  acquire(&ptable.lock);

  int old_queue = p->sched_info.queue;
  p->sched_info.queue = target_level;
  p->sched_info.arrival_queue_time = ticks;

  release(&ptable.lock);
  return old_queue;
}

struct proc* first_come_first_service()
{
  struct proc* res=0;
  struct proc* p;
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++)
  {
    if((p->state != RUNNABLE) || (p->sched_info.queue!=FCFS))
      continue;
      // cprintf("pid: %d arrival:  %d cpu: %d\n",p->pid,p->sched_info.sjf.arrival_time,(int)mycpu()->apicid);
    if(res == 0)
      res = p;
    else if(p->sched_info.sjf.arrival_time < res->sched_info.sjf.arrival_time)
      res = p;
  }
  if(res)
 // cprintf("chosen one is %d\n",res->pid);
  return res;
}


struct proc *
round_robin_t(struct proc *last_scheduled)
{
  struct proc *p = last_scheduled;
  for (;;)
  {
    p++;
    if (p >= &ptable.proc[NPROC])
      p = ptable.proc;
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
      return p;

    if (p == last_scheduled)
      return 0;
  }
  return 0;
}

void scheduler(void)
{
  struct proc *p = 0;
  
  struct cpu *c = mycpu();
  struct proc *last_scheduled_RR = &ptable.proc[NPROC - 1];
  c->proc = 0;

  for (;;)
  {
    sti();
    // Loop over process table looking for process to run.
    p = 0;
    acquire(&ptable.lock);
    //cprintf("time: %d",mycpu()->timePassed);
    if (mycpu()->qTypeTurn == ROUND_ROBIN)
    {
      if(mycpu()->rr>0)
      {
        p = round_robin_t(last_scheduled_RR);
      }
      if (!p)
      {
        mycpu()->qTypeTurn = SJF;
        mycpu()->timePassed =  1;
        p = short_job_first();
      }
      if (!p)
      {
        mycpu()->qTypeTurn = FCFS;
        mycpu()->timePassed = 1;
        p = first_come_first_service();
      }
      if (!p)
      {
        mycpu()->qTypeTurn = ROUND_ROBIN;
        mycpu()->timePassed = 1;
      }
      
      
    }
    else if (mycpu()->qTypeTurn == SJF)
    {
      p = short_job_first();
      if (!p)
      {
        mycpu()->qTypeTurn = FCFS;
        mycpu()->timePassed = 1;
        p = first_come_first_service();
      }
      if (!p)
      {
        mycpu()->qTypeTurn = ROUND_ROBIN;
        mycpu()->timePassed = 1;
        if(mycpu()->rr>0)
        {
          p = round_robin_t(last_scheduled_RR);
        }
      }
      if (!p)
      {
        mycpu()->qTypeTurn = SJF;
        mycpu()->timePassed =  1;
      }
      
    }
    else
    {
      p = first_come_first_service();
      if (!p)
      {
        mycpu()->qTypeTurn = ROUND_ROBIN;
        mycpu()->timePassed = 1;
        if(mycpu()->rr>0)
        {
          p = round_robin_t(last_scheduled_RR);
        }
      }
      if (!p)
      {
        mycpu()->qTypeTurn = SJF;
        mycpu()->timePassed =  1;
        p = short_job_first();
      }
      if (!p)
      {
        mycpu()->qTypeTurn = SJF;
        mycpu()->timePassed =  1;
      }
    }
        
        if (!p)
        {
          mycpu()->qTypeTurn = ROUND_ROBIN;
          mycpu()->timePassed = 0;
          release(&ptable.lock);

          continue;
        }

    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.

    c->proc = p;
    switchuvm(p);

    p->state = RUNNING;



    swtch(&(c->scheduler), p->context);
    switchkvm();

    p->consequtive_run += ticks - p->sched_info.last_exe_time;
    p->sched_info.last_exe_time = ticks;

    c->proc = 0;
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int sort_uniqe_procces(int pid)
{
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

int get_max_invoked(int pid)
{
  struct proc *p;
  int i, j;
  struct proc *target_p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      target_p = p;

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
      int count[300];
      memset(count, 0, 300);
      for (int i = 0; i < 300; i++)
      {
        count[i] = 0;
        // cprintf("%d \n",count[i]);
      }

      for (int i = 0; i < target_p->numsystemcalls; i++)
      {
        count[target_p->systemcalls[i]]++;
      }
      int max = -1;
      int max_index = -1;

      for (int i = 0; i < 30; i++)
      {
        if (count[i] >= max && count[i] != 0)
        {
          max = count[i];
          max_index = i;
        }
      }
      if (max == -1)
      {
        cprintf("no syscall found \n");
        return -1;
      }
      for (int i = 0; i < 30; i++)
      {
        if (count[i] == max)
        {
          cprintf("num of the system call is %d and it invoked is %d \n", i, count[i]);
          return i;
        }
      }
      // cprintf("num of the system call is %d and it invoked is %d \n",max_index,count[max_index]);
      return 0;
    }
  }
  cprintf("Pid not found \n");
  return -1;
}

int make_create_palindrom(long long int x)
{
  cprintf("Input number is : %d \n", x);
  long long int num = x;
  long long int comp = 0;
  while (x != 0)
  {
    comp = comp * 10 + x % 10;
    x = x / 10;
    num = num * 10;
  }
  num = num + comp;
  cprintf("palindrom value for given input is : %d \n", num);
  return 0;
}

int num_digits(int n)
{
  int num = 0;
  while (n != 0)
  {
    n /= 10;
    num += 1;
  }
  return num;
}

void space(int count)
{
  for (int i = 0; i < count; ++i)
    cprintf(" ");
}

int list_all_processes_(void)
{
  struct proc *p;
  int i, j;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid != 0)
    {
      cprintf("procces with pid : %d have these system calls : \n", p->pid);
      for (i = 0; i < p->numsystemcalls - 1; i++)
      {
        cprintf("system call number %d is %d \n", i + 1, p->systemcalls[i]);
      }
      cprintf("sum of all system calls is : %d \n", p->numsystemcalls);
    }
  }
  return 0;
}

int change_Q(int pid, int new_queue)
{
  struct proc *p;
  int old_queue = -1;

  if (new_queue == UNSET)
  {
    if (pid == 1)
      new_queue = ROUND_ROBIN;
    else if (pid > 1)
      new_queue = FCFS;
    else
      return -1;
  }
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      old_queue = p->sched_info.queue;
      p->sched_info.queue = new_queue;

      p->sched_info.arrival_queue_time = ticks;
    }
  }
  release(&ptable.lock);
  return old_queue;
}

void show_process_info()
{

  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleeping",
      [RUNNABLE] "runnable",
      [RUNNING] "running",
      [ZOMBIE] "zombie"};

  static int columns[] = {16, 8, 9, 8, 8, 8, 9, 8, 8, 8};
  cprintf("Process_Name    PID     State  Queue  wait time   Confidence  burst time consequtive run  arrival\n"
          "------------------------------------------------------------------------------------------------------\n");

  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;

    const char *state;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "unknown state";

    //name
    cprintf("%s", p->name);
    space(columns[0] - strlen(p->name));
    //pid
    cprintf("%d", p->pid);
    space(columns[1] - num_digits(p->pid));
    //state
    cprintf("%s", state);
    space(columns[2] - strlen(state));
    //queue
    cprintf("%d ", p->sched_info.queue);
    space(columns[3] - num_digits(p->sched_info.queue));

    //wait time
    if (p->state != RUNNABLE)
    {
      cprintf("%d", 0);
    }

    else
    {
      cprintf("%d", ticks - p->sched_info.last_exe_time);
    }
    
    space(columns[4] - num_digits(p->sched_info.sjf.confidence));

    //connfidence
    cprintf("%d", p->sched_info.sjf.confidence);
    space(columns[5] - num_digits(p->sched_info.sjf.confidence));
    //burst time
    cprintf("%d", p->sched_info.sjf.burst_time);
    space(columns[6] - num_digits(p->sched_info.sjf.burst_time));

    cprintf("%d", p->consequtive_run);
    space(columns[7] - num_digits(p->consequtive_run));

    cprintf("%d", p->sched_info.sjf.arrival_time);
    space(columns[8] - num_digits(p->sched_info.sjf.arrival_time));

    cprintf("\n");
  }
}

int set_proc_sjf_params_(int pid, int burst_time, int confidence)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->sched_info.sjf.burst_time = burst_time;
      p->sched_info.sjf.confidence = confidence;
      cprintf("%d %d %d %d %d \n", pid, p->sched_info.sjf.burst_time, p->sched_info.sjf.confidence, burst_time, confidence);
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

void ageProcs()
{
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == 0 || p->pid == 1 || p->pid == 2)
    {
      continue;
    }
    if (p->state == RUNNING)
    {
      p->ticks++;
    }
    
    if (p->state != RUNNABLE)
    {
      continue;
    }
    
    p->age++;
    if (p->age == 800)
    {
      if (p->sched_info.queue == FCFS)
      {
        p->sched_info.queue = SJF;
        cprintf("pid %d aged by one and age = %d and go to SJF Queue with %d cpu : %d doneTicks : %d \n" , p->pid, p->age, p->sched_info.queue, (int)mycpu()->apicid, p->ticks);
        p->age = 0;
      }
      else if (p->sched_info.queue == SJF )
      {
        p->sched_info.queue = ROUND_ROBIN;
        cprintf("pid %d aged by one and age = %d and go to RR Queue with %d cpu : %d doneTicks : %d \n" , p->pid, p->age, p->sched_info.queue, (int)mycpu()->apicid, p->ticks);
        p->age = 0;
      }
    }
  }
  release(&ptable.lock);
  
}
// void print_global(){
//   cprintf("global count is %d\n",syscall_c.global_counter);
// }
