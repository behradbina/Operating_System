#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"


struct {
    struct spinlock lock;
    int global_counter;
}  syscall_struct ;
void init_syscall_struct(){
  initlock(&syscall_struct.lock,"sycall_struct");
  syscall_struct.global_counter=0;
}
// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
  int i;

  for (i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void idtinit(void)
{
  lidt(idt, sizeof(idt));
}

void update_cpu_queue()
{
  if (ticks%10==0)
  {
    if (mycpu()->rr > 0)
    {
      mycpu()->rr--;
      if (mycpu()->rr == 0)
      {
        mycpu()->rr = 0;
        mycpu()->sjf = SJF_PR;
        mycpu()->fcfs = 0;
      }
      
    }
    else if (mycpu()->sjf > 0)
    {
      mycpu()->sjf--;
      if (mycpu()->sjf == 0)
      {
        mycpu()->rr = 0;
        mycpu()->sjf = 0;
        mycpu()->fcfs = FCFS_PR;
      }
    }
    else if (mycpu()->fcfs > 0)
    {
      mycpu()->fcfs--;

      if (mycpu()->fcfs == 0)
      {
        mycpu()->rr = RR_PR;
        mycpu()->sjf = 0;
        mycpu()->fcfs = 0;
      }
    }
  }
  
}




// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
  if (tf->trapno == T_SYSCALL)
  {
    if (myproc()->killed)
      exit();
    if (myproc()->numsystemcalls < 100)
      myproc()->systemcalls[myproc()->numsystemcalls++] = tf->eax;
    myproc()->tf = tf;
    syscall();

    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
  {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0)
    {
      acquire(&tickslock);
      ticks++;
      //update_cpu_queue();

      mycpu()->timePassed++;
  //     int num_sys=tf->eax;
  //   if (num_sys == 15)
  //  // cprintf("numsys")
  //   {
  //     mycpu()->weighted_syscall += 3; // Coefficient for open
  //  //   cprintf("too rohet kargahi\n");
  //      acquire(&syscall_struct.lock);
  //    // acquire(syscall_c.lock)
  //     syscall_struct.global_counter += 3;
  //      release(&syscall_struct.lock);
  //   }
  //   else if (num_sys == 16)
  //   {
  //    mycpu()->weighted_syscall += 2; // Coefficient for write
  //      acquire(&syscall_struct.lock);
  //    syscall_struct.global_counter += 2;
  //     release(&syscall_struct.lock);
  //   }
  //   else
  //   {
  //     mycpu()->weighted_syscall += 1; // Coefficient for all other calls
  //        acquire(&syscall_struct.lock);
  //       // cprintf("too rohet kargahi\n");
  //     syscall_struct.global_counter += 1;
  //    release(&syscall_struct.lock);
  //   }
      ageProcs();
      wakeup(&ticks);
      release(&tickslock);
    }
    else
    {
      mycpu()->timePassed++;
      ageProcs();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  // PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
    {
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

  if (myproc() && myproc()->state == RUNNING &&
      tf->trapno == T_IRQ0 + IRQ_TIMER){

      myproc()->sched_info.execution_time ++ ;
      if (mycpu()->qTypeTurn == ROUND_ROBIN && mycpu()->timePassed == 30)
      {
        // cprintf("RR time is finished we should go to SJF timePassed : %d\n", mycpu()->timePassed );
        mycpu()->qTypeTurn = SJF;
        mycpu()->timePassed = 1;
        yield();
      }
      else if (mycpu()->qTypeTurn == SJF && mycpu()->timePassed == 20)
      {
        // cprintf("SJF time is finished we should go to FCFS timePassed : %d\n", mycpu()->timePassed );
        mycpu()->qTypeTurn = FCFS;
        mycpu()->timePassed = 1;
        yield();
      }
      else if (mycpu()->qTypeTurn == FCFS && mycpu()->timePassed == 10)
      {
        // cprintf("FCFS time is finished we should go to RR timePassed : %d\n", mycpu()->timePassed );
        mycpu()->qTypeTurn = ROUND_ROBIN;
        mycpu()->timePassed = 1;
        yield();
      }
      else
      {
        if (myproc()->sched_info.queue == ROUND_ROBIN)
        {
          if (ticks%5 == 0)
          {
            yield();
          }
        }
      }
      // cprintf("cpu %d pid %d ticks %d q %d\n", (int)mycpu()->apicid ,myproc()->pid, ticks,myproc()->sched_info.queue);
      
  
  }

      

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();
}
void print_global(){
  cprintf("total global : %d\n",syscall_struct.global_counter);
}
int wrap_get_total(){
    int total_weighted_syscalls = 0;

    // // Iterate over all CPUs and sum their syscall_weight values
    for (int i = 0; i < 4; i++) 
      total_weighted_syscalls += cpus[i].weighted_syscall;
    //  // cprintf(1,"total global %d")
    // print_global();
    // total_weighted_syscalls+=cpus[1].weighted_syscall;
    // total_weighted_syscalls+=cpus[2].weighted_syscall;
    // total_weighted_syscalls+=cpus[3].weighted_syscall;

    // return total_weighted_syscalls;
   // return 0;
   cprintf("total in cores : %d \n",total_weighted_syscalls);
   print_global();
    return total_weighted_syscalls;
}