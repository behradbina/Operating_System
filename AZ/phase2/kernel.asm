
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
8010004c:	68 80 8b 10 80       	push   $0x80108b80
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 65 5a 00 00       	call   80105ac0 <initlock>
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
80100092:	68 87 8b 10 80       	push   $0x80108b87
80100097:	50                   	push   %eax
80100098:	e8 f3 58 00 00       	call   80105990 <initsleeplock>
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
801000e4:	e8 a7 5b 00 00       	call   80105c90 <acquire>
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
80100162:	e8 c9 5a 00 00       	call   80105c30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 58 00 00       	call   801059d0 <acquiresleep>
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
801001a1:	68 8e 8b 10 80       	push   $0x80108b8e
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
801001be:	e8 ad 58 00 00       	call   80105a70 <holdingsleep>
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
801001dc:	68 9f 8b 10 80       	push   $0x80108b9f
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
801001ff:	e8 6c 58 00 00       	call   80105a70 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 58 00 00       	call   80105a30 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 70 5a 00 00       	call   80105c90 <acquire>
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
8010026c:	e9 bf 59 00 00       	jmp    80105c30 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 8b 10 80       	push   $0x80108ba6
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
801002a0:	e8 eb 59 00 00       	call   80105c90 <acquire>
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
801002f6:	e8 35 59 00 00       	call   80105c30 <release>
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
8010034c:	e8 df 58 00 00       	call   80105c30 <release>
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
80100482:	68 ad 8b 10 80       	push   $0x80108bad
80100487:	e8 54 03 00 00       	call   801007e0 <cprintf>
  cprintf(s);
8010048c:	58                   	pop    %eax
8010048d:	ff 75 08             	push   0x8(%ebp)
80100490:	e8 4b 03 00 00       	call   801007e0 <cprintf>
  cprintf("\n");
80100495:	c7 04 24 f4 91 10 80 	movl   $0x801091f4,(%esp)
8010049c:	e8 3f 03 00 00       	call   801007e0 <cprintf>
  getcallerpcs(&s, pcs);
801004a1:	8d 45 08             	lea    0x8(%ebp),%eax
801004a4:	5a                   	pop    %edx
801004a5:	59                   	pop    %ecx
801004a6:	53                   	push   %ebx
801004a7:	50                   	push   %eax
801004a8:	e8 33 56 00 00       	call   80105ae0 <getcallerpcs>
  for(i=0; i<10; i++)
801004ad:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004b0:	83 ec 08             	sub    $0x8,%esp
801004b3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004b5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004b8:	68 c1 8b 10 80       	push   $0x80108bc1
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
801004fa:	e8 91 71 00 00       	call   80107690 <uartputc>
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
80100645:	e8 46 70 00 00       	call   80107690 <uartputc>
    uartputc(' ');
8010064a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100651:	e8 3a 70 00 00       	call   80107690 <uartputc>
    uartputc('\b');
80100656:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010065d:	e8 2e 70 00 00       	call   80107690 <uartputc>
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
80100687:	e8 64 57 00 00       	call   80105df0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010068c:	b8 80 07 00 00       	mov    $0x780,%eax
80100691:	83 c4 0c             	add    $0xc,%esp
80100694:	29 f8                	sub    %edi,%eax
80100696:	01 c0                	add    %eax,%eax
80100698:	50                   	push   %eax
80100699:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801006a0:	6a 00                	push   $0x0
801006a2:	50                   	push   %eax
801006a3:	e8 a8 56 00 00       	call   80105d50 <memset>
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
801006a8:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801006ac:	03 3d f8 1a 11 80    	add    0x80111af8,%edi
801006b2:	83 c4 10             	add    $0x10,%esp
801006b5:	e9 ed fe ff ff       	jmp    801005a7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801006ba:	83 ec 0c             	sub    $0xc,%esp
801006bd:	68 c5 8b 10 80       	push   $0x80108bc5
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
801006eb:	e8 a0 55 00 00       	call   80105c90 <acquire>
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
80100724:	e8 07 55 00 00       	call   80105c30 <release>
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
80100776:	0f b6 92 30 8c 10 80 	movzbl -0x7fef73d0(%edx),%edx
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
80100928:	e8 63 53 00 00       	call   80105c90 <acquire>
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
80100978:	bf d8 8b 10 80       	mov    $0x80108bd8,%edi
      for(; *s; s++)
8010097d:	b8 28 00 00 00       	mov    $0x28,%eax
80100982:	e9 19 ff ff ff       	jmp    801008a0 <cprintf+0xc0>
80100987:	89 d0                	mov    %edx,%eax
80100989:	e8 52 fb ff ff       	call   801004e0 <consputc.part.0>
8010098e:	e9 c8 fe ff ff       	jmp    8010085b <cprintf+0x7b>
    release(&cons.lock);
80100993:	83 ec 0c             	sub    $0xc,%esp
80100996:	68 c0 1a 11 80       	push   $0x80111ac0
8010099b:	e8 90 52 00 00       	call   80105c30 <release>
801009a0:	83 c4 10             	add    $0x10,%esp
}
801009a3:	e9 c9 fe ff ff       	jmp    80100871 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801009a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801009ab:	e9 ab fe ff ff       	jmp    8010085b <cprintf+0x7b>
    panic("null fmt");
801009b0:	83 ec 0c             	sub    $0xc,%esp
801009b3:	68 df 8b 10 80       	push   $0x80108bdf
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
80101236:	68 e8 8b 10 80       	push   $0x80108be8
8010123b:	68 c0 1a 11 80       	push   $0x80111ac0
80101240:	e8 7b 48 00 00       	call   80105ac0 <initlock>
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
80101751:	e8 3a 45 00 00       	call   80105c90 <acquire>
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
80101783:	ff 24 85 f0 8b 10 80 	jmp    *-0x7fef7410(,%eax,4)
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
80101858:	e8 d3 43 00 00       	call   80105c30 <release>
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
80101b15:	e8 36 42 00 00       	call   80105d50 <memset>
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
80101e14:	e8 07 6a 00 00       	call   80108820 <setupkvm>
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
80101e83:	e8 b8 67 00 00       	call   80108640 <allocuvm>
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
80101eb9:	e8 92 66 00 00       	call   80108550 <loaduvm>
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
80101efb:	e8 a0 68 00 00       	call   801087a0 <freevm>
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
80101f42:	e8 f9 66 00 00       	call   80108640 <allocuvm>
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
80101f63:	e8 58 69 00 00       	call   801088c0 <clearpteu>
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
80101fb3:	e8 98 3f 00 00       	call   80105f50 <strlen>
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
80101fc7:	e8 84 3f 00 00       	call   80105f50 <strlen>
80101fcc:	83 c0 01             	add    $0x1,%eax
80101fcf:	50                   	push   %eax
80101fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd3:	ff 34 b8             	push   (%eax,%edi,4)
80101fd6:	53                   	push   %ebx
80101fd7:	56                   	push   %esi
80101fd8:	e8 b3 6a 00 00       	call   80108a90 <copyout>
80101fdd:	83 c4 20             	add    $0x20,%esp
80101fe0:	85 c0                	test   %eax,%eax
80101fe2:	79 ac                	jns    80101f90 <exec+0x200>
80101fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101ff1:	e8 aa 67 00 00       	call   801087a0 <freevm>
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
80102043:	e8 48 6a 00 00       	call   80108a90 <copyout>
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
80102081:	e8 8a 3e 00 00       	call   80105f10 <safestrcpy>
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
801020ad:	e8 0e 63 00 00       	call   801083c0 <switchuvm>
  freevm(oldpgdir);
801020b2:	89 3c 24             	mov    %edi,(%esp)
801020b5:	e8 e6 66 00 00       	call   801087a0 <freevm>
  return 0;
801020ba:	83 c4 10             	add    $0x10,%esp
801020bd:	31 c0                	xor    %eax,%eax
801020bf:	e9 38 fd ff ff       	jmp    80101dfc <exec+0x6c>
    end_op();
801020c4:	e8 e7 1f 00 00       	call   801040b0 <end_op>
    cprintf("exec: fail\n");
801020c9:	83 ec 0c             	sub    $0xc,%esp
801020cc:	68 41 8c 10 80       	push   $0x80108c41
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
801020f6:	68 4d 8c 10 80       	push   $0x80108c4d
801020fb:	68 00 1b 11 80       	push   $0x80111b00
80102100:	e8 bb 39 00 00       	call   80105ac0 <initlock>
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
80102121:	e8 6a 3b 00 00       	call   80105c90 <acquire>
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
80102151:	e8 da 3a 00 00       	call   80105c30 <release>
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
8010216a:	e8 c1 3a 00 00       	call   80105c30 <release>
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
8010218f:	e8 fc 3a 00 00       	call   80105c90 <acquire>
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
801021ac:	e8 7f 3a 00 00       	call   80105c30 <release>
  return f;
}
801021b1:	89 d8                	mov    %ebx,%eax
801021b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021b6:	c9                   	leave  
801021b7:	c3                   	ret    
    panic("filedup");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 54 8c 10 80       	push   $0x80108c54
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
801021e1:	e8 aa 3a 00 00       	call   80105c90 <acquire>
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
8010221c:	e8 0f 3a 00 00       	call   80105c30 <release>

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
8010224e:	e9 dd 39 00 00       	jmp    80105c30 <release>
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
8010229c:	68 5c 8c 10 80       	push   $0x80108c5c
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
80102382:	68 66 8c 10 80       	push   $0x80108c66
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
80102457:	68 6f 8c 10 80       	push   $0x80108c6f
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
80102491:	68 75 8c 10 80       	push   $0x80108c75
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
80102507:	68 7f 8c 10 80       	push   $0x80108c7f
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
801025c4:	68 92 8c 10 80       	push   $0x80108c92
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
80102605:	e8 46 37 00 00       	call   80105d50 <memset>
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
8010264a:	e8 41 36 00 00       	call   80105c90 <acquire>
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
801026b7:	e8 74 35 00 00       	call   80105c30 <release>

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
801026e5:	e8 46 35 00 00       	call   80105c30 <release>
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
80102718:	68 a8 8c 10 80       	push   $0x80108ca8
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
801027f5:	68 b8 8c 10 80       	push   $0x80108cb8
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
80102821:	e8 ca 35 00 00       	call   80105df0 <memmove>
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
8010284c:	68 cb 8c 10 80       	push   $0x80108ccb
80102851:	68 00 25 11 80       	push   $0x80112500
80102856:	e8 65 32 00 00       	call   80105ac0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010285b:	83 c4 10             	add    $0x10,%esp
8010285e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	68 d2 8c 10 80       	push   $0x80108cd2
80102868:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102869:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010286f:	e8 1c 31 00 00       	call   80105990 <initsleeplock>
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
8010289c:	e8 4f 35 00 00       	call   80105df0 <memmove>
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
801028d3:	68 38 8d 10 80       	push   $0x80108d38
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
8010296e:	e8 dd 33 00 00       	call   80105d50 <memset>
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
801029a3:	68 d8 8c 10 80       	push   $0x80108cd8
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
80102a11:	e8 da 33 00 00       	call   80105df0 <memmove>
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
80102a3f:	e8 4c 32 00 00       	call   80105c90 <acquire>
  ip->ref++;
80102a44:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102a48:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102a4f:	e8 dc 31 00 00       	call   80105c30 <release>
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
80102a82:	e8 49 2f 00 00       	call   801059d0 <acquiresleep>
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
80102af8:	e8 f3 32 00 00       	call   80105df0 <memmove>
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
80102b1d:	68 f0 8c 10 80       	push   $0x80108cf0
80102b22:	e8 39 d9 ff ff       	call   80100460 <panic>
    panic("ilock");
80102b27:	83 ec 0c             	sub    $0xc,%esp
80102b2a:	68 ea 8c 10 80       	push   $0x80108cea
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
80102b53:	e8 18 2f 00 00       	call   80105a70 <holdingsleep>
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
80102b6f:	e9 bc 2e 00 00       	jmp    80105a30 <releasesleep>
    panic("iunlock");
80102b74:	83 ec 0c             	sub    $0xc,%esp
80102b77:	68 ff 8c 10 80       	push   $0x80108cff
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
80102ba0:	e8 2b 2e 00 00       	call   801059d0 <acquiresleep>
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
80102bba:	e8 71 2e 00 00       	call   80105a30 <releasesleep>
  acquire(&icache.lock);
80102bbf:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102bc6:	e8 c5 30 00 00       	call   80105c90 <acquire>
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
80102be0:	e9 4b 30 00 00       	jmp    80105c30 <release>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102be8:	83 ec 0c             	sub    $0xc,%esp
80102beb:	68 00 25 11 80       	push   $0x80112500
80102bf0:	e8 9b 30 00 00       	call   80105c90 <acquire>
    int r = ip->ref;
80102bf5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102bf8:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102bff:	e8 2c 30 00 00       	call   80105c30 <release>
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
80102d03:	e8 68 2d 00 00       	call   80105a70 <holdingsleep>
80102d08:	83 c4 10             	add    $0x10,%esp
80102d0b:	85 c0                	test   %eax,%eax
80102d0d:	74 21                	je     80102d30 <iunlockput+0x40>
80102d0f:	8b 43 08             	mov    0x8(%ebx),%eax
80102d12:	85 c0                	test   %eax,%eax
80102d14:	7e 1a                	jle    80102d30 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102d16:	83 ec 0c             	sub    $0xc,%esp
80102d19:	56                   	push   %esi
80102d1a:	e8 11 2d 00 00       	call   80105a30 <releasesleep>
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
80102d33:	68 ff 8c 10 80       	push   $0x80108cff
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
80102e17:	e8 d4 2f 00 00       	call   80105df0 <memmove>
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
80102f13:	e8 d8 2e 00 00       	call   80105df0 <memmove>
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
80102fae:	e8 ad 2e 00 00       	call   80105e60 <strncmp>
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
8010300d:	e8 4e 2e 00 00       	call   80105e60 <strncmp>
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
80103052:	68 19 8d 10 80       	push   $0x80108d19
80103057:	e8 04 d4 ff ff       	call   80100460 <panic>
    panic("dirlookup not DIR");
8010305c:	83 ec 0c             	sub    $0xc,%esp
8010305f:	68 07 8d 10 80       	push   $0x80108d07
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
8010309a:	e8 f1 2b 00 00       	call   80105c90 <acquire>
  ip->ref++;
8010309f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801030a3:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
801030aa:	e8 81 2b 00 00       	call   80105c30 <release>
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
80103107:	e8 e4 2c 00 00       	call   80105df0 <memmove>
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
8010316c:	e8 ff 28 00 00       	call   80105a70 <holdingsleep>
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
8010318e:	e8 9d 28 00 00       	call   80105a30 <releasesleep>
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
801031bb:	e8 30 2c 00 00       	call   80105df0 <memmove>
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
8010320b:	e8 60 28 00 00       	call   80105a70 <holdingsleep>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	85 c0                	test   %eax,%eax
80103215:	0f 84 91 00 00 00    	je     801032ac <namex+0x23c>
8010321b:	8b 46 08             	mov    0x8(%esi),%eax
8010321e:	85 c0                	test   %eax,%eax
80103220:	0f 8e 86 00 00 00    	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	53                   	push   %ebx
8010322a:	e8 01 28 00 00       	call   80105a30 <releasesleep>
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
8010324d:	e8 1e 28 00 00       	call   80105a70 <holdingsleep>
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
80103270:	e8 fb 27 00 00       	call   80105a70 <holdingsleep>
80103275:	83 c4 10             	add    $0x10,%esp
80103278:	85 c0                	test   %eax,%eax
8010327a:	74 30                	je     801032ac <namex+0x23c>
8010327c:	8b 7e 08             	mov    0x8(%esi),%edi
8010327f:	85 ff                	test   %edi,%edi
80103281:	7e 29                	jle    801032ac <namex+0x23c>
  releasesleep(&ip->lock);
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	53                   	push   %ebx
80103287:	e8 a4 27 00 00       	call   80105a30 <releasesleep>
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
801032af:	68 ff 8c 10 80       	push   $0x80108cff
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
8010331d:	e8 8e 2b 00 00       	call   80105eb0 <strncpy>
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
8010335b:	68 28 8d 10 80       	push   $0x80108d28
80103360:	e8 fb d0 ff ff       	call   80100460 <panic>
    panic("dirlink");
80103365:	83 ec 0c             	sub    $0xc,%esp
80103368:	68 ba 93 10 80       	push   $0x801093ba
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
8010347b:	68 94 8d 10 80       	push   $0x80108d94
80103480:	e8 db cf ff ff       	call   80100460 <panic>
    panic("idestart");
80103485:	83 ec 0c             	sub    $0xc,%esp
80103488:	68 8b 8d 10 80       	push   $0x80108d8b
8010348d:	e8 ce cf ff ff       	call   80100460 <panic>
80103492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <ideinit>:
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801034a6:	68 a6 8d 10 80       	push   $0x80108da6
801034ab:	68 a0 41 11 80       	push   $0x801141a0
801034b0:	e8 0b 26 00 00       	call   80105ac0 <initlock>
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
8010352e:	e8 5d 27 00 00       	call   80105c90 <acquire>

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
801035ab:	e8 80 26 00 00       	call   80105c30 <release>

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
801035ce:	e8 9d 24 00 00       	call   80105a70 <holdingsleep>
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
80103608:	e8 83 26 00 00       	call   80105c90 <acquire>

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
80103666:	e9 c5 25 00 00       	jmp    80105c30 <release>
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
8010368a:	68 d5 8d 10 80       	push   $0x80108dd5
8010368f:	e8 cc cd ff ff       	call   80100460 <panic>
    panic("iderw: nothing to do");
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	68 c0 8d 10 80       	push   $0x80108dc0
8010369c:	e8 bf cd ff ff       	call   80100460 <panic>
    panic("iderw: buf not locked");
801036a1:	83 ec 0c             	sub    $0xc,%esp
801036a4:	68 aa 8d 10 80       	push   $0x80108daa
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
801036fa:	68 f4 8d 10 80       	push   $0x80108df4
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
801037d2:	e8 79 25 00 00       	call   80105d50 <memset>

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
80103808:	e8 83 24 00 00       	call   80105c90 <acquire>
8010380d:	83 c4 10             	add    $0x10,%esp
80103810:	eb d2                	jmp    801037e4 <kfree+0x44>
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103818:	c7 45 08 e0 41 11 80 	movl   $0x801141e0,0x8(%ebp)
}
8010381f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103822:	c9                   	leave  
    release(&kmem.lock);
80103823:	e9 08 24 00 00       	jmp    80105c30 <release>
    panic("kfree");
80103828:	83 ec 0c             	sub    $0xc,%esp
8010382b:	68 26 8e 10 80       	push   $0x80108e26
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
801038fb:	68 2c 8e 10 80       	push   $0x80108e2c
80103900:	68 e0 41 11 80       	push   $0x801141e0
80103905:	e8 b6 21 00 00       	call   80105ac0 <initlock>
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
80103993:	e8 f8 22 00 00       	call   80105c90 <acquire>
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
801039c1:	e8 6a 22 00 00       	call   80105c30 <release>
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
80103a0b:	0f b6 91 60 8f 10 80 	movzbl -0x7fef70a0(%ecx),%edx
  shift ^= togglecode[data];
80103a12:	0f b6 81 60 8e 10 80 	movzbl -0x7fef71a0(%ecx),%eax
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
80103a2b:	8b 04 85 40 8e 10 80 	mov    -0x7fef71c0(,%eax,4),%eax
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
80103a68:	0f b6 81 60 8f 10 80 	movzbl -0x7fef70a0(%ecx),%eax
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
80103dd7:	e8 c4 1f 00 00       	call   80105da0 <memcmp>
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
80103f04:	e8 e7 1e 00 00       	call   80105df0 <memmove>
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
80103faa:	68 60 90 10 80       	push   $0x80109060
80103faf:	68 40 42 11 80       	push   $0x80114240
80103fb4:	e8 07 1b 00 00       	call   80105ac0 <initlock>
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
8010404b:	e8 40 1c 00 00       	call   80105c90 <acquire>
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
8010409c:	e8 8f 1b 00 00       	call   80105c30 <release>
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
801040be:	e8 cd 1b 00 00       	call   80105c90 <acquire>
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
801040fc:	e8 2f 1b 00 00       	call   80105c30 <release>
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
80104116:	e8 75 1b 00 00       	call   80105c90 <acquire>
    wakeup(&log);
8010411b:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
    log.committing = 0;
80104122:	c7 05 80 42 11 80 00 	movl   $0x0,0x80114280
80104129:	00 00 00 
    wakeup(&log);
8010412c:	e8 bf 12 00 00       	call   801053f0 <wakeup>
    release(&log.lock);
80104131:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80104138:	e8 f3 1a 00 00       	call   80105c30 <release>
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
80104194:	e8 57 1c 00 00       	call   80105df0 <memmove>
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
801041f4:	e8 37 1a 00 00       	call   80105c30 <release>
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
80104207:	68 64 90 10 80       	push   $0x80109064
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
80104256:	e8 35 1a 00 00       	call   80105c90 <acquire>
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
80104295:	e9 96 19 00 00       	jmp    80105c30 <release>
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
801042c1:	68 73 90 10 80       	push   $0x80109073
801042c6:	e8 95 c1 ff ff       	call   80100460 <panic>
    panic("log_write outside of trans");
801042cb:	83 ec 0c             	sub    $0xc,%esp
801042ce:	68 89 90 10 80       	push   $0x80109089
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
801042f8:	68 a4 90 10 80       	push   $0x801090a4
801042fd:	e8 de c4 ff ff       	call   801007e0 <cprintf>
  idtinit();       // load idt register
80104302:	e8 79 2f 00 00       	call   80107280 <idtinit>
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
80104326:	e8 85 40 00 00       	call   801083b0 <switchkvm>
  seginit();
8010432b:	e8 f0 3f 00 00       	call   80108320 <seginit>
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
80104361:	e8 3a 45 00 00       	call   801088a0 <kvmalloc>
  mpinit();        // detect other processors
80104366:	e8 85 01 00 00       	call   801044f0 <mpinit>
  lapicinit();     // interrupt controller
8010436b:	e8 60 f7 ff ff       	call   80103ad0 <lapicinit>
  seginit();       // segment descriptors
80104370:	e8 ab 3f 00 00       	call   80108320 <seginit>
  picinit();       // disable pic
80104375:	e8 76 03 00 00       	call   801046f0 <picinit>
  ioapicinit();    // another interrupt controller
8010437a:	e8 31 f3 ff ff       	call   801036b0 <ioapicinit>
  consoleinit();   // console hardware
8010437f:	e8 ac ce ff ff       	call   80101230 <consoleinit>
  uartinit();      // serial port
80104384:	e8 27 32 00 00       	call   801075b0 <uartinit>
  pinit();         // process table
80104389:	e8 32 08 00 00       	call   80104bc0 <pinit>
  tvinit();        // trap vectors
8010438e:	e8 6d 2e 00 00       	call   80107200 <tvinit>
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
801043b4:	e8 37 1a 00 00       	call   80105df0 <memmove>

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
8010449e:	68 b8 90 10 80       	push   $0x801090b8
801044a3:	56                   	push   %esi
801044a4:	e8 f7 18 00 00       	call   80105da0 <memcmp>
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
80104556:	68 bd 90 10 80       	push   $0x801090bd
8010455b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010455c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010455f:	e8 3c 18 00 00       	call   80105da0 <memcmp>
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
80104673:	68 c2 90 10 80       	push   $0x801090c2
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
801046a2:	68 b8 90 10 80       	push   $0x801090b8
801046a7:	53                   	push   %ebx
801046a8:	e8 f3 16 00 00       	call   80105da0 <memcmp>
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
801046d8:	68 dc 90 10 80       	push   $0x801090dc
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
80104783:	68 fb 90 10 80       	push   $0x801090fb
80104788:	50                   	push   %eax
80104789:	e8 32 13 00 00       	call   80105ac0 <initlock>
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
8010481f:	e8 6c 14 00 00       	call   80105c90 <acquire>
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
80104864:	e9 c7 13 00 00       	jmp    80105c30 <release>
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	53                   	push   %ebx
80104874:	e8 b7 13 00 00       	call   80105c30 <release>
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
801048bd:	e8 ce 13 00 00       	call   80105c90 <acquire>
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
8010494c:	e8 df 12 00 00       	call   80105c30 <release>
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
801049a2:	e8 89 12 00 00       	call   80105c30 <release>
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
801049c6:	e8 c5 12 00 00       	call   80105c90 <acquire>
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
80104a5e:	e8 cd 11 00 00       	call   80105c30 <release>
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
80104a79:	e8 b2 11 00 00       	call   80105c30 <release>
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
80104aa1:	e8 ea 11 00 00       	call   80105c90 <acquire>
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
80104af3:	e8 38 11 00 00       	call   80105c30 <release>

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
80104b18:	c7 40 14 e9 71 10 80 	movl   $0x801071e9,0x14(%eax)
  p->context = (struct context*)sp;
80104b1f:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104b22:	6a 14                	push   $0x14
80104b24:	6a 00                	push   $0x0
80104b26:	50                   	push   %eax
80104b27:	e8 24 12 00 00       	call   80105d50 <memset>
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
80104b4a:	e8 e1 10 00 00       	call   80105c30 <release>
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
80104b7b:	e8 b0 10 00 00       	call   80105c30 <release>

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
80104bc6:	68 00 91 10 80       	push   $0x80109100
80104bcb:	68 c0 48 11 80       	push   $0x801148c0
80104bd0:	e8 eb 0e 00 00       	call   80105ac0 <initlock>
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
80104c28:	68 07 91 10 80       	push   $0x80109107
80104c2d:	e8 2e b8 ff ff       	call   80100460 <panic>
    panic("mycpu called with interrupts enabled\n");
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	68 20 92 10 80       	push   $0x80109220
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
80104c67:	e8 d4 0e 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80104c6c:	e8 6f ff ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c77:	e8 14 0f 00 00       	call   80105b90 <popcli>
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
80104ca3:	e8 78 3b 00 00       	call   80108820 <setupkvm>
80104ca8:	89 43 04             	mov    %eax,0x4(%ebx)
80104cab:	85 c0                	test   %eax,%eax
80104cad:	0f 84 bd 00 00 00    	je     80104d70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104cb3:	83 ec 04             	sub    $0x4,%esp
80104cb6:	68 2c 00 00 00       	push   $0x2c
80104cbb:	68 60 c4 10 80       	push   $0x8010c460
80104cc0:	50                   	push   %eax
80104cc1:	e8 0a 38 00 00       	call   801084d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104cc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104ccf:	6a 4c                	push   $0x4c
80104cd1:	6a 00                	push   $0x0
80104cd3:	ff 73 18             	push   0x18(%ebx)
80104cd6:	e8 75 10 00 00       	call   80105d50 <memset>
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
80104d2f:	68 30 91 10 80       	push   $0x80109130
80104d34:	50                   	push   %eax
80104d35:	e8 d6 11 00 00       	call   80105f10 <safestrcpy>
  p->cwd = namei("/");
80104d3a:	c7 04 24 39 91 10 80 	movl   $0x80109139,(%esp)
80104d41:	e8 3a e6 ff ff       	call   80103380 <namei>
80104d46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104d49:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104d50:	e8 3b 0f 00 00       	call   80105c90 <acquire>
  p->state = RUNNABLE;
80104d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104d5c:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104d63:	e8 c8 0e 00 00       	call   80105c30 <release>
}
80104d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d6b:	83 c4 10             	add    $0x10,%esp
80104d6e:	c9                   	leave  
80104d6f:	c3                   	ret    
    panic("userinit: out of memory?");
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 17 91 10 80       	push   $0x80109117
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
80104d88:	e8 b3 0d 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80104d8d:	e8 4e fe ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d98:	e8 f3 0d 00 00       	call   80105b90 <popcli>
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
80104dab:	e8 10 36 00 00       	call   801083c0 <switchuvm>
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
80104dca:	e8 71 38 00 00       	call   80108640 <allocuvm>
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
80104dea:	e8 81 39 00 00       	call   80108770 <deallocuvm>
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
80104e09:	e8 32 0d 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80104e0e:	e8 cd fd ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e19:	e8 72 0d 00 00       	call   80105b90 <popcli>
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
80104e38:	e8 d3 3a 00 00       	call   80108910 <copyuvm>
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
80104eb1:	e8 5a 10 00 00       	call   80105f10 <safestrcpy>
  pid = np->pid;
80104eb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104eb9:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104ec0:	e8 cb 0d 00 00       	call   80105c90 <acquire>
  np->state = RUNNABLE;
80104ec5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104ecc:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104ed3:	e8 58 0d 00 00       	call   80105c30 <release>
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
80104f4e:	e8 3d 0d 00 00       	call   80105c90 <acquire>
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
80104f70:	e8 4b 34 00 00       	call   801083c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104f75:	58                   	pop    %eax
80104f76:	5a                   	pop    %edx
80104f77:	ff 73 1c             	push   0x1c(%ebx)
80104f7a:	57                   	push   %edi
      p->state = RUNNING;
80104f7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104f82:	e8 e4 0f 00 00       	call   80105f6b <swtch>
      switchkvm();
80104f87:	e8 24 34 00 00       	call   801083b0 <switchkvm>
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
80104faf:	e8 7c 0c 00 00       	call   80105c30 <release>
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
80104fc5:	e8 76 0b 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80104fca:	e8 11 fc ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80104fcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104fd5:	e8 b6 0b 00 00       	call   80105b90 <popcli>
  if(!holding(&ptable.lock))
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	68 c0 48 11 80       	push   $0x801148c0
80104fe2:	e8 09 0c 00 00       	call   80105bf0 <holding>
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
80105023:	e8 43 0f 00 00       	call   80105f6b <swtch>
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
80105040:	68 3b 91 10 80       	push   $0x8010913b
80105045:	e8 16 b4 ff ff       	call   80100460 <panic>
    panic("sched interruptible");
8010504a:	83 ec 0c             	sub    $0xc,%esp
8010504d:	68 67 91 10 80       	push   $0x80109167
80105052:	e8 09 b4 ff ff       	call   80100460 <panic>
    panic("sched running");
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	68 59 91 10 80       	push   $0x80109159
8010505f:	e8 fc b3 ff ff       	call   80100460 <panic>
    panic("sched locks");
80105064:	83 ec 0c             	sub    $0xc,%esp
80105067:	68 4d 91 10 80       	push   $0x8010914d
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
801050ea:	e8 a1 0b 00 00       	call   80105c90 <acquire>
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
80105197:	68 88 91 10 80       	push   $0x80109188
8010519c:	e8 bf b2 ff ff       	call   80100460 <panic>
    panic("init exiting");
801051a1:	83 ec 0c             	sub    $0xc,%esp
801051a4:	68 7b 91 10 80       	push   $0x8010917b
801051a9:	e8 b2 b2 ff ff       	call   80100460 <panic>
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <wait>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
  pushcli();
801051b5:	e8 86 09 00 00       	call   80105b40 <pushcli>
  c = mycpu();
801051ba:	e8 21 fa ff ff       	call   80104be0 <mycpu>
  p = c->proc;
801051bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801051c5:	e8 c6 09 00 00       	call   80105b90 <popcli>
  acquire(&ptable.lock);
801051ca:	83 ec 0c             	sub    $0xc,%esp
801051cd:	68 c0 48 11 80       	push   $0x801148c0
801051d2:	e8 b9 0a 00 00       	call   80105c90 <acquire>
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
80105227:	e8 14 09 00 00       	call   80105b40 <pushcli>
  c = mycpu();
8010522c:	e8 af f9 ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80105231:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105237:	e8 54 09 00 00       	call   80105b90 <popcli>
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
80105279:	e8 22 35 00 00       	call   801087a0 <freevm>
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
801052a5:	e8 86 09 00 00       	call   80105c30 <release>
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
801052c3:	e8 68 09 00 00       	call   80105c30 <release>
      return -1;
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	eb e0                	jmp    801052ad <wait+0xfd>
    panic("sleep");
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	68 94 91 10 80       	push   $0x80109194
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
801052ec:	e8 9f 09 00 00       	call   80105c90 <acquire>
  pushcli();
801052f1:	e8 4a 08 00 00       	call   80105b40 <pushcli>
  c = mycpu();
801052f6:	e8 e5 f8 ff ff       	call   80104be0 <mycpu>
  p = c->proc;
801052fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105301:	e8 8a 08 00 00       	call   80105b90 <popcli>
  myproc()->state = RUNNABLE;
80105306:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010530d:	e8 ae fc ff ff       	call   80104fc0 <sched>
  release(&ptable.lock);
80105312:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80105319:	e8 12 09 00 00       	call   80105c30 <release>
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
8010533f:	e8 fc 07 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80105344:	e8 97 f8 ff ff       	call   80104be0 <mycpu>
  p = c->proc;
80105349:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010534f:	e8 3c 08 00 00       	call   80105b90 <popcli>
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
80105370:	e8 1b 09 00 00       	call   80105c90 <acquire>
    release(lk);
80105375:	89 34 24             	mov    %esi,(%esp)
80105378:	e8 b3 08 00 00       	call   80105c30 <release>
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
8010539a:	e8 91 08 00 00       	call   80105c30 <release>
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
801053ac:	e9 df 08 00 00       	jmp    80105c90 <acquire>
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
801053d9:	68 9a 91 10 80       	push   $0x8010919a
801053de:	e8 7d b0 ff ff       	call   80100460 <panic>
    panic("sleep");
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	68 94 91 10 80       	push   $0x80109194
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
801053ff:	e8 8c 08 00 00       	call   80105c90 <acquire>
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
80105445:	e9 e6 07 00 00       	jmp    80105c30 <release>
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
8010545f:	e8 2c 08 00 00       	call   80105c90 <acquire>
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
8010549d:	e8 8e 07 00 00       	call   80105c30 <release>
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
801054b8:	e8 73 07 00 00       	call   80105c30 <release>
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
801054eb:	68 f4 91 10 80       	push   $0x801091f4
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
80105511:	ba ab 91 10 80       	mov    $0x801091ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105516:	83 f8 05             	cmp    $0x5,%eax
80105519:	77 11                	ja     8010552c <procdump+0x5c>
8010551b:	8b 14 85 a8 92 10 80 	mov    -0x7fef6d58(,%eax,4),%edx
      state = "???";
80105522:	b8 ab 91 10 80       	mov    $0x801091ab,%eax
80105527:	85 d2                	test   %edx,%edx
80105529:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010552c:	53                   	push   %ebx
8010552d:	52                   	push   %edx
8010552e:	ff 73 a4             	push   -0x5c(%ebx)
80105531:	68 af 91 10 80       	push   $0x801091af
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
80105558:	e8 83 05 00 00       	call   80105ae0 <getcallerpcs>
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
8010556d:	68 c1 8b 10 80       	push   $0x80108bc1
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
80105632:	68 b8 91 10 80       	push   $0x801091b8
80105637:	e8 a4 b1 ff ff       	call   801007e0 <cprintf>
      for (i = 0; i < p->numsystemcalls; i++)
8010563c:	83 c4 10             	add    $0x10,%esp
8010563f:	39 9e 0c 02 00 00    	cmp    %ebx,0x20c(%esi)
80105645:	7f e1                	jg     80105628 <sort_uniqe_procces+0x98>
      }
      cprintf("\n");
80105647:	83 ec 0c             	sub    $0xc,%esp
8010564a:	68 f4 91 10 80       	push   $0x801091f4
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
8010571f:	e8 2c 06 00 00       	call   80105d50 <memset>
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
801057a2:	68 48 92 10 80       	push   $0x80109248
801057a7:	e8 34 b0 ff ff       	call   801007e0 <cprintf>
       return  i;
801057ac:	83 c4 10             	add    $0x10,%esp
      return 0; 
    }
  }
  cprintf("Pid not found \n");
  return -1;
}
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
}
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
801057cd:	68 cf 91 10 80       	push   $0x801091cf
801057d2:	e8 09 b0 ff ff       	call   801007e0 <cprintf>
  return -1;
801057d7:	83 c4 10             	add    $0x10,%esp
}
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
801057ec:	68 bc 91 10 80       	push   $0x801091bc
801057f1:	e8 ea af ff ff       	call   801007e0 <cprintf>
      return -1;
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	eb b4                	jmp    801057af <get_max_invoked+0x13f>
801057fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ff:	90                   	nop

80105800 <make_create_palindrom>:


int make_create_palindrom(long long int x)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
80105806:	83 ec 40             	sub    $0x40,%esp
80105809:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010580c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  cprintf("Input number is : %d \n" , x);
8010580f:	53                   	push   %ebx
80105810:	51                   	push   %ecx
80105811:	68 df 91 10 80       	push   $0x801091df
80105816:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105819:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010581c:	e8 bf af ff ff       	call   801007e0 <cprintf>
  long long int num = x;
  long long int comp = 0;
  while (x != 0)
80105821:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105824:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	89 d8                	mov    %ebx,%eax
8010582c:	09 c8                	or     %ecx,%eax
8010582e:	0f 84 39 01 00 00    	je     8010596d <make_create_palindrom+0x16d>
  long long int comp = 0;
80105834:	31 f6                	xor    %esi,%esi
80105836:	31 ff                	xor    %edi,%edi
80105838:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010583b:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010583e:	66 90                	xchg   %ax,%ax
  {
    comp = comp * 10 + x % 10;
80105840:	b8 0a 00 00 00       	mov    $0xa,%eax
80105845:	f7 65 d8             	mull   -0x28(%ebp)
80105848:	89 ce                	mov    %ecx,%esi
8010584a:	6b 7d dc 0a          	imul   $0xa,-0x24(%ebp),%edi
8010584e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105851:	89 ca                	mov    %ecx,%edx
80105853:	01 7d dc             	add    %edi,-0x24(%ebp)
80105856:	89 df                	mov    %ebx,%edi
80105858:	81 e2 ff ff ff 0f    	and    $0xfffffff,%edx
8010585e:	0f ac fe 1c          	shrd   $0x1c,%edi,%esi
80105862:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105865:	89 d8                	mov    %ebx,%eax
80105867:	81 e6 ff ff ff 0f    	and    $0xfffffff,%esi
8010586d:	c1 f8 1f             	sar    $0x1f,%eax
80105870:	01 d6                	add    %edx,%esi
80105872:	89 da                	mov    %ebx,%edx
80105874:	89 45 d0             	mov    %eax,-0x30(%ebp)
80105877:	83 e0 03             	and    $0x3,%eax
8010587a:	c1 ea 18             	shr    $0x18,%edx
8010587d:	01 d6                	add    %edx,%esi
8010587f:	01 c6                	add    %eax,%esi
80105881:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80105886:	f7 e6                	mul    %esi
80105888:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010588b:	83 e0 fc             	and    $0xfffffffc,%eax
8010588e:	89 d7                	mov    %edx,%edi
80105890:	81 e2 fc ff ff 7f    	and    $0x7ffffffc,%edx
80105896:	c1 ef 02             	shr    $0x2,%edi
80105899:	01 fa                	add    %edi,%edx
8010589b:	89 df                	mov    %ebx,%edi
8010589d:	29 d6                	sub    %edx,%esi
8010589f:	01 c6                	add    %eax,%esi
801058a1:	89 f0                	mov    %esi,%eax
801058a3:	89 ce                	mov    %ecx,%esi
801058a5:	99                   	cltd   
801058a6:	29 c6                	sub    %eax,%esi
801058a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
801058ab:	19 d7                	sbb    %edx,%edi
801058ad:	69 c6 cc cc cc cc    	imul   $0xcccccccc,%esi,%eax
801058b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801058b6:	69 df cd cc cc cc    	imul   $0xcccccccd,%edi,%ebx
801058bc:	01 c3                	add    %eax,%ebx
801058be:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
801058c3:	f7 e6                	mul    %esi
801058c5:	89 d7                	mov    %edx,%edi
801058c7:	89 c6                	mov    %eax,%esi
801058c9:	01 df                	add    %ebx,%edi
801058cb:	89 fb                	mov    %edi,%ebx
801058cd:	c1 fb 1f             	sar    $0x1f,%ebx
801058d0:	89 d8                	mov    %ebx,%eax
801058d2:	89 d9                	mov    %ebx,%ecx
801058d4:	89 f3                	mov    %esi,%ebx
801058d6:	31 cb                	xor    %ecx,%ebx
801058d8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
801058db:	99                   	cltd   
801058dc:	89 5d c0             	mov    %ebx,-0x40(%ebp)
801058df:	8b 4d c0             	mov    -0x40(%ebp),%ecx
801058e2:	89 fb                	mov    %edi,%ebx
801058e4:	31 d3                	xor    %edx,%ebx
801058e6:	89 55 bc             	mov    %edx,-0x44(%ebp)
801058e9:	29 c1                	sub    %eax,%ecx
801058eb:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
801058ee:	8b 5d bc             	mov    -0x44(%ebp),%ebx
801058f1:	83 e1 01             	and    $0x1,%ecx
801058f4:	33 4d cc             	xor    -0x34(%ebp),%ecx
801058f7:	89 4d b8             	mov    %ecx,-0x48(%ebp)
801058fa:	8b 4d b8             	mov    -0x48(%ebp),%ecx
801058fd:	29 c1                	sub    %eax,%ecx
801058ff:	b8 05 00 00 00       	mov    $0x5,%eax
80105904:	19 d3                	sbb    %edx,%ebx
80105906:	f7 e1                	mul    %ecx
80105908:	89 f9                	mov    %edi,%ecx
8010590a:	8d 1c 9b             	lea    (%ebx,%ebx,4),%ebx
8010590d:	01 da                	add    %ebx,%edx
8010590f:	03 45 d0             	add    -0x30(%ebp),%eax
80105912:	13 55 d4             	adc    -0x2c(%ebp),%edx
80105915:	c1 e9 1f             	shr    $0x1f,%ecx
80105918:	31 db                	xor    %ebx,%ebx
8010591a:	01 f1                	add    %esi,%ecx
8010591c:	8b 75 d8             	mov    -0x28(%ebp),%esi
8010591f:	11 fb                	adc    %edi,%ebx
80105921:	8b 7d dc             	mov    -0x24(%ebp),%edi
80105924:	01 c6                	add    %eax,%esi
80105926:	11 d7                	adc    %edx,%edi
80105928:	89 75 d8             	mov    %esi,-0x28(%ebp)
    x = x / 10;
    num = num * 10;
8010592b:	8b 75 e0             	mov    -0x20(%ebp),%esi
    x = x / 10;
8010592e:	0f ac d9 01          	shrd   $0x1,%ebx,%ecx
    comp = comp * 10 + x % 10;
80105932:	89 7d dc             	mov    %edi,-0x24(%ebp)
    num = num * 10;
80105935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    x = x / 10;
80105938:	d1 fb                	sar    %ebx
    num = num * 10;
8010593a:	6b c7 0a             	imul   $0xa,%edi,%eax
8010593d:	89 45 d0             	mov    %eax,-0x30(%ebp)
80105940:	b8 0a 00 00 00       	mov    $0xa,%eax
80105945:	f7 e6                	mul    %esi
80105947:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010594a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010594d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105950:	01 45 e4             	add    %eax,-0x1c(%ebp)
  while (x != 0)
80105953:	89 d8                	mov    %ebx,%eax
80105955:	09 c8                	or     %ecx,%eax
80105957:	0f 85 e3 fe ff ff    	jne    80105840 <make_create_palindrom+0x40>
  }
  num = num + comp;
8010595d:	8b 75 d8             	mov    -0x28(%ebp),%esi
80105960:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105963:	8b 7d dc             	mov    -0x24(%ebp),%edi
80105966:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105969:	01 f1                	add    %esi,%ecx
8010596b:	11 fb                	adc    %edi,%ebx
  cprintf("palindrom value for given input is : %d \n", num);
8010596d:	83 ec 04             	sub    $0x4,%esp
80105970:	53                   	push   %ebx
80105971:	51                   	push   %ecx
80105972:	68 7c 92 10 80       	push   $0x8010927c
80105977:	e8 64 ae ff ff       	call   801007e0 <cprintf>
  return 0;
8010597c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010597f:	31 c0                	xor    %eax,%eax
80105981:	5b                   	pop    %ebx
80105982:	5e                   	pop    %esi
80105983:	5f                   	pop    %edi
80105984:	5d                   	pop    %ebp
80105985:	c3                   	ret    
80105986:	66 90                	xchg   %ax,%ax
80105988:	66 90                	xchg   %ax,%ax
8010598a:	66 90                	xchg   %ax,%ax
8010598c:	66 90                	xchg   %ax,%ax
8010598e:	66 90                	xchg   %ax,%ax

80105990 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
80105994:	83 ec 0c             	sub    $0xc,%esp
80105997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010599a:	68 c0 92 10 80       	push   $0x801092c0
8010599f:	8d 43 04             	lea    0x4(%ebx),%eax
801059a2:	50                   	push   %eax
801059a3:	e8 18 01 00 00       	call   80105ac0 <initlock>
  lk->name = name;
801059a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801059ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801059b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801059b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801059bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801059be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059c1:	c9                   	leave  
801059c2:	c3                   	ret    
801059c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	56                   	push   %esi
801059d4:	53                   	push   %ebx
801059d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801059d8:	8d 73 04             	lea    0x4(%ebx),%esi
801059db:	83 ec 0c             	sub    $0xc,%esp
801059de:	56                   	push   %esi
801059df:	e8 ac 02 00 00       	call   80105c90 <acquire>
  while (lk->locked) {
801059e4:	8b 13                	mov    (%ebx),%edx
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 d2                	test   %edx,%edx
801059eb:	74 16                	je     80105a03 <acquiresleep+0x33>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801059f0:	83 ec 08             	sub    $0x8,%esp
801059f3:	56                   	push   %esi
801059f4:	53                   	push   %ebx
801059f5:	e8 36 f9 ff ff       	call   80105330 <sleep>
  while (lk->locked) {
801059fa:	8b 03                	mov    (%ebx),%eax
801059fc:	83 c4 10             	add    $0x10,%esp
801059ff:	85 c0                	test   %eax,%eax
80105a01:	75 ed                	jne    801059f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105a03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105a09:	e8 52 f2 ff ff       	call   80104c60 <myproc>
80105a0e:	8b 40 10             	mov    0x10(%eax),%eax
80105a11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105a14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a1a:	5b                   	pop    %ebx
80105a1b:	5e                   	pop    %esi
80105a1c:	5d                   	pop    %ebp
  release(&lk->lk);
80105a1d:	e9 0e 02 00 00       	jmp    80105c30 <release>
80105a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	56                   	push   %esi
80105a34:	53                   	push   %ebx
80105a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105a38:	8d 73 04             	lea    0x4(%ebx),%esi
80105a3b:	83 ec 0c             	sub    $0xc,%esp
80105a3e:	56                   	push   %esi
80105a3f:	e8 4c 02 00 00       	call   80105c90 <acquire>
  lk->locked = 0;
80105a44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105a4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105a51:	89 1c 24             	mov    %ebx,(%esp)
80105a54:	e8 97 f9 ff ff       	call   801053f0 <wakeup>
  release(&lk->lk);
80105a59:	89 75 08             	mov    %esi,0x8(%ebp)
80105a5c:	83 c4 10             	add    $0x10,%esp
}
80105a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a62:	5b                   	pop    %ebx
80105a63:	5e                   	pop    %esi
80105a64:	5d                   	pop    %ebp
  release(&lk->lk);
80105a65:	e9 c6 01 00 00       	jmp    80105c30 <release>
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	57                   	push   %edi
80105a74:	31 ff                	xor    %edi,%edi
80105a76:	56                   	push   %esi
80105a77:	53                   	push   %ebx
80105a78:	83 ec 18             	sub    $0x18,%esp
80105a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105a7e:	8d 73 04             	lea    0x4(%ebx),%esi
80105a81:	56                   	push   %esi
80105a82:	e8 09 02 00 00       	call   80105c90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105a87:	8b 03                	mov    (%ebx),%eax
80105a89:	83 c4 10             	add    $0x10,%esp
80105a8c:	85 c0                	test   %eax,%eax
80105a8e:	75 18                	jne    80105aa8 <holdingsleep+0x38>
  release(&lk->lk);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	56                   	push   %esi
80105a94:	e8 97 01 00 00       	call   80105c30 <release>
  return r;
}
80105a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a9c:	89 f8                	mov    %edi,%eax
80105a9e:	5b                   	pop    %ebx
80105a9f:	5e                   	pop    %esi
80105aa0:	5f                   	pop    %edi
80105aa1:	5d                   	pop    %ebp
80105aa2:	c3                   	ret    
80105aa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aa7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105aa8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105aab:	e8 b0 f1 ff ff       	call   80104c60 <myproc>
80105ab0:	39 58 10             	cmp    %ebx,0x10(%eax)
80105ab3:	0f 94 c0             	sete   %al
80105ab6:	0f b6 c0             	movzbl %al,%eax
80105ab9:	89 c7                	mov    %eax,%edi
80105abb:	eb d3                	jmp    80105a90 <holdingsleep+0x20>
80105abd:	66 90                	xchg   %ax,%ax
80105abf:	90                   	nop

80105ac0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105acf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105ad2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105ad9:	5d                   	pop    %ebp
80105ada:	c3                   	ret    
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop

80105ae0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105ae0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105ae1:	31 d2                	xor    %edx,%edx
{
80105ae3:	89 e5                	mov    %esp,%ebp
80105ae5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105ae6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105aec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105aef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105af0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105af6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105afc:	77 1a                	ja     80105b18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105afe:	8b 58 04             	mov    0x4(%eax),%ebx
80105b01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105b04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105b07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105b09:	83 fa 0a             	cmp    $0xa,%edx
80105b0c:	75 e2                	jne    80105af0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b11:	c9                   	leave  
80105b12:	c3                   	ret    
80105b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b17:	90                   	nop
  for(; i < 10; i++)
80105b18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105b1b:	8d 51 28             	lea    0x28(%ecx),%edx
80105b1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105b26:	83 c0 04             	add    $0x4,%eax
80105b29:	39 d0                	cmp    %edx,%eax
80105b2b:	75 f3                	jne    80105b20 <getcallerpcs+0x40>
}
80105b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b30:	c9                   	leave  
80105b31:	c3                   	ret    
80105b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
80105b44:	83 ec 04             	sub    $0x4,%esp
80105b47:	9c                   	pushf  
80105b48:	5b                   	pop    %ebx
  asm volatile("cli");
80105b49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80105b4a:	e8 91 f0 ff ff       	call   80104be0 <mycpu>
80105b4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105b55:	85 c0                	test   %eax,%eax
80105b57:	74 17                	je     80105b70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105b59:	e8 82 f0 ff ff       	call   80104be0 <mycpu>
80105b5e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b68:	c9                   	leave  
80105b69:	c3                   	ret    
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105b70:	e8 6b f0 ff ff       	call   80104be0 <mycpu>
80105b75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80105b7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105b81:	eb d6                	jmp    80105b59 <pushcli+0x19>
80105b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <popcli>:

void
popcli(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105b96:	9c                   	pushf  
80105b97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105b98:	f6 c4 02             	test   $0x2,%ah
80105b9b:	75 35                	jne    80105bd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105b9d:	e8 3e f0 ff ff       	call   80104be0 <mycpu>
80105ba2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105ba9:	78 34                	js     80105bdf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105bab:	e8 30 f0 ff ff       	call   80104be0 <mycpu>
80105bb0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105bb6:	85 d2                	test   %edx,%edx
80105bb8:	74 06                	je     80105bc0 <popcli+0x30>
    sti();
}
80105bba:	c9                   	leave  
80105bbb:	c3                   	ret    
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105bc0:	e8 1b f0 ff ff       	call   80104be0 <mycpu>
80105bc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105bcb:	85 c0                	test   %eax,%eax
80105bcd:	74 eb                	je     80105bba <popcli+0x2a>
  asm volatile("sti");
80105bcf:	fb                   	sti    
}
80105bd0:	c9                   	leave  
80105bd1:	c3                   	ret    
    panic("popcli - interruptible");
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	68 cb 92 10 80       	push   $0x801092cb
80105bda:	e8 81 a8 ff ff       	call   80100460 <panic>
    panic("popcli");
80105bdf:	83 ec 0c             	sub    $0xc,%esp
80105be2:	68 e2 92 10 80       	push   $0x801092e2
80105be7:	e8 74 a8 ff ff       	call   80100460 <panic>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <holding>:
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	56                   	push   %esi
80105bf4:	53                   	push   %ebx
80105bf5:	8b 75 08             	mov    0x8(%ebp),%esi
80105bf8:	31 db                	xor    %ebx,%ebx
  pushcli();
80105bfa:	e8 41 ff ff ff       	call   80105b40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105bff:	8b 06                	mov    (%esi),%eax
80105c01:	85 c0                	test   %eax,%eax
80105c03:	75 0b                	jne    80105c10 <holding+0x20>
  popcli();
80105c05:	e8 86 ff ff ff       	call   80105b90 <popcli>
}
80105c0a:	89 d8                	mov    %ebx,%eax
80105c0c:	5b                   	pop    %ebx
80105c0d:	5e                   	pop    %esi
80105c0e:	5d                   	pop    %ebp
80105c0f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105c10:	8b 5e 08             	mov    0x8(%esi),%ebx
80105c13:	e8 c8 ef ff ff       	call   80104be0 <mycpu>
80105c18:	39 c3                	cmp    %eax,%ebx
80105c1a:	0f 94 c3             	sete   %bl
  popcli();
80105c1d:	e8 6e ff ff ff       	call   80105b90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105c22:	0f b6 db             	movzbl %bl,%ebx
}
80105c25:	89 d8                	mov    %ebx,%eax
80105c27:	5b                   	pop    %ebx
80105c28:	5e                   	pop    %esi
80105c29:	5d                   	pop    %ebp
80105c2a:	c3                   	ret    
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop

80105c30 <release>:
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	56                   	push   %esi
80105c34:	53                   	push   %ebx
80105c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105c38:	e8 03 ff ff ff       	call   80105b40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105c3d:	8b 03                	mov    (%ebx),%eax
80105c3f:	85 c0                	test   %eax,%eax
80105c41:	75 15                	jne    80105c58 <release+0x28>
  popcli();
80105c43:	e8 48 ff ff ff       	call   80105b90 <popcli>
    panic("release");
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	68 e9 92 10 80       	push   $0x801092e9
80105c50:	e8 0b a8 ff ff       	call   80100460 <panic>
80105c55:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105c58:	8b 73 08             	mov    0x8(%ebx),%esi
80105c5b:	e8 80 ef ff ff       	call   80104be0 <mycpu>
80105c60:	39 c6                	cmp    %eax,%esi
80105c62:	75 df                	jne    80105c43 <release+0x13>
  popcli();
80105c64:	e8 27 ff ff ff       	call   80105b90 <popcli>
  lk->pcs[0] = 0;
80105c69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105c70:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105c77:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105c7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c85:	5b                   	pop    %ebx
80105c86:	5e                   	pop    %esi
80105c87:	5d                   	pop    %ebp
  popcli();
80105c88:	e9 03 ff ff ff       	jmp    80105b90 <popcli>
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi

80105c90 <acquire>:
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
80105c94:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105c97:	e8 a4 fe ff ff       	call   80105b40 <pushcli>
  if(holding(lk))
80105c9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105c9f:	e8 9c fe ff ff       	call   80105b40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105ca4:	8b 03                	mov    (%ebx),%eax
80105ca6:	85 c0                	test   %eax,%eax
80105ca8:	75 7e                	jne    80105d28 <acquire+0x98>
  popcli();
80105caa:	e8 e1 fe ff ff       	call   80105b90 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80105caf:	b9 01 00 00 00       	mov    $0x1,%ecx
80105cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105cb8:	8b 55 08             	mov    0x8(%ebp),%edx
80105cbb:	89 c8                	mov    %ecx,%eax
80105cbd:	f0 87 02             	lock xchg %eax,(%edx)
80105cc0:	85 c0                	test   %eax,%eax
80105cc2:	75 f4                	jne    80105cb8 <acquire+0x28>
  __sync_synchronize();
80105cc4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105ccc:	e8 0f ef ff ff       	call   80104be0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105cd4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105cd6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105cd9:	31 c0                	xor    %eax,%eax
80105cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105ce0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105ce6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105cec:	77 1a                	ja     80105d08 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80105cee:	8b 5a 04             	mov    0x4(%edx),%ebx
80105cf1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105cf5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105cf8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105cfa:	83 f8 0a             	cmp    $0xa,%eax
80105cfd:	75 e1                	jne    80105ce0 <acquire+0x50>
}
80105cff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d02:	c9                   	leave  
80105d03:	c3                   	ret    
80105d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105d08:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80105d0c:	8d 51 34             	lea    0x34(%ecx),%edx
80105d0f:	90                   	nop
    pcs[i] = 0;
80105d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105d16:	83 c0 04             	add    $0x4,%eax
80105d19:	39 c2                	cmp    %eax,%edx
80105d1b:	75 f3                	jne    80105d10 <acquire+0x80>
}
80105d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d20:	c9                   	leave  
80105d21:	c3                   	ret    
80105d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105d28:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105d2b:	e8 b0 ee ff ff       	call   80104be0 <mycpu>
80105d30:	39 c3                	cmp    %eax,%ebx
80105d32:	0f 85 72 ff ff ff    	jne    80105caa <acquire+0x1a>
  popcli();
80105d38:	e8 53 fe ff ff       	call   80105b90 <popcli>
    panic("acquire");
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	68 f1 92 10 80       	push   $0x801092f1
80105d45:	e8 16 a7 ff ff       	call   80100460 <panic>
80105d4a:	66 90                	xchg   %ax,%ax
80105d4c:	66 90                	xchg   %ax,%ax
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	57                   	push   %edi
80105d54:	8b 55 08             	mov    0x8(%ebp),%edx
80105d57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105d5a:	53                   	push   %ebx
80105d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105d5e:	89 d7                	mov    %edx,%edi
80105d60:	09 cf                	or     %ecx,%edi
80105d62:	83 e7 03             	and    $0x3,%edi
80105d65:	75 29                	jne    80105d90 <memset+0x40>
    c &= 0xFF;
80105d67:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105d6a:	c1 e0 18             	shl    $0x18,%eax
80105d6d:	89 fb                	mov    %edi,%ebx
80105d6f:	c1 e9 02             	shr    $0x2,%ecx
80105d72:	c1 e3 10             	shl    $0x10,%ebx
80105d75:	09 d8                	or     %ebx,%eax
80105d77:	09 f8                	or     %edi,%eax
80105d79:	c1 e7 08             	shl    $0x8,%edi
80105d7c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105d7e:	89 d7                	mov    %edx,%edi
80105d80:	fc                   	cld    
80105d81:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105d83:	5b                   	pop    %ebx
80105d84:	89 d0                	mov    %edx,%eax
80105d86:	5f                   	pop    %edi
80105d87:	5d                   	pop    %ebp
80105d88:	c3                   	ret    
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105d90:	89 d7                	mov    %edx,%edi
80105d92:	fc                   	cld    
80105d93:	f3 aa                	rep stos %al,%es:(%edi)
80105d95:	5b                   	pop    %ebx
80105d96:	89 d0                	mov    %edx,%eax
80105d98:	5f                   	pop    %edi
80105d99:	5d                   	pop    %ebp
80105d9a:	c3                   	ret    
80105d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop

80105da0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	56                   	push   %esi
80105da4:	8b 75 10             	mov    0x10(%ebp),%esi
80105da7:	8b 55 08             	mov    0x8(%ebp),%edx
80105daa:	53                   	push   %ebx
80105dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105dae:	85 f6                	test   %esi,%esi
80105db0:	74 2e                	je     80105de0 <memcmp+0x40>
80105db2:	01 c6                	add    %eax,%esi
80105db4:	eb 14                	jmp    80105dca <memcmp+0x2a>
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105dc0:	83 c0 01             	add    $0x1,%eax
80105dc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105dc6:	39 f0                	cmp    %esi,%eax
80105dc8:	74 16                	je     80105de0 <memcmp+0x40>
    if(*s1 != *s2)
80105dca:	0f b6 0a             	movzbl (%edx),%ecx
80105dcd:	0f b6 18             	movzbl (%eax),%ebx
80105dd0:	38 d9                	cmp    %bl,%cl
80105dd2:	74 ec                	je     80105dc0 <memcmp+0x20>
      return *s1 - *s2;
80105dd4:	0f b6 c1             	movzbl %cl,%eax
80105dd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105dd9:	5b                   	pop    %ebx
80105dda:	5e                   	pop    %esi
80105ddb:	5d                   	pop    %ebp
80105ddc:	c3                   	ret    
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
80105de0:	5b                   	pop    %ebx
  return 0;
80105de1:	31 c0                	xor    %eax,%eax
}
80105de3:	5e                   	pop    %esi
80105de4:	5d                   	pop    %ebp
80105de5:	c3                   	ret    
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi

80105df0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	8b 55 08             	mov    0x8(%ebp),%edx
80105df7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105dfa:	56                   	push   %esi
80105dfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105dfe:	39 d6                	cmp    %edx,%esi
80105e00:	73 26                	jae    80105e28 <memmove+0x38>
80105e02:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105e05:	39 fa                	cmp    %edi,%edx
80105e07:	73 1f                	jae    80105e28 <memmove+0x38>
80105e09:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105e0c:	85 c9                	test   %ecx,%ecx
80105e0e:	74 0c                	je     80105e1c <memmove+0x2c>
      *--d = *--s;
80105e10:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105e14:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105e17:	83 e8 01             	sub    $0x1,%eax
80105e1a:	73 f4                	jae    80105e10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105e1c:	5e                   	pop    %esi
80105e1d:	89 d0                	mov    %edx,%eax
80105e1f:	5f                   	pop    %edi
80105e20:	5d                   	pop    %ebp
80105e21:	c3                   	ret    
80105e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105e28:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105e2b:	89 d7                	mov    %edx,%edi
80105e2d:	85 c9                	test   %ecx,%ecx
80105e2f:	74 eb                	je     80105e1c <memmove+0x2c>
80105e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105e38:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105e39:	39 c6                	cmp    %eax,%esi
80105e3b:	75 fb                	jne    80105e38 <memmove+0x48>
}
80105e3d:	5e                   	pop    %esi
80105e3e:	89 d0                	mov    %edx,%eax
80105e40:	5f                   	pop    %edi
80105e41:	5d                   	pop    %ebp
80105e42:	c3                   	ret    
80105e43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105e50:	eb 9e                	jmp    80105df0 <memmove>
80105e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	56                   	push   %esi
80105e64:	8b 75 10             	mov    0x10(%ebp),%esi
80105e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105e6a:	53                   	push   %ebx
80105e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80105e6e:	85 f6                	test   %esi,%esi
80105e70:	74 2e                	je     80105ea0 <strncmp+0x40>
80105e72:	01 d6                	add    %edx,%esi
80105e74:	eb 18                	jmp    80105e8e <strncmp+0x2e>
80105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
80105e80:	38 d8                	cmp    %bl,%al
80105e82:	75 14                	jne    80105e98 <strncmp+0x38>
    n--, p++, q++;
80105e84:	83 c2 01             	add    $0x1,%edx
80105e87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105e8a:	39 f2                	cmp    %esi,%edx
80105e8c:	74 12                	je     80105ea0 <strncmp+0x40>
80105e8e:	0f b6 01             	movzbl (%ecx),%eax
80105e91:	0f b6 1a             	movzbl (%edx),%ebx
80105e94:	84 c0                	test   %al,%al
80105e96:	75 e8                	jne    80105e80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105e98:	29 d8                	sub    %ebx,%eax
}
80105e9a:	5b                   	pop    %ebx
80105e9b:	5e                   	pop    %esi
80105e9c:	5d                   	pop    %ebp
80105e9d:	c3                   	ret    
80105e9e:	66 90                	xchg   %ax,%ax
80105ea0:	5b                   	pop    %ebx
    return 0;
80105ea1:	31 c0                	xor    %eax,%eax
}
80105ea3:	5e                   	pop    %esi
80105ea4:	5d                   	pop    %ebp
80105ea5:	c3                   	ret    
80105ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ead:	8d 76 00             	lea    0x0(%esi),%esi

80105eb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	57                   	push   %edi
80105eb4:	56                   	push   %esi
80105eb5:	8b 75 08             	mov    0x8(%ebp),%esi
80105eb8:	53                   	push   %ebx
80105eb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105ebc:	89 f0                	mov    %esi,%eax
80105ebe:	eb 15                	jmp    80105ed5 <strncpy+0x25>
80105ec0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105ec4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105ec7:	83 c0 01             	add    $0x1,%eax
80105eca:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105ece:	88 50 ff             	mov    %dl,-0x1(%eax)
80105ed1:	84 d2                	test   %dl,%dl
80105ed3:	74 09                	je     80105ede <strncpy+0x2e>
80105ed5:	89 cb                	mov    %ecx,%ebx
80105ed7:	83 e9 01             	sub    $0x1,%ecx
80105eda:	85 db                	test   %ebx,%ebx
80105edc:	7f e2                	jg     80105ec0 <strncpy+0x10>
    ;
  while(n-- > 0)
80105ede:	89 c2                	mov    %eax,%edx
80105ee0:	85 c9                	test   %ecx,%ecx
80105ee2:	7e 17                	jle    80105efb <strncpy+0x4b>
80105ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105ee8:	83 c2 01             	add    $0x1,%edx
80105eeb:	89 c1                	mov    %eax,%ecx
80105eed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105ef1:	29 d1                	sub    %edx,%ecx
80105ef3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105ef7:	85 c9                	test   %ecx,%ecx
80105ef9:	7f ed                	jg     80105ee8 <strncpy+0x38>
  return os;
}
80105efb:	5b                   	pop    %ebx
80105efc:	89 f0                	mov    %esi,%eax
80105efe:	5e                   	pop    %esi
80105eff:	5f                   	pop    %edi
80105f00:	5d                   	pop    %ebp
80105f01:	c3                   	ret    
80105f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	56                   	push   %esi
80105f14:	8b 55 10             	mov    0x10(%ebp),%edx
80105f17:	8b 75 08             	mov    0x8(%ebp),%esi
80105f1a:	53                   	push   %ebx
80105f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105f1e:	85 d2                	test   %edx,%edx
80105f20:	7e 25                	jle    80105f47 <safestrcpy+0x37>
80105f22:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105f26:	89 f2                	mov    %esi,%edx
80105f28:	eb 16                	jmp    80105f40 <safestrcpy+0x30>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105f30:	0f b6 08             	movzbl (%eax),%ecx
80105f33:	83 c0 01             	add    $0x1,%eax
80105f36:	83 c2 01             	add    $0x1,%edx
80105f39:	88 4a ff             	mov    %cl,-0x1(%edx)
80105f3c:	84 c9                	test   %cl,%cl
80105f3e:	74 04                	je     80105f44 <safestrcpy+0x34>
80105f40:	39 d8                	cmp    %ebx,%eax
80105f42:	75 ec                	jne    80105f30 <safestrcpy+0x20>
    ;
  *s = 0;
80105f44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105f47:	89 f0                	mov    %esi,%eax
80105f49:	5b                   	pop    %ebx
80105f4a:	5e                   	pop    %esi
80105f4b:	5d                   	pop    %ebp
80105f4c:	c3                   	ret    
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi

80105f50 <strlen>:

int
strlen(const char *s)
{
80105f50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105f51:	31 c0                	xor    %eax,%eax
{
80105f53:	89 e5                	mov    %esp,%ebp
80105f55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105f58:	80 3a 00             	cmpb   $0x0,(%edx)
80105f5b:	74 0c                	je     80105f69 <strlen+0x19>
80105f5d:	8d 76 00             	lea    0x0(%esi),%esi
80105f60:	83 c0 01             	add    $0x1,%eax
80105f63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105f67:	75 f7                	jne    80105f60 <strlen+0x10>
    ;
  return n;
}
80105f69:	5d                   	pop    %ebp
80105f6a:	c3                   	ret    

80105f6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105f6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105f6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105f73:	55                   	push   %ebp
  pushl %ebx
80105f74:	53                   	push   %ebx
  pushl %esi
80105f75:	56                   	push   %esi
  pushl %edi
80105f76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105f77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105f79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105f7b:	5f                   	pop    %edi
  popl %esi
80105f7c:	5e                   	pop    %esi
  popl %ebx
80105f7d:	5b                   	pop    %ebx
  popl %ebp
80105f7e:	5d                   	pop    %ebp
  ret
80105f7f:	c3                   	ret    

80105f80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	53                   	push   %ebx
80105f84:	83 ec 04             	sub    $0x4,%esp
80105f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105f8a:	e8 d1 ec ff ff       	call   80104c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f8f:	8b 00                	mov    (%eax),%eax
80105f91:	39 d8                	cmp    %ebx,%eax
80105f93:	76 1b                	jbe    80105fb0 <fetchint+0x30>
80105f95:	8d 53 04             	lea    0x4(%ebx),%edx
80105f98:	39 d0                	cmp    %edx,%eax
80105f9a:	72 14                	jb     80105fb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f9f:	8b 13                	mov    (%ebx),%edx
80105fa1:	89 10                	mov    %edx,(%eax)
  return 0;
80105fa3:	31 c0                	xor    %eax,%eax
}
80105fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fa8:	c9                   	leave  
80105fa9:	c3                   	ret    
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb5:	eb ee                	jmp    80105fa5 <fetchint+0x25>
80105fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	53                   	push   %ebx
80105fc4:	83 ec 04             	sub    $0x4,%esp
80105fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105fca:	e8 91 ec ff ff       	call   80104c60 <myproc>

  if(addr >= curproc->sz)
80105fcf:	39 18                	cmp    %ebx,(%eax)
80105fd1:	76 2d                	jbe    80106000 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fd6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105fd8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105fda:	39 d3                	cmp    %edx,%ebx
80105fdc:	73 22                	jae    80106000 <fetchstr+0x40>
80105fde:	89 d8                	mov    %ebx,%eax
80105fe0:	eb 0d                	jmp    80105fef <fetchstr+0x2f>
80105fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fe8:	83 c0 01             	add    $0x1,%eax
80105feb:	39 c2                	cmp    %eax,%edx
80105fed:	76 11                	jbe    80106000 <fetchstr+0x40>
    if(*s == 0)
80105fef:	80 38 00             	cmpb   $0x0,(%eax)
80105ff2:	75 f4                	jne    80105fe8 <fetchstr+0x28>
      return s - *pp;
80105ff4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105ff6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff9:	c9                   	leave  
80105ffa:	c3                   	ret    
80105ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop
80106000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80106003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106008:	c9                   	leave  
80106009:	c3                   	ret    
8010600a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106010 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	56                   	push   %esi
80106014:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106015:	e8 46 ec ff ff       	call   80104c60 <myproc>
8010601a:	8b 55 08             	mov    0x8(%ebp),%edx
8010601d:	8b 40 18             	mov    0x18(%eax),%eax
80106020:	8b 40 44             	mov    0x44(%eax),%eax
80106023:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106026:	e8 35 ec ff ff       	call   80104c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010602b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010602e:	8b 00                	mov    (%eax),%eax
80106030:	39 c6                	cmp    %eax,%esi
80106032:	73 1c                	jae    80106050 <argint+0x40>
80106034:	8d 53 08             	lea    0x8(%ebx),%edx
80106037:	39 d0                	cmp    %edx,%eax
80106039:	72 15                	jb     80106050 <argint+0x40>
  *ip = *(int*)(addr);
8010603b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010603e:	8b 53 04             	mov    0x4(%ebx),%edx
80106041:	89 10                	mov    %edx,(%eax)
  return 0;
80106043:	31 c0                	xor    %eax,%eax
}
80106045:	5b                   	pop    %ebx
80106046:	5e                   	pop    %esi
80106047:	5d                   	pop    %ebp
80106048:	c3                   	ret    
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106055:	eb ee                	jmp    80106045 <argint+0x35>
80106057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605e:	66 90                	xchg   %ax,%ax

80106060 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	57                   	push   %edi
80106064:	56                   	push   %esi
80106065:	53                   	push   %ebx
80106066:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80106069:	e8 f2 eb ff ff       	call   80104c60 <myproc>
8010606e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106070:	e8 eb eb ff ff       	call   80104c60 <myproc>
80106075:	8b 55 08             	mov    0x8(%ebp),%edx
80106078:	8b 40 18             	mov    0x18(%eax),%eax
8010607b:	8b 40 44             	mov    0x44(%eax),%eax
8010607e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106081:	e8 da eb ff ff       	call   80104c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106086:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106089:	8b 00                	mov    (%eax),%eax
8010608b:	39 c7                	cmp    %eax,%edi
8010608d:	73 31                	jae    801060c0 <argptr+0x60>
8010608f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106092:	39 c8                	cmp    %ecx,%eax
80106094:	72 2a                	jb     801060c0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106096:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106099:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010609c:	85 d2                	test   %edx,%edx
8010609e:	78 20                	js     801060c0 <argptr+0x60>
801060a0:	8b 16                	mov    (%esi),%edx
801060a2:	39 c2                	cmp    %eax,%edx
801060a4:	76 1a                	jbe    801060c0 <argptr+0x60>
801060a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801060a9:	01 c3                	add    %eax,%ebx
801060ab:	39 da                	cmp    %ebx,%edx
801060ad:	72 11                	jb     801060c0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801060af:	8b 55 0c             	mov    0xc(%ebp),%edx
801060b2:	89 02                	mov    %eax,(%edx)
  return 0;
801060b4:	31 c0                	xor    %eax,%eax
}
801060b6:	83 c4 0c             	add    $0xc,%esp
801060b9:	5b                   	pop    %ebx
801060ba:	5e                   	pop    %esi
801060bb:	5f                   	pop    %edi
801060bc:	5d                   	pop    %ebp
801060bd:	c3                   	ret    
801060be:	66 90                	xchg   %ax,%ax
    return -1;
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c5:	eb ef                	jmp    801060b6 <argptr+0x56>
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	56                   	push   %esi
801060d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801060d5:	e8 86 eb ff ff       	call   80104c60 <myproc>
801060da:	8b 55 08             	mov    0x8(%ebp),%edx
801060dd:	8b 40 18             	mov    0x18(%eax),%eax
801060e0:	8b 40 44             	mov    0x44(%eax),%eax
801060e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801060e6:	e8 75 eb ff ff       	call   80104c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801060eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801060ee:	8b 00                	mov    (%eax),%eax
801060f0:	39 c6                	cmp    %eax,%esi
801060f2:	73 44                	jae    80106138 <argstr+0x68>
801060f4:	8d 53 08             	lea    0x8(%ebx),%edx
801060f7:	39 d0                	cmp    %edx,%eax
801060f9:	72 3d                	jb     80106138 <argstr+0x68>
  *ip = *(int*)(addr);
801060fb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801060fe:	e8 5d eb ff ff       	call   80104c60 <myproc>
  if(addr >= curproc->sz)
80106103:	3b 18                	cmp    (%eax),%ebx
80106105:	73 31                	jae    80106138 <argstr+0x68>
  *pp = (char*)addr;
80106107:	8b 55 0c             	mov    0xc(%ebp),%edx
8010610a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010610c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010610e:	39 d3                	cmp    %edx,%ebx
80106110:	73 26                	jae    80106138 <argstr+0x68>
80106112:	89 d8                	mov    %ebx,%eax
80106114:	eb 11                	jmp    80106127 <argstr+0x57>
80106116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611d:	8d 76 00             	lea    0x0(%esi),%esi
80106120:	83 c0 01             	add    $0x1,%eax
80106123:	39 c2                	cmp    %eax,%edx
80106125:	76 11                	jbe    80106138 <argstr+0x68>
    if(*s == 0)
80106127:	80 38 00             	cmpb   $0x0,(%eax)
8010612a:	75 f4                	jne    80106120 <argstr+0x50>
      return s - *pp;
8010612c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010612e:	5b                   	pop    %ebx
8010612f:	5e                   	pop    %esi
80106130:	5d                   	pop    %ebp
80106131:	c3                   	ret    
80106132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106138:	5b                   	pop    %ebx
    return -1;
80106139:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010613e:	5e                   	pop    %esi
8010613f:	5d                   	pop    %ebp
80106140:	c3                   	ret    
80106141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614f:	90                   	nop

80106150 <syscall>:
[SYS_create_palindrom] sys_create_palindrom,
};

void
syscall(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	56                   	push   %esi
80106154:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80106155:	e8 06 eb ff ff       	call   80104c60 <myproc>
8010615a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010615c:	8b 40 18             	mov    0x18(%eax),%eax
8010615f:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106162:	8d 46 ff             	lea    -0x1(%esi),%eax
80106165:	83 f8 1b             	cmp    $0x1b,%eax
80106168:	77 26                	ja     80106190 <syscall+0x40>
8010616a:	8b 04 b5 20 93 10 80 	mov    -0x7fef6ce0(,%esi,4),%eax
80106171:	85 c0                	test   %eax,%eax
80106173:	74 1b                	je     80106190 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80106175:	ff d0                	call   *%eax
80106177:	89 c2                	mov    %eax,%edx
80106179:	8b 43 18             	mov    0x18(%ebx),%eax
8010617c:	89 50 1c             	mov    %edx,0x1c(%eax)
    cprintf("%d\n" , num);
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010617f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106182:	5b                   	pop    %ebx
80106183:	5e                   	pop    %esi
80106184:	5d                   	pop    %ebp
80106185:	c3                   	ret    
80106186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d\n" , num);
80106190:	83 ec 08             	sub    $0x8,%esp
80106193:	56                   	push   %esi
80106194:	68 b4 90 10 80       	push   $0x801090b4
80106199:	e8 42 a6 ff ff       	call   801007e0 <cprintf>
            curproc->pid, curproc->name, num);
8010619e:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801061a1:	56                   	push   %esi
801061a2:	50                   	push   %eax
801061a3:	ff 73 10             	push   0x10(%ebx)
801061a6:	68 f9 92 10 80       	push   $0x801092f9
801061ab:	e8 30 a6 ff ff       	call   801007e0 <cprintf>
    curproc->tf->eax = -1;
801061b0:	8b 43 18             	mov    0x18(%ebx),%eax
801061b3:	83 c4 20             	add    $0x20,%esp
801061b6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801061bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061c0:	5b                   	pop    %ebx
801061c1:	5e                   	pop    %esi
801061c2:	5d                   	pop    %ebp
801061c3:	c3                   	ret    
801061c4:	66 90                	xchg   %ax,%ax
801061c6:	66 90                	xchg   %ax,%ax
801061c8:	66 90                	xchg   %ax,%ax
801061ca:	66 90                	xchg   %ax,%ax
801061cc:	66 90                	xchg   %ax,%ax
801061ce:	66 90                	xchg   %ax,%ax

801061d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	57                   	push   %edi
801061d4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801061d5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801061d8:	53                   	push   %ebx
801061d9:	83 ec 34             	sub    $0x34,%esp
801061dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801061df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801061e2:	57                   	push   %edi
801061e3:	50                   	push   %eax
{
801061e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801061e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801061ea:	e8 b1 d1 ff ff       	call   801033a0 <nameiparent>
801061ef:	83 c4 10             	add    $0x10,%esp
801061f2:	85 c0                	test   %eax,%eax
801061f4:	0f 84 46 01 00 00    	je     80106340 <create+0x170>
    return 0;
  ilock(dp);
801061fa:	83 ec 0c             	sub    $0xc,%esp
801061fd:	89 c3                	mov    %eax,%ebx
801061ff:	50                   	push   %eax
80106200:	e8 5b c8 ff ff       	call   80102a60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80106205:	83 c4 0c             	add    $0xc,%esp
80106208:	6a 00                	push   $0x0
8010620a:	57                   	push   %edi
8010620b:	53                   	push   %ebx
8010620c:	e8 af cd ff ff       	call   80102fc0 <dirlookup>
80106211:	83 c4 10             	add    $0x10,%esp
80106214:	89 c6                	mov    %eax,%esi
80106216:	85 c0                	test   %eax,%eax
80106218:	74 56                	je     80106270 <create+0xa0>
    iunlockput(dp);
8010621a:	83 ec 0c             	sub    $0xc,%esp
8010621d:	53                   	push   %ebx
8010621e:	e8 cd ca ff ff       	call   80102cf0 <iunlockput>
    ilock(ip);
80106223:	89 34 24             	mov    %esi,(%esp)
80106226:	e8 35 c8 ff ff       	call   80102a60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010622b:	83 c4 10             	add    $0x10,%esp
8010622e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106233:	75 1b                	jne    80106250 <create+0x80>
80106235:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010623a:	75 14                	jne    80106250 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010623c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010623f:	89 f0                	mov    %esi,%eax
80106241:	5b                   	pop    %ebx
80106242:	5e                   	pop    %esi
80106243:	5f                   	pop    %edi
80106244:	5d                   	pop    %ebp
80106245:	c3                   	ret    
80106246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	56                   	push   %esi
    return 0;
80106254:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80106256:	e8 95 ca ff ff       	call   80102cf0 <iunlockput>
    return 0;
8010625b:	83 c4 10             	add    $0x10,%esp
}
8010625e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106261:	89 f0                	mov    %esi,%eax
80106263:	5b                   	pop    %ebx
80106264:	5e                   	pop    %esi
80106265:	5f                   	pop    %edi
80106266:	5d                   	pop    %ebp
80106267:	c3                   	ret    
80106268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80106270:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106274:	83 ec 08             	sub    $0x8,%esp
80106277:	50                   	push   %eax
80106278:	ff 33                	push   (%ebx)
8010627a:	e8 71 c6 ff ff       	call   801028f0 <ialloc>
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	89 c6                	mov    %eax,%esi
80106284:	85 c0                	test   %eax,%eax
80106286:	0f 84 cd 00 00 00    	je     80106359 <create+0x189>
  ilock(ip);
8010628c:	83 ec 0c             	sub    $0xc,%esp
8010628f:	50                   	push   %eax
80106290:	e8 cb c7 ff ff       	call   80102a60 <ilock>
  ip->major = major;
80106295:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106299:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010629d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801062a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801062a5:	b8 01 00 00 00       	mov    $0x1,%eax
801062aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801062ae:	89 34 24             	mov    %esi,(%esp)
801062b1:	e8 fa c6 ff ff       	call   801029b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801062b6:	83 c4 10             	add    $0x10,%esp
801062b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801062be:	74 30                	je     801062f0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801062c0:	83 ec 04             	sub    $0x4,%esp
801062c3:	ff 76 04             	push   0x4(%esi)
801062c6:	57                   	push   %edi
801062c7:	53                   	push   %ebx
801062c8:	e8 f3 cf ff ff       	call   801032c0 <dirlink>
801062cd:	83 c4 10             	add    $0x10,%esp
801062d0:	85 c0                	test   %eax,%eax
801062d2:	78 78                	js     8010634c <create+0x17c>
  iunlockput(dp);
801062d4:	83 ec 0c             	sub    $0xc,%esp
801062d7:	53                   	push   %ebx
801062d8:	e8 13 ca ff ff       	call   80102cf0 <iunlockput>
  return ip;
801062dd:	83 c4 10             	add    $0x10,%esp
}
801062e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e3:	89 f0                	mov    %esi,%eax
801062e5:	5b                   	pop    %ebx
801062e6:	5e                   	pop    %esi
801062e7:	5f                   	pop    %edi
801062e8:	5d                   	pop    %ebp
801062e9:	c3                   	ret    
801062ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801062f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801062f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801062f8:	53                   	push   %ebx
801062f9:	e8 b2 c6 ff ff       	call   801029b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801062fe:	83 c4 0c             	add    $0xc,%esp
80106301:	ff 76 04             	push   0x4(%esi)
80106304:	68 b0 93 10 80       	push   $0x801093b0
80106309:	56                   	push   %esi
8010630a:	e8 b1 cf ff ff       	call   801032c0 <dirlink>
8010630f:	83 c4 10             	add    $0x10,%esp
80106312:	85 c0                	test   %eax,%eax
80106314:	78 18                	js     8010632e <create+0x15e>
80106316:	83 ec 04             	sub    $0x4,%esp
80106319:	ff 73 04             	push   0x4(%ebx)
8010631c:	68 af 93 10 80       	push   $0x801093af
80106321:	56                   	push   %esi
80106322:	e8 99 cf ff ff       	call   801032c0 <dirlink>
80106327:	83 c4 10             	add    $0x10,%esp
8010632a:	85 c0                	test   %eax,%eax
8010632c:	79 92                	jns    801062c0 <create+0xf0>
      panic("create dots");
8010632e:	83 ec 0c             	sub    $0xc,%esp
80106331:	68 a3 93 10 80       	push   $0x801093a3
80106336:	e8 25 a1 ff ff       	call   80100460 <panic>
8010633b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010633f:	90                   	nop
}
80106340:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106343:	31 f6                	xor    %esi,%esi
}
80106345:	5b                   	pop    %ebx
80106346:	89 f0                	mov    %esi,%eax
80106348:	5e                   	pop    %esi
80106349:	5f                   	pop    %edi
8010634a:	5d                   	pop    %ebp
8010634b:	c3                   	ret    
    panic("create: dirlink");
8010634c:	83 ec 0c             	sub    $0xc,%esp
8010634f:	68 b2 93 10 80       	push   $0x801093b2
80106354:	e8 07 a1 ff ff       	call   80100460 <panic>
    panic("create: ialloc");
80106359:	83 ec 0c             	sub    $0xc,%esp
8010635c:	68 94 93 10 80       	push   $0x80109394
80106361:	e8 fa a0 ff ff       	call   80100460 <panic>
80106366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636d:	8d 76 00             	lea    0x0(%esi),%esi

80106370 <sys_dup>:
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	56                   	push   %esi
80106374:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106375:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106378:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010637b:	50                   	push   %eax
8010637c:	6a 00                	push   $0x0
8010637e:	e8 8d fc ff ff       	call   80106010 <argint>
80106383:	83 c4 10             	add    $0x10,%esp
80106386:	85 c0                	test   %eax,%eax
80106388:	78 36                	js     801063c0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010638a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010638e:	77 30                	ja     801063c0 <sys_dup+0x50>
80106390:	e8 cb e8 ff ff       	call   80104c60 <myproc>
80106395:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106398:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010639c:	85 f6                	test   %esi,%esi
8010639e:	74 20                	je     801063c0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801063a0:	e8 bb e8 ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801063a5:	31 db                	xor    %ebx,%ebx
801063a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801063b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801063b4:	85 d2                	test   %edx,%edx
801063b6:	74 18                	je     801063d0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801063b8:	83 c3 01             	add    $0x1,%ebx
801063bb:	83 fb 10             	cmp    $0x10,%ebx
801063be:	75 f0                	jne    801063b0 <sys_dup+0x40>
}
801063c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801063c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801063c8:	89 d8                	mov    %ebx,%eax
801063ca:	5b                   	pop    %ebx
801063cb:	5e                   	pop    %esi
801063cc:	5d                   	pop    %ebp
801063cd:	c3                   	ret    
801063ce:	66 90                	xchg   %ax,%ax
  filedup(f);
801063d0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801063d3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801063d7:	56                   	push   %esi
801063d8:	e8 a3 bd ff ff       	call   80102180 <filedup>
  return fd;
801063dd:	83 c4 10             	add    $0x10,%esp
}
801063e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063e3:	89 d8                	mov    %ebx,%eax
801063e5:	5b                   	pop    %ebx
801063e6:	5e                   	pop    %esi
801063e7:	5d                   	pop    %ebp
801063e8:	c3                   	ret    
801063e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063f0 <sys_read>:
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	56                   	push   %esi
801063f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801063f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801063f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801063fb:	53                   	push   %ebx
801063fc:	6a 00                	push   $0x0
801063fe:	e8 0d fc ff ff       	call   80106010 <argint>
80106403:	83 c4 10             	add    $0x10,%esp
80106406:	85 c0                	test   %eax,%eax
80106408:	78 5e                	js     80106468 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010640a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010640e:	77 58                	ja     80106468 <sys_read+0x78>
80106410:	e8 4b e8 ff ff       	call   80104c60 <myproc>
80106415:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106418:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010641c:	85 f6                	test   %esi,%esi
8010641e:	74 48                	je     80106468 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106420:	83 ec 08             	sub    $0x8,%esp
80106423:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106426:	50                   	push   %eax
80106427:	6a 02                	push   $0x2
80106429:	e8 e2 fb ff ff       	call   80106010 <argint>
8010642e:	83 c4 10             	add    $0x10,%esp
80106431:	85 c0                	test   %eax,%eax
80106433:	78 33                	js     80106468 <sys_read+0x78>
80106435:	83 ec 04             	sub    $0x4,%esp
80106438:	ff 75 f0             	push   -0x10(%ebp)
8010643b:	53                   	push   %ebx
8010643c:	6a 01                	push   $0x1
8010643e:	e8 1d fc ff ff       	call   80106060 <argptr>
80106443:	83 c4 10             	add    $0x10,%esp
80106446:	85 c0                	test   %eax,%eax
80106448:	78 1e                	js     80106468 <sys_read+0x78>
  return fileread(f, p, n);
8010644a:	83 ec 04             	sub    $0x4,%esp
8010644d:	ff 75 f0             	push   -0x10(%ebp)
80106450:	ff 75 f4             	push   -0xc(%ebp)
80106453:	56                   	push   %esi
80106454:	e8 a7 be ff ff       	call   80102300 <fileread>
80106459:	83 c4 10             	add    $0x10,%esp
}
8010645c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010645f:	5b                   	pop    %ebx
80106460:	5e                   	pop    %esi
80106461:	5d                   	pop    %ebp
80106462:	c3                   	ret    
80106463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106467:	90                   	nop
    return -1;
80106468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646d:	eb ed                	jmp    8010645c <sys_read+0x6c>
8010646f:	90                   	nop

80106470 <sys_write>:
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	56                   	push   %esi
80106474:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106475:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106478:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010647b:	53                   	push   %ebx
8010647c:	6a 00                	push   $0x0
8010647e:	e8 8d fb ff ff       	call   80106010 <argint>
80106483:	83 c4 10             	add    $0x10,%esp
80106486:	85 c0                	test   %eax,%eax
80106488:	78 5e                	js     801064e8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010648a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010648e:	77 58                	ja     801064e8 <sys_write+0x78>
80106490:	e8 cb e7 ff ff       	call   80104c60 <myproc>
80106495:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106498:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010649c:	85 f6                	test   %esi,%esi
8010649e:	74 48                	je     801064e8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801064a0:	83 ec 08             	sub    $0x8,%esp
801064a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064a6:	50                   	push   %eax
801064a7:	6a 02                	push   $0x2
801064a9:	e8 62 fb ff ff       	call   80106010 <argint>
801064ae:	83 c4 10             	add    $0x10,%esp
801064b1:	85 c0                	test   %eax,%eax
801064b3:	78 33                	js     801064e8 <sys_write+0x78>
801064b5:	83 ec 04             	sub    $0x4,%esp
801064b8:	ff 75 f0             	push   -0x10(%ebp)
801064bb:	53                   	push   %ebx
801064bc:	6a 01                	push   $0x1
801064be:	e8 9d fb ff ff       	call   80106060 <argptr>
801064c3:	83 c4 10             	add    $0x10,%esp
801064c6:	85 c0                	test   %eax,%eax
801064c8:	78 1e                	js     801064e8 <sys_write+0x78>
  return filewrite(f, p, n);
801064ca:	83 ec 04             	sub    $0x4,%esp
801064cd:	ff 75 f0             	push   -0x10(%ebp)
801064d0:	ff 75 f4             	push   -0xc(%ebp)
801064d3:	56                   	push   %esi
801064d4:	e8 b7 be ff ff       	call   80102390 <filewrite>
801064d9:	83 c4 10             	add    $0x10,%esp
}
801064dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064df:	5b                   	pop    %ebx
801064e0:	5e                   	pop    %esi
801064e1:	5d                   	pop    %ebp
801064e2:	c3                   	ret    
801064e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064e7:	90                   	nop
    return -1;
801064e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ed:	eb ed                	jmp    801064dc <sys_write+0x6c>
801064ef:	90                   	nop

801064f0 <sys_close>:
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	56                   	push   %esi
801064f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801064f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801064f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801064fb:	50                   	push   %eax
801064fc:	6a 00                	push   $0x0
801064fe:	e8 0d fb ff ff       	call   80106010 <argint>
80106503:	83 c4 10             	add    $0x10,%esp
80106506:	85 c0                	test   %eax,%eax
80106508:	78 3e                	js     80106548 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010650a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010650e:	77 38                	ja     80106548 <sys_close+0x58>
80106510:	e8 4b e7 ff ff       	call   80104c60 <myproc>
80106515:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106518:	8d 5a 08             	lea    0x8(%edx),%ebx
8010651b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010651f:	85 f6                	test   %esi,%esi
80106521:	74 25                	je     80106548 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106523:	e8 38 e7 ff ff       	call   80104c60 <myproc>
  fileclose(f);
80106528:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010652b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106532:	00 
  fileclose(f);
80106533:	56                   	push   %esi
80106534:	e8 97 bc ff ff       	call   801021d0 <fileclose>
  return 0;
80106539:	83 c4 10             	add    $0x10,%esp
8010653c:	31 c0                	xor    %eax,%eax
}
8010653e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106541:	5b                   	pop    %ebx
80106542:	5e                   	pop    %esi
80106543:	5d                   	pop    %ebp
80106544:	c3                   	ret    
80106545:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010654d:	eb ef                	jmp    8010653e <sys_close+0x4e>
8010654f:	90                   	nop

80106550 <sys_fstat>:
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	56                   	push   %esi
80106554:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106555:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106558:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010655b:	53                   	push   %ebx
8010655c:	6a 00                	push   $0x0
8010655e:	e8 ad fa ff ff       	call   80106010 <argint>
80106563:	83 c4 10             	add    $0x10,%esp
80106566:	85 c0                	test   %eax,%eax
80106568:	78 46                	js     801065b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010656a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010656e:	77 40                	ja     801065b0 <sys_fstat+0x60>
80106570:	e8 eb e6 ff ff       	call   80104c60 <myproc>
80106575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106578:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010657c:	85 f6                	test   %esi,%esi
8010657e:	74 30                	je     801065b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106580:	83 ec 04             	sub    $0x4,%esp
80106583:	6a 14                	push   $0x14
80106585:	53                   	push   %ebx
80106586:	6a 01                	push   $0x1
80106588:	e8 d3 fa ff ff       	call   80106060 <argptr>
8010658d:	83 c4 10             	add    $0x10,%esp
80106590:	85 c0                	test   %eax,%eax
80106592:	78 1c                	js     801065b0 <sys_fstat+0x60>
  return filestat(f, st);
80106594:	83 ec 08             	sub    $0x8,%esp
80106597:	ff 75 f4             	push   -0xc(%ebp)
8010659a:	56                   	push   %esi
8010659b:	e8 10 bd ff ff       	call   801022b0 <filestat>
801065a0:	83 c4 10             	add    $0x10,%esp
}
801065a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065a6:	5b                   	pop    %ebx
801065a7:	5e                   	pop    %esi
801065a8:	5d                   	pop    %ebp
801065a9:	c3                   	ret    
801065aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801065b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b5:	eb ec                	jmp    801065a3 <sys_fstat+0x53>
801065b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065be:	66 90                	xchg   %ax,%ax

801065c0 <sys_link>:
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801065c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801065c8:	53                   	push   %ebx
801065c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801065cc:	50                   	push   %eax
801065cd:	6a 00                	push   $0x0
801065cf:	e8 fc fa ff ff       	call   801060d0 <argstr>
801065d4:	83 c4 10             	add    $0x10,%esp
801065d7:	85 c0                	test   %eax,%eax
801065d9:	0f 88 fb 00 00 00    	js     801066da <sys_link+0x11a>
801065df:	83 ec 08             	sub    $0x8,%esp
801065e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801065e5:	50                   	push   %eax
801065e6:	6a 01                	push   $0x1
801065e8:	e8 e3 fa ff ff       	call   801060d0 <argstr>
801065ed:	83 c4 10             	add    $0x10,%esp
801065f0:	85 c0                	test   %eax,%eax
801065f2:	0f 88 e2 00 00 00    	js     801066da <sys_link+0x11a>
  begin_op();
801065f8:	e8 43 da ff ff       	call   80104040 <begin_op>
  if((ip = namei(old)) == 0){
801065fd:	83 ec 0c             	sub    $0xc,%esp
80106600:	ff 75 d4             	push   -0x2c(%ebp)
80106603:	e8 78 cd ff ff       	call   80103380 <namei>
80106608:	83 c4 10             	add    $0x10,%esp
8010660b:	89 c3                	mov    %eax,%ebx
8010660d:	85 c0                	test   %eax,%eax
8010660f:	0f 84 e4 00 00 00    	je     801066f9 <sys_link+0x139>
  ilock(ip);
80106615:	83 ec 0c             	sub    $0xc,%esp
80106618:	50                   	push   %eax
80106619:	e8 42 c4 ff ff       	call   80102a60 <ilock>
  if(ip->type == T_DIR){
8010661e:	83 c4 10             	add    $0x10,%esp
80106621:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106626:	0f 84 b5 00 00 00    	je     801066e1 <sys_link+0x121>
  iupdate(ip);
8010662c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010662f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106634:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106637:	53                   	push   %ebx
80106638:	e8 73 c3 ff ff       	call   801029b0 <iupdate>
  iunlock(ip);
8010663d:	89 1c 24             	mov    %ebx,(%esp)
80106640:	e8 fb c4 ff ff       	call   80102b40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106645:	58                   	pop    %eax
80106646:	5a                   	pop    %edx
80106647:	57                   	push   %edi
80106648:	ff 75 d0             	push   -0x30(%ebp)
8010664b:	e8 50 cd ff ff       	call   801033a0 <nameiparent>
80106650:	83 c4 10             	add    $0x10,%esp
80106653:	89 c6                	mov    %eax,%esi
80106655:	85 c0                	test   %eax,%eax
80106657:	74 5b                	je     801066b4 <sys_link+0xf4>
  ilock(dp);
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	50                   	push   %eax
8010665d:	e8 fe c3 ff ff       	call   80102a60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106662:	8b 03                	mov    (%ebx),%eax
80106664:	83 c4 10             	add    $0x10,%esp
80106667:	39 06                	cmp    %eax,(%esi)
80106669:	75 3d                	jne    801066a8 <sys_link+0xe8>
8010666b:	83 ec 04             	sub    $0x4,%esp
8010666e:	ff 73 04             	push   0x4(%ebx)
80106671:	57                   	push   %edi
80106672:	56                   	push   %esi
80106673:	e8 48 cc ff ff       	call   801032c0 <dirlink>
80106678:	83 c4 10             	add    $0x10,%esp
8010667b:	85 c0                	test   %eax,%eax
8010667d:	78 29                	js     801066a8 <sys_link+0xe8>
  iunlockput(dp);
8010667f:	83 ec 0c             	sub    $0xc,%esp
80106682:	56                   	push   %esi
80106683:	e8 68 c6 ff ff       	call   80102cf0 <iunlockput>
  iput(ip);
80106688:	89 1c 24             	mov    %ebx,(%esp)
8010668b:	e8 00 c5 ff ff       	call   80102b90 <iput>
  end_op();
80106690:	e8 1b da ff ff       	call   801040b0 <end_op>
  return 0;
80106695:	83 c4 10             	add    $0x10,%esp
80106698:	31 c0                	xor    %eax,%eax
}
8010669a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010669d:	5b                   	pop    %ebx
8010669e:	5e                   	pop    %esi
8010669f:	5f                   	pop    %edi
801066a0:	5d                   	pop    %ebp
801066a1:	c3                   	ret    
801066a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801066a8:	83 ec 0c             	sub    $0xc,%esp
801066ab:	56                   	push   %esi
801066ac:	e8 3f c6 ff ff       	call   80102cf0 <iunlockput>
    goto bad;
801066b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801066b4:	83 ec 0c             	sub    $0xc,%esp
801066b7:	53                   	push   %ebx
801066b8:	e8 a3 c3 ff ff       	call   80102a60 <ilock>
  ip->nlink--;
801066bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801066c2:	89 1c 24             	mov    %ebx,(%esp)
801066c5:	e8 e6 c2 ff ff       	call   801029b0 <iupdate>
  iunlockput(ip);
801066ca:	89 1c 24             	mov    %ebx,(%esp)
801066cd:	e8 1e c6 ff ff       	call   80102cf0 <iunlockput>
  end_op();
801066d2:	e8 d9 d9 ff ff       	call   801040b0 <end_op>
  return -1;
801066d7:	83 c4 10             	add    $0x10,%esp
801066da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066df:	eb b9                	jmp    8010669a <sys_link+0xda>
    iunlockput(ip);
801066e1:	83 ec 0c             	sub    $0xc,%esp
801066e4:	53                   	push   %ebx
801066e5:	e8 06 c6 ff ff       	call   80102cf0 <iunlockput>
    end_op();
801066ea:	e8 c1 d9 ff ff       	call   801040b0 <end_op>
    return -1;
801066ef:	83 c4 10             	add    $0x10,%esp
801066f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066f7:	eb a1                	jmp    8010669a <sys_link+0xda>
    end_op();
801066f9:	e8 b2 d9 ff ff       	call   801040b0 <end_op>
    return -1;
801066fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106703:	eb 95                	jmp    8010669a <sys_link+0xda>
80106705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106710 <sys_unlink>:
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106715:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106718:	53                   	push   %ebx
80106719:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010671c:	50                   	push   %eax
8010671d:	6a 00                	push   $0x0
8010671f:	e8 ac f9 ff ff       	call   801060d0 <argstr>
80106724:	83 c4 10             	add    $0x10,%esp
80106727:	85 c0                	test   %eax,%eax
80106729:	0f 88 7a 01 00 00    	js     801068a9 <sys_unlink+0x199>
  begin_op();
8010672f:	e8 0c d9 ff ff       	call   80104040 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106734:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106737:	83 ec 08             	sub    $0x8,%esp
8010673a:	53                   	push   %ebx
8010673b:	ff 75 c0             	push   -0x40(%ebp)
8010673e:	e8 5d cc ff ff       	call   801033a0 <nameiparent>
80106743:	83 c4 10             	add    $0x10,%esp
80106746:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106749:	85 c0                	test   %eax,%eax
8010674b:	0f 84 62 01 00 00    	je     801068b3 <sys_unlink+0x1a3>
  ilock(dp);
80106751:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106754:	83 ec 0c             	sub    $0xc,%esp
80106757:	57                   	push   %edi
80106758:	e8 03 c3 ff ff       	call   80102a60 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010675d:	58                   	pop    %eax
8010675e:	5a                   	pop    %edx
8010675f:	68 b0 93 10 80       	push   $0x801093b0
80106764:	53                   	push   %ebx
80106765:	e8 36 c8 ff ff       	call   80102fa0 <namecmp>
8010676a:	83 c4 10             	add    $0x10,%esp
8010676d:	85 c0                	test   %eax,%eax
8010676f:	0f 84 fb 00 00 00    	je     80106870 <sys_unlink+0x160>
80106775:	83 ec 08             	sub    $0x8,%esp
80106778:	68 af 93 10 80       	push   $0x801093af
8010677d:	53                   	push   %ebx
8010677e:	e8 1d c8 ff ff       	call   80102fa0 <namecmp>
80106783:	83 c4 10             	add    $0x10,%esp
80106786:	85 c0                	test   %eax,%eax
80106788:	0f 84 e2 00 00 00    	je     80106870 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010678e:	83 ec 04             	sub    $0x4,%esp
80106791:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106794:	50                   	push   %eax
80106795:	53                   	push   %ebx
80106796:	57                   	push   %edi
80106797:	e8 24 c8 ff ff       	call   80102fc0 <dirlookup>
8010679c:	83 c4 10             	add    $0x10,%esp
8010679f:	89 c3                	mov    %eax,%ebx
801067a1:	85 c0                	test   %eax,%eax
801067a3:	0f 84 c7 00 00 00    	je     80106870 <sys_unlink+0x160>
  ilock(ip);
801067a9:	83 ec 0c             	sub    $0xc,%esp
801067ac:	50                   	push   %eax
801067ad:	e8 ae c2 ff ff       	call   80102a60 <ilock>
  if(ip->nlink < 1)
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801067ba:	0f 8e 1c 01 00 00    	jle    801068dc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801067c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801067c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801067c8:	74 66                	je     80106830 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801067ca:	83 ec 04             	sub    $0x4,%esp
801067cd:	6a 10                	push   $0x10
801067cf:	6a 00                	push   $0x0
801067d1:	57                   	push   %edi
801067d2:	e8 79 f5 ff ff       	call   80105d50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801067d7:	6a 10                	push   $0x10
801067d9:	ff 75 c4             	push   -0x3c(%ebp)
801067dc:	57                   	push   %edi
801067dd:	ff 75 b4             	push   -0x4c(%ebp)
801067e0:	e8 8b c6 ff ff       	call   80102e70 <writei>
801067e5:	83 c4 20             	add    $0x20,%esp
801067e8:	83 f8 10             	cmp    $0x10,%eax
801067eb:	0f 85 de 00 00 00    	jne    801068cf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801067f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801067f6:	0f 84 94 00 00 00    	je     80106890 <sys_unlink+0x180>
  iunlockput(dp);
801067fc:	83 ec 0c             	sub    $0xc,%esp
801067ff:	ff 75 b4             	push   -0x4c(%ebp)
80106802:	e8 e9 c4 ff ff       	call   80102cf0 <iunlockput>
  ip->nlink--;
80106807:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010680c:	89 1c 24             	mov    %ebx,(%esp)
8010680f:	e8 9c c1 ff ff       	call   801029b0 <iupdate>
  iunlockput(ip);
80106814:	89 1c 24             	mov    %ebx,(%esp)
80106817:	e8 d4 c4 ff ff       	call   80102cf0 <iunlockput>
  end_op();
8010681c:	e8 8f d8 ff ff       	call   801040b0 <end_op>
  return 0;
80106821:	83 c4 10             	add    $0x10,%esp
80106824:	31 c0                	xor    %eax,%eax
}
80106826:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106829:	5b                   	pop    %ebx
8010682a:	5e                   	pop    %esi
8010682b:	5f                   	pop    %edi
8010682c:	5d                   	pop    %ebp
8010682d:	c3                   	ret    
8010682e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106830:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106834:	76 94                	jbe    801067ca <sys_unlink+0xba>
80106836:	be 20 00 00 00       	mov    $0x20,%esi
8010683b:	eb 0b                	jmp    80106848 <sys_unlink+0x138>
8010683d:	8d 76 00             	lea    0x0(%esi),%esi
80106840:	83 c6 10             	add    $0x10,%esi
80106843:	3b 73 58             	cmp    0x58(%ebx),%esi
80106846:	73 82                	jae    801067ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106848:	6a 10                	push   $0x10
8010684a:	56                   	push   %esi
8010684b:	57                   	push   %edi
8010684c:	53                   	push   %ebx
8010684d:	e8 1e c5 ff ff       	call   80102d70 <readi>
80106852:	83 c4 10             	add    $0x10,%esp
80106855:	83 f8 10             	cmp    $0x10,%eax
80106858:	75 68                	jne    801068c2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010685a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010685f:	74 df                	je     80106840 <sys_unlink+0x130>
    iunlockput(ip);
80106861:	83 ec 0c             	sub    $0xc,%esp
80106864:	53                   	push   %ebx
80106865:	e8 86 c4 ff ff       	call   80102cf0 <iunlockput>
    goto bad;
8010686a:	83 c4 10             	add    $0x10,%esp
8010686d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106870:	83 ec 0c             	sub    $0xc,%esp
80106873:	ff 75 b4             	push   -0x4c(%ebp)
80106876:	e8 75 c4 ff ff       	call   80102cf0 <iunlockput>
  end_op();
8010687b:	e8 30 d8 ff ff       	call   801040b0 <end_op>
  return -1;
80106880:	83 c4 10             	add    $0x10,%esp
80106883:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106888:	eb 9c                	jmp    80106826 <sys_unlink+0x116>
8010688a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106890:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106893:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106896:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010689b:	50                   	push   %eax
8010689c:	e8 0f c1 ff ff       	call   801029b0 <iupdate>
801068a1:	83 c4 10             	add    $0x10,%esp
801068a4:	e9 53 ff ff ff       	jmp    801067fc <sys_unlink+0xec>
    return -1;
801068a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ae:	e9 73 ff ff ff       	jmp    80106826 <sys_unlink+0x116>
    end_op();
801068b3:	e8 f8 d7 ff ff       	call   801040b0 <end_op>
    return -1;
801068b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068bd:	e9 64 ff ff ff       	jmp    80106826 <sys_unlink+0x116>
      panic("isdirempty: readi");
801068c2:	83 ec 0c             	sub    $0xc,%esp
801068c5:	68 d4 93 10 80       	push   $0x801093d4
801068ca:	e8 91 9b ff ff       	call   80100460 <panic>
    panic("unlink: writei");
801068cf:	83 ec 0c             	sub    $0xc,%esp
801068d2:	68 e6 93 10 80       	push   $0x801093e6
801068d7:	e8 84 9b ff ff       	call   80100460 <panic>
    panic("unlink: nlink < 1");
801068dc:	83 ec 0c             	sub    $0xc,%esp
801068df:	68 c2 93 10 80       	push   $0x801093c2
801068e4:	e8 77 9b ff ff       	call   80100460 <panic>
801068e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068f0 <sys_open>:

int
sys_open(void)
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801068f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801068f8:	53                   	push   %ebx
801068f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801068fc:	50                   	push   %eax
801068fd:	6a 00                	push   $0x0
801068ff:	e8 cc f7 ff ff       	call   801060d0 <argstr>
80106904:	83 c4 10             	add    $0x10,%esp
80106907:	85 c0                	test   %eax,%eax
80106909:	0f 88 8e 00 00 00    	js     8010699d <sys_open+0xad>
8010690f:	83 ec 08             	sub    $0x8,%esp
80106912:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106915:	50                   	push   %eax
80106916:	6a 01                	push   $0x1
80106918:	e8 f3 f6 ff ff       	call   80106010 <argint>
8010691d:	83 c4 10             	add    $0x10,%esp
80106920:	85 c0                	test   %eax,%eax
80106922:	78 79                	js     8010699d <sys_open+0xad>
    return -1;

  begin_op();
80106924:	e8 17 d7 ff ff       	call   80104040 <begin_op>

  if(omode & O_CREATE){
80106929:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010692d:	75 79                	jne    801069a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010692f:	83 ec 0c             	sub    $0xc,%esp
80106932:	ff 75 e0             	push   -0x20(%ebp)
80106935:	e8 46 ca ff ff       	call   80103380 <namei>
8010693a:	83 c4 10             	add    $0x10,%esp
8010693d:	89 c6                	mov    %eax,%esi
8010693f:	85 c0                	test   %eax,%eax
80106941:	0f 84 7e 00 00 00    	je     801069c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106947:	83 ec 0c             	sub    $0xc,%esp
8010694a:	50                   	push   %eax
8010694b:	e8 10 c1 ff ff       	call   80102a60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106950:	83 c4 10             	add    $0x10,%esp
80106953:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106958:	0f 84 c2 00 00 00    	je     80106a20 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010695e:	e8 ad b7 ff ff       	call   80102110 <filealloc>
80106963:	89 c7                	mov    %eax,%edi
80106965:	85 c0                	test   %eax,%eax
80106967:	74 23                	je     8010698c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106969:	e8 f2 e2 ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010696e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106970:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106974:	85 d2                	test   %edx,%edx
80106976:	74 60                	je     801069d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106978:	83 c3 01             	add    $0x1,%ebx
8010697b:	83 fb 10             	cmp    $0x10,%ebx
8010697e:	75 f0                	jne    80106970 <sys_open+0x80>
    if(f)
      fileclose(f);
80106980:	83 ec 0c             	sub    $0xc,%esp
80106983:	57                   	push   %edi
80106984:	e8 47 b8 ff ff       	call   801021d0 <fileclose>
80106989:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010698c:	83 ec 0c             	sub    $0xc,%esp
8010698f:	56                   	push   %esi
80106990:	e8 5b c3 ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106995:	e8 16 d7 ff ff       	call   801040b0 <end_op>
    return -1;
8010699a:	83 c4 10             	add    $0x10,%esp
8010699d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801069a2:	eb 6d                	jmp    80106a11 <sys_open+0x121>
801069a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801069a8:	83 ec 0c             	sub    $0xc,%esp
801069ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069ae:	31 c9                	xor    %ecx,%ecx
801069b0:	ba 02 00 00 00       	mov    $0x2,%edx
801069b5:	6a 00                	push   $0x0
801069b7:	e8 14 f8 ff ff       	call   801061d0 <create>
    if(ip == 0){
801069bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801069bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801069c1:	85 c0                	test   %eax,%eax
801069c3:	75 99                	jne    8010695e <sys_open+0x6e>
      end_op();
801069c5:	e8 e6 d6 ff ff       	call   801040b0 <end_op>
      return -1;
801069ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801069cf:	eb 40                	jmp    80106a11 <sys_open+0x121>
801069d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801069d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801069db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801069df:	56                   	push   %esi
801069e0:	e8 5b c1 ff ff       	call   80102b40 <iunlock>
  end_op();
801069e5:	e8 c6 d6 ff ff       	call   801040b0 <end_op>

  f->type = FD_INODE;
801069ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801069f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801069f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801069f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801069f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801069fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106a02:	f7 d0                	not    %eax
80106a04:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106a07:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106a0a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106a0d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a14:	89 d8                	mov    %ebx,%eax
80106a16:	5b                   	pop    %ebx
80106a17:	5e                   	pop    %esi
80106a18:	5f                   	pop    %edi
80106a19:	5d                   	pop    %ebp
80106a1a:	c3                   	ret    
80106a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a1f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106a20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a23:	85 c9                	test   %ecx,%ecx
80106a25:	0f 84 33 ff ff ff    	je     8010695e <sys_open+0x6e>
80106a2b:	e9 5c ff ff ff       	jmp    8010698c <sys_open+0x9c>

80106a30 <sys_mkdir>:

int
sys_mkdir(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106a36:	e8 05 d6 ff ff       	call   80104040 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106a3b:	83 ec 08             	sub    $0x8,%esp
80106a3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a41:	50                   	push   %eax
80106a42:	6a 00                	push   $0x0
80106a44:	e8 87 f6 ff ff       	call   801060d0 <argstr>
80106a49:	83 c4 10             	add    $0x10,%esp
80106a4c:	85 c0                	test   %eax,%eax
80106a4e:	78 30                	js     80106a80 <sys_mkdir+0x50>
80106a50:	83 ec 0c             	sub    $0xc,%esp
80106a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a56:	31 c9                	xor    %ecx,%ecx
80106a58:	ba 01 00 00 00       	mov    $0x1,%edx
80106a5d:	6a 00                	push   $0x0
80106a5f:	e8 6c f7 ff ff       	call   801061d0 <create>
80106a64:	83 c4 10             	add    $0x10,%esp
80106a67:	85 c0                	test   %eax,%eax
80106a69:	74 15                	je     80106a80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106a6b:	83 ec 0c             	sub    $0xc,%esp
80106a6e:	50                   	push   %eax
80106a6f:	e8 7c c2 ff ff       	call   80102cf0 <iunlockput>
  end_op();
80106a74:	e8 37 d6 ff ff       	call   801040b0 <end_op>
  return 0;
80106a79:	83 c4 10             	add    $0x10,%esp
80106a7c:	31 c0                	xor    %eax,%eax
}
80106a7e:	c9                   	leave  
80106a7f:	c3                   	ret    
    end_op();
80106a80:	e8 2b d6 ff ff       	call   801040b0 <end_op>
    return -1;
80106a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a8a:	c9                   	leave  
80106a8b:	c3                   	ret    
80106a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a90 <sys_mknod>:

int
sys_mknod(void)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106a96:	e8 a5 d5 ff ff       	call   80104040 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106a9b:	83 ec 08             	sub    $0x8,%esp
80106a9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106aa1:	50                   	push   %eax
80106aa2:	6a 00                	push   $0x0
80106aa4:	e8 27 f6 ff ff       	call   801060d0 <argstr>
80106aa9:	83 c4 10             	add    $0x10,%esp
80106aac:	85 c0                	test   %eax,%eax
80106aae:	78 60                	js     80106b10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106ab0:	83 ec 08             	sub    $0x8,%esp
80106ab3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ab6:	50                   	push   %eax
80106ab7:	6a 01                	push   $0x1
80106ab9:	e8 52 f5 ff ff       	call   80106010 <argint>
  if((argstr(0, &path)) < 0 ||
80106abe:	83 c4 10             	add    $0x10,%esp
80106ac1:	85 c0                	test   %eax,%eax
80106ac3:	78 4b                	js     80106b10 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106ac5:	83 ec 08             	sub    $0x8,%esp
80106ac8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106acb:	50                   	push   %eax
80106acc:	6a 02                	push   $0x2
80106ace:	e8 3d f5 ff ff       	call   80106010 <argint>
     argint(1, &major) < 0 ||
80106ad3:	83 c4 10             	add    $0x10,%esp
80106ad6:	85 c0                	test   %eax,%eax
80106ad8:	78 36                	js     80106b10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106ada:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106ade:	83 ec 0c             	sub    $0xc,%esp
80106ae1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106ae5:	ba 03 00 00 00       	mov    $0x3,%edx
80106aea:	50                   	push   %eax
80106aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106aee:	e8 dd f6 ff ff       	call   801061d0 <create>
     argint(2, &minor) < 0 ||
80106af3:	83 c4 10             	add    $0x10,%esp
80106af6:	85 c0                	test   %eax,%eax
80106af8:	74 16                	je     80106b10 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106afa:	83 ec 0c             	sub    $0xc,%esp
80106afd:	50                   	push   %eax
80106afe:	e8 ed c1 ff ff       	call   80102cf0 <iunlockput>
  end_op();
80106b03:	e8 a8 d5 ff ff       	call   801040b0 <end_op>
  return 0;
80106b08:	83 c4 10             	add    $0x10,%esp
80106b0b:	31 c0                	xor    %eax,%eax
}
80106b0d:	c9                   	leave  
80106b0e:	c3                   	ret    
80106b0f:	90                   	nop
    end_op();
80106b10:	e8 9b d5 ff ff       	call   801040b0 <end_op>
    return -1;
80106b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b1a:	c9                   	leave  
80106b1b:	c3                   	ret    
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <sys_chdir>:

int
sys_chdir(void)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	56                   	push   %esi
80106b24:	53                   	push   %ebx
80106b25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106b28:	e8 33 e1 ff ff       	call   80104c60 <myproc>
80106b2d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106b2f:	e8 0c d5 ff ff       	call   80104040 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106b34:	83 ec 08             	sub    $0x8,%esp
80106b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b3a:	50                   	push   %eax
80106b3b:	6a 00                	push   $0x0
80106b3d:	e8 8e f5 ff ff       	call   801060d0 <argstr>
80106b42:	83 c4 10             	add    $0x10,%esp
80106b45:	85 c0                	test   %eax,%eax
80106b47:	78 77                	js     80106bc0 <sys_chdir+0xa0>
80106b49:	83 ec 0c             	sub    $0xc,%esp
80106b4c:	ff 75 f4             	push   -0xc(%ebp)
80106b4f:	e8 2c c8 ff ff       	call   80103380 <namei>
80106b54:	83 c4 10             	add    $0x10,%esp
80106b57:	89 c3                	mov    %eax,%ebx
80106b59:	85 c0                	test   %eax,%eax
80106b5b:	74 63                	je     80106bc0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106b5d:	83 ec 0c             	sub    $0xc,%esp
80106b60:	50                   	push   %eax
80106b61:	e8 fa be ff ff       	call   80102a60 <ilock>
  if(ip->type != T_DIR){
80106b66:	83 c4 10             	add    $0x10,%esp
80106b69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106b6e:	75 30                	jne    80106ba0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106b70:	83 ec 0c             	sub    $0xc,%esp
80106b73:	53                   	push   %ebx
80106b74:	e8 c7 bf ff ff       	call   80102b40 <iunlock>
  iput(curproc->cwd);
80106b79:	58                   	pop    %eax
80106b7a:	ff 76 68             	push   0x68(%esi)
80106b7d:	e8 0e c0 ff ff       	call   80102b90 <iput>
  end_op();
80106b82:	e8 29 d5 ff ff       	call   801040b0 <end_op>
  curproc->cwd = ip;
80106b87:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80106b8a:	83 c4 10             	add    $0x10,%esp
80106b8d:	31 c0                	xor    %eax,%eax
}
80106b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b92:	5b                   	pop    %ebx
80106b93:	5e                   	pop    %esi
80106b94:	5d                   	pop    %ebp
80106b95:	c3                   	ret    
80106b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106ba0:	83 ec 0c             	sub    $0xc,%esp
80106ba3:	53                   	push   %ebx
80106ba4:	e8 47 c1 ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106ba9:	e8 02 d5 ff ff       	call   801040b0 <end_op>
    return -1;
80106bae:	83 c4 10             	add    $0x10,%esp
80106bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb6:	eb d7                	jmp    80106b8f <sys_chdir+0x6f>
80106bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop
    end_op();
80106bc0:	e8 eb d4 ff ff       	call   801040b0 <end_op>
    return -1;
80106bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bca:	eb c3                	jmp    80106b8f <sys_chdir+0x6f>
80106bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bd0 <sys_exec>:

int
sys_exec(void)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106bd5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106bdb:	53                   	push   %ebx
80106bdc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106be2:	50                   	push   %eax
80106be3:	6a 00                	push   $0x0
80106be5:	e8 e6 f4 ff ff       	call   801060d0 <argstr>
80106bea:	83 c4 10             	add    $0x10,%esp
80106bed:	85 c0                	test   %eax,%eax
80106bef:	0f 88 87 00 00 00    	js     80106c7c <sys_exec+0xac>
80106bf5:	83 ec 08             	sub    $0x8,%esp
80106bf8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106bfe:	50                   	push   %eax
80106bff:	6a 01                	push   $0x1
80106c01:	e8 0a f4 ff ff       	call   80106010 <argint>
80106c06:	83 c4 10             	add    $0x10,%esp
80106c09:	85 c0                	test   %eax,%eax
80106c0b:	78 6f                	js     80106c7c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106c0d:	83 ec 04             	sub    $0x4,%esp
80106c10:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106c16:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106c18:	68 80 00 00 00       	push   $0x80
80106c1d:	6a 00                	push   $0x0
80106c1f:	56                   	push   %esi
80106c20:	e8 2b f1 ff ff       	call   80105d50 <memset>
80106c25:	83 c4 10             	add    $0x10,%esp
80106c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c2f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106c30:	83 ec 08             	sub    $0x8,%esp
80106c33:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106c39:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106c40:	50                   	push   %eax
80106c41:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106c47:	01 f8                	add    %edi,%eax
80106c49:	50                   	push   %eax
80106c4a:	e8 31 f3 ff ff       	call   80105f80 <fetchint>
80106c4f:	83 c4 10             	add    $0x10,%esp
80106c52:	85 c0                	test   %eax,%eax
80106c54:	78 26                	js     80106c7c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106c56:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106c5c:	85 c0                	test   %eax,%eax
80106c5e:	74 30                	je     80106c90 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106c60:	83 ec 08             	sub    $0x8,%esp
80106c63:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106c66:	52                   	push   %edx
80106c67:	50                   	push   %eax
80106c68:	e8 53 f3 ff ff       	call   80105fc0 <fetchstr>
80106c6d:	83 c4 10             	add    $0x10,%esp
80106c70:	85 c0                	test   %eax,%eax
80106c72:	78 08                	js     80106c7c <sys_exec+0xac>
  for(i=0;; i++){
80106c74:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106c77:	83 fb 20             	cmp    $0x20,%ebx
80106c7a:	75 b4                	jne    80106c30 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c84:	5b                   	pop    %ebx
80106c85:	5e                   	pop    %esi
80106c86:	5f                   	pop    %edi
80106c87:	5d                   	pop    %ebp
80106c88:	c3                   	ret    
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106c90:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106c97:	00 00 00 00 
  return exec(path, argv);
80106c9b:	83 ec 08             	sub    $0x8,%esp
80106c9e:	56                   	push   %esi
80106c9f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106ca5:	e8 e6 b0 ff ff       	call   80101d90 <exec>
80106caa:	83 c4 10             	add    $0x10,%esp
}
80106cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb0:	5b                   	pop    %ebx
80106cb1:	5e                   	pop    %esi
80106cb2:	5f                   	pop    %edi
80106cb3:	5d                   	pop    %ebp
80106cb4:	c3                   	ret    
80106cb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <sys_pipe>:

int
sys_pipe(void)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106cc5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106cc8:	53                   	push   %ebx
80106cc9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106ccc:	6a 08                	push   $0x8
80106cce:	50                   	push   %eax
80106ccf:	6a 00                	push   $0x0
80106cd1:	e8 8a f3 ff ff       	call   80106060 <argptr>
80106cd6:	83 c4 10             	add    $0x10,%esp
80106cd9:	85 c0                	test   %eax,%eax
80106cdb:	78 4a                	js     80106d27 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106cdd:	83 ec 08             	sub    $0x8,%esp
80106ce0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ce3:	50                   	push   %eax
80106ce4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106ce7:	50                   	push   %eax
80106ce8:	e8 23 da ff ff       	call   80104710 <pipealloc>
80106ced:	83 c4 10             	add    $0x10,%esp
80106cf0:	85 c0                	test   %eax,%eax
80106cf2:	78 33                	js     80106d27 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106cf4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106cf7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106cf9:	e8 62 df ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106cfe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106d00:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106d04:	85 f6                	test   %esi,%esi
80106d06:	74 28                	je     80106d30 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106d08:	83 c3 01             	add    $0x1,%ebx
80106d0b:	83 fb 10             	cmp    $0x10,%ebx
80106d0e:	75 f0                	jne    80106d00 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106d10:	83 ec 0c             	sub    $0xc,%esp
80106d13:	ff 75 e0             	push   -0x20(%ebp)
80106d16:	e8 b5 b4 ff ff       	call   801021d0 <fileclose>
    fileclose(wf);
80106d1b:	58                   	pop    %eax
80106d1c:	ff 75 e4             	push   -0x1c(%ebp)
80106d1f:	e8 ac b4 ff ff       	call   801021d0 <fileclose>
    return -1;
80106d24:	83 c4 10             	add    $0x10,%esp
80106d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d2c:	eb 53                	jmp    80106d81 <sys_pipe+0xc1>
80106d2e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106d30:	8d 73 08             	lea    0x8(%ebx),%esi
80106d33:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106d37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106d3a:	e8 21 df ff ff       	call   80104c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106d3f:	31 d2                	xor    %edx,%edx
80106d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106d48:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106d4c:	85 c9                	test   %ecx,%ecx
80106d4e:	74 20                	je     80106d70 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106d50:	83 c2 01             	add    $0x1,%edx
80106d53:	83 fa 10             	cmp    $0x10,%edx
80106d56:	75 f0                	jne    80106d48 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106d58:	e8 03 df ff ff       	call   80104c60 <myproc>
80106d5d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106d64:	00 
80106d65:	eb a9                	jmp    80106d10 <sys_pipe+0x50>
80106d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106d70:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106d74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d77:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d7c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106d7f:	31 c0                	xor    %eax,%eax
}
80106d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d84:	5b                   	pop    %ebx
80106d85:	5e                   	pop    %esi
80106d86:	5f                   	pop    %edi
80106d87:	5d                   	pop    %ebp
80106d88:	c3                   	ret    
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d90 <sys_move_file>:

int sys_move_file(void)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
  struct inode *ip_src, *dp_des, *dp_src;
  char name[DIRSIZ];
  uint off;
  struct dirent de;

  if (argstr(0, &path_src) < 0 || argstr(1, &path_des) < 0){
80106d95:	8d 45 bc             	lea    -0x44(%ebp),%eax
{
80106d98:	53                   	push   %ebx
80106d99:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path_src) < 0 || argstr(1, &path_des) < 0){
80106d9c:	50                   	push   %eax
80106d9d:	6a 00                	push   $0x0
80106d9f:	e8 2c f3 ff ff       	call   801060d0 <argstr>
80106da4:	83 c4 10             	add    $0x10,%esp
80106da7:	85 c0                	test   %eax,%eax
80106da9:	0f 88 42 01 00 00    	js     80106ef1 <sys_move_file+0x161>
80106daf:	83 ec 08             	sub    $0x8,%esp
80106db2:	8d 45 c0             	lea    -0x40(%ebp),%eax
80106db5:	50                   	push   %eax
80106db6:	6a 01                	push   $0x1
80106db8:	e8 13 f3 ff ff       	call   801060d0 <argstr>
80106dbd:	83 c4 10             	add    $0x10,%esp
80106dc0:	85 c0                	test   %eax,%eax
80106dc2:	0f 88 29 01 00 00    	js     80106ef1 <sys_move_file+0x161>
    return -1;
  }

  cprintf("Source path: %s\n", path_src);
80106dc8:	83 ec 08             	sub    $0x8,%esp
80106dcb:	ff 75 bc             	push   -0x44(%ebp)
80106dce:	68 f5 93 10 80       	push   $0x801093f5
80106dd3:	e8 08 9a ff ff       	call   801007e0 <cprintf>
  cprintf("Destination directory: %s\n", path_des);
80106dd8:	58                   	pop    %eax
80106dd9:	5a                   	pop    %edx
80106dda:	ff 75 c0             	push   -0x40(%ebp)
80106ddd:	68 06 94 10 80       	push   $0x80109406
80106de2:	e8 f9 99 ff ff       	call   801007e0 <cprintf>

  ip_src = namei(path_src);
80106de7:	59                   	pop    %ecx
80106de8:	ff 75 bc             	push   -0x44(%ebp)
80106deb:	e8 90 c5 ff ff       	call   80103380 <namei>
  if (ip_src == 0)
80106df0:	83 c4 10             	add    $0x10,%esp
80106df3:	85 c0                	test   %eax,%eax
80106df5:	0f 84 51 01 00 00    	je     80106f4c <sys_move_file+0x1bc>
  {
    cprintf("Error: Source file not found\n");
    return -1;
  }
  if (ip_src->type != T_FILE)
80106dfb:	66 83 78 50 02       	cmpw   $0x2,0x50(%eax)
80106e00:	0f 85 fa 00 00 00    	jne    80106f00 <sys_move_file+0x170>
  {
    cprintf("Error: Source is not a regular file\n");
    return -1;
  }

  begin_op();
80106e06:	e8 35 d2 ff ff       	call   80104040 <begin_op>
  if ((dp_src = nameiparent(path_src, name)) == 0)
80106e0b:	8d 7d ca             	lea    -0x36(%ebp),%edi
80106e0e:	83 ec 08             	sub    $0x8,%esp
80106e11:	57                   	push   %edi
80106e12:	ff 75 bc             	push   -0x44(%ebp)
80106e15:	e8 86 c5 ff ff       	call   801033a0 <nameiparent>
80106e1a:	83 c4 10             	add    $0x10,%esp
80106e1d:	89 c3                	mov    %eax,%ebx
80106e1f:	85 c0                	test   %eax,%eax
80106e21:	0f 84 19 01 00 00    	je     80106f40 <sys_move_file+0x1b0>
  {
    end_op();
    return -1;
  }

  if ((ip_src = dirlookup(dp_src, name, &off)) == 0)
80106e27:	83 ec 04             	sub    $0x4,%esp
80106e2a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106e2d:	50                   	push   %eax
80106e2e:	57                   	push   %edi
80106e2f:	53                   	push   %ebx
80106e30:	e8 8b c1 ff ff       	call   80102fc0 <dirlookup>
80106e35:	83 c4 10             	add    $0x10,%esp
80106e38:	89 c6                	mov    %eax,%esi
80106e3a:	85 c0                	test   %eax,%eax
80106e3c:	0f 84 fe 00 00 00    	je     80106f40 <sys_move_file+0x1b0>
  {
    end_op();
    return -1;
  }

  if ((dp_des = namei(path_des)) == 0)
80106e42:	83 ec 0c             	sub    $0xc,%esp
80106e45:	ff 75 c0             	push   -0x40(%ebp)
80106e48:	e8 33 c5 ff ff       	call   80103380 <namei>
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	85 c0                	test   %eax,%eax
80106e52:	0f 84 e8 00 00 00    	je     80106f40 <sys_move_file+0x1b0>
  {
    end_op();
    return -1;
  }

  ilock(dp_des);
80106e58:	83 ec 0c             	sub    $0xc,%esp
80106e5b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106e5e:	50                   	push   %eax
80106e5f:	e8 fc bb ff ff       	call   80102a60 <ilock>
  if (dp_des->dev != ip_src->dev || dirlink(dp_des, name, ip_src->inum) < 0)
80106e64:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80106e67:	8b 06                	mov    (%esi),%eax
80106e69:	83 c4 10             	add    $0x10,%esp
80106e6c:	39 02                	cmp    %eax,(%edx)
80106e6e:	75 70                	jne    80106ee0 <sys_move_file+0x150>
80106e70:	83 ec 04             	sub    $0x4,%esp
80106e73:	ff 76 04             	push   0x4(%esi)
80106e76:	57                   	push   %edi
80106e77:	52                   	push   %edx
80106e78:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80106e7b:	e8 40 c4 ff ff       	call   801032c0 <dirlink>
80106e80:	83 c4 10             	add    $0x10,%esp
80106e83:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80106e86:	85 c0                	test   %eax,%eax
80106e88:	78 56                	js     80106ee0 <sys_move_file+0x150>
  {
    iunlockput(dp_des);
    end_op();
    return -1;
  }
  iunlockput(dp_des);
80106e8a:	83 ec 0c             	sub    $0xc,%esp

  ilock(dp_src);

  memset(&de, 0, sizeof(de));
80106e8d:	8d 75 d8             	lea    -0x28(%ebp),%esi
  iunlockput(dp_des);
80106e90:	52                   	push   %edx
80106e91:	e8 5a be ff ff       	call   80102cf0 <iunlockput>
  ilock(dp_src);
80106e96:	89 1c 24             	mov    %ebx,(%esp)
80106e99:	e8 c2 bb ff ff       	call   80102a60 <ilock>
  memset(&de, 0, sizeof(de));
80106e9e:	83 c4 0c             	add    $0xc,%esp
80106ea1:	6a 10                	push   $0x10
80106ea3:	6a 00                	push   $0x0
80106ea5:	56                   	push   %esi
80106ea6:	e8 a5 ee ff ff       	call   80105d50 <memset>
  if (writei(dp_src, (char *)&de, off, sizeof(de)) != sizeof(de))
80106eab:	6a 10                	push   $0x10
80106ead:	ff 75 c4             	push   -0x3c(%ebp)
80106eb0:	56                   	push   %esi
80106eb1:	53                   	push   %ebx
80106eb2:	e8 b9 bf ff ff       	call   80102e70 <writei>
80106eb7:	83 c4 20             	add    $0x20,%esp
80106eba:	83 f8 10             	cmp    $0x10,%eax
80106ebd:	75 61                	jne    80106f20 <sys_move_file+0x190>
  {
    iunlockput(dp_src);
    end_op();
    return -1;
  }
  iunlockput(dp_src);
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	53                   	push   %ebx
80106ec3:	e8 28 be ff ff       	call   80102cf0 <iunlockput>

  end_op();
80106ec8:	e8 e3 d1 ff ff       	call   801040b0 <end_op>
  return 0;
80106ecd:	83 c4 10             	add    $0x10,%esp
80106ed0:	31 c0                	xor    %eax,%eax
80106ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp_des);
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	52                   	push   %edx
80106ee4:	e8 07 be ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106ee9:	e8 c2 d1 ff ff       	call   801040b0 <end_op>
    return -1;
80106eee:	83 c4 10             	add    $0x10,%esp
80106ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ef6:	eb da                	jmp    80106ed2 <sys_move_file+0x142>
80106ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eff:	90                   	nop
    cprintf("Error: Source is not a regular file\n");
80106f00:	83 ec 0c             	sub    $0xc,%esp
80106f03:	68 40 94 10 80       	push   $0x80109440
80106f08:	e8 d3 98 ff ff       	call   801007e0 <cprintf>
    return -1;
80106f0d:	83 c4 10             	add    $0x10,%esp
80106f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f15:	eb bb                	jmp    80106ed2 <sys_move_file+0x142>
80106f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1e:	66 90                	xchg   %ax,%ax
    iunlockput(dp_src);
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	53                   	push   %ebx
80106f24:	e8 c7 bd ff ff       	call   80102cf0 <iunlockput>
    end_op();
80106f29:	e8 82 d1 ff ff       	call   801040b0 <end_op>
    return -1;
80106f2e:	83 c4 10             	add    $0x10,%esp
80106f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f36:	eb 9a                	jmp    80106ed2 <sys_move_file+0x142>
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop
    end_op();
80106f40:	e8 6b d1 ff ff       	call   801040b0 <end_op>
    return -1;
80106f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f4a:	eb 86                	jmp    80106ed2 <sys_move_file+0x142>
    cprintf("Error: Source file not found\n");
80106f4c:	83 ec 0c             	sub    $0xc,%esp
80106f4f:	68 21 94 10 80       	push   $0x80109421
80106f54:	e8 87 98 ff ff       	call   801007e0 <cprintf>
    return -1;
80106f59:	83 c4 10             	add    $0x10,%esp
80106f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f61:	e9 6c ff ff ff       	jmp    80106ed2 <sys_move_file+0x142>
80106f66:	66 90                	xchg   %ax,%ax
80106f68:	66 90                	xchg   %ax,%ax
80106f6a:	66 90                	xchg   %ax,%ax
80106f6c:	66 90                	xchg   %ax,%ax
80106f6e:	66 90                	xchg   %ax,%ax

80106f70 <sys_fork>:

#define MAXPATH 1024 

int sys_fork(void)
{
  return fork();
80106f70:	e9 8b de ff ff       	jmp    80104e00 <fork>
80106f75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f80 <sys_exit>:
}

int sys_exit(void)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	83 ec 08             	sub    $0x8,%esp
  exit();
80106f86:	e8 f5 e0 ff ff       	call   80105080 <exit>
  return 0; // not reached
}
80106f8b:	31 c0                	xor    %eax,%eax
80106f8d:	c9                   	leave  
80106f8e:	c3                   	ret    
80106f8f:	90                   	nop

80106f90 <sys_wait>:

int sys_wait(void)
{
  return wait();
80106f90:	e9 1b e2 ff ff       	jmp    801051b0 <wait>
80106f95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <sys_kill>:
}

int sys_kill(void)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fa9:	50                   	push   %eax
80106faa:	6a 00                	push   $0x0
80106fac:	e8 5f f0 ff ff       	call   80106010 <argint>
80106fb1:	83 c4 10             	add    $0x10,%esp
80106fb4:	85 c0                	test   %eax,%eax
80106fb6:	78 18                	js     80106fd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106fb8:	83 ec 0c             	sub    $0xc,%esp
80106fbb:	ff 75 f4             	push   -0xc(%ebp)
80106fbe:	e8 8d e4 ff ff       	call   80105450 <kill>
80106fc3:	83 c4 10             	add    $0x10,%esp
}
80106fc6:	c9                   	leave  
80106fc7:	c3                   	ret    
80106fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcf:	90                   	nop
80106fd0:	c9                   	leave  
    return -1;
80106fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fd6:	c3                   	ret    
80106fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fde:	66 90                	xchg   %ax,%ax

80106fe0 <sys_getpid>:

int sys_getpid(void)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106fe6:	e8 75 dc ff ff       	call   80104c60 <myproc>
80106feb:	8b 40 10             	mov    0x10(%eax),%eax
}
80106fee:	c9                   	leave  
80106fef:	c3                   	ret    

80106ff0 <sys_sbrk>:

int sys_sbrk(void)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106ff7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80106ffa:	50                   	push   %eax
80106ffb:	6a 00                	push   $0x0
80106ffd:	e8 0e f0 ff ff       	call   80106010 <argint>
80107002:	83 c4 10             	add    $0x10,%esp
80107005:	85 c0                	test   %eax,%eax
80107007:	78 27                	js     80107030 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80107009:	e8 52 dc ff ff       	call   80104c60 <myproc>
  if (growproc(n) < 0)
8010700e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107011:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80107013:	ff 75 f4             	push   -0xc(%ebp)
80107016:	e8 65 dd ff ff       	call   80104d80 <growproc>
8010701b:	83 c4 10             	add    $0x10,%esp
8010701e:	85 c0                	test   %eax,%eax
80107020:	78 0e                	js     80107030 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80107022:	89 d8                	mov    %ebx,%eax
80107024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107027:	c9                   	leave  
80107028:	c3                   	ret    
80107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107030:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107035:	eb eb                	jmp    80107022 <sys_sbrk+0x32>
80107037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703e:	66 90                	xchg   %ax,%ax

80107040 <sys_sleep>:

int sys_sleep(void)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80107044:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107047:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010704a:	50                   	push   %eax
8010704b:	6a 00                	push   $0x0
8010704d:	e8 be ef ff ff       	call   80106010 <argint>
80107052:	83 c4 10             	add    $0x10,%esp
80107055:	85 c0                	test   %eax,%eax
80107057:	0f 88 8a 00 00 00    	js     801070e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010705d:	83 ec 0c             	sub    $0xc,%esp
80107060:	68 20 cd 11 80       	push   $0x8011cd20
80107065:	e8 26 ec ff ff       	call   80105c90 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010706a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010706d:	8b 1d 00 cd 11 80    	mov    0x8011cd00,%ebx
  while (ticks - ticks0 < n)
80107073:	83 c4 10             	add    $0x10,%esp
80107076:	85 d2                	test   %edx,%edx
80107078:	75 27                	jne    801070a1 <sys_sleep+0x61>
8010707a:	eb 54                	jmp    801070d0 <sys_sleep+0x90>
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107080:	83 ec 08             	sub    $0x8,%esp
80107083:	68 20 cd 11 80       	push   $0x8011cd20
80107088:	68 00 cd 11 80       	push   $0x8011cd00
8010708d:	e8 9e e2 ff ff       	call   80105330 <sleep>
  while (ticks - ticks0 < n)
80107092:	a1 00 cd 11 80       	mov    0x8011cd00,%eax
80107097:	83 c4 10             	add    $0x10,%esp
8010709a:	29 d8                	sub    %ebx,%eax
8010709c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010709f:	73 2f                	jae    801070d0 <sys_sleep+0x90>
    if (myproc()->killed)
801070a1:	e8 ba db ff ff       	call   80104c60 <myproc>
801070a6:	8b 40 24             	mov    0x24(%eax),%eax
801070a9:	85 c0                	test   %eax,%eax
801070ab:	74 d3                	je     80107080 <sys_sleep+0x40>
      release(&tickslock);
801070ad:	83 ec 0c             	sub    $0xc,%esp
801070b0:	68 20 cd 11 80       	push   $0x8011cd20
801070b5:	e8 76 eb ff ff       	call   80105c30 <release>
  }
  release(&tickslock);
  return 0;
}
801070ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801070bd:	83 c4 10             	add    $0x10,%esp
801070c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c5:	c9                   	leave  
801070c6:	c3                   	ret    
801070c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801070d0:	83 ec 0c             	sub    $0xc,%esp
801070d3:	68 20 cd 11 80       	push   $0x8011cd20
801070d8:	e8 53 eb ff ff       	call   80105c30 <release>
  return 0;
801070dd:	83 c4 10             	add    $0x10,%esp
801070e0:	31 c0                	xor    %eax,%eax
}
801070e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801070e5:	c9                   	leave  
801070e6:	c3                   	ret    
    return -1;
801070e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070ec:	eb f4                	jmp    801070e2 <sys_sleep+0xa2>
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	53                   	push   %ebx
801070f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801070f7:	68 20 cd 11 80       	push   $0x8011cd20
801070fc:	e8 8f eb ff ff       	call   80105c90 <acquire>
  xticks = ticks;
80107101:	8b 1d 00 cd 11 80    	mov    0x8011cd00,%ebx
  release(&tickslock);
80107107:	c7 04 24 20 cd 11 80 	movl   $0x8011cd20,(%esp)
8010710e:	e8 1d eb ff ff       	call   80105c30 <release>
  return xticks;
}
80107113:	89 d8                	mov    %ebx,%eax
80107115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107118:	c9                   	leave  
80107119:	c3                   	ret    
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107120 <sys_my_syscall>:
int sys_my_syscall(void)
{
  // This can be anything, such as printing a message
  // printf(1, "My system call was invoked!\n");
  return 0; // You can return any value, or multiple values
}
80107120:	31 c0                	xor    %eax,%eax
80107122:	c3                   	ret    
80107123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <sys_sort_syscalls>:


int sys_sort_syscalls()
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80107136:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107139:	50                   	push   %eax
8010713a:	6a 00                	push   $0x0
8010713c:	e8 cf ee ff ff       	call   80106010 <argint>
80107141:	83 c4 10             	add    $0x10,%esp
80107144:	85 c0                	test   %eax,%eax
80107146:	78 18                	js     80107160 <sys_sort_syscalls+0x30>
  {
    return -1; // Return error if pid is not provided
  }
  return sort_uniqe_procces(pid);
80107148:	83 ec 0c             	sub    $0xc,%esp
8010714b:	ff 75 f4             	push   -0xc(%ebp)
8010714e:	e8 3d e4 ff ff       	call   80105590 <sort_uniqe_procces>
80107153:	83 c4 10             	add    $0x10,%esp
} 
80107156:	c9                   	leave  
80107157:	c3                   	ret    
80107158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop
80107160:	c9                   	leave  
    return -1; // Return error if pid is not provided
80107161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
} 
80107166:	c3                   	ret    
80107167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716e:	66 90                	xchg   %ax,%ax

80107170 <sys_get_most_invoked_syscalls>:
int sys_get_most_invoked_syscalls()
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80107176:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107179:	50                   	push   %eax
8010717a:	6a 00                	push   $0x0
8010717c:	e8 8f ee ff ff       	call   80106010 <argint>
80107181:	83 c4 10             	add    $0x10,%esp
80107184:	85 c0                	test   %eax,%eax
80107186:	78 18                	js     801071a0 <sys_get_most_invoked_syscalls+0x30>
  {
    return -1; // Return error if pid is not provided
  }
  return get_max_invoked(pid);
80107188:	83 ec 0c             	sub    $0xc,%esp
8010718b:	ff 75 f4             	push   -0xc(%ebp)
8010718e:	e8 dd e4 ff ff       	call   80105670 <get_max_invoked>
80107193:	83 c4 10             	add    $0x10,%esp
} 
80107196:	c9                   	leave  
80107197:	c3                   	ret    
80107198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719f:	90                   	nop
801071a0:	c9                   	leave  
    return -1; // Return error if pid is not provided
801071a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
} 
801071a6:	c3                   	ret    
801071a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ae:	66 90                	xchg   %ax,%ax

801071b0 <sys_create_palindrom>:

int sys_create_palindrom(void){
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	83 ec 08             	sub    $0x8,%esp
  long long int num = myproc()->tf->ecx;
801071b6:	e8 a5 da ff ff       	call   80104c60 <myproc>
  return make_create_palindrom(num);
801071bb:	83 ec 08             	sub    $0x8,%esp
  long long int num = myproc()->tf->ecx;
801071be:	31 d2                	xor    %edx,%edx
801071c0:	8b 40 18             	mov    0x18(%eax),%eax
801071c3:	8b 40 18             	mov    0x18(%eax),%eax
  return make_create_palindrom(num);
801071c6:	52                   	push   %edx
801071c7:	50                   	push   %eax
801071c8:	e8 33 e6 ff ff       	call   80105800 <make_create_palindrom>
}
801071cd:	c9                   	leave  
801071ce:	c3                   	ret    
801071cf:	90                   	nop

801071d0 <sys_list_all_processes>:

int sys_list_all_processes(void)
{
   
801071d0:	c3                   	ret    

801071d1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801071d1:	1e                   	push   %ds
  pushl %es
801071d2:	06                   	push   %es
  pushl %fs
801071d3:	0f a0                	push   %fs
  pushl %gs
801071d5:	0f a8                	push   %gs
  pushal
801071d7:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801071d8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801071dc:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801071de:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801071e0:	54                   	push   %esp
  call trap
801071e1:	e8 ca 00 00 00       	call   801072b0 <trap>
  addl $4, %esp
801071e6:	83 c4 04             	add    $0x4,%esp

801071e9 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801071e9:	61                   	popa   
  popl %gs
801071ea:	0f a9                	pop    %gs
  popl %fs
801071ec:	0f a1                	pop    %fs
  popl %es
801071ee:	07                   	pop    %es
  popl %ds
801071ef:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801071f0:	83 c4 08             	add    $0x8,%esp
  iret
801071f3:	cf                   	iret   
801071f4:	66 90                	xchg   %ax,%ax
801071f6:	66 90                	xchg   %ax,%ax
801071f8:	66 90                	xchg   %ax,%ax
801071fa:	66 90                	xchg   %ax,%ax
801071fc:	66 90                	xchg   %ax,%ax
801071fe:	66 90                	xchg   %ax,%ax

80107200 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80107200:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80107201:	31 c0                	xor    %eax,%eax
{
80107203:	89 e5                	mov    %esp,%ebp
80107205:	83 ec 08             	sub    $0x8,%esp
80107208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80107210:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80107217:	c7 04 c5 62 cd 11 80 	movl   $0x8e000008,-0x7fee329e(,%eax,8)
8010721e:	08 00 00 8e 
80107222:	66 89 14 c5 60 cd 11 	mov    %dx,-0x7fee32a0(,%eax,8)
80107229:	80 
8010722a:	c1 ea 10             	shr    $0x10,%edx
8010722d:	66 89 14 c5 66 cd 11 	mov    %dx,-0x7fee329a(,%eax,8)
80107234:	80 
  for (i = 0; i < 256; i++)
80107235:	83 c0 01             	add    $0x1,%eax
80107238:	3d 00 01 00 00       	cmp    $0x100,%eax
8010723d:	75 d1                	jne    80107210 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010723f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80107242:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107247:	c7 05 62 cf 11 80 08 	movl   $0xef000008,0x8011cf62
8010724e:	00 00 ef 
  initlock(&tickslock, "time");
80107251:	68 65 94 10 80       	push   $0x80109465
80107256:	68 20 cd 11 80       	push   $0x8011cd20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010725b:	66 a3 60 cf 11 80    	mov    %ax,0x8011cf60
80107261:	c1 e8 10             	shr    $0x10,%eax
80107264:	66 a3 66 cf 11 80    	mov    %ax,0x8011cf66
  initlock(&tickslock, "time");
8010726a:	e8 51 e8 ff ff       	call   80105ac0 <initlock>
}
8010726f:	83 c4 10             	add    $0x10,%esp
80107272:	c9                   	leave  
80107273:	c3                   	ret    
80107274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop

80107280 <idtinit>:

void idtinit(void)
{
80107280:	55                   	push   %ebp
  pd[0] = size-1;
80107281:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107286:	89 e5                	mov    %esp,%ebp
80107288:	83 ec 10             	sub    $0x10,%esp
8010728b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010728f:	b8 60 cd 11 80       	mov    $0x8011cd60,%eax
80107294:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107298:	c1 e8 10             	shr    $0x10,%eax
8010729b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010729f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801072a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801072a5:	c9                   	leave  
801072a6:	c3                   	ret    
801072a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ae:	66 90                	xchg   %ax,%ax

801072b0 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 1c             	sub    $0x1c,%esp
801072b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
801072bc:	8b 43 30             	mov    0x30(%ebx),%eax
801072bf:	83 f8 40             	cmp    $0x40,%eax
801072c2:	0f 84 68 01 00 00    	je     80107430 <trap+0x180>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
801072c8:	83 e8 20             	sub    $0x20,%eax
801072cb:	83 f8 1f             	cmp    $0x1f,%eax
801072ce:	0f 87 8c 00 00 00    	ja     80107360 <trap+0xb0>
801072d4:	ff 24 85 0c 95 10 80 	jmp    *-0x7fef6af4(,%eax,4)
801072db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072df:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801072e0:	e8 3b c2 ff ff       	call   80103520 <ideintr>
    lapiceoi();
801072e5:	e8 06 c9 ff ff       	call   80103bf0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801072ea:	e8 71 d9 ff ff       	call   80104c60 <myproc>
801072ef:	85 c0                	test   %eax,%eax
801072f1:	74 1d                	je     80107310 <trap+0x60>
801072f3:	e8 68 d9 ff ff       	call   80104c60 <myproc>
801072f8:	8b 50 24             	mov    0x24(%eax),%edx
801072fb:	85 d2                	test   %edx,%edx
801072fd:	74 11                	je     80107310 <trap+0x60>
801072ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107303:	83 e0 03             	and    $0x3,%eax
80107306:	66 83 f8 03          	cmp    $0x3,%ax
8010730a:	0f 84 f8 01 00 00    	je     80107508 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
80107310:	e8 4b d9 ff ff       	call   80104c60 <myproc>
80107315:	85 c0                	test   %eax,%eax
80107317:	74 0f                	je     80107328 <trap+0x78>
80107319:	e8 42 d9 ff ff       	call   80104c60 <myproc>
8010731e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107322:	0f 84 b8 00 00 00    	je     801073e0 <trap+0x130>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107328:	e8 33 d9 ff ff       	call   80104c60 <myproc>
8010732d:	85 c0                	test   %eax,%eax
8010732f:	74 1d                	je     8010734e <trap+0x9e>
80107331:	e8 2a d9 ff ff       	call   80104c60 <myproc>
80107336:	8b 40 24             	mov    0x24(%eax),%eax
80107339:	85 c0                	test   %eax,%eax
8010733b:	74 11                	je     8010734e <trap+0x9e>
8010733d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107341:	83 e0 03             	and    $0x3,%eax
80107344:	66 83 f8 03          	cmp    $0x3,%ax
80107348:	0f 84 21 01 00 00    	je     8010746f <trap+0x1bf>
    exit();
}
8010734e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107351:	5b                   	pop    %ebx
80107352:	5e                   	pop    %esi
80107353:	5f                   	pop    %edi
80107354:	5d                   	pop    %ebp
80107355:	c3                   	ret    
80107356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() == 0 || (tf->cs & 3) == 0)
80107360:	e8 fb d8 ff ff       	call   80104c60 <myproc>
80107365:	8b 7b 38             	mov    0x38(%ebx),%edi
80107368:	85 c0                	test   %eax,%eax
8010736a:	0f 84 df 01 00 00    	je     8010754f <trap+0x29f>
80107370:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107374:	0f 84 d5 01 00 00    	je     8010754f <trap+0x29f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010737a:	0f 20 d1             	mov    %cr2,%ecx
8010737d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107380:	e8 bb d8 ff ff       	call   80104c40 <cpuid>
80107385:	8b 73 30             	mov    0x30(%ebx),%esi
80107388:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010738b:	8b 43 34             	mov    0x34(%ebx),%eax
8010738e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107391:	e8 ca d8 ff ff       	call   80104c60 <myproc>
80107396:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107399:	e8 c2 d8 ff ff       	call   80104c60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010739e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801073a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801073a4:	51                   	push   %ecx
801073a5:	57                   	push   %edi
801073a6:	52                   	push   %edx
801073a7:	ff 75 e4             	push   -0x1c(%ebp)
801073aa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801073ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
801073ae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801073b1:	56                   	push   %esi
801073b2:	ff 70 10             	push   0x10(%eax)
801073b5:	68 c8 94 10 80       	push   $0x801094c8
801073ba:	e8 21 94 ff ff       	call   801007e0 <cprintf>
    myproc()->killed = 1;
801073bf:	83 c4 20             	add    $0x20,%esp
801073c2:	e8 99 d8 ff ff       	call   80104c60 <myproc>
801073c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801073ce:	e8 8d d8 ff ff       	call   80104c60 <myproc>
801073d3:	85 c0                	test   %eax,%eax
801073d5:	0f 85 18 ff ff ff    	jne    801072f3 <trap+0x43>
801073db:	e9 30 ff ff ff       	jmp    80107310 <trap+0x60>
  if (myproc() && myproc()->state == RUNNING &&
801073e0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801073e4:	0f 85 3e ff ff ff    	jne    80107328 <trap+0x78>
    yield();
801073ea:	e8 f1 de ff ff       	call   801052e0 <yield>
801073ef:	e9 34 ff ff ff       	jmp    80107328 <trap+0x78>
801073f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801073f8:	8b 7b 38             	mov    0x38(%ebx),%edi
801073fb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801073ff:	e8 3c d8 ff ff       	call   80104c40 <cpuid>
80107404:	57                   	push   %edi
80107405:	56                   	push   %esi
80107406:	50                   	push   %eax
80107407:	68 70 94 10 80       	push   $0x80109470
8010740c:	e8 cf 93 ff ff       	call   801007e0 <cprintf>
    lapiceoi();
80107411:	e8 da c7 ff ff       	call   80103bf0 <lapiceoi>
    break;
80107416:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107419:	e8 42 d8 ff ff       	call   80104c60 <myproc>
8010741e:	85 c0                	test   %eax,%eax
80107420:	0f 85 cd fe ff ff    	jne    801072f3 <trap+0x43>
80107426:	e9 e5 fe ff ff       	jmp    80107310 <trap+0x60>
8010742b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010742f:	90                   	nop
    if (myproc()->killed)
80107430:	e8 2b d8 ff ff       	call   80104c60 <myproc>
80107435:	8b 70 24             	mov    0x24(%eax),%esi
80107438:	85 f6                	test   %esi,%esi
8010743a:	0f 85 d8 00 00 00    	jne    80107518 <trap+0x268>
    if (myproc()->numsystemcalls < 100)
80107440:	e8 1b d8 ff ff       	call   80104c60 <myproc>
80107445:	83 b8 0c 02 00 00 63 	cmpl   $0x63,0x20c(%eax)
8010744c:	0f 8e d6 00 00 00    	jle    80107528 <trap+0x278>
    myproc()->tf = tf;
80107452:	e8 09 d8 ff ff       	call   80104c60 <myproc>
80107457:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010745a:	e8 f1 ec ff ff       	call   80106150 <syscall>
    if (myproc()->killed)
8010745f:	e8 fc d7 ff ff       	call   80104c60 <myproc>
80107464:	8b 48 24             	mov    0x24(%eax),%ecx
80107467:	85 c9                	test   %ecx,%ecx
80107469:	0f 84 df fe ff ff    	je     8010734e <trap+0x9e>
}
8010746f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107472:	5b                   	pop    %ebx
80107473:	5e                   	pop    %esi
80107474:	5f                   	pop    %edi
80107475:	5d                   	pop    %ebp
      exit();
80107476:	e9 05 dc ff ff       	jmp    80105080 <exit>
8010747b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010747f:	90                   	nop
    uartintr();
80107480:	e8 6b 02 00 00       	call   801076f0 <uartintr>
    lapiceoi();
80107485:	e8 66 c7 ff ff       	call   80103bf0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010748a:	e8 d1 d7 ff ff       	call   80104c60 <myproc>
8010748f:	85 c0                	test   %eax,%eax
80107491:	0f 85 5c fe ff ff    	jne    801072f3 <trap+0x43>
80107497:	e9 74 fe ff ff       	jmp    80107310 <trap+0x60>
8010749c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801074a0:	e8 0b c6 ff ff       	call   80103ab0 <kbdintr>
    lapiceoi();
801074a5:	e8 46 c7 ff ff       	call   80103bf0 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801074aa:	e8 b1 d7 ff ff       	call   80104c60 <myproc>
801074af:	85 c0                	test   %eax,%eax
801074b1:	0f 85 3c fe ff ff    	jne    801072f3 <trap+0x43>
801074b7:	e9 54 fe ff ff       	jmp    80107310 <trap+0x60>
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpuid() == 0)
801074c0:	e8 7b d7 ff ff       	call   80104c40 <cpuid>
801074c5:	85 c0                	test   %eax,%eax
801074c7:	0f 85 18 fe ff ff    	jne    801072e5 <trap+0x35>
      acquire(&tickslock);
801074cd:	83 ec 0c             	sub    $0xc,%esp
801074d0:	68 20 cd 11 80       	push   $0x8011cd20
801074d5:	e8 b6 e7 ff ff       	call   80105c90 <acquire>
      wakeup(&ticks);
801074da:	c7 04 24 00 cd 11 80 	movl   $0x8011cd00,(%esp)
      ticks++;
801074e1:	83 05 00 cd 11 80 01 	addl   $0x1,0x8011cd00
      wakeup(&ticks);
801074e8:	e8 03 df ff ff       	call   801053f0 <wakeup>
      release(&tickslock);
801074ed:	c7 04 24 20 cd 11 80 	movl   $0x8011cd20,(%esp)
801074f4:	e8 37 e7 ff ff       	call   80105c30 <release>
801074f9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801074fc:	e9 e4 fd ff ff       	jmp    801072e5 <trap+0x35>
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107508:	e8 73 db ff ff       	call   80105080 <exit>
8010750d:	e9 fe fd ff ff       	jmp    80107310 <trap+0x60>
80107512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107518:	e8 63 db ff ff       	call   80105080 <exit>
8010751d:	e9 1e ff ff ff       	jmp    80107440 <trap+0x190>
80107522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      myproc()->systemcalls[myproc()->numsystemcalls++] = tf->eax;
80107528:	8b 7b 1c             	mov    0x1c(%ebx),%edi
8010752b:	e8 30 d7 ff ff       	call   80104c60 <myproc>
80107530:	89 c6                	mov    %eax,%esi
80107532:	e8 29 d7 ff ff       	call   80104c60 <myproc>
80107537:	8b 90 0c 02 00 00    	mov    0x20c(%eax),%edx
8010753d:	8d 4a 01             	lea    0x1(%edx),%ecx
80107540:	89 88 0c 02 00 00    	mov    %ecx,0x20c(%eax)
80107546:	89 7c 96 7c          	mov    %edi,0x7c(%esi,%edx,4)
8010754a:	e9 03 ff ff ff       	jmp    80107452 <trap+0x1a2>
8010754f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107552:	e8 e9 d6 ff ff       	call   80104c40 <cpuid>
80107557:	83 ec 0c             	sub    $0xc,%esp
8010755a:	56                   	push   %esi
8010755b:	57                   	push   %edi
8010755c:	50                   	push   %eax
8010755d:	ff 73 30             	push   0x30(%ebx)
80107560:	68 94 94 10 80       	push   $0x80109494
80107565:	e8 76 92 ff ff       	call   801007e0 <cprintf>
      panic("trap");
8010756a:	83 c4 14             	add    $0x14,%esp
8010756d:	68 6a 94 10 80       	push   $0x8010946a
80107572:	e8 e9 8e ff ff       	call   80100460 <panic>
80107577:	66 90                	xchg   %ax,%ax
80107579:	66 90                	xchg   %ax,%ax
8010757b:	66 90                	xchg   %ax,%ax
8010757d:	66 90                	xchg   %ax,%ax
8010757f:	90                   	nop

80107580 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107580:	a1 60 d5 11 80       	mov    0x8011d560,%eax
80107585:	85 c0                	test   %eax,%eax
80107587:	74 17                	je     801075a0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107589:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010758e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010758f:	a8 01                	test   $0x1,%al
80107591:	74 0d                	je     801075a0 <uartgetc+0x20>
80107593:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107598:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107599:	0f b6 c0             	movzbl %al,%eax
8010759c:	c3                   	ret    
8010759d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801075a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075a5:	c3                   	ret    
801075a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ad:	8d 76 00             	lea    0x0(%esi),%esi

801075b0 <uartinit>:
{
801075b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801075b1:	31 c9                	xor    %ecx,%ecx
801075b3:	89 c8                	mov    %ecx,%eax
801075b5:	89 e5                	mov    %esp,%ebp
801075b7:	57                   	push   %edi
801075b8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801075bd:	56                   	push   %esi
801075be:	89 fa                	mov    %edi,%edx
801075c0:	53                   	push   %ebx
801075c1:	83 ec 1c             	sub    $0x1c,%esp
801075c4:	ee                   	out    %al,(%dx)
801075c5:	be fb 03 00 00       	mov    $0x3fb,%esi
801075ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801075cf:	89 f2                	mov    %esi,%edx
801075d1:	ee                   	out    %al,(%dx)
801075d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801075d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801075dc:	ee                   	out    %al,(%dx)
801075dd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801075e2:	89 c8                	mov    %ecx,%eax
801075e4:	89 da                	mov    %ebx,%edx
801075e6:	ee                   	out    %al,(%dx)
801075e7:	b8 03 00 00 00       	mov    $0x3,%eax
801075ec:	89 f2                	mov    %esi,%edx
801075ee:	ee                   	out    %al,(%dx)
801075ef:	ba fc 03 00 00       	mov    $0x3fc,%edx
801075f4:	89 c8                	mov    %ecx,%eax
801075f6:	ee                   	out    %al,(%dx)
801075f7:	b8 01 00 00 00       	mov    $0x1,%eax
801075fc:	89 da                	mov    %ebx,%edx
801075fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801075ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107604:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107605:	3c ff                	cmp    $0xff,%al
80107607:	74 78                	je     80107681 <uartinit+0xd1>
  uart = 1;
80107609:	c7 05 60 d5 11 80 01 	movl   $0x1,0x8011d560
80107610:	00 00 00 
80107613:	89 fa                	mov    %edi,%edx
80107615:	ec                   	in     (%dx),%al
80107616:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010761b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010761c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010761f:	bf 8c 95 10 80       	mov    $0x8010958c,%edi
80107624:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107629:	6a 00                	push   $0x0
8010762b:	6a 04                	push   $0x4
8010762d:	e8 2e c1 ff ff       	call   80103760 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107632:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107636:	83 c4 10             	add    $0x10,%esp
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80107640:	a1 60 d5 11 80       	mov    0x8011d560,%eax
80107645:	bb 80 00 00 00       	mov    $0x80,%ebx
8010764a:	85 c0                	test   %eax,%eax
8010764c:	75 14                	jne    80107662 <uartinit+0xb2>
8010764e:	eb 23                	jmp    80107673 <uartinit+0xc3>
    microdelay(10);
80107650:	83 ec 0c             	sub    $0xc,%esp
80107653:	6a 0a                	push   $0xa
80107655:	e8 b6 c5 ff ff       	call   80103c10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010765a:	83 c4 10             	add    $0x10,%esp
8010765d:	83 eb 01             	sub    $0x1,%ebx
80107660:	74 07                	je     80107669 <uartinit+0xb9>
80107662:	89 f2                	mov    %esi,%edx
80107664:	ec                   	in     (%dx),%al
80107665:	a8 20                	test   $0x20,%al
80107667:	74 e7                	je     80107650 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107669:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010766d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107672:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107673:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107677:	83 c7 01             	add    $0x1,%edi
8010767a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010767d:	84 c0                	test   %al,%al
8010767f:	75 bf                	jne    80107640 <uartinit+0x90>
}
80107681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107684:	5b                   	pop    %ebx
80107685:	5e                   	pop    %esi
80107686:	5f                   	pop    %edi
80107687:	5d                   	pop    %ebp
80107688:	c3                   	ret    
80107689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107690 <uartputc>:
  if(!uart)
80107690:	a1 60 d5 11 80       	mov    0x8011d560,%eax
80107695:	85 c0                	test   %eax,%eax
80107697:	74 47                	je     801076e0 <uartputc+0x50>
{
80107699:	55                   	push   %ebp
8010769a:	89 e5                	mov    %esp,%ebp
8010769c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010769d:	be fd 03 00 00       	mov    $0x3fd,%esi
801076a2:	53                   	push   %ebx
801076a3:	bb 80 00 00 00       	mov    $0x80,%ebx
801076a8:	eb 18                	jmp    801076c2 <uartputc+0x32>
801076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801076b0:	83 ec 0c             	sub    $0xc,%esp
801076b3:	6a 0a                	push   $0xa
801076b5:	e8 56 c5 ff ff       	call   80103c10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801076ba:	83 c4 10             	add    $0x10,%esp
801076bd:	83 eb 01             	sub    $0x1,%ebx
801076c0:	74 07                	je     801076c9 <uartputc+0x39>
801076c2:	89 f2                	mov    %esi,%edx
801076c4:	ec                   	in     (%dx),%al
801076c5:	a8 20                	test   $0x20,%al
801076c7:	74 e7                	je     801076b0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801076c9:	8b 45 08             	mov    0x8(%ebp),%eax
801076cc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801076d1:	ee                   	out    %al,(%dx)
}
801076d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5d                   	pop    %ebp
801076d8:	c3                   	ret    
801076d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076e0:	c3                   	ret    
801076e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ef:	90                   	nop

801076f0 <uartintr>:

void
uartintr(void)
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801076f6:	68 80 75 10 80       	push   $0x80107580
801076fb:	e8 40 a0 ff ff       	call   80101740 <consoleintr>
}
80107700:	83 c4 10             	add    $0x10,%esp
80107703:	c9                   	leave  
80107704:	c3                   	ret    

80107705 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $0
80107707:	6a 00                	push   $0x0
  jmp alltraps
80107709:	e9 c3 fa ff ff       	jmp    801071d1 <alltraps>

8010770e <vector1>:
.globl vector1
vector1:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $1
80107710:	6a 01                	push   $0x1
  jmp alltraps
80107712:	e9 ba fa ff ff       	jmp    801071d1 <alltraps>

80107717 <vector2>:
.globl vector2
vector2:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $2
80107719:	6a 02                	push   $0x2
  jmp alltraps
8010771b:	e9 b1 fa ff ff       	jmp    801071d1 <alltraps>

80107720 <vector3>:
.globl vector3
vector3:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $3
80107722:	6a 03                	push   $0x3
  jmp alltraps
80107724:	e9 a8 fa ff ff       	jmp    801071d1 <alltraps>

80107729 <vector4>:
.globl vector4
vector4:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $4
8010772b:	6a 04                	push   $0x4
  jmp alltraps
8010772d:	e9 9f fa ff ff       	jmp    801071d1 <alltraps>

80107732 <vector5>:
.globl vector5
vector5:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $5
80107734:	6a 05                	push   $0x5
  jmp alltraps
80107736:	e9 96 fa ff ff       	jmp    801071d1 <alltraps>

8010773b <vector6>:
.globl vector6
vector6:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $6
8010773d:	6a 06                	push   $0x6
  jmp alltraps
8010773f:	e9 8d fa ff ff       	jmp    801071d1 <alltraps>

80107744 <vector7>:
.globl vector7
vector7:
  pushl $0
80107744:	6a 00                	push   $0x0
  pushl $7
80107746:	6a 07                	push   $0x7
  jmp alltraps
80107748:	e9 84 fa ff ff       	jmp    801071d1 <alltraps>

8010774d <vector8>:
.globl vector8
vector8:
  pushl $8
8010774d:	6a 08                	push   $0x8
  jmp alltraps
8010774f:	e9 7d fa ff ff       	jmp    801071d1 <alltraps>

80107754 <vector9>:
.globl vector9
vector9:
  pushl $0
80107754:	6a 00                	push   $0x0
  pushl $9
80107756:	6a 09                	push   $0x9
  jmp alltraps
80107758:	e9 74 fa ff ff       	jmp    801071d1 <alltraps>

8010775d <vector10>:
.globl vector10
vector10:
  pushl $10
8010775d:	6a 0a                	push   $0xa
  jmp alltraps
8010775f:	e9 6d fa ff ff       	jmp    801071d1 <alltraps>

80107764 <vector11>:
.globl vector11
vector11:
  pushl $11
80107764:	6a 0b                	push   $0xb
  jmp alltraps
80107766:	e9 66 fa ff ff       	jmp    801071d1 <alltraps>

8010776b <vector12>:
.globl vector12
vector12:
  pushl $12
8010776b:	6a 0c                	push   $0xc
  jmp alltraps
8010776d:	e9 5f fa ff ff       	jmp    801071d1 <alltraps>

80107772 <vector13>:
.globl vector13
vector13:
  pushl $13
80107772:	6a 0d                	push   $0xd
  jmp alltraps
80107774:	e9 58 fa ff ff       	jmp    801071d1 <alltraps>

80107779 <vector14>:
.globl vector14
vector14:
  pushl $14
80107779:	6a 0e                	push   $0xe
  jmp alltraps
8010777b:	e9 51 fa ff ff       	jmp    801071d1 <alltraps>

80107780 <vector15>:
.globl vector15
vector15:
  pushl $0
80107780:	6a 00                	push   $0x0
  pushl $15
80107782:	6a 0f                	push   $0xf
  jmp alltraps
80107784:	e9 48 fa ff ff       	jmp    801071d1 <alltraps>

80107789 <vector16>:
.globl vector16
vector16:
  pushl $0
80107789:	6a 00                	push   $0x0
  pushl $16
8010778b:	6a 10                	push   $0x10
  jmp alltraps
8010778d:	e9 3f fa ff ff       	jmp    801071d1 <alltraps>

80107792 <vector17>:
.globl vector17
vector17:
  pushl $17
80107792:	6a 11                	push   $0x11
  jmp alltraps
80107794:	e9 38 fa ff ff       	jmp    801071d1 <alltraps>

80107799 <vector18>:
.globl vector18
vector18:
  pushl $0
80107799:	6a 00                	push   $0x0
  pushl $18
8010779b:	6a 12                	push   $0x12
  jmp alltraps
8010779d:	e9 2f fa ff ff       	jmp    801071d1 <alltraps>

801077a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801077a2:	6a 00                	push   $0x0
  pushl $19
801077a4:	6a 13                	push   $0x13
  jmp alltraps
801077a6:	e9 26 fa ff ff       	jmp    801071d1 <alltraps>

801077ab <vector20>:
.globl vector20
vector20:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $20
801077ad:	6a 14                	push   $0x14
  jmp alltraps
801077af:	e9 1d fa ff ff       	jmp    801071d1 <alltraps>

801077b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801077b4:	6a 00                	push   $0x0
  pushl $21
801077b6:	6a 15                	push   $0x15
  jmp alltraps
801077b8:	e9 14 fa ff ff       	jmp    801071d1 <alltraps>

801077bd <vector22>:
.globl vector22
vector22:
  pushl $0
801077bd:	6a 00                	push   $0x0
  pushl $22
801077bf:	6a 16                	push   $0x16
  jmp alltraps
801077c1:	e9 0b fa ff ff       	jmp    801071d1 <alltraps>

801077c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801077c6:	6a 00                	push   $0x0
  pushl $23
801077c8:	6a 17                	push   $0x17
  jmp alltraps
801077ca:	e9 02 fa ff ff       	jmp    801071d1 <alltraps>

801077cf <vector24>:
.globl vector24
vector24:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $24
801077d1:	6a 18                	push   $0x18
  jmp alltraps
801077d3:	e9 f9 f9 ff ff       	jmp    801071d1 <alltraps>

801077d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801077d8:	6a 00                	push   $0x0
  pushl $25
801077da:	6a 19                	push   $0x19
  jmp alltraps
801077dc:	e9 f0 f9 ff ff       	jmp    801071d1 <alltraps>

801077e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $26
801077e3:	6a 1a                	push   $0x1a
  jmp alltraps
801077e5:	e9 e7 f9 ff ff       	jmp    801071d1 <alltraps>

801077ea <vector27>:
.globl vector27
vector27:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $27
801077ec:	6a 1b                	push   $0x1b
  jmp alltraps
801077ee:	e9 de f9 ff ff       	jmp    801071d1 <alltraps>

801077f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $28
801077f5:	6a 1c                	push   $0x1c
  jmp alltraps
801077f7:	e9 d5 f9 ff ff       	jmp    801071d1 <alltraps>

801077fc <vector29>:
.globl vector29
vector29:
  pushl $0
801077fc:	6a 00                	push   $0x0
  pushl $29
801077fe:	6a 1d                	push   $0x1d
  jmp alltraps
80107800:	e9 cc f9 ff ff       	jmp    801071d1 <alltraps>

80107805 <vector30>:
.globl vector30
vector30:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $30
80107807:	6a 1e                	push   $0x1e
  jmp alltraps
80107809:	e9 c3 f9 ff ff       	jmp    801071d1 <alltraps>

8010780e <vector31>:
.globl vector31
vector31:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $31
80107810:	6a 1f                	push   $0x1f
  jmp alltraps
80107812:	e9 ba f9 ff ff       	jmp    801071d1 <alltraps>

80107817 <vector32>:
.globl vector32
vector32:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $32
80107819:	6a 20                	push   $0x20
  jmp alltraps
8010781b:	e9 b1 f9 ff ff       	jmp    801071d1 <alltraps>

80107820 <vector33>:
.globl vector33
vector33:
  pushl $0
80107820:	6a 00                	push   $0x0
  pushl $33
80107822:	6a 21                	push   $0x21
  jmp alltraps
80107824:	e9 a8 f9 ff ff       	jmp    801071d1 <alltraps>

80107829 <vector34>:
.globl vector34
vector34:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $34
8010782b:	6a 22                	push   $0x22
  jmp alltraps
8010782d:	e9 9f f9 ff ff       	jmp    801071d1 <alltraps>

80107832 <vector35>:
.globl vector35
vector35:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $35
80107834:	6a 23                	push   $0x23
  jmp alltraps
80107836:	e9 96 f9 ff ff       	jmp    801071d1 <alltraps>

8010783b <vector36>:
.globl vector36
vector36:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $36
8010783d:	6a 24                	push   $0x24
  jmp alltraps
8010783f:	e9 8d f9 ff ff       	jmp    801071d1 <alltraps>

80107844 <vector37>:
.globl vector37
vector37:
  pushl $0
80107844:	6a 00                	push   $0x0
  pushl $37
80107846:	6a 25                	push   $0x25
  jmp alltraps
80107848:	e9 84 f9 ff ff       	jmp    801071d1 <alltraps>

8010784d <vector38>:
.globl vector38
vector38:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $38
8010784f:	6a 26                	push   $0x26
  jmp alltraps
80107851:	e9 7b f9 ff ff       	jmp    801071d1 <alltraps>

80107856 <vector39>:
.globl vector39
vector39:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $39
80107858:	6a 27                	push   $0x27
  jmp alltraps
8010785a:	e9 72 f9 ff ff       	jmp    801071d1 <alltraps>

8010785f <vector40>:
.globl vector40
vector40:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $40
80107861:	6a 28                	push   $0x28
  jmp alltraps
80107863:	e9 69 f9 ff ff       	jmp    801071d1 <alltraps>

80107868 <vector41>:
.globl vector41
vector41:
  pushl $0
80107868:	6a 00                	push   $0x0
  pushl $41
8010786a:	6a 29                	push   $0x29
  jmp alltraps
8010786c:	e9 60 f9 ff ff       	jmp    801071d1 <alltraps>

80107871 <vector42>:
.globl vector42
vector42:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $42
80107873:	6a 2a                	push   $0x2a
  jmp alltraps
80107875:	e9 57 f9 ff ff       	jmp    801071d1 <alltraps>

8010787a <vector43>:
.globl vector43
vector43:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $43
8010787c:	6a 2b                	push   $0x2b
  jmp alltraps
8010787e:	e9 4e f9 ff ff       	jmp    801071d1 <alltraps>

80107883 <vector44>:
.globl vector44
vector44:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $44
80107885:	6a 2c                	push   $0x2c
  jmp alltraps
80107887:	e9 45 f9 ff ff       	jmp    801071d1 <alltraps>

8010788c <vector45>:
.globl vector45
vector45:
  pushl $0
8010788c:	6a 00                	push   $0x0
  pushl $45
8010788e:	6a 2d                	push   $0x2d
  jmp alltraps
80107890:	e9 3c f9 ff ff       	jmp    801071d1 <alltraps>

80107895 <vector46>:
.globl vector46
vector46:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $46
80107897:	6a 2e                	push   $0x2e
  jmp alltraps
80107899:	e9 33 f9 ff ff       	jmp    801071d1 <alltraps>

8010789e <vector47>:
.globl vector47
vector47:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $47
801078a0:	6a 2f                	push   $0x2f
  jmp alltraps
801078a2:	e9 2a f9 ff ff       	jmp    801071d1 <alltraps>

801078a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $48
801078a9:	6a 30                	push   $0x30
  jmp alltraps
801078ab:	e9 21 f9 ff ff       	jmp    801071d1 <alltraps>

801078b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801078b0:	6a 00                	push   $0x0
  pushl $49
801078b2:	6a 31                	push   $0x31
  jmp alltraps
801078b4:	e9 18 f9 ff ff       	jmp    801071d1 <alltraps>

801078b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $50
801078bb:	6a 32                	push   $0x32
  jmp alltraps
801078bd:	e9 0f f9 ff ff       	jmp    801071d1 <alltraps>

801078c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $51
801078c4:	6a 33                	push   $0x33
  jmp alltraps
801078c6:	e9 06 f9 ff ff       	jmp    801071d1 <alltraps>

801078cb <vector52>:
.globl vector52
vector52:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $52
801078cd:	6a 34                	push   $0x34
  jmp alltraps
801078cf:	e9 fd f8 ff ff       	jmp    801071d1 <alltraps>

801078d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $53
801078d6:	6a 35                	push   $0x35
  jmp alltraps
801078d8:	e9 f4 f8 ff ff       	jmp    801071d1 <alltraps>

801078dd <vector54>:
.globl vector54
vector54:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $54
801078df:	6a 36                	push   $0x36
  jmp alltraps
801078e1:	e9 eb f8 ff ff       	jmp    801071d1 <alltraps>

801078e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $55
801078e8:	6a 37                	push   $0x37
  jmp alltraps
801078ea:	e9 e2 f8 ff ff       	jmp    801071d1 <alltraps>

801078ef <vector56>:
.globl vector56
vector56:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $56
801078f1:	6a 38                	push   $0x38
  jmp alltraps
801078f3:	e9 d9 f8 ff ff       	jmp    801071d1 <alltraps>

801078f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $57
801078fa:	6a 39                	push   $0x39
  jmp alltraps
801078fc:	e9 d0 f8 ff ff       	jmp    801071d1 <alltraps>

80107901 <vector58>:
.globl vector58
vector58:
  pushl $0
80107901:	6a 00                	push   $0x0
  pushl $58
80107903:	6a 3a                	push   $0x3a
  jmp alltraps
80107905:	e9 c7 f8 ff ff       	jmp    801071d1 <alltraps>

8010790a <vector59>:
.globl vector59
vector59:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $59
8010790c:	6a 3b                	push   $0x3b
  jmp alltraps
8010790e:	e9 be f8 ff ff       	jmp    801071d1 <alltraps>

80107913 <vector60>:
.globl vector60
vector60:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $60
80107915:	6a 3c                	push   $0x3c
  jmp alltraps
80107917:	e9 b5 f8 ff ff       	jmp    801071d1 <alltraps>

8010791c <vector61>:
.globl vector61
vector61:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $61
8010791e:	6a 3d                	push   $0x3d
  jmp alltraps
80107920:	e9 ac f8 ff ff       	jmp    801071d1 <alltraps>

80107925 <vector62>:
.globl vector62
vector62:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $62
80107927:	6a 3e                	push   $0x3e
  jmp alltraps
80107929:	e9 a3 f8 ff ff       	jmp    801071d1 <alltraps>

8010792e <vector63>:
.globl vector63
vector63:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $63
80107930:	6a 3f                	push   $0x3f
  jmp alltraps
80107932:	e9 9a f8 ff ff       	jmp    801071d1 <alltraps>

80107937 <vector64>:
.globl vector64
vector64:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $64
80107939:	6a 40                	push   $0x40
  jmp alltraps
8010793b:	e9 91 f8 ff ff       	jmp    801071d1 <alltraps>

80107940 <vector65>:
.globl vector65
vector65:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $65
80107942:	6a 41                	push   $0x41
  jmp alltraps
80107944:	e9 88 f8 ff ff       	jmp    801071d1 <alltraps>

80107949 <vector66>:
.globl vector66
vector66:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $66
8010794b:	6a 42                	push   $0x42
  jmp alltraps
8010794d:	e9 7f f8 ff ff       	jmp    801071d1 <alltraps>

80107952 <vector67>:
.globl vector67
vector67:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $67
80107954:	6a 43                	push   $0x43
  jmp alltraps
80107956:	e9 76 f8 ff ff       	jmp    801071d1 <alltraps>

8010795b <vector68>:
.globl vector68
vector68:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $68
8010795d:	6a 44                	push   $0x44
  jmp alltraps
8010795f:	e9 6d f8 ff ff       	jmp    801071d1 <alltraps>

80107964 <vector69>:
.globl vector69
vector69:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $69
80107966:	6a 45                	push   $0x45
  jmp alltraps
80107968:	e9 64 f8 ff ff       	jmp    801071d1 <alltraps>

8010796d <vector70>:
.globl vector70
vector70:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $70
8010796f:	6a 46                	push   $0x46
  jmp alltraps
80107971:	e9 5b f8 ff ff       	jmp    801071d1 <alltraps>

80107976 <vector71>:
.globl vector71
vector71:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $71
80107978:	6a 47                	push   $0x47
  jmp alltraps
8010797a:	e9 52 f8 ff ff       	jmp    801071d1 <alltraps>

8010797f <vector72>:
.globl vector72
vector72:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $72
80107981:	6a 48                	push   $0x48
  jmp alltraps
80107983:	e9 49 f8 ff ff       	jmp    801071d1 <alltraps>

80107988 <vector73>:
.globl vector73
vector73:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $73
8010798a:	6a 49                	push   $0x49
  jmp alltraps
8010798c:	e9 40 f8 ff ff       	jmp    801071d1 <alltraps>

80107991 <vector74>:
.globl vector74
vector74:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $74
80107993:	6a 4a                	push   $0x4a
  jmp alltraps
80107995:	e9 37 f8 ff ff       	jmp    801071d1 <alltraps>

8010799a <vector75>:
.globl vector75
vector75:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $75
8010799c:	6a 4b                	push   $0x4b
  jmp alltraps
8010799e:	e9 2e f8 ff ff       	jmp    801071d1 <alltraps>

801079a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $76
801079a5:	6a 4c                	push   $0x4c
  jmp alltraps
801079a7:	e9 25 f8 ff ff       	jmp    801071d1 <alltraps>

801079ac <vector77>:
.globl vector77
vector77:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $77
801079ae:	6a 4d                	push   $0x4d
  jmp alltraps
801079b0:	e9 1c f8 ff ff       	jmp    801071d1 <alltraps>

801079b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801079b5:	6a 00                	push   $0x0
  pushl $78
801079b7:	6a 4e                	push   $0x4e
  jmp alltraps
801079b9:	e9 13 f8 ff ff       	jmp    801071d1 <alltraps>

801079be <vector79>:
.globl vector79
vector79:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $79
801079c0:	6a 4f                	push   $0x4f
  jmp alltraps
801079c2:	e9 0a f8 ff ff       	jmp    801071d1 <alltraps>

801079c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $80
801079c9:	6a 50                	push   $0x50
  jmp alltraps
801079cb:	e9 01 f8 ff ff       	jmp    801071d1 <alltraps>

801079d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $81
801079d2:	6a 51                	push   $0x51
  jmp alltraps
801079d4:	e9 f8 f7 ff ff       	jmp    801071d1 <alltraps>

801079d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801079d9:	6a 00                	push   $0x0
  pushl $82
801079db:	6a 52                	push   $0x52
  jmp alltraps
801079dd:	e9 ef f7 ff ff       	jmp    801071d1 <alltraps>

801079e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $83
801079e4:	6a 53                	push   $0x53
  jmp alltraps
801079e6:	e9 e6 f7 ff ff       	jmp    801071d1 <alltraps>

801079eb <vector84>:
.globl vector84
vector84:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $84
801079ed:	6a 54                	push   $0x54
  jmp alltraps
801079ef:	e9 dd f7 ff ff       	jmp    801071d1 <alltraps>

801079f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $85
801079f6:	6a 55                	push   $0x55
  jmp alltraps
801079f8:	e9 d4 f7 ff ff       	jmp    801071d1 <alltraps>

801079fd <vector86>:
.globl vector86
vector86:
  pushl $0
801079fd:	6a 00                	push   $0x0
  pushl $86
801079ff:	6a 56                	push   $0x56
  jmp alltraps
80107a01:	e9 cb f7 ff ff       	jmp    801071d1 <alltraps>

80107a06 <vector87>:
.globl vector87
vector87:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $87
80107a08:	6a 57                	push   $0x57
  jmp alltraps
80107a0a:	e9 c2 f7 ff ff       	jmp    801071d1 <alltraps>

80107a0f <vector88>:
.globl vector88
vector88:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $88
80107a11:	6a 58                	push   $0x58
  jmp alltraps
80107a13:	e9 b9 f7 ff ff       	jmp    801071d1 <alltraps>

80107a18 <vector89>:
.globl vector89
vector89:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $89
80107a1a:	6a 59                	push   $0x59
  jmp alltraps
80107a1c:	e9 b0 f7 ff ff       	jmp    801071d1 <alltraps>

80107a21 <vector90>:
.globl vector90
vector90:
  pushl $0
80107a21:	6a 00                	push   $0x0
  pushl $90
80107a23:	6a 5a                	push   $0x5a
  jmp alltraps
80107a25:	e9 a7 f7 ff ff       	jmp    801071d1 <alltraps>

80107a2a <vector91>:
.globl vector91
vector91:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $91
80107a2c:	6a 5b                	push   $0x5b
  jmp alltraps
80107a2e:	e9 9e f7 ff ff       	jmp    801071d1 <alltraps>

80107a33 <vector92>:
.globl vector92
vector92:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $92
80107a35:	6a 5c                	push   $0x5c
  jmp alltraps
80107a37:	e9 95 f7 ff ff       	jmp    801071d1 <alltraps>

80107a3c <vector93>:
.globl vector93
vector93:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $93
80107a3e:	6a 5d                	push   $0x5d
  jmp alltraps
80107a40:	e9 8c f7 ff ff       	jmp    801071d1 <alltraps>

80107a45 <vector94>:
.globl vector94
vector94:
  pushl $0
80107a45:	6a 00                	push   $0x0
  pushl $94
80107a47:	6a 5e                	push   $0x5e
  jmp alltraps
80107a49:	e9 83 f7 ff ff       	jmp    801071d1 <alltraps>

80107a4e <vector95>:
.globl vector95
vector95:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $95
80107a50:	6a 5f                	push   $0x5f
  jmp alltraps
80107a52:	e9 7a f7 ff ff       	jmp    801071d1 <alltraps>

80107a57 <vector96>:
.globl vector96
vector96:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $96
80107a59:	6a 60                	push   $0x60
  jmp alltraps
80107a5b:	e9 71 f7 ff ff       	jmp    801071d1 <alltraps>

80107a60 <vector97>:
.globl vector97
vector97:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $97
80107a62:	6a 61                	push   $0x61
  jmp alltraps
80107a64:	e9 68 f7 ff ff       	jmp    801071d1 <alltraps>

80107a69 <vector98>:
.globl vector98
vector98:
  pushl $0
80107a69:	6a 00                	push   $0x0
  pushl $98
80107a6b:	6a 62                	push   $0x62
  jmp alltraps
80107a6d:	e9 5f f7 ff ff       	jmp    801071d1 <alltraps>

80107a72 <vector99>:
.globl vector99
vector99:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $99
80107a74:	6a 63                	push   $0x63
  jmp alltraps
80107a76:	e9 56 f7 ff ff       	jmp    801071d1 <alltraps>

80107a7b <vector100>:
.globl vector100
vector100:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $100
80107a7d:	6a 64                	push   $0x64
  jmp alltraps
80107a7f:	e9 4d f7 ff ff       	jmp    801071d1 <alltraps>

80107a84 <vector101>:
.globl vector101
vector101:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $101
80107a86:	6a 65                	push   $0x65
  jmp alltraps
80107a88:	e9 44 f7 ff ff       	jmp    801071d1 <alltraps>

80107a8d <vector102>:
.globl vector102
vector102:
  pushl $0
80107a8d:	6a 00                	push   $0x0
  pushl $102
80107a8f:	6a 66                	push   $0x66
  jmp alltraps
80107a91:	e9 3b f7 ff ff       	jmp    801071d1 <alltraps>

80107a96 <vector103>:
.globl vector103
vector103:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $103
80107a98:	6a 67                	push   $0x67
  jmp alltraps
80107a9a:	e9 32 f7 ff ff       	jmp    801071d1 <alltraps>

80107a9f <vector104>:
.globl vector104
vector104:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $104
80107aa1:	6a 68                	push   $0x68
  jmp alltraps
80107aa3:	e9 29 f7 ff ff       	jmp    801071d1 <alltraps>

80107aa8 <vector105>:
.globl vector105
vector105:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $105
80107aaa:	6a 69                	push   $0x69
  jmp alltraps
80107aac:	e9 20 f7 ff ff       	jmp    801071d1 <alltraps>

80107ab1 <vector106>:
.globl vector106
vector106:
  pushl $0
80107ab1:	6a 00                	push   $0x0
  pushl $106
80107ab3:	6a 6a                	push   $0x6a
  jmp alltraps
80107ab5:	e9 17 f7 ff ff       	jmp    801071d1 <alltraps>

80107aba <vector107>:
.globl vector107
vector107:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $107
80107abc:	6a 6b                	push   $0x6b
  jmp alltraps
80107abe:	e9 0e f7 ff ff       	jmp    801071d1 <alltraps>

80107ac3 <vector108>:
.globl vector108
vector108:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $108
80107ac5:	6a 6c                	push   $0x6c
  jmp alltraps
80107ac7:	e9 05 f7 ff ff       	jmp    801071d1 <alltraps>

80107acc <vector109>:
.globl vector109
vector109:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $109
80107ace:	6a 6d                	push   $0x6d
  jmp alltraps
80107ad0:	e9 fc f6 ff ff       	jmp    801071d1 <alltraps>

80107ad5 <vector110>:
.globl vector110
vector110:
  pushl $0
80107ad5:	6a 00                	push   $0x0
  pushl $110
80107ad7:	6a 6e                	push   $0x6e
  jmp alltraps
80107ad9:	e9 f3 f6 ff ff       	jmp    801071d1 <alltraps>

80107ade <vector111>:
.globl vector111
vector111:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $111
80107ae0:	6a 6f                	push   $0x6f
  jmp alltraps
80107ae2:	e9 ea f6 ff ff       	jmp    801071d1 <alltraps>

80107ae7 <vector112>:
.globl vector112
vector112:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $112
80107ae9:	6a 70                	push   $0x70
  jmp alltraps
80107aeb:	e9 e1 f6 ff ff       	jmp    801071d1 <alltraps>

80107af0 <vector113>:
.globl vector113
vector113:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $113
80107af2:	6a 71                	push   $0x71
  jmp alltraps
80107af4:	e9 d8 f6 ff ff       	jmp    801071d1 <alltraps>

80107af9 <vector114>:
.globl vector114
vector114:
  pushl $0
80107af9:	6a 00                	push   $0x0
  pushl $114
80107afb:	6a 72                	push   $0x72
  jmp alltraps
80107afd:	e9 cf f6 ff ff       	jmp    801071d1 <alltraps>

80107b02 <vector115>:
.globl vector115
vector115:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $115
80107b04:	6a 73                	push   $0x73
  jmp alltraps
80107b06:	e9 c6 f6 ff ff       	jmp    801071d1 <alltraps>

80107b0b <vector116>:
.globl vector116
vector116:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $116
80107b0d:	6a 74                	push   $0x74
  jmp alltraps
80107b0f:	e9 bd f6 ff ff       	jmp    801071d1 <alltraps>

80107b14 <vector117>:
.globl vector117
vector117:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $117
80107b16:	6a 75                	push   $0x75
  jmp alltraps
80107b18:	e9 b4 f6 ff ff       	jmp    801071d1 <alltraps>

80107b1d <vector118>:
.globl vector118
vector118:
  pushl $0
80107b1d:	6a 00                	push   $0x0
  pushl $118
80107b1f:	6a 76                	push   $0x76
  jmp alltraps
80107b21:	e9 ab f6 ff ff       	jmp    801071d1 <alltraps>

80107b26 <vector119>:
.globl vector119
vector119:
  pushl $0
80107b26:	6a 00                	push   $0x0
  pushl $119
80107b28:	6a 77                	push   $0x77
  jmp alltraps
80107b2a:	e9 a2 f6 ff ff       	jmp    801071d1 <alltraps>

80107b2f <vector120>:
.globl vector120
vector120:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $120
80107b31:	6a 78                	push   $0x78
  jmp alltraps
80107b33:	e9 99 f6 ff ff       	jmp    801071d1 <alltraps>

80107b38 <vector121>:
.globl vector121
vector121:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $121
80107b3a:	6a 79                	push   $0x79
  jmp alltraps
80107b3c:	e9 90 f6 ff ff       	jmp    801071d1 <alltraps>

80107b41 <vector122>:
.globl vector122
vector122:
  pushl $0
80107b41:	6a 00                	push   $0x0
  pushl $122
80107b43:	6a 7a                	push   $0x7a
  jmp alltraps
80107b45:	e9 87 f6 ff ff       	jmp    801071d1 <alltraps>

80107b4a <vector123>:
.globl vector123
vector123:
  pushl $0
80107b4a:	6a 00                	push   $0x0
  pushl $123
80107b4c:	6a 7b                	push   $0x7b
  jmp alltraps
80107b4e:	e9 7e f6 ff ff       	jmp    801071d1 <alltraps>

80107b53 <vector124>:
.globl vector124
vector124:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $124
80107b55:	6a 7c                	push   $0x7c
  jmp alltraps
80107b57:	e9 75 f6 ff ff       	jmp    801071d1 <alltraps>

80107b5c <vector125>:
.globl vector125
vector125:
  pushl $0
80107b5c:	6a 00                	push   $0x0
  pushl $125
80107b5e:	6a 7d                	push   $0x7d
  jmp alltraps
80107b60:	e9 6c f6 ff ff       	jmp    801071d1 <alltraps>

80107b65 <vector126>:
.globl vector126
vector126:
  pushl $0
80107b65:	6a 00                	push   $0x0
  pushl $126
80107b67:	6a 7e                	push   $0x7e
  jmp alltraps
80107b69:	e9 63 f6 ff ff       	jmp    801071d1 <alltraps>

80107b6e <vector127>:
.globl vector127
vector127:
  pushl $0
80107b6e:	6a 00                	push   $0x0
  pushl $127
80107b70:	6a 7f                	push   $0x7f
  jmp alltraps
80107b72:	e9 5a f6 ff ff       	jmp    801071d1 <alltraps>

80107b77 <vector128>:
.globl vector128
vector128:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $128
80107b79:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107b7e:	e9 4e f6 ff ff       	jmp    801071d1 <alltraps>

80107b83 <vector129>:
.globl vector129
vector129:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $129
80107b85:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107b8a:	e9 42 f6 ff ff       	jmp    801071d1 <alltraps>

80107b8f <vector130>:
.globl vector130
vector130:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $130
80107b91:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107b96:	e9 36 f6 ff ff       	jmp    801071d1 <alltraps>

80107b9b <vector131>:
.globl vector131
vector131:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $131
80107b9d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107ba2:	e9 2a f6 ff ff       	jmp    801071d1 <alltraps>

80107ba7 <vector132>:
.globl vector132
vector132:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $132
80107ba9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107bae:	e9 1e f6 ff ff       	jmp    801071d1 <alltraps>

80107bb3 <vector133>:
.globl vector133
vector133:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $133
80107bb5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107bba:	e9 12 f6 ff ff       	jmp    801071d1 <alltraps>

80107bbf <vector134>:
.globl vector134
vector134:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $134
80107bc1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107bc6:	e9 06 f6 ff ff       	jmp    801071d1 <alltraps>

80107bcb <vector135>:
.globl vector135
vector135:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $135
80107bcd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107bd2:	e9 fa f5 ff ff       	jmp    801071d1 <alltraps>

80107bd7 <vector136>:
.globl vector136
vector136:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $136
80107bd9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107bde:	e9 ee f5 ff ff       	jmp    801071d1 <alltraps>

80107be3 <vector137>:
.globl vector137
vector137:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $137
80107be5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107bea:	e9 e2 f5 ff ff       	jmp    801071d1 <alltraps>

80107bef <vector138>:
.globl vector138
vector138:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $138
80107bf1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107bf6:	e9 d6 f5 ff ff       	jmp    801071d1 <alltraps>

80107bfb <vector139>:
.globl vector139
vector139:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $139
80107bfd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107c02:	e9 ca f5 ff ff       	jmp    801071d1 <alltraps>

80107c07 <vector140>:
.globl vector140
vector140:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $140
80107c09:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107c0e:	e9 be f5 ff ff       	jmp    801071d1 <alltraps>

80107c13 <vector141>:
.globl vector141
vector141:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $141
80107c15:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107c1a:	e9 b2 f5 ff ff       	jmp    801071d1 <alltraps>

80107c1f <vector142>:
.globl vector142
vector142:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $142
80107c21:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107c26:	e9 a6 f5 ff ff       	jmp    801071d1 <alltraps>

80107c2b <vector143>:
.globl vector143
vector143:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $143
80107c2d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107c32:	e9 9a f5 ff ff       	jmp    801071d1 <alltraps>

80107c37 <vector144>:
.globl vector144
vector144:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $144
80107c39:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107c3e:	e9 8e f5 ff ff       	jmp    801071d1 <alltraps>

80107c43 <vector145>:
.globl vector145
vector145:
  pushl $0
80107c43:	6a 00                	push   $0x0
  pushl $145
80107c45:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107c4a:	e9 82 f5 ff ff       	jmp    801071d1 <alltraps>

80107c4f <vector146>:
.globl vector146
vector146:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $146
80107c51:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107c56:	e9 76 f5 ff ff       	jmp    801071d1 <alltraps>

80107c5b <vector147>:
.globl vector147
vector147:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $147
80107c5d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107c62:	e9 6a f5 ff ff       	jmp    801071d1 <alltraps>

80107c67 <vector148>:
.globl vector148
vector148:
  pushl $0
80107c67:	6a 00                	push   $0x0
  pushl $148
80107c69:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107c6e:	e9 5e f5 ff ff       	jmp    801071d1 <alltraps>

80107c73 <vector149>:
.globl vector149
vector149:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $149
80107c75:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107c7a:	e9 52 f5 ff ff       	jmp    801071d1 <alltraps>

80107c7f <vector150>:
.globl vector150
vector150:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $150
80107c81:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107c86:	e9 46 f5 ff ff       	jmp    801071d1 <alltraps>

80107c8b <vector151>:
.globl vector151
vector151:
  pushl $0
80107c8b:	6a 00                	push   $0x0
  pushl $151
80107c8d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107c92:	e9 3a f5 ff ff       	jmp    801071d1 <alltraps>

80107c97 <vector152>:
.globl vector152
vector152:
  pushl $0
80107c97:	6a 00                	push   $0x0
  pushl $152
80107c99:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107c9e:	e9 2e f5 ff ff       	jmp    801071d1 <alltraps>

80107ca3 <vector153>:
.globl vector153
vector153:
  pushl $0
80107ca3:	6a 00                	push   $0x0
  pushl $153
80107ca5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107caa:	e9 22 f5 ff ff       	jmp    801071d1 <alltraps>

80107caf <vector154>:
.globl vector154
vector154:
  pushl $0
80107caf:	6a 00                	push   $0x0
  pushl $154
80107cb1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107cb6:	e9 16 f5 ff ff       	jmp    801071d1 <alltraps>

80107cbb <vector155>:
.globl vector155
vector155:
  pushl $0
80107cbb:	6a 00                	push   $0x0
  pushl $155
80107cbd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107cc2:	e9 0a f5 ff ff       	jmp    801071d1 <alltraps>

80107cc7 <vector156>:
.globl vector156
vector156:
  pushl $0
80107cc7:	6a 00                	push   $0x0
  pushl $156
80107cc9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107cce:	e9 fe f4 ff ff       	jmp    801071d1 <alltraps>

80107cd3 <vector157>:
.globl vector157
vector157:
  pushl $0
80107cd3:	6a 00                	push   $0x0
  pushl $157
80107cd5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107cda:	e9 f2 f4 ff ff       	jmp    801071d1 <alltraps>

80107cdf <vector158>:
.globl vector158
vector158:
  pushl $0
80107cdf:	6a 00                	push   $0x0
  pushl $158
80107ce1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107ce6:	e9 e6 f4 ff ff       	jmp    801071d1 <alltraps>

80107ceb <vector159>:
.globl vector159
vector159:
  pushl $0
80107ceb:	6a 00                	push   $0x0
  pushl $159
80107ced:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107cf2:	e9 da f4 ff ff       	jmp    801071d1 <alltraps>

80107cf7 <vector160>:
.globl vector160
vector160:
  pushl $0
80107cf7:	6a 00                	push   $0x0
  pushl $160
80107cf9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107cfe:	e9 ce f4 ff ff       	jmp    801071d1 <alltraps>

80107d03 <vector161>:
.globl vector161
vector161:
  pushl $0
80107d03:	6a 00                	push   $0x0
  pushl $161
80107d05:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107d0a:	e9 c2 f4 ff ff       	jmp    801071d1 <alltraps>

80107d0f <vector162>:
.globl vector162
vector162:
  pushl $0
80107d0f:	6a 00                	push   $0x0
  pushl $162
80107d11:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107d16:	e9 b6 f4 ff ff       	jmp    801071d1 <alltraps>

80107d1b <vector163>:
.globl vector163
vector163:
  pushl $0
80107d1b:	6a 00                	push   $0x0
  pushl $163
80107d1d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107d22:	e9 aa f4 ff ff       	jmp    801071d1 <alltraps>

80107d27 <vector164>:
.globl vector164
vector164:
  pushl $0
80107d27:	6a 00                	push   $0x0
  pushl $164
80107d29:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107d2e:	e9 9e f4 ff ff       	jmp    801071d1 <alltraps>

80107d33 <vector165>:
.globl vector165
vector165:
  pushl $0
80107d33:	6a 00                	push   $0x0
  pushl $165
80107d35:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107d3a:	e9 92 f4 ff ff       	jmp    801071d1 <alltraps>

80107d3f <vector166>:
.globl vector166
vector166:
  pushl $0
80107d3f:	6a 00                	push   $0x0
  pushl $166
80107d41:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107d46:	e9 86 f4 ff ff       	jmp    801071d1 <alltraps>

80107d4b <vector167>:
.globl vector167
vector167:
  pushl $0
80107d4b:	6a 00                	push   $0x0
  pushl $167
80107d4d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107d52:	e9 7a f4 ff ff       	jmp    801071d1 <alltraps>

80107d57 <vector168>:
.globl vector168
vector168:
  pushl $0
80107d57:	6a 00                	push   $0x0
  pushl $168
80107d59:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107d5e:	e9 6e f4 ff ff       	jmp    801071d1 <alltraps>

80107d63 <vector169>:
.globl vector169
vector169:
  pushl $0
80107d63:	6a 00                	push   $0x0
  pushl $169
80107d65:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107d6a:	e9 62 f4 ff ff       	jmp    801071d1 <alltraps>

80107d6f <vector170>:
.globl vector170
vector170:
  pushl $0
80107d6f:	6a 00                	push   $0x0
  pushl $170
80107d71:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107d76:	e9 56 f4 ff ff       	jmp    801071d1 <alltraps>

80107d7b <vector171>:
.globl vector171
vector171:
  pushl $0
80107d7b:	6a 00                	push   $0x0
  pushl $171
80107d7d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107d82:	e9 4a f4 ff ff       	jmp    801071d1 <alltraps>

80107d87 <vector172>:
.globl vector172
vector172:
  pushl $0
80107d87:	6a 00                	push   $0x0
  pushl $172
80107d89:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107d8e:	e9 3e f4 ff ff       	jmp    801071d1 <alltraps>

80107d93 <vector173>:
.globl vector173
vector173:
  pushl $0
80107d93:	6a 00                	push   $0x0
  pushl $173
80107d95:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107d9a:	e9 32 f4 ff ff       	jmp    801071d1 <alltraps>

80107d9f <vector174>:
.globl vector174
vector174:
  pushl $0
80107d9f:	6a 00                	push   $0x0
  pushl $174
80107da1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107da6:	e9 26 f4 ff ff       	jmp    801071d1 <alltraps>

80107dab <vector175>:
.globl vector175
vector175:
  pushl $0
80107dab:	6a 00                	push   $0x0
  pushl $175
80107dad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107db2:	e9 1a f4 ff ff       	jmp    801071d1 <alltraps>

80107db7 <vector176>:
.globl vector176
vector176:
  pushl $0
80107db7:	6a 00                	push   $0x0
  pushl $176
80107db9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107dbe:	e9 0e f4 ff ff       	jmp    801071d1 <alltraps>

80107dc3 <vector177>:
.globl vector177
vector177:
  pushl $0
80107dc3:	6a 00                	push   $0x0
  pushl $177
80107dc5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107dca:	e9 02 f4 ff ff       	jmp    801071d1 <alltraps>

80107dcf <vector178>:
.globl vector178
vector178:
  pushl $0
80107dcf:	6a 00                	push   $0x0
  pushl $178
80107dd1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107dd6:	e9 f6 f3 ff ff       	jmp    801071d1 <alltraps>

80107ddb <vector179>:
.globl vector179
vector179:
  pushl $0
80107ddb:	6a 00                	push   $0x0
  pushl $179
80107ddd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107de2:	e9 ea f3 ff ff       	jmp    801071d1 <alltraps>

80107de7 <vector180>:
.globl vector180
vector180:
  pushl $0
80107de7:	6a 00                	push   $0x0
  pushl $180
80107de9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107dee:	e9 de f3 ff ff       	jmp    801071d1 <alltraps>

80107df3 <vector181>:
.globl vector181
vector181:
  pushl $0
80107df3:	6a 00                	push   $0x0
  pushl $181
80107df5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107dfa:	e9 d2 f3 ff ff       	jmp    801071d1 <alltraps>

80107dff <vector182>:
.globl vector182
vector182:
  pushl $0
80107dff:	6a 00                	push   $0x0
  pushl $182
80107e01:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107e06:	e9 c6 f3 ff ff       	jmp    801071d1 <alltraps>

80107e0b <vector183>:
.globl vector183
vector183:
  pushl $0
80107e0b:	6a 00                	push   $0x0
  pushl $183
80107e0d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107e12:	e9 ba f3 ff ff       	jmp    801071d1 <alltraps>

80107e17 <vector184>:
.globl vector184
vector184:
  pushl $0
80107e17:	6a 00                	push   $0x0
  pushl $184
80107e19:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107e1e:	e9 ae f3 ff ff       	jmp    801071d1 <alltraps>

80107e23 <vector185>:
.globl vector185
vector185:
  pushl $0
80107e23:	6a 00                	push   $0x0
  pushl $185
80107e25:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107e2a:	e9 a2 f3 ff ff       	jmp    801071d1 <alltraps>

80107e2f <vector186>:
.globl vector186
vector186:
  pushl $0
80107e2f:	6a 00                	push   $0x0
  pushl $186
80107e31:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107e36:	e9 96 f3 ff ff       	jmp    801071d1 <alltraps>

80107e3b <vector187>:
.globl vector187
vector187:
  pushl $0
80107e3b:	6a 00                	push   $0x0
  pushl $187
80107e3d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107e42:	e9 8a f3 ff ff       	jmp    801071d1 <alltraps>

80107e47 <vector188>:
.globl vector188
vector188:
  pushl $0
80107e47:	6a 00                	push   $0x0
  pushl $188
80107e49:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107e4e:	e9 7e f3 ff ff       	jmp    801071d1 <alltraps>

80107e53 <vector189>:
.globl vector189
vector189:
  pushl $0
80107e53:	6a 00                	push   $0x0
  pushl $189
80107e55:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107e5a:	e9 72 f3 ff ff       	jmp    801071d1 <alltraps>

80107e5f <vector190>:
.globl vector190
vector190:
  pushl $0
80107e5f:	6a 00                	push   $0x0
  pushl $190
80107e61:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107e66:	e9 66 f3 ff ff       	jmp    801071d1 <alltraps>

80107e6b <vector191>:
.globl vector191
vector191:
  pushl $0
80107e6b:	6a 00                	push   $0x0
  pushl $191
80107e6d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107e72:	e9 5a f3 ff ff       	jmp    801071d1 <alltraps>

80107e77 <vector192>:
.globl vector192
vector192:
  pushl $0
80107e77:	6a 00                	push   $0x0
  pushl $192
80107e79:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107e7e:	e9 4e f3 ff ff       	jmp    801071d1 <alltraps>

80107e83 <vector193>:
.globl vector193
vector193:
  pushl $0
80107e83:	6a 00                	push   $0x0
  pushl $193
80107e85:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107e8a:	e9 42 f3 ff ff       	jmp    801071d1 <alltraps>

80107e8f <vector194>:
.globl vector194
vector194:
  pushl $0
80107e8f:	6a 00                	push   $0x0
  pushl $194
80107e91:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107e96:	e9 36 f3 ff ff       	jmp    801071d1 <alltraps>

80107e9b <vector195>:
.globl vector195
vector195:
  pushl $0
80107e9b:	6a 00                	push   $0x0
  pushl $195
80107e9d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107ea2:	e9 2a f3 ff ff       	jmp    801071d1 <alltraps>

80107ea7 <vector196>:
.globl vector196
vector196:
  pushl $0
80107ea7:	6a 00                	push   $0x0
  pushl $196
80107ea9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107eae:	e9 1e f3 ff ff       	jmp    801071d1 <alltraps>

80107eb3 <vector197>:
.globl vector197
vector197:
  pushl $0
80107eb3:	6a 00                	push   $0x0
  pushl $197
80107eb5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107eba:	e9 12 f3 ff ff       	jmp    801071d1 <alltraps>

80107ebf <vector198>:
.globl vector198
vector198:
  pushl $0
80107ebf:	6a 00                	push   $0x0
  pushl $198
80107ec1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107ec6:	e9 06 f3 ff ff       	jmp    801071d1 <alltraps>

80107ecb <vector199>:
.globl vector199
vector199:
  pushl $0
80107ecb:	6a 00                	push   $0x0
  pushl $199
80107ecd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107ed2:	e9 fa f2 ff ff       	jmp    801071d1 <alltraps>

80107ed7 <vector200>:
.globl vector200
vector200:
  pushl $0
80107ed7:	6a 00                	push   $0x0
  pushl $200
80107ed9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107ede:	e9 ee f2 ff ff       	jmp    801071d1 <alltraps>

80107ee3 <vector201>:
.globl vector201
vector201:
  pushl $0
80107ee3:	6a 00                	push   $0x0
  pushl $201
80107ee5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107eea:	e9 e2 f2 ff ff       	jmp    801071d1 <alltraps>

80107eef <vector202>:
.globl vector202
vector202:
  pushl $0
80107eef:	6a 00                	push   $0x0
  pushl $202
80107ef1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107ef6:	e9 d6 f2 ff ff       	jmp    801071d1 <alltraps>

80107efb <vector203>:
.globl vector203
vector203:
  pushl $0
80107efb:	6a 00                	push   $0x0
  pushl $203
80107efd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107f02:	e9 ca f2 ff ff       	jmp    801071d1 <alltraps>

80107f07 <vector204>:
.globl vector204
vector204:
  pushl $0
80107f07:	6a 00                	push   $0x0
  pushl $204
80107f09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107f0e:	e9 be f2 ff ff       	jmp    801071d1 <alltraps>

80107f13 <vector205>:
.globl vector205
vector205:
  pushl $0
80107f13:	6a 00                	push   $0x0
  pushl $205
80107f15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107f1a:	e9 b2 f2 ff ff       	jmp    801071d1 <alltraps>

80107f1f <vector206>:
.globl vector206
vector206:
  pushl $0
80107f1f:	6a 00                	push   $0x0
  pushl $206
80107f21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107f26:	e9 a6 f2 ff ff       	jmp    801071d1 <alltraps>

80107f2b <vector207>:
.globl vector207
vector207:
  pushl $0
80107f2b:	6a 00                	push   $0x0
  pushl $207
80107f2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107f32:	e9 9a f2 ff ff       	jmp    801071d1 <alltraps>

80107f37 <vector208>:
.globl vector208
vector208:
  pushl $0
80107f37:	6a 00                	push   $0x0
  pushl $208
80107f39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107f3e:	e9 8e f2 ff ff       	jmp    801071d1 <alltraps>

80107f43 <vector209>:
.globl vector209
vector209:
  pushl $0
80107f43:	6a 00                	push   $0x0
  pushl $209
80107f45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107f4a:	e9 82 f2 ff ff       	jmp    801071d1 <alltraps>

80107f4f <vector210>:
.globl vector210
vector210:
  pushl $0
80107f4f:	6a 00                	push   $0x0
  pushl $210
80107f51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107f56:	e9 76 f2 ff ff       	jmp    801071d1 <alltraps>

80107f5b <vector211>:
.globl vector211
vector211:
  pushl $0
80107f5b:	6a 00                	push   $0x0
  pushl $211
80107f5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107f62:	e9 6a f2 ff ff       	jmp    801071d1 <alltraps>

80107f67 <vector212>:
.globl vector212
vector212:
  pushl $0
80107f67:	6a 00                	push   $0x0
  pushl $212
80107f69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107f6e:	e9 5e f2 ff ff       	jmp    801071d1 <alltraps>

80107f73 <vector213>:
.globl vector213
vector213:
  pushl $0
80107f73:	6a 00                	push   $0x0
  pushl $213
80107f75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107f7a:	e9 52 f2 ff ff       	jmp    801071d1 <alltraps>

80107f7f <vector214>:
.globl vector214
vector214:
  pushl $0
80107f7f:	6a 00                	push   $0x0
  pushl $214
80107f81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107f86:	e9 46 f2 ff ff       	jmp    801071d1 <alltraps>

80107f8b <vector215>:
.globl vector215
vector215:
  pushl $0
80107f8b:	6a 00                	push   $0x0
  pushl $215
80107f8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107f92:	e9 3a f2 ff ff       	jmp    801071d1 <alltraps>

80107f97 <vector216>:
.globl vector216
vector216:
  pushl $0
80107f97:	6a 00                	push   $0x0
  pushl $216
80107f99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107f9e:	e9 2e f2 ff ff       	jmp    801071d1 <alltraps>

80107fa3 <vector217>:
.globl vector217
vector217:
  pushl $0
80107fa3:	6a 00                	push   $0x0
  pushl $217
80107fa5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107faa:	e9 22 f2 ff ff       	jmp    801071d1 <alltraps>

80107faf <vector218>:
.globl vector218
vector218:
  pushl $0
80107faf:	6a 00                	push   $0x0
  pushl $218
80107fb1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107fb6:	e9 16 f2 ff ff       	jmp    801071d1 <alltraps>

80107fbb <vector219>:
.globl vector219
vector219:
  pushl $0
80107fbb:	6a 00                	push   $0x0
  pushl $219
80107fbd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107fc2:	e9 0a f2 ff ff       	jmp    801071d1 <alltraps>

80107fc7 <vector220>:
.globl vector220
vector220:
  pushl $0
80107fc7:	6a 00                	push   $0x0
  pushl $220
80107fc9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107fce:	e9 fe f1 ff ff       	jmp    801071d1 <alltraps>

80107fd3 <vector221>:
.globl vector221
vector221:
  pushl $0
80107fd3:	6a 00                	push   $0x0
  pushl $221
80107fd5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107fda:	e9 f2 f1 ff ff       	jmp    801071d1 <alltraps>

80107fdf <vector222>:
.globl vector222
vector222:
  pushl $0
80107fdf:	6a 00                	push   $0x0
  pushl $222
80107fe1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107fe6:	e9 e6 f1 ff ff       	jmp    801071d1 <alltraps>

80107feb <vector223>:
.globl vector223
vector223:
  pushl $0
80107feb:	6a 00                	push   $0x0
  pushl $223
80107fed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107ff2:	e9 da f1 ff ff       	jmp    801071d1 <alltraps>

80107ff7 <vector224>:
.globl vector224
vector224:
  pushl $0
80107ff7:	6a 00                	push   $0x0
  pushl $224
80107ff9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107ffe:	e9 ce f1 ff ff       	jmp    801071d1 <alltraps>

80108003 <vector225>:
.globl vector225
vector225:
  pushl $0
80108003:	6a 00                	push   $0x0
  pushl $225
80108005:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010800a:	e9 c2 f1 ff ff       	jmp    801071d1 <alltraps>

8010800f <vector226>:
.globl vector226
vector226:
  pushl $0
8010800f:	6a 00                	push   $0x0
  pushl $226
80108011:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108016:	e9 b6 f1 ff ff       	jmp    801071d1 <alltraps>

8010801b <vector227>:
.globl vector227
vector227:
  pushl $0
8010801b:	6a 00                	push   $0x0
  pushl $227
8010801d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108022:	e9 aa f1 ff ff       	jmp    801071d1 <alltraps>

80108027 <vector228>:
.globl vector228
vector228:
  pushl $0
80108027:	6a 00                	push   $0x0
  pushl $228
80108029:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010802e:	e9 9e f1 ff ff       	jmp    801071d1 <alltraps>

80108033 <vector229>:
.globl vector229
vector229:
  pushl $0
80108033:	6a 00                	push   $0x0
  pushl $229
80108035:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010803a:	e9 92 f1 ff ff       	jmp    801071d1 <alltraps>

8010803f <vector230>:
.globl vector230
vector230:
  pushl $0
8010803f:	6a 00                	push   $0x0
  pushl $230
80108041:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108046:	e9 86 f1 ff ff       	jmp    801071d1 <alltraps>

8010804b <vector231>:
.globl vector231
vector231:
  pushl $0
8010804b:	6a 00                	push   $0x0
  pushl $231
8010804d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108052:	e9 7a f1 ff ff       	jmp    801071d1 <alltraps>

80108057 <vector232>:
.globl vector232
vector232:
  pushl $0
80108057:	6a 00                	push   $0x0
  pushl $232
80108059:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010805e:	e9 6e f1 ff ff       	jmp    801071d1 <alltraps>

80108063 <vector233>:
.globl vector233
vector233:
  pushl $0
80108063:	6a 00                	push   $0x0
  pushl $233
80108065:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010806a:	e9 62 f1 ff ff       	jmp    801071d1 <alltraps>

8010806f <vector234>:
.globl vector234
vector234:
  pushl $0
8010806f:	6a 00                	push   $0x0
  pushl $234
80108071:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108076:	e9 56 f1 ff ff       	jmp    801071d1 <alltraps>

8010807b <vector235>:
.globl vector235
vector235:
  pushl $0
8010807b:	6a 00                	push   $0x0
  pushl $235
8010807d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108082:	e9 4a f1 ff ff       	jmp    801071d1 <alltraps>

80108087 <vector236>:
.globl vector236
vector236:
  pushl $0
80108087:	6a 00                	push   $0x0
  pushl $236
80108089:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010808e:	e9 3e f1 ff ff       	jmp    801071d1 <alltraps>

80108093 <vector237>:
.globl vector237
vector237:
  pushl $0
80108093:	6a 00                	push   $0x0
  pushl $237
80108095:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010809a:	e9 32 f1 ff ff       	jmp    801071d1 <alltraps>

8010809f <vector238>:
.globl vector238
vector238:
  pushl $0
8010809f:	6a 00                	push   $0x0
  pushl $238
801080a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801080a6:	e9 26 f1 ff ff       	jmp    801071d1 <alltraps>

801080ab <vector239>:
.globl vector239
vector239:
  pushl $0
801080ab:	6a 00                	push   $0x0
  pushl $239
801080ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801080b2:	e9 1a f1 ff ff       	jmp    801071d1 <alltraps>

801080b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801080b7:	6a 00                	push   $0x0
  pushl $240
801080b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801080be:	e9 0e f1 ff ff       	jmp    801071d1 <alltraps>

801080c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801080c3:	6a 00                	push   $0x0
  pushl $241
801080c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801080ca:	e9 02 f1 ff ff       	jmp    801071d1 <alltraps>

801080cf <vector242>:
.globl vector242
vector242:
  pushl $0
801080cf:	6a 00                	push   $0x0
  pushl $242
801080d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801080d6:	e9 f6 f0 ff ff       	jmp    801071d1 <alltraps>

801080db <vector243>:
.globl vector243
vector243:
  pushl $0
801080db:	6a 00                	push   $0x0
  pushl $243
801080dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801080e2:	e9 ea f0 ff ff       	jmp    801071d1 <alltraps>

801080e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801080e7:	6a 00                	push   $0x0
  pushl $244
801080e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801080ee:	e9 de f0 ff ff       	jmp    801071d1 <alltraps>

801080f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801080f3:	6a 00                	push   $0x0
  pushl $245
801080f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801080fa:	e9 d2 f0 ff ff       	jmp    801071d1 <alltraps>

801080ff <vector246>:
.globl vector246
vector246:
  pushl $0
801080ff:	6a 00                	push   $0x0
  pushl $246
80108101:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108106:	e9 c6 f0 ff ff       	jmp    801071d1 <alltraps>

8010810b <vector247>:
.globl vector247
vector247:
  pushl $0
8010810b:	6a 00                	push   $0x0
  pushl $247
8010810d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108112:	e9 ba f0 ff ff       	jmp    801071d1 <alltraps>

80108117 <vector248>:
.globl vector248
vector248:
  pushl $0
80108117:	6a 00                	push   $0x0
  pushl $248
80108119:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010811e:	e9 ae f0 ff ff       	jmp    801071d1 <alltraps>

80108123 <vector249>:
.globl vector249
vector249:
  pushl $0
80108123:	6a 00                	push   $0x0
  pushl $249
80108125:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010812a:	e9 a2 f0 ff ff       	jmp    801071d1 <alltraps>

8010812f <vector250>:
.globl vector250
vector250:
  pushl $0
8010812f:	6a 00                	push   $0x0
  pushl $250
80108131:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108136:	e9 96 f0 ff ff       	jmp    801071d1 <alltraps>

8010813b <vector251>:
.globl vector251
vector251:
  pushl $0
8010813b:	6a 00                	push   $0x0
  pushl $251
8010813d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108142:	e9 8a f0 ff ff       	jmp    801071d1 <alltraps>

80108147 <vector252>:
.globl vector252
vector252:
  pushl $0
80108147:	6a 00                	push   $0x0
  pushl $252
80108149:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010814e:	e9 7e f0 ff ff       	jmp    801071d1 <alltraps>

80108153 <vector253>:
.globl vector253
vector253:
  pushl $0
80108153:	6a 00                	push   $0x0
  pushl $253
80108155:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010815a:	e9 72 f0 ff ff       	jmp    801071d1 <alltraps>

8010815f <vector254>:
.globl vector254
vector254:
  pushl $0
8010815f:	6a 00                	push   $0x0
  pushl $254
80108161:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108166:	e9 66 f0 ff ff       	jmp    801071d1 <alltraps>

8010816b <vector255>:
.globl vector255
vector255:
  pushl $0
8010816b:	6a 00                	push   $0x0
  pushl $255
8010816d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108172:	e9 5a f0 ff ff       	jmp    801071d1 <alltraps>
80108177:	66 90                	xchg   %ax,%ax
80108179:	66 90                	xchg   %ax,%ax
8010817b:	66 90                	xchg   %ax,%ax
8010817d:	66 90                	xchg   %ax,%ax
8010817f:	90                   	nop

80108180 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108180:	55                   	push   %ebp
80108181:	89 e5                	mov    %esp,%ebp
80108183:	57                   	push   %edi
80108184:	56                   	push   %esi
80108185:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108186:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010818c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108192:	83 ec 1c             	sub    $0x1c,%esp
80108195:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108198:	39 d3                	cmp    %edx,%ebx
8010819a:	73 49                	jae    801081e5 <deallocuvm.part.0+0x65>
8010819c:	89 c7                	mov    %eax,%edi
8010819e:	eb 0c                	jmp    801081ac <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801081a0:	83 c0 01             	add    $0x1,%eax
801081a3:	c1 e0 16             	shl    $0x16,%eax
801081a6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801081a8:	39 da                	cmp    %ebx,%edx
801081aa:	76 39                	jbe    801081e5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801081ac:	89 d8                	mov    %ebx,%eax
801081ae:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801081b1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801081b4:	f6 c1 01             	test   $0x1,%cl
801081b7:	74 e7                	je     801081a0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801081b9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081bb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801081c1:	c1 ee 0a             	shr    $0xa,%esi
801081c4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801081ca:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801081d1:	85 f6                	test   %esi,%esi
801081d3:	74 cb                	je     801081a0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801081d5:	8b 06                	mov    (%esi),%eax
801081d7:	a8 01                	test   $0x1,%al
801081d9:	75 15                	jne    801081f0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801081db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801081e1:	39 da                	cmp    %ebx,%edx
801081e3:	77 c7                	ja     801081ac <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801081e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081eb:	5b                   	pop    %ebx
801081ec:	5e                   	pop    %esi
801081ed:	5f                   	pop    %edi
801081ee:	5d                   	pop    %ebp
801081ef:	c3                   	ret    
      if(pa == 0)
801081f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081f5:	74 25                	je     8010821c <deallocuvm.part.0+0x9c>
      kfree(v);
801081f7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801081fa:	05 00 00 00 80       	add    $0x80000000,%eax
801081ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108202:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80108208:	50                   	push   %eax
80108209:	e8 92 b5 ff ff       	call   801037a0 <kfree>
      *pte = 0;
8010820e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80108214:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108217:	83 c4 10             	add    $0x10,%esp
8010821a:	eb 8c                	jmp    801081a8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010821c:	83 ec 0c             	sub    $0xc,%esp
8010821f:	68 26 8e 10 80       	push   $0x80108e26
80108224:	e8 37 82 ff ff       	call   80100460 <panic>
80108229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108230 <mappages>:
{
80108230:	55                   	push   %ebp
80108231:	89 e5                	mov    %esp,%ebp
80108233:	57                   	push   %edi
80108234:	56                   	push   %esi
80108235:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108236:	89 d3                	mov    %edx,%ebx
80108238:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010823e:	83 ec 1c             	sub    $0x1c,%esp
80108241:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108244:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108248:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010824d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108250:	8b 45 08             	mov    0x8(%ebp),%eax
80108253:	29 d8                	sub    %ebx,%eax
80108255:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108258:	eb 3d                	jmp    80108297 <mappages+0x67>
8010825a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108260:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108262:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108267:	c1 ea 0a             	shr    $0xa,%edx
8010826a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108270:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108277:	85 c0                	test   %eax,%eax
80108279:	74 75                	je     801082f0 <mappages+0xc0>
    if(*pte & PTE_P)
8010827b:	f6 00 01             	testb  $0x1,(%eax)
8010827e:	0f 85 86 00 00 00    	jne    8010830a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108284:	0b 75 0c             	or     0xc(%ebp),%esi
80108287:	83 ce 01             	or     $0x1,%esi
8010828a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010828c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010828f:	74 6f                	je     80108300 <mappages+0xd0>
    a += PGSIZE;
80108291:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108297:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010829a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010829d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801082a0:	89 d8                	mov    %ebx,%eax
801082a2:	c1 e8 16             	shr    $0x16,%eax
801082a5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801082a8:	8b 07                	mov    (%edi),%eax
801082aa:	a8 01                	test   $0x1,%al
801082ac:	75 b2                	jne    80108260 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801082ae:	e8 ad b6 ff ff       	call   80103960 <kalloc>
801082b3:	85 c0                	test   %eax,%eax
801082b5:	74 39                	je     801082f0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801082b7:	83 ec 04             	sub    $0x4,%esp
801082ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801082bd:	68 00 10 00 00       	push   $0x1000
801082c2:	6a 00                	push   $0x0
801082c4:	50                   	push   %eax
801082c5:	e8 86 da ff ff       	call   80105d50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801082ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801082cd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801082d0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801082d6:	83 c8 07             	or     $0x7,%eax
801082d9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801082db:	89 d8                	mov    %ebx,%eax
801082dd:	c1 e8 0a             	shr    $0xa,%eax
801082e0:	25 fc 0f 00 00       	and    $0xffc,%eax
801082e5:	01 d0                	add    %edx,%eax
801082e7:	eb 92                	jmp    8010827b <mappages+0x4b>
801082e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801082f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801082f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082f8:	5b                   	pop    %ebx
801082f9:	5e                   	pop    %esi
801082fa:	5f                   	pop    %edi
801082fb:	5d                   	pop    %ebp
801082fc:	c3                   	ret    
801082fd:	8d 76 00             	lea    0x0(%esi),%esi
80108300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108303:	31 c0                	xor    %eax,%eax
}
80108305:	5b                   	pop    %ebx
80108306:	5e                   	pop    %esi
80108307:	5f                   	pop    %edi
80108308:	5d                   	pop    %ebp
80108309:	c3                   	ret    
      panic("remap");
8010830a:	83 ec 0c             	sub    $0xc,%esp
8010830d:	68 94 95 10 80       	push   $0x80109594
80108312:	e8 49 81 ff ff       	call   80100460 <panic>
80108317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010831e:	66 90                	xchg   %ax,%ax

80108320 <seginit>:
{
80108320:	55                   	push   %ebp
80108321:	89 e5                	mov    %esp,%ebp
80108323:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108326:	e8 15 c9 ff ff       	call   80104c40 <cpuid>
  pd[0] = size-1;
8010832b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80108330:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80108336:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010833a:	c7 80 b8 43 11 80 ff 	movl   $0xffff,-0x7feebc48(%eax)
80108341:	ff 00 00 
80108344:	c7 80 bc 43 11 80 00 	movl   $0xcf9a00,-0x7feebc44(%eax)
8010834b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010834e:	c7 80 c0 43 11 80 ff 	movl   $0xffff,-0x7feebc40(%eax)
80108355:	ff 00 00 
80108358:	c7 80 c4 43 11 80 00 	movl   $0xcf9200,-0x7feebc3c(%eax)
8010835f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108362:	c7 80 c8 43 11 80 ff 	movl   $0xffff,-0x7feebc38(%eax)
80108369:	ff 00 00 
8010836c:	c7 80 cc 43 11 80 00 	movl   $0xcffa00,-0x7feebc34(%eax)
80108373:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108376:	c7 80 d0 43 11 80 ff 	movl   $0xffff,-0x7feebc30(%eax)
8010837d:	ff 00 00 
80108380:	c7 80 d4 43 11 80 00 	movl   $0xcff200,-0x7feebc2c(%eax)
80108387:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010838a:	05 b0 43 11 80       	add    $0x801143b0,%eax
  pd[1] = (uint)p;
8010838f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108393:	c1 e8 10             	shr    $0x10,%eax
80108396:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010839a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010839d:	0f 01 10             	lgdtl  (%eax)
}
801083a0:	c9                   	leave  
801083a1:	c3                   	ret    
801083a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801083b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801083b0:	a1 64 d5 11 80       	mov    0x8011d564,%eax
801083b5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801083ba:	0f 22 d8             	mov    %eax,%cr3
}
801083bd:	c3                   	ret    
801083be:	66 90                	xchg   %ax,%ax

801083c0 <switchuvm>:
{
801083c0:	55                   	push   %ebp
801083c1:	89 e5                	mov    %esp,%ebp
801083c3:	57                   	push   %edi
801083c4:	56                   	push   %esi
801083c5:	53                   	push   %ebx
801083c6:	83 ec 1c             	sub    $0x1c,%esp
801083c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801083cc:	85 f6                	test   %esi,%esi
801083ce:	0f 84 cb 00 00 00    	je     8010849f <switchuvm+0xdf>
  if(p->kstack == 0)
801083d4:	8b 46 08             	mov    0x8(%esi),%eax
801083d7:	85 c0                	test   %eax,%eax
801083d9:	0f 84 da 00 00 00    	je     801084b9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801083df:	8b 46 04             	mov    0x4(%esi),%eax
801083e2:	85 c0                	test   %eax,%eax
801083e4:	0f 84 c2 00 00 00    	je     801084ac <switchuvm+0xec>
  pushcli();
801083ea:	e8 51 d7 ff ff       	call   80105b40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801083ef:	e8 ec c7 ff ff       	call   80104be0 <mycpu>
801083f4:	89 c3                	mov    %eax,%ebx
801083f6:	e8 e5 c7 ff ff       	call   80104be0 <mycpu>
801083fb:	89 c7                	mov    %eax,%edi
801083fd:	e8 de c7 ff ff       	call   80104be0 <mycpu>
80108402:	83 c7 08             	add    $0x8,%edi
80108405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108408:	e8 d3 c7 ff ff       	call   80104be0 <mycpu>
8010840d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108410:	ba 67 00 00 00       	mov    $0x67,%edx
80108415:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010841c:	83 c0 08             	add    $0x8,%eax
8010841f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108426:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010842b:	83 c1 08             	add    $0x8,%ecx
8010842e:	c1 e8 18             	shr    $0x18,%eax
80108431:	c1 e9 10             	shr    $0x10,%ecx
80108434:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010843a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108440:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108445:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010844c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108451:	e8 8a c7 ff ff       	call   80104be0 <mycpu>
80108456:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010845d:	e8 7e c7 ff ff       	call   80104be0 <mycpu>
80108462:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108466:	8b 5e 08             	mov    0x8(%esi),%ebx
80108469:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010846f:	e8 6c c7 ff ff       	call   80104be0 <mycpu>
80108474:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108477:	e8 64 c7 ff ff       	call   80104be0 <mycpu>
8010847c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108480:	b8 28 00 00 00       	mov    $0x28,%eax
80108485:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108488:	8b 46 04             	mov    0x4(%esi),%eax
8010848b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108490:	0f 22 d8             	mov    %eax,%cr3
}
80108493:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108496:	5b                   	pop    %ebx
80108497:	5e                   	pop    %esi
80108498:	5f                   	pop    %edi
80108499:	5d                   	pop    %ebp
  popcli();
8010849a:	e9 f1 d6 ff ff       	jmp    80105b90 <popcli>
    panic("switchuvm: no process");
8010849f:	83 ec 0c             	sub    $0xc,%esp
801084a2:	68 9a 95 10 80       	push   $0x8010959a
801084a7:	e8 b4 7f ff ff       	call   80100460 <panic>
    panic("switchuvm: no pgdir");
801084ac:	83 ec 0c             	sub    $0xc,%esp
801084af:	68 c5 95 10 80       	push   $0x801095c5
801084b4:	e8 a7 7f ff ff       	call   80100460 <panic>
    panic("switchuvm: no kstack");
801084b9:	83 ec 0c             	sub    $0xc,%esp
801084bc:	68 b0 95 10 80       	push   $0x801095b0
801084c1:	e8 9a 7f ff ff       	call   80100460 <panic>
801084c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084cd:	8d 76 00             	lea    0x0(%esi),%esi

801084d0 <inituvm>:
{
801084d0:	55                   	push   %ebp
801084d1:	89 e5                	mov    %esp,%ebp
801084d3:	57                   	push   %edi
801084d4:	56                   	push   %esi
801084d5:	53                   	push   %ebx
801084d6:	83 ec 1c             	sub    $0x1c,%esp
801084d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084dc:	8b 75 10             	mov    0x10(%ebp),%esi
801084df:	8b 7d 08             	mov    0x8(%ebp),%edi
801084e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801084e5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801084eb:	77 4b                	ja     80108538 <inituvm+0x68>
  mem = kalloc();
801084ed:	e8 6e b4 ff ff       	call   80103960 <kalloc>
  memset(mem, 0, PGSIZE);
801084f2:	83 ec 04             	sub    $0x4,%esp
801084f5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801084fa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801084fc:	6a 00                	push   $0x0
801084fe:	50                   	push   %eax
801084ff:	e8 4c d8 ff ff       	call   80105d50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108504:	58                   	pop    %eax
80108505:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010850b:	5a                   	pop    %edx
8010850c:	6a 06                	push   $0x6
8010850e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108513:	31 d2                	xor    %edx,%edx
80108515:	50                   	push   %eax
80108516:	89 f8                	mov    %edi,%eax
80108518:	e8 13 fd ff ff       	call   80108230 <mappages>
  memmove(mem, init, sz);
8010851d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108520:	89 75 10             	mov    %esi,0x10(%ebp)
80108523:	83 c4 10             	add    $0x10,%esp
80108526:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108529:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010852c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010852f:	5b                   	pop    %ebx
80108530:	5e                   	pop    %esi
80108531:	5f                   	pop    %edi
80108532:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108533:	e9 b8 d8 ff ff       	jmp    80105df0 <memmove>
    panic("inituvm: more than a page");
80108538:	83 ec 0c             	sub    $0xc,%esp
8010853b:	68 d9 95 10 80       	push   $0x801095d9
80108540:	e8 1b 7f ff ff       	call   80100460 <panic>
80108545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010854c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108550 <loaduvm>:
{
80108550:	55                   	push   %ebp
80108551:	89 e5                	mov    %esp,%ebp
80108553:	57                   	push   %edi
80108554:	56                   	push   %esi
80108555:	53                   	push   %ebx
80108556:	83 ec 1c             	sub    $0x1c,%esp
80108559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010855c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010855f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108564:	0f 85 bb 00 00 00    	jne    80108625 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010856a:	01 f0                	add    %esi,%eax
8010856c:	89 f3                	mov    %esi,%ebx
8010856e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108571:	8b 45 14             	mov    0x14(%ebp),%eax
80108574:	01 f0                	add    %esi,%eax
80108576:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80108579:	85 f6                	test   %esi,%esi
8010857b:	0f 84 87 00 00 00    	je     80108608 <loaduvm+0xb8>
80108581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80108588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010858b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010858e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80108590:	89 c2                	mov    %eax,%edx
80108592:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108595:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80108598:	f6 c2 01             	test   $0x1,%dl
8010859b:	75 13                	jne    801085b0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010859d:	83 ec 0c             	sub    $0xc,%esp
801085a0:	68 f3 95 10 80       	push   $0x801095f3
801085a5:	e8 b6 7e ff ff       	call   80100460 <panic>
801085aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801085b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801085b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801085b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801085be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801085c5:	85 c0                	test   %eax,%eax
801085c7:	74 d4                	je     8010859d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801085c9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801085cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801085ce:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801085d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801085d8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801085de:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801085e1:	29 d9                	sub    %ebx,%ecx
801085e3:	05 00 00 00 80       	add    $0x80000000,%eax
801085e8:	57                   	push   %edi
801085e9:	51                   	push   %ecx
801085ea:	50                   	push   %eax
801085eb:	ff 75 10             	push   0x10(%ebp)
801085ee:	e8 7d a7 ff ff       	call   80102d70 <readi>
801085f3:	83 c4 10             	add    $0x10,%esp
801085f6:	39 f8                	cmp    %edi,%eax
801085f8:	75 1e                	jne    80108618 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801085fa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108600:	89 f0                	mov    %esi,%eax
80108602:	29 d8                	sub    %ebx,%eax
80108604:	39 c6                	cmp    %eax,%esi
80108606:	77 80                	ja     80108588 <loaduvm+0x38>
}
80108608:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010860b:	31 c0                	xor    %eax,%eax
}
8010860d:	5b                   	pop    %ebx
8010860e:	5e                   	pop    %esi
8010860f:	5f                   	pop    %edi
80108610:	5d                   	pop    %ebp
80108611:	c3                   	ret    
80108612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108618:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010861b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108620:	5b                   	pop    %ebx
80108621:	5e                   	pop    %esi
80108622:	5f                   	pop    %edi
80108623:	5d                   	pop    %ebp
80108624:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80108625:	83 ec 0c             	sub    $0xc,%esp
80108628:	68 94 96 10 80       	push   $0x80109694
8010862d:	e8 2e 7e ff ff       	call   80100460 <panic>
80108632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108640 <allocuvm>:
{
80108640:	55                   	push   %ebp
80108641:	89 e5                	mov    %esp,%ebp
80108643:	57                   	push   %edi
80108644:	56                   	push   %esi
80108645:	53                   	push   %ebx
80108646:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108649:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010864c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010864f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108652:	85 c0                	test   %eax,%eax
80108654:	0f 88 b6 00 00 00    	js     80108710 <allocuvm+0xd0>
  if(newsz < oldsz)
8010865a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010865d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108660:	0f 82 9a 00 00 00    	jb     80108700 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108666:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010866c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108672:	39 75 10             	cmp    %esi,0x10(%ebp)
80108675:	77 44                	ja     801086bb <allocuvm+0x7b>
80108677:	e9 87 00 00 00       	jmp    80108703 <allocuvm+0xc3>
8010867c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108680:	83 ec 04             	sub    $0x4,%esp
80108683:	68 00 10 00 00       	push   $0x1000
80108688:	6a 00                	push   $0x0
8010868a:	50                   	push   %eax
8010868b:	e8 c0 d6 ff ff       	call   80105d50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108690:	58                   	pop    %eax
80108691:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108697:	5a                   	pop    %edx
80108698:	6a 06                	push   $0x6
8010869a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010869f:	89 f2                	mov    %esi,%edx
801086a1:	50                   	push   %eax
801086a2:	89 f8                	mov    %edi,%eax
801086a4:	e8 87 fb ff ff       	call   80108230 <mappages>
801086a9:	83 c4 10             	add    $0x10,%esp
801086ac:	85 c0                	test   %eax,%eax
801086ae:	78 78                	js     80108728 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801086b0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801086b6:	39 75 10             	cmp    %esi,0x10(%ebp)
801086b9:	76 48                	jbe    80108703 <allocuvm+0xc3>
    mem = kalloc();
801086bb:	e8 a0 b2 ff ff       	call   80103960 <kalloc>
801086c0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801086c2:	85 c0                	test   %eax,%eax
801086c4:	75 ba                	jne    80108680 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801086c6:	83 ec 0c             	sub    $0xc,%esp
801086c9:	68 11 96 10 80       	push   $0x80109611
801086ce:	e8 0d 81 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
801086d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801086d6:	83 c4 10             	add    $0x10,%esp
801086d9:	39 45 10             	cmp    %eax,0x10(%ebp)
801086dc:	74 32                	je     80108710 <allocuvm+0xd0>
801086de:	8b 55 10             	mov    0x10(%ebp),%edx
801086e1:	89 c1                	mov    %eax,%ecx
801086e3:	89 f8                	mov    %edi,%eax
801086e5:	e8 96 fa ff ff       	call   80108180 <deallocuvm.part.0>
      return 0;
801086ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801086f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801086f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086f7:	5b                   	pop    %ebx
801086f8:	5e                   	pop    %esi
801086f9:	5f                   	pop    %edi
801086fa:	5d                   	pop    %ebp
801086fb:	c3                   	ret    
801086fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108706:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108709:	5b                   	pop    %ebx
8010870a:	5e                   	pop    %esi
8010870b:	5f                   	pop    %edi
8010870c:	5d                   	pop    %ebp
8010870d:	c3                   	ret    
8010870e:	66 90                	xchg   %ax,%ax
    return 0;
80108710:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010871a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010871d:	5b                   	pop    %ebx
8010871e:	5e                   	pop    %esi
8010871f:	5f                   	pop    %edi
80108720:	5d                   	pop    %ebp
80108721:	c3                   	ret    
80108722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108728:	83 ec 0c             	sub    $0xc,%esp
8010872b:	68 29 96 10 80       	push   $0x80109629
80108730:	e8 ab 80 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80108735:	8b 45 0c             	mov    0xc(%ebp),%eax
80108738:	83 c4 10             	add    $0x10,%esp
8010873b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010873e:	74 0c                	je     8010874c <allocuvm+0x10c>
80108740:	8b 55 10             	mov    0x10(%ebp),%edx
80108743:	89 c1                	mov    %eax,%ecx
80108745:	89 f8                	mov    %edi,%eax
80108747:	e8 34 fa ff ff       	call   80108180 <deallocuvm.part.0>
      kfree(mem);
8010874c:	83 ec 0c             	sub    $0xc,%esp
8010874f:	53                   	push   %ebx
80108750:	e8 4b b0 ff ff       	call   801037a0 <kfree>
      return 0;
80108755:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010875c:	83 c4 10             	add    $0x10,%esp
}
8010875f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108762:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108765:	5b                   	pop    %ebx
80108766:	5e                   	pop    %esi
80108767:	5f                   	pop    %edi
80108768:	5d                   	pop    %ebp
80108769:	c3                   	ret    
8010876a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108770 <deallocuvm>:
{
80108770:	55                   	push   %ebp
80108771:	89 e5                	mov    %esp,%ebp
80108773:	8b 55 0c             	mov    0xc(%ebp),%edx
80108776:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108779:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010877c:	39 d1                	cmp    %edx,%ecx
8010877e:	73 10                	jae    80108790 <deallocuvm+0x20>
}
80108780:	5d                   	pop    %ebp
80108781:	e9 fa f9 ff ff       	jmp    80108180 <deallocuvm.part.0>
80108786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010878d:	8d 76 00             	lea    0x0(%esi),%esi
80108790:	89 d0                	mov    %edx,%eax
80108792:	5d                   	pop    %ebp
80108793:	c3                   	ret    
80108794:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010879b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010879f:	90                   	nop

801087a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801087a0:	55                   	push   %ebp
801087a1:	89 e5                	mov    %esp,%ebp
801087a3:	57                   	push   %edi
801087a4:	56                   	push   %esi
801087a5:	53                   	push   %ebx
801087a6:	83 ec 0c             	sub    $0xc,%esp
801087a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801087ac:	85 f6                	test   %esi,%esi
801087ae:	74 59                	je     80108809 <freevm+0x69>
  if(newsz >= oldsz)
801087b0:	31 c9                	xor    %ecx,%ecx
801087b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801087b7:	89 f0                	mov    %esi,%eax
801087b9:	89 f3                	mov    %esi,%ebx
801087bb:	e8 c0 f9 ff ff       	call   80108180 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801087c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801087c6:	eb 0f                	jmp    801087d7 <freevm+0x37>
801087c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087cf:	90                   	nop
801087d0:	83 c3 04             	add    $0x4,%ebx
801087d3:	39 df                	cmp    %ebx,%edi
801087d5:	74 23                	je     801087fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801087d7:	8b 03                	mov    (%ebx),%eax
801087d9:	a8 01                	test   $0x1,%al
801087db:	74 f3                	je     801087d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801087dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801087e2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801087e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801087e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801087ed:	50                   	push   %eax
801087ee:	e8 ad af ff ff       	call   801037a0 <kfree>
801087f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801087f6:	39 df                	cmp    %ebx,%edi
801087f8:	75 dd                	jne    801087d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801087fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801087fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108800:	5b                   	pop    %ebx
80108801:	5e                   	pop    %esi
80108802:	5f                   	pop    %edi
80108803:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108804:	e9 97 af ff ff       	jmp    801037a0 <kfree>
    panic("freevm: no pgdir");
80108809:	83 ec 0c             	sub    $0xc,%esp
8010880c:	68 45 96 10 80       	push   $0x80109645
80108811:	e8 4a 7c ff ff       	call   80100460 <panic>
80108816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010881d:	8d 76 00             	lea    0x0(%esi),%esi

80108820 <setupkvm>:
{
80108820:	55                   	push   %ebp
80108821:	89 e5                	mov    %esp,%ebp
80108823:	56                   	push   %esi
80108824:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108825:	e8 36 b1 ff ff       	call   80103960 <kalloc>
8010882a:	89 c6                	mov    %eax,%esi
8010882c:	85 c0                	test   %eax,%eax
8010882e:	74 42                	je     80108872 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108830:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108833:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108838:	68 00 10 00 00       	push   $0x1000
8010883d:	6a 00                	push   $0x0
8010883f:	50                   	push   %eax
80108840:	e8 0b d5 ff ff       	call   80105d50 <memset>
80108845:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108848:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010884b:	83 ec 08             	sub    $0x8,%esp
8010884e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108851:	ff 73 0c             	push   0xc(%ebx)
80108854:	8b 13                	mov    (%ebx),%edx
80108856:	50                   	push   %eax
80108857:	29 c1                	sub    %eax,%ecx
80108859:	89 f0                	mov    %esi,%eax
8010885b:	e8 d0 f9 ff ff       	call   80108230 <mappages>
80108860:	83 c4 10             	add    $0x10,%esp
80108863:	85 c0                	test   %eax,%eax
80108865:	78 19                	js     80108880 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108867:	83 c3 10             	add    $0x10,%ebx
8010886a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108870:	75 d6                	jne    80108848 <setupkvm+0x28>
}
80108872:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108875:	89 f0                	mov    %esi,%eax
80108877:	5b                   	pop    %ebx
80108878:	5e                   	pop    %esi
80108879:	5d                   	pop    %ebp
8010887a:	c3                   	ret    
8010887b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010887f:	90                   	nop
      freevm(pgdir);
80108880:	83 ec 0c             	sub    $0xc,%esp
80108883:	56                   	push   %esi
      return 0;
80108884:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108886:	e8 15 ff ff ff       	call   801087a0 <freevm>
      return 0;
8010888b:	83 c4 10             	add    $0x10,%esp
}
8010888e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108891:	89 f0                	mov    %esi,%eax
80108893:	5b                   	pop    %ebx
80108894:	5e                   	pop    %esi
80108895:	5d                   	pop    %ebp
80108896:	c3                   	ret    
80108897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010889e:	66 90                	xchg   %ax,%ax

801088a0 <kvmalloc>:
{
801088a0:	55                   	push   %ebp
801088a1:	89 e5                	mov    %esp,%ebp
801088a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801088a6:	e8 75 ff ff ff       	call   80108820 <setupkvm>
801088ab:	a3 64 d5 11 80       	mov    %eax,0x8011d564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801088b0:	05 00 00 00 80       	add    $0x80000000,%eax
801088b5:	0f 22 d8             	mov    %eax,%cr3
}
801088b8:	c9                   	leave  
801088b9:	c3                   	ret    
801088ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801088c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801088c0:	55                   	push   %ebp
801088c1:	89 e5                	mov    %esp,%ebp
801088c3:	83 ec 08             	sub    $0x8,%esp
801088c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801088c9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801088cc:	89 c1                	mov    %eax,%ecx
801088ce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801088d1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801088d4:	f6 c2 01             	test   $0x1,%dl
801088d7:	75 17                	jne    801088f0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801088d9:	83 ec 0c             	sub    $0xc,%esp
801088dc:	68 56 96 10 80       	push   $0x80109656
801088e1:	e8 7a 7b ff ff       	call   80100460 <panic>
801088e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801088ed:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801088f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801088f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801088f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801088fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108905:	85 c0                	test   %eax,%eax
80108907:	74 d0                	je     801088d9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108909:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010890c:	c9                   	leave  
8010890d:	c3                   	ret    
8010890e:	66 90                	xchg   %ax,%ax

80108910 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108910:	55                   	push   %ebp
80108911:	89 e5                	mov    %esp,%ebp
80108913:	57                   	push   %edi
80108914:	56                   	push   %esi
80108915:	53                   	push   %ebx
80108916:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108919:	e8 02 ff ff ff       	call   80108820 <setupkvm>
8010891e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108921:	85 c0                	test   %eax,%eax
80108923:	0f 84 bd 00 00 00    	je     801089e6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010892c:	85 c9                	test   %ecx,%ecx
8010892e:	0f 84 b2 00 00 00    	je     801089e6 <copyuvm+0xd6>
80108934:	31 f6                	xor    %esi,%esi
80108936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010893d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108940:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108943:	89 f0                	mov    %esi,%eax
80108945:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108948:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010894b:	a8 01                	test   $0x1,%al
8010894d:	75 11                	jne    80108960 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010894f:	83 ec 0c             	sub    $0xc,%esp
80108952:	68 60 96 10 80       	push   $0x80109660
80108957:	e8 04 7b ff ff       	call   80100460 <panic>
8010895c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108960:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108967:	c1 ea 0a             	shr    $0xa,%edx
8010896a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108970:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108977:	85 c0                	test   %eax,%eax
80108979:	74 d4                	je     8010894f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010897b:	8b 00                	mov    (%eax),%eax
8010897d:	a8 01                	test   $0x1,%al
8010897f:	0f 84 9f 00 00 00    	je     80108a24 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108985:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108987:	25 ff 0f 00 00       	and    $0xfff,%eax
8010898c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010898f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108995:	e8 c6 af ff ff       	call   80103960 <kalloc>
8010899a:	89 c3                	mov    %eax,%ebx
8010899c:	85 c0                	test   %eax,%eax
8010899e:	74 64                	je     80108a04 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801089a0:	83 ec 04             	sub    $0x4,%esp
801089a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801089a9:	68 00 10 00 00       	push   $0x1000
801089ae:	57                   	push   %edi
801089af:	50                   	push   %eax
801089b0:	e8 3b d4 ff ff       	call   80105df0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801089b5:	58                   	pop    %eax
801089b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801089bc:	5a                   	pop    %edx
801089bd:	ff 75 e4             	push   -0x1c(%ebp)
801089c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801089c5:	89 f2                	mov    %esi,%edx
801089c7:	50                   	push   %eax
801089c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089cb:	e8 60 f8 ff ff       	call   80108230 <mappages>
801089d0:	83 c4 10             	add    $0x10,%esp
801089d3:	85 c0                	test   %eax,%eax
801089d5:	78 21                	js     801089f8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801089d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801089dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801089e0:	0f 87 5a ff ff ff    	ja     80108940 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801089e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089ec:	5b                   	pop    %ebx
801089ed:	5e                   	pop    %esi
801089ee:	5f                   	pop    %edi
801089ef:	5d                   	pop    %ebp
801089f0:	c3                   	ret    
801089f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801089f8:	83 ec 0c             	sub    $0xc,%esp
801089fb:	53                   	push   %ebx
801089fc:	e8 9f ad ff ff       	call   801037a0 <kfree>
      goto bad;
80108a01:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108a04:	83 ec 0c             	sub    $0xc,%esp
80108a07:	ff 75 e0             	push   -0x20(%ebp)
80108a0a:	e8 91 fd ff ff       	call   801087a0 <freevm>
  return 0;
80108a0f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108a16:	83 c4 10             	add    $0x10,%esp
}
80108a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a1f:	5b                   	pop    %ebx
80108a20:	5e                   	pop    %esi
80108a21:	5f                   	pop    %edi
80108a22:	5d                   	pop    %ebp
80108a23:	c3                   	ret    
      panic("copyuvm: page not present");
80108a24:	83 ec 0c             	sub    $0xc,%esp
80108a27:	68 7a 96 10 80       	push   $0x8010967a
80108a2c:	e8 2f 7a ff ff       	call   80100460 <panic>
80108a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a3f:	90                   	nop

80108a40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108a40:	55                   	push   %ebp
80108a41:	89 e5                	mov    %esp,%ebp
80108a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108a46:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108a49:	89 c1                	mov    %eax,%ecx
80108a4b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108a4e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108a51:	f6 c2 01             	test   $0x1,%dl
80108a54:	0f 84 00 01 00 00    	je     80108b5a <uva2ka.cold>
  return &pgtab[PTX(va)];
80108a5a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108a5d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108a63:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108a64:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108a69:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108a70:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108a72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108a77:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108a7a:	05 00 00 00 80       	add    $0x80000000,%eax
80108a7f:	83 fa 05             	cmp    $0x5,%edx
80108a82:	ba 00 00 00 00       	mov    $0x0,%edx
80108a87:	0f 45 c2             	cmovne %edx,%eax
}
80108a8a:	c3                   	ret    
80108a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108a8f:	90                   	nop

80108a90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108a90:	55                   	push   %ebp
80108a91:	89 e5                	mov    %esp,%ebp
80108a93:	57                   	push   %edi
80108a94:	56                   	push   %esi
80108a95:	53                   	push   %ebx
80108a96:	83 ec 0c             	sub    $0xc,%esp
80108a99:	8b 75 14             	mov    0x14(%ebp),%esi
80108a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a9f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108aa2:	85 f6                	test   %esi,%esi
80108aa4:	75 51                	jne    80108af7 <copyout+0x67>
80108aa6:	e9 a5 00 00 00       	jmp    80108b50 <copyout+0xc0>
80108aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108aaf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108ab0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108ab6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80108abc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108ac2:	74 75                	je     80108b39 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108ac4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108ac6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108ac9:	29 c3                	sub    %eax,%ebx
80108acb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108ad1:	39 f3                	cmp    %esi,%ebx
80108ad3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108ad6:	29 f8                	sub    %edi,%eax
80108ad8:	83 ec 04             	sub    $0x4,%esp
80108adb:	01 c1                	add    %eax,%ecx
80108add:	53                   	push   %ebx
80108ade:	52                   	push   %edx
80108adf:	51                   	push   %ecx
80108ae0:	e8 0b d3 ff ff       	call   80105df0 <memmove>
    len -= n;
    buf += n;
80108ae5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108ae8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80108aee:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108af1:	01 da                	add    %ebx,%edx
  while(len > 0){
80108af3:	29 de                	sub    %ebx,%esi
80108af5:	74 59                	je     80108b50 <copyout+0xc0>
  if(*pde & PTE_P){
80108af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80108afa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108afc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80108afe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108b01:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108b07:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80108b0a:	f6 c1 01             	test   $0x1,%cl
80108b0d:	0f 84 4e 00 00 00    	je     80108b61 <copyout.cold>
  return &pgtab[PTX(va)];
80108b13:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108b15:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108b1b:	c1 eb 0c             	shr    $0xc,%ebx
80108b1e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108b24:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80108b2b:	89 d9                	mov    %ebx,%ecx
80108b2d:	83 e1 05             	and    $0x5,%ecx
80108b30:	83 f9 05             	cmp    $0x5,%ecx
80108b33:	0f 84 77 ff ff ff    	je     80108ab0 <copyout+0x20>
  }
  return 0;
}
80108b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108b41:	5b                   	pop    %ebx
80108b42:	5e                   	pop    %esi
80108b43:	5f                   	pop    %edi
80108b44:	5d                   	pop    %ebp
80108b45:	c3                   	ret    
80108b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108b4d:	8d 76 00             	lea    0x0(%esi),%esi
80108b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108b53:	31 c0                	xor    %eax,%eax
}
80108b55:	5b                   	pop    %ebx
80108b56:	5e                   	pop    %esi
80108b57:	5f                   	pop    %edi
80108b58:	5d                   	pop    %ebp
80108b59:	c3                   	ret    

80108b5a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108b5a:	a1 00 00 00 00       	mov    0x0,%eax
80108b5f:	0f 0b                	ud2    

80108b61 <copyout.cold>:
80108b61:	a1 00 00 00 00       	mov    0x0,%eax
80108b66:	0f 0b                	ud2    
