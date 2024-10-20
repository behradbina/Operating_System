
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
8010002d:	b8 40 43 10 80       	mov    $0x80104340,%eax
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
8010004c:	68 80 84 10 80       	push   $0x80108480
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 55 56 00 00       	call   801056b0 <initlock>
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
80100092:	68 87 84 10 80       	push   $0x80108487
80100097:	50                   	push   %eax
80100098:	e8 e3 54 00 00       	call   80105580 <initsleeplock>
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
801000e4:	e8 97 57 00 00       	call   80105880 <acquire>
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
80100162:	e8 b9 56 00 00       	call   80105820 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 54 00 00       	call   801055c0 <acquiresleep>
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
8010018c:	e8 2f 34 00 00       	call   801035c0 <iderw>
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
801001a1:	68 8e 84 10 80       	push   $0x8010848e
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
801001be:	e8 9d 54 00 00       	call   80105660 <holdingsleep>
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
801001d4:	e9 e7 33 00 00       	jmp    801035c0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 84 10 80       	push   $0x8010849f
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
801001ff:	e8 5c 54 00 00       	call   80105660 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 54 00 00       	call   80105620 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 60 56 00 00       	call   80105880 <acquire>
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
8010026c:	e9 af 55 00 00       	jmp    80105820 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 84 10 80       	push   $0x801084a6
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
80100294:	e8 a7 28 00 00       	call   80102b40 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 c0 0a 11 80 	movl   $0x80110ac0,(%esp)
801002a0:	e8 db 55 00 00       	call   80105880 <acquire>
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
801002cd:	e8 4e 50 00 00       	call   80105320 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 69 49 00 00       	call   80104c50 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 0a 11 80       	push   $0x80110ac0
801002f6:	e8 25 55 00 00       	call   80105820 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 5c 27 00 00       	call   80102a60 <ilock>
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
8010034c:	e8 cf 54 00 00       	call   80105820 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 06 27 00 00       	call   80102a60 <ilock>
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


void itoa(int num, char *str, int base) {
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	57                   	push   %edi
80100384:	56                   	push   %esi
80100385:	53                   	push   %ebx
80100386:	89 d3                	mov    %edx,%ebx
80100388:	83 ec 0c             	sub    $0xc,%esp
8010038b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return;
    }

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
80100479:	e8 52 37 00 00       	call   80103bd0 <lapicid>
8010047e:	83 ec 08             	sub    $0x8,%esp
80100481:	50                   	push   %eax
80100482:	68 ad 84 10 80       	push   $0x801084ad
80100487:	e8 54 03 00 00       	call   801007e0 <cprintf>
  cprintf(s);
8010048c:	58                   	pop    %eax
8010048d:	ff 75 08             	push   0x8(%ebp)
80100490:	e8 4b 03 00 00       	call   801007e0 <cprintf>
  cprintf("\n");
80100495:	c7 04 24 17 8e 10 80 	movl   $0x80108e17,(%esp)
8010049c:	e8 3f 03 00 00       	call   801007e0 <cprintf>
  getcallerpcs(&s, pcs);
801004a1:	8d 45 08             	lea    0x8(%ebp),%eax
801004a4:	5a                   	pop    %edx
801004a5:	59                   	pop    %ecx
801004a6:	53                   	push   %ebx
801004a7:	50                   	push   %eax
801004a8:	e8 23 52 00 00       	call   801056d0 <getcallerpcs>
  for(i=0; i<10; i++)
801004ad:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004b0:	83 ec 08             	sub    $0x8,%esp
801004b3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004b5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004b8:	68 c1 84 10 80       	push   $0x801084c1
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
801004fa:	e8 91 6a 00 00       	call   80106f90 <uartputc>
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
80100645:	e8 46 69 00 00       	call   80106f90 <uartputc>
    uartputc(' ');
8010064a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100651:	e8 3a 69 00 00       	call   80106f90 <uartputc>
    uartputc('\b');
80100656:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010065d:	e8 2e 69 00 00       	call   80106f90 <uartputc>
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
80100687:	e8 54 53 00 00       	call   801059e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010068c:	b8 80 07 00 00       	mov    $0x780,%eax
80100691:	83 c4 0c             	add    $0xc,%esp
80100694:	29 f8                	sub    %edi,%eax
80100696:	01 c0                	add    %eax,%eax
80100698:	50                   	push   %eax
80100699:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801006a0:	6a 00                	push   $0x0
801006a2:	50                   	push   %eax
801006a3:	e8 98 52 00 00       	call   80105940 <memset>
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
801006a8:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801006ac:	03 3d f8 0a 11 80    	add    0x80110af8,%edi
801006b2:	83 c4 10             	add    $0x10,%esp
801006b5:	e9 ed fe ff ff       	jmp    801005a7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801006ba:	83 ec 0c             	sub    $0xc,%esp
801006bd:	68 c5 84 10 80       	push   $0x801084c5
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
801006df:	e8 5c 24 00 00       	call   80102b40 <iunlock>
  acquire(&cons.lock);
801006e4:	c7 04 24 c0 0a 11 80 	movl   $0x80110ac0,(%esp)
801006eb:	e8 90 51 00 00       	call   80105880 <acquire>
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
80100724:	e8 f7 50 00 00       	call   80105820 <release>
  ilock(ip);
80100729:	58                   	pop    %eax
8010072a:	ff 75 08             	push   0x8(%ebp)
8010072d:	e8 2e 23 00 00       	call   80102a60 <ilock>
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
80100776:	0f b6 92 30 85 10 80 	movzbl -0x7fef7ad0(%edx),%edx
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
80100928:	e8 53 4f 00 00       	call   80105880 <acquire>
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
80100978:	bf d8 84 10 80       	mov    $0x801084d8,%edi
      for(; *s; s++)
8010097d:	b8 28 00 00 00       	mov    $0x28,%eax
80100982:	e9 19 ff ff ff       	jmp    801008a0 <cprintf+0xc0>
80100987:	89 d0                	mov    %edx,%eax
80100989:	e8 52 fb ff ff       	call   801004e0 <consputc.part.0>
8010098e:	e9 c8 fe ff ff       	jmp    8010085b <cprintf+0x7b>
    release(&cons.lock);
80100993:	83 ec 0c             	sub    $0xc,%esp
80100996:	68 c0 0a 11 80       	push   $0x80110ac0
8010099b:	e8 80 4e 00 00       	call   80105820 <release>
801009a0:	83 c4 10             	add    $0x10,%esp
}
801009a3:	e9 c9 fe ff ff       	jmp    80100871 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801009a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801009ab:	e9 ab fe ff ff       	jmp    8010085b <cprintf+0x7b>
    panic("null fmt");
801009b0:	83 ec 0c             	sub    $0xc,%esp
801009b3:	68 df 84 10 80       	push   $0x801084df
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
80101236:	68 e8 84 10 80       	push   $0x801084e8
8010123b:	68 c0 0a 11 80       	push   $0x80110ac0
80101240:	e8 6b 44 00 00       	call   801056b0 <initlock>
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
80101269:	e8 f2 24 00 00       	call   80103760 <ioapicenable>
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

80101320 <reverseStr>:

void reverseStr(char* str, int len) {
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	56                   	push   %esi
    int i = 0, j = len - 1;
80101324:	8b 45 0c             	mov    0xc(%ebp),%eax
void reverseStr(char* str, int len) {
80101327:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010132a:	53                   	push   %ebx
    int i = 0, j = len - 1;
8010132b:	83 e8 01             	sub    $0x1,%eax
    while (i < j) {
8010132e:	85 c0                	test   %eax,%eax
80101330:	7e 20                	jle    80101352 <reverseStr+0x32>
    int i = 0, j = len - 1;
80101332:	31 d2                	xor    %edx,%edx
80101334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        char temp = str[i];
80101338:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        str[i] = str[j];
8010133c:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
80101340:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        str[j] = temp;
80101343:	89 f3                	mov    %esi,%ebx
        i++;
80101345:	83 c2 01             	add    $0x1,%edx
        str[j] = temp;
80101348:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
        j--;
8010134b:	83 e8 01             	sub    $0x1,%eax
    while (i < j) {
8010134e:	39 c2                	cmp    %eax,%edx
80101350:	7c e6                	jl     80101338 <reverseStr+0x18>
    }
}
80101352:	5b                   	pop    %ebx
80101353:	5e                   	pop    %esi
80101354:	5d                   	pop    %ebp
80101355:	c3                   	ret    
80101356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135d:	8d 76 00             	lea    0x0(%esi),%esi

80101360 <paste>:

void paste(int start, int end)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	56                   	push   %esi
80101364:	8b 4d 08             	mov    0x8(%ebp),%ecx
80101367:	8b 75 0c             	mov    0xc(%ebp),%esi
8010136a:	53                   	push   %ebx
  int k = 0;
  for (int i = start; i <= end; i++)
8010136b:	39 f1                	cmp    %esi,%ecx
8010136d:	7f 39                	jg     801013a8 <paste+0x48>
8010136f:	8d 5e 01             	lea    0x1(%esi),%ebx
  int k = 0;
80101372:	31 c0                	xor    %eax,%eax
80101374:	29 cb                	sub    %ecx,%ebx
80101376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137d:	8d 76 00             	lea    0x0(%esi),%esi
  {
    clipboard[k] = input.buf[i];
80101380:	0f b6 94 01 80 fe 10 	movzbl -0x7fef0180(%ecx,%eax,1),%edx
80101387:	80 
    k++;
80101388:	83 c0 01             	add    $0x1,%eax
    clipboard[k] = input.buf[i];
8010138b:	88 90 1f 04 11 80    	mov    %dl,-0x7feefbe1(%eax)
  for (int i = start; i <= end; i++)
80101391:	39 d8                	cmp    %ebx,%eax
80101393:	75 eb                	jne    80101380 <paste+0x20>
    k++;
80101395:	29 ce                	sub    %ecx,%esi
  }
  clipboard[k] = '\0';
  
}
80101397:	5b                   	pop    %ebx
    k++;
80101398:	83 c6 01             	add    $0x1,%esi
  clipboard[k] = '\0';
8010139b:	c6 86 20 04 11 80 00 	movb   $0x0,-0x7feefbe0(%esi)
}
801013a2:	5e                   	pop    %esi
801013a3:	5d                   	pop    %ebp
801013a4:	c3                   	ret    
801013a5:	8d 76 00             	lea    0x0(%esi),%esi
  int k = 0;
801013a8:	31 f6                	xor    %esi,%esi
}
801013aa:	5b                   	pop    %ebx
  clipboard[k] = '\0';
801013ab:	c6 86 20 04 11 80 00 	movb   $0x0,-0x7feefbe0(%esi)
}
801013b2:	5e                   	pop    %esi
801013b3:	5d                   	pop    %ebp
801013b4:	c3                   	ret    
801013b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013c0 <extractAndCompute>:

void extractAndCompute() {
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	bf 2b 00 00 00       	mov    $0x2b,%edi
801013c9:	56                   	push   %esi
801013ca:	53                   	push   %ebx
801013cb:	83 ec 3c             	sub    $0x3c,%esp
    int i = input.e - 2;
801013ce:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801013d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    int startPos = -1;
    char operator = '\0';
    int num1 = 0, num2 = 0;

    // Find the operator in the pattern NON=?
    while (i >= 0 && input.buf[i] != '\n') {
801013d6:	83 e8 02             	sub    $0x2,%eax
801013d9:	0f 88 fd 01 00 00    	js     801015dc <extractAndCompute+0x21c>
801013df:	90                   	nop
801013e0:	0f b6 90 80 fe 10 80 	movzbl -0x7fef0180(%eax),%edx
801013e7:	80 fa 0a             	cmp    $0xa,%dl
801013ea:	0f 84 ec 01 00 00    	je     801015dc <extractAndCompute+0x21c>
        if (isOperator(input.buf[i])) {
801013f0:	8d 72 d6             	lea    -0x2a(%edx),%esi
            operator = input.buf[i];
            startPos = i;
            break;
        }
        i--;
801013f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
801013f6:	89 f1                	mov    %esi,%ecx
801013f8:	80 f9 05             	cmp    $0x5,%cl
801013fb:	0f 87 e7 01 00 00    	ja     801015e8 <extractAndCompute+0x228>
80101401:	0f a3 f7             	bt     %esi,%edi
80101404:	0f 83 de 01 00 00    	jae    801015e8 <extractAndCompute+0x228>
    }

    if (operator == '\0') return;

    int j = input.e - 3; // Skip the last '?'
8010140a:	8b 7d c4             	mov    -0x3c(%ebp),%edi
8010140d:	88 55 c0             	mov    %dl,-0x40(%ebp)
80101410:	8d 77 fd             	lea    -0x3(%edi),%esi
    int count_zero_num2 = 0;
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
80101413:	31 ff                	xor    %edi,%edi
80101415:	89 f2                	mov    %esi,%edx
80101417:	39 c6                	cmp    %eax,%esi
80101419:	0f 8e 90 00 00 00    	jle    801014af <extractAndCompute+0xef>
8010141f:	31 c9                	xor    %ecx,%ecx
80101421:	eb 0f                	jmp    80101432 <extractAndCompute+0x72>
80101423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101427:	90                   	nop
        count_zero_num2++;
        j--;
80101428:	83 ea 01             	sub    $0x1,%edx
        count_zero_num2++;
8010142b:	83 c1 01             	add    $0x1,%ecx
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
8010142e:	39 c2                	cmp    %eax,%edx
80101430:	7e 09                	jle    8010143b <extractAndCompute+0x7b>
80101432:	80 ba 80 fe 10 80 30 	cmpb   $0x30,-0x7fef0180(%edx)
80101439:	74 ed                	je     80101428 <extractAndCompute+0x68>
8010143b:	89 4d bc             	mov    %ecx,-0x44(%ebp)
    int count_zero_num2 = 0;
8010143e:	31 c9                	xor    %ecx,%ecx
80101440:	eb 14                	jmp    80101456 <extractAndCompute+0x96>
80101442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }

    j = input.e - 3; // Skip the last '?'
    while (j > startPos && isDigit(input.buf[j])) {
        num2 = (num2 * 10) + (input.buf[j] - '0');
80101448:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
        j--;
8010144b:	83 ee 01             	sub    $0x1,%esi
        num2 = (num2 * 10) + (input.buf[j] - '0');
8010144e:	8d 4c 57 d0          	lea    -0x30(%edi,%edx,2),%ecx
    while (j > startPos && isDigit(input.buf[j])) {
80101452:	39 c6                	cmp    %eax,%esi
80101454:	7e 11                	jle    80101467 <extractAndCompute+0xa7>
80101456:	0f be be 80 fe 10 80 	movsbl -0x7fef0180(%esi),%edi
8010145d:	89 fa                	mov    %edi,%edx
  return(c>='0' && c<='9');
8010145f:	83 ea 30             	sub    $0x30,%edx
    while (j > startPos && isDigit(input.buf[j])) {
80101462:	80 fa 09             	cmp    $0x9,%dl
80101465:	76 e1                	jbe    80101448 <extractAndCompute+0x88>
    while (num > 0) {
80101467:	31 ff                	xor    %edi,%edi
80101469:	85 c9                	test   %ecx,%ecx
8010146b:	7e 25                	jle    80101492 <extractAndCompute+0xd2>
8010146d:	8d 76 00             	lea    0x0(%esi),%esi
        rev = rev * 10 + num % 10;
80101470:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80101475:	8d 34 bf             	lea    (%edi,%edi,4),%esi
80101478:	89 cf                	mov    %ecx,%edi
8010147a:	f7 e1                	mul    %ecx
8010147c:	c1 ea 03             	shr    $0x3,%edx
8010147f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101482:	01 c0                	add    %eax,%eax
80101484:	29 c7                	sub    %eax,%edi
80101486:	89 c8                	mov    %ecx,%eax
        num /= 10;
80101488:	89 d1                	mov    %edx,%ecx
        rev = rev * 10 + num % 10;
8010148a:	8d 3c 77             	lea    (%edi,%esi,2),%edi
    while (num > 0) {
8010148d:	83 f8 09             	cmp    $0x9,%eax
80101490:	7f de                	jg     80101470 <extractAndCompute+0xb0>
  for (int i = 0; i < power; i++)
80101492:	8b 4d bc             	mov    -0x44(%ebp),%ecx
80101495:	85 c9                	test   %ecx,%ecx
80101497:	74 16                	je     801014af <extractAndCompute+0xef>
80101499:	31 d2                	xor    %edx,%edx
  int result = 1;
8010149b:	b8 01 00 00 00       	mov    $0x1,%eax
    result = result * base;
801014a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  for (int i = 0; i < power; i++)
801014a3:	83 c2 01             	add    $0x1,%edx
    result = result * base;
801014a6:	01 c0                	add    %eax,%eax
  for (int i = 0; i < power; i++)
801014a8:	39 ca                	cmp    %ecx,%edx
801014aa:	75 f4                	jne    801014a0 <extractAndCompute+0xe0>
    }

    num2 = reverseNumber(num2);
    num2 = num2 * pow(10, count_zero_num2);
801014ac:	0f af f8             	imul   %eax,%edi

    j = startPos - 1;
    int count_zero_num1 = 0;
801014af:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    while (j > 0 && isDigit(input.buf[j]) && input.buf[j] == '0') {
801014b6:	89 d8                	mov    %ebx,%eax
801014b8:	31 d2                	xor    %edx,%edx
801014ba:	85 db                	test   %ebx,%ebx
801014bc:	7f 12                	jg     801014d0 <extractAndCompute+0x110>
801014be:	e9 15 02 00 00       	jmp    801016d8 <extractAndCompute+0x318>
801014c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014c7:	90                   	nop
        count_zero_num1++;
801014c8:	83 c2 01             	add    $0x1,%edx
    while (j > 0 && isDigit(input.buf[j]) && input.buf[j] == '0') {
801014cb:	83 e8 01             	sub    $0x1,%eax
801014ce:	74 09                	je     801014d9 <extractAndCompute+0x119>
801014d0:	80 b8 80 fe 10 80 30 	cmpb   $0x30,-0x7fef0180(%eax)
801014d7:	74 ef                	je     801014c8 <extractAndCompute+0x108>
801014d9:	89 55 bc             	mov    %edx,-0x44(%ebp)
    int count_zero_num1 = 0;
801014dc:	31 c9                	xor    %ecx,%ecx
801014de:	eb 0c                	jmp    801014ec <extractAndCompute+0x12c>
        j--;
    }

    j = startPos - 1;
    while (j >= 0 && isDigit(input.buf[j])) {
        num1 = (num1 * 10) + (input.buf[j] - '0');
801014e0:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
801014e3:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
    while (j >= 0 && isDigit(input.buf[j])) {
801014e7:	83 eb 01             	sub    $0x1,%ebx
801014ea:	72 10                	jb     801014fc <extractAndCompute+0x13c>
801014ec:	0f be 93 80 fe 10 80 	movsbl -0x7fef0180(%ebx),%edx
801014f3:	89 d0                	mov    %edx,%eax
  return(c>='0' && c<='9');
801014f5:	83 e8 30             	sub    $0x30,%eax
    while (j >= 0 && isDigit(input.buf[j])) {
801014f8:	3c 09                	cmp    $0x9,%al
801014fa:	76 e4                	jbe    801014e0 <extractAndCompute+0x120>
    while (num > 0) {
801014fc:	31 c0                	xor    %eax,%eax
801014fe:	85 c9                	test   %ecx,%ecx
80101500:	7e 2b                	jle    8010152d <extractAndCompute+0x16d>
        rev = rev * 10 + num % 10;
80101502:	89 5d b8             	mov    %ebx,-0x48(%ebp)
80101505:	8d 76 00             	lea    0x0(%esi),%esi
80101508:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
8010150b:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80101510:	89 ce                	mov    %ecx,%esi
80101512:	f7 e1                	mul    %ecx
80101514:	c1 ea 03             	shr    $0x3,%edx
80101517:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010151a:	01 c0                	add    %eax,%eax
8010151c:	29 c6                	sub    %eax,%esi
8010151e:	8d 04 5e             	lea    (%esi,%ebx,2),%eax
        num /= 10;
80101521:	89 cb                	mov    %ecx,%ebx
80101523:	89 d1                	mov    %edx,%ecx
    while (num > 0) {
80101525:	83 fb 09             	cmp    $0x9,%ebx
80101528:	7f de                	jg     80101508 <extractAndCompute+0x148>
8010152a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  for (int i = 0; i < power; i++)
8010152d:	8b 75 bc             	mov    -0x44(%ebp),%esi
80101530:	85 f6                	test   %esi,%esi
80101532:	74 1b                	je     8010154f <extractAndCompute+0x18f>
80101534:	31 c9                	xor    %ecx,%ecx
  int result = 1;
80101536:	ba 01 00 00 00       	mov    $0x1,%edx
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
    result = result * base;
80101540:	8d 14 92             	lea    (%edx,%edx,4),%edx
  for (int i = 0; i < power; i++)
80101543:	83 c1 01             	add    $0x1,%ecx
    result = result * base;
80101546:	01 d2                	add    %edx,%edx
  for (int i = 0; i < power; i++)
80101548:	39 f1                	cmp    %esi,%ecx
8010154a:	75 f4                	jne    80101540 <extractAndCompute+0x180>
        j--;
    }

    num1 = reverseNumber(num1);
    num1 = num1 * pow(10, count_zero_num1);
8010154c:	0f af c2             	imul   %edx,%eax

    int result = 0;
    int reminder = 0;
    switch (operator) {
8010154f:	0f b6 4d c0          	movzbl -0x40(%ebp),%ecx
80101553:	80 f9 2d             	cmp    $0x2d,%cl
80101556:	0f 84 06 01 00 00    	je     80101662 <extractAndCompute+0x2a2>
8010155c:	7f 3a                	jg     80101598 <extractAndCompute+0x1d8>
8010155e:	80 f9 2a             	cmp    $0x2a,%cl
80101561:	0f 84 e9 00 00 00    	je     80101650 <extractAndCompute+0x290>
80101567:	80 f9 2b             	cmp    $0x2b,%cl
8010156a:	75 70                	jne    801015dc <extractAndCompute+0x21c>
        case '+':
            result = num1 + num2;
8010156c:	01 f8                	add    %edi,%eax
    int reminder = 0;
8010156e:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
            result = num1 + num2;
80101575:	89 45 c0             	mov    %eax,-0x40(%ebp)
            break;
        default:
            return;
    }

    int lengthToRemove = (input.e - startPos) + (startPos - j - 1);
80101578:	8b 55 c4             	mov    -0x3c(%ebp),%edx

    // Remove the characters in the pattern NON=?
    for (i = 0; i < lengthToRemove; i++) {
8010157b:	31 f6                	xor    %esi,%esi
    int lengthToRemove = (input.e - startPos) + (startPos - j - 1);
8010157d:	83 ea 01             	sub    $0x1,%edx
80101580:	89 d7                	mov    %edx,%edi
80101582:	29 df                	sub    %ebx,%edi
    for (i = 0; i < lengthToRemove; i++) {
80101584:	85 ff                	test   %edi,%edi
80101586:	7e 7d                	jle    80101605 <extractAndCompute+0x245>
  if(panicked) {
80101588:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
8010158d:	85 c0                	test   %eax,%eax
8010158f:	74 63                	je     801015f4 <extractAndCompute+0x234>
80101591:	fa                   	cli    
    for(;;)
80101592:	eb fe                	jmp    80101592 <extractAndCompute+0x1d2>
80101594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (operator) {
80101598:	80 7d c0 2f          	cmpb   $0x2f,-0x40(%ebp)
8010159c:	75 3e                	jne    801015dc <extractAndCompute+0x21c>
            if (num2 != 0) {
8010159e:	85 ff                	test   %edi,%edi
801015a0:	74 3a                	je     801015dc <extractAndCompute+0x21c>
                reminder = num1 % num2;
801015a2:	99                   	cltd   
801015a3:	f7 ff                	idiv   %edi
801015a5:	89 55 bc             	mov    %edx,-0x44(%ebp)
801015a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
                if (reminder != 0) {
801015ab:	85 d2                	test   %edx,%edx
801015ad:	74 c9                	je     80101578 <extractAndCompute+0x1b8>
                    reminder = (reminder * 10) / num2;
801015af:	8d 04 92             	lea    (%edx,%edx,4),%eax
801015b2:	01 c0                	add    %eax,%eax
801015b4:	99                   	cltd   
801015b5:	f7 ff                	idiv   %edi
801015b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
801015ba:	eb bc                	jmp    80101578 <extractAndCompute+0x1b8>
        input.buf[input.e % INPUT_BUF] = '.';
        input.e++;
        
        char decimalResult[2]; 
        itoa(reminder, decimalResult, 10);
        consputc(decimalResult[0]);
801015bc:	0f be c3             	movsbl %bl,%eax
801015bf:	e8 1c ef ff ff       	call   801004e0 <consputc.part.0>
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
801015c4:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801015c9:	89 c2                	mov    %eax,%edx
        input.e++;
801015cb:	83 c0 01             	add    $0x1,%eax
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
801015ce:	83 e2 7f             	and    $0x7f,%edx
        input.e++;
801015d1:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
801015d6:	88 9a 80 fe 10 80    	mov    %bl,-0x7fef0180(%edx)
    }
}
801015dc:	83 c4 3c             	add    $0x3c,%esp
801015df:	5b                   	pop    %ebx
801015e0:	5e                   	pop    %esi
801015e1:	5f                   	pop    %edi
801015e2:	5d                   	pop    %ebp
801015e3:	c3                   	ret    
801015e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (i >= 0 && input.buf[i] != '\n') {
801015e8:	83 fb ff             	cmp    $0xffffffff,%ebx
801015eb:	74 ef                	je     801015dc <extractAndCompute+0x21c>
801015ed:	89 d8                	mov    %ebx,%eax
801015ef:	e9 ec fd ff ff       	jmp    801013e0 <extractAndCompute+0x20>
801015f4:	b8 00 01 00 00       	mov    $0x100,%eax
    for (i = 0; i < lengthToRemove; i++) {
801015f9:	83 c6 01             	add    $0x1,%esi
801015fc:	e8 df ee ff ff       	call   801004e0 <consputc.part.0>
80101601:	39 f7                	cmp    %esi,%edi
80101603:	75 83                	jne    80101588 <extractAndCompute+0x1c8>
    if (num == 0) {
80101605:	8b 45 c0             	mov    -0x40(%ebp),%eax
        input.buf[(j + 1 + i) % INPUT_BUF] = resultStr[i];
80101608:	8d 7b 01             	lea    0x1(%ebx),%edi
8010160b:	89 fb                	mov    %edi,%ebx
    if (num == 0) {
8010160d:	85 c0                	test   %eax,%eax
8010160f:	0f 84 ab 00 00 00    	je     801016c0 <extractAndCompute+0x300>
80101615:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101618:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010161d:	89 c2                	mov    %eax,%edx
8010161f:	89 c6                	mov    %eax,%esi
80101621:	8b 45 c0             	mov    -0x40(%ebp),%eax
80101624:	e8 57 ed ff ff       	call   80100380 <itoa.part.0>
    for (i = 0; resultStr[i] != '\0'; i++) {
80101629:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
8010162d:	84 c0                	test   %al,%al
8010162f:	74 54                	je     80101685 <extractAndCompute+0x2c5>
80101631:	31 db                	xor    %ebx,%ebx
        input.buf[(j + 1 + i) % INPUT_BUF] = resultStr[i];
80101633:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80101636:	83 e2 7f             	and    $0x7f,%edx
80101639:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
  if(panicked) {
8010163f:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
80101645:	85 d2                	test   %edx,%edx
80101647:	74 2a                	je     80101673 <extractAndCompute+0x2b3>
80101649:	fa                   	cli    
    for(;;)
8010164a:	eb fe                	jmp    8010164a <extractAndCompute+0x28a>
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            result = num1 * num2;
80101650:	0f af f8             	imul   %eax,%edi
    int reminder = 0;
80101653:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
            result = num1 * num2;
8010165a:	89 7d c0             	mov    %edi,-0x40(%ebp)
            break;
8010165d:	e9 16 ff ff ff       	jmp    80101578 <extractAndCompute+0x1b8>
            result = num1 - num2;
80101662:	29 f8                	sub    %edi,%eax
    int reminder = 0;
80101664:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
            result = num1 - num2;
8010166b:	89 45 c0             	mov    %eax,-0x40(%ebp)
            break;
8010166e:	e9 05 ff ff ff       	jmp    80101578 <extractAndCompute+0x1b8>
80101673:	e8 68 ee ff ff       	call   801004e0 <consputc.part.0>
    for (i = 0; resultStr[i] != '\0'; i++) {
80101678:	83 c3 01             	add    $0x1,%ebx
8010167b:	0f be 04 1e          	movsbl (%esi,%ebx,1),%eax
8010167f:	84 c0                	test   %al,%al
80101681:	75 b0                	jne    80101633 <extractAndCompute+0x273>
    input.e = j + 1 + i;
80101683:	01 fb                	add    %edi,%ebx
80101685:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
    for (int i = input.e; i < INPUT_BUF; i++)
8010168b:	83 fb 7f             	cmp    $0x7f,%ebx
8010168e:	7f 12                	jg     801016a2 <extractAndCompute+0x2e2>
      input.buf[i] = '\0';
80101690:	c6 83 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%ebx)
    for (int i = input.e; i < INPUT_BUF; i++)
80101697:	83 c3 01             	add    $0x1,%ebx
8010169a:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801016a0:	75 ee                	jne    80101690 <extractAndCompute+0x2d0>
    if (reminder != 0) {
801016a2:	8b 4d bc             	mov    -0x44(%ebp),%ecx
801016a5:	85 c9                	test   %ecx,%ecx
801016a7:	0f 84 2f ff ff ff    	je     801015dc <extractAndCompute+0x21c>
  if(panicked) {
801016ad:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
801016b3:	85 d2                	test   %edx,%edx
801016b5:	74 33                	je     801016ea <extractAndCompute+0x32a>
801016b7:	fa                   	cli    
    for(;;)
801016b8:	eb fe                	jmp    801016b8 <extractAndCompute+0x2f8>
801016ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        str[i++] = '0';
801016c0:	b9 30 00 00 00       	mov    $0x30,%ecx
801016c5:	8d 5d d8             	lea    -0x28(%ebp),%ebx
    for (i = 0; resultStr[i] != '\0'; i++) {
801016c8:	b8 30 00 00 00       	mov    $0x30,%eax
        str[i++] = '0';
801016cd:	66 89 4d d8          	mov    %cx,-0x28(%ebp)
    for (i = 0; resultStr[i] != '\0'; i++) {
801016d1:	89 de                	mov    %ebx,%esi
801016d3:	e9 59 ff ff ff       	jmp    80101631 <extractAndCompute+0x271>
    while (j >= 0 && isDigit(input.buf[j])) {
801016d8:	0f 84 fe fd ff ff    	je     801014dc <extractAndCompute+0x11c>
801016de:	31 c0                	xor    %eax,%eax
801016e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801016e5:	e9 65 fe ff ff       	jmp    8010154f <extractAndCompute+0x18f>
801016ea:	b8 2e 00 00 00       	mov    $0x2e,%eax
801016ef:	e8 ec ed ff ff       	call   801004e0 <consputc.part.0>
        input.buf[input.e % INPUT_BUF] = '.';
801016f4:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801016f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
801016fe:	89 c2                	mov    %eax,%edx
        input.e++;
80101700:	83 c0 01             	add    $0x1,%eax
80101703:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
        input.buf[input.e % INPUT_BUF] = '.';
80101708:	83 e2 7f             	and    $0x7f,%edx
8010170b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010170e:	c6 82 80 fe 10 80 2e 	movb   $0x2e,-0x7fef0180(%edx)
    if (num == 0) {
80101715:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80101718:	e8 63 ec ff ff       	call   80100380 <itoa.part.0>
  if(panicked) {
8010171d:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
        consputc(decimalResult[0]);
80101722:	0f b6 5d d6          	movzbl -0x2a(%ebp),%ebx
  if(panicked) {
80101726:	85 c0                	test   %eax,%eax
80101728:	0f 84 8e fe ff ff    	je     801015bc <extractAndCompute+0x1fc>
8010172e:	fa                   	cli    
    for(;;)
8010172f:	eb fe                	jmp    8010172f <extractAndCompute+0x36f>
80101731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173f:	90                   	nop

80101740 <consoleintr>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	57                   	push   %edi
80101744:	56                   	push   %esi
80101745:	53                   	push   %ebx
80101746:	83 ec 28             	sub    $0x28,%esp
80101749:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010174c:	68 c0 0a 11 80       	push   $0x80110ac0
80101751:	e8 2a 41 00 00       	call   80105880 <acquire>
  int c, doprocdump = 0;
80101756:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
8010175d:	83 c4 10             	add    $0x10,%esp
80101760:	ff d7                	call   *%edi
80101762:	89 c3                	mov    %eax,%ebx
80101764:	85 c0                	test   %eax,%eax
80101766:	0f 88 e4 00 00 00    	js     80101850 <consoleintr+0x110>
    switch(c){
8010176c:	83 fb 3f             	cmp    $0x3f,%ebx
8010176f:	0f 84 4b 04 00 00    	je     80101bc0 <consoleintr+0x480>
80101775:	7f 19                	jg     80101790 <consoleintr+0x50>
80101777:	8d 43 fa             	lea    -0x6(%ebx),%eax
8010177a:	83 f8 0f             	cmp    $0xf,%eax
8010177d:	0f 87 25 01 00 00    	ja     801018a8 <consoleintr+0x168>
80101783:	ff 24 85 f0 84 10 80 	jmp    *-0x7fef7b10(,%eax,4)
8010178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101790:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80101796:	0f 84 8c 03 00 00    	je     80101b28 <consoleintr+0x3e8>
8010179c:	0f 8e d6 00 00 00    	jle    80101878 <consoleintr+0x138>
801017a2:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801017a8:	0f 84 92 03 00 00    	je     80101b40 <consoleintr+0x400>
801017ae:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801017b4:	0f 85 f6 00 00 00    	jne    801018b0 <consoleintr+0x170>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801017ba:	be d4 03 00 00       	mov    $0x3d4,%esi
801017bf:	b8 0e 00 00 00       	mov    $0xe,%eax
801017c4:	89 f2                	mov    %esi,%edx
801017c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801017c7:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801017cc:	89 ca                	mov    %ecx,%edx
801017ce:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801017cf:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801017d2:	89 f2                	mov    %esi,%edx
801017d4:	b8 0f 00 00 00       	mov    $0xf,%eax
801017d9:	c1 e3 08             	shl    $0x8,%ebx
801017dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801017dd:	89 ca                	mov    %ecx,%edx
801017df:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801017e0:	0f b6 c8             	movzbl %al,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
801017e3:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT + 1);
801017e8:	09 d9                	or     %ebx,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
801017ea:	89 c8                	mov    %ecx,%eax
801017ec:	f7 e2                	mul    %edx
801017ee:	c1 ea 06             	shr    $0x6,%edx
801017f1:	8d 44 92 05          	lea    0x5(%edx,%edx,4),%eax
801017f5:	c1 e0 04             	shl    $0x4,%eax
801017f8:	83 e8 01             	sub    $0x1,%eax
  if ((pos < last_index_line) && (cap > 0))
801017fb:	39 c1                	cmp    %eax,%ecx
801017fd:	7d 14                	jge    80101813 <consoleintr+0xd3>
801017ff:	a1 f8 0a 11 80       	mov    0x80110af8,%eax
80101804:	85 c0                	test   %eax,%eax
80101806:	7e 0b                	jle    80101813 <consoleintr+0xd3>
    cap--;
80101808:	83 e8 01             	sub    $0x1,%eax
    pos++;
8010180b:	83 c1 01             	add    $0x1,%ecx
    cap--;
8010180e:	a3 f8 0a 11 80       	mov    %eax,0x80110af8
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101813:	be d4 03 00 00       	mov    $0x3d4,%esi
80101818:	b8 0e 00 00 00       	mov    $0xe,%eax
8010181d:	89 f2                	mov    %esi,%edx
8010181f:	ee                   	out    %al,(%dx)
80101820:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
80101825:	89 c8                	mov    %ecx,%eax
80101827:	c1 f8 08             	sar    $0x8,%eax
8010182a:	89 da                	mov    %ebx,%edx
8010182c:	ee                   	out    %al,(%dx)
8010182d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101832:	89 f2                	mov    %esi,%edx
80101834:	ee                   	out    %al,(%dx)
80101835:	89 c8                	mov    %ecx,%eax
80101837:	89 da                	mov    %ebx,%edx
80101839:	ee                   	out    %al,(%dx)
  while((c = getc()) >= 0){
8010183a:	ff d7                	call   *%edi
8010183c:	89 c3                	mov    %eax,%ebx
8010183e:	85 c0                	test   %eax,%eax
80101840:	0f 89 26 ff ff ff    	jns    8010176c <consoleintr+0x2c>
80101846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	68 c0 0a 11 80       	push   $0x80110ac0
80101858:	e8 c3 3f 00 00       	call   80105820 <release>
  if(doprocdump) {
8010185d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101860:	83 c4 10             	add    $0x10,%esp
80101863:	85 c0                	test   %eax,%eax
80101865:	0f 85 e4 03 00 00    	jne    80101c4f <consoleintr+0x50f>
}
8010186b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186e:	5b                   	pop    %ebx
8010186f:	5e                   	pop    %esi
80101870:	5f                   	pop    %edi
80101871:	5d                   	pop    %ebp
80101872:	c3                   	ret    
80101873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101877:	90                   	nop
    switch(c){
80101878:	83 fb 7f             	cmp    $0x7f,%ebx
8010187b:	0f 84 2f 01 00 00    	je     801019b0 <consoleintr+0x270>
80101881:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80101887:	75 27                	jne    801018b0 <consoleintr+0x170>
      if (upDownKeyIndex < historyCurrentSize)
80101889:	a1 24 05 11 80       	mov    0x80110524,%eax
8010188e:	39 05 20 05 11 80    	cmp    %eax,0x80110520
80101894:	0f 8d c6 fe ff ff    	jge    80101760 <consoleintr+0x20>
        showPastCommand();
8010189a:	e8 21 f6 ff ff       	call   80100ec0 <showPastCommand>
8010189f:	e9 bc fe ff ff       	jmp    80101760 <consoleintr+0x20>
801018a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801018a8:	85 db                	test   %ebx,%ebx
801018aa:	0f 84 b0 fe ff ff    	je     80101760 <consoleintr+0x20>
801018b0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801018b5:	89 c2                	mov    %eax,%edx
801018b7:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801018bd:	83 fa 7f             	cmp    $0x7f,%edx
801018c0:	0f 87 9a fe ff ff    	ja     80101760 <consoleintr+0x20>
        if (c=='\n'){
801018c6:	83 fb 0d             	cmp    $0xd,%ebx
801018c9:	0f 84 b4 03 00 00    	je     80101c83 <consoleintr+0x543>
801018cf:	83 fb 0a             	cmp    $0xa,%ebx
801018d2:	0f 84 ab 03 00 00    	je     80101c83 <consoleintr+0x543>
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
801018d8:	88 5d e0             	mov    %bl,-0x20(%ebp)
  for (int i = input.e; i > input.e - cap; i--)
801018db:	8b 35 f8 0a 11 80    	mov    0x80110af8,%esi
801018e1:	89 c1                	mov    %eax,%ecx
801018e3:	89 c2                	mov    %eax,%edx
801018e5:	29 f1                	sub    %esi,%ecx
801018e7:	39 c1                	cmp    %eax,%ecx
801018e9:	73 46                	jae    80101931 <consoleintr+0x1f1>
801018eb:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801018ee:	66 90                	xchg   %ax,%ax
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
8010192c:	72 c2                	jb     801018f0 <consoleintr+0x1b0>
8010192e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101931:	83 c0 01             	add    $0x1,%eax
  if(panicked) {
80101934:	8b 15 fc 0a 11 80    	mov    0x80110afc,%edx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
8010193a:	83 e1 7f             	and    $0x7f,%ecx
8010193d:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
80101942:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80101946:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked) {
8010194c:	85 d2                	test   %edx,%edx
8010194e:	0f 84 bd 03 00 00    	je     80101d11 <consoleintr+0x5d1>
  asm volatile("cli");
80101954:	fa                   	cli    
    for(;;)
80101955:	eb fe                	jmp    80101955 <consoleintr+0x215>
80101957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010195e:	66 90                	xchg   %ax,%ax
    switch(c){
80101960:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80101967:	e9 f4 fd ff ff       	jmp    80101760 <consoleintr+0x20>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80101970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101975:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010197b:	0f 84 df fd ff ff    	je     80101760 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80101981:	83 e8 01             	sub    $0x1,%eax
80101984:	89 c2                	mov    %eax,%edx
80101986:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80101989:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80101990:	0f 84 ca fd ff ff    	je     80101760 <consoleintr+0x20>
        input.e--;
80101996:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked) {
8010199b:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
801019a0:	85 c0                	test   %eax,%eax
801019a2:	0f 84 28 02 00 00    	je     80101bd0 <consoleintr+0x490>
801019a8:	fa                   	cli    
    for(;;)
801019a9:	eb fe                	jmp    801019a9 <consoleintr+0x269>
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop
        if(input.e != input.w && input.e - input.w > cap) {
801019b0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801019b5:	8b 15 04 ff 10 80    	mov    0x8010ff04,%edx
801019bb:	39 d0                	cmp    %edx,%eax
801019bd:	0f 84 9d fd ff ff    	je     80101760 <consoleintr+0x20>
801019c3:	89 c3                	mov    %eax,%ebx
801019c5:	8b 0d f8 0a 11 80    	mov    0x80110af8,%ecx
801019cb:	29 d3                	sub    %edx,%ebx
801019cd:	39 cb                	cmp    %ecx,%ebx
801019cf:	0f 86 8b fd ff ff    	jbe    80101760 <consoleintr+0x20>
          if (cap > 0)
801019d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801019d8:	85 c9                	test   %ecx,%ecx
801019da:	0f 8f db 02 00 00    	jg     80101cbb <consoleintr+0x57b>
  if(panicked) {
801019e0:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
          input.e--;
801019e5:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
  if(panicked) {
801019eb:	85 c0                	test   %eax,%eax
801019ed:	0f 84 68 02 00 00    	je     80101c5b <consoleintr+0x51b>
801019f3:	fa                   	cli    
    for(;;)
801019f4:	eb fe                	jmp    801019f4 <consoleintr+0x2b4>
801019f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019fd:	8d 76 00             	lea    0x0(%esi),%esi
      if(saveStatus)
80101a00:	8b 35 18 04 11 80    	mov    0x80110418,%esi
80101a06:	85 f6                	test   %esi,%esi
80101a08:	0f 84 52 fd ff ff    	je     80101760 <consoleintr+0x20>
        end_copy = input.e;
80101a0e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
        paste(start_copy, end_copy);
80101a13:	8b 1d 10 04 11 80    	mov    0x80110410,%ebx
        end_copy = input.e;
80101a19:	a3 0c 04 11 80       	mov    %eax,0x8011040c
  for (int i = start; i <= end; i++)
80101a1e:	39 d8                	cmp    %ebx,%eax
80101a20:	0f 8c 8e 02 00 00    	jl     80101cb4 <consoleintr+0x574>
80101a26:	8d 70 01             	lea    0x1(%eax),%esi
  int k = 0;
80101a29:	31 d2                	xor    %edx,%edx
80101a2b:	29 de                	sub    %ebx,%esi
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    clipboard[k] = input.buf[i];
80101a30:	0f b6 8c 13 80 fe 10 	movzbl -0x7fef0180(%ebx,%edx,1),%ecx
80101a37:	80 
    k++;
80101a38:	83 c2 01             	add    $0x1,%edx
    clipboard[k] = input.buf[i];
80101a3b:	88 8a 1f 04 11 80    	mov    %cl,-0x7feefbe1(%edx)
  for (int i = start; i <= end; i++)
80101a41:	39 f2                	cmp    %esi,%edx
80101a43:	75 eb                	jne    80101a30 <consoleintr+0x2f0>
    k++;
80101a45:	89 c2                	mov    %eax,%edx
80101a47:	29 da                	sub    %ebx,%edx
80101a49:	83 c2 01             	add    $0x1,%edx
  clipboard[k] = '\0';
80101a4c:	c6 82 20 04 11 80 00 	movb   $0x0,-0x7feefbe0(%edx)
        while(clipboard[i] != '\0')
80101a53:	0f b6 15 20 04 11 80 	movzbl 0x80110420,%edx
80101a5a:	88 55 e0             	mov    %dl,-0x20(%ebp)
80101a5d:	84 d2                	test   %dl,%dl
80101a5f:	0f 84 1a 03 00 00    	je     80101d7f <consoleintr+0x63f>
        int i = 0;
80101a65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  for (int i = input.e; i > input.e - cap; i--)
80101a6c:	8b 35 f8 0a 11 80    	mov    0x80110af8,%esi
80101a72:	89 c1                	mov    %eax,%ecx
80101a74:	89 c2                	mov    %eax,%edx
80101a76:	29 f1                	sub    %esi,%ecx
80101a78:	39 c1                	cmp    %eax,%ecx
80101a7a:	73 42                	jae    80101abe <consoleintr+0x37e>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
80101a80:	89 d0                	mov    %edx,%eax
80101a82:	83 ea 01             	sub    $0x1,%edx
80101a85:	89 d3                	mov    %edx,%ebx
80101a87:	c1 fb 1f             	sar    $0x1f,%ebx
80101a8a:	c1 eb 19             	shr    $0x19,%ebx
80101a8d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101a90:	83 e1 7f             	and    $0x7f,%ecx
80101a93:	29 d9                	sub    %ebx,%ecx
80101a95:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
80101a9c:	89 c1                	mov    %eax,%ecx
80101a9e:	c1 f9 1f             	sar    $0x1f,%ecx
80101aa1:	c1 e9 19             	shr    $0x19,%ecx
80101aa4:	01 c8                	add    %ecx,%eax
80101aa6:	83 e0 7f             	and    $0x7f,%eax
80101aa9:	29 c8                	sub    %ecx,%eax
80101aab:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101ab1:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101ab6:	89 c1                	mov    %eax,%ecx
80101ab8:	29 f1                	sub    %esi,%ecx
80101aba:	39 d1                	cmp    %edx,%ecx
80101abc:	72 c2                	jb     80101a80 <consoleintr+0x340>
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
80101abe:	83 c0 01             	add    $0x1,%eax
  if(panicked) {
80101ac1:	8b 1d fc 0a 11 80    	mov    0x80110afc,%ebx
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
80101ac7:	83 e1 7f             	and    $0x7f,%ecx
80101aca:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
80101acf:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80101ad3:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked) {
80101ad9:	85 db                	test   %ebx,%ebx
80101adb:	0f 84 6f 02 00 00    	je     80101d50 <consoleintr+0x610>
80101ae1:	fa                   	cli    
    for(;;)
80101ae2:	eb fe                	jmp    80101ae2 <consoleintr+0x3a2>
80101ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101ae8:	83 ec 04             	sub    $0x4,%esp
      start_copy = input.e;
80101aeb:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
      saveStatus = 1;
80101af0:	c7 05 18 04 11 80 01 	movl   $0x1,0x80110418
80101af7:	00 00 00 
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101afa:	68 80 00 00 00       	push   $0x80
80101aff:	6a 00                	push   $0x0
80101b01:	68 20 04 11 80       	push   $0x80110420
      saveIndex = 0;
80101b06:	c7 05 14 04 11 80 00 	movl   $0x0,0x80110414
80101b0d:	00 00 00 
      start_copy = input.e;
80101b10:	a3 10 04 11 80       	mov    %eax,0x80110410
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101b15:	e8 26 3e 00 00       	call   80105940 <memset>
      break;
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	e9 3e fc ff ff       	jmp    80101760 <consoleintr+0x20>
80101b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (upDownKeyIndex > 0)
80101b28:	8b 0d 20 05 11 80    	mov    0x80110520,%ecx
80101b2e:	85 c9                	test   %ecx,%ecx
80101b30:	0f 8e 2a fc ff ff    	jle    80101760 <consoleintr+0x20>
        showNewCommand();
80101b36:	e8 05 f3 ff ff       	call   80100e40 <showNewCommand>
80101b3b:	e9 20 fc ff ff       	jmp    80101760 <consoleintr+0x20>
      if ((input.e - cap) > input.w) 
80101b40:	8b 0d f8 0a 11 80    	mov    0x80110af8,%ecx
80101b46:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101b4b:	29 c8                	sub    %ecx,%eax
80101b4d:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80101b53:	0f 86 07 fc ff ff    	jbe    80101760 <consoleintr+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b59:	be d4 03 00 00       	mov    $0x3d4,%esi
80101b5e:	b8 0e 00 00 00       	mov    $0xe,%eax
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b66:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101b6b:	89 da                	mov    %ebx,%edx
80101b6d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80101b6e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b71:	89 f2                	mov    %esi,%edx
80101b73:	c1 e0 08             	shl    $0x8,%eax
80101b76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b79:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b7f:	89 da                	mov    %ebx,%edx
80101b81:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101b82:	0f b6 d8             	movzbl %al,%ebx
80101b85:	0b 5d e0             	or     -0x20(%ebp),%ebx
  int first_write_index = NUMCOL * ((int) pos / NUMCOL) + 2;
80101b88:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80101b8d:	89 d8                	mov    %ebx,%eax
80101b8f:	f7 e2                	mul    %edx
80101b91:	c1 ea 06             	shr    $0x6,%edx
80101b94:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101b97:	c1 e0 04             	shl    $0x4,%eax
80101b9a:	83 c0 02             	add    $0x2,%eax
  if(pos >= first_write_index  && crt[pos - 2] != (('$' & 0xff) | 0x0700))
80101b9d:	39 c3                	cmp    %eax,%ebx
80101b9f:	7c 7b                	jl     80101c1c <consoleintr+0x4dc>
80101ba1:	66 81 bc 1b fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ebx,%ebx,1)
80101ba8:	80 24 07 
80101bab:	74 6f                	je     80101c1c <consoleintr+0x4dc>
    pos--;
80101bad:	83 eb 01             	sub    $0x1,%ebx
    cap++;
80101bb0:	83 c1 01             	add    $0x1,%ecx
80101bb3:	89 0d f8 0a 11 80    	mov    %ecx,0x80110af8
80101bb9:	eb 68                	jmp    80101c23 <consoleintr+0x4e3>
80101bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop
  if(panicked) {
80101bc0:	a1 fc 0a 11 80       	mov    0x80110afc,%eax
80101bc5:	85 c0                	test   %eax,%eax
80101bc7:	74 27                	je     80101bf0 <consoleintr+0x4b0>
  asm volatile("cli");
80101bc9:	fa                   	cli    
    for(;;)
80101bca:	eb fe                	jmp    80101bca <consoleintr+0x48a>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd0:	b8 00 01 00 00       	mov    $0x100,%eax
80101bd5:	e8 06 e9 ff ff       	call   801004e0 <consputc.part.0>
      while(input.e != input.w &&
80101bda:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101bdf:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80101be5:	0f 85 96 fd ff ff    	jne    80101981 <consoleintr+0x241>
80101beb:	e9 70 fb ff ff       	jmp    80101760 <consoleintr+0x20>
80101bf0:	b8 3f 00 00 00       	mov    $0x3f,%eax
80101bf5:	e8 e6 e8 ff ff       	call   801004e0 <consputc.part.0>
      input.buf[(input.e++) % INPUT_BUF] = c;
80101bfa:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101bff:	8d 50 01             	lea    0x1(%eax),%edx
80101c02:	83 e0 7f             	and    $0x7f,%eax
80101c05:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80101c0b:	c6 80 80 fe 10 80 3f 	movb   $0x3f,-0x7fef0180(%eax)
      extractAndCompute(); // Check for NON=? and compute the result
80101c12:	e8 a9 f7 ff ff       	call   801013c0 <extractAndCompute>
      break;
80101c17:	e9 44 fb ff ff       	jmp    80101760 <consoleintr+0x20>
  if (pos+1 >= first_write_index)
80101c1c:	8d 53 01             	lea    0x1(%ebx),%edx
80101c1f:	39 d0                	cmp    %edx,%eax
80101c21:	7e 8d                	jle    80101bb0 <consoleintr+0x470>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c23:	be d4 03 00 00       	mov    $0x3d4,%esi
80101c28:	b8 0e 00 00 00       	mov    $0xe,%eax
80101c2d:	89 f2                	mov    %esi,%edx
80101c2f:	ee                   	out    %al,(%dx)
80101c30:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT + 1, pos >> 8);
80101c35:	89 d8                	mov    %ebx,%eax
80101c37:	c1 f8 08             	sar    $0x8,%eax
80101c3a:	89 ca                	mov    %ecx,%edx
80101c3c:	ee                   	out    %al,(%dx)
80101c3d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101c42:	89 f2                	mov    %esi,%edx
80101c44:	ee                   	out    %al,(%dx)
80101c45:	89 d8                	mov    %ebx,%eax
80101c47:	89 ca                	mov    %ecx,%edx
80101c49:	ee                   	out    %al,(%dx)
}
80101c4a:	e9 11 fb ff ff       	jmp    80101760 <consoleintr+0x20>
}
80101c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c52:	5b                   	pop    %ebx
80101c53:	5e                   	pop    %esi
80101c54:	5f                   	pop    %edi
80101c55:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80101c56:	e9 65 38 00 00       	jmp    801054c0 <procdump>
80101c5b:	b8 00 01 00 00       	mov    $0x100,%eax
80101c60:	e8 7b e8 ff ff       	call   801004e0 <consputc.part.0>
          if (cap == 0)
80101c65:	a1 f8 0a 11 80       	mov    0x80110af8,%eax
80101c6a:	85 c0                	test   %eax,%eax
80101c6c:	0f 85 ee fa ff ff    	jne    80101760 <consoleintr+0x20>
            input.buf[input.e] = '\0';
80101c72:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101c77:	c6 80 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%eax)
80101c7e:	e9 dd fa ff ff       	jmp    80101760 <consoleintr+0x20>
          cap = 0;
80101c83:	c7 05 f8 0a 11 80 00 	movl   $0x0,0x80110af8
80101c8a:	00 00 00 
  for (int i = input.e; i > input.e - cap; i--)
80101c8d:	bb 0a 00 00 00       	mov    $0xa,%ebx
          addNewCommandToHistory();
80101c92:	e8 d9 ee ff ff       	call   80100b70 <addNewCommandToHistory>
          controlNewCommand();
80101c97:	e8 14 f5 ff ff       	call   801011b0 <controlNewCommand>
  for (int i = input.e; i > input.e - cap; i--)
80101c9c:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
80101ca0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          upDownKeyIndex = 0;
80101ca5:	c7 05 20 05 11 80 00 	movl   $0x0,0x80110520
80101cac:	00 00 00 
80101caf:	e9 27 fc ff ff       	jmp    801018db <consoleintr+0x19b>
  int k = 0;
80101cb4:	31 d2                	xor    %edx,%edx
80101cb6:	e9 91 fd ff ff       	jmp    80101a4c <consoleintr+0x30c>
  for (int i = input.e - cap - 1; i < input.e; i++)
80101cbb:	89 da                	mov    %ebx,%edx
80101cbd:	29 ca                	sub    %ecx,%edx
80101cbf:	39 d0                	cmp    %edx,%eax
80101cc1:	76 42                	jbe    80101d05 <consoleintr+0x5c5>
80101cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cc7:	90                   	nop
    buf[(i) % INPUT_BUF] = buf[(i + 1) % INPUT_BUF]; // Shift elements to left
80101cc8:	89 d0                	mov    %edx,%eax
80101cca:	83 c2 01             	add    $0x1,%edx
80101ccd:	89 d3                	mov    %edx,%ebx
80101ccf:	c1 fb 1f             	sar    $0x1f,%ebx
80101cd2:	c1 eb 19             	shr    $0x19,%ebx
80101cd5:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101cd8:	83 e1 7f             	and    $0x7f,%ecx
80101cdb:	29 d9                	sub    %ebx,%ecx
80101cdd:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
80101ce4:	89 c1                	mov    %eax,%ecx
80101ce6:	c1 f9 1f             	sar    $0x1f,%ecx
80101ce9:	c1 e9 19             	shr    $0x19,%ecx
80101cec:	01 c8                	add    %ecx,%eax
80101cee:	83 e0 7f             	and    $0x7f,%eax
80101cf1:	29 c8                	sub    %ecx,%eax
80101cf3:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e - cap - 1; i < input.e; i++)
80101cf9:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101cfe:	39 d0                	cmp    %edx,%eax
80101d00:	77 c6                	ja     80101cc8 <consoleintr+0x588>
          input.e--;
80101d02:	8d 58 ff             	lea    -0x1(%eax),%ebx
  input.buf[input.e] = ' ';
80101d05:	c6 80 80 fe 10 80 20 	movb   $0x20,-0x7fef0180(%eax)
}
80101d0c:	e9 cf fc ff ff       	jmp    801019e0 <consoleintr+0x2a0>
80101d11:	89 d8                	mov    %ebx,%eax
80101d13:	e8 c8 e7 ff ff       	call   801004e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101d18:	83 fb 0a             	cmp    $0xa,%ebx
80101d1b:	74 5b                	je     80101d78 <consoleintr+0x638>
80101d1d:	83 fb 04             	cmp    $0x4,%ebx
80101d20:	74 56                	je     80101d78 <consoleintr+0x638>
80101d22:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80101d27:	83 e8 80             	sub    $0xffffff80,%eax
80101d2a:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80101d30:	0f 85 2a fa ff ff    	jne    80101760 <consoleintr+0x20>
          wakeup(&input.r);
80101d36:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101d39:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80101d3e:	68 00 ff 10 80       	push   $0x8010ff00
80101d43:	e8 98 36 00 00       	call   801053e0 <wakeup>
80101d48:	83 c4 10             	add    $0x10,%esp
80101d4b:	e9 10 fa ff ff       	jmp    80101760 <consoleintr+0x20>
          consputc(clipboard[i]);  
80101d50:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
80101d54:	e8 87 e7 ff ff       	call   801004e0 <consputc.part.0>
          i++;
80101d59:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80101d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
        while(clipboard[i] != '\0')
80101d60:	0f b6 80 20 04 11 80 	movzbl -0x7feefbe0(%eax),%eax
80101d67:	88 45 e0             	mov    %al,-0x20(%ebp)
80101d6a:	84 c0                	test   %al,%al
80101d6c:	74 11                	je     80101d7f <consoleintr+0x63f>
  for (int i = input.e; i > input.e - cap; i--)
80101d6e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101d73:	e9 f4 fc ff ff       	jmp    80101a6c <consoleintr+0x32c>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101d78:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101d7d:	eb b7                	jmp    80101d36 <consoleintr+0x5f6>
        saveStatus = 0;
80101d7f:	c7 05 18 04 11 80 00 	movl   $0x0,0x80110418
80101d86:	00 00 00 
80101d89:	e9 d2 f9 ff ff       	jmp    80101760 <consoleintr+0x20>
80101d8e:	66 90                	xchg   %ax,%ax

80101d90 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101d9c:	e8 af 2e 00 00       	call   80104c50 <myproc>
80101da1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101da7:	e8 94 22 00 00       	call   80104040 <begin_op>

  if((ip = namei(path)) == 0){
80101dac:	83 ec 0c             	sub    $0xc,%esp
80101daf:	ff 75 08             	push   0x8(%ebp)
80101db2:	e8 c9 15 00 00       	call   80103380 <namei>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	85 c0                	test   %eax,%eax
80101dbc:	0f 84 02 03 00 00    	je     801020c4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	89 c3                	mov    %eax,%ebx
80101dc7:	50                   	push   %eax
80101dc8:	e8 93 0c 00 00       	call   80102a60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101dcd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101dd3:	6a 34                	push   $0x34
80101dd5:	6a 00                	push   $0x0
80101dd7:	50                   	push   %eax
80101dd8:	53                   	push   %ebx
80101dd9:	e8 92 0f 00 00       	call   80102d70 <readi>
80101dde:	83 c4 20             	add    $0x20,%esp
80101de1:	83 f8 34             	cmp    $0x34,%eax
80101de4:	74 22                	je     80101e08 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101de6:	83 ec 0c             	sub    $0xc,%esp
80101de9:	53                   	push   %ebx
80101dea:	e8 01 0f 00 00       	call   80102cf0 <iunlockput>
    end_op();
80101def:	e8 bc 22 00 00       	call   801040b0 <end_op>
80101df4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101df7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dff:	5b                   	pop    %ebx
80101e00:	5e                   	pop    %esi
80101e01:	5f                   	pop    %edi
80101e02:	5d                   	pop    %ebp
80101e03:	c3                   	ret    
80101e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101e08:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101e0f:	45 4c 46 
80101e12:	75 d2                	jne    80101de6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101e14:	e8 07 63 00 00       	call   80108120 <setupkvm>
80101e19:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101e1f:	85 c0                	test   %eax,%eax
80101e21:	74 c3                	je     80101de6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101e23:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101e2a:	00 
80101e2b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101e31:	0f 84 ac 02 00 00    	je     801020e3 <exec+0x353>
  sz = 0;
80101e37:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101e3e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101e41:	31 ff                	xor    %edi,%edi
80101e43:	e9 8e 00 00 00       	jmp    80101ed6 <exec+0x146>
80101e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101e50:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101e57:	75 6c                	jne    80101ec5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101e59:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101e5f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101e65:	0f 82 87 00 00 00    	jb     80101ef2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101e6b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101e71:	72 7f                	jb     80101ef2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101e73:	83 ec 04             	sub    $0x4,%esp
80101e76:	50                   	push   %eax
80101e77:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101e7d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101e83:	e8 b8 60 00 00       	call   80107f40 <allocuvm>
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101e91:	85 c0                	test   %eax,%eax
80101e93:	74 5d                	je     80101ef2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101e95:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101e9b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101ea0:	75 50                	jne    80101ef2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101ea2:	83 ec 0c             	sub    $0xc,%esp
80101ea5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101eab:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101eb1:	53                   	push   %ebx
80101eb2:	50                   	push   %eax
80101eb3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101eb9:	e8 92 5f 00 00       	call   80107e50 <loaduvm>
80101ebe:	83 c4 20             	add    $0x20,%esp
80101ec1:	85 c0                	test   %eax,%eax
80101ec3:	78 2d                	js     80101ef2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101ec5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101ecc:	83 c7 01             	add    $0x1,%edi
80101ecf:	83 c6 20             	add    $0x20,%esi
80101ed2:	39 f8                	cmp    %edi,%eax
80101ed4:	7e 3a                	jle    80101f10 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101ed6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101edc:	6a 20                	push   $0x20
80101ede:	56                   	push   %esi
80101edf:	50                   	push   %eax
80101ee0:	53                   	push   %ebx
80101ee1:	e8 8a 0e 00 00       	call   80102d70 <readi>
80101ee6:	83 c4 10             	add    $0x10,%esp
80101ee9:	83 f8 20             	cmp    $0x20,%eax
80101eec:	0f 84 5e ff ff ff    	je     80101e50 <exec+0xc0>
    freevm(pgdir);
80101ef2:	83 ec 0c             	sub    $0xc,%esp
80101ef5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101efb:	e8 a0 61 00 00       	call   801080a0 <freevm>
  if(ip){
80101f00:	83 c4 10             	add    $0x10,%esp
80101f03:	e9 de fe ff ff       	jmp    80101de6 <exec+0x56>
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
  sz = PGROUNDUP(sz);
80101f10:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101f16:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80101f1c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101f22:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	53                   	push   %ebx
80101f2c:	e8 bf 0d 00 00       	call   80102cf0 <iunlockput>
  end_op();
80101f31:	e8 7a 21 00 00       	call   801040b0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101f36:	83 c4 0c             	add    $0xc,%esp
80101f39:	56                   	push   %esi
80101f3a:	57                   	push   %edi
80101f3b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101f41:	57                   	push   %edi
80101f42:	e8 f9 5f 00 00       	call   80107f40 <allocuvm>
80101f47:	83 c4 10             	add    $0x10,%esp
80101f4a:	89 c6                	mov    %eax,%esi
80101f4c:	85 c0                	test   %eax,%eax
80101f4e:	0f 84 94 00 00 00    	je     80101fe8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101f54:	83 ec 08             	sub    $0x8,%esp
80101f57:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80101f5d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101f5f:	50                   	push   %eax
80101f60:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101f61:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101f63:	e8 58 62 00 00       	call   801081c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101f68:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101f74:	8b 00                	mov    (%eax),%eax
80101f76:	85 c0                	test   %eax,%eax
80101f78:	0f 84 8b 00 00 00    	je     80102009 <exec+0x279>
80101f7e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101f84:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101f8a:	eb 23                	jmp    80101faf <exec+0x21f>
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f90:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101f93:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80101f9a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80101f9d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101fa3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101fa6:	85 c0                	test   %eax,%eax
80101fa8:	74 59                	je     80102003 <exec+0x273>
    if(argc >= MAXARG)
80101faa:	83 ff 20             	cmp    $0x20,%edi
80101fad:	74 39                	je     80101fe8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101faf:	83 ec 0c             	sub    $0xc,%esp
80101fb2:	50                   	push   %eax
80101fb3:	e8 88 3b 00 00       	call   80105b40 <strlen>
80101fb8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101fba:	58                   	pop    %eax
80101fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101fbe:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101fc1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101fc4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101fc7:	e8 74 3b 00 00       	call   80105b40 <strlen>
80101fcc:	83 c0 01             	add    $0x1,%eax
80101fcf:	50                   	push   %eax
80101fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd3:	ff 34 b8             	push   (%eax,%edi,4)
80101fd6:	53                   	push   %ebx
80101fd7:	56                   	push   %esi
80101fd8:	e8 b3 63 00 00       	call   80108390 <copyout>
80101fdd:	83 c4 20             	add    $0x20,%esp
80101fe0:	85 c0                	test   %eax,%eax
80101fe2:	79 ac                	jns    80101f90 <exec+0x200>
80101fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101ff1:	e8 aa 60 00 00       	call   801080a0 <freevm>
80101ff6:	83 c4 10             	add    $0x10,%esp
  return -1;
80101ff9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ffe:	e9 f9 fd ff ff       	jmp    80101dfc <exec+0x6c>
80102003:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102009:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80102010:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80102012:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80102019:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010201d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010201f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80102022:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80102028:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010202a:	50                   	push   %eax
8010202b:	52                   	push   %edx
8010202c:	53                   	push   %ebx
8010202d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80102033:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010203a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010203d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102043:	e8 48 63 00 00       	call   80108390 <copyout>
80102048:	83 c4 10             	add    $0x10,%esp
8010204b:	85 c0                	test   %eax,%eax
8010204d:	78 99                	js     80101fe8 <exec+0x258>
  for(last=s=path; *s; s++)
8010204f:	8b 45 08             	mov    0x8(%ebp),%eax
80102052:	8b 55 08             	mov    0x8(%ebp),%edx
80102055:	0f b6 00             	movzbl (%eax),%eax
80102058:	84 c0                	test   %al,%al
8010205a:	74 13                	je     8010206f <exec+0x2df>
8010205c:	89 d1                	mov    %edx,%ecx
8010205e:	66 90                	xchg   %ax,%ax
      last = s+1;
80102060:	83 c1 01             	add    $0x1,%ecx
80102063:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102065:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102068:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010206b:	84 c0                	test   %al,%al
8010206d:	75 f1                	jne    80102060 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010206f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80102075:	83 ec 04             	sub    $0x4,%esp
80102078:	6a 10                	push   $0x10
8010207a:	89 f8                	mov    %edi,%eax
8010207c:	52                   	push   %edx
8010207d:	83 c0 6c             	add    $0x6c,%eax
80102080:	50                   	push   %eax
80102081:	e8 7a 3a 00 00       	call   80105b00 <safestrcpy>
  curproc->pgdir = pgdir;
80102086:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010208c:	89 f8                	mov    %edi,%eax
8010208e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80102091:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80102093:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80102096:	89 c1                	mov    %eax,%ecx
80102098:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010209e:	8b 40 18             	mov    0x18(%eax),%eax
801020a1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801020a4:	8b 41 18             	mov    0x18(%ecx),%eax
801020a7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801020aa:	89 0c 24             	mov    %ecx,(%esp)
801020ad:	e8 0e 5c 00 00       	call   80107cc0 <switchuvm>
  freevm(oldpgdir);
801020b2:	89 3c 24             	mov    %edi,(%esp)
801020b5:	e8 e6 5f 00 00       	call   801080a0 <freevm>
  return 0;
801020ba:	83 c4 10             	add    $0x10,%esp
801020bd:	31 c0                	xor    %eax,%eax
801020bf:	e9 38 fd ff ff       	jmp    80101dfc <exec+0x6c>
    end_op();
801020c4:	e8 e7 1f 00 00       	call   801040b0 <end_op>
    cprintf("exec: fail\n");
801020c9:	83 ec 0c             	sub    $0xc,%esp
801020cc:	68 41 85 10 80       	push   $0x80108541
801020d1:	e8 0a e7 ff ff       	call   801007e0 <cprintf>
    return -1;
801020d6:	83 c4 10             	add    $0x10,%esp
801020d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020de:	e9 19 fd ff ff       	jmp    80101dfc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801020e3:	be 00 20 00 00       	mov    $0x2000,%esi
801020e8:	31 ff                	xor    %edi,%edi
801020ea:	e9 39 fe ff ff       	jmp    80101f28 <exec+0x198>
801020ef:	90                   	nop

801020f0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801020f6:	68 4d 85 10 80       	push   $0x8010854d
801020fb:	68 00 0b 11 80       	push   $0x80110b00
80102100:	e8 ab 35 00 00       	call   801056b0 <initlock>
}
80102105:	83 c4 10             	add    $0x10,%esp
80102108:	c9                   	leave  
80102109:	c3                   	ret    
8010210a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102110 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102114:	bb 34 0b 11 80       	mov    $0x80110b34,%ebx
{
80102119:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010211c:	68 00 0b 11 80       	push   $0x80110b00
80102121:	e8 5a 37 00 00       	call   80105880 <acquire>
80102126:	83 c4 10             	add    $0x10,%esp
80102129:	eb 10                	jmp    8010213b <filealloc+0x2b>
8010212b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010212f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102130:	83 c3 18             	add    $0x18,%ebx
80102133:	81 fb 94 14 11 80    	cmp    $0x80111494,%ebx
80102139:	74 25                	je     80102160 <filealloc+0x50>
    if(f->ref == 0){
8010213b:	8b 43 04             	mov    0x4(%ebx),%eax
8010213e:	85 c0                	test   %eax,%eax
80102140:	75 ee                	jne    80102130 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102142:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102145:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010214c:	68 00 0b 11 80       	push   $0x80110b00
80102151:	e8 ca 36 00 00       	call   80105820 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102156:	89 d8                	mov    %ebx,%eax
      return f;
80102158:	83 c4 10             	add    $0x10,%esp
}
8010215b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010215e:	c9                   	leave  
8010215f:	c3                   	ret    
  release(&ftable.lock);
80102160:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102163:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102165:	68 00 0b 11 80       	push   $0x80110b00
8010216a:	e8 b1 36 00 00       	call   80105820 <release>
}
8010216f:	89 d8                	mov    %ebx,%eax
  return 0;
80102171:	83 c4 10             	add    $0x10,%esp
}
80102174:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102177:	c9                   	leave  
80102178:	c3                   	ret    
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102180 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	53                   	push   %ebx
80102184:	83 ec 10             	sub    $0x10,%esp
80102187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010218a:	68 00 0b 11 80       	push   $0x80110b00
8010218f:	e8 ec 36 00 00       	call   80105880 <acquire>
  if(f->ref < 1)
80102194:	8b 43 04             	mov    0x4(%ebx),%eax
80102197:	83 c4 10             	add    $0x10,%esp
8010219a:	85 c0                	test   %eax,%eax
8010219c:	7e 1a                	jle    801021b8 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010219e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801021a1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801021a4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801021a7:	68 00 0b 11 80       	push   $0x80110b00
801021ac:	e8 6f 36 00 00       	call   80105820 <release>
  return f;
}
801021b1:	89 d8                	mov    %ebx,%eax
801021b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021b6:	c9                   	leave  
801021b7:	c3                   	ret    
    panic("filedup");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 54 85 10 80       	push   $0x80108554
801021c0:	e8 9b e2 ff ff       	call   80100460 <panic>
801021c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021d0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 28             	sub    $0x28,%esp
801021d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801021dc:	68 00 0b 11 80       	push   $0x80110b00
801021e1:	e8 9a 36 00 00       	call   80105880 <acquire>
  if(f->ref < 1)
801021e6:	8b 53 04             	mov    0x4(%ebx),%edx
801021e9:	83 c4 10             	add    $0x10,%esp
801021ec:	85 d2                	test   %edx,%edx
801021ee:	0f 8e a5 00 00 00    	jle    80102299 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801021f4:	83 ea 01             	sub    $0x1,%edx
801021f7:	89 53 04             	mov    %edx,0x4(%ebx)
801021fa:	75 44                	jne    80102240 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801021fc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102200:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102203:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102205:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010220b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010220e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102211:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80102214:	68 00 0b 11 80       	push   $0x80110b00
  ff = *f;
80102219:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010221c:	e8 ff 35 00 00       	call   80105820 <release>

  if(ff.type == FD_PIPE)
80102221:	83 c4 10             	add    $0x10,%esp
80102224:	83 ff 01             	cmp    $0x1,%edi
80102227:	74 57                	je     80102280 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102229:	83 ff 02             	cmp    $0x2,%edi
8010222c:	74 2a                	je     80102258 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010222e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102231:	5b                   	pop    %ebx
80102232:	5e                   	pop    %esi
80102233:	5f                   	pop    %edi
80102234:	5d                   	pop    %ebp
80102235:	c3                   	ret    
80102236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80102240:	c7 45 08 00 0b 11 80 	movl   $0x80110b00,0x8(%ebp)
}
80102247:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224a:	5b                   	pop    %ebx
8010224b:	5e                   	pop    %esi
8010224c:	5f                   	pop    %edi
8010224d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010224e:	e9 cd 35 00 00       	jmp    80105820 <release>
80102253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102257:	90                   	nop
    begin_op();
80102258:	e8 e3 1d 00 00       	call   80104040 <begin_op>
    iput(ff.ip);
8010225d:	83 ec 0c             	sub    $0xc,%esp
80102260:	ff 75 e0             	push   -0x20(%ebp)
80102263:	e8 28 09 00 00       	call   80102b90 <iput>
    end_op();
80102268:	83 c4 10             	add    $0x10,%esp
}
8010226b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010226e:	5b                   	pop    %ebx
8010226f:	5e                   	pop    %esi
80102270:	5f                   	pop    %edi
80102271:	5d                   	pop    %ebp
    end_op();
80102272:	e9 39 1e 00 00       	jmp    801040b0 <end_op>
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80102280:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102284:	83 ec 08             	sub    $0x8,%esp
80102287:	53                   	push   %ebx
80102288:	56                   	push   %esi
80102289:	e8 82 25 00 00       	call   80104810 <pipeclose>
8010228e:	83 c4 10             	add    $0x10,%esp
}
80102291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102294:	5b                   	pop    %ebx
80102295:	5e                   	pop    %esi
80102296:	5f                   	pop    %edi
80102297:	5d                   	pop    %ebp
80102298:	c3                   	ret    
    panic("fileclose");
80102299:	83 ec 0c             	sub    $0xc,%esp
8010229c:	68 5c 85 10 80       	push   $0x8010855c
801022a1:	e8 ba e1 ff ff       	call   80100460 <panic>
801022a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ad:	8d 76 00             	lea    0x0(%esi),%esi

801022b0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 04             	sub    $0x4,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801022ba:	83 3b 02             	cmpl   $0x2,(%ebx)
801022bd:	75 31                	jne    801022f0 <filestat+0x40>
    ilock(f->ip);
801022bf:	83 ec 0c             	sub    $0xc,%esp
801022c2:	ff 73 10             	push   0x10(%ebx)
801022c5:	e8 96 07 00 00       	call   80102a60 <ilock>
    stati(f->ip, st);
801022ca:	58                   	pop    %eax
801022cb:	5a                   	pop    %edx
801022cc:	ff 75 0c             	push   0xc(%ebp)
801022cf:	ff 73 10             	push   0x10(%ebx)
801022d2:	e8 69 0a 00 00       	call   80102d40 <stati>
    iunlock(f->ip);
801022d7:	59                   	pop    %ecx
801022d8:	ff 73 10             	push   0x10(%ebx)
801022db:	e8 60 08 00 00       	call   80102b40 <iunlock>
    return 0;
  }
  return -1;
}
801022e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	31 c0                	xor    %eax,%eax
}
801022e8:	c9                   	leave  
801022e9:	c3                   	ret    
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801022f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801022f8:	c9                   	leave  
801022f9:	c3                   	ret    
801022fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102300 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 0c             	sub    $0xc,%esp
80102309:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010230c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010230f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102312:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102316:	74 60                	je     80102378 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102318:	8b 03                	mov    (%ebx),%eax
8010231a:	83 f8 01             	cmp    $0x1,%eax
8010231d:	74 41                	je     80102360 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010231f:	83 f8 02             	cmp    $0x2,%eax
80102322:	75 5b                	jne    8010237f <fileread+0x7f>
    ilock(f->ip);
80102324:	83 ec 0c             	sub    $0xc,%esp
80102327:	ff 73 10             	push   0x10(%ebx)
8010232a:	e8 31 07 00 00       	call   80102a60 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010232f:	57                   	push   %edi
80102330:	ff 73 14             	push   0x14(%ebx)
80102333:	56                   	push   %esi
80102334:	ff 73 10             	push   0x10(%ebx)
80102337:	e8 34 0a 00 00       	call   80102d70 <readi>
8010233c:	83 c4 20             	add    $0x20,%esp
8010233f:	89 c6                	mov    %eax,%esi
80102341:	85 c0                	test   %eax,%eax
80102343:	7e 03                	jle    80102348 <fileread+0x48>
      f->off += r;
80102345:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	ff 73 10             	push   0x10(%ebx)
8010234e:	e8 ed 07 00 00       	call   80102b40 <iunlock>
    return r;
80102353:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102359:	89 f0                	mov    %esi,%eax
8010235b:	5b                   	pop    %ebx
8010235c:	5e                   	pop    %esi
8010235d:	5f                   	pop    %edi
8010235e:	5d                   	pop    %ebp
8010235f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80102360:	8b 43 0c             	mov    0xc(%ebx),%eax
80102363:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102366:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102369:	5b                   	pop    %ebx
8010236a:	5e                   	pop    %esi
8010236b:	5f                   	pop    %edi
8010236c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010236d:	e9 3e 26 00 00       	jmp    801049b0 <piperead>
80102372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102378:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010237d:	eb d7                	jmp    80102356 <fileread+0x56>
  panic("fileread");
8010237f:	83 ec 0c             	sub    $0xc,%esp
80102382:	68 66 85 10 80       	push   $0x80108566
80102387:	e8 d4 e0 ff ff       	call   80100460 <panic>
8010238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102390 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	57                   	push   %edi
80102394:	56                   	push   %esi
80102395:	53                   	push   %ebx
80102396:	83 ec 1c             	sub    $0x1c,%esp
80102399:	8b 45 0c             	mov    0xc(%ebp),%eax
8010239c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010239f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801023a2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801023a5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801023a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801023ac:	0f 84 bd 00 00 00    	je     8010246f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801023b2:	8b 03                	mov    (%ebx),%eax
801023b4:	83 f8 01             	cmp    $0x1,%eax
801023b7:	0f 84 bf 00 00 00    	je     8010247c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801023bd:	83 f8 02             	cmp    $0x2,%eax
801023c0:	0f 85 c8 00 00 00    	jne    8010248e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801023c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801023c9:	31 f6                	xor    %esi,%esi
    while(i < n){
801023cb:	85 c0                	test   %eax,%eax
801023cd:	7f 30                	jg     801023ff <filewrite+0x6f>
801023cf:	e9 94 00 00 00       	jmp    80102468 <filewrite+0xd8>
801023d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801023d8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801023e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801023e4:	e8 57 07 00 00       	call   80102b40 <iunlock>
      end_op();
801023e9:	e8 c2 1c 00 00       	call   801040b0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801023ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023f1:	83 c4 10             	add    $0x10,%esp
801023f4:	39 c7                	cmp    %eax,%edi
801023f6:	75 5c                	jne    80102454 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801023f8:	01 fe                	add    %edi,%esi
    while(i < n){
801023fa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801023fd:	7e 69                	jle    80102468 <filewrite+0xd8>
      int n1 = n - i;
801023ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102402:	b8 00 06 00 00       	mov    $0x600,%eax
80102407:	29 f7                	sub    %esi,%edi
80102409:	39 c7                	cmp    %eax,%edi
8010240b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010240e:	e8 2d 1c 00 00       	call   80104040 <begin_op>
      ilock(f->ip);
80102413:	83 ec 0c             	sub    $0xc,%esp
80102416:	ff 73 10             	push   0x10(%ebx)
80102419:	e8 42 06 00 00       	call   80102a60 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010241e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102421:	57                   	push   %edi
80102422:	ff 73 14             	push   0x14(%ebx)
80102425:	01 f0                	add    %esi,%eax
80102427:	50                   	push   %eax
80102428:	ff 73 10             	push   0x10(%ebx)
8010242b:	e8 40 0a 00 00       	call   80102e70 <writei>
80102430:	83 c4 20             	add    $0x20,%esp
80102433:	85 c0                	test   %eax,%eax
80102435:	7f a1                	jg     801023d8 <filewrite+0x48>
      iunlock(f->ip);
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	ff 73 10             	push   0x10(%ebx)
8010243d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102440:	e8 fb 06 00 00       	call   80102b40 <iunlock>
      end_op();
80102445:	e8 66 1c 00 00       	call   801040b0 <end_op>
      if(r < 0)
8010244a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	85 c0                	test   %eax,%eax
80102452:	75 1b                	jne    8010246f <filewrite+0xdf>
        panic("short filewrite");
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	68 6f 85 10 80       	push   $0x8010856f
8010245c:	e8 ff df ff ff       	call   80100460 <panic>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102468:	89 f0                	mov    %esi,%eax
8010246a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010246d:	74 05                	je     80102474 <filewrite+0xe4>
8010246f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80102474:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102477:	5b                   	pop    %ebx
80102478:	5e                   	pop    %esi
80102479:	5f                   	pop    %edi
8010247a:	5d                   	pop    %ebp
8010247b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010247c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010247f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102482:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102485:	5b                   	pop    %ebx
80102486:	5e                   	pop    %esi
80102487:	5f                   	pop    %edi
80102488:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80102489:	e9 22 24 00 00       	jmp    801048b0 <pipewrite>
  panic("filewrite");
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	68 75 85 10 80       	push   $0x80108575
80102496:	e8 c5 df ff ff       	call   80100460 <panic>
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801024a0:	55                   	push   %ebp
801024a1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801024a3:	89 d0                	mov    %edx,%eax
801024a5:	c1 e8 0c             	shr    $0xc,%eax
801024a8:	03 05 6c 31 11 80    	add    0x8011316c,%eax
{
801024ae:	89 e5                	mov    %esp,%ebp
801024b0:	56                   	push   %esi
801024b1:	53                   	push   %ebx
801024b2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801024b4:	83 ec 08             	sub    $0x8,%esp
801024b7:	50                   	push   %eax
801024b8:	51                   	push   %ecx
801024b9:	e8 12 dc ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801024be:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801024c0:	c1 fb 03             	sar    $0x3,%ebx
801024c3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801024c6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801024c8:	83 e1 07             	and    $0x7,%ecx
801024cb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801024d0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801024d6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801024d8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801024dd:	85 c1                	test   %eax,%ecx
801024df:	74 23                	je     80102504 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801024e1:	f7 d0                	not    %eax
  log_write(bp);
801024e3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801024e6:	21 c8                	and    %ecx,%eax
801024e8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801024ec:	56                   	push   %esi
801024ed:	e8 2e 1d 00 00       	call   80104220 <log_write>
  brelse(bp);
801024f2:	89 34 24             	mov    %esi,(%esp)
801024f5:	e8 f6 dc ff ff       	call   801001f0 <brelse>
}
801024fa:	83 c4 10             	add    $0x10,%esp
801024fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102500:	5b                   	pop    %ebx
80102501:	5e                   	pop    %esi
80102502:	5d                   	pop    %ebp
80102503:	c3                   	ret    
    panic("freeing free block");
80102504:	83 ec 0c             	sub    $0xc,%esp
80102507:	68 7f 85 10 80       	push   $0x8010857f
8010250c:	e8 4f df ff ff       	call   80100460 <panic>
80102511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251f:	90                   	nop

80102520 <balloc>:
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	57                   	push   %edi
80102524:	56                   	push   %esi
80102525:	53                   	push   %ebx
80102526:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80102529:	8b 0d 54 31 11 80    	mov    0x80113154,%ecx
{
8010252f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102532:	85 c9                	test   %ecx,%ecx
80102534:	0f 84 87 00 00 00    	je     801025c1 <balloc+0xa1>
8010253a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80102541:	8b 75 dc             	mov    -0x24(%ebp),%esi
80102544:	83 ec 08             	sub    $0x8,%esp
80102547:	89 f0                	mov    %esi,%eax
80102549:	c1 f8 0c             	sar    $0xc,%eax
8010254c:	03 05 6c 31 11 80    	add    0x8011316c,%eax
80102552:	50                   	push   %eax
80102553:	ff 75 d8             	push   -0x28(%ebp)
80102556:	e8 75 db ff ff       	call   801000d0 <bread>
8010255b:	83 c4 10             	add    $0x10,%esp
8010255e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102561:	a1 54 31 11 80       	mov    0x80113154,%eax
80102566:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102569:	31 c0                	xor    %eax,%eax
8010256b:	eb 2f                	jmp    8010259c <balloc+0x7c>
8010256d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80102570:	89 c1                	mov    %eax,%ecx
80102572:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010257a:	83 e1 07             	and    $0x7,%ecx
8010257d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010257f:	89 c1                	mov    %eax,%ecx
80102581:	c1 f9 03             	sar    $0x3,%ecx
80102584:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80102589:	89 fa                	mov    %edi,%edx
8010258b:	85 df                	test   %ebx,%edi
8010258d:	74 41                	je     801025d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010258f:	83 c0 01             	add    $0x1,%eax
80102592:	83 c6 01             	add    $0x1,%esi
80102595:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010259a:	74 05                	je     801025a1 <balloc+0x81>
8010259c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010259f:	77 cf                	ja     80102570 <balloc+0x50>
    brelse(bp);
801025a1:	83 ec 0c             	sub    $0xc,%esp
801025a4:	ff 75 e4             	push   -0x1c(%ebp)
801025a7:	e8 44 dc ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801025ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801025b3:	83 c4 10             	add    $0x10,%esp
801025b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025b9:	39 05 54 31 11 80    	cmp    %eax,0x80113154
801025bf:	77 80                	ja     80102541 <balloc+0x21>
  panic("balloc: out of blocks");
801025c1:	83 ec 0c             	sub    $0xc,%esp
801025c4:	68 92 85 10 80       	push   $0x80108592
801025c9:	e8 92 de ff ff       	call   80100460 <panic>
801025ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801025d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801025d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801025d6:	09 da                	or     %ebx,%edx
801025d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801025dc:	57                   	push   %edi
801025dd:	e8 3e 1c 00 00       	call   80104220 <log_write>
        brelse(bp);
801025e2:	89 3c 24             	mov    %edi,(%esp)
801025e5:	e8 06 dc ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801025ea:	58                   	pop    %eax
801025eb:	5a                   	pop    %edx
801025ec:	56                   	push   %esi
801025ed:	ff 75 d8             	push   -0x28(%ebp)
801025f0:	e8 db da ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801025f5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801025f8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801025fa:	8d 40 5c             	lea    0x5c(%eax),%eax
801025fd:	68 00 02 00 00       	push   $0x200
80102602:	6a 00                	push   $0x0
80102604:	50                   	push   %eax
80102605:	e8 36 33 00 00       	call   80105940 <memset>
  log_write(bp);
8010260a:	89 1c 24             	mov    %ebx,(%esp)
8010260d:	e8 0e 1c 00 00       	call   80104220 <log_write>
  brelse(bp);
80102612:	89 1c 24             	mov    %ebx,(%esp)
80102615:	e8 d6 db ff ff       	call   801001f0 <brelse>
}
8010261a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010261d:	89 f0                	mov    %esi,%eax
8010261f:	5b                   	pop    %ebx
80102620:	5e                   	pop    %esi
80102621:	5f                   	pop    %edi
80102622:	5d                   	pop    %ebp
80102623:	c3                   	ret    
80102624:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	57                   	push   %edi
80102634:	89 c7                	mov    %eax,%edi
80102636:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102637:	31 f6                	xor    %esi,%esi
{
80102639:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010263a:	bb 34 15 11 80       	mov    $0x80111534,%ebx
{
8010263f:	83 ec 28             	sub    $0x28,%esp
80102642:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102645:	68 00 15 11 80       	push   $0x80111500
8010264a:	e8 31 32 00 00       	call   80105880 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010264f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102652:	83 c4 10             	add    $0x10,%esp
80102655:	eb 1b                	jmp    80102672 <iget+0x42>
80102657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102660:	39 3b                	cmp    %edi,(%ebx)
80102662:	74 6c                	je     801026d0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102664:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010266a:	81 fb 54 31 11 80    	cmp    $0x80113154,%ebx
80102670:	73 26                	jae    80102698 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102672:	8b 43 08             	mov    0x8(%ebx),%eax
80102675:	85 c0                	test   %eax,%eax
80102677:	7f e7                	jg     80102660 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80102679:	85 f6                	test   %esi,%esi
8010267b:	75 e7                	jne    80102664 <iget+0x34>
8010267d:	85 c0                	test   %eax,%eax
8010267f:	75 76                	jne    801026f7 <iget+0xc7>
80102681:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102683:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102689:	81 fb 54 31 11 80    	cmp    $0x80113154,%ebx
8010268f:	72 e1                	jb     80102672 <iget+0x42>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80102698:	85 f6                	test   %esi,%esi
8010269a:	74 79                	je     80102715 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010269c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010269f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801026a1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801026a4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801026ab:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801026b2:	68 00 15 11 80       	push   $0x80111500
801026b7:	e8 64 31 00 00       	call   80105820 <release>

  return ip;
801026bc:	83 c4 10             	add    $0x10,%esp
}
801026bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026c2:	89 f0                	mov    %esi,%eax
801026c4:	5b                   	pop    %ebx
801026c5:	5e                   	pop    %esi
801026c6:	5f                   	pop    %edi
801026c7:	5d                   	pop    %ebp
801026c8:	c3                   	ret    
801026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801026d0:	39 53 04             	cmp    %edx,0x4(%ebx)
801026d3:	75 8f                	jne    80102664 <iget+0x34>
      release(&icache.lock);
801026d5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801026d8:	83 c0 01             	add    $0x1,%eax
      return ip;
801026db:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801026dd:	68 00 15 11 80       	push   $0x80111500
      ip->ref++;
801026e2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801026e5:	e8 36 31 00 00       	call   80105820 <release>
      return ip;
801026ea:	83 c4 10             	add    $0x10,%esp
}
801026ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026f0:	89 f0                	mov    %esi,%eax
801026f2:	5b                   	pop    %ebx
801026f3:	5e                   	pop    %esi
801026f4:	5f                   	pop    %edi
801026f5:	5d                   	pop    %ebp
801026f6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801026f7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801026fd:	81 fb 54 31 11 80    	cmp    $0x80113154,%ebx
80102703:	73 10                	jae    80102715 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102705:	8b 43 08             	mov    0x8(%ebx),%eax
80102708:	85 c0                	test   %eax,%eax
8010270a:	0f 8f 50 ff ff ff    	jg     80102660 <iget+0x30>
80102710:	e9 68 ff ff ff       	jmp    8010267d <iget+0x4d>
    panic("iget: no inodes");
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	68 a8 85 10 80       	push   $0x801085a8
8010271d:	e8 3e dd ff ff       	call   80100460 <panic>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102730 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	57                   	push   %edi
80102734:	56                   	push   %esi
80102735:	89 c6                	mov    %eax,%esi
80102737:	53                   	push   %ebx
80102738:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010273b:	83 fa 0b             	cmp    $0xb,%edx
8010273e:	0f 86 8c 00 00 00    	jbe    801027d0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80102744:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80102747:	83 fb 7f             	cmp    $0x7f,%ebx
8010274a:	0f 87 a2 00 00 00    	ja     801027f2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102750:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102756:	85 c0                	test   %eax,%eax
80102758:	74 5e                	je     801027b8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010275a:	83 ec 08             	sub    $0x8,%esp
8010275d:	50                   	push   %eax
8010275e:	ff 36                	push   (%esi)
80102760:	e8 6b d9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80102765:	83 c4 10             	add    $0x10,%esp
80102768:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010276c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010276e:	8b 3b                	mov    (%ebx),%edi
80102770:	85 ff                	test   %edi,%edi
80102772:	74 1c                	je     80102790 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80102774:	83 ec 0c             	sub    $0xc,%esp
80102777:	52                   	push   %edx
80102778:	e8 73 da ff ff       	call   801001f0 <brelse>
8010277d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80102780:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102783:	89 f8                	mov    %edi,%eax
80102785:	5b                   	pop    %ebx
80102786:	5e                   	pop    %esi
80102787:	5f                   	pop    %edi
80102788:	5d                   	pop    %ebp
80102789:	c3                   	ret    
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80102793:	8b 06                	mov    (%esi),%eax
80102795:	e8 86 fd ff ff       	call   80102520 <balloc>
      log_write(bp);
8010279a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010279d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801027a0:	89 03                	mov    %eax,(%ebx)
801027a2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801027a4:	52                   	push   %edx
801027a5:	e8 76 1a 00 00       	call   80104220 <log_write>
801027aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	eb c2                	jmp    80102774 <bmap+0x44>
801027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801027b8:	8b 06                	mov    (%esi),%eax
801027ba:	e8 61 fd ff ff       	call   80102520 <balloc>
801027bf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801027c5:	eb 93                	jmp    8010275a <bmap+0x2a>
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801027d0:	8d 5a 14             	lea    0x14(%edx),%ebx
801027d3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801027d7:	85 ff                	test   %edi,%edi
801027d9:	75 a5                	jne    80102780 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801027db:	8b 00                	mov    (%eax),%eax
801027dd:	e8 3e fd ff ff       	call   80102520 <balloc>
801027e2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801027e6:	89 c7                	mov    %eax,%edi
}
801027e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027eb:	5b                   	pop    %ebx
801027ec:	89 f8                	mov    %edi,%eax
801027ee:	5e                   	pop    %esi
801027ef:	5f                   	pop    %edi
801027f0:	5d                   	pop    %ebp
801027f1:	c3                   	ret    
  panic("bmap: out of range");
801027f2:	83 ec 0c             	sub    $0xc,%esp
801027f5:	68 b8 85 10 80       	push   $0x801085b8
801027fa:	e8 61 dc ff ff       	call   80100460 <panic>
801027ff:	90                   	nop

80102800 <readsb>:
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
80102804:	53                   	push   %ebx
80102805:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102808:	83 ec 08             	sub    $0x8,%esp
8010280b:	6a 01                	push   $0x1
8010280d:	ff 75 08             	push   0x8(%ebp)
80102810:	e8 bb d8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102815:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102818:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010281a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010281d:	6a 1c                	push   $0x1c
8010281f:	50                   	push   %eax
80102820:	56                   	push   %esi
80102821:	e8 ba 31 00 00       	call   801059e0 <memmove>
  brelse(bp);
80102826:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102829:	83 c4 10             	add    $0x10,%esp
}
8010282c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010282f:	5b                   	pop    %ebx
80102830:	5e                   	pop    %esi
80102831:	5d                   	pop    %ebp
  brelse(bp);
80102832:	e9 b9 d9 ff ff       	jmp    801001f0 <brelse>
80102837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283e:	66 90                	xchg   %ax,%ax

80102840 <iinit>:
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	53                   	push   %ebx
80102844:	bb 40 15 11 80       	mov    $0x80111540,%ebx
80102849:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010284c:	68 cb 85 10 80       	push   $0x801085cb
80102851:	68 00 15 11 80       	push   $0x80111500
80102856:	e8 55 2e 00 00       	call   801056b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010285b:	83 c4 10             	add    $0x10,%esp
8010285e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	68 d2 85 10 80       	push   $0x801085d2
80102868:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102869:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010286f:	e8 0c 2d 00 00       	call   80105580 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80102874:	83 c4 10             	add    $0x10,%esp
80102877:	81 fb 60 31 11 80    	cmp    $0x80113160,%ebx
8010287d:	75 e1                	jne    80102860 <iinit+0x20>
  bp = bread(dev, 1);
8010287f:	83 ec 08             	sub    $0x8,%esp
80102882:	6a 01                	push   $0x1
80102884:	ff 75 08             	push   0x8(%ebp)
80102887:	e8 44 d8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010288c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010288f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80102891:	8d 40 5c             	lea    0x5c(%eax),%eax
80102894:	6a 1c                	push   $0x1c
80102896:	50                   	push   %eax
80102897:	68 54 31 11 80       	push   $0x80113154
8010289c:	e8 3f 31 00 00       	call   801059e0 <memmove>
  brelse(bp);
801028a1:	89 1c 24             	mov    %ebx,(%esp)
801028a4:	e8 47 d9 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801028a9:	ff 35 6c 31 11 80    	push   0x8011316c
801028af:	ff 35 68 31 11 80    	push   0x80113168
801028b5:	ff 35 64 31 11 80    	push   0x80113164
801028bb:	ff 35 60 31 11 80    	push   0x80113160
801028c1:	ff 35 5c 31 11 80    	push   0x8011315c
801028c7:	ff 35 58 31 11 80    	push   0x80113158
801028cd:	ff 35 54 31 11 80    	push   0x80113154
801028d3:	68 38 86 10 80       	push   $0x80108638
801028d8:	e8 03 df ff ff       	call   801007e0 <cprintf>
}
801028dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e0:	83 c4 30             	add    $0x30,%esp
801028e3:	c9                   	leave  
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <ialloc>:
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	57                   	push   %edi
801028f4:	56                   	push   %esi
801028f5:	53                   	push   %ebx
801028f6:	83 ec 1c             	sub    $0x1c,%esp
801028f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801028fc:	83 3d 5c 31 11 80 01 	cmpl   $0x1,0x8011315c
{
80102903:	8b 75 08             	mov    0x8(%ebp),%esi
80102906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102909:	0f 86 91 00 00 00    	jbe    801029a0 <ialloc+0xb0>
8010290f:	bf 01 00 00 00       	mov    $0x1,%edi
80102914:	eb 21                	jmp    80102937 <ialloc+0x47>
80102916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102920:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102923:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102926:	53                   	push   %ebx
80102927:	e8 c4 d8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010292c:	83 c4 10             	add    $0x10,%esp
8010292f:	3b 3d 5c 31 11 80    	cmp    0x8011315c,%edi
80102935:	73 69                	jae    801029a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102937:	89 f8                	mov    %edi,%eax
80102939:	83 ec 08             	sub    $0x8,%esp
8010293c:	c1 e8 03             	shr    $0x3,%eax
8010293f:	03 05 68 31 11 80    	add    0x80113168,%eax
80102945:	50                   	push   %eax
80102946:	56                   	push   %esi
80102947:	e8 84 d7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010294c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010294f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102951:	89 f8                	mov    %edi,%eax
80102953:	83 e0 07             	and    $0x7,%eax
80102956:	c1 e0 06             	shl    $0x6,%eax
80102959:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010295d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102961:	75 bd                	jne    80102920 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102963:	83 ec 04             	sub    $0x4,%esp
80102966:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102969:	6a 40                	push   $0x40
8010296b:	6a 00                	push   $0x0
8010296d:	51                   	push   %ecx
8010296e:	e8 cd 2f 00 00       	call   80105940 <memset>
      dip->type = type;
80102973:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102977:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010297a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010297d:	89 1c 24             	mov    %ebx,(%esp)
80102980:	e8 9b 18 00 00       	call   80104220 <log_write>
      brelse(bp);
80102985:	89 1c 24             	mov    %ebx,(%esp)
80102988:	e8 63 d8 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010298d:	83 c4 10             	add    $0x10,%esp
}
80102990:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102993:	89 fa                	mov    %edi,%edx
}
80102995:	5b                   	pop    %ebx
      return iget(dev, inum);
80102996:	89 f0                	mov    %esi,%eax
}
80102998:	5e                   	pop    %esi
80102999:	5f                   	pop    %edi
8010299a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010299b:	e9 90 fc ff ff       	jmp    80102630 <iget>
  panic("ialloc: no inodes");
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	68 d8 85 10 80       	push   $0x801085d8
801029a8:	e8 b3 da ff ff       	call   80100460 <panic>
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <iupdate>:
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	56                   	push   %esi
801029b4:	53                   	push   %ebx
801029b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801029b8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801029bb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801029be:	83 ec 08             	sub    $0x8,%esp
801029c1:	c1 e8 03             	shr    $0x3,%eax
801029c4:	03 05 68 31 11 80    	add    0x80113168,%eax
801029ca:	50                   	push   %eax
801029cb:	ff 73 a4             	push   -0x5c(%ebx)
801029ce:	e8 fd d6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801029d3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801029d7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801029da:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801029dc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801029df:	83 e0 07             	and    $0x7,%eax
801029e2:	c1 e0 06             	shl    $0x6,%eax
801029e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801029e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801029ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801029f0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801029f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801029f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801029fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801029ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102a03:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102a07:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102a0a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a0d:	6a 34                	push   $0x34
80102a0f:	53                   	push   %ebx
80102a10:	50                   	push   %eax
80102a11:	e8 ca 2f 00 00       	call   801059e0 <memmove>
  log_write(bp);
80102a16:	89 34 24             	mov    %esi,(%esp)
80102a19:	e8 02 18 00 00       	call   80104220 <log_write>
  brelse(bp);
80102a1e:	89 75 08             	mov    %esi,0x8(%ebp)
80102a21:	83 c4 10             	add    $0x10,%esp
}
80102a24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a27:	5b                   	pop    %ebx
80102a28:	5e                   	pop    %esi
80102a29:	5d                   	pop    %ebp
  brelse(bp);
80102a2a:	e9 c1 d7 ff ff       	jmp    801001f0 <brelse>
80102a2f:	90                   	nop

80102a30 <idup>:
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	53                   	push   %ebx
80102a34:	83 ec 10             	sub    $0x10,%esp
80102a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102a3a:	68 00 15 11 80       	push   $0x80111500
80102a3f:	e8 3c 2e 00 00       	call   80105880 <acquire>
  ip->ref++;
80102a44:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102a48:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
80102a4f:	e8 cc 2d 00 00       	call   80105820 <release>
}
80102a54:	89 d8                	mov    %ebx,%eax
80102a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a59:	c9                   	leave  
80102a5a:	c3                   	ret    
80102a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a5f:	90                   	nop

80102a60 <ilock>:
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
80102a64:	53                   	push   %ebx
80102a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102a68:	85 db                	test   %ebx,%ebx
80102a6a:	0f 84 b7 00 00 00    	je     80102b27 <ilock+0xc7>
80102a70:	8b 53 08             	mov    0x8(%ebx),%edx
80102a73:	85 d2                	test   %edx,%edx
80102a75:	0f 8e ac 00 00 00    	jle    80102b27 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102a7b:	83 ec 0c             	sub    $0xc,%esp
80102a7e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102a81:	50                   	push   %eax
80102a82:	e8 39 2b 00 00       	call   801055c0 <acquiresleep>
  if(ip->valid == 0){
80102a87:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102a8a:	83 c4 10             	add    $0x10,%esp
80102a8d:	85 c0                	test   %eax,%eax
80102a8f:	74 0f                	je     80102aa0 <ilock+0x40>
}
80102a91:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a94:	5b                   	pop    %ebx
80102a95:	5e                   	pop    %esi
80102a96:	5d                   	pop    %ebp
80102a97:	c3                   	ret    
80102a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102aa0:	8b 43 04             	mov    0x4(%ebx),%eax
80102aa3:	83 ec 08             	sub    $0x8,%esp
80102aa6:	c1 e8 03             	shr    $0x3,%eax
80102aa9:	03 05 68 31 11 80    	add    0x80113168,%eax
80102aaf:	50                   	push   %eax
80102ab0:	ff 33                	push   (%ebx)
80102ab2:	e8 19 d6 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102ab7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102aba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102abc:	8b 43 04             	mov    0x4(%ebx),%eax
80102abf:	83 e0 07             	and    $0x7,%eax
80102ac2:	c1 e0 06             	shl    $0x6,%eax
80102ac5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102ac9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102acc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102acf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102ad3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102ad7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102adb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102adf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102ae3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102ae7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102aeb:	8b 50 fc             	mov    -0x4(%eax),%edx
80102aee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102af1:	6a 34                	push   $0x34
80102af3:	50                   	push   %eax
80102af4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102af7:	50                   	push   %eax
80102af8:	e8 e3 2e 00 00       	call   801059e0 <memmove>
    brelse(bp);
80102afd:	89 34 24             	mov    %esi,(%esp)
80102b00:	e8 eb d6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102b05:	83 c4 10             	add    $0x10,%esp
80102b08:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102b0d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102b14:	0f 85 77 ff ff ff    	jne    80102a91 <ilock+0x31>
      panic("ilock: no type");
80102b1a:	83 ec 0c             	sub    $0xc,%esp
80102b1d:	68 f0 85 10 80       	push   $0x801085f0
80102b22:	e8 39 d9 ff ff       	call   80100460 <panic>
    panic("ilock");
80102b27:	83 ec 0c             	sub    $0xc,%esp
80102b2a:	68 ea 85 10 80       	push   $0x801085ea
80102b2f:	e8 2c d9 ff ff       	call   80100460 <panic>
80102b34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b3f:	90                   	nop

80102b40 <iunlock>:
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	56                   	push   %esi
80102b44:	53                   	push   %ebx
80102b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102b48:	85 db                	test   %ebx,%ebx
80102b4a:	74 28                	je     80102b74 <iunlock+0x34>
80102b4c:	83 ec 0c             	sub    $0xc,%esp
80102b4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102b52:	56                   	push   %esi
80102b53:	e8 08 2b 00 00       	call   80105660 <holdingsleep>
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 c0                	test   %eax,%eax
80102b5d:	74 15                	je     80102b74 <iunlock+0x34>
80102b5f:	8b 43 08             	mov    0x8(%ebx),%eax
80102b62:	85 c0                	test   %eax,%eax
80102b64:	7e 0e                	jle    80102b74 <iunlock+0x34>
  releasesleep(&ip->lock);
80102b66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102b69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b6c:	5b                   	pop    %ebx
80102b6d:	5e                   	pop    %esi
80102b6e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102b6f:	e9 ac 2a 00 00       	jmp    80105620 <releasesleep>
    panic("iunlock");
80102b74:	83 ec 0c             	sub    $0xc,%esp
80102b77:	68 ff 85 10 80       	push   $0x801085ff
80102b7c:	e8 df d8 ff ff       	call   80100460 <panic>
80102b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b8f:	90                   	nop

80102b90 <iput>:
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 28             	sub    $0x28,%esp
80102b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102b9c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102b9f:	57                   	push   %edi
80102ba0:	e8 1b 2a 00 00       	call   801055c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102ba5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102ba8:	83 c4 10             	add    $0x10,%esp
80102bab:	85 d2                	test   %edx,%edx
80102bad:	74 07                	je     80102bb6 <iput+0x26>
80102baf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102bb4:	74 32                	je     80102be8 <iput+0x58>
  releasesleep(&ip->lock);
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	57                   	push   %edi
80102bba:	e8 61 2a 00 00       	call   80105620 <releasesleep>
  acquire(&icache.lock);
80102bbf:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
80102bc6:	e8 b5 2c 00 00       	call   80105880 <acquire>
  ip->ref--;
80102bcb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102bcf:	83 c4 10             	add    $0x10,%esp
80102bd2:	c7 45 08 00 15 11 80 	movl   $0x80111500,0x8(%ebp)
}
80102bd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdc:	5b                   	pop    %ebx
80102bdd:	5e                   	pop    %esi
80102bde:	5f                   	pop    %edi
80102bdf:	5d                   	pop    %ebp
  release(&icache.lock);
80102be0:	e9 3b 2c 00 00       	jmp    80105820 <release>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102be8:	83 ec 0c             	sub    $0xc,%esp
80102beb:	68 00 15 11 80       	push   $0x80111500
80102bf0:	e8 8b 2c 00 00       	call   80105880 <acquire>
    int r = ip->ref;
80102bf5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102bf8:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
80102bff:	e8 1c 2c 00 00       	call   80105820 <release>
    if(r == 1){
80102c04:	83 c4 10             	add    $0x10,%esp
80102c07:	83 fe 01             	cmp    $0x1,%esi
80102c0a:	75 aa                	jne    80102bb6 <iput+0x26>
80102c0c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102c12:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102c15:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102c18:	89 cf                	mov    %ecx,%edi
80102c1a:	eb 0b                	jmp    80102c27 <iput+0x97>
80102c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102c20:	83 c6 04             	add    $0x4,%esi
80102c23:	39 fe                	cmp    %edi,%esi
80102c25:	74 19                	je     80102c40 <iput+0xb0>
    if(ip->addrs[i]){
80102c27:	8b 16                	mov    (%esi),%edx
80102c29:	85 d2                	test   %edx,%edx
80102c2b:	74 f3                	je     80102c20 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102c2d:	8b 03                	mov    (%ebx),%eax
80102c2f:	e8 6c f8 ff ff       	call   801024a0 <bfree>
      ip->addrs[i] = 0;
80102c34:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102c3a:	eb e4                	jmp    80102c20 <iput+0x90>
80102c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102c40:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102c46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	75 2d                	jne    80102c7a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102c4d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102c50:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102c57:	53                   	push   %ebx
80102c58:	e8 53 fd ff ff       	call   801029b0 <iupdate>
      ip->type = 0;
80102c5d:	31 c0                	xor    %eax,%eax
80102c5f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102c63:	89 1c 24             	mov    %ebx,(%esp)
80102c66:	e8 45 fd ff ff       	call   801029b0 <iupdate>
      ip->valid = 0;
80102c6b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102c72:	83 c4 10             	add    $0x10,%esp
80102c75:	e9 3c ff ff ff       	jmp    80102bb6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102c7a:	83 ec 08             	sub    $0x8,%esp
80102c7d:	50                   	push   %eax
80102c7e:	ff 33                	push   (%ebx)
80102c80:	e8 4b d4 ff ff       	call   801000d0 <bread>
80102c85:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102c88:	83 c4 10             	add    $0x10,%esp
80102c8b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102c94:	8d 70 5c             	lea    0x5c(%eax),%esi
80102c97:	89 cf                	mov    %ecx,%edi
80102c99:	eb 0c                	jmp    80102ca7 <iput+0x117>
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
80102ca0:	83 c6 04             	add    $0x4,%esi
80102ca3:	39 f7                	cmp    %esi,%edi
80102ca5:	74 0f                	je     80102cb6 <iput+0x126>
      if(a[j])
80102ca7:	8b 16                	mov    (%esi),%edx
80102ca9:	85 d2                	test   %edx,%edx
80102cab:	74 f3                	je     80102ca0 <iput+0x110>
        bfree(ip->dev, a[j]);
80102cad:	8b 03                	mov    (%ebx),%eax
80102caf:	e8 ec f7 ff ff       	call   801024a0 <bfree>
80102cb4:	eb ea                	jmp    80102ca0 <iput+0x110>
    brelse(bp);
80102cb6:	83 ec 0c             	sub    $0xc,%esp
80102cb9:	ff 75 e4             	push   -0x1c(%ebp)
80102cbc:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102cbf:	e8 2c d5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102cc4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102cca:	8b 03                	mov    (%ebx),%eax
80102ccc:	e8 cf f7 ff ff       	call   801024a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80102cd1:	83 c4 10             	add    $0x10,%esp
80102cd4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102cdb:	00 00 00 
80102cde:	e9 6a ff ff ff       	jmp    80102c4d <iput+0xbd>
80102ce3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102cf0 <iunlockput>:
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	56                   	push   %esi
80102cf4:	53                   	push   %ebx
80102cf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102cf8:	85 db                	test   %ebx,%ebx
80102cfa:	74 34                	je     80102d30 <iunlockput+0x40>
80102cfc:	83 ec 0c             	sub    $0xc,%esp
80102cff:	8d 73 0c             	lea    0xc(%ebx),%esi
80102d02:	56                   	push   %esi
80102d03:	e8 58 29 00 00       	call   80105660 <holdingsleep>
80102d08:	83 c4 10             	add    $0x10,%esp
80102d0b:	85 c0                	test   %eax,%eax
80102d0d:	74 21                	je     80102d30 <iunlockput+0x40>
80102d0f:	8b 43 08             	mov    0x8(%ebx),%eax
80102d12:	85 c0                	test   %eax,%eax
80102d14:	7e 1a                	jle    80102d30 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102d16:	83 ec 0c             	sub    $0xc,%esp
80102d19:	56                   	push   %esi
80102d1a:	e8 01 29 00 00       	call   80105620 <releasesleep>
  iput(ip);
80102d1f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102d22:	83 c4 10             	add    $0x10,%esp
}
80102d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d28:	5b                   	pop    %ebx
80102d29:	5e                   	pop    %esi
80102d2a:	5d                   	pop    %ebp
  iput(ip);
80102d2b:	e9 60 fe ff ff       	jmp    80102b90 <iput>
    panic("iunlock");
80102d30:	83 ec 0c             	sub    $0xc,%esp
80102d33:	68 ff 85 10 80       	push   $0x801085ff
80102d38:	e8 23 d7 ff ff       	call   80100460 <panic>
80102d3d:	8d 76 00             	lea    0x0(%esi),%esi

80102d40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	8b 55 08             	mov    0x8(%ebp),%edx
80102d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102d49:	8b 0a                	mov    (%edx),%ecx
80102d4b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102d4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102d51:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102d54:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102d58:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102d5b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102d5f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102d63:	8b 52 58             	mov    0x58(%edx),%edx
80102d66:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d69:	5d                   	pop    %ebp
80102d6a:	c3                   	ret    
80102d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop

80102d70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	57                   	push   %edi
80102d74:	56                   	push   %esi
80102d75:	53                   	push   %ebx
80102d76:	83 ec 1c             	sub    $0x1c,%esp
80102d79:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d7f:	8b 75 10             	mov    0x10(%ebp),%esi
80102d82:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102d85:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102d88:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102d8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102d93:	0f 84 a7 00 00 00    	je     80102e40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102d99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d9c:	8b 40 58             	mov    0x58(%eax),%eax
80102d9f:	39 c6                	cmp    %eax,%esi
80102da1:	0f 87 ba 00 00 00    	ja     80102e61 <readi+0xf1>
80102da7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102daa:	31 c9                	xor    %ecx,%ecx
80102dac:	89 da                	mov    %ebx,%edx
80102dae:	01 f2                	add    %esi,%edx
80102db0:	0f 92 c1             	setb   %cl
80102db3:	89 cf                	mov    %ecx,%edi
80102db5:	0f 82 a6 00 00 00    	jb     80102e61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102dbb:	89 c1                	mov    %eax,%ecx
80102dbd:	29 f1                	sub    %esi,%ecx
80102dbf:	39 d0                	cmp    %edx,%eax
80102dc1:	0f 43 cb             	cmovae %ebx,%ecx
80102dc4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102dc7:	85 c9                	test   %ecx,%ecx
80102dc9:	74 67                	je     80102e32 <readi+0xc2>
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102dd0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102dd3:	89 f2                	mov    %esi,%edx
80102dd5:	c1 ea 09             	shr    $0x9,%edx
80102dd8:	89 d8                	mov    %ebx,%eax
80102dda:	e8 51 f9 ff ff       	call   80102730 <bmap>
80102ddf:	83 ec 08             	sub    $0x8,%esp
80102de2:	50                   	push   %eax
80102de3:	ff 33                	push   (%ebx)
80102de5:	e8 e6 d2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102dea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102ded:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102df2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102df4:	89 f0                	mov    %esi,%eax
80102df6:	25 ff 01 00 00       	and    $0x1ff,%eax
80102dfb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102dfd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102e00:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102e02:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102e06:	39 d9                	cmp    %ebx,%ecx
80102e08:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102e0b:	83 c4 0c             	add    $0xc,%esp
80102e0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102e0f:	01 df                	add    %ebx,%edi
80102e11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102e13:	50                   	push   %eax
80102e14:	ff 75 e0             	push   -0x20(%ebp)
80102e17:	e8 c4 2b 00 00       	call   801059e0 <memmove>
    brelse(bp);
80102e1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102e1f:	89 14 24             	mov    %edx,(%esp)
80102e22:	e8 c9 d3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102e27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102e2a:	83 c4 10             	add    $0x10,%esp
80102e2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102e30:	77 9e                	ja     80102dd0 <readi+0x60>
  }
  return n;
80102e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e38:	5b                   	pop    %ebx
80102e39:	5e                   	pop    %esi
80102e3a:	5f                   	pop    %edi
80102e3b:	5d                   	pop    %ebp
80102e3c:	c3                   	ret    
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102e40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102e44:	66 83 f8 09          	cmp    $0x9,%ax
80102e48:	77 17                	ja     80102e61 <readi+0xf1>
80102e4a:	8b 04 c5 a0 14 11 80 	mov    -0x7feeeb60(,%eax,8),%eax
80102e51:	85 c0                	test   %eax,%eax
80102e53:	74 0c                	je     80102e61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102e55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5b:	5b                   	pop    %ebx
80102e5c:	5e                   	pop    %esi
80102e5d:	5f                   	pop    %edi
80102e5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102e5f:	ff e0                	jmp    *%eax
      return -1;
80102e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e66:	eb cd                	jmp    80102e35 <readi+0xc5>
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	57                   	push   %edi
80102e74:	56                   	push   %esi
80102e75:	53                   	push   %ebx
80102e76:	83 ec 1c             	sub    $0x1c,%esp
80102e79:	8b 45 08             	mov    0x8(%ebp),%eax
80102e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e7f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102e82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102e87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80102e8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e8d:	8b 75 10             	mov    0x10(%ebp),%esi
80102e90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102e93:	0f 84 b7 00 00 00    	je     80102f50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102e99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102e9c:	3b 70 58             	cmp    0x58(%eax),%esi
80102e9f:	0f 87 e7 00 00 00    	ja     80102f8c <writei+0x11c>
80102ea5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102ea8:	31 d2                	xor    %edx,%edx
80102eaa:	89 f8                	mov    %edi,%eax
80102eac:	01 f0                	add    %esi,%eax
80102eae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102eb1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102eb6:	0f 87 d0 00 00 00    	ja     80102f8c <writei+0x11c>
80102ebc:	85 d2                	test   %edx,%edx
80102ebe:	0f 85 c8 00 00 00    	jne    80102f8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102ec4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102ecb:	85 ff                	test   %edi,%edi
80102ecd:	74 72                	je     80102f41 <writei+0xd1>
80102ecf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102ed0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102ed3:	89 f2                	mov    %esi,%edx
80102ed5:	c1 ea 09             	shr    $0x9,%edx
80102ed8:	89 f8                	mov    %edi,%eax
80102eda:	e8 51 f8 ff ff       	call   80102730 <bmap>
80102edf:	83 ec 08             	sub    $0x8,%esp
80102ee2:	50                   	push   %eax
80102ee3:	ff 37                	push   (%edi)
80102ee5:	e8 e6 d1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102eea:	b9 00 02 00 00       	mov    $0x200,%ecx
80102eef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102ef2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102ef5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102ef7:	89 f0                	mov    %esi,%eax
80102ef9:	25 ff 01 00 00       	and    $0x1ff,%eax
80102efe:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102f00:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102f04:	39 d9                	cmp    %ebx,%ecx
80102f06:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102f09:	83 c4 0c             	add    $0xc,%esp
80102f0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102f0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80102f0f:	ff 75 dc             	push   -0x24(%ebp)
80102f12:	50                   	push   %eax
80102f13:	e8 c8 2a 00 00       	call   801059e0 <memmove>
    log_write(bp);
80102f18:	89 3c 24             	mov    %edi,(%esp)
80102f1b:	e8 00 13 00 00       	call   80104220 <log_write>
    brelse(bp);
80102f20:	89 3c 24             	mov    %edi,(%esp)
80102f23:	e8 c8 d2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102f28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80102f2b:	83 c4 10             	add    $0x10,%esp
80102f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102f34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102f37:	77 97                	ja     80102ed0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102f39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102f3c:	3b 70 58             	cmp    0x58(%eax),%esi
80102f3f:	77 37                	ja     80102f78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f47:	5b                   	pop    %ebx
80102f48:	5e                   	pop    %esi
80102f49:	5f                   	pop    %edi
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    
80102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102f50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102f54:	66 83 f8 09          	cmp    $0x9,%ax
80102f58:	77 32                	ja     80102f8c <writei+0x11c>
80102f5a:	8b 04 c5 a4 14 11 80 	mov    -0x7feeeb5c(,%eax,8),%eax
80102f61:	85 c0                	test   %eax,%eax
80102f63:	74 27                	je     80102f8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102f65:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6b:	5b                   	pop    %ebx
80102f6c:	5e                   	pop    %esi
80102f6d:	5f                   	pop    %edi
80102f6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80102f6f:	ff e0                	jmp    *%eax
80102f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102f78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80102f7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80102f7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102f81:	50                   	push   %eax
80102f82:	e8 29 fa ff ff       	call   801029b0 <iupdate>
80102f87:	83 c4 10             	add    $0x10,%esp
80102f8a:	eb b5                	jmp    80102f41 <writei+0xd1>
      return -1;
80102f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f91:	eb b1                	jmp    80102f44 <writei+0xd4>
80102f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102fa0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102fa6:	6a 0e                	push   $0xe
80102fa8:	ff 75 0c             	push   0xc(%ebp)
80102fab:	ff 75 08             	push   0x8(%ebp)
80102fae:	e8 9d 2a 00 00       	call   80105a50 <strncmp>
}
80102fb3:	c9                   	leave  
80102fb4:	c3                   	ret    
80102fb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	53                   	push   %ebx
80102fc6:	83 ec 1c             	sub    $0x1c,%esp
80102fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102fcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102fd1:	0f 85 85 00 00 00    	jne    8010305c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102fd7:	8b 53 58             	mov    0x58(%ebx),%edx
80102fda:	31 ff                	xor    %edi,%edi
80102fdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102fdf:	85 d2                	test   %edx,%edx
80102fe1:	74 3e                	je     80103021 <dirlookup+0x61>
80102fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fe7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102fe8:	6a 10                	push   $0x10
80102fea:	57                   	push   %edi
80102feb:	56                   	push   %esi
80102fec:	53                   	push   %ebx
80102fed:	e8 7e fd ff ff       	call   80102d70 <readi>
80102ff2:	83 c4 10             	add    $0x10,%esp
80102ff5:	83 f8 10             	cmp    $0x10,%eax
80102ff8:	75 55                	jne    8010304f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80102ffa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102fff:	74 18                	je     80103019 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103001:	83 ec 04             	sub    $0x4,%esp
80103004:	8d 45 da             	lea    -0x26(%ebp),%eax
80103007:	6a 0e                	push   $0xe
80103009:	50                   	push   %eax
8010300a:	ff 75 0c             	push   0xc(%ebp)
8010300d:	e8 3e 2a 00 00       	call   80105a50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103012:	83 c4 10             	add    $0x10,%esp
80103015:	85 c0                	test   %eax,%eax
80103017:	74 17                	je     80103030 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103019:	83 c7 10             	add    $0x10,%edi
8010301c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010301f:	72 c7                	jb     80102fe8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103024:	31 c0                	xor    %eax,%eax
}
80103026:	5b                   	pop    %ebx
80103027:	5e                   	pop    %esi
80103028:	5f                   	pop    %edi
80103029:	5d                   	pop    %ebp
8010302a:	c3                   	ret    
8010302b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop
      if(poff)
80103030:	8b 45 10             	mov    0x10(%ebp),%eax
80103033:	85 c0                	test   %eax,%eax
80103035:	74 05                	je     8010303c <dirlookup+0x7c>
        *poff = off;
80103037:	8b 45 10             	mov    0x10(%ebp),%eax
8010303a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010303c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103040:	8b 03                	mov    (%ebx),%eax
80103042:	e8 e9 f5 ff ff       	call   80102630 <iget>
}
80103047:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304a:	5b                   	pop    %ebx
8010304b:	5e                   	pop    %esi
8010304c:	5f                   	pop    %edi
8010304d:	5d                   	pop    %ebp
8010304e:	c3                   	ret    
      panic("dirlookup read");
8010304f:	83 ec 0c             	sub    $0xc,%esp
80103052:	68 19 86 10 80       	push   $0x80108619
80103057:	e8 04 d4 ff ff       	call   80100460 <panic>
    panic("dirlookup not DIR");
8010305c:	83 ec 0c             	sub    $0xc,%esp
8010305f:	68 07 86 10 80       	push   $0x80108607
80103064:	e8 f7 d3 ff ff       	call   80100460 <panic>
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103070 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	89 c3                	mov    %eax,%ebx
80103078:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010307b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010307e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103081:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80103084:	0f 84 64 01 00 00    	je     801031ee <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010308a:	e8 c1 1b 00 00       	call   80104c50 <myproc>
  acquire(&icache.lock);
8010308f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103092:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103095:	68 00 15 11 80       	push   $0x80111500
8010309a:	e8 e1 27 00 00       	call   80105880 <acquire>
  ip->ref++;
8010309f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801030a3:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
801030aa:	e8 71 27 00 00       	call   80105820 <release>
801030af:	83 c4 10             	add    $0x10,%esp
801030b2:	eb 07                	jmp    801030bb <namex+0x4b>
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801030b8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801030bb:	0f b6 03             	movzbl (%ebx),%eax
801030be:	3c 2f                	cmp    $0x2f,%al
801030c0:	74 f6                	je     801030b8 <namex+0x48>
  if(*path == 0)
801030c2:	84 c0                	test   %al,%al
801030c4:	0f 84 06 01 00 00    	je     801031d0 <namex+0x160>
  while(*path != '/' && *path != 0)
801030ca:	0f b6 03             	movzbl (%ebx),%eax
801030cd:	84 c0                	test   %al,%al
801030cf:	0f 84 10 01 00 00    	je     801031e5 <namex+0x175>
801030d5:	89 df                	mov    %ebx,%edi
801030d7:	3c 2f                	cmp    $0x2f,%al
801030d9:	0f 84 06 01 00 00    	je     801031e5 <namex+0x175>
801030df:	90                   	nop
801030e0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801030e4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801030e7:	3c 2f                	cmp    $0x2f,%al
801030e9:	74 04                	je     801030ef <namex+0x7f>
801030eb:	84 c0                	test   %al,%al
801030ed:	75 f1                	jne    801030e0 <namex+0x70>
  len = path - s;
801030ef:	89 f8                	mov    %edi,%eax
801030f1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801030f3:	83 f8 0d             	cmp    $0xd,%eax
801030f6:	0f 8e ac 00 00 00    	jle    801031a8 <namex+0x138>
    memmove(name, s, DIRSIZ);
801030fc:	83 ec 04             	sub    $0x4,%esp
801030ff:	6a 0e                	push   $0xe
80103101:	53                   	push   %ebx
    path++;
80103102:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80103104:	ff 75 e4             	push   -0x1c(%ebp)
80103107:	e8 d4 28 00 00       	call   801059e0 <memmove>
8010310c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010310f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103112:	75 0c                	jne    80103120 <namex+0xb0>
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103118:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010311b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010311e:	74 f8                	je     80103118 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103120:	83 ec 0c             	sub    $0xc,%esp
80103123:	56                   	push   %esi
80103124:	e8 37 f9 ff ff       	call   80102a60 <ilock>
    if(ip->type != T_DIR){
80103129:	83 c4 10             	add    $0x10,%esp
8010312c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103131:	0f 85 cd 00 00 00    	jne    80103204 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103137:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010313a:	85 c0                	test   %eax,%eax
8010313c:	74 09                	je     80103147 <namex+0xd7>
8010313e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103141:	0f 84 22 01 00 00    	je     80103269 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103147:	83 ec 04             	sub    $0x4,%esp
8010314a:	6a 00                	push   $0x0
8010314c:	ff 75 e4             	push   -0x1c(%ebp)
8010314f:	56                   	push   %esi
80103150:	e8 6b fe ff ff       	call   80102fc0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103155:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80103158:	83 c4 10             	add    $0x10,%esp
8010315b:	89 c7                	mov    %eax,%edi
8010315d:	85 c0                	test   %eax,%eax
8010315f:	0f 84 e1 00 00 00    	je     80103246 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103165:	83 ec 0c             	sub    $0xc,%esp
80103168:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010316b:	52                   	push   %edx
8010316c:	e8 ef 24 00 00       	call   80105660 <holdingsleep>
80103171:	83 c4 10             	add    $0x10,%esp
80103174:	85 c0                	test   %eax,%eax
80103176:	0f 84 30 01 00 00    	je     801032ac <namex+0x23c>
8010317c:	8b 56 08             	mov    0x8(%esi),%edx
8010317f:	85 d2                	test   %edx,%edx
80103181:	0f 8e 25 01 00 00    	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103187:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010318a:	83 ec 0c             	sub    $0xc,%esp
8010318d:	52                   	push   %edx
8010318e:	e8 8d 24 00 00       	call   80105620 <releasesleep>
  iput(ip);
80103193:	89 34 24             	mov    %esi,(%esp)
80103196:	89 fe                	mov    %edi,%esi
80103198:	e8 f3 f9 ff ff       	call   80102b90 <iput>
8010319d:	83 c4 10             	add    $0x10,%esp
801031a0:	e9 16 ff ff ff       	jmp    801030bb <namex+0x4b>
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801031a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801031ab:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801031ae:	83 ec 04             	sub    $0x4,%esp
801031b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801031b4:	50                   	push   %eax
801031b5:	53                   	push   %ebx
    name[len] = 0;
801031b6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801031b8:	ff 75 e4             	push   -0x1c(%ebp)
801031bb:	e8 20 28 00 00       	call   801059e0 <memmove>
    name[len] = 0;
801031c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031c3:	83 c4 10             	add    $0x10,%esp
801031c6:	c6 02 00             	movb   $0x0,(%edx)
801031c9:	e9 41 ff ff ff       	jmp    8010310f <namex+0x9f>
801031ce:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031d3:	85 c0                	test   %eax,%eax
801031d5:	0f 85 be 00 00 00    	jne    80103299 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801031db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5b                   	pop    %ebx
801031e1:	5e                   	pop    %esi
801031e2:	5f                   	pop    %edi
801031e3:	5d                   	pop    %ebp
801031e4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801031e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031e8:	89 df                	mov    %ebx,%edi
801031ea:	31 c0                	xor    %eax,%eax
801031ec:	eb c0                	jmp    801031ae <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801031ee:	ba 01 00 00 00       	mov    $0x1,%edx
801031f3:	b8 01 00 00 00       	mov    $0x1,%eax
801031f8:	e8 33 f4 ff ff       	call   80102630 <iget>
801031fd:	89 c6                	mov    %eax,%esi
801031ff:	e9 b7 fe ff ff       	jmp    801030bb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103204:	83 ec 0c             	sub    $0xc,%esp
80103207:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010320a:	53                   	push   %ebx
8010320b:	e8 50 24 00 00       	call   80105660 <holdingsleep>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	85 c0                	test   %eax,%eax
80103215:	0f 84 91 00 00 00    	je     801032ac <namex+0x23c>
8010321b:	8b 46 08             	mov    0x8(%esi),%eax
8010321e:	85 c0                	test   %eax,%eax
80103220:	0f 8e 86 00 00 00    	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	53                   	push   %ebx
8010322a:	e8 f1 23 00 00       	call   80105620 <releasesleep>
  iput(ip);
8010322f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103232:	31 f6                	xor    %esi,%esi
  iput(ip);
80103234:	e8 57 f9 ff ff       	call   80102b90 <iput>
      return 0;
80103239:	83 c4 10             	add    $0x10,%esp
}
8010323c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323f:	89 f0                	mov    %esi,%eax
80103241:	5b                   	pop    %ebx
80103242:	5e                   	pop    %esi
80103243:	5f                   	pop    %edi
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010324c:	52                   	push   %edx
8010324d:	e8 0e 24 00 00       	call   80105660 <holdingsleep>
80103252:	83 c4 10             	add    $0x10,%esp
80103255:	85 c0                	test   %eax,%eax
80103257:	74 53                	je     801032ac <namex+0x23c>
80103259:	8b 4e 08             	mov    0x8(%esi),%ecx
8010325c:	85 c9                	test   %ecx,%ecx
8010325e:	7e 4c                	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103263:	83 ec 0c             	sub    $0xc,%esp
80103266:	52                   	push   %edx
80103267:	eb c1                	jmp    8010322a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103269:	83 ec 0c             	sub    $0xc,%esp
8010326c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010326f:	53                   	push   %ebx
80103270:	e8 eb 23 00 00       	call   80105660 <holdingsleep>
80103275:	83 c4 10             	add    $0x10,%esp
80103278:	85 c0                	test   %eax,%eax
8010327a:	74 30                	je     801032ac <namex+0x23c>
8010327c:	8b 7e 08             	mov    0x8(%esi),%edi
8010327f:	85 ff                	test   %edi,%edi
80103281:	7e 29                	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	53                   	push   %ebx
80103287:	e8 94 23 00 00       	call   80105620 <releasesleep>
}
8010328c:	83 c4 10             	add    $0x10,%esp
}
8010328f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103292:	89 f0                	mov    %esi,%eax
80103294:	5b                   	pop    %ebx
80103295:	5e                   	pop    %esi
80103296:	5f                   	pop    %edi
80103297:	5d                   	pop    %ebp
80103298:	c3                   	ret    
    iput(ip);
80103299:	83 ec 0c             	sub    $0xc,%esp
8010329c:	56                   	push   %esi
    return 0;
8010329d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010329f:	e8 ec f8 ff ff       	call   80102b90 <iput>
    return 0;
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	e9 2f ff ff ff       	jmp    801031db <namex+0x16b>
    panic("iunlock");
801032ac:	83 ec 0c             	sub    $0xc,%esp
801032af:	68 ff 85 10 80       	push   $0x801085ff
801032b4:	e8 a7 d1 ff ff       	call   80100460 <panic>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032c0 <dirlink>:
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 20             	sub    $0x20,%esp
801032c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801032cc:	6a 00                	push   $0x0
801032ce:	ff 75 0c             	push   0xc(%ebp)
801032d1:	53                   	push   %ebx
801032d2:	e8 e9 fc ff ff       	call   80102fc0 <dirlookup>
801032d7:	83 c4 10             	add    $0x10,%esp
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 67                	jne    80103345 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801032de:	8b 7b 58             	mov    0x58(%ebx),%edi
801032e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801032e4:	85 ff                	test   %edi,%edi
801032e6:	74 29                	je     80103311 <dirlink+0x51>
801032e8:	31 ff                	xor    %edi,%edi
801032ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801032ed:	eb 09                	jmp    801032f8 <dirlink+0x38>
801032ef:	90                   	nop
801032f0:	83 c7 10             	add    $0x10,%edi
801032f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801032f6:	73 19                	jae    80103311 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801032f8:	6a 10                	push   $0x10
801032fa:	57                   	push   %edi
801032fb:	56                   	push   %esi
801032fc:	53                   	push   %ebx
801032fd:	e8 6e fa ff ff       	call   80102d70 <readi>
80103302:	83 c4 10             	add    $0x10,%esp
80103305:	83 f8 10             	cmp    $0x10,%eax
80103308:	75 4e                	jne    80103358 <dirlink+0x98>
    if(de.inum == 0)
8010330a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010330f:	75 df                	jne    801032f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103311:	83 ec 04             	sub    $0x4,%esp
80103314:	8d 45 da             	lea    -0x26(%ebp),%eax
80103317:	6a 0e                	push   $0xe
80103319:	ff 75 0c             	push   0xc(%ebp)
8010331c:	50                   	push   %eax
8010331d:	e8 7e 27 00 00       	call   80105aa0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103322:	6a 10                	push   $0x10
  de.inum = inum;
80103324:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103327:	57                   	push   %edi
80103328:	56                   	push   %esi
80103329:	53                   	push   %ebx
  de.inum = inum;
8010332a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010332e:	e8 3d fb ff ff       	call   80102e70 <writei>
80103333:	83 c4 20             	add    $0x20,%esp
80103336:	83 f8 10             	cmp    $0x10,%eax
80103339:	75 2a                	jne    80103365 <dirlink+0xa5>
  return 0;
8010333b:	31 c0                	xor    %eax,%eax
}
8010333d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
    iput(ip);
80103345:	83 ec 0c             	sub    $0xc,%esp
80103348:	50                   	push   %eax
80103349:	e8 42 f8 ff ff       	call   80102b90 <iput>
    return -1;
8010334e:	83 c4 10             	add    $0x10,%esp
80103351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103356:	eb e5                	jmp    8010333d <dirlink+0x7d>
      panic("dirlink read");
80103358:	83 ec 0c             	sub    $0xc,%esp
8010335b:	68 28 86 10 80       	push   $0x80108628
80103360:	e8 fb d0 ff ff       	call   80100460 <panic>
    panic("dirlink");
80103365:	83 ec 0c             	sub    $0xc,%esp
80103368:	68 fe 8b 10 80       	push   $0x80108bfe
8010336d:	e8 ee d0 ff ff       	call   80100460 <panic>
80103372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103380 <namei>:

struct inode*
namei(char *path)
{
80103380:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80103381:	31 d2                	xor    %edx,%edx
{
80103383:	89 e5                	mov    %esp,%ebp
80103385:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80103388:	8b 45 08             	mov    0x8(%ebp),%eax
8010338b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010338e:	e8 dd fc ff ff       	call   80103070 <namex>
}
80103393:	c9                   	leave  
80103394:	c3                   	ret    
80103395:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801033a0:	55                   	push   %ebp
  return namex(path, 1, name);
801033a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801033a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801033a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801033ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801033af:	e9 bc fc ff ff       	jmp    80103070 <namex>
801033b4:	66 90                	xchg   %ax,%ax
801033b6:	66 90                	xchg   %ax,%ax
801033b8:	66 90                	xchg   %ax,%ax
801033ba:	66 90                	xchg   %ax,%ax
801033bc:	66 90                	xchg   %ax,%ax
801033be:	66 90                	xchg   %ax,%ax

801033c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801033c9:	85 c0                	test   %eax,%eax
801033cb:	0f 84 b4 00 00 00    	je     80103485 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801033d1:	8b 70 08             	mov    0x8(%eax),%esi
801033d4:	89 c3                	mov    %eax,%ebx
801033d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801033dc:	0f 87 96 00 00 00    	ja     80103478 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801033e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ee:	66 90                	xchg   %ax,%ax
801033f0:	89 ca                	mov    %ecx,%edx
801033f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801033f3:	83 e0 c0             	and    $0xffffffc0,%eax
801033f6:	3c 40                	cmp    $0x40,%al
801033f8:	75 f6                	jne    801033f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033fa:	31 ff                	xor    %edi,%edi
801033fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103401:	89 f8                	mov    %edi,%eax
80103403:	ee                   	out    %al,(%dx)
80103404:	b8 01 00 00 00       	mov    $0x1,%eax
80103409:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010340e:	ee                   	out    %al,(%dx)
8010340f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103414:	89 f0                	mov    %esi,%eax
80103416:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103417:	89 f0                	mov    %esi,%eax
80103419:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010341e:	c1 f8 08             	sar    $0x8,%eax
80103421:	ee                   	out    %al,(%dx)
80103422:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103427:	89 f8                	mov    %edi,%eax
80103429:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010342a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010342e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103433:	c1 e0 04             	shl    $0x4,%eax
80103436:	83 e0 10             	and    $0x10,%eax
80103439:	83 c8 e0             	or     $0xffffffe0,%eax
8010343c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010343d:	f6 03 04             	testb  $0x4,(%ebx)
80103440:	75 16                	jne    80103458 <idestart+0x98>
80103442:	b8 20 00 00 00       	mov    $0x20,%eax
80103447:	89 ca                	mov    %ecx,%edx
80103449:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010344a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344d:	5b                   	pop    %ebx
8010344e:	5e                   	pop    %esi
8010344f:	5f                   	pop    %edi
80103450:	5d                   	pop    %ebp
80103451:	c3                   	ret    
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103458:	b8 30 00 00 00       	mov    $0x30,%eax
8010345d:	89 ca                	mov    %ecx,%edx
8010345f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103460:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103465:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103468:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010346d:	fc                   	cld    
8010346e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80103470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103473:	5b                   	pop    %ebx
80103474:	5e                   	pop    %esi
80103475:	5f                   	pop    %edi
80103476:	5d                   	pop    %ebp
80103477:	c3                   	ret    
    panic("incorrect blockno");
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	68 94 86 10 80       	push   $0x80108694
80103480:	e8 db cf ff ff       	call   80100460 <panic>
    panic("idestart");
80103485:	83 ec 0c             	sub    $0xc,%esp
80103488:	68 8b 86 10 80       	push   $0x8010868b
8010348d:	e8 ce cf ff ff       	call   80100460 <panic>
80103492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <ideinit>:
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801034a6:	68 a6 86 10 80       	push   $0x801086a6
801034ab:	68 a0 31 11 80       	push   $0x801131a0
801034b0:	e8 fb 21 00 00       	call   801056b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801034b5:	58                   	pop    %eax
801034b6:	a1 24 33 11 80       	mov    0x80113324,%eax
801034bb:	5a                   	pop    %edx
801034bc:	83 e8 01             	sub    $0x1,%eax
801034bf:	50                   	push   %eax
801034c0:	6a 0e                	push   $0xe
801034c2:	e8 99 02 00 00       	call   80103760 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801034c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801034cf:	90                   	nop
801034d0:	ec                   	in     (%dx),%al
801034d1:	83 e0 c0             	and    $0xffffffc0,%eax
801034d4:	3c 40                	cmp    $0x40,%al
801034d6:	75 f8                	jne    801034d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801034dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801034e2:	ee                   	out    %al,(%dx)
801034e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801034ed:	eb 06                	jmp    801034f5 <ideinit+0x55>
801034ef:	90                   	nop
  for(i=0; i<1000; i++){
801034f0:	83 e9 01             	sub    $0x1,%ecx
801034f3:	74 0f                	je     80103504 <ideinit+0x64>
801034f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801034f6:	84 c0                	test   %al,%al
801034f8:	74 f6                	je     801034f0 <ideinit+0x50>
      havedisk1 = 1;
801034fa:	c7 05 80 31 11 80 01 	movl   $0x1,0x80113180
80103501:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103504:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103509:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010350e:	ee                   	out    %al,(%dx)
}
8010350f:	c9                   	leave  
80103510:	c3                   	ret    
80103511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop

80103520 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103529:	68 a0 31 11 80       	push   $0x801131a0
8010352e:	e8 4d 23 00 00       	call   80105880 <acquire>

  if((b = idequeue) == 0){
80103533:	8b 1d 84 31 11 80    	mov    0x80113184,%ebx
80103539:	83 c4 10             	add    $0x10,%esp
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	74 63                	je     801035a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103540:	8b 43 58             	mov    0x58(%ebx),%eax
80103543:	a3 84 31 11 80       	mov    %eax,0x80113184

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103548:	8b 33                	mov    (%ebx),%esi
8010354a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103550:	75 2f                	jne    80103581 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103552:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355e:	66 90                	xchg   %ax,%ax
80103560:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103561:	89 c1                	mov    %eax,%ecx
80103563:	83 e1 c0             	and    $0xffffffc0,%ecx
80103566:	80 f9 40             	cmp    $0x40,%cl
80103569:	75 f5                	jne    80103560 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010356b:	a8 21                	test   $0x21,%al
8010356d:	75 12                	jne    80103581 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010356f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80103572:	b9 80 00 00 00       	mov    $0x80,%ecx
80103577:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010357c:	fc                   	cld    
8010357d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010357f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80103581:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80103584:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80103587:	83 ce 02             	or     $0x2,%esi
8010358a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010358c:	53                   	push   %ebx
8010358d:	e8 4e 1e 00 00       	call   801053e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80103592:	a1 84 31 11 80       	mov    0x80113184,%eax
80103597:	83 c4 10             	add    $0x10,%esp
8010359a:	85 c0                	test   %eax,%eax
8010359c:	74 05                	je     801035a3 <ideintr+0x83>
    idestart(idequeue);
8010359e:	e8 1d fe ff ff       	call   801033c0 <idestart>
    release(&idelock);
801035a3:	83 ec 0c             	sub    $0xc,%esp
801035a6:	68 a0 31 11 80       	push   $0x801131a0
801035ab:	e8 70 22 00 00       	call   80105820 <release>

  release(&idelock);
}
801035b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b3:	5b                   	pop    %ebx
801035b4:	5e                   	pop    %esi
801035b5:	5f                   	pop    %edi
801035b6:	5d                   	pop    %ebp
801035b7:	c3                   	ret    
801035b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035bf:	90                   	nop

801035c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	53                   	push   %ebx
801035c4:	83 ec 10             	sub    $0x10,%esp
801035c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801035ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801035cd:	50                   	push   %eax
801035ce:	e8 8d 20 00 00       	call   80105660 <holdingsleep>
801035d3:	83 c4 10             	add    $0x10,%esp
801035d6:	85 c0                	test   %eax,%eax
801035d8:	0f 84 c3 00 00 00    	je     801036a1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801035de:	8b 03                	mov    (%ebx),%eax
801035e0:	83 e0 06             	and    $0x6,%eax
801035e3:	83 f8 02             	cmp    $0x2,%eax
801035e6:	0f 84 a8 00 00 00    	je     80103694 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801035ec:	8b 53 04             	mov    0x4(%ebx),%edx
801035ef:	85 d2                	test   %edx,%edx
801035f1:	74 0d                	je     80103600 <iderw+0x40>
801035f3:	a1 80 31 11 80       	mov    0x80113180,%eax
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 84 87 00 00 00    	je     80103687 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	68 a0 31 11 80       	push   $0x801131a0
80103608:	e8 73 22 00 00       	call   80105880 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010360d:	a1 84 31 11 80       	mov    0x80113184,%eax
  b->qnext = 0;
80103612:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	85 c0                	test   %eax,%eax
8010361e:	74 60                	je     80103680 <iderw+0xc0>
80103620:	89 c2                	mov    %eax,%edx
80103622:	8b 40 58             	mov    0x58(%eax),%eax
80103625:	85 c0                	test   %eax,%eax
80103627:	75 f7                	jne    80103620 <iderw+0x60>
80103629:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010362c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010362e:	39 1d 84 31 11 80    	cmp    %ebx,0x80113184
80103634:	74 3a                	je     80103670 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103636:	8b 03                	mov    (%ebx),%eax
80103638:	83 e0 06             	and    $0x6,%eax
8010363b:	83 f8 02             	cmp    $0x2,%eax
8010363e:	74 1b                	je     8010365b <iderw+0x9b>
    sleep(b, &idelock);
80103640:	83 ec 08             	sub    $0x8,%esp
80103643:	68 a0 31 11 80       	push   $0x801131a0
80103648:	53                   	push   %ebx
80103649:	e8 d2 1c 00 00       	call   80105320 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010364e:	8b 03                	mov    (%ebx),%eax
80103650:	83 c4 10             	add    $0x10,%esp
80103653:	83 e0 06             	and    $0x6,%eax
80103656:	83 f8 02             	cmp    $0x2,%eax
80103659:	75 e5                	jne    80103640 <iderw+0x80>
  }


  release(&idelock);
8010365b:	c7 45 08 a0 31 11 80 	movl   $0x801131a0,0x8(%ebp)
}
80103662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103665:	c9                   	leave  
  release(&idelock);
80103666:	e9 b5 21 00 00       	jmp    80105820 <release>
8010366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop
    idestart(b);
80103670:	89 d8                	mov    %ebx,%eax
80103672:	e8 49 fd ff ff       	call   801033c0 <idestart>
80103677:	eb bd                	jmp    80103636 <iderw+0x76>
80103679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103680:	ba 84 31 11 80       	mov    $0x80113184,%edx
80103685:	eb a5                	jmp    8010362c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80103687:	83 ec 0c             	sub    $0xc,%esp
8010368a:	68 d5 86 10 80       	push   $0x801086d5
8010368f:	e8 cc cd ff ff       	call   80100460 <panic>
    panic("iderw: nothing to do");
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	68 c0 86 10 80       	push   $0x801086c0
8010369c:	e8 bf cd ff ff       	call   80100460 <panic>
    panic("iderw: buf not locked");
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	68 aa 86 10 80       	push   $0x801086aa
801036a9:	e8 b2 cd ff ff       	call   80100460 <panic>
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801036b0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801036b1:	c7 05 d4 31 11 80 00 	movl   $0xfec00000,0x801131d4
801036b8:	00 c0 fe 
{
801036bb:	89 e5                	mov    %esp,%ebp
801036bd:	56                   	push   %esi
801036be:	53                   	push   %ebx
  ioapic->reg = reg;
801036bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801036c6:	00 00 00 
  return ioapic->data;
801036c9:	8b 15 d4 31 11 80    	mov    0x801131d4,%edx
801036cf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801036d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801036d8:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801036de:	0f b6 15 20 33 11 80 	movzbl 0x80113320,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801036e5:	c1 ee 10             	shr    $0x10,%esi
801036e8:	89 f0                	mov    %esi,%eax
801036ea:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801036ed:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801036f0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801036f3:	39 c2                	cmp    %eax,%edx
801036f5:	74 16                	je     8010370d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801036f7:	83 ec 0c             	sub    $0xc,%esp
801036fa:	68 f4 86 10 80       	push   $0x801086f4
801036ff:	e8 dc d0 ff ff       	call   801007e0 <cprintf>
  ioapic->reg = reg;
80103704:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	83 c6 21             	add    $0x21,%esi
{
80103710:	ba 10 00 00 00       	mov    $0x10,%edx
80103715:	b8 20 00 00 00       	mov    $0x20,%eax
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80103720:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80103722:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80103724:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
  for(i = 0; i <= maxintr; i++){
8010372a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010372d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80103733:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80103736:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80103739:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010373c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010373e:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
80103744:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010374b:	39 f0                	cmp    %esi,%eax
8010374d:	75 d1                	jne    80103720 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
80103755:	c3                   	ret    
80103756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010375d:	8d 76 00             	lea    0x0(%esi),%esi

80103760 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80103760:	55                   	push   %ebp
  ioapic->reg = reg;
80103761:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
{
80103767:	89 e5                	mov    %esp,%ebp
80103769:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010376c:	8d 50 20             	lea    0x20(%eax),%edx
8010376f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80103773:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103775:	8b 0d d4 31 11 80    	mov    0x801131d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010377b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010377e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103781:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80103784:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103786:	a1 d4 31 11 80       	mov    0x801131d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010378b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010378e:	89 50 10             	mov    %edx,0x10(%eax)
}
80103791:	5d                   	pop    %ebp
80103792:	c3                   	ret    
80103793:	66 90                	xchg   %ax,%ax
80103795:	66 90                	xchg   %ax,%ax
80103797:	66 90                	xchg   %ax,%ax
80103799:	66 90                	xchg   %ax,%ax
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
801037a4:	83 ec 04             	sub    $0x4,%esp
801037a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801037aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801037b0:	75 76                	jne    80103828 <kfree+0x88>
801037b2:	81 fb 70 70 11 80    	cmp    $0x80117070,%ebx
801037b8:	72 6e                	jb     80103828 <kfree+0x88>
801037ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801037c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801037c5:	77 61                	ja     80103828 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801037c7:	83 ec 04             	sub    $0x4,%esp
801037ca:	68 00 10 00 00       	push   $0x1000
801037cf:	6a 01                	push   $0x1
801037d1:	53                   	push   %ebx
801037d2:	e8 69 21 00 00       	call   80105940 <memset>

  if(kmem.use_lock)
801037d7:	8b 15 14 32 11 80    	mov    0x80113214,%edx
801037dd:	83 c4 10             	add    $0x10,%esp
801037e0:	85 d2                	test   %edx,%edx
801037e2:	75 1c                	jne    80103800 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801037e4:	a1 18 32 11 80       	mov    0x80113218,%eax
801037e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801037eb:	a1 14 32 11 80       	mov    0x80113214,%eax
  kmem.freelist = r;
801037f0:	89 1d 18 32 11 80    	mov    %ebx,0x80113218
  if(kmem.use_lock)
801037f6:	85 c0                	test   %eax,%eax
801037f8:	75 1e                	jne    80103818 <kfree+0x78>
    release(&kmem.lock);
}
801037fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037fd:	c9                   	leave  
801037fe:	c3                   	ret    
801037ff:	90                   	nop
    acquire(&kmem.lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
80103803:	68 e0 31 11 80       	push   $0x801131e0
80103808:	e8 73 20 00 00       	call   80105880 <acquire>
8010380d:	83 c4 10             	add    $0x10,%esp
80103810:	eb d2                	jmp    801037e4 <kfree+0x44>
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103818:	c7 45 08 e0 31 11 80 	movl   $0x801131e0,0x8(%ebp)
}
8010381f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103822:	c9                   	leave  
    release(&kmem.lock);
80103823:	e9 f8 1f 00 00       	jmp    80105820 <release>
    panic("kfree");
80103828:	83 ec 0c             	sub    $0xc,%esp
8010382b:	68 26 87 10 80       	push   $0x80108726
80103830:	e8 2b cc ff ff       	call   80100460 <panic>
80103835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103840 <freerange>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103844:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103847:	8b 75 0c             	mov    0xc(%ebp),%esi
8010384a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010384b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103851:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103857:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010385d:	39 de                	cmp    %ebx,%esi
8010385f:	72 23                	jb     80103884 <freerange+0x44>
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103871:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103877:	50                   	push   %eax
80103878:	e8 23 ff ff ff       	call   801037a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010387d:	83 c4 10             	add    $0x10,%esp
80103880:	39 f3                	cmp    %esi,%ebx
80103882:	76 e4                	jbe    80103868 <freerange+0x28>
}
80103884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103887:	5b                   	pop    %ebx
80103888:	5e                   	pop    %esi
80103889:	5d                   	pop    %ebp
8010388a:	c3                   	ret    
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop

80103890 <kinit2>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103894:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103897:	8b 75 0c             	mov    0xc(%ebp),%esi
8010389a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010389b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801038a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801038ad:	39 de                	cmp    %ebx,%esi
801038af:	72 23                	jb     801038d4 <kinit2+0x44>
801038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801038b8:	83 ec 0c             	sub    $0xc,%esp
801038bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801038c7:	50                   	push   %eax
801038c8:	e8 d3 fe ff ff       	call   801037a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038cd:	83 c4 10             	add    $0x10,%esp
801038d0:	39 de                	cmp    %ebx,%esi
801038d2:	73 e4                	jae    801038b8 <kinit2+0x28>
  kmem.use_lock = 1;
801038d4:	c7 05 14 32 11 80 01 	movl   $0x1,0x80113214
801038db:	00 00 00 
}
801038de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e1:	5b                   	pop    %ebx
801038e2:	5e                   	pop    %esi
801038e3:	5d                   	pop    %ebp
801038e4:	c3                   	ret    
801038e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <kinit1>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
801038f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801038f8:	83 ec 08             	sub    $0x8,%esp
801038fb:	68 2c 87 10 80       	push   $0x8010872c
80103900:	68 e0 31 11 80       	push   $0x801131e0
80103905:	e8 a6 1d 00 00       	call   801056b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010390a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010390d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103910:	c7 05 14 32 11 80 00 	movl   $0x0,0x80113214
80103917:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010391a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103920:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103926:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010392c:	39 de                	cmp    %ebx,%esi
8010392e:	72 1c                	jb     8010394c <kinit1+0x5c>
    kfree(p);
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103939:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010393f:	50                   	push   %eax
80103940:	e8 5b fe ff ff       	call   801037a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	39 de                	cmp    %ebx,%esi
8010394a:	73 e4                	jae    80103930 <kinit1+0x40>
}
8010394c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010394f:	5b                   	pop    %ebx
80103950:	5e                   	pop    %esi
80103951:	5d                   	pop    %ebp
80103952:	c3                   	ret    
80103953:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103960 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80103960:	a1 14 32 11 80       	mov    0x80113214,%eax
80103965:	85 c0                	test   %eax,%eax
80103967:	75 1f                	jne    80103988 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103969:	a1 18 32 11 80       	mov    0x80113218,%eax
  if(r)
8010396e:	85 c0                	test   %eax,%eax
80103970:	74 0e                	je     80103980 <kalloc+0x20>
    kmem.freelist = r->next;
80103972:	8b 10                	mov    (%eax),%edx
80103974:	89 15 18 32 11 80    	mov    %edx,0x80113218
  if(kmem.use_lock)
8010397a:	c3                   	ret    
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80103980:	c3                   	ret    
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80103988:	55                   	push   %ebp
80103989:	89 e5                	mov    %esp,%ebp
8010398b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010398e:	68 e0 31 11 80       	push   $0x801131e0
80103993:	e8 e8 1e 00 00       	call   80105880 <acquire>
  r = kmem.freelist;
80103998:	a1 18 32 11 80       	mov    0x80113218,%eax
  if(kmem.use_lock)
8010399d:	8b 15 14 32 11 80    	mov    0x80113214,%edx
  if(r)
801039a3:	83 c4 10             	add    $0x10,%esp
801039a6:	85 c0                	test   %eax,%eax
801039a8:	74 08                	je     801039b2 <kalloc+0x52>
    kmem.freelist = r->next;
801039aa:	8b 08                	mov    (%eax),%ecx
801039ac:	89 0d 18 32 11 80    	mov    %ecx,0x80113218
  if(kmem.use_lock)
801039b2:	85 d2                	test   %edx,%edx
801039b4:	74 16                	je     801039cc <kalloc+0x6c>
    release(&kmem.lock);
801039b6:	83 ec 0c             	sub    $0xc,%esp
801039b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039bc:	68 e0 31 11 80       	push   $0x801131e0
801039c1:	e8 5a 1e 00 00       	call   80105820 <release>
  return (char*)r;
801039c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801039c9:	83 c4 10             	add    $0x10,%esp
}
801039cc:	c9                   	leave  
801039cd:	c3                   	ret    
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039d0:	ba 64 00 00 00       	mov    $0x64,%edx
801039d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801039d6:	a8 01                	test   $0x1,%al
801039d8:	0f 84 c2 00 00 00    	je     80103aa0 <kbdgetc+0xd0>
{
801039de:	55                   	push   %ebp
801039df:	ba 60 00 00 00       	mov    $0x60,%edx
801039e4:	89 e5                	mov    %esp,%ebp
801039e6:	53                   	push   %ebx
801039e7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801039e8:	8b 1d 1c 32 11 80    	mov    0x8011321c,%ebx
  data = inb(KBDATAP);
801039ee:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801039f1:	3c e0                	cmp    $0xe0,%al
801039f3:	74 5b                	je     80103a50 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801039f5:	89 da                	mov    %ebx,%edx
801039f7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801039fa:	84 c0                	test   %al,%al
801039fc:	78 62                	js     80103a60 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801039fe:	85 d2                	test   %edx,%edx
80103a00:	74 09                	je     80103a0b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103a02:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103a05:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103a08:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80103a0b:	0f b6 91 60 88 10 80 	movzbl -0x7fef77a0(%ecx),%edx
  shift ^= togglecode[data];
80103a12:	0f b6 81 60 87 10 80 	movzbl -0x7fef78a0(%ecx),%eax
  shift |= shiftcode[data];
80103a19:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103a1b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a1d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103a1f:	89 15 1c 32 11 80    	mov    %edx,0x8011321c
  c = charcode[shift & (CTL | SHIFT)][data];
80103a25:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103a28:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a2b:	8b 04 85 40 87 10 80 	mov    -0x7fef78c0(,%eax,4),%eax
80103a32:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103a36:	74 0b                	je     80103a43 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103a38:	8d 50 9f             	lea    -0x61(%eax),%edx
80103a3b:	83 fa 19             	cmp    $0x19,%edx
80103a3e:	77 48                	ja     80103a88 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103a40:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a46:	c9                   	leave  
80103a47:	c3                   	ret    
80103a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4f:	90                   	nop
    shift |= E0ESC;
80103a50:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103a53:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103a55:	89 1d 1c 32 11 80    	mov    %ebx,0x8011321c
}
80103a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5e:	c9                   	leave  
80103a5f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80103a60:	83 e0 7f             	and    $0x7f,%eax
80103a63:	85 d2                	test   %edx,%edx
80103a65:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103a68:	0f b6 81 60 88 10 80 	movzbl -0x7fef77a0(%ecx),%eax
80103a6f:	83 c8 40             	or     $0x40,%eax
80103a72:	0f b6 c0             	movzbl %al,%eax
80103a75:	f7 d0                	not    %eax
80103a77:	21 d8                	and    %ebx,%eax
}
80103a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80103a7c:	a3 1c 32 11 80       	mov    %eax,0x8011321c
    return 0;
80103a81:	31 c0                	xor    %eax,%eax
}
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    
80103a85:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103a88:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103a8b:	8d 50 20             	lea    0x20(%eax),%edx
}
80103a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a91:	c9                   	leave  
      c += 'a' - 'A';
80103a92:	83 f9 1a             	cmp    $0x1a,%ecx
80103a95:	0f 42 c2             	cmovb  %edx,%eax
}
80103a98:	c3                   	ret    
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103aa5:	c3                   	ret    
80103aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <kbdintr>:

void
kbdintr(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103ab6:	68 d0 39 10 80       	push   $0x801039d0
80103abb:	e8 80 dc ff ff       	call   80101740 <consoleintr>
}
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	c9                   	leave  
80103ac4:	c3                   	ret    
80103ac5:	66 90                	xchg   %ax,%ax
80103ac7:	66 90                	xchg   %ax,%ax
80103ac9:	66 90                	xchg   %ax,%ax
80103acb:	66 90                	xchg   %ax,%ax
80103acd:	66 90                	xchg   %ax,%ax
80103acf:	90                   	nop

80103ad0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103ad0:	a1 20 32 11 80       	mov    0x80113220,%eax
80103ad5:	85 c0                	test   %eax,%eax
80103ad7:	0f 84 cb 00 00 00    	je     80103ba8 <lapicinit+0xd8>
  lapic[index] = value;
80103add:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103ae4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ae7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103aea:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103af1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103af4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103af7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103afe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103b01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b04:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103b0b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103b0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b11:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103b18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103b1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b1e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103b25:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103b28:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103b2b:	8b 50 30             	mov    0x30(%eax),%edx
80103b2e:	c1 ea 10             	shr    $0x10,%edx
80103b31:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103b37:	75 77                	jne    80103bb0 <lapicinit+0xe0>
  lapic[index] = value;
80103b39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103b40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103b4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103b5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103b67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103b74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103b81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103b84:	8b 50 20             	mov    0x20(%eax),%edx
80103b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103b90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103b96:	80 e6 10             	and    $0x10,%dh
80103b99:	75 f5                	jne    80103b90 <lapicinit+0xc0>
  lapic[index] = value;
80103b9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103ba2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ba5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103ba8:	c3                   	ret    
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103bb0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103bb7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103bba:	8b 50 20             	mov    0x20(%eax),%edx
}
80103bbd:	e9 77 ff ff ff       	jmp    80103b39 <lapicinit+0x69>
80103bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bd0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103bd0:	a1 20 32 11 80       	mov    0x80113220,%eax
80103bd5:	85 c0                	test   %eax,%eax
80103bd7:	74 07                	je     80103be0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103bd9:	8b 40 20             	mov    0x20(%eax),%eax
80103bdc:	c1 e8 18             	shr    $0x18,%eax
80103bdf:	c3                   	ret    
    return 0;
80103be0:	31 c0                	xor    %eax,%eax
}
80103be2:	c3                   	ret    
80103be3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bf0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103bf0:	a1 20 32 11 80       	mov    0x80113220,%eax
80103bf5:	85 c0                	test   %eax,%eax
80103bf7:	74 0d                	je     80103c06 <lapiceoi+0x16>
  lapic[index] = value;
80103bf9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103c00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c03:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103c06:	c3                   	ret    
80103c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c0e:	66 90                	xchg   %ax,%ax

80103c10 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103c10:	c3                   	ret    
80103c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1f:	90                   	nop

80103c20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103c20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c21:	b8 0f 00 00 00       	mov    $0xf,%eax
80103c26:	ba 70 00 00 00       	mov    $0x70,%edx
80103c2b:	89 e5                	mov    %esp,%ebp
80103c2d:	53                   	push   %ebx
80103c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c34:	ee                   	out    %al,(%dx)
80103c35:	b8 0a 00 00 00       	mov    $0xa,%eax
80103c3a:	ba 71 00 00 00       	mov    $0x71,%edx
80103c3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103c40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103c42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103c45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103c4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103c4d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103c50:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103c52:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103c55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103c58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103c5e:	a1 20 32 11 80       	mov    0x80113220,%eax
80103c63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103c73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103c80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103ca1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103ca7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cad:	c9                   	leave  
80103cae:	c3                   	ret    
80103caf:	90                   	nop

80103cb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103cb0:	55                   	push   %ebp
80103cb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80103cb6:	ba 70 00 00 00       	mov    $0x70,%edx
80103cbb:	89 e5                	mov    %esp,%ebp
80103cbd:	57                   	push   %edi
80103cbe:	56                   	push   %esi
80103cbf:	53                   	push   %ebx
80103cc0:	83 ec 4c             	sub    $0x4c,%esp
80103cc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cc4:	ba 71 00 00 00       	mov    $0x71,%edx
80103cc9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103cca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ccd:	bb 70 00 00 00       	mov    $0x70,%ebx
80103cd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103cd5:	8d 76 00             	lea    0x0(%esi),%esi
80103cd8:	31 c0                	xor    %eax,%eax
80103cda:	89 da                	mov    %ebx,%edx
80103cdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80103ce2:	89 ca                	mov    %ecx,%edx
80103ce4:	ec                   	in     (%dx),%al
80103ce5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ce8:	89 da                	mov    %ebx,%edx
80103cea:	b8 02 00 00 00       	mov    $0x2,%eax
80103cef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cf0:	89 ca                	mov    %ecx,%edx
80103cf2:	ec                   	in     (%dx),%al
80103cf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cf6:	89 da                	mov    %ebx,%edx
80103cf8:	b8 04 00 00 00       	mov    $0x4,%eax
80103cfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cfe:	89 ca                	mov    %ecx,%edx
80103d00:	ec                   	in     (%dx),%al
80103d01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d04:	89 da                	mov    %ebx,%edx
80103d06:	b8 07 00 00 00       	mov    $0x7,%eax
80103d0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d0c:	89 ca                	mov    %ecx,%edx
80103d0e:	ec                   	in     (%dx),%al
80103d0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d12:	89 da                	mov    %ebx,%edx
80103d14:	b8 08 00 00 00       	mov    $0x8,%eax
80103d19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d1a:	89 ca                	mov    %ecx,%edx
80103d1c:	ec                   	in     (%dx),%al
80103d1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d1f:	89 da                	mov    %ebx,%edx
80103d21:	b8 09 00 00 00       	mov    $0x9,%eax
80103d26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d27:	89 ca                	mov    %ecx,%edx
80103d29:	ec                   	in     (%dx),%al
80103d2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d2c:	89 da                	mov    %ebx,%edx
80103d2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103d33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d34:	89 ca                	mov    %ecx,%edx
80103d36:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103d37:	84 c0                	test   %al,%al
80103d39:	78 9d                	js     80103cd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103d3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103d3f:	89 fa                	mov    %edi,%edx
80103d41:	0f b6 fa             	movzbl %dl,%edi
80103d44:	89 f2                	mov    %esi,%edx
80103d46:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103d49:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103d4d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d50:	89 da                	mov    %ebx,%edx
80103d52:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103d55:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103d58:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103d5c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103d5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103d62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103d66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103d69:	31 c0                	xor    %eax,%eax
80103d6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d6c:	89 ca                	mov    %ecx,%edx
80103d6e:	ec                   	in     (%dx),%al
80103d6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d72:	89 da                	mov    %ebx,%edx
80103d74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103d77:	b8 02 00 00 00       	mov    $0x2,%eax
80103d7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d7d:	89 ca                	mov    %ecx,%edx
80103d7f:	ec                   	in     (%dx),%al
80103d80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d83:	89 da                	mov    %ebx,%edx
80103d85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103d88:	b8 04 00 00 00       	mov    $0x4,%eax
80103d8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d8e:	89 ca                	mov    %ecx,%edx
80103d90:	ec                   	in     (%dx),%al
80103d91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d94:	89 da                	mov    %ebx,%edx
80103d96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103d99:	b8 07 00 00 00       	mov    $0x7,%eax
80103d9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d9f:	89 ca                	mov    %ecx,%edx
80103da1:	ec                   	in     (%dx),%al
80103da2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103da5:	89 da                	mov    %ebx,%edx
80103da7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103daa:	b8 08 00 00 00       	mov    $0x8,%eax
80103daf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103db0:	89 ca                	mov    %ecx,%edx
80103db2:	ec                   	in     (%dx),%al
80103db3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103db6:	89 da                	mov    %ebx,%edx
80103db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103dbb:	b8 09 00 00 00       	mov    $0x9,%eax
80103dc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dc1:	89 ca                	mov    %ecx,%edx
80103dc3:	ec                   	in     (%dx),%al
80103dc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103dc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103dca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103dcd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103dd0:	6a 18                	push   $0x18
80103dd2:	50                   	push   %eax
80103dd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103dd6:	50                   	push   %eax
80103dd7:	e8 b4 1b 00 00       	call   80105990 <memcmp>
80103ddc:	83 c4 10             	add    $0x10,%esp
80103ddf:	85 c0                	test   %eax,%eax
80103de1:	0f 85 f1 fe ff ff    	jne    80103cd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103de7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103deb:	75 78                	jne    80103e65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103ded:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103df0:	89 c2                	mov    %eax,%edx
80103df2:	83 e0 0f             	and    $0xf,%eax
80103df5:	c1 ea 04             	shr    $0x4,%edx
80103df8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103dfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103dfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103e01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103e04:	89 c2                	mov    %eax,%edx
80103e06:	83 e0 0f             	and    $0xf,%eax
80103e09:	c1 ea 04             	shr    $0x4,%edx
80103e0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103e15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103e18:	89 c2                	mov    %eax,%edx
80103e1a:	83 e0 0f             	and    $0xf,%eax
80103e1d:	c1 ea 04             	shr    $0x4,%edx
80103e20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103e29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103e2c:	89 c2                	mov    %eax,%edx
80103e2e:	83 e0 0f             	and    $0xf,%eax
80103e31:	c1 ea 04             	shr    $0x4,%edx
80103e34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103e3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103e40:	89 c2                	mov    %eax,%edx
80103e42:	83 e0 0f             	and    $0xf,%eax
80103e45:	c1 ea 04             	shr    $0x4,%edx
80103e48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103e51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103e54:	89 c2                	mov    %eax,%edx
80103e56:	83 e0 0f             	and    $0xf,%eax
80103e59:	c1 ea 04             	shr    $0x4,%edx
80103e5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103e65:	8b 75 08             	mov    0x8(%ebp),%esi
80103e68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103e6b:	89 06                	mov    %eax,(%esi)
80103e6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103e70:	89 46 04             	mov    %eax,0x4(%esi)
80103e73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103e76:	89 46 08             	mov    %eax,0x8(%esi)
80103e79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103e7c:	89 46 0c             	mov    %eax,0xc(%esi)
80103e7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103e82:	89 46 10             	mov    %eax,0x10(%esi)
80103e85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103e88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103e8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e95:	5b                   	pop    %ebx
80103e96:	5e                   	pop    %esi
80103e97:	5f                   	pop    %edi
80103e98:	5d                   	pop    %ebp
80103e99:	c3                   	ret    
80103e9a:	66 90                	xchg   %ax,%ax
80103e9c:	66 90                	xchg   %ax,%ax
80103e9e:	66 90                	xchg   %ax,%ax

80103ea0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103ea0:	8b 0d 88 32 11 80    	mov    0x80113288,%ecx
80103ea6:	85 c9                	test   %ecx,%ecx
80103ea8:	0f 8e 8a 00 00 00    	jle    80103f38 <install_trans+0x98>
{
80103eae:	55                   	push   %ebp
80103eaf:	89 e5                	mov    %esp,%ebp
80103eb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103eb2:	31 ff                	xor    %edi,%edi
{
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 0c             	sub    $0xc,%esp
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103ec0:	a1 74 32 11 80       	mov    0x80113274,%eax
80103ec5:	83 ec 08             	sub    $0x8,%esp
80103ec8:	01 f8                	add    %edi,%eax
80103eca:	83 c0 01             	add    $0x1,%eax
80103ecd:	50                   	push   %eax
80103ece:	ff 35 84 32 11 80    	push   0x80113284
80103ed4:	e8 f7 c1 ff ff       	call   801000d0 <bread>
80103ed9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103edb:	58                   	pop    %eax
80103edc:	5a                   	pop    %edx
80103edd:	ff 34 bd 8c 32 11 80 	push   -0x7feecd74(,%edi,4)
80103ee4:	ff 35 84 32 11 80    	push   0x80113284
  for (tail = 0; tail < log.lh.n; tail++) {
80103eea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103eed:	e8 de c1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103ef2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103ef5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103ef7:	8d 46 5c             	lea    0x5c(%esi),%eax
80103efa:	68 00 02 00 00       	push   $0x200
80103eff:	50                   	push   %eax
80103f00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103f03:	50                   	push   %eax
80103f04:	e8 d7 1a 00 00       	call   801059e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103f09:	89 1c 24             	mov    %ebx,(%esp)
80103f0c:	e8 9f c2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103f11:	89 34 24             	mov    %esi,(%esp)
80103f14:	e8 d7 c2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103f19:	89 1c 24             	mov    %ebx,(%esp)
80103f1c:	e8 cf c2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103f21:	83 c4 10             	add    $0x10,%esp
80103f24:	39 3d 88 32 11 80    	cmp    %edi,0x80113288
80103f2a:	7f 94                	jg     80103ec0 <install_trans+0x20>
  }
}
80103f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f2f:	5b                   	pop    %ebx
80103f30:	5e                   	pop    %esi
80103f31:	5f                   	pop    %edi
80103f32:	5d                   	pop    %ebp
80103f33:	c3                   	ret    
80103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f38:	c3                   	ret    
80103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	53                   	push   %ebx
80103f44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f47:	ff 35 74 32 11 80    	push   0x80113274
80103f4d:	ff 35 84 32 11 80    	push   0x80113284
80103f53:	e8 78 c1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103f58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103f5d:	a1 88 32 11 80       	mov    0x80113288,%eax
80103f62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103f65:	85 c0                	test   %eax,%eax
80103f67:	7e 19                	jle    80103f82 <write_head+0x42>
80103f69:	31 d2                	xor    %edx,%edx
80103f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103f70:	8b 0c 95 8c 32 11 80 	mov    -0x7feecd74(,%edx,4),%ecx
80103f77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103f7b:	83 c2 01             	add    $0x1,%edx
80103f7e:	39 d0                	cmp    %edx,%eax
80103f80:	75 ee                	jne    80103f70 <write_head+0x30>
  }
  bwrite(buf);
80103f82:	83 ec 0c             	sub    $0xc,%esp
80103f85:	53                   	push   %ebx
80103f86:	e8 25 c2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80103f8b:	89 1c 24             	mov    %ebx,(%esp)
80103f8e:	e8 5d c2 ff ff       	call   801001f0 <brelse>
}
80103f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f96:	83 c4 10             	add    $0x10,%esp
80103f99:	c9                   	leave  
80103f9a:	c3                   	ret    
80103f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop

80103fa0 <initlog>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 2c             	sub    $0x2c,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80103faa:	68 60 89 10 80       	push   $0x80108960
80103faf:	68 40 32 11 80       	push   $0x80113240
80103fb4:	e8 f7 16 00 00       	call   801056b0 <initlock>
  readsb(dev, &sb);
80103fb9:	58                   	pop    %eax
80103fba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103fbd:	5a                   	pop    %edx
80103fbe:	50                   	push   %eax
80103fbf:	53                   	push   %ebx
80103fc0:	e8 3b e8 ff ff       	call   80102800 <readsb>
  log.start = sb.logstart;
80103fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103fc8:	59                   	pop    %ecx
  log.dev = dev;
80103fc9:	89 1d 84 32 11 80    	mov    %ebx,0x80113284
  log.size = sb.nlog;
80103fcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103fd2:	a3 74 32 11 80       	mov    %eax,0x80113274
  log.size = sb.nlog;
80103fd7:	89 15 78 32 11 80    	mov    %edx,0x80113278
  struct buf *buf = bread(log.dev, log.start);
80103fdd:	5a                   	pop    %edx
80103fde:	50                   	push   %eax
80103fdf:	53                   	push   %ebx
80103fe0:	e8 eb c0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103fe5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103fe8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80103feb:	89 1d 88 32 11 80    	mov    %ebx,0x80113288
  for (i = 0; i < log.lh.n; i++) {
80103ff1:	85 db                	test   %ebx,%ebx
80103ff3:	7e 1d                	jle    80104012 <initlog+0x72>
80103ff5:	31 d2                	xor    %edx,%edx
80103ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ffe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80104000:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80104004:	89 0c 95 8c 32 11 80 	mov    %ecx,-0x7feecd74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010400b:	83 c2 01             	add    $0x1,%edx
8010400e:	39 d3                	cmp    %edx,%ebx
80104010:	75 ee                	jne    80104000 <initlog+0x60>
  brelse(buf);
80104012:	83 ec 0c             	sub    $0xc,%esp
80104015:	50                   	push   %eax
80104016:	e8 d5 c1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010401b:	e8 80 fe ff ff       	call   80103ea0 <install_trans>
  log.lh.n = 0;
80104020:	c7 05 88 32 11 80 00 	movl   $0x0,0x80113288
80104027:	00 00 00 
  write_head(); // clear the log
8010402a:	e8 11 ff ff ff       	call   80103f40 <write_head>
}
8010402f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104032:	83 c4 10             	add    $0x10,%esp
80104035:	c9                   	leave  
80104036:	c3                   	ret    
80104037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403e:	66 90                	xchg   %ax,%ax

80104040 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104046:	68 40 32 11 80       	push   $0x80113240
8010404b:	e8 30 18 00 00       	call   80105880 <acquire>
80104050:	83 c4 10             	add    $0x10,%esp
80104053:	eb 18                	jmp    8010406d <begin_op+0x2d>
80104055:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104058:	83 ec 08             	sub    $0x8,%esp
8010405b:	68 40 32 11 80       	push   $0x80113240
80104060:	68 40 32 11 80       	push   $0x80113240
80104065:	e8 b6 12 00 00       	call   80105320 <sleep>
8010406a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010406d:	a1 80 32 11 80       	mov    0x80113280,%eax
80104072:	85 c0                	test   %eax,%eax
80104074:	75 e2                	jne    80104058 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104076:	a1 7c 32 11 80       	mov    0x8011327c,%eax
8010407b:	8b 15 88 32 11 80    	mov    0x80113288,%edx
80104081:	83 c0 01             	add    $0x1,%eax
80104084:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80104087:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010408a:	83 fa 1e             	cmp    $0x1e,%edx
8010408d:	7f c9                	jg     80104058 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010408f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80104092:	a3 7c 32 11 80       	mov    %eax,0x8011327c
      release(&log.lock);
80104097:	68 40 32 11 80       	push   $0x80113240
8010409c:	e8 7f 17 00 00       	call   80105820 <release>
      break;
    }
  }
}
801040a1:	83 c4 10             	add    $0x10,%esp
801040a4:	c9                   	leave  
801040a5:	c3                   	ret    
801040a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ad:	8d 76 00             	lea    0x0(%esi),%esi

801040b0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801040b9:	68 40 32 11 80       	push   $0x80113240
801040be:	e8 bd 17 00 00       	call   80105880 <acquire>
  log.outstanding -= 1;
801040c3:	a1 7c 32 11 80       	mov    0x8011327c,%eax
  if(log.committing)
801040c8:	8b 35 80 32 11 80    	mov    0x80113280,%esi
801040ce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801040d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801040d4:	89 1d 7c 32 11 80    	mov    %ebx,0x8011327c
  if(log.committing)
801040da:	85 f6                	test   %esi,%esi
801040dc:	0f 85 22 01 00 00    	jne    80104204 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801040e2:	85 db                	test   %ebx,%ebx
801040e4:	0f 85 f6 00 00 00    	jne    801041e0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801040ea:	c7 05 80 32 11 80 01 	movl   $0x1,0x80113280
801040f1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	68 40 32 11 80       	push   $0x80113240
801040fc:	e8 1f 17 00 00       	call   80105820 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104101:	8b 0d 88 32 11 80    	mov    0x80113288,%ecx
80104107:	83 c4 10             	add    $0x10,%esp
8010410a:	85 c9                	test   %ecx,%ecx
8010410c:	7f 42                	jg     80104150 <end_op+0xa0>
    acquire(&log.lock);
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	68 40 32 11 80       	push   $0x80113240
80104116:	e8 65 17 00 00       	call   80105880 <acquire>
    wakeup(&log);
8010411b:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
    log.committing = 0;
80104122:	c7 05 80 32 11 80 00 	movl   $0x0,0x80113280
80104129:	00 00 00 
    wakeup(&log);
8010412c:	e8 af 12 00 00       	call   801053e0 <wakeup>
    release(&log.lock);
80104131:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104138:	e8 e3 16 00 00       	call   80105820 <release>
8010413d:	83 c4 10             	add    $0x10,%esp
}
80104140:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104143:	5b                   	pop    %ebx
80104144:	5e                   	pop    %esi
80104145:	5f                   	pop    %edi
80104146:	5d                   	pop    %ebp
80104147:	c3                   	ret    
80104148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104150:	a1 74 32 11 80       	mov    0x80113274,%eax
80104155:	83 ec 08             	sub    $0x8,%esp
80104158:	01 d8                	add    %ebx,%eax
8010415a:	83 c0 01             	add    $0x1,%eax
8010415d:	50                   	push   %eax
8010415e:	ff 35 84 32 11 80    	push   0x80113284
80104164:	e8 67 bf ff ff       	call   801000d0 <bread>
80104169:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010416b:	58                   	pop    %eax
8010416c:	5a                   	pop    %edx
8010416d:	ff 34 9d 8c 32 11 80 	push   -0x7feecd74(,%ebx,4)
80104174:	ff 35 84 32 11 80    	push   0x80113284
  for (tail = 0; tail < log.lh.n; tail++) {
8010417a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010417d:	e8 4e bf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80104182:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104185:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80104187:	8d 40 5c             	lea    0x5c(%eax),%eax
8010418a:	68 00 02 00 00       	push   $0x200
8010418f:	50                   	push   %eax
80104190:	8d 46 5c             	lea    0x5c(%esi),%eax
80104193:	50                   	push   %eax
80104194:	e8 47 18 00 00       	call   801059e0 <memmove>
    bwrite(to);  // write the log
80104199:	89 34 24             	mov    %esi,(%esp)
8010419c:	e8 0f c0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801041a1:	89 3c 24             	mov    %edi,(%esp)
801041a4:	e8 47 c0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801041a9:	89 34 24             	mov    %esi,(%esp)
801041ac:	e8 3f c0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801041b1:	83 c4 10             	add    $0x10,%esp
801041b4:	3b 1d 88 32 11 80    	cmp    0x80113288,%ebx
801041ba:	7c 94                	jl     80104150 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801041bc:	e8 7f fd ff ff       	call   80103f40 <write_head>
    install_trans(); // Now install writes to home locations
801041c1:	e8 da fc ff ff       	call   80103ea0 <install_trans>
    log.lh.n = 0;
801041c6:	c7 05 88 32 11 80 00 	movl   $0x0,0x80113288
801041cd:	00 00 00 
    write_head();    // Erase the transaction from the log
801041d0:	e8 6b fd ff ff       	call   80103f40 <write_head>
801041d5:	e9 34 ff ff ff       	jmp    8010410e <end_op+0x5e>
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 40 32 11 80       	push   $0x80113240
801041e8:	e8 f3 11 00 00       	call   801053e0 <wakeup>
  release(&log.lock);
801041ed:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801041f4:	e8 27 16 00 00       	call   80105820 <release>
801041f9:	83 c4 10             	add    $0x10,%esp
}
801041fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041ff:	5b                   	pop    %ebx
80104200:	5e                   	pop    %esi
80104201:	5f                   	pop    %edi
80104202:	5d                   	pop    %ebp
80104203:	c3                   	ret    
    panic("log.committing");
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	68 64 89 10 80       	push   $0x80108964
8010420c:	e8 4f c2 ff ff       	call   80100460 <panic>
80104211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421f:	90                   	nop

80104220 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104227:	8b 15 88 32 11 80    	mov    0x80113288,%edx
{
8010422d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104230:	83 fa 1d             	cmp    $0x1d,%edx
80104233:	0f 8f 85 00 00 00    	jg     801042be <log_write+0x9e>
80104239:	a1 78 32 11 80       	mov    0x80113278,%eax
8010423e:	83 e8 01             	sub    $0x1,%eax
80104241:	39 c2                	cmp    %eax,%edx
80104243:	7d 79                	jge    801042be <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104245:	a1 7c 32 11 80       	mov    0x8011327c,%eax
8010424a:	85 c0                	test   %eax,%eax
8010424c:	7e 7d                	jle    801042cb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010424e:	83 ec 0c             	sub    $0xc,%esp
80104251:	68 40 32 11 80       	push   $0x80113240
80104256:	e8 25 16 00 00       	call   80105880 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010425b:	8b 15 88 32 11 80    	mov    0x80113288,%edx
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	85 d2                	test   %edx,%edx
80104266:	7e 4a                	jle    801042b2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104268:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010426b:	31 c0                	xor    %eax,%eax
8010426d:	eb 08                	jmp    80104277 <log_write+0x57>
8010426f:	90                   	nop
80104270:	83 c0 01             	add    $0x1,%eax
80104273:	39 c2                	cmp    %eax,%edx
80104275:	74 29                	je     801042a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104277:	39 0c 85 8c 32 11 80 	cmp    %ecx,-0x7feecd74(,%eax,4)
8010427e:	75 f0                	jne    80104270 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104280:	89 0c 85 8c 32 11 80 	mov    %ecx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80104287:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010428a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010428d:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
80104294:	c9                   	leave  
  release(&log.lock);
80104295:	e9 86 15 00 00       	jmp    80105820 <release>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801042a0:	89 0c 95 8c 32 11 80 	mov    %ecx,-0x7feecd74(,%edx,4)
    log.lh.n++;
801042a7:	83 c2 01             	add    $0x1,%edx
801042aa:	89 15 88 32 11 80    	mov    %edx,0x80113288
801042b0:	eb d5                	jmp    80104287 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801042b2:	8b 43 08             	mov    0x8(%ebx),%eax
801042b5:	a3 8c 32 11 80       	mov    %eax,0x8011328c
  if (i == log.lh.n)
801042ba:	75 cb                	jne    80104287 <log_write+0x67>
801042bc:	eb e9                	jmp    801042a7 <log_write+0x87>
    panic("too big a transaction");
801042be:	83 ec 0c             	sub    $0xc,%esp
801042c1:	68 73 89 10 80       	push   $0x80108973
801042c6:	e8 95 c1 ff ff       	call   80100460 <panic>
    panic("log_write outside of trans");
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	68 89 89 10 80       	push   $0x80108989
801042d3:	e8 88 c1 ff ff       	call   80100460 <panic>
801042d8:	66 90                	xchg   %ax,%ax
801042da:	66 90                	xchg   %ax,%ax
801042dc:	66 90                	xchg   %ax,%ax
801042de:	66 90                	xchg   %ax,%ax

801042e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801042e7:	e8 44 09 00 00       	call   80104c30 <cpuid>
801042ec:	89 c3                	mov    %eax,%ebx
801042ee:	e8 3d 09 00 00       	call   80104c30 <cpuid>
801042f3:	83 ec 04             	sub    $0x4,%esp
801042f6:	53                   	push   %ebx
801042f7:	50                   	push   %eax
801042f8:	68 a4 89 10 80       	push   $0x801089a4
801042fd:	e8 de c4 ff ff       	call   801007e0 <cprintf>
  idtinit();       // load idt register
80104302:	e8 b9 28 00 00       	call   80106bc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104307:	e8 c4 08 00 00       	call   80104bd0 <mycpu>
8010430c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010430e:	b8 01 00 00 00       	mov    $0x1,%eax
80104313:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010431a:	e8 f1 0b 00 00       	call   80104f10 <scheduler>
8010431f:	90                   	nop

80104320 <mpenter>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104326:	e8 85 39 00 00       	call   80107cb0 <switchkvm>
  seginit();
8010432b:	e8 f0 38 00 00       	call   80107c20 <seginit>
  lapicinit();
80104330:	e8 9b f7 ff ff       	call   80103ad0 <lapicinit>
  mpmain();
80104335:	e8 a6 ff ff ff       	call   801042e0 <mpmain>
8010433a:	66 90                	xchg   %ax,%ax
8010433c:	66 90                	xchg   %ax,%ax
8010433e:	66 90                	xchg   %ax,%ax

80104340 <main>:
{
80104340:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104344:	83 e4 f0             	and    $0xfffffff0,%esp
80104347:	ff 71 fc             	push   -0x4(%ecx)
8010434a:	55                   	push   %ebp
8010434b:	89 e5                	mov    %esp,%ebp
8010434d:	53                   	push   %ebx
8010434e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010434f:	83 ec 08             	sub    $0x8,%esp
80104352:	68 00 00 40 80       	push   $0x80400000
80104357:	68 70 70 11 80       	push   $0x80117070
8010435c:	e8 8f f5 ff ff       	call   801038f0 <kinit1>
  kvmalloc();      // kernel page table
80104361:	e8 3a 3e 00 00       	call   801081a0 <kvmalloc>
  mpinit();        // detect other processors
80104366:	e8 85 01 00 00       	call   801044f0 <mpinit>
  lapicinit();     // interrupt controller
8010436b:	e8 60 f7 ff ff       	call   80103ad0 <lapicinit>
  seginit();       // segment descriptors
80104370:	e8 ab 38 00 00       	call   80107c20 <seginit>
  picinit();       // disable pic
80104375:	e8 76 03 00 00       	call   801046f0 <picinit>
  ioapicinit();    // another interrupt controller
8010437a:	e8 31 f3 ff ff       	call   801036b0 <ioapicinit>
  consoleinit();   // console hardware
8010437f:	e8 ac ce ff ff       	call   80101230 <consoleinit>
  uartinit();      // serial port
80104384:	e8 27 2b 00 00       	call   80106eb0 <uartinit>
  pinit();         // process table
80104389:	e8 22 08 00 00       	call   80104bb0 <pinit>
  tvinit();        // trap vectors
8010438e:	e8 ad 27 00 00       	call   80106b40 <tvinit>
  binit();         // buffer cache
80104393:	e8 a8 bc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80104398:	e8 53 dd ff ff       	call   801020f0 <fileinit>
  ideinit();       // disk 
8010439d:	e8 fe f0 ff ff       	call   801034a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801043a2:	83 c4 0c             	add    $0xc,%esp
801043a5:	68 8a 00 00 00       	push   $0x8a
801043aa:	68 8c b4 10 80       	push   $0x8010b48c
801043af:	68 00 70 00 80       	push   $0x80007000
801043b4:	e8 27 16 00 00       	call   801059e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801043b9:	83 c4 10             	add    $0x10,%esp
801043bc:	69 05 24 33 11 80 b0 	imul   $0xb0,0x80113324,%eax
801043c3:	00 00 00 
801043c6:	05 40 33 11 80       	add    $0x80113340,%eax
801043cb:	3d 40 33 11 80       	cmp    $0x80113340,%eax
801043d0:	76 7e                	jbe    80104450 <main+0x110>
801043d2:	bb 40 33 11 80       	mov    $0x80113340,%ebx
801043d7:	eb 20                	jmp    801043f9 <main+0xb9>
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e0:	69 05 24 33 11 80 b0 	imul   $0xb0,0x80113324,%eax
801043e7:	00 00 00 
801043ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801043f0:	05 40 33 11 80       	add    $0x80113340,%eax
801043f5:	39 c3                	cmp    %eax,%ebx
801043f7:	73 57                	jae    80104450 <main+0x110>
    if(c == mycpu())  // We've started already.
801043f9:	e8 d2 07 00 00       	call   80104bd0 <mycpu>
801043fe:	39 c3                	cmp    %eax,%ebx
80104400:	74 de                	je     801043e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104402:	e8 59 f5 ff ff       	call   80103960 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104407:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010440a:	c7 05 f8 6f 00 80 20 	movl   $0x80104320,0x80006ff8
80104411:	43 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104414:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010441b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010441e:	05 00 10 00 00       	add    $0x1000,%eax
80104423:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104428:	0f b6 03             	movzbl (%ebx),%eax
8010442b:	68 00 70 00 00       	push   $0x7000
80104430:	50                   	push   %eax
80104431:	e8 ea f7 ff ff       	call   80103c20 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104436:	83 c4 10             	add    $0x10,%esp
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104440:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104446:	85 c0                	test   %eax,%eax
80104448:	74 f6                	je     80104440 <main+0x100>
8010444a:	eb 94                	jmp    801043e0 <main+0xa0>
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104450:	83 ec 08             	sub    $0x8,%esp
80104453:	68 00 00 00 8e       	push   $0x8e000000
80104458:	68 00 00 40 80       	push   $0x80400000
8010445d:	e8 2e f4 ff ff       	call   80103890 <kinit2>
  userinit();      // first user process
80104462:	e8 19 08 00 00       	call   80104c80 <userinit>
  mpmain();        // finish this processor's setup
80104467:	e8 74 fe ff ff       	call   801042e0 <mpmain>
8010446c:	66 90                	xchg   %ax,%ax
8010446e:	66 90                	xchg   %ax,%ax

80104470 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80104475:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010447b:	53                   	push   %ebx
  e = addr+len;
8010447c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010447f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80104482:	39 de                	cmp    %ebx,%esi
80104484:	72 10                	jb     80104496 <mpsearch1+0x26>
80104486:	eb 50                	jmp    801044d8 <mpsearch1+0x68>
80104488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448f:	90                   	nop
80104490:	89 fe                	mov    %edi,%esi
80104492:	39 fb                	cmp    %edi,%ebx
80104494:	76 42                	jbe    801044d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104496:	83 ec 04             	sub    $0x4,%esp
80104499:	8d 7e 10             	lea    0x10(%esi),%edi
8010449c:	6a 04                	push   $0x4
8010449e:	68 b8 89 10 80       	push   $0x801089b8
801044a3:	56                   	push   %esi
801044a4:	e8 e7 14 00 00       	call   80105990 <memcmp>
801044a9:	83 c4 10             	add    $0x10,%esp
801044ac:	85 c0                	test   %eax,%eax
801044ae:	75 e0                	jne    80104490 <mpsearch1+0x20>
801044b0:	89 f2                	mov    %esi,%edx
801044b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801044b8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801044bb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801044be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801044c0:	39 fa                	cmp    %edi,%edx
801044c2:	75 f4                	jne    801044b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801044c4:	84 c0                	test   %al,%al
801044c6:	75 c8                	jne    80104490 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801044c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cb:	89 f0                	mov    %esi,%eax
801044cd:	5b                   	pop    %ebx
801044ce:	5e                   	pop    %esi
801044cf:	5f                   	pop    %edi
801044d0:	5d                   	pop    %ebp
801044d1:	c3                   	ret    
801044d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801044db:	31 f6                	xor    %esi,%esi
}
801044dd:	5b                   	pop    %ebx
801044de:	89 f0                	mov    %esi,%eax
801044e0:	5e                   	pop    %esi
801044e1:	5f                   	pop    %edi
801044e2:	5d                   	pop    %ebp
801044e3:	c3                   	ret    
801044e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044ef:	90                   	nop

801044f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
801044f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801044f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104500:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104507:	c1 e0 08             	shl    $0x8,%eax
8010450a:	09 d0                	or     %edx,%eax
8010450c:	c1 e0 04             	shl    $0x4,%eax
8010450f:	75 1b                	jne    8010452c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104511:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104518:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010451f:	c1 e0 08             	shl    $0x8,%eax
80104522:	09 d0                	or     %edx,%eax
80104524:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104527:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010452c:	ba 00 04 00 00       	mov    $0x400,%edx
80104531:	e8 3a ff ff ff       	call   80104470 <mpsearch1>
80104536:	89 c3                	mov    %eax,%ebx
80104538:	85 c0                	test   %eax,%eax
8010453a:	0f 84 40 01 00 00    	je     80104680 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104540:	8b 73 04             	mov    0x4(%ebx),%esi
80104543:	85 f6                	test   %esi,%esi
80104545:	0f 84 25 01 00 00    	je     80104670 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010454b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010454e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80104554:	6a 04                	push   $0x4
80104556:	68 bd 89 10 80       	push   $0x801089bd
8010455b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010455c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010455f:	e8 2c 14 00 00       	call   80105990 <memcmp>
80104564:	83 c4 10             	add    $0x10,%esp
80104567:	85 c0                	test   %eax,%eax
80104569:	0f 85 01 01 00 00    	jne    80104670 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010456f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80104576:	3c 01                	cmp    $0x1,%al
80104578:	74 08                	je     80104582 <mpinit+0x92>
8010457a:	3c 04                	cmp    $0x4,%al
8010457c:	0f 85 ee 00 00 00    	jne    80104670 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80104582:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80104589:	66 85 d2             	test   %dx,%dx
8010458c:	74 22                	je     801045b0 <mpinit+0xc0>
8010458e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80104591:	89 f0                	mov    %esi,%eax
  sum = 0;
80104593:	31 d2                	xor    %edx,%edx
80104595:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104598:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010459f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801045a2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801045a4:	39 c7                	cmp    %eax,%edi
801045a6:	75 f0                	jne    80104598 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801045a8:	84 d2                	test   %dl,%dl
801045aa:	0f 85 c0 00 00 00    	jne    80104670 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801045b0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801045b6:	a3 20 32 11 80       	mov    %eax,0x80113220
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045bb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801045c2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801045c8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045cd:	03 55 e4             	add    -0x1c(%ebp),%edx
801045d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801045d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d7:	90                   	nop
801045d8:	39 d0                	cmp    %edx,%eax
801045da:	73 15                	jae    801045f1 <mpinit+0x101>
    switch(*p){
801045dc:	0f b6 08             	movzbl (%eax),%ecx
801045df:	80 f9 02             	cmp    $0x2,%cl
801045e2:	74 4c                	je     80104630 <mpinit+0x140>
801045e4:	77 3a                	ja     80104620 <mpinit+0x130>
801045e6:	84 c9                	test   %cl,%cl
801045e8:	74 56                	je     80104640 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801045ea:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045ed:	39 d0                	cmp    %edx,%eax
801045ef:	72 eb                	jb     801045dc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801045f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801045f4:	85 f6                	test   %esi,%esi
801045f6:	0f 84 d9 00 00 00    	je     801046d5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801045fc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104600:	74 15                	je     80104617 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104602:	b8 70 00 00 00       	mov    $0x70,%eax
80104607:	ba 22 00 00 00       	mov    $0x22,%edx
8010460c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010460d:	ba 23 00 00 00       	mov    $0x23,%edx
80104612:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104613:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104616:	ee                   	out    %al,(%dx)
  }
}
80104617:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010461a:	5b                   	pop    %ebx
8010461b:	5e                   	pop    %esi
8010461c:	5f                   	pop    %edi
8010461d:	5d                   	pop    %ebp
8010461e:	c3                   	ret    
8010461f:	90                   	nop
    switch(*p){
80104620:	83 e9 03             	sub    $0x3,%ecx
80104623:	80 f9 01             	cmp    $0x1,%cl
80104626:	76 c2                	jbe    801045ea <mpinit+0xfa>
80104628:	31 f6                	xor    %esi,%esi
8010462a:	eb ac                	jmp    801045d8 <mpinit+0xe8>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104630:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104634:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104637:	88 0d 20 33 11 80    	mov    %cl,0x80113320
      continue;
8010463d:	eb 99                	jmp    801045d8 <mpinit+0xe8>
8010463f:	90                   	nop
      if(ncpu < NCPU) {
80104640:	8b 0d 24 33 11 80    	mov    0x80113324,%ecx
80104646:	83 f9 07             	cmp    $0x7,%ecx
80104649:	7f 19                	jg     80104664 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010464b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80104651:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104655:	83 c1 01             	add    $0x1,%ecx
80104658:	89 0d 24 33 11 80    	mov    %ecx,0x80113324
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010465e:	88 9f 40 33 11 80    	mov    %bl,-0x7feeccc0(%edi)
      p += sizeof(struct mpproc);
80104664:	83 c0 14             	add    $0x14,%eax
      continue;
80104667:	e9 6c ff ff ff       	jmp    801045d8 <mpinit+0xe8>
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80104670:	83 ec 0c             	sub    $0xc,%esp
80104673:	68 c2 89 10 80       	push   $0x801089c2
80104678:	e8 e3 bd ff ff       	call   80100460 <panic>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
{
80104680:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80104685:	eb 13                	jmp    8010469a <mpinit+0x1aa>
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80104690:	89 f3                	mov    %esi,%ebx
80104692:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80104698:	74 d6                	je     80104670 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010469a:	83 ec 04             	sub    $0x4,%esp
8010469d:	8d 73 10             	lea    0x10(%ebx),%esi
801046a0:	6a 04                	push   $0x4
801046a2:	68 b8 89 10 80       	push   $0x801089b8
801046a7:	53                   	push   %ebx
801046a8:	e8 e3 12 00 00       	call   80105990 <memcmp>
801046ad:	83 c4 10             	add    $0x10,%esp
801046b0:	85 c0                	test   %eax,%eax
801046b2:	75 dc                	jne    80104690 <mpinit+0x1a0>
801046b4:	89 da                	mov    %ebx,%edx
801046b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801046c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801046c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801046c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801046c8:	39 d6                	cmp    %edx,%esi
801046ca:	75 f4                	jne    801046c0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801046cc:	84 c0                	test   %al,%al
801046ce:	75 c0                	jne    80104690 <mpinit+0x1a0>
801046d0:	e9 6b fe ff ff       	jmp    80104540 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801046d5:	83 ec 0c             	sub    $0xc,%esp
801046d8:	68 dc 89 10 80       	push   $0x801089dc
801046dd:	e8 7e bd ff ff       	call   80100460 <panic>
801046e2:	66 90                	xchg   %ax,%ax
801046e4:	66 90                	xchg   %ax,%ax
801046e6:	66 90                	xchg   %ax,%ax
801046e8:	66 90                	xchg   %ax,%ax
801046ea:	66 90                	xchg   %ax,%ax
801046ec:	66 90                	xchg   %ax,%ax
801046ee:	66 90                	xchg   %ax,%ax

801046f0 <picinit>:
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f5:	ba 21 00 00 00       	mov    $0x21,%edx
801046fa:	ee                   	out    %al,(%dx)
801046fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80104700:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104701:	c3                   	ret    
80104702:	66 90                	xchg   %ax,%ax
80104704:	66 90                	xchg   %ax,%ax
80104706:	66 90                	xchg   %ax,%ax
80104708:	66 90                	xchg   %ax,%ax
8010470a:	66 90                	xchg   %ax,%ax
8010470c:	66 90                	xchg   %ax,%ax
8010470e:	66 90                	xchg   %ax,%ax

80104710 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 0c             	sub    $0xc,%esp
80104719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010471c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010471f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104725:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010472b:	e8 e0 d9 ff ff       	call   80102110 <filealloc>
80104730:	89 03                	mov    %eax,(%ebx)
80104732:	85 c0                	test   %eax,%eax
80104734:	0f 84 a8 00 00 00    	je     801047e2 <pipealloc+0xd2>
8010473a:	e8 d1 d9 ff ff       	call   80102110 <filealloc>
8010473f:	89 06                	mov    %eax,(%esi)
80104741:	85 c0                	test   %eax,%eax
80104743:	0f 84 87 00 00 00    	je     801047d0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104749:	e8 12 f2 ff ff       	call   80103960 <kalloc>
8010474e:	89 c7                	mov    %eax,%edi
80104750:	85 c0                	test   %eax,%eax
80104752:	0f 84 b0 00 00 00    	je     80104808 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80104758:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010475f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104762:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104765:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010476c:	00 00 00 
  p->nwrite = 0;
8010476f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104776:	00 00 00 
  p->nread = 0;
80104779:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104780:	00 00 00 
  initlock(&p->lock, "pipe");
80104783:	68 fb 89 10 80       	push   $0x801089fb
80104788:	50                   	push   %eax
80104789:	e8 22 0f 00 00       	call   801056b0 <initlock>
  (*f0)->type = FD_PIPE;
8010478e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80104790:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104793:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104799:	8b 03                	mov    (%ebx),%eax
8010479b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010479f:	8b 03                	mov    (%ebx),%eax
801047a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801047a5:	8b 03                	mov    (%ebx),%eax
801047a7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801047aa:	8b 06                	mov    (%esi),%eax
801047ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801047b2:	8b 06                	mov    (%esi),%eax
801047b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801047b8:	8b 06                	mov    (%esi),%eax
801047ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801047be:	8b 06                	mov    (%esi),%eax
801047c0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801047c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801047c6:	31 c0                	xor    %eax,%eax
}
801047c8:	5b                   	pop    %ebx
801047c9:	5e                   	pop    %esi
801047ca:	5f                   	pop    %edi
801047cb:	5d                   	pop    %ebp
801047cc:	c3                   	ret    
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801047d0:	8b 03                	mov    (%ebx),%eax
801047d2:	85 c0                	test   %eax,%eax
801047d4:	74 1e                	je     801047f4 <pipealloc+0xe4>
    fileclose(*f0);
801047d6:	83 ec 0c             	sub    $0xc,%esp
801047d9:	50                   	push   %eax
801047da:	e8 f1 d9 ff ff       	call   801021d0 <fileclose>
801047df:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801047e2:	8b 06                	mov    (%esi),%eax
801047e4:	85 c0                	test   %eax,%eax
801047e6:	74 0c                	je     801047f4 <pipealloc+0xe4>
    fileclose(*f1);
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	50                   	push   %eax
801047ec:	e8 df d9 ff ff       	call   801021d0 <fileclose>
801047f1:	83 c4 10             	add    $0x10,%esp
}
801047f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801047f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047fc:	5b                   	pop    %ebx
801047fd:	5e                   	pop    %esi
801047fe:	5f                   	pop    %edi
801047ff:	5d                   	pop    %ebp
80104800:	c3                   	ret    
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104808:	8b 03                	mov    (%ebx),%eax
8010480a:	85 c0                	test   %eax,%eax
8010480c:	75 c8                	jne    801047d6 <pipealloc+0xc6>
8010480e:	eb d2                	jmp    801047e2 <pipealloc+0xd2>

80104810 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104818:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	53                   	push   %ebx
8010481f:	e8 5c 10 00 00       	call   80105880 <acquire>
  if(writable){
80104824:	83 c4 10             	add    $0x10,%esp
80104827:	85 f6                	test   %esi,%esi
80104829:	74 65                	je     80104890 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010482b:	83 ec 0c             	sub    $0xc,%esp
8010482e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104834:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010483b:	00 00 00 
    wakeup(&p->nread);
8010483e:	50                   	push   %eax
8010483f:	e8 9c 0b 00 00       	call   801053e0 <wakeup>
80104844:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104847:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010484d:	85 d2                	test   %edx,%edx
8010484f:	75 0a                	jne    8010485b <pipeclose+0x4b>
80104851:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104857:	85 c0                	test   %eax,%eax
80104859:	74 15                	je     80104870 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010485b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010485e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104861:	5b                   	pop    %ebx
80104862:	5e                   	pop    %esi
80104863:	5d                   	pop    %ebp
    release(&p->lock);
80104864:	e9 b7 0f 00 00       	jmp    80105820 <release>
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	53                   	push   %ebx
80104874:	e8 a7 0f 00 00       	call   80105820 <release>
    kfree((char*)p);
80104879:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010487c:	83 c4 10             	add    $0x10,%esp
}
8010487f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104882:	5b                   	pop    %ebx
80104883:	5e                   	pop    %esi
80104884:	5d                   	pop    %ebp
    kfree((char*)p);
80104885:	e9 16 ef ff ff       	jmp    801037a0 <kfree>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104899:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801048a0:	00 00 00 
    wakeup(&p->nwrite);
801048a3:	50                   	push   %eax
801048a4:	e8 37 0b 00 00       	call   801053e0 <wakeup>
801048a9:	83 c4 10             	add    $0x10,%esp
801048ac:	eb 99                	jmp    80104847 <pipeclose+0x37>
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	56                   	push   %esi
801048b5:	53                   	push   %ebx
801048b6:	83 ec 28             	sub    $0x28,%esp
801048b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801048bc:	53                   	push   %ebx
801048bd:	e8 be 0f 00 00       	call   80105880 <acquire>
  for(i = 0; i < n; i++){
801048c2:	8b 45 10             	mov    0x10(%ebp),%eax
801048c5:	83 c4 10             	add    $0x10,%esp
801048c8:	85 c0                	test   %eax,%eax
801048ca:	0f 8e c0 00 00 00    	jle    80104990 <pipewrite+0xe0>
801048d0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801048d3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801048d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801048df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801048e2:	03 45 10             	add    0x10(%ebp),%eax
801048e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801048e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801048ee:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801048f4:	89 ca                	mov    %ecx,%edx
801048f6:	05 00 02 00 00       	add    $0x200,%eax
801048fb:	39 c1                	cmp    %eax,%ecx
801048fd:	74 3f                	je     8010493e <pipewrite+0x8e>
801048ff:	eb 67                	jmp    80104968 <pipewrite+0xb8>
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104908:	e8 43 03 00 00       	call   80104c50 <myproc>
8010490d:	8b 48 24             	mov    0x24(%eax),%ecx
80104910:	85 c9                	test   %ecx,%ecx
80104912:	75 34                	jne    80104948 <pipewrite+0x98>
      wakeup(&p->nread);
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	57                   	push   %edi
80104918:	e8 c3 0a 00 00       	call   801053e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010491d:	58                   	pop    %eax
8010491e:	5a                   	pop    %edx
8010491f:	53                   	push   %ebx
80104920:	56                   	push   %esi
80104921:	e8 fa 09 00 00       	call   80105320 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104926:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010492c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104932:	83 c4 10             	add    $0x10,%esp
80104935:	05 00 02 00 00       	add    $0x200,%eax
8010493a:	39 c2                	cmp    %eax,%edx
8010493c:	75 2a                	jne    80104968 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010493e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104944:	85 c0                	test   %eax,%eax
80104946:	75 c0                	jne    80104908 <pipewrite+0x58>
        release(&p->lock);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	53                   	push   %ebx
8010494c:	e8 cf 0e 00 00       	call   80105820 <release>
        return -1;
80104951:	83 c4 10             	add    $0x10,%esp
80104954:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010495c:	5b                   	pop    %ebx
8010495d:	5e                   	pop    %esi
8010495e:	5f                   	pop    %edi
8010495f:	5d                   	pop    %ebp
80104960:	c3                   	ret    
80104961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104968:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010496b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010496e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104974:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010497a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010497d:	83 c6 01             	add    $0x1,%esi
80104980:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104983:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104987:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010498a:	0f 85 58 ff ff ff    	jne    801048e8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104990:	83 ec 0c             	sub    $0xc,%esp
80104993:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104999:	50                   	push   %eax
8010499a:	e8 41 0a 00 00       	call   801053e0 <wakeup>
  release(&p->lock);
8010499f:	89 1c 24             	mov    %ebx,(%esp)
801049a2:	e8 79 0e 00 00       	call   80105820 <release>
  return n;
801049a7:	8b 45 10             	mov    0x10(%ebp),%eax
801049aa:	83 c4 10             	add    $0x10,%esp
801049ad:	eb aa                	jmp    80104959 <pipewrite+0xa9>
801049af:	90                   	nop

801049b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	53                   	push   %ebx
801049b6:	83 ec 18             	sub    $0x18,%esp
801049b9:	8b 75 08             	mov    0x8(%ebp),%esi
801049bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801049bf:	56                   	push   %esi
801049c0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801049c6:	e8 b5 0e 00 00       	call   80105880 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801049cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801049da:	74 2f                	je     80104a0b <piperead+0x5b>
801049dc:	eb 37                	jmp    80104a15 <piperead+0x65>
801049de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801049e0:	e8 6b 02 00 00       	call   80104c50 <myproc>
801049e5:	8b 48 24             	mov    0x24(%eax),%ecx
801049e8:	85 c9                	test   %ecx,%ecx
801049ea:	0f 85 80 00 00 00    	jne    80104a70 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801049f0:	83 ec 08             	sub    $0x8,%esp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	e8 26 09 00 00       	call   80105320 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801049fa:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104a00:	83 c4 10             	add    $0x10,%esp
80104a03:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104a09:	75 0a                	jne    80104a15 <piperead+0x65>
80104a0b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104a11:	85 c0                	test   %eax,%eax
80104a13:	75 cb                	jne    801049e0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104a15:	8b 55 10             	mov    0x10(%ebp),%edx
80104a18:	31 db                	xor    %ebx,%ebx
80104a1a:	85 d2                	test   %edx,%edx
80104a1c:	7f 20                	jg     80104a3e <piperead+0x8e>
80104a1e:	eb 2c                	jmp    80104a4c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104a20:	8d 48 01             	lea    0x1(%eax),%ecx
80104a23:	25 ff 01 00 00       	and    $0x1ff,%eax
80104a28:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104a2e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104a33:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104a36:	83 c3 01             	add    $0x1,%ebx
80104a39:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104a3c:	74 0e                	je     80104a4c <piperead+0x9c>
    if(p->nread == p->nwrite)
80104a3e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104a44:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104a4a:	75 d4                	jne    80104a20 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104a55:	50                   	push   %eax
80104a56:	e8 85 09 00 00       	call   801053e0 <wakeup>
  release(&p->lock);
80104a5b:	89 34 24             	mov    %esi,(%esp)
80104a5e:	e8 bd 0d 00 00       	call   80105820 <release>
  return i;
80104a63:	83 c4 10             	add    $0x10,%esp
}
80104a66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a69:	89 d8                	mov    %ebx,%eax
80104a6b:	5b                   	pop    %ebx
80104a6c:	5e                   	pop    %esi
80104a6d:	5f                   	pop    %edi
80104a6e:	5d                   	pop    %ebp
80104a6f:	c3                   	ret    
      release(&p->lock);
80104a70:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104a78:	56                   	push   %esi
80104a79:	e8 a2 0d 00 00       	call   80105820 <release>
      return -1;
80104a7e:	83 c4 10             	add    $0x10,%esp
}
80104a81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a84:	89 d8                	mov    %ebx,%eax
80104a86:	5b                   	pop    %ebx
80104a87:	5e                   	pop    %esi
80104a88:	5f                   	pop    %edi
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	66 90                	xchg   %ax,%ax
80104a8d:	66 90                	xchg   %ax,%ax
80104a8f:	90                   	nop

80104a90 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a94:	bb f4 38 11 80       	mov    $0x801138f4,%ebx
{
80104a99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104a9c:	68 c0 38 11 80       	push   $0x801138c0
80104aa1:	e8 da 0d 00 00       	call   80105880 <acquire>
80104aa6:	83 c4 10             	add    $0x10,%esp
80104aa9:	eb 10                	jmp    80104abb <allocproc+0x2b>
80104aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ab0:	83 c3 7c             	add    $0x7c,%ebx
80104ab3:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
80104ab9:	74 75                	je     80104b30 <allocproc+0xa0>
    if(p->state == UNUSED)
80104abb:	8b 43 0c             	mov    0xc(%ebx),%eax
80104abe:	85 c0                	test   %eax,%eax
80104ac0:	75 ee                	jne    80104ab0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104ac2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104ac7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104aca:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104ad1:	89 43 10             	mov    %eax,0x10(%ebx)
80104ad4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104ad7:	68 c0 38 11 80       	push   $0x801138c0
  p->pid = nextpid++;
80104adc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104ae2:	e8 39 0d 00 00       	call   80105820 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104ae7:	e8 74 ee ff ff       	call   80103960 <kalloc>
80104aec:	83 c4 10             	add    $0x10,%esp
80104aef:	89 43 08             	mov    %eax,0x8(%ebx)
80104af2:	85 c0                	test   %eax,%eax
80104af4:	74 53                	je     80104b49 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104af6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104afc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104aff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104b04:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104b07:	c7 40 14 32 6b 10 80 	movl   $0x80106b32,0x14(%eax)
  p->context = (struct context*)sp;
80104b0e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104b11:	6a 14                	push   $0x14
80104b13:	6a 00                	push   $0x0
80104b15:	50                   	push   %eax
80104b16:	e8 25 0e 00 00       	call   80105940 <memset>
  p->context->eip = (uint)forkret;
80104b1b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80104b1e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104b21:	c7 40 10 60 4b 10 80 	movl   $0x80104b60,0x10(%eax)
}
80104b28:	89 d8                	mov    %ebx,%eax
80104b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2d:	c9                   	leave  
80104b2e:	c3                   	ret    
80104b2f:	90                   	nop
  release(&ptable.lock);
80104b30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104b33:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104b35:	68 c0 38 11 80       	push   $0x801138c0
80104b3a:	e8 e1 0c 00 00       	call   80105820 <release>
}
80104b3f:	89 d8                	mov    %ebx,%eax
  return 0;
80104b41:	83 c4 10             	add    $0x10,%esp
}
80104b44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b47:	c9                   	leave  
80104b48:	c3                   	ret    
    p->state = UNUSED;
80104b49:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104b50:	31 db                	xor    %ebx,%ebx
}
80104b52:	89 d8                	mov    %ebx,%eax
80104b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b57:	c9                   	leave  
80104b58:	c3                   	ret    
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b60 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b66:	68 c0 38 11 80       	push   $0x801138c0
80104b6b:	e8 b0 0c 00 00       	call   80105820 <release>

  if (first) {
80104b70:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104b75:	83 c4 10             	add    $0x10,%esp
80104b78:	85 c0                	test   %eax,%eax
80104b7a:	75 04                	jne    80104b80 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104b7c:	c9                   	leave  
80104b7d:	c3                   	ret    
80104b7e:	66 90                	xchg   %ax,%ax
    first = 0;
80104b80:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80104b87:	00 00 00 
    iinit(ROOTDEV);
80104b8a:	83 ec 0c             	sub    $0xc,%esp
80104b8d:	6a 01                	push   $0x1
80104b8f:	e8 ac dc ff ff       	call   80102840 <iinit>
    initlog(ROOTDEV);
80104b94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b9b:	e8 00 f4 ff ff       	call   80103fa0 <initlog>
}
80104ba0:	83 c4 10             	add    $0x10,%esp
80104ba3:	c9                   	leave  
80104ba4:	c3                   	ret    
80104ba5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <pinit>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104bb6:	68 00 8a 10 80       	push   $0x80108a00
80104bbb:	68 c0 38 11 80       	push   $0x801138c0
80104bc0:	e8 eb 0a 00 00       	call   801056b0 <initlock>
}
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <mycpu>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bd5:	9c                   	pushf  
80104bd6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bd7:	f6 c4 02             	test   $0x2,%ah
80104bda:	75 46                	jne    80104c22 <mycpu+0x52>
  apicid = lapicid();
80104bdc:	e8 ef ef ff ff       	call   80103bd0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104be1:	8b 35 24 33 11 80    	mov    0x80113324,%esi
80104be7:	85 f6                	test   %esi,%esi
80104be9:	7e 2a                	jle    80104c15 <mycpu+0x45>
80104beb:	31 d2                	xor    %edx,%edx
80104bed:	eb 08                	jmp    80104bf7 <mycpu+0x27>
80104bef:	90                   	nop
80104bf0:	83 c2 01             	add    $0x1,%edx
80104bf3:	39 f2                	cmp    %esi,%edx
80104bf5:	74 1e                	je     80104c15 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104bf7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104bfd:	0f b6 99 40 33 11 80 	movzbl -0x7feeccc0(%ecx),%ebx
80104c04:	39 c3                	cmp    %eax,%ebx
80104c06:	75 e8                	jne    80104bf0 <mycpu+0x20>
}
80104c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104c0b:	8d 81 40 33 11 80    	lea    -0x7feeccc0(%ecx),%eax
}
80104c11:	5b                   	pop    %ebx
80104c12:	5e                   	pop    %esi
80104c13:	5d                   	pop    %ebp
80104c14:	c3                   	ret    
  panic("unknown apicid\n");
80104c15:	83 ec 0c             	sub    $0xc,%esp
80104c18:	68 07 8a 10 80       	push   $0x80108a07
80104c1d:	e8 3e b8 ff ff       	call   80100460 <panic>
    panic("mycpu called with interrupts enabled\n");
80104c22:	83 ec 0c             	sub    $0xc,%esp
80104c25:	68 e4 8a 10 80       	push   $0x80108ae4
80104c2a:	e8 31 b8 ff ff       	call   80100460 <panic>
80104c2f:	90                   	nop

80104c30 <cpuid>:
cpuid() {
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104c36:	e8 95 ff ff ff       	call   80104bd0 <mycpu>
}
80104c3b:	c9                   	leave  
  return mycpu()-cpus;
80104c3c:	2d 40 33 11 80       	sub    $0x80113340,%eax
80104c41:	c1 f8 04             	sar    $0x4,%eax
80104c44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104c4a:	c3                   	ret    
80104c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop

80104c50 <myproc>:
myproc(void) {
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104c57:	e8 d4 0a 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104c5c:	e8 6f ff ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
80104c61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c67:	e8 14 0b 00 00       	call   80105780 <popcli>
}
80104c6c:	89 d8                	mov    %ebx,%eax
80104c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c71:	c9                   	leave  
80104c72:	c3                   	ret    
80104c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <userinit>:
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104c87:	e8 04 fe ff ff       	call   80104a90 <allocproc>
80104c8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104c8e:	a3 f4 57 11 80       	mov    %eax,0x801157f4
  if((p->pgdir = setupkvm()) == 0)
80104c93:	e8 88 34 00 00       	call   80108120 <setupkvm>
80104c98:	89 43 04             	mov    %eax,0x4(%ebx)
80104c9b:	85 c0                	test   %eax,%eax
80104c9d:	0f 84 bd 00 00 00    	je     80104d60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104ca3:	83 ec 04             	sub    $0x4,%esp
80104ca6:	68 2c 00 00 00       	push   $0x2c
80104cab:	68 60 b4 10 80       	push   $0x8010b460
80104cb0:	50                   	push   %eax
80104cb1:	e8 1a 31 00 00       	call   80107dd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104cb6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104cb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104cbf:	6a 4c                	push   $0x4c
80104cc1:	6a 00                	push   $0x0
80104cc3:	ff 73 18             	push   0x18(%ebx)
80104cc6:	e8 75 0c 00 00       	call   80105940 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104ccb:	8b 43 18             	mov    0x18(%ebx),%eax
80104cce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104cd3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104cd6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104cdb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104cdf:	8b 43 18             	mov    0x18(%ebx),%eax
80104ce2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104ce6:	8b 43 18             	mov    0x18(%ebx),%eax
80104ce9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104ced:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104cf1:	8b 43 18             	mov    0x18(%ebx),%eax
80104cf4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104cf8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104cfc:	8b 43 18             	mov    0x18(%ebx),%eax
80104cff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104d06:	8b 43 18             	mov    0x18(%ebx),%eax
80104d09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104d10:	8b 43 18             	mov    0x18(%ebx),%eax
80104d13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104d1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104d1d:	6a 10                	push   $0x10
80104d1f:	68 30 8a 10 80       	push   $0x80108a30
80104d24:	50                   	push   %eax
80104d25:	e8 d6 0d 00 00       	call   80105b00 <safestrcpy>
  p->cwd = namei("/");
80104d2a:	c7 04 24 39 8a 10 80 	movl   $0x80108a39,(%esp)
80104d31:	e8 4a e6 ff ff       	call   80103380 <namei>
80104d36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104d39:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104d40:	e8 3b 0b 00 00       	call   80105880 <acquire>
  p->state = RUNNABLE;
80104d45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104d4c:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104d53:	e8 c8 0a 00 00       	call   80105820 <release>
}
80104d58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d5b:	83 c4 10             	add    $0x10,%esp
80104d5e:	c9                   	leave  
80104d5f:	c3                   	ret    
    panic("userinit: out of memory?");
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	68 17 8a 10 80       	push   $0x80108a17
80104d68:	e8 f3 b6 ff ff       	call   80100460 <panic>
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <growproc>:
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104d78:	e8 b3 09 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104d7d:	e8 4e fe ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
80104d82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d88:	e8 f3 09 00 00       	call   80105780 <popcli>
  sz = curproc->sz;
80104d8d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104d8f:	85 f6                	test   %esi,%esi
80104d91:	7f 1d                	jg     80104db0 <growproc+0x40>
  } else if(n < 0){
80104d93:	75 3b                	jne    80104dd0 <growproc+0x60>
  switchuvm(curproc);
80104d95:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104d98:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104d9a:	53                   	push   %ebx
80104d9b:	e8 20 2f 00 00       	call   80107cc0 <switchuvm>
  return 0;
80104da0:	83 c4 10             	add    $0x10,%esp
80104da3:	31 c0                	xor    %eax,%eax
}
80104da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da8:	5b                   	pop    %ebx
80104da9:	5e                   	pop    %esi
80104daa:	5d                   	pop    %ebp
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104db0:	83 ec 04             	sub    $0x4,%esp
80104db3:	01 c6                	add    %eax,%esi
80104db5:	56                   	push   %esi
80104db6:	50                   	push   %eax
80104db7:	ff 73 04             	push   0x4(%ebx)
80104dba:	e8 81 31 00 00       	call   80107f40 <allocuvm>
80104dbf:	83 c4 10             	add    $0x10,%esp
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	75 cf                	jne    80104d95 <growproc+0x25>
      return -1;
80104dc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dcb:	eb d8                	jmp    80104da5 <growproc+0x35>
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104dd0:	83 ec 04             	sub    $0x4,%esp
80104dd3:	01 c6                	add    %eax,%esi
80104dd5:	56                   	push   %esi
80104dd6:	50                   	push   %eax
80104dd7:	ff 73 04             	push   0x4(%ebx)
80104dda:	e8 91 32 00 00       	call   80108070 <deallocuvm>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	75 af                	jne    80104d95 <growproc+0x25>
80104de6:	eb de                	jmp    80104dc6 <growproc+0x56>
80104de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop

80104df0 <fork>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
80104df5:	53                   	push   %ebx
80104df6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104df9:	e8 32 09 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104dfe:	e8 cd fd ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
80104e03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e09:	e8 72 09 00 00       	call   80105780 <popcli>
  if((np = allocproc()) == 0){
80104e0e:	e8 7d fc ff ff       	call   80104a90 <allocproc>
80104e13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104e16:	85 c0                	test   %eax,%eax
80104e18:	0f 84 b7 00 00 00    	je     80104ed5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104e1e:	83 ec 08             	sub    $0x8,%esp
80104e21:	ff 33                	push   (%ebx)
80104e23:	89 c7                	mov    %eax,%edi
80104e25:	ff 73 04             	push   0x4(%ebx)
80104e28:	e8 e3 33 00 00       	call   80108210 <copyuvm>
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	89 47 04             	mov    %eax,0x4(%edi)
80104e33:	85 c0                	test   %eax,%eax
80104e35:	0f 84 a1 00 00 00    	je     80104edc <fork+0xec>
  np->sz = curproc->sz;
80104e3b:	8b 03                	mov    (%ebx),%eax
80104e3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104e40:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104e42:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104e45:	89 c8                	mov    %ecx,%eax
80104e47:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104e4a:	b9 13 00 00 00       	mov    $0x13,%ecx
80104e4f:	8b 73 18             	mov    0x18(%ebx),%esi
80104e52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104e54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104e56:	8b 40 18             	mov    0x18(%eax),%eax
80104e59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104e60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104e64:	85 c0                	test   %eax,%eax
80104e66:	74 13                	je     80104e7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	50                   	push   %eax
80104e6c:	e8 0f d3 ff ff       	call   80102180 <filedup>
80104e71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e74:	83 c4 10             	add    $0x10,%esp
80104e77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104e7b:	83 c6 01             	add    $0x1,%esi
80104e7e:	83 fe 10             	cmp    $0x10,%esi
80104e81:	75 dd                	jne    80104e60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104e83:	83 ec 0c             	sub    $0xc,%esp
80104e86:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104e8c:	e8 9f db ff ff       	call   80102a30 <idup>
80104e91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104e97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80104e9d:	6a 10                	push   $0x10
80104e9f:	53                   	push   %ebx
80104ea0:	50                   	push   %eax
80104ea1:	e8 5a 0c 00 00       	call   80105b00 <safestrcpy>
  pid = np->pid;
80104ea6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104ea9:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104eb0:	e8 cb 09 00 00       	call   80105880 <acquire>
  np->state = RUNNABLE;
80104eb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104ebc:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80104ec3:	e8 58 09 00 00       	call   80105820 <release>
  return pid;
80104ec8:	83 c4 10             	add    $0x10,%esp
}
80104ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ece:	89 d8                	mov    %ebx,%eax
80104ed0:	5b                   	pop    %ebx
80104ed1:	5e                   	pop    %esi
80104ed2:	5f                   	pop    %edi
80104ed3:	5d                   	pop    %ebp
80104ed4:	c3                   	ret    
    return -1;
80104ed5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104eda:	eb ef                	jmp    80104ecb <fork+0xdb>
    kfree(np->kstack);
80104edc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	ff 73 08             	push   0x8(%ebx)
80104ee5:	e8 b6 e8 ff ff       	call   801037a0 <kfree>
    np->kstack = 0;
80104eea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104ef1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104ef4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104efb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f00:	eb c9                	jmp    80104ecb <fork+0xdb>
80104f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f10 <scheduler>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
80104f16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104f19:	e8 b2 fc ff ff       	call   80104bd0 <mycpu>
  c->proc = 0;
80104f1e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104f25:	00 00 00 
  struct cpu *c = mycpu();
80104f28:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104f2a:	8d 78 04             	lea    0x4(%eax),%edi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104f30:	fb                   	sti    
    acquire(&ptable.lock);
80104f31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f34:	bb f4 38 11 80       	mov    $0x801138f4,%ebx
    acquire(&ptable.lock);
80104f39:	68 c0 38 11 80       	push   $0x801138c0
80104f3e:	e8 3d 09 00 00       	call   80105880 <acquire>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104f50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104f54:	75 33                	jne    80104f89 <scheduler+0x79>
      switchuvm(p);
80104f56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104f59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104f5f:	53                   	push   %ebx
80104f60:	e8 5b 2d 00 00       	call   80107cc0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104f65:	58                   	pop    %eax
80104f66:	5a                   	pop    %edx
80104f67:	ff 73 1c             	push   0x1c(%ebx)
80104f6a:	57                   	push   %edi
      p->state = RUNNING;
80104f6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104f72:	e8 e4 0b 00 00       	call   80105b5b <swtch>
      switchkvm();
80104f77:	e8 34 2d 00 00       	call   80107cb0 <switchkvm>
      c->proc = 0;
80104f7c:	83 c4 10             	add    $0x10,%esp
80104f7f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104f86:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f89:	83 c3 7c             	add    $0x7c,%ebx
80104f8c:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
80104f92:	75 bc                	jne    80104f50 <scheduler+0x40>
    release(&ptable.lock);
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	68 c0 38 11 80       	push   $0x801138c0
80104f9c:	e8 7f 08 00 00       	call   80105820 <release>
    sti();
80104fa1:	83 c4 10             	add    $0x10,%esp
80104fa4:	eb 8a                	jmp    80104f30 <scheduler+0x20>
80104fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fad:	8d 76 00             	lea    0x0(%esi),%esi

80104fb0 <sched>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
  pushcli();
80104fb5:	e8 76 07 00 00       	call   80105730 <pushcli>
  c = mycpu();
80104fba:	e8 11 fc ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
80104fbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104fc5:	e8 b6 07 00 00       	call   80105780 <popcli>
  if(!holding(&ptable.lock))
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	68 c0 38 11 80       	push   $0x801138c0
80104fd2:	e8 09 08 00 00       	call   801057e0 <holding>
80104fd7:	83 c4 10             	add    $0x10,%esp
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	74 4f                	je     8010502d <sched+0x7d>
  if(mycpu()->ncli != 1)
80104fde:	e8 ed fb ff ff       	call   80104bd0 <mycpu>
80104fe3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104fea:	75 68                	jne    80105054 <sched+0xa4>
  if(p->state == RUNNING)
80104fec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104ff0:	74 55                	je     80105047 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ff2:	9c                   	pushf  
80104ff3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ff4:	f6 c4 02             	test   $0x2,%ah
80104ff7:	75 41                	jne    8010503a <sched+0x8a>
  intena = mycpu()->intena;
80104ff9:	e8 d2 fb ff ff       	call   80104bd0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104ffe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105001:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105007:	e8 c4 fb ff ff       	call   80104bd0 <mycpu>
8010500c:	83 ec 08             	sub    $0x8,%esp
8010500f:	ff 70 04             	push   0x4(%eax)
80105012:	53                   	push   %ebx
80105013:	e8 43 0b 00 00       	call   80105b5b <swtch>
  mycpu()->intena = intena;
80105018:	e8 b3 fb ff ff       	call   80104bd0 <mycpu>
}
8010501d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105020:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105029:	5b                   	pop    %ebx
8010502a:	5e                   	pop    %esi
8010502b:	5d                   	pop    %ebp
8010502c:	c3                   	ret    
    panic("sched ptable.lock");
8010502d:	83 ec 0c             	sub    $0xc,%esp
80105030:	68 3b 8a 10 80       	push   $0x80108a3b
80105035:	e8 26 b4 ff ff       	call   80100460 <panic>
    panic("sched interruptible");
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	68 67 8a 10 80       	push   $0x80108a67
80105042:	e8 19 b4 ff ff       	call   80100460 <panic>
    panic("sched running");
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	68 59 8a 10 80       	push   $0x80108a59
8010504f:	e8 0c b4 ff ff       	call   80100460 <panic>
    panic("sched locks");
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	68 4d 8a 10 80       	push   $0x80108a4d
8010505c:	e8 ff b3 ff ff       	call   80100460 <panic>
80105061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506f:	90                   	nop

80105070 <exit>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
80105076:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105079:	e8 d2 fb ff ff       	call   80104c50 <myproc>
  if(curproc == initproc)
8010507e:	39 05 f4 57 11 80    	cmp    %eax,0x801157f4
80105084:	0f 84 fd 00 00 00    	je     80105187 <exit+0x117>
8010508a:	89 c3                	mov    %eax,%ebx
8010508c:	8d 70 28             	lea    0x28(%eax),%esi
8010508f:	8d 78 68             	lea    0x68(%eax),%edi
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80105098:	8b 06                	mov    (%esi),%eax
8010509a:	85 c0                	test   %eax,%eax
8010509c:	74 12                	je     801050b0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010509e:	83 ec 0c             	sub    $0xc,%esp
801050a1:	50                   	push   %eax
801050a2:	e8 29 d1 ff ff       	call   801021d0 <fileclose>
      curproc->ofile[fd] = 0;
801050a7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801050ad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801050b0:	83 c6 04             	add    $0x4,%esi
801050b3:	39 f7                	cmp    %esi,%edi
801050b5:	75 e1                	jne    80105098 <exit+0x28>
  begin_op();
801050b7:	e8 84 ef ff ff       	call   80104040 <begin_op>
  iput(curproc->cwd);
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	ff 73 68             	push   0x68(%ebx)
801050c2:	e8 c9 da ff ff       	call   80102b90 <iput>
  end_op();
801050c7:	e8 e4 ef ff ff       	call   801040b0 <end_op>
  curproc->cwd = 0;
801050cc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801050d3:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
801050da:	e8 a1 07 00 00       	call   80105880 <acquire>
  wakeup1(curproc->parent);
801050df:	8b 53 14             	mov    0x14(%ebx),%edx
801050e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050e5:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
801050ea:	eb 0e                	jmp    801050fa <exit+0x8a>
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f0:	83 c0 7c             	add    $0x7c,%eax
801050f3:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
801050f8:	74 1c                	je     80105116 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801050fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801050fe:	75 f0                	jne    801050f0 <exit+0x80>
80105100:	3b 50 20             	cmp    0x20(%eax),%edx
80105103:	75 eb                	jne    801050f0 <exit+0x80>
      p->state = RUNNABLE;
80105105:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010510c:	83 c0 7c             	add    $0x7c,%eax
8010510f:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105114:	75 e4                	jne    801050fa <exit+0x8a>
      p->parent = initproc;
80105116:	8b 0d f4 57 11 80    	mov    0x801157f4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010511c:	ba f4 38 11 80       	mov    $0x801138f4,%edx
80105121:	eb 10                	jmp    80105133 <exit+0xc3>
80105123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105127:	90                   	nop
80105128:	83 c2 7c             	add    $0x7c,%edx
8010512b:	81 fa f4 57 11 80    	cmp    $0x801157f4,%edx
80105131:	74 3b                	je     8010516e <exit+0xfe>
    if(p->parent == curproc){
80105133:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105136:	75 f0                	jne    80105128 <exit+0xb8>
      if(p->state == ZOMBIE)
80105138:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010513c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010513f:	75 e7                	jne    80105128 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105141:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
80105146:	eb 12                	jmp    8010515a <exit+0xea>
80105148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
80105150:	83 c0 7c             	add    $0x7c,%eax
80105153:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105158:	74 ce                	je     80105128 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010515a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010515e:	75 f0                	jne    80105150 <exit+0xe0>
80105160:	3b 48 20             	cmp    0x20(%eax),%ecx
80105163:	75 eb                	jne    80105150 <exit+0xe0>
      p->state = RUNNABLE;
80105165:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010516c:	eb e2                	jmp    80105150 <exit+0xe0>
  curproc->state = ZOMBIE;
8010516e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105175:	e8 36 fe ff ff       	call   80104fb0 <sched>
  panic("zombie exit");
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	68 88 8a 10 80       	push   $0x80108a88
80105182:	e8 d9 b2 ff ff       	call   80100460 <panic>
    panic("init exiting");
80105187:	83 ec 0c             	sub    $0xc,%esp
8010518a:	68 7b 8a 10 80       	push   $0x80108a7b
8010518f:	e8 cc b2 ff ff       	call   80100460 <panic>
80105194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010519f:	90                   	nop

801051a0 <wait>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
  pushcli();
801051a5:	e8 86 05 00 00       	call   80105730 <pushcli>
  c = mycpu();
801051aa:	e8 21 fa ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
801051af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801051b5:	e8 c6 05 00 00       	call   80105780 <popcli>
  acquire(&ptable.lock);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	68 c0 38 11 80       	push   $0x801138c0
801051c2:	e8 b9 06 00 00       	call   80105880 <acquire>
801051c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801051ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051cc:	bb f4 38 11 80       	mov    $0x801138f4,%ebx
801051d1:	eb 10                	jmp    801051e3 <wait+0x43>
801051d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051d7:	90                   	nop
801051d8:	83 c3 7c             	add    $0x7c,%ebx
801051db:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
801051e1:	74 1b                	je     801051fe <wait+0x5e>
      if(p->parent != curproc)
801051e3:	39 73 14             	cmp    %esi,0x14(%ebx)
801051e6:	75 f0                	jne    801051d8 <wait+0x38>
      if(p->state == ZOMBIE){
801051e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801051ec:	74 62                	je     80105250 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051ee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801051f1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051f6:	81 fb f4 57 11 80    	cmp    $0x801157f4,%ebx
801051fc:	75 e5                	jne    801051e3 <wait+0x43>
    if(!havekids || curproc->killed){
801051fe:	85 c0                	test   %eax,%eax
80105200:	0f 84 a0 00 00 00    	je     801052a6 <wait+0x106>
80105206:	8b 46 24             	mov    0x24(%esi),%eax
80105209:	85 c0                	test   %eax,%eax
8010520b:	0f 85 95 00 00 00    	jne    801052a6 <wait+0x106>
  pushcli();
80105211:	e8 1a 05 00 00       	call   80105730 <pushcli>
  c = mycpu();
80105216:	e8 b5 f9 ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
8010521b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105221:	e8 5a 05 00 00       	call   80105780 <popcli>
  if(p == 0)
80105226:	85 db                	test   %ebx,%ebx
80105228:	0f 84 8f 00 00 00    	je     801052bd <wait+0x11d>
  p->chan = chan;
8010522e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105231:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105238:	e8 73 fd ff ff       	call   80104fb0 <sched>
  p->chan = 0;
8010523d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105244:	eb 84                	jmp    801051ca <wait+0x2a>
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80105250:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105253:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105256:	ff 73 08             	push   0x8(%ebx)
80105259:	e8 42 e5 ff ff       	call   801037a0 <kfree>
        p->kstack = 0;
8010525e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105265:	5a                   	pop    %edx
80105266:	ff 73 04             	push   0x4(%ebx)
80105269:	e8 32 2e 00 00       	call   801080a0 <freevm>
        p->pid = 0;
8010526e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105275:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010527c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105280:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105287:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010528e:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80105295:	e8 86 05 00 00       	call   80105820 <release>
        return pid;
8010529a:	83 c4 10             	add    $0x10,%esp
}
8010529d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a0:	89 f0                	mov    %esi,%eax
801052a2:	5b                   	pop    %ebx
801052a3:	5e                   	pop    %esi
801052a4:	5d                   	pop    %ebp
801052a5:	c3                   	ret    
      release(&ptable.lock);
801052a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801052a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801052ae:	68 c0 38 11 80       	push   $0x801138c0
801052b3:	e8 68 05 00 00       	call   80105820 <release>
      return -1;
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	eb e0                	jmp    8010529d <wait+0xfd>
    panic("sleep");
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	68 94 8a 10 80       	push   $0x80108a94
801052c5:	e8 96 b1 ff ff       	call   80100460 <panic>
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052d0 <yield>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	53                   	push   %ebx
801052d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801052d7:	68 c0 38 11 80       	push   $0x801138c0
801052dc:	e8 9f 05 00 00       	call   80105880 <acquire>
  pushcli();
801052e1:	e8 4a 04 00 00       	call   80105730 <pushcli>
  c = mycpu();
801052e6:	e8 e5 f8 ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
801052eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801052f1:	e8 8a 04 00 00       	call   80105780 <popcli>
  myproc()->state = RUNNABLE;
801052f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801052fd:	e8 ae fc ff ff       	call   80104fb0 <sched>
  release(&ptable.lock);
80105302:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80105309:	e8 12 05 00 00       	call   80105820 <release>
}
8010530e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	c9                   	leave  
80105315:	c3                   	ret    
80105316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531d:	8d 76 00             	lea    0x0(%esi),%esi

80105320 <sleep>:
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
80105326:	83 ec 0c             	sub    $0xc,%esp
80105329:	8b 7d 08             	mov    0x8(%ebp),%edi
8010532c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010532f:	e8 fc 03 00 00       	call   80105730 <pushcli>
  c = mycpu();
80105334:	e8 97 f8 ff ff       	call   80104bd0 <mycpu>
  p = c->proc;
80105339:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010533f:	e8 3c 04 00 00       	call   80105780 <popcli>
  if(p == 0)
80105344:	85 db                	test   %ebx,%ebx
80105346:	0f 84 87 00 00 00    	je     801053d3 <sleep+0xb3>
  if(lk == 0)
8010534c:	85 f6                	test   %esi,%esi
8010534e:	74 76                	je     801053c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105350:	81 fe c0 38 11 80    	cmp    $0x801138c0,%esi
80105356:	74 50                	je     801053a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105358:	83 ec 0c             	sub    $0xc,%esp
8010535b:	68 c0 38 11 80       	push   $0x801138c0
80105360:	e8 1b 05 00 00       	call   80105880 <acquire>
    release(lk);
80105365:	89 34 24             	mov    %esi,(%esp)
80105368:	e8 b3 04 00 00       	call   80105820 <release>
  p->chan = chan;
8010536d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105370:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105377:	e8 34 fc ff ff       	call   80104fb0 <sched>
  p->chan = 0;
8010537c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105383:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
8010538a:	e8 91 04 00 00       	call   80105820 <release>
    acquire(lk);
8010538f:	89 75 08             	mov    %esi,0x8(%ebp)
80105392:	83 c4 10             	add    $0x10,%esp
}
80105395:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105398:	5b                   	pop    %ebx
80105399:	5e                   	pop    %esi
8010539a:	5f                   	pop    %edi
8010539b:	5d                   	pop    %ebp
    acquire(lk);
8010539c:	e9 df 04 00 00       	jmp    80105880 <acquire>
801053a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801053a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801053ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801053b2:	e8 f9 fb ff ff       	call   80104fb0 <sched>
  p->chan = 0;
801053b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801053be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c1:	5b                   	pop    %ebx
801053c2:	5e                   	pop    %esi
801053c3:	5f                   	pop    %edi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
    panic("sleep without lk");
801053c6:	83 ec 0c             	sub    $0xc,%esp
801053c9:	68 9a 8a 10 80       	push   $0x80108a9a
801053ce:	e8 8d b0 ff ff       	call   80100460 <panic>
    panic("sleep");
801053d3:	83 ec 0c             	sub    $0xc,%esp
801053d6:	68 94 8a 10 80       	push   $0x80108a94
801053db:	e8 80 b0 ff ff       	call   80100460 <panic>

801053e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 10             	sub    $0x10,%esp
801053e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801053ea:	68 c0 38 11 80       	push   $0x801138c0
801053ef:	e8 8c 04 00 00       	call   80105880 <acquire>
801053f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053f7:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
801053fc:	eb 0c                	jmp    8010540a <wakeup+0x2a>
801053fe:	66 90                	xchg   %ax,%ax
80105400:	83 c0 7c             	add    $0x7c,%eax
80105403:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105408:	74 1c                	je     80105426 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010540a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010540e:	75 f0                	jne    80105400 <wakeup+0x20>
80105410:	3b 58 20             	cmp    0x20(%eax),%ebx
80105413:	75 eb                	jne    80105400 <wakeup+0x20>
      p->state = RUNNABLE;
80105415:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010541c:	83 c0 7c             	add    $0x7c,%eax
8010541f:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105424:	75 e4                	jne    8010540a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80105426:	c7 45 08 c0 38 11 80 	movl   $0x801138c0,0x8(%ebp)
}
8010542d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105430:	c9                   	leave  
  release(&ptable.lock);
80105431:	e9 ea 03 00 00       	jmp    80105820 <release>
80105436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543d:	8d 76 00             	lea    0x0(%esi),%esi

80105440 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 10             	sub    $0x10,%esp
80105447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010544a:	68 c0 38 11 80       	push   $0x801138c0
8010544f:	e8 2c 04 00 00       	call   80105880 <acquire>
80105454:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105457:	b8 f4 38 11 80       	mov    $0x801138f4,%eax
8010545c:	eb 0c                	jmp    8010546a <kill+0x2a>
8010545e:	66 90                	xchg   %ax,%ax
80105460:	83 c0 7c             	add    $0x7c,%eax
80105463:	3d f4 57 11 80       	cmp    $0x801157f4,%eax
80105468:	74 36                	je     801054a0 <kill+0x60>
    if(p->pid == pid){
8010546a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010546d:	75 f1                	jne    80105460 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010546f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105473:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010547a:	75 07                	jne    80105483 <kill+0x43>
        p->state = RUNNABLE;
8010547c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105483:	83 ec 0c             	sub    $0xc,%esp
80105486:	68 c0 38 11 80       	push   $0x801138c0
8010548b:	e8 90 03 00 00       	call   80105820 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80105490:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	31 c0                	xor    %eax,%eax
}
80105498:	c9                   	leave  
80105499:	c3                   	ret    
8010549a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	68 c0 38 11 80       	push   $0x801138c0
801054a8:	e8 73 03 00 00       	call   80105820 <release>
}
801054ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801054b0:	83 c4 10             	add    $0x10,%esp
801054b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b8:	c9                   	leave  
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
801054c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801054c8:	53                   	push   %ebx
801054c9:	bb 60 39 11 80       	mov    $0x80113960,%ebx
801054ce:	83 ec 3c             	sub    $0x3c,%esp
801054d1:	eb 24                	jmp    801054f7 <procdump+0x37>
801054d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	68 17 8e 10 80       	push   $0x80108e17
801054e0:	e8 fb b2 ff ff       	call   801007e0 <cprintf>
801054e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054e8:	83 c3 7c             	add    $0x7c,%ebx
801054eb:	81 fb 60 58 11 80    	cmp    $0x80115860,%ebx
801054f1:	0f 84 81 00 00 00    	je     80105578 <procdump+0xb8>
    if(p->state == UNUSED)
801054f7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801054fa:	85 c0                	test   %eax,%eax
801054fc:	74 ea                	je     801054e8 <procdump+0x28>
      state = "???";
801054fe:	ba ab 8a 10 80       	mov    $0x80108aab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105503:	83 f8 05             	cmp    $0x5,%eax
80105506:	77 11                	ja     80105519 <procdump+0x59>
80105508:	8b 14 85 0c 8b 10 80 	mov    -0x7fef74f4(,%eax,4),%edx
      state = "???";
8010550f:	b8 ab 8a 10 80       	mov    $0x80108aab,%eax
80105514:	85 d2                	test   %edx,%edx
80105516:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105519:	53                   	push   %ebx
8010551a:	52                   	push   %edx
8010551b:	ff 73 a4             	push   -0x5c(%ebx)
8010551e:	68 af 8a 10 80       	push   $0x80108aaf
80105523:	e8 b8 b2 ff ff       	call   801007e0 <cprintf>
    if(p->state == SLEEPING){
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010552f:	75 a7                	jne    801054d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105531:	83 ec 08             	sub    $0x8,%esp
80105534:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105537:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010553a:	50                   	push   %eax
8010553b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010553e:	8b 40 0c             	mov    0xc(%eax),%eax
80105541:	83 c0 08             	add    $0x8,%eax
80105544:	50                   	push   %eax
80105545:	e8 86 01 00 00       	call   801056d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
80105550:	8b 17                	mov    (%edi),%edx
80105552:	85 d2                	test   %edx,%edx
80105554:	74 82                	je     801054d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105556:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105559:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010555c:	52                   	push   %edx
8010555d:	68 c1 84 10 80       	push   $0x801084c1
80105562:	e8 79 b2 ff ff       	call   801007e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105567:	83 c4 10             	add    $0x10,%esp
8010556a:	39 fe                	cmp    %edi,%esi
8010556c:	75 e2                	jne    80105550 <procdump+0x90>
8010556e:	e9 65 ff ff ff       	jmp    801054d8 <procdump+0x18>
80105573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105577:	90                   	nop
  }
}
80105578:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010557b:	5b                   	pop    %ebx
8010557c:	5e                   	pop    %esi
8010557d:	5f                   	pop    %edi
8010557e:	5d                   	pop    %ebp
8010557f:	c3                   	ret    

80105580 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	53                   	push   %ebx
80105584:	83 ec 0c             	sub    $0xc,%esp
80105587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010558a:	68 24 8b 10 80       	push   $0x80108b24
8010558f:	8d 43 04             	lea    0x4(%ebx),%eax
80105592:	50                   	push   %eax
80105593:	e8 18 01 00 00       	call   801056b0 <initlock>
  lk->name = name;
80105598:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010559b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801055a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801055a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801055ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801055ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055b1:	c9                   	leave  
801055b2:	c3                   	ret    
801055b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
801055c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801055c8:	8d 73 04             	lea    0x4(%ebx),%esi
801055cb:	83 ec 0c             	sub    $0xc,%esp
801055ce:	56                   	push   %esi
801055cf:	e8 ac 02 00 00       	call   80105880 <acquire>
  while (lk->locked) {
801055d4:	8b 13                	mov    (%ebx),%edx
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 d2                	test   %edx,%edx
801055db:	74 16                	je     801055f3 <acquiresleep+0x33>
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
801055e5:	e8 36 fd ff ff       	call   80105320 <sleep>
  while (lk->locked) {
801055ea:	8b 03                	mov    (%ebx),%eax
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	85 c0                	test   %eax,%eax
801055f1:	75 ed                	jne    801055e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801055f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801055f9:	e8 52 f6 ff ff       	call   80104c50 <myproc>
801055fe:	8b 40 10             	mov    0x10(%eax),%eax
80105601:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105604:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105607:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010560a:	5b                   	pop    %ebx
8010560b:	5e                   	pop    %esi
8010560c:	5d                   	pop    %ebp
  release(&lk->lk);
8010560d:	e9 0e 02 00 00       	jmp    80105820 <release>
80105612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105620 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	56                   	push   %esi
80105624:	53                   	push   %ebx
80105625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105628:	8d 73 04             	lea    0x4(%ebx),%esi
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	56                   	push   %esi
8010562f:	e8 4c 02 00 00       	call   80105880 <acquire>
  lk->locked = 0;
80105634:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010563a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105641:	89 1c 24             	mov    %ebx,(%esp)
80105644:	e8 97 fd ff ff       	call   801053e0 <wakeup>
  release(&lk->lk);
80105649:	89 75 08             	mov    %esi,0x8(%ebp)
8010564c:	83 c4 10             	add    $0x10,%esp
}
8010564f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5d                   	pop    %ebp
  release(&lk->lk);
80105655:	e9 c6 01 00 00       	jmp    80105820 <release>
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105660 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	57                   	push   %edi
80105664:	31 ff                	xor    %edi,%edi
80105666:	56                   	push   %esi
80105667:	53                   	push   %ebx
80105668:	83 ec 18             	sub    $0x18,%esp
8010566b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010566e:	8d 73 04             	lea    0x4(%ebx),%esi
80105671:	56                   	push   %esi
80105672:	e8 09 02 00 00       	call   80105880 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105677:	8b 03                	mov    (%ebx),%eax
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	75 18                	jne    80105698 <holdingsleep+0x38>
  release(&lk->lk);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	56                   	push   %esi
80105684:	e8 97 01 00 00       	call   80105820 <release>
  return r;
}
80105689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010568c:	89 f8                	mov    %edi,%eax
8010568e:	5b                   	pop    %ebx
8010568f:	5e                   	pop    %esi
80105690:	5f                   	pop    %edi
80105691:	5d                   	pop    %ebp
80105692:	c3                   	ret    
80105693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105697:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105698:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010569b:	e8 b0 f5 ff ff       	call   80104c50 <myproc>
801056a0:	39 58 10             	cmp    %ebx,0x10(%eax)
801056a3:	0f 94 c0             	sete   %al
801056a6:	0f b6 c0             	movzbl %al,%eax
801056a9:	89 c7                	mov    %eax,%edi
801056ab:	eb d3                	jmp    80105680 <holdingsleep+0x20>
801056ad:	66 90                	xchg   %ax,%ax
801056af:	90                   	nop

801056b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801056b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801056b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801056bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801056c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801056c9:	5d                   	pop    %ebp
801056ca:	c3                   	ret    
801056cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop

801056d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801056d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801056d1:	31 d2                	xor    %edx,%edx
{
801056d3:	89 e5                	mov    %esp,%ebp
801056d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801056d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801056d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801056dc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801056df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801056e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801056e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801056ec:	77 1a                	ja     80105708 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801056ee:	8b 58 04             	mov    0x4(%eax),%ebx
801056f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801056f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801056f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801056f9:	83 fa 0a             	cmp    $0xa,%edx
801056fc:	75 e2                	jne    801056e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801056fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105701:	c9                   	leave  
80105702:	c3                   	ret    
80105703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105707:	90                   	nop
  for(; i < 10; i++)
80105708:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010570b:	8d 51 28             	lea    0x28(%ecx),%edx
8010570e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105716:	83 c0 04             	add    $0x4,%eax
80105719:	39 d0                	cmp    %edx,%eax
8010571b:	75 f3                	jne    80105710 <getcallerpcs+0x40>
}
8010571d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105720:	c9                   	leave  
80105721:	c3                   	ret    
80105722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	53                   	push   %ebx
80105734:	83 ec 04             	sub    $0x4,%esp
80105737:	9c                   	pushf  
80105738:	5b                   	pop    %ebx
  asm volatile("cli");
80105739:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010573a:	e8 91 f4 ff ff       	call   80104bd0 <mycpu>
8010573f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105745:	85 c0                	test   %eax,%eax
80105747:	74 17                	je     80105760 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105749:	e8 82 f4 ff ff       	call   80104bd0 <mycpu>
8010574e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105758:	c9                   	leave  
80105759:	c3                   	ret    
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105760:	e8 6b f4 ff ff       	call   80104bd0 <mycpu>
80105765:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010576b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105771:	eb d6                	jmp    80105749 <pushcli+0x19>
80105773:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105780 <popcli>:

void
popcli(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105786:	9c                   	pushf  
80105787:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105788:	f6 c4 02             	test   $0x2,%ah
8010578b:	75 35                	jne    801057c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010578d:	e8 3e f4 ff ff       	call   80104bd0 <mycpu>
80105792:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105799:	78 34                	js     801057cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010579b:	e8 30 f4 ff ff       	call   80104bd0 <mycpu>
801057a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801057a6:	85 d2                	test   %edx,%edx
801057a8:	74 06                	je     801057b0 <popcli+0x30>
    sti();
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801057b0:	e8 1b f4 ff ff       	call   80104bd0 <mycpu>
801057b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057bb:	85 c0                	test   %eax,%eax
801057bd:	74 eb                	je     801057aa <popcli+0x2a>
  asm volatile("sti");
801057bf:	fb                   	sti    
}
801057c0:	c9                   	leave  
801057c1:	c3                   	ret    
    panic("popcli - interruptible");
801057c2:	83 ec 0c             	sub    $0xc,%esp
801057c5:	68 2f 8b 10 80       	push   $0x80108b2f
801057ca:	e8 91 ac ff ff       	call   80100460 <panic>
    panic("popcli");
801057cf:	83 ec 0c             	sub    $0xc,%esp
801057d2:	68 46 8b 10 80       	push   $0x80108b46
801057d7:	e8 84 ac ff ff       	call   80100460 <panic>
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057e0 <holding>:
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	56                   	push   %esi
801057e4:	53                   	push   %ebx
801057e5:	8b 75 08             	mov    0x8(%ebp),%esi
801057e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801057ea:	e8 41 ff ff ff       	call   80105730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801057ef:	8b 06                	mov    (%esi),%eax
801057f1:	85 c0                	test   %eax,%eax
801057f3:	75 0b                	jne    80105800 <holding+0x20>
  popcli();
801057f5:	e8 86 ff ff ff       	call   80105780 <popcli>
}
801057fa:	89 d8                	mov    %ebx,%eax
801057fc:	5b                   	pop    %ebx
801057fd:	5e                   	pop    %esi
801057fe:	5d                   	pop    %ebp
801057ff:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105800:	8b 5e 08             	mov    0x8(%esi),%ebx
80105803:	e8 c8 f3 ff ff       	call   80104bd0 <mycpu>
80105808:	39 c3                	cmp    %eax,%ebx
8010580a:	0f 94 c3             	sete   %bl
  popcli();
8010580d:	e8 6e ff ff ff       	call   80105780 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105812:	0f b6 db             	movzbl %bl,%ebx
}
80105815:	89 d8                	mov    %ebx,%eax
80105817:	5b                   	pop    %ebx
80105818:	5e                   	pop    %esi
80105819:	5d                   	pop    %ebp
8010581a:	c3                   	ret    
8010581b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop

80105820 <release>:
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105828:	e8 03 ff ff ff       	call   80105730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010582d:	8b 03                	mov    (%ebx),%eax
8010582f:	85 c0                	test   %eax,%eax
80105831:	75 15                	jne    80105848 <release+0x28>
  popcli();
80105833:	e8 48 ff ff ff       	call   80105780 <popcli>
    panic("release");
80105838:	83 ec 0c             	sub    $0xc,%esp
8010583b:	68 4d 8b 10 80       	push   $0x80108b4d
80105840:	e8 1b ac ff ff       	call   80100460 <panic>
80105845:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105848:	8b 73 08             	mov    0x8(%ebx),%esi
8010584b:	e8 80 f3 ff ff       	call   80104bd0 <mycpu>
80105850:	39 c6                	cmp    %eax,%esi
80105852:	75 df                	jne    80105833 <release+0x13>
  popcli();
80105854:	e8 27 ff ff ff       	call   80105780 <popcli>
  lk->pcs[0] = 0;
80105859:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105860:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105867:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010586c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105872:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5d                   	pop    %ebp
  popcli();
80105878:	e9 03 ff ff ff       	jmp    80105780 <popcli>
8010587d:	8d 76 00             	lea    0x0(%esi),%esi

80105880 <acquire>:
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
80105884:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105887:	e8 a4 fe ff ff       	call   80105730 <pushcli>
  if(holding(lk))
8010588c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010588f:	e8 9c fe ff ff       	call   80105730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105894:	8b 03                	mov    (%ebx),%eax
80105896:	85 c0                	test   %eax,%eax
80105898:	75 7e                	jne    80105918 <acquire+0x98>
  popcli();
8010589a:	e8 e1 fe ff ff       	call   80105780 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010589f:	b9 01 00 00 00       	mov    $0x1,%ecx
801058a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801058a8:	8b 55 08             	mov    0x8(%ebp),%edx
801058ab:	89 c8                	mov    %ecx,%eax
801058ad:	f0 87 02             	lock xchg %eax,(%edx)
801058b0:	85 c0                	test   %eax,%eax
801058b2:	75 f4                	jne    801058a8 <acquire+0x28>
  __sync_synchronize();
801058b4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801058b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801058bc:	e8 0f f3 ff ff       	call   80104bd0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801058c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801058c4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801058c6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801058c9:	31 c0                	xor    %eax,%eax
801058cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801058d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801058d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801058dc:	77 1a                	ja     801058f8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801058de:	8b 5a 04             	mov    0x4(%edx),%ebx
801058e1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801058e5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801058e8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801058ea:	83 f8 0a             	cmp    $0xa,%eax
801058ed:	75 e1                	jne    801058d0 <acquire+0x50>
}
801058ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801058f8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801058fc:	8d 51 34             	lea    0x34(%ecx),%edx
801058ff:	90                   	nop
    pcs[i] = 0;
80105900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105906:	83 c0 04             	add    $0x4,%eax
80105909:	39 c2                	cmp    %eax,%edx
8010590b:	75 f3                	jne    80105900 <acquire+0x80>
}
8010590d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105910:	c9                   	leave  
80105911:	c3                   	ret    
80105912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105918:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010591b:	e8 b0 f2 ff ff       	call   80104bd0 <mycpu>
80105920:	39 c3                	cmp    %eax,%ebx
80105922:	0f 85 72 ff ff ff    	jne    8010589a <acquire+0x1a>
  popcli();
80105928:	e8 53 fe ff ff       	call   80105780 <popcli>
    panic("acquire");
8010592d:	83 ec 0c             	sub    $0xc,%esp
80105930:	68 55 8b 10 80       	push   $0x80108b55
80105935:	e8 26 ab ff ff       	call   80100460 <panic>
8010593a:	66 90                	xchg   %ax,%ax
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	8b 55 08             	mov    0x8(%ebp),%edx
80105947:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010594a:	53                   	push   %ebx
8010594b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010594e:	89 d7                	mov    %edx,%edi
80105950:	09 cf                	or     %ecx,%edi
80105952:	83 e7 03             	and    $0x3,%edi
80105955:	75 29                	jne    80105980 <memset+0x40>
    c &= 0xFF;
80105957:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010595a:	c1 e0 18             	shl    $0x18,%eax
8010595d:	89 fb                	mov    %edi,%ebx
8010595f:	c1 e9 02             	shr    $0x2,%ecx
80105962:	c1 e3 10             	shl    $0x10,%ebx
80105965:	09 d8                	or     %ebx,%eax
80105967:	09 f8                	or     %edi,%eax
80105969:	c1 e7 08             	shl    $0x8,%edi
8010596c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010596e:	89 d7                	mov    %edx,%edi
80105970:	fc                   	cld    
80105971:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105973:	5b                   	pop    %ebx
80105974:	89 d0                	mov    %edx,%eax
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105980:	89 d7                	mov    %edx,%edi
80105982:	fc                   	cld    
80105983:	f3 aa                	rep stos %al,%es:(%edi)
80105985:	5b                   	pop    %ebx
80105986:	89 d0                	mov    %edx,%eax
80105988:	5f                   	pop    %edi
80105989:	5d                   	pop    %ebp
8010598a:	c3                   	ret    
8010598b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop

80105990 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	56                   	push   %esi
80105994:	8b 75 10             	mov    0x10(%ebp),%esi
80105997:	8b 55 08             	mov    0x8(%ebp),%edx
8010599a:	53                   	push   %ebx
8010599b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010599e:	85 f6                	test   %esi,%esi
801059a0:	74 2e                	je     801059d0 <memcmp+0x40>
801059a2:	01 c6                	add    %eax,%esi
801059a4:	eb 14                	jmp    801059ba <memcmp+0x2a>
801059a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801059b0:	83 c0 01             	add    $0x1,%eax
801059b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801059b6:	39 f0                	cmp    %esi,%eax
801059b8:	74 16                	je     801059d0 <memcmp+0x40>
    if(*s1 != *s2)
801059ba:	0f b6 0a             	movzbl (%edx),%ecx
801059bd:	0f b6 18             	movzbl (%eax),%ebx
801059c0:	38 d9                	cmp    %bl,%cl
801059c2:	74 ec                	je     801059b0 <memcmp+0x20>
      return *s1 - *s2;
801059c4:	0f b6 c1             	movzbl %cl,%eax
801059c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801059c9:	5b                   	pop    %ebx
801059ca:	5e                   	pop    %esi
801059cb:	5d                   	pop    %ebp
801059cc:	c3                   	ret    
801059cd:	8d 76 00             	lea    0x0(%esi),%esi
801059d0:	5b                   	pop    %ebx
  return 0;
801059d1:	31 c0                	xor    %eax,%eax
}
801059d3:	5e                   	pop    %esi
801059d4:	5d                   	pop    %ebp
801059d5:	c3                   	ret    
801059d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059dd:	8d 76 00             	lea    0x0(%esi),%esi

801059e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	8b 55 08             	mov    0x8(%ebp),%edx
801059e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801059ea:	56                   	push   %esi
801059eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801059ee:	39 d6                	cmp    %edx,%esi
801059f0:	73 26                	jae    80105a18 <memmove+0x38>
801059f2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801059f5:	39 fa                	cmp    %edi,%edx
801059f7:	73 1f                	jae    80105a18 <memmove+0x38>
801059f9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801059fc:	85 c9                	test   %ecx,%ecx
801059fe:	74 0c                	je     80105a0c <memmove+0x2c>
      *--d = *--s;
80105a00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105a04:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105a07:	83 e8 01             	sub    $0x1,%eax
80105a0a:	73 f4                	jae    80105a00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105a0c:	5e                   	pop    %esi
80105a0d:	89 d0                	mov    %edx,%eax
80105a0f:	5f                   	pop    %edi
80105a10:	5d                   	pop    %ebp
80105a11:	c3                   	ret    
80105a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105a18:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105a1b:	89 d7                	mov    %edx,%edi
80105a1d:	85 c9                	test   %ecx,%ecx
80105a1f:	74 eb                	je     80105a0c <memmove+0x2c>
80105a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105a28:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105a29:	39 c6                	cmp    %eax,%esi
80105a2b:	75 fb                	jne    80105a28 <memmove+0x48>
}
80105a2d:	5e                   	pop    %esi
80105a2e:	89 d0                	mov    %edx,%eax
80105a30:	5f                   	pop    %edi
80105a31:	5d                   	pop    %ebp
80105a32:	c3                   	ret    
80105a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105a40:	eb 9e                	jmp    801059e0 <memmove>
80105a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	56                   	push   %esi
80105a54:	8b 75 10             	mov    0x10(%ebp),%esi
80105a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a5a:	53                   	push   %ebx
80105a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80105a5e:	85 f6                	test   %esi,%esi
80105a60:	74 2e                	je     80105a90 <strncmp+0x40>
80105a62:	01 d6                	add    %edx,%esi
80105a64:	eb 18                	jmp    80105a7e <strncmp+0x2e>
80105a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
80105a70:	38 d8                	cmp    %bl,%al
80105a72:	75 14                	jne    80105a88 <strncmp+0x38>
    n--, p++, q++;
80105a74:	83 c2 01             	add    $0x1,%edx
80105a77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105a7a:	39 f2                	cmp    %esi,%edx
80105a7c:	74 12                	je     80105a90 <strncmp+0x40>
80105a7e:	0f b6 01             	movzbl (%ecx),%eax
80105a81:	0f b6 1a             	movzbl (%edx),%ebx
80105a84:	84 c0                	test   %al,%al
80105a86:	75 e8                	jne    80105a70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105a88:	29 d8                	sub    %ebx,%eax
}
80105a8a:	5b                   	pop    %ebx
80105a8b:	5e                   	pop    %esi
80105a8c:	5d                   	pop    %ebp
80105a8d:	c3                   	ret    
80105a8e:	66 90                	xchg   %ax,%ax
80105a90:	5b                   	pop    %ebx
    return 0;
80105a91:	31 c0                	xor    %eax,%eax
}
80105a93:	5e                   	pop    %esi
80105a94:	5d                   	pop    %ebp
80105a95:	c3                   	ret    
80105a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi

80105aa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	8b 75 08             	mov    0x8(%ebp),%esi
80105aa8:	53                   	push   %ebx
80105aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105aac:	89 f0                	mov    %esi,%eax
80105aae:	eb 15                	jmp    80105ac5 <strncpy+0x25>
80105ab0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105ab4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105ab7:	83 c0 01             	add    $0x1,%eax
80105aba:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105abe:	88 50 ff             	mov    %dl,-0x1(%eax)
80105ac1:	84 d2                	test   %dl,%dl
80105ac3:	74 09                	je     80105ace <strncpy+0x2e>
80105ac5:	89 cb                	mov    %ecx,%ebx
80105ac7:	83 e9 01             	sub    $0x1,%ecx
80105aca:	85 db                	test   %ebx,%ebx
80105acc:	7f e2                	jg     80105ab0 <strncpy+0x10>
    ;
  while(n-- > 0)
80105ace:	89 c2                	mov    %eax,%edx
80105ad0:	85 c9                	test   %ecx,%ecx
80105ad2:	7e 17                	jle    80105aeb <strncpy+0x4b>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105ad8:	83 c2 01             	add    $0x1,%edx
80105adb:	89 c1                	mov    %eax,%ecx
80105add:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105ae1:	29 d1                	sub    %edx,%ecx
80105ae3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105ae7:	85 c9                	test   %ecx,%ecx
80105ae9:	7f ed                	jg     80105ad8 <strncpy+0x38>
  return os;
}
80105aeb:	5b                   	pop    %ebx
80105aec:	89 f0                	mov    %esi,%eax
80105aee:	5e                   	pop    %esi
80105aef:	5f                   	pop    %edi
80105af0:	5d                   	pop    %ebp
80105af1:	c3                   	ret    
80105af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	56                   	push   %esi
80105b04:	8b 55 10             	mov    0x10(%ebp),%edx
80105b07:	8b 75 08             	mov    0x8(%ebp),%esi
80105b0a:	53                   	push   %ebx
80105b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105b0e:	85 d2                	test   %edx,%edx
80105b10:	7e 25                	jle    80105b37 <safestrcpy+0x37>
80105b12:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105b16:	89 f2                	mov    %esi,%edx
80105b18:	eb 16                	jmp    80105b30 <safestrcpy+0x30>
80105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105b20:	0f b6 08             	movzbl (%eax),%ecx
80105b23:	83 c0 01             	add    $0x1,%eax
80105b26:	83 c2 01             	add    $0x1,%edx
80105b29:	88 4a ff             	mov    %cl,-0x1(%edx)
80105b2c:	84 c9                	test   %cl,%cl
80105b2e:	74 04                	je     80105b34 <safestrcpy+0x34>
80105b30:	39 d8                	cmp    %ebx,%eax
80105b32:	75 ec                	jne    80105b20 <safestrcpy+0x20>
    ;
  *s = 0;
80105b34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105b37:	89 f0                	mov    %esi,%eax
80105b39:	5b                   	pop    %ebx
80105b3a:	5e                   	pop    %esi
80105b3b:	5d                   	pop    %ebp
80105b3c:	c3                   	ret    
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi

80105b40 <strlen>:

int
strlen(const char *s)
{
80105b40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105b41:	31 c0                	xor    %eax,%eax
{
80105b43:	89 e5                	mov    %esp,%ebp
80105b45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105b48:	80 3a 00             	cmpb   $0x0,(%edx)
80105b4b:	74 0c                	je     80105b59 <strlen+0x19>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
80105b50:	83 c0 01             	add    $0x1,%eax
80105b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105b57:	75 f7                	jne    80105b50 <strlen+0x10>
    ;
  return n;
}
80105b59:	5d                   	pop    %ebp
80105b5a:	c3                   	ret    

80105b5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105b63:	55                   	push   %ebp
  pushl %ebx
80105b64:	53                   	push   %ebx
  pushl %esi
80105b65:	56                   	push   %esi
  pushl %edi
80105b66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105b6b:	5f                   	pop    %edi
  popl %esi
80105b6c:	5e                   	pop    %esi
  popl %ebx
80105b6d:	5b                   	pop    %ebx
  popl %ebp
80105b6e:	5d                   	pop    %ebp
  ret
80105b6f:	c3                   	ret    

80105b70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
80105b74:	83 ec 04             	sub    $0x4,%esp
80105b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105b7a:	e8 d1 f0 ff ff       	call   80104c50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b7f:	8b 00                	mov    (%eax),%eax
80105b81:	39 d8                	cmp    %ebx,%eax
80105b83:	76 1b                	jbe    80105ba0 <fetchint+0x30>
80105b85:	8d 53 04             	lea    0x4(%ebx),%edx
80105b88:	39 d0                	cmp    %edx,%eax
80105b8a:	72 14                	jb     80105ba0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b8f:	8b 13                	mov    (%ebx),%edx
80105b91:	89 10                	mov    %edx,(%eax)
  return 0;
80105b93:	31 c0                	xor    %eax,%eax
}
80105b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b98:	c9                   	leave  
80105b99:	c3                   	ret    
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba5:	eb ee                	jmp    80105b95 <fetchint+0x25>
80105ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	53                   	push   %ebx
80105bb4:	83 ec 04             	sub    $0x4,%esp
80105bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105bba:	e8 91 f0 ff ff       	call   80104c50 <myproc>

  if(addr >= curproc->sz)
80105bbf:	39 18                	cmp    %ebx,(%eax)
80105bc1:	76 2d                	jbe    80105bf0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bc6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105bc8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105bca:	39 d3                	cmp    %edx,%ebx
80105bcc:	73 22                	jae    80105bf0 <fetchstr+0x40>
80105bce:	89 d8                	mov    %ebx,%eax
80105bd0:	eb 0d                	jmp    80105bdf <fetchstr+0x2f>
80105bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bd8:	83 c0 01             	add    $0x1,%eax
80105bdb:	39 c2                	cmp    %eax,%edx
80105bdd:	76 11                	jbe    80105bf0 <fetchstr+0x40>
    if(*s == 0)
80105bdf:	80 38 00             	cmpb   $0x0,(%eax)
80105be2:	75 f4                	jne    80105bd8 <fetchstr+0x28>
      return s - *pp;
80105be4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be9:	c9                   	leave  
80105bea:	c3                   	ret    
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop
80105bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bf8:	c9                   	leave  
80105bf9:	c3                   	ret    
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	56                   	push   %esi
80105c04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c05:	e8 46 f0 ff ff       	call   80104c50 <myproc>
80105c0a:	8b 55 08             	mov    0x8(%ebp),%edx
80105c0d:	8b 40 18             	mov    0x18(%eax),%eax
80105c10:	8b 40 44             	mov    0x44(%eax),%eax
80105c13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c16:	e8 35 f0 ff ff       	call   80104c50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c1e:	8b 00                	mov    (%eax),%eax
80105c20:	39 c6                	cmp    %eax,%esi
80105c22:	73 1c                	jae    80105c40 <argint+0x40>
80105c24:	8d 53 08             	lea    0x8(%ebx),%edx
80105c27:	39 d0                	cmp    %edx,%eax
80105c29:	72 15                	jb     80105c40 <argint+0x40>
  *ip = *(int*)(addr);
80105c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c2e:	8b 53 04             	mov    0x4(%ebx),%edx
80105c31:	89 10                	mov    %edx,(%eax)
  return 0;
80105c33:	31 c0                	xor    %eax,%eax
}
80105c35:	5b                   	pop    %ebx
80105c36:	5e                   	pop    %esi
80105c37:	5d                   	pop    %ebp
80105c38:	c3                   	ret    
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c45:	eb ee                	jmp    80105c35 <argint+0x35>
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
80105c56:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105c59:	e8 f2 ef ff ff       	call   80104c50 <myproc>
80105c5e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c60:	e8 eb ef ff ff       	call   80104c50 <myproc>
80105c65:	8b 55 08             	mov    0x8(%ebp),%edx
80105c68:	8b 40 18             	mov    0x18(%eax),%eax
80105c6b:	8b 40 44             	mov    0x44(%eax),%eax
80105c6e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c71:	e8 da ef ff ff       	call   80104c50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c76:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c79:	8b 00                	mov    (%eax),%eax
80105c7b:	39 c7                	cmp    %eax,%edi
80105c7d:	73 31                	jae    80105cb0 <argptr+0x60>
80105c7f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105c82:	39 c8                	cmp    %ecx,%eax
80105c84:	72 2a                	jb     80105cb0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c86:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105c89:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c8c:	85 d2                	test   %edx,%edx
80105c8e:	78 20                	js     80105cb0 <argptr+0x60>
80105c90:	8b 16                	mov    (%esi),%edx
80105c92:	39 c2                	cmp    %eax,%edx
80105c94:	76 1a                	jbe    80105cb0 <argptr+0x60>
80105c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105c99:	01 c3                	add    %eax,%ebx
80105c9b:	39 da                	cmp    %ebx,%edx
80105c9d:	72 11                	jb     80105cb0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ca2:	89 02                	mov    %eax,(%edx)
  return 0;
80105ca4:	31 c0                	xor    %eax,%eax
}
80105ca6:	83 c4 0c             	add    $0xc,%esp
80105ca9:	5b                   	pop    %ebx
80105caa:	5e                   	pop    %esi
80105cab:	5f                   	pop    %edi
80105cac:	5d                   	pop    %ebp
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax
    return -1;
80105cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb5:	eb ef                	jmp    80105ca6 <argptr+0x56>
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	56                   	push   %esi
80105cc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105cc5:	e8 86 ef ff ff       	call   80104c50 <myproc>
80105cca:	8b 55 08             	mov    0x8(%ebp),%edx
80105ccd:	8b 40 18             	mov    0x18(%eax),%eax
80105cd0:	8b 40 44             	mov    0x44(%eax),%eax
80105cd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105cd6:	e8 75 ef ff ff       	call   80104c50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105cdb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105cde:	8b 00                	mov    (%eax),%eax
80105ce0:	39 c6                	cmp    %eax,%esi
80105ce2:	73 44                	jae    80105d28 <argstr+0x68>
80105ce4:	8d 53 08             	lea    0x8(%ebx),%edx
80105ce7:	39 d0                	cmp    %edx,%eax
80105ce9:	72 3d                	jb     80105d28 <argstr+0x68>
  *ip = *(int*)(addr);
80105ceb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105cee:	e8 5d ef ff ff       	call   80104c50 <myproc>
  if(addr >= curproc->sz)
80105cf3:	3b 18                	cmp    (%eax),%ebx
80105cf5:	73 31                	jae    80105d28 <argstr+0x68>
  *pp = (char*)addr;
80105cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cfa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105cfc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105cfe:	39 d3                	cmp    %edx,%ebx
80105d00:	73 26                	jae    80105d28 <argstr+0x68>
80105d02:	89 d8                	mov    %ebx,%eax
80105d04:	eb 11                	jmp    80105d17 <argstr+0x57>
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
80105d10:	83 c0 01             	add    $0x1,%eax
80105d13:	39 c2                	cmp    %eax,%edx
80105d15:	76 11                	jbe    80105d28 <argstr+0x68>
    if(*s == 0)
80105d17:	80 38 00             	cmpb   $0x0,(%eax)
80105d1a:	75 f4                	jne    80105d10 <argstr+0x50>
      return s - *pp;
80105d1c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105d1e:	5b                   	pop    %ebx
80105d1f:	5e                   	pop    %esi
80105d20:	5d                   	pop    %ebp
80105d21:	c3                   	ret    
80105d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d28:	5b                   	pop    %ebx
    return -1;
80105d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d2e:	5e                   	pop    %esi
80105d2f:	5d                   	pop    %ebp
80105d30:	c3                   	ret    
80105d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3f:	90                   	nop

80105d40 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	53                   	push   %ebx
80105d44:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105d47:	e8 04 ef ff ff       	call   80104c50 <myproc>
80105d4c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105d4e:	8b 40 18             	mov    0x18(%eax),%eax
80105d51:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105d54:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d57:	83 fa 14             	cmp    $0x14,%edx
80105d5a:	77 24                	ja     80105d80 <syscall+0x40>
80105d5c:	8b 14 85 80 8b 10 80 	mov    -0x7fef7480(,%eax,4),%edx
80105d63:	85 d2                	test   %edx,%edx
80105d65:	74 19                	je     80105d80 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105d67:	ff d2                	call   *%edx
80105d69:	89 c2                	mov    %eax,%edx
80105d6b:	8b 43 18             	mov    0x18(%ebx),%eax
80105d6e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d74:	c9                   	leave  
80105d75:	c3                   	ret    
80105d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105d80:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105d81:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105d84:	50                   	push   %eax
80105d85:	ff 73 10             	push   0x10(%ebx)
80105d88:	68 5d 8b 10 80       	push   $0x80108b5d
80105d8d:	e8 4e aa ff ff       	call   801007e0 <cprintf>
    curproc->tf->eax = -1;
80105d92:	8b 43 18             	mov    0x18(%ebx),%eax
80105d95:	83 c4 10             	add    $0x10,%esp
80105d98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da2:	c9                   	leave  
80105da3:	c3                   	ret    
80105da4:	66 90                	xchg   %ax,%ax
80105da6:	66 90                	xchg   %ax,%ax
80105da8:	66 90                	xchg   %ax,%ax
80105daa:	66 90                	xchg   %ax,%ax
80105dac:	66 90                	xchg   %ax,%ax
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105db5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105db8:	53                   	push   %ebx
80105db9:	83 ec 34             	sub    $0x34,%esp
80105dbc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105dbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105dc2:	57                   	push   %edi
80105dc3:	50                   	push   %eax
{
80105dc4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105dc7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105dca:	e8 d1 d5 ff ff       	call   801033a0 <nameiparent>
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	85 c0                	test   %eax,%eax
80105dd4:	0f 84 46 01 00 00    	je     80105f20 <create+0x170>
    return 0;
  ilock(dp);
80105dda:	83 ec 0c             	sub    $0xc,%esp
80105ddd:	89 c3                	mov    %eax,%ebx
80105ddf:	50                   	push   %eax
80105de0:	e8 7b cc ff ff       	call   80102a60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105de5:	83 c4 0c             	add    $0xc,%esp
80105de8:	6a 00                	push   $0x0
80105dea:	57                   	push   %edi
80105deb:	53                   	push   %ebx
80105dec:	e8 cf d1 ff ff       	call   80102fc0 <dirlookup>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	89 c6                	mov    %eax,%esi
80105df6:	85 c0                	test   %eax,%eax
80105df8:	74 56                	je     80105e50 <create+0xa0>
    iunlockput(dp);
80105dfa:	83 ec 0c             	sub    $0xc,%esp
80105dfd:	53                   	push   %ebx
80105dfe:	e8 ed ce ff ff       	call   80102cf0 <iunlockput>
    ilock(ip);
80105e03:	89 34 24             	mov    %esi,(%esp)
80105e06:	e8 55 cc ff ff       	call   80102a60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e0b:	83 c4 10             	add    $0x10,%esp
80105e0e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e13:	75 1b                	jne    80105e30 <create+0x80>
80105e15:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105e1a:	75 14                	jne    80105e30 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e1f:	89 f0                	mov    %esi,%eax
80105e21:	5b                   	pop    %ebx
80105e22:	5e                   	pop    %esi
80105e23:	5f                   	pop    %edi
80105e24:	5d                   	pop    %ebp
80105e25:	c3                   	ret    
80105e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	56                   	push   %esi
    return 0;
80105e34:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105e36:	e8 b5 ce ff ff       	call   80102cf0 <iunlockput>
    return 0;
80105e3b:	83 c4 10             	add    $0x10,%esp
}
80105e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e41:	89 f0                	mov    %esi,%eax
80105e43:	5b                   	pop    %ebx
80105e44:	5e                   	pop    %esi
80105e45:	5f                   	pop    %edi
80105e46:	5d                   	pop    %ebp
80105e47:	c3                   	ret    
80105e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105e50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105e54:	83 ec 08             	sub    $0x8,%esp
80105e57:	50                   	push   %eax
80105e58:	ff 33                	push   (%ebx)
80105e5a:	e8 91 ca ff ff       	call   801028f0 <ialloc>
80105e5f:	83 c4 10             	add    $0x10,%esp
80105e62:	89 c6                	mov    %eax,%esi
80105e64:	85 c0                	test   %eax,%eax
80105e66:	0f 84 cd 00 00 00    	je     80105f39 <create+0x189>
  ilock(ip);
80105e6c:	83 ec 0c             	sub    $0xc,%esp
80105e6f:	50                   	push   %eax
80105e70:	e8 eb cb ff ff       	call   80102a60 <ilock>
  ip->major = major;
80105e75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105e79:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105e7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105e81:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105e85:	b8 01 00 00 00       	mov    $0x1,%eax
80105e8a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105e8e:	89 34 24             	mov    %esi,(%esp)
80105e91:	e8 1a cb ff ff       	call   801029b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e96:	83 c4 10             	add    $0x10,%esp
80105e99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e9e:	74 30                	je     80105ed0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105ea0:	83 ec 04             	sub    $0x4,%esp
80105ea3:	ff 76 04             	push   0x4(%esi)
80105ea6:	57                   	push   %edi
80105ea7:	53                   	push   %ebx
80105ea8:	e8 13 d4 ff ff       	call   801032c0 <dirlink>
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	85 c0                	test   %eax,%eax
80105eb2:	78 78                	js     80105f2c <create+0x17c>
  iunlockput(dp);
80105eb4:	83 ec 0c             	sub    $0xc,%esp
80105eb7:	53                   	push   %ebx
80105eb8:	e8 33 ce ff ff       	call   80102cf0 <iunlockput>
  return ip;
80105ebd:	83 c4 10             	add    $0x10,%esp
}
80105ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec3:	89 f0                	mov    %esi,%eax
80105ec5:	5b                   	pop    %ebx
80105ec6:	5e                   	pop    %esi
80105ec7:	5f                   	pop    %edi
80105ec8:	5d                   	pop    %ebp
80105ec9:	c3                   	ret    
80105eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105ed3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105ed8:	53                   	push   %ebx
80105ed9:	e8 d2 ca ff ff       	call   801029b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ede:	83 c4 0c             	add    $0xc,%esp
80105ee1:	ff 76 04             	push   0x4(%esi)
80105ee4:	68 f4 8b 10 80       	push   $0x80108bf4
80105ee9:	56                   	push   %esi
80105eea:	e8 d1 d3 ff ff       	call   801032c0 <dirlink>
80105eef:	83 c4 10             	add    $0x10,%esp
80105ef2:	85 c0                	test   %eax,%eax
80105ef4:	78 18                	js     80105f0e <create+0x15e>
80105ef6:	83 ec 04             	sub    $0x4,%esp
80105ef9:	ff 73 04             	push   0x4(%ebx)
80105efc:	68 f3 8b 10 80       	push   $0x80108bf3
80105f01:	56                   	push   %esi
80105f02:	e8 b9 d3 ff ff       	call   801032c0 <dirlink>
80105f07:	83 c4 10             	add    $0x10,%esp
80105f0a:	85 c0                	test   %eax,%eax
80105f0c:	79 92                	jns    80105ea0 <create+0xf0>
      panic("create dots");
80105f0e:	83 ec 0c             	sub    $0xc,%esp
80105f11:	68 e7 8b 10 80       	push   $0x80108be7
80105f16:	e8 45 a5 ff ff       	call   80100460 <panic>
80105f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f1f:	90                   	nop
}
80105f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105f23:	31 f6                	xor    %esi,%esi
}
80105f25:	5b                   	pop    %ebx
80105f26:	89 f0                	mov    %esi,%eax
80105f28:	5e                   	pop    %esi
80105f29:	5f                   	pop    %edi
80105f2a:	5d                   	pop    %ebp
80105f2b:	c3                   	ret    
    panic("create: dirlink");
80105f2c:	83 ec 0c             	sub    $0xc,%esp
80105f2f:	68 f6 8b 10 80       	push   $0x80108bf6
80105f34:	e8 27 a5 ff ff       	call   80100460 <panic>
    panic("create: ialloc");
80105f39:	83 ec 0c             	sub    $0xc,%esp
80105f3c:	68 d8 8b 10 80       	push   $0x80108bd8
80105f41:	e8 1a a5 ff ff       	call   80100460 <panic>
80105f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi

80105f50 <sys_dup>:
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	56                   	push   %esi
80105f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105f5b:	50                   	push   %eax
80105f5c:	6a 00                	push   $0x0
80105f5e:	e8 9d fc ff ff       	call   80105c00 <argint>
80105f63:	83 c4 10             	add    $0x10,%esp
80105f66:	85 c0                	test   %eax,%eax
80105f68:	78 36                	js     80105fa0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f6e:	77 30                	ja     80105fa0 <sys_dup+0x50>
80105f70:	e8 db ec ff ff       	call   80104c50 <myproc>
80105f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105f7c:	85 f6                	test   %esi,%esi
80105f7e:	74 20                	je     80105fa0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105f80:	e8 cb ec ff ff       	call   80104c50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f85:	31 db                	xor    %ebx,%ebx
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105f90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f94:	85 d2                	test   %edx,%edx
80105f96:	74 18                	je     80105fb0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105f98:	83 c3 01             	add    $0x1,%ebx
80105f9b:	83 fb 10             	cmp    $0x10,%ebx
80105f9e:	75 f0                	jne    80105f90 <sys_dup+0x40>
}
80105fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105fa3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105fa8:	89 d8                	mov    %ebx,%eax
80105faa:	5b                   	pop    %ebx
80105fab:	5e                   	pop    %esi
80105fac:	5d                   	pop    %ebp
80105fad:	c3                   	ret    
80105fae:	66 90                	xchg   %ax,%ax
  filedup(f);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105fb3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105fb7:	56                   	push   %esi
80105fb8:	e8 c3 c1 ff ff       	call   80102180 <filedup>
  return fd;
80105fbd:	83 c4 10             	add    $0x10,%esp
}
80105fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fc3:	89 d8                	mov    %ebx,%eax
80105fc5:	5b                   	pop    %ebx
80105fc6:	5e                   	pop    %esi
80105fc7:	5d                   	pop    %ebp
80105fc8:	c3                   	ret    
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_read>:
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	56                   	push   %esi
80105fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105fd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105fd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105fdb:	53                   	push   %ebx
80105fdc:	6a 00                	push   $0x0
80105fde:	e8 1d fc ff ff       	call   80105c00 <argint>
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	85 c0                	test   %eax,%eax
80105fe8:	78 5e                	js     80106048 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105fea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105fee:	77 58                	ja     80106048 <sys_read+0x78>
80105ff0:	e8 5b ec ff ff       	call   80104c50 <myproc>
80105ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ff8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105ffc:	85 f6                	test   %esi,%esi
80105ffe:	74 48                	je     80106048 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106000:	83 ec 08             	sub    $0x8,%esp
80106003:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106006:	50                   	push   %eax
80106007:	6a 02                	push   $0x2
80106009:	e8 f2 fb ff ff       	call   80105c00 <argint>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	85 c0                	test   %eax,%eax
80106013:	78 33                	js     80106048 <sys_read+0x78>
80106015:	83 ec 04             	sub    $0x4,%esp
80106018:	ff 75 f0             	push   -0x10(%ebp)
8010601b:	53                   	push   %ebx
8010601c:	6a 01                	push   $0x1
8010601e:	e8 2d fc ff ff       	call   80105c50 <argptr>
80106023:	83 c4 10             	add    $0x10,%esp
80106026:	85 c0                	test   %eax,%eax
80106028:	78 1e                	js     80106048 <sys_read+0x78>
  return fileread(f, p, n);
8010602a:	83 ec 04             	sub    $0x4,%esp
8010602d:	ff 75 f0             	push   -0x10(%ebp)
80106030:	ff 75 f4             	push   -0xc(%ebp)
80106033:	56                   	push   %esi
80106034:	e8 c7 c2 ff ff       	call   80102300 <fileread>
80106039:	83 c4 10             	add    $0x10,%esp
}
8010603c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010603f:	5b                   	pop    %ebx
80106040:	5e                   	pop    %esi
80106041:	5d                   	pop    %ebp
80106042:	c3                   	ret    
80106043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106047:	90                   	nop
    return -1;
80106048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604d:	eb ed                	jmp    8010603c <sys_read+0x6c>
8010604f:	90                   	nop

80106050 <sys_write>:
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	56                   	push   %esi
80106054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106055:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010605b:	53                   	push   %ebx
8010605c:	6a 00                	push   $0x0
8010605e:	e8 9d fb ff ff       	call   80105c00 <argint>
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	85 c0                	test   %eax,%eax
80106068:	78 5e                	js     801060c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010606a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010606e:	77 58                	ja     801060c8 <sys_write+0x78>
80106070:	e8 db eb ff ff       	call   80104c50 <myproc>
80106075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106078:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010607c:	85 f6                	test   %esi,%esi
8010607e:	74 48                	je     801060c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106086:	50                   	push   %eax
80106087:	6a 02                	push   $0x2
80106089:	e8 72 fb ff ff       	call   80105c00 <argint>
8010608e:	83 c4 10             	add    $0x10,%esp
80106091:	85 c0                	test   %eax,%eax
80106093:	78 33                	js     801060c8 <sys_write+0x78>
80106095:	83 ec 04             	sub    $0x4,%esp
80106098:	ff 75 f0             	push   -0x10(%ebp)
8010609b:	53                   	push   %ebx
8010609c:	6a 01                	push   $0x1
8010609e:	e8 ad fb ff ff       	call   80105c50 <argptr>
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	85 c0                	test   %eax,%eax
801060a8:	78 1e                	js     801060c8 <sys_write+0x78>
  return filewrite(f, p, n);
801060aa:	83 ec 04             	sub    $0x4,%esp
801060ad:	ff 75 f0             	push   -0x10(%ebp)
801060b0:	ff 75 f4             	push   -0xc(%ebp)
801060b3:	56                   	push   %esi
801060b4:	e8 d7 c2 ff ff       	call   80102390 <filewrite>
801060b9:	83 c4 10             	add    $0x10,%esp
}
801060bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060bf:	5b                   	pop    %ebx
801060c0:	5e                   	pop    %esi
801060c1:	5d                   	pop    %ebp
801060c2:	c3                   	ret    
801060c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060c7:	90                   	nop
    return -1;
801060c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060cd:	eb ed                	jmp    801060bc <sys_write+0x6c>
801060cf:	90                   	nop

801060d0 <sys_close>:
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	56                   	push   %esi
801060d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801060d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801060db:	50                   	push   %eax
801060dc:	6a 00                	push   $0x0
801060de:	e8 1d fb ff ff       	call   80105c00 <argint>
801060e3:	83 c4 10             	add    $0x10,%esp
801060e6:	85 c0                	test   %eax,%eax
801060e8:	78 3e                	js     80106128 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801060ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801060ee:	77 38                	ja     80106128 <sys_close+0x58>
801060f0:	e8 5b eb ff ff       	call   80104c50 <myproc>
801060f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060f8:	8d 5a 08             	lea    0x8(%edx),%ebx
801060fb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801060ff:	85 f6                	test   %esi,%esi
80106101:	74 25                	je     80106128 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106103:	e8 48 eb ff ff       	call   80104c50 <myproc>
  fileclose(f);
80106108:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010610b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106112:	00 
  fileclose(f);
80106113:	56                   	push   %esi
80106114:	e8 b7 c0 ff ff       	call   801021d0 <fileclose>
  return 0;
80106119:	83 c4 10             	add    $0x10,%esp
8010611c:	31 c0                	xor    %eax,%eax
}
8010611e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106121:	5b                   	pop    %ebx
80106122:	5e                   	pop    %esi
80106123:	5d                   	pop    %ebp
80106124:	c3                   	ret    
80106125:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612d:	eb ef                	jmp    8010611e <sys_close+0x4e>
8010612f:	90                   	nop

80106130 <sys_fstat>:
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	56                   	push   %esi
80106134:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106135:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106138:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010613b:	53                   	push   %ebx
8010613c:	6a 00                	push   $0x0
8010613e:	e8 bd fa ff ff       	call   80105c00 <argint>
80106143:	83 c4 10             	add    $0x10,%esp
80106146:	85 c0                	test   %eax,%eax
80106148:	78 46                	js     80106190 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010614a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010614e:	77 40                	ja     80106190 <sys_fstat+0x60>
80106150:	e8 fb ea ff ff       	call   80104c50 <myproc>
80106155:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106158:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010615c:	85 f6                	test   %esi,%esi
8010615e:	74 30                	je     80106190 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106160:	83 ec 04             	sub    $0x4,%esp
80106163:	6a 14                	push   $0x14
80106165:	53                   	push   %ebx
80106166:	6a 01                	push   $0x1
80106168:	e8 e3 fa ff ff       	call   80105c50 <argptr>
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	85 c0                	test   %eax,%eax
80106172:	78 1c                	js     80106190 <sys_fstat+0x60>
  return filestat(f, st);
80106174:	83 ec 08             	sub    $0x8,%esp
80106177:	ff 75 f4             	push   -0xc(%ebp)
8010617a:	56                   	push   %esi
8010617b:	e8 30 c1 ff ff       	call   801022b0 <filestat>
80106180:	83 c4 10             	add    $0x10,%esp
}
80106183:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106186:	5b                   	pop    %ebx
80106187:	5e                   	pop    %esi
80106188:	5d                   	pop    %ebp
80106189:	c3                   	ret    
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106195:	eb ec                	jmp    80106183 <sys_fstat+0x53>
80106197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <sys_link>:
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	57                   	push   %edi
801061a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801061a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801061a8:	53                   	push   %ebx
801061a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801061ac:	50                   	push   %eax
801061ad:	6a 00                	push   $0x0
801061af:	e8 0c fb ff ff       	call   80105cc0 <argstr>
801061b4:	83 c4 10             	add    $0x10,%esp
801061b7:	85 c0                	test   %eax,%eax
801061b9:	0f 88 fb 00 00 00    	js     801062ba <sys_link+0x11a>
801061bf:	83 ec 08             	sub    $0x8,%esp
801061c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801061c5:	50                   	push   %eax
801061c6:	6a 01                	push   $0x1
801061c8:	e8 f3 fa ff ff       	call   80105cc0 <argstr>
801061cd:	83 c4 10             	add    $0x10,%esp
801061d0:	85 c0                	test   %eax,%eax
801061d2:	0f 88 e2 00 00 00    	js     801062ba <sys_link+0x11a>
  begin_op();
801061d8:	e8 63 de ff ff       	call   80104040 <begin_op>
  if((ip = namei(old)) == 0){
801061dd:	83 ec 0c             	sub    $0xc,%esp
801061e0:	ff 75 d4             	push   -0x2c(%ebp)
801061e3:	e8 98 d1 ff ff       	call   80103380 <namei>
801061e8:	83 c4 10             	add    $0x10,%esp
801061eb:	89 c3                	mov    %eax,%ebx
801061ed:	85 c0                	test   %eax,%eax
801061ef:	0f 84 e4 00 00 00    	je     801062d9 <sys_link+0x139>
  ilock(ip);
801061f5:	83 ec 0c             	sub    $0xc,%esp
801061f8:	50                   	push   %eax
801061f9:	e8 62 c8 ff ff       	call   80102a60 <ilock>
  if(ip->type == T_DIR){
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106206:	0f 84 b5 00 00 00    	je     801062c1 <sys_link+0x121>
  iupdate(ip);
8010620c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010620f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106214:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106217:	53                   	push   %ebx
80106218:	e8 93 c7 ff ff       	call   801029b0 <iupdate>
  iunlock(ip);
8010621d:	89 1c 24             	mov    %ebx,(%esp)
80106220:	e8 1b c9 ff ff       	call   80102b40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106225:	58                   	pop    %eax
80106226:	5a                   	pop    %edx
80106227:	57                   	push   %edi
80106228:	ff 75 d0             	push   -0x30(%ebp)
8010622b:	e8 70 d1 ff ff       	call   801033a0 <nameiparent>
80106230:	83 c4 10             	add    $0x10,%esp
80106233:	89 c6                	mov    %eax,%esi
80106235:	85 c0                	test   %eax,%eax
80106237:	74 5b                	je     80106294 <sys_link+0xf4>
  ilock(dp);
80106239:	83 ec 0c             	sub    $0xc,%esp
8010623c:	50                   	push   %eax
8010623d:	e8 1e c8 ff ff       	call   80102a60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106242:	8b 03                	mov    (%ebx),%eax
80106244:	83 c4 10             	add    $0x10,%esp
80106247:	39 06                	cmp    %eax,(%esi)
80106249:	75 3d                	jne    80106288 <sys_link+0xe8>
8010624b:	83 ec 04             	sub    $0x4,%esp
8010624e:	ff 73 04             	push   0x4(%ebx)
80106251:	57                   	push   %edi
80106252:	56                   	push   %esi
80106253:	e8 68 d0 ff ff       	call   801032c0 <dirlink>
80106258:	83 c4 10             	add    $0x10,%esp
8010625b:	85 c0                	test   %eax,%eax
8010625d:	78 29                	js     80106288 <sys_link+0xe8>
  iunlockput(dp);
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	56                   	push   %esi
80106263:	e8 88 ca ff ff       	call   80102cf0 <iunlockput>
  iput(ip);
80106268:	89 1c 24             	mov    %ebx,(%esp)
8010626b:	e8 20 c9 ff ff       	call   80102b90 <iput>
  end_op();
80106270:	e8 3b de ff ff       	call   801040b0 <end_op>
  return 0;
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	31 c0                	xor    %eax,%eax
}
8010627a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010627d:	5b                   	pop    %ebx
8010627e:	5e                   	pop    %esi
8010627f:	5f                   	pop    %edi
80106280:	5d                   	pop    %ebp
80106281:	c3                   	ret    
80106282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106288:	83 ec 0c             	sub    $0xc,%esp
8010628b:	56                   	push   %esi
8010628c:	e8 5f ca ff ff       	call   80102cf0 <iunlockput>
    goto bad;
80106291:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106294:	83 ec 0c             	sub    $0xc,%esp
80106297:	53                   	push   %ebx
80106298:	e8 c3 c7 ff ff       	call   80102a60 <ilock>
  ip->nlink--;
8010629d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801062a2:	89 1c 24             	mov    %ebx,(%esp)
801062a5:	e8 06 c7 ff ff       	call   801029b0 <iupdate>
  iunlockput(ip);
801062aa:	89 1c 24             	mov    %ebx,(%esp)
801062ad:	e8 3e ca ff ff       	call   80102cf0 <iunlockput>
  end_op();
801062b2:	e8 f9 dd ff ff       	call   801040b0 <end_op>
  return -1;
801062b7:	83 c4 10             	add    $0x10,%esp
801062ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bf:	eb b9                	jmp    8010627a <sys_link+0xda>
    iunlockput(ip);
801062c1:	83 ec 0c             	sub    $0xc,%esp
801062c4:	53                   	push   %ebx
801062c5:	e8 26 ca ff ff       	call   80102cf0 <iunlockput>
    end_op();
801062ca:	e8 e1 dd ff ff       	call   801040b0 <end_op>
    return -1;
801062cf:	83 c4 10             	add    $0x10,%esp
801062d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d7:	eb a1                	jmp    8010627a <sys_link+0xda>
    end_op();
801062d9:	e8 d2 dd ff ff       	call   801040b0 <end_op>
    return -1;
801062de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e3:	eb 95                	jmp    8010627a <sys_link+0xda>
801062e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062f0 <sys_unlink>:
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	57                   	push   %edi
801062f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801062f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801062f8:	53                   	push   %ebx
801062f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801062fc:	50                   	push   %eax
801062fd:	6a 00                	push   $0x0
801062ff:	e8 bc f9 ff ff       	call   80105cc0 <argstr>
80106304:	83 c4 10             	add    $0x10,%esp
80106307:	85 c0                	test   %eax,%eax
80106309:	0f 88 7a 01 00 00    	js     80106489 <sys_unlink+0x199>
  begin_op();
8010630f:	e8 2c dd ff ff       	call   80104040 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106314:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106317:	83 ec 08             	sub    $0x8,%esp
8010631a:	53                   	push   %ebx
8010631b:	ff 75 c0             	push   -0x40(%ebp)
8010631e:	e8 7d d0 ff ff       	call   801033a0 <nameiparent>
80106323:	83 c4 10             	add    $0x10,%esp
80106326:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106329:	85 c0                	test   %eax,%eax
8010632b:	0f 84 62 01 00 00    	je     80106493 <sys_unlink+0x1a3>
  ilock(dp);
80106331:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106334:	83 ec 0c             	sub    $0xc,%esp
80106337:	57                   	push   %edi
80106338:	e8 23 c7 ff ff       	call   80102a60 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010633d:	58                   	pop    %eax
8010633e:	5a                   	pop    %edx
8010633f:	68 f4 8b 10 80       	push   $0x80108bf4
80106344:	53                   	push   %ebx
80106345:	e8 56 cc ff ff       	call   80102fa0 <namecmp>
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	85 c0                	test   %eax,%eax
8010634f:	0f 84 fb 00 00 00    	je     80106450 <sys_unlink+0x160>
80106355:	83 ec 08             	sub    $0x8,%esp
80106358:	68 f3 8b 10 80       	push   $0x80108bf3
8010635d:	53                   	push   %ebx
8010635e:	e8 3d cc ff ff       	call   80102fa0 <namecmp>
80106363:	83 c4 10             	add    $0x10,%esp
80106366:	85 c0                	test   %eax,%eax
80106368:	0f 84 e2 00 00 00    	je     80106450 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010636e:	83 ec 04             	sub    $0x4,%esp
80106371:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106374:	50                   	push   %eax
80106375:	53                   	push   %ebx
80106376:	57                   	push   %edi
80106377:	e8 44 cc ff ff       	call   80102fc0 <dirlookup>
8010637c:	83 c4 10             	add    $0x10,%esp
8010637f:	89 c3                	mov    %eax,%ebx
80106381:	85 c0                	test   %eax,%eax
80106383:	0f 84 c7 00 00 00    	je     80106450 <sys_unlink+0x160>
  ilock(ip);
80106389:	83 ec 0c             	sub    $0xc,%esp
8010638c:	50                   	push   %eax
8010638d:	e8 ce c6 ff ff       	call   80102a60 <ilock>
  if(ip->nlink < 1)
80106392:	83 c4 10             	add    $0x10,%esp
80106395:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010639a:	0f 8e 1c 01 00 00    	jle    801064bc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801063a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801063a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801063a8:	74 66                	je     80106410 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801063aa:	83 ec 04             	sub    $0x4,%esp
801063ad:	6a 10                	push   $0x10
801063af:	6a 00                	push   $0x0
801063b1:	57                   	push   %edi
801063b2:	e8 89 f5 ff ff       	call   80105940 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063b7:	6a 10                	push   $0x10
801063b9:	ff 75 c4             	push   -0x3c(%ebp)
801063bc:	57                   	push   %edi
801063bd:	ff 75 b4             	push   -0x4c(%ebp)
801063c0:	e8 ab ca ff ff       	call   80102e70 <writei>
801063c5:	83 c4 20             	add    $0x20,%esp
801063c8:	83 f8 10             	cmp    $0x10,%eax
801063cb:	0f 85 de 00 00 00    	jne    801064af <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801063d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801063d6:	0f 84 94 00 00 00    	je     80106470 <sys_unlink+0x180>
  iunlockput(dp);
801063dc:	83 ec 0c             	sub    $0xc,%esp
801063df:	ff 75 b4             	push   -0x4c(%ebp)
801063e2:	e8 09 c9 ff ff       	call   80102cf0 <iunlockput>
  ip->nlink--;
801063e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801063ec:	89 1c 24             	mov    %ebx,(%esp)
801063ef:	e8 bc c5 ff ff       	call   801029b0 <iupdate>
  iunlockput(ip);
801063f4:	89 1c 24             	mov    %ebx,(%esp)
801063f7:	e8 f4 c8 ff ff       	call   80102cf0 <iunlockput>
  end_op();
801063fc:	e8 af dc ff ff       	call   801040b0 <end_op>
  return 0;
80106401:	83 c4 10             	add    $0x10,%esp
80106404:	31 c0                	xor    %eax,%eax
}
80106406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106409:	5b                   	pop    %ebx
8010640a:	5e                   	pop    %esi
8010640b:	5f                   	pop    %edi
8010640c:	5d                   	pop    %ebp
8010640d:	c3                   	ret    
8010640e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106410:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106414:	76 94                	jbe    801063aa <sys_unlink+0xba>
80106416:	be 20 00 00 00       	mov    $0x20,%esi
8010641b:	eb 0b                	jmp    80106428 <sys_unlink+0x138>
8010641d:	8d 76 00             	lea    0x0(%esi),%esi
80106420:	83 c6 10             	add    $0x10,%esi
80106423:	3b 73 58             	cmp    0x58(%ebx),%esi
80106426:	73 82                	jae    801063aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106428:	6a 10                	push   $0x10
8010642a:	56                   	push   %esi
8010642b:	57                   	push   %edi
8010642c:	53                   	push   %ebx
8010642d:	e8 3e c9 ff ff       	call   80102d70 <readi>
80106432:	83 c4 10             	add    $0x10,%esp
80106435:	83 f8 10             	cmp    $0x10,%eax
80106438:	75 68                	jne    801064a2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010643a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010643f:	74 df                	je     80106420 <sys_unlink+0x130>
    iunlockput(ip);
80106441:	83 ec 0c             	sub    $0xc,%esp
80106444:	53                   	push   %ebx
80106445:	e8 a6 c8 ff ff       	call   80102cf0 <iunlockput>
    goto bad;
8010644a:	83 c4 10             	add    $0x10,%esp
8010644d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106450:	83 ec 0c             	sub    $0xc,%esp
80106453:	ff 75 b4             	push   -0x4c(%ebp)
80106456:	e8 95 c8 ff ff       	call   80102cf0 <iunlockput>
  end_op();
8010645b:	e8 50 dc ff ff       	call   801040b0 <end_op>
  return -1;
80106460:	83 c4 10             	add    $0x10,%esp
80106463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106468:	eb 9c                	jmp    80106406 <sys_unlink+0x116>
8010646a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106470:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106473:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106476:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010647b:	50                   	push   %eax
8010647c:	e8 2f c5 ff ff       	call   801029b0 <iupdate>
80106481:	83 c4 10             	add    $0x10,%esp
80106484:	e9 53 ff ff ff       	jmp    801063dc <sys_unlink+0xec>
    return -1;
80106489:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648e:	e9 73 ff ff ff       	jmp    80106406 <sys_unlink+0x116>
    end_op();
80106493:	e8 18 dc ff ff       	call   801040b0 <end_op>
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649d:	e9 64 ff ff ff       	jmp    80106406 <sys_unlink+0x116>
      panic("isdirempty: readi");
801064a2:	83 ec 0c             	sub    $0xc,%esp
801064a5:	68 18 8c 10 80       	push   $0x80108c18
801064aa:	e8 b1 9f ff ff       	call   80100460 <panic>
    panic("unlink: writei");
801064af:	83 ec 0c             	sub    $0xc,%esp
801064b2:	68 2a 8c 10 80       	push   $0x80108c2a
801064b7:	e8 a4 9f ff ff       	call   80100460 <panic>
    panic("unlink: nlink < 1");
801064bc:	83 ec 0c             	sub    $0xc,%esp
801064bf:	68 06 8c 10 80       	push   $0x80108c06
801064c4:	e8 97 9f ff ff       	call   80100460 <panic>
801064c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064d0 <sys_open>:

int
sys_open(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	57                   	push   %edi
801064d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801064d8:	53                   	push   %ebx
801064d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064dc:	50                   	push   %eax
801064dd:	6a 00                	push   $0x0
801064df:	e8 dc f7 ff ff       	call   80105cc0 <argstr>
801064e4:	83 c4 10             	add    $0x10,%esp
801064e7:	85 c0                	test   %eax,%eax
801064e9:	0f 88 8e 00 00 00    	js     8010657d <sys_open+0xad>
801064ef:	83 ec 08             	sub    $0x8,%esp
801064f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064f5:	50                   	push   %eax
801064f6:	6a 01                	push   $0x1
801064f8:	e8 03 f7 ff ff       	call   80105c00 <argint>
801064fd:	83 c4 10             	add    $0x10,%esp
80106500:	85 c0                	test   %eax,%eax
80106502:	78 79                	js     8010657d <sys_open+0xad>
    return -1;

  begin_op();
80106504:	e8 37 db ff ff       	call   80104040 <begin_op>

  if(omode & O_CREATE){
80106509:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010650d:	75 79                	jne    80106588 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010650f:	83 ec 0c             	sub    $0xc,%esp
80106512:	ff 75 e0             	push   -0x20(%ebp)
80106515:	e8 66 ce ff ff       	call   80103380 <namei>
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	89 c6                	mov    %eax,%esi
8010651f:	85 c0                	test   %eax,%eax
80106521:	0f 84 7e 00 00 00    	je     801065a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106527:	83 ec 0c             	sub    $0xc,%esp
8010652a:	50                   	push   %eax
8010652b:	e8 30 c5 ff ff       	call   80102a60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106530:	83 c4 10             	add    $0x10,%esp
80106533:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106538:	0f 84 c2 00 00 00    	je     80106600 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010653e:	e8 cd bb ff ff       	call   80102110 <filealloc>
80106543:	89 c7                	mov    %eax,%edi
80106545:	85 c0                	test   %eax,%eax
80106547:	74 23                	je     8010656c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106549:	e8 02 e7 ff ff       	call   80104c50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010654e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106550:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106554:	85 d2                	test   %edx,%edx
80106556:	74 60                	je     801065b8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106558:	83 c3 01             	add    $0x1,%ebx
8010655b:	83 fb 10             	cmp    $0x10,%ebx
8010655e:	75 f0                	jne    80106550 <sys_open+0x80>
    if(f)
      fileclose(f);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	57                   	push   %edi
80106564:	e8 67 bc ff ff       	call   801021d0 <fileclose>
80106569:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010656c:	83 ec 0c             	sub    $0xc,%esp
8010656f:	56                   	push   %esi
80106570:	e8 7b c7 ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106575:	e8 36 db ff ff       	call   801040b0 <end_op>
    return -1;
8010657a:	83 c4 10             	add    $0x10,%esp
8010657d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106582:	eb 6d                	jmp    801065f1 <sys_open+0x121>
80106584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106588:	83 ec 0c             	sub    $0xc,%esp
8010658b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010658e:	31 c9                	xor    %ecx,%ecx
80106590:	ba 02 00 00 00       	mov    $0x2,%edx
80106595:	6a 00                	push   $0x0
80106597:	e8 14 f8 ff ff       	call   80105db0 <create>
    if(ip == 0){
8010659c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010659f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801065a1:	85 c0                	test   %eax,%eax
801065a3:	75 99                	jne    8010653e <sys_open+0x6e>
      end_op();
801065a5:	e8 06 db ff ff       	call   801040b0 <end_op>
      return -1;
801065aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065af:	eb 40                	jmp    801065f1 <sys_open+0x121>
801065b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801065b8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801065bb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801065bf:	56                   	push   %esi
801065c0:	e8 7b c5 ff ff       	call   80102b40 <iunlock>
  end_op();
801065c5:	e8 e6 da ff ff       	call   801040b0 <end_op>

  f->type = FD_INODE;
801065ca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801065d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065d3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801065d6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801065d9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801065db:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801065e2:	f7 d0                	not    %eax
801065e4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065e7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801065ea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065ed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801065f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f4:	89 d8                	mov    %ebx,%eax
801065f6:	5b                   	pop    %ebx
801065f7:	5e                   	pop    %esi
801065f8:	5f                   	pop    %edi
801065f9:	5d                   	pop    %ebp
801065fa:	c3                   	ret    
801065fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106600:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106603:	85 c9                	test   %ecx,%ecx
80106605:	0f 84 33 ff ff ff    	je     8010653e <sys_open+0x6e>
8010660b:	e9 5c ff ff ff       	jmp    8010656c <sys_open+0x9c>

80106610 <sys_mkdir>:

int
sys_mkdir(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106616:	e8 25 da ff ff       	call   80104040 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010661b:	83 ec 08             	sub    $0x8,%esp
8010661e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106621:	50                   	push   %eax
80106622:	6a 00                	push   $0x0
80106624:	e8 97 f6 ff ff       	call   80105cc0 <argstr>
80106629:	83 c4 10             	add    $0x10,%esp
8010662c:	85 c0                	test   %eax,%eax
8010662e:	78 30                	js     80106660 <sys_mkdir+0x50>
80106630:	83 ec 0c             	sub    $0xc,%esp
80106633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106636:	31 c9                	xor    %ecx,%ecx
80106638:	ba 01 00 00 00       	mov    $0x1,%edx
8010663d:	6a 00                	push   $0x0
8010663f:	e8 6c f7 ff ff       	call   80105db0 <create>
80106644:	83 c4 10             	add    $0x10,%esp
80106647:	85 c0                	test   %eax,%eax
80106649:	74 15                	je     80106660 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010664b:	83 ec 0c             	sub    $0xc,%esp
8010664e:	50                   	push   %eax
8010664f:	e8 9c c6 ff ff       	call   80102cf0 <iunlockput>
  end_op();
80106654:	e8 57 da ff ff       	call   801040b0 <end_op>
  return 0;
80106659:	83 c4 10             	add    $0x10,%esp
8010665c:	31 c0                	xor    %eax,%eax
}
8010665e:	c9                   	leave  
8010665f:	c3                   	ret    
    end_op();
80106660:	e8 4b da ff ff       	call   801040b0 <end_op>
    return -1;
80106665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010666a:	c9                   	leave  
8010666b:	c3                   	ret    
8010666c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106670 <sys_mknod>:

int
sys_mknod(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106676:	e8 c5 d9 ff ff       	call   80104040 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010667b:	83 ec 08             	sub    $0x8,%esp
8010667e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106681:	50                   	push   %eax
80106682:	6a 00                	push   $0x0
80106684:	e8 37 f6 ff ff       	call   80105cc0 <argstr>
80106689:	83 c4 10             	add    $0x10,%esp
8010668c:	85 c0                	test   %eax,%eax
8010668e:	78 60                	js     801066f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106690:	83 ec 08             	sub    $0x8,%esp
80106693:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106696:	50                   	push   %eax
80106697:	6a 01                	push   $0x1
80106699:	e8 62 f5 ff ff       	call   80105c00 <argint>
  if((argstr(0, &path)) < 0 ||
8010669e:	83 c4 10             	add    $0x10,%esp
801066a1:	85 c0                	test   %eax,%eax
801066a3:	78 4b                	js     801066f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801066a5:	83 ec 08             	sub    $0x8,%esp
801066a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066ab:	50                   	push   %eax
801066ac:	6a 02                	push   $0x2
801066ae:	e8 4d f5 ff ff       	call   80105c00 <argint>
     argint(1, &major) < 0 ||
801066b3:	83 c4 10             	add    $0x10,%esp
801066b6:	85 c0                	test   %eax,%eax
801066b8:	78 36                	js     801066f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801066ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801066be:	83 ec 0c             	sub    $0xc,%esp
801066c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801066c5:	ba 03 00 00 00       	mov    $0x3,%edx
801066ca:	50                   	push   %eax
801066cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066ce:	e8 dd f6 ff ff       	call   80105db0 <create>
     argint(2, &minor) < 0 ||
801066d3:	83 c4 10             	add    $0x10,%esp
801066d6:	85 c0                	test   %eax,%eax
801066d8:	74 16                	je     801066f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801066da:	83 ec 0c             	sub    $0xc,%esp
801066dd:	50                   	push   %eax
801066de:	e8 0d c6 ff ff       	call   80102cf0 <iunlockput>
  end_op();
801066e3:	e8 c8 d9 ff ff       	call   801040b0 <end_op>
  return 0;
801066e8:	83 c4 10             	add    $0x10,%esp
801066eb:	31 c0                	xor    %eax,%eax
}
801066ed:	c9                   	leave  
801066ee:	c3                   	ret    
801066ef:	90                   	nop
    end_op();
801066f0:	e8 bb d9 ff ff       	call   801040b0 <end_op>
    return -1;
801066f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066fa:	c9                   	leave  
801066fb:	c3                   	ret    
801066fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106700 <sys_chdir>:

int
sys_chdir(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	56                   	push   %esi
80106704:	53                   	push   %ebx
80106705:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106708:	e8 43 e5 ff ff       	call   80104c50 <myproc>
8010670d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010670f:	e8 2c d9 ff ff       	call   80104040 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106714:	83 ec 08             	sub    $0x8,%esp
80106717:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010671a:	50                   	push   %eax
8010671b:	6a 00                	push   $0x0
8010671d:	e8 9e f5 ff ff       	call   80105cc0 <argstr>
80106722:	83 c4 10             	add    $0x10,%esp
80106725:	85 c0                	test   %eax,%eax
80106727:	78 77                	js     801067a0 <sys_chdir+0xa0>
80106729:	83 ec 0c             	sub    $0xc,%esp
8010672c:	ff 75 f4             	push   -0xc(%ebp)
8010672f:	e8 4c cc ff ff       	call   80103380 <namei>
80106734:	83 c4 10             	add    $0x10,%esp
80106737:	89 c3                	mov    %eax,%ebx
80106739:	85 c0                	test   %eax,%eax
8010673b:	74 63                	je     801067a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010673d:	83 ec 0c             	sub    $0xc,%esp
80106740:	50                   	push   %eax
80106741:	e8 1a c3 ff ff       	call   80102a60 <ilock>
  if(ip->type != T_DIR){
80106746:	83 c4 10             	add    $0x10,%esp
80106749:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010674e:	75 30                	jne    80106780 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106750:	83 ec 0c             	sub    $0xc,%esp
80106753:	53                   	push   %ebx
80106754:	e8 e7 c3 ff ff       	call   80102b40 <iunlock>
  iput(curproc->cwd);
80106759:	58                   	pop    %eax
8010675a:	ff 76 68             	push   0x68(%esi)
8010675d:	e8 2e c4 ff ff       	call   80102b90 <iput>
  end_op();
80106762:	e8 49 d9 ff ff       	call   801040b0 <end_op>
  curproc->cwd = ip;
80106767:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010676a:	83 c4 10             	add    $0x10,%esp
8010676d:	31 c0                	xor    %eax,%eax
}
8010676f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106772:	5b                   	pop    %ebx
80106773:	5e                   	pop    %esi
80106774:	5d                   	pop    %ebp
80106775:	c3                   	ret    
80106776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010677d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106780:	83 ec 0c             	sub    $0xc,%esp
80106783:	53                   	push   %ebx
80106784:	e8 67 c5 ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106789:	e8 22 d9 ff ff       	call   801040b0 <end_op>
    return -1;
8010678e:	83 c4 10             	add    $0x10,%esp
80106791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106796:	eb d7                	jmp    8010676f <sys_chdir+0x6f>
80106798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010679f:	90                   	nop
    end_op();
801067a0:	e8 0b d9 ff ff       	call   801040b0 <end_op>
    return -1;
801067a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067aa:	eb c3                	jmp    8010676f <sys_chdir+0x6f>
801067ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067b0 <sys_exec>:

int
sys_exec(void)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801067b5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801067bb:	53                   	push   %ebx
801067bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801067c2:	50                   	push   %eax
801067c3:	6a 00                	push   $0x0
801067c5:	e8 f6 f4 ff ff       	call   80105cc0 <argstr>
801067ca:	83 c4 10             	add    $0x10,%esp
801067cd:	85 c0                	test   %eax,%eax
801067cf:	0f 88 87 00 00 00    	js     8010685c <sys_exec+0xac>
801067d5:	83 ec 08             	sub    $0x8,%esp
801067d8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801067de:	50                   	push   %eax
801067df:	6a 01                	push   $0x1
801067e1:	e8 1a f4 ff ff       	call   80105c00 <argint>
801067e6:	83 c4 10             	add    $0x10,%esp
801067e9:	85 c0                	test   %eax,%eax
801067eb:	78 6f                	js     8010685c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801067ed:	83 ec 04             	sub    $0x4,%esp
801067f0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801067f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801067f8:	68 80 00 00 00       	push   $0x80
801067fd:	6a 00                	push   $0x0
801067ff:	56                   	push   %esi
80106800:	e8 3b f1 ff ff       	call   80105940 <memset>
80106805:	83 c4 10             	add    $0x10,%esp
80106808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010680f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106810:	83 ec 08             	sub    $0x8,%esp
80106813:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106819:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106820:	50                   	push   %eax
80106821:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106827:	01 f8                	add    %edi,%eax
80106829:	50                   	push   %eax
8010682a:	e8 41 f3 ff ff       	call   80105b70 <fetchint>
8010682f:	83 c4 10             	add    $0x10,%esp
80106832:	85 c0                	test   %eax,%eax
80106834:	78 26                	js     8010685c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106836:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010683c:	85 c0                	test   %eax,%eax
8010683e:	74 30                	je     80106870 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106840:	83 ec 08             	sub    $0x8,%esp
80106843:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106846:	52                   	push   %edx
80106847:	50                   	push   %eax
80106848:	e8 63 f3 ff ff       	call   80105bb0 <fetchstr>
8010684d:	83 c4 10             	add    $0x10,%esp
80106850:	85 c0                	test   %eax,%eax
80106852:	78 08                	js     8010685c <sys_exec+0xac>
  for(i=0;; i++){
80106854:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106857:	83 fb 20             	cmp    $0x20,%ebx
8010685a:	75 b4                	jne    80106810 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010685c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010685f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106864:	5b                   	pop    %ebx
80106865:	5e                   	pop    %esi
80106866:	5f                   	pop    %edi
80106867:	5d                   	pop    %ebp
80106868:	c3                   	ret    
80106869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106870:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106877:	00 00 00 00 
  return exec(path, argv);
8010687b:	83 ec 08             	sub    $0x8,%esp
8010687e:	56                   	push   %esi
8010687f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106885:	e8 06 b5 ff ff       	call   80101d90 <exec>
8010688a:	83 c4 10             	add    $0x10,%esp
}
8010688d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106890:	5b                   	pop    %ebx
80106891:	5e                   	pop    %esi
80106892:	5f                   	pop    %edi
80106893:	5d                   	pop    %ebp
80106894:	c3                   	ret    
80106895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068a0 <sys_pipe>:

int
sys_pipe(void)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801068a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801068a8:	53                   	push   %ebx
801068a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801068ac:	6a 08                	push   $0x8
801068ae:	50                   	push   %eax
801068af:	6a 00                	push   $0x0
801068b1:	e8 9a f3 ff ff       	call   80105c50 <argptr>
801068b6:	83 c4 10             	add    $0x10,%esp
801068b9:	85 c0                	test   %eax,%eax
801068bb:	78 4a                	js     80106907 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801068bd:	83 ec 08             	sub    $0x8,%esp
801068c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068c3:	50                   	push   %eax
801068c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801068c7:	50                   	push   %eax
801068c8:	e8 43 de ff ff       	call   80104710 <pipealloc>
801068cd:	83 c4 10             	add    $0x10,%esp
801068d0:	85 c0                	test   %eax,%eax
801068d2:	78 33                	js     80106907 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801068d7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801068d9:	e8 72 e3 ff ff       	call   80104c50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068de:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801068e0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801068e4:	85 f6                	test   %esi,%esi
801068e6:	74 28                	je     80106910 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801068e8:	83 c3 01             	add    $0x1,%ebx
801068eb:	83 fb 10             	cmp    $0x10,%ebx
801068ee:	75 f0                	jne    801068e0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801068f0:	83 ec 0c             	sub    $0xc,%esp
801068f3:	ff 75 e0             	push   -0x20(%ebp)
801068f6:	e8 d5 b8 ff ff       	call   801021d0 <fileclose>
    fileclose(wf);
801068fb:	58                   	pop    %eax
801068fc:	ff 75 e4             	push   -0x1c(%ebp)
801068ff:	e8 cc b8 ff ff       	call   801021d0 <fileclose>
    return -1;
80106904:	83 c4 10             	add    $0x10,%esp
80106907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690c:	eb 53                	jmp    80106961 <sys_pipe+0xc1>
8010690e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106910:	8d 73 08             	lea    0x8(%ebx),%esi
80106913:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010691a:	e8 31 e3 ff ff       	call   80104c50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010691f:	31 d2                	xor    %edx,%edx
80106921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106928:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010692c:	85 c9                	test   %ecx,%ecx
8010692e:	74 20                	je     80106950 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106930:	83 c2 01             	add    $0x1,%edx
80106933:	83 fa 10             	cmp    $0x10,%edx
80106936:	75 f0                	jne    80106928 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106938:	e8 13 e3 ff ff       	call   80104c50 <myproc>
8010693d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106944:	00 
80106945:	eb a9                	jmp    801068f0 <sys_pipe+0x50>
80106947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106950:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106954:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106957:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106959:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010695c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010695f:	31 c0                	xor    %eax,%eax
}
80106961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106964:	5b                   	pop    %ebx
80106965:	5e                   	pop    %esi
80106966:	5f                   	pop    %edi
80106967:	5d                   	pop    %ebp
80106968:	c3                   	ret    
80106969:	66 90                	xchg   %ax,%ax
8010696b:	66 90                	xchg   %ax,%ax
8010696d:	66 90                	xchg   %ax,%ax
8010696f:	90                   	nop

80106970 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106970:	e9 7b e4 ff ff       	jmp    80104df0 <fork>
80106975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010697c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106980 <sys_exit>:
}

int
sys_exit(void)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	83 ec 08             	sub    $0x8,%esp
  exit();
80106986:	e8 e5 e6 ff ff       	call   80105070 <exit>
  return 0;  // not reached
}
8010698b:	31 c0                	xor    %eax,%eax
8010698d:	c9                   	leave  
8010698e:	c3                   	ret    
8010698f:	90                   	nop

80106990 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106990:	e9 0b e8 ff ff       	jmp    801051a0 <wait>
80106995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069a0 <sys_kill>:
}

int
sys_kill(void)
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801069a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069a9:	50                   	push   %eax
801069aa:	6a 00                	push   $0x0
801069ac:	e8 4f f2 ff ff       	call   80105c00 <argint>
801069b1:	83 c4 10             	add    $0x10,%esp
801069b4:	85 c0                	test   %eax,%eax
801069b6:	78 18                	js     801069d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801069b8:	83 ec 0c             	sub    $0xc,%esp
801069bb:	ff 75 f4             	push   -0xc(%ebp)
801069be:	e8 7d ea ff ff       	call   80105440 <kill>
801069c3:	83 c4 10             	add    $0x10,%esp
}
801069c6:	c9                   	leave  
801069c7:	c3                   	ret    
801069c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069cf:	90                   	nop
801069d0:	c9                   	leave  
    return -1;
801069d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069d6:	c3                   	ret    
801069d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069de:	66 90                	xchg   %ax,%ax

801069e0 <sys_getpid>:

int
sys_getpid(void)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801069e6:	e8 65 e2 ff ff       	call   80104c50 <myproc>
801069eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801069ee:	c9                   	leave  
801069ef:	c3                   	ret    

801069f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801069f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801069fa:	50                   	push   %eax
801069fb:	6a 00                	push   $0x0
801069fd:	e8 fe f1 ff ff       	call   80105c00 <argint>
80106a02:	83 c4 10             	add    $0x10,%esp
80106a05:	85 c0                	test   %eax,%eax
80106a07:	78 27                	js     80106a30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106a09:	e8 42 e2 ff ff       	call   80104c50 <myproc>
  if(growproc(n) < 0)
80106a0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106a11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106a13:	ff 75 f4             	push   -0xc(%ebp)
80106a16:	e8 55 e3 ff ff       	call   80104d70 <growproc>
80106a1b:	83 c4 10             	add    $0x10,%esp
80106a1e:	85 c0                	test   %eax,%eax
80106a20:	78 0e                	js     80106a30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106a22:	89 d8                	mov    %ebx,%eax
80106a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a27:	c9                   	leave  
80106a28:	c3                   	ret    
80106a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106a30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a35:	eb eb                	jmp    80106a22 <sys_sbrk+0x32>
80106a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a3e:	66 90                	xchg   %ax,%ax

80106a40 <sys_sleep>:

int
sys_sleep(void)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106a47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106a4a:	50                   	push   %eax
80106a4b:	6a 00                	push   $0x0
80106a4d:	e8 ae f1 ff ff       	call   80105c00 <argint>
80106a52:	83 c4 10             	add    $0x10,%esp
80106a55:	85 c0                	test   %eax,%eax
80106a57:	0f 88 8a 00 00 00    	js     80106ae7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106a5d:	83 ec 0c             	sub    $0xc,%esp
80106a60:	68 20 58 11 80       	push   $0x80115820
80106a65:	e8 16 ee ff ff       	call   80105880 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106a6d:	8b 1d 00 58 11 80    	mov    0x80115800,%ebx
  while(ticks - ticks0 < n){
80106a73:	83 c4 10             	add    $0x10,%esp
80106a76:	85 d2                	test   %edx,%edx
80106a78:	75 27                	jne    80106aa1 <sys_sleep+0x61>
80106a7a:	eb 54                	jmp    80106ad0 <sys_sleep+0x90>
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106a80:	83 ec 08             	sub    $0x8,%esp
80106a83:	68 20 58 11 80       	push   $0x80115820
80106a88:	68 00 58 11 80       	push   $0x80115800
80106a8d:	e8 8e e8 ff ff       	call   80105320 <sleep>
  while(ticks - ticks0 < n){
80106a92:	a1 00 58 11 80       	mov    0x80115800,%eax
80106a97:	83 c4 10             	add    $0x10,%esp
80106a9a:	29 d8                	sub    %ebx,%eax
80106a9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106a9f:	73 2f                	jae    80106ad0 <sys_sleep+0x90>
    if(myproc()->killed){
80106aa1:	e8 aa e1 ff ff       	call   80104c50 <myproc>
80106aa6:	8b 40 24             	mov    0x24(%eax),%eax
80106aa9:	85 c0                	test   %eax,%eax
80106aab:	74 d3                	je     80106a80 <sys_sleep+0x40>
      release(&tickslock);
80106aad:	83 ec 0c             	sub    $0xc,%esp
80106ab0:	68 20 58 11 80       	push   $0x80115820
80106ab5:	e8 66 ed ff ff       	call   80105820 <release>
  }
  release(&tickslock);
  return 0;
}
80106aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106abd:	83 c4 10             	add    $0x10,%esp
80106ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ac5:	c9                   	leave  
80106ac6:	c3                   	ret    
80106ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ace:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106ad0:	83 ec 0c             	sub    $0xc,%esp
80106ad3:	68 20 58 11 80       	push   $0x80115820
80106ad8:	e8 43 ed ff ff       	call   80105820 <release>
  return 0;
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	31 c0                	xor    %eax,%eax
}
80106ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106ae5:	c9                   	leave  
80106ae6:	c3                   	ret    
    return -1;
80106ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aec:	eb f4                	jmp    80106ae2 <sys_sleep+0xa2>
80106aee:	66 90                	xchg   %ax,%ax

80106af0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	53                   	push   %ebx
80106af4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106af7:	68 20 58 11 80       	push   $0x80115820
80106afc:	e8 7f ed ff ff       	call   80105880 <acquire>
  xticks = ticks;
80106b01:	8b 1d 00 58 11 80    	mov    0x80115800,%ebx
  release(&tickslock);
80106b07:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
80106b0e:	e8 0d ed ff ff       	call   80105820 <release>
  return xticks;
}
80106b13:	89 d8                	mov    %ebx,%eax
80106b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b18:	c9                   	leave  
80106b19:	c3                   	ret    

80106b1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106b1a:	1e                   	push   %ds
  pushl %es
80106b1b:	06                   	push   %es
  pushl %fs
80106b1c:	0f a0                	push   %fs
  pushl %gs
80106b1e:	0f a8                	push   %gs
  pushal
80106b20:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106b21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106b25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106b27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106b29:	54                   	push   %esp
  call trap
80106b2a:	e8 c1 00 00 00       	call   80106bf0 <trap>
  addl $4, %esp
80106b2f:	83 c4 04             	add    $0x4,%esp

80106b32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106b32:	61                   	popa   
  popl %gs
80106b33:	0f a9                	pop    %gs
  popl %fs
80106b35:	0f a1                	pop    %fs
  popl %es
80106b37:	07                   	pop    %es
  popl %ds
80106b38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106b39:	83 c4 08             	add    $0x8,%esp
  iret
80106b3c:	cf                   	iret   
80106b3d:	66 90                	xchg   %ax,%ax
80106b3f:	90                   	nop

80106b40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106b40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106b41:	31 c0                	xor    %eax,%eax
{
80106b43:	89 e5                	mov    %esp,%ebp
80106b45:	83 ec 08             	sub    $0x8,%esp
80106b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106b50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106b57:	c7 04 c5 62 58 11 80 	movl   $0x8e000008,-0x7feea79e(,%eax,8)
80106b5e:	08 00 00 8e 
80106b62:	66 89 14 c5 60 58 11 	mov    %dx,-0x7feea7a0(,%eax,8)
80106b69:	80 
80106b6a:	c1 ea 10             	shr    $0x10,%edx
80106b6d:	66 89 14 c5 66 58 11 	mov    %dx,-0x7feea79a(,%eax,8)
80106b74:	80 
  for(i = 0; i < 256; i++)
80106b75:	83 c0 01             	add    $0x1,%eax
80106b78:	3d 00 01 00 00       	cmp    $0x100,%eax
80106b7d:	75 d1                	jne    80106b50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106b7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106b87:	c7 05 62 5a 11 80 08 	movl   $0xef000008,0x80115a62
80106b8e:	00 00 ef 
  initlock(&tickslock, "time");
80106b91:	68 39 8c 10 80       	push   $0x80108c39
80106b96:	68 20 58 11 80       	push   $0x80115820
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b9b:	66 a3 60 5a 11 80    	mov    %ax,0x80115a60
80106ba1:	c1 e8 10             	shr    $0x10,%eax
80106ba4:	66 a3 66 5a 11 80    	mov    %ax,0x80115a66
  initlock(&tickslock, "time");
80106baa:	e8 01 eb ff ff       	call   801056b0 <initlock>
}
80106baf:	83 c4 10             	add    $0x10,%esp
80106bb2:	c9                   	leave  
80106bb3:	c3                   	ret    
80106bb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop

80106bc0 <idtinit>:

void
idtinit(void)
{
80106bc0:	55                   	push   %ebp
  pd[0] = size-1;
80106bc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106bc6:	89 e5                	mov    %esp,%ebp
80106bc8:	83 ec 10             	sub    $0x10,%esp
80106bcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106bcf:	b8 60 58 11 80       	mov    $0x80115860,%eax
80106bd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106bd8:	c1 e8 10             	shr    $0x10,%eax
80106bdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106bdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106be2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106be5:	c9                   	leave  
80106be6:	c3                   	ret    
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106bfc:	8b 43 30             	mov    0x30(%ebx),%eax
80106bff:	83 f8 40             	cmp    $0x40,%eax
80106c02:	0f 84 68 01 00 00    	je     80106d70 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106c08:	83 e8 20             	sub    $0x20,%eax
80106c0b:	83 f8 1f             	cmp    $0x1f,%eax
80106c0e:	0f 87 8c 00 00 00    	ja     80106ca0 <trap+0xb0>
80106c14:	ff 24 85 e0 8c 10 80 	jmp    *-0x7fef7320(,%eax,4)
80106c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c1f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106c20:	e8 fb c8 ff ff       	call   80103520 <ideintr>
    lapiceoi();
80106c25:	e8 c6 cf ff ff       	call   80103bf0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c2a:	e8 21 e0 ff ff       	call   80104c50 <myproc>
80106c2f:	85 c0                	test   %eax,%eax
80106c31:	74 1d                	je     80106c50 <trap+0x60>
80106c33:	e8 18 e0 ff ff       	call   80104c50 <myproc>
80106c38:	8b 50 24             	mov    0x24(%eax),%edx
80106c3b:	85 d2                	test   %edx,%edx
80106c3d:	74 11                	je     80106c50 <trap+0x60>
80106c3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106c43:	83 e0 03             	and    $0x3,%eax
80106c46:	66 83 f8 03          	cmp    $0x3,%ax
80106c4a:	0f 84 e8 01 00 00    	je     80106e38 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106c50:	e8 fb df ff ff       	call   80104c50 <myproc>
80106c55:	85 c0                	test   %eax,%eax
80106c57:	74 0f                	je     80106c68 <trap+0x78>
80106c59:	e8 f2 df ff ff       	call   80104c50 <myproc>
80106c5e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106c62:	0f 84 b8 00 00 00    	je     80106d20 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c68:	e8 e3 df ff ff       	call   80104c50 <myproc>
80106c6d:	85 c0                	test   %eax,%eax
80106c6f:	74 1d                	je     80106c8e <trap+0x9e>
80106c71:	e8 da df ff ff       	call   80104c50 <myproc>
80106c76:	8b 40 24             	mov    0x24(%eax),%eax
80106c79:	85 c0                	test   %eax,%eax
80106c7b:	74 11                	je     80106c8e <trap+0x9e>
80106c7d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106c81:	83 e0 03             	and    $0x3,%eax
80106c84:	66 83 f8 03          	cmp    $0x3,%ax
80106c88:	0f 84 0f 01 00 00    	je     80106d9d <trap+0x1ad>
    exit();
}
80106c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c91:	5b                   	pop    %ebx
80106c92:	5e                   	pop    %esi
80106c93:	5f                   	pop    %edi
80106c94:	5d                   	pop    %ebp
80106c95:	c3                   	ret    
80106c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106ca0:	e8 ab df ff ff       	call   80104c50 <myproc>
80106ca5:	8b 7b 38             	mov    0x38(%ebx),%edi
80106ca8:	85 c0                	test   %eax,%eax
80106caa:	0f 84 a2 01 00 00    	je     80106e52 <trap+0x262>
80106cb0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106cb4:	0f 84 98 01 00 00    	je     80106e52 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106cba:	0f 20 d1             	mov    %cr2,%ecx
80106cbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cc0:	e8 6b df ff ff       	call   80104c30 <cpuid>
80106cc5:	8b 73 30             	mov    0x30(%ebx),%esi
80106cc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ccb:	8b 43 34             	mov    0x34(%ebx),%eax
80106cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106cd1:	e8 7a df ff ff       	call   80104c50 <myproc>
80106cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cd9:	e8 72 df ff ff       	call   80104c50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106ce1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106ce4:	51                   	push   %ecx
80106ce5:	57                   	push   %edi
80106ce6:	52                   	push   %edx
80106ce7:	ff 75 e4             	push   -0x1c(%ebp)
80106cea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106ceb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106cee:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cf1:	56                   	push   %esi
80106cf2:	ff 70 10             	push   0x10(%eax)
80106cf5:	68 9c 8c 10 80       	push   $0x80108c9c
80106cfa:	e8 e1 9a ff ff       	call   801007e0 <cprintf>
    myproc()->killed = 1;
80106cff:	83 c4 20             	add    $0x20,%esp
80106d02:	e8 49 df ff ff       	call   80104c50 <myproc>
80106d07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d0e:	e8 3d df ff ff       	call   80104c50 <myproc>
80106d13:	85 c0                	test   %eax,%eax
80106d15:	0f 85 18 ff ff ff    	jne    80106c33 <trap+0x43>
80106d1b:	e9 30 ff ff ff       	jmp    80106c50 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106d20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106d24:	0f 85 3e ff ff ff    	jne    80106c68 <trap+0x78>
    yield();
80106d2a:	e8 a1 e5 ff ff       	call   801052d0 <yield>
80106d2f:	e9 34 ff ff ff       	jmp    80106c68 <trap+0x78>
80106d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d38:	8b 7b 38             	mov    0x38(%ebx),%edi
80106d3b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106d3f:	e8 ec de ff ff       	call   80104c30 <cpuid>
80106d44:	57                   	push   %edi
80106d45:	56                   	push   %esi
80106d46:	50                   	push   %eax
80106d47:	68 44 8c 10 80       	push   $0x80108c44
80106d4c:	e8 8f 9a ff ff       	call   801007e0 <cprintf>
    lapiceoi();
80106d51:	e8 9a ce ff ff       	call   80103bf0 <lapiceoi>
    break;
80106d56:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d59:	e8 f2 de ff ff       	call   80104c50 <myproc>
80106d5e:	85 c0                	test   %eax,%eax
80106d60:	0f 85 cd fe ff ff    	jne    80106c33 <trap+0x43>
80106d66:	e9 e5 fe ff ff       	jmp    80106c50 <trap+0x60>
80106d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d6f:	90                   	nop
    if(myproc()->killed)
80106d70:	e8 db de ff ff       	call   80104c50 <myproc>
80106d75:	8b 70 24             	mov    0x24(%eax),%esi
80106d78:	85 f6                	test   %esi,%esi
80106d7a:	0f 85 c8 00 00 00    	jne    80106e48 <trap+0x258>
    myproc()->tf = tf;
80106d80:	e8 cb de ff ff       	call   80104c50 <myproc>
80106d85:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106d88:	e8 b3 ef ff ff       	call   80105d40 <syscall>
    if(myproc()->killed)
80106d8d:	e8 be de ff ff       	call   80104c50 <myproc>
80106d92:	8b 48 24             	mov    0x24(%eax),%ecx
80106d95:	85 c9                	test   %ecx,%ecx
80106d97:	0f 84 f1 fe ff ff    	je     80106c8e <trap+0x9e>
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da0:	5b                   	pop    %ebx
80106da1:	5e                   	pop    %esi
80106da2:	5f                   	pop    %edi
80106da3:	5d                   	pop    %ebp
      exit();
80106da4:	e9 c7 e2 ff ff       	jmp    80105070 <exit>
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106db0:	e8 3b 02 00 00       	call   80106ff0 <uartintr>
    lapiceoi();
80106db5:	e8 36 ce ff ff       	call   80103bf0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dba:	e8 91 de ff ff       	call   80104c50 <myproc>
80106dbf:	85 c0                	test   %eax,%eax
80106dc1:	0f 85 6c fe ff ff    	jne    80106c33 <trap+0x43>
80106dc7:	e9 84 fe ff ff       	jmp    80106c50 <trap+0x60>
80106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106dd0:	e8 db cc ff ff       	call   80103ab0 <kbdintr>
    lapiceoi();
80106dd5:	e8 16 ce ff ff       	call   80103bf0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dda:	e8 71 de ff ff       	call   80104c50 <myproc>
80106ddf:	85 c0                	test   %eax,%eax
80106de1:	0f 85 4c fe ff ff    	jne    80106c33 <trap+0x43>
80106de7:	e9 64 fe ff ff       	jmp    80106c50 <trap+0x60>
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106df0:	e8 3b de ff ff       	call   80104c30 <cpuid>
80106df5:	85 c0                	test   %eax,%eax
80106df7:	0f 85 28 fe ff ff    	jne    80106c25 <trap+0x35>
      acquire(&tickslock);
80106dfd:	83 ec 0c             	sub    $0xc,%esp
80106e00:	68 20 58 11 80       	push   $0x80115820
80106e05:	e8 76 ea ff ff       	call   80105880 <acquire>
      wakeup(&ticks);
80106e0a:	c7 04 24 00 58 11 80 	movl   $0x80115800,(%esp)
      ticks++;
80106e11:	83 05 00 58 11 80 01 	addl   $0x1,0x80115800
      wakeup(&ticks);
80106e18:	e8 c3 e5 ff ff       	call   801053e0 <wakeup>
      release(&tickslock);
80106e1d:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
80106e24:	e8 f7 e9 ff ff       	call   80105820 <release>
80106e29:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106e2c:	e9 f4 fd ff ff       	jmp    80106c25 <trap+0x35>
80106e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106e38:	e8 33 e2 ff ff       	call   80105070 <exit>
80106e3d:	e9 0e fe ff ff       	jmp    80106c50 <trap+0x60>
80106e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106e48:	e8 23 e2 ff ff       	call   80105070 <exit>
80106e4d:	e9 2e ff ff ff       	jmp    80106d80 <trap+0x190>
80106e52:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e55:	e8 d6 dd ff ff       	call   80104c30 <cpuid>
80106e5a:	83 ec 0c             	sub    $0xc,%esp
80106e5d:	56                   	push   %esi
80106e5e:	57                   	push   %edi
80106e5f:	50                   	push   %eax
80106e60:	ff 73 30             	push   0x30(%ebx)
80106e63:	68 68 8c 10 80       	push   $0x80108c68
80106e68:	e8 73 99 ff ff       	call   801007e0 <cprintf>
      panic("trap");
80106e6d:	83 c4 14             	add    $0x14,%esp
80106e70:	68 3e 8c 10 80       	push   $0x80108c3e
80106e75:	e8 e6 95 ff ff       	call   80100460 <panic>
80106e7a:	66 90                	xchg   %ax,%ax
80106e7c:	66 90                	xchg   %ax,%ax
80106e7e:	66 90                	xchg   %ax,%ax

80106e80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106e80:	a1 60 60 11 80       	mov    0x80116060,%eax
80106e85:	85 c0                	test   %eax,%eax
80106e87:	74 17                	je     80106ea0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e89:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e8e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106e8f:	a8 01                	test   $0x1,%al
80106e91:	74 0d                	je     80106ea0 <uartgetc+0x20>
80106e93:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106e99:	0f b6 c0             	movzbl %al,%eax
80106e9c:	c3                   	ret    
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ea5:	c3                   	ret    
80106ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ead:	8d 76 00             	lea    0x0(%esi),%esi

80106eb0 <uartinit>:
{
80106eb0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106eb1:	31 c9                	xor    %ecx,%ecx
80106eb3:	89 c8                	mov    %ecx,%eax
80106eb5:	89 e5                	mov    %esp,%ebp
80106eb7:	57                   	push   %edi
80106eb8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106ebd:	56                   	push   %esi
80106ebe:	89 fa                	mov    %edi,%edx
80106ec0:	53                   	push   %ebx
80106ec1:	83 ec 1c             	sub    $0x1c,%esp
80106ec4:	ee                   	out    %al,(%dx)
80106ec5:	be fb 03 00 00       	mov    $0x3fb,%esi
80106eca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106ecf:	89 f2                	mov    %esi,%edx
80106ed1:	ee                   	out    %al,(%dx)
80106ed2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ed7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106edc:	ee                   	out    %al,(%dx)
80106edd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106ee2:	89 c8                	mov    %ecx,%eax
80106ee4:	89 da                	mov    %ebx,%edx
80106ee6:	ee                   	out    %al,(%dx)
80106ee7:	b8 03 00 00 00       	mov    $0x3,%eax
80106eec:	89 f2                	mov    %esi,%edx
80106eee:	ee                   	out    %al,(%dx)
80106eef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ef4:	89 c8                	mov    %ecx,%eax
80106ef6:	ee                   	out    %al,(%dx)
80106ef7:	b8 01 00 00 00       	mov    $0x1,%eax
80106efc:	89 da                	mov    %ebx,%edx
80106efe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106eff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106f04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106f05:	3c ff                	cmp    $0xff,%al
80106f07:	74 78                	je     80106f81 <uartinit+0xd1>
  uart = 1;
80106f09:	c7 05 60 60 11 80 01 	movl   $0x1,0x80116060
80106f10:	00 00 00 
80106f13:	89 fa                	mov    %edi,%edx
80106f15:	ec                   	in     (%dx),%al
80106f16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106f1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106f1f:	bf 60 8d 10 80       	mov    $0x80108d60,%edi
80106f24:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106f29:	6a 00                	push   $0x0
80106f2b:	6a 04                	push   $0x4
80106f2d:	e8 2e c8 ff ff       	call   80103760 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106f32:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106f36:	83 c4 10             	add    $0x10,%esp
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106f40:	a1 60 60 11 80       	mov    0x80116060,%eax
80106f45:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f4a:	85 c0                	test   %eax,%eax
80106f4c:	75 14                	jne    80106f62 <uartinit+0xb2>
80106f4e:	eb 23                	jmp    80106f73 <uartinit+0xc3>
    microdelay(10);
80106f50:	83 ec 0c             	sub    $0xc,%esp
80106f53:	6a 0a                	push   $0xa
80106f55:	e8 b6 cc ff ff       	call   80103c10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f5a:	83 c4 10             	add    $0x10,%esp
80106f5d:	83 eb 01             	sub    $0x1,%ebx
80106f60:	74 07                	je     80106f69 <uartinit+0xb9>
80106f62:	89 f2                	mov    %esi,%edx
80106f64:	ec                   	in     (%dx),%al
80106f65:	a8 20                	test   $0x20,%al
80106f67:	74 e7                	je     80106f50 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f69:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106f6d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f72:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106f73:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106f77:	83 c7 01             	add    $0x1,%edi
80106f7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80106f7d:	84 c0                	test   %al,%al
80106f7f:	75 bf                	jne    80106f40 <uartinit+0x90>
}
80106f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f84:	5b                   	pop    %ebx
80106f85:	5e                   	pop    %esi
80106f86:	5f                   	pop    %edi
80106f87:	5d                   	pop    %ebp
80106f88:	c3                   	ret    
80106f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f90 <uartputc>:
  if(!uart)
80106f90:	a1 60 60 11 80       	mov    0x80116060,%eax
80106f95:	85 c0                	test   %eax,%eax
80106f97:	74 47                	je     80106fe0 <uartputc+0x50>
{
80106f99:	55                   	push   %ebp
80106f9a:	89 e5                	mov    %esp,%ebp
80106f9c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106fa2:	53                   	push   %ebx
80106fa3:	bb 80 00 00 00       	mov    $0x80,%ebx
80106fa8:	eb 18                	jmp    80106fc2 <uartputc+0x32>
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106fb0:	83 ec 0c             	sub    $0xc,%esp
80106fb3:	6a 0a                	push   $0xa
80106fb5:	e8 56 cc ff ff       	call   80103c10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106fba:	83 c4 10             	add    $0x10,%esp
80106fbd:	83 eb 01             	sub    $0x1,%ebx
80106fc0:	74 07                	je     80106fc9 <uartputc+0x39>
80106fc2:	89 f2                	mov    %esi,%edx
80106fc4:	ec                   	in     (%dx),%al
80106fc5:	a8 20                	test   $0x20,%al
80106fc7:	74 e7                	je     80106fb0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fd1:	ee                   	out    %al,(%dx)
}
80106fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fd5:	5b                   	pop    %ebx
80106fd6:	5e                   	pop    %esi
80106fd7:	5d                   	pop    %ebp
80106fd8:	c3                   	ret    
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe0:	c3                   	ret    
80106fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fef:	90                   	nop

80106ff0 <uartintr>:

void
uartintr(void)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106ff6:	68 80 6e 10 80       	push   $0x80106e80
80106ffb:	e8 40 a7 ff ff       	call   80101740 <consoleintr>
}
80107000:	83 c4 10             	add    $0x10,%esp
80107003:	c9                   	leave  
80107004:	c3                   	ret    

80107005 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $0
80107007:	6a 00                	push   $0x0
  jmp alltraps
80107009:	e9 0c fb ff ff       	jmp    80106b1a <alltraps>

8010700e <vector1>:
.globl vector1
vector1:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $1
80107010:	6a 01                	push   $0x1
  jmp alltraps
80107012:	e9 03 fb ff ff       	jmp    80106b1a <alltraps>

80107017 <vector2>:
.globl vector2
vector2:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $2
80107019:	6a 02                	push   $0x2
  jmp alltraps
8010701b:	e9 fa fa ff ff       	jmp    80106b1a <alltraps>

80107020 <vector3>:
.globl vector3
vector3:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $3
80107022:	6a 03                	push   $0x3
  jmp alltraps
80107024:	e9 f1 fa ff ff       	jmp    80106b1a <alltraps>

80107029 <vector4>:
.globl vector4
vector4:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $4
8010702b:	6a 04                	push   $0x4
  jmp alltraps
8010702d:	e9 e8 fa ff ff       	jmp    80106b1a <alltraps>

80107032 <vector5>:
.globl vector5
vector5:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $5
80107034:	6a 05                	push   $0x5
  jmp alltraps
80107036:	e9 df fa ff ff       	jmp    80106b1a <alltraps>

8010703b <vector6>:
.globl vector6
vector6:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $6
8010703d:	6a 06                	push   $0x6
  jmp alltraps
8010703f:	e9 d6 fa ff ff       	jmp    80106b1a <alltraps>

80107044 <vector7>:
.globl vector7
vector7:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $7
80107046:	6a 07                	push   $0x7
  jmp alltraps
80107048:	e9 cd fa ff ff       	jmp    80106b1a <alltraps>

8010704d <vector8>:
.globl vector8
vector8:
  pushl $8
8010704d:	6a 08                	push   $0x8
  jmp alltraps
8010704f:	e9 c6 fa ff ff       	jmp    80106b1a <alltraps>

80107054 <vector9>:
.globl vector9
vector9:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $9
80107056:	6a 09                	push   $0x9
  jmp alltraps
80107058:	e9 bd fa ff ff       	jmp    80106b1a <alltraps>

8010705d <vector10>:
.globl vector10
vector10:
  pushl $10
8010705d:	6a 0a                	push   $0xa
  jmp alltraps
8010705f:	e9 b6 fa ff ff       	jmp    80106b1a <alltraps>

80107064 <vector11>:
.globl vector11
vector11:
  pushl $11
80107064:	6a 0b                	push   $0xb
  jmp alltraps
80107066:	e9 af fa ff ff       	jmp    80106b1a <alltraps>

8010706b <vector12>:
.globl vector12
vector12:
  pushl $12
8010706b:	6a 0c                	push   $0xc
  jmp alltraps
8010706d:	e9 a8 fa ff ff       	jmp    80106b1a <alltraps>

80107072 <vector13>:
.globl vector13
vector13:
  pushl $13
80107072:	6a 0d                	push   $0xd
  jmp alltraps
80107074:	e9 a1 fa ff ff       	jmp    80106b1a <alltraps>

80107079 <vector14>:
.globl vector14
vector14:
  pushl $14
80107079:	6a 0e                	push   $0xe
  jmp alltraps
8010707b:	e9 9a fa ff ff       	jmp    80106b1a <alltraps>

80107080 <vector15>:
.globl vector15
vector15:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $15
80107082:	6a 0f                	push   $0xf
  jmp alltraps
80107084:	e9 91 fa ff ff       	jmp    80106b1a <alltraps>

80107089 <vector16>:
.globl vector16
vector16:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $16
8010708b:	6a 10                	push   $0x10
  jmp alltraps
8010708d:	e9 88 fa ff ff       	jmp    80106b1a <alltraps>

80107092 <vector17>:
.globl vector17
vector17:
  pushl $17
80107092:	6a 11                	push   $0x11
  jmp alltraps
80107094:	e9 81 fa ff ff       	jmp    80106b1a <alltraps>

80107099 <vector18>:
.globl vector18
vector18:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $18
8010709b:	6a 12                	push   $0x12
  jmp alltraps
8010709d:	e9 78 fa ff ff       	jmp    80106b1a <alltraps>

801070a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $19
801070a4:	6a 13                	push   $0x13
  jmp alltraps
801070a6:	e9 6f fa ff ff       	jmp    80106b1a <alltraps>

801070ab <vector20>:
.globl vector20
vector20:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $20
801070ad:	6a 14                	push   $0x14
  jmp alltraps
801070af:	e9 66 fa ff ff       	jmp    80106b1a <alltraps>

801070b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $21
801070b6:	6a 15                	push   $0x15
  jmp alltraps
801070b8:	e9 5d fa ff ff       	jmp    80106b1a <alltraps>

801070bd <vector22>:
.globl vector22
vector22:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $22
801070bf:	6a 16                	push   $0x16
  jmp alltraps
801070c1:	e9 54 fa ff ff       	jmp    80106b1a <alltraps>

801070c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $23
801070c8:	6a 17                	push   $0x17
  jmp alltraps
801070ca:	e9 4b fa ff ff       	jmp    80106b1a <alltraps>

801070cf <vector24>:
.globl vector24
vector24:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $24
801070d1:	6a 18                	push   $0x18
  jmp alltraps
801070d3:	e9 42 fa ff ff       	jmp    80106b1a <alltraps>

801070d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $25
801070da:	6a 19                	push   $0x19
  jmp alltraps
801070dc:	e9 39 fa ff ff       	jmp    80106b1a <alltraps>

801070e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $26
801070e3:	6a 1a                	push   $0x1a
  jmp alltraps
801070e5:	e9 30 fa ff ff       	jmp    80106b1a <alltraps>

801070ea <vector27>:
.globl vector27
vector27:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $27
801070ec:	6a 1b                	push   $0x1b
  jmp alltraps
801070ee:	e9 27 fa ff ff       	jmp    80106b1a <alltraps>

801070f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $28
801070f5:	6a 1c                	push   $0x1c
  jmp alltraps
801070f7:	e9 1e fa ff ff       	jmp    80106b1a <alltraps>

801070fc <vector29>:
.globl vector29
vector29:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $29
801070fe:	6a 1d                	push   $0x1d
  jmp alltraps
80107100:	e9 15 fa ff ff       	jmp    80106b1a <alltraps>

80107105 <vector30>:
.globl vector30
vector30:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $30
80107107:	6a 1e                	push   $0x1e
  jmp alltraps
80107109:	e9 0c fa ff ff       	jmp    80106b1a <alltraps>

8010710e <vector31>:
.globl vector31
vector31:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $31
80107110:	6a 1f                	push   $0x1f
  jmp alltraps
80107112:	e9 03 fa ff ff       	jmp    80106b1a <alltraps>

80107117 <vector32>:
.globl vector32
vector32:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $32
80107119:	6a 20                	push   $0x20
  jmp alltraps
8010711b:	e9 fa f9 ff ff       	jmp    80106b1a <alltraps>

80107120 <vector33>:
.globl vector33
vector33:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $33
80107122:	6a 21                	push   $0x21
  jmp alltraps
80107124:	e9 f1 f9 ff ff       	jmp    80106b1a <alltraps>

80107129 <vector34>:
.globl vector34
vector34:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $34
8010712b:	6a 22                	push   $0x22
  jmp alltraps
8010712d:	e9 e8 f9 ff ff       	jmp    80106b1a <alltraps>

80107132 <vector35>:
.globl vector35
vector35:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $35
80107134:	6a 23                	push   $0x23
  jmp alltraps
80107136:	e9 df f9 ff ff       	jmp    80106b1a <alltraps>

8010713b <vector36>:
.globl vector36
vector36:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $36
8010713d:	6a 24                	push   $0x24
  jmp alltraps
8010713f:	e9 d6 f9 ff ff       	jmp    80106b1a <alltraps>

80107144 <vector37>:
.globl vector37
vector37:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $37
80107146:	6a 25                	push   $0x25
  jmp alltraps
80107148:	e9 cd f9 ff ff       	jmp    80106b1a <alltraps>

8010714d <vector38>:
.globl vector38
vector38:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $38
8010714f:	6a 26                	push   $0x26
  jmp alltraps
80107151:	e9 c4 f9 ff ff       	jmp    80106b1a <alltraps>

80107156 <vector39>:
.globl vector39
vector39:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $39
80107158:	6a 27                	push   $0x27
  jmp alltraps
8010715a:	e9 bb f9 ff ff       	jmp    80106b1a <alltraps>

8010715f <vector40>:
.globl vector40
vector40:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $40
80107161:	6a 28                	push   $0x28
  jmp alltraps
80107163:	e9 b2 f9 ff ff       	jmp    80106b1a <alltraps>

80107168 <vector41>:
.globl vector41
vector41:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $41
8010716a:	6a 29                	push   $0x29
  jmp alltraps
8010716c:	e9 a9 f9 ff ff       	jmp    80106b1a <alltraps>

80107171 <vector42>:
.globl vector42
vector42:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $42
80107173:	6a 2a                	push   $0x2a
  jmp alltraps
80107175:	e9 a0 f9 ff ff       	jmp    80106b1a <alltraps>

8010717a <vector43>:
.globl vector43
vector43:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $43
8010717c:	6a 2b                	push   $0x2b
  jmp alltraps
8010717e:	e9 97 f9 ff ff       	jmp    80106b1a <alltraps>

80107183 <vector44>:
.globl vector44
vector44:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $44
80107185:	6a 2c                	push   $0x2c
  jmp alltraps
80107187:	e9 8e f9 ff ff       	jmp    80106b1a <alltraps>

8010718c <vector45>:
.globl vector45
vector45:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $45
8010718e:	6a 2d                	push   $0x2d
  jmp alltraps
80107190:	e9 85 f9 ff ff       	jmp    80106b1a <alltraps>

80107195 <vector46>:
.globl vector46
vector46:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $46
80107197:	6a 2e                	push   $0x2e
  jmp alltraps
80107199:	e9 7c f9 ff ff       	jmp    80106b1a <alltraps>

8010719e <vector47>:
.globl vector47
vector47:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $47
801071a0:	6a 2f                	push   $0x2f
  jmp alltraps
801071a2:	e9 73 f9 ff ff       	jmp    80106b1a <alltraps>

801071a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $48
801071a9:	6a 30                	push   $0x30
  jmp alltraps
801071ab:	e9 6a f9 ff ff       	jmp    80106b1a <alltraps>

801071b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $49
801071b2:	6a 31                	push   $0x31
  jmp alltraps
801071b4:	e9 61 f9 ff ff       	jmp    80106b1a <alltraps>

801071b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $50
801071bb:	6a 32                	push   $0x32
  jmp alltraps
801071bd:	e9 58 f9 ff ff       	jmp    80106b1a <alltraps>

801071c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $51
801071c4:	6a 33                	push   $0x33
  jmp alltraps
801071c6:	e9 4f f9 ff ff       	jmp    80106b1a <alltraps>

801071cb <vector52>:
.globl vector52
vector52:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $52
801071cd:	6a 34                	push   $0x34
  jmp alltraps
801071cf:	e9 46 f9 ff ff       	jmp    80106b1a <alltraps>

801071d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $53
801071d6:	6a 35                	push   $0x35
  jmp alltraps
801071d8:	e9 3d f9 ff ff       	jmp    80106b1a <alltraps>

801071dd <vector54>:
.globl vector54
vector54:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $54
801071df:	6a 36                	push   $0x36
  jmp alltraps
801071e1:	e9 34 f9 ff ff       	jmp    80106b1a <alltraps>

801071e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $55
801071e8:	6a 37                	push   $0x37
  jmp alltraps
801071ea:	e9 2b f9 ff ff       	jmp    80106b1a <alltraps>

801071ef <vector56>:
.globl vector56
vector56:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $56
801071f1:	6a 38                	push   $0x38
  jmp alltraps
801071f3:	e9 22 f9 ff ff       	jmp    80106b1a <alltraps>

801071f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $57
801071fa:	6a 39                	push   $0x39
  jmp alltraps
801071fc:	e9 19 f9 ff ff       	jmp    80106b1a <alltraps>

80107201 <vector58>:
.globl vector58
vector58:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $58
80107203:	6a 3a                	push   $0x3a
  jmp alltraps
80107205:	e9 10 f9 ff ff       	jmp    80106b1a <alltraps>

8010720a <vector59>:
.globl vector59
vector59:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $59
8010720c:	6a 3b                	push   $0x3b
  jmp alltraps
8010720e:	e9 07 f9 ff ff       	jmp    80106b1a <alltraps>

80107213 <vector60>:
.globl vector60
vector60:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $60
80107215:	6a 3c                	push   $0x3c
  jmp alltraps
80107217:	e9 fe f8 ff ff       	jmp    80106b1a <alltraps>

8010721c <vector61>:
.globl vector61
vector61:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $61
8010721e:	6a 3d                	push   $0x3d
  jmp alltraps
80107220:	e9 f5 f8 ff ff       	jmp    80106b1a <alltraps>

80107225 <vector62>:
.globl vector62
vector62:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $62
80107227:	6a 3e                	push   $0x3e
  jmp alltraps
80107229:	e9 ec f8 ff ff       	jmp    80106b1a <alltraps>

8010722e <vector63>:
.globl vector63
vector63:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $63
80107230:	6a 3f                	push   $0x3f
  jmp alltraps
80107232:	e9 e3 f8 ff ff       	jmp    80106b1a <alltraps>

80107237 <vector64>:
.globl vector64
vector64:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $64
80107239:	6a 40                	push   $0x40
  jmp alltraps
8010723b:	e9 da f8 ff ff       	jmp    80106b1a <alltraps>

80107240 <vector65>:
.globl vector65
vector65:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $65
80107242:	6a 41                	push   $0x41
  jmp alltraps
80107244:	e9 d1 f8 ff ff       	jmp    80106b1a <alltraps>

80107249 <vector66>:
.globl vector66
vector66:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $66
8010724b:	6a 42                	push   $0x42
  jmp alltraps
8010724d:	e9 c8 f8 ff ff       	jmp    80106b1a <alltraps>

80107252 <vector67>:
.globl vector67
vector67:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $67
80107254:	6a 43                	push   $0x43
  jmp alltraps
80107256:	e9 bf f8 ff ff       	jmp    80106b1a <alltraps>

8010725b <vector68>:
.globl vector68
vector68:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $68
8010725d:	6a 44                	push   $0x44
  jmp alltraps
8010725f:	e9 b6 f8 ff ff       	jmp    80106b1a <alltraps>

80107264 <vector69>:
.globl vector69
vector69:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $69
80107266:	6a 45                	push   $0x45
  jmp alltraps
80107268:	e9 ad f8 ff ff       	jmp    80106b1a <alltraps>

8010726d <vector70>:
.globl vector70
vector70:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $70
8010726f:	6a 46                	push   $0x46
  jmp alltraps
80107271:	e9 a4 f8 ff ff       	jmp    80106b1a <alltraps>

80107276 <vector71>:
.globl vector71
vector71:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $71
80107278:	6a 47                	push   $0x47
  jmp alltraps
8010727a:	e9 9b f8 ff ff       	jmp    80106b1a <alltraps>

8010727f <vector72>:
.globl vector72
vector72:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $72
80107281:	6a 48                	push   $0x48
  jmp alltraps
80107283:	e9 92 f8 ff ff       	jmp    80106b1a <alltraps>

80107288 <vector73>:
.globl vector73
vector73:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $73
8010728a:	6a 49                	push   $0x49
  jmp alltraps
8010728c:	e9 89 f8 ff ff       	jmp    80106b1a <alltraps>

80107291 <vector74>:
.globl vector74
vector74:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $74
80107293:	6a 4a                	push   $0x4a
  jmp alltraps
80107295:	e9 80 f8 ff ff       	jmp    80106b1a <alltraps>

8010729a <vector75>:
.globl vector75
vector75:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $75
8010729c:	6a 4b                	push   $0x4b
  jmp alltraps
8010729e:	e9 77 f8 ff ff       	jmp    80106b1a <alltraps>

801072a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $76
801072a5:	6a 4c                	push   $0x4c
  jmp alltraps
801072a7:	e9 6e f8 ff ff       	jmp    80106b1a <alltraps>

801072ac <vector77>:
.globl vector77
vector77:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $77
801072ae:	6a 4d                	push   $0x4d
  jmp alltraps
801072b0:	e9 65 f8 ff ff       	jmp    80106b1a <alltraps>

801072b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $78
801072b7:	6a 4e                	push   $0x4e
  jmp alltraps
801072b9:	e9 5c f8 ff ff       	jmp    80106b1a <alltraps>

801072be <vector79>:
.globl vector79
vector79:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $79
801072c0:	6a 4f                	push   $0x4f
  jmp alltraps
801072c2:	e9 53 f8 ff ff       	jmp    80106b1a <alltraps>

801072c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $80
801072c9:	6a 50                	push   $0x50
  jmp alltraps
801072cb:	e9 4a f8 ff ff       	jmp    80106b1a <alltraps>

801072d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $81
801072d2:	6a 51                	push   $0x51
  jmp alltraps
801072d4:	e9 41 f8 ff ff       	jmp    80106b1a <alltraps>

801072d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $82
801072db:	6a 52                	push   $0x52
  jmp alltraps
801072dd:	e9 38 f8 ff ff       	jmp    80106b1a <alltraps>

801072e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $83
801072e4:	6a 53                	push   $0x53
  jmp alltraps
801072e6:	e9 2f f8 ff ff       	jmp    80106b1a <alltraps>

801072eb <vector84>:
.globl vector84
vector84:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $84
801072ed:	6a 54                	push   $0x54
  jmp alltraps
801072ef:	e9 26 f8 ff ff       	jmp    80106b1a <alltraps>

801072f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $85
801072f6:	6a 55                	push   $0x55
  jmp alltraps
801072f8:	e9 1d f8 ff ff       	jmp    80106b1a <alltraps>

801072fd <vector86>:
.globl vector86
vector86:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $86
801072ff:	6a 56                	push   $0x56
  jmp alltraps
80107301:	e9 14 f8 ff ff       	jmp    80106b1a <alltraps>

80107306 <vector87>:
.globl vector87
vector87:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $87
80107308:	6a 57                	push   $0x57
  jmp alltraps
8010730a:	e9 0b f8 ff ff       	jmp    80106b1a <alltraps>

8010730f <vector88>:
.globl vector88
vector88:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $88
80107311:	6a 58                	push   $0x58
  jmp alltraps
80107313:	e9 02 f8 ff ff       	jmp    80106b1a <alltraps>

80107318 <vector89>:
.globl vector89
vector89:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $89
8010731a:	6a 59                	push   $0x59
  jmp alltraps
8010731c:	e9 f9 f7 ff ff       	jmp    80106b1a <alltraps>

80107321 <vector90>:
.globl vector90
vector90:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $90
80107323:	6a 5a                	push   $0x5a
  jmp alltraps
80107325:	e9 f0 f7 ff ff       	jmp    80106b1a <alltraps>

8010732a <vector91>:
.globl vector91
vector91:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $91
8010732c:	6a 5b                	push   $0x5b
  jmp alltraps
8010732e:	e9 e7 f7 ff ff       	jmp    80106b1a <alltraps>

80107333 <vector92>:
.globl vector92
vector92:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $92
80107335:	6a 5c                	push   $0x5c
  jmp alltraps
80107337:	e9 de f7 ff ff       	jmp    80106b1a <alltraps>

8010733c <vector93>:
.globl vector93
vector93:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $93
8010733e:	6a 5d                	push   $0x5d
  jmp alltraps
80107340:	e9 d5 f7 ff ff       	jmp    80106b1a <alltraps>

80107345 <vector94>:
.globl vector94
vector94:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $94
80107347:	6a 5e                	push   $0x5e
  jmp alltraps
80107349:	e9 cc f7 ff ff       	jmp    80106b1a <alltraps>

8010734e <vector95>:
.globl vector95
vector95:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $95
80107350:	6a 5f                	push   $0x5f
  jmp alltraps
80107352:	e9 c3 f7 ff ff       	jmp    80106b1a <alltraps>

80107357 <vector96>:
.globl vector96
vector96:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $96
80107359:	6a 60                	push   $0x60
  jmp alltraps
8010735b:	e9 ba f7 ff ff       	jmp    80106b1a <alltraps>

80107360 <vector97>:
.globl vector97
vector97:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $97
80107362:	6a 61                	push   $0x61
  jmp alltraps
80107364:	e9 b1 f7 ff ff       	jmp    80106b1a <alltraps>

80107369 <vector98>:
.globl vector98
vector98:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $98
8010736b:	6a 62                	push   $0x62
  jmp alltraps
8010736d:	e9 a8 f7 ff ff       	jmp    80106b1a <alltraps>

80107372 <vector99>:
.globl vector99
vector99:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $99
80107374:	6a 63                	push   $0x63
  jmp alltraps
80107376:	e9 9f f7 ff ff       	jmp    80106b1a <alltraps>

8010737b <vector100>:
.globl vector100
vector100:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $100
8010737d:	6a 64                	push   $0x64
  jmp alltraps
8010737f:	e9 96 f7 ff ff       	jmp    80106b1a <alltraps>

80107384 <vector101>:
.globl vector101
vector101:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $101
80107386:	6a 65                	push   $0x65
  jmp alltraps
80107388:	e9 8d f7 ff ff       	jmp    80106b1a <alltraps>

8010738d <vector102>:
.globl vector102
vector102:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $102
8010738f:	6a 66                	push   $0x66
  jmp alltraps
80107391:	e9 84 f7 ff ff       	jmp    80106b1a <alltraps>

80107396 <vector103>:
.globl vector103
vector103:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $103
80107398:	6a 67                	push   $0x67
  jmp alltraps
8010739a:	e9 7b f7 ff ff       	jmp    80106b1a <alltraps>

8010739f <vector104>:
.globl vector104
vector104:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $104
801073a1:	6a 68                	push   $0x68
  jmp alltraps
801073a3:	e9 72 f7 ff ff       	jmp    80106b1a <alltraps>

801073a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $105
801073aa:	6a 69                	push   $0x69
  jmp alltraps
801073ac:	e9 69 f7 ff ff       	jmp    80106b1a <alltraps>

801073b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $106
801073b3:	6a 6a                	push   $0x6a
  jmp alltraps
801073b5:	e9 60 f7 ff ff       	jmp    80106b1a <alltraps>

801073ba <vector107>:
.globl vector107
vector107:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $107
801073bc:	6a 6b                	push   $0x6b
  jmp alltraps
801073be:	e9 57 f7 ff ff       	jmp    80106b1a <alltraps>

801073c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $108
801073c5:	6a 6c                	push   $0x6c
  jmp alltraps
801073c7:	e9 4e f7 ff ff       	jmp    80106b1a <alltraps>

801073cc <vector109>:
.globl vector109
vector109:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $109
801073ce:	6a 6d                	push   $0x6d
  jmp alltraps
801073d0:	e9 45 f7 ff ff       	jmp    80106b1a <alltraps>

801073d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $110
801073d7:	6a 6e                	push   $0x6e
  jmp alltraps
801073d9:	e9 3c f7 ff ff       	jmp    80106b1a <alltraps>

801073de <vector111>:
.globl vector111
vector111:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $111
801073e0:	6a 6f                	push   $0x6f
  jmp alltraps
801073e2:	e9 33 f7 ff ff       	jmp    80106b1a <alltraps>

801073e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $112
801073e9:	6a 70                	push   $0x70
  jmp alltraps
801073eb:	e9 2a f7 ff ff       	jmp    80106b1a <alltraps>

801073f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $113
801073f2:	6a 71                	push   $0x71
  jmp alltraps
801073f4:	e9 21 f7 ff ff       	jmp    80106b1a <alltraps>

801073f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $114
801073fb:	6a 72                	push   $0x72
  jmp alltraps
801073fd:	e9 18 f7 ff ff       	jmp    80106b1a <alltraps>

80107402 <vector115>:
.globl vector115
vector115:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $115
80107404:	6a 73                	push   $0x73
  jmp alltraps
80107406:	e9 0f f7 ff ff       	jmp    80106b1a <alltraps>

8010740b <vector116>:
.globl vector116
vector116:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $116
8010740d:	6a 74                	push   $0x74
  jmp alltraps
8010740f:	e9 06 f7 ff ff       	jmp    80106b1a <alltraps>

80107414 <vector117>:
.globl vector117
vector117:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $117
80107416:	6a 75                	push   $0x75
  jmp alltraps
80107418:	e9 fd f6 ff ff       	jmp    80106b1a <alltraps>

8010741d <vector118>:
.globl vector118
vector118:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $118
8010741f:	6a 76                	push   $0x76
  jmp alltraps
80107421:	e9 f4 f6 ff ff       	jmp    80106b1a <alltraps>

80107426 <vector119>:
.globl vector119
vector119:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $119
80107428:	6a 77                	push   $0x77
  jmp alltraps
8010742a:	e9 eb f6 ff ff       	jmp    80106b1a <alltraps>

8010742f <vector120>:
.globl vector120
vector120:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $120
80107431:	6a 78                	push   $0x78
  jmp alltraps
80107433:	e9 e2 f6 ff ff       	jmp    80106b1a <alltraps>

80107438 <vector121>:
.globl vector121
vector121:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $121
8010743a:	6a 79                	push   $0x79
  jmp alltraps
8010743c:	e9 d9 f6 ff ff       	jmp    80106b1a <alltraps>

80107441 <vector122>:
.globl vector122
vector122:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $122
80107443:	6a 7a                	push   $0x7a
  jmp alltraps
80107445:	e9 d0 f6 ff ff       	jmp    80106b1a <alltraps>

8010744a <vector123>:
.globl vector123
vector123:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $123
8010744c:	6a 7b                	push   $0x7b
  jmp alltraps
8010744e:	e9 c7 f6 ff ff       	jmp    80106b1a <alltraps>

80107453 <vector124>:
.globl vector124
vector124:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $124
80107455:	6a 7c                	push   $0x7c
  jmp alltraps
80107457:	e9 be f6 ff ff       	jmp    80106b1a <alltraps>

8010745c <vector125>:
.globl vector125
vector125:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $125
8010745e:	6a 7d                	push   $0x7d
  jmp alltraps
80107460:	e9 b5 f6 ff ff       	jmp    80106b1a <alltraps>

80107465 <vector126>:
.globl vector126
vector126:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $126
80107467:	6a 7e                	push   $0x7e
  jmp alltraps
80107469:	e9 ac f6 ff ff       	jmp    80106b1a <alltraps>

8010746e <vector127>:
.globl vector127
vector127:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $127
80107470:	6a 7f                	push   $0x7f
  jmp alltraps
80107472:	e9 a3 f6 ff ff       	jmp    80106b1a <alltraps>

80107477 <vector128>:
.globl vector128
vector128:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $128
80107479:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010747e:	e9 97 f6 ff ff       	jmp    80106b1a <alltraps>

80107483 <vector129>:
.globl vector129
vector129:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $129
80107485:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010748a:	e9 8b f6 ff ff       	jmp    80106b1a <alltraps>

8010748f <vector130>:
.globl vector130
vector130:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $130
80107491:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107496:	e9 7f f6 ff ff       	jmp    80106b1a <alltraps>

8010749b <vector131>:
.globl vector131
vector131:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $131
8010749d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801074a2:	e9 73 f6 ff ff       	jmp    80106b1a <alltraps>

801074a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $132
801074a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801074ae:	e9 67 f6 ff ff       	jmp    80106b1a <alltraps>

801074b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $133
801074b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801074ba:	e9 5b f6 ff ff       	jmp    80106b1a <alltraps>

801074bf <vector134>:
.globl vector134
vector134:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $134
801074c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801074c6:	e9 4f f6 ff ff       	jmp    80106b1a <alltraps>

801074cb <vector135>:
.globl vector135
vector135:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $135
801074cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801074d2:	e9 43 f6 ff ff       	jmp    80106b1a <alltraps>

801074d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $136
801074d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801074de:	e9 37 f6 ff ff       	jmp    80106b1a <alltraps>

801074e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $137
801074e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801074ea:	e9 2b f6 ff ff       	jmp    80106b1a <alltraps>

801074ef <vector138>:
.globl vector138
vector138:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $138
801074f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801074f6:	e9 1f f6 ff ff       	jmp    80106b1a <alltraps>

801074fb <vector139>:
.globl vector139
vector139:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $139
801074fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107502:	e9 13 f6 ff ff       	jmp    80106b1a <alltraps>

80107507 <vector140>:
.globl vector140
vector140:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $140
80107509:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010750e:	e9 07 f6 ff ff       	jmp    80106b1a <alltraps>

80107513 <vector141>:
.globl vector141
vector141:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $141
80107515:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010751a:	e9 fb f5 ff ff       	jmp    80106b1a <alltraps>

8010751f <vector142>:
.globl vector142
vector142:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $142
80107521:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107526:	e9 ef f5 ff ff       	jmp    80106b1a <alltraps>

8010752b <vector143>:
.globl vector143
vector143:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $143
8010752d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107532:	e9 e3 f5 ff ff       	jmp    80106b1a <alltraps>

80107537 <vector144>:
.globl vector144
vector144:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $144
80107539:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010753e:	e9 d7 f5 ff ff       	jmp    80106b1a <alltraps>

80107543 <vector145>:
.globl vector145
vector145:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $145
80107545:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010754a:	e9 cb f5 ff ff       	jmp    80106b1a <alltraps>

8010754f <vector146>:
.globl vector146
vector146:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $146
80107551:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107556:	e9 bf f5 ff ff       	jmp    80106b1a <alltraps>

8010755b <vector147>:
.globl vector147
vector147:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $147
8010755d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107562:	e9 b3 f5 ff ff       	jmp    80106b1a <alltraps>

80107567 <vector148>:
.globl vector148
vector148:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $148
80107569:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010756e:	e9 a7 f5 ff ff       	jmp    80106b1a <alltraps>

80107573 <vector149>:
.globl vector149
vector149:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $149
80107575:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010757a:	e9 9b f5 ff ff       	jmp    80106b1a <alltraps>

8010757f <vector150>:
.globl vector150
vector150:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $150
80107581:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107586:	e9 8f f5 ff ff       	jmp    80106b1a <alltraps>

8010758b <vector151>:
.globl vector151
vector151:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $151
8010758d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107592:	e9 83 f5 ff ff       	jmp    80106b1a <alltraps>

80107597 <vector152>:
.globl vector152
vector152:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $152
80107599:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010759e:	e9 77 f5 ff ff       	jmp    80106b1a <alltraps>

801075a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $153
801075a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801075aa:	e9 6b f5 ff ff       	jmp    80106b1a <alltraps>

801075af <vector154>:
.globl vector154
vector154:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $154
801075b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801075b6:	e9 5f f5 ff ff       	jmp    80106b1a <alltraps>

801075bb <vector155>:
.globl vector155
vector155:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $155
801075bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801075c2:	e9 53 f5 ff ff       	jmp    80106b1a <alltraps>

801075c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $156
801075c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801075ce:	e9 47 f5 ff ff       	jmp    80106b1a <alltraps>

801075d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $157
801075d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801075da:	e9 3b f5 ff ff       	jmp    80106b1a <alltraps>

801075df <vector158>:
.globl vector158
vector158:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $158
801075e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801075e6:	e9 2f f5 ff ff       	jmp    80106b1a <alltraps>

801075eb <vector159>:
.globl vector159
vector159:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $159
801075ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801075f2:	e9 23 f5 ff ff       	jmp    80106b1a <alltraps>

801075f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $160
801075f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801075fe:	e9 17 f5 ff ff       	jmp    80106b1a <alltraps>

80107603 <vector161>:
.globl vector161
vector161:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $161
80107605:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010760a:	e9 0b f5 ff ff       	jmp    80106b1a <alltraps>

8010760f <vector162>:
.globl vector162
vector162:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $162
80107611:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107616:	e9 ff f4 ff ff       	jmp    80106b1a <alltraps>

8010761b <vector163>:
.globl vector163
vector163:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $163
8010761d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107622:	e9 f3 f4 ff ff       	jmp    80106b1a <alltraps>

80107627 <vector164>:
.globl vector164
vector164:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $164
80107629:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010762e:	e9 e7 f4 ff ff       	jmp    80106b1a <alltraps>

80107633 <vector165>:
.globl vector165
vector165:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $165
80107635:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010763a:	e9 db f4 ff ff       	jmp    80106b1a <alltraps>

8010763f <vector166>:
.globl vector166
vector166:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $166
80107641:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107646:	e9 cf f4 ff ff       	jmp    80106b1a <alltraps>

8010764b <vector167>:
.globl vector167
vector167:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $167
8010764d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107652:	e9 c3 f4 ff ff       	jmp    80106b1a <alltraps>

80107657 <vector168>:
.globl vector168
vector168:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $168
80107659:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010765e:	e9 b7 f4 ff ff       	jmp    80106b1a <alltraps>

80107663 <vector169>:
.globl vector169
vector169:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $169
80107665:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010766a:	e9 ab f4 ff ff       	jmp    80106b1a <alltraps>

8010766f <vector170>:
.globl vector170
vector170:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $170
80107671:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107676:	e9 9f f4 ff ff       	jmp    80106b1a <alltraps>

8010767b <vector171>:
.globl vector171
vector171:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $171
8010767d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107682:	e9 93 f4 ff ff       	jmp    80106b1a <alltraps>

80107687 <vector172>:
.globl vector172
vector172:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $172
80107689:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010768e:	e9 87 f4 ff ff       	jmp    80106b1a <alltraps>

80107693 <vector173>:
.globl vector173
vector173:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $173
80107695:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010769a:	e9 7b f4 ff ff       	jmp    80106b1a <alltraps>

8010769f <vector174>:
.globl vector174
vector174:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $174
801076a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801076a6:	e9 6f f4 ff ff       	jmp    80106b1a <alltraps>

801076ab <vector175>:
.globl vector175
vector175:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $175
801076ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801076b2:	e9 63 f4 ff ff       	jmp    80106b1a <alltraps>

801076b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $176
801076b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801076be:	e9 57 f4 ff ff       	jmp    80106b1a <alltraps>

801076c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $177
801076c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801076ca:	e9 4b f4 ff ff       	jmp    80106b1a <alltraps>

801076cf <vector178>:
.globl vector178
vector178:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $178
801076d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801076d6:	e9 3f f4 ff ff       	jmp    80106b1a <alltraps>

801076db <vector179>:
.globl vector179
vector179:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $179
801076dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801076e2:	e9 33 f4 ff ff       	jmp    80106b1a <alltraps>

801076e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $180
801076e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801076ee:	e9 27 f4 ff ff       	jmp    80106b1a <alltraps>

801076f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $181
801076f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801076fa:	e9 1b f4 ff ff       	jmp    80106b1a <alltraps>

801076ff <vector182>:
.globl vector182
vector182:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $182
80107701:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107706:	e9 0f f4 ff ff       	jmp    80106b1a <alltraps>

8010770b <vector183>:
.globl vector183
vector183:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $183
8010770d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107712:	e9 03 f4 ff ff       	jmp    80106b1a <alltraps>

80107717 <vector184>:
.globl vector184
vector184:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $184
80107719:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010771e:	e9 f7 f3 ff ff       	jmp    80106b1a <alltraps>

80107723 <vector185>:
.globl vector185
vector185:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $185
80107725:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010772a:	e9 eb f3 ff ff       	jmp    80106b1a <alltraps>

8010772f <vector186>:
.globl vector186
vector186:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $186
80107731:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107736:	e9 df f3 ff ff       	jmp    80106b1a <alltraps>

8010773b <vector187>:
.globl vector187
vector187:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $187
8010773d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107742:	e9 d3 f3 ff ff       	jmp    80106b1a <alltraps>

80107747 <vector188>:
.globl vector188
vector188:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $188
80107749:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010774e:	e9 c7 f3 ff ff       	jmp    80106b1a <alltraps>

80107753 <vector189>:
.globl vector189
vector189:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $189
80107755:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010775a:	e9 bb f3 ff ff       	jmp    80106b1a <alltraps>

8010775f <vector190>:
.globl vector190
vector190:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $190
80107761:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107766:	e9 af f3 ff ff       	jmp    80106b1a <alltraps>

8010776b <vector191>:
.globl vector191
vector191:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $191
8010776d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107772:	e9 a3 f3 ff ff       	jmp    80106b1a <alltraps>

80107777 <vector192>:
.globl vector192
vector192:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $192
80107779:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010777e:	e9 97 f3 ff ff       	jmp    80106b1a <alltraps>

80107783 <vector193>:
.globl vector193
vector193:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $193
80107785:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010778a:	e9 8b f3 ff ff       	jmp    80106b1a <alltraps>

8010778f <vector194>:
.globl vector194
vector194:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $194
80107791:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107796:	e9 7f f3 ff ff       	jmp    80106b1a <alltraps>

8010779b <vector195>:
.globl vector195
vector195:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $195
8010779d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801077a2:	e9 73 f3 ff ff       	jmp    80106b1a <alltraps>

801077a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $196
801077a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801077ae:	e9 67 f3 ff ff       	jmp    80106b1a <alltraps>

801077b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $197
801077b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801077ba:	e9 5b f3 ff ff       	jmp    80106b1a <alltraps>

801077bf <vector198>:
.globl vector198
vector198:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $198
801077c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801077c6:	e9 4f f3 ff ff       	jmp    80106b1a <alltraps>

801077cb <vector199>:
.globl vector199
vector199:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $199
801077cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801077d2:	e9 43 f3 ff ff       	jmp    80106b1a <alltraps>

801077d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $200
801077d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801077de:	e9 37 f3 ff ff       	jmp    80106b1a <alltraps>

801077e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $201
801077e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801077ea:	e9 2b f3 ff ff       	jmp    80106b1a <alltraps>

801077ef <vector202>:
.globl vector202
vector202:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $202
801077f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801077f6:	e9 1f f3 ff ff       	jmp    80106b1a <alltraps>

801077fb <vector203>:
.globl vector203
vector203:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $203
801077fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107802:	e9 13 f3 ff ff       	jmp    80106b1a <alltraps>

80107807 <vector204>:
.globl vector204
vector204:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $204
80107809:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010780e:	e9 07 f3 ff ff       	jmp    80106b1a <alltraps>

80107813 <vector205>:
.globl vector205
vector205:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $205
80107815:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010781a:	e9 fb f2 ff ff       	jmp    80106b1a <alltraps>

8010781f <vector206>:
.globl vector206
vector206:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $206
80107821:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107826:	e9 ef f2 ff ff       	jmp    80106b1a <alltraps>

8010782b <vector207>:
.globl vector207
vector207:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $207
8010782d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107832:	e9 e3 f2 ff ff       	jmp    80106b1a <alltraps>

80107837 <vector208>:
.globl vector208
vector208:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $208
80107839:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010783e:	e9 d7 f2 ff ff       	jmp    80106b1a <alltraps>

80107843 <vector209>:
.globl vector209
vector209:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $209
80107845:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010784a:	e9 cb f2 ff ff       	jmp    80106b1a <alltraps>

8010784f <vector210>:
.globl vector210
vector210:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $210
80107851:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107856:	e9 bf f2 ff ff       	jmp    80106b1a <alltraps>

8010785b <vector211>:
.globl vector211
vector211:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $211
8010785d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107862:	e9 b3 f2 ff ff       	jmp    80106b1a <alltraps>

80107867 <vector212>:
.globl vector212
vector212:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $212
80107869:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010786e:	e9 a7 f2 ff ff       	jmp    80106b1a <alltraps>

80107873 <vector213>:
.globl vector213
vector213:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $213
80107875:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010787a:	e9 9b f2 ff ff       	jmp    80106b1a <alltraps>

8010787f <vector214>:
.globl vector214
vector214:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $214
80107881:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107886:	e9 8f f2 ff ff       	jmp    80106b1a <alltraps>

8010788b <vector215>:
.globl vector215
vector215:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $215
8010788d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107892:	e9 83 f2 ff ff       	jmp    80106b1a <alltraps>

80107897 <vector216>:
.globl vector216
vector216:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $216
80107899:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010789e:	e9 77 f2 ff ff       	jmp    80106b1a <alltraps>

801078a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $217
801078a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801078aa:	e9 6b f2 ff ff       	jmp    80106b1a <alltraps>

801078af <vector218>:
.globl vector218
vector218:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $218
801078b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801078b6:	e9 5f f2 ff ff       	jmp    80106b1a <alltraps>

801078bb <vector219>:
.globl vector219
vector219:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $219
801078bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801078c2:	e9 53 f2 ff ff       	jmp    80106b1a <alltraps>

801078c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $220
801078c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801078ce:	e9 47 f2 ff ff       	jmp    80106b1a <alltraps>

801078d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $221
801078d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801078da:	e9 3b f2 ff ff       	jmp    80106b1a <alltraps>

801078df <vector222>:
.globl vector222
vector222:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $222
801078e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801078e6:	e9 2f f2 ff ff       	jmp    80106b1a <alltraps>

801078eb <vector223>:
.globl vector223
vector223:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $223
801078ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801078f2:	e9 23 f2 ff ff       	jmp    80106b1a <alltraps>

801078f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $224
801078f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801078fe:	e9 17 f2 ff ff       	jmp    80106b1a <alltraps>

80107903 <vector225>:
.globl vector225
vector225:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $225
80107905:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010790a:	e9 0b f2 ff ff       	jmp    80106b1a <alltraps>

8010790f <vector226>:
.globl vector226
vector226:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $226
80107911:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107916:	e9 ff f1 ff ff       	jmp    80106b1a <alltraps>

8010791b <vector227>:
.globl vector227
vector227:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $227
8010791d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107922:	e9 f3 f1 ff ff       	jmp    80106b1a <alltraps>

80107927 <vector228>:
.globl vector228
vector228:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $228
80107929:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010792e:	e9 e7 f1 ff ff       	jmp    80106b1a <alltraps>

80107933 <vector229>:
.globl vector229
vector229:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $229
80107935:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010793a:	e9 db f1 ff ff       	jmp    80106b1a <alltraps>

8010793f <vector230>:
.globl vector230
vector230:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $230
80107941:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107946:	e9 cf f1 ff ff       	jmp    80106b1a <alltraps>

8010794b <vector231>:
.globl vector231
vector231:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $231
8010794d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107952:	e9 c3 f1 ff ff       	jmp    80106b1a <alltraps>

80107957 <vector232>:
.globl vector232
vector232:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $232
80107959:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010795e:	e9 b7 f1 ff ff       	jmp    80106b1a <alltraps>

80107963 <vector233>:
.globl vector233
vector233:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $233
80107965:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010796a:	e9 ab f1 ff ff       	jmp    80106b1a <alltraps>

8010796f <vector234>:
.globl vector234
vector234:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $234
80107971:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107976:	e9 9f f1 ff ff       	jmp    80106b1a <alltraps>

8010797b <vector235>:
.globl vector235
vector235:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $235
8010797d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107982:	e9 93 f1 ff ff       	jmp    80106b1a <alltraps>

80107987 <vector236>:
.globl vector236
vector236:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $236
80107989:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010798e:	e9 87 f1 ff ff       	jmp    80106b1a <alltraps>

80107993 <vector237>:
.globl vector237
vector237:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $237
80107995:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010799a:	e9 7b f1 ff ff       	jmp    80106b1a <alltraps>

8010799f <vector238>:
.globl vector238
vector238:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $238
801079a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801079a6:	e9 6f f1 ff ff       	jmp    80106b1a <alltraps>

801079ab <vector239>:
.globl vector239
vector239:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $239
801079ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801079b2:	e9 63 f1 ff ff       	jmp    80106b1a <alltraps>

801079b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $240
801079b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801079be:	e9 57 f1 ff ff       	jmp    80106b1a <alltraps>

801079c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $241
801079c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801079ca:	e9 4b f1 ff ff       	jmp    80106b1a <alltraps>

801079cf <vector242>:
.globl vector242
vector242:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $242
801079d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801079d6:	e9 3f f1 ff ff       	jmp    80106b1a <alltraps>

801079db <vector243>:
.globl vector243
vector243:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $243
801079dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801079e2:	e9 33 f1 ff ff       	jmp    80106b1a <alltraps>

801079e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $244
801079e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801079ee:	e9 27 f1 ff ff       	jmp    80106b1a <alltraps>

801079f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $245
801079f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801079fa:	e9 1b f1 ff ff       	jmp    80106b1a <alltraps>

801079ff <vector246>:
.globl vector246
vector246:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $246
80107a01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107a06:	e9 0f f1 ff ff       	jmp    80106b1a <alltraps>

80107a0b <vector247>:
.globl vector247
vector247:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $247
80107a0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107a12:	e9 03 f1 ff ff       	jmp    80106b1a <alltraps>

80107a17 <vector248>:
.globl vector248
vector248:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $248
80107a19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107a1e:	e9 f7 f0 ff ff       	jmp    80106b1a <alltraps>

80107a23 <vector249>:
.globl vector249
vector249:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $249
80107a25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107a2a:	e9 eb f0 ff ff       	jmp    80106b1a <alltraps>

80107a2f <vector250>:
.globl vector250
vector250:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $250
80107a31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107a36:	e9 df f0 ff ff       	jmp    80106b1a <alltraps>

80107a3b <vector251>:
.globl vector251
vector251:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $251
80107a3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107a42:	e9 d3 f0 ff ff       	jmp    80106b1a <alltraps>

80107a47 <vector252>:
.globl vector252
vector252:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $252
80107a49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107a4e:	e9 c7 f0 ff ff       	jmp    80106b1a <alltraps>

80107a53 <vector253>:
.globl vector253
vector253:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $253
80107a55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107a5a:	e9 bb f0 ff ff       	jmp    80106b1a <alltraps>

80107a5f <vector254>:
.globl vector254
vector254:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $254
80107a61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107a66:	e9 af f0 ff ff       	jmp    80106b1a <alltraps>

80107a6b <vector255>:
.globl vector255
vector255:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $255
80107a6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107a72:	e9 a3 f0 ff ff       	jmp    80106b1a <alltraps>
80107a77:	66 90                	xchg   %ax,%ax
80107a79:	66 90                	xchg   %ax,%ax
80107a7b:	66 90                	xchg   %ax,%ax
80107a7d:	66 90                	xchg   %ax,%ax
80107a7f:	90                   	nop

80107a80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	57                   	push   %edi
80107a84:	56                   	push   %esi
80107a85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107a86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107a8c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a92:	83 ec 1c             	sub    $0x1c,%esp
80107a95:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a98:	39 d3                	cmp    %edx,%ebx
80107a9a:	73 49                	jae    80107ae5 <deallocuvm.part.0+0x65>
80107a9c:	89 c7                	mov    %eax,%edi
80107a9e:	eb 0c                	jmp    80107aac <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107aa0:	83 c0 01             	add    $0x1,%eax
80107aa3:	c1 e0 16             	shl    $0x16,%eax
80107aa6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107aa8:	39 da                	cmp    %ebx,%edx
80107aaa:	76 39                	jbe    80107ae5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107aac:	89 d8                	mov    %ebx,%eax
80107aae:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107ab1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107ab4:	f6 c1 01             	test   $0x1,%cl
80107ab7:	74 e7                	je     80107aa0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107ab9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107abb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107ac1:	c1 ee 0a             	shr    $0xa,%esi
80107ac4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107aca:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107ad1:	85 f6                	test   %esi,%esi
80107ad3:	74 cb                	je     80107aa0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107ad5:	8b 06                	mov    (%esi),%eax
80107ad7:	a8 01                	test   $0x1,%al
80107ad9:	75 15                	jne    80107af0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107adb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ae1:	39 da                	cmp    %ebx,%edx
80107ae3:	77 c7                	ja     80107aac <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aeb:	5b                   	pop    %ebx
80107aec:	5e                   	pop    %esi
80107aed:	5f                   	pop    %edi
80107aee:	5d                   	pop    %ebp
80107aef:	c3                   	ret    
      if(pa == 0)
80107af0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107af5:	74 25                	je     80107b1c <deallocuvm.part.0+0x9c>
      kfree(v);
80107af7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107afa:	05 00 00 00 80       	add    $0x80000000,%eax
80107aff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107b02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107b08:	50                   	push   %eax
80107b09:	e8 92 bc ff ff       	call   801037a0 <kfree>
      *pte = 0;
80107b0e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107b14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b17:	83 c4 10             	add    $0x10,%esp
80107b1a:	eb 8c                	jmp    80107aa8 <deallocuvm.part.0+0x28>
        panic("kfree");
80107b1c:	83 ec 0c             	sub    $0xc,%esp
80107b1f:	68 26 87 10 80       	push   $0x80108726
80107b24:	e8 37 89 ff ff       	call   80100460 <panic>
80107b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b30 <mappages>:
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	57                   	push   %edi
80107b34:	56                   	push   %esi
80107b35:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107b36:	89 d3                	mov    %edx,%ebx
80107b38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107b3e:	83 ec 1c             	sub    $0x1c,%esp
80107b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107b44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107b48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107b50:	8b 45 08             	mov    0x8(%ebp),%eax
80107b53:	29 d8                	sub    %ebx,%eax
80107b55:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b58:	eb 3d                	jmp    80107b97 <mappages+0x67>
80107b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107b60:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107b67:	c1 ea 0a             	shr    $0xa,%edx
80107b6a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107b70:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b77:	85 c0                	test   %eax,%eax
80107b79:	74 75                	je     80107bf0 <mappages+0xc0>
    if(*pte & PTE_P)
80107b7b:	f6 00 01             	testb  $0x1,(%eax)
80107b7e:	0f 85 86 00 00 00    	jne    80107c0a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107b84:	0b 75 0c             	or     0xc(%ebp),%esi
80107b87:	83 ce 01             	or     $0x1,%esi
80107b8a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107b8c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80107b8f:	74 6f                	je     80107c00 <mappages+0xd0>
    a += PGSIZE;
80107b91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107b97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107b9a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b9d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107ba0:	89 d8                	mov    %ebx,%eax
80107ba2:	c1 e8 16             	shr    $0x16,%eax
80107ba5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107ba8:	8b 07                	mov    (%edi),%eax
80107baa:	a8 01                	test   $0x1,%al
80107bac:	75 b2                	jne    80107b60 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107bae:	e8 ad bd ff ff       	call   80103960 <kalloc>
80107bb3:	85 c0                	test   %eax,%eax
80107bb5:	74 39                	je     80107bf0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107bb7:	83 ec 04             	sub    $0x4,%esp
80107bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107bbd:	68 00 10 00 00       	push   $0x1000
80107bc2:	6a 00                	push   $0x0
80107bc4:	50                   	push   %eax
80107bc5:	e8 76 dd ff ff       	call   80105940 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107bca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107bcd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107bd0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107bd6:	83 c8 07             	or     $0x7,%eax
80107bd9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107bdb:	89 d8                	mov    %ebx,%eax
80107bdd:	c1 e8 0a             	shr    $0xa,%eax
80107be0:	25 fc 0f 00 00       	and    $0xffc,%eax
80107be5:	01 d0                	add    %edx,%eax
80107be7:	eb 92                	jmp    80107b7b <mappages+0x4b>
80107be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bf8:	5b                   	pop    %ebx
80107bf9:	5e                   	pop    %esi
80107bfa:	5f                   	pop    %edi
80107bfb:	5d                   	pop    %ebp
80107bfc:	c3                   	ret    
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi
80107c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c03:	31 c0                	xor    %eax,%eax
}
80107c05:	5b                   	pop    %ebx
80107c06:	5e                   	pop    %esi
80107c07:	5f                   	pop    %edi
80107c08:	5d                   	pop    %ebp
80107c09:	c3                   	ret    
      panic("remap");
80107c0a:	83 ec 0c             	sub    $0xc,%esp
80107c0d:	68 68 8d 10 80       	push   $0x80108d68
80107c12:	e8 49 88 ff ff       	call   80100460 <panic>
80107c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1e:	66 90                	xchg   %ax,%ax

80107c20 <seginit>:
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107c26:	e8 05 d0 ff ff       	call   80104c30 <cpuid>
  pd[0] = size-1;
80107c2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107c30:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107c36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c3a:	c7 80 b8 33 11 80 ff 	movl   $0xffff,-0x7feecc48(%eax)
80107c41:	ff 00 00 
80107c44:	c7 80 bc 33 11 80 00 	movl   $0xcf9a00,-0x7feecc44(%eax)
80107c4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c4e:	c7 80 c0 33 11 80 ff 	movl   $0xffff,-0x7feecc40(%eax)
80107c55:	ff 00 00 
80107c58:	c7 80 c4 33 11 80 00 	movl   $0xcf9200,-0x7feecc3c(%eax)
80107c5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c62:	c7 80 c8 33 11 80 ff 	movl   $0xffff,-0x7feecc38(%eax)
80107c69:	ff 00 00 
80107c6c:	c7 80 cc 33 11 80 00 	movl   $0xcffa00,-0x7feecc34(%eax)
80107c73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c76:	c7 80 d0 33 11 80 ff 	movl   $0xffff,-0x7feecc30(%eax)
80107c7d:	ff 00 00 
80107c80:	c7 80 d4 33 11 80 00 	movl   $0xcff200,-0x7feecc2c(%eax)
80107c87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107c8a:	05 b0 33 11 80       	add    $0x801133b0,%eax
  pd[1] = (uint)p;
80107c8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107c93:	c1 e8 10             	shr    $0x10,%eax
80107c96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107c9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107c9d:	0f 01 10             	lgdtl  (%eax)
}
80107ca0:	c9                   	leave  
80107ca1:	c3                   	ret    
80107ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107cb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107cb0:	a1 64 60 11 80       	mov    0x80116064,%eax
80107cb5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107cba:	0f 22 d8             	mov    %eax,%cr3
}
80107cbd:	c3                   	ret    
80107cbe:	66 90                	xchg   %ax,%ax

80107cc0 <switchuvm>:
{
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
80107cc6:	83 ec 1c             	sub    $0x1c,%esp
80107cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107ccc:	85 f6                	test   %esi,%esi
80107cce:	0f 84 cb 00 00 00    	je     80107d9f <switchuvm+0xdf>
  if(p->kstack == 0)
80107cd4:	8b 46 08             	mov    0x8(%esi),%eax
80107cd7:	85 c0                	test   %eax,%eax
80107cd9:	0f 84 da 00 00 00    	je     80107db9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107cdf:	8b 46 04             	mov    0x4(%esi),%eax
80107ce2:	85 c0                	test   %eax,%eax
80107ce4:	0f 84 c2 00 00 00    	je     80107dac <switchuvm+0xec>
  pushcli();
80107cea:	e8 41 da ff ff       	call   80105730 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107cef:	e8 dc ce ff ff       	call   80104bd0 <mycpu>
80107cf4:	89 c3                	mov    %eax,%ebx
80107cf6:	e8 d5 ce ff ff       	call   80104bd0 <mycpu>
80107cfb:	89 c7                	mov    %eax,%edi
80107cfd:	e8 ce ce ff ff       	call   80104bd0 <mycpu>
80107d02:	83 c7 08             	add    $0x8,%edi
80107d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d08:	e8 c3 ce ff ff       	call   80104bd0 <mycpu>
80107d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107d10:	ba 67 00 00 00       	mov    $0x67,%edx
80107d15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107d1c:	83 c0 08             	add    $0x8,%eax
80107d1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107d26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d2b:	83 c1 08             	add    $0x8,%ecx
80107d2e:	c1 e8 18             	shr    $0x18,%eax
80107d31:	c1 e9 10             	shr    $0x10,%ecx
80107d34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107d3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107d40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107d45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107d4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107d51:	e8 7a ce ff ff       	call   80104bd0 <mycpu>
80107d56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107d5d:	e8 6e ce ff ff       	call   80104bd0 <mycpu>
80107d62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107d66:	8b 5e 08             	mov    0x8(%esi),%ebx
80107d69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d6f:	e8 5c ce ff ff       	call   80104bd0 <mycpu>
80107d74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107d77:	e8 54 ce ff ff       	call   80104bd0 <mycpu>
80107d7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107d80:	b8 28 00 00 00       	mov    $0x28,%eax
80107d85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107d88:	8b 46 04             	mov    0x4(%esi),%eax
80107d8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d90:	0f 22 d8             	mov    %eax,%cr3
}
80107d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d96:	5b                   	pop    %ebx
80107d97:	5e                   	pop    %esi
80107d98:	5f                   	pop    %edi
80107d99:	5d                   	pop    %ebp
  popcli();
80107d9a:	e9 e1 d9 ff ff       	jmp    80105780 <popcli>
    panic("switchuvm: no process");
80107d9f:	83 ec 0c             	sub    $0xc,%esp
80107da2:	68 6e 8d 10 80       	push   $0x80108d6e
80107da7:	e8 b4 86 ff ff       	call   80100460 <panic>
    panic("switchuvm: no pgdir");
80107dac:	83 ec 0c             	sub    $0xc,%esp
80107daf:	68 99 8d 10 80       	push   $0x80108d99
80107db4:	e8 a7 86 ff ff       	call   80100460 <panic>
    panic("switchuvm: no kstack");
80107db9:	83 ec 0c             	sub    $0xc,%esp
80107dbc:	68 84 8d 10 80       	push   $0x80108d84
80107dc1:	e8 9a 86 ff ff       	call   80100460 <panic>
80107dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dcd:	8d 76 00             	lea    0x0(%esi),%esi

80107dd0 <inituvm>:
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	57                   	push   %edi
80107dd4:	56                   	push   %esi
80107dd5:	53                   	push   %ebx
80107dd6:	83 ec 1c             	sub    $0x1c,%esp
80107dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ddc:	8b 75 10             	mov    0x10(%ebp),%esi
80107ddf:	8b 7d 08             	mov    0x8(%ebp),%edi
80107de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107de5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107deb:	77 4b                	ja     80107e38 <inituvm+0x68>
  mem = kalloc();
80107ded:	e8 6e bb ff ff       	call   80103960 <kalloc>
  memset(mem, 0, PGSIZE);
80107df2:	83 ec 04             	sub    $0x4,%esp
80107df5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107dfa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107dfc:	6a 00                	push   $0x0
80107dfe:	50                   	push   %eax
80107dff:	e8 3c db ff ff       	call   80105940 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107e04:	58                   	pop    %eax
80107e05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e0b:	5a                   	pop    %edx
80107e0c:	6a 06                	push   $0x6
80107e0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e13:	31 d2                	xor    %edx,%edx
80107e15:	50                   	push   %eax
80107e16:	89 f8                	mov    %edi,%eax
80107e18:	e8 13 fd ff ff       	call   80107b30 <mappages>
  memmove(mem, init, sz);
80107e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e20:	89 75 10             	mov    %esi,0x10(%ebp)
80107e23:	83 c4 10             	add    $0x10,%esp
80107e26:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107e29:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e2f:	5b                   	pop    %ebx
80107e30:	5e                   	pop    %esi
80107e31:	5f                   	pop    %edi
80107e32:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107e33:	e9 a8 db ff ff       	jmp    801059e0 <memmove>
    panic("inituvm: more than a page");
80107e38:	83 ec 0c             	sub    $0xc,%esp
80107e3b:	68 ad 8d 10 80       	push   $0x80108dad
80107e40:	e8 1b 86 ff ff       	call   80100460 <panic>
80107e45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e50 <loaduvm>:
{
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	57                   	push   %edi
80107e54:	56                   	push   %esi
80107e55:	53                   	push   %ebx
80107e56:	83 ec 1c             	sub    $0x1c,%esp
80107e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e5c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107e5f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107e64:	0f 85 bb 00 00 00    	jne    80107f25 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107e6a:	01 f0                	add    %esi,%eax
80107e6c:	89 f3                	mov    %esi,%ebx
80107e6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e71:	8b 45 14             	mov    0x14(%ebp),%eax
80107e74:	01 f0                	add    %esi,%eax
80107e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107e79:	85 f6                	test   %esi,%esi
80107e7b:	0f 84 87 00 00 00    	je     80107f08 <loaduvm+0xb8>
80107e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107e8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107e8e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107e90:	89 c2                	mov    %eax,%edx
80107e92:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107e95:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107e98:	f6 c2 01             	test   $0x1,%dl
80107e9b:	75 13                	jne    80107eb0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107e9d:	83 ec 0c             	sub    $0xc,%esp
80107ea0:	68 c7 8d 10 80       	push   $0x80108dc7
80107ea5:	e8 b6 85 ff ff       	call   80100460 <panic>
80107eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107eb0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107eb3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107eb9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107ebe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ec5:	85 c0                	test   %eax,%eax
80107ec7:	74 d4                	je     80107e9d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107ec9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ecb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107ece:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ed3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ed8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107ede:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ee1:	29 d9                	sub    %ebx,%ecx
80107ee3:	05 00 00 00 80       	add    $0x80000000,%eax
80107ee8:	57                   	push   %edi
80107ee9:	51                   	push   %ecx
80107eea:	50                   	push   %eax
80107eeb:	ff 75 10             	push   0x10(%ebp)
80107eee:	e8 7d ae ff ff       	call   80102d70 <readi>
80107ef3:	83 c4 10             	add    $0x10,%esp
80107ef6:	39 f8                	cmp    %edi,%eax
80107ef8:	75 1e                	jne    80107f18 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107efa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107f00:	89 f0                	mov    %esi,%eax
80107f02:	29 d8                	sub    %ebx,%eax
80107f04:	39 c6                	cmp    %eax,%esi
80107f06:	77 80                	ja     80107e88 <loaduvm+0x38>
}
80107f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f0b:	31 c0                	xor    %eax,%eax
}
80107f0d:	5b                   	pop    %ebx
80107f0e:	5e                   	pop    %esi
80107f0f:	5f                   	pop    %edi
80107f10:	5d                   	pop    %ebp
80107f11:	c3                   	ret    
80107f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f20:	5b                   	pop    %ebx
80107f21:	5e                   	pop    %esi
80107f22:	5f                   	pop    %edi
80107f23:	5d                   	pop    %ebp
80107f24:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107f25:	83 ec 0c             	sub    $0xc,%esp
80107f28:	68 68 8e 10 80       	push   $0x80108e68
80107f2d:	e8 2e 85 ff ff       	call   80100460 <panic>
80107f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f40 <allocuvm>:
{
80107f40:	55                   	push   %ebp
80107f41:	89 e5                	mov    %esp,%ebp
80107f43:	57                   	push   %edi
80107f44:	56                   	push   %esi
80107f45:	53                   	push   %ebx
80107f46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107f49:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107f4c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f52:	85 c0                	test   %eax,%eax
80107f54:	0f 88 b6 00 00 00    	js     80108010 <allocuvm+0xd0>
  if(newsz < oldsz)
80107f5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107f60:	0f 82 9a 00 00 00    	jb     80108000 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107f66:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107f6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107f72:	39 75 10             	cmp    %esi,0x10(%ebp)
80107f75:	77 44                	ja     80107fbb <allocuvm+0x7b>
80107f77:	e9 87 00 00 00       	jmp    80108003 <allocuvm+0xc3>
80107f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107f80:	83 ec 04             	sub    $0x4,%esp
80107f83:	68 00 10 00 00       	push   $0x1000
80107f88:	6a 00                	push   $0x0
80107f8a:	50                   	push   %eax
80107f8b:	e8 b0 d9 ff ff       	call   80105940 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107f90:	58                   	pop    %eax
80107f91:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f97:	5a                   	pop    %edx
80107f98:	6a 06                	push   $0x6
80107f9a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f9f:	89 f2                	mov    %esi,%edx
80107fa1:	50                   	push   %eax
80107fa2:	89 f8                	mov    %edi,%eax
80107fa4:	e8 87 fb ff ff       	call   80107b30 <mappages>
80107fa9:	83 c4 10             	add    $0x10,%esp
80107fac:	85 c0                	test   %eax,%eax
80107fae:	78 78                	js     80108028 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107fb0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107fb6:	39 75 10             	cmp    %esi,0x10(%ebp)
80107fb9:	76 48                	jbe    80108003 <allocuvm+0xc3>
    mem = kalloc();
80107fbb:	e8 a0 b9 ff ff       	call   80103960 <kalloc>
80107fc0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107fc2:	85 c0                	test   %eax,%eax
80107fc4:	75 ba                	jne    80107f80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107fc6:	83 ec 0c             	sub    $0xc,%esp
80107fc9:	68 e5 8d 10 80       	push   $0x80108de5
80107fce:	e8 0d 88 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80107fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fd6:	83 c4 10             	add    $0x10,%esp
80107fd9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107fdc:	74 32                	je     80108010 <allocuvm+0xd0>
80107fde:	8b 55 10             	mov    0x10(%ebp),%edx
80107fe1:	89 c1                	mov    %eax,%ecx
80107fe3:	89 f8                	mov    %edi,%eax
80107fe5:	e8 96 fa ff ff       	call   80107a80 <deallocuvm.part.0>
      return 0;
80107fea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ff7:	5b                   	pop    %ebx
80107ff8:	5e                   	pop    %esi
80107ff9:	5f                   	pop    %edi
80107ffa:	5d                   	pop    %ebp
80107ffb:	c3                   	ret    
80107ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108000:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108009:	5b                   	pop    %ebx
8010800a:	5e                   	pop    %esi
8010800b:	5f                   	pop    %edi
8010800c:	5d                   	pop    %ebp
8010800d:	c3                   	ret    
8010800e:	66 90                	xchg   %ax,%ax
    return 0;
80108010:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010801a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010801d:	5b                   	pop    %ebx
8010801e:	5e                   	pop    %esi
8010801f:	5f                   	pop    %edi
80108020:	5d                   	pop    %ebp
80108021:	c3                   	ret    
80108022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108028:	83 ec 0c             	sub    $0xc,%esp
8010802b:	68 fd 8d 10 80       	push   $0x80108dfd
80108030:	e8 ab 87 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80108035:	8b 45 0c             	mov    0xc(%ebp),%eax
80108038:	83 c4 10             	add    $0x10,%esp
8010803b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010803e:	74 0c                	je     8010804c <allocuvm+0x10c>
80108040:	8b 55 10             	mov    0x10(%ebp),%edx
80108043:	89 c1                	mov    %eax,%ecx
80108045:	89 f8                	mov    %edi,%eax
80108047:	e8 34 fa ff ff       	call   80107a80 <deallocuvm.part.0>
      kfree(mem);
8010804c:	83 ec 0c             	sub    $0xc,%esp
8010804f:	53                   	push   %ebx
80108050:	e8 4b b7 ff ff       	call   801037a0 <kfree>
      return 0;
80108055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010805c:	83 c4 10             	add    $0x10,%esp
}
8010805f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108062:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108065:	5b                   	pop    %ebx
80108066:	5e                   	pop    %esi
80108067:	5f                   	pop    %edi
80108068:	5d                   	pop    %ebp
80108069:	c3                   	ret    
8010806a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108070 <deallocuvm>:
{
80108070:	55                   	push   %ebp
80108071:	89 e5                	mov    %esp,%ebp
80108073:	8b 55 0c             	mov    0xc(%ebp),%edx
80108076:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108079:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010807c:	39 d1                	cmp    %edx,%ecx
8010807e:	73 10                	jae    80108090 <deallocuvm+0x20>
}
80108080:	5d                   	pop    %ebp
80108081:	e9 fa f9 ff ff       	jmp    80107a80 <deallocuvm.part.0>
80108086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010808d:	8d 76 00             	lea    0x0(%esi),%esi
80108090:	89 d0                	mov    %edx,%eax
80108092:	5d                   	pop    %ebp
80108093:	c3                   	ret    
80108094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010809b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010809f:	90                   	nop

801080a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801080a0:	55                   	push   %ebp
801080a1:	89 e5                	mov    %esp,%ebp
801080a3:	57                   	push   %edi
801080a4:	56                   	push   %esi
801080a5:	53                   	push   %ebx
801080a6:	83 ec 0c             	sub    $0xc,%esp
801080a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801080ac:	85 f6                	test   %esi,%esi
801080ae:	74 59                	je     80108109 <freevm+0x69>
  if(newsz >= oldsz)
801080b0:	31 c9                	xor    %ecx,%ecx
801080b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801080b7:	89 f0                	mov    %esi,%eax
801080b9:	89 f3                	mov    %esi,%ebx
801080bb:	e8 c0 f9 ff ff       	call   80107a80 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801080c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801080c6:	eb 0f                	jmp    801080d7 <freevm+0x37>
801080c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080cf:	90                   	nop
801080d0:	83 c3 04             	add    $0x4,%ebx
801080d3:	39 df                	cmp    %ebx,%edi
801080d5:	74 23                	je     801080fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801080d7:	8b 03                	mov    (%ebx),%eax
801080d9:	a8 01                	test   $0x1,%al
801080db:	74 f3                	je     801080d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801080e2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801080e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801080ed:	50                   	push   %eax
801080ee:	e8 ad b6 ff ff       	call   801037a0 <kfree>
801080f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801080f6:	39 df                	cmp    %ebx,%edi
801080f8:	75 dd                	jne    801080d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801080fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801080fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108100:	5b                   	pop    %ebx
80108101:	5e                   	pop    %esi
80108102:	5f                   	pop    %edi
80108103:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108104:	e9 97 b6 ff ff       	jmp    801037a0 <kfree>
    panic("freevm: no pgdir");
80108109:	83 ec 0c             	sub    $0xc,%esp
8010810c:	68 19 8e 10 80       	push   $0x80108e19
80108111:	e8 4a 83 ff ff       	call   80100460 <panic>
80108116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010811d:	8d 76 00             	lea    0x0(%esi),%esi

80108120 <setupkvm>:
{
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
80108123:	56                   	push   %esi
80108124:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108125:	e8 36 b8 ff ff       	call   80103960 <kalloc>
8010812a:	89 c6                	mov    %eax,%esi
8010812c:	85 c0                	test   %eax,%eax
8010812e:	74 42                	je     80108172 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108130:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108133:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80108138:	68 00 10 00 00       	push   $0x1000
8010813d:	6a 00                	push   $0x0
8010813f:	50                   	push   %eax
80108140:	e8 fb d7 ff ff       	call   80105940 <memset>
80108145:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108148:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010814b:	83 ec 08             	sub    $0x8,%esp
8010814e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108151:	ff 73 0c             	push   0xc(%ebx)
80108154:	8b 13                	mov    (%ebx),%edx
80108156:	50                   	push   %eax
80108157:	29 c1                	sub    %eax,%ecx
80108159:	89 f0                	mov    %esi,%eax
8010815b:	e8 d0 f9 ff ff       	call   80107b30 <mappages>
80108160:	83 c4 10             	add    $0x10,%esp
80108163:	85 c0                	test   %eax,%eax
80108165:	78 19                	js     80108180 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108167:	83 c3 10             	add    $0x10,%ebx
8010816a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80108170:	75 d6                	jne    80108148 <setupkvm+0x28>
}
80108172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108175:	89 f0                	mov    %esi,%eax
80108177:	5b                   	pop    %ebx
80108178:	5e                   	pop    %esi
80108179:	5d                   	pop    %ebp
8010817a:	c3                   	ret    
8010817b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010817f:	90                   	nop
      freevm(pgdir);
80108180:	83 ec 0c             	sub    $0xc,%esp
80108183:	56                   	push   %esi
      return 0;
80108184:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108186:	e8 15 ff ff ff       	call   801080a0 <freevm>
      return 0;
8010818b:	83 c4 10             	add    $0x10,%esp
}
8010818e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108191:	89 f0                	mov    %esi,%eax
80108193:	5b                   	pop    %ebx
80108194:	5e                   	pop    %esi
80108195:	5d                   	pop    %ebp
80108196:	c3                   	ret    
80108197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010819e:	66 90                	xchg   %ax,%ax

801081a0 <kvmalloc>:
{
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801081a6:	e8 75 ff ff ff       	call   80108120 <setupkvm>
801081ab:	a3 64 60 11 80       	mov    %eax,0x80116064
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801081b0:	05 00 00 00 80       	add    $0x80000000,%eax
801081b5:	0f 22 d8             	mov    %eax,%cr3
}
801081b8:	c9                   	leave  
801081b9:	c3                   	ret    
801081ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801081c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801081c0:	55                   	push   %ebp
801081c1:	89 e5                	mov    %esp,%ebp
801081c3:	83 ec 08             	sub    $0x8,%esp
801081c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801081c9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801081cc:	89 c1                	mov    %eax,%ecx
801081ce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801081d1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801081d4:	f6 c2 01             	test   $0x1,%dl
801081d7:	75 17                	jne    801081f0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801081d9:	83 ec 0c             	sub    $0xc,%esp
801081dc:	68 2a 8e 10 80       	push   $0x80108e2a
801081e1:	e8 7a 82 ff ff       	call   80100460 <panic>
801081e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081ed:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801081f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801081f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801081fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108205:	85 c0                	test   %eax,%eax
80108207:	74 d0                	je     801081d9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108209:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010820c:	c9                   	leave  
8010820d:	c3                   	ret    
8010820e:	66 90                	xchg   %ax,%ax

80108210 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108210:	55                   	push   %ebp
80108211:	89 e5                	mov    %esp,%ebp
80108213:	57                   	push   %edi
80108214:	56                   	push   %esi
80108215:	53                   	push   %ebx
80108216:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108219:	e8 02 ff ff ff       	call   80108120 <setupkvm>
8010821e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108221:	85 c0                	test   %eax,%eax
80108223:	0f 84 bd 00 00 00    	je     801082e6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010822c:	85 c9                	test   %ecx,%ecx
8010822e:	0f 84 b2 00 00 00    	je     801082e6 <copyuvm+0xd6>
80108234:	31 f6                	xor    %esi,%esi
80108236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010823d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108240:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108243:	89 f0                	mov    %esi,%eax
80108245:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108248:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010824b:	a8 01                	test   $0x1,%al
8010824d:	75 11                	jne    80108260 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010824f:	83 ec 0c             	sub    $0xc,%esp
80108252:	68 34 8e 10 80       	push   $0x80108e34
80108257:	e8 04 82 ff ff       	call   80100460 <panic>
8010825c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108260:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108262:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108267:	c1 ea 0a             	shr    $0xa,%edx
8010826a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108270:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108277:	85 c0                	test   %eax,%eax
80108279:	74 d4                	je     8010824f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010827b:	8b 00                	mov    (%eax),%eax
8010827d:	a8 01                	test   $0x1,%al
8010827f:	0f 84 9f 00 00 00    	je     80108324 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108285:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108287:	25 ff 0f 00 00       	and    $0xfff,%eax
8010828c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010828f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108295:	e8 c6 b6 ff ff       	call   80103960 <kalloc>
8010829a:	89 c3                	mov    %eax,%ebx
8010829c:	85 c0                	test   %eax,%eax
8010829e:	74 64                	je     80108304 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801082a0:	83 ec 04             	sub    $0x4,%esp
801082a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801082a9:	68 00 10 00 00       	push   $0x1000
801082ae:	57                   	push   %edi
801082af:	50                   	push   %eax
801082b0:	e8 2b d7 ff ff       	call   801059e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801082b5:	58                   	pop    %eax
801082b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801082bc:	5a                   	pop    %edx
801082bd:	ff 75 e4             	push   -0x1c(%ebp)
801082c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801082c5:	89 f2                	mov    %esi,%edx
801082c7:	50                   	push   %eax
801082c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082cb:	e8 60 f8 ff ff       	call   80107b30 <mappages>
801082d0:	83 c4 10             	add    $0x10,%esp
801082d3:	85 c0                	test   %eax,%eax
801082d5:	78 21                	js     801082f8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801082d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801082dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801082e0:	0f 87 5a ff ff ff    	ja     80108240 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801082e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082ec:	5b                   	pop    %ebx
801082ed:	5e                   	pop    %esi
801082ee:	5f                   	pop    %edi
801082ef:	5d                   	pop    %ebp
801082f0:	c3                   	ret    
801082f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801082f8:	83 ec 0c             	sub    $0xc,%esp
801082fb:	53                   	push   %ebx
801082fc:	e8 9f b4 ff ff       	call   801037a0 <kfree>
      goto bad;
80108301:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108304:	83 ec 0c             	sub    $0xc,%esp
80108307:	ff 75 e0             	push   -0x20(%ebp)
8010830a:	e8 91 fd ff ff       	call   801080a0 <freevm>
  return 0;
8010830f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108316:	83 c4 10             	add    $0x10,%esp
}
80108319:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010831c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010831f:	5b                   	pop    %ebx
80108320:	5e                   	pop    %esi
80108321:	5f                   	pop    %edi
80108322:	5d                   	pop    %ebp
80108323:	c3                   	ret    
      panic("copyuvm: page not present");
80108324:	83 ec 0c             	sub    $0xc,%esp
80108327:	68 4e 8e 10 80       	push   $0x80108e4e
8010832c:	e8 2f 81 ff ff       	call   80100460 <panic>
80108331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010833f:	90                   	nop

80108340 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108340:	55                   	push   %ebp
80108341:	89 e5                	mov    %esp,%ebp
80108343:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108346:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108349:	89 c1                	mov    %eax,%ecx
8010834b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010834e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108351:	f6 c2 01             	test   $0x1,%dl
80108354:	0f 84 00 01 00 00    	je     8010845a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010835a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010835d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108363:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108364:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108369:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108370:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108372:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108377:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010837a:	05 00 00 00 80       	add    $0x80000000,%eax
8010837f:	83 fa 05             	cmp    $0x5,%edx
80108382:	ba 00 00 00 00       	mov    $0x0,%edx
80108387:	0f 45 c2             	cmovne %edx,%eax
}
8010838a:	c3                   	ret    
8010838b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010838f:	90                   	nop

80108390 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	57                   	push   %edi
80108394:	56                   	push   %esi
80108395:	53                   	push   %ebx
80108396:	83 ec 0c             	sub    $0xc,%esp
80108399:	8b 75 14             	mov    0x14(%ebp),%esi
8010839c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010839f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801083a2:	85 f6                	test   %esi,%esi
801083a4:	75 51                	jne    801083f7 <copyout+0x67>
801083a6:	e9 a5 00 00 00       	jmp    80108450 <copyout+0xc0>
801083ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801083af:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801083b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801083b6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801083bc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801083c2:	74 75                	je     80108439 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801083c4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801083c6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801083c9:	29 c3                	sub    %eax,%ebx
801083cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801083d1:	39 f3                	cmp    %esi,%ebx
801083d3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801083d6:	29 f8                	sub    %edi,%eax
801083d8:	83 ec 04             	sub    $0x4,%esp
801083db:	01 c1                	add    %eax,%ecx
801083dd:	53                   	push   %ebx
801083de:	52                   	push   %edx
801083df:	51                   	push   %ecx
801083e0:	e8 fb d5 ff ff       	call   801059e0 <memmove>
    len -= n;
    buf += n;
801083e5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801083e8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801083ee:	83 c4 10             	add    $0x10,%esp
    buf += n;
801083f1:	01 da                	add    %ebx,%edx
  while(len > 0){
801083f3:	29 de                	sub    %ebx,%esi
801083f5:	74 59                	je     80108450 <copyout+0xc0>
  if(*pde & PTE_P){
801083f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801083fa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801083fc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801083fe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108401:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108407:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010840a:	f6 c1 01             	test   $0x1,%cl
8010840d:	0f 84 4e 00 00 00    	je     80108461 <copyout.cold>
  return &pgtab[PTX(va)];
80108413:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108415:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010841b:	c1 eb 0c             	shr    $0xc,%ebx
8010841e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108424:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010842b:	89 d9                	mov    %ebx,%ecx
8010842d:	83 e1 05             	and    $0x5,%ecx
80108430:	83 f9 05             	cmp    $0x5,%ecx
80108433:	0f 84 77 ff ff ff    	je     801083b0 <copyout+0x20>
  }
  return 0;
}
80108439:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010843c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108441:	5b                   	pop    %ebx
80108442:	5e                   	pop    %esi
80108443:	5f                   	pop    %edi
80108444:	5d                   	pop    %ebp
80108445:	c3                   	ret    
80108446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010844d:	8d 76 00             	lea    0x0(%esi),%esi
80108450:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108453:	31 c0                	xor    %eax,%eax
}
80108455:	5b                   	pop    %ebx
80108456:	5e                   	pop    %esi
80108457:	5f                   	pop    %edi
80108458:	5d                   	pop    %ebp
80108459:	c3                   	ret    

8010845a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010845a:	a1 00 00 00 00       	mov    0x0,%eax
8010845f:	0f 0b                	ud2    

80108461 <copyout.cold>:
80108461:	a1 00 00 00 00       	mov    0x0,%eax
80108466:	0f 0b                	ud2    
