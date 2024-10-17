
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
80100028:	bc 50 6f 11 80       	mov    $0x80116f50,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 38 10 80       	mov    $0x801038a0,%eax
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
8010004c:	68 e0 79 10 80       	push   $0x801079e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 4b 00 00       	call   80104c10 <initlock>
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
80100092:	68 e7 79 10 80       	push   $0x801079e7
80100097:	50                   	push   %eax
80100098:	e8 43 4a 00 00       	call   80104ae0 <initsleeplock>
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
801000e4:	e8 f7 4c 00 00       	call   80104de0 <acquire>
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
80100162:	e8 19 4c 00 00       	call   80104d80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 49 00 00       	call   80104b20 <acquiresleep>
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
8010018c:	e8 8f 29 00 00       	call   80102b20 <iderw>
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
801001a1:	68 ee 79 10 80       	push   $0x801079ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
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
801001be:	e8 fd 49 00 00       	call   80104bc0 <holdingsleep>
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
801001d4:	e9 47 29 00 00       	jmp    80102b20 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 79 10 80       	push   $0x801079ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
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
801001ff:	e8 bc 49 00 00       	call   80104bc0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 49 00 00       	call   80104b80 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 4b 00 00       	call   80104de0 <acquire>
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
8010026c:	e9 0f 4b 00 00       	jmp    80104d80 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 7a 10 80       	push   $0x80107a06
80100279:	e8 02 01 00 00       	call   80100380 <panic>
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
80100294:	e8 07 1e 00 00       	call   801020a0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 a0 09 11 80 	movl   $0x801109a0,(%esp)
801002a0:	e8 3b 4b 00 00       	call   80104de0 <acquire>
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
801002c3:	68 a0 09 11 80       	push   $0x801109a0
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ae 45 00 00       	call   80104880 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 3e 00 00       	call   801041b0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 a0 09 11 80       	push   $0x801109a0
801002f6:	e8 85 4a 00 00       	call   80104d80 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 bc 1c 00 00       	call   80101fc0 <ilock>
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
80100347:	68 a0 09 11 80       	push   $0x801109a0
8010034c:	e8 2f 4a 00 00       	call   80104d80 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 66 1c 00 00       	call   80101fc0 <ilock>
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
80100389:	c7 05 d4 09 11 80 00 	movl   $0x0,0x801109d4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 92 2d 00 00       	call   80103130 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 7a 10 80       	push   $0x80107a0d
801003a7:	e8 54 03 00 00       	call   80100700 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 4b 03 00 00       	call   80100700 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 37 83 10 80 	movl   $0x80108337,(%esp)
801003bc:	e8 3f 03 00 00       	call   80100700 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 48 00 00       	call   80104c30 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 7a 10 80       	push   $0x80107a21
801003dd:	e8 1e 03 00 00       	call   80100700 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 dc 09 11 80 01 	movl   $0x1,0x801109dc
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE) {
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 4a 01 00 00    	je     80100560 <consputc.part.0+0x160>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 d1 60 00 00       	call   801064f0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 f2 00 00 00    	je     80100548 <consputc.part.0+0x148>
  for (int i = pos - 1; i < pos + cap; i++)
80100456:	8b 3d d8 09 11 80    	mov    0x801109d8,%edi
8010045c:	8d 34 38             	lea    (%eax,%edi,1),%esi
  else if(c == BACKSPACE) {
8010045f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100465:	0f 84 9d 00 00 00    	je     80100508 <consputc.part.0+0x108>
  for (int i = pos + cap; i > pos; i--)
8010046b:	39 f0                	cmp    %esi,%eax
8010046d:	7d 1f                	jge    8010048e <consputc.part.0+0x8e>
8010046f:	8d 94 36 fe 7f 0b 80 	lea    -0x7ff48002(%esi,%esi,1),%edx
80100476:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010047d:	8d 76 00             	lea    0x0(%esi),%esi
    crt[i] = crt[i - 1];
80100480:	0f b7 0a             	movzwl (%edx),%ecx
  for (int i = pos + cap; i > pos; i--)
80100483:	83 ea 02             	sub    $0x2,%edx
    crt[i] = crt[i - 1];
80100486:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for (int i = pos + cap; i > pos; i--)
8010048a:	39 d6                	cmp    %edx,%esi
8010048c:	75 f2                	jne    80100480 <consputc.part.0+0x80>
    crt[pos] = (c&0xff) | 0x0700;  // black on white
8010048e:	0f b6 db             	movzbl %bl,%ebx
80100491:	80 cf 07             	or     $0x7,%bh
80100494:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010049b:	80 
    pos++;
8010049c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(pos < 0 || pos > 25 * 80)
8010049f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004a5:	0f 8f 2f 01 00 00    	jg     801005da <consputc.part.0+0x1da>
  if((pos / 80) >= 24) {  // Scroll up.
801004ab:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004b1:	0f 8f d9 00 00 00    	jg     80100590 <consputc.part.0+0x190>
  outb(CRTPORT + 1, pos >> 8);
801004b7:	0f b6 c7             	movzbl %bh,%eax
  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
801004ba:	8b 3d d8 09 11 80    	mov    0x801109d8,%edi
  outb(CRTPORT + 1, pos);
801004c0:	89 de                	mov    %ebx,%esi
  outb(CRTPORT + 1, pos >> 8);
801004c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
801004c5:	01 df                	add    %ebx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c7:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004cc:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d1:	89 da                	mov    %ebx,%edx
801004d3:	ee                   	out    %al,(%dx)
801004d4:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004d9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004dd:	89 ca                	mov    %ecx,%edx
801004df:	ee                   	out    %al,(%dx)
801004e0:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e5:	89 da                	mov    %ebx,%edx
801004e7:	ee                   	out    %al,(%dx)
801004e8:	89 f0                	mov    %esi,%eax
801004ea:	89 ca                	mov    %ecx,%edx
801004ec:	ee                   	out    %al,(%dx)
801004ed:	b8 20 07 00 00       	mov    $0x720,%eax
801004f2:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
801004f9:	80 
}
801004fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004fd:	5b                   	pop    %ebx
801004fe:	5e                   	pop    %esi
801004ff:	5f                   	pop    %edi
80100500:	5d                   	pop    %ebp
80100501:	c3                   	ret    
80100502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int i = pos - 1; i < pos + cap; i++)
80100508:	8d 58 ff             	lea    -0x1(%eax),%ebx
8010050b:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
80100512:	89 d9                	mov    %ebx,%ecx
80100514:	85 ff                	test   %edi,%edi
80100516:	78 1c                	js     80100534 <consputc.part.0+0x134>
80100518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010051f:	90                   	nop
    crt[i] = crt[i+1];
80100520:	0f b7 02             	movzwl (%edx),%eax
  for (int i = pos - 1; i < pos + cap; i++)
80100523:	83 c1 01             	add    $0x1,%ecx
80100526:	83 c2 02             	add    $0x2,%edx
    crt[i] = crt[i+1];
80100529:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for (int i = pos - 1; i < pos + cap; i++)
8010052d:	39 f1                	cmp    %esi,%ecx
8010052f:	7c ef                	jl     80100520 <consputc.part.0+0x120>
80100531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0)
80100534:	85 c0                	test   %eax,%eax
80100536:	0f 85 63 ff ff ff    	jne    8010049f <consputc.part.0+0x9f>
8010053c:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100540:	31 f6                	xor    %esi,%esi
80100542:	eb 83                	jmp    801004c7 <consputc.part.0+0xc7>
80100544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100548:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010054d:	f7 e2                	mul    %edx
8010054f:	c1 ea 06             	shr    $0x6,%edx
80100552:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100555:	c1 e0 04             	shl    $0x4,%eax
80100558:	8d 58 50             	lea    0x50(%eax),%ebx
8010055b:	e9 3f ff ff ff       	jmp    8010049f <consputc.part.0+0x9f>
    uartputc('\b');
80100560:	83 ec 0c             	sub    $0xc,%esp
80100563:	6a 08                	push   $0x8
80100565:	e8 86 5f 00 00       	call   801064f0 <uartputc>
    uartputc(' ');
8010056a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100571:	e8 7a 5f 00 00       	call   801064f0 <uartputc>
    uartputc('\b');
80100576:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010057d:	e8 6e 5f 00 00       	call   801064f0 <uartputc>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 98 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100590:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100593:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100596:	68 60 0e 00 00       	push   $0xe60
  outb(CRTPORT + 1, pos);
8010059b:	89 fe                	mov    %edi,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010059d:	68 a0 80 0b 80       	push   $0x800b80a0
801005a2:	68 00 80 0b 80       	push   $0x800b8000
801005a7:	e8 94 49 00 00       	call   80104f40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005ac:	b8 80 07 00 00       	mov    $0x780,%eax
801005b1:	83 c4 0c             	add    $0xc,%esp
801005b4:	29 f8                	sub    %edi,%eax
801005b6:	01 c0                	add    %eax,%eax
801005b8:	50                   	push   %eax
801005b9:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801005c0:	6a 00                	push   $0x0
801005c2:	50                   	push   %eax
801005c3:	e8 d8 48 00 00       	call   80104ea0 <memset>
  crt[pos + cap] = ' ' | 0x0700; // space ra bezare tahe khat
801005c8:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005cc:	03 3d d8 09 11 80    	add    0x801109d8,%edi
801005d2:	83 c4 10             	add    $0x10,%esp
801005d5:	e9 ed fe ff ff       	jmp    801004c7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801005da:	83 ec 0c             	sub    $0xc,%esp
801005dd:	68 25 7a 10 80       	push   $0x80107a25
801005e2:	e8 99 fd ff ff       	call   80100380 <panic>
801005e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005ee:	66 90                	xchg   %ax,%ax

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005f9:	ff 75 08             	push   0x8(%ebp)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	e8 9c 1a 00 00       	call   801020a0 <iunlock>
  acquire(&cons.lock);
80100604:	c7 04 24 a0 09 11 80 	movl   $0x801109a0,(%esp)
8010060b:	e8 d0 47 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++)
80100610:	83 c4 10             	add    $0x10,%esp
80100613:	85 f6                	test   %esi,%esi
80100615:	7e 25                	jle    8010063c <consolewrite+0x4c>
80100617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010061a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked) {
8010061d:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
    consputc(buf[i] & 0xff);
80100623:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked) {
80100626:	85 d2                	test   %edx,%edx
80100628:	74 06                	je     80100630 <consolewrite+0x40>
  asm volatile("cli");
8010062a:	fa                   	cli    
    for(;;)
8010062b:	eb fe                	jmp    8010062b <consolewrite+0x3b>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
80100630:	e8 cb fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
80100635:	83 c3 01             	add    $0x1,%ebx
80100638:	39 df                	cmp    %ebx,%edi
8010063a:	75 e1                	jne    8010061d <consolewrite+0x2d>
  release(&cons.lock);
8010063c:	83 ec 0c             	sub    $0xc,%esp
8010063f:	68 a0 09 11 80       	push   $0x801109a0
80100644:	e8 37 47 00 00       	call   80104d80 <release>
  ilock(ip);
80100649:	58                   	pop    %eax
8010064a:	ff 75 08             	push   0x8(%ebp)
8010064d:	e8 6e 19 00 00       	call   80101fc0 <ilock>

  return n;
}
80100652:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100655:	89 f0                	mov    %esi,%eax
80100657:	5b                   	pop    %ebx
80100658:	5e                   	pop    %esi
80100659:	5f                   	pop    %edi
8010065a:	5d                   	pop    %ebp
8010065b:	c3                   	ret    
8010065c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100660 <printint>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 2c             	sub    $0x2c,%esp
80100669:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010066c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010066f:	85 c9                	test   %ecx,%ecx
80100671:	74 04                	je     80100677 <printint+0x17>
80100673:	85 c0                	test   %eax,%eax
80100675:	78 6d                	js     801006e4 <printint+0x84>
    x = xx;
80100677:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010067e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100680:	31 db                	xor    %ebx,%ebx
80100682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100688:	89 c8                	mov    %ecx,%eax
8010068a:	31 d2                	xor    %edx,%edx
8010068c:	89 de                	mov    %ebx,%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	f7 75 d4             	divl   -0x2c(%ebp)
80100693:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100696:	0f b6 92 5c 7a 10 80 	movzbl -0x7fef85a4(%edx),%edx
  }while((x /= base) != 0);
8010069d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010069f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801006a3:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
801006a6:	73 e0                	jae    80100688 <printint+0x28>
  if(sign)
801006a8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801006ab:	85 c9                	test   %ecx,%ecx
801006ad:	74 0c                	je     801006bb <printint+0x5b>
    buf[i++] = '-';
801006af:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801006b4:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
801006b6:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801006bb:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
801006bf:	0f be c2             	movsbl %dl,%eax
  if(panicked) {
801006c2:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
801006c8:	85 d2                	test   %edx,%edx
801006ca:	74 04                	je     801006d0 <printint+0x70>
801006cc:	fa                   	cli    
    for(;;)
801006cd:	eb fe                	jmp    801006cd <printint+0x6d>
801006cf:	90                   	nop
801006d0:	e8 2b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
801006d5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801006d8:	39 c3                	cmp    %eax,%ebx
801006da:	74 0e                	je     801006ea <printint+0x8a>
    consputc(buf[i]);
801006dc:	0f be 03             	movsbl (%ebx),%eax
801006df:	83 eb 01             	sub    $0x1,%ebx
801006e2:	eb de                	jmp    801006c2 <printint+0x62>
    x = -xx;
801006e4:	f7 d8                	neg    %eax
801006e6:	89 c1                	mov    %eax,%ecx
801006e8:	eb 96                	jmp    80100680 <printint+0x20>
}
801006ea:	83 c4 2c             	add    $0x2c,%esp
801006ed:	5b                   	pop    %ebx
801006ee:	5e                   	pop    %esi
801006ef:	5f                   	pop    %edi
801006f0:	5d                   	pop    %ebp
801006f1:	c3                   	ret    
801006f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100700 <cprintf>:
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100709:	a1 d4 09 11 80       	mov    0x801109d4,%eax
8010070e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100711:	85 c0                	test   %eax,%eax
80100713:	0f 85 27 01 00 00    	jne    80100840 <cprintf+0x140>
  if (fmt == 0)
80100719:	8b 75 08             	mov    0x8(%ebp),%esi
8010071c:	85 f6                	test   %esi,%esi
8010071e:	0f 84 ac 01 00 00    	je     801008d0 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100724:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100727:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072a:	31 db                	xor    %ebx,%ebx
8010072c:	85 c0                	test   %eax,%eax
8010072e:	74 56                	je     80100786 <cprintf+0x86>
    if(c != '%'){
80100730:	83 f8 25             	cmp    $0x25,%eax
80100733:	0f 85 cf 00 00 00    	jne    80100808 <cprintf+0x108>
    c = fmt[++i] & 0xff;
80100739:	83 c3 01             	add    $0x1,%ebx
8010073c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100740:	85 d2                	test   %edx,%edx
80100742:	74 42                	je     80100786 <cprintf+0x86>
    switch(c){
80100744:	83 fa 70             	cmp    $0x70,%edx
80100747:	0f 84 90 00 00 00    	je     801007dd <cprintf+0xdd>
8010074d:	7f 51                	jg     801007a0 <cprintf+0xa0>
8010074f:	83 fa 25             	cmp    $0x25,%edx
80100752:	0f 84 c0 00 00 00    	je     80100818 <cprintf+0x118>
80100758:	83 fa 64             	cmp    $0x64,%edx
8010075b:	0f 85 f4 00 00 00    	jne    80100855 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	b9 01 00 00 00       	mov    $0x1,%ecx
80100769:	ba 0a 00 00 00       	mov    $0xa,%edx
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 e8 fe ff ff       	call   80100660 <printint>
80100778:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077b:	83 c3 01             	add    $0x1,%ebx
8010077e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100782:	85 c0                	test   %eax,%eax
80100784:	75 aa                	jne    80100730 <cprintf+0x30>
  if(locking)
80100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100789:	85 c0                	test   %eax,%eax
8010078b:	0f 85 22 01 00 00    	jne    801008b3 <cprintf+0x1b3>
}
80100791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100794:	5b                   	pop    %ebx
80100795:	5e                   	pop    %esi
80100796:	5f                   	pop    %edi
80100797:	5d                   	pop    %ebp
80100798:	c3                   	ret    
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007a0:	83 fa 73             	cmp    $0x73,%edx
801007a3:	75 33                	jne    801007d8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
801007a5:	8d 47 04             	lea    0x4(%edi),%eax
801007a8:	8b 3f                	mov    (%edi),%edi
801007aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ad:	85 ff                	test   %edi,%edi
801007af:	0f 84 e3 00 00 00    	je     80100898 <cprintf+0x198>
      for(; *s; s++)
801007b5:	0f be 07             	movsbl (%edi),%eax
801007b8:	84 c0                	test   %al,%al
801007ba:	0f 84 08 01 00 00    	je     801008c8 <cprintf+0x1c8>
  if(panicked) {
801007c0:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
801007c6:	85 d2                	test   %edx,%edx
801007c8:	0f 84 b2 00 00 00    	je     80100880 <cprintf+0x180>
801007ce:	fa                   	cli    
    for(;;)
801007cf:	eb fe                	jmp    801007cf <cprintf+0xcf>
801007d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007d8:	83 fa 78             	cmp    $0x78,%edx
801007db:	75 78                	jne    80100855 <cprintf+0x155>
      printint(*argp++, 16, 0);
801007dd:	8d 47 04             	lea    0x4(%edi),%eax
801007e0:	31 c9                	xor    %ecx,%ecx
801007e2:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e7:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ed:	8b 07                	mov    (%edi),%eax
801007ef:	e8 6c fe ff ff       	call   80100660 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007f4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007fb:	85 c0                	test   %eax,%eax
801007fd:	0f 85 2d ff ff ff    	jne    80100730 <cprintf+0x30>
80100803:	eb 81                	jmp    80100786 <cprintf+0x86>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
80100808:	8b 0d dc 09 11 80    	mov    0x801109dc,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	74 14                	je     80100826 <cprintf+0x126>
80100812:	fa                   	cli    
    for(;;)
80100813:	eb fe                	jmp    80100813 <cprintf+0x113>
80100815:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
80100818:	a1 dc 09 11 80       	mov    0x801109dc,%eax
8010081d:	85 c0                	test   %eax,%eax
8010081f:	75 6c                	jne    8010088d <cprintf+0x18d>
80100821:	b8 25 00 00 00       	mov    $0x25,%eax
80100826:	e8 d5 fb ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010082b:	83 c3 01             	add    $0x1,%ebx
8010082e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100832:	85 c0                	test   %eax,%eax
80100834:	0f 85 f6 fe ff ff    	jne    80100730 <cprintf+0x30>
8010083a:	e9 47 ff ff ff       	jmp    80100786 <cprintf+0x86>
8010083f:	90                   	nop
    acquire(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 a0 09 11 80       	push   $0x801109a0
80100848:	e8 93 45 00 00       	call   80104de0 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 c4 fe ff ff       	jmp    80100719 <cprintf+0x19>
  if(panicked) {
80100855:	8b 0d dc 09 11 80    	mov    0x801109dc,%ecx
8010085b:	85 c9                	test   %ecx,%ecx
8010085d:	75 31                	jne    80100890 <cprintf+0x190>
8010085f:	b8 25 00 00 00       	mov    $0x25,%eax
80100864:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100867:	e8 94 fb ff ff       	call   80100400 <consputc.part.0>
8010086c:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
80100872:	85 d2                	test   %edx,%edx
80100874:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100877:	74 2e                	je     801008a7 <cprintf+0x1a7>
80100879:	fa                   	cli    
    for(;;)
8010087a:	eb fe                	jmp    8010087a <cprintf+0x17a>
8010087c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100880:	e8 7b fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100885:	83 c7 01             	add    $0x1,%edi
80100888:	e9 28 ff ff ff       	jmp    801007b5 <cprintf+0xb5>
8010088d:	fa                   	cli    
    for(;;)
8010088e:	eb fe                	jmp    8010088e <cprintf+0x18e>
80100890:	fa                   	cli    
80100891:	eb fe                	jmp    80100891 <cprintf+0x191>
80100893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100897:	90                   	nop
        s = "(null)";
80100898:	bf 38 7a 10 80       	mov    $0x80107a38,%edi
      for(; *s; s++)
8010089d:	b8 28 00 00 00       	mov    $0x28,%eax
801008a2:	e9 19 ff ff ff       	jmp    801007c0 <cprintf+0xc0>
801008a7:	89 d0                	mov    %edx,%eax
801008a9:	e8 52 fb ff ff       	call   80100400 <consputc.part.0>
801008ae:	e9 c8 fe ff ff       	jmp    8010077b <cprintf+0x7b>
    release(&cons.lock);
801008b3:	83 ec 0c             	sub    $0xc,%esp
801008b6:	68 a0 09 11 80       	push   $0x801109a0
801008bb:	e8 c0 44 00 00       	call   80104d80 <release>
801008c0:	83 c4 10             	add    $0x10,%esp
}
801008c3:	e9 c9 fe ff ff       	jmp    80100791 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008cb:	e9 ab fe ff ff       	jmp    8010077b <cprintf+0x7b>
    panic("null fmt");
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	68 3f 7a 10 80       	push   $0x80107a3f
801008d8:	e8 a3 fa ff ff       	call   80100380 <panic>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi

801008e0 <shift_forward_crt>:
{
801008e0:	55                   	push   %ebp
  for (int i = pos + cap; i > pos; i--)
801008e1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
{
801008e6:	89 e5                	mov    %esp,%ebp
801008e8:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i = pos + cap; i > pos; i--)
801008eb:	01 d0                	add    %edx,%eax
801008ed:	39 c2                	cmp    %eax,%edx
801008ef:	7d 1d                	jge    8010090e <shift_forward_crt+0x2e>
801008f1:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
801008f8:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
801008ff:	90                   	nop
    crt[i] = crt[i - 1];
80100900:	0f b7 10             	movzwl (%eax),%edx
  for (int i = pos + cap; i > pos; i--)
80100903:	83 e8 02             	sub    $0x2,%eax
    crt[i] = crt[i - 1];
80100906:	66 89 50 04          	mov    %dx,0x4(%eax)
  for (int i = pos + cap; i > pos; i--)
8010090a:	39 c8                	cmp    %ecx,%eax
8010090c:	75 f2                	jne    80100900 <shift_forward_crt+0x20>
}
8010090e:	5d                   	pop    %ebp
8010090f:	c3                   	ret    

80100910 <shift_back_crt>:
{
80100910:	55                   	push   %ebp
  for (int i = pos - 1; i < pos + cap; i++)
80100911:	8b 0d d8 09 11 80    	mov    0x801109d8,%ecx
{
80100917:	89 e5                	mov    %esp,%ebp
80100919:	53                   	push   %ebx
8010091a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (int i = pos - 1; i < pos + cap; i++)
8010091d:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80100920:	85 c9                	test   %ecx,%ecx
80100922:	78 1d                	js     80100941 <shift_back_crt+0x31>
80100924:	8d 50 ff             	lea    -0x1(%eax),%edx
80100927:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
8010092e:	66 90                	xchg   %ax,%ax
    crt[i] = crt[i+1];
80100930:	0f b7 08             	movzwl (%eax),%ecx
  for (int i = pos - 1; i < pos + cap; i++)
80100933:	83 c2 01             	add    $0x1,%edx
80100936:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i+1];
80100939:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for (int i = pos - 1; i < pos + cap; i++)
8010093d:	39 da                	cmp    %ebx,%edx
8010093f:	7c ef                	jl     80100930 <shift_back_crt+0x20>
}
80100941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100944:	c9                   	leave  
80100945:	c3                   	ret    
80100946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010094d:	8d 76 00             	lea    0x0(%esi),%esi

80100950 <makeChangeInPos>:
{
80100950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100951:	b8 0e 00 00 00       	mov    $0xe,%eax
80100956:	89 e5                	mov    %esp,%ebp
80100958:	56                   	push   %esi
80100959:	be d4 03 00 00       	mov    $0x3d4,%esi
8010095e:	53                   	push   %ebx
8010095f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100962:	89 f2                	mov    %esi,%edx
80100964:	ee                   	out    %al,(%dx)
80100965:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
8010096a:	89 c8                	mov    %ecx,%eax
8010096c:	c1 f8 08             	sar    $0x8,%eax
8010096f:	89 da                	mov    %ebx,%edx
80100971:	ee                   	out    %al,(%dx)
80100972:	b8 0f 00 00 00       	mov    $0xf,%eax
80100977:	89 f2                	mov    %esi,%edx
80100979:	ee                   	out    %al,(%dx)
8010097a:	89 c8                	mov    %ecx,%eax
8010097c:	89 da                	mov    %ebx,%edx
8010097e:	ee                   	out    %al,(%dx)
}
8010097f:	5b                   	pop    %ebx
80100980:	5e                   	pop    %esi
80100981:	5d                   	pop    %ebp
80100982:	c3                   	ret    
80100983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010098a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100990 <getLastCommand>:
{
80100990:	55                   	push   %ebp
80100991:	89 e5                	mov    %esp,%ebp
80100993:	57                   	push   %edi
80100994:	56                   	push   %esi
80100995:	53                   	push   %ebx
80100996:	83 ec 0c             	sub    $0xc,%esp
  for (i = 0; input.buf[i] != '\0'; i++)
80100999:	0f b6 05 80 fe 10 80 	movzbl 0x8010fe80,%eax
801009a0:	88 45 f3             	mov    %al,-0xd(%ebp)
801009a3:	84 c0                	test   %al,%al
801009a5:	0f 84 ad 00 00 00    	je     80100a58 <getLastCommand+0xc8>
801009ab:	31 d2                	xor    %edx,%edx
801009ad:	8d 76 00             	lea    0x0(%esi),%esi
801009b0:	89 d6                	mov    %edx,%esi
801009b2:	83 c2 01             	add    $0x1,%edx
801009b5:	80 ba 80 fe 10 80 00 	cmpb   $0x0,-0x7fef0180(%edx)
801009bc:	75 f2                	jne    801009b0 <getLastCommand+0x20>
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
801009be:	80 be 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%esi)
801009c5:	89 f0                	mov    %esi,%eax
801009c7:	75 0c                	jne    801009d5 <getLastCommand+0x45>
801009c9:	e9 8a 00 00 00       	jmp    80100a58 <getLastCommand+0xc8>
801009ce:	66 90                	xchg   %ax,%ax
801009d0:	83 f8 ff             	cmp    $0xffffffff,%eax
801009d3:	74 7b                	je     80100a50 <getLastCommand+0xc0>
801009d5:	89 c7                	mov    %eax,%edi
801009d7:	83 e8 01             	sub    $0x1,%eax
801009da:	80 b8 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%eax)
801009e1:	75 ed                	jne    801009d0 <getLastCommand+0x40>
  for (h = k+1; h < i; h++)
801009e3:	39 fa                	cmp    %edi,%edx
801009e5:	7e 71                	jle    80100a58 <getLastCommand+0xc8>
    result[h-k-1] = input.buf[h];
801009e7:	0f b6 9f 80 fe 10 80 	movzbl -0x7fef0180(%edi),%ebx
801009ee:	88 5d f3             	mov    %bl,-0xd(%ebp)
801009f1:	89 c3                	mov    %eax,%ebx
801009f3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  int h = k + 1;
801009f6:	89 f9                	mov    %edi,%ecx
    result[h-k-1] = input.buf[h];
801009f8:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
801009fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801009ff:	f7 db                	neg    %ebx
80100a01:	eb 0e                	jmp    80100a11 <getLastCommand+0x81>
80100a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a07:	90                   	nop
80100a08:	0f b6 90 80 fe 10 80 	movzbl -0x7fef0180(%eax),%edx
80100a0f:	89 c1                	mov    %eax,%ecx
80100a11:	88 94 0b 1f 09 11 80 	mov    %dl,-0x7feef6e1(%ebx,%ecx,1)
  for (h = k+1; h < i; h++)
80100a18:	8d 41 01             	lea    0x1(%ecx),%eax
80100a1b:	39 ce                	cmp    %ecx,%esi
80100a1d:	7f e9                	jg     80100a08 <getLastCommand+0x78>
80100a1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100a22:	29 fe                	sub    %edi,%esi
80100a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100a27:	39 fa                	cmp    %edi,%edx
80100a29:	ba 00 00 00 00       	mov    $0x0,%edx
80100a2e:	0f 4e f2             	cmovle %edx,%esi
  result[h-k-1] = '\0';
80100a31:	29 c7                	sub    %eax,%edi
80100a33:	8d 04 37             	lea    (%edi,%esi,1),%eax
80100a36:	c6 80 20 09 11 80 00 	movb   $0x0,-0x7feef6e0(%eax)
}
80100a3d:	83 c4 0c             	add    $0xc,%esp
80100a40:	b8 20 09 11 80       	mov    $0x80110920,%eax
80100a45:	5b                   	pop    %ebx
80100a46:	5e                   	pop    %esi
80100a47:	5f                   	pop    %edi
80100a48:	5d                   	pop    %ebp
80100a49:	c3                   	ret    
80100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int h = k + 1;
80100a50:	31 ff                	xor    %edi,%edi
80100a52:	eb 9d                	jmp    801009f1 <getLastCommand+0x61>
80100a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
80100a58:	31 c0                	xor    %eax,%eax
80100a5a:	eb da                	jmp    80100a36 <getLastCommand+0xa6>
80100a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a60 <addNewCommandToHistory>:
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	57                   	push   %edi
80100a64:	56                   	push   %esi
  for (int i = 0; i < HISTORYSIZE; i++)
80100a65:	31 f6                	xor    %esi,%esi
{
80100a67:	53                   	push   %ebx
80100a68:	83 ec 04             	sub    $0x4,%esp
80100a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a6f:	90                   	nop
    if (historyBuf[i][0] == '\0')
80100a70:	89 f0                	mov    %esi,%eax
80100a72:	c1 e0 07             	shl    $0x7,%eax
80100a75:	80 b8 20 04 11 80 00 	cmpb   $0x0,-0x7feefbe0(%eax)
80100a7c:	74 64                	je     80100ae2 <addNewCommandToHistory+0x82>
  for (int i = 0; i < HISTORYSIZE; i++)
80100a7e:	83 c6 01             	add    $0x1,%esi
80100a81:	83 fe 0a             	cmp    $0xa,%esi
80100a84:	75 ea                	jne    80100a70 <addNewCommandToHistory+0x10>
  int freeIndex = HISTORYSIZE-1;
80100a86:	be 09 00 00 00       	mov    $0x9,%esi
80100a8b:	89 f3                	mov    %esi,%ebx
80100a8d:	c1 e3 07             	shl    $0x7,%ebx
80100a90:	8d 7b 80             	lea    -0x80(%ebx),%edi
80100a93:	89 f9                	mov    %edi,%ecx
80100a95:	8d 76 00             	lea    0x0(%esi),%esi
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100a98:	0f b6 91 20 04 11 80 	movzbl -0x7feefbe0(%ecx),%edx
80100a9f:	89 75 f0             	mov    %esi,-0x10(%ebp)
80100aa2:	31 c0                	xor    %eax,%eax
80100aa4:	83 ee 01             	sub    $0x1,%esi
80100aa7:	84 d2                	test   %dl,%dl
80100aa9:	74 1b                	je     80100ac6 <addNewCommandToHistory+0x66>
80100aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100aaf:	90                   	nop
      historyBuf[i][j] = historyBuf[i-1][j];
80100ab0:	88 94 03 20 04 11 80 	mov    %dl,-0x7feefbe0(%ebx,%eax,1)
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100ab7:	83 c0 01             	add    $0x1,%eax
80100aba:	0f b6 94 01 20 04 11 	movzbl -0x7feefbe0(%ecx,%eax,1),%edx
80100ac1:	80 
80100ac2:	84 d2                	test   %dl,%dl
80100ac4:	75 ea                	jne    80100ab0 <addNewCommandToHistory+0x50>
    historyBuf[i][j] = '\0';
80100ac6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  for (int i = freeIndex; i >= 1; i--)
80100ac9:	89 fb                	mov    %edi,%ebx
80100acb:	83 c1 80             	add    $0xffffff80,%ecx
    historyBuf[i][j] = '\0';
80100ace:	c1 e2 07             	shl    $0x7,%edx
80100ad1:	c6 84 10 20 04 11 80 	movb   $0x0,-0x7feefbe0(%eax,%edx,1)
80100ad8:	00 
  for (int i = freeIndex; i >= 1; i--)
80100ad9:	85 f6                	test   %esi,%esi
80100adb:	74 13                	je     80100af0 <addNewCommandToHistory+0x90>
80100add:	83 c7 80             	add    $0xffffff80,%edi
80100ae0:	eb b6                	jmp    80100a98 <addNewCommandToHistory+0x38>
80100ae2:	85 f6                	test   %esi,%esi
80100ae4:	75 a5                	jne    80100a8b <addNewCommandToHistory+0x2b>
80100ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aed:	8d 76 00             	lea    0x0(%esi),%esi
  char* res = getLastCommand();
80100af0:	e8 9b fe ff ff       	call   80100990 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100af5:	31 d2                	xor    %edx,%edx
80100af7:	0f b6 08             	movzbl (%eax),%ecx
80100afa:	84 c9                	test   %cl,%cl
80100afc:	74 13                	je     80100b11 <addNewCommandToHistory+0xb1>
80100afe:	66 90                	xchg   %ax,%ax
    historyBuf[0][i] = res[i];
80100b00:	88 8a 20 04 11 80    	mov    %cl,-0x7feefbe0(%edx)
  for (i = 0; res[i] != '\0'; i++)
80100b06:	83 c2 01             	add    $0x1,%edx
80100b09:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100b0d:	84 c9                	test   %cl,%cl
80100b0f:	75 ef                	jne    80100b00 <addNewCommandToHistory+0xa0>
  historyBuf[0][i] = '\0';
80100b11:	c6 82 20 04 11 80 00 	movb   $0x0,-0x7feefbe0(%edx)
}
80100b18:	83 c4 04             	add    $0x4,%esp
80100b1b:	5b                   	pop    %ebx
80100b1c:	5e                   	pop    %esi
80100b1d:	5f                   	pop    %edi
80100b1e:	5d                   	pop    %ebp
80100b1f:	c3                   	ret    

80100b20 <checkHistoryCommand>:
{
80100b20:	55                   	push   %ebp
80100b21:	89 e5                	mov    %esp,%ebp
80100b23:	56                   	push   %esi
80100b24:	53                   	push   %ebx
80100b25:	83 ec 10             	sub    $0x10,%esp
80100b28:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char checkCommand[] = "history";
80100b2b:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
80100b32:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100b39:	0f b6 13             	movzbl (%ebx),%edx
80100b3c:	84 d2                	test   %dl,%dl
80100b3e:	74 30                	je     80100b70 <checkHistoryCommand+0x50>
80100b40:	b9 68 00 00 00       	mov    $0x68,%ecx
80100b45:	31 c0                	xor    %eax,%eax
  int flag = 1;
80100b47:	be 01 00 00 00       	mov    $0x1,%esi
80100b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100b50:	83 f8 06             	cmp    $0x6,%eax
80100b53:	7f 04                	jg     80100b59 <checkHistoryCommand+0x39>
80100b55:	38 ca                	cmp    %cl,%dl
80100b57:	74 02                	je     80100b5b <checkHistoryCommand+0x3b>
      flag = 0;
80100b59:	31 f6                	xor    %esi,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
80100b5b:	83 c0 01             	add    $0x1,%eax
80100b5e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80100b62:	84 d2                	test   %dl,%dl
80100b64:	74 0c                	je     80100b72 <checkHistoryCommand+0x52>
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100b66:	0f b6 4c 05 f0       	movzbl -0x10(%ebp,%eax,1),%ecx
80100b6b:	eb e3                	jmp    80100b50 <checkHistoryCommand+0x30>
80100b6d:	8d 76 00             	lea    0x0(%esi),%esi
    flag = 0;
80100b70:	31 f6                	xor    %esi,%esi
}
80100b72:	83 c4 10             	add    $0x10,%esp
80100b75:	89 f0                	mov    %esi,%eax
80100b77:	5b                   	pop    %ebx
80100b78:	5e                   	pop    %esi
80100b79:	5d                   	pop    %ebp
80100b7a:	c3                   	ret    
80100b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b7f:	90                   	nop

80100b80 <print>:
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	53                   	push   %ebx
80100b84:	83 ec 04             	sub    $0x4,%esp
80100b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = 0; message[i] != '\0'; i++)
80100b8a:	0f be 03             	movsbl (%ebx),%eax
80100b8d:	84 c0                	test   %al,%al
80100b8f:	74 26                	je     80100bb7 <print+0x37>
80100b91:	83 c3 01             	add    $0x1,%ebx
  if(panicked) {
80100b94:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
80100b9a:	85 d2                	test   %edx,%edx
80100b9c:	74 0a                	je     80100ba8 <print+0x28>
  asm volatile("cli");
80100b9e:	fa                   	cli    
    for(;;)
80100b9f:	eb fe                	jmp    80100b9f <print+0x1f>
80100ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ba8:	e8 53 f8 ff ff       	call   80100400 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100bad:	0f be 03             	movsbl (%ebx),%eax
80100bb0:	83 c3 01             	add    $0x1,%ebx
80100bb3:	84 c0                	test   %al,%al
80100bb5:	75 dd                	jne    80100b94 <print+0x14>
}
80100bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100bba:	c9                   	leave  
80100bbb:	c3                   	ret    
80100bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100bc0 <doHistoryCommand>:
  if(panicked) {
80100bc0:	8b 0d dc 09 11 80    	mov    0x801109dc,%ecx
80100bc6:	85 c9                	test   %ecx,%ecx
80100bc8:	74 06                	je     80100bd0 <doHistoryCommand+0x10>
80100bca:	fa                   	cli    
    for(;;)
80100bcb:	eb fe                	jmp    80100bcb <doHistoryCommand+0xb>
80100bcd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100bd0:	55                   	push   %ebp
80100bd1:	b8 0a 00 00 00       	mov    $0xa,%eax
80100bd6:	89 e5                	mov    %esp,%ebp
80100bd8:	57                   	push   %edi
80100bd9:	56                   	push   %esi
80100bda:	53                   	push   %ebx
80100bdb:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80100bde:	83 ec 3c             	sub    $0x3c,%esp
80100be1:	e8 1a f8 ff ff       	call   80100400 <consputc.part.0>
  char message[] = "here are the lastest commands : ";
80100be6:	c7 45 c7 68 65 72 65 	movl   $0x65726568,-0x39(%ebp)
  for (int i = 0; message[i] != '\0'; i++)
80100bed:	b8 68 00 00 00       	mov    $0x68,%eax
  char message[] = "here are the lastest commands : ";
80100bf2:	c7 45 cb 20 61 72 65 	movl   $0x65726120,-0x35(%ebp)
80100bf9:	c7 45 cf 20 74 68 65 	movl   $0x65687420,-0x31(%ebp)
80100c00:	c7 45 d3 20 6c 61 73 	movl   $0x73616c20,-0x2d(%ebp)
80100c07:	c7 45 d7 74 65 73 74 	movl   $0x74736574,-0x29(%ebp)
80100c0e:	c7 45 db 20 63 6f 6d 	movl   $0x6d6f6320,-0x25(%ebp)
80100c15:	c7 45 df 6d 61 6e 64 	movl   $0x646e616d,-0x21(%ebp)
80100c1c:	c7 45 e3 73 20 3a 20 	movl   $0x203a2073,-0x1d(%ebp)
80100c23:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  if(panicked) {
80100c27:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
80100c2d:	85 d2                	test   %edx,%edx
80100c2f:	74 07                	je     80100c38 <doHistoryCommand+0x78>
80100c31:	fa                   	cli    
    for(;;)
80100c32:	eb fe                	jmp    80100c32 <doHistoryCommand+0x72>
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c38:	e8 c3 f7 ff ff       	call   80100400 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100c3d:	0f be 03             	movsbl (%ebx),%eax
80100c40:	83 c3 01             	add    $0x1,%ebx
80100c43:	84 c0                	test   %al,%al
80100c45:	75 e0                	jne    80100c27 <doHistoryCommand+0x67>
  if(panicked) {
80100c47:	8b 1d dc 09 11 80    	mov    0x801109dc,%ebx
80100c4d:	85 db                	test   %ebx,%ebx
80100c4f:	75 7f                	jne    80100cd0 <doHistoryCommand+0x110>
80100c51:	b8 0a 00 00 00       	mov    $0xa,%eax
80100c56:	e8 a5 f7 ff ff       	call   80100400 <consputc.part.0>
  for (i = 0; i < HISTORYSIZE && historyBuf[i][0] != '\0' ; i++)
80100c5b:	89 d8                	mov    %ebx,%eax
80100c5d:	c1 e0 07             	shl    $0x7,%eax
80100c60:	80 b8 20 04 11 80 00 	cmpb   $0x0,-0x7feefbe0(%eax)
80100c67:	74 77                	je     80100ce0 <doHistoryCommand+0x120>
80100c69:	83 c3 01             	add    $0x1,%ebx
80100c6c:	83 fb 0a             	cmp    $0xa,%ebx
80100c6f:	75 ea                	jne    80100c5b <doHistoryCommand+0x9b>
  printint(i,10,1);
80100c71:	b8 09 00 00 00       	mov    $0x9,%eax
80100c76:	b9 01 00 00 00       	mov    $0x1,%ecx
80100c7b:	ba 0a 00 00 00       	mov    $0xa,%edx
80100c80:	e8 db f9 ff ff       	call   80100660 <printint>
  if(panicked) {
80100c85:	a1 dc 09 11 80       	mov    0x801109dc,%eax
80100c8a:	85 c0                	test   %eax,%eax
80100c8c:	75 4a                	jne    80100cd8 <doHistoryCommand+0x118>
80100c8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  i--;
80100c93:	bb 09 00 00 00       	mov    $0x9,%ebx
80100c98:	e8 63 f7 ff ff       	call   80100400 <consputc.part.0>
  for (i ; i >= 0; i--)
80100c9d:	89 de                	mov    %ebx,%esi
80100c9f:	c1 e6 07             	shl    $0x7,%esi
80100ca2:	81 c6 20 04 11 80    	add    $0x80110420,%esi
    printint(i+1,10 ,1);
80100ca8:	8d 43 01             	lea    0x1(%ebx),%eax
80100cab:	b9 01 00 00 00       	mov    $0x1,%ecx
80100cb0:	ba 0a 00 00 00       	mov    $0xa,%edx
80100cb5:	e8 a6 f9 ff ff       	call   80100660 <printint>
  if(panicked) {
80100cba:	8b 3d dc 09 11 80    	mov    0x801109dc,%edi
80100cc0:	85 ff                	test   %edi,%edi
80100cc2:	74 50                	je     80100d14 <doHistoryCommand+0x154>
80100cc4:	fa                   	cli    
    for(;;)
80100cc5:	eb fe                	jmp    80100cc5 <doHistoryCommand+0x105>
80100cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cce:	66 90                	xchg   %ax,%ax
80100cd0:	fa                   	cli    
80100cd1:	eb fe                	jmp    80100cd1 <doHistoryCommand+0x111>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	fa                   	cli    
80100cd9:	eb fe                	jmp    80100cd9 <doHistoryCommand+0x119>
80100cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cdf:	90                   	nop
  i--;
80100ce0:	83 eb 01             	sub    $0x1,%ebx
  printint(i,10,1);
80100ce3:	b9 01 00 00 00       	mov    $0x1,%ecx
80100ce8:	ba 0a 00 00 00       	mov    $0xa,%edx
80100ced:	89 d8                	mov    %ebx,%eax
80100cef:	e8 6c f9 ff ff       	call   80100660 <printint>
  if(panicked) {
80100cf4:	a1 dc 09 11 80       	mov    0x801109dc,%eax
80100cf9:	85 c0                	test   %eax,%eax
80100cfb:	75 db                	jne    80100cd8 <doHistoryCommand+0x118>
80100cfd:	b8 0a 00 00 00       	mov    $0xa,%eax
80100d02:	e8 f9 f6 ff ff       	call   80100400 <consputc.part.0>
  for (i ; i >= 0; i--)
80100d07:	83 fb ff             	cmp    $0xffffffff,%ebx
80100d0a:	75 91                	jne    80100c9d <doHistoryCommand+0xdd>
}
80100d0c:	83 c4 3c             	add    $0x3c,%esp
80100d0f:	5b                   	pop    %ebx
80100d10:	5e                   	pop    %esi
80100d11:	5f                   	pop    %edi
80100d12:	5d                   	pop    %ebp
80100d13:	c3                   	ret    
80100d14:	b8 3a 00 00 00       	mov    $0x3a,%eax
80100d19:	8d 7e 01             	lea    0x1(%esi),%edi
80100d1c:	e8 df f6 ff ff       	call   80100400 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100d21:	0f be 06             	movsbl (%esi),%eax
80100d24:	84 c0                	test   %al,%al
80100d26:	74 1f                	je     80100d47 <doHistoryCommand+0x187>
  if(panicked) {
80100d28:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
80100d2e:	85 d2                	test   %edx,%edx
80100d30:	74 06                	je     80100d38 <doHistoryCommand+0x178>
80100d32:	fa                   	cli    
    for(;;)
80100d33:	eb fe                	jmp    80100d33 <doHistoryCommand+0x173>
80100d35:	8d 76 00             	lea    0x0(%esi),%esi
80100d38:	e8 c3 f6 ff ff       	call   80100400 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100d3d:	0f be 07             	movsbl (%edi),%eax
80100d40:	83 c7 01             	add    $0x1,%edi
80100d43:	84 c0                	test   %al,%al
80100d45:	75 e1                	jne    80100d28 <doHistoryCommand+0x168>
  if(panicked) {
80100d47:	8b 0d dc 09 11 80    	mov    0x801109dc,%ecx
80100d4d:	85 c9                	test   %ecx,%ecx
80100d4f:	74 07                	je     80100d58 <doHistoryCommand+0x198>
80100d51:	fa                   	cli    
    for(;;)
80100d52:	eb fe                	jmp    80100d52 <doHistoryCommand+0x192>
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d58:	b8 0a 00 00 00       	mov    $0xa,%eax
  for (i ; i >= 0; i--)
80100d5d:	83 eb 01             	sub    $0x1,%ebx
80100d60:	83 c6 80             	add    $0xffffff80,%esi
80100d63:	e8 98 f6 ff ff       	call   80100400 <consputc.part.0>
80100d68:	83 fb ff             	cmp    $0xffffffff,%ebx
80100d6b:	0f 85 37 ff ff ff    	jne    80100ca8 <doHistoryCommand+0xe8>
80100d71:	eb 99                	jmp    80100d0c <doHistoryCommand+0x14c>
80100d73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <controlNewCommand>:
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	56                   	push   %esi
80100d84:	53                   	push   %ebx
80100d85:	83 ec 10             	sub    $0x10,%esp
  char* lastCommand = getLastCommand();
80100d88:	e8 03 fc ff ff       	call   80100990 <getLastCommand>
  char checkCommand[] = "history";
80100d8d:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100d94:	0f b6 08             	movzbl (%eax),%ecx
  char checkCommand[] = "history";
80100d97:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100d9e:	84 c9                	test   %cl,%cl
80100da0:	74 3e                	je     80100de0 <controlNewCommand+0x60>
80100da2:	bb 68 00 00 00       	mov    $0x68,%ebx
  int flag = 1;
80100da7:	be 01 00 00 00       	mov    $0x1,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
80100dac:	31 d2                	xor    %edx,%edx
80100dae:	66 90                	xchg   %ax,%ax
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100db0:	38 d9                	cmp    %bl,%cl
80100db2:	75 05                	jne    80100db9 <controlNewCommand+0x39>
80100db4:	83 fa 06             	cmp    $0x6,%edx
80100db7:	7e 02                	jle    80100dbb <controlNewCommand+0x3b>
      flag = 0;
80100db9:	31 f6                	xor    %esi,%esi
  for (i = 0; lastCommand[i] != '\0'; i++)
80100dbb:	83 c2 01             	add    $0x1,%edx
80100dbe:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100dc2:	84 c9                	test   %cl,%cl
80100dc4:	74 0a                	je     80100dd0 <controlNewCommand+0x50>
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100dc6:	0f b6 5c 15 f0       	movzbl -0x10(%ebp,%edx,1),%ebx
80100dcb:	eb e3                	jmp    80100db0 <controlNewCommand+0x30>
80100dcd:	8d 76 00             	lea    0x0(%esi),%esi
  if (checkHistoryCommand(lastCommand))
80100dd0:	85 f6                	test   %esi,%esi
80100dd2:	74 0c                	je     80100de0 <controlNewCommand+0x60>
}
80100dd4:	83 c4 10             	add    $0x10,%esp
80100dd7:	5b                   	pop    %ebx
80100dd8:	5e                   	pop    %esi
80100dd9:	5d                   	pop    %ebp
    doHistoryCommand();
80100dda:	e9 e1 fd ff ff       	jmp    80100bc0 <doHistoryCommand>
80100ddf:	90                   	nop
}
80100de0:	83 c4 10             	add    $0x10,%esp
80100de3:	5b                   	pop    %ebx
80100de4:	5e                   	pop    %esi
80100de5:	5d                   	pop    %ebp
80100de6:	c3                   	ret    
80100de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100dee:	66 90                	xchg   %ax,%ax

80100df0 <consoleintr>:
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	57                   	push   %edi
  int c, doprocdump = 0;
80100df4:	31 ff                	xor    %edi,%edi
{
80100df6:	56                   	push   %esi
80100df7:	53                   	push   %ebx
80100df8:	83 ec 28             	sub    $0x28,%esp
80100dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100dfe:	68 a0 09 11 80       	push   $0x801109a0
{
80100e03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80100e06:	e8 d5 3f 00 00       	call   80104de0 <acquire>
  while((c = getc()) >= 0){
80100e0b:	83 c4 10             	add    $0x10,%esp
80100e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e11:	ff d0                	call   *%eax
80100e13:	89 c3                	mov    %eax,%ebx
80100e15:	85 c0                	test   %eax,%eax
80100e17:	0f 88 13 01 00 00    	js     80100f30 <consoleintr+0x140>
    switch(c){
80100e1d:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100e23:	0f 84 77 02 00 00    	je     801010a0 <consoleintr+0x2b0>
80100e29:	7f 5d                	jg     80100e88 <consoleintr+0x98>
80100e2b:	83 fb 15             	cmp    $0x15,%ebx
80100e2e:	0f 84 2c 02 00 00    	je     80101060 <consoleintr+0x270>
80100e34:	0f 8e 16 01 00 00    	jle    80100f50 <consoleintr+0x160>
80100e3a:	83 fb 7f             	cmp    $0x7f,%ebx
80100e3d:	0f 85 dd 02 00 00    	jne    80101120 <consoleintr+0x330>
        if(input.e != input.w && input.e - input.w > cap) {
80100e43:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e48:	8b 15 04 ff 10 80    	mov    0x8010ff04,%edx
80100e4e:	39 d0                	cmp    %edx,%eax
80100e50:	74 bc                	je     80100e0e <consoleintr+0x1e>
80100e52:	89 c3                	mov    %eax,%ebx
80100e54:	8b 0d d8 09 11 80    	mov    0x801109d8,%ecx
80100e5a:	29 d3                	sub    %edx,%ebx
80100e5c:	39 cb                	cmp    %ecx,%ebx
80100e5e:	76 ae                	jbe    80100e0e <consoleintr+0x1e>
          if (cap > 0)
80100e60:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100e63:	85 c9                	test   %ecx,%ecx
80100e65:	0f 8f 9b 03 00 00    	jg     80101206 <consoleintr+0x416>
          input.e--;
80100e6b:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
  if(panicked) {
80100e71:	8b 1d dc 09 11 80    	mov    0x801109dc,%ebx
80100e77:	85 db                	test   %ebx,%ebx
80100e79:	0f 84 51 03 00 00    	je     801011d0 <consoleintr+0x3e0>
80100e7f:	fa                   	cli    
    for(;;)
80100e80:	eb fe                	jmp    80100e80 <consoleintr+0x90>
80100e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100e88:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100e8e:	0f 84 1c 01 00 00    	je     80100fb0 <consoleintr+0x1c0>
80100e94:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100e9a:	0f 85 d0 00 00 00    	jne    80100f70 <consoleintr+0x180>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ea0:	be d4 03 00 00       	mov    $0x3d4,%esi
80100ea5:	b8 0e 00 00 00       	mov    $0xe,%eax
80100eaa:	89 f2                	mov    %esi,%edx
80100eac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ead:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100eb2:	89 ca                	mov    %ecx,%edx
80100eb4:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100eb5:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100eb8:	89 f2                	mov    %esi,%edx
80100eba:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ebf:	c1 e3 08             	shl    $0x8,%ebx
80100ec2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ec3:	89 ca                	mov    %ecx,%edx
80100ec5:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100ec6:	0f b6 c8             	movzbl %al,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
80100ec9:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT + 1);
80100ece:	09 d9                	or     %ebx,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
80100ed0:	89 c8                	mov    %ecx,%eax
80100ed2:	f7 e2                	mul    %edx
80100ed4:	c1 ea 06             	shr    $0x6,%edx
80100ed7:	8d 44 92 05          	lea    0x5(%edx,%edx,4),%eax
80100edb:	c1 e0 04             	shl    $0x4,%eax
80100ede:	83 e8 01             	sub    $0x1,%eax
  if ((pos < last_index_line) && (cap > 0))
80100ee1:	39 c1                	cmp    %eax,%ecx
80100ee3:	7d 14                	jge    80100ef9 <consoleintr+0x109>
80100ee5:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80100eea:	85 c0                	test   %eax,%eax
80100eec:	7e 0b                	jle    80100ef9 <consoleintr+0x109>
    cap--;
80100eee:	83 e8 01             	sub    $0x1,%eax
    pos++;
80100ef1:	83 c1 01             	add    $0x1,%ecx
    cap--;
80100ef4:	a3 d8 09 11 80       	mov    %eax,0x801109d8
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ef9:	be d4 03 00 00       	mov    $0x3d4,%esi
80100efe:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f03:	89 f2                	mov    %esi,%edx
80100f05:	ee                   	out    %al,(%dx)
80100f06:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
80100f0b:	89 c8                	mov    %ecx,%eax
80100f0d:	c1 f8 08             	sar    $0x8,%eax
80100f10:	89 da                	mov    %ebx,%edx
80100f12:	ee                   	out    %al,(%dx)
80100f13:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f18:	89 f2                	mov    %esi,%edx
80100f1a:	ee                   	out    %al,(%dx)
80100f1b:	89 c8                	mov    %ecx,%eax
80100f1d:	89 da                	mov    %ebx,%edx
80100f1f:	ee                   	out    %al,(%dx)
  while((c = getc()) >= 0){
80100f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f23:	ff d0                	call   *%eax
80100f25:	89 c3                	mov    %eax,%ebx
80100f27:	85 c0                	test   %eax,%eax
80100f29:	0f 89 ee fe ff ff    	jns    80100e1d <consoleintr+0x2d>
80100f2f:	90                   	nop
  release(&cons.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
80100f33:	68 a0 09 11 80       	push   $0x801109a0
80100f38:	e8 43 3e 00 00       	call   80104d80 <release>
  if(doprocdump) {
80100f3d:	83 c4 10             	add    $0x10,%esp
80100f40:	85 ff                	test   %edi,%edi
80100f42:	0f 85 ac 01 00 00    	jne    801010f4 <consoleintr+0x304>
}
80100f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4b:	5b                   	pop    %ebx
80100f4c:	5e                   	pop    %esi
80100f4d:	5f                   	pop    %edi
80100f4e:	5d                   	pop    %ebp
80100f4f:	c3                   	ret    
    switch(c){
80100f50:	83 fb 08             	cmp    $0x8,%ebx
80100f53:	0f 84 ea fe ff ff    	je     80100e43 <consoleintr+0x53>
80100f59:	83 fb 10             	cmp    $0x10,%ebx
80100f5c:	0f 85 ae 01 00 00    	jne    80101110 <consoleintr+0x320>
80100f62:	bf 01 00 00 00       	mov    $0x1,%edi
80100f67:	e9 a2 fe ff ff       	jmp    80100e0e <consoleintr+0x1e>
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f70:	be 4d 7a 10 80       	mov    $0x80107a4d,%esi
  for (int i = 0; message[i] != '\0'; i++)
80100f75:	b8 44 00 00 00       	mov    $0x44,%eax
    switch(c){
80100f7a:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80100f80:	0f 85 9a 01 00 00    	jne    80101120 <consoleintr+0x330>
  if(panicked) {
80100f86:	8b 15 dc 09 11 80    	mov    0x801109dc,%edx
80100f8c:	85 d2                	test   %edx,%edx
80100f8e:	74 08                	je     80100f98 <consoleintr+0x1a8>
  asm volatile("cli");
80100f90:	fa                   	cli    
    for(;;)
80100f91:	eb fe                	jmp    80100f91 <consoleintr+0x1a1>
80100f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f97:	90                   	nop
80100f98:	e8 63 f4 ff ff       	call   80100400 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
80100f9d:	0f be 06             	movsbl (%esi),%eax
80100fa0:	83 c6 01             	add    $0x1,%esi
80100fa3:	84 c0                	test   %al,%al
80100fa5:	75 df                	jne    80100f86 <consoleintr+0x196>
80100fa7:	e9 62 fe ff ff       	jmp    80100e0e <consoleintr+0x1e>
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if ((input.e - cap) > input.w) 
80100fb0:	8b 0d d8 09 11 80    	mov    0x801109d8,%ecx
80100fb6:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100fbb:	29 c8                	sub    %ecx,%eax
80100fbd:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100fc3:	0f 86 45 fe ff ff    	jbe    80100e0e <consoleintr+0x1e>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100fc9:	be d4 03 00 00       	mov    $0x3d4,%esi
80100fce:	b8 0e 00 00 00       	mov    $0xe,%eax
80100fd3:	89 f2                	mov    %esi,%edx
80100fd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100fd6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100fdb:	89 da                	mov    %ebx,%edx
80100fdd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100fde:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100fe1:	89 f2                	mov    %esi,%edx
80100fe3:	c1 e0 08             	shl    $0x8,%eax
80100fe6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100fe9:	b8 0f 00 00 00       	mov    $0xf,%eax
80100fee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100fef:	89 da                	mov    %ebx,%edx
80100ff1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100ff2:	0f b6 d8             	movzbl %al,%ebx
80100ff5:	0b 5d e0             	or     -0x20(%ebp),%ebx
  int first_write_index = NUMCOL * ((int) pos / NUMCOL) + 2;
80100ff8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100ffd:	89 d8                	mov    %ebx,%eax
80100fff:	f7 e2                	mul    %edx
80101001:	c1 ea 06             	shr    $0x6,%edx
80101004:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101007:	c1 e0 04             	shl    $0x4,%eax
8010100a:	83 c0 02             	add    $0x2,%eax
  if(pos >= first_write_index  && crt[pos - 2] != ('$' | 0x0700))
8010100d:	39 c3                	cmp    %eax,%ebx
8010100f:	0f 8c eb 00 00 00    	jl     80101100 <consoleintr+0x310>
80101015:	66 81 bc 1b fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ebx,%ebx,1)
8010101c:	80 24 07 
8010101f:	0f 84 db 00 00 00    	je     80101100 <consoleintr+0x310>
    pos--;
80101025:	83 eb 01             	sub    $0x1,%ebx
    cap++;
80101028:	83 c1 01             	add    $0x1,%ecx
8010102b:	89 0d d8 09 11 80    	mov    %ecx,0x801109d8
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101031:	be d4 03 00 00       	mov    $0x3d4,%esi
80101036:	b8 0e 00 00 00       	mov    $0xe,%eax
8010103b:	89 f2                	mov    %esi,%edx
8010103d:	ee                   	out    %al,(%dx)
8010103e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT + 1, pos >> 8);
80101043:	89 d8                	mov    %ebx,%eax
80101045:	c1 f8 08             	sar    $0x8,%eax
80101048:	89 ca                	mov    %ecx,%edx
8010104a:	ee                   	out    %al,(%dx)
8010104b:	b8 0f 00 00 00       	mov    $0xf,%eax
80101050:	89 f2                	mov    %esi,%edx
80101052:	ee                   	out    %al,(%dx)
80101053:	89 d8                	mov    %ebx,%eax
80101055:	89 ca                	mov    %ecx,%edx
80101057:	ee                   	out    %al,(%dx)
}
80101058:	e9 b1 fd ff ff       	jmp    80100e0e <consoleintr+0x1e>
8010105d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80101060:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101065:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010106b:	0f 84 9d fd ff ff    	je     80100e0e <consoleintr+0x1e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80101071:	83 e8 01             	sub    $0x1,%eax
80101074:	89 c2                	mov    %eax,%edx
80101076:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80101079:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80101080:	0f 84 88 fd ff ff    	je     80100e0e <consoleintr+0x1e>
  if(panicked) {
80101086:	8b 35 dc 09 11 80    	mov    0x801109dc,%esi
        input.e--;
8010108c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked) {
80101091:	85 f6                	test   %esi,%esi
80101093:	74 2b                	je     801010c0 <consoleintr+0x2d0>
  asm volatile("cli");
80101095:	fa                   	cli    
    for(;;)
80101096:	eb fe                	jmp    80101096 <consoleintr+0x2a6>
80101098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop
801010a0:	bb 49 7a 10 80       	mov    $0x80107a49,%ebx
  for (int i = 0; message[i] != '\0'; i++)
801010a5:	b8 55 00 00 00       	mov    $0x55,%eax
  if(panicked) {
801010aa:	8b 0d dc 09 11 80    	mov    0x801109dc,%ecx
801010b0:	85 c9                	test   %ecx,%ecx
801010b2:	74 2c                	je     801010e0 <consoleintr+0x2f0>
801010b4:	fa                   	cli    
    for(;;)
801010b5:	eb fe                	jmp    801010b5 <consoleintr+0x2c5>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
801010c0:	b8 00 01 00 00       	mov    $0x100,%eax
801010c5:	e8 36 f3 ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801010ca:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801010cf:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801010d5:	75 9a                	jne    80101071 <consoleintr+0x281>
801010d7:	e9 32 fd ff ff       	jmp    80100e0e <consoleintr+0x1e>
801010dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010e0:	e8 1b f3 ff ff       	call   80100400 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
801010e5:	0f be 03             	movsbl (%ebx),%eax
801010e8:	83 c3 01             	add    $0x1,%ebx
801010eb:	84 c0                	test   %al,%al
801010ed:	75 bb                	jne    801010aa <consoleintr+0x2ba>
801010ef:	e9 1a fd ff ff       	jmp    80100e0e <consoleintr+0x1e>
}
801010f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f7:	5b                   	pop    %ebx
801010f8:	5e                   	pop    %esi
801010f9:	5f                   	pop    %edi
801010fa:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801010fb:	e9 20 39 00 00       	jmp    80104a20 <procdump>
  if (pos+1 >= first_write_index)
80101100:	8d 53 01             	lea    0x1(%ebx),%edx
80101103:	39 d0                	cmp    %edx,%eax
80101105:	0f 8f 26 ff ff ff    	jg     80101031 <consoleintr+0x241>
8010110b:	e9 18 ff ff ff       	jmp    80101028 <consoleintr+0x238>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101110:	85 db                	test   %ebx,%ebx
80101112:	0f 84 f6 fc ff ff    	je     80100e0e <consoleintr+0x1e>
80101118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010111f:	90                   	nop
80101120:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101125:	89 c2                	mov    %eax,%edx
80101127:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010112d:	83 fa 7f             	cmp    $0x7f,%edx
80101130:	0f 87 d8 fc ff ff    	ja     80100e0e <consoleintr+0x1e>
        if (c=='\n'){
80101136:	83 fb 0d             	cmp    $0xd,%ebx
80101139:	0f 84 a0 00 00 00    	je     801011df <consoleintr+0x3ef>
8010113f:	83 fb 0a             	cmp    $0xa,%ebx
80101142:	0f 84 97 00 00 00    	je     801011df <consoleintr+0x3ef>
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101148:	88 5d e0             	mov    %bl,-0x20(%ebp)
  for (int i = input.e; i > input.e - cap; i--)
8010114b:	8b 35 d8 09 11 80    	mov    0x801109d8,%esi
80101151:	89 c1                	mov    %eax,%ecx
80101153:	89 c2                	mov    %eax,%edx
80101155:	29 f1                	sub    %esi,%ecx
80101157:	39 c1                	cmp    %eax,%ecx
80101159:	73 48                	jae    801011a3 <consoleintr+0x3b3>
8010115b:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010115e:	89 df                	mov    %ebx,%edi
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
80101160:	89 d0                	mov    %edx,%eax
80101162:	83 ea 01             	sub    $0x1,%edx
80101165:	89 d3                	mov    %edx,%ebx
80101167:	c1 fb 1f             	sar    $0x1f,%ebx
8010116a:	c1 eb 19             	shr    $0x19,%ebx
8010116d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101170:	83 e1 7f             	and    $0x7f,%ecx
80101173:	29 d9                	sub    %ebx,%ecx
80101175:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
8010117c:	89 c1                	mov    %eax,%ecx
8010117e:	c1 f9 1f             	sar    $0x1f,%ecx
80101181:	c1 e9 19             	shr    $0x19,%ecx
80101184:	01 c8                	add    %ecx,%eax
80101186:	83 e0 7f             	and    $0x7f,%eax
80101189:	29 c8                	sub    %ecx,%eax
8010118b:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101191:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101196:	89 c1                	mov    %eax,%ecx
80101198:	29 f1                	sub    %esi,%ecx
8010119a:	39 d1                	cmp    %edx,%ecx
8010119c:	72 c2                	jb     80101160 <consoleintr+0x370>
8010119e:	89 fb                	mov    %edi,%ebx
801011a0:	8b 7d dc             	mov    -0x24(%ebp),%edi
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
801011a3:	83 c0 01             	add    $0x1,%eax
801011a6:	83 e1 7f             	and    $0x7f,%ecx
801011a9:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
801011ae:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
801011b2:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked) {
801011b8:	a1 dc 09 11 80       	mov    0x801109dc,%eax
801011bd:	85 c0                	test   %eax,%eax
801011bf:	0f 84 94 00 00 00    	je     80101259 <consoleintr+0x469>
801011c5:	fa                   	cli    
    for(;;)
801011c6:	eb fe                	jmp    801011c6 <consoleintr+0x3d6>
801011c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011cf:	90                   	nop
801011d0:	b8 00 01 00 00       	mov    $0x100,%eax
801011d5:	e8 26 f2 ff ff       	call   80100400 <consputc.part.0>
801011da:	e9 2f fc ff ff       	jmp    80100e0e <consoleintr+0x1e>
          cap = 0;
801011df:	c7 05 d8 09 11 80 00 	movl   $0x0,0x801109d8
801011e6:	00 00 00 
  for (int i = input.e; i > input.e - cap; i--)
801011e9:	bb 0a 00 00 00       	mov    $0xa,%ebx
          addNewCommandToHistory();
801011ee:	e8 6d f8 ff ff       	call   80100a60 <addNewCommandToHistory>
          controlNewCommand();
801011f3:	e8 88 fb ff ff       	call   80100d80 <controlNewCommand>
  for (int i = input.e; i > input.e - cap; i--)
801011f8:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
801011fc:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101201:	e9 45 ff ff ff       	jmp    8010114b <consoleintr+0x35b>
  for (int i = input.e - cap - 1; i < input.e; i++)
80101206:	89 da                	mov    %ebx,%edx
80101208:	29 ca                	sub    %ecx,%edx
8010120a:	39 d0                	cmp    %edx,%eax
8010120c:	76 3f                	jbe    8010124d <consoleintr+0x45d>
8010120e:	66 90                	xchg   %ax,%ax
    buf[(i) % INPUT_BUF] = buf[(i + 1) % INPUT_BUF]; // Shift elements to left
80101210:	89 d0                	mov    %edx,%eax
80101212:	83 c2 01             	add    $0x1,%edx
80101215:	89 d3                	mov    %edx,%ebx
80101217:	c1 fb 1f             	sar    $0x1f,%ebx
8010121a:	c1 eb 19             	shr    $0x19,%ebx
8010121d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101220:	83 e1 7f             	and    $0x7f,%ecx
80101223:	29 d9                	sub    %ebx,%ecx
80101225:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
8010122c:	89 c1                	mov    %eax,%ecx
8010122e:	c1 f9 1f             	sar    $0x1f,%ecx
80101231:	c1 e9 19             	shr    $0x19,%ecx
80101234:	01 c8                	add    %ecx,%eax
80101236:	83 e0 7f             	and    $0x7f,%eax
80101239:	29 c8                	sub    %ecx,%eax
8010123b:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  for (int i = input.e - cap - 1; i < input.e; i++)
80101241:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101246:	39 d0                	cmp    %edx,%eax
80101248:	77 c6                	ja     80101210 <consoleintr+0x420>
          input.e--;
8010124a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  input.buf[input.e] = ' ';
8010124d:	c6 80 80 fe 10 80 20 	movb   $0x20,-0x7fef0180(%eax)
}
80101254:	e9 12 fc ff ff       	jmp    80100e6b <consoleintr+0x7b>
80101259:	89 d8                	mov    %ebx,%eax
8010125b:	e8 a0 f1 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101260:	83 fb 0a             	cmp    $0xa,%ebx
80101263:	74 33                	je     80101298 <consoleintr+0x4a8>
80101265:	83 fb 04             	cmp    $0x4,%ebx
80101268:	74 2e                	je     80101298 <consoleintr+0x4a8>
8010126a:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010126f:	83 e8 80             	sub    $0xffffff80,%eax
80101272:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80101278:	0f 85 90 fb ff ff    	jne    80100e0e <consoleintr+0x1e>
          wakeup(&input.r);
8010127e:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101281:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80101286:	68 00 ff 10 80       	push   $0x8010ff00
8010128b:	e8 b0 36 00 00       	call   80104940 <wakeup>
80101290:	83 c4 10             	add    $0x10,%esp
80101293:	e9 76 fb ff ff       	jmp    80100e0e <consoleintr+0x1e>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101298:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010129d:	eb df                	jmp    8010127e <consoleintr+0x48e>
8010129f:	90                   	nop

801012a0 <consoleinit>:

void
consoleinit(void)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801012a6:	68 52 7a 10 80       	push   $0x80107a52
801012ab:	68 a0 09 11 80       	push   $0x801109a0
801012b0:	e8 5b 39 00 00       	call   80104c10 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801012b5:	58                   	pop    %eax
801012b6:	5a                   	pop    %edx
801012b7:	6a 00                	push   $0x0
801012b9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801012bb:	c7 05 8c 13 11 80 f0 	movl   $0x801005f0,0x8011138c
801012c2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801012c5:	c7 05 88 13 11 80 80 	movl   $0x80100280,0x80111388
801012cc:	02 10 80 
  cons.locking = 1;
801012cf:	c7 05 d4 09 11 80 01 	movl   $0x1,0x801109d4
801012d6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801012d9:	e8 e2 19 00 00       	call   80102cc0 <ioapicenable>
801012de:	83 c4 10             	add    $0x10,%esp
801012e1:	c9                   	leave  
801012e2:	c3                   	ret    
801012e3:	66 90                	xchg   %ax,%ax
801012e5:	66 90                	xchg   %ax,%ax
801012e7:	66 90                	xchg   %ax,%ax
801012e9:	66 90                	xchg   %ax,%ax
801012eb:	66 90                	xchg   %ax,%ax
801012ed:	66 90                	xchg   %ax,%ax
801012ef:	90                   	nop

801012f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801012fc:	e8 af 2e 00 00       	call   801041b0 <myproc>
80101301:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101307:	e8 94 22 00 00       	call   801035a0 <begin_op>

  if((ip = namei(path)) == 0){
8010130c:	83 ec 0c             	sub    $0xc,%esp
8010130f:	ff 75 08             	push   0x8(%ebp)
80101312:	e8 c9 15 00 00       	call   801028e0 <namei>
80101317:	83 c4 10             	add    $0x10,%esp
8010131a:	85 c0                	test   %eax,%eax
8010131c:	0f 84 02 03 00 00    	je     80101624 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101322:	83 ec 0c             	sub    $0xc,%esp
80101325:	89 c3                	mov    %eax,%ebx
80101327:	50                   	push   %eax
80101328:	e8 93 0c 00 00       	call   80101fc0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010132d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101333:	6a 34                	push   $0x34
80101335:	6a 00                	push   $0x0
80101337:	50                   	push   %eax
80101338:	53                   	push   %ebx
80101339:	e8 92 0f 00 00       	call   801022d0 <readi>
8010133e:	83 c4 20             	add    $0x20,%esp
80101341:	83 f8 34             	cmp    $0x34,%eax
80101344:	74 22                	je     80101368 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101346:	83 ec 0c             	sub    $0xc,%esp
80101349:	53                   	push   %ebx
8010134a:	e8 01 0f 00 00       	call   80102250 <iunlockput>
    end_op();
8010134f:	e8 bc 22 00 00       	call   80103610 <end_op>
80101354:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010135c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135f:	5b                   	pop    %ebx
80101360:	5e                   	pop    %esi
80101361:	5f                   	pop    %edi
80101362:	5d                   	pop    %ebp
80101363:	c3                   	ret    
80101364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101368:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010136f:	45 4c 46 
80101372:	75 d2                	jne    80101346 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101374:	e8 07 63 00 00       	call   80107680 <setupkvm>
80101379:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010137f:	85 c0                	test   %eax,%eax
80101381:	74 c3                	je     80101346 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101383:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
8010138a:	00 
8010138b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101391:	0f 84 ac 02 00 00    	je     80101643 <exec+0x353>
  sz = 0;
80101397:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
8010139e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801013a1:	31 ff                	xor    %edi,%edi
801013a3:	e9 8e 00 00 00       	jmp    80101436 <exec+0x146>
801013a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013af:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
801013b0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801013b7:	75 6c                	jne    80101425 <exec+0x135>
    if(ph.memsz < ph.filesz)
801013b9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801013bf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801013c5:	0f 82 87 00 00 00    	jb     80101452 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801013cb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801013d1:	72 7f                	jb     80101452 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801013d3:	83 ec 04             	sub    $0x4,%esp
801013d6:	50                   	push   %eax
801013d7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801013dd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801013e3:	e8 b8 60 00 00       	call   801074a0 <allocuvm>
801013e8:	83 c4 10             	add    $0x10,%esp
801013eb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801013f1:	85 c0                	test   %eax,%eax
801013f3:	74 5d                	je     80101452 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
801013f5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801013fb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101400:	75 50                	jne    80101452 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101402:	83 ec 0c             	sub    $0xc,%esp
80101405:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010140b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101411:	53                   	push   %ebx
80101412:	50                   	push   %eax
80101413:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101419:	e8 92 5f 00 00       	call   801073b0 <loaduvm>
8010141e:	83 c4 20             	add    $0x20,%esp
80101421:	85 c0                	test   %eax,%eax
80101423:	78 2d                	js     80101452 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101425:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010142c:	83 c7 01             	add    $0x1,%edi
8010142f:	83 c6 20             	add    $0x20,%esi
80101432:	39 f8                	cmp    %edi,%eax
80101434:	7e 3a                	jle    80101470 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101436:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010143c:	6a 20                	push   $0x20
8010143e:	56                   	push   %esi
8010143f:	50                   	push   %eax
80101440:	53                   	push   %ebx
80101441:	e8 8a 0e 00 00       	call   801022d0 <readi>
80101446:	83 c4 10             	add    $0x10,%esp
80101449:	83 f8 20             	cmp    $0x20,%eax
8010144c:	0f 84 5e ff ff ff    	je     801013b0 <exec+0xc0>
    freevm(pgdir);
80101452:	83 ec 0c             	sub    $0xc,%esp
80101455:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010145b:	e8 a0 61 00 00       	call   80107600 <freevm>
  if(ip){
80101460:	83 c4 10             	add    $0x10,%esp
80101463:	e9 de fe ff ff       	jmp    80101346 <exec+0x56>
80101468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146f:	90                   	nop
  sz = PGROUNDUP(sz);
80101470:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101476:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010147c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101482:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101488:	83 ec 0c             	sub    $0xc,%esp
8010148b:	53                   	push   %ebx
8010148c:	e8 bf 0d 00 00       	call   80102250 <iunlockput>
  end_op();
80101491:	e8 7a 21 00 00       	call   80103610 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101496:	83 c4 0c             	add    $0xc,%esp
80101499:	56                   	push   %esi
8010149a:	57                   	push   %edi
8010149b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801014a1:	57                   	push   %edi
801014a2:	e8 f9 5f 00 00       	call   801074a0 <allocuvm>
801014a7:	83 c4 10             	add    $0x10,%esp
801014aa:	89 c6                	mov    %eax,%esi
801014ac:	85 c0                	test   %eax,%eax
801014ae:	0f 84 94 00 00 00    	je     80101548 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014b4:	83 ec 08             	sub    $0x8,%esp
801014b7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801014bd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014bf:	50                   	push   %eax
801014c0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801014c1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014c3:	e8 58 62 00 00       	call   80107720 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801014d4:	8b 00                	mov    (%eax),%eax
801014d6:	85 c0                	test   %eax,%eax
801014d8:	0f 84 8b 00 00 00    	je     80101569 <exec+0x279>
801014de:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801014e4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801014ea:	eb 23                	jmp    8010150f <exec+0x21f>
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801014f3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801014fa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801014fd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101503:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101506:	85 c0                	test   %eax,%eax
80101508:	74 59                	je     80101563 <exec+0x273>
    if(argc >= MAXARG)
8010150a:	83 ff 20             	cmp    $0x20,%edi
8010150d:	74 39                	je     80101548 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010150f:	83 ec 0c             	sub    $0xc,%esp
80101512:	50                   	push   %eax
80101513:	e8 88 3b 00 00       	call   801050a0 <strlen>
80101518:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010151a:	58                   	pop    %eax
8010151b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010151e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101521:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101524:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101527:	e8 74 3b 00 00       	call   801050a0 <strlen>
8010152c:	83 c0 01             	add    $0x1,%eax
8010152f:	50                   	push   %eax
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	ff 34 b8             	push   (%eax,%edi,4)
80101536:	53                   	push   %ebx
80101537:	56                   	push   %esi
80101538:	e8 b3 63 00 00       	call   801078f0 <copyout>
8010153d:	83 c4 20             	add    $0x20,%esp
80101540:	85 c0                	test   %eax,%eax
80101542:	79 ac                	jns    801014f0 <exec+0x200>
80101544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101548:	83 ec 0c             	sub    $0xc,%esp
8010154b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101551:	e8 aa 60 00 00       	call   80107600 <freevm>
80101556:	83 c4 10             	add    $0x10,%esp
  return -1;
80101559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010155e:	e9 f9 fd ff ff       	jmp    8010135c <exec+0x6c>
80101563:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101569:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101570:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101572:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101579:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010157d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010157f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101582:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101588:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010158a:	50                   	push   %eax
8010158b:	52                   	push   %edx
8010158c:	53                   	push   %ebx
8010158d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101593:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010159a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010159d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801015a3:	e8 48 63 00 00       	call   801078f0 <copyout>
801015a8:	83 c4 10             	add    $0x10,%esp
801015ab:	85 c0                	test   %eax,%eax
801015ad:	78 99                	js     80101548 <exec+0x258>
  for(last=s=path; *s; s++)
801015af:	8b 45 08             	mov    0x8(%ebp),%eax
801015b2:	8b 55 08             	mov    0x8(%ebp),%edx
801015b5:	0f b6 00             	movzbl (%eax),%eax
801015b8:	84 c0                	test   %al,%al
801015ba:	74 13                	je     801015cf <exec+0x2df>
801015bc:	89 d1                	mov    %edx,%ecx
801015be:	66 90                	xchg   %ax,%ax
      last = s+1;
801015c0:	83 c1 01             	add    $0x1,%ecx
801015c3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801015c5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
801015c8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801015cb:	84 c0                	test   %al,%al
801015cd:	75 f1                	jne    801015c0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801015cf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801015d5:	83 ec 04             	sub    $0x4,%esp
801015d8:	6a 10                	push   $0x10
801015da:	89 f8                	mov    %edi,%eax
801015dc:	52                   	push   %edx
801015dd:	83 c0 6c             	add    $0x6c,%eax
801015e0:	50                   	push   %eax
801015e1:	e8 7a 3a 00 00       	call   80105060 <safestrcpy>
  curproc->pgdir = pgdir;
801015e6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801015ec:	89 f8                	mov    %edi,%eax
801015ee:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801015f1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801015f3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801015f6:	89 c1                	mov    %eax,%ecx
801015f8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801015fe:	8b 40 18             	mov    0x18(%eax),%eax
80101601:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101604:	8b 41 18             	mov    0x18(%ecx),%eax
80101607:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010160a:	89 0c 24             	mov    %ecx,(%esp)
8010160d:	e8 0e 5c 00 00       	call   80107220 <switchuvm>
  freevm(oldpgdir);
80101612:	89 3c 24             	mov    %edi,(%esp)
80101615:	e8 e6 5f 00 00       	call   80107600 <freevm>
  return 0;
8010161a:	83 c4 10             	add    $0x10,%esp
8010161d:	31 c0                	xor    %eax,%eax
8010161f:	e9 38 fd ff ff       	jmp    8010135c <exec+0x6c>
    end_op();
80101624:	e8 e7 1f 00 00       	call   80103610 <end_op>
    cprintf("exec: fail\n");
80101629:	83 ec 0c             	sub    $0xc,%esp
8010162c:	68 6d 7a 10 80       	push   $0x80107a6d
80101631:	e8 ca f0 ff ff       	call   80100700 <cprintf>
    return -1;
80101636:	83 c4 10             	add    $0x10,%esp
80101639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010163e:	e9 19 fd ff ff       	jmp    8010135c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101643:	be 00 20 00 00       	mov    $0x2000,%esi
80101648:	31 ff                	xor    %edi,%edi
8010164a:	e9 39 fe ff ff       	jmp    80101488 <exec+0x198>
8010164f:	90                   	nop

80101650 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101656:	68 79 7a 10 80       	push   $0x80107a79
8010165b:	68 e0 09 11 80       	push   $0x801109e0
80101660:	e8 ab 35 00 00       	call   80104c10 <initlock>
}
80101665:	83 c4 10             	add    $0x10,%esp
80101668:	c9                   	leave  
80101669:	c3                   	ret    
8010166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101670 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101674:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
80101679:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010167c:	68 e0 09 11 80       	push   $0x801109e0
80101681:	e8 5a 37 00 00       	call   80104de0 <acquire>
80101686:	83 c4 10             	add    $0x10,%esp
80101689:	eb 10                	jmp    8010169b <filealloc+0x2b>
8010168b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010168f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101690:	83 c3 18             	add    $0x18,%ebx
80101693:	81 fb 74 13 11 80    	cmp    $0x80111374,%ebx
80101699:	74 25                	je     801016c0 <filealloc+0x50>
    if(f->ref == 0){
8010169b:	8b 43 04             	mov    0x4(%ebx),%eax
8010169e:	85 c0                	test   %eax,%eax
801016a0:	75 ee                	jne    80101690 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801016a2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801016a5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801016ac:	68 e0 09 11 80       	push   $0x801109e0
801016b1:	e8 ca 36 00 00       	call   80104d80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801016b6:	89 d8                	mov    %ebx,%eax
      return f;
801016b8:	83 c4 10             	add    $0x10,%esp
}
801016bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016be:	c9                   	leave  
801016bf:	c3                   	ret    
  release(&ftable.lock);
801016c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801016c3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801016c5:	68 e0 09 11 80       	push   $0x801109e0
801016ca:	e8 b1 36 00 00       	call   80104d80 <release>
}
801016cf:	89 d8                	mov    %ebx,%eax
  return 0;
801016d1:	83 c4 10             	add    $0x10,%esp
}
801016d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016d7:	c9                   	leave  
801016d8:	c3                   	ret    
801016d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801016e0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	83 ec 10             	sub    $0x10,%esp
801016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801016ea:	68 e0 09 11 80       	push   $0x801109e0
801016ef:	e8 ec 36 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
801016f4:	8b 43 04             	mov    0x4(%ebx),%eax
801016f7:	83 c4 10             	add    $0x10,%esp
801016fa:	85 c0                	test   %eax,%eax
801016fc:	7e 1a                	jle    80101718 <filedup+0x38>
    panic("filedup");
  f->ref++;
801016fe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101701:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101704:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101707:	68 e0 09 11 80       	push   $0x801109e0
8010170c:	e8 6f 36 00 00       	call   80104d80 <release>
  return f;
}
80101711:	89 d8                	mov    %ebx,%eax
80101713:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101716:	c9                   	leave  
80101717:	c3                   	ret    
    panic("filedup");
80101718:	83 ec 0c             	sub    $0xc,%esp
8010171b:	68 80 7a 10 80       	push   $0x80107a80
80101720:	e8 5b ec ff ff       	call   80100380 <panic>
80101725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101730 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	57                   	push   %edi
80101734:	56                   	push   %esi
80101735:	53                   	push   %ebx
80101736:	83 ec 28             	sub    $0x28,%esp
80101739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010173c:	68 e0 09 11 80       	push   $0x801109e0
80101741:	e8 9a 36 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
80101746:	8b 53 04             	mov    0x4(%ebx),%edx
80101749:	83 c4 10             	add    $0x10,%esp
8010174c:	85 d2                	test   %edx,%edx
8010174e:	0f 8e a5 00 00 00    	jle    801017f9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101754:	83 ea 01             	sub    $0x1,%edx
80101757:	89 53 04             	mov    %edx,0x4(%ebx)
8010175a:	75 44                	jne    801017a0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010175c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101760:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101763:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101765:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010176b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010176e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101771:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101774:	68 e0 09 11 80       	push   $0x801109e0
  ff = *f;
80101779:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010177c:	e8 ff 35 00 00       	call   80104d80 <release>

  if(ff.type == FD_PIPE)
80101781:	83 c4 10             	add    $0x10,%esp
80101784:	83 ff 01             	cmp    $0x1,%edi
80101787:	74 57                	je     801017e0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101789:	83 ff 02             	cmp    $0x2,%edi
8010178c:	74 2a                	je     801017b8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010178e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101791:	5b                   	pop    %ebx
80101792:	5e                   	pop    %esi
80101793:	5f                   	pop    %edi
80101794:	5d                   	pop    %ebp
80101795:	c3                   	ret    
80101796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010179d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801017a0:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017aa:	5b                   	pop    %ebx
801017ab:	5e                   	pop    %esi
801017ac:	5f                   	pop    %edi
801017ad:	5d                   	pop    %ebp
    release(&ftable.lock);
801017ae:	e9 cd 35 00 00       	jmp    80104d80 <release>
801017b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017b7:	90                   	nop
    begin_op();
801017b8:	e8 e3 1d 00 00       	call   801035a0 <begin_op>
    iput(ff.ip);
801017bd:	83 ec 0c             	sub    $0xc,%esp
801017c0:	ff 75 e0             	push   -0x20(%ebp)
801017c3:	e8 28 09 00 00       	call   801020f0 <iput>
    end_op();
801017c8:	83 c4 10             	add    $0x10,%esp
}
801017cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ce:	5b                   	pop    %ebx
801017cf:	5e                   	pop    %esi
801017d0:	5f                   	pop    %edi
801017d1:	5d                   	pop    %ebp
    end_op();
801017d2:	e9 39 1e 00 00       	jmp    80103610 <end_op>
801017d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017de:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801017e0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801017e4:	83 ec 08             	sub    $0x8,%esp
801017e7:	53                   	push   %ebx
801017e8:	56                   	push   %esi
801017e9:	e8 82 25 00 00       	call   80103d70 <pipeclose>
801017ee:	83 c4 10             	add    $0x10,%esp
}
801017f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f4:	5b                   	pop    %ebx
801017f5:	5e                   	pop    %esi
801017f6:	5f                   	pop    %edi
801017f7:	5d                   	pop    %ebp
801017f8:	c3                   	ret    
    panic("fileclose");
801017f9:	83 ec 0c             	sub    $0xc,%esp
801017fc:	68 88 7a 10 80       	push   $0x80107a88
80101801:	e8 7a eb ff ff       	call   80100380 <panic>
80101806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180d:	8d 76 00             	lea    0x0(%esi),%esi

80101810 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	53                   	push   %ebx
80101814:	83 ec 04             	sub    $0x4,%esp
80101817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010181a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010181d:	75 31                	jne    80101850 <filestat+0x40>
    ilock(f->ip);
8010181f:	83 ec 0c             	sub    $0xc,%esp
80101822:	ff 73 10             	push   0x10(%ebx)
80101825:	e8 96 07 00 00       	call   80101fc0 <ilock>
    stati(f->ip, st);
8010182a:	58                   	pop    %eax
8010182b:	5a                   	pop    %edx
8010182c:	ff 75 0c             	push   0xc(%ebp)
8010182f:	ff 73 10             	push   0x10(%ebx)
80101832:	e8 69 0a 00 00       	call   801022a0 <stati>
    iunlock(f->ip);
80101837:	59                   	pop    %ecx
80101838:	ff 73 10             	push   0x10(%ebx)
8010183b:	e8 60 08 00 00       	call   801020a0 <iunlock>
    return 0;
  }
  return -1;
}
80101840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101843:	83 c4 10             	add    $0x10,%esp
80101846:	31 c0                	xor    %eax,%eax
}
80101848:	c9                   	leave  
80101849:	c3                   	ret    
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101858:	c9                   	leave  
80101859:	c3                   	ret    
8010185a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101860 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	57                   	push   %edi
80101864:	56                   	push   %esi
80101865:	53                   	push   %ebx
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010186c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010186f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101872:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101876:	74 60                	je     801018d8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101878:	8b 03                	mov    (%ebx),%eax
8010187a:	83 f8 01             	cmp    $0x1,%eax
8010187d:	74 41                	je     801018c0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010187f:	83 f8 02             	cmp    $0x2,%eax
80101882:	75 5b                	jne    801018df <fileread+0x7f>
    ilock(f->ip);
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	ff 73 10             	push   0x10(%ebx)
8010188a:	e8 31 07 00 00       	call   80101fc0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010188f:	57                   	push   %edi
80101890:	ff 73 14             	push   0x14(%ebx)
80101893:	56                   	push   %esi
80101894:	ff 73 10             	push   0x10(%ebx)
80101897:	e8 34 0a 00 00       	call   801022d0 <readi>
8010189c:	83 c4 20             	add    $0x20,%esp
8010189f:	89 c6                	mov    %eax,%esi
801018a1:	85 c0                	test   %eax,%eax
801018a3:	7e 03                	jle    801018a8 <fileread+0x48>
      f->off += r;
801018a5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	ff 73 10             	push   0x10(%ebx)
801018ae:	e8 ed 07 00 00       	call   801020a0 <iunlock>
    return r;
801018b3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801018b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b9:	89 f0                	mov    %esi,%eax
801018bb:	5b                   	pop    %ebx
801018bc:	5e                   	pop    %esi
801018bd:	5f                   	pop    %edi
801018be:	5d                   	pop    %ebp
801018bf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801018c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801018c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801018c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018c9:	5b                   	pop    %ebx
801018ca:	5e                   	pop    %esi
801018cb:	5f                   	pop    %edi
801018cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801018cd:	e9 3e 26 00 00       	jmp    80103f10 <piperead>
801018d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801018d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801018dd:	eb d7                	jmp    801018b6 <fileread+0x56>
  panic("fileread");
801018df:	83 ec 0c             	sub    $0xc,%esp
801018e2:	68 92 7a 10 80       	push   $0x80107a92
801018e7:	e8 94 ea ff ff       	call   80100380 <panic>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	53                   	push   %ebx
801018f6:	83 ec 1c             	sub    $0x1c,%esp
801018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801018fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101902:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101905:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010190c:	0f 84 bd 00 00 00    	je     801019cf <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101912:	8b 03                	mov    (%ebx),%eax
80101914:	83 f8 01             	cmp    $0x1,%eax
80101917:	0f 84 bf 00 00 00    	je     801019dc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010191d:	83 f8 02             	cmp    $0x2,%eax
80101920:	0f 85 c8 00 00 00    	jne    801019ee <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101929:	31 f6                	xor    %esi,%esi
    while(i < n){
8010192b:	85 c0                	test   %eax,%eax
8010192d:	7f 30                	jg     8010195f <filewrite+0x6f>
8010192f:	e9 94 00 00 00       	jmp    801019c8 <filewrite+0xd8>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101938:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010193b:	83 ec 0c             	sub    $0xc,%esp
8010193e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101941:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101944:	e8 57 07 00 00       	call   801020a0 <iunlock>
      end_op();
80101949:	e8 c2 1c 00 00       	call   80103610 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010194e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101951:	83 c4 10             	add    $0x10,%esp
80101954:	39 c7                	cmp    %eax,%edi
80101956:	75 5c                	jne    801019b4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101958:	01 fe                	add    %edi,%esi
    while(i < n){
8010195a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010195d:	7e 69                	jle    801019c8 <filewrite+0xd8>
      int n1 = n - i;
8010195f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101962:	b8 00 06 00 00       	mov    $0x600,%eax
80101967:	29 f7                	sub    %esi,%edi
80101969:	39 c7                	cmp    %eax,%edi
8010196b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010196e:	e8 2d 1c 00 00       	call   801035a0 <begin_op>
      ilock(f->ip);
80101973:	83 ec 0c             	sub    $0xc,%esp
80101976:	ff 73 10             	push   0x10(%ebx)
80101979:	e8 42 06 00 00       	call   80101fc0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010197e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101981:	57                   	push   %edi
80101982:	ff 73 14             	push   0x14(%ebx)
80101985:	01 f0                	add    %esi,%eax
80101987:	50                   	push   %eax
80101988:	ff 73 10             	push   0x10(%ebx)
8010198b:	e8 40 0a 00 00       	call   801023d0 <writei>
80101990:	83 c4 20             	add    $0x20,%esp
80101993:	85 c0                	test   %eax,%eax
80101995:	7f a1                	jg     80101938 <filewrite+0x48>
      iunlock(f->ip);
80101997:	83 ec 0c             	sub    $0xc,%esp
8010199a:	ff 73 10             	push   0x10(%ebx)
8010199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801019a0:	e8 fb 06 00 00       	call   801020a0 <iunlock>
      end_op();
801019a5:	e8 66 1c 00 00       	call   80103610 <end_op>
      if(r < 0)
801019aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019ad:	83 c4 10             	add    $0x10,%esp
801019b0:	85 c0                	test   %eax,%eax
801019b2:	75 1b                	jne    801019cf <filewrite+0xdf>
        panic("short filewrite");
801019b4:	83 ec 0c             	sub    $0xc,%esp
801019b7:	68 9b 7a 10 80       	push   $0x80107a9b
801019bc:	e8 bf e9 ff ff       	call   80100380 <panic>
801019c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801019c8:	89 f0                	mov    %esi,%eax
801019ca:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801019cd:	74 05                	je     801019d4 <filewrite+0xe4>
801019cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801019d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019d7:	5b                   	pop    %ebx
801019d8:	5e                   	pop    %esi
801019d9:	5f                   	pop    %edi
801019da:	5d                   	pop    %ebp
801019db:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801019dc:	8b 43 0c             	mov    0xc(%ebx),%eax
801019df:	89 45 08             	mov    %eax,0x8(%ebp)
}
801019e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019e5:	5b                   	pop    %ebx
801019e6:	5e                   	pop    %esi
801019e7:	5f                   	pop    %edi
801019e8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801019e9:	e9 22 24 00 00       	jmp    80103e10 <pipewrite>
  panic("filewrite");
801019ee:	83 ec 0c             	sub    $0xc,%esp
801019f1:	68 a1 7a 10 80       	push   $0x80107aa1
801019f6:	e8 85 e9 ff ff       	call   80100380 <panic>
801019fb:	66 90                	xchg   %ax,%ax
801019fd:	66 90                	xchg   %ax,%ax
801019ff:	90                   	nop

80101a00 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101a00:	55                   	push   %ebp
80101a01:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101a03:	89 d0                	mov    %edx,%eax
80101a05:	c1 e8 0c             	shr    $0xc,%eax
80101a08:	03 05 4c 30 11 80    	add    0x8011304c,%eax
{
80101a0e:	89 e5                	mov    %esp,%ebp
80101a10:	56                   	push   %esi
80101a11:	53                   	push   %ebx
80101a12:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101a14:	83 ec 08             	sub    $0x8,%esp
80101a17:	50                   	push   %eax
80101a18:	51                   	push   %ecx
80101a19:	e8 b2 e6 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101a1e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a20:	c1 fb 03             	sar    $0x3,%ebx
80101a23:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101a26:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101a28:	83 e1 07             	and    $0x7,%ecx
80101a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101a30:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101a36:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101a38:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101a3d:	85 c1                	test   %eax,%ecx
80101a3f:	74 23                	je     80101a64 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101a41:	f7 d0                	not    %eax
  log_write(bp);
80101a43:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101a46:	21 c8                	and    %ecx,%eax
80101a48:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101a4c:	56                   	push   %esi
80101a4d:	e8 2e 1d 00 00       	call   80103780 <log_write>
  brelse(bp);
80101a52:	89 34 24             	mov    %esi,(%esp)
80101a55:	e8 96 e7 ff ff       	call   801001f0 <brelse>
}
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a60:	5b                   	pop    %ebx
80101a61:	5e                   	pop    %esi
80101a62:	5d                   	pop    %ebp
80101a63:	c3                   	ret    
    panic("freeing free block");
80101a64:	83 ec 0c             	sub    $0xc,%esp
80101a67:	68 ab 7a 10 80       	push   $0x80107aab
80101a6c:	e8 0f e9 ff ff       	call   80100380 <panic>
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop

80101a80 <balloc>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101a89:	8b 0d 34 30 11 80    	mov    0x80113034,%ecx
{
80101a8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101a92:	85 c9                	test   %ecx,%ecx
80101a94:	0f 84 87 00 00 00    	je     80101b21 <balloc+0xa1>
80101a9a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101aa1:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101aa4:	83 ec 08             	sub    $0x8,%esp
80101aa7:	89 f0                	mov    %esi,%eax
80101aa9:	c1 f8 0c             	sar    $0xc,%eax
80101aac:	03 05 4c 30 11 80    	add    0x8011304c,%eax
80101ab2:	50                   	push   %eax
80101ab3:	ff 75 d8             	push   -0x28(%ebp)
80101ab6:	e8 15 e6 ff ff       	call   801000d0 <bread>
80101abb:	83 c4 10             	add    $0x10,%esp
80101abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101ac1:	a1 34 30 11 80       	mov    0x80113034,%eax
80101ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ac9:	31 c0                	xor    %eax,%eax
80101acb:	eb 2f                	jmp    80101afc <balloc+0x7c>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101ad0:	89 c1                	mov    %eax,%ecx
80101ad2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101ad7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101ada:	83 e1 07             	and    $0x7,%ecx
80101add:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101adf:	89 c1                	mov    %eax,%ecx
80101ae1:	c1 f9 03             	sar    $0x3,%ecx
80101ae4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101ae9:	89 fa                	mov    %edi,%edx
80101aeb:	85 df                	test   %ebx,%edi
80101aed:	74 41                	je     80101b30 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101aef:	83 c0 01             	add    $0x1,%eax
80101af2:	83 c6 01             	add    $0x1,%esi
80101af5:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101afa:	74 05                	je     80101b01 <balloc+0x81>
80101afc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101aff:	77 cf                	ja     80101ad0 <balloc+0x50>
    brelse(bp);
80101b01:	83 ec 0c             	sub    $0xc,%esp
80101b04:	ff 75 e4             	push   -0x1c(%ebp)
80101b07:	e8 e4 e6 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101b0c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101b13:	83 c4 10             	add    $0x10,%esp
80101b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b19:	39 05 34 30 11 80    	cmp    %eax,0x80113034
80101b1f:	77 80                	ja     80101aa1 <balloc+0x21>
  panic("balloc: out of blocks");
80101b21:	83 ec 0c             	sub    $0xc,%esp
80101b24:	68 be 7a 10 80       	push   $0x80107abe
80101b29:	e8 52 e8 ff ff       	call   80100380 <panic>
80101b2e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101b30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101b33:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101b36:	09 da                	or     %ebx,%edx
80101b38:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101b3c:	57                   	push   %edi
80101b3d:	e8 3e 1c 00 00       	call   80103780 <log_write>
        brelse(bp);
80101b42:	89 3c 24             	mov    %edi,(%esp)
80101b45:	e8 a6 e6 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101b4a:	58                   	pop    %eax
80101b4b:	5a                   	pop    %edx
80101b4c:	56                   	push   %esi
80101b4d:	ff 75 d8             	push   -0x28(%ebp)
80101b50:	e8 7b e5 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101b55:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101b58:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101b5a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b5d:	68 00 02 00 00       	push   $0x200
80101b62:	6a 00                	push   $0x0
80101b64:	50                   	push   %eax
80101b65:	e8 36 33 00 00       	call   80104ea0 <memset>
  log_write(bp);
80101b6a:	89 1c 24             	mov    %ebx,(%esp)
80101b6d:	e8 0e 1c 00 00       	call   80103780 <log_write>
  brelse(bp);
80101b72:	89 1c 24             	mov    %ebx,(%esp)
80101b75:	e8 76 e6 ff ff       	call   801001f0 <brelse>
}
80101b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7d:	89 f0                	mov    %esi,%eax
80101b7f:	5b                   	pop    %ebx
80101b80:	5e                   	pop    %esi
80101b81:	5f                   	pop    %edi
80101b82:	5d                   	pop    %ebp
80101b83:	c3                   	ret    
80101b84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	89 c7                	mov    %eax,%edi
80101b96:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101b97:	31 f6                	xor    %esi,%esi
{
80101b99:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b9a:	bb 14 14 11 80       	mov    $0x80111414,%ebx
{
80101b9f:	83 ec 28             	sub    $0x28,%esp
80101ba2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101ba5:	68 e0 13 11 80       	push   $0x801113e0
80101baa:	e8 31 32 00 00       	call   80104de0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101baf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101bb2:	83 c4 10             	add    $0x10,%esp
80101bb5:	eb 1b                	jmp    80101bd2 <iget+0x42>
80101bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bbe:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bc0:	39 3b                	cmp    %edi,(%ebx)
80101bc2:	74 6c                	je     80101c30 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bc4:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101bca:	81 fb 34 30 11 80    	cmp    $0x80113034,%ebx
80101bd0:	73 26                	jae    80101bf8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bd2:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd5:	85 c0                	test   %eax,%eax
80101bd7:	7f e7                	jg     80101bc0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101bd9:	85 f6                	test   %esi,%esi
80101bdb:	75 e7                	jne    80101bc4 <iget+0x34>
80101bdd:	85 c0                	test   %eax,%eax
80101bdf:	75 76                	jne    80101c57 <iget+0xc7>
80101be1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101be3:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101be9:	81 fb 34 30 11 80    	cmp    $0x80113034,%ebx
80101bef:	72 e1                	jb     80101bd2 <iget+0x42>
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	74 79                	je     80101c75 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101bfc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101bff:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101c01:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101c04:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101c0b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101c12:	68 e0 13 11 80       	push   $0x801113e0
80101c17:	e8 64 31 00 00       	call   80104d80 <release>

  return ip;
80101c1c:	83 c4 10             	add    $0x10,%esp
}
80101c1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c22:	89 f0                	mov    %esi,%eax
80101c24:	5b                   	pop    %ebx
80101c25:	5e                   	pop    %esi
80101c26:	5f                   	pop    %edi
80101c27:	5d                   	pop    %ebp
80101c28:	c3                   	ret    
80101c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c30:	39 53 04             	cmp    %edx,0x4(%ebx)
80101c33:	75 8f                	jne    80101bc4 <iget+0x34>
      release(&icache.lock);
80101c35:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101c38:	83 c0 01             	add    $0x1,%eax
      return ip;
80101c3b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101c3d:	68 e0 13 11 80       	push   $0x801113e0
      ip->ref++;
80101c42:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101c45:	e8 36 31 00 00       	call   80104d80 <release>
      return ip;
80101c4a:	83 c4 10             	add    $0x10,%esp
}
80101c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c50:	89 f0                	mov    %esi,%eax
80101c52:	5b                   	pop    %ebx
80101c53:	5e                   	pop    %esi
80101c54:	5f                   	pop    %edi
80101c55:	5d                   	pop    %ebp
80101c56:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c57:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c5d:	81 fb 34 30 11 80    	cmp    $0x80113034,%ebx
80101c63:	73 10                	jae    80101c75 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c65:	8b 43 08             	mov    0x8(%ebx),%eax
80101c68:	85 c0                	test   %eax,%eax
80101c6a:	0f 8f 50 ff ff ff    	jg     80101bc0 <iget+0x30>
80101c70:	e9 68 ff ff ff       	jmp    80101bdd <iget+0x4d>
    panic("iget: no inodes");
80101c75:	83 ec 0c             	sub    $0xc,%esp
80101c78:	68 d4 7a 10 80       	push   $0x80107ad4
80101c7d:	e8 fe e6 ff ff       	call   80100380 <panic>
80101c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c90 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	89 c6                	mov    %eax,%esi
80101c97:	53                   	push   %ebx
80101c98:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c9b:	83 fa 0b             	cmp    $0xb,%edx
80101c9e:	0f 86 8c 00 00 00    	jbe    80101d30 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101ca4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101ca7:	83 fb 7f             	cmp    $0x7f,%ebx
80101caa:	0f 87 a2 00 00 00    	ja     80101d52 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cb0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cb6:	85 c0                	test   %eax,%eax
80101cb8:	74 5e                	je     80101d18 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101cba:	83 ec 08             	sub    $0x8,%esp
80101cbd:	50                   	push   %eax
80101cbe:	ff 36                	push   (%esi)
80101cc0:	e8 0b e4 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101cc5:	83 c4 10             	add    $0x10,%esp
80101cc8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101ccc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101cce:	8b 3b                	mov    (%ebx),%edi
80101cd0:	85 ff                	test   %edi,%edi
80101cd2:	74 1c                	je     80101cf0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101cd4:	83 ec 0c             	sub    $0xc,%esp
80101cd7:	52                   	push   %edx
80101cd8:	e8 13 e5 ff ff       	call   801001f0 <brelse>
80101cdd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce3:	89 f8                	mov    %edi,%eax
80101ce5:	5b                   	pop    %ebx
80101ce6:	5e                   	pop    %esi
80101ce7:	5f                   	pop    %edi
80101ce8:	5d                   	pop    %ebp
80101ce9:	c3                   	ret    
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101cf3:	8b 06                	mov    (%esi),%eax
80101cf5:	e8 86 fd ff ff       	call   80101a80 <balloc>
      log_write(bp);
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cfd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101d00:	89 03                	mov    %eax,(%ebx)
80101d02:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101d04:	52                   	push   %edx
80101d05:	e8 76 1a 00 00       	call   80103780 <log_write>
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d0d:	83 c4 10             	add    $0x10,%esp
80101d10:	eb c2                	jmp    80101cd4 <bmap+0x44>
80101d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d18:	8b 06                	mov    (%esi),%eax
80101d1a:	e8 61 fd ff ff       	call   80101a80 <balloc>
80101d1f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101d25:	eb 93                	jmp    80101cba <bmap+0x2a>
80101d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101d30:	8d 5a 14             	lea    0x14(%edx),%ebx
80101d33:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101d37:	85 ff                	test   %edi,%edi
80101d39:	75 a5                	jne    80101ce0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d3b:	8b 00                	mov    (%eax),%eax
80101d3d:	e8 3e fd ff ff       	call   80101a80 <balloc>
80101d42:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101d46:	89 c7                	mov    %eax,%edi
}
80101d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4b:	5b                   	pop    %ebx
80101d4c:	89 f8                	mov    %edi,%eax
80101d4e:	5e                   	pop    %esi
80101d4f:	5f                   	pop    %edi
80101d50:	5d                   	pop    %ebp
80101d51:	c3                   	ret    
  panic("bmap: out of range");
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	68 e4 7a 10 80       	push   $0x80107ae4
80101d5a:	e8 21 e6 ff ff       	call   80100380 <panic>
80101d5f:	90                   	nop

80101d60 <readsb>:
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	56                   	push   %esi
80101d64:	53                   	push   %ebx
80101d65:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101d68:	83 ec 08             	sub    $0x8,%esp
80101d6b:	6a 01                	push   $0x1
80101d6d:	ff 75 08             	push   0x8(%ebp)
80101d70:	e8 5b e3 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101d75:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101d78:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101d7a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101d7d:	6a 1c                	push   $0x1c
80101d7f:	50                   	push   %eax
80101d80:	56                   	push   %esi
80101d81:	e8 ba 31 00 00       	call   80104f40 <memmove>
  brelse(bp);
80101d86:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d89:	83 c4 10             	add    $0x10,%esp
}
80101d8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d8f:	5b                   	pop    %ebx
80101d90:	5e                   	pop    %esi
80101d91:	5d                   	pop    %ebp
  brelse(bp);
80101d92:	e9 59 e4 ff ff       	jmp    801001f0 <brelse>
80101d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d9e:	66 90                	xchg   %ax,%ax

80101da0 <iinit>:
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	53                   	push   %ebx
80101da4:	bb 20 14 11 80       	mov    $0x80111420,%ebx
80101da9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101dac:	68 f7 7a 10 80       	push   $0x80107af7
80101db1:	68 e0 13 11 80       	push   $0x801113e0
80101db6:	e8 55 2e 00 00       	call   80104c10 <initlock>
  for(i = 0; i < NINODE; i++) {
80101dbb:	83 c4 10             	add    $0x10,%esp
80101dbe:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101dc0:	83 ec 08             	sub    $0x8,%esp
80101dc3:	68 fe 7a 10 80       	push   $0x80107afe
80101dc8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101dc9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101dcf:	e8 0c 2d 00 00       	call   80104ae0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101dd4:	83 c4 10             	add    $0x10,%esp
80101dd7:	81 fb 40 30 11 80    	cmp    $0x80113040,%ebx
80101ddd:	75 e1                	jne    80101dc0 <iinit+0x20>
  bp = bread(dev, 1);
80101ddf:	83 ec 08             	sub    $0x8,%esp
80101de2:	6a 01                	push   $0x1
80101de4:	ff 75 08             	push   0x8(%ebp)
80101de7:	e8 e4 e2 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101dec:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101def:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101df1:	8d 40 5c             	lea    0x5c(%eax),%eax
80101df4:	6a 1c                	push   $0x1c
80101df6:	50                   	push   %eax
80101df7:	68 34 30 11 80       	push   $0x80113034
80101dfc:	e8 3f 31 00 00       	call   80104f40 <memmove>
  brelse(bp);
80101e01:	89 1c 24             	mov    %ebx,(%esp)
80101e04:	e8 e7 e3 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101e09:	ff 35 4c 30 11 80    	push   0x8011304c
80101e0f:	ff 35 48 30 11 80    	push   0x80113048
80101e15:	ff 35 44 30 11 80    	push   0x80113044
80101e1b:	ff 35 40 30 11 80    	push   0x80113040
80101e21:	ff 35 3c 30 11 80    	push   0x8011303c
80101e27:	ff 35 38 30 11 80    	push   0x80113038
80101e2d:	ff 35 34 30 11 80    	push   0x80113034
80101e33:	68 64 7b 10 80       	push   $0x80107b64
80101e38:	e8 c3 e8 ff ff       	call   80100700 <cprintf>
}
80101e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e40:	83 c4 30             	add    $0x30,%esp
80101e43:	c9                   	leave  
80101e44:	c3                   	ret    
80101e45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <ialloc>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 1c             	sub    $0x1c,%esp
80101e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101e5c:	83 3d 3c 30 11 80 01 	cmpl   $0x1,0x8011303c
{
80101e63:	8b 75 08             	mov    0x8(%ebp),%esi
80101e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101e69:	0f 86 91 00 00 00    	jbe    80101f00 <ialloc+0xb0>
80101e6f:	bf 01 00 00 00       	mov    $0x1,%edi
80101e74:	eb 21                	jmp    80101e97 <ialloc+0x47>
80101e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101e80:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101e83:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101e86:	53                   	push   %ebx
80101e87:	e8 64 e3 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101e8c:	83 c4 10             	add    $0x10,%esp
80101e8f:	3b 3d 3c 30 11 80    	cmp    0x8011303c,%edi
80101e95:	73 69                	jae    80101f00 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101e97:	89 f8                	mov    %edi,%eax
80101e99:	83 ec 08             	sub    $0x8,%esp
80101e9c:	c1 e8 03             	shr    $0x3,%eax
80101e9f:	03 05 48 30 11 80    	add    0x80113048,%eax
80101ea5:	50                   	push   %eax
80101ea6:	56                   	push   %esi
80101ea7:	e8 24 e2 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101eac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101eaf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101eb1:	89 f8                	mov    %edi,%eax
80101eb3:	83 e0 07             	and    $0x7,%eax
80101eb6:	c1 e0 06             	shl    $0x6,%eax
80101eb9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101ebd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101ec1:	75 bd                	jne    80101e80 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101ec3:	83 ec 04             	sub    $0x4,%esp
80101ec6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ec9:	6a 40                	push   $0x40
80101ecb:	6a 00                	push   $0x0
80101ecd:	51                   	push   %ecx
80101ece:	e8 cd 2f 00 00       	call   80104ea0 <memset>
      dip->type = type;
80101ed3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101ed7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eda:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101edd:	89 1c 24             	mov    %ebx,(%esp)
80101ee0:	e8 9b 18 00 00       	call   80103780 <log_write>
      brelse(bp);
80101ee5:	89 1c 24             	mov    %ebx,(%esp)
80101ee8:	e8 03 e3 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101eed:	83 c4 10             	add    $0x10,%esp
}
80101ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101ef3:	89 fa                	mov    %edi,%edx
}
80101ef5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101ef6:	89 f0                	mov    %esi,%eax
}
80101ef8:	5e                   	pop    %esi
80101ef9:	5f                   	pop    %edi
80101efa:	5d                   	pop    %ebp
      return iget(dev, inum);
80101efb:	e9 90 fc ff ff       	jmp    80101b90 <iget>
  panic("ialloc: no inodes");
80101f00:	83 ec 0c             	sub    $0xc,%esp
80101f03:	68 04 7b 10 80       	push   $0x80107b04
80101f08:	e8 73 e4 ff ff       	call   80100380 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <iupdate>:
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	56                   	push   %esi
80101f14:	53                   	push   %ebx
80101f15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f18:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f1b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f1e:	83 ec 08             	sub    $0x8,%esp
80101f21:	c1 e8 03             	shr    $0x3,%eax
80101f24:	03 05 48 30 11 80    	add    0x80113048,%eax
80101f2a:	50                   	push   %eax
80101f2b:	ff 73 a4             	push   -0x5c(%ebx)
80101f2e:	e8 9d e1 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101f33:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f37:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f3a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101f3c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101f3f:	83 e0 07             	and    $0x7,%eax
80101f42:	c1 e0 06             	shl    $0x6,%eax
80101f45:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101f49:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101f4c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f50:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101f53:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101f57:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101f5b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101f5f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101f63:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101f67:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101f6a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f6d:	6a 34                	push   $0x34
80101f6f:	53                   	push   %ebx
80101f70:	50                   	push   %eax
80101f71:	e8 ca 2f 00 00       	call   80104f40 <memmove>
  log_write(bp);
80101f76:	89 34 24             	mov    %esi,(%esp)
80101f79:	e8 02 18 00 00       	call   80103780 <log_write>
  brelse(bp);
80101f7e:	89 75 08             	mov    %esi,0x8(%ebp)
80101f81:	83 c4 10             	add    $0x10,%esp
}
80101f84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f87:	5b                   	pop    %ebx
80101f88:	5e                   	pop    %esi
80101f89:	5d                   	pop    %ebp
  brelse(bp);
80101f8a:	e9 61 e2 ff ff       	jmp    801001f0 <brelse>
80101f8f:	90                   	nop

80101f90 <idup>:
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	53                   	push   %ebx
80101f94:	83 ec 10             	sub    $0x10,%esp
80101f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101f9a:	68 e0 13 11 80       	push   $0x801113e0
80101f9f:	e8 3c 2e 00 00       	call   80104de0 <acquire>
  ip->ref++;
80101fa4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101fa8:	c7 04 24 e0 13 11 80 	movl   $0x801113e0,(%esp)
80101faf:	e8 cc 2d 00 00       	call   80104d80 <release>
}
80101fb4:	89 d8                	mov    %ebx,%eax
80101fb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fb9:	c9                   	leave  
80101fba:	c3                   	ret    
80101fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fbf:	90                   	nop

80101fc0 <ilock>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101fc8:	85 db                	test   %ebx,%ebx
80101fca:	0f 84 b7 00 00 00    	je     80102087 <ilock+0xc7>
80101fd0:	8b 53 08             	mov    0x8(%ebx),%edx
80101fd3:	85 d2                	test   %edx,%edx
80101fd5:	0f 8e ac 00 00 00    	jle    80102087 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101fdb:	83 ec 0c             	sub    $0xc,%esp
80101fde:	8d 43 0c             	lea    0xc(%ebx),%eax
80101fe1:	50                   	push   %eax
80101fe2:	e8 39 2b 00 00       	call   80104b20 <acquiresleep>
  if(ip->valid == 0){
80101fe7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	85 c0                	test   %eax,%eax
80101fef:	74 0f                	je     80102000 <ilock+0x40>
}
80101ff1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ff4:	5b                   	pop    %ebx
80101ff5:	5e                   	pop    %esi
80101ff6:	5d                   	pop    %ebp
80101ff7:	c3                   	ret    
80101ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fff:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102000:	8b 43 04             	mov    0x4(%ebx),%eax
80102003:	83 ec 08             	sub    $0x8,%esp
80102006:	c1 e8 03             	shr    $0x3,%eax
80102009:	03 05 48 30 11 80    	add    0x80113048,%eax
8010200f:	50                   	push   %eax
80102010:	ff 33                	push   (%ebx)
80102012:	e8 b9 e0 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102017:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010201a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010201c:	8b 43 04             	mov    0x4(%ebx),%eax
8010201f:	83 e0 07             	and    $0x7,%eax
80102022:	c1 e0 06             	shl    $0x6,%eax
80102025:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102029:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010202c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010202f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102033:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102037:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010203b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010203f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102043:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102047:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010204b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010204e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102051:	6a 34                	push   $0x34
80102053:	50                   	push   %eax
80102054:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102057:	50                   	push   %eax
80102058:	e8 e3 2e 00 00       	call   80104f40 <memmove>
    brelse(bp);
8010205d:	89 34 24             	mov    %esi,(%esp)
80102060:	e8 8b e1 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010206d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102074:	0f 85 77 ff ff ff    	jne    80101ff1 <ilock+0x31>
      panic("ilock: no type");
8010207a:	83 ec 0c             	sub    $0xc,%esp
8010207d:	68 1c 7b 10 80       	push   $0x80107b1c
80102082:	e8 f9 e2 ff ff       	call   80100380 <panic>
    panic("ilock");
80102087:	83 ec 0c             	sub    $0xc,%esp
8010208a:	68 16 7b 10 80       	push   $0x80107b16
8010208f:	e8 ec e2 ff ff       	call   80100380 <panic>
80102094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010209f:	90                   	nop

801020a0 <iunlock>:
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	56                   	push   %esi
801020a4:	53                   	push   %ebx
801020a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020a8:	85 db                	test   %ebx,%ebx
801020aa:	74 28                	je     801020d4 <iunlock+0x34>
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	8d 73 0c             	lea    0xc(%ebx),%esi
801020b2:	56                   	push   %esi
801020b3:	e8 08 2b 00 00       	call   80104bc0 <holdingsleep>
801020b8:	83 c4 10             	add    $0x10,%esp
801020bb:	85 c0                	test   %eax,%eax
801020bd:	74 15                	je     801020d4 <iunlock+0x34>
801020bf:	8b 43 08             	mov    0x8(%ebx),%eax
801020c2:	85 c0                	test   %eax,%eax
801020c4:	7e 0e                	jle    801020d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801020c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801020c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020cc:	5b                   	pop    %ebx
801020cd:	5e                   	pop    %esi
801020ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801020cf:	e9 ac 2a 00 00       	jmp    80104b80 <releasesleep>
    panic("iunlock");
801020d4:	83 ec 0c             	sub    $0xc,%esp
801020d7:	68 2b 7b 10 80       	push   $0x80107b2b
801020dc:	e8 9f e2 ff ff       	call   80100380 <panic>
801020e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ef:	90                   	nop

801020f0 <iput>:
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 28             	sub    $0x28,%esp
801020f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801020fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801020ff:	57                   	push   %edi
80102100:	e8 1b 2a 00 00       	call   80104b20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102105:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102108:	83 c4 10             	add    $0x10,%esp
8010210b:	85 d2                	test   %edx,%edx
8010210d:	74 07                	je     80102116 <iput+0x26>
8010210f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102114:	74 32                	je     80102148 <iput+0x58>
  releasesleep(&ip->lock);
80102116:	83 ec 0c             	sub    $0xc,%esp
80102119:	57                   	push   %edi
8010211a:	e8 61 2a 00 00       	call   80104b80 <releasesleep>
  acquire(&icache.lock);
8010211f:	c7 04 24 e0 13 11 80 	movl   $0x801113e0,(%esp)
80102126:	e8 b5 2c 00 00       	call   80104de0 <acquire>
  ip->ref--;
8010212b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010212f:	83 c4 10             	add    $0x10,%esp
80102132:	c7 45 08 e0 13 11 80 	movl   $0x801113e0,0x8(%ebp)
}
80102139:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213c:	5b                   	pop    %ebx
8010213d:	5e                   	pop    %esi
8010213e:	5f                   	pop    %edi
8010213f:	5d                   	pop    %ebp
  release(&icache.lock);
80102140:	e9 3b 2c 00 00       	jmp    80104d80 <release>
80102145:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102148:	83 ec 0c             	sub    $0xc,%esp
8010214b:	68 e0 13 11 80       	push   $0x801113e0
80102150:	e8 8b 2c 00 00       	call   80104de0 <acquire>
    int r = ip->ref;
80102155:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102158:	c7 04 24 e0 13 11 80 	movl   $0x801113e0,(%esp)
8010215f:	e8 1c 2c 00 00       	call   80104d80 <release>
    if(r == 1){
80102164:	83 c4 10             	add    $0x10,%esp
80102167:	83 fe 01             	cmp    $0x1,%esi
8010216a:	75 aa                	jne    80102116 <iput+0x26>
8010216c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102172:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102175:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102178:	89 cf                	mov    %ecx,%edi
8010217a:	eb 0b                	jmp    80102187 <iput+0x97>
8010217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102180:	83 c6 04             	add    $0x4,%esi
80102183:	39 fe                	cmp    %edi,%esi
80102185:	74 19                	je     801021a0 <iput+0xb0>
    if(ip->addrs[i]){
80102187:	8b 16                	mov    (%esi),%edx
80102189:	85 d2                	test   %edx,%edx
8010218b:	74 f3                	je     80102180 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010218d:	8b 03                	mov    (%ebx),%eax
8010218f:	e8 6c f8 ff ff       	call   80101a00 <bfree>
      ip->addrs[i] = 0;
80102194:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010219a:	eb e4                	jmp    80102180 <iput+0x90>
8010219c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801021a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801021a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801021a9:	85 c0                	test   %eax,%eax
801021ab:	75 2d                	jne    801021da <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801021ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801021b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801021b7:	53                   	push   %ebx
801021b8:	e8 53 fd ff ff       	call   80101f10 <iupdate>
      ip->type = 0;
801021bd:	31 c0                	xor    %eax,%eax
801021bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801021c3:	89 1c 24             	mov    %ebx,(%esp)
801021c6:	e8 45 fd ff ff       	call   80101f10 <iupdate>
      ip->valid = 0;
801021cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	e9 3c ff ff ff       	jmp    80102116 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801021da:	83 ec 08             	sub    $0x8,%esp
801021dd:	50                   	push   %eax
801021de:	ff 33                	push   (%ebx)
801021e0:	e8 eb de ff ff       	call   801000d0 <bread>
801021e5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801021e8:	83 c4 10             	add    $0x10,%esp
801021eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801021f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801021f4:	8d 70 5c             	lea    0x5c(%eax),%esi
801021f7:	89 cf                	mov    %ecx,%edi
801021f9:	eb 0c                	jmp    80102207 <iput+0x117>
801021fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop
80102200:	83 c6 04             	add    $0x4,%esi
80102203:	39 f7                	cmp    %esi,%edi
80102205:	74 0f                	je     80102216 <iput+0x126>
      if(a[j])
80102207:	8b 16                	mov    (%esi),%edx
80102209:	85 d2                	test   %edx,%edx
8010220b:	74 f3                	je     80102200 <iput+0x110>
        bfree(ip->dev, a[j]);
8010220d:	8b 03                	mov    (%ebx),%eax
8010220f:	e8 ec f7 ff ff       	call   80101a00 <bfree>
80102214:	eb ea                	jmp    80102200 <iput+0x110>
    brelse(bp);
80102216:	83 ec 0c             	sub    $0xc,%esp
80102219:	ff 75 e4             	push   -0x1c(%ebp)
8010221c:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010221f:	e8 cc df ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102224:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010222a:	8b 03                	mov    (%ebx),%eax
8010222c:	e8 cf f7 ff ff       	call   80101a00 <bfree>
    ip->addrs[NDIRECT] = 0;
80102231:	83 c4 10             	add    $0x10,%esp
80102234:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010223b:	00 00 00 
8010223e:	e9 6a ff ff ff       	jmp    801021ad <iput+0xbd>
80102243:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102250 <iunlockput>:
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	56                   	push   %esi
80102254:	53                   	push   %ebx
80102255:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102258:	85 db                	test   %ebx,%ebx
8010225a:	74 34                	je     80102290 <iunlockput+0x40>
8010225c:	83 ec 0c             	sub    $0xc,%esp
8010225f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102262:	56                   	push   %esi
80102263:	e8 58 29 00 00       	call   80104bc0 <holdingsleep>
80102268:	83 c4 10             	add    $0x10,%esp
8010226b:	85 c0                	test   %eax,%eax
8010226d:	74 21                	je     80102290 <iunlockput+0x40>
8010226f:	8b 43 08             	mov    0x8(%ebx),%eax
80102272:	85 c0                	test   %eax,%eax
80102274:	7e 1a                	jle    80102290 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102276:	83 ec 0c             	sub    $0xc,%esp
80102279:	56                   	push   %esi
8010227a:	e8 01 29 00 00       	call   80104b80 <releasesleep>
  iput(ip);
8010227f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102282:	83 c4 10             	add    $0x10,%esp
}
80102285:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102288:	5b                   	pop    %ebx
80102289:	5e                   	pop    %esi
8010228a:	5d                   	pop    %ebp
  iput(ip);
8010228b:	e9 60 fe ff ff       	jmp    801020f0 <iput>
    panic("iunlock");
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	68 2b 7b 10 80       	push   $0x80107b2b
80102298:	e8 e3 e0 ff ff       	call   80100380 <panic>
8010229d:	8d 76 00             	lea    0x0(%esi),%esi

801022a0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 55 08             	mov    0x8(%ebp),%edx
801022a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801022a9:	8b 0a                	mov    (%edx),%ecx
801022ab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801022ae:	8b 4a 04             	mov    0x4(%edx),%ecx
801022b1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801022b4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801022b8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801022bb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801022bf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801022c3:	8b 52 58             	mov    0x58(%edx),%edx
801022c6:	89 50 10             	mov    %edx,0x10(%eax)
}
801022c9:	5d                   	pop    %ebp
801022ca:	c3                   	ret    
801022cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop

801022d0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	57                   	push   %edi
801022d4:	56                   	push   %esi
801022d5:	53                   	push   %ebx
801022d6:	83 ec 1c             	sub    $0x1c,%esp
801022d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801022dc:	8b 45 08             	mov    0x8(%ebp),%eax
801022df:	8b 75 10             	mov    0x10(%ebp),%esi
801022e2:	89 7d e0             	mov    %edi,-0x20(%ebp)
801022e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801022e8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801022ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
801022f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801022f3:	0f 84 a7 00 00 00    	je     801023a0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801022f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801022fc:	8b 40 58             	mov    0x58(%eax),%eax
801022ff:	39 c6                	cmp    %eax,%esi
80102301:	0f 87 ba 00 00 00    	ja     801023c1 <readi+0xf1>
80102307:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010230a:	31 c9                	xor    %ecx,%ecx
8010230c:	89 da                	mov    %ebx,%edx
8010230e:	01 f2                	add    %esi,%edx
80102310:	0f 92 c1             	setb   %cl
80102313:	89 cf                	mov    %ecx,%edi
80102315:	0f 82 a6 00 00 00    	jb     801023c1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010231b:	89 c1                	mov    %eax,%ecx
8010231d:	29 f1                	sub    %esi,%ecx
8010231f:	39 d0                	cmp    %edx,%eax
80102321:	0f 43 cb             	cmovae %ebx,%ecx
80102324:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102327:	85 c9                	test   %ecx,%ecx
80102329:	74 67                	je     80102392 <readi+0xc2>
8010232b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102330:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102333:	89 f2                	mov    %esi,%edx
80102335:	c1 ea 09             	shr    $0x9,%edx
80102338:	89 d8                	mov    %ebx,%eax
8010233a:	e8 51 f9 ff ff       	call   80101c90 <bmap>
8010233f:	83 ec 08             	sub    $0x8,%esp
80102342:	50                   	push   %eax
80102343:	ff 33                	push   (%ebx)
80102345:	e8 86 dd ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010234a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010234d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102352:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102354:	89 f0                	mov    %esi,%eax
80102356:	25 ff 01 00 00       	and    $0x1ff,%eax
8010235b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010235d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102360:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102362:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102366:	39 d9                	cmp    %ebx,%ecx
80102368:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010236b:	83 c4 0c             	add    $0xc,%esp
8010236e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010236f:	01 df                	add    %ebx,%edi
80102371:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102373:	50                   	push   %eax
80102374:	ff 75 e0             	push   -0x20(%ebp)
80102377:	e8 c4 2b 00 00       	call   80104f40 <memmove>
    brelse(bp);
8010237c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010237f:	89 14 24             	mov    %edx,(%esp)
80102382:	e8 69 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102387:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010238a:	83 c4 10             	add    $0x10,%esp
8010238d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102390:	77 9e                	ja     80102330 <readi+0x60>
  }
  return n;
80102392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102395:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102398:	5b                   	pop    %ebx
80102399:	5e                   	pop    %esi
8010239a:	5f                   	pop    %edi
8010239b:	5d                   	pop    %ebp
8010239c:	c3                   	ret    
8010239d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801023a0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801023a4:	66 83 f8 09          	cmp    $0x9,%ax
801023a8:	77 17                	ja     801023c1 <readi+0xf1>
801023aa:	8b 04 c5 80 13 11 80 	mov    -0x7feeec80(,%eax,8),%eax
801023b1:	85 c0                	test   %eax,%eax
801023b3:	74 0c                	je     801023c1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801023b5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801023b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023bb:	5b                   	pop    %ebx
801023bc:	5e                   	pop    %esi
801023bd:	5f                   	pop    %edi
801023be:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801023bf:	ff e0                	jmp    *%eax
      return -1;
801023c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023c6:	eb cd                	jmp    80102395 <readi+0xc5>
801023c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cf:	90                   	nop

801023d0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	57                   	push   %edi
801023d4:	56                   	push   %esi
801023d5:	53                   	push   %ebx
801023d6:	83 ec 1c             	sub    $0x1c,%esp
801023d9:	8b 45 08             	mov    0x8(%ebp),%eax
801023dc:	8b 75 0c             	mov    0xc(%ebp),%esi
801023df:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023e2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801023e7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801023ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
801023ed:	8b 75 10             	mov    0x10(%ebp),%esi
801023f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
801023f3:	0f 84 b7 00 00 00    	je     801024b0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801023f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801023fc:	3b 70 58             	cmp    0x58(%eax),%esi
801023ff:	0f 87 e7 00 00 00    	ja     801024ec <writei+0x11c>
80102405:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102408:	31 d2                	xor    %edx,%edx
8010240a:	89 f8                	mov    %edi,%eax
8010240c:	01 f0                	add    %esi,%eax
8010240e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102411:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102416:	0f 87 d0 00 00 00    	ja     801024ec <writei+0x11c>
8010241c:	85 d2                	test   %edx,%edx
8010241e:	0f 85 c8 00 00 00    	jne    801024ec <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102424:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010242b:	85 ff                	test   %edi,%edi
8010242d:	74 72                	je     801024a1 <writei+0xd1>
8010242f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102430:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102433:	89 f2                	mov    %esi,%edx
80102435:	c1 ea 09             	shr    $0x9,%edx
80102438:	89 f8                	mov    %edi,%eax
8010243a:	e8 51 f8 ff ff       	call   80101c90 <bmap>
8010243f:	83 ec 08             	sub    $0x8,%esp
80102442:	50                   	push   %eax
80102443:	ff 37                	push   (%edi)
80102445:	e8 86 dc ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010244a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010244f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102452:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102455:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102457:	89 f0                	mov    %esi,%eax
80102459:	25 ff 01 00 00       	and    $0x1ff,%eax
8010245e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102460:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102464:	39 d9                	cmp    %ebx,%ecx
80102466:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102469:	83 c4 0c             	add    $0xc,%esp
8010246c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010246d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010246f:	ff 75 dc             	push   -0x24(%ebp)
80102472:	50                   	push   %eax
80102473:	e8 c8 2a 00 00       	call   80104f40 <memmove>
    log_write(bp);
80102478:	89 3c 24             	mov    %edi,(%esp)
8010247b:	e8 00 13 00 00       	call   80103780 <log_write>
    brelse(bp);
80102480:	89 3c 24             	mov    %edi,(%esp)
80102483:	e8 68 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102488:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010248b:	83 c4 10             	add    $0x10,%esp
8010248e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102491:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102494:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102497:	77 97                	ja     80102430 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102499:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010249c:	3b 70 58             	cmp    0x58(%eax),%esi
8010249f:	77 37                	ja     801024d8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801024a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801024a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024a7:	5b                   	pop    %ebx
801024a8:	5e                   	pop    %esi
801024a9:	5f                   	pop    %edi
801024aa:	5d                   	pop    %ebp
801024ab:	c3                   	ret    
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801024b0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801024b4:	66 83 f8 09          	cmp    $0x9,%ax
801024b8:	77 32                	ja     801024ec <writei+0x11c>
801024ba:	8b 04 c5 84 13 11 80 	mov    -0x7feeec7c(,%eax,8),%eax
801024c1:	85 c0                	test   %eax,%eax
801024c3:	74 27                	je     801024ec <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801024c5:	89 55 10             	mov    %edx,0x10(%ebp)
}
801024c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5f                   	pop    %edi
801024ce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801024cf:	ff e0                	jmp    *%eax
801024d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801024d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801024db:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801024de:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801024e1:	50                   	push   %eax
801024e2:	e8 29 fa ff ff       	call   80101f10 <iupdate>
801024e7:	83 c4 10             	add    $0x10,%esp
801024ea:	eb b5                	jmp    801024a1 <writei+0xd1>
      return -1;
801024ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024f1:	eb b1                	jmp    801024a4 <writei+0xd4>
801024f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102500 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102506:	6a 0e                	push   $0xe
80102508:	ff 75 0c             	push   0xc(%ebp)
8010250b:	ff 75 08             	push   0x8(%ebp)
8010250e:	e8 9d 2a 00 00       	call   80104fb0 <strncmp>
}
80102513:	c9                   	leave  
80102514:	c3                   	ret    
80102515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102520 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	57                   	push   %edi
80102524:	56                   	push   %esi
80102525:	53                   	push   %ebx
80102526:	83 ec 1c             	sub    $0x1c,%esp
80102529:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010252c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102531:	0f 85 85 00 00 00    	jne    801025bc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102537:	8b 53 58             	mov    0x58(%ebx),%edx
8010253a:	31 ff                	xor    %edi,%edi
8010253c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010253f:	85 d2                	test   %edx,%edx
80102541:	74 3e                	je     80102581 <dirlookup+0x61>
80102543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102547:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102548:	6a 10                	push   $0x10
8010254a:	57                   	push   %edi
8010254b:	56                   	push   %esi
8010254c:	53                   	push   %ebx
8010254d:	e8 7e fd ff ff       	call   801022d0 <readi>
80102552:	83 c4 10             	add    $0x10,%esp
80102555:	83 f8 10             	cmp    $0x10,%eax
80102558:	75 55                	jne    801025af <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010255a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010255f:	74 18                	je     80102579 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102561:	83 ec 04             	sub    $0x4,%esp
80102564:	8d 45 da             	lea    -0x26(%ebp),%eax
80102567:	6a 0e                	push   $0xe
80102569:	50                   	push   %eax
8010256a:	ff 75 0c             	push   0xc(%ebp)
8010256d:	e8 3e 2a 00 00       	call   80104fb0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102572:	83 c4 10             	add    $0x10,%esp
80102575:	85 c0                	test   %eax,%eax
80102577:	74 17                	je     80102590 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102579:	83 c7 10             	add    $0x10,%edi
8010257c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010257f:	72 c7                	jb     80102548 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102581:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102584:	31 c0                	xor    %eax,%eax
}
80102586:	5b                   	pop    %ebx
80102587:	5e                   	pop    %esi
80102588:	5f                   	pop    %edi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop
      if(poff)
80102590:	8b 45 10             	mov    0x10(%ebp),%eax
80102593:	85 c0                	test   %eax,%eax
80102595:	74 05                	je     8010259c <dirlookup+0x7c>
        *poff = off;
80102597:	8b 45 10             	mov    0x10(%ebp),%eax
8010259a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010259c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801025a0:	8b 03                	mov    (%ebx),%eax
801025a2:	e8 e9 f5 ff ff       	call   80101b90 <iget>
}
801025a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025aa:	5b                   	pop    %ebx
801025ab:	5e                   	pop    %esi
801025ac:	5f                   	pop    %edi
801025ad:	5d                   	pop    %ebp
801025ae:	c3                   	ret    
      panic("dirlookup read");
801025af:	83 ec 0c             	sub    $0xc,%esp
801025b2:	68 45 7b 10 80       	push   $0x80107b45
801025b7:	e8 c4 dd ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
801025bc:	83 ec 0c             	sub    $0xc,%esp
801025bf:	68 33 7b 10 80       	push   $0x80107b33
801025c4:	e8 b7 dd ff ff       	call   80100380 <panic>
801025c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801025d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	57                   	push   %edi
801025d4:	56                   	push   %esi
801025d5:	53                   	push   %ebx
801025d6:	89 c3                	mov    %eax,%ebx
801025d8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025db:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801025de:	89 55 dc             	mov    %edx,-0x24(%ebp)
801025e1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801025e4:	0f 84 64 01 00 00    	je     8010274e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801025ea:	e8 c1 1b 00 00       	call   801041b0 <myproc>
  acquire(&icache.lock);
801025ef:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801025f2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801025f5:	68 e0 13 11 80       	push   $0x801113e0
801025fa:	e8 e1 27 00 00       	call   80104de0 <acquire>
  ip->ref++;
801025ff:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102603:	c7 04 24 e0 13 11 80 	movl   $0x801113e0,(%esp)
8010260a:	e8 71 27 00 00       	call   80104d80 <release>
8010260f:	83 c4 10             	add    $0x10,%esp
80102612:	eb 07                	jmp    8010261b <namex+0x4b>
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102618:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010261b:	0f b6 03             	movzbl (%ebx),%eax
8010261e:	3c 2f                	cmp    $0x2f,%al
80102620:	74 f6                	je     80102618 <namex+0x48>
  if(*path == 0)
80102622:	84 c0                	test   %al,%al
80102624:	0f 84 06 01 00 00    	je     80102730 <namex+0x160>
  while(*path != '/' && *path != 0)
8010262a:	0f b6 03             	movzbl (%ebx),%eax
8010262d:	84 c0                	test   %al,%al
8010262f:	0f 84 10 01 00 00    	je     80102745 <namex+0x175>
80102635:	89 df                	mov    %ebx,%edi
80102637:	3c 2f                	cmp    $0x2f,%al
80102639:	0f 84 06 01 00 00    	je     80102745 <namex+0x175>
8010263f:	90                   	nop
80102640:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102644:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102647:	3c 2f                	cmp    $0x2f,%al
80102649:	74 04                	je     8010264f <namex+0x7f>
8010264b:	84 c0                	test   %al,%al
8010264d:	75 f1                	jne    80102640 <namex+0x70>
  len = path - s;
8010264f:	89 f8                	mov    %edi,%eax
80102651:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102653:	83 f8 0d             	cmp    $0xd,%eax
80102656:	0f 8e ac 00 00 00    	jle    80102708 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010265c:	83 ec 04             	sub    $0x4,%esp
8010265f:	6a 0e                	push   $0xe
80102661:	53                   	push   %ebx
    path++;
80102662:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102664:	ff 75 e4             	push   -0x1c(%ebp)
80102667:	e8 d4 28 00 00       	call   80104f40 <memmove>
8010266c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010266f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102672:	75 0c                	jne    80102680 <namex+0xb0>
80102674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102678:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010267b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010267e:	74 f8                	je     80102678 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	56                   	push   %esi
80102684:	e8 37 f9 ff ff       	call   80101fc0 <ilock>
    if(ip->type != T_DIR){
80102689:	83 c4 10             	add    $0x10,%esp
8010268c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102691:	0f 85 cd 00 00 00    	jne    80102764 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102697:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010269a:	85 c0                	test   %eax,%eax
8010269c:	74 09                	je     801026a7 <namex+0xd7>
8010269e:	80 3b 00             	cmpb   $0x0,(%ebx)
801026a1:	0f 84 22 01 00 00    	je     801027c9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801026a7:	83 ec 04             	sub    $0x4,%esp
801026aa:	6a 00                	push   $0x0
801026ac:	ff 75 e4             	push   -0x1c(%ebp)
801026af:	56                   	push   %esi
801026b0:	e8 6b fe ff ff       	call   80102520 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801026b5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
801026b8:	83 c4 10             	add    $0x10,%esp
801026bb:	89 c7                	mov    %eax,%edi
801026bd:	85 c0                	test   %eax,%eax
801026bf:	0f 84 e1 00 00 00    	je     801027a6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801026c5:	83 ec 0c             	sub    $0xc,%esp
801026c8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801026cb:	52                   	push   %edx
801026cc:	e8 ef 24 00 00       	call   80104bc0 <holdingsleep>
801026d1:	83 c4 10             	add    $0x10,%esp
801026d4:	85 c0                	test   %eax,%eax
801026d6:	0f 84 30 01 00 00    	je     8010280c <namex+0x23c>
801026dc:	8b 56 08             	mov    0x8(%esi),%edx
801026df:	85 d2                	test   %edx,%edx
801026e1:	0f 8e 25 01 00 00    	jle    8010280c <namex+0x23c>
  releasesleep(&ip->lock);
801026e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801026ea:	83 ec 0c             	sub    $0xc,%esp
801026ed:	52                   	push   %edx
801026ee:	e8 8d 24 00 00       	call   80104b80 <releasesleep>
  iput(ip);
801026f3:	89 34 24             	mov    %esi,(%esp)
801026f6:	89 fe                	mov    %edi,%esi
801026f8:	e8 f3 f9 ff ff       	call   801020f0 <iput>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	e9 16 ff ff ff       	jmp    8010261b <namex+0x4b>
80102705:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102708:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010270b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010270e:	83 ec 04             	sub    $0x4,%esp
80102711:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102714:	50                   	push   %eax
80102715:	53                   	push   %ebx
    name[len] = 0;
80102716:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102718:	ff 75 e4             	push   -0x1c(%ebp)
8010271b:	e8 20 28 00 00       	call   80104f40 <memmove>
    name[len] = 0;
80102720:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102723:	83 c4 10             	add    $0x10,%esp
80102726:	c6 02 00             	movb   $0x0,(%edx)
80102729:	e9 41 ff ff ff       	jmp    8010266f <namex+0x9f>
8010272e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102730:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102733:	85 c0                	test   %eax,%eax
80102735:	0f 85 be 00 00 00    	jne    801027f9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010273b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010273e:	89 f0                	mov    %esi,%eax
80102740:	5b                   	pop    %ebx
80102741:	5e                   	pop    %esi
80102742:	5f                   	pop    %edi
80102743:	5d                   	pop    %ebp
80102744:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102748:	89 df                	mov    %ebx,%edi
8010274a:	31 c0                	xor    %eax,%eax
8010274c:	eb c0                	jmp    8010270e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010274e:	ba 01 00 00 00       	mov    $0x1,%edx
80102753:	b8 01 00 00 00       	mov    $0x1,%eax
80102758:	e8 33 f4 ff ff       	call   80101b90 <iget>
8010275d:	89 c6                	mov    %eax,%esi
8010275f:	e9 b7 fe ff ff       	jmp    8010261b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102764:	83 ec 0c             	sub    $0xc,%esp
80102767:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010276a:	53                   	push   %ebx
8010276b:	e8 50 24 00 00       	call   80104bc0 <holdingsleep>
80102770:	83 c4 10             	add    $0x10,%esp
80102773:	85 c0                	test   %eax,%eax
80102775:	0f 84 91 00 00 00    	je     8010280c <namex+0x23c>
8010277b:	8b 46 08             	mov    0x8(%esi),%eax
8010277e:	85 c0                	test   %eax,%eax
80102780:	0f 8e 86 00 00 00    	jle    8010280c <namex+0x23c>
  releasesleep(&ip->lock);
80102786:	83 ec 0c             	sub    $0xc,%esp
80102789:	53                   	push   %ebx
8010278a:	e8 f1 23 00 00       	call   80104b80 <releasesleep>
  iput(ip);
8010278f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102792:	31 f6                	xor    %esi,%esi
  iput(ip);
80102794:	e8 57 f9 ff ff       	call   801020f0 <iput>
      return 0;
80102799:	83 c4 10             	add    $0x10,%esp
}
8010279c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010279f:	89 f0                	mov    %esi,%eax
801027a1:	5b                   	pop    %ebx
801027a2:	5e                   	pop    %esi
801027a3:	5f                   	pop    %edi
801027a4:	5d                   	pop    %ebp
801027a5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801027a6:	83 ec 0c             	sub    $0xc,%esp
801027a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801027ac:	52                   	push   %edx
801027ad:	e8 0e 24 00 00       	call   80104bc0 <holdingsleep>
801027b2:	83 c4 10             	add    $0x10,%esp
801027b5:	85 c0                	test   %eax,%eax
801027b7:	74 53                	je     8010280c <namex+0x23c>
801027b9:	8b 4e 08             	mov    0x8(%esi),%ecx
801027bc:	85 c9                	test   %ecx,%ecx
801027be:	7e 4c                	jle    8010280c <namex+0x23c>
  releasesleep(&ip->lock);
801027c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801027c3:	83 ec 0c             	sub    $0xc,%esp
801027c6:	52                   	push   %edx
801027c7:	eb c1                	jmp    8010278a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801027c9:	83 ec 0c             	sub    $0xc,%esp
801027cc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801027cf:	53                   	push   %ebx
801027d0:	e8 eb 23 00 00       	call   80104bc0 <holdingsleep>
801027d5:	83 c4 10             	add    $0x10,%esp
801027d8:	85 c0                	test   %eax,%eax
801027da:	74 30                	je     8010280c <namex+0x23c>
801027dc:	8b 7e 08             	mov    0x8(%esi),%edi
801027df:	85 ff                	test   %edi,%edi
801027e1:	7e 29                	jle    8010280c <namex+0x23c>
  releasesleep(&ip->lock);
801027e3:	83 ec 0c             	sub    $0xc,%esp
801027e6:	53                   	push   %ebx
801027e7:	e8 94 23 00 00       	call   80104b80 <releasesleep>
}
801027ec:	83 c4 10             	add    $0x10,%esp
}
801027ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027f2:	89 f0                	mov    %esi,%eax
801027f4:	5b                   	pop    %ebx
801027f5:	5e                   	pop    %esi
801027f6:	5f                   	pop    %edi
801027f7:	5d                   	pop    %ebp
801027f8:	c3                   	ret    
    iput(ip);
801027f9:	83 ec 0c             	sub    $0xc,%esp
801027fc:	56                   	push   %esi
    return 0;
801027fd:	31 f6                	xor    %esi,%esi
    iput(ip);
801027ff:	e8 ec f8 ff ff       	call   801020f0 <iput>
    return 0;
80102804:	83 c4 10             	add    $0x10,%esp
80102807:	e9 2f ff ff ff       	jmp    8010273b <namex+0x16b>
    panic("iunlock");
8010280c:	83 ec 0c             	sub    $0xc,%esp
8010280f:	68 2b 7b 10 80       	push   $0x80107b2b
80102814:	e8 67 db ff ff       	call   80100380 <panic>
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102820 <dirlink>:
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	57                   	push   %edi
80102824:	56                   	push   %esi
80102825:	53                   	push   %ebx
80102826:	83 ec 20             	sub    $0x20,%esp
80102829:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010282c:	6a 00                	push   $0x0
8010282e:	ff 75 0c             	push   0xc(%ebp)
80102831:	53                   	push   %ebx
80102832:	e8 e9 fc ff ff       	call   80102520 <dirlookup>
80102837:	83 c4 10             	add    $0x10,%esp
8010283a:	85 c0                	test   %eax,%eax
8010283c:	75 67                	jne    801028a5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010283e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102841:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102844:	85 ff                	test   %edi,%edi
80102846:	74 29                	je     80102871 <dirlink+0x51>
80102848:	31 ff                	xor    %edi,%edi
8010284a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010284d:	eb 09                	jmp    80102858 <dirlink+0x38>
8010284f:	90                   	nop
80102850:	83 c7 10             	add    $0x10,%edi
80102853:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102856:	73 19                	jae    80102871 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102858:	6a 10                	push   $0x10
8010285a:	57                   	push   %edi
8010285b:	56                   	push   %esi
8010285c:	53                   	push   %ebx
8010285d:	e8 6e fa ff ff       	call   801022d0 <readi>
80102862:	83 c4 10             	add    $0x10,%esp
80102865:	83 f8 10             	cmp    $0x10,%eax
80102868:	75 4e                	jne    801028b8 <dirlink+0x98>
    if(de.inum == 0)
8010286a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010286f:	75 df                	jne    80102850 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102871:	83 ec 04             	sub    $0x4,%esp
80102874:	8d 45 da             	lea    -0x26(%ebp),%eax
80102877:	6a 0e                	push   $0xe
80102879:	ff 75 0c             	push   0xc(%ebp)
8010287c:	50                   	push   %eax
8010287d:	e8 7e 27 00 00       	call   80105000 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102882:	6a 10                	push   $0x10
  de.inum = inum;
80102884:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102887:	57                   	push   %edi
80102888:	56                   	push   %esi
80102889:	53                   	push   %ebx
  de.inum = inum;
8010288a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010288e:	e8 3d fb ff ff       	call   801023d0 <writei>
80102893:	83 c4 20             	add    $0x20,%esp
80102896:	83 f8 10             	cmp    $0x10,%eax
80102899:	75 2a                	jne    801028c5 <dirlink+0xa5>
  return 0;
8010289b:	31 c0                	xor    %eax,%eax
}
8010289d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028a0:	5b                   	pop    %ebx
801028a1:	5e                   	pop    %esi
801028a2:	5f                   	pop    %edi
801028a3:	5d                   	pop    %ebp
801028a4:	c3                   	ret    
    iput(ip);
801028a5:	83 ec 0c             	sub    $0xc,%esp
801028a8:	50                   	push   %eax
801028a9:	e8 42 f8 ff ff       	call   801020f0 <iput>
    return -1;
801028ae:	83 c4 10             	add    $0x10,%esp
801028b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801028b6:	eb e5                	jmp    8010289d <dirlink+0x7d>
      panic("dirlink read");
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	68 54 7b 10 80       	push   $0x80107b54
801028c0:	e8 bb da ff ff       	call   80100380 <panic>
    panic("dirlink");
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 1e 81 10 80       	push   $0x8010811e
801028cd:	e8 ae da ff ff       	call   80100380 <panic>
801028d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028e0 <namei>:

struct inode*
namei(char *path)
{
801028e0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801028e1:	31 d2                	xor    %edx,%edx
{
801028e3:	89 e5                	mov    %esp,%ebp
801028e5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801028e8:	8b 45 08             	mov    0x8(%ebp),%eax
801028eb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801028ee:	e8 dd fc ff ff       	call   801025d0 <namex>
}
801028f3:	c9                   	leave  
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102900:	55                   	push   %ebp
  return namex(path, 1, name);
80102901:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102906:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102908:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010290b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010290e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010290f:	e9 bc fc ff ff       	jmp    801025d0 <namex>
80102914:	66 90                	xchg   %ax,%ax
80102916:	66 90                	xchg   %ax,%ax
80102918:	66 90                	xchg   %ax,%ax
8010291a:	66 90                	xchg   %ax,%ax
8010291c:	66 90                	xchg   %ax,%ax
8010291e:	66 90                	xchg   %ax,%ax

80102920 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	57                   	push   %edi
80102924:	56                   	push   %esi
80102925:	53                   	push   %ebx
80102926:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102929:	85 c0                	test   %eax,%eax
8010292b:	0f 84 b4 00 00 00    	je     801029e5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102931:	8b 70 08             	mov    0x8(%eax),%esi
80102934:	89 c3                	mov    %eax,%ebx
80102936:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010293c:	0f 87 96 00 00 00    	ja     801029d8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102942:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294e:	66 90                	xchg   %ax,%ax
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102953:	83 e0 c0             	and    $0xffffffc0,%eax
80102956:	3c 40                	cmp    $0x40,%al
80102958:	75 f6                	jne    80102950 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010295a:	31 ff                	xor    %edi,%edi
8010295c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102961:	89 f8                	mov    %edi,%eax
80102963:	ee                   	out    %al,(%dx)
80102964:	b8 01 00 00 00       	mov    $0x1,%eax
80102969:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010296e:	ee                   	out    %al,(%dx)
8010296f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102974:	89 f0                	mov    %esi,%eax
80102976:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102977:	89 f0                	mov    %esi,%eax
80102979:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010297e:	c1 f8 08             	sar    $0x8,%eax
80102981:	ee                   	out    %al,(%dx)
80102982:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102987:	89 f8                	mov    %edi,%eax
80102989:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010298a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010298e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102993:	c1 e0 04             	shl    $0x4,%eax
80102996:	83 e0 10             	and    $0x10,%eax
80102999:	83 c8 e0             	or     $0xffffffe0,%eax
8010299c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010299d:	f6 03 04             	testb  $0x4,(%ebx)
801029a0:	75 16                	jne    801029b8 <idestart+0x98>
801029a2:	b8 20 00 00 00       	mov    $0x20,%eax
801029a7:	89 ca                	mov    %ecx,%edx
801029a9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801029aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029ad:	5b                   	pop    %ebx
801029ae:	5e                   	pop    %esi
801029af:	5f                   	pop    %edi
801029b0:	5d                   	pop    %ebp
801029b1:	c3                   	ret    
801029b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029b8:	b8 30 00 00 00       	mov    $0x30,%eax
801029bd:	89 ca                	mov    %ecx,%edx
801029bf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801029c0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801029c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801029c8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801029cd:	fc                   	cld    
801029ce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801029d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029d3:	5b                   	pop    %ebx
801029d4:	5e                   	pop    %esi
801029d5:	5f                   	pop    %edi
801029d6:	5d                   	pop    %ebp
801029d7:	c3                   	ret    
    panic("incorrect blockno");
801029d8:	83 ec 0c             	sub    $0xc,%esp
801029db:	68 c0 7b 10 80       	push   $0x80107bc0
801029e0:	e8 9b d9 ff ff       	call   80100380 <panic>
    panic("idestart");
801029e5:	83 ec 0c             	sub    $0xc,%esp
801029e8:	68 b7 7b 10 80       	push   $0x80107bb7
801029ed:	e8 8e d9 ff ff       	call   80100380 <panic>
801029f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a00 <ideinit>:
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102a06:	68 d2 7b 10 80       	push   $0x80107bd2
80102a0b:	68 80 30 11 80       	push   $0x80113080
80102a10:	e8 fb 21 00 00       	call   80104c10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102a15:	58                   	pop    %eax
80102a16:	a1 04 32 11 80       	mov    0x80113204,%eax
80102a1b:	5a                   	pop    %edx
80102a1c:	83 e8 01             	sub    $0x1,%eax
80102a1f:	50                   	push   %eax
80102a20:	6a 0e                	push   $0xe
80102a22:	e8 99 02 00 00       	call   80102cc0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102a27:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a2f:	90                   	nop
80102a30:	ec                   	in     (%dx),%al
80102a31:	83 e0 c0             	and    $0xffffffc0,%eax
80102a34:	3c 40                	cmp    $0x40,%al
80102a36:	75 f8                	jne    80102a30 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102a3d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a42:	ee                   	out    %al,(%dx)
80102a43:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a48:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a4d:	eb 06                	jmp    80102a55 <ideinit+0x55>
80102a4f:	90                   	nop
  for(i=0; i<1000; i++){
80102a50:	83 e9 01             	sub    $0x1,%ecx
80102a53:	74 0f                	je     80102a64 <ideinit+0x64>
80102a55:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102a56:	84 c0                	test   %al,%al
80102a58:	74 f6                	je     80102a50 <ideinit+0x50>
      havedisk1 = 1;
80102a5a:	c7 05 60 30 11 80 01 	movl   $0x1,0x80113060
80102a61:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a64:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102a69:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a6e:	ee                   	out    %al,(%dx)
}
80102a6f:	c9                   	leave  
80102a70:	c3                   	ret    
80102a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop

80102a80 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	57                   	push   %edi
80102a84:	56                   	push   %esi
80102a85:	53                   	push   %ebx
80102a86:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a89:	68 80 30 11 80       	push   $0x80113080
80102a8e:	e8 4d 23 00 00       	call   80104de0 <acquire>

  if((b = idequeue) == 0){
80102a93:	8b 1d 64 30 11 80    	mov    0x80113064,%ebx
80102a99:	83 c4 10             	add    $0x10,%esp
80102a9c:	85 db                	test   %ebx,%ebx
80102a9e:	74 63                	je     80102b03 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102aa0:	8b 43 58             	mov    0x58(%ebx),%eax
80102aa3:	a3 64 30 11 80       	mov    %eax,0x80113064

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102aa8:	8b 33                	mov    (%ebx),%esi
80102aaa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102ab0:	75 2f                	jne    80102ae1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abe:	66 90                	xchg   %ax,%ax
80102ac0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102ac1:	89 c1                	mov    %eax,%ecx
80102ac3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102ac6:	80 f9 40             	cmp    $0x40,%cl
80102ac9:	75 f5                	jne    80102ac0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102acb:	a8 21                	test   $0x21,%al
80102acd:	75 12                	jne    80102ae1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102acf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102ad2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102ad7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102adc:	fc                   	cld    
80102add:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102adf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102ae1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102ae4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102ae7:	83 ce 02             	or     $0x2,%esi
80102aea:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102aec:	53                   	push   %ebx
80102aed:	e8 4e 1e 00 00       	call   80104940 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102af2:	a1 64 30 11 80       	mov    0x80113064,%eax
80102af7:	83 c4 10             	add    $0x10,%esp
80102afa:	85 c0                	test   %eax,%eax
80102afc:	74 05                	je     80102b03 <ideintr+0x83>
    idestart(idequeue);
80102afe:	e8 1d fe ff ff       	call   80102920 <idestart>
    release(&idelock);
80102b03:	83 ec 0c             	sub    $0xc,%esp
80102b06:	68 80 30 11 80       	push   $0x80113080
80102b0b:	e8 70 22 00 00       	call   80104d80 <release>

  release(&idelock);
}
80102b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b13:	5b                   	pop    %ebx
80102b14:	5e                   	pop    %esi
80102b15:	5f                   	pop    %edi
80102b16:	5d                   	pop    %ebp
80102b17:	c3                   	ret    
80102b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop

80102b20 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 10             	sub    $0x10,%esp
80102b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102b2a:	8d 43 0c             	lea    0xc(%ebx),%eax
80102b2d:	50                   	push   %eax
80102b2e:	e8 8d 20 00 00       	call   80104bc0 <holdingsleep>
80102b33:	83 c4 10             	add    $0x10,%esp
80102b36:	85 c0                	test   %eax,%eax
80102b38:	0f 84 c3 00 00 00    	je     80102c01 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b3e:	8b 03                	mov    (%ebx),%eax
80102b40:	83 e0 06             	and    $0x6,%eax
80102b43:	83 f8 02             	cmp    $0x2,%eax
80102b46:	0f 84 a8 00 00 00    	je     80102bf4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102b4c:	8b 53 04             	mov    0x4(%ebx),%edx
80102b4f:	85 d2                	test   %edx,%edx
80102b51:	74 0d                	je     80102b60 <iderw+0x40>
80102b53:	a1 60 30 11 80       	mov    0x80113060,%eax
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	0f 84 87 00 00 00    	je     80102be7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102b60:	83 ec 0c             	sub    $0xc,%esp
80102b63:	68 80 30 11 80       	push   $0x80113080
80102b68:	e8 73 22 00 00       	call   80104de0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b6d:	a1 64 30 11 80       	mov    0x80113064,%eax
  b->qnext = 0;
80102b72:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b79:	83 c4 10             	add    $0x10,%esp
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	74 60                	je     80102be0 <iderw+0xc0>
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	8b 40 58             	mov    0x58(%eax),%eax
80102b85:	85 c0                	test   %eax,%eax
80102b87:	75 f7                	jne    80102b80 <iderw+0x60>
80102b89:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102b8c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102b8e:	39 1d 64 30 11 80    	cmp    %ebx,0x80113064
80102b94:	74 3a                	je     80102bd0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b96:	8b 03                	mov    (%ebx),%eax
80102b98:	83 e0 06             	and    $0x6,%eax
80102b9b:	83 f8 02             	cmp    $0x2,%eax
80102b9e:	74 1b                	je     80102bbb <iderw+0x9b>
    sleep(b, &idelock);
80102ba0:	83 ec 08             	sub    $0x8,%esp
80102ba3:	68 80 30 11 80       	push   $0x80113080
80102ba8:	53                   	push   %ebx
80102ba9:	e8 d2 1c 00 00       	call   80104880 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bae:	8b 03                	mov    (%ebx),%eax
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	83 e0 06             	and    $0x6,%eax
80102bb6:	83 f8 02             	cmp    $0x2,%eax
80102bb9:	75 e5                	jne    80102ba0 <iderw+0x80>
  }


  release(&idelock);
80102bbb:	c7 45 08 80 30 11 80 	movl   $0x80113080,0x8(%ebp)
}
80102bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc5:	c9                   	leave  
  release(&idelock);
80102bc6:	e9 b5 21 00 00       	jmp    80104d80 <release>
80102bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop
    idestart(b);
80102bd0:	89 d8                	mov    %ebx,%eax
80102bd2:	e8 49 fd ff ff       	call   80102920 <idestart>
80102bd7:	eb bd                	jmp    80102b96 <iderw+0x76>
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102be0:	ba 64 30 11 80       	mov    $0x80113064,%edx
80102be5:	eb a5                	jmp    80102b8c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102be7:	83 ec 0c             	sub    $0xc,%esp
80102bea:	68 01 7c 10 80       	push   $0x80107c01
80102bef:	e8 8c d7 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102bf4:	83 ec 0c             	sub    $0xc,%esp
80102bf7:	68 ec 7b 10 80       	push   $0x80107bec
80102bfc:	e8 7f d7 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102c01:	83 ec 0c             	sub    $0xc,%esp
80102c04:	68 d6 7b 10 80       	push   $0x80107bd6
80102c09:	e8 72 d7 ff ff       	call   80100380 <panic>
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102c10:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c11:	c7 05 b4 30 11 80 00 	movl   $0xfec00000,0x801130b4
80102c18:	00 c0 fe 
{
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	56                   	push   %esi
80102c1e:	53                   	push   %ebx
  ioapic->reg = reg;
80102c1f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102c26:	00 00 00 
  return ioapic->data;
80102c29:	8b 15 b4 30 11 80    	mov    0x801130b4,%edx
80102c2f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102c32:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102c38:	8b 0d b4 30 11 80    	mov    0x801130b4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102c3e:	0f b6 15 00 32 11 80 	movzbl 0x80113200,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c45:	c1 ee 10             	shr    $0x10,%esi
80102c48:	89 f0                	mov    %esi,%eax
80102c4a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102c4d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102c50:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102c53:	39 c2                	cmp    %eax,%edx
80102c55:	74 16                	je     80102c6d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c57:	83 ec 0c             	sub    $0xc,%esp
80102c5a:	68 20 7c 10 80       	push   $0x80107c20
80102c5f:	e8 9c da ff ff       	call   80100700 <cprintf>
  ioapic->reg = reg;
80102c64:	8b 0d b4 30 11 80    	mov    0x801130b4,%ecx
80102c6a:	83 c4 10             	add    $0x10,%esp
80102c6d:	83 c6 21             	add    $0x21,%esi
{
80102c70:	ba 10 00 00 00       	mov    $0x10,%edx
80102c75:	b8 20 00 00 00       	mov    $0x20,%eax
80102c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102c80:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c82:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102c84:	8b 0d b4 30 11 80    	mov    0x801130b4,%ecx
  for(i = 0; i <= maxintr; i++){
80102c8a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c8d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102c93:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102c96:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102c99:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102c9c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102c9e:	8b 0d b4 30 11 80    	mov    0x801130b4,%ecx
80102ca4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102cab:	39 f0                	cmp    %esi,%eax
80102cad:	75 d1                	jne    80102c80 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cb2:	5b                   	pop    %ebx
80102cb3:	5e                   	pop    %esi
80102cb4:	5d                   	pop    %ebp
80102cb5:	c3                   	ret    
80102cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cbd:	8d 76 00             	lea    0x0(%esi),%esi

80102cc0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102cc0:	55                   	push   %ebp
  ioapic->reg = reg;
80102cc1:	8b 0d b4 30 11 80    	mov    0x801130b4,%ecx
{
80102cc7:	89 e5                	mov    %esp,%ebp
80102cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ccc:	8d 50 20             	lea    0x20(%eax),%edx
80102ccf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102cd3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102cd5:	8b 0d b4 30 11 80    	mov    0x801130b4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cdb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102cde:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ce4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ce6:	a1 b4 30 11 80       	mov    0x801130b4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ceb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102cee:	89 50 10             	mov    %edx,0x10(%eax)
}
80102cf1:	5d                   	pop    %ebp
80102cf2:	c3                   	ret    
80102cf3:	66 90                	xchg   %ax,%ax
80102cf5:	66 90                	xchg   %ax,%ax
80102cf7:	66 90                	xchg   %ax,%ax
80102cf9:	66 90                	xchg   %ax,%ax
80102cfb:	66 90                	xchg   %ax,%ax
80102cfd:	66 90                	xchg   %ax,%ax
80102cff:	90                   	nop

80102d00 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 04             	sub    $0x4,%esp
80102d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d0a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102d10:	75 76                	jne    80102d88 <kfree+0x88>
80102d12:	81 fb 50 6f 11 80    	cmp    $0x80116f50,%ebx
80102d18:	72 6e                	jb     80102d88 <kfree+0x88>
80102d1a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102d20:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d25:	77 61                	ja     80102d88 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d27:	83 ec 04             	sub    $0x4,%esp
80102d2a:	68 00 10 00 00       	push   $0x1000
80102d2f:	6a 01                	push   $0x1
80102d31:	53                   	push   %ebx
80102d32:	e8 69 21 00 00       	call   80104ea0 <memset>

  if(kmem.use_lock)
80102d37:	8b 15 f4 30 11 80    	mov    0x801130f4,%edx
80102d3d:	83 c4 10             	add    $0x10,%esp
80102d40:	85 d2                	test   %edx,%edx
80102d42:	75 1c                	jne    80102d60 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102d44:	a1 f8 30 11 80       	mov    0x801130f8,%eax
80102d49:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102d4b:	a1 f4 30 11 80       	mov    0x801130f4,%eax
  kmem.freelist = r;
80102d50:	89 1d f8 30 11 80    	mov    %ebx,0x801130f8
  if(kmem.use_lock)
80102d56:	85 c0                	test   %eax,%eax
80102d58:	75 1e                	jne    80102d78 <kfree+0x78>
    release(&kmem.lock);
}
80102d5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d5d:	c9                   	leave  
80102d5e:	c3                   	ret    
80102d5f:	90                   	nop
    acquire(&kmem.lock);
80102d60:	83 ec 0c             	sub    $0xc,%esp
80102d63:	68 c0 30 11 80       	push   $0x801130c0
80102d68:	e8 73 20 00 00       	call   80104de0 <acquire>
80102d6d:	83 c4 10             	add    $0x10,%esp
80102d70:	eb d2                	jmp    80102d44 <kfree+0x44>
80102d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102d78:	c7 45 08 c0 30 11 80 	movl   $0x801130c0,0x8(%ebp)
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	c9                   	leave  
    release(&kmem.lock);
80102d83:	e9 f8 1f 00 00       	jmp    80104d80 <release>
    panic("kfree");
80102d88:	83 ec 0c             	sub    $0xc,%esp
80102d8b:	68 52 7c 10 80       	push   $0x80107c52
80102d90:	e8 eb d5 ff ff       	call   80100380 <panic>
80102d95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102da0 <freerange>:
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102da4:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102da7:	8b 75 0c             	mov    0xc(%ebp),%esi
80102daa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102dab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102db1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102db7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102dbd:	39 de                	cmp    %ebx,%esi
80102dbf:	72 23                	jb     80102de4 <freerange+0x44>
80102dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102dc8:	83 ec 0c             	sub    $0xc,%esp
80102dcb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dd1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102dd7:	50                   	push   %eax
80102dd8:	e8 23 ff ff ff       	call   80102d00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ddd:	83 c4 10             	add    $0x10,%esp
80102de0:	39 f3                	cmp    %esi,%ebx
80102de2:	76 e4                	jbe    80102dc8 <freerange+0x28>
}
80102de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102de7:	5b                   	pop    %ebx
80102de8:	5e                   	pop    %esi
80102de9:	5d                   	pop    %ebp
80102dea:	c3                   	ret    
80102deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102def:	90                   	nop

80102df0 <kinit2>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102df4:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102df7:	8b 75 0c             	mov    0xc(%ebp),%esi
80102dfa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102dfb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e01:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e0d:	39 de                	cmp    %ebx,%esi
80102e0f:	72 23                	jb     80102e34 <kinit2+0x44>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102e18:	83 ec 0c             	sub    $0xc,%esp
80102e1b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e27:	50                   	push   %eax
80102e28:	e8 d3 fe ff ff       	call   80102d00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e2d:	83 c4 10             	add    $0x10,%esp
80102e30:	39 de                	cmp    %ebx,%esi
80102e32:	73 e4                	jae    80102e18 <kinit2+0x28>
  kmem.use_lock = 1;
80102e34:	c7 05 f4 30 11 80 01 	movl   $0x1,0x801130f4
80102e3b:	00 00 00 
}
80102e3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e41:	5b                   	pop    %ebx
80102e42:	5e                   	pop    %esi
80102e43:	5d                   	pop    %ebp
80102e44:	c3                   	ret    
80102e45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e50 <kinit1>:
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	56                   	push   %esi
80102e54:	53                   	push   %ebx
80102e55:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102e58:	83 ec 08             	sub    $0x8,%esp
80102e5b:	68 58 7c 10 80       	push   $0x80107c58
80102e60:	68 c0 30 11 80       	push   $0x801130c0
80102e65:	e8 a6 1d 00 00       	call   80104c10 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e6d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e70:	c7 05 f4 30 11 80 00 	movl   $0x0,0x801130f4
80102e77:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102e7a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e86:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e8c:	39 de                	cmp    %ebx,%esi
80102e8e:	72 1c                	jb     80102eac <kinit1+0x5c>
    kfree(p);
80102e90:	83 ec 0c             	sub    $0xc,%esp
80102e93:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e9f:	50                   	push   %eax
80102ea0:	e8 5b fe ff ff       	call   80102d00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ea5:	83 c4 10             	add    $0x10,%esp
80102ea8:	39 de                	cmp    %ebx,%esi
80102eaa:	73 e4                	jae    80102e90 <kinit1+0x40>
}
80102eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102eaf:	5b                   	pop    %ebx
80102eb0:	5e                   	pop    %esi
80102eb1:	5d                   	pop    %ebp
80102eb2:	c3                   	ret    
80102eb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ec0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102ec0:	a1 f4 30 11 80       	mov    0x801130f4,%eax
80102ec5:	85 c0                	test   %eax,%eax
80102ec7:	75 1f                	jne    80102ee8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102ec9:	a1 f8 30 11 80       	mov    0x801130f8,%eax
  if(r)
80102ece:	85 c0                	test   %eax,%eax
80102ed0:	74 0e                	je     80102ee0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ed2:	8b 10                	mov    (%eax),%edx
80102ed4:	89 15 f8 30 11 80    	mov    %edx,0x801130f8
  if(kmem.use_lock)
80102eda:	c3                   	ret    
80102edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102ee0:	c3                   	ret    
80102ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102ee8:	55                   	push   %ebp
80102ee9:	89 e5                	mov    %esp,%ebp
80102eeb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102eee:	68 c0 30 11 80       	push   $0x801130c0
80102ef3:	e8 e8 1e 00 00       	call   80104de0 <acquire>
  r = kmem.freelist;
80102ef8:	a1 f8 30 11 80       	mov    0x801130f8,%eax
  if(kmem.use_lock)
80102efd:	8b 15 f4 30 11 80    	mov    0x801130f4,%edx
  if(r)
80102f03:	83 c4 10             	add    $0x10,%esp
80102f06:	85 c0                	test   %eax,%eax
80102f08:	74 08                	je     80102f12 <kalloc+0x52>
    kmem.freelist = r->next;
80102f0a:	8b 08                	mov    (%eax),%ecx
80102f0c:	89 0d f8 30 11 80    	mov    %ecx,0x801130f8
  if(kmem.use_lock)
80102f12:	85 d2                	test   %edx,%edx
80102f14:	74 16                	je     80102f2c <kalloc+0x6c>
    release(&kmem.lock);
80102f16:	83 ec 0c             	sub    $0xc,%esp
80102f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f1c:	68 c0 30 11 80       	push   $0x801130c0
80102f21:	e8 5a 1e 00 00       	call   80104d80 <release>
  return (char*)r;
80102f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	c9                   	leave  
80102f2d:	c3                   	ret    
80102f2e:	66 90                	xchg   %ax,%ax

80102f30 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f30:	ba 64 00 00 00       	mov    $0x64,%edx
80102f35:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f36:	a8 01                	test   $0x1,%al
80102f38:	0f 84 c2 00 00 00    	je     80103000 <kbdgetc+0xd0>
{
80102f3e:	55                   	push   %ebp
80102f3f:	ba 60 00 00 00       	mov    $0x60,%edx
80102f44:	89 e5                	mov    %esp,%ebp
80102f46:	53                   	push   %ebx
80102f47:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102f48:	8b 1d fc 30 11 80    	mov    0x801130fc,%ebx
  data = inb(KBDATAP);
80102f4e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102f51:	3c e0                	cmp    $0xe0,%al
80102f53:	74 5b                	je     80102fb0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102f55:	89 da                	mov    %ebx,%edx
80102f57:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102f5a:	84 c0                	test   %al,%al
80102f5c:	78 62                	js     80102fc0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f5e:	85 d2                	test   %edx,%edx
80102f60:	74 09                	je     80102f6b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f62:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f65:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102f68:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102f6b:	0f b6 91 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%edx
  shift ^= togglecode[data];
80102f72:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
  shift |= shiftcode[data];
80102f79:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102f7b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f7d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102f7f:	89 15 fc 30 11 80    	mov    %edx,0x801130fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102f85:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f88:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f8b:	8b 04 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%eax
80102f92:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102f96:	74 0b                	je     80102fa3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102f98:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f9b:	83 fa 19             	cmp    $0x19,%edx
80102f9e:	77 48                	ja     80102fe8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102fa0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fa6:	c9                   	leave  
80102fa7:	c3                   	ret    
80102fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop
    shift |= E0ESC;
80102fb0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102fb3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102fb5:	89 1d fc 30 11 80    	mov    %ebx,0x801130fc
}
80102fbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fbe:	c9                   	leave  
80102fbf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102fc0:	83 e0 7f             	and    $0x7f,%eax
80102fc3:	85 d2                	test   %edx,%edx
80102fc5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102fc8:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
80102fcf:	83 c8 40             	or     $0x40,%eax
80102fd2:	0f b6 c0             	movzbl %al,%eax
80102fd5:	f7 d0                	not    %eax
80102fd7:	21 d8                	and    %ebx,%eax
}
80102fd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102fdc:	a3 fc 30 11 80       	mov    %eax,0x801130fc
    return 0;
80102fe1:	31 c0                	xor    %eax,%eax
}
80102fe3:	c9                   	leave  
80102fe4:	c3                   	ret    
80102fe5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102fe8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102feb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ff1:	c9                   	leave  
      c += 'a' - 'A';
80102ff2:	83 f9 1a             	cmp    $0x1a,%ecx
80102ff5:	0f 42 c2             	cmovb  %edx,%eax
}
80102ff8:	c3                   	ret    
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103005:	c3                   	ret    
80103006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010300d:	8d 76 00             	lea    0x0(%esi),%esi

80103010 <kbdintr>:

void
kbdintr(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103016:	68 30 2f 10 80       	push   $0x80102f30
8010301b:	e8 d0 dd ff ff       	call   80100df0 <consoleintr>
}
80103020:	83 c4 10             	add    $0x10,%esp
80103023:	c9                   	leave  
80103024:	c3                   	ret    
80103025:	66 90                	xchg   %ax,%ax
80103027:	66 90                	xchg   %ax,%ax
80103029:	66 90                	xchg   %ax,%ax
8010302b:	66 90                	xchg   %ax,%ax
8010302d:	66 90                	xchg   %ax,%ax
8010302f:	90                   	nop

80103030 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103030:	a1 00 31 11 80       	mov    0x80113100,%eax
80103035:	85 c0                	test   %eax,%eax
80103037:	0f 84 cb 00 00 00    	je     80103108 <lapicinit+0xd8>
  lapic[index] = value;
8010303d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103044:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103047:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010304a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103051:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103054:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103057:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010305e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103061:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103064:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010306b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010306e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103071:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103078:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010307b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010307e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103085:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103088:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010308b:	8b 50 30             	mov    0x30(%eax),%edx
8010308e:	c1 ea 10             	shr    $0x10,%edx
80103091:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103097:	75 77                	jne    80103110 <lapicinit+0xe0>
  lapic[index] = value;
80103099:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801030a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801030d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801030e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801030e4:	8b 50 20             	mov    0x20(%eax),%edx
801030e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ee:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801030f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801030f6:	80 e6 10             	and    $0x10,%dh
801030f9:	75 f5                	jne    801030f0 <lapicinit+0xc0>
  lapic[index] = value;
801030fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103102:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103105:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103108:	c3                   	ret    
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103110:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103117:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010311a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010311d:	e9 77 ff ff ff       	jmp    80103099 <lapicinit+0x69>
80103122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103130 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103130:	a1 00 31 11 80       	mov    0x80113100,%eax
80103135:	85 c0                	test   %eax,%eax
80103137:	74 07                	je     80103140 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103139:	8b 40 20             	mov    0x20(%eax),%eax
8010313c:	c1 e8 18             	shr    $0x18,%eax
8010313f:	c3                   	ret    
    return 0;
80103140:	31 c0                	xor    %eax,%eax
}
80103142:	c3                   	ret    
80103143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103150 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103150:	a1 00 31 11 80       	mov    0x80113100,%eax
80103155:	85 c0                	test   %eax,%eax
80103157:	74 0d                	je     80103166 <lapiceoi+0x16>
  lapic[index] = value;
80103159:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103160:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103163:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103166:	c3                   	ret    
80103167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010316e:	66 90                	xchg   %ax,%ax

80103170 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103170:	c3                   	ret    
80103171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103180:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103181:	b8 0f 00 00 00       	mov    $0xf,%eax
80103186:	ba 70 00 00 00       	mov    $0x70,%edx
8010318b:	89 e5                	mov    %esp,%ebp
8010318d:	53                   	push   %ebx
8010318e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103191:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103194:	ee                   	out    %al,(%dx)
80103195:	b8 0a 00 00 00       	mov    $0xa,%eax
8010319a:	ba 71 00 00 00       	mov    $0x71,%edx
8010319f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801031a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801031a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801031ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801031ad:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801031b0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801031b2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801031b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801031b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801031be:	a1 00 31 11 80       	mov    0x80113100,%eax
801031c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801031d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801031e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103201:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103207:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010320a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010320d:	c9                   	leave  
8010320e:	c3                   	ret    
8010320f:	90                   	nop

80103210 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103210:	55                   	push   %ebp
80103211:	b8 0b 00 00 00       	mov    $0xb,%eax
80103216:	ba 70 00 00 00       	mov    $0x70,%edx
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	57                   	push   %edi
8010321e:	56                   	push   %esi
8010321f:	53                   	push   %ebx
80103220:	83 ec 4c             	sub    $0x4c,%esp
80103223:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103224:	ba 71 00 00 00       	mov    $0x71,%edx
80103229:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010322a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010322d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103232:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103235:	8d 76 00             	lea    0x0(%esi),%esi
80103238:	31 c0                	xor    %eax,%eax
8010323a:	89 da                	mov    %ebx,%edx
8010323c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010323d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103242:	89 ca                	mov    %ecx,%edx
80103244:	ec                   	in     (%dx),%al
80103245:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103248:	89 da                	mov    %ebx,%edx
8010324a:	b8 02 00 00 00       	mov    $0x2,%eax
8010324f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103250:	89 ca                	mov    %ecx,%edx
80103252:	ec                   	in     (%dx),%al
80103253:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103256:	89 da                	mov    %ebx,%edx
80103258:	b8 04 00 00 00       	mov    $0x4,%eax
8010325d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010325e:	89 ca                	mov    %ecx,%edx
80103260:	ec                   	in     (%dx),%al
80103261:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103264:	89 da                	mov    %ebx,%edx
80103266:	b8 07 00 00 00       	mov    $0x7,%eax
8010326b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010326c:	89 ca                	mov    %ecx,%edx
8010326e:	ec                   	in     (%dx),%al
8010326f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103272:	89 da                	mov    %ebx,%edx
80103274:	b8 08 00 00 00       	mov    $0x8,%eax
80103279:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010327a:	89 ca                	mov    %ecx,%edx
8010327c:	ec                   	in     (%dx),%al
8010327d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010327f:	89 da                	mov    %ebx,%edx
80103281:	b8 09 00 00 00       	mov    $0x9,%eax
80103286:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103287:	89 ca                	mov    %ecx,%edx
80103289:	ec                   	in     (%dx),%al
8010328a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010328c:	89 da                	mov    %ebx,%edx
8010328e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103293:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103294:	89 ca                	mov    %ecx,%edx
80103296:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103297:	84 c0                	test   %al,%al
80103299:	78 9d                	js     80103238 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010329b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010329f:	89 fa                	mov    %edi,%edx
801032a1:	0f b6 fa             	movzbl %dl,%edi
801032a4:	89 f2                	mov    %esi,%edx
801032a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801032a9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801032ad:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b0:	89 da                	mov    %ebx,%edx
801032b2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801032b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801032b8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801032bc:	89 75 cc             	mov    %esi,-0x34(%ebp)
801032bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801032c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801032c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801032c9:	31 c0                	xor    %eax,%eax
801032cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032cc:	89 ca                	mov    %ecx,%edx
801032ce:	ec                   	in     (%dx),%al
801032cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d2:	89 da                	mov    %ebx,%edx
801032d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801032d7:	b8 02 00 00 00       	mov    $0x2,%eax
801032dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032dd:	89 ca                	mov    %ecx,%edx
801032df:	ec                   	in     (%dx),%al
801032e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032e3:	89 da                	mov    %ebx,%edx
801032e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801032e8:	b8 04 00 00 00       	mov    $0x4,%eax
801032ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ee:	89 ca                	mov    %ecx,%edx
801032f0:	ec                   	in     (%dx),%al
801032f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f4:	89 da                	mov    %ebx,%edx
801032f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801032f9:	b8 07 00 00 00       	mov    $0x7,%eax
801032fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ff:	89 ca                	mov    %ecx,%edx
80103301:	ec                   	in     (%dx),%al
80103302:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103305:	89 da                	mov    %ebx,%edx
80103307:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010330a:	b8 08 00 00 00       	mov    $0x8,%eax
8010330f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103310:	89 ca                	mov    %ecx,%edx
80103312:	ec                   	in     (%dx),%al
80103313:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103316:	89 da                	mov    %ebx,%edx
80103318:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010331b:	b8 09 00 00 00       	mov    $0x9,%eax
80103320:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103321:	89 ca                	mov    %ecx,%edx
80103323:	ec                   	in     (%dx),%al
80103324:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103327:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010332a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010332d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103330:	6a 18                	push   $0x18
80103332:	50                   	push   %eax
80103333:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103336:	50                   	push   %eax
80103337:	e8 b4 1b 00 00       	call   80104ef0 <memcmp>
8010333c:	83 c4 10             	add    $0x10,%esp
8010333f:	85 c0                	test   %eax,%eax
80103341:	0f 85 f1 fe ff ff    	jne    80103238 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103347:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010334b:	75 78                	jne    801033c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010334d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103350:	89 c2                	mov    %eax,%edx
80103352:	83 e0 0f             	and    $0xf,%eax
80103355:	c1 ea 04             	shr    $0x4,%edx
80103358:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010335b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010335e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103361:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103364:	89 c2                	mov    %eax,%edx
80103366:	83 e0 0f             	and    $0xf,%eax
80103369:	c1 ea 04             	shr    $0x4,%edx
8010336c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010336f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103372:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103375:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103378:	89 c2                	mov    %eax,%edx
8010337a:	83 e0 0f             	and    $0xf,%eax
8010337d:	c1 ea 04             	shr    $0x4,%edx
80103380:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103383:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103386:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103389:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010338c:	89 c2                	mov    %eax,%edx
8010338e:	83 e0 0f             	and    $0xf,%eax
80103391:	c1 ea 04             	shr    $0x4,%edx
80103394:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103397:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010339a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010339d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033a0:	89 c2                	mov    %eax,%edx
801033a2:	83 e0 0f             	and    $0xf,%eax
801033a5:	c1 ea 04             	shr    $0x4,%edx
801033a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801033b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	83 e0 0f             	and    $0xf,%eax
801033b9:	c1 ea 04             	shr    $0x4,%edx
801033bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801033c5:	8b 75 08             	mov    0x8(%ebp),%esi
801033c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033cb:	89 06                	mov    %eax,(%esi)
801033cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033d0:	89 46 04             	mov    %eax,0x4(%esi)
801033d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033d6:	89 46 08             	mov    %eax,0x8(%esi)
801033d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033dc:	89 46 0c             	mov    %eax,0xc(%esi)
801033df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033e2:	89 46 10             	mov    %eax,0x10(%esi)
801033e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801033eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801033f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033f5:	5b                   	pop    %ebx
801033f6:	5e                   	pop    %esi
801033f7:	5f                   	pop    %edi
801033f8:	5d                   	pop    %ebp
801033f9:	c3                   	ret    
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103400:	8b 0d 68 31 11 80    	mov    0x80113168,%ecx
80103406:	85 c9                	test   %ecx,%ecx
80103408:	0f 8e 8a 00 00 00    	jle    80103498 <install_trans+0x98>
{
8010340e:	55                   	push   %ebp
8010340f:	89 e5                	mov    %esp,%ebp
80103411:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103412:	31 ff                	xor    %edi,%edi
{
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103420:	a1 54 31 11 80       	mov    0x80113154,%eax
80103425:	83 ec 08             	sub    $0x8,%esp
80103428:	01 f8                	add    %edi,%eax
8010342a:	83 c0 01             	add    $0x1,%eax
8010342d:	50                   	push   %eax
8010342e:	ff 35 64 31 11 80    	push   0x80113164
80103434:	e8 97 cc ff ff       	call   801000d0 <bread>
80103439:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010343b:	58                   	pop    %eax
8010343c:	5a                   	pop    %edx
8010343d:	ff 34 bd 6c 31 11 80 	push   -0x7feece94(,%edi,4)
80103444:	ff 35 64 31 11 80    	push   0x80113164
  for (tail = 0; tail < log.lh.n; tail++) {
8010344a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010344d:	e8 7e cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103452:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103455:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103457:	8d 46 5c             	lea    0x5c(%esi),%eax
8010345a:	68 00 02 00 00       	push   $0x200
8010345f:	50                   	push   %eax
80103460:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103463:	50                   	push   %eax
80103464:	e8 d7 1a 00 00       	call   80104f40 <memmove>
    bwrite(dbuf);  // write dst to disk
80103469:	89 1c 24             	mov    %ebx,(%esp)
8010346c:	e8 3f cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103471:	89 34 24             	mov    %esi,(%esp)
80103474:	e8 77 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103479:	89 1c 24             	mov    %ebx,(%esp)
8010347c:	e8 6f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103481:	83 c4 10             	add    $0x10,%esp
80103484:	39 3d 68 31 11 80    	cmp    %edi,0x80113168
8010348a:	7f 94                	jg     80103420 <install_trans+0x20>
  }
}
8010348c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010348f:	5b                   	pop    %ebx
80103490:	5e                   	pop    %esi
80103491:	5f                   	pop    %edi
80103492:	5d                   	pop    %ebp
80103493:	c3                   	ret    
80103494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103498:	c3                   	ret    
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	53                   	push   %ebx
801034a4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801034a7:	ff 35 54 31 11 80    	push   0x80113154
801034ad:	ff 35 64 31 11 80    	push   0x80113164
801034b3:	e8 18 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034b8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801034bb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801034bd:	a1 68 31 11 80       	mov    0x80113168,%eax
801034c2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801034c5:	85 c0                	test   %eax,%eax
801034c7:	7e 19                	jle    801034e2 <write_head+0x42>
801034c9:	31 d2                	xor    %edx,%edx
801034cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034cf:	90                   	nop
    hb->block[i] = log.lh.block[i];
801034d0:	8b 0c 95 6c 31 11 80 	mov    -0x7feece94(,%edx,4),%ecx
801034d7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034db:	83 c2 01             	add    $0x1,%edx
801034de:	39 d0                	cmp    %edx,%eax
801034e0:	75 ee                	jne    801034d0 <write_head+0x30>
  }
  bwrite(buf);
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	53                   	push   %ebx
801034e6:	e8 c5 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801034eb:	89 1c 24             	mov    %ebx,(%esp)
801034ee:	e8 fd cc ff ff       	call   801001f0 <brelse>
}
801034f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034f6:	83 c4 10             	add    $0x10,%esp
801034f9:	c9                   	leave  
801034fa:	c3                   	ret    
801034fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <initlog>:
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	53                   	push   %ebx
80103504:	83 ec 2c             	sub    $0x2c,%esp
80103507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010350a:	68 80 7e 10 80       	push   $0x80107e80
8010350f:	68 20 31 11 80       	push   $0x80113120
80103514:	e8 f7 16 00 00       	call   80104c10 <initlock>
  readsb(dev, &sb);
80103519:	58                   	pop    %eax
8010351a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010351d:	5a                   	pop    %edx
8010351e:	50                   	push   %eax
8010351f:	53                   	push   %ebx
80103520:	e8 3b e8 ff ff       	call   80101d60 <readsb>
  log.start = sb.logstart;
80103525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103528:	59                   	pop    %ecx
  log.dev = dev;
80103529:	89 1d 64 31 11 80    	mov    %ebx,0x80113164
  log.size = sb.nlog;
8010352f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103532:	a3 54 31 11 80       	mov    %eax,0x80113154
  log.size = sb.nlog;
80103537:	89 15 58 31 11 80    	mov    %edx,0x80113158
  struct buf *buf = bread(log.dev, log.start);
8010353d:	5a                   	pop    %edx
8010353e:	50                   	push   %eax
8010353f:	53                   	push   %ebx
80103540:	e8 8b cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103545:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103548:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010354b:	89 1d 68 31 11 80    	mov    %ebx,0x80113168
  for (i = 0; i < log.lh.n; i++) {
80103551:	85 db                	test   %ebx,%ebx
80103553:	7e 1d                	jle    80103572 <initlog+0x72>
80103555:	31 d2                	xor    %edx,%edx
80103557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103560:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103564:	89 0c 95 6c 31 11 80 	mov    %ecx,-0x7feece94(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010356b:	83 c2 01             	add    $0x1,%edx
8010356e:	39 d3                	cmp    %edx,%ebx
80103570:	75 ee                	jne    80103560 <initlog+0x60>
  brelse(buf);
80103572:	83 ec 0c             	sub    $0xc,%esp
80103575:	50                   	push   %eax
80103576:	e8 75 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010357b:	e8 80 fe ff ff       	call   80103400 <install_trans>
  log.lh.n = 0;
80103580:	c7 05 68 31 11 80 00 	movl   $0x0,0x80113168
80103587:	00 00 00 
  write_head(); // clear the log
8010358a:	e8 11 ff ff ff       	call   801034a0 <write_head>
}
8010358f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103592:	83 c4 10             	add    $0x10,%esp
80103595:	c9                   	leave  
80103596:	c3                   	ret    
80103597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801035a6:	68 20 31 11 80       	push   $0x80113120
801035ab:	e8 30 18 00 00       	call   80104de0 <acquire>
801035b0:	83 c4 10             	add    $0x10,%esp
801035b3:	eb 18                	jmp    801035cd <begin_op+0x2d>
801035b5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801035b8:	83 ec 08             	sub    $0x8,%esp
801035bb:	68 20 31 11 80       	push   $0x80113120
801035c0:	68 20 31 11 80       	push   $0x80113120
801035c5:	e8 b6 12 00 00       	call   80104880 <sleep>
801035ca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801035cd:	a1 60 31 11 80       	mov    0x80113160,%eax
801035d2:	85 c0                	test   %eax,%eax
801035d4:	75 e2                	jne    801035b8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035d6:	a1 5c 31 11 80       	mov    0x8011315c,%eax
801035db:	8b 15 68 31 11 80    	mov    0x80113168,%edx
801035e1:	83 c0 01             	add    $0x1,%eax
801035e4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801035e7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801035ea:	83 fa 1e             	cmp    $0x1e,%edx
801035ed:	7f c9                	jg     801035b8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801035ef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801035f2:	a3 5c 31 11 80       	mov    %eax,0x8011315c
      release(&log.lock);
801035f7:	68 20 31 11 80       	push   $0x80113120
801035fc:	e8 7f 17 00 00       	call   80104d80 <release>
      break;
    }
  }
}
80103601:	83 c4 10             	add    $0x10,%esp
80103604:	c9                   	leave  
80103605:	c3                   	ret    
80103606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010360d:	8d 76 00             	lea    0x0(%esi),%esi

80103610 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103619:	68 20 31 11 80       	push   $0x80113120
8010361e:	e8 bd 17 00 00       	call   80104de0 <acquire>
  log.outstanding -= 1;
80103623:	a1 5c 31 11 80       	mov    0x8011315c,%eax
  if(log.committing)
80103628:	8b 35 60 31 11 80    	mov    0x80113160,%esi
8010362e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103631:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103634:	89 1d 5c 31 11 80    	mov    %ebx,0x8011315c
  if(log.committing)
8010363a:	85 f6                	test   %esi,%esi
8010363c:	0f 85 22 01 00 00    	jne    80103764 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103642:	85 db                	test   %ebx,%ebx
80103644:	0f 85 f6 00 00 00    	jne    80103740 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010364a:	c7 05 60 31 11 80 01 	movl   $0x1,0x80113160
80103651:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	68 20 31 11 80       	push   $0x80113120
8010365c:	e8 1f 17 00 00       	call   80104d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103661:	8b 0d 68 31 11 80    	mov    0x80113168,%ecx
80103667:	83 c4 10             	add    $0x10,%esp
8010366a:	85 c9                	test   %ecx,%ecx
8010366c:	7f 42                	jg     801036b0 <end_op+0xa0>
    acquire(&log.lock);
8010366e:	83 ec 0c             	sub    $0xc,%esp
80103671:	68 20 31 11 80       	push   $0x80113120
80103676:	e8 65 17 00 00       	call   80104de0 <acquire>
    wakeup(&log);
8010367b:	c7 04 24 20 31 11 80 	movl   $0x80113120,(%esp)
    log.committing = 0;
80103682:	c7 05 60 31 11 80 00 	movl   $0x0,0x80113160
80103689:	00 00 00 
    wakeup(&log);
8010368c:	e8 af 12 00 00       	call   80104940 <wakeup>
    release(&log.lock);
80103691:	c7 04 24 20 31 11 80 	movl   $0x80113120,(%esp)
80103698:	e8 e3 16 00 00       	call   80104d80 <release>
8010369d:	83 c4 10             	add    $0x10,%esp
}
801036a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a3:	5b                   	pop    %ebx
801036a4:	5e                   	pop    %esi
801036a5:	5f                   	pop    %edi
801036a6:	5d                   	pop    %ebp
801036a7:	c3                   	ret    
801036a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036af:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036b0:	a1 54 31 11 80       	mov    0x80113154,%eax
801036b5:	83 ec 08             	sub    $0x8,%esp
801036b8:	01 d8                	add    %ebx,%eax
801036ba:	83 c0 01             	add    $0x1,%eax
801036bd:	50                   	push   %eax
801036be:	ff 35 64 31 11 80    	push   0x80113164
801036c4:	e8 07 ca ff ff       	call   801000d0 <bread>
801036c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036cb:	58                   	pop    %eax
801036cc:	5a                   	pop    %edx
801036cd:	ff 34 9d 6c 31 11 80 	push   -0x7feece94(,%ebx,4)
801036d4:	ff 35 64 31 11 80    	push   0x80113164
  for (tail = 0; tail < log.lh.n; tail++) {
801036da:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036dd:	e8 ee c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801036e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036e5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801036e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801036ea:	68 00 02 00 00       	push   $0x200
801036ef:	50                   	push   %eax
801036f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801036f3:	50                   	push   %eax
801036f4:	e8 47 18 00 00       	call   80104f40 <memmove>
    bwrite(to);  // write the log
801036f9:	89 34 24             	mov    %esi,(%esp)
801036fc:	e8 af ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103701:	89 3c 24             	mov    %edi,(%esp)
80103704:	e8 e7 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
80103709:	89 34 24             	mov    %esi,(%esp)
8010370c:	e8 df ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	3b 1d 68 31 11 80    	cmp    0x80113168,%ebx
8010371a:	7c 94                	jl     801036b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010371c:	e8 7f fd ff ff       	call   801034a0 <write_head>
    install_trans(); // Now install writes to home locations
80103721:	e8 da fc ff ff       	call   80103400 <install_trans>
    log.lh.n = 0;
80103726:	c7 05 68 31 11 80 00 	movl   $0x0,0x80113168
8010372d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103730:	e8 6b fd ff ff       	call   801034a0 <write_head>
80103735:	e9 34 ff ff ff       	jmp    8010366e <end_op+0x5e>
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	68 20 31 11 80       	push   $0x80113120
80103748:	e8 f3 11 00 00       	call   80104940 <wakeup>
  release(&log.lock);
8010374d:	c7 04 24 20 31 11 80 	movl   $0x80113120,(%esp)
80103754:	e8 27 16 00 00       	call   80104d80 <release>
80103759:	83 c4 10             	add    $0x10,%esp
}
8010375c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010375f:	5b                   	pop    %ebx
80103760:	5e                   	pop    %esi
80103761:	5f                   	pop    %edi
80103762:	5d                   	pop    %ebp
80103763:	c3                   	ret    
    panic("log.committing");
80103764:	83 ec 0c             	sub    $0xc,%esp
80103767:	68 84 7e 10 80       	push   $0x80107e84
8010376c:	e8 0f cc ff ff       	call   80100380 <panic>
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010377f:	90                   	nop

80103780 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
80103784:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103787:	8b 15 68 31 11 80    	mov    0x80113168,%edx
{
8010378d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103790:	83 fa 1d             	cmp    $0x1d,%edx
80103793:	0f 8f 85 00 00 00    	jg     8010381e <log_write+0x9e>
80103799:	a1 58 31 11 80       	mov    0x80113158,%eax
8010379e:	83 e8 01             	sub    $0x1,%eax
801037a1:	39 c2                	cmp    %eax,%edx
801037a3:	7d 79                	jge    8010381e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801037a5:	a1 5c 31 11 80       	mov    0x8011315c,%eax
801037aa:	85 c0                	test   %eax,%eax
801037ac:	7e 7d                	jle    8010382b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801037ae:	83 ec 0c             	sub    $0xc,%esp
801037b1:	68 20 31 11 80       	push   $0x80113120
801037b6:	e8 25 16 00 00       	call   80104de0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801037bb:	8b 15 68 31 11 80    	mov    0x80113168,%edx
801037c1:	83 c4 10             	add    $0x10,%esp
801037c4:	85 d2                	test   %edx,%edx
801037c6:	7e 4a                	jle    80103812 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037c8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801037cb:	31 c0                	xor    %eax,%eax
801037cd:	eb 08                	jmp    801037d7 <log_write+0x57>
801037cf:	90                   	nop
801037d0:	83 c0 01             	add    $0x1,%eax
801037d3:	39 c2                	cmp    %eax,%edx
801037d5:	74 29                	je     80103800 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037d7:	39 0c 85 6c 31 11 80 	cmp    %ecx,-0x7feece94(,%eax,4)
801037de:	75 f0                	jne    801037d0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801037e0:	89 0c 85 6c 31 11 80 	mov    %ecx,-0x7feece94(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801037e7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801037ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801037ed:	c7 45 08 20 31 11 80 	movl   $0x80113120,0x8(%ebp)
}
801037f4:	c9                   	leave  
  release(&log.lock);
801037f5:	e9 86 15 00 00       	jmp    80104d80 <release>
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103800:	89 0c 95 6c 31 11 80 	mov    %ecx,-0x7feece94(,%edx,4)
    log.lh.n++;
80103807:	83 c2 01             	add    $0x1,%edx
8010380a:	89 15 68 31 11 80    	mov    %edx,0x80113168
80103810:	eb d5                	jmp    801037e7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103812:	8b 43 08             	mov    0x8(%ebx),%eax
80103815:	a3 6c 31 11 80       	mov    %eax,0x8011316c
  if (i == log.lh.n)
8010381a:	75 cb                	jne    801037e7 <log_write+0x67>
8010381c:	eb e9                	jmp    80103807 <log_write+0x87>
    panic("too big a transaction");
8010381e:	83 ec 0c             	sub    $0xc,%esp
80103821:	68 93 7e 10 80       	push   $0x80107e93
80103826:	e8 55 cb ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010382b:	83 ec 0c             	sub    $0xc,%esp
8010382e:	68 a9 7e 10 80       	push   $0x80107ea9
80103833:	e8 48 cb ff ff       	call   80100380 <panic>
80103838:	66 90                	xchg   %ax,%ax
8010383a:	66 90                	xchg   %ax,%ax
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
80103844:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103847:	e8 44 09 00 00       	call   80104190 <cpuid>
8010384c:	89 c3                	mov    %eax,%ebx
8010384e:	e8 3d 09 00 00       	call   80104190 <cpuid>
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	53                   	push   %ebx
80103857:	50                   	push   %eax
80103858:	68 c4 7e 10 80       	push   $0x80107ec4
8010385d:	e8 9e ce ff ff       	call   80100700 <cprintf>
  idtinit();       // load idt register
80103862:	e8 b9 28 00 00       	call   80106120 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103867:	e8 c4 08 00 00       	call   80104130 <mycpu>
8010386c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010386e:	b8 01 00 00 00       	mov    $0x1,%eax
80103873:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010387a:	e8 f1 0b 00 00       	call   80104470 <scheduler>
8010387f:	90                   	nop

80103880 <mpenter>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103886:	e8 85 39 00 00       	call   80107210 <switchkvm>
  seginit();
8010388b:	e8 f0 38 00 00       	call   80107180 <seginit>
  lapicinit();
80103890:	e8 9b f7 ff ff       	call   80103030 <lapicinit>
  mpmain();
80103895:	e8 a6 ff ff ff       	call   80103840 <mpmain>
8010389a:	66 90                	xchg   %ax,%ax
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <main>:
{
801038a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038a4:	83 e4 f0             	and    $0xfffffff0,%esp
801038a7:	ff 71 fc             	push   -0x4(%ecx)
801038aa:	55                   	push   %ebp
801038ab:	89 e5                	mov    %esp,%ebp
801038ad:	53                   	push   %ebx
801038ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038af:	83 ec 08             	sub    $0x8,%esp
801038b2:	68 00 00 40 80       	push   $0x80400000
801038b7:	68 50 6f 11 80       	push   $0x80116f50
801038bc:	e8 8f f5 ff ff       	call   80102e50 <kinit1>
  kvmalloc();      // kernel page table
801038c1:	e8 3a 3e 00 00       	call   80107700 <kvmalloc>
  mpinit();        // detect other processors
801038c6:	e8 85 01 00 00       	call   80103a50 <mpinit>
  lapicinit();     // interrupt controller
801038cb:	e8 60 f7 ff ff       	call   80103030 <lapicinit>
  seginit();       // segment descriptors
801038d0:	e8 ab 38 00 00       	call   80107180 <seginit>
  picinit();       // disable pic
801038d5:	e8 76 03 00 00       	call   80103c50 <picinit>
  ioapicinit();    // another interrupt controller
801038da:	e8 31 f3 ff ff       	call   80102c10 <ioapicinit>
  consoleinit();   // console hardware
801038df:	e8 bc d9 ff ff       	call   801012a0 <consoleinit>
  uartinit();      // serial port
801038e4:	e8 27 2b 00 00       	call   80106410 <uartinit>
  pinit();         // process table
801038e9:	e8 22 08 00 00       	call   80104110 <pinit>
  tvinit();        // trap vectors
801038ee:	e8 ad 27 00 00       	call   801060a0 <tvinit>
  binit();         // buffer cache
801038f3:	e8 48 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801038f8:	e8 53 dd ff ff       	call   80101650 <fileinit>
  ideinit();       // disk 
801038fd:	e8 fe f0 ff ff       	call   80102a00 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103902:	83 c4 0c             	add    $0xc,%esp
80103905:	68 8a 00 00 00       	push   $0x8a
8010390a:	68 8c b4 10 80       	push   $0x8010b48c
8010390f:	68 00 70 00 80       	push   $0x80007000
80103914:	e8 27 16 00 00       	call   80104f40 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	69 05 04 32 11 80 b0 	imul   $0xb0,0x80113204,%eax
80103923:	00 00 00 
80103926:	05 20 32 11 80       	add    $0x80113220,%eax
8010392b:	3d 20 32 11 80       	cmp    $0x80113220,%eax
80103930:	76 7e                	jbe    801039b0 <main+0x110>
80103932:	bb 20 32 11 80       	mov    $0x80113220,%ebx
80103937:	eb 20                	jmp    80103959 <main+0xb9>
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103940:	69 05 04 32 11 80 b0 	imul   $0xb0,0x80113204,%eax
80103947:	00 00 00 
8010394a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103950:	05 20 32 11 80       	add    $0x80113220,%eax
80103955:	39 c3                	cmp    %eax,%ebx
80103957:	73 57                	jae    801039b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103959:	e8 d2 07 00 00       	call   80104130 <mycpu>
8010395e:	39 c3                	cmp    %eax,%ebx
80103960:	74 de                	je     80103940 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103962:	e8 59 f5 ff ff       	call   80102ec0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103967:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010396a:	c7 05 f8 6f 00 80 80 	movl   $0x80103880,0x80006ff8
80103971:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103974:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010397b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010397e:	05 00 10 00 00       	add    $0x1000,%eax
80103983:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103988:	0f b6 03             	movzbl (%ebx),%eax
8010398b:	68 00 70 00 00       	push   $0x7000
80103990:	50                   	push   %eax
80103991:	e8 ea f7 ff ff       	call   80103180 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801039a6:	85 c0                	test   %eax,%eax
801039a8:	74 f6                	je     801039a0 <main+0x100>
801039aa:	eb 94                	jmp    80103940 <main+0xa0>
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039b0:	83 ec 08             	sub    $0x8,%esp
801039b3:	68 00 00 00 8e       	push   $0x8e000000
801039b8:	68 00 00 40 80       	push   $0x80400000
801039bd:	e8 2e f4 ff ff       	call   80102df0 <kinit2>
  userinit();      // first user process
801039c2:	e8 19 08 00 00       	call   801041e0 <userinit>
  mpmain();        // finish this processor's setup
801039c7:	e8 74 fe ff ff       	call   80103840 <mpmain>
801039cc:	66 90                	xchg   %ax,%ax
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801039d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801039db:	53                   	push   %ebx
  e = addr+len;
801039dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801039df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801039e2:	39 de                	cmp    %ebx,%esi
801039e4:	72 10                	jb     801039f6 <mpsearch1+0x26>
801039e6:	eb 50                	jmp    80103a38 <mpsearch1+0x68>
801039e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop
801039f0:	89 fe                	mov    %edi,%esi
801039f2:	39 fb                	cmp    %edi,%ebx
801039f4:	76 42                	jbe    80103a38 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039f6:	83 ec 04             	sub    $0x4,%esp
801039f9:	8d 7e 10             	lea    0x10(%esi),%edi
801039fc:	6a 04                	push   $0x4
801039fe:	68 d8 7e 10 80       	push   $0x80107ed8
80103a03:	56                   	push   %esi
80103a04:	e8 e7 14 00 00       	call   80104ef0 <memcmp>
80103a09:	83 c4 10             	add    $0x10,%esp
80103a0c:	85 c0                	test   %eax,%eax
80103a0e:	75 e0                	jne    801039f0 <mpsearch1+0x20>
80103a10:	89 f2                	mov    %esi,%edx
80103a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a18:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103a1b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103a1e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a20:	39 fa                	cmp    %edi,%edx
80103a22:	75 f4                	jne    80103a18 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a24:	84 c0                	test   %al,%al
80103a26:	75 c8                	jne    801039f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2b:	89 f0                	mov    %esi,%eax
80103a2d:	5b                   	pop    %ebx
80103a2e:	5e                   	pop    %esi
80103a2f:	5f                   	pop    %edi
80103a30:	5d                   	pop    %ebp
80103a31:	c3                   	ret    
80103a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a3b:	31 f6                	xor    %esi,%esi
}
80103a3d:	5b                   	pop    %ebx
80103a3e:	89 f0                	mov    %esi,%eax
80103a40:	5e                   	pop    %esi
80103a41:	5f                   	pop    %edi
80103a42:	5d                   	pop    %ebp
80103a43:	c3                   	ret    
80103a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a4f:	90                   	nop

80103a50 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	57                   	push   %edi
80103a54:	56                   	push   %esi
80103a55:	53                   	push   %ebx
80103a56:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a59:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103a60:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103a67:	c1 e0 08             	shl    $0x8,%eax
80103a6a:	09 d0                	or     %edx,%eax
80103a6c:	c1 e0 04             	shl    $0x4,%eax
80103a6f:	75 1b                	jne    80103a8c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a71:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a78:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a7f:	c1 e0 08             	shl    $0x8,%eax
80103a82:	09 d0                	or     %edx,%eax
80103a84:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a87:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a8c:	ba 00 04 00 00       	mov    $0x400,%edx
80103a91:	e8 3a ff ff ff       	call   801039d0 <mpsearch1>
80103a96:	89 c3                	mov    %eax,%ebx
80103a98:	85 c0                	test   %eax,%eax
80103a9a:	0f 84 40 01 00 00    	je     80103be0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103aa0:	8b 73 04             	mov    0x4(%ebx),%esi
80103aa3:	85 f6                	test   %esi,%esi
80103aa5:	0f 84 25 01 00 00    	je     80103bd0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
80103aab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103aae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103ab4:	6a 04                	push   $0x4
80103ab6:	68 dd 7e 10 80       	push   $0x80107edd
80103abb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103abc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103abf:	e8 2c 14 00 00       	call   80104ef0 <memcmp>
80103ac4:	83 c4 10             	add    $0x10,%esp
80103ac7:	85 c0                	test   %eax,%eax
80103ac9:	0f 85 01 01 00 00    	jne    80103bd0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
80103acf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103ad6:	3c 01                	cmp    $0x1,%al
80103ad8:	74 08                	je     80103ae2 <mpinit+0x92>
80103ada:	3c 04                	cmp    $0x4,%al
80103adc:	0f 85 ee 00 00 00    	jne    80103bd0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103ae2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103ae9:	66 85 d2             	test   %dx,%dx
80103aec:	74 22                	je     80103b10 <mpinit+0xc0>
80103aee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103af1:	89 f0                	mov    %esi,%eax
  sum = 0;
80103af3:	31 d2                	xor    %edx,%edx
80103af5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103af8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103aff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103b02:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b04:	39 c7                	cmp    %eax,%edi
80103b06:	75 f0                	jne    80103af8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103b08:	84 d2                	test   %dl,%dl
80103b0a:	0f 85 c0 00 00 00    	jne    80103bd0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b10:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103b16:	a3 00 31 11 80       	mov    %eax,0x80113100
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b1b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103b22:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103b28:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b2d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103b30:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b37:	90                   	nop
80103b38:	39 d0                	cmp    %edx,%eax
80103b3a:	73 15                	jae    80103b51 <mpinit+0x101>
    switch(*p){
80103b3c:	0f b6 08             	movzbl (%eax),%ecx
80103b3f:	80 f9 02             	cmp    $0x2,%cl
80103b42:	74 4c                	je     80103b90 <mpinit+0x140>
80103b44:	77 3a                	ja     80103b80 <mpinit+0x130>
80103b46:	84 c9                	test   %cl,%cl
80103b48:	74 56                	je     80103ba0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b4a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b4d:	39 d0                	cmp    %edx,%eax
80103b4f:	72 eb                	jb     80103b3c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b51:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b54:	85 f6                	test   %esi,%esi
80103b56:	0f 84 d9 00 00 00    	je     80103c35 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103b5c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103b60:	74 15                	je     80103b77 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b62:	b8 70 00 00 00       	mov    $0x70,%eax
80103b67:	ba 22 00 00 00       	mov    $0x22,%edx
80103b6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b6d:	ba 23 00 00 00       	mov    $0x23,%edx
80103b72:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b73:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b76:	ee                   	out    %al,(%dx)
  }
}
80103b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b7a:	5b                   	pop    %ebx
80103b7b:	5e                   	pop    %esi
80103b7c:	5f                   	pop    %edi
80103b7d:	5d                   	pop    %ebp
80103b7e:	c3                   	ret    
80103b7f:	90                   	nop
    switch(*p){
80103b80:	83 e9 03             	sub    $0x3,%ecx
80103b83:	80 f9 01             	cmp    $0x1,%cl
80103b86:	76 c2                	jbe    80103b4a <mpinit+0xfa>
80103b88:	31 f6                	xor    %esi,%esi
80103b8a:	eb ac                	jmp    80103b38 <mpinit+0xe8>
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b90:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103b94:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b97:	88 0d 00 32 11 80    	mov    %cl,0x80113200
      continue;
80103b9d:	eb 99                	jmp    80103b38 <mpinit+0xe8>
80103b9f:	90                   	nop
      if(ncpu < NCPU) {
80103ba0:	8b 0d 04 32 11 80    	mov    0x80113204,%ecx
80103ba6:	83 f9 07             	cmp    $0x7,%ecx
80103ba9:	7f 19                	jg     80103bc4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bab:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103bb1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103bb5:	83 c1 01             	add    $0x1,%ecx
80103bb8:	89 0d 04 32 11 80    	mov    %ecx,0x80113204
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bbe:	88 9f 20 32 11 80    	mov    %bl,-0x7feecde0(%edi)
      p += sizeof(struct mpproc);
80103bc4:	83 c0 14             	add    $0x14,%eax
      continue;
80103bc7:	e9 6c ff ff ff       	jmp    80103b38 <mpinit+0xe8>
80103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	68 e2 7e 10 80       	push   $0x80107ee2
80103bd8:	e8 a3 c7 ff ff       	call   80100380 <panic>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi
{
80103be0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103be5:	eb 13                	jmp    80103bfa <mpinit+0x1aa>
80103be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bee:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103bf0:	89 f3                	mov    %esi,%ebx
80103bf2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103bf8:	74 d6                	je     80103bd0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103bfa:	83 ec 04             	sub    $0x4,%esp
80103bfd:	8d 73 10             	lea    0x10(%ebx),%esi
80103c00:	6a 04                	push   $0x4
80103c02:	68 d8 7e 10 80       	push   $0x80107ed8
80103c07:	53                   	push   %ebx
80103c08:	e8 e3 12 00 00       	call   80104ef0 <memcmp>
80103c0d:	83 c4 10             	add    $0x10,%esp
80103c10:	85 c0                	test   %eax,%eax
80103c12:	75 dc                	jne    80103bf0 <mpinit+0x1a0>
80103c14:	89 da                	mov    %ebx,%edx
80103c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103c20:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103c23:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103c26:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103c28:	39 d6                	cmp    %edx,%esi
80103c2a:	75 f4                	jne    80103c20 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c2c:	84 c0                	test   %al,%al
80103c2e:	75 c0                	jne    80103bf0 <mpinit+0x1a0>
80103c30:	e9 6b fe ff ff       	jmp    80103aa0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103c35:	83 ec 0c             	sub    $0xc,%esp
80103c38:	68 fc 7e 10 80       	push   $0x80107efc
80103c3d:	e8 3e c7 ff ff       	call   80100380 <panic>
80103c42:	66 90                	xchg   %ax,%ax
80103c44:	66 90                	xchg   %ax,%ax
80103c46:	66 90                	xchg   %ax,%ax
80103c48:	66 90                	xchg   %ax,%ax
80103c4a:	66 90                	xchg   %ax,%ax
80103c4c:	66 90                	xchg   %ax,%ax
80103c4e:	66 90                	xchg   %ax,%ax

80103c50 <picinit>:
80103c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c55:	ba 21 00 00 00       	mov    $0x21,%edx
80103c5a:	ee                   	out    %al,(%dx)
80103c5b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103c60:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103c61:	c3                   	ret    
80103c62:	66 90                	xchg   %ax,%ax
80103c64:	66 90                	xchg   %ax,%ax
80103c66:	66 90                	xchg   %ax,%ax
80103c68:	66 90                	xchg   %ax,%ax
80103c6a:	66 90                	xchg   %ax,%ax
80103c6c:	66 90                	xchg   %ax,%ax
80103c6e:	66 90                	xchg   %ax,%ax

80103c70 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 0c             	sub    $0xc,%esp
80103c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103c7f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103c85:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c8b:	e8 e0 d9 ff ff       	call   80101670 <filealloc>
80103c90:	89 03                	mov    %eax,(%ebx)
80103c92:	85 c0                	test   %eax,%eax
80103c94:	0f 84 a8 00 00 00    	je     80103d42 <pipealloc+0xd2>
80103c9a:	e8 d1 d9 ff ff       	call   80101670 <filealloc>
80103c9f:	89 06                	mov    %eax,(%esi)
80103ca1:	85 c0                	test   %eax,%eax
80103ca3:	0f 84 87 00 00 00    	je     80103d30 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ca9:	e8 12 f2 ff ff       	call   80102ec0 <kalloc>
80103cae:	89 c7                	mov    %eax,%edi
80103cb0:	85 c0                	test   %eax,%eax
80103cb2:	0f 84 b0 00 00 00    	je     80103d68 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103cb8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103cbf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103cc2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103cc5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ccc:	00 00 00 
  p->nwrite = 0;
80103ccf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cd6:	00 00 00 
  p->nread = 0;
80103cd9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ce0:	00 00 00 
  initlock(&p->lock, "pipe");
80103ce3:	68 1b 7f 10 80       	push   $0x80107f1b
80103ce8:	50                   	push   %eax
80103ce9:	e8 22 0f 00 00       	call   80104c10 <initlock>
  (*f0)->type = FD_PIPE;
80103cee:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103cf0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cf3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cf9:	8b 03                	mov    (%ebx),%eax
80103cfb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cff:	8b 03                	mov    (%ebx),%eax
80103d01:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d05:	8b 03                	mov    (%ebx),%eax
80103d07:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d0a:	8b 06                	mov    (%esi),%eax
80103d0c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d12:	8b 06                	mov    (%esi),%eax
80103d14:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d18:	8b 06                	mov    (%esi),%eax
80103d1a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d1e:	8b 06                	mov    (%esi),%eax
80103d20:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d26:	31 c0                	xor    %eax,%eax
}
80103d28:	5b                   	pop    %ebx
80103d29:	5e                   	pop    %esi
80103d2a:	5f                   	pop    %edi
80103d2b:	5d                   	pop    %ebp
80103d2c:	c3                   	ret    
80103d2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103d30:	8b 03                	mov    (%ebx),%eax
80103d32:	85 c0                	test   %eax,%eax
80103d34:	74 1e                	je     80103d54 <pipealloc+0xe4>
    fileclose(*f0);
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	50                   	push   %eax
80103d3a:	e8 f1 d9 ff ff       	call   80101730 <fileclose>
80103d3f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d42:	8b 06                	mov    (%esi),%eax
80103d44:	85 c0                	test   %eax,%eax
80103d46:	74 0c                	je     80103d54 <pipealloc+0xe4>
    fileclose(*f1);
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	50                   	push   %eax
80103d4c:	e8 df d9 ff ff       	call   80101730 <fileclose>
80103d51:	83 c4 10             	add    $0x10,%esp
}
80103d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103d57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d5c:	5b                   	pop    %ebx
80103d5d:	5e                   	pop    %esi
80103d5e:	5f                   	pop    %edi
80103d5f:	5d                   	pop    %ebp
80103d60:	c3                   	ret    
80103d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d68:	8b 03                	mov    (%ebx),%eax
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	75 c8                	jne    80103d36 <pipealloc+0xc6>
80103d6e:	eb d2                	jmp    80103d42 <pipealloc+0xd2>

80103d70 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d78:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103d7b:	83 ec 0c             	sub    $0xc,%esp
80103d7e:	53                   	push   %ebx
80103d7f:	e8 5c 10 00 00       	call   80104de0 <acquire>
  if(writable){
80103d84:	83 c4 10             	add    $0x10,%esp
80103d87:	85 f6                	test   %esi,%esi
80103d89:	74 65                	je     80103df0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103d94:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d9b:	00 00 00 
    wakeup(&p->nread);
80103d9e:	50                   	push   %eax
80103d9f:	e8 9c 0b 00 00       	call   80104940 <wakeup>
80103da4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103da7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103dad:	85 d2                	test   %edx,%edx
80103daf:	75 0a                	jne    80103dbb <pipeclose+0x4b>
80103db1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103db7:	85 c0                	test   %eax,%eax
80103db9:	74 15                	je     80103dd0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103dbb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dc1:	5b                   	pop    %ebx
80103dc2:	5e                   	pop    %esi
80103dc3:	5d                   	pop    %ebp
    release(&p->lock);
80103dc4:	e9 b7 0f 00 00       	jmp    80104d80 <release>
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	53                   	push   %ebx
80103dd4:	e8 a7 0f 00 00       	call   80104d80 <release>
    kfree((char*)p);
80103dd9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103ddc:	83 c4 10             	add    $0x10,%esp
}
80103ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de2:	5b                   	pop    %ebx
80103de3:	5e                   	pop    %esi
80103de4:	5d                   	pop    %ebp
    kfree((char*)p);
80103de5:	e9 16 ef ff ff       	jmp    80102d00 <kfree>
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103df0:	83 ec 0c             	sub    $0xc,%esp
80103df3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103df9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103e00:	00 00 00 
    wakeup(&p->nwrite);
80103e03:	50                   	push   %eax
80103e04:	e8 37 0b 00 00       	call   80104940 <wakeup>
80103e09:	83 c4 10             	add    $0x10,%esp
80103e0c:	eb 99                	jmp    80103da7 <pipeclose+0x37>
80103e0e:	66 90                	xchg   %ax,%ax

80103e10 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 28             	sub    $0x28,%esp
80103e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103e1c:	53                   	push   %ebx
80103e1d:	e8 be 0f 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++){
80103e22:	8b 45 10             	mov    0x10(%ebp),%eax
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	85 c0                	test   %eax,%eax
80103e2a:	0f 8e c0 00 00 00    	jle    80103ef0 <pipewrite+0xe0>
80103e30:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e33:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e39:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e42:	03 45 10             	add    0x10(%ebp),%eax
80103e45:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e48:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e4e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e54:	89 ca                	mov    %ecx,%edx
80103e56:	05 00 02 00 00       	add    $0x200,%eax
80103e5b:	39 c1                	cmp    %eax,%ecx
80103e5d:	74 3f                	je     80103e9e <pipewrite+0x8e>
80103e5f:	eb 67                	jmp    80103ec8 <pipewrite+0xb8>
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103e68:	e8 43 03 00 00       	call   801041b0 <myproc>
80103e6d:	8b 48 24             	mov    0x24(%eax),%ecx
80103e70:	85 c9                	test   %ecx,%ecx
80103e72:	75 34                	jne    80103ea8 <pipewrite+0x98>
      wakeup(&p->nread);
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	57                   	push   %edi
80103e78:	e8 c3 0a 00 00       	call   80104940 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e7d:	58                   	pop    %eax
80103e7e:	5a                   	pop    %edx
80103e7f:	53                   	push   %ebx
80103e80:	56                   	push   %esi
80103e81:	e8 fa 09 00 00       	call   80104880 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e86:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e8c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e92:	83 c4 10             	add    $0x10,%esp
80103e95:	05 00 02 00 00       	add    $0x200,%eax
80103e9a:	39 c2                	cmp    %eax,%edx
80103e9c:	75 2a                	jne    80103ec8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103e9e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ea4:	85 c0                	test   %eax,%eax
80103ea6:	75 c0                	jne    80103e68 <pipewrite+0x58>
        release(&p->lock);
80103ea8:	83 ec 0c             	sub    $0xc,%esp
80103eab:	53                   	push   %ebx
80103eac:	e8 cf 0e 00 00       	call   80104d80 <release>
        return -1;
80103eb1:	83 c4 10             	add    $0x10,%esp
80103eb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ebc:	5b                   	pop    %ebx
80103ebd:	5e                   	pop    %esi
80103ebe:	5f                   	pop    %edi
80103ebf:	5d                   	pop    %ebp
80103ec0:	c3                   	ret    
80103ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ec8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ecb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103ece:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103ed4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103eda:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103edd:	83 c6 01             	add    $0x1,%esi
80103ee0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ee3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ee7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103eea:	0f 85 58 ff ff ff    	jne    80103e48 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ef9:	50                   	push   %eax
80103efa:	e8 41 0a 00 00       	call   80104940 <wakeup>
  release(&p->lock);
80103eff:	89 1c 24             	mov    %ebx,(%esp)
80103f02:	e8 79 0e 00 00       	call   80104d80 <release>
  return n;
80103f07:	8b 45 10             	mov    0x10(%ebp),%eax
80103f0a:	83 c4 10             	add    $0x10,%esp
80103f0d:	eb aa                	jmp    80103eb9 <pipewrite+0xa9>
80103f0f:	90                   	nop

80103f10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 18             	sub    $0x18,%esp
80103f19:	8b 75 08             	mov    0x8(%ebp),%esi
80103f1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103f1f:	56                   	push   %esi
80103f20:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f26:	e8 b5 0e 00 00       	call   80104de0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f2b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f31:	83 c4 10             	add    $0x10,%esp
80103f34:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103f3a:	74 2f                	je     80103f6b <piperead+0x5b>
80103f3c:	eb 37                	jmp    80103f75 <piperead+0x65>
80103f3e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103f40:	e8 6b 02 00 00       	call   801041b0 <myproc>
80103f45:	8b 48 24             	mov    0x24(%eax),%ecx
80103f48:	85 c9                	test   %ecx,%ecx
80103f4a:	0f 85 80 00 00 00    	jne    80103fd0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f50:	83 ec 08             	sub    $0x8,%esp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
80103f55:	e8 26 09 00 00       	call   80104880 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f5a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103f60:	83 c4 10             	add    $0x10,%esp
80103f63:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103f69:	75 0a                	jne    80103f75 <piperead+0x65>
80103f6b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103f71:	85 c0                	test   %eax,%eax
80103f73:	75 cb                	jne    80103f40 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f75:	8b 55 10             	mov    0x10(%ebp),%edx
80103f78:	31 db                	xor    %ebx,%ebx
80103f7a:	85 d2                	test   %edx,%edx
80103f7c:	7f 20                	jg     80103f9e <piperead+0x8e>
80103f7e:	eb 2c                	jmp    80103fac <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f80:	8d 48 01             	lea    0x1(%eax),%ecx
80103f83:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f88:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103f8e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103f93:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f96:	83 c3 01             	add    $0x1,%ebx
80103f99:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f9c:	74 0e                	je     80103fac <piperead+0x9c>
    if(p->nread == p->nwrite)
80103f9e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103fa4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103faa:	75 d4                	jne    80103f80 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103fb5:	50                   	push   %eax
80103fb6:	e8 85 09 00 00       	call   80104940 <wakeup>
  release(&p->lock);
80103fbb:	89 34 24             	mov    %esi,(%esp)
80103fbe:	e8 bd 0d 00 00       	call   80104d80 <release>
  return i;
80103fc3:	83 c4 10             	add    $0x10,%esp
}
80103fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc9:	89 d8                	mov    %ebx,%eax
80103fcb:	5b                   	pop    %ebx
80103fcc:	5e                   	pop    %esi
80103fcd:	5f                   	pop    %edi
80103fce:	5d                   	pop    %ebp
80103fcf:	c3                   	ret    
      release(&p->lock);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103fd8:	56                   	push   %esi
80103fd9:	e8 a2 0d 00 00       	call   80104d80 <release>
      return -1;
80103fde:	83 c4 10             	add    $0x10,%esp
}
80103fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe4:	89 d8                	mov    %ebx,%eax
80103fe6:	5b                   	pop    %ebx
80103fe7:	5e                   	pop    %esi
80103fe8:	5f                   	pop    %edi
80103fe9:	5d                   	pop    %ebp
80103fea:	c3                   	ret    
80103feb:	66 90                	xchg   %ax,%ax
80103fed:	66 90                	xchg   %ax,%ax
80103fef:	90                   	nop

80103ff0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff4:	bb d4 37 11 80       	mov    $0x801137d4,%ebx
{
80103ff9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103ffc:	68 a0 37 11 80       	push   $0x801137a0
80104001:	e8 da 0d 00 00       	call   80104de0 <acquire>
80104006:	83 c4 10             	add    $0x10,%esp
80104009:	eb 10                	jmp    8010401b <allocproc+0x2b>
8010400b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104010:	83 c3 7c             	add    $0x7c,%ebx
80104013:	81 fb d4 56 11 80    	cmp    $0x801156d4,%ebx
80104019:	74 75                	je     80104090 <allocproc+0xa0>
    if(p->state == UNUSED)
8010401b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010401e:	85 c0                	test   %eax,%eax
80104020:	75 ee                	jne    80104010 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104022:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104027:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010402a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104031:	89 43 10             	mov    %eax,0x10(%ebx)
80104034:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104037:	68 a0 37 11 80       	push   $0x801137a0
  p->pid = nextpid++;
8010403c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104042:	e8 39 0d 00 00       	call   80104d80 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104047:	e8 74 ee ff ff       	call   80102ec0 <kalloc>
8010404c:	83 c4 10             	add    $0x10,%esp
8010404f:	89 43 08             	mov    %eax,0x8(%ebx)
80104052:	85 c0                	test   %eax,%eax
80104054:	74 53                	je     801040a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104056:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010405c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010405f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104064:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104067:	c7 40 14 92 60 10 80 	movl   $0x80106092,0x14(%eax)
  p->context = (struct context*)sp;
8010406e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104071:	6a 14                	push   $0x14
80104073:	6a 00                	push   $0x0
80104075:	50                   	push   %eax
80104076:	e8 25 0e 00 00       	call   80104ea0 <memset>
  p->context->eip = (uint)forkret;
8010407b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010407e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104081:	c7 40 10 c0 40 10 80 	movl   $0x801040c0,0x10(%eax)
}
80104088:	89 d8                	mov    %ebx,%eax
8010408a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010408d:	c9                   	leave  
8010408e:	c3                   	ret    
8010408f:	90                   	nop
  release(&ptable.lock);
80104090:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104093:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104095:	68 a0 37 11 80       	push   $0x801137a0
8010409a:	e8 e1 0c 00 00       	call   80104d80 <release>
}
8010409f:	89 d8                	mov    %ebx,%eax
  return 0;
801040a1:	83 c4 10             	add    $0x10,%esp
}
801040a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a7:	c9                   	leave  
801040a8:	c3                   	ret    
    p->state = UNUSED;
801040a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801040b0:	31 db                	xor    %ebx,%ebx
}
801040b2:	89 d8                	mov    %ebx,%eax
801040b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b7:	c9                   	leave  
801040b8:	c3                   	ret    
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801040c6:	68 a0 37 11 80       	push   $0x801137a0
801040cb:	e8 b0 0c 00 00       	call   80104d80 <release>

  if (first) {
801040d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	85 c0                	test   %eax,%eax
801040da:	75 04                	jne    801040e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801040dc:	c9                   	leave  
801040dd:	c3                   	ret    
801040de:	66 90                	xchg   %ax,%ax
    first = 0;
801040e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801040e7:	00 00 00 
    iinit(ROOTDEV);
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	6a 01                	push   $0x1
801040ef:	e8 ac dc ff ff       	call   80101da0 <iinit>
    initlog(ROOTDEV);
801040f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801040fb:	e8 00 f4 ff ff       	call   80103500 <initlog>
}
80104100:	83 c4 10             	add    $0x10,%esp
80104103:	c9                   	leave  
80104104:	c3                   	ret    
80104105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104110 <pinit>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104116:	68 20 7f 10 80       	push   $0x80107f20
8010411b:	68 a0 37 11 80       	push   $0x801137a0
80104120:	e8 eb 0a 00 00       	call   80104c10 <initlock>
}
80104125:	83 c4 10             	add    $0x10,%esp
80104128:	c9                   	leave  
80104129:	c3                   	ret    
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <mycpu>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104135:	9c                   	pushf  
80104136:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104137:	f6 c4 02             	test   $0x2,%ah
8010413a:	75 46                	jne    80104182 <mycpu+0x52>
  apicid = lapicid();
8010413c:	e8 ef ef ff ff       	call   80103130 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104141:	8b 35 04 32 11 80    	mov    0x80113204,%esi
80104147:	85 f6                	test   %esi,%esi
80104149:	7e 2a                	jle    80104175 <mycpu+0x45>
8010414b:	31 d2                	xor    %edx,%edx
8010414d:	eb 08                	jmp    80104157 <mycpu+0x27>
8010414f:	90                   	nop
80104150:	83 c2 01             	add    $0x1,%edx
80104153:	39 f2                	cmp    %esi,%edx
80104155:	74 1e                	je     80104175 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104157:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010415d:	0f b6 99 20 32 11 80 	movzbl -0x7feecde0(%ecx),%ebx
80104164:	39 c3                	cmp    %eax,%ebx
80104166:	75 e8                	jne    80104150 <mycpu+0x20>
}
80104168:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010416b:	8d 81 20 32 11 80    	lea    -0x7feecde0(%ecx),%eax
}
80104171:	5b                   	pop    %ebx
80104172:	5e                   	pop    %esi
80104173:	5d                   	pop    %ebp
80104174:	c3                   	ret    
  panic("unknown apicid\n");
80104175:	83 ec 0c             	sub    $0xc,%esp
80104178:	68 27 7f 10 80       	push   $0x80107f27
8010417d:	e8 fe c1 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104182:	83 ec 0c             	sub    $0xc,%esp
80104185:	68 04 80 10 80       	push   $0x80108004
8010418a:	e8 f1 c1 ff ff       	call   80100380 <panic>
8010418f:	90                   	nop

80104190 <cpuid>:
cpuid() {
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104196:	e8 95 ff ff ff       	call   80104130 <mycpu>
}
8010419b:	c9                   	leave  
  return mycpu()-cpus;
8010419c:	2d 20 32 11 80       	sub    $0x80113220,%eax
801041a1:	c1 f8 04             	sar    $0x4,%eax
801041a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801041aa:	c3                   	ret    
801041ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041af:	90                   	nop

801041b0 <myproc>:
myproc(void) {
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041b7:	e8 d4 0a 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801041bc:	e8 6f ff ff ff       	call   80104130 <mycpu>
  p = c->proc;
801041c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c7:	e8 14 0b 00 00       	call   80104ce0 <popcli>
}
801041cc:	89 d8                	mov    %ebx,%eax
801041ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d1:	c9                   	leave  
801041d2:	c3                   	ret    
801041d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <userinit>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801041e7:	e8 04 fe ff ff       	call   80103ff0 <allocproc>
801041ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801041ee:	a3 d4 56 11 80       	mov    %eax,0x801156d4
  if((p->pgdir = setupkvm()) == 0)
801041f3:	e8 88 34 00 00       	call   80107680 <setupkvm>
801041f8:	89 43 04             	mov    %eax,0x4(%ebx)
801041fb:	85 c0                	test   %eax,%eax
801041fd:	0f 84 bd 00 00 00    	je     801042c0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104203:	83 ec 04             	sub    $0x4,%esp
80104206:	68 2c 00 00 00       	push   $0x2c
8010420b:	68 60 b4 10 80       	push   $0x8010b460
80104210:	50                   	push   %eax
80104211:	e8 1a 31 00 00       	call   80107330 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104216:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104219:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010421f:	6a 4c                	push   $0x4c
80104221:	6a 00                	push   $0x0
80104223:	ff 73 18             	push   0x18(%ebx)
80104226:	e8 75 0c 00 00       	call   80104ea0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010422b:	8b 43 18             	mov    0x18(%ebx),%eax
8010422e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104233:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104236:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010423b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010423f:	8b 43 18             	mov    0x18(%ebx),%eax
80104242:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104246:	8b 43 18             	mov    0x18(%ebx),%eax
80104249:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010424d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104251:	8b 43 18             	mov    0x18(%ebx),%eax
80104254:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104258:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010425c:	8b 43 18             	mov    0x18(%ebx),%eax
8010425f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104266:	8b 43 18             	mov    0x18(%ebx),%eax
80104269:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104270:	8b 43 18             	mov    0x18(%ebx),%eax
80104273:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010427a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010427d:	6a 10                	push   $0x10
8010427f:	68 50 7f 10 80       	push   $0x80107f50
80104284:	50                   	push   %eax
80104285:	e8 d6 0d 00 00       	call   80105060 <safestrcpy>
  p->cwd = namei("/");
8010428a:	c7 04 24 59 7f 10 80 	movl   $0x80107f59,(%esp)
80104291:	e8 4a e6 ff ff       	call   801028e0 <namei>
80104296:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104299:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
801042a0:	e8 3b 0b 00 00       	call   80104de0 <acquire>
  p->state = RUNNABLE;
801042a5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801042ac:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
801042b3:	e8 c8 0a 00 00       	call   80104d80 <release>
}
801042b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042bb:	83 c4 10             	add    $0x10,%esp
801042be:	c9                   	leave  
801042bf:	c3                   	ret    
    panic("userinit: out of memory?");
801042c0:	83 ec 0c             	sub    $0xc,%esp
801042c3:	68 37 7f 10 80       	push   $0x80107f37
801042c8:	e8 b3 c0 ff ff       	call   80100380 <panic>
801042cd:	8d 76 00             	lea    0x0(%esi),%esi

801042d0 <growproc>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	56                   	push   %esi
801042d4:	53                   	push   %ebx
801042d5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801042d8:	e8 b3 09 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801042dd:	e8 4e fe ff ff       	call   80104130 <mycpu>
  p = c->proc;
801042e2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e8:	e8 f3 09 00 00       	call   80104ce0 <popcli>
  sz = curproc->sz;
801042ed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801042ef:	85 f6                	test   %esi,%esi
801042f1:	7f 1d                	jg     80104310 <growproc+0x40>
  } else if(n < 0){
801042f3:	75 3b                	jne    80104330 <growproc+0x60>
  switchuvm(curproc);
801042f5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801042f8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801042fa:	53                   	push   %ebx
801042fb:	e8 20 2f 00 00       	call   80107220 <switchuvm>
  return 0;
80104300:	83 c4 10             	add    $0x10,%esp
80104303:	31 c0                	xor    %eax,%eax
}
80104305:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5d                   	pop    %ebp
8010430b:	c3                   	ret    
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104310:	83 ec 04             	sub    $0x4,%esp
80104313:	01 c6                	add    %eax,%esi
80104315:	56                   	push   %esi
80104316:	50                   	push   %eax
80104317:	ff 73 04             	push   0x4(%ebx)
8010431a:	e8 81 31 00 00       	call   801074a0 <allocuvm>
8010431f:	83 c4 10             	add    $0x10,%esp
80104322:	85 c0                	test   %eax,%eax
80104324:	75 cf                	jne    801042f5 <growproc+0x25>
      return -1;
80104326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010432b:	eb d8                	jmp    80104305 <growproc+0x35>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104330:	83 ec 04             	sub    $0x4,%esp
80104333:	01 c6                	add    %eax,%esi
80104335:	56                   	push   %esi
80104336:	50                   	push   %eax
80104337:	ff 73 04             	push   0x4(%ebx)
8010433a:	e8 91 32 00 00       	call   801075d0 <deallocuvm>
8010433f:	83 c4 10             	add    $0x10,%esp
80104342:	85 c0                	test   %eax,%eax
80104344:	75 af                	jne    801042f5 <growproc+0x25>
80104346:	eb de                	jmp    80104326 <growproc+0x56>
80104348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop

80104350 <fork>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104359:	e8 32 09 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010435e:	e8 cd fd ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104363:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104369:	e8 72 09 00 00       	call   80104ce0 <popcli>
  if((np = allocproc()) == 0){
8010436e:	e8 7d fc ff ff       	call   80103ff0 <allocproc>
80104373:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104376:	85 c0                	test   %eax,%eax
80104378:	0f 84 b7 00 00 00    	je     80104435 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010437e:	83 ec 08             	sub    $0x8,%esp
80104381:	ff 33                	push   (%ebx)
80104383:	89 c7                	mov    %eax,%edi
80104385:	ff 73 04             	push   0x4(%ebx)
80104388:	e8 e3 33 00 00       	call   80107770 <copyuvm>
8010438d:	83 c4 10             	add    $0x10,%esp
80104390:	89 47 04             	mov    %eax,0x4(%edi)
80104393:	85 c0                	test   %eax,%eax
80104395:	0f 84 a1 00 00 00    	je     8010443c <fork+0xec>
  np->sz = curproc->sz;
8010439b:	8b 03                	mov    (%ebx),%eax
8010439d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043a0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801043a2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801043a5:	89 c8                	mov    %ecx,%eax
801043a7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801043aa:	b9 13 00 00 00       	mov    $0x13,%ecx
801043af:	8b 73 18             	mov    0x18(%ebx),%esi
801043b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801043b4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801043b6:	8b 40 18             	mov    0x18(%eax),%eax
801043b9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801043c0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801043c4:	85 c0                	test   %eax,%eax
801043c6:	74 13                	je     801043db <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	50                   	push   %eax
801043cc:	e8 0f d3 ff ff       	call   801016e0 <filedup>
801043d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043d4:	83 c4 10             	add    $0x10,%esp
801043d7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801043db:	83 c6 01             	add    $0x1,%esi
801043de:	83 fe 10             	cmp    $0x10,%esi
801043e1:	75 dd                	jne    801043c0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043e9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801043ec:	e8 9f db ff ff       	call   80101f90 <idup>
801043f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043f4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801043f7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043fa:	8d 47 6c             	lea    0x6c(%edi),%eax
801043fd:	6a 10                	push   $0x10
801043ff:	53                   	push   %ebx
80104400:	50                   	push   %eax
80104401:	e8 5a 0c 00 00       	call   80105060 <safestrcpy>
  pid = np->pid;
80104406:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104409:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
80104410:	e8 cb 09 00 00       	call   80104de0 <acquire>
  np->state = RUNNABLE;
80104415:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010441c:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
80104423:	e8 58 09 00 00       	call   80104d80 <release>
  return pid;
80104428:	83 c4 10             	add    $0x10,%esp
}
8010442b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010442e:	89 d8                	mov    %ebx,%eax
80104430:	5b                   	pop    %ebx
80104431:	5e                   	pop    %esi
80104432:	5f                   	pop    %edi
80104433:	5d                   	pop    %ebp
80104434:	c3                   	ret    
    return -1;
80104435:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010443a:	eb ef                	jmp    8010442b <fork+0xdb>
    kfree(np->kstack);
8010443c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	ff 73 08             	push   0x8(%ebx)
80104445:	e8 b6 e8 ff ff       	call   80102d00 <kfree>
    np->kstack = 0;
8010444a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104451:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104454:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010445b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104460:	eb c9                	jmp    8010442b <fork+0xdb>
80104462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <scheduler>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104479:	e8 b2 fc ff ff       	call   80104130 <mycpu>
  c->proc = 0;
8010447e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104485:	00 00 00 
  struct cpu *c = mycpu();
80104488:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010448a:	8d 78 04             	lea    0x4(%eax),%edi
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104490:	fb                   	sti    
    acquire(&ptable.lock);
80104491:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104494:	bb d4 37 11 80       	mov    $0x801137d4,%ebx
    acquire(&ptable.lock);
80104499:	68 a0 37 11 80       	push   $0x801137a0
8010449e:	e8 3d 09 00 00       	call   80104de0 <acquire>
801044a3:	83 c4 10             	add    $0x10,%esp
801044a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
801044b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801044b4:	75 33                	jne    801044e9 <scheduler+0x79>
      switchuvm(p);
801044b6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801044bf:	53                   	push   %ebx
801044c0:	e8 5b 2d 00 00       	call   80107220 <switchuvm>
      swtch(&(c->scheduler), p->context);
801044c5:	58                   	pop    %eax
801044c6:	5a                   	pop    %edx
801044c7:	ff 73 1c             	push   0x1c(%ebx)
801044ca:	57                   	push   %edi
      p->state = RUNNING;
801044cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044d2:	e8 e4 0b 00 00       	call   801050bb <swtch>
      switchkvm();
801044d7:	e8 34 2d 00 00       	call   80107210 <switchkvm>
      c->proc = 0;
801044dc:	83 c4 10             	add    $0x10,%esp
801044df:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801044e6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e9:	83 c3 7c             	add    $0x7c,%ebx
801044ec:	81 fb d4 56 11 80    	cmp    $0x801156d4,%ebx
801044f2:	75 bc                	jne    801044b0 <scheduler+0x40>
    release(&ptable.lock);
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	68 a0 37 11 80       	push   $0x801137a0
801044fc:	e8 7f 08 00 00       	call   80104d80 <release>
    sti();
80104501:	83 c4 10             	add    $0x10,%esp
80104504:	eb 8a                	jmp    80104490 <scheduler+0x20>
80104506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <sched>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
  pushcli();
80104515:	e8 76 07 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010451a:	e8 11 fc ff ff       	call   80104130 <mycpu>
  p = c->proc;
8010451f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104525:	e8 b6 07 00 00       	call   80104ce0 <popcli>
  if(!holding(&ptable.lock))
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	68 a0 37 11 80       	push   $0x801137a0
80104532:	e8 09 08 00 00       	call   80104d40 <holding>
80104537:	83 c4 10             	add    $0x10,%esp
8010453a:	85 c0                	test   %eax,%eax
8010453c:	74 4f                	je     8010458d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010453e:	e8 ed fb ff ff       	call   80104130 <mycpu>
80104543:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010454a:	75 68                	jne    801045b4 <sched+0xa4>
  if(p->state == RUNNING)
8010454c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104550:	74 55                	je     801045a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104552:	9c                   	pushf  
80104553:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104554:	f6 c4 02             	test   $0x2,%ah
80104557:	75 41                	jne    8010459a <sched+0x8a>
  intena = mycpu()->intena;
80104559:	e8 d2 fb ff ff       	call   80104130 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010455e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104561:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104567:	e8 c4 fb ff ff       	call   80104130 <mycpu>
8010456c:	83 ec 08             	sub    $0x8,%esp
8010456f:	ff 70 04             	push   0x4(%eax)
80104572:	53                   	push   %ebx
80104573:	e8 43 0b 00 00       	call   801050bb <swtch>
  mycpu()->intena = intena;
80104578:	e8 b3 fb ff ff       	call   80104130 <mycpu>
}
8010457d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104580:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104586:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
    panic("sched ptable.lock");
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 5b 7f 10 80       	push   $0x80107f5b
80104595:	e8 e6 bd ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	68 87 7f 10 80       	push   $0x80107f87
801045a2:	e8 d9 bd ff ff       	call   80100380 <panic>
    panic("sched running");
801045a7:	83 ec 0c             	sub    $0xc,%esp
801045aa:	68 79 7f 10 80       	push   $0x80107f79
801045af:	e8 cc bd ff ff       	call   80100380 <panic>
    panic("sched locks");
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	68 6d 7f 10 80       	push   $0x80107f6d
801045bc:	e8 bf bd ff ff       	call   80100380 <panic>
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop

801045d0 <exit>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801045d9:	e8 d2 fb ff ff       	call   801041b0 <myproc>
  if(curproc == initproc)
801045de:	39 05 d4 56 11 80    	cmp    %eax,0x801156d4
801045e4:	0f 84 fd 00 00 00    	je     801046e7 <exit+0x117>
801045ea:	89 c3                	mov    %eax,%ebx
801045ec:	8d 70 28             	lea    0x28(%eax),%esi
801045ef:	8d 78 68             	lea    0x68(%eax),%edi
801045f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801045f8:	8b 06                	mov    (%esi),%eax
801045fa:	85 c0                	test   %eax,%eax
801045fc:	74 12                	je     80104610 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801045fe:	83 ec 0c             	sub    $0xc,%esp
80104601:	50                   	push   %eax
80104602:	e8 29 d1 ff ff       	call   80101730 <fileclose>
      curproc->ofile[fd] = 0;
80104607:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010460d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104610:	83 c6 04             	add    $0x4,%esi
80104613:	39 f7                	cmp    %esi,%edi
80104615:	75 e1                	jne    801045f8 <exit+0x28>
  begin_op();
80104617:	e8 84 ef ff ff       	call   801035a0 <begin_op>
  iput(curproc->cwd);
8010461c:	83 ec 0c             	sub    $0xc,%esp
8010461f:	ff 73 68             	push   0x68(%ebx)
80104622:	e8 c9 da ff ff       	call   801020f0 <iput>
  end_op();
80104627:	e8 e4 ef ff ff       	call   80103610 <end_op>
  curproc->cwd = 0;
8010462c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104633:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
8010463a:	e8 a1 07 00 00       	call   80104de0 <acquire>
  wakeup1(curproc->parent);
8010463f:	8b 53 14             	mov    0x14(%ebx),%edx
80104642:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104645:	b8 d4 37 11 80       	mov    $0x801137d4,%eax
8010464a:	eb 0e                	jmp    8010465a <exit+0x8a>
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104650:	83 c0 7c             	add    $0x7c,%eax
80104653:	3d d4 56 11 80       	cmp    $0x801156d4,%eax
80104658:	74 1c                	je     80104676 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010465a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010465e:	75 f0                	jne    80104650 <exit+0x80>
80104660:	3b 50 20             	cmp    0x20(%eax),%edx
80104663:	75 eb                	jne    80104650 <exit+0x80>
      p->state = RUNNABLE;
80104665:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010466c:	83 c0 7c             	add    $0x7c,%eax
8010466f:	3d d4 56 11 80       	cmp    $0x801156d4,%eax
80104674:	75 e4                	jne    8010465a <exit+0x8a>
      p->parent = initproc;
80104676:	8b 0d d4 56 11 80    	mov    0x801156d4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467c:	ba d4 37 11 80       	mov    $0x801137d4,%edx
80104681:	eb 10                	jmp    80104693 <exit+0xc3>
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	83 c2 7c             	add    $0x7c,%edx
8010468b:	81 fa d4 56 11 80    	cmp    $0x801156d4,%edx
80104691:	74 3b                	je     801046ce <exit+0xfe>
    if(p->parent == curproc){
80104693:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104696:	75 f0                	jne    80104688 <exit+0xb8>
      if(p->state == ZOMBIE)
80104698:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010469c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010469f:	75 e7                	jne    80104688 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046a1:	b8 d4 37 11 80       	mov    $0x801137d4,%eax
801046a6:	eb 12                	jmp    801046ba <exit+0xea>
801046a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop
801046b0:	83 c0 7c             	add    $0x7c,%eax
801046b3:	3d d4 56 11 80       	cmp    $0x801156d4,%eax
801046b8:	74 ce                	je     80104688 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801046ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046be:	75 f0                	jne    801046b0 <exit+0xe0>
801046c0:	3b 48 20             	cmp    0x20(%eax),%ecx
801046c3:	75 eb                	jne    801046b0 <exit+0xe0>
      p->state = RUNNABLE;
801046c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046cc:	eb e2                	jmp    801046b0 <exit+0xe0>
  curproc->state = ZOMBIE;
801046ce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801046d5:	e8 36 fe ff ff       	call   80104510 <sched>
  panic("zombie exit");
801046da:	83 ec 0c             	sub    $0xc,%esp
801046dd:	68 a8 7f 10 80       	push   $0x80107fa8
801046e2:	e8 99 bc ff ff       	call   80100380 <panic>
    panic("init exiting");
801046e7:	83 ec 0c             	sub    $0xc,%esp
801046ea:	68 9b 7f 10 80       	push   $0x80107f9b
801046ef:	e8 8c bc ff ff       	call   80100380 <panic>
801046f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ff:	90                   	nop

80104700 <wait>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
  pushcli();
80104705:	e8 86 05 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010470a:	e8 21 fa ff ff       	call   80104130 <mycpu>
  p = c->proc;
8010470f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104715:	e8 c6 05 00 00       	call   80104ce0 <popcli>
  acquire(&ptable.lock);
8010471a:	83 ec 0c             	sub    $0xc,%esp
8010471d:	68 a0 37 11 80       	push   $0x801137a0
80104722:	e8 b9 06 00 00       	call   80104de0 <acquire>
80104727:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010472a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472c:	bb d4 37 11 80       	mov    $0x801137d4,%ebx
80104731:	eb 10                	jmp    80104743 <wait+0x43>
80104733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104737:	90                   	nop
80104738:	83 c3 7c             	add    $0x7c,%ebx
8010473b:	81 fb d4 56 11 80    	cmp    $0x801156d4,%ebx
80104741:	74 1b                	je     8010475e <wait+0x5e>
      if(p->parent != curproc)
80104743:	39 73 14             	cmp    %esi,0x14(%ebx)
80104746:	75 f0                	jne    80104738 <wait+0x38>
      if(p->state == ZOMBIE){
80104748:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010474c:	74 62                	je     801047b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010474e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104751:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104756:	81 fb d4 56 11 80    	cmp    $0x801156d4,%ebx
8010475c:	75 e5                	jne    80104743 <wait+0x43>
    if(!havekids || curproc->killed){
8010475e:	85 c0                	test   %eax,%eax
80104760:	0f 84 a0 00 00 00    	je     80104806 <wait+0x106>
80104766:	8b 46 24             	mov    0x24(%esi),%eax
80104769:	85 c0                	test   %eax,%eax
8010476b:	0f 85 95 00 00 00    	jne    80104806 <wait+0x106>
  pushcli();
80104771:	e8 1a 05 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104776:	e8 b5 f9 ff ff       	call   80104130 <mycpu>
  p = c->proc;
8010477b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104781:	e8 5a 05 00 00       	call   80104ce0 <popcli>
  if(p == 0)
80104786:	85 db                	test   %ebx,%ebx
80104788:	0f 84 8f 00 00 00    	je     8010481d <wait+0x11d>
  p->chan = chan;
8010478e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104791:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104798:	e8 73 fd ff ff       	call   80104510 <sched>
  p->chan = 0;
8010479d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047a4:	eb 84                	jmp    8010472a <wait+0x2a>
801047a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801047b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801047b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801047b6:	ff 73 08             	push   0x8(%ebx)
801047b9:	e8 42 e5 ff ff       	call   80102d00 <kfree>
        p->kstack = 0;
801047be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801047c5:	5a                   	pop    %edx
801047c6:	ff 73 04             	push   0x4(%ebx)
801047c9:	e8 32 2e 00 00       	call   80107600 <freevm>
        p->pid = 0;
801047ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801047d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801047e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801047ee:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
801047f5:	e8 86 05 00 00       	call   80104d80 <release>
        return pid;
801047fa:	83 c4 10             	add    $0x10,%esp
}
801047fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104800:	89 f0                	mov    %esi,%eax
80104802:	5b                   	pop    %ebx
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
      release(&ptable.lock);
80104806:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104809:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010480e:	68 a0 37 11 80       	push   $0x801137a0
80104813:	e8 68 05 00 00       	call   80104d80 <release>
      return -1;
80104818:	83 c4 10             	add    $0x10,%esp
8010481b:	eb e0                	jmp    801047fd <wait+0xfd>
    panic("sleep");
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	68 b4 7f 10 80       	push   $0x80107fb4
80104825:	e8 56 bb ff ff       	call   80100380 <panic>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <yield>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104837:	68 a0 37 11 80       	push   $0x801137a0
8010483c:	e8 9f 05 00 00       	call   80104de0 <acquire>
  pushcli();
80104841:	e8 4a 04 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104846:	e8 e5 f8 ff ff       	call   80104130 <mycpu>
  p = c->proc;
8010484b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104851:	e8 8a 04 00 00       	call   80104ce0 <popcli>
  myproc()->state = RUNNABLE;
80104856:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010485d:	e8 ae fc ff ff       	call   80104510 <sched>
  release(&ptable.lock);
80104862:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
80104869:	e8 12 05 00 00       	call   80104d80 <release>
}
8010486e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104871:	83 c4 10             	add    $0x10,%esp
80104874:	c9                   	leave  
80104875:	c3                   	ret    
80104876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487d:	8d 76 00             	lea    0x0(%esi),%esi

80104880 <sleep>:
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	53                   	push   %ebx
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	8b 7d 08             	mov    0x8(%ebp),%edi
8010488c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010488f:	e8 fc 03 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104894:	e8 97 f8 ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104899:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010489f:	e8 3c 04 00 00       	call   80104ce0 <popcli>
  if(p == 0)
801048a4:	85 db                	test   %ebx,%ebx
801048a6:	0f 84 87 00 00 00    	je     80104933 <sleep+0xb3>
  if(lk == 0)
801048ac:	85 f6                	test   %esi,%esi
801048ae:	74 76                	je     80104926 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048b0:	81 fe a0 37 11 80    	cmp    $0x801137a0,%esi
801048b6:	74 50                	je     80104908 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	68 a0 37 11 80       	push   $0x801137a0
801048c0:	e8 1b 05 00 00       	call   80104de0 <acquire>
    release(lk);
801048c5:	89 34 24             	mov    %esi,(%esp)
801048c8:	e8 b3 04 00 00       	call   80104d80 <release>
  p->chan = chan;
801048cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048d7:	e8 34 fc ff ff       	call   80104510 <sched>
  p->chan = 0;
801048dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801048e3:	c7 04 24 a0 37 11 80 	movl   $0x801137a0,(%esp)
801048ea:	e8 91 04 00 00       	call   80104d80 <release>
    acquire(lk);
801048ef:	89 75 08             	mov    %esi,0x8(%ebp)
801048f2:	83 c4 10             	add    $0x10,%esp
}
801048f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5f                   	pop    %edi
801048fb:	5d                   	pop    %ebp
    acquire(lk);
801048fc:	e9 df 04 00 00       	jmp    80104de0 <acquire>
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104908:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010490b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104912:	e8 f9 fb ff ff       	call   80104510 <sched>
  p->chan = 0;
80104917:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010491e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104921:	5b                   	pop    %ebx
80104922:	5e                   	pop    %esi
80104923:	5f                   	pop    %edi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
    panic("sleep without lk");
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	68 ba 7f 10 80       	push   $0x80107fba
8010492e:	e8 4d ba ff ff       	call   80100380 <panic>
    panic("sleep");
80104933:	83 ec 0c             	sub    $0xc,%esp
80104936:	68 b4 7f 10 80       	push   $0x80107fb4
8010493b:	e8 40 ba ff ff       	call   80100380 <panic>

80104940 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 10             	sub    $0x10,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010494a:	68 a0 37 11 80       	push   $0x801137a0
8010494f:	e8 8c 04 00 00       	call   80104de0 <acquire>
80104954:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104957:	b8 d4 37 11 80       	mov    $0x801137d4,%eax
8010495c:	eb 0c                	jmp    8010496a <wakeup+0x2a>
8010495e:	66 90                	xchg   %ax,%ax
80104960:	83 c0 7c             	add    $0x7c,%eax
80104963:	3d d4 56 11 80       	cmp    $0x801156d4,%eax
80104968:	74 1c                	je     80104986 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010496a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010496e:	75 f0                	jne    80104960 <wakeup+0x20>
80104970:	3b 58 20             	cmp    0x20(%eax),%ebx
80104973:	75 eb                	jne    80104960 <wakeup+0x20>
      p->state = RUNNABLE;
80104975:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010497c:	83 c0 7c             	add    $0x7c,%eax
8010497f:	3d d4 56 11 80       	cmp    $0x801156d4,%eax
80104984:	75 e4                	jne    8010496a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104986:	c7 45 08 a0 37 11 80 	movl   $0x801137a0,0x8(%ebp)
}
8010498d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104990:	c9                   	leave  
  release(&ptable.lock);
80104991:	e9 ea 03 00 00       	jmp    80104d80 <release>
80104996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499d:	8d 76 00             	lea    0x0(%esi),%esi

801049a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 10             	sub    $0x10,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801049aa:	68 a0 37 11 80       	push   $0x801137a0
801049af:	e8 2c 04 00 00       	call   80104de0 <acquire>
801049b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b7:	b8 d4 37 11 80       	mov    $0x801137d4,%eax
801049bc:	eb 0c                	jmp    801049ca <kill+0x2a>
801049be:	66 90                	xchg   %ax,%ax
801049c0:	83 c0 7c             	add    $0x7c,%eax
801049c3:	3d d4 56 11 80       	cmp    $0x801156d4,%eax
801049c8:	74 36                	je     80104a00 <kill+0x60>
    if(p->pid == pid){
801049ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801049cd:	75 f1                	jne    801049c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801049d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801049da:	75 07                	jne    801049e3 <kill+0x43>
        p->state = RUNNABLE;
801049dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049e3:	83 ec 0c             	sub    $0xc,%esp
801049e6:	68 a0 37 11 80       	push   $0x801137a0
801049eb:	e8 90 03 00 00       	call   80104d80 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801049f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801049f3:	83 c4 10             	add    $0x10,%esp
801049f6:	31 c0                	xor    %eax,%eax
}
801049f8:	c9                   	leave  
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	68 a0 37 11 80       	push   $0x801137a0
80104a08:	e8 73 03 00 00       	call   80104d80 <release>
}
80104a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a10:	83 c4 10             	add    $0x10,%esp
80104a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a18:	c9                   	leave  
80104a19:	c3                   	ret    
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104a28:	53                   	push   %ebx
80104a29:	bb 40 38 11 80       	mov    $0x80113840,%ebx
80104a2e:	83 ec 3c             	sub    $0x3c,%esp
80104a31:	eb 24                	jmp    80104a57 <procdump+0x37>
80104a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a37:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	68 37 83 10 80       	push   $0x80108337
80104a40:	e8 bb bc ff ff       	call   80100700 <cprintf>
80104a45:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a48:	83 c3 7c             	add    $0x7c,%ebx
80104a4b:	81 fb 40 57 11 80    	cmp    $0x80115740,%ebx
80104a51:	0f 84 81 00 00 00    	je     80104ad8 <procdump+0xb8>
    if(p->state == UNUSED)
80104a57:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a5a:	85 c0                	test   %eax,%eax
80104a5c:	74 ea                	je     80104a48 <procdump+0x28>
      state = "???";
80104a5e:	ba cb 7f 10 80       	mov    $0x80107fcb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a63:	83 f8 05             	cmp    $0x5,%eax
80104a66:	77 11                	ja     80104a79 <procdump+0x59>
80104a68:	8b 14 85 2c 80 10 80 	mov    -0x7fef7fd4(,%eax,4),%edx
      state = "???";
80104a6f:	b8 cb 7f 10 80       	mov    $0x80107fcb,%eax
80104a74:	85 d2                	test   %edx,%edx
80104a76:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a79:	53                   	push   %ebx
80104a7a:	52                   	push   %edx
80104a7b:	ff 73 a4             	push   -0x5c(%ebx)
80104a7e:	68 cf 7f 10 80       	push   $0x80107fcf
80104a83:	e8 78 bc ff ff       	call   80100700 <cprintf>
    if(p->state == SLEEPING){
80104a88:	83 c4 10             	add    $0x10,%esp
80104a8b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a8f:	75 a7                	jne    80104a38 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a91:	83 ec 08             	sub    $0x8,%esp
80104a94:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a97:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a9a:	50                   	push   %eax
80104a9b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a9e:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa1:	83 c0 08             	add    $0x8,%eax
80104aa4:	50                   	push   %eax
80104aa5:	e8 86 01 00 00       	call   80104c30 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104aaa:	83 c4 10             	add    $0x10,%esp
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	8b 17                	mov    (%edi),%edx
80104ab2:	85 d2                	test   %edx,%edx
80104ab4:	74 82                	je     80104a38 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104ab6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ab9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104abc:	52                   	push   %edx
80104abd:	68 21 7a 10 80       	push   $0x80107a21
80104ac2:	e8 39 bc ff ff       	call   80100700 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	39 fe                	cmp    %edi,%esi
80104acc:	75 e2                	jne    80104ab0 <procdump+0x90>
80104ace:	e9 65 ff ff ff       	jmp    80104a38 <procdump+0x18>
80104ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ad7:	90                   	nop
  }
}
80104ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104adb:	5b                   	pop    %ebx
80104adc:	5e                   	pop    %esi
80104add:	5f                   	pop    %edi
80104ade:	5d                   	pop    %ebp
80104adf:	c3                   	ret    

80104ae0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104aea:	68 44 80 10 80       	push   $0x80108044
80104aef:	8d 43 04             	lea    0x4(%ebx),%eax
80104af2:	50                   	push   %eax
80104af3:	e8 18 01 00 00       	call   80104c10 <initlock>
  lk->name = name;
80104af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104afb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b01:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b0b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b11:	c9                   	leave  
80104b12:	c3                   	ret    
80104b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b28:	8d 73 04             	lea    0x4(%ebx),%esi
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	56                   	push   %esi
80104b2f:	e8 ac 02 00 00       	call   80104de0 <acquire>
  while (lk->locked) {
80104b34:	8b 13                	mov    (%ebx),%edx
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 d2                	test   %edx,%edx
80104b3b:	74 16                	je     80104b53 <acquiresleep+0x33>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104b40:	83 ec 08             	sub    $0x8,%esp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
80104b45:	e8 36 fd ff ff       	call   80104880 <sleep>
  while (lk->locked) {
80104b4a:	8b 03                	mov    (%ebx),%eax
80104b4c:	83 c4 10             	add    $0x10,%esp
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	75 ed                	jne    80104b40 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b59:	e8 52 f6 ff ff       	call   801041b0 <myproc>
80104b5e:	8b 40 10             	mov    0x10(%eax),%eax
80104b61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b6a:	5b                   	pop    %ebx
80104b6b:	5e                   	pop    %esi
80104b6c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b6d:	e9 0e 02 00 00       	jmp    80104d80 <release>
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b88:	8d 73 04             	lea    0x4(%ebx),%esi
80104b8b:	83 ec 0c             	sub    $0xc,%esp
80104b8e:	56                   	push   %esi
80104b8f:	e8 4c 02 00 00       	call   80104de0 <acquire>
  lk->locked = 0;
80104b94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ba1:	89 1c 24             	mov    %ebx,(%esp)
80104ba4:	e8 97 fd ff ff       	call   80104940 <wakeup>
  release(&lk->lk);
80104ba9:	89 75 08             	mov    %esi,0x8(%ebp)
80104bac:	83 c4 10             	add    $0x10,%esp
}
80104baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bb5:	e9 c6 01 00 00       	jmp    80104d80 <release>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	31 ff                	xor    %edi,%edi
80104bc6:	56                   	push   %esi
80104bc7:	53                   	push   %ebx
80104bc8:	83 ec 18             	sub    $0x18,%esp
80104bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bce:	8d 73 04             	lea    0x4(%ebx),%esi
80104bd1:	56                   	push   %esi
80104bd2:	e8 09 02 00 00       	call   80104de0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bd7:	8b 03                	mov    (%ebx),%eax
80104bd9:	83 c4 10             	add    $0x10,%esp
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	75 18                	jne    80104bf8 <holdingsleep+0x38>
  release(&lk->lk);
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	56                   	push   %esi
80104be4:	e8 97 01 00 00       	call   80104d80 <release>
  return r;
}
80104be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bec:	89 f8                	mov    %edi,%eax
80104bee:	5b                   	pop    %ebx
80104bef:	5e                   	pop    %esi
80104bf0:	5f                   	pop    %edi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret    
80104bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104bf8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bfb:	e8 b0 f5 ff ff       	call   801041b0 <myproc>
80104c00:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c03:	0f 94 c0             	sete   %al
80104c06:	0f b6 c0             	movzbl %al,%eax
80104c09:	89 c7                	mov    %eax,%edi
80104c0b:	eb d3                	jmp    80104be0 <holdingsleep+0x20>
80104c0d:	66 90                	xchg   %ax,%ax
80104c0f:	90                   	nop

80104c10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c30:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c31:	31 d2                	xor    %edx,%edx
{
80104c33:	89 e5                	mov    %esp,%ebp
80104c35:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c36:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c3c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c4c:	77 1a                	ja     80104c68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104c51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c54:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c57:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c59:	83 fa 0a             	cmp    $0xa,%edx
80104c5c:	75 e2                	jne    80104c40 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c61:	c9                   	leave  
80104c62:	c3                   	ret    
80104c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c67:	90                   	nop
  for(; i < 10; i++)
80104c68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c6b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c76:	83 c0 04             	add    $0x4,%eax
80104c79:	39 d0                	cmp    %edx,%eax
80104c7b:	75 f3                	jne    80104c70 <getcallerpcs+0x40>
}
80104c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c80:	c9                   	leave  
80104c81:	c3                   	ret    
80104c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	9c                   	pushf  
80104c98:	5b                   	pop    %ebx
  asm volatile("cli");
80104c99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c9a:	e8 91 f4 ff ff       	call   80104130 <mycpu>
80104c9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	74 17                	je     80104cc0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104ca9:	e8 82 f4 ff ff       	call   80104130 <mycpu>
80104cae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb8:	c9                   	leave  
80104cb9:	c3                   	ret    
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104cc0:	e8 6b f4 ff ff       	call   80104130 <mycpu>
80104cc5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ccb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104cd1:	eb d6                	jmp    80104ca9 <pushcli+0x19>
80104cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <popcli>:

void
popcli(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ce6:	9c                   	pushf  
80104ce7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ce8:	f6 c4 02             	test   $0x2,%ah
80104ceb:	75 35                	jne    80104d22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ced:	e8 3e f4 ff ff       	call   80104130 <mycpu>
80104cf2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cf9:	78 34                	js     80104d2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cfb:	e8 30 f4 ff ff       	call   80104130 <mycpu>
80104d00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d06:	85 d2                	test   %edx,%edx
80104d08:	74 06                	je     80104d10 <popcli+0x30>
    sti();
}
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d10:	e8 1b f4 ff ff       	call   80104130 <mycpu>
80104d15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	74 eb                	je     80104d0a <popcli+0x2a>
  asm volatile("sti");
80104d1f:	fb                   	sti    
}
80104d20:	c9                   	leave  
80104d21:	c3                   	ret    
    panic("popcli - interruptible");
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	68 4f 80 10 80       	push   $0x8010804f
80104d2a:	e8 51 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	68 66 80 10 80       	push   $0x80108066
80104d37:	e8 44 b6 ff ff       	call   80100380 <panic>
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <holding>:
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 75 08             	mov    0x8(%ebp),%esi
80104d48:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d4a:	e8 41 ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d4f:	8b 06                	mov    (%esi),%eax
80104d51:	85 c0                	test   %eax,%eax
80104d53:	75 0b                	jne    80104d60 <holding+0x20>
  popcli();
80104d55:	e8 86 ff ff ff       	call   80104ce0 <popcli>
}
80104d5a:	89 d8                	mov    %ebx,%eax
80104d5c:	5b                   	pop    %ebx
80104d5d:	5e                   	pop    %esi
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d60:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d63:	e8 c8 f3 ff ff       	call   80104130 <mycpu>
80104d68:	39 c3                	cmp    %eax,%ebx
80104d6a:	0f 94 c3             	sete   %bl
  popcli();
80104d6d:	e8 6e ff ff ff       	call   80104ce0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d72:	0f b6 db             	movzbl %bl,%ebx
}
80104d75:	89 d8                	mov    %ebx,%eax
80104d77:	5b                   	pop    %ebx
80104d78:	5e                   	pop    %esi
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop

80104d80 <release>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d88:	e8 03 ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d8d:	8b 03                	mov    (%ebx),%eax
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	75 15                	jne    80104da8 <release+0x28>
  popcli();
80104d93:	e8 48 ff ff ff       	call   80104ce0 <popcli>
    panic("release");
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	68 6d 80 10 80       	push   $0x8010806d
80104da0:	e8 db b5 ff ff       	call   80100380 <panic>
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104da8:	8b 73 08             	mov    0x8(%ebx),%esi
80104dab:	e8 80 f3 ff ff       	call   80104130 <mycpu>
80104db0:	39 c6                	cmp    %eax,%esi
80104db2:	75 df                	jne    80104d93 <release+0x13>
  popcli();
80104db4:	e8 27 ff ff ff       	call   80104ce0 <popcli>
  lk->pcs[0] = 0;
80104db9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104dc0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104dc7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dcc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
  popcli();
80104dd8:	e9 03 ff ff ff       	jmp    80104ce0 <popcli>
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <acquire>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104de7:	e8 a4 fe ff ff       	call   80104c90 <pushcli>
  if(holding(lk))
80104dec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104def:	e8 9c fe ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104df4:	8b 03                	mov    (%ebx),%eax
80104df6:	85 c0                	test   %eax,%eax
80104df8:	75 7e                	jne    80104e78 <acquire+0x98>
  popcli();
80104dfa:	e8 e1 fe ff ff       	call   80104ce0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104dff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104e08:	8b 55 08             	mov    0x8(%ebp),%edx
80104e0b:	89 c8                	mov    %ecx,%eax
80104e0d:	f0 87 02             	lock xchg %eax,(%edx)
80104e10:	85 c0                	test   %eax,%eax
80104e12:	75 f4                	jne    80104e08 <acquire+0x28>
  __sync_synchronize();
80104e14:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e1c:	e8 0f f3 ff ff       	call   80104130 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e24:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104e26:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104e29:	31 c0                	xor    %eax,%eax
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e30:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104e36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e3c:	77 1a                	ja     80104e58 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104e3e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104e41:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104e45:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104e48:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104e4a:	83 f8 0a             	cmp    $0xa,%eax
80104e4d:	75 e1                	jne    80104e30 <acquire+0x50>
}
80104e4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e52:	c9                   	leave  
80104e53:	c3                   	ret    
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e58:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104e5c:	8d 51 34             	lea    0x34(%ecx),%edx
80104e5f:	90                   	nop
    pcs[i] = 0;
80104e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e66:	83 c0 04             	add    $0x4,%eax
80104e69:	39 c2                	cmp    %eax,%edx
80104e6b:	75 f3                	jne    80104e60 <acquire+0x80>
}
80104e6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e70:	c9                   	leave  
80104e71:	c3                   	ret    
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e78:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104e7b:	e8 b0 f2 ff ff       	call   80104130 <mycpu>
80104e80:	39 c3                	cmp    %eax,%ebx
80104e82:	0f 85 72 ff ff ff    	jne    80104dfa <acquire+0x1a>
  popcli();
80104e88:	e8 53 fe ff ff       	call   80104ce0 <popcli>
    panic("acquire");
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	68 75 80 10 80       	push   $0x80108075
80104e95:	e8 e6 b4 ff ff       	call   80100380 <panic>
80104e9a:	66 90                	xchg   %ax,%ax
80104e9c:	66 90                	xchg   %ax,%ax
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eaa:	53                   	push   %ebx
80104eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104eae:	89 d7                	mov    %edx,%edi
80104eb0:	09 cf                	or     %ecx,%edi
80104eb2:	83 e7 03             	and    $0x3,%edi
80104eb5:	75 29                	jne    80104ee0 <memset+0x40>
    c &= 0xFF;
80104eb7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104eba:	c1 e0 18             	shl    $0x18,%eax
80104ebd:	89 fb                	mov    %edi,%ebx
80104ebf:	c1 e9 02             	shr    $0x2,%ecx
80104ec2:	c1 e3 10             	shl    $0x10,%ebx
80104ec5:	09 d8                	or     %ebx,%eax
80104ec7:	09 f8                	or     %edi,%eax
80104ec9:	c1 e7 08             	shl    $0x8,%edi
80104ecc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ece:	89 d7                	mov    %edx,%edi
80104ed0:	fc                   	cld    
80104ed1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ed3:	5b                   	pop    %ebx
80104ed4:	89 d0                	mov    %edx,%eax
80104ed6:	5f                   	pop    %edi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104ee0:	89 d7                	mov    %edx,%edi
80104ee2:	fc                   	cld    
80104ee3:	f3 aa                	rep stos %al,%es:(%edi)
80104ee5:	5b                   	pop    %ebx
80104ee6:	89 d0                	mov    %edx,%eax
80104ee8:	5f                   	pop    %edi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ef7:	8b 55 08             	mov    0x8(%ebp),%edx
80104efa:	53                   	push   %ebx
80104efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104efe:	85 f6                	test   %esi,%esi
80104f00:	74 2e                	je     80104f30 <memcmp+0x40>
80104f02:	01 c6                	add    %eax,%esi
80104f04:	eb 14                	jmp    80104f1a <memcmp+0x2a>
80104f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f10:	83 c0 01             	add    $0x1,%eax
80104f13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f16:	39 f0                	cmp    %esi,%eax
80104f18:	74 16                	je     80104f30 <memcmp+0x40>
    if(*s1 != *s2)
80104f1a:	0f b6 0a             	movzbl (%edx),%ecx
80104f1d:	0f b6 18             	movzbl (%eax),%ebx
80104f20:	38 d9                	cmp    %bl,%cl
80104f22:	74 ec                	je     80104f10 <memcmp+0x20>
      return *s1 - *s2;
80104f24:	0f b6 c1             	movzbl %cl,%eax
80104f27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	5b                   	pop    %ebx
  return 0;
80104f31:	31 c0                	xor    %eax,%eax
}
80104f33:	5e                   	pop    %esi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

80104f40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	8b 55 08             	mov    0x8(%ebp),%edx
80104f47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f4a:	56                   	push   %esi
80104f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f4e:	39 d6                	cmp    %edx,%esi
80104f50:	73 26                	jae    80104f78 <memmove+0x38>
80104f52:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f55:	39 fa                	cmp    %edi,%edx
80104f57:	73 1f                	jae    80104f78 <memmove+0x38>
80104f59:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f5c:	85 c9                	test   %ecx,%ecx
80104f5e:	74 0c                	je     80104f6c <memmove+0x2c>
      *--d = *--s;
80104f60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f64:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f67:	83 e8 01             	sub    $0x1,%eax
80104f6a:	73 f4                	jae    80104f60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f6c:	5e                   	pop    %esi
80104f6d:	89 d0                	mov    %edx,%eax
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f78:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f7b:	89 d7                	mov    %edx,%edi
80104f7d:	85 c9                	test   %ecx,%ecx
80104f7f:	74 eb                	je     80104f6c <memmove+0x2c>
80104f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f88:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f89:	39 c6                	cmp    %eax,%esi
80104f8b:	75 fb                	jne    80104f88 <memmove+0x48>
}
80104f8d:	5e                   	pop    %esi
80104f8e:	89 d0                	mov    %edx,%eax
80104f90:	5f                   	pop    %edi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fa0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104fa0:	eb 9e                	jmp    80104f40 <memmove>
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	8b 75 10             	mov    0x10(%ebp),%esi
80104fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fba:	53                   	push   %ebx
80104fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104fbe:	85 f6                	test   %esi,%esi
80104fc0:	74 2e                	je     80104ff0 <strncmp+0x40>
80104fc2:	01 d6                	add    %edx,%esi
80104fc4:	eb 18                	jmp    80104fde <strncmp+0x2e>
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
80104fd0:	38 d8                	cmp    %bl,%al
80104fd2:	75 14                	jne    80104fe8 <strncmp+0x38>
    n--, p++, q++;
80104fd4:	83 c2 01             	add    $0x1,%edx
80104fd7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fda:	39 f2                	cmp    %esi,%edx
80104fdc:	74 12                	je     80104ff0 <strncmp+0x40>
80104fde:	0f b6 01             	movzbl (%ecx),%eax
80104fe1:	0f b6 1a             	movzbl (%edx),%ebx
80104fe4:	84 c0                	test   %al,%al
80104fe6:	75 e8                	jne    80104fd0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fe8:	29 d8                	sub    %ebx,%eax
}
80104fea:	5b                   	pop    %ebx
80104feb:	5e                   	pop    %esi
80104fec:	5d                   	pop    %ebp
80104fed:	c3                   	ret    
80104fee:	66 90                	xchg   %ax,%ax
80104ff0:	5b                   	pop    %ebx
    return 0;
80104ff1:	31 c0                	xor    %eax,%eax
}
80104ff3:	5e                   	pop    %esi
80104ff4:	5d                   	pop    %ebp
80104ff5:	c3                   	ret    
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	8b 75 08             	mov    0x8(%ebp),%esi
80105008:	53                   	push   %ebx
80105009:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010500c:	89 f0                	mov    %esi,%eax
8010500e:	eb 15                	jmp    80105025 <strncpy+0x25>
80105010:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105014:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105017:	83 c0 01             	add    $0x1,%eax
8010501a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010501e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105021:	84 d2                	test   %dl,%dl
80105023:	74 09                	je     8010502e <strncpy+0x2e>
80105025:	89 cb                	mov    %ecx,%ebx
80105027:	83 e9 01             	sub    $0x1,%ecx
8010502a:	85 db                	test   %ebx,%ebx
8010502c:	7f e2                	jg     80105010 <strncpy+0x10>
    ;
  while(n-- > 0)
8010502e:	89 c2                	mov    %eax,%edx
80105030:	85 c9                	test   %ecx,%ecx
80105032:	7e 17                	jle    8010504b <strncpy+0x4b>
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105038:	83 c2 01             	add    $0x1,%edx
8010503b:	89 c1                	mov    %eax,%ecx
8010503d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105041:	29 d1                	sub    %edx,%ecx
80105043:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105047:	85 c9                	test   %ecx,%ecx
80105049:	7f ed                	jg     80105038 <strncpy+0x38>
  return os;
}
8010504b:	5b                   	pop    %ebx
8010504c:	89 f0                	mov    %esi,%eax
8010504e:	5e                   	pop    %esi
8010504f:	5f                   	pop    %edi
80105050:	5d                   	pop    %ebp
80105051:	c3                   	ret    
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105060 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	8b 55 10             	mov    0x10(%ebp),%edx
80105067:	8b 75 08             	mov    0x8(%ebp),%esi
8010506a:	53                   	push   %ebx
8010506b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010506e:	85 d2                	test   %edx,%edx
80105070:	7e 25                	jle    80105097 <safestrcpy+0x37>
80105072:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105076:	89 f2                	mov    %esi,%edx
80105078:	eb 16                	jmp    80105090 <safestrcpy+0x30>
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105080:	0f b6 08             	movzbl (%eax),%ecx
80105083:	83 c0 01             	add    $0x1,%eax
80105086:	83 c2 01             	add    $0x1,%edx
80105089:	88 4a ff             	mov    %cl,-0x1(%edx)
8010508c:	84 c9                	test   %cl,%cl
8010508e:	74 04                	je     80105094 <safestrcpy+0x34>
80105090:	39 d8                	cmp    %ebx,%eax
80105092:	75 ec                	jne    80105080 <safestrcpy+0x20>
    ;
  *s = 0;
80105094:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105097:	89 f0                	mov    %esi,%eax
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi

801050a0 <strlen>:

int
strlen(const char *s)
{
801050a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050a1:	31 c0                	xor    %eax,%eax
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050a8:	80 3a 00             	cmpb   $0x0,(%edx)
801050ab:	74 0c                	je     801050b9 <strlen+0x19>
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
801050b0:	83 c0 01             	add    $0x1,%eax
801050b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050b7:	75 f7                	jne    801050b0 <strlen+0x10>
    ;
  return n;
}
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    

801050bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050c3:	55                   	push   %ebp
  pushl %ebx
801050c4:	53                   	push   %ebx
  pushl %esi
801050c5:	56                   	push   %esi
  pushl %edi
801050c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050cb:	5f                   	pop    %edi
  popl %esi
801050cc:	5e                   	pop    %esi
  popl %ebx
801050cd:	5b                   	pop    %ebx
  popl %ebp
801050ce:	5d                   	pop    %ebp
  ret
801050cf:	c3                   	ret    

801050d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	53                   	push   %ebx
801050d4:	83 ec 04             	sub    $0x4,%esp
801050d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050da:	e8 d1 f0 ff ff       	call   801041b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050df:	8b 00                	mov    (%eax),%eax
801050e1:	39 d8                	cmp    %ebx,%eax
801050e3:	76 1b                	jbe    80105100 <fetchint+0x30>
801050e5:	8d 53 04             	lea    0x4(%ebx),%edx
801050e8:	39 d0                	cmp    %edx,%eax
801050ea:	72 14                	jb     80105100 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ef:	8b 13                	mov    (%ebx),%edx
801050f1:	89 10                	mov    %edx,(%eax)
  return 0;
801050f3:	31 c0                	xor    %eax,%eax
}
801050f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f8:	c9                   	leave  
801050f9:	c3                   	ret    
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105105:	eb ee                	jmp    801050f5 <fetchint+0x25>
80105107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510e:	66 90                	xchg   %ax,%ax

80105110 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 04             	sub    $0x4,%esp
80105117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010511a:	e8 91 f0 ff ff       	call   801041b0 <myproc>

  if(addr >= curproc->sz)
8010511f:	39 18                	cmp    %ebx,(%eax)
80105121:	76 2d                	jbe    80105150 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105123:	8b 55 0c             	mov    0xc(%ebp),%edx
80105126:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105128:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010512a:	39 d3                	cmp    %edx,%ebx
8010512c:	73 22                	jae    80105150 <fetchstr+0x40>
8010512e:	89 d8                	mov    %ebx,%eax
80105130:	eb 0d                	jmp    8010513f <fetchstr+0x2f>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105138:	83 c0 01             	add    $0x1,%eax
8010513b:	39 c2                	cmp    %eax,%edx
8010513d:	76 11                	jbe    80105150 <fetchstr+0x40>
    if(*s == 0)
8010513f:	80 38 00             	cmpb   $0x0,(%eax)
80105142:	75 f4                	jne    80105138 <fetchstr+0x28>
      return s - *pp;
80105144:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105149:	c9                   	leave  
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
80105150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105158:	c9                   	leave  
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105165:	e8 46 f0 ff ff       	call   801041b0 <myproc>
8010516a:	8b 55 08             	mov    0x8(%ebp),%edx
8010516d:	8b 40 18             	mov    0x18(%eax),%eax
80105170:	8b 40 44             	mov    0x44(%eax),%eax
80105173:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105176:	e8 35 f0 ff ff       	call   801041b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010517b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010517e:	8b 00                	mov    (%eax),%eax
80105180:	39 c6                	cmp    %eax,%esi
80105182:	73 1c                	jae    801051a0 <argint+0x40>
80105184:	8d 53 08             	lea    0x8(%ebx),%edx
80105187:	39 d0                	cmp    %edx,%eax
80105189:	72 15                	jb     801051a0 <argint+0x40>
  *ip = *(int*)(addr);
8010518b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518e:	8b 53 04             	mov    0x4(%ebx),%edx
80105191:	89 10                	mov    %edx,(%eax)
  return 0;
80105193:	31 c0                	xor    %eax,%eax
}
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5d                   	pop    %ebp
80105198:	c3                   	ret    
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051a5:	eb ee                	jmp    80105195 <argint+0x35>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801051b9:	e8 f2 ef ff ff       	call   801041b0 <myproc>
801051be:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051c0:	e8 eb ef ff ff       	call   801041b0 <myproc>
801051c5:	8b 55 08             	mov    0x8(%ebp),%edx
801051c8:	8b 40 18             	mov    0x18(%eax),%eax
801051cb:	8b 40 44             	mov    0x44(%eax),%eax
801051ce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051d1:	e8 da ef ff ff       	call   801041b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051d9:	8b 00                	mov    (%eax),%eax
801051db:	39 c7                	cmp    %eax,%edi
801051dd:	73 31                	jae    80105210 <argptr+0x60>
801051df:	8d 4b 08             	lea    0x8(%ebx),%ecx
801051e2:	39 c8                	cmp    %ecx,%eax
801051e4:	72 2a                	jb     80105210 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051e6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801051e9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051ec:	85 d2                	test   %edx,%edx
801051ee:	78 20                	js     80105210 <argptr+0x60>
801051f0:	8b 16                	mov    (%esi),%edx
801051f2:	39 c2                	cmp    %eax,%edx
801051f4:	76 1a                	jbe    80105210 <argptr+0x60>
801051f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801051f9:	01 c3                	add    %eax,%ebx
801051fb:	39 da                	cmp    %ebx,%edx
801051fd:	72 11                	jb     80105210 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801051ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105202:	89 02                	mov    %eax,(%edx)
  return 0;
80105204:	31 c0                	xor    %eax,%eax
}
80105206:	83 c4 0c             	add    $0xc,%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5f                   	pop    %edi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105215:	eb ef                	jmp    80105206 <argptr+0x56>
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax

80105220 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105225:	e8 86 ef ff ff       	call   801041b0 <myproc>
8010522a:	8b 55 08             	mov    0x8(%ebp),%edx
8010522d:	8b 40 18             	mov    0x18(%eax),%eax
80105230:	8b 40 44             	mov    0x44(%eax),%eax
80105233:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105236:	e8 75 ef ff ff       	call   801041b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010523b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010523e:	8b 00                	mov    (%eax),%eax
80105240:	39 c6                	cmp    %eax,%esi
80105242:	73 44                	jae    80105288 <argstr+0x68>
80105244:	8d 53 08             	lea    0x8(%ebx),%edx
80105247:	39 d0                	cmp    %edx,%eax
80105249:	72 3d                	jb     80105288 <argstr+0x68>
  *ip = *(int*)(addr);
8010524b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010524e:	e8 5d ef ff ff       	call   801041b0 <myproc>
  if(addr >= curproc->sz)
80105253:	3b 18                	cmp    (%eax),%ebx
80105255:	73 31                	jae    80105288 <argstr+0x68>
  *pp = (char*)addr;
80105257:	8b 55 0c             	mov    0xc(%ebp),%edx
8010525a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010525c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010525e:	39 d3                	cmp    %edx,%ebx
80105260:	73 26                	jae    80105288 <argstr+0x68>
80105262:	89 d8                	mov    %ebx,%eax
80105264:	eb 11                	jmp    80105277 <argstr+0x57>
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	83 c0 01             	add    $0x1,%eax
80105273:	39 c2                	cmp    %eax,%edx
80105275:	76 11                	jbe    80105288 <argstr+0x68>
    if(*s == 0)
80105277:	80 38 00             	cmpb   $0x0,(%eax)
8010527a:	75 f4                	jne    80105270 <argstr+0x50>
      return s - *pp;
8010527c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010527e:	5b                   	pop    %ebx
8010527f:	5e                   	pop    %esi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105288:	5b                   	pop    %ebx
    return -1;
80105289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010528e:	5e                   	pop    %esi
8010528f:	5d                   	pop    %ebp
80105290:	c3                   	ret    
80105291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop

801052a0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052a7:	e8 04 ef ff ff       	call   801041b0 <myproc>
801052ac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052ae:	8b 40 18             	mov    0x18(%eax),%eax
801052b1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052b4:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b7:	83 fa 14             	cmp    $0x14,%edx
801052ba:	77 24                	ja     801052e0 <syscall+0x40>
801052bc:	8b 14 85 a0 80 10 80 	mov    -0x7fef7f60(,%eax,4),%edx
801052c3:	85 d2                	test   %edx,%edx
801052c5:	74 19                	je     801052e0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052c7:	ff d2                	call   *%edx
801052c9:	89 c2                	mov    %eax,%edx
801052cb:	8b 43 18             	mov    0x18(%ebx),%eax
801052ce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052d4:	c9                   	leave  
801052d5:	c3                   	ret    
801052d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801052e0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052e1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052e4:	50                   	push   %eax
801052e5:	ff 73 10             	push   0x10(%ebx)
801052e8:	68 7d 80 10 80       	push   $0x8010807d
801052ed:	e8 0e b4 ff ff       	call   80100700 <cprintf>
    curproc->tf->eax = -1;
801052f2:	8b 43 18             	mov    0x18(%ebx),%eax
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105302:	c9                   	leave  
80105303:	c3                   	ret    
80105304:	66 90                	xchg   %ax,%ax
80105306:	66 90                	xchg   %ax,%ax
80105308:	66 90                	xchg   %ax,%ax
8010530a:	66 90                	xchg   %ax,%ax
8010530c:	66 90                	xchg   %ax,%ax
8010530e:	66 90                	xchg   %ax,%ax

80105310 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105315:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105318:	53                   	push   %ebx
80105319:	83 ec 34             	sub    $0x34,%esp
8010531c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010531f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105322:	57                   	push   %edi
80105323:	50                   	push   %eax
{
80105324:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105327:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010532a:	e8 d1 d5 ff ff       	call   80102900 <nameiparent>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	0f 84 46 01 00 00    	je     80105480 <create+0x170>
    return 0;
  ilock(dp);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	50                   	push   %eax
80105340:	e8 7b cc ff ff       	call   80101fc0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105345:	83 c4 0c             	add    $0xc,%esp
80105348:	6a 00                	push   $0x0
8010534a:	57                   	push   %edi
8010534b:	53                   	push   %ebx
8010534c:	e8 cf d1 ff ff       	call   80102520 <dirlookup>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	89 c6                	mov    %eax,%esi
80105356:	85 c0                	test   %eax,%eax
80105358:	74 56                	je     801053b0 <create+0xa0>
    iunlockput(dp);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	53                   	push   %ebx
8010535e:	e8 ed ce ff ff       	call   80102250 <iunlockput>
    ilock(ip);
80105363:	89 34 24             	mov    %esi,(%esp)
80105366:	e8 55 cc ff ff       	call   80101fc0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010536b:	83 c4 10             	add    $0x10,%esp
8010536e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105373:	75 1b                	jne    80105390 <create+0x80>
80105375:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010537a:	75 14                	jne    80105390 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010537c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537f:	89 f0                	mov    %esi,%eax
80105381:	5b                   	pop    %ebx
80105382:	5e                   	pop    %esi
80105383:	5f                   	pop    %edi
80105384:	5d                   	pop    %ebp
80105385:	c3                   	ret    
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	56                   	push   %esi
    return 0;
80105394:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105396:	e8 b5 ce ff ff       	call   80102250 <iunlockput>
    return 0;
8010539b:	83 c4 10             	add    $0x10,%esp
}
8010539e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a1:	89 f0                	mov    %esi,%eax
801053a3:	5b                   	pop    %ebx
801053a4:	5e                   	pop    %esi
801053a5:	5f                   	pop    %edi
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    
801053a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053b4:	83 ec 08             	sub    $0x8,%esp
801053b7:	50                   	push   %eax
801053b8:	ff 33                	push   (%ebx)
801053ba:	e8 91 ca ff ff       	call   80101e50 <ialloc>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	89 c6                	mov    %eax,%esi
801053c4:	85 c0                	test   %eax,%eax
801053c6:	0f 84 cd 00 00 00    	je     80105499 <create+0x189>
  ilock(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	50                   	push   %eax
801053d0:	e8 eb cb ff ff       	call   80101fc0 <ilock>
  ip->major = major;
801053d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053d9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053e1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053e5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053ee:	89 34 24             	mov    %esi,(%esp)
801053f1:	e8 1a cb ff ff       	call   80101f10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053fe:	74 30                	je     80105430 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105400:	83 ec 04             	sub    $0x4,%esp
80105403:	ff 76 04             	push   0x4(%esi)
80105406:	57                   	push   %edi
80105407:	53                   	push   %ebx
80105408:	e8 13 d4 ff ff       	call   80102820 <dirlink>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 78                	js     8010548c <create+0x17c>
  iunlockput(dp);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	53                   	push   %ebx
80105418:	e8 33 ce ff ff       	call   80102250 <iunlockput>
  return ip;
8010541d:	83 c4 10             	add    $0x10,%esp
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105423:	89 f0                	mov    %esi,%eax
80105425:	5b                   	pop    %ebx
80105426:	5e                   	pop    %esi
80105427:	5f                   	pop    %edi
80105428:	5d                   	pop    %ebp
80105429:	c3                   	ret    
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105433:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105438:	53                   	push   %ebx
80105439:	e8 d2 ca ff ff       	call   80101f10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010543e:	83 c4 0c             	add    $0xc,%esp
80105441:	ff 76 04             	push   0x4(%esi)
80105444:	68 14 81 10 80       	push   $0x80108114
80105449:	56                   	push   %esi
8010544a:	e8 d1 d3 ff ff       	call   80102820 <dirlink>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	78 18                	js     8010546e <create+0x15e>
80105456:	83 ec 04             	sub    $0x4,%esp
80105459:	ff 73 04             	push   0x4(%ebx)
8010545c:	68 13 81 10 80       	push   $0x80108113
80105461:	56                   	push   %esi
80105462:	e8 b9 d3 ff ff       	call   80102820 <dirlink>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	85 c0                	test   %eax,%eax
8010546c:	79 92                	jns    80105400 <create+0xf0>
      panic("create dots");
8010546e:	83 ec 0c             	sub    $0xc,%esp
80105471:	68 07 81 10 80       	push   $0x80108107
80105476:	e8 05 af ff ff       	call   80100380 <panic>
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105483:	31 f6                	xor    %esi,%esi
}
80105485:	5b                   	pop    %ebx
80105486:	89 f0                	mov    %esi,%eax
80105488:	5e                   	pop    %esi
80105489:	5f                   	pop    %edi
8010548a:	5d                   	pop    %ebp
8010548b:	c3                   	ret    
    panic("create: dirlink");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 16 81 10 80       	push   $0x80108116
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	68 f8 80 10 80       	push   $0x801080f8
801054a1:	e8 da ae ff ff       	call   80100380 <panic>
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi

801054b0 <sys_dup>:
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054bb:	50                   	push   %eax
801054bc:	6a 00                	push   $0x0
801054be:	e8 9d fc ff ff       	call   80105160 <argint>
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 36                	js     80105500 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ce:	77 30                	ja     80105500 <sys_dup+0x50>
801054d0:	e8 db ec ff ff       	call   801041b0 <myproc>
801054d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801054dc:	85 f6                	test   %esi,%esi
801054de:	74 20                	je     80105500 <sys_dup+0x50>
  struct proc *curproc = myproc();
801054e0:	e8 cb ec ff ff       	call   801041b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054e5:	31 db                	xor    %ebx,%ebx
801054e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054f4:	85 d2                	test   %edx,%edx
801054f6:	74 18                	je     80105510 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	75 f0                	jne    801054f0 <sys_dup+0x40>
}
80105500:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105503:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105508:	89 d8                	mov    %ebx,%eax
8010550a:	5b                   	pop    %ebx
8010550b:	5e                   	pop    %esi
8010550c:	5d                   	pop    %ebp
8010550d:	c3                   	ret    
8010550e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105510:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105513:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105517:	56                   	push   %esi
80105518:	e8 c3 c1 ff ff       	call   801016e0 <filedup>
  return fd;
8010551d:	83 c4 10             	add    $0x10,%esp
}
80105520:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105523:	89 d8                	mov    %ebx,%eax
80105525:	5b                   	pop    %ebx
80105526:	5e                   	pop    %esi
80105527:	5d                   	pop    %ebp
80105528:	c3                   	ret    
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_read>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105535:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105538:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010553b:	53                   	push   %ebx
8010553c:	6a 00                	push   $0x0
8010553e:	e8 1d fc ff ff       	call   80105160 <argint>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	78 5e                	js     801055a8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010554a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010554e:	77 58                	ja     801055a8 <sys_read+0x78>
80105550:	e8 5b ec ff ff       	call   801041b0 <myproc>
80105555:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105558:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010555c:	85 f6                	test   %esi,%esi
8010555e:	74 48                	je     801055a8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105566:	50                   	push   %eax
80105567:	6a 02                	push   $0x2
80105569:	e8 f2 fb ff ff       	call   80105160 <argint>
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
80105573:	78 33                	js     801055a8 <sys_read+0x78>
80105575:	83 ec 04             	sub    $0x4,%esp
80105578:	ff 75 f0             	push   -0x10(%ebp)
8010557b:	53                   	push   %ebx
8010557c:	6a 01                	push   $0x1
8010557e:	e8 2d fc ff ff       	call   801051b0 <argptr>
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 1e                	js     801055a8 <sys_read+0x78>
  return fileread(f, p, n);
8010558a:	83 ec 04             	sub    $0x4,%esp
8010558d:	ff 75 f0             	push   -0x10(%ebp)
80105590:	ff 75 f4             	push   -0xc(%ebp)
80105593:	56                   	push   %esi
80105594:	e8 c7 c2 ff ff       	call   80101860 <fileread>
80105599:	83 c4 10             	add    $0x10,%esp
}
8010559c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010559f:	5b                   	pop    %ebx
801055a0:	5e                   	pop    %esi
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret    
801055a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a7:	90                   	nop
    return -1;
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	eb ed                	jmp    8010559c <sys_read+0x6c>
801055af:	90                   	nop

801055b0 <sys_write>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055bb:	53                   	push   %ebx
801055bc:	6a 00                	push   $0x0
801055be:	e8 9d fb ff ff       	call   80105160 <argint>
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	78 5e                	js     80105628 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ce:	77 58                	ja     80105628 <sys_write+0x78>
801055d0:	e8 db eb ff ff       	call   801041b0 <myproc>
801055d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801055dc:	85 f6                	test   %esi,%esi
801055de:	74 48                	je     80105628 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 02                	push   $0x2
801055e9:	e8 72 fb ff ff       	call   80105160 <argint>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 33                	js     80105628 <sys_write+0x78>
801055f5:	83 ec 04             	sub    $0x4,%esp
801055f8:	ff 75 f0             	push   -0x10(%ebp)
801055fb:	53                   	push   %ebx
801055fc:	6a 01                	push   $0x1
801055fe:	e8 ad fb ff ff       	call   801051b0 <argptr>
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 1e                	js     80105628 <sys_write+0x78>
  return filewrite(f, p, n);
8010560a:	83 ec 04             	sub    $0x4,%esp
8010560d:	ff 75 f0             	push   -0x10(%ebp)
80105610:	ff 75 f4             	push   -0xc(%ebp)
80105613:	56                   	push   %esi
80105614:	e8 d7 c2 ff ff       	call   801018f0 <filewrite>
80105619:	83 c4 10             	add    $0x10,%esp
}
8010561c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010561f:	5b                   	pop    %ebx
80105620:	5e                   	pop    %esi
80105621:	5d                   	pop    %ebp
80105622:	c3                   	ret    
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb ed                	jmp    8010561c <sys_write+0x6c>
8010562f:	90                   	nop

80105630 <sys_close>:
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105635:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105638:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010563b:	50                   	push   %eax
8010563c:	6a 00                	push   $0x0
8010563e:	e8 1d fb ff ff       	call   80105160 <argint>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 3e                	js     80105688 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010564a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010564e:	77 38                	ja     80105688 <sys_close+0x58>
80105650:	e8 5b eb ff ff       	call   801041b0 <myproc>
80105655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105658:	8d 5a 08             	lea    0x8(%edx),%ebx
8010565b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010565f:	85 f6                	test   %esi,%esi
80105661:	74 25                	je     80105688 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105663:	e8 48 eb ff ff       	call   801041b0 <myproc>
  fileclose(f);
80105668:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010566b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105672:	00 
  fileclose(f);
80105673:	56                   	push   %esi
80105674:	e8 b7 c0 ff ff       	call   80101730 <fileclose>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105681:	5b                   	pop    %ebx
80105682:	5e                   	pop    %esi
80105683:	5d                   	pop    %ebp
80105684:	c3                   	ret    
80105685:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb ef                	jmp    8010567e <sys_close+0x4e>
8010568f:	90                   	nop

80105690 <sys_fstat>:
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105695:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105698:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010569b:	53                   	push   %ebx
8010569c:	6a 00                	push   $0x0
8010569e:	e8 bd fa ff ff       	call   80105160 <argint>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 46                	js     801056f0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056ae:	77 40                	ja     801056f0 <sys_fstat+0x60>
801056b0:	e8 fb ea ff ff       	call   801041b0 <myproc>
801056b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801056bc:	85 f6                	test   %esi,%esi
801056be:	74 30                	je     801056f0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056c0:	83 ec 04             	sub    $0x4,%esp
801056c3:	6a 14                	push   $0x14
801056c5:	53                   	push   %ebx
801056c6:	6a 01                	push   $0x1
801056c8:	e8 e3 fa ff ff       	call   801051b0 <argptr>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 1c                	js     801056f0 <sys_fstat+0x60>
  return filestat(f, st);
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	ff 75 f4             	push   -0xc(%ebp)
801056da:	56                   	push   %esi
801056db:	e8 30 c1 ff ff       	call   80101810 <filestat>
801056e0:	83 c4 10             	add    $0x10,%esp
}
801056e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e6:	5b                   	pop    %ebx
801056e7:	5e                   	pop    %esi
801056e8:	5d                   	pop    %ebp
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f5:	eb ec                	jmp    801056e3 <sys_fstat+0x53>
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax

80105700 <sys_link>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105705:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 0c fb ff ff       	call   80105220 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 fb 00 00 00    	js     8010581a <sys_link+0x11a>
8010571f:	83 ec 08             	sub    $0x8,%esp
80105722:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105725:	50                   	push   %eax
80105726:	6a 01                	push   $0x1
80105728:	e8 f3 fa ff ff       	call   80105220 <argstr>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	0f 88 e2 00 00 00    	js     8010581a <sys_link+0x11a>
  begin_op();
80105738:	e8 63 de ff ff       	call   801035a0 <begin_op>
  if((ip = namei(old)) == 0){
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	ff 75 d4             	push   -0x2c(%ebp)
80105743:	e8 98 d1 ff ff       	call   801028e0 <namei>
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	89 c3                	mov    %eax,%ebx
8010574d:	85 c0                	test   %eax,%eax
8010574f:	0f 84 e4 00 00 00    	je     80105839 <sys_link+0x139>
  ilock(ip);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	50                   	push   %eax
80105759:	e8 62 c8 ff ff       	call   80101fc0 <ilock>
  if(ip->type == T_DIR){
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105766:	0f 84 b5 00 00 00    	je     80105821 <sys_link+0x121>
  iupdate(ip);
8010576c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010576f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105774:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105777:	53                   	push   %ebx
80105778:	e8 93 c7 ff ff       	call   80101f10 <iupdate>
  iunlock(ip);
8010577d:	89 1c 24             	mov    %ebx,(%esp)
80105780:	e8 1b c9 ff ff       	call   801020a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105785:	58                   	pop    %eax
80105786:	5a                   	pop    %edx
80105787:	57                   	push   %edi
80105788:	ff 75 d0             	push   -0x30(%ebp)
8010578b:	e8 70 d1 ff ff       	call   80102900 <nameiparent>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	89 c6                	mov    %eax,%esi
80105795:	85 c0                	test   %eax,%eax
80105797:	74 5b                	je     801057f4 <sys_link+0xf4>
  ilock(dp);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 1e c8 ff ff       	call   80101fc0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057a2:	8b 03                	mov    (%ebx),%eax
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	39 06                	cmp    %eax,(%esi)
801057a9:	75 3d                	jne    801057e8 <sys_link+0xe8>
801057ab:	83 ec 04             	sub    $0x4,%esp
801057ae:	ff 73 04             	push   0x4(%ebx)
801057b1:	57                   	push   %edi
801057b2:	56                   	push   %esi
801057b3:	e8 68 d0 ff ff       	call   80102820 <dirlink>
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	85 c0                	test   %eax,%eax
801057bd:	78 29                	js     801057e8 <sys_link+0xe8>
  iunlockput(dp);
801057bf:	83 ec 0c             	sub    $0xc,%esp
801057c2:	56                   	push   %esi
801057c3:	e8 88 ca ff ff       	call   80102250 <iunlockput>
  iput(ip);
801057c8:	89 1c 24             	mov    %ebx,(%esp)
801057cb:	e8 20 c9 ff ff       	call   801020f0 <iput>
  end_op();
801057d0:	e8 3b de ff ff       	call   80103610 <end_op>
  return 0;
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	31 c0                	xor    %eax,%eax
}
801057da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057dd:	5b                   	pop    %ebx
801057de:	5e                   	pop    %esi
801057df:	5f                   	pop    %edi
801057e0:	5d                   	pop    %ebp
801057e1:	c3                   	ret    
801057e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	56                   	push   %esi
801057ec:	e8 5f ca ff ff       	call   80102250 <iunlockput>
    goto bad;
801057f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	53                   	push   %ebx
801057f8:	e8 c3 c7 ff ff       	call   80101fc0 <ilock>
  ip->nlink--;
801057fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105802:	89 1c 24             	mov    %ebx,(%esp)
80105805:	e8 06 c7 ff ff       	call   80101f10 <iupdate>
  iunlockput(ip);
8010580a:	89 1c 24             	mov    %ebx,(%esp)
8010580d:	e8 3e ca ff ff       	call   80102250 <iunlockput>
  end_op();
80105812:	e8 f9 dd ff ff       	call   80103610 <end_op>
  return -1;
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581f:	eb b9                	jmp    801057da <sys_link+0xda>
    iunlockput(ip);
80105821:	83 ec 0c             	sub    $0xc,%esp
80105824:	53                   	push   %ebx
80105825:	e8 26 ca ff ff       	call   80102250 <iunlockput>
    end_op();
8010582a:	e8 e1 dd ff ff       	call   80103610 <end_op>
    return -1;
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105837:	eb a1                	jmp    801057da <sys_link+0xda>
    end_op();
80105839:	e8 d2 dd ff ff       	call   80103610 <end_op>
    return -1;
8010583e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105843:	eb 95                	jmp    801057da <sys_link+0xda>
80105845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_unlink>:
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105855:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105858:	53                   	push   %ebx
80105859:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010585c:	50                   	push   %eax
8010585d:	6a 00                	push   $0x0
8010585f:	e8 bc f9 ff ff       	call   80105220 <argstr>
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	85 c0                	test   %eax,%eax
80105869:	0f 88 7a 01 00 00    	js     801059e9 <sys_unlink+0x199>
  begin_op();
8010586f:	e8 2c dd ff ff       	call   801035a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105874:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	53                   	push   %ebx
8010587b:	ff 75 c0             	push   -0x40(%ebp)
8010587e:	e8 7d d0 ff ff       	call   80102900 <nameiparent>
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105889:	85 c0                	test   %eax,%eax
8010588b:	0f 84 62 01 00 00    	je     801059f3 <sys_unlink+0x1a3>
  ilock(dp);
80105891:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105894:	83 ec 0c             	sub    $0xc,%esp
80105897:	57                   	push   %edi
80105898:	e8 23 c7 ff ff       	call   80101fc0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010589d:	58                   	pop    %eax
8010589e:	5a                   	pop    %edx
8010589f:	68 14 81 10 80       	push   $0x80108114
801058a4:	53                   	push   %ebx
801058a5:	e8 56 cc ff ff       	call   80102500 <namecmp>
801058aa:	83 c4 10             	add    $0x10,%esp
801058ad:	85 c0                	test   %eax,%eax
801058af:	0f 84 fb 00 00 00    	je     801059b0 <sys_unlink+0x160>
801058b5:	83 ec 08             	sub    $0x8,%esp
801058b8:	68 13 81 10 80       	push   $0x80108113
801058bd:	53                   	push   %ebx
801058be:	e8 3d cc ff ff       	call   80102500 <namecmp>
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	0f 84 e2 00 00 00    	je     801059b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058ce:	83 ec 04             	sub    $0x4,%esp
801058d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058d4:	50                   	push   %eax
801058d5:	53                   	push   %ebx
801058d6:	57                   	push   %edi
801058d7:	e8 44 cc ff ff       	call   80102520 <dirlookup>
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	89 c3                	mov    %eax,%ebx
801058e1:	85 c0                	test   %eax,%eax
801058e3:	0f 84 c7 00 00 00    	je     801059b0 <sys_unlink+0x160>
  ilock(ip);
801058e9:	83 ec 0c             	sub    $0xc,%esp
801058ec:	50                   	push   %eax
801058ed:	e8 ce c6 ff ff       	call   80101fc0 <ilock>
  if(ip->nlink < 1)
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058fa:	0f 8e 1c 01 00 00    	jle    80105a1c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105900:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105905:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105908:	74 66                	je     80105970 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010590a:	83 ec 04             	sub    $0x4,%esp
8010590d:	6a 10                	push   $0x10
8010590f:	6a 00                	push   $0x0
80105911:	57                   	push   %edi
80105912:	e8 89 f5 ff ff       	call   80104ea0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105917:	6a 10                	push   $0x10
80105919:	ff 75 c4             	push   -0x3c(%ebp)
8010591c:	57                   	push   %edi
8010591d:	ff 75 b4             	push   -0x4c(%ebp)
80105920:	e8 ab ca ff ff       	call   801023d0 <writei>
80105925:	83 c4 20             	add    $0x20,%esp
80105928:	83 f8 10             	cmp    $0x10,%eax
8010592b:	0f 85 de 00 00 00    	jne    80105a0f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105931:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105936:	0f 84 94 00 00 00    	je     801059d0 <sys_unlink+0x180>
  iunlockput(dp);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	ff 75 b4             	push   -0x4c(%ebp)
80105942:	e8 09 c9 ff ff       	call   80102250 <iunlockput>
  ip->nlink--;
80105947:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010594c:	89 1c 24             	mov    %ebx,(%esp)
8010594f:	e8 bc c5 ff ff       	call   80101f10 <iupdate>
  iunlockput(ip);
80105954:	89 1c 24             	mov    %ebx,(%esp)
80105957:	e8 f4 c8 ff ff       	call   80102250 <iunlockput>
  end_op();
8010595c:	e8 af dc ff ff       	call   80103610 <end_op>
  return 0;
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	31 c0                	xor    %eax,%eax
}
80105966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105969:	5b                   	pop    %ebx
8010596a:	5e                   	pop    %esi
8010596b:	5f                   	pop    %edi
8010596c:	5d                   	pop    %ebp
8010596d:	c3                   	ret    
8010596e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105970:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105974:	76 94                	jbe    8010590a <sys_unlink+0xba>
80105976:	be 20 00 00 00       	mov    $0x20,%esi
8010597b:	eb 0b                	jmp    80105988 <sys_unlink+0x138>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
80105980:	83 c6 10             	add    $0x10,%esi
80105983:	3b 73 58             	cmp    0x58(%ebx),%esi
80105986:	73 82                	jae    8010590a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105988:	6a 10                	push   $0x10
8010598a:	56                   	push   %esi
8010598b:	57                   	push   %edi
8010598c:	53                   	push   %ebx
8010598d:	e8 3e c9 ff ff       	call   801022d0 <readi>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	83 f8 10             	cmp    $0x10,%eax
80105998:	75 68                	jne    80105a02 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010599a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010599f:	74 df                	je     80105980 <sys_unlink+0x130>
    iunlockput(ip);
801059a1:	83 ec 0c             	sub    $0xc,%esp
801059a4:	53                   	push   %ebx
801059a5:	e8 a6 c8 ff ff       	call   80102250 <iunlockput>
    goto bad;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	ff 75 b4             	push   -0x4c(%ebp)
801059b6:	e8 95 c8 ff ff       	call   80102250 <iunlockput>
  end_op();
801059bb:	e8 50 dc ff ff       	call   80103610 <end_op>
  return -1;
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c8:	eb 9c                	jmp    80105966 <sys_unlink+0x116>
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801059d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801059d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801059db:	50                   	push   %eax
801059dc:	e8 2f c5 ff ff       	call   80101f10 <iupdate>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	e9 53 ff ff ff       	jmp    8010593c <sys_unlink+0xec>
    return -1;
801059e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ee:	e9 73 ff ff ff       	jmp    80105966 <sys_unlink+0x116>
    end_op();
801059f3:	e8 18 dc ff ff       	call   80103610 <end_op>
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fd:	e9 64 ff ff ff       	jmp    80105966 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105a02:	83 ec 0c             	sub    $0xc,%esp
80105a05:	68 38 81 10 80       	push   $0x80108138
80105a0a:	e8 71 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	68 4a 81 10 80       	push   $0x8010814a
80105a17:	e8 64 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	68 26 81 10 80       	push   $0x80108126
80105a24:	e8 57 a9 ff ff       	call   80100380 <panic>
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_open>:

int
sys_open(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a35:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a38:	53                   	push   %ebx
80105a39:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a3c:	50                   	push   %eax
80105a3d:	6a 00                	push   $0x0
80105a3f:	e8 dc f7 ff ff       	call   80105220 <argstr>
80105a44:	83 c4 10             	add    $0x10,%esp
80105a47:	85 c0                	test   %eax,%eax
80105a49:	0f 88 8e 00 00 00    	js     80105add <sys_open+0xad>
80105a4f:	83 ec 08             	sub    $0x8,%esp
80105a52:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a55:	50                   	push   %eax
80105a56:	6a 01                	push   $0x1
80105a58:	e8 03 f7 ff ff       	call   80105160 <argint>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	85 c0                	test   %eax,%eax
80105a62:	78 79                	js     80105add <sys_open+0xad>
    return -1;

  begin_op();
80105a64:	e8 37 db ff ff       	call   801035a0 <begin_op>

  if(omode & O_CREATE){
80105a69:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a6d:	75 79                	jne    80105ae8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	ff 75 e0             	push   -0x20(%ebp)
80105a75:	e8 66 ce ff ff       	call   801028e0 <namei>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	89 c6                	mov    %eax,%esi
80105a7f:	85 c0                	test   %eax,%eax
80105a81:	0f 84 7e 00 00 00    	je     80105b05 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a87:	83 ec 0c             	sub    $0xc,%esp
80105a8a:	50                   	push   %eax
80105a8b:	e8 30 c5 ff ff       	call   80101fc0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a90:	83 c4 10             	add    $0x10,%esp
80105a93:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a98:	0f 84 c2 00 00 00    	je     80105b60 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a9e:	e8 cd bb ff ff       	call   80101670 <filealloc>
80105aa3:	89 c7                	mov    %eax,%edi
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 23                	je     80105acc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105aa9:	e8 02 e7 ff ff       	call   801041b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ab0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ab4:	85 d2                	test   %edx,%edx
80105ab6:	74 60                	je     80105b18 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ab8:	83 c3 01             	add    $0x1,%ebx
80105abb:	83 fb 10             	cmp    $0x10,%ebx
80105abe:	75 f0                	jne    80105ab0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	57                   	push   %edi
80105ac4:	e8 67 bc ff ff       	call   80101730 <fileclose>
80105ac9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105acc:	83 ec 0c             	sub    $0xc,%esp
80105acf:	56                   	push   %esi
80105ad0:	e8 7b c7 ff ff       	call   80102250 <iunlockput>
    end_op();
80105ad5:	e8 36 db ff ff       	call   80103610 <end_op>
    return -1;
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ae2:	eb 6d                	jmp    80105b51 <sys_open+0x121>
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aee:	31 c9                	xor    %ecx,%ecx
80105af0:	ba 02 00 00 00       	mov    $0x2,%edx
80105af5:	6a 00                	push   $0x0
80105af7:	e8 14 f8 ff ff       	call   80105310 <create>
    if(ip == 0){
80105afc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105aff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b01:	85 c0                	test   %eax,%eax
80105b03:	75 99                	jne    80105a9e <sys_open+0x6e>
      end_op();
80105b05:	e8 06 db ff ff       	call   80103610 <end_op>
      return -1;
80105b0a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b0f:	eb 40                	jmp    80105b51 <sys_open+0x121>
80105b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b18:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b1b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b1f:	56                   	push   %esi
80105b20:	e8 7b c5 ff ff       	call   801020a0 <iunlock>
  end_op();
80105b25:	e8 e6 da ff ff       	call   80103610 <end_op>

  f->type = FD_INODE;
80105b2a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b33:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b36:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b39:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b3b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b42:	f7 d0                	not    %eax
80105b44:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b47:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b4a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b4d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b54:	89 d8                	mov    %ebx,%eax
80105b56:	5b                   	pop    %ebx
80105b57:	5e                   	pop    %esi
80105b58:	5f                   	pop    %edi
80105b59:	5d                   	pop    %ebp
80105b5a:	c3                   	ret    
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b63:	85 c9                	test   %ecx,%ecx
80105b65:	0f 84 33 ff ff ff    	je     80105a9e <sys_open+0x6e>
80105b6b:	e9 5c ff ff ff       	jmp    80105acc <sys_open+0x9c>

80105b70 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b76:	e8 25 da ff ff       	call   801035a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b7b:	83 ec 08             	sub    $0x8,%esp
80105b7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b81:	50                   	push   %eax
80105b82:	6a 00                	push   $0x0
80105b84:	e8 97 f6 ff ff       	call   80105220 <argstr>
80105b89:	83 c4 10             	add    $0x10,%esp
80105b8c:	85 c0                	test   %eax,%eax
80105b8e:	78 30                	js     80105bc0 <sys_mkdir+0x50>
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b96:	31 c9                	xor    %ecx,%ecx
80105b98:	ba 01 00 00 00       	mov    $0x1,%edx
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 6c f7 ff ff       	call   80105310 <create>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	74 15                	je     80105bc0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bab:	83 ec 0c             	sub    $0xc,%esp
80105bae:	50                   	push   %eax
80105baf:	e8 9c c6 ff ff       	call   80102250 <iunlockput>
  end_op();
80105bb4:	e8 57 da ff ff       	call   80103610 <end_op>
  return 0;
80105bb9:	83 c4 10             	add    $0x10,%esp
80105bbc:	31 c0                	xor    %eax,%eax
}
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    
    end_op();
80105bc0:	e8 4b da ff ff       	call   80103610 <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bca:	c9                   	leave  
80105bcb:	c3                   	ret    
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_mknod>:

int
sys_mknod(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bd6:	e8 c5 d9 ff ff       	call   801035a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bdb:	83 ec 08             	sub    $0x8,%esp
80105bde:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be1:	50                   	push   %eax
80105be2:	6a 00                	push   $0x0
80105be4:	e8 37 f6 ff ff       	call   80105220 <argstr>
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	85 c0                	test   %eax,%eax
80105bee:	78 60                	js     80105c50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf6:	50                   	push   %eax
80105bf7:	6a 01                	push   $0x1
80105bf9:	e8 62 f5 ff ff       	call   80105160 <argint>
  if((argstr(0, &path)) < 0 ||
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	78 4b                	js     80105c50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c05:	83 ec 08             	sub    $0x8,%esp
80105c08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0b:	50                   	push   %eax
80105c0c:	6a 02                	push   $0x2
80105c0e:	e8 4d f5 ff ff       	call   80105160 <argint>
     argint(1, &major) < 0 ||
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	78 36                	js     80105c50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c1a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c25:	ba 03 00 00 00       	mov    $0x3,%edx
80105c2a:	50                   	push   %eax
80105c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c2e:	e8 dd f6 ff ff       	call   80105310 <create>
     argint(2, &minor) < 0 ||
80105c33:	83 c4 10             	add    $0x10,%esp
80105c36:	85 c0                	test   %eax,%eax
80105c38:	74 16                	je     80105c50 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c3a:	83 ec 0c             	sub    $0xc,%esp
80105c3d:	50                   	push   %eax
80105c3e:	e8 0d c6 ff ff       	call   80102250 <iunlockput>
  end_op();
80105c43:	e8 c8 d9 ff ff       	call   80103610 <end_op>
  return 0;
80105c48:	83 c4 10             	add    $0x10,%esp
80105c4b:	31 c0                	xor    %eax,%eax
}
80105c4d:	c9                   	leave  
80105c4e:	c3                   	ret    
80105c4f:	90                   	nop
    end_op();
80105c50:	e8 bb d9 ff ff       	call   80103610 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_chdir>:

int
sys_chdir(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	56                   	push   %esi
80105c64:	53                   	push   %ebx
80105c65:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c68:	e8 43 e5 ff ff       	call   801041b0 <myproc>
80105c6d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c6f:	e8 2c d9 ff ff       	call   801035a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 9e f5 ff ff       	call   80105220 <argstr>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 77                	js     80105d00 <sys_chdir+0xa0>
80105c89:	83 ec 0c             	sub    $0xc,%esp
80105c8c:	ff 75 f4             	push   -0xc(%ebp)
80105c8f:	e8 4c cc ff ff       	call   801028e0 <namei>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	89 c3                	mov    %eax,%ebx
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 63                	je     80105d00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c9d:	83 ec 0c             	sub    $0xc,%esp
80105ca0:	50                   	push   %eax
80105ca1:	e8 1a c3 ff ff       	call   80101fc0 <ilock>
  if(ip->type != T_DIR){
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cae:	75 30                	jne    80105ce0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	53                   	push   %ebx
80105cb4:	e8 e7 c3 ff ff       	call   801020a0 <iunlock>
  iput(curproc->cwd);
80105cb9:	58                   	pop    %eax
80105cba:	ff 76 68             	push   0x68(%esi)
80105cbd:	e8 2e c4 ff ff       	call   801020f0 <iput>
  end_op();
80105cc2:	e8 49 d9 ff ff       	call   80103610 <end_op>
  curproc->cwd = ip;
80105cc7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	31 c0                	xor    %eax,%eax
}
80105ccf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cd2:	5b                   	pop    %ebx
80105cd3:	5e                   	pop    %esi
80105cd4:	5d                   	pop    %ebp
80105cd5:	c3                   	ret    
80105cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	53                   	push   %ebx
80105ce4:	e8 67 c5 ff ff       	call   80102250 <iunlockput>
    end_op();
80105ce9:	e8 22 d9 ff ff       	call   80103610 <end_op>
    return -1;
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf6:	eb d7                	jmp    80105ccf <sys_chdir+0x6f>
80105cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
    end_op();
80105d00:	e8 0b d9 ff ff       	call   80103610 <end_op>
    return -1;
80105d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0a:	eb c3                	jmp    80105ccf <sys_chdir+0x6f>
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d10 <sys_exec>:

int
sys_exec(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d15:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d1b:	53                   	push   %ebx
80105d1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d22:	50                   	push   %eax
80105d23:	6a 00                	push   $0x0
80105d25:	e8 f6 f4 ff ff       	call   80105220 <argstr>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	0f 88 87 00 00 00    	js     80105dbc <sys_exec+0xac>
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d3e:	50                   	push   %eax
80105d3f:	6a 01                	push   $0x1
80105d41:	e8 1a f4 ff ff       	call   80105160 <argint>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	78 6f                	js     80105dbc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d4d:	83 ec 04             	sub    $0x4,%esp
80105d50:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105d56:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d58:	68 80 00 00 00       	push   $0x80
80105d5d:	6a 00                	push   $0x0
80105d5f:	56                   	push   %esi
80105d60:	e8 3b f1 ff ff       	call   80104ea0 <memset>
80105d65:	83 c4 10             	add    $0x10,%esp
80105d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d79:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105d80:	50                   	push   %eax
80105d81:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d87:	01 f8                	add    %edi,%eax
80105d89:	50                   	push   %eax
80105d8a:	e8 41 f3 ff ff       	call   801050d0 <fetchint>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	85 c0                	test   %eax,%eax
80105d94:	78 26                	js     80105dbc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d96:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d9c:	85 c0                	test   %eax,%eax
80105d9e:	74 30                	je     80105dd0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105da0:	83 ec 08             	sub    $0x8,%esp
80105da3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105da6:	52                   	push   %edx
80105da7:	50                   	push   %eax
80105da8:	e8 63 f3 ff ff       	call   80105110 <fetchstr>
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	85 c0                	test   %eax,%eax
80105db2:	78 08                	js     80105dbc <sys_exec+0xac>
  for(i=0;; i++){
80105db4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105db7:	83 fb 20             	cmp    $0x20,%ebx
80105dba:	75 b4                	jne    80105d70 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc4:	5b                   	pop    %ebx
80105dc5:	5e                   	pop    %esi
80105dc6:	5f                   	pop    %edi
80105dc7:	5d                   	pop    %ebp
80105dc8:	c3                   	ret    
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105dd0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dd7:	00 00 00 00 
  return exec(path, argv);
80105ddb:	83 ec 08             	sub    $0x8,%esp
80105dde:	56                   	push   %esi
80105ddf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105de5:	e8 06 b5 ff ff       	call   801012f0 <exec>
80105dea:	83 c4 10             	add    $0x10,%esp
}
80105ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df0:	5b                   	pop    %ebx
80105df1:	5e                   	pop    %esi
80105df2:	5f                   	pop    %edi
80105df3:	5d                   	pop    %ebp
80105df4:	c3                   	ret    
80105df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_pipe>:

int
sys_pipe(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e05:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e08:	53                   	push   %ebx
80105e09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e0c:	6a 08                	push   $0x8
80105e0e:	50                   	push   %eax
80105e0f:	6a 00                	push   $0x0
80105e11:	e8 9a f3 ff ff       	call   801051b0 <argptr>
80105e16:	83 c4 10             	add    $0x10,%esp
80105e19:	85 c0                	test   %eax,%eax
80105e1b:	78 4a                	js     80105e67 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e1d:	83 ec 08             	sub    $0x8,%esp
80105e20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e23:	50                   	push   %eax
80105e24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e27:	50                   	push   %eax
80105e28:	e8 43 de ff ff       	call   80103c70 <pipealloc>
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	85 c0                	test   %eax,%eax
80105e32:	78 33                	js     80105e67 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e34:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e37:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e39:	e8 72 e3 ff ff       	call   801041b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105e40:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e44:	85 f6                	test   %esi,%esi
80105e46:	74 28                	je     80105e70 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105e48:	83 c3 01             	add    $0x1,%ebx
80105e4b:	83 fb 10             	cmp    $0x10,%ebx
80105e4e:	75 f0                	jne    80105e40 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	ff 75 e0             	push   -0x20(%ebp)
80105e56:	e8 d5 b8 ff ff       	call   80101730 <fileclose>
    fileclose(wf);
80105e5b:	58                   	pop    %eax
80105e5c:	ff 75 e4             	push   -0x1c(%ebp)
80105e5f:	e8 cc b8 ff ff       	call   80101730 <fileclose>
    return -1;
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	eb 53                	jmp    80105ec1 <sys_pipe+0xc1>
80105e6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e70:	8d 73 08             	lea    0x8(%ebx),%esi
80105e73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e7a:	e8 31 e3 ff ff       	call   801041b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e7f:	31 d2                	xor    %edx,%edx
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e8c:	85 c9                	test   %ecx,%ecx
80105e8e:	74 20                	je     80105eb0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e90:	83 c2 01             	add    $0x1,%edx
80105e93:	83 fa 10             	cmp    $0x10,%edx
80105e96:	75 f0                	jne    80105e88 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e98:	e8 13 e3 ff ff       	call   801041b0 <myproc>
80105e9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ea4:	00 
80105ea5:	eb a9                	jmp    80105e50 <sys_pipe+0x50>
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105eb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ebc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ebf:	31 c0                	xor    %eax,%eax
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	66 90                	xchg   %ax,%ax
80105ecb:	66 90                	xchg   %ax,%ax
80105ecd:	66 90                	xchg   %ax,%ax
80105ecf:	90                   	nop

80105ed0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ed0:	e9 7b e4 ff ff       	jmp    80104350 <fork>
80105ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_exit>:
}

int
sys_exit(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ee6:	e8 e5 e6 ff ff       	call   801045d0 <exit>
  return 0;  // not reached
}
80105eeb:	31 c0                	xor    %eax,%eax
80105eed:	c9                   	leave  
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ef0:	e9 0b e8 ff ff       	jmp    80104700 <wait>
80105ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_kill>:
}

int
sys_kill(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f09:	50                   	push   %eax
80105f0a:	6a 00                	push   $0x0
80105f0c:	e8 4f f2 ff ff       	call   80105160 <argint>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	78 18                	js     80105f30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f18:	83 ec 0c             	sub    $0xc,%esp
80105f1b:	ff 75 f4             	push   -0xc(%ebp)
80105f1e:	e8 7d ea ff ff       	call   801049a0 <kill>
80105f23:	83 c4 10             	add    $0x10,%esp
}
80105f26:	c9                   	leave  
80105f27:	c3                   	ret    
80105f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop
80105f30:	c9                   	leave  
    return -1;
80105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f36:	c3                   	ret    
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_getpid>:

int
sys_getpid(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f46:	e8 65 e2 ff ff       	call   801041b0 <myproc>
80105f4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f4e:	c9                   	leave  
80105f4f:	c3                   	ret    

80105f50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f5a:	50                   	push   %eax
80105f5b:	6a 00                	push   $0x0
80105f5d:	e8 fe f1 ff ff       	call   80105160 <argint>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	85 c0                	test   %eax,%eax
80105f67:	78 27                	js     80105f90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f69:	e8 42 e2 ff ff       	call   801041b0 <myproc>
  if(growproc(n) < 0)
80105f6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f73:	ff 75 f4             	push   -0xc(%ebp)
80105f76:	e8 55 e3 ff ff       	call   801042d0 <growproc>
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	78 0e                	js     80105f90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f82:	89 d8                	mov    %ebx,%eax
80105f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f87:	c9                   	leave  
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f95:	eb eb                	jmp    80105f82 <sys_sbrk+0x32>
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_sleep>:

int
sys_sleep(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105faa:	50                   	push   %eax
80105fab:	6a 00                	push   $0x0
80105fad:	e8 ae f1 ff ff       	call   80105160 <argint>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	0f 88 8a 00 00 00    	js     80106047 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
80105fc0:	68 00 57 11 80       	push   $0x80115700
80105fc5:	e8 16 ee ff ff       	call   80104de0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105fcd:	8b 1d e0 56 11 80    	mov    0x801156e0,%ebx
  while(ticks - ticks0 < n){
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 d2                	test   %edx,%edx
80105fd8:	75 27                	jne    80106001 <sys_sleep+0x61>
80105fda:	eb 54                	jmp    80106030 <sys_sleep+0x90>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fe0:	83 ec 08             	sub    $0x8,%esp
80105fe3:	68 00 57 11 80       	push   $0x80115700
80105fe8:	68 e0 56 11 80       	push   $0x801156e0
80105fed:	e8 8e e8 ff ff       	call   80104880 <sleep>
  while(ticks - ticks0 < n){
80105ff2:	a1 e0 56 11 80       	mov    0x801156e0,%eax
80105ff7:	83 c4 10             	add    $0x10,%esp
80105ffa:	29 d8                	sub    %ebx,%eax
80105ffc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fff:	73 2f                	jae    80106030 <sys_sleep+0x90>
    if(myproc()->killed){
80106001:	e8 aa e1 ff ff       	call   801041b0 <myproc>
80106006:	8b 40 24             	mov    0x24(%eax),%eax
80106009:	85 c0                	test   %eax,%eax
8010600b:	74 d3                	je     80105fe0 <sys_sleep+0x40>
      release(&tickslock);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	68 00 57 11 80       	push   $0x80115700
80106015:	e8 66 ed ff ff       	call   80104d80 <release>
  }
  release(&tickslock);
  return 0;
}
8010601a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010601d:	83 c4 10             	add    $0x10,%esp
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106025:	c9                   	leave  
80106026:	c3                   	ret    
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	68 00 57 11 80       	push   $0x80115700
80106038:	e8 43 ed ff ff       	call   80104d80 <release>
  return 0;
8010603d:	83 c4 10             	add    $0x10,%esp
80106040:	31 c0                	xor    %eax,%eax
}
80106042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106045:	c9                   	leave  
80106046:	c3                   	ret    
    return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604c:	eb f4                	jmp    80106042 <sys_sleep+0xa2>
8010604e:	66 90                	xchg   %ax,%ax

80106050 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	53                   	push   %ebx
80106054:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106057:	68 00 57 11 80       	push   $0x80115700
8010605c:	e8 7f ed ff ff       	call   80104de0 <acquire>
  xticks = ticks;
80106061:	8b 1d e0 56 11 80    	mov    0x801156e0,%ebx
  release(&tickslock);
80106067:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
8010606e:	e8 0d ed ff ff       	call   80104d80 <release>
  return xticks;
}
80106073:	89 d8                	mov    %ebx,%eax
80106075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106078:	c9                   	leave  
80106079:	c3                   	ret    

8010607a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010607a:	1e                   	push   %ds
  pushl %es
8010607b:	06                   	push   %es
  pushl %fs
8010607c:	0f a0                	push   %fs
  pushl %gs
8010607e:	0f a8                	push   %gs
  pushal
80106080:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106081:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106085:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106087:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106089:	54                   	push   %esp
  call trap
8010608a:	e8 c1 00 00 00       	call   80106150 <trap>
  addl $4, %esp
8010608f:	83 c4 04             	add    $0x4,%esp

80106092 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106092:	61                   	popa   
  popl %gs
80106093:	0f a9                	pop    %gs
  popl %fs
80106095:	0f a1                	pop    %fs
  popl %es
80106097:	07                   	pop    %es
  popl %ds
80106098:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106099:	83 c4 08             	add    $0x8,%esp
  iret
8010609c:	cf                   	iret   
8010609d:	66 90                	xchg   %ax,%ax
8010609f:	90                   	nop

801060a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060a0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801060a1:	31 c0                	xor    %eax,%eax
{
801060a3:	89 e5                	mov    %esp,%ebp
801060a5:	83 ec 08             	sub    $0x8,%esp
801060a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060b0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801060b7:	c7 04 c5 42 57 11 80 	movl   $0x8e000008,-0x7feea8be(,%eax,8)
801060be:	08 00 00 8e 
801060c2:	66 89 14 c5 40 57 11 	mov    %dx,-0x7feea8c0(,%eax,8)
801060c9:	80 
801060ca:	c1 ea 10             	shr    $0x10,%edx
801060cd:	66 89 14 c5 46 57 11 	mov    %dx,-0x7feea8ba(,%eax,8)
801060d4:	80 
  for(i = 0; i < 256; i++)
801060d5:	83 c0 01             	add    $0x1,%eax
801060d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801060dd:	75 d1                	jne    801060b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801060df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060e2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801060e7:	c7 05 42 59 11 80 08 	movl   $0xef000008,0x80115942
801060ee:	00 00 ef 
  initlock(&tickslock, "time");
801060f1:	68 59 81 10 80       	push   $0x80108159
801060f6:	68 00 57 11 80       	push   $0x80115700
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060fb:	66 a3 40 59 11 80    	mov    %ax,0x80115940
80106101:	c1 e8 10             	shr    $0x10,%eax
80106104:	66 a3 46 59 11 80    	mov    %ax,0x80115946
  initlock(&tickslock, "time");
8010610a:	e8 01 eb ff ff       	call   80104c10 <initlock>
}
8010610f:	83 c4 10             	add    $0x10,%esp
80106112:	c9                   	leave  
80106113:	c3                   	ret    
80106114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop

80106120 <idtinit>:

void
idtinit(void)
{
80106120:	55                   	push   %ebp
  pd[0] = size-1;
80106121:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106126:	89 e5                	mov    %esp,%ebp
80106128:	83 ec 10             	sub    $0x10,%esp
8010612b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010612f:	b8 40 57 11 80       	mov    $0x80115740,%eax
80106134:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106138:	c1 e8 10             	shr    $0x10,%eax
8010613b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010613f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106142:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax

80106150 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	57                   	push   %edi
80106154:	56                   	push   %esi
80106155:	53                   	push   %ebx
80106156:	83 ec 1c             	sub    $0x1c,%esp
80106159:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010615c:	8b 43 30             	mov    0x30(%ebx),%eax
8010615f:	83 f8 40             	cmp    $0x40,%eax
80106162:	0f 84 68 01 00 00    	je     801062d0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106168:	83 e8 20             	sub    $0x20,%eax
8010616b:	83 f8 1f             	cmp    $0x1f,%eax
8010616e:	0f 87 8c 00 00 00    	ja     80106200 <trap+0xb0>
80106174:	ff 24 85 00 82 10 80 	jmp    *-0x7fef7e00(,%eax,4)
8010617b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010617f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106180:	e8 fb c8 ff ff       	call   80102a80 <ideintr>
    lapiceoi();
80106185:	e8 c6 cf ff ff       	call   80103150 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010618a:	e8 21 e0 ff ff       	call   801041b0 <myproc>
8010618f:	85 c0                	test   %eax,%eax
80106191:	74 1d                	je     801061b0 <trap+0x60>
80106193:	e8 18 e0 ff ff       	call   801041b0 <myproc>
80106198:	8b 50 24             	mov    0x24(%eax),%edx
8010619b:	85 d2                	test   %edx,%edx
8010619d:	74 11                	je     801061b0 <trap+0x60>
8010619f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061a3:	83 e0 03             	and    $0x3,%eax
801061a6:	66 83 f8 03          	cmp    $0x3,%ax
801061aa:	0f 84 e8 01 00 00    	je     80106398 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801061b0:	e8 fb df ff ff       	call   801041b0 <myproc>
801061b5:	85 c0                	test   %eax,%eax
801061b7:	74 0f                	je     801061c8 <trap+0x78>
801061b9:	e8 f2 df ff ff       	call   801041b0 <myproc>
801061be:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801061c2:	0f 84 b8 00 00 00    	je     80106280 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061c8:	e8 e3 df ff ff       	call   801041b0 <myproc>
801061cd:	85 c0                	test   %eax,%eax
801061cf:	74 1d                	je     801061ee <trap+0x9e>
801061d1:	e8 da df ff ff       	call   801041b0 <myproc>
801061d6:	8b 40 24             	mov    0x24(%eax),%eax
801061d9:	85 c0                	test   %eax,%eax
801061db:	74 11                	je     801061ee <trap+0x9e>
801061dd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061e1:	83 e0 03             	and    $0x3,%eax
801061e4:	66 83 f8 03          	cmp    $0x3,%ax
801061e8:	0f 84 0f 01 00 00    	je     801062fd <trap+0x1ad>
    exit();
}
801061ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f1:	5b                   	pop    %ebx
801061f2:	5e                   	pop    %esi
801061f3:	5f                   	pop    %edi
801061f4:	5d                   	pop    %ebp
801061f5:	c3                   	ret    
801061f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106200:	e8 ab df ff ff       	call   801041b0 <myproc>
80106205:	8b 7b 38             	mov    0x38(%ebx),%edi
80106208:	85 c0                	test   %eax,%eax
8010620a:	0f 84 a2 01 00 00    	je     801063b2 <trap+0x262>
80106210:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106214:	0f 84 98 01 00 00    	je     801063b2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010621a:	0f 20 d1             	mov    %cr2,%ecx
8010621d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106220:	e8 6b df ff ff       	call   80104190 <cpuid>
80106225:	8b 73 30             	mov    0x30(%ebx),%esi
80106228:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010622b:	8b 43 34             	mov    0x34(%ebx),%eax
8010622e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106231:	e8 7a df ff ff       	call   801041b0 <myproc>
80106236:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106239:	e8 72 df ff ff       	call   801041b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010623e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106241:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106244:	51                   	push   %ecx
80106245:	57                   	push   %edi
80106246:	52                   	push   %edx
80106247:	ff 75 e4             	push   -0x1c(%ebp)
8010624a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010624b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010624e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106251:	56                   	push   %esi
80106252:	ff 70 10             	push   0x10(%eax)
80106255:	68 bc 81 10 80       	push   $0x801081bc
8010625a:	e8 a1 a4 ff ff       	call   80100700 <cprintf>
    myproc()->killed = 1;
8010625f:	83 c4 20             	add    $0x20,%esp
80106262:	e8 49 df ff ff       	call   801041b0 <myproc>
80106267:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010626e:	e8 3d df ff ff       	call   801041b0 <myproc>
80106273:	85 c0                	test   %eax,%eax
80106275:	0f 85 18 ff ff ff    	jne    80106193 <trap+0x43>
8010627b:	e9 30 ff ff ff       	jmp    801061b0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106280:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106284:	0f 85 3e ff ff ff    	jne    801061c8 <trap+0x78>
    yield();
8010628a:	e8 a1 e5 ff ff       	call   80104830 <yield>
8010628f:	e9 34 ff ff ff       	jmp    801061c8 <trap+0x78>
80106294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106298:	8b 7b 38             	mov    0x38(%ebx),%edi
8010629b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010629f:	e8 ec de ff ff       	call   80104190 <cpuid>
801062a4:	57                   	push   %edi
801062a5:	56                   	push   %esi
801062a6:	50                   	push   %eax
801062a7:	68 64 81 10 80       	push   $0x80108164
801062ac:	e8 4f a4 ff ff       	call   80100700 <cprintf>
    lapiceoi();
801062b1:	e8 9a ce ff ff       	call   80103150 <lapiceoi>
    break;
801062b6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062b9:	e8 f2 de ff ff       	call   801041b0 <myproc>
801062be:	85 c0                	test   %eax,%eax
801062c0:	0f 85 cd fe ff ff    	jne    80106193 <trap+0x43>
801062c6:	e9 e5 fe ff ff       	jmp    801061b0 <trap+0x60>
801062cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062cf:	90                   	nop
    if(myproc()->killed)
801062d0:	e8 db de ff ff       	call   801041b0 <myproc>
801062d5:	8b 70 24             	mov    0x24(%eax),%esi
801062d8:	85 f6                	test   %esi,%esi
801062da:	0f 85 c8 00 00 00    	jne    801063a8 <trap+0x258>
    myproc()->tf = tf;
801062e0:	e8 cb de ff ff       	call   801041b0 <myproc>
801062e5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801062e8:	e8 b3 ef ff ff       	call   801052a0 <syscall>
    if(myproc()->killed)
801062ed:	e8 be de ff ff       	call   801041b0 <myproc>
801062f2:	8b 48 24             	mov    0x24(%eax),%ecx
801062f5:	85 c9                	test   %ecx,%ecx
801062f7:	0f 84 f1 fe ff ff    	je     801061ee <trap+0x9e>
}
801062fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106300:	5b                   	pop    %ebx
80106301:	5e                   	pop    %esi
80106302:	5f                   	pop    %edi
80106303:	5d                   	pop    %ebp
      exit();
80106304:	e9 c7 e2 ff ff       	jmp    801045d0 <exit>
80106309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106310:	e8 3b 02 00 00       	call   80106550 <uartintr>
    lapiceoi();
80106315:	e8 36 ce ff ff       	call   80103150 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010631a:	e8 91 de ff ff       	call   801041b0 <myproc>
8010631f:	85 c0                	test   %eax,%eax
80106321:	0f 85 6c fe ff ff    	jne    80106193 <trap+0x43>
80106327:	e9 84 fe ff ff       	jmp    801061b0 <trap+0x60>
8010632c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106330:	e8 db cc ff ff       	call   80103010 <kbdintr>
    lapiceoi();
80106335:	e8 16 ce ff ff       	call   80103150 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010633a:	e8 71 de ff ff       	call   801041b0 <myproc>
8010633f:	85 c0                	test   %eax,%eax
80106341:	0f 85 4c fe ff ff    	jne    80106193 <trap+0x43>
80106347:	e9 64 fe ff ff       	jmp    801061b0 <trap+0x60>
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106350:	e8 3b de ff ff       	call   80104190 <cpuid>
80106355:	85 c0                	test   %eax,%eax
80106357:	0f 85 28 fe ff ff    	jne    80106185 <trap+0x35>
      acquire(&tickslock);
8010635d:	83 ec 0c             	sub    $0xc,%esp
80106360:	68 00 57 11 80       	push   $0x80115700
80106365:	e8 76 ea ff ff       	call   80104de0 <acquire>
      wakeup(&ticks);
8010636a:	c7 04 24 e0 56 11 80 	movl   $0x801156e0,(%esp)
      ticks++;
80106371:	83 05 e0 56 11 80 01 	addl   $0x1,0x801156e0
      wakeup(&ticks);
80106378:	e8 c3 e5 ff ff       	call   80104940 <wakeup>
      release(&tickslock);
8010637d:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80106384:	e8 f7 e9 ff ff       	call   80104d80 <release>
80106389:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010638c:	e9 f4 fd ff ff       	jmp    80106185 <trap+0x35>
80106391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106398:	e8 33 e2 ff ff       	call   801045d0 <exit>
8010639d:	e9 0e fe ff ff       	jmp    801061b0 <trap+0x60>
801063a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801063a8:	e8 23 e2 ff ff       	call   801045d0 <exit>
801063ad:	e9 2e ff ff ff       	jmp    801062e0 <trap+0x190>
801063b2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063b5:	e8 d6 dd ff ff       	call   80104190 <cpuid>
801063ba:	83 ec 0c             	sub    $0xc,%esp
801063bd:	56                   	push   %esi
801063be:	57                   	push   %edi
801063bf:	50                   	push   %eax
801063c0:	ff 73 30             	push   0x30(%ebx)
801063c3:	68 88 81 10 80       	push   $0x80108188
801063c8:	e8 33 a3 ff ff       	call   80100700 <cprintf>
      panic("trap");
801063cd:	83 c4 14             	add    $0x14,%esp
801063d0:	68 5e 81 10 80       	push   $0x8010815e
801063d5:	e8 a6 9f ff ff       	call   80100380 <panic>
801063da:	66 90                	xchg   %ax,%ax
801063dc:	66 90                	xchg   %ax,%ax
801063de:	66 90                	xchg   %ax,%ax

801063e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801063e0:	a1 40 5f 11 80       	mov    0x80115f40,%eax
801063e5:	85 c0                	test   %eax,%eax
801063e7:	74 17                	je     80106400 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063e9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063ee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063ef:	a8 01                	test   $0x1,%al
801063f1:	74 0d                	je     80106400 <uartgetc+0x20>
801063f3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063f8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063f9:	0f b6 c0             	movzbl %al,%eax
801063fc:	c3                   	ret    
801063fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106405:	c3                   	ret    
80106406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640d:	8d 76 00             	lea    0x0(%esi),%esi

80106410 <uartinit>:
{
80106410:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106411:	31 c9                	xor    %ecx,%ecx
80106413:	89 c8                	mov    %ecx,%eax
80106415:	89 e5                	mov    %esp,%ebp
80106417:	57                   	push   %edi
80106418:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010641d:	56                   	push   %esi
8010641e:	89 fa                	mov    %edi,%edx
80106420:	53                   	push   %ebx
80106421:	83 ec 1c             	sub    $0x1c,%esp
80106424:	ee                   	out    %al,(%dx)
80106425:	be fb 03 00 00       	mov    $0x3fb,%esi
8010642a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010642f:	89 f2                	mov    %esi,%edx
80106431:	ee                   	out    %al,(%dx)
80106432:	b8 0c 00 00 00       	mov    $0xc,%eax
80106437:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010643c:	ee                   	out    %al,(%dx)
8010643d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106442:	89 c8                	mov    %ecx,%eax
80106444:	89 da                	mov    %ebx,%edx
80106446:	ee                   	out    %al,(%dx)
80106447:	b8 03 00 00 00       	mov    $0x3,%eax
8010644c:	89 f2                	mov    %esi,%edx
8010644e:	ee                   	out    %al,(%dx)
8010644f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106454:	89 c8                	mov    %ecx,%eax
80106456:	ee                   	out    %al,(%dx)
80106457:	b8 01 00 00 00       	mov    $0x1,%eax
8010645c:	89 da                	mov    %ebx,%edx
8010645e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106464:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106465:	3c ff                	cmp    $0xff,%al
80106467:	74 78                	je     801064e1 <uartinit+0xd1>
  uart = 1;
80106469:	c7 05 40 5f 11 80 01 	movl   $0x1,0x80115f40
80106470:	00 00 00 
80106473:	89 fa                	mov    %edi,%edx
80106475:	ec                   	in     (%dx),%al
80106476:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010647b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010647c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010647f:	bf 80 82 10 80       	mov    $0x80108280,%edi
80106484:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106489:	6a 00                	push   $0x0
8010648b:	6a 04                	push   $0x4
8010648d:	e8 2e c8 ff ff       	call   80102cc0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106492:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106496:	83 c4 10             	add    $0x10,%esp
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801064a0:	a1 40 5f 11 80       	mov    0x80115f40,%eax
801064a5:	bb 80 00 00 00       	mov    $0x80,%ebx
801064aa:	85 c0                	test   %eax,%eax
801064ac:	75 14                	jne    801064c2 <uartinit+0xb2>
801064ae:	eb 23                	jmp    801064d3 <uartinit+0xc3>
    microdelay(10);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	6a 0a                	push   $0xa
801064b5:	e8 b6 cc ff ff       	call   80103170 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	83 eb 01             	sub    $0x1,%ebx
801064c0:	74 07                	je     801064c9 <uartinit+0xb9>
801064c2:	89 f2                	mov    %esi,%edx
801064c4:	ec                   	in     (%dx),%al
801064c5:	a8 20                	test   $0x20,%al
801064c7:	74 e7                	je     801064b0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064c9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801064cd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064d2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801064d3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801064d7:	83 c7 01             	add    $0x1,%edi
801064da:	88 45 e7             	mov    %al,-0x19(%ebp)
801064dd:	84 c0                	test   %al,%al
801064df:	75 bf                	jne    801064a0 <uartinit+0x90>
}
801064e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e4:	5b                   	pop    %ebx
801064e5:	5e                   	pop    %esi
801064e6:	5f                   	pop    %edi
801064e7:	5d                   	pop    %ebp
801064e8:	c3                   	ret    
801064e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064f0 <uartputc>:
  if(!uart)
801064f0:	a1 40 5f 11 80       	mov    0x80115f40,%eax
801064f5:	85 c0                	test   %eax,%eax
801064f7:	74 47                	je     80106540 <uartputc+0x50>
{
801064f9:	55                   	push   %ebp
801064fa:	89 e5                	mov    %esp,%ebp
801064fc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106502:	53                   	push   %ebx
80106503:	bb 80 00 00 00       	mov    $0x80,%ebx
80106508:	eb 18                	jmp    80106522 <uartputc+0x32>
8010650a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	6a 0a                	push   $0xa
80106515:	e8 56 cc ff ff       	call   80103170 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	83 eb 01             	sub    $0x1,%ebx
80106520:	74 07                	je     80106529 <uartputc+0x39>
80106522:	89 f2                	mov    %esi,%edx
80106524:	ec                   	in     (%dx),%al
80106525:	a8 20                	test   $0x20,%al
80106527:	74 e7                	je     80106510 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106529:	8b 45 08             	mov    0x8(%ebp),%eax
8010652c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106531:	ee                   	out    %al,(%dx)
}
80106532:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106535:	5b                   	pop    %ebx
80106536:	5e                   	pop    %esi
80106537:	5d                   	pop    %ebp
80106538:	c3                   	ret    
80106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106540:	c3                   	ret    
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010654f:	90                   	nop

80106550 <uartintr>:

void
uartintr(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106556:	68 e0 63 10 80       	push   $0x801063e0
8010655b:	e8 90 a8 ff ff       	call   80100df0 <consoleintr>
}
80106560:	83 c4 10             	add    $0x10,%esp
80106563:	c9                   	leave  
80106564:	c3                   	ret    

80106565 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $0
80106567:	6a 00                	push   $0x0
  jmp alltraps
80106569:	e9 0c fb ff ff       	jmp    8010607a <alltraps>

8010656e <vector1>:
.globl vector1
vector1:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $1
80106570:	6a 01                	push   $0x1
  jmp alltraps
80106572:	e9 03 fb ff ff       	jmp    8010607a <alltraps>

80106577 <vector2>:
.globl vector2
vector2:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $2
80106579:	6a 02                	push   $0x2
  jmp alltraps
8010657b:	e9 fa fa ff ff       	jmp    8010607a <alltraps>

80106580 <vector3>:
.globl vector3
vector3:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $3
80106582:	6a 03                	push   $0x3
  jmp alltraps
80106584:	e9 f1 fa ff ff       	jmp    8010607a <alltraps>

80106589 <vector4>:
.globl vector4
vector4:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $4
8010658b:	6a 04                	push   $0x4
  jmp alltraps
8010658d:	e9 e8 fa ff ff       	jmp    8010607a <alltraps>

80106592 <vector5>:
.globl vector5
vector5:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $5
80106594:	6a 05                	push   $0x5
  jmp alltraps
80106596:	e9 df fa ff ff       	jmp    8010607a <alltraps>

8010659b <vector6>:
.globl vector6
vector6:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $6
8010659d:	6a 06                	push   $0x6
  jmp alltraps
8010659f:	e9 d6 fa ff ff       	jmp    8010607a <alltraps>

801065a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $7
801065a6:	6a 07                	push   $0x7
  jmp alltraps
801065a8:	e9 cd fa ff ff       	jmp    8010607a <alltraps>

801065ad <vector8>:
.globl vector8
vector8:
  pushl $8
801065ad:	6a 08                	push   $0x8
  jmp alltraps
801065af:	e9 c6 fa ff ff       	jmp    8010607a <alltraps>

801065b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $9
801065b6:	6a 09                	push   $0x9
  jmp alltraps
801065b8:	e9 bd fa ff ff       	jmp    8010607a <alltraps>

801065bd <vector10>:
.globl vector10
vector10:
  pushl $10
801065bd:	6a 0a                	push   $0xa
  jmp alltraps
801065bf:	e9 b6 fa ff ff       	jmp    8010607a <alltraps>

801065c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801065c4:	6a 0b                	push   $0xb
  jmp alltraps
801065c6:	e9 af fa ff ff       	jmp    8010607a <alltraps>

801065cb <vector12>:
.globl vector12
vector12:
  pushl $12
801065cb:	6a 0c                	push   $0xc
  jmp alltraps
801065cd:	e9 a8 fa ff ff       	jmp    8010607a <alltraps>

801065d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801065d2:	6a 0d                	push   $0xd
  jmp alltraps
801065d4:	e9 a1 fa ff ff       	jmp    8010607a <alltraps>

801065d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801065d9:	6a 0e                	push   $0xe
  jmp alltraps
801065db:	e9 9a fa ff ff       	jmp    8010607a <alltraps>

801065e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $15
801065e2:	6a 0f                	push   $0xf
  jmp alltraps
801065e4:	e9 91 fa ff ff       	jmp    8010607a <alltraps>

801065e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $16
801065eb:	6a 10                	push   $0x10
  jmp alltraps
801065ed:	e9 88 fa ff ff       	jmp    8010607a <alltraps>

801065f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801065f2:	6a 11                	push   $0x11
  jmp alltraps
801065f4:	e9 81 fa ff ff       	jmp    8010607a <alltraps>

801065f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $18
801065fb:	6a 12                	push   $0x12
  jmp alltraps
801065fd:	e9 78 fa ff ff       	jmp    8010607a <alltraps>

80106602 <vector19>:
.globl vector19
vector19:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $19
80106604:	6a 13                	push   $0x13
  jmp alltraps
80106606:	e9 6f fa ff ff       	jmp    8010607a <alltraps>

8010660b <vector20>:
.globl vector20
vector20:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $20
8010660d:	6a 14                	push   $0x14
  jmp alltraps
8010660f:	e9 66 fa ff ff       	jmp    8010607a <alltraps>

80106614 <vector21>:
.globl vector21
vector21:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $21
80106616:	6a 15                	push   $0x15
  jmp alltraps
80106618:	e9 5d fa ff ff       	jmp    8010607a <alltraps>

8010661d <vector22>:
.globl vector22
vector22:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $22
8010661f:	6a 16                	push   $0x16
  jmp alltraps
80106621:	e9 54 fa ff ff       	jmp    8010607a <alltraps>

80106626 <vector23>:
.globl vector23
vector23:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $23
80106628:	6a 17                	push   $0x17
  jmp alltraps
8010662a:	e9 4b fa ff ff       	jmp    8010607a <alltraps>

8010662f <vector24>:
.globl vector24
vector24:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $24
80106631:	6a 18                	push   $0x18
  jmp alltraps
80106633:	e9 42 fa ff ff       	jmp    8010607a <alltraps>

80106638 <vector25>:
.globl vector25
vector25:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $25
8010663a:	6a 19                	push   $0x19
  jmp alltraps
8010663c:	e9 39 fa ff ff       	jmp    8010607a <alltraps>

80106641 <vector26>:
.globl vector26
vector26:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $26
80106643:	6a 1a                	push   $0x1a
  jmp alltraps
80106645:	e9 30 fa ff ff       	jmp    8010607a <alltraps>

8010664a <vector27>:
.globl vector27
vector27:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $27
8010664c:	6a 1b                	push   $0x1b
  jmp alltraps
8010664e:	e9 27 fa ff ff       	jmp    8010607a <alltraps>

80106653 <vector28>:
.globl vector28
vector28:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $28
80106655:	6a 1c                	push   $0x1c
  jmp alltraps
80106657:	e9 1e fa ff ff       	jmp    8010607a <alltraps>

8010665c <vector29>:
.globl vector29
vector29:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $29
8010665e:	6a 1d                	push   $0x1d
  jmp alltraps
80106660:	e9 15 fa ff ff       	jmp    8010607a <alltraps>

80106665 <vector30>:
.globl vector30
vector30:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $30
80106667:	6a 1e                	push   $0x1e
  jmp alltraps
80106669:	e9 0c fa ff ff       	jmp    8010607a <alltraps>

8010666e <vector31>:
.globl vector31
vector31:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $31
80106670:	6a 1f                	push   $0x1f
  jmp alltraps
80106672:	e9 03 fa ff ff       	jmp    8010607a <alltraps>

80106677 <vector32>:
.globl vector32
vector32:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $32
80106679:	6a 20                	push   $0x20
  jmp alltraps
8010667b:	e9 fa f9 ff ff       	jmp    8010607a <alltraps>

80106680 <vector33>:
.globl vector33
vector33:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $33
80106682:	6a 21                	push   $0x21
  jmp alltraps
80106684:	e9 f1 f9 ff ff       	jmp    8010607a <alltraps>

80106689 <vector34>:
.globl vector34
vector34:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $34
8010668b:	6a 22                	push   $0x22
  jmp alltraps
8010668d:	e9 e8 f9 ff ff       	jmp    8010607a <alltraps>

80106692 <vector35>:
.globl vector35
vector35:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $35
80106694:	6a 23                	push   $0x23
  jmp alltraps
80106696:	e9 df f9 ff ff       	jmp    8010607a <alltraps>

8010669b <vector36>:
.globl vector36
vector36:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $36
8010669d:	6a 24                	push   $0x24
  jmp alltraps
8010669f:	e9 d6 f9 ff ff       	jmp    8010607a <alltraps>

801066a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $37
801066a6:	6a 25                	push   $0x25
  jmp alltraps
801066a8:	e9 cd f9 ff ff       	jmp    8010607a <alltraps>

801066ad <vector38>:
.globl vector38
vector38:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $38
801066af:	6a 26                	push   $0x26
  jmp alltraps
801066b1:	e9 c4 f9 ff ff       	jmp    8010607a <alltraps>

801066b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $39
801066b8:	6a 27                	push   $0x27
  jmp alltraps
801066ba:	e9 bb f9 ff ff       	jmp    8010607a <alltraps>

801066bf <vector40>:
.globl vector40
vector40:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $40
801066c1:	6a 28                	push   $0x28
  jmp alltraps
801066c3:	e9 b2 f9 ff ff       	jmp    8010607a <alltraps>

801066c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $41
801066ca:	6a 29                	push   $0x29
  jmp alltraps
801066cc:	e9 a9 f9 ff ff       	jmp    8010607a <alltraps>

801066d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $42
801066d3:	6a 2a                	push   $0x2a
  jmp alltraps
801066d5:	e9 a0 f9 ff ff       	jmp    8010607a <alltraps>

801066da <vector43>:
.globl vector43
vector43:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $43
801066dc:	6a 2b                	push   $0x2b
  jmp alltraps
801066de:	e9 97 f9 ff ff       	jmp    8010607a <alltraps>

801066e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $44
801066e5:	6a 2c                	push   $0x2c
  jmp alltraps
801066e7:	e9 8e f9 ff ff       	jmp    8010607a <alltraps>

801066ec <vector45>:
.globl vector45
vector45:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $45
801066ee:	6a 2d                	push   $0x2d
  jmp alltraps
801066f0:	e9 85 f9 ff ff       	jmp    8010607a <alltraps>

801066f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $46
801066f7:	6a 2e                	push   $0x2e
  jmp alltraps
801066f9:	e9 7c f9 ff ff       	jmp    8010607a <alltraps>

801066fe <vector47>:
.globl vector47
vector47:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $47
80106700:	6a 2f                	push   $0x2f
  jmp alltraps
80106702:	e9 73 f9 ff ff       	jmp    8010607a <alltraps>

80106707 <vector48>:
.globl vector48
vector48:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $48
80106709:	6a 30                	push   $0x30
  jmp alltraps
8010670b:	e9 6a f9 ff ff       	jmp    8010607a <alltraps>

80106710 <vector49>:
.globl vector49
vector49:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $49
80106712:	6a 31                	push   $0x31
  jmp alltraps
80106714:	e9 61 f9 ff ff       	jmp    8010607a <alltraps>

80106719 <vector50>:
.globl vector50
vector50:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $50
8010671b:	6a 32                	push   $0x32
  jmp alltraps
8010671d:	e9 58 f9 ff ff       	jmp    8010607a <alltraps>

80106722 <vector51>:
.globl vector51
vector51:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $51
80106724:	6a 33                	push   $0x33
  jmp alltraps
80106726:	e9 4f f9 ff ff       	jmp    8010607a <alltraps>

8010672b <vector52>:
.globl vector52
vector52:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $52
8010672d:	6a 34                	push   $0x34
  jmp alltraps
8010672f:	e9 46 f9 ff ff       	jmp    8010607a <alltraps>

80106734 <vector53>:
.globl vector53
vector53:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $53
80106736:	6a 35                	push   $0x35
  jmp alltraps
80106738:	e9 3d f9 ff ff       	jmp    8010607a <alltraps>

8010673d <vector54>:
.globl vector54
vector54:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $54
8010673f:	6a 36                	push   $0x36
  jmp alltraps
80106741:	e9 34 f9 ff ff       	jmp    8010607a <alltraps>

80106746 <vector55>:
.globl vector55
vector55:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $55
80106748:	6a 37                	push   $0x37
  jmp alltraps
8010674a:	e9 2b f9 ff ff       	jmp    8010607a <alltraps>

8010674f <vector56>:
.globl vector56
vector56:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $56
80106751:	6a 38                	push   $0x38
  jmp alltraps
80106753:	e9 22 f9 ff ff       	jmp    8010607a <alltraps>

80106758 <vector57>:
.globl vector57
vector57:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $57
8010675a:	6a 39                	push   $0x39
  jmp alltraps
8010675c:	e9 19 f9 ff ff       	jmp    8010607a <alltraps>

80106761 <vector58>:
.globl vector58
vector58:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $58
80106763:	6a 3a                	push   $0x3a
  jmp alltraps
80106765:	e9 10 f9 ff ff       	jmp    8010607a <alltraps>

8010676a <vector59>:
.globl vector59
vector59:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $59
8010676c:	6a 3b                	push   $0x3b
  jmp alltraps
8010676e:	e9 07 f9 ff ff       	jmp    8010607a <alltraps>

80106773 <vector60>:
.globl vector60
vector60:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $60
80106775:	6a 3c                	push   $0x3c
  jmp alltraps
80106777:	e9 fe f8 ff ff       	jmp    8010607a <alltraps>

8010677c <vector61>:
.globl vector61
vector61:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $61
8010677e:	6a 3d                	push   $0x3d
  jmp alltraps
80106780:	e9 f5 f8 ff ff       	jmp    8010607a <alltraps>

80106785 <vector62>:
.globl vector62
vector62:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $62
80106787:	6a 3e                	push   $0x3e
  jmp alltraps
80106789:	e9 ec f8 ff ff       	jmp    8010607a <alltraps>

8010678e <vector63>:
.globl vector63
vector63:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $63
80106790:	6a 3f                	push   $0x3f
  jmp alltraps
80106792:	e9 e3 f8 ff ff       	jmp    8010607a <alltraps>

80106797 <vector64>:
.globl vector64
vector64:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $64
80106799:	6a 40                	push   $0x40
  jmp alltraps
8010679b:	e9 da f8 ff ff       	jmp    8010607a <alltraps>

801067a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $65
801067a2:	6a 41                	push   $0x41
  jmp alltraps
801067a4:	e9 d1 f8 ff ff       	jmp    8010607a <alltraps>

801067a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $66
801067ab:	6a 42                	push   $0x42
  jmp alltraps
801067ad:	e9 c8 f8 ff ff       	jmp    8010607a <alltraps>

801067b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $67
801067b4:	6a 43                	push   $0x43
  jmp alltraps
801067b6:	e9 bf f8 ff ff       	jmp    8010607a <alltraps>

801067bb <vector68>:
.globl vector68
vector68:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $68
801067bd:	6a 44                	push   $0x44
  jmp alltraps
801067bf:	e9 b6 f8 ff ff       	jmp    8010607a <alltraps>

801067c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $69
801067c6:	6a 45                	push   $0x45
  jmp alltraps
801067c8:	e9 ad f8 ff ff       	jmp    8010607a <alltraps>

801067cd <vector70>:
.globl vector70
vector70:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $70
801067cf:	6a 46                	push   $0x46
  jmp alltraps
801067d1:	e9 a4 f8 ff ff       	jmp    8010607a <alltraps>

801067d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $71
801067d8:	6a 47                	push   $0x47
  jmp alltraps
801067da:	e9 9b f8 ff ff       	jmp    8010607a <alltraps>

801067df <vector72>:
.globl vector72
vector72:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $72
801067e1:	6a 48                	push   $0x48
  jmp alltraps
801067e3:	e9 92 f8 ff ff       	jmp    8010607a <alltraps>

801067e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $73
801067ea:	6a 49                	push   $0x49
  jmp alltraps
801067ec:	e9 89 f8 ff ff       	jmp    8010607a <alltraps>

801067f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $74
801067f3:	6a 4a                	push   $0x4a
  jmp alltraps
801067f5:	e9 80 f8 ff ff       	jmp    8010607a <alltraps>

801067fa <vector75>:
.globl vector75
vector75:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $75
801067fc:	6a 4b                	push   $0x4b
  jmp alltraps
801067fe:	e9 77 f8 ff ff       	jmp    8010607a <alltraps>

80106803 <vector76>:
.globl vector76
vector76:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $76
80106805:	6a 4c                	push   $0x4c
  jmp alltraps
80106807:	e9 6e f8 ff ff       	jmp    8010607a <alltraps>

8010680c <vector77>:
.globl vector77
vector77:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $77
8010680e:	6a 4d                	push   $0x4d
  jmp alltraps
80106810:	e9 65 f8 ff ff       	jmp    8010607a <alltraps>

80106815 <vector78>:
.globl vector78
vector78:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $78
80106817:	6a 4e                	push   $0x4e
  jmp alltraps
80106819:	e9 5c f8 ff ff       	jmp    8010607a <alltraps>

8010681e <vector79>:
.globl vector79
vector79:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $79
80106820:	6a 4f                	push   $0x4f
  jmp alltraps
80106822:	e9 53 f8 ff ff       	jmp    8010607a <alltraps>

80106827 <vector80>:
.globl vector80
vector80:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $80
80106829:	6a 50                	push   $0x50
  jmp alltraps
8010682b:	e9 4a f8 ff ff       	jmp    8010607a <alltraps>

80106830 <vector81>:
.globl vector81
vector81:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $81
80106832:	6a 51                	push   $0x51
  jmp alltraps
80106834:	e9 41 f8 ff ff       	jmp    8010607a <alltraps>

80106839 <vector82>:
.globl vector82
vector82:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $82
8010683b:	6a 52                	push   $0x52
  jmp alltraps
8010683d:	e9 38 f8 ff ff       	jmp    8010607a <alltraps>

80106842 <vector83>:
.globl vector83
vector83:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $83
80106844:	6a 53                	push   $0x53
  jmp alltraps
80106846:	e9 2f f8 ff ff       	jmp    8010607a <alltraps>

8010684b <vector84>:
.globl vector84
vector84:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $84
8010684d:	6a 54                	push   $0x54
  jmp alltraps
8010684f:	e9 26 f8 ff ff       	jmp    8010607a <alltraps>

80106854 <vector85>:
.globl vector85
vector85:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $85
80106856:	6a 55                	push   $0x55
  jmp alltraps
80106858:	e9 1d f8 ff ff       	jmp    8010607a <alltraps>

8010685d <vector86>:
.globl vector86
vector86:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $86
8010685f:	6a 56                	push   $0x56
  jmp alltraps
80106861:	e9 14 f8 ff ff       	jmp    8010607a <alltraps>

80106866 <vector87>:
.globl vector87
vector87:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $87
80106868:	6a 57                	push   $0x57
  jmp alltraps
8010686a:	e9 0b f8 ff ff       	jmp    8010607a <alltraps>

8010686f <vector88>:
.globl vector88
vector88:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $88
80106871:	6a 58                	push   $0x58
  jmp alltraps
80106873:	e9 02 f8 ff ff       	jmp    8010607a <alltraps>

80106878 <vector89>:
.globl vector89
vector89:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $89
8010687a:	6a 59                	push   $0x59
  jmp alltraps
8010687c:	e9 f9 f7 ff ff       	jmp    8010607a <alltraps>

80106881 <vector90>:
.globl vector90
vector90:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $90
80106883:	6a 5a                	push   $0x5a
  jmp alltraps
80106885:	e9 f0 f7 ff ff       	jmp    8010607a <alltraps>

8010688a <vector91>:
.globl vector91
vector91:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $91
8010688c:	6a 5b                	push   $0x5b
  jmp alltraps
8010688e:	e9 e7 f7 ff ff       	jmp    8010607a <alltraps>

80106893 <vector92>:
.globl vector92
vector92:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $92
80106895:	6a 5c                	push   $0x5c
  jmp alltraps
80106897:	e9 de f7 ff ff       	jmp    8010607a <alltraps>

8010689c <vector93>:
.globl vector93
vector93:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $93
8010689e:	6a 5d                	push   $0x5d
  jmp alltraps
801068a0:	e9 d5 f7 ff ff       	jmp    8010607a <alltraps>

801068a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $94
801068a7:	6a 5e                	push   $0x5e
  jmp alltraps
801068a9:	e9 cc f7 ff ff       	jmp    8010607a <alltraps>

801068ae <vector95>:
.globl vector95
vector95:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $95
801068b0:	6a 5f                	push   $0x5f
  jmp alltraps
801068b2:	e9 c3 f7 ff ff       	jmp    8010607a <alltraps>

801068b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $96
801068b9:	6a 60                	push   $0x60
  jmp alltraps
801068bb:	e9 ba f7 ff ff       	jmp    8010607a <alltraps>

801068c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $97
801068c2:	6a 61                	push   $0x61
  jmp alltraps
801068c4:	e9 b1 f7 ff ff       	jmp    8010607a <alltraps>

801068c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $98
801068cb:	6a 62                	push   $0x62
  jmp alltraps
801068cd:	e9 a8 f7 ff ff       	jmp    8010607a <alltraps>

801068d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $99
801068d4:	6a 63                	push   $0x63
  jmp alltraps
801068d6:	e9 9f f7 ff ff       	jmp    8010607a <alltraps>

801068db <vector100>:
.globl vector100
vector100:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $100
801068dd:	6a 64                	push   $0x64
  jmp alltraps
801068df:	e9 96 f7 ff ff       	jmp    8010607a <alltraps>

801068e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $101
801068e6:	6a 65                	push   $0x65
  jmp alltraps
801068e8:	e9 8d f7 ff ff       	jmp    8010607a <alltraps>

801068ed <vector102>:
.globl vector102
vector102:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $102
801068ef:	6a 66                	push   $0x66
  jmp alltraps
801068f1:	e9 84 f7 ff ff       	jmp    8010607a <alltraps>

801068f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $103
801068f8:	6a 67                	push   $0x67
  jmp alltraps
801068fa:	e9 7b f7 ff ff       	jmp    8010607a <alltraps>

801068ff <vector104>:
.globl vector104
vector104:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $104
80106901:	6a 68                	push   $0x68
  jmp alltraps
80106903:	e9 72 f7 ff ff       	jmp    8010607a <alltraps>

80106908 <vector105>:
.globl vector105
vector105:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $105
8010690a:	6a 69                	push   $0x69
  jmp alltraps
8010690c:	e9 69 f7 ff ff       	jmp    8010607a <alltraps>

80106911 <vector106>:
.globl vector106
vector106:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $106
80106913:	6a 6a                	push   $0x6a
  jmp alltraps
80106915:	e9 60 f7 ff ff       	jmp    8010607a <alltraps>

8010691a <vector107>:
.globl vector107
vector107:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $107
8010691c:	6a 6b                	push   $0x6b
  jmp alltraps
8010691e:	e9 57 f7 ff ff       	jmp    8010607a <alltraps>

80106923 <vector108>:
.globl vector108
vector108:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $108
80106925:	6a 6c                	push   $0x6c
  jmp alltraps
80106927:	e9 4e f7 ff ff       	jmp    8010607a <alltraps>

8010692c <vector109>:
.globl vector109
vector109:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $109
8010692e:	6a 6d                	push   $0x6d
  jmp alltraps
80106930:	e9 45 f7 ff ff       	jmp    8010607a <alltraps>

80106935 <vector110>:
.globl vector110
vector110:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $110
80106937:	6a 6e                	push   $0x6e
  jmp alltraps
80106939:	e9 3c f7 ff ff       	jmp    8010607a <alltraps>

8010693e <vector111>:
.globl vector111
vector111:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $111
80106940:	6a 6f                	push   $0x6f
  jmp alltraps
80106942:	e9 33 f7 ff ff       	jmp    8010607a <alltraps>

80106947 <vector112>:
.globl vector112
vector112:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $112
80106949:	6a 70                	push   $0x70
  jmp alltraps
8010694b:	e9 2a f7 ff ff       	jmp    8010607a <alltraps>

80106950 <vector113>:
.globl vector113
vector113:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $113
80106952:	6a 71                	push   $0x71
  jmp alltraps
80106954:	e9 21 f7 ff ff       	jmp    8010607a <alltraps>

80106959 <vector114>:
.globl vector114
vector114:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $114
8010695b:	6a 72                	push   $0x72
  jmp alltraps
8010695d:	e9 18 f7 ff ff       	jmp    8010607a <alltraps>

80106962 <vector115>:
.globl vector115
vector115:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $115
80106964:	6a 73                	push   $0x73
  jmp alltraps
80106966:	e9 0f f7 ff ff       	jmp    8010607a <alltraps>

8010696b <vector116>:
.globl vector116
vector116:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $116
8010696d:	6a 74                	push   $0x74
  jmp alltraps
8010696f:	e9 06 f7 ff ff       	jmp    8010607a <alltraps>

80106974 <vector117>:
.globl vector117
vector117:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $117
80106976:	6a 75                	push   $0x75
  jmp alltraps
80106978:	e9 fd f6 ff ff       	jmp    8010607a <alltraps>

8010697d <vector118>:
.globl vector118
vector118:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $118
8010697f:	6a 76                	push   $0x76
  jmp alltraps
80106981:	e9 f4 f6 ff ff       	jmp    8010607a <alltraps>

80106986 <vector119>:
.globl vector119
vector119:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $119
80106988:	6a 77                	push   $0x77
  jmp alltraps
8010698a:	e9 eb f6 ff ff       	jmp    8010607a <alltraps>

8010698f <vector120>:
.globl vector120
vector120:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $120
80106991:	6a 78                	push   $0x78
  jmp alltraps
80106993:	e9 e2 f6 ff ff       	jmp    8010607a <alltraps>

80106998 <vector121>:
.globl vector121
vector121:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $121
8010699a:	6a 79                	push   $0x79
  jmp alltraps
8010699c:	e9 d9 f6 ff ff       	jmp    8010607a <alltraps>

801069a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $122
801069a3:	6a 7a                	push   $0x7a
  jmp alltraps
801069a5:	e9 d0 f6 ff ff       	jmp    8010607a <alltraps>

801069aa <vector123>:
.globl vector123
vector123:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $123
801069ac:	6a 7b                	push   $0x7b
  jmp alltraps
801069ae:	e9 c7 f6 ff ff       	jmp    8010607a <alltraps>

801069b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $124
801069b5:	6a 7c                	push   $0x7c
  jmp alltraps
801069b7:	e9 be f6 ff ff       	jmp    8010607a <alltraps>

801069bc <vector125>:
.globl vector125
vector125:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $125
801069be:	6a 7d                	push   $0x7d
  jmp alltraps
801069c0:	e9 b5 f6 ff ff       	jmp    8010607a <alltraps>

801069c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $126
801069c7:	6a 7e                	push   $0x7e
  jmp alltraps
801069c9:	e9 ac f6 ff ff       	jmp    8010607a <alltraps>

801069ce <vector127>:
.globl vector127
vector127:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $127
801069d0:	6a 7f                	push   $0x7f
  jmp alltraps
801069d2:	e9 a3 f6 ff ff       	jmp    8010607a <alltraps>

801069d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $128
801069d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069de:	e9 97 f6 ff ff       	jmp    8010607a <alltraps>

801069e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $129
801069e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ea:	e9 8b f6 ff ff       	jmp    8010607a <alltraps>

801069ef <vector130>:
.globl vector130
vector130:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $130
801069f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069f6:	e9 7f f6 ff ff       	jmp    8010607a <alltraps>

801069fb <vector131>:
.globl vector131
vector131:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $131
801069fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a02:	e9 73 f6 ff ff       	jmp    8010607a <alltraps>

80106a07 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $132
80106a09:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a0e:	e9 67 f6 ff ff       	jmp    8010607a <alltraps>

80106a13 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $133
80106a15:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a1a:	e9 5b f6 ff ff       	jmp    8010607a <alltraps>

80106a1f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $134
80106a21:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a26:	e9 4f f6 ff ff       	jmp    8010607a <alltraps>

80106a2b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $135
80106a2d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a32:	e9 43 f6 ff ff       	jmp    8010607a <alltraps>

80106a37 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $136
80106a39:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a3e:	e9 37 f6 ff ff       	jmp    8010607a <alltraps>

80106a43 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $137
80106a45:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a4a:	e9 2b f6 ff ff       	jmp    8010607a <alltraps>

80106a4f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $138
80106a51:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a56:	e9 1f f6 ff ff       	jmp    8010607a <alltraps>

80106a5b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $139
80106a5d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a62:	e9 13 f6 ff ff       	jmp    8010607a <alltraps>

80106a67 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $140
80106a69:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a6e:	e9 07 f6 ff ff       	jmp    8010607a <alltraps>

80106a73 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $141
80106a75:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a7a:	e9 fb f5 ff ff       	jmp    8010607a <alltraps>

80106a7f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $142
80106a81:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a86:	e9 ef f5 ff ff       	jmp    8010607a <alltraps>

80106a8b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $143
80106a8d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a92:	e9 e3 f5 ff ff       	jmp    8010607a <alltraps>

80106a97 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $144
80106a99:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a9e:	e9 d7 f5 ff ff       	jmp    8010607a <alltraps>

80106aa3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $145
80106aa5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aaa:	e9 cb f5 ff ff       	jmp    8010607a <alltraps>

80106aaf <vector146>:
.globl vector146
vector146:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $146
80106ab1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ab6:	e9 bf f5 ff ff       	jmp    8010607a <alltraps>

80106abb <vector147>:
.globl vector147
vector147:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $147
80106abd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ac2:	e9 b3 f5 ff ff       	jmp    8010607a <alltraps>

80106ac7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $148
80106ac9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ace:	e9 a7 f5 ff ff       	jmp    8010607a <alltraps>

80106ad3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $149
80106ad5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106ada:	e9 9b f5 ff ff       	jmp    8010607a <alltraps>

80106adf <vector150>:
.globl vector150
vector150:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $150
80106ae1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ae6:	e9 8f f5 ff ff       	jmp    8010607a <alltraps>

80106aeb <vector151>:
.globl vector151
vector151:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $151
80106aed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106af2:	e9 83 f5 ff ff       	jmp    8010607a <alltraps>

80106af7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $152
80106af9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106afe:	e9 77 f5 ff ff       	jmp    8010607a <alltraps>

80106b03 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $153
80106b05:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b0a:	e9 6b f5 ff ff       	jmp    8010607a <alltraps>

80106b0f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $154
80106b11:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b16:	e9 5f f5 ff ff       	jmp    8010607a <alltraps>

80106b1b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $155
80106b1d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b22:	e9 53 f5 ff ff       	jmp    8010607a <alltraps>

80106b27 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $156
80106b29:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b2e:	e9 47 f5 ff ff       	jmp    8010607a <alltraps>

80106b33 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $157
80106b35:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b3a:	e9 3b f5 ff ff       	jmp    8010607a <alltraps>

80106b3f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $158
80106b41:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b46:	e9 2f f5 ff ff       	jmp    8010607a <alltraps>

80106b4b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $159
80106b4d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b52:	e9 23 f5 ff ff       	jmp    8010607a <alltraps>

80106b57 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $160
80106b59:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b5e:	e9 17 f5 ff ff       	jmp    8010607a <alltraps>

80106b63 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $161
80106b65:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b6a:	e9 0b f5 ff ff       	jmp    8010607a <alltraps>

80106b6f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $162
80106b71:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b76:	e9 ff f4 ff ff       	jmp    8010607a <alltraps>

80106b7b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $163
80106b7d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b82:	e9 f3 f4 ff ff       	jmp    8010607a <alltraps>

80106b87 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $164
80106b89:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b8e:	e9 e7 f4 ff ff       	jmp    8010607a <alltraps>

80106b93 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $165
80106b95:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b9a:	e9 db f4 ff ff       	jmp    8010607a <alltraps>

80106b9f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $166
80106ba1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ba6:	e9 cf f4 ff ff       	jmp    8010607a <alltraps>

80106bab <vector167>:
.globl vector167
vector167:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $167
80106bad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bb2:	e9 c3 f4 ff ff       	jmp    8010607a <alltraps>

80106bb7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $168
80106bb9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bbe:	e9 b7 f4 ff ff       	jmp    8010607a <alltraps>

80106bc3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $169
80106bc5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bca:	e9 ab f4 ff ff       	jmp    8010607a <alltraps>

80106bcf <vector170>:
.globl vector170
vector170:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $170
80106bd1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bd6:	e9 9f f4 ff ff       	jmp    8010607a <alltraps>

80106bdb <vector171>:
.globl vector171
vector171:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $171
80106bdd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106be2:	e9 93 f4 ff ff       	jmp    8010607a <alltraps>

80106be7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $172
80106be9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bee:	e9 87 f4 ff ff       	jmp    8010607a <alltraps>

80106bf3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $173
80106bf5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bfa:	e9 7b f4 ff ff       	jmp    8010607a <alltraps>

80106bff <vector174>:
.globl vector174
vector174:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $174
80106c01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c06:	e9 6f f4 ff ff       	jmp    8010607a <alltraps>

80106c0b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $175
80106c0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c12:	e9 63 f4 ff ff       	jmp    8010607a <alltraps>

80106c17 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $176
80106c19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c1e:	e9 57 f4 ff ff       	jmp    8010607a <alltraps>

80106c23 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $177
80106c25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c2a:	e9 4b f4 ff ff       	jmp    8010607a <alltraps>

80106c2f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $178
80106c31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c36:	e9 3f f4 ff ff       	jmp    8010607a <alltraps>

80106c3b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $179
80106c3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c42:	e9 33 f4 ff ff       	jmp    8010607a <alltraps>

80106c47 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $180
80106c49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c4e:	e9 27 f4 ff ff       	jmp    8010607a <alltraps>

80106c53 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $181
80106c55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c5a:	e9 1b f4 ff ff       	jmp    8010607a <alltraps>

80106c5f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $182
80106c61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c66:	e9 0f f4 ff ff       	jmp    8010607a <alltraps>

80106c6b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $183
80106c6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c72:	e9 03 f4 ff ff       	jmp    8010607a <alltraps>

80106c77 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $184
80106c79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c7e:	e9 f7 f3 ff ff       	jmp    8010607a <alltraps>

80106c83 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $185
80106c85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c8a:	e9 eb f3 ff ff       	jmp    8010607a <alltraps>

80106c8f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $186
80106c91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c96:	e9 df f3 ff ff       	jmp    8010607a <alltraps>

80106c9b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $187
80106c9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ca2:	e9 d3 f3 ff ff       	jmp    8010607a <alltraps>

80106ca7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $188
80106ca9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cae:	e9 c7 f3 ff ff       	jmp    8010607a <alltraps>

80106cb3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $189
80106cb5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cba:	e9 bb f3 ff ff       	jmp    8010607a <alltraps>

80106cbf <vector190>:
.globl vector190
vector190:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $190
80106cc1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cc6:	e9 af f3 ff ff       	jmp    8010607a <alltraps>

80106ccb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $191
80106ccd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cd2:	e9 a3 f3 ff ff       	jmp    8010607a <alltraps>

80106cd7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $192
80106cd9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106cde:	e9 97 f3 ff ff       	jmp    8010607a <alltraps>

80106ce3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $193
80106ce5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cea:	e9 8b f3 ff ff       	jmp    8010607a <alltraps>

80106cef <vector194>:
.globl vector194
vector194:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $194
80106cf1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cf6:	e9 7f f3 ff ff       	jmp    8010607a <alltraps>

80106cfb <vector195>:
.globl vector195
vector195:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $195
80106cfd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d02:	e9 73 f3 ff ff       	jmp    8010607a <alltraps>

80106d07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $196
80106d09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d0e:	e9 67 f3 ff ff       	jmp    8010607a <alltraps>

80106d13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $197
80106d15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d1a:	e9 5b f3 ff ff       	jmp    8010607a <alltraps>

80106d1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $198
80106d21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d26:	e9 4f f3 ff ff       	jmp    8010607a <alltraps>

80106d2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $199
80106d2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d32:	e9 43 f3 ff ff       	jmp    8010607a <alltraps>

80106d37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $200
80106d39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d3e:	e9 37 f3 ff ff       	jmp    8010607a <alltraps>

80106d43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $201
80106d45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d4a:	e9 2b f3 ff ff       	jmp    8010607a <alltraps>

80106d4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $202
80106d51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d56:	e9 1f f3 ff ff       	jmp    8010607a <alltraps>

80106d5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $203
80106d5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d62:	e9 13 f3 ff ff       	jmp    8010607a <alltraps>

80106d67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $204
80106d69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d6e:	e9 07 f3 ff ff       	jmp    8010607a <alltraps>

80106d73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $205
80106d75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d7a:	e9 fb f2 ff ff       	jmp    8010607a <alltraps>

80106d7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $206
80106d81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d86:	e9 ef f2 ff ff       	jmp    8010607a <alltraps>

80106d8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $207
80106d8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d92:	e9 e3 f2 ff ff       	jmp    8010607a <alltraps>

80106d97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $208
80106d99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d9e:	e9 d7 f2 ff ff       	jmp    8010607a <alltraps>

80106da3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $209
80106da5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106daa:	e9 cb f2 ff ff       	jmp    8010607a <alltraps>

80106daf <vector210>:
.globl vector210
vector210:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $210
80106db1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106db6:	e9 bf f2 ff ff       	jmp    8010607a <alltraps>

80106dbb <vector211>:
.globl vector211
vector211:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $211
80106dbd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106dc2:	e9 b3 f2 ff ff       	jmp    8010607a <alltraps>

80106dc7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $212
80106dc9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dce:	e9 a7 f2 ff ff       	jmp    8010607a <alltraps>

80106dd3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $213
80106dd5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dda:	e9 9b f2 ff ff       	jmp    8010607a <alltraps>

80106ddf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $214
80106de1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106de6:	e9 8f f2 ff ff       	jmp    8010607a <alltraps>

80106deb <vector215>:
.globl vector215
vector215:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $215
80106ded:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106df2:	e9 83 f2 ff ff       	jmp    8010607a <alltraps>

80106df7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $216
80106df9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dfe:	e9 77 f2 ff ff       	jmp    8010607a <alltraps>

80106e03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $217
80106e05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e0a:	e9 6b f2 ff ff       	jmp    8010607a <alltraps>

80106e0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $218
80106e11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e16:	e9 5f f2 ff ff       	jmp    8010607a <alltraps>

80106e1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $219
80106e1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e22:	e9 53 f2 ff ff       	jmp    8010607a <alltraps>

80106e27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $220
80106e29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e2e:	e9 47 f2 ff ff       	jmp    8010607a <alltraps>

80106e33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $221
80106e35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e3a:	e9 3b f2 ff ff       	jmp    8010607a <alltraps>

80106e3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $222
80106e41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e46:	e9 2f f2 ff ff       	jmp    8010607a <alltraps>

80106e4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $223
80106e4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e52:	e9 23 f2 ff ff       	jmp    8010607a <alltraps>

80106e57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $224
80106e59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e5e:	e9 17 f2 ff ff       	jmp    8010607a <alltraps>

80106e63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $225
80106e65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e6a:	e9 0b f2 ff ff       	jmp    8010607a <alltraps>

80106e6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $226
80106e71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e76:	e9 ff f1 ff ff       	jmp    8010607a <alltraps>

80106e7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $227
80106e7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e82:	e9 f3 f1 ff ff       	jmp    8010607a <alltraps>

80106e87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $228
80106e89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e8e:	e9 e7 f1 ff ff       	jmp    8010607a <alltraps>

80106e93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $229
80106e95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e9a:	e9 db f1 ff ff       	jmp    8010607a <alltraps>

80106e9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $230
80106ea1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ea6:	e9 cf f1 ff ff       	jmp    8010607a <alltraps>

80106eab <vector231>:
.globl vector231
vector231:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $231
80106ead:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106eb2:	e9 c3 f1 ff ff       	jmp    8010607a <alltraps>

80106eb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $232
80106eb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ebe:	e9 b7 f1 ff ff       	jmp    8010607a <alltraps>

80106ec3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $233
80106ec5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eca:	e9 ab f1 ff ff       	jmp    8010607a <alltraps>

80106ecf <vector234>:
.globl vector234
vector234:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $234
80106ed1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ed6:	e9 9f f1 ff ff       	jmp    8010607a <alltraps>

80106edb <vector235>:
.globl vector235
vector235:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $235
80106edd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ee2:	e9 93 f1 ff ff       	jmp    8010607a <alltraps>

80106ee7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $236
80106ee9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106eee:	e9 87 f1 ff ff       	jmp    8010607a <alltraps>

80106ef3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $237
80106ef5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106efa:	e9 7b f1 ff ff       	jmp    8010607a <alltraps>

80106eff <vector238>:
.globl vector238
vector238:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $238
80106f01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f06:	e9 6f f1 ff ff       	jmp    8010607a <alltraps>

80106f0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $239
80106f0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f12:	e9 63 f1 ff ff       	jmp    8010607a <alltraps>

80106f17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $240
80106f19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f1e:	e9 57 f1 ff ff       	jmp    8010607a <alltraps>

80106f23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $241
80106f25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f2a:	e9 4b f1 ff ff       	jmp    8010607a <alltraps>

80106f2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $242
80106f31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f36:	e9 3f f1 ff ff       	jmp    8010607a <alltraps>

80106f3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $243
80106f3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f42:	e9 33 f1 ff ff       	jmp    8010607a <alltraps>

80106f47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $244
80106f49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f4e:	e9 27 f1 ff ff       	jmp    8010607a <alltraps>

80106f53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $245
80106f55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f5a:	e9 1b f1 ff ff       	jmp    8010607a <alltraps>

80106f5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $246
80106f61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f66:	e9 0f f1 ff ff       	jmp    8010607a <alltraps>

80106f6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $247
80106f6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f72:	e9 03 f1 ff ff       	jmp    8010607a <alltraps>

80106f77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $248
80106f79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f7e:	e9 f7 f0 ff ff       	jmp    8010607a <alltraps>

80106f83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $249
80106f85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f8a:	e9 eb f0 ff ff       	jmp    8010607a <alltraps>

80106f8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $250
80106f91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f96:	e9 df f0 ff ff       	jmp    8010607a <alltraps>

80106f9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $251
80106f9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fa2:	e9 d3 f0 ff ff       	jmp    8010607a <alltraps>

80106fa7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $252
80106fa9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fae:	e9 c7 f0 ff ff       	jmp    8010607a <alltraps>

80106fb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $253
80106fb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fba:	e9 bb f0 ff ff       	jmp    8010607a <alltraps>

80106fbf <vector254>:
.globl vector254
vector254:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $254
80106fc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fc6:	e9 af f0 ff ff       	jmp    8010607a <alltraps>

80106fcb <vector255>:
.globl vector255
vector255:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $255
80106fcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106fd2:	e9 a3 f0 ff ff       	jmp    8010607a <alltraps>
80106fd7:	66 90                	xchg   %ax,%ax
80106fd9:	66 90                	xchg   %ax,%ax
80106fdb:	66 90                	xchg   %ax,%ax
80106fdd:	66 90                	xchg   %ax,%ax
80106fdf:	90                   	nop

80106fe0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fe6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106fec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ff2:	83 ec 1c             	sub    $0x1c,%esp
80106ff5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ff8:	39 d3                	cmp    %edx,%ebx
80106ffa:	73 49                	jae    80107045 <deallocuvm.part.0+0x65>
80106ffc:	89 c7                	mov    %eax,%edi
80106ffe:	eb 0c                	jmp    8010700c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107000:	83 c0 01             	add    $0x1,%eax
80107003:	c1 e0 16             	shl    $0x16,%eax
80107006:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107008:	39 da                	cmp    %ebx,%edx
8010700a:	76 39                	jbe    80107045 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010700c:	89 d8                	mov    %ebx,%eax
8010700e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107011:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107014:	f6 c1 01             	test   $0x1,%cl
80107017:	74 e7                	je     80107000 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107019:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010701b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107021:	c1 ee 0a             	shr    $0xa,%esi
80107024:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010702a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107031:	85 f6                	test   %esi,%esi
80107033:	74 cb                	je     80107000 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107035:	8b 06                	mov    (%esi),%eax
80107037:	a8 01                	test   $0x1,%al
80107039:	75 15                	jne    80107050 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010703b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107041:	39 da                	cmp    %ebx,%edx
80107043:	77 c7                	ja     8010700c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107045:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704b:	5b                   	pop    %ebx
8010704c:	5e                   	pop    %esi
8010704d:	5f                   	pop    %edi
8010704e:	5d                   	pop    %ebp
8010704f:	c3                   	ret    
      if(pa == 0)
80107050:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107055:	74 25                	je     8010707c <deallocuvm.part.0+0x9c>
      kfree(v);
80107057:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010705a:	05 00 00 00 80       	add    $0x80000000,%eax
8010705f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107062:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107068:	50                   	push   %eax
80107069:	e8 92 bc ff ff       	call   80102d00 <kfree>
      *pte = 0;
8010706e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107074:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107077:	83 c4 10             	add    $0x10,%esp
8010707a:	eb 8c                	jmp    80107008 <deallocuvm.part.0+0x28>
        panic("kfree");
8010707c:	83 ec 0c             	sub    $0xc,%esp
8010707f:	68 52 7c 10 80       	push   $0x80107c52
80107084:	e8 f7 92 ff ff       	call   80100380 <panic>
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107090 <mappages>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107096:	89 d3                	mov    %edx,%ebx
80107098:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010709e:	83 ec 1c             	sub    $0x1c,%esp
801070a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801070a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070b0:	8b 45 08             	mov    0x8(%ebp),%eax
801070b3:	29 d8                	sub    %ebx,%eax
801070b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070b8:	eb 3d                	jmp    801070f7 <mappages+0x67>
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070c0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070c7:	c1 ea 0a             	shr    $0xa,%edx
801070ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070d7:	85 c0                	test   %eax,%eax
801070d9:	74 75                	je     80107150 <mappages+0xc0>
    if(*pte & PTE_P)
801070db:	f6 00 01             	testb  $0x1,(%eax)
801070de:	0f 85 86 00 00 00    	jne    8010716a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801070e4:	0b 75 0c             	or     0xc(%ebp),%esi
801070e7:	83 ce 01             	or     $0x1,%esi
801070ea:	89 30                	mov    %esi,(%eax)
    if(a == last)
801070ec:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801070ef:	74 6f                	je     80107160 <mappages+0xd0>
    a += PGSIZE;
801070f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801070f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801070fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070fd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107100:	89 d8                	mov    %ebx,%eax
80107102:	c1 e8 16             	shr    $0x16,%eax
80107105:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107108:	8b 07                	mov    (%edi),%eax
8010710a:	a8 01                	test   $0x1,%al
8010710c:	75 b2                	jne    801070c0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010710e:	e8 ad bd ff ff       	call   80102ec0 <kalloc>
80107113:	85 c0                	test   %eax,%eax
80107115:	74 39                	je     80107150 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107117:	83 ec 04             	sub    $0x4,%esp
8010711a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010711d:	68 00 10 00 00       	push   $0x1000
80107122:	6a 00                	push   $0x0
80107124:	50                   	push   %eax
80107125:	e8 76 dd ff ff       	call   80104ea0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010712a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010712d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107130:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107136:	83 c8 07             	or     $0x7,%eax
80107139:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010713b:	89 d8                	mov    %ebx,%eax
8010713d:	c1 e8 0a             	shr    $0xa,%eax
80107140:	25 fc 0f 00 00       	and    $0xffc,%eax
80107145:	01 d0                	add    %edx,%eax
80107147:	eb 92                	jmp    801070db <mappages+0x4b>
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107158:	5b                   	pop    %ebx
80107159:	5e                   	pop    %esi
8010715a:	5f                   	pop    %edi
8010715b:	5d                   	pop    %ebp
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
      panic("remap");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 88 82 10 80       	push   $0x80108288
80107172:	e8 09 92 ff ff       	call   80100380 <panic>
80107177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717e:	66 90                	xchg   %ax,%ax

80107180 <seginit>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107186:	e8 05 d0 ff ff       	call   80104190 <cpuid>
  pd[0] = size-1;
8010718b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107190:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107196:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010719a:	c7 80 98 32 11 80 ff 	movl   $0xffff,-0x7feecd68(%eax)
801071a1:	ff 00 00 
801071a4:	c7 80 9c 32 11 80 00 	movl   $0xcf9a00,-0x7feecd64(%eax)
801071ab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071ae:	c7 80 a0 32 11 80 ff 	movl   $0xffff,-0x7feecd60(%eax)
801071b5:	ff 00 00 
801071b8:	c7 80 a4 32 11 80 00 	movl   $0xcf9200,-0x7feecd5c(%eax)
801071bf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071c2:	c7 80 a8 32 11 80 ff 	movl   $0xffff,-0x7feecd58(%eax)
801071c9:	ff 00 00 
801071cc:	c7 80 ac 32 11 80 00 	movl   $0xcffa00,-0x7feecd54(%eax)
801071d3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071d6:	c7 80 b0 32 11 80 ff 	movl   $0xffff,-0x7feecd50(%eax)
801071dd:	ff 00 00 
801071e0:	c7 80 b4 32 11 80 00 	movl   $0xcff200,-0x7feecd4c(%eax)
801071e7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071ea:	05 90 32 11 80       	add    $0x80113290,%eax
  pd[1] = (uint)p;
801071ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071f3:	c1 e8 10             	shr    $0x10,%eax
801071f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071fd:	0f 01 10             	lgdtl  (%eax)
}
80107200:	c9                   	leave  
80107201:	c3                   	ret    
80107202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107210:	a1 44 5f 11 80       	mov    0x80115f44,%eax
80107215:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010721a:	0f 22 d8             	mov    %eax,%cr3
}
8010721d:	c3                   	ret    
8010721e:	66 90                	xchg   %ax,%ax

80107220 <switchuvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
80107229:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010722c:	85 f6                	test   %esi,%esi
8010722e:	0f 84 cb 00 00 00    	je     801072ff <switchuvm+0xdf>
  if(p->kstack == 0)
80107234:	8b 46 08             	mov    0x8(%esi),%eax
80107237:	85 c0                	test   %eax,%eax
80107239:	0f 84 da 00 00 00    	je     80107319 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010723f:	8b 46 04             	mov    0x4(%esi),%eax
80107242:	85 c0                	test   %eax,%eax
80107244:	0f 84 c2 00 00 00    	je     8010730c <switchuvm+0xec>
  pushcli();
8010724a:	e8 41 da ff ff       	call   80104c90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010724f:	e8 dc ce ff ff       	call   80104130 <mycpu>
80107254:	89 c3                	mov    %eax,%ebx
80107256:	e8 d5 ce ff ff       	call   80104130 <mycpu>
8010725b:	89 c7                	mov    %eax,%edi
8010725d:	e8 ce ce ff ff       	call   80104130 <mycpu>
80107262:	83 c7 08             	add    $0x8,%edi
80107265:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107268:	e8 c3 ce ff ff       	call   80104130 <mycpu>
8010726d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107270:	ba 67 00 00 00       	mov    $0x67,%edx
80107275:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010727c:	83 c0 08             	add    $0x8,%eax
8010727f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107286:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010728b:	83 c1 08             	add    $0x8,%ecx
8010728e:	c1 e8 18             	shr    $0x18,%eax
80107291:	c1 e9 10             	shr    $0x10,%ecx
80107294:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010729a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072a0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072a5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072b1:	e8 7a ce ff ff       	call   80104130 <mycpu>
801072b6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072bd:	e8 6e ce ff ff       	call   80104130 <mycpu>
801072c2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072c6:	8b 5e 08             	mov    0x8(%esi),%ebx
801072c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072cf:	e8 5c ce ff ff       	call   80104130 <mycpu>
801072d4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d7:	e8 54 ce ff ff       	call   80104130 <mycpu>
801072dc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072e0:	b8 28 00 00 00       	mov    $0x28,%eax
801072e5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072e8:	8b 46 04             	mov    0x4(%esi),%eax
801072eb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072f0:	0f 22 d8             	mov    %eax,%cr3
}
801072f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f6:	5b                   	pop    %ebx
801072f7:	5e                   	pop    %esi
801072f8:	5f                   	pop    %edi
801072f9:	5d                   	pop    %ebp
  popcli();
801072fa:	e9 e1 d9 ff ff       	jmp    80104ce0 <popcli>
    panic("switchuvm: no process");
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	68 8e 82 10 80       	push   $0x8010828e
80107307:	e8 74 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 b9 82 10 80       	push   $0x801082b9
80107314:	e8 67 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 a4 82 10 80       	push   $0x801082a4
80107321:	e8 5a 90 ff ff       	call   80100380 <panic>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi

80107330 <inituvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010733c:	8b 75 10             	mov    0x10(%ebp),%esi
8010733f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107342:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107345:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010734b:	77 4b                	ja     80107398 <inituvm+0x68>
  mem = kalloc();
8010734d:	e8 6e bb ff ff       	call   80102ec0 <kalloc>
  memset(mem, 0, PGSIZE);
80107352:	83 ec 04             	sub    $0x4,%esp
80107355:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010735a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010735c:	6a 00                	push   $0x0
8010735e:	50                   	push   %eax
8010735f:	e8 3c db ff ff       	call   80104ea0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107364:	58                   	pop    %eax
80107365:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010736b:	5a                   	pop    %edx
8010736c:	6a 06                	push   $0x6
8010736e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107373:	31 d2                	xor    %edx,%edx
80107375:	50                   	push   %eax
80107376:	89 f8                	mov    %edi,%eax
80107378:	e8 13 fd ff ff       	call   80107090 <mappages>
  memmove(mem, init, sz);
8010737d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107380:	89 75 10             	mov    %esi,0x10(%ebp)
80107383:	83 c4 10             	add    $0x10,%esp
80107386:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107389:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010738c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010738f:	5b                   	pop    %ebx
80107390:	5e                   	pop    %esi
80107391:	5f                   	pop    %edi
80107392:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107393:	e9 a8 db ff ff       	jmp    80104f40 <memmove>
    panic("inituvm: more than a page");
80107398:	83 ec 0c             	sub    $0xc,%esp
8010739b:	68 cd 82 10 80       	push   $0x801082cd
801073a0:	e8 db 8f ff ff       	call   80100380 <panic>
801073a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073b0 <loaduvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 1c             	sub    $0x1c,%esp
801073b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801073bc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801073bf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073c4:	0f 85 bb 00 00 00    	jne    80107485 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801073ca:	01 f0                	add    %esi,%eax
801073cc:	89 f3                	mov    %esi,%ebx
801073ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073d1:	8b 45 14             	mov    0x14(%ebp),%eax
801073d4:	01 f0                	add    %esi,%eax
801073d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801073d9:	85 f6                	test   %esi,%esi
801073db:	0f 84 87 00 00 00    	je     80107468 <loaduvm+0xb8>
801073e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801073e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801073eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801073ee:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801073f0:	89 c2                	mov    %eax,%edx
801073f2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801073f5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801073f8:	f6 c2 01             	test   $0x1,%dl
801073fb:	75 13                	jne    80107410 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801073fd:	83 ec 0c             	sub    $0xc,%esp
80107400:	68 e7 82 10 80       	push   $0x801082e7
80107405:	e8 76 8f ff ff       	call   80100380 <panic>
8010740a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107410:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107413:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107419:	25 fc 0f 00 00       	and    $0xffc,%eax
8010741e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107425:	85 c0                	test   %eax,%eax
80107427:	74 d4                	je     801073fd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107429:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010742b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010742e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107438:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010743e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107441:	29 d9                	sub    %ebx,%ecx
80107443:	05 00 00 00 80       	add    $0x80000000,%eax
80107448:	57                   	push   %edi
80107449:	51                   	push   %ecx
8010744a:	50                   	push   %eax
8010744b:	ff 75 10             	push   0x10(%ebp)
8010744e:	e8 7d ae ff ff       	call   801022d0 <readi>
80107453:	83 c4 10             	add    $0x10,%esp
80107456:	39 f8                	cmp    %edi,%eax
80107458:	75 1e                	jne    80107478 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010745a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107460:	89 f0                	mov    %esi,%eax
80107462:	29 d8                	sub    %ebx,%eax
80107464:	39 c6                	cmp    %eax,%esi
80107466:	77 80                	ja     801073e8 <loaduvm+0x38>
}
80107468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010746b:	31 c0                	xor    %eax,%eax
}
8010746d:	5b                   	pop    %ebx
8010746e:	5e                   	pop    %esi
8010746f:	5f                   	pop    %edi
80107470:	5d                   	pop    %ebp
80107471:	c3                   	ret    
80107472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107478:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010747b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107480:	5b                   	pop    %ebx
80107481:	5e                   	pop    %esi
80107482:	5f                   	pop    %edi
80107483:	5d                   	pop    %ebp
80107484:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107485:	83 ec 0c             	sub    $0xc,%esp
80107488:	68 88 83 10 80       	push   $0x80108388
8010748d:	e8 ee 8e ff ff       	call   80100380 <panic>
80107492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074a0 <allocuvm>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
801074a6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074a9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074b2:	85 c0                	test   %eax,%eax
801074b4:	0f 88 b6 00 00 00    	js     80107570 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074c0:	0f 82 9a 00 00 00    	jb     80107560 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074c6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074cc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801074d2:	39 75 10             	cmp    %esi,0x10(%ebp)
801074d5:	77 44                	ja     8010751b <allocuvm+0x7b>
801074d7:	e9 87 00 00 00       	jmp    80107563 <allocuvm+0xc3>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801074e0:	83 ec 04             	sub    $0x4,%esp
801074e3:	68 00 10 00 00       	push   $0x1000
801074e8:	6a 00                	push   $0x0
801074ea:	50                   	push   %eax
801074eb:	e8 b0 d9 ff ff       	call   80104ea0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074f0:	58                   	pop    %eax
801074f1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074f7:	5a                   	pop    %edx
801074f8:	6a 06                	push   $0x6
801074fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074ff:	89 f2                	mov    %esi,%edx
80107501:	50                   	push   %eax
80107502:	89 f8                	mov    %edi,%eax
80107504:	e8 87 fb ff ff       	call   80107090 <mappages>
80107509:	83 c4 10             	add    $0x10,%esp
8010750c:	85 c0                	test   %eax,%eax
8010750e:	78 78                	js     80107588 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107510:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107516:	39 75 10             	cmp    %esi,0x10(%ebp)
80107519:	76 48                	jbe    80107563 <allocuvm+0xc3>
    mem = kalloc();
8010751b:	e8 a0 b9 ff ff       	call   80102ec0 <kalloc>
80107520:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107522:	85 c0                	test   %eax,%eax
80107524:	75 ba                	jne    801074e0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107526:	83 ec 0c             	sub    $0xc,%esp
80107529:	68 05 83 10 80       	push   $0x80108305
8010752e:	e8 cd 91 ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
80107533:	8b 45 0c             	mov    0xc(%ebp),%eax
80107536:	83 c4 10             	add    $0x10,%esp
80107539:	39 45 10             	cmp    %eax,0x10(%ebp)
8010753c:	74 32                	je     80107570 <allocuvm+0xd0>
8010753e:	8b 55 10             	mov    0x10(%ebp),%edx
80107541:	89 c1                	mov    %eax,%ecx
80107543:	89 f8                	mov    %edi,%eax
80107545:	e8 96 fa ff ff       	call   80106fe0 <deallocuvm.part.0>
      return 0;
8010754a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107554:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107557:	5b                   	pop    %ebx
80107558:	5e                   	pop    %esi
80107559:	5f                   	pop    %edi
8010755a:	5d                   	pop    %ebp
8010755b:	c3                   	ret    
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107566:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107569:	5b                   	pop    %ebx
8010756a:	5e                   	pop    %esi
8010756b:	5f                   	pop    %edi
8010756c:	5d                   	pop    %ebp
8010756d:	c3                   	ret    
8010756e:	66 90                	xchg   %ax,%ax
    return 0;
80107570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010757a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010757d:	5b                   	pop    %ebx
8010757e:	5e                   	pop    %esi
8010757f:	5f                   	pop    %edi
80107580:	5d                   	pop    %ebp
80107581:	c3                   	ret    
80107582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107588:	83 ec 0c             	sub    $0xc,%esp
8010758b:	68 1d 83 10 80       	push   $0x8010831d
80107590:	e8 6b 91 ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
80107595:	8b 45 0c             	mov    0xc(%ebp),%eax
80107598:	83 c4 10             	add    $0x10,%esp
8010759b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010759e:	74 0c                	je     801075ac <allocuvm+0x10c>
801075a0:	8b 55 10             	mov    0x10(%ebp),%edx
801075a3:	89 c1                	mov    %eax,%ecx
801075a5:	89 f8                	mov    %edi,%eax
801075a7:	e8 34 fa ff ff       	call   80106fe0 <deallocuvm.part.0>
      kfree(mem);
801075ac:	83 ec 0c             	sub    $0xc,%esp
801075af:	53                   	push   %ebx
801075b0:	e8 4b b7 ff ff       	call   80102d00 <kfree>
      return 0;
801075b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075bc:	83 c4 10             	add    $0x10,%esp
}
801075bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075d0 <deallocuvm>:
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801075d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801075dc:	39 d1                	cmp    %edx,%ecx
801075de:	73 10                	jae    801075f0 <deallocuvm+0x20>
}
801075e0:	5d                   	pop    %ebp
801075e1:	e9 fa f9 ff ff       	jmp    80106fe0 <deallocuvm.part.0>
801075e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ed:	8d 76 00             	lea    0x0(%esi),%esi
801075f0:	89 d0                	mov    %edx,%eax
801075f2:	5d                   	pop    %ebp
801075f3:	c3                   	ret    
801075f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075ff:	90                   	nop

80107600 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010760c:	85 f6                	test   %esi,%esi
8010760e:	74 59                	je     80107669 <freevm+0x69>
  if(newsz >= oldsz)
80107610:	31 c9                	xor    %ecx,%ecx
80107612:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107617:	89 f0                	mov    %esi,%eax
80107619:	89 f3                	mov    %esi,%ebx
8010761b:	e8 c0 f9 ff ff       	call   80106fe0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107620:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107626:	eb 0f                	jmp    80107637 <freevm+0x37>
80107628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop
80107630:	83 c3 04             	add    $0x4,%ebx
80107633:	39 df                	cmp    %ebx,%edi
80107635:	74 23                	je     8010765a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107637:	8b 03                	mov    (%ebx),%eax
80107639:	a8 01                	test   $0x1,%al
8010763b:	74 f3                	je     80107630 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010763d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107642:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107645:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107648:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010764d:	50                   	push   %eax
8010764e:	e8 ad b6 ff ff       	call   80102d00 <kfree>
80107653:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107656:	39 df                	cmp    %ebx,%edi
80107658:	75 dd                	jne    80107637 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010765a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010765d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107660:	5b                   	pop    %ebx
80107661:	5e                   	pop    %esi
80107662:	5f                   	pop    %edi
80107663:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107664:	e9 97 b6 ff ff       	jmp    80102d00 <kfree>
    panic("freevm: no pgdir");
80107669:	83 ec 0c             	sub    $0xc,%esp
8010766c:	68 39 83 10 80       	push   $0x80108339
80107671:	e8 0a 8d ff ff       	call   80100380 <panic>
80107676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767d:	8d 76 00             	lea    0x0(%esi),%esi

80107680 <setupkvm>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	56                   	push   %esi
80107684:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107685:	e8 36 b8 ff ff       	call   80102ec0 <kalloc>
8010768a:	89 c6                	mov    %eax,%esi
8010768c:	85 c0                	test   %eax,%eax
8010768e:	74 42                	je     801076d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107690:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107693:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107698:	68 00 10 00 00       	push   $0x1000
8010769d:	6a 00                	push   $0x0
8010769f:	50                   	push   %eax
801076a0:	e8 fb d7 ff ff       	call   80104ea0 <memset>
801076a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076ab:	83 ec 08             	sub    $0x8,%esp
801076ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076b1:	ff 73 0c             	push   0xc(%ebx)
801076b4:	8b 13                	mov    (%ebx),%edx
801076b6:	50                   	push   %eax
801076b7:	29 c1                	sub    %eax,%ecx
801076b9:	89 f0                	mov    %esi,%eax
801076bb:	e8 d0 f9 ff ff       	call   80107090 <mappages>
801076c0:	83 c4 10             	add    $0x10,%esp
801076c3:	85 c0                	test   %eax,%eax
801076c5:	78 19                	js     801076e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076c7:	83 c3 10             	add    $0x10,%ebx
801076ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076d0:	75 d6                	jne    801076a8 <setupkvm+0x28>
}
801076d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076d5:	89 f0                	mov    %esi,%eax
801076d7:	5b                   	pop    %ebx
801076d8:	5e                   	pop    %esi
801076d9:	5d                   	pop    %ebp
801076da:	c3                   	ret    
801076db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop
      freevm(pgdir);
801076e0:	83 ec 0c             	sub    $0xc,%esp
801076e3:	56                   	push   %esi
      return 0;
801076e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801076e6:	e8 15 ff ff ff       	call   80107600 <freevm>
      return 0;
801076eb:	83 c4 10             	add    $0x10,%esp
}
801076ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076f1:	89 f0                	mov    %esi,%eax
801076f3:	5b                   	pop    %ebx
801076f4:	5e                   	pop    %esi
801076f5:	5d                   	pop    %ebp
801076f6:	c3                   	ret    
801076f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fe:	66 90                	xchg   %ax,%ax

80107700 <kvmalloc>:
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107706:	e8 75 ff ff ff       	call   80107680 <setupkvm>
8010770b:	a3 44 5f 11 80       	mov    %eax,0x80115f44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107710:	05 00 00 00 80       	add    $0x80000000,%eax
80107715:	0f 22 d8             	mov    %eax,%cr3
}
80107718:	c9                   	leave  
80107719:	c3                   	ret    
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107720 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	83 ec 08             	sub    $0x8,%esp
80107726:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107729:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010772c:	89 c1                	mov    %eax,%ecx
8010772e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107731:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107734:	f6 c2 01             	test   $0x1,%dl
80107737:	75 17                	jne    80107750 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107739:	83 ec 0c             	sub    $0xc,%esp
8010773c:	68 4a 83 10 80       	push   $0x8010834a
80107741:	e8 3a 8c ff ff       	call   80100380 <panic>
80107746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107750:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107753:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107759:	25 fc 0f 00 00       	and    $0xffc,%eax
8010775e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107765:	85 c0                	test   %eax,%eax
80107767:	74 d0                	je     80107739 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107769:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010776c:	c9                   	leave  
8010776d:	c3                   	ret    
8010776e:	66 90                	xchg   %ax,%ax

80107770 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	57                   	push   %edi
80107774:	56                   	push   %esi
80107775:	53                   	push   %ebx
80107776:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107779:	e8 02 ff ff ff       	call   80107680 <setupkvm>
8010777e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107781:	85 c0                	test   %eax,%eax
80107783:	0f 84 bd 00 00 00    	je     80107846 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107789:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010778c:	85 c9                	test   %ecx,%ecx
8010778e:	0f 84 b2 00 00 00    	je     80107846 <copyuvm+0xd6>
80107794:	31 f6                	xor    %esi,%esi
80107796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801077a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801077a3:	89 f0                	mov    %esi,%eax
801077a5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801077a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801077ab:	a8 01                	test   $0x1,%al
801077ad:	75 11                	jne    801077c0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801077af:	83 ec 0c             	sub    $0xc,%esp
801077b2:	68 54 83 10 80       	push   $0x80108354
801077b7:	e8 c4 8b ff ff       	call   80100380 <panic>
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801077c0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801077c7:	c1 ea 0a             	shr    $0xa,%edx
801077ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801077d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077d7:	85 c0                	test   %eax,%eax
801077d9:	74 d4                	je     801077af <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801077db:	8b 00                	mov    (%eax),%eax
801077dd:	a8 01                	test   $0x1,%al
801077df:	0f 84 9f 00 00 00    	je     80107884 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801077e5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801077e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801077ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801077ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801077f5:	e8 c6 b6 ff ff       	call   80102ec0 <kalloc>
801077fa:	89 c3                	mov    %eax,%ebx
801077fc:	85 c0                	test   %eax,%eax
801077fe:	74 64                	je     80107864 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107800:	83 ec 04             	sub    $0x4,%esp
80107803:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107809:	68 00 10 00 00       	push   $0x1000
8010780e:	57                   	push   %edi
8010780f:	50                   	push   %eax
80107810:	e8 2b d7 ff ff       	call   80104f40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107815:	58                   	pop    %eax
80107816:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010781c:	5a                   	pop    %edx
8010781d:	ff 75 e4             	push   -0x1c(%ebp)
80107820:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107825:	89 f2                	mov    %esi,%edx
80107827:	50                   	push   %eax
80107828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010782b:	e8 60 f8 ff ff       	call   80107090 <mappages>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	78 21                	js     80107858 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107837:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010783d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107840:	0f 87 5a ff ff ff    	ja     801077a0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107846:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010784c:	5b                   	pop    %ebx
8010784d:	5e                   	pop    %esi
8010784e:	5f                   	pop    %edi
8010784f:	5d                   	pop    %ebp
80107850:	c3                   	ret    
80107851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107858:	83 ec 0c             	sub    $0xc,%esp
8010785b:	53                   	push   %ebx
8010785c:	e8 9f b4 ff ff       	call   80102d00 <kfree>
      goto bad;
80107861:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107864:	83 ec 0c             	sub    $0xc,%esp
80107867:	ff 75 e0             	push   -0x20(%ebp)
8010786a:	e8 91 fd ff ff       	call   80107600 <freevm>
  return 0;
8010786f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107876:	83 c4 10             	add    $0x10,%esp
}
80107879:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010787c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010787f:	5b                   	pop    %ebx
80107880:	5e                   	pop    %esi
80107881:	5f                   	pop    %edi
80107882:	5d                   	pop    %ebp
80107883:	c3                   	ret    
      panic("copyuvm: page not present");
80107884:	83 ec 0c             	sub    $0xc,%esp
80107887:	68 6e 83 10 80       	push   $0x8010836e
8010788c:	e8 ef 8a ff ff       	call   80100380 <panic>
80107891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789f:	90                   	nop

801078a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078a9:	89 c1                	mov    %eax,%ecx
801078ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078b1:	f6 c2 01             	test   $0x1,%dl
801078b4:	0f 84 00 01 00 00    	je     801079ba <uva2ka.cold>
  return &pgtab[PTX(va)];
801078ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801078c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801078c9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801078d0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078d7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078da:	05 00 00 00 80       	add    $0x80000000,%eax
801078df:	83 fa 05             	cmp    $0x5,%edx
801078e2:	ba 00 00 00 00       	mov    $0x0,%edx
801078e7:	0f 45 c2             	cmovne %edx,%eax
}
801078ea:	c3                   	ret    
801078eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078ef:	90                   	nop

801078f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	57                   	push   %edi
801078f4:	56                   	push   %esi
801078f5:	53                   	push   %ebx
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	8b 75 14             	mov    0x14(%ebp),%esi
801078fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107902:	85 f6                	test   %esi,%esi
80107904:	75 51                	jne    80107957 <copyout+0x67>
80107906:	e9 a5 00 00 00       	jmp    801079b0 <copyout+0xc0>
8010790b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010790f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107910:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107916:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010791c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107922:	74 75                	je     80107999 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107924:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107926:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107929:	29 c3                	sub    %eax,%ebx
8010792b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107931:	39 f3                	cmp    %esi,%ebx
80107933:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107936:	29 f8                	sub    %edi,%eax
80107938:	83 ec 04             	sub    $0x4,%esp
8010793b:	01 c1                	add    %eax,%ecx
8010793d:	53                   	push   %ebx
8010793e:	52                   	push   %edx
8010793f:	51                   	push   %ecx
80107940:	e8 fb d5 ff ff       	call   80104f40 <memmove>
    len -= n;
    buf += n;
80107945:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107948:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010794e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107951:	01 da                	add    %ebx,%edx
  while(len > 0){
80107953:	29 de                	sub    %ebx,%esi
80107955:	74 59                	je     801079b0 <copyout+0xc0>
  if(*pde & PTE_P){
80107957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010795a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010795c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010795e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107961:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107967:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010796a:	f6 c1 01             	test   $0x1,%cl
8010796d:	0f 84 4e 00 00 00    	je     801079c1 <copyout.cold>
  return &pgtab[PTX(va)];
80107973:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107975:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010797b:	c1 eb 0c             	shr    $0xc,%ebx
8010797e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107984:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010798b:	89 d9                	mov    %ebx,%ecx
8010798d:	83 e1 05             	and    $0x5,%ecx
80107990:	83 f9 05             	cmp    $0x5,%ecx
80107993:	0f 84 77 ff ff ff    	je     80107910 <copyout+0x20>
  }
  return 0;
}
80107999:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010799c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a1:	5b                   	pop    %ebx
801079a2:	5e                   	pop    %esi
801079a3:	5f                   	pop    %edi
801079a4:	5d                   	pop    %ebp
801079a5:	c3                   	ret    
801079a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079ad:	8d 76 00             	lea    0x0(%esi),%esi
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    

801079ba <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801079ba:	a1 00 00 00 00       	mov    0x0,%eax
801079bf:	0f 0b                	ud2    

801079c1 <copyout.cold>:
801079c1:	a1 00 00 00 00       	mov    0x0,%eax
801079c6:	0f 0b                	ud2    
