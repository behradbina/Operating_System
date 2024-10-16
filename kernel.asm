
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
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
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 71 10 80       	push   $0x801071a0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 85 43 00 00       	call   801043e0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
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
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 71 10 80       	push   $0x801071a7
80100097:	50                   	push   %eax
80100098:	e8 13 42 00 00       	call   801042b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 e7 44 00 00       	call   801045d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
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
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
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
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 09 44 00 00       	call   80104570 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 41 00 00       	call   801042f0 <acquiresleep>
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
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
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
801001a1:	68 ae 71 10 80       	push   $0x801071ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
801001be:	e8 cd 41 00 00       	call   80104390 <holdingsleep>
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
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 71 10 80       	push   $0x801071bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

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
801001ff:	e8 8c 41 00 00       	call   80104390 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 41 00 00       	call   80104350 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 b0 43 00 00       	call   801045d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 02 43 00 00       	jmp    80104570 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 c6 71 10 80       	push   $0x801071c6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
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
80100294:	e8 17 16 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 2b 43 00 00       	call   801045d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
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
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 7e 3d 00 00       	call   80104050 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 36 00 00       	call   80103990 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 75 42 00 00       	call   80104570 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 14 00 00       	call   801017d0 <ilock>
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
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
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
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 1f 42 00 00       	call   80104570 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 14 00 00       	call   801017d0 <ilock>
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
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 71 10 80       	push   $0x801071cd
801003a7:	e8 34 03 00 00       	call   801006e0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 2b 03 00 00       	call   801006e0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 4f 76 10 80 	movl   $0x8010764f,(%esp)
801003bc:	e8 1f 03 00 00       	call   801006e0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 40 00 00       	call   80104400 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 71 10 80       	push   $0x801071e1
801003dd:	e8 fe 02 00 00       	call   801006e0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 ec 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c6                	mov    %eax,%esi
8010041e:	50                   	push   %eax
8010041f:	e8 bc 58 00 00       	call   80105ce0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100431:	89 da                	mov    %ebx,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 da                	mov    %ebx,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fe 0a             	cmp    $0xa,%esi
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 58 50             	lea    0x50(%eax),%ebx
  if(pos < 0 || pos > 25*80)
80100465:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010046b:	0f 87 5f 01 00 00    	ja     801005d0 <consputc.part.0+0x1d0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100477:	0f 8f e3 00 00 00    	jg     80100560 <consputc.part.0+0x160>
  outb(CRTPORT+1, pos>>8);
8010047d:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100480:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100482:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
80100489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
801004a5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004aa:	89 da                	mov    %ebx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	89 f8                	mov    %edi,%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(c==RIGHT_ARROW){
801004c8:	81 fe 4b e0 00 00    	cmp    $0xe04b,%esi
801004ce:	0f 84 ec 00 00 00    	je     801005c0 <consputc.part.0+0x1c0>
     int previous_pos=pos-1;
801004d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  else if(c==LEFT_ARROW){
801004d7:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
801004dd:	74 86                	je     80100465 <consputc.part.0+0x65>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004df:	89 f1                	mov    %esi,%ecx
801004e1:	8d 58 01             	lea    0x1(%eax),%ebx
801004e4:	0f b6 f1             	movzbl %cl,%esi
801004e7:	66 81 ce 00 07       	or     $0x700,%si
801004ec:	66 89 b4 00 00 80 0b 	mov    %si,-0x7ff48000(%eax,%eax,1)
801004f3:	80 
801004f4:	e9 6c ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
801004f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	be d4 03 00 00       	mov    $0x3d4,%esi
80100508:	6a 08                	push   $0x8
8010050a:	e8 d1 57 00 00       	call   80105ce0 <uartputc>
8010050f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100516:	e8 c5 57 00 00       	call   80105ce0 <uartputc>
8010051b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100522:	e8 b9 57 00 00       	call   80105ce0 <uartputc>
80100527:	b8 0e 00 00 00       	mov    $0xe,%eax
8010052c:	89 f2                	mov    %esi,%edx
8010052e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010052f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100534:	89 da                	mov    %ebx,%edx
80100536:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100537:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010053a:	89 f2                	mov    %esi,%edx
8010053c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100541:	c1 e1 08             	shl    $0x8,%ecx
80100544:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100545:	89 da                	mov    %ebx,%edx
80100547:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100548:	0f b6 d8             	movzbl %al,%ebx
   if(pos > 0) --pos;
8010054b:	83 c4 10             	add    $0x10,%esp
8010054e:	09 cb                	or     %ecx,%ebx
80100550:	74 56                	je     801005a8 <consputc.part.0+0x1a8>
80100552:	83 eb 01             	sub    $0x1,%ebx
80100555:	e9 0b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010055a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100563:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010056d:	68 60 0e 00 00       	push   $0xe60
80100572:	68 a0 80 0b 80       	push   $0x800b80a0
80100577:	68 00 80 0b 80       	push   $0x800b8000
8010057c:	e8 df 41 00 00       	call   80104760 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100581:	b8 80 07 00 00       	mov    $0x780,%eax
80100586:	83 c4 0c             	add    $0xc,%esp
80100589:	29 f8                	sub    %edi,%eax
8010058b:	01 c0                	add    %eax,%eax
8010058d:	50                   	push   %eax
8010058e:	6a 00                	push   $0x0
80100590:	56                   	push   %esi
80100591:	e8 3a 41 00 00       	call   801046d0 <memset>
  outb(CRTPORT+1, pos);
80100596:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010059a:	83 c4 10             	add    $0x10,%esp
8010059d:	e9 ea fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
801005a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005a8:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801005ac:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801005b1:	31 ff                	xor    %edi,%edi
801005b3:	e9 d4 fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
801005b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005bf:	00 
     int l=crt[--pos];
801005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
     crt[pos] = (l&0xff) | 0x0700;
801005c3:	c6 84 1b 01 80 0b 80 	movb   $0x7,-0x7ff47fff(%ebx,%ebx,1)
801005ca:	07 
801005cb:	e9 95 fe ff ff       	jmp    80100465 <consputc.part.0+0x65>
    panic("pos under/overflow");
801005d0:	83 ec 0c             	sub    $0xc,%esp
801005d3:	68 e5 71 10 80       	push   $0x801071e5
801005d8:	e8 a3 fd ff ff       	call   80100380 <panic>
801005dd:	8d 76 00             	lea    0x0(%esi),%esi

801005e0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 18             	sub    $0x18,%esp
801005e9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ec:	ff 75 08             	push   0x8(%ebp)
801005ef:	e8 bc 12 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
801005f4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005fb:	e8 d0 3f 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++)
80100600:	83 c4 10             	add    $0x10,%esp
80100603:	85 f6                	test   %esi,%esi
80100605:	7e 25                	jle    8010062c <consolewrite+0x4c>
80100607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010060a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010060d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
80100613:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100616:	85 d2                	test   %edx,%edx
80100618:	74 06                	je     80100620 <consolewrite+0x40>
  asm volatile("cli");
8010061a:	fa                   	cli
    for(;;)
8010061b:	eb fe                	jmp    8010061b <consolewrite+0x3b>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
80100620:	e8 db fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
80100625:	83 c3 01             	add    $0x1,%ebx
80100628:	39 fb                	cmp    %edi,%ebx
8010062a:	75 e1                	jne    8010060d <consolewrite+0x2d>
  release(&cons.lock);
8010062c:	83 ec 0c             	sub    $0xc,%esp
8010062f:	68 20 ef 10 80       	push   $0x8010ef20
80100634:	e8 37 3f 00 00       	call   80104570 <release>
  ilock(ip);
80100639:	58                   	pop    %eax
8010063a:	ff 75 08             	push   0x8(%ebp)
8010063d:	e8 8e 11 00 00       	call   801017d0 <ilock>

  return n;
}
80100642:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100645:	89 f0                	mov    %esi,%eax
80100647:	5b                   	pop    %ebx
80100648:	5e                   	pop    %esi
80100649:	5f                   	pop    %edi
8010064a:	5d                   	pop    %ebp
8010064b:	c3                   	ret
8010064c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100650 <printint>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	89 d3                	mov    %edx,%ebx
80100658:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010065b:	85 c0                	test   %eax,%eax
8010065d:	79 05                	jns    80100664 <printint+0x14>
8010065f:	83 e1 01             	and    $0x1,%ecx
80100662:	75 64                	jne    801006c8 <printint+0x78>
    x = xx;
80100664:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010066b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010066d:	31 f6                	xor    %esi,%esi
8010066f:	90                   	nop
    buf[i++] = digits[x % base];
80100670:	89 c8                	mov    %ecx,%eax
80100672:	31 d2                	xor    %edx,%edx
80100674:	89 f7                	mov    %esi,%edi
80100676:	f7 f3                	div    %ebx
80100678:	8d 76 01             	lea    0x1(%esi),%esi
8010067b:	0f b6 92 a0 76 10 80 	movzbl -0x7fef8960(%edx),%edx
80100682:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100686:	89 ca                	mov    %ecx,%edx
80100688:	89 c1                	mov    %eax,%ecx
8010068a:	39 da                	cmp    %ebx,%edx
8010068c:	73 e2                	jae    80100670 <printint+0x20>
  if(sign)
8010068e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100691:	85 c9                	test   %ecx,%ecx
80100693:	74 07                	je     8010069c <printint+0x4c>
    buf[i++] = '-';
80100695:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010069a:	89 f7                	mov    %esi,%edi
8010069c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010069f:	01 df                	add    %ebx,%edi
  if(panicked){
801006a1:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
801006a7:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
801006aa:	85 d2                	test   %edx,%edx
801006ac:	74 0a                	je     801006b8 <printint+0x68>
801006ae:	fa                   	cli
    for(;;)
801006af:	eb fe                	jmp    801006af <printint+0x5f>
801006b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006b8:	e8 43 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
801006bd:	8d 47 ff             	lea    -0x1(%edi),%eax
801006c0:	39 df                	cmp    %ebx,%edi
801006c2:	74 11                	je     801006d5 <printint+0x85>
801006c4:	89 c7                	mov    %eax,%edi
801006c6:	eb d9                	jmp    801006a1 <printint+0x51>
    x = -xx;
801006c8:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
801006ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006d1:	89 c1                	mov    %eax,%ecx
801006d3:	eb 98                	jmp    8010066d <printint+0x1d>
}
801006d5:	83 c4 2c             	add    $0x2c,%esp
801006d8:	5b                   	pop    %ebx
801006d9:	5e                   	pop    %esi
801006da:	5f                   	pop    %edi
801006db:	5d                   	pop    %ebp
801006dc:	c3                   	ret
801006dd:	8d 76 00             	lea    0x0(%esi),%esi

801006e0 <cprintf>:
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	57                   	push   %edi
801006e4:	56                   	push   %esi
801006e5:	53                   	push   %ebx
801006e6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006e9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006ef:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006f2:	85 ff                	test   %edi,%edi
801006f4:	0f 85 06 01 00 00    	jne    80100800 <cprintf+0x120>
  if (fmt == 0)
801006fa:	85 f6                	test   %esi,%esi
801006fc:	0f 84 b7 01 00 00    	je     801008b9 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	0f b6 06             	movzbl (%esi),%eax
80100705:	85 c0                	test   %eax,%eax
80100707:	74 5f                	je     80100768 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
80100709:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010070f:	31 db                	xor    %ebx,%ebx
80100711:	89 d7                	mov    %edx,%edi
    if(c != '%'){
80100713:	83 f8 25             	cmp    $0x25,%eax
80100716:	75 58                	jne    80100770 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100718:	83 c3 01             	add    $0x1,%ebx
8010071b:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
8010071f:	85 c9                	test   %ecx,%ecx
80100721:	74 3a                	je     8010075d <cprintf+0x7d>
    switch(c){
80100723:	83 f9 70             	cmp    $0x70,%ecx
80100726:	0f 84 b4 00 00 00    	je     801007e0 <cprintf+0x100>
8010072c:	7f 72                	jg     801007a0 <cprintf+0xc0>
8010072e:	83 f9 25             	cmp    $0x25,%ecx
80100731:	74 4d                	je     80100780 <cprintf+0xa0>
80100733:	83 f9 64             	cmp    $0x64,%ecx
80100736:	75 76                	jne    801007ae <cprintf+0xce>
      printint(*argp++, 10, 1);
80100738:	8d 47 04             	lea    0x4(%edi),%eax
8010073b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100740:	ba 0a 00 00 00       	mov    $0xa,%edx
80100745:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100748:	8b 07                	mov    (%edi),%eax
8010074a:	e8 01 ff ff ff       	call   80100650 <printint>
8010074f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100752:	83 c3 01             	add    $0x1,%ebx
80100755:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100759:	85 c0                	test   %eax,%eax
8010075b:	75 b6                	jne    80100713 <cprintf+0x33>
8010075d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100760:	85 ff                	test   %edi,%edi
80100762:	0f 85 bb 00 00 00    	jne    80100823 <cprintf+0x143>
}
80100768:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010076b:	5b                   	pop    %ebx
8010076c:	5e                   	pop    %esi
8010076d:	5f                   	pop    %edi
8010076e:	5d                   	pop    %ebp
8010076f:	c3                   	ret
  if(panicked){
80100770:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100776:	85 c9                	test   %ecx,%ecx
80100778:	74 19                	je     80100793 <cprintf+0xb3>
8010077a:	fa                   	cli
    for(;;)
8010077b:	eb fe                	jmp    8010077b <cprintf+0x9b>
8010077d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100780:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100786:	85 c9                	test   %ecx,%ecx
80100788:	0f 85 f2 00 00 00    	jne    80100880 <cprintf+0x1a0>
8010078e:	b8 25 00 00 00       	mov    $0x25,%eax
80100793:	e8 68 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100798:	eb b8                	jmp    80100752 <cprintf+0x72>
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
801007a0:	83 f9 73             	cmp    $0x73,%ecx
801007a3:	0f 84 8f 00 00 00    	je     80100838 <cprintf+0x158>
801007a9:	83 f9 78             	cmp    $0x78,%ecx
801007ac:	74 32                	je     801007e0 <cprintf+0x100>
  if(panicked){
801007ae:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801007b4:	85 d2                	test   %edx,%edx
801007b6:	0f 85 b8 00 00 00    	jne    80100874 <cprintf+0x194>
801007bc:	b8 25 00 00 00       	mov    $0x25,%eax
801007c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801007c4:	e8 37 fc ff ff       	call   80100400 <consputc.part.0>
801007c9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007ce:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007d1:	85 c0                	test   %eax,%eax
801007d3:	0f 84 cd 00 00 00    	je     801008a6 <cprintf+0x1c6>
801007d9:	fa                   	cli
    for(;;)
801007da:	eb fe                	jmp    801007da <cprintf+0xfa>
801007dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007e0:	8d 47 04             	lea    0x4(%edi),%eax
801007e3:	31 c9                	xor    %ecx,%ecx
801007e5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ed:	8b 07                	mov    (%edi),%eax
801007ef:	e8 5c fe ff ff       	call   80100650 <printint>
801007f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007f7:	e9 56 ff ff ff       	jmp    80100752 <cprintf+0x72>
801007fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ef 10 80       	push   $0x8010ef20
80100808:	e8 c3 3d 00 00       	call   801045d0 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 a1 00 00 00    	je     801008b9 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 e6 fe ff ff    	jne    80100709 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ef 10 80       	push   $0x8010ef20
8010082b:	e8 40 3d 00 00       	call   80104570 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 30 ff ff ff       	jmp    80100768 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100838:	8b 17                	mov    (%edi),%edx
8010083a:	8d 47 04             	lea    0x4(%edi),%eax
8010083d:	85 d2                	test   %edx,%edx
8010083f:	74 27                	je     80100868 <cprintf+0x188>
      for(; *s; s++)
80100841:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100844:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100846:	84 c9                	test   %cl,%cl
80100848:	74 68                	je     801008b2 <cprintf+0x1d2>
8010084a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010084d:	89 fb                	mov    %edi,%ebx
8010084f:	89 f7                	mov    %esi,%edi
80100851:	89 c6                	mov    %eax,%esi
80100853:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100856:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010085c:	85 d2                	test   %edx,%edx
8010085e:	74 28                	je     80100888 <cprintf+0x1a8>
80100860:	fa                   	cli
    for(;;)
80100861:	eb fe                	jmp    80100861 <cprintf+0x181>
80100863:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100868:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010086d:	bf f8 71 10 80       	mov    $0x801071f8,%edi
80100872:	eb d6                	jmp    8010084a <cprintf+0x16a>
80100874:	fa                   	cli
    for(;;)
80100875:	eb fe                	jmp    80100875 <cprintf+0x195>
80100877:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010087e:	00 
8010087f:	90                   	nop
80100880:	fa                   	cli
80100881:	eb fe                	jmp    80100881 <cprintf+0x1a1>
80100883:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100888:	e8 73 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010088d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100891:	83 c3 01             	add    $0x1,%ebx
80100894:	84 c0                	test   %al,%al
80100896:	75 be                	jne    80100856 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 ac fe ff ff       	jmp    80100752 <cprintf+0x72>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
      break;
801008ad:	e9 a0 fe ff ff       	jmp    80100752 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
801008b2:	89 c7                	mov    %eax,%edi
801008b4:	e9 99 fe ff ff       	jmp    80100752 <cprintf+0x72>
    panic("null fmt");
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 ff 71 10 80       	push   $0x801071ff
801008c1:	e8 ba fa ff ff       	call   80100380 <panic>
801008c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801008cd:	00 
801008ce:	66 90                	xchg   %ax,%ax

801008d0 <consoleintr>:
{
801008d0:	55                   	push   %ebp
801008d1:	89 e5                	mov    %esp,%ebp
801008d3:	57                   	push   %edi
  int c, doprocdump = 0;
801008d4:	31 ff                	xor    %edi,%edi
{
801008d6:	56                   	push   %esi
801008d7:	53                   	push   %ebx
801008d8:	83 ec 18             	sub    $0x18,%esp
801008db:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008de:	68 20 ef 10 80       	push   $0x8010ef20
801008e3:	e8 e8 3c 00 00       	call   801045d0 <acquire>
  while((c = getc()) >= 0){
801008e8:	83 c4 10             	add    $0x10,%esp
801008eb:	ff d6                	call   *%esi
801008ed:	89 c3                	mov    %eax,%ebx
801008ef:	85 c0                	test   %eax,%eax
801008f1:	78 22                	js     80100915 <consoleintr+0x45>
    switch(c){
801008f3:	83 fb 15             	cmp    $0x15,%ebx
801008f6:	74 47                	je     8010093f <consoleintr+0x6f>
801008f8:	7f 76                	jg     80100970 <consoleintr+0xa0>
801008fa:	83 fb 08             	cmp    $0x8,%ebx
801008fd:	74 76                	je     80100975 <consoleintr+0xa5>
801008ff:	83 fb 10             	cmp    $0x10,%ebx
80100902:	0f 85 f8 00 00 00    	jne    80100a00 <consoleintr+0x130>
  while((c = getc()) >= 0){
80100908:	ff d6                	call   *%esi
    switch(c){
8010090a:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
8010090f:	89 c3                	mov    %eax,%ebx
80100911:	85 c0                	test   %eax,%eax
80100913:	79 de                	jns    801008f3 <consoleintr+0x23>
  release(&cons.lock);
80100915:	83 ec 0c             	sub    $0xc,%esp
80100918:	68 20 ef 10 80       	push   $0x8010ef20
8010091d:	e8 4e 3c 00 00       	call   80104570 <release>
  if(doprocdump) {
80100922:	83 c4 10             	add    $0x10,%esp
80100925:	85 ff                	test   %edi,%edi
80100927:	0f 85 4b 01 00 00    	jne    80100a78 <consoleintr+0x1a8>
}
8010092d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100930:	5b                   	pop    %ebx
80100931:	5e                   	pop    %esi
80100932:	5f                   	pop    %edi
80100933:	5d                   	pop    %ebp
80100934:	c3                   	ret
80100935:	b8 00 01 00 00       	mov    $0x100,%eax
8010093a:	e8 c1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010093f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100944:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010094a:	74 9f                	je     801008eb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010094c:	83 e8 01             	sub    $0x1,%eax
8010094f:	89 c2                	mov    %eax,%edx
80100951:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100954:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010095b:	74 8e                	je     801008eb <consoleintr+0x1b>
  if(panicked){
8010095d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100963:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100968:	85 d2                	test   %edx,%edx
8010096a:	74 c9                	je     80100935 <consoleintr+0x65>
8010096c:	fa                   	cli
    for(;;)
8010096d:	eb fe                	jmp    8010096d <consoleintr+0x9d>
8010096f:	90                   	nop
    switch(c){
80100970:	83 fb 7f             	cmp    $0x7f,%ebx
80100973:	75 2b                	jne    801009a0 <consoleintr+0xd0>
      if(input.e != input.w){
80100975:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010097a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100980:	0f 84 65 ff ff ff    	je     801008eb <consoleintr+0x1b>
        input.e--;
80100986:	83 e8 01             	sub    $0x1,%eax
80100989:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010098e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100993:	85 c0                	test   %eax,%eax
80100995:	0f 84 ce 00 00 00    	je     80100a69 <consoleintr+0x199>
8010099b:	fa                   	cli
    for(;;)
8010099c:	eb fe                	jmp    8010099c <consoleintr+0xcc>
8010099e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009a5:	89 c2                	mov    %eax,%edx
801009a7:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009ad:	83 fa 7f             	cmp    $0x7f,%edx
801009b0:	0f 87 35 ff ff ff    	ja     801008eb <consoleintr+0x1b>
  if(panicked){
801009b6:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009bc:	8d 50 01             	lea    0x1(%eax),%edx
801009bf:	83 e0 7f             	and    $0x7f,%eax
801009c2:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801009c8:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
801009ce:	85 c9                	test   %ecx,%ecx
801009d0:	0f 85 ae 00 00 00    	jne    80100a84 <consoleintr+0x1b4>
801009d6:	89 d8                	mov    %ebx,%eax
801009d8:	e8 23 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009dd:	83 fb 0a             	cmp    $0xa,%ebx
801009e0:	74 68                	je     80100a4a <consoleintr+0x17a>
801009e2:	83 fb 04             	cmp    $0x4,%ebx
801009e5:	74 63                	je     80100a4a <consoleintr+0x17a>
801009e7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009ec:	83 e8 80             	sub    $0xffffff80,%eax
801009ef:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009f5:	0f 85 f0 fe ff ff    	jne    801008eb <consoleintr+0x1b>
801009fb:	eb 52                	jmp    80100a4f <consoleintr+0x17f>
801009fd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a00:	85 db                	test   %ebx,%ebx
80100a02:	0f 84 e3 fe ff ff    	je     801008eb <consoleintr+0x1b>
80100a08:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a0d:	89 c2                	mov    %eax,%edx
80100a0f:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a15:	83 fa 7f             	cmp    $0x7f,%edx
80100a18:	0f 87 cd fe ff ff    	ja     801008eb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a1e:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a21:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a27:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a2a:	83 fb 0d             	cmp    $0xd,%ebx
80100a2d:	75 93                	jne    801009c2 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a2f:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a35:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a3c:	85 c9                	test   %ecx,%ecx
80100a3e:	75 44                	jne    80100a84 <consoleintr+0x1b4>
80100a40:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a45:	e8 b6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a4a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a4f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a52:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a57:	68 00 ef 10 80       	push   $0x8010ef00
80100a5c:	e8 af 36 00 00       	call   80104110 <wakeup>
80100a61:	83 c4 10             	add    $0x10,%esp
80100a64:	e9 82 fe ff ff       	jmp    801008eb <consoleintr+0x1b>
80100a69:	b8 00 01 00 00       	mov    $0x100,%eax
80100a6e:	e8 8d f9 ff ff       	call   80100400 <consputc.part.0>
80100a73:	e9 73 fe ff ff       	jmp    801008eb <consoleintr+0x1b>
}
80100a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7b:	5b                   	pop    %ebx
80100a7c:	5e                   	pop    %esi
80100a7d:	5f                   	pop    %edi
80100a7e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a7f:	e9 6c 37 00 00       	jmp    801041f0 <procdump>
80100a84:	fa                   	cli
    for(;;)
80100a85:	eb fe                	jmp    80100a85 <consoleintr+0x1b5>
80100a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a8e:	00 
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 08 72 10 80       	push   $0x80107208
80100a9b:	68 20 ef 10 80       	push   $0x8010ef20
80100aa0:	e8 3b 39 00 00       	call   801043e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100aa5:	58                   	pop    %eax
80100aa6:	5a                   	pop    %edx
80100aa7:	6a 00                	push   $0x0
80100aa9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100aab:	c7 05 0c f9 10 80 e0 	movl   $0x801005e0,0x8010f90c
80100ab2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab5:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100abc:	02 10 80 
  cons.locking = 1;
80100abf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ac6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ac9:	e8 c2 19 00 00       	call   80102490 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 9f 2e 00 00       	call   80103990 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 74 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 a9 15 00 00       	call   801020b0 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 b3 0c 00 00       	call   801017d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 b2 0f 00 00       	call   80101ae0 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 01 63 00 00       	call   80106e50 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 c0 60 00 00       	call   80106c80 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 ba 5f 00 00       	call   80106bb0 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 c2 0e 00 00       	call   80101ae0 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 98 61 00 00       	call   80106dd0 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 1c 0e 00 00       	call   80101a60 <iunlockput>
    end_op();
80100c44:	e8 97 21 00 00       	call   80102de0 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 df 0d 00 00       	call   80101a60 <iunlockput>
  end_op();
80100c81:	e8 5a 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 e9 5f 00 00       	call   80106c80 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 38 62 00 00       	call   80106ef0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 c1 3b 00 00       	call   801048c0 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 b0 3b 00 00       	call   801048c0 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 9d 63 00 00       	call   801070c0 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 98 60 00 00       	call   80106dd0 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 2c 63 00 00       	call   801070c0 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 ac 3a 00 00       	call   80104880 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 20 5c 00 00       	call   80106a20 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 c8 5f 00 00       	call   80106dd0 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 99 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 10 72 10 80       	push   $0x80107210
80100e4f:	e8 8c f8 ff ff       	call   801006e0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 1c 72 10 80       	push   $0x8010721c
80100e6b:	68 60 ef 10 80       	push   $0x8010ef60
80100e70:	e8 6b 35 00 00       	call   801043e0 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 3a 37 00 00       	call   801045d0 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ef 10 80       	push   $0x8010ef60
80100ec1:	e8 aa 36 00 00       	call   80104570 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ef 10 80       	push   $0x8010ef60
80100eda:	e8 91 36 00 00       	call   80104570 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ef 10 80       	push   $0x8010ef60
80100eff:	e8 cc 36 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ef 10 80       	push   $0x8010ef60
80100f1c:	e8 4f 36 00 00       	call   80104570 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 23 72 10 80       	push   $0x80107223
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f3c:	00 
80100f3d:	8d 76 00             	lea    0x0(%esi),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ef 10 80       	push   $0x8010ef60
80100f51:	e8 7a 36 00 00       	call   801045d0 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ef 10 80       	push   $0x8010ef60
80100f8c:	e8 df 35 00 00       	call   80104570 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fad:	00 
80100fae:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 ad 35 00 00       	jmp    80104570 <release>
80100fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fc8:	e8 a3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 28 09 00 00       	call   80101900 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 f9 1d 00 00       	jmp    80102de0 <end_op>
80100fe7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fee:	00 
80100fef:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 32 25 00 00       	call   80103530 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 2b 72 10 80       	push   $0x8010722b
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010101d:	00 
8010101e:	66 90                	xchg   %ax,%ax

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 96 07 00 00       	call   801017d0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 69 0a 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 60 08 00 00       	call   801018b0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 31 07 00 00       	call   801017d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 34 0a 00 00       	call   80101ae0 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 ed 07 00 00       	call   801018b0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 0e 26 00 00       	jmp    801036f0 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 35 72 10 80       	push   $0x80107235
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 57 07 00 00       	call   801018b0 <iunlock>
      end_op();
80101159:	e8 82 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 ed 1b 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 42 06 00 00       	call   801017d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 40 0a 00 00       	call   80101be0 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 fb 06 00 00       	call   801018b0 <iunlock>
      end_op();
801011b5:	e8 26 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 3e 72 10 80       	push   $0x8010723e
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 d2 23 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 44 72 10 80       	push   $0x80107244
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 4e 72 10 80       	push   $0x8010724e
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 76 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 ce 33 00 00       	call   801046d0 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 46 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 f9 10 80       	push   $0x8010f960
8010133a:	e8 91 32 00 00       	call   801045d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010134e:	00 
8010134f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
      empty = ip;
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 f9 10 80       	push   $0x8010f960
801013a7:	e8 c4 31 00 00       	call   80104570 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 f9 10 80       	push   $0x8010f960
801013d5:	e8 96 31 00 00       	call   80104570 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 64 72 10 80       	push   $0x80107264
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101419:	00 
8010141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
{
80101428:	89 e5                	mov    %esp,%ebp
8010142a:	56                   	push   %esi
8010142b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010142c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
80101443:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101446:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101448:	83 e1 07             	and    $0x7,%ecx
8010144b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101450:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101456:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101458:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010145d:	85 c1                	test   %eax,%ecx
8010145f:	74 23                	je     80101484 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101461:	f7 d0                	not    %eax
  log_write(bp);
80101463:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101466:	21 c8                	and    %ecx,%eax
80101468:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146c:	56                   	push   %esi
8010146d:	e8 de 1a 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 74 72 10 80       	push   $0x80107274
8010148c:	e8 ef ee ff ff       	call   80100380 <panic>
80101491:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101498:	00 
80101499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	0f 86 8c 00 00 00    	jbe    80101540 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 a2 00 00 00    	ja     80101562 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	74 5e                	je     80101528 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ca:	83 ec 08             	sub    $0x8,%esp
801014cd:	50                   	push   %eax
801014ce:	ff 36                	push   (%esi)
801014d0:	e8 fb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014de:	8b 3b                	mov    (%ebx),%edi
801014e0:	85 ff                	test   %edi,%edi
801014e2:	74 1c                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	52                   	push   %edx
801014e8:	e8 03 ed ff ff       	call   801001f0 <brelse>
801014ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f3:	89 f8                	mov    %edi,%eax
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
801014f9:	c3                   	ret
801014fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	e8 06 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 03                	mov    %eax,(%ebx)
80101512:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101514:	52                   	push   %edx
80101515:	e8 36 1a 00 00       	call   80102f50 <log_write>
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	eb c2                	jmp    801014e4 <bmap+0x44>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 e1 fc ff ff       	call   80101210 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 93                	jmp    801014ca <bmap+0x2a>
80101537:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010153e:	00 
8010153f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 5a 14             	lea    0x14(%edx),%ebx
80101543:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101547:	85 ff                	test   %edi,%edi
80101549:	75 a5                	jne    801014f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154b:	8b 00                	mov    (%eax),%eax
8010154d:	e8 be fc ff ff       	call   80101210 <balloc>
80101552:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101556:	89 c7                	mov    %eax,%edi
}
80101558:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155b:	5b                   	pop    %ebx
8010155c:	89 f8                	mov    %edi,%eax
8010155e:	5e                   	pop    %esi
8010155f:	5f                   	pop    %edi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret
  panic("bmap: out of range");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 87 72 10 80       	push   $0x80107287
8010156a:	e8 11 ee ff ff       	call   80100380 <panic>
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	push   0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101585:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101588:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 ca 31 00 00       	call   80104760 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 49 ec ff ff       	jmp    801001f0 <brelse>
801015a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ae:	00 
801015af:	90                   	nop

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 9a 72 10 80       	push   $0x8010729a
801015c1:	68 60 f9 10 80       	push   $0x8010f960
801015c6:	e8 15 2e 00 00       	call   801043e0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 a1 72 10 80       	push   $0x801072a1
801015d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015df:	e8 cc 2c 00 00       	call   801042b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  bp = bread(dev, 1);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	6a 01                	push   $0x1
801015f4:	ff 75 08             	push   0x8(%ebp)
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101601:	8d 40 5c             	lea    0x5c(%eax),%eax
80101604:	6a 1c                	push   $0x1c
80101606:	50                   	push   %eax
80101607:	68 b4 15 11 80       	push   $0x801115b4
8010160c:	e8 4f 31 00 00       	call   80104760 <memmove>
  brelse(bp);
80101611:	89 1c 24             	mov    %ebx,(%esp)
80101614:	e8 d7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101619:	ff 35 cc 15 11 80    	push   0x801115cc
8010161f:	ff 35 c8 15 11 80    	push   0x801115c8
80101625:	ff 35 c4 15 11 80    	push   0x801115c4
8010162b:	ff 35 c0 15 11 80    	push   0x801115c0
80101631:	ff 35 bc 15 11 80    	push   0x801115bc
80101637:	ff 35 b8 15 11 80    	push   0x801115b8
8010163d:	ff 35 b4 15 11 80    	push   0x801115b4
80101643:	68 b4 76 10 80       	push   $0x801076b4
80101648:	e8 93 f0 ff ff       	call   801006e0 <cprintf>
}
8010164d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101650:	83 c4 30             	add    $0x30,%esp
80101653:	c9                   	leave
80101654:	c3                   	ret
80101655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165c:	00 
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <ialloc>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101673:	8b 75 08             	mov    0x8(%ebp),%esi
80101676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101679:	0f 86 91 00 00 00    	jbe    80101710 <ialloc+0xb0>
8010167f:	bf 01 00 00 00       	mov    $0x1,%edi
80101684:	eb 21                	jmp    801016a7 <ialloc+0x47>
80101686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010168d:	00 
8010168e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101693:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101696:	53                   	push   %ebx
80101697:	e8 54 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 c4 10             	add    $0x10,%esp
8010169f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016a5:	73 69                	jae    80101710 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016a7:	89 f8                	mov    %edi,%eax
801016a9:	83 ec 08             	sub    $0x8,%esp
801016ac:	c1 e8 03             	shr    $0x3,%eax
801016af:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016b5:	50                   	push   %eax
801016b6:	56                   	push   %esi
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016c1:	89 f8                	mov    %edi,%eax
801016c3:	83 e0 07             	and    $0x7,%eax
801016c6:	c1 e0 06             	shl    $0x6,%eax
801016c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016d1:	75 bd                	jne    80101690 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	6a 40                	push   $0x40
801016d8:	6a 00                	push   $0x0
801016da:	51                   	push   %ecx
801016db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016de:	e8 ed 2f 00 00       	call   801046d0 <memset>
      dip->type = type;
801016e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ed:	89 1c 24             	mov    %ebx,(%esp)
801016f0:	e8 5b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016f5:	89 1c 24             	mov    %ebx,(%esp)
801016f8:	e8 f3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016fd:	83 c4 10             	add    $0x10,%esp
}
80101700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101703:	89 fa                	mov    %edi,%edx
}
80101705:	5b                   	pop    %ebx
      return iget(dev, inum);
80101706:	89 f0                	mov    %esi,%eax
}
80101708:	5e                   	pop    %esi
80101709:	5f                   	pop    %edi
8010170a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010170b:	e9 10 fc ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101710:	83 ec 0c             	sub    $0xc,%esp
80101713:	68 a7 72 10 80       	push   $0x801072a7
80101718:	e8 63 ec ff ff       	call   80100380 <panic>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi

80101720 <iupdate>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172e:	83 ec 08             	sub    $0x8,%esp
80101731:	c1 e8 03             	shr    $0x3,%eax
80101734:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010173a:	50                   	push   %eax
8010173b:	ff 73 a4             	push   -0x5c(%ebx)
8010173e:	e8 8d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101743:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101747:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101759:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010175c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101760:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101763:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101767:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010176b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010176f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101773:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101777:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010177a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177d:	6a 34                	push   $0x34
8010177f:	53                   	push   %ebx
80101780:	50                   	push   %eax
80101781:	e8 da 2f 00 00       	call   80104760 <memmove>
  log_write(bp);
80101786:	89 34 24             	mov    %esi,(%esp)
80101789:	e8 c2 17 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010178e:	89 75 08             	mov    %esi,0x8(%ebp)
80101791:	83 c4 10             	add    $0x10,%esp
}
80101794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101797:	5b                   	pop    %ebx
80101798:	5e                   	pop    %esi
80101799:	5d                   	pop    %ebp
  brelse(bp);
8010179a:	e9 51 ea ff ff       	jmp    801001f0 <brelse>
8010179f:	90                   	nop

801017a0 <idup>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	53                   	push   %ebx
801017a4:	83 ec 10             	sub    $0x10,%esp
801017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017aa:	68 60 f9 10 80       	push   $0x8010f960
801017af:	e8 1c 2e 00 00       	call   801045d0 <acquire>
  ip->ref++;
801017b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017b8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017bf:	e8 ac 2d 00 00       	call   80104570 <release>
}
801017c4:	89 d8                	mov    %ebx,%eax
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave
801017ca:	c3                   	ret
801017cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017d0 <ilock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	0f 84 b7 00 00 00    	je     80101897 <ilock+0xc7>
801017e0:	8b 53 08             	mov    0x8(%ebx),%edx
801017e3:	85 d2                	test   %edx,%edx
801017e5:	0f 8e ac 00 00 00    	jle    80101897 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017eb:	83 ec 0c             	sub    $0xc,%esp
801017ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801017f1:	50                   	push   %eax
801017f2:	e8 f9 2a 00 00       	call   801042f0 <acquiresleep>
  if(ip->valid == 0){
801017f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	85 c0                	test   %eax,%eax
801017ff:	74 0f                	je     80101810 <ilock+0x40>
}
80101801:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5d                   	pop    %ebp
80101807:	c3                   	ret
80101808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010180f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101810:	8b 43 04             	mov    0x4(%ebx),%eax
80101813:	83 ec 08             	sub    $0x8,%esp
80101816:	c1 e8 03             	shr    $0x3,%eax
80101819:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010181f:	50                   	push   %eax
80101820:	ff 33                	push   (%ebx)
80101822:	e8 a9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 04             	mov    0x4(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101839:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010183c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010183f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101843:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101847:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010184b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010184f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101853:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101857:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010185b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010185e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101861:	6a 34                	push   $0x34
80101863:	50                   	push   %eax
80101864:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101867:	50                   	push   %eax
80101868:	e8 f3 2e 00 00       	call   80104760 <memmove>
    brelse(bp);
8010186d:	89 34 24             	mov    %esi,(%esp)
80101870:	e8 7b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101875:	83 c4 10             	add    $0x10,%esp
80101878:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010187d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101884:	0f 85 77 ff ff ff    	jne    80101801 <ilock+0x31>
      panic("ilock: no type");
8010188a:	83 ec 0c             	sub    $0xc,%esp
8010188d:	68 bf 72 10 80       	push   $0x801072bf
80101892:	e8 e9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	68 b9 72 10 80       	push   $0x801072b9
8010189f:	e8 dc ea ff ff       	call   80100380 <panic>
801018a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018ab:	00 
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <iunlock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	74 28                	je     801018e4 <iunlock+0x34>
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018c2:	56                   	push   %esi
801018c3:	e8 c8 2a 00 00       	call   80104390 <holdingsleep>
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 c0                	test   %eax,%eax
801018cd:	74 15                	je     801018e4 <iunlock+0x34>
801018cf:	8b 43 08             	mov    0x8(%ebx),%eax
801018d2:	85 c0                	test   %eax,%eax
801018d4:	7e 0e                	jle    801018e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018df:	e9 6c 2a 00 00       	jmp    80104350 <releasesleep>
    panic("iunlock");
801018e4:	83 ec 0c             	sub    $0xc,%esp
801018e7:	68 ce 72 10 80       	push   $0x801072ce
801018ec:	e8 8f ea ff ff       	call   80100380 <panic>
801018f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018f8:	00 
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101900 <iput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	57                   	push   %edi
80101904:	56                   	push   %esi
80101905:	53                   	push   %ebx
80101906:	83 ec 28             	sub    $0x28,%esp
80101909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010190c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010190f:	57                   	push   %edi
80101910:	e8 db 29 00 00       	call   801042f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101915:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101918:	83 c4 10             	add    $0x10,%esp
8010191b:	85 d2                	test   %edx,%edx
8010191d:	74 07                	je     80101926 <iput+0x26>
8010191f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101924:	74 32                	je     80101958 <iput+0x58>
  releasesleep(&ip->lock);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	57                   	push   %edi
8010192a:	e8 21 2a 00 00       	call   80104350 <releasesleep>
  acquire(&icache.lock);
8010192f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101936:	e8 95 2c 00 00       	call   801045d0 <acquire>
  ip->ref--;
8010193b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010193f:	83 c4 10             	add    $0x10,%esp
80101942:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5f                   	pop    %edi
8010194f:	5d                   	pop    %ebp
  release(&icache.lock);
80101950:	e9 1b 2c 00 00       	jmp    80104570 <release>
80101955:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101958:	83 ec 0c             	sub    $0xc,%esp
8010195b:	68 60 f9 10 80       	push   $0x8010f960
80101960:	e8 6b 2c 00 00       	call   801045d0 <acquire>
    int r = ip->ref;
80101965:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101968:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010196f:	e8 fc 2b 00 00       	call   80104570 <release>
    if(r == 1){
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	83 fe 01             	cmp    $0x1,%esi
8010197a:	75 aa                	jne    80101926 <iput+0x26>
8010197c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101982:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101985:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101988:	89 df                	mov    %ebx,%edi
8010198a:	89 cb                	mov    %ecx,%ebx
8010198c:	eb 09                	jmp    80101997 <iput+0x97>
8010198e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101990:	83 c6 04             	add    $0x4,%esi
80101993:	39 de                	cmp    %ebx,%esi
80101995:	74 19                	je     801019b0 <iput+0xb0>
    if(ip->addrs[i]){
80101997:	8b 16                	mov    (%esi),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010199d:	8b 07                	mov    (%edi),%eax
8010199f:	e8 7c fa ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
801019a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019aa:	eb e4                	jmp    80101990 <iput+0x90>
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019b0:	89 fb                	mov    %edi,%ebx
801019b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019b5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	75 2d                	jne    801019ec <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019bf:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019c9:	53                   	push   %ebx
801019ca:	e8 51 fd ff ff       	call   80101720 <iupdate>
      ip->type = 0;
801019cf:	31 c0                	xor    %eax,%eax
801019d1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019d5:	89 1c 24             	mov    %ebx,(%esp)
801019d8:	e8 43 fd ff ff       	call   80101720 <iupdate>
      ip->valid = 0;
801019dd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019e4:	83 c4 10             	add    $0x10,%esp
801019e7:	e9 3a ff ff ff       	jmp    80101926 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ec:	83 ec 08             	sub    $0x8,%esp
801019ef:	50                   	push   %eax
801019f0:	ff 33                	push   (%ebx)
801019f2:	e8 d9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019f7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019fa:	83 c4 10             	add    $0x10,%esp
801019fd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a03:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a06:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a09:	89 cf                	mov    %ecx,%edi
80101a0b:	eb 0a                	jmp    80101a17 <iput+0x117>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 fe                	cmp    %edi,%esi
80101a15:	74 0f                	je     80101a26 <iput+0x126>
      if(a[j])
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 fc f9 ff ff       	call   80101420 <bfree>
80101a24:	eb ea                	jmp    80101a10 <iput+0x110>
    brelse(bp);
80101a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a29:	83 ec 0c             	sub    $0xc,%esp
80101a2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a2f:	50                   	push   %eax
80101a30:	e8 bb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a35:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a3b:	8b 03                	mov    (%ebx),%eax
80101a3d:	e8 de f9 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a4c:	00 00 00 
80101a4f:	e9 6b ff ff ff       	jmp    801019bf <iput+0xbf>
80101a54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a5b:	00 
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a60 <iunlockput>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	56                   	push   %esi
80101a64:	53                   	push   %ebx
80101a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a68:	85 db                	test   %ebx,%ebx
80101a6a:	74 34                	je     80101aa0 <iunlockput+0x40>
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a72:	56                   	push   %esi
80101a73:	e8 18 29 00 00       	call   80104390 <holdingsleep>
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	74 21                	je     80101aa0 <iunlockput+0x40>
80101a7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7e 1a                	jle    80101aa0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	56                   	push   %esi
80101a8a:	e8 c1 28 00 00       	call   80104350 <releasesleep>
  iput(ip);
80101a8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a92:	83 c4 10             	add    $0x10,%esp
}
80101a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5d                   	pop    %ebp
  iput(ip);
80101a9b:	e9 60 fe ff ff       	jmp    80101900 <iput>
    panic("iunlock");
80101aa0:	83 ec 0c             	sub    $0xc,%esp
80101aa3:	68 ce 72 10 80       	push   $0x801072ce
80101aa8:	e8 d3 e8 ff ff       	call   80100380 <panic>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ab9:	8b 0a                	mov    (%edx),%ecx
80101abb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101abe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ac8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101acf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad3:	8b 52 58             	mov    0x58(%edx),%edx
80101ad6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ad9:	5d                   	pop    %ebp
80101ada:	c3                   	ret
80101adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ae0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 75 08             	mov    0x8(%ebp),%esi
80101aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101aef:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101afa:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101afd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b00:	0f 84 aa 00 00 00    	je     80101bb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b06:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b09:	8b 56 58             	mov    0x58(%esi),%edx
80101b0c:	39 fa                	cmp    %edi,%edx
80101b0e:	0f 82 bd 00 00 00    	jb     80101bd1 <readi+0xf1>
80101b14:	89 f9                	mov    %edi,%ecx
80101b16:	31 db                	xor    %ebx,%ebx
80101b18:	01 c1                	add    %eax,%ecx
80101b1a:	0f 92 c3             	setb   %bl
80101b1d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b20:	0f 82 ab 00 00 00    	jb     80101bd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b26:	89 d3                	mov    %edx,%ebx
80101b28:	29 fb                	sub    %edi,%ebx
80101b2a:	39 ca                	cmp    %ecx,%edx
80101b2c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	85 c0                	test   %eax,%eax
80101b31:	74 73                	je     80101ba6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b33:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b43:	89 fa                	mov    %edi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 d8                	mov    %ebx,%eax
80101b4a:	e8 51 f9 ff ff       	call   801014a0 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 33                	push   (%ebx)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b64:	89 f8                	mov    %edi,%eax
80101b66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b6b:	29 f3                	sub    %esi,%ebx
80101b6d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b6f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	39 d9                	cmp    %ebx,%ecx
80101b75:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b78:	83 c4 0c             	add    $0xc,%esp
80101b7b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7c:	01 de                	add    %ebx,%esi
80101b7e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b83:	50                   	push   %eax
80101b84:	ff 75 e0             	push   -0x20(%ebp)
80101b87:	e8 d4 2b 00 00       	call   80104760 <memmove>
    brelse(bp);
80101b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b8f:	89 14 24             	mov    %edx,(%esp)
80101b92:	e8 59 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b9d:	83 c4 10             	add    $0x10,%esp
80101ba0:	39 de                	cmp    %ebx,%esi
80101ba2:	72 9c                	jb     80101b40 <readi+0x60>
80101ba4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba9:	5b                   	pop    %ebx
80101baa:	5e                   	pop    %esi
80101bab:	5f                   	pop    %edi
80101bac:	5d                   	pop    %ebp
80101bad:	c3                   	ret
80101bae:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bb0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bb4:	66 83 fa 09          	cmp    $0x9,%dx
80101bb8:	77 17                	ja     80101bd1 <readi+0xf1>
80101bba:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101bc1:	85 d2                	test   %edx,%edx
80101bc3:	74 0c                	je     80101bd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bc5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bcf:	ff e2                	jmp    *%edx
      return -1;
80101bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd6:	eb ce                	jmp    80101ba6 <readi+0xc6>
80101bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bdf:	00 

80101be0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bef:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bfa:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bfd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c00:	0f 84 ba 00 00 00    	je     80101cc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c06:	39 78 58             	cmp    %edi,0x58(%eax)
80101c09:	0f 82 ea 00 00 00    	jb     80101cf9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c0f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c12:	89 f2                	mov    %esi,%edx
80101c14:	01 fa                	add    %edi,%edx
80101c16:	0f 82 dd 00 00 00    	jb     80101cf9 <writei+0x119>
80101c1c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c22:	0f 87 d1 00 00 00    	ja     80101cf9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	85 f6                	test   %esi,%esi
80101c2a:	0f 84 85 00 00 00    	je     80101cb5 <writei+0xd5>
80101c30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c40:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c43:	89 fa                	mov    %edi,%edx
80101c45:	c1 ea 09             	shr    $0x9,%edx
80101c48:	89 f0                	mov    %esi,%eax
80101c4a:	e8 51 f8 ff ff       	call   801014a0 <bmap>
80101c4f:	83 ec 08             	sub    $0x8,%esp
80101c52:	50                   	push   %eax
80101c53:	ff 36                	push   (%esi)
80101c55:	e8 76 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c5d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c60:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c65:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c67:	89 f8                	mov    %edi,%eax
80101c69:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c6e:	29 d3                	sub    %edx,%ebx
80101c70:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c72:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c76:	39 d9                	cmp    %ebx,%ecx
80101c78:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c7b:	83 c4 0c             	add    $0xc,%esp
80101c7e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c7f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c81:	ff 75 dc             	push   -0x24(%ebp)
80101c84:	50                   	push   %eax
80101c85:	e8 d6 2a 00 00       	call   80104760 <memmove>
    log_write(bp);
80101c8a:	89 34 24             	mov    %esi,(%esp)
80101c8d:	e8 be 12 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c92:	89 34 24             	mov    %esi,(%esp)
80101c95:	e8 56 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c9a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca0:	83 c4 10             	add    $0x10,%esp
80101ca3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ca6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ca9:	39 d8                	cmp    %ebx,%eax
80101cab:	72 93                	jb     80101c40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cb0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cb3:	72 33                	jb     80101ce8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cbb:	5b                   	pop    %ebx
80101cbc:	5e                   	pop    %esi
80101cbd:	5f                   	pop    %edi
80101cbe:	5d                   	pop    %ebp
80101cbf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cc4:	66 83 f8 09          	cmp    $0x9,%ax
80101cc8:	77 2f                	ja     80101cf9 <writei+0x119>
80101cca:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101cd1:	85 c0                	test   %eax,%eax
80101cd3:	74 24                	je     80101cf9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101cd5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cdf:	ff e0                	jmp    *%eax
80101ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101ceb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cee:	50                   	push   %eax
80101cef:	e8 2c fa ff ff       	call   80101720 <iupdate>
80101cf4:	83 c4 10             	add    $0x10,%esp
80101cf7:	eb bc                	jmp    80101cb5 <writei+0xd5>
      return -1;
80101cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cfe:	eb b8                	jmp    80101cb8 <writei+0xd8>

80101d00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d06:	6a 0e                	push   $0xe
80101d08:	ff 75 0c             	push   0xc(%ebp)
80101d0b:	ff 75 08             	push   0x8(%ebp)
80101d0e:	e8 bd 2a 00 00       	call   801047d0 <strncmp>
}
80101d13:	c9                   	leave
80101d14:	c3                   	ret
80101d15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d1c:	00 
80101d1d:	8d 76 00             	lea    0x0(%esi),%esi

80101d20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 1c             	sub    $0x1c,%esp
80101d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d31:	0f 85 85 00 00 00    	jne    80101dbc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d37:	8b 53 58             	mov    0x58(%ebx),%edx
80101d3a:	31 ff                	xor    %edi,%edi
80101d3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d3f:	85 d2                	test   %edx,%edx
80101d41:	74 3e                	je     80101d81 <dirlookup+0x61>
80101d43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d48:	6a 10                	push   $0x10
80101d4a:	57                   	push   %edi
80101d4b:	56                   	push   %esi
80101d4c:	53                   	push   %ebx
80101d4d:	e8 8e fd ff ff       	call   80101ae0 <readi>
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	83 f8 10             	cmp    $0x10,%eax
80101d58:	75 55                	jne    80101daf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d5f:	74 18                	je     80101d79 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d61:	83 ec 04             	sub    $0x4,%esp
80101d64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d67:	6a 0e                	push   $0xe
80101d69:	50                   	push   %eax
80101d6a:	ff 75 0c             	push   0xc(%ebp)
80101d6d:	e8 5e 2a 00 00       	call   801047d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	85 c0                	test   %eax,%eax
80101d77:	74 17                	je     80101d90 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d79:	83 c7 10             	add    $0x10,%edi
80101d7c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d7f:	72 c7                	jb     80101d48 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d84:	31 c0                	xor    %eax,%eax
}
80101d86:	5b                   	pop    %ebx
80101d87:	5e                   	pop    %esi
80101d88:	5f                   	pop    %edi
80101d89:	5d                   	pop    %ebp
80101d8a:	c3                   	ret
80101d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d90:	8b 45 10             	mov    0x10(%ebp),%eax
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 05                	je     80101d9c <dirlookup+0x7c>
        *poff = off;
80101d97:	8b 45 10             	mov    0x10(%ebp),%eax
80101d9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101da0:	8b 03                	mov    (%ebx),%eax
80101da2:	e8 79 f5 ff ff       	call   80101320 <iget>
}
80101da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101daa:	5b                   	pop    %ebx
80101dab:	5e                   	pop    %esi
80101dac:	5f                   	pop    %edi
80101dad:	5d                   	pop    %ebp
80101dae:	c3                   	ret
      panic("dirlookup read");
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	68 e8 72 10 80       	push   $0x801072e8
80101db7:	e8 c4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dbc:	83 ec 0c             	sub    $0xc,%esp
80101dbf:	68 d6 72 10 80       	push   $0x801072d6
80101dc4:	e8 b7 e5 ff ff       	call   80100380 <panic>
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	89 c3                	mov    %eax,%ebx
80101dd8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ddb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dde:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101de1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101de4:	0f 84 9e 01 00 00    	je     80101f88 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dea:	e8 a1 1b 00 00       	call   80103990 <myproc>
  acquire(&icache.lock);
80101def:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101df2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101df5:	68 60 f9 10 80       	push   $0x8010f960
80101dfa:	e8 d1 27 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101dff:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e03:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e0a:	e8 61 27 00 00       	call   80104570 <release>
80101e0f:	83 c4 10             	add    $0x10,%esp
80101e12:	eb 07                	jmp    80101e1b <namex+0x4b>
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e1b:	0f b6 03             	movzbl (%ebx),%eax
80101e1e:	3c 2f                	cmp    $0x2f,%al
80101e20:	74 f6                	je     80101e18 <namex+0x48>
  if(*path == 0)
80101e22:	84 c0                	test   %al,%al
80101e24:	0f 84 06 01 00 00    	je     80101f30 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e2a:	0f b6 03             	movzbl (%ebx),%eax
80101e2d:	84 c0                	test   %al,%al
80101e2f:	0f 84 10 01 00 00    	je     80101f45 <namex+0x175>
80101e35:	89 df                	mov    %ebx,%edi
80101e37:	3c 2f                	cmp    $0x2f,%al
80101e39:	0f 84 06 01 00 00    	je     80101f45 <namex+0x175>
80101e3f:	90                   	nop
80101e40:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e44:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e47:	3c 2f                	cmp    $0x2f,%al
80101e49:	74 04                	je     80101e4f <namex+0x7f>
80101e4b:	84 c0                	test   %al,%al
80101e4d:	75 f1                	jne    80101e40 <namex+0x70>
  len = path - s;
80101e4f:	89 f8                	mov    %edi,%eax
80101e51:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e53:	83 f8 0d             	cmp    $0xd,%eax
80101e56:	0f 8e ac 00 00 00    	jle    80101f08 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e5c:	83 ec 04             	sub    $0x4,%esp
80101e5f:	6a 0e                	push   $0xe
80101e61:	53                   	push   %ebx
80101e62:	89 fb                	mov    %edi,%ebx
80101e64:	ff 75 e4             	push   -0x1c(%ebp)
80101e67:	e8 f4 28 00 00       	call   80104760 <memmove>
80101e6c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e6f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e72:	75 0c                	jne    80101e80 <namex+0xb0>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e7b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e7e:	74 f8                	je     80101e78 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e80:	83 ec 0c             	sub    $0xc,%esp
80101e83:	56                   	push   %esi
80101e84:	e8 47 f9 ff ff       	call   801017d0 <ilock>
    if(ip->type != T_DIR){
80101e89:	83 c4 10             	add    $0x10,%esp
80101e8c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e91:	0f 85 b7 00 00 00    	jne    80101f4e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	74 09                	je     80101ea7 <namex+0xd7>
80101e9e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ea1:	0f 84 f7 00 00 00    	je     80101f9e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ea7:	83 ec 04             	sub    $0x4,%esp
80101eaa:	6a 00                	push   $0x0
80101eac:	ff 75 e4             	push   -0x1c(%ebp)
80101eaf:	56                   	push   %esi
80101eb0:	e8 6b fe ff ff       	call   80101d20 <dirlookup>
80101eb5:	83 c4 10             	add    $0x10,%esp
80101eb8:	89 c7                	mov    %eax,%edi
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	0f 84 8c 00 00 00    	je     80101f4e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ec2:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	51                   	push   %ecx
80101ec9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ecc:	e8 bf 24 00 00       	call   80104390 <holdingsleep>
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	85 c0                	test   %eax,%eax
80101ed6:	0f 84 02 01 00 00    	je     80101fde <namex+0x20e>
80101edc:	8b 56 08             	mov    0x8(%esi),%edx
80101edf:	85 d2                	test   %edx,%edx
80101ee1:	0f 8e f7 00 00 00    	jle    80101fde <namex+0x20e>
  releasesleep(&ip->lock);
80101ee7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eea:	83 ec 0c             	sub    $0xc,%esp
80101eed:	51                   	push   %ecx
80101eee:	e8 5d 24 00 00       	call   80104350 <releasesleep>
  iput(ip);
80101ef3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ef6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ef8:	e8 03 fa ff ff       	call   80101900 <iput>
80101efd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f00:	e9 16 ff ff ff       	jmp    80101e1b <namex+0x4b>
80101f05:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f0b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f0e:	83 ec 04             	sub    $0x4,%esp
80101f11:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f14:	50                   	push   %eax
80101f15:	53                   	push   %ebx
    name[len] = 0;
80101f16:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f18:	ff 75 e4             	push   -0x1c(%ebp)
80101f1b:	e8 40 28 00 00       	call   80104760 <memmove>
    name[len] = 0;
80101f20:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f23:	83 c4 10             	add    $0x10,%esp
80101f26:	c6 01 00             	movb   $0x0,(%ecx)
80101f29:	e9 41 ff ff ff       	jmp    80101e6f <namex+0x9f>
80101f2e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 85 93 00 00 00    	jne    80101fce <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3e:	89 f0                	mov    %esi,%eax
80101f40:	5b                   	pop    %ebx
80101f41:	5e                   	pop    %esi
80101f42:	5f                   	pop    %edi
80101f43:	5d                   	pop    %ebp
80101f44:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f45:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f48:	89 df                	mov    %ebx,%edi
80101f4a:	31 c0                	xor    %eax,%eax
80101f4c:	eb c0                	jmp    80101f0e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f4e:	83 ec 0c             	sub    $0xc,%esp
80101f51:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f54:	53                   	push   %ebx
80101f55:	e8 36 24 00 00       	call   80104390 <holdingsleep>
80101f5a:	83 c4 10             	add    $0x10,%esp
80101f5d:	85 c0                	test   %eax,%eax
80101f5f:	74 7d                	je     80101fde <namex+0x20e>
80101f61:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f64:	85 c9                	test   %ecx,%ecx
80101f66:	7e 76                	jle    80101fde <namex+0x20e>
  releasesleep(&ip->lock);
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	53                   	push   %ebx
80101f6c:	e8 df 23 00 00       	call   80104350 <releasesleep>
  iput(ip);
80101f71:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f74:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f76:	e8 85 f9 ff ff       	call   80101900 <iput>
      return 0;
80101f7b:	83 c4 10             	add    $0x10,%esp
}
80101f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f81:	89 f0                	mov    %esi,%eax
80101f83:	5b                   	pop    %ebx
80101f84:	5e                   	pop    %esi
80101f85:	5f                   	pop    %edi
80101f86:	5d                   	pop    %ebp
80101f87:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f88:	ba 01 00 00 00       	mov    $0x1,%edx
80101f8d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f92:	e8 89 f3 ff ff       	call   80101320 <iget>
80101f97:	89 c6                	mov    %eax,%esi
80101f99:	e9 7d fe ff ff       	jmp    80101e1b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fa4:	53                   	push   %ebx
80101fa5:	e8 e6 23 00 00       	call   80104390 <holdingsleep>
80101faa:	83 c4 10             	add    $0x10,%esp
80101fad:	85 c0                	test   %eax,%eax
80101faf:	74 2d                	je     80101fde <namex+0x20e>
80101fb1:	8b 7e 08             	mov    0x8(%esi),%edi
80101fb4:	85 ff                	test   %edi,%edi
80101fb6:	7e 26                	jle    80101fde <namex+0x20e>
  releasesleep(&ip->lock);
80101fb8:	83 ec 0c             	sub    $0xc,%esp
80101fbb:	53                   	push   %ebx
80101fbc:	e8 8f 23 00 00       	call   80104350 <releasesleep>
}
80101fc1:	83 c4 10             	add    $0x10,%esp
}
80101fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc7:	89 f0                	mov    %esi,%eax
80101fc9:	5b                   	pop    %ebx
80101fca:	5e                   	pop    %esi
80101fcb:	5f                   	pop    %edi
80101fcc:	5d                   	pop    %ebp
80101fcd:	c3                   	ret
    iput(ip);
80101fce:	83 ec 0c             	sub    $0xc,%esp
80101fd1:	56                   	push   %esi
      return 0;
80101fd2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fd4:	e8 27 f9 ff ff       	call   80101900 <iput>
    return 0;
80101fd9:	83 c4 10             	add    $0x10,%esp
80101fdc:	eb a0                	jmp    80101f7e <namex+0x1ae>
    panic("iunlock");
80101fde:	83 ec 0c             	sub    $0xc,%esp
80101fe1:	68 ce 72 10 80       	push   $0x801072ce
80101fe6:	e8 95 e3 ff ff       	call   80100380 <panic>
80101feb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 19 fd ff ff       	call   80101d20 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 ae fa ff ff       	call   80101ae0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 ce 27 00 00       	call   80104820 <strncpy>
  de.inum = inum;
80102052:	8b 45 10             	mov    0x10(%ebp),%eax
80102055:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102059:	6a 10                	push   $0x10
8010205b:	57                   	push   %edi
8010205c:	56                   	push   %esi
8010205d:	53                   	push   %ebx
8010205e:	e8 7d fb ff ff       	call   80101be0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 82 f8 ff ff       	call   80101900 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 f7 72 10 80       	push   $0x801072f7
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 53 75 10 80       	push   $0x80107553
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020a9:	00 
801020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 0d fd ff ff       	call   80101dd0 <namex>
}
801020c3:	c9                   	leave
801020c4:	c3                   	ret
801020c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020cc:	00 
801020cd:	8d 76 00             	lea    0x0(%esi),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 ec fc ff ff       	jmp    80101dd0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010211e:	00 
8010211f:	90                   	nop
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 0d 73 10 80       	push   $0x8010730d
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 04 73 10 80       	push   $0x80107304
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021c9:	00 
801021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 1f 73 10 80       	push   $0x8010731f
801021db:	68 00 16 11 80       	push   $0x80111600
801021e0:	e8 fb 21 00 00       	call   801043e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021ff:	90                   	nop
80102200:	89 ca                	mov    %ecx,%edx
80102202:	ec                   	in     (%dx),%al
80102203:	83 e0 c0             	and    $0xffffffc0,%eax
80102206:	3c 40                	cmp    $0x40,%al
80102208:	75 f6                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102214:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102215:	89 ca                	mov    %ecx,%edx
80102217:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102218:	84 c0                	test   %al,%al
8010221a:	75 1e                	jne    8010223a <ideinit+0x6a>
8010221c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102221:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010222d:	00 
8010222e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x74>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x60>
      havedisk1 = 1;
8010223a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave
80102250:	c3                   	ret
80102251:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102258:	00 
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 00 16 11 80       	push   $0x80111600
8010226e:	e8 5d 23 00 00       	call   801045d0 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010229e:	00 
8010229f:	90                   	nop
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 3e 1e 00 00       	call   80104110 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 0d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 00 16 11 80       	push   $0x80111600
801022eb:	e8 80 22 00 00       	call   80104570 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret
801022f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022ff:	00 

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 7d 20 00 00       	call   80104390 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 00 16 11 80       	push   $0x80111600
80102348:	e8 83 22 00 00       	call   801045d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 00 16 11 80       	push   $0x80111600
80102388:	53                   	push   %ebx
80102389:	e8 c2 1c 00 00       	call   80104050 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave
  release(&idelock);
801023a6:	e9 c5 21 00 00       	jmp    80104570 <release>
801023ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 39 fd ff ff       	call   801020f0 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 4e 73 10 80       	push   $0x8010734e
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 39 73 10 80       	push   $0x80107339
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 23 73 10 80       	push   $0x80107323
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023fc:	00 c0 fe 
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 08 77 10 80       	push   $0x80107708
8010243f:	e8 9c e2 ff ff       	call   801006e0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010244a:	83 c4 10             	add    $0x10,%esp
{
8010244d:	ba 10 00 00 00       	mov    $0x10,%edx
80102452:	31 c0                	xor    %eax,%eax
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102458:	89 13                	mov    %edx,(%ebx)
8010245a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010245d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102463:	83 c0 01             	add    $0x1,%eax
80102466:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010246c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010246f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102472:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102475:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102477:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010247d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102484:	39 c6                	cmp    %eax,%esi
80102486:	7d d0                	jge    80102458 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102488:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret
8010248f:	90                   	nop

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 c9 21 00 00       	call   801046d0 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 16 11 80       	mov    0x80111678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave
8010252e:	c3                   	ret
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 16 11 80       	push   $0x80111640
80102538:	e8 93 20 00 00       	call   801045d0 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave
    release(&kmem.lock);
80102553:	e9 18 20 00 00       	jmp    80104570 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 6c 73 10 80       	push   $0x8010736c
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010256c:	00 
8010256d:	8d 76 00             	lea    0x0(%esi),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102575:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102578:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	73 e4                	jae    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret
801025bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret
80102615:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010261c:	00 
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 72 73 10 80       	push   $0x80107372
80102630:	68 40 16 11 80       	push   $0x80111640
80102635:	e8 a6 1d 00 00       	call   801043e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret
80102683:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268a:	00 
8010268b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102690 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	53                   	push   %ebx
80102694:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102697:	a1 74 16 11 80       	mov    0x80111674,%eax
8010269c:	85 c0                	test   %eax,%eax
8010269e:	75 20                	jne    801026c0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026a0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801026a6:	85 db                	test   %ebx,%ebx
801026a8:	74 07                	je     801026b1 <kalloc+0x21>
    kmem.freelist = r->next;
801026aa:	8b 03                	mov    (%ebx),%eax
801026ac:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026b1:	89 d8                	mov    %ebx,%eax
801026b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b6:	c9                   	leave
801026b7:	c3                   	ret
801026b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bf:	00 
    acquire(&kmem.lock);
801026c0:	83 ec 0c             	sub    $0xc,%esp
801026c3:	68 40 16 11 80       	push   $0x80111640
801026c8:	e8 03 1f 00 00       	call   801045d0 <acquire>
  r = kmem.freelist;
801026cd:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801026d3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801026d8:	83 c4 10             	add    $0x10,%esp
801026db:	85 db                	test   %ebx,%ebx
801026dd:	74 08                	je     801026e7 <kalloc+0x57>
    kmem.freelist = r->next;
801026df:	8b 13                	mov    (%ebx),%edx
801026e1:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026e7:	85 c0                	test   %eax,%eax
801026e9:	74 c6                	je     801026b1 <kalloc+0x21>
    release(&kmem.lock);
801026eb:	83 ec 0c             	sub    $0xc,%esp
801026ee:	68 40 16 11 80       	push   $0x80111640
801026f3:	e8 78 1e 00 00       	call   80104570 <release>
}
801026f8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026fa:	83 c4 10             	add    $0x10,%esp
}
801026fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102700:	c9                   	leave
80102701:	c3                   	ret
80102702:	66 90                	xchg   %ax,%ax
80102704:	66 90                	xchg   %ax,%ax
80102706:	66 90                	xchg   %ax,%ax
80102708:	66 90                	xchg   %ax,%ax
8010270a:	66 90                	xchg   %ax,%ax
8010270c:	66 90                	xchg   %ax,%ax
8010270e:	66 90                	xchg   %ax,%ax

80102710 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba 64 00 00 00       	mov    $0x64,%edx
80102715:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102716:	a8 01                	test   $0x1,%al
80102718:	0f 84 c2 00 00 00    	je     801027e0 <kbdgetc+0xd0>
{
8010271e:	55                   	push   %ebp
8010271f:	ba 60 00 00 00       	mov    $0x60,%edx
80102724:	89 e5                	mov    %esp,%ebp
80102726:	53                   	push   %ebx
80102727:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102728:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010272e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102731:	3c e0                	cmp    $0xe0,%al
80102733:	74 5b                	je     80102790 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102735:	89 da                	mov    %ebx,%edx
80102737:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010273a:	84 c0                	test   %al,%al
8010273c:	78 62                	js     801027a0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010273e:	85 d2                	test   %edx,%edx
80102740:	74 09                	je     8010274b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102742:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102745:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102748:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010274b:	0f b6 91 80 79 10 80 	movzbl -0x7fef8680(%ecx),%edx
  shift ^= togglecode[data];
80102752:	0f b6 81 80 78 10 80 	movzbl -0x7fef8780(%ecx),%eax
  shift |= shiftcode[data];
80102759:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010275b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010275f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102765:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102768:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276b:	8b 04 85 60 78 10 80 	mov    -0x7fef87a0(,%eax,4),%eax
80102772:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102776:	74 0b                	je     80102783 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102778:	8d 50 9f             	lea    -0x61(%eax),%edx
8010277b:	83 fa 19             	cmp    $0x19,%edx
8010277e:	77 48                	ja     801027c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102780:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave
80102787:	c3                   	ret
80102788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278f:	00 
    shift |= E0ESC;
80102790:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102793:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102795:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010279b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279e:	c9                   	leave
8010279f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 d2                	test   %edx,%edx
801027a5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 81 80 79 10 80 	movzbl -0x7fef8680(%ecx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 d8                	and    %ebx,%eax
801027b9:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027be:	31 c0                	xor    %eax,%eax
801027c0:	eb d9                	jmp    8010279b <kbdgetc+0x8b>
801027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave
      c += 'a' - 'A';
801027d2:	83 f9 1a             	cmp    $0x1a,%ecx
801027d5:	0f 42 c2             	cmovb  %edx,%eax
}
801027d8:	c3                   	ret
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027e5:	c3                   	ret
801027e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027ed:	00 
801027ee:	66 90                	xchg   %ax,%ax

801027f0 <kbdintr>:

void
kbdintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027f6:	68 10 27 10 80       	push   $0x80102710
801027fb:	e8 d0 e0 ff ff       	call   801008d0 <consoleintr>
}
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	c9                   	leave
80102804:	c3                   	ret
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 80 16 11 80       	mov    0x80111680,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	0f 84 c3 00 00 00    	je     801028e0 <lapicinit+0xd0>
  lapic[index] = value;
8010281d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102824:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010283e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102865:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286b:	8b 50 30             	mov    0x30(%eax),%edx
8010286e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102874:	75 72                	jne    801028e8 <lapicinit+0xd8>
  lapic[index] = value;
80102876:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028be:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028ce:	80 e6 10             	and    $0x10,%dh
801028d1:	75 f5                	jne    801028c8 <lapicinit+0xb8>
  lapic[index] = value;
801028d3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e0:	c3                   	ret
801028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028ef:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028f2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028f5:	e9 7c ff ff ff       	jmp    80102876 <lapicinit+0x66>
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 16 11 80       	mov    0x80111680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret
80102913:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010291a:	00 
8010291b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 16 11 80       	mov    0x80111680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret
80102937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010293e:	00 
8010293f:	90                   	nop

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret
80102941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102948:	00 
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave
801029de:	c3                   	ret
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bf 70 00 00 00       	mov    $0x70,%edi
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 fa                	mov    %edi,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 fa                	mov    %edi,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 fa                	mov    %edi,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 fa                	mov    %edi,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 fa                	mov    %edi,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 fa                	mov    %edi,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5d:	89 fa                	mov    %edi,%edx
80102a5f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a68:	84 c0                	test   %al,%al
80102a6a:	78 9c                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a70:	89 f2                	mov    %esi,%edx
80102a72:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a75:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 fa                	mov    %edi,%edx
80102a7a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a7d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a81:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a84:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a87:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a8e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a95:	31 c0                	xor    %eax,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 fa                	mov    %edi,%edx
80102aa0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa3:	b8 02 00 00 00       	mov    $0x2,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaf:	89 fa                	mov    %edi,%edx
80102ab1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab4:	b8 04 00 00 00       	mov    $0x4,%eax
80102ab9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aba:	89 ca                	mov    %ecx,%edx
80102abc:	ec                   	in     (%dx),%al
80102abd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac0:	89 fa                	mov    %edi,%edx
80102ac2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac5:	b8 07 00 00 00       	mov    $0x7,%eax
80102aca:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acb:	89 ca                	mov    %ecx,%edx
80102acd:	ec                   	in     (%dx),%al
80102ace:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad1:	89 fa                	mov    %edi,%edx
80102ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ad6:	b8 08 00 00 00       	mov    $0x8,%eax
80102adb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adc:	89 ca                	mov    %ecx,%edx
80102ade:	ec                   	in     (%dx),%al
80102adf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae2:	89 fa                	mov    %edi,%edx
80102ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ae7:	b8 09 00 00 00       	mov    $0x9,%eax
80102aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aed:	89 ca                	mov    %ecx,%edx
80102aef:	ec                   	in     (%dx),%al
80102af0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102afc:	6a 18                	push   $0x18
80102afe:	50                   	push   %eax
80102aff:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b02:	50                   	push   %eax
80102b03:	e8 08 1c 00 00       	call   80104710 <memcmp>
80102b08:	83 c4 10             	add    $0x10,%esp
80102b0b:	85 c0                	test   %eax,%eax
80102b0d:	0f 85 f5 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b13:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b1a:	89 f0                	mov    %esi,%eax
80102b1c:	84 c0                	test   %al,%al
80102b1e:	75 78                	jne    80102b98 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b20:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b23:	89 c2                	mov    %eax,%edx
80102b25:	83 e0 0f             	and    $0xf,%eax
80102b28:	c1 ea 04             	shr    $0x4,%edx
80102b2b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b31:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b34:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b37:	89 c2                	mov    %eax,%edx
80102b39:	83 e0 0f             	and    $0xf,%eax
80102b3c:	c1 ea 04             	shr    $0x4,%edx
80102b3f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b42:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b48:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b4b:	89 c2                	mov    %eax,%edx
80102b4d:	83 e0 0f             	and    $0xf,%eax
80102b50:	c1 ea 04             	shr    $0x4,%edx
80102b53:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b56:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b59:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5f:	89 c2                	mov    %eax,%edx
80102b61:	83 e0 0f             	and    $0xf,%eax
80102b64:	c1 ea 04             	shr    $0x4,%edx
80102b67:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b70:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b73:	89 c2                	mov    %eax,%edx
80102b75:	83 e0 0f             	and    $0xf,%eax
80102b78:	c1 ea 04             	shr    $0x4,%edx
80102b7b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b81:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b84:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b87:	89 c2                	mov    %eax,%edx
80102b89:	83 e0 0f             	and    $0xf,%eax
80102b8c:	c1 ea 04             	shr    $0x4,%edx
80102b8f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b92:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b95:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 03                	mov    %eax,(%ebx)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 43 04             	mov    %eax,0x4(%ebx)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 43 08             	mov    %eax,0x8(%ebx)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 43 0c             	mov    %eax,0xc(%ebx)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bbb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 16 11 80    	push   0x801116e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c14:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 27 1b 00 00       	call   80104760 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 16 11 80    	push   0x801116d4
80102c7d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave
80102cca:	c3                   	ret
80102ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 77 73 10 80       	push   $0x80107377
80102cdf:	68 a0 16 11 80       	push   $0x801116a0
80102ce4:	e8 f7 16 00 00       	call   801043e0 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 7b e8 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d07:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d2e:	00 
80102d2f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave
80102d66:	c3                   	ret
80102d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6e:	00 
80102d6f:	90                   	nop

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 16 11 80       	push   $0x801116a0
80102d7b:	e8 50 18 00 00       	call   801045d0 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 16 11 80       	push   $0x801116a0
80102d90:	68 a0 16 11 80       	push   $0x801116a0
80102d95:	e8 b6 12 00 00       	call   80104050 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102dab:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102dc7:	68 a0 16 11 80       	push   $0x801116a0
80102dcc:	e8 9f 17 00 00       	call   80104570 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave
80102dd5:	c3                   	ret
80102dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ddd:	00 
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 16 11 80       	push   $0x801116a0
80102dee:	e8 dd 17 00 00       	call   801045d0 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 16 11 80       	push   $0x801116a0
80102e2c:	e8 3f 17 00 00       	call   80104570 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 16 11 80       	push   $0x801116a0
80102e46:	e8 85 17 00 00       	call   801045d0 <acquire>
    log.committing = 0;
80102e4b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e52:	00 00 00 
    wakeup(&log);
80102e55:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e5c:	e8 af 12 00 00       	call   80104110 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e68:	e8 03 17 00 00       	call   80104570 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret
80102e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ea4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 97 18 00 00       	call   80104760 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 16 11 80       	push   $0x801116a0
80102f18:	e8 f3 11 00 00       	call   80104110 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f24:	e8 47 16 00 00       	call   80104570 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 7b 73 10 80       	push   $0x8010737b
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f48:	00 
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	7f 7d                	jg     80102fe2 <log_write+0x92>
80102f65:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f6a:	83 e8 01             	sub    $0x1,%eax
80102f6d:	39 c2                	cmp    %eax,%edx
80102f6f:	7d 71                	jge    80102fe2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f71:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f76:	85 c0                	test   %eax,%eax
80102f78:	7e 75                	jle    80102fef <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7a:	83 ec 0c             	sub    $0xc,%esp
80102f7d:	68 a0 16 11 80       	push   $0x801116a0
80102f82:	e8 49 16 00 00       	call   801045d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	31 c0                	xor    %eax,%eax
80102f8f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f95:	85 d2                	test   %edx,%edx
80102f97:	7f 0e                	jg     80102fa7 <log_write+0x57>
80102f99:	eb 15                	jmp    80102fb0 <log_write+0x60>
80102f9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102fb7:	39 c2                	cmp    %eax,%edx
80102fb9:	74 1c                	je     80102fd7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fbb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fc1:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fc8:	c9                   	leave
  release(&log.lock);
80102fc9:	e9 a2 15 00 00       	jmp    80104570 <release>
80102fce:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fe0:	eb d9                	jmp    80102fbb <log_write+0x6b>
    panic("too big a transaction");
80102fe2:	83 ec 0c             	sub    $0xc,%esp
80102fe5:	68 8a 73 10 80       	push   $0x8010738a
80102fea:	e8 91 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fef:	83 ec 0c             	sub    $0xc,%esp
80102ff2:	68 a0 73 10 80       	push   $0x801073a0
80102ff7:	e8 84 d3 ff ff       	call   80100380 <panic>
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 64 09 00 00       	call   80103970 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 5d 09 00 00       	call   80103970 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 bb 73 10 80       	push   $0x801073bb
8010301d:	e8 be d6 ff ff       	call   801006e0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 e9 28 00 00       	call   80105910 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 e4 08 00 00       	call   80103910 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 01 0c 00 00       	call   80103c40 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 c5 39 00 00       	call   80106a10 <switchkvm>
  seginit();
8010304b:	e8 30 39 00 00       	call   80106980 <seginit>
  lapicinit();
80103050:	e8 bb f7 ff ff       	call   80102810 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 d0 54 11 80       	push   $0x801154d0
8010307c:	e8 9f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 4a 3e 00 00       	call   80106ed0 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 80 f7 ff ff       	call   80102810 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 eb 38 00 00       	call   80106980 <seginit>
  picinit();       // disable pic
80103095:	e8 86 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 51 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 ec d9 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 47 2b 00 00       	call   80105bf0 <uartinit>
  pinit();         // process table
801030a9:	e8 42 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 dd 27 00 00       	call   80105890 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 a3 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801030bd:	e8 0e f1 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c a4 10 80       	push   $0x8010a48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 87 16 00 00       	call   80104760 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030eb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 f2 07 00 00       	call   80103910 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 69 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010313b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 fa f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 3e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103182:	e8 39 08 00 00       	call   801039c0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031af:	00 
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 df                	cmp    %ebx,%edi
801031b4:	73 42                	jae    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 cf 73 10 80       	push   $0x801073cf
801031c3:	56                   	push   %esi
801031c4:	e8 47 15 00 00       	call   80104710 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret
80103204:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010320b:	00 
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 58 01 00 00    	je     801033b8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 3d 01 00 00    	je     801033a8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103277:	6a 04                	push   $0x4
80103279:	68 d4 73 10 80       	push   $0x801073d4
8010327e:	50                   	push   %eax
8010327f:	e8 8c 14 00 00       	call   80104710 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 19 01 00 00    	jne    801033a8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 06 01 00 00    	jne    801033a8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 f8                	cmp    %edi,%eax
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 d8 00 00 00    	jne    801033a8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032dc:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032ee:	01 d7                	add    %edx,%edi
801032f0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801032f2:	bf 01 00 00 00       	mov    $0x1,%edi
801032f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032fe:	00 
801032ff:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103300:	39 d0                	cmp    %edx,%eax
80103302:	73 19                	jae    8010331d <mpinit+0x10d>
    switch(*p){
80103304:	0f b6 08             	movzbl (%eax),%ecx
80103307:	80 f9 02             	cmp    $0x2,%cl
8010330a:	0f 84 80 00 00 00    	je     80103390 <mpinit+0x180>
80103310:	77 6e                	ja     80103380 <mpinit+0x170>
80103312:	84 c9                	test   %cl,%cl
80103314:	74 3a                	je     80103350 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103316:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103319:	39 d0                	cmp    %edx,%eax
8010331b:	72 e7                	jb     80103304 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010331d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103320:	85 ff                	test   %edi,%edi
80103322:	0f 84 dd 00 00 00    	je     80103405 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103328:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010332c:	74 15                	je     80103343 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	b8 70 00 00 00       	mov    $0x70,%eax
80103333:	ba 22 00 00 00       	mov    $0x22,%edx
80103338:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103339:	ba 23 00 00 00       	mov    $0x23,%edx
8010333e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010333f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103342:	ee                   	out    %al,(%dx)
  }
}
80103343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103346:	5b                   	pop    %ebx
80103347:	5e                   	pop    %esi
80103348:	5f                   	pop    %edi
80103349:	5d                   	pop    %ebp
8010334a:	c3                   	ret
8010334b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103350:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103356:	83 f9 07             	cmp    $0x7,%ecx
80103359:	7f 19                	jg     80103374 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010335b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103361:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103365:	83 c1 01             	add    $0x1,%ecx
80103368:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336e:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
      p += sizeof(struct mpproc);
80103374:	83 c0 14             	add    $0x14,%eax
      continue;
80103377:	eb 87                	jmp    80103300 <mpinit+0xf0>
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103380:	83 e9 03             	sub    $0x3,%ecx
80103383:	80 f9 01             	cmp    $0x1,%cl
80103386:	76 8e                	jbe    80103316 <mpinit+0x106>
80103388:	31 ff                	xor    %edi,%edi
8010338a:	e9 71 ff ff ff       	jmp    80103300 <mpinit+0xf0>
8010338f:	90                   	nop
      ioapicid = ioapic->apicno;
80103390:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103394:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103397:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010339d:	e9 5e ff ff ff       	jmp    80103300 <mpinit+0xf0>
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033a8:	83 ec 0c             	sub    $0xc,%esp
801033ab:	68 d9 73 10 80       	push   $0x801073d9
801033b0:	e8 cb cf ff ff       	call   80100380 <panic>
801033b5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033bd:	eb 0b                	jmp    801033ca <mpinit+0x1ba>
801033bf:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 de                	je     801033a8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 cf 73 10 80       	push   $0x801073cf
801033d7:	53                   	push   %ebx
801033d8:	e8 33 13 00 00       	call   80104710 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1b0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ed:	00 
801033ee:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1b0>
80103400:	e9 5b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 3c 77 10 80       	push   $0x8010773c
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 75 08             	mov    0x8(%ebp),%esi
8010344c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103455:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 20 da ff ff       	call   80100e80 <filealloc>
80103460:	89 06                	mov    %eax,(%esi)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a5 00 00 00    	je     8010350f <pipealloc+0xcf>
8010346a:	e8 11 da ff ff       	call   80100e80 <filealloc>
8010346f:	89 07                	mov    %eax,(%edi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 84 00 00 00    	je     801034fd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c3                	mov    %eax,%ebx
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 a0 00 00 00    	je     80103528 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 f1 73 10 80       	push   $0x801073f1
801034b8:	50                   	push   %eax
801034b9:	e8 22 0f 00 00       	call   801043e0 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 06                	mov    (%esi),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 06                	mov    (%esi),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 06                	mov    (%esi),%eax
801034d7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 07                	mov    (%edi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 07                	mov    (%edi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 07                	mov    (%edi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 07                	mov    (%edi),%eax
801034f0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034f3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret
  if(*f0)
801034fd:	8b 06                	mov    (%esi),%eax
801034ff:	85 c0                	test   %eax,%eax
80103501:	74 1e                	je     80103521 <pipealloc+0xe1>
    fileclose(*f0);
80103503:	83 ec 0c             	sub    $0xc,%esp
80103506:	50                   	push   %eax
80103507:	e8 34 da ff ff       	call   80100f40 <fileclose>
8010350c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010350f:	8b 07                	mov    (%edi),%eax
80103511:	85 c0                	test   %eax,%eax
80103513:	74 0c                	je     80103521 <pipealloc+0xe1>
    fileclose(*f1);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	50                   	push   %eax
80103519:	e8 22 da ff ff       	call   80100f40 <fileclose>
8010351e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103526:	eb cd                	jmp    801034f5 <pipealloc+0xb5>
  if(*f0)
80103528:	8b 06                	mov    (%esi),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 d5                	jne    80103503 <pipealloc+0xc3>
8010352e:	eb df                	jmp    8010350f <pipealloc+0xcf>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 8c 10 00 00       	call   801045d0 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 ac 0b 00 00       	call   80104110 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 e7 0f 00 00       	jmp    80104570 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 d7 0f 00 00       	call   80104570 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 26 ef ff ff       	jmp    801024d0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 47 0b 00 00       	call   80104110 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035df:	53                   	push   %ebx
801035e0:	e8 eb 0f 00 00       	call   801045d0 <acquire>
  for(i = 0; i < n; i++){
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 ff                	test   %edi,%edi
801035ea:	0f 8e ce 00 00 00    	jle    801036be <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035f9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035ff:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103602:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103605:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010360b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103611:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103617:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010361d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103620:	0f 85 b6 00 00 00    	jne    801036dc <pipewrite+0x10c>
80103626:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103629:	eb 3b                	jmp    80103666 <pipewrite+0x96>
8010362b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103630:	e8 5b 03 00 00       	call   80103990 <myproc>
80103635:	8b 48 24             	mov    0x24(%eax),%ecx
80103638:	85 c9                	test   %ecx,%ecx
8010363a:	75 34                	jne    80103670 <pipewrite+0xa0>
      wakeup(&p->nread);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	56                   	push   %esi
80103640:	e8 cb 0a 00 00       	call   80104110 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103645:	58                   	pop    %eax
80103646:	5a                   	pop    %edx
80103647:	53                   	push   %ebx
80103648:	57                   	push   %edi
80103649:	e8 02 0a 00 00       	call   80104050 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103654:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	05 00 02 00 00       	add    $0x200,%eax
80103662:	39 c2                	cmp    %eax,%edx
80103664:	75 2a                	jne    80103690 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103666:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010366c:	85 c0                	test   %eax,%eax
8010366e:	75 c0                	jne    80103630 <pipewrite+0x60>
        release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	53                   	push   %ebx
80103674:	e8 f7 0e 00 00       	call   80104570 <release>
        return -1;
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103684:	5b                   	pop    %ebx
80103685:	5e                   	pop    %esi
80103686:	5f                   	pop    %edi
80103687:	5d                   	pop    %ebp
80103688:	c3                   	ret
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103690:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103693:	8d 42 01             	lea    0x1(%edx),%eax
80103696:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010369c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010369f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036a8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036ac:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036b3:	39 c1                	cmp    %eax,%ecx
801036b5:	0f 85 50 ff ff ff    	jne    8010360b <pipewrite+0x3b>
801036bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036be:	83 ec 0c             	sub    $0xc,%esp
801036c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c7:	50                   	push   %eax
801036c8:	e8 43 0a 00 00       	call   80104110 <wakeup>
  release(&p->lock);
801036cd:	89 1c 24             	mov    %ebx,(%esp)
801036d0:	e8 9b 0e 00 00       	call   80104570 <release>
  return n;
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	89 f8                	mov    %edi,%eax
801036da:	eb a5                	jmp    80103681 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036df:	eb b2                	jmp    80103693 <pipewrite+0xc3>
801036e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036e8:	00 
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103706:	e8 c5 0e 00 00       	call   801045d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010371a:	74 2f                	je     8010374b <piperead+0x5b>
8010371c:	eb 37                	jmp    80103755 <piperead+0x65>
8010371e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103720:	e8 6b 02 00 00       	call   80103990 <myproc>
80103725:	8b 40 24             	mov    0x24(%eax),%eax
80103728:	85 c0                	test   %eax,%eax
8010372a:	0f 85 80 00 00 00    	jne    801037b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 16 09 00 00       	call   80104050 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103749:	75 0a                	jne    80103755 <piperead+0x65>
8010374b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103751:	85 d2                	test   %edx,%edx
80103753:	75 cb                	jne    80103720 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103755:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	85 c9                	test   %ecx,%ecx
8010375c:	7f 26                	jg     80103784 <piperead+0x94>
8010375e:	eb 2c                	jmp    8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103760:	8d 48 01             	lea    0x1(%eax),%ecx
80103763:	25 ff 01 00 00       	and    $0x1ff,%eax
80103768:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010376e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103773:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103776:	83 c3 01             	add    $0x1,%ebx
80103779:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377c:	74 0e                	je     8010378c <piperead+0x9c>
8010377e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103784:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378a:	75 d4                	jne    80103760 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103795:	50                   	push   %eax
80103796:	e8 75 09 00 00       	call   80104110 <wakeup>
  release(&p->lock);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 cd 0d 00 00       	call   80104570 <release>
  return i;
801037a3:	83 c4 10             	add    $0x10,%esp
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret
      release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037b8:	56                   	push   %esi
801037b9:	e8 b2 0d 00 00       	call   80104570 <release>
      return -1;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	89 d8                	mov    %ebx,%eax
801037c6:	5b                   	pop    %ebx
801037c7:	5e                   	pop    %esi
801037c8:	5f                   	pop    %edi
801037c9:	5d                   	pop    %ebp
801037ca:	c3                   	ret
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037dc:	68 20 1d 11 80       	push   $0x80111d20
801037e1:	e8 ea 0d 00 00       	call   801045d0 <acquire>
801037e6:	83 c4 10             	add    $0x10,%esp
801037e9:	eb 10                	jmp    801037fb <allocproc+0x2b>
801037eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	83 c3 7c             	add    $0x7c,%ebx
801037f3:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801037f9:	74 75                	je     80103870 <allocproc+0xa0>
    if(p->state == UNUSED)
801037fb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	75 ee                	jne    801037f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103802:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103807:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010380a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103811:	89 43 10             	mov    %eax,0x10(%ebx)
80103814:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103817:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010381c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103822:	e8 49 0d 00 00       	call   80104570 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103827:	e8 64 ee ff ff       	call   80102690 <kalloc>
8010382c:	83 c4 10             	add    $0x10,%esp
8010382f:	89 43 08             	mov    %eax,0x8(%ebx)
80103832:	85 c0                	test   %eax,%eax
80103834:	74 53                	je     80103889 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103836:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010383c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103844:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103847:	c7 40 14 82 58 10 80 	movl   $0x80105882,0x14(%eax)
  p->context = (struct context*)sp;
8010384e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103851:	6a 14                	push   $0x14
80103853:	6a 00                	push   $0x0
80103855:	50                   	push   %eax
80103856:	e8 75 0e 00 00       	call   801046d0 <memset>
  p->context->eip = (uint)forkret;
8010385b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010385e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103861:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
80103868:	89 d8                	mov    %ebx,%eax
8010386a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386d:	c9                   	leave
8010386e:	c3                   	ret
8010386f:	90                   	nop
  release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103873:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103875:	68 20 1d 11 80       	push   $0x80111d20
8010387a:	e8 f1 0c 00 00       	call   80104570 <release>
  return 0;
8010387f:	83 c4 10             	add    $0x10,%esp
}
80103882:	89 d8                	mov    %ebx,%eax
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave
80103888:	c3                   	ret
    p->state = UNUSED;
80103889:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103890:	31 db                	xor    %ebx,%ebx
80103892:	eb ee                	jmp    80103882 <allocproc+0xb2>
80103894:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010389b:	00 
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038a6:	68 20 1d 11 80       	push   $0x80111d20
801038ab:	e8 c0 0c 00 00       	call   80104570 <release>

  if (first) {
801038b0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	75 04                	jne    801038c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038bc:	c9                   	leave
801038bd:	c3                   	ret
801038be:	66 90                	xchg   %ax,%ax
    first = 0;
801038c0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038c7:	00 00 00 
    iinit(ROOTDEV);
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	6a 01                	push   $0x1
801038cf:	e8 dc dc ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
801038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038db:	e8 f0 f3 ff ff       	call   80102cd0 <initlog>
}
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	c9                   	leave
801038e4:	c3                   	ret
801038e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038ec:	00 
801038ed:	8d 76 00             	lea    0x0(%esi),%esi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 f6 73 10 80       	push   $0x801073f6
801038fb:	68 20 1d 11 80       	push   $0x80111d20
80103900:	e8 db 0a 00 00       	call   801043e0 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave
80103909:	c3                   	ret
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 46                	jne    80103962 <mycpu+0x52>
  apicid = lapicid();
8010391c:	e8 df ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 2a                	jle    80103955 <mycpu+0x45>
8010392b:	31 d2                	xor    %edx,%edx
8010392d:	eb 08                	jmp    80103937 <mycpu+0x27>
8010392f:	90                   	nop
80103930:	83 c2 01             	add    $0x1,%edx
80103933:	39 f2                	cmp    %esi,%edx
80103935:	74 1e                	je     80103955 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103937:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010393d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103944:	39 c3                	cmp    %eax,%ebx
80103946:	75 e8                	jne    80103930 <mycpu+0x20>
}
80103948:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010394b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103951:	5b                   	pop    %ebx
80103952:	5e                   	pop    %esi
80103953:	5d                   	pop    %ebp
80103954:	c3                   	ret
  panic("unknown apicid\n");
80103955:	83 ec 0c             	sub    $0xc,%esp
80103958:	68 fd 73 10 80       	push   $0x801073fd
8010395d:	e8 1e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 5c 77 10 80       	push   $0x8010775c
8010396a:	e8 11 ca ff ff       	call   80100380 <panic>
8010396f:	90                   	nop

80103970 <cpuid>:
cpuid() {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103976:	e8 95 ff ff ff       	call   80103910 <mycpu>
}
8010397b:	c9                   	leave
  return mycpu()-cpus;
8010397c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103981:	c1 f8 04             	sar    $0x4,%eax
80103984:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010398a:	c3                   	ret
8010398b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103990 <myproc>:
myproc(void) {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103997:	e8 e4 0a 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010399c:	e8 6f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a7:	e8 24 0b 00 00       	call   801044d0 <popcli>
}
801039ac:	89 d8                	mov    %ebx,%eax
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave
801039b2:	c3                   	ret
801039b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039ba:	00 
801039bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039c0 <userinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039c7:	e8 04 fe ff ff       	call   801037d0 <allocproc>
801039cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ce:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
801039d3:	e8 78 34 00 00       	call   80106e50 <setupkvm>
801039d8:	89 43 04             	mov    %eax,0x4(%ebx)
801039db:	85 c0                	test   %eax,%eax
801039dd:	0f 84 bd 00 00 00    	je     80103aa0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e3:	83 ec 04             	sub    $0x4,%esp
801039e6:	68 2c 00 00 00       	push   $0x2c
801039eb:	68 60 a4 10 80       	push   $0x8010a460
801039f0:	50                   	push   %eax
801039f1:	e8 3a 31 00 00       	call   80106b30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ff:	6a 4c                	push   $0x4c
80103a01:	6a 00                	push   $0x0
80103a03:	ff 73 18             	push   0x18(%ebx)
80103a06:	e8 c5 0c 00 00       	call   801046d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a31:	8b 43 18             	mov    0x18(%ebx),%eax
80103a34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a50:	8b 43 18             	mov    0x18(%ebx),%eax
80103a53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a5d:	6a 10                	push   $0x10
80103a5f:	68 26 74 10 80       	push   $0x80107426
80103a64:	50                   	push   %eax
80103a65:	e8 16 0e 00 00       	call   80104880 <safestrcpy>
  p->cwd = namei("/");
80103a6a:	c7 04 24 2f 74 10 80 	movl   $0x8010742f,(%esp)
80103a71:	e8 3a e6 ff ff       	call   801020b0 <namei>
80103a76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a80:	e8 4b 0b 00 00       	call   801045d0 <acquire>
  p->state = RUNNABLE;
80103a85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a93:	e8 d8 0a 00 00       	call   80104570 <release>
}
80103a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	c9                   	leave
80103a9f:	c3                   	ret
    panic("userinit: out of memory?");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 0d 74 10 80       	push   $0x8010740d
80103aa8:	e8 d3 c8 ff ff       	call   80100380 <panic>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <growproc>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ab8:	e8 c3 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103abd:	e8 4e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac8:	e8 03 0a 00 00       	call   801044d0 <popcli>
  sz = curproc->sz;
80103acd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103acf:	85 f6                	test   %esi,%esi
80103ad1:	7f 1d                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad3:	75 3b                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ad8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ada:	53                   	push   %ebx
80103adb:	e8 40 2f 00 00       	call   80106a20 <switchuvm>
  return 0;
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	31 c0                	xor    %eax,%eax
}
80103ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 81 31 00 00       	call   80106c80 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 cf                	jne    80103ad5 <growproc+0x25>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb d8                	jmp    80103ae5 <growproc+0x35>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 81 32 00 00       	call   80106da0 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 af                	jne    80103ad5 <growproc+0x25>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b2f:	00 

80103b30 <fork>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b39:	e8 42 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103b3e:	e8 cd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b49:	e8 82 09 00 00       	call   801044d0 <popcli>
  if((np = allocproc()) == 0){
80103b4e:	e8 7d fc ff ff       	call   801037d0 <allocproc>
80103b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b56:	85 c0                	test   %eax,%eax
80103b58:	0f 84 d6 00 00 00    	je     80103c34 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	ff 33                	push   (%ebx)
80103b63:	89 c7                	mov    %eax,%edi
80103b65:	ff 73 04             	push   0x4(%ebx)
80103b68:	e8 d3 33 00 00       	call   80106f40 <copyuvm>
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	89 47 04             	mov    %eax,0x4(%edi)
80103b73:	85 c0                	test   %eax,%eax
80103b75:	0f 84 9a 00 00 00    	je     80103c15 <fork+0xe5>
  np->sz = curproc->sz;
80103b7b:	8b 03                	mov    (%ebx),%eax
80103b7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b85:	89 c8                	mov    %ecx,%eax
80103b87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b96:	8b 40 18             	mov    0x18(%eax),%eax
80103b99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 3f d3 ff ff       	call   80100ef0 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 cf db ff ff       	call   801017a0 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 9a 0c 00 00       	call   80104880 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bf0:	e8 db 09 00 00       	call   801045d0 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c03:	e8 68 09 00 00       	call   80104570 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret
    kfree(np->kstack);
80103c15:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c18:	83 ec 0c             	sub    $0xc,%esp
80103c1b:	ff 73 08             	push   0x8(%ebx)
80103c1e:	e8 ad e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c23:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c2a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c2d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c34:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c39:	eb d0                	jmp    80103c0b <fork+0xdb>
80103c3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c40 <scheduler>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c49:	e8 c2 fc ff ff       	call   80103910 <mycpu>
  c->proc = 0;
80103c4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c55:	00 00 00 
  struct cpu *c = mycpu();
80103c58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c5a:	8d 78 04             	lea    0x4(%eax),%edi
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c60:	fb                   	sti
    acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c64:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c69:	68 20 1d 11 80       	push   $0x80111d20
80103c6e:	e8 5d 09 00 00       	call   801045d0 <acquire>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c7d:	00 
80103c7e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c84:	75 33                	jne    80103cb9 <scheduler+0x79>
      switchuvm(p);
80103c86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c8f:	53                   	push   %ebx
80103c90:	e8 8b 2d 00 00       	call   80106a20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c95:	58                   	pop    %eax
80103c96:	5a                   	pop    %edx
80103c97:	ff 73 1c             	push   0x1c(%ebx)
80103c9a:	57                   	push   %edi
      p->state = RUNNING;
80103c9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ca2:	e8 34 0c 00 00       	call   801048db <swtch>
      switchkvm();
80103ca7:	e8 64 2d 00 00       	call   80106a10 <switchkvm>
      c->proc = 0;
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb9:	83 c3 7c             	add    $0x7c,%ebx
80103cbc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103cc2:	75 bc                	jne    80103c80 <scheduler+0x40>
    release(&ptable.lock);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 20 1d 11 80       	push   $0x80111d20
80103ccc:	e8 9f 08 00 00       	call   80104570 <release>
    sti();
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	eb 8a                	jmp    80103c60 <scheduler+0x20>
80103cd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cdd:	00 
80103cde:	66 90                	xchg   %ax,%ax

80103ce0 <sched>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 96 07 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103cea:	e8 21 fc ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf5:	e8 d6 07 00 00       	call   801044d0 <popcli>
  if(!holding(&ptable.lock))
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 20 1d 11 80       	push   $0x80111d20
80103d02:	e8 29 08 00 00       	call   80104530 <holding>
80103d07:	83 c4 10             	add    $0x10,%esp
80103d0a:	85 c0                	test   %eax,%eax
80103d0c:	74 4f                	je     80103d5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d0e:	e8 fd fb ff ff       	call   80103910 <mycpu>
80103d13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d1a:	75 68                	jne    80103d84 <sched+0xa4>
  if(p->state == RUNNING)
80103d1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d20:	74 55                	je     80103d77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d22:	9c                   	pushf
80103d23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d24:	f6 c4 02             	test   $0x2,%ah
80103d27:	75 41                	jne    80103d6a <sched+0x8a>
  intena = mycpu()->intena;
80103d29:	e8 e2 fb ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d37:	e8 d4 fb ff ff       	call   80103910 <mycpu>
80103d3c:	83 ec 08             	sub    $0x8,%esp
80103d3f:	ff 70 04             	push   0x4(%eax)
80103d42:	53                   	push   %ebx
80103d43:	e8 93 0b 00 00       	call   801048db <swtch>
  mycpu()->intena = intena;
80103d48:	e8 c3 fb ff ff       	call   80103910 <mycpu>
}
80103d4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret
    panic("sched ptable.lock");
80103d5d:	83 ec 0c             	sub    $0xc,%esp
80103d60:	68 31 74 10 80       	push   $0x80107431
80103d65:	e8 16 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 5d 74 10 80       	push   $0x8010745d
80103d72:	e8 09 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 4f 74 10 80       	push   $0x8010744f
80103d7f:	e8 fc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 43 74 10 80       	push   $0x80107443
80103d8c:	e8 ef c5 ff ff       	call   80100380 <panic>
80103d91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d98:	00 
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <exit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103da9:	e8 e2 fb ff ff       	call   80103990 <myproc>
  if(curproc == initproc)
80103dae:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103db4:	0f 84 fd 00 00 00    	je     80103eb7 <exit+0x117>
80103dba:	89 c3                	mov    %eax,%ebx
80103dbc:	8d 70 28             	lea    0x28(%eax),%esi
80103dbf:	8d 78 68             	lea    0x68(%eax),%edi
80103dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dc8:	8b 06                	mov    (%esi),%eax
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 12                	je     80103de0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	50                   	push   %eax
80103dd2:	e8 69 d1 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103dd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ddd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103de0:	83 c6 04             	add    $0x4,%esi
80103de3:	39 f7                	cmp    %esi,%edi
80103de5:	75 e1                	jne    80103dc8 <exit+0x28>
  begin_op();
80103de7:	e8 84 ef ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103dec:	83 ec 0c             	sub    $0xc,%esp
80103def:	ff 73 68             	push   0x68(%ebx)
80103df2:	e8 09 db ff ff       	call   80101900 <iput>
  end_op();
80103df7:	e8 e4 ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103dfc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e03:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e0a:	e8 c1 07 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103e0f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e12:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e15:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e1a:	eb 0e                	jmp    80103e2a <exit+0x8a>
80103e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e20:	83 c0 7c             	add    $0x7c,%eax
80103e23:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e28:	74 1c                	je     80103e46 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e2e:	75 f0                	jne    80103e20 <exit+0x80>
80103e30:	3b 50 20             	cmp    0x20(%eax),%edx
80103e33:	75 eb                	jne    80103e20 <exit+0x80>
      p->state = RUNNABLE;
80103e35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3c:	83 c0 7c             	add    $0x7c,%eax
80103e3f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e44:	75 e4                	jne    80103e2a <exit+0x8a>
      p->parent = initproc;
80103e46:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e51:	eb 10                	jmp    80103e63 <exit+0xc3>
80103e53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e58:	83 c2 7c             	add    $0x7c,%edx
80103e5b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103e61:	74 3b                	je     80103e9e <exit+0xfe>
    if(p->parent == curproc){
80103e63:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e66:	75 f0                	jne    80103e58 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e68:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e6c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e6f:	75 e7                	jne    80103e58 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e71:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e76:	eb 12                	jmp    80103e8a <exit+0xea>
80103e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e7f:	00 
80103e80:	83 c0 7c             	add    $0x7c,%eax
80103e83:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103e88:	74 ce                	je     80103e58 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0xe0>
80103e90:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e93:	75 eb                	jne    80103e80 <exit+0xe0>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e9c:	eb e2                	jmp    80103e80 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e9e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ea5:	e8 36 fe ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 7e 74 10 80       	push   $0x8010747e
80103eb2:	e8 c9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 71 74 10 80       	push   $0x80107471
80103ebf:	e8 bc c4 ff ff       	call   80100380 <panic>
80103ec4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ecb:	00 
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <wait>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	56                   	push   %esi
80103ed4:	53                   	push   %ebx
  pushcli();
80103ed5:	e8 a6 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103eda:	e8 31 fa ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103edf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ee5:	e8 e6 05 00 00       	call   801044d0 <popcli>
  acquire(&ptable.lock);
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 20 1d 11 80       	push   $0x80111d20
80103ef2:	e8 d9 06 00 00       	call   801045d0 <acquire>
80103ef7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103efa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f01:	eb 10                	jmp    80103f13 <wait+0x43>
80103f03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f08:	83 c3 7c             	add    $0x7c,%ebx
80103f0b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f11:	74 1b                	je     80103f2e <wait+0x5e>
      if(p->parent != curproc)
80103f13:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f16:	75 f0                	jne    80103f08 <wait+0x38>
      if(p->state == ZOMBIE){
80103f18:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f1c:	74 62                	je     80103f80 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f21:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f26:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103f2c:	75 e5                	jne    80103f13 <wait+0x43>
    if(!havekids || curproc->killed){
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	0f 84 a0 00 00 00    	je     80103fd6 <wait+0x106>
80103f36:	8b 46 24             	mov    0x24(%esi),%eax
80103f39:	85 c0                	test   %eax,%eax
80103f3b:	0f 85 95 00 00 00    	jne    80103fd6 <wait+0x106>
  pushcli();
80103f41:	e8 3a 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f46:	e8 c5 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f51:	e8 7a 05 00 00       	call   801044d0 <popcli>
  if(p == 0)
80103f56:	85 db                	test   %ebx,%ebx
80103f58:	0f 84 8f 00 00 00    	je     80103fed <wait+0x11d>
  p->chan = chan;
80103f5e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f61:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f68:	e8 73 fd ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103f6d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f74:	eb 84                	jmp    80103efa <wait+0x2a>
80103f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f7d:	00 
80103f7e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80103f80:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f83:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f86:	ff 73 08             	push   0x8(%ebx)
80103f89:	e8 42 e5 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
80103f8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f95:	5a                   	pop    %edx
80103f96:	ff 73 04             	push   0x4(%ebx)
80103f99:	e8 32 2e 00 00       	call   80106dd0 <freevm>
        p->pid = 0;
80103f9e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fa5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fb0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fbe:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fc5:	e8 a6 05 00 00       	call   80104570 <release>
        return pid;
80103fca:	83 c4 10             	add    $0x10,%esp
}
80103fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd0:	89 f0                	mov    %esi,%eax
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5d                   	pop    %ebp
80103fd5:	c3                   	ret
      release(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fd9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fde:	68 20 1d 11 80       	push   $0x80111d20
80103fe3:	e8 88 05 00 00       	call   80104570 <release>
      return -1;
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	eb e0                	jmp    80103fcd <wait+0xfd>
    panic("sleep");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 8a 74 10 80       	push   $0x8010748a
80103ff5:	e8 86 c3 ff ff       	call   80100380 <panic>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104000 <yield>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104007:	68 20 1d 11 80       	push   $0x80111d20
8010400c:	e8 bf 05 00 00       	call   801045d0 <acquire>
  pushcli();
80104011:	e8 6a 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104016:	e8 f5 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010401b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104021:	e8 aa 04 00 00       	call   801044d0 <popcli>
  myproc()->state = RUNNABLE;
80104026:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010402d:	e8 ae fc ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
80104032:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104039:	e8 32 05 00 00       	call   80104570 <release>
}
8010403e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104041:	83 c4 10             	add    $0x10,%esp
80104044:	c9                   	leave
80104045:	c3                   	ret
80104046:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010404d:	00 
8010404e:	66 90                	xchg   %ax,%ax

80104050 <sleep>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	8b 7d 08             	mov    0x8(%ebp),%edi
8010405c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010405f:	e8 1c 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104064:	e8 a7 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104069:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010406f:	e8 5c 04 00 00       	call   801044d0 <popcli>
  if(p == 0)
80104074:	85 db                	test   %ebx,%ebx
80104076:	0f 84 87 00 00 00    	je     80104103 <sleep+0xb3>
  if(lk == 0)
8010407c:	85 f6                	test   %esi,%esi
8010407e:	74 76                	je     801040f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104080:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104086:	74 50                	je     801040d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 20 1d 11 80       	push   $0x80111d20
80104090:	e8 3b 05 00 00       	call   801045d0 <acquire>
    release(lk);
80104095:	89 34 24             	mov    %esi,(%esp)
80104098:	e8 d3 04 00 00       	call   80104570 <release>
  p->chan = chan;
8010409d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040a7:	e8 34 fc ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040b3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040ba:	e8 b1 04 00 00       	call   80104570 <release>
    acquire(lk);
801040bf:	89 75 08             	mov    %esi,0x8(%ebp)
801040c2:	83 c4 10             	add    $0x10,%esp
}
801040c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c8:	5b                   	pop    %ebx
801040c9:	5e                   	pop    %esi
801040ca:	5f                   	pop    %edi
801040cb:	5d                   	pop    %ebp
    acquire(lk);
801040cc:	e9 ff 04 00 00       	jmp    801045d0 <acquire>
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e2:	e8 f9 fb ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f1:	5b                   	pop    %ebx
801040f2:	5e                   	pop    %esi
801040f3:	5f                   	pop    %edi
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret
    panic("sleep without lk");
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	68 90 74 10 80       	push   $0x80107490
801040fe:	e8 7d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104103:	83 ec 0c             	sub    $0xc,%esp
80104106:	68 8a 74 10 80       	push   $0x8010748a
8010410b:	e8 70 c2 ff ff       	call   80100380 <panic>

80104110 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010411a:	68 20 1d 11 80       	push   $0x80111d20
8010411f:	e8 ac 04 00 00       	call   801045d0 <acquire>
80104124:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104127:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010412c:	eb 0c                	jmp    8010413a <wakeup+0x2a>
8010412e:	66 90                	xchg   %ax,%ax
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104138:	74 1c                	je     80104156 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010413a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010413e:	75 f0                	jne    80104130 <wakeup+0x20>
80104140:	3b 58 20             	cmp    0x20(%eax),%ebx
80104143:	75 eb                	jne    80104130 <wakeup+0x20>
      p->state = RUNNABLE;
80104145:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	83 c0 7c             	add    $0x7c,%eax
8010414f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104154:	75 e4                	jne    8010413a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104156:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010415d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104160:	c9                   	leave
  release(&ptable.lock);
80104161:	e9 0a 04 00 00       	jmp    80104570 <release>
80104166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010416d:	00 
8010416e:	66 90                	xchg   %ax,%ax

80104170 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010417a:	68 20 1d 11 80       	push   $0x80111d20
8010417f:	e8 4c 04 00 00       	call   801045d0 <acquire>
80104184:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104187:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010418c:	eb 0c                	jmp    8010419a <kill+0x2a>
8010418e:	66 90                	xchg   %ax,%ax
80104190:	83 c0 7c             	add    $0x7c,%eax
80104193:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104198:	74 36                	je     801041d0 <kill+0x60>
    if(p->pid == pid){
8010419a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010419d:	75 f1                	jne    80104190 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010419f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041aa:	75 07                	jne    801041b3 <kill+0x43>
        p->state = RUNNABLE;
801041ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 20 1d 11 80       	push   $0x80111d20
801041bb:	e8 b0 03 00 00       	call   80104570 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041c3:	83 c4 10             	add    $0x10,%esp
801041c6:	31 c0                	xor    %eax,%eax
}
801041c8:	c9                   	leave
801041c9:	c3                   	ret
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	68 20 1d 11 80       	push   $0x80111d20
801041d8:	e8 93 03 00 00       	call   80104570 <release>
}
801041dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041e0:	83 c4 10             	add    $0x10,%esp
801041e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e8:	c9                   	leave
801041e9:	c3                   	ret
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041f8:	53                   	push   %ebx
801041f9:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
801041fe:	83 ec 3c             	sub    $0x3c,%esp
80104201:	eb 24                	jmp    80104227 <procdump+0x37>
80104203:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 4f 76 10 80       	push   $0x8010764f
80104210:	e8 cb c4 ff ff       	call   801006e0 <cprintf>
80104215:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104218:	83 c3 7c             	add    $0x7c,%ebx
8010421b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104221:	0f 84 81 00 00 00    	je     801042a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104227:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010422a:	85 c0                	test   %eax,%eax
8010422c:	74 ea                	je     80104218 <procdump+0x28>
      state = "???";
8010422e:	ba a1 74 10 80       	mov    $0x801074a1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104233:	83 f8 05             	cmp    $0x5,%eax
80104236:	77 11                	ja     80104249 <procdump+0x59>
80104238:	8b 14 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%edx
      state = "???";
8010423f:	b8 a1 74 10 80       	mov    $0x801074a1,%eax
80104244:	85 d2                	test   %edx,%edx
80104246:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104249:	53                   	push   %ebx
8010424a:	52                   	push   %edx
8010424b:	ff 73 a4             	push   -0x5c(%ebx)
8010424e:	68 a5 74 10 80       	push   $0x801074a5
80104253:	e8 88 c4 ff ff       	call   801006e0 <cprintf>
    if(p->state == SLEEPING){
80104258:	83 c4 10             	add    $0x10,%esp
8010425b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010425f:	75 a7                	jne    80104208 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104261:	83 ec 08             	sub    $0x8,%esp
80104264:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104267:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010426a:	50                   	push   %eax
8010426b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010426e:	8b 40 0c             	mov    0xc(%eax),%eax
80104271:	83 c0 08             	add    $0x8,%eax
80104274:	50                   	push   %eax
80104275:	e8 86 01 00 00       	call   80104400 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010427a:	83 c4 10             	add    $0x10,%esp
8010427d:	8d 76 00             	lea    0x0(%esi),%esi
80104280:	8b 17                	mov    (%edi),%edx
80104282:	85 d2                	test   %edx,%edx
80104284:	74 82                	je     80104208 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104286:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104289:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010428c:	52                   	push   %edx
8010428d:	68 e1 71 10 80       	push   $0x801071e1
80104292:	e8 49 c4 ff ff       	call   801006e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	39 f7                	cmp    %esi,%edi
8010429c:	75 e2                	jne    80104280 <procdump+0x90>
8010429e:	e9 65 ff ff ff       	jmp    80104208 <procdump+0x18>
801042a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801042a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ab:	5b                   	pop    %ebx
801042ac:	5e                   	pop    %esi
801042ad:	5f                   	pop    %edi
801042ae:	5d                   	pop    %ebp
801042af:	c3                   	ret

801042b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ba:	68 d8 74 10 80       	push   $0x801074d8
801042bf:	8d 43 04             	lea    0x4(%ebx),%eax
801042c2:	50                   	push   %eax
801042c3:	e8 18 01 00 00       	call   801043e0 <initlock>
  lk->name = name;
801042c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e1:	c9                   	leave
801042e2:	c3                   	ret
801042e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042ea:	00 
801042eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801042f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042f8:	8d 73 04             	lea    0x4(%ebx),%esi
801042fb:	83 ec 0c             	sub    $0xc,%esp
801042fe:	56                   	push   %esi
801042ff:	e8 cc 02 00 00       	call   801045d0 <acquire>
  while (lk->locked) {
80104304:	8b 13                	mov    (%ebx),%edx
80104306:	83 c4 10             	add    $0x10,%esp
80104309:	85 d2                	test   %edx,%edx
8010430b:	74 16                	je     80104323 <acquiresleep+0x33>
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104310:	83 ec 08             	sub    $0x8,%esp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	e8 36 fd ff ff       	call   80104050 <sleep>
  while (lk->locked) {
8010431a:	8b 03                	mov    (%ebx),%eax
8010431c:	83 c4 10             	add    $0x10,%esp
8010431f:	85 c0                	test   %eax,%eax
80104321:	75 ed                	jne    80104310 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104323:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104329:	e8 62 f6 ff ff       	call   80103990 <myproc>
8010432e:	8b 40 10             	mov    0x10(%eax),%eax
80104331:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104334:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104337:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010433a:	5b                   	pop    %ebx
8010433b:	5e                   	pop    %esi
8010433c:	5d                   	pop    %ebp
  release(&lk->lk);
8010433d:	e9 2e 02 00 00       	jmp    80104570 <release>
80104342:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104349:	00 
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104358:	8d 73 04             	lea    0x4(%ebx),%esi
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	56                   	push   %esi
8010435f:	e8 6c 02 00 00       	call   801045d0 <acquire>
  lk->locked = 0;
80104364:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010436a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104371:	89 1c 24             	mov    %ebx,(%esp)
80104374:	e8 97 fd ff ff       	call   80104110 <wakeup>
  release(&lk->lk);
80104379:	89 75 08             	mov    %esi,0x8(%ebp)
8010437c:	83 c4 10             	add    $0x10,%esp
}
8010437f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104382:	5b                   	pop    %ebx
80104383:	5e                   	pop    %esi
80104384:	5d                   	pop    %ebp
  release(&lk->lk);
80104385:	e9 e6 01 00 00       	jmp    80104570 <release>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	31 ff                	xor    %edi,%edi
80104396:	56                   	push   %esi
80104397:	53                   	push   %ebx
80104398:	83 ec 18             	sub    $0x18,%esp
8010439b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010439e:	8d 73 04             	lea    0x4(%ebx),%esi
801043a1:	56                   	push   %esi
801043a2:	e8 29 02 00 00       	call   801045d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043a7:	8b 03                	mov    (%ebx),%eax
801043a9:	83 c4 10             	add    $0x10,%esp
801043ac:	85 c0                	test   %eax,%eax
801043ae:	75 18                	jne    801043c8 <holdingsleep+0x38>
  release(&lk->lk);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	56                   	push   %esi
801043b4:	e8 b7 01 00 00       	call   80104570 <release>
  return r;
}
801043b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043bc:	89 f8                	mov    %edi,%eax
801043be:	5b                   	pop    %ebx
801043bf:	5e                   	pop    %esi
801043c0:	5f                   	pop    %edi
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret
801043c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801043c8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043cb:	e8 c0 f5 ff ff       	call   80103990 <myproc>
801043d0:	39 58 10             	cmp    %ebx,0x10(%eax)
801043d3:	0f 94 c0             	sete   %al
801043d6:	0f b6 c0             	movzbl %al,%eax
801043d9:	89 c7                	mov    %eax,%edi
801043db:	eb d3                	jmp    801043b0 <holdingsleep+0x20>
801043dd:	66 90                	xchg   %ax,%ax
801043df:	90                   	nop

801043e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043f9:	5d                   	pop    %ebp
801043fa:	c3                   	ret
801043fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104400 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	8b 45 08             	mov    0x8(%ebp),%eax
80104407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010440a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010440d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104412:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104417:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010441c:	76 10                	jbe    8010442e <getcallerpcs+0x2e>
8010441e:	eb 28                	jmp    80104448 <getcallerpcs+0x48>
80104420:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104426:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010442c:	77 1a                	ja     80104448 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010442e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104431:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104434:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104437:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104439:	83 f8 0a             	cmp    $0xa,%eax
8010443c:	75 e2                	jne    80104420 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010443e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104441:	c9                   	leave
80104442:	c3                   	ret
80104443:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104448:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010444b:	83 c1 28             	add    $0x28,%ecx
8010444e:	89 ca                	mov    %ecx,%edx
80104450:	29 c2                	sub    %eax,%edx
80104452:	83 e2 04             	and    $0x4,%edx
80104455:	74 11                	je     80104468 <getcallerpcs+0x68>
    pcs[i] = 0;
80104457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010445d:	83 c0 04             	add    $0x4,%eax
80104460:	39 c1                	cmp    %eax,%ecx
80104462:	74 da                	je     8010443e <getcallerpcs+0x3e>
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010446e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104471:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104478:	39 c1                	cmp    %eax,%ecx
8010447a:	75 ec                	jne    80104468 <getcallerpcs+0x68>
8010447c:	eb c0                	jmp    8010443e <getcallerpcs+0x3e>
8010447e:	66 90                	xchg   %ax,%ax

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	9c                   	pushf
80104488:	5b                   	pop    %ebx
  asm volatile("cli");
80104489:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448a:	e8 81 f4 ff ff       	call   80103910 <mycpu>
8010448f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 17                	je     801044b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104499:	e8 72 f4 ff ff       	call   80103910 <mycpu>
8010449e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a8:	c9                   	leave
801044a9:	c3                   	ret
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044b0:	e8 5b f4 ff ff       	call   80103910 <mycpu>
801044b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044c1:	eb d6                	jmp    80104499 <pushcli+0x19>
801044c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ca:	00 
801044cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044d0 <popcli>:

void
popcli(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044d6:	9c                   	pushf
801044d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044d8:	f6 c4 02             	test   $0x2,%ah
801044db:	75 35                	jne    80104512 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044dd:	e8 2e f4 ff ff       	call   80103910 <mycpu>
801044e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044e9:	78 34                	js     8010451f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044eb:	e8 20 f4 ff ff       	call   80103910 <mycpu>
801044f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044f6:	85 d2                	test   %edx,%edx
801044f8:	74 06                	je     80104500 <popcli+0x30>
    sti();
}
801044fa:	c9                   	leave
801044fb:	c3                   	ret
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104500:	e8 0b f4 ff ff       	call   80103910 <mycpu>
80104505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010450b:	85 c0                	test   %eax,%eax
8010450d:	74 eb                	je     801044fa <popcli+0x2a>
  asm volatile("sti");
8010450f:	fb                   	sti
}
80104510:	c9                   	leave
80104511:	c3                   	ret
    panic("popcli - interruptible");
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	68 e3 74 10 80       	push   $0x801074e3
8010451a:	e8 61 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	68 fa 74 10 80       	push   $0x801074fa
80104527:	e8 54 be ff ff       	call   80100380 <panic>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <holding>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 75 08             	mov    0x8(%ebp),%esi
80104538:	31 db                	xor    %ebx,%ebx
  pushcli();
8010453a:	e8 41 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010453f:	8b 06                	mov    (%esi),%eax
80104541:	85 c0                	test   %eax,%eax
80104543:	75 0b                	jne    80104550 <holding+0x20>
  popcli();
80104545:	e8 86 ff ff ff       	call   801044d0 <popcli>
}
8010454a:	89 d8                	mov    %ebx,%eax
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104550:	8b 5e 08             	mov    0x8(%esi),%ebx
80104553:	e8 b8 f3 ff ff       	call   80103910 <mycpu>
80104558:	39 c3                	cmp    %eax,%ebx
8010455a:	0f 94 c3             	sete   %bl
  popcli();
8010455d:	e8 6e ff ff ff       	call   801044d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104562:	0f b6 db             	movzbl %bl,%ebx
}
80104565:	89 d8                	mov    %ebx,%eax
80104567:	5b                   	pop    %ebx
80104568:	5e                   	pop    %esi
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret
8010456b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104570 <release>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104578:	e8 03 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010457d:	8b 03                	mov    (%ebx),%eax
8010457f:	85 c0                	test   %eax,%eax
80104581:	75 15                	jne    80104598 <release+0x28>
  popcli();
80104583:	e8 48 ff ff ff       	call   801044d0 <popcli>
    panic("release");
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 01 75 10 80       	push   $0x80107501
80104590:	e8 eb bd ff ff       	call   80100380 <panic>
80104595:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104598:	8b 73 08             	mov    0x8(%ebx),%esi
8010459b:	e8 70 f3 ff ff       	call   80103910 <mycpu>
801045a0:	39 c6                	cmp    %eax,%esi
801045a2:	75 df                	jne    80104583 <release+0x13>
  popcli();
801045a4:	e8 27 ff ff ff       	call   801044d0 <popcli>
  lk->pcs[0] = 0;
801045a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c5:	5b                   	pop    %ebx
801045c6:	5e                   	pop    %esi
801045c7:	5d                   	pop    %ebp
  popcli();
801045c8:	e9 03 ff ff ff       	jmp    801044d0 <popcli>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <acquire>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045d7:	e8 a4 fe ff ff       	call   80104480 <pushcli>
  if(holding(lk))
801045dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045df:	e8 9c fe ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045e4:	8b 03                	mov    (%ebx),%eax
801045e6:	85 c0                	test   %eax,%eax
801045e8:	0f 85 b2 00 00 00    	jne    801046a0 <acquire+0xd0>
  popcli();
801045ee:	e8 dd fe ff ff       	call   801044d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801045f3:	b9 01 00 00 00       	mov    $0x1,%ecx
801045f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ff:	00 
  while(xchg(&lk->locked, 1) != 0)
80104600:	8b 55 08             	mov    0x8(%ebp),%edx
80104603:	89 c8                	mov    %ecx,%eax
80104605:	f0 87 02             	lock xchg %eax,(%edx)
80104608:	85 c0                	test   %eax,%eax
8010460a:	75 f4                	jne    80104600 <acquire+0x30>
  __sync_synchronize();
8010460c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104611:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104614:	e8 f7 f2 ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010461c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010461e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104621:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104627:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010462c:	77 32                	ja     80104660 <acquire+0x90>
  ebp = (uint*)v - 2;
8010462e:	89 e8                	mov    %ebp,%eax
80104630:	eb 14                	jmp    80104646 <acquire+0x76>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104638:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010463e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104644:	77 1a                	ja     80104660 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104646:	8b 58 04             	mov    0x4(%eax),%ebx
80104649:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010464d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104650:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104652:	83 fa 0a             	cmp    $0xa,%edx
80104655:	75 e1                	jne    80104638 <acquire+0x68>
}
80104657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010465a:	c9                   	leave
8010465b:	c3                   	ret
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104660:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104664:	83 c1 34             	add    $0x34,%ecx
80104667:	89 ca                	mov    %ecx,%edx
80104669:	29 c2                	sub    %eax,%edx
8010466b:	83 e2 04             	and    $0x4,%edx
8010466e:	74 10                	je     80104680 <acquire+0xb0>
    pcs[i] = 0;
80104670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104676:	83 c0 04             	add    $0x4,%eax
80104679:	39 c1                	cmp    %eax,%ecx
8010467b:	74 da                	je     80104657 <acquire+0x87>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104686:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104689:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104690:	39 c1                	cmp    %eax,%ecx
80104692:	75 ec                	jne    80104680 <acquire+0xb0>
80104694:	eb c1                	jmp    80104657 <acquire+0x87>
80104696:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010469d:	00 
8010469e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801046a0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046a3:	e8 68 f2 ff ff       	call   80103910 <mycpu>
801046a8:	39 c3                	cmp    %eax,%ebx
801046aa:	0f 85 3e ff ff ff    	jne    801045ee <acquire+0x1e>
  popcli();
801046b0:	e8 1b fe ff ff       	call   801044d0 <popcli>
    panic("acquire");
801046b5:	83 ec 0c             	sub    $0xc,%esp
801046b8:	68 09 75 10 80       	push   $0x80107509
801046bd:	e8 be bc ff ff       	call   80100380 <panic>
801046c2:	66 90                	xchg   %ax,%ax
801046c4:	66 90                	xchg   %ax,%ax
801046c6:	66 90                	xchg   %ax,%ax
801046c8:	66 90                	xchg   %ax,%ax
801046ca:	66 90                	xchg   %ax,%ax
801046cc:	66 90                	xchg   %ax,%ax
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	8b 55 08             	mov    0x8(%ebp),%edx
801046d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046da:	89 d0                	mov    %edx,%eax
801046dc:	09 c8                	or     %ecx,%eax
801046de:	a8 03                	test   $0x3,%al
801046e0:	75 1e                	jne    80104700 <memset+0x30>
    c &= 0xFF;
801046e2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046e6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801046e9:	89 d7                	mov    %edx,%edi
801046eb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801046f1:	fc                   	cld
801046f2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801046f7:	89 d0                	mov    %edx,%eax
801046f9:	c9                   	leave
801046fa:	c3                   	ret
801046fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104700:	8b 45 0c             	mov    0xc(%ebp),%eax
80104703:	89 d7                	mov    %edx,%edi
80104705:	fc                   	cld
80104706:	f3 aa                	rep stos %al,%es:(%edi)
80104708:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010470b:	89 d0                	mov    %edx,%eax
8010470d:	c9                   	leave
8010470e:	c3                   	ret
8010470f:	90                   	nop

80104710 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	8b 75 10             	mov    0x10(%ebp),%esi
80104717:	8b 45 08             	mov    0x8(%ebp),%eax
8010471a:	53                   	push   %ebx
8010471b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010471e:	85 f6                	test   %esi,%esi
80104720:	74 2e                	je     80104750 <memcmp+0x40>
80104722:	01 c6                	add    %eax,%esi
80104724:	eb 14                	jmp    8010473a <memcmp+0x2a>
80104726:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010472d:	00 
8010472e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104730:	83 c0 01             	add    $0x1,%eax
80104733:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104736:	39 f0                	cmp    %esi,%eax
80104738:	74 16                	je     80104750 <memcmp+0x40>
    if(*s1 != *s2)
8010473a:	0f b6 08             	movzbl (%eax),%ecx
8010473d:	0f b6 1a             	movzbl (%edx),%ebx
80104740:	38 d9                	cmp    %bl,%cl
80104742:	74 ec                	je     80104730 <memcmp+0x20>
      return *s1 - *s2;
80104744:	0f b6 c1             	movzbl %cl,%eax
80104747:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104749:	5b                   	pop    %ebx
8010474a:	5e                   	pop    %esi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
80104750:	5b                   	pop    %ebx
  return 0;
80104751:	31 c0                	xor    %eax,%eax
}
80104753:	5e                   	pop    %esi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret
80104756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010475d:	00 
8010475e:	66 90                	xchg   %ax,%ax

80104760 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	8b 55 08             	mov    0x8(%ebp),%edx
80104767:	8b 45 10             	mov    0x10(%ebp),%eax
8010476a:	56                   	push   %esi
8010476b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010476e:	39 d6                	cmp    %edx,%esi
80104770:	73 26                	jae    80104798 <memmove+0x38>
80104772:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104775:	39 ca                	cmp    %ecx,%edx
80104777:	73 1f                	jae    80104798 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104779:	85 c0                	test   %eax,%eax
8010477b:	74 0f                	je     8010478c <memmove+0x2c>
8010477d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104780:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104784:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104787:	83 e8 01             	sub    $0x1,%eax
8010478a:	73 f4                	jae    80104780 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010478c:	5e                   	pop    %esi
8010478d:	89 d0                	mov    %edx,%eax
8010478f:	5f                   	pop    %edi
80104790:	5d                   	pop    %ebp
80104791:	c3                   	ret
80104792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104798:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010479b:	89 d7                	mov    %edx,%edi
8010479d:	85 c0                	test   %eax,%eax
8010479f:	74 eb                	je     8010478c <memmove+0x2c>
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047a9:	39 ce                	cmp    %ecx,%esi
801047ab:	75 fb                	jne    801047a8 <memmove+0x48>
}
801047ad:	5e                   	pop    %esi
801047ae:	89 d0                	mov    %edx,%eax
801047b0:	5f                   	pop    %edi
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret
801047b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ba:	00 
801047bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047c0:	eb 9e                	jmp    80104760 <memmove>
801047c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047c9:	00 
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	8b 55 10             	mov    0x10(%ebp),%edx
801047d7:	8b 45 08             	mov    0x8(%ebp),%eax
801047da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801047dd:	85 d2                	test   %edx,%edx
801047df:	75 16                	jne    801047f7 <strncmp+0x27>
801047e1:	eb 2d                	jmp    80104810 <strncmp+0x40>
801047e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801047e8:	3a 19                	cmp    (%ecx),%bl
801047ea:	75 12                	jne    801047fe <strncmp+0x2e>
    n--, p++, q++;
801047ec:	83 c0 01             	add    $0x1,%eax
801047ef:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047f2:	83 ea 01             	sub    $0x1,%edx
801047f5:	74 19                	je     80104810 <strncmp+0x40>
801047f7:	0f b6 18             	movzbl (%eax),%ebx
801047fa:	84 db                	test   %bl,%bl
801047fc:	75 ea                	jne    801047e8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047fe:	0f b6 00             	movzbl (%eax),%eax
80104801:	0f b6 11             	movzbl (%ecx),%edx
}
80104804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104807:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104808:	29 d0                	sub    %edx,%eax
}
8010480a:	c3                   	ret
8010480b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104810:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104813:	31 c0                	xor    %eax,%eax
}
80104815:	c9                   	leave
80104816:	c3                   	ret
80104817:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010481e:	00 
8010481f:	90                   	nop

80104820 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	8b 75 08             	mov    0x8(%ebp),%esi
80104828:	53                   	push   %ebx
80104829:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010482c:	89 f0                	mov    %esi,%eax
8010482e:	eb 15                	jmp    80104845 <strncpy+0x25>
80104830:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104834:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104837:	83 c0 01             	add    $0x1,%eax
8010483a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010483e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104841:	84 c9                	test   %cl,%cl
80104843:	74 13                	je     80104858 <strncpy+0x38>
80104845:	89 d3                	mov    %edx,%ebx
80104847:	83 ea 01             	sub    $0x1,%edx
8010484a:	85 db                	test   %ebx,%ebx
8010484c:	7f e2                	jg     80104830 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010484e:	5b                   	pop    %ebx
8010484f:	89 f0                	mov    %esi,%eax
80104851:	5e                   	pop    %esi
80104852:	5f                   	pop    %edi
80104853:	5d                   	pop    %ebp
80104854:	c3                   	ret
80104855:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104858:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010485b:	83 e9 01             	sub    $0x1,%ecx
8010485e:	85 d2                	test   %edx,%edx
80104860:	74 ec                	je     8010484e <strncpy+0x2e>
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104868:	83 c0 01             	add    $0x1,%eax
8010486b:	89 ca                	mov    %ecx,%edx
8010486d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104871:	29 c2                	sub    %eax,%edx
80104873:	85 d2                	test   %edx,%edx
80104875:	7f f1                	jg     80104868 <strncpy+0x48>
}
80104877:	5b                   	pop    %ebx
80104878:	89 f0                	mov    %esi,%eax
8010487a:	5e                   	pop    %esi
8010487b:	5f                   	pop    %edi
8010487c:	5d                   	pop    %ebp
8010487d:	c3                   	ret
8010487e:	66 90                	xchg   %ax,%ax

80104880 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	8b 55 10             	mov    0x10(%ebp),%edx
80104887:	8b 75 08             	mov    0x8(%ebp),%esi
8010488a:	53                   	push   %ebx
8010488b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010488e:	85 d2                	test   %edx,%edx
80104890:	7e 25                	jle    801048b7 <safestrcpy+0x37>
80104892:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104896:	89 f2                	mov    %esi,%edx
80104898:	eb 16                	jmp    801048b0 <safestrcpy+0x30>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048a0:	0f b6 08             	movzbl (%eax),%ecx
801048a3:	83 c0 01             	add    $0x1,%eax
801048a6:	83 c2 01             	add    $0x1,%edx
801048a9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048ac:	84 c9                	test   %cl,%cl
801048ae:	74 04                	je     801048b4 <safestrcpy+0x34>
801048b0:	39 d8                	cmp    %ebx,%eax
801048b2:	75 ec                	jne    801048a0 <safestrcpy+0x20>
    ;
  *s = 0;
801048b4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048b7:	89 f0                	mov    %esi,%eax
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <strlen>:

int
strlen(const char *s)
{
801048c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048c1:	31 c0                	xor    %eax,%eax
{
801048c3:	89 e5                	mov    %esp,%ebp
801048c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048c8:	80 3a 00             	cmpb   $0x0,(%edx)
801048cb:	74 0c                	je     801048d9 <strlen+0x19>
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	83 c0 01             	add    $0x1,%eax
801048d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048d7:	75 f7                	jne    801048d0 <strlen+0x10>
    ;
  return n;
}
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret

801048db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048e3:	55                   	push   %ebp
  pushl %ebx
801048e4:	53                   	push   %ebx
  pushl %esi
801048e5:	56                   	push   %esi
  pushl %edi
801048e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048eb:	5f                   	pop    %edi
  popl %esi
801048ec:	5e                   	pop    %esi
  popl %ebx
801048ed:	5b                   	pop    %ebx
  popl %ebp
801048ee:	5d                   	pop    %ebp
  ret
801048ef:	c3                   	ret

801048f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
801048f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048fa:	e8 91 f0 ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ff:	8b 00                	mov    (%eax),%eax
80104901:	39 c3                	cmp    %eax,%ebx
80104903:	73 1b                	jae    80104920 <fetchint+0x30>
80104905:	8d 53 04             	lea    0x4(%ebx),%edx
80104908:	39 d0                	cmp    %edx,%eax
8010490a:	72 14                	jb     80104920 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010490c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010490f:	8b 13                	mov    (%ebx),%edx
80104911:	89 10                	mov    %edx,(%eax)
  return 0;
80104913:	31 c0                	xor    %eax,%eax
}
80104915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104918:	c9                   	leave
80104919:	c3                   	ret
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104925:	eb ee                	jmp    80104915 <fetchint+0x25>
80104927:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010492e:	00 
8010492f:	90                   	nop

80104930 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010493a:	e8 51 f0 ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz)
8010493f:	3b 18                	cmp    (%eax),%ebx
80104941:	73 2d                	jae    80104970 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104943:	8b 55 0c             	mov    0xc(%ebp),%edx
80104946:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104948:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010494a:	39 d3                	cmp    %edx,%ebx
8010494c:	73 22                	jae    80104970 <fetchstr+0x40>
8010494e:	89 d8                	mov    %ebx,%eax
80104950:	eb 0d                	jmp    8010495f <fetchstr+0x2f>
80104952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104958:	83 c0 01             	add    $0x1,%eax
8010495b:	39 d0                	cmp    %edx,%eax
8010495d:	73 11                	jae    80104970 <fetchstr+0x40>
    if(*s == 0)
8010495f:	80 38 00             	cmpb   $0x0,(%eax)
80104962:	75 f4                	jne    80104958 <fetchstr+0x28>
      return s - *pp;
80104964:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104969:	c9                   	leave
8010496a:	c3                   	ret
8010496b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104978:	c9                   	leave
80104979:	c3                   	ret
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104985:	e8 06 f0 ff ff       	call   80103990 <myproc>
8010498a:	8b 55 08             	mov    0x8(%ebp),%edx
8010498d:	8b 40 18             	mov    0x18(%eax),%eax
80104990:	8b 40 44             	mov    0x44(%eax),%eax
80104993:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104996:	e8 f5 ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010499b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010499e:	8b 00                	mov    (%eax),%eax
801049a0:	39 c6                	cmp    %eax,%esi
801049a2:	73 1c                	jae    801049c0 <argint+0x40>
801049a4:	8d 53 08             	lea    0x8(%ebx),%edx
801049a7:	39 d0                	cmp    %edx,%eax
801049a9:	72 15                	jb     801049c0 <argint+0x40>
  *ip = *(int*)(addr);
801049ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ae:	8b 53 04             	mov    0x4(%ebx),%edx
801049b1:	89 10                	mov    %edx,(%eax)
  return 0;
801049b3:	31 c0                	xor    %eax,%eax
}
801049b5:	5b                   	pop    %ebx
801049b6:	5e                   	pop    %esi
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049c5:	eb ee                	jmp    801049b5 <argint+0x35>
801049c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ce:	00 
801049cf:	90                   	nop

801049d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049d9:	e8 b2 ef ff ff       	call   80103990 <myproc>
801049de:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e0:	e8 ab ef ff ff       	call   80103990 <myproc>
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
801049e8:	8b 40 18             	mov    0x18(%eax),%eax
801049eb:	8b 40 44             	mov    0x44(%eax),%eax
801049ee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049f1:	e8 9a ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049f9:	8b 00                	mov    (%eax),%eax
801049fb:	39 c7                	cmp    %eax,%edi
801049fd:	73 31                	jae    80104a30 <argptr+0x60>
801049ff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a02:	39 c8                	cmp    %ecx,%eax
80104a04:	72 2a                	jb     80104a30 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a06:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a09:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a0c:	85 d2                	test   %edx,%edx
80104a0e:	78 20                	js     80104a30 <argptr+0x60>
80104a10:	8b 16                	mov    (%esi),%edx
80104a12:	39 d0                	cmp    %edx,%eax
80104a14:	73 1a                	jae    80104a30 <argptr+0x60>
80104a16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a19:	01 c3                	add    %eax,%ebx
80104a1b:	39 da                	cmp    %ebx,%edx
80104a1d:	72 11                	jb     80104a30 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a22:	89 02                	mov    %eax,(%edx)
  return 0;
80104a24:	31 c0                	xor    %eax,%eax
}
80104a26:	83 c4 0c             	add    $0xc,%esp
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5f                   	pop    %edi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret
80104a2e:	66 90                	xchg   %ax,%ax
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb ef                	jmp    80104a26 <argptr+0x56>
80104a37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a3e:	00 
80104a3f:	90                   	nop

80104a40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a45:	e8 46 ef ff ff       	call   80103990 <myproc>
80104a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a4d:	8b 40 18             	mov    0x18(%eax),%eax
80104a50:	8b 40 44             	mov    0x44(%eax),%eax
80104a53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a56:	e8 35 ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a5e:	8b 00                	mov    (%eax),%eax
80104a60:	39 c6                	cmp    %eax,%esi
80104a62:	73 44                	jae    80104aa8 <argstr+0x68>
80104a64:	8d 53 08             	lea    0x8(%ebx),%edx
80104a67:	39 d0                	cmp    %edx,%eax
80104a69:	72 3d                	jb     80104aa8 <argstr+0x68>
  *ip = *(int*)(addr);
80104a6b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a6e:	e8 1d ef ff ff       	call   80103990 <myproc>
  if(addr >= curproc->sz)
80104a73:	3b 18                	cmp    (%eax),%ebx
80104a75:	73 31                	jae    80104aa8 <argstr+0x68>
  *pp = (char*)addr;
80104a77:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a7a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a7c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a7e:	39 d3                	cmp    %edx,%ebx
80104a80:	73 26                	jae    80104aa8 <argstr+0x68>
80104a82:	89 d8                	mov    %ebx,%eax
80104a84:	eb 11                	jmp    80104a97 <argstr+0x57>
80104a86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a8d:	00 
80104a8e:	66 90                	xchg   %ax,%ax
80104a90:	83 c0 01             	add    $0x1,%eax
80104a93:	39 d0                	cmp    %edx,%eax
80104a95:	73 11                	jae    80104aa8 <argstr+0x68>
    if(*s == 0)
80104a97:	80 38 00             	cmpb   $0x0,(%eax)
80104a9a:	75 f4                	jne    80104a90 <argstr+0x50>
      return s - *pp;
80104a9c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a9e:	5b                   	pop    %ebx
80104a9f:	5e                   	pop    %esi
80104aa0:	5d                   	pop    %ebp
80104aa1:	c3                   	ret
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	5b                   	pop    %ebx
    return -1;
80104aa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aae:	5e                   	pop    %esi
80104aaf:	5d                   	pop    %ebp
80104ab0:	c3                   	ret
80104ab1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ab8:	00 
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ac7:	e8 c4 ee ff ff       	call   80103990 <myproc>
80104acc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ace:	8b 40 18             	mov    0x18(%eax),%eax
80104ad1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ad4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ad7:	83 fa 14             	cmp    $0x14,%edx
80104ada:	77 24                	ja     80104b00 <syscall+0x40>
80104adc:	8b 14 85 a0 7a 10 80 	mov    -0x7fef8560(,%eax,4),%edx
80104ae3:	85 d2                	test   %edx,%edx
80104ae5:	74 19                	je     80104b00 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ae7:	ff d2                	call   *%edx
80104ae9:	89 c2                	mov    %eax,%edx
80104aeb:	8b 43 18             	mov    0x18(%ebx),%eax
80104aee:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af4:	c9                   	leave
80104af5:	c3                   	ret
80104af6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104afd:	00 
80104afe:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104b00:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b01:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b04:	50                   	push   %eax
80104b05:	ff 73 10             	push   0x10(%ebx)
80104b08:	68 11 75 10 80       	push   $0x80107511
80104b0d:	e8 ce bb ff ff       	call   801006e0 <cprintf>
    curproc->tf->eax = -1;
80104b12:	8b 43 18             	mov    0x18(%ebx),%eax
80104b15:	83 c4 10             	add    $0x10,%esp
80104b18:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b22:	c9                   	leave
80104b23:	c3                   	ret
80104b24:	66 90                	xchg   %ax,%ax
80104b26:	66 90                	xchg   %ax,%ax
80104b28:	66 90                	xchg   %ax,%ax
80104b2a:	66 90                	xchg   %ax,%ax
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b35:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b38:	53                   	push   %ebx
80104b39:	83 ec 34             	sub    $0x34,%esp
80104b3c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b42:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b45:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b48:	57                   	push   %edi
80104b49:	50                   	push   %eax
80104b4a:	e8 81 d5 ff ff       	call   801020d0 <nameiparent>
80104b4f:	83 c4 10             	add    $0x10,%esp
80104b52:	85 c0                	test   %eax,%eax
80104b54:	74 5e                	je     80104bb4 <create+0x84>
    return 0;
  ilock(dp);
80104b56:	83 ec 0c             	sub    $0xc,%esp
80104b59:	89 c3                	mov    %eax,%ebx
80104b5b:	50                   	push   %eax
80104b5c:	e8 6f cc ff ff       	call   801017d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b61:	83 c4 0c             	add    $0xc,%esp
80104b64:	6a 00                	push   $0x0
80104b66:	57                   	push   %edi
80104b67:	53                   	push   %ebx
80104b68:	e8 b3 d1 ff ff       	call   80101d20 <dirlookup>
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	89 c6                	mov    %eax,%esi
80104b72:	85 c0                	test   %eax,%eax
80104b74:	74 4a                	je     80104bc0 <create+0x90>
    iunlockput(dp);
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	53                   	push   %ebx
80104b7a:	e8 e1 ce ff ff       	call   80101a60 <iunlockput>
    ilock(ip);
80104b7f:	89 34 24             	mov    %esi,(%esp)
80104b82:	e8 49 cc ff ff       	call   801017d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b87:	83 c4 10             	add    $0x10,%esp
80104b8a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b8f:	75 17                	jne    80104ba8 <create+0x78>
80104b91:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b96:	75 10                	jne    80104ba8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b9b:	89 f0                	mov    %esi,%eax
80104b9d:	5b                   	pop    %ebx
80104b9e:	5e                   	pop    %esi
80104b9f:	5f                   	pop    %edi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ba8:	83 ec 0c             	sub    $0xc,%esp
80104bab:	56                   	push   %esi
80104bac:	e8 af ce ff ff       	call   80101a60 <iunlockput>
    return 0;
80104bb1:	83 c4 10             	add    $0x10,%esp
}
80104bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104bb7:	31 f6                	xor    %esi,%esi
}
80104bb9:	5b                   	pop    %ebx
80104bba:	89 f0                	mov    %esi,%eax
80104bbc:	5e                   	pop    %esi
80104bbd:	5f                   	pop    %edi
80104bbe:	5d                   	pop    %ebp
80104bbf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104bc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bc4:	83 ec 08             	sub    $0x8,%esp
80104bc7:	50                   	push   %eax
80104bc8:	ff 33                	push   (%ebx)
80104bca:	e8 91 ca ff ff       	call   80101660 <ialloc>
80104bcf:	83 c4 10             	add    $0x10,%esp
80104bd2:	89 c6                	mov    %eax,%esi
80104bd4:	85 c0                	test   %eax,%eax
80104bd6:	0f 84 bc 00 00 00    	je     80104c98 <create+0x168>
  ilock(ip);
80104bdc:	83 ec 0c             	sub    $0xc,%esp
80104bdf:	50                   	push   %eax
80104be0:	e8 eb cb ff ff       	call   801017d0 <ilock>
  ip->major = major;
80104be5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104be9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104bf1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104bf5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bfa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bfe:	89 34 24             	mov    %esi,(%esp)
80104c01:	e8 1a cb ff ff       	call   80101720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c0e:	74 30                	je     80104c40 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104c10:	83 ec 04             	sub    $0x4,%esp
80104c13:	ff 76 04             	push   0x4(%esi)
80104c16:	57                   	push   %edi
80104c17:	53                   	push   %ebx
80104c18:	e8 d3 d3 ff ff       	call   80101ff0 <dirlink>
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	85 c0                	test   %eax,%eax
80104c22:	78 67                	js     80104c8b <create+0x15b>
  iunlockput(dp);
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	53                   	push   %ebx
80104c28:	e8 33 ce ff ff       	call   80101a60 <iunlockput>
  return ip;
80104c2d:	83 c4 10             	add    $0x10,%esp
}
80104c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c33:	89 f0                	mov    %esi,%eax
80104c35:	5b                   	pop    %ebx
80104c36:	5e                   	pop    %esi
80104c37:	5f                   	pop    %edi
80104c38:	5d                   	pop    %ebp
80104c39:	c3                   	ret
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c48:	53                   	push   %ebx
80104c49:	e8 d2 ca ff ff       	call   80101720 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c4e:	83 c4 0c             	add    $0xc,%esp
80104c51:	ff 76 04             	push   0x4(%esi)
80104c54:	68 49 75 10 80       	push   $0x80107549
80104c59:	56                   	push   %esi
80104c5a:	e8 91 d3 ff ff       	call   80101ff0 <dirlink>
80104c5f:	83 c4 10             	add    $0x10,%esp
80104c62:	85 c0                	test   %eax,%eax
80104c64:	78 18                	js     80104c7e <create+0x14e>
80104c66:	83 ec 04             	sub    $0x4,%esp
80104c69:	ff 73 04             	push   0x4(%ebx)
80104c6c:	68 48 75 10 80       	push   $0x80107548
80104c71:	56                   	push   %esi
80104c72:	e8 79 d3 ff ff       	call   80101ff0 <dirlink>
80104c77:	83 c4 10             	add    $0x10,%esp
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	79 92                	jns    80104c10 <create+0xe0>
      panic("create dots");
80104c7e:	83 ec 0c             	sub    $0xc,%esp
80104c81:	68 3c 75 10 80       	push   $0x8010753c
80104c86:	e8 f5 b6 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104c8b:	83 ec 0c             	sub    $0xc,%esp
80104c8e:	68 4b 75 10 80       	push   $0x8010754b
80104c93:	e8 e8 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c98:	83 ec 0c             	sub    $0xc,%esp
80104c9b:	68 2d 75 10 80       	push   $0x8010752d
80104ca0:	e8 db b6 ff ff       	call   80100380 <panic>
80104ca5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cac:	00 
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <sys_dup>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104cb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cbb:	50                   	push   %eax
80104cbc:	6a 00                	push   $0x0
80104cbe:	e8 bd fc ff ff       	call   80104980 <argint>
80104cc3:	83 c4 10             	add    $0x10,%esp
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	78 36                	js     80104d00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cce:	77 30                	ja     80104d00 <sys_dup+0x50>
80104cd0:	e8 bb ec ff ff       	call   80103990 <myproc>
80104cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cdc:	85 f6                	test   %esi,%esi
80104cde:	74 20                	je     80104d00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ce0:	e8 ab ec ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ce5:	31 db                	xor    %ebx,%ebx
80104ce7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cee:	00 
80104cef:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104cf0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cf4:	85 d2                	test   %edx,%edx
80104cf6:	74 18                	je     80104d10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	83 fb 10             	cmp    $0x10,%ebx
80104cfe:	75 f0                	jne    80104cf0 <sys_dup+0x40>
}
80104d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d08:	89 d8                	mov    %ebx,%eax
80104d0a:	5b                   	pop    %ebx
80104d0b:	5e                   	pop    %esi
80104d0c:	5d                   	pop    %ebp
80104d0d:	c3                   	ret
80104d0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d17:	56                   	push   %esi
80104d18:	e8 d3 c1 ff ff       	call   80100ef0 <filedup>
  return fd;
80104d1d:	83 c4 10             	add    $0x10,%esp
}
80104d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d23:	89 d8                	mov    %ebx,%eax
80104d25:	5b                   	pop    %ebx
80104d26:	5e                   	pop    %esi
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <sys_read>:
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d3b:	53                   	push   %ebx
80104d3c:	6a 00                	push   $0x0
80104d3e:	e8 3d fc ff ff       	call   80104980 <argint>
80104d43:	83 c4 10             	add    $0x10,%esp
80104d46:	85 c0                	test   %eax,%eax
80104d48:	78 5e                	js     80104da8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d4e:	77 58                	ja     80104da8 <sys_read+0x78>
80104d50:	e8 3b ec ff ff       	call   80103990 <myproc>
80104d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d5c:	85 f6                	test   %esi,%esi
80104d5e:	74 48                	je     80104da8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d60:	83 ec 08             	sub    $0x8,%esp
80104d63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d66:	50                   	push   %eax
80104d67:	6a 02                	push   $0x2
80104d69:	e8 12 fc ff ff       	call   80104980 <argint>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 33                	js     80104da8 <sys_read+0x78>
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	push   -0x10(%ebp)
80104d7b:	53                   	push   %ebx
80104d7c:	6a 01                	push   $0x1
80104d7e:	e8 4d fc ff ff       	call   801049d0 <argptr>
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	78 1e                	js     80104da8 <sys_read+0x78>
  return fileread(f, p, n);
80104d8a:	83 ec 04             	sub    $0x4,%esp
80104d8d:	ff 75 f0             	push   -0x10(%ebp)
80104d90:	ff 75 f4             	push   -0xc(%ebp)
80104d93:	56                   	push   %esi
80104d94:	e8 d7 c2 ff ff       	call   80101070 <fileread>
80104d99:	83 c4 10             	add    $0x10,%esp
}
80104d9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5d                   	pop    %ebp
80104da2:	c3                   	ret
80104da3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dad:	eb ed                	jmp    80104d9c <sys_read+0x6c>
80104daf:	90                   	nop

80104db0 <sys_write>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104db5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104db8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dbb:	53                   	push   %ebx
80104dbc:	6a 00                	push   $0x0
80104dbe:	e8 bd fb ff ff       	call   80104980 <argint>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	78 5e                	js     80104e28 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dce:	77 58                	ja     80104e28 <sys_write+0x78>
80104dd0:	e8 bb eb ff ff       	call   80103990 <myproc>
80104dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ddc:	85 f6                	test   %esi,%esi
80104dde:	74 48                	je     80104e28 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de0:	83 ec 08             	sub    $0x8,%esp
80104de3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104de6:	50                   	push   %eax
80104de7:	6a 02                	push   $0x2
80104de9:	e8 92 fb ff ff       	call   80104980 <argint>
80104dee:	83 c4 10             	add    $0x10,%esp
80104df1:	85 c0                	test   %eax,%eax
80104df3:	78 33                	js     80104e28 <sys_write+0x78>
80104df5:	83 ec 04             	sub    $0x4,%esp
80104df8:	ff 75 f0             	push   -0x10(%ebp)
80104dfb:	53                   	push   %ebx
80104dfc:	6a 01                	push   $0x1
80104dfe:	e8 cd fb ff ff       	call   801049d0 <argptr>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	78 1e                	js     80104e28 <sys_write+0x78>
  return filewrite(f, p, n);
80104e0a:	83 ec 04             	sub    $0x4,%esp
80104e0d:	ff 75 f0             	push   -0x10(%ebp)
80104e10:	ff 75 f4             	push   -0xc(%ebp)
80104e13:	56                   	push   %esi
80104e14:	e8 e7 c2 ff ff       	call   80101100 <filewrite>
80104e19:	83 c4 10             	add    $0x10,%esp
}
80104e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e1f:	5b                   	pop    %ebx
80104e20:	5e                   	pop    %esi
80104e21:	5d                   	pop    %ebp
80104e22:	c3                   	ret
80104e23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2d:	eb ed                	jmp    80104e1c <sys_write+0x6c>
80104e2f:	90                   	nop

80104e30 <sys_close>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e3b:	50                   	push   %eax
80104e3c:	6a 00                	push   $0x0
80104e3e:	e8 3d fb ff ff       	call   80104980 <argint>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	78 3e                	js     80104e88 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e4e:	77 38                	ja     80104e88 <sys_close+0x58>
80104e50:	e8 3b eb ff ff       	call   80103990 <myproc>
80104e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e58:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e5b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e5f:	85 f6                	test   %esi,%esi
80104e61:	74 25                	je     80104e88 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e63:	e8 28 eb ff ff       	call   80103990 <myproc>
  fileclose(f);
80104e68:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e6b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e72:	00 
  fileclose(f);
80104e73:	56                   	push   %esi
80104e74:	e8 c7 c0 ff ff       	call   80100f40 <fileclose>
  return 0;
80104e79:	83 c4 10             	add    $0x10,%esp
80104e7c:	31 c0                	xor    %eax,%eax
}
80104e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e81:	5b                   	pop    %ebx
80104e82:	5e                   	pop    %esi
80104e83:	5d                   	pop    %ebp
80104e84:	c3                   	ret
80104e85:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8d:	eb ef                	jmp    80104e7e <sys_close+0x4e>
80104e8f:	90                   	nop

80104e90 <sys_fstat>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e9b:	53                   	push   %ebx
80104e9c:	6a 00                	push   $0x0
80104e9e:	e8 dd fa ff ff       	call   80104980 <argint>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	78 46                	js     80104ef0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eae:	77 40                	ja     80104ef0 <sys_fstat+0x60>
80104eb0:	e8 db ea ff ff       	call   80103990 <myproc>
80104eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ebc:	85 f6                	test   %esi,%esi
80104ebe:	74 30                	je     80104ef0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ec0:	83 ec 04             	sub    $0x4,%esp
80104ec3:	6a 14                	push   $0x14
80104ec5:	53                   	push   %ebx
80104ec6:	6a 01                	push   $0x1
80104ec8:	e8 03 fb ff ff       	call   801049d0 <argptr>
80104ecd:	83 c4 10             	add    $0x10,%esp
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 1c                	js     80104ef0 <sys_fstat+0x60>
  return filestat(f, st);
80104ed4:	83 ec 08             	sub    $0x8,%esp
80104ed7:	ff 75 f4             	push   -0xc(%ebp)
80104eda:	56                   	push   %esi
80104edb:	e8 40 c1 ff ff       	call   80101020 <filestat>
80104ee0:	83 c4 10             	add    $0x10,%esp
}
80104ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee6:	5b                   	pop    %ebx
80104ee7:	5e                   	pop    %esi
80104ee8:	5d                   	pop    %ebp
80104ee9:	c3                   	ret
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef5:	eb ec                	jmp    80104ee3 <sys_fstat+0x53>
80104ef7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104efe:	00 
80104eff:	90                   	nop

80104f00 <sys_link>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f05:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f08:	53                   	push   %ebx
80104f09:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f0c:	50                   	push   %eax
80104f0d:	6a 00                	push   $0x0
80104f0f:	e8 2c fb ff ff       	call   80104a40 <argstr>
80104f14:	83 c4 10             	add    $0x10,%esp
80104f17:	85 c0                	test   %eax,%eax
80104f19:	0f 88 fb 00 00 00    	js     8010501a <sys_link+0x11a>
80104f1f:	83 ec 08             	sub    $0x8,%esp
80104f22:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f25:	50                   	push   %eax
80104f26:	6a 01                	push   $0x1
80104f28:	e8 13 fb ff ff       	call   80104a40 <argstr>
80104f2d:	83 c4 10             	add    $0x10,%esp
80104f30:	85 c0                	test   %eax,%eax
80104f32:	0f 88 e2 00 00 00    	js     8010501a <sys_link+0x11a>
  begin_op();
80104f38:	e8 33 de ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
80104f3d:	83 ec 0c             	sub    $0xc,%esp
80104f40:	ff 75 d4             	push   -0x2c(%ebp)
80104f43:	e8 68 d1 ff ff       	call   801020b0 <namei>
80104f48:	83 c4 10             	add    $0x10,%esp
80104f4b:	89 c3                	mov    %eax,%ebx
80104f4d:	85 c0                	test   %eax,%eax
80104f4f:	0f 84 df 00 00 00    	je     80105034 <sys_link+0x134>
  ilock(ip);
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	50                   	push   %eax
80104f59:	e8 72 c8 ff ff       	call   801017d0 <ilock>
  if(ip->type == T_DIR){
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f66:	0f 84 b5 00 00 00    	je     80105021 <sys_link+0x121>
  iupdate(ip);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f6f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f74:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f77:	53                   	push   %ebx
80104f78:	e8 a3 c7 ff ff       	call   80101720 <iupdate>
  iunlock(ip);
80104f7d:	89 1c 24             	mov    %ebx,(%esp)
80104f80:	e8 2b c9 ff ff       	call   801018b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f85:	58                   	pop    %eax
80104f86:	5a                   	pop    %edx
80104f87:	57                   	push   %edi
80104f88:	ff 75 d0             	push   -0x30(%ebp)
80104f8b:	e8 40 d1 ff ff       	call   801020d0 <nameiparent>
80104f90:	83 c4 10             	add    $0x10,%esp
80104f93:	89 c6                	mov    %eax,%esi
80104f95:	85 c0                	test   %eax,%eax
80104f97:	74 5b                	je     80104ff4 <sys_link+0xf4>
  ilock(dp);
80104f99:	83 ec 0c             	sub    $0xc,%esp
80104f9c:	50                   	push   %eax
80104f9d:	e8 2e c8 ff ff       	call   801017d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fa2:	8b 03                	mov    (%ebx),%eax
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	39 06                	cmp    %eax,(%esi)
80104fa9:	75 3d                	jne    80104fe8 <sys_link+0xe8>
80104fab:	83 ec 04             	sub    $0x4,%esp
80104fae:	ff 73 04             	push   0x4(%ebx)
80104fb1:	57                   	push   %edi
80104fb2:	56                   	push   %esi
80104fb3:	e8 38 d0 ff ff       	call   80101ff0 <dirlink>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	78 29                	js     80104fe8 <sys_link+0xe8>
  iunlockput(dp);
80104fbf:	83 ec 0c             	sub    $0xc,%esp
80104fc2:	56                   	push   %esi
80104fc3:	e8 98 ca ff ff       	call   80101a60 <iunlockput>
  iput(ip);
80104fc8:	89 1c 24             	mov    %ebx,(%esp)
80104fcb:	e8 30 c9 ff ff       	call   80101900 <iput>
  end_op();
80104fd0:	e8 0b de ff ff       	call   80102de0 <end_op>
  return 0;
80104fd5:	83 c4 10             	add    $0x10,%esp
80104fd8:	31 c0                	xor    %eax,%eax
}
80104fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fdd:	5b                   	pop    %ebx
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	56                   	push   %esi
80104fec:	e8 6f ca ff ff       	call   80101a60 <iunlockput>
    goto bad;
80104ff1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	53                   	push   %ebx
80104ff8:	e8 d3 c7 ff ff       	call   801017d0 <ilock>
  ip->nlink--;
80104ffd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105002:	89 1c 24             	mov    %ebx,(%esp)
80105005:	e8 16 c7 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
8010500a:	89 1c 24             	mov    %ebx,(%esp)
8010500d:	e8 4e ca ff ff       	call   80101a60 <iunlockput>
  end_op();
80105012:	e8 c9 dd ff ff       	call   80102de0 <end_op>
  return -1;
80105017:	83 c4 10             	add    $0x10,%esp
    return -1;
8010501a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501f:	eb b9                	jmp    80104fda <sys_link+0xda>
    iunlockput(ip);
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	53                   	push   %ebx
80105025:	e8 36 ca ff ff       	call   80101a60 <iunlockput>
    end_op();
8010502a:	e8 b1 dd ff ff       	call   80102de0 <end_op>
    return -1;
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	eb e6                	jmp    8010501a <sys_link+0x11a>
    end_op();
80105034:	e8 a7 dd ff ff       	call   80102de0 <end_op>
    return -1;
80105039:	eb df                	jmp    8010501a <sys_link+0x11a>
8010503b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105040 <sys_unlink>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105045:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105048:	53                   	push   %ebx
80105049:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010504c:	50                   	push   %eax
8010504d:	6a 00                	push   $0x0
8010504f:	e8 ec f9 ff ff       	call   80104a40 <argstr>
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	85 c0                	test   %eax,%eax
80105059:	0f 88 54 01 00 00    	js     801051b3 <sys_unlink+0x173>
  begin_op();
8010505f:	e8 0c dd ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105064:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105067:	83 ec 08             	sub    $0x8,%esp
8010506a:	53                   	push   %ebx
8010506b:	ff 75 c0             	push   -0x40(%ebp)
8010506e:	e8 5d d0 ff ff       	call   801020d0 <nameiparent>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105079:	85 c0                	test   %eax,%eax
8010507b:	0f 84 58 01 00 00    	je     801051d9 <sys_unlink+0x199>
  ilock(dp);
80105081:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	57                   	push   %edi
80105088:	e8 43 c7 ff ff       	call   801017d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010508d:	58                   	pop    %eax
8010508e:	5a                   	pop    %edx
8010508f:	68 49 75 10 80       	push   $0x80107549
80105094:	53                   	push   %ebx
80105095:	e8 66 cc ff ff       	call   80101d00 <namecmp>
8010509a:	83 c4 10             	add    $0x10,%esp
8010509d:	85 c0                	test   %eax,%eax
8010509f:	0f 84 fb 00 00 00    	je     801051a0 <sys_unlink+0x160>
801050a5:	83 ec 08             	sub    $0x8,%esp
801050a8:	68 48 75 10 80       	push   $0x80107548
801050ad:	53                   	push   %ebx
801050ae:	e8 4d cc ff ff       	call   80101d00 <namecmp>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	0f 84 e2 00 00 00    	je     801051a0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050be:	83 ec 04             	sub    $0x4,%esp
801050c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050c4:	50                   	push   %eax
801050c5:	53                   	push   %ebx
801050c6:	57                   	push   %edi
801050c7:	e8 54 cc ff ff       	call   80101d20 <dirlookup>
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	89 c3                	mov    %eax,%ebx
801050d1:	85 c0                	test   %eax,%eax
801050d3:	0f 84 c7 00 00 00    	je     801051a0 <sys_unlink+0x160>
  ilock(ip);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	50                   	push   %eax
801050dd:	e8 ee c6 ff ff       	call   801017d0 <ilock>
  if(ip->nlink < 1)
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ea:	0f 8e 0a 01 00 00    	jle    801051fa <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050f8:	74 66                	je     80105160 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050fa:	83 ec 04             	sub    $0x4,%esp
801050fd:	6a 10                	push   $0x10
801050ff:	6a 00                	push   $0x0
80105101:	57                   	push   %edi
80105102:	e8 c9 f5 ff ff       	call   801046d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105107:	6a 10                	push   $0x10
80105109:	ff 75 c4             	push   -0x3c(%ebp)
8010510c:	57                   	push   %edi
8010510d:	ff 75 b4             	push   -0x4c(%ebp)
80105110:	e8 cb ca ff ff       	call   80101be0 <writei>
80105115:	83 c4 20             	add    $0x20,%esp
80105118:	83 f8 10             	cmp    $0x10,%eax
8010511b:	0f 85 cc 00 00 00    	jne    801051ed <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105121:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105126:	0f 84 94 00 00 00    	je     801051c0 <sys_unlink+0x180>
  iunlockput(dp);
8010512c:	83 ec 0c             	sub    $0xc,%esp
8010512f:	ff 75 b4             	push   -0x4c(%ebp)
80105132:	e8 29 c9 ff ff       	call   80101a60 <iunlockput>
  ip->nlink--;
80105137:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010513c:	89 1c 24             	mov    %ebx,(%esp)
8010513f:	e8 dc c5 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105144:	89 1c 24             	mov    %ebx,(%esp)
80105147:	e8 14 c9 ff ff       	call   80101a60 <iunlockput>
  end_op();
8010514c:	e8 8f dc ff ff       	call   80102de0 <end_op>
  return 0;
80105151:	83 c4 10             	add    $0x10,%esp
80105154:	31 c0                	xor    %eax,%eax
}
80105156:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5f                   	pop    %edi
8010515c:	5d                   	pop    %ebp
8010515d:	c3                   	ret
8010515e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105160:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105164:	76 94                	jbe    801050fa <sys_unlink+0xba>
80105166:	be 20 00 00 00       	mov    $0x20,%esi
8010516b:	eb 0b                	jmp    80105178 <sys_unlink+0x138>
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
80105170:	83 c6 10             	add    $0x10,%esi
80105173:	3b 73 58             	cmp    0x58(%ebx),%esi
80105176:	73 82                	jae    801050fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105178:	6a 10                	push   $0x10
8010517a:	56                   	push   %esi
8010517b:	57                   	push   %edi
8010517c:	53                   	push   %ebx
8010517d:	e8 5e c9 ff ff       	call   80101ae0 <readi>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	83 f8 10             	cmp    $0x10,%eax
80105188:	75 56                	jne    801051e0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010518a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010518f:	74 df                	je     80105170 <sys_unlink+0x130>
    iunlockput(ip);
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	53                   	push   %ebx
80105195:	e8 c6 c8 ff ff       	call   80101a60 <iunlockput>
    goto bad;
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	ff 75 b4             	push   -0x4c(%ebp)
801051a6:	e8 b5 c8 ff ff       	call   80101a60 <iunlockput>
  end_op();
801051ab:	e8 30 dc ff ff       	call   80102de0 <end_op>
  return -1;
801051b0:	83 c4 10             	add    $0x10,%esp
    return -1;
801051b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b8:	eb 9c                	jmp    80105156 <sys_unlink+0x116>
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051c3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051c6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051cb:	50                   	push   %eax
801051cc:	e8 4f c5 ff ff       	call   80101720 <iupdate>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	e9 53 ff ff ff       	jmp    8010512c <sys_unlink+0xec>
    end_op();
801051d9:	e8 02 dc ff ff       	call   80102de0 <end_op>
    return -1;
801051de:	eb d3                	jmp    801051b3 <sys_unlink+0x173>
      panic("isdirempty: readi");
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	68 6d 75 10 80       	push   $0x8010756d
801051e8:	e8 93 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	68 7f 75 10 80       	push   $0x8010757f
801051f5:	e8 86 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	68 5b 75 10 80       	push   $0x8010755b
80105202:	e8 79 b1 ff ff       	call   80100380 <panic>
80105207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010520e:	00 
8010520f:	90                   	nop

80105210 <sys_open>:

int
sys_open(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105215:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105218:	53                   	push   %ebx
80105219:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 1c f8 ff ff       	call   80104a40 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 8e 00 00 00    	js     801052bd <sys_open+0xad>
8010522f:	83 ec 08             	sub    $0x8,%esp
80105232:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105235:	50                   	push   %eax
80105236:	6a 01                	push   $0x1
80105238:	e8 43 f7 ff ff       	call   80104980 <argint>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	78 79                	js     801052bd <sys_open+0xad>
    return -1;

  begin_op();
80105244:	e8 27 db ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105249:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010524d:	75 79                	jne    801052c8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	ff 75 e0             	push   -0x20(%ebp)
80105255:	e8 56 ce ff ff       	call   801020b0 <namei>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	89 c6                	mov    %eax,%esi
8010525f:	85 c0                	test   %eax,%eax
80105261:	0f 84 7e 00 00 00    	je     801052e5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105267:	83 ec 0c             	sub    $0xc,%esp
8010526a:	50                   	push   %eax
8010526b:	e8 60 c5 ff ff       	call   801017d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105278:	0f 84 ba 00 00 00    	je     80105338 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010527e:	e8 fd bb ff ff       	call   80100e80 <filealloc>
80105283:	89 c7                	mov    %eax,%edi
80105285:	85 c0                	test   %eax,%eax
80105287:	74 23                	je     801052ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105289:	e8 02 e7 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010528e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105290:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105294:	85 d2                	test   %edx,%edx
80105296:	74 58                	je     801052f0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105298:	83 c3 01             	add    $0x1,%ebx
8010529b:	83 fb 10             	cmp    $0x10,%ebx
8010529e:	75 f0                	jne    80105290 <sys_open+0x80>
    if(f)
      fileclose(f);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	57                   	push   %edi
801052a4:	e8 97 bc ff ff       	call   80100f40 <fileclose>
801052a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	56                   	push   %esi
801052b0:	e8 ab c7 ff ff       	call   80101a60 <iunlockput>
    end_op();
801052b5:	e8 26 db ff ff       	call   80102de0 <end_op>
    return -1;
801052ba:	83 c4 10             	add    $0x10,%esp
    return -1;
801052bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052c2:	eb 65                	jmp    80105329 <sys_open+0x119>
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052c8:	83 ec 0c             	sub    $0xc,%esp
801052cb:	31 c9                	xor    %ecx,%ecx
801052cd:	ba 02 00 00 00       	mov    $0x2,%edx
801052d2:	6a 00                	push   $0x0
801052d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052d7:	e8 54 f8 ff ff       	call   80104b30 <create>
    if(ip == 0){
801052dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052e1:	85 c0                	test   %eax,%eax
801052e3:	75 99                	jne    8010527e <sys_open+0x6e>
      end_op();
801052e5:	e8 f6 da ff ff       	call   80102de0 <end_op>
      return -1;
801052ea:	eb d1                	jmp    801052bd <sys_open+0xad>
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052f0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052f3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052f7:	56                   	push   %esi
801052f8:	e8 b3 c5 ff ff       	call   801018b0 <iunlock>
  end_op();
801052fd:	e8 de da ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
80105302:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010530b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010530e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105311:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105313:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010531a:	f7 d0                	not    %eax
8010531c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010531f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105322:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105325:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105329:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010532c:	89 d8                	mov    %ebx,%eax
8010532e:	5b                   	pop    %ebx
8010532f:	5e                   	pop    %esi
80105330:	5f                   	pop    %edi
80105331:	5d                   	pop    %ebp
80105332:	c3                   	ret
80105333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105338:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010533b:	85 c9                	test   %ecx,%ecx
8010533d:	0f 84 3b ff ff ff    	je     8010527e <sys_open+0x6e>
80105343:	e9 64 ff ff ff       	jmp    801052ac <sys_open+0x9c>
80105348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010534f:	00 

80105350 <sys_mkdir>:

int
sys_mkdir(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105356:	e8 15 da ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010535b:	83 ec 08             	sub    $0x8,%esp
8010535e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105361:	50                   	push   %eax
80105362:	6a 00                	push   $0x0
80105364:	e8 d7 f6 ff ff       	call   80104a40 <argstr>
80105369:	83 c4 10             	add    $0x10,%esp
8010536c:	85 c0                	test   %eax,%eax
8010536e:	78 30                	js     801053a0 <sys_mkdir+0x50>
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105376:	31 c9                	xor    %ecx,%ecx
80105378:	ba 01 00 00 00       	mov    $0x1,%edx
8010537d:	6a 00                	push   $0x0
8010537f:	e8 ac f7 ff ff       	call   80104b30 <create>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	74 15                	je     801053a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538b:	83 ec 0c             	sub    $0xc,%esp
8010538e:	50                   	push   %eax
8010538f:	e8 cc c6 ff ff       	call   80101a60 <iunlockput>
  end_op();
80105394:	e8 47 da ff ff       	call   80102de0 <end_op>
  return 0;
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	31 c0                	xor    %eax,%eax
}
8010539e:	c9                   	leave
8010539f:	c3                   	ret
    end_op();
801053a0:	e8 3b da ff ff       	call   80102de0 <end_op>
    return -1;
801053a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053aa:	c9                   	leave
801053ab:	c3                   	ret
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_mknod>:

int
sys_mknod(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053b6:	e8 b5 d9 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053bb:	83 ec 08             	sub    $0x8,%esp
801053be:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053c1:	50                   	push   %eax
801053c2:	6a 00                	push   $0x0
801053c4:	e8 77 f6 ff ff       	call   80104a40 <argstr>
801053c9:	83 c4 10             	add    $0x10,%esp
801053cc:	85 c0                	test   %eax,%eax
801053ce:	78 60                	js     80105430 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053d0:	83 ec 08             	sub    $0x8,%esp
801053d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d6:	50                   	push   %eax
801053d7:	6a 01                	push   $0x1
801053d9:	e8 a2 f5 ff ff       	call   80104980 <argint>
  if((argstr(0, &path)) < 0 ||
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 4b                	js     80105430 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053e5:	83 ec 08             	sub    $0x8,%esp
801053e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053eb:	50                   	push   %eax
801053ec:	6a 02                	push   $0x2
801053ee:	e8 8d f5 ff ff       	call   80104980 <argint>
     argint(1, &major) < 0 ||
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 36                	js     80105430 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053fe:	83 ec 0c             	sub    $0xc,%esp
80105401:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105405:	ba 03 00 00 00       	mov    $0x3,%edx
8010540a:	50                   	push   %eax
8010540b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010540e:	e8 1d f7 ff ff       	call   80104b30 <create>
     argint(2, &minor) < 0 ||
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	74 16                	je     80105430 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	50                   	push   %eax
8010541e:	e8 3d c6 ff ff       	call   80101a60 <iunlockput>
  end_op();
80105423:	e8 b8 d9 ff ff       	call   80102de0 <end_op>
  return 0;
80105428:	83 c4 10             	add    $0x10,%esp
8010542b:	31 c0                	xor    %eax,%eax
}
8010542d:	c9                   	leave
8010542e:	c3                   	ret
8010542f:	90                   	nop
    end_op();
80105430:	e8 ab d9 ff ff       	call   80102de0 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010543a:	c9                   	leave
8010543b:	c3                   	ret
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_chdir>:

int
sys_chdir(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105448:	e8 43 e5 ff ff       	call   80103990 <myproc>
8010544d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010544f:	e8 1c d9 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105454:	83 ec 08             	sub    $0x8,%esp
80105457:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545a:	50                   	push   %eax
8010545b:	6a 00                	push   $0x0
8010545d:	e8 de f5 ff ff       	call   80104a40 <argstr>
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	85 c0                	test   %eax,%eax
80105467:	78 77                	js     801054e0 <sys_chdir+0xa0>
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	ff 75 f4             	push   -0xc(%ebp)
8010546f:	e8 3c cc ff ff       	call   801020b0 <namei>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	89 c3                	mov    %eax,%ebx
80105479:	85 c0                	test   %eax,%eax
8010547b:	74 63                	je     801054e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	50                   	push   %eax
80105481:	e8 4a c3 ff ff       	call   801017d0 <ilock>
  if(ip->type != T_DIR){
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010548e:	75 30                	jne    801054c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	53                   	push   %ebx
80105494:	e8 17 c4 ff ff       	call   801018b0 <iunlock>
  iput(curproc->cwd);
80105499:	58                   	pop    %eax
8010549a:	ff 76 68             	push   0x68(%esi)
8010549d:	e8 5e c4 ff ff       	call   80101900 <iput>
  end_op();
801054a2:	e8 39 d9 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
801054a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	31 c0                	xor    %eax,%eax
}
801054af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5d                   	pop    %ebp
801054b5:	c3                   	ret
801054b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054bd:	00 
801054be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 97 c5 ff ff       	call   80101a60 <iunlockput>
    end_op();
801054c9:	e8 12 d9 ff ff       	call   80102de0 <end_op>
    return -1;
801054ce:	83 c4 10             	add    $0x10,%esp
    return -1;
801054d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d6:	eb d7                	jmp    801054af <sys_chdir+0x6f>
801054d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054df:	00 
    end_op();
801054e0:	e8 fb d8 ff ff       	call   80102de0 <end_op>
    return -1;
801054e5:	eb ea                	jmp    801054d1 <sys_chdir+0x91>
801054e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ee:	00 
801054ef:	90                   	nop

801054f0 <sys_exec>:

int
sys_exec(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054f5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054fb:	53                   	push   %ebx
801054fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105502:	50                   	push   %eax
80105503:	6a 00                	push   $0x0
80105505:	e8 36 f5 ff ff       	call   80104a40 <argstr>
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	85 c0                	test   %eax,%eax
8010550f:	0f 88 87 00 00 00    	js     8010559c <sys_exec+0xac>
80105515:	83 ec 08             	sub    $0x8,%esp
80105518:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010551e:	50                   	push   %eax
8010551f:	6a 01                	push   $0x1
80105521:	e8 5a f4 ff ff       	call   80104980 <argint>
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	85 c0                	test   %eax,%eax
8010552b:	78 6f                	js     8010559c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010552d:	83 ec 04             	sub    $0x4,%esp
80105530:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105536:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105538:	68 80 00 00 00       	push   $0x80
8010553d:	6a 00                	push   $0x0
8010553f:	56                   	push   %esi
80105540:	e8 8b f1 ff ff       	call   801046d0 <memset>
80105545:	83 c4 10             	add    $0x10,%esp
80105548:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010554f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105550:	83 ec 08             	sub    $0x8,%esp
80105553:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105559:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105560:	50                   	push   %eax
80105561:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105567:	01 f8                	add    %edi,%eax
80105569:	50                   	push   %eax
8010556a:	e8 81 f3 ff ff       	call   801048f0 <fetchint>
8010556f:	83 c4 10             	add    $0x10,%esp
80105572:	85 c0                	test   %eax,%eax
80105574:	78 26                	js     8010559c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105576:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010557c:	85 c0                	test   %eax,%eax
8010557e:	74 30                	je     801055b0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105586:	52                   	push   %edx
80105587:	50                   	push   %eax
80105588:	e8 a3 f3 ff ff       	call   80104930 <fetchstr>
8010558d:	83 c4 10             	add    $0x10,%esp
80105590:	85 c0                	test   %eax,%eax
80105592:	78 08                	js     8010559c <sys_exec+0xac>
  for(i=0;; i++){
80105594:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105597:	83 fb 20             	cmp    $0x20,%ebx
8010559a:	75 b4                	jne    80105550 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010559c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010559f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a4:	5b                   	pop    %ebx
801055a5:	5e                   	pop    %esi
801055a6:	5f                   	pop    %edi
801055a7:	5d                   	pop    %ebp
801055a8:	c3                   	ret
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055b0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055b7:	00 00 00 00 
  return exec(path, argv);
801055bb:	83 ec 08             	sub    $0x8,%esp
801055be:	56                   	push   %esi
801055bf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801055c5:	e8 16 b5 ff ff       	call   80100ae0 <exec>
801055ca:	83 c4 10             	add    $0x10,%esp
}
801055cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d0:	5b                   	pop    %ebx
801055d1:	5e                   	pop    %esi
801055d2:	5f                   	pop    %edi
801055d3:	5d                   	pop    %ebp
801055d4:	c3                   	ret
801055d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055dc:	00 
801055dd:	8d 76 00             	lea    0x0(%esi),%esi

801055e0 <sys_pipe>:

int
sys_pipe(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055e8:	53                   	push   %ebx
801055e9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055ec:	6a 08                	push   $0x8
801055ee:	50                   	push   %eax
801055ef:	6a 00                	push   $0x0
801055f1:	e8 da f3 ff ff       	call   801049d0 <argptr>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	0f 88 8b 00 00 00    	js     8010568c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105601:	83 ec 08             	sub    $0x8,%esp
80105604:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105607:	50                   	push   %eax
80105608:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010560b:	50                   	push   %eax
8010560c:	e8 2f de ff ff       	call   80103440 <pipealloc>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	78 74                	js     8010568c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105618:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010561b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010561d:	e8 6e e3 ff ff       	call   80103990 <myproc>
    if(curproc->ofile[fd] == 0){
80105622:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105626:	85 f6                	test   %esi,%esi
80105628:	74 16                	je     80105640 <sys_pipe+0x60>
8010562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105630:	83 c3 01             	add    $0x1,%ebx
80105633:	83 fb 10             	cmp    $0x10,%ebx
80105636:	74 3d                	je     80105675 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105638:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010563c:	85 f6                	test   %esi,%esi
8010563e:	75 f0                	jne    80105630 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105640:	8d 73 08             	lea    0x8(%ebx),%esi
80105643:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010564a:	e8 41 e3 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010564f:	31 d2                	xor    %edx,%edx
80105651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105658:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010565c:	85 c9                	test   %ecx,%ecx
8010565e:	74 38                	je     80105698 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105660:	83 c2 01             	add    $0x1,%edx
80105663:	83 fa 10             	cmp    $0x10,%edx
80105666:	75 f0                	jne    80105658 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105668:	e8 23 e3 ff ff       	call   80103990 <myproc>
8010566d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105674:	00 
    fileclose(rf);
80105675:	83 ec 0c             	sub    $0xc,%esp
80105678:	ff 75 e0             	push   -0x20(%ebp)
8010567b:	e8 c0 b8 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105680:	58                   	pop    %eax
80105681:	ff 75 e4             	push   -0x1c(%ebp)
80105684:	e8 b7 b8 ff ff       	call   80100f40 <fileclose>
    return -1;
80105689:	83 c4 10             	add    $0x10,%esp
    return -1;
8010568c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105691:	eb 16                	jmp    801056a9 <sys_pipe+0xc9>
80105693:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105698:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010569c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010569f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056a4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056a7:	31 c0                	xor    %eax,%eax
}
801056a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ac:	5b                   	pop    %ebx
801056ad:	5e                   	pop    %esi
801056ae:	5f                   	pop    %edi
801056af:	5d                   	pop    %ebp
801056b0:	c3                   	ret
801056b1:	66 90                	xchg   %ax,%ax
801056b3:	66 90                	xchg   %ax,%ax
801056b5:	66 90                	xchg   %ax,%ax
801056b7:	66 90                	xchg   %ax,%ax
801056b9:	66 90                	xchg   %ax,%ax
801056bb:	66 90                	xchg   %ax,%ax
801056bd:	66 90                	xchg   %ax,%ax
801056bf:	90                   	nop

801056c0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801056c0:	e9 6b e4 ff ff       	jmp    80103b30 <fork>
801056c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056cc:	00 
801056cd:	8d 76 00             	lea    0x0(%esi),%esi

801056d0 <sys_exit>:
}

int
sys_exit(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056d6:	e8 c5 e6 ff ff       	call   80103da0 <exit>
  return 0;  // not reached
}
801056db:	31 c0                	xor    %eax,%eax
801056dd:	c9                   	leave
801056de:	c3                   	ret
801056df:	90                   	nop

801056e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801056e0:	e9 eb e7 ff ff       	jmp    80103ed0 <wait>
801056e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ec:	00 
801056ed:	8d 76 00             	lea    0x0(%esi),%esi

801056f0 <sys_kill>:
}

int
sys_kill(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801056f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	6a 00                	push   $0x0
801056fc:	e8 7f f2 ff ff       	call   80104980 <argint>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	78 18                	js     80105720 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	ff 75 f4             	push   -0xc(%ebp)
8010570e:	e8 5d ea ff ff       	call   80104170 <kill>
80105713:	83 c4 10             	add    $0x10,%esp
}
80105716:	c9                   	leave
80105717:	c3                   	ret
80105718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010571f:	00 
80105720:	c9                   	leave
    return -1;
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105726:	c3                   	ret
80105727:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010572e:	00 
8010572f:	90                   	nop

80105730 <sys_getpid>:

int
sys_getpid(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105736:	e8 55 e2 ff ff       	call   80103990 <myproc>
8010573b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010573e:	c9                   	leave
8010573f:	c3                   	ret

80105740 <sys_sbrk>:

int
sys_sbrk(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105744:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105747:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010574a:	50                   	push   %eax
8010574b:	6a 00                	push   $0x0
8010574d:	e8 2e f2 ff ff       	call   80104980 <argint>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 27                	js     80105780 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105759:	e8 32 e2 ff ff       	call   80103990 <myproc>
  if(growproc(n) < 0)
8010575e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105761:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105763:	ff 75 f4             	push   -0xc(%ebp)
80105766:	e8 45 e3 ff ff       	call   80103ab0 <growproc>
8010576b:	83 c4 10             	add    $0x10,%esp
8010576e:	85 c0                	test   %eax,%eax
80105770:	78 0e                	js     80105780 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105772:	89 d8                	mov    %ebx,%eax
80105774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105777:	c9                   	leave
80105778:	c3                   	ret
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105780:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105785:	eb eb                	jmp    80105772 <sys_sbrk+0x32>
80105787:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010578e:	00 
8010578f:	90                   	nop

80105790 <sys_sleep>:

int
sys_sleep(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105797:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 de f1 ff ff       	call   80104980 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 64                	js     8010580d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	68 80 3c 11 80       	push   $0x80113c80
801057b1:	e8 1a ee ff ff       	call   801045d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057b9:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 d2                	test   %edx,%edx
801057c4:	75 2b                	jne    801057f1 <sys_sleep+0x61>
801057c6:	eb 58                	jmp    80105820 <sys_sleep+0x90>
801057c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057cf:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	68 80 3c 11 80       	push   $0x80113c80
801057d8:	68 60 3c 11 80       	push   $0x80113c60
801057dd:	e8 6e e8 ff ff       	call   80104050 <sleep>
  while(ticks - ticks0 < n){
801057e2:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801057e7:	83 c4 10             	add    $0x10,%esp
801057ea:	29 d8                	sub    %ebx,%eax
801057ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057ef:	73 2f                	jae    80105820 <sys_sleep+0x90>
    if(myproc()->killed){
801057f1:	e8 9a e1 ff ff       	call   80103990 <myproc>
801057f6:	8b 40 24             	mov    0x24(%eax),%eax
801057f9:	85 c0                	test   %eax,%eax
801057fb:	74 d3                	je     801057d0 <sys_sleep+0x40>
      release(&tickslock);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	68 80 3c 11 80       	push   $0x80113c80
80105805:	e8 66 ed ff ff       	call   80104570 <release>
      return -1;
8010580a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010580d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105815:	c9                   	leave
80105816:	c3                   	ret
80105817:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581e:	00 
8010581f:	90                   	nop
  release(&tickslock);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	68 80 3c 11 80       	push   $0x80113c80
80105828:	e8 43 ed ff ff       	call   80104570 <release>
}
8010582d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105830:	83 c4 10             	add    $0x10,%esp
80105833:	31 c0                	xor    %eax,%eax
}
80105835:	c9                   	leave
80105836:	c3                   	ret
80105837:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583e:	00 
8010583f:	90                   	nop

80105840 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
80105844:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105847:	68 80 3c 11 80       	push   $0x80113c80
8010584c:	e8 7f ed ff ff       	call   801045d0 <acquire>
  xticks = ticks;
80105851:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105857:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
8010585e:	e8 0d ed ff ff       	call   80104570 <release>
  return xticks;
}
80105863:	89 d8                	mov    %ebx,%eax
80105865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105868:	c9                   	leave
80105869:	c3                   	ret

8010586a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010586a:	1e                   	push   %ds
  pushl %es
8010586b:	06                   	push   %es
  pushl %fs
8010586c:	0f a0                	push   %fs
  pushl %gs
8010586e:	0f a8                	push   %gs
  pushal
80105870:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105871:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105875:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105877:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105879:	54                   	push   %esp
  call trap
8010587a:	e8 c1 00 00 00       	call   80105940 <trap>
  addl $4, %esp
8010587f:	83 c4 04             	add    $0x4,%esp

80105882 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105882:	61                   	popa
  popl %gs
80105883:	0f a9                	pop    %gs
  popl %fs
80105885:	0f a1                	pop    %fs
  popl %es
80105887:	07                   	pop    %es
  popl %ds
80105888:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105889:	83 c4 08             	add    $0x8,%esp
  iret
8010588c:	cf                   	iret
8010588d:	66 90                	xchg   %ax,%ax
8010588f:	90                   	nop

80105890 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105890:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105891:	31 c0                	xor    %eax,%eax
{
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 08             	sub    $0x8,%esp
80105898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058a0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058a7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801058ae:	08 00 00 8e 
801058b2:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
801058b9:	80 
801058ba:	c1 ea 10             	shr    $0x10,%edx
801058bd:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
801058c4:	80 
  for(i = 0; i < 256; i++)
801058c5:	83 c0 01             	add    $0x1,%eax
801058c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801058cd:	75 d1                	jne    801058a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801058cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058d2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801058d7:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
801058de:	00 00 ef 
  initlock(&tickslock, "time");
801058e1:	68 8e 75 10 80       	push   $0x8010758e
801058e6:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058eb:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
801058f1:	c1 e8 10             	shr    $0x10,%eax
801058f4:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
801058fa:	e8 e1 ea ff ff       	call   801043e0 <initlock>
}
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	c9                   	leave
80105903:	c3                   	ret
80105904:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010590b:	00 
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <idtinit>:

void
idtinit(void)
{
80105910:	55                   	push   %ebp
  pd[0] = size-1;
80105911:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105916:	89 e5                	mov    %esp,%ebp
80105918:	83 ec 10             	sub    $0x10,%esp
8010591b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010591f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105924:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105928:	c1 e8 10             	shr    $0x10,%eax
8010592b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010592f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105932:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105935:	c9                   	leave
80105936:	c3                   	ret
80105937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593e:	00 
8010593f:	90                   	nop

80105940 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
80105946:	83 ec 1c             	sub    $0x1c,%esp
80105949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010594c:	8b 43 30             	mov    0x30(%ebx),%eax
8010594f:	83 f8 40             	cmp    $0x40,%eax
80105952:	0f 84 58 01 00 00    	je     80105ab0 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105958:	83 e8 20             	sub    $0x20,%eax
8010595b:	83 f8 1f             	cmp    $0x1f,%eax
8010595e:	0f 87 7c 00 00 00    	ja     801059e0 <trap+0xa0>
80105964:	ff 24 85 f8 7a 10 80 	jmp    *-0x7fef8508(,%eax,4)
8010596b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105970:	e8 eb c8 ff ff       	call   80102260 <ideintr>
    lapiceoi();
80105975:	e8 a6 cf ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010597a:	e8 11 e0 ff ff       	call   80103990 <myproc>
8010597f:	85 c0                	test   %eax,%eax
80105981:	74 1a                	je     8010599d <trap+0x5d>
80105983:	e8 08 e0 ff ff       	call   80103990 <myproc>
80105988:	8b 50 24             	mov    0x24(%eax),%edx
8010598b:	85 d2                	test   %edx,%edx
8010598d:	74 0e                	je     8010599d <trap+0x5d>
8010598f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105993:	f7 d0                	not    %eax
80105995:	a8 03                	test   $0x3,%al
80105997:	0f 84 db 01 00 00    	je     80105b78 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010599d:	e8 ee df ff ff       	call   80103990 <myproc>
801059a2:	85 c0                	test   %eax,%eax
801059a4:	74 0f                	je     801059b5 <trap+0x75>
801059a6:	e8 e5 df ff ff       	call   80103990 <myproc>
801059ab:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059af:	0f 84 ab 00 00 00    	je     80105a60 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059b5:	e8 d6 df ff ff       	call   80103990 <myproc>
801059ba:	85 c0                	test   %eax,%eax
801059bc:	74 1a                	je     801059d8 <trap+0x98>
801059be:	e8 cd df ff ff       	call   80103990 <myproc>
801059c3:	8b 40 24             	mov    0x24(%eax),%eax
801059c6:	85 c0                	test   %eax,%eax
801059c8:	74 0e                	je     801059d8 <trap+0x98>
801059ca:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059ce:	f7 d0                	not    %eax
801059d0:	a8 03                	test   $0x3,%al
801059d2:	0f 84 05 01 00 00    	je     80105add <trap+0x19d>
    exit();
}
801059d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059db:	5b                   	pop    %ebx
801059dc:	5e                   	pop    %esi
801059dd:	5f                   	pop    %edi
801059de:	5d                   	pop    %ebp
801059df:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
801059e0:	e8 ab df ff ff       	call   80103990 <myproc>
801059e5:	8b 7b 38             	mov    0x38(%ebx),%edi
801059e8:	85 c0                	test   %eax,%eax
801059ea:	0f 84 a2 01 00 00    	je     80105b92 <trap+0x252>
801059f0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801059f4:	0f 84 98 01 00 00    	je     80105b92 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059fa:	0f 20 d1             	mov    %cr2,%ecx
801059fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a00:	e8 6b df ff ff       	call   80103970 <cpuid>
80105a05:	8b 73 30             	mov    0x30(%ebx),%esi
80105a08:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a0b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a11:	e8 7a df ff ff       	call   80103990 <myproc>
80105a16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a19:	e8 72 df ff ff       	call   80103990 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a21:	51                   	push   %ecx
80105a22:	57                   	push   %edi
80105a23:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a26:	52                   	push   %edx
80105a27:	ff 75 e4             	push   -0x1c(%ebp)
80105a2a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a2b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a2e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a31:	56                   	push   %esi
80105a32:	ff 70 10             	push   0x10(%eax)
80105a35:	68 dc 77 10 80       	push   $0x801077dc
80105a3a:	e8 a1 ac ff ff       	call   801006e0 <cprintf>
    myproc()->killed = 1;
80105a3f:	83 c4 20             	add    $0x20,%esp
80105a42:	e8 49 df ff ff       	call   80103990 <myproc>
80105a47:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a4e:	e8 3d df ff ff       	call   80103990 <myproc>
80105a53:	85 c0                	test   %eax,%eax
80105a55:	0f 85 28 ff ff ff    	jne    80105983 <trap+0x43>
80105a5b:	e9 3d ff ff ff       	jmp    8010599d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105a60:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a64:	0f 85 4b ff ff ff    	jne    801059b5 <trap+0x75>
    yield();
80105a6a:	e8 91 e5 ff ff       	call   80104000 <yield>
80105a6f:	e9 41 ff ff ff       	jmp    801059b5 <trap+0x75>
80105a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a78:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a7b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105a7f:	e8 ec de ff ff       	call   80103970 <cpuid>
80105a84:	57                   	push   %edi
80105a85:	56                   	push   %esi
80105a86:	50                   	push   %eax
80105a87:	68 84 77 10 80       	push   $0x80107784
80105a8c:	e8 4f ac ff ff       	call   801006e0 <cprintf>
    lapiceoi();
80105a91:	e8 8a ce ff ff       	call   80102920 <lapiceoi>
    break;
80105a96:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a99:	e8 f2 de ff ff       	call   80103990 <myproc>
80105a9e:	85 c0                	test   %eax,%eax
80105aa0:	0f 85 dd fe ff ff    	jne    80105983 <trap+0x43>
80105aa6:	e9 f2 fe ff ff       	jmp    8010599d <trap+0x5d>
80105aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ab0:	e8 db de ff ff       	call   80103990 <myproc>
80105ab5:	8b 70 24             	mov    0x24(%eax),%esi
80105ab8:	85 f6                	test   %esi,%esi
80105aba:	0f 85 c8 00 00 00    	jne    80105b88 <trap+0x248>
    myproc()->tf = tf;
80105ac0:	e8 cb de ff ff       	call   80103990 <myproc>
80105ac5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105ac8:	e8 f3 ef ff ff       	call   80104ac0 <syscall>
    if(myproc()->killed)
80105acd:	e8 be de ff ff       	call   80103990 <myproc>
80105ad2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ad5:	85 c9                	test   %ecx,%ecx
80105ad7:	0f 84 fb fe ff ff    	je     801059d8 <trap+0x98>
}
80105add:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae0:	5b                   	pop    %ebx
80105ae1:	5e                   	pop    %esi
80105ae2:	5f                   	pop    %edi
80105ae3:	5d                   	pop    %ebp
      exit();
80105ae4:	e9 b7 e2 ff ff       	jmp    80103da0 <exit>
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105af0:	e8 4b 02 00 00       	call   80105d40 <uartintr>
    lapiceoi();
80105af5:	e8 26 ce ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105afa:	e8 91 de ff ff       	call   80103990 <myproc>
80105aff:	85 c0                	test   %eax,%eax
80105b01:	0f 85 7c fe ff ff    	jne    80105983 <trap+0x43>
80105b07:	e9 91 fe ff ff       	jmp    8010599d <trap+0x5d>
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b10:	e8 db cc ff ff       	call   801027f0 <kbdintr>
    lapiceoi();
80105b15:	e8 06 ce ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b1a:	e8 71 de ff ff       	call   80103990 <myproc>
80105b1f:	85 c0                	test   %eax,%eax
80105b21:	0f 85 5c fe ff ff    	jne    80105983 <trap+0x43>
80105b27:	e9 71 fe ff ff       	jmp    8010599d <trap+0x5d>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105b30:	e8 3b de ff ff       	call   80103970 <cpuid>
80105b35:	85 c0                	test   %eax,%eax
80105b37:	0f 85 38 fe ff ff    	jne    80105975 <trap+0x35>
      acquire(&tickslock);
80105b3d:	83 ec 0c             	sub    $0xc,%esp
80105b40:	68 80 3c 11 80       	push   $0x80113c80
80105b45:	e8 86 ea ff ff       	call   801045d0 <acquire>
      ticks++;
80105b4a:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105b51:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105b58:	e8 b3 e5 ff ff       	call   80104110 <wakeup>
      release(&tickslock);
80105b5d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105b64:	e8 07 ea ff ff       	call   80104570 <release>
80105b69:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105b6c:	e9 04 fe ff ff       	jmp    80105975 <trap+0x35>
80105b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105b78:	e8 23 e2 ff ff       	call   80103da0 <exit>
80105b7d:	e9 1b fe ff ff       	jmp    8010599d <trap+0x5d>
80105b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105b88:	e8 13 e2 ff ff       	call   80103da0 <exit>
80105b8d:	e9 2e ff ff ff       	jmp    80105ac0 <trap+0x180>
80105b92:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b95:	e8 d6 dd ff ff       	call   80103970 <cpuid>
80105b9a:	83 ec 0c             	sub    $0xc,%esp
80105b9d:	56                   	push   %esi
80105b9e:	57                   	push   %edi
80105b9f:	50                   	push   %eax
80105ba0:	ff 73 30             	push   0x30(%ebx)
80105ba3:	68 a8 77 10 80       	push   $0x801077a8
80105ba8:	e8 33 ab ff ff       	call   801006e0 <cprintf>
      panic("trap");
80105bad:	83 c4 14             	add    $0x14,%esp
80105bb0:	68 93 75 10 80       	push   $0x80107593
80105bb5:	e8 c6 a7 ff ff       	call   80100380 <panic>
80105bba:	66 90                	xchg   %ax,%ax
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105bc0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 17                	je     80105be0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bc9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105bcf:	a8 01                	test   $0x1,%al
80105bd1:	74 0d                	je     80105be0 <uartgetc+0x20>
80105bd3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bd8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105bd9:	0f b6 c0             	movzbl %al,%eax
80105bdc:	c3                   	ret
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be5:	c3                   	ret
80105be6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bed:	00 
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <uartinit>:
{
80105bf0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bf1:	31 c9                	xor    %ecx,%ecx
80105bf3:	89 c8                	mov    %ecx,%eax
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	57                   	push   %edi
80105bf8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105bfd:	56                   	push   %esi
80105bfe:	89 fa                	mov    %edi,%edx
80105c00:	53                   	push   %ebx
80105c01:	83 ec 1c             	sub    $0x1c,%esp
80105c04:	ee                   	out    %al,(%dx)
80105c05:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c0f:	89 f2                	mov    %esi,%edx
80105c11:	ee                   	out    %al,(%dx)
80105c12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c1c:	ee                   	out    %al,(%dx)
80105c1d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c22:	89 c8                	mov    %ecx,%eax
80105c24:	89 da                	mov    %ebx,%edx
80105c26:	ee                   	out    %al,(%dx)
80105c27:	b8 03 00 00 00       	mov    $0x3,%eax
80105c2c:	89 f2                	mov    %esi,%edx
80105c2e:	ee                   	out    %al,(%dx)
80105c2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c34:	89 c8                	mov    %ecx,%eax
80105c36:	ee                   	out    %al,(%dx)
80105c37:	b8 01 00 00 00       	mov    $0x1,%eax
80105c3c:	89 da                	mov    %ebx,%edx
80105c3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c44:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c45:	3c ff                	cmp    $0xff,%al
80105c47:	0f 84 7c 00 00 00    	je     80105cc9 <uartinit+0xd9>
  uart = 1;
80105c4d:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105c54:	00 00 00 
80105c57:	89 fa                	mov    %edi,%edx
80105c59:	ec                   	in     (%dx),%al
80105c5a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c5f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c60:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105c63:	bf 98 75 10 80       	mov    $0x80107598,%edi
80105c68:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105c6d:	6a 00                	push   $0x0
80105c6f:	6a 04                	push   $0x4
80105c71:	e8 1a c8 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105c76:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105c80:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 32                	je     80105cbb <uartinit+0xcb>
80105c89:	89 f2                	mov    %esi,%edx
80105c8b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c8c:	a8 20                	test   $0x20,%al
80105c8e:	75 21                	jne    80105cb1 <uartinit+0xc1>
80105c90:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c95:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	6a 0a                	push   $0xa
80105c9d:	e8 9e cc ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	83 eb 01             	sub    $0x1,%ebx
80105ca8:	74 07                	je     80105cb1 <uartinit+0xc1>
80105caa:	89 f2                	mov    %esi,%edx
80105cac:	ec                   	in     (%dx),%al
80105cad:	a8 20                	test   $0x20,%al
80105caf:	74 e7                	je     80105c98 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cb1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cb6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105cba:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105cbb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105cbf:	83 c7 01             	add    $0x1,%edi
80105cc2:	88 45 e7             	mov    %al,-0x19(%ebp)
80105cc5:	84 c0                	test   %al,%al
80105cc7:	75 b7                	jne    80105c80 <uartinit+0x90>
}
80105cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ccc:	5b                   	pop    %ebx
80105ccd:	5e                   	pop    %esi
80105cce:	5f                   	pop    %edi
80105ccf:	5d                   	pop    %ebp
80105cd0:	c3                   	ret
80105cd1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cd8:	00 
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <uartputc>:
  if(!uart)
80105ce0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	74 4f                	je     80105d38 <uartputc+0x58>
{
80105ce9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cea:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cef:	89 e5                	mov    %esp,%ebp
80105cf1:	56                   	push   %esi
80105cf2:	53                   	push   %ebx
80105cf3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cf4:	a8 20                	test   $0x20,%al
80105cf6:	75 29                	jne    80105d21 <uartputc+0x41>
80105cf8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cfd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	6a 0a                	push   $0xa
80105d0d:	e8 2e cc ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	83 eb 01             	sub    $0x1,%ebx
80105d18:	74 07                	je     80105d21 <uartputc+0x41>
80105d1a:	89 f2                	mov    %esi,%edx
80105d1c:	ec                   	in     (%dx),%al
80105d1d:	a8 20                	test   $0x20,%al
80105d1f:	74 e7                	je     80105d08 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d21:	8b 45 08             	mov    0x8(%ebp),%eax
80105d24:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d29:	ee                   	out    %al,(%dx)
}
80105d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d2d:	5b                   	pop    %ebx
80105d2e:	5e                   	pop    %esi
80105d2f:	5d                   	pop    %ebp
80105d30:	c3                   	ret
80105d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d38:	c3                   	ret
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d40 <uartintr>:

void
uartintr(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d46:	68 c0 5b 10 80       	push   $0x80105bc0
80105d4b:	e8 80 ab ff ff       	call   801008d0 <consoleintr>
}
80105d50:	83 c4 10             	add    $0x10,%esp
80105d53:	c9                   	leave
80105d54:	c3                   	ret

80105d55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $0
80105d57:	6a 00                	push   $0x0
  jmp alltraps
80105d59:	e9 0c fb ff ff       	jmp    8010586a <alltraps>

80105d5e <vector1>:
.globl vector1
vector1:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $1
80105d60:	6a 01                	push   $0x1
  jmp alltraps
80105d62:	e9 03 fb ff ff       	jmp    8010586a <alltraps>

80105d67 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $2
80105d69:	6a 02                	push   $0x2
  jmp alltraps
80105d6b:	e9 fa fa ff ff       	jmp    8010586a <alltraps>

80105d70 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $3
80105d72:	6a 03                	push   $0x3
  jmp alltraps
80105d74:	e9 f1 fa ff ff       	jmp    8010586a <alltraps>

80105d79 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $4
80105d7b:	6a 04                	push   $0x4
  jmp alltraps
80105d7d:	e9 e8 fa ff ff       	jmp    8010586a <alltraps>

80105d82 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $5
80105d84:	6a 05                	push   $0x5
  jmp alltraps
80105d86:	e9 df fa ff ff       	jmp    8010586a <alltraps>

80105d8b <vector6>:
.globl vector6
vector6:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $6
80105d8d:	6a 06                	push   $0x6
  jmp alltraps
80105d8f:	e9 d6 fa ff ff       	jmp    8010586a <alltraps>

80105d94 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $7
80105d96:	6a 07                	push   $0x7
  jmp alltraps
80105d98:	e9 cd fa ff ff       	jmp    8010586a <alltraps>

80105d9d <vector8>:
.globl vector8
vector8:
  pushl $8
80105d9d:	6a 08                	push   $0x8
  jmp alltraps
80105d9f:	e9 c6 fa ff ff       	jmp    8010586a <alltraps>

80105da4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $9
80105da6:	6a 09                	push   $0x9
  jmp alltraps
80105da8:	e9 bd fa ff ff       	jmp    8010586a <alltraps>

80105dad <vector10>:
.globl vector10
vector10:
  pushl $10
80105dad:	6a 0a                	push   $0xa
  jmp alltraps
80105daf:	e9 b6 fa ff ff       	jmp    8010586a <alltraps>

80105db4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105db4:	6a 0b                	push   $0xb
  jmp alltraps
80105db6:	e9 af fa ff ff       	jmp    8010586a <alltraps>

80105dbb <vector12>:
.globl vector12
vector12:
  pushl $12
80105dbb:	6a 0c                	push   $0xc
  jmp alltraps
80105dbd:	e9 a8 fa ff ff       	jmp    8010586a <alltraps>

80105dc2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105dc2:	6a 0d                	push   $0xd
  jmp alltraps
80105dc4:	e9 a1 fa ff ff       	jmp    8010586a <alltraps>

80105dc9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105dc9:	6a 0e                	push   $0xe
  jmp alltraps
80105dcb:	e9 9a fa ff ff       	jmp    8010586a <alltraps>

80105dd0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $15
80105dd2:	6a 0f                	push   $0xf
  jmp alltraps
80105dd4:	e9 91 fa ff ff       	jmp    8010586a <alltraps>

80105dd9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $16
80105ddb:	6a 10                	push   $0x10
  jmp alltraps
80105ddd:	e9 88 fa ff ff       	jmp    8010586a <alltraps>

80105de2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105de2:	6a 11                	push   $0x11
  jmp alltraps
80105de4:	e9 81 fa ff ff       	jmp    8010586a <alltraps>

80105de9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $18
80105deb:	6a 12                	push   $0x12
  jmp alltraps
80105ded:	e9 78 fa ff ff       	jmp    8010586a <alltraps>

80105df2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $19
80105df4:	6a 13                	push   $0x13
  jmp alltraps
80105df6:	e9 6f fa ff ff       	jmp    8010586a <alltraps>

80105dfb <vector20>:
.globl vector20
vector20:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $20
80105dfd:	6a 14                	push   $0x14
  jmp alltraps
80105dff:	e9 66 fa ff ff       	jmp    8010586a <alltraps>

80105e04 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $21
80105e06:	6a 15                	push   $0x15
  jmp alltraps
80105e08:	e9 5d fa ff ff       	jmp    8010586a <alltraps>

80105e0d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $22
80105e0f:	6a 16                	push   $0x16
  jmp alltraps
80105e11:	e9 54 fa ff ff       	jmp    8010586a <alltraps>

80105e16 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $23
80105e18:	6a 17                	push   $0x17
  jmp alltraps
80105e1a:	e9 4b fa ff ff       	jmp    8010586a <alltraps>

80105e1f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $24
80105e21:	6a 18                	push   $0x18
  jmp alltraps
80105e23:	e9 42 fa ff ff       	jmp    8010586a <alltraps>

80105e28 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $25
80105e2a:	6a 19                	push   $0x19
  jmp alltraps
80105e2c:	e9 39 fa ff ff       	jmp    8010586a <alltraps>

80105e31 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $26
80105e33:	6a 1a                	push   $0x1a
  jmp alltraps
80105e35:	e9 30 fa ff ff       	jmp    8010586a <alltraps>

80105e3a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $27
80105e3c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e3e:	e9 27 fa ff ff       	jmp    8010586a <alltraps>

80105e43 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $28
80105e45:	6a 1c                	push   $0x1c
  jmp alltraps
80105e47:	e9 1e fa ff ff       	jmp    8010586a <alltraps>

80105e4c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $29
80105e4e:	6a 1d                	push   $0x1d
  jmp alltraps
80105e50:	e9 15 fa ff ff       	jmp    8010586a <alltraps>

80105e55 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $30
80105e57:	6a 1e                	push   $0x1e
  jmp alltraps
80105e59:	e9 0c fa ff ff       	jmp    8010586a <alltraps>

80105e5e <vector31>:
.globl vector31
vector31:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $31
80105e60:	6a 1f                	push   $0x1f
  jmp alltraps
80105e62:	e9 03 fa ff ff       	jmp    8010586a <alltraps>

80105e67 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $32
80105e69:	6a 20                	push   $0x20
  jmp alltraps
80105e6b:	e9 fa f9 ff ff       	jmp    8010586a <alltraps>

80105e70 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $33
80105e72:	6a 21                	push   $0x21
  jmp alltraps
80105e74:	e9 f1 f9 ff ff       	jmp    8010586a <alltraps>

80105e79 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $34
80105e7b:	6a 22                	push   $0x22
  jmp alltraps
80105e7d:	e9 e8 f9 ff ff       	jmp    8010586a <alltraps>

80105e82 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $35
80105e84:	6a 23                	push   $0x23
  jmp alltraps
80105e86:	e9 df f9 ff ff       	jmp    8010586a <alltraps>

80105e8b <vector36>:
.globl vector36
vector36:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $36
80105e8d:	6a 24                	push   $0x24
  jmp alltraps
80105e8f:	e9 d6 f9 ff ff       	jmp    8010586a <alltraps>

80105e94 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $37
80105e96:	6a 25                	push   $0x25
  jmp alltraps
80105e98:	e9 cd f9 ff ff       	jmp    8010586a <alltraps>

80105e9d <vector38>:
.globl vector38
vector38:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $38
80105e9f:	6a 26                	push   $0x26
  jmp alltraps
80105ea1:	e9 c4 f9 ff ff       	jmp    8010586a <alltraps>

80105ea6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $39
80105ea8:	6a 27                	push   $0x27
  jmp alltraps
80105eaa:	e9 bb f9 ff ff       	jmp    8010586a <alltraps>

80105eaf <vector40>:
.globl vector40
vector40:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $40
80105eb1:	6a 28                	push   $0x28
  jmp alltraps
80105eb3:	e9 b2 f9 ff ff       	jmp    8010586a <alltraps>

80105eb8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $41
80105eba:	6a 29                	push   $0x29
  jmp alltraps
80105ebc:	e9 a9 f9 ff ff       	jmp    8010586a <alltraps>

80105ec1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $42
80105ec3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ec5:	e9 a0 f9 ff ff       	jmp    8010586a <alltraps>

80105eca <vector43>:
.globl vector43
vector43:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $43
80105ecc:	6a 2b                	push   $0x2b
  jmp alltraps
80105ece:	e9 97 f9 ff ff       	jmp    8010586a <alltraps>

80105ed3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $44
80105ed5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ed7:	e9 8e f9 ff ff       	jmp    8010586a <alltraps>

80105edc <vector45>:
.globl vector45
vector45:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $45
80105ede:	6a 2d                	push   $0x2d
  jmp alltraps
80105ee0:	e9 85 f9 ff ff       	jmp    8010586a <alltraps>

80105ee5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $46
80105ee7:	6a 2e                	push   $0x2e
  jmp alltraps
80105ee9:	e9 7c f9 ff ff       	jmp    8010586a <alltraps>

80105eee <vector47>:
.globl vector47
vector47:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $47
80105ef0:	6a 2f                	push   $0x2f
  jmp alltraps
80105ef2:	e9 73 f9 ff ff       	jmp    8010586a <alltraps>

80105ef7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $48
80105ef9:	6a 30                	push   $0x30
  jmp alltraps
80105efb:	e9 6a f9 ff ff       	jmp    8010586a <alltraps>

80105f00 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $49
80105f02:	6a 31                	push   $0x31
  jmp alltraps
80105f04:	e9 61 f9 ff ff       	jmp    8010586a <alltraps>

80105f09 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $50
80105f0b:	6a 32                	push   $0x32
  jmp alltraps
80105f0d:	e9 58 f9 ff ff       	jmp    8010586a <alltraps>

80105f12 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $51
80105f14:	6a 33                	push   $0x33
  jmp alltraps
80105f16:	e9 4f f9 ff ff       	jmp    8010586a <alltraps>

80105f1b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $52
80105f1d:	6a 34                	push   $0x34
  jmp alltraps
80105f1f:	e9 46 f9 ff ff       	jmp    8010586a <alltraps>

80105f24 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $53
80105f26:	6a 35                	push   $0x35
  jmp alltraps
80105f28:	e9 3d f9 ff ff       	jmp    8010586a <alltraps>

80105f2d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $54
80105f2f:	6a 36                	push   $0x36
  jmp alltraps
80105f31:	e9 34 f9 ff ff       	jmp    8010586a <alltraps>

80105f36 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $55
80105f38:	6a 37                	push   $0x37
  jmp alltraps
80105f3a:	e9 2b f9 ff ff       	jmp    8010586a <alltraps>

80105f3f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $56
80105f41:	6a 38                	push   $0x38
  jmp alltraps
80105f43:	e9 22 f9 ff ff       	jmp    8010586a <alltraps>

80105f48 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $57
80105f4a:	6a 39                	push   $0x39
  jmp alltraps
80105f4c:	e9 19 f9 ff ff       	jmp    8010586a <alltraps>

80105f51 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $58
80105f53:	6a 3a                	push   $0x3a
  jmp alltraps
80105f55:	e9 10 f9 ff ff       	jmp    8010586a <alltraps>

80105f5a <vector59>:
.globl vector59
vector59:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $59
80105f5c:	6a 3b                	push   $0x3b
  jmp alltraps
80105f5e:	e9 07 f9 ff ff       	jmp    8010586a <alltraps>

80105f63 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $60
80105f65:	6a 3c                	push   $0x3c
  jmp alltraps
80105f67:	e9 fe f8 ff ff       	jmp    8010586a <alltraps>

80105f6c <vector61>:
.globl vector61
vector61:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $61
80105f6e:	6a 3d                	push   $0x3d
  jmp alltraps
80105f70:	e9 f5 f8 ff ff       	jmp    8010586a <alltraps>

80105f75 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $62
80105f77:	6a 3e                	push   $0x3e
  jmp alltraps
80105f79:	e9 ec f8 ff ff       	jmp    8010586a <alltraps>

80105f7e <vector63>:
.globl vector63
vector63:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $63
80105f80:	6a 3f                	push   $0x3f
  jmp alltraps
80105f82:	e9 e3 f8 ff ff       	jmp    8010586a <alltraps>

80105f87 <vector64>:
.globl vector64
vector64:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $64
80105f89:	6a 40                	push   $0x40
  jmp alltraps
80105f8b:	e9 da f8 ff ff       	jmp    8010586a <alltraps>

80105f90 <vector65>:
.globl vector65
vector65:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $65
80105f92:	6a 41                	push   $0x41
  jmp alltraps
80105f94:	e9 d1 f8 ff ff       	jmp    8010586a <alltraps>

80105f99 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $66
80105f9b:	6a 42                	push   $0x42
  jmp alltraps
80105f9d:	e9 c8 f8 ff ff       	jmp    8010586a <alltraps>

80105fa2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $67
80105fa4:	6a 43                	push   $0x43
  jmp alltraps
80105fa6:	e9 bf f8 ff ff       	jmp    8010586a <alltraps>

80105fab <vector68>:
.globl vector68
vector68:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $68
80105fad:	6a 44                	push   $0x44
  jmp alltraps
80105faf:	e9 b6 f8 ff ff       	jmp    8010586a <alltraps>

80105fb4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $69
80105fb6:	6a 45                	push   $0x45
  jmp alltraps
80105fb8:	e9 ad f8 ff ff       	jmp    8010586a <alltraps>

80105fbd <vector70>:
.globl vector70
vector70:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $70
80105fbf:	6a 46                	push   $0x46
  jmp alltraps
80105fc1:	e9 a4 f8 ff ff       	jmp    8010586a <alltraps>

80105fc6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $71
80105fc8:	6a 47                	push   $0x47
  jmp alltraps
80105fca:	e9 9b f8 ff ff       	jmp    8010586a <alltraps>

80105fcf <vector72>:
.globl vector72
vector72:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $72
80105fd1:	6a 48                	push   $0x48
  jmp alltraps
80105fd3:	e9 92 f8 ff ff       	jmp    8010586a <alltraps>

80105fd8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $73
80105fda:	6a 49                	push   $0x49
  jmp alltraps
80105fdc:	e9 89 f8 ff ff       	jmp    8010586a <alltraps>

80105fe1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $74
80105fe3:	6a 4a                	push   $0x4a
  jmp alltraps
80105fe5:	e9 80 f8 ff ff       	jmp    8010586a <alltraps>

80105fea <vector75>:
.globl vector75
vector75:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $75
80105fec:	6a 4b                	push   $0x4b
  jmp alltraps
80105fee:	e9 77 f8 ff ff       	jmp    8010586a <alltraps>

80105ff3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $76
80105ff5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ff7:	e9 6e f8 ff ff       	jmp    8010586a <alltraps>

80105ffc <vector77>:
.globl vector77
vector77:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $77
80105ffe:	6a 4d                	push   $0x4d
  jmp alltraps
80106000:	e9 65 f8 ff ff       	jmp    8010586a <alltraps>

80106005 <vector78>:
.globl vector78
vector78:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $78
80106007:	6a 4e                	push   $0x4e
  jmp alltraps
80106009:	e9 5c f8 ff ff       	jmp    8010586a <alltraps>

8010600e <vector79>:
.globl vector79
vector79:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $79
80106010:	6a 4f                	push   $0x4f
  jmp alltraps
80106012:	e9 53 f8 ff ff       	jmp    8010586a <alltraps>

80106017 <vector80>:
.globl vector80
vector80:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $80
80106019:	6a 50                	push   $0x50
  jmp alltraps
8010601b:	e9 4a f8 ff ff       	jmp    8010586a <alltraps>

80106020 <vector81>:
.globl vector81
vector81:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $81
80106022:	6a 51                	push   $0x51
  jmp alltraps
80106024:	e9 41 f8 ff ff       	jmp    8010586a <alltraps>

80106029 <vector82>:
.globl vector82
vector82:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $82
8010602b:	6a 52                	push   $0x52
  jmp alltraps
8010602d:	e9 38 f8 ff ff       	jmp    8010586a <alltraps>

80106032 <vector83>:
.globl vector83
vector83:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $83
80106034:	6a 53                	push   $0x53
  jmp alltraps
80106036:	e9 2f f8 ff ff       	jmp    8010586a <alltraps>

8010603b <vector84>:
.globl vector84
vector84:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $84
8010603d:	6a 54                	push   $0x54
  jmp alltraps
8010603f:	e9 26 f8 ff ff       	jmp    8010586a <alltraps>

80106044 <vector85>:
.globl vector85
vector85:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $85
80106046:	6a 55                	push   $0x55
  jmp alltraps
80106048:	e9 1d f8 ff ff       	jmp    8010586a <alltraps>

8010604d <vector86>:
.globl vector86
vector86:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $86
8010604f:	6a 56                	push   $0x56
  jmp alltraps
80106051:	e9 14 f8 ff ff       	jmp    8010586a <alltraps>

80106056 <vector87>:
.globl vector87
vector87:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $87
80106058:	6a 57                	push   $0x57
  jmp alltraps
8010605a:	e9 0b f8 ff ff       	jmp    8010586a <alltraps>

8010605f <vector88>:
.globl vector88
vector88:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $88
80106061:	6a 58                	push   $0x58
  jmp alltraps
80106063:	e9 02 f8 ff ff       	jmp    8010586a <alltraps>

80106068 <vector89>:
.globl vector89
vector89:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $89
8010606a:	6a 59                	push   $0x59
  jmp alltraps
8010606c:	e9 f9 f7 ff ff       	jmp    8010586a <alltraps>

80106071 <vector90>:
.globl vector90
vector90:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $90
80106073:	6a 5a                	push   $0x5a
  jmp alltraps
80106075:	e9 f0 f7 ff ff       	jmp    8010586a <alltraps>

8010607a <vector91>:
.globl vector91
vector91:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $91
8010607c:	6a 5b                	push   $0x5b
  jmp alltraps
8010607e:	e9 e7 f7 ff ff       	jmp    8010586a <alltraps>

80106083 <vector92>:
.globl vector92
vector92:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $92
80106085:	6a 5c                	push   $0x5c
  jmp alltraps
80106087:	e9 de f7 ff ff       	jmp    8010586a <alltraps>

8010608c <vector93>:
.globl vector93
vector93:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $93
8010608e:	6a 5d                	push   $0x5d
  jmp alltraps
80106090:	e9 d5 f7 ff ff       	jmp    8010586a <alltraps>

80106095 <vector94>:
.globl vector94
vector94:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $94
80106097:	6a 5e                	push   $0x5e
  jmp alltraps
80106099:	e9 cc f7 ff ff       	jmp    8010586a <alltraps>

8010609e <vector95>:
.globl vector95
vector95:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $95
801060a0:	6a 5f                	push   $0x5f
  jmp alltraps
801060a2:	e9 c3 f7 ff ff       	jmp    8010586a <alltraps>

801060a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $96
801060a9:	6a 60                	push   $0x60
  jmp alltraps
801060ab:	e9 ba f7 ff ff       	jmp    8010586a <alltraps>

801060b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $97
801060b2:	6a 61                	push   $0x61
  jmp alltraps
801060b4:	e9 b1 f7 ff ff       	jmp    8010586a <alltraps>

801060b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $98
801060bb:	6a 62                	push   $0x62
  jmp alltraps
801060bd:	e9 a8 f7 ff ff       	jmp    8010586a <alltraps>

801060c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $99
801060c4:	6a 63                	push   $0x63
  jmp alltraps
801060c6:	e9 9f f7 ff ff       	jmp    8010586a <alltraps>

801060cb <vector100>:
.globl vector100
vector100:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $100
801060cd:	6a 64                	push   $0x64
  jmp alltraps
801060cf:	e9 96 f7 ff ff       	jmp    8010586a <alltraps>

801060d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $101
801060d6:	6a 65                	push   $0x65
  jmp alltraps
801060d8:	e9 8d f7 ff ff       	jmp    8010586a <alltraps>

801060dd <vector102>:
.globl vector102
vector102:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $102
801060df:	6a 66                	push   $0x66
  jmp alltraps
801060e1:	e9 84 f7 ff ff       	jmp    8010586a <alltraps>

801060e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $103
801060e8:	6a 67                	push   $0x67
  jmp alltraps
801060ea:	e9 7b f7 ff ff       	jmp    8010586a <alltraps>

801060ef <vector104>:
.globl vector104
vector104:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $104
801060f1:	6a 68                	push   $0x68
  jmp alltraps
801060f3:	e9 72 f7 ff ff       	jmp    8010586a <alltraps>

801060f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $105
801060fa:	6a 69                	push   $0x69
  jmp alltraps
801060fc:	e9 69 f7 ff ff       	jmp    8010586a <alltraps>

80106101 <vector106>:
.globl vector106
vector106:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $106
80106103:	6a 6a                	push   $0x6a
  jmp alltraps
80106105:	e9 60 f7 ff ff       	jmp    8010586a <alltraps>

8010610a <vector107>:
.globl vector107
vector107:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $107
8010610c:	6a 6b                	push   $0x6b
  jmp alltraps
8010610e:	e9 57 f7 ff ff       	jmp    8010586a <alltraps>

80106113 <vector108>:
.globl vector108
vector108:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $108
80106115:	6a 6c                	push   $0x6c
  jmp alltraps
80106117:	e9 4e f7 ff ff       	jmp    8010586a <alltraps>

8010611c <vector109>:
.globl vector109
vector109:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $109
8010611e:	6a 6d                	push   $0x6d
  jmp alltraps
80106120:	e9 45 f7 ff ff       	jmp    8010586a <alltraps>

80106125 <vector110>:
.globl vector110
vector110:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $110
80106127:	6a 6e                	push   $0x6e
  jmp alltraps
80106129:	e9 3c f7 ff ff       	jmp    8010586a <alltraps>

8010612e <vector111>:
.globl vector111
vector111:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $111
80106130:	6a 6f                	push   $0x6f
  jmp alltraps
80106132:	e9 33 f7 ff ff       	jmp    8010586a <alltraps>

80106137 <vector112>:
.globl vector112
vector112:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $112
80106139:	6a 70                	push   $0x70
  jmp alltraps
8010613b:	e9 2a f7 ff ff       	jmp    8010586a <alltraps>

80106140 <vector113>:
.globl vector113
vector113:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $113
80106142:	6a 71                	push   $0x71
  jmp alltraps
80106144:	e9 21 f7 ff ff       	jmp    8010586a <alltraps>

80106149 <vector114>:
.globl vector114
vector114:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $114
8010614b:	6a 72                	push   $0x72
  jmp alltraps
8010614d:	e9 18 f7 ff ff       	jmp    8010586a <alltraps>

80106152 <vector115>:
.globl vector115
vector115:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $115
80106154:	6a 73                	push   $0x73
  jmp alltraps
80106156:	e9 0f f7 ff ff       	jmp    8010586a <alltraps>

8010615b <vector116>:
.globl vector116
vector116:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $116
8010615d:	6a 74                	push   $0x74
  jmp alltraps
8010615f:	e9 06 f7 ff ff       	jmp    8010586a <alltraps>

80106164 <vector117>:
.globl vector117
vector117:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $117
80106166:	6a 75                	push   $0x75
  jmp alltraps
80106168:	e9 fd f6 ff ff       	jmp    8010586a <alltraps>

8010616d <vector118>:
.globl vector118
vector118:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $118
8010616f:	6a 76                	push   $0x76
  jmp alltraps
80106171:	e9 f4 f6 ff ff       	jmp    8010586a <alltraps>

80106176 <vector119>:
.globl vector119
vector119:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $119
80106178:	6a 77                	push   $0x77
  jmp alltraps
8010617a:	e9 eb f6 ff ff       	jmp    8010586a <alltraps>

8010617f <vector120>:
.globl vector120
vector120:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $120
80106181:	6a 78                	push   $0x78
  jmp alltraps
80106183:	e9 e2 f6 ff ff       	jmp    8010586a <alltraps>

80106188 <vector121>:
.globl vector121
vector121:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $121
8010618a:	6a 79                	push   $0x79
  jmp alltraps
8010618c:	e9 d9 f6 ff ff       	jmp    8010586a <alltraps>

80106191 <vector122>:
.globl vector122
vector122:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $122
80106193:	6a 7a                	push   $0x7a
  jmp alltraps
80106195:	e9 d0 f6 ff ff       	jmp    8010586a <alltraps>

8010619a <vector123>:
.globl vector123
vector123:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $123
8010619c:	6a 7b                	push   $0x7b
  jmp alltraps
8010619e:	e9 c7 f6 ff ff       	jmp    8010586a <alltraps>

801061a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $124
801061a5:	6a 7c                	push   $0x7c
  jmp alltraps
801061a7:	e9 be f6 ff ff       	jmp    8010586a <alltraps>

801061ac <vector125>:
.globl vector125
vector125:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $125
801061ae:	6a 7d                	push   $0x7d
  jmp alltraps
801061b0:	e9 b5 f6 ff ff       	jmp    8010586a <alltraps>

801061b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $126
801061b7:	6a 7e                	push   $0x7e
  jmp alltraps
801061b9:	e9 ac f6 ff ff       	jmp    8010586a <alltraps>

801061be <vector127>:
.globl vector127
vector127:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $127
801061c0:	6a 7f                	push   $0x7f
  jmp alltraps
801061c2:	e9 a3 f6 ff ff       	jmp    8010586a <alltraps>

801061c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $128
801061c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061ce:	e9 97 f6 ff ff       	jmp    8010586a <alltraps>

801061d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $129
801061d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801061da:	e9 8b f6 ff ff       	jmp    8010586a <alltraps>

801061df <vector130>:
.globl vector130
vector130:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $130
801061e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801061e6:	e9 7f f6 ff ff       	jmp    8010586a <alltraps>

801061eb <vector131>:
.globl vector131
vector131:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $131
801061ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801061f2:	e9 73 f6 ff ff       	jmp    8010586a <alltraps>

801061f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $132
801061f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801061fe:	e9 67 f6 ff ff       	jmp    8010586a <alltraps>

80106203 <vector133>:
.globl vector133
vector133:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $133
80106205:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010620a:	e9 5b f6 ff ff       	jmp    8010586a <alltraps>

8010620f <vector134>:
.globl vector134
vector134:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $134
80106211:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106216:	e9 4f f6 ff ff       	jmp    8010586a <alltraps>

8010621b <vector135>:
.globl vector135
vector135:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $135
8010621d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106222:	e9 43 f6 ff ff       	jmp    8010586a <alltraps>

80106227 <vector136>:
.globl vector136
vector136:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $136
80106229:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010622e:	e9 37 f6 ff ff       	jmp    8010586a <alltraps>

80106233 <vector137>:
.globl vector137
vector137:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $137
80106235:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010623a:	e9 2b f6 ff ff       	jmp    8010586a <alltraps>

8010623f <vector138>:
.globl vector138
vector138:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $138
80106241:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106246:	e9 1f f6 ff ff       	jmp    8010586a <alltraps>

8010624b <vector139>:
.globl vector139
vector139:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $139
8010624d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106252:	e9 13 f6 ff ff       	jmp    8010586a <alltraps>

80106257 <vector140>:
.globl vector140
vector140:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $140
80106259:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010625e:	e9 07 f6 ff ff       	jmp    8010586a <alltraps>

80106263 <vector141>:
.globl vector141
vector141:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $141
80106265:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010626a:	e9 fb f5 ff ff       	jmp    8010586a <alltraps>

8010626f <vector142>:
.globl vector142
vector142:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $142
80106271:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106276:	e9 ef f5 ff ff       	jmp    8010586a <alltraps>

8010627b <vector143>:
.globl vector143
vector143:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $143
8010627d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106282:	e9 e3 f5 ff ff       	jmp    8010586a <alltraps>

80106287 <vector144>:
.globl vector144
vector144:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $144
80106289:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010628e:	e9 d7 f5 ff ff       	jmp    8010586a <alltraps>

80106293 <vector145>:
.globl vector145
vector145:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $145
80106295:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010629a:	e9 cb f5 ff ff       	jmp    8010586a <alltraps>

8010629f <vector146>:
.globl vector146
vector146:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $146
801062a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062a6:	e9 bf f5 ff ff       	jmp    8010586a <alltraps>

801062ab <vector147>:
.globl vector147
vector147:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $147
801062ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062b2:	e9 b3 f5 ff ff       	jmp    8010586a <alltraps>

801062b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $148
801062b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062be:	e9 a7 f5 ff ff       	jmp    8010586a <alltraps>

801062c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $149
801062c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062ca:	e9 9b f5 ff ff       	jmp    8010586a <alltraps>

801062cf <vector150>:
.globl vector150
vector150:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $150
801062d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801062d6:	e9 8f f5 ff ff       	jmp    8010586a <alltraps>

801062db <vector151>:
.globl vector151
vector151:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $151
801062dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801062e2:	e9 83 f5 ff ff       	jmp    8010586a <alltraps>

801062e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $152
801062e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801062ee:	e9 77 f5 ff ff       	jmp    8010586a <alltraps>

801062f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $153
801062f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801062fa:	e9 6b f5 ff ff       	jmp    8010586a <alltraps>

801062ff <vector154>:
.globl vector154
vector154:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $154
80106301:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106306:	e9 5f f5 ff ff       	jmp    8010586a <alltraps>

8010630b <vector155>:
.globl vector155
vector155:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $155
8010630d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106312:	e9 53 f5 ff ff       	jmp    8010586a <alltraps>

80106317 <vector156>:
.globl vector156
vector156:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $156
80106319:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010631e:	e9 47 f5 ff ff       	jmp    8010586a <alltraps>

80106323 <vector157>:
.globl vector157
vector157:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $157
80106325:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010632a:	e9 3b f5 ff ff       	jmp    8010586a <alltraps>

8010632f <vector158>:
.globl vector158
vector158:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $158
80106331:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106336:	e9 2f f5 ff ff       	jmp    8010586a <alltraps>

8010633b <vector159>:
.globl vector159
vector159:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $159
8010633d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106342:	e9 23 f5 ff ff       	jmp    8010586a <alltraps>

80106347 <vector160>:
.globl vector160
vector160:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $160
80106349:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010634e:	e9 17 f5 ff ff       	jmp    8010586a <alltraps>

80106353 <vector161>:
.globl vector161
vector161:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $161
80106355:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010635a:	e9 0b f5 ff ff       	jmp    8010586a <alltraps>

8010635f <vector162>:
.globl vector162
vector162:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $162
80106361:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106366:	e9 ff f4 ff ff       	jmp    8010586a <alltraps>

8010636b <vector163>:
.globl vector163
vector163:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $163
8010636d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106372:	e9 f3 f4 ff ff       	jmp    8010586a <alltraps>

80106377 <vector164>:
.globl vector164
vector164:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $164
80106379:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010637e:	e9 e7 f4 ff ff       	jmp    8010586a <alltraps>

80106383 <vector165>:
.globl vector165
vector165:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $165
80106385:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010638a:	e9 db f4 ff ff       	jmp    8010586a <alltraps>

8010638f <vector166>:
.globl vector166
vector166:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $166
80106391:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106396:	e9 cf f4 ff ff       	jmp    8010586a <alltraps>

8010639b <vector167>:
.globl vector167
vector167:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $167
8010639d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063a2:	e9 c3 f4 ff ff       	jmp    8010586a <alltraps>

801063a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $168
801063a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063ae:	e9 b7 f4 ff ff       	jmp    8010586a <alltraps>

801063b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $169
801063b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063ba:	e9 ab f4 ff ff       	jmp    8010586a <alltraps>

801063bf <vector170>:
.globl vector170
vector170:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $170
801063c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063c6:	e9 9f f4 ff ff       	jmp    8010586a <alltraps>

801063cb <vector171>:
.globl vector171
vector171:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $171
801063cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801063d2:	e9 93 f4 ff ff       	jmp    8010586a <alltraps>

801063d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $172
801063d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801063de:	e9 87 f4 ff ff       	jmp    8010586a <alltraps>

801063e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $173
801063e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801063ea:	e9 7b f4 ff ff       	jmp    8010586a <alltraps>

801063ef <vector174>:
.globl vector174
vector174:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $174
801063f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801063f6:	e9 6f f4 ff ff       	jmp    8010586a <alltraps>

801063fb <vector175>:
.globl vector175
vector175:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $175
801063fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106402:	e9 63 f4 ff ff       	jmp    8010586a <alltraps>

80106407 <vector176>:
.globl vector176
vector176:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $176
80106409:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010640e:	e9 57 f4 ff ff       	jmp    8010586a <alltraps>

80106413 <vector177>:
.globl vector177
vector177:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $177
80106415:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010641a:	e9 4b f4 ff ff       	jmp    8010586a <alltraps>

8010641f <vector178>:
.globl vector178
vector178:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $178
80106421:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106426:	e9 3f f4 ff ff       	jmp    8010586a <alltraps>

8010642b <vector179>:
.globl vector179
vector179:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $179
8010642d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106432:	e9 33 f4 ff ff       	jmp    8010586a <alltraps>

80106437 <vector180>:
.globl vector180
vector180:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $180
80106439:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010643e:	e9 27 f4 ff ff       	jmp    8010586a <alltraps>

80106443 <vector181>:
.globl vector181
vector181:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $181
80106445:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010644a:	e9 1b f4 ff ff       	jmp    8010586a <alltraps>

8010644f <vector182>:
.globl vector182
vector182:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $182
80106451:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106456:	e9 0f f4 ff ff       	jmp    8010586a <alltraps>

8010645b <vector183>:
.globl vector183
vector183:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $183
8010645d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106462:	e9 03 f4 ff ff       	jmp    8010586a <alltraps>

80106467 <vector184>:
.globl vector184
vector184:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $184
80106469:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010646e:	e9 f7 f3 ff ff       	jmp    8010586a <alltraps>

80106473 <vector185>:
.globl vector185
vector185:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $185
80106475:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010647a:	e9 eb f3 ff ff       	jmp    8010586a <alltraps>

8010647f <vector186>:
.globl vector186
vector186:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $186
80106481:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106486:	e9 df f3 ff ff       	jmp    8010586a <alltraps>

8010648b <vector187>:
.globl vector187
vector187:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $187
8010648d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106492:	e9 d3 f3 ff ff       	jmp    8010586a <alltraps>

80106497 <vector188>:
.globl vector188
vector188:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $188
80106499:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010649e:	e9 c7 f3 ff ff       	jmp    8010586a <alltraps>

801064a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $189
801064a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064aa:	e9 bb f3 ff ff       	jmp    8010586a <alltraps>

801064af <vector190>:
.globl vector190
vector190:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $190
801064b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064b6:	e9 af f3 ff ff       	jmp    8010586a <alltraps>

801064bb <vector191>:
.globl vector191
vector191:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $191
801064bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064c2:	e9 a3 f3 ff ff       	jmp    8010586a <alltraps>

801064c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $192
801064c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064ce:	e9 97 f3 ff ff       	jmp    8010586a <alltraps>

801064d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $193
801064d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801064da:	e9 8b f3 ff ff       	jmp    8010586a <alltraps>

801064df <vector194>:
.globl vector194
vector194:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $194
801064e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801064e6:	e9 7f f3 ff ff       	jmp    8010586a <alltraps>

801064eb <vector195>:
.globl vector195
vector195:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $195
801064ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801064f2:	e9 73 f3 ff ff       	jmp    8010586a <alltraps>

801064f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $196
801064f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801064fe:	e9 67 f3 ff ff       	jmp    8010586a <alltraps>

80106503 <vector197>:
.globl vector197
vector197:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $197
80106505:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010650a:	e9 5b f3 ff ff       	jmp    8010586a <alltraps>

8010650f <vector198>:
.globl vector198
vector198:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $198
80106511:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106516:	e9 4f f3 ff ff       	jmp    8010586a <alltraps>

8010651b <vector199>:
.globl vector199
vector199:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $199
8010651d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106522:	e9 43 f3 ff ff       	jmp    8010586a <alltraps>

80106527 <vector200>:
.globl vector200
vector200:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $200
80106529:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010652e:	e9 37 f3 ff ff       	jmp    8010586a <alltraps>

80106533 <vector201>:
.globl vector201
vector201:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $201
80106535:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010653a:	e9 2b f3 ff ff       	jmp    8010586a <alltraps>

8010653f <vector202>:
.globl vector202
vector202:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $202
80106541:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106546:	e9 1f f3 ff ff       	jmp    8010586a <alltraps>

8010654b <vector203>:
.globl vector203
vector203:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $203
8010654d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106552:	e9 13 f3 ff ff       	jmp    8010586a <alltraps>

80106557 <vector204>:
.globl vector204
vector204:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $204
80106559:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010655e:	e9 07 f3 ff ff       	jmp    8010586a <alltraps>

80106563 <vector205>:
.globl vector205
vector205:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $205
80106565:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010656a:	e9 fb f2 ff ff       	jmp    8010586a <alltraps>

8010656f <vector206>:
.globl vector206
vector206:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $206
80106571:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106576:	e9 ef f2 ff ff       	jmp    8010586a <alltraps>

8010657b <vector207>:
.globl vector207
vector207:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $207
8010657d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106582:	e9 e3 f2 ff ff       	jmp    8010586a <alltraps>

80106587 <vector208>:
.globl vector208
vector208:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $208
80106589:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010658e:	e9 d7 f2 ff ff       	jmp    8010586a <alltraps>

80106593 <vector209>:
.globl vector209
vector209:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $209
80106595:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010659a:	e9 cb f2 ff ff       	jmp    8010586a <alltraps>

8010659f <vector210>:
.globl vector210
vector210:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $210
801065a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065a6:	e9 bf f2 ff ff       	jmp    8010586a <alltraps>

801065ab <vector211>:
.globl vector211
vector211:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $211
801065ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065b2:	e9 b3 f2 ff ff       	jmp    8010586a <alltraps>

801065b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $212
801065b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065be:	e9 a7 f2 ff ff       	jmp    8010586a <alltraps>

801065c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $213
801065c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065ca:	e9 9b f2 ff ff       	jmp    8010586a <alltraps>

801065cf <vector214>:
.globl vector214
vector214:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $214
801065d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801065d6:	e9 8f f2 ff ff       	jmp    8010586a <alltraps>

801065db <vector215>:
.globl vector215
vector215:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $215
801065dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801065e2:	e9 83 f2 ff ff       	jmp    8010586a <alltraps>

801065e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $216
801065e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801065ee:	e9 77 f2 ff ff       	jmp    8010586a <alltraps>

801065f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $217
801065f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801065fa:	e9 6b f2 ff ff       	jmp    8010586a <alltraps>

801065ff <vector218>:
.globl vector218
vector218:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $218
80106601:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106606:	e9 5f f2 ff ff       	jmp    8010586a <alltraps>

8010660b <vector219>:
.globl vector219
vector219:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $219
8010660d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106612:	e9 53 f2 ff ff       	jmp    8010586a <alltraps>

80106617 <vector220>:
.globl vector220
vector220:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $220
80106619:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010661e:	e9 47 f2 ff ff       	jmp    8010586a <alltraps>

80106623 <vector221>:
.globl vector221
vector221:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $221
80106625:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010662a:	e9 3b f2 ff ff       	jmp    8010586a <alltraps>

8010662f <vector222>:
.globl vector222
vector222:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $222
80106631:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106636:	e9 2f f2 ff ff       	jmp    8010586a <alltraps>

8010663b <vector223>:
.globl vector223
vector223:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $223
8010663d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106642:	e9 23 f2 ff ff       	jmp    8010586a <alltraps>

80106647 <vector224>:
.globl vector224
vector224:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $224
80106649:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010664e:	e9 17 f2 ff ff       	jmp    8010586a <alltraps>

80106653 <vector225>:
.globl vector225
vector225:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $225
80106655:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010665a:	e9 0b f2 ff ff       	jmp    8010586a <alltraps>

8010665f <vector226>:
.globl vector226
vector226:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $226
80106661:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106666:	e9 ff f1 ff ff       	jmp    8010586a <alltraps>

8010666b <vector227>:
.globl vector227
vector227:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $227
8010666d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106672:	e9 f3 f1 ff ff       	jmp    8010586a <alltraps>

80106677 <vector228>:
.globl vector228
vector228:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $228
80106679:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010667e:	e9 e7 f1 ff ff       	jmp    8010586a <alltraps>

80106683 <vector229>:
.globl vector229
vector229:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $229
80106685:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010668a:	e9 db f1 ff ff       	jmp    8010586a <alltraps>

8010668f <vector230>:
.globl vector230
vector230:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $230
80106691:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106696:	e9 cf f1 ff ff       	jmp    8010586a <alltraps>

8010669b <vector231>:
.globl vector231
vector231:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $231
8010669d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066a2:	e9 c3 f1 ff ff       	jmp    8010586a <alltraps>

801066a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $232
801066a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066ae:	e9 b7 f1 ff ff       	jmp    8010586a <alltraps>

801066b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $233
801066b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066ba:	e9 ab f1 ff ff       	jmp    8010586a <alltraps>

801066bf <vector234>:
.globl vector234
vector234:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $234
801066c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066c6:	e9 9f f1 ff ff       	jmp    8010586a <alltraps>

801066cb <vector235>:
.globl vector235
vector235:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $235
801066cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801066d2:	e9 93 f1 ff ff       	jmp    8010586a <alltraps>

801066d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $236
801066d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801066de:	e9 87 f1 ff ff       	jmp    8010586a <alltraps>

801066e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $237
801066e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801066ea:	e9 7b f1 ff ff       	jmp    8010586a <alltraps>

801066ef <vector238>:
.globl vector238
vector238:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $238
801066f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801066f6:	e9 6f f1 ff ff       	jmp    8010586a <alltraps>

801066fb <vector239>:
.globl vector239
vector239:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $239
801066fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106702:	e9 63 f1 ff ff       	jmp    8010586a <alltraps>

80106707 <vector240>:
.globl vector240
vector240:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $240
80106709:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010670e:	e9 57 f1 ff ff       	jmp    8010586a <alltraps>

80106713 <vector241>:
.globl vector241
vector241:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $241
80106715:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010671a:	e9 4b f1 ff ff       	jmp    8010586a <alltraps>

8010671f <vector242>:
.globl vector242
vector242:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $242
80106721:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106726:	e9 3f f1 ff ff       	jmp    8010586a <alltraps>

8010672b <vector243>:
.globl vector243
vector243:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $243
8010672d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106732:	e9 33 f1 ff ff       	jmp    8010586a <alltraps>

80106737 <vector244>:
.globl vector244
vector244:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $244
80106739:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010673e:	e9 27 f1 ff ff       	jmp    8010586a <alltraps>

80106743 <vector245>:
.globl vector245
vector245:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $245
80106745:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010674a:	e9 1b f1 ff ff       	jmp    8010586a <alltraps>

8010674f <vector246>:
.globl vector246
vector246:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $246
80106751:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106756:	e9 0f f1 ff ff       	jmp    8010586a <alltraps>

8010675b <vector247>:
.globl vector247
vector247:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $247
8010675d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106762:	e9 03 f1 ff ff       	jmp    8010586a <alltraps>

80106767 <vector248>:
.globl vector248
vector248:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $248
80106769:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010676e:	e9 f7 f0 ff ff       	jmp    8010586a <alltraps>

80106773 <vector249>:
.globl vector249
vector249:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $249
80106775:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010677a:	e9 eb f0 ff ff       	jmp    8010586a <alltraps>

8010677f <vector250>:
.globl vector250
vector250:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $250
80106781:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106786:	e9 df f0 ff ff       	jmp    8010586a <alltraps>

8010678b <vector251>:
.globl vector251
vector251:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $251
8010678d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106792:	e9 d3 f0 ff ff       	jmp    8010586a <alltraps>

80106797 <vector252>:
.globl vector252
vector252:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $252
80106799:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010679e:	e9 c7 f0 ff ff       	jmp    8010586a <alltraps>

801067a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $253
801067a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067aa:	e9 bb f0 ff ff       	jmp    8010586a <alltraps>

801067af <vector254>:
.globl vector254
vector254:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $254
801067b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067b6:	e9 af f0 ff ff       	jmp    8010586a <alltraps>

801067bb <vector255>:
.globl vector255
vector255:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $255
801067bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067c2:	e9 a3 f0 ff ff       	jmp    8010586a <alltraps>
801067c7:	66 90                	xchg   %ax,%ax
801067c9:	66 90                	xchg   %ax,%ax
801067cb:	66 90                	xchg   %ax,%ax
801067cd:	66 90                	xchg   %ax,%ax
801067cf:	90                   	nop

801067d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	56                   	push   %esi
801067d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067e2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801067e5:	39 d3                	cmp    %edx,%ebx
801067e7:	73 56                	jae    8010683f <deallocuvm.part.0+0x6f>
801067e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801067ec:	89 c6                	mov    %eax,%esi
801067ee:	89 d7                	mov    %edx,%edi
801067f0:	eb 12                	jmp    80106804 <deallocuvm.part.0+0x34>
801067f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067f8:	83 c2 01             	add    $0x1,%edx
801067fb:	89 d3                	mov    %edx,%ebx
801067fd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106800:	39 fb                	cmp    %edi,%ebx
80106802:	73 38                	jae    8010683c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106804:	89 da                	mov    %ebx,%edx
80106806:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106809:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010680c:	a8 01                	test   $0x1,%al
8010680e:	74 e8                	je     801067f8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106810:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106812:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106817:	c1 e9 0a             	shr    $0xa,%ecx
8010681a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106820:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106827:	85 c0                	test   %eax,%eax
80106829:	74 cd                	je     801067f8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010682b:	8b 10                	mov    (%eax),%edx
8010682d:	f6 c2 01             	test   $0x1,%dl
80106830:	75 1e                	jne    80106850 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106832:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106838:	39 fb                	cmp    %edi,%ebx
8010683a:	72 c8                	jb     80106804 <deallocuvm.part.0+0x34>
8010683c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010683f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106842:	89 c8                	mov    %ecx,%eax
80106844:	5b                   	pop    %ebx
80106845:	5e                   	pop    %esi
80106846:	5f                   	pop    %edi
80106847:	5d                   	pop    %ebp
80106848:	c3                   	ret
80106849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106850:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106856:	74 26                	je     8010687e <deallocuvm.part.0+0xae>
      kfree(v);
80106858:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010685b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106861:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106864:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010686a:	52                   	push   %edx
8010686b:	e8 60 bc ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106873:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010687c:	eb 82                	jmp    80106800 <deallocuvm.part.0+0x30>
        panic("kfree");
8010687e:	83 ec 0c             	sub    $0xc,%esp
80106881:	68 6c 73 10 80       	push   $0x8010736c
80106886:	e8 f5 9a ff ff       	call   80100380 <panic>
8010688b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106890 <mappages>:
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106896:	89 d3                	mov    %edx,%ebx
80106898:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010689e:	83 ec 1c             	sub    $0x1c,%esp
801068a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068b0:	8b 45 08             	mov    0x8(%ebp),%eax
801068b3:	29 d8                	sub    %ebx,%eax
801068b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068b8:	eb 3f                	jmp    801068f9 <mappages+0x69>
801068ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801068c0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801068c7:	c1 ea 0a             	shr    $0xa,%edx
801068ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068d7:	85 c0                	test   %eax,%eax
801068d9:	74 75                	je     80106950 <mappages+0xc0>
    if(*pte & PTE_P)
801068db:	f6 00 01             	testb  $0x1,(%eax)
801068de:	0f 85 86 00 00 00    	jne    8010696a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801068e4:	0b 75 0c             	or     0xc(%ebp),%esi
801068e7:	83 ce 01             	or     $0x1,%esi
801068ea:	89 30                	mov    %esi,(%eax)
    if(a == last)
801068ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068ef:	39 c3                	cmp    %eax,%ebx
801068f1:	74 6d                	je     80106960 <mappages+0xd0>
    a += PGSIZE;
801068f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801068f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801068fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801068ff:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106902:	89 d8                	mov    %ebx,%eax
80106904:	c1 e8 16             	shr    $0x16,%eax
80106907:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010690a:	8b 07                	mov    (%edi),%eax
8010690c:	a8 01                	test   $0x1,%al
8010690e:	75 b0                	jne    801068c0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106910:	e8 7b bd ff ff       	call   80102690 <kalloc>
80106915:	85 c0                	test   %eax,%eax
80106917:	74 37                	je     80106950 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106919:	83 ec 04             	sub    $0x4,%esp
8010691c:	68 00 10 00 00       	push   $0x1000
80106921:	6a 00                	push   $0x0
80106923:	50                   	push   %eax
80106924:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106927:	e8 a4 dd ff ff       	call   801046d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010692c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010692f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106932:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106938:	83 c8 07             	or     $0x7,%eax
8010693b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010693d:	89 d8                	mov    %ebx,%eax
8010693f:	c1 e8 0a             	shr    $0xa,%eax
80106942:	25 fc 0f 00 00       	and    $0xffc,%eax
80106947:	01 d0                	add    %edx,%eax
80106949:	eb 90                	jmp    801068db <mappages+0x4b>
8010694b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106950:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106958:	5b                   	pop    %ebx
80106959:	5e                   	pop    %esi
8010695a:	5f                   	pop    %edi
8010695b:	5d                   	pop    %ebp
8010695c:	c3                   	ret
8010695d:	8d 76 00             	lea    0x0(%esi),%esi
80106960:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106963:	31 c0                	xor    %eax,%eax
}
80106965:	5b                   	pop    %ebx
80106966:	5e                   	pop    %esi
80106967:	5f                   	pop    %edi
80106968:	5d                   	pop    %ebp
80106969:	c3                   	ret
      panic("remap");
8010696a:	83 ec 0c             	sub    $0xc,%esp
8010696d:	68 a0 75 10 80       	push   $0x801075a0
80106972:	e8 09 9a ff ff       	call   80100380 <panic>
80106977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010697e:	00 
8010697f:	90                   	nop

80106980 <seginit>:
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106986:	e8 e5 cf ff ff       	call   80103970 <cpuid>
  pd[0] = size-1;
8010698b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106990:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106996:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010699a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801069a1:	ff 00 00 
801069a4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
801069ab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069ae:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
801069b5:	ff 00 00 
801069b8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
801069bf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069c2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
801069c9:	ff 00 00 
801069cc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
801069d3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069d6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
801069dd:	ff 00 00 
801069e0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
801069e7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801069ea:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
801069ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069f3:	c1 e8 10             	shr    $0x10,%eax
801069f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801069fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801069fd:	0f 01 10             	lgdtl  (%eax)
}
80106a00:	c9                   	leave
80106a01:	c3                   	ret
80106a02:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a09:	00 
80106a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a10:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106a15:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a1a:	0f 22 d8             	mov    %eax,%cr3
}
80106a1d:	c3                   	ret
80106a1e:	66 90                	xchg   %ax,%ax

80106a20 <switchuvm>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 1c             	sub    $0x1c,%esp
80106a29:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a2c:	85 f6                	test   %esi,%esi
80106a2e:	0f 84 cb 00 00 00    	je     80106aff <switchuvm+0xdf>
  if(p->kstack == 0)
80106a34:	8b 46 08             	mov    0x8(%esi),%eax
80106a37:	85 c0                	test   %eax,%eax
80106a39:	0f 84 da 00 00 00    	je     80106b19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a3f:	8b 46 04             	mov    0x4(%esi),%eax
80106a42:	85 c0                	test   %eax,%eax
80106a44:	0f 84 c2 00 00 00    	je     80106b0c <switchuvm+0xec>
  pushcli();
80106a4a:	e8 31 da ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a4f:	e8 bc ce ff ff       	call   80103910 <mycpu>
80106a54:	89 c3                	mov    %eax,%ebx
80106a56:	e8 b5 ce ff ff       	call   80103910 <mycpu>
80106a5b:	89 c7                	mov    %eax,%edi
80106a5d:	e8 ae ce ff ff       	call   80103910 <mycpu>
80106a62:	83 c7 08             	add    $0x8,%edi
80106a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a68:	e8 a3 ce ff ff       	call   80103910 <mycpu>
80106a6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a70:	ba 67 00 00 00       	mov    $0x67,%edx
80106a75:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a7c:	83 c0 08             	add    $0x8,%eax
80106a7f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a86:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a8b:	83 c1 08             	add    $0x8,%ecx
80106a8e:	c1 e8 18             	shr    $0x18,%eax
80106a91:	c1 e9 10             	shr    $0x10,%ecx
80106a94:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106a9a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106aa0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106aa5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106aac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ab1:	e8 5a ce ff ff       	call   80103910 <mycpu>
80106ab6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106abd:	e8 4e ce ff ff       	call   80103910 <mycpu>
80106ac2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ac6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106ac9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106acf:	e8 3c ce ff ff       	call   80103910 <mycpu>
80106ad4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ad7:	e8 34 ce ff ff       	call   80103910 <mycpu>
80106adc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ae0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ae5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ae8:	8b 46 04             	mov    0x4(%esi),%eax
80106aeb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106af0:	0f 22 d8             	mov    %eax,%cr3
}
80106af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106af6:	5b                   	pop    %ebx
80106af7:	5e                   	pop    %esi
80106af8:	5f                   	pop    %edi
80106af9:	5d                   	pop    %ebp
  popcli();
80106afa:	e9 d1 d9 ff ff       	jmp    801044d0 <popcli>
    panic("switchuvm: no process");
80106aff:	83 ec 0c             	sub    $0xc,%esp
80106b02:	68 a6 75 10 80       	push   $0x801075a6
80106b07:	e8 74 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106b0c:	83 ec 0c             	sub    $0xc,%esp
80106b0f:	68 d1 75 10 80       	push   $0x801075d1
80106b14:	e8 67 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106b19:	83 ec 0c             	sub    $0xc,%esp
80106b1c:	68 bc 75 10 80       	push   $0x801075bc
80106b21:	e8 5a 98 ff ff       	call   80100380 <panic>
80106b26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b2d:	00 
80106b2e:	66 90                	xchg   %ax,%ax

80106b30 <inituvm>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 1c             	sub    $0x1c,%esp
80106b39:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3c:	8b 75 10             	mov    0x10(%ebp),%esi
80106b3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b45:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b4b:	77 49                	ja     80106b96 <inituvm+0x66>
  mem = kalloc();
80106b4d:	e8 3e bb ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80106b52:	83 ec 04             	sub    $0x4,%esp
80106b55:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106b5a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b5c:	6a 00                	push   $0x0
80106b5e:	50                   	push   %eax
80106b5f:	e8 6c db ff ff       	call   801046d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b64:	58                   	pop    %eax
80106b65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b6b:	5a                   	pop    %edx
80106b6c:	6a 06                	push   $0x6
80106b6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b73:	31 d2                	xor    %edx,%edx
80106b75:	50                   	push   %eax
80106b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b79:	e8 12 fd ff ff       	call   80106890 <mappages>
  memmove(mem, init, sz);
80106b7e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b81:	83 c4 10             	add    $0x10,%esp
80106b84:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b87:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b8d:	5b                   	pop    %ebx
80106b8e:	5e                   	pop    %esi
80106b8f:	5f                   	pop    %edi
80106b90:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b91:	e9 ca db ff ff       	jmp    80104760 <memmove>
    panic("inituvm: more than a page");
80106b96:	83 ec 0c             	sub    $0xc,%esp
80106b99:	68 e5 75 10 80       	push   $0x801075e5
80106b9e:	e8 dd 97 ff ff       	call   80100380 <panic>
80106ba3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106baa:	00 
80106bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106bb0 <loaduvm>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
80106bb6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106bb9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106bbc:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106bbf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106bc5:	0f 85 a2 00 00 00    	jne    80106c6d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106bcb:	85 ff                	test   %edi,%edi
80106bcd:	74 7d                	je     80106c4c <loaduvm+0x9c>
80106bcf:	90                   	nop
  pde = &pgdir[PDX(va)];
80106bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106bd3:	8b 55 08             	mov    0x8(%ebp),%edx
80106bd6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106bd8:	89 c1                	mov    %eax,%ecx
80106bda:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106bdd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106be0:	f6 c1 01             	test   $0x1,%cl
80106be3:	75 13                	jne    80106bf8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106be5:	83 ec 0c             	sub    $0xc,%esp
80106be8:	68 ff 75 10 80       	push   $0x801075ff
80106bed:	e8 8e 97 ff ff       	call   80100380 <panic>
80106bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bf8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bfb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c01:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c06:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c0d:	85 c9                	test   %ecx,%ecx
80106c0f:	74 d4                	je     80106be5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106c11:	89 fb                	mov    %edi,%ebx
80106c13:	b8 00 10 00 00       	mov    $0x1000,%eax
80106c18:	29 f3                	sub    %esi,%ebx
80106c1a:	39 c3                	cmp    %eax,%ebx
80106c1c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c1f:	53                   	push   %ebx
80106c20:	8b 45 14             	mov    0x14(%ebp),%eax
80106c23:	01 f0                	add    %esi,%eax
80106c25:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106c26:	8b 01                	mov    (%ecx),%eax
80106c28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c2d:	05 00 00 00 80       	add    $0x80000000,%eax
80106c32:	50                   	push   %eax
80106c33:	ff 75 10             	push   0x10(%ebp)
80106c36:	e8 a5 ae ff ff       	call   80101ae0 <readi>
80106c3b:	83 c4 10             	add    $0x10,%esp
80106c3e:	39 d8                	cmp    %ebx,%eax
80106c40:	75 1e                	jne    80106c60 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106c42:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c48:	39 fe                	cmp    %edi,%esi
80106c4a:	72 84                	jb     80106bd0 <loaduvm+0x20>
}
80106c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c4f:	31 c0                	xor    %eax,%eax
}
80106c51:	5b                   	pop    %ebx
80106c52:	5e                   	pop    %esi
80106c53:	5f                   	pop    %edi
80106c54:	5d                   	pop    %ebp
80106c55:	c3                   	ret
80106c56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c5d:	00 
80106c5e:	66 90                	xchg   %ax,%ax
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
80106c6c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106c6d:	83 ec 0c             	sub    $0xc,%esp
80106c70:	68 20 78 10 80       	push   $0x80107820
80106c75:	e8 06 97 ff ff       	call   80100380 <panic>
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c80 <allocuvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106c8c:	85 f6                	test   %esi,%esi
80106c8e:	0f 88 98 00 00 00    	js     80106d2c <allocuvm+0xac>
80106c94:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106c96:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106c99:	0f 82 a1 00 00 00    	jb     80106d40 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ca2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106ca7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cac:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106cae:	39 f0                	cmp    %esi,%eax
80106cb0:	0f 83 8d 00 00 00    	jae    80106d43 <allocuvm+0xc3>
80106cb6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106cb9:	eb 44                	jmp    80106cff <allocuvm+0x7f>
80106cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106cc0:	83 ec 04             	sub    $0x4,%esp
80106cc3:	68 00 10 00 00       	push   $0x1000
80106cc8:	6a 00                	push   $0x0
80106cca:	50                   	push   %eax
80106ccb:	e8 00 da ff ff       	call   801046d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106cd0:	58                   	pop    %eax
80106cd1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cd7:	5a                   	pop    %edx
80106cd8:	6a 06                	push   $0x6
80106cda:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cdf:	89 fa                	mov    %edi,%edx
80106ce1:	50                   	push   %eax
80106ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce5:	e8 a6 fb ff ff       	call   80106890 <mappages>
80106cea:	83 c4 10             	add    $0x10,%esp
80106ced:	85 c0                	test   %eax,%eax
80106cef:	78 5f                	js     80106d50 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106cf1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106cf7:	39 f7                	cmp    %esi,%edi
80106cf9:	0f 83 89 00 00 00    	jae    80106d88 <allocuvm+0x108>
    mem = kalloc();
80106cff:	e8 8c b9 ff ff       	call   80102690 <kalloc>
80106d04:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d06:	85 c0                	test   %eax,%eax
80106d08:	75 b6                	jne    80106cc0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d0a:	83 ec 0c             	sub    $0xc,%esp
80106d0d:	68 1d 76 10 80       	push   $0x8010761d
80106d12:	e8 c9 99 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
80106d17:	83 c4 10             	add    $0x10,%esp
80106d1a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d1d:	74 0d                	je     80106d2c <allocuvm+0xac>
80106d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d22:	8b 45 08             	mov    0x8(%ebp),%eax
80106d25:	89 f2                	mov    %esi,%edx
80106d27:	e8 a4 fa ff ff       	call   801067d0 <deallocuvm.part.0>
    return 0;
80106d2c:	31 d2                	xor    %edx,%edx
}
80106d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d31:	89 d0                	mov    %edx,%eax
80106d33:	5b                   	pop    %ebx
80106d34:	5e                   	pop    %esi
80106d35:	5f                   	pop    %edi
80106d36:	5d                   	pop    %ebp
80106d37:	c3                   	ret
80106d38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d3f:	00 
    return oldsz;
80106d40:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d46:	89 d0                	mov    %edx,%eax
80106d48:	5b                   	pop    %ebx
80106d49:	5e                   	pop    %esi
80106d4a:	5f                   	pop    %edi
80106d4b:	5d                   	pop    %ebp
80106d4c:	c3                   	ret
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106d50:	83 ec 0c             	sub    $0xc,%esp
80106d53:	68 35 76 10 80       	push   $0x80107635
80106d58:	e8 83 99 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
80106d5d:	83 c4 10             	add    $0x10,%esp
80106d60:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d63:	74 0d                	je     80106d72 <allocuvm+0xf2>
80106d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d68:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6b:	89 f2                	mov    %esi,%edx
80106d6d:	e8 5e fa ff ff       	call   801067d0 <deallocuvm.part.0>
      kfree(mem);
80106d72:	83 ec 0c             	sub    $0xc,%esp
80106d75:	53                   	push   %ebx
80106d76:	e8 55 b7 ff ff       	call   801024d0 <kfree>
      return 0;
80106d7b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106d7e:	31 d2                	xor    %edx,%edx
80106d80:	eb ac                	jmp    80106d2e <allocuvm+0xae>
80106d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d8e:	5b                   	pop    %ebx
80106d8f:	5e                   	pop    %esi
80106d90:	89 d0                	mov    %edx,%eax
80106d92:	5f                   	pop    %edi
80106d93:	5d                   	pop    %ebp
80106d94:	c3                   	ret
80106d95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d9c:	00 
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi

80106da0 <deallocuvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106da6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106da9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106dac:	39 d1                	cmp    %edx,%ecx
80106dae:	73 10                	jae    80106dc0 <deallocuvm+0x20>
}
80106db0:	5d                   	pop    %ebp
80106db1:	e9 1a fa ff ff       	jmp    801067d0 <deallocuvm.part.0>
80106db6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dbd:	00 
80106dbe:	66 90                	xchg   %ax,%ax
80106dc0:	89 d0                	mov    %edx,%eax
80106dc2:	5d                   	pop    %ebp
80106dc3:	c3                   	ret
80106dc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dcb:	00 
80106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 0c             	sub    $0xc,%esp
80106dd9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ddc:	85 f6                	test   %esi,%esi
80106dde:	74 59                	je     80106e39 <freevm+0x69>
  if(newsz >= oldsz)
80106de0:	31 c9                	xor    %ecx,%ecx
80106de2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106de7:	89 f0                	mov    %esi,%eax
80106de9:	89 f3                	mov    %esi,%ebx
80106deb:	e8 e0 f9 ff ff       	call   801067d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106df0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106df6:	eb 0f                	jmp    80106e07 <freevm+0x37>
80106df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dff:	00 
80106e00:	83 c3 04             	add    $0x4,%ebx
80106e03:	39 fb                	cmp    %edi,%ebx
80106e05:	74 23                	je     80106e2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e07:	8b 03                	mov    (%ebx),%eax
80106e09:	a8 01                	test   $0x1,%al
80106e0b:	74 f3                	je     80106e00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e12:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e15:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e18:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e1d:	50                   	push   %eax
80106e1e:	e8 ad b6 ff ff       	call   801024d0 <kfree>
80106e23:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e26:	39 fb                	cmp    %edi,%ebx
80106e28:	75 dd                	jne    80106e07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e30:	5b                   	pop    %ebx
80106e31:	5e                   	pop    %esi
80106e32:	5f                   	pop    %edi
80106e33:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e34:	e9 97 b6 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80106e39:	83 ec 0c             	sub    $0xc,%esp
80106e3c:	68 51 76 10 80       	push   $0x80107651
80106e41:	e8 3a 95 ff ff       	call   80100380 <panic>
80106e46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e4d:	00 
80106e4e:	66 90                	xchg   %ax,%ax

80106e50 <setupkvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	56                   	push   %esi
80106e54:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e55:	e8 36 b8 ff ff       	call   80102690 <kalloc>
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	74 5e                	je     80106ebc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106e5e:	83 ec 04             	sub    $0x4,%esp
80106e61:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e63:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e68:	68 00 10 00 00       	push   $0x1000
80106e6d:	6a 00                	push   $0x0
80106e6f:	50                   	push   %eax
80106e70:	e8 5b d8 ff ff       	call   801046d0 <memset>
80106e75:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106e78:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e7b:	83 ec 08             	sub    $0x8,%esp
80106e7e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e81:	8b 13                	mov    (%ebx),%edx
80106e83:	ff 73 0c             	push   0xc(%ebx)
80106e86:	50                   	push   %eax
80106e87:	29 c1                	sub    %eax,%ecx
80106e89:	89 f0                	mov    %esi,%eax
80106e8b:	e8 00 fa ff ff       	call   80106890 <mappages>
80106e90:	83 c4 10             	add    $0x10,%esp
80106e93:	85 c0                	test   %eax,%eax
80106e95:	78 19                	js     80106eb0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e97:	83 c3 10             	add    $0x10,%ebx
80106e9a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ea0:	75 d6                	jne    80106e78 <setupkvm+0x28>
}
80106ea2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ea5:	89 f0                	mov    %esi,%eax
80106ea7:	5b                   	pop    %ebx
80106ea8:	5e                   	pop    %esi
80106ea9:	5d                   	pop    %ebp
80106eaa:	c3                   	ret
80106eab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106eb0:	83 ec 0c             	sub    $0xc,%esp
80106eb3:	56                   	push   %esi
80106eb4:	e8 17 ff ff ff       	call   80106dd0 <freevm>
      return 0;
80106eb9:	83 c4 10             	add    $0x10,%esp
}
80106ebc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106ebf:	31 f6                	xor    %esi,%esi
}
80106ec1:	89 f0                	mov    %esi,%eax
80106ec3:	5b                   	pop    %ebx
80106ec4:	5e                   	pop    %esi
80106ec5:	5d                   	pop    %ebp
80106ec6:	c3                   	ret
80106ec7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ece:	00 
80106ecf:	90                   	nop

80106ed0 <kvmalloc>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ed6:	e8 75 ff ff ff       	call   80106e50 <setupkvm>
80106edb:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ee0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ee5:	0f 22 d8             	mov    %eax,%cr3
}
80106ee8:	c9                   	leave
80106ee9:	c3                   	ret
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 08             	sub    $0x8,%esp
80106ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106efc:	89 c1                	mov    %eax,%ecx
80106efe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f01:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106f04:	f6 c2 01             	test   $0x1,%dl
80106f07:	75 17                	jne    80106f20 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 62 76 10 80       	push   $0x80107662
80106f11:	e8 6a 94 ff ff       	call   80100380 <panic>
80106f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f1d:	00 
80106f1e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80106f20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f29:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106f35:	85 c0                	test   %eax,%eax
80106f37:	74 d0                	je     80106f09 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106f39:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f3c:	c9                   	leave
80106f3d:	c3                   	ret
80106f3e:	66 90                	xchg   %ax,%ax

80106f40 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f49:	e8 02 ff ff ff       	call   80106e50 <setupkvm>
80106f4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f51:	85 c0                	test   %eax,%eax
80106f53:	0f 84 e9 00 00 00    	je     80107042 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f5c:	85 c9                	test   %ecx,%ecx
80106f5e:	0f 84 b2 00 00 00    	je     80107016 <copyuvm+0xd6>
80106f64:	31 f6                	xor    %esi,%esi
80106f66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f6d:	00 
80106f6e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80106f70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106f73:	89 f0                	mov    %esi,%eax
80106f75:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106f78:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106f7b:	a8 01                	test   $0x1,%al
80106f7d:	75 11                	jne    80106f90 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f7f:	83 ec 0c             	sub    $0xc,%esp
80106f82:	68 6c 76 10 80       	push   $0x8010766c
80106f87:	e8 f4 93 ff ff       	call   80100380 <panic>
80106f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80106f90:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106f97:	c1 ea 0a             	shr    $0xa,%edx
80106f9a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fa0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fa7:	85 c0                	test   %eax,%eax
80106fa9:	74 d4                	je     80106f7f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80106fab:	8b 00                	mov    (%eax),%eax
80106fad:	a8 01                	test   $0x1,%al
80106faf:	0f 84 9f 00 00 00    	je     80107054 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106fb5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106fb7:	25 ff 0f 00 00       	and    $0xfff,%eax
80106fbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106fbf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106fc5:	e8 c6 b6 ff ff       	call   80102690 <kalloc>
80106fca:	89 c3                	mov    %eax,%ebx
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	74 64                	je     80107034 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106fd0:	83 ec 04             	sub    $0x4,%esp
80106fd3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fd9:	68 00 10 00 00       	push   $0x1000
80106fde:	57                   	push   %edi
80106fdf:	50                   	push   %eax
80106fe0:	e8 7b d7 ff ff       	call   80104760 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106fe5:	58                   	pop    %eax
80106fe6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fec:	5a                   	pop    %edx
80106fed:	ff 75 e4             	push   -0x1c(%ebp)
80106ff0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ff5:	89 f2                	mov    %esi,%edx
80106ff7:	50                   	push   %eax
80106ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ffb:	e8 90 f8 ff ff       	call   80106890 <mappages>
80107000:	83 c4 10             	add    $0x10,%esp
80107003:	85 c0                	test   %eax,%eax
80107005:	78 21                	js     80107028 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107007:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010700d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107010:	0f 82 5a ff ff ff    	jb     80106f70 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107016:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107019:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010701c:	5b                   	pop    %ebx
8010701d:	5e                   	pop    %esi
8010701e:	5f                   	pop    %edi
8010701f:	5d                   	pop    %ebp
80107020:	c3                   	ret
80107021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107028:	83 ec 0c             	sub    $0xc,%esp
8010702b:	53                   	push   %ebx
8010702c:	e8 9f b4 ff ff       	call   801024d0 <kfree>
      goto bad;
80107031:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107034:	83 ec 0c             	sub    $0xc,%esp
80107037:	ff 75 e0             	push   -0x20(%ebp)
8010703a:	e8 91 fd ff ff       	call   80106dd0 <freevm>
  return 0;
8010703f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107042:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107049:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010704c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704f:	5b                   	pop    %ebx
80107050:	5e                   	pop    %esi
80107051:	5f                   	pop    %edi
80107052:	5d                   	pop    %ebp
80107053:	c3                   	ret
      panic("copyuvm: page not present");
80107054:	83 ec 0c             	sub    $0xc,%esp
80107057:	68 86 76 10 80       	push   $0x80107686
8010705c:	e8 1f 93 ff ff       	call   80100380 <panic>
80107061:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107068:	00 
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107070 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107076:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107079:	89 c1                	mov    %eax,%ecx
8010707b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010707e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107081:	f6 c2 01             	test   $0x1,%dl
80107084:	0f 84 f8 00 00 00    	je     80107182 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010708a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010708d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107093:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107094:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107099:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801070a0:	89 d0                	mov    %edx,%eax
801070a2:	f7 d2                	not    %edx
801070a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070a9:	05 00 00 00 80       	add    $0x80000000,%eax
801070ae:	83 e2 05             	and    $0x5,%edx
801070b1:	ba 00 00 00 00       	mov    $0x0,%edx
801070b6:	0f 45 c2             	cmovne %edx,%eax
}
801070b9:	c3                   	ret
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	8b 75 14             	mov    0x14(%ebp),%esi
801070cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801070cf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070d2:	85 f6                	test   %esi,%esi
801070d4:	75 51                	jne    80107127 <copyout+0x67>
801070d6:	e9 9d 00 00 00       	jmp    80107178 <copyout+0xb8>
801070db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801070e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801070e6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801070ec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801070f2:	74 74                	je     80107168 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801070f4:	89 fb                	mov    %edi,%ebx
801070f6:	29 c3                	sub    %eax,%ebx
801070f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801070fe:	39 f3                	cmp    %esi,%ebx
80107100:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107103:	29 f8                	sub    %edi,%eax
80107105:	83 ec 04             	sub    $0x4,%esp
80107108:	01 c1                	add    %eax,%ecx
8010710a:	53                   	push   %ebx
8010710b:	52                   	push   %edx
8010710c:	89 55 10             	mov    %edx,0x10(%ebp)
8010710f:	51                   	push   %ecx
80107110:	e8 4b d6 ff ff       	call   80104760 <memmove>
    len -= n;
    buf += n;
80107115:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107118:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010711e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107121:	01 da                	add    %ebx,%edx
  while(len > 0){
80107123:	29 de                	sub    %ebx,%esi
80107125:	74 51                	je     80107178 <copyout+0xb8>
  if(*pde & PTE_P){
80107127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010712a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010712c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010712e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107131:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107137:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010713a:	f6 c1 01             	test   $0x1,%cl
8010713d:	0f 84 46 00 00 00    	je     80107189 <copyout.cold>
  return &pgtab[PTX(va)];
80107143:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107145:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010714b:	c1 eb 0c             	shr    $0xc,%ebx
8010714e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107154:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010715b:	89 d9                	mov    %ebx,%ecx
8010715d:	f7 d1                	not    %ecx
8010715f:	83 e1 05             	and    $0x5,%ecx
80107162:	0f 84 78 ff ff ff    	je     801070e0 <copyout+0x20>
  }
  return 0;
}
80107168:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010716b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107170:	5b                   	pop    %ebx
80107171:	5e                   	pop    %esi
80107172:	5f                   	pop    %edi
80107173:	5d                   	pop    %ebp
80107174:	c3                   	ret
80107175:	8d 76 00             	lea    0x0(%esi),%esi
80107178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010717b:	31 c0                	xor    %eax,%eax
}
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
80107181:	c3                   	ret

80107182 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107182:	a1 00 00 00 00       	mov    0x0,%eax
80107187:	0f 0b                	ud2

80107189 <copyout.cold>:
80107189:	a1 00 00 00 00       	mov    0x0,%eax
8010718e:	0f 0b                	ud2
