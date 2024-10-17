
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 6f 11 80       	mov    $0x80116ff0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 3a 10 80       	mov    $0x80103ab0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 7b 10 80       	push   $0x80107be0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 c5 4d 00 00       	call   80104e20 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 7b 10 80       	push   $0x80107be7
80100097:	50                   	push   %eax
80100098:	e8 53 4c 00 00       	call   80104cf0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 07 4f 00 00       	call   80104ff0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 29 4e 00 00       	call   80104f90 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 4b 00 00       	call   80104d30 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 9f 2b 00 00       	call   80102d30 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 7b 10 80       	push   $0x80107bee
801001a6:	e8 65 02 00 00       	call   80100410 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 0d 4c 00 00       	call   80104dd0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 57 2b 00 00       	jmp    80102d30 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 7b 10 80       	push   $0x80107bff
801001e1:	e8 2a 02 00 00       	call   80100410 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 4b 00 00       	call   80104dd0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 4b 00 00       	call   80104d90 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 d0 4d 00 00       	call   80104ff0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 4d 00 00       	jmp    80104f90 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 7c 10 80       	push   $0x80107c06
80100279:	e8 92 01 00 00       	call   80100410 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <goRight>:
  }
  makeChangeInPos(pos);
}

static void goRight()
{
80100280:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100281:	b8 0e 00 00 00       	mov    $0xe,%eax
80100286:	89 e5                	mov    %esp,%ebp
80100288:	56                   	push   %esi
80100289:	be d4 03 00 00       	mov    $0x3d4,%esi
8010028e:	53                   	push   %ebx
8010028f:	89 f2                	mov    %esi,%edx
80100291:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100292:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100297:	89 ca                	mov    %ecx,%edx
80100299:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010029a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010029d:	89 f2                	mov    %esi,%edx
8010029f:	b8 0f 00 00 00       	mov    $0xf,%eax
801002a4:	c1 e3 08             	shl    $0x8,%ebx
801002a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002a8:	89 ca                	mov    %ecx,%edx
801002aa:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801002ab:	0f b6 c8             	movzbl %al,%ecx
  int pos = findPos();

  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
801002ae:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT + 1);
801002b3:	09 d9                	or     %ebx,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
801002b5:	89 c8                	mov    %ecx,%eax
801002b7:	f7 e2                	mul    %edx
801002b9:	c1 ea 06             	shr    $0x6,%edx
801002bc:	8d 44 92 05          	lea    0x5(%edx,%edx,4),%eax
801002c0:	c1 e0 04             	shl    $0x4,%eax
801002c3:	83 e8 01             	sub    $0x1,%eax

  if ((pos < last_index_line) && (cap > 0))
801002c6:	39 c8                	cmp    %ecx,%eax
801002c8:	7e 14                	jle    801002de <goRight+0x5e>
801002ca:	a1 78 0a 11 80       	mov    0x80110a78,%eax
801002cf:	85 c0                	test   %eax,%eax
801002d1:	7e 0b                	jle    801002de <goRight+0x5e>
  {
    pos++;
    cap--;
801002d3:	83 e8 01             	sub    $0x1,%eax
    pos++;
801002d6:	83 c1 01             	add    $0x1,%ecx
    cap--;
801002d9:	a3 78 0a 11 80       	mov    %eax,0x80110a78
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002de:	be d4 03 00 00       	mov    $0x3d4,%esi
801002e3:	b8 0e 00 00 00       	mov    $0xe,%eax
801002e8:	89 f2                	mov    %esi,%edx
801002ea:	ee                   	out    %al,(%dx)
801002eb:	bb d5 03 00 00       	mov    $0x3d5,%ebx
}

void makeChangeInPos(int pos)
{
  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
801002f0:	89 c8                	mov    %ecx,%eax
801002f2:	c1 f8 08             	sar    $0x8,%eax
801002f5:	89 da                	mov    %ebx,%edx
801002f7:	ee                   	out    %al,(%dx)
801002f8:	b8 0f 00 00 00       	mov    $0xf,%eax
801002fd:	89 f2                	mov    %esi,%edx
801002ff:	ee                   	out    %al,(%dx)
80100300:	89 c8                	mov    %ecx,%eax
80100302:	89 da                	mov    %ebx,%edx
80100304:	ee                   	out    %al,(%dx)
}
80100305:	5b                   	pop    %ebx
80100306:	5e                   	pop    %esi
80100307:	5d                   	pop    %ebp
80100308:	c3                   	ret    
80100309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100310 <consoleread>:
  
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
80100313:	57                   	push   %edi
80100314:	56                   	push   %esi
80100315:	53                   	push   %ebx
80100316:	83 ec 18             	sub    $0x18,%esp
80100319:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010031c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010031f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100322:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100324:	e8 87 1f 00 00       	call   801022b0 <iunlock>
  acquire(&cons.lock);
80100329:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80100330:	e8 bb 4c 00 00       	call   80104ff0 <acquire>
  while(n > 0){
80100335:	83 c4 10             	add    $0x10,%esp
80100338:	85 db                	test   %ebx,%ebx
8010033a:	0f 8e 94 00 00 00    	jle    801003d4 <consoleread+0xc4>
    while(input.r == input.w){
80100340:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100345:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010034b:	74 25                	je     80100372 <consoleread+0x62>
8010034d:	eb 59                	jmp    801003a8 <consoleread+0x98>
8010034f:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100350:	83 ec 08             	sub    $0x8,%esp
80100353:	68 40 0a 11 80       	push   $0x80110a40
80100358:	68 00 ff 10 80       	push   $0x8010ff00
8010035d:	e8 2e 47 00 00       	call   80104a90 <sleep>
    while(input.r == input.w){
80100362:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100367:	83 c4 10             	add    $0x10,%esp
8010036a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100370:	75 36                	jne    801003a8 <consoleread+0x98>
      if(myproc()->killed){
80100372:	e8 49 40 00 00       	call   801043c0 <myproc>
80100377:	8b 48 24             	mov    0x24(%eax),%ecx
8010037a:	85 c9                	test   %ecx,%ecx
8010037c:	74 d2                	je     80100350 <consoleread+0x40>
        release(&cons.lock);
8010037e:	83 ec 0c             	sub    $0xc,%esp
80100381:	68 40 0a 11 80       	push   $0x80110a40
80100386:	e8 05 4c 00 00       	call   80104f90 <release>
        ilock(ip);
8010038b:	5a                   	pop    %edx
8010038c:	ff 75 08             	push   0x8(%ebp)
8010038f:	e8 3c 1e 00 00       	call   801021d0 <ilock>
        return -1;
80100394:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100397:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010039a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010039f:	5b                   	pop    %ebx
801003a0:	5e                   	pop    %esi
801003a1:	5f                   	pop    %edi
801003a2:	5d                   	pop    %ebp
801003a3:	c3                   	ret    
801003a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
801003a8:	8d 50 01             	lea    0x1(%eax),%edx
801003ab:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
801003b1:	89 c2                	mov    %eax,%edx
801003b3:	83 e2 7f             	and    $0x7f,%edx
801003b6:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
801003bd:	80 f9 04             	cmp    $0x4,%cl
801003c0:	74 37                	je     801003f9 <consoleread+0xe9>
    *dst++ = c;
801003c2:	83 c6 01             	add    $0x1,%esi
    --n;
801003c5:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
801003c8:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801003cb:	83 f9 0a             	cmp    $0xa,%ecx
801003ce:	0f 85 64 ff ff ff    	jne    80100338 <consoleread+0x28>
  release(&cons.lock);
801003d4:	83 ec 0c             	sub    $0xc,%esp
801003d7:	68 40 0a 11 80       	push   $0x80110a40
801003dc:	e8 af 4b 00 00       	call   80104f90 <release>
  ilock(ip);
801003e1:	58                   	pop    %eax
801003e2:	ff 75 08             	push   0x8(%ebp)
801003e5:	e8 e6 1d 00 00       	call   801021d0 <ilock>
  return target - n;
801003ea:	89 f8                	mov    %edi,%eax
801003ec:	83 c4 10             	add    $0x10,%esp
}
801003ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
801003f2:	29 d8                	sub    %ebx,%eax
}
801003f4:	5b                   	pop    %ebx
801003f5:	5e                   	pop    %esi
801003f6:	5f                   	pop    %edi
801003f7:	5d                   	pop    %ebp
801003f8:	c3                   	ret    
      if(n < target){
801003f9:	39 fb                	cmp    %edi,%ebx
801003fb:	73 d7                	jae    801003d4 <consoleread+0xc4>
        input.r--;
801003fd:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100402:	eb d0                	jmp    801003d4 <consoleread+0xc4>
80100404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010040f:	90                   	nop

80100410 <panic>:
{
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	56                   	push   %esi
80100414:	53                   	push   %ebx
80100415:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100418:	fa                   	cli    
  cons.locking = 0;
80100419:	c7 05 74 0a 11 80 00 	movl   $0x0,0x80110a74
80100420:	00 00 00 
  getcallerpcs(&s, pcs);
80100423:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100426:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100429:	e8 12 2f 00 00       	call   80103340 <lapicid>
8010042e:	83 ec 08             	sub    $0x8,%esp
80100431:	50                   	push   %eax
80100432:	68 0d 7c 10 80       	push   $0x80107c0d
80100437:	e8 54 03 00 00       	call   80100790 <cprintf>
  cprintf(s);
8010043c:	58                   	pop    %eax
8010043d:	ff 75 08             	push   0x8(%ebp)
80100440:	e8 4b 03 00 00       	call   80100790 <cprintf>
  cprintf("\n");
80100445:	c7 04 24 37 85 10 80 	movl   $0x80108537,(%esp)
8010044c:	e8 3f 03 00 00       	call   80100790 <cprintf>
  getcallerpcs(&s, pcs);
80100451:	8d 45 08             	lea    0x8(%ebp),%eax
80100454:	5a                   	pop    %edx
80100455:	59                   	pop    %ecx
80100456:	53                   	push   %ebx
80100457:	50                   	push   %eax
80100458:	e8 e3 49 00 00       	call   80104e40 <getcallerpcs>
  for(i=0; i<10; i++)
8010045d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100460:	83 ec 08             	sub    $0x8,%esp
80100463:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
80100465:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
80100468:	68 21 7c 10 80       	push   $0x80107c21
8010046d:	e8 1e 03 00 00       	call   80100790 <cprintf>
  for(i=0; i<10; i++)
80100472:	83 c4 10             	add    $0x10,%esp
80100475:	39 f3                	cmp    %esi,%ebx
80100477:	75 e7                	jne    80100460 <panic+0x50>
  panicked = 1; // freeze other CPU
80100479:	c7 05 7c 0a 11 80 01 	movl   $0x1,0x80110a7c
80100480:	00 00 00 
  for(;;)
80100483:	eb fe                	jmp    80100483 <panic+0x73>
80100485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010048c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100490 <consputc.part.0>:
consputc(int c)
80100490:	55                   	push   %ebp
80100491:	89 e5                	mov    %esp,%ebp
80100493:	57                   	push   %edi
80100494:	56                   	push   %esi
80100495:	53                   	push   %ebx
80100496:	89 c3                	mov    %eax,%ebx
80100498:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE) {
8010049b:	3d 00 01 00 00       	cmp    $0x100,%eax
801004a0:	0f 84 4a 01 00 00    	je     801005f0 <consputc.part.0+0x160>
    uartputc(c);
801004a6:	83 ec 0c             	sub    $0xc,%esp
801004a9:	50                   	push   %eax
801004aa:	e8 51 62 00 00       	call   80106700 <uartputc>
801004af:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004b2:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004b7:	b8 0e 00 00 00       	mov    $0xe,%eax
801004bc:	89 fa                	mov    %edi,%edx
801004be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004bf:	be d5 03 00 00       	mov    $0x3d5,%esi
801004c4:	89 f2                	mov    %esi,%edx
801004c6:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801004c7:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ca:	89 fa                	mov    %edi,%edx
801004cc:	b8 0f 00 00 00       	mov    $0xf,%eax
801004d1:	c1 e1 08             	shl    $0x8,%ecx
801004d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004d5:	89 f2                	mov    %esi,%edx
801004d7:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801004d8:	0f b6 c0             	movzbl %al,%eax
801004db:	09 c8                	or     %ecx,%eax
  if(c == '\n')
801004dd:	83 fb 0a             	cmp    $0xa,%ebx
801004e0:	0f 84 f2 00 00 00    	je     801005d8 <consputc.part.0+0x148>
  for (int i = pos - 1; i < pos + cap; i++)
801004e6:	8b 3d 78 0a 11 80    	mov    0x80110a78,%edi
801004ec:	8d 34 38             	lea    (%eax,%edi,1),%esi
  else if(c == BACKSPACE) {
801004ef:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801004f5:	0f 84 9d 00 00 00    	je     80100598 <consputc.part.0+0x108>
  for (int i = pos + cap; i > pos; i--)
801004fb:	39 f0                	cmp    %esi,%eax
801004fd:	7d 1f                	jge    8010051e <consputc.part.0+0x8e>
801004ff:	8d 94 36 fe 7f 0b 80 	lea    -0x7ff48002(%esi,%esi,1),%edx
80100506:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010050d:	8d 76 00             	lea    0x0(%esi),%esi
    crt[i] = crt[i - 1];
80100510:	0f b7 0a             	movzwl (%edx),%ecx
  for (int i = pos + cap; i > pos; i--)
80100513:	83 ea 02             	sub    $0x2,%edx
    crt[i] = crt[i - 1];
80100516:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for (int i = pos + cap; i > pos; i--)
8010051a:	39 d6                	cmp    %edx,%esi
8010051c:	75 f2                	jne    80100510 <consputc.part.0+0x80>
    crt[pos] = (c&0xff) | 0x0700;  // black on white
8010051e:	0f b6 db             	movzbl %bl,%ebx
80100521:	80 cf 07             	or     $0x7,%bh
80100524:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010052b:	80 
    pos++;
8010052c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(pos < 0 || pos > 25 * 80)
8010052f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100535:	0f 8f 2f 01 00 00    	jg     8010066a <consputc.part.0+0x1da>
  if((pos / 80) >= 24) {  // Scroll up.
8010053b:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100541:	0f 8f d9 00 00 00    	jg     80100620 <consputc.part.0+0x190>
  outb(CRTPORT + 1, pos >> 8);
80100547:	0f b6 c7             	movzbl %bh,%eax
  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
8010054a:	8b 3d 78 0a 11 80    	mov    0x80110a78,%edi
  outb(CRTPORT + 1, pos);
80100550:	89 de                	mov    %ebx,%esi
  outb(CRTPORT + 1, pos >> 8);
80100552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
80100555:	01 df                	add    %ebx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100557:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010055c:	b8 0e 00 00 00       	mov    $0xe,%eax
80100561:	89 da                	mov    %ebx,%edx
80100563:	ee                   	out    %al,(%dx)
80100564:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100569:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
8010056d:	89 ca                	mov    %ecx,%edx
8010056f:	ee                   	out    %al,(%dx)
80100570:	b8 0f 00 00 00       	mov    $0xf,%eax
80100575:	89 da                	mov    %ebx,%edx
80100577:	ee                   	out    %al,(%dx)
80100578:	89 f0                	mov    %esi,%eax
8010057a:	89 ca                	mov    %ecx,%edx
8010057c:	ee                   	out    %al,(%dx)
8010057d:	b8 20 07 00 00       	mov    $0x720,%eax
80100582:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
80100589:	80 
}
8010058a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010058d:	5b                   	pop    %ebx
8010058e:	5e                   	pop    %esi
8010058f:	5f                   	pop    %edi
80100590:	5d                   	pop    %ebp
80100591:	c3                   	ret    
80100592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int i = pos - 1; i < pos + cap; i++)
80100598:	8d 58 ff             	lea    -0x1(%eax),%ebx
8010059b:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
801005a2:	89 d9                	mov    %ebx,%ecx
801005a4:	85 ff                	test   %edi,%edi
801005a6:	78 1c                	js     801005c4 <consputc.part.0+0x134>
801005a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801005af:	90                   	nop
    crt[i] = crt[i+1];
801005b0:	0f b7 02             	movzwl (%edx),%eax
  for (int i = pos - 1; i < pos + cap; i++)
801005b3:	83 c1 01             	add    $0x1,%ecx
801005b6:	83 c2 02             	add    $0x2,%edx
    crt[i] = crt[i+1];
801005b9:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for (int i = pos - 1; i < pos + cap; i++)
801005bd:	39 f1                	cmp    %esi,%ecx
801005bf:	7c ef                	jl     801005b0 <consputc.part.0+0x120>
801005c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0)
801005c4:	85 c0                	test   %eax,%eax
801005c6:	0f 85 63 ff ff ff    	jne    8010052f <consputc.part.0+0x9f>
801005cc:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801005d0:	31 f6                	xor    %esi,%esi
801005d2:	eb 83                	jmp    80100557 <consputc.part.0+0xc7>
801005d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801005d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801005dd:	f7 e2                	mul    %edx
801005df:	c1 ea 06             	shr    $0x6,%edx
801005e2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801005e5:	c1 e0 04             	shl    $0x4,%eax
801005e8:	8d 58 50             	lea    0x50(%eax),%ebx
801005eb:	e9 3f ff ff ff       	jmp    8010052f <consputc.part.0+0x9f>
    uartputc('\b');
801005f0:	83 ec 0c             	sub    $0xc,%esp
801005f3:	6a 08                	push   $0x8
801005f5:	e8 06 61 00 00       	call   80106700 <uartputc>
    uartputc(' ');
801005fa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100601:	e8 fa 60 00 00       	call   80106700 <uartputc>
    uartputc('\b');
80100606:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010060d:	e8 ee 60 00 00       	call   80106700 <uartputc>
80100612:	83 c4 10             	add    $0x10,%esp
80100615:	e9 98 fe ff ff       	jmp    801004b2 <consputc.part.0+0x22>
8010061a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100620:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100623:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100626:	68 60 0e 00 00       	push   $0xe60
  outb(CRTPORT + 1, pos);
8010062b:	89 fe                	mov    %edi,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010062d:	68 a0 80 0b 80       	push   $0x800b80a0
80100632:	68 00 80 0b 80       	push   $0x800b8000
80100637:	e8 14 4b 00 00       	call   80105150 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010063c:	b8 80 07 00 00       	mov    $0x780,%eax
80100641:	83 c4 0c             	add    $0xc,%esp
80100644:	29 f8                	sub    %edi,%eax
80100646:	01 c0                	add    %eax,%eax
80100648:	50                   	push   %eax
80100649:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
80100650:	6a 00                	push   $0x0
80100652:	50                   	push   %eax
80100653:	e8 58 4a 00 00       	call   801050b0 <memset>
  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
80100658:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010065c:	03 3d 78 0a 11 80    	add    0x80110a78,%edi
80100662:	83 c4 10             	add    $0x10,%esp
80100665:	e9 ed fe ff ff       	jmp    80100557 <consputc.part.0+0xc7>
    panic("pos under/overflow");
8010066a:	83 ec 0c             	sub    $0xc,%esp
8010066d:	68 25 7c 10 80       	push   $0x80107c25
80100672:	e8 99 fd ff ff       	call   80100410 <panic>
80100677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067e:	66 90                	xchg   %ax,%ax

80100680 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100689:	ff 75 08             	push   0x8(%ebp)
{
8010068c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010068f:	e8 1c 1c 00 00       	call   801022b0 <iunlock>
  acquire(&cons.lock);
80100694:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010069b:	e8 50 49 00 00       	call   80104ff0 <acquire>
  for(i = 0; i < n; i++)
801006a0:	83 c4 10             	add    $0x10,%esp
801006a3:	85 f6                	test   %esi,%esi
801006a5:	7e 25                	jle    801006cc <consolewrite+0x4c>
801006a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006aa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked) {
801006ad:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
    consputc(buf[i] & 0xff);
801006b3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked) {
801006b6:	85 d2                	test   %edx,%edx
801006b8:	74 06                	je     801006c0 <consolewrite+0x40>
  asm volatile("cli");
801006ba:	fa                   	cli    
    for(;;)
801006bb:	eb fe                	jmp    801006bb <consolewrite+0x3b>
801006bd:	8d 76 00             	lea    0x0(%esi),%esi
801006c0:	e8 cb fd ff ff       	call   80100490 <consputc.part.0>
  for(i = 0; i < n; i++)
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	39 df                	cmp    %ebx,%edi
801006ca:	75 e1                	jne    801006ad <consolewrite+0x2d>
  release(&cons.lock);
801006cc:	83 ec 0c             	sub    $0xc,%esp
801006cf:	68 40 0a 11 80       	push   $0x80110a40
801006d4:	e8 b7 48 00 00       	call   80104f90 <release>
  ilock(ip);
801006d9:	58                   	pop    %eax
801006da:	ff 75 08             	push   0x8(%ebp)
801006dd:	e8 ee 1a 00 00       	call   801021d0 <ilock>

  return n;
}
801006e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e5:	89 f0                	mov    %esi,%eax
801006e7:	5b                   	pop    %ebx
801006e8:	5e                   	pop    %esi
801006e9:	5f                   	pop    %edi
801006ea:	5d                   	pop    %ebp
801006eb:	c3                   	ret    
801006ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801006f0 <printint>:
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 2c             	sub    $0x2c,%esp
801006f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801006fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801006ff:	85 c9                	test   %ecx,%ecx
80100701:	74 04                	je     80100707 <printint+0x17>
80100703:	85 c0                	test   %eax,%eax
80100705:	78 6d                	js     80100774 <printint+0x84>
    x = xx;
80100707:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010070e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100710:	31 db                	xor    %ebx,%ebx
80100712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100718:	89 c8                	mov    %ecx,%eax
8010071a:	31 d2                	xor    %edx,%edx
8010071c:	89 de                	mov    %ebx,%esi
8010071e:	89 cf                	mov    %ecx,%edi
80100720:	f7 75 d4             	divl   -0x2c(%ebp)
80100723:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100726:	0f b6 92 50 7c 10 80 	movzbl -0x7fef83b0(%edx),%edx
  }while((x /= base) != 0);
8010072d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010072f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100733:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100736:	73 e0                	jae    80100718 <printint+0x28>
  if(sign)
80100738:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010073b:	85 c9                	test   %ecx,%ecx
8010073d:	74 0c                	je     8010074b <printint+0x5b>
    buf[i++] = '-';
8010073f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100744:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100746:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010074b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010074f:	0f be c2             	movsbl %dl,%eax
  if(panicked) {
80100752:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
80100758:	85 d2                	test   %edx,%edx
8010075a:	74 04                	je     80100760 <printint+0x70>
8010075c:	fa                   	cli    
    for(;;)
8010075d:	eb fe                	jmp    8010075d <printint+0x6d>
8010075f:	90                   	nop
80100760:	e8 2b fd ff ff       	call   80100490 <consputc.part.0>
  while(--i >= 0)
80100765:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100768:	39 c3                	cmp    %eax,%ebx
8010076a:	74 0e                	je     8010077a <printint+0x8a>
    consputc(buf[i]);
8010076c:	0f be 03             	movsbl (%ebx),%eax
8010076f:	83 eb 01             	sub    $0x1,%ebx
80100772:	eb de                	jmp    80100752 <printint+0x62>
    x = -xx;
80100774:	f7 d8                	neg    %eax
80100776:	89 c1                	mov    %eax,%ecx
80100778:	eb 96                	jmp    80100710 <printint+0x20>
}
8010077a:	83 c4 2c             	add    $0x2c,%esp
8010077d:	5b                   	pop    %ebx
8010077e:	5e                   	pop    %esi
8010077f:	5f                   	pop    %edi
80100780:	5d                   	pop    %ebp
80100781:	c3                   	ret    
80100782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100790 <cprintf>:
{
80100790:	55                   	push   %ebp
80100791:	89 e5                	mov    %esp,%ebp
80100793:	57                   	push   %edi
80100794:	56                   	push   %esi
80100795:	53                   	push   %ebx
80100796:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100799:	a1 74 0a 11 80       	mov    0x80110a74,%eax
8010079e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 85 27 01 00 00    	jne    801008d0 <cprintf+0x140>
  if (fmt == 0)
801007a9:	8b 75 08             	mov    0x8(%ebp),%esi
801007ac:	85 f6                	test   %esi,%esi
801007ae:	0f 84 ac 01 00 00    	je     80100960 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801007b7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ba:	31 db                	xor    %ebx,%ebx
801007bc:	85 c0                	test   %eax,%eax
801007be:	74 56                	je     80100816 <cprintf+0x86>
    if(c != '%'){
801007c0:	83 f8 25             	cmp    $0x25,%eax
801007c3:	0f 85 cf 00 00 00    	jne    80100898 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801007c9:	83 c3 01             	add    $0x1,%ebx
801007cc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801007d0:	85 d2                	test   %edx,%edx
801007d2:	74 42                	je     80100816 <cprintf+0x86>
    switch(c){
801007d4:	83 fa 70             	cmp    $0x70,%edx
801007d7:	0f 84 90 00 00 00    	je     8010086d <cprintf+0xdd>
801007dd:	7f 51                	jg     80100830 <cprintf+0xa0>
801007df:	83 fa 25             	cmp    $0x25,%edx
801007e2:	0f 84 c0 00 00 00    	je     801008a8 <cprintf+0x118>
801007e8:	83 fa 64             	cmp    $0x64,%edx
801007eb:	0f 85 f4 00 00 00    	jne    801008e5 <cprintf+0x155>
      printint(*argp++, 10, 1);
801007f1:	8d 47 04             	lea    0x4(%edi),%eax
801007f4:	b9 01 00 00 00       	mov    $0x1,%ecx
801007f9:	ba 0a 00 00 00       	mov    $0xa,%edx
801007fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100801:	8b 07                	mov    (%edi),%eax
80100803:	e8 e8 fe ff ff       	call   801006f0 <printint>
80100808:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080b:	83 c3 01             	add    $0x1,%ebx
8010080e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	75 aa                	jne    801007c0 <cprintf+0x30>
  if(locking)
80100816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100819:	85 c0                	test   %eax,%eax
8010081b:	0f 85 22 01 00 00    	jne    80100943 <cprintf+0x1b3>
}
80100821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100824:	5b                   	pop    %ebx
80100825:	5e                   	pop    %esi
80100826:	5f                   	pop    %edi
80100827:	5d                   	pop    %ebp
80100828:	c3                   	ret    
80100829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100830:	83 fa 73             	cmp    $0x73,%edx
80100833:	75 33                	jne    80100868 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100835:	8d 47 04             	lea    0x4(%edi),%eax
80100838:	8b 3f                	mov    (%edi),%edi
8010083a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010083d:	85 ff                	test   %edi,%edi
8010083f:	0f 84 e3 00 00 00    	je     80100928 <cprintf+0x198>
      for(; *s; s++)
80100845:	0f be 07             	movsbl (%edi),%eax
80100848:	84 c0                	test   %al,%al
8010084a:	0f 84 08 01 00 00    	je     80100958 <cprintf+0x1c8>
  if(panicked) {
80100850:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
80100856:	85 d2                	test   %edx,%edx
80100858:	0f 84 b2 00 00 00    	je     80100910 <cprintf+0x180>
8010085e:	fa                   	cli    
    for(;;)
8010085f:	eb fe                	jmp    8010085f <cprintf+0xcf>
80100861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100868:	83 fa 78             	cmp    $0x78,%edx
8010086b:	75 78                	jne    801008e5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010086d:	8d 47 04             	lea    0x4(%edi),%eax
80100870:	31 c9                	xor    %ecx,%ecx
80100872:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100877:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010087d:	8b 07                	mov    (%edi),%eax
8010087f:	e8 6c fe ff ff       	call   801006f0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100884:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100888:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010088b:	85 c0                	test   %eax,%eax
8010088d:	0f 85 2d ff ff ff    	jne    801007c0 <cprintf+0x30>
80100893:	eb 81                	jmp    80100816 <cprintf+0x86>
80100895:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
80100898:	8b 0d 7c 0a 11 80    	mov    0x80110a7c,%ecx
8010089e:	85 c9                	test   %ecx,%ecx
801008a0:	74 14                	je     801008b6 <cprintf+0x126>
801008a2:	fa                   	cli    
    for(;;)
801008a3:	eb fe                	jmp    801008a3 <cprintf+0x113>
801008a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
801008a8:	a1 7c 0a 11 80       	mov    0x80110a7c,%eax
801008ad:	85 c0                	test   %eax,%eax
801008af:	75 6c                	jne    8010091d <cprintf+0x18d>
801008b1:	b8 25 00 00 00       	mov    $0x25,%eax
801008b6:	e8 d5 fb ff ff       	call   80100490 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008bb:	83 c3 01             	add    $0x1,%ebx
801008be:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801008c2:	85 c0                	test   %eax,%eax
801008c4:	0f 85 f6 fe ff ff    	jne    801007c0 <cprintf+0x30>
801008ca:	e9 47 ff ff ff       	jmp    80100816 <cprintf+0x86>
801008cf:	90                   	nop
    acquire(&cons.lock);
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	68 40 0a 11 80       	push   $0x80110a40
801008d8:	e8 13 47 00 00       	call   80104ff0 <acquire>
801008dd:	83 c4 10             	add    $0x10,%esp
801008e0:	e9 c4 fe ff ff       	jmp    801007a9 <cprintf+0x19>
  if(panicked) {
801008e5:	8b 0d 7c 0a 11 80    	mov    0x80110a7c,%ecx
801008eb:	85 c9                	test   %ecx,%ecx
801008ed:	75 31                	jne    80100920 <cprintf+0x190>
801008ef:	b8 25 00 00 00       	mov    $0x25,%eax
801008f4:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008f7:	e8 94 fb ff ff       	call   80100490 <consputc.part.0>
801008fc:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
80100902:	85 d2                	test   %edx,%edx
80100904:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100907:	74 2e                	je     80100937 <cprintf+0x1a7>
80100909:	fa                   	cli    
    for(;;)
8010090a:	eb fe                	jmp    8010090a <cprintf+0x17a>
8010090c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100910:	e8 7b fb ff ff       	call   80100490 <consputc.part.0>
      for(; *s; s++)
80100915:	83 c7 01             	add    $0x1,%edi
80100918:	e9 28 ff ff ff       	jmp    80100845 <cprintf+0xb5>
8010091d:	fa                   	cli    
    for(;;)
8010091e:	eb fe                	jmp    8010091e <cprintf+0x18e>
80100920:	fa                   	cli    
80100921:	eb fe                	jmp    80100921 <cprintf+0x191>
80100923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100927:	90                   	nop
        s = "(null)";
80100928:	bf 38 7c 10 80       	mov    $0x80107c38,%edi
      for(; *s; s++)
8010092d:	b8 28 00 00 00       	mov    $0x28,%eax
80100932:	e9 19 ff ff ff       	jmp    80100850 <cprintf+0xc0>
80100937:	89 d0                	mov    %edx,%eax
80100939:	e8 52 fb ff ff       	call   80100490 <consputc.part.0>
8010093e:	e9 c8 fe ff ff       	jmp    8010080b <cprintf+0x7b>
    release(&cons.lock);
80100943:	83 ec 0c             	sub    $0xc,%esp
80100946:	68 40 0a 11 80       	push   $0x80110a40
8010094b:	e8 40 46 00 00       	call   80104f90 <release>
80100950:	83 c4 10             	add    $0x10,%esp
}
80100953:	e9 c9 fe ff ff       	jmp    80100821 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100958:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010095b:	e9 ab fe ff ff       	jmp    8010080b <cprintf+0x7b>
    panic("null fmt");
80100960:	83 ec 0c             	sub    $0xc,%esp
80100963:	68 3f 7c 10 80       	push   $0x80107c3f
80100968:	e8 a3 fa ff ff       	call   80100410 <panic>
8010096d:	8d 76 00             	lea    0x0(%esi),%esi

80100970 <shift_forward_crt>:
{
80100970:	55                   	push   %ebp
  for (int i = pos + cap; i > pos; i--)
80100971:	a1 78 0a 11 80       	mov    0x80110a78,%eax
{
80100976:	89 e5                	mov    %esp,%ebp
80100978:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i = pos + cap; i > pos; i--)
8010097b:	01 d0                	add    %edx,%eax
8010097d:	39 c2                	cmp    %eax,%edx
8010097f:	7d 1d                	jge    8010099e <shift_forward_crt+0x2e>
80100981:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
80100988:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
8010098f:	90                   	nop
    crt[i] = crt[i - 1];
80100990:	0f b7 10             	movzwl (%eax),%edx
  for (int i = pos + cap; i > pos; i--)
80100993:	83 e8 02             	sub    $0x2,%eax
    crt[i] = crt[i - 1];
80100996:	66 89 50 04          	mov    %dx,0x4(%eax)
  for (int i = pos + cap; i > pos; i--)
8010099a:	39 c8                	cmp    %ecx,%eax
8010099c:	75 f2                	jne    80100990 <shift_forward_crt+0x20>
}
8010099e:	5d                   	pop    %ebp
8010099f:	c3                   	ret    

801009a0 <shift_back_crt>:
{
801009a0:	55                   	push   %ebp
  for (int i = pos - 1; i < pos + cap; i++)
801009a1:	8b 0d 78 0a 11 80    	mov    0x80110a78,%ecx
{
801009a7:	89 e5                	mov    %esp,%ebp
801009a9:	53                   	push   %ebx
801009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for (int i = pos - 1; i < pos + cap; i++)
801009ad:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
801009b0:	85 c9                	test   %ecx,%ecx
801009b2:	78 1d                	js     801009d1 <shift_back_crt+0x31>
801009b4:	8d 50 ff             	lea    -0x1(%eax),%edx
801009b7:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
801009be:	66 90                	xchg   %ax,%ax
    crt[i] = crt[i+1];
801009c0:	0f b7 08             	movzwl (%eax),%ecx
  for (int i = pos - 1; i < pos + cap; i++)
801009c3:	83 c2 01             	add    $0x1,%edx
801009c6:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i+1];
801009c9:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for (int i = pos - 1; i < pos + cap; i++)
801009cd:	39 da                	cmp    %ebx,%edx
801009cf:	7c ef                	jl     801009c0 <shift_back_crt+0x20>
}
801009d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801009d4:	c9                   	leave  
801009d5:	c3                   	ret    
801009d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009dd:	8d 76 00             	lea    0x0(%esi),%esi

801009e0 <makeChangeInPos>:
{
801009e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009e1:	b8 0e 00 00 00       	mov    $0xe,%eax
801009e6:	89 e5                	mov    %esp,%ebp
801009e8:	56                   	push   %esi
801009e9:	be d4 03 00 00       	mov    $0x3d4,%esi
801009ee:	53                   	push   %ebx
801009ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
801009f2:	89 f2                	mov    %esi,%edx
801009f4:	ee                   	out    %al,(%dx)
801009f5:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
801009fa:	89 c8                	mov    %ecx,%eax
801009fc:	c1 f8 08             	sar    $0x8,%eax
801009ff:	89 da                	mov    %ebx,%edx
80100a01:	ee                   	out    %al,(%dx)
80100a02:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a07:	89 f2                	mov    %esi,%edx
80100a09:	ee                   	out    %al,(%dx)
80100a0a:	89 c8                	mov    %ecx,%eax
80100a0c:	89 da                	mov    %ebx,%edx
80100a0e:	ee                   	out    %al,(%dx)
}
80100a0f:	5b                   	pop    %ebx
80100a10:	5e                   	pop    %esi
80100a11:	5d                   	pop    %ebp
80100a12:	c3                   	ret    
80100a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a20 <getLastCommand>:
{
80100a20:	55                   	push   %ebp
  for (i = 0; input.buf[i] != '\0'; i++)
80100a21:	80 3d 80 fe 10 80 00 	cmpb   $0x0,0x8010fe80
{
80100a28:	89 e5                	mov    %esp,%ebp
80100a2a:	56                   	push   %esi
80100a2b:	8b 55 08             	mov    0x8(%ebp),%edx
80100a2e:	53                   	push   %ebx
  for (i = 0; input.buf[i] != '\0'; i++)
80100a2f:	0f 84 93 00 00 00    	je     80100ac8 <getLastCommand+0xa8>
80100a35:	31 f6                	xor    %esi,%esi
80100a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a3e:	66 90                	xchg   %ax,%ax
80100a40:	89 f0                	mov    %esi,%eax
80100a42:	83 c6 01             	add    $0x1,%esi
80100a45:	80 be 80 fe 10 80 00 	cmpb   $0x0,-0x7fef0180(%esi)
80100a4c:	75 f2                	jne    80100a40 <getLastCommand+0x20>
    if (input.buf[k] == '\n')
80100a4e:	80 b8 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%eax)
80100a55:	74 17                	je     80100a6e <getLastCommand+0x4e>
80100a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5e:	66 90                	xchg   %ax,%ax
  for (k = i-1; (k != -1); k--)
80100a60:	83 e8 01             	sub    $0x1,%eax
80100a63:	72 17                	jb     80100a7c <getLastCommand+0x5c>
    if (input.buf[k] == '\n')
80100a65:	80 b8 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%eax)
80100a6c:	75 f2                	jne    80100a60 <getLastCommand+0x40>
      if (numberOfIgnore == 0)
80100a6e:	85 d2                	test   %edx,%edx
80100a70:	74 4e                	je     80100ac0 <getLastCommand+0xa0>
        numberOfIgnore--;
80100a72:	83 ea 01             	sub    $0x1,%edx
80100a75:	89 c6                	mov    %eax,%esi
  for (k = i-1; (k != -1); k--)
80100a77:	83 e8 01             	sub    $0x1,%eax
80100a7a:	73 e9                	jae    80100a65 <getLastCommand+0x45>
80100a7c:	31 d2                	xor    %edx,%edx
  for (h = k+1; h < i; h++)
80100a7e:	39 f2                	cmp    %esi,%edx
80100a80:	7d 46                	jge    80100ac8 <getLastCommand+0xa8>
    result[h-k-1] = input.buf[h];
80100a82:	89 c3                	mov    %eax,%ebx
80100a84:	f7 db                	neg    %ebx
80100a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a8d:	8d 76 00             	lea    0x0(%esi),%esi
80100a90:	0f b6 8a 80 fe 10 80 	movzbl -0x7fef0180(%edx),%ecx
80100a97:	88 8c 13 bf 09 11 80 	mov    %cl,-0x7feef641(%ebx,%edx,1)
  for (h = k+1; h < i; h++)
80100a9e:	83 c2 01             	add    $0x1,%edx
80100aa1:	39 f2                	cmp    %esi,%edx
80100aa3:	75 eb                	jne    80100a90 <getLastCommand+0x70>
  result[h-k-1] = '\0';
80100aa5:	29 c2                	sub    %eax,%edx
}
80100aa7:	5b                   	pop    %ebx
80100aa8:	b8 c0 09 11 80       	mov    $0x801109c0,%eax
80100aad:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100aae:	83 ea 01             	sub    $0x1,%edx
}
80100ab1:	5d                   	pop    %ebp
  result[h-k-1] = '\0';
80100ab2:	c6 82 c0 09 11 80 00 	movb   $0x0,-0x7feef640(%edx)
}
80100ab9:	c3                   	ret    
80100aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int h = k + 1;
80100ac0:	8d 50 01             	lea    0x1(%eax),%edx
80100ac3:	eb b9                	jmp    80100a7e <getLastCommand+0x5e>
80100ac5:	8d 76 00             	lea    0x0(%esi),%esi
  for (h = k+1; h < i; h++)
80100ac8:	31 d2                	xor    %edx,%edx
}
80100aca:	5b                   	pop    %ebx
80100acb:	b8 c0 09 11 80       	mov    $0x801109c0,%eax
80100ad0:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100ad1:	c6 82 c0 09 11 80 00 	movb   $0x0,-0x7feef640(%edx)
}
80100ad8:	5d                   	pop    %ebp
80100ad9:	c3                   	ret    
80100ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ae0 <addNewCommandToHistory>:
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
  for (int i = 0; i < HISTORYSIZE; i++)
80100ae5:	31 f6                	xor    %esi,%esi
{
80100ae7:	53                   	push   %ebx
80100ae8:	83 ec 1c             	sub    $0x1c,%esp
80100aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100aef:	90                   	nop
    if (historyBuf[i][0] == '\0')
80100af0:	89 f0                	mov    %esi,%eax
80100af2:	c1 e0 07             	shl    $0x7,%eax
80100af5:	80 b8 c0 04 11 80 00 	cmpb   $0x0,-0x7feefb40(%eax)
80100afc:	74 64                	je     80100b62 <addNewCommandToHistory+0x82>
  for (int i = 0; i < HISTORYSIZE; i++)
80100afe:	83 c6 01             	add    $0x1,%esi
80100b01:	83 fe 0a             	cmp    $0xa,%esi
80100b04:	75 ea                	jne    80100af0 <addNewCommandToHistory+0x10>
  int freeIndex = HISTORYSIZE-1;
80100b06:	be 09 00 00 00       	mov    $0x9,%esi
80100b0b:	89 f3                	mov    %esi,%ebx
80100b0d:	c1 e3 07             	shl    $0x7,%ebx
80100b10:	8d 7b 80             	lea    -0x80(%ebx),%edi
80100b13:	89 f9                	mov    %edi,%ecx
80100b15:	8d 76 00             	lea    0x0(%esi),%esi
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100b18:	0f b6 91 c0 04 11 80 	movzbl -0x7feefb40(%ecx),%edx
80100b1f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80100b22:	31 c0                	xor    %eax,%eax
80100b24:	83 ee 01             	sub    $0x1,%esi
80100b27:	84 d2                	test   %dl,%dl
80100b29:	74 1b                	je     80100b46 <addNewCommandToHistory+0x66>
80100b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b2f:	90                   	nop
      historyBuf[i][j] = historyBuf[i-1][j];
80100b30:	88 94 03 c0 04 11 80 	mov    %dl,-0x7feefb40(%ebx,%eax,1)
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100b37:	83 c0 01             	add    $0x1,%eax
80100b3a:	0f b6 94 01 c0 04 11 	movzbl -0x7feefb40(%ecx,%eax,1),%edx
80100b41:	80 
80100b42:	84 d2                	test   %dl,%dl
80100b44:	75 ea                	jne    80100b30 <addNewCommandToHistory+0x50>
    historyBuf[i][j] = '\0';
80100b46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (int i = freeIndex; i >= 1; i--)
80100b49:	89 fb                	mov    %edi,%ebx
80100b4b:	83 c1 80             	add    $0xffffff80,%ecx
    historyBuf[i][j] = '\0';
80100b4e:	c1 e2 07             	shl    $0x7,%edx
80100b51:	c6 84 10 c0 04 11 80 	movb   $0x0,-0x7feefb40(%eax,%edx,1)
80100b58:	00 
  for (int i = freeIndex; i >= 1; i--)
80100b59:	85 f6                	test   %esi,%esi
80100b5b:	74 13                	je     80100b70 <addNewCommandToHistory+0x90>
80100b5d:	83 c7 80             	add    $0xffffff80,%edi
80100b60:	eb b6                	jmp    80100b18 <addNewCommandToHistory+0x38>
80100b62:	85 f6                	test   %esi,%esi
80100b64:	75 a5                	jne    80100b0b <addNewCommandToHistory+0x2b>
80100b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6d:	8d 76 00             	lea    0x0(%esi),%esi
  char* res = getLastCommand(0);
80100b70:	83 ec 0c             	sub    $0xc,%esp
80100b73:	6a 00                	push   $0x0
80100b75:	e8 a6 fe ff ff       	call   80100a20 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100b7a:	83 c4 10             	add    $0x10,%esp
80100b7d:	31 d2                	xor    %edx,%edx
80100b7f:	0f b6 08             	movzbl (%eax),%ecx
80100b82:	84 c9                	test   %cl,%cl
80100b84:	74 1b                	je     80100ba1 <addNewCommandToHistory+0xc1>
80100b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b8d:	8d 76 00             	lea    0x0(%esi),%esi
    historyBuf[0][i] = res[i];
80100b90:	88 8a c0 04 11 80    	mov    %cl,-0x7feefb40(%edx)
  for (i = 0; res[i] != '\0'; i++)
80100b96:	83 c2 01             	add    $0x1,%edx
80100b99:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100b9d:	84 c9                	test   %cl,%cl
80100b9f:	75 ef                	jne    80100b90 <addNewCommandToHistory+0xb0>
  if (historyCurrentSize <= HISTORYSIZE)
80100ba1:	a1 a4 04 11 80       	mov    0x801104a4,%eax
  historyBuf[0][i] = '\0';
80100ba6:	c6 82 c0 04 11 80 00 	movb   $0x0,-0x7feefb40(%edx)
  if (historyCurrentSize <= HISTORYSIZE)
80100bad:	83 f8 0a             	cmp    $0xa,%eax
80100bb0:	7f 08                	jg     80100bba <addNewCommandToHistory+0xda>
    historyCurrentSize = historyCurrentSize + 1;
80100bb2:	83 c0 01             	add    $0x1,%eax
80100bb5:	a3 a4 04 11 80       	mov    %eax,0x801104a4
}
80100bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bbd:	5b                   	pop    %ebx
80100bbe:	5e                   	pop    %esi
80100bbf:	5f                   	pop    %edi
80100bc0:	5d                   	pop    %ebp
80100bc1:	c3                   	ret    
80100bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100bd0 <putLastCommandBuf>:
{
80100bd0:	55                   	push   %ebp
  for (i = 0; input.buf[i] != '\0'; i++)
80100bd1:	31 c0                	xor    %eax,%eax
80100bd3:	80 3d 80 fe 10 80 00 	cmpb   $0x0,0x8010fe80
{
80100bda:	89 e5                	mov    %esp,%ebp
80100bdc:	53                   	push   %ebx
80100bdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = 0; input.buf[i] != '\0'; i++)
80100be0:	74 76                	je     80100c58 <putLastCommandBuf+0x88>
80100be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100be8:	89 c2                	mov    %eax,%edx
80100bea:	83 c0 01             	add    $0x1,%eax
80100bed:	80 b8 80 fe 10 80 00 	cmpb   $0x0,-0x7fef0180(%eax)
80100bf4:	75 f2                	jne    80100be8 <putLastCommandBuf+0x18>
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
80100bf6:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100bfd:	75 0e                	jne    80100c0d <putLastCommandBuf+0x3d>
80100bff:	eb 1a                	jmp    80100c1b <putLastCommandBuf+0x4b>
80100c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c08:	83 fa ff             	cmp    $0xffffffff,%edx
80100c0b:	74 43                	je     80100c50 <putLastCommandBuf+0x80>
80100c0d:	89 d0                	mov    %edx,%eax
80100c0f:	83 ea 01             	sub    $0x1,%edx
80100c12:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100c19:	75 ed                	jne    80100c08 <putLastCommandBuf+0x38>
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100c1b:	0f b6 0b             	movzbl (%ebx),%ecx
80100c1e:	84 c9                	test   %cl,%cl
80100c20:	74 18                	je     80100c3a <putLastCommandBuf+0x6a>
80100c22:	29 d3                	sub    %edx,%ebx
80100c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    input.buf[h] = changedCommand[h-k-1];
80100c28:	88 88 80 fe 10 80    	mov    %cl,-0x7fef0180(%eax)
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100c2e:	83 c0 01             	add    $0x1,%eax
80100c31:	0f b6 4c 03 ff       	movzbl -0x1(%ebx,%eax,1),%ecx
80100c36:	84 c9                	test   %cl,%cl
80100c38:	75 ee                	jne    80100c28 <putLastCommandBuf+0x58>
  input.buf[h] = '\0';
80100c3a:	c6 80 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%eax)
}
80100c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  input.e = h;
80100c44:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
}
80100c49:	c9                   	leave  
80100c4a:	c3                   	ret    
80100c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c4f:	90                   	nop
80100c50:	31 c0                	xor    %eax,%eax
80100c52:	eb c7                	jmp    80100c1b <putLastCommandBuf+0x4b>
80100c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int k =  i-1;
80100c58:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80100c5d:	eb bc                	jmp    80100c1b <putLastCommandBuf+0x4b>
80100c5f:	90                   	nop

80100c60 <clearTheInputLine>:
{
80100c60:	55                   	push   %ebp
80100c61:	89 e5                	mov    %esp,%ebp
80100c63:	53                   	push   %ebx
80100c64:	83 ec 04             	sub    $0x4,%esp
  for (int i = 0; i < cap; i++)
80100c67:	8b 15 78 0a 11 80    	mov    0x80110a78,%edx
80100c6d:	85 d2                	test   %edx,%edx
80100c6f:	7e 17                	jle    80100c88 <clearTheInputLine+0x28>
80100c71:	31 db                	xor    %ebx,%ebx
80100c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c77:	90                   	nop
    goRight();
80100c78:	e8 03 f6 ff ff       	call   80100280 <goRight>
  for (int i = 0; i < cap; i++)
80100c7d:	83 c3 01             	add    $0x1,%ebx
80100c80:	39 1d 78 0a 11 80    	cmp    %ebx,0x80110a78
80100c86:	7f f0                	jg     80100c78 <clearTheInputLine+0x18>
  cap = 0;
80100c88:	c7 05 78 0a 11 80 00 	movl   $0x0,0x80110a78
80100c8f:	00 00 00 
  char* res = getLastCommand(0);
80100c92:	83 ec 0c             	sub    $0xc,%esp
80100c95:	6a 00                	push   $0x0
80100c97:	e8 84 fd ff ff       	call   80100a20 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	80 38 00             	cmpb   $0x0,(%eax)
80100ca2:	74 27                	je     80100ccb <clearTheInputLine+0x6b>
80100ca4:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100ca7:	a1 7c 0a 11 80       	mov    0x80110a7c,%eax
80100cac:	85 c0                	test   %eax,%eax
80100cae:	74 08                	je     80100cb8 <clearTheInputLine+0x58>
  asm volatile("cli");
80100cb0:	fa                   	cli    
    for(;;)
80100cb1:	eb fe                	jmp    80100cb1 <clearTheInputLine+0x51>
80100cb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb7:	90                   	nop
80100cb8:	b8 00 01 00 00       	mov    $0x100,%eax
  for (i = 0; res[i] != '\0'; i++)
80100cbd:	83 c3 01             	add    $0x1,%ebx
80100cc0:	e8 cb f7 ff ff       	call   80100490 <consputc.part.0>
80100cc5:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
80100cc9:	75 dc                	jne    80100ca7 <clearTheInputLine+0x47>
}
80100ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cce:	c9                   	leave  
80100ccf:	c3                   	ret    

80100cd0 <showNewCommand>:
{
80100cd0:	55                   	push   %ebp
80100cd1:	89 e5                	mov    %esp,%ebp
80100cd3:	53                   	push   %ebx
80100cd4:	83 ec 04             	sub    $0x4,%esp
  upDownKeyIndex--;
80100cd7:	83 2d a0 04 11 80 01 	subl   $0x1,0x801104a0
  clearTheInputLine();
80100cde:	e8 7d ff ff ff       	call   80100c60 <clearTheInputLine>
  if (upDownKeyIndex == 0)
80100ce3:	a1 a0 04 11 80       	mov    0x801104a0,%eax
80100ce8:	85 c0                	test   %eax,%eax
80100cea:	75 4c                	jne    80100d38 <showNewCommand+0x68>
    putLastCommandBuf(tempBuf);
80100cec:	83 ec 0c             	sub    $0xc,%esp
80100cef:	68 20 04 11 80       	push   $0x80110420
80100cf4:	e8 d7 fe ff ff       	call   80100bd0 <putLastCommandBuf>
80100cf9:	83 c4 10             	add    $0x10,%esp
  char* lastCommand = getLastCommand(0);
80100cfc:	83 ec 0c             	sub    $0xc,%esp
80100cff:	6a 00                	push   $0x0
80100d01:	e8 1a fd ff ff       	call   80100a20 <getLastCommand>
  for (int i = 0; message[i] != '\0'; i++)
80100d06:	83 c4 10             	add    $0x10,%esp
80100d09:	0f b6 10             	movzbl (%eax),%edx
80100d0c:	84 d2                	test   %dl,%dl
80100d0e:	74 23                	je     80100d33 <showNewCommand+0x63>
80100d10:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100d13:	a1 7c 0a 11 80       	mov    0x80110a7c,%eax
80100d18:	85 c0                	test   %eax,%eax
80100d1a:	74 04                	je     80100d20 <showNewCommand+0x50>
80100d1c:	fa                   	cli    
    for(;;)
80100d1d:	eb fe                	jmp    80100d1d <showNewCommand+0x4d>
80100d1f:	90                   	nop
    consputc(message[i]);
80100d20:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; message[i] != '\0'; i++)
80100d23:	83 c3 01             	add    $0x1,%ebx
80100d26:	e8 65 f7 ff ff       	call   80100490 <consputc.part.0>
80100d2b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
80100d2f:	84 d2                	test   %dl,%dl
80100d31:	75 e0                	jne    80100d13 <showNewCommand+0x43>
}
80100d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d36:	c9                   	leave  
80100d37:	c3                   	ret    
    putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100d38:	c1 e0 07             	shl    $0x7,%eax
80100d3b:	83 ec 0c             	sub    $0xc,%esp
80100d3e:	05 40 04 11 80       	add    $0x80110440,%eax
80100d43:	50                   	push   %eax
80100d44:	e8 87 fe ff ff       	call   80100bd0 <putLastCommandBuf>
80100d49:	83 c4 10             	add    $0x10,%esp
80100d4c:	eb ae                	jmp    80100cfc <showNewCommand+0x2c>
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <showPastCommand>:
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
80100d54:	83 ec 04             	sub    $0x4,%esp
  if (upDownKeyIndex == 0)
80100d57:	8b 1d a0 04 11 80    	mov    0x801104a0,%ebx
80100d5d:	85 db                	test   %ebx,%ebx
80100d5f:	74 67                	je     80100dc8 <showPastCommand+0x78>
  upDownKeyIndex++;
80100d61:	83 c3 01             	add    $0x1,%ebx
80100d64:	89 1d a0 04 11 80    	mov    %ebx,0x801104a0
  clearTheInputLine();
80100d6a:	e8 f1 fe ff ff       	call   80100c60 <clearTheInputLine>
  putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100d6f:	a1 a0 04 11 80       	mov    0x801104a0,%eax
80100d74:	83 ec 0c             	sub    $0xc,%esp
80100d77:	c1 e0 07             	shl    $0x7,%eax
80100d7a:	05 40 04 11 80       	add    $0x80110440,%eax
80100d7f:	50                   	push   %eax
80100d80:	e8 4b fe ff ff       	call   80100bd0 <putLastCommandBuf>
  char* lastCommand = getLastCommand(0);
80100d85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80100d8c:	e8 8f fc ff ff       	call   80100a20 <getLastCommand>
  for (int i = 0; message[i] != '\0'; i++)
80100d91:	83 c4 10             	add    $0x10,%esp
80100d94:	0f b6 10             	movzbl (%eax),%edx
80100d97:	8d 58 01             	lea    0x1(%eax),%ebx
80100d9a:	84 d2                	test   %dl,%dl
80100d9c:	74 25                	je     80100dc3 <showPastCommand+0x73>
  if(panicked) {
80100d9e:	a1 7c 0a 11 80       	mov    0x80110a7c,%eax
80100da3:	85 c0                	test   %eax,%eax
80100da5:	74 09                	je     80100db0 <showPastCommand+0x60>
80100da7:	fa                   	cli    
    for(;;)
80100da8:	eb fe                	jmp    80100da8 <showPastCommand+0x58>
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(message[i]);
80100db0:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; message[i] != '\0'; i++)
80100db3:	83 c3 01             	add    $0x1,%ebx
80100db6:	e8 d5 f6 ff ff       	call   80100490 <consputc.part.0>
80100dbb:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
80100dbf:	84 d2                	test   %dl,%dl
80100dc1:	75 db                	jne    80100d9e <showPastCommand+0x4e>
}
80100dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc6:	c9                   	leave  
80100dc7:	c3                   	ret    
    char* res = getLastCommand(0);
80100dc8:	83 ec 0c             	sub    $0xc,%esp
80100dcb:	6a 00                	push   $0x0
80100dcd:	e8 4e fc ff ff       	call   80100a20 <getLastCommand>
    for (i = 0; res[i] != '\0'; i++)
80100dd2:	83 c4 10             	add    $0x10,%esp
80100dd5:	0f b6 10             	movzbl (%eax),%edx
80100dd8:	84 d2                	test   %dl,%dl
80100dda:	74 15                	je     80100df1 <showPastCommand+0xa1>
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      tempBuf[i] = res[i];
80100de0:	88 93 20 04 11 80    	mov    %dl,-0x7feefbe0(%ebx)
    for (i = 0; res[i] != '\0'; i++)
80100de6:	83 c3 01             	add    $0x1,%ebx
80100de9:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
80100ded:	84 d2                	test   %dl,%dl
80100def:	75 ef                	jne    80100de0 <showPastCommand+0x90>
    tempBuf[i] = '\0';
80100df1:	c6 83 20 04 11 80 00 	movb   $0x0,-0x7feefbe0(%ebx)
  upDownKeyIndex++;
80100df8:	8b 1d a0 04 11 80    	mov    0x801104a0,%ebx
80100dfe:	e9 5e ff ff ff       	jmp    80100d61 <showPastCommand+0x11>
80100e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e10 <checkHistoryCommand>:
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	56                   	push   %esi
80100e14:	53                   	push   %ebx
80100e15:	83 ec 10             	sub    $0x10,%esp
80100e18:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char checkCommand[] = "history";
80100e1b:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
80100e22:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100e29:	0f b6 13             	movzbl (%ebx),%edx
80100e2c:	84 d2                	test   %dl,%dl
80100e2e:	74 30                	je     80100e60 <checkHistoryCommand+0x50>
80100e30:	b9 68 00 00 00       	mov    $0x68,%ecx
80100e35:	31 c0                	xor    %eax,%eax
  int flag = 1;
80100e37:	be 01 00 00 00       	mov    $0x1,%esi
80100e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100e40:	83 f8 06             	cmp    $0x6,%eax
80100e43:	7f 04                	jg     80100e49 <checkHistoryCommand+0x39>
80100e45:	38 ca                	cmp    %cl,%dl
80100e47:	74 02                	je     80100e4b <checkHistoryCommand+0x3b>
      flag = 0;
80100e49:	31 f6                	xor    %esi,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
80100e4b:	83 c0 01             	add    $0x1,%eax
80100e4e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80100e52:	84 d2                	test   %dl,%dl
80100e54:	74 0c                	je     80100e62 <checkHistoryCommand+0x52>
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100e56:	0f b6 4c 05 f0       	movzbl -0x10(%ebp,%eax,1),%ecx
80100e5b:	eb e3                	jmp    80100e40 <checkHistoryCommand+0x30>
80100e5d:	8d 76 00             	lea    0x0(%esi),%esi
    flag = 0;
80100e60:	31 f6                	xor    %esi,%esi
}
80100e62:	83 c4 10             	add    $0x10,%esp
80100e65:	89 f0                	mov    %esi,%eax
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5d                   	pop    %ebp
80100e6a:	c3                   	ret    
80100e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e6f:	90                   	nop

80100e70 <print>:
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 04             	sub    $0x4,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = 0; message[i] != '\0'; i++)
80100e7a:	0f be 03             	movsbl (%ebx),%eax
80100e7d:	84 c0                	test   %al,%al
80100e7f:	74 26                	je     80100ea7 <print+0x37>
80100e81:	83 c3 01             	add    $0x1,%ebx
  if(panicked) {
80100e84:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
80100e8a:	85 d2                	test   %edx,%edx
80100e8c:	74 0a                	je     80100e98 <print+0x28>
80100e8e:	fa                   	cli    
    for(;;)
80100e8f:	eb fe                	jmp    80100e8f <print+0x1f>
80100e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e98:	e8 f3 f5 ff ff       	call   80100490 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100e9d:	0f be 03             	movsbl (%ebx),%eax
80100ea0:	83 c3 01             	add    $0x1,%ebx
80100ea3:	84 c0                	test   %al,%al
80100ea5:	75 dd                	jne    80100e84 <print+0x14>
}
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <doHistoryCommand>:
  if(panicked) {
80100eb0:	8b 0d 7c 0a 11 80    	mov    0x80110a7c,%ecx
80100eb6:	85 c9                	test   %ecx,%ecx
80100eb8:	74 06                	je     80100ec0 <doHistoryCommand+0x10>
80100eba:	fa                   	cli    
    for(;;)
80100ebb:	eb fe                	jmp    80100ebb <doHistoryCommand+0xb>
80100ebd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100ec0:	55                   	push   %ebp
80100ec1:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ec6:	89 e5                	mov    %esp,%ebp
80100ec8:	57                   	push   %edi
80100ec9:	56                   	push   %esi
80100eca:	53                   	push   %ebx
80100ecb:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80100ece:	83 ec 3c             	sub    $0x3c,%esp
80100ed1:	e8 ba f5 ff ff       	call   80100490 <consputc.part.0>
  char message[] = "here are the lastest commands : ";
80100ed6:	c7 45 c7 68 65 72 65 	movl   $0x65726568,-0x39(%ebp)
  for (int i = 0; message[i] != '\0'; i++)
80100edd:	b8 68 00 00 00       	mov    $0x68,%eax
  char message[] = "here are the lastest commands : ";
80100ee2:	c7 45 cb 20 61 72 65 	movl   $0x65726120,-0x35(%ebp)
80100ee9:	c7 45 cf 20 74 68 65 	movl   $0x65687420,-0x31(%ebp)
80100ef0:	c7 45 d3 20 6c 61 73 	movl   $0x73616c20,-0x2d(%ebp)
80100ef7:	c7 45 d7 74 65 73 74 	movl   $0x74736574,-0x29(%ebp)
80100efe:	c7 45 db 20 63 6f 6d 	movl   $0x6d6f6320,-0x25(%ebp)
80100f05:	c7 45 df 6d 61 6e 64 	movl   $0x646e616d,-0x21(%ebp)
80100f0c:	c7 45 e3 73 20 3a 20 	movl   $0x203a2073,-0x1d(%ebp)
80100f13:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  if(panicked) {
80100f17:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
80100f1d:	85 d2                	test   %edx,%edx
80100f1f:	74 07                	je     80100f28 <doHistoryCommand+0x78>
80100f21:	fa                   	cli    
    for(;;)
80100f22:	eb fe                	jmp    80100f22 <doHistoryCommand+0x72>
80100f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f28:	e8 63 f5 ff ff       	call   80100490 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100f2d:	0f be 03             	movsbl (%ebx),%eax
80100f30:	83 c3 01             	add    $0x1,%ebx
80100f33:	84 c0                	test   %al,%al
80100f35:	75 e0                	jne    80100f17 <doHistoryCommand+0x67>
  if(panicked) {
80100f37:	8b 1d 7c 0a 11 80    	mov    0x80110a7c,%ebx
80100f3d:	85 db                	test   %ebx,%ebx
80100f3f:	75 57                	jne    80100f98 <doHistoryCommand+0xe8>
80100f41:	b8 0a 00 00 00       	mov    $0xa,%eax
80100f46:	e8 45 f5 ff ff       	call   80100490 <consputc.part.0>
  for (i = 0; i < HISTORYSIZE && historyBuf[i][0] != '\0' ; i++)
80100f4b:	89 d8                	mov    %ebx,%eax
80100f4d:	c1 e0 07             	shl    $0x7,%eax
80100f50:	80 b8 c0 04 11 80 00 	cmpb   $0x0,-0x7feefb40(%eax)
80100f57:	0f 84 8b 00 00 00    	je     80100fe8 <doHistoryCommand+0x138>
80100f5d:	83 c3 01             	add    $0x1,%ebx
80100f60:	83 fb 0a             	cmp    $0xa,%ebx
80100f63:	75 e6                	jne    80100f4b <doHistoryCommand+0x9b>
  i--;
80100f65:	be 09 00 00 00       	mov    $0x9,%esi
80100f6a:	89 f3                	mov    %esi,%ebx
80100f6c:	c1 e3 07             	shl    $0x7,%ebx
80100f6f:	81 c3 c0 04 11 80    	add    $0x801104c0,%ebx
    printint(i+1,10 ,1);
80100f75:	8d 46 01             	lea    0x1(%esi),%eax
80100f78:	b9 01 00 00 00       	mov    $0x1,%ecx
80100f7d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100f82:	e8 69 f7 ff ff       	call   801006f0 <printint>
  if(panicked) {
80100f87:	8b 3d 7c 0a 11 80    	mov    0x80110a7c,%edi
80100f8d:	85 ff                	test   %edi,%edi
80100f8f:	74 0f                	je     80100fa0 <doHistoryCommand+0xf0>
80100f91:	fa                   	cli    
    for(;;)
80100f92:	eb fe                	jmp    80100f92 <doHistoryCommand+0xe2>
80100f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f98:	fa                   	cli    
80100f99:	eb fe                	jmp    80100f99 <doHistoryCommand+0xe9>
80100f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop
80100fa0:	b8 3a 00 00 00       	mov    $0x3a,%eax
80100fa5:	8d 7b 01             	lea    0x1(%ebx),%edi
80100fa8:	e8 e3 f4 ff ff       	call   80100490 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100fad:	0f be 03             	movsbl (%ebx),%eax
80100fb0:	84 c0                	test   %al,%al
80100fb2:	74 23                	je     80100fd7 <doHistoryCommand+0x127>
  if(panicked) {
80100fb4:	8b 15 7c 0a 11 80    	mov    0x80110a7c,%edx
80100fba:	85 d2                	test   %edx,%edx
80100fbc:	74 0a                	je     80100fc8 <doHistoryCommand+0x118>
80100fbe:	fa                   	cli    
    for(;;)
80100fbf:	eb fe                	jmp    80100fbf <doHistoryCommand+0x10f>
80100fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fc8:	e8 c3 f4 ff ff       	call   80100490 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100fcd:	0f be 07             	movsbl (%edi),%eax
80100fd0:	83 c7 01             	add    $0x1,%edi
80100fd3:	84 c0                	test   %al,%al
80100fd5:	75 dd                	jne    80100fb4 <doHistoryCommand+0x104>
  if(panicked) {
80100fd7:	8b 0d 7c 0a 11 80    	mov    0x80110a7c,%ecx
80100fdd:	85 c9                	test   %ecx,%ecx
80100fdf:	74 1a                	je     80100ffb <doHistoryCommand+0x14b>
80100fe1:	fa                   	cli    
    for(;;)
80100fe2:	eb fe                	jmp    80100fe2 <doHistoryCommand+0x132>
80100fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  i--;
80100fe8:	8d 73 ff             	lea    -0x1(%ebx),%esi
  for (i ; i >= 0; i--)
80100feb:	85 db                	test   %ebx,%ebx
80100fed:	0f 85 77 ff ff ff    	jne    80100f6a <doHistoryCommand+0xba>
}
80100ff3:	83 c4 3c             	add    $0x3c,%esp
80100ff6:	5b                   	pop    %ebx
80100ff7:	5e                   	pop    %esi
80100ff8:	5f                   	pop    %edi
80100ff9:	5d                   	pop    %ebp
80100ffa:	c3                   	ret    
80100ffb:	b8 0a 00 00 00       	mov    $0xa,%eax
  for (i ; i >= 0; i--)
80101000:	83 ee 01             	sub    $0x1,%esi
80101003:	83 c3 80             	add    $0xffffff80,%ebx
80101006:	e8 85 f4 ff ff       	call   80100490 <consputc.part.0>
8010100b:	83 fe ff             	cmp    $0xffffffff,%esi
8010100e:	0f 85 61 ff ff ff    	jne    80100f75 <doHistoryCommand+0xc5>
80101014:	eb dd                	jmp    80100ff3 <doHistoryCommand+0x143>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <controlNewCommand>:
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	56                   	push   %esi
80101024:	53                   	push   %ebx
80101025:	83 ec 1c             	sub    $0x1c,%esp
  char* lastCommand = getLastCommand(0);
80101028:	6a 00                	push   $0x0
8010102a:	e8 f1 f9 ff ff       	call   80100a20 <getLastCommand>
  char checkCommand[] = "history";
8010102f:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80101036:	83 c4 10             	add    $0x10,%esp
80101039:	0f b6 08             	movzbl (%eax),%ecx
  char checkCommand[] = "history";
8010103c:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80101043:	84 c9                	test   %cl,%cl
80101045:	74 49                	je     80101090 <controlNewCommand+0x70>
80101047:	bb 68 00 00 00       	mov    $0x68,%ebx
  int flag = 1;
8010104c:	be 01 00 00 00       	mov    $0x1,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
80101051:	31 d2                	xor    %edx,%edx
80101053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101057:	90                   	nop
    if (checkCommand[i] != lastCommand[i] || i > 6)
80101058:	38 d9                	cmp    %bl,%cl
8010105a:	75 05                	jne    80101061 <controlNewCommand+0x41>
8010105c:	83 fa 06             	cmp    $0x6,%edx
8010105f:	7e 02                	jle    80101063 <controlNewCommand+0x43>
      flag = 0;
80101061:	31 f6                	xor    %esi,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
80101063:	83 c2 01             	add    $0x1,%edx
80101066:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
8010106a:	84 c9                	test   %cl,%cl
8010106c:	74 0a                	je     80101078 <controlNewCommand+0x58>
    if (checkCommand[i] != lastCommand[i] || i > 6)
8010106e:	0f b6 5c 15 f0       	movzbl -0x10(%ebp,%edx,1),%ebx
80101073:	eb e3                	jmp    80101058 <controlNewCommand+0x38>
80101075:	8d 76 00             	lea    0x0(%esi),%esi
  if (checkHistoryCommand(lastCommand))
80101078:	85 f6                	test   %esi,%esi
8010107a:	74 14                	je     80101090 <controlNewCommand+0x70>
}
8010107c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010107f:	5b                   	pop    %ebx
80101080:	5e                   	pop    %esi
80101081:	5d                   	pop    %ebp
    doHistoryCommand();
80101082:	e9 29 fe ff ff       	jmp    80100eb0 <doHistoryCommand>
80101087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108e:	66 90                	xchg   %ax,%ax
}
80101090:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101093:	5b                   	pop    %ebx
80101094:	5e                   	pop    %esi
80101095:	5d                   	pop    %ebp
80101096:	c3                   	ret    
80101097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109e:	66 90                	xchg   %ax,%ax

801010a0 <consoleintr>:
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
  int c, doprocdump = 0;
801010a4:	31 ff                	xor    %edi,%edi
{
801010a6:	56                   	push   %esi
801010a7:	53                   	push   %ebx
801010a8:	83 ec 28             	sub    $0x28,%esp
801010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
801010ae:	68 40 0a 11 80       	push   $0x80110a40
{
801010b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
801010b6:	e8 35 3f 00 00       	call   80104ff0 <acquire>
  while((c = getc()) >= 0){
801010bb:	83 c4 10             	add    $0x10,%esp
801010be:	66 90                	xchg   %ax,%ax
801010c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010c3:	ff d0                	call   *%eax
801010c5:	89 c3                	mov    %eax,%ebx
801010c7:	85 c0                	test   %eax,%eax
801010c9:	0f 88 91 00 00 00    	js     80101160 <consoleintr+0xc0>
    switch(c){
801010cf:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
801010d5:	0f 84 2d 01 00 00    	je     80101208 <consoleintr+0x168>
801010db:	7f 5b                	jg     80101138 <consoleintr+0x98>
801010dd:	83 fb 15             	cmp    $0x15,%ebx
801010e0:	0f 84 e2 00 00 00    	je     801011c8 <consoleintr+0x128>
801010e6:	0f 8e 94 00 00 00    	jle    80101180 <consoleintr+0xe0>
801010ec:	83 fb 7f             	cmp    $0x7f,%ebx
801010ef:	0f 85 0b 02 00 00    	jne    80101300 <consoleintr+0x260>
        if(input.e != input.w && input.e - input.w > cap) {
801010f5:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801010fa:	8b 15 04 ff 10 80    	mov    0x8010ff04,%edx
80101100:	39 d0                	cmp    %edx,%eax
80101102:	74 bc                	je     801010c0 <consoleintr+0x20>
80101104:	89 c3                	mov    %eax,%ebx
80101106:	8b 0d 78 0a 11 80    	mov    0x80110a78,%ecx
8010110c:	29 d3                	sub    %edx,%ebx
8010110e:	39 cb                	cmp    %ecx,%ebx
80101110:	76 ae                	jbe    801010c0 <consoleintr+0x20>
          if (cap > 0)
80101112:	8d 58 ff             	lea    -0x1(%eax),%ebx
80101115:	85 c9                	test   %ecx,%ecx
80101117:	0f 8f be 02 00 00    	jg     801013db <consoleintr+0x33b>
  if(panicked) {
8010111d:	8b 0d 7c 0a 11 80    	mov    0x80110a7c,%ecx
          input.e--;
80101123:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
  if(panicked) {
80101129:	85 c9                	test   %ecx,%ecx
8010112b:	0f 84 9b 02 00 00    	je     801013cc <consoleintr+0x32c>
80101131:	fa                   	cli    
    for(;;)
80101132:	eb fe                	jmp    80101132 <consoleintr+0x92>
80101134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80101138:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
8010113e:	0f 84 e4 00 00 00    	je     80101228 <consoleintr+0x188>
80101144:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
8010114a:	75 54                	jne    801011a0 <consoleintr+0x100>
        goRight();
8010114c:	e8 2f f1 ff ff       	call   80100280 <goRight>
  while((c = getc()) >= 0){
80101151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101154:	ff d0                	call   *%eax
80101156:	89 c3                	mov    %eax,%ebx
80101158:	85 c0                	test   %eax,%eax
8010115a:	0f 89 6f ff ff ff    	jns    801010cf <consoleintr+0x2f>
  release(&cons.lock);
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 40 0a 11 80       	push   $0x80110a40
80101168:	e8 23 3e 00 00       	call   80104f90 <release>
  if(doprocdump) {
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 ff                	test   %edi,%edi
80101172:	0f 85 38 02 00 00    	jne    801013b0 <consoleintr+0x310>
}
80101178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117b:	5b                   	pop    %ebx
8010117c:	5e                   	pop    %esi
8010117d:	5f                   	pop    %edi
8010117e:	5d                   	pop    %ebp
8010117f:	c3                   	ret    
    switch(c){
80101180:	83 fb 08             	cmp    $0x8,%ebx
80101183:	0f 84 6c ff ff ff    	je     801010f5 <consoleintr+0x55>
80101189:	83 fb 10             	cmp    $0x10,%ebx
8010118c:	0f 85 66 01 00 00    	jne    801012f8 <consoleintr+0x258>
80101192:	bf 01 00 00 00       	mov    $0x1,%edi
80101197:	e9 24 ff ff ff       	jmp    801010c0 <consoleintr+0x20>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011a0:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
801011a6:	0f 85 54 01 00 00    	jne    80101300 <consoleintr+0x260>
      if (upDownKeyIndex > 0)
801011ac:	8b 15 a0 04 11 80    	mov    0x801104a0,%edx
801011b2:	85 d2                	test   %edx,%edx
801011b4:	0f 8e 06 ff ff ff    	jle    801010c0 <consoleintr+0x20>
        showNewCommand();
801011ba:	e8 11 fb ff ff       	call   80100cd0 <showNewCommand>
801011bf:	e9 fc fe ff ff       	jmp    801010c0 <consoleintr+0x20>
801011c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801011c8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801011cd:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801011d3:	0f 84 e7 fe ff ff    	je     801010c0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801011d9:	83 e8 01             	sub    $0x1,%eax
801011dc:	89 c2                	mov    %eax,%edx
801011de:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801011e1:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
801011e8:	0f 84 d2 fe ff ff    	je     801010c0 <consoleintr+0x20>
  if(panicked) {
801011ee:	8b 1d 7c 0a 11 80    	mov    0x80110a7c,%ebx
        input.e--;
801011f4:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked) {
801011f9:	85 db                	test   %ebx,%ebx
801011fb:	0f 84 d4 00 00 00    	je     801012d5 <consoleintr+0x235>
80101201:	fa                   	cli    
    for(;;)
80101202:	eb fe                	jmp    80101202 <consoleintr+0x162>
80101204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (upDownKeyIndex < historyCurrentSize)
80101208:	a1 a4 04 11 80       	mov    0x801104a4,%eax
8010120d:	39 05 a0 04 11 80    	cmp    %eax,0x801104a0
80101213:	0f 8d a7 fe ff ff    	jge    801010c0 <consoleintr+0x20>
        showPastCommand();
80101219:	e8 32 fb ff ff       	call   80100d50 <showPastCommand>
8010121e:	e9 9d fe ff ff       	jmp    801010c0 <consoleintr+0x20>
80101223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101227:	90                   	nop
      if ((input.e - cap) > input.w) 
80101228:	8b 0d 78 0a 11 80    	mov    0x80110a78,%ecx
8010122e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101233:	29 c8                	sub    %ecx,%eax
80101235:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010123b:	0f 86 7f fe ff ff    	jbe    801010c0 <consoleintr+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101241:	be d4 03 00 00       	mov    $0x3d4,%esi
80101246:	b8 0e 00 00 00       	mov    $0xe,%eax
8010124b:	89 f2                	mov    %esi,%edx
8010124d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010124e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101253:	89 da                	mov    %ebx,%edx
80101255:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101256:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101259:	89 f2                	mov    %esi,%edx
8010125b:	c1 e0 08             	shl    $0x8,%eax
8010125e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101261:	b8 0f 00 00 00       	mov    $0xf,%eax
80101266:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101267:	89 da                	mov    %ebx,%edx
80101269:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010126a:	0f b6 d8             	movzbl %al,%ebx
8010126d:	0b 5d e0             	or     -0x20(%ebp),%ebx
  int first_write_index = NUMCOL * ((int) pos / NUMCOL) + 2;
80101270:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80101275:	89 d8                	mov    %ebx,%eax
80101277:	f7 e2                	mul    %edx
80101279:	c1 ea 06             	shr    $0x6,%edx
8010127c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010127f:	c1 e0 04             	shl    $0x4,%eax
80101282:	83 c0 02             	add    $0x2,%eax
  if(pos >= first_write_index  && crt[pos - 2] != (('$' & 0xff) | 0x0700))
80101285:	39 c3                	cmp    %eax,%ebx
80101287:	0f 8c 2f 01 00 00    	jl     801013bc <consoleintr+0x31c>
8010128d:	66 81 bc 1b fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ebx,%ebx,1)
80101294:	80 24 07 
80101297:	0f 84 1f 01 00 00    	je     801013bc <consoleintr+0x31c>
    pos--;
8010129d:	83 eb 01             	sub    $0x1,%ebx
    cap++;
801012a0:	83 c1 01             	add    $0x1,%ecx
801012a3:	89 0d 78 0a 11 80    	mov    %ecx,0x80110a78
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801012a9:	be d4 03 00 00       	mov    $0x3d4,%esi
801012ae:	b8 0e 00 00 00       	mov    $0xe,%eax
801012b3:	89 f2                	mov    %esi,%edx
801012b5:	ee                   	out    %al,(%dx)
801012b6:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT + 1, pos >> 8);
801012bb:	89 d8                	mov    %ebx,%eax
801012bd:	c1 f8 08             	sar    $0x8,%eax
801012c0:	89 ca                	mov    %ecx,%edx
801012c2:	ee                   	out    %al,(%dx)
801012c3:	b8 0f 00 00 00       	mov    $0xf,%eax
801012c8:	89 f2                	mov    %esi,%edx
801012ca:	ee                   	out    %al,(%dx)
801012cb:	89 d8                	mov    %ebx,%eax
801012cd:	89 ca                	mov    %ecx,%edx
801012cf:	ee                   	out    %al,(%dx)
}
801012d0:	e9 eb fd ff ff       	jmp    801010c0 <consoleintr+0x20>
801012d5:	b8 00 01 00 00       	mov    $0x100,%eax
801012da:	e8 b1 f1 ff ff       	call   80100490 <consputc.part.0>
      while(input.e != input.w &&
801012df:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801012e4:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801012ea:	0f 85 e9 fe ff ff    	jne    801011d9 <consoleintr+0x139>
801012f0:	e9 cb fd ff ff       	jmp    801010c0 <consoleintr+0x20>
801012f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801012f8:	85 db                	test   %ebx,%ebx
801012fa:	0f 84 c0 fd ff ff    	je     801010c0 <consoleintr+0x20>
80101300:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101305:	89 c2                	mov    %eax,%edx
80101307:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010130d:	83 fa 7f             	cmp    $0x7f,%edx
80101310:	0f 87 aa fd ff ff    	ja     801010c0 <consoleintr+0x20>
        if (c=='\n'){
80101316:	83 fb 0d             	cmp    $0xd,%ebx
80101319:	0f 84 51 01 00 00    	je     80101470 <consoleintr+0x3d0>
8010131f:	83 fb 0a             	cmp    $0xa,%ebx
80101322:	0f 84 48 01 00 00    	je     80101470 <consoleintr+0x3d0>
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101328:	88 5d e0             	mov    %bl,-0x20(%ebp)
  for (int i = input.e; i > input.e - cap; i--)
8010132b:	8b 35 78 0a 11 80    	mov    0x80110a78,%esi
80101331:	89 c1                	mov    %eax,%ecx
80101333:	89 c2                	mov    %eax,%edx
80101335:	29 f1                	sub    %esi,%ecx
80101337:	39 c1                	cmp    %eax,%ecx
80101339:	73 48                	jae    80101383 <consoleintr+0x2e3>
8010133b:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010133e:	89 df                	mov    %ebx,%edi
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
80101340:	89 d0                	mov    %edx,%eax
80101342:	83 ea 01             	sub    $0x1,%edx
80101345:	89 d3                	mov    %edx,%ebx
80101347:	c1 fb 1f             	sar    $0x1f,%ebx
8010134a:	c1 eb 19             	shr    $0x19,%ebx
8010134d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101350:	83 e1 7f             	and    $0x7f,%ecx
80101353:	29 d9                	sub    %ebx,%ecx
80101355:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
8010135c:	89 c1                	mov    %eax,%ecx
8010135e:	c1 f9 1f             	sar    $0x1f,%ecx
80101361:	c1 e9 19             	shr    $0x19,%ecx
80101364:	01 c8                	add    %ecx,%eax
80101366:	83 e0 7f             	and    $0x7f,%eax
80101369:	29 c8                	sub    %ecx,%eax
8010136b:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101371:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101376:	89 c1                	mov    %eax,%ecx
80101378:	29 f1                	sub    %esi,%ecx
8010137a:	39 d1                	cmp    %edx,%ecx
8010137c:	72 c2                	jb     80101340 <consoleintr+0x2a0>
8010137e:	89 fb                	mov    %edi,%ebx
80101380:	8b 7d dc             	mov    -0x24(%ebp),%edi
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101383:	83 c0 01             	add    $0x1,%eax
80101386:	83 e1 7f             	and    $0x7f,%ecx
80101389:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
8010138e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80101392:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked) {
80101398:	a1 7c 0a 11 80       	mov    0x80110a7c,%eax
8010139d:	85 c0                	test   %eax,%eax
8010139f:	0f 84 8c 00 00 00    	je     80101431 <consoleintr+0x391>
  asm volatile("cli");
801013a5:	fa                   	cli    
    for(;;)
801013a6:	eb fe                	jmp    801013a6 <consoleintr+0x306>
801013a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013af:	90                   	nop
}
801013b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b3:	5b                   	pop    %ebx
801013b4:	5e                   	pop    %esi
801013b5:	5f                   	pop    %edi
801013b6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801013b7:	e9 74 38 00 00       	jmp    80104c30 <procdump>
  if (pos+1 >= first_write_index)
801013bc:	8d 53 01             	lea    0x1(%ebx),%edx
801013bf:	39 d0                	cmp    %edx,%eax
801013c1:	0f 8f e2 fe ff ff    	jg     801012a9 <consoleintr+0x209>
801013c7:	e9 d4 fe ff ff       	jmp    801012a0 <consoleintr+0x200>
801013cc:	b8 00 01 00 00       	mov    $0x100,%eax
801013d1:	e8 ba f0 ff ff       	call   80100490 <consputc.part.0>
801013d6:	e9 e5 fc ff ff       	jmp    801010c0 <consoleintr+0x20>
  for (int i = input.e - cap - 1; i < input.e; i++)
801013db:	89 da                	mov    %ebx,%edx
801013dd:	29 ca                	sub    %ecx,%edx
801013df:	39 d0                	cmp    %edx,%eax
801013e1:	76 42                	jbe    80101425 <consoleintr+0x385>
801013e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e7:	90                   	nop
    buf[(i) % INPUT_BUF] = buf[(i + 1) % INPUT_BUF]; // Shift elements to left
801013e8:	89 d0                	mov    %edx,%eax
801013ea:	83 c2 01             	add    $0x1,%edx
801013ed:	89 d3                	mov    %edx,%ebx
801013ef:	c1 fb 1f             	sar    $0x1f,%ebx
801013f2:	c1 eb 19             	shr    $0x19,%ebx
801013f5:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801013f8:	83 e1 7f             	and    $0x7f,%ecx
801013fb:	29 d9                	sub    %ebx,%ecx
801013fd:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
80101404:	89 c1                	mov    %eax,%ecx
80101406:	c1 f9 1f             	sar    $0x1f,%ecx
80101409:	c1 e9 19             	shr    $0x19,%ecx
8010140c:	01 c8                	add    %ecx,%eax
8010140e:	83 e0 7f             	and    $0x7f,%eax
80101411:	29 c8                	sub    %ecx,%eax
80101413:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e - cap - 1; i < input.e; i++)
80101419:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010141e:	39 d0                	cmp    %edx,%eax
80101420:	77 c6                	ja     801013e8 <consoleintr+0x348>
          input.e--;
80101422:	8d 58 ff             	lea    -0x1(%eax),%ebx
  input.buf[input.e] = ' ';
80101425:	c6 80 80 fe 10 80 20 	movb   $0x20,-0x7fef0180(%eax)
}
8010142c:	e9 ec fc ff ff       	jmp    8010111d <consoleintr+0x7d>
80101431:	89 d8                	mov    %ebx,%eax
80101433:	e8 58 f0 ff ff       	call   80100490 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101438:	83 fb 0a             	cmp    $0xa,%ebx
8010143b:	74 64                	je     801014a1 <consoleintr+0x401>
8010143d:	83 fb 04             	cmp    $0x4,%ebx
80101440:	74 5f                	je     801014a1 <consoleintr+0x401>
80101442:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80101447:	83 e8 80             	sub    $0xffffff80,%eax
8010144a:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80101450:	0f 85 6a fc ff ff    	jne    801010c0 <consoleintr+0x20>
          wakeup(&input.r);
80101456:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101459:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
8010145e:	68 00 ff 10 80       	push   $0x8010ff00
80101463:	e8 e8 36 00 00       	call   80104b50 <wakeup>
80101468:	83 c4 10             	add    $0x10,%esp
8010146b:	e9 50 fc ff ff       	jmp    801010c0 <consoleintr+0x20>
          cap = 0;
80101470:	c7 05 78 0a 11 80 00 	movl   $0x0,0x80110a78
80101477:	00 00 00 
  for (int i = input.e; i > input.e - cap; i--)
8010147a:	bb 0a 00 00 00       	mov    $0xa,%ebx
          addNewCommandToHistory();
8010147f:	e8 5c f6 ff ff       	call   80100ae0 <addNewCommandToHistory>
          controlNewCommand();
80101484:	e8 97 fb ff ff       	call   80101020 <controlNewCommand>
  for (int i = input.e; i > input.e - cap; i--)
80101489:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
8010148d:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          upDownKeyIndex = 0;
80101492:	c7 05 a0 04 11 80 00 	movl   $0x0,0x801104a0
80101499:	00 00 00 
8010149c:	e9 8a fe ff ff       	jmp    8010132b <consoleintr+0x28b>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801014a1:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801014a6:	eb ae                	jmp    80101456 <consoleintr+0x3b6>
801014a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014af:	90                   	nop

801014b0 <consoleinit>:

void
consoleinit(void)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801014b6:	68 48 7c 10 80       	push   $0x80107c48
801014bb:	68 40 0a 11 80       	push   $0x80110a40
801014c0:	e8 5b 39 00 00       	call   80104e20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801014c5:	58                   	pop    %eax
801014c6:	5a                   	pop    %edx
801014c7:	6a 00                	push   $0x0
801014c9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801014cb:	c7 05 2c 14 11 80 80 	movl   $0x80100680,0x8011142c
801014d2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801014d5:	c7 05 28 14 11 80 10 	movl   $0x80100310,0x80111428
801014dc:	03 10 80 
  cons.locking = 1;
801014df:	c7 05 74 0a 11 80 01 	movl   $0x1,0x80110a74
801014e6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801014e9:	e8 e2 19 00 00       	call   80102ed0 <ioapicenable>
801014ee:	83 c4 10             	add    $0x10,%esp
801014f1:	c9                   	leave  
801014f2:	c3                   	ret    
801014f3:	66 90                	xchg   %ax,%ax
801014f5:	66 90                	xchg   %ax,%ax
801014f7:	66 90                	xchg   %ax,%ax
801014f9:	66 90                	xchg   %ax,%ax
801014fb:	66 90                	xchg   %ax,%ax
801014fd:	66 90                	xchg   %ax,%ax
801014ff:	90                   	nop

80101500 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010150c:	e8 af 2e 00 00       	call   801043c0 <myproc>
80101511:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101517:	e8 94 22 00 00       	call   801037b0 <begin_op>

  if((ip = namei(path)) == 0){
8010151c:	83 ec 0c             	sub    $0xc,%esp
8010151f:	ff 75 08             	push   0x8(%ebp)
80101522:	e8 c9 15 00 00       	call   80102af0 <namei>
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	85 c0                	test   %eax,%eax
8010152c:	0f 84 02 03 00 00    	je     80101834 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	89 c3                	mov    %eax,%ebx
80101537:	50                   	push   %eax
80101538:	e8 93 0c 00 00       	call   801021d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010153d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101543:	6a 34                	push   $0x34
80101545:	6a 00                	push   $0x0
80101547:	50                   	push   %eax
80101548:	53                   	push   %ebx
80101549:	e8 92 0f 00 00       	call   801024e0 <readi>
8010154e:	83 c4 20             	add    $0x20,%esp
80101551:	83 f8 34             	cmp    $0x34,%eax
80101554:	74 22                	je     80101578 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	53                   	push   %ebx
8010155a:	e8 01 0f 00 00       	call   80102460 <iunlockput>
    end_op();
8010155f:	e8 bc 22 00 00       	call   80103820 <end_op>
80101564:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010156c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5f                   	pop    %edi
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
80101574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101578:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010157f:	45 4c 46 
80101582:	75 d2                	jne    80101556 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101584:	e8 07 63 00 00       	call   80107890 <setupkvm>
80101589:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010158f:	85 c0                	test   %eax,%eax
80101591:	74 c3                	je     80101556 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101593:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
8010159a:	00 
8010159b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801015a1:	0f 84 ac 02 00 00    	je     80101853 <exec+0x353>
  sz = 0;
801015a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801015ae:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801015b1:	31 ff                	xor    %edi,%edi
801015b3:	e9 8e 00 00 00       	jmp    80101646 <exec+0x146>
801015b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015bf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
801015c0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801015c7:	75 6c                	jne    80101635 <exec+0x135>
    if(ph.memsz < ph.filesz)
801015c9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801015cf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801015d5:	0f 82 87 00 00 00    	jb     80101662 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801015db:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801015e1:	72 7f                	jb     80101662 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801015e3:	83 ec 04             	sub    $0x4,%esp
801015e6:	50                   	push   %eax
801015e7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801015ed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801015f3:	e8 b8 60 00 00       	call   801076b0 <allocuvm>
801015f8:	83 c4 10             	add    $0x10,%esp
801015fb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101601:	85 c0                	test   %eax,%eax
80101603:	74 5d                	je     80101662 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101605:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010160b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101610:	75 50                	jne    80101662 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101612:	83 ec 0c             	sub    $0xc,%esp
80101615:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010161b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101621:	53                   	push   %ebx
80101622:	50                   	push   %eax
80101623:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101629:	e8 92 5f 00 00       	call   801075c0 <loaduvm>
8010162e:	83 c4 20             	add    $0x20,%esp
80101631:	85 c0                	test   %eax,%eax
80101633:	78 2d                	js     80101662 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101635:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010163c:	83 c7 01             	add    $0x1,%edi
8010163f:	83 c6 20             	add    $0x20,%esi
80101642:	39 f8                	cmp    %edi,%eax
80101644:	7e 3a                	jle    80101680 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101646:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010164c:	6a 20                	push   $0x20
8010164e:	56                   	push   %esi
8010164f:	50                   	push   %eax
80101650:	53                   	push   %ebx
80101651:	e8 8a 0e 00 00       	call   801024e0 <readi>
80101656:	83 c4 10             	add    $0x10,%esp
80101659:	83 f8 20             	cmp    $0x20,%eax
8010165c:	0f 84 5e ff ff ff    	je     801015c0 <exec+0xc0>
    freevm(pgdir);
80101662:	83 ec 0c             	sub    $0xc,%esp
80101665:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010166b:	e8 a0 61 00 00       	call   80107810 <freevm>
  if(ip){
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	e9 de fe ff ff       	jmp    80101556 <exec+0x56>
80101678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167f:	90                   	nop
  sz = PGROUNDUP(sz);
80101680:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101686:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010168c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101692:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101698:	83 ec 0c             	sub    $0xc,%esp
8010169b:	53                   	push   %ebx
8010169c:	e8 bf 0d 00 00       	call   80102460 <iunlockput>
  end_op();
801016a1:	e8 7a 21 00 00       	call   80103820 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801016a6:	83 c4 0c             	add    $0xc,%esp
801016a9:	56                   	push   %esi
801016aa:	57                   	push   %edi
801016ab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801016b1:	57                   	push   %edi
801016b2:	e8 f9 5f 00 00       	call   801076b0 <allocuvm>
801016b7:	83 c4 10             	add    $0x10,%esp
801016ba:	89 c6                	mov    %eax,%esi
801016bc:	85 c0                	test   %eax,%eax
801016be:	0f 84 94 00 00 00    	je     80101758 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801016c4:	83 ec 08             	sub    $0x8,%esp
801016c7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801016cd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801016cf:	50                   	push   %eax
801016d0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801016d1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801016d3:	e8 58 62 00 00       	call   80107930 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801016db:	83 c4 10             	add    $0x10,%esp
801016de:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801016e4:	8b 00                	mov    (%eax),%eax
801016e6:	85 c0                	test   %eax,%eax
801016e8:	0f 84 8b 00 00 00    	je     80101779 <exec+0x279>
801016ee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801016f4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801016fa:	eb 23                	jmp    8010171f <exec+0x21f>
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101700:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101703:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010170a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010170d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101713:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101716:	85 c0                	test   %eax,%eax
80101718:	74 59                	je     80101773 <exec+0x273>
    if(argc >= MAXARG)
8010171a:	83 ff 20             	cmp    $0x20,%edi
8010171d:	74 39                	je     80101758 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010171f:	83 ec 0c             	sub    $0xc,%esp
80101722:	50                   	push   %eax
80101723:	e8 88 3b 00 00       	call   801052b0 <strlen>
80101728:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010172a:	58                   	pop    %eax
8010172b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010172e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101731:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101734:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101737:	e8 74 3b 00 00       	call   801052b0 <strlen>
8010173c:	83 c0 01             	add    $0x1,%eax
8010173f:	50                   	push   %eax
80101740:	8b 45 0c             	mov    0xc(%ebp),%eax
80101743:	ff 34 b8             	push   (%eax,%edi,4)
80101746:	53                   	push   %ebx
80101747:	56                   	push   %esi
80101748:	e8 b3 63 00 00       	call   80107b00 <copyout>
8010174d:	83 c4 20             	add    $0x20,%esp
80101750:	85 c0                	test   %eax,%eax
80101752:	79 ac                	jns    80101700 <exec+0x200>
80101754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101758:	83 ec 0c             	sub    $0xc,%esp
8010175b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101761:	e8 aa 60 00 00       	call   80107810 <freevm>
80101766:	83 c4 10             	add    $0x10,%esp
  return -1;
80101769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010176e:	e9 f9 fd ff ff       	jmp    8010156c <exec+0x6c>
80101773:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101779:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101780:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101782:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101789:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010178d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010178f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101792:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101798:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010179a:	50                   	push   %eax
8010179b:	52                   	push   %edx
8010179c:	53                   	push   %ebx
8010179d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801017a3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801017aa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801017ad:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801017b3:	e8 48 63 00 00       	call   80107b00 <copyout>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	78 99                	js     80101758 <exec+0x258>
  for(last=s=path; *s; s++)
801017bf:	8b 45 08             	mov    0x8(%ebp),%eax
801017c2:	8b 55 08             	mov    0x8(%ebp),%edx
801017c5:	0f b6 00             	movzbl (%eax),%eax
801017c8:	84 c0                	test   %al,%al
801017ca:	74 13                	je     801017df <exec+0x2df>
801017cc:	89 d1                	mov    %edx,%ecx
801017ce:	66 90                	xchg   %ax,%ax
      last = s+1;
801017d0:	83 c1 01             	add    $0x1,%ecx
801017d3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801017d5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
801017d8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801017db:	84 c0                	test   %al,%al
801017dd:	75 f1                	jne    801017d0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801017df:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801017e5:	83 ec 04             	sub    $0x4,%esp
801017e8:	6a 10                	push   $0x10
801017ea:	89 f8                	mov    %edi,%eax
801017ec:	52                   	push   %edx
801017ed:	83 c0 6c             	add    $0x6c,%eax
801017f0:	50                   	push   %eax
801017f1:	e8 7a 3a 00 00       	call   80105270 <safestrcpy>
  curproc->pgdir = pgdir;
801017f6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801017fc:	89 f8                	mov    %edi,%eax
801017fe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101801:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101803:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101806:	89 c1                	mov    %eax,%ecx
80101808:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010180e:	8b 40 18             	mov    0x18(%eax),%eax
80101811:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101814:	8b 41 18             	mov    0x18(%ecx),%eax
80101817:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010181a:	89 0c 24             	mov    %ecx,(%esp)
8010181d:	e8 0e 5c 00 00       	call   80107430 <switchuvm>
  freevm(oldpgdir);
80101822:	89 3c 24             	mov    %edi,(%esp)
80101825:	e8 e6 5f 00 00       	call   80107810 <freevm>
  return 0;
8010182a:	83 c4 10             	add    $0x10,%esp
8010182d:	31 c0                	xor    %eax,%eax
8010182f:	e9 38 fd ff ff       	jmp    8010156c <exec+0x6c>
    end_op();
80101834:	e8 e7 1f 00 00       	call   80103820 <end_op>
    cprintf("exec: fail\n");
80101839:	83 ec 0c             	sub    $0xc,%esp
8010183c:	68 61 7c 10 80       	push   $0x80107c61
80101841:	e8 4a ef ff ff       	call   80100790 <cprintf>
    return -1;
80101846:	83 c4 10             	add    $0x10,%esp
80101849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010184e:	e9 19 fd ff ff       	jmp    8010156c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101853:	be 00 20 00 00       	mov    $0x2000,%esi
80101858:	31 ff                	xor    %edi,%edi
8010185a:	e9 39 fe ff ff       	jmp    80101698 <exec+0x198>
8010185f:	90                   	nop

80101860 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101866:	68 6d 7c 10 80       	push   $0x80107c6d
8010186b:	68 80 0a 11 80       	push   $0x80110a80
80101870:	e8 ab 35 00 00       	call   80104e20 <initlock>
}
80101875:	83 c4 10             	add    $0x10,%esp
80101878:	c9                   	leave  
80101879:	c3                   	ret    
8010187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101880 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101884:	bb b4 0a 11 80       	mov    $0x80110ab4,%ebx
{
80101889:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010188c:	68 80 0a 11 80       	push   $0x80110a80
80101891:	e8 5a 37 00 00       	call   80104ff0 <acquire>
80101896:	83 c4 10             	add    $0x10,%esp
80101899:	eb 10                	jmp    801018ab <filealloc+0x2b>
8010189b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010189f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801018a0:	83 c3 18             	add    $0x18,%ebx
801018a3:	81 fb 14 14 11 80    	cmp    $0x80111414,%ebx
801018a9:	74 25                	je     801018d0 <filealloc+0x50>
    if(f->ref == 0){
801018ab:	8b 43 04             	mov    0x4(%ebx),%eax
801018ae:	85 c0                	test   %eax,%eax
801018b0:	75 ee                	jne    801018a0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801018b2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801018b5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801018bc:	68 80 0a 11 80       	push   $0x80110a80
801018c1:	e8 ca 36 00 00       	call   80104f90 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801018c6:	89 d8                	mov    %ebx,%eax
      return f;
801018c8:	83 c4 10             	add    $0x10,%esp
}
801018cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018ce:	c9                   	leave  
801018cf:	c3                   	ret    
  release(&ftable.lock);
801018d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801018d3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801018d5:	68 80 0a 11 80       	push   $0x80110a80
801018da:	e8 b1 36 00 00       	call   80104f90 <release>
}
801018df:	89 d8                	mov    %ebx,%eax
  return 0;
801018e1:	83 c4 10             	add    $0x10,%esp
}
801018e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018e7:	c9                   	leave  
801018e8:	c3                   	ret    
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801018fa:	68 80 0a 11 80       	push   $0x80110a80
801018ff:	e8 ec 36 00 00       	call   80104ff0 <acquire>
  if(f->ref < 1)
80101904:	8b 43 04             	mov    0x4(%ebx),%eax
80101907:	83 c4 10             	add    $0x10,%esp
8010190a:	85 c0                	test   %eax,%eax
8010190c:	7e 1a                	jle    80101928 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010190e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101911:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101914:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101917:	68 80 0a 11 80       	push   $0x80110a80
8010191c:	e8 6f 36 00 00       	call   80104f90 <release>
  return f;
}
80101921:	89 d8                	mov    %ebx,%eax
80101923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101926:	c9                   	leave  
80101927:	c3                   	ret    
    panic("filedup");
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 74 7c 10 80       	push   $0x80107c74
80101930:	e8 db ea ff ff       	call   80100410 <panic>
80101935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 28             	sub    $0x28,%esp
80101949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010194c:	68 80 0a 11 80       	push   $0x80110a80
80101951:	e8 9a 36 00 00       	call   80104ff0 <acquire>
  if(f->ref < 1)
80101956:	8b 53 04             	mov    0x4(%ebx),%edx
80101959:	83 c4 10             	add    $0x10,%esp
8010195c:	85 d2                	test   %edx,%edx
8010195e:	0f 8e a5 00 00 00    	jle    80101a09 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101964:	83 ea 01             	sub    $0x1,%edx
80101967:	89 53 04             	mov    %edx,0x4(%ebx)
8010196a:	75 44                	jne    801019b0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010196c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101970:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101973:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101975:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010197b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010197e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101981:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101984:	68 80 0a 11 80       	push   $0x80110a80
  ff = *f;
80101989:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010198c:	e8 ff 35 00 00       	call   80104f90 <release>

  if(ff.type == FD_PIPE)
80101991:	83 c4 10             	add    $0x10,%esp
80101994:	83 ff 01             	cmp    $0x1,%edi
80101997:	74 57                	je     801019f0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101999:	83 ff 02             	cmp    $0x2,%edi
8010199c:	74 2a                	je     801019c8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010199e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a1:	5b                   	pop    %ebx
801019a2:	5e                   	pop    %esi
801019a3:	5f                   	pop    %edi
801019a4:	5d                   	pop    %ebp
801019a5:	c3                   	ret    
801019a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801019b0:	c7 45 08 80 0a 11 80 	movl   $0x80110a80,0x8(%ebp)
}
801019b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ba:	5b                   	pop    %ebx
801019bb:	5e                   	pop    %esi
801019bc:	5f                   	pop    %edi
801019bd:	5d                   	pop    %ebp
    release(&ftable.lock);
801019be:	e9 cd 35 00 00       	jmp    80104f90 <release>
801019c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019c7:	90                   	nop
    begin_op();
801019c8:	e8 e3 1d 00 00       	call   801037b0 <begin_op>
    iput(ff.ip);
801019cd:	83 ec 0c             	sub    $0xc,%esp
801019d0:	ff 75 e0             	push   -0x20(%ebp)
801019d3:	e8 28 09 00 00       	call   80102300 <iput>
    end_op();
801019d8:	83 c4 10             	add    $0x10,%esp
}
801019db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019de:	5b                   	pop    %ebx
801019df:	5e                   	pop    %esi
801019e0:	5f                   	pop    %edi
801019e1:	5d                   	pop    %ebp
    end_op();
801019e2:	e9 39 1e 00 00       	jmp    80103820 <end_op>
801019e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801019f0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801019f4:	83 ec 08             	sub    $0x8,%esp
801019f7:	53                   	push   %ebx
801019f8:	56                   	push   %esi
801019f9:	e8 82 25 00 00       	call   80103f80 <pipeclose>
801019fe:	83 c4 10             	add    $0x10,%esp
}
80101a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a04:	5b                   	pop    %ebx
80101a05:	5e                   	pop    %esi
80101a06:	5f                   	pop    %edi
80101a07:	5d                   	pop    %ebp
80101a08:	c3                   	ret    
    panic("fileclose");
80101a09:	83 ec 0c             	sub    $0xc,%esp
80101a0c:	68 7c 7c 10 80       	push   $0x80107c7c
80101a11:	e8 fa e9 ff ff       	call   80100410 <panic>
80101a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi

80101a20 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	53                   	push   %ebx
80101a24:	83 ec 04             	sub    $0x4,%esp
80101a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80101a2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80101a2d:	75 31                	jne    80101a60 <filestat+0x40>
    ilock(f->ip);
80101a2f:	83 ec 0c             	sub    $0xc,%esp
80101a32:	ff 73 10             	push   0x10(%ebx)
80101a35:	e8 96 07 00 00       	call   801021d0 <ilock>
    stati(f->ip, st);
80101a3a:	58                   	pop    %eax
80101a3b:	5a                   	pop    %edx
80101a3c:	ff 75 0c             	push   0xc(%ebp)
80101a3f:	ff 73 10             	push   0x10(%ebx)
80101a42:	e8 69 0a 00 00       	call   801024b0 <stati>
    iunlock(f->ip);
80101a47:	59                   	pop    %ecx
80101a48:	ff 73 10             	push   0x10(%ebx)
80101a4b:	e8 60 08 00 00       	call   801022b0 <iunlock>
    return 0;
  }
  return -1;
}
80101a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101a53:	83 c4 10             	add    $0x10,%esp
80101a56:	31 c0                	xor    %eax,%eax
}
80101a58:	c9                   	leave  
80101a59:	c3                   	ret    
80101a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101a68:	c9                   	leave  
80101a69:	c3                   	ret    
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 0c             	sub    $0xc,%esp
80101a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101a82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101a86:	74 60                	je     80101ae8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101a88:	8b 03                	mov    (%ebx),%eax
80101a8a:	83 f8 01             	cmp    $0x1,%eax
80101a8d:	74 41                	je     80101ad0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101a8f:	83 f8 02             	cmp    $0x2,%eax
80101a92:	75 5b                	jne    80101aef <fileread+0x7f>
    ilock(f->ip);
80101a94:	83 ec 0c             	sub    $0xc,%esp
80101a97:	ff 73 10             	push   0x10(%ebx)
80101a9a:	e8 31 07 00 00       	call   801021d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101a9f:	57                   	push   %edi
80101aa0:	ff 73 14             	push   0x14(%ebx)
80101aa3:	56                   	push   %esi
80101aa4:	ff 73 10             	push   0x10(%ebx)
80101aa7:	e8 34 0a 00 00       	call   801024e0 <readi>
80101aac:	83 c4 20             	add    $0x20,%esp
80101aaf:	89 c6                	mov    %eax,%esi
80101ab1:	85 c0                	test   %eax,%eax
80101ab3:	7e 03                	jle    80101ab8 <fileread+0x48>
      f->off += r;
80101ab5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101ab8:	83 ec 0c             	sub    $0xc,%esp
80101abb:	ff 73 10             	push   0x10(%ebx)
80101abe:	e8 ed 07 00 00       	call   801022b0 <iunlock>
    return r;
80101ac3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac9:	89 f0                	mov    %esi,%eax
80101acb:	5b                   	pop    %ebx
80101acc:	5e                   	pop    %esi
80101acd:	5f                   	pop    %edi
80101ace:	5d                   	pop    %ebp
80101acf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101ad0:	8b 43 0c             	mov    0xc(%ebx),%eax
80101ad3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ad9:	5b                   	pop    %ebx
80101ada:	5e                   	pop    %esi
80101adb:	5f                   	pop    %edi
80101adc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101add:	e9 3e 26 00 00       	jmp    80104120 <piperead>
80101ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101ae8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101aed:	eb d7                	jmp    80101ac6 <fileread+0x56>
  panic("fileread");
80101aef:	83 ec 0c             	sub    $0xc,%esp
80101af2:	68 86 7c 10 80       	push   $0x80107c86
80101af7:	e8 14 e9 ff ff       	call   80100410 <panic>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b00 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101b12:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101b15:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101b19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101b1c:	0f 84 bd 00 00 00    	je     80101bdf <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101b22:	8b 03                	mov    (%ebx),%eax
80101b24:	83 f8 01             	cmp    $0x1,%eax
80101b27:	0f 84 bf 00 00 00    	je     80101bec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101b2d:	83 f8 02             	cmp    $0x2,%eax
80101b30:	0f 85 c8 00 00 00    	jne    80101bfe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101b39:	31 f6                	xor    %esi,%esi
    while(i < n){
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	7f 30                	jg     80101b6f <filewrite+0x6f>
80101b3f:	e9 94 00 00 00       	jmp    80101bd8 <filewrite+0xd8>
80101b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101b48:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
80101b4e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101b51:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101b54:	e8 57 07 00 00       	call   801022b0 <iunlock>
      end_op();
80101b59:	e8 c2 1c 00 00       	call   80103820 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b61:	83 c4 10             	add    $0x10,%esp
80101b64:	39 c7                	cmp    %eax,%edi
80101b66:	75 5c                	jne    80101bc4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101b68:	01 fe                	add    %edi,%esi
    while(i < n){
80101b6a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101b6d:	7e 69                	jle    80101bd8 <filewrite+0xd8>
      int n1 = n - i;
80101b6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b72:	b8 00 06 00 00       	mov    $0x600,%eax
80101b77:	29 f7                	sub    %esi,%edi
80101b79:	39 c7                	cmp    %eax,%edi
80101b7b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80101b7e:	e8 2d 1c 00 00       	call   801037b0 <begin_op>
      ilock(f->ip);
80101b83:	83 ec 0c             	sub    $0xc,%esp
80101b86:	ff 73 10             	push   0x10(%ebx)
80101b89:	e8 42 06 00 00       	call   801021d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101b8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b91:	57                   	push   %edi
80101b92:	ff 73 14             	push   0x14(%ebx)
80101b95:	01 f0                	add    %esi,%eax
80101b97:	50                   	push   %eax
80101b98:	ff 73 10             	push   0x10(%ebx)
80101b9b:	e8 40 0a 00 00       	call   801025e0 <writei>
80101ba0:	83 c4 20             	add    $0x20,%esp
80101ba3:	85 c0                	test   %eax,%eax
80101ba5:	7f a1                	jg     80101b48 <filewrite+0x48>
      iunlock(f->ip);
80101ba7:	83 ec 0c             	sub    $0xc,%esp
80101baa:	ff 73 10             	push   0x10(%ebx)
80101bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101bb0:	e8 fb 06 00 00       	call   801022b0 <iunlock>
      end_op();
80101bb5:	e8 66 1c 00 00       	call   80103820 <end_op>
      if(r < 0)
80101bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	85 c0                	test   %eax,%eax
80101bc2:	75 1b                	jne    80101bdf <filewrite+0xdf>
        panic("short filewrite");
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	68 8f 7c 10 80       	push   $0x80107c8f
80101bcc:	e8 3f e8 ff ff       	call   80100410 <panic>
80101bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101bd8:	89 f0                	mov    %esi,%eax
80101bda:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80101bdd:	74 05                	je     80101be4 <filewrite+0xe4>
80101bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5f                   	pop    %edi
80101bea:	5d                   	pop    %ebp
80101beb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101bec:	8b 43 0c             	mov    0xc(%ebx),%eax
80101bef:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf5:	5b                   	pop    %ebx
80101bf6:	5e                   	pop    %esi
80101bf7:	5f                   	pop    %edi
80101bf8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101bf9:	e9 22 24 00 00       	jmp    80104020 <pipewrite>
  panic("filewrite");
80101bfe:	83 ec 0c             	sub    $0xc,%esp
80101c01:	68 95 7c 10 80       	push   $0x80107c95
80101c06:	e8 05 e8 ff ff       	call   80100410 <panic>
80101c0b:	66 90                	xchg   %ax,%ax
80101c0d:	66 90                	xchg   %ax,%ax
80101c0f:	90                   	nop

80101c10 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101c10:	55                   	push   %ebp
80101c11:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101c13:	89 d0                	mov    %edx,%eax
80101c15:	c1 e8 0c             	shr    $0xc,%eax
80101c18:	03 05 ec 30 11 80    	add    0x801130ec,%eax
{
80101c1e:	89 e5                	mov    %esp,%ebp
80101c20:	56                   	push   %esi
80101c21:	53                   	push   %ebx
80101c22:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101c24:	83 ec 08             	sub    $0x8,%esp
80101c27:	50                   	push   %eax
80101c28:	51                   	push   %ecx
80101c29:	e8 a2 e4 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101c2e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101c30:	c1 fb 03             	sar    $0x3,%ebx
80101c33:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101c36:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101c38:	83 e1 07             	and    $0x7,%ecx
80101c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101c40:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101c46:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101c48:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101c4d:	85 c1                	test   %eax,%ecx
80101c4f:	74 23                	je     80101c74 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101c51:	f7 d0                	not    %eax
  log_write(bp);
80101c53:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101c56:	21 c8                	and    %ecx,%eax
80101c58:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101c5c:	56                   	push   %esi
80101c5d:	e8 2e 1d 00 00       	call   80103990 <log_write>
  brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
}
80101c6a:	83 c4 10             	add    $0x10,%esp
80101c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c70:	5b                   	pop    %ebx
80101c71:	5e                   	pop    %esi
80101c72:	5d                   	pop    %ebp
80101c73:	c3                   	ret    
    panic("freeing free block");
80101c74:	83 ec 0c             	sub    $0xc,%esp
80101c77:	68 9f 7c 10 80       	push   $0x80107c9f
80101c7c:	e8 8f e7 ff ff       	call   80100410 <panic>
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8f:	90                   	nop

80101c90 <balloc>:
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101c99:	8b 0d d4 30 11 80    	mov    0x801130d4,%ecx
{
80101c9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101ca2:	85 c9                	test   %ecx,%ecx
80101ca4:	0f 84 87 00 00 00    	je     80101d31 <balloc+0xa1>
80101caa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101cb1:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101cb4:	83 ec 08             	sub    $0x8,%esp
80101cb7:	89 f0                	mov    %esi,%eax
80101cb9:	c1 f8 0c             	sar    $0xc,%eax
80101cbc:	03 05 ec 30 11 80    	add    0x801130ec,%eax
80101cc2:	50                   	push   %eax
80101cc3:	ff 75 d8             	push   -0x28(%ebp)
80101cc6:	e8 05 e4 ff ff       	call   801000d0 <bread>
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101cd1:	a1 d4 30 11 80       	mov    0x801130d4,%eax
80101cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101cd9:	31 c0                	xor    %eax,%eax
80101cdb:	eb 2f                	jmp    80101d0c <balloc+0x7c>
80101cdd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101ce0:	89 c1                	mov    %eax,%ecx
80101ce2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101ce7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101cea:	83 e1 07             	and    $0x7,%ecx
80101ced:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101cef:	89 c1                	mov    %eax,%ecx
80101cf1:	c1 f9 03             	sar    $0x3,%ecx
80101cf4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101cf9:	89 fa                	mov    %edi,%edx
80101cfb:	85 df                	test   %ebx,%edi
80101cfd:	74 41                	je     80101d40 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101cff:	83 c0 01             	add    $0x1,%eax
80101d02:	83 c6 01             	add    $0x1,%esi
80101d05:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101d0a:	74 05                	je     80101d11 <balloc+0x81>
80101d0c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101d0f:	77 cf                	ja     80101ce0 <balloc+0x50>
    brelse(bp);
80101d11:	83 ec 0c             	sub    $0xc,%esp
80101d14:	ff 75 e4             	push   -0x1c(%ebp)
80101d17:	e8 d4 e4 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101d1c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101d23:	83 c4 10             	add    $0x10,%esp
80101d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101d29:	39 05 d4 30 11 80    	cmp    %eax,0x801130d4
80101d2f:	77 80                	ja     80101cb1 <balloc+0x21>
  panic("balloc: out of blocks");
80101d31:	83 ec 0c             	sub    $0xc,%esp
80101d34:	68 b2 7c 10 80       	push   $0x80107cb2
80101d39:	e8 d2 e6 ff ff       	call   80100410 <panic>
80101d3e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101d40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101d43:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101d46:	09 da                	or     %ebx,%edx
80101d48:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101d4c:	57                   	push   %edi
80101d4d:	e8 3e 1c 00 00       	call   80103990 <log_write>
        brelse(bp);
80101d52:	89 3c 24             	mov    %edi,(%esp)
80101d55:	e8 96 e4 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101d5a:	58                   	pop    %eax
80101d5b:	5a                   	pop    %edx
80101d5c:	56                   	push   %esi
80101d5d:	ff 75 d8             	push   -0x28(%ebp)
80101d60:	e8 6b e3 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101d65:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101d68:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101d6a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101d6d:	68 00 02 00 00       	push   $0x200
80101d72:	6a 00                	push   $0x0
80101d74:	50                   	push   %eax
80101d75:	e8 36 33 00 00       	call   801050b0 <memset>
  log_write(bp);
80101d7a:	89 1c 24             	mov    %ebx,(%esp)
80101d7d:	e8 0e 1c 00 00       	call   80103990 <log_write>
  brelse(bp);
80101d82:	89 1c 24             	mov    %ebx,(%esp)
80101d85:	e8 66 e4 ff ff       	call   801001f0 <brelse>
}
80101d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8d:	89 f0                	mov    %esi,%eax
80101d8f:	5b                   	pop    %ebx
80101d90:	5e                   	pop    %esi
80101d91:	5f                   	pop    %edi
80101d92:	5d                   	pop    %ebp
80101d93:	c3                   	ret    
80101d94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d9f:	90                   	nop

80101da0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	89 c7                	mov    %eax,%edi
80101da6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101da7:	31 f6                	xor    %esi,%esi
{
80101da9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101daa:	bb b4 14 11 80       	mov    $0x801114b4,%ebx
{
80101daf:	83 ec 28             	sub    $0x28,%esp
80101db2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101db5:	68 80 14 11 80       	push   $0x80111480
80101dba:	e8 31 32 00 00       	call   80104ff0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101dbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101dc2:	83 c4 10             	add    $0x10,%esp
80101dc5:	eb 1b                	jmp    80101de2 <iget+0x42>
80101dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101dd0:	39 3b                	cmp    %edi,(%ebx)
80101dd2:	74 6c                	je     80101e40 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101dd4:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101dda:	81 fb d4 30 11 80    	cmp    $0x801130d4,%ebx
80101de0:	73 26                	jae    80101e08 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101de2:	8b 43 08             	mov    0x8(%ebx),%eax
80101de5:	85 c0                	test   %eax,%eax
80101de7:	7f e7                	jg     80101dd0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101de9:	85 f6                	test   %esi,%esi
80101deb:	75 e7                	jne    80101dd4 <iget+0x34>
80101ded:	85 c0                	test   %eax,%eax
80101def:	75 76                	jne    80101e67 <iget+0xc7>
80101df1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101df3:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101df9:	81 fb d4 30 11 80    	cmp    $0x801130d4,%ebx
80101dff:	72 e1                	jb     80101de2 <iget+0x42>
80101e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101e08:	85 f6                	test   %esi,%esi
80101e0a:	74 79                	je     80101e85 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101e0f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101e11:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101e14:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101e1b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101e22:	68 80 14 11 80       	push   $0x80111480
80101e27:	e8 64 31 00 00       	call   80104f90 <release>

  return ip;
80101e2c:	83 c4 10             	add    $0x10,%esp
}
80101e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e32:	89 f0                	mov    %esi,%eax
80101e34:	5b                   	pop    %ebx
80101e35:	5e                   	pop    %esi
80101e36:	5f                   	pop    %edi
80101e37:	5d                   	pop    %ebp
80101e38:	c3                   	ret    
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101e40:	39 53 04             	cmp    %edx,0x4(%ebx)
80101e43:	75 8f                	jne    80101dd4 <iget+0x34>
      release(&icache.lock);
80101e45:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101e48:	83 c0 01             	add    $0x1,%eax
      return ip;
80101e4b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101e4d:	68 80 14 11 80       	push   $0x80111480
      ip->ref++;
80101e52:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101e55:	e8 36 31 00 00       	call   80104f90 <release>
      return ip;
80101e5a:	83 c4 10             	add    $0x10,%esp
}
80101e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e60:	89 f0                	mov    %esi,%eax
80101e62:	5b                   	pop    %ebx
80101e63:	5e                   	pop    %esi
80101e64:	5f                   	pop    %edi
80101e65:	5d                   	pop    %ebp
80101e66:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101e67:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101e6d:	81 fb d4 30 11 80    	cmp    $0x801130d4,%ebx
80101e73:	73 10                	jae    80101e85 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101e75:	8b 43 08             	mov    0x8(%ebx),%eax
80101e78:	85 c0                	test   %eax,%eax
80101e7a:	0f 8f 50 ff ff ff    	jg     80101dd0 <iget+0x30>
80101e80:	e9 68 ff ff ff       	jmp    80101ded <iget+0x4d>
    panic("iget: no inodes");
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	68 c8 7c 10 80       	push   $0x80107cc8
80101e8d:	e8 7e e5 ff ff       	call   80100410 <panic>
80101e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	89 c6                	mov    %eax,%esi
80101ea7:	53                   	push   %ebx
80101ea8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101eab:	83 fa 0b             	cmp    $0xb,%edx
80101eae:	0f 86 8c 00 00 00    	jbe    80101f40 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101eb4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101eb7:	83 fb 7f             	cmp    $0x7f,%ebx
80101eba:	0f 87 a2 00 00 00    	ja     80101f62 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ec0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ec6:	85 c0                	test   %eax,%eax
80101ec8:	74 5e                	je     80101f28 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101eca:	83 ec 08             	sub    $0x8,%esp
80101ecd:	50                   	push   %eax
80101ece:	ff 36                	push   (%esi)
80101ed0:	e8 fb e1 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101ed5:	83 c4 10             	add    $0x10,%esp
80101ed8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101edc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101ede:	8b 3b                	mov    (%ebx),%edi
80101ee0:	85 ff                	test   %edi,%edi
80101ee2:	74 1c                	je     80101f00 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101ee4:	83 ec 0c             	sub    $0xc,%esp
80101ee7:	52                   	push   %edx
80101ee8:	e8 03 e3 ff ff       	call   801001f0 <brelse>
80101eed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef3:	89 f8                	mov    %edi,%eax
80101ef5:	5b                   	pop    %ebx
80101ef6:	5e                   	pop    %esi
80101ef7:	5f                   	pop    %edi
80101ef8:	5d                   	pop    %ebp
80101ef9:	c3                   	ret    
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101f03:	8b 06                	mov    (%esi),%eax
80101f05:	e8 86 fd ff ff       	call   80101c90 <balloc>
      log_write(bp);
80101f0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f0d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101f10:	89 03                	mov    %eax,(%ebx)
80101f12:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101f14:	52                   	push   %edx
80101f15:	e8 76 1a 00 00       	call   80103990 <log_write>
80101f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f1d:	83 c4 10             	add    $0x10,%esp
80101f20:	eb c2                	jmp    80101ee4 <bmap+0x44>
80101f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101f28:	8b 06                	mov    (%esi),%eax
80101f2a:	e8 61 fd ff ff       	call   80101c90 <balloc>
80101f2f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101f35:	eb 93                	jmp    80101eca <bmap+0x2a>
80101f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101f40:	8d 5a 14             	lea    0x14(%edx),%ebx
80101f43:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101f47:	85 ff                	test   %edi,%edi
80101f49:	75 a5                	jne    80101ef0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101f4b:	8b 00                	mov    (%eax),%eax
80101f4d:	e8 3e fd ff ff       	call   80101c90 <balloc>
80101f52:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101f56:	89 c7                	mov    %eax,%edi
}
80101f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5b:	5b                   	pop    %ebx
80101f5c:	89 f8                	mov    %edi,%eax
80101f5e:	5e                   	pop    %esi
80101f5f:	5f                   	pop    %edi
80101f60:	5d                   	pop    %ebp
80101f61:	c3                   	ret    
  panic("bmap: out of range");
80101f62:	83 ec 0c             	sub    $0xc,%esp
80101f65:	68 d8 7c 10 80       	push   $0x80107cd8
80101f6a:	e8 a1 e4 ff ff       	call   80100410 <panic>
80101f6f:	90                   	nop

80101f70 <readsb>:
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	56                   	push   %esi
80101f74:	53                   	push   %ebx
80101f75:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101f78:	83 ec 08             	sub    $0x8,%esp
80101f7b:	6a 01                	push   $0x1
80101f7d:	ff 75 08             	push   0x8(%ebp)
80101f80:	e8 4b e1 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101f85:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101f88:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101f8a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101f8d:	6a 1c                	push   $0x1c
80101f8f:	50                   	push   %eax
80101f90:	56                   	push   %esi
80101f91:	e8 ba 31 00 00       	call   80105150 <memmove>
  brelse(bp);
80101f96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f99:	83 c4 10             	add    $0x10,%esp
}
80101f9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f9f:	5b                   	pop    %ebx
80101fa0:	5e                   	pop    %esi
80101fa1:	5d                   	pop    %ebp
  brelse(bp);
80101fa2:	e9 49 e2 ff ff       	jmp    801001f0 <brelse>
80101fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fae:	66 90                	xchg   %ax,%ax

80101fb0 <iinit>:
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	53                   	push   %ebx
80101fb4:	bb c0 14 11 80       	mov    $0x801114c0,%ebx
80101fb9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101fbc:	68 eb 7c 10 80       	push   $0x80107ceb
80101fc1:	68 80 14 11 80       	push   $0x80111480
80101fc6:	e8 55 2e 00 00       	call   80104e20 <initlock>
  for(i = 0; i < NINODE; i++) {
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101fd0:	83 ec 08             	sub    $0x8,%esp
80101fd3:	68 f2 7c 10 80       	push   $0x80107cf2
80101fd8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101fd9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101fdf:	e8 0c 2d 00 00       	call   80104cf0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	81 fb e0 30 11 80    	cmp    $0x801130e0,%ebx
80101fed:	75 e1                	jne    80101fd0 <iinit+0x20>
  bp = bread(dev, 1);
80101fef:	83 ec 08             	sub    $0x8,%esp
80101ff2:	6a 01                	push   $0x1
80101ff4:	ff 75 08             	push   0x8(%ebp)
80101ff7:	e8 d4 e0 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101ffc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101fff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80102001:	8d 40 5c             	lea    0x5c(%eax),%eax
80102004:	6a 1c                	push   $0x1c
80102006:	50                   	push   %eax
80102007:	68 d4 30 11 80       	push   $0x801130d4
8010200c:	e8 3f 31 00 00       	call   80105150 <memmove>
  brelse(bp);
80102011:	89 1c 24             	mov    %ebx,(%esp)
80102014:	e8 d7 e1 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80102019:	ff 35 ec 30 11 80    	push   0x801130ec
8010201f:	ff 35 e8 30 11 80    	push   0x801130e8
80102025:	ff 35 e4 30 11 80    	push   0x801130e4
8010202b:	ff 35 e0 30 11 80    	push   0x801130e0
80102031:	ff 35 dc 30 11 80    	push   0x801130dc
80102037:	ff 35 d8 30 11 80    	push   0x801130d8
8010203d:	ff 35 d4 30 11 80    	push   0x801130d4
80102043:	68 58 7d 10 80       	push   $0x80107d58
80102048:	e8 43 e7 ff ff       	call   80100790 <cprintf>
}
8010204d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102050:	83 c4 30             	add    $0x30,%esp
80102053:	c9                   	leave  
80102054:	c3                   	ret    
80102055:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102060 <ialloc>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 1c             	sub    $0x1c,%esp
80102069:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010206c:	83 3d dc 30 11 80 01 	cmpl   $0x1,0x801130dc
{
80102073:	8b 75 08             	mov    0x8(%ebp),%esi
80102076:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102079:	0f 86 91 00 00 00    	jbe    80102110 <ialloc+0xb0>
8010207f:	bf 01 00 00 00       	mov    $0x1,%edi
80102084:	eb 21                	jmp    801020a7 <ialloc+0x47>
80102086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010208d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102090:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102093:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102096:	53                   	push   %ebx
80102097:	e8 54 e1 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010209c:	83 c4 10             	add    $0x10,%esp
8010209f:	3b 3d dc 30 11 80    	cmp    0x801130dc,%edi
801020a5:	73 69                	jae    80102110 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801020a7:	89 f8                	mov    %edi,%eax
801020a9:	83 ec 08             	sub    $0x8,%esp
801020ac:	c1 e8 03             	shr    $0x3,%eax
801020af:	03 05 e8 30 11 80    	add    0x801130e8,%eax
801020b5:	50                   	push   %eax
801020b6:	56                   	push   %esi
801020b7:	e8 14 e0 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801020bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801020bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	83 e0 07             	and    $0x7,%eax
801020c6:	c1 e0 06             	shl    $0x6,%eax
801020c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801020cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801020d1:	75 bd                	jne    80102090 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801020d3:	83 ec 04             	sub    $0x4,%esp
801020d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801020d9:	6a 40                	push   $0x40
801020db:	6a 00                	push   $0x0
801020dd:	51                   	push   %ecx
801020de:	e8 cd 2f 00 00       	call   801050b0 <memset>
      dip->type = type;
801020e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801020e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801020ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801020ed:	89 1c 24             	mov    %ebx,(%esp)
801020f0:	e8 9b 18 00 00       	call   80103990 <log_write>
      brelse(bp);
801020f5:	89 1c 24             	mov    %ebx,(%esp)
801020f8:	e8 f3 e0 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801020fd:	83 c4 10             	add    $0x10,%esp
}
80102100:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102103:	89 fa                	mov    %edi,%edx
}
80102105:	5b                   	pop    %ebx
      return iget(dev, inum);
80102106:	89 f0                	mov    %esi,%eax
}
80102108:	5e                   	pop    %esi
80102109:	5f                   	pop    %edi
8010210a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010210b:	e9 90 fc ff ff       	jmp    80101da0 <iget>
  panic("ialloc: no inodes");
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	68 f8 7c 10 80       	push   $0x80107cf8
80102118:	e8 f3 e2 ff ff       	call   80100410 <panic>
8010211d:	8d 76 00             	lea    0x0(%esi),%esi

80102120 <iupdate>:
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	56                   	push   %esi
80102124:	53                   	push   %ebx
80102125:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102128:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010212b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010212e:	83 ec 08             	sub    $0x8,%esp
80102131:	c1 e8 03             	shr    $0x3,%eax
80102134:	03 05 e8 30 11 80    	add    0x801130e8,%eax
8010213a:	50                   	push   %eax
8010213b:	ff 73 a4             	push   -0x5c(%ebx)
8010213e:	e8 8d df ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102143:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102147:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010214a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010214c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010214f:	83 e0 07             	and    $0x7,%eax
80102152:	c1 e0 06             	shl    $0x6,%eax
80102155:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102159:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010215c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102160:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102163:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102167:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010216b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010216f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102173:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102177:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010217a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010217d:	6a 34                	push   $0x34
8010217f:	53                   	push   %ebx
80102180:	50                   	push   %eax
80102181:	e8 ca 2f 00 00       	call   80105150 <memmove>
  log_write(bp);
80102186:	89 34 24             	mov    %esi,(%esp)
80102189:	e8 02 18 00 00       	call   80103990 <log_write>
  brelse(bp);
8010218e:	89 75 08             	mov    %esi,0x8(%ebp)
80102191:	83 c4 10             	add    $0x10,%esp
}
80102194:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102197:	5b                   	pop    %ebx
80102198:	5e                   	pop    %esi
80102199:	5d                   	pop    %ebp
  brelse(bp);
8010219a:	e9 51 e0 ff ff       	jmp    801001f0 <brelse>
8010219f:	90                   	nop

801021a0 <idup>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	53                   	push   %ebx
801021a4:	83 ec 10             	sub    $0x10,%esp
801021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801021aa:	68 80 14 11 80       	push   $0x80111480
801021af:	e8 3c 2e 00 00       	call   80104ff0 <acquire>
  ip->ref++;
801021b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801021b8:	c7 04 24 80 14 11 80 	movl   $0x80111480,(%esp)
801021bf:	e8 cc 2d 00 00       	call   80104f90 <release>
}
801021c4:	89 d8                	mov    %ebx,%eax
801021c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021c9:	c9                   	leave  
801021ca:	c3                   	ret    
801021cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021cf:	90                   	nop

801021d0 <ilock>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	56                   	push   %esi
801021d4:	53                   	push   %ebx
801021d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801021d8:	85 db                	test   %ebx,%ebx
801021da:	0f 84 b7 00 00 00    	je     80102297 <ilock+0xc7>
801021e0:	8b 53 08             	mov    0x8(%ebx),%edx
801021e3:	85 d2                	test   %edx,%edx
801021e5:	0f 8e ac 00 00 00    	jle    80102297 <ilock+0xc7>
  acquiresleep(&ip->lock);
801021eb:	83 ec 0c             	sub    $0xc,%esp
801021ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801021f1:	50                   	push   %eax
801021f2:	e8 39 2b 00 00       	call   80104d30 <acquiresleep>
  if(ip->valid == 0){
801021f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	85 c0                	test   %eax,%eax
801021ff:	74 0f                	je     80102210 <ilock+0x40>
}
80102201:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102204:	5b                   	pop    %ebx
80102205:	5e                   	pop    %esi
80102206:	5d                   	pop    %ebp
80102207:	c3                   	ret    
80102208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102210:	8b 43 04             	mov    0x4(%ebx),%eax
80102213:	83 ec 08             	sub    $0x8,%esp
80102216:	c1 e8 03             	shr    $0x3,%eax
80102219:	03 05 e8 30 11 80    	add    0x801130e8,%eax
8010221f:	50                   	push   %eax
80102220:	ff 33                	push   (%ebx)
80102222:	e8 a9 de ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102227:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010222a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010222c:	8b 43 04             	mov    0x4(%ebx),%eax
8010222f:	83 e0 07             	and    $0x7,%eax
80102232:	c1 e0 06             	shl    $0x6,%eax
80102235:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102239:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010223c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010223f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102243:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102247:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010224b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010224f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102253:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102257:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010225b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010225e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102261:	6a 34                	push   $0x34
80102263:	50                   	push   %eax
80102264:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102267:	50                   	push   %eax
80102268:	e8 e3 2e 00 00       	call   80105150 <memmove>
    brelse(bp);
8010226d:	89 34 24             	mov    %esi,(%esp)
80102270:	e8 7b df ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102275:	83 c4 10             	add    $0x10,%esp
80102278:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010227d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102284:	0f 85 77 ff ff ff    	jne    80102201 <ilock+0x31>
      panic("ilock: no type");
8010228a:	83 ec 0c             	sub    $0xc,%esp
8010228d:	68 10 7d 10 80       	push   $0x80107d10
80102292:	e8 79 e1 ff ff       	call   80100410 <panic>
    panic("ilock");
80102297:	83 ec 0c             	sub    $0xc,%esp
8010229a:	68 0a 7d 10 80       	push   $0x80107d0a
8010229f:	e8 6c e1 ff ff       	call   80100410 <panic>
801022a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop

801022b0 <iunlock>:
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	56                   	push   %esi
801022b4:	53                   	push   %ebx
801022b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801022b8:	85 db                	test   %ebx,%ebx
801022ba:	74 28                	je     801022e4 <iunlock+0x34>
801022bc:	83 ec 0c             	sub    $0xc,%esp
801022bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801022c2:	56                   	push   %esi
801022c3:	e8 08 2b 00 00       	call   80104dd0 <holdingsleep>
801022c8:	83 c4 10             	add    $0x10,%esp
801022cb:	85 c0                	test   %eax,%eax
801022cd:	74 15                	je     801022e4 <iunlock+0x34>
801022cf:	8b 43 08             	mov    0x8(%ebx),%eax
801022d2:	85 c0                	test   %eax,%eax
801022d4:	7e 0e                	jle    801022e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801022d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801022d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022dc:	5b                   	pop    %ebx
801022dd:	5e                   	pop    %esi
801022de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801022df:	e9 ac 2a 00 00       	jmp    80104d90 <releasesleep>
    panic("iunlock");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 1f 7d 10 80       	push   $0x80107d1f
801022ec:	e8 1f e1 ff ff       	call   80100410 <panic>
801022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <iput>:
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 28             	sub    $0x28,%esp
80102309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010230c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010230f:	57                   	push   %edi
80102310:	e8 1b 2a 00 00       	call   80104d30 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102315:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102318:	83 c4 10             	add    $0x10,%esp
8010231b:	85 d2                	test   %edx,%edx
8010231d:	74 07                	je     80102326 <iput+0x26>
8010231f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102324:	74 32                	je     80102358 <iput+0x58>
  releasesleep(&ip->lock);
80102326:	83 ec 0c             	sub    $0xc,%esp
80102329:	57                   	push   %edi
8010232a:	e8 61 2a 00 00       	call   80104d90 <releasesleep>
  acquire(&icache.lock);
8010232f:	c7 04 24 80 14 11 80 	movl   $0x80111480,(%esp)
80102336:	e8 b5 2c 00 00       	call   80104ff0 <acquire>
  ip->ref--;
8010233b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010233f:	83 c4 10             	add    $0x10,%esp
80102342:	c7 45 08 80 14 11 80 	movl   $0x80111480,0x8(%ebp)
}
80102349:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010234c:	5b                   	pop    %ebx
8010234d:	5e                   	pop    %esi
8010234e:	5f                   	pop    %edi
8010234f:	5d                   	pop    %ebp
  release(&icache.lock);
80102350:	e9 3b 2c 00 00       	jmp    80104f90 <release>
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102358:	83 ec 0c             	sub    $0xc,%esp
8010235b:	68 80 14 11 80       	push   $0x80111480
80102360:	e8 8b 2c 00 00       	call   80104ff0 <acquire>
    int r = ip->ref;
80102365:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102368:	c7 04 24 80 14 11 80 	movl   $0x80111480,(%esp)
8010236f:	e8 1c 2c 00 00       	call   80104f90 <release>
    if(r == 1){
80102374:	83 c4 10             	add    $0x10,%esp
80102377:	83 fe 01             	cmp    $0x1,%esi
8010237a:	75 aa                	jne    80102326 <iput+0x26>
8010237c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102382:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102385:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102388:	89 cf                	mov    %ecx,%edi
8010238a:	eb 0b                	jmp    80102397 <iput+0x97>
8010238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102390:	83 c6 04             	add    $0x4,%esi
80102393:	39 fe                	cmp    %edi,%esi
80102395:	74 19                	je     801023b0 <iput+0xb0>
    if(ip->addrs[i]){
80102397:	8b 16                	mov    (%esi),%edx
80102399:	85 d2                	test   %edx,%edx
8010239b:	74 f3                	je     80102390 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010239d:	8b 03                	mov    (%ebx),%eax
8010239f:	e8 6c f8 ff ff       	call   80101c10 <bfree>
      ip->addrs[i] = 0;
801023a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801023aa:	eb e4                	jmp    80102390 <iput+0x90>
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801023b0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801023b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801023b9:	85 c0                	test   %eax,%eax
801023bb:	75 2d                	jne    801023ea <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801023bd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801023c0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801023c7:	53                   	push   %ebx
801023c8:	e8 53 fd ff ff       	call   80102120 <iupdate>
      ip->type = 0;
801023cd:	31 c0                	xor    %eax,%eax
801023cf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801023d3:	89 1c 24             	mov    %ebx,(%esp)
801023d6:	e8 45 fd ff ff       	call   80102120 <iupdate>
      ip->valid = 0;
801023db:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801023e2:	83 c4 10             	add    $0x10,%esp
801023e5:	e9 3c ff ff ff       	jmp    80102326 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801023ea:	83 ec 08             	sub    $0x8,%esp
801023ed:	50                   	push   %eax
801023ee:	ff 33                	push   (%ebx)
801023f0:	e8 db dc ff ff       	call   801000d0 <bread>
801023f5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102404:	8d 70 5c             	lea    0x5c(%eax),%esi
80102407:	89 cf                	mov    %ecx,%edi
80102409:	eb 0c                	jmp    80102417 <iput+0x117>
8010240b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop
80102410:	83 c6 04             	add    $0x4,%esi
80102413:	39 f7                	cmp    %esi,%edi
80102415:	74 0f                	je     80102426 <iput+0x126>
      if(a[j])
80102417:	8b 16                	mov    (%esi),%edx
80102419:	85 d2                	test   %edx,%edx
8010241b:	74 f3                	je     80102410 <iput+0x110>
        bfree(ip->dev, a[j]);
8010241d:	8b 03                	mov    (%ebx),%eax
8010241f:	e8 ec f7 ff ff       	call   80101c10 <bfree>
80102424:	eb ea                	jmp    80102410 <iput+0x110>
    brelse(bp);
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	ff 75 e4             	push   -0x1c(%ebp)
8010242c:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010242f:	e8 bc dd ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102434:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010243a:	8b 03                	mov    (%ebx),%eax
8010243c:	e8 cf f7 ff ff       	call   80101c10 <bfree>
    ip->addrs[NDIRECT] = 0;
80102441:	83 c4 10             	add    $0x10,%esp
80102444:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010244b:	00 00 00 
8010244e:	e9 6a ff ff ff       	jmp    801023bd <iput+0xbd>
80102453:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102460 <iunlockput>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102468:	85 db                	test   %ebx,%ebx
8010246a:	74 34                	je     801024a0 <iunlockput+0x40>
8010246c:	83 ec 0c             	sub    $0xc,%esp
8010246f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102472:	56                   	push   %esi
80102473:	e8 58 29 00 00       	call   80104dd0 <holdingsleep>
80102478:	83 c4 10             	add    $0x10,%esp
8010247b:	85 c0                	test   %eax,%eax
8010247d:	74 21                	je     801024a0 <iunlockput+0x40>
8010247f:	8b 43 08             	mov    0x8(%ebx),%eax
80102482:	85 c0                	test   %eax,%eax
80102484:	7e 1a                	jle    801024a0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102486:	83 ec 0c             	sub    $0xc,%esp
80102489:	56                   	push   %esi
8010248a:	e8 01 29 00 00       	call   80104d90 <releasesleep>
  iput(ip);
8010248f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102492:	83 c4 10             	add    $0x10,%esp
}
80102495:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102498:	5b                   	pop    %ebx
80102499:	5e                   	pop    %esi
8010249a:	5d                   	pop    %ebp
  iput(ip);
8010249b:	e9 60 fe ff ff       	jmp    80102300 <iput>
    panic("iunlock");
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	68 1f 7d 10 80       	push   $0x80107d1f
801024a8:	e8 63 df ff ff       	call   80100410 <panic>
801024ad:	8d 76 00             	lea    0x0(%esi),%esi

801024b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	8b 55 08             	mov    0x8(%ebp),%edx
801024b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801024b9:	8b 0a                	mov    (%edx),%ecx
801024bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801024be:	8b 4a 04             	mov    0x4(%edx),%ecx
801024c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801024c4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801024c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801024cb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801024cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801024d3:	8b 52 58             	mov    0x58(%edx),%edx
801024d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d9:	5d                   	pop    %ebp
801024da:	c3                   	ret    
801024db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024df:	90                   	nop

801024e0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	57                   	push   %edi
801024e4:	56                   	push   %esi
801024e5:	53                   	push   %ebx
801024e6:	83 ec 1c             	sub    $0x1c,%esp
801024e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801024ec:	8b 45 08             	mov    0x8(%ebp),%eax
801024ef:	8b 75 10             	mov    0x10(%ebp),%esi
801024f2:	89 7d e0             	mov    %edi,-0x20(%ebp)
801024f5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801024f8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801024fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102500:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102503:	0f 84 a7 00 00 00    	je     801025b0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102509:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010250c:	8b 40 58             	mov    0x58(%eax),%eax
8010250f:	39 c6                	cmp    %eax,%esi
80102511:	0f 87 ba 00 00 00    	ja     801025d1 <readi+0xf1>
80102517:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010251a:	31 c9                	xor    %ecx,%ecx
8010251c:	89 da                	mov    %ebx,%edx
8010251e:	01 f2                	add    %esi,%edx
80102520:	0f 92 c1             	setb   %cl
80102523:	89 cf                	mov    %ecx,%edi
80102525:	0f 82 a6 00 00 00    	jb     801025d1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010252b:	89 c1                	mov    %eax,%ecx
8010252d:	29 f1                	sub    %esi,%ecx
8010252f:	39 d0                	cmp    %edx,%eax
80102531:	0f 43 cb             	cmovae %ebx,%ecx
80102534:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102537:	85 c9                	test   %ecx,%ecx
80102539:	74 67                	je     801025a2 <readi+0xc2>
8010253b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010253f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102540:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102543:	89 f2                	mov    %esi,%edx
80102545:	c1 ea 09             	shr    $0x9,%edx
80102548:	89 d8                	mov    %ebx,%eax
8010254a:	e8 51 f9 ff ff       	call   80101ea0 <bmap>
8010254f:	83 ec 08             	sub    $0x8,%esp
80102552:	50                   	push   %eax
80102553:	ff 33                	push   (%ebx)
80102555:	e8 76 db ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010255a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010255d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102562:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102564:	89 f0                	mov    %esi,%eax
80102566:	25 ff 01 00 00       	and    $0x1ff,%eax
8010256b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010256d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102570:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102572:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102576:	39 d9                	cmp    %ebx,%ecx
80102578:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010257b:	83 c4 0c             	add    $0xc,%esp
8010257e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010257f:	01 df                	add    %ebx,%edi
80102581:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102583:	50                   	push   %eax
80102584:	ff 75 e0             	push   -0x20(%ebp)
80102587:	e8 c4 2b 00 00       	call   80105150 <memmove>
    brelse(bp);
8010258c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010258f:	89 14 24             	mov    %edx,(%esp)
80102592:	e8 59 dc ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102597:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010259a:	83 c4 10             	add    $0x10,%esp
8010259d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801025a0:	77 9e                	ja     80102540 <readi+0x60>
  }
  return n;
801025a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801025a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a8:	5b                   	pop    %ebx
801025a9:	5e                   	pop    %esi
801025aa:	5f                   	pop    %edi
801025ab:	5d                   	pop    %ebp
801025ac:	c3                   	ret    
801025ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801025b0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801025b4:	66 83 f8 09          	cmp    $0x9,%ax
801025b8:	77 17                	ja     801025d1 <readi+0xf1>
801025ba:	8b 04 c5 20 14 11 80 	mov    -0x7feeebe0(,%eax,8),%eax
801025c1:	85 c0                	test   %eax,%eax
801025c3:	74 0c                	je     801025d1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801025c5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801025c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025cb:	5b                   	pop    %ebx
801025cc:	5e                   	pop    %esi
801025cd:	5f                   	pop    %edi
801025ce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801025cf:	ff e0                	jmp    *%eax
      return -1;
801025d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d6:	eb cd                	jmp    801025a5 <readi+0xc5>
801025d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	57                   	push   %edi
801025e4:	56                   	push   %esi
801025e5:	53                   	push   %ebx
801025e6:	83 ec 1c             	sub    $0x1c,%esp
801025e9:	8b 45 08             	mov    0x8(%ebp),%eax
801025ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ef:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801025f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801025f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801025fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801025fd:	8b 75 10             	mov    0x10(%ebp),%esi
80102600:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102603:	0f 84 b7 00 00 00    	je     801026c0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102609:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010260c:	3b 70 58             	cmp    0x58(%eax),%esi
8010260f:	0f 87 e7 00 00 00    	ja     801026fc <writei+0x11c>
80102615:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102618:	31 d2                	xor    %edx,%edx
8010261a:	89 f8                	mov    %edi,%eax
8010261c:	01 f0                	add    %esi,%eax
8010261e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102621:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102626:	0f 87 d0 00 00 00    	ja     801026fc <writei+0x11c>
8010262c:	85 d2                	test   %edx,%edx
8010262e:	0f 85 c8 00 00 00    	jne    801026fc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010263b:	85 ff                	test   %edi,%edi
8010263d:	74 72                	je     801026b1 <writei+0xd1>
8010263f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102640:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102643:	89 f2                	mov    %esi,%edx
80102645:	c1 ea 09             	shr    $0x9,%edx
80102648:	89 f8                	mov    %edi,%eax
8010264a:	e8 51 f8 ff ff       	call   80101ea0 <bmap>
8010264f:	83 ec 08             	sub    $0x8,%esp
80102652:	50                   	push   %eax
80102653:	ff 37                	push   (%edi)
80102655:	e8 76 da ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010265a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010265f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102662:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102665:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102667:	89 f0                	mov    %esi,%eax
80102669:	25 ff 01 00 00       	and    $0x1ff,%eax
8010266e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102670:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102674:	39 d9                	cmp    %ebx,%ecx
80102676:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102679:	83 c4 0c             	add    $0xc,%esp
8010267c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010267d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010267f:	ff 75 dc             	push   -0x24(%ebp)
80102682:	50                   	push   %eax
80102683:	e8 c8 2a 00 00       	call   80105150 <memmove>
    log_write(bp);
80102688:	89 3c 24             	mov    %edi,(%esp)
8010268b:	e8 00 13 00 00       	call   80103990 <log_write>
    brelse(bp);
80102690:	89 3c 24             	mov    %edi,(%esp)
80102693:	e8 58 db ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102698:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010269b:	83 c4 10             	add    $0x10,%esp
8010269e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801026a1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801026a4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801026a7:	77 97                	ja     80102640 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801026a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801026ac:	3b 70 58             	cmp    0x58(%eax),%esi
801026af:	77 37                	ja     801026e8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801026b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026b7:	5b                   	pop    %ebx
801026b8:	5e                   	pop    %esi
801026b9:	5f                   	pop    %edi
801026ba:	5d                   	pop    %ebp
801026bb:	c3                   	ret    
801026bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801026c0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801026c4:	66 83 f8 09          	cmp    $0x9,%ax
801026c8:	77 32                	ja     801026fc <writei+0x11c>
801026ca:	8b 04 c5 24 14 11 80 	mov    -0x7feeebdc(,%eax,8),%eax
801026d1:	85 c0                	test   %eax,%eax
801026d3:	74 27                	je     801026fc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801026d5:	89 55 10             	mov    %edx,0x10(%ebp)
}
801026d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026db:	5b                   	pop    %ebx
801026dc:	5e                   	pop    %esi
801026dd:	5f                   	pop    %edi
801026de:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801026df:	ff e0                	jmp    *%eax
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801026e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801026eb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801026ee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801026f1:	50                   	push   %eax
801026f2:	e8 29 fa ff ff       	call   80102120 <iupdate>
801026f7:	83 c4 10             	add    $0x10,%esp
801026fa:	eb b5                	jmp    801026b1 <writei+0xd1>
      return -1;
801026fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102701:	eb b1                	jmp    801026b4 <writei+0xd4>
80102703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102710 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102716:	6a 0e                	push   $0xe
80102718:	ff 75 0c             	push   0xc(%ebp)
8010271b:	ff 75 08             	push   0x8(%ebp)
8010271e:	e8 9d 2a 00 00       	call   801051c0 <strncmp>
}
80102723:	c9                   	leave  
80102724:	c3                   	ret    
80102725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	57                   	push   %edi
80102734:	56                   	push   %esi
80102735:	53                   	push   %ebx
80102736:	83 ec 1c             	sub    $0x1c,%esp
80102739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010273c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102741:	0f 85 85 00 00 00    	jne    801027cc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102747:	8b 53 58             	mov    0x58(%ebx),%edx
8010274a:	31 ff                	xor    %edi,%edi
8010274c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010274f:	85 d2                	test   %edx,%edx
80102751:	74 3e                	je     80102791 <dirlookup+0x61>
80102753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102757:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102758:	6a 10                	push   $0x10
8010275a:	57                   	push   %edi
8010275b:	56                   	push   %esi
8010275c:	53                   	push   %ebx
8010275d:	e8 7e fd ff ff       	call   801024e0 <readi>
80102762:	83 c4 10             	add    $0x10,%esp
80102765:	83 f8 10             	cmp    $0x10,%eax
80102768:	75 55                	jne    801027bf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010276a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010276f:	74 18                	je     80102789 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102771:	83 ec 04             	sub    $0x4,%esp
80102774:	8d 45 da             	lea    -0x26(%ebp),%eax
80102777:	6a 0e                	push   $0xe
80102779:	50                   	push   %eax
8010277a:	ff 75 0c             	push   0xc(%ebp)
8010277d:	e8 3e 2a 00 00       	call   801051c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102782:	83 c4 10             	add    $0x10,%esp
80102785:	85 c0                	test   %eax,%eax
80102787:	74 17                	je     801027a0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102789:	83 c7 10             	add    $0x10,%edi
8010278c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010278f:	72 c7                	jb     80102758 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102791:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102794:	31 c0                	xor    %eax,%eax
}
80102796:	5b                   	pop    %ebx
80102797:	5e                   	pop    %esi
80102798:	5f                   	pop    %edi
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010279f:	90                   	nop
      if(poff)
801027a0:	8b 45 10             	mov    0x10(%ebp),%eax
801027a3:	85 c0                	test   %eax,%eax
801027a5:	74 05                	je     801027ac <dirlookup+0x7c>
        *poff = off;
801027a7:	8b 45 10             	mov    0x10(%ebp),%eax
801027aa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801027ac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801027b0:	8b 03                	mov    (%ebx),%eax
801027b2:	e8 e9 f5 ff ff       	call   80101da0 <iget>
}
801027b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027ba:	5b                   	pop    %ebx
801027bb:	5e                   	pop    %esi
801027bc:	5f                   	pop    %edi
801027bd:	5d                   	pop    %ebp
801027be:	c3                   	ret    
      panic("dirlookup read");
801027bf:	83 ec 0c             	sub    $0xc,%esp
801027c2:	68 39 7d 10 80       	push   $0x80107d39
801027c7:	e8 44 dc ff ff       	call   80100410 <panic>
    panic("dirlookup not DIR");
801027cc:	83 ec 0c             	sub    $0xc,%esp
801027cf:	68 27 7d 10 80       	push   $0x80107d27
801027d4:	e8 37 dc ff ff       	call   80100410 <panic>
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	57                   	push   %edi
801027e4:	56                   	push   %esi
801027e5:	53                   	push   %ebx
801027e6:	89 c3                	mov    %eax,%ebx
801027e8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801027eb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801027ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
801027f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801027f4:	0f 84 64 01 00 00    	je     8010295e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801027fa:	e8 c1 1b 00 00       	call   801043c0 <myproc>
  acquire(&icache.lock);
801027ff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102802:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102805:	68 80 14 11 80       	push   $0x80111480
8010280a:	e8 e1 27 00 00       	call   80104ff0 <acquire>
  ip->ref++;
8010280f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102813:	c7 04 24 80 14 11 80 	movl   $0x80111480,(%esp)
8010281a:	e8 71 27 00 00       	call   80104f90 <release>
8010281f:	83 c4 10             	add    $0x10,%esp
80102822:	eb 07                	jmp    8010282b <namex+0x4b>
80102824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102828:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010282b:	0f b6 03             	movzbl (%ebx),%eax
8010282e:	3c 2f                	cmp    $0x2f,%al
80102830:	74 f6                	je     80102828 <namex+0x48>
  if(*path == 0)
80102832:	84 c0                	test   %al,%al
80102834:	0f 84 06 01 00 00    	je     80102940 <namex+0x160>
  while(*path != '/' && *path != 0)
8010283a:	0f b6 03             	movzbl (%ebx),%eax
8010283d:	84 c0                	test   %al,%al
8010283f:	0f 84 10 01 00 00    	je     80102955 <namex+0x175>
80102845:	89 df                	mov    %ebx,%edi
80102847:	3c 2f                	cmp    $0x2f,%al
80102849:	0f 84 06 01 00 00    	je     80102955 <namex+0x175>
8010284f:	90                   	nop
80102850:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102854:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102857:	3c 2f                	cmp    $0x2f,%al
80102859:	74 04                	je     8010285f <namex+0x7f>
8010285b:	84 c0                	test   %al,%al
8010285d:	75 f1                	jne    80102850 <namex+0x70>
  len = path - s;
8010285f:	89 f8                	mov    %edi,%eax
80102861:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102863:	83 f8 0d             	cmp    $0xd,%eax
80102866:	0f 8e ac 00 00 00    	jle    80102918 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010286c:	83 ec 04             	sub    $0x4,%esp
8010286f:	6a 0e                	push   $0xe
80102871:	53                   	push   %ebx
    path++;
80102872:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102874:	ff 75 e4             	push   -0x1c(%ebp)
80102877:	e8 d4 28 00 00       	call   80105150 <memmove>
8010287c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010287f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102882:	75 0c                	jne    80102890 <namex+0xb0>
80102884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102888:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010288b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010288e:	74 f8                	je     80102888 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	56                   	push   %esi
80102894:	e8 37 f9 ff ff       	call   801021d0 <ilock>
    if(ip->type != T_DIR){
80102899:	83 c4 10             	add    $0x10,%esp
8010289c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801028a1:	0f 85 cd 00 00 00    	jne    80102974 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801028a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801028aa:	85 c0                	test   %eax,%eax
801028ac:	74 09                	je     801028b7 <namex+0xd7>
801028ae:	80 3b 00             	cmpb   $0x0,(%ebx)
801028b1:	0f 84 22 01 00 00    	je     801029d9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801028b7:	83 ec 04             	sub    $0x4,%esp
801028ba:	6a 00                	push   $0x0
801028bc:	ff 75 e4             	push   -0x1c(%ebp)
801028bf:	56                   	push   %esi
801028c0:	e8 6b fe ff ff       	call   80102730 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801028c5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
801028c8:	83 c4 10             	add    $0x10,%esp
801028cb:	89 c7                	mov    %eax,%edi
801028cd:	85 c0                	test   %eax,%eax
801028cf:	0f 84 e1 00 00 00    	je     801029b6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801028d5:	83 ec 0c             	sub    $0xc,%esp
801028d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801028db:	52                   	push   %edx
801028dc:	e8 ef 24 00 00       	call   80104dd0 <holdingsleep>
801028e1:	83 c4 10             	add    $0x10,%esp
801028e4:	85 c0                	test   %eax,%eax
801028e6:	0f 84 30 01 00 00    	je     80102a1c <namex+0x23c>
801028ec:	8b 56 08             	mov    0x8(%esi),%edx
801028ef:	85 d2                	test   %edx,%edx
801028f1:	0f 8e 25 01 00 00    	jle    80102a1c <namex+0x23c>
  releasesleep(&ip->lock);
801028f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801028fa:	83 ec 0c             	sub    $0xc,%esp
801028fd:	52                   	push   %edx
801028fe:	e8 8d 24 00 00       	call   80104d90 <releasesleep>
  iput(ip);
80102903:	89 34 24             	mov    %esi,(%esp)
80102906:	89 fe                	mov    %edi,%esi
80102908:	e8 f3 f9 ff ff       	call   80102300 <iput>
8010290d:	83 c4 10             	add    $0x10,%esp
80102910:	e9 16 ff ff ff       	jmp    8010282b <namex+0x4b>
80102915:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102918:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010291b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010291e:	83 ec 04             	sub    $0x4,%esp
80102921:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102924:	50                   	push   %eax
80102925:	53                   	push   %ebx
    name[len] = 0;
80102926:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102928:	ff 75 e4             	push   -0x1c(%ebp)
8010292b:	e8 20 28 00 00       	call   80105150 <memmove>
    name[len] = 0;
80102930:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102933:	83 c4 10             	add    $0x10,%esp
80102936:	c6 02 00             	movb   $0x0,(%edx)
80102939:	e9 41 ff ff ff       	jmp    8010287f <namex+0x9f>
8010293e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102940:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102943:	85 c0                	test   %eax,%eax
80102945:	0f 85 be 00 00 00    	jne    80102a09 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010294b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010294e:	89 f0                	mov    %esi,%eax
80102950:	5b                   	pop    %ebx
80102951:	5e                   	pop    %esi
80102952:	5f                   	pop    %edi
80102953:	5d                   	pop    %ebp
80102954:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102958:	89 df                	mov    %ebx,%edi
8010295a:	31 c0                	xor    %eax,%eax
8010295c:	eb c0                	jmp    8010291e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010295e:	ba 01 00 00 00       	mov    $0x1,%edx
80102963:	b8 01 00 00 00       	mov    $0x1,%eax
80102968:	e8 33 f4 ff ff       	call   80101da0 <iget>
8010296d:	89 c6                	mov    %eax,%esi
8010296f:	e9 b7 fe ff ff       	jmp    8010282b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102974:	83 ec 0c             	sub    $0xc,%esp
80102977:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010297a:	53                   	push   %ebx
8010297b:	e8 50 24 00 00       	call   80104dd0 <holdingsleep>
80102980:	83 c4 10             	add    $0x10,%esp
80102983:	85 c0                	test   %eax,%eax
80102985:	0f 84 91 00 00 00    	je     80102a1c <namex+0x23c>
8010298b:	8b 46 08             	mov    0x8(%esi),%eax
8010298e:	85 c0                	test   %eax,%eax
80102990:	0f 8e 86 00 00 00    	jle    80102a1c <namex+0x23c>
  releasesleep(&ip->lock);
80102996:	83 ec 0c             	sub    $0xc,%esp
80102999:	53                   	push   %ebx
8010299a:	e8 f1 23 00 00       	call   80104d90 <releasesleep>
  iput(ip);
8010299f:	89 34 24             	mov    %esi,(%esp)
      return 0;
801029a2:	31 f6                	xor    %esi,%esi
  iput(ip);
801029a4:	e8 57 f9 ff ff       	call   80102300 <iput>
      return 0;
801029a9:	83 c4 10             	add    $0x10,%esp
}
801029ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029af:	89 f0                	mov    %esi,%eax
801029b1:	5b                   	pop    %ebx
801029b2:	5e                   	pop    %esi
801029b3:	5f                   	pop    %edi
801029b4:	5d                   	pop    %ebp
801029b5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801029bc:	52                   	push   %edx
801029bd:	e8 0e 24 00 00       	call   80104dd0 <holdingsleep>
801029c2:	83 c4 10             	add    $0x10,%esp
801029c5:	85 c0                	test   %eax,%eax
801029c7:	74 53                	je     80102a1c <namex+0x23c>
801029c9:	8b 4e 08             	mov    0x8(%esi),%ecx
801029cc:	85 c9                	test   %ecx,%ecx
801029ce:	7e 4c                	jle    80102a1c <namex+0x23c>
  releasesleep(&ip->lock);
801029d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801029d3:	83 ec 0c             	sub    $0xc,%esp
801029d6:	52                   	push   %edx
801029d7:	eb c1                	jmp    8010299a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801029d9:	83 ec 0c             	sub    $0xc,%esp
801029dc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801029df:	53                   	push   %ebx
801029e0:	e8 eb 23 00 00       	call   80104dd0 <holdingsleep>
801029e5:	83 c4 10             	add    $0x10,%esp
801029e8:	85 c0                	test   %eax,%eax
801029ea:	74 30                	je     80102a1c <namex+0x23c>
801029ec:	8b 7e 08             	mov    0x8(%esi),%edi
801029ef:	85 ff                	test   %edi,%edi
801029f1:	7e 29                	jle    80102a1c <namex+0x23c>
  releasesleep(&ip->lock);
801029f3:	83 ec 0c             	sub    $0xc,%esp
801029f6:	53                   	push   %ebx
801029f7:	e8 94 23 00 00       	call   80104d90 <releasesleep>
}
801029fc:	83 c4 10             	add    $0x10,%esp
}
801029ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a02:	89 f0                	mov    %esi,%eax
80102a04:	5b                   	pop    %ebx
80102a05:	5e                   	pop    %esi
80102a06:	5f                   	pop    %edi
80102a07:	5d                   	pop    %ebp
80102a08:	c3                   	ret    
    iput(ip);
80102a09:	83 ec 0c             	sub    $0xc,%esp
80102a0c:	56                   	push   %esi
    return 0;
80102a0d:	31 f6                	xor    %esi,%esi
    iput(ip);
80102a0f:	e8 ec f8 ff ff       	call   80102300 <iput>
    return 0;
80102a14:	83 c4 10             	add    $0x10,%esp
80102a17:	e9 2f ff ff ff       	jmp    8010294b <namex+0x16b>
    panic("iunlock");
80102a1c:	83 ec 0c             	sub    $0xc,%esp
80102a1f:	68 1f 7d 10 80       	push   $0x80107d1f
80102a24:	e8 e7 d9 ff ff       	call   80100410 <panic>
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a30 <dirlink>:
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	57                   	push   %edi
80102a34:	56                   	push   %esi
80102a35:	53                   	push   %ebx
80102a36:	83 ec 20             	sub    $0x20,%esp
80102a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102a3c:	6a 00                	push   $0x0
80102a3e:	ff 75 0c             	push   0xc(%ebp)
80102a41:	53                   	push   %ebx
80102a42:	e8 e9 fc ff ff       	call   80102730 <dirlookup>
80102a47:	83 c4 10             	add    $0x10,%esp
80102a4a:	85 c0                	test   %eax,%eax
80102a4c:	75 67                	jne    80102ab5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102a4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102a51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102a54:	85 ff                	test   %edi,%edi
80102a56:	74 29                	je     80102a81 <dirlink+0x51>
80102a58:	31 ff                	xor    %edi,%edi
80102a5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102a5d:	eb 09                	jmp    80102a68 <dirlink+0x38>
80102a5f:	90                   	nop
80102a60:	83 c7 10             	add    $0x10,%edi
80102a63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102a66:	73 19                	jae    80102a81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102a68:	6a 10                	push   $0x10
80102a6a:	57                   	push   %edi
80102a6b:	56                   	push   %esi
80102a6c:	53                   	push   %ebx
80102a6d:	e8 6e fa ff ff       	call   801024e0 <readi>
80102a72:	83 c4 10             	add    $0x10,%esp
80102a75:	83 f8 10             	cmp    $0x10,%eax
80102a78:	75 4e                	jne    80102ac8 <dirlink+0x98>
    if(de.inum == 0)
80102a7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102a7f:	75 df                	jne    80102a60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102a81:	83 ec 04             	sub    $0x4,%esp
80102a84:	8d 45 da             	lea    -0x26(%ebp),%eax
80102a87:	6a 0e                	push   $0xe
80102a89:	ff 75 0c             	push   0xc(%ebp)
80102a8c:	50                   	push   %eax
80102a8d:	e8 7e 27 00 00       	call   80105210 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102a92:	6a 10                	push   $0x10
  de.inum = inum;
80102a94:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102a97:	57                   	push   %edi
80102a98:	56                   	push   %esi
80102a99:	53                   	push   %ebx
  de.inum = inum;
80102a9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102a9e:	e8 3d fb ff ff       	call   801025e0 <writei>
80102aa3:	83 c4 20             	add    $0x20,%esp
80102aa6:	83 f8 10             	cmp    $0x10,%eax
80102aa9:	75 2a                	jne    80102ad5 <dirlink+0xa5>
  return 0;
80102aab:	31 c0                	xor    %eax,%eax
}
80102aad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ab0:	5b                   	pop    %ebx
80102ab1:	5e                   	pop    %esi
80102ab2:	5f                   	pop    %edi
80102ab3:	5d                   	pop    %ebp
80102ab4:	c3                   	ret    
    iput(ip);
80102ab5:	83 ec 0c             	sub    $0xc,%esp
80102ab8:	50                   	push   %eax
80102ab9:	e8 42 f8 ff ff       	call   80102300 <iput>
    return -1;
80102abe:	83 c4 10             	add    $0x10,%esp
80102ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ac6:	eb e5                	jmp    80102aad <dirlink+0x7d>
      panic("dirlink read");
80102ac8:	83 ec 0c             	sub    $0xc,%esp
80102acb:	68 48 7d 10 80       	push   $0x80107d48
80102ad0:	e8 3b d9 ff ff       	call   80100410 <panic>
    panic("dirlink");
80102ad5:	83 ec 0c             	sub    $0xc,%esp
80102ad8:	68 1e 83 10 80       	push   $0x8010831e
80102add:	e8 2e d9 ff ff       	call   80100410 <panic>
80102ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102af0 <namei>:

struct inode*
namei(char *path)
{
80102af0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102af1:	31 d2                	xor    %edx,%edx
{
80102af3:	89 e5                	mov    %esp,%ebp
80102af5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102af8:	8b 45 08             	mov    0x8(%ebp),%eax
80102afb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102afe:	e8 dd fc ff ff       	call   801027e0 <namex>
}
80102b03:	c9                   	leave  
80102b04:	c3                   	ret    
80102b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102b10:	55                   	push   %ebp
  return namex(path, 1, name);
80102b11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102b16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102b18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102b1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102b1f:	e9 bc fc ff ff       	jmp    801027e0 <namex>
80102b24:	66 90                	xchg   %ax,%ax
80102b26:	66 90                	xchg   %ax,%ax
80102b28:	66 90                	xchg   %ax,%ax
80102b2a:	66 90                	xchg   %ax,%ax
80102b2c:	66 90                	xchg   %ax,%ax
80102b2e:	66 90                	xchg   %ax,%ax

80102b30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	57                   	push   %edi
80102b34:	56                   	push   %esi
80102b35:	53                   	push   %ebx
80102b36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102b39:	85 c0                	test   %eax,%eax
80102b3b:	0f 84 b4 00 00 00    	je     80102bf5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102b41:	8b 70 08             	mov    0x8(%eax),%esi
80102b44:	89 c3                	mov    %eax,%ebx
80102b46:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80102b4c:	0f 87 96 00 00 00    	ja     80102be8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b5e:	66 90                	xchg   %ax,%ax
80102b60:	89 ca                	mov    %ecx,%edx
80102b62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102b63:	83 e0 c0             	and    $0xffffffc0,%eax
80102b66:	3c 40                	cmp    $0x40,%al
80102b68:	75 f6                	jne    80102b60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6a:	31 ff                	xor    %edi,%edi
80102b6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102b71:	89 f8                	mov    %edi,%eax
80102b73:	ee                   	out    %al,(%dx)
80102b74:	b8 01 00 00 00       	mov    $0x1,%eax
80102b79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102b7e:	ee                   	out    %al,(%dx)
80102b7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102b84:	89 f0                	mov    %esi,%eax
80102b86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102b87:	89 f0                	mov    %esi,%eax
80102b89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102b8e:	c1 f8 08             	sar    $0x8,%eax
80102b91:	ee                   	out    %al,(%dx)
80102b92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102b97:	89 f8                	mov    %edi,%eax
80102b99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102b9a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102b9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102ba3:	c1 e0 04             	shl    $0x4,%eax
80102ba6:	83 e0 10             	and    $0x10,%eax
80102ba9:	83 c8 e0             	or     $0xffffffe0,%eax
80102bac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102bad:	f6 03 04             	testb  $0x4,(%ebx)
80102bb0:	75 16                	jne    80102bc8 <idestart+0x98>
80102bb2:	b8 20 00 00 00       	mov    $0x20,%eax
80102bb7:	89 ca                	mov    %ecx,%edx
80102bb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bbd:	5b                   	pop    %ebx
80102bbe:	5e                   	pop    %esi
80102bbf:	5f                   	pop    %edi
80102bc0:	5d                   	pop    %ebp
80102bc1:	c3                   	ret    
80102bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bc8:	b8 30 00 00 00       	mov    $0x30,%eax
80102bcd:	89 ca                	mov    %ecx,%edx
80102bcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102bd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102bd5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102bd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102bdd:	fc                   	cld    
80102bde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102be3:	5b                   	pop    %ebx
80102be4:	5e                   	pop    %esi
80102be5:	5f                   	pop    %edi
80102be6:	5d                   	pop    %ebp
80102be7:	c3                   	ret    
    panic("incorrect blockno");
80102be8:	83 ec 0c             	sub    $0xc,%esp
80102beb:	68 b4 7d 10 80       	push   $0x80107db4
80102bf0:	e8 1b d8 ff ff       	call   80100410 <panic>
    panic("idestart");
80102bf5:	83 ec 0c             	sub    $0xc,%esp
80102bf8:	68 ab 7d 10 80       	push   $0x80107dab
80102bfd:	e8 0e d8 ff ff       	call   80100410 <panic>
80102c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c10 <ideinit>:
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102c16:	68 c6 7d 10 80       	push   $0x80107dc6
80102c1b:	68 20 31 11 80       	push   $0x80113120
80102c20:	e8 fb 21 00 00       	call   80104e20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102c25:	58                   	pop    %eax
80102c26:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80102c2b:	5a                   	pop    %edx
80102c2c:	83 e8 01             	sub    $0x1,%eax
80102c2f:	50                   	push   %eax
80102c30:	6a 0e                	push   $0xe
80102c32:	e8 99 02 00 00       	call   80102ed0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102c37:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102c3f:	90                   	nop
80102c40:	ec                   	in     (%dx),%al
80102c41:	83 e0 c0             	and    $0xffffffc0,%eax
80102c44:	3c 40                	cmp    $0x40,%al
80102c46:	75 f8                	jne    80102c40 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c48:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102c4d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102c52:	ee                   	out    %al,(%dx)
80102c53:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c58:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102c5d:	eb 06                	jmp    80102c65 <ideinit+0x55>
80102c5f:	90                   	nop
  for(i=0; i<1000; i++){
80102c60:	83 e9 01             	sub    $0x1,%ecx
80102c63:	74 0f                	je     80102c74 <ideinit+0x64>
80102c65:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102c66:	84 c0                	test   %al,%al
80102c68:	74 f6                	je     80102c60 <ideinit+0x50>
      havedisk1 = 1;
80102c6a:	c7 05 00 31 11 80 01 	movl   $0x1,0x80113100
80102c71:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c74:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102c79:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102c7e:	ee                   	out    %al,(%dx)
}
80102c7f:	c9                   	leave  
80102c80:	c3                   	ret    
80102c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	57                   	push   %edi
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102c99:	68 20 31 11 80       	push   $0x80113120
80102c9e:	e8 4d 23 00 00       	call   80104ff0 <acquire>

  if((b = idequeue) == 0){
80102ca3:	8b 1d 04 31 11 80    	mov    0x80113104,%ebx
80102ca9:	83 c4 10             	add    $0x10,%esp
80102cac:	85 db                	test   %ebx,%ebx
80102cae:	74 63                	je     80102d13 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102cb0:	8b 43 58             	mov    0x58(%ebx),%eax
80102cb3:	a3 04 31 11 80       	mov    %eax,0x80113104

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102cb8:	8b 33                	mov    (%ebx),%esi
80102cba:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102cc0:	75 2f                	jne    80102cf1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cce:	66 90                	xchg   %ax,%ax
80102cd0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102cd1:	89 c1                	mov    %eax,%ecx
80102cd3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102cd6:	80 f9 40             	cmp    $0x40,%cl
80102cd9:	75 f5                	jne    80102cd0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102cdb:	a8 21                	test   $0x21,%al
80102cdd:	75 12                	jne    80102cf1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102cdf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102ce2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102ce7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102cec:	fc                   	cld    
80102ced:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102cef:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102cf1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102cf4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102cf7:	83 ce 02             	or     $0x2,%esi
80102cfa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102cfc:	53                   	push   %ebx
80102cfd:	e8 4e 1e 00 00       	call   80104b50 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102d02:	a1 04 31 11 80       	mov    0x80113104,%eax
80102d07:	83 c4 10             	add    $0x10,%esp
80102d0a:	85 c0                	test   %eax,%eax
80102d0c:	74 05                	je     80102d13 <ideintr+0x83>
    idestart(idequeue);
80102d0e:	e8 1d fe ff ff       	call   80102b30 <idestart>
    release(&idelock);
80102d13:	83 ec 0c             	sub    $0xc,%esp
80102d16:	68 20 31 11 80       	push   $0x80113120
80102d1b:	e8 70 22 00 00       	call   80104f90 <release>

  release(&idelock);
}
80102d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d23:	5b                   	pop    %ebx
80102d24:	5e                   	pop    %esi
80102d25:	5f                   	pop    %edi
80102d26:	5d                   	pop    %ebp
80102d27:	c3                   	ret    
80102d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop

80102d30 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 10             	sub    $0x10,%esp
80102d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102d3a:	8d 43 0c             	lea    0xc(%ebx),%eax
80102d3d:	50                   	push   %eax
80102d3e:	e8 8d 20 00 00       	call   80104dd0 <holdingsleep>
80102d43:	83 c4 10             	add    $0x10,%esp
80102d46:	85 c0                	test   %eax,%eax
80102d48:	0f 84 c3 00 00 00    	je     80102e11 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102d4e:	8b 03                	mov    (%ebx),%eax
80102d50:	83 e0 06             	and    $0x6,%eax
80102d53:	83 f8 02             	cmp    $0x2,%eax
80102d56:	0f 84 a8 00 00 00    	je     80102e04 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102d5c:	8b 53 04             	mov    0x4(%ebx),%edx
80102d5f:	85 d2                	test   %edx,%edx
80102d61:	74 0d                	je     80102d70 <iderw+0x40>
80102d63:	a1 00 31 11 80       	mov    0x80113100,%eax
80102d68:	85 c0                	test   %eax,%eax
80102d6a:	0f 84 87 00 00 00    	je     80102df7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	68 20 31 11 80       	push   $0x80113120
80102d78:	e8 73 22 00 00       	call   80104ff0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102d7d:	a1 04 31 11 80       	mov    0x80113104,%eax
  b->qnext = 0;
80102d82:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102d89:	83 c4 10             	add    $0x10,%esp
80102d8c:	85 c0                	test   %eax,%eax
80102d8e:	74 60                	je     80102df0 <iderw+0xc0>
80102d90:	89 c2                	mov    %eax,%edx
80102d92:	8b 40 58             	mov    0x58(%eax),%eax
80102d95:	85 c0                	test   %eax,%eax
80102d97:	75 f7                	jne    80102d90 <iderw+0x60>
80102d99:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102d9c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102d9e:	39 1d 04 31 11 80    	cmp    %ebx,0x80113104
80102da4:	74 3a                	je     80102de0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102da6:	8b 03                	mov    (%ebx),%eax
80102da8:	83 e0 06             	and    $0x6,%eax
80102dab:	83 f8 02             	cmp    $0x2,%eax
80102dae:	74 1b                	je     80102dcb <iderw+0x9b>
    sleep(b, &idelock);
80102db0:	83 ec 08             	sub    $0x8,%esp
80102db3:	68 20 31 11 80       	push   $0x80113120
80102db8:	53                   	push   %ebx
80102db9:	e8 d2 1c 00 00       	call   80104a90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102dbe:	8b 03                	mov    (%ebx),%eax
80102dc0:	83 c4 10             	add    $0x10,%esp
80102dc3:	83 e0 06             	and    $0x6,%eax
80102dc6:	83 f8 02             	cmp    $0x2,%eax
80102dc9:	75 e5                	jne    80102db0 <iderw+0x80>
  }


  release(&idelock);
80102dcb:	c7 45 08 20 31 11 80 	movl   $0x80113120,0x8(%ebp)
}
80102dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dd5:	c9                   	leave  
  release(&idelock);
80102dd6:	e9 b5 21 00 00       	jmp    80104f90 <release>
80102ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop
    idestart(b);
80102de0:	89 d8                	mov    %ebx,%eax
80102de2:	e8 49 fd ff ff       	call   80102b30 <idestart>
80102de7:	eb bd                	jmp    80102da6 <iderw+0x76>
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102df0:	ba 04 31 11 80       	mov    $0x80113104,%edx
80102df5:	eb a5                	jmp    80102d9c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102df7:	83 ec 0c             	sub    $0xc,%esp
80102dfa:	68 f5 7d 10 80       	push   $0x80107df5
80102dff:	e8 0c d6 ff ff       	call   80100410 <panic>
    panic("iderw: nothing to do");
80102e04:	83 ec 0c             	sub    $0xc,%esp
80102e07:	68 e0 7d 10 80       	push   $0x80107de0
80102e0c:	e8 ff d5 ff ff       	call   80100410 <panic>
    panic("iderw: buf not locked");
80102e11:	83 ec 0c             	sub    $0xc,%esp
80102e14:	68 ca 7d 10 80       	push   $0x80107dca
80102e19:	e8 f2 d5 ff ff       	call   80100410 <panic>
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102e20:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102e21:	c7 05 54 31 11 80 00 	movl   $0xfec00000,0x80113154
80102e28:	00 c0 fe 
{
80102e2b:	89 e5                	mov    %esp,%ebp
80102e2d:	56                   	push   %esi
80102e2e:	53                   	push   %ebx
  ioapic->reg = reg;
80102e2f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102e36:	00 00 00 
  return ioapic->data;
80102e39:	8b 15 54 31 11 80    	mov    0x80113154,%edx
80102e3f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102e42:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102e48:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102e4e:	0f b6 15 a0 32 11 80 	movzbl 0x801132a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102e55:	c1 ee 10             	shr    $0x10,%esi
80102e58:	89 f0                	mov    %esi,%eax
80102e5a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102e5d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102e60:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102e63:	39 c2                	cmp    %eax,%edx
80102e65:	74 16                	je     80102e7d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102e67:	83 ec 0c             	sub    $0xc,%esp
80102e6a:	68 14 7e 10 80       	push   $0x80107e14
80102e6f:	e8 1c d9 ff ff       	call   80100790 <cprintf>
  ioapic->reg = reg;
80102e74:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
80102e7a:	83 c4 10             	add    $0x10,%esp
80102e7d:	83 c6 21             	add    $0x21,%esi
{
80102e80:	ba 10 00 00 00       	mov    $0x10,%edx
80102e85:	b8 20 00 00 00       	mov    $0x20,%eax
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102e90:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e92:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102e94:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
  for(i = 0; i <= maxintr; i++){
80102e9a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e9d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102ea3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102ea6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102ea9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102eac:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102eae:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
80102eb4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102ebb:	39 f0                	cmp    %esi,%eax
80102ebd:	75 d1                	jne    80102e90 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ec2:	5b                   	pop    %ebx
80102ec3:	5e                   	pop    %esi
80102ec4:	5d                   	pop    %ebp
80102ec5:	c3                   	ret    
80102ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ecd:	8d 76 00             	lea    0x0(%esi),%esi

80102ed0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ed0:	55                   	push   %ebp
  ioapic->reg = reg;
80102ed1:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
{
80102ed7:	89 e5                	mov    %esp,%ebp
80102ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102edc:	8d 50 20             	lea    0x20(%eax),%edx
80102edf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ee3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ee5:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102eeb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102eee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ef4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ef6:	a1 54 31 11 80       	mov    0x80113154,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102efb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102efe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102f01:	5d                   	pop    %ebp
80102f02:	c3                   	ret    
80102f03:	66 90                	xchg   %ax,%ax
80102f05:	66 90                	xchg   %ax,%ax
80102f07:	66 90                	xchg   %ax,%ax
80102f09:	66 90                	xchg   %ax,%ax
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 04             	sub    $0x4,%esp
80102f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102f1a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102f20:	75 76                	jne    80102f98 <kfree+0x88>
80102f22:	81 fb f0 6f 11 80    	cmp    $0x80116ff0,%ebx
80102f28:	72 6e                	jb     80102f98 <kfree+0x88>
80102f2a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102f30:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f35:	77 61                	ja     80102f98 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f37:	83 ec 04             	sub    $0x4,%esp
80102f3a:	68 00 10 00 00       	push   $0x1000
80102f3f:	6a 01                	push   $0x1
80102f41:	53                   	push   %ebx
80102f42:	e8 69 21 00 00       	call   801050b0 <memset>

  if(kmem.use_lock)
80102f47:	8b 15 94 31 11 80    	mov    0x80113194,%edx
80102f4d:	83 c4 10             	add    $0x10,%esp
80102f50:	85 d2                	test   %edx,%edx
80102f52:	75 1c                	jne    80102f70 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102f54:	a1 98 31 11 80       	mov    0x80113198,%eax
80102f59:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102f5b:	a1 94 31 11 80       	mov    0x80113194,%eax
  kmem.freelist = r;
80102f60:	89 1d 98 31 11 80    	mov    %ebx,0x80113198
  if(kmem.use_lock)
80102f66:	85 c0                	test   %eax,%eax
80102f68:	75 1e                	jne    80102f88 <kfree+0x78>
    release(&kmem.lock);
}
80102f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f6d:	c9                   	leave  
80102f6e:	c3                   	ret    
80102f6f:	90                   	nop
    acquire(&kmem.lock);
80102f70:	83 ec 0c             	sub    $0xc,%esp
80102f73:	68 60 31 11 80       	push   $0x80113160
80102f78:	e8 73 20 00 00       	call   80104ff0 <acquire>
80102f7d:	83 c4 10             	add    $0x10,%esp
80102f80:	eb d2                	jmp    80102f54 <kfree+0x44>
80102f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102f88:	c7 45 08 60 31 11 80 	movl   $0x80113160,0x8(%ebp)
}
80102f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f92:	c9                   	leave  
    release(&kmem.lock);
80102f93:	e9 f8 1f 00 00       	jmp    80104f90 <release>
    panic("kfree");
80102f98:	83 ec 0c             	sub    $0xc,%esp
80102f9b:	68 46 7e 10 80       	push   $0x80107e46
80102fa0:	e8 6b d4 ff ff       	call   80100410 <panic>
80102fa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <freerange>:
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102fb4:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102fb7:	8b 75 0c             	mov    0xc(%ebp),%esi
80102fba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102fbb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102fc1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102fc7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102fcd:	39 de                	cmp    %ebx,%esi
80102fcf:	72 23                	jb     80102ff4 <freerange+0x44>
80102fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102fd8:	83 ec 0c             	sub    $0xc,%esp
80102fdb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102fe1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102fe7:	50                   	push   %eax
80102fe8:	e8 23 ff ff ff       	call   80102f10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102fed:	83 c4 10             	add    $0x10,%esp
80102ff0:	39 f3                	cmp    %esi,%ebx
80102ff2:	76 e4                	jbe    80102fd8 <freerange+0x28>
}
80102ff4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ff7:	5b                   	pop    %ebx
80102ff8:	5e                   	pop    %esi
80102ff9:	5d                   	pop    %ebp
80102ffa:	c3                   	ret    
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop

80103000 <kinit2>:
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103004:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103007:	8b 75 0c             	mov    0xc(%ebp),%esi
8010300a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010300b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103011:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103017:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010301d:	39 de                	cmp    %ebx,%esi
8010301f:	72 23                	jb     80103044 <kinit2+0x44>
80103021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103028:	83 ec 0c             	sub    $0xc,%esp
8010302b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103031:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103037:	50                   	push   %eax
80103038:	e8 d3 fe ff ff       	call   80102f10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010303d:	83 c4 10             	add    $0x10,%esp
80103040:	39 de                	cmp    %ebx,%esi
80103042:	73 e4                	jae    80103028 <kinit2+0x28>
  kmem.use_lock = 1;
80103044:	c7 05 94 31 11 80 01 	movl   $0x1,0x80113194
8010304b:	00 00 00 
}
8010304e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103051:	5b                   	pop    %ebx
80103052:	5e                   	pop    %esi
80103053:	5d                   	pop    %ebp
80103054:	c3                   	ret    
80103055:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010305c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103060 <kinit1>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	56                   	push   %esi
80103064:	53                   	push   %ebx
80103065:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103068:	83 ec 08             	sub    $0x8,%esp
8010306b:	68 4c 7e 10 80       	push   $0x80107e4c
80103070:	68 60 31 11 80       	push   $0x80113160
80103075:	e8 a6 1d 00 00       	call   80104e20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010307a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010307d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103080:	c7 05 94 31 11 80 00 	movl   $0x0,0x80113194
80103087:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010308a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103090:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103096:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010309c:	39 de                	cmp    %ebx,%esi
8010309e:	72 1c                	jb     801030bc <kinit1+0x5c>
    kfree(p);
801030a0:	83 ec 0c             	sub    $0xc,%esp
801030a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801030af:	50                   	push   %eax
801030b0:	e8 5b fe ff ff       	call   80102f10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030b5:	83 c4 10             	add    $0x10,%esp
801030b8:	39 de                	cmp    %ebx,%esi
801030ba:	73 e4                	jae    801030a0 <kinit1+0x40>
}
801030bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5d                   	pop    %ebp
801030c2:	c3                   	ret    
801030c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801030d0:	a1 94 31 11 80       	mov    0x80113194,%eax
801030d5:	85 c0                	test   %eax,%eax
801030d7:	75 1f                	jne    801030f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801030d9:	a1 98 31 11 80       	mov    0x80113198,%eax
  if(r)
801030de:	85 c0                	test   %eax,%eax
801030e0:	74 0e                	je     801030f0 <kalloc+0x20>
    kmem.freelist = r->next;
801030e2:	8b 10                	mov    (%eax),%edx
801030e4:	89 15 98 31 11 80    	mov    %edx,0x80113198
  if(kmem.use_lock)
801030ea:	c3                   	ret    
801030eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801030f0:	c3                   	ret    
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801030f8:	55                   	push   %ebp
801030f9:	89 e5                	mov    %esp,%ebp
801030fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801030fe:	68 60 31 11 80       	push   $0x80113160
80103103:	e8 e8 1e 00 00       	call   80104ff0 <acquire>
  r = kmem.freelist;
80103108:	a1 98 31 11 80       	mov    0x80113198,%eax
  if(kmem.use_lock)
8010310d:	8b 15 94 31 11 80    	mov    0x80113194,%edx
  if(r)
80103113:	83 c4 10             	add    $0x10,%esp
80103116:	85 c0                	test   %eax,%eax
80103118:	74 08                	je     80103122 <kalloc+0x52>
    kmem.freelist = r->next;
8010311a:	8b 08                	mov    (%eax),%ecx
8010311c:	89 0d 98 31 11 80    	mov    %ecx,0x80113198
  if(kmem.use_lock)
80103122:	85 d2                	test   %edx,%edx
80103124:	74 16                	je     8010313c <kalloc+0x6c>
    release(&kmem.lock);
80103126:	83 ec 0c             	sub    $0xc,%esp
80103129:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010312c:	68 60 31 11 80       	push   $0x80113160
80103131:	e8 5a 1e 00 00       	call   80104f90 <release>
  return (char*)r;
80103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103139:	83 c4 10             	add    $0x10,%esp
}
8010313c:	c9                   	leave  
8010313d:	c3                   	ret    
8010313e:	66 90                	xchg   %ax,%ax

80103140 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103140:	ba 64 00 00 00       	mov    $0x64,%edx
80103145:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103146:	a8 01                	test   $0x1,%al
80103148:	0f 84 c2 00 00 00    	je     80103210 <kbdgetc+0xd0>
{
8010314e:	55                   	push   %ebp
8010314f:	ba 60 00 00 00       	mov    $0x60,%edx
80103154:	89 e5                	mov    %esp,%ebp
80103156:	53                   	push   %ebx
80103157:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103158:	8b 1d 9c 31 11 80    	mov    0x8011319c,%ebx
  data = inb(KBDATAP);
8010315e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103161:	3c e0                	cmp    $0xe0,%al
80103163:	74 5b                	je     801031c0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103165:	89 da                	mov    %ebx,%edx
80103167:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010316a:	84 c0                	test   %al,%al
8010316c:	78 62                	js     801031d0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010316e:	85 d2                	test   %edx,%edx
80103170:	74 09                	je     8010317b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103172:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103175:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103178:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010317b:	0f b6 91 80 7f 10 80 	movzbl -0x7fef8080(%ecx),%edx
  shift ^= togglecode[data];
80103182:	0f b6 81 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%eax
  shift |= shiftcode[data];
80103189:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010318b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010318d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010318f:	89 15 9c 31 11 80    	mov    %edx,0x8011319c
  c = charcode[shift & (CTL | SHIFT)][data];
80103195:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103198:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010319b:	8b 04 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%eax
801031a2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801031a6:	74 0b                	je     801031b3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801031a8:	8d 50 9f             	lea    -0x61(%eax),%edx
801031ab:	83 fa 19             	cmp    $0x19,%edx
801031ae:	77 48                	ja     801031f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801031b0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801031b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031b6:	c9                   	leave  
801031b7:	c3                   	ret    
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
    shift |= E0ESC;
801031c0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801031c3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801031c5:	89 1d 9c 31 11 80    	mov    %ebx,0x8011319c
}
801031cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031ce:	c9                   	leave  
801031cf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801031d0:	83 e0 7f             	and    $0x7f,%eax
801031d3:	85 d2                	test   %edx,%edx
801031d5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801031d8:	0f b6 81 80 7f 10 80 	movzbl -0x7fef8080(%ecx),%eax
801031df:	83 c8 40             	or     $0x40,%eax
801031e2:	0f b6 c0             	movzbl %al,%eax
801031e5:	f7 d0                	not    %eax
801031e7:	21 d8                	and    %ebx,%eax
}
801031e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801031ec:	a3 9c 31 11 80       	mov    %eax,0x8011319c
    return 0;
801031f1:	31 c0                	xor    %eax,%eax
}
801031f3:	c9                   	leave  
801031f4:	c3                   	ret    
801031f5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801031f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801031fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801031fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103201:	c9                   	leave  
      c += 'a' - 'A';
80103202:	83 f9 1a             	cmp    $0x1a,%ecx
80103205:	0f 42 c2             	cmovb  %edx,%eax
}
80103208:	c3                   	ret    
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103215:	c3                   	ret    
80103216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321d:	8d 76 00             	lea    0x0(%esi),%esi

80103220 <kbdintr>:

void
kbdintr(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103226:	68 40 31 10 80       	push   $0x80103140
8010322b:	e8 70 de ff ff       	call   801010a0 <consoleintr>
}
80103230:	83 c4 10             	add    $0x10,%esp
80103233:	c9                   	leave  
80103234:	c3                   	ret    
80103235:	66 90                	xchg   %ax,%ax
80103237:	66 90                	xchg   %ax,%ax
80103239:	66 90                	xchg   %ax,%ax
8010323b:	66 90                	xchg   %ax,%ax
8010323d:	66 90                	xchg   %ax,%ax
8010323f:	90                   	nop

80103240 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103240:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80103245:	85 c0                	test   %eax,%eax
80103247:	0f 84 cb 00 00 00    	je     80103318 <lapicinit+0xd8>
  lapic[index] = value;
8010324d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103254:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103257:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010325a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103261:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103264:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103267:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010326e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103271:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103274:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010327b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010327e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103281:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103288:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010328b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010328e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103295:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103298:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010329b:	8b 50 30             	mov    0x30(%eax),%edx
8010329e:	c1 ea 10             	shr    $0x10,%edx
801032a1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801032a7:	75 77                	jne    80103320 <lapicinit+0xe0>
  lapic[index] = value;
801032a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801032b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801032bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801032ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801032d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801032e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801032f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801032f4:	8b 50 20             	mov    0x20(%eax),%edx
801032f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032fe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103300:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103306:	80 e6 10             	and    $0x10,%dh
80103309:	75 f5                	jne    80103300 <lapicinit+0xc0>
  lapic[index] = value;
8010330b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103312:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103315:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103318:	c3                   	ret    
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103320:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103327:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010332a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010332d:	e9 77 ff ff ff       	jmp    801032a9 <lapicinit+0x69>
80103332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103340 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103340:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80103345:	85 c0                	test   %eax,%eax
80103347:	74 07                	je     80103350 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103349:	8b 40 20             	mov    0x20(%eax),%eax
8010334c:	c1 e8 18             	shr    $0x18,%eax
8010334f:	c3                   	ret    
    return 0;
80103350:	31 c0                	xor    %eax,%eax
}
80103352:	c3                   	ret    
80103353:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103360 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103360:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80103365:	85 c0                	test   %eax,%eax
80103367:	74 0d                	je     80103376 <lapiceoi+0x16>
  lapic[index] = value;
80103369:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103370:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103373:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103376:	c3                   	ret    
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax

80103380 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103380:	c3                   	ret    
80103381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338f:	90                   	nop

80103390 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103390:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103391:	b8 0f 00 00 00       	mov    $0xf,%eax
80103396:	ba 70 00 00 00       	mov    $0x70,%edx
8010339b:	89 e5                	mov    %esp,%ebp
8010339d:	53                   	push   %ebx
8010339e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033a4:	ee                   	out    %al,(%dx)
801033a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801033aa:	ba 71 00 00 00       	mov    $0x71,%edx
801033af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801033b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801033b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801033bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801033bd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801033c0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801033c2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801033c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801033c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801033ce:	a1 a0 31 11 80       	mov    0x801131a0,%eax
801033d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801033d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801033e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801033e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801033f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801033f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801033fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103405:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103408:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010340e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103411:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103417:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010341a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010341d:	c9                   	leave  
8010341e:	c3                   	ret    
8010341f:	90                   	nop

80103420 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103420:	55                   	push   %ebp
80103421:	b8 0b 00 00 00       	mov    $0xb,%eax
80103426:	ba 70 00 00 00       	mov    $0x70,%edx
8010342b:	89 e5                	mov    %esp,%ebp
8010342d:	57                   	push   %edi
8010342e:	56                   	push   %esi
8010342f:	53                   	push   %ebx
80103430:	83 ec 4c             	sub    $0x4c,%esp
80103433:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103434:	ba 71 00 00 00       	mov    $0x71,%edx
80103439:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010343a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010343d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103442:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103445:	8d 76 00             	lea    0x0(%esi),%esi
80103448:	31 c0                	xor    %eax,%eax
8010344a:	89 da                	mov    %ebx,%edx
8010344c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010344d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103452:	89 ca                	mov    %ecx,%edx
80103454:	ec                   	in     (%dx),%al
80103455:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103458:	89 da                	mov    %ebx,%edx
8010345a:	b8 02 00 00 00       	mov    $0x2,%eax
8010345f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103460:	89 ca                	mov    %ecx,%edx
80103462:	ec                   	in     (%dx),%al
80103463:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103466:	89 da                	mov    %ebx,%edx
80103468:	b8 04 00 00 00       	mov    $0x4,%eax
8010346d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010346e:	89 ca                	mov    %ecx,%edx
80103470:	ec                   	in     (%dx),%al
80103471:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103474:	89 da                	mov    %ebx,%edx
80103476:	b8 07 00 00 00       	mov    $0x7,%eax
8010347b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010347c:	89 ca                	mov    %ecx,%edx
8010347e:	ec                   	in     (%dx),%al
8010347f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103482:	89 da                	mov    %ebx,%edx
80103484:	b8 08 00 00 00       	mov    $0x8,%eax
80103489:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010348a:	89 ca                	mov    %ecx,%edx
8010348c:	ec                   	in     (%dx),%al
8010348d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010348f:	89 da                	mov    %ebx,%edx
80103491:	b8 09 00 00 00       	mov    $0x9,%eax
80103496:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103497:	89 ca                	mov    %ecx,%edx
80103499:	ec                   	in     (%dx),%al
8010349a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010349c:	89 da                	mov    %ebx,%edx
8010349e:	b8 0a 00 00 00       	mov    $0xa,%eax
801034a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034a4:	89 ca                	mov    %ecx,%edx
801034a6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801034a7:	84 c0                	test   %al,%al
801034a9:	78 9d                	js     80103448 <cmostime+0x28>
  return inb(CMOS_RETURN);
801034ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801034af:	89 fa                	mov    %edi,%edx
801034b1:	0f b6 fa             	movzbl %dl,%edi
801034b4:	89 f2                	mov    %esi,%edx
801034b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801034b9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801034bd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034c0:	89 da                	mov    %ebx,%edx
801034c2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801034c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801034c8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801034cc:	89 75 cc             	mov    %esi,-0x34(%ebp)
801034cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801034d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801034d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801034d9:	31 c0                	xor    %eax,%eax
801034db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034dc:	89 ca                	mov    %ecx,%edx
801034de:	ec                   	in     (%dx),%al
801034df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e2:	89 da                	mov    %ebx,%edx
801034e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801034e7:	b8 02 00 00 00       	mov    $0x2,%eax
801034ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034ed:	89 ca                	mov    %ecx,%edx
801034ef:	ec                   	in     (%dx),%al
801034f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f3:	89 da                	mov    %ebx,%edx
801034f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801034f8:	b8 04 00 00 00       	mov    $0x4,%eax
801034fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034fe:	89 ca                	mov    %ecx,%edx
80103500:	ec                   	in     (%dx),%al
80103501:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103504:	89 da                	mov    %ebx,%edx
80103506:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103509:	b8 07 00 00 00       	mov    $0x7,%eax
8010350e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010350f:	89 ca                	mov    %ecx,%edx
80103511:	ec                   	in     (%dx),%al
80103512:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103515:	89 da                	mov    %ebx,%edx
80103517:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010351a:	b8 08 00 00 00       	mov    $0x8,%eax
8010351f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103520:	89 ca                	mov    %ecx,%edx
80103522:	ec                   	in     (%dx),%al
80103523:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103526:	89 da                	mov    %ebx,%edx
80103528:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010352b:	b8 09 00 00 00       	mov    $0x9,%eax
80103530:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103531:	89 ca                	mov    %ecx,%edx
80103533:	ec                   	in     (%dx),%al
80103534:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103537:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010353a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010353d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103540:	6a 18                	push   $0x18
80103542:	50                   	push   %eax
80103543:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103546:	50                   	push   %eax
80103547:	e8 b4 1b 00 00       	call   80105100 <memcmp>
8010354c:	83 c4 10             	add    $0x10,%esp
8010354f:	85 c0                	test   %eax,%eax
80103551:	0f 85 f1 fe ff ff    	jne    80103448 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103557:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010355b:	75 78                	jne    801035d5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010355d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103560:	89 c2                	mov    %eax,%edx
80103562:	83 e0 0f             	and    $0xf,%eax
80103565:	c1 ea 04             	shr    $0x4,%edx
80103568:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010356b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010356e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103571:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103574:	89 c2                	mov    %eax,%edx
80103576:	83 e0 0f             	and    $0xf,%eax
80103579:	c1 ea 04             	shr    $0x4,%edx
8010357c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010357f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103582:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103585:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103588:	89 c2                	mov    %eax,%edx
8010358a:	83 e0 0f             	and    $0xf,%eax
8010358d:	c1 ea 04             	shr    $0x4,%edx
80103590:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103593:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103596:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103599:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010359c:	89 c2                	mov    %eax,%edx
8010359e:	83 e0 0f             	and    $0xf,%eax
801035a1:	c1 ea 04             	shr    $0x4,%edx
801035a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801035ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801035b0:	89 c2                	mov    %eax,%edx
801035b2:	83 e0 0f             	and    $0xf,%eax
801035b5:	c1 ea 04             	shr    $0x4,%edx
801035b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801035c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801035c4:	89 c2                	mov    %eax,%edx
801035c6:	83 e0 0f             	and    $0xf,%eax
801035c9:	c1 ea 04             	shr    $0x4,%edx
801035cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801035d5:	8b 75 08             	mov    0x8(%ebp),%esi
801035d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801035db:	89 06                	mov    %eax,(%esi)
801035dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801035e0:	89 46 04             	mov    %eax,0x4(%esi)
801035e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801035e6:	89 46 08             	mov    %eax,0x8(%esi)
801035e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801035ec:	89 46 0c             	mov    %eax,0xc(%esi)
801035ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801035f2:	89 46 10             	mov    %eax,0x10(%esi)
801035f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801035f8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801035fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103602:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103605:	5b                   	pop    %ebx
80103606:	5e                   	pop    %esi
80103607:	5f                   	pop    %edi
80103608:	5d                   	pop    %ebp
80103609:	c3                   	ret    
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103610:	8b 0d 08 32 11 80    	mov    0x80113208,%ecx
80103616:	85 c9                	test   %ecx,%ecx
80103618:	0f 8e 8a 00 00 00    	jle    801036a8 <install_trans+0x98>
{
8010361e:	55                   	push   %ebp
8010361f:	89 e5                	mov    %esp,%ebp
80103621:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103622:	31 ff                	xor    %edi,%edi
{
80103624:	56                   	push   %esi
80103625:	53                   	push   %ebx
80103626:	83 ec 0c             	sub    $0xc,%esp
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103630:	a1 f4 31 11 80       	mov    0x801131f4,%eax
80103635:	83 ec 08             	sub    $0x8,%esp
80103638:	01 f8                	add    %edi,%eax
8010363a:	83 c0 01             	add    $0x1,%eax
8010363d:	50                   	push   %eax
8010363e:	ff 35 04 32 11 80    	push   0x80113204
80103644:	e8 87 ca ff ff       	call   801000d0 <bread>
80103649:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010364b:	58                   	pop    %eax
8010364c:	5a                   	pop    %edx
8010364d:	ff 34 bd 0c 32 11 80 	push   -0x7feecdf4(,%edi,4)
80103654:	ff 35 04 32 11 80    	push   0x80113204
  for (tail = 0; tail < log.lh.n; tail++) {
8010365a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010365d:	e8 6e ca ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103662:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103665:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103667:	8d 46 5c             	lea    0x5c(%esi),%eax
8010366a:	68 00 02 00 00       	push   $0x200
8010366f:	50                   	push   %eax
80103670:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103673:	50                   	push   %eax
80103674:	e8 d7 1a 00 00       	call   80105150 <memmove>
    bwrite(dbuf);  // write dst to disk
80103679:	89 1c 24             	mov    %ebx,(%esp)
8010367c:	e8 2f cb ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103681:	89 34 24             	mov    %esi,(%esp)
80103684:	e8 67 cb ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103689:	89 1c 24             	mov    %ebx,(%esp)
8010368c:	e8 5f cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	39 3d 08 32 11 80    	cmp    %edi,0x80113208
8010369a:	7f 94                	jg     80103630 <install_trans+0x20>
  }
}
8010369c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369f:	5b                   	pop    %ebx
801036a0:	5e                   	pop    %esi
801036a1:	5f                   	pop    %edi
801036a2:	5d                   	pop    %ebp
801036a3:	c3                   	ret    
801036a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036a8:	c3                   	ret    
801036a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036b0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
801036b4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801036b7:	ff 35 f4 31 11 80    	push   0x801131f4
801036bd:	ff 35 04 32 11 80    	push   0x80113204
801036c3:	e8 08 ca ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801036c8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801036cb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801036cd:	a1 08 32 11 80       	mov    0x80113208,%eax
801036d2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801036d5:	85 c0                	test   %eax,%eax
801036d7:	7e 19                	jle    801036f2 <write_head+0x42>
801036d9:	31 d2                	xor    %edx,%edx
801036db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036df:	90                   	nop
    hb->block[i] = log.lh.block[i];
801036e0:	8b 0c 95 0c 32 11 80 	mov    -0x7feecdf4(,%edx,4),%ecx
801036e7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801036eb:	83 c2 01             	add    $0x1,%edx
801036ee:	39 d0                	cmp    %edx,%eax
801036f0:	75 ee                	jne    801036e0 <write_head+0x30>
  }
  bwrite(buf);
801036f2:	83 ec 0c             	sub    $0xc,%esp
801036f5:	53                   	push   %ebx
801036f6:	e8 b5 ca ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801036fb:	89 1c 24             	mov    %ebx,(%esp)
801036fe:	e8 ed ca ff ff       	call   801001f0 <brelse>
}
80103703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103706:	83 c4 10             	add    $0x10,%esp
80103709:	c9                   	leave  
8010370a:	c3                   	ret    
8010370b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop

80103710 <initlog>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 2c             	sub    $0x2c,%esp
80103717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010371a:	68 80 80 10 80       	push   $0x80108080
8010371f:	68 c0 31 11 80       	push   $0x801131c0
80103724:	e8 f7 16 00 00       	call   80104e20 <initlock>
  readsb(dev, &sb);
80103729:	58                   	pop    %eax
8010372a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010372d:	5a                   	pop    %edx
8010372e:	50                   	push   %eax
8010372f:	53                   	push   %ebx
80103730:	e8 3b e8 ff ff       	call   80101f70 <readsb>
  log.start = sb.logstart;
80103735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103738:	59                   	pop    %ecx
  log.dev = dev;
80103739:	89 1d 04 32 11 80    	mov    %ebx,0x80113204
  log.size = sb.nlog;
8010373f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103742:	a3 f4 31 11 80       	mov    %eax,0x801131f4
  log.size = sb.nlog;
80103747:	89 15 f8 31 11 80    	mov    %edx,0x801131f8
  struct buf *buf = bread(log.dev, log.start);
8010374d:	5a                   	pop    %edx
8010374e:	50                   	push   %eax
8010374f:	53                   	push   %ebx
80103750:	e8 7b c9 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103755:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103758:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010375b:	89 1d 08 32 11 80    	mov    %ebx,0x80113208
  for (i = 0; i < log.lh.n; i++) {
80103761:	85 db                	test   %ebx,%ebx
80103763:	7e 1d                	jle    80103782 <initlog+0x72>
80103765:	31 d2                	xor    %edx,%edx
80103767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103770:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103774:	89 0c 95 0c 32 11 80 	mov    %ecx,-0x7feecdf4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010377b:	83 c2 01             	add    $0x1,%edx
8010377e:	39 d3                	cmp    %edx,%ebx
80103780:	75 ee                	jne    80103770 <initlog+0x60>
  brelse(buf);
80103782:	83 ec 0c             	sub    $0xc,%esp
80103785:	50                   	push   %eax
80103786:	e8 65 ca ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010378b:	e8 80 fe ff ff       	call   80103610 <install_trans>
  log.lh.n = 0;
80103790:	c7 05 08 32 11 80 00 	movl   $0x0,0x80113208
80103797:	00 00 00 
  write_head(); // clear the log
8010379a:	e8 11 ff ff ff       	call   801036b0 <write_head>
}
8010379f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037a2:	83 c4 10             	add    $0x10,%esp
801037a5:	c9                   	leave  
801037a6:	c3                   	ret    
801037a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801037b6:	68 c0 31 11 80       	push   $0x801131c0
801037bb:	e8 30 18 00 00       	call   80104ff0 <acquire>
801037c0:	83 c4 10             	add    $0x10,%esp
801037c3:	eb 18                	jmp    801037dd <begin_op+0x2d>
801037c5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801037c8:	83 ec 08             	sub    $0x8,%esp
801037cb:	68 c0 31 11 80       	push   $0x801131c0
801037d0:	68 c0 31 11 80       	push   $0x801131c0
801037d5:	e8 b6 12 00 00       	call   80104a90 <sleep>
801037da:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801037dd:	a1 00 32 11 80       	mov    0x80113200,%eax
801037e2:	85 c0                	test   %eax,%eax
801037e4:	75 e2                	jne    801037c8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801037e6:	a1 fc 31 11 80       	mov    0x801131fc,%eax
801037eb:	8b 15 08 32 11 80    	mov    0x80113208,%edx
801037f1:	83 c0 01             	add    $0x1,%eax
801037f4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801037f7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801037fa:	83 fa 1e             	cmp    $0x1e,%edx
801037fd:	7f c9                	jg     801037c8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801037ff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103802:	a3 fc 31 11 80       	mov    %eax,0x801131fc
      release(&log.lock);
80103807:	68 c0 31 11 80       	push   $0x801131c0
8010380c:	e8 7f 17 00 00       	call   80104f90 <release>
      break;
    }
  }
}
80103811:	83 c4 10             	add    $0x10,%esp
80103814:	c9                   	leave  
80103815:	c3                   	ret    
80103816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010381d:	8d 76 00             	lea    0x0(%esi),%esi

80103820 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
80103826:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103829:	68 c0 31 11 80       	push   $0x801131c0
8010382e:	e8 bd 17 00 00       	call   80104ff0 <acquire>
  log.outstanding -= 1;
80103833:	a1 fc 31 11 80       	mov    0x801131fc,%eax
  if(log.committing)
80103838:	8b 35 00 32 11 80    	mov    0x80113200,%esi
8010383e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103841:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103844:	89 1d fc 31 11 80    	mov    %ebx,0x801131fc
  if(log.committing)
8010384a:	85 f6                	test   %esi,%esi
8010384c:	0f 85 22 01 00 00    	jne    80103974 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103852:	85 db                	test   %ebx,%ebx
80103854:	0f 85 f6 00 00 00    	jne    80103950 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010385a:	c7 05 00 32 11 80 01 	movl   $0x1,0x80113200
80103861:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103864:	83 ec 0c             	sub    $0xc,%esp
80103867:	68 c0 31 11 80       	push   $0x801131c0
8010386c:	e8 1f 17 00 00       	call   80104f90 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103871:	8b 0d 08 32 11 80    	mov    0x80113208,%ecx
80103877:	83 c4 10             	add    $0x10,%esp
8010387a:	85 c9                	test   %ecx,%ecx
8010387c:	7f 42                	jg     801038c0 <end_op+0xa0>
    acquire(&log.lock);
8010387e:	83 ec 0c             	sub    $0xc,%esp
80103881:	68 c0 31 11 80       	push   $0x801131c0
80103886:	e8 65 17 00 00       	call   80104ff0 <acquire>
    wakeup(&log);
8010388b:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
    log.committing = 0;
80103892:	c7 05 00 32 11 80 00 	movl   $0x0,0x80113200
80103899:	00 00 00 
    wakeup(&log);
8010389c:	e8 af 12 00 00       	call   80104b50 <wakeup>
    release(&log.lock);
801038a1:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
801038a8:	e8 e3 16 00 00       	call   80104f90 <release>
801038ad:	83 c4 10             	add    $0x10,%esp
}
801038b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b3:	5b                   	pop    %ebx
801038b4:	5e                   	pop    %esi
801038b5:	5f                   	pop    %edi
801038b6:	5d                   	pop    %ebp
801038b7:	c3                   	ret    
801038b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801038c0:	a1 f4 31 11 80       	mov    0x801131f4,%eax
801038c5:	83 ec 08             	sub    $0x8,%esp
801038c8:	01 d8                	add    %ebx,%eax
801038ca:	83 c0 01             	add    $0x1,%eax
801038cd:	50                   	push   %eax
801038ce:	ff 35 04 32 11 80    	push   0x80113204
801038d4:	e8 f7 c7 ff ff       	call   801000d0 <bread>
801038d9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801038db:	58                   	pop    %eax
801038dc:	5a                   	pop    %edx
801038dd:	ff 34 9d 0c 32 11 80 	push   -0x7feecdf4(,%ebx,4)
801038e4:	ff 35 04 32 11 80    	push   0x80113204
  for (tail = 0; tail < log.lh.n; tail++) {
801038ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801038ed:	e8 de c7 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801038f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801038f5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801038f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801038fa:	68 00 02 00 00       	push   $0x200
801038ff:	50                   	push   %eax
80103900:	8d 46 5c             	lea    0x5c(%esi),%eax
80103903:	50                   	push   %eax
80103904:	e8 47 18 00 00       	call   80105150 <memmove>
    bwrite(to);  // write the log
80103909:	89 34 24             	mov    %esi,(%esp)
8010390c:	e8 9f c8 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103911:	89 3c 24             	mov    %edi,(%esp)
80103914:	e8 d7 c8 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103919:	89 34 24             	mov    %esi,(%esp)
8010391c:	e8 cf c8 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103921:	83 c4 10             	add    $0x10,%esp
80103924:	3b 1d 08 32 11 80    	cmp    0x80113208,%ebx
8010392a:	7c 94                	jl     801038c0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010392c:	e8 7f fd ff ff       	call   801036b0 <write_head>
    install_trans(); // Now install writes to home locations
80103931:	e8 da fc ff ff       	call   80103610 <install_trans>
    log.lh.n = 0;
80103936:	c7 05 08 32 11 80 00 	movl   $0x0,0x80113208
8010393d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103940:	e8 6b fd ff ff       	call   801036b0 <write_head>
80103945:	e9 34 ff ff ff       	jmp    8010387e <end_op+0x5e>
8010394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	68 c0 31 11 80       	push   $0x801131c0
80103958:	e8 f3 11 00 00       	call   80104b50 <wakeup>
  release(&log.lock);
8010395d:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
80103964:	e8 27 16 00 00       	call   80104f90 <release>
80103969:	83 c4 10             	add    $0x10,%esp
}
8010396c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010396f:	5b                   	pop    %ebx
80103970:	5e                   	pop    %esi
80103971:	5f                   	pop    %edi
80103972:	5d                   	pop    %ebp
80103973:	c3                   	ret    
    panic("log.committing");
80103974:	83 ec 0c             	sub    $0xc,%esp
80103977:	68 84 80 10 80       	push   $0x80108084
8010397c:	e8 8f ca ff ff       	call   80100410 <panic>
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103997:	8b 15 08 32 11 80    	mov    0x80113208,%edx
{
8010399d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801039a0:	83 fa 1d             	cmp    $0x1d,%edx
801039a3:	0f 8f 85 00 00 00    	jg     80103a2e <log_write+0x9e>
801039a9:	a1 f8 31 11 80       	mov    0x801131f8,%eax
801039ae:	83 e8 01             	sub    $0x1,%eax
801039b1:	39 c2                	cmp    %eax,%edx
801039b3:	7d 79                	jge    80103a2e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801039b5:	a1 fc 31 11 80       	mov    0x801131fc,%eax
801039ba:	85 c0                	test   %eax,%eax
801039bc:	7e 7d                	jle    80103a3b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801039be:	83 ec 0c             	sub    $0xc,%esp
801039c1:	68 c0 31 11 80       	push   $0x801131c0
801039c6:	e8 25 16 00 00       	call   80104ff0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801039cb:	8b 15 08 32 11 80    	mov    0x80113208,%edx
801039d1:	83 c4 10             	add    $0x10,%esp
801039d4:	85 d2                	test   %edx,%edx
801039d6:	7e 4a                	jle    80103a22 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801039d8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801039db:	31 c0                	xor    %eax,%eax
801039dd:	eb 08                	jmp    801039e7 <log_write+0x57>
801039df:	90                   	nop
801039e0:	83 c0 01             	add    $0x1,%eax
801039e3:	39 c2                	cmp    %eax,%edx
801039e5:	74 29                	je     80103a10 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801039e7:	39 0c 85 0c 32 11 80 	cmp    %ecx,-0x7feecdf4(,%eax,4)
801039ee:	75 f0                	jne    801039e0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801039f0:	89 0c 85 0c 32 11 80 	mov    %ecx,-0x7feecdf4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801039f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801039fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801039fd:	c7 45 08 c0 31 11 80 	movl   $0x801131c0,0x8(%ebp)
}
80103a04:	c9                   	leave  
  release(&log.lock);
80103a05:	e9 86 15 00 00       	jmp    80104f90 <release>
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103a10:	89 0c 95 0c 32 11 80 	mov    %ecx,-0x7feecdf4(,%edx,4)
    log.lh.n++;
80103a17:	83 c2 01             	add    $0x1,%edx
80103a1a:	89 15 08 32 11 80    	mov    %edx,0x80113208
80103a20:	eb d5                	jmp    801039f7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103a22:	8b 43 08             	mov    0x8(%ebx),%eax
80103a25:	a3 0c 32 11 80       	mov    %eax,0x8011320c
  if (i == log.lh.n)
80103a2a:	75 cb                	jne    801039f7 <log_write+0x67>
80103a2c:	eb e9                	jmp    80103a17 <log_write+0x87>
    panic("too big a transaction");
80103a2e:	83 ec 0c             	sub    $0xc,%esp
80103a31:	68 93 80 10 80       	push   $0x80108093
80103a36:	e8 d5 c9 ff ff       	call   80100410 <panic>
    panic("log_write outside of trans");
80103a3b:	83 ec 0c             	sub    $0xc,%esp
80103a3e:	68 a9 80 10 80       	push   $0x801080a9
80103a43:	e8 c8 c9 ff ff       	call   80100410 <panic>
80103a48:	66 90                	xchg   %ax,%ax
80103a4a:	66 90                	xchg   %ax,%ax
80103a4c:	66 90                	xchg   %ax,%ax
80103a4e:	66 90                	xchg   %ax,%ax

80103a50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103a57:	e8 44 09 00 00       	call   801043a0 <cpuid>
80103a5c:	89 c3                	mov    %eax,%ebx
80103a5e:	e8 3d 09 00 00       	call   801043a0 <cpuid>
80103a63:	83 ec 04             	sub    $0x4,%esp
80103a66:	53                   	push   %ebx
80103a67:	50                   	push   %eax
80103a68:	68 c4 80 10 80       	push   $0x801080c4
80103a6d:	e8 1e cd ff ff       	call   80100790 <cprintf>
  idtinit();       // load idt register
80103a72:	e8 b9 28 00 00       	call   80106330 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103a77:	e8 c4 08 00 00       	call   80104340 <mycpu>
80103a7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a7e:	b8 01 00 00 00       	mov    $0x1,%eax
80103a83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80103a8a:	e8 f1 0b 00 00       	call   80104680 <scheduler>
80103a8f:	90                   	nop

80103a90 <mpenter>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103a96:	e8 85 39 00 00       	call   80107420 <switchkvm>
  seginit();
80103a9b:	e8 f0 38 00 00       	call   80107390 <seginit>
  lapicinit();
80103aa0:	e8 9b f7 ff ff       	call   80103240 <lapicinit>
  mpmain();
80103aa5:	e8 a6 ff ff ff       	call   80103a50 <mpmain>
80103aaa:	66 90                	xchg   %ax,%ax
80103aac:	66 90                	xchg   %ax,%ax
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <main>:
{
80103ab0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103ab4:	83 e4 f0             	and    $0xfffffff0,%esp
80103ab7:	ff 71 fc             	push   -0x4(%ecx)
80103aba:	55                   	push   %ebp
80103abb:	89 e5                	mov    %esp,%ebp
80103abd:	53                   	push   %ebx
80103abe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103abf:	83 ec 08             	sub    $0x8,%esp
80103ac2:	68 00 00 40 80       	push   $0x80400000
80103ac7:	68 f0 6f 11 80       	push   $0x80116ff0
80103acc:	e8 8f f5 ff ff       	call   80103060 <kinit1>
  kvmalloc();      // kernel page table
80103ad1:	e8 3a 3e 00 00       	call   80107910 <kvmalloc>
  mpinit();        // detect other processors
80103ad6:	e8 85 01 00 00       	call   80103c60 <mpinit>
  lapicinit();     // interrupt controller
80103adb:	e8 60 f7 ff ff       	call   80103240 <lapicinit>
  seginit();       // segment descriptors
80103ae0:	e8 ab 38 00 00       	call   80107390 <seginit>
  picinit();       // disable pic
80103ae5:	e8 76 03 00 00       	call   80103e60 <picinit>
  ioapicinit();    // another interrupt controller
80103aea:	e8 31 f3 ff ff       	call   80102e20 <ioapicinit>
  consoleinit();   // console hardware
80103aef:	e8 bc d9 ff ff       	call   801014b0 <consoleinit>
  uartinit();      // serial port
80103af4:	e8 27 2b 00 00       	call   80106620 <uartinit>
  pinit();         // process table
80103af9:	e8 22 08 00 00       	call   80104320 <pinit>
  tvinit();        // trap vectors
80103afe:	e8 ad 27 00 00       	call   801062b0 <tvinit>
  binit();         // buffer cache
80103b03:	e8 38 c5 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103b08:	e8 53 dd ff ff       	call   80101860 <fileinit>
  ideinit();       // disk 
80103b0d:	e8 fe f0 ff ff       	call   80102c10 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b12:	83 c4 0c             	add    $0xc,%esp
80103b15:	68 8a 00 00 00       	push   $0x8a
80103b1a:	68 8c b4 10 80       	push   $0x8010b48c
80103b1f:	68 00 70 00 80       	push   $0x80007000
80103b24:	e8 27 16 00 00       	call   80105150 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103b29:	83 c4 10             	add    $0x10,%esp
80103b2c:	69 05 a4 32 11 80 b0 	imul   $0xb0,0x801132a4,%eax
80103b33:	00 00 00 
80103b36:	05 c0 32 11 80       	add    $0x801132c0,%eax
80103b3b:	3d c0 32 11 80       	cmp    $0x801132c0,%eax
80103b40:	76 7e                	jbe    80103bc0 <main+0x110>
80103b42:	bb c0 32 11 80       	mov    $0x801132c0,%ebx
80103b47:	eb 20                	jmp    80103b69 <main+0xb9>
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b50:	69 05 a4 32 11 80 b0 	imul   $0xb0,0x801132a4,%eax
80103b57:	00 00 00 
80103b5a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103b60:	05 c0 32 11 80       	add    $0x801132c0,%eax
80103b65:	39 c3                	cmp    %eax,%ebx
80103b67:	73 57                	jae    80103bc0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103b69:	e8 d2 07 00 00       	call   80104340 <mycpu>
80103b6e:	39 c3                	cmp    %eax,%ebx
80103b70:	74 de                	je     80103b50 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b72:	e8 59 f5 ff ff       	call   801030d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103b77:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103b7a:	c7 05 f8 6f 00 80 90 	movl   $0x80103a90,0x80006ff8
80103b81:	3a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b84:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103b8b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b8e:	05 00 10 00 00       	add    $0x1000,%eax
80103b93:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103b98:	0f b6 03             	movzbl (%ebx),%eax
80103b9b:	68 00 70 00 00       	push   $0x7000
80103ba0:	50                   	push   %eax
80103ba1:	e8 ea f7 ff ff       	call   80103390 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103ba6:	83 c4 10             	add    $0x10,%esp
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bb0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103bb6:	85 c0                	test   %eax,%eax
80103bb8:	74 f6                	je     80103bb0 <main+0x100>
80103bba:	eb 94                	jmp    80103b50 <main+0xa0>
80103bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103bc0:	83 ec 08             	sub    $0x8,%esp
80103bc3:	68 00 00 00 8e       	push   $0x8e000000
80103bc8:	68 00 00 40 80       	push   $0x80400000
80103bcd:	e8 2e f4 ff ff       	call   80103000 <kinit2>
  userinit();      // first user process
80103bd2:	e8 19 08 00 00       	call   801043f0 <userinit>
  mpmain();        // finish this processor's setup
80103bd7:	e8 74 fe ff ff       	call   80103a50 <mpmain>
80103bdc:	66 90                	xchg   %ax,%ax
80103bde:	66 90                	xchg   %ax,%ax

80103be0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103be5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103beb:	53                   	push   %ebx
  e = addr+len;
80103bec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103bef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103bf2:	39 de                	cmp    %ebx,%esi
80103bf4:	72 10                	jb     80103c06 <mpsearch1+0x26>
80103bf6:	eb 50                	jmp    80103c48 <mpsearch1+0x68>
80103bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bff:	90                   	nop
80103c00:	89 fe                	mov    %edi,%esi
80103c02:	39 fb                	cmp    %edi,%ebx
80103c04:	76 42                	jbe    80103c48 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c06:	83 ec 04             	sub    $0x4,%esp
80103c09:	8d 7e 10             	lea    0x10(%esi),%edi
80103c0c:	6a 04                	push   $0x4
80103c0e:	68 d8 80 10 80       	push   $0x801080d8
80103c13:	56                   	push   %esi
80103c14:	e8 e7 14 00 00       	call   80105100 <memcmp>
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	75 e0                	jne    80103c00 <mpsearch1+0x20>
80103c20:	89 f2                	mov    %esi,%edx
80103c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103c28:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103c2b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103c2e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103c30:	39 fa                	cmp    %edi,%edx
80103c32:	75 f4                	jne    80103c28 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c34:	84 c0                	test   %al,%al
80103c36:	75 c8                	jne    80103c00 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3b:	89 f0                	mov    %esi,%eax
80103c3d:	5b                   	pop    %ebx
80103c3e:	5e                   	pop    %esi
80103c3f:	5f                   	pop    %edi
80103c40:	5d                   	pop    %ebp
80103c41:	c3                   	ret    
80103c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c4b:	31 f6                	xor    %esi,%esi
}
80103c4d:	5b                   	pop    %ebx
80103c4e:	89 f0                	mov    %esi,%eax
80103c50:	5e                   	pop    %esi
80103c51:	5f                   	pop    %edi
80103c52:	5d                   	pop    %ebp
80103c53:	c3                   	ret    
80103c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c69:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103c70:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103c77:	c1 e0 08             	shl    $0x8,%eax
80103c7a:	09 d0                	or     %edx,%eax
80103c7c:	c1 e0 04             	shl    $0x4,%eax
80103c7f:	75 1b                	jne    80103c9c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c81:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103c88:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103c8f:	c1 e0 08             	shl    $0x8,%eax
80103c92:	09 d0                	or     %edx,%eax
80103c94:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103c97:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103c9c:	ba 00 04 00 00       	mov    $0x400,%edx
80103ca1:	e8 3a ff ff ff       	call   80103be0 <mpsearch1>
80103ca6:	89 c3                	mov    %eax,%ebx
80103ca8:	85 c0                	test   %eax,%eax
80103caa:	0f 84 40 01 00 00    	je     80103df0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103cb0:	8b 73 04             	mov    0x4(%ebx),%esi
80103cb3:	85 f6                	test   %esi,%esi
80103cb5:	0f 84 25 01 00 00    	je     80103de0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
80103cbb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103cbe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103cc4:	6a 04                	push   $0x4
80103cc6:	68 dd 80 10 80       	push   $0x801080dd
80103ccb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ccc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ccf:	e8 2c 14 00 00       	call   80105100 <memcmp>
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	85 c0                	test   %eax,%eax
80103cd9:	0f 85 01 01 00 00    	jne    80103de0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
80103cdf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103ce6:	3c 01                	cmp    $0x1,%al
80103ce8:	74 08                	je     80103cf2 <mpinit+0x92>
80103cea:	3c 04                	cmp    $0x4,%al
80103cec:	0f 85 ee 00 00 00    	jne    80103de0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103cf2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103cf9:	66 85 d2             	test   %dx,%dx
80103cfc:	74 22                	je     80103d20 <mpinit+0xc0>
80103cfe:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103d01:	89 f0                	mov    %esi,%eax
  sum = 0;
80103d03:	31 d2                	xor    %edx,%edx
80103d05:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103d08:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103d0f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103d12:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103d14:	39 c7                	cmp    %eax,%edi
80103d16:	75 f0                	jne    80103d08 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103d18:	84 d2                	test   %dl,%dl
80103d1a:	0f 85 c0 00 00 00    	jne    80103de0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103d20:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103d26:	a3 a0 31 11 80       	mov    %eax,0x801131a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d2b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103d32:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103d38:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d3d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103d40:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103d43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d47:	90                   	nop
80103d48:	39 d0                	cmp    %edx,%eax
80103d4a:	73 15                	jae    80103d61 <mpinit+0x101>
    switch(*p){
80103d4c:	0f b6 08             	movzbl (%eax),%ecx
80103d4f:	80 f9 02             	cmp    $0x2,%cl
80103d52:	74 4c                	je     80103da0 <mpinit+0x140>
80103d54:	77 3a                	ja     80103d90 <mpinit+0x130>
80103d56:	84 c9                	test   %cl,%cl
80103d58:	74 56                	je     80103db0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d5a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d5d:	39 d0                	cmp    %edx,%eax
80103d5f:	72 eb                	jb     80103d4c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103d61:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d64:	85 f6                	test   %esi,%esi
80103d66:	0f 84 d9 00 00 00    	je     80103e45 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103d6c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103d70:	74 15                	je     80103d87 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d72:	b8 70 00 00 00       	mov    $0x70,%eax
80103d77:	ba 22 00 00 00       	mov    $0x22,%edx
80103d7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d7d:	ba 23 00 00 00       	mov    $0x23,%edx
80103d82:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d83:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d86:	ee                   	out    %al,(%dx)
  }
}
80103d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d8a:	5b                   	pop    %ebx
80103d8b:	5e                   	pop    %esi
80103d8c:	5f                   	pop    %edi
80103d8d:	5d                   	pop    %ebp
80103d8e:	c3                   	ret    
80103d8f:	90                   	nop
    switch(*p){
80103d90:	83 e9 03             	sub    $0x3,%ecx
80103d93:	80 f9 01             	cmp    $0x1,%cl
80103d96:	76 c2                	jbe    80103d5a <mpinit+0xfa>
80103d98:	31 f6                	xor    %esi,%esi
80103d9a:	eb ac                	jmp    80103d48 <mpinit+0xe8>
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103da0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103da4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103da7:	88 0d a0 32 11 80    	mov    %cl,0x801132a0
      continue;
80103dad:	eb 99                	jmp    80103d48 <mpinit+0xe8>
80103daf:	90                   	nop
      if(ncpu < NCPU) {
80103db0:	8b 0d a4 32 11 80    	mov    0x801132a4,%ecx
80103db6:	83 f9 07             	cmp    $0x7,%ecx
80103db9:	7f 19                	jg     80103dd4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103dbb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103dc1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103dc5:	83 c1 01             	add    $0x1,%ecx
80103dc8:	89 0d a4 32 11 80    	mov    %ecx,0x801132a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103dce:	88 9f c0 32 11 80    	mov    %bl,-0x7feecd40(%edi)
      p += sizeof(struct mpproc);
80103dd4:	83 c0 14             	add    $0x14,%eax
      continue;
80103dd7:	e9 6c ff ff ff       	jmp    80103d48 <mpinit+0xe8>
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	68 e2 80 10 80       	push   $0x801080e2
80103de8:	e8 23 c6 ff ff       	call   80100410 <panic>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
{
80103df0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103df5:	eb 13                	jmp    80103e0a <mpinit+0x1aa>
80103df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfe:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103e00:	89 f3                	mov    %esi,%ebx
80103e02:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103e08:	74 d6                	je     80103de0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e0a:	83 ec 04             	sub    $0x4,%esp
80103e0d:	8d 73 10             	lea    0x10(%ebx),%esi
80103e10:	6a 04                	push   $0x4
80103e12:	68 d8 80 10 80       	push   $0x801080d8
80103e17:	53                   	push   %ebx
80103e18:	e8 e3 12 00 00       	call   80105100 <memcmp>
80103e1d:	83 c4 10             	add    $0x10,%esp
80103e20:	85 c0                	test   %eax,%eax
80103e22:	75 dc                	jne    80103e00 <mpinit+0x1a0>
80103e24:	89 da                	mov    %ebx,%edx
80103e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103e30:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103e33:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103e36:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103e38:	39 d6                	cmp    %edx,%esi
80103e3a:	75 f4                	jne    80103e30 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e3c:	84 c0                	test   %al,%al
80103e3e:	75 c0                	jne    80103e00 <mpinit+0x1a0>
80103e40:	e9 6b fe ff ff       	jmp    80103cb0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103e45:	83 ec 0c             	sub    $0xc,%esp
80103e48:	68 fc 80 10 80       	push   $0x801080fc
80103e4d:	e8 be c5 ff ff       	call   80100410 <panic>
80103e52:	66 90                	xchg   %ax,%ax
80103e54:	66 90                	xchg   %ax,%ax
80103e56:	66 90                	xchg   %ax,%ax
80103e58:	66 90                	xchg   %ax,%ax
80103e5a:	66 90                	xchg   %ax,%ax
80103e5c:	66 90                	xchg   %ax,%ax
80103e5e:	66 90                	xchg   %ax,%ax

80103e60 <picinit>:
80103e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e65:	ba 21 00 00 00       	mov    $0x21,%edx
80103e6a:	ee                   	out    %al,(%dx)
80103e6b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103e70:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103e71:	c3                   	ret    
80103e72:	66 90                	xchg   %ax,%ax
80103e74:	66 90                	xchg   %ax,%ax
80103e76:	66 90                	xchg   %ax,%ax
80103e78:	66 90                	xchg   %ax,%ax
80103e7a:	66 90                	xchg   %ax,%ax
80103e7c:	66 90                	xchg   %ax,%ax
80103e7e:	66 90                	xchg   %ax,%ax

80103e80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103e8f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103e9b:	e8 e0 d9 ff ff       	call   80101880 <filealloc>
80103ea0:	89 03                	mov    %eax,(%ebx)
80103ea2:	85 c0                	test   %eax,%eax
80103ea4:	0f 84 a8 00 00 00    	je     80103f52 <pipealloc+0xd2>
80103eaa:	e8 d1 d9 ff ff       	call   80101880 <filealloc>
80103eaf:	89 06                	mov    %eax,(%esi)
80103eb1:	85 c0                	test   %eax,%eax
80103eb3:	0f 84 87 00 00 00    	je     80103f40 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103eb9:	e8 12 f2 ff ff       	call   801030d0 <kalloc>
80103ebe:	89 c7                	mov    %eax,%edi
80103ec0:	85 c0                	test   %eax,%eax
80103ec2:	0f 84 b0 00 00 00    	je     80103f78 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103ec8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ecf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ed2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ed5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103edc:	00 00 00 
  p->nwrite = 0;
80103edf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103ee6:	00 00 00 
  p->nread = 0;
80103ee9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ef0:	00 00 00 
  initlock(&p->lock, "pipe");
80103ef3:	68 1b 81 10 80       	push   $0x8010811b
80103ef8:	50                   	push   %eax
80103ef9:	e8 22 0f 00 00       	call   80104e20 <initlock>
  (*f0)->type = FD_PIPE;
80103efe:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103f00:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103f03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103f09:	8b 03                	mov    (%ebx),%eax
80103f0b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103f0f:	8b 03                	mov    (%ebx),%eax
80103f11:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103f15:	8b 03                	mov    (%ebx),%eax
80103f17:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103f1a:	8b 06                	mov    (%esi),%eax
80103f1c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103f22:	8b 06                	mov    (%esi),%eax
80103f24:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103f28:	8b 06                	mov    (%esi),%eax
80103f2a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103f2e:	8b 06                	mov    (%esi),%eax
80103f30:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103f36:	31 c0                	xor    %eax,%eax
}
80103f38:	5b                   	pop    %ebx
80103f39:	5e                   	pop    %esi
80103f3a:	5f                   	pop    %edi
80103f3b:	5d                   	pop    %ebp
80103f3c:	c3                   	ret    
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103f40:	8b 03                	mov    (%ebx),%eax
80103f42:	85 c0                	test   %eax,%eax
80103f44:	74 1e                	je     80103f64 <pipealloc+0xe4>
    fileclose(*f0);
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	50                   	push   %eax
80103f4a:	e8 f1 d9 ff ff       	call   80101940 <fileclose>
80103f4f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103f52:	8b 06                	mov    (%esi),%eax
80103f54:	85 c0                	test   %eax,%eax
80103f56:	74 0c                	je     80103f64 <pipealloc+0xe4>
    fileclose(*f1);
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	50                   	push   %eax
80103f5c:	e8 df d9 ff ff       	call   80101940 <fileclose>
80103f61:	83 c4 10             	add    $0x10,%esp
}
80103f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f6c:	5b                   	pop    %ebx
80103f6d:	5e                   	pop    %esi
80103f6e:	5f                   	pop    %edi
80103f6f:	5d                   	pop    %ebp
80103f70:	c3                   	ret    
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103f78:	8b 03                	mov    (%ebx),%eax
80103f7a:	85 c0                	test   %eax,%eax
80103f7c:	75 c8                	jne    80103f46 <pipealloc+0xc6>
80103f7e:	eb d2                	jmp    80103f52 <pipealloc+0xd2>

80103f80 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
80103f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f88:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103f8b:	83 ec 0c             	sub    $0xc,%esp
80103f8e:	53                   	push   %ebx
80103f8f:	e8 5c 10 00 00       	call   80104ff0 <acquire>
  if(writable){
80103f94:	83 c4 10             	add    $0x10,%esp
80103f97:	85 f6                	test   %esi,%esi
80103f99:	74 65                	je     80104000 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103f9b:	83 ec 0c             	sub    $0xc,%esp
80103f9e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103fa4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103fab:	00 00 00 
    wakeup(&p->nread);
80103fae:	50                   	push   %eax
80103faf:	e8 9c 0b 00 00       	call   80104b50 <wakeup>
80103fb4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103fb7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103fbd:	85 d2                	test   %edx,%edx
80103fbf:	75 0a                	jne    80103fcb <pipeclose+0x4b>
80103fc1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103fc7:	85 c0                	test   %eax,%eax
80103fc9:	74 15                	je     80103fe0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103fcb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd1:	5b                   	pop    %ebx
80103fd2:	5e                   	pop    %esi
80103fd3:	5d                   	pop    %ebp
    release(&p->lock);
80103fd4:	e9 b7 0f 00 00       	jmp    80104f90 <release>
80103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103fe0:	83 ec 0c             	sub    $0xc,%esp
80103fe3:	53                   	push   %ebx
80103fe4:	e8 a7 0f 00 00       	call   80104f90 <release>
    kfree((char*)p);
80103fe9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103fec:	83 c4 10             	add    $0x10,%esp
}
80103fef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff2:	5b                   	pop    %ebx
80103ff3:	5e                   	pop    %esi
80103ff4:	5d                   	pop    %ebp
    kfree((char*)p);
80103ff5:	e9 16 ef ff ff       	jmp    80102f10 <kfree>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104009:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104010:	00 00 00 
    wakeup(&p->nwrite);
80104013:	50                   	push   %eax
80104014:	e8 37 0b 00 00       	call   80104b50 <wakeup>
80104019:	83 c4 10             	add    $0x10,%esp
8010401c:	eb 99                	jmp    80103fb7 <pipeclose+0x37>
8010401e:	66 90                	xchg   %ax,%ax

80104020 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 28             	sub    $0x28,%esp
80104029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010402c:	53                   	push   %ebx
8010402d:	e8 be 0f 00 00       	call   80104ff0 <acquire>
  for(i = 0; i < n; i++){
80104032:	8b 45 10             	mov    0x10(%ebp),%eax
80104035:	83 c4 10             	add    $0x10,%esp
80104038:	85 c0                	test   %eax,%eax
8010403a:	0f 8e c0 00 00 00    	jle    80104100 <pipewrite+0xe0>
80104040:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104043:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104049:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010404f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104052:	03 45 10             	add    0x10(%ebp),%eax
80104055:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104058:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010405e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104064:	89 ca                	mov    %ecx,%edx
80104066:	05 00 02 00 00       	add    $0x200,%eax
8010406b:	39 c1                	cmp    %eax,%ecx
8010406d:	74 3f                	je     801040ae <pipewrite+0x8e>
8010406f:	eb 67                	jmp    801040d8 <pipewrite+0xb8>
80104071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104078:	e8 43 03 00 00       	call   801043c0 <myproc>
8010407d:	8b 48 24             	mov    0x24(%eax),%ecx
80104080:	85 c9                	test   %ecx,%ecx
80104082:	75 34                	jne    801040b8 <pipewrite+0x98>
      wakeup(&p->nread);
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	57                   	push   %edi
80104088:	e8 c3 0a 00 00       	call   80104b50 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010408d:	58                   	pop    %eax
8010408e:	5a                   	pop    %edx
8010408f:	53                   	push   %ebx
80104090:	56                   	push   %esi
80104091:	e8 fa 09 00 00       	call   80104a90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104096:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010409c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801040a2:	83 c4 10             	add    $0x10,%esp
801040a5:	05 00 02 00 00       	add    $0x200,%eax
801040aa:	39 c2                	cmp    %eax,%edx
801040ac:	75 2a                	jne    801040d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801040ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801040b4:	85 c0                	test   %eax,%eax
801040b6:	75 c0                	jne    80104078 <pipewrite+0x58>
        release(&p->lock);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	53                   	push   %ebx
801040bc:	e8 cf 0e 00 00       	call   80104f90 <release>
        return -1;
801040c1:	83 c4 10             	add    $0x10,%esp
801040c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801040c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040cc:	5b                   	pop    %ebx
801040cd:	5e                   	pop    %esi
801040ce:	5f                   	pop    %edi
801040cf:	5d                   	pop    %ebp
801040d0:	c3                   	ret    
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801040d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801040db:	8d 4a 01             	lea    0x1(%edx),%ecx
801040de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801040e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801040ea:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801040ed:	83 c6 01             	add    $0x1,%esi
801040f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801040f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801040f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801040fa:	0f 85 58 ff ff ff    	jne    80104058 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104109:	50                   	push   %eax
8010410a:	e8 41 0a 00 00       	call   80104b50 <wakeup>
  release(&p->lock);
8010410f:	89 1c 24             	mov    %ebx,(%esp)
80104112:	e8 79 0e 00 00       	call   80104f90 <release>
  return n;
80104117:	8b 45 10             	mov    0x10(%ebp),%eax
8010411a:	83 c4 10             	add    $0x10,%esp
8010411d:	eb aa                	jmp    801040c9 <pipewrite+0xa9>
8010411f:	90                   	nop

80104120 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	53                   	push   %ebx
80104126:	83 ec 18             	sub    $0x18,%esp
80104129:	8b 75 08             	mov    0x8(%ebp),%esi
8010412c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010412f:	56                   	push   %esi
80104130:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104136:	e8 b5 0e 00 00       	call   80104ff0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010413b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104141:	83 c4 10             	add    $0x10,%esp
80104144:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010414a:	74 2f                	je     8010417b <piperead+0x5b>
8010414c:	eb 37                	jmp    80104185 <piperead+0x65>
8010414e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104150:	e8 6b 02 00 00       	call   801043c0 <myproc>
80104155:	8b 48 24             	mov    0x24(%eax),%ecx
80104158:	85 c9                	test   %ecx,%ecx
8010415a:	0f 85 80 00 00 00    	jne    801041e0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104160:	83 ec 08             	sub    $0x8,%esp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
80104165:	e8 26 09 00 00       	call   80104a90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010416a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104170:	83 c4 10             	add    $0x10,%esp
80104173:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104179:	75 0a                	jne    80104185 <piperead+0x65>
8010417b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104181:	85 c0                	test   %eax,%eax
80104183:	75 cb                	jne    80104150 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104185:	8b 55 10             	mov    0x10(%ebp),%edx
80104188:	31 db                	xor    %ebx,%ebx
8010418a:	85 d2                	test   %edx,%edx
8010418c:	7f 20                	jg     801041ae <piperead+0x8e>
8010418e:	eb 2c                	jmp    801041bc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104190:	8d 48 01             	lea    0x1(%eax),%ecx
80104193:	25 ff 01 00 00       	and    $0x1ff,%eax
80104198:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010419e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801041a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041a6:	83 c3 01             	add    $0x1,%ebx
801041a9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801041ac:	74 0e                	je     801041bc <piperead+0x9c>
    if(p->nread == p->nwrite)
801041ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801041b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801041ba:	75 d4                	jne    80104190 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801041bc:	83 ec 0c             	sub    $0xc,%esp
801041bf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801041c5:	50                   	push   %eax
801041c6:	e8 85 09 00 00       	call   80104b50 <wakeup>
  release(&p->lock);
801041cb:	89 34 24             	mov    %esi,(%esp)
801041ce:	e8 bd 0d 00 00       	call   80104f90 <release>
  return i;
801041d3:	83 c4 10             	add    $0x10,%esp
}
801041d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041d9:	89 d8                	mov    %ebx,%eax
801041db:	5b                   	pop    %ebx
801041dc:	5e                   	pop    %esi
801041dd:	5f                   	pop    %edi
801041de:	5d                   	pop    %ebp
801041df:	c3                   	ret    
      release(&p->lock);
801041e0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801041e8:	56                   	push   %esi
801041e9:	e8 a2 0d 00 00       	call   80104f90 <release>
      return -1;
801041ee:	83 c4 10             	add    $0x10,%esp
}
801041f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f4:	89 d8                	mov    %ebx,%eax
801041f6:	5b                   	pop    %ebx
801041f7:	5e                   	pop    %esi
801041f8:	5f                   	pop    %edi
801041f9:	5d                   	pop    %ebp
801041fa:	c3                   	ret    
801041fb:	66 90                	xchg   %ax,%ax
801041fd:	66 90                	xchg   %ax,%ax
801041ff:	90                   	nop

80104200 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104204:	bb 74 38 11 80       	mov    $0x80113874,%ebx
{
80104209:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010420c:	68 40 38 11 80       	push   $0x80113840
80104211:	e8 da 0d 00 00       	call   80104ff0 <acquire>
80104216:	83 c4 10             	add    $0x10,%esp
80104219:	eb 10                	jmp    8010422b <allocproc+0x2b>
8010421b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010421f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104220:	83 c3 7c             	add    $0x7c,%ebx
80104223:	81 fb 74 57 11 80    	cmp    $0x80115774,%ebx
80104229:	74 75                	je     801042a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010422b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010422e:	85 c0                	test   %eax,%eax
80104230:	75 ee                	jne    80104220 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104232:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104237:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010423a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104241:	89 43 10             	mov    %eax,0x10(%ebx)
80104244:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104247:	68 40 38 11 80       	push   $0x80113840
  p->pid = nextpid++;
8010424c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104252:	e8 39 0d 00 00       	call   80104f90 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104257:	e8 74 ee ff ff       	call   801030d0 <kalloc>
8010425c:	83 c4 10             	add    $0x10,%esp
8010425f:	89 43 08             	mov    %eax,0x8(%ebx)
80104262:	85 c0                	test   %eax,%eax
80104264:	74 53                	je     801042b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104266:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010426c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010426f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104274:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104277:	c7 40 14 a2 62 10 80 	movl   $0x801062a2,0x14(%eax)
  p->context = (struct context*)sp;
8010427e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104281:	6a 14                	push   $0x14
80104283:	6a 00                	push   $0x0
80104285:	50                   	push   %eax
80104286:	e8 25 0e 00 00       	call   801050b0 <memset>
  p->context->eip = (uint)forkret;
8010428b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010428e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104291:	c7 40 10 d0 42 10 80 	movl   $0x801042d0,0x10(%eax)
}
80104298:	89 d8                	mov    %ebx,%eax
8010429a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010429d:	c9                   	leave  
8010429e:	c3                   	ret    
8010429f:	90                   	nop
  release(&ptable.lock);
801042a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801042a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801042a5:	68 40 38 11 80       	push   $0x80113840
801042aa:	e8 e1 0c 00 00       	call   80104f90 <release>
}
801042af:	89 d8                	mov    %ebx,%eax
  return 0;
801042b1:	83 c4 10             	add    $0x10,%esp
}
801042b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b7:	c9                   	leave  
801042b8:	c3                   	ret    
    p->state = UNUSED;
801042b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801042c0:	31 db                	xor    %ebx,%ebx
}
801042c2:	89 d8                	mov    %ebx,%eax
801042c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c7:	c9                   	leave  
801042c8:	c3                   	ret    
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801042d6:	68 40 38 11 80       	push   $0x80113840
801042db:	e8 b0 0c 00 00       	call   80104f90 <release>

  if (first) {
801042e0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801042e5:	83 c4 10             	add    $0x10,%esp
801042e8:	85 c0                	test   %eax,%eax
801042ea:	75 04                	jne    801042f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801042ec:	c9                   	leave  
801042ed:	c3                   	ret    
801042ee:	66 90                	xchg   %ax,%ax
    first = 0;
801042f0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801042f7:	00 00 00 
    iinit(ROOTDEV);
801042fa:	83 ec 0c             	sub    $0xc,%esp
801042fd:	6a 01                	push   $0x1
801042ff:	e8 ac dc ff ff       	call   80101fb0 <iinit>
    initlog(ROOTDEV);
80104304:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010430b:	e8 00 f4 ff ff       	call   80103710 <initlog>
}
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	c9                   	leave  
80104314:	c3                   	ret    
80104315:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104320 <pinit>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104326:	68 20 81 10 80       	push   $0x80108120
8010432b:	68 40 38 11 80       	push   $0x80113840
80104330:	e8 eb 0a 00 00       	call   80104e20 <initlock>
}
80104335:	83 c4 10             	add    $0x10,%esp
80104338:	c9                   	leave  
80104339:	c3                   	ret    
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <mycpu>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104345:	9c                   	pushf  
80104346:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104347:	f6 c4 02             	test   $0x2,%ah
8010434a:	75 46                	jne    80104392 <mycpu+0x52>
  apicid = lapicid();
8010434c:	e8 ef ef ff ff       	call   80103340 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104351:	8b 35 a4 32 11 80    	mov    0x801132a4,%esi
80104357:	85 f6                	test   %esi,%esi
80104359:	7e 2a                	jle    80104385 <mycpu+0x45>
8010435b:	31 d2                	xor    %edx,%edx
8010435d:	eb 08                	jmp    80104367 <mycpu+0x27>
8010435f:	90                   	nop
80104360:	83 c2 01             	add    $0x1,%edx
80104363:	39 f2                	cmp    %esi,%edx
80104365:	74 1e                	je     80104385 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104367:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010436d:	0f b6 99 c0 32 11 80 	movzbl -0x7feecd40(%ecx),%ebx
80104374:	39 c3                	cmp    %eax,%ebx
80104376:	75 e8                	jne    80104360 <mycpu+0x20>
}
80104378:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010437b:	8d 81 c0 32 11 80    	lea    -0x7feecd40(%ecx),%eax
}
80104381:	5b                   	pop    %ebx
80104382:	5e                   	pop    %esi
80104383:	5d                   	pop    %ebp
80104384:	c3                   	ret    
  panic("unknown apicid\n");
80104385:	83 ec 0c             	sub    $0xc,%esp
80104388:	68 27 81 10 80       	push   $0x80108127
8010438d:	e8 7e c0 ff ff       	call   80100410 <panic>
    panic("mycpu called with interrupts enabled\n");
80104392:	83 ec 0c             	sub    $0xc,%esp
80104395:	68 04 82 10 80       	push   $0x80108204
8010439a:	e8 71 c0 ff ff       	call   80100410 <panic>
8010439f:	90                   	nop

801043a0 <cpuid>:
cpuid() {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801043a6:	e8 95 ff ff ff       	call   80104340 <mycpu>
}
801043ab:	c9                   	leave  
  return mycpu()-cpus;
801043ac:	2d c0 32 11 80       	sub    $0x801132c0,%eax
801043b1:	c1 f8 04             	sar    $0x4,%eax
801043b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801043ba:	c3                   	ret    
801043bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043bf:	90                   	nop

801043c0 <myproc>:
myproc(void) {
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801043c7:	e8 d4 0a 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801043cc:	e8 6f ff ff ff       	call   80104340 <mycpu>
  p = c->proc;
801043d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043d7:	e8 14 0b 00 00       	call   80104ef0 <popcli>
}
801043dc:	89 d8                	mov    %ebx,%eax
801043de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e1:	c9                   	leave  
801043e2:	c3                   	ret    
801043e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <userinit>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801043f7:	e8 04 fe ff ff       	call   80104200 <allocproc>
801043fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801043fe:	a3 74 57 11 80       	mov    %eax,0x80115774
  if((p->pgdir = setupkvm()) == 0)
80104403:	e8 88 34 00 00       	call   80107890 <setupkvm>
80104408:	89 43 04             	mov    %eax,0x4(%ebx)
8010440b:	85 c0                	test   %eax,%eax
8010440d:	0f 84 bd 00 00 00    	je     801044d0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104413:	83 ec 04             	sub    $0x4,%esp
80104416:	68 2c 00 00 00       	push   $0x2c
8010441b:	68 60 b4 10 80       	push   $0x8010b460
80104420:	50                   	push   %eax
80104421:	e8 1a 31 00 00       	call   80107540 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104426:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104429:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010442f:	6a 4c                	push   $0x4c
80104431:	6a 00                	push   $0x0
80104433:	ff 73 18             	push   0x18(%ebx)
80104436:	e8 75 0c 00 00       	call   801050b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010443b:	8b 43 18             	mov    0x18(%ebx),%eax
8010443e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104443:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104446:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010444b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010444f:	8b 43 18             	mov    0x18(%ebx),%eax
80104452:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104456:	8b 43 18             	mov    0x18(%ebx),%eax
80104459:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010445d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104461:	8b 43 18             	mov    0x18(%ebx),%eax
80104464:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104468:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010446c:	8b 43 18             	mov    0x18(%ebx),%eax
8010446f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104476:	8b 43 18             	mov    0x18(%ebx),%eax
80104479:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104480:	8b 43 18             	mov    0x18(%ebx),%eax
80104483:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010448a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010448d:	6a 10                	push   $0x10
8010448f:	68 50 81 10 80       	push   $0x80108150
80104494:	50                   	push   %eax
80104495:	e8 d6 0d 00 00       	call   80105270 <safestrcpy>
  p->cwd = namei("/");
8010449a:	c7 04 24 59 81 10 80 	movl   $0x80108159,(%esp)
801044a1:	e8 4a e6 ff ff       	call   80102af0 <namei>
801044a6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801044a9:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
801044b0:	e8 3b 0b 00 00       	call   80104ff0 <acquire>
  p->state = RUNNABLE;
801044b5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801044bc:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
801044c3:	e8 c8 0a 00 00       	call   80104f90 <release>
}
801044c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	c9                   	leave  
801044cf:	c3                   	ret    
    panic("userinit: out of memory?");
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	68 37 81 10 80       	push   $0x80108137
801044d8:	e8 33 bf ff ff       	call   80100410 <panic>
801044dd:	8d 76 00             	lea    0x0(%esi),%esi

801044e0 <growproc>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801044e8:	e8 b3 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801044ed:	e8 4e fe ff ff       	call   80104340 <mycpu>
  p = c->proc;
801044f2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f8:	e8 f3 09 00 00       	call   80104ef0 <popcli>
  sz = curproc->sz;
801044fd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801044ff:	85 f6                	test   %esi,%esi
80104501:	7f 1d                	jg     80104520 <growproc+0x40>
  } else if(n < 0){
80104503:	75 3b                	jne    80104540 <growproc+0x60>
  switchuvm(curproc);
80104505:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104508:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010450a:	53                   	push   %ebx
8010450b:	e8 20 2f 00 00       	call   80107430 <switchuvm>
  return 0;
80104510:	83 c4 10             	add    $0x10,%esp
80104513:	31 c0                	xor    %eax,%eax
}
80104515:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104518:	5b                   	pop    %ebx
80104519:	5e                   	pop    %esi
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104520:	83 ec 04             	sub    $0x4,%esp
80104523:	01 c6                	add    %eax,%esi
80104525:	56                   	push   %esi
80104526:	50                   	push   %eax
80104527:	ff 73 04             	push   0x4(%ebx)
8010452a:	e8 81 31 00 00       	call   801076b0 <allocuvm>
8010452f:	83 c4 10             	add    $0x10,%esp
80104532:	85 c0                	test   %eax,%eax
80104534:	75 cf                	jne    80104505 <growproc+0x25>
      return -1;
80104536:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453b:	eb d8                	jmp    80104515 <growproc+0x35>
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104540:	83 ec 04             	sub    $0x4,%esp
80104543:	01 c6                	add    %eax,%esi
80104545:	56                   	push   %esi
80104546:	50                   	push   %eax
80104547:	ff 73 04             	push   0x4(%ebx)
8010454a:	e8 91 32 00 00       	call   801077e0 <deallocuvm>
8010454f:	83 c4 10             	add    $0x10,%esp
80104552:	85 c0                	test   %eax,%eax
80104554:	75 af                	jne    80104505 <growproc+0x25>
80104556:	eb de                	jmp    80104536 <growproc+0x56>
80104558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop

80104560 <fork>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
80104565:	53                   	push   %ebx
80104566:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104569:	e8 32 09 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010456e:	e8 cd fd ff ff       	call   80104340 <mycpu>
  p = c->proc;
80104573:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104579:	e8 72 09 00 00       	call   80104ef0 <popcli>
  if((np = allocproc()) == 0){
8010457e:	e8 7d fc ff ff       	call   80104200 <allocproc>
80104583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104586:	85 c0                	test   %eax,%eax
80104588:	0f 84 b7 00 00 00    	je     80104645 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010458e:	83 ec 08             	sub    $0x8,%esp
80104591:	ff 33                	push   (%ebx)
80104593:	89 c7                	mov    %eax,%edi
80104595:	ff 73 04             	push   0x4(%ebx)
80104598:	e8 e3 33 00 00       	call   80107980 <copyuvm>
8010459d:	83 c4 10             	add    $0x10,%esp
801045a0:	89 47 04             	mov    %eax,0x4(%edi)
801045a3:	85 c0                	test   %eax,%eax
801045a5:	0f 84 a1 00 00 00    	je     8010464c <fork+0xec>
  np->sz = curproc->sz;
801045ab:	8b 03                	mov    (%ebx),%eax
801045ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801045b0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801045b2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801045b5:	89 c8                	mov    %ecx,%eax
801045b7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801045ba:	b9 13 00 00 00       	mov    $0x13,%ecx
801045bf:	8b 73 18             	mov    0x18(%ebx),%esi
801045c2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801045c4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801045c6:	8b 40 18             	mov    0x18(%eax),%eax
801045c9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801045d0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801045d4:	85 c0                	test   %eax,%eax
801045d6:	74 13                	je     801045eb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	50                   	push   %eax
801045dc:	e8 0f d3 ff ff       	call   801018f0 <filedup>
801045e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801045eb:	83 c6 01             	add    $0x1,%esi
801045ee:	83 fe 10             	cmp    $0x10,%esi
801045f1:	75 dd                	jne    801045d0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801045f9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801045fc:	e8 9f db ff ff       	call   801021a0 <idup>
80104601:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104604:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104607:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010460a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010460d:	6a 10                	push   $0x10
8010460f:	53                   	push   %ebx
80104610:	50                   	push   %eax
80104611:	e8 5a 0c 00 00       	call   80105270 <safestrcpy>
  pid = np->pid;
80104616:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104619:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104620:	e8 cb 09 00 00       	call   80104ff0 <acquire>
  np->state = RUNNABLE;
80104625:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010462c:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104633:	e8 58 09 00 00       	call   80104f90 <release>
  return pid;
80104638:	83 c4 10             	add    $0x10,%esp
}
8010463b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010463e:	89 d8                	mov    %ebx,%eax
80104640:	5b                   	pop    %ebx
80104641:	5e                   	pop    %esi
80104642:	5f                   	pop    %edi
80104643:	5d                   	pop    %ebp
80104644:	c3                   	ret    
    return -1;
80104645:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010464a:	eb ef                	jmp    8010463b <fork+0xdb>
    kfree(np->kstack);
8010464c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010464f:	83 ec 0c             	sub    $0xc,%esp
80104652:	ff 73 08             	push   0x8(%ebx)
80104655:	e8 b6 e8 ff ff       	call   80102f10 <kfree>
    np->kstack = 0;
8010465a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104661:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104664:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010466b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104670:	eb c9                	jmp    8010463b <fork+0xdb>
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <scheduler>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	53                   	push   %ebx
80104686:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104689:	e8 b2 fc ff ff       	call   80104340 <mycpu>
  c->proc = 0;
8010468e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104695:	00 00 00 
  struct cpu *c = mycpu();
80104698:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010469a:	8d 78 04             	lea    0x4(%eax),%edi
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801046a0:	fb                   	sti    
    acquire(&ptable.lock);
801046a1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a4:	bb 74 38 11 80       	mov    $0x80113874,%ebx
    acquire(&ptable.lock);
801046a9:	68 40 38 11 80       	push   $0x80113840
801046ae:	e8 3d 09 00 00       	call   80104ff0 <acquire>
801046b3:	83 c4 10             	add    $0x10,%esp
801046b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
801046c0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801046c4:	75 33                	jne    801046f9 <scheduler+0x79>
      switchuvm(p);
801046c6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801046c9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801046cf:	53                   	push   %ebx
801046d0:	e8 5b 2d 00 00       	call   80107430 <switchuvm>
      swtch(&(c->scheduler), p->context);
801046d5:	58                   	pop    %eax
801046d6:	5a                   	pop    %edx
801046d7:	ff 73 1c             	push   0x1c(%ebx)
801046da:	57                   	push   %edi
      p->state = RUNNING;
801046db:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801046e2:	e8 e4 0b 00 00       	call   801052cb <swtch>
      switchkvm();
801046e7:	e8 34 2d 00 00       	call   80107420 <switchkvm>
      c->proc = 0;
801046ec:	83 c4 10             	add    $0x10,%esp
801046ef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801046f6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f9:	83 c3 7c             	add    $0x7c,%ebx
801046fc:	81 fb 74 57 11 80    	cmp    $0x80115774,%ebx
80104702:	75 bc                	jne    801046c0 <scheduler+0x40>
    release(&ptable.lock);
80104704:	83 ec 0c             	sub    $0xc,%esp
80104707:	68 40 38 11 80       	push   $0x80113840
8010470c:	e8 7f 08 00 00       	call   80104f90 <release>
    sti();
80104711:	83 c4 10             	add    $0x10,%esp
80104714:	eb 8a                	jmp    801046a0 <scheduler+0x20>
80104716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471d:	8d 76 00             	lea    0x0(%esi),%esi

80104720 <sched>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
  pushcli();
80104725:	e8 76 07 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010472a:	e8 11 fc ff ff       	call   80104340 <mycpu>
  p = c->proc;
8010472f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104735:	e8 b6 07 00 00       	call   80104ef0 <popcli>
  if(!holding(&ptable.lock))
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 40 38 11 80       	push   $0x80113840
80104742:	e8 09 08 00 00       	call   80104f50 <holding>
80104747:	83 c4 10             	add    $0x10,%esp
8010474a:	85 c0                	test   %eax,%eax
8010474c:	74 4f                	je     8010479d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010474e:	e8 ed fb ff ff       	call   80104340 <mycpu>
80104753:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010475a:	75 68                	jne    801047c4 <sched+0xa4>
  if(p->state == RUNNING)
8010475c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104760:	74 55                	je     801047b7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104762:	9c                   	pushf  
80104763:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104764:	f6 c4 02             	test   $0x2,%ah
80104767:	75 41                	jne    801047aa <sched+0x8a>
  intena = mycpu()->intena;
80104769:	e8 d2 fb ff ff       	call   80104340 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010476e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104771:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104777:	e8 c4 fb ff ff       	call   80104340 <mycpu>
8010477c:	83 ec 08             	sub    $0x8,%esp
8010477f:	ff 70 04             	push   0x4(%eax)
80104782:	53                   	push   %ebx
80104783:	e8 43 0b 00 00       	call   801052cb <swtch>
  mycpu()->intena = intena;
80104788:	e8 b3 fb ff ff       	call   80104340 <mycpu>
}
8010478d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104790:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104796:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104799:	5b                   	pop    %ebx
8010479a:	5e                   	pop    %esi
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret    
    panic("sched ptable.lock");
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	68 5b 81 10 80       	push   $0x8010815b
801047a5:	e8 66 bc ff ff       	call   80100410 <panic>
    panic("sched interruptible");
801047aa:	83 ec 0c             	sub    $0xc,%esp
801047ad:	68 87 81 10 80       	push   $0x80108187
801047b2:	e8 59 bc ff ff       	call   80100410 <panic>
    panic("sched running");
801047b7:	83 ec 0c             	sub    $0xc,%esp
801047ba:	68 79 81 10 80       	push   $0x80108179
801047bf:	e8 4c bc ff ff       	call   80100410 <panic>
    panic("sched locks");
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	68 6d 81 10 80       	push   $0x8010816d
801047cc:	e8 3f bc ff ff       	call   80100410 <panic>
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <exit>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801047e9:	e8 d2 fb ff ff       	call   801043c0 <myproc>
  if(curproc == initproc)
801047ee:	39 05 74 57 11 80    	cmp    %eax,0x80115774
801047f4:	0f 84 fd 00 00 00    	je     801048f7 <exit+0x117>
801047fa:	89 c3                	mov    %eax,%ebx
801047fc:	8d 70 28             	lea    0x28(%eax),%esi
801047ff:	8d 78 68             	lea    0x68(%eax),%edi
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104808:	8b 06                	mov    (%esi),%eax
8010480a:	85 c0                	test   %eax,%eax
8010480c:	74 12                	je     80104820 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010480e:	83 ec 0c             	sub    $0xc,%esp
80104811:	50                   	push   %eax
80104812:	e8 29 d1 ff ff       	call   80101940 <fileclose>
      curproc->ofile[fd] = 0;
80104817:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010481d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104820:	83 c6 04             	add    $0x4,%esi
80104823:	39 f7                	cmp    %esi,%edi
80104825:	75 e1                	jne    80104808 <exit+0x28>
  begin_op();
80104827:	e8 84 ef ff ff       	call   801037b0 <begin_op>
  iput(curproc->cwd);
8010482c:	83 ec 0c             	sub    $0xc,%esp
8010482f:	ff 73 68             	push   0x68(%ebx)
80104832:	e8 c9 da ff ff       	call   80102300 <iput>
  end_op();
80104837:	e8 e4 ef ff ff       	call   80103820 <end_op>
  curproc->cwd = 0;
8010483c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104843:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
8010484a:	e8 a1 07 00 00       	call   80104ff0 <acquire>
  wakeup1(curproc->parent);
8010484f:	8b 53 14             	mov    0x14(%ebx),%edx
80104852:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104855:	b8 74 38 11 80       	mov    $0x80113874,%eax
8010485a:	eb 0e                	jmp    8010486a <exit+0x8a>
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104860:	83 c0 7c             	add    $0x7c,%eax
80104863:	3d 74 57 11 80       	cmp    $0x80115774,%eax
80104868:	74 1c                	je     80104886 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010486a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010486e:	75 f0                	jne    80104860 <exit+0x80>
80104870:	3b 50 20             	cmp    0x20(%eax),%edx
80104873:	75 eb                	jne    80104860 <exit+0x80>
      p->state = RUNNABLE;
80104875:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010487c:	83 c0 7c             	add    $0x7c,%eax
8010487f:	3d 74 57 11 80       	cmp    $0x80115774,%eax
80104884:	75 e4                	jne    8010486a <exit+0x8a>
      p->parent = initproc;
80104886:	8b 0d 74 57 11 80    	mov    0x80115774,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488c:	ba 74 38 11 80       	mov    $0x80113874,%edx
80104891:	eb 10                	jmp    801048a3 <exit+0xc3>
80104893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104897:	90                   	nop
80104898:	83 c2 7c             	add    $0x7c,%edx
8010489b:	81 fa 74 57 11 80    	cmp    $0x80115774,%edx
801048a1:	74 3b                	je     801048de <exit+0xfe>
    if(p->parent == curproc){
801048a3:	39 5a 14             	cmp    %ebx,0x14(%edx)
801048a6:	75 f0                	jne    80104898 <exit+0xb8>
      if(p->state == ZOMBIE)
801048a8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801048ac:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801048af:	75 e7                	jne    80104898 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b1:	b8 74 38 11 80       	mov    $0x80113874,%eax
801048b6:	eb 12                	jmp    801048ca <exit+0xea>
801048b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop
801048c0:	83 c0 7c             	add    $0x7c,%eax
801048c3:	3d 74 57 11 80       	cmp    $0x80115774,%eax
801048c8:	74 ce                	je     80104898 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801048ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048ce:	75 f0                	jne    801048c0 <exit+0xe0>
801048d0:	3b 48 20             	cmp    0x20(%eax),%ecx
801048d3:	75 eb                	jne    801048c0 <exit+0xe0>
      p->state = RUNNABLE;
801048d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048dc:	eb e2                	jmp    801048c0 <exit+0xe0>
  curproc->state = ZOMBIE;
801048de:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801048e5:	e8 36 fe ff ff       	call   80104720 <sched>
  panic("zombie exit");
801048ea:	83 ec 0c             	sub    $0xc,%esp
801048ed:	68 a8 81 10 80       	push   $0x801081a8
801048f2:	e8 19 bb ff ff       	call   80100410 <panic>
    panic("init exiting");
801048f7:	83 ec 0c             	sub    $0xc,%esp
801048fa:	68 9b 81 10 80       	push   $0x8010819b
801048ff:	e8 0c bb ff ff       	call   80100410 <panic>
80104904:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop

80104910 <wait>:
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	53                   	push   %ebx
  pushcli();
80104915:	e8 86 05 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010491a:	e8 21 fa ff ff       	call   80104340 <mycpu>
  p = c->proc;
8010491f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104925:	e8 c6 05 00 00       	call   80104ef0 <popcli>
  acquire(&ptable.lock);
8010492a:	83 ec 0c             	sub    $0xc,%esp
8010492d:	68 40 38 11 80       	push   $0x80113840
80104932:	e8 b9 06 00 00       	call   80104ff0 <acquire>
80104937:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010493a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493c:	bb 74 38 11 80       	mov    $0x80113874,%ebx
80104941:	eb 10                	jmp    80104953 <wait+0x43>
80104943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104947:	90                   	nop
80104948:	83 c3 7c             	add    $0x7c,%ebx
8010494b:	81 fb 74 57 11 80    	cmp    $0x80115774,%ebx
80104951:	74 1b                	je     8010496e <wait+0x5e>
      if(p->parent != curproc)
80104953:	39 73 14             	cmp    %esi,0x14(%ebx)
80104956:	75 f0                	jne    80104948 <wait+0x38>
      if(p->state == ZOMBIE){
80104958:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010495c:	74 62                	je     801049c0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010495e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104961:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104966:	81 fb 74 57 11 80    	cmp    $0x80115774,%ebx
8010496c:	75 e5                	jne    80104953 <wait+0x43>
    if(!havekids || curproc->killed){
8010496e:	85 c0                	test   %eax,%eax
80104970:	0f 84 a0 00 00 00    	je     80104a16 <wait+0x106>
80104976:	8b 46 24             	mov    0x24(%esi),%eax
80104979:	85 c0                	test   %eax,%eax
8010497b:	0f 85 95 00 00 00    	jne    80104a16 <wait+0x106>
  pushcli();
80104981:	e8 1a 05 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104986:	e8 b5 f9 ff ff       	call   80104340 <mycpu>
  p = c->proc;
8010498b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104991:	e8 5a 05 00 00       	call   80104ef0 <popcli>
  if(p == 0)
80104996:	85 db                	test   %ebx,%ebx
80104998:	0f 84 8f 00 00 00    	je     80104a2d <wait+0x11d>
  p->chan = chan;
8010499e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801049a1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049a8:	e8 73 fd ff ff       	call   80104720 <sched>
  p->chan = 0;
801049ad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801049b4:	eb 84                	jmp    8010493a <wait+0x2a>
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801049c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801049c3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801049c6:	ff 73 08             	push   0x8(%ebx)
801049c9:	e8 42 e5 ff ff       	call   80102f10 <kfree>
        p->kstack = 0;
801049ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801049d5:	5a                   	pop    %edx
801049d6:	ff 73 04             	push   0x4(%ebx)
801049d9:	e8 32 2e 00 00       	call   80107810 <freevm>
        p->pid = 0;
801049de:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801049e5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801049ec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801049f0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801049f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801049fe:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104a05:	e8 86 05 00 00       	call   80104f90 <release>
        return pid;
80104a0a:	83 c4 10             	add    $0x10,%esp
}
80104a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a10:	89 f0                	mov    %esi,%eax
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
80104a15:	c3                   	ret    
      release(&ptable.lock);
80104a16:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a19:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a1e:	68 40 38 11 80       	push   $0x80113840
80104a23:	e8 68 05 00 00       	call   80104f90 <release>
      return -1;
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	eb e0                	jmp    80104a0d <wait+0xfd>
    panic("sleep");
80104a2d:	83 ec 0c             	sub    $0xc,%esp
80104a30:	68 b4 81 10 80       	push   $0x801081b4
80104a35:	e8 d6 b9 ff ff       	call   80100410 <panic>
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a40 <yield>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a47:	68 40 38 11 80       	push   $0x80113840
80104a4c:	e8 9f 05 00 00       	call   80104ff0 <acquire>
  pushcli();
80104a51:	e8 4a 04 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104a56:	e8 e5 f8 ff ff       	call   80104340 <mycpu>
  p = c->proc;
80104a5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a61:	e8 8a 04 00 00       	call   80104ef0 <popcli>
  myproc()->state = RUNNABLE;
80104a66:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104a6d:	e8 ae fc ff ff       	call   80104720 <sched>
  release(&ptable.lock);
80104a72:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104a79:	e8 12 05 00 00       	call   80104f90 <release>
}
80104a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a81:	83 c4 10             	add    $0x10,%esp
80104a84:	c9                   	leave  
80104a85:	c3                   	ret    
80104a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <sleep>:
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	83 ec 0c             	sub    $0xc,%esp
80104a99:	8b 7d 08             	mov    0x8(%ebp),%edi
80104a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104a9f:	e8 fc 03 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104aa4:	e8 97 f8 ff ff       	call   80104340 <mycpu>
  p = c->proc;
80104aa9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aaf:	e8 3c 04 00 00       	call   80104ef0 <popcli>
  if(p == 0)
80104ab4:	85 db                	test   %ebx,%ebx
80104ab6:	0f 84 87 00 00 00    	je     80104b43 <sleep+0xb3>
  if(lk == 0)
80104abc:	85 f6                	test   %esi,%esi
80104abe:	74 76                	je     80104b36 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ac0:	81 fe 40 38 11 80    	cmp    $0x80113840,%esi
80104ac6:	74 50                	je     80104b18 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ac8:	83 ec 0c             	sub    $0xc,%esp
80104acb:	68 40 38 11 80       	push   $0x80113840
80104ad0:	e8 1b 05 00 00       	call   80104ff0 <acquire>
    release(lk);
80104ad5:	89 34 24             	mov    %esi,(%esp)
80104ad8:	e8 b3 04 00 00       	call   80104f90 <release>
  p->chan = chan;
80104add:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104ae0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104ae7:	e8 34 fc ff ff       	call   80104720 <sched>
  p->chan = 0;
80104aec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104af3:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104afa:	e8 91 04 00 00       	call   80104f90 <release>
    acquire(lk);
80104aff:	89 75 08             	mov    %esi,0x8(%ebp)
80104b02:	83 c4 10             	add    $0x10,%esp
}
80104b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b08:	5b                   	pop    %ebx
80104b09:	5e                   	pop    %esi
80104b0a:	5f                   	pop    %edi
80104b0b:	5d                   	pop    %ebp
    acquire(lk);
80104b0c:	e9 df 04 00 00       	jmp    80104ff0 <acquire>
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b18:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b1b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b22:	e8 f9 fb ff ff       	call   80104720 <sched>
  p->chan = 0;
80104b27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b31:	5b                   	pop    %ebx
80104b32:	5e                   	pop    %esi
80104b33:	5f                   	pop    %edi
80104b34:	5d                   	pop    %ebp
80104b35:	c3                   	ret    
    panic("sleep without lk");
80104b36:	83 ec 0c             	sub    $0xc,%esp
80104b39:	68 ba 81 10 80       	push   $0x801081ba
80104b3e:	e8 cd b8 ff ff       	call   80100410 <panic>
    panic("sleep");
80104b43:	83 ec 0c             	sub    $0xc,%esp
80104b46:	68 b4 81 10 80       	push   $0x801081b4
80104b4b:	e8 c0 b8 ff ff       	call   80100410 <panic>

80104b50 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 10             	sub    $0x10,%esp
80104b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104b5a:	68 40 38 11 80       	push   $0x80113840
80104b5f:	e8 8c 04 00 00       	call   80104ff0 <acquire>
80104b64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b67:	b8 74 38 11 80       	mov    $0x80113874,%eax
80104b6c:	eb 0c                	jmp    80104b7a <wakeup+0x2a>
80104b6e:	66 90                	xchg   %ax,%ax
80104b70:	83 c0 7c             	add    $0x7c,%eax
80104b73:	3d 74 57 11 80       	cmp    $0x80115774,%eax
80104b78:	74 1c                	je     80104b96 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80104b7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b7e:	75 f0                	jne    80104b70 <wakeup+0x20>
80104b80:	3b 58 20             	cmp    0x20(%eax),%ebx
80104b83:	75 eb                	jne    80104b70 <wakeup+0x20>
      p->state = RUNNABLE;
80104b85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b8c:	83 c0 7c             	add    $0x7c,%eax
80104b8f:	3d 74 57 11 80       	cmp    $0x80115774,%eax
80104b94:	75 e4                	jne    80104b7a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104b96:	c7 45 08 40 38 11 80 	movl   $0x80113840,0x8(%ebp)
}
80104b9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba0:	c9                   	leave  
  release(&ptable.lock);
80104ba1:	e9 ea 03 00 00       	jmp    80104f90 <release>
80104ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bad:	8d 76 00             	lea    0x0(%esi),%esi

80104bb0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 10             	sub    $0x10,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104bba:	68 40 38 11 80       	push   $0x80113840
80104bbf:	e8 2c 04 00 00       	call   80104ff0 <acquire>
80104bc4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc7:	b8 74 38 11 80       	mov    $0x80113874,%eax
80104bcc:	eb 0c                	jmp    80104bda <kill+0x2a>
80104bce:	66 90                	xchg   %ax,%ax
80104bd0:	83 c0 7c             	add    $0x7c,%eax
80104bd3:	3d 74 57 11 80       	cmp    $0x80115774,%eax
80104bd8:	74 36                	je     80104c10 <kill+0x60>
    if(p->pid == pid){
80104bda:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bdd:	75 f1                	jne    80104bd0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104bdf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104be3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104bea:	75 07                	jne    80104bf3 <kill+0x43>
        p->state = RUNNABLE;
80104bec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104bf3:	83 ec 0c             	sub    $0xc,%esp
80104bf6:	68 40 38 11 80       	push   $0x80113840
80104bfb:	e8 90 03 00 00       	call   80104f90 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104c03:	83 c4 10             	add    $0x10,%esp
80104c06:	31 c0                	xor    %eax,%eax
}
80104c08:	c9                   	leave  
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104c10:	83 ec 0c             	sub    $0xc,%esp
80104c13:	68 40 38 11 80       	push   $0x80113840
80104c18:	e8 73 03 00 00       	call   80104f90 <release>
}
80104c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104c20:	83 c4 10             	add    $0x10,%esp
80104c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c28:	c9                   	leave  
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104c38:	53                   	push   %ebx
80104c39:	bb e0 38 11 80       	mov    $0x801138e0,%ebx
80104c3e:	83 ec 3c             	sub    $0x3c,%esp
80104c41:	eb 24                	jmp    80104c67 <procdump+0x37>
80104c43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c47:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c48:	83 ec 0c             	sub    $0xc,%esp
80104c4b:	68 37 85 10 80       	push   $0x80108537
80104c50:	e8 3b bb ff ff       	call   80100790 <cprintf>
80104c55:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c58:	83 c3 7c             	add    $0x7c,%ebx
80104c5b:	81 fb e0 57 11 80    	cmp    $0x801157e0,%ebx
80104c61:	0f 84 81 00 00 00    	je     80104ce8 <procdump+0xb8>
    if(p->state == UNUSED)
80104c67:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	74 ea                	je     80104c58 <procdump+0x28>
      state = "???";
80104c6e:	ba cb 81 10 80       	mov    $0x801081cb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c73:	83 f8 05             	cmp    $0x5,%eax
80104c76:	77 11                	ja     80104c89 <procdump+0x59>
80104c78:	8b 14 85 2c 82 10 80 	mov    -0x7fef7dd4(,%eax,4),%edx
      state = "???";
80104c7f:	b8 cb 81 10 80       	mov    $0x801081cb,%eax
80104c84:	85 d2                	test   %edx,%edx
80104c86:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c89:	53                   	push   %ebx
80104c8a:	52                   	push   %edx
80104c8b:	ff 73 a4             	push   -0x5c(%ebx)
80104c8e:	68 cf 81 10 80       	push   $0x801081cf
80104c93:	e8 f8 ba ff ff       	call   80100790 <cprintf>
    if(p->state == SLEEPING){
80104c98:	83 c4 10             	add    $0x10,%esp
80104c9b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104c9f:	75 a7                	jne    80104c48 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ca1:	83 ec 08             	sub    $0x8,%esp
80104ca4:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104ca7:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104caa:	50                   	push   %eax
80104cab:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104cae:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb1:	83 c0 08             	add    $0x8,%eax
80104cb4:	50                   	push   %eax
80104cb5:	e8 86 01 00 00       	call   80104e40 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104cba:	83 c4 10             	add    $0x10,%esp
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi
80104cc0:	8b 17                	mov    (%edi),%edx
80104cc2:	85 d2                	test   %edx,%edx
80104cc4:	74 82                	je     80104c48 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104cc6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104cc9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104ccc:	52                   	push   %edx
80104ccd:	68 21 7c 10 80       	push   $0x80107c21
80104cd2:	e8 b9 ba ff ff       	call   80100790 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	39 fe                	cmp    %edi,%esi
80104cdc:	75 e2                	jne    80104cc0 <procdump+0x90>
80104cde:	e9 65 ff ff ff       	jmp    80104c48 <procdump+0x18>
80104ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ce7:	90                   	nop
  }
}
80104ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ceb:	5b                   	pop    %ebx
80104cec:	5e                   	pop    %esi
80104ced:	5f                   	pop    %edi
80104cee:	5d                   	pop    %ebp
80104cef:	c3                   	ret    

80104cf0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104cfa:	68 44 82 10 80       	push   $0x80108244
80104cff:	8d 43 04             	lea    0x4(%ebx),%eax
80104d02:	50                   	push   %eax
80104d03:	e8 18 01 00 00       	call   80104e20 <initlock>
  lk->name = name;
80104d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d11:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d14:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d1b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d21:	c9                   	leave  
80104d22:	c3                   	ret    
80104d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d38:	8d 73 04             	lea    0x4(%ebx),%esi
80104d3b:	83 ec 0c             	sub    $0xc,%esp
80104d3e:	56                   	push   %esi
80104d3f:	e8 ac 02 00 00       	call   80104ff0 <acquire>
  while (lk->locked) {
80104d44:	8b 13                	mov    (%ebx),%edx
80104d46:	83 c4 10             	add    $0x10,%esp
80104d49:	85 d2                	test   %edx,%edx
80104d4b:	74 16                	je     80104d63 <acquiresleep+0x33>
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104d50:	83 ec 08             	sub    $0x8,%esp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	e8 36 fd ff ff       	call   80104a90 <sleep>
  while (lk->locked) {
80104d5a:	8b 03                	mov    (%ebx),%eax
80104d5c:	83 c4 10             	add    $0x10,%esp
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	75 ed                	jne    80104d50 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104d63:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104d69:	e8 52 f6 ff ff       	call   801043c0 <myproc>
80104d6e:	8b 40 10             	mov    0x10(%eax),%eax
80104d71:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104d74:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d7a:	5b                   	pop    %ebx
80104d7b:	5e                   	pop    %esi
80104d7c:	5d                   	pop    %ebp
  release(&lk->lk);
80104d7d:	e9 0e 02 00 00       	jmp    80104f90 <release>
80104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d90 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d98:	8d 73 04             	lea    0x4(%ebx),%esi
80104d9b:	83 ec 0c             	sub    $0xc,%esp
80104d9e:	56                   	push   %esi
80104d9f:	e8 4c 02 00 00       	call   80104ff0 <acquire>
  lk->locked = 0;
80104da4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104daa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104db1:	89 1c 24             	mov    %ebx,(%esp)
80104db4:	e8 97 fd ff ff       	call   80104b50 <wakeup>
  release(&lk->lk);
80104db9:	89 75 08             	mov    %esi,0x8(%ebp)
80104dbc:	83 c4 10             	add    $0x10,%esp
}
80104dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104dc5:	e9 c6 01 00 00       	jmp    80104f90 <release>
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	31 ff                	xor    %edi,%edi
80104dd6:	56                   	push   %esi
80104dd7:	53                   	push   %ebx
80104dd8:	83 ec 18             	sub    $0x18,%esp
80104ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104dde:	8d 73 04             	lea    0x4(%ebx),%esi
80104de1:	56                   	push   %esi
80104de2:	e8 09 02 00 00       	call   80104ff0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104de7:	8b 03                	mov    (%ebx),%eax
80104de9:	83 c4 10             	add    $0x10,%esp
80104dec:	85 c0                	test   %eax,%eax
80104dee:	75 18                	jne    80104e08 <holdingsleep+0x38>
  release(&lk->lk);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	56                   	push   %esi
80104df4:	e8 97 01 00 00       	call   80104f90 <release>
  return r;
}
80104df9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dfc:	89 f8                	mov    %edi,%eax
80104dfe:	5b                   	pop    %ebx
80104dff:	5e                   	pop    %esi
80104e00:	5f                   	pop    %edi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e07:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104e08:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e0b:	e8 b0 f5 ff ff       	call   801043c0 <myproc>
80104e10:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e13:	0f 94 c0             	sete   %al
80104e16:	0f b6 c0             	movzbl %al,%eax
80104e19:	89 c7                	mov    %eax,%edi
80104e1b:	eb d3                	jmp    80104df0 <holdingsleep+0x20>
80104e1d:	66 90                	xchg   %ax,%ax
80104e1f:	90                   	nop

80104e20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop

80104e40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e40:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e41:	31 d2                	xor    %edx,%edx
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e46:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e4c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104e4f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e50:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104e56:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e5c:	77 1a                	ja     80104e78 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e5e:	8b 58 04             	mov    0x4(%eax),%ebx
80104e61:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e64:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e67:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e69:	83 fa 0a             	cmp    $0xa,%edx
80104e6c:	75 e2                	jne    80104e50 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e71:	c9                   	leave  
80104e72:	c3                   	ret    
80104e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e77:	90                   	nop
  for(; i < 10; i++)
80104e78:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e7b:	8d 51 28             	lea    0x28(%ecx),%edx
80104e7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e86:	83 c0 04             	add    $0x4,%eax
80104e89:	39 d0                	cmp    %edx,%eax
80104e8b:	75 f3                	jne    80104e80 <getcallerpcs+0x40>
}
80104e8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e90:	c9                   	leave  
80104e91:	c3                   	ret    
80104e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
80104ea7:	9c                   	pushf  
80104ea8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ea9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104eaa:	e8 91 f4 ff ff       	call   80104340 <mycpu>
80104eaf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	74 17                	je     80104ed0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104eb9:	e8 82 f4 ff ff       	call   80104340 <mycpu>
80104ebe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ec5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ec8:	c9                   	leave  
80104ec9:	c3                   	ret    
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104ed0:	e8 6b f4 ff ff       	call   80104340 <mycpu>
80104ed5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104edb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ee1:	eb d6                	jmp    80104eb9 <pushcli+0x19>
80104ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ef0 <popcli>:

void
popcli(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ef6:	9c                   	pushf  
80104ef7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ef8:	f6 c4 02             	test   $0x2,%ah
80104efb:	75 35                	jne    80104f32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104efd:	e8 3e f4 ff ff       	call   80104340 <mycpu>
80104f02:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f09:	78 34                	js     80104f3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f0b:	e8 30 f4 ff ff       	call   80104340 <mycpu>
80104f10:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f16:	85 d2                	test   %edx,%edx
80104f18:	74 06                	je     80104f20 <popcli+0x30>
    sti();
}
80104f1a:	c9                   	leave  
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f20:	e8 1b f4 ff ff       	call   80104340 <mycpu>
80104f25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f2b:	85 c0                	test   %eax,%eax
80104f2d:	74 eb                	je     80104f1a <popcli+0x2a>
  asm volatile("sti");
80104f2f:	fb                   	sti    
}
80104f30:	c9                   	leave  
80104f31:	c3                   	ret    
    panic("popcli - interruptible");
80104f32:	83 ec 0c             	sub    $0xc,%esp
80104f35:	68 4f 82 10 80       	push   $0x8010824f
80104f3a:	e8 d1 b4 ff ff       	call   80100410 <panic>
    panic("popcli");
80104f3f:	83 ec 0c             	sub    $0xc,%esp
80104f42:	68 66 82 10 80       	push   $0x80108266
80104f47:	e8 c4 b4 ff ff       	call   80100410 <panic>
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <holding>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
80104f55:	8b 75 08             	mov    0x8(%ebp),%esi
80104f58:	31 db                	xor    %ebx,%ebx
  pushcli();
80104f5a:	e8 41 ff ff ff       	call   80104ea0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f5f:	8b 06                	mov    (%esi),%eax
80104f61:	85 c0                	test   %eax,%eax
80104f63:	75 0b                	jne    80104f70 <holding+0x20>
  popcli();
80104f65:	e8 86 ff ff ff       	call   80104ef0 <popcli>
}
80104f6a:	89 d8                	mov    %ebx,%eax
80104f6c:	5b                   	pop    %ebx
80104f6d:	5e                   	pop    %esi
80104f6e:	5d                   	pop    %ebp
80104f6f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104f70:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f73:	e8 c8 f3 ff ff       	call   80104340 <mycpu>
80104f78:	39 c3                	cmp    %eax,%ebx
80104f7a:	0f 94 c3             	sete   %bl
  popcli();
80104f7d:	e8 6e ff ff ff       	call   80104ef0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104f82:	0f b6 db             	movzbl %bl,%ebx
}
80104f85:	89 d8                	mov    %ebx,%eax
80104f87:	5b                   	pop    %ebx
80104f88:	5e                   	pop    %esi
80104f89:	5d                   	pop    %ebp
80104f8a:	c3                   	ret    
80104f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f8f:	90                   	nop

80104f90 <release>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104f98:	e8 03 ff ff ff       	call   80104ea0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f9d:	8b 03                	mov    (%ebx),%eax
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	75 15                	jne    80104fb8 <release+0x28>
  popcli();
80104fa3:	e8 48 ff ff ff       	call   80104ef0 <popcli>
    panic("release");
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	68 6d 82 10 80       	push   $0x8010826d
80104fb0:	e8 5b b4 ff ff       	call   80100410 <panic>
80104fb5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104fb8:	8b 73 08             	mov    0x8(%ebx),%esi
80104fbb:	e8 80 f3 ff ff       	call   80104340 <mycpu>
80104fc0:	39 c6                	cmp    %eax,%esi
80104fc2:	75 df                	jne    80104fa3 <release+0x13>
  popcli();
80104fc4:	e8 27 ff ff ff       	call   80104ef0 <popcli>
  lk->pcs[0] = 0;
80104fc9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104fd0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104fd7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104fdc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe5:	5b                   	pop    %ebx
80104fe6:	5e                   	pop    %esi
80104fe7:	5d                   	pop    %ebp
  popcli();
80104fe8:	e9 03 ff ff ff       	jmp    80104ef0 <popcli>
80104fed:	8d 76 00             	lea    0x0(%esi),%esi

80104ff0 <acquire>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	53                   	push   %ebx
80104ff4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ff7:	e8 a4 fe ff ff       	call   80104ea0 <pushcli>
  if(holding(lk))
80104ffc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104fff:	e8 9c fe ff ff       	call   80104ea0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105004:	8b 03                	mov    (%ebx),%eax
80105006:	85 c0                	test   %eax,%eax
80105008:	75 7e                	jne    80105088 <acquire+0x98>
  popcli();
8010500a:	e8 e1 fe ff ff       	call   80104ef0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010500f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105018:	8b 55 08             	mov    0x8(%ebp),%edx
8010501b:	89 c8                	mov    %ecx,%eax
8010501d:	f0 87 02             	lock xchg %eax,(%edx)
80105020:	85 c0                	test   %eax,%eax
80105022:	75 f4                	jne    80105018 <acquire+0x28>
  __sync_synchronize();
80105024:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010502c:	e8 0f f3 ff ff       	call   80104340 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105031:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105034:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105036:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105039:	31 c0                	xor    %eax,%eax
8010503b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010503f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105040:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105046:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010504c:	77 1a                	ja     80105068 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010504e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105051:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105055:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105058:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010505a:	83 f8 0a             	cmp    $0xa,%eax
8010505d:	75 e1                	jne    80105040 <acquire+0x50>
}
8010505f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105062:	c9                   	leave  
80105063:	c3                   	ret    
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105068:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010506c:	8d 51 34             	lea    0x34(%ecx),%edx
8010506f:	90                   	nop
    pcs[i] = 0;
80105070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105076:	83 c0 04             	add    $0x4,%eax
80105079:	39 c2                	cmp    %eax,%edx
8010507b:	75 f3                	jne    80105070 <acquire+0x80>
}
8010507d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105080:	c9                   	leave  
80105081:	c3                   	ret    
80105082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105088:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010508b:	e8 b0 f2 ff ff       	call   80104340 <mycpu>
80105090:	39 c3                	cmp    %eax,%ebx
80105092:	0f 85 72 ff ff ff    	jne    8010500a <acquire+0x1a>
  popcli();
80105098:	e8 53 fe ff ff       	call   80104ef0 <popcli>
    panic("acquire");
8010509d:	83 ec 0c             	sub    $0xc,%esp
801050a0:	68 75 82 10 80       	push   $0x80108275
801050a5:	e8 66 b3 ff ff       	call   80100410 <panic>
801050aa:	66 90                	xchg   %ax,%ax
801050ac:	66 90                	xchg   %ax,%ax
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	8b 55 08             	mov    0x8(%ebp),%edx
801050b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050ba:	53                   	push   %ebx
801050bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801050be:	89 d7                	mov    %edx,%edi
801050c0:	09 cf                	or     %ecx,%edi
801050c2:	83 e7 03             	and    $0x3,%edi
801050c5:	75 29                	jne    801050f0 <memset+0x40>
    c &= 0xFF;
801050c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801050ca:	c1 e0 18             	shl    $0x18,%eax
801050cd:	89 fb                	mov    %edi,%ebx
801050cf:	c1 e9 02             	shr    $0x2,%ecx
801050d2:	c1 e3 10             	shl    $0x10,%ebx
801050d5:	09 d8                	or     %ebx,%eax
801050d7:	09 f8                	or     %edi,%eax
801050d9:	c1 e7 08             	shl    $0x8,%edi
801050dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801050de:	89 d7                	mov    %edx,%edi
801050e0:	fc                   	cld    
801050e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801050e3:	5b                   	pop    %ebx
801050e4:	89 d0                	mov    %edx,%eax
801050e6:	5f                   	pop    %edi
801050e7:	5d                   	pop    %ebp
801050e8:	c3                   	ret    
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801050f0:	89 d7                	mov    %edx,%edi
801050f2:	fc                   	cld    
801050f3:	f3 aa                	rep stos %al,%es:(%edi)
801050f5:	5b                   	pop    %ebx
801050f6:	89 d0                	mov    %edx,%eax
801050f8:	5f                   	pop    %edi
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret    
801050fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop

80105100 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	8b 75 10             	mov    0x10(%ebp),%esi
80105107:	8b 55 08             	mov    0x8(%ebp),%edx
8010510a:	53                   	push   %ebx
8010510b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010510e:	85 f6                	test   %esi,%esi
80105110:	74 2e                	je     80105140 <memcmp+0x40>
80105112:	01 c6                	add    %eax,%esi
80105114:	eb 14                	jmp    8010512a <memcmp+0x2a>
80105116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105120:	83 c0 01             	add    $0x1,%eax
80105123:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105126:	39 f0                	cmp    %esi,%eax
80105128:	74 16                	je     80105140 <memcmp+0x40>
    if(*s1 != *s2)
8010512a:	0f b6 0a             	movzbl (%edx),%ecx
8010512d:	0f b6 18             	movzbl (%eax),%ebx
80105130:	38 d9                	cmp    %bl,%cl
80105132:	74 ec                	je     80105120 <memcmp+0x20>
      return *s1 - *s2;
80105134:	0f b6 c1             	movzbl %cl,%eax
80105137:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5d                   	pop    %ebp
8010513c:	c3                   	ret    
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
80105140:	5b                   	pop    %ebx
  return 0;
80105141:	31 c0                	xor    %eax,%eax
}
80105143:	5e                   	pop    %esi
80105144:	5d                   	pop    %ebp
80105145:	c3                   	ret    
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi

80105150 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	8b 55 08             	mov    0x8(%ebp),%edx
80105157:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010515a:	56                   	push   %esi
8010515b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010515e:	39 d6                	cmp    %edx,%esi
80105160:	73 26                	jae    80105188 <memmove+0x38>
80105162:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105165:	39 fa                	cmp    %edi,%edx
80105167:	73 1f                	jae    80105188 <memmove+0x38>
80105169:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010516c:	85 c9                	test   %ecx,%ecx
8010516e:	74 0c                	je     8010517c <memmove+0x2c>
      *--d = *--s;
80105170:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105174:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105177:	83 e8 01             	sub    $0x1,%eax
8010517a:	73 f4                	jae    80105170 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010517c:	5e                   	pop    %esi
8010517d:	89 d0                	mov    %edx,%eax
8010517f:	5f                   	pop    %edi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret    
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105188:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010518b:	89 d7                	mov    %edx,%edi
8010518d:	85 c9                	test   %ecx,%ecx
8010518f:	74 eb                	je     8010517c <memmove+0x2c>
80105191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105198:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105199:	39 c6                	cmp    %eax,%esi
8010519b:	75 fb                	jne    80105198 <memmove+0x48>
}
8010519d:	5e                   	pop    %esi
8010519e:	89 d0                	mov    %edx,%eax
801051a0:	5f                   	pop    %edi
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret    
801051a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801051b0:	eb 9e                	jmp    80105150 <memmove>
801051b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	8b 75 10             	mov    0x10(%ebp),%esi
801051c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ca:	53                   	push   %ebx
801051cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801051ce:	85 f6                	test   %esi,%esi
801051d0:	74 2e                	je     80105200 <strncmp+0x40>
801051d2:	01 d6                	add    %edx,%esi
801051d4:	eb 18                	jmp    801051ee <strncmp+0x2e>
801051d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
801051e0:	38 d8                	cmp    %bl,%al
801051e2:	75 14                	jne    801051f8 <strncmp+0x38>
    n--, p++, q++;
801051e4:	83 c2 01             	add    $0x1,%edx
801051e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801051ea:	39 f2                	cmp    %esi,%edx
801051ec:	74 12                	je     80105200 <strncmp+0x40>
801051ee:	0f b6 01             	movzbl (%ecx),%eax
801051f1:	0f b6 1a             	movzbl (%edx),%ebx
801051f4:	84 c0                	test   %al,%al
801051f6:	75 e8                	jne    801051e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801051f8:	29 d8                	sub    %ebx,%eax
}
801051fa:	5b                   	pop    %ebx
801051fb:	5e                   	pop    %esi
801051fc:	5d                   	pop    %ebp
801051fd:	c3                   	ret    
801051fe:	66 90                	xchg   %ax,%ax
80105200:	5b                   	pop    %ebx
    return 0;
80105201:	31 c0                	xor    %eax,%eax
}
80105203:	5e                   	pop    %esi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi

80105210 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
80105215:	8b 75 08             	mov    0x8(%ebp),%esi
80105218:	53                   	push   %ebx
80105219:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010521c:	89 f0                	mov    %esi,%eax
8010521e:	eb 15                	jmp    80105235 <strncpy+0x25>
80105220:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105224:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105227:	83 c0 01             	add    $0x1,%eax
8010522a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010522e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105231:	84 d2                	test   %dl,%dl
80105233:	74 09                	je     8010523e <strncpy+0x2e>
80105235:	89 cb                	mov    %ecx,%ebx
80105237:	83 e9 01             	sub    $0x1,%ecx
8010523a:	85 db                	test   %ebx,%ebx
8010523c:	7f e2                	jg     80105220 <strncpy+0x10>
    ;
  while(n-- > 0)
8010523e:	89 c2                	mov    %eax,%edx
80105240:	85 c9                	test   %ecx,%ecx
80105242:	7e 17                	jle    8010525b <strncpy+0x4b>
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105248:	83 c2 01             	add    $0x1,%edx
8010524b:	89 c1                	mov    %eax,%ecx
8010524d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105251:	29 d1                	sub    %edx,%ecx
80105253:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105257:	85 c9                	test   %ecx,%ecx
80105259:	7f ed                	jg     80105248 <strncpy+0x38>
  return os;
}
8010525b:	5b                   	pop    %ebx
8010525c:	89 f0                	mov    %esi,%eax
8010525e:	5e                   	pop    %esi
8010525f:	5f                   	pop    %edi
80105260:	5d                   	pop    %ebp
80105261:	c3                   	ret    
80105262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105270 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	8b 55 10             	mov    0x10(%ebp),%edx
80105277:	8b 75 08             	mov    0x8(%ebp),%esi
8010527a:	53                   	push   %ebx
8010527b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010527e:	85 d2                	test   %edx,%edx
80105280:	7e 25                	jle    801052a7 <safestrcpy+0x37>
80105282:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105286:	89 f2                	mov    %esi,%edx
80105288:	eb 16                	jmp    801052a0 <safestrcpy+0x30>
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105290:	0f b6 08             	movzbl (%eax),%ecx
80105293:	83 c0 01             	add    $0x1,%eax
80105296:	83 c2 01             	add    $0x1,%edx
80105299:	88 4a ff             	mov    %cl,-0x1(%edx)
8010529c:	84 c9                	test   %cl,%cl
8010529e:	74 04                	je     801052a4 <safestrcpy+0x34>
801052a0:	39 d8                	cmp    %ebx,%eax
801052a2:	75 ec                	jne    80105290 <safestrcpy+0x20>
    ;
  *s = 0;
801052a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801052a7:	89 f0                	mov    %esi,%eax
801052a9:	5b                   	pop    %ebx
801052aa:	5e                   	pop    %esi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <strlen>:

int
strlen(const char *s)
{
801052b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801052b1:	31 c0                	xor    %eax,%eax
{
801052b3:	89 e5                	mov    %esp,%ebp
801052b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801052b8:	80 3a 00             	cmpb   $0x0,(%edx)
801052bb:	74 0c                	je     801052c9 <strlen+0x19>
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
801052c0:	83 c0 01             	add    $0x1,%eax
801052c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801052c7:	75 f7                	jne    801052c0 <strlen+0x10>
    ;
  return n;
}
801052c9:	5d                   	pop    %ebp
801052ca:	c3                   	ret    

801052cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801052cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801052cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801052d3:	55                   	push   %ebp
  pushl %ebx
801052d4:	53                   	push   %ebx
  pushl %esi
801052d5:	56                   	push   %esi
  pushl %edi
801052d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801052d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801052d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801052db:	5f                   	pop    %edi
  popl %esi
801052dc:	5e                   	pop    %esi
  popl %ebx
801052dd:	5b                   	pop    %ebx
  popl %ebp
801052de:	5d                   	pop    %ebp
  ret
801052df:	c3                   	ret    

801052e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 04             	sub    $0x4,%esp
801052e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801052ea:	e8 d1 f0 ff ff       	call   801043c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052ef:	8b 00                	mov    (%eax),%eax
801052f1:	39 d8                	cmp    %ebx,%eax
801052f3:	76 1b                	jbe    80105310 <fetchint+0x30>
801052f5:	8d 53 04             	lea    0x4(%ebx),%edx
801052f8:	39 d0                	cmp    %edx,%eax
801052fa:	72 14                	jb     80105310 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ff:	8b 13                	mov    (%ebx),%edx
80105301:	89 10                	mov    %edx,(%eax)
  return 0;
80105303:	31 c0                	xor    %eax,%eax
}
80105305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105308:	c9                   	leave  
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105315:	eb ee                	jmp    80105305 <fetchint+0x25>
80105317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531e:	66 90                	xchg   %ax,%ax

80105320 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 04             	sub    $0x4,%esp
80105327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010532a:	e8 91 f0 ff ff       	call   801043c0 <myproc>

  if(addr >= curproc->sz)
8010532f:	39 18                	cmp    %ebx,(%eax)
80105331:	76 2d                	jbe    80105360 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105333:	8b 55 0c             	mov    0xc(%ebp),%edx
80105336:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105338:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010533a:	39 d3                	cmp    %edx,%ebx
8010533c:	73 22                	jae    80105360 <fetchstr+0x40>
8010533e:	89 d8                	mov    %ebx,%eax
80105340:	eb 0d                	jmp    8010534f <fetchstr+0x2f>
80105342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105348:	83 c0 01             	add    $0x1,%eax
8010534b:	39 c2                	cmp    %eax,%edx
8010534d:	76 11                	jbe    80105360 <fetchstr+0x40>
    if(*s == 0)
8010534f:	80 38 00             	cmpb   $0x0,(%eax)
80105352:	75 f4                	jne    80105348 <fetchstr+0x28>
      return s - *pp;
80105354:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105356:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105359:	c9                   	leave  
8010535a:	c3                   	ret    
8010535b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
80105360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105368:	c9                   	leave  
80105369:	c3                   	ret    
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105370 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105375:	e8 46 f0 ff ff       	call   801043c0 <myproc>
8010537a:	8b 55 08             	mov    0x8(%ebp),%edx
8010537d:	8b 40 18             	mov    0x18(%eax),%eax
80105380:	8b 40 44             	mov    0x44(%eax),%eax
80105383:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105386:	e8 35 f0 ff ff       	call   801043c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010538b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010538e:	8b 00                	mov    (%eax),%eax
80105390:	39 c6                	cmp    %eax,%esi
80105392:	73 1c                	jae    801053b0 <argint+0x40>
80105394:	8d 53 08             	lea    0x8(%ebx),%edx
80105397:	39 d0                	cmp    %edx,%eax
80105399:	72 15                	jb     801053b0 <argint+0x40>
  *ip = *(int*)(addr);
8010539b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539e:	8b 53 04             	mov    0x4(%ebx),%edx
801053a1:	89 10                	mov    %edx,(%eax)
  return 0;
801053a3:	31 c0                	xor    %eax,%eax
}
801053a5:	5b                   	pop    %ebx
801053a6:	5e                   	pop    %esi
801053a7:	5d                   	pop    %ebp
801053a8:	c3                   	ret    
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053b5:	eb ee                	jmp    801053a5 <argint+0x35>
801053b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053be:	66 90                	xchg   %ax,%ax

801053c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
801053c5:	53                   	push   %ebx
801053c6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801053c9:	e8 f2 ef ff ff       	call   801043c0 <myproc>
801053ce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053d0:	e8 eb ef ff ff       	call   801043c0 <myproc>
801053d5:	8b 55 08             	mov    0x8(%ebp),%edx
801053d8:	8b 40 18             	mov    0x18(%eax),%eax
801053db:	8b 40 44             	mov    0x44(%eax),%eax
801053de:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801053e1:	e8 da ef ff ff       	call   801043c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053e6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053e9:	8b 00                	mov    (%eax),%eax
801053eb:	39 c7                	cmp    %eax,%edi
801053ed:	73 31                	jae    80105420 <argptr+0x60>
801053ef:	8d 4b 08             	lea    0x8(%ebx),%ecx
801053f2:	39 c8                	cmp    %ecx,%eax
801053f4:	72 2a                	jb     80105420 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053f6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801053f9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053fc:	85 d2                	test   %edx,%edx
801053fe:	78 20                	js     80105420 <argptr+0x60>
80105400:	8b 16                	mov    (%esi),%edx
80105402:	39 c2                	cmp    %eax,%edx
80105404:	76 1a                	jbe    80105420 <argptr+0x60>
80105406:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105409:	01 c3                	add    %eax,%ebx
8010540b:	39 da                	cmp    %ebx,%edx
8010540d:	72 11                	jb     80105420 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010540f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105412:	89 02                	mov    %eax,(%edx)
  return 0;
80105414:	31 c0                	xor    %eax,%eax
}
80105416:	83 c4 0c             	add    $0xc,%esp
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5f                   	pop    %edi
8010541c:	5d                   	pop    %ebp
8010541d:	c3                   	ret    
8010541e:	66 90                	xchg   %ax,%ax
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105425:	eb ef                	jmp    80105416 <argptr+0x56>
80105427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542e:	66 90                	xchg   %ax,%ax

80105430 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105435:	e8 86 ef ff ff       	call   801043c0 <myproc>
8010543a:	8b 55 08             	mov    0x8(%ebp),%edx
8010543d:	8b 40 18             	mov    0x18(%eax),%eax
80105440:	8b 40 44             	mov    0x44(%eax),%eax
80105443:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105446:	e8 75 ef ff ff       	call   801043c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010544b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010544e:	8b 00                	mov    (%eax),%eax
80105450:	39 c6                	cmp    %eax,%esi
80105452:	73 44                	jae    80105498 <argstr+0x68>
80105454:	8d 53 08             	lea    0x8(%ebx),%edx
80105457:	39 d0                	cmp    %edx,%eax
80105459:	72 3d                	jb     80105498 <argstr+0x68>
  *ip = *(int*)(addr);
8010545b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010545e:	e8 5d ef ff ff       	call   801043c0 <myproc>
  if(addr >= curproc->sz)
80105463:	3b 18                	cmp    (%eax),%ebx
80105465:	73 31                	jae    80105498 <argstr+0x68>
  *pp = (char*)addr;
80105467:	8b 55 0c             	mov    0xc(%ebp),%edx
8010546a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010546c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010546e:	39 d3                	cmp    %edx,%ebx
80105470:	73 26                	jae    80105498 <argstr+0x68>
80105472:	89 d8                	mov    %ebx,%eax
80105474:	eb 11                	jmp    80105487 <argstr+0x57>
80105476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
80105480:	83 c0 01             	add    $0x1,%eax
80105483:	39 c2                	cmp    %eax,%edx
80105485:	76 11                	jbe    80105498 <argstr+0x68>
    if(*s == 0)
80105487:	80 38 00             	cmpb   $0x0,(%eax)
8010548a:	75 f4                	jne    80105480 <argstr+0x50>
      return s - *pp;
8010548c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010548e:	5b                   	pop    %ebx
8010548f:	5e                   	pop    %esi
80105490:	5d                   	pop    %ebp
80105491:	c3                   	ret    
80105492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105498:	5b                   	pop    %ebx
    return -1;
80105499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010549e:	5e                   	pop    %esi
8010549f:	5d                   	pop    %ebp
801054a0:	c3                   	ret    
801054a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop

801054b0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801054b7:	e8 04 ef ff ff       	call   801043c0 <myproc>
801054bc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801054be:	8b 40 18             	mov    0x18(%eax),%eax
801054c1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801054c7:	83 fa 14             	cmp    $0x14,%edx
801054ca:	77 24                	ja     801054f0 <syscall+0x40>
801054cc:	8b 14 85 a0 82 10 80 	mov    -0x7fef7d60(,%eax,4),%edx
801054d3:	85 d2                	test   %edx,%edx
801054d5:	74 19                	je     801054f0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801054d7:	ff d2                	call   *%edx
801054d9:	89 c2                	mov    %eax,%edx
801054db:	8b 43 18             	mov    0x18(%ebx),%eax
801054de:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801054e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054e4:	c9                   	leave  
801054e5:	c3                   	ret    
801054e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801054f0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801054f1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801054f4:	50                   	push   %eax
801054f5:	ff 73 10             	push   0x10(%ebx)
801054f8:	68 7d 82 10 80       	push   $0x8010827d
801054fd:	e8 8e b2 ff ff       	call   80100790 <cprintf>
    curproc->tf->eax = -1;
80105502:	8b 43 18             	mov    0x18(%ebx),%eax
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010550f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105512:	c9                   	leave  
80105513:	c3                   	ret    
80105514:	66 90                	xchg   %ax,%ax
80105516:	66 90                	xchg   %ax,%ax
80105518:	66 90                	xchg   %ax,%ax
8010551a:	66 90                	xchg   %ax,%ax
8010551c:	66 90                	xchg   %ax,%ax
8010551e:	66 90                	xchg   %ax,%ax

80105520 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105525:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105528:	53                   	push   %ebx
80105529:	83 ec 34             	sub    $0x34,%esp
8010552c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010552f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105532:	57                   	push   %edi
80105533:	50                   	push   %eax
{
80105534:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105537:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010553a:	e8 d1 d5 ff ff       	call   80102b10 <nameiparent>
8010553f:	83 c4 10             	add    $0x10,%esp
80105542:	85 c0                	test   %eax,%eax
80105544:	0f 84 46 01 00 00    	je     80105690 <create+0x170>
    return 0;
  ilock(dp);
8010554a:	83 ec 0c             	sub    $0xc,%esp
8010554d:	89 c3                	mov    %eax,%ebx
8010554f:	50                   	push   %eax
80105550:	e8 7b cc ff ff       	call   801021d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105555:	83 c4 0c             	add    $0xc,%esp
80105558:	6a 00                	push   $0x0
8010555a:	57                   	push   %edi
8010555b:	53                   	push   %ebx
8010555c:	e8 cf d1 ff ff       	call   80102730 <dirlookup>
80105561:	83 c4 10             	add    $0x10,%esp
80105564:	89 c6                	mov    %eax,%esi
80105566:	85 c0                	test   %eax,%eax
80105568:	74 56                	je     801055c0 <create+0xa0>
    iunlockput(dp);
8010556a:	83 ec 0c             	sub    $0xc,%esp
8010556d:	53                   	push   %ebx
8010556e:	e8 ed ce ff ff       	call   80102460 <iunlockput>
    ilock(ip);
80105573:	89 34 24             	mov    %esi,(%esp)
80105576:	e8 55 cc ff ff       	call   801021d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010557b:	83 c4 10             	add    $0x10,%esp
8010557e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105583:	75 1b                	jne    801055a0 <create+0x80>
80105585:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010558a:	75 14                	jne    801055a0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010558c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010558f:	89 f0                	mov    %esi,%eax
80105591:	5b                   	pop    %ebx
80105592:	5e                   	pop    %esi
80105593:	5f                   	pop    %edi
80105594:	5d                   	pop    %ebp
80105595:	c3                   	ret    
80105596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	56                   	push   %esi
    return 0;
801055a4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801055a6:	e8 b5 ce ff ff       	call   80102460 <iunlockput>
    return 0;
801055ab:	83 c4 10             	add    $0x10,%esp
}
801055ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b1:	89 f0                	mov    %esi,%eax
801055b3:	5b                   	pop    %ebx
801055b4:	5e                   	pop    %esi
801055b5:	5f                   	pop    %edi
801055b6:	5d                   	pop    %ebp
801055b7:	c3                   	ret    
801055b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055bf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801055c0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801055c4:	83 ec 08             	sub    $0x8,%esp
801055c7:	50                   	push   %eax
801055c8:	ff 33                	push   (%ebx)
801055ca:	e8 91 ca ff ff       	call   80102060 <ialloc>
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	89 c6                	mov    %eax,%esi
801055d4:	85 c0                	test   %eax,%eax
801055d6:	0f 84 cd 00 00 00    	je     801056a9 <create+0x189>
  ilock(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	50                   	push   %eax
801055e0:	e8 eb cb ff ff       	call   801021d0 <ilock>
  ip->major = major;
801055e5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801055e9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801055ed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801055f1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801055f5:	b8 01 00 00 00       	mov    $0x1,%eax
801055fa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801055fe:	89 34 24             	mov    %esi,(%esp)
80105601:	e8 1a cb ff ff       	call   80102120 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010560e:	74 30                	je     80105640 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105610:	83 ec 04             	sub    $0x4,%esp
80105613:	ff 76 04             	push   0x4(%esi)
80105616:	57                   	push   %edi
80105617:	53                   	push   %ebx
80105618:	e8 13 d4 ff ff       	call   80102a30 <dirlink>
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	85 c0                	test   %eax,%eax
80105622:	78 78                	js     8010569c <create+0x17c>
  iunlockput(dp);
80105624:	83 ec 0c             	sub    $0xc,%esp
80105627:	53                   	push   %ebx
80105628:	e8 33 ce ff ff       	call   80102460 <iunlockput>
  return ip;
8010562d:	83 c4 10             	add    $0x10,%esp
}
80105630:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105633:	89 f0                	mov    %esi,%eax
80105635:	5b                   	pop    %ebx
80105636:	5e                   	pop    %esi
80105637:	5f                   	pop    %edi
80105638:	5d                   	pop    %ebp
80105639:	c3                   	ret    
8010563a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105640:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105643:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105648:	53                   	push   %ebx
80105649:	e8 d2 ca ff ff       	call   80102120 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010564e:	83 c4 0c             	add    $0xc,%esp
80105651:	ff 76 04             	push   0x4(%esi)
80105654:	68 14 83 10 80       	push   $0x80108314
80105659:	56                   	push   %esi
8010565a:	e8 d1 d3 ff ff       	call   80102a30 <dirlink>
8010565f:	83 c4 10             	add    $0x10,%esp
80105662:	85 c0                	test   %eax,%eax
80105664:	78 18                	js     8010567e <create+0x15e>
80105666:	83 ec 04             	sub    $0x4,%esp
80105669:	ff 73 04             	push   0x4(%ebx)
8010566c:	68 13 83 10 80       	push   $0x80108313
80105671:	56                   	push   %esi
80105672:	e8 b9 d3 ff ff       	call   80102a30 <dirlink>
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	85 c0                	test   %eax,%eax
8010567c:	79 92                	jns    80105610 <create+0xf0>
      panic("create dots");
8010567e:	83 ec 0c             	sub    $0xc,%esp
80105681:	68 07 83 10 80       	push   $0x80108307
80105686:	e8 85 ad ff ff       	call   80100410 <panic>
8010568b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010568f:	90                   	nop
}
80105690:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105693:	31 f6                	xor    %esi,%esi
}
80105695:	5b                   	pop    %ebx
80105696:	89 f0                	mov    %esi,%eax
80105698:	5e                   	pop    %esi
80105699:	5f                   	pop    %edi
8010569a:	5d                   	pop    %ebp
8010569b:	c3                   	ret    
    panic("create: dirlink");
8010569c:	83 ec 0c             	sub    $0xc,%esp
8010569f:	68 16 83 10 80       	push   $0x80108316
801056a4:	e8 67 ad ff ff       	call   80100410 <panic>
    panic("create: ialloc");
801056a9:	83 ec 0c             	sub    $0xc,%esp
801056ac:	68 f8 82 10 80       	push   $0x801082f8
801056b1:	e8 5a ad ff ff       	call   80100410 <panic>
801056b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bd:	8d 76 00             	lea    0x0(%esi),%esi

801056c0 <sys_dup>:
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801056c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056cb:	50                   	push   %eax
801056cc:	6a 00                	push   $0x0
801056ce:	e8 9d fc ff ff       	call   80105370 <argint>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 36                	js     80105710 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056de:	77 30                	ja     80105710 <sys_dup+0x50>
801056e0:	e8 db ec ff ff       	call   801043c0 <myproc>
801056e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801056ec:	85 f6                	test   %esi,%esi
801056ee:	74 20                	je     80105710 <sys_dup+0x50>
  struct proc *curproc = myproc();
801056f0:	e8 cb ec ff ff       	call   801043c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056f5:	31 db                	xor    %ebx,%ebx
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105700:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105704:	85 d2                	test   %edx,%edx
80105706:	74 18                	je     80105720 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105708:	83 c3 01             	add    $0x1,%ebx
8010570b:	83 fb 10             	cmp    $0x10,%ebx
8010570e:	75 f0                	jne    80105700 <sys_dup+0x40>
}
80105710:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105713:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105718:	89 d8                	mov    %ebx,%eax
8010571a:	5b                   	pop    %ebx
8010571b:	5e                   	pop    %esi
8010571c:	5d                   	pop    %ebp
8010571d:	c3                   	ret    
8010571e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105720:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105723:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105727:	56                   	push   %esi
80105728:	e8 c3 c1 ff ff       	call   801018f0 <filedup>
  return fd;
8010572d:	83 c4 10             	add    $0x10,%esp
}
80105730:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105733:	89 d8                	mov    %ebx,%eax
80105735:	5b                   	pop    %ebx
80105736:	5e                   	pop    %esi
80105737:	5d                   	pop    %ebp
80105738:	c3                   	ret    
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_read>:
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	56                   	push   %esi
80105744:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105745:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105748:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010574b:	53                   	push   %ebx
8010574c:	6a 00                	push   $0x0
8010574e:	e8 1d fc ff ff       	call   80105370 <argint>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	78 5e                	js     801057b8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010575a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010575e:	77 58                	ja     801057b8 <sys_read+0x78>
80105760:	e8 5b ec ff ff       	call   801043c0 <myproc>
80105765:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105768:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010576c:	85 f6                	test   %esi,%esi
8010576e:	74 48                	je     801057b8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105770:	83 ec 08             	sub    $0x8,%esp
80105773:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105776:	50                   	push   %eax
80105777:	6a 02                	push   $0x2
80105779:	e8 f2 fb ff ff       	call   80105370 <argint>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	85 c0                	test   %eax,%eax
80105783:	78 33                	js     801057b8 <sys_read+0x78>
80105785:	83 ec 04             	sub    $0x4,%esp
80105788:	ff 75 f0             	push   -0x10(%ebp)
8010578b:	53                   	push   %ebx
8010578c:	6a 01                	push   $0x1
8010578e:	e8 2d fc ff ff       	call   801053c0 <argptr>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	78 1e                	js     801057b8 <sys_read+0x78>
  return fileread(f, p, n);
8010579a:	83 ec 04             	sub    $0x4,%esp
8010579d:	ff 75 f0             	push   -0x10(%ebp)
801057a0:	ff 75 f4             	push   -0xc(%ebp)
801057a3:	56                   	push   %esi
801057a4:	e8 c7 c2 ff ff       	call   80101a70 <fileread>
801057a9:	83 c4 10             	add    $0x10,%esp
}
801057ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057af:	5b                   	pop    %ebx
801057b0:	5e                   	pop    %esi
801057b1:	5d                   	pop    %ebp
801057b2:	c3                   	ret    
801057b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b7:	90                   	nop
    return -1;
801057b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bd:	eb ed                	jmp    801057ac <sys_read+0x6c>
801057bf:	90                   	nop

801057c0 <sys_write>:
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801057c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801057c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057cb:	53                   	push   %ebx
801057cc:	6a 00                	push   $0x0
801057ce:	e8 9d fb ff ff       	call   80105370 <argint>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 5e                	js     80105838 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057de:	77 58                	ja     80105838 <sys_write+0x78>
801057e0:	e8 db eb ff ff       	call   801043c0 <myproc>
801057e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801057ec:	85 f6                	test   %esi,%esi
801057ee:	74 48                	je     80105838 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f6:	50                   	push   %eax
801057f7:	6a 02                	push   $0x2
801057f9:	e8 72 fb ff ff       	call   80105370 <argint>
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	85 c0                	test   %eax,%eax
80105803:	78 33                	js     80105838 <sys_write+0x78>
80105805:	83 ec 04             	sub    $0x4,%esp
80105808:	ff 75 f0             	push   -0x10(%ebp)
8010580b:	53                   	push   %ebx
8010580c:	6a 01                	push   $0x1
8010580e:	e8 ad fb ff ff       	call   801053c0 <argptr>
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	78 1e                	js     80105838 <sys_write+0x78>
  return filewrite(f, p, n);
8010581a:	83 ec 04             	sub    $0x4,%esp
8010581d:	ff 75 f0             	push   -0x10(%ebp)
80105820:	ff 75 f4             	push   -0xc(%ebp)
80105823:	56                   	push   %esi
80105824:	e8 d7 c2 ff ff       	call   80101b00 <filewrite>
80105829:	83 c4 10             	add    $0x10,%esp
}
8010582c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010582f:	5b                   	pop    %ebx
80105830:	5e                   	pop    %esi
80105831:	5d                   	pop    %ebp
80105832:	c3                   	ret    
80105833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105837:	90                   	nop
    return -1;
80105838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583d:	eb ed                	jmp    8010582c <sys_write+0x6c>
8010583f:	90                   	nop

80105840 <sys_close>:
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	56                   	push   %esi
80105844:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105845:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105848:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010584b:	50                   	push   %eax
8010584c:	6a 00                	push   $0x0
8010584e:	e8 1d fb ff ff       	call   80105370 <argint>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	78 3e                	js     80105898 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010585a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010585e:	77 38                	ja     80105898 <sys_close+0x58>
80105860:	e8 5b eb ff ff       	call   801043c0 <myproc>
80105865:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105868:	8d 5a 08             	lea    0x8(%edx),%ebx
8010586b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010586f:	85 f6                	test   %esi,%esi
80105871:	74 25                	je     80105898 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105873:	e8 48 eb ff ff       	call   801043c0 <myproc>
  fileclose(f);
80105878:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010587b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105882:	00 
  fileclose(f);
80105883:	56                   	push   %esi
80105884:	e8 b7 c0 ff ff       	call   80101940 <fileclose>
  return 0;
80105889:	83 c4 10             	add    $0x10,%esp
8010588c:	31 c0                	xor    %eax,%eax
}
8010588e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105891:	5b                   	pop    %ebx
80105892:	5e                   	pop    %esi
80105893:	5d                   	pop    %ebp
80105894:	c3                   	ret    
80105895:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589d:	eb ef                	jmp    8010588e <sys_close+0x4e>
8010589f:	90                   	nop

801058a0 <sys_fstat>:
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801058a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801058a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058ab:	53                   	push   %ebx
801058ac:	6a 00                	push   $0x0
801058ae:	e8 bd fa ff ff       	call   80105370 <argint>
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	78 46                	js     80105900 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058be:	77 40                	ja     80105900 <sys_fstat+0x60>
801058c0:	e8 fb ea ff ff       	call   801043c0 <myproc>
801058c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801058cc:	85 f6                	test   %esi,%esi
801058ce:	74 30                	je     80105900 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058d0:	83 ec 04             	sub    $0x4,%esp
801058d3:	6a 14                	push   $0x14
801058d5:	53                   	push   %ebx
801058d6:	6a 01                	push   $0x1
801058d8:	e8 e3 fa ff ff       	call   801053c0 <argptr>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	78 1c                	js     80105900 <sys_fstat+0x60>
  return filestat(f, st);
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	ff 75 f4             	push   -0xc(%ebp)
801058ea:	56                   	push   %esi
801058eb:	e8 30 c1 ff ff       	call   80101a20 <filestat>
801058f0:	83 c4 10             	add    $0x10,%esp
}
801058f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058f6:	5b                   	pop    %ebx
801058f7:	5e                   	pop    %esi
801058f8:	5d                   	pop    %ebp
801058f9:	c3                   	ret    
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105905:	eb ec                	jmp    801058f3 <sys_fstat+0x53>
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_link>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105915:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105918:	53                   	push   %ebx
80105919:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010591c:	50                   	push   %eax
8010591d:	6a 00                	push   $0x0
8010591f:	e8 0c fb ff ff       	call   80105430 <argstr>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	0f 88 fb 00 00 00    	js     80105a2a <sys_link+0x11a>
8010592f:	83 ec 08             	sub    $0x8,%esp
80105932:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105935:	50                   	push   %eax
80105936:	6a 01                	push   $0x1
80105938:	e8 f3 fa ff ff       	call   80105430 <argstr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	0f 88 e2 00 00 00    	js     80105a2a <sys_link+0x11a>
  begin_op();
80105948:	e8 63 de ff ff       	call   801037b0 <begin_op>
  if((ip = namei(old)) == 0){
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	ff 75 d4             	push   -0x2c(%ebp)
80105953:	e8 98 d1 ff ff       	call   80102af0 <namei>
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	89 c3                	mov    %eax,%ebx
8010595d:	85 c0                	test   %eax,%eax
8010595f:	0f 84 e4 00 00 00    	je     80105a49 <sys_link+0x139>
  ilock(ip);
80105965:	83 ec 0c             	sub    $0xc,%esp
80105968:	50                   	push   %eax
80105969:	e8 62 c8 ff ff       	call   801021d0 <ilock>
  if(ip->type == T_DIR){
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105976:	0f 84 b5 00 00 00    	je     80105a31 <sys_link+0x121>
  iupdate(ip);
8010597c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010597f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105984:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105987:	53                   	push   %ebx
80105988:	e8 93 c7 ff ff       	call   80102120 <iupdate>
  iunlock(ip);
8010598d:	89 1c 24             	mov    %ebx,(%esp)
80105990:	e8 1b c9 ff ff       	call   801022b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105995:	58                   	pop    %eax
80105996:	5a                   	pop    %edx
80105997:	57                   	push   %edi
80105998:	ff 75 d0             	push   -0x30(%ebp)
8010599b:	e8 70 d1 ff ff       	call   80102b10 <nameiparent>
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	89 c6                	mov    %eax,%esi
801059a5:	85 c0                	test   %eax,%eax
801059a7:	74 5b                	je     80105a04 <sys_link+0xf4>
  ilock(dp);
801059a9:	83 ec 0c             	sub    $0xc,%esp
801059ac:	50                   	push   %eax
801059ad:	e8 1e c8 ff ff       	call   801021d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059b2:	8b 03                	mov    (%ebx),%eax
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	39 06                	cmp    %eax,(%esi)
801059b9:	75 3d                	jne    801059f8 <sys_link+0xe8>
801059bb:	83 ec 04             	sub    $0x4,%esp
801059be:	ff 73 04             	push   0x4(%ebx)
801059c1:	57                   	push   %edi
801059c2:	56                   	push   %esi
801059c3:	e8 68 d0 ff ff       	call   80102a30 <dirlink>
801059c8:	83 c4 10             	add    $0x10,%esp
801059cb:	85 c0                	test   %eax,%eax
801059cd:	78 29                	js     801059f8 <sys_link+0xe8>
  iunlockput(dp);
801059cf:	83 ec 0c             	sub    $0xc,%esp
801059d2:	56                   	push   %esi
801059d3:	e8 88 ca ff ff       	call   80102460 <iunlockput>
  iput(ip);
801059d8:	89 1c 24             	mov    %ebx,(%esp)
801059db:	e8 20 c9 ff ff       	call   80102300 <iput>
  end_op();
801059e0:	e8 3b de ff ff       	call   80103820 <end_op>
  return 0;
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	31 c0                	xor    %eax,%eax
}
801059ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ed:	5b                   	pop    %ebx
801059ee:	5e                   	pop    %esi
801059ef:	5f                   	pop    %edi
801059f0:	5d                   	pop    %ebp
801059f1:	c3                   	ret    
801059f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	56                   	push   %esi
801059fc:	e8 5f ca ff ff       	call   80102460 <iunlockput>
    goto bad;
80105a01:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	53                   	push   %ebx
80105a08:	e8 c3 c7 ff ff       	call   801021d0 <ilock>
  ip->nlink--;
80105a0d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a12:	89 1c 24             	mov    %ebx,(%esp)
80105a15:	e8 06 c7 ff ff       	call   80102120 <iupdate>
  iunlockput(ip);
80105a1a:	89 1c 24             	mov    %ebx,(%esp)
80105a1d:	e8 3e ca ff ff       	call   80102460 <iunlockput>
  end_op();
80105a22:	e8 f9 dd ff ff       	call   80103820 <end_op>
  return -1;
80105a27:	83 c4 10             	add    $0x10,%esp
80105a2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2f:	eb b9                	jmp    801059ea <sys_link+0xda>
    iunlockput(ip);
80105a31:	83 ec 0c             	sub    $0xc,%esp
80105a34:	53                   	push   %ebx
80105a35:	e8 26 ca ff ff       	call   80102460 <iunlockput>
    end_op();
80105a3a:	e8 e1 dd ff ff       	call   80103820 <end_op>
    return -1;
80105a3f:	83 c4 10             	add    $0x10,%esp
80105a42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a47:	eb a1                	jmp    801059ea <sys_link+0xda>
    end_op();
80105a49:	e8 d2 dd ff ff       	call   80103820 <end_op>
    return -1;
80105a4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a53:	eb 95                	jmp    801059ea <sys_link+0xda>
80105a55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_unlink>:
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105a65:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105a68:	53                   	push   %ebx
80105a69:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105a6c:	50                   	push   %eax
80105a6d:	6a 00                	push   $0x0
80105a6f:	e8 bc f9 ff ff       	call   80105430 <argstr>
80105a74:	83 c4 10             	add    $0x10,%esp
80105a77:	85 c0                	test   %eax,%eax
80105a79:	0f 88 7a 01 00 00    	js     80105bf9 <sys_unlink+0x199>
  begin_op();
80105a7f:	e8 2c dd ff ff       	call   801037b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a84:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105a87:	83 ec 08             	sub    $0x8,%esp
80105a8a:	53                   	push   %ebx
80105a8b:	ff 75 c0             	push   -0x40(%ebp)
80105a8e:	e8 7d d0 ff ff       	call   80102b10 <nameiparent>
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	0f 84 62 01 00 00    	je     80105c03 <sys_unlink+0x1a3>
  ilock(dp);
80105aa1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105aa4:	83 ec 0c             	sub    $0xc,%esp
80105aa7:	57                   	push   %edi
80105aa8:	e8 23 c7 ff ff       	call   801021d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105aad:	58                   	pop    %eax
80105aae:	5a                   	pop    %edx
80105aaf:	68 14 83 10 80       	push   $0x80108314
80105ab4:	53                   	push   %ebx
80105ab5:	e8 56 cc ff ff       	call   80102710 <namecmp>
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	85 c0                	test   %eax,%eax
80105abf:	0f 84 fb 00 00 00    	je     80105bc0 <sys_unlink+0x160>
80105ac5:	83 ec 08             	sub    $0x8,%esp
80105ac8:	68 13 83 10 80       	push   $0x80108313
80105acd:	53                   	push   %ebx
80105ace:	e8 3d cc ff ff       	call   80102710 <namecmp>
80105ad3:	83 c4 10             	add    $0x10,%esp
80105ad6:	85 c0                	test   %eax,%eax
80105ad8:	0f 84 e2 00 00 00    	je     80105bc0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105ade:	83 ec 04             	sub    $0x4,%esp
80105ae1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105ae4:	50                   	push   %eax
80105ae5:	53                   	push   %ebx
80105ae6:	57                   	push   %edi
80105ae7:	e8 44 cc ff ff       	call   80102730 <dirlookup>
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	89 c3                	mov    %eax,%ebx
80105af1:	85 c0                	test   %eax,%eax
80105af3:	0f 84 c7 00 00 00    	je     80105bc0 <sys_unlink+0x160>
  ilock(ip);
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	50                   	push   %eax
80105afd:	e8 ce c6 ff ff       	call   801021d0 <ilock>
  if(ip->nlink < 1)
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b0a:	0f 8e 1c 01 00 00    	jle    80105c2c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b10:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b15:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b18:	74 66                	je     80105b80 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105b1a:	83 ec 04             	sub    $0x4,%esp
80105b1d:	6a 10                	push   $0x10
80105b1f:	6a 00                	push   $0x0
80105b21:	57                   	push   %edi
80105b22:	e8 89 f5 ff ff       	call   801050b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b27:	6a 10                	push   $0x10
80105b29:	ff 75 c4             	push   -0x3c(%ebp)
80105b2c:	57                   	push   %edi
80105b2d:	ff 75 b4             	push   -0x4c(%ebp)
80105b30:	e8 ab ca ff ff       	call   801025e0 <writei>
80105b35:	83 c4 20             	add    $0x20,%esp
80105b38:	83 f8 10             	cmp    $0x10,%eax
80105b3b:	0f 85 de 00 00 00    	jne    80105c1f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105b41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b46:	0f 84 94 00 00 00    	je     80105be0 <sys_unlink+0x180>
  iunlockput(dp);
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	ff 75 b4             	push   -0x4c(%ebp)
80105b52:	e8 09 c9 ff ff       	call   80102460 <iunlockput>
  ip->nlink--;
80105b57:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b5c:	89 1c 24             	mov    %ebx,(%esp)
80105b5f:	e8 bc c5 ff ff       	call   80102120 <iupdate>
  iunlockput(ip);
80105b64:	89 1c 24             	mov    %ebx,(%esp)
80105b67:	e8 f4 c8 ff ff       	call   80102460 <iunlockput>
  end_op();
80105b6c:	e8 af dc ff ff       	call   80103820 <end_op>
  return 0;
80105b71:	83 c4 10             	add    $0x10,%esp
80105b74:	31 c0                	xor    %eax,%eax
}
80105b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b79:	5b                   	pop    %ebx
80105b7a:	5e                   	pop    %esi
80105b7b:	5f                   	pop    %edi
80105b7c:	5d                   	pop    %ebp
80105b7d:	c3                   	ret    
80105b7e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b80:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105b84:	76 94                	jbe    80105b1a <sys_unlink+0xba>
80105b86:	be 20 00 00 00       	mov    $0x20,%esi
80105b8b:	eb 0b                	jmp    80105b98 <sys_unlink+0x138>
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
80105b90:	83 c6 10             	add    $0x10,%esi
80105b93:	3b 73 58             	cmp    0x58(%ebx),%esi
80105b96:	73 82                	jae    80105b1a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b98:	6a 10                	push   $0x10
80105b9a:	56                   	push   %esi
80105b9b:	57                   	push   %edi
80105b9c:	53                   	push   %ebx
80105b9d:	e8 3e c9 ff ff       	call   801024e0 <readi>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	83 f8 10             	cmp    $0x10,%eax
80105ba8:	75 68                	jne    80105c12 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105baa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105baf:	74 df                	je     80105b90 <sys_unlink+0x130>
    iunlockput(ip);
80105bb1:	83 ec 0c             	sub    $0xc,%esp
80105bb4:	53                   	push   %ebx
80105bb5:	e8 a6 c8 ff ff       	call   80102460 <iunlockput>
    goto bad;
80105bba:	83 c4 10             	add    $0x10,%esp
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	ff 75 b4             	push   -0x4c(%ebp)
80105bc6:	e8 95 c8 ff ff       	call   80102460 <iunlockput>
  end_op();
80105bcb:	e8 50 dc ff ff       	call   80103820 <end_op>
  return -1;
80105bd0:	83 c4 10             	add    $0x10,%esp
80105bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd8:	eb 9c                	jmp    80105b76 <sys_unlink+0x116>
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105be0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105be3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105be6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105beb:	50                   	push   %eax
80105bec:	e8 2f c5 ff ff       	call   80102120 <iupdate>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	e9 53 ff ff ff       	jmp    80105b4c <sys_unlink+0xec>
    return -1;
80105bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfe:	e9 73 ff ff ff       	jmp    80105b76 <sys_unlink+0x116>
    end_op();
80105c03:	e8 18 dc ff ff       	call   80103820 <end_op>
    return -1;
80105c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0d:	e9 64 ff ff ff       	jmp    80105b76 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105c12:	83 ec 0c             	sub    $0xc,%esp
80105c15:	68 38 83 10 80       	push   $0x80108338
80105c1a:	e8 f1 a7 ff ff       	call   80100410 <panic>
    panic("unlink: writei");
80105c1f:	83 ec 0c             	sub    $0xc,%esp
80105c22:	68 4a 83 10 80       	push   $0x8010834a
80105c27:	e8 e4 a7 ff ff       	call   80100410 <panic>
    panic("unlink: nlink < 1");
80105c2c:	83 ec 0c             	sub    $0xc,%esp
80105c2f:	68 26 83 10 80       	push   $0x80108326
80105c34:	e8 d7 a7 ff ff       	call   80100410 <panic>
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_open>:

int
sys_open(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c45:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c48:	53                   	push   %ebx
80105c49:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c4c:	50                   	push   %eax
80105c4d:	6a 00                	push   $0x0
80105c4f:	e8 dc f7 ff ff       	call   80105430 <argstr>
80105c54:	83 c4 10             	add    $0x10,%esp
80105c57:	85 c0                	test   %eax,%eax
80105c59:	0f 88 8e 00 00 00    	js     80105ced <sys_open+0xad>
80105c5f:	83 ec 08             	sub    $0x8,%esp
80105c62:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c65:	50                   	push   %eax
80105c66:	6a 01                	push   $0x1
80105c68:	e8 03 f7 ff ff       	call   80105370 <argint>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	78 79                	js     80105ced <sys_open+0xad>
    return -1;

  begin_op();
80105c74:	e8 37 db ff ff       	call   801037b0 <begin_op>

  if(omode & O_CREATE){
80105c79:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c7d:	75 79                	jne    80105cf8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c7f:	83 ec 0c             	sub    $0xc,%esp
80105c82:	ff 75 e0             	push   -0x20(%ebp)
80105c85:	e8 66 ce ff ff       	call   80102af0 <namei>
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	89 c6                	mov    %eax,%esi
80105c8f:	85 c0                	test   %eax,%eax
80105c91:	0f 84 7e 00 00 00    	je     80105d15 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105c97:	83 ec 0c             	sub    $0xc,%esp
80105c9a:	50                   	push   %eax
80105c9b:	e8 30 c5 ff ff       	call   801021d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ca0:	83 c4 10             	add    $0x10,%esp
80105ca3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ca8:	0f 84 c2 00 00 00    	je     80105d70 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cae:	e8 cd bb ff ff       	call   80101880 <filealloc>
80105cb3:	89 c7                	mov    %eax,%edi
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	74 23                	je     80105cdc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105cb9:	e8 02 e7 ff ff       	call   801043c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cbe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105cc0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105cc4:	85 d2                	test   %edx,%edx
80105cc6:	74 60                	je     80105d28 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105cc8:	83 c3 01             	add    $0x1,%ebx
80105ccb:	83 fb 10             	cmp    $0x10,%ebx
80105cce:	75 f0                	jne    80105cc0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	57                   	push   %edi
80105cd4:	e8 67 bc ff ff       	call   80101940 <fileclose>
80105cd9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	56                   	push   %esi
80105ce0:	e8 7b c7 ff ff       	call   80102460 <iunlockput>
    end_op();
80105ce5:	e8 36 db ff ff       	call   80103820 <end_op>
    return -1;
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cf2:	eb 6d                	jmp    80105d61 <sys_open+0x121>
80105cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cfe:	31 c9                	xor    %ecx,%ecx
80105d00:	ba 02 00 00 00       	mov    $0x2,%edx
80105d05:	6a 00                	push   $0x0
80105d07:	e8 14 f8 ff ff       	call   80105520 <create>
    if(ip == 0){
80105d0c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105d0f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d11:	85 c0                	test   %eax,%eax
80105d13:	75 99                	jne    80105cae <sys_open+0x6e>
      end_op();
80105d15:	e8 06 db ff ff       	call   80103820 <end_op>
      return -1;
80105d1a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d1f:	eb 40                	jmp    80105d61 <sys_open+0x121>
80105d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105d28:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d2b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105d2f:	56                   	push   %esi
80105d30:	e8 7b c5 ff ff       	call   801022b0 <iunlock>
  end_op();
80105d35:	e8 e6 da ff ff       	call   80103820 <end_op>

  f->type = FD_INODE;
80105d3a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d43:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d46:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105d49:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105d4b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d52:	f7 d0                	not    %eax
80105d54:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d57:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105d5a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d5d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d64:	89 d8                	mov    %ebx,%eax
80105d66:	5b                   	pop    %ebx
80105d67:	5e                   	pop    %esi
80105d68:	5f                   	pop    %edi
80105d69:	5d                   	pop    %ebp
80105d6a:	c3                   	ret    
80105d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d73:	85 c9                	test   %ecx,%ecx
80105d75:	0f 84 33 ff ff ff    	je     80105cae <sys_open+0x6e>
80105d7b:	e9 5c ff ff ff       	jmp    80105cdc <sys_open+0x9c>

80105d80 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d86:	e8 25 da ff ff       	call   801037b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d8b:	83 ec 08             	sub    $0x8,%esp
80105d8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d91:	50                   	push   %eax
80105d92:	6a 00                	push   $0x0
80105d94:	e8 97 f6 ff ff       	call   80105430 <argstr>
80105d99:	83 c4 10             	add    $0x10,%esp
80105d9c:	85 c0                	test   %eax,%eax
80105d9e:	78 30                	js     80105dd0 <sys_mkdir+0x50>
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da6:	31 c9                	xor    %ecx,%ecx
80105da8:	ba 01 00 00 00       	mov    $0x1,%edx
80105dad:	6a 00                	push   $0x0
80105daf:	e8 6c f7 ff ff       	call   80105520 <create>
80105db4:	83 c4 10             	add    $0x10,%esp
80105db7:	85 c0                	test   %eax,%eax
80105db9:	74 15                	je     80105dd0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105dbb:	83 ec 0c             	sub    $0xc,%esp
80105dbe:	50                   	push   %eax
80105dbf:	e8 9c c6 ff ff       	call   80102460 <iunlockput>
  end_op();
80105dc4:	e8 57 da ff ff       	call   80103820 <end_op>
  return 0;
80105dc9:	83 c4 10             	add    $0x10,%esp
80105dcc:	31 c0                	xor    %eax,%eax
}
80105dce:	c9                   	leave  
80105dcf:	c3                   	ret    
    end_op();
80105dd0:	e8 4b da ff ff       	call   80103820 <end_op>
    return -1;
80105dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dda:	c9                   	leave  
80105ddb:	c3                   	ret    
80105ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_mknod>:

int
sys_mknod(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105de6:	e8 c5 d9 ff ff       	call   801037b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105deb:	83 ec 08             	sub    $0x8,%esp
80105dee:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105df1:	50                   	push   %eax
80105df2:	6a 00                	push   $0x0
80105df4:	e8 37 f6 ff ff       	call   80105430 <argstr>
80105df9:	83 c4 10             	add    $0x10,%esp
80105dfc:	85 c0                	test   %eax,%eax
80105dfe:	78 60                	js     80105e60 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e06:	50                   	push   %eax
80105e07:	6a 01                	push   $0x1
80105e09:	e8 62 f5 ff ff       	call   80105370 <argint>
  if((argstr(0, &path)) < 0 ||
80105e0e:	83 c4 10             	add    $0x10,%esp
80105e11:	85 c0                	test   %eax,%eax
80105e13:	78 4b                	js     80105e60 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e15:	83 ec 08             	sub    $0x8,%esp
80105e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e1b:	50                   	push   %eax
80105e1c:	6a 02                	push   $0x2
80105e1e:	e8 4d f5 ff ff       	call   80105370 <argint>
     argint(1, &major) < 0 ||
80105e23:	83 c4 10             	add    $0x10,%esp
80105e26:	85 c0                	test   %eax,%eax
80105e28:	78 36                	js     80105e60 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e2a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105e2e:	83 ec 0c             	sub    $0xc,%esp
80105e31:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105e35:	ba 03 00 00 00       	mov    $0x3,%edx
80105e3a:	50                   	push   %eax
80105e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e3e:	e8 dd f6 ff ff       	call   80105520 <create>
     argint(2, &minor) < 0 ||
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	74 16                	je     80105e60 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e4a:	83 ec 0c             	sub    $0xc,%esp
80105e4d:	50                   	push   %eax
80105e4e:	e8 0d c6 ff ff       	call   80102460 <iunlockput>
  end_op();
80105e53:	e8 c8 d9 ff ff       	call   80103820 <end_op>
  return 0;
80105e58:	83 c4 10             	add    $0x10,%esp
80105e5b:	31 c0                	xor    %eax,%eax
}
80105e5d:	c9                   	leave  
80105e5e:	c3                   	ret    
80105e5f:	90                   	nop
    end_op();
80105e60:	e8 bb d9 ff ff       	call   80103820 <end_op>
    return -1;
80105e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e6a:	c9                   	leave  
80105e6b:	c3                   	ret    
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e70 <sys_chdir>:

int
sys_chdir(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	56                   	push   %esi
80105e74:	53                   	push   %ebx
80105e75:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e78:	e8 43 e5 ff ff       	call   801043c0 <myproc>
80105e7d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e7f:	e8 2c d9 ff ff       	call   801037b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e84:	83 ec 08             	sub    $0x8,%esp
80105e87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e8a:	50                   	push   %eax
80105e8b:	6a 00                	push   $0x0
80105e8d:	e8 9e f5 ff ff       	call   80105430 <argstr>
80105e92:	83 c4 10             	add    $0x10,%esp
80105e95:	85 c0                	test   %eax,%eax
80105e97:	78 77                	js     80105f10 <sys_chdir+0xa0>
80105e99:	83 ec 0c             	sub    $0xc,%esp
80105e9c:	ff 75 f4             	push   -0xc(%ebp)
80105e9f:	e8 4c cc ff ff       	call   80102af0 <namei>
80105ea4:	83 c4 10             	add    $0x10,%esp
80105ea7:	89 c3                	mov    %eax,%ebx
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	74 63                	je     80105f10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ead:	83 ec 0c             	sub    $0xc,%esp
80105eb0:	50                   	push   %eax
80105eb1:	e8 1a c3 ff ff       	call   801021d0 <ilock>
  if(ip->type != T_DIR){
80105eb6:	83 c4 10             	add    $0x10,%esp
80105eb9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ebe:	75 30                	jne    80105ef0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	53                   	push   %ebx
80105ec4:	e8 e7 c3 ff ff       	call   801022b0 <iunlock>
  iput(curproc->cwd);
80105ec9:	58                   	pop    %eax
80105eca:	ff 76 68             	push   0x68(%esi)
80105ecd:	e8 2e c4 ff ff       	call   80102300 <iput>
  end_op();
80105ed2:	e8 49 d9 ff ff       	call   80103820 <end_op>
  curproc->cwd = ip;
80105ed7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105eda:	83 c4 10             	add    $0x10,%esp
80105edd:	31 c0                	xor    %eax,%eax
}
80105edf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ee2:	5b                   	pop    %ebx
80105ee3:	5e                   	pop    %esi
80105ee4:	5d                   	pop    %ebp
80105ee5:	c3                   	ret    
80105ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	53                   	push   %ebx
80105ef4:	e8 67 c5 ff ff       	call   80102460 <iunlockput>
    end_op();
80105ef9:	e8 22 d9 ff ff       	call   80103820 <end_op>
    return -1;
80105efe:	83 c4 10             	add    $0x10,%esp
80105f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f06:	eb d7                	jmp    80105edf <sys_chdir+0x6f>
80105f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0f:	90                   	nop
    end_op();
80105f10:	e8 0b d9 ff ff       	call   80103820 <end_op>
    return -1;
80105f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1a:	eb c3                	jmp    80105edf <sys_chdir+0x6f>
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_exec>:

int
sys_exec(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	57                   	push   %edi
80105f24:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f25:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f2b:	53                   	push   %ebx
80105f2c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f32:	50                   	push   %eax
80105f33:	6a 00                	push   $0x0
80105f35:	e8 f6 f4 ff ff       	call   80105430 <argstr>
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	85 c0                	test   %eax,%eax
80105f3f:	0f 88 87 00 00 00    	js     80105fcc <sys_exec+0xac>
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f4e:	50                   	push   %eax
80105f4f:	6a 01                	push   $0x1
80105f51:	e8 1a f4 ff ff       	call   80105370 <argint>
80105f56:	83 c4 10             	add    $0x10,%esp
80105f59:	85 c0                	test   %eax,%eax
80105f5b:	78 6f                	js     80105fcc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f5d:	83 ec 04             	sub    $0x4,%esp
80105f60:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105f66:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f68:	68 80 00 00 00       	push   $0x80
80105f6d:	6a 00                	push   $0x0
80105f6f:	56                   	push   %esi
80105f70:	e8 3b f1 ff ff       	call   801050b0 <memset>
80105f75:	83 c4 10             	add    $0x10,%esp
80105f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105f89:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105f90:	50                   	push   %eax
80105f91:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f97:	01 f8                	add    %edi,%eax
80105f99:	50                   	push   %eax
80105f9a:	e8 41 f3 ff ff       	call   801052e0 <fetchint>
80105f9f:	83 c4 10             	add    $0x10,%esp
80105fa2:	85 c0                	test   %eax,%eax
80105fa4:	78 26                	js     80105fcc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105fa6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105fac:	85 c0                	test   %eax,%eax
80105fae:	74 30                	je     80105fe0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105fb0:	83 ec 08             	sub    $0x8,%esp
80105fb3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105fb6:	52                   	push   %edx
80105fb7:	50                   	push   %eax
80105fb8:	e8 63 f3 ff ff       	call   80105320 <fetchstr>
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	85 c0                	test   %eax,%eax
80105fc2:	78 08                	js     80105fcc <sys_exec+0xac>
  for(i=0;; i++){
80105fc4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105fc7:	83 fb 20             	cmp    $0x20,%ebx
80105fca:	75 b4                	jne    80105f80 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105fcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd4:	5b                   	pop    %ebx
80105fd5:	5e                   	pop    %esi
80105fd6:	5f                   	pop    %edi
80105fd7:	5d                   	pop    %ebp
80105fd8:	c3                   	ret    
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105fe0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105fe7:	00 00 00 00 
  return exec(path, argv);
80105feb:	83 ec 08             	sub    $0x8,%esp
80105fee:	56                   	push   %esi
80105fef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105ff5:	e8 06 b5 ff ff       	call   80101500 <exec>
80105ffa:	83 c4 10             	add    $0x10,%esp
}
80105ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106000:	5b                   	pop    %ebx
80106001:	5e                   	pop    %esi
80106002:	5f                   	pop    %edi
80106003:	5d                   	pop    %ebp
80106004:	c3                   	ret    
80106005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106010 <sys_pipe>:

int
sys_pipe(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	57                   	push   %edi
80106014:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106015:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106018:	53                   	push   %ebx
80106019:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010601c:	6a 08                	push   $0x8
8010601e:	50                   	push   %eax
8010601f:	6a 00                	push   $0x0
80106021:	e8 9a f3 ff ff       	call   801053c0 <argptr>
80106026:	83 c4 10             	add    $0x10,%esp
80106029:	85 c0                	test   %eax,%eax
8010602b:	78 4a                	js     80106077 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010602d:	83 ec 08             	sub    $0x8,%esp
80106030:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106033:	50                   	push   %eax
80106034:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106037:	50                   	push   %eax
80106038:	e8 43 de ff ff       	call   80103e80 <pipealloc>
8010603d:	83 c4 10             	add    $0x10,%esp
80106040:	85 c0                	test   %eax,%eax
80106042:	78 33                	js     80106077 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106044:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106047:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106049:	e8 72 e3 ff ff       	call   801043c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010604e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106050:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106054:	85 f6                	test   %esi,%esi
80106056:	74 28                	je     80106080 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106058:	83 c3 01             	add    $0x1,%ebx
8010605b:	83 fb 10             	cmp    $0x10,%ebx
8010605e:	75 f0                	jne    80106050 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	ff 75 e0             	push   -0x20(%ebp)
80106066:	e8 d5 b8 ff ff       	call   80101940 <fileclose>
    fileclose(wf);
8010606b:	58                   	pop    %eax
8010606c:	ff 75 e4             	push   -0x1c(%ebp)
8010606f:	e8 cc b8 ff ff       	call   80101940 <fileclose>
    return -1;
80106074:	83 c4 10             	add    $0x10,%esp
80106077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607c:	eb 53                	jmp    801060d1 <sys_pipe+0xc1>
8010607e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106080:	8d 73 08             	lea    0x8(%ebx),%esi
80106083:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106087:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010608a:	e8 31 e3 ff ff       	call   801043c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010608f:	31 d2                	xor    %edx,%edx
80106091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106098:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010609c:	85 c9                	test   %ecx,%ecx
8010609e:	74 20                	je     801060c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801060a0:	83 c2 01             	add    $0x1,%edx
801060a3:	83 fa 10             	cmp    $0x10,%edx
801060a6:	75 f0                	jne    80106098 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801060a8:	e8 13 e3 ff ff       	call   801043c0 <myproc>
801060ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801060b4:	00 
801060b5:	eb a9                	jmp    80106060 <sys_pipe+0x50>
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801060c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801060c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801060c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801060c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801060cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801060cf:	31 c0                	xor    %eax,%eax
}
801060d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d4:	5b                   	pop    %ebx
801060d5:	5e                   	pop    %esi
801060d6:	5f                   	pop    %edi
801060d7:	5d                   	pop    %ebp
801060d8:	c3                   	ret    
801060d9:	66 90                	xchg   %ax,%ax
801060db:	66 90                	xchg   %ax,%ax
801060dd:	66 90                	xchg   %ax,%ax
801060df:	90                   	nop

801060e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801060e0:	e9 7b e4 ff ff       	jmp    80104560 <fork>
801060e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_exit>:
}

int
sys_exit(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801060f6:	e8 e5 e6 ff ff       	call   801047e0 <exit>
  return 0;  // not reached
}
801060fb:	31 c0                	xor    %eax,%eax
801060fd:	c9                   	leave  
801060fe:	c3                   	ret    
801060ff:	90                   	nop

80106100 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106100:	e9 0b e8 ff ff       	jmp    80104910 <wait>
80106105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106110 <sys_kill>:
}

int
sys_kill(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106116:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106119:	50                   	push   %eax
8010611a:	6a 00                	push   $0x0
8010611c:	e8 4f f2 ff ff       	call   80105370 <argint>
80106121:	83 c4 10             	add    $0x10,%esp
80106124:	85 c0                	test   %eax,%eax
80106126:	78 18                	js     80106140 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	ff 75 f4             	push   -0xc(%ebp)
8010612e:	e8 7d ea ff ff       	call   80104bb0 <kill>
80106133:	83 c4 10             	add    $0x10,%esp
}
80106136:	c9                   	leave  
80106137:	c3                   	ret    
80106138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop
80106140:	c9                   	leave  
    return -1;
80106141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106146:	c3                   	ret    
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax

80106150 <sys_getpid>:

int
sys_getpid(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106156:	e8 65 e2 ff ff       	call   801043c0 <myproc>
8010615b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010615e:	c9                   	leave  
8010615f:	c3                   	ret    

80106160 <sys_sbrk>:

int
sys_sbrk(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106164:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106167:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010616a:	50                   	push   %eax
8010616b:	6a 00                	push   $0x0
8010616d:	e8 fe f1 ff ff       	call   80105370 <argint>
80106172:	83 c4 10             	add    $0x10,%esp
80106175:	85 c0                	test   %eax,%eax
80106177:	78 27                	js     801061a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106179:	e8 42 e2 ff ff       	call   801043c0 <myproc>
  if(growproc(n) < 0)
8010617e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106181:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106183:	ff 75 f4             	push   -0xc(%ebp)
80106186:	e8 55 e3 ff ff       	call   801044e0 <growproc>
8010618b:	83 c4 10             	add    $0x10,%esp
8010618e:	85 c0                	test   %eax,%eax
80106190:	78 0e                	js     801061a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106192:	89 d8                	mov    %ebx,%eax
80106194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106197:	c9                   	leave  
80106198:	c3                   	ret    
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061a5:	eb eb                	jmp    80106192 <sys_sbrk+0x32>
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax

801061b0 <sys_sleep>:

int
sys_sleep(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801061b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061ba:	50                   	push   %eax
801061bb:	6a 00                	push   $0x0
801061bd:	e8 ae f1 ff ff       	call   80105370 <argint>
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	85 c0                	test   %eax,%eax
801061c7:	0f 88 8a 00 00 00    	js     80106257 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801061cd:	83 ec 0c             	sub    $0xc,%esp
801061d0:	68 a0 57 11 80       	push   $0x801157a0
801061d5:	e8 16 ee ff ff       	call   80104ff0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801061dd:	8b 1d 80 57 11 80    	mov    0x80115780,%ebx
  while(ticks - ticks0 < n){
801061e3:	83 c4 10             	add    $0x10,%esp
801061e6:	85 d2                	test   %edx,%edx
801061e8:	75 27                	jne    80106211 <sys_sleep+0x61>
801061ea:	eb 54                	jmp    80106240 <sys_sleep+0x90>
801061ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	68 a0 57 11 80       	push   $0x801157a0
801061f8:	68 80 57 11 80       	push   $0x80115780
801061fd:	e8 8e e8 ff ff       	call   80104a90 <sleep>
  while(ticks - ticks0 < n){
80106202:	a1 80 57 11 80       	mov    0x80115780,%eax
80106207:	83 c4 10             	add    $0x10,%esp
8010620a:	29 d8                	sub    %ebx,%eax
8010620c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010620f:	73 2f                	jae    80106240 <sys_sleep+0x90>
    if(myproc()->killed){
80106211:	e8 aa e1 ff ff       	call   801043c0 <myproc>
80106216:	8b 40 24             	mov    0x24(%eax),%eax
80106219:	85 c0                	test   %eax,%eax
8010621b:	74 d3                	je     801061f0 <sys_sleep+0x40>
      release(&tickslock);
8010621d:	83 ec 0c             	sub    $0xc,%esp
80106220:	68 a0 57 11 80       	push   $0x801157a0
80106225:	e8 66 ed ff ff       	call   80104f90 <release>
  }
  release(&tickslock);
  return 0;
}
8010622a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106235:	c9                   	leave  
80106236:	c3                   	ret    
80106237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	68 a0 57 11 80       	push   $0x801157a0
80106248:	e8 43 ed ff ff       	call   80104f90 <release>
  return 0;
8010624d:	83 c4 10             	add    $0x10,%esp
80106250:	31 c0                	xor    %eax,%eax
}
80106252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106255:	c9                   	leave  
80106256:	c3                   	ret    
    return -1;
80106257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625c:	eb f4                	jmp    80106252 <sys_sleep+0xa2>
8010625e:	66 90                	xchg   %ax,%ax

80106260 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	53                   	push   %ebx
80106264:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106267:	68 a0 57 11 80       	push   $0x801157a0
8010626c:	e8 7f ed ff ff       	call   80104ff0 <acquire>
  xticks = ticks;
80106271:	8b 1d 80 57 11 80    	mov    0x80115780,%ebx
  release(&tickslock);
80106277:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
8010627e:	e8 0d ed ff ff       	call   80104f90 <release>
  return xticks;
}
80106283:	89 d8                	mov    %ebx,%eax
80106285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106288:	c9                   	leave  
80106289:	c3                   	ret    

8010628a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010628a:	1e                   	push   %ds
  pushl %es
8010628b:	06                   	push   %es
  pushl %fs
8010628c:	0f a0                	push   %fs
  pushl %gs
8010628e:	0f a8                	push   %gs
  pushal
80106290:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106291:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106295:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106297:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106299:	54                   	push   %esp
  call trap
8010629a:	e8 c1 00 00 00       	call   80106360 <trap>
  addl $4, %esp
8010629f:	83 c4 04             	add    $0x4,%esp

801062a2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062a2:	61                   	popa   
  popl %gs
801062a3:	0f a9                	pop    %gs
  popl %fs
801062a5:	0f a1                	pop    %fs
  popl %es
801062a7:	07                   	pop    %es
  popl %ds
801062a8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062a9:	83 c4 08             	add    $0x8,%esp
  iret
801062ac:	cf                   	iret   
801062ad:	66 90                	xchg   %ax,%ax
801062af:	90                   	nop

801062b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801062b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801062b1:	31 c0                	xor    %eax,%eax
{
801062b3:	89 e5                	mov    %esp,%ebp
801062b5:	83 ec 08             	sub    $0x8,%esp
801062b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062bf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062c0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062c7:	c7 04 c5 e2 57 11 80 	movl   $0x8e000008,-0x7feea81e(,%eax,8)
801062ce:	08 00 00 8e 
801062d2:	66 89 14 c5 e0 57 11 	mov    %dx,-0x7feea820(,%eax,8)
801062d9:	80 
801062da:	c1 ea 10             	shr    $0x10,%edx
801062dd:	66 89 14 c5 e6 57 11 	mov    %dx,-0x7feea81a(,%eax,8)
801062e4:	80 
  for(i = 0; i < 256; i++)
801062e5:	83 c0 01             	add    $0x1,%eax
801062e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062ed:	75 d1                	jne    801062c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062f2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801062f7:	c7 05 e2 59 11 80 08 	movl   $0xef000008,0x801159e2
801062fe:	00 00 ef 
  initlock(&tickslock, "time");
80106301:	68 59 83 10 80       	push   $0x80108359
80106306:	68 a0 57 11 80       	push   $0x801157a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010630b:	66 a3 e0 59 11 80    	mov    %ax,0x801159e0
80106311:	c1 e8 10             	shr    $0x10,%eax
80106314:	66 a3 e6 59 11 80    	mov    %ax,0x801159e6
  initlock(&tickslock, "time");
8010631a:	e8 01 eb ff ff       	call   80104e20 <initlock>
}
8010631f:	83 c4 10             	add    $0x10,%esp
80106322:	c9                   	leave  
80106323:	c3                   	ret    
80106324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010632f:	90                   	nop

80106330 <idtinit>:

void
idtinit(void)
{
80106330:	55                   	push   %ebp
  pd[0] = size-1;
80106331:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106336:	89 e5                	mov    %esp,%ebp
80106338:	83 ec 10             	sub    $0x10,%esp
8010633b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010633f:	b8 e0 57 11 80       	mov    $0x801157e0,%eax
80106344:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106348:	c1 e8 10             	shr    $0x10,%eax
8010634b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010634f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106352:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106355:	c9                   	leave  
80106356:	c3                   	ret    
80106357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010635e:	66 90                	xchg   %ax,%ax

80106360 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	56                   	push   %esi
80106365:	53                   	push   %ebx
80106366:	83 ec 1c             	sub    $0x1c,%esp
80106369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010636c:	8b 43 30             	mov    0x30(%ebx),%eax
8010636f:	83 f8 40             	cmp    $0x40,%eax
80106372:	0f 84 68 01 00 00    	je     801064e0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106378:	83 e8 20             	sub    $0x20,%eax
8010637b:	83 f8 1f             	cmp    $0x1f,%eax
8010637e:	0f 87 8c 00 00 00    	ja     80106410 <trap+0xb0>
80106384:	ff 24 85 00 84 10 80 	jmp    *-0x7fef7c00(,%eax,4)
8010638b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010638f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106390:	e8 fb c8 ff ff       	call   80102c90 <ideintr>
    lapiceoi();
80106395:	e8 c6 cf ff ff       	call   80103360 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010639a:	e8 21 e0 ff ff       	call   801043c0 <myproc>
8010639f:	85 c0                	test   %eax,%eax
801063a1:	74 1d                	je     801063c0 <trap+0x60>
801063a3:	e8 18 e0 ff ff       	call   801043c0 <myproc>
801063a8:	8b 50 24             	mov    0x24(%eax),%edx
801063ab:	85 d2                	test   %edx,%edx
801063ad:	74 11                	je     801063c0 <trap+0x60>
801063af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801063b3:	83 e0 03             	and    $0x3,%eax
801063b6:	66 83 f8 03          	cmp    $0x3,%ax
801063ba:	0f 84 e8 01 00 00    	je     801065a8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801063c0:	e8 fb df ff ff       	call   801043c0 <myproc>
801063c5:	85 c0                	test   %eax,%eax
801063c7:	74 0f                	je     801063d8 <trap+0x78>
801063c9:	e8 f2 df ff ff       	call   801043c0 <myproc>
801063ce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801063d2:	0f 84 b8 00 00 00    	je     80106490 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063d8:	e8 e3 df ff ff       	call   801043c0 <myproc>
801063dd:	85 c0                	test   %eax,%eax
801063df:	74 1d                	je     801063fe <trap+0x9e>
801063e1:	e8 da df ff ff       	call   801043c0 <myproc>
801063e6:	8b 40 24             	mov    0x24(%eax),%eax
801063e9:	85 c0                	test   %eax,%eax
801063eb:	74 11                	je     801063fe <trap+0x9e>
801063ed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801063f1:	83 e0 03             	and    $0x3,%eax
801063f4:	66 83 f8 03          	cmp    $0x3,%ax
801063f8:	0f 84 0f 01 00 00    	je     8010650d <trap+0x1ad>
    exit();
}
801063fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106401:	5b                   	pop    %ebx
80106402:	5e                   	pop    %esi
80106403:	5f                   	pop    %edi
80106404:	5d                   	pop    %ebp
80106405:	c3                   	ret    
80106406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106410:	e8 ab df ff ff       	call   801043c0 <myproc>
80106415:	8b 7b 38             	mov    0x38(%ebx),%edi
80106418:	85 c0                	test   %eax,%eax
8010641a:	0f 84 a2 01 00 00    	je     801065c2 <trap+0x262>
80106420:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106424:	0f 84 98 01 00 00    	je     801065c2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010642a:	0f 20 d1             	mov    %cr2,%ecx
8010642d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106430:	e8 6b df ff ff       	call   801043a0 <cpuid>
80106435:	8b 73 30             	mov    0x30(%ebx),%esi
80106438:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010643b:	8b 43 34             	mov    0x34(%ebx),%eax
8010643e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106441:	e8 7a df ff ff       	call   801043c0 <myproc>
80106446:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106449:	e8 72 df ff ff       	call   801043c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010644e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106451:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106454:	51                   	push   %ecx
80106455:	57                   	push   %edi
80106456:	52                   	push   %edx
80106457:	ff 75 e4             	push   -0x1c(%ebp)
8010645a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010645b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010645e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106461:	56                   	push   %esi
80106462:	ff 70 10             	push   0x10(%eax)
80106465:	68 bc 83 10 80       	push   $0x801083bc
8010646a:	e8 21 a3 ff ff       	call   80100790 <cprintf>
    myproc()->killed = 1;
8010646f:	83 c4 20             	add    $0x20,%esp
80106472:	e8 49 df ff ff       	call   801043c0 <myproc>
80106477:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010647e:	e8 3d df ff ff       	call   801043c0 <myproc>
80106483:	85 c0                	test   %eax,%eax
80106485:	0f 85 18 ff ff ff    	jne    801063a3 <trap+0x43>
8010648b:	e9 30 ff ff ff       	jmp    801063c0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106490:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106494:	0f 85 3e ff ff ff    	jne    801063d8 <trap+0x78>
    yield();
8010649a:	e8 a1 e5 ff ff       	call   80104a40 <yield>
8010649f:	e9 34 ff ff ff       	jmp    801063d8 <trap+0x78>
801064a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064a8:	8b 7b 38             	mov    0x38(%ebx),%edi
801064ab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064af:	e8 ec de ff ff       	call   801043a0 <cpuid>
801064b4:	57                   	push   %edi
801064b5:	56                   	push   %esi
801064b6:	50                   	push   %eax
801064b7:	68 64 83 10 80       	push   $0x80108364
801064bc:	e8 cf a2 ff ff       	call   80100790 <cprintf>
    lapiceoi();
801064c1:	e8 9a ce ff ff       	call   80103360 <lapiceoi>
    break;
801064c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064c9:	e8 f2 de ff ff       	call   801043c0 <myproc>
801064ce:	85 c0                	test   %eax,%eax
801064d0:	0f 85 cd fe ff ff    	jne    801063a3 <trap+0x43>
801064d6:	e9 e5 fe ff ff       	jmp    801063c0 <trap+0x60>
801064db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064df:	90                   	nop
    if(myproc()->killed)
801064e0:	e8 db de ff ff       	call   801043c0 <myproc>
801064e5:	8b 70 24             	mov    0x24(%eax),%esi
801064e8:	85 f6                	test   %esi,%esi
801064ea:	0f 85 c8 00 00 00    	jne    801065b8 <trap+0x258>
    myproc()->tf = tf;
801064f0:	e8 cb de ff ff       	call   801043c0 <myproc>
801064f5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801064f8:	e8 b3 ef ff ff       	call   801054b0 <syscall>
    if(myproc()->killed)
801064fd:	e8 be de ff ff       	call   801043c0 <myproc>
80106502:	8b 48 24             	mov    0x24(%eax),%ecx
80106505:	85 c9                	test   %ecx,%ecx
80106507:	0f 84 f1 fe ff ff    	je     801063fe <trap+0x9e>
}
8010650d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106510:	5b                   	pop    %ebx
80106511:	5e                   	pop    %esi
80106512:	5f                   	pop    %edi
80106513:	5d                   	pop    %ebp
      exit();
80106514:	e9 c7 e2 ff ff       	jmp    801047e0 <exit>
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106520:	e8 3b 02 00 00       	call   80106760 <uartintr>
    lapiceoi();
80106525:	e8 36 ce ff ff       	call   80103360 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010652a:	e8 91 de ff ff       	call   801043c0 <myproc>
8010652f:	85 c0                	test   %eax,%eax
80106531:	0f 85 6c fe ff ff    	jne    801063a3 <trap+0x43>
80106537:	e9 84 fe ff ff       	jmp    801063c0 <trap+0x60>
8010653c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106540:	e8 db cc ff ff       	call   80103220 <kbdintr>
    lapiceoi();
80106545:	e8 16 ce ff ff       	call   80103360 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010654a:	e8 71 de ff ff       	call   801043c0 <myproc>
8010654f:	85 c0                	test   %eax,%eax
80106551:	0f 85 4c fe ff ff    	jne    801063a3 <trap+0x43>
80106557:	e9 64 fe ff ff       	jmp    801063c0 <trap+0x60>
8010655c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106560:	e8 3b de ff ff       	call   801043a0 <cpuid>
80106565:	85 c0                	test   %eax,%eax
80106567:	0f 85 28 fe ff ff    	jne    80106395 <trap+0x35>
      acquire(&tickslock);
8010656d:	83 ec 0c             	sub    $0xc,%esp
80106570:	68 a0 57 11 80       	push   $0x801157a0
80106575:	e8 76 ea ff ff       	call   80104ff0 <acquire>
      wakeup(&ticks);
8010657a:	c7 04 24 80 57 11 80 	movl   $0x80115780,(%esp)
      ticks++;
80106581:	83 05 80 57 11 80 01 	addl   $0x1,0x80115780
      wakeup(&ticks);
80106588:	e8 c3 e5 ff ff       	call   80104b50 <wakeup>
      release(&tickslock);
8010658d:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
80106594:	e8 f7 e9 ff ff       	call   80104f90 <release>
80106599:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010659c:	e9 f4 fd ff ff       	jmp    80106395 <trap+0x35>
801065a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801065a8:	e8 33 e2 ff ff       	call   801047e0 <exit>
801065ad:	e9 0e fe ff ff       	jmp    801063c0 <trap+0x60>
801065b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801065b8:	e8 23 e2 ff ff       	call   801047e0 <exit>
801065bd:	e9 2e ff ff ff       	jmp    801064f0 <trap+0x190>
801065c2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065c5:	e8 d6 dd ff ff       	call   801043a0 <cpuid>
801065ca:	83 ec 0c             	sub    $0xc,%esp
801065cd:	56                   	push   %esi
801065ce:	57                   	push   %edi
801065cf:	50                   	push   %eax
801065d0:	ff 73 30             	push   0x30(%ebx)
801065d3:	68 88 83 10 80       	push   $0x80108388
801065d8:	e8 b3 a1 ff ff       	call   80100790 <cprintf>
      panic("trap");
801065dd:	83 c4 14             	add    $0x14,%esp
801065e0:	68 5e 83 10 80       	push   $0x8010835e
801065e5:	e8 26 9e ff ff       	call   80100410 <panic>
801065ea:	66 90                	xchg   %ax,%ax
801065ec:	66 90                	xchg   %ax,%ax
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801065f0:	a1 e0 5f 11 80       	mov    0x80115fe0,%eax
801065f5:	85 c0                	test   %eax,%eax
801065f7:	74 17                	je     80106610 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065f9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065fe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065ff:	a8 01                	test   $0x1,%al
80106601:	74 0d                	je     80106610 <uartgetc+0x20>
80106603:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106608:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106609:	0f b6 c0             	movzbl %al,%eax
8010660c:	c3                   	ret    
8010660d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106615:	c3                   	ret    
80106616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661d:	8d 76 00             	lea    0x0(%esi),%esi

80106620 <uartinit>:
{
80106620:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106621:	31 c9                	xor    %ecx,%ecx
80106623:	89 c8                	mov    %ecx,%eax
80106625:	89 e5                	mov    %esp,%ebp
80106627:	57                   	push   %edi
80106628:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010662d:	56                   	push   %esi
8010662e:	89 fa                	mov    %edi,%edx
80106630:	53                   	push   %ebx
80106631:	83 ec 1c             	sub    $0x1c,%esp
80106634:	ee                   	out    %al,(%dx)
80106635:	be fb 03 00 00       	mov    $0x3fb,%esi
8010663a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010663f:	89 f2                	mov    %esi,%edx
80106641:	ee                   	out    %al,(%dx)
80106642:	b8 0c 00 00 00       	mov    $0xc,%eax
80106647:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010664c:	ee                   	out    %al,(%dx)
8010664d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106652:	89 c8                	mov    %ecx,%eax
80106654:	89 da                	mov    %ebx,%edx
80106656:	ee                   	out    %al,(%dx)
80106657:	b8 03 00 00 00       	mov    $0x3,%eax
8010665c:	89 f2                	mov    %esi,%edx
8010665e:	ee                   	out    %al,(%dx)
8010665f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106664:	89 c8                	mov    %ecx,%eax
80106666:	ee                   	out    %al,(%dx)
80106667:	b8 01 00 00 00       	mov    $0x1,%eax
8010666c:	89 da                	mov    %ebx,%edx
8010666e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010666f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106674:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106675:	3c ff                	cmp    $0xff,%al
80106677:	74 78                	je     801066f1 <uartinit+0xd1>
  uart = 1;
80106679:	c7 05 e0 5f 11 80 01 	movl   $0x1,0x80115fe0
80106680:	00 00 00 
80106683:	89 fa                	mov    %edi,%edx
80106685:	ec                   	in     (%dx),%al
80106686:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010668b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010668c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010668f:	bf 80 84 10 80       	mov    $0x80108480,%edi
80106694:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106699:	6a 00                	push   $0x0
8010669b:	6a 04                	push   $0x4
8010669d:	e8 2e c8 ff ff       	call   80102ed0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801066a2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801066a6:	83 c4 10             	add    $0x10,%esp
801066a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801066b0:	a1 e0 5f 11 80       	mov    0x80115fe0,%eax
801066b5:	bb 80 00 00 00       	mov    $0x80,%ebx
801066ba:	85 c0                	test   %eax,%eax
801066bc:	75 14                	jne    801066d2 <uartinit+0xb2>
801066be:	eb 23                	jmp    801066e3 <uartinit+0xc3>
    microdelay(10);
801066c0:	83 ec 0c             	sub    $0xc,%esp
801066c3:	6a 0a                	push   $0xa
801066c5:	e8 b6 cc ff ff       	call   80103380 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066ca:	83 c4 10             	add    $0x10,%esp
801066cd:	83 eb 01             	sub    $0x1,%ebx
801066d0:	74 07                	je     801066d9 <uartinit+0xb9>
801066d2:	89 f2                	mov    %esi,%edx
801066d4:	ec                   	in     (%dx),%al
801066d5:	a8 20                	test   $0x20,%al
801066d7:	74 e7                	je     801066c0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066d9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801066dd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066e2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801066e3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801066e7:	83 c7 01             	add    $0x1,%edi
801066ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801066ed:	84 c0                	test   %al,%al
801066ef:	75 bf                	jne    801066b0 <uartinit+0x90>
}
801066f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f4:	5b                   	pop    %ebx
801066f5:	5e                   	pop    %esi
801066f6:	5f                   	pop    %edi
801066f7:	5d                   	pop    %ebp
801066f8:	c3                   	ret    
801066f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106700 <uartputc>:
  if(!uart)
80106700:	a1 e0 5f 11 80       	mov    0x80115fe0,%eax
80106705:	85 c0                	test   %eax,%eax
80106707:	74 47                	je     80106750 <uartputc+0x50>
{
80106709:	55                   	push   %ebp
8010670a:	89 e5                	mov    %esp,%ebp
8010670c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010670d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106712:	53                   	push   %ebx
80106713:	bb 80 00 00 00       	mov    $0x80,%ebx
80106718:	eb 18                	jmp    80106732 <uartputc+0x32>
8010671a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106720:	83 ec 0c             	sub    $0xc,%esp
80106723:	6a 0a                	push   $0xa
80106725:	e8 56 cc ff ff       	call   80103380 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010672a:	83 c4 10             	add    $0x10,%esp
8010672d:	83 eb 01             	sub    $0x1,%ebx
80106730:	74 07                	je     80106739 <uartputc+0x39>
80106732:	89 f2                	mov    %esi,%edx
80106734:	ec                   	in     (%dx),%al
80106735:	a8 20                	test   $0x20,%al
80106737:	74 e7                	je     80106720 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106739:	8b 45 08             	mov    0x8(%ebp),%eax
8010673c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106741:	ee                   	out    %al,(%dx)
}
80106742:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5d                   	pop    %ebp
80106748:	c3                   	ret    
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106750:	c3                   	ret    
80106751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675f:	90                   	nop

80106760 <uartintr>:

void
uartintr(void)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106766:	68 f0 65 10 80       	push   $0x801065f0
8010676b:	e8 30 a9 ff ff       	call   801010a0 <consoleintr>
}
80106770:	83 c4 10             	add    $0x10,%esp
80106773:	c9                   	leave  
80106774:	c3                   	ret    

80106775 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $0
80106777:	6a 00                	push   $0x0
  jmp alltraps
80106779:	e9 0c fb ff ff       	jmp    8010628a <alltraps>

8010677e <vector1>:
.globl vector1
vector1:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $1
80106780:	6a 01                	push   $0x1
  jmp alltraps
80106782:	e9 03 fb ff ff       	jmp    8010628a <alltraps>

80106787 <vector2>:
.globl vector2
vector2:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $2
80106789:	6a 02                	push   $0x2
  jmp alltraps
8010678b:	e9 fa fa ff ff       	jmp    8010628a <alltraps>

80106790 <vector3>:
.globl vector3
vector3:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $3
80106792:	6a 03                	push   $0x3
  jmp alltraps
80106794:	e9 f1 fa ff ff       	jmp    8010628a <alltraps>

80106799 <vector4>:
.globl vector4
vector4:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $4
8010679b:	6a 04                	push   $0x4
  jmp alltraps
8010679d:	e9 e8 fa ff ff       	jmp    8010628a <alltraps>

801067a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $5
801067a4:	6a 05                	push   $0x5
  jmp alltraps
801067a6:	e9 df fa ff ff       	jmp    8010628a <alltraps>

801067ab <vector6>:
.globl vector6
vector6:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $6
801067ad:	6a 06                	push   $0x6
  jmp alltraps
801067af:	e9 d6 fa ff ff       	jmp    8010628a <alltraps>

801067b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $7
801067b6:	6a 07                	push   $0x7
  jmp alltraps
801067b8:	e9 cd fa ff ff       	jmp    8010628a <alltraps>

801067bd <vector8>:
.globl vector8
vector8:
  pushl $8
801067bd:	6a 08                	push   $0x8
  jmp alltraps
801067bf:	e9 c6 fa ff ff       	jmp    8010628a <alltraps>

801067c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $9
801067c6:	6a 09                	push   $0x9
  jmp alltraps
801067c8:	e9 bd fa ff ff       	jmp    8010628a <alltraps>

801067cd <vector10>:
.globl vector10
vector10:
  pushl $10
801067cd:	6a 0a                	push   $0xa
  jmp alltraps
801067cf:	e9 b6 fa ff ff       	jmp    8010628a <alltraps>

801067d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801067d4:	6a 0b                	push   $0xb
  jmp alltraps
801067d6:	e9 af fa ff ff       	jmp    8010628a <alltraps>

801067db <vector12>:
.globl vector12
vector12:
  pushl $12
801067db:	6a 0c                	push   $0xc
  jmp alltraps
801067dd:	e9 a8 fa ff ff       	jmp    8010628a <alltraps>

801067e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801067e2:	6a 0d                	push   $0xd
  jmp alltraps
801067e4:	e9 a1 fa ff ff       	jmp    8010628a <alltraps>

801067e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801067e9:	6a 0e                	push   $0xe
  jmp alltraps
801067eb:	e9 9a fa ff ff       	jmp    8010628a <alltraps>

801067f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $15
801067f2:	6a 0f                	push   $0xf
  jmp alltraps
801067f4:	e9 91 fa ff ff       	jmp    8010628a <alltraps>

801067f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $16
801067fb:	6a 10                	push   $0x10
  jmp alltraps
801067fd:	e9 88 fa ff ff       	jmp    8010628a <alltraps>

80106802 <vector17>:
.globl vector17
vector17:
  pushl $17
80106802:	6a 11                	push   $0x11
  jmp alltraps
80106804:	e9 81 fa ff ff       	jmp    8010628a <alltraps>

80106809 <vector18>:
.globl vector18
vector18:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $18
8010680b:	6a 12                	push   $0x12
  jmp alltraps
8010680d:	e9 78 fa ff ff       	jmp    8010628a <alltraps>

80106812 <vector19>:
.globl vector19
vector19:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $19
80106814:	6a 13                	push   $0x13
  jmp alltraps
80106816:	e9 6f fa ff ff       	jmp    8010628a <alltraps>

8010681b <vector20>:
.globl vector20
vector20:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $20
8010681d:	6a 14                	push   $0x14
  jmp alltraps
8010681f:	e9 66 fa ff ff       	jmp    8010628a <alltraps>

80106824 <vector21>:
.globl vector21
vector21:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $21
80106826:	6a 15                	push   $0x15
  jmp alltraps
80106828:	e9 5d fa ff ff       	jmp    8010628a <alltraps>

8010682d <vector22>:
.globl vector22
vector22:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $22
8010682f:	6a 16                	push   $0x16
  jmp alltraps
80106831:	e9 54 fa ff ff       	jmp    8010628a <alltraps>

80106836 <vector23>:
.globl vector23
vector23:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $23
80106838:	6a 17                	push   $0x17
  jmp alltraps
8010683a:	e9 4b fa ff ff       	jmp    8010628a <alltraps>

8010683f <vector24>:
.globl vector24
vector24:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $24
80106841:	6a 18                	push   $0x18
  jmp alltraps
80106843:	e9 42 fa ff ff       	jmp    8010628a <alltraps>

80106848 <vector25>:
.globl vector25
vector25:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $25
8010684a:	6a 19                	push   $0x19
  jmp alltraps
8010684c:	e9 39 fa ff ff       	jmp    8010628a <alltraps>

80106851 <vector26>:
.globl vector26
vector26:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $26
80106853:	6a 1a                	push   $0x1a
  jmp alltraps
80106855:	e9 30 fa ff ff       	jmp    8010628a <alltraps>

8010685a <vector27>:
.globl vector27
vector27:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $27
8010685c:	6a 1b                	push   $0x1b
  jmp alltraps
8010685e:	e9 27 fa ff ff       	jmp    8010628a <alltraps>

80106863 <vector28>:
.globl vector28
vector28:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $28
80106865:	6a 1c                	push   $0x1c
  jmp alltraps
80106867:	e9 1e fa ff ff       	jmp    8010628a <alltraps>

8010686c <vector29>:
.globl vector29
vector29:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $29
8010686e:	6a 1d                	push   $0x1d
  jmp alltraps
80106870:	e9 15 fa ff ff       	jmp    8010628a <alltraps>

80106875 <vector30>:
.globl vector30
vector30:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $30
80106877:	6a 1e                	push   $0x1e
  jmp alltraps
80106879:	e9 0c fa ff ff       	jmp    8010628a <alltraps>

8010687e <vector31>:
.globl vector31
vector31:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $31
80106880:	6a 1f                	push   $0x1f
  jmp alltraps
80106882:	e9 03 fa ff ff       	jmp    8010628a <alltraps>

80106887 <vector32>:
.globl vector32
vector32:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $32
80106889:	6a 20                	push   $0x20
  jmp alltraps
8010688b:	e9 fa f9 ff ff       	jmp    8010628a <alltraps>

80106890 <vector33>:
.globl vector33
vector33:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $33
80106892:	6a 21                	push   $0x21
  jmp alltraps
80106894:	e9 f1 f9 ff ff       	jmp    8010628a <alltraps>

80106899 <vector34>:
.globl vector34
vector34:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $34
8010689b:	6a 22                	push   $0x22
  jmp alltraps
8010689d:	e9 e8 f9 ff ff       	jmp    8010628a <alltraps>

801068a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $35
801068a4:	6a 23                	push   $0x23
  jmp alltraps
801068a6:	e9 df f9 ff ff       	jmp    8010628a <alltraps>

801068ab <vector36>:
.globl vector36
vector36:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $36
801068ad:	6a 24                	push   $0x24
  jmp alltraps
801068af:	e9 d6 f9 ff ff       	jmp    8010628a <alltraps>

801068b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $37
801068b6:	6a 25                	push   $0x25
  jmp alltraps
801068b8:	e9 cd f9 ff ff       	jmp    8010628a <alltraps>

801068bd <vector38>:
.globl vector38
vector38:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $38
801068bf:	6a 26                	push   $0x26
  jmp alltraps
801068c1:	e9 c4 f9 ff ff       	jmp    8010628a <alltraps>

801068c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $39
801068c8:	6a 27                	push   $0x27
  jmp alltraps
801068ca:	e9 bb f9 ff ff       	jmp    8010628a <alltraps>

801068cf <vector40>:
.globl vector40
vector40:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $40
801068d1:	6a 28                	push   $0x28
  jmp alltraps
801068d3:	e9 b2 f9 ff ff       	jmp    8010628a <alltraps>

801068d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $41
801068da:	6a 29                	push   $0x29
  jmp alltraps
801068dc:	e9 a9 f9 ff ff       	jmp    8010628a <alltraps>

801068e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $42
801068e3:	6a 2a                	push   $0x2a
  jmp alltraps
801068e5:	e9 a0 f9 ff ff       	jmp    8010628a <alltraps>

801068ea <vector43>:
.globl vector43
vector43:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $43
801068ec:	6a 2b                	push   $0x2b
  jmp alltraps
801068ee:	e9 97 f9 ff ff       	jmp    8010628a <alltraps>

801068f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $44
801068f5:	6a 2c                	push   $0x2c
  jmp alltraps
801068f7:	e9 8e f9 ff ff       	jmp    8010628a <alltraps>

801068fc <vector45>:
.globl vector45
vector45:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $45
801068fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106900:	e9 85 f9 ff ff       	jmp    8010628a <alltraps>

80106905 <vector46>:
.globl vector46
vector46:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $46
80106907:	6a 2e                	push   $0x2e
  jmp alltraps
80106909:	e9 7c f9 ff ff       	jmp    8010628a <alltraps>

8010690e <vector47>:
.globl vector47
vector47:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $47
80106910:	6a 2f                	push   $0x2f
  jmp alltraps
80106912:	e9 73 f9 ff ff       	jmp    8010628a <alltraps>

80106917 <vector48>:
.globl vector48
vector48:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $48
80106919:	6a 30                	push   $0x30
  jmp alltraps
8010691b:	e9 6a f9 ff ff       	jmp    8010628a <alltraps>

80106920 <vector49>:
.globl vector49
vector49:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $49
80106922:	6a 31                	push   $0x31
  jmp alltraps
80106924:	e9 61 f9 ff ff       	jmp    8010628a <alltraps>

80106929 <vector50>:
.globl vector50
vector50:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $50
8010692b:	6a 32                	push   $0x32
  jmp alltraps
8010692d:	e9 58 f9 ff ff       	jmp    8010628a <alltraps>

80106932 <vector51>:
.globl vector51
vector51:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $51
80106934:	6a 33                	push   $0x33
  jmp alltraps
80106936:	e9 4f f9 ff ff       	jmp    8010628a <alltraps>

8010693b <vector52>:
.globl vector52
vector52:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $52
8010693d:	6a 34                	push   $0x34
  jmp alltraps
8010693f:	e9 46 f9 ff ff       	jmp    8010628a <alltraps>

80106944 <vector53>:
.globl vector53
vector53:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $53
80106946:	6a 35                	push   $0x35
  jmp alltraps
80106948:	e9 3d f9 ff ff       	jmp    8010628a <alltraps>

8010694d <vector54>:
.globl vector54
vector54:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $54
8010694f:	6a 36                	push   $0x36
  jmp alltraps
80106951:	e9 34 f9 ff ff       	jmp    8010628a <alltraps>

80106956 <vector55>:
.globl vector55
vector55:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $55
80106958:	6a 37                	push   $0x37
  jmp alltraps
8010695a:	e9 2b f9 ff ff       	jmp    8010628a <alltraps>

8010695f <vector56>:
.globl vector56
vector56:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $56
80106961:	6a 38                	push   $0x38
  jmp alltraps
80106963:	e9 22 f9 ff ff       	jmp    8010628a <alltraps>

80106968 <vector57>:
.globl vector57
vector57:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $57
8010696a:	6a 39                	push   $0x39
  jmp alltraps
8010696c:	e9 19 f9 ff ff       	jmp    8010628a <alltraps>

80106971 <vector58>:
.globl vector58
vector58:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $58
80106973:	6a 3a                	push   $0x3a
  jmp alltraps
80106975:	e9 10 f9 ff ff       	jmp    8010628a <alltraps>

8010697a <vector59>:
.globl vector59
vector59:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $59
8010697c:	6a 3b                	push   $0x3b
  jmp alltraps
8010697e:	e9 07 f9 ff ff       	jmp    8010628a <alltraps>

80106983 <vector60>:
.globl vector60
vector60:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $60
80106985:	6a 3c                	push   $0x3c
  jmp alltraps
80106987:	e9 fe f8 ff ff       	jmp    8010628a <alltraps>

8010698c <vector61>:
.globl vector61
vector61:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $61
8010698e:	6a 3d                	push   $0x3d
  jmp alltraps
80106990:	e9 f5 f8 ff ff       	jmp    8010628a <alltraps>

80106995 <vector62>:
.globl vector62
vector62:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $62
80106997:	6a 3e                	push   $0x3e
  jmp alltraps
80106999:	e9 ec f8 ff ff       	jmp    8010628a <alltraps>

8010699e <vector63>:
.globl vector63
vector63:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $63
801069a0:	6a 3f                	push   $0x3f
  jmp alltraps
801069a2:	e9 e3 f8 ff ff       	jmp    8010628a <alltraps>

801069a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $64
801069a9:	6a 40                	push   $0x40
  jmp alltraps
801069ab:	e9 da f8 ff ff       	jmp    8010628a <alltraps>

801069b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $65
801069b2:	6a 41                	push   $0x41
  jmp alltraps
801069b4:	e9 d1 f8 ff ff       	jmp    8010628a <alltraps>

801069b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $66
801069bb:	6a 42                	push   $0x42
  jmp alltraps
801069bd:	e9 c8 f8 ff ff       	jmp    8010628a <alltraps>

801069c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $67
801069c4:	6a 43                	push   $0x43
  jmp alltraps
801069c6:	e9 bf f8 ff ff       	jmp    8010628a <alltraps>

801069cb <vector68>:
.globl vector68
vector68:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $68
801069cd:	6a 44                	push   $0x44
  jmp alltraps
801069cf:	e9 b6 f8 ff ff       	jmp    8010628a <alltraps>

801069d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $69
801069d6:	6a 45                	push   $0x45
  jmp alltraps
801069d8:	e9 ad f8 ff ff       	jmp    8010628a <alltraps>

801069dd <vector70>:
.globl vector70
vector70:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $70
801069df:	6a 46                	push   $0x46
  jmp alltraps
801069e1:	e9 a4 f8 ff ff       	jmp    8010628a <alltraps>

801069e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $71
801069e8:	6a 47                	push   $0x47
  jmp alltraps
801069ea:	e9 9b f8 ff ff       	jmp    8010628a <alltraps>

801069ef <vector72>:
.globl vector72
vector72:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $72
801069f1:	6a 48                	push   $0x48
  jmp alltraps
801069f3:	e9 92 f8 ff ff       	jmp    8010628a <alltraps>

801069f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $73
801069fa:	6a 49                	push   $0x49
  jmp alltraps
801069fc:	e9 89 f8 ff ff       	jmp    8010628a <alltraps>

80106a01 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $74
80106a03:	6a 4a                	push   $0x4a
  jmp alltraps
80106a05:	e9 80 f8 ff ff       	jmp    8010628a <alltraps>

80106a0a <vector75>:
.globl vector75
vector75:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $75
80106a0c:	6a 4b                	push   $0x4b
  jmp alltraps
80106a0e:	e9 77 f8 ff ff       	jmp    8010628a <alltraps>

80106a13 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $76
80106a15:	6a 4c                	push   $0x4c
  jmp alltraps
80106a17:	e9 6e f8 ff ff       	jmp    8010628a <alltraps>

80106a1c <vector77>:
.globl vector77
vector77:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $77
80106a1e:	6a 4d                	push   $0x4d
  jmp alltraps
80106a20:	e9 65 f8 ff ff       	jmp    8010628a <alltraps>

80106a25 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $78
80106a27:	6a 4e                	push   $0x4e
  jmp alltraps
80106a29:	e9 5c f8 ff ff       	jmp    8010628a <alltraps>

80106a2e <vector79>:
.globl vector79
vector79:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $79
80106a30:	6a 4f                	push   $0x4f
  jmp alltraps
80106a32:	e9 53 f8 ff ff       	jmp    8010628a <alltraps>

80106a37 <vector80>:
.globl vector80
vector80:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $80
80106a39:	6a 50                	push   $0x50
  jmp alltraps
80106a3b:	e9 4a f8 ff ff       	jmp    8010628a <alltraps>

80106a40 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $81
80106a42:	6a 51                	push   $0x51
  jmp alltraps
80106a44:	e9 41 f8 ff ff       	jmp    8010628a <alltraps>

80106a49 <vector82>:
.globl vector82
vector82:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $82
80106a4b:	6a 52                	push   $0x52
  jmp alltraps
80106a4d:	e9 38 f8 ff ff       	jmp    8010628a <alltraps>

80106a52 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $83
80106a54:	6a 53                	push   $0x53
  jmp alltraps
80106a56:	e9 2f f8 ff ff       	jmp    8010628a <alltraps>

80106a5b <vector84>:
.globl vector84
vector84:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $84
80106a5d:	6a 54                	push   $0x54
  jmp alltraps
80106a5f:	e9 26 f8 ff ff       	jmp    8010628a <alltraps>

80106a64 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $85
80106a66:	6a 55                	push   $0x55
  jmp alltraps
80106a68:	e9 1d f8 ff ff       	jmp    8010628a <alltraps>

80106a6d <vector86>:
.globl vector86
vector86:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $86
80106a6f:	6a 56                	push   $0x56
  jmp alltraps
80106a71:	e9 14 f8 ff ff       	jmp    8010628a <alltraps>

80106a76 <vector87>:
.globl vector87
vector87:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $87
80106a78:	6a 57                	push   $0x57
  jmp alltraps
80106a7a:	e9 0b f8 ff ff       	jmp    8010628a <alltraps>

80106a7f <vector88>:
.globl vector88
vector88:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $88
80106a81:	6a 58                	push   $0x58
  jmp alltraps
80106a83:	e9 02 f8 ff ff       	jmp    8010628a <alltraps>

80106a88 <vector89>:
.globl vector89
vector89:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $89
80106a8a:	6a 59                	push   $0x59
  jmp alltraps
80106a8c:	e9 f9 f7 ff ff       	jmp    8010628a <alltraps>

80106a91 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $90
80106a93:	6a 5a                	push   $0x5a
  jmp alltraps
80106a95:	e9 f0 f7 ff ff       	jmp    8010628a <alltraps>

80106a9a <vector91>:
.globl vector91
vector91:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $91
80106a9c:	6a 5b                	push   $0x5b
  jmp alltraps
80106a9e:	e9 e7 f7 ff ff       	jmp    8010628a <alltraps>

80106aa3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $92
80106aa5:	6a 5c                	push   $0x5c
  jmp alltraps
80106aa7:	e9 de f7 ff ff       	jmp    8010628a <alltraps>

80106aac <vector93>:
.globl vector93
vector93:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $93
80106aae:	6a 5d                	push   $0x5d
  jmp alltraps
80106ab0:	e9 d5 f7 ff ff       	jmp    8010628a <alltraps>

80106ab5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $94
80106ab7:	6a 5e                	push   $0x5e
  jmp alltraps
80106ab9:	e9 cc f7 ff ff       	jmp    8010628a <alltraps>

80106abe <vector95>:
.globl vector95
vector95:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $95
80106ac0:	6a 5f                	push   $0x5f
  jmp alltraps
80106ac2:	e9 c3 f7 ff ff       	jmp    8010628a <alltraps>

80106ac7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $96
80106ac9:	6a 60                	push   $0x60
  jmp alltraps
80106acb:	e9 ba f7 ff ff       	jmp    8010628a <alltraps>

80106ad0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $97
80106ad2:	6a 61                	push   $0x61
  jmp alltraps
80106ad4:	e9 b1 f7 ff ff       	jmp    8010628a <alltraps>

80106ad9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $98
80106adb:	6a 62                	push   $0x62
  jmp alltraps
80106add:	e9 a8 f7 ff ff       	jmp    8010628a <alltraps>

80106ae2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $99
80106ae4:	6a 63                	push   $0x63
  jmp alltraps
80106ae6:	e9 9f f7 ff ff       	jmp    8010628a <alltraps>

80106aeb <vector100>:
.globl vector100
vector100:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $100
80106aed:	6a 64                	push   $0x64
  jmp alltraps
80106aef:	e9 96 f7 ff ff       	jmp    8010628a <alltraps>

80106af4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $101
80106af6:	6a 65                	push   $0x65
  jmp alltraps
80106af8:	e9 8d f7 ff ff       	jmp    8010628a <alltraps>

80106afd <vector102>:
.globl vector102
vector102:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $102
80106aff:	6a 66                	push   $0x66
  jmp alltraps
80106b01:	e9 84 f7 ff ff       	jmp    8010628a <alltraps>

80106b06 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $103
80106b08:	6a 67                	push   $0x67
  jmp alltraps
80106b0a:	e9 7b f7 ff ff       	jmp    8010628a <alltraps>

80106b0f <vector104>:
.globl vector104
vector104:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $104
80106b11:	6a 68                	push   $0x68
  jmp alltraps
80106b13:	e9 72 f7 ff ff       	jmp    8010628a <alltraps>

80106b18 <vector105>:
.globl vector105
vector105:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $105
80106b1a:	6a 69                	push   $0x69
  jmp alltraps
80106b1c:	e9 69 f7 ff ff       	jmp    8010628a <alltraps>

80106b21 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $106
80106b23:	6a 6a                	push   $0x6a
  jmp alltraps
80106b25:	e9 60 f7 ff ff       	jmp    8010628a <alltraps>

80106b2a <vector107>:
.globl vector107
vector107:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $107
80106b2c:	6a 6b                	push   $0x6b
  jmp alltraps
80106b2e:	e9 57 f7 ff ff       	jmp    8010628a <alltraps>

80106b33 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $108
80106b35:	6a 6c                	push   $0x6c
  jmp alltraps
80106b37:	e9 4e f7 ff ff       	jmp    8010628a <alltraps>

80106b3c <vector109>:
.globl vector109
vector109:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $109
80106b3e:	6a 6d                	push   $0x6d
  jmp alltraps
80106b40:	e9 45 f7 ff ff       	jmp    8010628a <alltraps>

80106b45 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $110
80106b47:	6a 6e                	push   $0x6e
  jmp alltraps
80106b49:	e9 3c f7 ff ff       	jmp    8010628a <alltraps>

80106b4e <vector111>:
.globl vector111
vector111:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $111
80106b50:	6a 6f                	push   $0x6f
  jmp alltraps
80106b52:	e9 33 f7 ff ff       	jmp    8010628a <alltraps>

80106b57 <vector112>:
.globl vector112
vector112:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $112
80106b59:	6a 70                	push   $0x70
  jmp alltraps
80106b5b:	e9 2a f7 ff ff       	jmp    8010628a <alltraps>

80106b60 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $113
80106b62:	6a 71                	push   $0x71
  jmp alltraps
80106b64:	e9 21 f7 ff ff       	jmp    8010628a <alltraps>

80106b69 <vector114>:
.globl vector114
vector114:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $114
80106b6b:	6a 72                	push   $0x72
  jmp alltraps
80106b6d:	e9 18 f7 ff ff       	jmp    8010628a <alltraps>

80106b72 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $115
80106b74:	6a 73                	push   $0x73
  jmp alltraps
80106b76:	e9 0f f7 ff ff       	jmp    8010628a <alltraps>

80106b7b <vector116>:
.globl vector116
vector116:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $116
80106b7d:	6a 74                	push   $0x74
  jmp alltraps
80106b7f:	e9 06 f7 ff ff       	jmp    8010628a <alltraps>

80106b84 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $117
80106b86:	6a 75                	push   $0x75
  jmp alltraps
80106b88:	e9 fd f6 ff ff       	jmp    8010628a <alltraps>

80106b8d <vector118>:
.globl vector118
vector118:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $118
80106b8f:	6a 76                	push   $0x76
  jmp alltraps
80106b91:	e9 f4 f6 ff ff       	jmp    8010628a <alltraps>

80106b96 <vector119>:
.globl vector119
vector119:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $119
80106b98:	6a 77                	push   $0x77
  jmp alltraps
80106b9a:	e9 eb f6 ff ff       	jmp    8010628a <alltraps>

80106b9f <vector120>:
.globl vector120
vector120:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $120
80106ba1:	6a 78                	push   $0x78
  jmp alltraps
80106ba3:	e9 e2 f6 ff ff       	jmp    8010628a <alltraps>

80106ba8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $121
80106baa:	6a 79                	push   $0x79
  jmp alltraps
80106bac:	e9 d9 f6 ff ff       	jmp    8010628a <alltraps>

80106bb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $122
80106bb3:	6a 7a                	push   $0x7a
  jmp alltraps
80106bb5:	e9 d0 f6 ff ff       	jmp    8010628a <alltraps>

80106bba <vector123>:
.globl vector123
vector123:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $123
80106bbc:	6a 7b                	push   $0x7b
  jmp alltraps
80106bbe:	e9 c7 f6 ff ff       	jmp    8010628a <alltraps>

80106bc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $124
80106bc5:	6a 7c                	push   $0x7c
  jmp alltraps
80106bc7:	e9 be f6 ff ff       	jmp    8010628a <alltraps>

80106bcc <vector125>:
.globl vector125
vector125:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $125
80106bce:	6a 7d                	push   $0x7d
  jmp alltraps
80106bd0:	e9 b5 f6 ff ff       	jmp    8010628a <alltraps>

80106bd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $126
80106bd7:	6a 7e                	push   $0x7e
  jmp alltraps
80106bd9:	e9 ac f6 ff ff       	jmp    8010628a <alltraps>

80106bde <vector127>:
.globl vector127
vector127:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $127
80106be0:	6a 7f                	push   $0x7f
  jmp alltraps
80106be2:	e9 a3 f6 ff ff       	jmp    8010628a <alltraps>

80106be7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $128
80106be9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bee:	e9 97 f6 ff ff       	jmp    8010628a <alltraps>

80106bf3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $129
80106bf5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bfa:	e9 8b f6 ff ff       	jmp    8010628a <alltraps>

80106bff <vector130>:
.globl vector130
vector130:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $130
80106c01:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c06:	e9 7f f6 ff ff       	jmp    8010628a <alltraps>

80106c0b <vector131>:
.globl vector131
vector131:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $131
80106c0d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c12:	e9 73 f6 ff ff       	jmp    8010628a <alltraps>

80106c17 <vector132>:
.globl vector132
vector132:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $132
80106c19:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c1e:	e9 67 f6 ff ff       	jmp    8010628a <alltraps>

80106c23 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $133
80106c25:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c2a:	e9 5b f6 ff ff       	jmp    8010628a <alltraps>

80106c2f <vector134>:
.globl vector134
vector134:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $134
80106c31:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c36:	e9 4f f6 ff ff       	jmp    8010628a <alltraps>

80106c3b <vector135>:
.globl vector135
vector135:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $135
80106c3d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c42:	e9 43 f6 ff ff       	jmp    8010628a <alltraps>

80106c47 <vector136>:
.globl vector136
vector136:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $136
80106c49:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c4e:	e9 37 f6 ff ff       	jmp    8010628a <alltraps>

80106c53 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $137
80106c55:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c5a:	e9 2b f6 ff ff       	jmp    8010628a <alltraps>

80106c5f <vector138>:
.globl vector138
vector138:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $138
80106c61:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c66:	e9 1f f6 ff ff       	jmp    8010628a <alltraps>

80106c6b <vector139>:
.globl vector139
vector139:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $139
80106c6d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c72:	e9 13 f6 ff ff       	jmp    8010628a <alltraps>

80106c77 <vector140>:
.globl vector140
vector140:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $140
80106c79:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c7e:	e9 07 f6 ff ff       	jmp    8010628a <alltraps>

80106c83 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $141
80106c85:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c8a:	e9 fb f5 ff ff       	jmp    8010628a <alltraps>

80106c8f <vector142>:
.globl vector142
vector142:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $142
80106c91:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c96:	e9 ef f5 ff ff       	jmp    8010628a <alltraps>

80106c9b <vector143>:
.globl vector143
vector143:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $143
80106c9d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ca2:	e9 e3 f5 ff ff       	jmp    8010628a <alltraps>

80106ca7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $144
80106ca9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106cae:	e9 d7 f5 ff ff       	jmp    8010628a <alltraps>

80106cb3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $145
80106cb5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cba:	e9 cb f5 ff ff       	jmp    8010628a <alltraps>

80106cbf <vector146>:
.globl vector146
vector146:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $146
80106cc1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106cc6:	e9 bf f5 ff ff       	jmp    8010628a <alltraps>

80106ccb <vector147>:
.globl vector147
vector147:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $147
80106ccd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cd2:	e9 b3 f5 ff ff       	jmp    8010628a <alltraps>

80106cd7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $148
80106cd9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cde:	e9 a7 f5 ff ff       	jmp    8010628a <alltraps>

80106ce3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $149
80106ce5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cea:	e9 9b f5 ff ff       	jmp    8010628a <alltraps>

80106cef <vector150>:
.globl vector150
vector150:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $150
80106cf1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cf6:	e9 8f f5 ff ff       	jmp    8010628a <alltraps>

80106cfb <vector151>:
.globl vector151
vector151:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $151
80106cfd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d02:	e9 83 f5 ff ff       	jmp    8010628a <alltraps>

80106d07 <vector152>:
.globl vector152
vector152:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $152
80106d09:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d0e:	e9 77 f5 ff ff       	jmp    8010628a <alltraps>

80106d13 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $153
80106d15:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d1a:	e9 6b f5 ff ff       	jmp    8010628a <alltraps>

80106d1f <vector154>:
.globl vector154
vector154:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $154
80106d21:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d26:	e9 5f f5 ff ff       	jmp    8010628a <alltraps>

80106d2b <vector155>:
.globl vector155
vector155:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $155
80106d2d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d32:	e9 53 f5 ff ff       	jmp    8010628a <alltraps>

80106d37 <vector156>:
.globl vector156
vector156:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $156
80106d39:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d3e:	e9 47 f5 ff ff       	jmp    8010628a <alltraps>

80106d43 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $157
80106d45:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d4a:	e9 3b f5 ff ff       	jmp    8010628a <alltraps>

80106d4f <vector158>:
.globl vector158
vector158:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $158
80106d51:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d56:	e9 2f f5 ff ff       	jmp    8010628a <alltraps>

80106d5b <vector159>:
.globl vector159
vector159:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $159
80106d5d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d62:	e9 23 f5 ff ff       	jmp    8010628a <alltraps>

80106d67 <vector160>:
.globl vector160
vector160:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $160
80106d69:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d6e:	e9 17 f5 ff ff       	jmp    8010628a <alltraps>

80106d73 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $161
80106d75:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d7a:	e9 0b f5 ff ff       	jmp    8010628a <alltraps>

80106d7f <vector162>:
.globl vector162
vector162:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $162
80106d81:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d86:	e9 ff f4 ff ff       	jmp    8010628a <alltraps>

80106d8b <vector163>:
.globl vector163
vector163:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $163
80106d8d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d92:	e9 f3 f4 ff ff       	jmp    8010628a <alltraps>

80106d97 <vector164>:
.globl vector164
vector164:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $164
80106d99:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d9e:	e9 e7 f4 ff ff       	jmp    8010628a <alltraps>

80106da3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $165
80106da5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106daa:	e9 db f4 ff ff       	jmp    8010628a <alltraps>

80106daf <vector166>:
.globl vector166
vector166:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $166
80106db1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106db6:	e9 cf f4 ff ff       	jmp    8010628a <alltraps>

80106dbb <vector167>:
.globl vector167
vector167:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $167
80106dbd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106dc2:	e9 c3 f4 ff ff       	jmp    8010628a <alltraps>

80106dc7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $168
80106dc9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106dce:	e9 b7 f4 ff ff       	jmp    8010628a <alltraps>

80106dd3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $169
80106dd5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106dda:	e9 ab f4 ff ff       	jmp    8010628a <alltraps>

80106ddf <vector170>:
.globl vector170
vector170:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $170
80106de1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106de6:	e9 9f f4 ff ff       	jmp    8010628a <alltraps>

80106deb <vector171>:
.globl vector171
vector171:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $171
80106ded:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106df2:	e9 93 f4 ff ff       	jmp    8010628a <alltraps>

80106df7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $172
80106df9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106dfe:	e9 87 f4 ff ff       	jmp    8010628a <alltraps>

80106e03 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $173
80106e05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e0a:	e9 7b f4 ff ff       	jmp    8010628a <alltraps>

80106e0f <vector174>:
.globl vector174
vector174:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $174
80106e11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e16:	e9 6f f4 ff ff       	jmp    8010628a <alltraps>

80106e1b <vector175>:
.globl vector175
vector175:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $175
80106e1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e22:	e9 63 f4 ff ff       	jmp    8010628a <alltraps>

80106e27 <vector176>:
.globl vector176
vector176:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $176
80106e29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e2e:	e9 57 f4 ff ff       	jmp    8010628a <alltraps>

80106e33 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $177
80106e35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e3a:	e9 4b f4 ff ff       	jmp    8010628a <alltraps>

80106e3f <vector178>:
.globl vector178
vector178:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $178
80106e41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e46:	e9 3f f4 ff ff       	jmp    8010628a <alltraps>

80106e4b <vector179>:
.globl vector179
vector179:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $179
80106e4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e52:	e9 33 f4 ff ff       	jmp    8010628a <alltraps>

80106e57 <vector180>:
.globl vector180
vector180:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $180
80106e59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e5e:	e9 27 f4 ff ff       	jmp    8010628a <alltraps>

80106e63 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $181
80106e65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e6a:	e9 1b f4 ff ff       	jmp    8010628a <alltraps>

80106e6f <vector182>:
.globl vector182
vector182:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $182
80106e71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e76:	e9 0f f4 ff ff       	jmp    8010628a <alltraps>

80106e7b <vector183>:
.globl vector183
vector183:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $183
80106e7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e82:	e9 03 f4 ff ff       	jmp    8010628a <alltraps>

80106e87 <vector184>:
.globl vector184
vector184:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $184
80106e89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e8e:	e9 f7 f3 ff ff       	jmp    8010628a <alltraps>

80106e93 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $185
80106e95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e9a:	e9 eb f3 ff ff       	jmp    8010628a <alltraps>

80106e9f <vector186>:
.globl vector186
vector186:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $186
80106ea1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ea6:	e9 df f3 ff ff       	jmp    8010628a <alltraps>

80106eab <vector187>:
.globl vector187
vector187:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $187
80106ead:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106eb2:	e9 d3 f3 ff ff       	jmp    8010628a <alltraps>

80106eb7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $188
80106eb9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ebe:	e9 c7 f3 ff ff       	jmp    8010628a <alltraps>

80106ec3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $189
80106ec5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106eca:	e9 bb f3 ff ff       	jmp    8010628a <alltraps>

80106ecf <vector190>:
.globl vector190
vector190:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $190
80106ed1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ed6:	e9 af f3 ff ff       	jmp    8010628a <alltraps>

80106edb <vector191>:
.globl vector191
vector191:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $191
80106edd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ee2:	e9 a3 f3 ff ff       	jmp    8010628a <alltraps>

80106ee7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $192
80106ee9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106eee:	e9 97 f3 ff ff       	jmp    8010628a <alltraps>

80106ef3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $193
80106ef5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106efa:	e9 8b f3 ff ff       	jmp    8010628a <alltraps>

80106eff <vector194>:
.globl vector194
vector194:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $194
80106f01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f06:	e9 7f f3 ff ff       	jmp    8010628a <alltraps>

80106f0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $195
80106f0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f12:	e9 73 f3 ff ff       	jmp    8010628a <alltraps>

80106f17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $196
80106f19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f1e:	e9 67 f3 ff ff       	jmp    8010628a <alltraps>

80106f23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $197
80106f25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f2a:	e9 5b f3 ff ff       	jmp    8010628a <alltraps>

80106f2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $198
80106f31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f36:	e9 4f f3 ff ff       	jmp    8010628a <alltraps>

80106f3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $199
80106f3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f42:	e9 43 f3 ff ff       	jmp    8010628a <alltraps>

80106f47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $200
80106f49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f4e:	e9 37 f3 ff ff       	jmp    8010628a <alltraps>

80106f53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $201
80106f55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f5a:	e9 2b f3 ff ff       	jmp    8010628a <alltraps>

80106f5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $202
80106f61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f66:	e9 1f f3 ff ff       	jmp    8010628a <alltraps>

80106f6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $203
80106f6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f72:	e9 13 f3 ff ff       	jmp    8010628a <alltraps>

80106f77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $204
80106f79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f7e:	e9 07 f3 ff ff       	jmp    8010628a <alltraps>

80106f83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $205
80106f85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f8a:	e9 fb f2 ff ff       	jmp    8010628a <alltraps>

80106f8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $206
80106f91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f96:	e9 ef f2 ff ff       	jmp    8010628a <alltraps>

80106f9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $207
80106f9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fa2:	e9 e3 f2 ff ff       	jmp    8010628a <alltraps>

80106fa7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $208
80106fa9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fae:	e9 d7 f2 ff ff       	jmp    8010628a <alltraps>

80106fb3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $209
80106fb5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fba:	e9 cb f2 ff ff       	jmp    8010628a <alltraps>

80106fbf <vector210>:
.globl vector210
vector210:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $210
80106fc1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fc6:	e9 bf f2 ff ff       	jmp    8010628a <alltraps>

80106fcb <vector211>:
.globl vector211
vector211:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $211
80106fcd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fd2:	e9 b3 f2 ff ff       	jmp    8010628a <alltraps>

80106fd7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $212
80106fd9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fde:	e9 a7 f2 ff ff       	jmp    8010628a <alltraps>

80106fe3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $213
80106fe5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fea:	e9 9b f2 ff ff       	jmp    8010628a <alltraps>

80106fef <vector214>:
.globl vector214
vector214:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $214
80106ff1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ff6:	e9 8f f2 ff ff       	jmp    8010628a <alltraps>

80106ffb <vector215>:
.globl vector215
vector215:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $215
80106ffd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107002:	e9 83 f2 ff ff       	jmp    8010628a <alltraps>

80107007 <vector216>:
.globl vector216
vector216:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $216
80107009:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010700e:	e9 77 f2 ff ff       	jmp    8010628a <alltraps>

80107013 <vector217>:
.globl vector217
vector217:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $217
80107015:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010701a:	e9 6b f2 ff ff       	jmp    8010628a <alltraps>

8010701f <vector218>:
.globl vector218
vector218:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $218
80107021:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107026:	e9 5f f2 ff ff       	jmp    8010628a <alltraps>

8010702b <vector219>:
.globl vector219
vector219:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $219
8010702d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107032:	e9 53 f2 ff ff       	jmp    8010628a <alltraps>

80107037 <vector220>:
.globl vector220
vector220:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $220
80107039:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010703e:	e9 47 f2 ff ff       	jmp    8010628a <alltraps>

80107043 <vector221>:
.globl vector221
vector221:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $221
80107045:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010704a:	e9 3b f2 ff ff       	jmp    8010628a <alltraps>

8010704f <vector222>:
.globl vector222
vector222:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $222
80107051:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107056:	e9 2f f2 ff ff       	jmp    8010628a <alltraps>

8010705b <vector223>:
.globl vector223
vector223:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $223
8010705d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107062:	e9 23 f2 ff ff       	jmp    8010628a <alltraps>

80107067 <vector224>:
.globl vector224
vector224:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $224
80107069:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010706e:	e9 17 f2 ff ff       	jmp    8010628a <alltraps>

80107073 <vector225>:
.globl vector225
vector225:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $225
80107075:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010707a:	e9 0b f2 ff ff       	jmp    8010628a <alltraps>

8010707f <vector226>:
.globl vector226
vector226:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $226
80107081:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107086:	e9 ff f1 ff ff       	jmp    8010628a <alltraps>

8010708b <vector227>:
.globl vector227
vector227:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $227
8010708d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107092:	e9 f3 f1 ff ff       	jmp    8010628a <alltraps>

80107097 <vector228>:
.globl vector228
vector228:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $228
80107099:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010709e:	e9 e7 f1 ff ff       	jmp    8010628a <alltraps>

801070a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $229
801070a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070aa:	e9 db f1 ff ff       	jmp    8010628a <alltraps>

801070af <vector230>:
.globl vector230
vector230:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $230
801070b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070b6:	e9 cf f1 ff ff       	jmp    8010628a <alltraps>

801070bb <vector231>:
.globl vector231
vector231:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $231
801070bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070c2:	e9 c3 f1 ff ff       	jmp    8010628a <alltraps>

801070c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $232
801070c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070ce:	e9 b7 f1 ff ff       	jmp    8010628a <alltraps>

801070d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $233
801070d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070da:	e9 ab f1 ff ff       	jmp    8010628a <alltraps>

801070df <vector234>:
.globl vector234
vector234:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $234
801070e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070e6:	e9 9f f1 ff ff       	jmp    8010628a <alltraps>

801070eb <vector235>:
.globl vector235
vector235:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $235
801070ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070f2:	e9 93 f1 ff ff       	jmp    8010628a <alltraps>

801070f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $236
801070f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070fe:	e9 87 f1 ff ff       	jmp    8010628a <alltraps>

80107103 <vector237>:
.globl vector237
vector237:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $237
80107105:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010710a:	e9 7b f1 ff ff       	jmp    8010628a <alltraps>

8010710f <vector238>:
.globl vector238
vector238:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $238
80107111:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107116:	e9 6f f1 ff ff       	jmp    8010628a <alltraps>

8010711b <vector239>:
.globl vector239
vector239:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $239
8010711d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107122:	e9 63 f1 ff ff       	jmp    8010628a <alltraps>

80107127 <vector240>:
.globl vector240
vector240:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $240
80107129:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010712e:	e9 57 f1 ff ff       	jmp    8010628a <alltraps>

80107133 <vector241>:
.globl vector241
vector241:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $241
80107135:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010713a:	e9 4b f1 ff ff       	jmp    8010628a <alltraps>

8010713f <vector242>:
.globl vector242
vector242:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $242
80107141:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107146:	e9 3f f1 ff ff       	jmp    8010628a <alltraps>

8010714b <vector243>:
.globl vector243
vector243:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $243
8010714d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107152:	e9 33 f1 ff ff       	jmp    8010628a <alltraps>

80107157 <vector244>:
.globl vector244
vector244:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $244
80107159:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010715e:	e9 27 f1 ff ff       	jmp    8010628a <alltraps>

80107163 <vector245>:
.globl vector245
vector245:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $245
80107165:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010716a:	e9 1b f1 ff ff       	jmp    8010628a <alltraps>

8010716f <vector246>:
.globl vector246
vector246:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $246
80107171:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107176:	e9 0f f1 ff ff       	jmp    8010628a <alltraps>

8010717b <vector247>:
.globl vector247
vector247:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $247
8010717d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107182:	e9 03 f1 ff ff       	jmp    8010628a <alltraps>

80107187 <vector248>:
.globl vector248
vector248:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $248
80107189:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010718e:	e9 f7 f0 ff ff       	jmp    8010628a <alltraps>

80107193 <vector249>:
.globl vector249
vector249:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $249
80107195:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010719a:	e9 eb f0 ff ff       	jmp    8010628a <alltraps>

8010719f <vector250>:
.globl vector250
vector250:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $250
801071a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071a6:	e9 df f0 ff ff       	jmp    8010628a <alltraps>

801071ab <vector251>:
.globl vector251
vector251:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $251
801071ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071b2:	e9 d3 f0 ff ff       	jmp    8010628a <alltraps>

801071b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $252
801071b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071be:	e9 c7 f0 ff ff       	jmp    8010628a <alltraps>

801071c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $253
801071c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071ca:	e9 bb f0 ff ff       	jmp    8010628a <alltraps>

801071cf <vector254>:
.globl vector254
vector254:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $254
801071d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071d6:	e9 af f0 ff ff       	jmp    8010628a <alltraps>

801071db <vector255>:
.globl vector255
vector255:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $255
801071dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071e2:	e9 a3 f0 ff ff       	jmp    8010628a <alltraps>
801071e7:	66 90                	xchg   %ax,%ax
801071e9:	66 90                	xchg   %ax,%ax
801071eb:	66 90                	xchg   %ax,%ax
801071ed:	66 90                	xchg   %ax,%ax
801071ef:	90                   	nop

801071f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801071f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801071fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107202:	83 ec 1c             	sub    $0x1c,%esp
80107205:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107208:	39 d3                	cmp    %edx,%ebx
8010720a:	73 49                	jae    80107255 <deallocuvm.part.0+0x65>
8010720c:	89 c7                	mov    %eax,%edi
8010720e:	eb 0c                	jmp    8010721c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107210:	83 c0 01             	add    $0x1,%eax
80107213:	c1 e0 16             	shl    $0x16,%eax
80107216:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107218:	39 da                	cmp    %ebx,%edx
8010721a:	76 39                	jbe    80107255 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010721c:	89 d8                	mov    %ebx,%eax
8010721e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107221:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107224:	f6 c1 01             	test   $0x1,%cl
80107227:	74 e7                	je     80107210 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107229:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010722b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107231:	c1 ee 0a             	shr    $0xa,%esi
80107234:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010723a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107241:	85 f6                	test   %esi,%esi
80107243:	74 cb                	je     80107210 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107245:	8b 06                	mov    (%esi),%eax
80107247:	a8 01                	test   $0x1,%al
80107249:	75 15                	jne    80107260 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010724b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107251:	39 da                	cmp    %ebx,%edx
80107253:	77 c7                	ja     8010721c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107255:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010725b:	5b                   	pop    %ebx
8010725c:	5e                   	pop    %esi
8010725d:	5f                   	pop    %edi
8010725e:	5d                   	pop    %ebp
8010725f:	c3                   	ret    
      if(pa == 0)
80107260:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107265:	74 25                	je     8010728c <deallocuvm.part.0+0x9c>
      kfree(v);
80107267:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010726a:	05 00 00 00 80       	add    $0x80000000,%eax
8010726f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107272:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107278:	50                   	push   %eax
80107279:	e8 92 bc ff ff       	call   80102f10 <kfree>
      *pte = 0;
8010727e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107284:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107287:	83 c4 10             	add    $0x10,%esp
8010728a:	eb 8c                	jmp    80107218 <deallocuvm.part.0+0x28>
        panic("kfree");
8010728c:	83 ec 0c             	sub    $0xc,%esp
8010728f:	68 46 7e 10 80       	push   $0x80107e46
80107294:	e8 77 91 ff ff       	call   80100410 <panic>
80107299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072a0 <mappages>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801072a6:	89 d3                	mov    %edx,%ebx
801072a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801072ae:	83 ec 1c             	sub    $0x1c,%esp
801072b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801072b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801072c0:	8b 45 08             	mov    0x8(%ebp),%eax
801072c3:	29 d8                	sub    %ebx,%eax
801072c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072c8:	eb 3d                	jmp    80107307 <mappages+0x67>
801072ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072d0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072d7:	c1 ea 0a             	shr    $0xa,%edx
801072da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801072e7:	85 c0                	test   %eax,%eax
801072e9:	74 75                	je     80107360 <mappages+0xc0>
    if(*pte & PTE_P)
801072eb:	f6 00 01             	testb  $0x1,(%eax)
801072ee:	0f 85 86 00 00 00    	jne    8010737a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801072f4:	0b 75 0c             	or     0xc(%ebp),%esi
801072f7:	83 ce 01             	or     $0x1,%esi
801072fa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801072fc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801072ff:	74 6f                	je     80107370 <mappages+0xd0>
    a += PGSIZE;
80107301:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107307:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010730a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010730d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107310:	89 d8                	mov    %ebx,%eax
80107312:	c1 e8 16             	shr    $0x16,%eax
80107315:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107318:	8b 07                	mov    (%edi),%eax
8010731a:	a8 01                	test   $0x1,%al
8010731c:	75 b2                	jne    801072d0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010731e:	e8 ad bd ff ff       	call   801030d0 <kalloc>
80107323:	85 c0                	test   %eax,%eax
80107325:	74 39                	je     80107360 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107327:	83 ec 04             	sub    $0x4,%esp
8010732a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010732d:	68 00 10 00 00       	push   $0x1000
80107332:	6a 00                	push   $0x0
80107334:	50                   	push   %eax
80107335:	e8 76 dd ff ff       	call   801050b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010733a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010733d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107340:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107346:	83 c8 07             	or     $0x7,%eax
80107349:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010734b:	89 d8                	mov    %ebx,%eax
8010734d:	c1 e8 0a             	shr    $0xa,%eax
80107350:	25 fc 0f 00 00       	and    $0xffc,%eax
80107355:	01 d0                	add    %edx,%eax
80107357:	eb 92                	jmp    801072eb <mappages+0x4b>
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107360:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107368:	5b                   	pop    %ebx
80107369:	5e                   	pop    %esi
8010736a:	5f                   	pop    %edi
8010736b:	5d                   	pop    %ebp
8010736c:	c3                   	ret    
8010736d:	8d 76 00             	lea    0x0(%esi),%esi
80107370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107373:	31 c0                	xor    %eax,%eax
}
80107375:	5b                   	pop    %ebx
80107376:	5e                   	pop    %esi
80107377:	5f                   	pop    %edi
80107378:	5d                   	pop    %ebp
80107379:	c3                   	ret    
      panic("remap");
8010737a:	83 ec 0c             	sub    $0xc,%esp
8010737d:	68 88 84 10 80       	push   $0x80108488
80107382:	e8 89 90 ff ff       	call   80100410 <panic>
80107387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738e:	66 90                	xchg   %ax,%ax

80107390 <seginit>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107396:	e8 05 d0 ff ff       	call   801043a0 <cpuid>
  pd[0] = size-1;
8010739b:	ba 2f 00 00 00       	mov    $0x2f,%edx
801073a0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801073a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801073aa:	c7 80 38 33 11 80 ff 	movl   $0xffff,-0x7feeccc8(%eax)
801073b1:	ff 00 00 
801073b4:	c7 80 3c 33 11 80 00 	movl   $0xcf9a00,-0x7feeccc4(%eax)
801073bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073be:	c7 80 40 33 11 80 ff 	movl   $0xffff,-0x7feeccc0(%eax)
801073c5:	ff 00 00 
801073c8:	c7 80 44 33 11 80 00 	movl   $0xcf9200,-0x7feeccbc(%eax)
801073cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073d2:	c7 80 48 33 11 80 ff 	movl   $0xffff,-0x7feeccb8(%eax)
801073d9:	ff 00 00 
801073dc:	c7 80 4c 33 11 80 00 	movl   $0xcffa00,-0x7feeccb4(%eax)
801073e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801073e6:	c7 80 50 33 11 80 ff 	movl   $0xffff,-0x7feeccb0(%eax)
801073ed:	ff 00 00 
801073f0:	c7 80 54 33 11 80 00 	movl   $0xcff200,-0x7feeccac(%eax)
801073f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801073fa:	05 30 33 11 80       	add    $0x80113330,%eax
  pd[1] = (uint)p;
801073ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107403:	c1 e8 10             	shr    $0x10,%eax
80107406:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010740a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010740d:	0f 01 10             	lgdtl  (%eax)
}
80107410:	c9                   	leave  
80107411:	c3                   	ret    
80107412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107420 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107420:	a1 e4 5f 11 80       	mov    0x80115fe4,%eax
80107425:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010742a:	0f 22 d8             	mov    %eax,%cr3
}
8010742d:	c3                   	ret    
8010742e:	66 90                	xchg   %ax,%ax

80107430 <switchuvm>:
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
80107439:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010743c:	85 f6                	test   %esi,%esi
8010743e:	0f 84 cb 00 00 00    	je     8010750f <switchuvm+0xdf>
  if(p->kstack == 0)
80107444:	8b 46 08             	mov    0x8(%esi),%eax
80107447:	85 c0                	test   %eax,%eax
80107449:	0f 84 da 00 00 00    	je     80107529 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010744f:	8b 46 04             	mov    0x4(%esi),%eax
80107452:	85 c0                	test   %eax,%eax
80107454:	0f 84 c2 00 00 00    	je     8010751c <switchuvm+0xec>
  pushcli();
8010745a:	e8 41 da ff ff       	call   80104ea0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010745f:	e8 dc ce ff ff       	call   80104340 <mycpu>
80107464:	89 c3                	mov    %eax,%ebx
80107466:	e8 d5 ce ff ff       	call   80104340 <mycpu>
8010746b:	89 c7                	mov    %eax,%edi
8010746d:	e8 ce ce ff ff       	call   80104340 <mycpu>
80107472:	83 c7 08             	add    $0x8,%edi
80107475:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107478:	e8 c3 ce ff ff       	call   80104340 <mycpu>
8010747d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107480:	ba 67 00 00 00       	mov    $0x67,%edx
80107485:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010748c:	83 c0 08             	add    $0x8,%eax
8010748f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107496:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010749b:	83 c1 08             	add    $0x8,%ecx
8010749e:	c1 e8 18             	shr    $0x18,%eax
801074a1:	c1 e9 10             	shr    $0x10,%ecx
801074a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801074aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801074b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801074c1:	e8 7a ce ff ff       	call   80104340 <mycpu>
801074c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074cd:	e8 6e ce ff ff       	call   80104340 <mycpu>
801074d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801074d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074df:	e8 5c ce ff ff       	call   80104340 <mycpu>
801074e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074e7:	e8 54 ce ff ff       	call   80104340 <mycpu>
801074ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801074f0:	b8 28 00 00 00       	mov    $0x28,%eax
801074f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801074f8:	8b 46 04             	mov    0x4(%esi),%eax
801074fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107500:	0f 22 d8             	mov    %eax,%cr3
}
80107503:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107506:	5b                   	pop    %ebx
80107507:	5e                   	pop    %esi
80107508:	5f                   	pop    %edi
80107509:	5d                   	pop    %ebp
  popcli();
8010750a:	e9 e1 d9 ff ff       	jmp    80104ef0 <popcli>
    panic("switchuvm: no process");
8010750f:	83 ec 0c             	sub    $0xc,%esp
80107512:	68 8e 84 10 80       	push   $0x8010848e
80107517:	e8 f4 8e ff ff       	call   80100410 <panic>
    panic("switchuvm: no pgdir");
8010751c:	83 ec 0c             	sub    $0xc,%esp
8010751f:	68 b9 84 10 80       	push   $0x801084b9
80107524:	e8 e7 8e ff ff       	call   80100410 <panic>
    panic("switchuvm: no kstack");
80107529:	83 ec 0c             	sub    $0xc,%esp
8010752c:	68 a4 84 10 80       	push   $0x801084a4
80107531:	e8 da 8e ff ff       	call   80100410 <panic>
80107536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753d:	8d 76 00             	lea    0x0(%esi),%esi

80107540 <inituvm>:
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 1c             	sub    $0x1c,%esp
80107549:	8b 45 0c             	mov    0xc(%ebp),%eax
8010754c:	8b 75 10             	mov    0x10(%ebp),%esi
8010754f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107555:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010755b:	77 4b                	ja     801075a8 <inituvm+0x68>
  mem = kalloc();
8010755d:	e8 6e bb ff ff       	call   801030d0 <kalloc>
  memset(mem, 0, PGSIZE);
80107562:	83 ec 04             	sub    $0x4,%esp
80107565:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010756a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010756c:	6a 00                	push   $0x0
8010756e:	50                   	push   %eax
8010756f:	e8 3c db ff ff       	call   801050b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107574:	58                   	pop    %eax
80107575:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010757b:	5a                   	pop    %edx
8010757c:	6a 06                	push   $0x6
8010757e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107583:	31 d2                	xor    %edx,%edx
80107585:	50                   	push   %eax
80107586:	89 f8                	mov    %edi,%eax
80107588:	e8 13 fd ff ff       	call   801072a0 <mappages>
  memmove(mem, init, sz);
8010758d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107590:	89 75 10             	mov    %esi,0x10(%ebp)
80107593:	83 c4 10             	add    $0x10,%esp
80107596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107599:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010759c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759f:	5b                   	pop    %ebx
801075a0:	5e                   	pop    %esi
801075a1:	5f                   	pop    %edi
801075a2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801075a3:	e9 a8 db ff ff       	jmp    80105150 <memmove>
    panic("inituvm: more than a page");
801075a8:	83 ec 0c             	sub    $0xc,%esp
801075ab:	68 cd 84 10 80       	push   $0x801084cd
801075b0:	e8 5b 8e ff ff       	call   80100410 <panic>
801075b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075c0 <loaduvm>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	57                   	push   %edi
801075c4:	56                   	push   %esi
801075c5:	53                   	push   %ebx
801075c6:	83 ec 1c             	sub    $0x1c,%esp
801075c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801075cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801075cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801075d4:	0f 85 bb 00 00 00    	jne    80107695 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801075da:	01 f0                	add    %esi,%eax
801075dc:	89 f3                	mov    %esi,%ebx
801075de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075e1:	8b 45 14             	mov    0x14(%ebp),%eax
801075e4:	01 f0                	add    %esi,%eax
801075e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801075e9:	85 f6                	test   %esi,%esi
801075eb:	0f 84 87 00 00 00    	je     80107678 <loaduvm+0xb8>
801075f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801075f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801075fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801075fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107600:	89 c2                	mov    %eax,%edx
80107602:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107605:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107608:	f6 c2 01             	test   $0x1,%dl
8010760b:	75 13                	jne    80107620 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010760d:	83 ec 0c             	sub    $0xc,%esp
80107610:	68 e7 84 10 80       	push   $0x801084e7
80107615:	e8 f6 8d ff ff       	call   80100410 <panic>
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107620:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107623:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107629:	25 fc 0f 00 00       	and    $0xffc,%eax
8010762e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107635:	85 c0                	test   %eax,%eax
80107637:	74 d4                	je     8010760d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107639:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010763b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010763e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107643:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107648:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010764e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107651:	29 d9                	sub    %ebx,%ecx
80107653:	05 00 00 00 80       	add    $0x80000000,%eax
80107658:	57                   	push   %edi
80107659:	51                   	push   %ecx
8010765a:	50                   	push   %eax
8010765b:	ff 75 10             	push   0x10(%ebp)
8010765e:	e8 7d ae ff ff       	call   801024e0 <readi>
80107663:	83 c4 10             	add    $0x10,%esp
80107666:	39 f8                	cmp    %edi,%eax
80107668:	75 1e                	jne    80107688 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010766a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107670:	89 f0                	mov    %esi,%eax
80107672:	29 d8                	sub    %ebx,%eax
80107674:	39 c6                	cmp    %eax,%esi
80107676:	77 80                	ja     801075f8 <loaduvm+0x38>
}
80107678:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010767b:	31 c0                	xor    %eax,%eax
}
8010767d:	5b                   	pop    %ebx
8010767e:	5e                   	pop    %esi
8010767f:	5f                   	pop    %edi
80107680:	5d                   	pop    %ebp
80107681:	c3                   	ret    
80107682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107688:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010768b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107690:	5b                   	pop    %ebx
80107691:	5e                   	pop    %esi
80107692:	5f                   	pop    %edi
80107693:	5d                   	pop    %ebp
80107694:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107695:	83 ec 0c             	sub    $0xc,%esp
80107698:	68 88 85 10 80       	push   $0x80108588
8010769d:	e8 6e 8d ff ff       	call   80100410 <panic>
801076a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076b0 <allocuvm>:
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801076b9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801076bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801076bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076c2:	85 c0                	test   %eax,%eax
801076c4:	0f 88 b6 00 00 00    	js     80107780 <allocuvm+0xd0>
  if(newsz < oldsz)
801076ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801076cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801076d0:	0f 82 9a 00 00 00    	jb     80107770 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801076d6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801076dc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801076e2:	39 75 10             	cmp    %esi,0x10(%ebp)
801076e5:	77 44                	ja     8010772b <allocuvm+0x7b>
801076e7:	e9 87 00 00 00       	jmp    80107773 <allocuvm+0xc3>
801076ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801076f0:	83 ec 04             	sub    $0x4,%esp
801076f3:	68 00 10 00 00       	push   $0x1000
801076f8:	6a 00                	push   $0x0
801076fa:	50                   	push   %eax
801076fb:	e8 b0 d9 ff ff       	call   801050b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107700:	58                   	pop    %eax
80107701:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107707:	5a                   	pop    %edx
80107708:	6a 06                	push   $0x6
8010770a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010770f:	89 f2                	mov    %esi,%edx
80107711:	50                   	push   %eax
80107712:	89 f8                	mov    %edi,%eax
80107714:	e8 87 fb ff ff       	call   801072a0 <mappages>
80107719:	83 c4 10             	add    $0x10,%esp
8010771c:	85 c0                	test   %eax,%eax
8010771e:	78 78                	js     80107798 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107720:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107726:	39 75 10             	cmp    %esi,0x10(%ebp)
80107729:	76 48                	jbe    80107773 <allocuvm+0xc3>
    mem = kalloc();
8010772b:	e8 a0 b9 ff ff       	call   801030d0 <kalloc>
80107730:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107732:	85 c0                	test   %eax,%eax
80107734:	75 ba                	jne    801076f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107736:	83 ec 0c             	sub    $0xc,%esp
80107739:	68 05 85 10 80       	push   $0x80108505
8010773e:	e8 4d 90 ff ff       	call   80100790 <cprintf>
  if(newsz >= oldsz)
80107743:	8b 45 0c             	mov    0xc(%ebp),%eax
80107746:	83 c4 10             	add    $0x10,%esp
80107749:	39 45 10             	cmp    %eax,0x10(%ebp)
8010774c:	74 32                	je     80107780 <allocuvm+0xd0>
8010774e:	8b 55 10             	mov    0x10(%ebp),%edx
80107751:	89 c1                	mov    %eax,%ecx
80107753:	89 f8                	mov    %edi,%eax
80107755:	e8 96 fa ff ff       	call   801071f0 <deallocuvm.part.0>
      return 0;
8010775a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107764:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107767:	5b                   	pop    %ebx
80107768:	5e                   	pop    %esi
80107769:	5f                   	pop    %edi
8010776a:	5d                   	pop    %ebp
8010776b:	c3                   	ret    
8010776c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107779:	5b                   	pop    %ebx
8010777a:	5e                   	pop    %esi
8010777b:	5f                   	pop    %edi
8010777c:	5d                   	pop    %ebp
8010777d:	c3                   	ret    
8010777e:	66 90                	xchg   %ax,%ax
    return 0;
80107780:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010778a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778d:	5b                   	pop    %ebx
8010778e:	5e                   	pop    %esi
8010778f:	5f                   	pop    %edi
80107790:	5d                   	pop    %ebp
80107791:	c3                   	ret    
80107792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107798:	83 ec 0c             	sub    $0xc,%esp
8010779b:	68 1d 85 10 80       	push   $0x8010851d
801077a0:	e8 eb 8f ff ff       	call   80100790 <cprintf>
  if(newsz >= oldsz)
801077a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801077a8:	83 c4 10             	add    $0x10,%esp
801077ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801077ae:	74 0c                	je     801077bc <allocuvm+0x10c>
801077b0:	8b 55 10             	mov    0x10(%ebp),%edx
801077b3:	89 c1                	mov    %eax,%ecx
801077b5:	89 f8                	mov    %edi,%eax
801077b7:	e8 34 fa ff ff       	call   801071f0 <deallocuvm.part.0>
      kfree(mem);
801077bc:	83 ec 0c             	sub    $0xc,%esp
801077bf:	53                   	push   %ebx
801077c0:	e8 4b b7 ff ff       	call   80102f10 <kfree>
      return 0;
801077c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801077cc:	83 c4 10             	add    $0x10,%esp
}
801077cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    
801077da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077e0 <deallocuvm>:
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801077e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801077e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801077ec:	39 d1                	cmp    %edx,%ecx
801077ee:	73 10                	jae    80107800 <deallocuvm+0x20>
}
801077f0:	5d                   	pop    %ebp
801077f1:	e9 fa f9 ff ff       	jmp    801071f0 <deallocuvm.part.0>
801077f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fd:	8d 76 00             	lea    0x0(%esi),%esi
80107800:	89 d0                	mov    %edx,%eax
80107802:	5d                   	pop    %ebp
80107803:	c3                   	ret    
80107804:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010780f:	90                   	nop

80107810 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	57                   	push   %edi
80107814:	56                   	push   %esi
80107815:	53                   	push   %ebx
80107816:	83 ec 0c             	sub    $0xc,%esp
80107819:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010781c:	85 f6                	test   %esi,%esi
8010781e:	74 59                	je     80107879 <freevm+0x69>
  if(newsz >= oldsz)
80107820:	31 c9                	xor    %ecx,%ecx
80107822:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107827:	89 f0                	mov    %esi,%eax
80107829:	89 f3                	mov    %esi,%ebx
8010782b:	e8 c0 f9 ff ff       	call   801071f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107830:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107836:	eb 0f                	jmp    80107847 <freevm+0x37>
80107838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010783f:	90                   	nop
80107840:	83 c3 04             	add    $0x4,%ebx
80107843:	39 df                	cmp    %ebx,%edi
80107845:	74 23                	je     8010786a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107847:	8b 03                	mov    (%ebx),%eax
80107849:	a8 01                	test   $0x1,%al
8010784b:	74 f3                	je     80107840 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010784d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107852:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107855:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107858:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010785d:	50                   	push   %eax
8010785e:	e8 ad b6 ff ff       	call   80102f10 <kfree>
80107863:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107866:	39 df                	cmp    %ebx,%edi
80107868:	75 dd                	jne    80107847 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010786a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010786d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107870:	5b                   	pop    %ebx
80107871:	5e                   	pop    %esi
80107872:	5f                   	pop    %edi
80107873:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107874:	e9 97 b6 ff ff       	jmp    80102f10 <kfree>
    panic("freevm: no pgdir");
80107879:	83 ec 0c             	sub    $0xc,%esp
8010787c:	68 39 85 10 80       	push   $0x80108539
80107881:	e8 8a 8b ff ff       	call   80100410 <panic>
80107886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010788d:	8d 76 00             	lea    0x0(%esi),%esi

80107890 <setupkvm>:
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	56                   	push   %esi
80107894:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107895:	e8 36 b8 ff ff       	call   801030d0 <kalloc>
8010789a:	89 c6                	mov    %eax,%esi
8010789c:	85 c0                	test   %eax,%eax
8010789e:	74 42                	je     801078e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801078a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801078a8:	68 00 10 00 00       	push   $0x1000
801078ad:	6a 00                	push   $0x0
801078af:	50                   	push   %eax
801078b0:	e8 fb d7 ff ff       	call   801050b0 <memset>
801078b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801078b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078bb:	83 ec 08             	sub    $0x8,%esp
801078be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078c1:	ff 73 0c             	push   0xc(%ebx)
801078c4:	8b 13                	mov    (%ebx),%edx
801078c6:	50                   	push   %eax
801078c7:	29 c1                	sub    %eax,%ecx
801078c9:	89 f0                	mov    %esi,%eax
801078cb:	e8 d0 f9 ff ff       	call   801072a0 <mappages>
801078d0:	83 c4 10             	add    $0x10,%esp
801078d3:	85 c0                	test   %eax,%eax
801078d5:	78 19                	js     801078f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078d7:	83 c3 10             	add    $0x10,%ebx
801078da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801078e0:	75 d6                	jne    801078b8 <setupkvm+0x28>
}
801078e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078e5:	89 f0                	mov    %esi,%eax
801078e7:	5b                   	pop    %ebx
801078e8:	5e                   	pop    %esi
801078e9:	5d                   	pop    %ebp
801078ea:	c3                   	ret    
801078eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078ef:	90                   	nop
      freevm(pgdir);
801078f0:	83 ec 0c             	sub    $0xc,%esp
801078f3:	56                   	push   %esi
      return 0;
801078f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801078f6:	e8 15 ff ff ff       	call   80107810 <freevm>
      return 0;
801078fb:	83 c4 10             	add    $0x10,%esp
}
801078fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107901:	89 f0                	mov    %esi,%eax
80107903:	5b                   	pop    %ebx
80107904:	5e                   	pop    %esi
80107905:	5d                   	pop    %ebp
80107906:	c3                   	ret    
80107907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790e:	66 90                	xchg   %ax,%ax

80107910 <kvmalloc>:
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107916:	e8 75 ff ff ff       	call   80107890 <setupkvm>
8010791b:	a3 e4 5f 11 80       	mov    %eax,0x80115fe4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107920:	05 00 00 00 80       	add    $0x80000000,%eax
80107925:	0f 22 d8             	mov    %eax,%cr3
}
80107928:	c9                   	leave  
80107929:	c3                   	ret    
8010792a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107930 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	83 ec 08             	sub    $0x8,%esp
80107936:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107939:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010793c:	89 c1                	mov    %eax,%ecx
8010793e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107941:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107944:	f6 c2 01             	test   $0x1,%dl
80107947:	75 17                	jne    80107960 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107949:	83 ec 0c             	sub    $0xc,%esp
8010794c:	68 4a 85 10 80       	push   $0x8010854a
80107951:	e8 ba 8a ff ff       	call   80100410 <panic>
80107956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010795d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107960:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107963:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107969:	25 fc 0f 00 00       	and    $0xffc,%eax
8010796e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107975:	85 c0                	test   %eax,%eax
80107977:	74 d0                	je     80107949 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107979:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010797c:	c9                   	leave  
8010797d:	c3                   	ret    
8010797e:	66 90                	xchg   %ax,%ax

80107980 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
80107986:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107989:	e8 02 ff ff ff       	call   80107890 <setupkvm>
8010798e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107991:	85 c0                	test   %eax,%eax
80107993:	0f 84 bd 00 00 00    	je     80107a56 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010799c:	85 c9                	test   %ecx,%ecx
8010799e:	0f 84 b2 00 00 00    	je     80107a56 <copyuvm+0xd6>
801079a4:	31 f6                	xor    %esi,%esi
801079a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801079b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801079b3:	89 f0                	mov    %esi,%eax
801079b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801079b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801079bb:	a8 01                	test   $0x1,%al
801079bd:	75 11                	jne    801079d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801079bf:	83 ec 0c             	sub    $0xc,%esp
801079c2:	68 54 85 10 80       	push   $0x80108554
801079c7:	e8 44 8a ff ff       	call   80100410 <panic>
801079cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801079d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801079d7:	c1 ea 0a             	shr    $0xa,%edx
801079da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801079e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801079e7:	85 c0                	test   %eax,%eax
801079e9:	74 d4                	je     801079bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801079eb:	8b 00                	mov    (%eax),%eax
801079ed:	a8 01                	test   $0x1,%al
801079ef:	0f 84 9f 00 00 00    	je     80107a94 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801079f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801079f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801079fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801079ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a05:	e8 c6 b6 ff ff       	call   801030d0 <kalloc>
80107a0a:	89 c3                	mov    %eax,%ebx
80107a0c:	85 c0                	test   %eax,%eax
80107a0e:	74 64                	je     80107a74 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a10:	83 ec 04             	sub    $0x4,%esp
80107a13:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a19:	68 00 10 00 00       	push   $0x1000
80107a1e:	57                   	push   %edi
80107a1f:	50                   	push   %eax
80107a20:	e8 2b d7 ff ff       	call   80105150 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a25:	58                   	pop    %eax
80107a26:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a2c:	5a                   	pop    %edx
80107a2d:	ff 75 e4             	push   -0x1c(%ebp)
80107a30:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a35:	89 f2                	mov    %esi,%edx
80107a37:	50                   	push   %eax
80107a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a3b:	e8 60 f8 ff ff       	call   801072a0 <mappages>
80107a40:	83 c4 10             	add    $0x10,%esp
80107a43:	85 c0                	test   %eax,%eax
80107a45:	78 21                	js     80107a68 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107a47:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a4d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a50:	0f 87 5a ff ff ff    	ja     801079b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a5c:	5b                   	pop    %ebx
80107a5d:	5e                   	pop    %esi
80107a5e:	5f                   	pop    %edi
80107a5f:	5d                   	pop    %ebp
80107a60:	c3                   	ret    
80107a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107a68:	83 ec 0c             	sub    $0xc,%esp
80107a6b:	53                   	push   %ebx
80107a6c:	e8 9f b4 ff ff       	call   80102f10 <kfree>
      goto bad;
80107a71:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107a74:	83 ec 0c             	sub    $0xc,%esp
80107a77:	ff 75 e0             	push   -0x20(%ebp)
80107a7a:	e8 91 fd ff ff       	call   80107810 <freevm>
  return 0;
80107a7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a86:	83 c4 10             	add    $0x10,%esp
}
80107a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a8f:	5b                   	pop    %ebx
80107a90:	5e                   	pop    %esi
80107a91:	5f                   	pop    %edi
80107a92:	5d                   	pop    %ebp
80107a93:	c3                   	ret    
      panic("copyuvm: page not present");
80107a94:	83 ec 0c             	sub    $0xc,%esp
80107a97:	68 6e 85 10 80       	push   $0x8010856e
80107a9c:	e8 6f 89 ff ff       	call   80100410 <panic>
80107aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aaf:	90                   	nop

80107ab0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ab0:	55                   	push   %ebp
80107ab1:	89 e5                	mov    %esp,%ebp
80107ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107ab9:	89 c1                	mov    %eax,%ecx
80107abb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107abe:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107ac1:	f6 c2 01             	test   $0x1,%dl
80107ac4:	0f 84 00 01 00 00    	je     80107bca <uva2ka.cold>
  return &pgtab[PTX(va)];
80107aca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107acd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ad3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107ad4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107ad9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107ae0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ae7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107aea:	05 00 00 00 80       	add    $0x80000000,%eax
80107aef:	83 fa 05             	cmp    $0x5,%edx
80107af2:	ba 00 00 00 00       	mov    $0x0,%edx
80107af7:	0f 45 c2             	cmovne %edx,%eax
}
80107afa:	c3                   	ret    
80107afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107aff:	90                   	nop

80107b00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	57                   	push   %edi
80107b04:	56                   	push   %esi
80107b05:	53                   	push   %ebx
80107b06:	83 ec 0c             	sub    $0xc,%esp
80107b09:	8b 75 14             	mov    0x14(%ebp),%esi
80107b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b0f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b12:	85 f6                	test   %esi,%esi
80107b14:	75 51                	jne    80107b67 <copyout+0x67>
80107b16:	e9 a5 00 00 00       	jmp    80107bc0 <copyout+0xc0>
80107b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b1f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107b20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107b26:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107b2c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107b32:	74 75                	je     80107ba9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107b34:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b36:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107b39:	29 c3                	sub    %eax,%ebx
80107b3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b41:	39 f3                	cmp    %esi,%ebx
80107b43:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107b46:	29 f8                	sub    %edi,%eax
80107b48:	83 ec 04             	sub    $0x4,%esp
80107b4b:	01 c1                	add    %eax,%ecx
80107b4d:	53                   	push   %ebx
80107b4e:	52                   	push   %edx
80107b4f:	51                   	push   %ecx
80107b50:	e8 fb d5 ff ff       	call   80105150 <memmove>
    len -= n;
    buf += n;
80107b55:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107b58:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107b5e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107b61:	01 da                	add    %ebx,%edx
  while(len > 0){
80107b63:	29 de                	sub    %ebx,%esi
80107b65:	74 59                	je     80107bc0 <copyout+0xc0>
  if(*pde & PTE_P){
80107b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107b6a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b6c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107b6e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b71:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107b77:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107b7a:	f6 c1 01             	test   $0x1,%cl
80107b7d:	0f 84 4e 00 00 00    	je     80107bd1 <copyout.cold>
  return &pgtab[PTX(va)];
80107b83:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b85:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107b8b:	c1 eb 0c             	shr    $0xc,%ebx
80107b8e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107b94:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107b9b:	89 d9                	mov    %ebx,%ecx
80107b9d:	83 e1 05             	and    $0x5,%ecx
80107ba0:	83 f9 05             	cmp    $0x5,%ecx
80107ba3:	0f 84 77 ff ff ff    	je     80107b20 <copyout+0x20>
  }
  return 0;
}
80107ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bb1:	5b                   	pop    %ebx
80107bb2:	5e                   	pop    %esi
80107bb3:	5f                   	pop    %edi
80107bb4:	5d                   	pop    %ebp
80107bb5:	c3                   	ret    
80107bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bbd:	8d 76 00             	lea    0x0(%esi),%esi
80107bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bc3:	31 c0                	xor    %eax,%eax
}
80107bc5:	5b                   	pop    %ebx
80107bc6:	5e                   	pop    %esi
80107bc7:	5f                   	pop    %edi
80107bc8:	5d                   	pop    %ebp
80107bc9:	c3                   	ret    

80107bca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107bca:	a1 00 00 00 00       	mov    0x0,%eax
80107bcf:	0f 0b                	ud2    

80107bd1 <copyout.cold>:
80107bd1:	a1 00 00 00 00       	mov    0x0,%eax
80107bd6:	0f 0b                	ud2    
