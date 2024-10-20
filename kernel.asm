
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
80100028:	bc 70 70 11 80       	mov    $0x80117070,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 41 10 80       	mov    $0x801041a0,%eax
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
8010004c:	68 e0 82 10 80       	push   $0x801082e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 54 00 00       	call   80105510 <initlock>
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
80100092:	68 e7 82 10 80       	push   $0x801082e7
80100097:	50                   	push   %eax
80100098:	e8 43 53 00 00       	call   801053e0 <initsleeplock>
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
801000e4:	e8 f7 55 00 00       	call   801056e0 <acquire>
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
80100162:	e8 19 55 00 00       	call   80105680 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 52 00 00       	call   80105420 <acquiresleep>
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
8010018c:	e8 8f 32 00 00       	call   80103420 <iderw>
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
801001a1:	68 ee 82 10 80       	push   $0x801082ee
801001a6:	e8 b5 02 00 00       	call   80100460 <panic>
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
801001be:	e8 fd 52 00 00       	call   801054c0 <holdingsleep>
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
801001d4:	e9 47 32 00 00       	jmp    80103420 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 82 10 80       	push   $0x801082ff
801001e1:	e8 7a 02 00 00       	call   80100460 <panic>
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
801001ff:	e8 bc 52 00 00       	call   801054c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 52 00 00       	call   80105480 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 54 00 00       	call   801056e0 <acquire>
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
8010026c:	e9 0f 54 00 00       	jmp    80105680 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 83 10 80       	push   $0x80108306
80100279:	e8 e2 01 00 00       	call   80100460 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 07 27 00 00       	call   801029a0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 c0 0a 11 80 	movl   $0x80110ac0,(%esp)
801002a0:	e8 3b 54 00 00       	call   801056e0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 c0 0a 11 80       	push   $0x80110ac0
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ae 4e 00 00       	call   80105180 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 47 00 00       	call   80104ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 0a 11 80       	push   $0x80110ac0
801002f6:	e8 85 53 00 00       	call   80105680 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 bc 25 00 00       	call   801028c0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 c0 0a 11 80       	push   $0x80110ac0
8010034c:	e8 2f 53 00 00       	call   80105680 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 66 25 00 00       	call   801028c0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <itoa.part.0>:
    }
    return rev;
}

// Helper function to convert an integer to string (similar to itoa)
void itoa(int num, char *str, int base) {
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	57                   	push   %edi
80100384:	56                   	push   %esi
80100385:	53                   	push   %ebx
80100386:	89 d3                	mov    %edx,%ebx
80100388:	83 ec 0c             	sub    $0xc,%esp
8010038b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        str[i] = '\0';
        return;
    }

    // Handle negative numbers
    if (num < 0 && base == 10) {
8010038e:	85 c0                	test   %eax,%eax
80100390:	0f 89 9a 00 00 00    	jns    80100430 <itoa.part.0+0xb0>
80100396:	83 f9 0a             	cmp    $0xa,%ecx
80100399:	0f 85 91 00 00 00    	jne    80100430 <itoa.part.0+0xb0>
        isNegative = 1;
8010039f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
        num = -num;
801003a6:	f7 d8                	neg    %eax
    }

    // Process individual digits
    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801003a8:	31 c9                	xor    %ecx,%ecx
801003aa:	eb 06                	jmp    801003b2 <itoa.part.0+0x32>
801003ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003b0:	89 d1                	mov    %edx,%ecx
        int rem = num % base;
801003b2:	99                   	cltd   
801003b3:	f7 7d ec             	idivl  -0x14(%ebp)
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801003b6:	8d 7a 57             	lea    0x57(%edx),%edi
801003b9:	8d 72 30             	lea    0x30(%edx),%esi
801003bc:	83 fa 0a             	cmp    $0xa,%edx
801003bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003c2:	0f 4d f7             	cmovge %edi,%esi
801003c5:	8d 51 01             	lea    0x1(%ecx),%edx
801003c8:	89 f0                	mov    %esi,%eax
801003ca:	88 44 13 ff          	mov    %al,-0x1(%ebx,%edx,1)
        num = num / base;
801003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (num != 0) {
801003d1:	85 c0                	test   %eax,%eax
801003d3:	75 db                	jne    801003b0 <itoa.part.0+0x30>
    }

    // Append '-' if the number is negative
    if (isNegative) str[i++] = '-';
801003d5:	8b 7d e8             	mov    -0x18(%ebp),%edi
801003d8:	8d 34 13             	lea    (%ebx,%edx,1),%esi
801003db:	85 ff                	test   %edi,%edi
801003dd:	74 39                	je     80100418 <itoa.part.0+0x98>
801003df:	c6 06 2d             	movb   $0x2d,(%esi)

    str[i] = '\0';
801003e2:	c6 44 0b 02 00       	movb   $0x0,0x2(%ebx,%ecx,1)
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801003e7:	89 d1                	mov    %edx,%ecx
801003e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // Reverse the string
    int start = 0;
    int end = i - 1;
    while (start < end) {
        char temp = str[start];
801003f0:	0f b6 34 03          	movzbl (%ebx,%eax,1),%esi
        str[start] = str[end];
801003f4:	0f b6 14 0b          	movzbl (%ebx,%ecx,1),%edx
801003f8:	88 14 03             	mov    %dl,(%ebx,%eax,1)
        str[end] = temp;
801003fb:	89 f2                	mov    %esi,%edx
        start++;
801003fd:	83 c0 01             	add    $0x1,%eax
        str[end] = temp;
80100400:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
        end--;
80100403:	83 e9 01             	sub    $0x1,%ecx
    while (start < end) {
80100406:	39 c8                	cmp    %ecx,%eax
80100408:	7c e6                	jl     801003f0 <itoa.part.0+0x70>
    }
}
8010040a:	83 c4 0c             	add    $0xc,%esp
8010040d:	5b                   	pop    %ebx
8010040e:	5e                   	pop    %esi
8010040f:	5f                   	pop    %edi
80100410:	5d                   	pop    %ebp
80100411:	c3                   	ret    
80100412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    str[i] = '\0';
80100418:	c6 06 00             	movb   $0x0,(%esi)
    while (start < end) {
8010041b:	85 c9                	test   %ecx,%ecx
8010041d:	75 d1                	jne    801003f0 <itoa.part.0+0x70>
}
8010041f:	83 c4 0c             	add    $0xc,%esp
80100422:	5b                   	pop    %ebx
80100423:	5e                   	pop    %esi
80100424:	5f                   	pop    %edi
80100425:	5d                   	pop    %ebp
80100426:	c3                   	ret    
80100427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010042e:	66 90                	xchg   %ax,%ax
    int isNegative = 0;
80100430:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80100437:	e9 6c ff ff ff       	jmp    801003a8 <itoa.part.0+0x28>
8010043c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100440 <isDigit>:
{
80100440:	55                   	push   %ebp
80100441:	89 e5                	mov    %esp,%ebp
  return(c>='0' && c<='9');
80100443:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}
80100447:	5d                   	pop    %ebp
  return(c>='0' && c<='9');
80100448:	83 e8 30             	sub    $0x30,%eax
8010044b:	3c 09                	cmp    $0x9,%al
8010044d:	0f 96 c0             	setbe  %al
80100450:	0f b6 c0             	movzbl %al,%eax
}
80100453:	c3                   	ret    
80100454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010045b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010045f:	90                   	nop

80100460 <panic>:
{
80100460:	55                   	push   %ebp
80100461:	89 e5                	mov    %esp,%ebp
80100463:	56                   	push   %esi
80100464:	53                   	push   %ebx
80100465:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100468:	fa                   	cli    
  cons.locking = 0;
80100469:	c7 05 f4 0a 11 80 00 	movl   $0x0,0x80110af4
80100470:	00 00 00 
  getcallerpcs(&s, pcs);
80100473:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100476:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100479:	e8 b2 35 00 00       	call   80103a30 <lapicid>
8010047e:	83 ec 08             	sub    $0x8,%esp
80100481:	50                   	push   %eax
80100482:	68 0d 83 10 80       	push   $0x8010830d
80100487:	e8 54 03 00 00       	call   801007e0 <cprintf>
  cprintf(s);
8010048c:	58                   	pop    %eax
8010048d:	ff 75 08             	push   0x8(%ebp)
80100490:	e8 4b 03 00 00       	call   801007e0 <cprintf>
  cprintf("\n");
80100495:	c7 04 24 77 8c 10 80 	movl   $0x80108c77,(%esp)
8010049c:	e8 3f 03 00 00       	call   801007e0 <cprintf>
  getcallerpcs(&s, pcs);
801004a1:	8d 45 08             	lea    0x8(%ebp),%eax
801004a4:	5a                   	pop    %edx
801004a5:	59                   	pop    %ecx
801004a6:	53                   	push   %ebx
801004a7:	50                   	push   %eax
801004a8:	e8 83 50 00 00       	call   80105530 <getcallerpcs>
  for(i=0; i<10; i++)
801004ad:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004b0:	83 ec 08             	sub    $0x8,%esp
801004b3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004b5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004b8:	68 21 83 10 80       	push   $0x80108321
801004bd:	e8 1e 03 00 00       	call   801007e0 <cprintf>
  for(i=0; i<10; i++)
801004c2:	83 c4 10             	add    $0x10,%esp
801004c5:	39 f3                	cmp    %esi,%ebx
801004c7:	75 e7                	jne    801004b0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004c9:	c7 05 fc 0a 11 80 01 	movl   $0x1,0x80110afc
801004d0:	00 00 00 
  for(;;)
801004d3:	eb fe                	jmp    801004d3 <panic+0x73>
801004d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801004e0 <consputc.part.0>:
consputc(int c)
801004e0:	55                   	push   %ebp
801004e1:	89 e5                	mov    %esp,%ebp
801004e3:	57                   	push   %edi
801004e4:	56                   	push   %esi
801004e5:	53                   	push   %ebx
801004e6:	89 c3                	mov    %eax,%ebx
801004e8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE) {
801004eb:	3d 00 01 00 00       	cmp    $0x100,%eax
801004f0:	0f 84 4a 01 00 00    	je     80100640 <consputc.part.0+0x160>
    uartputc(c);
801004f6:	83 ec 0c             	sub    $0xc,%esp
801004f9:	50                   	push   %eax
801004fa:	e8 f1 68 00 00       	call   80106df0 <uartputc>
801004ff:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100502:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 fa                	mov    %edi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100514:	89 f2                	mov    %esi,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 fa                	mov    %edi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 f2                	mov    %esi,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100528:	0f b6 c0             	movzbl %al,%eax
8010052b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010052d:	83 fb 0a             	cmp    $0xa,%ebx
80100530:	0f 84 f2 00 00 00    	je     80100628 <consputc.part.0+0x148>
  for (int i = pos - 1; i < pos + cap; i++)
80100536:	8b 3d f8 0a 11 80    	mov    0x80110af8,%edi
8010053c:	8d 34 38             	lea    (%eax,%edi,1),%esi
  else if(c == BACKSPACE) {
8010053f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100545:	0f 84 9d 00 00 00    	je     801005e8 <consputc.part.0+0x108>
  for (int i = pos + cap; i > pos; i--)
8010054b:	39 f0                	cmp    %esi,%eax
8010054d:	7d 1f                	jge    8010056e <consputc.part.0+0x8e>
8010054f:	8d 94 36 fe 7f 0b 80 	lea    -0x7ff48002(%esi,%esi,1),%edx
80100556:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010055d:	8d 76 00             	lea    0x0(%esi),%esi
    crt[i] = crt[i - 1];
80100560:	0f b7 0a             	movzwl (%edx),%ecx
  for (int i = pos + cap; i > pos; i--)
80100563:	83 ea 02             	sub    $0x2,%edx
    crt[i] = crt[i - 1];
80100566:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for (int i = pos + cap; i > pos; i--)
8010056a:	39 d6                	cmp    %edx,%esi
8010056c:	75 f2                	jne    80100560 <consputc.part.0+0x80>
    crt[pos] = (c&0xff) | 0x0700;  // black on white
8010056e:	0f b6 db             	movzbl %bl,%ebx
80100571:	80 cf 07             	or     $0x7,%bh
80100574:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010057b:	80 
    pos++;
8010057c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(pos < 0 || pos > 25 * 80)
8010057f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100585:	0f 8f 2f 01 00 00    	jg     801006ba <consputc.part.0+0x1da>
  if((pos / 80) >= 24) {  // Scroll up.
8010058b:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100591:	0f 8f d9 00 00 00    	jg     80100670 <consputc.part.0+0x190>
  outb(CRTPORT + 1, pos >> 8);
80100597:	0f b6 c7             	movzbl %bh,%eax
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
8010059a:	8b 3d f8 0a 11 80    	mov    0x80110af8,%edi
  outb(CRTPORT + 1, pos);
801005a0:	89 de                	mov    %ebx,%esi
  outb(CRTPORT + 1, pos >> 8);
801005a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
801005a5:	01 df                	add    %ebx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005a7:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801005ac:	b8 0e 00 00 00       	mov    $0xe,%eax
801005b1:	89 da                	mov    %ebx,%edx
801005b3:	ee                   	out    %al,(%dx)
801005b4:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801005b9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801005bd:	89 ca                	mov    %ecx,%edx
801005bf:	ee                   	out    %al,(%dx)
801005c0:	b8 0f 00 00 00       	mov    $0xf,%eax
801005c5:	89 da                	mov    %ebx,%edx
801005c7:	ee                   	out    %al,(%dx)
801005c8:	89 f0                	mov    %esi,%eax
801005ca:	89 ca                	mov    %ecx,%edx
801005cc:	ee                   	out    %al,(%dx)
801005cd:	b8 20 07 00 00       	mov    $0x720,%eax
801005d2:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
801005d9:	80 
}
801005da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005dd:	5b                   	pop    %ebx
801005de:	5e                   	pop    %esi
801005df:	5f                   	pop    %edi
801005e0:	5d                   	pop    %ebp
801005e1:	c3                   	ret    
801005e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int i = pos - 1; i < pos + cap; i++)
801005e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
801005eb:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
801005f2:	89 d9                	mov    %ebx,%ecx
801005f4:	85 ff                	test   %edi,%edi
801005f6:	78 1c                	js     80100614 <consputc.part.0+0x134>
801005f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801005ff:	90                   	nop
    crt[i] = crt[i+1];
80100600:	0f b7 02             	movzwl (%edx),%eax
  for (int i = pos - 1; i < pos + cap; i++)
80100603:	83 c1 01             	add    $0x1,%ecx
80100606:	83 c2 02             	add    $0x2,%edx
    crt[i] = crt[i+1];
80100609:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for (int i = pos - 1; i < pos + cap; i++)
8010060d:	39 f1                	cmp    %esi,%ecx
8010060f:	7c ef                	jl     80100600 <consputc.part.0+0x120>
80100611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0)
80100614:	85 c0                	test   %eax,%eax
80100616:	0f 85 63 ff ff ff    	jne    8010057f <consputc.part.0+0x9f>
8010061c:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100620:	31 f6                	xor    %esi,%esi
80100622:	eb 83                	jmp    801005a7 <consputc.part.0+0xc7>
80100624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100628:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010062d:	f7 e2                	mul    %edx
8010062f:	c1 ea 06             	shr    $0x6,%edx
80100632:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100635:	c1 e0 04             	shl    $0x4,%eax
80100638:	8d 58 50             	lea    0x50(%eax),%ebx
8010063b:	e9 3f ff ff ff       	jmp    8010057f <consputc.part.0+0x9f>
    uartputc('\b');
80100640:	83 ec 0c             	sub    $0xc,%esp
80100643:	6a 08                	push   $0x8
80100645:	e8 a6 67 00 00       	call   80106df0 <uartputc>
    uartputc(' ');
8010064a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100651:	e8 9a 67 00 00       	call   80106df0 <uartputc>
    uartputc('\b');
80100656:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010065d:	e8 8e 67 00 00       	call   80106df0 <uartputc>
80100662:	83 c4 10             	add    $0x10,%esp
80100665:	e9 98 fe ff ff       	jmp    80100502 <consputc.part.0+0x22>
8010066a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100670:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100673:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100676:	68 60 0e 00 00       	push   $0xe60
  outb(CRTPORT + 1, pos);
8010067b:	89 fe                	mov    %edi,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010067d:	68 a0 80 0b 80       	push   $0x800b80a0
80100682:	68 00 80 0b 80       	push   $0x800b8000
80100687:	e8 b4 51 00 00       	call   80105840 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010068c:	b8 80 07 00 00       	mov    $0x780,%eax
80100691:	83 c4 0c             	add    $0xc,%esp
80100694:	29 f8                	sub    %edi,%eax
80100696:	01 c0                	add    %eax,%eax
80100698:	50                   	push   %eax
80100699:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801006a0:	6a 00                	push   $0x0
801006a2:	50                   	push   %eax
801006a3:	e8 f8 50 00 00       	call   801057a0 <memset>
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
801006a8:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801006ac:	03 3d f8 0a 11 80    	add    0x80110af8,%edi
801006b2:	83 c4 10             	add    $0x10,%esp
801006b5:	e9 ed fe ff ff       	jmp    801005a7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801006ba:	83 ec 0c             	sub    $0xc,%esp
801006bd:	68 25 83 10 80       	push   $0x80108325
801006c2:	e8 99 fd ff ff       	call   80100460 <panic>
801006c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006ce:	66 90                	xchg   %ax,%ax

801006d0 <consolewrite>:
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
801006d9:	ff 75 08             	push   0x8(%ebp)
{
801006dc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801006df:	e8 bc 22 00 00       	call   801029a0 <iunlock>
  acquire(&cons.lock);
801006e4:	c7 04 24 c0 0a 11 80 	movl   $0x80110ac0,(%esp)
801006eb:	e8 f0 4f 00 00       	call   801056e0 <acquire>
  for(i = 0; i < n; i++)
801006f0:	83 c4 10             	add    $0x10,%esp
801006f3:	85 f6                	test   %esi,%esi
801006f5:	7e 25                	jle    8010071c <consolewrite+0x4c>
801006f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked) {
801006fd:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
    consputc(buf[i] & 0xff);
80100703:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked) {
80100706:	85 d2                	test   %edx,%edx
80100708:	74 06                	je     80100710 <consolewrite+0x40>
  asm volatile("cli");
8010070a:	fa                   	cli    
    for(;;)
8010070b:	eb fe                	jmp    8010070b <consolewrite+0x3b>
8010070d:	8d 76 00             	lea    0x0(%esi),%esi
80100710:	e8 cb fd ff ff       	call   801004e0 <consputc.part.0>
  for(i = 0; i < n; i++)
80100715:	83 c3 01             	add    $0x1,%ebx
80100718:	39 df                	cmp    %ebx,%edi
8010071a:	75 e1                	jne    801006fd <consolewrite+0x2d>
  release(&cons.lock);
8010071c:	83 ec 0c             	sub    $0xc,%esp
8010071f:	68 c0 0a 11 80       	push   $0x80110ac0
80100724:	e8 57 4f 00 00       	call   80105680 <release>
  ilock(ip);
80100729:	58                   	pop    %eax
8010072a:	ff 75 08             	push   0x8(%ebp)
8010072d:	e8 8e 21 00 00       	call   801028c0 <ilock>
}
80100732:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100735:	89 f0                	mov    %esi,%eax
80100737:	5b                   	pop    %ebx
80100738:	5e                   	pop    %esi
80100739:	5f                   	pop    %edi
8010073a:	5d                   	pop    %ebp
8010073b:	c3                   	ret    
8010073c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100740 <printint>:
{
80100740:	55                   	push   %ebp
80100741:	89 e5                	mov    %esp,%ebp
80100743:	57                   	push   %edi
80100744:	56                   	push   %esi
80100745:	53                   	push   %ebx
80100746:	83 ec 2c             	sub    $0x2c,%esp
80100749:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010074c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010074f:	85 c9                	test   %ecx,%ecx
80100751:	74 04                	je     80100757 <printint+0x17>
80100753:	85 c0                	test   %eax,%eax
80100755:	78 6d                	js     801007c4 <printint+0x84>
    x = xx;
80100757:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010075e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100760:	31 db                	xor    %ebx,%ebx
80100762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100768:	89 c8                	mov    %ecx,%eax
8010076a:	31 d2                	xor    %edx,%edx
8010076c:	89 de                	mov    %ebx,%esi
8010076e:	89 cf                	mov    %ecx,%edi
80100770:	f7 75 d4             	divl   -0x2c(%ebp)
80100773:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100776:	0f b6 92 90 83 10 80 	movzbl -0x7fef7c70(%edx),%edx
  }while((x /= base) != 0);
8010077d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010077f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100783:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100786:	73 e0                	jae    80100768 <printint+0x28>
  if(sign)
80100788:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010078b:	85 c9                	test   %ecx,%ecx
8010078d:	74 0c                	je     8010079b <printint+0x5b>
    buf[i++] = '-';
8010078f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100794:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100796:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010079b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010079f:	0f be c2             	movsbl %dl,%eax
  if(panicked) {
801007a2:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
801007a8:	85 d2                	test   %edx,%edx
801007aa:	74 04                	je     801007b0 <printint+0x70>
801007ac:	fa                   	cli    
    for(;;)
801007ad:	eb fe                	jmp    801007ad <printint+0x6d>
801007af:	90                   	nop
801007b0:	e8 2b fd ff ff       	call   801004e0 <consputc.part.0>
  while(--i >= 0)
801007b5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801007b8:	39 c3                	cmp    %eax,%ebx
801007ba:	74 0e                	je     801007ca <printint+0x8a>
    consputc(buf[i]);
801007bc:	0f be 03             	movsbl (%ebx),%eax
801007bf:	83 eb 01             	sub    $0x1,%ebx
801007c2:	eb de                	jmp    801007a2 <printint+0x62>
    x = -xx;
801007c4:	f7 d8                	neg    %eax
801007c6:	89 c1                	mov    %eax,%ecx
801007c8:	eb 96                	jmp    80100760 <printint+0x20>
}
801007ca:	83 c4 2c             	add    $0x2c,%esp
801007cd:	5b                   	pop    %ebx
801007ce:	5e                   	pop    %esi
801007cf:	5f                   	pop    %edi
801007d0:	5d                   	pop    %ebp
801007d1:	c3                   	ret    
801007d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801007e0 <cprintf>:
{
801007e0:	55                   	push   %ebp
801007e1:	89 e5                	mov    %esp,%ebp
801007e3:	57                   	push   %edi
801007e4:	56                   	push   %esi
801007e5:	53                   	push   %ebx
801007e6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007e9:	a1 f4 0a 11 80       	mov    0x80110af4,%eax
801007ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801007f1:	85 c0                	test   %eax,%eax
801007f3:	0f 85 27 01 00 00    	jne    80100920 <cprintf+0x140>
  if (fmt == 0)
801007f9:	8b 75 08             	mov    0x8(%ebp),%esi
801007fc:	85 f6                	test   %esi,%esi
801007fe:	0f 84 ac 01 00 00    	je     801009b0 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100804:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100807:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080a:	31 db                	xor    %ebx,%ebx
8010080c:	85 c0                	test   %eax,%eax
8010080e:	74 56                	je     80100866 <cprintf+0x86>
    if(c != '%'){
80100810:	83 f8 25             	cmp    $0x25,%eax
80100813:	0f 85 cf 00 00 00    	jne    801008e8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
80100819:	83 c3 01             	add    $0x1,%ebx
8010081c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100820:	85 d2                	test   %edx,%edx
80100822:	74 42                	je     80100866 <cprintf+0x86>
    switch(c){
80100824:	83 fa 70             	cmp    $0x70,%edx
80100827:	0f 84 90 00 00 00    	je     801008bd <cprintf+0xdd>
8010082d:	7f 51                	jg     80100880 <cprintf+0xa0>
8010082f:	83 fa 25             	cmp    $0x25,%edx
80100832:	0f 84 c0 00 00 00    	je     801008f8 <cprintf+0x118>
80100838:	83 fa 64             	cmp    $0x64,%edx
8010083b:	0f 85 f4 00 00 00    	jne    80100935 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100841:	8d 47 04             	lea    0x4(%edi),%eax
80100844:	b9 01 00 00 00       	mov    $0x1,%ecx
80100849:	ba 0a 00 00 00       	mov    $0xa,%edx
8010084e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100851:	8b 07                	mov    (%edi),%eax
80100853:	e8 e8 fe ff ff       	call   80100740 <printint>
80100858:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010085b:	83 c3 01             	add    $0x1,%ebx
8010085e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100862:	85 c0                	test   %eax,%eax
80100864:	75 aa                	jne    80100810 <cprintf+0x30>
  if(locking)
80100866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100869:	85 c0                	test   %eax,%eax
8010086b:	0f 85 22 01 00 00    	jne    80100993 <cprintf+0x1b3>
}
80100871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100874:	5b                   	pop    %ebx
80100875:	5e                   	pop    %esi
80100876:	5f                   	pop    %edi
80100877:	5d                   	pop    %ebp
80100878:	c3                   	ret    
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100880:	83 fa 73             	cmp    $0x73,%edx
80100883:	75 33                	jne    801008b8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100885:	8d 47 04             	lea    0x4(%edi),%eax
80100888:	8b 3f                	mov    (%edi),%edi
8010088a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010088d:	85 ff                	test   %edi,%edi
8010088f:	0f 84 e3 00 00 00    	je     80100978 <cprintf+0x198>
      for(; *s; s++)
80100895:	0f be 07             	movsbl (%edi),%eax
80100898:	84 c0                	test   %al,%al
8010089a:	0f 84 08 01 00 00    	je     801009a8 <cprintf+0x1c8>
  if(panicked) {
801008a0:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
801008a6:	85 d2                	test   %edx,%edx
801008a8:	0f 84 b2 00 00 00    	je     80100960 <cprintf+0x180>
801008ae:	fa                   	cli    
    for(;;)
801008af:	eb fe                	jmp    801008af <cprintf+0xcf>
801008b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801008b8:	83 fa 78             	cmp    $0x78,%edx
801008bb:	75 78                	jne    80100935 <cprintf+0x155>
      printint(*argp++, 16, 0);
801008bd:	8d 47 04             	lea    0x4(%edi),%eax
801008c0:	31 c9                	xor    %ecx,%ecx
801008c2:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008c7:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801008ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008cd:	8b 07                	mov    (%edi),%eax
801008cf:	e8 6c fe ff ff       	call   80100740 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008d4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801008d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008db:	85 c0                	test   %eax,%eax
801008dd:	0f 85 2d ff ff ff    	jne    80100810 <cprintf+0x30>
801008e3:	eb 81                	jmp    80100866 <cprintf+0x86>
801008e5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
801008e8:	8b 0d fc 0a 11 80    	mov    0x80110afc,%ecx
801008ee:	85 c9                	test   %ecx,%ecx
801008f0:	74 14                	je     80100906 <cprintf+0x126>
801008f2:	fa                   	cli    
    for(;;)
801008f3:	eb fe                	jmp    801008f3 <cprintf+0x113>
801008f5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
801008f8:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
801008fd:	85 c0                	test   %eax,%eax
801008ff:	75 6c                	jne    8010096d <cprintf+0x18d>
80100901:	b8 25 00 00 00       	mov    $0x25,%eax
80100906:	e8 d5 fb ff ff       	call   801004e0 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010090b:	83 c3 01             	add    $0x1,%ebx
8010090e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100912:	85 c0                	test   %eax,%eax
80100914:	0f 85 f6 fe ff ff    	jne    80100810 <cprintf+0x30>
8010091a:	e9 47 ff ff ff       	jmp    80100866 <cprintf+0x86>
8010091f:	90                   	nop
    acquire(&cons.lock);
80100920:	83 ec 0c             	sub    $0xc,%esp
80100923:	68 c0 0a 11 80       	push   $0x80110ac0
80100928:	e8 b3 4d 00 00       	call   801056e0 <acquire>
8010092d:	83 c4 10             	add    $0x10,%esp
80100930:	e9 c4 fe ff ff       	jmp    801007f9 <cprintf+0x19>
  if(panicked) {
80100935:	8b 0d fc 0a 11 80    	mov    0x80110afc,%ecx
8010093b:	85 c9                	test   %ecx,%ecx
8010093d:	75 31                	jne    80100970 <cprintf+0x190>
8010093f:	b8 25 00 00 00       	mov    $0x25,%eax
80100944:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100947:	e8 94 fb ff ff       	call   801004e0 <consputc.part.0>
8010094c:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
80100952:	85 d2                	test   %edx,%edx
80100954:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100957:	74 2e                	je     80100987 <cprintf+0x1a7>
80100959:	fa                   	cli    
    for(;;)
8010095a:	eb fe                	jmp    8010095a <cprintf+0x17a>
8010095c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100960:	e8 7b fb ff ff       	call   801004e0 <consputc.part.0>
      for(; *s; s++)
80100965:	83 c7 01             	add    $0x1,%edi
80100968:	e9 28 ff ff ff       	jmp    80100895 <cprintf+0xb5>
8010096d:	fa                   	cli    
    for(;;)
8010096e:	eb fe                	jmp    8010096e <cprintf+0x18e>
80100970:	fa                   	cli    
80100971:	eb fe                	jmp    80100971 <cprintf+0x191>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
        s = "(null)";
80100978:	bf 38 83 10 80       	mov    $0x80108338,%edi
      for(; *s; s++)
8010097d:	b8 28 00 00 00       	mov    $0x28,%eax
80100982:	e9 19 ff ff ff       	jmp    801008a0 <cprintf+0xc0>
80100987:	89 d0                	mov    %edx,%eax
80100989:	e8 52 fb ff ff       	call   801004e0 <consputc.part.0>
8010098e:	e9 c8 fe ff ff       	jmp    8010085b <cprintf+0x7b>
    release(&cons.lock);
80100993:	83 ec 0c             	sub    $0xc,%esp
80100996:	68 c0 0a 11 80       	push   $0x80110ac0
8010099b:	e8 e0 4c 00 00       	call   80105680 <release>
801009a0:	83 c4 10             	add    $0x10,%esp
}
801009a3:	e9 c9 fe ff ff       	jmp    80100871 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801009a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801009ab:	e9 ab fe ff ff       	jmp    8010085b <cprintf+0x7b>
    panic("null fmt");
801009b0:	83 ec 0c             	sub    $0xc,%esp
801009b3:	68 3f 83 10 80       	push   $0x8010833f
801009b8:	e8 a3 fa ff ff       	call   80100460 <panic>
801009bd:	8d 76 00             	lea    0x0(%esi),%esi

801009c0 <shift_forward_crt>:
{
801009c0:	55                   	push   %ebp
  for (int i = pos + cap; i > pos; i--)
801009c1:	a1 f8 0a 11 80       	mov    0x80110af8,%eax
{
801009c6:	89 e5                	mov    %esp,%ebp
801009c8:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i = pos + cap; i > pos; i--)
801009cb:	01 d0                	add    %edx,%eax
801009cd:	39 c2                	cmp    %eax,%edx
801009cf:	7d 1d                	jge    801009ee <shift_forward_crt+0x2e>
801009d1:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
801009d8:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
801009df:	90                   	nop
    crt[i] = crt[i - 1];
801009e0:	0f b7 10             	movzwl (%eax),%edx
  for (int i = pos + cap; i > pos; i--)
801009e3:	83 e8 02             	sub    $0x2,%eax
    crt[i] = crt[i - 1];
801009e6:	66 89 50 04          	mov    %dx,0x4(%eax)
  for (int i = pos + cap; i > pos; i--)
801009ea:	39 c8                	cmp    %ecx,%eax
801009ec:	75 f2                	jne    801009e0 <shift_forward_crt+0x20>
}
801009ee:	5d                   	pop    %ebp
801009ef:	c3                   	ret    

801009f0 <shift_back_crt>:
{
801009f0:	55                   	push   %ebp
  for (int i = pos - 1; i < pos + cap; i++)
801009f1:	8b 0d f8 0a 11 80    	mov    0x80110af8,%ecx
{
801009f7:	89 e5                	mov    %esp,%ebp
801009f9:	53                   	push   %ebx
801009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for (int i = pos - 1; i < pos + cap; i++)
801009fd:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80100a00:	85 c9                	test   %ecx,%ecx
80100a02:	78 1d                	js     80100a21 <shift_back_crt+0x31>
80100a04:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a07:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
80100a0e:	66 90                	xchg   %ax,%ax
    crt[i] = crt[i+1];
80100a10:	0f b7 08             	movzwl (%eax),%ecx
  for (int i = pos - 1; i < pos + cap; i++)
80100a13:	83 c2 01             	add    $0x1,%edx
80100a16:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i+1];
80100a19:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for (int i = pos - 1; i < pos + cap; i++)
80100a1d:	39 da                	cmp    %ebx,%edx
80100a1f:	7c ef                	jl     80100a10 <shift_back_crt+0x20>
}
80100a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a24:	c9                   	leave  
80100a25:	c3                   	ret    
80100a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <pow>:
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	53                   	push   %ebx
80100a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = 0; i < power; i++)
80100a3a:	85 c9                	test   %ecx,%ecx
80100a3c:	7e 22                	jle    80100a60 <pow+0x30>
80100a3e:	31 c0                	xor    %eax,%eax
  int result = 1;
80100a40:	ba 01 00 00 00       	mov    $0x1,%edx
80100a45:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = 0; i < power; i++)
80100a48:	83 c0 01             	add    $0x1,%eax
    result = result * base;
80100a4b:	0f af d3             	imul   %ebx,%edx
  for (int i = 0; i < power; i++)
80100a4e:	39 c1                	cmp    %eax,%ecx
80100a50:	75 f6                	jne    80100a48 <pow+0x18>
}
80100a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a55:	89 d0                	mov    %edx,%eax
80100a57:	c9                   	leave  
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int result = 1;
80100a60:	ba 01 00 00 00       	mov    $0x1,%edx
}
80100a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a68:	c9                   	leave  
80100a69:	89 d0                	mov    %edx,%eax
80100a6b:	c3                   	ret    
80100a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a70 <makeChangeInPos>:
{
80100a70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a71:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a76:	89 e5                	mov    %esp,%ebp
80100a78:	56                   	push   %esi
80100a79:	be d4 03 00 00       	mov    $0x3d4,%esi
80100a7e:	53                   	push   %ebx
80100a7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100a82:	89 f2                	mov    %esi,%edx
80100a84:	ee                   	out    %al,(%dx)
80100a85:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
80100a8a:	89 c8                	mov    %ecx,%eax
80100a8c:	c1 f8 08             	sar    $0x8,%eax
80100a8f:	89 da                	mov    %ebx,%edx
80100a91:	ee                   	out    %al,(%dx)
80100a92:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a97:	89 f2                	mov    %esi,%edx
80100a99:	ee                   	out    %al,(%dx)
80100a9a:	89 c8                	mov    %ecx,%eax
80100a9c:	89 da                	mov    %ebx,%edx
80100a9e:	ee                   	out    %al,(%dx)
}
80100a9f:	5b                   	pop    %ebx
80100aa0:	5e                   	pop    %esi
80100aa1:	5d                   	pop    %ebp
80100aa2:	c3                   	ret    
80100aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ab0 <getLastCommand>:
{
80100ab0:	55                   	push   %ebp
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100ab1:	80 3d 80 fe 10 80 00 	cmpb   $0x0,0x8010fe80
{
80100ab8:	89 e5                	mov    %esp,%ebp
80100aba:	56                   	push   %esi
80100abb:	8b 55 08             	mov    0x8(%ebp),%edx
80100abe:	53                   	push   %ebx
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100abf:	0f 84 93 00 00 00    	je     80100b58 <getLastCommand+0xa8>
80100ac5:	31 f6                	xor    %esi,%esi
80100ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ace:	66 90                	xchg   %ax,%ax
80100ad0:	89 f0                	mov    %esi,%eax
80100ad2:	83 c6 01             	add    $0x1,%esi
80100ad5:	80 be 80 fe 10 80 00 	cmpb   $0x0,-0x7fef0180(%esi)
80100adc:	75 f2                	jne    80100ad0 <getLastCommand+0x20>
    if (input.buf[k] == '\n')
80100ade:	80 b8 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%eax)
80100ae5:	74 17                	je     80100afe <getLastCommand+0x4e>
80100ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aee:	66 90                	xchg   %ax,%ax
  for (k = i-1; (k != -1); k--)
80100af0:	83 e8 01             	sub    $0x1,%eax
80100af3:	72 17                	jb     80100b0c <getLastCommand+0x5c>
    if (input.buf[k] == '\n')
80100af5:	80 b8 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%eax)
80100afc:	75 f2                	jne    80100af0 <getLastCommand+0x40>
      if (numberOfIgnore == 0)
80100afe:	85 d2                	test   %edx,%edx
80100b00:	74 4e                	je     80100b50 <getLastCommand+0xa0>
        numberOfIgnore--;
80100b02:	83 ea 01             	sub    $0x1,%edx
80100b05:	89 c6                	mov    %eax,%esi
  for (k = i-1; (k != -1); k--)
80100b07:	83 e8 01             	sub    $0x1,%eax
80100b0a:	73 e9                	jae    80100af5 <getLastCommand+0x45>
80100b0c:	31 d2                	xor    %edx,%edx
  for (h = k+1; h < i; h++)
80100b0e:	39 f2                	cmp    %esi,%edx
80100b10:	7d 46                	jge    80100b58 <getLastCommand+0xa8>
    result[h-k-1] = input.buf[h];
80100b12:	89 c3                	mov    %eax,%ebx
80100b14:	f7 db                	neg    %ebx
80100b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b1d:	8d 76 00             	lea    0x0(%esi),%esi
80100b20:	0f b6 8a 80 fe 10 80 	movzbl -0x7fef0180(%edx),%ecx
80100b27:	88 8c 13 3f 0a 11 80 	mov    %cl,-0x7feef5c1(%ebx,%edx,1)
  for (h = k+1; h < i; h++)
80100b2e:	83 c2 01             	add    $0x1,%edx
80100b31:	39 f2                	cmp    %esi,%edx
80100b33:	75 eb                	jne    80100b20 <getLastCommand+0x70>
  result[h-k-1] = '\0';
80100b35:	29 c2                	sub    %eax,%edx
}
80100b37:	5b                   	pop    %ebx
80100b38:	b8 40 0a 11 80       	mov    $0x80110a40,%eax
80100b3d:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100b3e:	83 ea 01             	sub    $0x1,%edx
}
80100b41:	5d                   	pop    %ebp
  result[h-k-1] = '\0';
80100b42:	c6 82 40 0a 11 80 00 	movb   $0x0,-0x7feef5c0(%edx)
}
80100b49:	c3                   	ret    
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int h = k + 1;
80100b50:	8d 50 01             	lea    0x1(%eax),%edx
80100b53:	eb b9                	jmp    80100b0e <getLastCommand+0x5e>
80100b55:	8d 76 00             	lea    0x0(%esi),%esi
  for (h = k+1; h < i; h++)
80100b58:	31 d2                	xor    %edx,%edx
}
80100b5a:	5b                   	pop    %ebx
80100b5b:	b8 40 0a 11 80       	mov    $0x80110a40,%eax
80100b60:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100b61:	c6 82 40 0a 11 80 00 	movb   $0x0,-0x7feef5c0(%edx)
}
80100b68:	5d                   	pop    %ebp
80100b69:	c3                   	ret    
80100b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b70 <addNewCommandToHistory>:
{
80100b70:	55                   	push   %ebp
80100b71:	89 e5                	mov    %esp,%ebp
80100b73:	57                   	push   %edi
80100b74:	56                   	push   %esi
  for (int i = 0; i < HISTORYSIZE; i++)
80100b75:	31 f6                	xor    %esi,%esi
{
80100b77:	53                   	push   %ebx
80100b78:	83 ec 1c             	sub    $0x1c,%esp
80100b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b7f:	90                   	nop
    if (historyBuf[i][0] == '\0')
80100b80:	89 f0                	mov    %esi,%eax
80100b82:	c1 e0 07             	shl    $0x7,%eax
80100b85:	80 b8 40 05 11 80 00 	cmpb   $0x0,-0x7feefac0(%eax)
80100b8c:	74 64                	je     80100bf2 <addNewCommandToHistory+0x82>
  for (int i = 0; i < HISTORYSIZE; i++)
80100b8e:	83 c6 01             	add    $0x1,%esi
80100b91:	83 fe 0a             	cmp    $0xa,%esi
80100b94:	75 ea                	jne    80100b80 <addNewCommandToHistory+0x10>
  int freeIndex = HISTORYSIZE-1;
80100b96:	be 09 00 00 00       	mov    $0x9,%esi
80100b9b:	89 f3                	mov    %esi,%ebx
80100b9d:	c1 e3 07             	shl    $0x7,%ebx
80100ba0:	8d 7b 80             	lea    -0x80(%ebx),%edi
80100ba3:	89 f9                	mov    %edi,%ecx
80100ba5:	8d 76 00             	lea    0x0(%esi),%esi
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100ba8:	0f b6 91 40 05 11 80 	movzbl -0x7feefac0(%ecx),%edx
80100baf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80100bb2:	31 c0                	xor    %eax,%eax
80100bb4:	83 ee 01             	sub    $0x1,%esi
80100bb7:	84 d2                	test   %dl,%dl
80100bb9:	74 1b                	je     80100bd6 <addNewCommandToHistory+0x66>
80100bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bbf:	90                   	nop
      historyBuf[i][j] = historyBuf[i-1][j];
80100bc0:	88 94 03 40 05 11 80 	mov    %dl,-0x7feefac0(%ebx,%eax,1)
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100bc7:	83 c0 01             	add    $0x1,%eax
80100bca:	0f b6 94 01 40 05 11 	movzbl -0x7feefac0(%ecx,%eax,1),%edx
80100bd1:	80 
80100bd2:	84 d2                	test   %dl,%dl
80100bd4:	75 ea                	jne    80100bc0 <addNewCommandToHistory+0x50>
    historyBuf[i][j] = '\0';
80100bd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (int i = freeIndex; i >= 1; i--)
80100bd9:	89 fb                	mov    %edi,%ebx
80100bdb:	83 c1 80             	add    $0xffffff80,%ecx
    historyBuf[i][j] = '\0';
80100bde:	c1 e2 07             	shl    $0x7,%edx
80100be1:	c6 84 10 40 05 11 80 	movb   $0x0,-0x7feefac0(%eax,%edx,1)
80100be8:	00 
  for (int i = freeIndex; i >= 1; i--)
80100be9:	85 f6                	test   %esi,%esi
80100beb:	74 13                	je     80100c00 <addNewCommandToHistory+0x90>
80100bed:	83 c7 80             	add    $0xffffff80,%edi
80100bf0:	eb b6                	jmp    80100ba8 <addNewCommandToHistory+0x38>
80100bf2:	85 f6                	test   %esi,%esi
80100bf4:	75 a5                	jne    80100b9b <addNewCommandToHistory+0x2b>
80100bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bfd:	8d 76 00             	lea    0x0(%esi),%esi
  char* res = getLastCommand(0);
80100c00:	83 ec 0c             	sub    $0xc,%esp
80100c03:	6a 00                	push   $0x0
80100c05:	e8 a6 fe ff ff       	call   80100ab0 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100c0a:	83 c4 10             	add    $0x10,%esp
80100c0d:	31 d2                	xor    %edx,%edx
80100c0f:	0f b6 08             	movzbl (%eax),%ecx
80100c12:	84 c9                	test   %cl,%cl
80100c14:	74 1b                	je     80100c31 <addNewCommandToHistory+0xc1>
80100c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c1d:	8d 76 00             	lea    0x0(%esi),%esi
    historyBuf[0][i] = res[i];
80100c20:	88 8a 40 05 11 80    	mov    %cl,-0x7feefac0(%edx)
  for (i = 0; res[i] != '\0'; i++)
80100c26:	83 c2 01             	add    $0x1,%edx
80100c29:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100c2d:	84 c9                	test   %cl,%cl
80100c2f:	75 ef                	jne    80100c20 <addNewCommandToHistory+0xb0>
  if (historyCurrentSize <= HISTORYSIZE)
80100c31:	a1 24 05 11 80       	mov    0x80110524,%eax
  historyBuf[0][i] = '\0';
80100c36:	c6 82 40 05 11 80 00 	movb   $0x0,-0x7feefac0(%edx)
  if (historyCurrentSize <= HISTORYSIZE)
80100c3d:	83 f8 0a             	cmp    $0xa,%eax
80100c40:	7f 08                	jg     80100c4a <addNewCommandToHistory+0xda>
    historyCurrentSize = historyCurrentSize + 1;
80100c42:	83 c0 01             	add    $0x1,%eax
80100c45:	a3 24 05 11 80       	mov    %eax,0x80110524
}
80100c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c4d:	5b                   	pop    %ebx
80100c4e:	5e                   	pop    %esi
80100c4f:	5f                   	pop    %edi
80100c50:	5d                   	pop    %ebp
80100c51:	c3                   	ret    
80100c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100c60 <makeBufferEmpty>:
{
80100c60:	55                   	push   %ebp
80100c61:	89 e5                	mov    %esp,%ebp
80100c63:	53                   	push   %ebx
80100c64:	83 ec 10             	sub    $0x10,%esp
  char* lastCommand = getLastCommand(0);
80100c67:	6a 00                	push   $0x0
80100c69:	e8 42 fe ff ff       	call   80100ab0 <getLastCommand>
80100c6e:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < INPUT_BUF; i++)
80100c71:	31 d2                	xor    %edx,%edx
80100c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c77:	90                   	nop
    input.buf[i] = '\0';
80100c78:	c6 82 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%edx)
  for (int i = 0; i < INPUT_BUF; i++)
80100c7f:	83 c2 01             	add    $0x1,%edx
80100c82:	81 fa 80 00 00 00    	cmp    $0x80,%edx
80100c88:	75 ee                	jne    80100c78 <makeBufferEmpty+0x18>
  for (i = 0; lastCommand[i] != '\0'; i++)
80100c8a:	0f b6 08             	movzbl (%eax),%ecx
80100c8d:	84 c9                	test   %cl,%cl
80100c8f:	74 25                	je     80100cb6 <makeBufferEmpty+0x56>
80100c91:	31 d2                	xor    %edx,%edx
80100c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c97:	90                   	nop
    input.buf[i] = lastCommand[i];
80100c98:	88 8a 80 fe 10 80    	mov    %cl,-0x7fef0180(%edx)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100c9e:	83 c2 01             	add    $0x1,%edx
80100ca1:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100ca5:	89 d3                	mov    %edx,%ebx
80100ca7:	84 c9                	test   %cl,%cl
80100ca9:	75 ed                	jne    80100c98 <makeBufferEmpty+0x38>
  input.e = i;
80100cab:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
}
80100cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cb4:	c9                   	leave  
80100cb5:	c3                   	ret    
  for (i = 0; lastCommand[i] != '\0'; i++)
80100cb6:	31 db                	xor    %ebx,%ebx
  input.e = i;
80100cb8:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
}
80100cbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cc1:	c9                   	leave  
80100cc2:	c3                   	ret    
80100cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100cd0 <checkBufferNeedEmpty>:
  for (int i = 0; input.buf[i] != '\0'; i++)
80100cd0:	31 c0                	xor    %eax,%eax
80100cd2:	80 3d 80 fe 10 80 00 	cmpb   $0x0,0x8010fe80
80100cd9:	75 0a                	jne    80100ce5 <checkBufferNeedEmpty+0x15>
80100cdb:	eb 1a                	jmp    80100cf7 <checkBufferNeedEmpty+0x27>
80100cdd:	8d 76 00             	lea    0x0(%esi),%esi
    if (i > INPUT_BUF-3)
80100ce0:	83 f8 7e             	cmp    $0x7e,%eax
80100ce3:	74 0d                	je     80100cf2 <checkBufferNeedEmpty+0x22>
  for (int i = 0; input.buf[i] != '\0'; i++)
80100ce5:	83 c0 01             	add    $0x1,%eax
80100ce8:	80 b8 80 fe 10 80 00 	cmpb   $0x0,-0x7fef0180(%eax)
80100cef:	75 ef                	jne    80100ce0 <checkBufferNeedEmpty+0x10>
}
80100cf1:	c3                   	ret    
      makeBufferEmpty();
80100cf2:	e9 69 ff ff ff       	jmp    80100c60 <makeBufferEmpty>
80100cf7:	c3                   	ret    
80100cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cff:	90                   	nop

80100d00 <putLastCommandBuf>:
{
80100d00:	55                   	push   %ebp
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100d01:	31 c0                	xor    %eax,%eax
80100d03:	80 3d 80 fe 10 80 00 	cmpb   $0x0,0x8010fe80
{
80100d0a:	89 e5                	mov    %esp,%ebp
80100d0c:	53                   	push   %ebx
80100d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100d10:	74 76                	je     80100d88 <putLastCommandBuf+0x88>
80100d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d18:	89 c2                	mov    %eax,%edx
80100d1a:	83 c0 01             	add    $0x1,%eax
80100d1d:	80 b8 80 fe 10 80 00 	cmpb   $0x0,-0x7fef0180(%eax)
80100d24:	75 f2                	jne    80100d18 <putLastCommandBuf+0x18>
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
80100d26:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100d2d:	75 0e                	jne    80100d3d <putLastCommandBuf+0x3d>
80100d2f:	eb 1a                	jmp    80100d4b <putLastCommandBuf+0x4b>
80100d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d38:	83 fa ff             	cmp    $0xffffffff,%edx
80100d3b:	74 43                	je     80100d80 <putLastCommandBuf+0x80>
80100d3d:	89 d0                	mov    %edx,%eax
80100d3f:	83 ea 01             	sub    $0x1,%edx
80100d42:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100d49:	75 ed                	jne    80100d38 <putLastCommandBuf+0x38>
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100d4b:	0f b6 0b             	movzbl (%ebx),%ecx
80100d4e:	84 c9                	test   %cl,%cl
80100d50:	74 18                	je     80100d6a <putLastCommandBuf+0x6a>
80100d52:	29 d3                	sub    %edx,%ebx
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    input.buf[h] = changedCommand[h-k-1];
80100d58:	88 88 80 fe 10 80    	mov    %cl,-0x7fef0180(%eax)
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100d5e:	83 c0 01             	add    $0x1,%eax
80100d61:	0f b6 4c 03 ff       	movzbl -0x1(%ebx,%eax,1),%ecx
80100d66:	84 c9                	test   %cl,%cl
80100d68:	75 ee                	jne    80100d58 <putLastCommandBuf+0x58>
  input.buf[h] = '\0';
80100d6a:	c6 80 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%eax)
}
80100d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  input.e = h;
80100d74:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
}
80100d79:	c9                   	leave  
80100d7a:	c3                   	ret    
80100d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d7f:	90                   	nop
80100d80:	31 c0                	xor    %eax,%eax
80100d82:	eb c7                	jmp    80100d4b <putLastCommandBuf+0x4b>
80100d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int k =  i-1;
80100d88:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80100d8d:	eb bc                	jmp    80100d4b <putLastCommandBuf+0x4b>
80100d8f:	90                   	nop

80100d90 <clearTheInputLine>:
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	57                   	push   %edi
80100d94:	bf 0e 00 00 00       	mov    $0xe,%edi
80100d99:	56                   	push   %esi
80100d9a:	be d4 03 00 00       	mov    $0x3d4,%esi
80100d9f:	89 f8                	mov    %edi,%eax
80100da1:	53                   	push   %ebx
80100da2:	89 f2                	mov    %esi,%edx
80100da4:	83 ec 18             	sub    $0x18,%esp
80100da7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100da8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100dad:	89 da                	mov    %ebx,%edx
80100daf:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100db0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100db3:	89 f2                	mov    %esi,%edx
80100db5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100dba:	c1 e1 08             	shl    $0x8,%ecx
80100dbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dbe:	89 da                	mov    %ebx,%edx
80100dc0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100dc1:	0f b6 c0             	movzbl %al,%eax
80100dc4:	09 c1                	or     %eax,%ecx
  for (int i = 0; i < cap; i++)
80100dc6:	a1 f8 0a 11 80       	mov    0x80110af8,%eax
    pos++;
80100dcb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80100dce:	85 c0                	test   %eax,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100dd0:	89 f8                	mov    %edi,%eax
80100dd2:	0f 4f ca             	cmovg  %edx,%ecx
80100dd5:	89 f2                	mov    %esi,%edx
80100dd7:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100dd8:	89 cf                	mov    %ecx,%edi
80100dda:	89 da                	mov    %ebx,%edx
80100ddc:	c1 ff 08             	sar    $0x8,%edi
80100ddf:	89 f8                	mov    %edi,%eax
80100de1:	ee                   	out    %al,(%dx)
80100de2:	b8 0f 00 00 00       	mov    $0xf,%eax
80100de7:	89 f2                	mov    %esi,%edx
80100de9:	ee                   	out    %al,(%dx)
80100dea:	89 c8                	mov    %ecx,%eax
80100dec:	89 da                	mov    %ebx,%edx
80100dee:	ee                   	out    %al,(%dx)
  char* res = getLastCommand(0);
80100def:	6a 00                	push   $0x0
  cap = 0;
80100df1:	c7 05 f8 0a 11 80 00 	movl   $0x0,0x80110af8
80100df8:	00 00 00 
  char* res = getLastCommand(0);
80100dfb:	e8 b0 fc ff ff       	call   80100ab0 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100e00:	83 c4 10             	add    $0x10,%esp
80100e03:	80 38 00             	cmpb   $0x0,(%eax)
80100e06:	74 2b                	je     80100e33 <clearTheInputLine+0xa3>
80100e08:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100e0b:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
80100e10:	85 c0                	test   %eax,%eax
80100e12:	74 0c                	je     80100e20 <clearTheInputLine+0x90>
  asm volatile("cli");
80100e14:	fa                   	cli    
    for(;;)
80100e15:	eb fe                	jmp    80100e15 <clearTheInputLine+0x85>
80100e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e1e:	66 90                	xchg   %ax,%ax
80100e20:	b8 00 01 00 00       	mov    $0x100,%eax
  for (i = 0; res[i] != '\0'; i++)
80100e25:	83 c3 01             	add    $0x1,%ebx
80100e28:	e8 b3 f6 ff ff       	call   801004e0 <consputc.part.0>
80100e2d:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
80100e31:	75 d8                	jne    80100e0b <clearTheInputLine+0x7b>
}
80100e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e36:	5b                   	pop    %ebx
80100e37:	5e                   	pop    %esi
80100e38:	5f                   	pop    %edi
80100e39:	5d                   	pop    %ebp
80100e3a:	c3                   	ret    
80100e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e3f:	90                   	nop

80100e40 <showNewCommand>:
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
80100e44:	83 ec 04             	sub    $0x4,%esp
  upDownKeyIndex--;
80100e47:	83 2d 20 05 11 80 01 	subl   $0x1,0x80110520
  clearTheInputLine();
80100e4e:	e8 3d ff ff ff       	call   80100d90 <clearTheInputLine>
  if (upDownKeyIndex == 0)
80100e53:	a1 20 05 11 80       	mov    0x80110520,%eax
80100e58:	85 c0                	test   %eax,%eax
80100e5a:	75 4c                	jne    80100ea8 <showNewCommand+0x68>
    putLastCommandBuf(tempBuf);
80100e5c:	83 ec 0c             	sub    $0xc,%esp
80100e5f:	68 a0 04 11 80       	push   $0x801104a0
80100e64:	e8 97 fe ff ff       	call   80100d00 <putLastCommandBuf>
80100e69:	83 c4 10             	add    $0x10,%esp
  char* lastCommand = getLastCommand(0);
80100e6c:	83 ec 0c             	sub    $0xc,%esp
80100e6f:	6a 00                	push   $0x0
80100e71:	e8 3a fc ff ff       	call   80100ab0 <getLastCommand>
  for (int i = 0; message[i] != '\0'; i++)
80100e76:	83 c4 10             	add    $0x10,%esp
80100e79:	0f b6 10             	movzbl (%eax),%edx
80100e7c:	84 d2                	test   %dl,%dl
80100e7e:	74 23                	je     80100ea3 <showNewCommand+0x63>
80100e80:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100e83:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
80100e88:	85 c0                	test   %eax,%eax
80100e8a:	74 04                	je     80100e90 <showNewCommand+0x50>
80100e8c:	fa                   	cli    
    for(;;)
80100e8d:	eb fe                	jmp    80100e8d <showNewCommand+0x4d>
80100e8f:	90                   	nop
    consputc(message[i]);
80100e90:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; message[i] != '\0'; i++)
80100e93:	83 c3 01             	add    $0x1,%ebx
80100e96:	e8 45 f6 ff ff       	call   801004e0 <consputc.part.0>
80100e9b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
80100e9f:	84 d2                	test   %dl,%dl
80100ea1:	75 e0                	jne    80100e83 <showNewCommand+0x43>
}
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100ea8:	c1 e0 07             	shl    $0x7,%eax
80100eab:	83 ec 0c             	sub    $0xc,%esp
80100eae:	05 c0 04 11 80       	add    $0x801104c0,%eax
80100eb3:	50                   	push   %eax
80100eb4:	e8 47 fe ff ff       	call   80100d00 <putLastCommandBuf>
80100eb9:	83 c4 10             	add    $0x10,%esp
80100ebc:	eb ae                	jmp    80100e6c <showNewCommand+0x2c>
80100ebe:	66 90                	xchg   %ax,%ax

80100ec0 <showPastCommand>:
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 04             	sub    $0x4,%esp
  if (upDownKeyIndex == 0)
80100ec7:	8b 1d 20 05 11 80    	mov    0x80110520,%ebx
80100ecd:	85 db                	test   %ebx,%ebx
80100ecf:	74 67                	je     80100f38 <showPastCommand+0x78>
  upDownKeyIndex++;
80100ed1:	83 c3 01             	add    $0x1,%ebx
80100ed4:	89 1d 20 05 11 80    	mov    %ebx,0x80110520
  clearTheInputLine();
80100eda:	e8 b1 fe ff ff       	call   80100d90 <clearTheInputLine>
  putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100edf:	a1 20 05 11 80       	mov    0x80110520,%eax
80100ee4:	83 ec 0c             	sub    $0xc,%esp
80100ee7:	c1 e0 07             	shl    $0x7,%eax
80100eea:	05 c0 04 11 80       	add    $0x801104c0,%eax
80100eef:	50                   	push   %eax
80100ef0:	e8 0b fe ff ff       	call   80100d00 <putLastCommandBuf>
  char* lastCommand = getLastCommand(0);
80100ef5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80100efc:	e8 af fb ff ff       	call   80100ab0 <getLastCommand>
  for (int i = 0; message[i] != '\0'; i++)
80100f01:	83 c4 10             	add    $0x10,%esp
80100f04:	0f b6 10             	movzbl (%eax),%edx
80100f07:	8d 58 01             	lea    0x1(%eax),%ebx
80100f0a:	84 d2                	test   %dl,%dl
80100f0c:	74 25                	je     80100f33 <showPastCommand+0x73>
  if(panicked) {
80100f0e:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
80100f13:	85 c0                	test   %eax,%eax
80100f15:	74 09                	je     80100f20 <showPastCommand+0x60>
80100f17:	fa                   	cli    
    for(;;)
80100f18:	eb fe                	jmp    80100f18 <showPastCommand+0x58>
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(message[i]);
80100f20:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; message[i] != '\0'; i++)
80100f23:	83 c3 01             	add    $0x1,%ebx
80100f26:	e8 b5 f5 ff ff       	call   801004e0 <consputc.part.0>
80100f2b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
80100f2f:	84 d2                	test   %dl,%dl
80100f31:	75 db                	jne    80100f0e <showPastCommand+0x4e>
}
80100f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f36:	c9                   	leave  
80100f37:	c3                   	ret    
    char* res = getLastCommand(0);
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	6a 00                	push   $0x0
80100f3d:	e8 6e fb ff ff       	call   80100ab0 <getLastCommand>
    for (i = 0; res[i] != '\0'; i++)
80100f42:	83 c4 10             	add    $0x10,%esp
80100f45:	0f b6 10             	movzbl (%eax),%edx
80100f48:	84 d2                	test   %dl,%dl
80100f4a:	74 15                	je     80100f61 <showPastCommand+0xa1>
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      tempBuf[i] = res[i];
80100f50:	88 93 a0 04 11 80    	mov    %dl,-0x7feefb60(%ebx)
    for (i = 0; res[i] != '\0'; i++)
80100f56:	83 c3 01             	add    $0x1,%ebx
80100f59:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
80100f5d:	84 d2                	test   %dl,%dl
80100f5f:	75 ef                	jne    80100f50 <showPastCommand+0x90>
    tempBuf[i] = '\0';
80100f61:	c6 83 a0 04 11 80 00 	movb   $0x0,-0x7feefb60(%ebx)
  upDownKeyIndex++;
80100f68:	8b 1d 20 05 11 80    	mov    0x80110520,%ebx
80100f6e:	e9 5e ff ff ff       	jmp    80100ed1 <showPastCommand+0x11>
80100f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f80 <checkHistoryCommand>:
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	56                   	push   %esi
80100f84:	53                   	push   %ebx
80100f85:	83 ec 10             	sub    $0x10,%esp
80100f88:	8b 75 08             	mov    0x8(%ebp),%esi
  char checkCommand[] = "history";
80100f8b:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
80100f92:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100f99:	0f b6 16             	movzbl (%esi),%edx
80100f9c:	84 d2                	test   %dl,%dl
80100f9e:	74 48                	je     80100fe8 <checkHistoryCommand+0x68>
80100fa0:	b9 68 00 00 00       	mov    $0x68,%ecx
80100fa5:	31 c0                	xor    %eax,%eax
  int flag = 1;
80100fa7:	bb 01 00 00 00       	mov    $0x1,%ebx
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100fb0:	83 f8 06             	cmp    $0x6,%eax
80100fb3:	7f 04                	jg     80100fb9 <checkHistoryCommand+0x39>
80100fb5:	38 ca                	cmp    %cl,%dl
80100fb7:	74 02                	je     80100fbb <checkHistoryCommand+0x3b>
      flag = 0;
80100fb9:	31 db                	xor    %ebx,%ebx
  for (i = 0; lastCommand[i] != '\0'; i++)
80100fbb:	83 c0 01             	add    $0x1,%eax
80100fbe:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80100fc2:	84 d2                	test   %dl,%dl
80100fc4:	74 0a                	je     80100fd0 <checkHistoryCommand+0x50>
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100fc6:	0f b6 4c 05 f0       	movzbl -0x10(%ebp,%eax,1),%ecx
80100fcb:	eb e3                	jmp    80100fb0 <checkHistoryCommand+0x30>
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi
    flag = 0;
80100fd0:	83 f8 06             	cmp    $0x6,%eax
80100fd3:	b8 00 00 00 00       	mov    $0x0,%eax
80100fd8:	0f 4e d8             	cmovle %eax,%ebx
}
80100fdb:	83 c4 10             	add    $0x10,%esp
80100fde:	89 d8                	mov    %ebx,%eax
80100fe0:	5b                   	pop    %ebx
80100fe1:	5e                   	pop    %esi
80100fe2:	5d                   	pop    %ebp
80100fe3:	c3                   	ret    
80100fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fe8:	83 c4 10             	add    $0x10,%esp
    flag = 0;
80100feb:	31 db                	xor    %ebx,%ebx
}
80100fed:	89 d8                	mov    %ebx,%eax
80100fef:	5b                   	pop    %ebx
80100ff0:	5e                   	pop    %esi
80100ff1:	5d                   	pop    %ebp
80100ff2:	c3                   	ret    
80100ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <print>:
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	53                   	push   %ebx
80101004:	83 ec 04             	sub    $0x4,%esp
80101007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = 0; message[i] != '\0'; i++)
8010100a:	0f be 03             	movsbl (%ebx),%eax
8010100d:	84 c0                	test   %al,%al
8010100f:	74 26                	je     80101037 <print+0x37>
80101011:	83 c3 01             	add    $0x1,%ebx
  if(panicked) {
80101014:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
8010101a:	85 d2                	test   %edx,%edx
8010101c:	74 0a                	je     80101028 <print+0x28>
8010101e:	fa                   	cli    
    for(;;)
8010101f:	eb fe                	jmp    8010101f <print+0x1f>
80101021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101028:	e8 b3 f4 ff ff       	call   801004e0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
8010102d:	0f be 03             	movsbl (%ebx),%eax
80101030:	83 c3 01             	add    $0x1,%ebx
80101033:	84 c0                	test   %al,%al
80101035:	75 dd                	jne    80101014 <print+0x14>
}
80101037:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010103a:	c9                   	leave  
8010103b:	c3                   	ret    
8010103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101040 <doHistoryCommand>:
  if(panicked) {
80101040:	8b 0d fc 0a 11 80    	mov    0x80110afc,%ecx
80101046:	85 c9                	test   %ecx,%ecx
80101048:	74 06                	je     80101050 <doHistoryCommand+0x10>
8010104a:	fa                   	cli    
    for(;;)
8010104b:	eb fe                	jmp    8010104b <doHistoryCommand+0xb>
8010104d:	8d 76 00             	lea    0x0(%esi),%esi
{
80101050:	55                   	push   %ebp
80101051:	b8 0a 00 00 00       	mov    $0xa,%eax
80101056:	89 e5                	mov    %esp,%ebp
80101058:	57                   	push   %edi
80101059:	56                   	push   %esi
8010105a:	53                   	push   %ebx
8010105b:	8d 5d c8             	lea    -0x38(%ebp),%ebx
8010105e:	83 ec 3c             	sub    $0x3c,%esp
80101061:	e8 7a f4 ff ff       	call   801004e0 <consputc.part.0>
  char message[] = "here are the lastest commands : ";
80101066:	c7 45 c7 68 65 72 65 	movl   $0x65726568,-0x39(%ebp)
  for (int i = 0; message[i] != '\0'; i++)
8010106d:	b8 68 00 00 00       	mov    $0x68,%eax
  char message[] = "here are the lastest commands : ";
80101072:	c7 45 cb 20 61 72 65 	movl   $0x65726120,-0x35(%ebp)
80101079:	c7 45 cf 20 74 68 65 	movl   $0x65687420,-0x31(%ebp)
80101080:	c7 45 d3 20 6c 61 73 	movl   $0x73616c20,-0x2d(%ebp)
80101087:	c7 45 d7 74 65 73 74 	movl   $0x74736574,-0x29(%ebp)
8010108e:	c7 45 db 20 63 6f 6d 	movl   $0x6d6f6320,-0x25(%ebp)
80101095:	c7 45 df 6d 61 6e 64 	movl   $0x646e616d,-0x21(%ebp)
8010109c:	c7 45 e3 73 20 3a 20 	movl   $0x203a2073,-0x1d(%ebp)
801010a3:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  if(panicked) {
801010a7:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
801010ad:	85 d2                	test   %edx,%edx
801010af:	74 07                	je     801010b8 <doHistoryCommand+0x78>
801010b1:	fa                   	cli    
    for(;;)
801010b2:	eb fe                	jmp    801010b2 <doHistoryCommand+0x72>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010b8:	e8 23 f4 ff ff       	call   801004e0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
801010bd:	0f be 03             	movsbl (%ebx),%eax
801010c0:	83 c3 01             	add    $0x1,%ebx
801010c3:	84 c0                	test   %al,%al
801010c5:	75 e0                	jne    801010a7 <doHistoryCommand+0x67>
  if(panicked) {
801010c7:	8b 1d fc 0a 11 80    	mov    0x80110afc,%ebx
801010cd:	85 db                	test   %ebx,%ebx
801010cf:	75 57                	jne    80101128 <doHistoryCommand+0xe8>
801010d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801010d6:	e8 05 f4 ff ff       	call   801004e0 <consputc.part.0>
  for (i = 0; i < HISTORYSIZE && historyBuf[i][0] != '\0' ; i++)
801010db:	89 d8                	mov    %ebx,%eax
801010dd:	c1 e0 07             	shl    $0x7,%eax
801010e0:	80 b8 40 05 11 80 00 	cmpb   $0x0,-0x7feefac0(%eax)
801010e7:	0f 84 8b 00 00 00    	je     80101178 <doHistoryCommand+0x138>
801010ed:	83 c3 01             	add    $0x1,%ebx
801010f0:	83 fb 0a             	cmp    $0xa,%ebx
801010f3:	75 e6                	jne    801010db <doHistoryCommand+0x9b>
  i--;
801010f5:	be 09 00 00 00       	mov    $0x9,%esi
801010fa:	89 f3                	mov    %esi,%ebx
801010fc:	c1 e3 07             	shl    $0x7,%ebx
801010ff:	81 c3 40 05 11 80    	add    $0x80110540,%ebx
    printint(i+1,10 ,1);
80101105:	8d 46 01             	lea    0x1(%esi),%eax
80101108:	b9 01 00 00 00       	mov    $0x1,%ecx
8010110d:	ba 0a 00 00 00       	mov    $0xa,%edx
80101112:	e8 29 f6 ff ff       	call   80100740 <printint>
  if(panicked) {
80101117:	8b 3d fc 0a 11 80    	mov    0x80110afc,%edi
8010111d:	85 ff                	test   %edi,%edi
8010111f:	74 0f                	je     80101130 <doHistoryCommand+0xf0>
80101121:	fa                   	cli    
    for(;;)
80101122:	eb fe                	jmp    80101122 <doHistoryCommand+0xe2>
80101124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101128:	fa                   	cli    
80101129:	eb fe                	jmp    80101129 <doHistoryCommand+0xe9>
8010112b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010112f:	90                   	nop
80101130:	b8 3a 00 00 00       	mov    $0x3a,%eax
80101135:	8d 7b 01             	lea    0x1(%ebx),%edi
80101138:	e8 a3 f3 ff ff       	call   801004e0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
8010113d:	0f be 03             	movsbl (%ebx),%eax
80101140:	84 c0                	test   %al,%al
80101142:	74 23                	je     80101167 <doHistoryCommand+0x127>
  if(panicked) {
80101144:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
8010114a:	85 d2                	test   %edx,%edx
8010114c:	74 0a                	je     80101158 <doHistoryCommand+0x118>
8010114e:	fa                   	cli    
    for(;;)
8010114f:	eb fe                	jmp    8010114f <doHistoryCommand+0x10f>
80101151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101158:	e8 83 f3 ff ff       	call   801004e0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
8010115d:	0f be 07             	movsbl (%edi),%eax
80101160:	83 c7 01             	add    $0x1,%edi
80101163:	84 c0                	test   %al,%al
80101165:	75 dd                	jne    80101144 <doHistoryCommand+0x104>
  if(panicked) {
80101167:	8b 0d fc 0a 11 80    	mov    0x80110afc,%ecx
8010116d:	85 c9                	test   %ecx,%ecx
8010116f:	74 1a                	je     8010118b <doHistoryCommand+0x14b>
80101171:	fa                   	cli    
    for(;;)
80101172:	eb fe                	jmp    80101172 <doHistoryCommand+0x132>
80101174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  i--;
80101178:	8d 73 ff             	lea    -0x1(%ebx),%esi
  for (i ; i >= 0; i--)
8010117b:	85 db                	test   %ebx,%ebx
8010117d:	0f 85 77 ff ff ff    	jne    801010fa <doHistoryCommand+0xba>
}
80101183:	83 c4 3c             	add    $0x3c,%esp
80101186:	5b                   	pop    %ebx
80101187:	5e                   	pop    %esi
80101188:	5f                   	pop    %edi
80101189:	5d                   	pop    %ebp
8010118a:	c3                   	ret    
8010118b:	b8 0a 00 00 00       	mov    $0xa,%eax
  for (i ; i >= 0; i--)
80101190:	83 ee 01             	sub    $0x1,%esi
80101193:	83 c3 80             	add    $0xffffff80,%ebx
80101196:	e8 45 f3 ff ff       	call   801004e0 <consputc.part.0>
8010119b:	83 fe ff             	cmp    $0xffffffff,%esi
8010119e:	0f 85 61 ff ff ff    	jne    80101105 <doHistoryCommand+0xc5>
801011a4:	eb dd                	jmp    80101183 <doHistoryCommand+0x143>
801011a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011ad:	8d 76 00             	lea    0x0(%esi),%esi

801011b0 <controlNewCommand>:
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	56                   	push   %esi
801011b4:	53                   	push   %ebx
801011b5:	83 ec 1c             	sub    $0x1c,%esp
  char* lastCommand = getLastCommand(0);
801011b8:	6a 00                	push   $0x0
801011ba:	e8 f1 f8 ff ff       	call   80100ab0 <getLastCommand>
  char checkCommand[] = "history";
801011bf:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
801011c6:	83 c4 10             	add    $0x10,%esp
801011c9:	0f b6 08             	movzbl (%eax),%ecx
  char checkCommand[] = "history";
801011cc:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
801011d3:	84 c9                	test   %cl,%cl
801011d5:	74 36                	je     8010120d <controlNewCommand+0x5d>
801011d7:	bb 68 00 00 00       	mov    $0x68,%ebx
  int flag = 1;
801011dc:	be 01 00 00 00       	mov    $0x1,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
801011e1:	31 d2                	xor    %edx,%edx
801011e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011e7:	90                   	nop
    if (checkCommand[i] != lastCommand[i] || i > 6)
801011e8:	83 fa 06             	cmp    $0x6,%edx
801011eb:	7f 04                	jg     801011f1 <controlNewCommand+0x41>
801011ed:	38 d9                	cmp    %bl,%cl
801011ef:	74 02                	je     801011f3 <controlNewCommand+0x43>
      flag = 0;
801011f1:	31 f6                	xor    %esi,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
801011f3:	83 c2 01             	add    $0x1,%edx
801011f6:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
801011fa:	84 c9                	test   %cl,%cl
801011fc:	74 0a                	je     80101208 <controlNewCommand+0x58>
    if (checkCommand[i] != lastCommand[i] || i > 6)
801011fe:	0f b6 5c 15 f0       	movzbl -0x10(%ebp,%edx,1),%ebx
80101203:	eb e3                	jmp    801011e8 <controlNewCommand+0x38>
80101205:	8d 76 00             	lea    0x0(%esi),%esi
  if (i < 7)
80101208:	83 fa 06             	cmp    $0x6,%edx
8010120b:	7f 0b                	jg     80101218 <controlNewCommand+0x68>
}
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (checkHistoryCommand(lastCommand))
80101218:	85 f6                	test   %esi,%esi
8010121a:	74 f1                	je     8010120d <controlNewCommand+0x5d>
}
8010121c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5d                   	pop    %ebp
    doHistoryCommand();
80101222:	e9 19 fe ff ff       	jmp    80101040 <doHistoryCommand>
80101227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122e:	66 90                	xchg   %ax,%ax

80101230 <consoleinit>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101236:	68 48 83 10 80       	push   $0x80108348
8010123b:	68 c0 0a 11 80       	push   $0x80110ac0
80101240:	e8 cb 42 00 00       	call   80105510 <initlock>
  ioapicenable(IRQ_KBD, 0);
80101245:	58                   	pop    %eax
80101246:	5a                   	pop    %edx
80101247:	6a 00                	push   $0x0
80101249:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010124b:	c7 05 ac 14 11 80 d0 	movl   $0x801006d0,0x801114ac
80101252:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101255:	c7 05 a8 14 11 80 80 	movl   $0x80100280,0x801114a8
8010125c:	02 10 80 
  cons.locking = 1;
8010125f:	c7 05 f4 0a 11 80 01 	movl   $0x1,0x80110af4
80101266:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101269:	e8 52 23 00 00       	call   801035c0 <ioapicenable>
}
8010126e:	83 c4 10             	add    $0x10,%esp
80101271:	c9                   	leave  
80101272:	c3                   	ret    
80101273:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010127a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101280 <isOperator>:
int isOperator(char c) {
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
80101287:	8d 48 d6             	lea    -0x2a(%eax),%ecx
8010128a:	80 f9 05             	cmp    $0x5,%cl
8010128d:	77 11                	ja     801012a0 <isOperator+0x20>
    return (c == '+' || c == '-' || c == '*' || c == '/');
8010128f:	b8 2b 00 00 00       	mov    $0x2b,%eax
}
80101294:	5d                   	pop    %ebp
    return (c == '+' || c == '-' || c == '*' || c == '/');
80101295:	d3 e8                	shr    %cl,%eax
80101297:	83 e0 01             	and    $0x1,%eax
}
8010129a:	c3                   	ret    
8010129b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop
    return (c == '+' || c == '-' || c == '*' || c == '/');
801012a0:	31 c0                	xor    %eax,%eax
}
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
801012a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012af:	90                   	nop

801012b0 <reverseNumber>:
int reverseNumber(int num) {
801012b0:	55                   	push   %ebp
    int rev = 0;
801012b1:	31 c0                	xor    %eax,%eax
int reverseNumber(int num) {
801012b3:	89 e5                	mov    %esp,%ebp
801012b5:	57                   	push   %edi
801012b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801012b9:	56                   	push   %esi
801012ba:	53                   	push   %ebx
    while (num > 0) {
801012bb:	85 c9                	test   %ecx,%ecx
801012bd:	7e 28                	jle    801012e7 <reverseNumber+0x37>
        rev = rev * 10 + num % 10;
801012bf:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801012c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c8:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
801012cb:	89 c8                	mov    %ecx,%eax
801012cd:	89 cf                	mov    %ecx,%edi
801012cf:	f7 e6                	mul    %esi
801012d1:	c1 ea 03             	shr    $0x3,%edx
801012d4:	8d 04 92             	lea    (%edx,%edx,4),%eax
801012d7:	01 c0                	add    %eax,%eax
801012d9:	29 c7                	sub    %eax,%edi
801012db:	8d 04 5f             	lea    (%edi,%ebx,2),%eax
        num /= 10;
801012de:	89 cb                	mov    %ecx,%ebx
801012e0:	89 d1                	mov    %edx,%ecx
    while (num > 0) {
801012e2:	83 fb 09             	cmp    $0x9,%ebx
801012e5:	7f e1                	jg     801012c8 <reverseNumber+0x18>
}
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret    
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <itoa>:
void itoa(int num, char *str, int base) {
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	8b 45 08             	mov    0x8(%ebp),%eax
801012f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801012f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if (num == 0) {
801012fc:	85 c0                	test   %eax,%eax
801012fe:	74 10                	je     80101310 <itoa+0x20>
}
80101300:	5d                   	pop    %ebp
80101301:	e9 7a f0 ff ff       	jmp    80100380 <itoa.part.0>
80101306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010130d:	8d 76 00             	lea    0x0(%esi),%esi
        str[i++] = '0';
80101310:	b8 30 00 00 00       	mov    $0x30,%eax
80101315:	66 89 02             	mov    %ax,(%edx)
}
80101318:	5d                   	pop    %ebp
80101319:	c3                   	ret    
8010131a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101320 <extractAndCompute>:


void extractAndCompute() {
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	bf 2b 00 00 00       	mov    $0x2b,%edi
80101329:	56                   	push   %esi
8010132a:	53                   	push   %ebx
8010132b:	83 ec 2c             	sub    $0x2c,%esp
    int i = input.e - 2;
8010132e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101333:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    int startPos = -1;
    char operator = '\0';
    int num1 = 0, num2 = 0;

    while (i >= 0 && input.buf[i] != '\n') {
80101336:	83 e8 02             	sub    $0x2,%eax
80101339:	0f 88 00 02 00 00    	js     8010153f <extractAndCompute+0x21f>
8010133f:	90                   	nop
80101340:	0f b6 90 80 fe 10 80 	movzbl -0x7fef0180(%eax),%edx
80101347:	80 fa 0a             	cmp    $0xa,%dl
8010134a:	0f 84 ef 01 00 00    	je     8010153f <extractAndCompute+0x21f>
        if (isOperator(input.buf[i])) {
80101350:	8d 72 d6             	lea    -0x2a(%edx),%esi
            operator = input.buf[i];
            startPos = i;
            break;
        }
        i--;
80101353:	8d 58 ff             	lea    -0x1(%eax),%ebx
80101356:	89 f1                	mov    %esi,%ecx
80101358:	80 f9 05             	cmp    $0x5,%cl
8010135b:	0f 87 ef 01 00 00    	ja     80101550 <extractAndCompute+0x230>
80101361:	0f a3 f7             	bt     %esi,%edi
80101364:	0f 83 e6 01 00 00    	jae    80101550 <extractAndCompute+0x230>
    }

    if (operator == '\0') 
      return;

    int j = input.e - 3; // Skip the last '?'
8010136a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
8010136d:	88 55 d0             	mov    %dl,-0x30(%ebp)
80101370:	8d 77 fd             	lea    -0x3(%edi),%esi
    int count_zero_num2 = 0;
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
80101373:	31 ff                	xor    %edi,%edi
80101375:	89 f2                	mov    %esi,%edx
80101377:	39 c6                	cmp    %eax,%esi
80101379:	0f 8e 90 00 00 00    	jle    8010140f <extractAndCompute+0xef>
8010137f:	31 c9                	xor    %ecx,%ecx
80101381:	eb 0f                	jmp    80101392 <extractAndCompute+0x72>
80101383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101387:	90                   	nop
        count_zero_num2++ ;
        j--;
80101388:	83 ea 01             	sub    $0x1,%edx
        count_zero_num2++ ;
8010138b:	83 c1 01             	add    $0x1,%ecx
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
8010138e:	39 c2                	cmp    %eax,%edx
80101390:	7e 09                	jle    8010139b <extractAndCompute+0x7b>
80101392:	80 ba 80 fe 10 80 30 	cmpb   $0x30,-0x7fef0180(%edx)
80101399:	74 ed                	je     80101388 <extractAndCompute+0x68>
8010139b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
    int count_zero_num2 = 0;
8010139e:	31 c9                	xor    %ecx,%ecx
801013a0:	eb 14                	jmp    801013b6 <extractAndCompute+0x96>
801013a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }


    j = input.e - 3; // Skip the last '?'
    while (j > startPos && isDigit(input.buf[j])) {
        num2 = (num2 * 10) + (input.buf[j] - '0');
801013a8:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
        j--;
801013ab:	83 ee 01             	sub    $0x1,%esi
        num2 = (num2 * 10) + (input.buf[j] - '0');
801013ae:	8d 4c 57 d0          	lea    -0x30(%edi,%edx,2),%ecx
    while (j > startPos && isDigit(input.buf[j])) {
801013b2:	39 c6                	cmp    %eax,%esi
801013b4:	7e 11                	jle    801013c7 <extractAndCompute+0xa7>
801013b6:	0f be be 80 fe 10 80 	movsbl -0x7fef0180(%esi),%edi
801013bd:	89 fa                	mov    %edi,%edx
  return(c>='0' && c<='9');
801013bf:	83 ea 30             	sub    $0x30,%edx
    while (j > startPos && isDigit(input.buf[j])) {
801013c2:	80 fa 09             	cmp    $0x9,%dl
801013c5:	76 e1                	jbe    801013a8 <extractAndCompute+0x88>
    while (num > 0) {
801013c7:	31 ff                	xor    %edi,%edi
801013c9:	85 c9                	test   %ecx,%ecx
801013cb:	7e 25                	jle    801013f2 <extractAndCompute+0xd2>
801013cd:	8d 76 00             	lea    0x0(%esi),%esi
        rev = rev * 10 + num % 10;
801013d0:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
801013d5:	8d 34 bf             	lea    (%edi,%edi,4),%esi
801013d8:	89 cf                	mov    %ecx,%edi
801013da:	f7 e1                	mul    %ecx
801013dc:	c1 ea 03             	shr    $0x3,%edx
801013df:	8d 04 92             	lea    (%edx,%edx,4),%eax
801013e2:	01 c0                	add    %eax,%eax
801013e4:	29 c7                	sub    %eax,%edi
801013e6:	89 c8                	mov    %ecx,%eax
        num /= 10;
801013e8:	89 d1                	mov    %edx,%ecx
        rev = rev * 10 + num % 10;
801013ea:	8d 3c 77             	lea    (%edi,%esi,2),%edi
    while (num > 0) {
801013ed:	83 f8 09             	cmp    $0x9,%eax
801013f0:	7f de                	jg     801013d0 <extractAndCompute+0xb0>
  for (int i = 0; i < power; i++)
801013f2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
801013f5:	85 c9                	test   %ecx,%ecx
801013f7:	74 16                	je     8010140f <extractAndCompute+0xef>
801013f9:	31 d2                	xor    %edx,%edx
  int result = 1;
801013fb:	b8 01 00 00 00       	mov    $0x1,%eax
    result = result * base;
80101400:	8d 04 80             	lea    (%eax,%eax,4),%eax
  for (int i = 0; i < power; i++)
80101403:	83 c2 01             	add    $0x1,%edx
    result = result * base;
80101406:	01 c0                	add    %eax,%eax
  for (int i = 0; i < power; i++)
80101408:	39 d1                	cmp    %edx,%ecx
8010140a:	75 f4                	jne    80101400 <extractAndCompute+0xe0>
    }

    
    num2 = reverseNumber(num2);
    num2 = num2 * pow(10, count_zero_num2); 
8010140c:	0f af f8             	imul   %eax,%edi
    //printint(num2, 10, 1);

    j = startPos - 1;


    int count_zero_num1 = 0;
8010140f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
    while (j > 0 && isDigit(input.buf[j]) && input.buf[j] == '0') {
80101416:	89 d8                	mov    %ebx,%eax
80101418:	31 d2                	xor    %edx,%edx
8010141a:	85 db                	test   %ebx,%ebx
8010141c:	7f 12                	jg     80101430 <extractAndCompute+0x110>
8010141e:	e9 96 01 00 00       	jmp    801015b9 <extractAndCompute+0x299>
80101423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101427:	90                   	nop
        count_zero_num1++ ;
80101428:	83 c2 01             	add    $0x1,%edx
    while (j > 0 && isDigit(input.buf[j]) && input.buf[j] == '0') {
8010142b:	83 e8 01             	sub    $0x1,%eax
8010142e:	74 09                	je     80101439 <extractAndCompute+0x119>
80101430:	80 b8 80 fe 10 80 30 	cmpb   $0x30,-0x7fef0180(%eax)
80101437:	74 ef                	je     80101428 <extractAndCompute+0x108>
80101439:	89 55 cc             	mov    %edx,-0x34(%ebp)
    int count_zero_num1 = 0;
8010143c:	31 c9                	xor    %ecx,%ecx
8010143e:	eb 0c                	jmp    8010144c <extractAndCompute+0x12c>
    }


    j = startPos - 1;
    while (j >= 0 && isDigit(input.buf[j])) {
        num1 = (num1 * 10) + (input.buf[j] - '0');
80101440:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80101443:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
    while (j >= 0 && isDigit(input.buf[j])) {
80101447:	83 eb 01             	sub    $0x1,%ebx
8010144a:	72 10                	jb     8010145c <extractAndCompute+0x13c>
8010144c:	0f be 93 80 fe 10 80 	movsbl -0x7fef0180(%ebx),%edx
80101453:	89 d0                	mov    %edx,%eax
  return(c>='0' && c<='9');
80101455:	83 e8 30             	sub    $0x30,%eax
    while (j >= 0 && isDigit(input.buf[j])) {
80101458:	3c 09                	cmp    $0x9,%al
8010145a:	76 e4                	jbe    80101440 <extractAndCompute+0x120>
    while (num > 0) {
8010145c:	31 c0                	xor    %eax,%eax
8010145e:	85 c9                	test   %ecx,%ecx
80101460:	7e 2b                	jle    8010148d <extractAndCompute+0x16d>
        rev = rev * 10 + num % 10;
80101462:	89 5d c8             	mov    %ebx,-0x38(%ebp)
80101465:	8d 76 00             	lea    0x0(%esi),%esi
80101468:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
8010146b:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80101470:	89 ce                	mov    %ecx,%esi
80101472:	f7 e1                	mul    %ecx
80101474:	c1 ea 03             	shr    $0x3,%edx
80101477:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010147a:	01 c0                	add    %eax,%eax
8010147c:	29 c6                	sub    %eax,%esi
8010147e:	8d 04 5e             	lea    (%esi,%ebx,2),%eax
        num /= 10;
80101481:	89 cb                	mov    %ecx,%ebx
80101483:	89 d1                	mov    %edx,%ecx
    while (num > 0) {
80101485:	83 fb 09             	cmp    $0x9,%ebx
80101488:	7f de                	jg     80101468 <extractAndCompute+0x148>
8010148a:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  for (int i = 0; i < power; i++)
8010148d:	8b 75 cc             	mov    -0x34(%ebp),%esi
80101490:	85 f6                	test   %esi,%esi
80101492:	74 1b                	je     801014af <extractAndCompute+0x18f>
80101494:	31 c9                	xor    %ecx,%ecx
  int result = 1;
80101496:	ba 01 00 00 00       	mov    $0x1,%edx
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
    result = result * base;
801014a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
  for (int i = 0; i < power; i++)
801014a3:	83 c1 01             	add    $0x1,%ecx
    result = result * base;
801014a6:	01 d2                	add    %edx,%edx
  for (int i = 0; i < power; i++)
801014a8:	39 ce                	cmp    %ecx,%esi
801014aa:	75 f4                	jne    801014a0 <extractAndCompute+0x180>
        j--;
    }

  
    num1 = reverseNumber(num1);
    num1 = num1 * pow(10, count_zero_num1);
801014ac:	0f af c2             	imul   %edx,%eax
    
    int result = 0;
    switch (operator) {
801014af:	0f b6 4d d0          	movzbl -0x30(%ebp),%ecx
801014b3:	80 f9 2d             	cmp    $0x2d,%cl
801014b6:	0f 84 dc 00 00 00    	je     80101598 <extractAndCompute+0x278>
801014bc:	7f 32                	jg     801014f0 <extractAndCompute+0x1d0>
801014be:	80 f9 2a             	cmp    $0x2a,%cl
801014c1:	0f 84 95 00 00 00    	je     8010155c <extractAndCompute+0x23c>
801014c7:	80 f9 2b             	cmp    $0x2b,%cl
801014ca:	75 73                	jne    8010153f <extractAndCompute+0x21f>
        case '+':
            result = num1 + num2;
801014cc:	01 f8                	add    %edi,%eax
801014ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
        default:
            return;
    }


    int lengthToRemove = (input.e - startPos) + (startPos - j - 1);
801014d1:	8b 7d d4             	mov    -0x2c(%ebp),%edi

    // Remove the characters in the pattern NON=?
    for (i = 0; i < lengthToRemove; i++) {
801014d4:	31 f6                	xor    %esi,%esi
    int lengthToRemove = (input.e - startPos) + (startPos - j - 1);
801014d6:	83 ef 01             	sub    $0x1,%edi
801014d9:	29 df                	sub    %ebx,%edi
    for (i = 0; i < lengthToRemove; i++) {
801014db:	85 ff                	test   %edi,%edi
801014dd:	7e 34                	jle    80101513 <extractAndCompute+0x1f3>
  if(panicked) {
801014df:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
801014e4:	85 c0                	test   %eax,%eax
801014e6:	74 1a                	je     80101502 <extractAndCompute+0x1e2>
801014e8:	fa                   	cli    
    for(;;)
801014e9:	eb fe                	jmp    801014e9 <extractAndCompute+0x1c9>
801014eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014ef:	90                   	nop
    switch (operator) {
801014f0:	80 7d d0 2f          	cmpb   $0x2f,-0x30(%ebp)
801014f4:	75 49                	jne    8010153f <extractAndCompute+0x21f>
            if (num2 != 0) result = num1 / num2;
801014f6:	85 ff                	test   %edi,%edi
801014f8:	74 45                	je     8010153f <extractAndCompute+0x21f>
801014fa:	99                   	cltd   
801014fb:	f7 ff                	idiv   %edi
801014fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
            break;
80101500:	eb cf                	jmp    801014d1 <extractAndCompute+0x1b1>
80101502:	b8 00 01 00 00       	mov    $0x100,%eax
    for (i = 0; i < lengthToRemove; i++) {
80101507:	83 c6 01             	add    $0x1,%esi
8010150a:	e8 d1 ef ff ff       	call   801004e0 <consputc.part.0>
8010150f:	39 f7                	cmp    %esi,%edi
80101511:	75 cc                	jne    801014df <extractAndCompute+0x1bf>
    if (num == 0) {
80101513:	8b 45 d0             	mov    -0x30(%ebp),%eax
    char resultStr[16];
    itoa(result, resultStr, 10); // Convert result to string

    // Write the result back to the console and input buffer
    for (i = 0; resultStr[i] != '\0'; i++) {
        input.buf[(j + 1 + i) % INPUT_BUF] = resultStr[i];
80101516:	83 c3 01             	add    $0x1,%ebx
80101519:	89 de                	mov    %ebx,%esi
    if (num == 0) {
8010151b:	85 c0                	test   %eax,%eax
8010151d:	74 48                	je     80101567 <extractAndCompute+0x247>
8010151f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101522:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101525:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010152a:	89 fa                	mov    %edi,%edx
8010152c:	e8 4f ee ff ff       	call   80100380 <itoa.part.0>
    for (i = 0; resultStr[i] != '\0'; i++) {
80101531:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
80101535:	84 c0                	test   %al,%al
80101537:	75 3f                	jne    80101578 <extractAndCompute+0x258>
        consputc(resultStr[i]);
    }

    input.e = j + 1 + i;
80101539:	89 35 08 ff 10 80    	mov    %esi,0x8010ff08
}
8010153f:	83 c4 2c             	add    $0x2c,%esp
80101542:	5b                   	pop    %ebx
80101543:	5e                   	pop    %esi
80101544:	5f                   	pop    %edi
80101545:	5d                   	pop    %ebp
80101546:	c3                   	ret    
80101547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154e:	66 90                	xchg   %ax,%ax
    while (i >= 0 && input.buf[i] != '\n') {
80101550:	83 fb ff             	cmp    $0xffffffff,%ebx
80101553:	74 ea                	je     8010153f <extractAndCompute+0x21f>
80101555:	89 d8                	mov    %ebx,%eax
80101557:	e9 e4 fd ff ff       	jmp    80101340 <extractAndCompute+0x20>
            result = num1 * num2;
8010155c:	0f af c7             	imul   %edi,%eax
8010155f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            break;
80101562:	e9 6a ff ff ff       	jmp    801014d1 <extractAndCompute+0x1b1>
        str[i++] = '0';
80101567:	b9 30 00 00 00       	mov    $0x30,%ecx
    for (i = 0; resultStr[i] != '\0'; i++) {
8010156c:	b8 30 00 00 00       	mov    $0x30,%eax
80101571:	8d 7d d8             	lea    -0x28(%ebp),%edi
        str[i++] = '0';
80101574:	66 89 4d d8          	mov    %cx,-0x28(%ebp)
    for (i = 0; resultStr[i] != '\0'; i++) {
80101578:	31 f6                	xor    %esi,%esi
        input.buf[(j + 1 + i) % INPUT_BUF] = resultStr[i];
8010157a:	8d 14 33             	lea    (%ebx,%esi,1),%edx
8010157d:	83 e2 7f             	and    $0x7f,%edx
80101580:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
  if(panicked) {
80101586:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
8010158c:	85 d2                	test   %edx,%edx
8010158e:	74 12                	je     801015a2 <extractAndCompute+0x282>
80101590:	fa                   	cli    
    for(;;)
80101591:	eb fe                	jmp    80101591 <extractAndCompute+0x271>
80101593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101597:	90                   	nop
            result = num1 - num2;
80101598:	29 f8                	sub    %edi,%eax
8010159a:	89 45 d0             	mov    %eax,-0x30(%ebp)
            break;
8010159d:	e9 2f ff ff ff       	jmp    801014d1 <extractAndCompute+0x1b1>
801015a2:	e8 39 ef ff ff       	call   801004e0 <consputc.part.0>
    for (i = 0; resultStr[i] != '\0'; i++) {
801015a7:	83 c6 01             	add    $0x1,%esi
801015aa:	0f be 04 37          	movsbl (%edi,%esi,1),%eax
801015ae:	84 c0                	test   %al,%al
801015b0:	75 c8                	jne    8010157a <extractAndCompute+0x25a>
    input.e = j + 1 + i;
801015b2:	8d 04 33             	lea    (%ebx,%esi,1),%eax
801015b5:	89 c6                	mov    %eax,%esi
801015b7:	eb 80                	jmp    80101539 <extractAndCompute+0x219>
    while (j >= 0 && isDigit(input.buf[j])) {
801015b9:	0f 84 7d fe ff ff    	je     8010143c <extractAndCompute+0x11c>
801015bf:	31 c0                	xor    %eax,%eax
801015c1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801015c6:	e9 e4 fe ff ff       	jmp    801014af <extractAndCompute+0x18f>
801015cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015cf:	90                   	nop

801015d0 <consoleintr>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 28             	sub    $0x28,%esp
801015d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801015dc:	68 c0 0a 11 80       	push   $0x80110ac0
801015e1:	e8 fa 40 00 00       	call   801056e0 <acquire>
  int c, doprocdump = 0;
801015e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
801015ed:	83 c4 10             	add    $0x10,%esp
801015f0:	ff d7                	call   *%edi
801015f2:	89 c3                	mov    %eax,%ebx
801015f4:	85 c0                	test   %eax,%eax
801015f6:	0f 88 e4 00 00 00    	js     801016e0 <consoleintr+0x110>
    switch(c){
801015fc:	83 fb 3f             	cmp    $0x3f,%ebx
801015ff:	0f 84 2b 04 00 00    	je     80101a30 <consoleintr+0x460>
80101605:	7f 19                	jg     80101620 <consoleintr+0x50>
80101607:	8d 43 fa             	lea    -0x6(%ebx),%eax
8010160a:	83 f8 0f             	cmp    $0xf,%eax
8010160d:	0f 87 25 01 00 00    	ja     80101738 <consoleintr+0x168>
80101613:	ff 24 85 50 83 10 80 	jmp    *-0x7fef7cb0(,%eax,4)
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101620:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80101626:	0f 84 64 03 00 00    	je     80101990 <consoleintr+0x3c0>
8010162c:	0f 8e d6 00 00 00    	jle    80101708 <consoleintr+0x138>
80101632:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80101638:	0f 84 72 03 00 00    	je     801019b0 <consoleintr+0x3e0>
8010163e:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80101644:	0f 85 f6 00 00 00    	jne    80101740 <consoleintr+0x170>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010164a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010164f:	b8 0e 00 00 00       	mov    $0xe,%eax
80101654:	89 f2                	mov    %esi,%edx
80101656:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101657:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010165c:	89 ca                	mov    %ecx,%edx
8010165e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010165f:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101662:	89 f2                	mov    %esi,%edx
80101664:	b8 0f 00 00 00       	mov    $0xf,%eax
80101669:	c1 e3 08             	shl    $0x8,%ebx
8010166c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010166d:	89 ca                	mov    %ecx,%edx
8010166f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101670:	0f b6 c8             	movzbl %al,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
80101673:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT + 1);
80101678:	09 d9                	or     %ebx,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
8010167a:	89 c8                	mov    %ecx,%eax
8010167c:	f7 e2                	mul    %edx
8010167e:	c1 ea 06             	shr    $0x6,%edx
80101681:	8d 44 92 05          	lea    0x5(%edx,%edx,4),%eax
80101685:	c1 e0 04             	shl    $0x4,%eax
80101688:	83 e8 01             	sub    $0x1,%eax
  if ((pos < last_index_line) && (cap > 0))
8010168b:	39 c1                	cmp    %eax,%ecx
8010168d:	7d 14                	jge    801016a3 <consoleintr+0xd3>
8010168f:	a1 f8 0a 11 80       	mov    0x80110af8,%eax
80101694:	85 c0                	test   %eax,%eax
80101696:	7e 0b                	jle    801016a3 <consoleintr+0xd3>
    cap--;
80101698:	83 e8 01             	sub    $0x1,%eax
    pos++;
8010169b:	83 c1 01             	add    $0x1,%ecx
    cap--;
8010169e:	a3 f8 0a 11 80       	mov    %eax,0x80110af8
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801016a3:	be d4 03 00 00       	mov    $0x3d4,%esi
801016a8:	b8 0e 00 00 00       	mov    $0xe,%eax
801016ad:	89 f2                	mov    %esi,%edx
801016af:	ee                   	out    %al,(%dx)
801016b0:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
801016b5:	89 c8                	mov    %ecx,%eax
801016b7:	c1 f8 08             	sar    $0x8,%eax
801016ba:	89 da                	mov    %ebx,%edx
801016bc:	ee                   	out    %al,(%dx)
801016bd:	b8 0f 00 00 00       	mov    $0xf,%eax
801016c2:	89 f2                	mov    %esi,%edx
801016c4:	ee                   	out    %al,(%dx)
801016c5:	89 c8                	mov    %ecx,%eax
801016c7:	89 da                	mov    %ebx,%edx
801016c9:	ee                   	out    %al,(%dx)
  while((c = getc()) >= 0){
801016ca:	ff d7                	call   *%edi
801016cc:	89 c3                	mov    %eax,%ebx
801016ce:	85 c0                	test   %eax,%eax
801016d0:	0f 89 26 ff ff ff    	jns    801015fc <consoleintr+0x2c>
801016d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016dd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 c0 0a 11 80       	push   $0x80110ac0
801016e8:	e8 93 3f 00 00       	call   80105680 <release>
  if(doprocdump) {
801016ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	85 c0                	test   %eax,%eax
801016f5:	0f 85 c4 03 00 00    	jne    80101abf <consoleintr+0x4ef>
}
801016fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fe:	5b                   	pop    %ebx
801016ff:	5e                   	pop    %esi
80101700:	5f                   	pop    %edi
80101701:	5d                   	pop    %ebp
80101702:	c3                   	ret    
80101703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101707:	90                   	nop
    switch(c){
80101708:	83 fb 7f             	cmp    $0x7f,%ebx
8010170b:	0f 84 4f 01 00 00    	je     80101860 <consoleintr+0x290>
80101711:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80101717:	75 27                	jne    80101740 <consoleintr+0x170>
      if (upDownKeyIndex < historyCurrentSize)
80101719:	a1 24 05 11 80       	mov    0x80110524,%eax
8010171e:	39 05 20 05 11 80    	cmp    %eax,0x80110520
80101724:	0f 8d c6 fe ff ff    	jge    801015f0 <consoleintr+0x20>
        showPastCommand();
8010172a:	e8 91 f7 ff ff       	call   80100ec0 <showPastCommand>
8010172f:	e9 bc fe ff ff       	jmp    801015f0 <consoleintr+0x20>
80101734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101738:	85 db                	test   %ebx,%ebx
8010173a:	0f 84 b0 fe ff ff    	je     801015f0 <consoleintr+0x20>
80101740:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101745:	89 c2                	mov    %eax,%edx
80101747:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010174d:	83 fa 7f             	cmp    $0x7f,%edx
80101750:	0f 87 9a fe ff ff    	ja     801015f0 <consoleintr+0x20>
        if (c=='\n'){
80101756:	83 fb 0a             	cmp    $0xa,%ebx
80101759:	0f 84 c6 03 00 00    	je     80101b25 <consoleintr+0x555>
8010175f:	83 fb 0d             	cmp    $0xd,%ebx
80101762:	0f 84 bd 03 00 00    	je     80101b25 <consoleintr+0x555>
        if (saveStatus && c != '\n')
80101768:	8b 0d 10 04 11 80    	mov    0x80110410,%ecx
            clipboard[saveIndex++] = c;
8010176e:	88 5d e0             	mov    %bl,-0x20(%ebp)
        if (saveStatus && c != '\n')
80101771:	85 c9                	test   %ecx,%ecx
80101773:	74 1c                	je     80101791 <consoleintr+0x1c1>
            clipboard[saveIndex++] = c;
80101775:	8b 0d 0c 04 11 80    	mov    0x8011040c,%ecx
8010177b:	8d 51 01             	lea    0x1(%ecx),%edx
8010177e:	88 99 20 04 11 80    	mov    %bl,-0x7feefbe0(%ecx)
80101784:	89 15 0c 04 11 80    	mov    %edx,0x8011040c
            clipboard[saveIndex] = '\0'; 
8010178a:	c6 81 21 04 11 80 00 	movb   $0x0,-0x7feefbdf(%ecx)
  for (int i = input.e; i > input.e - cap; i--)
80101791:	8b 35 f8 0a 11 80    	mov    0x80110af8,%esi
80101797:	89 c1                	mov    %eax,%ecx
80101799:	89 c2                	mov    %eax,%edx
8010179b:	29 f1                	sub    %esi,%ecx
8010179d:	39 c1                	cmp    %eax,%ecx
8010179f:	73 48                	jae    801017e9 <consoleintr+0x219>
801017a1:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801017a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
801017a8:	89 d0                	mov    %edx,%eax
801017aa:	83 ea 01             	sub    $0x1,%edx
801017ad:	89 d3                	mov    %edx,%ebx
801017af:	c1 fb 1f             	sar    $0x1f,%ebx
801017b2:	c1 eb 19             	shr    $0x19,%ebx
801017b5:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801017b8:	83 e1 7f             	and    $0x7f,%ecx
801017bb:	29 d9                	sub    %ebx,%ecx
801017bd:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
801017c4:	89 c1                	mov    %eax,%ecx
801017c6:	c1 f9 1f             	sar    $0x1f,%ecx
801017c9:	c1 e9 19             	shr    $0x19,%ecx
801017cc:	01 c8                	add    %ecx,%eax
801017ce:	83 e0 7f             	and    $0x7f,%eax
801017d1:	29 c8                	sub    %ecx,%eax
801017d3:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
801017d9:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801017de:	89 c1                	mov    %eax,%ecx
801017e0:	29 f1                	sub    %esi,%ecx
801017e2:	39 d1                	cmp    %edx,%ecx
801017e4:	72 c2                	jb     801017a8 <consoleintr+0x1d8>
801017e6:	8b 5d dc             	mov    -0x24(%ebp),%ebx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
801017e9:	83 c0 01             	add    $0x1,%eax
  if(panicked) {
801017ec:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
801017f2:	83 e1 7f             	and    $0x7f,%ecx
801017f5:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
801017fa:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
801017fe:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked) {
80101804:	85 d2                	test   %edx,%edx
80101806:	0f 84 9d 03 00 00    	je     80101ba9 <consoleintr+0x5d9>
  asm volatile("cli");
8010180c:	fa                   	cli    
    for(;;)
8010180d:	eb fe                	jmp    8010180d <consoleintr+0x23d>
8010180f:	90                   	nop
    switch(c){
80101810:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80101817:	e9 d4 fd ff ff       	jmp    801015f0 <consoleintr+0x20>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80101820:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101825:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010182b:	0f 84 bf fd ff ff    	je     801015f0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80101831:	83 e8 01             	sub    $0x1,%eax
80101834:	89 c2                	mov    %eax,%edx
80101836:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80101839:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80101840:	0f 84 aa fd ff ff    	je     801015f0 <consoleintr+0x20>
        input.e--;
80101846:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked) {
8010184b:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
80101850:	85 c0                	test   %eax,%eax
80101852:	0f 84 e8 01 00 00    	je     80101a40 <consoleintr+0x470>
80101858:	fa                   	cli    
    for(;;)
80101859:	eb fe                	jmp    80101859 <consoleintr+0x289>
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop
        if(input.e != input.w && input.e - input.w > cap) {
80101860:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101865:	8b 15 04 ff 10 80    	mov    0x8010ff04,%edx
8010186b:	39 d0                	cmp    %edx,%eax
8010186d:	0f 84 7d fd ff ff    	je     801015f0 <consoleintr+0x20>
80101873:	89 c3                	mov    %eax,%ebx
80101875:	8b 0d f8 0a 11 80    	mov    0x80110af8,%ecx
8010187b:	29 d3                	sub    %edx,%ebx
8010187d:	39 cb                	cmp    %ecx,%ebx
8010187f:	0f 86 6b fd ff ff    	jbe    801015f0 <consoleintr+0x20>
          if (cap > 0)
80101885:	8d 58 ff             	lea    -0x1(%eax),%ebx
80101888:	85 c9                	test   %ecx,%ecx
8010188a:	0f 8f c6 02 00 00    	jg     80101b56 <consoleintr+0x586>
  if(panicked) {
80101890:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
          input.e--;
80101895:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
  if(panicked) {
8010189b:	85 c0                	test   %eax,%eax
8010189d:	0f 84 5a 02 00 00    	je     80101afd <consoleintr+0x52d>
801018a3:	fa                   	cli    
    for(;;)
801018a4:	eb fe                	jmp    801018a4 <consoleintr+0x2d4>
801018a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ad:	8d 76 00             	lea    0x0(%esi),%esi
      if(saveStatus)
801018b0:	a1 10 04 11 80       	mov    0x80110410,%eax
801018b5:	85 c0                	test   %eax,%eax
801018b7:	0f 84 33 fd ff ff    	je     801015f0 <consoleintr+0x20>
        while(clipboard[i] != '\0')
801018bd:	0f b6 05 20 04 11 80 	movzbl 0x80110420,%eax
        int i = 0;
801018c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        while(clipboard[i] != '\0')
801018cb:	84 c0                	test   %al,%al
801018cd:	0f 84 1b 02 00 00    	je     80101aee <consoleintr+0x51e>
801018d3:	89 7d dc             	mov    %edi,-0x24(%ebp)
801018d6:	89 c7                	mov    %eax,%edi
  for (int i = input.e; i > input.e - cap; i--)
801018d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801018dd:	8b 35 f8 0a 11 80    	mov    0x80110af8,%esi
801018e3:	89 c1                	mov    %eax,%ecx
801018e5:	89 c2                	mov    %eax,%edx
801018e7:	29 f1                	sub    %esi,%ecx
801018e9:	39 c1                	cmp    %eax,%ecx
801018eb:	73 41                	jae    8010192e <consoleintr+0x35e>
801018ed:	8d 76 00             	lea    0x0(%esi),%esi
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
801018f0:	89 d0                	mov    %edx,%eax
801018f2:	83 ea 01             	sub    $0x1,%edx
801018f5:	89 d3                	mov    %edx,%ebx
801018f7:	c1 fb 1f             	sar    $0x1f,%ebx
801018fa:	c1 eb 19             	shr    $0x19,%ebx
801018fd:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101900:	83 e1 7f             	and    $0x7f,%ecx
80101903:	29 d9                	sub    %ebx,%ecx
80101905:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
8010190c:	89 c1                	mov    %eax,%ecx
8010190e:	c1 f9 1f             	sar    $0x1f,%ecx
80101911:	c1 e9 19             	shr    $0x19,%ecx
80101914:	01 c8                	add    %ecx,%eax
80101916:	83 e0 7f             	and    $0x7f,%eax
80101919:	29 c8                	sub    %ecx,%eax
8010191b:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101921:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101926:	89 c1                	mov    %eax,%ecx
80101928:	29 f1                	sub    %esi,%ecx
8010192a:	39 d1                	cmp    %edx,%ecx
8010192c:	72 c2                	jb     801018f0 <consoleintr+0x320>
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
8010192e:	83 c0 01             	add    $0x1,%eax
  if(panicked) {
80101931:	8b 35 fc 0a 11 80    	mov    0x80110afc,%esi
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
80101937:	83 e1 7f             	and    $0x7f,%ecx
8010193a:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
8010193f:	89 f8                	mov    %edi,%eax
80101941:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked) {
80101947:	85 f6                	test   %esi,%esi
80101949:	0f 84 7c 01 00 00    	je     80101acb <consoleintr+0x4fb>
8010194f:	fa                   	cli    
    for(;;)
80101950:	eb fe                	jmp    80101950 <consoleintr+0x380>
80101952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      saveStatus = 1;
80101958:	c7 05 10 04 11 80 01 	movl   $0x1,0x80110410
8010195f:	00 00 00 
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad. might be wrong approach
80101962:	83 ec 04             	sub    $0x4,%esp
80101965:	68 80 00 00 00       	push   $0x80
8010196a:	6a 00                	push   $0x0
8010196c:	68 20 04 11 80       	push   $0x80110420
      saveIndex = 0;
80101971:	c7 05 0c 04 11 80 00 	movl   $0x0,0x8011040c
80101978:	00 00 00 
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad. might be wrong approach
8010197b:	e8 20 3e 00 00       	call   801057a0 <memset>
      break;
80101980:	83 c4 10             	add    $0x10,%esp
80101983:	e9 68 fc ff ff       	jmp    801015f0 <consoleintr+0x20>
80101988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop
      if (upDownKeyIndex > 0)
80101990:	8b 1d 20 05 11 80    	mov    0x80110520,%ebx
80101996:	85 db                	test   %ebx,%ebx
80101998:	0f 8e 52 fc ff ff    	jle    801015f0 <consoleintr+0x20>
        showNewCommand();
8010199e:	e8 9d f4 ff ff       	call   80100e40 <showNewCommand>
801019a3:	e9 48 fc ff ff       	jmp    801015f0 <consoleintr+0x20>
801019a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop
      if ((input.e - cap) > input.w) 
801019b0:	8b 0d f8 0a 11 80    	mov    0x80110af8,%ecx
801019b6:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801019bb:	29 c8                	sub    %ecx,%eax
801019bd:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801019c3:	0f 86 27 fc ff ff    	jbe    801015f0 <consoleintr+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801019c9:	be d4 03 00 00       	mov    $0x3d4,%esi
801019ce:	b8 0e 00 00 00       	mov    $0xe,%eax
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801019d6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801019db:	89 da                	mov    %ebx,%edx
801019dd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801019de:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801019e1:	89 f2                	mov    %esi,%edx
801019e3:	c1 e0 08             	shl    $0x8,%eax
801019e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019e9:	b8 0f 00 00 00       	mov    $0xf,%eax
801019ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801019ef:	89 da                	mov    %ebx,%edx
801019f1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801019f2:	0f b6 d8             	movzbl %al,%ebx
801019f5:	0b 5d e0             	or     -0x20(%ebp),%ebx
  int first_write_index = NUMCOL * ((int) pos / NUMCOL) + 2;
801019f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801019fd:	89 d8                	mov    %ebx,%eax
801019ff:	f7 e2                	mul    %edx
80101a01:	c1 ea 06             	shr    $0x6,%edx
80101a04:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101a07:	c1 e0 04             	shl    $0x4,%eax
80101a0a:	83 c0 02             	add    $0x2,%eax
  if(pos >= first_write_index  && crt[pos - 2] != (('$' & 0xff) | 0x0700))
80101a0d:	39 c3                	cmp    %eax,%ebx
80101a0f:	7c 7b                	jl     80101a8c <consoleintr+0x4bc>
80101a11:	66 81 bc 1b fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ebx,%ebx,1)
80101a18:	80 24 07 
80101a1b:	74 6f                	je     80101a8c <consoleintr+0x4bc>
    pos--;
80101a1d:	83 eb 01             	sub    $0x1,%ebx
    cap++;
80101a20:	83 c1 01             	add    $0x1,%ecx
80101a23:	89 0d f8 0a 11 80    	mov    %ecx,0x80110af8
80101a29:	eb 68                	jmp    80101a93 <consoleintr+0x4c3>
80101a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a2f:	90                   	nop
  if(panicked) {
80101a30:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
80101a35:	85 c0                	test   %eax,%eax
80101a37:	74 27                	je     80101a60 <consoleintr+0x490>
  asm volatile("cli");
80101a39:	fa                   	cli    
    for(;;)
80101a3a:	eb fe                	jmp    80101a3a <consoleintr+0x46a>
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a40:	b8 00 01 00 00       	mov    $0x100,%eax
80101a45:	e8 96 ea ff ff       	call   801004e0 <consputc.part.0>
      while(input.e != input.w &&
80101a4a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101a4f:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80101a55:	0f 85 d6 fd ff ff    	jne    80101831 <consoleintr+0x261>
80101a5b:	e9 90 fb ff ff       	jmp    801015f0 <consoleintr+0x20>
80101a60:	b8 3f 00 00 00       	mov    $0x3f,%eax
80101a65:	e8 76 ea ff ff       	call   801004e0 <consputc.part.0>
      input.buf[(input.e++) % INPUT_BUF] = c;
80101a6a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101a6f:	8d 50 01             	lea    0x1(%eax),%edx
80101a72:	83 e0 7f             	and    $0x7f,%eax
80101a75:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80101a7b:	c6 80 80 fe 10 80 3f 	movb   $0x3f,-0x7fef0180(%eax)
      extractAndCompute(); // Check for NON=? and compute the result
80101a82:	e8 99 f8 ff ff       	call   80101320 <extractAndCompute>
      break;
80101a87:	e9 64 fb ff ff       	jmp    801015f0 <consoleintr+0x20>
  if (pos+1 >= first_write_index)
80101a8c:	8d 53 01             	lea    0x1(%ebx),%edx
80101a8f:	39 d0                	cmp    %edx,%eax
80101a91:	7e 8d                	jle    80101a20 <consoleintr+0x450>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101a93:	be d4 03 00 00       	mov    $0x3d4,%esi
80101a98:	b8 0e 00 00 00       	mov    $0xe,%eax
80101a9d:	89 f2                	mov    %esi,%edx
80101a9f:	ee                   	out    %al,(%dx)
80101aa0:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT + 1, pos >> 8);
80101aa5:	89 d8                	mov    %ebx,%eax
80101aa7:	c1 f8 08             	sar    $0x8,%eax
80101aaa:	89 ca                	mov    %ecx,%edx
80101aac:	ee                   	out    %al,(%dx)
80101aad:	b8 0f 00 00 00       	mov    $0xf,%eax
80101ab2:	89 f2                	mov    %esi,%edx
80101ab4:	ee                   	out    %al,(%dx)
80101ab5:	89 d8                	mov    %ebx,%eax
80101ab7:	89 ca                	mov    %ecx,%edx
80101ab9:	ee                   	out    %al,(%dx)
}
80101aba:	e9 31 fb ff ff       	jmp    801015f0 <consoleintr+0x20>
}
80101abf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac2:	5b                   	pop    %ebx
80101ac3:	5e                   	pop    %esi
80101ac4:	5f                   	pop    %edi
80101ac5:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80101ac6:	e9 55 38 00 00       	jmp    80105320 <procdump>
          consputc(clipboard[i]);  
80101acb:	0f be c0             	movsbl %al,%eax
80101ace:	e8 0d ea ff ff       	call   801004e0 <consputc.part.0>
          i++;
80101ad3:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80101ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
        while(clipboard[i] != '\0')
80101ada:	0f b6 b8 20 04 11 80 	movzbl -0x7feefbe0(%eax),%edi
80101ae1:	89 f8                	mov    %edi,%eax
80101ae3:	84 c0                	test   %al,%al
80101ae5:	0f 85 ed fd ff ff    	jne    801018d8 <consoleintr+0x308>
80101aeb:	8b 7d dc             	mov    -0x24(%ebp),%edi
        saveStatus = 0;
80101aee:	c7 05 10 04 11 80 00 	movl   $0x0,0x80110410
80101af5:	00 00 00 
80101af8:	e9 f3 fa ff ff       	jmp    801015f0 <consoleintr+0x20>
80101afd:	b8 00 01 00 00       	mov    $0x100,%eax
80101b02:	e8 d9 e9 ff ff       	call   801004e0 <consputc.part.0>
          if (cap == 0)
80101b07:	a1 f8 0a 11 80       	mov    0x80110af8,%eax
80101b0c:	85 c0                	test   %eax,%eax
80101b0e:	0f 85 dc fa ff ff    	jne    801015f0 <consoleintr+0x20>
            input.buf[input.e] = '\0';
80101b14:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101b19:	c6 80 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%eax)
80101b20:	e9 cb fa ff ff       	jmp    801015f0 <consoleintr+0x20>
          cap = 0;
80101b25:	c7 05 f8 0a 11 80 00 	movl   $0x0,0x80110af8
80101b2c:	00 00 00 
  for (int i = input.e; i > input.e - cap; i--)
80101b2f:	bb 0a 00 00 00       	mov    $0xa,%ebx
          addNewCommandToHistory();
80101b34:	e8 37 f0 ff ff       	call   80100b70 <addNewCommandToHistory>
          controlNewCommand();
80101b39:	e8 72 f6 ff ff       	call   801011b0 <controlNewCommand>
  for (int i = input.e; i > input.e - cap; i--)
80101b3e:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
80101b42:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          upDownKeyIndex = 0;
80101b47:	c7 05 20 05 11 80 00 	movl   $0x0,0x80110520
80101b4e:	00 00 00 
        if (saveStatus && c != '\n')
80101b51:	e9 3b fc ff ff       	jmp    80101791 <consoleintr+0x1c1>
  for (int i = input.e - cap - 1; i < input.e; i++)
80101b56:	89 da                	mov    %ebx,%edx
80101b58:	29 ca                	sub    %ecx,%edx
80101b5a:	39 d0                	cmp    %edx,%eax
80101b5c:	76 3f                	jbe    80101b9d <consoleintr+0x5cd>
80101b5e:	66 90                	xchg   %ax,%ax
    buf[(i) % INPUT_BUF] = buf[(i + 1) % INPUT_BUF]; // Shift elements to left
80101b60:	89 d0                	mov    %edx,%eax
80101b62:	83 c2 01             	add    $0x1,%edx
80101b65:	89 d3                	mov    %edx,%ebx
80101b67:	c1 fb 1f             	sar    $0x1f,%ebx
80101b6a:	c1 eb 19             	shr    $0x19,%ebx
80101b6d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101b70:	83 e1 7f             	and    $0x7f,%ecx
80101b73:	29 d9                	sub    %ebx,%ecx
80101b75:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
80101b7c:	89 c1                	mov    %eax,%ecx
80101b7e:	c1 f9 1f             	sar    $0x1f,%ecx
80101b81:	c1 e9 19             	shr    $0x19,%ecx
80101b84:	01 c8                	add    %ecx,%eax
80101b86:	83 e0 7f             	and    $0x7f,%eax
80101b89:	29 c8                	sub    %ecx,%eax
80101b8b:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e - cap - 1; i < input.e; i++)
80101b91:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101b96:	39 d0                	cmp    %edx,%eax
80101b98:	77 c6                	ja     80101b60 <consoleintr+0x590>
          input.e--;
80101b9a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  input.buf[input.e] = ' ';
80101b9d:	c6 80 80 fe 10 80 20 	movb   $0x20,-0x7fef0180(%eax)
}
80101ba4:	e9 e7 fc ff ff       	jmp    80101890 <consoleintr+0x2c0>
80101ba9:	89 d8                	mov    %ebx,%eax
80101bab:	e8 30 e9 ff ff       	call   801004e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101bb0:	83 fb 0a             	cmp    $0xa,%ebx
80101bb3:	74 33                	je     80101be8 <consoleintr+0x618>
80101bb5:	83 fb 04             	cmp    $0x4,%ebx
80101bb8:	74 2e                	je     80101be8 <consoleintr+0x618>
80101bba:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80101bbf:	83 e8 80             	sub    $0xffffff80,%eax
80101bc2:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80101bc8:	0f 85 22 fa ff ff    	jne    801015f0 <consoleintr+0x20>
          wakeup(&input.r);
80101bce:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101bd1:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80101bd6:	68 00 ff 10 80       	push   $0x8010ff00
80101bdb:	e8 60 36 00 00       	call   80105240 <wakeup>
80101be0:	83 c4 10             	add    $0x10,%esp
80101be3:	e9 08 fa ff ff       	jmp    801015f0 <consoleintr+0x20>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101be8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101bed:	eb df                	jmp    80101bce <consoleintr+0x5fe>
80101bef:	90                   	nop

80101bf0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101bfc:	e8 af 2e 00 00       	call   80104ab0 <myproc>
80101c01:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101c07:	e8 94 22 00 00       	call   80103ea0 <begin_op>

  if((ip = namei(path)) == 0){
80101c0c:	83 ec 0c             	sub    $0xc,%esp
80101c0f:	ff 75 08             	push   0x8(%ebp)
80101c12:	e8 c9 15 00 00       	call   801031e0 <namei>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	85 c0                	test   %eax,%eax
80101c1c:	0f 84 02 03 00 00    	je     80101f24 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101c22:	83 ec 0c             	sub    $0xc,%esp
80101c25:	89 c3                	mov    %eax,%ebx
80101c27:	50                   	push   %eax
80101c28:	e8 93 0c 00 00       	call   801028c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101c2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101c33:	6a 34                	push   $0x34
80101c35:	6a 00                	push   $0x0
80101c37:	50                   	push   %eax
80101c38:	53                   	push   %ebx
80101c39:	e8 92 0f 00 00       	call   80102bd0 <readi>
80101c3e:	83 c4 20             	add    $0x20,%esp
80101c41:	83 f8 34             	cmp    $0x34,%eax
80101c44:	74 22                	je     80101c68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101c46:	83 ec 0c             	sub    $0xc,%esp
80101c49:	53                   	push   %ebx
80101c4a:	e8 01 0f 00 00       	call   80102b50 <iunlockput>
    end_op();
80101c4f:	e8 bc 22 00 00       	call   80103f10 <end_op>
80101c54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5f:	5b                   	pop    %ebx
80101c60:	5e                   	pop    %esi
80101c61:	5f                   	pop    %edi
80101c62:	5d                   	pop    %ebp
80101c63:	c3                   	ret    
80101c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101c68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101c6f:	45 4c 46 
80101c72:	75 d2                	jne    80101c46 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101c74:	e8 07 63 00 00       	call   80107f80 <setupkvm>
80101c79:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101c7f:	85 c0                	test   %eax,%eax
80101c81:	74 c3                	je     80101c46 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101c83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101c8a:	00 
80101c8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101c91:	0f 84 ac 02 00 00    	je     80101f43 <exec+0x353>
  sz = 0;
80101c97:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101c9e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101ca1:	31 ff                	xor    %edi,%edi
80101ca3:	e9 8e 00 00 00       	jmp    80101d36 <exec+0x146>
80101ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101caf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101cb0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101cb7:	75 6c                	jne    80101d25 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101cb9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101cbf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101cc5:	0f 82 87 00 00 00    	jb     80101d52 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101ccb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101cd1:	72 7f                	jb     80101d52 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101cd3:	83 ec 04             	sub    $0x4,%esp
80101cd6:	50                   	push   %eax
80101cd7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101cdd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101ce3:	e8 b8 60 00 00       	call   80107da0 <allocuvm>
80101ce8:	83 c4 10             	add    $0x10,%esp
80101ceb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101cf1:	85 c0                	test   %eax,%eax
80101cf3:	74 5d                	je     80101d52 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101cf5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101cfb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101d00:	75 50                	jne    80101d52 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101d02:	83 ec 0c             	sub    $0xc,%esp
80101d05:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101d0b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101d11:	53                   	push   %ebx
80101d12:	50                   	push   %eax
80101d13:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101d19:	e8 92 5f 00 00       	call   80107cb0 <loaduvm>
80101d1e:	83 c4 20             	add    $0x20,%esp
80101d21:	85 c0                	test   %eax,%eax
80101d23:	78 2d                	js     80101d52 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101d25:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101d2c:	83 c7 01             	add    $0x1,%edi
80101d2f:	83 c6 20             	add    $0x20,%esi
80101d32:	39 f8                	cmp    %edi,%eax
80101d34:	7e 3a                	jle    80101d70 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101d36:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101d3c:	6a 20                	push   $0x20
80101d3e:	56                   	push   %esi
80101d3f:	50                   	push   %eax
80101d40:	53                   	push   %ebx
80101d41:	e8 8a 0e 00 00       	call   80102bd0 <readi>
80101d46:	83 c4 10             	add    $0x10,%esp
80101d49:	83 f8 20             	cmp    $0x20,%eax
80101d4c:	0f 84 5e ff ff ff    	je     80101cb0 <exec+0xc0>
    freevm(pgdir);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101d5b:	e8 a0 61 00 00       	call   80107f00 <freevm>
  if(ip){
80101d60:	83 c4 10             	add    $0x10,%esp
80101d63:	e9 de fe ff ff       	jmp    80101c46 <exec+0x56>
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
  sz = PGROUNDUP(sz);
80101d70:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101d76:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80101d7c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101d82:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101d88:	83 ec 0c             	sub    $0xc,%esp
80101d8b:	53                   	push   %ebx
80101d8c:	e8 bf 0d 00 00       	call   80102b50 <iunlockput>
  end_op();
80101d91:	e8 7a 21 00 00       	call   80103f10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101d96:	83 c4 0c             	add    $0xc,%esp
80101d99:	56                   	push   %esi
80101d9a:	57                   	push   %edi
80101d9b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101da1:	57                   	push   %edi
80101da2:	e8 f9 5f 00 00       	call   80107da0 <allocuvm>
80101da7:	83 c4 10             	add    $0x10,%esp
80101daa:	89 c6                	mov    %eax,%esi
80101dac:	85 c0                	test   %eax,%eax
80101dae:	0f 84 94 00 00 00    	je     80101e48 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101db4:	83 ec 08             	sub    $0x8,%esp
80101db7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80101dbd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101dbf:	50                   	push   %eax
80101dc0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101dc1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101dc3:	e8 58 62 00 00       	call   80108020 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dcb:	83 c4 10             	add    $0x10,%esp
80101dce:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101dd4:	8b 00                	mov    (%eax),%eax
80101dd6:	85 c0                	test   %eax,%eax
80101dd8:	0f 84 8b 00 00 00    	je     80101e69 <exec+0x279>
80101dde:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101de4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101dea:	eb 23                	jmp    80101e0f <exec+0x21f>
80101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101df0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101df3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80101dfa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80101dfd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101e03:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101e06:	85 c0                	test   %eax,%eax
80101e08:	74 59                	je     80101e63 <exec+0x273>
    if(argc >= MAXARG)
80101e0a:	83 ff 20             	cmp    $0x20,%edi
80101e0d:	74 39                	je     80101e48 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101e0f:	83 ec 0c             	sub    $0xc,%esp
80101e12:	50                   	push   %eax
80101e13:	e8 88 3b 00 00       	call   801059a0 <strlen>
80101e18:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101e1a:	58                   	pop    %eax
80101e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101e1e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101e21:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101e24:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101e27:	e8 74 3b 00 00       	call   801059a0 <strlen>
80101e2c:	83 c0 01             	add    $0x1,%eax
80101e2f:	50                   	push   %eax
80101e30:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e33:	ff 34 b8             	push   (%eax,%edi,4)
80101e36:	53                   	push   %ebx
80101e37:	56                   	push   %esi
80101e38:	e8 b3 63 00 00       	call   801081f0 <copyout>
80101e3d:	83 c4 20             	add    $0x20,%esp
80101e40:	85 c0                	test   %eax,%eax
80101e42:	79 ac                	jns    80101df0 <exec+0x200>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101e48:	83 ec 0c             	sub    $0xc,%esp
80101e4b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101e51:	e8 aa 60 00 00       	call   80107f00 <freevm>
80101e56:	83 c4 10             	add    $0x10,%esp
  return -1;
80101e59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e5e:	e9 f9 fd ff ff       	jmp    80101c5c <exec+0x6c>
80101e63:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101e69:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101e70:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101e72:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101e79:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101e7d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80101e7f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101e82:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101e88:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101e8a:	50                   	push   %eax
80101e8b:	52                   	push   %edx
80101e8c:	53                   	push   %ebx
80101e8d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101e93:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101e9a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101e9d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101ea3:	e8 48 63 00 00       	call   801081f0 <copyout>
80101ea8:	83 c4 10             	add    $0x10,%esp
80101eab:	85 c0                	test   %eax,%eax
80101ead:	78 99                	js     80101e48 <exec+0x258>
  for(last=s=path; *s; s++)
80101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb2:	8b 55 08             	mov    0x8(%ebp),%edx
80101eb5:	0f b6 00             	movzbl (%eax),%eax
80101eb8:	84 c0                	test   %al,%al
80101eba:	74 13                	je     80101ecf <exec+0x2df>
80101ebc:	89 d1                	mov    %edx,%ecx
80101ebe:	66 90                	xchg   %ax,%ax
      last = s+1;
80101ec0:	83 c1 01             	add    $0x1,%ecx
80101ec3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101ec5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101ec8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80101ecb:	84 c0                	test   %al,%al
80101ecd:	75 f1                	jne    80101ec0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101ecf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101ed5:	83 ec 04             	sub    $0x4,%esp
80101ed8:	6a 10                	push   $0x10
80101eda:	89 f8                	mov    %edi,%eax
80101edc:	52                   	push   %edx
80101edd:	83 c0 6c             	add    $0x6c,%eax
80101ee0:	50                   	push   %eax
80101ee1:	e8 7a 3a 00 00       	call   80105960 <safestrcpy>
  curproc->pgdir = pgdir;
80101ee6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80101eec:	89 f8                	mov    %edi,%eax
80101eee:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101ef1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101ef3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101ef6:	89 c1                	mov    %eax,%ecx
80101ef8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101efe:	8b 40 18             	mov    0x18(%eax),%eax
80101f01:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101f04:	8b 41 18             	mov    0x18(%ecx),%eax
80101f07:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101f0a:	89 0c 24             	mov    %ecx,(%esp)
80101f0d:	e8 0e 5c 00 00       	call   80107b20 <switchuvm>
  freevm(oldpgdir);
80101f12:	89 3c 24             	mov    %edi,(%esp)
80101f15:	e8 e6 5f 00 00       	call   80107f00 <freevm>
  return 0;
80101f1a:	83 c4 10             	add    $0x10,%esp
80101f1d:	31 c0                	xor    %eax,%eax
80101f1f:	e9 38 fd ff ff       	jmp    80101c5c <exec+0x6c>
    end_op();
80101f24:	e8 e7 1f 00 00       	call   80103f10 <end_op>
    cprintf("exec: fail\n");
80101f29:	83 ec 0c             	sub    $0xc,%esp
80101f2c:	68 a1 83 10 80       	push   $0x801083a1
80101f31:	e8 aa e8 ff ff       	call   801007e0 <cprintf>
    return -1;
80101f36:	83 c4 10             	add    $0x10,%esp
80101f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f3e:	e9 19 fd ff ff       	jmp    80101c5c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f43:	be 00 20 00 00       	mov    $0x2000,%esi
80101f48:	31 ff                	xor    %edi,%edi
80101f4a:	e9 39 fe ff ff       	jmp    80101d88 <exec+0x198>
80101f4f:	90                   	nop

80101f50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101f56:	68 ad 83 10 80       	push   $0x801083ad
80101f5b:	68 00 0b 11 80       	push   $0x80110b00
80101f60:	e8 ab 35 00 00       	call   80105510 <initlock>
}
80101f65:	83 c4 10             	add    $0x10,%esp
80101f68:	c9                   	leave  
80101f69:	c3                   	ret    
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101f74:	bb 34 0b 11 80       	mov    $0x80110b34,%ebx
{
80101f79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101f7c:	68 00 0b 11 80       	push   $0x80110b00
80101f81:	e8 5a 37 00 00       	call   801056e0 <acquire>
80101f86:	83 c4 10             	add    $0x10,%esp
80101f89:	eb 10                	jmp    80101f9b <filealloc+0x2b>
80101f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f8f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101f90:	83 c3 18             	add    $0x18,%ebx
80101f93:	81 fb 94 14 11 80    	cmp    $0x80111494,%ebx
80101f99:	74 25                	je     80101fc0 <filealloc+0x50>
    if(f->ref == 0){
80101f9b:	8b 43 04             	mov    0x4(%ebx),%eax
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 ee                	jne    80101f90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101fa2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101fa5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80101fac:	68 00 0b 11 80       	push   $0x80110b00
80101fb1:	e8 ca 36 00 00       	call   80105680 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101fb6:	89 d8                	mov    %ebx,%eax
      return f;
80101fb8:	83 c4 10             	add    $0x10,%esp
}
80101fbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fbe:	c9                   	leave  
80101fbf:	c3                   	ret    
  release(&ftable.lock);
80101fc0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101fc3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101fc5:	68 00 0b 11 80       	push   $0x80110b00
80101fca:	e8 b1 36 00 00       	call   80105680 <release>
}
80101fcf:	89 d8                	mov    %ebx,%eax
  return 0;
80101fd1:	83 c4 10             	add    $0x10,%esp
}
80101fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fd7:	c9                   	leave  
80101fd8:	c3                   	ret    
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	53                   	push   %ebx
80101fe4:	83 ec 10             	sub    $0x10,%esp
80101fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80101fea:	68 00 0b 11 80       	push   $0x80110b00
80101fef:	e8 ec 36 00 00       	call   801056e0 <acquire>
  if(f->ref < 1)
80101ff4:	8b 43 04             	mov    0x4(%ebx),%eax
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	7e 1a                	jle    80102018 <filedup+0x38>
    panic("filedup");
  f->ref++;
80101ffe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80102001:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80102004:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80102007:	68 00 0b 11 80       	push   $0x80110b00
8010200c:	e8 6f 36 00 00       	call   80105680 <release>
  return f;
}
80102011:	89 d8                	mov    %ebx,%eax
80102013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102016:	c9                   	leave  
80102017:	c3                   	ret    
    panic("filedup");
80102018:	83 ec 0c             	sub    $0xc,%esp
8010201b:	68 b4 83 10 80       	push   $0x801083b4
80102020:	e8 3b e4 ff ff       	call   80100460 <panic>
80102025:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102030 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 28             	sub    $0x28,%esp
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010203c:	68 00 0b 11 80       	push   $0x80110b00
80102041:	e8 9a 36 00 00       	call   801056e0 <acquire>
  if(f->ref < 1)
80102046:	8b 53 04             	mov    0x4(%ebx),%edx
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	85 d2                	test   %edx,%edx
8010204e:	0f 8e a5 00 00 00    	jle    801020f9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102054:	83 ea 01             	sub    $0x1,%edx
80102057:	89 53 04             	mov    %edx,0x4(%ebx)
8010205a:	75 44                	jne    801020a0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010205c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102060:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102063:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102065:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010206b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010206e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102071:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80102074:	68 00 0b 11 80       	push   $0x80110b00
  ff = *f;
80102079:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010207c:	e8 ff 35 00 00       	call   80105680 <release>

  if(ff.type == FD_PIPE)
80102081:	83 c4 10             	add    $0x10,%esp
80102084:	83 ff 01             	cmp    $0x1,%edi
80102087:	74 57                	je     801020e0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102089:	83 ff 02             	cmp    $0x2,%edi
8010208c:	74 2a                	je     801020b8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010208e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102091:	5b                   	pop    %ebx
80102092:	5e                   	pop    %esi
80102093:	5f                   	pop    %edi
80102094:	5d                   	pop    %ebp
80102095:	c3                   	ret    
80102096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801020a0:	c7 45 08 00 0b 11 80 	movl   $0x80110b00,0x8(%ebp)
}
801020a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020aa:	5b                   	pop    %ebx
801020ab:	5e                   	pop    %esi
801020ac:	5f                   	pop    %edi
801020ad:	5d                   	pop    %ebp
    release(&ftable.lock);
801020ae:	e9 cd 35 00 00       	jmp    80105680 <release>
801020b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b7:	90                   	nop
    begin_op();
801020b8:	e8 e3 1d 00 00       	call   80103ea0 <begin_op>
    iput(ff.ip);
801020bd:	83 ec 0c             	sub    $0xc,%esp
801020c0:	ff 75 e0             	push   -0x20(%ebp)
801020c3:	e8 28 09 00 00       	call   801029f0 <iput>
    end_op();
801020c8:	83 c4 10             	add    $0x10,%esp
}
801020cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
    end_op();
801020d2:	e9 39 1e 00 00       	jmp    80103f10 <end_op>
801020d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020de:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801020e0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801020e4:	83 ec 08             	sub    $0x8,%esp
801020e7:	53                   	push   %ebx
801020e8:	56                   	push   %esi
801020e9:	e8 82 25 00 00       	call   80104670 <pipeclose>
801020ee:	83 c4 10             	add    $0x10,%esp
}
801020f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f4:	5b                   	pop    %ebx
801020f5:	5e                   	pop    %esi
801020f6:	5f                   	pop    %edi
801020f7:	5d                   	pop    %ebp
801020f8:	c3                   	ret    
    panic("fileclose");
801020f9:	83 ec 0c             	sub    $0xc,%esp
801020fc:	68 bc 83 10 80       	push   $0x801083bc
80102101:	e8 5a e3 ff ff       	call   80100460 <panic>
80102106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210d:	8d 76 00             	lea    0x0(%esi),%esi

80102110 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 04             	sub    $0x4,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010211a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010211d:	75 31                	jne    80102150 <filestat+0x40>
    ilock(f->ip);
8010211f:	83 ec 0c             	sub    $0xc,%esp
80102122:	ff 73 10             	push   0x10(%ebx)
80102125:	e8 96 07 00 00       	call   801028c0 <ilock>
    stati(f->ip, st);
8010212a:	58                   	pop    %eax
8010212b:	5a                   	pop    %edx
8010212c:	ff 75 0c             	push   0xc(%ebp)
8010212f:	ff 73 10             	push   0x10(%ebx)
80102132:	e8 69 0a 00 00       	call   80102ba0 <stati>
    iunlock(f->ip);
80102137:	59                   	pop    %ecx
80102138:	ff 73 10             	push   0x10(%ebx)
8010213b:	e8 60 08 00 00       	call   801029a0 <iunlock>
    return 0;
  }
  return -1;
}
80102140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	31 c0                	xor    %eax,%eax
}
80102148:	c9                   	leave  
80102149:	c3                   	ret    
8010214a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102158:	c9                   	leave  
80102159:	c3                   	ret    
8010215a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102160 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
80102169:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010216c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010216f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102172:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102176:	74 60                	je     801021d8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102178:	8b 03                	mov    (%ebx),%eax
8010217a:	83 f8 01             	cmp    $0x1,%eax
8010217d:	74 41                	je     801021c0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010217f:	83 f8 02             	cmp    $0x2,%eax
80102182:	75 5b                	jne    801021df <fileread+0x7f>
    ilock(f->ip);
80102184:	83 ec 0c             	sub    $0xc,%esp
80102187:	ff 73 10             	push   0x10(%ebx)
8010218a:	e8 31 07 00 00       	call   801028c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010218f:	57                   	push   %edi
80102190:	ff 73 14             	push   0x14(%ebx)
80102193:	56                   	push   %esi
80102194:	ff 73 10             	push   0x10(%ebx)
80102197:	e8 34 0a 00 00       	call   80102bd0 <readi>
8010219c:	83 c4 20             	add    $0x20,%esp
8010219f:	89 c6                	mov    %eax,%esi
801021a1:	85 c0                	test   %eax,%eax
801021a3:	7e 03                	jle    801021a8 <fileread+0x48>
      f->off += r;
801021a5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	ff 73 10             	push   0x10(%ebx)
801021ae:	e8 ed 07 00 00       	call   801029a0 <iunlock>
    return r;
801021b3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801021b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b9:	89 f0                	mov    %esi,%eax
801021bb:	5b                   	pop    %ebx
801021bc:	5e                   	pop    %esi
801021bd:	5f                   	pop    %edi
801021be:	5d                   	pop    %ebp
801021bf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801021c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801021c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801021c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c9:	5b                   	pop    %ebx
801021ca:	5e                   	pop    %esi
801021cb:	5f                   	pop    %edi
801021cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801021cd:	e9 3e 26 00 00       	jmp    80104810 <piperead>
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801021d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801021dd:	eb d7                	jmp    801021b6 <fileread+0x56>
  panic("fileread");
801021df:	83 ec 0c             	sub    $0xc,%esp
801021e2:	68 c6 83 10 80       	push   $0x801083c6
801021e7:	e8 74 e2 ff ff       	call   80100460 <panic>
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 1c             	sub    $0x1c,%esp
801021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801021fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801021ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102202:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80102205:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80102209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010220c:	0f 84 bd 00 00 00    	je     801022cf <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80102212:	8b 03                	mov    (%ebx),%eax
80102214:	83 f8 01             	cmp    $0x1,%eax
80102217:	0f 84 bf 00 00 00    	je     801022dc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010221d:	83 f8 02             	cmp    $0x2,%eax
80102220:	0f 85 c8 00 00 00    	jne    801022ee <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80102226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80102229:	31 f6                	xor    %esi,%esi
    while(i < n){
8010222b:	85 c0                	test   %eax,%eax
8010222d:	7f 30                	jg     8010225f <filewrite+0x6f>
8010222f:	e9 94 00 00 00       	jmp    801022c8 <filewrite+0xd8>
80102234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102238:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010223b:	83 ec 0c             	sub    $0xc,%esp
8010223e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80102241:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102244:	e8 57 07 00 00       	call   801029a0 <iunlock>
      end_op();
80102249:	e8 c2 1c 00 00       	call   80103f10 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010224e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102251:	83 c4 10             	add    $0x10,%esp
80102254:	39 c7                	cmp    %eax,%edi
80102256:	75 5c                	jne    801022b4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102258:	01 fe                	add    %edi,%esi
    while(i < n){
8010225a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010225d:	7e 69                	jle    801022c8 <filewrite+0xd8>
      int n1 = n - i;
8010225f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102262:	b8 00 06 00 00       	mov    $0x600,%eax
80102267:	29 f7                	sub    %esi,%edi
80102269:	39 c7                	cmp    %eax,%edi
8010226b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010226e:	e8 2d 1c 00 00       	call   80103ea0 <begin_op>
      ilock(f->ip);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	ff 73 10             	push   0x10(%ebx)
80102279:	e8 42 06 00 00       	call   801028c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010227e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102281:	57                   	push   %edi
80102282:	ff 73 14             	push   0x14(%ebx)
80102285:	01 f0                	add    %esi,%eax
80102287:	50                   	push   %eax
80102288:	ff 73 10             	push   0x10(%ebx)
8010228b:	e8 40 0a 00 00       	call   80102cd0 <writei>
80102290:	83 c4 20             	add    $0x20,%esp
80102293:	85 c0                	test   %eax,%eax
80102295:	7f a1                	jg     80102238 <filewrite+0x48>
      iunlock(f->ip);
80102297:	83 ec 0c             	sub    $0xc,%esp
8010229a:	ff 73 10             	push   0x10(%ebx)
8010229d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801022a0:	e8 fb 06 00 00       	call   801029a0 <iunlock>
      end_op();
801022a5:	e8 66 1c 00 00       	call   80103f10 <end_op>
      if(r < 0)
801022aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022ad:	83 c4 10             	add    $0x10,%esp
801022b0:	85 c0                	test   %eax,%eax
801022b2:	75 1b                	jne    801022cf <filewrite+0xdf>
        panic("short filewrite");
801022b4:	83 ec 0c             	sub    $0xc,%esp
801022b7:	68 cf 83 10 80       	push   $0x801083cf
801022bc:	e8 9f e1 ff ff       	call   80100460 <panic>
801022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801022c8:	89 f0                	mov    %esi,%eax
801022ca:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801022cd:	74 05                	je     801022d4 <filewrite+0xe4>
801022cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801022d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d7:	5b                   	pop    %ebx
801022d8:	5e                   	pop    %esi
801022d9:	5f                   	pop    %edi
801022da:	5d                   	pop    %ebp
801022db:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801022dc:	8b 43 0c             	mov    0xc(%ebx),%eax
801022df:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e5:	5b                   	pop    %ebx
801022e6:	5e                   	pop    %esi
801022e7:	5f                   	pop    %edi
801022e8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801022e9:	e9 22 24 00 00       	jmp    80104710 <pipewrite>
  panic("filewrite");
801022ee:	83 ec 0c             	sub    $0xc,%esp
801022f1:	68 d5 83 10 80       	push   $0x801083d5
801022f6:	e8 65 e1 ff ff       	call   80100460 <panic>
801022fb:	66 90                	xchg   %ax,%ax
801022fd:	66 90                	xchg   %ax,%ax
801022ff:	90                   	nop

80102300 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80102300:	55                   	push   %ebp
80102301:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80102303:	89 d0                	mov    %edx,%eax
80102305:	c1 e8 0c             	shr    $0xc,%eax
80102308:	03 05 6c 31 11 80    	add    0x8011316c,%eax
{
8010230e:	89 e5                	mov    %esp,%ebp
80102310:	56                   	push   %esi
80102311:	53                   	push   %ebx
80102312:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80102314:	83 ec 08             	sub    $0x8,%esp
80102317:	50                   	push   %eax
80102318:	51                   	push   %ecx
80102319:	e8 b2 dd ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010231e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80102320:	c1 fb 03             	sar    $0x3,%ebx
80102323:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80102326:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80102328:	83 e1 07             	and    $0x7,%ecx
8010232b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80102330:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80102336:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80102338:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010233d:	85 c1                	test   %eax,%ecx
8010233f:	74 23                	je     80102364 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80102341:	f7 d0                	not    %eax
  log_write(bp);
80102343:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102346:	21 c8                	and    %ecx,%eax
80102348:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010234c:	56                   	push   %esi
8010234d:	e8 2e 1d 00 00       	call   80104080 <log_write>
  brelse(bp);
80102352:	89 34 24             	mov    %esi,(%esp)
80102355:	e8 96 de ff ff       	call   801001f0 <brelse>
}
8010235a:	83 c4 10             	add    $0x10,%esp
8010235d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102360:	5b                   	pop    %ebx
80102361:	5e                   	pop    %esi
80102362:	5d                   	pop    %ebp
80102363:	c3                   	ret    
    panic("freeing free block");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 df 83 10 80       	push   $0x801083df
8010236c:	e8 ef e0 ff ff       	call   80100460 <panic>
80102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010237f:	90                   	nop

80102380 <balloc>:
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	57                   	push   %edi
80102384:	56                   	push   %esi
80102385:	53                   	push   %ebx
80102386:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80102389:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
{
8010238f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102392:	85 c9                	test   %ecx,%ecx
80102394:	0f 84 87 00 00 00    	je     80102421 <balloc+0xa1>
8010239a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801023a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801023a4:	83 ec 08             	sub    $0x8,%esp
801023a7:	89 f0                	mov    %esi,%eax
801023a9:	c1 f8 0c             	sar    $0xc,%eax
801023ac:	03 05 6c 31 11 80    	add    0x8011316c,%eax
801023b2:	50                   	push   %eax
801023b3:	ff 75 d8             	push   -0x28(%ebp)
801023b6:	e8 15 dd ff ff       	call   801000d0 <bread>
801023bb:	83 c4 10             	add    $0x10,%esp
801023be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801023c1:	a1 54 31 11 80       	mov    0x80113154,%eax
801023c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801023c9:	31 c0                	xor    %eax,%eax
801023cb:	eb 2f                	jmp    801023fc <balloc+0x7c>
801023cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801023d0:	89 c1                	mov    %eax,%ecx
801023d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801023d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801023da:	83 e1 07             	and    $0x7,%ecx
801023dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801023df:	89 c1                	mov    %eax,%ecx
801023e1:	c1 f9 03             	sar    $0x3,%ecx
801023e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801023e9:	89 fa                	mov    %edi,%edx
801023eb:	85 df                	test   %ebx,%edi
801023ed:	74 41                	je     80102430 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801023ef:	83 c0 01             	add    $0x1,%eax
801023f2:	83 c6 01             	add    $0x1,%esi
801023f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801023fa:	74 05                	je     80102401 <balloc+0x81>
801023fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801023ff:	77 cf                	ja     801023d0 <balloc+0x50>
    brelse(bp);
80102401:	83 ec 0c             	sub    $0xc,%esp
80102404:	ff 75 e4             	push   -0x1c(%ebp)
80102407:	e8 e4 dd ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010240c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80102413:	83 c4 10             	add    $0x10,%esp
80102416:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102419:	39 05 54 31 11 80    	cmp    %eax,0x80113154
8010241f:	77 80                	ja     801023a1 <balloc+0x21>
  panic("balloc: out of blocks");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 f2 83 10 80       	push   $0x801083f2
80102429:	e8 32 e0 ff ff       	call   80100460 <panic>
8010242e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80102430:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80102433:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80102436:	09 da                	or     %ebx,%edx
80102438:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010243c:	57                   	push   %edi
8010243d:	e8 3e 1c 00 00       	call   80104080 <log_write>
        brelse(bp);
80102442:	89 3c 24             	mov    %edi,(%esp)
80102445:	e8 a6 dd ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010244a:	58                   	pop    %eax
8010244b:	5a                   	pop    %edx
8010244c:	56                   	push   %esi
8010244d:	ff 75 d8             	push   -0x28(%ebp)
80102450:	e8 7b dc ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80102455:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102458:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010245a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010245d:	68 00 02 00 00       	push   $0x200
80102462:	6a 00                	push   $0x0
80102464:	50                   	push   %eax
80102465:	e8 36 33 00 00       	call   801057a0 <memset>
  log_write(bp);
8010246a:	89 1c 24             	mov    %ebx,(%esp)
8010246d:	e8 0e 1c 00 00       	call   80104080 <log_write>
  brelse(bp);
80102472:	89 1c 24             	mov    %ebx,(%esp)
80102475:	e8 76 dd ff ff       	call   801001f0 <brelse>
}
8010247a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010247d:	89 f0                	mov    %esi,%eax
8010247f:	5b                   	pop    %ebx
80102480:	5e                   	pop    %esi
80102481:	5f                   	pop    %edi
80102482:	5d                   	pop    %ebp
80102483:	c3                   	ret    
80102484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010248f:	90                   	nop

80102490 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	57                   	push   %edi
80102494:	89 c7                	mov    %eax,%edi
80102496:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102497:	31 f6                	xor    %esi,%esi
{
80102499:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010249a:	bb 34 15 11 80       	mov    $0x80111534,%ebx
{
8010249f:	83 ec 28             	sub    $0x28,%esp
801024a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801024a5:	68 00 15 11 80       	push   $0x80111500
801024aa:	e8 31 32 00 00       	call   801056e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801024af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801024b2:	83 c4 10             	add    $0x10,%esp
801024b5:	eb 1b                	jmp    801024d2 <iget+0x42>
801024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024be:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801024c0:	39 3b                	cmp    %edi,(%ebx)
801024c2:	74 6c                	je     80102530 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801024c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801024ca:	81 fb 54 31 11 80    	cmp    $0x80113154,%ebx
801024d0:	73 26                	jae    801024f8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801024d2:	8b 43 08             	mov    0x8(%ebx),%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	7f e7                	jg     801024c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801024d9:	85 f6                	test   %esi,%esi
801024db:	75 e7                	jne    801024c4 <iget+0x34>
801024dd:	85 c0                	test   %eax,%eax
801024df:	75 76                	jne    80102557 <iget+0xc7>
801024e1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801024e3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801024e9:	81 fb 54 31 11 80    	cmp    $0x80113154,%ebx
801024ef:	72 e1                	jb     801024d2 <iget+0x42>
801024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801024f8:	85 f6                	test   %esi,%esi
801024fa:	74 79                	je     80102575 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801024fc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801024ff:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80102501:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80102504:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010250b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80102512:	68 00 15 11 80       	push   $0x80111500
80102517:	e8 64 31 00 00       	call   80105680 <release>

  return ip;
8010251c:	83 c4 10             	add    $0x10,%esp
}
8010251f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102522:	89 f0                	mov    %esi,%eax
80102524:	5b                   	pop    %ebx
80102525:	5e                   	pop    %esi
80102526:	5f                   	pop    %edi
80102527:	5d                   	pop    %ebp
80102528:	c3                   	ret    
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102530:	39 53 04             	cmp    %edx,0x4(%ebx)
80102533:	75 8f                	jne    801024c4 <iget+0x34>
      release(&icache.lock);
80102535:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80102538:	83 c0 01             	add    $0x1,%eax
      return ip;
8010253b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010253d:	68 00 15 11 80       	push   $0x80111500
      ip->ref++;
80102542:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102545:	e8 36 31 00 00       	call   80105680 <release>
      return ip;
8010254a:	83 c4 10             	add    $0x10,%esp
}
8010254d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102550:	89 f0                	mov    %esi,%eax
80102552:	5b                   	pop    %ebx
80102553:	5e                   	pop    %esi
80102554:	5f                   	pop    %edi
80102555:	5d                   	pop    %ebp
80102556:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102557:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010255d:	81 fb 54 31 11 80    	cmp    $0x80113154,%ebx
80102563:	73 10                	jae    80102575 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102565:	8b 43 08             	mov    0x8(%ebx),%eax
80102568:	85 c0                	test   %eax,%eax
8010256a:	0f 8f 50 ff ff ff    	jg     801024c0 <iget+0x30>
80102570:	e9 68 ff ff ff       	jmp    801024dd <iget+0x4d>
    panic("iget: no inodes");
80102575:	83 ec 0c             	sub    $0xc,%esp
80102578:	68 08 84 10 80       	push   $0x80108408
8010257d:	e8 de de ff ff       	call   80100460 <panic>
80102582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102590 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	56                   	push   %esi
80102595:	89 c6                	mov    %eax,%esi
80102597:	53                   	push   %ebx
80102598:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010259b:	83 fa 0b             	cmp    $0xb,%edx
8010259e:	0f 86 8c 00 00 00    	jbe    80102630 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801025a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801025a7:	83 fb 7f             	cmp    $0x7f,%ebx
801025aa:	0f 87 a2 00 00 00    	ja     80102652 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801025b0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801025b6:	85 c0                	test   %eax,%eax
801025b8:	74 5e                	je     80102618 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801025ba:	83 ec 08             	sub    $0x8,%esp
801025bd:	50                   	push   %eax
801025be:	ff 36                	push   (%esi)
801025c0:	e8 0b db ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801025c5:	83 c4 10             	add    $0x10,%esp
801025c8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801025cc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801025ce:	8b 3b                	mov    (%ebx),%edi
801025d0:	85 ff                	test   %edi,%edi
801025d2:	74 1c                	je     801025f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	52                   	push   %edx
801025d8:	e8 13 dc ff ff       	call   801001f0 <brelse>
801025dd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801025e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025e3:	89 f8                	mov    %edi,%eax
801025e5:	5b                   	pop    %ebx
801025e6:	5e                   	pop    %esi
801025e7:	5f                   	pop    %edi
801025e8:	5d                   	pop    %ebp
801025e9:	c3                   	ret    
801025ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801025f3:	8b 06                	mov    (%esi),%eax
801025f5:	e8 86 fd ff ff       	call   80102380 <balloc>
      log_write(bp);
801025fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801025fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80102600:	89 03                	mov    %eax,(%ebx)
80102602:	89 c7                	mov    %eax,%edi
      log_write(bp);
80102604:	52                   	push   %edx
80102605:	e8 76 1a 00 00       	call   80104080 <log_write>
8010260a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	eb c2                	jmp    801025d4 <bmap+0x44>
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80102618:	8b 06                	mov    (%esi),%eax
8010261a:	e8 61 fd ff ff       	call   80102380 <balloc>
8010261f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80102625:	eb 93                	jmp    801025ba <bmap+0x2a>
80102627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80102630:	8d 5a 14             	lea    0x14(%edx),%ebx
80102633:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80102637:	85 ff                	test   %edi,%edi
80102639:	75 a5                	jne    801025e0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010263b:	8b 00                	mov    (%eax),%eax
8010263d:	e8 3e fd ff ff       	call   80102380 <balloc>
80102642:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80102646:	89 c7                	mov    %eax,%edi
}
80102648:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010264b:	5b                   	pop    %ebx
8010264c:	89 f8                	mov    %edi,%eax
8010264e:	5e                   	pop    %esi
8010264f:	5f                   	pop    %edi
80102650:	5d                   	pop    %ebp
80102651:	c3                   	ret    
  panic("bmap: out of range");
80102652:	83 ec 0c             	sub    $0xc,%esp
80102655:	68 18 84 10 80       	push   $0x80108418
8010265a:	e8 01 de ff ff       	call   80100460 <panic>
8010265f:	90                   	nop

80102660 <readsb>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
80102665:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102668:	83 ec 08             	sub    $0x8,%esp
8010266b:	6a 01                	push   $0x1
8010266d:	ff 75 08             	push   0x8(%ebp)
80102670:	e8 5b da ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102675:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102678:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010267a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010267d:	6a 1c                	push   $0x1c
8010267f:	50                   	push   %eax
80102680:	56                   	push   %esi
80102681:	e8 ba 31 00 00       	call   80105840 <memmove>
  brelse(bp);
80102686:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102689:	83 c4 10             	add    $0x10,%esp
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
  brelse(bp);
80102692:	e9 59 db ff ff       	jmp    801001f0 <brelse>
80102697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <iinit>:
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	53                   	push   %ebx
801026a4:	bb 40 15 11 80       	mov    $0x80111540,%ebx
801026a9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801026ac:	68 2b 84 10 80       	push   $0x8010842b
801026b1:	68 00 15 11 80       	push   $0x80111500
801026b6:	e8 55 2e 00 00       	call   80105510 <initlock>
  for(i = 0; i < NINODE; i++) {
801026bb:	83 c4 10             	add    $0x10,%esp
801026be:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801026c0:	83 ec 08             	sub    $0x8,%esp
801026c3:	68 32 84 10 80       	push   $0x80108432
801026c8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801026c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801026cf:	e8 0c 2d 00 00       	call   801053e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801026d4:	83 c4 10             	add    $0x10,%esp
801026d7:	81 fb 60 31 11 80    	cmp    $0x80113160,%ebx
801026dd:	75 e1                	jne    801026c0 <iinit+0x20>
  bp = bread(dev, 1);
801026df:	83 ec 08             	sub    $0x8,%esp
801026e2:	6a 01                	push   $0x1
801026e4:	ff 75 08             	push   0x8(%ebp)
801026e7:	e8 e4 d9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801026ec:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801026ef:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801026f1:	8d 40 5c             	lea    0x5c(%eax),%eax
801026f4:	6a 1c                	push   $0x1c
801026f6:	50                   	push   %eax
801026f7:	68 54 31 11 80       	push   $0x80113154
801026fc:	e8 3f 31 00 00       	call   80105840 <memmove>
  brelse(bp);
80102701:	89 1c 24             	mov    %ebx,(%esp)
80102704:	e8 e7 da ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80102709:	ff 35 6c 31 11 80    	push   0x8011316c
8010270f:	ff 35 68 31 11 80    	push   0x80113168
80102715:	ff 35 64 31 11 80    	push   0x80113164
8010271b:	ff 35 60 31 11 80    	push   0x80113160
80102721:	ff 35 5c 31 11 80    	push   0x8011315c
80102727:	ff 35 58 31 11 80    	push   0x80113158
8010272d:	ff 35 54 31 11 80    	push   0x80113154
80102733:	68 98 84 10 80       	push   $0x80108498
80102738:	e8 a3 e0 ff ff       	call   801007e0 <cprintf>
}
8010273d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102740:	83 c4 30             	add    $0x30,%esp
80102743:	c9                   	leave  
80102744:	c3                   	ret    
80102745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <ialloc>:
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	57                   	push   %edi
80102754:	56                   	push   %esi
80102755:	53                   	push   %ebx
80102756:	83 ec 1c             	sub    $0x1c,%esp
80102759:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010275c:	83 3d 5c 31 11 80 01 	cmpl   $0x1,0x8011315c
{
80102763:	8b 75 08             	mov    0x8(%ebp),%esi
80102766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102769:	0f 86 91 00 00 00    	jbe    80102800 <ialloc+0xb0>
8010276f:	bf 01 00 00 00       	mov    $0x1,%edi
80102774:	eb 21                	jmp    80102797 <ialloc+0x47>
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102780:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102783:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102786:	53                   	push   %ebx
80102787:	e8 64 da ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010278c:	83 c4 10             	add    $0x10,%esp
8010278f:	3b 3d 5c 31 11 80    	cmp    0x8011315c,%edi
80102795:	73 69                	jae    80102800 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102797:	89 f8                	mov    %edi,%eax
80102799:	83 ec 08             	sub    $0x8,%esp
8010279c:	c1 e8 03             	shr    $0x3,%eax
8010279f:	03 05 68 31 11 80    	add    0x80113168,%eax
801027a5:	50                   	push   %eax
801027a6:	56                   	push   %esi
801027a7:	e8 24 d9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801027ac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801027af:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801027b1:	89 f8                	mov    %edi,%eax
801027b3:	83 e0 07             	and    $0x7,%eax
801027b6:	c1 e0 06             	shl    $0x6,%eax
801027b9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801027bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801027c1:	75 bd                	jne    80102780 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801027c3:	83 ec 04             	sub    $0x4,%esp
801027c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801027c9:	6a 40                	push   $0x40
801027cb:	6a 00                	push   $0x0
801027cd:	51                   	push   %ecx
801027ce:	e8 cd 2f 00 00       	call   801057a0 <memset>
      dip->type = type;
801027d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801027d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801027da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801027dd:	89 1c 24             	mov    %ebx,(%esp)
801027e0:	e8 9b 18 00 00       	call   80104080 <log_write>
      brelse(bp);
801027e5:	89 1c 24             	mov    %ebx,(%esp)
801027e8:	e8 03 da ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801027ed:	83 c4 10             	add    $0x10,%esp
}
801027f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801027f3:	89 fa                	mov    %edi,%edx
}
801027f5:	5b                   	pop    %ebx
      return iget(dev, inum);
801027f6:	89 f0                	mov    %esi,%eax
}
801027f8:	5e                   	pop    %esi
801027f9:	5f                   	pop    %edi
801027fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801027fb:	e9 90 fc ff ff       	jmp    80102490 <iget>
  panic("ialloc: no inodes");
80102800:	83 ec 0c             	sub    $0xc,%esp
80102803:	68 38 84 10 80       	push   $0x80108438
80102808:	e8 53 dc ff ff       	call   80100460 <panic>
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <iupdate>:
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	56                   	push   %esi
80102814:	53                   	push   %ebx
80102815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102818:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010281b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010281e:	83 ec 08             	sub    $0x8,%esp
80102821:	c1 e8 03             	shr    $0x3,%eax
80102824:	03 05 68 31 11 80    	add    0x80113168,%eax
8010282a:	50                   	push   %eax
8010282b:	ff 73 a4             	push   -0x5c(%ebx)
8010282e:	e8 9d d8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102833:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102837:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010283a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010283c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010283f:	83 e0 07             	and    $0x7,%eax
80102842:	c1 e0 06             	shl    $0x6,%eax
80102845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102849:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010284c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102850:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102853:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102857:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010285b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010285f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102863:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102867:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010286a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010286d:	6a 34                	push   $0x34
8010286f:	53                   	push   %ebx
80102870:	50                   	push   %eax
80102871:	e8 ca 2f 00 00       	call   80105840 <memmove>
  log_write(bp);
80102876:	89 34 24             	mov    %esi,(%esp)
80102879:	e8 02 18 00 00       	call   80104080 <log_write>
  brelse(bp);
8010287e:	89 75 08             	mov    %esi,0x8(%ebp)
80102881:	83 c4 10             	add    $0x10,%esp
}
80102884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102887:	5b                   	pop    %ebx
80102888:	5e                   	pop    %esi
80102889:	5d                   	pop    %ebp
  brelse(bp);
8010288a:	e9 61 d9 ff ff       	jmp    801001f0 <brelse>
8010288f:	90                   	nop

80102890 <idup>:
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	53                   	push   %ebx
80102894:	83 ec 10             	sub    $0x10,%esp
80102897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010289a:	68 00 15 11 80       	push   $0x80111500
8010289f:	e8 3c 2e 00 00       	call   801056e0 <acquire>
  ip->ref++;
801028a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801028a8:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
801028af:	e8 cc 2d 00 00       	call   80105680 <release>
}
801028b4:	89 d8                	mov    %ebx,%eax
801028b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b9:	c9                   	leave  
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <ilock>:
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	56                   	push   %esi
801028c4:	53                   	push   %ebx
801028c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801028c8:	85 db                	test   %ebx,%ebx
801028ca:	0f 84 b7 00 00 00    	je     80102987 <ilock+0xc7>
801028d0:	8b 53 08             	mov    0x8(%ebx),%edx
801028d3:	85 d2                	test   %edx,%edx
801028d5:	0f 8e ac 00 00 00    	jle    80102987 <ilock+0xc7>
  acquiresleep(&ip->lock);
801028db:	83 ec 0c             	sub    $0xc,%esp
801028de:	8d 43 0c             	lea    0xc(%ebx),%eax
801028e1:	50                   	push   %eax
801028e2:	e8 39 2b 00 00       	call   80105420 <acquiresleep>
  if(ip->valid == 0){
801028e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801028ea:	83 c4 10             	add    $0x10,%esp
801028ed:	85 c0                	test   %eax,%eax
801028ef:	74 0f                	je     80102900 <ilock+0x40>
}
801028f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f4:	5b                   	pop    %ebx
801028f5:	5e                   	pop    %esi
801028f6:	5d                   	pop    %ebp
801028f7:	c3                   	ret    
801028f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102900:	8b 43 04             	mov    0x4(%ebx),%eax
80102903:	83 ec 08             	sub    $0x8,%esp
80102906:	c1 e8 03             	shr    $0x3,%eax
80102909:	03 05 68 31 11 80    	add    0x80113168,%eax
8010290f:	50                   	push   %eax
80102910:	ff 33                	push   (%ebx)
80102912:	e8 b9 d7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102917:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010291a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010291c:	8b 43 04             	mov    0x4(%ebx),%eax
8010291f:	83 e0 07             	and    $0x7,%eax
80102922:	c1 e0 06             	shl    $0x6,%eax
80102925:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102929:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010292c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010292f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102933:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102937:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010293b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010293f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102943:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102947:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010294b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010294e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102951:	6a 34                	push   $0x34
80102953:	50                   	push   %eax
80102954:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102957:	50                   	push   %eax
80102958:	e8 e3 2e 00 00       	call   80105840 <memmove>
    brelse(bp);
8010295d:	89 34 24             	mov    %esi,(%esp)
80102960:	e8 8b d8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102965:	83 c4 10             	add    $0x10,%esp
80102968:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010296d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102974:	0f 85 77 ff ff ff    	jne    801028f1 <ilock+0x31>
      panic("ilock: no type");
8010297a:	83 ec 0c             	sub    $0xc,%esp
8010297d:	68 50 84 10 80       	push   $0x80108450
80102982:	e8 d9 da ff ff       	call   80100460 <panic>
    panic("ilock");
80102987:	83 ec 0c             	sub    $0xc,%esp
8010298a:	68 4a 84 10 80       	push   $0x8010844a
8010298f:	e8 cc da ff ff       	call   80100460 <panic>
80102994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <iunlock>:
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	56                   	push   %esi
801029a4:	53                   	push   %ebx
801029a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801029a8:	85 db                	test   %ebx,%ebx
801029aa:	74 28                	je     801029d4 <iunlock+0x34>
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	8d 73 0c             	lea    0xc(%ebx),%esi
801029b2:	56                   	push   %esi
801029b3:	e8 08 2b 00 00       	call   801054c0 <holdingsleep>
801029b8:	83 c4 10             	add    $0x10,%esp
801029bb:	85 c0                	test   %eax,%eax
801029bd:	74 15                	je     801029d4 <iunlock+0x34>
801029bf:	8b 43 08             	mov    0x8(%ebx),%eax
801029c2:	85 c0                	test   %eax,%eax
801029c4:	7e 0e                	jle    801029d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801029c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801029c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029cc:	5b                   	pop    %ebx
801029cd:	5e                   	pop    %esi
801029ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801029cf:	e9 ac 2a 00 00       	jmp    80105480 <releasesleep>
    panic("iunlock");
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 5f 84 10 80       	push   $0x8010845f
801029dc:	e8 7f da ff ff       	call   80100460 <panic>
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop

801029f0 <iput>:
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 28             	sub    $0x28,%esp
801029f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801029fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801029ff:	57                   	push   %edi
80102a00:	e8 1b 2a 00 00       	call   80105420 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102a05:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102a08:	83 c4 10             	add    $0x10,%esp
80102a0b:	85 d2                	test   %edx,%edx
80102a0d:	74 07                	je     80102a16 <iput+0x26>
80102a0f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102a14:	74 32                	je     80102a48 <iput+0x58>
  releasesleep(&ip->lock);
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	57                   	push   %edi
80102a1a:	e8 61 2a 00 00       	call   80105480 <releasesleep>
  acquire(&icache.lock);
80102a1f:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
80102a26:	e8 b5 2c 00 00       	call   801056e0 <acquire>
  ip->ref--;
80102a2b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102a2f:	83 c4 10             	add    $0x10,%esp
80102a32:	c7 45 08 00 15 11 80 	movl   $0x80111500,0x8(%ebp)
}
80102a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a3c:	5b                   	pop    %ebx
80102a3d:	5e                   	pop    %esi
80102a3e:	5f                   	pop    %edi
80102a3f:	5d                   	pop    %ebp
  release(&icache.lock);
80102a40:	e9 3b 2c 00 00       	jmp    80105680 <release>
80102a45:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102a48:	83 ec 0c             	sub    $0xc,%esp
80102a4b:	68 00 15 11 80       	push   $0x80111500
80102a50:	e8 8b 2c 00 00       	call   801056e0 <acquire>
    int r = ip->ref;
80102a55:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102a58:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
80102a5f:	e8 1c 2c 00 00       	call   80105680 <release>
    if(r == 1){
80102a64:	83 c4 10             	add    $0x10,%esp
80102a67:	83 fe 01             	cmp    $0x1,%esi
80102a6a:	75 aa                	jne    80102a16 <iput+0x26>
80102a6c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102a72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102a75:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102a78:	89 cf                	mov    %ecx,%edi
80102a7a:	eb 0b                	jmp    80102a87 <iput+0x97>
80102a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102a80:	83 c6 04             	add    $0x4,%esi
80102a83:	39 fe                	cmp    %edi,%esi
80102a85:	74 19                	je     80102aa0 <iput+0xb0>
    if(ip->addrs[i]){
80102a87:	8b 16                	mov    (%esi),%edx
80102a89:	85 d2                	test   %edx,%edx
80102a8b:	74 f3                	je     80102a80 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102a8d:	8b 03                	mov    (%ebx),%eax
80102a8f:	e8 6c f8 ff ff       	call   80102300 <bfree>
      ip->addrs[i] = 0;
80102a94:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102a9a:	eb e4                	jmp    80102a80 <iput+0x90>
80102a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102aa0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102aa9:	85 c0                	test   %eax,%eax
80102aab:	75 2d                	jne    80102ada <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102aad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102ab0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102ab7:	53                   	push   %ebx
80102ab8:	e8 53 fd ff ff       	call   80102810 <iupdate>
      ip->type = 0;
80102abd:	31 c0                	xor    %eax,%eax
80102abf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102ac3:	89 1c 24             	mov    %ebx,(%esp)
80102ac6:	e8 45 fd ff ff       	call   80102810 <iupdate>
      ip->valid = 0;
80102acb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102ad2:	83 c4 10             	add    $0x10,%esp
80102ad5:	e9 3c ff ff ff       	jmp    80102a16 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102ada:	83 ec 08             	sub    $0x8,%esp
80102add:	50                   	push   %eax
80102ade:	ff 33                	push   (%ebx)
80102ae0:	e8 eb d5 ff ff       	call   801000d0 <bread>
80102ae5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102ae8:	83 c4 10             	add    $0x10,%esp
80102aeb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102af1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102af4:	8d 70 5c             	lea    0x5c(%eax),%esi
80102af7:	89 cf                	mov    %ecx,%edi
80102af9:	eb 0c                	jmp    80102b07 <iput+0x117>
80102afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aff:	90                   	nop
80102b00:	83 c6 04             	add    $0x4,%esi
80102b03:	39 f7                	cmp    %esi,%edi
80102b05:	74 0f                	je     80102b16 <iput+0x126>
      if(a[j])
80102b07:	8b 16                	mov    (%esi),%edx
80102b09:	85 d2                	test   %edx,%edx
80102b0b:	74 f3                	je     80102b00 <iput+0x110>
        bfree(ip->dev, a[j]);
80102b0d:	8b 03                	mov    (%ebx),%eax
80102b0f:	e8 ec f7 ff ff       	call   80102300 <bfree>
80102b14:	eb ea                	jmp    80102b00 <iput+0x110>
    brelse(bp);
80102b16:	83 ec 0c             	sub    $0xc,%esp
80102b19:	ff 75 e4             	push   -0x1c(%ebp)
80102b1c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102b1f:	e8 cc d6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102b24:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102b2a:	8b 03                	mov    (%ebx),%eax
80102b2c:	e8 cf f7 ff ff       	call   80102300 <bfree>
    ip->addrs[NDIRECT] = 0;
80102b31:	83 c4 10             	add    $0x10,%esp
80102b34:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102b3b:	00 00 00 
80102b3e:	e9 6a ff ff ff       	jmp    80102aad <iput+0xbd>
80102b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b50 <iunlockput>:
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
80102b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102b58:	85 db                	test   %ebx,%ebx
80102b5a:	74 34                	je     80102b90 <iunlockput+0x40>
80102b5c:	83 ec 0c             	sub    $0xc,%esp
80102b5f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102b62:	56                   	push   %esi
80102b63:	e8 58 29 00 00       	call   801054c0 <holdingsleep>
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	74 21                	je     80102b90 <iunlockput+0x40>
80102b6f:	8b 43 08             	mov    0x8(%ebx),%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	7e 1a                	jle    80102b90 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102b76:	83 ec 0c             	sub    $0xc,%esp
80102b79:	56                   	push   %esi
80102b7a:	e8 01 29 00 00       	call   80105480 <releasesleep>
  iput(ip);
80102b7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102b82:	83 c4 10             	add    $0x10,%esp
}
80102b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b88:	5b                   	pop    %ebx
80102b89:	5e                   	pop    %esi
80102b8a:	5d                   	pop    %ebp
  iput(ip);
80102b8b:	e9 60 fe ff ff       	jmp    801029f0 <iput>
    panic("iunlock");
80102b90:	83 ec 0c             	sub    $0xc,%esp
80102b93:	68 5f 84 10 80       	push   $0x8010845f
80102b98:	e8 c3 d8 ff ff       	call   80100460 <panic>
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ba0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	8b 55 08             	mov    0x8(%ebp),%edx
80102ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102ba9:	8b 0a                	mov    (%edx),%ecx
80102bab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102bae:	8b 4a 04             	mov    0x4(%edx),%ecx
80102bb1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102bb4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102bb8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102bbb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102bbf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102bc3:	8b 52 58             	mov    0x58(%edx),%edx
80102bc6:	89 50 10             	mov    %edx,0x10(%eax)
}
80102bc9:	5d                   	pop    %ebp
80102bca:	c3                   	ret    
80102bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop

80102bd0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	57                   	push   %edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 1c             	sub    $0x1c,%esp
80102bd9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80102bdf:	8b 75 10             	mov    0x10(%ebp),%esi
80102be2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102be5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102be8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102bed:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bf0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102bf3:	0f 84 a7 00 00 00    	je     80102ca0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102bf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102bfc:	8b 40 58             	mov    0x58(%eax),%eax
80102bff:	39 c6                	cmp    %eax,%esi
80102c01:	0f 87 ba 00 00 00    	ja     80102cc1 <readi+0xf1>
80102c07:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102c0a:	31 c9                	xor    %ecx,%ecx
80102c0c:	89 da                	mov    %ebx,%edx
80102c0e:	01 f2                	add    %esi,%edx
80102c10:	0f 92 c1             	setb   %cl
80102c13:	89 cf                	mov    %ecx,%edi
80102c15:	0f 82 a6 00 00 00    	jb     80102cc1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102c1b:	89 c1                	mov    %eax,%ecx
80102c1d:	29 f1                	sub    %esi,%ecx
80102c1f:	39 d0                	cmp    %edx,%eax
80102c21:	0f 43 cb             	cmovae %ebx,%ecx
80102c24:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102c27:	85 c9                	test   %ecx,%ecx
80102c29:	74 67                	je     80102c92 <readi+0xc2>
80102c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102c30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102c33:	89 f2                	mov    %esi,%edx
80102c35:	c1 ea 09             	shr    $0x9,%edx
80102c38:	89 d8                	mov    %ebx,%eax
80102c3a:	e8 51 f9 ff ff       	call   80102590 <bmap>
80102c3f:	83 ec 08             	sub    $0x8,%esp
80102c42:	50                   	push   %eax
80102c43:	ff 33                	push   (%ebx)
80102c45:	e8 86 d4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102c4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102c4d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102c52:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102c54:	89 f0                	mov    %esi,%eax
80102c56:	25 ff 01 00 00       	and    $0x1ff,%eax
80102c5b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102c5d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102c60:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102c62:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102c66:	39 d9                	cmp    %ebx,%ecx
80102c68:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102c6b:	83 c4 0c             	add    $0xc,%esp
80102c6e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102c6f:	01 df                	add    %ebx,%edi
80102c71:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102c73:	50                   	push   %eax
80102c74:	ff 75 e0             	push   -0x20(%ebp)
80102c77:	e8 c4 2b 00 00       	call   80105840 <memmove>
    brelse(bp);
80102c7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102c7f:	89 14 24             	mov    %edx,(%esp)
80102c82:	e8 69 d5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102c87:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102c8a:	83 c4 10             	add    $0x10,%esp
80102c8d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102c90:	77 9e                	ja     80102c30 <readi+0x60>
  }
  return n;
80102c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c98:	5b                   	pop    %ebx
80102c99:	5e                   	pop    %esi
80102c9a:	5f                   	pop    %edi
80102c9b:	5d                   	pop    %ebp
80102c9c:	c3                   	ret    
80102c9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102ca0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102ca4:	66 83 f8 09          	cmp    $0x9,%ax
80102ca8:	77 17                	ja     80102cc1 <readi+0xf1>
80102caa:	8b 04 c5 a0 14 11 80 	mov    -0x7feeeb60(,%eax,8),%eax
80102cb1:	85 c0                	test   %eax,%eax
80102cb3:	74 0c                	je     80102cc1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102cb5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cbb:	5b                   	pop    %ebx
80102cbc:	5e                   	pop    %esi
80102cbd:	5f                   	pop    %edi
80102cbe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102cbf:	ff e0                	jmp    *%eax
      return -1;
80102cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cc6:	eb cd                	jmp    80102c95 <readi+0xc5>
80102cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	57                   	push   %edi
80102cd4:	56                   	push   %esi
80102cd5:	53                   	push   %ebx
80102cd6:	83 ec 1c             	sub    $0x1c,%esp
80102cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80102cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
80102cdf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102ce2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102ce7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80102cea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ced:	8b 75 10             	mov    0x10(%ebp),%esi
80102cf0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102cf3:	0f 84 b7 00 00 00    	je     80102db0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102cfc:	3b 70 58             	cmp    0x58(%eax),%esi
80102cff:	0f 87 e7 00 00 00    	ja     80102dec <writei+0x11c>
80102d05:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102d08:	31 d2                	xor    %edx,%edx
80102d0a:	89 f8                	mov    %edi,%eax
80102d0c:	01 f0                	add    %esi,%eax
80102d0e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102d11:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102d16:	0f 87 d0 00 00 00    	ja     80102dec <writei+0x11c>
80102d1c:	85 d2                	test   %edx,%edx
80102d1e:	0f 85 c8 00 00 00    	jne    80102dec <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102d24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102d2b:	85 ff                	test   %edi,%edi
80102d2d:	74 72                	je     80102da1 <writei+0xd1>
80102d2f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102d30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102d33:	89 f2                	mov    %esi,%edx
80102d35:	c1 ea 09             	shr    $0x9,%edx
80102d38:	89 f8                	mov    %edi,%eax
80102d3a:	e8 51 f8 ff ff       	call   80102590 <bmap>
80102d3f:	83 ec 08             	sub    $0x8,%esp
80102d42:	50                   	push   %eax
80102d43:	ff 37                	push   (%edi)
80102d45:	e8 86 d3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102d4a:	b9 00 02 00 00       	mov    $0x200,%ecx
80102d4f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102d52:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102d55:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102d57:	89 f0                	mov    %esi,%eax
80102d59:	25 ff 01 00 00       	and    $0x1ff,%eax
80102d5e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102d60:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102d64:	39 d9                	cmp    %ebx,%ecx
80102d66:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102d69:	83 c4 0c             	add    $0xc,%esp
80102d6c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102d6d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80102d6f:	ff 75 dc             	push   -0x24(%ebp)
80102d72:	50                   	push   %eax
80102d73:	e8 c8 2a 00 00       	call   80105840 <memmove>
    log_write(bp);
80102d78:	89 3c 24             	mov    %edi,(%esp)
80102d7b:	e8 00 13 00 00       	call   80104080 <log_write>
    brelse(bp);
80102d80:	89 3c 24             	mov    %edi,(%esp)
80102d83:	e8 68 d4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102d88:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80102d8b:	83 c4 10             	add    $0x10,%esp
80102d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d91:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102d94:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102d97:	77 97                	ja     80102d30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102d99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d9c:	3b 70 58             	cmp    0x58(%eax),%esi
80102d9f:	77 37                	ja     80102dd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102da7:	5b                   	pop    %ebx
80102da8:	5e                   	pop    %esi
80102da9:	5f                   	pop    %edi
80102daa:	5d                   	pop    %ebp
80102dab:	c3                   	ret    
80102dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102db0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102db4:	66 83 f8 09          	cmp    $0x9,%ax
80102db8:	77 32                	ja     80102dec <writei+0x11c>
80102dba:	8b 04 c5 a4 14 11 80 	mov    -0x7feeeb5c(,%eax,8),%eax
80102dc1:	85 c0                	test   %eax,%eax
80102dc3:	74 27                	je     80102dec <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102dc5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcb:	5b                   	pop    %ebx
80102dcc:	5e                   	pop    %esi
80102dcd:	5f                   	pop    %edi
80102dce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80102dcf:	ff e0                	jmp    *%eax
80102dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102dd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80102ddb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80102dde:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102de1:	50                   	push   %eax
80102de2:	e8 29 fa ff ff       	call   80102810 <iupdate>
80102de7:	83 c4 10             	add    $0x10,%esp
80102dea:	eb b5                	jmp    80102da1 <writei+0xd1>
      return -1;
80102dec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102df1:	eb b1                	jmp    80102da4 <writei+0xd4>
80102df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102e06:	6a 0e                	push   $0xe
80102e08:	ff 75 0c             	push   0xc(%ebp)
80102e0b:	ff 75 08             	push   0x8(%ebp)
80102e0e:	e8 9d 2a 00 00       	call   801058b0 <strncmp>
}
80102e13:	c9                   	leave  
80102e14:	c3                   	ret    
80102e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	57                   	push   %edi
80102e24:	56                   	push   %esi
80102e25:	53                   	push   %ebx
80102e26:	83 ec 1c             	sub    $0x1c,%esp
80102e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102e2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102e31:	0f 85 85 00 00 00    	jne    80102ebc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102e37:	8b 53 58             	mov    0x58(%ebx),%edx
80102e3a:	31 ff                	xor    %edi,%edi
80102e3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102e3f:	85 d2                	test   %edx,%edx
80102e41:	74 3e                	je     80102e81 <dirlookup+0x61>
80102e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e47:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102e48:	6a 10                	push   $0x10
80102e4a:	57                   	push   %edi
80102e4b:	56                   	push   %esi
80102e4c:	53                   	push   %ebx
80102e4d:	e8 7e fd ff ff       	call   80102bd0 <readi>
80102e52:	83 c4 10             	add    $0x10,%esp
80102e55:	83 f8 10             	cmp    $0x10,%eax
80102e58:	75 55                	jne    80102eaf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80102e5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102e5f:	74 18                	je     80102e79 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102e61:	83 ec 04             	sub    $0x4,%esp
80102e64:	8d 45 da             	lea    -0x26(%ebp),%eax
80102e67:	6a 0e                	push   $0xe
80102e69:	50                   	push   %eax
80102e6a:	ff 75 0c             	push   0xc(%ebp)
80102e6d:	e8 3e 2a 00 00       	call   801058b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102e72:	83 c4 10             	add    $0x10,%esp
80102e75:	85 c0                	test   %eax,%eax
80102e77:	74 17                	je     80102e90 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102e79:	83 c7 10             	add    $0x10,%edi
80102e7c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102e7f:	72 c7                	jb     80102e48 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102e84:	31 c0                	xor    %eax,%eax
}
80102e86:	5b                   	pop    %ebx
80102e87:	5e                   	pop    %esi
80102e88:	5f                   	pop    %edi
80102e89:	5d                   	pop    %ebp
80102e8a:	c3                   	ret    
80102e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop
      if(poff)
80102e90:	8b 45 10             	mov    0x10(%ebp),%eax
80102e93:	85 c0                	test   %eax,%eax
80102e95:	74 05                	je     80102e9c <dirlookup+0x7c>
        *poff = off;
80102e97:	8b 45 10             	mov    0x10(%ebp),%eax
80102e9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102e9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102ea0:	8b 03                	mov    (%ebx),%eax
80102ea2:	e8 e9 f5 ff ff       	call   80102490 <iget>
}
80102ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaa:	5b                   	pop    %ebx
80102eab:	5e                   	pop    %esi
80102eac:	5f                   	pop    %edi
80102ead:	5d                   	pop    %ebp
80102eae:	c3                   	ret    
      panic("dirlookup read");
80102eaf:	83 ec 0c             	sub    $0xc,%esp
80102eb2:	68 79 84 10 80       	push   $0x80108479
80102eb7:	e8 a4 d5 ff ff       	call   80100460 <panic>
    panic("dirlookup not DIR");
80102ebc:	83 ec 0c             	sub    $0xc,%esp
80102ebf:	68 67 84 10 80       	push   $0x80108467
80102ec4:	e8 97 d5 ff ff       	call   80100460 <panic>
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ed0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	57                   	push   %edi
80102ed4:	56                   	push   %esi
80102ed5:	53                   	push   %ebx
80102ed6:	89 c3                	mov    %eax,%ebx
80102ed8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102edb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80102ede:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102ee1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102ee4:	0f 84 64 01 00 00    	je     8010304e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102eea:	e8 c1 1b 00 00       	call   80104ab0 <myproc>
  acquire(&icache.lock);
80102eef:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102ef2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102ef5:	68 00 15 11 80       	push   $0x80111500
80102efa:	e8 e1 27 00 00       	call   801056e0 <acquire>
  ip->ref++;
80102eff:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102f03:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
80102f0a:	e8 71 27 00 00       	call   80105680 <release>
80102f0f:	83 c4 10             	add    $0x10,%esp
80102f12:	eb 07                	jmp    80102f1b <namex+0x4b>
80102f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102f18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102f1b:	0f b6 03             	movzbl (%ebx),%eax
80102f1e:	3c 2f                	cmp    $0x2f,%al
80102f20:	74 f6                	je     80102f18 <namex+0x48>
  if(*path == 0)
80102f22:	84 c0                	test   %al,%al
80102f24:	0f 84 06 01 00 00    	je     80103030 <namex+0x160>
  while(*path != '/' && *path != 0)
80102f2a:	0f b6 03             	movzbl (%ebx),%eax
80102f2d:	84 c0                	test   %al,%al
80102f2f:	0f 84 10 01 00 00    	je     80103045 <namex+0x175>
80102f35:	89 df                	mov    %ebx,%edi
80102f37:	3c 2f                	cmp    $0x2f,%al
80102f39:	0f 84 06 01 00 00    	je     80103045 <namex+0x175>
80102f3f:	90                   	nop
80102f40:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102f44:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102f47:	3c 2f                	cmp    $0x2f,%al
80102f49:	74 04                	je     80102f4f <namex+0x7f>
80102f4b:	84 c0                	test   %al,%al
80102f4d:	75 f1                	jne    80102f40 <namex+0x70>
  len = path - s;
80102f4f:	89 f8                	mov    %edi,%eax
80102f51:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102f53:	83 f8 0d             	cmp    $0xd,%eax
80102f56:	0f 8e ac 00 00 00    	jle    80103008 <namex+0x138>
    memmove(name, s, DIRSIZ);
80102f5c:	83 ec 04             	sub    $0x4,%esp
80102f5f:	6a 0e                	push   $0xe
80102f61:	53                   	push   %ebx
    path++;
80102f62:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102f64:	ff 75 e4             	push   -0x1c(%ebp)
80102f67:	e8 d4 28 00 00       	call   80105840 <memmove>
80102f6c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80102f6f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102f72:	75 0c                	jne    80102f80 <namex+0xb0>
80102f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102f78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102f7b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102f7e:	74 f8                	je     80102f78 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102f80:	83 ec 0c             	sub    $0xc,%esp
80102f83:	56                   	push   %esi
80102f84:	e8 37 f9 ff ff       	call   801028c0 <ilock>
    if(ip->type != T_DIR){
80102f89:	83 c4 10             	add    $0x10,%esp
80102f8c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102f91:	0f 85 cd 00 00 00    	jne    80103064 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102f97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102f9a:	85 c0                	test   %eax,%eax
80102f9c:	74 09                	je     80102fa7 <namex+0xd7>
80102f9e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102fa1:	0f 84 22 01 00 00    	je     801030c9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102fa7:	83 ec 04             	sub    $0x4,%esp
80102faa:	6a 00                	push   $0x0
80102fac:	ff 75 e4             	push   -0x1c(%ebp)
80102faf:	56                   	push   %esi
80102fb0:	e8 6b fe ff ff       	call   80102e20 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102fb5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102fb8:	83 c4 10             	add    $0x10,%esp
80102fbb:	89 c7                	mov    %eax,%edi
80102fbd:	85 c0                	test   %eax,%eax
80102fbf:	0f 84 e1 00 00 00    	je     801030a6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102fc5:	83 ec 0c             	sub    $0xc,%esp
80102fc8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102fcb:	52                   	push   %edx
80102fcc:	e8 ef 24 00 00       	call   801054c0 <holdingsleep>
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	85 c0                	test   %eax,%eax
80102fd6:	0f 84 30 01 00 00    	je     8010310c <namex+0x23c>
80102fdc:	8b 56 08             	mov    0x8(%esi),%edx
80102fdf:	85 d2                	test   %edx,%edx
80102fe1:	0f 8e 25 01 00 00    	jle    8010310c <namex+0x23c>
  releasesleep(&ip->lock);
80102fe7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102fea:	83 ec 0c             	sub    $0xc,%esp
80102fed:	52                   	push   %edx
80102fee:	e8 8d 24 00 00       	call   80105480 <releasesleep>
  iput(ip);
80102ff3:	89 34 24             	mov    %esi,(%esp)
80102ff6:	89 fe                	mov    %edi,%esi
80102ff8:	e8 f3 f9 ff ff       	call   801029f0 <iput>
80102ffd:	83 c4 10             	add    $0x10,%esp
80103000:	e9 16 ff ff ff       	jmp    80102f1b <namex+0x4b>
80103005:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80103008:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010300b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010300e:	83 ec 04             	sub    $0x4,%esp
80103011:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103014:	50                   	push   %eax
80103015:	53                   	push   %ebx
    name[len] = 0;
80103016:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80103018:	ff 75 e4             	push   -0x1c(%ebp)
8010301b:	e8 20 28 00 00       	call   80105840 <memmove>
    name[len] = 0;
80103020:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103023:	83 c4 10             	add    $0x10,%esp
80103026:	c6 02 00             	movb   $0x0,(%edx)
80103029:	e9 41 ff ff ff       	jmp    80102f6f <namex+0x9f>
8010302e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80103030:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103033:	85 c0                	test   %eax,%eax
80103035:	0f 85 be 00 00 00    	jne    801030f9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010303b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303e:	89 f0                	mov    %esi,%eax
80103040:	5b                   	pop    %ebx
80103041:	5e                   	pop    %esi
80103042:	5f                   	pop    %edi
80103043:	5d                   	pop    %ebp
80103044:	c3                   	ret    
  while(*path != '/' && *path != 0)
80103045:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103048:	89 df                	mov    %ebx,%edi
8010304a:	31 c0                	xor    %eax,%eax
8010304c:	eb c0                	jmp    8010300e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010304e:	ba 01 00 00 00       	mov    $0x1,%edx
80103053:	b8 01 00 00 00       	mov    $0x1,%eax
80103058:	e8 33 f4 ff ff       	call   80102490 <iget>
8010305d:	89 c6                	mov    %eax,%esi
8010305f:	e9 b7 fe ff ff       	jmp    80102f1b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103064:	83 ec 0c             	sub    $0xc,%esp
80103067:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010306a:	53                   	push   %ebx
8010306b:	e8 50 24 00 00       	call   801054c0 <holdingsleep>
80103070:	83 c4 10             	add    $0x10,%esp
80103073:	85 c0                	test   %eax,%eax
80103075:	0f 84 91 00 00 00    	je     8010310c <namex+0x23c>
8010307b:	8b 46 08             	mov    0x8(%esi),%eax
8010307e:	85 c0                	test   %eax,%eax
80103080:	0f 8e 86 00 00 00    	jle    8010310c <namex+0x23c>
  releasesleep(&ip->lock);
80103086:	83 ec 0c             	sub    $0xc,%esp
80103089:	53                   	push   %ebx
8010308a:	e8 f1 23 00 00       	call   80105480 <releasesleep>
  iput(ip);
8010308f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103092:	31 f6                	xor    %esi,%esi
  iput(ip);
80103094:	e8 57 f9 ff ff       	call   801029f0 <iput>
      return 0;
80103099:	83 c4 10             	add    $0x10,%esp
}
8010309c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309f:	89 f0                	mov    %esi,%eax
801030a1:	5b                   	pop    %ebx
801030a2:	5e                   	pop    %esi
801030a3:	5f                   	pop    %edi
801030a4:	5d                   	pop    %ebp
801030a5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801030a6:	83 ec 0c             	sub    $0xc,%esp
801030a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801030ac:	52                   	push   %edx
801030ad:	e8 0e 24 00 00       	call   801054c0 <holdingsleep>
801030b2:	83 c4 10             	add    $0x10,%esp
801030b5:	85 c0                	test   %eax,%eax
801030b7:	74 53                	je     8010310c <namex+0x23c>
801030b9:	8b 4e 08             	mov    0x8(%esi),%ecx
801030bc:	85 c9                	test   %ecx,%ecx
801030be:	7e 4c                	jle    8010310c <namex+0x23c>
  releasesleep(&ip->lock);
801030c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801030c3:	83 ec 0c             	sub    $0xc,%esp
801030c6:	52                   	push   %edx
801030c7:	eb c1                	jmp    8010308a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801030c9:	83 ec 0c             	sub    $0xc,%esp
801030cc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801030cf:	53                   	push   %ebx
801030d0:	e8 eb 23 00 00       	call   801054c0 <holdingsleep>
801030d5:	83 c4 10             	add    $0x10,%esp
801030d8:	85 c0                	test   %eax,%eax
801030da:	74 30                	je     8010310c <namex+0x23c>
801030dc:	8b 7e 08             	mov    0x8(%esi),%edi
801030df:	85 ff                	test   %edi,%edi
801030e1:	7e 29                	jle    8010310c <namex+0x23c>
  releasesleep(&ip->lock);
801030e3:	83 ec 0c             	sub    $0xc,%esp
801030e6:	53                   	push   %ebx
801030e7:	e8 94 23 00 00       	call   80105480 <releasesleep>
}
801030ec:	83 c4 10             	add    $0x10,%esp
}
801030ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f2:	89 f0                	mov    %esi,%eax
801030f4:	5b                   	pop    %ebx
801030f5:	5e                   	pop    %esi
801030f6:	5f                   	pop    %edi
801030f7:	5d                   	pop    %ebp
801030f8:	c3                   	ret    
    iput(ip);
801030f9:	83 ec 0c             	sub    $0xc,%esp
801030fc:	56                   	push   %esi
    return 0;
801030fd:	31 f6                	xor    %esi,%esi
    iput(ip);
801030ff:	e8 ec f8 ff ff       	call   801029f0 <iput>
    return 0;
80103104:	83 c4 10             	add    $0x10,%esp
80103107:	e9 2f ff ff ff       	jmp    8010303b <namex+0x16b>
    panic("iunlock");
8010310c:	83 ec 0c             	sub    $0xc,%esp
8010310f:	68 5f 84 10 80       	push   $0x8010845f
80103114:	e8 47 d3 ff ff       	call   80100460 <panic>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103120 <dirlink>:
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 20             	sub    $0x20,%esp
80103129:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010312c:	6a 00                	push   $0x0
8010312e:	ff 75 0c             	push   0xc(%ebp)
80103131:	53                   	push   %ebx
80103132:	e8 e9 fc ff ff       	call   80102e20 <dirlookup>
80103137:	83 c4 10             	add    $0x10,%esp
8010313a:	85 c0                	test   %eax,%eax
8010313c:	75 67                	jne    801031a5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010313e:	8b 7b 58             	mov    0x58(%ebx),%edi
80103141:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103144:	85 ff                	test   %edi,%edi
80103146:	74 29                	je     80103171 <dirlink+0x51>
80103148:	31 ff                	xor    %edi,%edi
8010314a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010314d:	eb 09                	jmp    80103158 <dirlink+0x38>
8010314f:	90                   	nop
80103150:	83 c7 10             	add    $0x10,%edi
80103153:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103156:	73 19                	jae    80103171 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103158:	6a 10                	push   $0x10
8010315a:	57                   	push   %edi
8010315b:	56                   	push   %esi
8010315c:	53                   	push   %ebx
8010315d:	e8 6e fa ff ff       	call   80102bd0 <readi>
80103162:	83 c4 10             	add    $0x10,%esp
80103165:	83 f8 10             	cmp    $0x10,%eax
80103168:	75 4e                	jne    801031b8 <dirlink+0x98>
    if(de.inum == 0)
8010316a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010316f:	75 df                	jne    80103150 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103171:	83 ec 04             	sub    $0x4,%esp
80103174:	8d 45 da             	lea    -0x26(%ebp),%eax
80103177:	6a 0e                	push   $0xe
80103179:	ff 75 0c             	push   0xc(%ebp)
8010317c:	50                   	push   %eax
8010317d:	e8 7e 27 00 00       	call   80105900 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103182:	6a 10                	push   $0x10
  de.inum = inum;
80103184:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103187:	57                   	push   %edi
80103188:	56                   	push   %esi
80103189:	53                   	push   %ebx
  de.inum = inum;
8010318a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010318e:	e8 3d fb ff ff       	call   80102cd0 <writei>
80103193:	83 c4 20             	add    $0x20,%esp
80103196:	83 f8 10             	cmp    $0x10,%eax
80103199:	75 2a                	jne    801031c5 <dirlink+0xa5>
  return 0;
8010319b:	31 c0                	xor    %eax,%eax
}
8010319d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a0:	5b                   	pop    %ebx
801031a1:	5e                   	pop    %esi
801031a2:	5f                   	pop    %edi
801031a3:	5d                   	pop    %ebp
801031a4:	c3                   	ret    
    iput(ip);
801031a5:	83 ec 0c             	sub    $0xc,%esp
801031a8:	50                   	push   %eax
801031a9:	e8 42 f8 ff ff       	call   801029f0 <iput>
    return -1;
801031ae:	83 c4 10             	add    $0x10,%esp
801031b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031b6:	eb e5                	jmp    8010319d <dirlink+0x7d>
      panic("dirlink read");
801031b8:	83 ec 0c             	sub    $0xc,%esp
801031bb:	68 88 84 10 80       	push   $0x80108488
801031c0:	e8 9b d2 ff ff       	call   80100460 <panic>
    panic("dirlink");
801031c5:	83 ec 0c             	sub    $0xc,%esp
801031c8:	68 5e 8a 10 80       	push   $0x80108a5e
801031cd:	e8 8e d2 ff ff       	call   80100460 <panic>
801031d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031e0 <namei>:

struct inode*
namei(char *path)
{
801031e0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801031e1:	31 d2                	xor    %edx,%edx
{
801031e3:	89 e5                	mov    %esp,%ebp
801031e5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801031e8:	8b 45 08             	mov    0x8(%ebp),%eax
801031eb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801031ee:	e8 dd fc ff ff       	call   80102ed0 <namex>
}
801031f3:	c9                   	leave  
801031f4:	c3                   	ret    
801031f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103200 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80103200:	55                   	push   %ebp
  return namex(path, 1, name);
80103201:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103206:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80103208:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010320b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010320e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010320f:	e9 bc fc ff ff       	jmp    80102ed0 <namex>
80103214:	66 90                	xchg   %ax,%ax
80103216:	66 90                	xchg   %ax,%ax
80103218:	66 90                	xchg   %ax,%ax
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103229:	85 c0                	test   %eax,%eax
8010322b:	0f 84 b4 00 00 00    	je     801032e5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103231:	8b 70 08             	mov    0x8(%eax),%esi
80103234:	89 c3                	mov    %eax,%ebx
80103236:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010323c:	0f 87 96 00 00 00    	ja     801032d8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103242:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324e:	66 90                	xchg   %ax,%ax
80103250:	89 ca                	mov    %ecx,%edx
80103252:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103253:	83 e0 c0             	and    $0xffffffc0,%eax
80103256:	3c 40                	cmp    $0x40,%al
80103258:	75 f6                	jne    80103250 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325a:	31 ff                	xor    %edi,%edi
8010325c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103261:	89 f8                	mov    %edi,%eax
80103263:	ee                   	out    %al,(%dx)
80103264:	b8 01 00 00 00       	mov    $0x1,%eax
80103269:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010326e:	ee                   	out    %al,(%dx)
8010326f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103274:	89 f0                	mov    %esi,%eax
80103276:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103277:	89 f0                	mov    %esi,%eax
80103279:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010327e:	c1 f8 08             	sar    $0x8,%eax
80103281:	ee                   	out    %al,(%dx)
80103282:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103287:	89 f8                	mov    %edi,%eax
80103289:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010328a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010328e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103293:	c1 e0 04             	shl    $0x4,%eax
80103296:	83 e0 10             	and    $0x10,%eax
80103299:	83 c8 e0             	or     $0xffffffe0,%eax
8010329c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010329d:	f6 03 04             	testb  $0x4,(%ebx)
801032a0:	75 16                	jne    801032b8 <idestart+0x98>
801032a2:	b8 20 00 00 00       	mov    $0x20,%eax
801032a7:	89 ca                	mov    %ecx,%edx
801032a9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ad:	5b                   	pop    %ebx
801032ae:	5e                   	pop    %esi
801032af:	5f                   	pop    %edi
801032b0:	5d                   	pop    %ebp
801032b1:	c3                   	ret    
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032b8:	b8 30 00 00 00       	mov    $0x30,%eax
801032bd:	89 ca                	mov    %ecx,%edx
801032bf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801032c0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801032c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801032c8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801032cd:	fc                   	cld    
801032ce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801032d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d3:	5b                   	pop    %ebx
801032d4:	5e                   	pop    %esi
801032d5:	5f                   	pop    %edi
801032d6:	5d                   	pop    %ebp
801032d7:	c3                   	ret    
    panic("incorrect blockno");
801032d8:	83 ec 0c             	sub    $0xc,%esp
801032db:	68 f4 84 10 80       	push   $0x801084f4
801032e0:	e8 7b d1 ff ff       	call   80100460 <panic>
    panic("idestart");
801032e5:	83 ec 0c             	sub    $0xc,%esp
801032e8:	68 eb 84 10 80       	push   $0x801084eb
801032ed:	e8 6e d1 ff ff       	call   80100460 <panic>
801032f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103300 <ideinit>:
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80103306:	68 06 85 10 80       	push   $0x80108506
8010330b:	68 a0 31 11 80       	push   $0x801131a0
80103310:	e8 fb 21 00 00       	call   80105510 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80103315:	58                   	pop    %eax
80103316:	a1 24 33 11 80       	mov    0x80113324,%eax
8010331b:	5a                   	pop    %edx
8010331c:	83 e8 01             	sub    $0x1,%eax
8010331f:	50                   	push   %eax
80103320:	6a 0e                	push   $0xe
80103322:	e8 99 02 00 00       	call   801035c0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103327:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010332f:	90                   	nop
80103330:	ec                   	in     (%dx),%al
80103331:	83 e0 c0             	and    $0xffffffc0,%eax
80103334:	3c 40                	cmp    $0x40,%al
80103336:	75 f8                	jne    80103330 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103338:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010333d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103342:	ee                   	out    %al,(%dx)
80103343:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103348:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010334d:	eb 06                	jmp    80103355 <ideinit+0x55>
8010334f:	90                   	nop
  for(i=0; i<1000; i++){
80103350:	83 e9 01             	sub    $0x1,%ecx
80103353:	74 0f                	je     80103364 <ideinit+0x64>
80103355:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103356:	84 c0                	test   %al,%al
80103358:	74 f6                	je     80103350 <ideinit+0x50>
      havedisk1 = 1;
8010335a:	c7 05 80 31 11 80 01 	movl   $0x1,0x80113180
80103361:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103364:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103369:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010336e:	ee                   	out    %al,(%dx)
}
8010336f:	c9                   	leave  
80103370:	c3                   	ret    
80103371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop

80103380 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103389:	68 a0 31 11 80       	push   $0x801131a0
8010338e:	e8 4d 23 00 00       	call   801056e0 <acquire>

  if((b = idequeue) == 0){
80103393:	8b 1d 84 31 11 80    	mov    0x80113184,%ebx
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	85 db                	test   %ebx,%ebx
8010339e:	74 63                	je     80103403 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801033a0:	8b 43 58             	mov    0x58(%ebx),%eax
801033a3:	a3 84 31 11 80       	mov    %eax,0x80113184

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801033a8:	8b 33                	mov    (%ebx),%esi
801033aa:	f7 c6 04 00 00 00    	test   $0x4,%esi
801033b0:	75 2f                	jne    801033e1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
801033c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801033c1:	89 c1                	mov    %eax,%ecx
801033c3:	83 e1 c0             	and    $0xffffffc0,%ecx
801033c6:	80 f9 40             	cmp    $0x40,%cl
801033c9:	75 f5                	jne    801033c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801033cb:	a8 21                	test   $0x21,%al
801033cd:	75 12                	jne    801033e1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801033cf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801033d2:	b9 80 00 00 00       	mov    $0x80,%ecx
801033d7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801033dc:	fc                   	cld    
801033dd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801033df:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801033e1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801033e4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801033e7:	83 ce 02             	or     $0x2,%esi
801033ea:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801033ec:	53                   	push   %ebx
801033ed:	e8 4e 1e 00 00       	call   80105240 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801033f2:	a1 84 31 11 80       	mov    0x80113184,%eax
801033f7:	83 c4 10             	add    $0x10,%esp
801033fa:	85 c0                	test   %eax,%eax
801033fc:	74 05                	je     80103403 <ideintr+0x83>
    idestart(idequeue);
801033fe:	e8 1d fe ff ff       	call   80103220 <idestart>
    release(&idelock);
80103403:	83 ec 0c             	sub    $0xc,%esp
80103406:	68 a0 31 11 80       	push   $0x801131a0
8010340b:	e8 70 22 00 00       	call   80105680 <release>

  release(&idelock);
}
80103410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103413:	5b                   	pop    %ebx
80103414:	5e                   	pop    %esi
80103415:	5f                   	pop    %edi
80103416:	5d                   	pop    %ebp
80103417:	c3                   	ret    
80103418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341f:	90                   	nop

80103420 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	53                   	push   %ebx
80103424:	83 ec 10             	sub    $0x10,%esp
80103427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010342a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010342d:	50                   	push   %eax
8010342e:	e8 8d 20 00 00       	call   801054c0 <holdingsleep>
80103433:	83 c4 10             	add    $0x10,%esp
80103436:	85 c0                	test   %eax,%eax
80103438:	0f 84 c3 00 00 00    	je     80103501 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010343e:	8b 03                	mov    (%ebx),%eax
80103440:	83 e0 06             	and    $0x6,%eax
80103443:	83 f8 02             	cmp    $0x2,%eax
80103446:	0f 84 a8 00 00 00    	je     801034f4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010344c:	8b 53 04             	mov    0x4(%ebx),%edx
8010344f:	85 d2                	test   %edx,%edx
80103451:	74 0d                	je     80103460 <iderw+0x40>
80103453:	a1 80 31 11 80       	mov    0x80113180,%eax
80103458:	85 c0                	test   %eax,%eax
8010345a:	0f 84 87 00 00 00    	je     801034e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	68 a0 31 11 80       	push   $0x801131a0
80103468:	e8 73 22 00 00       	call   801056e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010346d:	a1 84 31 11 80       	mov    0x80113184,%eax
  b->qnext = 0;
80103472:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	85 c0                	test   %eax,%eax
8010347e:	74 60                	je     801034e0 <iderw+0xc0>
80103480:	89 c2                	mov    %eax,%edx
80103482:	8b 40 58             	mov    0x58(%eax),%eax
80103485:	85 c0                	test   %eax,%eax
80103487:	75 f7                	jne    80103480 <iderw+0x60>
80103489:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010348c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010348e:	39 1d 84 31 11 80    	cmp    %ebx,0x80113184
80103494:	74 3a                	je     801034d0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103496:	8b 03                	mov    (%ebx),%eax
80103498:	83 e0 06             	and    $0x6,%eax
8010349b:	83 f8 02             	cmp    $0x2,%eax
8010349e:	74 1b                	je     801034bb <iderw+0x9b>
    sleep(b, &idelock);
801034a0:	83 ec 08             	sub    $0x8,%esp
801034a3:	68 a0 31 11 80       	push   $0x801131a0
801034a8:	53                   	push   %ebx
801034a9:	e8 d2 1c 00 00       	call   80105180 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801034ae:	8b 03                	mov    (%ebx),%eax
801034b0:	83 c4 10             	add    $0x10,%esp
801034b3:	83 e0 06             	and    $0x6,%eax
801034b6:	83 f8 02             	cmp    $0x2,%eax
801034b9:	75 e5                	jne    801034a0 <iderw+0x80>
  }


  release(&idelock);
801034bb:	c7 45 08 a0 31 11 80 	movl   $0x801131a0,0x8(%ebp)
}
801034c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034c5:	c9                   	leave  
  release(&idelock);
801034c6:	e9 b5 21 00 00       	jmp    80105680 <release>
801034cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034cf:	90                   	nop
    idestart(b);
801034d0:	89 d8                	mov    %ebx,%eax
801034d2:	e8 49 fd ff ff       	call   80103220 <idestart>
801034d7:	eb bd                	jmp    80103496 <iderw+0x76>
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801034e0:	ba 84 31 11 80       	mov    $0x80113184,%edx
801034e5:	eb a5                	jmp    8010348c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801034e7:	83 ec 0c             	sub    $0xc,%esp
801034ea:	68 35 85 10 80       	push   $0x80108535
801034ef:	e8 6c cf ff ff       	call   80100460 <panic>
    panic("iderw: nothing to do");
801034f4:	83 ec 0c             	sub    $0xc,%esp
801034f7:	68 20 85 10 80       	push   $0x80108520
801034fc:	e8 5f cf ff ff       	call   80100460 <panic>
    panic("iderw: buf not locked");
80103501:	83 ec 0c             	sub    $0xc,%esp
80103504:	68 0a 85 10 80       	push   $0x8010850a
80103509:	e8 52 cf ff ff       	call   80100460 <panic>
8010350e:	66 90                	xchg   %ax,%ax

80103510 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80103510:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103511:	c7 05 d4 31 11 80 00 	movl   $0xfec00000,0x801131d4
80103518:	00 c0 fe 
{
8010351b:	89 e5                	mov    %esp,%ebp
8010351d:	56                   	push   %esi
8010351e:	53                   	push   %ebx
  ioapic->reg = reg;
8010351f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80103526:	00 00 00 
  return ioapic->data;
80103529:	8b 15 d4 31 11 80    	mov    0x801131d4,%edx
8010352f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103532:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103538:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010353e:	0f b6 15 20 33 11 80 	movzbl 0x80113320,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103545:	c1 ee 10             	shr    $0x10,%esi
80103548:	89 f0                	mov    %esi,%eax
8010354a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010354d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80103550:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103553:	39 c2                	cmp    %eax,%edx
80103555:	74 16                	je     8010356d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103557:	83 ec 0c             	sub    $0xc,%esp
8010355a:	68 54 85 10 80       	push   $0x80108554
8010355f:	e8 7c d2 ff ff       	call   801007e0 <cprintf>
  ioapic->reg = reg;
80103564:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
8010356a:	83 c4 10             	add    $0x10,%esp
8010356d:	83 c6 21             	add    $0x21,%esi
{
80103570:	ba 10 00 00 00       	mov    $0x10,%edx
80103575:	b8 20 00 00 00       	mov    $0x20,%eax
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80103580:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80103582:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80103584:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
  for(i = 0; i <= maxintr; i++){
8010358a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010358d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80103593:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80103596:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80103599:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010359c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010359e:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
801035a4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801035ab:	39 f0                	cmp    %esi,%eax
801035ad:	75 d1                	jne    80103580 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
801035b5:	c3                   	ret    
801035b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035bd:	8d 76 00             	lea    0x0(%esi),%esi

801035c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801035c0:	55                   	push   %ebp
  ioapic->reg = reg;
801035c1:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
{
801035c7:	89 e5                	mov    %esp,%ebp
801035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801035cc:	8d 50 20             	lea    0x20(%eax),%edx
801035cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801035d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801035d5:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801035db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801035de:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801035e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801035e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801035e6:	a1 d4 31 11 80       	mov    0x801131d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801035eb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801035ee:	89 50 10             	mov    %edx,0x10(%eax)
}
801035f1:	5d                   	pop    %ebp
801035f2:	c3                   	ret    
801035f3:	66 90                	xchg   %ax,%ax
801035f5:	66 90                	xchg   %ax,%ax
801035f7:	66 90                	xchg   %ax,%ax
801035f9:	66 90                	xchg   %ax,%ax
801035fb:	66 90                	xchg   %ax,%ax
801035fd:	66 90                	xchg   %ax,%ax
801035ff:	90                   	nop

80103600 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
80103604:	83 ec 04             	sub    $0x4,%esp
80103607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010360a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80103610:	75 76                	jne    80103688 <kfree+0x88>
80103612:	81 fb 70 70 11 80    	cmp    $0x80117070,%ebx
80103618:	72 6e                	jb     80103688 <kfree+0x88>
8010361a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80103620:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80103625:	77 61                	ja     80103688 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80103627:	83 ec 04             	sub    $0x4,%esp
8010362a:	68 00 10 00 00       	push   $0x1000
8010362f:	6a 01                	push   $0x1
80103631:	53                   	push   %ebx
80103632:	e8 69 21 00 00       	call   801057a0 <memset>

  if(kmem.use_lock)
80103637:	8b 15 14 32 11 80    	mov    0x80113214,%edx
8010363d:	83 c4 10             	add    $0x10,%esp
80103640:	85 d2                	test   %edx,%edx
80103642:	75 1c                	jne    80103660 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80103644:	a1 18 32 11 80       	mov    0x80113218,%eax
80103649:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010364b:	a1 14 32 11 80       	mov    0x80113214,%eax
  kmem.freelist = r;
80103650:	89 1d 18 32 11 80    	mov    %ebx,0x80113218
  if(kmem.use_lock)
80103656:	85 c0                	test   %eax,%eax
80103658:	75 1e                	jne    80103678 <kfree+0x78>
    release(&kmem.lock);
}
8010365a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010365d:	c9                   	leave  
8010365e:	c3                   	ret    
8010365f:	90                   	nop
    acquire(&kmem.lock);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	68 e0 31 11 80       	push   $0x801131e0
80103668:	e8 73 20 00 00       	call   801056e0 <acquire>
8010366d:	83 c4 10             	add    $0x10,%esp
80103670:	eb d2                	jmp    80103644 <kfree+0x44>
80103672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103678:	c7 45 08 e0 31 11 80 	movl   $0x801131e0,0x8(%ebp)
}
8010367f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103682:	c9                   	leave  
    release(&kmem.lock);
80103683:	e9 f8 1f 00 00       	jmp    80105680 <release>
    panic("kfree");
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	68 86 85 10 80       	push   $0x80108586
80103690:	e8 cb cd ff ff       	call   80100460 <panic>
80103695:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036a0 <freerange>:
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801036a4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801036a7:	8b 75 0c             	mov    0xc(%ebp),%esi
801036aa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801036ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801036b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801036b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801036bd:	39 de                	cmp    %ebx,%esi
801036bf:	72 23                	jb     801036e4 <freerange+0x44>
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801036d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801036d7:	50                   	push   %eax
801036d8:	e8 23 ff ff ff       	call   80103600 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801036dd:	83 c4 10             	add    $0x10,%esp
801036e0:	39 f3                	cmp    %esi,%ebx
801036e2:	76 e4                	jbe    801036c8 <freerange+0x28>
}
801036e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036e7:	5b                   	pop    %ebx
801036e8:	5e                   	pop    %esi
801036e9:	5d                   	pop    %ebp
801036ea:	c3                   	ret    
801036eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop

801036f0 <kinit2>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801036f4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801036f7:	8b 75 0c             	mov    0xc(%ebp),%esi
801036fa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801036fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103701:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103707:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010370d:	39 de                	cmp    %ebx,%esi
8010370f:	72 23                	jb     80103734 <kinit2+0x44>
80103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103721:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103727:	50                   	push   %eax
80103728:	e8 d3 fe ff ff       	call   80103600 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010372d:	83 c4 10             	add    $0x10,%esp
80103730:	39 de                	cmp    %ebx,%esi
80103732:	73 e4                	jae    80103718 <kinit2+0x28>
  kmem.use_lock = 1;
80103734:	c7 05 14 32 11 80 01 	movl   $0x1,0x80113214
8010373b:	00 00 00 
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	5b                   	pop    %ebx
80103742:	5e                   	pop    %esi
80103743:	5d                   	pop    %ebp
80103744:	c3                   	ret    
80103745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103750 <kinit1>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
80103755:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103758:	83 ec 08             	sub    $0x8,%esp
8010375b:	68 8c 85 10 80       	push   $0x8010858c
80103760:	68 e0 31 11 80       	push   $0x801131e0
80103765:	e8 a6 1d 00 00       	call   80105510 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010376a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010376d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103770:	c7 05 14 32 11 80 00 	movl   $0x0,0x80113214
80103777:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010377a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103780:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103786:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010378c:	39 de                	cmp    %ebx,%esi
8010378e:	72 1c                	jb     801037ac <kinit1+0x5c>
    kfree(p);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103799:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010379f:	50                   	push   %eax
801037a0:	e8 5b fe ff ff       	call   80103600 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	39 de                	cmp    %ebx,%esi
801037aa:	73 e4                	jae    80103790 <kinit1+0x40>
}
801037ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037af:	5b                   	pop    %ebx
801037b0:	5e                   	pop    %esi
801037b1:	5d                   	pop    %ebp
801037b2:	c3                   	ret    
801037b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801037c0:	a1 14 32 11 80       	mov    0x80113214,%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 1f                	jne    801037e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801037c9:	a1 18 32 11 80       	mov    0x80113218,%eax
  if(r)
801037ce:	85 c0                	test   %eax,%eax
801037d0:	74 0e                	je     801037e0 <kalloc+0x20>
    kmem.freelist = r->next;
801037d2:	8b 10                	mov    (%eax),%edx
801037d4:	89 15 18 32 11 80    	mov    %edx,0x80113218
  if(kmem.use_lock)
801037da:	c3                   	ret    
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801037e0:	c3                   	ret    
801037e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801037e8:	55                   	push   %ebp
801037e9:	89 e5                	mov    %esp,%ebp
801037eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801037ee:	68 e0 31 11 80       	push   $0x801131e0
801037f3:	e8 e8 1e 00 00       	call   801056e0 <acquire>
  r = kmem.freelist;
801037f8:	a1 18 32 11 80       	mov    0x80113218,%eax
  if(kmem.use_lock)
801037fd:	8b 15 14 32 11 80    	mov    0x80113214,%edx
  if(r)
80103803:	83 c4 10             	add    $0x10,%esp
80103806:	85 c0                	test   %eax,%eax
80103808:	74 08                	je     80103812 <kalloc+0x52>
    kmem.freelist = r->next;
8010380a:	8b 08                	mov    (%eax),%ecx
8010380c:	89 0d 18 32 11 80    	mov    %ecx,0x80113218
  if(kmem.use_lock)
80103812:	85 d2                	test   %edx,%edx
80103814:	74 16                	je     8010382c <kalloc+0x6c>
    release(&kmem.lock);
80103816:	83 ec 0c             	sub    $0xc,%esp
80103819:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010381c:	68 e0 31 11 80       	push   $0x801131e0
80103821:	e8 5a 1e 00 00       	call   80105680 <release>
  return (char*)r;
80103826:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103829:	83 c4 10             	add    $0x10,%esp
}
8010382c:	c9                   	leave  
8010382d:	c3                   	ret    
8010382e:	66 90                	xchg   %ax,%ax

80103830 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103830:	ba 64 00 00 00       	mov    $0x64,%edx
80103835:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103836:	a8 01                	test   $0x1,%al
80103838:	0f 84 c2 00 00 00    	je     80103900 <kbdgetc+0xd0>
{
8010383e:	55                   	push   %ebp
8010383f:	ba 60 00 00 00       	mov    $0x60,%edx
80103844:	89 e5                	mov    %esp,%ebp
80103846:	53                   	push   %ebx
80103847:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103848:	8b 1d 1c 32 11 80    	mov    0x8011321c,%ebx
  data = inb(KBDATAP);
8010384e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103851:	3c e0                	cmp    $0xe0,%al
80103853:	74 5b                	je     801038b0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103855:	89 da                	mov    %ebx,%edx
80103857:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010385a:	84 c0                	test   %al,%al
8010385c:	78 62                	js     801038c0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010385e:	85 d2                	test   %edx,%edx
80103860:	74 09                	je     8010386b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103862:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103865:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103868:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010386b:	0f b6 91 c0 86 10 80 	movzbl -0x7fef7940(%ecx),%edx
  shift ^= togglecode[data];
80103872:	0f b6 81 c0 85 10 80 	movzbl -0x7fef7a40(%ecx),%eax
  shift |= shiftcode[data];
80103879:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010387b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010387d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010387f:	89 15 1c 32 11 80    	mov    %edx,0x8011321c
  c = charcode[shift & (CTL | SHIFT)][data];
80103885:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103888:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010388b:	8b 04 85 a0 85 10 80 	mov    -0x7fef7a60(,%eax,4),%eax
80103892:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103896:	74 0b                	je     801038a3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103898:	8d 50 9f             	lea    -0x61(%eax),%edx
8010389b:	83 fa 19             	cmp    $0x19,%edx
8010389e:	77 48                	ja     801038e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801038a0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801038a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a6:	c9                   	leave  
801038a7:	c3                   	ret    
801038a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038af:	90                   	nop
    shift |= E0ESC;
801038b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801038b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801038b5:	89 1d 1c 32 11 80    	mov    %ebx,0x8011321c
}
801038bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038be:	c9                   	leave  
801038bf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801038c0:	83 e0 7f             	and    $0x7f,%eax
801038c3:	85 d2                	test   %edx,%edx
801038c5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801038c8:	0f b6 81 c0 86 10 80 	movzbl -0x7fef7940(%ecx),%eax
801038cf:	83 c8 40             	or     $0x40,%eax
801038d2:	0f b6 c0             	movzbl %al,%eax
801038d5:	f7 d0                	not    %eax
801038d7:	21 d8                	and    %ebx,%eax
}
801038d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801038dc:	a3 1c 32 11 80       	mov    %eax,0x8011321c
    return 0;
801038e1:	31 c0                	xor    %eax,%eax
}
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    
801038e5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801038e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801038eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801038ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038f1:	c9                   	leave  
      c += 'a' - 'A';
801038f2:	83 f9 1a             	cmp    $0x1a,%ecx
801038f5:	0f 42 c2             	cmovb  %edx,%eax
}
801038f8:	c3                   	ret    
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103905:	c3                   	ret    
80103906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <kbdintr>:

void
kbdintr(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103916:	68 30 38 10 80       	push   $0x80103830
8010391b:	e8 b0 dc ff ff       	call   801015d0 <consoleintr>
}
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	c9                   	leave  
80103924:	c3                   	ret    
80103925:	66 90                	xchg   %ax,%ax
80103927:	66 90                	xchg   %ax,%ax
80103929:	66 90                	xchg   %ax,%ax
8010392b:	66 90                	xchg   %ax,%ax
8010392d:	66 90                	xchg   %ax,%ax
8010392f:	90                   	nop

80103930 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103930:	a1 20 32 11 80       	mov    0x80113220,%eax
80103935:	85 c0                	test   %eax,%eax
80103937:	0f 84 cb 00 00 00    	je     80103a08 <lapicinit+0xd8>
  lapic[index] = value;
8010393d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103944:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103947:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010394a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103951:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103954:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103957:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010395e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103961:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103964:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010396b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010396e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103971:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103978:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010397b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010397e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103985:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103988:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010398b:	8b 50 30             	mov    0x30(%eax),%edx
8010398e:	c1 ea 10             	shr    $0x10,%edx
80103991:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103997:	75 77                	jne    80103a10 <lapicinit+0xe0>
  lapic[index] = value;
80103999:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801039a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801039a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801039a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801039ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801039b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801039b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801039ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801039bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801039c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801039c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801039ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801039cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801039d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801039d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801039da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801039e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801039e4:	8b 50 20             	mov    0x20(%eax),%edx
801039e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ee:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801039f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801039f6:	80 e6 10             	and    $0x10,%dh
801039f9:	75 f5                	jne    801039f0 <lapicinit+0xc0>
  lapic[index] = value;
801039fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103a02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103a05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103a08:	c3                   	ret    
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103a10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103a17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103a1a:	8b 50 20             	mov    0x20(%eax),%edx
}
80103a1d:	e9 77 ff ff ff       	jmp    80103999 <lapicinit+0x69>
80103a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103a30:	a1 20 32 11 80       	mov    0x80113220,%eax
80103a35:	85 c0                	test   %eax,%eax
80103a37:	74 07                	je     80103a40 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103a39:	8b 40 20             	mov    0x20(%eax),%eax
80103a3c:	c1 e8 18             	shr    $0x18,%eax
80103a3f:	c3                   	ret    
    return 0;
80103a40:	31 c0                	xor    %eax,%eax
}
80103a42:	c3                   	ret    
80103a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103a50:	a1 20 32 11 80       	mov    0x80113220,%eax
80103a55:	85 c0                	test   %eax,%eax
80103a57:	74 0d                	je     80103a66 <lapiceoi+0x16>
  lapic[index] = value;
80103a59:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103a60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103a63:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103a66:	c3                   	ret    
80103a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103a70:	c3                   	ret    
80103a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7f:	90                   	nop

80103a80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103a80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a81:	b8 0f 00 00 00       	mov    $0xf,%eax
80103a86:	ba 70 00 00 00       	mov    $0x70,%edx
80103a8b:	89 e5                	mov    %esp,%ebp
80103a8d:	53                   	push   %ebx
80103a8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103a91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a94:	ee                   	out    %al,(%dx)
80103a95:	b8 0a 00 00 00       	mov    $0xa,%eax
80103a9a:	ba 71 00 00 00       	mov    $0x71,%edx
80103a9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103aa0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103aa2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103aa5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103aab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103aad:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103ab0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103ab2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103ab5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103ab8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103abe:	a1 20 32 11 80       	mov    0x80113220,%eax
80103ac3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103ac9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103acc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103ad3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ad6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103ad9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103ae0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ae3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103ae6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103aec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103aef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103af5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103af8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103afe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103b07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b0d:	c9                   	leave  
80103b0e:	c3                   	ret    
80103b0f:	90                   	nop

80103b10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103b10:	55                   	push   %ebp
80103b11:	b8 0b 00 00 00       	mov    $0xb,%eax
80103b16:	ba 70 00 00 00       	mov    $0x70,%edx
80103b1b:	89 e5                	mov    %esp,%ebp
80103b1d:	57                   	push   %edi
80103b1e:	56                   	push   %esi
80103b1f:	53                   	push   %ebx
80103b20:	83 ec 4c             	sub    $0x4c,%esp
80103b23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b24:	ba 71 00 00 00       	mov    $0x71,%edx
80103b29:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103b2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103b32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103b35:	8d 76 00             	lea    0x0(%esi),%esi
80103b38:	31 c0                	xor    %eax,%eax
80103b3a:	89 da                	mov    %ebx,%edx
80103b3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103b42:	89 ca                	mov    %ecx,%edx
80103b44:	ec                   	in     (%dx),%al
80103b45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b48:	89 da                	mov    %ebx,%edx
80103b4a:	b8 02 00 00 00       	mov    $0x2,%eax
80103b4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b50:	89 ca                	mov    %ecx,%edx
80103b52:	ec                   	in     (%dx),%al
80103b53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b56:	89 da                	mov    %ebx,%edx
80103b58:	b8 04 00 00 00       	mov    $0x4,%eax
80103b5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b5e:	89 ca                	mov    %ecx,%edx
80103b60:	ec                   	in     (%dx),%al
80103b61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b64:	89 da                	mov    %ebx,%edx
80103b66:	b8 07 00 00 00       	mov    $0x7,%eax
80103b6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b6c:	89 ca                	mov    %ecx,%edx
80103b6e:	ec                   	in     (%dx),%al
80103b6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b72:	89 da                	mov    %ebx,%edx
80103b74:	b8 08 00 00 00       	mov    $0x8,%eax
80103b79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b7a:	89 ca                	mov    %ecx,%edx
80103b7c:	ec                   	in     (%dx),%al
80103b7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b7f:	89 da                	mov    %ebx,%edx
80103b81:	b8 09 00 00 00       	mov    $0x9,%eax
80103b86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b87:	89 ca                	mov    %ecx,%edx
80103b89:	ec                   	in     (%dx),%al
80103b8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b8c:	89 da                	mov    %ebx,%edx
80103b8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103b93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b94:	89 ca                	mov    %ecx,%edx
80103b96:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103b97:	84 c0                	test   %al,%al
80103b99:	78 9d                	js     80103b38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103b9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103b9f:	89 fa                	mov    %edi,%edx
80103ba1:	0f b6 fa             	movzbl %dl,%edi
80103ba4:	89 f2                	mov    %esi,%edx
80103ba6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103ba9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103bad:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bb0:	89 da                	mov    %ebx,%edx
80103bb2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103bb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103bb8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103bbc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103bbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103bc2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103bc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103bc9:	31 c0                	xor    %eax,%eax
80103bcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bcc:	89 ca                	mov    %ecx,%edx
80103bce:	ec                   	in     (%dx),%al
80103bcf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bd2:	89 da                	mov    %ebx,%edx
80103bd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103bd7:	b8 02 00 00 00       	mov    $0x2,%eax
80103bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bdd:	89 ca                	mov    %ecx,%edx
80103bdf:	ec                   	in     (%dx),%al
80103be0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103be3:	89 da                	mov    %ebx,%edx
80103be5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103be8:	b8 04 00 00 00       	mov    $0x4,%eax
80103bed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bee:	89 ca                	mov    %ecx,%edx
80103bf0:	ec                   	in     (%dx),%al
80103bf1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bf4:	89 da                	mov    %ebx,%edx
80103bf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103bf9:	b8 07 00 00 00       	mov    $0x7,%eax
80103bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bff:	89 ca                	mov    %ecx,%edx
80103c01:	ec                   	in     (%dx),%al
80103c02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c05:	89 da                	mov    %ebx,%edx
80103c07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103c0a:	b8 08 00 00 00       	mov    $0x8,%eax
80103c0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c10:	89 ca                	mov    %ecx,%edx
80103c12:	ec                   	in     (%dx),%al
80103c13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c16:	89 da                	mov    %ebx,%edx
80103c18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103c1b:	b8 09 00 00 00       	mov    $0x9,%eax
80103c20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c21:	89 ca                	mov    %ecx,%edx
80103c23:	ec                   	in     (%dx),%al
80103c24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103c27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103c2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103c30:	6a 18                	push   $0x18
80103c32:	50                   	push   %eax
80103c33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103c36:	50                   	push   %eax
80103c37:	e8 b4 1b 00 00       	call   801057f0 <memcmp>
80103c3c:	83 c4 10             	add    $0x10,%esp
80103c3f:	85 c0                	test   %eax,%eax
80103c41:	0f 85 f1 fe ff ff    	jne    80103b38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103c47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103c4b:	75 78                	jne    80103cc5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103c4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103c50:	89 c2                	mov    %eax,%edx
80103c52:	83 e0 0f             	and    $0xf,%eax
80103c55:	c1 ea 04             	shr    $0x4,%edx
80103c58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103c5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103c5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103c61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103c64:	89 c2                	mov    %eax,%edx
80103c66:	83 e0 0f             	and    $0xf,%eax
80103c69:	c1 ea 04             	shr    $0x4,%edx
80103c6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103c6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103c72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103c75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103c78:	89 c2                	mov    %eax,%edx
80103c7a:	83 e0 0f             	and    $0xf,%eax
80103c7d:	c1 ea 04             	shr    $0x4,%edx
80103c80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103c83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103c86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103c89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103c8c:	89 c2                	mov    %eax,%edx
80103c8e:	83 e0 0f             	and    $0xf,%eax
80103c91:	c1 ea 04             	shr    $0x4,%edx
80103c94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103c97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103c9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103c9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103ca0:	89 c2                	mov    %eax,%edx
80103ca2:	83 e0 0f             	and    $0xf,%eax
80103ca5:	c1 ea 04             	shr    $0x4,%edx
80103ca8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103cab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103cae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103cb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103cb4:	89 c2                	mov    %eax,%edx
80103cb6:	83 e0 0f             	and    $0xf,%eax
80103cb9:	c1 ea 04             	shr    $0x4,%edx
80103cbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103cbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103cc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103cc5:	8b 75 08             	mov    0x8(%ebp),%esi
80103cc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103ccb:	89 06                	mov    %eax,(%esi)
80103ccd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103cd0:	89 46 04             	mov    %eax,0x4(%esi)
80103cd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103cd6:	89 46 08             	mov    %eax,0x8(%esi)
80103cd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103cdc:	89 46 0c             	mov    %eax,0xc(%esi)
80103cdf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103ce2:	89 46 10             	mov    %eax,0x10(%esi)
80103ce5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103ce8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103ceb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cf5:	5b                   	pop    %ebx
80103cf6:	5e                   	pop    %esi
80103cf7:	5f                   	pop    %edi
80103cf8:	5d                   	pop    %ebp
80103cf9:	c3                   	ret    
80103cfa:	66 90                	xchg   %ax,%ax
80103cfc:	66 90                	xchg   %ax,%ax
80103cfe:	66 90                	xchg   %ax,%ax

80103d00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103d00:	8b 0d 88 32 11 80    	mov    0x80113288,%ecx
80103d06:	85 c9                	test   %ecx,%ecx
80103d08:	0f 8e 8a 00 00 00    	jle    80103d98 <install_trans+0x98>
{
80103d0e:	55                   	push   %ebp
80103d0f:	89 e5                	mov    %esp,%ebp
80103d11:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103d12:	31 ff                	xor    %edi,%edi
{
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
80103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103d20:	a1 74 32 11 80       	mov    0x80113274,%eax
80103d25:	83 ec 08             	sub    $0x8,%esp
80103d28:	01 f8                	add    %edi,%eax
80103d2a:	83 c0 01             	add    $0x1,%eax
80103d2d:	50                   	push   %eax
80103d2e:	ff 35 84 32 11 80    	push   0x80113284
80103d34:	e8 97 c3 ff ff       	call   801000d0 <bread>
80103d39:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103d3b:	58                   	pop    %eax
80103d3c:	5a                   	pop    %edx
80103d3d:	ff 34 bd 8c 32 11 80 	push   -0x7feecd74(,%edi,4)
80103d44:	ff 35 84 32 11 80    	push   0x80113284
  for (tail = 0; tail < log.lh.n; tail++) {
80103d4a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103d4d:	e8 7e c3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103d52:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103d55:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103d57:	8d 46 5c             	lea    0x5c(%esi),%eax
80103d5a:	68 00 02 00 00       	push   $0x200
80103d5f:	50                   	push   %eax
80103d60:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103d63:	50                   	push   %eax
80103d64:	e8 d7 1a 00 00       	call   80105840 <memmove>
    bwrite(dbuf);  // write dst to disk
80103d69:	89 1c 24             	mov    %ebx,(%esp)
80103d6c:	e8 3f c4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103d71:	89 34 24             	mov    %esi,(%esp)
80103d74:	e8 77 c4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103d79:	89 1c 24             	mov    %ebx,(%esp)
80103d7c:	e8 6f c4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	39 3d 88 32 11 80    	cmp    %edi,0x80113288
80103d8a:	7f 94                	jg     80103d20 <install_trans+0x20>
  }
}
80103d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d8f:	5b                   	pop    %ebx
80103d90:	5e                   	pop    %esi
80103d91:	5f                   	pop    %edi
80103d92:	5d                   	pop    %ebp
80103d93:	c3                   	ret    
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d98:	c3                   	ret    
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103da7:	ff 35 74 32 11 80    	push   0x80113274
80103dad:	ff 35 84 32 11 80    	push   0x80113284
80103db3:	e8 18 c3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103db8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103dbb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103dbd:	a1 88 32 11 80       	mov    0x80113288,%eax
80103dc2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103dc5:	85 c0                	test   %eax,%eax
80103dc7:	7e 19                	jle    80103de2 <write_head+0x42>
80103dc9:	31 d2                	xor    %edx,%edx
80103dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103dd0:	8b 0c 95 8c 32 11 80 	mov    -0x7feecd74(,%edx,4),%ecx
80103dd7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103ddb:	83 c2 01             	add    $0x1,%edx
80103dde:	39 d0                	cmp    %edx,%eax
80103de0:	75 ee                	jne    80103dd0 <write_head+0x30>
  }
  bwrite(buf);
80103de2:	83 ec 0c             	sub    $0xc,%esp
80103de5:	53                   	push   %ebx
80103de6:	e8 c5 c3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80103deb:	89 1c 24             	mov    %ebx,(%esp)
80103dee:	e8 fd c3 ff ff       	call   801001f0 <brelse>
}
80103df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df6:	83 c4 10             	add    $0x10,%esp
80103df9:	c9                   	leave  
80103dfa:	c3                   	ret    
80103dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <initlog>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	53                   	push   %ebx
80103e04:	83 ec 2c             	sub    $0x2c,%esp
80103e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80103e0a:	68 c0 87 10 80       	push   $0x801087c0
80103e0f:	68 40 32 11 80       	push   $0x80113240
80103e14:	e8 f7 16 00 00       	call   80105510 <initlock>
  readsb(dev, &sb);
80103e19:	58                   	pop    %eax
80103e1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103e1d:	5a                   	pop    %edx
80103e1e:	50                   	push   %eax
80103e1f:	53                   	push   %ebx
80103e20:	e8 3b e8 ff ff       	call   80102660 <readsb>
  log.start = sb.logstart;
80103e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103e28:	59                   	pop    %ecx
  log.dev = dev;
80103e29:	89 1d 84 32 11 80    	mov    %ebx,0x80113284
  log.size = sb.nlog;
80103e2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103e32:	a3 74 32 11 80       	mov    %eax,0x80113274
  log.size = sb.nlog;
80103e37:	89 15 78 32 11 80    	mov    %edx,0x80113278
  struct buf *buf = bread(log.dev, log.start);
80103e3d:	5a                   	pop    %edx
80103e3e:	50                   	push   %eax
80103e3f:	53                   	push   %ebx
80103e40:	e8 8b c2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103e45:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103e48:	8b 58 5c             	mov    0x5c(%eax),%ebx
80103e4b:	89 1d 88 32 11 80    	mov    %ebx,0x80113288
  for (i = 0; i < log.lh.n; i++) {
80103e51:	85 db                	test   %ebx,%ebx
80103e53:	7e 1d                	jle    80103e72 <initlog+0x72>
80103e55:	31 d2                	xor    %edx,%edx
80103e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103e60:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103e64:	89 0c 95 8c 32 11 80 	mov    %ecx,-0x7feecd74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103e6b:	83 c2 01             	add    $0x1,%edx
80103e6e:	39 d3                	cmp    %edx,%ebx
80103e70:	75 ee                	jne    80103e60 <initlog+0x60>
  brelse(buf);
80103e72:	83 ec 0c             	sub    $0xc,%esp
80103e75:	50                   	push   %eax
80103e76:	e8 75 c3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80103e7b:	e8 80 fe ff ff       	call   80103d00 <install_trans>
  log.lh.n = 0;
80103e80:	c7 05 88 32 11 80 00 	movl   $0x0,0x80113288
80103e87:	00 00 00 
  write_head(); // clear the log
80103e8a:	e8 11 ff ff ff       	call   80103da0 <write_head>
}
80103e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e92:	83 c4 10             	add    $0x10,%esp
80103e95:	c9                   	leave  
80103e96:	c3                   	ret    
80103e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9e:	66 90                	xchg   %ax,%ax

80103ea0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103ea6:	68 40 32 11 80       	push   $0x80113240
80103eab:	e8 30 18 00 00       	call   801056e0 <acquire>
80103eb0:	83 c4 10             	add    $0x10,%esp
80103eb3:	eb 18                	jmp    80103ecd <begin_op+0x2d>
80103eb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103eb8:	83 ec 08             	sub    $0x8,%esp
80103ebb:	68 40 32 11 80       	push   $0x80113240
80103ec0:	68 40 32 11 80       	push   $0x80113240
80103ec5:	e8 b6 12 00 00       	call   80105180 <sleep>
80103eca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103ecd:	a1 80 32 11 80       	mov    0x80113280,%eax
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	75 e2                	jne    80103eb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103ed6:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103edb:	8b 15 88 32 11 80    	mov    0x80113288,%edx
80103ee1:	83 c0 01             	add    $0x1,%eax
80103ee4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103ee7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103eea:	83 fa 1e             	cmp    $0x1e,%edx
80103eed:	7f c9                	jg     80103eb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103eef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103ef2:	a3 7c 32 11 80       	mov    %eax,0x8011327c
      release(&log.lock);
80103ef7:	68 40 32 11 80       	push   $0x80113240
80103efc:	e8 7f 17 00 00       	call   80105680 <release>
      break;
    }
  }
}
80103f01:	83 c4 10             	add    $0x10,%esp
80103f04:	c9                   	leave  
80103f05:	c3                   	ret    
80103f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103f19:	68 40 32 11 80       	push   $0x80113240
80103f1e:	e8 bd 17 00 00       	call   801056e0 <acquire>
  log.outstanding -= 1;
80103f23:	a1 7c 32 11 80       	mov    0x8011327c,%eax
  if(log.committing)
80103f28:	8b 35 80 32 11 80    	mov    0x80113280,%esi
80103f2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103f31:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103f34:	89 1d 7c 32 11 80    	mov    %ebx,0x8011327c
  if(log.committing)
80103f3a:	85 f6                	test   %esi,%esi
80103f3c:	0f 85 22 01 00 00    	jne    80104064 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103f42:	85 db                	test   %ebx,%ebx
80103f44:	0f 85 f6 00 00 00    	jne    80104040 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80103f4a:	c7 05 80 32 11 80 01 	movl   $0x1,0x80113280
80103f51:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 40 32 11 80       	push   $0x80113240
80103f5c:	e8 1f 17 00 00       	call   80105680 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103f61:	8b 0d 88 32 11 80    	mov    0x80113288,%ecx
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	85 c9                	test   %ecx,%ecx
80103f6c:	7f 42                	jg     80103fb0 <end_op+0xa0>
    acquire(&log.lock);
80103f6e:	83 ec 0c             	sub    $0xc,%esp
80103f71:	68 40 32 11 80       	push   $0x80113240
80103f76:	e8 65 17 00 00       	call   801056e0 <acquire>
    wakeup(&log);
80103f7b:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
    log.committing = 0;
80103f82:	c7 05 80 32 11 80 00 	movl   $0x0,0x80113280
80103f89:	00 00 00 
    wakeup(&log);
80103f8c:	e8 af 12 00 00       	call   80105240 <wakeup>
    release(&log.lock);
80103f91:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80103f98:	e8 e3 16 00 00       	call   80105680 <release>
80103f9d:	83 c4 10             	add    $0x10,%esp
}
80103fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fa3:	5b                   	pop    %ebx
80103fa4:	5e                   	pop    %esi
80103fa5:	5f                   	pop    %edi
80103fa6:	5d                   	pop    %ebp
80103fa7:	c3                   	ret    
80103fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103fb0:	a1 74 32 11 80       	mov    0x80113274,%eax
80103fb5:	83 ec 08             	sub    $0x8,%esp
80103fb8:	01 d8                	add    %ebx,%eax
80103fba:	83 c0 01             	add    $0x1,%eax
80103fbd:	50                   	push   %eax
80103fbe:	ff 35 84 32 11 80    	push   0x80113284
80103fc4:	e8 07 c1 ff ff       	call   801000d0 <bread>
80103fc9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103fcb:	58                   	pop    %eax
80103fcc:	5a                   	pop    %edx
80103fcd:	ff 34 9d 8c 32 11 80 	push   -0x7feecd74(,%ebx,4)
80103fd4:	ff 35 84 32 11 80    	push   0x80113284
  for (tail = 0; tail < log.lh.n; tail++) {
80103fda:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103fdd:	e8 ee c0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103fe2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103fe5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103fe7:	8d 40 5c             	lea    0x5c(%eax),%eax
80103fea:	68 00 02 00 00       	push   $0x200
80103fef:	50                   	push   %eax
80103ff0:	8d 46 5c             	lea    0x5c(%esi),%eax
80103ff3:	50                   	push   %eax
80103ff4:	e8 47 18 00 00       	call   80105840 <memmove>
    bwrite(to);  // write the log
80103ff9:	89 34 24             	mov    %esi,(%esp)
80103ffc:	e8 af c1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80104001:	89 3c 24             	mov    %edi,(%esp)
80104004:	e8 e7 c1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80104009:	89 34 24             	mov    %esi,(%esp)
8010400c:	e8 df c1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104011:	83 c4 10             	add    $0x10,%esp
80104014:	3b 1d 88 32 11 80    	cmp    0x80113288,%ebx
8010401a:	7c 94                	jl     80103fb0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010401c:	e8 7f fd ff ff       	call   80103da0 <write_head>
    install_trans(); // Now install writes to home locations
80104021:	e8 da fc ff ff       	call   80103d00 <install_trans>
    log.lh.n = 0;
80104026:	c7 05 88 32 11 80 00 	movl   $0x0,0x80113288
8010402d:	00 00 00 
    write_head();    // Erase the transaction from the log
80104030:	e8 6b fd ff ff       	call   80103da0 <write_head>
80104035:	e9 34 ff ff ff       	jmp    80103f6e <end_op+0x5e>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	68 40 32 11 80       	push   $0x80113240
80104048:	e8 f3 11 00 00       	call   80105240 <wakeup>
  release(&log.lock);
8010404d:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104054:	e8 27 16 00 00       	call   80105680 <release>
80104059:	83 c4 10             	add    $0x10,%esp
}
8010405c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405f:	5b                   	pop    %ebx
80104060:	5e                   	pop    %esi
80104061:	5f                   	pop    %edi
80104062:	5d                   	pop    %ebp
80104063:	c3                   	ret    
    panic("log.committing");
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 c4 87 10 80       	push   $0x801087c4
8010406c:	e8 ef c3 ff ff       	call   80100460 <panic>
80104071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407f:	90                   	nop

80104080 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104087:	8b 15 88 32 11 80    	mov    0x80113288,%edx
{
8010408d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104090:	83 fa 1d             	cmp    $0x1d,%edx
80104093:	0f 8f 85 00 00 00    	jg     8010411e <log_write+0x9e>
80104099:	a1 78 32 11 80       	mov    0x80113278,%eax
8010409e:	83 e8 01             	sub    $0x1,%eax
801040a1:	39 c2                	cmp    %eax,%edx
801040a3:	7d 79                	jge    8010411e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801040a5:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	7e 7d                	jle    8010412b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801040ae:	83 ec 0c             	sub    $0xc,%esp
801040b1:	68 40 32 11 80       	push   $0x80113240
801040b6:	e8 25 16 00 00       	call   801056e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801040bb:	8b 15 88 32 11 80    	mov    0x80113288,%edx
801040c1:	83 c4 10             	add    $0x10,%esp
801040c4:	85 d2                	test   %edx,%edx
801040c6:	7e 4a                	jle    80104112 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801040c8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801040cb:	31 c0                	xor    %eax,%eax
801040cd:	eb 08                	jmp    801040d7 <log_write+0x57>
801040cf:	90                   	nop
801040d0:	83 c0 01             	add    $0x1,%eax
801040d3:	39 c2                	cmp    %eax,%edx
801040d5:	74 29                	je     80104100 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801040d7:	39 0c 85 8c 32 11 80 	cmp    %ecx,-0x7feecd74(,%eax,4)
801040de:	75 f0                	jne    801040d0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801040e0:	89 0c 85 8c 32 11 80 	mov    %ecx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801040e7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801040ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801040ed:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
801040f4:	c9                   	leave  
  release(&log.lock);
801040f5:	e9 86 15 00 00       	jmp    80105680 <release>
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80104100:	89 0c 95 8c 32 11 80 	mov    %ecx,-0x7feecd74(,%edx,4)
    log.lh.n++;
80104107:	83 c2 01             	add    $0x1,%edx
8010410a:	89 15 88 32 11 80    	mov    %edx,0x80113288
80104110:	eb d5                	jmp    801040e7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80104112:	8b 43 08             	mov    0x8(%ebx),%eax
80104115:	a3 8c 32 11 80       	mov    %eax,0x8011328c
  if (i == log.lh.n)
8010411a:	75 cb                	jne    801040e7 <log_write+0x67>
8010411c:	eb e9                	jmp    80104107 <log_write+0x87>
    panic("too big a transaction");
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	68 d3 87 10 80       	push   $0x801087d3
80104126:	e8 35 c3 ff ff       	call   80100460 <panic>
    panic("log_write outside of trans");
8010412b:	83 ec 0c             	sub    $0xc,%esp
8010412e:	68 e9 87 10 80       	push   $0x801087e9
80104133:	e8 28 c3 ff ff       	call   80100460 <panic>
80104138:	66 90                	xchg   %ax,%ax
8010413a:	66 90                	xchg   %ax,%ax
8010413c:	66 90                	xchg   %ax,%ax
8010413e:	66 90                	xchg   %ax,%ax

80104140 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104147:	e8 44 09 00 00       	call   80104a90 <cpuid>
8010414c:	89 c3                	mov    %eax,%ebx
8010414e:	e8 3d 09 00 00       	call   80104a90 <cpuid>
80104153:	83 ec 04             	sub    $0x4,%esp
80104156:	53                   	push   %ebx
80104157:	50                   	push   %eax
80104158:	68 04 88 10 80       	push   $0x80108804
8010415d:	e8 7e c6 ff ff       	call   801007e0 <cprintf>
  idtinit();       // load idt register
80104162:	e8 b9 28 00 00       	call   80106a20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104167:	e8 c4 08 00 00       	call   80104a30 <mycpu>
8010416c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010416e:	b8 01 00 00 00       	mov    $0x1,%eax
80104173:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010417a:	e8 f1 0b 00 00       	call   80104d70 <scheduler>
8010417f:	90                   	nop

80104180 <mpenter>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104186:	e8 85 39 00 00       	call   80107b10 <switchkvm>
  seginit();
8010418b:	e8 f0 38 00 00       	call   80107a80 <seginit>
  lapicinit();
80104190:	e8 9b f7 ff ff       	call   80103930 <lapicinit>
  mpmain();
80104195:	e8 a6 ff ff ff       	call   80104140 <mpmain>
8010419a:	66 90                	xchg   %ax,%ax
8010419c:	66 90                	xchg   %ax,%ax
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <main>:
{
801041a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801041a4:	83 e4 f0             	and    $0xfffffff0,%esp
801041a7:	ff 71 fc             	push   -0x4(%ecx)
801041aa:	55                   	push   %ebp
801041ab:	89 e5                	mov    %esp,%ebp
801041ad:	53                   	push   %ebx
801041ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801041af:	83 ec 08             	sub    $0x8,%esp
801041b2:	68 00 00 40 80       	push   $0x80400000
801041b7:	68 70 70 11 80       	push   $0x80117070
801041bc:	e8 8f f5 ff ff       	call   80103750 <kinit1>
  kvmalloc();      // kernel page table
801041c1:	e8 3a 3e 00 00       	call   80108000 <kvmalloc>
  mpinit();        // detect other processors
801041c6:	e8 85 01 00 00       	call   80104350 <mpinit>
  lapicinit();     // interrupt controller
801041cb:	e8 60 f7 ff ff       	call   80103930 <lapicinit>
  seginit();       // segment descriptors
801041d0:	e8 ab 38 00 00       	call   80107a80 <seginit>
  picinit();       // disable pic
801041d5:	e8 76 03 00 00       	call   80104550 <picinit>
  ioapicinit();    // another interrupt controller
801041da:	e8 31 f3 ff ff       	call   80103510 <ioapicinit>
  consoleinit();   // console hardware
801041df:	e8 4c d0 ff ff       	call   80101230 <consoleinit>
  uartinit();      // serial port
801041e4:	e8 27 2b 00 00       	call   80106d10 <uartinit>
  pinit();         // process table
801041e9:	e8 22 08 00 00       	call   80104a10 <pinit>
  tvinit();        // trap vectors
801041ee:	e8 ad 27 00 00       	call   801069a0 <tvinit>
  binit();         // buffer cache
801041f3:	e8 48 be ff ff       	call   80100040 <binit>
  fileinit();      // file table
801041f8:	e8 53 dd ff ff       	call   80101f50 <fileinit>
  ideinit();       // disk 
801041fd:	e8 fe f0 ff ff       	call   80103300 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80104202:	83 c4 0c             	add    $0xc,%esp
80104205:	68 8a 00 00 00       	push   $0x8a
8010420a:	68 8c b4 10 80       	push   $0x8010b48c
8010420f:	68 00 70 00 80       	push   $0x80007000
80104214:	e8 27 16 00 00       	call   80105840 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104219:	83 c4 10             	add    $0x10,%esp
8010421c:	69 05 24 33 11 80 b0 	imul   $0xb0,0x80113324,%eax
80104223:	00 00 00 
80104226:	05 40 33 11 80       	add    $0x80113340,%eax
8010422b:	3d 40 33 11 80       	cmp    $0x80113340,%eax
80104230:	76 7e                	jbe    801042b0 <main+0x110>
80104232:	bb 40 33 11 80       	mov    $0x80113340,%ebx
80104237:	eb 20                	jmp    80104259 <main+0xb9>
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104240:	69 05 24 33 11 80 b0 	imul   $0xb0,0x80113324,%eax
80104247:	00 00 00 
8010424a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104250:	05 40 33 11 80       	add    $0x80113340,%eax
80104255:	39 c3                	cmp    %eax,%ebx
80104257:	73 57                	jae    801042b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80104259:	e8 d2 07 00 00       	call   80104a30 <mycpu>
8010425e:	39 c3                	cmp    %eax,%ebx
80104260:	74 de                	je     80104240 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104262:	e8 59 f5 ff ff       	call   801037c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104267:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010426a:	c7 05 f8 6f 00 80 80 	movl   $0x80104180,0x80006ff8
80104271:	41 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104274:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010427b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010427e:	05 00 10 00 00       	add    $0x1000,%eax
80104283:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104288:	0f b6 03             	movzbl (%ebx),%eax
8010428b:	68 00 70 00 00       	push   $0x7000
80104290:	50                   	push   %eax
80104291:	e8 ea f7 ff ff       	call   80103a80 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104296:	83 c4 10             	add    $0x10,%esp
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801042a6:	85 c0                	test   %eax,%eax
801042a8:	74 f6                	je     801042a0 <main+0x100>
801042aa:	eb 94                	jmp    80104240 <main+0xa0>
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801042b0:	83 ec 08             	sub    $0x8,%esp
801042b3:	68 00 00 00 8e       	push   $0x8e000000
801042b8:	68 00 00 40 80       	push   $0x80400000
801042bd:	e8 2e f4 ff ff       	call   801036f0 <kinit2>
  userinit();      // first user process
801042c2:	e8 19 08 00 00       	call   80104ae0 <userinit>
  mpmain();        // finish this processor's setup
801042c7:	e8 74 fe ff ff       	call   80104140 <mpmain>
801042cc:	66 90                	xchg   %ax,%ax
801042ce:	66 90                	xchg   %ax,%ax

801042d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801042d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801042db:	53                   	push   %ebx
  e = addr+len;
801042dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801042df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801042e2:	39 de                	cmp    %ebx,%esi
801042e4:	72 10                	jb     801042f6 <mpsearch1+0x26>
801042e6:	eb 50                	jmp    80104338 <mpsearch1+0x68>
801042e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ef:	90                   	nop
801042f0:	89 fe                	mov    %edi,%esi
801042f2:	39 fb                	cmp    %edi,%ebx
801042f4:	76 42                	jbe    80104338 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801042f6:	83 ec 04             	sub    $0x4,%esp
801042f9:	8d 7e 10             	lea    0x10(%esi),%edi
801042fc:	6a 04                	push   $0x4
801042fe:	68 18 88 10 80       	push   $0x80108818
80104303:	56                   	push   %esi
80104304:	e8 e7 14 00 00       	call   801057f0 <memcmp>
80104309:	83 c4 10             	add    $0x10,%esp
8010430c:	85 c0                	test   %eax,%eax
8010430e:	75 e0                	jne    801042f0 <mpsearch1+0x20>
80104310:	89 f2                	mov    %esi,%edx
80104312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80104318:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010431b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010431e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104320:	39 fa                	cmp    %edi,%edx
80104322:	75 f4                	jne    80104318 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104324:	84 c0                	test   %al,%al
80104326:	75 c8                	jne    801042f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80104328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432b:	89 f0                	mov    %esi,%eax
8010432d:	5b                   	pop    %ebx
8010432e:	5e                   	pop    %esi
8010432f:	5f                   	pop    %edi
80104330:	5d                   	pop    %ebp
80104331:	c3                   	ret    
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010433b:	31 f6                	xor    %esi,%esi
}
8010433d:	5b                   	pop    %ebx
8010433e:	89 f0                	mov    %esi,%eax
80104340:	5e                   	pop    %esi
80104341:	5f                   	pop    %edi
80104342:	5d                   	pop    %ebp
80104343:	c3                   	ret    
80104344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop

80104350 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104359:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104360:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104367:	c1 e0 08             	shl    $0x8,%eax
8010436a:	09 d0                	or     %edx,%eax
8010436c:	c1 e0 04             	shl    $0x4,%eax
8010436f:	75 1b                	jne    8010438c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104371:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104378:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010437f:	c1 e0 08             	shl    $0x8,%eax
80104382:	09 d0                	or     %edx,%eax
80104384:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104387:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010438c:	ba 00 04 00 00       	mov    $0x400,%edx
80104391:	e8 3a ff ff ff       	call   801042d0 <mpsearch1>
80104396:	89 c3                	mov    %eax,%ebx
80104398:	85 c0                	test   %eax,%eax
8010439a:	0f 84 40 01 00 00    	je     801044e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801043a0:	8b 73 04             	mov    0x4(%ebx),%esi
801043a3:	85 f6                	test   %esi,%esi
801043a5:	0f 84 25 01 00 00    	je     801044d0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801043ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801043ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801043b4:	6a 04                	push   $0x4
801043b6:	68 1d 88 10 80       	push   $0x8010881d
801043bb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801043bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801043bf:	e8 2c 14 00 00       	call   801057f0 <memcmp>
801043c4:	83 c4 10             	add    $0x10,%esp
801043c7:	85 c0                	test   %eax,%eax
801043c9:	0f 85 01 01 00 00    	jne    801044d0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801043cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801043d6:	3c 01                	cmp    $0x1,%al
801043d8:	74 08                	je     801043e2 <mpinit+0x92>
801043da:	3c 04                	cmp    $0x4,%al
801043dc:	0f 85 ee 00 00 00    	jne    801044d0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801043e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801043e9:	66 85 d2             	test   %dx,%dx
801043ec:	74 22                	je     80104410 <mpinit+0xc0>
801043ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801043f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801043f3:	31 d2                	xor    %edx,%edx
801043f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801043f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801043ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80104402:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80104404:	39 c7                	cmp    %eax,%edi
80104406:	75 f0                	jne    801043f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80104408:	84 d2                	test   %dl,%dl
8010440a:	0f 85 c0 00 00 00    	jne    801044d0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80104410:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80104416:	a3 20 32 11 80       	mov    %eax,0x80113220
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010441b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80104422:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80104428:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010442d:	03 55 e4             	add    -0x1c(%ebp),%edx
80104430:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
80104438:	39 d0                	cmp    %edx,%eax
8010443a:	73 15                	jae    80104451 <mpinit+0x101>
    switch(*p){
8010443c:	0f b6 08             	movzbl (%eax),%ecx
8010443f:	80 f9 02             	cmp    $0x2,%cl
80104442:	74 4c                	je     80104490 <mpinit+0x140>
80104444:	77 3a                	ja     80104480 <mpinit+0x130>
80104446:	84 c9                	test   %cl,%cl
80104448:	74 56                	je     801044a0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010444a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010444d:	39 d0                	cmp    %edx,%eax
8010444f:	72 eb                	jb     8010443c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104451:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104454:	85 f6                	test   %esi,%esi
80104456:	0f 84 d9 00 00 00    	je     80104535 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010445c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104460:	74 15                	je     80104477 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104462:	b8 70 00 00 00       	mov    $0x70,%eax
80104467:	ba 22 00 00 00       	mov    $0x22,%edx
8010446c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010446d:	ba 23 00 00 00       	mov    $0x23,%edx
80104472:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104473:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104476:	ee                   	out    %al,(%dx)
  }
}
80104477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447a:	5b                   	pop    %ebx
8010447b:	5e                   	pop    %esi
8010447c:	5f                   	pop    %edi
8010447d:	5d                   	pop    %ebp
8010447e:	c3                   	ret    
8010447f:	90                   	nop
    switch(*p){
80104480:	83 e9 03             	sub    $0x3,%ecx
80104483:	80 f9 01             	cmp    $0x1,%cl
80104486:	76 c2                	jbe    8010444a <mpinit+0xfa>
80104488:	31 f6                	xor    %esi,%esi
8010448a:	eb ac                	jmp    80104438 <mpinit+0xe8>
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104490:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104494:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104497:	88 0d 20 33 11 80    	mov    %cl,0x80113320
      continue;
8010449d:	eb 99                	jmp    80104438 <mpinit+0xe8>
8010449f:	90                   	nop
      if(ncpu < NCPU) {
801044a0:	8b 0d 24 33 11 80    	mov    0x80113324,%ecx
801044a6:	83 f9 07             	cmp    $0x7,%ecx
801044a9:	7f 19                	jg     801044c4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801044ab:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801044b1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801044b5:	83 c1 01             	add    $0x1,%ecx
801044b8:	89 0d 24 33 11 80    	mov    %ecx,0x80113324
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801044be:	88 9f 40 33 11 80    	mov    %bl,-0x7feeccc0(%edi)
      p += sizeof(struct mpproc);
801044c4:	83 c0 14             	add    $0x14,%eax
      continue;
801044c7:	e9 6c ff ff ff       	jmp    80104438 <mpinit+0xe8>
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	68 22 88 10 80       	push   $0x80108822
801044d8:	e8 83 bf ff ff       	call   80100460 <panic>
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
{
801044e0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801044e5:	eb 13                	jmp    801044fa <mpinit+0x1aa>
801044e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ee:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801044f0:	89 f3                	mov    %esi,%ebx
801044f2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801044f8:	74 d6                	je     801044d0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801044fa:	83 ec 04             	sub    $0x4,%esp
801044fd:	8d 73 10             	lea    0x10(%ebx),%esi
80104500:	6a 04                	push   $0x4
80104502:	68 18 88 10 80       	push   $0x80108818
80104507:	53                   	push   %ebx
80104508:	e8 e3 12 00 00       	call   801057f0 <memcmp>
8010450d:	83 c4 10             	add    $0x10,%esp
80104510:	85 c0                	test   %eax,%eax
80104512:	75 dc                	jne    801044f0 <mpinit+0x1a0>
80104514:	89 da                	mov    %ebx,%edx
80104516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104520:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104523:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104526:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104528:	39 d6                	cmp    %edx,%esi
8010452a:	75 f4                	jne    80104520 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010452c:	84 c0                	test   %al,%al
8010452e:	75 c0                	jne    801044f0 <mpinit+0x1a0>
80104530:	e9 6b fe ff ff       	jmp    801043a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104535:	83 ec 0c             	sub    $0xc,%esp
80104538:	68 3c 88 10 80       	push   $0x8010883c
8010453d:	e8 1e bf ff ff       	call   80100460 <panic>
80104542:	66 90                	xchg   %ax,%ax
80104544:	66 90                	xchg   %ax,%ax
80104546:	66 90                	xchg   %ax,%ax
80104548:	66 90                	xchg   %ax,%ax
8010454a:	66 90                	xchg   %ax,%ax
8010454c:	66 90                	xchg   %ax,%ax
8010454e:	66 90                	xchg   %ax,%ax

80104550 <picinit>:
80104550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104555:	ba 21 00 00 00       	mov    $0x21,%edx
8010455a:	ee                   	out    %al,(%dx)
8010455b:	ba a1 00 00 00       	mov    $0xa1,%edx
80104560:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104561:	c3                   	ret    
80104562:	66 90                	xchg   %ax,%ax
80104564:	66 90                	xchg   %ax,%ax
80104566:	66 90                	xchg   %ax,%ax
80104568:	66 90                	xchg   %ax,%ax
8010456a:	66 90                	xchg   %ax,%ax
8010456c:	66 90                	xchg   %ax,%ax
8010456e:	66 90                	xchg   %ax,%ax

80104570 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	57                   	push   %edi
80104574:	56                   	push   %esi
80104575:	53                   	push   %ebx
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010457c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010457f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104585:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010458b:	e8 e0 d9 ff ff       	call   80101f70 <filealloc>
80104590:	89 03                	mov    %eax,(%ebx)
80104592:	85 c0                	test   %eax,%eax
80104594:	0f 84 a8 00 00 00    	je     80104642 <pipealloc+0xd2>
8010459a:	e8 d1 d9 ff ff       	call   80101f70 <filealloc>
8010459f:	89 06                	mov    %eax,(%esi)
801045a1:	85 c0                	test   %eax,%eax
801045a3:	0f 84 87 00 00 00    	je     80104630 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801045a9:	e8 12 f2 ff ff       	call   801037c0 <kalloc>
801045ae:	89 c7                	mov    %eax,%edi
801045b0:	85 c0                	test   %eax,%eax
801045b2:	0f 84 b0 00 00 00    	je     80104668 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801045b8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801045bf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801045c2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801045c5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801045cc:	00 00 00 
  p->nwrite = 0;
801045cf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801045d6:	00 00 00 
  p->nread = 0;
801045d9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801045e0:	00 00 00 
  initlock(&p->lock, "pipe");
801045e3:	68 5b 88 10 80       	push   $0x8010885b
801045e8:	50                   	push   %eax
801045e9:	e8 22 0f 00 00       	call   80105510 <initlock>
  (*f0)->type = FD_PIPE;
801045ee:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801045f0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801045f3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801045f9:	8b 03                	mov    (%ebx),%eax
801045fb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801045ff:	8b 03                	mov    (%ebx),%eax
80104601:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104605:	8b 03                	mov    (%ebx),%eax
80104607:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010460a:	8b 06                	mov    (%esi),%eax
8010460c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104612:	8b 06                	mov    (%esi),%eax
80104614:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104618:	8b 06                	mov    (%esi),%eax
8010461a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010461e:	8b 06                	mov    (%esi),%eax
80104620:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80104623:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80104626:	31 c0                	xor    %eax,%eax
}
80104628:	5b                   	pop    %ebx
80104629:	5e                   	pop    %esi
8010462a:	5f                   	pop    %edi
8010462b:	5d                   	pop    %ebp
8010462c:	c3                   	ret    
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80104630:	8b 03                	mov    (%ebx),%eax
80104632:	85 c0                	test   %eax,%eax
80104634:	74 1e                	je     80104654 <pipealloc+0xe4>
    fileclose(*f0);
80104636:	83 ec 0c             	sub    $0xc,%esp
80104639:	50                   	push   %eax
8010463a:	e8 f1 d9 ff ff       	call   80102030 <fileclose>
8010463f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104642:	8b 06                	mov    (%esi),%eax
80104644:	85 c0                	test   %eax,%eax
80104646:	74 0c                	je     80104654 <pipealloc+0xe4>
    fileclose(*f1);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	50                   	push   %eax
8010464c:	e8 df d9 ff ff       	call   80102030 <fileclose>
80104651:	83 c4 10             	add    $0x10,%esp
}
80104654:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010465c:	5b                   	pop    %ebx
8010465d:	5e                   	pop    %esi
8010465e:	5f                   	pop    %edi
8010465f:	5d                   	pop    %ebp
80104660:	c3                   	ret    
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104668:	8b 03                	mov    (%ebx),%eax
8010466a:	85 c0                	test   %eax,%eax
8010466c:	75 c8                	jne    80104636 <pipealloc+0xc6>
8010466e:	eb d2                	jmp    80104642 <pipealloc+0xd2>

80104670 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104678:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	53                   	push   %ebx
8010467f:	e8 5c 10 00 00       	call   801056e0 <acquire>
  if(writable){
80104684:	83 c4 10             	add    $0x10,%esp
80104687:	85 f6                	test   %esi,%esi
80104689:	74 65                	je     801046f0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010468b:	83 ec 0c             	sub    $0xc,%esp
8010468e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104694:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010469b:	00 00 00 
    wakeup(&p->nread);
8010469e:	50                   	push   %eax
8010469f:	e8 9c 0b 00 00       	call   80105240 <wakeup>
801046a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801046a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801046ad:	85 d2                	test   %edx,%edx
801046af:	75 0a                	jne    801046bb <pipeclose+0x4b>
801046b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801046b7:	85 c0                	test   %eax,%eax
801046b9:	74 15                	je     801046d0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801046bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801046be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c1:	5b                   	pop    %ebx
801046c2:	5e                   	pop    %esi
801046c3:	5d                   	pop    %ebp
    release(&p->lock);
801046c4:	e9 b7 0f 00 00       	jmp    80105680 <release>
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	53                   	push   %ebx
801046d4:	e8 a7 0f 00 00       	call   80105680 <release>
    kfree((char*)p);
801046d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801046dc:	83 c4 10             	add    $0x10,%esp
}
801046df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e2:	5b                   	pop    %ebx
801046e3:	5e                   	pop    %esi
801046e4:	5d                   	pop    %ebp
    kfree((char*)p);
801046e5:	e9 16 ef ff ff       	jmp    80103600 <kfree>
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801046f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104700:	00 00 00 
    wakeup(&p->nwrite);
80104703:	50                   	push   %eax
80104704:	e8 37 0b 00 00       	call   80105240 <wakeup>
80104709:	83 c4 10             	add    $0x10,%esp
8010470c:	eb 99                	jmp    801046a7 <pipeclose+0x37>
8010470e:	66 90                	xchg   %ax,%ax

80104710 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 28             	sub    $0x28,%esp
80104719:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010471c:	53                   	push   %ebx
8010471d:	e8 be 0f 00 00       	call   801056e0 <acquire>
  for(i = 0; i < n; i++){
80104722:	8b 45 10             	mov    0x10(%ebp),%eax
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	85 c0                	test   %eax,%eax
8010472a:	0f 8e c0 00 00 00    	jle    801047f0 <pipewrite+0xe0>
80104730:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104733:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104739:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010473f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104742:	03 45 10             	add    0x10(%ebp),%eax
80104745:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104748:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010474e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104754:	89 ca                	mov    %ecx,%edx
80104756:	05 00 02 00 00       	add    $0x200,%eax
8010475b:	39 c1                	cmp    %eax,%ecx
8010475d:	74 3f                	je     8010479e <pipewrite+0x8e>
8010475f:	eb 67                	jmp    801047c8 <pipewrite+0xb8>
80104761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104768:	e8 43 03 00 00       	call   80104ab0 <myproc>
8010476d:	8b 48 24             	mov    0x24(%eax),%ecx
80104770:	85 c9                	test   %ecx,%ecx
80104772:	75 34                	jne    801047a8 <pipewrite+0x98>
      wakeup(&p->nread);
80104774:	83 ec 0c             	sub    $0xc,%esp
80104777:	57                   	push   %edi
80104778:	e8 c3 0a 00 00       	call   80105240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010477d:	58                   	pop    %eax
8010477e:	5a                   	pop    %edx
8010477f:	53                   	push   %ebx
80104780:	56                   	push   %esi
80104781:	e8 fa 09 00 00       	call   80105180 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104786:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010478c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104792:	83 c4 10             	add    $0x10,%esp
80104795:	05 00 02 00 00       	add    $0x200,%eax
8010479a:	39 c2                	cmp    %eax,%edx
8010479c:	75 2a                	jne    801047c8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010479e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801047a4:	85 c0                	test   %eax,%eax
801047a6:	75 c0                	jne    80104768 <pipewrite+0x58>
        release(&p->lock);
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	53                   	push   %ebx
801047ac:	e8 cf 0e 00 00       	call   80105680 <release>
        return -1;
801047b1:	83 c4 10             	add    $0x10,%esp
801047b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801047b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047bc:	5b                   	pop    %ebx
801047bd:	5e                   	pop    %esi
801047be:	5f                   	pop    %edi
801047bf:	5d                   	pop    %ebp
801047c0:	c3                   	ret    
801047c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801047c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801047cb:	8d 4a 01             	lea    0x1(%edx),%ecx
801047ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801047d4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801047da:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801047dd:	83 c6 01             	add    $0x1,%esi
801047e0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801047e3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801047e7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801047ea:	0f 85 58 ff ff ff    	jne    80104748 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801047f9:	50                   	push   %eax
801047fa:	e8 41 0a 00 00       	call   80105240 <wakeup>
  release(&p->lock);
801047ff:	89 1c 24             	mov    %ebx,(%esp)
80104802:	e8 79 0e 00 00       	call   80105680 <release>
  return n;
80104807:	8b 45 10             	mov    0x10(%ebp),%eax
8010480a:	83 c4 10             	add    $0x10,%esp
8010480d:	eb aa                	jmp    801047b9 <pipewrite+0xa9>
8010480f:	90                   	nop

80104810 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	83 ec 18             	sub    $0x18,%esp
80104819:	8b 75 08             	mov    0x8(%ebp),%esi
8010481c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010481f:	56                   	push   %esi
80104820:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104826:	e8 b5 0e 00 00       	call   801056e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010482b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104831:	83 c4 10             	add    $0x10,%esp
80104834:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010483a:	74 2f                	je     8010486b <piperead+0x5b>
8010483c:	eb 37                	jmp    80104875 <piperead+0x65>
8010483e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104840:	e8 6b 02 00 00       	call   80104ab0 <myproc>
80104845:	8b 48 24             	mov    0x24(%eax),%ecx
80104848:	85 c9                	test   %ecx,%ecx
8010484a:	0f 85 80 00 00 00    	jne    801048d0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104850:	83 ec 08             	sub    $0x8,%esp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	e8 26 09 00 00       	call   80105180 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010485a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104860:	83 c4 10             	add    $0x10,%esp
80104863:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104869:	75 0a                	jne    80104875 <piperead+0x65>
8010486b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104871:	85 c0                	test   %eax,%eax
80104873:	75 cb                	jne    80104840 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104875:	8b 55 10             	mov    0x10(%ebp),%edx
80104878:	31 db                	xor    %ebx,%ebx
8010487a:	85 d2                	test   %edx,%edx
8010487c:	7f 20                	jg     8010489e <piperead+0x8e>
8010487e:	eb 2c                	jmp    801048ac <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104880:	8d 48 01             	lea    0x1(%eax),%ecx
80104883:	25 ff 01 00 00       	and    $0x1ff,%eax
80104888:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010488e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104893:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104896:	83 c3 01             	add    $0x1,%ebx
80104899:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010489c:	74 0e                	je     801048ac <piperead+0x9c>
    if(p->nread == p->nwrite)
8010489e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801048a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801048aa:	75 d4                	jne    80104880 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801048ac:	83 ec 0c             	sub    $0xc,%esp
801048af:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801048b5:	50                   	push   %eax
801048b6:	e8 85 09 00 00       	call   80105240 <wakeup>
  release(&p->lock);
801048bb:	89 34 24             	mov    %esi,(%esp)
801048be:	e8 bd 0d 00 00       	call   80105680 <release>
  return i;
801048c3:	83 c4 10             	add    $0x10,%esp
}
801048c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c9:	89 d8                	mov    %ebx,%eax
801048cb:	5b                   	pop    %ebx
801048cc:	5e                   	pop    %esi
801048cd:	5f                   	pop    %edi
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret    
      release(&p->lock);
801048d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801048d8:	56                   	push   %esi
801048d9:	e8 a2 0d 00 00       	call   80105680 <release>
      return -1;
801048de:	83 c4 10             	add    $0x10,%esp
}
801048e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048e4:	89 d8                	mov    %ebx,%eax
801048e6:	5b                   	pop    %ebx
801048e7:	5e                   	pop    %esi
801048e8:	5f                   	pop    %edi
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	66 90                	xchg   %ax,%ax
801048ed:	66 90                	xchg   %ax,%ax
801048ef:	90                   	nop

801048f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048f4:	bb f4 38 11 80       	mov    $0x801138f4,%ebx
{
801048f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801048fc:	68 c0 38 11 80       	push   $0x801138c0
80104901:	e8 da 0d 00 00       	call   801056e0 <acquire>
80104906:	83 c4 10             	add    $0x10,%esp
80104909:	eb 10                	jmp    8010491b <allocproc+0x2b>
8010490b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104910:	83 c3 7c             	add    $0x7c,%ebx
80104913:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
80104919:	74 75                	je     80104990 <allocproc+0xa0>
    if(p->state == UNUSED)
8010491b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010491e:	85 c0                	test   %eax,%eax
80104920:	75 ee                	jne    80104910 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104922:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104927:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010492a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104931:	89 43 10             	mov    %eax,0x10(%ebx)
80104934:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104937:	68 c0 38 11 80       	push   $0x801138c0
  p->pid = nextpid++;
8010493c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104942:	e8 39 0d 00 00       	call   80105680 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104947:	e8 74 ee ff ff       	call   801037c0 <kalloc>
8010494c:	83 c4 10             	add    $0x10,%esp
8010494f:	89 43 08             	mov    %eax,0x8(%ebx)
80104952:	85 c0                	test   %eax,%eax
80104954:	74 53                	je     801049a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104956:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010495c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010495f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104964:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104967:	c7 40 14 92 69 10 80 	movl   $0x80106992,0x14(%eax)
  p->context = (struct context*)sp;
8010496e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104971:	6a 14                	push   $0x14
80104973:	6a 00                	push   $0x0
80104975:	50                   	push   %eax
80104976:	e8 25 0e 00 00       	call   801057a0 <memset>
  p->context->eip = (uint)forkret;
8010497b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010497e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104981:	c7 40 10 c0 49 10 80 	movl   $0x801049c0,0x10(%eax)
}
80104988:	89 d8                	mov    %ebx,%eax
8010498a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010498d:	c9                   	leave  
8010498e:	c3                   	ret    
8010498f:	90                   	nop
  release(&ptable.lock);
80104990:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104993:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104995:	68 c0 38 11 80       	push   $0x801138c0
8010499a:	e8 e1 0c 00 00       	call   80105680 <release>
}
8010499f:	89 d8                	mov    %ebx,%eax
  return 0;
801049a1:	83 c4 10             	add    $0x10,%esp
}
801049a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a7:	c9                   	leave  
801049a8:	c3                   	ret    
    p->state = UNUSED;
801049a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801049b0:	31 db                	xor    %ebx,%ebx
}
801049b2:	89 d8                	mov    %ebx,%eax
801049b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b7:	c9                   	leave  
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801049c6:	68 c0 38 11 80       	push   $0x801138c0
801049cb:	e8 b0 0c 00 00       	call   80105680 <release>

  if (first) {
801049d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801049d5:	83 c4 10             	add    $0x10,%esp
801049d8:	85 c0                	test   %eax,%eax
801049da:	75 04                	jne    801049e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801049dc:	c9                   	leave  
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax
    first = 0;
801049e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801049e7:	00 00 00 
    iinit(ROOTDEV);
801049ea:	83 ec 0c             	sub    $0xc,%esp
801049ed:	6a 01                	push   $0x1
801049ef:	e8 ac dc ff ff       	call   801026a0 <iinit>
    initlog(ROOTDEV);
801049f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049fb:	e8 00 f4 ff ff       	call   80103e00 <initlog>
}
80104a00:	83 c4 10             	add    $0x10,%esp
80104a03:	c9                   	leave  
80104a04:	c3                   	ret    
80104a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <pinit>:
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104a16:	68 60 88 10 80       	push   $0x80108860
80104a1b:	68 c0 38 11 80       	push   $0x801138c0
80104a20:	e8 eb 0a 00 00       	call   80105510 <initlock>
}
80104a25:	83 c4 10             	add    $0x10,%esp
80104a28:	c9                   	leave  
80104a29:	c3                   	ret    
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <mycpu>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a35:	9c                   	pushf  
80104a36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a37:	f6 c4 02             	test   $0x2,%ah
80104a3a:	75 46                	jne    80104a82 <mycpu+0x52>
  apicid = lapicid();
80104a3c:	e8 ef ef ff ff       	call   80103a30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104a41:	8b 35 24 33 11 80    	mov    0x80113324,%esi
80104a47:	85 f6                	test   %esi,%esi
80104a49:	7e 2a                	jle    80104a75 <mycpu+0x45>
80104a4b:	31 d2                	xor    %edx,%edx
80104a4d:	eb 08                	jmp    80104a57 <mycpu+0x27>
80104a4f:	90                   	nop
80104a50:	83 c2 01             	add    $0x1,%edx
80104a53:	39 f2                	cmp    %esi,%edx
80104a55:	74 1e                	je     80104a75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104a57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104a5d:	0f b6 99 40 33 11 80 	movzbl -0x7feeccc0(%ecx),%ebx
80104a64:	39 c3                	cmp    %eax,%ebx
80104a66:	75 e8                	jne    80104a50 <mycpu+0x20>
}
80104a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104a6b:	8d 81 40 33 11 80    	lea    -0x7feeccc0(%ecx),%eax
}
80104a71:	5b                   	pop    %ebx
80104a72:	5e                   	pop    %esi
80104a73:	5d                   	pop    %ebp
80104a74:	c3                   	ret    
  panic("unknown apicid\n");
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	68 67 88 10 80       	push   $0x80108867
80104a7d:	e8 de b9 ff ff       	call   80100460 <panic>
    panic("mycpu called with interrupts enabled\n");
80104a82:	83 ec 0c             	sub    $0xc,%esp
80104a85:	68 44 89 10 80       	push   $0x80108944
80104a8a:	e8 d1 b9 ff ff       	call   80100460 <panic>
80104a8f:	90                   	nop

80104a90 <cpuid>:
cpuid() {
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104a96:	e8 95 ff ff ff       	call   80104a30 <mycpu>
}
80104a9b:	c9                   	leave  
  return mycpu()-cpus;
80104a9c:	2d 40 33 11 80       	sub    $0x80113340,%eax
80104aa1:	c1 f8 04             	sar    $0x4,%eax
80104aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104aaa:	c3                   	ret    
80104aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop

80104ab0 <myproc>:
myproc(void) {
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104ab7:	e8 d4 0a 00 00       	call   80105590 <pushcli>
  c = mycpu();
80104abc:	e8 6f ff ff ff       	call   80104a30 <mycpu>
  p = c->proc;
80104ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ac7:	e8 14 0b 00 00       	call   801055e0 <popcli>
}
80104acc:	89 d8                	mov    %ebx,%eax
80104ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad1:	c9                   	leave  
80104ad2:	c3                   	ret    
80104ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ae0 <userinit>:
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104ae7:	e8 04 fe ff ff       	call   801048f0 <allocproc>
80104aec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104aee:	a3 f4 57 11 80       	mov    %eax,0x801157f4
  if((p->pgdir = setupkvm()) == 0)
80104af3:	e8 88 34 00 00       	call   80107f80 <setupkvm>
80104af8:	89 43 04             	mov    %eax,0x4(%ebx)
80104afb:	85 c0                	test   %eax,%eax
80104afd:	0f 84 bd 00 00 00    	je     80104bc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104b03:	83 ec 04             	sub    $0x4,%esp
80104b06:	68 2c 00 00 00       	push   $0x2c
80104b0b:	68 60 b4 10 80       	push   $0x8010b460
80104b10:	50                   	push   %eax
80104b11:	e8 1a 31 00 00       	call   80107c30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104b16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104b19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104b1f:	6a 4c                	push   $0x4c
80104b21:	6a 00                	push   $0x0
80104b23:	ff 73 18             	push   0x18(%ebx)
80104b26:	e8 75 0c 00 00       	call   801057a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104b2b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104b36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104b3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104b3f:	8b 43 18             	mov    0x18(%ebx),%eax
80104b42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104b46:	8b 43 18             	mov    0x18(%ebx),%eax
80104b49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104b4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104b51:	8b 43 18             	mov    0x18(%ebx),%eax
80104b54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104b58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104b5c:	8b 43 18             	mov    0x18(%ebx),%eax
80104b5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104b66:	8b 43 18             	mov    0x18(%ebx),%eax
80104b69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104b70:	8b 43 18             	mov    0x18(%ebx),%eax
80104b73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b7d:	6a 10                	push   $0x10
80104b7f:	68 90 88 10 80       	push   $0x80108890
80104b84:	50                   	push   %eax
80104b85:	e8 d6 0d 00 00       	call   80105960 <safestrcpy>
  p->cwd = namei("/");
80104b8a:	c7 04 24 99 88 10 80 	movl   $0x80108899,(%esp)
80104b91:	e8 4a e6 ff ff       	call   801031e0 <namei>
80104b96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104b99:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104ba0:	e8 3b 0b 00 00       	call   801056e0 <acquire>
  p->state = RUNNABLE;
80104ba5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104bac:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104bb3:	e8 c8 0a 00 00       	call   80105680 <release>
}
80104bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bbb:	83 c4 10             	add    $0x10,%esp
80104bbe:	c9                   	leave  
80104bbf:	c3                   	ret    
    panic("userinit: out of memory?");
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	68 77 88 10 80       	push   $0x80108877
80104bc8:	e8 93 b8 ff ff       	call   80100460 <panic>
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi

80104bd0 <growproc>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104bd8:	e8 b3 09 00 00       	call   80105590 <pushcli>
  c = mycpu();
80104bdd:	e8 4e fe ff ff       	call   80104a30 <mycpu>
  p = c->proc;
80104be2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104be8:	e8 f3 09 00 00       	call   801055e0 <popcli>
  sz = curproc->sz;
80104bed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104bef:	85 f6                	test   %esi,%esi
80104bf1:	7f 1d                	jg     80104c10 <growproc+0x40>
  } else if(n < 0){
80104bf3:	75 3b                	jne    80104c30 <growproc+0x60>
  switchuvm(curproc);
80104bf5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104bf8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104bfa:	53                   	push   %ebx
80104bfb:	e8 20 2f 00 00       	call   80107b20 <switchuvm>
  return 0;
80104c00:	83 c4 10             	add    $0x10,%esp
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c08:	5b                   	pop    %ebx
80104c09:	5e                   	pop    %esi
80104c0a:	5d                   	pop    %ebp
80104c0b:	c3                   	ret    
80104c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104c10:	83 ec 04             	sub    $0x4,%esp
80104c13:	01 c6                	add    %eax,%esi
80104c15:	56                   	push   %esi
80104c16:	50                   	push   %eax
80104c17:	ff 73 04             	push   0x4(%ebx)
80104c1a:	e8 81 31 00 00       	call   80107da0 <allocuvm>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	75 cf                	jne    80104bf5 <growproc+0x25>
      return -1;
80104c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c2b:	eb d8                	jmp    80104c05 <growproc+0x35>
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104c30:	83 ec 04             	sub    $0x4,%esp
80104c33:	01 c6                	add    %eax,%esi
80104c35:	56                   	push   %esi
80104c36:	50                   	push   %eax
80104c37:	ff 73 04             	push   0x4(%ebx)
80104c3a:	e8 91 32 00 00       	call   80107ed0 <deallocuvm>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	75 af                	jne    80104bf5 <growproc+0x25>
80104c46:	eb de                	jmp    80104c26 <growproc+0x56>
80104c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop

80104c50 <fork>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	56                   	push   %esi
80104c55:	53                   	push   %ebx
80104c56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104c59:	e8 32 09 00 00       	call   80105590 <pushcli>
  c = mycpu();
80104c5e:	e8 cd fd ff ff       	call   80104a30 <mycpu>
  p = c->proc;
80104c63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c69:	e8 72 09 00 00       	call   801055e0 <popcli>
  if((np = allocproc()) == 0){
80104c6e:	e8 7d fc ff ff       	call   801048f0 <allocproc>
80104c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104c76:	85 c0                	test   %eax,%eax
80104c78:	0f 84 b7 00 00 00    	je     80104d35 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104c7e:	83 ec 08             	sub    $0x8,%esp
80104c81:	ff 33                	push   (%ebx)
80104c83:	89 c7                	mov    %eax,%edi
80104c85:	ff 73 04             	push   0x4(%ebx)
80104c88:	e8 e3 33 00 00       	call   80108070 <copyuvm>
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	89 47 04             	mov    %eax,0x4(%edi)
80104c93:	85 c0                	test   %eax,%eax
80104c95:	0f 84 a1 00 00 00    	je     80104d3c <fork+0xec>
  np->sz = curproc->sz;
80104c9b:	8b 03                	mov    (%ebx),%eax
80104c9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104ca0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104ca2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104ca5:	89 c8                	mov    %ecx,%eax
80104ca7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104caa:	b9 13 00 00 00       	mov    $0x13,%ecx
80104caf:	8b 73 18             	mov    0x18(%ebx),%esi
80104cb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104cb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104cb6:	8b 40 18             	mov    0x18(%eax),%eax
80104cb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104cc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104cc4:	85 c0                	test   %eax,%eax
80104cc6:	74 13                	je     80104cdb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	50                   	push   %eax
80104ccc:	e8 0f d3 ff ff       	call   80101fe0 <filedup>
80104cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104cd4:	83 c4 10             	add    $0x10,%esp
80104cd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104cdb:	83 c6 01             	add    $0x1,%esi
80104cde:	83 fe 10             	cmp    $0x10,%esi
80104ce1:	75 dd                	jne    80104cc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104ce3:	83 ec 0c             	sub    $0xc,%esp
80104ce6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104ce9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104cec:	e8 9f db ff ff       	call   80102890 <idup>
80104cf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104cf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104cf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104cfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80104cfd:	6a 10                	push   $0x10
80104cff:	53                   	push   %ebx
80104d00:	50                   	push   %eax
80104d01:	e8 5a 0c 00 00       	call   80105960 <safestrcpy>
  pid = np->pid;
80104d06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104d09:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104d10:	e8 cb 09 00 00       	call   801056e0 <acquire>
  np->state = RUNNABLE;
80104d15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104d1c:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104d23:	e8 58 09 00 00       	call   80105680 <release>
  return pid;
80104d28:	83 c4 10             	add    $0x10,%esp
}
80104d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d2e:	89 d8                	mov    %ebx,%eax
80104d30:	5b                   	pop    %ebx
80104d31:	5e                   	pop    %esi
80104d32:	5f                   	pop    %edi
80104d33:	5d                   	pop    %ebp
80104d34:	c3                   	ret    
    return -1;
80104d35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d3a:	eb ef                	jmp    80104d2b <fork+0xdb>
    kfree(np->kstack);
80104d3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104d3f:	83 ec 0c             	sub    $0xc,%esp
80104d42:	ff 73 08             	push   0x8(%ebx)
80104d45:	e8 b6 e8 ff ff       	call   80103600 <kfree>
    np->kstack = 0;
80104d4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104d51:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104d54:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104d5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d60:	eb c9                	jmp    80104d2b <fork+0xdb>
80104d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d70 <scheduler>:
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
80104d76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104d79:	e8 b2 fc ff ff       	call   80104a30 <mycpu>
  c->proc = 0;
80104d7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104d85:	00 00 00 
  struct cpu *c = mycpu();
80104d88:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104d8a:	8d 78 04             	lea    0x4(%eax),%edi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104d90:	fb                   	sti    
    acquire(&ptable.lock);
80104d91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d94:	bb f4 38 11 80       	mov    $0x801138f4,%ebx
    acquire(&ptable.lock);
80104d99:	68 c0 38 11 80       	push   $0x801138c0
80104d9e:	e8 3d 09 00 00       	call   801056e0 <acquire>
80104da3:	83 c4 10             	add    $0x10,%esp
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104db0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104db4:	75 33                	jne    80104de9 <scheduler+0x79>
      switchuvm(p);
80104db6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104db9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104dbf:	53                   	push   %ebx
80104dc0:	e8 5b 2d 00 00       	call   80107b20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104dc5:	58                   	pop    %eax
80104dc6:	5a                   	pop    %edx
80104dc7:	ff 73 1c             	push   0x1c(%ebx)
80104dca:	57                   	push   %edi
      p->state = RUNNING;
80104dcb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104dd2:	e8 e4 0b 00 00       	call   801059bb <swtch>
      switchkvm();
80104dd7:	e8 34 2d 00 00       	call   80107b10 <switchkvm>
      c->proc = 0;
80104ddc:	83 c4 10             	add    $0x10,%esp
80104ddf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104de6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104de9:	83 c3 7c             	add    $0x7c,%ebx
80104dec:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
80104df2:	75 bc                	jne    80104db0 <scheduler+0x40>
    release(&ptable.lock);
80104df4:	83 ec 0c             	sub    $0xc,%esp
80104df7:	68 c0 38 11 80       	push   $0x801138c0
80104dfc:	e8 7f 08 00 00       	call   80105680 <release>
    sti();
80104e01:	83 c4 10             	add    $0x10,%esp
80104e04:	eb 8a                	jmp    80104d90 <scheduler+0x20>
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi

80104e10 <sched>:
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
  pushcli();
80104e15:	e8 76 07 00 00       	call   80105590 <pushcli>
  c = mycpu();
80104e1a:	e8 11 fc ff ff       	call   80104a30 <mycpu>
  p = c->proc;
80104e1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e25:	e8 b6 07 00 00       	call   801055e0 <popcli>
  if(!holding(&ptable.lock))
80104e2a:	83 ec 0c             	sub    $0xc,%esp
80104e2d:	68 c0 38 11 80       	push   $0x801138c0
80104e32:	e8 09 08 00 00       	call   80105640 <holding>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	74 4f                	je     80104e8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80104e3e:	e8 ed fb ff ff       	call   80104a30 <mycpu>
80104e43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104e4a:	75 68                	jne    80104eb4 <sched+0xa4>
  if(p->state == RUNNING)
80104e4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104e50:	74 55                	je     80104ea7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e52:	9c                   	pushf  
80104e53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e54:	f6 c4 02             	test   $0x2,%ah
80104e57:	75 41                	jne    80104e9a <sched+0x8a>
  intena = mycpu()->intena;
80104e59:	e8 d2 fb ff ff       	call   80104a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104e5e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104e61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104e67:	e8 c4 fb ff ff       	call   80104a30 <mycpu>
80104e6c:	83 ec 08             	sub    $0x8,%esp
80104e6f:	ff 70 04             	push   0x4(%eax)
80104e72:	53                   	push   %ebx
80104e73:	e8 43 0b 00 00       	call   801059bb <swtch>
  mycpu()->intena = intena;
80104e78:	e8 b3 fb ff ff       	call   80104a30 <mycpu>
}
80104e7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104e80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104e86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e89:	5b                   	pop    %ebx
80104e8a:	5e                   	pop    %esi
80104e8b:	5d                   	pop    %ebp
80104e8c:	c3                   	ret    
    panic("sched ptable.lock");
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	68 9b 88 10 80       	push   $0x8010889b
80104e95:	e8 c6 b5 ff ff       	call   80100460 <panic>
    panic("sched interruptible");
80104e9a:	83 ec 0c             	sub    $0xc,%esp
80104e9d:	68 c7 88 10 80       	push   $0x801088c7
80104ea2:	e8 b9 b5 ff ff       	call   80100460 <panic>
    panic("sched running");
80104ea7:	83 ec 0c             	sub    $0xc,%esp
80104eaa:	68 b9 88 10 80       	push   $0x801088b9
80104eaf:	e8 ac b5 ff ff       	call   80100460 <panic>
    panic("sched locks");
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	68 ad 88 10 80       	push   $0x801088ad
80104ebc:	e8 9f b5 ff ff       	call   80100460 <panic>
80104ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecf:	90                   	nop

80104ed0 <exit>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
80104ed6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104ed9:	e8 d2 fb ff ff       	call   80104ab0 <myproc>
  if(curproc == initproc)
80104ede:	39 05 f4 57 11 80    	cmp    %eax,0x801157f4
80104ee4:	0f 84 fd 00 00 00    	je     80104fe7 <exit+0x117>
80104eea:	89 c3                	mov    %eax,%ebx
80104eec:	8d 70 28             	lea    0x28(%eax),%esi
80104eef:	8d 78 68             	lea    0x68(%eax),%edi
80104ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104ef8:	8b 06                	mov    (%esi),%eax
80104efa:	85 c0                	test   %eax,%eax
80104efc:	74 12                	je     80104f10 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80104efe:	83 ec 0c             	sub    $0xc,%esp
80104f01:	50                   	push   %eax
80104f02:	e8 29 d1 ff ff       	call   80102030 <fileclose>
      curproc->ofile[fd] = 0;
80104f07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104f0d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104f10:	83 c6 04             	add    $0x4,%esi
80104f13:	39 f7                	cmp    %esi,%edi
80104f15:	75 e1                	jne    80104ef8 <exit+0x28>
  begin_op();
80104f17:	e8 84 ef ff ff       	call   80103ea0 <begin_op>
  iput(curproc->cwd);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	ff 73 68             	push   0x68(%ebx)
80104f22:	e8 c9 da ff ff       	call   801029f0 <iput>
  end_op();
80104f27:	e8 e4 ef ff ff       	call   80103f10 <end_op>
  curproc->cwd = 0;
80104f2c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104f33:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104f3a:	e8 a1 07 00 00       	call   801056e0 <acquire>
  wakeup1(curproc->parent);
80104f3f:	8b 53 14             	mov    0x14(%ebx),%edx
80104f42:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f45:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
80104f4a:	eb 0e                	jmp    80104f5a <exit+0x8a>
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f50:	83 c0 7c             	add    $0x7c,%eax
80104f53:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80104f58:	74 1c                	je     80104f76 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80104f5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104f5e:	75 f0                	jne    80104f50 <exit+0x80>
80104f60:	3b 50 20             	cmp    0x20(%eax),%edx
80104f63:	75 eb                	jne    80104f50 <exit+0x80>
      p->state = RUNNABLE;
80104f65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f6c:	83 c0 7c             	add    $0x7c,%eax
80104f6f:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80104f74:	75 e4                	jne    80104f5a <exit+0x8a>
      p->parent = initproc;
80104f76:	8b 0d f4 57 11 80    	mov    0x801157f4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f7c:	ba f4 38 11 80       	mov    $0x801138f4,%edx
80104f81:	eb 10                	jmp    80104f93 <exit+0xc3>
80104f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f87:	90                   	nop
80104f88:	83 c2 7c             	add    $0x7c,%edx
80104f8b:	81 fa f4 57 11 80    	cmp    $0x801157f4,%edx
80104f91:	74 3b                	je     80104fce <exit+0xfe>
    if(p->parent == curproc){
80104f93:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104f96:	75 f0                	jne    80104f88 <exit+0xb8>
      if(p->state == ZOMBIE)
80104f98:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104f9c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104f9f:	75 e7                	jne    80104f88 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fa1:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
80104fa6:	eb 12                	jmp    80104fba <exit+0xea>
80104fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop
80104fb0:	83 c0 7c             	add    $0x7c,%eax
80104fb3:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80104fb8:	74 ce                	je     80104f88 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80104fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104fbe:	75 f0                	jne    80104fb0 <exit+0xe0>
80104fc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80104fc3:	75 eb                	jne    80104fb0 <exit+0xe0>
      p->state = RUNNABLE;
80104fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104fcc:	eb e2                	jmp    80104fb0 <exit+0xe0>
  curproc->state = ZOMBIE;
80104fce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104fd5:	e8 36 fe ff ff       	call   80104e10 <sched>
  panic("zombie exit");
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	68 e8 88 10 80       	push   $0x801088e8
80104fe2:	e8 79 b4 ff ff       	call   80100460 <panic>
    panic("init exiting");
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	68 db 88 10 80       	push   $0x801088db
80104fef:	e8 6c b4 ff ff       	call   80100460 <panic>
80104ff4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop

80105000 <wait>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  pushcli();
80105005:	e8 86 05 00 00       	call   80105590 <pushcli>
  c = mycpu();
8010500a:	e8 21 fa ff ff       	call   80104a30 <mycpu>
  p = c->proc;
8010500f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105015:	e8 c6 05 00 00       	call   801055e0 <popcli>
  acquire(&ptable.lock);
8010501a:	83 ec 0c             	sub    $0xc,%esp
8010501d:	68 c0 38 11 80       	push   $0x801138c0
80105022:	e8 b9 06 00 00       	call   801056e0 <acquire>
80105027:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010502a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010502c:	bb f4 38 11 80       	mov    $0x801138f4,%ebx
80105031:	eb 10                	jmp    80105043 <wait+0x43>
80105033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105037:	90                   	nop
80105038:	83 c3 7c             	add    $0x7c,%ebx
8010503b:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
80105041:	74 1b                	je     8010505e <wait+0x5e>
      if(p->parent != curproc)
80105043:	39 73 14             	cmp    %esi,0x14(%ebx)
80105046:	75 f0                	jne    80105038 <wait+0x38>
      if(p->state == ZOMBIE){
80105048:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010504c:	74 62                	je     801050b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010504e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80105051:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105056:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
8010505c:	75 e5                	jne    80105043 <wait+0x43>
    if(!havekids || curproc->killed){
8010505e:	85 c0                	test   %eax,%eax
80105060:	0f 84 a0 00 00 00    	je     80105106 <wait+0x106>
80105066:	8b 46 24             	mov    0x24(%esi),%eax
80105069:	85 c0                	test   %eax,%eax
8010506b:	0f 85 95 00 00 00    	jne    80105106 <wait+0x106>
  pushcli();
80105071:	e8 1a 05 00 00       	call   80105590 <pushcli>
  c = mycpu();
80105076:	e8 b5 f9 ff ff       	call   80104a30 <mycpu>
  p = c->proc;
8010507b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105081:	e8 5a 05 00 00       	call   801055e0 <popcli>
  if(p == 0)
80105086:	85 db                	test   %ebx,%ebx
80105088:	0f 84 8f 00 00 00    	je     8010511d <wait+0x11d>
  p->chan = chan;
8010508e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105091:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105098:	e8 73 fd ff ff       	call   80104e10 <sched>
  p->chan = 0;
8010509d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801050a4:	eb 84                	jmp    8010502a <wait+0x2a>
801050a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801050b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801050b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801050b6:	ff 73 08             	push   0x8(%ebx)
801050b9:	e8 42 e5 ff ff       	call   80103600 <kfree>
        p->kstack = 0;
801050be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801050c5:	5a                   	pop    %edx
801050c6:	ff 73 04             	push   0x4(%ebx)
801050c9:	e8 32 2e 00 00       	call   80107f00 <freevm>
        p->pid = 0;
801050ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801050d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801050dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801050e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801050e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801050ee:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
801050f5:	e8 86 05 00 00       	call   80105680 <release>
        return pid;
801050fa:	83 c4 10             	add    $0x10,%esp
}
801050fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105100:	89 f0                	mov    %esi,%eax
80105102:	5b                   	pop    %ebx
80105103:	5e                   	pop    %esi
80105104:	5d                   	pop    %ebp
80105105:	c3                   	ret    
      release(&ptable.lock);
80105106:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105109:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010510e:	68 c0 38 11 80       	push   $0x801138c0
80105113:	e8 68 05 00 00       	call   80105680 <release>
      return -1;
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	eb e0                	jmp    801050fd <wait+0xfd>
    panic("sleep");
8010511d:	83 ec 0c             	sub    $0xc,%esp
80105120:	68 f4 88 10 80       	push   $0x801088f4
80105125:	e8 36 b3 ff ff       	call   80100460 <panic>
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105130 <yield>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105137:	68 c0 38 11 80       	push   $0x801138c0
8010513c:	e8 9f 05 00 00       	call   801056e0 <acquire>
  pushcli();
80105141:	e8 4a 04 00 00       	call   80105590 <pushcli>
  c = mycpu();
80105146:	e8 e5 f8 ff ff       	call   80104a30 <mycpu>
  p = c->proc;
8010514b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105151:	e8 8a 04 00 00       	call   801055e0 <popcli>
  myproc()->state = RUNNABLE;
80105156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010515d:	e8 ae fc ff ff       	call   80104e10 <sched>
  release(&ptable.lock);
80105162:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80105169:	e8 12 05 00 00       	call   80105680 <release>
}
8010516e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	c9                   	leave  
80105175:	c3                   	ret    
80105176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517d:	8d 76 00             	lea    0x0(%esi),%esi

80105180 <sleep>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
80105185:	53                   	push   %ebx
80105186:	83 ec 0c             	sub    $0xc,%esp
80105189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010518c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010518f:	e8 fc 03 00 00       	call   80105590 <pushcli>
  c = mycpu();
80105194:	e8 97 f8 ff ff       	call   80104a30 <mycpu>
  p = c->proc;
80105199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010519f:	e8 3c 04 00 00       	call   801055e0 <popcli>
  if(p == 0)
801051a4:	85 db                	test   %ebx,%ebx
801051a6:	0f 84 87 00 00 00    	je     80105233 <sleep+0xb3>
  if(lk == 0)
801051ac:	85 f6                	test   %esi,%esi
801051ae:	74 76                	je     80105226 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801051b0:	81 fe c0 38 11 80    	cmp    $0x801138c0,%esi
801051b6:	74 50                	je     80105208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	68 c0 38 11 80       	push   $0x801138c0
801051c0:	e8 1b 05 00 00       	call   801056e0 <acquire>
    release(lk);
801051c5:	89 34 24             	mov    %esi,(%esp)
801051c8:	e8 b3 04 00 00       	call   80105680 <release>
  p->chan = chan;
801051cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801051d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801051d7:	e8 34 fc ff ff       	call   80104e10 <sched>
  p->chan = 0;
801051dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801051e3:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
801051ea:	e8 91 04 00 00       	call   80105680 <release>
    acquire(lk);
801051ef:	89 75 08             	mov    %esi,0x8(%ebp)
801051f2:	83 c4 10             	add    $0x10,%esp
}
801051f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f8:	5b                   	pop    %ebx
801051f9:	5e                   	pop    %esi
801051fa:	5f                   	pop    %edi
801051fb:	5d                   	pop    %ebp
    acquire(lk);
801051fc:	e9 df 04 00 00       	jmp    801056e0 <acquire>
80105201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010520b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105212:	e8 f9 fb ff ff       	call   80104e10 <sched>
  p->chan = 0;
80105217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010521e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105221:	5b                   	pop    %ebx
80105222:	5e                   	pop    %esi
80105223:	5f                   	pop    %edi
80105224:	5d                   	pop    %ebp
80105225:	c3                   	ret    
    panic("sleep without lk");
80105226:	83 ec 0c             	sub    $0xc,%esp
80105229:	68 fa 88 10 80       	push   $0x801088fa
8010522e:	e8 2d b2 ff ff       	call   80100460 <panic>
    panic("sleep");
80105233:	83 ec 0c             	sub    $0xc,%esp
80105236:	68 f4 88 10 80       	push   $0x801088f4
8010523b:	e8 20 b2 ff ff       	call   80100460 <panic>

80105240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	53                   	push   %ebx
80105244:	83 ec 10             	sub    $0x10,%esp
80105247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010524a:	68 c0 38 11 80       	push   $0x801138c0
8010524f:	e8 8c 04 00 00       	call   801056e0 <acquire>
80105254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105257:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
8010525c:	eb 0c                	jmp    8010526a <wakeup+0x2a>
8010525e:	66 90                	xchg   %ax,%ax
80105260:	83 c0 7c             	add    $0x7c,%eax
80105263:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105268:	74 1c                	je     80105286 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010526a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010526e:	75 f0                	jne    80105260 <wakeup+0x20>
80105270:	3b 58 20             	cmp    0x20(%eax),%ebx
80105273:	75 eb                	jne    80105260 <wakeup+0x20>
      p->state = RUNNABLE;
80105275:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010527c:	83 c0 7c             	add    $0x7c,%eax
8010527f:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105284:	75 e4                	jne    8010526a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80105286:	c7 45 08 c0 38 11 80 	movl   $0x801138c0,0x8(%ebp)
}
8010528d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105290:	c9                   	leave  
  release(&ptable.lock);
80105291:	e9 ea 03 00 00       	jmp    80105680 <release>
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi

801052a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 10             	sub    $0x10,%esp
801052a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801052aa:	68 c0 38 11 80       	push   $0x801138c0
801052af:	e8 2c 04 00 00       	call   801056e0 <acquire>
801052b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052b7:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
801052bc:	eb 0c                	jmp    801052ca <kill+0x2a>
801052be:	66 90                	xchg   %ax,%ax
801052c0:	83 c0 7c             	add    $0x7c,%eax
801052c3:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
801052c8:	74 36                	je     80105300 <kill+0x60>
    if(p->pid == pid){
801052ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801052cd:	75 f1                	jne    801052c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801052cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801052d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801052da:	75 07                	jne    801052e3 <kill+0x43>
        p->state = RUNNABLE;
801052dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801052e3:	83 ec 0c             	sub    $0xc,%esp
801052e6:	68 c0 38 11 80       	push   $0x801138c0
801052eb:	e8 90 03 00 00       	call   80105680 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801052f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	31 c0                	xor    %eax,%eax
}
801052f8:	c9                   	leave  
801052f9:	c3                   	ret    
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	68 c0 38 11 80       	push   $0x801138c0
80105308:	e8 73 03 00 00       	call   80105680 <release>
}
8010530d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105318:	c9                   	leave  
80105319:	c3                   	ret    
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105320 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105328:	53                   	push   %ebx
80105329:	bb 60 39 11 80       	mov    $0x80113960,%ebx
8010532e:	83 ec 3c             	sub    $0x3c,%esp
80105331:	eb 24                	jmp    80105357 <procdump+0x37>
80105333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105337:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	68 77 8c 10 80       	push   $0x80108c77
80105340:	e8 9b b4 ff ff       	call   801007e0 <cprintf>
80105345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105348:	83 c3 7c             	add    $0x7c,%ebx
8010534b:	81 fb 60 58 11 80    	cmp    $0x80115860,%ebx
80105351:	0f 84 81 00 00 00    	je     801053d8 <procdump+0xb8>
    if(p->state == UNUSED)
80105357:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010535a:	85 c0                	test   %eax,%eax
8010535c:	74 ea                	je     80105348 <procdump+0x28>
      state = "???";
8010535e:	ba 0b 89 10 80       	mov    $0x8010890b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105363:	83 f8 05             	cmp    $0x5,%eax
80105366:	77 11                	ja     80105379 <procdump+0x59>
80105368:	8b 14 85 6c 89 10 80 	mov    -0x7fef7694(,%eax,4),%edx
      state = "???";
8010536f:	b8 0b 89 10 80       	mov    $0x8010890b,%eax
80105374:	85 d2                	test   %edx,%edx
80105376:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105379:	53                   	push   %ebx
8010537a:	52                   	push   %edx
8010537b:	ff 73 a4             	push   -0x5c(%ebx)
8010537e:	68 0f 89 10 80       	push   $0x8010890f
80105383:	e8 58 b4 ff ff       	call   801007e0 <cprintf>
    if(p->state == SLEEPING){
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010538f:	75 a7                	jne    80105338 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105391:	83 ec 08             	sub    $0x8,%esp
80105394:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105397:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010539a:	50                   	push   %eax
8010539b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010539e:	8b 40 0c             	mov    0xc(%eax),%eax
801053a1:	83 c0 08             	add    $0x8,%eax
801053a4:	50                   	push   %eax
801053a5:	e8 86 01 00 00       	call   80105530 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
801053b0:	8b 17                	mov    (%edi),%edx
801053b2:	85 d2                	test   %edx,%edx
801053b4:	74 82                	je     80105338 <procdump+0x18>
        cprintf(" %p", pc[i]);
801053b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801053b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801053bc:	52                   	push   %edx
801053bd:	68 21 83 10 80       	push   $0x80108321
801053c2:	e8 19 b4 ff ff       	call   801007e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801053c7:	83 c4 10             	add    $0x10,%esp
801053ca:	39 fe                	cmp    %edi,%esi
801053cc:	75 e2                	jne    801053b0 <procdump+0x90>
801053ce:	e9 65 ff ff ff       	jmp    80105338 <procdump+0x18>
801053d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d7:	90                   	nop
  }
}
801053d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053db:	5b                   	pop    %ebx
801053dc:	5e                   	pop    %esi
801053dd:	5f                   	pop    %edi
801053de:	5d                   	pop    %ebp
801053df:	c3                   	ret    

801053e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801053ea:	68 84 89 10 80       	push   $0x80108984
801053ef:	8d 43 04             	lea    0x4(%ebx),%eax
801053f2:	50                   	push   %eax
801053f3:	e8 18 01 00 00       	call   80105510 <initlock>
  lk->name = name;
801053f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801053fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105401:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105404:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010540b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010540e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105411:	c9                   	leave  
80105412:	c3                   	ret    
80105413:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
80105425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105428:	8d 73 04             	lea    0x4(%ebx),%esi
8010542b:	83 ec 0c             	sub    $0xc,%esp
8010542e:	56                   	push   %esi
8010542f:	e8 ac 02 00 00       	call   801056e0 <acquire>
  while (lk->locked) {
80105434:	8b 13                	mov    (%ebx),%edx
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	85 d2                	test   %edx,%edx
8010543b:	74 16                	je     80105453 <acquiresleep+0x33>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	e8 36 fd ff ff       	call   80105180 <sleep>
  while (lk->locked) {
8010544a:	8b 03                	mov    (%ebx),%eax
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	85 c0                	test   %eax,%eax
80105451:	75 ed                	jne    80105440 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105453:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105459:	e8 52 f6 ff ff       	call   80104ab0 <myproc>
8010545e:	8b 40 10             	mov    0x10(%eax),%eax
80105461:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105464:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105467:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010546a:	5b                   	pop    %ebx
8010546b:	5e                   	pop    %esi
8010546c:	5d                   	pop    %ebp
  release(&lk->lk);
8010546d:	e9 0e 02 00 00       	jmp    80105680 <release>
80105472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105480 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
80105485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105488:	8d 73 04             	lea    0x4(%ebx),%esi
8010548b:	83 ec 0c             	sub    $0xc,%esp
8010548e:	56                   	push   %esi
8010548f:	e8 4c 02 00 00       	call   801056e0 <acquire>
  lk->locked = 0;
80105494:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010549a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801054a1:	89 1c 24             	mov    %ebx,(%esp)
801054a4:	e8 97 fd ff ff       	call   80105240 <wakeup>
  release(&lk->lk);
801054a9:	89 75 08             	mov    %esi,0x8(%ebp)
801054ac:	83 c4 10             	add    $0x10,%esp
}
801054af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5d                   	pop    %ebp
  release(&lk->lk);
801054b5:	e9 c6 01 00 00       	jmp    80105680 <release>
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	31 ff                	xor    %edi,%edi
801054c6:	56                   	push   %esi
801054c7:	53                   	push   %ebx
801054c8:	83 ec 18             	sub    $0x18,%esp
801054cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801054ce:	8d 73 04             	lea    0x4(%ebx),%esi
801054d1:	56                   	push   %esi
801054d2:	e8 09 02 00 00       	call   801056e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801054d7:	8b 03                	mov    (%ebx),%eax
801054d9:	83 c4 10             	add    $0x10,%esp
801054dc:	85 c0                	test   %eax,%eax
801054de:	75 18                	jne    801054f8 <holdingsleep+0x38>
  release(&lk->lk);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	56                   	push   %esi
801054e4:	e8 97 01 00 00       	call   80105680 <release>
  return r;
}
801054e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054ec:	89 f8                	mov    %edi,%eax
801054ee:	5b                   	pop    %ebx
801054ef:	5e                   	pop    %esi
801054f0:	5f                   	pop    %edi
801054f1:	5d                   	pop    %ebp
801054f2:	c3                   	ret    
801054f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801054f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801054fb:	e8 b0 f5 ff ff       	call   80104ab0 <myproc>
80105500:	39 58 10             	cmp    %ebx,0x10(%eax)
80105503:	0f 94 c0             	sete   %al
80105506:	0f b6 c0             	movzbl %al,%eax
80105509:	89 c7                	mov    %eax,%edi
8010550b:	eb d3                	jmp    801054e0 <holdingsleep+0x20>
8010550d:	66 90                	xchg   %ax,%ax
8010550f:	90                   	nop

80105510 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105516:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010551f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105529:	5d                   	pop    %ebp
8010552a:	c3                   	ret    
8010552b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop

80105530 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105530:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105531:	31 d2                	xor    %edx,%edx
{
80105533:	89 e5                	mov    %esp,%ebp
80105535:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105536:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010553c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010553f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105540:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105546:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010554c:	77 1a                	ja     80105568 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010554e:	8b 58 04             	mov    0x4(%eax),%ebx
80105551:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105554:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105557:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105559:	83 fa 0a             	cmp    $0xa,%edx
8010555c:	75 e2                	jne    80105540 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010555e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105561:	c9                   	leave  
80105562:	c3                   	ret    
80105563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105567:	90                   	nop
  for(; i < 10; i++)
80105568:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010556b:	8d 51 28             	lea    0x28(%ecx),%edx
8010556e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105576:	83 c0 04             	add    $0x4,%eax
80105579:	39 d0                	cmp    %edx,%eax
8010557b:	75 f3                	jne    80105570 <getcallerpcs+0x40>
}
8010557d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105580:	c9                   	leave  
80105581:	c3                   	ret    
80105582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105590 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 04             	sub    $0x4,%esp
80105597:	9c                   	pushf  
80105598:	5b                   	pop    %ebx
  asm volatile("cli");
80105599:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010559a:	e8 91 f4 ff ff       	call   80104a30 <mycpu>
8010559f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801055a5:	85 c0                	test   %eax,%eax
801055a7:	74 17                	je     801055c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801055a9:	e8 82 f4 ff ff       	call   80104a30 <mycpu>
801055ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801055b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055b8:	c9                   	leave  
801055b9:	c3                   	ret    
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801055c0:	e8 6b f4 ff ff       	call   80104a30 <mycpu>
801055c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801055cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801055d1:	eb d6                	jmp    801055a9 <pushcli+0x19>
801055d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055e0 <popcli>:

void
popcli(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801055e6:	9c                   	pushf  
801055e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801055e8:	f6 c4 02             	test   $0x2,%ah
801055eb:	75 35                	jne    80105622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801055ed:	e8 3e f4 ff ff       	call   80104a30 <mycpu>
801055f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801055f9:	78 34                	js     8010562f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801055fb:	e8 30 f4 ff ff       	call   80104a30 <mycpu>
80105600:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105606:	85 d2                	test   %edx,%edx
80105608:	74 06                	je     80105610 <popcli+0x30>
    sti();
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105610:	e8 1b f4 ff ff       	call   80104a30 <mycpu>
80105615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010561b:	85 c0                	test   %eax,%eax
8010561d:	74 eb                	je     8010560a <popcli+0x2a>
  asm volatile("sti");
8010561f:	fb                   	sti    
}
80105620:	c9                   	leave  
80105621:	c3                   	ret    
    panic("popcli - interruptible");
80105622:	83 ec 0c             	sub    $0xc,%esp
80105625:	68 8f 89 10 80       	push   $0x8010898f
8010562a:	e8 31 ae ff ff       	call   80100460 <panic>
    panic("popcli");
8010562f:	83 ec 0c             	sub    $0xc,%esp
80105632:	68 a6 89 10 80       	push   $0x801089a6
80105637:	e8 24 ae ff ff       	call   80100460 <panic>
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <holding>:
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	56                   	push   %esi
80105644:	53                   	push   %ebx
80105645:	8b 75 08             	mov    0x8(%ebp),%esi
80105648:	31 db                	xor    %ebx,%ebx
  pushcli();
8010564a:	e8 41 ff ff ff       	call   80105590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010564f:	8b 06                	mov    (%esi),%eax
80105651:	85 c0                	test   %eax,%eax
80105653:	75 0b                	jne    80105660 <holding+0x20>
  popcli();
80105655:	e8 86 ff ff ff       	call   801055e0 <popcli>
}
8010565a:	89 d8                	mov    %ebx,%eax
8010565c:	5b                   	pop    %ebx
8010565d:	5e                   	pop    %esi
8010565e:	5d                   	pop    %ebp
8010565f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105660:	8b 5e 08             	mov    0x8(%esi),%ebx
80105663:	e8 c8 f3 ff ff       	call   80104a30 <mycpu>
80105668:	39 c3                	cmp    %eax,%ebx
8010566a:	0f 94 c3             	sete   %bl
  popcli();
8010566d:	e8 6e ff ff ff       	call   801055e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105672:	0f b6 db             	movzbl %bl,%ebx
}
80105675:	89 d8                	mov    %ebx,%eax
80105677:	5b                   	pop    %ebx
80105678:	5e                   	pop    %esi
80105679:	5d                   	pop    %ebp
8010567a:	c3                   	ret    
8010567b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010567f:	90                   	nop

80105680 <release>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
80105685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105688:	e8 03 ff ff ff       	call   80105590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010568d:	8b 03                	mov    (%ebx),%eax
8010568f:	85 c0                	test   %eax,%eax
80105691:	75 15                	jne    801056a8 <release+0x28>
  popcli();
80105693:	e8 48 ff ff ff       	call   801055e0 <popcli>
    panic("release");
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	68 ad 89 10 80       	push   $0x801089ad
801056a0:	e8 bb ad ff ff       	call   80100460 <panic>
801056a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801056a8:	8b 73 08             	mov    0x8(%ebx),%esi
801056ab:	e8 80 f3 ff ff       	call   80104a30 <mycpu>
801056b0:	39 c6                	cmp    %eax,%esi
801056b2:	75 df                	jne    80105693 <release+0x13>
  popcli();
801056b4:	e8 27 ff ff ff       	call   801055e0 <popcli>
  lk->pcs[0] = 0;
801056b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801056c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801056c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801056cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801056d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056d5:	5b                   	pop    %ebx
801056d6:	5e                   	pop    %esi
801056d7:	5d                   	pop    %ebp
  popcli();
801056d8:	e9 03 ff ff ff       	jmp    801055e0 <popcli>
801056dd:	8d 76 00             	lea    0x0(%esi),%esi

801056e0 <acquire>:
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	53                   	push   %ebx
801056e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801056e7:	e8 a4 fe ff ff       	call   80105590 <pushcli>
  if(holding(lk))
801056ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801056ef:	e8 9c fe ff ff       	call   80105590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801056f4:	8b 03                	mov    (%ebx),%eax
801056f6:	85 c0                	test   %eax,%eax
801056f8:	75 7e                	jne    80105778 <acquire+0x98>
  popcli();
801056fa:	e8 e1 fe ff ff       	call   801055e0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801056ff:	b9 01 00 00 00       	mov    $0x1,%ecx
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105708:	8b 55 08             	mov    0x8(%ebp),%edx
8010570b:	89 c8                	mov    %ecx,%eax
8010570d:	f0 87 02             	lock xchg %eax,(%edx)
80105710:	85 c0                	test   %eax,%eax
80105712:	75 f4                	jne    80105708 <acquire+0x28>
  __sync_synchronize();
80105714:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010571c:	e8 0f f3 ff ff       	call   80104a30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105721:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105724:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105726:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105729:	31 c0                	xor    %eax,%eax
8010572b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105730:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105736:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010573c:	77 1a                	ja     80105758 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010573e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105741:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105745:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105748:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010574a:	83 f8 0a             	cmp    $0xa,%eax
8010574d:	75 e1                	jne    80105730 <acquire+0x50>
}
8010574f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105752:	c9                   	leave  
80105753:	c3                   	ret    
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105758:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010575c:	8d 51 34             	lea    0x34(%ecx),%edx
8010575f:	90                   	nop
    pcs[i] = 0;
80105760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105766:	83 c0 04             	add    $0x4,%eax
80105769:	39 c2                	cmp    %eax,%edx
8010576b:	75 f3                	jne    80105760 <acquire+0x80>
}
8010576d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105770:	c9                   	leave  
80105771:	c3                   	ret    
80105772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105778:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010577b:	e8 b0 f2 ff ff       	call   80104a30 <mycpu>
80105780:	39 c3                	cmp    %eax,%ebx
80105782:	0f 85 72 ff ff ff    	jne    801056fa <acquire+0x1a>
  popcli();
80105788:	e8 53 fe ff ff       	call   801055e0 <popcli>
    panic("acquire");
8010578d:	83 ec 0c             	sub    $0xc,%esp
80105790:	68 b5 89 10 80       	push   $0x801089b5
80105795:	e8 c6 ac ff ff       	call   80100460 <panic>
8010579a:	66 90                	xchg   %ax,%ax
8010579c:	66 90                	xchg   %ax,%ax
8010579e:	66 90                	xchg   %ax,%ax

801057a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	8b 55 08             	mov    0x8(%ebp),%edx
801057a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801057aa:	53                   	push   %ebx
801057ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801057ae:	89 d7                	mov    %edx,%edi
801057b0:	09 cf                	or     %ecx,%edi
801057b2:	83 e7 03             	and    $0x3,%edi
801057b5:	75 29                	jne    801057e0 <memset+0x40>
    c &= 0xFF;
801057b7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801057ba:	c1 e0 18             	shl    $0x18,%eax
801057bd:	89 fb                	mov    %edi,%ebx
801057bf:	c1 e9 02             	shr    $0x2,%ecx
801057c2:	c1 e3 10             	shl    $0x10,%ebx
801057c5:	09 d8                	or     %ebx,%eax
801057c7:	09 f8                	or     %edi,%eax
801057c9:	c1 e7 08             	shl    $0x8,%edi
801057cc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801057ce:	89 d7                	mov    %edx,%edi
801057d0:	fc                   	cld    
801057d1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801057d3:	5b                   	pop    %ebx
801057d4:	89 d0                	mov    %edx,%eax
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801057e0:	89 d7                	mov    %edx,%edi
801057e2:	fc                   	cld    
801057e3:	f3 aa                	rep stos %al,%es:(%edi)
801057e5:	5b                   	pop    %ebx
801057e6:	89 d0                	mov    %edx,%eax
801057e8:	5f                   	pop    %edi
801057e9:	5d                   	pop    %ebp
801057ea:	c3                   	ret    
801057eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop

801057f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	56                   	push   %esi
801057f4:	8b 75 10             	mov    0x10(%ebp),%esi
801057f7:	8b 55 08             	mov    0x8(%ebp),%edx
801057fa:	53                   	push   %ebx
801057fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801057fe:	85 f6                	test   %esi,%esi
80105800:	74 2e                	je     80105830 <memcmp+0x40>
80105802:	01 c6                	add    %eax,%esi
80105804:	eb 14                	jmp    8010581a <memcmp+0x2a>
80105806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105810:	83 c0 01             	add    $0x1,%eax
80105813:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105816:	39 f0                	cmp    %esi,%eax
80105818:	74 16                	je     80105830 <memcmp+0x40>
    if(*s1 != *s2)
8010581a:	0f b6 0a             	movzbl (%edx),%ecx
8010581d:	0f b6 18             	movzbl (%eax),%ebx
80105820:	38 d9                	cmp    %bl,%cl
80105822:	74 ec                	je     80105810 <memcmp+0x20>
      return *s1 - *s2;
80105824:	0f b6 c1             	movzbl %cl,%eax
80105827:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105829:	5b                   	pop    %ebx
8010582a:	5e                   	pop    %esi
8010582b:	5d                   	pop    %ebp
8010582c:	c3                   	ret    
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
80105830:	5b                   	pop    %ebx
  return 0;
80105831:	31 c0                	xor    %eax,%eax
}
80105833:	5e                   	pop    %esi
80105834:	5d                   	pop    %ebp
80105835:	c3                   	ret    
80105836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583d:	8d 76 00             	lea    0x0(%esi),%esi

80105840 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	8b 55 08             	mov    0x8(%ebp),%edx
80105847:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010584a:	56                   	push   %esi
8010584b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010584e:	39 d6                	cmp    %edx,%esi
80105850:	73 26                	jae    80105878 <memmove+0x38>
80105852:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105855:	39 fa                	cmp    %edi,%edx
80105857:	73 1f                	jae    80105878 <memmove+0x38>
80105859:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010585c:	85 c9                	test   %ecx,%ecx
8010585e:	74 0c                	je     8010586c <memmove+0x2c>
      *--d = *--s;
80105860:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105864:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105867:	83 e8 01             	sub    $0x1,%eax
8010586a:	73 f4                	jae    80105860 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010586c:	5e                   	pop    %esi
8010586d:	89 d0                	mov    %edx,%eax
8010586f:	5f                   	pop    %edi
80105870:	5d                   	pop    %ebp
80105871:	c3                   	ret    
80105872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105878:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010587b:	89 d7                	mov    %edx,%edi
8010587d:	85 c9                	test   %ecx,%ecx
8010587f:	74 eb                	je     8010586c <memmove+0x2c>
80105881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105888:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105889:	39 c6                	cmp    %eax,%esi
8010588b:	75 fb                	jne    80105888 <memmove+0x48>
}
8010588d:	5e                   	pop    %esi
8010588e:	89 d0                	mov    %edx,%eax
80105890:	5f                   	pop    %edi
80105891:	5d                   	pop    %ebp
80105892:	c3                   	ret    
80105893:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801058a0:	eb 9e                	jmp    80105840 <memmove>
801058a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	56                   	push   %esi
801058b4:	8b 75 10             	mov    0x10(%ebp),%esi
801058b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801058ba:	53                   	push   %ebx
801058bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801058be:	85 f6                	test   %esi,%esi
801058c0:	74 2e                	je     801058f0 <strncmp+0x40>
801058c2:	01 d6                	add    %edx,%esi
801058c4:	eb 18                	jmp    801058de <strncmp+0x2e>
801058c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cd:	8d 76 00             	lea    0x0(%esi),%esi
801058d0:	38 d8                	cmp    %bl,%al
801058d2:	75 14                	jne    801058e8 <strncmp+0x38>
    n--, p++, q++;
801058d4:	83 c2 01             	add    $0x1,%edx
801058d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801058da:	39 f2                	cmp    %esi,%edx
801058dc:	74 12                	je     801058f0 <strncmp+0x40>
801058de:	0f b6 01             	movzbl (%ecx),%eax
801058e1:	0f b6 1a             	movzbl (%edx),%ebx
801058e4:	84 c0                	test   %al,%al
801058e6:	75 e8                	jne    801058d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801058e8:	29 d8                	sub    %ebx,%eax
}
801058ea:	5b                   	pop    %ebx
801058eb:	5e                   	pop    %esi
801058ec:	5d                   	pop    %ebp
801058ed:	c3                   	ret    
801058ee:	66 90                	xchg   %ax,%ax
801058f0:	5b                   	pop    %ebx
    return 0;
801058f1:	31 c0                	xor    %eax,%eax
}
801058f3:	5e                   	pop    %esi
801058f4:	5d                   	pop    %ebp
801058f5:	c3                   	ret    
801058f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fd:	8d 76 00             	lea    0x0(%esi),%esi

80105900 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	57                   	push   %edi
80105904:	56                   	push   %esi
80105905:	8b 75 08             	mov    0x8(%ebp),%esi
80105908:	53                   	push   %ebx
80105909:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010590c:	89 f0                	mov    %esi,%eax
8010590e:	eb 15                	jmp    80105925 <strncpy+0x25>
80105910:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105914:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105917:	83 c0 01             	add    $0x1,%eax
8010591a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010591e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105921:	84 d2                	test   %dl,%dl
80105923:	74 09                	je     8010592e <strncpy+0x2e>
80105925:	89 cb                	mov    %ecx,%ebx
80105927:	83 e9 01             	sub    $0x1,%ecx
8010592a:	85 db                	test   %ebx,%ebx
8010592c:	7f e2                	jg     80105910 <strncpy+0x10>
    ;
  while(n-- > 0)
8010592e:	89 c2                	mov    %eax,%edx
80105930:	85 c9                	test   %ecx,%ecx
80105932:	7e 17                	jle    8010594b <strncpy+0x4b>
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105938:	83 c2 01             	add    $0x1,%edx
8010593b:	89 c1                	mov    %eax,%ecx
8010593d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105941:	29 d1                	sub    %edx,%ecx
80105943:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105947:	85 c9                	test   %ecx,%ecx
80105949:	7f ed                	jg     80105938 <strncpy+0x38>
  return os;
}
8010594b:	5b                   	pop    %ebx
8010594c:	89 f0                	mov    %esi,%eax
8010594e:	5e                   	pop    %esi
8010594f:	5f                   	pop    %edi
80105950:	5d                   	pop    %ebp
80105951:	c3                   	ret    
80105952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105960 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	56                   	push   %esi
80105964:	8b 55 10             	mov    0x10(%ebp),%edx
80105967:	8b 75 08             	mov    0x8(%ebp),%esi
8010596a:	53                   	push   %ebx
8010596b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010596e:	85 d2                	test   %edx,%edx
80105970:	7e 25                	jle    80105997 <safestrcpy+0x37>
80105972:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105976:	89 f2                	mov    %esi,%edx
80105978:	eb 16                	jmp    80105990 <safestrcpy+0x30>
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105980:	0f b6 08             	movzbl (%eax),%ecx
80105983:	83 c0 01             	add    $0x1,%eax
80105986:	83 c2 01             	add    $0x1,%edx
80105989:	88 4a ff             	mov    %cl,-0x1(%edx)
8010598c:	84 c9                	test   %cl,%cl
8010598e:	74 04                	je     80105994 <safestrcpy+0x34>
80105990:	39 d8                	cmp    %ebx,%eax
80105992:	75 ec                	jne    80105980 <safestrcpy+0x20>
    ;
  *s = 0;
80105994:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105997:	89 f0                	mov    %esi,%eax
80105999:	5b                   	pop    %ebx
8010599a:	5e                   	pop    %esi
8010599b:	5d                   	pop    %ebp
8010599c:	c3                   	ret    
8010599d:	8d 76 00             	lea    0x0(%esi),%esi

801059a0 <strlen>:

int
strlen(const char *s)
{
801059a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801059a1:	31 c0                	xor    %eax,%eax
{
801059a3:	89 e5                	mov    %esp,%ebp
801059a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801059a8:	80 3a 00             	cmpb   $0x0,(%edx)
801059ab:	74 0c                	je     801059b9 <strlen+0x19>
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
801059b0:	83 c0 01             	add    $0x1,%eax
801059b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801059b7:	75 f7                	jne    801059b0 <strlen+0x10>
    ;
  return n;
}
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    

801059bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801059bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801059bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801059c3:	55                   	push   %ebp
  pushl %ebx
801059c4:	53                   	push   %ebx
  pushl %esi
801059c5:	56                   	push   %esi
  pushl %edi
801059c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801059c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801059c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801059cb:	5f                   	pop    %edi
  popl %esi
801059cc:	5e                   	pop    %esi
  popl %ebx
801059cd:	5b                   	pop    %ebx
  popl %ebp
801059ce:	5d                   	pop    %ebp
  ret
801059cf:	c3                   	ret    

801059d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
801059d4:	83 ec 04             	sub    $0x4,%esp
801059d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801059da:	e8 d1 f0 ff ff       	call   80104ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801059df:	8b 00                	mov    (%eax),%eax
801059e1:	39 d8                	cmp    %ebx,%eax
801059e3:	76 1b                	jbe    80105a00 <fetchint+0x30>
801059e5:	8d 53 04             	lea    0x4(%ebx),%edx
801059e8:	39 d0                	cmp    %edx,%eax
801059ea:	72 14                	jb     80105a00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801059ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ef:	8b 13                	mov    (%ebx),%edx
801059f1:	89 10                	mov    %edx,(%eax)
  return 0;
801059f3:	31 c0                	xor    %eax,%eax
}
801059f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f8:	c9                   	leave  
801059f9:	c3                   	ret    
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a05:	eb ee                	jmp    801059f5 <fetchint+0x25>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
80105a14:	83 ec 04             	sub    $0x4,%esp
80105a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105a1a:	e8 91 f0 ff ff       	call   80104ab0 <myproc>

  if(addr >= curproc->sz)
80105a1f:	39 18                	cmp    %ebx,(%eax)
80105a21:	76 2d                	jbe    80105a50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105a23:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105a28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105a2a:	39 d3                	cmp    %edx,%ebx
80105a2c:	73 22                	jae    80105a50 <fetchstr+0x40>
80105a2e:	89 d8                	mov    %ebx,%eax
80105a30:	eb 0d                	jmp    80105a3f <fetchstr+0x2f>
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a38:	83 c0 01             	add    $0x1,%eax
80105a3b:	39 c2                	cmp    %eax,%edx
80105a3d:	76 11                	jbe    80105a50 <fetchstr+0x40>
    if(*s == 0)
80105a3f:	80 38 00             	cmpb   $0x0,(%eax)
80105a42:	75 f4                	jne    80105a38 <fetchstr+0x28>
      return s - *pp;
80105a44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105a46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a49:	c9                   	leave  
80105a4a:	c3                   	ret    
80105a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a4f:	90                   	nop
80105a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a58:	c9                   	leave  
80105a59:	c3                   	ret    
80105a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	56                   	push   %esi
80105a64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a65:	e8 46 f0 ff ff       	call   80104ab0 <myproc>
80105a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80105a6d:	8b 40 18             	mov    0x18(%eax),%eax
80105a70:	8b 40 44             	mov    0x44(%eax),%eax
80105a73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105a76:	e8 35 f0 ff ff       	call   80104ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a7e:	8b 00                	mov    (%eax),%eax
80105a80:	39 c6                	cmp    %eax,%esi
80105a82:	73 1c                	jae    80105aa0 <argint+0x40>
80105a84:	8d 53 08             	lea    0x8(%ebx),%edx
80105a87:	39 d0                	cmp    %edx,%eax
80105a89:	72 15                	jb     80105aa0 <argint+0x40>
  *ip = *(int*)(addr);
80105a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a8e:	8b 53 04             	mov    0x4(%ebx),%edx
80105a91:	89 10                	mov    %edx,(%eax)
  return 0;
80105a93:	31 c0                	xor    %eax,%eax
}
80105a95:	5b                   	pop    %ebx
80105a96:	5e                   	pop    %esi
80105a97:	5d                   	pop    %ebp
80105a98:	c3                   	ret    
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105aa5:	eb ee                	jmp    80105a95 <argint+0x35>
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
80105ab6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105ab9:	e8 f2 ef ff ff       	call   80104ab0 <myproc>
80105abe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ac0:	e8 eb ef ff ff       	call   80104ab0 <myproc>
80105ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80105ac8:	8b 40 18             	mov    0x18(%eax),%eax
80105acb:	8b 40 44             	mov    0x44(%eax),%eax
80105ace:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105ad1:	e8 da ef ff ff       	call   80104ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ad6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105ad9:	8b 00                	mov    (%eax),%eax
80105adb:	39 c7                	cmp    %eax,%edi
80105add:	73 31                	jae    80105b10 <argptr+0x60>
80105adf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105ae2:	39 c8                	cmp    %ecx,%eax
80105ae4:	72 2a                	jb     80105b10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105ae6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105ae9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105aec:	85 d2                	test   %edx,%edx
80105aee:	78 20                	js     80105b10 <argptr+0x60>
80105af0:	8b 16                	mov    (%esi),%edx
80105af2:	39 c2                	cmp    %eax,%edx
80105af4:	76 1a                	jbe    80105b10 <argptr+0x60>
80105af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105af9:	01 c3                	add    %eax,%ebx
80105afb:	39 da                	cmp    %ebx,%edx
80105afd:	72 11                	jb     80105b10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105aff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b02:	89 02                	mov    %eax,(%edx)
  return 0;
80105b04:	31 c0                	xor    %eax,%eax
}
80105b06:	83 c4 0c             	add    $0xc,%esp
80105b09:	5b                   	pop    %ebx
80105b0a:	5e                   	pop    %esi
80105b0b:	5f                   	pop    %edi
80105b0c:	5d                   	pop    %ebp
80105b0d:	c3                   	ret    
80105b0e:	66 90                	xchg   %ax,%ax
    return -1;
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b15:	eb ef                	jmp    80105b06 <argptr+0x56>
80105b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	56                   	push   %esi
80105b24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b25:	e8 86 ef ff ff       	call   80104ab0 <myproc>
80105b2a:	8b 55 08             	mov    0x8(%ebp),%edx
80105b2d:	8b 40 18             	mov    0x18(%eax),%eax
80105b30:	8b 40 44             	mov    0x44(%eax),%eax
80105b33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105b36:	e8 75 ef ff ff       	call   80104ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b3e:	8b 00                	mov    (%eax),%eax
80105b40:	39 c6                	cmp    %eax,%esi
80105b42:	73 44                	jae    80105b88 <argstr+0x68>
80105b44:	8d 53 08             	lea    0x8(%ebx),%edx
80105b47:	39 d0                	cmp    %edx,%eax
80105b49:	72 3d                	jb     80105b88 <argstr+0x68>
  *ip = *(int*)(addr);
80105b4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105b4e:	e8 5d ef ff ff       	call   80104ab0 <myproc>
  if(addr >= curproc->sz)
80105b53:	3b 18                	cmp    (%eax),%ebx
80105b55:	73 31                	jae    80105b88 <argstr+0x68>
  *pp = (char*)addr;
80105b57:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105b5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105b5e:	39 d3                	cmp    %edx,%ebx
80105b60:	73 26                	jae    80105b88 <argstr+0x68>
80105b62:	89 d8                	mov    %ebx,%eax
80105b64:	eb 11                	jmp    80105b77 <argstr+0x57>
80105b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi
80105b70:	83 c0 01             	add    $0x1,%eax
80105b73:	39 c2                	cmp    %eax,%edx
80105b75:	76 11                	jbe    80105b88 <argstr+0x68>
    if(*s == 0)
80105b77:	80 38 00             	cmpb   $0x0,(%eax)
80105b7a:	75 f4                	jne    80105b70 <argstr+0x50>
      return s - *pp;
80105b7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105b7e:	5b                   	pop    %ebx
80105b7f:	5e                   	pop    %esi
80105b80:	5d                   	pop    %ebp
80105b81:	c3                   	ret    
80105b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b88:	5b                   	pop    %ebx
    return -1;
80105b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b8e:	5e                   	pop    %esi
80105b8f:	5d                   	pop    %ebp
80105b90:	c3                   	ret    
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop

80105ba0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
80105ba4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105ba7:	e8 04 ef ff ff       	call   80104ab0 <myproc>
80105bac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105bae:	8b 40 18             	mov    0x18(%eax),%eax
80105bb1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105bb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80105bb7:	83 fa 14             	cmp    $0x14,%edx
80105bba:	77 24                	ja     80105be0 <syscall+0x40>
80105bbc:	8b 14 85 e0 89 10 80 	mov    -0x7fef7620(,%eax,4),%edx
80105bc3:	85 d2                	test   %edx,%edx
80105bc5:	74 19                	je     80105be0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105bc7:	ff d2                	call   *%edx
80105bc9:	89 c2                	mov    %eax,%edx
80105bcb:	8b 43 18             	mov    0x18(%ebx),%eax
80105bce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bd4:	c9                   	leave  
80105bd5:	c3                   	ret    
80105bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105be0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105be1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105be4:	50                   	push   %eax
80105be5:	ff 73 10             	push   0x10(%ebx)
80105be8:	68 bd 89 10 80       	push   $0x801089bd
80105bed:	e8 ee ab ff ff       	call   801007e0 <cprintf>
    curproc->tf->eax = -1;
80105bf2:	8b 43 18             	mov    0x18(%ebx),%eax
80105bf5:	83 c4 10             	add    $0x10,%esp
80105bf8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    
80105c04:	66 90                	xchg   %ax,%ax
80105c06:	66 90                	xchg   %ax,%ax
80105c08:	66 90                	xchg   %ax,%ax
80105c0a:	66 90                	xchg   %ax,%ax
80105c0c:	66 90                	xchg   %ax,%ax
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105c18:	53                   	push   %ebx
80105c19:	83 ec 34             	sub    $0x34,%esp
80105c1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105c1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105c22:	57                   	push   %edi
80105c23:	50                   	push   %eax
{
80105c24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105c27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105c2a:	e8 d1 d5 ff ff       	call   80103200 <nameiparent>
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	85 c0                	test   %eax,%eax
80105c34:	0f 84 46 01 00 00    	je     80105d80 <create+0x170>
    return 0;
  ilock(dp);
80105c3a:	83 ec 0c             	sub    $0xc,%esp
80105c3d:	89 c3                	mov    %eax,%ebx
80105c3f:	50                   	push   %eax
80105c40:	e8 7b cc ff ff       	call   801028c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105c45:	83 c4 0c             	add    $0xc,%esp
80105c48:	6a 00                	push   $0x0
80105c4a:	57                   	push   %edi
80105c4b:	53                   	push   %ebx
80105c4c:	e8 cf d1 ff ff       	call   80102e20 <dirlookup>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	89 c6                	mov    %eax,%esi
80105c56:	85 c0                	test   %eax,%eax
80105c58:	74 56                	je     80105cb0 <create+0xa0>
    iunlockput(dp);
80105c5a:	83 ec 0c             	sub    $0xc,%esp
80105c5d:	53                   	push   %ebx
80105c5e:	e8 ed ce ff ff       	call   80102b50 <iunlockput>
    ilock(ip);
80105c63:	89 34 24             	mov    %esi,(%esp)
80105c66:	e8 55 cc ff ff       	call   801028c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c6b:	83 c4 10             	add    $0x10,%esp
80105c6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c73:	75 1b                	jne    80105c90 <create+0x80>
80105c75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105c7a:	75 14                	jne    80105c90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c7f:	89 f0                	mov    %esi,%eax
80105c81:	5b                   	pop    %ebx
80105c82:	5e                   	pop    %esi
80105c83:	5f                   	pop    %edi
80105c84:	5d                   	pop    %ebp
80105c85:	c3                   	ret    
80105c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	56                   	push   %esi
    return 0;
80105c94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105c96:	e8 b5 ce ff ff       	call   80102b50 <iunlockput>
    return 0;
80105c9b:	83 c4 10             	add    $0x10,%esp
}
80105c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca1:	89 f0                	mov    %esi,%eax
80105ca3:	5b                   	pop    %ebx
80105ca4:	5e                   	pop    %esi
80105ca5:	5f                   	pop    %edi
80105ca6:	5d                   	pop    %ebp
80105ca7:	c3                   	ret    
80105ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105cb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105cb4:	83 ec 08             	sub    $0x8,%esp
80105cb7:	50                   	push   %eax
80105cb8:	ff 33                	push   (%ebx)
80105cba:	e8 91 ca ff ff       	call   80102750 <ialloc>
80105cbf:	83 c4 10             	add    $0x10,%esp
80105cc2:	89 c6                	mov    %eax,%esi
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	0f 84 cd 00 00 00    	je     80105d99 <create+0x189>
  ilock(ip);
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	50                   	push   %eax
80105cd0:	e8 eb cb ff ff       	call   801028c0 <ilock>
  ip->major = major;
80105cd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105cd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105cdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105ce1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105ce5:	b8 01 00 00 00       	mov    $0x1,%eax
80105cea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105cee:	89 34 24             	mov    %esi,(%esp)
80105cf1:	e8 1a cb ff ff       	call   80102810 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105cfe:	74 30                	je     80105d30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105d00:	83 ec 04             	sub    $0x4,%esp
80105d03:	ff 76 04             	push   0x4(%esi)
80105d06:	57                   	push   %edi
80105d07:	53                   	push   %ebx
80105d08:	e8 13 d4 ff ff       	call   80103120 <dirlink>
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	85 c0                	test   %eax,%eax
80105d12:	78 78                	js     80105d8c <create+0x17c>
  iunlockput(dp);
80105d14:	83 ec 0c             	sub    $0xc,%esp
80105d17:	53                   	push   %ebx
80105d18:	e8 33 ce ff ff       	call   80102b50 <iunlockput>
  return ip;
80105d1d:	83 c4 10             	add    $0x10,%esp
}
80105d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d23:	89 f0                	mov    %esi,%eax
80105d25:	5b                   	pop    %ebx
80105d26:	5e                   	pop    %esi
80105d27:	5f                   	pop    %edi
80105d28:	5d                   	pop    %ebp
80105d29:	c3                   	ret    
80105d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105d30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105d33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105d38:	53                   	push   %ebx
80105d39:	e8 d2 ca ff ff       	call   80102810 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d3e:	83 c4 0c             	add    $0xc,%esp
80105d41:	ff 76 04             	push   0x4(%esi)
80105d44:	68 54 8a 10 80       	push   $0x80108a54
80105d49:	56                   	push   %esi
80105d4a:	e8 d1 d3 ff ff       	call   80103120 <dirlink>
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	85 c0                	test   %eax,%eax
80105d54:	78 18                	js     80105d6e <create+0x15e>
80105d56:	83 ec 04             	sub    $0x4,%esp
80105d59:	ff 73 04             	push   0x4(%ebx)
80105d5c:	68 53 8a 10 80       	push   $0x80108a53
80105d61:	56                   	push   %esi
80105d62:	e8 b9 d3 ff ff       	call   80103120 <dirlink>
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	85 c0                	test   %eax,%eax
80105d6c:	79 92                	jns    80105d00 <create+0xf0>
      panic("create dots");
80105d6e:	83 ec 0c             	sub    $0xc,%esp
80105d71:	68 47 8a 10 80       	push   $0x80108a47
80105d76:	e8 e5 a6 ff ff       	call   80100460 <panic>
80105d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d7f:	90                   	nop
}
80105d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105d83:	31 f6                	xor    %esi,%esi
}
80105d85:	5b                   	pop    %ebx
80105d86:	89 f0                	mov    %esi,%eax
80105d88:	5e                   	pop    %esi
80105d89:	5f                   	pop    %edi
80105d8a:	5d                   	pop    %ebp
80105d8b:	c3                   	ret    
    panic("create: dirlink");
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	68 56 8a 10 80       	push   $0x80108a56
80105d94:	e8 c7 a6 ff ff       	call   80100460 <panic>
    panic("create: ialloc");
80105d99:	83 ec 0c             	sub    $0xc,%esp
80105d9c:	68 38 8a 10 80       	push   $0x80108a38
80105da1:	e8 ba a6 ff ff       	call   80100460 <panic>
80105da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dad:	8d 76 00             	lea    0x0(%esi),%esi

80105db0 <sys_dup>:
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	56                   	push   %esi
80105db4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105db8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105dbb:	50                   	push   %eax
80105dbc:	6a 00                	push   $0x0
80105dbe:	e8 9d fc ff ff       	call   80105a60 <argint>
80105dc3:	83 c4 10             	add    $0x10,%esp
80105dc6:	85 c0                	test   %eax,%eax
80105dc8:	78 36                	js     80105e00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105dca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105dce:	77 30                	ja     80105e00 <sys_dup+0x50>
80105dd0:	e8 db ec ff ff       	call   80104ab0 <myproc>
80105dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105ddc:	85 f6                	test   %esi,%esi
80105dde:	74 20                	je     80105e00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105de0:	e8 cb ec ff ff       	call   80104ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105de5:	31 db                	xor    %ebx,%ebx
80105de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105df0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105df4:	85 d2                	test   %edx,%edx
80105df6:	74 18                	je     80105e10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105df8:	83 c3 01             	add    $0x1,%ebx
80105dfb:	83 fb 10             	cmp    $0x10,%ebx
80105dfe:	75 f0                	jne    80105df0 <sys_dup+0x40>
}
80105e00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105e03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105e08:	89 d8                	mov    %ebx,%eax
80105e0a:	5b                   	pop    %ebx
80105e0b:	5e                   	pop    %esi
80105e0c:	5d                   	pop    %ebp
80105e0d:	c3                   	ret    
80105e0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105e10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105e17:	56                   	push   %esi
80105e18:	e8 c3 c1 ff ff       	call   80101fe0 <filedup>
  return fd;
80105e1d:	83 c4 10             	add    $0x10,%esp
}
80105e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e23:	89 d8                	mov    %ebx,%eax
80105e25:	5b                   	pop    %ebx
80105e26:	5e                   	pop    %esi
80105e27:	5d                   	pop    %ebp
80105e28:	c3                   	ret    
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_read>:
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	56                   	push   %esi
80105e34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105e35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105e38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e3b:	53                   	push   %ebx
80105e3c:	6a 00                	push   $0x0
80105e3e:	e8 1d fc ff ff       	call   80105a60 <argint>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	78 5e                	js     80105ea8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105e4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e4e:	77 58                	ja     80105ea8 <sys_read+0x78>
80105e50:	e8 5b ec ff ff       	call   80104ab0 <myproc>
80105e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105e5c:	85 f6                	test   %esi,%esi
80105e5e:	74 48                	je     80105ea8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e60:	83 ec 08             	sub    $0x8,%esp
80105e63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e66:	50                   	push   %eax
80105e67:	6a 02                	push   $0x2
80105e69:	e8 f2 fb ff ff       	call   80105a60 <argint>
80105e6e:	83 c4 10             	add    $0x10,%esp
80105e71:	85 c0                	test   %eax,%eax
80105e73:	78 33                	js     80105ea8 <sys_read+0x78>
80105e75:	83 ec 04             	sub    $0x4,%esp
80105e78:	ff 75 f0             	push   -0x10(%ebp)
80105e7b:	53                   	push   %ebx
80105e7c:	6a 01                	push   $0x1
80105e7e:	e8 2d fc ff ff       	call   80105ab0 <argptr>
80105e83:	83 c4 10             	add    $0x10,%esp
80105e86:	85 c0                	test   %eax,%eax
80105e88:	78 1e                	js     80105ea8 <sys_read+0x78>
  return fileread(f, p, n);
80105e8a:	83 ec 04             	sub    $0x4,%esp
80105e8d:	ff 75 f0             	push   -0x10(%ebp)
80105e90:	ff 75 f4             	push   -0xc(%ebp)
80105e93:	56                   	push   %esi
80105e94:	e8 c7 c2 ff ff       	call   80102160 <fileread>
80105e99:	83 c4 10             	add    $0x10,%esp
}
80105e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e9f:	5b                   	pop    %ebx
80105ea0:	5e                   	pop    %esi
80105ea1:	5d                   	pop    %ebp
80105ea2:	c3                   	ret    
80105ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ea7:	90                   	nop
    return -1;
80105ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ead:	eb ed                	jmp    80105e9c <sys_read+0x6c>
80105eaf:	90                   	nop

80105eb0 <sys_write>:
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	56                   	push   %esi
80105eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105eb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105ebb:	53                   	push   %ebx
80105ebc:	6a 00                	push   $0x0
80105ebe:	e8 9d fb ff ff       	call   80105a60 <argint>
80105ec3:	83 c4 10             	add    $0x10,%esp
80105ec6:	85 c0                	test   %eax,%eax
80105ec8:	78 5e                	js     80105f28 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105ece:	77 58                	ja     80105f28 <sys_write+0x78>
80105ed0:	e8 db eb ff ff       	call   80104ab0 <myproc>
80105ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ed8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105edc:	85 f6                	test   %esi,%esi
80105ede:	74 48                	je     80105f28 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ee0:	83 ec 08             	sub    $0x8,%esp
80105ee3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ee6:	50                   	push   %eax
80105ee7:	6a 02                	push   $0x2
80105ee9:	e8 72 fb ff ff       	call   80105a60 <argint>
80105eee:	83 c4 10             	add    $0x10,%esp
80105ef1:	85 c0                	test   %eax,%eax
80105ef3:	78 33                	js     80105f28 <sys_write+0x78>
80105ef5:	83 ec 04             	sub    $0x4,%esp
80105ef8:	ff 75 f0             	push   -0x10(%ebp)
80105efb:	53                   	push   %ebx
80105efc:	6a 01                	push   $0x1
80105efe:	e8 ad fb ff ff       	call   80105ab0 <argptr>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	85 c0                	test   %eax,%eax
80105f08:	78 1e                	js     80105f28 <sys_write+0x78>
  return filewrite(f, p, n);
80105f0a:	83 ec 04             	sub    $0x4,%esp
80105f0d:	ff 75 f0             	push   -0x10(%ebp)
80105f10:	ff 75 f4             	push   -0xc(%ebp)
80105f13:	56                   	push   %esi
80105f14:	e8 d7 c2 ff ff       	call   801021f0 <filewrite>
80105f19:	83 c4 10             	add    $0x10,%esp
}
80105f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f1f:	5b                   	pop    %ebx
80105f20:	5e                   	pop    %esi
80105f21:	5d                   	pop    %ebp
80105f22:	c3                   	ret    
80105f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f27:	90                   	nop
    return -1;
80105f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2d:	eb ed                	jmp    80105f1c <sys_write+0x6c>
80105f2f:	90                   	nop

80105f30 <sys_close>:
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	56                   	push   %esi
80105f34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105f3b:	50                   	push   %eax
80105f3c:	6a 00                	push   $0x0
80105f3e:	e8 1d fb ff ff       	call   80105a60 <argint>
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 c0                	test   %eax,%eax
80105f48:	78 3e                	js     80105f88 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f4e:	77 38                	ja     80105f88 <sys_close+0x58>
80105f50:	e8 5b eb ff ff       	call   80104ab0 <myproc>
80105f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f58:	8d 5a 08             	lea    0x8(%edx),%ebx
80105f5b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105f5f:	85 f6                	test   %esi,%esi
80105f61:	74 25                	je     80105f88 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105f63:	e8 48 eb ff ff       	call   80104ab0 <myproc>
  fileclose(f);
80105f68:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105f6b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105f72:	00 
  fileclose(f);
80105f73:	56                   	push   %esi
80105f74:	e8 b7 c0 ff ff       	call   80102030 <fileclose>
  return 0;
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	31 c0                	xor    %eax,%eax
}
80105f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f81:	5b                   	pop    %ebx
80105f82:	5e                   	pop    %esi
80105f83:	5d                   	pop    %ebp
80105f84:	c3                   	ret    
80105f85:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8d:	eb ef                	jmp    80105f7e <sys_close+0x4e>
80105f8f:	90                   	nop

80105f90 <sys_fstat>:
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	56                   	push   %esi
80105f94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105f95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105f98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105f9b:	53                   	push   %ebx
80105f9c:	6a 00                	push   $0x0
80105f9e:	e8 bd fa ff ff       	call   80105a60 <argint>
80105fa3:	83 c4 10             	add    $0x10,%esp
80105fa6:	85 c0                	test   %eax,%eax
80105fa8:	78 46                	js     80105ff0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105faa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105fae:	77 40                	ja     80105ff0 <sys_fstat+0x60>
80105fb0:	e8 fb ea ff ff       	call   80104ab0 <myproc>
80105fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105fbc:	85 f6                	test   %esi,%esi
80105fbe:	74 30                	je     80105ff0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105fc0:	83 ec 04             	sub    $0x4,%esp
80105fc3:	6a 14                	push   $0x14
80105fc5:	53                   	push   %ebx
80105fc6:	6a 01                	push   $0x1
80105fc8:	e8 e3 fa ff ff       	call   80105ab0 <argptr>
80105fcd:	83 c4 10             	add    $0x10,%esp
80105fd0:	85 c0                	test   %eax,%eax
80105fd2:	78 1c                	js     80105ff0 <sys_fstat+0x60>
  return filestat(f, st);
80105fd4:	83 ec 08             	sub    $0x8,%esp
80105fd7:	ff 75 f4             	push   -0xc(%ebp)
80105fda:	56                   	push   %esi
80105fdb:	e8 30 c1 ff ff       	call   80102110 <filestat>
80105fe0:	83 c4 10             	add    $0x10,%esp
}
80105fe3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fe6:	5b                   	pop    %ebx
80105fe7:	5e                   	pop    %esi
80105fe8:	5d                   	pop    %ebp
80105fe9:	c3                   	ret    
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff5:	eb ec                	jmp    80105fe3 <sys_fstat+0x53>
80105ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <sys_link>:
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	57                   	push   %edi
80106004:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106005:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106008:	53                   	push   %ebx
80106009:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010600c:	50                   	push   %eax
8010600d:	6a 00                	push   $0x0
8010600f:	e8 0c fb ff ff       	call   80105b20 <argstr>
80106014:	83 c4 10             	add    $0x10,%esp
80106017:	85 c0                	test   %eax,%eax
80106019:	0f 88 fb 00 00 00    	js     8010611a <sys_link+0x11a>
8010601f:	83 ec 08             	sub    $0x8,%esp
80106022:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106025:	50                   	push   %eax
80106026:	6a 01                	push   $0x1
80106028:	e8 f3 fa ff ff       	call   80105b20 <argstr>
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	85 c0                	test   %eax,%eax
80106032:	0f 88 e2 00 00 00    	js     8010611a <sys_link+0x11a>
  begin_op();
80106038:	e8 63 de ff ff       	call   80103ea0 <begin_op>
  if((ip = namei(old)) == 0){
8010603d:	83 ec 0c             	sub    $0xc,%esp
80106040:	ff 75 d4             	push   -0x2c(%ebp)
80106043:	e8 98 d1 ff ff       	call   801031e0 <namei>
80106048:	83 c4 10             	add    $0x10,%esp
8010604b:	89 c3                	mov    %eax,%ebx
8010604d:	85 c0                	test   %eax,%eax
8010604f:	0f 84 e4 00 00 00    	je     80106139 <sys_link+0x139>
  ilock(ip);
80106055:	83 ec 0c             	sub    $0xc,%esp
80106058:	50                   	push   %eax
80106059:	e8 62 c8 ff ff       	call   801028c0 <ilock>
  if(ip->type == T_DIR){
8010605e:	83 c4 10             	add    $0x10,%esp
80106061:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106066:	0f 84 b5 00 00 00    	je     80106121 <sys_link+0x121>
  iupdate(ip);
8010606c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010606f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106074:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106077:	53                   	push   %ebx
80106078:	e8 93 c7 ff ff       	call   80102810 <iupdate>
  iunlock(ip);
8010607d:	89 1c 24             	mov    %ebx,(%esp)
80106080:	e8 1b c9 ff ff       	call   801029a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106085:	58                   	pop    %eax
80106086:	5a                   	pop    %edx
80106087:	57                   	push   %edi
80106088:	ff 75 d0             	push   -0x30(%ebp)
8010608b:	e8 70 d1 ff ff       	call   80103200 <nameiparent>
80106090:	83 c4 10             	add    $0x10,%esp
80106093:	89 c6                	mov    %eax,%esi
80106095:	85 c0                	test   %eax,%eax
80106097:	74 5b                	je     801060f4 <sys_link+0xf4>
  ilock(dp);
80106099:	83 ec 0c             	sub    $0xc,%esp
8010609c:	50                   	push   %eax
8010609d:	e8 1e c8 ff ff       	call   801028c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801060a2:	8b 03                	mov    (%ebx),%eax
801060a4:	83 c4 10             	add    $0x10,%esp
801060a7:	39 06                	cmp    %eax,(%esi)
801060a9:	75 3d                	jne    801060e8 <sys_link+0xe8>
801060ab:	83 ec 04             	sub    $0x4,%esp
801060ae:	ff 73 04             	push   0x4(%ebx)
801060b1:	57                   	push   %edi
801060b2:	56                   	push   %esi
801060b3:	e8 68 d0 ff ff       	call   80103120 <dirlink>
801060b8:	83 c4 10             	add    $0x10,%esp
801060bb:	85 c0                	test   %eax,%eax
801060bd:	78 29                	js     801060e8 <sys_link+0xe8>
  iunlockput(dp);
801060bf:	83 ec 0c             	sub    $0xc,%esp
801060c2:	56                   	push   %esi
801060c3:	e8 88 ca ff ff       	call   80102b50 <iunlockput>
  iput(ip);
801060c8:	89 1c 24             	mov    %ebx,(%esp)
801060cb:	e8 20 c9 ff ff       	call   801029f0 <iput>
  end_op();
801060d0:	e8 3b de ff ff       	call   80103f10 <end_op>
  return 0;
801060d5:	83 c4 10             	add    $0x10,%esp
801060d8:	31 c0                	xor    %eax,%eax
}
801060da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060dd:	5b                   	pop    %ebx
801060de:	5e                   	pop    %esi
801060df:	5f                   	pop    %edi
801060e0:	5d                   	pop    %ebp
801060e1:	c3                   	ret    
801060e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801060e8:	83 ec 0c             	sub    $0xc,%esp
801060eb:	56                   	push   %esi
801060ec:	e8 5f ca ff ff       	call   80102b50 <iunlockput>
    goto bad;
801060f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801060f4:	83 ec 0c             	sub    $0xc,%esp
801060f7:	53                   	push   %ebx
801060f8:	e8 c3 c7 ff ff       	call   801028c0 <ilock>
  ip->nlink--;
801060fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106102:	89 1c 24             	mov    %ebx,(%esp)
80106105:	e8 06 c7 ff ff       	call   80102810 <iupdate>
  iunlockput(ip);
8010610a:	89 1c 24             	mov    %ebx,(%esp)
8010610d:	e8 3e ca ff ff       	call   80102b50 <iunlockput>
  end_op();
80106112:	e8 f9 dd ff ff       	call   80103f10 <end_op>
  return -1;
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611f:	eb b9                	jmp    801060da <sys_link+0xda>
    iunlockput(ip);
80106121:	83 ec 0c             	sub    $0xc,%esp
80106124:	53                   	push   %ebx
80106125:	e8 26 ca ff ff       	call   80102b50 <iunlockput>
    end_op();
8010612a:	e8 e1 dd ff ff       	call   80103f10 <end_op>
    return -1;
8010612f:	83 c4 10             	add    $0x10,%esp
80106132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106137:	eb a1                	jmp    801060da <sys_link+0xda>
    end_op();
80106139:	e8 d2 dd ff ff       	call   80103f10 <end_op>
    return -1;
8010613e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106143:	eb 95                	jmp    801060da <sys_link+0xda>
80106145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_unlink>:
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	57                   	push   %edi
80106154:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106155:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106158:	53                   	push   %ebx
80106159:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010615c:	50                   	push   %eax
8010615d:	6a 00                	push   $0x0
8010615f:	e8 bc f9 ff ff       	call   80105b20 <argstr>
80106164:	83 c4 10             	add    $0x10,%esp
80106167:	85 c0                	test   %eax,%eax
80106169:	0f 88 7a 01 00 00    	js     801062e9 <sys_unlink+0x199>
  begin_op();
8010616f:	e8 2c dd ff ff       	call   80103ea0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106174:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106177:	83 ec 08             	sub    $0x8,%esp
8010617a:	53                   	push   %ebx
8010617b:	ff 75 c0             	push   -0x40(%ebp)
8010617e:	e8 7d d0 ff ff       	call   80103200 <nameiparent>
80106183:	83 c4 10             	add    $0x10,%esp
80106186:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106189:	85 c0                	test   %eax,%eax
8010618b:	0f 84 62 01 00 00    	je     801062f3 <sys_unlink+0x1a3>
  ilock(dp);
80106191:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106194:	83 ec 0c             	sub    $0xc,%esp
80106197:	57                   	push   %edi
80106198:	e8 23 c7 ff ff       	call   801028c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010619d:	58                   	pop    %eax
8010619e:	5a                   	pop    %edx
8010619f:	68 54 8a 10 80       	push   $0x80108a54
801061a4:	53                   	push   %ebx
801061a5:	e8 56 cc ff ff       	call   80102e00 <namecmp>
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	85 c0                	test   %eax,%eax
801061af:	0f 84 fb 00 00 00    	je     801062b0 <sys_unlink+0x160>
801061b5:	83 ec 08             	sub    $0x8,%esp
801061b8:	68 53 8a 10 80       	push   $0x80108a53
801061bd:	53                   	push   %ebx
801061be:	e8 3d cc ff ff       	call   80102e00 <namecmp>
801061c3:	83 c4 10             	add    $0x10,%esp
801061c6:	85 c0                	test   %eax,%eax
801061c8:	0f 84 e2 00 00 00    	je     801062b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801061ce:	83 ec 04             	sub    $0x4,%esp
801061d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801061d4:	50                   	push   %eax
801061d5:	53                   	push   %ebx
801061d6:	57                   	push   %edi
801061d7:	e8 44 cc ff ff       	call   80102e20 <dirlookup>
801061dc:	83 c4 10             	add    $0x10,%esp
801061df:	89 c3                	mov    %eax,%ebx
801061e1:	85 c0                	test   %eax,%eax
801061e3:	0f 84 c7 00 00 00    	je     801062b0 <sys_unlink+0x160>
  ilock(ip);
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	50                   	push   %eax
801061ed:	e8 ce c6 ff ff       	call   801028c0 <ilock>
  if(ip->nlink < 1)
801061f2:	83 c4 10             	add    $0x10,%esp
801061f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801061fa:	0f 8e 1c 01 00 00    	jle    8010631c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106200:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106205:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106208:	74 66                	je     80106270 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010620a:	83 ec 04             	sub    $0x4,%esp
8010620d:	6a 10                	push   $0x10
8010620f:	6a 00                	push   $0x0
80106211:	57                   	push   %edi
80106212:	e8 89 f5 ff ff       	call   801057a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106217:	6a 10                	push   $0x10
80106219:	ff 75 c4             	push   -0x3c(%ebp)
8010621c:	57                   	push   %edi
8010621d:	ff 75 b4             	push   -0x4c(%ebp)
80106220:	e8 ab ca ff ff       	call   80102cd0 <writei>
80106225:	83 c4 20             	add    $0x20,%esp
80106228:	83 f8 10             	cmp    $0x10,%eax
8010622b:	0f 85 de 00 00 00    	jne    8010630f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106231:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106236:	0f 84 94 00 00 00    	je     801062d0 <sys_unlink+0x180>
  iunlockput(dp);
8010623c:	83 ec 0c             	sub    $0xc,%esp
8010623f:	ff 75 b4             	push   -0x4c(%ebp)
80106242:	e8 09 c9 ff ff       	call   80102b50 <iunlockput>
  ip->nlink--;
80106247:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010624c:	89 1c 24             	mov    %ebx,(%esp)
8010624f:	e8 bc c5 ff ff       	call   80102810 <iupdate>
  iunlockput(ip);
80106254:	89 1c 24             	mov    %ebx,(%esp)
80106257:	e8 f4 c8 ff ff       	call   80102b50 <iunlockput>
  end_op();
8010625c:	e8 af dc ff ff       	call   80103f10 <end_op>
  return 0;
80106261:	83 c4 10             	add    $0x10,%esp
80106264:	31 c0                	xor    %eax,%eax
}
80106266:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106269:	5b                   	pop    %ebx
8010626a:	5e                   	pop    %esi
8010626b:	5f                   	pop    %edi
8010626c:	5d                   	pop    %ebp
8010626d:	c3                   	ret    
8010626e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106270:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106274:	76 94                	jbe    8010620a <sys_unlink+0xba>
80106276:	be 20 00 00 00       	mov    $0x20,%esi
8010627b:	eb 0b                	jmp    80106288 <sys_unlink+0x138>
8010627d:	8d 76 00             	lea    0x0(%esi),%esi
80106280:	83 c6 10             	add    $0x10,%esi
80106283:	3b 73 58             	cmp    0x58(%ebx),%esi
80106286:	73 82                	jae    8010620a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106288:	6a 10                	push   $0x10
8010628a:	56                   	push   %esi
8010628b:	57                   	push   %edi
8010628c:	53                   	push   %ebx
8010628d:	e8 3e c9 ff ff       	call   80102bd0 <readi>
80106292:	83 c4 10             	add    $0x10,%esp
80106295:	83 f8 10             	cmp    $0x10,%eax
80106298:	75 68                	jne    80106302 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010629a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010629f:	74 df                	je     80106280 <sys_unlink+0x130>
    iunlockput(ip);
801062a1:	83 ec 0c             	sub    $0xc,%esp
801062a4:	53                   	push   %ebx
801062a5:	e8 a6 c8 ff ff       	call   80102b50 <iunlockput>
    goto bad;
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	ff 75 b4             	push   -0x4c(%ebp)
801062b6:	e8 95 c8 ff ff       	call   80102b50 <iunlockput>
  end_op();
801062bb:	e8 50 dc ff ff       	call   80103f10 <end_op>
  return -1;
801062c0:	83 c4 10             	add    $0x10,%esp
801062c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c8:	eb 9c                	jmp    80106266 <sys_unlink+0x116>
801062ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801062d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801062d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801062d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801062db:	50                   	push   %eax
801062dc:	e8 2f c5 ff ff       	call   80102810 <iupdate>
801062e1:	83 c4 10             	add    $0x10,%esp
801062e4:	e9 53 ff ff ff       	jmp    8010623c <sys_unlink+0xec>
    return -1;
801062e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ee:	e9 73 ff ff ff       	jmp    80106266 <sys_unlink+0x116>
    end_op();
801062f3:	e8 18 dc ff ff       	call   80103f10 <end_op>
    return -1;
801062f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fd:	e9 64 ff ff ff       	jmp    80106266 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106302:	83 ec 0c             	sub    $0xc,%esp
80106305:	68 78 8a 10 80       	push   $0x80108a78
8010630a:	e8 51 a1 ff ff       	call   80100460 <panic>
    panic("unlink: writei");
8010630f:	83 ec 0c             	sub    $0xc,%esp
80106312:	68 8a 8a 10 80       	push   $0x80108a8a
80106317:	e8 44 a1 ff ff       	call   80100460 <panic>
    panic("unlink: nlink < 1");
8010631c:	83 ec 0c             	sub    $0xc,%esp
8010631f:	68 66 8a 10 80       	push   $0x80108a66
80106324:	e8 37 a1 ff ff       	call   80100460 <panic>
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106330 <sys_open>:

int
sys_open(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	57                   	push   %edi
80106334:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106335:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106338:	53                   	push   %ebx
80106339:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010633c:	50                   	push   %eax
8010633d:	6a 00                	push   $0x0
8010633f:	e8 dc f7 ff ff       	call   80105b20 <argstr>
80106344:	83 c4 10             	add    $0x10,%esp
80106347:	85 c0                	test   %eax,%eax
80106349:	0f 88 8e 00 00 00    	js     801063dd <sys_open+0xad>
8010634f:	83 ec 08             	sub    $0x8,%esp
80106352:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106355:	50                   	push   %eax
80106356:	6a 01                	push   $0x1
80106358:	e8 03 f7 ff ff       	call   80105a60 <argint>
8010635d:	83 c4 10             	add    $0x10,%esp
80106360:	85 c0                	test   %eax,%eax
80106362:	78 79                	js     801063dd <sys_open+0xad>
    return -1;

  begin_op();
80106364:	e8 37 db ff ff       	call   80103ea0 <begin_op>

  if(omode & O_CREATE){
80106369:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010636d:	75 79                	jne    801063e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010636f:	83 ec 0c             	sub    $0xc,%esp
80106372:	ff 75 e0             	push   -0x20(%ebp)
80106375:	e8 66 ce ff ff       	call   801031e0 <namei>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	89 c6                	mov    %eax,%esi
8010637f:	85 c0                	test   %eax,%eax
80106381:	0f 84 7e 00 00 00    	je     80106405 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106387:	83 ec 0c             	sub    $0xc,%esp
8010638a:	50                   	push   %eax
8010638b:	e8 30 c5 ff ff       	call   801028c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106398:	0f 84 c2 00 00 00    	je     80106460 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010639e:	e8 cd bb ff ff       	call   80101f70 <filealloc>
801063a3:	89 c7                	mov    %eax,%edi
801063a5:	85 c0                	test   %eax,%eax
801063a7:	74 23                	je     801063cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801063a9:	e8 02 e7 ff ff       	call   80104ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801063ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801063b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801063b4:	85 d2                	test   %edx,%edx
801063b6:	74 60                	je     80106418 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801063b8:	83 c3 01             	add    $0x1,%ebx
801063bb:	83 fb 10             	cmp    $0x10,%ebx
801063be:	75 f0                	jne    801063b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	57                   	push   %edi
801063c4:	e8 67 bc ff ff       	call   80102030 <fileclose>
801063c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801063cc:	83 ec 0c             	sub    $0xc,%esp
801063cf:	56                   	push   %esi
801063d0:	e8 7b c7 ff ff       	call   80102b50 <iunlockput>
    end_op();
801063d5:	e8 36 db ff ff       	call   80103f10 <end_op>
    return -1;
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063e2:	eb 6d                	jmp    80106451 <sys_open+0x121>
801063e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801063e8:	83 ec 0c             	sub    $0xc,%esp
801063eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801063ee:	31 c9                	xor    %ecx,%ecx
801063f0:	ba 02 00 00 00       	mov    $0x2,%edx
801063f5:	6a 00                	push   $0x0
801063f7:	e8 14 f8 ff ff       	call   80105c10 <create>
    if(ip == 0){
801063fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801063ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106401:	85 c0                	test   %eax,%eax
80106403:	75 99                	jne    8010639e <sys_open+0x6e>
      end_op();
80106405:	e8 06 db ff ff       	call   80103f10 <end_op>
      return -1;
8010640a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010640f:	eb 40                	jmp    80106451 <sys_open+0x121>
80106411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106418:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010641b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010641f:	56                   	push   %esi
80106420:	e8 7b c5 ff ff       	call   801029a0 <iunlock>
  end_op();
80106425:	e8 e6 da ff ff       	call   80103f10 <end_op>

  f->type = FD_INODE;
8010642a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106430:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106433:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106436:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106439:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010643b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106442:	f7 d0                	not    %eax
80106444:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106447:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010644a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010644d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106454:	89 d8                	mov    %ebx,%eax
80106456:	5b                   	pop    %ebx
80106457:	5e                   	pop    %esi
80106458:	5f                   	pop    %edi
80106459:	5d                   	pop    %ebp
8010645a:	c3                   	ret    
8010645b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010645f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106460:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106463:	85 c9                	test   %ecx,%ecx
80106465:	0f 84 33 ff ff ff    	je     8010639e <sys_open+0x6e>
8010646b:	e9 5c ff ff ff       	jmp    801063cc <sys_open+0x9c>

80106470 <sys_mkdir>:

int
sys_mkdir(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106476:	e8 25 da ff ff       	call   80103ea0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010647b:	83 ec 08             	sub    $0x8,%esp
8010647e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106481:	50                   	push   %eax
80106482:	6a 00                	push   $0x0
80106484:	e8 97 f6 ff ff       	call   80105b20 <argstr>
80106489:	83 c4 10             	add    $0x10,%esp
8010648c:	85 c0                	test   %eax,%eax
8010648e:	78 30                	js     801064c0 <sys_mkdir+0x50>
80106490:	83 ec 0c             	sub    $0xc,%esp
80106493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106496:	31 c9                	xor    %ecx,%ecx
80106498:	ba 01 00 00 00       	mov    $0x1,%edx
8010649d:	6a 00                	push   $0x0
8010649f:	e8 6c f7 ff ff       	call   80105c10 <create>
801064a4:	83 c4 10             	add    $0x10,%esp
801064a7:	85 c0                	test   %eax,%eax
801064a9:	74 15                	je     801064c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801064ab:	83 ec 0c             	sub    $0xc,%esp
801064ae:	50                   	push   %eax
801064af:	e8 9c c6 ff ff       	call   80102b50 <iunlockput>
  end_op();
801064b4:	e8 57 da ff ff       	call   80103f10 <end_op>
  return 0;
801064b9:	83 c4 10             	add    $0x10,%esp
801064bc:	31 c0                	xor    %eax,%eax
}
801064be:	c9                   	leave  
801064bf:	c3                   	ret    
    end_op();
801064c0:	e8 4b da ff ff       	call   80103f10 <end_op>
    return -1;
801064c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ca:	c9                   	leave  
801064cb:	c3                   	ret    
801064cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064d0 <sys_mknod>:

int
sys_mknod(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801064d6:	e8 c5 d9 ff ff       	call   80103ea0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801064db:	83 ec 08             	sub    $0x8,%esp
801064de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064e1:	50                   	push   %eax
801064e2:	6a 00                	push   $0x0
801064e4:	e8 37 f6 ff ff       	call   80105b20 <argstr>
801064e9:	83 c4 10             	add    $0x10,%esp
801064ec:	85 c0                	test   %eax,%eax
801064ee:	78 60                	js     80106550 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801064f0:	83 ec 08             	sub    $0x8,%esp
801064f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064f6:	50                   	push   %eax
801064f7:	6a 01                	push   $0x1
801064f9:	e8 62 f5 ff ff       	call   80105a60 <argint>
  if((argstr(0, &path)) < 0 ||
801064fe:	83 c4 10             	add    $0x10,%esp
80106501:	85 c0                	test   %eax,%eax
80106503:	78 4b                	js     80106550 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106505:	83 ec 08             	sub    $0x8,%esp
80106508:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010650b:	50                   	push   %eax
8010650c:	6a 02                	push   $0x2
8010650e:	e8 4d f5 ff ff       	call   80105a60 <argint>
     argint(1, &major) < 0 ||
80106513:	83 c4 10             	add    $0x10,%esp
80106516:	85 c0                	test   %eax,%eax
80106518:	78 36                	js     80106550 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010651a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010651e:	83 ec 0c             	sub    $0xc,%esp
80106521:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106525:	ba 03 00 00 00       	mov    $0x3,%edx
8010652a:	50                   	push   %eax
8010652b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010652e:	e8 dd f6 ff ff       	call   80105c10 <create>
     argint(2, &minor) < 0 ||
80106533:	83 c4 10             	add    $0x10,%esp
80106536:	85 c0                	test   %eax,%eax
80106538:	74 16                	je     80106550 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010653a:	83 ec 0c             	sub    $0xc,%esp
8010653d:	50                   	push   %eax
8010653e:	e8 0d c6 ff ff       	call   80102b50 <iunlockput>
  end_op();
80106543:	e8 c8 d9 ff ff       	call   80103f10 <end_op>
  return 0;
80106548:	83 c4 10             	add    $0x10,%esp
8010654b:	31 c0                	xor    %eax,%eax
}
8010654d:	c9                   	leave  
8010654e:	c3                   	ret    
8010654f:	90                   	nop
    end_op();
80106550:	e8 bb d9 ff ff       	call   80103f10 <end_op>
    return -1;
80106555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010655a:	c9                   	leave  
8010655b:	c3                   	ret    
8010655c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106560 <sys_chdir>:

int
sys_chdir(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	56                   	push   %esi
80106564:	53                   	push   %ebx
80106565:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106568:	e8 43 e5 ff ff       	call   80104ab0 <myproc>
8010656d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010656f:	e8 2c d9 ff ff       	call   80103ea0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106574:	83 ec 08             	sub    $0x8,%esp
80106577:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010657a:	50                   	push   %eax
8010657b:	6a 00                	push   $0x0
8010657d:	e8 9e f5 ff ff       	call   80105b20 <argstr>
80106582:	83 c4 10             	add    $0x10,%esp
80106585:	85 c0                	test   %eax,%eax
80106587:	78 77                	js     80106600 <sys_chdir+0xa0>
80106589:	83 ec 0c             	sub    $0xc,%esp
8010658c:	ff 75 f4             	push   -0xc(%ebp)
8010658f:	e8 4c cc ff ff       	call   801031e0 <namei>
80106594:	83 c4 10             	add    $0x10,%esp
80106597:	89 c3                	mov    %eax,%ebx
80106599:	85 c0                	test   %eax,%eax
8010659b:	74 63                	je     80106600 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010659d:	83 ec 0c             	sub    $0xc,%esp
801065a0:	50                   	push   %eax
801065a1:	e8 1a c3 ff ff       	call   801028c0 <ilock>
  if(ip->type != T_DIR){
801065a6:	83 c4 10             	add    $0x10,%esp
801065a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801065ae:	75 30                	jne    801065e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	53                   	push   %ebx
801065b4:	e8 e7 c3 ff ff       	call   801029a0 <iunlock>
  iput(curproc->cwd);
801065b9:	58                   	pop    %eax
801065ba:	ff 76 68             	push   0x68(%esi)
801065bd:	e8 2e c4 ff ff       	call   801029f0 <iput>
  end_op();
801065c2:	e8 49 d9 ff ff       	call   80103f10 <end_op>
  curproc->cwd = ip;
801065c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	31 c0                	xor    %eax,%eax
}
801065cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065d2:	5b                   	pop    %ebx
801065d3:	5e                   	pop    %esi
801065d4:	5d                   	pop    %ebp
801065d5:	c3                   	ret    
801065d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	53                   	push   %ebx
801065e4:	e8 67 c5 ff ff       	call   80102b50 <iunlockput>
    end_op();
801065e9:	e8 22 d9 ff ff       	call   80103f10 <end_op>
    return -1;
801065ee:	83 c4 10             	add    $0x10,%esp
801065f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f6:	eb d7                	jmp    801065cf <sys_chdir+0x6f>
801065f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop
    end_op();
80106600:	e8 0b d9 ff ff       	call   80103f10 <end_op>
    return -1;
80106605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660a:	eb c3                	jmp    801065cf <sys_chdir+0x6f>
8010660c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106610 <sys_exec>:

int
sys_exec(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	57                   	push   %edi
80106614:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106615:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010661b:	53                   	push   %ebx
8010661c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106622:	50                   	push   %eax
80106623:	6a 00                	push   $0x0
80106625:	e8 f6 f4 ff ff       	call   80105b20 <argstr>
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	85 c0                	test   %eax,%eax
8010662f:	0f 88 87 00 00 00    	js     801066bc <sys_exec+0xac>
80106635:	83 ec 08             	sub    $0x8,%esp
80106638:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010663e:	50                   	push   %eax
8010663f:	6a 01                	push   $0x1
80106641:	e8 1a f4 ff ff       	call   80105a60 <argint>
80106646:	83 c4 10             	add    $0x10,%esp
80106649:	85 c0                	test   %eax,%eax
8010664b:	78 6f                	js     801066bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010664d:	83 ec 04             	sub    $0x4,%esp
80106650:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106656:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106658:	68 80 00 00 00       	push   $0x80
8010665d:	6a 00                	push   $0x0
8010665f:	56                   	push   %esi
80106660:	e8 3b f1 ff ff       	call   801057a0 <memset>
80106665:	83 c4 10             	add    $0x10,%esp
80106668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106670:	83 ec 08             	sub    $0x8,%esp
80106673:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106679:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106680:	50                   	push   %eax
80106681:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106687:	01 f8                	add    %edi,%eax
80106689:	50                   	push   %eax
8010668a:	e8 41 f3 ff ff       	call   801059d0 <fetchint>
8010668f:	83 c4 10             	add    $0x10,%esp
80106692:	85 c0                	test   %eax,%eax
80106694:	78 26                	js     801066bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106696:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010669c:	85 c0                	test   %eax,%eax
8010669e:	74 30                	je     801066d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801066a0:	83 ec 08             	sub    $0x8,%esp
801066a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801066a6:	52                   	push   %edx
801066a7:	50                   	push   %eax
801066a8:	e8 63 f3 ff ff       	call   80105a10 <fetchstr>
801066ad:	83 c4 10             	add    $0x10,%esp
801066b0:	85 c0                	test   %eax,%eax
801066b2:	78 08                	js     801066bc <sys_exec+0xac>
  for(i=0;; i++){
801066b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801066b7:	83 fb 20             	cmp    $0x20,%ebx
801066ba:	75 b4                	jne    80106670 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801066bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801066bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066c4:	5b                   	pop    %ebx
801066c5:	5e                   	pop    %esi
801066c6:	5f                   	pop    %edi
801066c7:	5d                   	pop    %ebp
801066c8:	c3                   	ret    
801066c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801066d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801066d7:	00 00 00 00 
  return exec(path, argv);
801066db:	83 ec 08             	sub    $0x8,%esp
801066de:	56                   	push   %esi
801066df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801066e5:	e8 06 b5 ff ff       	call   80101bf0 <exec>
801066ea:	83 c4 10             	add    $0x10,%esp
}
801066ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f0:	5b                   	pop    %ebx
801066f1:	5e                   	pop    %esi
801066f2:	5f                   	pop    %edi
801066f3:	5d                   	pop    %ebp
801066f4:	c3                   	ret    
801066f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106700 <sys_pipe>:

int
sys_pipe(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106705:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106708:	53                   	push   %ebx
80106709:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010670c:	6a 08                	push   $0x8
8010670e:	50                   	push   %eax
8010670f:	6a 00                	push   $0x0
80106711:	e8 9a f3 ff ff       	call   80105ab0 <argptr>
80106716:	83 c4 10             	add    $0x10,%esp
80106719:	85 c0                	test   %eax,%eax
8010671b:	78 4a                	js     80106767 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010671d:	83 ec 08             	sub    $0x8,%esp
80106720:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106723:	50                   	push   %eax
80106724:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106727:	50                   	push   %eax
80106728:	e8 43 de ff ff       	call   80104570 <pipealloc>
8010672d:	83 c4 10             	add    $0x10,%esp
80106730:	85 c0                	test   %eax,%eax
80106732:	78 33                	js     80106767 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106734:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106737:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106739:	e8 72 e3 ff ff       	call   80104ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010673e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106740:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106744:	85 f6                	test   %esi,%esi
80106746:	74 28                	je     80106770 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106748:	83 c3 01             	add    $0x1,%ebx
8010674b:	83 fb 10             	cmp    $0x10,%ebx
8010674e:	75 f0                	jne    80106740 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106750:	83 ec 0c             	sub    $0xc,%esp
80106753:	ff 75 e0             	push   -0x20(%ebp)
80106756:	e8 d5 b8 ff ff       	call   80102030 <fileclose>
    fileclose(wf);
8010675b:	58                   	pop    %eax
8010675c:	ff 75 e4             	push   -0x1c(%ebp)
8010675f:	e8 cc b8 ff ff       	call   80102030 <fileclose>
    return -1;
80106764:	83 c4 10             	add    $0x10,%esp
80106767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676c:	eb 53                	jmp    801067c1 <sys_pipe+0xc1>
8010676e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106770:	8d 73 08             	lea    0x8(%ebx),%esi
80106773:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106777:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010677a:	e8 31 e3 ff ff       	call   80104ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010677f:	31 d2                	xor    %edx,%edx
80106781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106788:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010678c:	85 c9                	test   %ecx,%ecx
8010678e:	74 20                	je     801067b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106790:	83 c2 01             	add    $0x1,%edx
80106793:	83 fa 10             	cmp    $0x10,%edx
80106796:	75 f0                	jne    80106788 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106798:	e8 13 e3 ff ff       	call   80104ab0 <myproc>
8010679d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801067a4:	00 
801067a5:	eb a9                	jmp    80106750 <sys_pipe+0x50>
801067a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801067b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801067b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801067b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801067b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801067bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801067bf:	31 c0                	xor    %eax,%eax
}
801067c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067c4:	5b                   	pop    %ebx
801067c5:	5e                   	pop    %esi
801067c6:	5f                   	pop    %edi
801067c7:	5d                   	pop    %ebp
801067c8:	c3                   	ret    
801067c9:	66 90                	xchg   %ax,%ax
801067cb:	66 90                	xchg   %ax,%ax
801067cd:	66 90                	xchg   %ax,%ax
801067cf:	90                   	nop

801067d0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801067d0:	e9 7b e4 ff ff       	jmp    80104c50 <fork>
801067d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067e0 <sys_exit>:
}

int
sys_exit(void)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801067e6:	e8 e5 e6 ff ff       	call   80104ed0 <exit>
  return 0;  // not reached
}
801067eb:	31 c0                	xor    %eax,%eax
801067ed:	c9                   	leave  
801067ee:	c3                   	ret    
801067ef:	90                   	nop

801067f0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801067f0:	e9 0b e8 ff ff       	jmp    80105000 <wait>
801067f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106800 <sys_kill>:
}

int
sys_kill(void)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106806:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106809:	50                   	push   %eax
8010680a:	6a 00                	push   $0x0
8010680c:	e8 4f f2 ff ff       	call   80105a60 <argint>
80106811:	83 c4 10             	add    $0x10,%esp
80106814:	85 c0                	test   %eax,%eax
80106816:	78 18                	js     80106830 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106818:	83 ec 0c             	sub    $0xc,%esp
8010681b:	ff 75 f4             	push   -0xc(%ebp)
8010681e:	e8 7d ea ff ff       	call   801052a0 <kill>
80106823:	83 c4 10             	add    $0x10,%esp
}
80106826:	c9                   	leave  
80106827:	c3                   	ret    
80106828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682f:	90                   	nop
80106830:	c9                   	leave  
    return -1;
80106831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106836:	c3                   	ret    
80106837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010683e:	66 90                	xchg   %ax,%ax

80106840 <sys_getpid>:

int
sys_getpid(void)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106846:	e8 65 e2 ff ff       	call   80104ab0 <myproc>
8010684b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010684e:	c9                   	leave  
8010684f:	c3                   	ret    

80106850 <sys_sbrk>:

int
sys_sbrk(void)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106854:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106857:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010685a:	50                   	push   %eax
8010685b:	6a 00                	push   $0x0
8010685d:	e8 fe f1 ff ff       	call   80105a60 <argint>
80106862:	83 c4 10             	add    $0x10,%esp
80106865:	85 c0                	test   %eax,%eax
80106867:	78 27                	js     80106890 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106869:	e8 42 e2 ff ff       	call   80104ab0 <myproc>
  if(growproc(n) < 0)
8010686e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106871:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106873:	ff 75 f4             	push   -0xc(%ebp)
80106876:	e8 55 e3 ff ff       	call   80104bd0 <growproc>
8010687b:	83 c4 10             	add    $0x10,%esp
8010687e:	85 c0                	test   %eax,%eax
80106880:	78 0e                	js     80106890 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106882:	89 d8                	mov    %ebx,%eax
80106884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106887:	c9                   	leave  
80106888:	c3                   	ret    
80106889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106890:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106895:	eb eb                	jmp    80106882 <sys_sbrk+0x32>
80106897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689e:	66 90                	xchg   %ax,%ax

801068a0 <sys_sleep>:

int
sys_sleep(void)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801068a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801068a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801068aa:	50                   	push   %eax
801068ab:	6a 00                	push   $0x0
801068ad:	e8 ae f1 ff ff       	call   80105a60 <argint>
801068b2:	83 c4 10             	add    $0x10,%esp
801068b5:	85 c0                	test   %eax,%eax
801068b7:	0f 88 8a 00 00 00    	js     80106947 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801068bd:	83 ec 0c             	sub    $0xc,%esp
801068c0:	68 20 58 11 80       	push   $0x80115820
801068c5:	e8 16 ee ff ff       	call   801056e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801068ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801068cd:	8b 1d 00 58 11 80    	mov    0x80115800,%ebx
  while(ticks - ticks0 < n){
801068d3:	83 c4 10             	add    $0x10,%esp
801068d6:	85 d2                	test   %edx,%edx
801068d8:	75 27                	jne    80106901 <sys_sleep+0x61>
801068da:	eb 54                	jmp    80106930 <sys_sleep+0x90>
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801068e0:	83 ec 08             	sub    $0x8,%esp
801068e3:	68 20 58 11 80       	push   $0x80115820
801068e8:	68 00 58 11 80       	push   $0x80115800
801068ed:	e8 8e e8 ff ff       	call   80105180 <sleep>
  while(ticks - ticks0 < n){
801068f2:	a1 00 58 11 80       	mov    0x80115800,%eax
801068f7:	83 c4 10             	add    $0x10,%esp
801068fa:	29 d8                	sub    %ebx,%eax
801068fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801068ff:	73 2f                	jae    80106930 <sys_sleep+0x90>
    if(myproc()->killed){
80106901:	e8 aa e1 ff ff       	call   80104ab0 <myproc>
80106906:	8b 40 24             	mov    0x24(%eax),%eax
80106909:	85 c0                	test   %eax,%eax
8010690b:	74 d3                	je     801068e0 <sys_sleep+0x40>
      release(&tickslock);
8010690d:	83 ec 0c             	sub    $0xc,%esp
80106910:	68 20 58 11 80       	push   $0x80115820
80106915:	e8 66 ed ff ff       	call   80105680 <release>
  }
  release(&tickslock);
  return 0;
}
8010691a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010691d:	83 c4 10             	add    $0x10,%esp
80106920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106925:	c9                   	leave  
80106926:	c3                   	ret    
80106927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106930:	83 ec 0c             	sub    $0xc,%esp
80106933:	68 20 58 11 80       	push   $0x80115820
80106938:	e8 43 ed ff ff       	call   80105680 <release>
  return 0;
8010693d:	83 c4 10             	add    $0x10,%esp
80106940:	31 c0                	xor    %eax,%eax
}
80106942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106945:	c9                   	leave  
80106946:	c3                   	ret    
    return -1;
80106947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694c:	eb f4                	jmp    80106942 <sys_sleep+0xa2>
8010694e:	66 90                	xchg   %ax,%ax

80106950 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	53                   	push   %ebx
80106954:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106957:	68 20 58 11 80       	push   $0x80115820
8010695c:	e8 7f ed ff ff       	call   801056e0 <acquire>
  xticks = ticks;
80106961:	8b 1d 00 58 11 80    	mov    0x80115800,%ebx
  release(&tickslock);
80106967:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
8010696e:	e8 0d ed ff ff       	call   80105680 <release>
  return xticks;
}
80106973:	89 d8                	mov    %ebx,%eax
80106975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106978:	c9                   	leave  
80106979:	c3                   	ret    

8010697a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010697a:	1e                   	push   %ds
  pushl %es
8010697b:	06                   	push   %es
  pushl %fs
8010697c:	0f a0                	push   %fs
  pushl %gs
8010697e:	0f a8                	push   %gs
  pushal
80106980:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106981:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106985:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106987:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106989:	54                   	push   %esp
  call trap
8010698a:	e8 c1 00 00 00       	call   80106a50 <trap>
  addl $4, %esp
8010698f:	83 c4 04             	add    $0x4,%esp

80106992 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106992:	61                   	popa   
  popl %gs
80106993:	0f a9                	pop    %gs
  popl %fs
80106995:	0f a1                	pop    %fs
  popl %es
80106997:	07                   	pop    %es
  popl %ds
80106998:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106999:	83 c4 08             	add    $0x8,%esp
  iret
8010699c:	cf                   	iret   
8010699d:	66 90                	xchg   %ax,%ax
8010699f:	90                   	nop

801069a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801069a0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801069a1:	31 c0                	xor    %eax,%eax
{
801069a3:	89 e5                	mov    %esp,%ebp
801069a5:	83 ec 08             	sub    $0x8,%esp
801069a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069af:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801069b0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801069b7:	c7 04 c5 62 58 11 80 	movl   $0x8e000008,-0x7feea79e(,%eax,8)
801069be:	08 00 00 8e 
801069c2:	66 89 14 c5 60 58 11 	mov    %dx,-0x7feea7a0(,%eax,8)
801069c9:	80 
801069ca:	c1 ea 10             	shr    $0x10,%edx
801069cd:	66 89 14 c5 66 58 11 	mov    %dx,-0x7feea79a(,%eax,8)
801069d4:	80 
  for(i = 0; i < 256; i++)
801069d5:	83 c0 01             	add    $0x1,%eax
801069d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801069dd:	75 d1                	jne    801069b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801069df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069e2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801069e7:	c7 05 62 5a 11 80 08 	movl   $0xef000008,0x80115a62
801069ee:	00 00 ef 
  initlock(&tickslock, "time");
801069f1:	68 99 8a 10 80       	push   $0x80108a99
801069f6:	68 20 58 11 80       	push   $0x80115820
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069fb:	66 a3 60 5a 11 80    	mov    %ax,0x80115a60
80106a01:	c1 e8 10             	shr    $0x10,%eax
80106a04:	66 a3 66 5a 11 80    	mov    %ax,0x80115a66
  initlock(&tickslock, "time");
80106a0a:	e8 01 eb ff ff       	call   80105510 <initlock>
}
80106a0f:	83 c4 10             	add    $0x10,%esp
80106a12:	c9                   	leave  
80106a13:	c3                   	ret    
80106a14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a1f:	90                   	nop

80106a20 <idtinit>:

void
idtinit(void)
{
80106a20:	55                   	push   %ebp
  pd[0] = size-1;
80106a21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a26:	89 e5                	mov    %esp,%ebp
80106a28:	83 ec 10             	sub    $0x10,%esp
80106a2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a2f:	b8 60 58 11 80       	mov    $0x80115860,%eax
80106a34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a38:	c1 e8 10             	shr    $0x10,%eax
80106a3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106a45:	c9                   	leave  
80106a46:	c3                   	ret    
80106a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4e:	66 90                	xchg   %ax,%ax

80106a50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 1c             	sub    $0x1c,%esp
80106a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106a5c:	8b 43 30             	mov    0x30(%ebx),%eax
80106a5f:	83 f8 40             	cmp    $0x40,%eax
80106a62:	0f 84 68 01 00 00    	je     80106bd0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106a68:	83 e8 20             	sub    $0x20,%eax
80106a6b:	83 f8 1f             	cmp    $0x1f,%eax
80106a6e:	0f 87 8c 00 00 00    	ja     80106b00 <trap+0xb0>
80106a74:	ff 24 85 40 8b 10 80 	jmp    *-0x7fef74c0(,%eax,4)
80106a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a7f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a80:	e8 fb c8 ff ff       	call   80103380 <ideintr>
    lapiceoi();
80106a85:	e8 c6 cf ff ff       	call   80103a50 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a8a:	e8 21 e0 ff ff       	call   80104ab0 <myproc>
80106a8f:	85 c0                	test   %eax,%eax
80106a91:	74 1d                	je     80106ab0 <trap+0x60>
80106a93:	e8 18 e0 ff ff       	call   80104ab0 <myproc>
80106a98:	8b 50 24             	mov    0x24(%eax),%edx
80106a9b:	85 d2                	test   %edx,%edx
80106a9d:	74 11                	je     80106ab0 <trap+0x60>
80106a9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106aa3:	83 e0 03             	and    $0x3,%eax
80106aa6:	66 83 f8 03          	cmp    $0x3,%ax
80106aaa:	0f 84 e8 01 00 00    	je     80106c98 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106ab0:	e8 fb df ff ff       	call   80104ab0 <myproc>
80106ab5:	85 c0                	test   %eax,%eax
80106ab7:	74 0f                	je     80106ac8 <trap+0x78>
80106ab9:	e8 f2 df ff ff       	call   80104ab0 <myproc>
80106abe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106ac2:	0f 84 b8 00 00 00    	je     80106b80 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ac8:	e8 e3 df ff ff       	call   80104ab0 <myproc>
80106acd:	85 c0                	test   %eax,%eax
80106acf:	74 1d                	je     80106aee <trap+0x9e>
80106ad1:	e8 da df ff ff       	call   80104ab0 <myproc>
80106ad6:	8b 40 24             	mov    0x24(%eax),%eax
80106ad9:	85 c0                	test   %eax,%eax
80106adb:	74 11                	je     80106aee <trap+0x9e>
80106add:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106ae1:	83 e0 03             	and    $0x3,%eax
80106ae4:	66 83 f8 03          	cmp    $0x3,%ax
80106ae8:	0f 84 0f 01 00 00    	je     80106bfd <trap+0x1ad>
    exit();
}
80106aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106af1:	5b                   	pop    %ebx
80106af2:	5e                   	pop    %esi
80106af3:	5f                   	pop    %edi
80106af4:	5d                   	pop    %ebp
80106af5:	c3                   	ret    
80106af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106b00:	e8 ab df ff ff       	call   80104ab0 <myproc>
80106b05:	8b 7b 38             	mov    0x38(%ebx),%edi
80106b08:	85 c0                	test   %eax,%eax
80106b0a:	0f 84 a2 01 00 00    	je     80106cb2 <trap+0x262>
80106b10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106b14:	0f 84 98 01 00 00    	je     80106cb2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b1a:	0f 20 d1             	mov    %cr2,%ecx
80106b1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b20:	e8 6b df ff ff       	call   80104a90 <cpuid>
80106b25:	8b 73 30             	mov    0x30(%ebx),%esi
80106b28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b2b:	8b 43 34             	mov    0x34(%ebx),%eax
80106b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106b31:	e8 7a df ff ff       	call   80104ab0 <myproc>
80106b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b39:	e8 72 df ff ff       	call   80104ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106b41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b44:	51                   	push   %ecx
80106b45:	57                   	push   %edi
80106b46:	52                   	push   %edx
80106b47:	ff 75 e4             	push   -0x1c(%ebp)
80106b4a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106b4b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106b4e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b51:	56                   	push   %esi
80106b52:	ff 70 10             	push   0x10(%eax)
80106b55:	68 fc 8a 10 80       	push   $0x80108afc
80106b5a:	e8 81 9c ff ff       	call   801007e0 <cprintf>
    myproc()->killed = 1;
80106b5f:	83 c4 20             	add    $0x20,%esp
80106b62:	e8 49 df ff ff       	call   80104ab0 <myproc>
80106b67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b6e:	e8 3d df ff ff       	call   80104ab0 <myproc>
80106b73:	85 c0                	test   %eax,%eax
80106b75:	0f 85 18 ff ff ff    	jne    80106a93 <trap+0x43>
80106b7b:	e9 30 ff ff ff       	jmp    80106ab0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106b80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106b84:	0f 85 3e ff ff ff    	jne    80106ac8 <trap+0x78>
    yield();
80106b8a:	e8 a1 e5 ff ff       	call   80105130 <yield>
80106b8f:	e9 34 ff ff ff       	jmp    80106ac8 <trap+0x78>
80106b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b98:	8b 7b 38             	mov    0x38(%ebx),%edi
80106b9b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106b9f:	e8 ec de ff ff       	call   80104a90 <cpuid>
80106ba4:	57                   	push   %edi
80106ba5:	56                   	push   %esi
80106ba6:	50                   	push   %eax
80106ba7:	68 a4 8a 10 80       	push   $0x80108aa4
80106bac:	e8 2f 9c ff ff       	call   801007e0 <cprintf>
    lapiceoi();
80106bb1:	e8 9a ce ff ff       	call   80103a50 <lapiceoi>
    break;
80106bb6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bb9:	e8 f2 de ff ff       	call   80104ab0 <myproc>
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	0f 85 cd fe ff ff    	jne    80106a93 <trap+0x43>
80106bc6:	e9 e5 fe ff ff       	jmp    80106ab0 <trap+0x60>
80106bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bcf:	90                   	nop
    if(myproc()->killed)
80106bd0:	e8 db de ff ff       	call   80104ab0 <myproc>
80106bd5:	8b 70 24             	mov    0x24(%eax),%esi
80106bd8:	85 f6                	test   %esi,%esi
80106bda:	0f 85 c8 00 00 00    	jne    80106ca8 <trap+0x258>
    myproc()->tf = tf;
80106be0:	e8 cb de ff ff       	call   80104ab0 <myproc>
80106be5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106be8:	e8 b3 ef ff ff       	call   80105ba0 <syscall>
    if(myproc()->killed)
80106bed:	e8 be de ff ff       	call   80104ab0 <myproc>
80106bf2:	8b 48 24             	mov    0x24(%eax),%ecx
80106bf5:	85 c9                	test   %ecx,%ecx
80106bf7:	0f 84 f1 fe ff ff    	je     80106aee <trap+0x9e>
}
80106bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c00:	5b                   	pop    %ebx
80106c01:	5e                   	pop    %esi
80106c02:	5f                   	pop    %edi
80106c03:	5d                   	pop    %ebp
      exit();
80106c04:	e9 c7 e2 ff ff       	jmp    80104ed0 <exit>
80106c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106c10:	e8 3b 02 00 00       	call   80106e50 <uartintr>
    lapiceoi();
80106c15:	e8 36 ce ff ff       	call   80103a50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c1a:	e8 91 de ff ff       	call   80104ab0 <myproc>
80106c1f:	85 c0                	test   %eax,%eax
80106c21:	0f 85 6c fe ff ff    	jne    80106a93 <trap+0x43>
80106c27:	e9 84 fe ff ff       	jmp    80106ab0 <trap+0x60>
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106c30:	e8 db cc ff ff       	call   80103910 <kbdintr>
    lapiceoi();
80106c35:	e8 16 ce ff ff       	call   80103a50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c3a:	e8 71 de ff ff       	call   80104ab0 <myproc>
80106c3f:	85 c0                	test   %eax,%eax
80106c41:	0f 85 4c fe ff ff    	jne    80106a93 <trap+0x43>
80106c47:	e9 64 fe ff ff       	jmp    80106ab0 <trap+0x60>
80106c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106c50:	e8 3b de ff ff       	call   80104a90 <cpuid>
80106c55:	85 c0                	test   %eax,%eax
80106c57:	0f 85 28 fe ff ff    	jne    80106a85 <trap+0x35>
      acquire(&tickslock);
80106c5d:	83 ec 0c             	sub    $0xc,%esp
80106c60:	68 20 58 11 80       	push   $0x80115820
80106c65:	e8 76 ea ff ff       	call   801056e0 <acquire>
      wakeup(&ticks);
80106c6a:	c7 04 24 00 58 11 80 	movl   $0x80115800,(%esp)
      ticks++;
80106c71:	83 05 00 58 11 80 01 	addl   $0x1,0x80115800
      wakeup(&ticks);
80106c78:	e8 c3 e5 ff ff       	call   80105240 <wakeup>
      release(&tickslock);
80106c7d:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
80106c84:	e8 f7 e9 ff ff       	call   80105680 <release>
80106c89:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106c8c:	e9 f4 fd ff ff       	jmp    80106a85 <trap+0x35>
80106c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106c98:	e8 33 e2 ff ff       	call   80104ed0 <exit>
80106c9d:	e9 0e fe ff ff       	jmp    80106ab0 <trap+0x60>
80106ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106ca8:	e8 23 e2 ff ff       	call   80104ed0 <exit>
80106cad:	e9 2e ff ff ff       	jmp    80106be0 <trap+0x190>
80106cb2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106cb5:	e8 d6 dd ff ff       	call   80104a90 <cpuid>
80106cba:	83 ec 0c             	sub    $0xc,%esp
80106cbd:	56                   	push   %esi
80106cbe:	57                   	push   %edi
80106cbf:	50                   	push   %eax
80106cc0:	ff 73 30             	push   0x30(%ebx)
80106cc3:	68 c8 8a 10 80       	push   $0x80108ac8
80106cc8:	e8 13 9b ff ff       	call   801007e0 <cprintf>
      panic("trap");
80106ccd:	83 c4 14             	add    $0x14,%esp
80106cd0:	68 9e 8a 10 80       	push   $0x80108a9e
80106cd5:	e8 86 97 ff ff       	call   80100460 <panic>
80106cda:	66 90                	xchg   %ax,%ax
80106cdc:	66 90                	xchg   %ax,%ax
80106cde:	66 90                	xchg   %ax,%ax

80106ce0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106ce0:	a1 60 60 11 80       	mov    0x80116060,%eax
80106ce5:	85 c0                	test   %eax,%eax
80106ce7:	74 17                	je     80106d00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ce9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106cef:	a8 01                	test   $0x1,%al
80106cf1:	74 0d                	je     80106d00 <uartgetc+0x20>
80106cf3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cf8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106cf9:	0f b6 c0             	movzbl %al,%eax
80106cfc:	c3                   	ret    
80106cfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d05:	c3                   	ret    
80106d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0d:	8d 76 00             	lea    0x0(%esi),%esi

80106d10 <uartinit>:
{
80106d10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d11:	31 c9                	xor    %ecx,%ecx
80106d13:	89 c8                	mov    %ecx,%eax
80106d15:	89 e5                	mov    %esp,%ebp
80106d17:	57                   	push   %edi
80106d18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106d1d:	56                   	push   %esi
80106d1e:	89 fa                	mov    %edi,%edx
80106d20:	53                   	push   %ebx
80106d21:	83 ec 1c             	sub    $0x1c,%esp
80106d24:	ee                   	out    %al,(%dx)
80106d25:	be fb 03 00 00       	mov    $0x3fb,%esi
80106d2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106d2f:	89 f2                	mov    %esi,%edx
80106d31:	ee                   	out    %al,(%dx)
80106d32:	b8 0c 00 00 00       	mov    $0xc,%eax
80106d37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d3c:	ee                   	out    %al,(%dx)
80106d3d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106d42:	89 c8                	mov    %ecx,%eax
80106d44:	89 da                	mov    %ebx,%edx
80106d46:	ee                   	out    %al,(%dx)
80106d47:	b8 03 00 00 00       	mov    $0x3,%eax
80106d4c:	89 f2                	mov    %esi,%edx
80106d4e:	ee                   	out    %al,(%dx)
80106d4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106d54:	89 c8                	mov    %ecx,%eax
80106d56:	ee                   	out    %al,(%dx)
80106d57:	b8 01 00 00 00       	mov    $0x1,%eax
80106d5c:	89 da                	mov    %ebx,%edx
80106d5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106d65:	3c ff                	cmp    $0xff,%al
80106d67:	74 78                	je     80106de1 <uartinit+0xd1>
  uart = 1;
80106d69:	c7 05 60 60 11 80 01 	movl   $0x1,0x80116060
80106d70:	00 00 00 
80106d73:	89 fa                	mov    %edi,%edx
80106d75:	ec                   	in     (%dx),%al
80106d76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106d7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106d7f:	bf c0 8b 10 80       	mov    $0x80108bc0,%edi
80106d84:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106d89:	6a 00                	push   $0x0
80106d8b:	6a 04                	push   $0x4
80106d8d:	e8 2e c8 ff ff       	call   801035c0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106d92:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106d96:	83 c4 10             	add    $0x10,%esp
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106da0:	a1 60 60 11 80       	mov    0x80116060,%eax
80106da5:	bb 80 00 00 00       	mov    $0x80,%ebx
80106daa:	85 c0                	test   %eax,%eax
80106dac:	75 14                	jne    80106dc2 <uartinit+0xb2>
80106dae:	eb 23                	jmp    80106dd3 <uartinit+0xc3>
    microdelay(10);
80106db0:	83 ec 0c             	sub    $0xc,%esp
80106db3:	6a 0a                	push   $0xa
80106db5:	e8 b6 cc ff ff       	call   80103a70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106dba:	83 c4 10             	add    $0x10,%esp
80106dbd:	83 eb 01             	sub    $0x1,%ebx
80106dc0:	74 07                	je     80106dc9 <uartinit+0xb9>
80106dc2:	89 f2                	mov    %esi,%edx
80106dc4:	ec                   	in     (%dx),%al
80106dc5:	a8 20                	test   $0x20,%al
80106dc7:	74 e7                	je     80106db0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106dc9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106dcd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106dd2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106dd3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106dd7:	83 c7 01             	add    $0x1,%edi
80106dda:	88 45 e7             	mov    %al,-0x19(%ebp)
80106ddd:	84 c0                	test   %al,%al
80106ddf:	75 bf                	jne    80106da0 <uartinit+0x90>
}
80106de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de4:	5b                   	pop    %ebx
80106de5:	5e                   	pop    %esi
80106de6:	5f                   	pop    %edi
80106de7:	5d                   	pop    %ebp
80106de8:	c3                   	ret    
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106df0 <uartputc>:
  if(!uart)
80106df0:	a1 60 60 11 80       	mov    0x80116060,%eax
80106df5:	85 c0                	test   %eax,%eax
80106df7:	74 47                	je     80106e40 <uartputc+0x50>
{
80106df9:	55                   	push   %ebp
80106dfa:	89 e5                	mov    %esp,%ebp
80106dfc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106dfd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106e02:	53                   	push   %ebx
80106e03:	bb 80 00 00 00       	mov    $0x80,%ebx
80106e08:	eb 18                	jmp    80106e22 <uartputc+0x32>
80106e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106e10:	83 ec 0c             	sub    $0xc,%esp
80106e13:	6a 0a                	push   $0xa
80106e15:	e8 56 cc ff ff       	call   80103a70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e1a:	83 c4 10             	add    $0x10,%esp
80106e1d:	83 eb 01             	sub    $0x1,%ebx
80106e20:	74 07                	je     80106e29 <uartputc+0x39>
80106e22:	89 f2                	mov    %esi,%edx
80106e24:	ec                   	in     (%dx),%al
80106e25:	a8 20                	test   $0x20,%al
80106e27:	74 e7                	je     80106e10 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e31:	ee                   	out    %al,(%dx)
}
80106e32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e35:	5b                   	pop    %ebx
80106e36:	5e                   	pop    %esi
80106e37:	5d                   	pop    %ebp
80106e38:	c3                   	ret    
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e40:	c3                   	ret    
80106e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4f:	90                   	nop

80106e50 <uartintr>:

void
uartintr(void)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106e56:	68 e0 6c 10 80       	push   $0x80106ce0
80106e5b:	e8 70 a7 ff ff       	call   801015d0 <consoleintr>
}
80106e60:	83 c4 10             	add    $0x10,%esp
80106e63:	c9                   	leave  
80106e64:	c3                   	ret    

80106e65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $0
80106e67:	6a 00                	push   $0x0
  jmp alltraps
80106e69:	e9 0c fb ff ff       	jmp    8010697a <alltraps>

80106e6e <vector1>:
.globl vector1
vector1:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $1
80106e70:	6a 01                	push   $0x1
  jmp alltraps
80106e72:	e9 03 fb ff ff       	jmp    8010697a <alltraps>

80106e77 <vector2>:
.globl vector2
vector2:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $2
80106e79:	6a 02                	push   $0x2
  jmp alltraps
80106e7b:	e9 fa fa ff ff       	jmp    8010697a <alltraps>

80106e80 <vector3>:
.globl vector3
vector3:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $3
80106e82:	6a 03                	push   $0x3
  jmp alltraps
80106e84:	e9 f1 fa ff ff       	jmp    8010697a <alltraps>

80106e89 <vector4>:
.globl vector4
vector4:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $4
80106e8b:	6a 04                	push   $0x4
  jmp alltraps
80106e8d:	e9 e8 fa ff ff       	jmp    8010697a <alltraps>

80106e92 <vector5>:
.globl vector5
vector5:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $5
80106e94:	6a 05                	push   $0x5
  jmp alltraps
80106e96:	e9 df fa ff ff       	jmp    8010697a <alltraps>

80106e9b <vector6>:
.globl vector6
vector6:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $6
80106e9d:	6a 06                	push   $0x6
  jmp alltraps
80106e9f:	e9 d6 fa ff ff       	jmp    8010697a <alltraps>

80106ea4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $7
80106ea6:	6a 07                	push   $0x7
  jmp alltraps
80106ea8:	e9 cd fa ff ff       	jmp    8010697a <alltraps>

80106ead <vector8>:
.globl vector8
vector8:
  pushl $8
80106ead:	6a 08                	push   $0x8
  jmp alltraps
80106eaf:	e9 c6 fa ff ff       	jmp    8010697a <alltraps>

80106eb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $9
80106eb6:	6a 09                	push   $0x9
  jmp alltraps
80106eb8:	e9 bd fa ff ff       	jmp    8010697a <alltraps>

80106ebd <vector10>:
.globl vector10
vector10:
  pushl $10
80106ebd:	6a 0a                	push   $0xa
  jmp alltraps
80106ebf:	e9 b6 fa ff ff       	jmp    8010697a <alltraps>

80106ec4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ec4:	6a 0b                	push   $0xb
  jmp alltraps
80106ec6:	e9 af fa ff ff       	jmp    8010697a <alltraps>

80106ecb <vector12>:
.globl vector12
vector12:
  pushl $12
80106ecb:	6a 0c                	push   $0xc
  jmp alltraps
80106ecd:	e9 a8 fa ff ff       	jmp    8010697a <alltraps>

80106ed2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ed2:	6a 0d                	push   $0xd
  jmp alltraps
80106ed4:	e9 a1 fa ff ff       	jmp    8010697a <alltraps>

80106ed9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ed9:	6a 0e                	push   $0xe
  jmp alltraps
80106edb:	e9 9a fa ff ff       	jmp    8010697a <alltraps>

80106ee0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $15
80106ee2:	6a 0f                	push   $0xf
  jmp alltraps
80106ee4:	e9 91 fa ff ff       	jmp    8010697a <alltraps>

80106ee9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $16
80106eeb:	6a 10                	push   $0x10
  jmp alltraps
80106eed:	e9 88 fa ff ff       	jmp    8010697a <alltraps>

80106ef2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ef2:	6a 11                	push   $0x11
  jmp alltraps
80106ef4:	e9 81 fa ff ff       	jmp    8010697a <alltraps>

80106ef9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $18
80106efb:	6a 12                	push   $0x12
  jmp alltraps
80106efd:	e9 78 fa ff ff       	jmp    8010697a <alltraps>

80106f02 <vector19>:
.globl vector19
vector19:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $19
80106f04:	6a 13                	push   $0x13
  jmp alltraps
80106f06:	e9 6f fa ff ff       	jmp    8010697a <alltraps>

80106f0b <vector20>:
.globl vector20
vector20:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $20
80106f0d:	6a 14                	push   $0x14
  jmp alltraps
80106f0f:	e9 66 fa ff ff       	jmp    8010697a <alltraps>

80106f14 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $21
80106f16:	6a 15                	push   $0x15
  jmp alltraps
80106f18:	e9 5d fa ff ff       	jmp    8010697a <alltraps>

80106f1d <vector22>:
.globl vector22
vector22:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $22
80106f1f:	6a 16                	push   $0x16
  jmp alltraps
80106f21:	e9 54 fa ff ff       	jmp    8010697a <alltraps>

80106f26 <vector23>:
.globl vector23
vector23:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $23
80106f28:	6a 17                	push   $0x17
  jmp alltraps
80106f2a:	e9 4b fa ff ff       	jmp    8010697a <alltraps>

80106f2f <vector24>:
.globl vector24
vector24:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $24
80106f31:	6a 18                	push   $0x18
  jmp alltraps
80106f33:	e9 42 fa ff ff       	jmp    8010697a <alltraps>

80106f38 <vector25>:
.globl vector25
vector25:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $25
80106f3a:	6a 19                	push   $0x19
  jmp alltraps
80106f3c:	e9 39 fa ff ff       	jmp    8010697a <alltraps>

80106f41 <vector26>:
.globl vector26
vector26:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $26
80106f43:	6a 1a                	push   $0x1a
  jmp alltraps
80106f45:	e9 30 fa ff ff       	jmp    8010697a <alltraps>

80106f4a <vector27>:
.globl vector27
vector27:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $27
80106f4c:	6a 1b                	push   $0x1b
  jmp alltraps
80106f4e:	e9 27 fa ff ff       	jmp    8010697a <alltraps>

80106f53 <vector28>:
.globl vector28
vector28:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $28
80106f55:	6a 1c                	push   $0x1c
  jmp alltraps
80106f57:	e9 1e fa ff ff       	jmp    8010697a <alltraps>

80106f5c <vector29>:
.globl vector29
vector29:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $29
80106f5e:	6a 1d                	push   $0x1d
  jmp alltraps
80106f60:	e9 15 fa ff ff       	jmp    8010697a <alltraps>

80106f65 <vector30>:
.globl vector30
vector30:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $30
80106f67:	6a 1e                	push   $0x1e
  jmp alltraps
80106f69:	e9 0c fa ff ff       	jmp    8010697a <alltraps>

80106f6e <vector31>:
.globl vector31
vector31:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $31
80106f70:	6a 1f                	push   $0x1f
  jmp alltraps
80106f72:	e9 03 fa ff ff       	jmp    8010697a <alltraps>

80106f77 <vector32>:
.globl vector32
vector32:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $32
80106f79:	6a 20                	push   $0x20
  jmp alltraps
80106f7b:	e9 fa f9 ff ff       	jmp    8010697a <alltraps>

80106f80 <vector33>:
.globl vector33
vector33:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $33
80106f82:	6a 21                	push   $0x21
  jmp alltraps
80106f84:	e9 f1 f9 ff ff       	jmp    8010697a <alltraps>

80106f89 <vector34>:
.globl vector34
vector34:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $34
80106f8b:	6a 22                	push   $0x22
  jmp alltraps
80106f8d:	e9 e8 f9 ff ff       	jmp    8010697a <alltraps>

80106f92 <vector35>:
.globl vector35
vector35:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $35
80106f94:	6a 23                	push   $0x23
  jmp alltraps
80106f96:	e9 df f9 ff ff       	jmp    8010697a <alltraps>

80106f9b <vector36>:
.globl vector36
vector36:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $36
80106f9d:	6a 24                	push   $0x24
  jmp alltraps
80106f9f:	e9 d6 f9 ff ff       	jmp    8010697a <alltraps>

80106fa4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $37
80106fa6:	6a 25                	push   $0x25
  jmp alltraps
80106fa8:	e9 cd f9 ff ff       	jmp    8010697a <alltraps>

80106fad <vector38>:
.globl vector38
vector38:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $38
80106faf:	6a 26                	push   $0x26
  jmp alltraps
80106fb1:	e9 c4 f9 ff ff       	jmp    8010697a <alltraps>

80106fb6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $39
80106fb8:	6a 27                	push   $0x27
  jmp alltraps
80106fba:	e9 bb f9 ff ff       	jmp    8010697a <alltraps>

80106fbf <vector40>:
.globl vector40
vector40:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $40
80106fc1:	6a 28                	push   $0x28
  jmp alltraps
80106fc3:	e9 b2 f9 ff ff       	jmp    8010697a <alltraps>

80106fc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $41
80106fca:	6a 29                	push   $0x29
  jmp alltraps
80106fcc:	e9 a9 f9 ff ff       	jmp    8010697a <alltraps>

80106fd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $42
80106fd3:	6a 2a                	push   $0x2a
  jmp alltraps
80106fd5:	e9 a0 f9 ff ff       	jmp    8010697a <alltraps>

80106fda <vector43>:
.globl vector43
vector43:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $43
80106fdc:	6a 2b                	push   $0x2b
  jmp alltraps
80106fde:	e9 97 f9 ff ff       	jmp    8010697a <alltraps>

80106fe3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $44
80106fe5:	6a 2c                	push   $0x2c
  jmp alltraps
80106fe7:	e9 8e f9 ff ff       	jmp    8010697a <alltraps>

80106fec <vector45>:
.globl vector45
vector45:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $45
80106fee:	6a 2d                	push   $0x2d
  jmp alltraps
80106ff0:	e9 85 f9 ff ff       	jmp    8010697a <alltraps>

80106ff5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $46
80106ff7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ff9:	e9 7c f9 ff ff       	jmp    8010697a <alltraps>

80106ffe <vector47>:
.globl vector47
vector47:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $47
80107000:	6a 2f                	push   $0x2f
  jmp alltraps
80107002:	e9 73 f9 ff ff       	jmp    8010697a <alltraps>

80107007 <vector48>:
.globl vector48
vector48:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $48
80107009:	6a 30                	push   $0x30
  jmp alltraps
8010700b:	e9 6a f9 ff ff       	jmp    8010697a <alltraps>

80107010 <vector49>:
.globl vector49
vector49:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $49
80107012:	6a 31                	push   $0x31
  jmp alltraps
80107014:	e9 61 f9 ff ff       	jmp    8010697a <alltraps>

80107019 <vector50>:
.globl vector50
vector50:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $50
8010701b:	6a 32                	push   $0x32
  jmp alltraps
8010701d:	e9 58 f9 ff ff       	jmp    8010697a <alltraps>

80107022 <vector51>:
.globl vector51
vector51:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $51
80107024:	6a 33                	push   $0x33
  jmp alltraps
80107026:	e9 4f f9 ff ff       	jmp    8010697a <alltraps>

8010702b <vector52>:
.globl vector52
vector52:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $52
8010702d:	6a 34                	push   $0x34
  jmp alltraps
8010702f:	e9 46 f9 ff ff       	jmp    8010697a <alltraps>

80107034 <vector53>:
.globl vector53
vector53:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $53
80107036:	6a 35                	push   $0x35
  jmp alltraps
80107038:	e9 3d f9 ff ff       	jmp    8010697a <alltraps>

8010703d <vector54>:
.globl vector54
vector54:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $54
8010703f:	6a 36                	push   $0x36
  jmp alltraps
80107041:	e9 34 f9 ff ff       	jmp    8010697a <alltraps>

80107046 <vector55>:
.globl vector55
vector55:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $55
80107048:	6a 37                	push   $0x37
  jmp alltraps
8010704a:	e9 2b f9 ff ff       	jmp    8010697a <alltraps>

8010704f <vector56>:
.globl vector56
vector56:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $56
80107051:	6a 38                	push   $0x38
  jmp alltraps
80107053:	e9 22 f9 ff ff       	jmp    8010697a <alltraps>

80107058 <vector57>:
.globl vector57
vector57:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $57
8010705a:	6a 39                	push   $0x39
  jmp alltraps
8010705c:	e9 19 f9 ff ff       	jmp    8010697a <alltraps>

80107061 <vector58>:
.globl vector58
vector58:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $58
80107063:	6a 3a                	push   $0x3a
  jmp alltraps
80107065:	e9 10 f9 ff ff       	jmp    8010697a <alltraps>

8010706a <vector59>:
.globl vector59
vector59:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $59
8010706c:	6a 3b                	push   $0x3b
  jmp alltraps
8010706e:	e9 07 f9 ff ff       	jmp    8010697a <alltraps>

80107073 <vector60>:
.globl vector60
vector60:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $60
80107075:	6a 3c                	push   $0x3c
  jmp alltraps
80107077:	e9 fe f8 ff ff       	jmp    8010697a <alltraps>

8010707c <vector61>:
.globl vector61
vector61:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $61
8010707e:	6a 3d                	push   $0x3d
  jmp alltraps
80107080:	e9 f5 f8 ff ff       	jmp    8010697a <alltraps>

80107085 <vector62>:
.globl vector62
vector62:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $62
80107087:	6a 3e                	push   $0x3e
  jmp alltraps
80107089:	e9 ec f8 ff ff       	jmp    8010697a <alltraps>

8010708e <vector63>:
.globl vector63
vector63:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $63
80107090:	6a 3f                	push   $0x3f
  jmp alltraps
80107092:	e9 e3 f8 ff ff       	jmp    8010697a <alltraps>

80107097 <vector64>:
.globl vector64
vector64:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $64
80107099:	6a 40                	push   $0x40
  jmp alltraps
8010709b:	e9 da f8 ff ff       	jmp    8010697a <alltraps>

801070a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $65
801070a2:	6a 41                	push   $0x41
  jmp alltraps
801070a4:	e9 d1 f8 ff ff       	jmp    8010697a <alltraps>

801070a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $66
801070ab:	6a 42                	push   $0x42
  jmp alltraps
801070ad:	e9 c8 f8 ff ff       	jmp    8010697a <alltraps>

801070b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $67
801070b4:	6a 43                	push   $0x43
  jmp alltraps
801070b6:	e9 bf f8 ff ff       	jmp    8010697a <alltraps>

801070bb <vector68>:
.globl vector68
vector68:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $68
801070bd:	6a 44                	push   $0x44
  jmp alltraps
801070bf:	e9 b6 f8 ff ff       	jmp    8010697a <alltraps>

801070c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $69
801070c6:	6a 45                	push   $0x45
  jmp alltraps
801070c8:	e9 ad f8 ff ff       	jmp    8010697a <alltraps>

801070cd <vector70>:
.globl vector70
vector70:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $70
801070cf:	6a 46                	push   $0x46
  jmp alltraps
801070d1:	e9 a4 f8 ff ff       	jmp    8010697a <alltraps>

801070d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $71
801070d8:	6a 47                	push   $0x47
  jmp alltraps
801070da:	e9 9b f8 ff ff       	jmp    8010697a <alltraps>

801070df <vector72>:
.globl vector72
vector72:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $72
801070e1:	6a 48                	push   $0x48
  jmp alltraps
801070e3:	e9 92 f8 ff ff       	jmp    8010697a <alltraps>

801070e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $73
801070ea:	6a 49                	push   $0x49
  jmp alltraps
801070ec:	e9 89 f8 ff ff       	jmp    8010697a <alltraps>

801070f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $74
801070f3:	6a 4a                	push   $0x4a
  jmp alltraps
801070f5:	e9 80 f8 ff ff       	jmp    8010697a <alltraps>

801070fa <vector75>:
.globl vector75
vector75:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $75
801070fc:	6a 4b                	push   $0x4b
  jmp alltraps
801070fe:	e9 77 f8 ff ff       	jmp    8010697a <alltraps>

80107103 <vector76>:
.globl vector76
vector76:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $76
80107105:	6a 4c                	push   $0x4c
  jmp alltraps
80107107:	e9 6e f8 ff ff       	jmp    8010697a <alltraps>

8010710c <vector77>:
.globl vector77
vector77:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $77
8010710e:	6a 4d                	push   $0x4d
  jmp alltraps
80107110:	e9 65 f8 ff ff       	jmp    8010697a <alltraps>

80107115 <vector78>:
.globl vector78
vector78:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $78
80107117:	6a 4e                	push   $0x4e
  jmp alltraps
80107119:	e9 5c f8 ff ff       	jmp    8010697a <alltraps>

8010711e <vector79>:
.globl vector79
vector79:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $79
80107120:	6a 4f                	push   $0x4f
  jmp alltraps
80107122:	e9 53 f8 ff ff       	jmp    8010697a <alltraps>

80107127 <vector80>:
.globl vector80
vector80:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $80
80107129:	6a 50                	push   $0x50
  jmp alltraps
8010712b:	e9 4a f8 ff ff       	jmp    8010697a <alltraps>

80107130 <vector81>:
.globl vector81
vector81:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $81
80107132:	6a 51                	push   $0x51
  jmp alltraps
80107134:	e9 41 f8 ff ff       	jmp    8010697a <alltraps>

80107139 <vector82>:
.globl vector82
vector82:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $82
8010713b:	6a 52                	push   $0x52
  jmp alltraps
8010713d:	e9 38 f8 ff ff       	jmp    8010697a <alltraps>

80107142 <vector83>:
.globl vector83
vector83:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $83
80107144:	6a 53                	push   $0x53
  jmp alltraps
80107146:	e9 2f f8 ff ff       	jmp    8010697a <alltraps>

8010714b <vector84>:
.globl vector84
vector84:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $84
8010714d:	6a 54                	push   $0x54
  jmp alltraps
8010714f:	e9 26 f8 ff ff       	jmp    8010697a <alltraps>

80107154 <vector85>:
.globl vector85
vector85:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $85
80107156:	6a 55                	push   $0x55
  jmp alltraps
80107158:	e9 1d f8 ff ff       	jmp    8010697a <alltraps>

8010715d <vector86>:
.globl vector86
vector86:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $86
8010715f:	6a 56                	push   $0x56
  jmp alltraps
80107161:	e9 14 f8 ff ff       	jmp    8010697a <alltraps>

80107166 <vector87>:
.globl vector87
vector87:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $87
80107168:	6a 57                	push   $0x57
  jmp alltraps
8010716a:	e9 0b f8 ff ff       	jmp    8010697a <alltraps>

8010716f <vector88>:
.globl vector88
vector88:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $88
80107171:	6a 58                	push   $0x58
  jmp alltraps
80107173:	e9 02 f8 ff ff       	jmp    8010697a <alltraps>

80107178 <vector89>:
.globl vector89
vector89:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $89
8010717a:	6a 59                	push   $0x59
  jmp alltraps
8010717c:	e9 f9 f7 ff ff       	jmp    8010697a <alltraps>

80107181 <vector90>:
.globl vector90
vector90:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $90
80107183:	6a 5a                	push   $0x5a
  jmp alltraps
80107185:	e9 f0 f7 ff ff       	jmp    8010697a <alltraps>

8010718a <vector91>:
.globl vector91
vector91:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $91
8010718c:	6a 5b                	push   $0x5b
  jmp alltraps
8010718e:	e9 e7 f7 ff ff       	jmp    8010697a <alltraps>

80107193 <vector92>:
.globl vector92
vector92:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $92
80107195:	6a 5c                	push   $0x5c
  jmp alltraps
80107197:	e9 de f7 ff ff       	jmp    8010697a <alltraps>

8010719c <vector93>:
.globl vector93
vector93:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $93
8010719e:	6a 5d                	push   $0x5d
  jmp alltraps
801071a0:	e9 d5 f7 ff ff       	jmp    8010697a <alltraps>

801071a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $94
801071a7:	6a 5e                	push   $0x5e
  jmp alltraps
801071a9:	e9 cc f7 ff ff       	jmp    8010697a <alltraps>

801071ae <vector95>:
.globl vector95
vector95:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $95
801071b0:	6a 5f                	push   $0x5f
  jmp alltraps
801071b2:	e9 c3 f7 ff ff       	jmp    8010697a <alltraps>

801071b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $96
801071b9:	6a 60                	push   $0x60
  jmp alltraps
801071bb:	e9 ba f7 ff ff       	jmp    8010697a <alltraps>

801071c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $97
801071c2:	6a 61                	push   $0x61
  jmp alltraps
801071c4:	e9 b1 f7 ff ff       	jmp    8010697a <alltraps>

801071c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $98
801071cb:	6a 62                	push   $0x62
  jmp alltraps
801071cd:	e9 a8 f7 ff ff       	jmp    8010697a <alltraps>

801071d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $99
801071d4:	6a 63                	push   $0x63
  jmp alltraps
801071d6:	e9 9f f7 ff ff       	jmp    8010697a <alltraps>

801071db <vector100>:
.globl vector100
vector100:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $100
801071dd:	6a 64                	push   $0x64
  jmp alltraps
801071df:	e9 96 f7 ff ff       	jmp    8010697a <alltraps>

801071e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $101
801071e6:	6a 65                	push   $0x65
  jmp alltraps
801071e8:	e9 8d f7 ff ff       	jmp    8010697a <alltraps>

801071ed <vector102>:
.globl vector102
vector102:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $102
801071ef:	6a 66                	push   $0x66
  jmp alltraps
801071f1:	e9 84 f7 ff ff       	jmp    8010697a <alltraps>

801071f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $103
801071f8:	6a 67                	push   $0x67
  jmp alltraps
801071fa:	e9 7b f7 ff ff       	jmp    8010697a <alltraps>

801071ff <vector104>:
.globl vector104
vector104:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $104
80107201:	6a 68                	push   $0x68
  jmp alltraps
80107203:	e9 72 f7 ff ff       	jmp    8010697a <alltraps>

80107208 <vector105>:
.globl vector105
vector105:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $105
8010720a:	6a 69                	push   $0x69
  jmp alltraps
8010720c:	e9 69 f7 ff ff       	jmp    8010697a <alltraps>

80107211 <vector106>:
.globl vector106
vector106:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $106
80107213:	6a 6a                	push   $0x6a
  jmp alltraps
80107215:	e9 60 f7 ff ff       	jmp    8010697a <alltraps>

8010721a <vector107>:
.globl vector107
vector107:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $107
8010721c:	6a 6b                	push   $0x6b
  jmp alltraps
8010721e:	e9 57 f7 ff ff       	jmp    8010697a <alltraps>

80107223 <vector108>:
.globl vector108
vector108:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $108
80107225:	6a 6c                	push   $0x6c
  jmp alltraps
80107227:	e9 4e f7 ff ff       	jmp    8010697a <alltraps>

8010722c <vector109>:
.globl vector109
vector109:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $109
8010722e:	6a 6d                	push   $0x6d
  jmp alltraps
80107230:	e9 45 f7 ff ff       	jmp    8010697a <alltraps>

80107235 <vector110>:
.globl vector110
vector110:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $110
80107237:	6a 6e                	push   $0x6e
  jmp alltraps
80107239:	e9 3c f7 ff ff       	jmp    8010697a <alltraps>

8010723e <vector111>:
.globl vector111
vector111:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $111
80107240:	6a 6f                	push   $0x6f
  jmp alltraps
80107242:	e9 33 f7 ff ff       	jmp    8010697a <alltraps>

80107247 <vector112>:
.globl vector112
vector112:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $112
80107249:	6a 70                	push   $0x70
  jmp alltraps
8010724b:	e9 2a f7 ff ff       	jmp    8010697a <alltraps>

80107250 <vector113>:
.globl vector113
vector113:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $113
80107252:	6a 71                	push   $0x71
  jmp alltraps
80107254:	e9 21 f7 ff ff       	jmp    8010697a <alltraps>

80107259 <vector114>:
.globl vector114
vector114:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $114
8010725b:	6a 72                	push   $0x72
  jmp alltraps
8010725d:	e9 18 f7 ff ff       	jmp    8010697a <alltraps>

80107262 <vector115>:
.globl vector115
vector115:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $115
80107264:	6a 73                	push   $0x73
  jmp alltraps
80107266:	e9 0f f7 ff ff       	jmp    8010697a <alltraps>

8010726b <vector116>:
.globl vector116
vector116:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $116
8010726d:	6a 74                	push   $0x74
  jmp alltraps
8010726f:	e9 06 f7 ff ff       	jmp    8010697a <alltraps>

80107274 <vector117>:
.globl vector117
vector117:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $117
80107276:	6a 75                	push   $0x75
  jmp alltraps
80107278:	e9 fd f6 ff ff       	jmp    8010697a <alltraps>

8010727d <vector118>:
.globl vector118
vector118:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $118
8010727f:	6a 76                	push   $0x76
  jmp alltraps
80107281:	e9 f4 f6 ff ff       	jmp    8010697a <alltraps>

80107286 <vector119>:
.globl vector119
vector119:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $119
80107288:	6a 77                	push   $0x77
  jmp alltraps
8010728a:	e9 eb f6 ff ff       	jmp    8010697a <alltraps>

8010728f <vector120>:
.globl vector120
vector120:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $120
80107291:	6a 78                	push   $0x78
  jmp alltraps
80107293:	e9 e2 f6 ff ff       	jmp    8010697a <alltraps>

80107298 <vector121>:
.globl vector121
vector121:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $121
8010729a:	6a 79                	push   $0x79
  jmp alltraps
8010729c:	e9 d9 f6 ff ff       	jmp    8010697a <alltraps>

801072a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $122
801072a3:	6a 7a                	push   $0x7a
  jmp alltraps
801072a5:	e9 d0 f6 ff ff       	jmp    8010697a <alltraps>

801072aa <vector123>:
.globl vector123
vector123:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $123
801072ac:	6a 7b                	push   $0x7b
  jmp alltraps
801072ae:	e9 c7 f6 ff ff       	jmp    8010697a <alltraps>

801072b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $124
801072b5:	6a 7c                	push   $0x7c
  jmp alltraps
801072b7:	e9 be f6 ff ff       	jmp    8010697a <alltraps>

801072bc <vector125>:
.globl vector125
vector125:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $125
801072be:	6a 7d                	push   $0x7d
  jmp alltraps
801072c0:	e9 b5 f6 ff ff       	jmp    8010697a <alltraps>

801072c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $126
801072c7:	6a 7e                	push   $0x7e
  jmp alltraps
801072c9:	e9 ac f6 ff ff       	jmp    8010697a <alltraps>

801072ce <vector127>:
.globl vector127
vector127:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $127
801072d0:	6a 7f                	push   $0x7f
  jmp alltraps
801072d2:	e9 a3 f6 ff ff       	jmp    8010697a <alltraps>

801072d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $128
801072d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801072de:	e9 97 f6 ff ff       	jmp    8010697a <alltraps>

801072e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $129
801072e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801072ea:	e9 8b f6 ff ff       	jmp    8010697a <alltraps>

801072ef <vector130>:
.globl vector130
vector130:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $130
801072f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801072f6:	e9 7f f6 ff ff       	jmp    8010697a <alltraps>

801072fb <vector131>:
.globl vector131
vector131:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $131
801072fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107302:	e9 73 f6 ff ff       	jmp    8010697a <alltraps>

80107307 <vector132>:
.globl vector132
vector132:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $132
80107309:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010730e:	e9 67 f6 ff ff       	jmp    8010697a <alltraps>

80107313 <vector133>:
.globl vector133
vector133:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $133
80107315:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010731a:	e9 5b f6 ff ff       	jmp    8010697a <alltraps>

8010731f <vector134>:
.globl vector134
vector134:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $134
80107321:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107326:	e9 4f f6 ff ff       	jmp    8010697a <alltraps>

8010732b <vector135>:
.globl vector135
vector135:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $135
8010732d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107332:	e9 43 f6 ff ff       	jmp    8010697a <alltraps>

80107337 <vector136>:
.globl vector136
vector136:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $136
80107339:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010733e:	e9 37 f6 ff ff       	jmp    8010697a <alltraps>

80107343 <vector137>:
.globl vector137
vector137:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $137
80107345:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010734a:	e9 2b f6 ff ff       	jmp    8010697a <alltraps>

8010734f <vector138>:
.globl vector138
vector138:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $138
80107351:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107356:	e9 1f f6 ff ff       	jmp    8010697a <alltraps>

8010735b <vector139>:
.globl vector139
vector139:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $139
8010735d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107362:	e9 13 f6 ff ff       	jmp    8010697a <alltraps>

80107367 <vector140>:
.globl vector140
vector140:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $140
80107369:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010736e:	e9 07 f6 ff ff       	jmp    8010697a <alltraps>

80107373 <vector141>:
.globl vector141
vector141:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $141
80107375:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010737a:	e9 fb f5 ff ff       	jmp    8010697a <alltraps>

8010737f <vector142>:
.globl vector142
vector142:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $142
80107381:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107386:	e9 ef f5 ff ff       	jmp    8010697a <alltraps>

8010738b <vector143>:
.globl vector143
vector143:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $143
8010738d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107392:	e9 e3 f5 ff ff       	jmp    8010697a <alltraps>

80107397 <vector144>:
.globl vector144
vector144:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $144
80107399:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010739e:	e9 d7 f5 ff ff       	jmp    8010697a <alltraps>

801073a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $145
801073a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801073aa:	e9 cb f5 ff ff       	jmp    8010697a <alltraps>

801073af <vector146>:
.globl vector146
vector146:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $146
801073b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801073b6:	e9 bf f5 ff ff       	jmp    8010697a <alltraps>

801073bb <vector147>:
.globl vector147
vector147:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $147
801073bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801073c2:	e9 b3 f5 ff ff       	jmp    8010697a <alltraps>

801073c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $148
801073c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801073ce:	e9 a7 f5 ff ff       	jmp    8010697a <alltraps>

801073d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $149
801073d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801073da:	e9 9b f5 ff ff       	jmp    8010697a <alltraps>

801073df <vector150>:
.globl vector150
vector150:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $150
801073e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801073e6:	e9 8f f5 ff ff       	jmp    8010697a <alltraps>

801073eb <vector151>:
.globl vector151
vector151:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $151
801073ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801073f2:	e9 83 f5 ff ff       	jmp    8010697a <alltraps>

801073f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $152
801073f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801073fe:	e9 77 f5 ff ff       	jmp    8010697a <alltraps>

80107403 <vector153>:
.globl vector153
vector153:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $153
80107405:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010740a:	e9 6b f5 ff ff       	jmp    8010697a <alltraps>

8010740f <vector154>:
.globl vector154
vector154:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $154
80107411:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107416:	e9 5f f5 ff ff       	jmp    8010697a <alltraps>

8010741b <vector155>:
.globl vector155
vector155:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $155
8010741d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107422:	e9 53 f5 ff ff       	jmp    8010697a <alltraps>

80107427 <vector156>:
.globl vector156
vector156:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $156
80107429:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010742e:	e9 47 f5 ff ff       	jmp    8010697a <alltraps>

80107433 <vector157>:
.globl vector157
vector157:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $157
80107435:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010743a:	e9 3b f5 ff ff       	jmp    8010697a <alltraps>

8010743f <vector158>:
.globl vector158
vector158:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $158
80107441:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107446:	e9 2f f5 ff ff       	jmp    8010697a <alltraps>

8010744b <vector159>:
.globl vector159
vector159:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $159
8010744d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107452:	e9 23 f5 ff ff       	jmp    8010697a <alltraps>

80107457 <vector160>:
.globl vector160
vector160:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $160
80107459:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010745e:	e9 17 f5 ff ff       	jmp    8010697a <alltraps>

80107463 <vector161>:
.globl vector161
vector161:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $161
80107465:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010746a:	e9 0b f5 ff ff       	jmp    8010697a <alltraps>

8010746f <vector162>:
.globl vector162
vector162:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $162
80107471:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107476:	e9 ff f4 ff ff       	jmp    8010697a <alltraps>

8010747b <vector163>:
.globl vector163
vector163:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $163
8010747d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107482:	e9 f3 f4 ff ff       	jmp    8010697a <alltraps>

80107487 <vector164>:
.globl vector164
vector164:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $164
80107489:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010748e:	e9 e7 f4 ff ff       	jmp    8010697a <alltraps>

80107493 <vector165>:
.globl vector165
vector165:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $165
80107495:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010749a:	e9 db f4 ff ff       	jmp    8010697a <alltraps>

8010749f <vector166>:
.globl vector166
vector166:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $166
801074a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801074a6:	e9 cf f4 ff ff       	jmp    8010697a <alltraps>

801074ab <vector167>:
.globl vector167
vector167:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $167
801074ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801074b2:	e9 c3 f4 ff ff       	jmp    8010697a <alltraps>

801074b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $168
801074b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801074be:	e9 b7 f4 ff ff       	jmp    8010697a <alltraps>

801074c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $169
801074c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801074ca:	e9 ab f4 ff ff       	jmp    8010697a <alltraps>

801074cf <vector170>:
.globl vector170
vector170:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $170
801074d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801074d6:	e9 9f f4 ff ff       	jmp    8010697a <alltraps>

801074db <vector171>:
.globl vector171
vector171:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $171
801074dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801074e2:	e9 93 f4 ff ff       	jmp    8010697a <alltraps>

801074e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $172
801074e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801074ee:	e9 87 f4 ff ff       	jmp    8010697a <alltraps>

801074f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $173
801074f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801074fa:	e9 7b f4 ff ff       	jmp    8010697a <alltraps>

801074ff <vector174>:
.globl vector174
vector174:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $174
80107501:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107506:	e9 6f f4 ff ff       	jmp    8010697a <alltraps>

8010750b <vector175>:
.globl vector175
vector175:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $175
8010750d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107512:	e9 63 f4 ff ff       	jmp    8010697a <alltraps>

80107517 <vector176>:
.globl vector176
vector176:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $176
80107519:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010751e:	e9 57 f4 ff ff       	jmp    8010697a <alltraps>

80107523 <vector177>:
.globl vector177
vector177:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $177
80107525:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010752a:	e9 4b f4 ff ff       	jmp    8010697a <alltraps>

8010752f <vector178>:
.globl vector178
vector178:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $178
80107531:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107536:	e9 3f f4 ff ff       	jmp    8010697a <alltraps>

8010753b <vector179>:
.globl vector179
vector179:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $179
8010753d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107542:	e9 33 f4 ff ff       	jmp    8010697a <alltraps>

80107547 <vector180>:
.globl vector180
vector180:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $180
80107549:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010754e:	e9 27 f4 ff ff       	jmp    8010697a <alltraps>

80107553 <vector181>:
.globl vector181
vector181:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $181
80107555:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010755a:	e9 1b f4 ff ff       	jmp    8010697a <alltraps>

8010755f <vector182>:
.globl vector182
vector182:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $182
80107561:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107566:	e9 0f f4 ff ff       	jmp    8010697a <alltraps>

8010756b <vector183>:
.globl vector183
vector183:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $183
8010756d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107572:	e9 03 f4 ff ff       	jmp    8010697a <alltraps>

80107577 <vector184>:
.globl vector184
vector184:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $184
80107579:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010757e:	e9 f7 f3 ff ff       	jmp    8010697a <alltraps>

80107583 <vector185>:
.globl vector185
vector185:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $185
80107585:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010758a:	e9 eb f3 ff ff       	jmp    8010697a <alltraps>

8010758f <vector186>:
.globl vector186
vector186:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $186
80107591:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107596:	e9 df f3 ff ff       	jmp    8010697a <alltraps>

8010759b <vector187>:
.globl vector187
vector187:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $187
8010759d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801075a2:	e9 d3 f3 ff ff       	jmp    8010697a <alltraps>

801075a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $188
801075a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801075ae:	e9 c7 f3 ff ff       	jmp    8010697a <alltraps>

801075b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $189
801075b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801075ba:	e9 bb f3 ff ff       	jmp    8010697a <alltraps>

801075bf <vector190>:
.globl vector190
vector190:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $190
801075c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801075c6:	e9 af f3 ff ff       	jmp    8010697a <alltraps>

801075cb <vector191>:
.globl vector191
vector191:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $191
801075cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801075d2:	e9 a3 f3 ff ff       	jmp    8010697a <alltraps>

801075d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $192
801075d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801075de:	e9 97 f3 ff ff       	jmp    8010697a <alltraps>

801075e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $193
801075e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801075ea:	e9 8b f3 ff ff       	jmp    8010697a <alltraps>

801075ef <vector194>:
.globl vector194
vector194:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $194
801075f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801075f6:	e9 7f f3 ff ff       	jmp    8010697a <alltraps>

801075fb <vector195>:
.globl vector195
vector195:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $195
801075fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107602:	e9 73 f3 ff ff       	jmp    8010697a <alltraps>

80107607 <vector196>:
.globl vector196
vector196:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $196
80107609:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010760e:	e9 67 f3 ff ff       	jmp    8010697a <alltraps>

80107613 <vector197>:
.globl vector197
vector197:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $197
80107615:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010761a:	e9 5b f3 ff ff       	jmp    8010697a <alltraps>

8010761f <vector198>:
.globl vector198
vector198:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $198
80107621:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107626:	e9 4f f3 ff ff       	jmp    8010697a <alltraps>

8010762b <vector199>:
.globl vector199
vector199:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $199
8010762d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107632:	e9 43 f3 ff ff       	jmp    8010697a <alltraps>

80107637 <vector200>:
.globl vector200
vector200:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $200
80107639:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010763e:	e9 37 f3 ff ff       	jmp    8010697a <alltraps>

80107643 <vector201>:
.globl vector201
vector201:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $201
80107645:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010764a:	e9 2b f3 ff ff       	jmp    8010697a <alltraps>

8010764f <vector202>:
.globl vector202
vector202:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $202
80107651:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107656:	e9 1f f3 ff ff       	jmp    8010697a <alltraps>

8010765b <vector203>:
.globl vector203
vector203:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $203
8010765d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107662:	e9 13 f3 ff ff       	jmp    8010697a <alltraps>

80107667 <vector204>:
.globl vector204
vector204:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $204
80107669:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010766e:	e9 07 f3 ff ff       	jmp    8010697a <alltraps>

80107673 <vector205>:
.globl vector205
vector205:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $205
80107675:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010767a:	e9 fb f2 ff ff       	jmp    8010697a <alltraps>

8010767f <vector206>:
.globl vector206
vector206:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $206
80107681:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107686:	e9 ef f2 ff ff       	jmp    8010697a <alltraps>

8010768b <vector207>:
.globl vector207
vector207:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $207
8010768d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107692:	e9 e3 f2 ff ff       	jmp    8010697a <alltraps>

80107697 <vector208>:
.globl vector208
vector208:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $208
80107699:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010769e:	e9 d7 f2 ff ff       	jmp    8010697a <alltraps>

801076a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $209
801076a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801076aa:	e9 cb f2 ff ff       	jmp    8010697a <alltraps>

801076af <vector210>:
.globl vector210
vector210:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $210
801076b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801076b6:	e9 bf f2 ff ff       	jmp    8010697a <alltraps>

801076bb <vector211>:
.globl vector211
vector211:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $211
801076bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801076c2:	e9 b3 f2 ff ff       	jmp    8010697a <alltraps>

801076c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $212
801076c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801076ce:	e9 a7 f2 ff ff       	jmp    8010697a <alltraps>

801076d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $213
801076d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801076da:	e9 9b f2 ff ff       	jmp    8010697a <alltraps>

801076df <vector214>:
.globl vector214
vector214:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $214
801076e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801076e6:	e9 8f f2 ff ff       	jmp    8010697a <alltraps>

801076eb <vector215>:
.globl vector215
vector215:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $215
801076ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801076f2:	e9 83 f2 ff ff       	jmp    8010697a <alltraps>

801076f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $216
801076f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801076fe:	e9 77 f2 ff ff       	jmp    8010697a <alltraps>

80107703 <vector217>:
.globl vector217
vector217:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $217
80107705:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010770a:	e9 6b f2 ff ff       	jmp    8010697a <alltraps>

8010770f <vector218>:
.globl vector218
vector218:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $218
80107711:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107716:	e9 5f f2 ff ff       	jmp    8010697a <alltraps>

8010771b <vector219>:
.globl vector219
vector219:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $219
8010771d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107722:	e9 53 f2 ff ff       	jmp    8010697a <alltraps>

80107727 <vector220>:
.globl vector220
vector220:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $220
80107729:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010772e:	e9 47 f2 ff ff       	jmp    8010697a <alltraps>

80107733 <vector221>:
.globl vector221
vector221:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $221
80107735:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010773a:	e9 3b f2 ff ff       	jmp    8010697a <alltraps>

8010773f <vector222>:
.globl vector222
vector222:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $222
80107741:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107746:	e9 2f f2 ff ff       	jmp    8010697a <alltraps>

8010774b <vector223>:
.globl vector223
vector223:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $223
8010774d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107752:	e9 23 f2 ff ff       	jmp    8010697a <alltraps>

80107757 <vector224>:
.globl vector224
vector224:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $224
80107759:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010775e:	e9 17 f2 ff ff       	jmp    8010697a <alltraps>

80107763 <vector225>:
.globl vector225
vector225:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $225
80107765:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010776a:	e9 0b f2 ff ff       	jmp    8010697a <alltraps>

8010776f <vector226>:
.globl vector226
vector226:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $226
80107771:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107776:	e9 ff f1 ff ff       	jmp    8010697a <alltraps>

8010777b <vector227>:
.globl vector227
vector227:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $227
8010777d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107782:	e9 f3 f1 ff ff       	jmp    8010697a <alltraps>

80107787 <vector228>:
.globl vector228
vector228:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $228
80107789:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010778e:	e9 e7 f1 ff ff       	jmp    8010697a <alltraps>

80107793 <vector229>:
.globl vector229
vector229:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $229
80107795:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010779a:	e9 db f1 ff ff       	jmp    8010697a <alltraps>

8010779f <vector230>:
.globl vector230
vector230:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $230
801077a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801077a6:	e9 cf f1 ff ff       	jmp    8010697a <alltraps>

801077ab <vector231>:
.globl vector231
vector231:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $231
801077ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801077b2:	e9 c3 f1 ff ff       	jmp    8010697a <alltraps>

801077b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $232
801077b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801077be:	e9 b7 f1 ff ff       	jmp    8010697a <alltraps>

801077c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $233
801077c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801077ca:	e9 ab f1 ff ff       	jmp    8010697a <alltraps>

801077cf <vector234>:
.globl vector234
vector234:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $234
801077d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801077d6:	e9 9f f1 ff ff       	jmp    8010697a <alltraps>

801077db <vector235>:
.globl vector235
vector235:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $235
801077dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801077e2:	e9 93 f1 ff ff       	jmp    8010697a <alltraps>

801077e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $236
801077e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801077ee:	e9 87 f1 ff ff       	jmp    8010697a <alltraps>

801077f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $237
801077f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801077fa:	e9 7b f1 ff ff       	jmp    8010697a <alltraps>

801077ff <vector238>:
.globl vector238
vector238:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $238
80107801:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107806:	e9 6f f1 ff ff       	jmp    8010697a <alltraps>

8010780b <vector239>:
.globl vector239
vector239:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $239
8010780d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107812:	e9 63 f1 ff ff       	jmp    8010697a <alltraps>

80107817 <vector240>:
.globl vector240
vector240:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $240
80107819:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010781e:	e9 57 f1 ff ff       	jmp    8010697a <alltraps>

80107823 <vector241>:
.globl vector241
vector241:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $241
80107825:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010782a:	e9 4b f1 ff ff       	jmp    8010697a <alltraps>

8010782f <vector242>:
.globl vector242
vector242:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $242
80107831:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107836:	e9 3f f1 ff ff       	jmp    8010697a <alltraps>

8010783b <vector243>:
.globl vector243
vector243:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $243
8010783d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107842:	e9 33 f1 ff ff       	jmp    8010697a <alltraps>

80107847 <vector244>:
.globl vector244
vector244:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $244
80107849:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010784e:	e9 27 f1 ff ff       	jmp    8010697a <alltraps>

80107853 <vector245>:
.globl vector245
vector245:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $245
80107855:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010785a:	e9 1b f1 ff ff       	jmp    8010697a <alltraps>

8010785f <vector246>:
.globl vector246
vector246:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $246
80107861:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107866:	e9 0f f1 ff ff       	jmp    8010697a <alltraps>

8010786b <vector247>:
.globl vector247
vector247:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $247
8010786d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107872:	e9 03 f1 ff ff       	jmp    8010697a <alltraps>

80107877 <vector248>:
.globl vector248
vector248:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $248
80107879:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010787e:	e9 f7 f0 ff ff       	jmp    8010697a <alltraps>

80107883 <vector249>:
.globl vector249
vector249:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $249
80107885:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010788a:	e9 eb f0 ff ff       	jmp    8010697a <alltraps>

8010788f <vector250>:
.globl vector250
vector250:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $250
80107891:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107896:	e9 df f0 ff ff       	jmp    8010697a <alltraps>

8010789b <vector251>:
.globl vector251
vector251:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $251
8010789d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801078a2:	e9 d3 f0 ff ff       	jmp    8010697a <alltraps>

801078a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $252
801078a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801078ae:	e9 c7 f0 ff ff       	jmp    8010697a <alltraps>

801078b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $253
801078b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801078ba:	e9 bb f0 ff ff       	jmp    8010697a <alltraps>

801078bf <vector254>:
.globl vector254
vector254:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $254
801078c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801078c6:	e9 af f0 ff ff       	jmp    8010697a <alltraps>

801078cb <vector255>:
.globl vector255
vector255:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $255
801078cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801078d2:	e9 a3 f0 ff ff       	jmp    8010697a <alltraps>
801078d7:	66 90                	xchg   %ax,%ax
801078d9:	66 90                	xchg   %ax,%ax
801078db:	66 90                	xchg   %ax,%ax
801078dd:	66 90                	xchg   %ax,%ax
801078df:	90                   	nop

801078e0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801078e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801078ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078f2:	83 ec 1c             	sub    $0x1c,%esp
801078f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801078f8:	39 d3                	cmp    %edx,%ebx
801078fa:	73 49                	jae    80107945 <deallocuvm.part.0+0x65>
801078fc:	89 c7                	mov    %eax,%edi
801078fe:	eb 0c                	jmp    8010790c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107900:	83 c0 01             	add    $0x1,%eax
80107903:	c1 e0 16             	shl    $0x16,%eax
80107906:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107908:	39 da                	cmp    %ebx,%edx
8010790a:	76 39                	jbe    80107945 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010790c:	89 d8                	mov    %ebx,%eax
8010790e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107911:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107914:	f6 c1 01             	test   $0x1,%cl
80107917:	74 e7                	je     80107900 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107919:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010791b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107921:	c1 ee 0a             	shr    $0xa,%esi
80107924:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010792a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107931:	85 f6                	test   %esi,%esi
80107933:	74 cb                	je     80107900 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107935:	8b 06                	mov    (%esi),%eax
80107937:	a8 01                	test   $0x1,%al
80107939:	75 15                	jne    80107950 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010793b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107941:	39 da                	cmp    %ebx,%edx
80107943:	77 c7                	ja     8010790c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107945:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107948:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010794b:	5b                   	pop    %ebx
8010794c:	5e                   	pop    %esi
8010794d:	5f                   	pop    %edi
8010794e:	5d                   	pop    %ebp
8010794f:	c3                   	ret    
      if(pa == 0)
80107950:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107955:	74 25                	je     8010797c <deallocuvm.part.0+0x9c>
      kfree(v);
80107957:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010795a:	05 00 00 00 80       	add    $0x80000000,%eax
8010795f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107962:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107968:	50                   	push   %eax
80107969:	e8 92 bc ff ff       	call   80103600 <kfree>
      *pte = 0;
8010796e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107974:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107977:	83 c4 10             	add    $0x10,%esp
8010797a:	eb 8c                	jmp    80107908 <deallocuvm.part.0+0x28>
        panic("kfree");
8010797c:	83 ec 0c             	sub    $0xc,%esp
8010797f:	68 86 85 10 80       	push   $0x80108586
80107984:	e8 d7 8a ff ff       	call   80100460 <panic>
80107989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107990 <mappages>:
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107996:	89 d3                	mov    %edx,%ebx
80107998:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010799e:	83 ec 1c             	sub    $0x1c,%esp
801079a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801079a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801079a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801079b0:	8b 45 08             	mov    0x8(%ebp),%eax
801079b3:	29 d8                	sub    %ebx,%eax
801079b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079b8:	eb 3d                	jmp    801079f7 <mappages+0x67>
801079ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801079c0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801079c7:	c1 ea 0a             	shr    $0xa,%edx
801079ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801079d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079d7:	85 c0                	test   %eax,%eax
801079d9:	74 75                	je     80107a50 <mappages+0xc0>
    if(*pte & PTE_P)
801079db:	f6 00 01             	testb  $0x1,(%eax)
801079de:	0f 85 86 00 00 00    	jne    80107a6a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801079e4:	0b 75 0c             	or     0xc(%ebp),%esi
801079e7:	83 ce 01             	or     $0x1,%esi
801079ea:	89 30                	mov    %esi,(%eax)
    if(a == last)
801079ec:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801079ef:	74 6f                	je     80107a60 <mappages+0xd0>
    a += PGSIZE;
801079f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801079f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801079fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801079fd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107a00:	89 d8                	mov    %ebx,%eax
80107a02:	c1 e8 16             	shr    $0x16,%eax
80107a05:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107a08:	8b 07                	mov    (%edi),%eax
80107a0a:	a8 01                	test   $0x1,%al
80107a0c:	75 b2                	jne    801079c0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107a0e:	e8 ad bd ff ff       	call   801037c0 <kalloc>
80107a13:	85 c0                	test   %eax,%eax
80107a15:	74 39                	je     80107a50 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107a17:	83 ec 04             	sub    $0x4,%esp
80107a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107a1d:	68 00 10 00 00       	push   $0x1000
80107a22:	6a 00                	push   $0x0
80107a24:	50                   	push   %eax
80107a25:	e8 76 dd ff ff       	call   801057a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107a2a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107a2d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107a30:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107a36:	83 c8 07             	or     $0x7,%eax
80107a39:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107a3b:	89 d8                	mov    %ebx,%eax
80107a3d:	c1 e8 0a             	shr    $0xa,%eax
80107a40:	25 fc 0f 00 00       	and    $0xffc,%eax
80107a45:	01 d0                	add    %edx,%eax
80107a47:	eb 92                	jmp    801079db <mappages+0x4b>
80107a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a58:	5b                   	pop    %ebx
80107a59:	5e                   	pop    %esi
80107a5a:	5f                   	pop    %edi
80107a5b:	5d                   	pop    %ebp
80107a5c:	c3                   	ret    
80107a5d:	8d 76 00             	lea    0x0(%esi),%esi
80107a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a63:	31 c0                	xor    %eax,%eax
}
80107a65:	5b                   	pop    %ebx
80107a66:	5e                   	pop    %esi
80107a67:	5f                   	pop    %edi
80107a68:	5d                   	pop    %ebp
80107a69:	c3                   	ret    
      panic("remap");
80107a6a:	83 ec 0c             	sub    $0xc,%esp
80107a6d:	68 c8 8b 10 80       	push   $0x80108bc8
80107a72:	e8 e9 89 ff ff       	call   80100460 <panic>
80107a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a7e:	66 90                	xchg   %ax,%ax

80107a80 <seginit>:
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107a86:	e8 05 d0 ff ff       	call   80104a90 <cpuid>
  pd[0] = size-1;
80107a8b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107a90:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107a96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a9a:	c7 80 b8 33 11 80 ff 	movl   $0xffff,-0x7feecc48(%eax)
80107aa1:	ff 00 00 
80107aa4:	c7 80 bc 33 11 80 00 	movl   $0xcf9a00,-0x7feecc44(%eax)
80107aab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107aae:	c7 80 c0 33 11 80 ff 	movl   $0xffff,-0x7feecc40(%eax)
80107ab5:	ff 00 00 
80107ab8:	c7 80 c4 33 11 80 00 	movl   $0xcf9200,-0x7feecc3c(%eax)
80107abf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ac2:	c7 80 c8 33 11 80 ff 	movl   $0xffff,-0x7feecc38(%eax)
80107ac9:	ff 00 00 
80107acc:	c7 80 cc 33 11 80 00 	movl   $0xcffa00,-0x7feecc34(%eax)
80107ad3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ad6:	c7 80 d0 33 11 80 ff 	movl   $0xffff,-0x7feecc30(%eax)
80107add:	ff 00 00 
80107ae0:	c7 80 d4 33 11 80 00 	movl   $0xcff200,-0x7feecc2c(%eax)
80107ae7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107aea:	05 b0 33 11 80       	add    $0x801133b0,%eax
  pd[1] = (uint)p;
80107aef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107af3:	c1 e8 10             	shr    $0x10,%eax
80107af6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107afa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107afd:	0f 01 10             	lgdtl  (%eax)
}
80107b00:	c9                   	leave  
80107b01:	c3                   	ret    
80107b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b10:	a1 64 60 11 80       	mov    0x80116064,%eax
80107b15:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b1a:	0f 22 d8             	mov    %eax,%cr3
}
80107b1d:	c3                   	ret    
80107b1e:	66 90                	xchg   %ax,%ax

80107b20 <switchuvm>:
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	57                   	push   %edi
80107b24:	56                   	push   %esi
80107b25:	53                   	push   %ebx
80107b26:	83 ec 1c             	sub    $0x1c,%esp
80107b29:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107b2c:	85 f6                	test   %esi,%esi
80107b2e:	0f 84 cb 00 00 00    	je     80107bff <switchuvm+0xdf>
  if(p->kstack == 0)
80107b34:	8b 46 08             	mov    0x8(%esi),%eax
80107b37:	85 c0                	test   %eax,%eax
80107b39:	0f 84 da 00 00 00    	je     80107c19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107b3f:	8b 46 04             	mov    0x4(%esi),%eax
80107b42:	85 c0                	test   %eax,%eax
80107b44:	0f 84 c2 00 00 00    	je     80107c0c <switchuvm+0xec>
  pushcli();
80107b4a:	e8 41 da ff ff       	call   80105590 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b4f:	e8 dc ce ff ff       	call   80104a30 <mycpu>
80107b54:	89 c3                	mov    %eax,%ebx
80107b56:	e8 d5 ce ff ff       	call   80104a30 <mycpu>
80107b5b:	89 c7                	mov    %eax,%edi
80107b5d:	e8 ce ce ff ff       	call   80104a30 <mycpu>
80107b62:	83 c7 08             	add    $0x8,%edi
80107b65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b68:	e8 c3 ce ff ff       	call   80104a30 <mycpu>
80107b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b70:	ba 67 00 00 00       	mov    $0x67,%edx
80107b75:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107b7c:	83 c0 08             	add    $0x8,%eax
80107b7f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b86:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b8b:	83 c1 08             	add    $0x8,%ecx
80107b8e:	c1 e8 18             	shr    $0x18,%eax
80107b91:	c1 e9 10             	shr    $0x10,%ecx
80107b94:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107b9a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107ba0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107ba5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107bb1:	e8 7a ce ff ff       	call   80104a30 <mycpu>
80107bb6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bbd:	e8 6e ce ff ff       	call   80104a30 <mycpu>
80107bc2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107bc6:	8b 5e 08             	mov    0x8(%esi),%ebx
80107bc9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bcf:	e8 5c ce ff ff       	call   80104a30 <mycpu>
80107bd4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107bd7:	e8 54 ce ff ff       	call   80104a30 <mycpu>
80107bdc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107be0:	b8 28 00 00 00       	mov    $0x28,%eax
80107be5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107be8:	8b 46 04             	mov    0x4(%esi),%eax
80107beb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bf0:	0f 22 d8             	mov    %eax,%cr3
}
80107bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bf6:	5b                   	pop    %ebx
80107bf7:	5e                   	pop    %esi
80107bf8:	5f                   	pop    %edi
80107bf9:	5d                   	pop    %ebp
  popcli();
80107bfa:	e9 e1 d9 ff ff       	jmp    801055e0 <popcli>
    panic("switchuvm: no process");
80107bff:	83 ec 0c             	sub    $0xc,%esp
80107c02:	68 ce 8b 10 80       	push   $0x80108bce
80107c07:	e8 54 88 ff ff       	call   80100460 <panic>
    panic("switchuvm: no pgdir");
80107c0c:	83 ec 0c             	sub    $0xc,%esp
80107c0f:	68 f9 8b 10 80       	push   $0x80108bf9
80107c14:	e8 47 88 ff ff       	call   80100460 <panic>
    panic("switchuvm: no kstack");
80107c19:	83 ec 0c             	sub    $0xc,%esp
80107c1c:	68 e4 8b 10 80       	push   $0x80108be4
80107c21:	e8 3a 88 ff ff       	call   80100460 <panic>
80107c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c2d:	8d 76 00             	lea    0x0(%esi),%esi

80107c30 <inituvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 1c             	sub    $0x1c,%esp
80107c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c3c:	8b 75 10             	mov    0x10(%ebp),%esi
80107c3f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107c45:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107c4b:	77 4b                	ja     80107c98 <inituvm+0x68>
  mem = kalloc();
80107c4d:	e8 6e bb ff ff       	call   801037c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107c52:	83 ec 04             	sub    $0x4,%esp
80107c55:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107c5a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c5c:	6a 00                	push   $0x0
80107c5e:	50                   	push   %eax
80107c5f:	e8 3c db ff ff       	call   801057a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c64:	58                   	pop    %eax
80107c65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c6b:	5a                   	pop    %edx
80107c6c:	6a 06                	push   $0x6
80107c6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c73:	31 d2                	xor    %edx,%edx
80107c75:	50                   	push   %eax
80107c76:	89 f8                	mov    %edi,%eax
80107c78:	e8 13 fd ff ff       	call   80107990 <mappages>
  memmove(mem, init, sz);
80107c7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c80:	89 75 10             	mov    %esi,0x10(%ebp)
80107c83:	83 c4 10             	add    $0x10,%esp
80107c86:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107c89:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c8f:	5b                   	pop    %ebx
80107c90:	5e                   	pop    %esi
80107c91:	5f                   	pop    %edi
80107c92:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107c93:	e9 a8 db ff ff       	jmp    80105840 <memmove>
    panic("inituvm: more than a page");
80107c98:	83 ec 0c             	sub    $0xc,%esp
80107c9b:	68 0d 8c 10 80       	push   $0x80108c0d
80107ca0:	e8 bb 87 ff ff       	call   80100460 <panic>
80107ca5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107cb0 <loaduvm>:
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	57                   	push   %edi
80107cb4:	56                   	push   %esi
80107cb5:	53                   	push   %ebx
80107cb6:	83 ec 1c             	sub    $0x1c,%esp
80107cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cbc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107cbf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107cc4:	0f 85 bb 00 00 00    	jne    80107d85 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107cca:	01 f0                	add    %esi,%eax
80107ccc:	89 f3                	mov    %esi,%ebx
80107cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cd1:	8b 45 14             	mov    0x14(%ebp),%eax
80107cd4:	01 f0                	add    %esi,%eax
80107cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107cd9:	85 f6                	test   %esi,%esi
80107cdb:	0f 84 87 00 00 00    	je     80107d68 <loaduvm+0xb8>
80107ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107ceb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107cee:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107cf0:	89 c2                	mov    %eax,%edx
80107cf2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107cf5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107cf8:	f6 c2 01             	test   $0x1,%dl
80107cfb:	75 13                	jne    80107d10 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107cfd:	83 ec 0c             	sub    $0xc,%esp
80107d00:	68 27 8c 10 80       	push   $0x80108c27
80107d05:	e8 56 87 ff ff       	call   80100460 <panic>
80107d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107d10:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d13:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107d19:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d1e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d25:	85 c0                	test   %eax,%eax
80107d27:	74 d4                	je     80107cfd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107d29:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107d2e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107d33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107d38:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107d3e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d41:	29 d9                	sub    %ebx,%ecx
80107d43:	05 00 00 00 80       	add    $0x80000000,%eax
80107d48:	57                   	push   %edi
80107d49:	51                   	push   %ecx
80107d4a:	50                   	push   %eax
80107d4b:	ff 75 10             	push   0x10(%ebp)
80107d4e:	e8 7d ae ff ff       	call   80102bd0 <readi>
80107d53:	83 c4 10             	add    $0x10,%esp
80107d56:	39 f8                	cmp    %edi,%eax
80107d58:	75 1e                	jne    80107d78 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107d5a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107d60:	89 f0                	mov    %esi,%eax
80107d62:	29 d8                	sub    %ebx,%eax
80107d64:	39 c6                	cmp    %eax,%esi
80107d66:	77 80                	ja     80107ce8 <loaduvm+0x38>
}
80107d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d6b:	31 c0                	xor    %eax,%eax
}
80107d6d:	5b                   	pop    %ebx
80107d6e:	5e                   	pop    %esi
80107d6f:	5f                   	pop    %edi
80107d70:	5d                   	pop    %ebp
80107d71:	c3                   	ret    
80107d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d80:	5b                   	pop    %ebx
80107d81:	5e                   	pop    %esi
80107d82:	5f                   	pop    %edi
80107d83:	5d                   	pop    %ebp
80107d84:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107d85:	83 ec 0c             	sub    $0xc,%esp
80107d88:	68 c8 8c 10 80       	push   $0x80108cc8
80107d8d:	e8 ce 86 ff ff       	call   80100460 <panic>
80107d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107da0 <allocuvm>:
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	57                   	push   %edi
80107da4:	56                   	push   %esi
80107da5:	53                   	push   %ebx
80107da6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107da9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107dac:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107daf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107db2:	85 c0                	test   %eax,%eax
80107db4:	0f 88 b6 00 00 00    	js     80107e70 <allocuvm+0xd0>
  if(newsz < oldsz)
80107dba:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107dc0:	0f 82 9a 00 00 00    	jb     80107e60 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107dc6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107dcc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107dd2:	39 75 10             	cmp    %esi,0x10(%ebp)
80107dd5:	77 44                	ja     80107e1b <allocuvm+0x7b>
80107dd7:	e9 87 00 00 00       	jmp    80107e63 <allocuvm+0xc3>
80107ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107de0:	83 ec 04             	sub    $0x4,%esp
80107de3:	68 00 10 00 00       	push   $0x1000
80107de8:	6a 00                	push   $0x0
80107dea:	50                   	push   %eax
80107deb:	e8 b0 d9 ff ff       	call   801057a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107df0:	58                   	pop    %eax
80107df1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107df7:	5a                   	pop    %edx
80107df8:	6a 06                	push   $0x6
80107dfa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107dff:	89 f2                	mov    %esi,%edx
80107e01:	50                   	push   %eax
80107e02:	89 f8                	mov    %edi,%eax
80107e04:	e8 87 fb ff ff       	call   80107990 <mappages>
80107e09:	83 c4 10             	add    $0x10,%esp
80107e0c:	85 c0                	test   %eax,%eax
80107e0e:	78 78                	js     80107e88 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107e10:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e16:	39 75 10             	cmp    %esi,0x10(%ebp)
80107e19:	76 48                	jbe    80107e63 <allocuvm+0xc3>
    mem = kalloc();
80107e1b:	e8 a0 b9 ff ff       	call   801037c0 <kalloc>
80107e20:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107e22:	85 c0                	test   %eax,%eax
80107e24:	75 ba                	jne    80107de0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107e26:	83 ec 0c             	sub    $0xc,%esp
80107e29:	68 45 8c 10 80       	push   $0x80108c45
80107e2e:	e8 ad 89 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80107e33:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e36:	83 c4 10             	add    $0x10,%esp
80107e39:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e3c:	74 32                	je     80107e70 <allocuvm+0xd0>
80107e3e:	8b 55 10             	mov    0x10(%ebp),%edx
80107e41:	89 c1                	mov    %eax,%ecx
80107e43:	89 f8                	mov    %edi,%eax
80107e45:	e8 96 fa ff ff       	call   801078e0 <deallocuvm.part.0>
      return 0;
80107e4a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e57:	5b                   	pop    %ebx
80107e58:	5e                   	pop    %esi
80107e59:	5f                   	pop    %edi
80107e5a:	5d                   	pop    %ebp
80107e5b:	c3                   	ret    
80107e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e69:	5b                   	pop    %ebx
80107e6a:	5e                   	pop    %esi
80107e6b:	5f                   	pop    %edi
80107e6c:	5d                   	pop    %ebp
80107e6d:	c3                   	ret    
80107e6e:	66 90                	xchg   %ax,%ax
    return 0;
80107e70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e7d:	5b                   	pop    %ebx
80107e7e:	5e                   	pop    %esi
80107e7f:	5f                   	pop    %edi
80107e80:	5d                   	pop    %ebp
80107e81:	c3                   	ret    
80107e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107e88:	83 ec 0c             	sub    $0xc,%esp
80107e8b:	68 5d 8c 10 80       	push   $0x80108c5d
80107e90:	e8 4b 89 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80107e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e98:	83 c4 10             	add    $0x10,%esp
80107e9b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e9e:	74 0c                	je     80107eac <allocuvm+0x10c>
80107ea0:	8b 55 10             	mov    0x10(%ebp),%edx
80107ea3:	89 c1                	mov    %eax,%ecx
80107ea5:	89 f8                	mov    %edi,%eax
80107ea7:	e8 34 fa ff ff       	call   801078e0 <deallocuvm.part.0>
      kfree(mem);
80107eac:	83 ec 0c             	sub    $0xc,%esp
80107eaf:	53                   	push   %ebx
80107eb0:	e8 4b b7 ff ff       	call   80103600 <kfree>
      return 0;
80107eb5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107ebc:	83 c4 10             	add    $0x10,%esp
}
80107ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ec5:	5b                   	pop    %ebx
80107ec6:	5e                   	pop    %esi
80107ec7:	5f                   	pop    %edi
80107ec8:	5d                   	pop    %ebp
80107ec9:	c3                   	ret    
80107eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ed0 <deallocuvm>:
{
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
80107ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ed6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107edc:	39 d1                	cmp    %edx,%ecx
80107ede:	73 10                	jae    80107ef0 <deallocuvm+0x20>
}
80107ee0:	5d                   	pop    %ebp
80107ee1:	e9 fa f9 ff ff       	jmp    801078e0 <deallocuvm.part.0>
80107ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eed:	8d 76 00             	lea    0x0(%esi),%esi
80107ef0:	89 d0                	mov    %edx,%eax
80107ef2:	5d                   	pop    %ebp
80107ef3:	c3                   	ret    
80107ef4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eff:	90                   	nop

80107f00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	57                   	push   %edi
80107f04:	56                   	push   %esi
80107f05:	53                   	push   %ebx
80107f06:	83 ec 0c             	sub    $0xc,%esp
80107f09:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107f0c:	85 f6                	test   %esi,%esi
80107f0e:	74 59                	je     80107f69 <freevm+0x69>
  if(newsz >= oldsz)
80107f10:	31 c9                	xor    %ecx,%ecx
80107f12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107f17:	89 f0                	mov    %esi,%eax
80107f19:	89 f3                	mov    %esi,%ebx
80107f1b:	e8 c0 f9 ff ff       	call   801078e0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107f26:	eb 0f                	jmp    80107f37 <freevm+0x37>
80107f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f2f:	90                   	nop
80107f30:	83 c3 04             	add    $0x4,%ebx
80107f33:	39 df                	cmp    %ebx,%edi
80107f35:	74 23                	je     80107f5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107f37:	8b 03                	mov    (%ebx),%eax
80107f39:	a8 01                	test   $0x1,%al
80107f3b:	74 f3                	je     80107f30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107f42:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f45:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f48:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107f4d:	50                   	push   %eax
80107f4e:	e8 ad b6 ff ff       	call   80103600 <kfree>
80107f53:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f56:	39 df                	cmp    %ebx,%edi
80107f58:	75 dd                	jne    80107f37 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107f5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f60:	5b                   	pop    %ebx
80107f61:	5e                   	pop    %esi
80107f62:	5f                   	pop    %edi
80107f63:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107f64:	e9 97 b6 ff ff       	jmp    80103600 <kfree>
    panic("freevm: no pgdir");
80107f69:	83 ec 0c             	sub    $0xc,%esp
80107f6c:	68 79 8c 10 80       	push   $0x80108c79
80107f71:	e8 ea 84 ff ff       	call   80100460 <panic>
80107f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f7d:	8d 76 00             	lea    0x0(%esi),%esi

80107f80 <setupkvm>:
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	56                   	push   %esi
80107f84:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107f85:	e8 36 b8 ff ff       	call   801037c0 <kalloc>
80107f8a:	89 c6                	mov    %eax,%esi
80107f8c:	85 c0                	test   %eax,%eax
80107f8e:	74 42                	je     80107fd2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107f90:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f93:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107f98:	68 00 10 00 00       	push   $0x1000
80107f9d:	6a 00                	push   $0x0
80107f9f:	50                   	push   %eax
80107fa0:	e8 fb d7 ff ff       	call   801057a0 <memset>
80107fa5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107fa8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107fab:	83 ec 08             	sub    $0x8,%esp
80107fae:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107fb1:	ff 73 0c             	push   0xc(%ebx)
80107fb4:	8b 13                	mov    (%ebx),%edx
80107fb6:	50                   	push   %eax
80107fb7:	29 c1                	sub    %eax,%ecx
80107fb9:	89 f0                	mov    %esi,%eax
80107fbb:	e8 d0 f9 ff ff       	call   80107990 <mappages>
80107fc0:	83 c4 10             	add    $0x10,%esp
80107fc3:	85 c0                	test   %eax,%eax
80107fc5:	78 19                	js     80107fe0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107fc7:	83 c3 10             	add    $0x10,%ebx
80107fca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107fd0:	75 d6                	jne    80107fa8 <setupkvm+0x28>
}
80107fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fd5:	89 f0                	mov    %esi,%eax
80107fd7:	5b                   	pop    %ebx
80107fd8:	5e                   	pop    %esi
80107fd9:	5d                   	pop    %ebp
80107fda:	c3                   	ret    
80107fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fdf:	90                   	nop
      freevm(pgdir);
80107fe0:	83 ec 0c             	sub    $0xc,%esp
80107fe3:	56                   	push   %esi
      return 0;
80107fe4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107fe6:	e8 15 ff ff ff       	call   80107f00 <freevm>
      return 0;
80107feb:	83 c4 10             	add    $0x10,%esp
}
80107fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ff1:	89 f0                	mov    %esi,%eax
80107ff3:	5b                   	pop    %ebx
80107ff4:	5e                   	pop    %esi
80107ff5:	5d                   	pop    %ebp
80107ff6:	c3                   	ret    
80107ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ffe:	66 90                	xchg   %ax,%ax

80108000 <kvmalloc>:
{
80108000:	55                   	push   %ebp
80108001:	89 e5                	mov    %esp,%ebp
80108003:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108006:	e8 75 ff ff ff       	call   80107f80 <setupkvm>
8010800b:	a3 64 60 11 80       	mov    %eax,0x80116064
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108010:	05 00 00 00 80       	add    $0x80000000,%eax
80108015:	0f 22 d8             	mov    %eax,%cr3
}
80108018:	c9                   	leave  
80108019:	c3                   	ret    
8010801a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108020 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108020:	55                   	push   %ebp
80108021:	89 e5                	mov    %esp,%ebp
80108023:	83 ec 08             	sub    $0x8,%esp
80108026:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108029:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010802c:	89 c1                	mov    %eax,%ecx
8010802e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108031:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108034:	f6 c2 01             	test   $0x1,%dl
80108037:	75 17                	jne    80108050 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108039:	83 ec 0c             	sub    $0xc,%esp
8010803c:	68 8a 8c 10 80       	push   $0x80108c8a
80108041:	e8 1a 84 ff ff       	call   80100460 <panic>
80108046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010804d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108050:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108053:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108059:	25 fc 0f 00 00       	and    $0xffc,%eax
8010805e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108065:	85 c0                	test   %eax,%eax
80108067:	74 d0                	je     80108039 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108069:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010806c:	c9                   	leave  
8010806d:	c3                   	ret    
8010806e:	66 90                	xchg   %ax,%ax

80108070 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108070:	55                   	push   %ebp
80108071:	89 e5                	mov    %esp,%ebp
80108073:	57                   	push   %edi
80108074:	56                   	push   %esi
80108075:	53                   	push   %ebx
80108076:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108079:	e8 02 ff ff ff       	call   80107f80 <setupkvm>
8010807e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108081:	85 c0                	test   %eax,%eax
80108083:	0f 84 bd 00 00 00    	je     80108146 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010808c:	85 c9                	test   %ecx,%ecx
8010808e:	0f 84 b2 00 00 00    	je     80108146 <copyuvm+0xd6>
80108094:	31 f6                	xor    %esi,%esi
80108096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010809d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801080a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801080a3:	89 f0                	mov    %esi,%eax
801080a5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801080a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801080ab:	a8 01                	test   $0x1,%al
801080ad:	75 11                	jne    801080c0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801080af:	83 ec 0c             	sub    $0xc,%esp
801080b2:	68 94 8c 10 80       	push   $0x80108c94
801080b7:	e8 a4 83 ff ff       	call   80100460 <panic>
801080bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801080c0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801080c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801080c7:	c1 ea 0a             	shr    $0xa,%edx
801080ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801080d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080d7:	85 c0                	test   %eax,%eax
801080d9:	74 d4                	je     801080af <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801080db:	8b 00                	mov    (%eax),%eax
801080dd:	a8 01                	test   $0x1,%al
801080df:	0f 84 9f 00 00 00    	je     80108184 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801080e5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801080e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801080ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801080ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801080f5:	e8 c6 b6 ff ff       	call   801037c0 <kalloc>
801080fa:	89 c3                	mov    %eax,%ebx
801080fc:	85 c0                	test   %eax,%eax
801080fe:	74 64                	je     80108164 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108100:	83 ec 04             	sub    $0x4,%esp
80108103:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108109:	68 00 10 00 00       	push   $0x1000
8010810e:	57                   	push   %edi
8010810f:	50                   	push   %eax
80108110:	e8 2b d7 ff ff       	call   80105840 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108115:	58                   	pop    %eax
80108116:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010811c:	5a                   	pop    %edx
8010811d:	ff 75 e4             	push   -0x1c(%ebp)
80108120:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108125:	89 f2                	mov    %esi,%edx
80108127:	50                   	push   %eax
80108128:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010812b:	e8 60 f8 ff ff       	call   80107990 <mappages>
80108130:	83 c4 10             	add    $0x10,%esp
80108133:	85 c0                	test   %eax,%eax
80108135:	78 21                	js     80108158 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108137:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010813d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108140:	0f 87 5a ff ff ff    	ja     801080a0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108146:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010814c:	5b                   	pop    %ebx
8010814d:	5e                   	pop    %esi
8010814e:	5f                   	pop    %edi
8010814f:	5d                   	pop    %ebp
80108150:	c3                   	ret    
80108151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108158:	83 ec 0c             	sub    $0xc,%esp
8010815b:	53                   	push   %ebx
8010815c:	e8 9f b4 ff ff       	call   80103600 <kfree>
      goto bad;
80108161:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108164:	83 ec 0c             	sub    $0xc,%esp
80108167:	ff 75 e0             	push   -0x20(%ebp)
8010816a:	e8 91 fd ff ff       	call   80107f00 <freevm>
  return 0;
8010816f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108176:	83 c4 10             	add    $0x10,%esp
}
80108179:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010817c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010817f:	5b                   	pop    %ebx
80108180:	5e                   	pop    %esi
80108181:	5f                   	pop    %edi
80108182:	5d                   	pop    %ebp
80108183:	c3                   	ret    
      panic("copyuvm: page not present");
80108184:	83 ec 0c             	sub    $0xc,%esp
80108187:	68 ae 8c 10 80       	push   $0x80108cae
8010818c:	e8 cf 82 ff ff       	call   80100460 <panic>
80108191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010819f:	90                   	nop

801081a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801081a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801081a9:	89 c1                	mov    %eax,%ecx
801081ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801081ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801081b1:	f6 c2 01             	test   $0x1,%dl
801081b4:	0f 84 00 01 00 00    	je     801082ba <uva2ka.cold>
  return &pgtab[PTX(va)];
801081ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801081c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801081c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801081c9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801081d0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801081d7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081da:	05 00 00 00 80       	add    $0x80000000,%eax
801081df:	83 fa 05             	cmp    $0x5,%edx
801081e2:	ba 00 00 00 00       	mov    $0x0,%edx
801081e7:	0f 45 c2             	cmovne %edx,%eax
}
801081ea:	c3                   	ret    
801081eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081ef:	90                   	nop

801081f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081f0:	55                   	push   %ebp
801081f1:	89 e5                	mov    %esp,%ebp
801081f3:	57                   	push   %edi
801081f4:	56                   	push   %esi
801081f5:	53                   	push   %ebx
801081f6:	83 ec 0c             	sub    $0xc,%esp
801081f9:	8b 75 14             	mov    0x14(%ebp),%esi
801081fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108202:	85 f6                	test   %esi,%esi
80108204:	75 51                	jne    80108257 <copyout+0x67>
80108206:	e9 a5 00 00 00       	jmp    801082b0 <copyout+0xc0>
8010820b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010820f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108210:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108216:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010821c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108222:	74 75                	je     80108299 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108224:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108226:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108229:	29 c3                	sub    %eax,%ebx
8010822b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108231:	39 f3                	cmp    %esi,%ebx
80108233:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108236:	29 f8                	sub    %edi,%eax
80108238:	83 ec 04             	sub    $0x4,%esp
8010823b:	01 c1                	add    %eax,%ecx
8010823d:	53                   	push   %ebx
8010823e:	52                   	push   %edx
8010823f:	51                   	push   %ecx
80108240:	e8 fb d5 ff ff       	call   80105840 <memmove>
    len -= n;
    buf += n;
80108245:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108248:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010824e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108251:	01 da                	add    %ebx,%edx
  while(len > 0){
80108253:	29 de                	sub    %ebx,%esi
80108255:	74 59                	je     801082b0 <copyout+0xc0>
  if(*pde & PTE_P){
80108257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010825a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010825c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010825e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108261:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108267:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010826a:	f6 c1 01             	test   $0x1,%cl
8010826d:	0f 84 4e 00 00 00    	je     801082c1 <copyout.cold>
  return &pgtab[PTX(va)];
80108273:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108275:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010827b:	c1 eb 0c             	shr    $0xc,%ebx
8010827e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108284:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010828b:	89 d9                	mov    %ebx,%ecx
8010828d:	83 e1 05             	and    $0x5,%ecx
80108290:	83 f9 05             	cmp    $0x5,%ecx
80108293:	0f 84 77 ff ff ff    	je     80108210 <copyout+0x20>
  }
  return 0;
}
80108299:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010829c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082a1:	5b                   	pop    %ebx
801082a2:	5e                   	pop    %esi
801082a3:	5f                   	pop    %edi
801082a4:	5d                   	pop    %ebp
801082a5:	c3                   	ret    
801082a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082ad:	8d 76 00             	lea    0x0(%esi),%esi
801082b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082b3:	31 c0                	xor    %eax,%eax
}
801082b5:	5b                   	pop    %ebx
801082b6:	5e                   	pop    %esi
801082b7:	5f                   	pop    %edi
801082b8:	5d                   	pop    %ebp
801082b9:	c3                   	ret    

801082ba <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801082ba:	a1 00 00 00 00       	mov    0x0,%eax
801082bf:	0f 0b                	ud2    

801082c1 <copyout.cold>:
801082c1:	a1 00 00 00 00       	mov    0x0,%eax
801082c6:	0f 0b                	ud2    
