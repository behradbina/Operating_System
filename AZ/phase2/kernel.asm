
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 e5 11 80       	mov    $0x8011e570,%esp

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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 89 10 80       	push   $0x801089a0
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 d5 58 00 00       	call   80105930 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
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
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 89 10 80       	push   $0x801089a7
80100097:	50                   	push   %eax
80100098:	e8 63 57 00 00       	call   80105800 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 17 5a 00 00       	call   80105b00 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 39 59 00 00       	call   80105aa0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 56 00 00       	call   80105840 <acquiresleep>
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
801001a1:	68 ae 89 10 80       	push   $0x801089ae
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
801001be:	e8 1d 57 00 00       	call   801058e0 <holdingsleep>
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
801001dc:	68 bf 89 10 80       	push   $0x801089bf
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
801001ff:	e8 dc 56 00 00       	call   801058e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 56 00 00       	call   801058a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 e0 58 00 00       	call   80105b00 <acquire>
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
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 2f 58 00 00       	jmp    80105aa0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 89 10 80       	push   $0x801089c6
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
80100299:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
801002a0:	e8 5b 58 00 00       	call   80105b00 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
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
801002c3:	68 c0 1a 11 80       	push   $0x80111ac0
801002c8:	68 00 0f 11 80       	push   $0x80110f00
801002cd:	e8 5e 50 00 00       	call   80105330 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 49 00 00       	call   80104c60 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 1a 11 80       	push   $0x80111ac0
801002f6:	e8 a5 57 00 00       	call   80105aa0 <release>
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
8010031b:	89 15 00 0f 11 80    	mov    %edx,0x80110f00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 0e 11 80 	movsbl -0x7feef180(%edx),%ecx
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
80100347:	68 c0 1a 11 80       	push   $0x80111ac0
8010034c:	e8 4f 57 00 00       	call   80105aa0 <release>
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
8010036d:	a3 00 0f 11 80       	mov    %eax,0x80110f00
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
80100469:	c7 05 f4 1a 11 80 00 	movl   $0x0,0x80111af4
80100470:	00 00 00 
  getcallerpcs(&s, pcs);
80100473:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100476:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100479:	e8 52 37 00 00       	call   80103bd0 <lapicid>
8010047e:	83 ec 08             	sub    $0x8,%esp
80100481:	50                   	push   %eax
80100482:	68 cd 89 10 80       	push   $0x801089cd
80100487:	e8 54 03 00 00       	call   801007e0 <cprintf>
  cprintf(s);
8010048c:	58                   	pop    %eax
8010048d:	ff 75 08             	push   0x8(%ebp)
80100490:	e8 4b 03 00 00       	call   801007e0 <cprintf>
  cprintf("\n");
80100495:	c7 04 24 ed 8f 10 80 	movl   $0x80108fed,(%esp)
8010049c:	e8 3f 03 00 00       	call   801007e0 <cprintf>
  getcallerpcs(&s, pcs);
801004a1:	8d 45 08             	lea    0x8(%ebp),%eax
801004a4:	5a                   	pop    %edx
801004a5:	59                   	pop    %ecx
801004a6:	53                   	push   %ebx
801004a7:	50                   	push   %eax
801004a8:	e8 a3 54 00 00       	call   80105950 <getcallerpcs>
  for(i=0; i<10; i++)
801004ad:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004b0:	83 ec 08             	sub    $0x8,%esp
801004b3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004b5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004b8:	68 e1 89 10 80       	push   $0x801089e1
801004bd:	e8 1e 03 00 00       	call   801007e0 <cprintf>
  for(i=0; i<10; i++)
801004c2:	83 c4 10             	add    $0x10,%esp
801004c5:	39 f3                	cmp    %esi,%ebx
801004c7:	75 e7                	jne    801004b0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004c9:	c7 05 fc 1a 11 80 01 	movl   $0x1,0x80111afc
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
801004fa:	e8 c1 6f 00 00       	call   801074c0 <uartputc>
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
80100536:	8b 3d f8 1a 11 80    	mov    0x80111af8,%edi
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
8010059a:	8b 3d f8 1a 11 80    	mov    0x80111af8,%edi
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
80100645:	e8 76 6e 00 00       	call   801074c0 <uartputc>
    uartputc(' ');
8010064a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100651:	e8 6a 6e 00 00       	call   801074c0 <uartputc>
    uartputc('\b');
80100656:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010065d:	e8 5e 6e 00 00       	call   801074c0 <uartputc>
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
80100687:	e8 d4 55 00 00       	call   80105c60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010068c:	b8 80 07 00 00       	mov    $0x780,%eax
80100691:	83 c4 0c             	add    $0xc,%esp
80100694:	29 f8                	sub    %edi,%eax
80100696:	01 c0                	add    %eax,%eax
80100698:	50                   	push   %eax
80100699:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801006a0:	6a 00                	push   $0x0
801006a2:	50                   	push   %eax
801006a3:	e8 18 55 00 00       	call   80105bc0 <memset>
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
801006a8:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801006ac:	03 3d f8 1a 11 80    	add    0x80111af8,%edi
801006b2:	83 c4 10             	add    $0x10,%esp
801006b5:	e9 ed fe ff ff       	jmp    801005a7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801006ba:	83 ec 0c             	sub    $0xc,%esp
801006bd:	68 e5 89 10 80       	push   $0x801089e5
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
801006e4:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
801006eb:	e8 10 54 00 00       	call   80105b00 <acquire>
  for(i = 0; i < n; i++)
801006f0:	83 c4 10             	add    $0x10,%esp
801006f3:	85 f6                	test   %esi,%esi
801006f5:	7e 25                	jle    8010071c <consolewrite+0x4c>
801006f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked) {
801006fd:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
8010071f:	68 c0 1a 11 80       	push   $0x80111ac0
80100724:	e8 77 53 00 00       	call   80105aa0 <release>
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
80100776:	0f b6 92 50 8a 10 80 	movzbl -0x7fef75b0(%edx),%edx
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
801007a2:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
801007e9:	a1 f4 1a 11 80       	mov    0x80111af4,%eax
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
801008a0:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
801008e8:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
801008ee:	85 c9                	test   %ecx,%ecx
801008f0:	74 14                	je     80100906 <cprintf+0x126>
801008f2:	fa                   	cli    
    for(;;)
801008f3:	eb fe                	jmp    801008f3 <cprintf+0x113>
801008f5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
801008f8:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
80100923:	68 c0 1a 11 80       	push   $0x80111ac0
80100928:	e8 d3 51 00 00       	call   80105b00 <acquire>
8010092d:	83 c4 10             	add    $0x10,%esp
80100930:	e9 c4 fe ff ff       	jmp    801007f9 <cprintf+0x19>
  if(panicked) {
80100935:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
8010093b:	85 c9                	test   %ecx,%ecx
8010093d:	75 31                	jne    80100970 <cprintf+0x190>
8010093f:	b8 25 00 00 00       	mov    $0x25,%eax
80100944:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100947:	e8 94 fb ff ff       	call   801004e0 <consputc.part.0>
8010094c:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
80100978:	bf f8 89 10 80       	mov    $0x801089f8,%edi
      for(; *s; s++)
8010097d:	b8 28 00 00 00       	mov    $0x28,%eax
80100982:	e9 19 ff ff ff       	jmp    801008a0 <cprintf+0xc0>
80100987:	89 d0                	mov    %edx,%eax
80100989:	e8 52 fb ff ff       	call   801004e0 <consputc.part.0>
8010098e:	e9 c8 fe ff ff       	jmp    8010085b <cprintf+0x7b>
    release(&cons.lock);
80100993:	83 ec 0c             	sub    $0xc,%esp
80100996:	68 c0 1a 11 80       	push   $0x80111ac0
8010099b:	e8 00 51 00 00       	call   80105aa0 <release>
801009a0:	83 c4 10             	add    $0x10,%esp
}
801009a3:	e9 c9 fe ff ff       	jmp    80100871 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801009a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801009ab:	e9 ab fe ff ff       	jmp    8010085b <cprintf+0x7b>
    panic("null fmt");
801009b0:	83 ec 0c             	sub    $0xc,%esp
801009b3:	68 ff 89 10 80       	push   $0x801089ff
801009b8:	e8 a3 fa ff ff       	call   80100460 <panic>
801009bd:	8d 76 00             	lea    0x0(%esi),%esi

801009c0 <shift_forward_crt>:
{
801009c0:	55                   	push   %ebp
  for (int i = pos + cap; i > pos; i--)
801009c1:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
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
801009f1:	8b 0d f8 1a 11 80    	mov    0x80111af8,%ecx
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
80100ab1:	80 3d 80 0e 11 80 00 	cmpb   $0x0,0x80110e80
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
80100ad5:	80 be 80 0e 11 80 00 	cmpb   $0x0,-0x7feef180(%esi)
80100adc:	75 f2                	jne    80100ad0 <getLastCommand+0x20>
    if (input.buf[k] == '\n')
80100ade:	80 b8 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%eax)
80100ae5:	74 17                	je     80100afe <getLastCommand+0x4e>
80100ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aee:	66 90                	xchg   %ax,%ax
  for (k = i-1; (k != -1); k--)
80100af0:	83 e8 01             	sub    $0x1,%eax
80100af3:	72 17                	jb     80100b0c <getLastCommand+0x5c>
    if (input.buf[k] == '\n')
80100af5:	80 b8 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%eax)
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
80100b20:	0f b6 8a 80 0e 11 80 	movzbl -0x7feef180(%edx),%ecx
80100b27:	88 8c 13 3f 1a 11 80 	mov    %cl,-0x7feee5c1(%ebx,%edx,1)
  for (h = k+1; h < i; h++)
80100b2e:	83 c2 01             	add    $0x1,%edx
80100b31:	39 f2                	cmp    %esi,%edx
80100b33:	75 eb                	jne    80100b20 <getLastCommand+0x70>
  result[h-k-1] = '\0';
80100b35:	29 c2                	sub    %eax,%edx
}
80100b37:	5b                   	pop    %ebx
80100b38:	b8 40 1a 11 80       	mov    $0x80111a40,%eax
80100b3d:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100b3e:	83 ea 01             	sub    $0x1,%edx
}
80100b41:	5d                   	pop    %ebp
  result[h-k-1] = '\0';
80100b42:	c6 82 40 1a 11 80 00 	movb   $0x0,-0x7feee5c0(%edx)
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
80100b5b:	b8 40 1a 11 80       	mov    $0x80111a40,%eax
80100b60:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100b61:	c6 82 40 1a 11 80 00 	movb   $0x0,-0x7feee5c0(%edx)
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
80100b85:	80 b8 40 15 11 80 00 	cmpb   $0x0,-0x7feeeac0(%eax)
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
80100ba8:	0f b6 91 40 15 11 80 	movzbl -0x7feeeac0(%ecx),%edx
80100baf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80100bb2:	31 c0                	xor    %eax,%eax
80100bb4:	83 ee 01             	sub    $0x1,%esi
80100bb7:	84 d2                	test   %dl,%dl
80100bb9:	74 1b                	je     80100bd6 <addNewCommandToHistory+0x66>
80100bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bbf:	90                   	nop
      historyBuf[i][j] = historyBuf[i-1][j];
80100bc0:	88 94 03 40 15 11 80 	mov    %dl,-0x7feeeac0(%ebx,%eax,1)
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100bc7:	83 c0 01             	add    $0x1,%eax
80100bca:	0f b6 94 01 40 15 11 	movzbl -0x7feeeac0(%ecx,%eax,1),%edx
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
80100be1:	c6 84 10 40 15 11 80 	movb   $0x0,-0x7feeeac0(%eax,%edx,1)
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
80100c20:	88 8a 40 15 11 80    	mov    %cl,-0x7feeeac0(%edx)
  for (i = 0; res[i] != '\0'; i++)
80100c26:	83 c2 01             	add    $0x1,%edx
80100c29:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100c2d:	84 c9                	test   %cl,%cl
80100c2f:	75 ef                	jne    80100c20 <addNewCommandToHistory+0xb0>
  if (historyCurrentSize <= HISTORYSIZE)
80100c31:	a1 24 15 11 80       	mov    0x80111524,%eax
  historyBuf[0][i] = '\0';
80100c36:	c6 82 40 15 11 80 00 	movb   $0x0,-0x7feeeac0(%edx)
  if (historyCurrentSize <= HISTORYSIZE)
80100c3d:	83 f8 0a             	cmp    $0xa,%eax
80100c40:	7f 08                	jg     80100c4a <addNewCommandToHistory+0xda>
    historyCurrentSize = historyCurrentSize + 1;
80100c42:	83 c0 01             	add    $0x1,%eax
80100c45:	a3 24 15 11 80       	mov    %eax,0x80111524
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
80100c78:	c6 82 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%edx)
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
80100c98:	88 8a 80 0e 11 80    	mov    %cl,-0x7feef180(%edx)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100c9e:	83 c2 01             	add    $0x1,%edx
80100ca1:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100ca5:	89 d3                	mov    %edx,%ebx
80100ca7:	84 c9                	test   %cl,%cl
80100ca9:	75 ed                	jne    80100c98 <makeBufferEmpty+0x38>
  input.e = i;
80100cab:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
}
80100cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cb4:	c9                   	leave  
80100cb5:	c3                   	ret    
  for (i = 0; lastCommand[i] != '\0'; i++)
80100cb6:	31 db                	xor    %ebx,%ebx
  input.e = i;
80100cb8:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
}
80100cbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cc1:	c9                   	leave  
80100cc2:	c3                   	ret    
80100cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100cd0 <checkBufferNeedEmpty>:
  for (int i = 0; input.buf[i] != '\0'; i++)
80100cd0:	31 c0                	xor    %eax,%eax
80100cd2:	80 3d 80 0e 11 80 00 	cmpb   $0x0,0x80110e80
80100cd9:	75 0a                	jne    80100ce5 <checkBufferNeedEmpty+0x15>
80100cdb:	eb 1a                	jmp    80100cf7 <checkBufferNeedEmpty+0x27>
80100cdd:	8d 76 00             	lea    0x0(%esi),%esi
    if (i > INPUT_BUF-3)
80100ce0:	83 f8 7e             	cmp    $0x7e,%eax
80100ce3:	74 0d                	je     80100cf2 <checkBufferNeedEmpty+0x22>
  for (int i = 0; input.buf[i] != '\0'; i++)
80100ce5:	83 c0 01             	add    $0x1,%eax
80100ce8:	80 b8 80 0e 11 80 00 	cmpb   $0x0,-0x7feef180(%eax)
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
80100d03:	80 3d 80 0e 11 80 00 	cmpb   $0x0,0x80110e80
{
80100d0a:	89 e5                	mov    %esp,%ebp
80100d0c:	53                   	push   %ebx
80100d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100d10:	74 76                	je     80100d88 <putLastCommandBuf+0x88>
80100d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d18:	89 c2                	mov    %eax,%edx
80100d1a:	83 c0 01             	add    $0x1,%eax
80100d1d:	80 b8 80 0e 11 80 00 	cmpb   $0x0,-0x7feef180(%eax)
80100d24:	75 f2                	jne    80100d18 <putLastCommandBuf+0x18>
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
80100d26:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100d2d:	75 0e                	jne    80100d3d <putLastCommandBuf+0x3d>
80100d2f:	eb 1a                	jmp    80100d4b <putLastCommandBuf+0x4b>
80100d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d38:	83 fa ff             	cmp    $0xffffffff,%edx
80100d3b:	74 43                	je     80100d80 <putLastCommandBuf+0x80>
80100d3d:	89 d0                	mov    %edx,%eax
80100d3f:	83 ea 01             	sub    $0x1,%edx
80100d42:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100d49:	75 ed                	jne    80100d38 <putLastCommandBuf+0x38>
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100d4b:	0f b6 0b             	movzbl (%ebx),%ecx
80100d4e:	84 c9                	test   %cl,%cl
80100d50:	74 18                	je     80100d6a <putLastCommandBuf+0x6a>
80100d52:	29 d3                	sub    %edx,%ebx
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    input.buf[h] = changedCommand[h-k-1];
80100d58:	88 88 80 0e 11 80    	mov    %cl,-0x7feef180(%eax)
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100d5e:	83 c0 01             	add    $0x1,%eax
80100d61:	0f b6 4c 03 ff       	movzbl -0x1(%ebx,%eax,1),%ecx
80100d66:	84 c9                	test   %cl,%cl
80100d68:	75 ee                	jne    80100d58 <putLastCommandBuf+0x58>
  input.buf[h] = '\0';
80100d6a:	c6 80 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%eax)
}
80100d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  input.e = h;
80100d74:	a3 08 0f 11 80       	mov    %eax,0x80110f08
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
80100dc6:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
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
80100df1:	c7 05 f8 1a 11 80 00 	movl   $0x0,0x80111af8
80100df8:	00 00 00 
  char* res = getLastCommand(0);
80100dfb:	e8 b0 fc ff ff       	call   80100ab0 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100e00:	83 c4 10             	add    $0x10,%esp
80100e03:	80 38 00             	cmpb   $0x0,(%eax)
80100e06:	74 2b                	je     80100e33 <clearTheInputLine+0xa3>
80100e08:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100e0b:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
80100e47:	83 2d 20 15 11 80 01 	subl   $0x1,0x80111520
  clearTheInputLine();
80100e4e:	e8 3d ff ff ff       	call   80100d90 <clearTheInputLine>
  if (upDownKeyIndex == 0)
80100e53:	a1 20 15 11 80       	mov    0x80111520,%eax
80100e58:	85 c0                	test   %eax,%eax
80100e5a:	75 4c                	jne    80100ea8 <showNewCommand+0x68>
    putLastCommandBuf(tempBuf);
80100e5c:	83 ec 0c             	sub    $0xc,%esp
80100e5f:	68 a0 14 11 80       	push   $0x801114a0
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
80100e83:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
80100eae:	05 c0 14 11 80       	add    $0x801114c0,%eax
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
80100ec7:	8b 1d 20 15 11 80    	mov    0x80111520,%ebx
80100ecd:	85 db                	test   %ebx,%ebx
80100ecf:	74 67                	je     80100f38 <showPastCommand+0x78>
  upDownKeyIndex++;
80100ed1:	83 c3 01             	add    $0x1,%ebx
80100ed4:	89 1d 20 15 11 80    	mov    %ebx,0x80111520
  clearTheInputLine();
80100eda:	e8 b1 fe ff ff       	call   80100d90 <clearTheInputLine>
  putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100edf:	a1 20 15 11 80       	mov    0x80111520,%eax
80100ee4:	83 ec 0c             	sub    $0xc,%esp
80100ee7:	c1 e0 07             	shl    $0x7,%eax
80100eea:	05 c0 14 11 80       	add    $0x801114c0,%eax
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
80100f0e:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
80100f50:	88 93 a0 14 11 80    	mov    %dl,-0x7feeeb60(%ebx)
    for (i = 0; res[i] != '\0'; i++)
80100f56:	83 c3 01             	add    $0x1,%ebx
80100f59:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
80100f5d:	84 d2                	test   %dl,%dl
80100f5f:	75 ef                	jne    80100f50 <showPastCommand+0x90>
    tempBuf[i] = '\0';
80100f61:	c6 83 a0 14 11 80 00 	movb   $0x0,-0x7feeeb60(%ebx)
  upDownKeyIndex++;
80100f68:	8b 1d 20 15 11 80    	mov    0x80111520,%ebx
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
80101014:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
80101040:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
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
801010a7:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
801010c7:	8b 1d fc 1a 11 80    	mov    0x80111afc,%ebx
801010cd:	85 db                	test   %ebx,%ebx
801010cf:	75 57                	jne    80101128 <doHistoryCommand+0xe8>
801010d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801010d6:	e8 05 f4 ff ff       	call   801004e0 <consputc.part.0>
  for (i = 0; i < HISTORYSIZE && historyBuf[i][0] != '\0' ; i++)
801010db:	89 d8                	mov    %ebx,%eax
801010dd:	c1 e0 07             	shl    $0x7,%eax
801010e0:	80 b8 40 15 11 80 00 	cmpb   $0x0,-0x7feeeac0(%eax)
801010e7:	0f 84 8b 00 00 00    	je     80101178 <doHistoryCommand+0x138>
801010ed:	83 c3 01             	add    $0x1,%ebx
801010f0:	83 fb 0a             	cmp    $0xa,%ebx
801010f3:	75 e6                	jne    801010db <doHistoryCommand+0x9b>
  i--;
801010f5:	be 09 00 00 00       	mov    $0x9,%esi
801010fa:	89 f3                	mov    %esi,%ebx
801010fc:	c1 e3 07             	shl    $0x7,%ebx
801010ff:	81 c3 40 15 11 80    	add    $0x80111540,%ebx
    printint(i+1,10 ,1);
80101105:	8d 46 01             	lea    0x1(%esi),%eax
80101108:	b9 01 00 00 00       	mov    $0x1,%ecx
8010110d:	ba 0a 00 00 00       	mov    $0xa,%edx
80101112:	e8 29 f6 ff ff       	call   80100740 <printint>
  if(panicked) {
80101117:	8b 3d fc 1a 11 80    	mov    0x80111afc,%edi
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
80101144:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
80101167:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
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
80101236:	68 08 8a 10 80       	push   $0x80108a08
8010123b:	68 c0 1a 11 80       	push   $0x80111ac0
80101240:	e8 eb 46 00 00       	call   80105930 <initlock>
  ioapicenable(IRQ_KBD, 0);
80101245:	58                   	pop    %eax
80101246:	5a                   	pop    %edx
80101247:	6a 00                	push   $0x0
80101249:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010124b:	c7 05 ac 24 11 80 d0 	movl   $0x801006d0,0x801124ac
80101252:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101255:	c7 05 a8 24 11 80 80 	movl   $0x80100280,0x801124a8
8010125c:	02 10 80 
  cons.locking = 1;
8010125f:	c7 05 f4 1a 11 80 01 	movl   $0x1,0x80111af4
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
80101380:	0f b6 94 01 80 0e 11 	movzbl -0x7feef180(%ecx,%eax,1),%edx
80101387:	80 
    k++;
80101388:	83 c0 01             	add    $0x1,%eax
    clipboard[k] = input.buf[i];
8010138b:	88 90 1f 14 11 80    	mov    %dl,-0x7feeebe1(%eax)
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
8010139b:	c6 86 20 14 11 80 00 	movb   $0x0,-0x7feeebe0(%esi)
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
801013ab:	c6 86 20 14 11 80 00 	movb   $0x0,-0x7feeebe0(%esi)
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
801013ce:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801013d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    int startPos = -1;
    char operator = '\0';
    int num1 = 0, num2 = 0;

    // Find the operator in the pattern NON=?
    while (i >= 0 && input.buf[i] != '\n') {
801013d6:	83 e8 02             	sub    $0x2,%eax
801013d9:	0f 88 fd 01 00 00    	js     801015dc <extractAndCompute+0x21c>
801013df:	90                   	nop
801013e0:	0f b6 90 80 0e 11 80 	movzbl -0x7feef180(%eax),%edx
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
80101432:	80 ba 80 0e 11 80 30 	cmpb   $0x30,-0x7feef180(%edx)
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
80101456:	0f be be 80 0e 11 80 	movsbl -0x7feef180(%esi),%edi
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
801014d0:	80 b8 80 0e 11 80 30 	cmpb   $0x30,-0x7feef180(%eax)
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
801014ec:	0f be 93 80 0e 11 80 	movsbl -0x7feef180(%ebx),%edx
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
80101588:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
801015c4:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801015c9:	89 c2                	mov    %eax,%edx
        input.e++;
801015cb:	83 c0 01             	add    $0x1,%eax
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
801015ce:	83 e2 7f             	and    $0x7f,%edx
        input.e++;
801015d1:	a3 08 0f 11 80       	mov    %eax,0x80110f08
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
801015d6:	88 9a 80 0e 11 80    	mov    %bl,-0x7feef180(%edx)
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
80101639:	88 82 80 0e 11 80    	mov    %al,-0x7feef180(%edx)
  if(panicked) {
8010163f:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
80101685:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
    for (int i = input.e; i < INPUT_BUF; i++)
8010168b:	83 fb 7f             	cmp    $0x7f,%ebx
8010168e:	7f 12                	jg     801016a2 <extractAndCompute+0x2e2>
      input.buf[i] = '\0';
80101690:	c6 83 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%ebx)
    for (int i = input.e; i < INPUT_BUF; i++)
80101697:	83 c3 01             	add    $0x1,%ebx
8010169a:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801016a0:	75 ee                	jne    80101690 <extractAndCompute+0x2d0>
    if (reminder != 0) {
801016a2:	8b 4d bc             	mov    -0x44(%ebp),%ecx
801016a5:	85 c9                	test   %ecx,%ecx
801016a7:	0f 84 2f ff ff ff    	je     801015dc <extractAndCompute+0x21c>
  if(panicked) {
801016ad:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
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
801016f4:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801016f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
801016fe:	89 c2                	mov    %eax,%edx
        input.e++;
80101700:	83 c0 01             	add    $0x1,%eax
80101703:	a3 08 0f 11 80       	mov    %eax,0x80110f08
        input.buf[input.e % INPUT_BUF] = '.';
80101708:	83 e2 7f             	and    $0x7f,%edx
8010170b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010170e:	c6 82 80 0e 11 80 2e 	movb   $0x2e,-0x7feef180(%edx)
    if (num == 0) {
80101715:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80101718:	e8 63 ec ff ff       	call   80100380 <itoa.part.0>
  if(panicked) {
8010171d:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
8010174c:	68 c0 1a 11 80       	push   $0x80111ac0
80101751:	e8 aa 43 00 00       	call   80105b00 <acquire>
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
80101783:	ff 24 85 10 8a 10 80 	jmp    *-0x7fef75f0(,%eax,4)
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
801017ff:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
80101804:	85 c0                	test   %eax,%eax
80101806:	7e 0b                	jle    80101813 <consoleintr+0xd3>
    cap--;
80101808:	83 e8 01             	sub    $0x1,%eax
    pos++;
8010180b:	83 c1 01             	add    $0x1,%ecx
    cap--;
8010180e:	a3 f8 1a 11 80       	mov    %eax,0x80111af8
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
80101853:	68 c0 1a 11 80       	push   $0x80111ac0
80101858:	e8 43 42 00 00       	call   80105aa0 <release>
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
80101889:	a1 24 15 11 80       	mov    0x80111524,%eax
8010188e:	39 05 20 15 11 80    	cmp    %eax,0x80111520
80101894:	0f 8d c6 fe ff ff    	jge    80101760 <consoleintr+0x20>
        showPastCommand();
8010189a:	e8 21 f6 ff ff       	call   80100ec0 <showPastCommand>
8010189f:	e9 bc fe ff ff       	jmp    80101760 <consoleintr+0x20>
801018a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801018a8:	85 db                	test   %ebx,%ebx
801018aa:	0f 84 b0 fe ff ff    	je     80101760 <consoleintr+0x20>
801018b0:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801018b5:	89 c2                	mov    %eax,%edx
801018b7:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
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
801018db:	8b 35 f8 1a 11 80    	mov    0x80111af8,%esi
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
80101905:	0f b6 99 80 0e 11 80 	movzbl -0x7feef180(%ecx),%ebx
8010190c:	89 c1                	mov    %eax,%ecx
8010190e:	c1 f9 1f             	sar    $0x1f,%ecx
80101911:	c1 e9 19             	shr    $0x19,%ecx
80101914:	01 c8                	add    %ecx,%eax
80101916:	83 e0 7f             	and    $0x7f,%eax
80101919:	29 c8                	sub    %ecx,%eax
8010191b:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101921:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101926:	89 c1                	mov    %eax,%ecx
80101928:	29 f1                	sub    %esi,%ecx
8010192a:	39 d1                	cmp    %edx,%ecx
8010192c:	72 c2                	jb     801018f0 <consoleintr+0x1b0>
8010192e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101931:	83 c0 01             	add    $0x1,%eax
  if(panicked) {
80101934:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
8010193a:	83 e1 7f             	and    $0x7f,%ecx
8010193d:	a3 08 0f 11 80       	mov    %eax,0x80110f08
80101942:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80101946:	88 81 80 0e 11 80    	mov    %al,-0x7feef180(%ecx)
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
80101970:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101975:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
8010197b:	0f 84 df fd ff ff    	je     80101760 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80101981:	83 e8 01             	sub    $0x1,%eax
80101984:	89 c2                	mov    %eax,%edx
80101986:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80101989:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80101990:	0f 84 ca fd ff ff    	je     80101760 <consoleintr+0x20>
        input.e--;
80101996:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked) {
8010199b:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
801019a0:	85 c0                	test   %eax,%eax
801019a2:	0f 84 28 02 00 00    	je     80101bd0 <consoleintr+0x490>
801019a8:	fa                   	cli    
    for(;;)
801019a9:	eb fe                	jmp    801019a9 <consoleintr+0x269>
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop
        if(input.e != input.w && input.e - input.w > cap) {
801019b0:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801019b5:	8b 15 04 0f 11 80    	mov    0x80110f04,%edx
801019bb:	39 d0                	cmp    %edx,%eax
801019bd:	0f 84 9d fd ff ff    	je     80101760 <consoleintr+0x20>
801019c3:	89 c3                	mov    %eax,%ebx
801019c5:	8b 0d f8 1a 11 80    	mov    0x80111af8,%ecx
801019cb:	29 d3                	sub    %edx,%ebx
801019cd:	39 cb                	cmp    %ecx,%ebx
801019cf:	0f 86 8b fd ff ff    	jbe    80101760 <consoleintr+0x20>
          if (cap > 0)
801019d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801019d8:	85 c9                	test   %ecx,%ecx
801019da:	0f 8f db 02 00 00    	jg     80101cbb <consoleintr+0x57b>
  if(panicked) {
801019e0:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
          input.e--;
801019e5:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
  if(panicked) {
801019eb:	85 c0                	test   %eax,%eax
801019ed:	0f 84 68 02 00 00    	je     80101c5b <consoleintr+0x51b>
801019f3:	fa                   	cli    
    for(;;)
801019f4:	eb fe                	jmp    801019f4 <consoleintr+0x2b4>
801019f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019fd:	8d 76 00             	lea    0x0(%esi),%esi
      if(saveStatus)
80101a00:	8b 35 18 14 11 80    	mov    0x80111418,%esi
80101a06:	85 f6                	test   %esi,%esi
80101a08:	0f 84 52 fd ff ff    	je     80101760 <consoleintr+0x20>
        end_copy = input.e;
80101a0e:	a1 08 0f 11 80       	mov    0x80110f08,%eax
        paste(start_copy, end_copy);
80101a13:	8b 1d 10 14 11 80    	mov    0x80111410,%ebx
        end_copy = input.e;
80101a19:	a3 0c 14 11 80       	mov    %eax,0x8011140c
  for (int i = start; i <= end; i++)
80101a1e:	39 d8                	cmp    %ebx,%eax
80101a20:	0f 8c 8e 02 00 00    	jl     80101cb4 <consoleintr+0x574>
80101a26:	8d 70 01             	lea    0x1(%eax),%esi
  int k = 0;
80101a29:	31 d2                	xor    %edx,%edx
80101a2b:	29 de                	sub    %ebx,%esi
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    clipboard[k] = input.buf[i];
80101a30:	0f b6 8c 13 80 0e 11 	movzbl -0x7feef180(%ebx,%edx,1),%ecx
80101a37:	80 
    k++;
80101a38:	83 c2 01             	add    $0x1,%edx
    clipboard[k] = input.buf[i];
80101a3b:	88 8a 1f 14 11 80    	mov    %cl,-0x7feeebe1(%edx)
  for (int i = start; i <= end; i++)
80101a41:	39 f2                	cmp    %esi,%edx
80101a43:	75 eb                	jne    80101a30 <consoleintr+0x2f0>
    k++;
80101a45:	89 c2                	mov    %eax,%edx
80101a47:	29 da                	sub    %ebx,%edx
80101a49:	83 c2 01             	add    $0x1,%edx
  clipboard[k] = '\0';
80101a4c:	c6 82 20 14 11 80 00 	movb   $0x0,-0x7feeebe0(%edx)
        while(clipboard[i] != '\0')
80101a53:	0f b6 15 20 14 11 80 	movzbl 0x80111420,%edx
80101a5a:	88 55 e0             	mov    %dl,-0x20(%ebp)
80101a5d:	84 d2                	test   %dl,%dl
80101a5f:	0f 84 1a 03 00 00    	je     80101d7f <consoleintr+0x63f>
        int i = 0;
80101a65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  for (int i = input.e; i > input.e - cap; i--)
80101a6c:	8b 35 f8 1a 11 80    	mov    0x80111af8,%esi
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
80101a95:	0f b6 99 80 0e 11 80 	movzbl -0x7feef180(%ecx),%ebx
80101a9c:	89 c1                	mov    %eax,%ecx
80101a9e:	c1 f9 1f             	sar    $0x1f,%ecx
80101aa1:	c1 e9 19             	shr    $0x19,%ecx
80101aa4:	01 c8                	add    %ecx,%eax
80101aa6:	83 e0 7f             	and    $0x7f,%eax
80101aa9:	29 c8                	sub    %ecx,%eax
80101aab:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101ab1:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101ab6:	89 c1                	mov    %eax,%ecx
80101ab8:	29 f1                	sub    %esi,%ecx
80101aba:	39 d1                	cmp    %edx,%ecx
80101abc:	72 c2                	jb     80101a80 <consoleintr+0x340>
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
80101abe:	83 c0 01             	add    $0x1,%eax
  if(panicked) {
80101ac1:	8b 1d fc 1a 11 80    	mov    0x80111afc,%ebx
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
80101ac7:	83 e1 7f             	and    $0x7f,%ecx
80101aca:	a3 08 0f 11 80       	mov    %eax,0x80110f08
80101acf:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80101ad3:	88 81 80 0e 11 80    	mov    %al,-0x7feef180(%ecx)
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
80101aeb:	a1 08 0f 11 80       	mov    0x80110f08,%eax
      saveStatus = 1;
80101af0:	c7 05 18 14 11 80 01 	movl   $0x1,0x80111418
80101af7:	00 00 00 
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101afa:	68 80 00 00 00       	push   $0x80
80101aff:	6a 00                	push   $0x0
80101b01:	68 20 14 11 80       	push   $0x80111420
      saveIndex = 0;
80101b06:	c7 05 14 14 11 80 00 	movl   $0x0,0x80111414
80101b0d:	00 00 00 
      start_copy = input.e;
80101b10:	a3 10 14 11 80       	mov    %eax,0x80111410
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101b15:	e8 a6 40 00 00       	call   80105bc0 <memset>
      break;
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	e9 3e fc ff ff       	jmp    80101760 <consoleintr+0x20>
80101b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (upDownKeyIndex > 0)
80101b28:	8b 0d 20 15 11 80    	mov    0x80111520,%ecx
80101b2e:	85 c9                	test   %ecx,%ecx
80101b30:	0f 8e 2a fc ff ff    	jle    80101760 <consoleintr+0x20>
        showNewCommand();
80101b36:	e8 05 f3 ff ff       	call   80100e40 <showNewCommand>
80101b3b:	e9 20 fc ff ff       	jmp    80101760 <consoleintr+0x20>
      if ((input.e - cap) > input.w) 
80101b40:	8b 0d f8 1a 11 80    	mov    0x80111af8,%ecx
80101b46:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101b4b:	29 c8                	sub    %ecx,%eax
80101b4d:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
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
80101bb3:	89 0d f8 1a 11 80    	mov    %ecx,0x80111af8
80101bb9:	eb 68                	jmp    80101c23 <consoleintr+0x4e3>
80101bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop
  if(panicked) {
80101bc0:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
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
80101bda:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101bdf:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
80101be5:	0f 85 96 fd ff ff    	jne    80101981 <consoleintr+0x241>
80101beb:	e9 70 fb ff ff       	jmp    80101760 <consoleintr+0x20>
80101bf0:	b8 3f 00 00 00       	mov    $0x3f,%eax
80101bf5:	e8 e6 e8 ff ff       	call   801004e0 <consputc.part.0>
      input.buf[(input.e++) % INPUT_BUF] = c;
80101bfa:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101bff:	8d 50 01             	lea    0x1(%eax),%edx
80101c02:	83 e0 7f             	and    $0x7f,%eax
80101c05:	89 15 08 0f 11 80    	mov    %edx,0x80110f08
80101c0b:	c6 80 80 0e 11 80 3f 	movb   $0x3f,-0x7feef180(%eax)
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
80101c56:	e9 75 38 00 00       	jmp    801054d0 <procdump>
80101c5b:	b8 00 01 00 00       	mov    $0x100,%eax
80101c60:	e8 7b e8 ff ff       	call   801004e0 <consputc.part.0>
          if (cap == 0)
80101c65:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
80101c6a:	85 c0                	test   %eax,%eax
80101c6c:	0f 85 ee fa ff ff    	jne    80101760 <consoleintr+0x20>
            input.buf[input.e] = '\0';
80101c72:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101c77:	c6 80 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%eax)
80101c7e:	e9 dd fa ff ff       	jmp    80101760 <consoleintr+0x20>
          cap = 0;
80101c83:	c7 05 f8 1a 11 80 00 	movl   $0x0,0x80111af8
80101c8a:	00 00 00 
  for (int i = input.e; i > input.e - cap; i--)
80101c8d:	bb 0a 00 00 00       	mov    $0xa,%ebx
          addNewCommandToHistory();
80101c92:	e8 d9 ee ff ff       	call   80100b70 <addNewCommandToHistory>
          controlNewCommand();
80101c97:	e8 14 f5 ff ff       	call   801011b0 <controlNewCommand>
  for (int i = input.e; i > input.e - cap; i--)
80101c9c:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
80101ca0:	a1 08 0f 11 80       	mov    0x80110f08,%eax
          upDownKeyIndex = 0;
80101ca5:	c7 05 20 15 11 80 00 	movl   $0x0,0x80111520
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
80101cdd:	0f b6 99 80 0e 11 80 	movzbl -0x7feef180(%ecx),%ebx
80101ce4:	89 c1                	mov    %eax,%ecx
80101ce6:	c1 f9 1f             	sar    $0x1f,%ecx
80101ce9:	c1 e9 19             	shr    $0x19,%ecx
80101cec:	01 c8                	add    %ecx,%eax
80101cee:	83 e0 7f             	and    $0x7f,%eax
80101cf1:	29 c8                	sub    %ecx,%eax
80101cf3:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  for (int i = input.e - cap - 1; i < input.e; i++)
80101cf9:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101cfe:	39 d0                	cmp    %edx,%eax
80101d00:	77 c6                	ja     80101cc8 <consoleintr+0x588>
          input.e--;
80101d02:	8d 58 ff             	lea    -0x1(%eax),%ebx
  input.buf[input.e] = ' ';
80101d05:	c6 80 80 0e 11 80 20 	movb   $0x20,-0x7feef180(%eax)
}
80101d0c:	e9 cf fc ff ff       	jmp    801019e0 <consoleintr+0x2a0>
80101d11:	89 d8                	mov    %ebx,%eax
80101d13:	e8 c8 e7 ff ff       	call   801004e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101d18:	83 fb 0a             	cmp    $0xa,%ebx
80101d1b:	74 5b                	je     80101d78 <consoleintr+0x638>
80101d1d:	83 fb 04             	cmp    $0x4,%ebx
80101d20:	74 56                	je     80101d78 <consoleintr+0x638>
80101d22:	a1 00 0f 11 80       	mov    0x80110f00,%eax
80101d27:	83 e8 80             	sub    $0xffffff80,%eax
80101d2a:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
80101d30:	0f 85 2a fa ff ff    	jne    80101760 <consoleintr+0x20>
          wakeup(&input.r);
80101d36:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101d39:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80101d3e:	68 00 0f 11 80       	push   $0x80110f00
80101d43:	e8 a8 36 00 00       	call   801053f0 <wakeup>
80101d48:	83 c4 10             	add    $0x10,%esp
80101d4b:	e9 10 fa ff ff       	jmp    80101760 <consoleintr+0x20>
          consputc(clipboard[i]);  
80101d50:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
80101d54:	e8 87 e7 ff ff       	call   801004e0 <consputc.part.0>
          i++;
80101d59:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80101d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
        while(clipboard[i] != '\0')
80101d60:	0f b6 80 20 14 11 80 	movzbl -0x7feeebe0(%eax),%eax
80101d67:	88 45 e0             	mov    %al,-0x20(%ebp)
80101d6a:	84 c0                	test   %al,%al
80101d6c:	74 11                	je     80101d7f <consoleintr+0x63f>
  for (int i = input.e; i > input.e - cap; i--)
80101d6e:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101d73:	e9 f4 fc ff ff       	jmp    80101a6c <consoleintr+0x32c>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101d78:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101d7d:	eb b7                	jmp    80101d36 <consoleintr+0x5f6>
        saveStatus = 0;
80101d7f:	c7 05 18 14 11 80 00 	movl   $0x0,0x80111418
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
80101d9c:	e8 bf 2e 00 00       	call   80104c60 <myproc>
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
80101e14:	e8 37 68 00 00       	call   80108650 <setupkvm>
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
80101e83:	e8 e8 65 00 00       	call   80108470 <allocuvm>
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
80101eb9:	e8 c2 64 00 00       	call   80108380 <loaduvm>
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
80101efb:	e8 d0 66 00 00       	call   801085d0 <freevm>
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
80101f42:	e8 29 65 00 00       	call   80108470 <allocuvm>
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
80101f63:	e8 88 67 00 00       	call   801086f0 <clearpteu>
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
80101fb3:	e8 08 3e 00 00       	call   80105dc0 <strlen>
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
80101fc7:	e8 f4 3d 00 00       	call   80105dc0 <strlen>
80101fcc:	83 c0 01             	add    $0x1,%eax
80101fcf:	50                   	push   %eax
80101fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd3:	ff 34 b8             	push   (%eax,%edi,4)
80101fd6:	53                   	push   %ebx
80101fd7:	56                   	push   %esi
80101fd8:	e8 e3 68 00 00       	call   801088c0 <copyout>
80101fdd:	83 c4 20             	add    $0x20,%esp
80101fe0:	85 c0                	test   %eax,%eax
80101fe2:	79 ac                	jns    80101f90 <exec+0x200>
80101fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101ff1:	e8 da 65 00 00       	call   801085d0 <freevm>
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
80102043:	e8 78 68 00 00       	call   801088c0 <copyout>
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
80102081:	e8 fa 3c 00 00       	call   80105d80 <safestrcpy>
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
801020ad:	e8 3e 61 00 00       	call   801081f0 <switchuvm>
  freevm(oldpgdir);
801020b2:	89 3c 24             	mov    %edi,(%esp)
801020b5:	e8 16 65 00 00       	call   801085d0 <freevm>
  return 0;
801020ba:	83 c4 10             	add    $0x10,%esp
801020bd:	31 c0                	xor    %eax,%eax
801020bf:	e9 38 fd ff ff       	jmp    80101dfc <exec+0x6c>
    end_op();
801020c4:	e8 e7 1f 00 00       	call   801040b0 <end_op>
    cprintf("exec: fail\n");
801020c9:	83 ec 0c             	sub    $0xc,%esp
801020cc:	68 61 8a 10 80       	push   $0x80108a61
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
801020f6:	68 6d 8a 10 80       	push   $0x80108a6d
801020fb:	68 00 1b 11 80       	push   $0x80111b00
80102100:	e8 2b 38 00 00       	call   80105930 <initlock>
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
80102114:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
{
80102119:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010211c:	68 00 1b 11 80       	push   $0x80111b00
80102121:	e8 da 39 00 00       	call   80105b00 <acquire>
80102126:	83 c4 10             	add    $0x10,%esp
80102129:	eb 10                	jmp    8010213b <filealloc+0x2b>
8010212b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010212f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102130:	83 c3 18             	add    $0x18,%ebx
80102133:	81 fb 94 24 11 80    	cmp    $0x80112494,%ebx
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
8010214c:	68 00 1b 11 80       	push   $0x80111b00
80102151:	e8 4a 39 00 00       	call   80105aa0 <release>
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
80102165:	68 00 1b 11 80       	push   $0x80111b00
8010216a:	e8 31 39 00 00       	call   80105aa0 <release>
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
8010218a:	68 00 1b 11 80       	push   $0x80111b00
8010218f:	e8 6c 39 00 00       	call   80105b00 <acquire>
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
801021a7:	68 00 1b 11 80       	push   $0x80111b00
801021ac:	e8 ef 38 00 00       	call   80105aa0 <release>
  return f;
}
801021b1:	89 d8                	mov    %ebx,%eax
801021b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021b6:	c9                   	leave  
801021b7:	c3                   	ret    
    panic("filedup");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 74 8a 10 80       	push   $0x80108a74
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
801021dc:	68 00 1b 11 80       	push   $0x80111b00
801021e1:	e8 1a 39 00 00       	call   80105b00 <acquire>
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
80102214:	68 00 1b 11 80       	push   $0x80111b00
  ff = *f;
80102219:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010221c:	e8 7f 38 00 00       	call   80105aa0 <release>

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
80102240:	c7 45 08 00 1b 11 80 	movl   $0x80111b00,0x8(%ebp)
}
80102247:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224a:	5b                   	pop    %ebx
8010224b:	5e                   	pop    %esi
8010224c:	5f                   	pop    %edi
8010224d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010224e:	e9 4d 38 00 00       	jmp    80105aa0 <release>
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
8010229c:	68 7c 8a 10 80       	push   $0x80108a7c
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
80102382:	68 86 8a 10 80       	push   $0x80108a86
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
80102457:	68 8f 8a 10 80       	push   $0x80108a8f
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
80102491:	68 95 8a 10 80       	push   $0x80108a95
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
801024a8:	03 05 6c 41 11 80    	add    0x8011416c,%eax
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
80102507:	68 9f 8a 10 80       	push   $0x80108a9f
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
80102529:	8b 0d 54 41 11 80    	mov    0x80114154,%ecx
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
8010254c:	03 05 6c 41 11 80    	add    0x8011416c,%eax
80102552:	50                   	push   %eax
80102553:	ff 75 d8             	push   -0x28(%ebp)
80102556:	e8 75 db ff ff       	call   801000d0 <bread>
8010255b:	83 c4 10             	add    $0x10,%esp
8010255e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102561:	a1 54 41 11 80       	mov    0x80114154,%eax
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
801025b9:	39 05 54 41 11 80    	cmp    %eax,0x80114154
801025bf:	77 80                	ja     80102541 <balloc+0x21>
  panic("balloc: out of blocks");
801025c1:	83 ec 0c             	sub    $0xc,%esp
801025c4:	68 b2 8a 10 80       	push   $0x80108ab2
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
80102605:	e8 b6 35 00 00       	call   80105bc0 <memset>
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
8010263a:	bb 34 25 11 80       	mov    $0x80112534,%ebx
{
8010263f:	83 ec 28             	sub    $0x28,%esp
80102642:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102645:	68 00 25 11 80       	push   $0x80112500
8010264a:	e8 b1 34 00 00       	call   80105b00 <acquire>
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
8010266a:	81 fb 54 41 11 80    	cmp    $0x80114154,%ebx
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
80102689:	81 fb 54 41 11 80    	cmp    $0x80114154,%ebx
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
801026b2:	68 00 25 11 80       	push   $0x80112500
801026b7:	e8 e4 33 00 00       	call   80105aa0 <release>

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
801026dd:	68 00 25 11 80       	push   $0x80112500
      ip->ref++;
801026e2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801026e5:	e8 b6 33 00 00       	call   80105aa0 <release>
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
801026fd:	81 fb 54 41 11 80    	cmp    $0x80114154,%ebx
80102703:	73 10                	jae    80102715 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102705:	8b 43 08             	mov    0x8(%ebx),%eax
80102708:	85 c0                	test   %eax,%eax
8010270a:	0f 8f 50 ff ff ff    	jg     80102660 <iget+0x30>
80102710:	e9 68 ff ff ff       	jmp    8010267d <iget+0x4d>
    panic("iget: no inodes");
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	68 c8 8a 10 80       	push   $0x80108ac8
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
801027f5:	68 d8 8a 10 80       	push   $0x80108ad8
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
80102821:	e8 3a 34 00 00       	call   80105c60 <memmove>
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
80102844:	bb 40 25 11 80       	mov    $0x80112540,%ebx
80102849:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010284c:	68 eb 8a 10 80       	push   $0x80108aeb
80102851:	68 00 25 11 80       	push   $0x80112500
80102856:	e8 d5 30 00 00       	call   80105930 <initlock>
  for(i = 0; i < NINODE; i++) {
8010285b:	83 c4 10             	add    $0x10,%esp
8010285e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	68 f2 8a 10 80       	push   $0x80108af2
80102868:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102869:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010286f:	e8 8c 2f 00 00       	call   80105800 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80102874:	83 c4 10             	add    $0x10,%esp
80102877:	81 fb 60 41 11 80    	cmp    $0x80114160,%ebx
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
80102897:	68 54 41 11 80       	push   $0x80114154
8010289c:	e8 bf 33 00 00       	call   80105c60 <memmove>
  brelse(bp);
801028a1:	89 1c 24             	mov    %ebx,(%esp)
801028a4:	e8 47 d9 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801028a9:	ff 35 6c 41 11 80    	push   0x8011416c
801028af:	ff 35 68 41 11 80    	push   0x80114168
801028b5:	ff 35 64 41 11 80    	push   0x80114164
801028bb:	ff 35 60 41 11 80    	push   0x80114160
801028c1:	ff 35 5c 41 11 80    	push   0x8011415c
801028c7:	ff 35 58 41 11 80    	push   0x80114158
801028cd:	ff 35 54 41 11 80    	push   0x80114154
801028d3:	68 58 8b 10 80       	push   $0x80108b58
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
801028fc:	83 3d 5c 41 11 80 01 	cmpl   $0x1,0x8011415c
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
8010292f:	3b 3d 5c 41 11 80    	cmp    0x8011415c,%edi
80102935:	73 69                	jae    801029a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102937:	89 f8                	mov    %edi,%eax
80102939:	83 ec 08             	sub    $0x8,%esp
8010293c:	c1 e8 03             	shr    $0x3,%eax
8010293f:	03 05 68 41 11 80    	add    0x80114168,%eax
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
8010296e:	e8 4d 32 00 00       	call   80105bc0 <memset>
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
801029a3:	68 f8 8a 10 80       	push   $0x80108af8
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
801029c4:	03 05 68 41 11 80    	add    0x80114168,%eax
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
80102a11:	e8 4a 32 00 00       	call   80105c60 <memmove>
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
80102a3a:	68 00 25 11 80       	push   $0x80112500
80102a3f:	e8 bc 30 00 00       	call   80105b00 <acquire>
  ip->ref++;
80102a44:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102a48:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102a4f:	e8 4c 30 00 00       	call   80105aa0 <release>
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
80102a82:	e8 b9 2d 00 00       	call   80105840 <acquiresleep>
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
80102aa9:	03 05 68 41 11 80    	add    0x80114168,%eax
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
80102af8:	e8 63 31 00 00       	call   80105c60 <memmove>
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
80102b1d:	68 10 8b 10 80       	push   $0x80108b10
80102b22:	e8 39 d9 ff ff       	call   80100460 <panic>
    panic("ilock");
80102b27:	83 ec 0c             	sub    $0xc,%esp
80102b2a:	68 0a 8b 10 80       	push   $0x80108b0a
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
80102b53:	e8 88 2d 00 00       	call   801058e0 <holdingsleep>
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
80102b6f:	e9 2c 2d 00 00       	jmp    801058a0 <releasesleep>
    panic("iunlock");
80102b74:	83 ec 0c             	sub    $0xc,%esp
80102b77:	68 1f 8b 10 80       	push   $0x80108b1f
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
80102ba0:	e8 9b 2c 00 00       	call   80105840 <acquiresleep>
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
80102bba:	e8 e1 2c 00 00       	call   801058a0 <releasesleep>
  acquire(&icache.lock);
80102bbf:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102bc6:	e8 35 2f 00 00       	call   80105b00 <acquire>
  ip->ref--;
80102bcb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102bcf:	83 c4 10             	add    $0x10,%esp
80102bd2:	c7 45 08 00 25 11 80 	movl   $0x80112500,0x8(%ebp)
}
80102bd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdc:	5b                   	pop    %ebx
80102bdd:	5e                   	pop    %esi
80102bde:	5f                   	pop    %edi
80102bdf:	5d                   	pop    %ebp
  release(&icache.lock);
80102be0:	e9 bb 2e 00 00       	jmp    80105aa0 <release>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102be8:	83 ec 0c             	sub    $0xc,%esp
80102beb:	68 00 25 11 80       	push   $0x80112500
80102bf0:	e8 0b 2f 00 00       	call   80105b00 <acquire>
    int r = ip->ref;
80102bf5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102bf8:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102bff:	e8 9c 2e 00 00       	call   80105aa0 <release>
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
80102d03:	e8 d8 2b 00 00       	call   801058e0 <holdingsleep>
80102d08:	83 c4 10             	add    $0x10,%esp
80102d0b:	85 c0                	test   %eax,%eax
80102d0d:	74 21                	je     80102d30 <iunlockput+0x40>
80102d0f:	8b 43 08             	mov    0x8(%ebx),%eax
80102d12:	85 c0                	test   %eax,%eax
80102d14:	7e 1a                	jle    80102d30 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102d16:	83 ec 0c             	sub    $0xc,%esp
80102d19:	56                   	push   %esi
80102d1a:	e8 81 2b 00 00       	call   801058a0 <releasesleep>
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
80102d33:	68 1f 8b 10 80       	push   $0x80108b1f
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
80102e17:	e8 44 2e 00 00       	call   80105c60 <memmove>
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
80102e4a:	8b 04 c5 a0 24 11 80 	mov    -0x7feedb60(,%eax,8),%eax
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
80102f13:	e8 48 2d 00 00       	call   80105c60 <memmove>
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
80102f5a:	8b 04 c5 a4 24 11 80 	mov    -0x7feedb5c(,%eax,8),%eax
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
80102fae:	e8 1d 2d 00 00       	call   80105cd0 <strncmp>
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
8010300d:	e8 be 2c 00 00       	call   80105cd0 <strncmp>
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
80103052:	68 39 8b 10 80       	push   $0x80108b39
80103057:	e8 04 d4 ff ff       	call   80100460 <panic>
    panic("dirlookup not DIR");
8010305c:	83 ec 0c             	sub    $0xc,%esp
8010305f:	68 27 8b 10 80       	push   $0x80108b27
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
8010308a:	e8 d1 1b 00 00       	call   80104c60 <myproc>
  acquire(&icache.lock);
8010308f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103092:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103095:	68 00 25 11 80       	push   $0x80112500
8010309a:	e8 61 2a 00 00       	call   80105b00 <acquire>
  ip->ref++;
8010309f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801030a3:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
801030aa:	e8 f1 29 00 00       	call   80105aa0 <release>
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
80103107:	e8 54 2b 00 00       	call   80105c60 <memmove>
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
8010316c:	e8 6f 27 00 00       	call   801058e0 <holdingsleep>
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
8010318e:	e8 0d 27 00 00       	call   801058a0 <releasesleep>
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
801031bb:	e8 a0 2a 00 00       	call   80105c60 <memmove>
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
8010320b:	e8 d0 26 00 00       	call   801058e0 <holdingsleep>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	85 c0                	test   %eax,%eax
80103215:	0f 84 91 00 00 00    	je     801032ac <namex+0x23c>
8010321b:	8b 46 08             	mov    0x8(%esi),%eax
8010321e:	85 c0                	test   %eax,%eax
80103220:	0f 8e 86 00 00 00    	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	53                   	push   %ebx
8010322a:	e8 71 26 00 00       	call   801058a0 <releasesleep>
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
8010324d:	e8 8e 26 00 00       	call   801058e0 <holdingsleep>
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
80103270:	e8 6b 26 00 00       	call   801058e0 <holdingsleep>
80103275:	83 c4 10             	add    $0x10,%esp
80103278:	85 c0                	test   %eax,%eax
8010327a:	74 30                	je     801032ac <namex+0x23c>
8010327c:	8b 7e 08             	mov    0x8(%esi),%edi
8010327f:	85 ff                	test   %edi,%edi
80103281:	7e 29                	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	53                   	push   %ebx
80103287:	e8 14 26 00 00       	call   801058a0 <releasesleep>
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
801032af:	68 1f 8b 10 80       	push   $0x80108b1f
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
8010331d:	e8 fe 29 00 00       	call   80105d20 <strncpy>
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
8010335b:	68 48 8b 10 80       	push   $0x80108b48
80103360:	e8 fb d0 ff ff       	call   80100460 <panic>
    panic("dirlink");
80103365:	83 ec 0c             	sub    $0xc,%esp
80103368:	68 9a 91 10 80       	push   $0x8010919a
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
8010347b:	68 b4 8b 10 80       	push   $0x80108bb4
80103480:	e8 db cf ff ff       	call   80100460 <panic>
    panic("idestart");
80103485:	83 ec 0c             	sub    $0xc,%esp
80103488:	68 ab 8b 10 80       	push   $0x80108bab
8010348d:	e8 ce cf ff ff       	call   80100460 <panic>
80103492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <ideinit>:
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801034a6:	68 c6 8b 10 80       	push   $0x80108bc6
801034ab:	68 a0 41 11 80       	push   $0x801141a0
801034b0:	e8 7b 24 00 00       	call   80105930 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801034b5:	58                   	pop    %eax
801034b6:	a1 24 43 11 80       	mov    0x80114324,%eax
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
801034fa:	c7 05 80 41 11 80 01 	movl   $0x1,0x80114180
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
80103529:	68 a0 41 11 80       	push   $0x801141a0
8010352e:	e8 cd 25 00 00       	call   80105b00 <acquire>

  if((b = idequeue) == 0){
80103533:	8b 1d 84 41 11 80    	mov    0x80114184,%ebx
80103539:	83 c4 10             	add    $0x10,%esp
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	74 63                	je     801035a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103540:	8b 43 58             	mov    0x58(%ebx),%eax
80103543:	a3 84 41 11 80       	mov    %eax,0x80114184

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
8010358d:	e8 5e 1e 00 00       	call   801053f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80103592:	a1 84 41 11 80       	mov    0x80114184,%eax
80103597:	83 c4 10             	add    $0x10,%esp
8010359a:	85 c0                	test   %eax,%eax
8010359c:	74 05                	je     801035a3 <ideintr+0x83>
    idestart(idequeue);
8010359e:	e8 1d fe ff ff       	call   801033c0 <idestart>
    release(&idelock);
801035a3:	83 ec 0c             	sub    $0xc,%esp
801035a6:	68 a0 41 11 80       	push   $0x801141a0
801035ab:	e8 f0 24 00 00       	call   80105aa0 <release>

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
801035ce:	e8 0d 23 00 00       	call   801058e0 <holdingsleep>
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
801035f3:	a1 80 41 11 80       	mov    0x80114180,%eax
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 84 87 00 00 00    	je     80103687 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	68 a0 41 11 80       	push   $0x801141a0
80103608:	e8 f3 24 00 00       	call   80105b00 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010360d:	a1 84 41 11 80       	mov    0x80114184,%eax
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
8010362e:	39 1d 84 41 11 80    	cmp    %ebx,0x80114184
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
80103643:	68 a0 41 11 80       	push   $0x801141a0
80103648:	53                   	push   %ebx
80103649:	e8 e2 1c 00 00       	call   80105330 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010364e:	8b 03                	mov    (%ebx),%eax
80103650:	83 c4 10             	add    $0x10,%esp
80103653:	83 e0 06             	and    $0x6,%eax
80103656:	83 f8 02             	cmp    $0x2,%eax
80103659:	75 e5                	jne    80103640 <iderw+0x80>
  }


  release(&idelock);
8010365b:	c7 45 08 a0 41 11 80 	movl   $0x801141a0,0x8(%ebp)
}
80103662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103665:	c9                   	leave  
  release(&idelock);
80103666:	e9 35 24 00 00       	jmp    80105aa0 <release>
8010366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop
    idestart(b);
80103670:	89 d8                	mov    %ebx,%eax
80103672:	e8 49 fd ff ff       	call   801033c0 <idestart>
80103677:	eb bd                	jmp    80103636 <iderw+0x76>
80103679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103680:	ba 84 41 11 80       	mov    $0x80114184,%edx
80103685:	eb a5                	jmp    8010362c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80103687:	83 ec 0c             	sub    $0xc,%esp
8010368a:	68 f5 8b 10 80       	push   $0x80108bf5
8010368f:	e8 cc cd ff ff       	call   80100460 <panic>
    panic("iderw: nothing to do");
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	68 e0 8b 10 80       	push   $0x80108be0
8010369c:	e8 bf cd ff ff       	call   80100460 <panic>
    panic("iderw: buf not locked");
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	68 ca 8b 10 80       	push   $0x80108bca
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
801036b1:	c7 05 d4 41 11 80 00 	movl   $0xfec00000,0x801141d4
801036b8:	00 c0 fe 
{
801036bb:	89 e5                	mov    %esp,%ebp
801036bd:	56                   	push   %esi
801036be:	53                   	push   %ebx
  ioapic->reg = reg;
801036bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801036c6:	00 00 00 
  return ioapic->data;
801036c9:	8b 15 d4 41 11 80    	mov    0x801141d4,%edx
801036cf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801036d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801036d8:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801036de:	0f b6 15 20 43 11 80 	movzbl 0x80114320,%edx
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
801036fa:	68 14 8c 10 80       	push   $0x80108c14
801036ff:	e8 dc d0 ff ff       	call   801007e0 <cprintf>
  ioapic->reg = reg;
80103704:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
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
80103724:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
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
8010373e:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
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
80103761:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
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
80103775:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010377b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010377e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103781:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80103784:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103786:	a1 d4 41 11 80       	mov    0x801141d4,%eax
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
801037b2:	81 fb 70 e5 11 80    	cmp    $0x8011e570,%ebx
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
801037d2:	e8 e9 23 00 00       	call   80105bc0 <memset>

  if(kmem.use_lock)
801037d7:	8b 15 14 42 11 80    	mov    0x80114214,%edx
801037dd:	83 c4 10             	add    $0x10,%esp
801037e0:	85 d2                	test   %edx,%edx
801037e2:	75 1c                	jne    80103800 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801037e4:	a1 18 42 11 80       	mov    0x80114218,%eax
801037e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801037eb:	a1 14 42 11 80       	mov    0x80114214,%eax
  kmem.freelist = r;
801037f0:	89 1d 18 42 11 80    	mov    %ebx,0x80114218
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
80103803:	68 e0 41 11 80       	push   $0x801141e0
80103808:	e8 f3 22 00 00       	call   80105b00 <acquire>
8010380d:	83 c4 10             	add    $0x10,%esp
80103810:	eb d2                	jmp    801037e4 <kfree+0x44>
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103818:	c7 45 08 e0 41 11 80 	movl   $0x801141e0,0x8(%ebp)
}
8010381f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103822:	c9                   	leave  
    release(&kmem.lock);
80103823:	e9 78 22 00 00       	jmp    80105aa0 <release>
    panic("kfree");
80103828:	83 ec 0c             	sub    $0xc,%esp
8010382b:	68 46 8c 10 80       	push   $0x80108c46
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
801038d4:	c7 05 14 42 11 80 01 	movl   $0x1,0x80114214
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
801038fb:	68 4c 8c 10 80       	push   $0x80108c4c
80103900:	68 e0 41 11 80       	push   $0x801141e0
80103905:	e8 26 20 00 00       	call   80105930 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010390a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010390d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103910:	c7 05 14 42 11 80 00 	movl   $0x0,0x80114214
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
80103960:	a1 14 42 11 80       	mov    0x80114214,%eax
80103965:	85 c0                	test   %eax,%eax
80103967:	75 1f                	jne    80103988 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103969:	a1 18 42 11 80       	mov    0x80114218,%eax
  if(r)
8010396e:	85 c0                	test   %eax,%eax
80103970:	74 0e                	je     80103980 <kalloc+0x20>
    kmem.freelist = r->next;
80103972:	8b 10                	mov    (%eax),%edx
80103974:	89 15 18 42 11 80    	mov    %edx,0x80114218
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
8010398e:	68 e0 41 11 80       	push   $0x801141e0
80103993:	e8 68 21 00 00       	call   80105b00 <acquire>
  r = kmem.freelist;
80103998:	a1 18 42 11 80       	mov    0x80114218,%eax
  if(kmem.use_lock)
8010399d:	8b 15 14 42 11 80    	mov    0x80114214,%edx
  if(r)
801039a3:	83 c4 10             	add    $0x10,%esp
801039a6:	85 c0                	test   %eax,%eax
801039a8:	74 08                	je     801039b2 <kalloc+0x52>
    kmem.freelist = r->next;
801039aa:	8b 08                	mov    (%eax),%ecx
801039ac:	89 0d 18 42 11 80    	mov    %ecx,0x80114218
  if(kmem.use_lock)
801039b2:	85 d2                	test   %edx,%edx
801039b4:	74 16                	je     801039cc <kalloc+0x6c>
    release(&kmem.lock);
801039b6:	83 ec 0c             	sub    $0xc,%esp
801039b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039bc:	68 e0 41 11 80       	push   $0x801141e0
801039c1:	e8 da 20 00 00       	call   80105aa0 <release>
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
801039e8:	8b 1d 1c 42 11 80    	mov    0x8011421c,%ebx
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
80103a0b:	0f b6 91 80 8d 10 80 	movzbl -0x7fef7280(%ecx),%edx
  shift ^= togglecode[data];
80103a12:	0f b6 81 80 8c 10 80 	movzbl -0x7fef7380(%ecx),%eax
  shift |= shiftcode[data];
80103a19:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103a1b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a1d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103a1f:	89 15 1c 42 11 80    	mov    %edx,0x8011421c
  c = charcode[shift & (CTL | SHIFT)][data];
80103a25:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103a28:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a2b:	8b 04 85 60 8c 10 80 	mov    -0x7fef73a0(,%eax,4),%eax
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
80103a55:	89 1d 1c 42 11 80    	mov    %ebx,0x8011421c
}
80103a5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5e:	c9                   	leave  
80103a5f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80103a60:	83 e0 7f             	and    $0x7f,%eax
80103a63:	85 d2                	test   %edx,%edx
80103a65:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103a68:	0f b6 81 80 8d 10 80 	movzbl -0x7fef7280(%ecx),%eax
80103a6f:	83 c8 40             	or     $0x40,%eax
80103a72:	0f b6 c0             	movzbl %al,%eax
80103a75:	f7 d0                	not    %eax
80103a77:	21 d8                	and    %ebx,%eax
}
80103a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80103a7c:	a3 1c 42 11 80       	mov    %eax,0x8011421c
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
80103ad0:	a1 20 42 11 80       	mov    0x80114220,%eax
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
80103bd0:	a1 20 42 11 80       	mov    0x80114220,%eax
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
80103bf0:	a1 20 42 11 80       	mov    0x80114220,%eax
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
80103c5e:	a1 20 42 11 80       	mov    0x80114220,%eax
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
80103dd7:	e8 34 1e 00 00       	call   80105c10 <memcmp>
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
80103ea0:	8b 0d 88 42 11 80    	mov    0x80114288,%ecx
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
80103ec0:	a1 74 42 11 80       	mov    0x80114274,%eax
80103ec5:	83 ec 08             	sub    $0x8,%esp
80103ec8:	01 f8                	add    %edi,%eax
80103eca:	83 c0 01             	add    $0x1,%eax
80103ecd:	50                   	push   %eax
80103ece:	ff 35 84 42 11 80    	push   0x80114284
80103ed4:	e8 f7 c1 ff ff       	call   801000d0 <bread>
80103ed9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103edb:	58                   	pop    %eax
80103edc:	5a                   	pop    %edx
80103edd:	ff 34 bd 8c 42 11 80 	push   -0x7feebd74(,%edi,4)
80103ee4:	ff 35 84 42 11 80    	push   0x80114284
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
80103f04:	e8 57 1d 00 00       	call   80105c60 <memmove>
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
80103f24:	39 3d 88 42 11 80    	cmp    %edi,0x80114288
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
80103f47:	ff 35 74 42 11 80    	push   0x80114274
80103f4d:	ff 35 84 42 11 80    	push   0x80114284
80103f53:	e8 78 c1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103f58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103f5d:	a1 88 42 11 80       	mov    0x80114288,%eax
80103f62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103f65:	85 c0                	test   %eax,%eax
80103f67:	7e 19                	jle    80103f82 <write_head+0x42>
80103f69:	31 d2                	xor    %edx,%edx
80103f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103f70:	8b 0c 95 8c 42 11 80 	mov    -0x7feebd74(,%edx,4),%ecx
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
80103faa:	68 80 8e 10 80       	push   $0x80108e80
80103faf:	68 40 42 11 80       	push   $0x80114240
80103fb4:	e8 77 19 00 00       	call   80105930 <initlock>
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
80103fc9:	89 1d 84 42 11 80    	mov    %ebx,0x80114284
  log.size = sb.nlog;
80103fcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103fd2:	a3 74 42 11 80       	mov    %eax,0x80114274
  log.size = sb.nlog;
80103fd7:	89 15 78 42 11 80    	mov    %edx,0x80114278
  struct buf *buf = bread(log.dev, log.start);
80103fdd:	5a                   	pop    %edx
80103fde:	50                   	push   %eax
80103fdf:	53                   	push   %ebx
80103fe0:	e8 eb c0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103fe5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103fe8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80103feb:	89 1d 88 42 11 80    	mov    %ebx,0x80114288
  for (i = 0; i < log.lh.n; i++) {
80103ff1:	85 db                	test   %ebx,%ebx
80103ff3:	7e 1d                	jle    80104012 <initlog+0x72>
80103ff5:	31 d2                	xor    %edx,%edx
80103ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ffe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80104000:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80104004:	89 0c 95 8c 42 11 80 	mov    %ecx,-0x7feebd74(,%edx,4)
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
80104020:	c7 05 88 42 11 80 00 	movl   $0x0,0x80114288
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
80104046:	68 40 42 11 80       	push   $0x80114240
8010404b:	e8 b0 1a 00 00       	call   80105b00 <acquire>
80104050:	83 c4 10             	add    $0x10,%esp
80104053:	eb 18                	jmp    8010406d <begin_op+0x2d>
80104055:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104058:	83 ec 08             	sub    $0x8,%esp
8010405b:	68 40 42 11 80       	push   $0x80114240
80104060:	68 40 42 11 80       	push   $0x80114240
80104065:	e8 c6 12 00 00       	call   80105330 <sleep>
8010406a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010406d:	a1 80 42 11 80       	mov    0x80114280,%eax
80104072:	85 c0                	test   %eax,%eax
80104074:	75 e2                	jne    80104058 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104076:	a1 7c 42 11 80       	mov    0x8011427c,%eax
8010407b:	8b 15 88 42 11 80    	mov    0x80114288,%edx
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
80104092:	a3 7c 42 11 80       	mov    %eax,0x8011427c
      release(&log.lock);
80104097:	68 40 42 11 80       	push   $0x80114240
8010409c:	e8 ff 19 00 00       	call   80105aa0 <release>
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
801040b9:	68 40 42 11 80       	push   $0x80114240
801040be:	e8 3d 1a 00 00       	call   80105b00 <acquire>
  log.outstanding -= 1;
801040c3:	a1 7c 42 11 80       	mov    0x8011427c,%eax
  if(log.committing)
801040c8:	8b 35 80 42 11 80    	mov    0x80114280,%esi
801040ce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801040d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801040d4:	89 1d 7c 42 11 80    	mov    %ebx,0x8011427c
  if(log.committing)
801040da:	85 f6                	test   %esi,%esi
801040dc:	0f 85 22 01 00 00    	jne    80104204 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801040e2:	85 db                	test   %ebx,%ebx
801040e4:	0f 85 f6 00 00 00    	jne    801041e0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801040ea:	c7 05 80 42 11 80 01 	movl   $0x1,0x80114280
801040f1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	68 40 42 11 80       	push   $0x80114240
801040fc:	e8 9f 19 00 00       	call   80105aa0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104101:	8b 0d 88 42 11 80    	mov    0x80114288,%ecx
80104107:	83 c4 10             	add    $0x10,%esp
8010410a:	85 c9                	test   %ecx,%ecx
8010410c:	7f 42                	jg     80104150 <end_op+0xa0>
    acquire(&log.lock);
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	68 40 42 11 80       	push   $0x80114240
80104116:	e8 e5 19 00 00       	call   80105b00 <acquire>
    wakeup(&log);
8010411b:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
    log.committing = 0;
80104122:	c7 05 80 42 11 80 00 	movl   $0x0,0x80114280
80104129:	00 00 00 
    wakeup(&log);
8010412c:	e8 bf 12 00 00       	call   801053f0 <wakeup>
    release(&log.lock);
80104131:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80104138:	e8 63 19 00 00       	call   80105aa0 <release>
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
80104150:	a1 74 42 11 80       	mov    0x80114274,%eax
80104155:	83 ec 08             	sub    $0x8,%esp
80104158:	01 d8                	add    %ebx,%eax
8010415a:	83 c0 01             	add    $0x1,%eax
8010415d:	50                   	push   %eax
8010415e:	ff 35 84 42 11 80    	push   0x80114284
80104164:	e8 67 bf ff ff       	call   801000d0 <bread>
80104169:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010416b:	58                   	pop    %eax
8010416c:	5a                   	pop    %edx
8010416d:	ff 34 9d 8c 42 11 80 	push   -0x7feebd74(,%ebx,4)
80104174:	ff 35 84 42 11 80    	push   0x80114284
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
80104194:	e8 c7 1a 00 00       	call   80105c60 <memmove>
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
801041b4:	3b 1d 88 42 11 80    	cmp    0x80114288,%ebx
801041ba:	7c 94                	jl     80104150 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801041bc:	e8 7f fd ff ff       	call   80103f40 <write_head>
    install_trans(); // Now install writes to home locations
801041c1:	e8 da fc ff ff       	call   80103ea0 <install_trans>
    log.lh.n = 0;
801041c6:	c7 05 88 42 11 80 00 	movl   $0x0,0x80114288
801041cd:	00 00 00 
    write_head();    // Erase the transaction from the log
801041d0:	e8 6b fd ff ff       	call   80103f40 <write_head>
801041d5:	e9 34 ff ff ff       	jmp    8010410e <end_op+0x5e>
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 40 42 11 80       	push   $0x80114240
801041e8:	e8 03 12 00 00       	call   801053f0 <wakeup>
  release(&log.lock);
801041ed:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
801041f4:	e8 a7 18 00 00       	call   80105aa0 <release>
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
80104207:	68 84 8e 10 80       	push   $0x80108e84
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
80104227:	8b 15 88 42 11 80    	mov    0x80114288,%edx
{
8010422d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104230:	83 fa 1d             	cmp    $0x1d,%edx
80104233:	0f 8f 85 00 00 00    	jg     801042be <log_write+0x9e>
80104239:	a1 78 42 11 80       	mov    0x80114278,%eax
8010423e:	83 e8 01             	sub    $0x1,%eax
80104241:	39 c2                	cmp    %eax,%edx
80104243:	7d 79                	jge    801042be <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104245:	a1 7c 42 11 80       	mov    0x8011427c,%eax
8010424a:	85 c0                	test   %eax,%eax
8010424c:	7e 7d                	jle    801042cb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010424e:	83 ec 0c             	sub    $0xc,%esp
80104251:	68 40 42 11 80       	push   $0x80114240
80104256:	e8 a5 18 00 00       	call   80105b00 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010425b:	8b 15 88 42 11 80    	mov    0x80114288,%edx
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
80104277:	39 0c 85 8c 42 11 80 	cmp    %ecx,-0x7feebd74(,%eax,4)
8010427e:	75 f0                	jne    80104270 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104280:	89 0c 85 8c 42 11 80 	mov    %ecx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80104287:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010428a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010428d:	c7 45 08 40 42 11 80 	movl   $0x80114240,0x8(%ebp)
}
80104294:	c9                   	leave  
  release(&log.lock);
80104295:	e9 06 18 00 00       	jmp    80105aa0 <release>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801042a0:	89 0c 95 8c 42 11 80 	mov    %ecx,-0x7feebd74(,%edx,4)
    log.lh.n++;
801042a7:	83 c2 01             	add    $0x1,%edx
801042aa:	89 15 88 42 11 80    	mov    %edx,0x80114288
801042b0:	eb d5                	jmp    80104287 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801042b2:	8b 43 08             	mov    0x8(%ebx),%eax
801042b5:	a3 8c 42 11 80       	mov    %eax,0x8011428c
  if (i == log.lh.n)
801042ba:	75 cb                	jne    80104287 <log_write+0x67>
801042bc:	eb e9                	jmp    801042a7 <log_write+0x87>
    panic("too big a transaction");
801042be:	83 ec 0c             	sub    $0xc,%esp
801042c1:	68 93 8e 10 80       	push   $0x80108e93
801042c6:	e8 95 c1 ff ff       	call   80100460 <panic>
    panic("log_write outside of trans");
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	68 a9 8e 10 80       	push   $0x80108ea9
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
801042e7:	e8 54 09 00 00       	call   80104c40 <cpuid>
801042ec:	89 c3                	mov    %eax,%ebx
801042ee:	e8 4d 09 00 00       	call   80104c40 <cpuid>
801042f3:	83 ec 04             	sub    $0x4,%esp
801042f6:	53                   	push   %ebx
801042f7:	50                   	push   %eax
801042f8:	68 c4 8e 10 80       	push   $0x80108ec4
801042fd:	e8 de c4 ff ff       	call   801007e0 <cprintf>
  idtinit();       // load idt register
80104302:	e8 a9 2d 00 00       	call   801070b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104307:	e8 d4 08 00 00       	call   80104be0 <mycpu>
8010430c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010430e:	b8 01 00 00 00       	mov    $0x1,%eax
80104313:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010431a:	e8 01 0c 00 00       	call   80104f20 <scheduler>
8010431f:	90                   	nop

80104320 <mpenter>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104326:	e8 b5 3e 00 00       	call   801081e0 <switchkvm>
  seginit();
8010432b:	e8 20 3e 00 00       	call   80108150 <seginit>
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
80104357:	68 70 e5 11 80       	push   $0x8011e570
8010435c:	e8 8f f5 ff ff       	call   801038f0 <kinit1>
  kvmalloc();      // kernel page table
80104361:	e8 6a 43 00 00       	call   801086d0 <kvmalloc>
  mpinit();        // detect other processors
80104366:	e8 85 01 00 00       	call   801044f0 <mpinit>
  lapicinit();     // interrupt controller
8010436b:	e8 60 f7 ff ff       	call   80103ad0 <lapicinit>
  seginit();       // segment descriptors
80104370:	e8 db 3d 00 00       	call   80108150 <seginit>
  picinit();       // disable pic
80104375:	e8 76 03 00 00       	call   801046f0 <picinit>
  ioapicinit();    // another interrupt controller
8010437a:	e8 31 f3 ff ff       	call   801036b0 <ioapicinit>
  consoleinit();   // console hardware
8010437f:	e8 ac ce ff ff       	call   80101230 <consoleinit>
  uartinit();      // serial port
80104384:	e8 57 30 00 00       	call   801073e0 <uartinit>
  pinit();         // process table
80104389:	e8 32 08 00 00       	call   80104bc0 <pinit>
  tvinit();        // trap vectors
8010438e:	e8 9d 2c 00 00       	call   80107030 <tvinit>
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
801043aa:	68 8c c4 10 80       	push   $0x8010c48c
801043af:	68 00 70 00 80       	push   $0x80007000
801043b4:	e8 a7 18 00 00       	call   80105c60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801043b9:	83 c4 10             	add    $0x10,%esp
801043bc:	69 05 24 43 11 80 b0 	imul   $0xb0,0x80114324,%eax
801043c3:	00 00 00 
801043c6:	05 40 43 11 80       	add    $0x80114340,%eax
801043cb:	3d 40 43 11 80       	cmp    $0x80114340,%eax
801043d0:	76 7e                	jbe    80104450 <main+0x110>
801043d2:	bb 40 43 11 80       	mov    $0x80114340,%ebx
801043d7:	eb 20                	jmp    801043f9 <main+0xb9>
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e0:	69 05 24 43 11 80 b0 	imul   $0xb0,0x80114324,%eax
801043e7:	00 00 00 
801043ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801043f0:	05 40 43 11 80       	add    $0x80114340,%eax
801043f5:	39 c3                	cmp    %eax,%ebx
801043f7:	73 57                	jae    80104450 <main+0x110>
    if(c == mycpu())  // We've started already.
801043f9:	e8 e2 07 00 00       	call   80104be0 <mycpu>
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
80104414:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010441b:	b0 10 00 
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
80104462:	e8 29 08 00 00       	call   80104c90 <userinit>
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
8010449e:	68 d8 8e 10 80       	push   $0x80108ed8
801044a3:	56                   	push   %esi
801044a4:	e8 67 17 00 00       	call   80105c10 <memcmp>
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
80104556:	68 dd 8e 10 80       	push   $0x80108edd
8010455b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010455c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010455f:	e8 ac 16 00 00       	call   80105c10 <memcmp>
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
801045b6:	a3 20 42 11 80       	mov    %eax,0x80114220
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
80104637:	88 0d 20 43 11 80    	mov    %cl,0x80114320
      continue;
8010463d:	eb 99                	jmp    801045d8 <mpinit+0xe8>
8010463f:	90                   	nop
      if(ncpu < NCPU) {
80104640:	8b 0d 24 43 11 80    	mov    0x80114324,%ecx
80104646:	83 f9 07             	cmp    $0x7,%ecx
80104649:	7f 19                	jg     80104664 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010464b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80104651:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104655:	83 c1 01             	add    $0x1,%ecx
80104658:	89 0d 24 43 11 80    	mov    %ecx,0x80114324
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010465e:	88 9f 40 43 11 80    	mov    %bl,-0x7feebcc0(%edi)
      p += sizeof(struct mpproc);
80104664:	83 c0 14             	add    $0x14,%eax
      continue;
80104667:	e9 6c ff ff ff       	jmp    801045d8 <mpinit+0xe8>
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80104670:	83 ec 0c             	sub    $0xc,%esp
80104673:	68 e2 8e 10 80       	push   $0x80108ee2
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
801046a2:	68 d8 8e 10 80       	push   $0x80108ed8
801046a7:	53                   	push   %ebx
801046a8:	e8 63 15 00 00       	call   80105c10 <memcmp>
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
801046d8:	68 fc 8e 10 80       	push   $0x80108efc
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
80104783:	68 1b 8f 10 80       	push   $0x80108f1b
80104788:	50                   	push   %eax
80104789:	e8 a2 11 00 00       	call   80105930 <initlock>
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
8010481f:	e8 dc 12 00 00       	call   80105b00 <acquire>
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
8010483f:	e8 ac 0b 00 00       	call   801053f0 <wakeup>
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
80104864:	e9 37 12 00 00       	jmp    80105aa0 <release>
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	53                   	push   %ebx
80104874:	e8 27 12 00 00       	call   80105aa0 <release>
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
801048a4:	e8 47 0b 00 00       	call   801053f0 <wakeup>
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
801048bd:	e8 3e 12 00 00       	call   80105b00 <acquire>
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
80104908:	e8 53 03 00 00       	call   80104c60 <myproc>
8010490d:	8b 48 24             	mov    0x24(%eax),%ecx
80104910:	85 c9                	test   %ecx,%ecx
80104912:	75 34                	jne    80104948 <pipewrite+0x98>
      wakeup(&p->nread);
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	57                   	push   %edi
80104918:	e8 d3 0a 00 00       	call   801053f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010491d:	58                   	pop    %eax
8010491e:	5a                   	pop    %edx
8010491f:	53                   	push   %ebx
80104920:	56                   	push   %esi
80104921:	e8 0a 0a 00 00       	call   80105330 <sleep>
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
8010494c:	e8 4f 11 00 00       	call   80105aa0 <release>
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
8010499a:	e8 51 0a 00 00       	call   801053f0 <wakeup>
  release(&p->lock);
8010499f:	89 1c 24             	mov    %ebx,(%esp)
801049a2:	e8 f9 10 00 00       	call   80105aa0 <release>
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
801049c6:	e8 35 11 00 00       	call   80105b00 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801049cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801049da:	74 2f                	je     80104a0b <piperead+0x5b>
801049dc:	eb 37                	jmp    80104a15 <piperead+0x65>
801049de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801049e0:	e8 7b 02 00 00       	call   80104c60 <myproc>
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
801049f5:	e8 36 09 00 00       	call   80105330 <sleep>
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
80104a56:	e8 95 09 00 00       	call   801053f0 <wakeup>
  release(&p->lock);
80104a5b:	89 34 24             	mov    %esi,(%esp)
80104a5e:	e8 3d 10 00 00       	call   80105aa0 <release>
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
80104a79:	e8 22 10 00 00       	call   80105aa0 <release>
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
80104a94:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
{
80104a99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104a9c:	68 c0 48 11 80       	push   $0x801148c0
80104aa1:	e8 5a 10 00 00       	call   80105b00 <acquire>
80104aa6:	83 c4 10             	add    $0x10,%esp
80104aa9:	eb 17                	jmp    80104ac2 <allocproc+0x32>
80104aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ab0:	81 c3 10 02 00 00    	add    $0x210,%ebx
80104ab6:	81 fb f4 cc 11 80    	cmp    $0x8011ccf4,%ebx
80104abc:	0f 84 7e 00 00 00    	je     80104b40 <allocproc+0xb0>
    if(p->state == UNUSED)
80104ac2:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ac5:	85 c0                	test   %eax,%eax
80104ac7:	75 e7                	jne    80104ab0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104ac9:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->numsystemcalls=0;

  release(&ptable.lock);
80104ace:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104ad1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->numsystemcalls=0;
80104ad8:	c7 83 0c 02 00 00 00 	movl   $0x0,0x20c(%ebx)
80104adf:	00 00 00 
  p->pid = nextpid++;
80104ae2:	89 43 10             	mov    %eax,0x10(%ebx)
80104ae5:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104ae8:	68 c0 48 11 80       	push   $0x801148c0
  p->pid = nextpid++;
80104aed:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104af3:	e8 a8 0f 00 00       	call   80105aa0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104af8:	e8 63 ee ff ff       	call   80103960 <kalloc>
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	89 43 08             	mov    %eax,0x8(%ebx)
80104b03:	85 c0                	test   %eax,%eax
80104b05:	74 52                	je     80104b59 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104b07:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104b0d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104b10:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104b15:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104b18:	c7 40 14 1f 70 10 80 	movl   $0x8010701f,0x14(%eax)
  p->context = (struct context*)sp;
80104b1f:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104b22:	6a 14                	push   $0x14
80104b24:	6a 00                	push   $0x0
80104b26:	50                   	push   %eax
80104b27:	e8 94 10 00 00       	call   80105bc0 <memset>
  p->context->eip = (uint)forkret;
80104b2c:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80104b2f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104b32:	c7 40 10 70 4b 10 80 	movl   $0x80104b70,0x10(%eax)
}
80104b39:	89 d8                	mov    %ebx,%eax
80104b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b3e:	c9                   	leave  
80104b3f:	c3                   	ret    
  release(&ptable.lock);
80104b40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104b43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104b45:	68 c0 48 11 80       	push   $0x801148c0
80104b4a:	e8 51 0f 00 00       	call   80105aa0 <release>
}
80104b4f:	89 d8                	mov    %ebx,%eax
  return 0;
80104b51:	83 c4 10             	add    $0x10,%esp
}
80104b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b57:	c9                   	leave  
80104b58:	c3                   	ret    
    p->state = UNUSED;
80104b59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104b60:	31 db                	xor    %ebx,%ebx
}
80104b62:	89 d8                	mov    %ebx,%eax
80104b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b67:	c9                   	leave  
80104b68:	c3                   	ret    
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b76:	68 c0 48 11 80       	push   $0x801148c0
80104b7b:	e8 20 0f 00 00       	call   80105aa0 <release>

  if (first) {
80104b80:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	85 c0                	test   %eax,%eax
80104b8a:	75 04                	jne    80104b90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104b8c:	c9                   	leave  
80104b8d:	c3                   	ret    
80104b8e:	66 90                	xchg   %ax,%ax
    first = 0;
80104b90:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80104b97:	00 00 00 
    iinit(ROOTDEV);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	6a 01                	push   $0x1
80104b9f:	e8 9c dc ff ff       	call   80102840 <iinit>
    initlog(ROOTDEV);
80104ba4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bab:	e8 f0 f3 ff ff       	call   80103fa0 <initlog>
}
80104bb0:	83 c4 10             	add    $0x10,%esp
80104bb3:	c9                   	leave  
80104bb4:	c3                   	ret    
80104bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <pinit>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104bc6:	68 20 8f 10 80       	push   $0x80108f20
80104bcb:	68 c0 48 11 80       	push   $0x801148c0
80104bd0:	e8 5b 0d 00 00       	call   80105930 <initlock>
}
80104bd5:	83 c4 10             	add    $0x10,%esp
80104bd8:	c9                   	leave  
80104bd9:	c3                   	ret    
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104be0 <mycpu>:
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104be5:	9c                   	pushf  
80104be6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104be7:	f6 c4 02             	test   $0x2,%ah
80104bea:	75 46                	jne    80104c32 <mycpu+0x52>
  apicid = lapicid();
80104bec:	e8 df ef ff ff       	call   80103bd0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104bf1:	8b 35 24 43 11 80    	mov    0x80114324,%esi
80104bf7:	85 f6                	test   %esi,%esi
80104bf9:	7e 2a                	jle    80104c25 <mycpu+0x45>
80104bfb:	31 d2                	xor    %edx,%edx
80104bfd:	eb 08                	jmp    80104c07 <mycpu+0x27>
80104bff:	90                   	nop
80104c00:	83 c2 01             	add    $0x1,%edx
80104c03:	39 f2                	cmp    %esi,%edx
80104c05:	74 1e                	je     80104c25 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104c07:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104c0d:	0f b6 99 40 43 11 80 	movzbl -0x7feebcc0(%ecx),%ebx
80104c14:	39 c3                	cmp    %eax,%ebx
80104c16:	75 e8                	jne    80104c00 <mycpu+0x20>
}
80104c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104c1b:	8d 81 40 43 11 80    	lea    -0x7feebcc0(%ecx),%eax
}
80104c21:	5b                   	pop    %ebx
80104c22:	5e                   	pop    %esi
80104c23:	5d                   	pop    %ebp
80104c24:	c3                   	ret    
  panic("unknown apicid\n");
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	68 27 8f 10 80       	push   $0x80108f27
80104c2d:	e8 2e b8 ff ff       	call   80100460 <panic>
    panic("mycpu called with interrupts enabled\n");
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	68 2c 90 10 80       	push   $0x8010902c
80104c3a:	e8 21 b8 ff ff       	call   80100460 <panic>
80104c3f:	90                   	nop

80104c40 <cpuid>:
cpuid() {
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104c46:	e8 95 ff ff ff       	call   80104be0 <mycpu>
}
80104c4b:	c9                   	leave  
  return mycpu()-cpus;
80104c4c:	2d 40 43 11 80       	sub    $0x80114340,%eax
80104c51:	c1 f8 04             	sar    $0x4,%eax
80104c54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104c5a:	c3                   	ret    
80104c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop

80104c60 <myproc>:
myproc(void) {
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104c67:	e8 44 0d 00 00       	call   801059b0 <pushcli>
  c = mycpu();
80104c6c:	e8 6f ff ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c77:	e8 84 0d 00 00       	call   80105a00 <popcli>
}
80104c7c:	89 d8                	mov    %ebx,%eax
80104c7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c81:	c9                   	leave  
80104c82:	c3                   	ret    
80104c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <userinit>:
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104c97:	e8 f4 fd ff ff       	call   80104a90 <allocproc>
80104c9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104c9e:	a3 f4 cc 11 80       	mov    %eax,0x8011ccf4
  if((p->pgdir = setupkvm()) == 0)
80104ca3:	e8 a8 39 00 00       	call   80108650 <setupkvm>
80104ca8:	89 43 04             	mov    %eax,0x4(%ebx)
80104cab:	85 c0                	test   %eax,%eax
80104cad:	0f 84 bd 00 00 00    	je     80104d70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104cb3:	83 ec 04             	sub    $0x4,%esp
80104cb6:	68 2c 00 00 00       	push   $0x2c
80104cbb:	68 60 c4 10 80       	push   $0x8010c460
80104cc0:	50                   	push   %eax
80104cc1:	e8 3a 36 00 00       	call   80108300 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104cc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104ccf:	6a 4c                	push   $0x4c
80104cd1:	6a 00                	push   $0x0
80104cd3:	ff 73 18             	push   0x18(%ebx)
80104cd6:	e8 e5 0e 00 00       	call   80105bc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104cdb:	8b 43 18             	mov    0x18(%ebx),%eax
80104cde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104ce3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104ce6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104ceb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104cef:	8b 43 18             	mov    0x18(%ebx),%eax
80104cf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80104cf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104cfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104d01:	8b 43 18             	mov    0x18(%ebx),%eax
80104d04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104d08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104d0c:	8b 43 18             	mov    0x18(%ebx),%eax
80104d0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104d16:	8b 43 18             	mov    0x18(%ebx),%eax
80104d19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104d20:	8b 43 18             	mov    0x18(%ebx),%eax
80104d23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104d2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104d2d:	6a 10                	push   $0x10
80104d2f:	68 50 8f 10 80       	push   $0x80108f50
80104d34:	50                   	push   %eax
80104d35:	e8 46 10 00 00       	call   80105d80 <safestrcpy>
  p->cwd = namei("/");
80104d3a:	c7 04 24 59 8f 10 80 	movl   $0x80108f59,(%esp)
80104d41:	e8 3a e6 ff ff       	call   80103380 <namei>
80104d46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104d49:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104d50:	e8 ab 0d 00 00       	call   80105b00 <acquire>
  p->state = RUNNABLE;
80104d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104d5c:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104d63:	e8 38 0d 00 00       	call   80105aa0 <release>
}
80104d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d6b:	83 c4 10             	add    $0x10,%esp
80104d6e:	c9                   	leave  
80104d6f:	c3                   	ret    
    panic("userinit: out of memory?");
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 37 8f 10 80       	push   $0x80108f37
80104d78:	e8 e3 b6 ff ff       	call   80100460 <panic>
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi

80104d80 <growproc>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104d88:	e8 23 0c 00 00       	call   801059b0 <pushcli>
  c = mycpu();
80104d8d:	e8 4e fe ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d98:	e8 63 0c 00 00       	call   80105a00 <popcli>
  sz = curproc->sz;
80104d9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104d9f:	85 f6                	test   %esi,%esi
80104da1:	7f 1d                	jg     80104dc0 <growproc+0x40>
  } else if(n < 0){
80104da3:	75 3b                	jne    80104de0 <growproc+0x60>
  switchuvm(curproc);
80104da5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104da8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104daa:	53                   	push   %ebx
80104dab:	e8 40 34 00 00       	call   801081f0 <switchuvm>
  return 0;
80104db0:	83 c4 10             	add    $0x10,%esp
80104db3:	31 c0                	xor    %eax,%eax
}
80104db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db8:	5b                   	pop    %ebx
80104db9:	5e                   	pop    %esi
80104dba:	5d                   	pop    %ebp
80104dbb:	c3                   	ret    
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104dc0:	83 ec 04             	sub    $0x4,%esp
80104dc3:	01 c6                	add    %eax,%esi
80104dc5:	56                   	push   %esi
80104dc6:	50                   	push   %eax
80104dc7:	ff 73 04             	push   0x4(%ebx)
80104dca:	e8 a1 36 00 00       	call   80108470 <allocuvm>
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	75 cf                	jne    80104da5 <growproc+0x25>
      return -1;
80104dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddb:	eb d8                	jmp    80104db5 <growproc+0x35>
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104de0:	83 ec 04             	sub    $0x4,%esp
80104de3:	01 c6                	add    %eax,%esi
80104de5:	56                   	push   %esi
80104de6:	50                   	push   %eax
80104de7:	ff 73 04             	push   0x4(%ebx)
80104dea:	e8 b1 37 00 00       	call   801085a0 <deallocuvm>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	75 af                	jne    80104da5 <growproc+0x25>
80104df6:	eb de                	jmp    80104dd6 <growproc+0x56>
80104df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop

80104e00 <fork>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
80104e06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104e09:	e8 a2 0b 00 00       	call   801059b0 <pushcli>
  c = mycpu();
80104e0e:	e8 cd fd ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e19:	e8 e2 0b 00 00       	call   80105a00 <popcli>
  if((np = allocproc()) == 0){
80104e1e:	e8 6d fc ff ff       	call   80104a90 <allocproc>
80104e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104e26:	85 c0                	test   %eax,%eax
80104e28:	0f 84 b7 00 00 00    	je     80104ee5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104e2e:	83 ec 08             	sub    $0x8,%esp
80104e31:	ff 33                	push   (%ebx)
80104e33:	89 c7                	mov    %eax,%edi
80104e35:	ff 73 04             	push   0x4(%ebx)
80104e38:	e8 03 39 00 00       	call   80108740 <copyuvm>
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	89 47 04             	mov    %eax,0x4(%edi)
80104e43:	85 c0                	test   %eax,%eax
80104e45:	0f 84 a1 00 00 00    	je     80104eec <fork+0xec>
  np->sz = curproc->sz;
80104e4b:	8b 03                	mov    (%ebx),%eax
80104e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104e50:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104e52:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104e55:	89 c8                	mov    %ecx,%eax
80104e57:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104e5a:	b9 13 00 00 00       	mov    $0x13,%ecx
80104e5f:	8b 73 18             	mov    0x18(%ebx),%esi
80104e62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104e64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104e66:	8b 40 18             	mov    0x18(%eax),%eax
80104e69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104e70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104e74:	85 c0                	test   %eax,%eax
80104e76:	74 13                	je     80104e8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	50                   	push   %eax
80104e7c:	e8 ff d2 ff ff       	call   80102180 <filedup>
80104e81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104e8b:	83 c6 01             	add    $0x1,%esi
80104e8e:	83 fe 10             	cmp    $0x10,%esi
80104e91:	75 dd                	jne    80104e70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104e93:	83 ec 0c             	sub    $0xc,%esp
80104e96:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104e9c:	e8 8f db ff ff       	call   80102a30 <idup>
80104ea1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104ea4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104ea7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104eaa:	8d 47 6c             	lea    0x6c(%edi),%eax
80104ead:	6a 10                	push   $0x10
80104eaf:	53                   	push   %ebx
80104eb0:	50                   	push   %eax
80104eb1:	e8 ca 0e 00 00       	call   80105d80 <safestrcpy>
  pid = np->pid;
80104eb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104eb9:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104ec0:	e8 3b 0c 00 00       	call   80105b00 <acquire>
  np->state = RUNNABLE;
80104ec5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104ecc:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104ed3:	e8 c8 0b 00 00       	call   80105aa0 <release>
  return pid;
80104ed8:	83 c4 10             	add    $0x10,%esp
}
80104edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ede:	89 d8                	mov    %ebx,%eax
80104ee0:	5b                   	pop    %ebx
80104ee1:	5e                   	pop    %esi
80104ee2:	5f                   	pop    %edi
80104ee3:	5d                   	pop    %ebp
80104ee4:	c3                   	ret    
    return -1;
80104ee5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104eea:	eb ef                	jmp    80104edb <fork+0xdb>
    kfree(np->kstack);
80104eec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104eef:	83 ec 0c             	sub    $0xc,%esp
80104ef2:	ff 73 08             	push   0x8(%ebx)
80104ef5:	e8 a6 e8 ff ff       	call   801037a0 <kfree>
    np->kstack = 0;
80104efa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104f01:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104f04:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104f0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f10:	eb c9                	jmp    80104edb <fork+0xdb>
80104f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <scheduler>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
80104f26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104f29:	e8 b2 fc ff ff       	call   80104be0 <mycpu>
  c->proc = 0;
80104f2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104f35:	00 00 00 
  struct cpu *c = mycpu();
80104f38:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104f3a:	8d 78 04             	lea    0x4(%eax),%edi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104f40:	fb                   	sti    
    acquire(&ptable.lock);
80104f41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f44:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
    acquire(&ptable.lock);
80104f49:	68 c0 48 11 80       	push   $0x801148c0
80104f4e:	e8 ad 0b 00 00       	call   80105b00 <acquire>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104f60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104f64:	75 33                	jne    80104f99 <scheduler+0x79>
      switchuvm(p);
80104f66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104f69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104f6f:	53                   	push   %ebx
80104f70:	e8 7b 32 00 00       	call   801081f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104f75:	58                   	pop    %eax
80104f76:	5a                   	pop    %edx
80104f77:	ff 73 1c             	push   0x1c(%ebx)
80104f7a:	57                   	push   %edi
      p->state = RUNNING;
80104f7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104f82:	e8 54 0e 00 00       	call   80105ddb <swtch>
      switchkvm();
80104f87:	e8 54 32 00 00       	call   801081e0 <switchkvm>
      c->proc = 0;
80104f8c:	83 c4 10             	add    $0x10,%esp
80104f8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104f96:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f99:	81 c3 10 02 00 00    	add    $0x210,%ebx
80104f9f:	81 fb f4 cc 11 80    	cmp    $0x8011ccf4,%ebx
80104fa5:	75 b9                	jne    80104f60 <scheduler+0x40>
    release(&ptable.lock);
80104fa7:	83 ec 0c             	sub    $0xc,%esp
80104faa:	68 c0 48 11 80       	push   $0x801148c0
80104faf:	e8 ec 0a 00 00       	call   80105aa0 <release>
    sti();
80104fb4:	83 c4 10             	add    $0x10,%esp
80104fb7:	eb 87                	jmp    80104f40 <scheduler+0x20>
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fc0 <sched>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  pushcli();
80104fc5:	e8 e6 09 00 00       	call   801059b0 <pushcli>
  c = mycpu();
80104fca:	e8 11 fc ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104fcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104fd5:	e8 26 0a 00 00       	call   80105a00 <popcli>
  if(!holding(&ptable.lock))
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	68 c0 48 11 80       	push   $0x801148c0
80104fe2:	e8 79 0a 00 00       	call   80105a60 <holding>
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	85 c0                	test   %eax,%eax
80104fec:	74 4f                	je     8010503d <sched+0x7d>
  if(mycpu()->ncli != 1)
80104fee:	e8 ed fb ff ff       	call   80104be0 <mycpu>
80104ff3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104ffa:	75 68                	jne    80105064 <sched+0xa4>
  if(p->state == RUNNING)
80104ffc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105000:	74 55                	je     80105057 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105002:	9c                   	pushf  
80105003:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105004:	f6 c4 02             	test   $0x2,%ah
80105007:	75 41                	jne    8010504a <sched+0x8a>
  intena = mycpu()->intena;
80105009:	e8 d2 fb ff ff       	call   80104be0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010500e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105011:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105017:	e8 c4 fb ff ff       	call   80104be0 <mycpu>
8010501c:	83 ec 08             	sub    $0x8,%esp
8010501f:	ff 70 04             	push   0x4(%eax)
80105022:	53                   	push   %ebx
80105023:	e8 b3 0d 00 00       	call   80105ddb <swtch>
  mycpu()->intena = intena;
80105028:	e8 b3 fb ff ff       	call   80104be0 <mycpu>
}
8010502d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105030:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105036:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105039:	5b                   	pop    %ebx
8010503a:	5e                   	pop    %esi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
    panic("sched ptable.lock");
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	68 5b 8f 10 80       	push   $0x80108f5b
80105045:	e8 16 b4 ff ff       	call   80100460 <panic>
    panic("sched interruptible");
8010504a:	83 ec 0c             	sub    $0xc,%esp
8010504d:	68 87 8f 10 80       	push   $0x80108f87
80105052:	e8 09 b4 ff ff       	call   80100460 <panic>
    panic("sched running");
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	68 79 8f 10 80       	push   $0x80108f79
8010505f:	e8 fc b3 ff ff       	call   80100460 <panic>
    panic("sched locks");
80105064:	83 ec 0c             	sub    $0xc,%esp
80105067:	68 6d 8f 10 80       	push   $0x80108f6d
8010506c:	e8 ef b3 ff ff       	call   80100460 <panic>
80105071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop

80105080 <exit>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
80105086:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105089:	e8 d2 fb ff ff       	call   80104c60 <myproc>
  if(curproc == initproc)
8010508e:	39 05 f4 cc 11 80    	cmp    %eax,0x8011ccf4
80105094:	0f 84 07 01 00 00    	je     801051a1 <exit+0x121>
8010509a:	89 c3                	mov    %eax,%ebx
8010509c:	8d 70 28             	lea    0x28(%eax),%esi
8010509f:	8d 78 68             	lea    0x68(%eax),%edi
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801050a8:	8b 06                	mov    (%esi),%eax
801050aa:	85 c0                	test   %eax,%eax
801050ac:	74 12                	je     801050c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801050ae:	83 ec 0c             	sub    $0xc,%esp
801050b1:	50                   	push   %eax
801050b2:	e8 19 d1 ff ff       	call   801021d0 <fileclose>
      curproc->ofile[fd] = 0;
801050b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801050bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801050c0:	83 c6 04             	add    $0x4,%esi
801050c3:	39 f7                	cmp    %esi,%edi
801050c5:	75 e1                	jne    801050a8 <exit+0x28>
  begin_op();
801050c7:	e8 74 ef ff ff       	call   80104040 <begin_op>
  iput(curproc->cwd);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	ff 73 68             	push   0x68(%ebx)
801050d2:	e8 b9 da ff ff       	call   80102b90 <iput>
  end_op();
801050d7:	e8 d4 ef ff ff       	call   801040b0 <end_op>
  curproc->cwd = 0;
801050dc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801050e3:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801050ea:	e8 11 0a 00 00       	call   80105b00 <acquire>
  wakeup1(curproc->parent);
801050ef:	8b 53 14             	mov    0x14(%ebx),%edx
801050f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050f5:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
801050fa:	eb 10                	jmp    8010510c <exit+0x8c>
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105100:	05 10 02 00 00       	add    $0x210,%eax
80105105:	3d f4 cc 11 80       	cmp    $0x8011ccf4,%eax
8010510a:	74 1e                	je     8010512a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
8010510c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105110:	75 ee                	jne    80105100 <exit+0x80>
80105112:	3b 50 20             	cmp    0x20(%eax),%edx
80105115:	75 e9                	jne    80105100 <exit+0x80>
      p->state = RUNNABLE;
80105117:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010511e:	05 10 02 00 00       	add    $0x210,%eax
80105123:	3d f4 cc 11 80       	cmp    $0x8011ccf4,%eax
80105128:	75 e2                	jne    8010510c <exit+0x8c>
      p->parent = initproc;
8010512a:	8b 0d f4 cc 11 80    	mov    0x8011ccf4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105130:	ba f4 48 11 80       	mov    $0x801148f4,%edx
80105135:	eb 17                	jmp    8010514e <exit+0xce>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax
80105140:	81 c2 10 02 00 00    	add    $0x210,%edx
80105146:	81 fa f4 cc 11 80    	cmp    $0x8011ccf4,%edx
8010514c:	74 3a                	je     80105188 <exit+0x108>
    if(p->parent == curproc){
8010514e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105151:	75 ed                	jne    80105140 <exit+0xc0>
      if(p->state == ZOMBIE)
80105153:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105157:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010515a:	75 e4                	jne    80105140 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010515c:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
80105161:	eb 11                	jmp    80105174 <exit+0xf4>
80105163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105167:	90                   	nop
80105168:	05 10 02 00 00       	add    $0x210,%eax
8010516d:	3d f4 cc 11 80       	cmp    $0x8011ccf4,%eax
80105172:	74 cc                	je     80105140 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80105174:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105178:	75 ee                	jne    80105168 <exit+0xe8>
8010517a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010517d:	75 e9                	jne    80105168 <exit+0xe8>
      p->state = RUNNABLE;
8010517f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105186:	eb e0                	jmp    80105168 <exit+0xe8>
  curproc->state = ZOMBIE;
80105188:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010518f:	e8 2c fe ff ff       	call   80104fc0 <sched>
  panic("zombie exit");
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	68 a8 8f 10 80       	push   $0x80108fa8
8010519c:	e8 bf b2 ff ff       	call   80100460 <panic>
    panic("init exiting");
801051a1:	83 ec 0c             	sub    $0xc,%esp
801051a4:	68 9b 8f 10 80       	push   $0x80108f9b
801051a9:	e8 b2 b2 ff ff       	call   80100460 <panic>
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <wait>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
  pushcli();
801051b5:	e8 f6 07 00 00       	call   801059b0 <pushcli>
  c = mycpu();
801051ba:	e8 21 fa ff ff       	call   80104be0 <mycpu>
  p = c->proc;
801051bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801051c5:	e8 36 08 00 00       	call   80105a00 <popcli>
  acquire(&ptable.lock);
801051ca:	83 ec 0c             	sub    $0xc,%esp
801051cd:	68 c0 48 11 80       	push   $0x801148c0
801051d2:	e8 29 09 00 00       	call   80105b00 <acquire>
801051d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801051da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051dc:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
801051e1:	eb 13                	jmp    801051f6 <wait+0x46>
801051e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e7:	90                   	nop
801051e8:	81 c3 10 02 00 00    	add    $0x210,%ebx
801051ee:	81 fb f4 cc 11 80    	cmp    $0x8011ccf4,%ebx
801051f4:	74 1e                	je     80105214 <wait+0x64>
      if(p->parent != curproc)
801051f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801051f9:	75 ed                	jne    801051e8 <wait+0x38>
      if(p->state == ZOMBIE){
801051fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801051ff:	74 5f                	je     80105260 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105201:	81 c3 10 02 00 00    	add    $0x210,%ebx
      havekids = 1;
80105207:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010520c:	81 fb f4 cc 11 80    	cmp    $0x8011ccf4,%ebx
80105212:	75 e2                	jne    801051f6 <wait+0x46>
    if(!havekids || curproc->killed){
80105214:	85 c0                	test   %eax,%eax
80105216:	0f 84 9a 00 00 00    	je     801052b6 <wait+0x106>
8010521c:	8b 46 24             	mov    0x24(%esi),%eax
8010521f:	85 c0                	test   %eax,%eax
80105221:	0f 85 8f 00 00 00    	jne    801052b6 <wait+0x106>
  pushcli();
80105227:	e8 84 07 00 00       	call   801059b0 <pushcli>
  c = mycpu();
8010522c:	e8 af f9 ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80105231:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105237:	e8 c4 07 00 00       	call   80105a00 <popcli>
  if(p == 0)
8010523c:	85 db                	test   %ebx,%ebx
8010523e:	0f 84 89 00 00 00    	je     801052cd <wait+0x11d>
  p->chan = chan;
80105244:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105247:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010524e:	e8 6d fd ff ff       	call   80104fc0 <sched>
  p->chan = 0;
80105253:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010525a:	e9 7b ff ff ff       	jmp    801051da <wait+0x2a>
8010525f:	90                   	nop
        kfree(p->kstack);
80105260:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105263:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105266:	ff 73 08             	push   0x8(%ebx)
80105269:	e8 32 e5 ff ff       	call   801037a0 <kfree>
        p->kstack = 0;
8010526e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105275:	5a                   	pop    %edx
80105276:	ff 73 04             	push   0x4(%ebx)
80105279:	e8 52 33 00 00       	call   801085d0 <freevm>
        p->pid = 0;
8010527e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105285:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010528c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105290:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105297:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010529e:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801052a5:	e8 f6 07 00 00       	call   80105aa0 <release>
        return pid;
801052aa:	83 c4 10             	add    $0x10,%esp
}
801052ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b0:	89 f0                	mov    %esi,%eax
801052b2:	5b                   	pop    %ebx
801052b3:	5e                   	pop    %esi
801052b4:	5d                   	pop    %ebp
801052b5:	c3                   	ret    
      release(&ptable.lock);
801052b6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801052b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801052be:	68 c0 48 11 80       	push   $0x801148c0
801052c3:	e8 d8 07 00 00       	call   80105aa0 <release>
      return -1;
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	eb e0                	jmp    801052ad <wait+0xfd>
    panic("sleep");
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	68 b4 8f 10 80       	push   $0x80108fb4
801052d5:	e8 86 b1 ff ff       	call   80100460 <panic>
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052e0 <yield>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801052e7:	68 c0 48 11 80       	push   $0x801148c0
801052ec:	e8 0f 08 00 00       	call   80105b00 <acquire>
  pushcli();
801052f1:	e8 ba 06 00 00       	call   801059b0 <pushcli>
  c = mycpu();
801052f6:	e8 e5 f8 ff ff       	call   80104be0 <mycpu>
  p = c->proc;
801052fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105301:	e8 fa 06 00 00       	call   80105a00 <popcli>
  myproc()->state = RUNNABLE;
80105306:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010530d:	e8 ae fc ff ff       	call   80104fc0 <sched>
  release(&ptable.lock);
80105312:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80105319:	e8 82 07 00 00       	call   80105aa0 <release>
}
8010531e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	c9                   	leave  
80105325:	c3                   	ret    
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi

80105330 <sleep>:
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
80105335:	53                   	push   %ebx
80105336:	83 ec 0c             	sub    $0xc,%esp
80105339:	8b 7d 08             	mov    0x8(%ebp),%edi
8010533c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010533f:	e8 6c 06 00 00       	call   801059b0 <pushcli>
  c = mycpu();
80105344:	e8 97 f8 ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80105349:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010534f:	e8 ac 06 00 00       	call   80105a00 <popcli>
  if(p == 0)
80105354:	85 db                	test   %ebx,%ebx
80105356:	0f 84 87 00 00 00    	je     801053e3 <sleep+0xb3>
  if(lk == 0)
8010535c:	85 f6                	test   %esi,%esi
8010535e:	74 76                	je     801053d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105360:	81 fe c0 48 11 80    	cmp    $0x801148c0,%esi
80105366:	74 50                	je     801053b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105368:	83 ec 0c             	sub    $0xc,%esp
8010536b:	68 c0 48 11 80       	push   $0x801148c0
80105370:	e8 8b 07 00 00       	call   80105b00 <acquire>
    release(lk);
80105375:	89 34 24             	mov    %esi,(%esp)
80105378:	e8 23 07 00 00       	call   80105aa0 <release>
  p->chan = chan;
8010537d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105380:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105387:	e8 34 fc ff ff       	call   80104fc0 <sched>
  p->chan = 0;
8010538c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105393:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
8010539a:	e8 01 07 00 00       	call   80105aa0 <release>
    acquire(lk);
8010539f:	89 75 08             	mov    %esi,0x8(%ebp)
801053a2:	83 c4 10             	add    $0x10,%esp
}
801053a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a8:	5b                   	pop    %ebx
801053a9:	5e                   	pop    %esi
801053aa:	5f                   	pop    %edi
801053ab:	5d                   	pop    %ebp
    acquire(lk);
801053ac:	e9 4f 07 00 00       	jmp    80105b00 <acquire>
801053b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801053b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801053bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801053c2:	e8 f9 fb ff ff       	call   80104fc0 <sched>
  p->chan = 0;
801053c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801053ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d1:	5b                   	pop    %ebx
801053d2:	5e                   	pop    %esi
801053d3:	5f                   	pop    %edi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
    panic("sleep without lk");
801053d6:	83 ec 0c             	sub    $0xc,%esp
801053d9:	68 ba 8f 10 80       	push   $0x80108fba
801053de:	e8 7d b0 ff ff       	call   80100460 <panic>
    panic("sleep");
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	68 b4 8f 10 80       	push   $0x80108fb4
801053eb:	e8 70 b0 ff ff       	call   80100460 <panic>

801053f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	53                   	push   %ebx
801053f4:	83 ec 10             	sub    $0x10,%esp
801053f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801053fa:	68 c0 48 11 80       	push   $0x801148c0
801053ff:	e8 fc 06 00 00       	call   80105b00 <acquire>
80105404:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105407:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
8010540c:	eb 0e                	jmp    8010541c <wakeup+0x2c>
8010540e:	66 90                	xchg   %ax,%ax
80105410:	05 10 02 00 00       	add    $0x210,%eax
80105415:	3d f4 cc 11 80       	cmp    $0x8011ccf4,%eax
8010541a:	74 1e                	je     8010543a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010541c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105420:	75 ee                	jne    80105410 <wakeup+0x20>
80105422:	3b 58 20             	cmp    0x20(%eax),%ebx
80105425:	75 e9                	jne    80105410 <wakeup+0x20>
      p->state = RUNNABLE;
80105427:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010542e:	05 10 02 00 00       	add    $0x210,%eax
80105433:	3d f4 cc 11 80       	cmp    $0x8011ccf4,%eax
80105438:	75 e2                	jne    8010541c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010543a:	c7 45 08 c0 48 11 80 	movl   $0x801148c0,0x8(%ebp)
}
80105441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105444:	c9                   	leave  
  release(&ptable.lock);
80105445:	e9 56 06 00 00       	jmp    80105aa0 <release>
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105450 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 10             	sub    $0x10,%esp
80105457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010545a:	68 c0 48 11 80       	push   $0x801148c0
8010545f:	e8 9c 06 00 00       	call   80105b00 <acquire>
80105464:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105467:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
8010546c:	eb 0e                	jmp    8010547c <kill+0x2c>
8010546e:	66 90                	xchg   %ax,%ax
80105470:	05 10 02 00 00       	add    $0x210,%eax
80105475:	3d f4 cc 11 80       	cmp    $0x8011ccf4,%eax
8010547a:	74 34                	je     801054b0 <kill+0x60>
    if(p->pid == pid){
8010547c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010547f:	75 ef                	jne    80105470 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105481:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105485:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010548c:	75 07                	jne    80105495 <kill+0x45>
        p->state = RUNNABLE;
8010548e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	68 c0 48 11 80       	push   $0x801148c0
8010549d:	e8 fe 05 00 00       	call   80105aa0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801054a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801054a5:	83 c4 10             	add    $0x10,%esp
801054a8:	31 c0                	xor    %eax,%eax
}
801054aa:	c9                   	leave  
801054ab:	c3                   	ret    
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	68 c0 48 11 80       	push   $0x801148c0
801054b8:	e8 e3 05 00 00       	call   80105aa0 <release>
}
801054bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054c8:	c9                   	leave  
801054c9:	c3                   	ret    
801054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801054d8:	53                   	push   %ebx
801054d9:	bb 60 49 11 80       	mov    $0x80114960,%ebx
801054de:	83 ec 3c             	sub    $0x3c,%esp
801054e1:	eb 27                	jmp    8010550a <procdump+0x3a>
801054e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054e7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801054e8:	83 ec 0c             	sub    $0xc,%esp
801054eb:	68 ed 8f 10 80       	push   $0x80108fed
801054f0:	e8 eb b2 ff ff       	call   801007e0 <cprintf>
801054f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054f8:	81 c3 10 02 00 00    	add    $0x210,%ebx
801054fe:	81 fb 60 cd 11 80    	cmp    $0x8011cd60,%ebx
80105504:	0f 84 7e 00 00 00    	je     80105588 <procdump+0xb8>
    if(p->state == UNUSED)
8010550a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010550d:	85 c0                	test   %eax,%eax
8010550f:	74 e7                	je     801054f8 <procdump+0x28>
      state = "???";
80105511:	ba cb 8f 10 80       	mov    $0x80108fcb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105516:	83 f8 05             	cmp    $0x5,%eax
80105519:	77 11                	ja     8010552c <procdump+0x5c>
8010551b:	8b 14 85 88 90 10 80 	mov    -0x7fef6f78(,%eax,4),%edx
      state = "???";
80105522:	b8 cb 8f 10 80       	mov    $0x80108fcb,%eax
80105527:	85 d2                	test   %edx,%edx
80105529:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010552c:	53                   	push   %ebx
8010552d:	52                   	push   %edx
8010552e:	ff 73 a4             	push   -0x5c(%ebx)
80105531:	68 cf 8f 10 80       	push   $0x80108fcf
80105536:	e8 a5 b2 ff ff       	call   801007e0 <cprintf>
    if(p->state == SLEEPING){
8010553b:	83 c4 10             	add    $0x10,%esp
8010553e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105542:	75 a4                	jne    801054e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010554a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010554d:	50                   	push   %eax
8010554e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105551:	8b 40 0c             	mov    0xc(%eax),%eax
80105554:	83 c0 08             	add    $0x8,%eax
80105557:	50                   	push   %eax
80105558:	e8 f3 03 00 00       	call   80105950 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	8b 17                	mov    (%edi),%edx
80105562:	85 d2                	test   %edx,%edx
80105564:	74 82                	je     801054e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105566:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105569:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010556c:	52                   	push   %edx
8010556d:	68 e1 89 10 80       	push   $0x801089e1
80105572:	e8 69 b2 ff ff       	call   801007e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105577:	83 c4 10             	add    $0x10,%esp
8010557a:	39 fe                	cmp    %edi,%esi
8010557c:	75 e2                	jne    80105560 <procdump+0x90>
8010557e:	e9 65 ff ff ff       	jmp    801054e8 <procdump+0x18>
80105583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105587:	90                   	nop
  }
}
80105588:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010558b:	5b                   	pop    %ebx
8010558c:	5e                   	pop    %esi
8010558d:	5f                   	pop    %edi
8010558e:	5d                   	pop    %ebp
8010558f:	c3                   	ret    

80105590 <sort_uniqe_procces>:

int sort_uniqe_procces(int pid)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
  struct proc *p;
  int i, j;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105595:	be f4 48 11 80       	mov    $0x801148f4,%esi
{
8010559a:	53                   	push   %ebx
8010559b:	83 ec 1c             	sub    $0x1c,%esp
8010559e:	8b 45 08             	mov    0x8(%ebp),%eax
801055a1:	eb 17                	jmp    801055ba <sort_uniqe_procces+0x2a>
801055a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a7:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801055a8:	81 c6 10 02 00 00    	add    $0x210,%esi
801055ae:	81 fe f4 cc 11 80    	cmp    $0x8011ccf4,%esi
801055b4:	0f 84 a7 00 00 00    	je     80105661 <sort_uniqe_procces+0xd1>
  {
    if (p->pid == pid)
801055ba:	39 46 10             	cmp    %eax,0x10(%esi)
801055bd:	75 e9                	jne    801055a8 <sort_uniqe_procces+0x18>
    {
   
      for (i = 0; i < p->numsystemcalls - 1; i++)
801055bf:	8b 86 0c 02 00 00    	mov    0x20c(%esi),%eax
801055c5:	8d 78 ff             	lea    -0x1(%eax),%edi
801055c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801055cb:	89 7d e0             	mov    %edi,-0x20(%ebp)
801055ce:	85 ff                	test   %edi,%edi
801055d0:	7e 46                	jle    80105618 <sort_uniqe_procces+0x88>
801055d2:	8d 7c 86 7c          	lea    0x7c(%esi,%eax,4),%edi
801055d6:	31 c0                	xor    %eax,%eax
801055d8:	89 75 dc             	mov    %esi,-0x24(%ebp)
801055db:	8d 9e 80 00 00 00    	lea    0x80(%esi),%ebx
801055e1:	89 c6                	mov    %eax,%esi
801055e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e7:	90                   	nop
      {
        for (j = i + 1; j < p->numsystemcalls; j++)
801055e8:	83 c6 01             	add    $0x1,%esi
801055eb:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801055ee:	7d 1d                	jge    8010560d <sort_uniqe_procces+0x7d>
801055f0:	89 d8                	mov    %ebx,%eax
801055f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        {
          if (p->systemcalls[i] > p->systemcalls[j])
801055f8:	8b 53 fc             	mov    -0x4(%ebx),%edx
801055fb:	8b 08                	mov    (%eax),%ecx
801055fd:	39 ca                	cmp    %ecx,%edx
801055ff:	7e 05                	jle    80105606 <sort_uniqe_procces+0x76>
          {
            
            int temp = p->systemcalls[i];
            p->systemcalls[i] = p->systemcalls[j];
80105601:	89 4b fc             	mov    %ecx,-0x4(%ebx)
            p->systemcalls[j] = temp;
80105604:	89 10                	mov    %edx,(%eax)
        for (j = i + 1; j < p->numsystemcalls; j++)
80105606:	83 c0 04             	add    $0x4,%eax
80105609:	39 f8                	cmp    %edi,%eax
8010560b:	75 eb                	jne    801055f8 <sort_uniqe_procces+0x68>
      for (i = 0; i < p->numsystemcalls - 1; i++)
8010560d:	83 c3 04             	add    $0x4,%ebx
80105610:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80105613:	75 d3                	jne    801055e8 <sort_uniqe_procces+0x58>
80105615:	8b 75 dc             	mov    -0x24(%ebp),%esi
          }
        }
      }
      for (i = 0; i < p->numsystemcalls; i++)
80105618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010561b:	85 c0                	test   %eax,%eax
8010561d:	7e 28                	jle    80105647 <sort_uniqe_procces+0xb7>
8010561f:	31 db                	xor    %ebx,%ebx
80105621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      { 
        cprintf("%d ", p->systemcalls[i]);
80105628:	83 ec 08             	sub    $0x8,%esp
8010562b:	ff 74 9e 7c          	push   0x7c(%esi,%ebx,4)
      for (i = 0; i < p->numsystemcalls; i++)
8010562f:	83 c3 01             	add    $0x1,%ebx
        cprintf("%d ", p->systemcalls[i]);
80105632:	68 d8 8f 10 80       	push   $0x80108fd8
80105637:	e8 a4 b1 ff ff       	call   801007e0 <cprintf>
      for (i = 0; i < p->numsystemcalls; i++)
8010563c:	83 c4 10             	add    $0x10,%esp
8010563f:	39 9e 0c 02 00 00    	cmp    %ebx,0x20c(%esi)
80105645:	7f e1                	jg     80105628 <sort_uniqe_procces+0x98>
      }
      cprintf("\n");
80105647:	83 ec 0c             	sub    $0xc,%esp
8010564a:	68 ed 8f 10 80       	push   $0x80108fed
8010564f:	e8 8c b1 ff ff       	call   801007e0 <cprintf>

      return 0; 
80105654:	83 c4 10             	add    $0x10,%esp
    }
  }
  return -1;
}
80105657:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0; 
8010565a:	31 c0                	xor    %eax,%eax
}
8010565c:	5b                   	pop    %ebx
8010565d:	5e                   	pop    %esi
8010565e:	5f                   	pop    %edi
8010565f:	5d                   	pop    %ebp
80105660:	c3                   	ret    
80105661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5f                   	pop    %edi
8010566c:	5d                   	pop    %ebp
8010566d:	c3                   	ret    
8010566e:	66 90                	xchg   %ax,%ax

80105670 <get_max_invoked>:
int get_max_invoked(int pid)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
  struct proc *p;
  int i, j;
  struct proc* target_p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105675:	be f4 48 11 80       	mov    $0x801148f4,%esi
{
8010567a:	53                   	push   %ebx
8010567b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
80105681:	8b 45 08             	mov    0x8(%ebp),%eax
80105684:	eb 1c                	jmp    801056a2 <get_max_invoked+0x32>
80105686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105690:	81 c6 10 02 00 00    	add    $0x210,%esi
80105696:	81 fe f4 cc 11 80    	cmp    $0x8011ccf4,%esi
8010569c:	0f 84 23 01 00 00    	je     801057c5 <get_max_invoked+0x155>
  {
    if (p->pid == pid)
801056a2:	39 46 10             	cmp    %eax,0x10(%esi)
801056a5:	75 e9                	jne    80105690 <get_max_invoked+0x20>
    {
      target_p=p;
   
      for (i = 0; i < p->numsystemcalls - 1; i++)
801056a7:	8b 86 0c 02 00 00    	mov    0x20c(%esi),%eax
801056ad:	8d 78 ff             	lea    -0x1(%eax),%edi
801056b0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
801056b6:	89 bd 64 ff ff ff    	mov    %edi,-0x9c(%ebp)
801056bc:	85 ff                	test   %edi,%edi
801056be:	7e 4e                	jle    8010570e <get_max_invoked+0x9e>
801056c0:	8d 7c 86 7c          	lea    0x7c(%esi,%eax,4),%edi
801056c4:	31 c0                	xor    %eax,%eax
801056c6:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
801056cc:	8d 9e 80 00 00 00    	lea    0x80(%esi),%ebx
801056d2:	89 c6                	mov    %eax,%esi
801056d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      {
        for (j = i + 1; j < p->numsystemcalls; j++)
801056d8:	83 c6 01             	add    $0x1,%esi
801056db:	39 b5 60 ff ff ff    	cmp    %esi,-0xa0(%ebp)
801056e1:	7e 1a                	jle    801056fd <get_max_invoked+0x8d>
801056e3:	89 d8                	mov    %ebx,%eax
801056e5:	8d 76 00             	lea    0x0(%esi),%esi
        {
          if (p->systemcalls[i] > p->systemcalls[j])
801056e8:	8b 53 fc             	mov    -0x4(%ebx),%edx
801056eb:	8b 08                	mov    (%eax),%ecx
801056ed:	39 ca                	cmp    %ecx,%edx
801056ef:	7e 05                	jle    801056f6 <get_max_invoked+0x86>
          {
            
            int temp = p->systemcalls[i];
            p->systemcalls[i] = p->systemcalls[j];
801056f1:	89 4b fc             	mov    %ecx,-0x4(%ebx)
            p->systemcalls[j] = temp;
801056f4:	89 10                	mov    %edx,(%eax)
        for (j = i + 1; j < p->numsystemcalls; j++)
801056f6:	83 c0 04             	add    $0x4,%eax
801056f9:	39 f8                	cmp    %edi,%eax
801056fb:	75 eb                	jne    801056e8 <get_max_invoked+0x78>
      for (i = 0; i < p->numsystemcalls - 1; i++)
801056fd:	83 c3 04             	add    $0x4,%ebx
80105700:	39 b5 64 ff ff ff    	cmp    %esi,-0x9c(%ebp)
80105706:	75 d0                	jne    801056d8 <get_max_invoked+0x68>
80105708:	8b b5 5c ff ff ff    	mov    -0xa4(%ebp),%esi
          }
        }
      }
     int count[30];
     memset(count,0,30);
8010570e:	83 ec 04             	sub    $0x4,%esp
80105711:	8d 9d 70 ff ff ff    	lea    -0x90(%ebp),%ebx
80105717:	8d 7d e8             	lea    -0x18(%ebp),%edi
8010571a:	6a 1e                	push   $0x1e
8010571c:	6a 00                	push   $0x0
8010571e:	53                   	push   %ebx
8010571f:	e8 9c 04 00 00       	call   80105bc0 <memset>
     for(int i=0;i<30;i++){
80105724:	89 d9                	mov    %ebx,%ecx
80105726:	83 c4 10             	add    $0x10,%esp
     memset(count,0,30);
80105729:	89 d8                	mov    %ebx,%eax
8010572b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
      count[i]=0;
80105730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     for(int i=0;i<30;i++){
80105736:	83 c0 04             	add    $0x4,%eax
80105739:	39 f8                	cmp    %edi,%eax
8010573b:	75 f3                	jne    80105730 <get_max_invoked+0xc0>
     // cprintf("%d \n",count[i]);
      
     }
     
     for (int i=0;i<target_p->numsystemcalls;i++){
8010573d:	8b 86 0c 02 00 00    	mov    0x20c(%esi),%eax
80105743:	85 c0                	test   %eax,%eax
80105745:	7e 1a                	jle    80105761 <get_max_invoked+0xf1>
80105747:	83 c6 7c             	add    $0x7c,%esi
8010574a:	8d 14 86             	lea    (%esi,%eax,4),%edx
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
      count[target_p->systemcalls[i]]++;
80105750:	8b 06                	mov    (%esi),%eax
     for (int i=0;i<target_p->numsystemcalls;i++){
80105752:	83 c6 04             	add    $0x4,%esi
      count[target_p->systemcalls[i]]++;
80105755:	83 84 85 70 ff ff ff 	addl   $0x1,-0x90(%ebp,%eax,4)
8010575c:	01 
     for (int i=0;i<target_p->numsystemcalls;i++){
8010575d:	39 d6                	cmp    %edx,%esi
8010575f:	75 ef                	jne    80105750 <get_max_invoked+0xe0>
     }
     int max=-1;
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576d:	8d 76 00             	lea    0x0(%esi),%esi
     int max_index=-1;

     for(int i=0;i<30;i++){
     if(count[i]>=max && count[i]!=0){
80105770:	8b 11                	mov    (%ecx),%edx
80105772:	89 c6                	mov    %eax,%esi
80105774:	39 c2                	cmp    %eax,%edx
80105776:	0f 4d c2             	cmovge %edx,%eax
80105779:	85 d2                	test   %edx,%edx
8010577b:	0f 44 c6             	cmove  %esi,%eax
     for(int i=0;i<30;i++){
8010577e:	83 c1 04             	add    $0x4,%ecx
80105781:	39 f9                	cmp    %edi,%ecx
80105783:	75 eb                	jne    80105770 <get_max_invoked+0x100>
     }
     if(max==-1){
      cprintf("no syscall found \n");
      return -1;
     }
        for(int i=0;i<30;i++){
80105785:	31 f6                	xor    %esi,%esi
     if(max==-1){
80105787:	83 f8 ff             	cmp    $0xffffffff,%eax
8010578a:	75 0c                	jne    80105798 <get_max_invoked+0x128>
8010578c:	eb 56                	jmp    801057e4 <get_max_invoked+0x174>
8010578e:	66 90                	xchg   %ax,%ax
        for(int i=0;i<30;i++){
80105790:	83 c6 01             	add    $0x1,%esi
80105793:	83 fe 1e             	cmp    $0x1e,%esi
80105796:	74 21                	je     801057b9 <get_max_invoked+0x149>
     if(count[i]==max){
80105798:	39 04 b3             	cmp    %eax,(%ebx,%esi,4)
8010579b:	75 f3                	jne    80105790 <get_max_invoked+0x120>
       cprintf("num of the system call is %d and it invoked is %d \n",i,count[i]);
8010579d:	83 ec 04             	sub    $0x4,%esp
801057a0:	50                   	push   %eax
801057a1:	56                   	push   %esi
801057a2:	68 54 90 10 80       	push   $0x80109054
801057a7:	e8 34 b0 ff ff       	call   801007e0 <cprintf>
       return  i;
801057ac:	83 c4 10             	add    $0x10,%esp
      return 0; 
    }
  }
  cprintf("Pid not found \n");
  return -1;
801057af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b2:	89 f0                	mov    %esi,%eax
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0; 
801057bc:	31 f6                	xor    %esi,%esi
801057be:	5b                   	pop    %ebx
801057bf:	89 f0                	mov    %esi,%eax
801057c1:	5e                   	pop    %esi
801057c2:	5f                   	pop    %edi
801057c3:	5d                   	pop    %ebp
801057c4:	c3                   	ret    
  cprintf("Pid not found \n");
801057c5:	83 ec 0c             	sub    $0xc,%esp
  return -1;
801057c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
  cprintf("Pid not found \n");
801057cd:	68 ef 8f 10 80       	push   $0x80108fef
801057d2:	e8 09 b0 ff ff       	call   801007e0 <cprintf>
  return -1;
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057dd:	89 f0                	mov    %esi,%eax
801057df:	5b                   	pop    %ebx
801057e0:	5e                   	pop    %esi
801057e1:	5f                   	pop    %edi
801057e2:	5d                   	pop    %ebp
801057e3:	c3                   	ret    
      cprintf("no syscall found \n");
801057e4:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801057e7:	be ff ff ff ff       	mov    $0xffffffff,%esi
      cprintf("no syscall found \n");
801057ec:	68 dc 8f 10 80       	push   $0x80108fdc
801057f1:	e8 ea af ff ff       	call   801007e0 <cprintf>
      return -1;
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	eb b4                	jmp    801057af <get_max_invoked+0x13f>
801057fb:	66 90                	xchg   %ax,%ax
801057fd:	66 90                	xchg   %ax,%ax
801057ff:	90                   	nop

80105800 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	53                   	push   %ebx
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010580a:	68 a0 90 10 80       	push   $0x801090a0
8010580f:	8d 43 04             	lea    0x4(%ebx),%eax
80105812:	50                   	push   %eax
80105813:	e8 18 01 00 00       	call   80105930 <initlock>
  lk->name = name;
80105818:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010581b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105821:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105824:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010582b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010582e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105831:	c9                   	leave  
80105832:	c3                   	ret    
80105833:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	56                   	push   %esi
80105844:	53                   	push   %ebx
80105845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105848:	8d 73 04             	lea    0x4(%ebx),%esi
8010584b:	83 ec 0c             	sub    $0xc,%esp
8010584e:	56                   	push   %esi
8010584f:	e8 ac 02 00 00       	call   80105b00 <acquire>
  while (lk->locked) {
80105854:	8b 13                	mov    (%ebx),%edx
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 d2                	test   %edx,%edx
8010585b:	74 16                	je     80105873 <acquiresleep+0x33>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	e8 c6 fa ff ff       	call   80105330 <sleep>
  while (lk->locked) {
8010586a:	8b 03                	mov    (%ebx),%eax
8010586c:	83 c4 10             	add    $0x10,%esp
8010586f:	85 c0                	test   %eax,%eax
80105871:	75 ed                	jne    80105860 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105873:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105879:	e8 e2 f3 ff ff       	call   80104c60 <myproc>
8010587e:	8b 40 10             	mov    0x10(%eax),%eax
80105881:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105884:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105887:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010588a:	5b                   	pop    %ebx
8010588b:	5e                   	pop    %esi
8010588c:	5d                   	pop    %ebp
  release(&lk->lk);
8010588d:	e9 0e 02 00 00       	jmp    80105aa0 <release>
80105892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
801058a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801058a8:	8d 73 04             	lea    0x4(%ebx),%esi
801058ab:	83 ec 0c             	sub    $0xc,%esp
801058ae:	56                   	push   %esi
801058af:	e8 4c 02 00 00       	call   80105b00 <acquire>
  lk->locked = 0;
801058b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801058ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801058c1:	89 1c 24             	mov    %ebx,(%esp)
801058c4:	e8 27 fb ff ff       	call   801053f0 <wakeup>
  release(&lk->lk);
801058c9:	89 75 08             	mov    %esi,0x8(%ebp)
801058cc:	83 c4 10             	add    $0x10,%esp
}
801058cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d2:	5b                   	pop    %ebx
801058d3:	5e                   	pop    %esi
801058d4:	5d                   	pop    %ebp
  release(&lk->lk);
801058d5:	e9 c6 01 00 00       	jmp    80105aa0 <release>
801058da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	31 ff                	xor    %edi,%edi
801058e6:	56                   	push   %esi
801058e7:	53                   	push   %ebx
801058e8:	83 ec 18             	sub    $0x18,%esp
801058eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801058ee:	8d 73 04             	lea    0x4(%ebx),%esi
801058f1:	56                   	push   %esi
801058f2:	e8 09 02 00 00       	call   80105b00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801058f7:	8b 03                	mov    (%ebx),%eax
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	85 c0                	test   %eax,%eax
801058fe:	75 18                	jne    80105918 <holdingsleep+0x38>
  release(&lk->lk);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	56                   	push   %esi
80105904:	e8 97 01 00 00       	call   80105aa0 <release>
  return r;
}
80105909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010590c:	89 f8                	mov    %edi,%eax
8010590e:	5b                   	pop    %ebx
8010590f:	5e                   	pop    %esi
80105910:	5f                   	pop    %edi
80105911:	5d                   	pop    %ebp
80105912:	c3                   	ret    
80105913:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105917:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105918:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010591b:	e8 40 f3 ff ff       	call   80104c60 <myproc>
80105920:	39 58 10             	cmp    %ebx,0x10(%eax)
80105923:	0f 94 c0             	sete   %al
80105926:	0f b6 c0             	movzbl %al,%eax
80105929:	89 c7                	mov    %eax,%edi
8010592b:	eb d3                	jmp    80105900 <holdingsleep+0x20>
8010592d:	66 90                	xchg   %ax,%ax
8010592f:	90                   	nop

80105930 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105936:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105939:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010593f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105942:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105949:	5d                   	pop    %ebp
8010594a:	c3                   	ret    
8010594b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop

80105950 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105950:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105951:	31 d2                	xor    %edx,%edx
{
80105953:	89 e5                	mov    %esp,%ebp
80105955:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105956:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010595c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010595f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105960:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105966:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010596c:	77 1a                	ja     80105988 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010596e:	8b 58 04             	mov    0x4(%eax),%ebx
80105971:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105974:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105977:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105979:	83 fa 0a             	cmp    $0xa,%edx
8010597c:	75 e2                	jne    80105960 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010597e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105981:	c9                   	leave  
80105982:	c3                   	ret    
80105983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105987:	90                   	nop
  for(; i < 10; i++)
80105988:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010598b:	8d 51 28             	lea    0x28(%ecx),%edx
8010598e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105996:	83 c0 04             	add    $0x4,%eax
80105999:	39 d0                	cmp    %edx,%eax
8010599b:	75 f3                	jne    80105990 <getcallerpcs+0x40>
}
8010599d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a0:	c9                   	leave  
801059a1:	c3                   	ret    
801059a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 04             	sub    $0x4,%esp
801059b7:	9c                   	pushf  
801059b8:	5b                   	pop    %ebx
  asm volatile("cli");
801059b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801059ba:	e8 21 f2 ff ff       	call   80104be0 <mycpu>
801059bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801059c5:	85 c0                	test   %eax,%eax
801059c7:	74 17                	je     801059e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801059c9:	e8 12 f2 ff ff       	call   80104be0 <mycpu>
801059ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801059d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059d8:	c9                   	leave  
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801059e0:	e8 fb f1 ff ff       	call   80104be0 <mycpu>
801059e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801059eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801059f1:	eb d6                	jmp    801059c9 <pushcli+0x19>
801059f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a00 <popcli>:

void
popcli(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105a06:	9c                   	pushf  
80105a07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105a08:	f6 c4 02             	test   $0x2,%ah
80105a0b:	75 35                	jne    80105a42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105a0d:	e8 ce f1 ff ff       	call   80104be0 <mycpu>
80105a12:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105a19:	78 34                	js     80105a4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105a1b:	e8 c0 f1 ff ff       	call   80104be0 <mycpu>
80105a20:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105a26:	85 d2                	test   %edx,%edx
80105a28:	74 06                	je     80105a30 <popcli+0x30>
    sti();
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105a30:	e8 ab f1 ff ff       	call   80104be0 <mycpu>
80105a35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	74 eb                	je     80105a2a <popcli+0x2a>
  asm volatile("sti");
80105a3f:	fb                   	sti    
}
80105a40:	c9                   	leave  
80105a41:	c3                   	ret    
    panic("popcli - interruptible");
80105a42:	83 ec 0c             	sub    $0xc,%esp
80105a45:	68 ab 90 10 80       	push   $0x801090ab
80105a4a:	e8 11 aa ff ff       	call   80100460 <panic>
    panic("popcli");
80105a4f:	83 ec 0c             	sub    $0xc,%esp
80105a52:	68 c2 90 10 80       	push   $0x801090c2
80105a57:	e8 04 aa ff ff       	call   80100460 <panic>
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <holding>:
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	56                   	push   %esi
80105a64:	53                   	push   %ebx
80105a65:	8b 75 08             	mov    0x8(%ebp),%esi
80105a68:	31 db                	xor    %ebx,%ebx
  pushcli();
80105a6a:	e8 41 ff ff ff       	call   801059b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105a6f:	8b 06                	mov    (%esi),%eax
80105a71:	85 c0                	test   %eax,%eax
80105a73:	75 0b                	jne    80105a80 <holding+0x20>
  popcli();
80105a75:	e8 86 ff ff ff       	call   80105a00 <popcli>
}
80105a7a:	89 d8                	mov    %ebx,%eax
80105a7c:	5b                   	pop    %ebx
80105a7d:	5e                   	pop    %esi
80105a7e:	5d                   	pop    %ebp
80105a7f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105a80:	8b 5e 08             	mov    0x8(%esi),%ebx
80105a83:	e8 58 f1 ff ff       	call   80104be0 <mycpu>
80105a88:	39 c3                	cmp    %eax,%ebx
80105a8a:	0f 94 c3             	sete   %bl
  popcli();
80105a8d:	e8 6e ff ff ff       	call   80105a00 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105a92:	0f b6 db             	movzbl %bl,%ebx
}
80105a95:	89 d8                	mov    %ebx,%eax
80105a97:	5b                   	pop    %ebx
80105a98:	5e                   	pop    %esi
80105a99:	5d                   	pop    %ebp
80105a9a:	c3                   	ret    
80105a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop

80105aa0 <release>:
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	56                   	push   %esi
80105aa4:	53                   	push   %ebx
80105aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105aa8:	e8 03 ff ff ff       	call   801059b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105aad:	8b 03                	mov    (%ebx),%eax
80105aaf:	85 c0                	test   %eax,%eax
80105ab1:	75 15                	jne    80105ac8 <release+0x28>
  popcli();
80105ab3:	e8 48 ff ff ff       	call   80105a00 <popcli>
    panic("release");
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	68 c9 90 10 80       	push   $0x801090c9
80105ac0:	e8 9b a9 ff ff       	call   80100460 <panic>
80105ac5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105ac8:	8b 73 08             	mov    0x8(%ebx),%esi
80105acb:	e8 10 f1 ff ff       	call   80104be0 <mycpu>
80105ad0:	39 c6                	cmp    %eax,%esi
80105ad2:	75 df                	jne    80105ab3 <release+0x13>
  popcli();
80105ad4:	e8 27 ff ff ff       	call   80105a00 <popcli>
  lk->pcs[0] = 0;
80105ad9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105ae0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105ae7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105aec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105af2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105af5:	5b                   	pop    %ebx
80105af6:	5e                   	pop    %esi
80105af7:	5d                   	pop    %ebp
  popcli();
80105af8:	e9 03 ff ff ff       	jmp    80105a00 <popcli>
80105afd:	8d 76 00             	lea    0x0(%esi),%esi

80105b00 <acquire>:
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
80105b04:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105b07:	e8 a4 fe ff ff       	call   801059b0 <pushcli>
  if(holding(lk))
80105b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105b0f:	e8 9c fe ff ff       	call   801059b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105b14:	8b 03                	mov    (%ebx),%eax
80105b16:	85 c0                	test   %eax,%eax
80105b18:	75 7e                	jne    80105b98 <acquire+0x98>
  popcli();
80105b1a:	e8 e1 fe ff ff       	call   80105a00 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80105b1f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105b28:	8b 55 08             	mov    0x8(%ebp),%edx
80105b2b:	89 c8                	mov    %ecx,%eax
80105b2d:	f0 87 02             	lock xchg %eax,(%edx)
80105b30:	85 c0                	test   %eax,%eax
80105b32:	75 f4                	jne    80105b28 <acquire+0x28>
  __sync_synchronize();
80105b34:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105b3c:	e8 9f f0 ff ff       	call   80104be0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105b41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105b44:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105b46:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105b49:	31 c0                	xor    %eax,%eax
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105b50:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105b56:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105b5c:	77 1a                	ja     80105b78 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80105b5e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105b61:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105b65:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105b68:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105b6a:	83 f8 0a             	cmp    $0xa,%eax
80105b6d:	75 e1                	jne    80105b50 <acquire+0x50>
}
80105b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b72:	c9                   	leave  
80105b73:	c3                   	ret    
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105b78:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80105b7c:	8d 51 34             	lea    0x34(%ecx),%edx
80105b7f:	90                   	nop
    pcs[i] = 0;
80105b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105b86:	83 c0 04             	add    $0x4,%eax
80105b89:	39 c2                	cmp    %eax,%edx
80105b8b:	75 f3                	jne    80105b80 <acquire+0x80>
}
80105b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b90:	c9                   	leave  
80105b91:	c3                   	ret    
80105b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105b98:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105b9b:	e8 40 f0 ff ff       	call   80104be0 <mycpu>
80105ba0:	39 c3                	cmp    %eax,%ebx
80105ba2:	0f 85 72 ff ff ff    	jne    80105b1a <acquire+0x1a>
  popcli();
80105ba8:	e8 53 fe ff ff       	call   80105a00 <popcli>
    panic("acquire");
80105bad:	83 ec 0c             	sub    $0xc,%esp
80105bb0:	68 d1 90 10 80       	push   $0x801090d1
80105bb5:	e8 a6 a8 ff ff       	call   80100460 <panic>
80105bba:	66 90                	xchg   %ax,%ax
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
80105bc4:	8b 55 08             	mov    0x8(%ebp),%edx
80105bc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105bca:	53                   	push   %ebx
80105bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105bce:	89 d7                	mov    %edx,%edi
80105bd0:	09 cf                	or     %ecx,%edi
80105bd2:	83 e7 03             	and    $0x3,%edi
80105bd5:	75 29                	jne    80105c00 <memset+0x40>
    c &= 0xFF;
80105bd7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105bda:	c1 e0 18             	shl    $0x18,%eax
80105bdd:	89 fb                	mov    %edi,%ebx
80105bdf:	c1 e9 02             	shr    $0x2,%ecx
80105be2:	c1 e3 10             	shl    $0x10,%ebx
80105be5:	09 d8                	or     %ebx,%eax
80105be7:	09 f8                	or     %edi,%eax
80105be9:	c1 e7 08             	shl    $0x8,%edi
80105bec:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105bee:	89 d7                	mov    %edx,%edi
80105bf0:	fc                   	cld    
80105bf1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105bf3:	5b                   	pop    %ebx
80105bf4:	89 d0                	mov    %edx,%eax
80105bf6:	5f                   	pop    %edi
80105bf7:	5d                   	pop    %ebp
80105bf8:	c3                   	ret    
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105c00:	89 d7                	mov    %edx,%edi
80105c02:	fc                   	cld    
80105c03:	f3 aa                	rep stos %al,%es:(%edi)
80105c05:	5b                   	pop    %ebx
80105c06:	89 d0                	mov    %edx,%eax
80105c08:	5f                   	pop    %edi
80105c09:	5d                   	pop    %ebp
80105c0a:	c3                   	ret    
80105c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c0f:	90                   	nop

80105c10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	56                   	push   %esi
80105c14:	8b 75 10             	mov    0x10(%ebp),%esi
80105c17:	8b 55 08             	mov    0x8(%ebp),%edx
80105c1a:	53                   	push   %ebx
80105c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105c1e:	85 f6                	test   %esi,%esi
80105c20:	74 2e                	je     80105c50 <memcmp+0x40>
80105c22:	01 c6                	add    %eax,%esi
80105c24:	eb 14                	jmp    80105c3a <memcmp+0x2a>
80105c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105c30:	83 c0 01             	add    $0x1,%eax
80105c33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105c36:	39 f0                	cmp    %esi,%eax
80105c38:	74 16                	je     80105c50 <memcmp+0x40>
    if(*s1 != *s2)
80105c3a:	0f b6 0a             	movzbl (%edx),%ecx
80105c3d:	0f b6 18             	movzbl (%eax),%ebx
80105c40:	38 d9                	cmp    %bl,%cl
80105c42:	74 ec                	je     80105c30 <memcmp+0x20>
      return *s1 - *s2;
80105c44:	0f b6 c1             	movzbl %cl,%eax
80105c47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105c49:	5b                   	pop    %ebx
80105c4a:	5e                   	pop    %esi
80105c4b:	5d                   	pop    %ebp
80105c4c:	c3                   	ret    
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
80105c50:	5b                   	pop    %ebx
  return 0;
80105c51:	31 c0                	xor    %eax,%eax
}
80105c53:	5e                   	pop    %esi
80105c54:	5d                   	pop    %ebp
80105c55:	c3                   	ret    
80105c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	8b 55 08             	mov    0x8(%ebp),%edx
80105c67:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105c6a:	56                   	push   %esi
80105c6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105c6e:	39 d6                	cmp    %edx,%esi
80105c70:	73 26                	jae    80105c98 <memmove+0x38>
80105c72:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105c75:	39 fa                	cmp    %edi,%edx
80105c77:	73 1f                	jae    80105c98 <memmove+0x38>
80105c79:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105c7c:	85 c9                	test   %ecx,%ecx
80105c7e:	74 0c                	je     80105c8c <memmove+0x2c>
      *--d = *--s;
80105c80:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105c84:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105c87:	83 e8 01             	sub    $0x1,%eax
80105c8a:	73 f4                	jae    80105c80 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105c8c:	5e                   	pop    %esi
80105c8d:	89 d0                	mov    %edx,%eax
80105c8f:	5f                   	pop    %edi
80105c90:	5d                   	pop    %ebp
80105c91:	c3                   	ret    
80105c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105c98:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105c9b:	89 d7                	mov    %edx,%edi
80105c9d:	85 c9                	test   %ecx,%ecx
80105c9f:	74 eb                	je     80105c8c <memmove+0x2c>
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105ca8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105ca9:	39 c6                	cmp    %eax,%esi
80105cab:	75 fb                	jne    80105ca8 <memmove+0x48>
}
80105cad:	5e                   	pop    %esi
80105cae:	89 d0                	mov    %edx,%eax
80105cb0:	5f                   	pop    %edi
80105cb1:	5d                   	pop    %ebp
80105cb2:	c3                   	ret    
80105cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cc0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105cc0:	eb 9e                	jmp    80105c60 <memmove>
80105cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	56                   	push   %esi
80105cd4:	8b 75 10             	mov    0x10(%ebp),%esi
80105cd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105cda:	53                   	push   %ebx
80105cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80105cde:	85 f6                	test   %esi,%esi
80105ce0:	74 2e                	je     80105d10 <strncmp+0x40>
80105ce2:	01 d6                	add    %edx,%esi
80105ce4:	eb 18                	jmp    80105cfe <strncmp+0x2e>
80105ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
80105cf0:	38 d8                	cmp    %bl,%al
80105cf2:	75 14                	jne    80105d08 <strncmp+0x38>
    n--, p++, q++;
80105cf4:	83 c2 01             	add    $0x1,%edx
80105cf7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105cfa:	39 f2                	cmp    %esi,%edx
80105cfc:	74 12                	je     80105d10 <strncmp+0x40>
80105cfe:	0f b6 01             	movzbl (%ecx),%eax
80105d01:	0f b6 1a             	movzbl (%edx),%ebx
80105d04:	84 c0                	test   %al,%al
80105d06:	75 e8                	jne    80105cf0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105d08:	29 d8                	sub    %ebx,%eax
}
80105d0a:	5b                   	pop    %ebx
80105d0b:	5e                   	pop    %esi
80105d0c:	5d                   	pop    %ebp
80105d0d:	c3                   	ret    
80105d0e:	66 90                	xchg   %ax,%ax
80105d10:	5b                   	pop    %ebx
    return 0;
80105d11:	31 c0                	xor    %eax,%eax
}
80105d13:	5e                   	pop    %esi
80105d14:	5d                   	pop    %ebp
80105d15:	c3                   	ret    
80105d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi

80105d20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
80105d25:	8b 75 08             	mov    0x8(%ebp),%esi
80105d28:	53                   	push   %ebx
80105d29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105d2c:	89 f0                	mov    %esi,%eax
80105d2e:	eb 15                	jmp    80105d45 <strncpy+0x25>
80105d30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105d34:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105d37:	83 c0 01             	add    $0x1,%eax
80105d3a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105d3e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105d41:	84 d2                	test   %dl,%dl
80105d43:	74 09                	je     80105d4e <strncpy+0x2e>
80105d45:	89 cb                	mov    %ecx,%ebx
80105d47:	83 e9 01             	sub    $0x1,%ecx
80105d4a:	85 db                	test   %ebx,%ebx
80105d4c:	7f e2                	jg     80105d30 <strncpy+0x10>
    ;
  while(n-- > 0)
80105d4e:	89 c2                	mov    %eax,%edx
80105d50:	85 c9                	test   %ecx,%ecx
80105d52:	7e 17                	jle    80105d6b <strncpy+0x4b>
80105d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105d58:	83 c2 01             	add    $0x1,%edx
80105d5b:	89 c1                	mov    %eax,%ecx
80105d5d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105d61:	29 d1                	sub    %edx,%ecx
80105d63:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105d67:	85 c9                	test   %ecx,%ecx
80105d69:	7f ed                	jg     80105d58 <strncpy+0x38>
  return os;
}
80105d6b:	5b                   	pop    %ebx
80105d6c:	89 f0                	mov    %esi,%eax
80105d6e:	5e                   	pop    %esi
80105d6f:	5f                   	pop    %edi
80105d70:	5d                   	pop    %ebp
80105d71:	c3                   	ret    
80105d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	56                   	push   %esi
80105d84:	8b 55 10             	mov    0x10(%ebp),%edx
80105d87:	8b 75 08             	mov    0x8(%ebp),%esi
80105d8a:	53                   	push   %ebx
80105d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105d8e:	85 d2                	test   %edx,%edx
80105d90:	7e 25                	jle    80105db7 <safestrcpy+0x37>
80105d92:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105d96:	89 f2                	mov    %esi,%edx
80105d98:	eb 16                	jmp    80105db0 <safestrcpy+0x30>
80105d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105da0:	0f b6 08             	movzbl (%eax),%ecx
80105da3:	83 c0 01             	add    $0x1,%eax
80105da6:	83 c2 01             	add    $0x1,%edx
80105da9:	88 4a ff             	mov    %cl,-0x1(%edx)
80105dac:	84 c9                	test   %cl,%cl
80105dae:	74 04                	je     80105db4 <safestrcpy+0x34>
80105db0:	39 d8                	cmp    %ebx,%eax
80105db2:	75 ec                	jne    80105da0 <safestrcpy+0x20>
    ;
  *s = 0;
80105db4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105db7:	89 f0                	mov    %esi,%eax
80105db9:	5b                   	pop    %ebx
80105dba:	5e                   	pop    %esi
80105dbb:	5d                   	pop    %ebp
80105dbc:	c3                   	ret    
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi

80105dc0 <strlen>:

int
strlen(const char *s)
{
80105dc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105dc1:	31 c0                	xor    %eax,%eax
{
80105dc3:	89 e5                	mov    %esp,%ebp
80105dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105dc8:	80 3a 00             	cmpb   $0x0,(%edx)
80105dcb:	74 0c                	je     80105dd9 <strlen+0x19>
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
80105dd0:	83 c0 01             	add    $0x1,%eax
80105dd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105dd7:	75 f7                	jne    80105dd0 <strlen+0x10>
    ;
  return n;
}
80105dd9:	5d                   	pop    %ebp
80105dda:	c3                   	ret    

80105ddb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105ddb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105ddf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105de3:	55                   	push   %ebp
  pushl %ebx
80105de4:	53                   	push   %ebx
  pushl %esi
80105de5:	56                   	push   %esi
  pushl %edi
80105de6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105de7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105de9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105deb:	5f                   	pop    %edi
  popl %esi
80105dec:	5e                   	pop    %esi
  popl %ebx
80105ded:	5b                   	pop    %ebx
  popl %ebp
80105dee:	5d                   	pop    %ebp
  ret
80105def:	c3                   	ret    

80105df0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	53                   	push   %ebx
80105df4:	83 ec 04             	sub    $0x4,%esp
80105df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105dfa:	e8 61 ee ff ff       	call   80104c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105dff:	8b 00                	mov    (%eax),%eax
80105e01:	39 d8                	cmp    %ebx,%eax
80105e03:	76 1b                	jbe    80105e20 <fetchint+0x30>
80105e05:	8d 53 04             	lea    0x4(%ebx),%edx
80105e08:	39 d0                	cmp    %edx,%eax
80105e0a:	72 14                	jb     80105e20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e0f:	8b 13                	mov    (%ebx),%edx
80105e11:	89 10                	mov    %edx,(%eax)
  return 0;
80105e13:	31 c0                	xor    %eax,%eax
}
80105e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e18:	c9                   	leave  
80105e19:	c3                   	ret    
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e25:	eb ee                	jmp    80105e15 <fetchint+0x25>
80105e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2e:	66 90                	xchg   %ax,%ax

80105e30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	53                   	push   %ebx
80105e34:	83 ec 04             	sub    $0x4,%esp
80105e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105e3a:	e8 21 ee ff ff       	call   80104c60 <myproc>

  if(addr >= curproc->sz)
80105e3f:	39 18                	cmp    %ebx,(%eax)
80105e41:	76 2d                	jbe    80105e70 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105e43:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e46:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105e48:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105e4a:	39 d3                	cmp    %edx,%ebx
80105e4c:	73 22                	jae    80105e70 <fetchstr+0x40>
80105e4e:	89 d8                	mov    %ebx,%eax
80105e50:	eb 0d                	jmp    80105e5f <fetchstr+0x2f>
80105e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e58:	83 c0 01             	add    $0x1,%eax
80105e5b:	39 c2                	cmp    %eax,%edx
80105e5d:	76 11                	jbe    80105e70 <fetchstr+0x40>
    if(*s == 0)
80105e5f:	80 38 00             	cmpb   $0x0,(%eax)
80105e62:	75 f4                	jne    80105e58 <fetchstr+0x28>
      return s - *pp;
80105e64:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105e66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e69:	c9                   	leave  
80105e6a:	c3                   	ret    
80105e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
80105e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105e73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e78:	c9                   	leave  
80105e79:	c3                   	ret    
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	56                   	push   %esi
80105e84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105e85:	e8 d6 ed ff ff       	call   80104c60 <myproc>
80105e8a:	8b 55 08             	mov    0x8(%ebp),%edx
80105e8d:	8b 40 18             	mov    0x18(%eax),%eax
80105e90:	8b 40 44             	mov    0x44(%eax),%eax
80105e93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105e96:	e8 c5 ed ff ff       	call   80104c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105e9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105e9e:	8b 00                	mov    (%eax),%eax
80105ea0:	39 c6                	cmp    %eax,%esi
80105ea2:	73 1c                	jae    80105ec0 <argint+0x40>
80105ea4:	8d 53 08             	lea    0x8(%ebx),%edx
80105ea7:	39 d0                	cmp    %edx,%eax
80105ea9:	72 15                	jb     80105ec0 <argint+0x40>
  *ip = *(int*)(addr);
80105eab:	8b 45 0c             	mov    0xc(%ebp),%eax
80105eae:	8b 53 04             	mov    0x4(%ebx),%edx
80105eb1:	89 10                	mov    %edx,(%eax)
  return 0;
80105eb3:	31 c0                	xor    %eax,%eax
}
80105eb5:	5b                   	pop    %ebx
80105eb6:	5e                   	pop    %esi
80105eb7:	5d                   	pop    %ebp
80105eb8:	c3                   	ret    
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ec5:	eb ee                	jmp    80105eb5 <argint+0x35>
80105ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105ed9:	e8 82 ed ff ff       	call   80104c60 <myproc>
80105ede:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ee0:	e8 7b ed ff ff       	call   80104c60 <myproc>
80105ee5:	8b 55 08             	mov    0x8(%ebp),%edx
80105ee8:	8b 40 18             	mov    0x18(%eax),%eax
80105eeb:	8b 40 44             	mov    0x44(%eax),%eax
80105eee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105ef1:	e8 6a ed ff ff       	call   80104c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ef6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105ef9:	8b 00                	mov    (%eax),%eax
80105efb:	39 c7                	cmp    %eax,%edi
80105efd:	73 31                	jae    80105f30 <argptr+0x60>
80105eff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105f02:	39 c8                	cmp    %ecx,%eax
80105f04:	72 2a                	jb     80105f30 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105f06:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105f09:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105f0c:	85 d2                	test   %edx,%edx
80105f0e:	78 20                	js     80105f30 <argptr+0x60>
80105f10:	8b 16                	mov    (%esi),%edx
80105f12:	39 c2                	cmp    %eax,%edx
80105f14:	76 1a                	jbe    80105f30 <argptr+0x60>
80105f16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105f19:	01 c3                	add    %eax,%ebx
80105f1b:	39 da                	cmp    %ebx,%edx
80105f1d:	72 11                	jb     80105f30 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105f22:	89 02                	mov    %eax,(%edx)
  return 0;
80105f24:	31 c0                	xor    %eax,%eax
}
80105f26:	83 c4 0c             	add    $0xc,%esp
80105f29:	5b                   	pop    %ebx
80105f2a:	5e                   	pop    %esi
80105f2b:	5f                   	pop    %edi
80105f2c:	5d                   	pop    %ebp
80105f2d:	c3                   	ret    
80105f2e:	66 90                	xchg   %ax,%ax
    return -1;
80105f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f35:	eb ef                	jmp    80105f26 <argptr+0x56>
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	56                   	push   %esi
80105f44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f45:	e8 16 ed ff ff       	call   80104c60 <myproc>
80105f4a:	8b 55 08             	mov    0x8(%ebp),%edx
80105f4d:	8b 40 18             	mov    0x18(%eax),%eax
80105f50:	8b 40 44             	mov    0x44(%eax),%eax
80105f53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105f56:	e8 05 ed ff ff       	call   80104c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f5e:	8b 00                	mov    (%eax),%eax
80105f60:	39 c6                	cmp    %eax,%esi
80105f62:	73 44                	jae    80105fa8 <argstr+0x68>
80105f64:	8d 53 08             	lea    0x8(%ebx),%edx
80105f67:	39 d0                	cmp    %edx,%eax
80105f69:	72 3d                	jb     80105fa8 <argstr+0x68>
  *ip = *(int*)(addr);
80105f6b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105f6e:	e8 ed ec ff ff       	call   80104c60 <myproc>
  if(addr >= curproc->sz)
80105f73:	3b 18                	cmp    (%eax),%ebx
80105f75:	73 31                	jae    80105fa8 <argstr+0x68>
  *pp = (char*)addr;
80105f77:	8b 55 0c             	mov    0xc(%ebp),%edx
80105f7a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105f7c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105f7e:	39 d3                	cmp    %edx,%ebx
80105f80:	73 26                	jae    80105fa8 <argstr+0x68>
80105f82:	89 d8                	mov    %ebx,%eax
80105f84:	eb 11                	jmp    80105f97 <argstr+0x57>
80105f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8d:	8d 76 00             	lea    0x0(%esi),%esi
80105f90:	83 c0 01             	add    $0x1,%eax
80105f93:	39 c2                	cmp    %eax,%edx
80105f95:	76 11                	jbe    80105fa8 <argstr+0x68>
    if(*s == 0)
80105f97:	80 38 00             	cmpb   $0x0,(%eax)
80105f9a:	75 f4                	jne    80105f90 <argstr+0x50>
      return s - *pp;
80105f9c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105f9e:	5b                   	pop    %ebx
80105f9f:	5e                   	pop    %esi
80105fa0:	5d                   	pop    %ebp
80105fa1:	c3                   	ret    
80105fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fa8:	5b                   	pop    %ebx
    return -1;
80105fa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fae:	5e                   	pop    %esi
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop

80105fc0 <syscall>:

};

void
syscall(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	53                   	push   %ebx
80105fc4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105fc7:	e8 94 ec ff ff       	call   80104c60 <myproc>
80105fcc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105fce:	8b 40 18             	mov    0x18(%eax),%eax
80105fd1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
80105fd7:	83 fa 1b             	cmp    $0x1b,%edx
80105fda:	77 24                	ja     80106000 <syscall+0x40>
80105fdc:	8b 14 85 00 91 10 80 	mov    -0x7fef6f00(,%eax,4),%edx
80105fe3:	85 d2                	test   %edx,%edx
80105fe5:	74 19                	je     80106000 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105fe7:	ff d2                	call   *%edx
80105fe9:	89 c2                	mov    %eax,%edx
80105feb:	8b 43 18             	mov    0x18(%ebx),%eax
80105fee:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff4:	c9                   	leave  
80105ff5:	c3                   	ret    
80105ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80106000:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106001:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106004:	50                   	push   %eax
80106005:	ff 73 10             	push   0x10(%ebx)
80106008:	68 d9 90 10 80       	push   $0x801090d9
8010600d:	e8 ce a7 ff ff       	call   801007e0 <cprintf>
    curproc->tf->eax = -1;
80106012:	8b 43 18             	mov    0x18(%ebx),%eax
80106015:	83 c4 10             	add    $0x10,%esp
80106018:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010601f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106022:	c9                   	leave  
80106023:	c3                   	ret    
80106024:	66 90                	xchg   %ax,%ax
80106026:	66 90                	xchg   %ax,%ax
80106028:	66 90                	xchg   %ax,%ax
8010602a:	66 90                	xchg   %ax,%ax
8010602c:	66 90                	xchg   %ax,%ax
8010602e:	66 90                	xchg   %ax,%ax

80106030 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	57                   	push   %edi
80106034:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106035:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106038:	53                   	push   %ebx
80106039:	83 ec 34             	sub    $0x34,%esp
8010603c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010603f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80106042:	57                   	push   %edi
80106043:	50                   	push   %eax
{
80106044:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106047:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010604a:	e8 51 d3 ff ff       	call   801033a0 <nameiparent>
8010604f:	83 c4 10             	add    $0x10,%esp
80106052:	85 c0                	test   %eax,%eax
80106054:	0f 84 46 01 00 00    	je     801061a0 <create+0x170>
    return 0;
  ilock(dp);
8010605a:	83 ec 0c             	sub    $0xc,%esp
8010605d:	89 c3                	mov    %eax,%ebx
8010605f:	50                   	push   %eax
80106060:	e8 fb c9 ff ff       	call   80102a60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80106065:	83 c4 0c             	add    $0xc,%esp
80106068:	6a 00                	push   $0x0
8010606a:	57                   	push   %edi
8010606b:	53                   	push   %ebx
8010606c:	e8 4f cf ff ff       	call   80102fc0 <dirlookup>
80106071:	83 c4 10             	add    $0x10,%esp
80106074:	89 c6                	mov    %eax,%esi
80106076:	85 c0                	test   %eax,%eax
80106078:	74 56                	je     801060d0 <create+0xa0>
    iunlockput(dp);
8010607a:	83 ec 0c             	sub    $0xc,%esp
8010607d:	53                   	push   %ebx
8010607e:	e8 6d cc ff ff       	call   80102cf0 <iunlockput>
    ilock(ip);
80106083:	89 34 24             	mov    %esi,(%esp)
80106086:	e8 d5 c9 ff ff       	call   80102a60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010608b:	83 c4 10             	add    $0x10,%esp
8010608e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106093:	75 1b                	jne    801060b0 <create+0x80>
80106095:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010609a:	75 14                	jne    801060b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010609c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010609f:	89 f0                	mov    %esi,%eax
801060a1:	5b                   	pop    %ebx
801060a2:	5e                   	pop    %esi
801060a3:	5f                   	pop    %edi
801060a4:	5d                   	pop    %ebp
801060a5:	c3                   	ret    
801060a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801060b0:	83 ec 0c             	sub    $0xc,%esp
801060b3:	56                   	push   %esi
    return 0;
801060b4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801060b6:	e8 35 cc ff ff       	call   80102cf0 <iunlockput>
    return 0;
801060bb:	83 c4 10             	add    $0x10,%esp
}
801060be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c1:	89 f0                	mov    %esi,%eax
801060c3:	5b                   	pop    %ebx
801060c4:	5e                   	pop    %esi
801060c5:	5f                   	pop    %edi
801060c6:	5d                   	pop    %ebp
801060c7:	c3                   	ret    
801060c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801060d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801060d4:	83 ec 08             	sub    $0x8,%esp
801060d7:	50                   	push   %eax
801060d8:	ff 33                	push   (%ebx)
801060da:	e8 11 c8 ff ff       	call   801028f0 <ialloc>
801060df:	83 c4 10             	add    $0x10,%esp
801060e2:	89 c6                	mov    %eax,%esi
801060e4:	85 c0                	test   %eax,%eax
801060e6:	0f 84 cd 00 00 00    	je     801061b9 <create+0x189>
  ilock(ip);
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	50                   	push   %eax
801060f0:	e8 6b c9 ff ff       	call   80102a60 <ilock>
  ip->major = major;
801060f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801060f9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801060fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106101:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106105:	b8 01 00 00 00       	mov    $0x1,%eax
8010610a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010610e:	89 34 24             	mov    %esi,(%esp)
80106111:	e8 9a c8 ff ff       	call   801029b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010611e:	74 30                	je     80106150 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106120:	83 ec 04             	sub    $0x4,%esp
80106123:	ff 76 04             	push   0x4(%esi)
80106126:	57                   	push   %edi
80106127:	53                   	push   %ebx
80106128:	e8 93 d1 ff ff       	call   801032c0 <dirlink>
8010612d:	83 c4 10             	add    $0x10,%esp
80106130:	85 c0                	test   %eax,%eax
80106132:	78 78                	js     801061ac <create+0x17c>
  iunlockput(dp);
80106134:	83 ec 0c             	sub    $0xc,%esp
80106137:	53                   	push   %ebx
80106138:	e8 b3 cb ff ff       	call   80102cf0 <iunlockput>
  return ip;
8010613d:	83 c4 10             	add    $0x10,%esp
}
80106140:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106143:	89 f0                	mov    %esi,%eax
80106145:	5b                   	pop    %ebx
80106146:	5e                   	pop    %esi
80106147:	5f                   	pop    %edi
80106148:	5d                   	pop    %ebp
80106149:	c3                   	ret    
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106150:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80106153:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106158:	53                   	push   %ebx
80106159:	e8 52 c8 ff ff       	call   801029b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010615e:	83 c4 0c             	add    $0xc,%esp
80106161:	ff 76 04             	push   0x4(%esi)
80106164:	68 90 91 10 80       	push   $0x80109190
80106169:	56                   	push   %esi
8010616a:	e8 51 d1 ff ff       	call   801032c0 <dirlink>
8010616f:	83 c4 10             	add    $0x10,%esp
80106172:	85 c0                	test   %eax,%eax
80106174:	78 18                	js     8010618e <create+0x15e>
80106176:	83 ec 04             	sub    $0x4,%esp
80106179:	ff 73 04             	push   0x4(%ebx)
8010617c:	68 8f 91 10 80       	push   $0x8010918f
80106181:	56                   	push   %esi
80106182:	e8 39 d1 ff ff       	call   801032c0 <dirlink>
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	85 c0                	test   %eax,%eax
8010618c:	79 92                	jns    80106120 <create+0xf0>
      panic("create dots");
8010618e:	83 ec 0c             	sub    $0xc,%esp
80106191:	68 83 91 10 80       	push   $0x80109183
80106196:	e8 c5 a2 ff ff       	call   80100460 <panic>
8010619b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010619f:	90                   	nop
}
801061a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801061a3:	31 f6                	xor    %esi,%esi
}
801061a5:	5b                   	pop    %ebx
801061a6:	89 f0                	mov    %esi,%eax
801061a8:	5e                   	pop    %esi
801061a9:	5f                   	pop    %edi
801061aa:	5d                   	pop    %ebp
801061ab:	c3                   	ret    
    panic("create: dirlink");
801061ac:	83 ec 0c             	sub    $0xc,%esp
801061af:	68 92 91 10 80       	push   $0x80109192
801061b4:	e8 a7 a2 ff ff       	call   80100460 <panic>
    panic("create: ialloc");
801061b9:	83 ec 0c             	sub    $0xc,%esp
801061bc:	68 74 91 10 80       	push   $0x80109174
801061c1:	e8 9a a2 ff ff       	call   80100460 <panic>
801061c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cd:	8d 76 00             	lea    0x0(%esi),%esi

801061d0 <sys_dup>:
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	56                   	push   %esi
801061d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801061d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801061db:	50                   	push   %eax
801061dc:	6a 00                	push   $0x0
801061de:	e8 9d fc ff ff       	call   80105e80 <argint>
801061e3:	83 c4 10             	add    $0x10,%esp
801061e6:	85 c0                	test   %eax,%eax
801061e8:	78 36                	js     80106220 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801061ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801061ee:	77 30                	ja     80106220 <sys_dup+0x50>
801061f0:	e8 6b ea ff ff       	call   80104c60 <myproc>
801061f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801061fc:	85 f6                	test   %esi,%esi
801061fe:	74 20                	je     80106220 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106200:	e8 5b ea ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106205:	31 db                	xor    %ebx,%ebx
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106210:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106214:	85 d2                	test   %edx,%edx
80106216:	74 18                	je     80106230 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80106218:	83 c3 01             	add    $0x1,%ebx
8010621b:	83 fb 10             	cmp    $0x10,%ebx
8010621e:	75 f0                	jne    80106210 <sys_dup+0x40>
}
80106220:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80106223:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106228:	89 d8                	mov    %ebx,%eax
8010622a:	5b                   	pop    %ebx
8010622b:	5e                   	pop    %esi
8010622c:	5d                   	pop    %ebp
8010622d:	c3                   	ret    
8010622e:	66 90                	xchg   %ax,%ax
  filedup(f);
80106230:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106233:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106237:	56                   	push   %esi
80106238:	e8 43 bf ff ff       	call   80102180 <filedup>
  return fd;
8010623d:	83 c4 10             	add    $0x10,%esp
}
80106240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106243:	89 d8                	mov    %ebx,%eax
80106245:	5b                   	pop    %ebx
80106246:	5e                   	pop    %esi
80106247:	5d                   	pop    %ebp
80106248:	c3                   	ret    
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106250 <sys_read>:
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	56                   	push   %esi
80106254:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106255:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106258:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010625b:	53                   	push   %ebx
8010625c:	6a 00                	push   $0x0
8010625e:	e8 1d fc ff ff       	call   80105e80 <argint>
80106263:	83 c4 10             	add    $0x10,%esp
80106266:	85 c0                	test   %eax,%eax
80106268:	78 5e                	js     801062c8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010626a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010626e:	77 58                	ja     801062c8 <sys_read+0x78>
80106270:	e8 eb e9 ff ff       	call   80104c60 <myproc>
80106275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106278:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010627c:	85 f6                	test   %esi,%esi
8010627e:	74 48                	je     801062c8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106280:	83 ec 08             	sub    $0x8,%esp
80106283:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106286:	50                   	push   %eax
80106287:	6a 02                	push   $0x2
80106289:	e8 f2 fb ff ff       	call   80105e80 <argint>
8010628e:	83 c4 10             	add    $0x10,%esp
80106291:	85 c0                	test   %eax,%eax
80106293:	78 33                	js     801062c8 <sys_read+0x78>
80106295:	83 ec 04             	sub    $0x4,%esp
80106298:	ff 75 f0             	push   -0x10(%ebp)
8010629b:	53                   	push   %ebx
8010629c:	6a 01                	push   $0x1
8010629e:	e8 2d fc ff ff       	call   80105ed0 <argptr>
801062a3:	83 c4 10             	add    $0x10,%esp
801062a6:	85 c0                	test   %eax,%eax
801062a8:	78 1e                	js     801062c8 <sys_read+0x78>
  return fileread(f, p, n);
801062aa:	83 ec 04             	sub    $0x4,%esp
801062ad:	ff 75 f0             	push   -0x10(%ebp)
801062b0:	ff 75 f4             	push   -0xc(%ebp)
801062b3:	56                   	push   %esi
801062b4:	e8 47 c0 ff ff       	call   80102300 <fileread>
801062b9:	83 c4 10             	add    $0x10,%esp
}
801062bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062bf:	5b                   	pop    %ebx
801062c0:	5e                   	pop    %esi
801062c1:	5d                   	pop    %ebp
801062c2:	c3                   	ret    
801062c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062c7:	90                   	nop
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cd:	eb ed                	jmp    801062bc <sys_read+0x6c>
801062cf:	90                   	nop

801062d0 <sys_write>:
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	56                   	push   %esi
801062d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801062d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801062d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801062db:	53                   	push   %ebx
801062dc:	6a 00                	push   $0x0
801062de:	e8 9d fb ff ff       	call   80105e80 <argint>
801062e3:	83 c4 10             	add    $0x10,%esp
801062e6:	85 c0                	test   %eax,%eax
801062e8:	78 5e                	js     80106348 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801062ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801062ee:	77 58                	ja     80106348 <sys_write+0x78>
801062f0:	e8 6b e9 ff ff       	call   80104c60 <myproc>
801062f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801062fc:	85 f6                	test   %esi,%esi
801062fe:	74 48                	je     80106348 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106300:	83 ec 08             	sub    $0x8,%esp
80106303:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106306:	50                   	push   %eax
80106307:	6a 02                	push   $0x2
80106309:	e8 72 fb ff ff       	call   80105e80 <argint>
8010630e:	83 c4 10             	add    $0x10,%esp
80106311:	85 c0                	test   %eax,%eax
80106313:	78 33                	js     80106348 <sys_write+0x78>
80106315:	83 ec 04             	sub    $0x4,%esp
80106318:	ff 75 f0             	push   -0x10(%ebp)
8010631b:	53                   	push   %ebx
8010631c:	6a 01                	push   $0x1
8010631e:	e8 ad fb ff ff       	call   80105ed0 <argptr>
80106323:	83 c4 10             	add    $0x10,%esp
80106326:	85 c0                	test   %eax,%eax
80106328:	78 1e                	js     80106348 <sys_write+0x78>
  return filewrite(f, p, n);
8010632a:	83 ec 04             	sub    $0x4,%esp
8010632d:	ff 75 f0             	push   -0x10(%ebp)
80106330:	ff 75 f4             	push   -0xc(%ebp)
80106333:	56                   	push   %esi
80106334:	e8 57 c0 ff ff       	call   80102390 <filewrite>
80106339:	83 c4 10             	add    $0x10,%esp
}
8010633c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010633f:	5b                   	pop    %ebx
80106340:	5e                   	pop    %esi
80106341:	5d                   	pop    %ebp
80106342:	c3                   	ret    
80106343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106347:	90                   	nop
    return -1;
80106348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634d:	eb ed                	jmp    8010633c <sys_write+0x6c>
8010634f:	90                   	nop

80106350 <sys_close>:
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	56                   	push   %esi
80106354:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106355:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106358:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010635b:	50                   	push   %eax
8010635c:	6a 00                	push   $0x0
8010635e:	e8 1d fb ff ff       	call   80105e80 <argint>
80106363:	83 c4 10             	add    $0x10,%esp
80106366:	85 c0                	test   %eax,%eax
80106368:	78 3e                	js     801063a8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010636a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010636e:	77 38                	ja     801063a8 <sys_close+0x58>
80106370:	e8 eb e8 ff ff       	call   80104c60 <myproc>
80106375:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106378:	8d 5a 08             	lea    0x8(%edx),%ebx
8010637b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010637f:	85 f6                	test   %esi,%esi
80106381:	74 25                	je     801063a8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106383:	e8 d8 e8 ff ff       	call   80104c60 <myproc>
  fileclose(f);
80106388:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010638b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106392:	00 
  fileclose(f);
80106393:	56                   	push   %esi
80106394:	e8 37 be ff ff       	call   801021d0 <fileclose>
  return 0;
80106399:	83 c4 10             	add    $0x10,%esp
8010639c:	31 c0                	xor    %eax,%eax
}
8010639e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063a1:	5b                   	pop    %ebx
801063a2:	5e                   	pop    %esi
801063a3:	5d                   	pop    %ebp
801063a4:	c3                   	ret    
801063a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801063a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ad:	eb ef                	jmp    8010639e <sys_close+0x4e>
801063af:	90                   	nop

801063b0 <sys_fstat>:
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	56                   	push   %esi
801063b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801063b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801063b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801063bb:	53                   	push   %ebx
801063bc:	6a 00                	push   $0x0
801063be:	e8 bd fa ff ff       	call   80105e80 <argint>
801063c3:	83 c4 10             	add    $0x10,%esp
801063c6:	85 c0                	test   %eax,%eax
801063c8:	78 46                	js     80106410 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801063ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801063ce:	77 40                	ja     80106410 <sys_fstat+0x60>
801063d0:	e8 8b e8 ff ff       	call   80104c60 <myproc>
801063d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801063dc:	85 f6                	test   %esi,%esi
801063de:	74 30                	je     80106410 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801063e0:	83 ec 04             	sub    $0x4,%esp
801063e3:	6a 14                	push   $0x14
801063e5:	53                   	push   %ebx
801063e6:	6a 01                	push   $0x1
801063e8:	e8 e3 fa ff ff       	call   80105ed0 <argptr>
801063ed:	83 c4 10             	add    $0x10,%esp
801063f0:	85 c0                	test   %eax,%eax
801063f2:	78 1c                	js     80106410 <sys_fstat+0x60>
  return filestat(f, st);
801063f4:	83 ec 08             	sub    $0x8,%esp
801063f7:	ff 75 f4             	push   -0xc(%ebp)
801063fa:	56                   	push   %esi
801063fb:	e8 b0 be ff ff       	call   801022b0 <filestat>
80106400:	83 c4 10             	add    $0x10,%esp
}
80106403:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106406:	5b                   	pop    %ebx
80106407:	5e                   	pop    %esi
80106408:	5d                   	pop    %ebp
80106409:	c3                   	ret    
8010640a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106415:	eb ec                	jmp    80106403 <sys_fstat+0x53>
80106417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010641e:	66 90                	xchg   %ax,%ax

80106420 <sys_link>:
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	57                   	push   %edi
80106424:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106425:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106428:	53                   	push   %ebx
80106429:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010642c:	50                   	push   %eax
8010642d:	6a 00                	push   $0x0
8010642f:	e8 0c fb ff ff       	call   80105f40 <argstr>
80106434:	83 c4 10             	add    $0x10,%esp
80106437:	85 c0                	test   %eax,%eax
80106439:	0f 88 fb 00 00 00    	js     8010653a <sys_link+0x11a>
8010643f:	83 ec 08             	sub    $0x8,%esp
80106442:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106445:	50                   	push   %eax
80106446:	6a 01                	push   $0x1
80106448:	e8 f3 fa ff ff       	call   80105f40 <argstr>
8010644d:	83 c4 10             	add    $0x10,%esp
80106450:	85 c0                	test   %eax,%eax
80106452:	0f 88 e2 00 00 00    	js     8010653a <sys_link+0x11a>
  begin_op();
80106458:	e8 e3 db ff ff       	call   80104040 <begin_op>
  if((ip = namei(old)) == 0){
8010645d:	83 ec 0c             	sub    $0xc,%esp
80106460:	ff 75 d4             	push   -0x2c(%ebp)
80106463:	e8 18 cf ff ff       	call   80103380 <namei>
80106468:	83 c4 10             	add    $0x10,%esp
8010646b:	89 c3                	mov    %eax,%ebx
8010646d:	85 c0                	test   %eax,%eax
8010646f:	0f 84 e4 00 00 00    	je     80106559 <sys_link+0x139>
  ilock(ip);
80106475:	83 ec 0c             	sub    $0xc,%esp
80106478:	50                   	push   %eax
80106479:	e8 e2 c5 ff ff       	call   80102a60 <ilock>
  if(ip->type == T_DIR){
8010647e:	83 c4 10             	add    $0x10,%esp
80106481:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106486:	0f 84 b5 00 00 00    	je     80106541 <sys_link+0x121>
  iupdate(ip);
8010648c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010648f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106494:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106497:	53                   	push   %ebx
80106498:	e8 13 c5 ff ff       	call   801029b0 <iupdate>
  iunlock(ip);
8010649d:	89 1c 24             	mov    %ebx,(%esp)
801064a0:	e8 9b c6 ff ff       	call   80102b40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801064a5:	58                   	pop    %eax
801064a6:	5a                   	pop    %edx
801064a7:	57                   	push   %edi
801064a8:	ff 75 d0             	push   -0x30(%ebp)
801064ab:	e8 f0 ce ff ff       	call   801033a0 <nameiparent>
801064b0:	83 c4 10             	add    $0x10,%esp
801064b3:	89 c6                	mov    %eax,%esi
801064b5:	85 c0                	test   %eax,%eax
801064b7:	74 5b                	je     80106514 <sys_link+0xf4>
  ilock(dp);
801064b9:	83 ec 0c             	sub    $0xc,%esp
801064bc:	50                   	push   %eax
801064bd:	e8 9e c5 ff ff       	call   80102a60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801064c2:	8b 03                	mov    (%ebx),%eax
801064c4:	83 c4 10             	add    $0x10,%esp
801064c7:	39 06                	cmp    %eax,(%esi)
801064c9:	75 3d                	jne    80106508 <sys_link+0xe8>
801064cb:	83 ec 04             	sub    $0x4,%esp
801064ce:	ff 73 04             	push   0x4(%ebx)
801064d1:	57                   	push   %edi
801064d2:	56                   	push   %esi
801064d3:	e8 e8 cd ff ff       	call   801032c0 <dirlink>
801064d8:	83 c4 10             	add    $0x10,%esp
801064db:	85 c0                	test   %eax,%eax
801064dd:	78 29                	js     80106508 <sys_link+0xe8>
  iunlockput(dp);
801064df:	83 ec 0c             	sub    $0xc,%esp
801064e2:	56                   	push   %esi
801064e3:	e8 08 c8 ff ff       	call   80102cf0 <iunlockput>
  iput(ip);
801064e8:	89 1c 24             	mov    %ebx,(%esp)
801064eb:	e8 a0 c6 ff ff       	call   80102b90 <iput>
  end_op();
801064f0:	e8 bb db ff ff       	call   801040b0 <end_op>
  return 0;
801064f5:	83 c4 10             	add    $0x10,%esp
801064f8:	31 c0                	xor    %eax,%eax
}
801064fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064fd:	5b                   	pop    %ebx
801064fe:	5e                   	pop    %esi
801064ff:	5f                   	pop    %edi
80106500:	5d                   	pop    %ebp
80106501:	c3                   	ret    
80106502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106508:	83 ec 0c             	sub    $0xc,%esp
8010650b:	56                   	push   %esi
8010650c:	e8 df c7 ff ff       	call   80102cf0 <iunlockput>
    goto bad;
80106511:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	53                   	push   %ebx
80106518:	e8 43 c5 ff ff       	call   80102a60 <ilock>
  ip->nlink--;
8010651d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106522:	89 1c 24             	mov    %ebx,(%esp)
80106525:	e8 86 c4 ff ff       	call   801029b0 <iupdate>
  iunlockput(ip);
8010652a:	89 1c 24             	mov    %ebx,(%esp)
8010652d:	e8 be c7 ff ff       	call   80102cf0 <iunlockput>
  end_op();
80106532:	e8 79 db ff ff       	call   801040b0 <end_op>
  return -1;
80106537:	83 c4 10             	add    $0x10,%esp
8010653a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010653f:	eb b9                	jmp    801064fa <sys_link+0xda>
    iunlockput(ip);
80106541:	83 ec 0c             	sub    $0xc,%esp
80106544:	53                   	push   %ebx
80106545:	e8 a6 c7 ff ff       	call   80102cf0 <iunlockput>
    end_op();
8010654a:	e8 61 db ff ff       	call   801040b0 <end_op>
    return -1;
8010654f:	83 c4 10             	add    $0x10,%esp
80106552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106557:	eb a1                	jmp    801064fa <sys_link+0xda>
    end_op();
80106559:	e8 52 db ff ff       	call   801040b0 <end_op>
    return -1;
8010655e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106563:	eb 95                	jmp    801064fa <sys_link+0xda>
80106565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106570 <sys_unlink>:
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106575:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106578:	53                   	push   %ebx
80106579:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010657c:	50                   	push   %eax
8010657d:	6a 00                	push   $0x0
8010657f:	e8 bc f9 ff ff       	call   80105f40 <argstr>
80106584:	83 c4 10             	add    $0x10,%esp
80106587:	85 c0                	test   %eax,%eax
80106589:	0f 88 7a 01 00 00    	js     80106709 <sys_unlink+0x199>
  begin_op();
8010658f:	e8 ac da ff ff       	call   80104040 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106594:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106597:	83 ec 08             	sub    $0x8,%esp
8010659a:	53                   	push   %ebx
8010659b:	ff 75 c0             	push   -0x40(%ebp)
8010659e:	e8 fd cd ff ff       	call   801033a0 <nameiparent>
801065a3:	83 c4 10             	add    $0x10,%esp
801065a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801065a9:	85 c0                	test   %eax,%eax
801065ab:	0f 84 62 01 00 00    	je     80106713 <sys_unlink+0x1a3>
  ilock(dp);
801065b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801065b4:	83 ec 0c             	sub    $0xc,%esp
801065b7:	57                   	push   %edi
801065b8:	e8 a3 c4 ff ff       	call   80102a60 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801065bd:	58                   	pop    %eax
801065be:	5a                   	pop    %edx
801065bf:	68 90 91 10 80       	push   $0x80109190
801065c4:	53                   	push   %ebx
801065c5:	e8 d6 c9 ff ff       	call   80102fa0 <namecmp>
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	85 c0                	test   %eax,%eax
801065cf:	0f 84 fb 00 00 00    	je     801066d0 <sys_unlink+0x160>
801065d5:	83 ec 08             	sub    $0x8,%esp
801065d8:	68 8f 91 10 80       	push   $0x8010918f
801065dd:	53                   	push   %ebx
801065de:	e8 bd c9 ff ff       	call   80102fa0 <namecmp>
801065e3:	83 c4 10             	add    $0x10,%esp
801065e6:	85 c0                	test   %eax,%eax
801065e8:	0f 84 e2 00 00 00    	je     801066d0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801065ee:	83 ec 04             	sub    $0x4,%esp
801065f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801065f4:	50                   	push   %eax
801065f5:	53                   	push   %ebx
801065f6:	57                   	push   %edi
801065f7:	e8 c4 c9 ff ff       	call   80102fc0 <dirlookup>
801065fc:	83 c4 10             	add    $0x10,%esp
801065ff:	89 c3                	mov    %eax,%ebx
80106601:	85 c0                	test   %eax,%eax
80106603:	0f 84 c7 00 00 00    	je     801066d0 <sys_unlink+0x160>
  ilock(ip);
80106609:	83 ec 0c             	sub    $0xc,%esp
8010660c:	50                   	push   %eax
8010660d:	e8 4e c4 ff ff       	call   80102a60 <ilock>
  if(ip->nlink < 1)
80106612:	83 c4 10             	add    $0x10,%esp
80106615:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010661a:	0f 8e 1c 01 00 00    	jle    8010673c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106620:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106625:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106628:	74 66                	je     80106690 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010662a:	83 ec 04             	sub    $0x4,%esp
8010662d:	6a 10                	push   $0x10
8010662f:	6a 00                	push   $0x0
80106631:	57                   	push   %edi
80106632:	e8 89 f5 ff ff       	call   80105bc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106637:	6a 10                	push   $0x10
80106639:	ff 75 c4             	push   -0x3c(%ebp)
8010663c:	57                   	push   %edi
8010663d:	ff 75 b4             	push   -0x4c(%ebp)
80106640:	e8 2b c8 ff ff       	call   80102e70 <writei>
80106645:	83 c4 20             	add    $0x20,%esp
80106648:	83 f8 10             	cmp    $0x10,%eax
8010664b:	0f 85 de 00 00 00    	jne    8010672f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106651:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106656:	0f 84 94 00 00 00    	je     801066f0 <sys_unlink+0x180>
  iunlockput(dp);
8010665c:	83 ec 0c             	sub    $0xc,%esp
8010665f:	ff 75 b4             	push   -0x4c(%ebp)
80106662:	e8 89 c6 ff ff       	call   80102cf0 <iunlockput>
  ip->nlink--;
80106667:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010666c:	89 1c 24             	mov    %ebx,(%esp)
8010666f:	e8 3c c3 ff ff       	call   801029b0 <iupdate>
  iunlockput(ip);
80106674:	89 1c 24             	mov    %ebx,(%esp)
80106677:	e8 74 c6 ff ff       	call   80102cf0 <iunlockput>
  end_op();
8010667c:	e8 2f da ff ff       	call   801040b0 <end_op>
  return 0;
80106681:	83 c4 10             	add    $0x10,%esp
80106684:	31 c0                	xor    %eax,%eax
}
80106686:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106689:	5b                   	pop    %ebx
8010668a:	5e                   	pop    %esi
8010668b:	5f                   	pop    %edi
8010668c:	5d                   	pop    %ebp
8010668d:	c3                   	ret    
8010668e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106690:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106694:	76 94                	jbe    8010662a <sys_unlink+0xba>
80106696:	be 20 00 00 00       	mov    $0x20,%esi
8010669b:	eb 0b                	jmp    801066a8 <sys_unlink+0x138>
8010669d:	8d 76 00             	lea    0x0(%esi),%esi
801066a0:	83 c6 10             	add    $0x10,%esi
801066a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801066a6:	73 82                	jae    8010662a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801066a8:	6a 10                	push   $0x10
801066aa:	56                   	push   %esi
801066ab:	57                   	push   %edi
801066ac:	53                   	push   %ebx
801066ad:	e8 be c6 ff ff       	call   80102d70 <readi>
801066b2:	83 c4 10             	add    $0x10,%esp
801066b5:	83 f8 10             	cmp    $0x10,%eax
801066b8:	75 68                	jne    80106722 <sys_unlink+0x1b2>
    if(de.inum != 0)
801066ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801066bf:	74 df                	je     801066a0 <sys_unlink+0x130>
    iunlockput(ip);
801066c1:	83 ec 0c             	sub    $0xc,%esp
801066c4:	53                   	push   %ebx
801066c5:	e8 26 c6 ff ff       	call   80102cf0 <iunlockput>
    goto bad;
801066ca:	83 c4 10             	add    $0x10,%esp
801066cd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801066d0:	83 ec 0c             	sub    $0xc,%esp
801066d3:	ff 75 b4             	push   -0x4c(%ebp)
801066d6:	e8 15 c6 ff ff       	call   80102cf0 <iunlockput>
  end_op();
801066db:	e8 d0 d9 ff ff       	call   801040b0 <end_op>
  return -1;
801066e0:	83 c4 10             	add    $0x10,%esp
801066e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e8:	eb 9c                	jmp    80106686 <sys_unlink+0x116>
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801066f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801066f3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801066f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801066fb:	50                   	push   %eax
801066fc:	e8 af c2 ff ff       	call   801029b0 <iupdate>
80106701:	83 c4 10             	add    $0x10,%esp
80106704:	e9 53 ff ff ff       	jmp    8010665c <sys_unlink+0xec>
    return -1;
80106709:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010670e:	e9 73 ff ff ff       	jmp    80106686 <sys_unlink+0x116>
    end_op();
80106713:	e8 98 d9 ff ff       	call   801040b0 <end_op>
    return -1;
80106718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671d:	e9 64 ff ff ff       	jmp    80106686 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106722:	83 ec 0c             	sub    $0xc,%esp
80106725:	68 b4 91 10 80       	push   $0x801091b4
8010672a:	e8 31 9d ff ff       	call   80100460 <panic>
    panic("unlink: writei");
8010672f:	83 ec 0c             	sub    $0xc,%esp
80106732:	68 c6 91 10 80       	push   $0x801091c6
80106737:	e8 24 9d ff ff       	call   80100460 <panic>
    panic("unlink: nlink < 1");
8010673c:	83 ec 0c             	sub    $0xc,%esp
8010673f:	68 a2 91 10 80       	push   $0x801091a2
80106744:	e8 17 9d ff ff       	call   80100460 <panic>
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106750 <sys_open>:

int
sys_open(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106755:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106758:	53                   	push   %ebx
80106759:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010675c:	50                   	push   %eax
8010675d:	6a 00                	push   $0x0
8010675f:	e8 dc f7 ff ff       	call   80105f40 <argstr>
80106764:	83 c4 10             	add    $0x10,%esp
80106767:	85 c0                	test   %eax,%eax
80106769:	0f 88 8e 00 00 00    	js     801067fd <sys_open+0xad>
8010676f:	83 ec 08             	sub    $0x8,%esp
80106772:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106775:	50                   	push   %eax
80106776:	6a 01                	push   $0x1
80106778:	e8 03 f7 ff ff       	call   80105e80 <argint>
8010677d:	83 c4 10             	add    $0x10,%esp
80106780:	85 c0                	test   %eax,%eax
80106782:	78 79                	js     801067fd <sys_open+0xad>
    return -1;

  begin_op();
80106784:	e8 b7 d8 ff ff       	call   80104040 <begin_op>

  if(omode & O_CREATE){
80106789:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010678d:	75 79                	jne    80106808 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010678f:	83 ec 0c             	sub    $0xc,%esp
80106792:	ff 75 e0             	push   -0x20(%ebp)
80106795:	e8 e6 cb ff ff       	call   80103380 <namei>
8010679a:	83 c4 10             	add    $0x10,%esp
8010679d:	89 c6                	mov    %eax,%esi
8010679f:	85 c0                	test   %eax,%eax
801067a1:	0f 84 7e 00 00 00    	je     80106825 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801067a7:	83 ec 0c             	sub    $0xc,%esp
801067aa:	50                   	push   %eax
801067ab:	e8 b0 c2 ff ff       	call   80102a60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801067b0:	83 c4 10             	add    $0x10,%esp
801067b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801067b8:	0f 84 c2 00 00 00    	je     80106880 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801067be:	e8 4d b9 ff ff       	call   80102110 <filealloc>
801067c3:	89 c7                	mov    %eax,%edi
801067c5:	85 c0                	test   %eax,%eax
801067c7:	74 23                	je     801067ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801067c9:	e8 92 e4 ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801067ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801067d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801067d4:	85 d2                	test   %edx,%edx
801067d6:	74 60                	je     80106838 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801067d8:	83 c3 01             	add    $0x1,%ebx
801067db:	83 fb 10             	cmp    $0x10,%ebx
801067de:	75 f0                	jne    801067d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801067e0:	83 ec 0c             	sub    $0xc,%esp
801067e3:	57                   	push   %edi
801067e4:	e8 e7 b9 ff ff       	call   801021d0 <fileclose>
801067e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801067ec:	83 ec 0c             	sub    $0xc,%esp
801067ef:	56                   	push   %esi
801067f0:	e8 fb c4 ff ff       	call   80102cf0 <iunlockput>
    end_op();
801067f5:	e8 b6 d8 ff ff       	call   801040b0 <end_op>
    return -1;
801067fa:	83 c4 10             	add    $0x10,%esp
801067fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106802:	eb 6d                	jmp    80106871 <sys_open+0x121>
80106804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106808:	83 ec 0c             	sub    $0xc,%esp
8010680b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010680e:	31 c9                	xor    %ecx,%ecx
80106810:	ba 02 00 00 00       	mov    $0x2,%edx
80106815:	6a 00                	push   $0x0
80106817:	e8 14 f8 ff ff       	call   80106030 <create>
    if(ip == 0){
8010681c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010681f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106821:	85 c0                	test   %eax,%eax
80106823:	75 99                	jne    801067be <sys_open+0x6e>
      end_op();
80106825:	e8 86 d8 ff ff       	call   801040b0 <end_op>
      return -1;
8010682a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010682f:	eb 40                	jmp    80106871 <sys_open+0x121>
80106831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106838:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010683b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010683f:	56                   	push   %esi
80106840:	e8 fb c2 ff ff       	call   80102b40 <iunlock>
  end_op();
80106845:	e8 66 d8 ff ff       	call   801040b0 <end_op>

  f->type = FD_INODE;
8010684a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106853:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106856:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106859:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010685b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106862:	f7 d0                	not    %eax
80106864:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106867:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010686a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010686d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106874:	89 d8                	mov    %ebx,%eax
80106876:	5b                   	pop    %ebx
80106877:	5e                   	pop    %esi
80106878:	5f                   	pop    %edi
80106879:	5d                   	pop    %ebp
8010687a:	c3                   	ret    
8010687b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010687f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106880:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106883:	85 c9                	test   %ecx,%ecx
80106885:	0f 84 33 ff ff ff    	je     801067be <sys_open+0x6e>
8010688b:	e9 5c ff ff ff       	jmp    801067ec <sys_open+0x9c>

80106890 <sys_mkdir>:

int
sys_mkdir(void)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106896:	e8 a5 d7 ff ff       	call   80104040 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010689b:	83 ec 08             	sub    $0x8,%esp
8010689e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068a1:	50                   	push   %eax
801068a2:	6a 00                	push   $0x0
801068a4:	e8 97 f6 ff ff       	call   80105f40 <argstr>
801068a9:	83 c4 10             	add    $0x10,%esp
801068ac:	85 c0                	test   %eax,%eax
801068ae:	78 30                	js     801068e0 <sys_mkdir+0x50>
801068b0:	83 ec 0c             	sub    $0xc,%esp
801068b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b6:	31 c9                	xor    %ecx,%ecx
801068b8:	ba 01 00 00 00       	mov    $0x1,%edx
801068bd:	6a 00                	push   $0x0
801068bf:	e8 6c f7 ff ff       	call   80106030 <create>
801068c4:	83 c4 10             	add    $0x10,%esp
801068c7:	85 c0                	test   %eax,%eax
801068c9:	74 15                	je     801068e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801068cb:	83 ec 0c             	sub    $0xc,%esp
801068ce:	50                   	push   %eax
801068cf:	e8 1c c4 ff ff       	call   80102cf0 <iunlockput>
  end_op();
801068d4:	e8 d7 d7 ff ff       	call   801040b0 <end_op>
  return 0;
801068d9:	83 c4 10             	add    $0x10,%esp
801068dc:	31 c0                	xor    %eax,%eax
}
801068de:	c9                   	leave  
801068df:	c3                   	ret    
    end_op();
801068e0:	e8 cb d7 ff ff       	call   801040b0 <end_op>
    return -1;
801068e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ea:	c9                   	leave  
801068eb:	c3                   	ret    
801068ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068f0 <sys_mknod>:

int
sys_mknod(void)
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801068f6:	e8 45 d7 ff ff       	call   80104040 <begin_op>
  if((argstr(0, &path)) < 0 ||
801068fb:	83 ec 08             	sub    $0x8,%esp
801068fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106901:	50                   	push   %eax
80106902:	6a 00                	push   $0x0
80106904:	e8 37 f6 ff ff       	call   80105f40 <argstr>
80106909:	83 c4 10             	add    $0x10,%esp
8010690c:	85 c0                	test   %eax,%eax
8010690e:	78 60                	js     80106970 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106910:	83 ec 08             	sub    $0x8,%esp
80106913:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106916:	50                   	push   %eax
80106917:	6a 01                	push   $0x1
80106919:	e8 62 f5 ff ff       	call   80105e80 <argint>
  if((argstr(0, &path)) < 0 ||
8010691e:	83 c4 10             	add    $0x10,%esp
80106921:	85 c0                	test   %eax,%eax
80106923:	78 4b                	js     80106970 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106925:	83 ec 08             	sub    $0x8,%esp
80106928:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010692b:	50                   	push   %eax
8010692c:	6a 02                	push   $0x2
8010692e:	e8 4d f5 ff ff       	call   80105e80 <argint>
     argint(1, &major) < 0 ||
80106933:	83 c4 10             	add    $0x10,%esp
80106936:	85 c0                	test   %eax,%eax
80106938:	78 36                	js     80106970 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010693a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010693e:	83 ec 0c             	sub    $0xc,%esp
80106941:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106945:	ba 03 00 00 00       	mov    $0x3,%edx
8010694a:	50                   	push   %eax
8010694b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010694e:	e8 dd f6 ff ff       	call   80106030 <create>
     argint(2, &minor) < 0 ||
80106953:	83 c4 10             	add    $0x10,%esp
80106956:	85 c0                	test   %eax,%eax
80106958:	74 16                	je     80106970 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010695a:	83 ec 0c             	sub    $0xc,%esp
8010695d:	50                   	push   %eax
8010695e:	e8 8d c3 ff ff       	call   80102cf0 <iunlockput>
  end_op();
80106963:	e8 48 d7 ff ff       	call   801040b0 <end_op>
  return 0;
80106968:	83 c4 10             	add    $0x10,%esp
8010696b:	31 c0                	xor    %eax,%eax
}
8010696d:	c9                   	leave  
8010696e:	c3                   	ret    
8010696f:	90                   	nop
    end_op();
80106970:	e8 3b d7 ff ff       	call   801040b0 <end_op>
    return -1;
80106975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010697a:	c9                   	leave  
8010697b:	c3                   	ret    
8010697c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106980 <sys_chdir>:

int
sys_chdir(void)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	56                   	push   %esi
80106984:	53                   	push   %ebx
80106985:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106988:	e8 d3 e2 ff ff       	call   80104c60 <myproc>
8010698d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010698f:	e8 ac d6 ff ff       	call   80104040 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106994:	83 ec 08             	sub    $0x8,%esp
80106997:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010699a:	50                   	push   %eax
8010699b:	6a 00                	push   $0x0
8010699d:	e8 9e f5 ff ff       	call   80105f40 <argstr>
801069a2:	83 c4 10             	add    $0x10,%esp
801069a5:	85 c0                	test   %eax,%eax
801069a7:	78 77                	js     80106a20 <sys_chdir+0xa0>
801069a9:	83 ec 0c             	sub    $0xc,%esp
801069ac:	ff 75 f4             	push   -0xc(%ebp)
801069af:	e8 cc c9 ff ff       	call   80103380 <namei>
801069b4:	83 c4 10             	add    $0x10,%esp
801069b7:	89 c3                	mov    %eax,%ebx
801069b9:	85 c0                	test   %eax,%eax
801069bb:	74 63                	je     80106a20 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801069bd:	83 ec 0c             	sub    $0xc,%esp
801069c0:	50                   	push   %eax
801069c1:	e8 9a c0 ff ff       	call   80102a60 <ilock>
  if(ip->type != T_DIR){
801069c6:	83 c4 10             	add    $0x10,%esp
801069c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801069ce:	75 30                	jne    80106a00 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801069d0:	83 ec 0c             	sub    $0xc,%esp
801069d3:	53                   	push   %ebx
801069d4:	e8 67 c1 ff ff       	call   80102b40 <iunlock>
  iput(curproc->cwd);
801069d9:	58                   	pop    %eax
801069da:	ff 76 68             	push   0x68(%esi)
801069dd:	e8 ae c1 ff ff       	call   80102b90 <iput>
  end_op();
801069e2:	e8 c9 d6 ff ff       	call   801040b0 <end_op>
  curproc->cwd = ip;
801069e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801069ea:	83 c4 10             	add    $0x10,%esp
801069ed:	31 c0                	xor    %eax,%eax
}
801069ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069f2:	5b                   	pop    %ebx
801069f3:	5e                   	pop    %esi
801069f4:	5d                   	pop    %ebp
801069f5:	c3                   	ret    
801069f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106a00:	83 ec 0c             	sub    $0xc,%esp
80106a03:	53                   	push   %ebx
80106a04:	e8 e7 c2 ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106a09:	e8 a2 d6 ff ff       	call   801040b0 <end_op>
    return -1;
80106a0e:	83 c4 10             	add    $0x10,%esp
80106a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a16:	eb d7                	jmp    801069ef <sys_chdir+0x6f>
80106a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1f:	90                   	nop
    end_op();
80106a20:	e8 8b d6 ff ff       	call   801040b0 <end_op>
    return -1;
80106a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a2a:	eb c3                	jmp    801069ef <sys_chdir+0x6f>
80106a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a30 <sys_exec>:

int
sys_exec(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a35:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106a3b:	53                   	push   %ebx
80106a3c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a42:	50                   	push   %eax
80106a43:	6a 00                	push   $0x0
80106a45:	e8 f6 f4 ff ff       	call   80105f40 <argstr>
80106a4a:	83 c4 10             	add    $0x10,%esp
80106a4d:	85 c0                	test   %eax,%eax
80106a4f:	0f 88 87 00 00 00    	js     80106adc <sys_exec+0xac>
80106a55:	83 ec 08             	sub    $0x8,%esp
80106a58:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106a5e:	50                   	push   %eax
80106a5f:	6a 01                	push   $0x1
80106a61:	e8 1a f4 ff ff       	call   80105e80 <argint>
80106a66:	83 c4 10             	add    $0x10,%esp
80106a69:	85 c0                	test   %eax,%eax
80106a6b:	78 6f                	js     80106adc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106a6d:	83 ec 04             	sub    $0x4,%esp
80106a70:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106a76:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106a78:	68 80 00 00 00       	push   $0x80
80106a7d:	6a 00                	push   $0x0
80106a7f:	56                   	push   %esi
80106a80:	e8 3b f1 ff ff       	call   80105bc0 <memset>
80106a85:	83 c4 10             	add    $0x10,%esp
80106a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a90:	83 ec 08             	sub    $0x8,%esp
80106a93:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106a99:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106aa0:	50                   	push   %eax
80106aa1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106aa7:	01 f8                	add    %edi,%eax
80106aa9:	50                   	push   %eax
80106aaa:	e8 41 f3 ff ff       	call   80105df0 <fetchint>
80106aaf:	83 c4 10             	add    $0x10,%esp
80106ab2:	85 c0                	test   %eax,%eax
80106ab4:	78 26                	js     80106adc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106ab6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106abc:	85 c0                	test   %eax,%eax
80106abe:	74 30                	je     80106af0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106ac0:	83 ec 08             	sub    $0x8,%esp
80106ac3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106ac6:	52                   	push   %edx
80106ac7:	50                   	push   %eax
80106ac8:	e8 63 f3 ff ff       	call   80105e30 <fetchstr>
80106acd:	83 c4 10             	add    $0x10,%esp
80106ad0:	85 c0                	test   %eax,%eax
80106ad2:	78 08                	js     80106adc <sys_exec+0xac>
  for(i=0;; i++){
80106ad4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106ad7:	83 fb 20             	cmp    $0x20,%ebx
80106ada:	75 b4                	jne    80106a90 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106adf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ae4:	5b                   	pop    %ebx
80106ae5:	5e                   	pop    %esi
80106ae6:	5f                   	pop    %edi
80106ae7:	5d                   	pop    %ebp
80106ae8:	c3                   	ret    
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106af0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106af7:	00 00 00 00 
  return exec(path, argv);
80106afb:	83 ec 08             	sub    $0x8,%esp
80106afe:	56                   	push   %esi
80106aff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106b05:	e8 86 b2 ff ff       	call   80101d90 <exec>
80106b0a:	83 c4 10             	add    $0x10,%esp
}
80106b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b10:	5b                   	pop    %ebx
80106b11:	5e                   	pop    %esi
80106b12:	5f                   	pop    %edi
80106b13:	5d                   	pop    %ebp
80106b14:	c3                   	ret    
80106b15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <sys_pipe>:

int
sys_pipe(void)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b25:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106b28:	53                   	push   %ebx
80106b29:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b2c:	6a 08                	push   $0x8
80106b2e:	50                   	push   %eax
80106b2f:	6a 00                	push   $0x0
80106b31:	e8 9a f3 ff ff       	call   80105ed0 <argptr>
80106b36:	83 c4 10             	add    $0x10,%esp
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	78 4a                	js     80106b87 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106b3d:	83 ec 08             	sub    $0x8,%esp
80106b40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b43:	50                   	push   %eax
80106b44:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b47:	50                   	push   %eax
80106b48:	e8 c3 db ff ff       	call   80104710 <pipealloc>
80106b4d:	83 c4 10             	add    $0x10,%esp
80106b50:	85 c0                	test   %eax,%eax
80106b52:	78 33                	js     80106b87 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b54:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106b57:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106b59:	e8 02 e1 ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106b5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106b60:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106b64:	85 f6                	test   %esi,%esi
80106b66:	74 28                	je     80106b90 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106b68:	83 c3 01             	add    $0x1,%ebx
80106b6b:	83 fb 10             	cmp    $0x10,%ebx
80106b6e:	75 f0                	jne    80106b60 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106b70:	83 ec 0c             	sub    $0xc,%esp
80106b73:	ff 75 e0             	push   -0x20(%ebp)
80106b76:	e8 55 b6 ff ff       	call   801021d0 <fileclose>
    fileclose(wf);
80106b7b:	58                   	pop    %eax
80106b7c:	ff 75 e4             	push   -0x1c(%ebp)
80106b7f:	e8 4c b6 ff ff       	call   801021d0 <fileclose>
    return -1;
80106b84:	83 c4 10             	add    $0x10,%esp
80106b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b8c:	eb 53                	jmp    80106be1 <sys_pipe+0xc1>
80106b8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106b90:	8d 73 08             	lea    0x8(%ebx),%esi
80106b93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106b9a:	e8 c1 e0 ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106b9f:	31 d2                	xor    %edx,%edx
80106ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106ba8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106bac:	85 c9                	test   %ecx,%ecx
80106bae:	74 20                	je     80106bd0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106bb0:	83 c2 01             	add    $0x1,%edx
80106bb3:	83 fa 10             	cmp    $0x10,%edx
80106bb6:	75 f0                	jne    80106ba8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106bb8:	e8 a3 e0 ff ff       	call   80104c60 <myproc>
80106bbd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106bc4:	00 
80106bc5:	eb a9                	jmp    80106b70 <sys_pipe+0x50>
80106bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106bd0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106bd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bd7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106bd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bdc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106bdf:	31 c0                	xor    %eax,%eax
}
80106be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be4:	5b                   	pop    %ebx
80106be5:	5e                   	pop    %esi
80106be6:	5f                   	pop    %edi
80106be7:	5d                   	pop    %ebp
80106be8:	c3                   	ret    
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <sys_move_file>:

int sys_move_file(void)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
  struct inode *ip_src, *dp_des, *dp_src;
  char name[DIRSIZ];
  uint off;
  struct dirent de;

  if (argstr(0, &path_src) < 0 || argstr(1, &path_des) < 0){
80106bf5:	8d 45 bc             	lea    -0x44(%ebp),%eax
{
80106bf8:	53                   	push   %ebx
80106bf9:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path_src) < 0 || argstr(1, &path_des) < 0){
80106bfc:	50                   	push   %eax
80106bfd:	6a 00                	push   $0x0
80106bff:	e8 3c f3 ff ff       	call   80105f40 <argstr>
80106c04:	83 c4 10             	add    $0x10,%esp
80106c07:	85 c0                	test   %eax,%eax
80106c09:	0f 88 42 01 00 00    	js     80106d51 <sys_move_file+0x161>
80106c0f:	83 ec 08             	sub    $0x8,%esp
80106c12:	8d 45 c0             	lea    -0x40(%ebp),%eax
80106c15:	50                   	push   %eax
80106c16:	6a 01                	push   $0x1
80106c18:	e8 23 f3 ff ff       	call   80105f40 <argstr>
80106c1d:	83 c4 10             	add    $0x10,%esp
80106c20:	85 c0                	test   %eax,%eax
80106c22:	0f 88 29 01 00 00    	js     80106d51 <sys_move_file+0x161>
    return -1;
  }

  cprintf("Source path: %s\n", path_src);
80106c28:	83 ec 08             	sub    $0x8,%esp
80106c2b:	ff 75 bc             	push   -0x44(%ebp)
80106c2e:	68 d5 91 10 80       	push   $0x801091d5
80106c33:	e8 a8 9b ff ff       	call   801007e0 <cprintf>
  cprintf("Destination directory: %s\n", path_des);
80106c38:	58                   	pop    %eax
80106c39:	5a                   	pop    %edx
80106c3a:	ff 75 c0             	push   -0x40(%ebp)
80106c3d:	68 e6 91 10 80       	push   $0x801091e6
80106c42:	e8 99 9b ff ff       	call   801007e0 <cprintf>

  ip_src = namei(path_src);
80106c47:	59                   	pop    %ecx
80106c48:	ff 75 bc             	push   -0x44(%ebp)
80106c4b:	e8 30 c7 ff ff       	call   80103380 <namei>
  if (ip_src == 0)
80106c50:	83 c4 10             	add    $0x10,%esp
80106c53:	85 c0                	test   %eax,%eax
80106c55:	0f 84 51 01 00 00    	je     80106dac <sys_move_file+0x1bc>
  {
    cprintf("Error: Source file not found\n");
    return -1;
  }
  if (ip_src->type != T_FILE)
80106c5b:	66 83 78 50 02       	cmpw   $0x2,0x50(%eax)
80106c60:	0f 85 fa 00 00 00    	jne    80106d60 <sys_move_file+0x170>
  {
    cprintf("Error: Source is not a regular file\n");
    return -1;
  }

  begin_op();
80106c66:	e8 d5 d3 ff ff       	call   80104040 <begin_op>
  if ((dp_src = nameiparent(path_src, name)) == 0)
80106c6b:	8d 7d ca             	lea    -0x36(%ebp),%edi
80106c6e:	83 ec 08             	sub    $0x8,%esp
80106c71:	57                   	push   %edi
80106c72:	ff 75 bc             	push   -0x44(%ebp)
80106c75:	e8 26 c7 ff ff       	call   801033a0 <nameiparent>
80106c7a:	83 c4 10             	add    $0x10,%esp
80106c7d:	89 c3                	mov    %eax,%ebx
80106c7f:	85 c0                	test   %eax,%eax
80106c81:	0f 84 19 01 00 00    	je     80106da0 <sys_move_file+0x1b0>
  {
    end_op();
    return -1;
  }

  if ((ip_src = dirlookup(dp_src, name, &off)) == 0)
80106c87:	83 ec 04             	sub    $0x4,%esp
80106c8a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106c8d:	50                   	push   %eax
80106c8e:	57                   	push   %edi
80106c8f:	53                   	push   %ebx
80106c90:	e8 2b c3 ff ff       	call   80102fc0 <dirlookup>
80106c95:	83 c4 10             	add    $0x10,%esp
80106c98:	89 c6                	mov    %eax,%esi
80106c9a:	85 c0                	test   %eax,%eax
80106c9c:	0f 84 fe 00 00 00    	je     80106da0 <sys_move_file+0x1b0>
  {
    end_op();
    return -1;
  }

  if ((dp_des = namei(path_des)) == 0)
80106ca2:	83 ec 0c             	sub    $0xc,%esp
80106ca5:	ff 75 c0             	push   -0x40(%ebp)
80106ca8:	e8 d3 c6 ff ff       	call   80103380 <namei>
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	85 c0                	test   %eax,%eax
80106cb2:	0f 84 e8 00 00 00    	je     80106da0 <sys_move_file+0x1b0>
  {
    end_op();
    return -1;
  }

  ilock(dp_des);
80106cb8:	83 ec 0c             	sub    $0xc,%esp
80106cbb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106cbe:	50                   	push   %eax
80106cbf:	e8 9c bd ff ff       	call   80102a60 <ilock>
  if (dp_des->dev != ip_src->dev || dirlink(dp_des, name, ip_src->inum) < 0)
80106cc4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80106cc7:	8b 06                	mov    (%esi),%eax
80106cc9:	83 c4 10             	add    $0x10,%esp
80106ccc:	39 02                	cmp    %eax,(%edx)
80106cce:	75 70                	jne    80106d40 <sys_move_file+0x150>
80106cd0:	83 ec 04             	sub    $0x4,%esp
80106cd3:	ff 76 04             	push   0x4(%esi)
80106cd6:	57                   	push   %edi
80106cd7:	52                   	push   %edx
80106cd8:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80106cdb:	e8 e0 c5 ff ff       	call   801032c0 <dirlink>
80106ce0:	83 c4 10             	add    $0x10,%esp
80106ce3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80106ce6:	85 c0                	test   %eax,%eax
80106ce8:	78 56                	js     80106d40 <sys_move_file+0x150>
  {
    iunlockput(dp_des);
    end_op();
    return -1;
  }
  iunlockput(dp_des);
80106cea:	83 ec 0c             	sub    $0xc,%esp

  ilock(dp_src);

  memset(&de, 0, sizeof(de));
80106ced:	8d 75 d8             	lea    -0x28(%ebp),%esi
  iunlockput(dp_des);
80106cf0:	52                   	push   %edx
80106cf1:	e8 fa bf ff ff       	call   80102cf0 <iunlockput>
  ilock(dp_src);
80106cf6:	89 1c 24             	mov    %ebx,(%esp)
80106cf9:	e8 62 bd ff ff       	call   80102a60 <ilock>
  memset(&de, 0, sizeof(de));
80106cfe:	83 c4 0c             	add    $0xc,%esp
80106d01:	6a 10                	push   $0x10
80106d03:	6a 00                	push   $0x0
80106d05:	56                   	push   %esi
80106d06:	e8 b5 ee ff ff       	call   80105bc0 <memset>
  if (writei(dp_src, (char *)&de, off, sizeof(de)) != sizeof(de))
80106d0b:	6a 10                	push   $0x10
80106d0d:	ff 75 c4             	push   -0x3c(%ebp)
80106d10:	56                   	push   %esi
80106d11:	53                   	push   %ebx
80106d12:	e8 59 c1 ff ff       	call   80102e70 <writei>
80106d17:	83 c4 20             	add    $0x20,%esp
80106d1a:	83 f8 10             	cmp    $0x10,%eax
80106d1d:	75 61                	jne    80106d80 <sys_move_file+0x190>
  {
    iunlockput(dp_src);
    end_op();
    return -1;
  }
  iunlockput(dp_src);
80106d1f:	83 ec 0c             	sub    $0xc,%esp
80106d22:	53                   	push   %ebx
80106d23:	e8 c8 bf ff ff       	call   80102cf0 <iunlockput>

  end_op();
80106d28:	e8 83 d3 ff ff       	call   801040b0 <end_op>
  return 0;
80106d2d:	83 c4 10             	add    $0x10,%esp
80106d30:	31 c0                	xor    %eax,%eax
80106d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
80106d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp_des);
80106d40:	83 ec 0c             	sub    $0xc,%esp
80106d43:	52                   	push   %edx
80106d44:	e8 a7 bf ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106d49:	e8 62 d3 ff ff       	call   801040b0 <end_op>
    return -1;
80106d4e:	83 c4 10             	add    $0x10,%esp
80106d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d56:	eb da                	jmp    80106d32 <sys_move_file+0x142>
80106d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d5f:	90                   	nop
    cprintf("Error: Source is not a regular file\n");
80106d60:	83 ec 0c             	sub    $0xc,%esp
80106d63:	68 20 92 10 80       	push   $0x80109220
80106d68:	e8 73 9a ff ff       	call   801007e0 <cprintf>
    return -1;
80106d6d:	83 c4 10             	add    $0x10,%esp
80106d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d75:	eb bb                	jmp    80106d32 <sys_move_file+0x142>
80106d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7e:	66 90                	xchg   %ax,%ax
    iunlockput(dp_src);
80106d80:	83 ec 0c             	sub    $0xc,%esp
80106d83:	53                   	push   %ebx
80106d84:	e8 67 bf ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106d89:	e8 22 d3 ff ff       	call   801040b0 <end_op>
    return -1;
80106d8e:	83 c4 10             	add    $0x10,%esp
80106d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d96:	eb 9a                	jmp    80106d32 <sys_move_file+0x142>
80106d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop
    end_op();
80106da0:	e8 0b d3 ff ff       	call   801040b0 <end_op>
    return -1;
80106da5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106daa:	eb 86                	jmp    80106d32 <sys_move_file+0x142>
    cprintf("Error: Source file not found\n");
80106dac:	83 ec 0c             	sub    $0xc,%esp
80106daf:	68 01 92 10 80       	push   $0x80109201
80106db4:	e8 27 9a ff ff       	call   801007e0 <cprintf>
    return -1;
80106db9:	83 c4 10             	add    $0x10,%esp
80106dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc1:	e9 6c ff ff ff       	jmp    80106d32 <sys_move_file+0x142>
80106dc6:	66 90                	xchg   %ax,%ax
80106dc8:	66 90                	xchg   %ax,%ax
80106dca:	66 90                	xchg   %ax,%ax
80106dcc:	66 90                	xchg   %ax,%ax
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <sys_fork>:

#define MAXPATH 1024 

int sys_fork(void)
{
  return fork();
80106dd0:	e9 2b e0 ff ff       	jmp    80104e00 <fork>
80106dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106de0 <sys_exit>:
}

int sys_exit(void)
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	83 ec 08             	sub    $0x8,%esp
  exit();
80106de6:	e8 95 e2 ff ff       	call   80105080 <exit>
  return 0; // not reached
}
80106deb:	31 c0                	xor    %eax,%eax
80106ded:	c9                   	leave  
80106dee:	c3                   	ret    
80106def:	90                   	nop

80106df0 <sys_wait>:

int sys_wait(void)
{
  return wait();
80106df0:	e9 bb e3 ff ff       	jmp    801051b0 <wait>
80106df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e00 <sys_kill>:
}

int sys_kill(void)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106e06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e09:	50                   	push   %eax
80106e0a:	6a 00                	push   $0x0
80106e0c:	e8 6f f0 ff ff       	call   80105e80 <argint>
80106e11:	83 c4 10             	add    $0x10,%esp
80106e14:	85 c0                	test   %eax,%eax
80106e16:	78 18                	js     80106e30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106e18:	83 ec 0c             	sub    $0xc,%esp
80106e1b:	ff 75 f4             	push   -0xc(%ebp)
80106e1e:	e8 2d e6 ff ff       	call   80105450 <kill>
80106e23:	83 c4 10             	add    $0x10,%esp
}
80106e26:	c9                   	leave  
80106e27:	c3                   	ret    
80106e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2f:	90                   	nop
80106e30:	c9                   	leave  
    return -1;
80106e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e36:	c3                   	ret    
80106e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <sys_getpid>:

int sys_getpid(void)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106e46:	e8 15 de ff ff       	call   80104c60 <myproc>
80106e4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80106e4e:	c9                   	leave  
80106e4f:	c3                   	ret    

80106e50 <sys_sbrk>:

int sys_sbrk(void)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106e54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106e57:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80106e5a:	50                   	push   %eax
80106e5b:	6a 00                	push   $0x0
80106e5d:	e8 1e f0 ff ff       	call   80105e80 <argint>
80106e62:	83 c4 10             	add    $0x10,%esp
80106e65:	85 c0                	test   %eax,%eax
80106e67:	78 27                	js     80106e90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106e69:	e8 f2 dd ff ff       	call   80104c60 <myproc>
  if (growproc(n) < 0)
80106e6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106e71:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106e73:	ff 75 f4             	push   -0xc(%ebp)
80106e76:	e8 05 df ff ff       	call   80104d80 <growproc>
80106e7b:	83 c4 10             	add    $0x10,%esp
80106e7e:	85 c0                	test   %eax,%eax
80106e80:	78 0e                	js     80106e90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106e82:	89 d8                	mov    %ebx,%eax
80106e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106e87:	c9                   	leave  
80106e88:	c3                   	ret    
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106e90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106e95:	eb eb                	jmp    80106e82 <sys_sbrk+0x32>
80106e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9e:	66 90                	xchg   %ax,%ax

80106ea0 <sys_sleep>:

int sys_sleep(void)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80106ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106ea7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80106eaa:	50                   	push   %eax
80106eab:	6a 00                	push   $0x0
80106ead:	e8 ce ef ff ff       	call   80105e80 <argint>
80106eb2:	83 c4 10             	add    $0x10,%esp
80106eb5:	85 c0                	test   %eax,%eax
80106eb7:	0f 88 8a 00 00 00    	js     80106f47 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106ebd:	83 ec 0c             	sub    $0xc,%esp
80106ec0:	68 20 cd 11 80       	push   $0x8011cd20
80106ec5:	e8 36 ec ff ff       	call   80105b00 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80106eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106ecd:	8b 1d 00 cd 11 80    	mov    0x8011cd00,%ebx
  while (ticks - ticks0 < n)
80106ed3:	83 c4 10             	add    $0x10,%esp
80106ed6:	85 d2                	test   %edx,%edx
80106ed8:	75 27                	jne    80106f01 <sys_sleep+0x61>
80106eda:	eb 54                	jmp    80106f30 <sys_sleep+0x90>
80106edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106ee0:	83 ec 08             	sub    $0x8,%esp
80106ee3:	68 20 cd 11 80       	push   $0x8011cd20
80106ee8:	68 00 cd 11 80       	push   $0x8011cd00
80106eed:	e8 3e e4 ff ff       	call   80105330 <sleep>
  while (ticks - ticks0 < n)
80106ef2:	a1 00 cd 11 80       	mov    0x8011cd00,%eax
80106ef7:	83 c4 10             	add    $0x10,%esp
80106efa:	29 d8                	sub    %ebx,%eax
80106efc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106eff:	73 2f                	jae    80106f30 <sys_sleep+0x90>
    if (myproc()->killed)
80106f01:	e8 5a dd ff ff       	call   80104c60 <myproc>
80106f06:	8b 40 24             	mov    0x24(%eax),%eax
80106f09:	85 c0                	test   %eax,%eax
80106f0b:	74 d3                	je     80106ee0 <sys_sleep+0x40>
      release(&tickslock);
80106f0d:	83 ec 0c             	sub    $0xc,%esp
80106f10:	68 20 cd 11 80       	push   $0x8011cd20
80106f15:	e8 86 eb ff ff       	call   80105aa0 <release>
  }
  release(&tickslock);
  return 0;
}
80106f1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106f1d:	83 c4 10             	add    $0x10,%esp
80106f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f25:	c9                   	leave  
80106f26:	c3                   	ret    
80106f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106f30:	83 ec 0c             	sub    $0xc,%esp
80106f33:	68 20 cd 11 80       	push   $0x8011cd20
80106f38:	e8 63 eb ff ff       	call   80105aa0 <release>
  return 0;
80106f3d:	83 c4 10             	add    $0x10,%esp
80106f40:	31 c0                	xor    %eax,%eax
}
80106f42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f45:	c9                   	leave  
80106f46:	c3                   	ret    
    return -1;
80106f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f4c:	eb f4                	jmp    80106f42 <sys_sleep+0xa2>
80106f4e:	66 90                	xchg   %ax,%ax

80106f50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	53                   	push   %ebx
80106f54:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106f57:	68 20 cd 11 80       	push   $0x8011cd20
80106f5c:	e8 9f eb ff ff       	call   80105b00 <acquire>
  xticks = ticks;
80106f61:	8b 1d 00 cd 11 80    	mov    0x8011cd00,%ebx
  release(&tickslock);
80106f67:	c7 04 24 20 cd 11 80 	movl   $0x8011cd20,(%esp)
80106f6e:	e8 2d eb ff ff       	call   80105aa0 <release>
  return xticks;
}
80106f73:	89 d8                	mov    %ebx,%eax
80106f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f78:	c9                   	leave  
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f80 <sys_my_syscall>:
int sys_my_syscall(void)
{
  // This can be anything, such as printing a message
  // printf(1, "My system call was invoked!\n");
  return 0; // You can return any value, or multiple values
}
80106f80:	31 c0                	xor    %eax,%eax
80106f82:	c3                   	ret    
80106f83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f90 <sys_sort_syscalls>:


int sys_sort_syscalls()
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80106f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f99:	50                   	push   %eax
80106f9a:	6a 00                	push   $0x0
80106f9c:	e8 df ee ff ff       	call   80105e80 <argint>
80106fa1:	83 c4 10             	add    $0x10,%esp
80106fa4:	85 c0                	test   %eax,%eax
80106fa6:	78 18                	js     80106fc0 <sys_sort_syscalls+0x30>
  {
    return -1; // Return error if pid is not provided
  }
  return sort_uniqe_procces(pid);
80106fa8:	83 ec 0c             	sub    $0xc,%esp
80106fab:	ff 75 f4             	push   -0xc(%ebp)
80106fae:	e8 dd e5 ff ff       	call   80105590 <sort_uniqe_procces>
80106fb3:	83 c4 10             	add    $0x10,%esp
} 
80106fb6:	c9                   	leave  
80106fb7:	c3                   	ret    
80106fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbf:	90                   	nop
80106fc0:	c9                   	leave  
    return -1; // Return error if pid is not provided
80106fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
} 
80106fc6:	c3                   	ret    
80106fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fce:	66 90                	xchg   %ax,%ax

80106fd0 <sys_get_most_invoked_syscalls>:
int sys_get_most_invoked_syscalls()
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80106fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fd9:	50                   	push   %eax
80106fda:	6a 00                	push   $0x0
80106fdc:	e8 9f ee ff ff       	call   80105e80 <argint>
80106fe1:	83 c4 10             	add    $0x10,%esp
80106fe4:	85 c0                	test   %eax,%eax
80106fe6:	78 18                	js     80107000 <sys_get_most_invoked_syscalls+0x30>
  {
    return -1; // Return error if pid is not provided
  }
  return get_max_invoked(pid);
80106fe8:	83 ec 0c             	sub    $0xc,%esp
80106feb:	ff 75 f4             	push   -0xc(%ebp)
80106fee:	e8 7d e6 ff ff       	call   80105670 <get_max_invoked>
80106ff3:	83 c4 10             	add    $0x10,%esp
} 
80106ff6:	c9                   	leave  
80106ff7:	c3                   	ret    
80106ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fff:	90                   	nop
80107000:	c9                   	leave  
    return -1; // Return error if pid is not provided
80107001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
} 
80107006:	c3                   	ret    

80107007 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107007:	1e                   	push   %ds
  pushl %es
80107008:	06                   	push   %es
  pushl %fs
80107009:	0f a0                	push   %fs
  pushl %gs
8010700b:	0f a8                	push   %gs
  pushal
8010700d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010700e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107012:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107014:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107016:	54                   	push   %esp
  call trap
80107017:	e8 c4 00 00 00       	call   801070e0 <trap>
  addl $4, %esp
8010701c:	83 c4 04             	add    $0x4,%esp

8010701f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010701f:	61                   	popa   
  popl %gs
80107020:	0f a9                	pop    %gs
  popl %fs
80107022:	0f a1                	pop    %fs
  popl %es
80107024:	07                   	pop    %es
  popl %ds
80107025:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107026:	83 c4 08             	add    $0x8,%esp
  iret
80107029:	cf                   	iret   
8010702a:	66 90                	xchg   %ax,%ax
8010702c:	66 90                	xchg   %ax,%ax
8010702e:	66 90                	xchg   %ax,%ax

80107030 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80107030:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80107031:	31 c0                	xor    %eax,%eax
{
80107033:	89 e5                	mov    %esp,%ebp
80107035:	83 ec 08             	sub    $0x8,%esp
80107038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80107040:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80107047:	c7 04 c5 62 cd 11 80 	movl   $0x8e000008,-0x7fee329e(,%eax,8)
8010704e:	08 00 00 8e 
80107052:	66 89 14 c5 60 cd 11 	mov    %dx,-0x7fee32a0(,%eax,8)
80107059:	80 
8010705a:	c1 ea 10             	shr    $0x10,%edx
8010705d:	66 89 14 c5 66 cd 11 	mov    %dx,-0x7fee329a(,%eax,8)
80107064:	80 
  for (i = 0; i < 256; i++)
80107065:	83 c0 01             	add    $0x1,%eax
80107068:	3d 00 01 00 00       	cmp    $0x100,%eax
8010706d:	75 d1                	jne    80107040 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010706f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80107072:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107077:	c7 05 62 cf 11 80 08 	movl   $0xef000008,0x8011cf62
8010707e:	00 00 ef 
  initlock(&tickslock, "time");
80107081:	68 45 92 10 80       	push   $0x80109245
80107086:	68 20 cd 11 80       	push   $0x8011cd20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010708b:	66 a3 60 cf 11 80    	mov    %ax,0x8011cf60
80107091:	c1 e8 10             	shr    $0x10,%eax
80107094:	66 a3 66 cf 11 80    	mov    %ax,0x8011cf66
  initlock(&tickslock, "time");
8010709a:	e8 91 e8 ff ff       	call   80105930 <initlock>
}
8010709f:	83 c4 10             	add    $0x10,%esp
801070a2:	c9                   	leave  
801070a3:	c3                   	ret    
801070a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070af:	90                   	nop

801070b0 <idtinit>:

void idtinit(void)
{
801070b0:	55                   	push   %ebp
  pd[0] = size-1;
801070b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801070b6:	89 e5                	mov    %esp,%ebp
801070b8:	83 ec 10             	sub    $0x10,%esp
801070bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801070bf:	b8 60 cd 11 80       	mov    $0x8011cd60,%eax
801070c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801070c8:	c1 e8 10             	shr    $0x10,%eax
801070cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801070cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801070d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801070d5:	c9                   	leave  
801070d6:	c3                   	ret    
801070d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070de:	66 90                	xchg   %ax,%ax

801070e0 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
801070ec:	8b 43 30             	mov    0x30(%ebx),%eax
801070ef:	83 f8 40             	cmp    $0x40,%eax
801070f2:	0f 84 68 01 00 00    	je     80107260 <trap+0x180>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
801070f8:	83 e8 20             	sub    $0x20,%eax
801070fb:	83 f8 1f             	cmp    $0x1f,%eax
801070fe:	0f 87 8c 00 00 00    	ja     80107190 <trap+0xb0>
80107104:	ff 24 85 ec 92 10 80 	jmp    *-0x7fef6d14(,%eax,4)
8010710b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107110:	e8 0b c4 ff ff       	call   80103520 <ideintr>
    lapiceoi();
80107115:	e8 d6 ca ff ff       	call   80103bf0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010711a:	e8 41 db ff ff       	call   80104c60 <myproc>
8010711f:	85 c0                	test   %eax,%eax
80107121:	74 1d                	je     80107140 <trap+0x60>
80107123:	e8 38 db ff ff       	call   80104c60 <myproc>
80107128:	8b 50 24             	mov    0x24(%eax),%edx
8010712b:	85 d2                	test   %edx,%edx
8010712d:	74 11                	je     80107140 <trap+0x60>
8010712f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107133:	83 e0 03             	and    $0x3,%eax
80107136:	66 83 f8 03          	cmp    $0x3,%ax
8010713a:	0f 84 f8 01 00 00    	je     80107338 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
80107140:	e8 1b db ff ff       	call   80104c60 <myproc>
80107145:	85 c0                	test   %eax,%eax
80107147:	74 0f                	je     80107158 <trap+0x78>
80107149:	e8 12 db ff ff       	call   80104c60 <myproc>
8010714e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107152:	0f 84 b8 00 00 00    	je     80107210 <trap+0x130>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107158:	e8 03 db ff ff       	call   80104c60 <myproc>
8010715d:	85 c0                	test   %eax,%eax
8010715f:	74 1d                	je     8010717e <trap+0x9e>
80107161:	e8 fa da ff ff       	call   80104c60 <myproc>
80107166:	8b 40 24             	mov    0x24(%eax),%eax
80107169:	85 c0                	test   %eax,%eax
8010716b:	74 11                	je     8010717e <trap+0x9e>
8010716d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107171:	83 e0 03             	and    $0x3,%eax
80107174:	66 83 f8 03          	cmp    $0x3,%ax
80107178:	0f 84 21 01 00 00    	je     8010729f <trap+0x1bf>
    exit();
}
8010717e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107181:	5b                   	pop    %ebx
80107182:	5e                   	pop    %esi
80107183:	5f                   	pop    %edi
80107184:	5d                   	pop    %ebp
80107185:	c3                   	ret    
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() == 0 || (tf->cs & 3) == 0)
80107190:	e8 cb da ff ff       	call   80104c60 <myproc>
80107195:	8b 7b 38             	mov    0x38(%ebx),%edi
80107198:	85 c0                	test   %eax,%eax
8010719a:	0f 84 df 01 00 00    	je     8010737f <trap+0x29f>
801071a0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801071a4:	0f 84 d5 01 00 00    	je     8010737f <trap+0x29f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801071aa:	0f 20 d1             	mov    %cr2,%ecx
801071ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071b0:	e8 8b da ff ff       	call   80104c40 <cpuid>
801071b5:	8b 73 30             	mov    0x30(%ebx),%esi
801071b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071bb:	8b 43 34             	mov    0x34(%ebx),%eax
801071be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801071c1:	e8 9a da ff ff       	call   80104c60 <myproc>
801071c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c9:	e8 92 da ff ff       	call   80104c60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801071d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801071d4:	51                   	push   %ecx
801071d5:	57                   	push   %edi
801071d6:	52                   	push   %edx
801071d7:	ff 75 e4             	push   -0x1c(%ebp)
801071da:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801071db:	8b 75 e0             	mov    -0x20(%ebp),%esi
801071de:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071e1:	56                   	push   %esi
801071e2:	ff 70 10             	push   0x10(%eax)
801071e5:	68 a8 92 10 80       	push   $0x801092a8
801071ea:	e8 f1 95 ff ff       	call   801007e0 <cprintf>
    myproc()->killed = 1;
801071ef:	83 c4 20             	add    $0x20,%esp
801071f2:	e8 69 da ff ff       	call   80104c60 <myproc>
801071f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801071fe:	e8 5d da ff ff       	call   80104c60 <myproc>
80107203:	85 c0                	test   %eax,%eax
80107205:	0f 85 18 ff ff ff    	jne    80107123 <trap+0x43>
8010720b:	e9 30 ff ff ff       	jmp    80107140 <trap+0x60>
  if (myproc() && myproc()->state == RUNNING &&
80107210:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107214:	0f 85 3e ff ff ff    	jne    80107158 <trap+0x78>
    yield();
8010721a:	e8 c1 e0 ff ff       	call   801052e0 <yield>
8010721f:	e9 34 ff ff ff       	jmp    80107158 <trap+0x78>
80107224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107228:	8b 7b 38             	mov    0x38(%ebx),%edi
8010722b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010722f:	e8 0c da ff ff       	call   80104c40 <cpuid>
80107234:	57                   	push   %edi
80107235:	56                   	push   %esi
80107236:	50                   	push   %eax
80107237:	68 50 92 10 80       	push   $0x80109250
8010723c:	e8 9f 95 ff ff       	call   801007e0 <cprintf>
    lapiceoi();
80107241:	e8 aa c9 ff ff       	call   80103bf0 <lapiceoi>
    break;
80107246:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107249:	e8 12 da ff ff       	call   80104c60 <myproc>
8010724e:	85 c0                	test   %eax,%eax
80107250:	0f 85 cd fe ff ff    	jne    80107123 <trap+0x43>
80107256:	e9 e5 fe ff ff       	jmp    80107140 <trap+0x60>
8010725b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010725f:	90                   	nop
    if (myproc()->killed)
80107260:	e8 fb d9 ff ff       	call   80104c60 <myproc>
80107265:	8b 70 24             	mov    0x24(%eax),%esi
80107268:	85 f6                	test   %esi,%esi
8010726a:	0f 85 d8 00 00 00    	jne    80107348 <trap+0x268>
    if (myproc()->numsystemcalls < 100)
80107270:	e8 eb d9 ff ff       	call   80104c60 <myproc>
80107275:	83 b8 0c 02 00 00 63 	cmpl   $0x63,0x20c(%eax)
8010727c:	0f 8e d6 00 00 00    	jle    80107358 <trap+0x278>
    myproc()->tf = tf;
80107282:	e8 d9 d9 ff ff       	call   80104c60 <myproc>
80107287:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010728a:	e8 31 ed ff ff       	call   80105fc0 <syscall>
    if (myproc()->killed)
8010728f:	e8 cc d9 ff ff       	call   80104c60 <myproc>
80107294:	8b 48 24             	mov    0x24(%eax),%ecx
80107297:	85 c9                	test   %ecx,%ecx
80107299:	0f 84 df fe ff ff    	je     8010717e <trap+0x9e>
}
8010729f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a2:	5b                   	pop    %ebx
801072a3:	5e                   	pop    %esi
801072a4:	5f                   	pop    %edi
801072a5:	5d                   	pop    %ebp
      exit();
801072a6:	e9 d5 dd ff ff       	jmp    80105080 <exit>
801072ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop
    uartintr();
801072b0:	e8 6b 02 00 00       	call   80107520 <uartintr>
    lapiceoi();
801072b5:	e8 36 c9 ff ff       	call   80103bf0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801072ba:	e8 a1 d9 ff ff       	call   80104c60 <myproc>
801072bf:	85 c0                	test   %eax,%eax
801072c1:	0f 85 5c fe ff ff    	jne    80107123 <trap+0x43>
801072c7:	e9 74 fe ff ff       	jmp    80107140 <trap+0x60>
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801072d0:	e8 db c7 ff ff       	call   80103ab0 <kbdintr>
    lapiceoi();
801072d5:	e8 16 c9 ff ff       	call   80103bf0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801072da:	e8 81 d9 ff ff       	call   80104c60 <myproc>
801072df:	85 c0                	test   %eax,%eax
801072e1:	0f 85 3c fe ff ff    	jne    80107123 <trap+0x43>
801072e7:	e9 54 fe ff ff       	jmp    80107140 <trap+0x60>
801072ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpuid() == 0)
801072f0:	e8 4b d9 ff ff       	call   80104c40 <cpuid>
801072f5:	85 c0                	test   %eax,%eax
801072f7:	0f 85 18 fe ff ff    	jne    80107115 <trap+0x35>
      acquire(&tickslock);
801072fd:	83 ec 0c             	sub    $0xc,%esp
80107300:	68 20 cd 11 80       	push   $0x8011cd20
80107305:	e8 f6 e7 ff ff       	call   80105b00 <acquire>
      wakeup(&ticks);
8010730a:	c7 04 24 00 cd 11 80 	movl   $0x8011cd00,(%esp)
      ticks++;
80107311:	83 05 00 cd 11 80 01 	addl   $0x1,0x8011cd00
      wakeup(&ticks);
80107318:	e8 d3 e0 ff ff       	call   801053f0 <wakeup>
      release(&tickslock);
8010731d:	c7 04 24 20 cd 11 80 	movl   $0x8011cd20,(%esp)
80107324:	e8 77 e7 ff ff       	call   80105aa0 <release>
80107329:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010732c:	e9 e4 fd ff ff       	jmp    80107115 <trap+0x35>
80107331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107338:	e8 43 dd ff ff       	call   80105080 <exit>
8010733d:	e9 fe fd ff ff       	jmp    80107140 <trap+0x60>
80107342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107348:	e8 33 dd ff ff       	call   80105080 <exit>
8010734d:	e9 1e ff ff ff       	jmp    80107270 <trap+0x190>
80107352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      myproc()->systemcalls[myproc()->numsystemcalls++] = tf->eax;
80107358:	8b 7b 1c             	mov    0x1c(%ebx),%edi
8010735b:	e8 00 d9 ff ff       	call   80104c60 <myproc>
80107360:	89 c6                	mov    %eax,%esi
80107362:	e8 f9 d8 ff ff       	call   80104c60 <myproc>
80107367:	8b 90 0c 02 00 00    	mov    0x20c(%eax),%edx
8010736d:	8d 4a 01             	lea    0x1(%edx),%ecx
80107370:	89 88 0c 02 00 00    	mov    %ecx,0x20c(%eax)
80107376:	89 7c 96 7c          	mov    %edi,0x7c(%esi,%edx,4)
8010737a:	e9 03 ff ff ff       	jmp    80107282 <trap+0x1a2>
8010737f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107382:	e8 b9 d8 ff ff       	call   80104c40 <cpuid>
80107387:	83 ec 0c             	sub    $0xc,%esp
8010738a:	56                   	push   %esi
8010738b:	57                   	push   %edi
8010738c:	50                   	push   %eax
8010738d:	ff 73 30             	push   0x30(%ebx)
80107390:	68 74 92 10 80       	push   $0x80109274
80107395:	e8 46 94 ff ff       	call   801007e0 <cprintf>
      panic("trap");
8010739a:	83 c4 14             	add    $0x14,%esp
8010739d:	68 4a 92 10 80       	push   $0x8010924a
801073a2:	e8 b9 90 ff ff       	call   80100460 <panic>
801073a7:	66 90                	xchg   %ax,%ax
801073a9:	66 90                	xchg   %ax,%ax
801073ab:	66 90                	xchg   %ax,%ax
801073ad:	66 90                	xchg   %ax,%ax
801073af:	90                   	nop

801073b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801073b0:	a1 60 d5 11 80       	mov    0x8011d560,%eax
801073b5:	85 c0                	test   %eax,%eax
801073b7:	74 17                	je     801073d0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801073b9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801073be:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801073bf:	a8 01                	test   $0x1,%al
801073c1:	74 0d                	je     801073d0 <uartgetc+0x20>
801073c3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801073c8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801073c9:	0f b6 c0             	movzbl %al,%eax
801073cc:	c3                   	ret    
801073cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801073d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073d5:	c3                   	ret    
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi

801073e0 <uartinit>:
{
801073e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801073e1:	31 c9                	xor    %ecx,%ecx
801073e3:	89 c8                	mov    %ecx,%eax
801073e5:	89 e5                	mov    %esp,%ebp
801073e7:	57                   	push   %edi
801073e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801073ed:	56                   	push   %esi
801073ee:	89 fa                	mov    %edi,%edx
801073f0:	53                   	push   %ebx
801073f1:	83 ec 1c             	sub    $0x1c,%esp
801073f4:	ee                   	out    %al,(%dx)
801073f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801073fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801073ff:	89 f2                	mov    %esi,%edx
80107401:	ee                   	out    %al,(%dx)
80107402:	b8 0c 00 00 00       	mov    $0xc,%eax
80107407:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010740c:	ee                   	out    %al,(%dx)
8010740d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107412:	89 c8                	mov    %ecx,%eax
80107414:	89 da                	mov    %ebx,%edx
80107416:	ee                   	out    %al,(%dx)
80107417:	b8 03 00 00 00       	mov    $0x3,%eax
8010741c:	89 f2                	mov    %esi,%edx
8010741e:	ee                   	out    %al,(%dx)
8010741f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107424:	89 c8                	mov    %ecx,%eax
80107426:	ee                   	out    %al,(%dx)
80107427:	b8 01 00 00 00       	mov    $0x1,%eax
8010742c:	89 da                	mov    %ebx,%edx
8010742e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010742f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107434:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107435:	3c ff                	cmp    $0xff,%al
80107437:	74 78                	je     801074b1 <uartinit+0xd1>
  uart = 1;
80107439:	c7 05 60 d5 11 80 01 	movl   $0x1,0x8011d560
80107440:	00 00 00 
80107443:	89 fa                	mov    %edi,%edx
80107445:	ec                   	in     (%dx),%al
80107446:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010744b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010744c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010744f:	bf 6c 93 10 80       	mov    $0x8010936c,%edi
80107454:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107459:	6a 00                	push   $0x0
8010745b:	6a 04                	push   $0x4
8010745d:	e8 fe c2 ff ff       	call   80103760 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107462:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107466:	83 c4 10             	add    $0x10,%esp
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80107470:	a1 60 d5 11 80       	mov    0x8011d560,%eax
80107475:	bb 80 00 00 00       	mov    $0x80,%ebx
8010747a:	85 c0                	test   %eax,%eax
8010747c:	75 14                	jne    80107492 <uartinit+0xb2>
8010747e:	eb 23                	jmp    801074a3 <uartinit+0xc3>
    microdelay(10);
80107480:	83 ec 0c             	sub    $0xc,%esp
80107483:	6a 0a                	push   $0xa
80107485:	e8 86 c7 ff ff       	call   80103c10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010748a:	83 c4 10             	add    $0x10,%esp
8010748d:	83 eb 01             	sub    $0x1,%ebx
80107490:	74 07                	je     80107499 <uartinit+0xb9>
80107492:	89 f2                	mov    %esi,%edx
80107494:	ec                   	in     (%dx),%al
80107495:	a8 20                	test   $0x20,%al
80107497:	74 e7                	je     80107480 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107499:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010749d:	ba f8 03 00 00       	mov    $0x3f8,%edx
801074a2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801074a3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801074a7:	83 c7 01             	add    $0x1,%edi
801074aa:	88 45 e7             	mov    %al,-0x19(%ebp)
801074ad:	84 c0                	test   %al,%al
801074af:	75 bf                	jne    80107470 <uartinit+0x90>
}
801074b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074b4:	5b                   	pop    %ebx
801074b5:	5e                   	pop    %esi
801074b6:	5f                   	pop    %edi
801074b7:	5d                   	pop    %ebp
801074b8:	c3                   	ret    
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074c0 <uartputc>:
  if(!uart)
801074c0:	a1 60 d5 11 80       	mov    0x8011d560,%eax
801074c5:	85 c0                	test   %eax,%eax
801074c7:	74 47                	je     80107510 <uartputc+0x50>
{
801074c9:	55                   	push   %ebp
801074ca:	89 e5                	mov    %esp,%ebp
801074cc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801074cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801074d2:	53                   	push   %ebx
801074d3:	bb 80 00 00 00       	mov    $0x80,%ebx
801074d8:	eb 18                	jmp    801074f2 <uartputc+0x32>
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801074e0:	83 ec 0c             	sub    $0xc,%esp
801074e3:	6a 0a                	push   $0xa
801074e5:	e8 26 c7 ff ff       	call   80103c10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801074ea:	83 c4 10             	add    $0x10,%esp
801074ed:	83 eb 01             	sub    $0x1,%ebx
801074f0:	74 07                	je     801074f9 <uartputc+0x39>
801074f2:	89 f2                	mov    %esi,%edx
801074f4:	ec                   	in     (%dx),%al
801074f5:	a8 20                	test   $0x20,%al
801074f7:	74 e7                	je     801074e0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801074f9:	8b 45 08             	mov    0x8(%ebp),%eax
801074fc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107501:	ee                   	out    %al,(%dx)
}
80107502:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107505:	5b                   	pop    %ebx
80107506:	5e                   	pop    %esi
80107507:	5d                   	pop    %ebp
80107508:	c3                   	ret    
80107509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107510:	c3                   	ret    
80107511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751f:	90                   	nop

80107520 <uartintr>:

void
uartintr(void)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107526:	68 b0 73 10 80       	push   $0x801073b0
8010752b:	e8 10 a2 ff ff       	call   80101740 <consoleintr>
}
80107530:	83 c4 10             	add    $0x10,%esp
80107533:	c9                   	leave  
80107534:	c3                   	ret    

80107535 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $0
80107537:	6a 00                	push   $0x0
  jmp alltraps
80107539:	e9 c9 fa ff ff       	jmp    80107007 <alltraps>

8010753e <vector1>:
.globl vector1
vector1:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $1
80107540:	6a 01                	push   $0x1
  jmp alltraps
80107542:	e9 c0 fa ff ff       	jmp    80107007 <alltraps>

80107547 <vector2>:
.globl vector2
vector2:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $2
80107549:	6a 02                	push   $0x2
  jmp alltraps
8010754b:	e9 b7 fa ff ff       	jmp    80107007 <alltraps>

80107550 <vector3>:
.globl vector3
vector3:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $3
80107552:	6a 03                	push   $0x3
  jmp alltraps
80107554:	e9 ae fa ff ff       	jmp    80107007 <alltraps>

80107559 <vector4>:
.globl vector4
vector4:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $4
8010755b:	6a 04                	push   $0x4
  jmp alltraps
8010755d:	e9 a5 fa ff ff       	jmp    80107007 <alltraps>

80107562 <vector5>:
.globl vector5
vector5:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $5
80107564:	6a 05                	push   $0x5
  jmp alltraps
80107566:	e9 9c fa ff ff       	jmp    80107007 <alltraps>

8010756b <vector6>:
.globl vector6
vector6:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $6
8010756d:	6a 06                	push   $0x6
  jmp alltraps
8010756f:	e9 93 fa ff ff       	jmp    80107007 <alltraps>

80107574 <vector7>:
.globl vector7
vector7:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $7
80107576:	6a 07                	push   $0x7
  jmp alltraps
80107578:	e9 8a fa ff ff       	jmp    80107007 <alltraps>

8010757d <vector8>:
.globl vector8
vector8:
  pushl $8
8010757d:	6a 08                	push   $0x8
  jmp alltraps
8010757f:	e9 83 fa ff ff       	jmp    80107007 <alltraps>

80107584 <vector9>:
.globl vector9
vector9:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $9
80107586:	6a 09                	push   $0x9
  jmp alltraps
80107588:	e9 7a fa ff ff       	jmp    80107007 <alltraps>

8010758d <vector10>:
.globl vector10
vector10:
  pushl $10
8010758d:	6a 0a                	push   $0xa
  jmp alltraps
8010758f:	e9 73 fa ff ff       	jmp    80107007 <alltraps>

80107594 <vector11>:
.globl vector11
vector11:
  pushl $11
80107594:	6a 0b                	push   $0xb
  jmp alltraps
80107596:	e9 6c fa ff ff       	jmp    80107007 <alltraps>

8010759b <vector12>:
.globl vector12
vector12:
  pushl $12
8010759b:	6a 0c                	push   $0xc
  jmp alltraps
8010759d:	e9 65 fa ff ff       	jmp    80107007 <alltraps>

801075a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801075a2:	6a 0d                	push   $0xd
  jmp alltraps
801075a4:	e9 5e fa ff ff       	jmp    80107007 <alltraps>

801075a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801075a9:	6a 0e                	push   $0xe
  jmp alltraps
801075ab:	e9 57 fa ff ff       	jmp    80107007 <alltraps>

801075b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $15
801075b2:	6a 0f                	push   $0xf
  jmp alltraps
801075b4:	e9 4e fa ff ff       	jmp    80107007 <alltraps>

801075b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $16
801075bb:	6a 10                	push   $0x10
  jmp alltraps
801075bd:	e9 45 fa ff ff       	jmp    80107007 <alltraps>

801075c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801075c2:	6a 11                	push   $0x11
  jmp alltraps
801075c4:	e9 3e fa ff ff       	jmp    80107007 <alltraps>

801075c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $18
801075cb:	6a 12                	push   $0x12
  jmp alltraps
801075cd:	e9 35 fa ff ff       	jmp    80107007 <alltraps>

801075d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $19
801075d4:	6a 13                	push   $0x13
  jmp alltraps
801075d6:	e9 2c fa ff ff       	jmp    80107007 <alltraps>

801075db <vector20>:
.globl vector20
vector20:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $20
801075dd:	6a 14                	push   $0x14
  jmp alltraps
801075df:	e9 23 fa ff ff       	jmp    80107007 <alltraps>

801075e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $21
801075e6:	6a 15                	push   $0x15
  jmp alltraps
801075e8:	e9 1a fa ff ff       	jmp    80107007 <alltraps>

801075ed <vector22>:
.globl vector22
vector22:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $22
801075ef:	6a 16                	push   $0x16
  jmp alltraps
801075f1:	e9 11 fa ff ff       	jmp    80107007 <alltraps>

801075f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $23
801075f8:	6a 17                	push   $0x17
  jmp alltraps
801075fa:	e9 08 fa ff ff       	jmp    80107007 <alltraps>

801075ff <vector24>:
.globl vector24
vector24:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $24
80107601:	6a 18                	push   $0x18
  jmp alltraps
80107603:	e9 ff f9 ff ff       	jmp    80107007 <alltraps>

80107608 <vector25>:
.globl vector25
vector25:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $25
8010760a:	6a 19                	push   $0x19
  jmp alltraps
8010760c:	e9 f6 f9 ff ff       	jmp    80107007 <alltraps>

80107611 <vector26>:
.globl vector26
vector26:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $26
80107613:	6a 1a                	push   $0x1a
  jmp alltraps
80107615:	e9 ed f9 ff ff       	jmp    80107007 <alltraps>

8010761a <vector27>:
.globl vector27
vector27:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $27
8010761c:	6a 1b                	push   $0x1b
  jmp alltraps
8010761e:	e9 e4 f9 ff ff       	jmp    80107007 <alltraps>

80107623 <vector28>:
.globl vector28
vector28:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $28
80107625:	6a 1c                	push   $0x1c
  jmp alltraps
80107627:	e9 db f9 ff ff       	jmp    80107007 <alltraps>

8010762c <vector29>:
.globl vector29
vector29:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $29
8010762e:	6a 1d                	push   $0x1d
  jmp alltraps
80107630:	e9 d2 f9 ff ff       	jmp    80107007 <alltraps>

80107635 <vector30>:
.globl vector30
vector30:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $30
80107637:	6a 1e                	push   $0x1e
  jmp alltraps
80107639:	e9 c9 f9 ff ff       	jmp    80107007 <alltraps>

8010763e <vector31>:
.globl vector31
vector31:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $31
80107640:	6a 1f                	push   $0x1f
  jmp alltraps
80107642:	e9 c0 f9 ff ff       	jmp    80107007 <alltraps>

80107647 <vector32>:
.globl vector32
vector32:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $32
80107649:	6a 20                	push   $0x20
  jmp alltraps
8010764b:	e9 b7 f9 ff ff       	jmp    80107007 <alltraps>

80107650 <vector33>:
.globl vector33
vector33:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $33
80107652:	6a 21                	push   $0x21
  jmp alltraps
80107654:	e9 ae f9 ff ff       	jmp    80107007 <alltraps>

80107659 <vector34>:
.globl vector34
vector34:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $34
8010765b:	6a 22                	push   $0x22
  jmp alltraps
8010765d:	e9 a5 f9 ff ff       	jmp    80107007 <alltraps>

80107662 <vector35>:
.globl vector35
vector35:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $35
80107664:	6a 23                	push   $0x23
  jmp alltraps
80107666:	e9 9c f9 ff ff       	jmp    80107007 <alltraps>

8010766b <vector36>:
.globl vector36
vector36:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $36
8010766d:	6a 24                	push   $0x24
  jmp alltraps
8010766f:	e9 93 f9 ff ff       	jmp    80107007 <alltraps>

80107674 <vector37>:
.globl vector37
vector37:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $37
80107676:	6a 25                	push   $0x25
  jmp alltraps
80107678:	e9 8a f9 ff ff       	jmp    80107007 <alltraps>

8010767d <vector38>:
.globl vector38
vector38:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $38
8010767f:	6a 26                	push   $0x26
  jmp alltraps
80107681:	e9 81 f9 ff ff       	jmp    80107007 <alltraps>

80107686 <vector39>:
.globl vector39
vector39:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $39
80107688:	6a 27                	push   $0x27
  jmp alltraps
8010768a:	e9 78 f9 ff ff       	jmp    80107007 <alltraps>

8010768f <vector40>:
.globl vector40
vector40:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $40
80107691:	6a 28                	push   $0x28
  jmp alltraps
80107693:	e9 6f f9 ff ff       	jmp    80107007 <alltraps>

80107698 <vector41>:
.globl vector41
vector41:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $41
8010769a:	6a 29                	push   $0x29
  jmp alltraps
8010769c:	e9 66 f9 ff ff       	jmp    80107007 <alltraps>

801076a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $42
801076a3:	6a 2a                	push   $0x2a
  jmp alltraps
801076a5:	e9 5d f9 ff ff       	jmp    80107007 <alltraps>

801076aa <vector43>:
.globl vector43
vector43:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $43
801076ac:	6a 2b                	push   $0x2b
  jmp alltraps
801076ae:	e9 54 f9 ff ff       	jmp    80107007 <alltraps>

801076b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $44
801076b5:	6a 2c                	push   $0x2c
  jmp alltraps
801076b7:	e9 4b f9 ff ff       	jmp    80107007 <alltraps>

801076bc <vector45>:
.globl vector45
vector45:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $45
801076be:	6a 2d                	push   $0x2d
  jmp alltraps
801076c0:	e9 42 f9 ff ff       	jmp    80107007 <alltraps>

801076c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $46
801076c7:	6a 2e                	push   $0x2e
  jmp alltraps
801076c9:	e9 39 f9 ff ff       	jmp    80107007 <alltraps>

801076ce <vector47>:
.globl vector47
vector47:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $47
801076d0:	6a 2f                	push   $0x2f
  jmp alltraps
801076d2:	e9 30 f9 ff ff       	jmp    80107007 <alltraps>

801076d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $48
801076d9:	6a 30                	push   $0x30
  jmp alltraps
801076db:	e9 27 f9 ff ff       	jmp    80107007 <alltraps>

801076e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $49
801076e2:	6a 31                	push   $0x31
  jmp alltraps
801076e4:	e9 1e f9 ff ff       	jmp    80107007 <alltraps>

801076e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $50
801076eb:	6a 32                	push   $0x32
  jmp alltraps
801076ed:	e9 15 f9 ff ff       	jmp    80107007 <alltraps>

801076f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $51
801076f4:	6a 33                	push   $0x33
  jmp alltraps
801076f6:	e9 0c f9 ff ff       	jmp    80107007 <alltraps>

801076fb <vector52>:
.globl vector52
vector52:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $52
801076fd:	6a 34                	push   $0x34
  jmp alltraps
801076ff:	e9 03 f9 ff ff       	jmp    80107007 <alltraps>

80107704 <vector53>:
.globl vector53
vector53:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $53
80107706:	6a 35                	push   $0x35
  jmp alltraps
80107708:	e9 fa f8 ff ff       	jmp    80107007 <alltraps>

8010770d <vector54>:
.globl vector54
vector54:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $54
8010770f:	6a 36                	push   $0x36
  jmp alltraps
80107711:	e9 f1 f8 ff ff       	jmp    80107007 <alltraps>

80107716 <vector55>:
.globl vector55
vector55:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $55
80107718:	6a 37                	push   $0x37
  jmp alltraps
8010771a:	e9 e8 f8 ff ff       	jmp    80107007 <alltraps>

8010771f <vector56>:
.globl vector56
vector56:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $56
80107721:	6a 38                	push   $0x38
  jmp alltraps
80107723:	e9 df f8 ff ff       	jmp    80107007 <alltraps>

80107728 <vector57>:
.globl vector57
vector57:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $57
8010772a:	6a 39                	push   $0x39
  jmp alltraps
8010772c:	e9 d6 f8 ff ff       	jmp    80107007 <alltraps>

80107731 <vector58>:
.globl vector58
vector58:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $58
80107733:	6a 3a                	push   $0x3a
  jmp alltraps
80107735:	e9 cd f8 ff ff       	jmp    80107007 <alltraps>

8010773a <vector59>:
.globl vector59
vector59:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $59
8010773c:	6a 3b                	push   $0x3b
  jmp alltraps
8010773e:	e9 c4 f8 ff ff       	jmp    80107007 <alltraps>

80107743 <vector60>:
.globl vector60
vector60:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $60
80107745:	6a 3c                	push   $0x3c
  jmp alltraps
80107747:	e9 bb f8 ff ff       	jmp    80107007 <alltraps>

8010774c <vector61>:
.globl vector61
vector61:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $61
8010774e:	6a 3d                	push   $0x3d
  jmp alltraps
80107750:	e9 b2 f8 ff ff       	jmp    80107007 <alltraps>

80107755 <vector62>:
.globl vector62
vector62:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $62
80107757:	6a 3e                	push   $0x3e
  jmp alltraps
80107759:	e9 a9 f8 ff ff       	jmp    80107007 <alltraps>

8010775e <vector63>:
.globl vector63
vector63:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $63
80107760:	6a 3f                	push   $0x3f
  jmp alltraps
80107762:	e9 a0 f8 ff ff       	jmp    80107007 <alltraps>

80107767 <vector64>:
.globl vector64
vector64:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $64
80107769:	6a 40                	push   $0x40
  jmp alltraps
8010776b:	e9 97 f8 ff ff       	jmp    80107007 <alltraps>

80107770 <vector65>:
.globl vector65
vector65:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $65
80107772:	6a 41                	push   $0x41
  jmp alltraps
80107774:	e9 8e f8 ff ff       	jmp    80107007 <alltraps>

80107779 <vector66>:
.globl vector66
vector66:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $66
8010777b:	6a 42                	push   $0x42
  jmp alltraps
8010777d:	e9 85 f8 ff ff       	jmp    80107007 <alltraps>

80107782 <vector67>:
.globl vector67
vector67:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $67
80107784:	6a 43                	push   $0x43
  jmp alltraps
80107786:	e9 7c f8 ff ff       	jmp    80107007 <alltraps>

8010778b <vector68>:
.globl vector68
vector68:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $68
8010778d:	6a 44                	push   $0x44
  jmp alltraps
8010778f:	e9 73 f8 ff ff       	jmp    80107007 <alltraps>

80107794 <vector69>:
.globl vector69
vector69:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $69
80107796:	6a 45                	push   $0x45
  jmp alltraps
80107798:	e9 6a f8 ff ff       	jmp    80107007 <alltraps>

8010779d <vector70>:
.globl vector70
vector70:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $70
8010779f:	6a 46                	push   $0x46
  jmp alltraps
801077a1:	e9 61 f8 ff ff       	jmp    80107007 <alltraps>

801077a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $71
801077a8:	6a 47                	push   $0x47
  jmp alltraps
801077aa:	e9 58 f8 ff ff       	jmp    80107007 <alltraps>

801077af <vector72>:
.globl vector72
vector72:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $72
801077b1:	6a 48                	push   $0x48
  jmp alltraps
801077b3:	e9 4f f8 ff ff       	jmp    80107007 <alltraps>

801077b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801077b8:	6a 00                	push   $0x0
  pushl $73
801077ba:	6a 49                	push   $0x49
  jmp alltraps
801077bc:	e9 46 f8 ff ff       	jmp    80107007 <alltraps>

801077c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $74
801077c3:	6a 4a                	push   $0x4a
  jmp alltraps
801077c5:	e9 3d f8 ff ff       	jmp    80107007 <alltraps>

801077ca <vector75>:
.globl vector75
vector75:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $75
801077cc:	6a 4b                	push   $0x4b
  jmp alltraps
801077ce:	e9 34 f8 ff ff       	jmp    80107007 <alltraps>

801077d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $76
801077d5:	6a 4c                	push   $0x4c
  jmp alltraps
801077d7:	e9 2b f8 ff ff       	jmp    80107007 <alltraps>

801077dc <vector77>:
.globl vector77
vector77:
  pushl $0
801077dc:	6a 00                	push   $0x0
  pushl $77
801077de:	6a 4d                	push   $0x4d
  jmp alltraps
801077e0:	e9 22 f8 ff ff       	jmp    80107007 <alltraps>

801077e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $78
801077e7:	6a 4e                	push   $0x4e
  jmp alltraps
801077e9:	e9 19 f8 ff ff       	jmp    80107007 <alltraps>

801077ee <vector79>:
.globl vector79
vector79:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $79
801077f0:	6a 4f                	push   $0x4f
  jmp alltraps
801077f2:	e9 10 f8 ff ff       	jmp    80107007 <alltraps>

801077f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $80
801077f9:	6a 50                	push   $0x50
  jmp alltraps
801077fb:	e9 07 f8 ff ff       	jmp    80107007 <alltraps>

80107800 <vector81>:
.globl vector81
vector81:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $81
80107802:	6a 51                	push   $0x51
  jmp alltraps
80107804:	e9 fe f7 ff ff       	jmp    80107007 <alltraps>

80107809 <vector82>:
.globl vector82
vector82:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $82
8010780b:	6a 52                	push   $0x52
  jmp alltraps
8010780d:	e9 f5 f7 ff ff       	jmp    80107007 <alltraps>

80107812 <vector83>:
.globl vector83
vector83:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $83
80107814:	6a 53                	push   $0x53
  jmp alltraps
80107816:	e9 ec f7 ff ff       	jmp    80107007 <alltraps>

8010781b <vector84>:
.globl vector84
vector84:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $84
8010781d:	6a 54                	push   $0x54
  jmp alltraps
8010781f:	e9 e3 f7 ff ff       	jmp    80107007 <alltraps>

80107824 <vector85>:
.globl vector85
vector85:
  pushl $0
80107824:	6a 00                	push   $0x0
  pushl $85
80107826:	6a 55                	push   $0x55
  jmp alltraps
80107828:	e9 da f7 ff ff       	jmp    80107007 <alltraps>

8010782d <vector86>:
.globl vector86
vector86:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $86
8010782f:	6a 56                	push   $0x56
  jmp alltraps
80107831:	e9 d1 f7 ff ff       	jmp    80107007 <alltraps>

80107836 <vector87>:
.globl vector87
vector87:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $87
80107838:	6a 57                	push   $0x57
  jmp alltraps
8010783a:	e9 c8 f7 ff ff       	jmp    80107007 <alltraps>

8010783f <vector88>:
.globl vector88
vector88:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $88
80107841:	6a 58                	push   $0x58
  jmp alltraps
80107843:	e9 bf f7 ff ff       	jmp    80107007 <alltraps>

80107848 <vector89>:
.globl vector89
vector89:
  pushl $0
80107848:	6a 00                	push   $0x0
  pushl $89
8010784a:	6a 59                	push   $0x59
  jmp alltraps
8010784c:	e9 b6 f7 ff ff       	jmp    80107007 <alltraps>

80107851 <vector90>:
.globl vector90
vector90:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $90
80107853:	6a 5a                	push   $0x5a
  jmp alltraps
80107855:	e9 ad f7 ff ff       	jmp    80107007 <alltraps>

8010785a <vector91>:
.globl vector91
vector91:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $91
8010785c:	6a 5b                	push   $0x5b
  jmp alltraps
8010785e:	e9 a4 f7 ff ff       	jmp    80107007 <alltraps>

80107863 <vector92>:
.globl vector92
vector92:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $92
80107865:	6a 5c                	push   $0x5c
  jmp alltraps
80107867:	e9 9b f7 ff ff       	jmp    80107007 <alltraps>

8010786c <vector93>:
.globl vector93
vector93:
  pushl $0
8010786c:	6a 00                	push   $0x0
  pushl $93
8010786e:	6a 5d                	push   $0x5d
  jmp alltraps
80107870:	e9 92 f7 ff ff       	jmp    80107007 <alltraps>

80107875 <vector94>:
.globl vector94
vector94:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $94
80107877:	6a 5e                	push   $0x5e
  jmp alltraps
80107879:	e9 89 f7 ff ff       	jmp    80107007 <alltraps>

8010787e <vector95>:
.globl vector95
vector95:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $95
80107880:	6a 5f                	push   $0x5f
  jmp alltraps
80107882:	e9 80 f7 ff ff       	jmp    80107007 <alltraps>

80107887 <vector96>:
.globl vector96
vector96:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $96
80107889:	6a 60                	push   $0x60
  jmp alltraps
8010788b:	e9 77 f7 ff ff       	jmp    80107007 <alltraps>

80107890 <vector97>:
.globl vector97
vector97:
  pushl $0
80107890:	6a 00                	push   $0x0
  pushl $97
80107892:	6a 61                	push   $0x61
  jmp alltraps
80107894:	e9 6e f7 ff ff       	jmp    80107007 <alltraps>

80107899 <vector98>:
.globl vector98
vector98:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $98
8010789b:	6a 62                	push   $0x62
  jmp alltraps
8010789d:	e9 65 f7 ff ff       	jmp    80107007 <alltraps>

801078a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $99
801078a4:	6a 63                	push   $0x63
  jmp alltraps
801078a6:	e9 5c f7 ff ff       	jmp    80107007 <alltraps>

801078ab <vector100>:
.globl vector100
vector100:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $100
801078ad:	6a 64                	push   $0x64
  jmp alltraps
801078af:	e9 53 f7 ff ff       	jmp    80107007 <alltraps>

801078b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801078b4:	6a 00                	push   $0x0
  pushl $101
801078b6:	6a 65                	push   $0x65
  jmp alltraps
801078b8:	e9 4a f7 ff ff       	jmp    80107007 <alltraps>

801078bd <vector102>:
.globl vector102
vector102:
  pushl $0
801078bd:	6a 00                	push   $0x0
  pushl $102
801078bf:	6a 66                	push   $0x66
  jmp alltraps
801078c1:	e9 41 f7 ff ff       	jmp    80107007 <alltraps>

801078c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $103
801078c8:	6a 67                	push   $0x67
  jmp alltraps
801078ca:	e9 38 f7 ff ff       	jmp    80107007 <alltraps>

801078cf <vector104>:
.globl vector104
vector104:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $104
801078d1:	6a 68                	push   $0x68
  jmp alltraps
801078d3:	e9 2f f7 ff ff       	jmp    80107007 <alltraps>

801078d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801078d8:	6a 00                	push   $0x0
  pushl $105
801078da:	6a 69                	push   $0x69
  jmp alltraps
801078dc:	e9 26 f7 ff ff       	jmp    80107007 <alltraps>

801078e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801078e1:	6a 00                	push   $0x0
  pushl $106
801078e3:	6a 6a                	push   $0x6a
  jmp alltraps
801078e5:	e9 1d f7 ff ff       	jmp    80107007 <alltraps>

801078ea <vector107>:
.globl vector107
vector107:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $107
801078ec:	6a 6b                	push   $0x6b
  jmp alltraps
801078ee:	e9 14 f7 ff ff       	jmp    80107007 <alltraps>

801078f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $108
801078f5:	6a 6c                	push   $0x6c
  jmp alltraps
801078f7:	e9 0b f7 ff ff       	jmp    80107007 <alltraps>

801078fc <vector109>:
.globl vector109
vector109:
  pushl $0
801078fc:	6a 00                	push   $0x0
  pushl $109
801078fe:	6a 6d                	push   $0x6d
  jmp alltraps
80107900:	e9 02 f7 ff ff       	jmp    80107007 <alltraps>

80107905 <vector110>:
.globl vector110
vector110:
  pushl $0
80107905:	6a 00                	push   $0x0
  pushl $110
80107907:	6a 6e                	push   $0x6e
  jmp alltraps
80107909:	e9 f9 f6 ff ff       	jmp    80107007 <alltraps>

8010790e <vector111>:
.globl vector111
vector111:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $111
80107910:	6a 6f                	push   $0x6f
  jmp alltraps
80107912:	e9 f0 f6 ff ff       	jmp    80107007 <alltraps>

80107917 <vector112>:
.globl vector112
vector112:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $112
80107919:	6a 70                	push   $0x70
  jmp alltraps
8010791b:	e9 e7 f6 ff ff       	jmp    80107007 <alltraps>

80107920 <vector113>:
.globl vector113
vector113:
  pushl $0
80107920:	6a 00                	push   $0x0
  pushl $113
80107922:	6a 71                	push   $0x71
  jmp alltraps
80107924:	e9 de f6 ff ff       	jmp    80107007 <alltraps>

80107929 <vector114>:
.globl vector114
vector114:
  pushl $0
80107929:	6a 00                	push   $0x0
  pushl $114
8010792b:	6a 72                	push   $0x72
  jmp alltraps
8010792d:	e9 d5 f6 ff ff       	jmp    80107007 <alltraps>

80107932 <vector115>:
.globl vector115
vector115:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $115
80107934:	6a 73                	push   $0x73
  jmp alltraps
80107936:	e9 cc f6 ff ff       	jmp    80107007 <alltraps>

8010793b <vector116>:
.globl vector116
vector116:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $116
8010793d:	6a 74                	push   $0x74
  jmp alltraps
8010793f:	e9 c3 f6 ff ff       	jmp    80107007 <alltraps>

80107944 <vector117>:
.globl vector117
vector117:
  pushl $0
80107944:	6a 00                	push   $0x0
  pushl $117
80107946:	6a 75                	push   $0x75
  jmp alltraps
80107948:	e9 ba f6 ff ff       	jmp    80107007 <alltraps>

8010794d <vector118>:
.globl vector118
vector118:
  pushl $0
8010794d:	6a 00                	push   $0x0
  pushl $118
8010794f:	6a 76                	push   $0x76
  jmp alltraps
80107951:	e9 b1 f6 ff ff       	jmp    80107007 <alltraps>

80107956 <vector119>:
.globl vector119
vector119:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $119
80107958:	6a 77                	push   $0x77
  jmp alltraps
8010795a:	e9 a8 f6 ff ff       	jmp    80107007 <alltraps>

8010795f <vector120>:
.globl vector120
vector120:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $120
80107961:	6a 78                	push   $0x78
  jmp alltraps
80107963:	e9 9f f6 ff ff       	jmp    80107007 <alltraps>

80107968 <vector121>:
.globl vector121
vector121:
  pushl $0
80107968:	6a 00                	push   $0x0
  pushl $121
8010796a:	6a 79                	push   $0x79
  jmp alltraps
8010796c:	e9 96 f6 ff ff       	jmp    80107007 <alltraps>

80107971 <vector122>:
.globl vector122
vector122:
  pushl $0
80107971:	6a 00                	push   $0x0
  pushl $122
80107973:	6a 7a                	push   $0x7a
  jmp alltraps
80107975:	e9 8d f6 ff ff       	jmp    80107007 <alltraps>

8010797a <vector123>:
.globl vector123
vector123:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $123
8010797c:	6a 7b                	push   $0x7b
  jmp alltraps
8010797e:	e9 84 f6 ff ff       	jmp    80107007 <alltraps>

80107983 <vector124>:
.globl vector124
vector124:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $124
80107985:	6a 7c                	push   $0x7c
  jmp alltraps
80107987:	e9 7b f6 ff ff       	jmp    80107007 <alltraps>

8010798c <vector125>:
.globl vector125
vector125:
  pushl $0
8010798c:	6a 00                	push   $0x0
  pushl $125
8010798e:	6a 7d                	push   $0x7d
  jmp alltraps
80107990:	e9 72 f6 ff ff       	jmp    80107007 <alltraps>

80107995 <vector126>:
.globl vector126
vector126:
  pushl $0
80107995:	6a 00                	push   $0x0
  pushl $126
80107997:	6a 7e                	push   $0x7e
  jmp alltraps
80107999:	e9 69 f6 ff ff       	jmp    80107007 <alltraps>

8010799e <vector127>:
.globl vector127
vector127:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $127
801079a0:	6a 7f                	push   $0x7f
  jmp alltraps
801079a2:	e9 60 f6 ff ff       	jmp    80107007 <alltraps>

801079a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $128
801079a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801079ae:	e9 54 f6 ff ff       	jmp    80107007 <alltraps>

801079b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $129
801079b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801079ba:	e9 48 f6 ff ff       	jmp    80107007 <alltraps>

801079bf <vector130>:
.globl vector130
vector130:
  pushl $0
801079bf:	6a 00                	push   $0x0
  pushl $130
801079c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801079c6:	e9 3c f6 ff ff       	jmp    80107007 <alltraps>

801079cb <vector131>:
.globl vector131
vector131:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $131
801079cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801079d2:	e9 30 f6 ff ff       	jmp    80107007 <alltraps>

801079d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $132
801079d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801079de:	e9 24 f6 ff ff       	jmp    80107007 <alltraps>

801079e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801079e3:	6a 00                	push   $0x0
  pushl $133
801079e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801079ea:	e9 18 f6 ff ff       	jmp    80107007 <alltraps>

801079ef <vector134>:
.globl vector134
vector134:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $134
801079f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801079f6:	e9 0c f6 ff ff       	jmp    80107007 <alltraps>

801079fb <vector135>:
.globl vector135
vector135:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $135
801079fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107a02:	e9 00 f6 ff ff       	jmp    80107007 <alltraps>

80107a07 <vector136>:
.globl vector136
vector136:
  pushl $0
80107a07:	6a 00                	push   $0x0
  pushl $136
80107a09:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107a0e:	e9 f4 f5 ff ff       	jmp    80107007 <alltraps>

80107a13 <vector137>:
.globl vector137
vector137:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $137
80107a15:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107a1a:	e9 e8 f5 ff ff       	jmp    80107007 <alltraps>

80107a1f <vector138>:
.globl vector138
vector138:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $138
80107a21:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107a26:	e9 dc f5 ff ff       	jmp    80107007 <alltraps>

80107a2b <vector139>:
.globl vector139
vector139:
  pushl $0
80107a2b:	6a 00                	push   $0x0
  pushl $139
80107a2d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107a32:	e9 d0 f5 ff ff       	jmp    80107007 <alltraps>

80107a37 <vector140>:
.globl vector140
vector140:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $140
80107a39:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107a3e:	e9 c4 f5 ff ff       	jmp    80107007 <alltraps>

80107a43 <vector141>:
.globl vector141
vector141:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $141
80107a45:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107a4a:	e9 b8 f5 ff ff       	jmp    80107007 <alltraps>

80107a4f <vector142>:
.globl vector142
vector142:
  pushl $0
80107a4f:	6a 00                	push   $0x0
  pushl $142
80107a51:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107a56:	e9 ac f5 ff ff       	jmp    80107007 <alltraps>

80107a5b <vector143>:
.globl vector143
vector143:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $143
80107a5d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107a62:	e9 a0 f5 ff ff       	jmp    80107007 <alltraps>

80107a67 <vector144>:
.globl vector144
vector144:
  pushl $0
80107a67:	6a 00                	push   $0x0
  pushl $144
80107a69:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107a6e:	e9 94 f5 ff ff       	jmp    80107007 <alltraps>

80107a73 <vector145>:
.globl vector145
vector145:
  pushl $0
80107a73:	6a 00                	push   $0x0
  pushl $145
80107a75:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107a7a:	e9 88 f5 ff ff       	jmp    80107007 <alltraps>

80107a7f <vector146>:
.globl vector146
vector146:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $146
80107a81:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107a86:	e9 7c f5 ff ff       	jmp    80107007 <alltraps>

80107a8b <vector147>:
.globl vector147
vector147:
  pushl $0
80107a8b:	6a 00                	push   $0x0
  pushl $147
80107a8d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107a92:	e9 70 f5 ff ff       	jmp    80107007 <alltraps>

80107a97 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a97:	6a 00                	push   $0x0
  pushl $148
80107a99:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a9e:	e9 64 f5 ff ff       	jmp    80107007 <alltraps>

80107aa3 <vector149>:
.globl vector149
vector149:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $149
80107aa5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107aaa:	e9 58 f5 ff ff       	jmp    80107007 <alltraps>

80107aaf <vector150>:
.globl vector150
vector150:
  pushl $0
80107aaf:	6a 00                	push   $0x0
  pushl $150
80107ab1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107ab6:	e9 4c f5 ff ff       	jmp    80107007 <alltraps>

80107abb <vector151>:
.globl vector151
vector151:
  pushl $0
80107abb:	6a 00                	push   $0x0
  pushl $151
80107abd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107ac2:	e9 40 f5 ff ff       	jmp    80107007 <alltraps>

80107ac7 <vector152>:
.globl vector152
vector152:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $152
80107ac9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107ace:	e9 34 f5 ff ff       	jmp    80107007 <alltraps>

80107ad3 <vector153>:
.globl vector153
vector153:
  pushl $0
80107ad3:	6a 00                	push   $0x0
  pushl $153
80107ad5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107ada:	e9 28 f5 ff ff       	jmp    80107007 <alltraps>

80107adf <vector154>:
.globl vector154
vector154:
  pushl $0
80107adf:	6a 00                	push   $0x0
  pushl $154
80107ae1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107ae6:	e9 1c f5 ff ff       	jmp    80107007 <alltraps>

80107aeb <vector155>:
.globl vector155
vector155:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $155
80107aed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107af2:	e9 10 f5 ff ff       	jmp    80107007 <alltraps>

80107af7 <vector156>:
.globl vector156
vector156:
  pushl $0
80107af7:	6a 00                	push   $0x0
  pushl $156
80107af9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107afe:	e9 04 f5 ff ff       	jmp    80107007 <alltraps>

80107b03 <vector157>:
.globl vector157
vector157:
  pushl $0
80107b03:	6a 00                	push   $0x0
  pushl $157
80107b05:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107b0a:	e9 f8 f4 ff ff       	jmp    80107007 <alltraps>

80107b0f <vector158>:
.globl vector158
vector158:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $158
80107b11:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107b16:	e9 ec f4 ff ff       	jmp    80107007 <alltraps>

80107b1b <vector159>:
.globl vector159
vector159:
  pushl $0
80107b1b:	6a 00                	push   $0x0
  pushl $159
80107b1d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107b22:	e9 e0 f4 ff ff       	jmp    80107007 <alltraps>

80107b27 <vector160>:
.globl vector160
vector160:
  pushl $0
80107b27:	6a 00                	push   $0x0
  pushl $160
80107b29:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107b2e:	e9 d4 f4 ff ff       	jmp    80107007 <alltraps>

80107b33 <vector161>:
.globl vector161
vector161:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $161
80107b35:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107b3a:	e9 c8 f4 ff ff       	jmp    80107007 <alltraps>

80107b3f <vector162>:
.globl vector162
vector162:
  pushl $0
80107b3f:	6a 00                	push   $0x0
  pushl $162
80107b41:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107b46:	e9 bc f4 ff ff       	jmp    80107007 <alltraps>

80107b4b <vector163>:
.globl vector163
vector163:
  pushl $0
80107b4b:	6a 00                	push   $0x0
  pushl $163
80107b4d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107b52:	e9 b0 f4 ff ff       	jmp    80107007 <alltraps>

80107b57 <vector164>:
.globl vector164
vector164:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $164
80107b59:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107b5e:	e9 a4 f4 ff ff       	jmp    80107007 <alltraps>

80107b63 <vector165>:
.globl vector165
vector165:
  pushl $0
80107b63:	6a 00                	push   $0x0
  pushl $165
80107b65:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107b6a:	e9 98 f4 ff ff       	jmp    80107007 <alltraps>

80107b6f <vector166>:
.globl vector166
vector166:
  pushl $0
80107b6f:	6a 00                	push   $0x0
  pushl $166
80107b71:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107b76:	e9 8c f4 ff ff       	jmp    80107007 <alltraps>

80107b7b <vector167>:
.globl vector167
vector167:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $167
80107b7d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107b82:	e9 80 f4 ff ff       	jmp    80107007 <alltraps>

80107b87 <vector168>:
.globl vector168
vector168:
  pushl $0
80107b87:	6a 00                	push   $0x0
  pushl $168
80107b89:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107b8e:	e9 74 f4 ff ff       	jmp    80107007 <alltraps>

80107b93 <vector169>:
.globl vector169
vector169:
  pushl $0
80107b93:	6a 00                	push   $0x0
  pushl $169
80107b95:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b9a:	e9 68 f4 ff ff       	jmp    80107007 <alltraps>

80107b9f <vector170>:
.globl vector170
vector170:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $170
80107ba1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107ba6:	e9 5c f4 ff ff       	jmp    80107007 <alltraps>

80107bab <vector171>:
.globl vector171
vector171:
  pushl $0
80107bab:	6a 00                	push   $0x0
  pushl $171
80107bad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107bb2:	e9 50 f4 ff ff       	jmp    80107007 <alltraps>

80107bb7 <vector172>:
.globl vector172
vector172:
  pushl $0
80107bb7:	6a 00                	push   $0x0
  pushl $172
80107bb9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107bbe:	e9 44 f4 ff ff       	jmp    80107007 <alltraps>

80107bc3 <vector173>:
.globl vector173
vector173:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $173
80107bc5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107bca:	e9 38 f4 ff ff       	jmp    80107007 <alltraps>

80107bcf <vector174>:
.globl vector174
vector174:
  pushl $0
80107bcf:	6a 00                	push   $0x0
  pushl $174
80107bd1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107bd6:	e9 2c f4 ff ff       	jmp    80107007 <alltraps>

80107bdb <vector175>:
.globl vector175
vector175:
  pushl $0
80107bdb:	6a 00                	push   $0x0
  pushl $175
80107bdd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107be2:	e9 20 f4 ff ff       	jmp    80107007 <alltraps>

80107be7 <vector176>:
.globl vector176
vector176:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $176
80107be9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107bee:	e9 14 f4 ff ff       	jmp    80107007 <alltraps>

80107bf3 <vector177>:
.globl vector177
vector177:
  pushl $0
80107bf3:	6a 00                	push   $0x0
  pushl $177
80107bf5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107bfa:	e9 08 f4 ff ff       	jmp    80107007 <alltraps>

80107bff <vector178>:
.globl vector178
vector178:
  pushl $0
80107bff:	6a 00                	push   $0x0
  pushl $178
80107c01:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107c06:	e9 fc f3 ff ff       	jmp    80107007 <alltraps>

80107c0b <vector179>:
.globl vector179
vector179:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $179
80107c0d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107c12:	e9 f0 f3 ff ff       	jmp    80107007 <alltraps>

80107c17 <vector180>:
.globl vector180
vector180:
  pushl $0
80107c17:	6a 00                	push   $0x0
  pushl $180
80107c19:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107c1e:	e9 e4 f3 ff ff       	jmp    80107007 <alltraps>

80107c23 <vector181>:
.globl vector181
vector181:
  pushl $0
80107c23:	6a 00                	push   $0x0
  pushl $181
80107c25:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107c2a:	e9 d8 f3 ff ff       	jmp    80107007 <alltraps>

80107c2f <vector182>:
.globl vector182
vector182:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $182
80107c31:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107c36:	e9 cc f3 ff ff       	jmp    80107007 <alltraps>

80107c3b <vector183>:
.globl vector183
vector183:
  pushl $0
80107c3b:	6a 00                	push   $0x0
  pushl $183
80107c3d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107c42:	e9 c0 f3 ff ff       	jmp    80107007 <alltraps>

80107c47 <vector184>:
.globl vector184
vector184:
  pushl $0
80107c47:	6a 00                	push   $0x0
  pushl $184
80107c49:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107c4e:	e9 b4 f3 ff ff       	jmp    80107007 <alltraps>

80107c53 <vector185>:
.globl vector185
vector185:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $185
80107c55:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107c5a:	e9 a8 f3 ff ff       	jmp    80107007 <alltraps>

80107c5f <vector186>:
.globl vector186
vector186:
  pushl $0
80107c5f:	6a 00                	push   $0x0
  pushl $186
80107c61:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107c66:	e9 9c f3 ff ff       	jmp    80107007 <alltraps>

80107c6b <vector187>:
.globl vector187
vector187:
  pushl $0
80107c6b:	6a 00                	push   $0x0
  pushl $187
80107c6d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107c72:	e9 90 f3 ff ff       	jmp    80107007 <alltraps>

80107c77 <vector188>:
.globl vector188
vector188:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $188
80107c79:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107c7e:	e9 84 f3 ff ff       	jmp    80107007 <alltraps>

80107c83 <vector189>:
.globl vector189
vector189:
  pushl $0
80107c83:	6a 00                	push   $0x0
  pushl $189
80107c85:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107c8a:	e9 78 f3 ff ff       	jmp    80107007 <alltraps>

80107c8f <vector190>:
.globl vector190
vector190:
  pushl $0
80107c8f:	6a 00                	push   $0x0
  pushl $190
80107c91:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107c96:	e9 6c f3 ff ff       	jmp    80107007 <alltraps>

80107c9b <vector191>:
.globl vector191
vector191:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $191
80107c9d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107ca2:	e9 60 f3 ff ff       	jmp    80107007 <alltraps>

80107ca7 <vector192>:
.globl vector192
vector192:
  pushl $0
80107ca7:	6a 00                	push   $0x0
  pushl $192
80107ca9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107cae:	e9 54 f3 ff ff       	jmp    80107007 <alltraps>

80107cb3 <vector193>:
.globl vector193
vector193:
  pushl $0
80107cb3:	6a 00                	push   $0x0
  pushl $193
80107cb5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107cba:	e9 48 f3 ff ff       	jmp    80107007 <alltraps>

80107cbf <vector194>:
.globl vector194
vector194:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $194
80107cc1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107cc6:	e9 3c f3 ff ff       	jmp    80107007 <alltraps>

80107ccb <vector195>:
.globl vector195
vector195:
  pushl $0
80107ccb:	6a 00                	push   $0x0
  pushl $195
80107ccd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107cd2:	e9 30 f3 ff ff       	jmp    80107007 <alltraps>

80107cd7 <vector196>:
.globl vector196
vector196:
  pushl $0
80107cd7:	6a 00                	push   $0x0
  pushl $196
80107cd9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107cde:	e9 24 f3 ff ff       	jmp    80107007 <alltraps>

80107ce3 <vector197>:
.globl vector197
vector197:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $197
80107ce5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107cea:	e9 18 f3 ff ff       	jmp    80107007 <alltraps>

80107cef <vector198>:
.globl vector198
vector198:
  pushl $0
80107cef:	6a 00                	push   $0x0
  pushl $198
80107cf1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107cf6:	e9 0c f3 ff ff       	jmp    80107007 <alltraps>

80107cfb <vector199>:
.globl vector199
vector199:
  pushl $0
80107cfb:	6a 00                	push   $0x0
  pushl $199
80107cfd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107d02:	e9 00 f3 ff ff       	jmp    80107007 <alltraps>

80107d07 <vector200>:
.globl vector200
vector200:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $200
80107d09:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107d0e:	e9 f4 f2 ff ff       	jmp    80107007 <alltraps>

80107d13 <vector201>:
.globl vector201
vector201:
  pushl $0
80107d13:	6a 00                	push   $0x0
  pushl $201
80107d15:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107d1a:	e9 e8 f2 ff ff       	jmp    80107007 <alltraps>

80107d1f <vector202>:
.globl vector202
vector202:
  pushl $0
80107d1f:	6a 00                	push   $0x0
  pushl $202
80107d21:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107d26:	e9 dc f2 ff ff       	jmp    80107007 <alltraps>

80107d2b <vector203>:
.globl vector203
vector203:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $203
80107d2d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107d32:	e9 d0 f2 ff ff       	jmp    80107007 <alltraps>

80107d37 <vector204>:
.globl vector204
vector204:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $204
80107d39:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107d3e:	e9 c4 f2 ff ff       	jmp    80107007 <alltraps>

80107d43 <vector205>:
.globl vector205
vector205:
  pushl $0
80107d43:	6a 00                	push   $0x0
  pushl $205
80107d45:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107d4a:	e9 b8 f2 ff ff       	jmp    80107007 <alltraps>

80107d4f <vector206>:
.globl vector206
vector206:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $206
80107d51:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107d56:	e9 ac f2 ff ff       	jmp    80107007 <alltraps>

80107d5b <vector207>:
.globl vector207
vector207:
  pushl $0
80107d5b:	6a 00                	push   $0x0
  pushl $207
80107d5d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107d62:	e9 a0 f2 ff ff       	jmp    80107007 <alltraps>

80107d67 <vector208>:
.globl vector208
vector208:
  pushl $0
80107d67:	6a 00                	push   $0x0
  pushl $208
80107d69:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107d6e:	e9 94 f2 ff ff       	jmp    80107007 <alltraps>

80107d73 <vector209>:
.globl vector209
vector209:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $209
80107d75:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107d7a:	e9 88 f2 ff ff       	jmp    80107007 <alltraps>

80107d7f <vector210>:
.globl vector210
vector210:
  pushl $0
80107d7f:	6a 00                	push   $0x0
  pushl $210
80107d81:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107d86:	e9 7c f2 ff ff       	jmp    80107007 <alltraps>

80107d8b <vector211>:
.globl vector211
vector211:
  pushl $0
80107d8b:	6a 00                	push   $0x0
  pushl $211
80107d8d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107d92:	e9 70 f2 ff ff       	jmp    80107007 <alltraps>

80107d97 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $212
80107d99:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d9e:	e9 64 f2 ff ff       	jmp    80107007 <alltraps>

80107da3 <vector213>:
.globl vector213
vector213:
  pushl $0
80107da3:	6a 00                	push   $0x0
  pushl $213
80107da5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107daa:	e9 58 f2 ff ff       	jmp    80107007 <alltraps>

80107daf <vector214>:
.globl vector214
vector214:
  pushl $0
80107daf:	6a 00                	push   $0x0
  pushl $214
80107db1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107db6:	e9 4c f2 ff ff       	jmp    80107007 <alltraps>

80107dbb <vector215>:
.globl vector215
vector215:
  pushl $0
80107dbb:	6a 00                	push   $0x0
  pushl $215
80107dbd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107dc2:	e9 40 f2 ff ff       	jmp    80107007 <alltraps>

80107dc7 <vector216>:
.globl vector216
vector216:
  pushl $0
80107dc7:	6a 00                	push   $0x0
  pushl $216
80107dc9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107dce:	e9 34 f2 ff ff       	jmp    80107007 <alltraps>

80107dd3 <vector217>:
.globl vector217
vector217:
  pushl $0
80107dd3:	6a 00                	push   $0x0
  pushl $217
80107dd5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107dda:	e9 28 f2 ff ff       	jmp    80107007 <alltraps>

80107ddf <vector218>:
.globl vector218
vector218:
  pushl $0
80107ddf:	6a 00                	push   $0x0
  pushl $218
80107de1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107de6:	e9 1c f2 ff ff       	jmp    80107007 <alltraps>

80107deb <vector219>:
.globl vector219
vector219:
  pushl $0
80107deb:	6a 00                	push   $0x0
  pushl $219
80107ded:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107df2:	e9 10 f2 ff ff       	jmp    80107007 <alltraps>

80107df7 <vector220>:
.globl vector220
vector220:
  pushl $0
80107df7:	6a 00                	push   $0x0
  pushl $220
80107df9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107dfe:	e9 04 f2 ff ff       	jmp    80107007 <alltraps>

80107e03 <vector221>:
.globl vector221
vector221:
  pushl $0
80107e03:	6a 00                	push   $0x0
  pushl $221
80107e05:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107e0a:	e9 f8 f1 ff ff       	jmp    80107007 <alltraps>

80107e0f <vector222>:
.globl vector222
vector222:
  pushl $0
80107e0f:	6a 00                	push   $0x0
  pushl $222
80107e11:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107e16:	e9 ec f1 ff ff       	jmp    80107007 <alltraps>

80107e1b <vector223>:
.globl vector223
vector223:
  pushl $0
80107e1b:	6a 00                	push   $0x0
  pushl $223
80107e1d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107e22:	e9 e0 f1 ff ff       	jmp    80107007 <alltraps>

80107e27 <vector224>:
.globl vector224
vector224:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $224
80107e29:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107e2e:	e9 d4 f1 ff ff       	jmp    80107007 <alltraps>

80107e33 <vector225>:
.globl vector225
vector225:
  pushl $0
80107e33:	6a 00                	push   $0x0
  pushl $225
80107e35:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107e3a:	e9 c8 f1 ff ff       	jmp    80107007 <alltraps>

80107e3f <vector226>:
.globl vector226
vector226:
  pushl $0
80107e3f:	6a 00                	push   $0x0
  pushl $226
80107e41:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107e46:	e9 bc f1 ff ff       	jmp    80107007 <alltraps>

80107e4b <vector227>:
.globl vector227
vector227:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $227
80107e4d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107e52:	e9 b0 f1 ff ff       	jmp    80107007 <alltraps>

80107e57 <vector228>:
.globl vector228
vector228:
  pushl $0
80107e57:	6a 00                	push   $0x0
  pushl $228
80107e59:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107e5e:	e9 a4 f1 ff ff       	jmp    80107007 <alltraps>

80107e63 <vector229>:
.globl vector229
vector229:
  pushl $0
80107e63:	6a 00                	push   $0x0
  pushl $229
80107e65:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107e6a:	e9 98 f1 ff ff       	jmp    80107007 <alltraps>

80107e6f <vector230>:
.globl vector230
vector230:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $230
80107e71:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107e76:	e9 8c f1 ff ff       	jmp    80107007 <alltraps>

80107e7b <vector231>:
.globl vector231
vector231:
  pushl $0
80107e7b:	6a 00                	push   $0x0
  pushl $231
80107e7d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107e82:	e9 80 f1 ff ff       	jmp    80107007 <alltraps>

80107e87 <vector232>:
.globl vector232
vector232:
  pushl $0
80107e87:	6a 00                	push   $0x0
  pushl $232
80107e89:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107e8e:	e9 74 f1 ff ff       	jmp    80107007 <alltraps>

80107e93 <vector233>:
.globl vector233
vector233:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $233
80107e95:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e9a:	e9 68 f1 ff ff       	jmp    80107007 <alltraps>

80107e9f <vector234>:
.globl vector234
vector234:
  pushl $0
80107e9f:	6a 00                	push   $0x0
  pushl $234
80107ea1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107ea6:	e9 5c f1 ff ff       	jmp    80107007 <alltraps>

80107eab <vector235>:
.globl vector235
vector235:
  pushl $0
80107eab:	6a 00                	push   $0x0
  pushl $235
80107ead:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107eb2:	e9 50 f1 ff ff       	jmp    80107007 <alltraps>

80107eb7 <vector236>:
.globl vector236
vector236:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $236
80107eb9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107ebe:	e9 44 f1 ff ff       	jmp    80107007 <alltraps>

80107ec3 <vector237>:
.globl vector237
vector237:
  pushl $0
80107ec3:	6a 00                	push   $0x0
  pushl $237
80107ec5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107eca:	e9 38 f1 ff ff       	jmp    80107007 <alltraps>

80107ecf <vector238>:
.globl vector238
vector238:
  pushl $0
80107ecf:	6a 00                	push   $0x0
  pushl $238
80107ed1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ed6:	e9 2c f1 ff ff       	jmp    80107007 <alltraps>

80107edb <vector239>:
.globl vector239
vector239:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $239
80107edd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ee2:	e9 20 f1 ff ff       	jmp    80107007 <alltraps>

80107ee7 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ee7:	6a 00                	push   $0x0
  pushl $240
80107ee9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107eee:	e9 14 f1 ff ff       	jmp    80107007 <alltraps>

80107ef3 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ef3:	6a 00                	push   $0x0
  pushl $241
80107ef5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107efa:	e9 08 f1 ff ff       	jmp    80107007 <alltraps>

80107eff <vector242>:
.globl vector242
vector242:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $242
80107f01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107f06:	e9 fc f0 ff ff       	jmp    80107007 <alltraps>

80107f0b <vector243>:
.globl vector243
vector243:
  pushl $0
80107f0b:	6a 00                	push   $0x0
  pushl $243
80107f0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107f12:	e9 f0 f0 ff ff       	jmp    80107007 <alltraps>

80107f17 <vector244>:
.globl vector244
vector244:
  pushl $0
80107f17:	6a 00                	push   $0x0
  pushl $244
80107f19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107f1e:	e9 e4 f0 ff ff       	jmp    80107007 <alltraps>

80107f23 <vector245>:
.globl vector245
vector245:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $245
80107f25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107f2a:	e9 d8 f0 ff ff       	jmp    80107007 <alltraps>

80107f2f <vector246>:
.globl vector246
vector246:
  pushl $0
80107f2f:	6a 00                	push   $0x0
  pushl $246
80107f31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107f36:	e9 cc f0 ff ff       	jmp    80107007 <alltraps>

80107f3b <vector247>:
.globl vector247
vector247:
  pushl $0
80107f3b:	6a 00                	push   $0x0
  pushl $247
80107f3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107f42:	e9 c0 f0 ff ff       	jmp    80107007 <alltraps>

80107f47 <vector248>:
.globl vector248
vector248:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $248
80107f49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107f4e:	e9 b4 f0 ff ff       	jmp    80107007 <alltraps>

80107f53 <vector249>:
.globl vector249
vector249:
  pushl $0
80107f53:	6a 00                	push   $0x0
  pushl $249
80107f55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107f5a:	e9 a8 f0 ff ff       	jmp    80107007 <alltraps>

80107f5f <vector250>:
.globl vector250
vector250:
  pushl $0
80107f5f:	6a 00                	push   $0x0
  pushl $250
80107f61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107f66:	e9 9c f0 ff ff       	jmp    80107007 <alltraps>

80107f6b <vector251>:
.globl vector251
vector251:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $251
80107f6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107f72:	e9 90 f0 ff ff       	jmp    80107007 <alltraps>

80107f77 <vector252>:
.globl vector252
vector252:
  pushl $0
80107f77:	6a 00                	push   $0x0
  pushl $252
80107f79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107f7e:	e9 84 f0 ff ff       	jmp    80107007 <alltraps>

80107f83 <vector253>:
.globl vector253
vector253:
  pushl $0
80107f83:	6a 00                	push   $0x0
  pushl $253
80107f85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107f8a:	e9 78 f0 ff ff       	jmp    80107007 <alltraps>

80107f8f <vector254>:
.globl vector254
vector254:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $254
80107f91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107f96:	e9 6c f0 ff ff       	jmp    80107007 <alltraps>

80107f9b <vector255>:
.globl vector255
vector255:
  pushl $0
80107f9b:	6a 00                	push   $0x0
  pushl $255
80107f9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107fa2:	e9 60 f0 ff ff       	jmp    80107007 <alltraps>
80107fa7:	66 90                	xchg   %ax,%ax
80107fa9:	66 90                	xchg   %ax,%ax
80107fab:	66 90                	xchg   %ax,%ax
80107fad:	66 90                	xchg   %ax,%ax
80107faf:	90                   	nop

80107fb0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107fb0:	55                   	push   %ebp
80107fb1:	89 e5                	mov    %esp,%ebp
80107fb3:	57                   	push   %edi
80107fb4:	56                   	push   %esi
80107fb5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107fb6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107fbc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107fc2:	83 ec 1c             	sub    $0x1c,%esp
80107fc5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107fc8:	39 d3                	cmp    %edx,%ebx
80107fca:	73 49                	jae    80108015 <deallocuvm.part.0+0x65>
80107fcc:	89 c7                	mov    %eax,%edi
80107fce:	eb 0c                	jmp    80107fdc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107fd0:	83 c0 01             	add    $0x1,%eax
80107fd3:	c1 e0 16             	shl    $0x16,%eax
80107fd6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107fd8:	39 da                	cmp    %ebx,%edx
80107fda:	76 39                	jbe    80108015 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107fdc:	89 d8                	mov    %ebx,%eax
80107fde:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107fe1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107fe4:	f6 c1 01             	test   $0x1,%cl
80107fe7:	74 e7                	je     80107fd0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107fe9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107feb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107ff1:	c1 ee 0a             	shr    $0xa,%esi
80107ff4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107ffa:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80108001:	85 f6                	test   %esi,%esi
80108003:	74 cb                	je     80107fd0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80108005:	8b 06                	mov    (%esi),%eax
80108007:	a8 01                	test   $0x1,%al
80108009:	75 15                	jne    80108020 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010800b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108011:	39 da                	cmp    %ebx,%edx
80108013:	77 c7                	ja     80107fdc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80108015:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010801b:	5b                   	pop    %ebx
8010801c:	5e                   	pop    %esi
8010801d:	5f                   	pop    %edi
8010801e:	5d                   	pop    %ebp
8010801f:	c3                   	ret    
      if(pa == 0)
80108020:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108025:	74 25                	je     8010804c <deallocuvm.part.0+0x9c>
      kfree(v);
80108027:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010802a:	05 00 00 00 80       	add    $0x80000000,%eax
8010802f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108032:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80108038:	50                   	push   %eax
80108039:	e8 62 b7 ff ff       	call   801037a0 <kfree>
      *pte = 0;
8010803e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80108044:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108047:	83 c4 10             	add    $0x10,%esp
8010804a:	eb 8c                	jmp    80107fd8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010804c:	83 ec 0c             	sub    $0xc,%esp
8010804f:	68 46 8c 10 80       	push   $0x80108c46
80108054:	e8 07 84 ff ff       	call   80100460 <panic>
80108059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108060 <mappages>:
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108066:	89 d3                	mov    %edx,%ebx
80108068:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010806e:	83 ec 1c             	sub    $0x1c,%esp
80108071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108074:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108078:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010807d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108080:	8b 45 08             	mov    0x8(%ebp),%eax
80108083:	29 d8                	sub    %ebx,%eax
80108085:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108088:	eb 3d                	jmp    801080c7 <mappages+0x67>
8010808a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108090:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108092:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108097:	c1 ea 0a             	shr    $0xa,%edx
8010809a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801080a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801080a7:	85 c0                	test   %eax,%eax
801080a9:	74 75                	je     80108120 <mappages+0xc0>
    if(*pte & PTE_P)
801080ab:	f6 00 01             	testb  $0x1,(%eax)
801080ae:	0f 85 86 00 00 00    	jne    8010813a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801080b4:	0b 75 0c             	or     0xc(%ebp),%esi
801080b7:	83 ce 01             	or     $0x1,%esi
801080ba:	89 30                	mov    %esi,(%eax)
    if(a == last)
801080bc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801080bf:	74 6f                	je     80108130 <mappages+0xd0>
    a += PGSIZE;
801080c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801080c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801080ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801080cd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801080d0:	89 d8                	mov    %ebx,%eax
801080d2:	c1 e8 16             	shr    $0x16,%eax
801080d5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801080d8:	8b 07                	mov    (%edi),%eax
801080da:	a8 01                	test   $0x1,%al
801080dc:	75 b2                	jne    80108090 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080de:	e8 7d b8 ff ff       	call   80103960 <kalloc>
801080e3:	85 c0                	test   %eax,%eax
801080e5:	74 39                	je     80108120 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801080e7:	83 ec 04             	sub    $0x4,%esp
801080ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
801080ed:	68 00 10 00 00       	push   $0x1000
801080f2:	6a 00                	push   $0x0
801080f4:	50                   	push   %eax
801080f5:	e8 c6 da ff ff       	call   80105bc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801080fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801080fd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108100:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108106:	83 c8 07             	or     $0x7,%eax
80108109:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010810b:	89 d8                	mov    %ebx,%eax
8010810d:	c1 e8 0a             	shr    $0xa,%eax
80108110:	25 fc 0f 00 00       	and    $0xffc,%eax
80108115:	01 d0                	add    %edx,%eax
80108117:	eb 92                	jmp    801080ab <mappages+0x4b>
80108119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80108120:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108128:	5b                   	pop    %ebx
80108129:	5e                   	pop    %esi
8010812a:	5f                   	pop    %edi
8010812b:	5d                   	pop    %ebp
8010812c:	c3                   	ret    
8010812d:	8d 76 00             	lea    0x0(%esi),%esi
80108130:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108133:	31 c0                	xor    %eax,%eax
}
80108135:	5b                   	pop    %ebx
80108136:	5e                   	pop    %esi
80108137:	5f                   	pop    %edi
80108138:	5d                   	pop    %ebp
80108139:	c3                   	ret    
      panic("remap");
8010813a:	83 ec 0c             	sub    $0xc,%esp
8010813d:	68 74 93 10 80       	push   $0x80109374
80108142:	e8 19 83 ff ff       	call   80100460 <panic>
80108147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010814e:	66 90                	xchg   %ax,%ax

80108150 <seginit>:
{
80108150:	55                   	push   %ebp
80108151:	89 e5                	mov    %esp,%ebp
80108153:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108156:	e8 e5 ca ff ff       	call   80104c40 <cpuid>
  pd[0] = size-1;
8010815b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80108160:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80108166:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010816a:	c7 80 b8 43 11 80 ff 	movl   $0xffff,-0x7feebc48(%eax)
80108171:	ff 00 00 
80108174:	c7 80 bc 43 11 80 00 	movl   $0xcf9a00,-0x7feebc44(%eax)
8010817b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010817e:	c7 80 c0 43 11 80 ff 	movl   $0xffff,-0x7feebc40(%eax)
80108185:	ff 00 00 
80108188:	c7 80 c4 43 11 80 00 	movl   $0xcf9200,-0x7feebc3c(%eax)
8010818f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108192:	c7 80 c8 43 11 80 ff 	movl   $0xffff,-0x7feebc38(%eax)
80108199:	ff 00 00 
8010819c:	c7 80 cc 43 11 80 00 	movl   $0xcffa00,-0x7feebc34(%eax)
801081a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801081a6:	c7 80 d0 43 11 80 ff 	movl   $0xffff,-0x7feebc30(%eax)
801081ad:	ff 00 00 
801081b0:	c7 80 d4 43 11 80 00 	movl   $0xcff200,-0x7feebc2c(%eax)
801081b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801081ba:	05 b0 43 11 80       	add    $0x801143b0,%eax
  pd[1] = (uint)p;
801081bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801081c3:	c1 e8 10             	shr    $0x10,%eax
801081c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801081ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801081cd:	0f 01 10             	lgdtl  (%eax)
}
801081d0:	c9                   	leave  
801081d1:	c3                   	ret    
801081d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801081e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801081e0:	a1 64 d5 11 80       	mov    0x8011d564,%eax
801081e5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801081ea:	0f 22 d8             	mov    %eax,%cr3
}
801081ed:	c3                   	ret    
801081ee:	66 90                	xchg   %ax,%ax

801081f0 <switchuvm>:
{
801081f0:	55                   	push   %ebp
801081f1:	89 e5                	mov    %esp,%ebp
801081f3:	57                   	push   %edi
801081f4:	56                   	push   %esi
801081f5:	53                   	push   %ebx
801081f6:	83 ec 1c             	sub    $0x1c,%esp
801081f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801081fc:	85 f6                	test   %esi,%esi
801081fe:	0f 84 cb 00 00 00    	je     801082cf <switchuvm+0xdf>
  if(p->kstack == 0)
80108204:	8b 46 08             	mov    0x8(%esi),%eax
80108207:	85 c0                	test   %eax,%eax
80108209:	0f 84 da 00 00 00    	je     801082e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010820f:	8b 46 04             	mov    0x4(%esi),%eax
80108212:	85 c0                	test   %eax,%eax
80108214:	0f 84 c2 00 00 00    	je     801082dc <switchuvm+0xec>
  pushcli();
8010821a:	e8 91 d7 ff ff       	call   801059b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010821f:	e8 bc c9 ff ff       	call   80104be0 <mycpu>
80108224:	89 c3                	mov    %eax,%ebx
80108226:	e8 b5 c9 ff ff       	call   80104be0 <mycpu>
8010822b:	89 c7                	mov    %eax,%edi
8010822d:	e8 ae c9 ff ff       	call   80104be0 <mycpu>
80108232:	83 c7 08             	add    $0x8,%edi
80108235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108238:	e8 a3 c9 ff ff       	call   80104be0 <mycpu>
8010823d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108240:	ba 67 00 00 00       	mov    $0x67,%edx
80108245:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010824c:	83 c0 08             	add    $0x8,%eax
8010824f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108256:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010825b:	83 c1 08             	add    $0x8,%ecx
8010825e:	c1 e8 18             	shr    $0x18,%eax
80108261:	c1 e9 10             	shr    $0x10,%ecx
80108264:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010826a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108270:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108275:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010827c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108281:	e8 5a c9 ff ff       	call   80104be0 <mycpu>
80108286:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010828d:	e8 4e c9 ff ff       	call   80104be0 <mycpu>
80108292:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108296:	8b 5e 08             	mov    0x8(%esi),%ebx
80108299:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010829f:	e8 3c c9 ff ff       	call   80104be0 <mycpu>
801082a4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801082a7:	e8 34 c9 ff ff       	call   80104be0 <mycpu>
801082ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801082b0:	b8 28 00 00 00       	mov    $0x28,%eax
801082b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801082b8:	8b 46 04             	mov    0x4(%esi),%eax
801082bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801082c0:	0f 22 d8             	mov    %eax,%cr3
}
801082c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c6:	5b                   	pop    %ebx
801082c7:	5e                   	pop    %esi
801082c8:	5f                   	pop    %edi
801082c9:	5d                   	pop    %ebp
  popcli();
801082ca:	e9 31 d7 ff ff       	jmp    80105a00 <popcli>
    panic("switchuvm: no process");
801082cf:	83 ec 0c             	sub    $0xc,%esp
801082d2:	68 7a 93 10 80       	push   $0x8010937a
801082d7:	e8 84 81 ff ff       	call   80100460 <panic>
    panic("switchuvm: no pgdir");
801082dc:	83 ec 0c             	sub    $0xc,%esp
801082df:	68 a5 93 10 80       	push   $0x801093a5
801082e4:	e8 77 81 ff ff       	call   80100460 <panic>
    panic("switchuvm: no kstack");
801082e9:	83 ec 0c             	sub    $0xc,%esp
801082ec:	68 90 93 10 80       	push   $0x80109390
801082f1:	e8 6a 81 ff ff       	call   80100460 <panic>
801082f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082fd:	8d 76 00             	lea    0x0(%esi),%esi

80108300 <inituvm>:
{
80108300:	55                   	push   %ebp
80108301:	89 e5                	mov    %esp,%ebp
80108303:	57                   	push   %edi
80108304:	56                   	push   %esi
80108305:	53                   	push   %ebx
80108306:	83 ec 1c             	sub    $0x1c,%esp
80108309:	8b 45 0c             	mov    0xc(%ebp),%eax
8010830c:	8b 75 10             	mov    0x10(%ebp),%esi
8010830f:	8b 7d 08             	mov    0x8(%ebp),%edi
80108312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108315:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010831b:	77 4b                	ja     80108368 <inituvm+0x68>
  mem = kalloc();
8010831d:	e8 3e b6 ff ff       	call   80103960 <kalloc>
  memset(mem, 0, PGSIZE);
80108322:	83 ec 04             	sub    $0x4,%esp
80108325:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010832a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010832c:	6a 00                	push   $0x0
8010832e:	50                   	push   %eax
8010832f:	e8 8c d8 ff ff       	call   80105bc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108334:	58                   	pop    %eax
80108335:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010833b:	5a                   	pop    %edx
8010833c:	6a 06                	push   $0x6
8010833e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108343:	31 d2                	xor    %edx,%edx
80108345:	50                   	push   %eax
80108346:	89 f8                	mov    %edi,%eax
80108348:	e8 13 fd ff ff       	call   80108060 <mappages>
  memmove(mem, init, sz);
8010834d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108350:	89 75 10             	mov    %esi,0x10(%ebp)
80108353:	83 c4 10             	add    $0x10,%esp
80108356:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108359:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010835c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010835f:	5b                   	pop    %ebx
80108360:	5e                   	pop    %esi
80108361:	5f                   	pop    %edi
80108362:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108363:	e9 f8 d8 ff ff       	jmp    80105c60 <memmove>
    panic("inituvm: more than a page");
80108368:	83 ec 0c             	sub    $0xc,%esp
8010836b:	68 b9 93 10 80       	push   $0x801093b9
80108370:	e8 eb 80 ff ff       	call   80100460 <panic>
80108375:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010837c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108380 <loaduvm>:
{
80108380:	55                   	push   %ebp
80108381:	89 e5                	mov    %esp,%ebp
80108383:	57                   	push   %edi
80108384:	56                   	push   %esi
80108385:	53                   	push   %ebx
80108386:	83 ec 1c             	sub    $0x1c,%esp
80108389:	8b 45 0c             	mov    0xc(%ebp),%eax
8010838c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010838f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108394:	0f 85 bb 00 00 00    	jne    80108455 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010839a:	01 f0                	add    %esi,%eax
8010839c:	89 f3                	mov    %esi,%ebx
8010839e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801083a1:	8b 45 14             	mov    0x14(%ebp),%eax
801083a4:	01 f0                	add    %esi,%eax
801083a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801083a9:	85 f6                	test   %esi,%esi
801083ab:	0f 84 87 00 00 00    	je     80108438 <loaduvm+0xb8>
801083b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801083b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801083bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801083be:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801083c0:	89 c2                	mov    %eax,%edx
801083c2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801083c5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801083c8:	f6 c2 01             	test   $0x1,%dl
801083cb:	75 13                	jne    801083e0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801083cd:	83 ec 0c             	sub    $0xc,%esp
801083d0:	68 d3 93 10 80       	push   $0x801093d3
801083d5:	e8 86 80 ff ff       	call   80100460 <panic>
801083da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801083e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801083e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801083e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801083ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801083f5:	85 c0                	test   %eax,%eax
801083f7:	74 d4                	je     801083cd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801083f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801083fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801083fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108403:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108408:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010840e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108411:	29 d9                	sub    %ebx,%ecx
80108413:	05 00 00 00 80       	add    $0x80000000,%eax
80108418:	57                   	push   %edi
80108419:	51                   	push   %ecx
8010841a:	50                   	push   %eax
8010841b:	ff 75 10             	push   0x10(%ebp)
8010841e:	e8 4d a9 ff ff       	call   80102d70 <readi>
80108423:	83 c4 10             	add    $0x10,%esp
80108426:	39 f8                	cmp    %edi,%eax
80108428:	75 1e                	jne    80108448 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010842a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108430:	89 f0                	mov    %esi,%eax
80108432:	29 d8                	sub    %ebx,%eax
80108434:	39 c6                	cmp    %eax,%esi
80108436:	77 80                	ja     801083b8 <loaduvm+0x38>
}
80108438:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010843b:	31 c0                	xor    %eax,%eax
}
8010843d:	5b                   	pop    %ebx
8010843e:	5e                   	pop    %esi
8010843f:	5f                   	pop    %edi
80108440:	5d                   	pop    %ebp
80108441:	c3                   	ret    
80108442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108448:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010844b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108450:	5b                   	pop    %ebx
80108451:	5e                   	pop    %esi
80108452:	5f                   	pop    %edi
80108453:	5d                   	pop    %ebp
80108454:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80108455:	83 ec 0c             	sub    $0xc,%esp
80108458:	68 74 94 10 80       	push   $0x80109474
8010845d:	e8 fe 7f ff ff       	call   80100460 <panic>
80108462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108470 <allocuvm>:
{
80108470:	55                   	push   %ebp
80108471:	89 e5                	mov    %esp,%ebp
80108473:	57                   	push   %edi
80108474:	56                   	push   %esi
80108475:	53                   	push   %ebx
80108476:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108479:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010847c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010847f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108482:	85 c0                	test   %eax,%eax
80108484:	0f 88 b6 00 00 00    	js     80108540 <allocuvm+0xd0>
  if(newsz < oldsz)
8010848a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010848d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108490:	0f 82 9a 00 00 00    	jb     80108530 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108496:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010849c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801084a2:	39 75 10             	cmp    %esi,0x10(%ebp)
801084a5:	77 44                	ja     801084eb <allocuvm+0x7b>
801084a7:	e9 87 00 00 00       	jmp    80108533 <allocuvm+0xc3>
801084ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801084b0:	83 ec 04             	sub    $0x4,%esp
801084b3:	68 00 10 00 00       	push   $0x1000
801084b8:	6a 00                	push   $0x0
801084ba:	50                   	push   %eax
801084bb:	e8 00 d7 ff ff       	call   80105bc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801084c0:	58                   	pop    %eax
801084c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801084c7:	5a                   	pop    %edx
801084c8:	6a 06                	push   $0x6
801084ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801084cf:	89 f2                	mov    %esi,%edx
801084d1:	50                   	push   %eax
801084d2:	89 f8                	mov    %edi,%eax
801084d4:	e8 87 fb ff ff       	call   80108060 <mappages>
801084d9:	83 c4 10             	add    $0x10,%esp
801084dc:	85 c0                	test   %eax,%eax
801084de:	78 78                	js     80108558 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801084e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801084e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801084e9:	76 48                	jbe    80108533 <allocuvm+0xc3>
    mem = kalloc();
801084eb:	e8 70 b4 ff ff       	call   80103960 <kalloc>
801084f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801084f2:	85 c0                	test   %eax,%eax
801084f4:	75 ba                	jne    801084b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801084f6:	83 ec 0c             	sub    $0xc,%esp
801084f9:	68 f1 93 10 80       	push   $0x801093f1
801084fe:	e8 dd 82 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80108503:	8b 45 0c             	mov    0xc(%ebp),%eax
80108506:	83 c4 10             	add    $0x10,%esp
80108509:	39 45 10             	cmp    %eax,0x10(%ebp)
8010850c:	74 32                	je     80108540 <allocuvm+0xd0>
8010850e:	8b 55 10             	mov    0x10(%ebp),%edx
80108511:	89 c1                	mov    %eax,%ecx
80108513:	89 f8                	mov    %edi,%eax
80108515:	e8 96 fa ff ff       	call   80107fb0 <deallocuvm.part.0>
      return 0;
8010851a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108524:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108527:	5b                   	pop    %ebx
80108528:	5e                   	pop    %esi
80108529:	5f                   	pop    %edi
8010852a:	5d                   	pop    %ebp
8010852b:	c3                   	ret    
8010852c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108539:	5b                   	pop    %ebx
8010853a:	5e                   	pop    %esi
8010853b:	5f                   	pop    %edi
8010853c:	5d                   	pop    %ebp
8010853d:	c3                   	ret    
8010853e:	66 90                	xchg   %ax,%ax
    return 0;
80108540:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010854a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010854d:	5b                   	pop    %ebx
8010854e:	5e                   	pop    %esi
8010854f:	5f                   	pop    %edi
80108550:	5d                   	pop    %ebp
80108551:	c3                   	ret    
80108552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108558:	83 ec 0c             	sub    $0xc,%esp
8010855b:	68 09 94 10 80       	push   $0x80109409
80108560:	e8 7b 82 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80108565:	8b 45 0c             	mov    0xc(%ebp),%eax
80108568:	83 c4 10             	add    $0x10,%esp
8010856b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010856e:	74 0c                	je     8010857c <allocuvm+0x10c>
80108570:	8b 55 10             	mov    0x10(%ebp),%edx
80108573:	89 c1                	mov    %eax,%ecx
80108575:	89 f8                	mov    %edi,%eax
80108577:	e8 34 fa ff ff       	call   80107fb0 <deallocuvm.part.0>
      kfree(mem);
8010857c:	83 ec 0c             	sub    $0xc,%esp
8010857f:	53                   	push   %ebx
80108580:	e8 1b b2 ff ff       	call   801037a0 <kfree>
      return 0;
80108585:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010858c:	83 c4 10             	add    $0x10,%esp
}
8010858f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108592:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108595:	5b                   	pop    %ebx
80108596:	5e                   	pop    %esi
80108597:	5f                   	pop    %edi
80108598:	5d                   	pop    %ebp
80108599:	c3                   	ret    
8010859a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801085a0 <deallocuvm>:
{
801085a0:	55                   	push   %ebp
801085a1:	89 e5                	mov    %esp,%ebp
801085a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801085a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801085a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801085ac:	39 d1                	cmp    %edx,%ecx
801085ae:	73 10                	jae    801085c0 <deallocuvm+0x20>
}
801085b0:	5d                   	pop    %ebp
801085b1:	e9 fa f9 ff ff       	jmp    80107fb0 <deallocuvm.part.0>
801085b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085bd:	8d 76 00             	lea    0x0(%esi),%esi
801085c0:	89 d0                	mov    %edx,%eax
801085c2:	5d                   	pop    %ebp
801085c3:	c3                   	ret    
801085c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801085cf:	90                   	nop

801085d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801085d0:	55                   	push   %ebp
801085d1:	89 e5                	mov    %esp,%ebp
801085d3:	57                   	push   %edi
801085d4:	56                   	push   %esi
801085d5:	53                   	push   %ebx
801085d6:	83 ec 0c             	sub    $0xc,%esp
801085d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801085dc:	85 f6                	test   %esi,%esi
801085de:	74 59                	je     80108639 <freevm+0x69>
  if(newsz >= oldsz)
801085e0:	31 c9                	xor    %ecx,%ecx
801085e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801085e7:	89 f0                	mov    %esi,%eax
801085e9:	89 f3                	mov    %esi,%ebx
801085eb:	e8 c0 f9 ff ff       	call   80107fb0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801085f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801085f6:	eb 0f                	jmp    80108607 <freevm+0x37>
801085f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085ff:	90                   	nop
80108600:	83 c3 04             	add    $0x4,%ebx
80108603:	39 df                	cmp    %ebx,%edi
80108605:	74 23                	je     8010862a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108607:	8b 03                	mov    (%ebx),%eax
80108609:	a8 01                	test   $0x1,%al
8010860b:	74 f3                	je     80108600 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010860d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108612:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108615:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108618:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010861d:	50                   	push   %eax
8010861e:	e8 7d b1 ff ff       	call   801037a0 <kfree>
80108623:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108626:	39 df                	cmp    %ebx,%edi
80108628:	75 dd                	jne    80108607 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010862a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010862d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108630:	5b                   	pop    %ebx
80108631:	5e                   	pop    %esi
80108632:	5f                   	pop    %edi
80108633:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108634:	e9 67 b1 ff ff       	jmp    801037a0 <kfree>
    panic("freevm: no pgdir");
80108639:	83 ec 0c             	sub    $0xc,%esp
8010863c:	68 25 94 10 80       	push   $0x80109425
80108641:	e8 1a 7e ff ff       	call   80100460 <panic>
80108646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010864d:	8d 76 00             	lea    0x0(%esi),%esi

80108650 <setupkvm>:
{
80108650:	55                   	push   %ebp
80108651:	89 e5                	mov    %esp,%ebp
80108653:	56                   	push   %esi
80108654:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108655:	e8 06 b3 ff ff       	call   80103960 <kalloc>
8010865a:	89 c6                	mov    %eax,%esi
8010865c:	85 c0                	test   %eax,%eax
8010865e:	74 42                	je     801086a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108660:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108663:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108668:	68 00 10 00 00       	push   $0x1000
8010866d:	6a 00                	push   $0x0
8010866f:	50                   	push   %eax
80108670:	e8 4b d5 ff ff       	call   80105bc0 <memset>
80108675:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108678:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010867b:	83 ec 08             	sub    $0x8,%esp
8010867e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108681:	ff 73 0c             	push   0xc(%ebx)
80108684:	8b 13                	mov    (%ebx),%edx
80108686:	50                   	push   %eax
80108687:	29 c1                	sub    %eax,%ecx
80108689:	89 f0                	mov    %esi,%eax
8010868b:	e8 d0 f9 ff ff       	call   80108060 <mappages>
80108690:	83 c4 10             	add    $0x10,%esp
80108693:	85 c0                	test   %eax,%eax
80108695:	78 19                	js     801086b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108697:	83 c3 10             	add    $0x10,%ebx
8010869a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801086a0:	75 d6                	jne    80108678 <setupkvm+0x28>
}
801086a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801086a5:	89 f0                	mov    %esi,%eax
801086a7:	5b                   	pop    %ebx
801086a8:	5e                   	pop    %esi
801086a9:	5d                   	pop    %ebp
801086aa:	c3                   	ret    
801086ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801086af:	90                   	nop
      freevm(pgdir);
801086b0:	83 ec 0c             	sub    $0xc,%esp
801086b3:	56                   	push   %esi
      return 0;
801086b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801086b6:	e8 15 ff ff ff       	call   801085d0 <freevm>
      return 0;
801086bb:	83 c4 10             	add    $0x10,%esp
}
801086be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801086c1:	89 f0                	mov    %esi,%eax
801086c3:	5b                   	pop    %ebx
801086c4:	5e                   	pop    %esi
801086c5:	5d                   	pop    %ebp
801086c6:	c3                   	ret    
801086c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086ce:	66 90                	xchg   %ax,%ax

801086d0 <kvmalloc>:
{
801086d0:	55                   	push   %ebp
801086d1:	89 e5                	mov    %esp,%ebp
801086d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801086d6:	e8 75 ff ff ff       	call   80108650 <setupkvm>
801086db:	a3 64 d5 11 80       	mov    %eax,0x8011d564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801086e0:	05 00 00 00 80       	add    $0x80000000,%eax
801086e5:	0f 22 d8             	mov    %eax,%cr3
}
801086e8:	c9                   	leave  
801086e9:	c3                   	ret    
801086ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801086f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801086f0:	55                   	push   %ebp
801086f1:	89 e5                	mov    %esp,%ebp
801086f3:	83 ec 08             	sub    $0x8,%esp
801086f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801086f9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801086fc:	89 c1                	mov    %eax,%ecx
801086fe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108701:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108704:	f6 c2 01             	test   $0x1,%dl
80108707:	75 17                	jne    80108720 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108709:	83 ec 0c             	sub    $0xc,%esp
8010870c:	68 36 94 10 80       	push   $0x80109436
80108711:	e8 4a 7d ff ff       	call   80100460 <panic>
80108716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010871d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108720:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108723:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108729:	25 fc 0f 00 00       	and    $0xffc,%eax
8010872e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108735:	85 c0                	test   %eax,%eax
80108737:	74 d0                	je     80108709 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108739:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010873c:	c9                   	leave  
8010873d:	c3                   	ret    
8010873e:	66 90                	xchg   %ax,%ax

80108740 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108740:	55                   	push   %ebp
80108741:	89 e5                	mov    %esp,%ebp
80108743:	57                   	push   %edi
80108744:	56                   	push   %esi
80108745:	53                   	push   %ebx
80108746:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108749:	e8 02 ff ff ff       	call   80108650 <setupkvm>
8010874e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108751:	85 c0                	test   %eax,%eax
80108753:	0f 84 bd 00 00 00    	je     80108816 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108759:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010875c:	85 c9                	test   %ecx,%ecx
8010875e:	0f 84 b2 00 00 00    	je     80108816 <copyuvm+0xd6>
80108764:	31 f6                	xor    %esi,%esi
80108766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010876d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108770:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108773:	89 f0                	mov    %esi,%eax
80108775:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108778:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010877b:	a8 01                	test   $0x1,%al
8010877d:	75 11                	jne    80108790 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010877f:	83 ec 0c             	sub    $0xc,%esp
80108782:	68 40 94 10 80       	push   $0x80109440
80108787:	e8 d4 7c ff ff       	call   80100460 <panic>
8010878c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108790:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108792:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108797:	c1 ea 0a             	shr    $0xa,%edx
8010879a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801087a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801087a7:	85 c0                	test   %eax,%eax
801087a9:	74 d4                	je     8010877f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801087ab:	8b 00                	mov    (%eax),%eax
801087ad:	a8 01                	test   $0x1,%al
801087af:	0f 84 9f 00 00 00    	je     80108854 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801087b5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801087b7:	25 ff 0f 00 00       	and    $0xfff,%eax
801087bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801087bf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801087c5:	e8 96 b1 ff ff       	call   80103960 <kalloc>
801087ca:	89 c3                	mov    %eax,%ebx
801087cc:	85 c0                	test   %eax,%eax
801087ce:	74 64                	je     80108834 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801087d0:	83 ec 04             	sub    $0x4,%esp
801087d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801087d9:	68 00 10 00 00       	push   $0x1000
801087de:	57                   	push   %edi
801087df:	50                   	push   %eax
801087e0:	e8 7b d4 ff ff       	call   80105c60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801087e5:	58                   	pop    %eax
801087e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801087ec:	5a                   	pop    %edx
801087ed:	ff 75 e4             	push   -0x1c(%ebp)
801087f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801087f5:	89 f2                	mov    %esi,%edx
801087f7:	50                   	push   %eax
801087f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087fb:	e8 60 f8 ff ff       	call   80108060 <mappages>
80108800:	83 c4 10             	add    $0x10,%esp
80108803:	85 c0                	test   %eax,%eax
80108805:	78 21                	js     80108828 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108807:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010880d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108810:	0f 87 5a ff ff ff    	ja     80108770 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108816:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010881c:	5b                   	pop    %ebx
8010881d:	5e                   	pop    %esi
8010881e:	5f                   	pop    %edi
8010881f:	5d                   	pop    %ebp
80108820:	c3                   	ret    
80108821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108828:	83 ec 0c             	sub    $0xc,%esp
8010882b:	53                   	push   %ebx
8010882c:	e8 6f af ff ff       	call   801037a0 <kfree>
      goto bad;
80108831:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108834:	83 ec 0c             	sub    $0xc,%esp
80108837:	ff 75 e0             	push   -0x20(%ebp)
8010883a:	e8 91 fd ff ff       	call   801085d0 <freevm>
  return 0;
8010883f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108846:	83 c4 10             	add    $0x10,%esp
}
80108849:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010884c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010884f:	5b                   	pop    %ebx
80108850:	5e                   	pop    %esi
80108851:	5f                   	pop    %edi
80108852:	5d                   	pop    %ebp
80108853:	c3                   	ret    
      panic("copyuvm: page not present");
80108854:	83 ec 0c             	sub    $0xc,%esp
80108857:	68 5a 94 10 80       	push   $0x8010945a
8010885c:	e8 ff 7b ff ff       	call   80100460 <panic>
80108861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010886f:	90                   	nop

80108870 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108870:	55                   	push   %ebp
80108871:	89 e5                	mov    %esp,%ebp
80108873:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108876:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108879:	89 c1                	mov    %eax,%ecx
8010887b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010887e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108881:	f6 c2 01             	test   $0x1,%dl
80108884:	0f 84 00 01 00 00    	je     8010898a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010888a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010888d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108893:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108894:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108899:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801088a0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801088a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801088a7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801088aa:	05 00 00 00 80       	add    $0x80000000,%eax
801088af:	83 fa 05             	cmp    $0x5,%edx
801088b2:	ba 00 00 00 00       	mov    $0x0,%edx
801088b7:	0f 45 c2             	cmovne %edx,%eax
}
801088ba:	c3                   	ret    
801088bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801088bf:	90                   	nop

801088c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801088c0:	55                   	push   %ebp
801088c1:	89 e5                	mov    %esp,%ebp
801088c3:	57                   	push   %edi
801088c4:	56                   	push   %esi
801088c5:	53                   	push   %ebx
801088c6:	83 ec 0c             	sub    $0xc,%esp
801088c9:	8b 75 14             	mov    0x14(%ebp),%esi
801088cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801088cf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801088d2:	85 f6                	test   %esi,%esi
801088d4:	75 51                	jne    80108927 <copyout+0x67>
801088d6:	e9 a5 00 00 00       	jmp    80108980 <copyout+0xc0>
801088db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801088df:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801088e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801088e6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801088ec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801088f2:	74 75                	je     80108969 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801088f4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801088f6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801088f9:	29 c3                	sub    %eax,%ebx
801088fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108901:	39 f3                	cmp    %esi,%ebx
80108903:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108906:	29 f8                	sub    %edi,%eax
80108908:	83 ec 04             	sub    $0x4,%esp
8010890b:	01 c1                	add    %eax,%ecx
8010890d:	53                   	push   %ebx
8010890e:	52                   	push   %edx
8010890f:	51                   	push   %ecx
80108910:	e8 4b d3 ff ff       	call   80105c60 <memmove>
    len -= n;
    buf += n;
80108915:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108918:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010891e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108921:	01 da                	add    %ebx,%edx
  while(len > 0){
80108923:	29 de                	sub    %ebx,%esi
80108925:	74 59                	je     80108980 <copyout+0xc0>
  if(*pde & PTE_P){
80108927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010892a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010892c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010892e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108931:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108937:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010893a:	f6 c1 01             	test   $0x1,%cl
8010893d:	0f 84 4e 00 00 00    	je     80108991 <copyout.cold>
  return &pgtab[PTX(va)];
80108943:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108945:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010894b:	c1 eb 0c             	shr    $0xc,%ebx
8010894e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108954:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010895b:	89 d9                	mov    %ebx,%ecx
8010895d:	83 e1 05             	and    $0x5,%ecx
80108960:	83 f9 05             	cmp    $0x5,%ecx
80108963:	0f 84 77 ff ff ff    	je     801088e0 <copyout+0x20>
  }
  return 0;
}
80108969:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010896c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108971:	5b                   	pop    %ebx
80108972:	5e                   	pop    %esi
80108973:	5f                   	pop    %edi
80108974:	5d                   	pop    %ebp
80108975:	c3                   	ret    
80108976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010897d:	8d 76 00             	lea    0x0(%esi),%esi
80108980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108983:	31 c0                	xor    %eax,%eax
}
80108985:	5b                   	pop    %ebx
80108986:	5e                   	pop    %esi
80108987:	5f                   	pop    %edi
80108988:	5d                   	pop    %ebp
80108989:	c3                   	ret    

8010898a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010898a:	a1 00 00 00 00       	mov    0x0,%eax
8010898f:	0f 0b                	ud2    

80108991 <copyout.cold>:
80108991:	a1 00 00 00 00       	mov    0x0,%eax
80108996:	0f 0b                	ud2    
