// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

// define arrow
#define UPARROWKEY 0xE2
#define DOWNARROWKEY 0xE3
#define LEFTARROWKEY 0xE4
#define RIGHTARROWKEY 0xE5
#define FORWARD 1
#define BACKWARD 0
#define NUMCOL 80
#define NUMROW 25
#define INPUT_BUF 128
#define HISTORYSIZE 10

char historyBuf[HISTORYSIZE][INPUT_BUF] = {'\0'};
int historyCurrentSize = 0;
int upDownKeyIndex = 0;
char tempBuf[INPUT_BUF] = {'\0'};
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  // uint end; // End index
  char historyBuf[HISTORYSIZE][INPUT_BUF];
} input;

// static voids
static void consputc(int);

// static variables
static int panicked = 0;
static int cap = 0;


static struct {
  struct spinlock lock;
  int locking;
} cons;


static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

// shift forward crt
void shift_forward_crt(int pos)
{
  for (int i = pos + cap; i > pos; i--)
    crt[i] = crt[i - 1];
}

// shift backward crt
void shift_back_crt(int pos)
{
  for (int i = pos - 1; i < pos + cap; i++)
    crt[i] = crt[i+1];
}

static int findPos()
{
  int pos;

  outb(CRTPORT, 14);
  pos = inb(CRTPORT + 1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT + 1);
  return pos;
}

static void goLeft(){
  
  int pos = findPos();
  int first_write_index = NUMCOL * ((int) pos / NUMCOL) + 2;

  if(pos >= first_write_index  && crt[pos - 2] != (('$' & 0xff) | 0x0700))
  {
    pos--;
  }
  if (pos+1 >= first_write_index)
  {
    cap++;
  }
  makeChangeInPos(pos);
}

static void goRight()
{
  int pos = findPos();

  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);

  if ((pos < last_index_line) && (cap > 0))
  {
    pos++;
    cap--;
  }
  makeChangeInPos(pos);
}

static void shift_buffer_left(char *buf)
{
  for (int i = input.e - cap - 1; i < input.e; i++)
  {
    buf[(i) % INPUT_BUF] = buf[(i + 1) % INPUT_BUF]; // Shift elements to left
  }
  input.buf[input.e] = ' ';
}

static void shift_buffer_right(char *buf)
{
  for (int i = input.e; i > input.e - cap; i--)
  {
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
  }
}

static void
cgaputc(int c)
{
  int pos = findPos();

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE) {
    shift_back_crt(pos);
    if(pos > 0)
      --pos;
  }
  else
  {
    shift_forward_crt(pos);
    crt[pos] = (c&0xff) | 0x0700;  // black on white
    pos++;
  }

  if(pos < 0 || pos > 25 * 80)
    panic("pos under/overflow");

  if((pos / 80) >= 24) {  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  makeChangeInPos(pos);

  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
}

void makeChangeInPos(int pos)
{
  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
}

void
consputc(int c)
{
  if(panicked) {
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE) {
    uartputc('\b');
    uartputc(' ');
    uartputc('\b');
  }
  else
    uartputc(c);
 
  cgaputc(c);
}

#define C(x)  ((x)-'@')  // Control-x

char* getLastCommand(int numberOfIgnore)
{
  static char result[INPUT_BUF] = {'\0'};
  int i = 0;
  for (i = 0; input.buf[i] != '\0'; i++)
  {
    
  }
  int k =  i-1;
  for (k = i-1; (k != -1); k--)
  {
    if (input.buf[k] == '\n')
    {
      if (numberOfIgnore == 0)
      {
        break;
      }
      else
      {
        i = k;
        numberOfIgnore--;
      }
    }
     
  }
  int h = k + 1;
  for (h = k+1; h < i; h++)
  {
    result[h-k-1] = input.buf[h];
  }
  result[h-k-1] = '\0';
  return result;
}

void addNewCommandToHistory()
{
  int freeIndex = HISTORYSIZE-1;
  for (int i = 0; i < HISTORYSIZE; i++)
  {
    if (historyBuf[i][0] == '\0')
    {
      freeIndex = i;
      break;
    }
  }
  for (int i = freeIndex; i >= 1; i--)
  {
    int j = 0;
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
    {
      historyBuf[i][j] = historyBuf[i-1][j];
    }
    historyBuf[i][j] = '\0';
  }
  char* res = getLastCommand(0);
  int i = 0;
  for (i = 0; res[i] != '\0'; i++)
  {
    historyBuf[0][i] = res[i];
  }
  historyBuf[0][i] = '\0';
  if (historyCurrentSize <= HISTORYSIZE)
  {
    historyCurrentSize = historyCurrentSize + 1;
  }
}

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'):
      case '\x7f':  // Backspace
        if(input.e != input.w && input.e - input.w > cap) {
          if (cap > 0)
            shift_buffer_left(input.buf);
          input.e--;
          consputc(BACKSPACE);
          if (cap == 0)
          {
            input.buf[input.e] = '\0';
          }
          
        }
      break;

    // left arrow
    case LEFTARROWKEY:
      if ((input.e - cap) > input.w) 
        goLeft();
      break;
   

    // Right Arrow
    case RIGHTARROWKEY:
        goRight();
    break;

    // UP Arrow 
    case UPARROWKEY:
      if (upDownKeyIndex < historyCurrentSize)
      {
        showPastCommand();
      }
      
    break;

    // DOWN Arrow
    case DOWNARROWKEY:
      if (upDownKeyIndex > 0)
      {
        showNewCommand();
      }
      
    break;

    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;

        if (c=='\n'){
          cap = 0;
          addNewCommandToHistory();
          controlNewCommand();
          upDownKeyIndex = 0;
        }

        shift_buffer_right(input.buf);
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
void showNewCommand()
{
  upDownKeyIndex--;
  clearTheInputLine();
  if (upDownKeyIndex == 0)
  {
    putLastCommandBuf(tempBuf);
  }
  else
  {
    putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
  }
  char* lastCommand = getLastCommand(0);
  print(lastCommand);
}
void showPastCommand()
{
  if (upDownKeyIndex == 0)
  {
    char* res = getLastCommand(0);
    int i = 0;
    for (i = 0; res[i] != '\0'; i++)
    {
      tempBuf[i] = res[i];
    }
    tempBuf[i] = '\0';
  }
  upDownKeyIndex++;
  clearTheInputLine();
  putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
  char* lastCommand = getLastCommand(0);
  print(lastCommand);
}
void putLastCommandBuf(char* changedCommand)
{
  int i = 0;
  for (i = 0; input.buf[i] != '\0'; i++)
  {
    
  }
  int k =  i-1;
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
  {
  }
  int h = k + 1;
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
  {
    input.buf[h] = changedCommand[h-k-1];
  }
  input.buf[h] = '\0';
  input.e = h;
}
void clearTheInputLine()
{
  for (int i = 0; i < cap; i++)
  {
    goRight();
  }
  cap = 0;
  char* res = getLastCommand(0);
  int i = 0;
  for (i = 0; res[i] != '\0'; i++)
  {
    consputc(BACKSPACE);
  }
  
}
int checkHistoryCommand(char* lastCommand)
{
  int flag = 1;
  char checkCommand[] = "history";
  int i;
  for (i = 0; lastCommand[i] != '\0'; i++)
  {
    if (checkCommand[i] != lastCommand[i] || i > 6)
    {
      flag = 0;
    }
  }
  if (i == 0)
  {
    flag = 0;
  }
  
  return flag;
}

void print(char* message)
{
  for (int i = 0; message[i] != '\0'; i++)
  {
    consputc(message[i]);
  }
  
}

void doHistoryCommand()
{
  consputc('\n');
  char message[] = "here are the lastest commands : ";
  print(message);
  consputc('\n');
  int i = 0;
  for (i = 0; i < HISTORYSIZE && historyBuf[i][0] != '\0' ; i++)
  {
    
  }
  i--;
  for (i ; i >= 0; i--)
  {
    printint(i+1,10 ,1);
    consputc(':');
    print(historyBuf[i]);
    consputc('\n');
  }
  
  
  
}

void controlNewCommand()
{
  char* lastCommand = getLastCommand(0);
  if (checkHistoryCommand(lastCommand))
  {
    doHistoryCommand();
  }
  
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}