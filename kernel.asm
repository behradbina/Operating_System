
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
80100028:	bc 70 ee 11 80       	mov    $0x8011ee70,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 43 10 80       	mov    $0x80104370,%eax
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
8010004c:	68 60 92 10 80       	push   $0x80109260
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 85 60 00 00       	call   801060e0 <initlock>
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
80100092:	68 67 92 10 80       	push   $0x80109267
80100097:	50                   	push   %eax
80100098:	e8 13 5f 00 00       	call   80105fb0 <initsleeplock>
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 e7 61 00 00       	call   801062d0 <acquire>
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
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
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
80100162:	e8 09 61 00 00       	call   80106270 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 5e 00 00       	call   80105ff0 <acquiresleep>
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
8010018c:	e8 7f 34 00 00       	call   80103610 <iderw>
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
801001a1:	68 6e 92 10 80       	push   $0x8010926e
801001a6:	e8 a5 02 00 00       	call   80100450 <panic>
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
801001be:	e8 cd 5e 00 00       	call   80106090 <holdingsleep>
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
801001d4:	e9 37 34 00 00       	jmp    80103610 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 92 10 80       	push   $0x8010927f
801001e1:	e8 6a 02 00 00       	call   80100450 <panic>
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
801001ff:	e8 8c 5e 00 00       	call   80106090 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 5e 00 00       	call   80106050 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 b0 60 00 00       	call   801062d0 <acquire>
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
8010023f:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 02 60 00 00       	jmp    80106270 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 92 10 80       	push   $0x80109286
80100276:	e8 d5 01 00 00       	call   80100450 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

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
80100294:	e8 27 29 00 00       	call   80102bc0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
801002a0:	e8 2b 60 00 00       	call   801062d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
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
801002cd:	e8 1e 51 00 00       	call   801053f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 4a 00 00       	call   80104cf0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 1a 11 80       	push   $0x80111ac0
801002f6:	e8 75 5f 00 00       	call   80106270 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 dc 27 00 00       	call   80102ae0 <ilock>
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
8010034c:	e8 1f 5f 00 00       	call   80106270 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 86 27 00 00       	call   80102ae0 <ilock>
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
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80100388:	83 ec 08             	sub    $0x8,%esp
8010038b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return;
    }

    if (num < 0 && base == 10) {
8010038e:	85 c0                	test   %eax,%eax
80100390:	79 76                	jns    80100408 <itoa.part.0+0x88>
80100392:	83 f9 0a             	cmp    $0xa,%ecx
80100395:	75 71                	jne    80100408 <itoa.part.0+0x88>
        isNegative = 1;
        num = -num;
80100397:	f7 d8                	neg    %eax
        isNegative = 1;
80100399:	bf 01 00 00 00       	mov    $0x1,%edi
8010039e:	89 7d ec             	mov    %edi,-0x14(%ebp)
801003a1:	31 c9                	xor    %ecx,%ecx
801003a3:	eb 05                	jmp    801003aa <itoa.part.0+0x2a>
801003a5:	8d 76 00             	lea    0x0(%esi),%esi
    }

    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801003a8:	89 f1                	mov    %esi,%ecx
        int rem = num % base;
801003aa:	99                   	cltd
801003ab:	f7 7d f0             	idivl  -0x10(%ebp)
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801003ae:	8d 72 30             	lea    0x30(%edx),%esi
801003b1:	8d 7a 57             	lea    0x57(%edx),%edi
801003b4:	83 fa 0a             	cmp    $0xa,%edx
801003b7:	0f 4c fe             	cmovl  %esi,%edi
801003ba:	8d 71 01             	lea    0x1(%ecx),%esi
801003bd:	89 fa                	mov    %edi,%edx
801003bf:	88 54 33 ff          	mov    %dl,-0x1(%ebx,%esi,1)
    while (num != 0) {
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 e1                	jne    801003a8 <itoa.part.0+0x28>
801003c7:	8b 7d ec             	mov    -0x14(%ebp),%edi
        num = num / base;
    }

    if (isNegative) str[i++] = '-';
801003ca:	85 ff                	test   %edi,%edi
801003cc:	74 52                	je     80100420 <itoa.part.0+0xa0>
801003ce:	c6 04 33 2d          	movb   $0x2d,(%ebx,%esi,1)

    str[i] = '\0';
801003d2:	c6 44 0b 02 00       	movb   $0x0,0x2(%ebx,%ecx,1)

    // Reverse the string
    int start = 0;
    int end = i - 1;
801003d7:	89 f1                	mov    %esi,%ecx
801003d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (start < end) {
        char temp = str[start];
801003e0:	0f b6 3c 03          	movzbl (%ebx,%eax,1),%edi
        str[start] = str[end];
801003e4:	0f b6 14 0b          	movzbl (%ebx,%ecx,1),%edx
801003e8:	88 14 03             	mov    %dl,(%ebx,%eax,1)
        str[end] = temp;
801003eb:	89 fa                	mov    %edi,%edx
        start++;
801003ed:	83 c0 01             	add    $0x1,%eax
        str[end] = temp;
801003f0:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
        end--;
801003f3:	83 e9 01             	sub    $0x1,%ecx
    while (start < end) {
801003f6:	39 c8                	cmp    %ecx,%eax
801003f8:	7c e6                	jl     801003e0 <itoa.part.0+0x60>
    }
}
801003fa:	83 c4 08             	add    $0x8,%esp
801003fd:	5b                   	pop    %ebx
801003fe:	5e                   	pop    %esi
801003ff:	5f                   	pop    %edi
80100400:	5d                   	pop    %ebp
80100401:	c3                   	ret
80100402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while (num != 0) {
80100408:	31 ff                	xor    %edi,%edi
8010040a:	85 c0                	test   %eax,%eax
8010040c:	75 90                	jne    8010039e <itoa.part.0+0x1e>
    str[i] = '\0';
8010040e:	c6 03 00             	movb   $0x0,(%ebx)
}
80100411:	83 c4 08             	add    $0x8,%esp
80100414:	5b                   	pop    %ebx
80100415:	5e                   	pop    %esi
80100416:	5f                   	pop    %edi
80100417:	5d                   	pop    %ebp
80100418:	c3                   	ret
80100419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    str[i] = '\0';
80100420:	c6 04 33 00          	movb   $0x0,(%ebx,%esi,1)
    while (start < end) {
80100424:	85 c9                	test   %ecx,%ecx
80100426:	75 b8                	jne    801003e0 <itoa.part.0+0x60>
80100428:	eb d0                	jmp    801003fa <itoa.part.0+0x7a>
8010042a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100430 <isDigit>:
{
80100430:	55                   	push   %ebp
80100431:	89 e5                	mov    %esp,%ebp
  return(c>='0' && c<='9');
80100433:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}
80100437:	5d                   	pop    %ebp
  return(c>='0' && c<='9');
80100438:	83 e8 30             	sub    $0x30,%eax
8010043b:	3c 09                	cmp    $0x9,%al
8010043d:	0f 96 c0             	setbe  %al
80100440:	0f b6 c0             	movzbl %al,%eax
}
80100443:	c3                   	ret
80100444:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010044b:	00 
8010044c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100450 <panic>:
{
80100450:	55                   	push   %ebp
80100451:	89 e5                	mov    %esp,%ebp
80100453:	56                   	push   %esi
80100454:	53                   	push   %ebx
80100455:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100458:	fa                   	cli
  cons.locking = 0;
80100459:	c7 05 f4 1a 11 80 00 	movl   $0x0,0x80111af4
80100460:	00 00 00 
  getcallerpcs(&s, pcs);
80100463:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100466:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100469:	e8 a2 37 00 00       	call   80103c10 <lapicid>
8010046e:	83 ec 08             	sub    $0x8,%esp
80100471:	50                   	push   %eax
80100472:	68 8d 92 10 80       	push   $0x8010928d
80100477:	e8 64 03 00 00       	call   801007e0 <cprintf>
  cprintf(s);
8010047c:	58                   	pop    %eax
8010047d:	ff 75 08             	push   0x8(%ebp)
80100480:	e8 5b 03 00 00       	call   801007e0 <cprintf>
  cprintf("\n");
80100485:	c7 04 24 aa 95 10 80 	movl   $0x801095aa,(%esp)
8010048c:	e8 4f 03 00 00       	call   801007e0 <cprintf>
  getcallerpcs(&s, pcs);
80100491:	8d 45 08             	lea    0x8(%ebp),%eax
80100494:	5a                   	pop    %edx
80100495:	59                   	pop    %ecx
80100496:	53                   	push   %ebx
80100497:	50                   	push   %eax
80100498:	e8 63 5c 00 00       	call   80106100 <getcallerpcs>
  for(i=0; i<10; i++)
8010049d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004a0:	83 ec 08             	sub    $0x8,%esp
801004a3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004a5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004a8:	68 a1 92 10 80       	push   $0x801092a1
801004ad:	e8 2e 03 00 00       	call   801007e0 <cprintf>
  for(i=0; i<10; i++)
801004b2:	83 c4 10             	add    $0x10,%esp
801004b5:	39 f3                	cmp    %esi,%ebx
801004b7:	75 e7                	jne    801004a0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004b9:	c7 05 fc 1a 11 80 01 	movl   $0x1,0x80111afc
801004c0:	00 00 00 
  for(;;)
801004c3:	eb fe                	jmp    801004c3 <panic+0x73>
801004c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801004cc:	00 
801004cd:	8d 76 00             	lea    0x0(%esi),%esi

801004d0 <consputc.part.0>:
consputc(int c)
801004d0:	55                   	push   %ebp
801004d1:	89 e5                	mov    %esp,%ebp
801004d3:	57                   	push   %edi
801004d4:	56                   	push   %esi
801004d5:	53                   	push   %ebx
801004d6:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE) {
801004d9:	3d 00 01 00 00       	cmp    $0x100,%eax
801004de:	0f 84 04 01 00 00    	je     801005e8 <consputc.part.0+0x118>
    uartputc(c);
801004e4:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004e7:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004ec:	89 c3                	mov    %eax,%ebx
801004ee:	50                   	push   %eax
801004ef:	e8 ac 78 00 00       	call   80107da0 <uartputc>
801004f4:	b8 0e 00 00 00       	mov    $0xe,%eax
801004f9:	89 fa                	mov    %edi,%edx
801004fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004fc:	be d5 03 00 00       	mov    $0x3d5,%esi
80100501:	89 f2                	mov    %esi,%edx
80100503:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100504:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100507:	89 fa                	mov    %edi,%edx
80100509:	b8 0f 00 00 00       	mov    $0xf,%eax
8010050e:	c1 e1 08             	shl    $0x8,%ecx
80100511:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100512:	89 f2                	mov    %esi,%edx
80100514:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100515:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100518:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
8010051b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010051d:	83 fb 0a             	cmp    $0xa,%ebx
80100520:	75 7e                	jne    801005a0 <consputc.part.0+0xd0>
    pos += 80 - pos%80;
80100522:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100527:	f7 e2                	mul    %edx
80100529:	c1 ea 06             	shr    $0x6,%edx
8010052c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010052f:	c1 e0 04             	shl    $0x4,%eax
80100532:	8d 58 50             	lea    0x50(%eax),%ebx
  if(pos < 0 || pos > 25 * 80)
80100535:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010053b:	0f 8f 89 01 00 00    	jg     801006ca <consputc.part.0+0x1fa>
  if((pos / 80) >= 24) {  // Scroll up.
80100541:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100547:	0f 8f 33 01 00 00    	jg     80100680 <consputc.part.0+0x1b0>
  outb(CRTPORT + 1, pos >> 8);
8010054d:	0f b6 c7             	movzbl %bh,%eax
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
80100550:	8b 3d f8 1a 11 80    	mov    0x80111af8,%edi
  outb(CRTPORT + 1, pos);
80100556:	89 de                	mov    %ebx,%esi
  outb(CRTPORT + 1, pos >> 8);
80100558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
8010055b:	01 df                	add    %ebx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010055d:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100562:	b8 0e 00 00 00       	mov    $0xe,%eax
80100567:	89 da                	mov    %ebx,%edx
80100569:	ee                   	out    %al,(%dx)
8010056a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010056f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100573:	89 ca                	mov    %ecx,%edx
80100575:	ee                   	out    %al,(%dx)
80100576:	b8 0f 00 00 00       	mov    $0xf,%eax
8010057b:	89 da                	mov    %ebx,%edx
8010057d:	ee                   	out    %al,(%dx)
8010057e:	89 f0                	mov    %esi,%eax
80100580:	89 ca                	mov    %ecx,%edx
80100582:	ee                   	out    %al,(%dx)
80100583:	b8 20 07 00 00       	mov    $0x720,%eax
80100588:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
8010058f:	80 
}
80100590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100593:	5b                   	pop    %ebx
80100594:	5e                   	pop    %esi
80100595:	5f                   	pop    %edi
80100596:	5d                   	pop    %ebp
80100597:	c3                   	ret
80100598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010059f:	00 
  for (int i = pos + cap; i > pos; i--)
801005a0:	8b 15 f8 1a 11 80    	mov    0x80111af8,%edx
801005a6:	01 c2                	add    %eax,%edx
801005a8:	39 d0                	cmp    %edx,%eax
801005aa:	7d 22                	jge    801005ce <consputc.part.0+0xfe>
801005ac:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
801005b3:	8d 94 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%edx
801005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[i] = crt[i - 1];
801005c0:	0f b7 31             	movzwl (%ecx),%esi
  for (int i = pos + cap; i > pos; i--)
801005c3:	83 e9 02             	sub    $0x2,%ecx
    crt[i] = crt[i - 1];
801005c6:	66 89 71 04          	mov    %si,0x4(%ecx)
  for (int i = pos + cap; i > pos; i--)
801005ca:	39 ca                	cmp    %ecx,%edx
801005cc:	75 f2                	jne    801005c0 <consputc.part.0+0xf0>
    crt[pos] = (c&0xff) | 0x0700;  // black on white
801005ce:	0f b6 db             	movzbl %bl,%ebx
801005d1:	80 cf 07             	or     $0x7,%bh
801005d4:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801005db:	80 
    pos++;
801005dc:	8d 58 01             	lea    0x1(%eax),%ebx
801005df:	e9 51 ff ff ff       	jmp    80100535 <consputc.part.0+0x65>
801005e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
801005e8:	83 ec 0c             	sub    $0xc,%esp
801005eb:	be d4 03 00 00       	mov    $0x3d4,%esi
801005f0:	6a 08                	push   $0x8
801005f2:	e8 a9 77 00 00       	call   80107da0 <uartputc>
    uartputc(' ');
801005f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005fe:	e8 9d 77 00 00       	call   80107da0 <uartputc>
    uartputc('\b');
80100603:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010060a:	e8 91 77 00 00       	call   80107da0 <uartputc>
8010060f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100614:	89 f2                	mov    %esi,%edx
80100616:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100617:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010061c:	89 ca                	mov    %ecx,%edx
8010061e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010061f:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100622:	89 f2                	mov    %esi,%edx
80100624:	b8 0f 00 00 00       	mov    $0xf,%eax
80100629:	c1 e3 08             	shl    $0x8,%ebx
8010062c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010062d:	89 ca                	mov    %ecx,%edx
8010062f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100630:	0f b6 c8             	movzbl %al,%ecx
  for (int i = pos - 1; i < pos + cap; i++)
80100633:	8b 3d f8 1a 11 80    	mov    0x80111af8,%edi
80100639:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
8010063c:	09 d9                	or     %ebx,%ecx
  for (int i = pos - 1; i < pos + cap; i++)
8010063e:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100641:	8d 34 0f             	lea    (%edi,%ecx,1),%esi
80100644:	8d 84 09 00 80 0b 80 	lea    -0x7ff48000(%ecx,%ecx,1),%eax
8010064b:	89 da                	mov    %ebx,%edx
8010064d:	85 ff                	test   %edi,%edi
8010064f:	78 1b                	js     8010066c <consputc.part.0+0x19c>
80100651:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    crt[i] = crt[i+1];
80100658:	0f b7 08             	movzwl (%eax),%ecx
  for (int i = pos - 1; i < pos + cap; i++)
8010065b:	83 c2 01             	add    $0x1,%edx
8010065e:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i+1];
80100661:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for (int i = pos - 1; i < pos + cap; i++)
80100665:	39 d6                	cmp    %edx,%esi
80100667:	7f ef                	jg     80100658 <consputc.part.0+0x188>
80100669:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    if(pos > 0)
8010066c:	85 c9                	test   %ecx,%ecx
8010066e:	0f 85 c1 fe ff ff    	jne    80100535 <consputc.part.0+0x65>
80100674:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100678:	31 f6                	xor    %esi,%esi
8010067a:	e9 de fe ff ff       	jmp    8010055d <consputc.part.0+0x8d>
8010067f:	90                   	nop
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100680:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100683:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100686:	68 60 0e 00 00       	push   $0xe60
  outb(CRTPORT + 1, pos);
8010068b:	89 fe                	mov    %edi,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010068d:	68 a0 80 0b 80       	push   $0x800b80a0
80100692:	68 00 80 0b 80       	push   $0x800b8000
80100697:	e8 c4 5d 00 00       	call   80106460 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010069c:	b8 80 07 00 00       	mov    $0x780,%eax
801006a1:	83 c4 0c             	add    $0xc,%esp
801006a4:	29 f8                	sub    %edi,%eax
801006a6:	01 c0                	add    %eax,%eax
801006a8:	50                   	push   %eax
801006a9:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801006b0:	6a 00                	push   $0x0
801006b2:	50                   	push   %eax
801006b3:	e8 18 5d 00 00       	call   801063d0 <memset>
  crt[pos + cap] = ' ' | 0x0700; // To put the space in the end of the line 
801006b8:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801006bc:	03 3d f8 1a 11 80    	add    0x80111af8,%edi
801006c2:	83 c4 10             	add    $0x10,%esp
801006c5:	e9 93 fe ff ff       	jmp    8010055d <consputc.part.0+0x8d>
    panic("pos under/overflow");
801006ca:	83 ec 0c             	sub    $0xc,%esp
801006cd:	68 a5 92 10 80       	push   $0x801092a5
801006d2:	e8 79 fd ff ff       	call   80100450 <panic>
801006d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006de:	00 
801006df:	90                   	nop

801006e0 <consolewrite>:
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	57                   	push   %edi
801006e4:	56                   	push   %esi
801006e5:	53                   	push   %ebx
801006e6:	83 ec 18             	sub    $0x18,%esp
801006e9:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801006ec:	ff 75 08             	push   0x8(%ebp)
801006ef:	e8 cc 24 00 00       	call   80102bc0 <iunlock>
  acquire(&cons.lock);
801006f4:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
801006fb:	e8 d0 5b 00 00       	call   801062d0 <acquire>
  for(i = 0; i < n; i++)
80100700:	83 c4 10             	add    $0x10,%esp
80100703:	85 f6                	test   %esi,%esi
80100705:	7e 25                	jle    8010072c <consolewrite+0x4c>
80100707:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010070a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked) {
8010070d:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
    consputc(buf[i] & 0xff);
80100713:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked) {
80100716:	85 d2                	test   %edx,%edx
80100718:	74 06                	je     80100720 <consolewrite+0x40>
  asm volatile("cli");
8010071a:	fa                   	cli
    for(;;)
8010071b:	eb fe                	jmp    8010071b <consolewrite+0x3b>
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
80100720:	e8 ab fd ff ff       	call   801004d0 <consputc.part.0>
  for(i = 0; i < n; i++)
80100725:	83 c3 01             	add    $0x1,%ebx
80100728:	39 fb                	cmp    %edi,%ebx
8010072a:	75 e1                	jne    8010070d <consolewrite+0x2d>
  release(&cons.lock);
8010072c:	83 ec 0c             	sub    $0xc,%esp
8010072f:	68 c0 1a 11 80       	push   $0x80111ac0
80100734:	e8 37 5b 00 00       	call   80106270 <release>
  ilock(ip);
80100739:	58                   	pop    %eax
8010073a:	ff 75 08             	push   0x8(%ebp)
8010073d:	e8 9e 23 00 00       	call   80102ae0 <ilock>
}
80100742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100745:	89 f0                	mov    %esi,%eax
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100750 <printint>:
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	57                   	push   %edi
80100754:	56                   	push   %esi
80100755:	53                   	push   %ebx
80100756:	89 d3                	mov    %edx,%ebx
80100758:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010075b:	85 c0                	test   %eax,%eax
8010075d:	79 05                	jns    80100764 <printint+0x14>
8010075f:	83 e1 01             	and    $0x1,%ecx
80100762:	75 64                	jne    801007c8 <printint+0x78>
    x = xx;
80100764:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010076b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010076d:	31 f6                	xor    %esi,%esi
8010076f:	90                   	nop
    buf[i++] = digits[x % base];
80100770:	89 c8                	mov    %ecx,%eax
80100772:	31 d2                	xor    %edx,%edx
80100774:	89 f7                	mov    %esi,%edi
80100776:	f7 f3                	div    %ebx
80100778:	8d 76 01             	lea    0x1(%esi),%esi
8010077b:	0f b6 92 7c 98 10 80 	movzbl -0x7fef6784(%edx),%edx
80100782:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100786:	89 ca                	mov    %ecx,%edx
80100788:	89 c1                	mov    %eax,%ecx
8010078a:	39 da                	cmp    %ebx,%edx
8010078c:	73 e2                	jae    80100770 <printint+0x20>
  if(sign)
8010078e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100791:	85 c9                	test   %ecx,%ecx
80100793:	74 07                	je     8010079c <printint+0x4c>
    buf[i++] = '-';
80100795:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010079a:	89 f7                	mov    %esi,%edi
8010079c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010079f:	01 df                	add    %ebx,%edi
  if(panicked) {
801007a1:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
    consputc(buf[i]);
801007a7:	0f be 07             	movsbl (%edi),%eax
  if(panicked) {
801007aa:	85 d2                	test   %edx,%edx
801007ac:	74 0a                	je     801007b8 <printint+0x68>
801007ae:	fa                   	cli
    for(;;)
801007af:	eb fe                	jmp    801007af <printint+0x5f>
801007b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007b8:	e8 13 fd ff ff       	call   801004d0 <consputc.part.0>
  while(--i >= 0)
801007bd:	8d 47 ff             	lea    -0x1(%edi),%eax
801007c0:	39 df                	cmp    %ebx,%edi
801007c2:	74 11                	je     801007d5 <printint+0x85>
801007c4:	89 c7                	mov    %eax,%edi
801007c6:	eb d9                	jmp    801007a1 <printint+0x51>
    x = -xx;
801007c8:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
801007ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801007d1:	89 c1                	mov    %eax,%ecx
801007d3:	eb 98                	jmp    8010076d <printint+0x1d>
}
801007d5:	83 c4 2c             	add    $0x2c,%esp
801007d8:	5b                   	pop    %ebx
801007d9:	5e                   	pop    %esi
801007da:	5f                   	pop    %edi
801007db:	5d                   	pop    %ebp
801007dc:	c3                   	ret
801007dd:	8d 76 00             	lea    0x0(%esi),%esi

801007e0 <cprintf>:
{
801007e0:	55                   	push   %ebp
801007e1:	89 e5                	mov    %esp,%ebp
801007e3:	57                   	push   %edi
801007e4:	56                   	push   %esi
801007e5:	53                   	push   %ebx
801007e6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007e9:	8b 3d f4 1a 11 80    	mov    0x80111af4,%edi
  if (fmt == 0)
801007ef:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801007f2:	85 ff                	test   %edi,%edi
801007f4:	0f 85 06 01 00 00    	jne    80100900 <cprintf+0x120>
  if (fmt == 0)
801007fa:	85 f6                	test   %esi,%esi
801007fc:	0f 84 b7 01 00 00    	je     801009b9 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100802:	0f b6 06             	movzbl (%esi),%eax
80100805:	85 c0                	test   %eax,%eax
80100807:	74 5f                	je     80100868 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
80100809:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010080f:	31 db                	xor    %ebx,%ebx
80100811:	89 d7                	mov    %edx,%edi
    if(c != '%'){
80100813:	83 f8 25             	cmp    $0x25,%eax
80100816:	75 58                	jne    80100870 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100818:	83 c3 01             	add    $0x1,%ebx
8010081b:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
8010081f:	85 c9                	test   %ecx,%ecx
80100821:	74 3a                	je     8010085d <cprintf+0x7d>
    switch(c){
80100823:	83 f9 70             	cmp    $0x70,%ecx
80100826:	0f 84 b4 00 00 00    	je     801008e0 <cprintf+0x100>
8010082c:	7f 72                	jg     801008a0 <cprintf+0xc0>
8010082e:	83 f9 25             	cmp    $0x25,%ecx
80100831:	74 4d                	je     80100880 <cprintf+0xa0>
80100833:	83 f9 64             	cmp    $0x64,%ecx
80100836:	75 76                	jne    801008ae <cprintf+0xce>
      printint(*argp++, 10, 1);
80100838:	8d 47 04             	lea    0x4(%edi),%eax
8010083b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100840:	ba 0a 00 00 00       	mov    $0xa,%edx
80100845:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100848:	8b 07                	mov    (%edi),%eax
8010084a:	e8 01 ff ff ff       	call   80100750 <printint>
8010084f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100852:	83 c3 01             	add    $0x1,%ebx
80100855:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100859:	85 c0                	test   %eax,%eax
8010085b:	75 b6                	jne    80100813 <cprintf+0x33>
8010085d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100860:	85 ff                	test   %edi,%edi
80100862:	0f 85 bb 00 00 00    	jne    80100923 <cprintf+0x143>
}
80100868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086b:	5b                   	pop    %ebx
8010086c:	5e                   	pop    %esi
8010086d:	5f                   	pop    %edi
8010086e:	5d                   	pop    %ebp
8010086f:	c3                   	ret
  if(panicked) {
80100870:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
80100876:	85 c9                	test   %ecx,%ecx
80100878:	74 19                	je     80100893 <cprintf+0xb3>
8010087a:	fa                   	cli
    for(;;)
8010087b:	eb fe                	jmp    8010087b <cprintf+0x9b>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked) {
80100880:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
80100886:	85 c9                	test   %ecx,%ecx
80100888:	0f 85 f2 00 00 00    	jne    80100980 <cprintf+0x1a0>
8010088e:	b8 25 00 00 00       	mov    $0x25,%eax
80100893:	e8 38 fc ff ff       	call   801004d0 <consputc.part.0>
      break;
80100898:	eb b8                	jmp    80100852 <cprintf+0x72>
8010089a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 f9 73             	cmp    $0x73,%ecx
801008a3:	0f 84 8f 00 00 00    	je     80100938 <cprintf+0x158>
801008a9:	83 f9 78             	cmp    $0x78,%ecx
801008ac:	74 32                	je     801008e0 <cprintf+0x100>
  if(panicked) {
801008ae:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
801008b4:	85 d2                	test   %edx,%edx
801008b6:	0f 85 b8 00 00 00    	jne    80100974 <cprintf+0x194>
801008bc:	b8 25 00 00 00       	mov    $0x25,%eax
801008c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801008c4:	e8 07 fc ff ff       	call   801004d0 <consputc.part.0>
801008c9:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
801008ce:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801008d1:	85 c0                	test   %eax,%eax
801008d3:	0f 84 cd 00 00 00    	je     801009a6 <cprintf+0x1c6>
801008d9:	fa                   	cli
    for(;;)
801008da:	eb fe                	jmp    801008da <cprintf+0xfa>
801008dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801008e0:	8d 47 04             	lea    0x4(%edi),%eax
801008e3:	31 c9                	xor    %ecx,%ecx
801008e5:	ba 10 00 00 00       	mov    $0x10,%edx
801008ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008ed:	8b 07                	mov    (%edi),%eax
801008ef:	e8 5c fe ff ff       	call   80100750 <printint>
801008f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801008f7:	e9 56 ff ff ff       	jmp    80100852 <cprintf+0x72>
801008fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100900:	83 ec 0c             	sub    $0xc,%esp
80100903:	68 c0 1a 11 80       	push   $0x80111ac0
80100908:	e8 c3 59 00 00       	call   801062d0 <acquire>
  if (fmt == 0)
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	85 f6                	test   %esi,%esi
80100912:	0f 84 a1 00 00 00    	je     801009b9 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100918:	0f b6 06             	movzbl (%esi),%eax
8010091b:	85 c0                	test   %eax,%eax
8010091d:	0f 85 e6 fe ff ff    	jne    80100809 <cprintf+0x29>
    release(&cons.lock);
80100923:	83 ec 0c             	sub    $0xc,%esp
80100926:	68 c0 1a 11 80       	push   $0x80111ac0
8010092b:	e8 40 59 00 00       	call   80106270 <release>
80100930:	83 c4 10             	add    $0x10,%esp
80100933:	e9 30 ff ff ff       	jmp    80100868 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100938:	8b 17                	mov    (%edi),%edx
8010093a:	8d 47 04             	lea    0x4(%edi),%eax
8010093d:	85 d2                	test   %edx,%edx
8010093f:	74 27                	je     80100968 <cprintf+0x188>
      for(; *s; s++)
80100941:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100944:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100946:	84 c9                	test   %cl,%cl
80100948:	74 68                	je     801009b2 <cprintf+0x1d2>
8010094a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010094d:	89 fb                	mov    %edi,%ebx
8010094f:	89 f7                	mov    %esi,%edi
80100951:	89 c6                	mov    %eax,%esi
80100953:	0f be c1             	movsbl %cl,%eax
  if(panicked) {
80100956:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
8010095c:	85 d2                	test   %edx,%edx
8010095e:	74 28                	je     80100988 <cprintf+0x1a8>
80100960:	fa                   	cli
    for(;;)
80100961:	eb fe                	jmp    80100961 <cprintf+0x181>
80100963:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100968:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010096d:	bf b8 92 10 80       	mov    $0x801092b8,%edi
80100972:	eb d6                	jmp    8010094a <cprintf+0x16a>
80100974:	fa                   	cli
    for(;;)
80100975:	eb fe                	jmp    80100975 <cprintf+0x195>
80100977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010097e:	00 
8010097f:	90                   	nop
80100980:	fa                   	cli
80100981:	eb fe                	jmp    80100981 <cprintf+0x1a1>
80100983:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100988:	e8 43 fb ff ff       	call   801004d0 <consputc.part.0>
      for(; *s; s++)
8010098d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100991:	83 c3 01             	add    $0x1,%ebx
80100994:	84 c0                	test   %al,%al
80100996:	75 be                	jne    80100956 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100998:	89 f0                	mov    %esi,%eax
8010099a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010099d:	89 fe                	mov    %edi,%esi
8010099f:	89 c7                	mov    %eax,%edi
801009a1:	e9 ac fe ff ff       	jmp    80100852 <cprintf+0x72>
801009a6:	89 c8                	mov    %ecx,%eax
801009a8:	e8 23 fb ff ff       	call   801004d0 <consputc.part.0>
      break;
801009ad:	e9 a0 fe ff ff       	jmp    80100852 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
801009b2:	89 c7                	mov    %eax,%edi
801009b4:	e9 99 fe ff ff       	jmp    80100852 <cprintf+0x72>
    panic("null fmt");
801009b9:	83 ec 0c             	sub    $0xc,%esp
801009bc:	68 bf 92 10 80       	push   $0x801092bf
801009c1:	e8 8a fa ff ff       	call   80100450 <panic>
801009c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801009cd:	00 
801009ce:	66 90                	xchg   %ax,%ax

801009d0 <shift_forward_crt>:
{
801009d0:	55                   	push   %ebp
  for (int i = pos + cap; i > pos; i--)
801009d1:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
{
801009d6:	89 e5                	mov    %esp,%ebp
801009d8:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i = pos + cap; i > pos; i--)
801009db:	01 d0                	add    %edx,%eax
801009dd:	39 c2                	cmp    %eax,%edx
801009df:	7d 1d                	jge    801009fe <shift_forward_crt+0x2e>
801009e1:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
801009e8:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
801009ef:	90                   	nop
    crt[i] = crt[i - 1];
801009f0:	0f b7 10             	movzwl (%eax),%edx
  for (int i = pos + cap; i > pos; i--)
801009f3:	83 e8 02             	sub    $0x2,%eax
    crt[i] = crt[i - 1];
801009f6:	66 89 50 04          	mov    %dx,0x4(%eax)
  for (int i = pos + cap; i > pos; i--)
801009fa:	39 c8                	cmp    %ecx,%eax
801009fc:	75 f2                	jne    801009f0 <shift_forward_crt+0x20>
}
801009fe:	5d                   	pop    %ebp
801009ff:	c3                   	ret

80100a00 <shift_back_crt>:
{
80100a00:	55                   	push   %ebp
  for (int i = pos - 1; i < pos + cap; i++)
80100a01:	8b 0d f8 1a 11 80    	mov    0x80111af8,%ecx
{
80100a07:	89 e5                	mov    %esp,%ebp
80100a09:	53                   	push   %ebx
80100a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  for (int i = pos - 1; i < pos + cap; i++)
80100a0d:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80100a10:	85 c9                	test   %ecx,%ecx
80100a12:	78 1d                	js     80100a31 <shift_back_crt+0x31>
80100a14:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a17:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
80100a1e:	66 90                	xchg   %ax,%ax
    crt[i] = crt[i+1];
80100a20:	0f b7 08             	movzwl (%eax),%ecx
  for (int i = pos - 1; i < pos + cap; i++)
80100a23:	83 c2 01             	add    $0x1,%edx
80100a26:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i+1];
80100a29:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for (int i = pos - 1; i < pos + cap; i++)
80100a2d:	39 da                	cmp    %ebx,%edx
80100a2f:	7c ef                	jl     80100a20 <shift_back_crt+0x20>
}
80100a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a34:	c9                   	leave
80100a35:	c3                   	ret
80100a36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a3d:	00 
80100a3e:	66 90                	xchg   %ax,%ax

80100a40 <pow>:
{
80100a40:	55                   	push   %ebp
80100a41:	89 e5                	mov    %esp,%ebp
80100a43:	53                   	push   %ebx
80100a44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100a47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for (int i = 0; i < power; i++)
80100a4a:	85 db                	test   %ebx,%ebx
80100a4c:	7e 3a                	jle    80100a88 <pow+0x48>
80100a4e:	31 d2                	xor    %edx,%edx
  int result = 1;
80100a50:	b8 01 00 00 00       	mov    $0x1,%eax
80100a55:	f6 c3 01             	test   $0x1,%bl
80100a58:	74 16                	je     80100a70 <pow+0x30>
    result = result * base;
80100a5a:	89 c8                	mov    %ecx,%eax
  for (int i = 0; i < power; i++)
80100a5c:	ba 01 00 00 00       	mov    $0x1,%edx
80100a61:	83 fb 01             	cmp    $0x1,%ebx
80100a64:	74 17                	je     80100a7d <pow+0x3d>
80100a66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a6d:	00 
80100a6e:	66 90                	xchg   %ax,%ax
    result = result * base;
80100a70:	0f af c1             	imul   %ecx,%eax
  for (int i = 0; i < power; i++)
80100a73:	83 c2 02             	add    $0x2,%edx
    result = result * base;
80100a76:	0f af c1             	imul   %ecx,%eax
  for (int i = 0; i < power; i++)
80100a79:	39 d3                	cmp    %edx,%ebx
80100a7b:	75 f3                	jne    80100a70 <pow+0x30>
}
80100a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a80:	c9                   	leave
80100a81:	c3                   	ret
80100a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  int result = 1;
80100a8b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80100a90:	c9                   	leave
80100a91:	c3                   	ret
80100a92:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a99:	00 
80100a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100aa0 <makeChangeInPos>:
{
80100aa0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100aa1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100aa6:	89 e5                	mov    %esp,%ebp
80100aa8:	56                   	push   %esi
80100aa9:	be d4 03 00 00       	mov    $0x3d4,%esi
80100aae:	53                   	push   %ebx
80100aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ab2:	89 f2                	mov    %esi,%edx
80100ab4:	ee                   	out    %al,(%dx)
80100ab5:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
80100aba:	89 c8                	mov    %ecx,%eax
80100abc:	c1 f8 08             	sar    $0x8,%eax
80100abf:	89 da                	mov    %ebx,%edx
80100ac1:	ee                   	out    %al,(%dx)
80100ac2:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ac7:	89 f2                	mov    %esi,%edx
80100ac9:	ee                   	out    %al,(%dx)
80100aca:	89 c8                	mov    %ecx,%eax
80100acc:	89 da                	mov    %ebx,%edx
80100ace:	ee                   	out    %al,(%dx)
}
80100acf:	5b                   	pop    %ebx
80100ad0:	5e                   	pop    %esi
80100ad1:	5d                   	pop    %ebp
80100ad2:	c3                   	ret
80100ad3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ada:	00 
80100adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100ae0 <getLastCommand>:
{
80100ae0:	55                   	push   %ebp
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100ae1:	80 3d 80 0e 11 80 00 	cmpb   $0x0,0x80110e80
{
80100ae8:	89 e5                	mov    %esp,%ebp
80100aea:	56                   	push   %esi
80100aeb:	8b 55 08             	mov    0x8(%ebp),%edx
80100aee:	53                   	push   %ebx
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100aef:	0f 84 90 00 00 00    	je     80100b85 <getLastCommand+0xa5>
80100af5:	31 f6                	xor    %esi,%esi
80100af7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100afe:	00 
80100aff:	90                   	nop
80100b00:	89 f0                	mov    %esi,%eax
80100b02:	83 c6 01             	add    $0x1,%esi
80100b05:	80 be 80 0e 11 80 00 	cmpb   $0x0,-0x7feef180(%esi)
80100b0c:	75 f2                	jne    80100b00 <getLastCommand+0x20>
    if (input.buf[k] == '\n')
80100b0e:	80 b8 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%eax)
80100b15:	74 17                	je     80100b2e <getLastCommand+0x4e>
80100b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b1e:	00 
80100b1f:	90                   	nop
  for (k = i-1; (k != -1); k--)
80100b20:	83 e8 01             	sub    $0x1,%eax
80100b23:	72 17                	jb     80100b3c <getLastCommand+0x5c>
    if (input.buf[k] == '\n')
80100b25:	80 b8 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%eax)
80100b2c:	75 f2                	jne    80100b20 <getLastCommand+0x40>
      if (numberOfIgnore == 0)
80100b2e:	85 d2                	test   %edx,%edx
80100b30:	74 4e                	je     80100b80 <getLastCommand+0xa0>
        numberOfIgnore--;
80100b32:	83 ea 01             	sub    $0x1,%edx
        i = k;
80100b35:	89 c6                	mov    %eax,%esi
  for (k = i-1; (k != -1); k--)
80100b37:	83 e8 01             	sub    $0x1,%eax
80100b3a:	73 e9                	jae    80100b25 <getLastCommand+0x45>
80100b3c:	31 d2                	xor    %edx,%edx
  for (h = k+1; h < i; h++)
80100b3e:	39 f2                	cmp    %esi,%edx
80100b40:	7d 43                	jge    80100b85 <getLastCommand+0xa5>
    result[h-k-1] = input.buf[h];
80100b42:	89 c3                	mov    %eax,%ebx
80100b44:	f7 db                	neg    %ebx
80100b46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b4d:	00 
80100b4e:	66 90                	xchg   %ax,%ax
80100b50:	0f b6 8a 80 0e 11 80 	movzbl -0x7feef180(%edx),%ecx
80100b57:	88 8c 13 3f 1a 11 80 	mov    %cl,-0x7feee5c1(%ebx,%edx,1)
  for (h = k+1; h < i; h++)
80100b5e:	83 c2 01             	add    $0x1,%edx
80100b61:	39 f2                	cmp    %esi,%edx
80100b63:	75 eb                	jne    80100b50 <getLastCommand+0x70>
  result[h-k-1] = '\0';
80100b65:	29 c2                	sub    %eax,%edx
}
80100b67:	5b                   	pop    %ebx
80100b68:	b8 40 1a 11 80       	mov    $0x80111a40,%eax
80100b6d:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100b6e:	83 ea 01             	sub    $0x1,%edx
}
80100b71:	5d                   	pop    %ebp
  result[h-k-1] = '\0';
80100b72:	c6 82 40 1a 11 80 00 	movb   $0x0,-0x7feee5c0(%edx)
}
80100b79:	c3                   	ret
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (h = k+1; h < i; h++)
80100b80:	8d 50 01             	lea    0x1(%eax),%edx
80100b83:	eb b9                	jmp    80100b3e <getLastCommand+0x5e>
80100b85:	31 d2                	xor    %edx,%edx
}
80100b87:	5b                   	pop    %ebx
80100b88:	b8 40 1a 11 80       	mov    $0x80111a40,%eax
80100b8d:	5e                   	pop    %esi
  result[h-k-1] = '\0';
80100b8e:	c6 82 40 1a 11 80 00 	movb   $0x0,-0x7feee5c0(%edx)
}
80100b95:	5d                   	pop    %ebp
80100b96:	c3                   	ret
80100b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b9e:	00 
80100b9f:	90                   	nop

80100ba0 <addNewCommandToHistory>:
{
80100ba0:	55                   	push   %ebp
80100ba1:	89 e5                	mov    %esp,%ebp
80100ba3:	57                   	push   %edi
80100ba4:	56                   	push   %esi
  for (int i = 0; i < HISTORYSIZE; i++)
80100ba5:	31 f6                	xor    %esi,%esi
{
80100ba7:	53                   	push   %ebx
80100ba8:	83 ec 1c             	sub    $0x1c,%esp
80100bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (historyBuf[i][0] == '\0')
80100bb0:	89 f0                	mov    %esi,%eax
80100bb2:	c1 e0 07             	shl    $0x7,%eax
80100bb5:	80 b8 40 15 11 80 00 	cmpb   $0x0,-0x7feeeac0(%eax)
80100bbc:	74 64                	je     80100c22 <addNewCommandToHistory+0x82>
  for (int i = 0; i < HISTORYSIZE; i++)
80100bbe:	83 c6 01             	add    $0x1,%esi
80100bc1:	83 fe 0a             	cmp    $0xa,%esi
80100bc4:	75 ea                	jne    80100bb0 <addNewCommandToHistory+0x10>
  int freeIndex = HISTORYSIZE-1;
80100bc6:	be 09 00 00 00       	mov    $0x9,%esi
80100bcb:	89 f3                	mov    %esi,%ebx
80100bcd:	c1 e3 07             	shl    $0x7,%ebx
80100bd0:	8d 7b 80             	lea    -0x80(%ebx),%edi
80100bd3:	89 f9                	mov    %edi,%ecx
80100bd5:	8d 76 00             	lea    0x0(%esi),%esi
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100bd8:	0f b6 91 40 15 11 80 	movzbl -0x7feeeac0(%ecx),%edx
80100bdf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80100be2:	31 c0                	xor    %eax,%eax
80100be4:	83 ee 01             	sub    $0x1,%esi
80100be7:	84 d2                	test   %dl,%dl
80100be9:	74 1b                	je     80100c06 <addNewCommandToHistory+0x66>
80100beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      historyBuf[i][j] = historyBuf[i-1][j];
80100bf0:	88 94 03 40 15 11 80 	mov    %dl,-0x7feeeac0(%ebx,%eax,1)
    for (j = 0; historyBuf[i-1][j] != '\0'; j++)
80100bf7:	83 c0 01             	add    $0x1,%eax
80100bfa:	0f b6 94 01 40 15 11 	movzbl -0x7feeeac0(%ecx,%eax,1),%edx
80100c01:	80 
80100c02:	84 d2                	test   %dl,%dl
80100c04:	75 ea                	jne    80100bf0 <addNewCommandToHistory+0x50>
    historyBuf[i][j] = '\0';
80100c06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (int i = freeIndex; i >= 1; i--)
80100c09:	89 fb                	mov    %edi,%ebx
80100c0b:	83 c1 80             	add    $0xffffff80,%ecx
    historyBuf[i][j] = '\0';
80100c0e:	c1 e2 07             	shl    $0x7,%edx
80100c11:	c6 84 10 40 15 11 80 	movb   $0x0,-0x7feeeac0(%eax,%edx,1)
80100c18:	00 
  for (int i = freeIndex; i >= 1; i--)
80100c19:	85 f6                	test   %esi,%esi
80100c1b:	74 13                	je     80100c30 <addNewCommandToHistory+0x90>
80100c1d:	83 c7 80             	add    $0xffffff80,%edi
80100c20:	eb b6                	jmp    80100bd8 <addNewCommandToHistory+0x38>
80100c22:	85 f6                	test   %esi,%esi
80100c24:	75 a5                	jne    80100bcb <addNewCommandToHistory+0x2b>
80100c26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c2d:	00 
80100c2e:	66 90                	xchg   %ax,%ax
  char* res = getLastCommand(0);
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	6a 00                	push   $0x0
80100c35:	e8 a6 fe ff ff       	call   80100ae0 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100c3a:	83 c4 10             	add    $0x10,%esp
80100c3d:	31 d2                	xor    %edx,%edx
80100c3f:	0f b6 08             	movzbl (%eax),%ecx
80100c42:	84 c9                	test   %cl,%cl
80100c44:	74 1b                	je     80100c61 <addNewCommandToHistory+0xc1>
80100c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c4d:	00 
80100c4e:	66 90                	xchg   %ax,%ax
    historyBuf[0][i] = res[i];
80100c50:	88 8a 40 15 11 80    	mov    %cl,-0x7feeeac0(%edx)
  for (i = 0; res[i] != '\0'; i++)
80100c56:	83 c2 01             	add    $0x1,%edx
80100c59:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100c5d:	84 c9                	test   %cl,%cl
80100c5f:	75 ef                	jne    80100c50 <addNewCommandToHistory+0xb0>
  if (historyCurrentSize <= HISTORYSIZE)
80100c61:	a1 24 15 11 80       	mov    0x80111524,%eax
  historyBuf[0][i] = '\0';
80100c66:	c6 82 40 15 11 80 00 	movb   $0x0,-0x7feeeac0(%edx)
  if (historyCurrentSize <= HISTORYSIZE)
80100c6d:	83 f8 0a             	cmp    $0xa,%eax
80100c70:	7f 08                	jg     80100c7a <addNewCommandToHistory+0xda>
    historyCurrentSize = historyCurrentSize + 1;
80100c72:	83 c0 01             	add    $0x1,%eax
80100c75:	a3 24 15 11 80       	mov    %eax,0x80111524
}
80100c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c7d:	5b                   	pop    %ebx
80100c7e:	5e                   	pop    %esi
80100c7f:	5f                   	pop    %edi
80100c80:	5d                   	pop    %ebp
80100c81:	c3                   	ret
80100c82:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c89:	00 
80100c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100c90 <makeBufferEmpty>:
{
80100c90:	55                   	push   %ebp
80100c91:	89 e5                	mov    %esp,%ebp
80100c93:	53                   	push   %ebx
80100c94:	83 ec 10             	sub    $0x10,%esp
  char* lastCommand = getLastCommand(0);
80100c97:	6a 00                	push   $0x0
80100c99:	e8 42 fe ff ff       	call   80100ae0 <getLastCommand>
  for (int i = 0; i < INPUT_BUF; i++)
80100c9e:	ba 80 0e 11 80       	mov    $0x80110e80,%edx
80100ca3:	83 c4 10             	add    $0x10,%esp
80100ca6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100cad:	00 
80100cae:	66 90                	xchg   %ax,%ax
    input.buf[i] = '\0';
80100cb0:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80100cb6:	83 c2 08             	add    $0x8,%edx
80100cb9:	c7 42 fc 00 00 00 00 	movl   $0x0,-0x4(%edx)
  for (int i = 0; i < INPUT_BUF; i++)
80100cc0:	81 fa 00 0f 11 80    	cmp    $0x80110f00,%edx
80100cc6:	75 e8                	jne    80100cb0 <makeBufferEmpty+0x20>
  for (i = 0; lastCommand[i] != '\0'; i++)
80100cc8:	0f b6 08             	movzbl (%eax),%ecx
80100ccb:	84 c9                	test   %cl,%cl
80100ccd:	74 27                	je     80100cf6 <makeBufferEmpty+0x66>
80100ccf:	31 d2                	xor    %edx,%edx
80100cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    input.buf[i] = lastCommand[i];
80100cd8:	88 8a 80 0e 11 80    	mov    %cl,-0x7feef180(%edx)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100cde:	83 c2 01             	add    $0x1,%edx
80100ce1:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80100ce5:	89 d3                	mov    %edx,%ebx
80100ce7:	84 c9                	test   %cl,%cl
80100ce9:	75 ed                	jne    80100cd8 <makeBufferEmpty+0x48>
  input.e = i;
80100ceb:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
}
80100cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf4:	c9                   	leave
80100cf5:	c3                   	ret
  for (i = 0; lastCommand[i] != '\0'; i++)
80100cf6:	31 db                	xor    %ebx,%ebx
  input.e = i;
80100cf8:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
}
80100cfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d01:	c9                   	leave
80100d02:	c3                   	ret
80100d03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d0a:	00 
80100d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100d10 <checkBufferNeedEmpty>:
  for (int i = 0; input.buf[i] != '\0'; i++)
80100d10:	31 c0                	xor    %eax,%eax
80100d12:	80 3d 80 0e 11 80 00 	cmpb   $0x0,0x80110e80
80100d19:	75 0a                	jne    80100d25 <checkBufferNeedEmpty+0x15>
80100d1b:	c3                   	ret
80100d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (i > INPUT_BUF-3)
80100d20:	83 f8 7e             	cmp    $0x7e,%eax
80100d23:	74 0d                	je     80100d32 <checkBufferNeedEmpty+0x22>
  for (int i = 0; input.buf[i] != '\0'; i++)
80100d25:	83 c0 01             	add    $0x1,%eax
80100d28:	80 b8 80 0e 11 80 00 	cmpb   $0x0,-0x7feef180(%eax)
80100d2f:	75 ef                	jne    80100d20 <checkBufferNeedEmpty+0x10>
}
80100d31:	c3                   	ret
      makeBufferEmpty();
80100d32:	e9 59 ff ff ff       	jmp    80100c90 <makeBufferEmpty>
80100d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d3e:	00 
80100d3f:	90                   	nop

80100d40 <putLastCommandBuf>:
{
80100d40:	55                   	push   %ebp
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100d41:	31 c0                	xor    %eax,%eax
80100d43:	80 3d 80 0e 11 80 00 	cmpb   $0x0,0x80110e80
{
80100d4a:	89 e5                	mov    %esp,%ebp
80100d4c:	53                   	push   %ebx
80100d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = 0; input.buf[i] != '\0' && i < INPUT_BUF; i++)
80100d50:	74 76                	je     80100dc8 <putLastCommandBuf+0x88>
80100d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d58:	89 c2                	mov    %eax,%edx
80100d5a:	83 c0 01             	add    $0x1,%eax
80100d5d:	80 b8 80 0e 11 80 00 	cmpb   $0x0,-0x7feef180(%eax)
80100d64:	75 f2                	jne    80100d58 <putLastCommandBuf+0x18>
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
80100d66:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100d6d:	75 0e                	jne    80100d7d <putLastCommandBuf+0x3d>
80100d6f:	eb 1a                	jmp    80100d8b <putLastCommandBuf+0x4b>
80100d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d78:	83 fa ff             	cmp    $0xffffffff,%edx
80100d7b:	74 43                	je     80100dc0 <putLastCommandBuf+0x80>
80100d7d:	89 d0                	mov    %edx,%eax
80100d7f:	83 ea 01             	sub    $0x1,%edx
80100d82:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100d89:	75 ed                	jne    80100d78 <putLastCommandBuf+0x38>
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100d8b:	0f b6 0b             	movzbl (%ebx),%ecx
80100d8e:	84 c9                	test   %cl,%cl
80100d90:	74 18                	je     80100daa <putLastCommandBuf+0x6a>
80100d92:	29 d3                	sub    %edx,%ebx
80100d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    input.buf[h] = changedCommand[h-k-1];
80100d98:	88 88 80 0e 11 80    	mov    %cl,-0x7feef180(%eax)
  for (h = k+1; changedCommand[h-k-1] != '\0'; h++)
80100d9e:	83 c0 01             	add    $0x1,%eax
80100da1:	0f b6 4c 03 ff       	movzbl -0x1(%ebx,%eax,1),%ecx
80100da6:	84 c9                	test   %cl,%cl
80100da8:	75 ee                	jne    80100d98 <putLastCommandBuf+0x58>
  input.buf[h] = '\0';
80100daa:	c6 80 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%eax)
}
80100db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  input.e = h;
80100db4:	a3 08 0f 11 80       	mov    %eax,0x80110f08
}
80100db9:	c9                   	leave
80100dba:	c3                   	ret
80100dbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100dc0:	31 c0                	xor    %eax,%eax
80100dc2:	eb c7                	jmp    80100d8b <putLastCommandBuf+0x4b>
80100dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (k = i-1; (input.buf[k] != '\n' && k != -1); k--)
80100dc8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80100dcd:	eb bc                	jmp    80100d8b <putLastCommandBuf+0x4b>
80100dcf:	90                   	nop

80100dd0 <clearTheInputLine>:
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	57                   	push   %edi
80100dd4:	bf 0e 00 00 00       	mov    $0xe,%edi
80100dd9:	56                   	push   %esi
80100dda:	be d4 03 00 00       	mov    $0x3d4,%esi
80100ddf:	89 f8                	mov    %edi,%eax
80100de1:	53                   	push   %ebx
80100de2:	89 f2                	mov    %esi,%edx
80100de4:	83 ec 18             	sub    $0x18,%esp
80100de7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100de8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100ded:	89 da                	mov    %ebx,%edx
80100def:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100df0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100df3:	89 f2                	mov    %esi,%edx
80100df5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100dfa:	c1 e1 08             	shl    $0x8,%ecx
80100dfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dfe:	89 da                	mov    %ebx,%edx
80100e00:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100e01:	0f b6 c0             	movzbl %al,%eax
80100e04:	09 c1                	or     %eax,%ecx
  for (int i = 0; i < cap; i++)
80100e06:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
80100e0b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80100e0e:	85 c0                	test   %eax,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e10:	89 f8                	mov    %edi,%eax
80100e12:	0f 4f ca             	cmovg  %edx,%ecx
80100e15:	89 f2                	mov    %esi,%edx
80100e17:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100e18:	89 cf                	mov    %ecx,%edi
80100e1a:	89 da                	mov    %ebx,%edx
80100e1c:	c1 ff 08             	sar    $0x8,%edi
80100e1f:	89 f8                	mov    %edi,%eax
80100e21:	ee                   	out    %al,(%dx)
80100e22:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e27:	89 f2                	mov    %esi,%edx
80100e29:	ee                   	out    %al,(%dx)
80100e2a:	89 c8                	mov    %ecx,%eax
80100e2c:	89 da                	mov    %ebx,%edx
80100e2e:	ee                   	out    %al,(%dx)
  cap = 0;
80100e2f:	c7 05 f8 1a 11 80 00 	movl   $0x0,0x80111af8
80100e36:	00 00 00 
  char* res = getLastCommand(0);
80100e39:	6a 00                	push   $0x0
80100e3b:	e8 a0 fc ff ff       	call   80100ae0 <getLastCommand>
  for (i = 0; res[i] != '\0'; i++)
80100e40:	83 c4 10             	add    $0x10,%esp
80100e43:	80 38 00             	cmpb   $0x0,(%eax)
80100e46:	74 2b                	je     80100e73 <clearTheInputLine+0xa3>
80100e48:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100e4b:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
80100e50:	85 c0                	test   %eax,%eax
80100e52:	74 0c                	je     80100e60 <clearTheInputLine+0x90>
  asm volatile("cli");
80100e54:	fa                   	cli
    for(;;)
80100e55:	eb fe                	jmp    80100e55 <clearTheInputLine+0x85>
80100e57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e5e:	00 
80100e5f:	90                   	nop
80100e60:	b8 00 01 00 00       	mov    $0x100,%eax
  for (i = 0; res[i] != '\0'; i++)
80100e65:	83 c3 01             	add    $0x1,%ebx
80100e68:	e8 63 f6 ff ff       	call   801004d0 <consputc.part.0>
80100e6d:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
80100e71:	75 d8                	jne    80100e4b <clearTheInputLine+0x7b>
}
80100e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e76:	5b                   	pop    %ebx
80100e77:	5e                   	pop    %esi
80100e78:	5f                   	pop    %edi
80100e79:	5d                   	pop    %ebp
80100e7a:	c3                   	ret
80100e7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100e80 <showNewCommand>:
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
80100e84:	83 ec 04             	sub    $0x4,%esp
  upDownKeyIndex--;
80100e87:	83 2d 20 15 11 80 01 	subl   $0x1,0x80111520
  clearTheInputLine();
80100e8e:	e8 3d ff ff ff       	call   80100dd0 <clearTheInputLine>
  if (upDownKeyIndex == 0)
80100e93:	a1 20 15 11 80       	mov    0x80111520,%eax
80100e98:	85 c0                	test   %eax,%eax
80100e9a:	75 4c                	jne    80100ee8 <showNewCommand+0x68>
    putLastCommandBuf(tempBuf);
80100e9c:	83 ec 0c             	sub    $0xc,%esp
80100e9f:	68 a0 14 11 80       	push   $0x801114a0
80100ea4:	e8 97 fe ff ff       	call   80100d40 <putLastCommandBuf>
80100ea9:	83 c4 10             	add    $0x10,%esp
  char* lastCommand = getLastCommand(0);
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	6a 00                	push   $0x0
80100eb1:	e8 2a fc ff ff       	call   80100ae0 <getLastCommand>
  for (int i = 0; message[i] != '\0'; i++)
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	0f b6 10             	movzbl (%eax),%edx
80100ebc:	84 d2                	test   %dl,%dl
80100ebe:	74 23                	je     80100ee3 <showNewCommand+0x63>
80100ec0:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked) {
80100ec3:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
80100ec8:	85 c0                	test   %eax,%eax
80100eca:	74 04                	je     80100ed0 <showNewCommand+0x50>
80100ecc:	fa                   	cli
    for(;;)
80100ecd:	eb fe                	jmp    80100ecd <showNewCommand+0x4d>
80100ecf:	90                   	nop
    consputc(message[i]);
80100ed0:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; message[i] != '\0'; i++)
80100ed3:	83 c3 01             	add    $0x1,%ebx
80100ed6:	e8 f5 f5 ff ff       	call   801004d0 <consputc.part.0>
80100edb:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
80100edf:	84 d2                	test   %dl,%dl
80100ee1:	75 e0                	jne    80100ec3 <showNewCommand+0x43>
}
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave
80100ee7:	c3                   	ret
    putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100ee8:	c1 e0 07             	shl    $0x7,%eax
80100eeb:	83 ec 0c             	sub    $0xc,%esp
80100eee:	05 c0 14 11 80       	add    $0x801114c0,%eax
80100ef3:	50                   	push   %eax
80100ef4:	e8 47 fe ff ff       	call   80100d40 <putLastCommandBuf>
80100ef9:	83 c4 10             	add    $0x10,%esp
80100efc:	eb ae                	jmp    80100eac <showNewCommand+0x2c>
80100efe:	66 90                	xchg   %ax,%ax

80100f00 <showPastCommand>:
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
  if (upDownKeyIndex == 0)
80100f07:	8b 1d 20 15 11 80    	mov    0x80111520,%ebx
80100f0d:	85 db                	test   %ebx,%ebx
80100f0f:	74 67                	je     80100f78 <showPastCommand+0x78>
  upDownKeyIndex++;
80100f11:	83 c3 01             	add    $0x1,%ebx
80100f14:	89 1d 20 15 11 80    	mov    %ebx,0x80111520
  clearTheInputLine();
80100f1a:	e8 b1 fe ff ff       	call   80100dd0 <clearTheInputLine>
  putLastCommandBuf(historyBuf[upDownKeyIndex-1]);
80100f1f:	a1 20 15 11 80       	mov    0x80111520,%eax
80100f24:	83 ec 0c             	sub    $0xc,%esp
80100f27:	c1 e0 07             	shl    $0x7,%eax
80100f2a:	05 c0 14 11 80       	add    $0x801114c0,%eax
80100f2f:	50                   	push   %eax
80100f30:	e8 0b fe ff ff       	call   80100d40 <putLastCommandBuf>
  char* lastCommand = getLastCommand(0);
80100f35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80100f3c:	e8 9f fb ff ff       	call   80100ae0 <getLastCommand>
  for (int i = 0; message[i] != '\0'; i++)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	0f b6 10             	movzbl (%eax),%edx
80100f47:	8d 58 01             	lea    0x1(%eax),%ebx
80100f4a:	84 d2                	test   %dl,%dl
80100f4c:	74 25                	je     80100f73 <showPastCommand+0x73>
  if(panicked) {
80100f4e:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
80100f53:	85 c0                	test   %eax,%eax
80100f55:	74 09                	je     80100f60 <showPastCommand+0x60>
80100f57:	fa                   	cli
    for(;;)
80100f58:	eb fe                	jmp    80100f58 <showPastCommand+0x58>
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(message[i]);
80100f60:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; message[i] != '\0'; i++)
80100f63:	83 c3 01             	add    $0x1,%ebx
80100f66:	e8 65 f5 ff ff       	call   801004d0 <consputc.part.0>
80100f6b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
80100f6f:	84 d2                	test   %dl,%dl
80100f71:	75 db                	jne    80100f4e <showPastCommand+0x4e>
}
80100f73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f76:	c9                   	leave
80100f77:	c3                   	ret
    char* res = getLastCommand(0);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	6a 00                	push   $0x0
80100f7d:	e8 5e fb ff ff       	call   80100ae0 <getLastCommand>
    for (i = 0; res[i] != '\0'; i++)
80100f82:	83 c4 10             	add    $0x10,%esp
80100f85:	0f b6 10             	movzbl (%eax),%edx
80100f88:	84 d2                	test   %dl,%dl
80100f8a:	74 15                	je     80100fa1 <showPastCommand+0xa1>
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      tempBuf[i] = res[i];
80100f90:	88 93 a0 14 11 80    	mov    %dl,-0x7feeeb60(%ebx)
    for (i = 0; res[i] != '\0'; i++)
80100f96:	83 c3 01             	add    $0x1,%ebx
80100f99:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
80100f9d:	84 d2                	test   %dl,%dl
80100f9f:	75 ef                	jne    80100f90 <showPastCommand+0x90>
    tempBuf[i] = '\0';
80100fa1:	c6 83 a0 14 11 80 00 	movb   $0x0,-0x7feeeb60(%ebx)
  upDownKeyIndex++;
80100fa8:	8b 1d 20 15 11 80    	mov    0x80111520,%ebx
80100fae:	e9 5e ff ff ff       	jmp    80100f11 <showPastCommand+0x11>
80100fb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fba:	00 
80100fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100fc0 <checkHistoryCommand>:
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 10             	sub    $0x10,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char checkCommand[] = "history";
80100fca:	c7 45 f4 68 69 73 74 	movl   $0x74736968,-0xc(%ebp)
80100fd1:	c7 45 f8 6f 72 79 00 	movl   $0x79726f,-0x8(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80100fd8:	0f b6 13             	movzbl (%ebx),%edx
80100fdb:	84 d2                	test   %dl,%dl
80100fdd:	74 41                	je     80101020 <checkHistoryCommand+0x60>
80100fdf:	31 c0                	xor    %eax,%eax
  int flag = 1;
80100fe1:	b9 01 00 00 00       	mov    $0x1,%ecx
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax
    if (checkCommand[i] != lastCommand[i] || i > 6)
80100ff0:	38 54 05 f4          	cmp    %dl,-0xc(%ebp,%eax,1)
80100ff4:	75 05                	jne    80100ffb <checkHistoryCommand+0x3b>
80100ff6:	83 f8 06             	cmp    $0x6,%eax
80100ff9:	7e 02                	jle    80100ffd <checkHistoryCommand+0x3d>
      flag = 0;
80100ffb:	31 c9                	xor    %ecx,%ecx
  for (i = 0; lastCommand[i] != '\0'; i++)
80100ffd:	83 c0 01             	add    $0x1,%eax
80101000:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80101004:	84 d2                	test   %dl,%dl
80101006:	75 e8                	jne    80100ff0 <checkHistoryCommand+0x30>
    flag = 0;
80101008:	83 f8 06             	cmp    $0x6,%eax
8010100b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101013:	c9                   	leave
    flag = 0;
80101014:	0f 4e c8             	cmovle %eax,%ecx
}
80101017:	89 c8                	mov    %ecx,%eax
80101019:	c3                   	ret
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    flag = 0;
80101020:	31 c9                	xor    %ecx,%ecx
}
80101022:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101025:	c9                   	leave
80101026:	89 c8                	mov    %ecx,%eax
80101028:	c3                   	ret
80101029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101030 <print>:
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	53                   	push   %ebx
80101034:	83 ec 04             	sub    $0x4,%esp
80101037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = 0; message[i] != '\0'; i++)
8010103a:	0f be 03             	movsbl (%ebx),%eax
8010103d:	84 c0                	test   %al,%al
8010103f:	74 26                	je     80101067 <print+0x37>
80101041:	83 c3 01             	add    $0x1,%ebx
  if(panicked) {
80101044:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
8010104a:	85 d2                	test   %edx,%edx
8010104c:	74 0a                	je     80101058 <print+0x28>
8010104e:	fa                   	cli
    for(;;)
8010104f:	eb fe                	jmp    8010104f <print+0x1f>
80101051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101058:	e8 73 f4 ff ff       	call   801004d0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
8010105d:	0f be 03             	movsbl (%ebx),%eax
80101060:	83 c3 01             	add    $0x1,%ebx
80101063:	84 c0                	test   %al,%al
80101065:	75 dd                	jne    80101044 <print+0x14>
}
80101067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010106a:	c9                   	leave
8010106b:	c3                   	ret
8010106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101070 <doHistoryCommand>:
  if(panicked) {
80101070:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
80101076:	85 c9                	test   %ecx,%ecx
80101078:	74 06                	je     80101080 <doHistoryCommand+0x10>
8010107a:	fa                   	cli
    for(;;)
8010107b:	eb fe                	jmp    8010107b <doHistoryCommand+0xb>
8010107d:	8d 76 00             	lea    0x0(%esi),%esi
{
80101080:	55                   	push   %ebp
80101081:	b8 0a 00 00 00       	mov    $0xa,%eax
80101086:	89 e5                	mov    %esp,%ebp
80101088:	57                   	push   %edi
80101089:	56                   	push   %esi
8010108a:	53                   	push   %ebx
8010108b:	8d 5d c8             	lea    -0x38(%ebp),%ebx
8010108e:	83 ec 3c             	sub    $0x3c,%esp
80101091:	e8 3a f4 ff ff       	call   801004d0 <consputc.part.0>
  char message[] = "here are the lastest commands : ";
80101096:	c7 45 c7 68 65 72 65 	movl   $0x65726568,-0x39(%ebp)
  for (int i = 0; message[i] != '\0'; i++)
8010109d:	b8 68 00 00 00       	mov    $0x68,%eax
  char message[] = "here are the lastest commands : ";
801010a2:	c7 45 cb 20 61 72 65 	movl   $0x65726120,-0x35(%ebp)
801010a9:	c7 45 cf 20 74 68 65 	movl   $0x65687420,-0x31(%ebp)
801010b0:	c7 45 d3 20 6c 61 73 	movl   $0x73616c20,-0x2d(%ebp)
801010b7:	c7 45 d7 74 65 73 74 	movl   $0x74736574,-0x29(%ebp)
801010be:	c7 45 db 20 63 6f 6d 	movl   $0x6d6f6320,-0x25(%ebp)
801010c5:	c7 45 df 6d 61 6e 64 	movl   $0x646e616d,-0x21(%ebp)
801010cc:	c7 45 e3 73 20 3a 20 	movl   $0x203a2073,-0x1d(%ebp)
801010d3:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  if(panicked) {
801010d7:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
801010dd:	85 d2                	test   %edx,%edx
801010df:	74 07                	je     801010e8 <doHistoryCommand+0x78>
801010e1:	fa                   	cli
    for(;;)
801010e2:	eb fe                	jmp    801010e2 <doHistoryCommand+0x72>
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010e8:	e8 e3 f3 ff ff       	call   801004d0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
801010ed:	0f be 03             	movsbl (%ebx),%eax
801010f0:	83 c3 01             	add    $0x1,%ebx
801010f3:	84 c0                	test   %al,%al
801010f5:	75 e0                	jne    801010d7 <doHistoryCommand+0x67>
  if(panicked) {
801010f7:	8b 1d fc 1a 11 80    	mov    0x80111afc,%ebx
801010fd:	85 db                	test   %ebx,%ebx
801010ff:	75 57                	jne    80101158 <doHistoryCommand+0xe8>
80101101:	b8 0a 00 00 00       	mov    $0xa,%eax
80101106:	e8 c5 f3 ff ff       	call   801004d0 <consputc.part.0>
  for (i = 0; i < HISTORYSIZE && historyBuf[i][0] != '\0' ; i++)
8010110b:	89 d8                	mov    %ebx,%eax
8010110d:	c1 e0 07             	shl    $0x7,%eax
80101110:	80 b8 40 15 11 80 00 	cmpb   $0x0,-0x7feeeac0(%eax)
80101117:	0f 84 8b 00 00 00    	je     801011a8 <doHistoryCommand+0x138>
8010111d:	83 c3 01             	add    $0x1,%ebx
80101120:	83 fb 0a             	cmp    $0xa,%ebx
80101123:	75 e6                	jne    8010110b <doHistoryCommand+0x9b>
80101125:	b8 09 00 00 00       	mov    $0x9,%eax
8010112a:	8d 70 01             	lea    0x1(%eax),%esi
8010112d:	c1 e0 07             	shl    $0x7,%eax
80101130:	8d 98 40 15 11 80    	lea    -0x7feeeac0(%eax),%ebx
    printint(i+1,10 ,1);
80101136:	b9 01 00 00 00       	mov    $0x1,%ecx
8010113b:	ba 0a 00 00 00       	mov    $0xa,%edx
80101140:	89 f0                	mov    %esi,%eax
80101142:	e8 09 f6 ff ff       	call   80100750 <printint>
  if(panicked) {
80101147:	8b 3d fc 1a 11 80    	mov    0x80111afc,%edi
8010114d:	85 ff                	test   %edi,%edi
8010114f:	74 0f                	je     80101160 <doHistoryCommand+0xf0>
80101151:	fa                   	cli
    for(;;)
80101152:	eb fe                	jmp    80101152 <doHistoryCommand+0xe2>
80101154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101158:	fa                   	cli
80101159:	eb fe                	jmp    80101159 <doHistoryCommand+0xe9>
8010115b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101160:	b8 3a 00 00 00       	mov    $0x3a,%eax
80101165:	8d 7b 01             	lea    0x1(%ebx),%edi
80101168:	e8 63 f3 ff ff       	call   801004d0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
8010116d:	0f be 03             	movsbl (%ebx),%eax
80101170:	84 c0                	test   %al,%al
80101172:	74 23                	je     80101197 <doHistoryCommand+0x127>
  if(panicked) {
80101174:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
8010117a:	85 d2                	test   %edx,%edx
8010117c:	74 0a                	je     80101188 <doHistoryCommand+0x118>
8010117e:	fa                   	cli
    for(;;)
8010117f:	eb fe                	jmp    8010117f <doHistoryCommand+0x10f>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101188:	e8 43 f3 ff ff       	call   801004d0 <consputc.part.0>
  for (int i = 0; message[i] != '\0'; i++)
8010118d:	0f be 07             	movsbl (%edi),%eax
80101190:	83 c7 01             	add    $0x1,%edi
80101193:	84 c0                	test   %al,%al
80101195:	75 dd                	jne    80101174 <doHistoryCommand+0x104>
  if(panicked) {
80101197:	8b 0d fc 1a 11 80    	mov    0x80111afc,%ecx
8010119d:	85 c9                	test   %ecx,%ecx
8010119f:	74 1a                	je     801011bb <doHistoryCommand+0x14b>
801011a1:	fa                   	cli
    for(;;)
801011a2:	eb fe                	jmp    801011a2 <doHistoryCommand+0x132>
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  i--;
801011a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  for (i ; i >= 0; i--)
801011ab:	85 db                	test   %ebx,%ebx
801011ad:	0f 85 77 ff ff ff    	jne    8010112a <doHistoryCommand+0xba>
}
801011b3:	83 c4 3c             	add    $0x3c,%esp
801011b6:	5b                   	pop    %ebx
801011b7:	5e                   	pop    %esi
801011b8:	5f                   	pop    %edi
801011b9:	5d                   	pop    %ebp
801011ba:	c3                   	ret
801011bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  for (i ; i >= 0; i--)
801011c0:	83 ee 01             	sub    $0x1,%esi
801011c3:	e8 08 f3 ff ff       	call   801004d0 <consputc.part.0>
801011c8:	8d 43 80             	lea    -0x80(%ebx),%eax
801011cb:	81 fb 40 15 11 80    	cmp    $0x80111540,%ebx
801011d1:	74 e0                	je     801011b3 <doHistoryCommand+0x143>
801011d3:	89 c3                	mov    %eax,%ebx
801011d5:	e9 5c ff ff ff       	jmp    80101136 <doHistoryCommand+0xc6>
801011da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011e0 <controlNewCommand>:
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	53                   	push   %ebx
801011e4:	83 ec 20             	sub    $0x20,%esp
  char* lastCommand = getLastCommand(0);
801011e7:	6a 00                	push   $0x0
801011e9:	e8 f2 f8 ff ff       	call   80100ae0 <getLastCommand>
  char checkCommand[] = "history";
801011ee:	c7 45 f0 68 69 73 74 	movl   $0x74736968,-0x10(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
801011f5:	83 c4 10             	add    $0x10,%esp
801011f8:	0f b6 08             	movzbl (%eax),%ecx
  char checkCommand[] = "history";
801011fb:	c7 45 f4 6f 72 79 00 	movl   $0x79726f,-0xc(%ebp)
  for (i = 0; lastCommand[i] != '\0'; i++)
80101202:	84 c9                	test   %cl,%cl
80101204:	74 27                	je     8010122d <controlNewCommand+0x4d>
  int flag = 1;
80101206:	bb 01 00 00 00       	mov    $0x1,%ebx
  for (i = 0; lastCommand[i] != '\0'; i++)
8010120b:	31 d2                	xor    %edx,%edx
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
    if (checkCommand[i] != lastCommand[i] || i > 6)
80101210:	38 4c 15 f0          	cmp    %cl,-0x10(%ebp,%edx,1)
80101214:	75 05                	jne    8010121b <controlNewCommand+0x3b>
80101216:	83 fa 06             	cmp    $0x6,%edx
80101219:	7e 02                	jle    8010121d <controlNewCommand+0x3d>
      flag = 0;
8010121b:	31 db                	xor    %ebx,%ebx
  for (i = 0; lastCommand[i] != '\0'; i++)
8010121d:	83 c2 01             	add    $0x1,%edx
80101220:	0f b6 0c 10          	movzbl (%eax,%edx,1),%ecx
80101224:	84 c9                	test   %cl,%cl
80101226:	75 e8                	jne    80101210 <controlNewCommand+0x30>
  if (i < 7)
80101228:	83 fa 06             	cmp    $0x6,%edx
8010122b:	7f 0b                	jg     80101238 <controlNewCommand+0x58>
}
8010122d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101230:	c9                   	leave
80101231:	c3                   	ret
80101232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (checkHistoryCommand(lastCommand))
80101238:	85 db                	test   %ebx,%ebx
8010123a:	74 f1                	je     8010122d <controlNewCommand+0x4d>
}
8010123c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010123f:	c9                   	leave
    doHistoryCommand();
80101240:	e9 2b fe ff ff       	jmp    80101070 <doHistoryCommand>
80101245:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010124c:	00 
8010124d:	8d 76 00             	lea    0x0(%esi),%esi

80101250 <consoleinit>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101256:	68 c8 92 10 80       	push   $0x801092c8
8010125b:	68 c0 1a 11 80       	push   $0x80111ac0
80101260:	e8 7b 4e 00 00       	call   801060e0 <initlock>
  ioapicenable(IRQ_KBD, 0);
80101265:	58                   	pop    %eax
80101266:	5a                   	pop    %edx
80101267:	6a 00                	push   $0x0
80101269:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010126b:	c7 05 ac 24 11 80 e0 	movl   $0x801006e0,0x801124ac
80101272:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101275:	c7 05 a8 24 11 80 80 	movl   $0x80100280,0x801124a8
8010127c:	02 10 80 
  cons.locking = 1;
8010127f:	c7 05 f4 1a 11 80 01 	movl   $0x1,0x80111af4
80101286:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101289:	e8 12 25 00 00       	call   801037a0 <ioapicenable>
}
8010128e:	83 c4 10             	add    $0x10,%esp
80101291:	c9                   	leave
80101292:	c3                   	ret
80101293:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010129a:	00 
8010129b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801012a0 <isOperator>:
int isOperator(char c) {
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
801012a7:	8d 48 d6             	lea    -0x2a(%eax),%ecx
801012aa:	31 c0                	xor    %eax,%eax
801012ac:	80 f9 05             	cmp    $0x5,%cl
801012af:	77 0a                	ja     801012bb <isOperator+0x1b>
801012b1:	b8 2b 00 00 00       	mov    $0x2b,%eax
801012b6:	d3 e8                	shr    %cl,%eax
801012b8:	83 e0 01             	and    $0x1,%eax
}
801012bb:	5d                   	pop    %ebp
801012bc:	c3                   	ret
801012bd:	8d 76 00             	lea    0x0(%esi),%esi

801012c0 <reverseNumber>:
int reverseNumber(int num) {
801012c0:	55                   	push   %ebp
    int rev = 0;
801012c1:	31 c0                	xor    %eax,%eax
int reverseNumber(int num) {
801012c3:	89 e5                	mov    %esp,%ebp
801012c5:	57                   	push   %edi
801012c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801012c9:	56                   	push   %esi
801012ca:	53                   	push   %ebx
    while (num > 0) {
801012cb:	85 c9                	test   %ecx,%ecx
801012cd:	7e 28                	jle    801012f7 <reverseNumber+0x37>
        rev = rev * 10 + num % 10;
801012cf:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801012d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012d8:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
801012db:	89 c8                	mov    %ecx,%eax
801012dd:	89 cf                	mov    %ecx,%edi
801012df:	f7 e6                	mul    %esi
801012e1:	c1 ea 03             	shr    $0x3,%edx
801012e4:	8d 04 92             	lea    (%edx,%edx,4),%eax
801012e7:	01 c0                	add    %eax,%eax
801012e9:	29 c7                	sub    %eax,%edi
801012eb:	8d 04 5f             	lea    (%edi,%ebx,2),%eax
        num /= 10;
801012ee:	89 cb                	mov    %ecx,%ebx
801012f0:	89 d1                	mov    %edx,%ecx
    while (num > 0) {
801012f2:	83 fb 09             	cmp    $0x9,%ebx
801012f5:	7f e1                	jg     801012d8 <reverseNumber+0x18>
}
801012f7:	5b                   	pop    %ebx
801012f8:	5e                   	pop    %esi
801012f9:	5f                   	pop    %edi
801012fa:	5d                   	pop    %ebp
801012fb:	c3                   	ret
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101300 <itoa>:
void itoa(int num, char *str, int base) {
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	8b 45 08             	mov    0x8(%ebp),%eax
80101306:	8b 55 0c             	mov    0xc(%ebp),%edx
80101309:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if (num == 0) {
8010130c:	85 c0                	test   %eax,%eax
8010130e:	74 10                	je     80101320 <itoa+0x20>
}
80101310:	5d                   	pop    %ebp
80101311:	e9 6a f0 ff ff       	jmp    80100380 <itoa.part.0>
80101316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131d:	00 
8010131e:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
80101320:	b8 30 00 00 00       	mov    $0x30,%eax
80101325:	66 89 02             	mov    %ax,(%edx)
}
80101328:	5d                   	pop    %ebp
80101329:	c3                   	ret
8010132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101330 <reverseStr>:

void reverseStr(char* str, int len) {
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	56                   	push   %esi
    int i = 0, j = len - 1;
80101334:	8b 45 0c             	mov    0xc(%ebp),%eax
void reverseStr(char* str, int len) {
80101337:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010133a:	53                   	push   %ebx
    int i = 0, j = len - 1;
8010133b:	83 e8 01             	sub    $0x1,%eax
    while (i < j) {
8010133e:	85 c0                	test   %eax,%eax
80101340:	7e 20                	jle    80101362 <reverseStr+0x32>
    int i = 0, j = len - 1;
80101342:	31 d2                	xor    %edx,%edx
80101344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        char temp = str[i];
80101348:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        str[i] = str[j];
8010134c:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
80101350:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        str[j] = temp;
80101353:	89 f3                	mov    %esi,%ebx
        i++;
80101355:	83 c2 01             	add    $0x1,%edx
        str[j] = temp;
80101358:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
        j--;
8010135b:	83 e8 01             	sub    $0x1,%eax
    while (i < j) {
8010135e:	39 c2                	cmp    %eax,%edx
80101360:	7c e6                	jl     80101348 <reverseStr+0x18>
    }
}
80101362:	5b                   	pop    %ebx
80101363:	5e                   	pop    %esi
80101364:	5d                   	pop    %ebp
80101365:	c3                   	ret
80101366:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010136d:	00 
8010136e:	66 90                	xchg   %ax,%ax

80101370 <paste>:

void paste(int start, int end)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	56                   	push   %esi
80101374:	8b 4d 08             	mov    0x8(%ebp),%ecx
80101377:	8b 75 0c             	mov    0xc(%ebp),%esi
8010137a:	53                   	push   %ebx
  int k = 0;
  for (int i = start; i <= end; i++)
8010137b:	39 f1                	cmp    %esi,%ecx
8010137d:	7f 39                	jg     801013b8 <paste+0x48>
8010137f:	8d 5e 01             	lea    0x1(%esi),%ebx
  int k = 0;
80101382:	31 c0                	xor    %eax,%eax
80101384:	29 cb                	sub    %ecx,%ebx
80101386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010138d:	00 
8010138e:	66 90                	xchg   %ax,%ax
  {
    clipboard[k] = input.buf[i];
80101390:	0f b6 94 01 80 0e 11 	movzbl -0x7feef180(%ecx,%eax,1),%edx
80101397:	80 
    k++;
80101398:	83 c0 01             	add    $0x1,%eax
    clipboard[k] = input.buf[i];
8010139b:	88 90 1f 14 11 80    	mov    %dl,-0x7feeebe1(%eax)
  for (int i = start; i <= end; i++)
801013a1:	39 d8                	cmp    %ebx,%eax
801013a3:	75 eb                	jne    80101390 <paste+0x20>
801013a5:	29 ce                	sub    %ecx,%esi
  }
  clipboard[k] = '\0';
  
}
801013a7:	5b                   	pop    %ebx
801013a8:	83 c6 01             	add    $0x1,%esi
  clipboard[k] = '\0';
801013ab:	c6 86 20 14 11 80 00 	movb   $0x0,-0x7feeebe0(%esi)
}
801013b2:	5e                   	pop    %esi
801013b3:	5d                   	pop    %ebp
801013b4:	c3                   	ret
801013b5:	8d 76 00             	lea    0x0(%esi),%esi
  int k = 0;
801013b8:	31 f6                	xor    %esi,%esi
}
801013ba:	5b                   	pop    %ebx
  clipboard[k] = '\0';
801013bb:	c6 86 20 14 11 80 00 	movb   $0x0,-0x7feeebe0(%esi)
}
801013c2:	5e                   	pop    %esi
801013c3:	5d                   	pop    %ebp
801013c4:	c3                   	ret
801013c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013cc:	00 
801013cd:	8d 76 00             	lea    0x0(%esi),%esi

801013d0 <extractAndCompute>:

void extractAndCompute() {
801013d0:	55                   	push   %ebp
801013d1:	ba 2b 00 00 00       	mov    $0x2b,%edx
801013d6:	89 e5                	mov    %esp,%ebp
801013d8:	57                   	push   %edi
801013d9:	56                   	push   %esi
801013da:	53                   	push   %ebx
801013db:	83 ec 3c             	sub    $0x3c,%esp
    int i = input.e - 2;
801013de:	a1 08 0f 11 80       	mov    0x80110f08,%eax
    int startPos = -1;
    char operator = '\0';
    int num1 = 0, num2 = 0;

    // Find the operator in the pattern NON=?
    while (i >= 0 && input.buf[i] != '\n') {
801013e3:	89 c1                	mov    %eax,%ecx
    int i = input.e - 2;
801013e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    while (i >= 0 && input.buf[i] != '\n') {
801013e8:	83 e9 02             	sub    $0x2,%ecx
801013eb:	0f 88 e0 01 00 00    	js     801015d1 <extractAndCompute+0x201>
801013f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013f8:	0f b6 81 80 0e 11 80 	movzbl -0x7feef180(%ecx),%eax
801013ff:	3c 0a                	cmp    $0xa,%al
80101401:	0f 84 ca 01 00 00    	je     801015d1 <extractAndCompute+0x201>
        if (isOperator(input.buf[i])) {
80101407:	8d 58 d6             	lea    -0x2a(%eax),%ebx
8010140a:	80 fb 05             	cmp    $0x5,%bl
8010140d:	0f 87 b5 01 00 00    	ja     801015c8 <extractAndCompute+0x1f8>
80101413:	0f a3 da             	bt     %ebx,%edx
80101416:	0f 83 ac 01 00 00    	jae    801015c8 <extractAndCompute+0x1f8>
        i--;
    }

    if (operator == '\0') return;

    int j = input.e - 3; // Skip the last '?'
8010141c:	89 c7                	mov    %eax,%edi
8010141e:	8b 45 c0             	mov    -0x40(%ebp),%eax
    int count_zero_num2 = 0;
80101421:	31 f6                	xor    %esi,%esi
    int j = input.e - 3; // Skip the last '?'
80101423:	8d 50 fd             	lea    -0x3(%eax),%edx
80101426:	89 d0                	mov    %edx,%eax
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
80101428:	39 ca                	cmp    %ecx,%edx
8010142a:	7f 16                	jg     80101442 <extractAndCompute+0x72>
8010142c:	e9 df 02 00 00       	jmp    80101710 <extractAndCompute+0x340>
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count_zero_num2++;
        j--;
80101438:	83 e8 01             	sub    $0x1,%eax
        count_zero_num2++;
8010143b:	83 c6 01             	add    $0x1,%esi
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
8010143e:	39 c8                	cmp    %ecx,%eax
80101440:	7e 09                	jle    8010144b <extractAndCompute+0x7b>
80101442:	80 b8 80 0e 11 80 30 	cmpb   $0x30,-0x7feef180(%eax)
80101449:	74 ed                	je     80101438 <extractAndCompute+0x68>
    }

    j = input.e - 3; // Skip the last '?'
    while (j > startPos && isDigit(input.buf[j])) {
8010144b:	89 75 c4             	mov    %esi,-0x3c(%ebp)
    int count_zero_num2 = 0;
8010144e:	31 db                	xor    %ebx,%ebx
80101450:	89 ce                	mov    %ecx,%esi
80101452:	eb 12                	jmp    80101466 <extractAndCompute+0x96>
80101454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        num2 = (num2 * 10) + (input.buf[j] - '0');
80101458:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
        j--;
8010145b:	83 ea 01             	sub    $0x1,%edx
        num2 = (num2 * 10) + (input.buf[j] - '0');
8010145e:	8d 5c 48 d0          	lea    -0x30(%eax,%ecx,2),%ebx
    while (j > startPos && isDigit(input.buf[j])) {
80101462:	39 f2                	cmp    %esi,%edx
80101464:	7e 0f                	jle    80101475 <extractAndCompute+0xa5>
80101466:	0f be 82 80 0e 11 80 	movsbl -0x7feef180(%edx),%eax
  return(c>='0' && c<='9');
8010146d:	8d 48 d0             	lea    -0x30(%eax),%ecx
    while (j > startPos && isDigit(input.buf[j])) {
80101470:	80 f9 09             	cmp    $0x9,%cl
80101473:	76 e3                	jbe    80101458 <extractAndCompute+0x88>
80101475:	89 f1                	mov    %esi,%ecx
80101477:	8b 75 c4             	mov    -0x3c(%ebp),%esi
    while (num > 0) {
8010147a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
80101481:	85 db                	test   %ebx,%ebx
80101483:	7e 36                	jle    801014bb <extractAndCompute+0xeb>
80101485:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80101488:	31 c0                	xor    %eax,%eax
8010148a:	89 75 bc             	mov    %esi,-0x44(%ebp)
8010148d:	8d 76 00             	lea    0x0(%esi),%esi
        rev = rev * 10 + num % 10;
80101490:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80101493:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80101498:	89 de                	mov    %ebx,%esi
8010149a:	f7 e3                	mul    %ebx
8010149c:	c1 ea 03             	shr    $0x3,%edx
8010149f:	8d 04 92             	lea    (%edx,%edx,4),%eax
801014a2:	01 c0                	add    %eax,%eax
801014a4:	29 c6                	sub    %eax,%esi
801014a6:	8d 04 4e             	lea    (%esi,%ecx,2),%eax
        num /= 10;
801014a9:	89 d9                	mov    %ebx,%ecx
801014ab:	89 d3                	mov    %edx,%ebx
    while (num > 0) {
801014ad:	83 f9 09             	cmp    $0x9,%ecx
801014b0:	7f de                	jg     80101490 <extractAndCompute+0xc0>
801014b2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
801014b5:	8b 75 bc             	mov    -0x44(%ebp),%esi
801014b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for (int i = 0; i < power; i++)
801014bb:	85 f6                	test   %esi,%esi
801014bd:	74 26                	je     801014e5 <extractAndCompute+0x115>
801014bf:	31 d2                	xor    %edx,%edx
  int result = 1;
801014c1:	b8 01 00 00 00       	mov    $0x1,%eax
801014c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014cd:	00 
801014ce:	66 90                	xchg   %ax,%ax
    result = result * base;
801014d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  for (int i = 0; i < power; i++)
801014d3:	83 c2 01             	add    $0x1,%edx
    result = result * base;
801014d6:	01 c0                	add    %eax,%eax
  for (int i = 0; i < power; i++)
801014d8:	39 f2                	cmp    %esi,%edx
801014da:	75 f4                	jne    801014d0 <extractAndCompute+0x100>
    }

    num2 = reverseNumber(num2);
    num2 = num2 * pow(10, count_zero_num2);
801014dc:	8b 75 c4             	mov    -0x3c(%ebp),%esi
801014df:	0f af f0             	imul   %eax,%esi
801014e2:	89 75 c4             	mov    %esi,-0x3c(%ebp)

    j = startPos - 1;
801014e5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
    int count_zero_num1 = 0;
801014e8:	31 f6                	xor    %esi,%esi
    j = startPos - 1;
801014ea:	89 d8                	mov    %ebx,%eax
    while (j > 0 && isDigit(input.buf[j]) && input.buf[j] == '0') {
801014ec:	85 db                	test   %ebx,%ebx
801014ee:	7f 10                	jg     80101500 <extractAndCompute+0x130>
801014f0:	e9 06 02 00 00       	jmp    801016fb <extractAndCompute+0x32b>
801014f5:	8d 76 00             	lea    0x0(%esi),%esi
        count_zero_num1++;
801014f8:	83 c6 01             	add    $0x1,%esi
    while (j > 0 && isDigit(input.buf[j]) && input.buf[j] == '0') {
801014fb:	83 e8 01             	sub    $0x1,%eax
801014fe:	74 09                	je     80101509 <extractAndCompute+0x139>
80101500:	80 b8 80 0e 11 80 30 	cmpb   $0x30,-0x7feef180(%eax)
80101507:	74 ef                	je     801014f8 <extractAndCompute+0x128>
    int count_zero_num1 = 0;
80101509:	31 c9                	xor    %ecx,%ecx
8010150b:	eb 0f                	jmp    8010151c <extractAndCompute+0x14c>
8010150d:	8d 76 00             	lea    0x0(%esi),%esi
        j--;
    }

    j = startPos - 1;
    while (j >= 0 && isDigit(input.buf[j])) {
        num1 = (num1 * 10) + (input.buf[j] - '0');
80101510:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
80101513:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
    while (j >= 0 && isDigit(input.buf[j])) {
80101517:	83 eb 01             	sub    $0x1,%ebx
8010151a:	72 0f                	jb     8010152b <extractAndCompute+0x15b>
8010151c:	0f be 83 80 0e 11 80 	movsbl -0x7feef180(%ebx),%eax
  return(c>='0' && c<='9');
80101523:	8d 50 d0             	lea    -0x30(%eax),%edx
    while (j >= 0 && isDigit(input.buf[j])) {
80101526:	80 fa 09             	cmp    $0x9,%dl
80101529:	76 e5                	jbe    80101510 <extractAndCompute+0x140>
    while (num > 0) {
8010152b:	31 c0                	xor    %eax,%eax
8010152d:	85 c9                	test   %ecx,%ecx
8010152f:	7e 37                	jle    80101568 <extractAndCompute+0x198>
        rev = rev * 10 + num % 10;
80101531:	89 75 bc             	mov    %esi,-0x44(%ebp)
80101534:	89 5d b8             	mov    %ebx,-0x48(%ebp)
80101537:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010153e:	00 
8010153f:	90                   	nop
80101540:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
80101543:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80101548:	89 ce                	mov    %ecx,%esi
8010154a:	f7 e1                	mul    %ecx
8010154c:	c1 ea 03             	shr    $0x3,%edx
8010154f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101552:	01 c0                	add    %eax,%eax
80101554:	29 c6                	sub    %eax,%esi
80101556:	8d 04 5e             	lea    (%esi,%ebx,2),%eax
        num /= 10;
80101559:	89 cb                	mov    %ecx,%ebx
8010155b:	89 d1                	mov    %edx,%ecx
    while (num > 0) {
8010155d:	83 fb 09             	cmp    $0x9,%ebx
80101560:	7f de                	jg     80101540 <extractAndCompute+0x170>
80101562:	8b 75 bc             	mov    -0x44(%ebp),%esi
80101565:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  for (int i = 0; i < power; i++)
80101568:	85 f6                	test   %esi,%esi
8010156a:	74 1b                	je     80101587 <extractAndCompute+0x1b7>
8010156c:	31 c9                	xor    %ecx,%ecx
  int result = 1;
8010156e:	ba 01 00 00 00       	mov    $0x1,%edx
80101573:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    result = result * base;
80101578:	8d 14 92             	lea    (%edx,%edx,4),%edx
  for (int i = 0; i < power; i++)
8010157b:	83 c1 01             	add    $0x1,%ecx
    result = result * base;
8010157e:	01 d2                	add    %edx,%edx
  for (int i = 0; i < power; i++)
80101580:	39 ce                	cmp    %ecx,%esi
80101582:	75 f4                	jne    80101578 <extractAndCompute+0x1a8>
        j--;
    }

    num1 = reverseNumber(num1);
    num1 = num1 * pow(10, count_zero_num1);
80101584:	0f af c2             	imul   %edx,%eax

    int result = 0;
    int reminder = 0;
    switch (operator) {
80101587:	89 f9                	mov    %edi,%ecx
        case '+':
            result = num1 + num2;
80101589:	8b 7d c4             	mov    -0x3c(%ebp),%edi
    switch (operator) {
8010158c:	80 f9 2d             	cmp    $0x2d,%cl
8010158f:	0f 84 cb 00 00 00    	je     80101660 <extractAndCompute+0x290>
80101595:	7f 42                	jg     801015d9 <extractAndCompute+0x209>
80101597:	80 f9 2a             	cmp    $0x2a,%cl
8010159a:	74 5b                	je     801015f7 <extractAndCompute+0x227>
            result = num1 + num2;
8010159c:	01 c7                	add    %eax,%edi
    int reminder = 0;
8010159e:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
            result = num1 + num2;
801015a5:	89 7d c4             	mov    %edi,-0x3c(%ebp)
            break;
        default:
            return;
    }

    int lengthToRemove = (input.e - startPos) + (startPos - j - 1);
801015a8:	8b 55 c0             	mov    -0x40(%ebp),%edx

    // Remove the characters in the pattern NON=?
    for (i = 0; i < lengthToRemove; i++) {
801015ab:	31 ff                	xor    %edi,%edi
    int lengthToRemove = (input.e - startPos) + (startPos - j - 1);
801015ad:	83 ea 01             	sub    $0x1,%edx
801015b0:	89 d6                	mov    %edx,%esi
801015b2:	29 de                	sub    %ebx,%esi
    for (i = 0; i < lengthToRemove; i++) {
801015b4:	85 f6                	test   %esi,%esi
801015b6:	7e 5f                	jle    80101617 <extractAndCompute+0x247>
  if(panicked) {
801015b8:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
801015bd:	85 c0                	test   %eax,%eax
801015bf:	74 45                	je     80101606 <extractAndCompute+0x236>
801015c1:	fa                   	cli
    for(;;)
801015c2:	eb fe                	jmp    801015c2 <extractAndCompute+0x1f2>
801015c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (i >= 0 && input.buf[i] != '\n') {
801015c8:	83 e9 01             	sub    $0x1,%ecx
801015cb:	0f 83 27 fe ff ff    	jae    801013f8 <extractAndCompute+0x28>
        itoa(reminder, decimalResult, 10);
        consputc(decimalResult[0]);
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
        input.e++;
    }
}
801015d1:	83 c4 3c             	add    $0x3c,%esp
801015d4:	5b                   	pop    %ebx
801015d5:	5e                   	pop    %esi
801015d6:	5f                   	pop    %edi
801015d7:	5d                   	pop    %ebp
801015d8:	c3                   	ret
            if (num2 != 0) {
801015d9:	85 ff                	test   %edi,%edi
801015db:	74 f4                	je     801015d1 <extractAndCompute+0x201>
                reminder = num1 % num2;
801015dd:	99                   	cltd
801015de:	f7 ff                	idiv   %edi
801015e0:	89 55 bc             	mov    %edx,-0x44(%ebp)
801015e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
                if (reminder != 0) {
801015e6:	85 d2                	test   %edx,%edx
801015e8:	74 be                	je     801015a8 <extractAndCompute+0x1d8>
                    reminder = (reminder * 10) / num2;
801015ea:	8d 04 92             	lea    (%edx,%edx,4),%eax
801015ed:	01 c0                	add    %eax,%eax
801015ef:	99                   	cltd
801015f0:	f7 ff                	idiv   %edi
801015f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
801015f5:	eb b1                	jmp    801015a8 <extractAndCompute+0x1d8>
            result = num1 * num2;
801015f7:	0f af f8             	imul   %eax,%edi
    int reminder = 0;
801015fa:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
            result = num1 * num2;
80101601:	89 7d c4             	mov    %edi,-0x3c(%ebp)
            break;
80101604:	eb a2                	jmp    801015a8 <extractAndCompute+0x1d8>
80101606:	b8 00 01 00 00       	mov    $0x100,%eax
    for (i = 0; i < lengthToRemove; i++) {
8010160b:	83 c7 01             	add    $0x1,%edi
8010160e:	e8 bd ee ff ff       	call   801004d0 <consputc.part.0>
80101613:	39 fe                	cmp    %edi,%esi
80101615:	75 a1                	jne    801015b8 <extractAndCompute+0x1e8>
    if (num == 0) {
80101617:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010161a:	85 c0                	test   %eax,%eax
8010161c:	0f 84 be 00 00 00    	je     801016e0 <extractAndCompute+0x310>
80101622:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101625:	b9 0a 00 00 00       	mov    $0xa,%ecx
    input.e = j + 1 + i;
8010162a:	83 c3 01             	add    $0x1,%ebx
8010162d:	89 c2                	mov    %eax,%edx
8010162f:	89 c7                	mov    %eax,%edi
80101631:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80101634:	e8 47 ed ff ff       	call   80100380 <itoa.part.0>
    for (i = 0; resultStr[i] != '\0'; i++) {
80101639:	0f b6 55 d8          	movzbl -0x28(%ebp),%edx
    input.e = j + 1 + i;
8010163d:	89 d8                	mov    %ebx,%eax
    for (i = 0; resultStr[i] != '\0'; i++) {
8010163f:	84 d2                	test   %dl,%dl
80101641:	74 44                	je     80101687 <extractAndCompute+0x2b7>
    input.e = j + 1 + i;
80101643:	31 f6                	xor    %esi,%esi
        input.buf[(j + 1 + i) % INPUT_BUF] = resultStr[i];
80101645:	8d 04 33             	lea    (%ebx,%esi,1),%eax
80101648:	83 e0 7f             	and    $0x7f,%eax
8010164b:	88 90 80 0e 11 80    	mov    %dl,-0x7feef180(%eax)
  if(panicked) {
80101651:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
80101656:	85 c0                	test   %eax,%eax
80101658:	74 17                	je     80101671 <extractAndCompute+0x2a1>
8010165a:	fa                   	cli
    for(;;)
8010165b:	eb fe                	jmp    8010165b <extractAndCompute+0x28b>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
            result = num1 - num2;
80101660:	29 f8                	sub    %edi,%eax
    int reminder = 0;
80101662:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
            result = num1 - num2;
80101669:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            break;
8010166c:	e9 37 ff ff ff       	jmp    801015a8 <extractAndCompute+0x1d8>
        consputc(resultStr[i]);
80101671:	0f be c2             	movsbl %dl,%eax
    for (i = 0; resultStr[i] != '\0'; i++) {
80101674:	83 c6 01             	add    $0x1,%esi
80101677:	e8 54 ee ff ff       	call   801004d0 <consputc.part.0>
8010167c:	0f b6 14 37          	movzbl (%edi,%esi,1),%edx
80101680:	84 d2                	test   %dl,%dl
80101682:	75 c1                	jne    80101645 <extractAndCompute+0x275>
    input.e = j + 1 + i;
80101684:	8d 04 33             	lea    (%ebx,%esi,1),%eax
80101687:	a3 08 0f 11 80       	mov    %eax,0x80110f08
    for (int i = input.e; i < INPUT_BUF; i++)
8010168c:	83 f8 7f             	cmp    $0x7f,%eax
8010168f:	7f 2d                	jg     801016be <extractAndCompute+0x2ee>
80101691:	a8 01                	test   $0x1,%al
80101693:	74 11                	je     801016a6 <extractAndCompute+0x2d6>
      input.buf[i] = '\0';
80101695:	c6 80 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%eax)
    for (int i = input.e; i < INPUT_BUF; i++)
8010169c:	83 c0 01             	add    $0x1,%eax
8010169f:	3d 80 00 00 00       	cmp    $0x80,%eax
801016a4:	74 18                	je     801016be <extractAndCompute+0x2ee>
      input.buf[i] = '\0';
801016a6:	c6 80 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%eax)
    for (int i = input.e; i < INPUT_BUF; i++)
801016ad:	83 c0 02             	add    $0x2,%eax
      input.buf[i] = '\0';
801016b0:	c6 80 7f 0e 11 80 00 	movb   $0x0,-0x7feef181(%eax)
    for (int i = input.e; i < INPUT_BUF; i++)
801016b7:	3d 80 00 00 00       	cmp    $0x80,%eax
801016bc:	75 e8                	jne    801016a6 <extractAndCompute+0x2d6>
    if (reminder != 0) {
801016be:	8b 4d bc             	mov    -0x44(%ebp),%ecx
801016c1:	85 c9                	test   %ecx,%ecx
801016c3:	0f 84 08 ff ff ff    	je     801015d1 <extractAndCompute+0x201>
  if(panicked) {
801016c9:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
801016cf:	85 d2                	test   %edx,%edx
801016d1:	74 49                	je     8010171c <extractAndCompute+0x34c>
801016d3:	fa                   	cli
    for(;;)
801016d4:	eb fe                	jmp    801016d4 <extractAndCompute+0x304>
801016d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016dd:	00 
801016de:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
801016e0:	b8 30 00 00 00       	mov    $0x30,%eax
    input.e = j + 1 + i;
801016e5:	83 c3 01             	add    $0x1,%ebx
801016e8:	ba 30 00 00 00       	mov    $0x30,%edx
        str[i++] = '0';
801016ed:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    for (i = 0; resultStr[i] != '\0'; i++) {
801016f1:	8d 45 d8             	lea    -0x28(%ebp),%eax
801016f4:	89 c7                	mov    %eax,%edi
801016f6:	e9 48 ff ff ff       	jmp    80101643 <extractAndCompute+0x273>
    while (j >= 0 && isDigit(input.buf[j])) {
801016fb:	0f 84 08 fe ff ff    	je     80101509 <extractAndCompute+0x139>
80101701:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80101706:	31 c0                	xor    %eax,%eax
80101708:	e9 7a fe ff ff       	jmp    80101587 <extractAndCompute+0x1b7>
8010170d:	8d 76 00             	lea    0x0(%esi),%esi
    while (j > startPos && isDigit(input.buf[j]) && input.buf[j] == '0') {
80101710:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
80101717:	e9 c9 fd ff ff       	jmp    801014e5 <extractAndCompute+0x115>
8010171c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80101721:	e8 aa ed ff ff       	call   801004d0 <consputc.part.0>
        input.buf[input.e % INPUT_BUF] = '.';
80101726:	a1 08 0f 11 80       	mov    0x80110f08,%eax
8010172b:	b9 0a 00 00 00       	mov    $0xa,%ecx
80101730:	89 c2                	mov    %eax,%edx
        input.e++;
80101732:	83 c0 01             	add    $0x1,%eax
80101735:	a3 08 0f 11 80       	mov    %eax,0x80110f08
        input.buf[input.e % INPUT_BUF] = '.';
8010173a:	83 e2 7f             	and    $0x7f,%edx
8010173d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80101740:	c6 82 80 0e 11 80 2e 	movb   $0x2e,-0x7feef180(%edx)
    if (num == 0) {
80101747:	8d 55 d6             	lea    -0x2a(%ebp),%edx
8010174a:	e8 31 ec ff ff       	call   80100380 <itoa.part.0>
  if(panicked) {
8010174f:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
        consputc(decimalResult[0]);
80101754:	0f b6 5d d6          	movzbl -0x2a(%ebp),%ebx
  if(panicked) {
80101758:	85 c0                	test   %eax,%eax
8010175a:	74 04                	je     80101760 <extractAndCompute+0x390>
8010175c:	fa                   	cli
    for(;;)
8010175d:	eb fe                	jmp    8010175d <extractAndCompute+0x38d>
8010175f:	90                   	nop
        consputc(decimalResult[0]);
80101760:	0f be c3             	movsbl %bl,%eax
80101763:	e8 68 ed ff ff       	call   801004d0 <consputc.part.0>
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
80101768:	a1 08 0f 11 80       	mov    0x80110f08,%eax
8010176d:	89 c2                	mov    %eax,%edx
        input.e++;
8010176f:	83 c0 01             	add    $0x1,%eax
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
80101772:	83 e2 7f             	and    $0x7f,%edx
        input.e++;
80101775:	a3 08 0f 11 80       	mov    %eax,0x80110f08
        input.buf[input.e % INPUT_BUF] = decimalResult[0];
8010177a:	88 9a 80 0e 11 80    	mov    %bl,-0x7feef180(%edx)
        input.e++;
80101780:	e9 4c fe ff ff       	jmp    801015d1 <extractAndCompute+0x201>
80101785:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010178c:	00 
8010178d:	8d 76 00             	lea    0x0(%esi),%esi

80101790 <consoleintr>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 28             	sub    $0x28,%esp
80101799:	8b 45 08             	mov    0x8(%ebp),%eax
8010179c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
8010179f:	68 c0 1a 11 80       	push   $0x80111ac0
801017a4:	e8 27 4b 00 00       	call   801062d0 <acquire>
  int c, doprocdump = 0;
801017a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((c = getc()) >= 0){
801017b0:	83 c4 10             	add    $0x10,%esp
801017b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801017b6:	ff d0                	call   *%eax
801017b8:	89 c3                	mov    %eax,%ebx
801017ba:	85 c0                	test   %eax,%eax
801017bc:	0f 88 1e 01 00 00    	js     801018e0 <consoleintr+0x150>
    switch(c){
801017c2:	83 fb 3f             	cmp    $0x3f,%ebx
801017c5:	0f 84 85 03 00 00    	je     80101b50 <consoleintr+0x3c0>
801017cb:	7f 53                	jg     80101820 <consoleintr+0x90>
801017cd:	8d 43 fa             	lea    -0x6(%ebx),%eax
801017d0:	83 f8 0f             	cmp    $0xf,%eax
801017d3:	0f 87 87 03 00 00    	ja     80101b60 <consoleintr+0x3d0>
801017d9:	ff 24 85 3c 98 10 80 	jmp    *-0x7fef67c4(,%eax,4)
801017e0:	b8 00 01 00 00       	mov    $0x100,%eax
801017e5:	e8 e6 ec ff ff       	call   801004d0 <consputc.part.0>
      while(input.e != input.w &&
801017ea:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801017ef:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801017f5:	74 bc                	je     801017b3 <consoleintr+0x23>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801017f7:	83 e8 01             	sub    $0x1,%eax
801017fa:	89 c2                	mov    %eax,%edx
801017fc:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801017ff:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80101806:	74 ab                	je     801017b3 <consoleintr+0x23>
        input.e--;
80101808:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked) {
8010180d:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
80101812:	85 c0                	test   %eax,%eax
80101814:	74 ca                	je     801017e0 <consoleintr+0x50>
80101816:	fa                   	cli
    for(;;)
80101817:	eb fe                	jmp    80101817 <consoleintr+0x87>
80101819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80101820:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80101826:	0f 84 0c 03 00 00    	je     80101b38 <consoleintr+0x3a8>
8010182c:	0f 8e d6 00 00 00    	jle    80101908 <consoleintr+0x178>
80101832:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80101838:	0f 84 02 01 00 00    	je     80101940 <consoleintr+0x1b0>
8010183e:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80101844:	0f 85 ef 03 00 00    	jne    80101c39 <consoleintr+0x4a9>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010184a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010184f:	b8 0e 00 00 00       	mov    $0xe,%eax
80101854:	89 f2                	mov    %esi,%edx
80101856:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101857:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010185c:	89 ca                	mov    %ecx,%edx
8010185e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010185f:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101862:	89 f2                	mov    %esi,%edx
80101864:	b8 0f 00 00 00       	mov    $0xf,%eax
80101869:	c1 e3 08             	shl    $0x8,%ebx
8010186c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010186d:	89 ca                	mov    %ecx,%edx
8010186f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101870:	0f b6 c8             	movzbl %al,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
80101873:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
  pos |= inb(CRTPORT + 1);
80101878:	09 d9                	or     %ebx,%ecx
  int last_index_line = ((((int) pos / NUMCOL) + 1) * NUMCOL - 1);
8010187a:	f7 e1                	mul    %ecx
8010187c:	c1 ea 06             	shr    $0x6,%edx
8010187f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101882:	c1 e0 04             	shl    $0x4,%eax
80101885:	83 c0 4f             	add    $0x4f,%eax
  if ((pos < last_index_line) && (cap > 0))
80101888:	39 c1                	cmp    %eax,%ecx
8010188a:	7d 14                	jge    801018a0 <consoleintr+0x110>
8010188c:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
80101891:	85 c0                	test   %eax,%eax
80101893:	7e 0b                	jle    801018a0 <consoleintr+0x110>
    cap--;
80101895:	83 e8 01             	sub    $0x1,%eax
    pos++;
80101898:	83 c1 01             	add    $0x1,%ecx
    cap--;
8010189b:	a3 f8 1a 11 80       	mov    %eax,0x80111af8
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801018a0:	be d4 03 00 00       	mov    $0x3d4,%esi
801018a5:	b8 0e 00 00 00       	mov    $0xe,%eax
801018aa:	89 f2                	mov    %esi,%edx
801018ac:	ee                   	out    %al,(%dx)
801018ad:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT + 1, pos >> 8);
801018b2:	89 c8                	mov    %ecx,%eax
801018b4:	c1 f8 08             	sar    $0x8,%eax
801018b7:	89 da                	mov    %ebx,%edx
801018b9:	ee                   	out    %al,(%dx)
801018ba:	b8 0f 00 00 00       	mov    $0xf,%eax
801018bf:	89 f2                	mov    %esi,%edx
801018c1:	ee                   	out    %al,(%dx)
801018c2:	89 c8                	mov    %ecx,%eax
801018c4:	89 da                	mov    %ebx,%edx
801018c6:	ee                   	out    %al,(%dx)
  while((c = getc()) >= 0){
801018c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018ca:	ff d0                	call   *%eax
801018cc:	89 c3                	mov    %eax,%ebx
801018ce:	85 c0                	test   %eax,%eax
801018d0:	0f 89 ec fe ff ff    	jns    801017c2 <consoleintr+0x32>
801018d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018dd:	00 
801018de:	66 90                	xchg   %ax,%ax
  release(&cons.lock);
801018e0:	83 ec 0c             	sub    $0xc,%esp
801018e3:	68 c0 1a 11 80       	push   $0x80111ac0
801018e8:	e8 83 49 00 00       	call   80106270 <release>
  if(doprocdump) {
801018ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801018f0:	83 c4 10             	add    $0x10,%esp
801018f3:	85 c0                	test   %eax,%eax
801018f5:	0f 85 32 03 00 00    	jne    80101c2d <consoleintr+0x49d>
}
801018fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fe:	5b                   	pop    %ebx
801018ff:	5e                   	pop    %esi
80101900:	5f                   	pop    %edi
80101901:	5d                   	pop    %ebp
80101902:	c3                   	ret
80101903:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    switch(c){
80101908:	83 fb 7f             	cmp    $0x7f,%ebx
8010190b:	0f 84 af 00 00 00    	je     801019c0 <consoleintr+0x230>
80101911:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80101917:	0f 85 4b 02 00 00    	jne    80101b68 <consoleintr+0x3d8>
      if (upDownKeyIndex < historyCurrentSize)
8010191d:	a1 24 15 11 80       	mov    0x80111524,%eax
80101922:	39 05 20 15 11 80    	cmp    %eax,0x80111520
80101928:	0f 8d 85 fe ff ff    	jge    801017b3 <consoleintr+0x23>
        showPastCommand();
8010192e:	e8 cd f5 ff ff       	call   80100f00 <showPastCommand>
80101933:	e9 7b fe ff ff       	jmp    801017b3 <consoleintr+0x23>
80101938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010193f:	00 
      if ((input.e - cap) > input.w) 
80101940:	8b 0d f8 1a 11 80    	mov    0x80111af8,%ecx
80101946:	a1 08 0f 11 80       	mov    0x80110f08,%eax
8010194b:	29 c8                	sub    %ecx,%eax
8010194d:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
80101953:	0f 83 5a fe ff ff    	jae    801017b3 <consoleintr+0x23>
80101959:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010195e:	b8 0e 00 00 00       	mov    $0xe,%eax
80101963:	89 fa                	mov    %edi,%edx
80101965:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101966:	be d5 03 00 00       	mov    $0x3d5,%esi
8010196b:	89 f2                	mov    %esi,%edx
8010196d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010196e:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101971:	89 fa                	mov    %edi,%edx
80101973:	b8 0f 00 00 00       	mov    $0xf,%eax
80101978:	c1 e3 08             	shl    $0x8,%ebx
8010197b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010197c:	89 f2                	mov    %esi,%edx
8010197e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010197f:	0f b6 c0             	movzbl %al,%eax
80101982:	09 c3                	or     %eax,%ebx
  int first_write_index = NUMCOL * ((int) pos / NUMCOL) + 2;
80101984:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80101989:	f7 e3                	mul    %ebx
8010198b:	c1 ea 06             	shr    $0x6,%edx
8010198e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101991:	c1 e0 04             	shl    $0x4,%eax
80101994:	83 c0 02             	add    $0x2,%eax
  if(pos >= first_write_index  && crt[pos - 2] != (('$' & 0xff) | 0x0700))
80101997:	39 c3                	cmp    %eax,%ebx
80101999:	0f 8c 57 02 00 00    	jl     80101bf6 <consoleintr+0x466>
8010199f:	66 81 bc 1b fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ebx,%ebx,1)
801019a6:	80 24 07 
801019a9:	0f 84 47 02 00 00    	je     80101bf6 <consoleintr+0x466>
    pos--;
801019af:	83 eb 01             	sub    $0x1,%ebx
    cap++;
801019b2:	83 c1 01             	add    $0x1,%ecx
801019b5:	89 0d f8 1a 11 80    	mov    %ecx,0x80111af8
801019bb:	e9 41 02 00 00       	jmp    80101c01 <consoleintr+0x471>
        if(input.e != input.w && input.e - input.w > cap) {
801019c0:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801019c5:	8b 15 04 0f 11 80    	mov    0x80110f04,%edx
801019cb:	39 d0                	cmp    %edx,%eax
801019cd:	0f 84 e0 fd ff ff    	je     801017b3 <consoleintr+0x23>
801019d3:	89 c3                	mov    %eax,%ebx
801019d5:	8b 0d f8 1a 11 80    	mov    0x80111af8,%ecx
801019db:	29 d3                	sub    %edx,%ebx
801019dd:	39 d9                	cmp    %ebx,%ecx
801019df:	0f 83 ce fd ff ff    	jae    801017b3 <consoleintr+0x23>
          if (cap > 0)
801019e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801019e8:	85 c9                	test   %ecx,%ecx
801019ea:	0f 8f 1f 03 00 00    	jg     80101d0f <consoleintr+0x57f>
  if(panicked) {
801019f0:	a1 fc 1a 11 80       	mov    0x80111afc,%eax
          input.e--;
801019f5:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
  if(panicked) {
801019fb:	85 c0                	test   %eax,%eax
801019fd:	0f 84 dd 02 00 00    	je     80101ce0 <consoleintr+0x550>
  asm volatile("cli");
80101a03:	fa                   	cli
    for(;;)
80101a04:	eb fe                	jmp    80101a04 <consoleintr+0x274>
80101a06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a0d:	00 
80101a0e:	66 90                	xchg   %ax,%ax
      if(saveStatus)
80101a10:	8b 35 18 14 11 80    	mov    0x80111418,%esi
80101a16:	85 f6                	test   %esi,%esi
80101a18:	0f 84 95 fd ff ff    	je     801017b3 <consoleintr+0x23>
        end_copy = input.e;
80101a1e:	a1 08 0f 11 80       	mov    0x80110f08,%eax
        paste(start_copy, end_copy);
80101a23:	8b 1d 10 14 11 80    	mov    0x80111410,%ebx
        end_copy = input.e;
80101a29:	a3 0c 14 11 80       	mov    %eax,0x8011140c
  for (int i = start; i <= end; i++)
80101a2e:	39 d8                	cmp    %ebx,%eax
80101a30:	0f 8c d2 02 00 00    	jl     80101d08 <consoleintr+0x578>
80101a36:	8d 70 01             	lea    0x1(%eax),%esi
  int k = 0;
80101a39:	31 d2                	xor    %edx,%edx
80101a3b:	29 de                	sub    %ebx,%esi
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    clipboard[k] = input.buf[i];
80101a40:	0f b6 8c 13 80 0e 11 	movzbl -0x7feef180(%ebx,%edx,1),%ecx
80101a47:	80 
    k++;
80101a48:	83 c2 01             	add    $0x1,%edx
    clipboard[k] = input.buf[i];
80101a4b:	88 8a 1f 14 11 80    	mov    %cl,-0x7feeebe1(%edx)
  for (int i = start; i <= end; i++)
80101a51:	39 f2                	cmp    %esi,%edx
80101a53:	75 eb                	jne    80101a40 <consoleintr+0x2b0>
80101a55:	89 c2                	mov    %eax,%edx
80101a57:	29 da                	sub    %ebx,%edx
80101a59:	83 c2 01             	add    $0x1,%edx
  clipboard[k] = '\0';
80101a5c:	c6 82 20 14 11 80 00 	movb   $0x0,-0x7feeebe0(%edx)
        while(clipboard[i] != '\0')
80101a63:	0f b6 0d 20 14 11 80 	movzbl 0x80111420,%ecx
80101a6a:	84 c9                	test   %cl,%cl
80101a6c:	0f 84 63 03 00 00    	je     80101dd5 <consoleintr+0x645>
        int i = 0;
80101a72:	31 ff                	xor    %edi,%edi
80101a74:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101a77:	89 cf                	mov    %ecx,%edi
  for (int i = input.e; i > input.e - cap; i--)
80101a79:	8b 35 f8 1a 11 80    	mov    0x80111af8,%esi
80101a7f:	89 c3                	mov    %eax,%ebx
80101a81:	89 c2                	mov    %eax,%edx
80101a83:	29 f3                	sub    %esi,%ebx
80101a85:	39 c3                	cmp    %eax,%ebx
80101a87:	73 45                	jae    80101ace <consoleintr+0x33e>
80101a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
80101a90:	89 d0                	mov    %edx,%eax
80101a92:	83 ea 01             	sub    $0x1,%edx
80101a95:	89 d3                	mov    %edx,%ebx
80101a97:	c1 fb 1f             	sar    $0x1f,%ebx
80101a9a:	c1 eb 19             	shr    $0x19,%ebx
80101a9d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101aa0:	83 e1 7f             	and    $0x7f,%ecx
80101aa3:	29 d9                	sub    %ebx,%ecx
80101aa5:	0f b6 99 80 0e 11 80 	movzbl -0x7feef180(%ecx),%ebx
80101aac:	89 c1                	mov    %eax,%ecx
80101aae:	c1 f9 1f             	sar    $0x1f,%ecx
80101ab1:	c1 e9 19             	shr    $0x19,%ecx
80101ab4:	01 c8                	add    %ecx,%eax
80101ab6:	83 e0 7f             	and    $0x7f,%eax
80101ab9:	29 c8                	sub    %ecx,%eax
80101abb:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101ac1:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101ac6:	89 c3                	mov    %eax,%ebx
80101ac8:	29 f3                	sub    %esi,%ebx
80101aca:	39 d3                	cmp    %edx,%ebx
80101acc:	72 c2                	jb     80101a90 <consoleintr+0x300>
          input.buf[(input.e ++ - cap) % INPUT_BUF] = clipboard[i];
80101ace:	83 c0 01             	add    $0x1,%eax
80101ad1:	83 e3 7f             	and    $0x7f,%ebx
80101ad4:	a3 08 0f 11 80       	mov    %eax,0x80110f08
80101ad9:	89 f8                	mov    %edi,%eax
80101adb:	88 83 80 0e 11 80    	mov    %al,-0x7feef180(%ebx)
  if(panicked) {
80101ae1:	8b 1d fc 1a 11 80    	mov    0x80111afc,%ebx
80101ae7:	85 db                	test   %ebx,%ebx
80101ae9:	0f 84 b9 02 00 00    	je     80101da8 <consoleintr+0x618>
80101aef:	fa                   	cli
    for(;;)
80101af0:	eb fe                	jmp    80101af0 <consoleintr+0x360>
80101af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      start_copy = input.e;
80101af8:	a1 08 0f 11 80       	mov    0x80110f08,%eax
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101afd:	83 ec 04             	sub    $0x4,%esp
      saveStatus = 1;
80101b00:	c7 05 18 14 11 80 01 	movl   $0x1,0x80111418
80101b07:	00 00 00 
      saveIndex = 0;
80101b0a:	c7 05 14 14 11 80 00 	movl   $0x0,0x80111414
80101b11:	00 00 00 
      start_copy = input.e;
80101b14:	a3 10 14 11 80       	mov    %eax,0x80111410
      memset(clipboard, '\0', INPUT_BUF); // clear the clipborad
80101b19:	68 80 00 00 00       	push   $0x80
80101b1e:	6a 00                	push   $0x0
80101b20:	68 20 14 11 80       	push   $0x80111420
80101b25:	e8 a6 48 00 00       	call   801063d0 <memset>
      break;
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	e9 81 fc ff ff       	jmp    801017b3 <consoleintr+0x23>
80101b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (upDownKeyIndex > 0)
80101b38:	8b 0d 20 15 11 80    	mov    0x80111520,%ecx
80101b3e:	85 c9                	test   %ecx,%ecx
80101b40:	0f 8e 6d fc ff ff    	jle    801017b3 <consoleintr+0x23>
        showNewCommand();
80101b46:	e8 35 f3 ff ff       	call   80100e80 <showNewCommand>
80101b4b:	e9 63 fc ff ff       	jmp    801017b3 <consoleintr+0x23>
  if(panicked) {
80101b50:	8b 3d fc 1a 11 80    	mov    0x80111afc,%edi
80101b56:	85 ff                	test   %edi,%edi
80101b58:	74 64                	je     80101bbe <consoleintr+0x42e>
80101b5a:	fa                   	cli
    for(;;)
80101b5b:	eb fe                	jmp    80101b5b <consoleintr+0x3cb>
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101b60:	85 db                	test   %ebx,%ebx
80101b62:	0f 84 4b fc ff ff    	je     801017b3 <consoleintr+0x23>
80101b68:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101b6d:	89 c2                	mov    %eax,%edx
80101b6f:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
80101b75:	83 fa 7f             	cmp    $0x7f,%edx
80101b78:	0f 87 35 fc ff ff    	ja     801017b3 <consoleintr+0x23>
        if (c=='\n'){
80101b7e:	83 fb 0a             	cmp    $0xa,%ebx
80101b81:	74 09                	je     80101b8c <consoleintr+0x3fc>
80101b83:	83 fb 0d             	cmp    $0xd,%ebx
80101b86:	0f 85 c3 00 00 00    	jne    80101c4f <consoleintr+0x4bf>
          cap = 0;
80101b8c:	c7 05 f8 1a 11 80 00 	movl   $0x0,0x80111af8
80101b93:	00 00 00 
  for (int i = input.e; i > input.e - cap; i--)
80101b96:	bb 0a 00 00 00       	mov    $0xa,%ebx
          addNewCommandToHistory();
80101b9b:	e8 00 f0 ff ff       	call   80100ba0 <addNewCommandToHistory>
          controlNewCommand();
80101ba0:	e8 3b f6 ff ff       	call   801011e0 <controlNewCommand>
  for (int i = input.e; i > input.e - cap; i--)
80101ba5:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101baa:	b9 0a 00 00 00       	mov    $0xa,%ecx
          upDownKeyIndex = 0;
80101baf:	c7 05 20 15 11 80 00 	movl   $0x0,0x80111520
80101bb6:	00 00 00 
80101bb9:	e9 93 00 00 00       	jmp    80101c51 <consoleintr+0x4c1>
80101bbe:	b8 3f 00 00 00       	mov    $0x3f,%eax
80101bc3:	e8 08 e9 ff ff       	call   801004d0 <consputc.part.0>
      input.buf[(input.e++) % INPUT_BUF] = c;
80101bc8:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101bcd:	8d 50 01             	lea    0x1(%eax),%edx
80101bd0:	83 e0 7f             	and    $0x7f,%eax
80101bd3:	89 15 08 0f 11 80    	mov    %edx,0x80110f08
80101bd9:	c6 80 80 0e 11 80 3f 	movb   $0x3f,-0x7feef180(%eax)
      extractAndCompute(); // Check for NON=? and compute the result
80101be0:	e8 eb f7 ff ff       	call   801013d0 <extractAndCompute>
      break;
80101be5:	e9 c9 fb ff ff       	jmp    801017b3 <consoleintr+0x23>
    switch(c){
80101bea:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80101bf1:	e9 bd fb ff ff       	jmp    801017b3 <consoleintr+0x23>
  if (pos+1 >= first_write_index)
80101bf6:	8d 53 01             	lea    0x1(%ebx),%edx
80101bf9:	39 d0                	cmp    %edx,%eax
80101bfb:	0f 8e b1 fd ff ff    	jle    801019b2 <consoleintr+0x222>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c01:	be d4 03 00 00       	mov    $0x3d4,%esi
80101c06:	b8 0e 00 00 00       	mov    $0xe,%eax
80101c0b:	89 f2                	mov    %esi,%edx
80101c0d:	ee                   	out    %al,(%dx)
80101c0e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT + 1, pos >> 8);
80101c13:	89 d8                	mov    %ebx,%eax
80101c15:	c1 f8 08             	sar    $0x8,%eax
80101c18:	89 ca                	mov    %ecx,%edx
80101c1a:	ee                   	out    %al,(%dx)
80101c1b:	b8 0f 00 00 00       	mov    $0xf,%eax
80101c20:	89 f2                	mov    %esi,%edx
80101c22:	ee                   	out    %al,(%dx)
80101c23:	89 d8                	mov    %ebx,%eax
80101c25:	89 ca                	mov    %ecx,%edx
80101c27:	ee                   	out    %al,(%dx)
}
80101c28:	e9 86 fb ff ff       	jmp    801017b3 <consoleintr+0x23>
}
80101c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c30:	5b                   	pop    %ebx
80101c31:	5e                   	pop    %esi
80101c32:	5f                   	pop    %edi
80101c33:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80101c34:	e9 57 39 00 00       	jmp    80105590 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101c39:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101c3e:	89 c2                	mov    %eax,%edx
80101c40:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
80101c46:	83 fa 7f             	cmp    $0x7f,%edx
80101c49:	0f 87 64 fb ff ff    	ja     801017b3 <consoleintr+0x23>
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101c4f:	89 d9                	mov    %ebx,%ecx
  for (int i = input.e; i > input.e - cap; i--)
80101c51:	8b 35 f8 1a 11 80    	mov    0x80111af8,%esi
80101c57:	89 c7                	mov    %eax,%edi
80101c59:	89 c2                	mov    %eax,%edx
80101c5b:	29 f7                	sub    %esi,%edi
80101c5d:	39 c7                	cmp    %eax,%edi
80101c5f:	73 56                	jae    80101cb7 <consoleintr+0x527>
80101c61:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80101c64:	89 cf                	mov    %ecx,%edi
80101c66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c6d:	00 
80101c6e:	66 90                	xchg   %ax,%ax
    buf[(i) % INPUT_BUF] = buf[(i-1) % INPUT_BUF]; // Shift elements to right
80101c70:	89 d0                	mov    %edx,%eax
80101c72:	83 ea 01             	sub    $0x1,%edx
80101c75:	89 d3                	mov    %edx,%ebx
80101c77:	c1 fb 1f             	sar    $0x1f,%ebx
80101c7a:	c1 eb 19             	shr    $0x19,%ebx
80101c7d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101c80:	83 e1 7f             	and    $0x7f,%ecx
80101c83:	29 d9                	sub    %ebx,%ecx
80101c85:	89 c3                	mov    %eax,%ebx
80101c87:	c1 fb 1f             	sar    $0x1f,%ebx
80101c8a:	0f b6 89 80 0e 11 80 	movzbl -0x7feef180(%ecx),%ecx
80101c91:	c1 eb 19             	shr    $0x19,%ebx
80101c94:	01 d8                	add    %ebx,%eax
80101c96:	83 e0 7f             	and    $0x7f,%eax
80101c99:	29 d8                	sub    %ebx,%eax
80101c9b:	88 88 80 0e 11 80    	mov    %cl,-0x7feef180(%eax)
  for (int i = input.e; i > input.e - cap; i--)
80101ca1:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101ca6:	89 c1                	mov    %eax,%ecx
80101ca8:	29 f1                	sub    %esi,%ecx
80101caa:	39 d1                	cmp    %edx,%ecx
80101cac:	72 c2                	jb     80101c70 <consoleintr+0x4e0>
80101cae:	89 fa                	mov    %edi,%edx
80101cb0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101cb3:	89 cf                	mov    %ecx,%edi
80101cb5:	89 d1                	mov    %edx,%ecx
  if(panicked) {
80101cb7:	8b 15 fc 1a 11 80    	mov    0x80111afc,%edx
        input.buf[(input.e++ - cap) % INPUT_BUF] = c;
80101cbd:	83 c0 01             	add    $0x1,%eax
80101cc0:	83 e7 7f             	and    $0x7f,%edi
80101cc3:	a3 08 0f 11 80       	mov    %eax,0x80110f08
80101cc8:	88 8f 80 0e 11 80    	mov    %cl,-0x7feef180(%edi)
  if(panicked) {
80101cce:	85 d2                	test   %edx,%edx
80101cd0:	0f 84 93 00 00 00    	je     80101d69 <consoleintr+0x5d9>
  asm volatile("cli");
80101cd6:	fa                   	cli
    for(;;)
80101cd7:	eb fe                	jmp    80101cd7 <consoleintr+0x547>
80101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ce0:	b8 00 01 00 00       	mov    $0x100,%eax
80101ce5:	e8 e6 e7 ff ff       	call   801004d0 <consputc.part.0>
          if (cap == 0)
80101cea:	a1 f8 1a 11 80       	mov    0x80111af8,%eax
80101cef:	85 c0                	test   %eax,%eax
80101cf1:	0f 85 bc fa ff ff    	jne    801017b3 <consoleintr+0x23>
            input.buf[input.e] = '\0';
80101cf7:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101cfc:	c6 80 80 0e 11 80 00 	movb   $0x0,-0x7feef180(%eax)
80101d03:	e9 ab fa ff ff       	jmp    801017b3 <consoleintr+0x23>
  int k = 0;
80101d08:	31 d2                	xor    %edx,%edx
80101d0a:	e9 4d fd ff ff       	jmp    80101a5c <consoleintr+0x2cc>
  for (int i = input.e - cap - 1; i < input.e; i++)
80101d0f:	89 da                	mov    %ebx,%edx
80101d11:	29 ca                	sub    %ecx,%edx
80101d13:	39 c2                	cmp    %eax,%edx
80101d15:	73 46                	jae    80101d5d <consoleintr+0x5cd>
80101d17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d1e:	00 
80101d1f:	90                   	nop
    buf[(i) % INPUT_BUF] = buf[(i + 1) % INPUT_BUF]; // Shift elements to left
80101d20:	89 d0                	mov    %edx,%eax
80101d22:	83 c2 01             	add    $0x1,%edx
80101d25:	89 d3                	mov    %edx,%ebx
80101d27:	c1 fb 1f             	sar    $0x1f,%ebx
80101d2a:	c1 eb 19             	shr    $0x19,%ebx
80101d2d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101d30:	83 e1 7f             	and    $0x7f,%ecx
80101d33:	29 d9                	sub    %ebx,%ecx
80101d35:	0f b6 99 80 0e 11 80 	movzbl -0x7feef180(%ecx),%ebx
80101d3c:	89 c1                	mov    %eax,%ecx
80101d3e:	c1 f9 1f             	sar    $0x1f,%ecx
80101d41:	c1 e9 19             	shr    $0x19,%ecx
80101d44:	01 c8                	add    %ecx,%eax
80101d46:	83 e0 7f             	and    $0x7f,%eax
80101d49:	29 c8                	sub    %ecx,%eax
80101d4b:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
  for (int i = input.e - cap - 1; i < input.e; i++)
80101d51:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101d56:	39 c2                	cmp    %eax,%edx
80101d58:	72 c6                	jb     80101d20 <consoleintr+0x590>
          input.e--;
80101d5a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  input.buf[input.e] = ' ';
80101d5d:	c6 80 80 0e 11 80 20 	movb   $0x20,-0x7feef180(%eax)
}
80101d64:	e9 87 fc ff ff       	jmp    801019f0 <consoleintr+0x260>
80101d69:	89 d8                	mov    %ebx,%eax
80101d6b:	e8 60 e7 ff ff       	call   801004d0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101d70:	83 fb 0a             	cmp    $0xa,%ebx
80101d73:	74 59                	je     80101dce <consoleintr+0x63e>
80101d75:	83 fb 04             	cmp    $0x4,%ebx
80101d78:	74 54                	je     80101dce <consoleintr+0x63e>
80101d7a:	a1 00 0f 11 80       	mov    0x80110f00,%eax
80101d7f:	83 e8 80             	sub    $0xffffff80,%eax
80101d82:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
80101d88:	0f 85 25 fa ff ff    	jne    801017b3 <consoleintr+0x23>
          wakeup(&input.r);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101d91:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80101d96:	68 00 0f 11 80       	push   $0x80110f00
80101d9b:	e8 10 37 00 00       	call   801054b0 <wakeup>
80101da0:	83 c4 10             	add    $0x10,%esp
80101da3:	e9 0b fa ff ff       	jmp    801017b3 <consoleintr+0x23>
          consputc(clipboard[i]);  
80101da8:	0f be c0             	movsbl %al,%eax
80101dab:	e8 20 e7 ff ff       	call   801004d0 <consputc.part.0>
          i++;
80101db0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80101db4:	8b 45 dc             	mov    -0x24(%ebp),%eax
        while(clipboard[i] != '\0')
80101db7:	0f b6 b8 20 14 11 80 	movzbl -0x7feeebe0(%eax),%edi
80101dbe:	89 f8                	mov    %edi,%eax
80101dc0:	84 c0                	test   %al,%al
80101dc2:	74 11                	je     80101dd5 <consoleintr+0x645>
  for (int i = input.e; i > input.e - cap; i--)
80101dc4:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101dc9:	e9 ab fc ff ff       	jmp    80101a79 <consoleintr+0x2e9>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101dce:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80101dd3:	eb b9                	jmp    80101d8e <consoleintr+0x5fe>
        saveStatus = 0;
80101dd5:	c7 05 18 14 11 80 00 	movl   $0x0,0x80111418
80101ddc:	00 00 00 
80101ddf:	e9 cf f9 ff ff       	jmp    801017b3 <consoleintr+0x23>
80101de4:	66 90                	xchg   %ax,%ax
80101de6:	66 90                	xchg   %ax,%ax
80101de8:	66 90                	xchg   %ax,%ax
80101dea:	66 90                	xchg   %ax,%ax
80101dec:	66 90                	xchg   %ax,%ax
80101dee:	66 90                	xchg   %ax,%ax

80101df0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101dfc:	e8 ef 2e 00 00       	call   80104cf0 <myproc>
80101e01:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101e07:	e8 74 22 00 00       	call   80104080 <begin_op>

  if((ip = namei(path)) == 0){
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	ff 75 08             	push   0x8(%ebp)
80101e12:	e8 a9 15 00 00       	call   801033c0 <namei>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	0f 84 30 03 00 00    	je     80102152 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101e22:	83 ec 0c             	sub    $0xc,%esp
80101e25:	89 c7                	mov    %eax,%edi
80101e27:	50                   	push   %eax
80101e28:	e8 b3 0c 00 00       	call   80102ae0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101e2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101e33:	6a 34                	push   $0x34
80101e35:	6a 00                	push   $0x0
80101e37:	50                   	push   %eax
80101e38:	57                   	push   %edi
80101e39:	e8 b2 0f 00 00       	call   80102df0 <readi>
80101e3e:	83 c4 20             	add    $0x20,%esp
80101e41:	83 f8 34             	cmp    $0x34,%eax
80101e44:	0f 85 01 01 00 00    	jne    80101f4b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80101e4a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101e51:	45 4c 46 
80101e54:	0f 85 f1 00 00 00    	jne    80101f4b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80101e5a:	e8 b1 70 00 00       	call   80108f10 <setupkvm>
80101e5f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101e65:	85 c0                	test   %eax,%eax
80101e67:	0f 84 de 00 00 00    	je     80101f4b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101e6d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101e74:	00 
80101e75:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101e7b:	0f 84 a1 02 00 00    	je     80102122 <exec+0x332>
  sz = 0;
80101e81:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101e88:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101e8b:	31 db                	xor    %ebx,%ebx
80101e8d:	e9 8c 00 00 00       	jmp    80101f1e <exec+0x12e>
80101e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101e98:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101e9f:	75 6c                	jne    80101f0d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101ea1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101ea7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101ead:	0f 82 87 00 00 00    	jb     80101f3a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101eb3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101eb9:	72 7f                	jb     80101f3a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101ebb:	83 ec 04             	sub    $0x4,%esp
80101ebe:	50                   	push   %eax
80101ebf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101ec5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101ecb:	e8 70 6e 00 00       	call   80108d40 <allocuvm>
80101ed0:	83 c4 10             	add    $0x10,%esp
80101ed3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101ed9:	85 c0                	test   %eax,%eax
80101edb:	74 5d                	je     80101f3a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80101edd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101ee3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101ee8:	75 50                	jne    80101f3a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101eea:	83 ec 0c             	sub    $0xc,%esp
80101eed:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101ef3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101ef9:	57                   	push   %edi
80101efa:	50                   	push   %eax
80101efb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101f01:	e8 6a 6d 00 00       	call   80108c70 <loaduvm>
80101f06:	83 c4 20             	add    $0x20,%esp
80101f09:	85 c0                	test   %eax,%eax
80101f0b:	78 2d                	js     80101f3a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f0d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101f14:	83 c3 01             	add    $0x1,%ebx
80101f17:	83 c6 20             	add    $0x20,%esi
80101f1a:	39 d8                	cmp    %ebx,%eax
80101f1c:	7e 52                	jle    80101f70 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101f1e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101f24:	6a 20                	push   $0x20
80101f26:	56                   	push   %esi
80101f27:	50                   	push   %eax
80101f28:	57                   	push   %edi
80101f29:	e8 c2 0e 00 00       	call   80102df0 <readi>
80101f2e:	83 c4 10             	add    $0x10,%esp
80101f31:	83 f8 20             	cmp    $0x20,%eax
80101f34:	0f 84 5e ff ff ff    	je     80101e98 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80101f3a:	83 ec 0c             	sub    $0xc,%esp
80101f3d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101f43:	e8 48 6f 00 00       	call   80108e90 <freevm>
  if(ip){
80101f48:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80101f4b:	83 ec 0c             	sub    $0xc,%esp
80101f4e:	57                   	push   %edi
80101f4f:	e8 1c 0e 00 00       	call   80102d70 <iunlockput>
    end_op();
80101f54:	e8 97 21 00 00       	call   801040f0 <end_op>
80101f59:	83 c4 10             	add    $0x10,%esp
    return -1;
80101f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80101f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f64:	5b                   	pop    %ebx
80101f65:	5e                   	pop    %esi
80101f66:	5f                   	pop    %edi
80101f67:	5d                   	pop    %ebp
80101f68:	c3                   	ret
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80101f70:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101f76:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80101f7c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101f82:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	57                   	push   %edi
80101f8c:	e8 df 0d 00 00       	call   80102d70 <iunlockput>
  end_op();
80101f91:	e8 5a 21 00 00       	call   801040f0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101f96:	83 c4 0c             	add    $0xc,%esp
80101f99:	53                   	push   %ebx
80101f9a:	56                   	push   %esi
80101f9b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101fa1:	56                   	push   %esi
80101fa2:	e8 99 6d 00 00       	call   80108d40 <allocuvm>
80101fa7:	83 c4 10             	add    $0x10,%esp
80101faa:	89 c7                	mov    %eax,%edi
80101fac:	85 c0                	test   %eax,%eax
80101fae:	0f 84 86 00 00 00    	je     8010203a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101fb4:	83 ec 08             	sub    $0x8,%esp
80101fb7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80101fbd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101fbf:	50                   	push   %eax
80101fc0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101fc1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101fc3:	e8 e8 6f 00 00       	call   80108fb0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	8b 10                	mov    (%eax),%edx
80101fd0:	85 d2                	test   %edx,%edx
80101fd2:	0f 84 56 01 00 00    	je     8010212e <exec+0x33e>
80101fd8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80101fde:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101fe1:	eb 23                	jmp    80102006 <exec+0x216>
80101fe3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101fe8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80101feb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80101ff2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101ff8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101ffb:	85 d2                	test   %edx,%edx
80101ffd:	74 51                	je     80102050 <exec+0x260>
    if(argc >= MAXARG)
80101fff:	83 f8 20             	cmp    $0x20,%eax
80102002:	74 36                	je     8010203a <exec+0x24a>
80102004:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102006:	83 ec 0c             	sub    $0xc,%esp
80102009:	52                   	push   %edx
8010200a:	e8 b1 45 00 00       	call   801065c0 <strlen>
8010200f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80102011:	58                   	pop    %eax
80102012:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102015:	83 eb 01             	sub    $0x1,%ebx
80102018:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010201b:	e8 a0 45 00 00       	call   801065c0 <strlen>
80102020:	83 c0 01             	add    $0x1,%eax
80102023:	50                   	push   %eax
80102024:	ff 34 b7             	push   (%edi,%esi,4)
80102027:	53                   	push   %ebx
80102028:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010202e:	e8 4d 71 00 00       	call   80109180 <copyout>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	85 c0                	test   %eax,%eax
80102038:	79 ae                	jns    80101fe8 <exec+0x1f8>
    freevm(pgdir);
8010203a:	83 ec 0c             	sub    $0xc,%esp
8010203d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102043:	e8 48 6e 00 00       	call   80108e90 <freevm>
80102048:	83 c4 10             	add    $0x10,%esp
8010204b:	e9 0c ff ff ff       	jmp    80101f5c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102050:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80102057:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
8010205d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80102063:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80102066:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80102069:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80102070:	00 00 00 00 
  ustack[1] = argc;
80102074:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010207a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80102081:	ff ff ff 
  ustack[1] = argc;
80102084:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010208a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010208c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010208e:	29 d0                	sub    %edx,%eax
80102090:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102096:	56                   	push   %esi
80102097:	51                   	push   %ecx
80102098:	53                   	push   %ebx
80102099:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010209f:	e8 dc 70 00 00       	call   80109180 <copyout>
801020a4:	83 c4 10             	add    $0x10,%esp
801020a7:	85 c0                	test   %eax,%eax
801020a9:	78 8f                	js     8010203a <exec+0x24a>
  for(last=s=path; *s; s++)
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
801020ae:	8b 55 08             	mov    0x8(%ebp),%edx
801020b1:	0f b6 00             	movzbl (%eax),%eax
801020b4:	84 c0                	test   %al,%al
801020b6:	74 17                	je     801020cf <exec+0x2df>
801020b8:	89 d1                	mov    %edx,%ecx
801020ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
801020c0:	83 c1 01             	add    $0x1,%ecx
801020c3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801020c5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
801020c8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801020cb:	84 c0                	test   %al,%al
801020cd:	75 f1                	jne    801020c0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801020cf:	83 ec 04             	sub    $0x4,%esp
801020d2:	6a 10                	push   $0x10
801020d4:	52                   	push   %edx
801020d5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
801020db:	8d 46 6c             	lea    0x6c(%esi),%eax
801020de:	50                   	push   %eax
801020df:	e8 9c 44 00 00       	call   80106580 <safestrcpy>
  curproc->pgdir = pgdir;
801020e4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801020ea:	89 f0                	mov    %esi,%eax
801020ec:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
801020ef:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
801020f1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801020f4:	89 c1                	mov    %eax,%ecx
801020f6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801020fc:	8b 40 18             	mov    0x18(%eax),%eax
801020ff:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80102102:	8b 41 18             	mov    0x18(%ecx),%eax
80102105:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80102108:	89 0c 24             	mov    %ecx,(%esp)
8010210b:	e8 d0 69 00 00       	call   80108ae0 <switchuvm>
  freevm(oldpgdir);
80102110:	89 34 24             	mov    %esi,(%esp)
80102113:	e8 78 6d 00 00       	call   80108e90 <freevm>
  return 0;
80102118:	83 c4 10             	add    $0x10,%esp
8010211b:	31 c0                	xor    %eax,%eax
8010211d:	e9 3f fe ff ff       	jmp    80101f61 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102122:	bb 00 20 00 00       	mov    $0x2000,%ebx
80102127:	31 f6                	xor    %esi,%esi
80102129:	e9 5a fe ff ff       	jmp    80101f88 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
8010212e:	be 10 00 00 00       	mov    $0x10,%esi
80102133:	ba 04 00 00 00       	mov    $0x4,%edx
80102138:	b8 03 00 00 00       	mov    $0x3,%eax
8010213d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80102144:	00 00 00 
80102147:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
8010214d:	e9 17 ff ff ff       	jmp    80102069 <exec+0x279>
    end_op();
80102152:	e8 99 1f 00 00       	call   801040f0 <end_op>
    cprintf("exec: fail\n");
80102157:	83 ec 0c             	sub    $0xc,%esp
8010215a:	68 d0 92 10 80       	push   $0x801092d0
8010215f:	e8 7c e6 ff ff       	call   801007e0 <cprintf>
    return -1;
80102164:	83 c4 10             	add    $0x10,%esp
80102167:	e9 f0 fd ff ff       	jmp    80101f5c <exec+0x16c>
8010216c:	66 90                	xchg   %ax,%ax
8010216e:	66 90                	xchg   %ax,%ax

80102170 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102176:	68 dc 92 10 80       	push   $0x801092dc
8010217b:	68 00 1b 11 80       	push   $0x80111b00
80102180:	e8 5b 3f 00 00       	call   801060e0 <initlock>
}
80102185:	83 c4 10             	add    $0x10,%esp
80102188:	c9                   	leave
80102189:	c3                   	ret
8010218a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102190 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102194:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
{
80102199:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010219c:	68 00 1b 11 80       	push   $0x80111b00
801021a1:	e8 2a 41 00 00       	call   801062d0 <acquire>
801021a6:	83 c4 10             	add    $0x10,%esp
801021a9:	eb 10                	jmp    801021bb <filealloc+0x2b>
801021ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801021b0:	83 c3 18             	add    $0x18,%ebx
801021b3:	81 fb 94 24 11 80    	cmp    $0x80112494,%ebx
801021b9:	74 25                	je     801021e0 <filealloc+0x50>
    if(f->ref == 0){
801021bb:	8b 43 04             	mov    0x4(%ebx),%eax
801021be:	85 c0                	test   %eax,%eax
801021c0:	75 ee                	jne    801021b0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801021c2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801021c5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801021cc:	68 00 1b 11 80       	push   $0x80111b00
801021d1:	e8 9a 40 00 00       	call   80106270 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801021d6:	89 d8                	mov    %ebx,%eax
      return f;
801021d8:	83 c4 10             	add    $0x10,%esp
}
801021db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021de:	c9                   	leave
801021df:	c3                   	ret
  release(&ftable.lock);
801021e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801021e3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801021e5:	68 00 1b 11 80       	push   $0x80111b00
801021ea:	e8 81 40 00 00       	call   80106270 <release>
}
801021ef:	89 d8                	mov    %ebx,%eax
  return 0;
801021f1:	83 c4 10             	add    $0x10,%esp
}
801021f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021f7:	c9                   	leave
801021f8:	c3                   	ret
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102200 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 10             	sub    $0x10,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010220a:	68 00 1b 11 80       	push   $0x80111b00
8010220f:	e8 bc 40 00 00       	call   801062d0 <acquire>
  if(f->ref < 1)
80102214:	8b 43 04             	mov    0x4(%ebx),%eax
80102217:	83 c4 10             	add    $0x10,%esp
8010221a:	85 c0                	test   %eax,%eax
8010221c:	7e 1a                	jle    80102238 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010221e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80102221:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80102224:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80102227:	68 00 1b 11 80       	push   $0x80111b00
8010222c:	e8 3f 40 00 00       	call   80106270 <release>
  return f;
}
80102231:	89 d8                	mov    %ebx,%eax
80102233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102236:	c9                   	leave
80102237:	c3                   	ret
    panic("filedup");
80102238:	83 ec 0c             	sub    $0xc,%esp
8010223b:	68 e3 92 10 80       	push   $0x801092e3
80102240:	e8 0b e2 ff ff       	call   80100450 <panic>
80102245:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010224c:	00 
8010224d:	8d 76 00             	lea    0x0(%esi),%esi

80102250 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 28             	sub    $0x28,%esp
80102259:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010225c:	68 00 1b 11 80       	push   $0x80111b00
80102261:	e8 6a 40 00 00       	call   801062d0 <acquire>
  if(f->ref < 1)
80102266:	8b 53 04             	mov    0x4(%ebx),%edx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 d2                	test   %edx,%edx
8010226e:	0f 8e a5 00 00 00    	jle    80102319 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102274:	83 ea 01             	sub    $0x1,%edx
80102277:	89 53 04             	mov    %edx,0x4(%ebx)
8010227a:	75 44                	jne    801022c0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010227c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102280:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102283:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010228b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010228e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102291:	8b 43 10             	mov    0x10(%ebx),%eax
80102294:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80102297:	68 00 1b 11 80       	push   $0x80111b00
8010229c:	e8 cf 3f 00 00       	call   80106270 <release>

  if(ff.type == FD_PIPE)
801022a1:	83 c4 10             	add    $0x10,%esp
801022a4:	83 ff 01             	cmp    $0x1,%edi
801022a7:	74 57                	je     80102300 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801022a9:	83 ff 02             	cmp    $0x2,%edi
801022ac:	74 2a                	je     801022d8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801022ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b1:	5b                   	pop    %ebx
801022b2:	5e                   	pop    %esi
801022b3:	5f                   	pop    %edi
801022b4:	5d                   	pop    %ebp
801022b5:	c3                   	ret
801022b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022bd:	00 
801022be:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
801022c0:	c7 45 08 00 1b 11 80 	movl   $0x80111b00,0x8(%ebp)
}
801022c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ca:	5b                   	pop    %ebx
801022cb:	5e                   	pop    %esi
801022cc:	5f                   	pop    %edi
801022cd:	5d                   	pop    %ebp
    release(&ftable.lock);
801022ce:	e9 9d 3f 00 00       	jmp    80106270 <release>
801022d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
801022d8:	e8 a3 1d 00 00       	call   80104080 <begin_op>
    iput(ff.ip);
801022dd:	83 ec 0c             	sub    $0xc,%esp
801022e0:	ff 75 e0             	push   -0x20(%ebp)
801022e3:	e8 28 09 00 00       	call   80102c10 <iput>
    end_op();
801022e8:	83 c4 10             	add    $0x10,%esp
}
801022eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ee:	5b                   	pop    %ebx
801022ef:	5e                   	pop    %esi
801022f0:	5f                   	pop    %edi
801022f1:	5d                   	pop    %ebp
    end_op();
801022f2:	e9 f9 1d 00 00       	jmp    801040f0 <end_op>
801022f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022fe:	00 
801022ff:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80102300:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102304:	83 ec 08             	sub    $0x8,%esp
80102307:	53                   	push   %ebx
80102308:	56                   	push   %esi
80102309:	e8 32 25 00 00       	call   80104840 <pipeclose>
8010230e:	83 c4 10             	add    $0x10,%esp
}
80102311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102314:	5b                   	pop    %ebx
80102315:	5e                   	pop    %esi
80102316:	5f                   	pop    %edi
80102317:	5d                   	pop    %ebp
80102318:	c3                   	ret
    panic("fileclose");
80102319:	83 ec 0c             	sub    $0xc,%esp
8010231c:	68 eb 92 10 80       	push   $0x801092eb
80102321:	e8 2a e1 ff ff       	call   80100450 <panic>
80102326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010232d:	00 
8010232e:	66 90                	xchg   %ax,%ax

80102330 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 04             	sub    $0x4,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010233a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010233d:	75 31                	jne    80102370 <filestat+0x40>
    ilock(f->ip);
8010233f:	83 ec 0c             	sub    $0xc,%esp
80102342:	ff 73 10             	push   0x10(%ebx)
80102345:	e8 96 07 00 00       	call   80102ae0 <ilock>
    stati(f->ip, st);
8010234a:	58                   	pop    %eax
8010234b:	5a                   	pop    %edx
8010234c:	ff 75 0c             	push   0xc(%ebp)
8010234f:	ff 73 10             	push   0x10(%ebx)
80102352:	e8 69 0a 00 00       	call   80102dc0 <stati>
    iunlock(f->ip);
80102357:	59                   	pop    %ecx
80102358:	ff 73 10             	push   0x10(%ebx)
8010235b:	e8 60 08 00 00       	call   80102bc0 <iunlock>
    return 0;
  }
  return -1;
}
80102360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102363:	83 c4 10             	add    $0x10,%esp
80102366:	31 c0                	xor    %eax,%eax
}
80102368:	c9                   	leave
80102369:	c3                   	ret
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102378:	c9                   	leave
80102379:	c3                   	ret
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	57                   	push   %edi
80102384:	56                   	push   %esi
80102385:	53                   	push   %ebx
80102386:	83 ec 0c             	sub    $0xc,%esp
80102389:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010238c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010238f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102392:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102396:	74 60                	je     801023f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102398:	8b 03                	mov    (%ebx),%eax
8010239a:	83 f8 01             	cmp    $0x1,%eax
8010239d:	74 41                	je     801023e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010239f:	83 f8 02             	cmp    $0x2,%eax
801023a2:	75 5b                	jne    801023ff <fileread+0x7f>
    ilock(f->ip);
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	ff 73 10             	push   0x10(%ebx)
801023aa:	e8 31 07 00 00       	call   80102ae0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801023af:	57                   	push   %edi
801023b0:	ff 73 14             	push   0x14(%ebx)
801023b3:	56                   	push   %esi
801023b4:	ff 73 10             	push   0x10(%ebx)
801023b7:	e8 34 0a 00 00       	call   80102df0 <readi>
801023bc:	83 c4 20             	add    $0x20,%esp
801023bf:	89 c6                	mov    %eax,%esi
801023c1:	85 c0                	test   %eax,%eax
801023c3:	7e 03                	jle    801023c8 <fileread+0x48>
      f->off += r;
801023c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801023c8:	83 ec 0c             	sub    $0xc,%esp
801023cb:	ff 73 10             	push   0x10(%ebx)
801023ce:	e8 ed 07 00 00       	call   80102bc0 <iunlock>
    return r;
801023d3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801023d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023d9:	89 f0                	mov    %esi,%eax
801023db:	5b                   	pop    %ebx
801023dc:	5e                   	pop    %esi
801023dd:	5f                   	pop    %edi
801023de:	5d                   	pop    %ebp
801023df:	c3                   	ret
    return piperead(f->pipe, addr, n);
801023e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801023e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801023e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e9:	5b                   	pop    %ebx
801023ea:	5e                   	pop    %esi
801023eb:	5f                   	pop    %edi
801023ec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801023ed:	e9 0e 26 00 00       	jmp    80104a00 <piperead>
801023f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801023f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801023fd:	eb d7                	jmp    801023d6 <fileread+0x56>
  panic("fileread");
801023ff:	83 ec 0c             	sub    $0xc,%esp
80102402:	68 f5 92 10 80       	push   $0x801092f5
80102407:	e8 44 e0 ff ff       	call   80100450 <panic>
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	57                   	push   %edi
80102414:	56                   	push   %esi
80102415:	53                   	push   %ebx
80102416:	83 ec 1c             	sub    $0x1c,%esp
80102419:	8b 45 0c             	mov    0xc(%ebp),%eax
8010241c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010241f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102422:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80102425:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80102429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010242c:	0f 84 bb 00 00 00    	je     801024ed <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80102432:	8b 03                	mov    (%ebx),%eax
80102434:	83 f8 01             	cmp    $0x1,%eax
80102437:	0f 84 bf 00 00 00    	je     801024fc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010243d:	83 f8 02             	cmp    $0x2,%eax
80102440:	0f 85 c8 00 00 00    	jne    8010250e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80102446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80102449:	31 f6                	xor    %esi,%esi
    while(i < n){
8010244b:	85 c0                	test   %eax,%eax
8010244d:	7f 30                	jg     8010247f <filewrite+0x6f>
8010244f:	e9 94 00 00 00       	jmp    801024e8 <filewrite+0xd8>
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102458:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010245b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010245e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102461:	ff 73 10             	push   0x10(%ebx)
80102464:	e8 57 07 00 00       	call   80102bc0 <iunlock>
      end_op();
80102469:	e8 82 1c 00 00       	call   801040f0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010246e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102471:	83 c4 10             	add    $0x10,%esp
80102474:	39 c7                	cmp    %eax,%edi
80102476:	75 5c                	jne    801024d4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102478:	01 fe                	add    %edi,%esi
    while(i < n){
8010247a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010247d:	7e 69                	jle    801024e8 <filewrite+0xd8>
      int n1 = n - i;
8010247f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80102482:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80102487:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80102489:	39 c7                	cmp    %eax,%edi
8010248b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010248e:	e8 ed 1b 00 00       	call   80104080 <begin_op>
      ilock(f->ip);
80102493:	83 ec 0c             	sub    $0xc,%esp
80102496:	ff 73 10             	push   0x10(%ebx)
80102499:	e8 42 06 00 00       	call   80102ae0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010249e:	57                   	push   %edi
8010249f:	ff 73 14             	push   0x14(%ebx)
801024a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801024a5:	01 f0                	add    %esi,%eax
801024a7:	50                   	push   %eax
801024a8:	ff 73 10             	push   0x10(%ebx)
801024ab:	e8 40 0a 00 00       	call   80102ef0 <writei>
801024b0:	83 c4 20             	add    $0x20,%esp
801024b3:	85 c0                	test   %eax,%eax
801024b5:	7f a1                	jg     80102458 <filewrite+0x48>
801024b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801024ba:	83 ec 0c             	sub    $0xc,%esp
801024bd:	ff 73 10             	push   0x10(%ebx)
801024c0:	e8 fb 06 00 00       	call   80102bc0 <iunlock>
      end_op();
801024c5:	e8 26 1c 00 00       	call   801040f0 <end_op>
      if(r < 0)
801024ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	85 c0                	test   %eax,%eax
801024d2:	75 14                	jne    801024e8 <filewrite+0xd8>
        panic("short filewrite");
801024d4:	83 ec 0c             	sub    $0xc,%esp
801024d7:	68 fe 92 10 80       	push   $0x801092fe
801024dc:	e8 6f df ff ff       	call   80100450 <panic>
801024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801024e8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801024eb:	74 05                	je     801024f2 <filewrite+0xe2>
801024ed:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801024f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024f5:	89 f0                	mov    %esi,%eax
801024f7:	5b                   	pop    %ebx
801024f8:	5e                   	pop    %esi
801024f9:	5f                   	pop    %edi
801024fa:	5d                   	pop    %ebp
801024fb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801024fc:	8b 43 0c             	mov    0xc(%ebx),%eax
801024ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102502:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102505:	5b                   	pop    %ebx
80102506:	5e                   	pop    %esi
80102507:	5f                   	pop    %edi
80102508:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80102509:	e9 d2 23 00 00       	jmp    801048e0 <pipewrite>
  panic("filewrite");
8010250e:	83 ec 0c             	sub    $0xc,%esp
80102511:	68 04 93 10 80       	push   $0x80109304
80102516:	e8 35 df ff ff       	call   80100450 <panic>
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	57                   	push   %edi
80102524:	56                   	push   %esi
80102525:	53                   	push   %ebx
80102526:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80102529:	8b 0d 54 41 11 80    	mov    0x80114154,%ecx
{
8010252f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102532:	85 c9                	test   %ecx,%ecx
80102534:	0f 84 8c 00 00 00    	je     801025c6 <balloc+0xa6>
8010253a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010253c:	89 f8                	mov    %edi,%eax
8010253e:	83 ec 08             	sub    $0x8,%esp
80102541:	89 fe                	mov    %edi,%esi
80102543:	c1 f8 0c             	sar    $0xc,%eax
80102546:	03 05 6c 41 11 80    	add    0x8011416c,%eax
8010254c:	50                   	push   %eax
8010254d:	ff 75 dc             	push   -0x24(%ebp)
80102550:	e8 7b db ff ff       	call   801000d0 <bread>
80102555:	89 7d d8             	mov    %edi,-0x28(%ebp)
80102558:	83 c4 10             	add    $0x10,%esp
8010255b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010255e:	a1 54 41 11 80       	mov    0x80114154,%eax
80102563:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102566:	31 c0                	xor    %eax,%eax
80102568:	eb 32                	jmp    8010259c <balloc+0x7c>
8010256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80102570:	89 c1                	mov    %eax,%ecx
80102572:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010257a:	83 e1 07             	and    $0x7,%ecx
8010257d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010257f:	89 c1                	mov    %eax,%ecx
80102581:	c1 f9 03             	sar    $0x3,%ecx
80102584:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80102589:	89 fa                	mov    %edi,%edx
8010258b:	85 df                	test   %ebx,%edi
8010258d:	74 49                	je     801025d8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010258f:	83 c0 01             	add    $0x1,%eax
80102592:	83 c6 01             	add    $0x1,%esi
80102595:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010259a:	74 07                	je     801025a3 <balloc+0x83>
8010259c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010259f:	39 d6                	cmp    %edx,%esi
801025a1:	72 cd                	jb     80102570 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801025a3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801025a6:	83 ec 0c             	sub    $0xc,%esp
801025a9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801025ac:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801025b2:	e8 39 dc ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801025b7:	83 c4 10             	add    $0x10,%esp
801025ba:	3b 3d 54 41 11 80    	cmp    0x80114154,%edi
801025c0:	0f 82 76 ff ff ff    	jb     8010253c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801025c6:	83 ec 0c             	sub    $0xc,%esp
801025c9:	68 0e 93 10 80       	push   $0x8010930e
801025ce:	e8 7d de ff ff       	call   80100450 <panic>
801025d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801025d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801025db:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801025de:	09 da                	or     %ebx,%edx
801025e0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801025e4:	57                   	push   %edi
801025e5:	e8 76 1c 00 00       	call   80104260 <log_write>
        brelse(bp);
801025ea:	89 3c 24             	mov    %edi,(%esp)
801025ed:	e8 fe db ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801025f2:	58                   	pop    %eax
801025f3:	5a                   	pop    %edx
801025f4:	56                   	push   %esi
801025f5:	ff 75 dc             	push   -0x24(%ebp)
801025f8:	e8 d3 da ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801025fd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102600:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80102602:	8d 40 5c             	lea    0x5c(%eax),%eax
80102605:	68 00 02 00 00       	push   $0x200
8010260a:	6a 00                	push   $0x0
8010260c:	50                   	push   %eax
8010260d:	e8 be 3d 00 00       	call   801063d0 <memset>
  log_write(bp);
80102612:	89 1c 24             	mov    %ebx,(%esp)
80102615:	e8 46 1c 00 00       	call   80104260 <log_write>
  brelse(bp);
8010261a:	89 1c 24             	mov    %ebx,(%esp)
8010261d:	e8 ce db ff ff       	call   801001f0 <brelse>
}
80102622:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102625:	89 f0                	mov    %esi,%eax
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5f                   	pop    %edi
8010262a:	5d                   	pop    %ebp
8010262b:	c3                   	ret
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102634:	31 ff                	xor    %edi,%edi
{
80102636:	56                   	push   %esi
80102637:	89 c6                	mov    %eax,%esi
80102639:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010263a:	bb 34 25 11 80       	mov    $0x80112534,%ebx
{
8010263f:	83 ec 28             	sub    $0x28,%esp
80102642:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102645:	68 00 25 11 80       	push   $0x80112500
8010264a:	e8 81 3c 00 00       	call   801062d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010264f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102652:	83 c4 10             	add    $0x10,%esp
80102655:	eb 1b                	jmp    80102672 <iget+0x42>
80102657:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265e:	00 
8010265f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102660:	39 33                	cmp    %esi,(%ebx)
80102662:	74 6c                	je     801026d0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102664:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010266a:	81 fb 54 41 11 80    	cmp    $0x80114154,%ebx
80102670:	74 26                	je     80102698 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102672:	8b 43 08             	mov    0x8(%ebx),%eax
80102675:	85 c0                	test   %eax,%eax
80102677:	7f e7                	jg     80102660 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80102679:	85 ff                	test   %edi,%edi
8010267b:	75 e7                	jne    80102664 <iget+0x34>
8010267d:	85 c0                	test   %eax,%eax
8010267f:	75 76                	jne    801026f7 <iget+0xc7>
      empty = ip;
80102681:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102683:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102689:	81 fb 54 41 11 80    	cmp    $0x80114154,%ebx
8010268f:	75 e1                	jne    80102672 <iget+0x42>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80102698:	85 ff                	test   %edi,%edi
8010269a:	74 79                	je     80102715 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010269c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010269f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801026a1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801026a4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801026ab:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801026b2:	68 00 25 11 80       	push   $0x80112500
801026b7:	e8 b4 3b 00 00       	call   80106270 <release>

  return ip;
801026bc:	83 c4 10             	add    $0x10,%esp
}
801026bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026c2:	89 f8                	mov    %edi,%eax
801026c4:	5b                   	pop    %ebx
801026c5:	5e                   	pop    %esi
801026c6:	5f                   	pop    %edi
801026c7:	5d                   	pop    %ebp
801026c8:	c3                   	ret
801026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801026d0:	39 53 04             	cmp    %edx,0x4(%ebx)
801026d3:	75 8f                	jne    80102664 <iget+0x34>
      ip->ref++;
801026d5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801026d8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801026db:	89 df                	mov    %ebx,%edi
      ip->ref++;
801026dd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801026e0:	68 00 25 11 80       	push   $0x80112500
801026e5:	e8 86 3b 00 00       	call   80106270 <release>
      return ip;
801026ea:	83 c4 10             	add    $0x10,%esp
}
801026ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026f0:	89 f8                	mov    %edi,%eax
801026f2:	5b                   	pop    %ebx
801026f3:	5e                   	pop    %esi
801026f4:	5f                   	pop    %edi
801026f5:	5d                   	pop    %ebp
801026f6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801026f7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801026fd:	81 fb 54 41 11 80    	cmp    $0x80114154,%ebx
80102703:	74 10                	je     80102715 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102705:	8b 43 08             	mov    0x8(%ebx),%eax
80102708:	85 c0                	test   %eax,%eax
8010270a:	0f 8f 50 ff ff ff    	jg     80102660 <iget+0x30>
80102710:	e9 68 ff ff ff       	jmp    8010267d <iget+0x4d>
    panic("iget: no inodes");
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	68 24 93 10 80       	push   $0x80109324
8010271d:	e8 2e dd ff ff       	call   80100450 <panic>
80102722:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102729:	00 
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102730 <bfree>:
{
80102730:	55                   	push   %ebp
80102731:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80102733:	89 d0                	mov    %edx,%eax
80102735:	c1 e8 0c             	shr    $0xc,%eax
{
80102738:	89 e5                	mov    %esp,%ebp
8010273a:	56                   	push   %esi
8010273b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010273c:	03 05 6c 41 11 80    	add    0x8011416c,%eax
{
80102742:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80102744:	83 ec 08             	sub    $0x8,%esp
80102747:	50                   	push   %eax
80102748:	51                   	push   %ecx
80102749:	e8 82 d9 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010274e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80102750:	c1 fb 03             	sar    $0x3,%ebx
80102753:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80102756:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80102758:	83 e1 07             	and    $0x7,%ecx
8010275b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80102760:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80102766:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80102768:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010276d:	85 c1                	test   %eax,%ecx
8010276f:	74 23                	je     80102794 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80102771:	f7 d0                	not    %eax
  log_write(bp);
80102773:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102776:	21 c8                	and    %ecx,%eax
80102778:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010277c:	56                   	push   %esi
8010277d:	e8 de 1a 00 00       	call   80104260 <log_write>
  brelse(bp);
80102782:	89 34 24             	mov    %esi,(%esp)
80102785:	e8 66 da ff ff       	call   801001f0 <brelse>
}
8010278a:	83 c4 10             	add    $0x10,%esp
8010278d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102790:	5b                   	pop    %ebx
80102791:	5e                   	pop    %esi
80102792:	5d                   	pop    %ebp
80102793:	c3                   	ret
    panic("freeing free block");
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 34 93 10 80       	push   $0x80109334
8010279c:	e8 af dc ff ff       	call   80100450 <panic>
801027a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027a8:	00 
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	57                   	push   %edi
801027b4:	56                   	push   %esi
801027b5:	89 c6                	mov    %eax,%esi
801027b7:	53                   	push   %ebx
801027b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801027bb:	83 fa 0b             	cmp    $0xb,%edx
801027be:	0f 86 8c 00 00 00    	jbe    80102850 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801027c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801027c7:	83 fb 7f             	cmp    $0x7f,%ebx
801027ca:	0f 87 a2 00 00 00    	ja     80102872 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801027d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 5e                	je     80102838 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801027da:	83 ec 08             	sub    $0x8,%esp
801027dd:	50                   	push   %eax
801027de:	ff 36                	push   (%esi)
801027e0:	e8 eb d8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801027e5:	83 c4 10             	add    $0x10,%esp
801027e8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801027ec:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801027ee:	8b 3b                	mov    (%ebx),%edi
801027f0:	85 ff                	test   %edi,%edi
801027f2:	74 1c                	je     80102810 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801027f4:	83 ec 0c             	sub    $0xc,%esp
801027f7:	52                   	push   %edx
801027f8:	e8 f3 d9 ff ff       	call   801001f0 <brelse>
801027fd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80102800:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102803:	89 f8                	mov    %edi,%eax
80102805:	5b                   	pop    %ebx
80102806:	5e                   	pop    %esi
80102807:	5f                   	pop    %edi
80102808:	5d                   	pop    %ebp
80102809:	c3                   	ret
8010280a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80102813:	8b 06                	mov    (%esi),%eax
80102815:	e8 06 fd ff ff       	call   80102520 <balloc>
      log_write(bp);
8010281a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010281d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80102820:	89 03                	mov    %eax,(%ebx)
80102822:	89 c7                	mov    %eax,%edi
      log_write(bp);
80102824:	52                   	push   %edx
80102825:	e8 36 1a 00 00       	call   80104260 <log_write>
8010282a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	eb c2                	jmp    801027f4 <bmap+0x44>
80102832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80102838:	8b 06                	mov    (%esi),%eax
8010283a:	e8 e1 fc ff ff       	call   80102520 <balloc>
8010283f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80102845:	eb 93                	jmp    801027da <bmap+0x2a>
80102847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010284e:	00 
8010284f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80102850:	8d 5a 14             	lea    0x14(%edx),%ebx
80102853:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80102857:	85 ff                	test   %edi,%edi
80102859:	75 a5                	jne    80102800 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010285b:	8b 00                	mov    (%eax),%eax
8010285d:	e8 be fc ff ff       	call   80102520 <balloc>
80102862:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80102866:	89 c7                	mov    %eax,%edi
}
80102868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010286b:	5b                   	pop    %ebx
8010286c:	89 f8                	mov    %edi,%eax
8010286e:	5e                   	pop    %esi
8010286f:	5f                   	pop    %edi
80102870:	5d                   	pop    %ebp
80102871:	c3                   	ret
  panic("bmap: out of range");
80102872:	83 ec 0c             	sub    $0xc,%esp
80102875:	68 47 93 10 80       	push   $0x80109347
8010287a:	e8 d1 db ff ff       	call   80100450 <panic>
8010287f:	90                   	nop

80102880 <readsb>:
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	56                   	push   %esi
80102884:	53                   	push   %ebx
80102885:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102888:	83 ec 08             	sub    $0x8,%esp
8010288b:	6a 01                	push   $0x1
8010288d:	ff 75 08             	push   0x8(%ebp)
80102890:	e8 3b d8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102895:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102898:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010289a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010289d:	6a 1c                	push   $0x1c
8010289f:	50                   	push   %eax
801028a0:	56                   	push   %esi
801028a1:	e8 ba 3b 00 00       	call   80106460 <memmove>
  brelse(bp);
801028a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801028a9:	83 c4 10             	add    $0x10,%esp
}
801028ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028af:	5b                   	pop    %ebx
801028b0:	5e                   	pop    %esi
801028b1:	5d                   	pop    %ebp
  brelse(bp);
801028b2:	e9 39 d9 ff ff       	jmp    801001f0 <brelse>
801028b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028be:	00 
801028bf:	90                   	nop

801028c0 <iinit>:
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	53                   	push   %ebx
801028c4:	bb 40 25 11 80       	mov    $0x80112540,%ebx
801028c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801028cc:	68 5a 93 10 80       	push   $0x8010935a
801028d1:	68 00 25 11 80       	push   $0x80112500
801028d6:	e8 05 38 00 00       	call   801060e0 <initlock>
  for(i = 0; i < NINODE; i++) {
801028db:	83 c4 10             	add    $0x10,%esp
801028de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801028e0:	83 ec 08             	sub    $0x8,%esp
801028e3:	68 61 93 10 80       	push   $0x80109361
801028e8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801028e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801028ef:	e8 bc 36 00 00       	call   80105fb0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801028f4:	83 c4 10             	add    $0x10,%esp
801028f7:	81 fb 60 41 11 80    	cmp    $0x80114160,%ebx
801028fd:	75 e1                	jne    801028e0 <iinit+0x20>
  bp = bread(dev, 1);
801028ff:	83 ec 08             	sub    $0x8,%esp
80102902:	6a 01                	push   $0x1
80102904:	ff 75 08             	push   0x8(%ebp)
80102907:	e8 c4 d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010290c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010290f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80102911:	8d 40 5c             	lea    0x5c(%eax),%eax
80102914:	6a 1c                	push   $0x1c
80102916:	50                   	push   %eax
80102917:	68 54 41 11 80       	push   $0x80114154
8010291c:	e8 3f 3b 00 00       	call   80106460 <memmove>
  brelse(bp);
80102921:	89 1c 24             	mov    %ebx,(%esp)
80102924:	e8 c7 d8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80102929:	ff 35 6c 41 11 80    	push   0x8011416c
8010292f:	ff 35 68 41 11 80    	push   0x80114168
80102935:	ff 35 64 41 11 80    	push   0x80114164
8010293b:	ff 35 60 41 11 80    	push   0x80114160
80102941:	ff 35 5c 41 11 80    	push   0x8011415c
80102947:	ff 35 58 41 11 80    	push   0x80114158
8010294d:	ff 35 54 41 11 80    	push   0x80114154
80102953:	68 90 98 10 80       	push   $0x80109890
80102958:	e8 83 de ff ff       	call   801007e0 <cprintf>
}
8010295d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102960:	83 c4 30             	add    $0x30,%esp
80102963:	c9                   	leave
80102964:	c3                   	ret
80102965:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010296c:	00 
8010296d:	8d 76 00             	lea    0x0(%esi),%esi

80102970 <ialloc>:
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
80102976:	83 ec 1c             	sub    $0x1c,%esp
80102979:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010297c:	83 3d 5c 41 11 80 01 	cmpl   $0x1,0x8011415c
{
80102983:	8b 75 08             	mov    0x8(%ebp),%esi
80102986:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102989:	0f 86 91 00 00 00    	jbe    80102a20 <ialloc+0xb0>
8010298f:	bf 01 00 00 00       	mov    $0x1,%edi
80102994:	eb 21                	jmp    801029b7 <ialloc+0x47>
80102996:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010299d:	00 
8010299e:	66 90                	xchg   %ax,%ax
    brelse(bp);
801029a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801029a3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801029a6:	53                   	push   %ebx
801029a7:	e8 44 d8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801029ac:	83 c4 10             	add    $0x10,%esp
801029af:	3b 3d 5c 41 11 80    	cmp    0x8011415c,%edi
801029b5:	73 69                	jae    80102a20 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801029b7:	89 f8                	mov    %edi,%eax
801029b9:	83 ec 08             	sub    $0x8,%esp
801029bc:	c1 e8 03             	shr    $0x3,%eax
801029bf:	03 05 68 41 11 80    	add    0x80114168,%eax
801029c5:	50                   	push   %eax
801029c6:	56                   	push   %esi
801029c7:	e8 04 d7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801029cc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801029cf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801029d1:	89 f8                	mov    %edi,%eax
801029d3:	83 e0 07             	and    $0x7,%eax
801029d6:	c1 e0 06             	shl    $0x6,%eax
801029d9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801029dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801029e1:	75 bd                	jne    801029a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801029e3:	83 ec 04             	sub    $0x4,%esp
801029e6:	6a 40                	push   $0x40
801029e8:	6a 00                	push   $0x0
801029ea:	51                   	push   %ecx
801029eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801029ee:	e8 dd 39 00 00       	call   801063d0 <memset>
      dip->type = type;
801029f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801029f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801029fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801029fd:	89 1c 24             	mov    %ebx,(%esp)
80102a00:	e8 5b 18 00 00       	call   80104260 <log_write>
      brelse(bp);
80102a05:	89 1c 24             	mov    %ebx,(%esp)
80102a08:	e8 e3 d7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80102a0d:	83 c4 10             	add    $0x10,%esp
}
80102a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102a13:	89 fa                	mov    %edi,%edx
}
80102a15:	5b                   	pop    %ebx
      return iget(dev, inum);
80102a16:	89 f0                	mov    %esi,%eax
}
80102a18:	5e                   	pop    %esi
80102a19:	5f                   	pop    %edi
80102a1a:	5d                   	pop    %ebp
      return iget(dev, inum);
80102a1b:	e9 10 fc ff ff       	jmp    80102630 <iget>
  panic("ialloc: no inodes");
80102a20:	83 ec 0c             	sub    $0xc,%esp
80102a23:	68 67 93 10 80       	push   $0x80109367
80102a28:	e8 23 da ff ff       	call   80100450 <panic>
80102a2d:	8d 76 00             	lea    0x0(%esi),%esi

80102a30 <iupdate>:
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	56                   	push   %esi
80102a34:	53                   	push   %ebx
80102a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102a38:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a3b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102a3e:	83 ec 08             	sub    $0x8,%esp
80102a41:	c1 e8 03             	shr    $0x3,%eax
80102a44:	03 05 68 41 11 80    	add    0x80114168,%eax
80102a4a:	50                   	push   %eax
80102a4b:	ff 73 a4             	push   -0x5c(%ebx)
80102a4e:	e8 7d d6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102a53:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a57:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102a5a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102a5c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102a5f:	83 e0 07             	and    $0x7,%eax
80102a62:	c1 e0 06             	shl    $0x6,%eax
80102a65:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102a69:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80102a6c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a70:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102a73:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102a77:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80102a7b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102a7f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102a83:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102a87:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102a8a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a8d:	6a 34                	push   $0x34
80102a8f:	53                   	push   %ebx
80102a90:	50                   	push   %eax
80102a91:	e8 ca 39 00 00       	call   80106460 <memmove>
  log_write(bp);
80102a96:	89 34 24             	mov    %esi,(%esp)
80102a99:	e8 c2 17 00 00       	call   80104260 <log_write>
  brelse(bp);
80102a9e:	89 75 08             	mov    %esi,0x8(%ebp)
80102aa1:	83 c4 10             	add    $0x10,%esp
}
80102aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa7:	5b                   	pop    %ebx
80102aa8:	5e                   	pop    %esi
80102aa9:	5d                   	pop    %ebp
  brelse(bp);
80102aaa:	e9 41 d7 ff ff       	jmp    801001f0 <brelse>
80102aaf:	90                   	nop

80102ab0 <idup>:
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 10             	sub    $0x10,%esp
80102ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102aba:	68 00 25 11 80       	push   $0x80112500
80102abf:	e8 0c 38 00 00       	call   801062d0 <acquire>
  ip->ref++;
80102ac4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102ac8:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102acf:	e8 9c 37 00 00       	call   80106270 <release>
}
80102ad4:	89 d8                	mov    %ebx,%eax
80102ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ad9:	c9                   	leave
80102ada:	c3                   	ret
80102adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ae0 <ilock>:
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102ae8:	85 db                	test   %ebx,%ebx
80102aea:	0f 84 b7 00 00 00    	je     80102ba7 <ilock+0xc7>
80102af0:	8b 53 08             	mov    0x8(%ebx),%edx
80102af3:	85 d2                	test   %edx,%edx
80102af5:	0f 8e ac 00 00 00    	jle    80102ba7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102afb:	83 ec 0c             	sub    $0xc,%esp
80102afe:	8d 43 0c             	lea    0xc(%ebx),%eax
80102b01:	50                   	push   %eax
80102b02:	e8 e9 34 00 00       	call   80105ff0 <acquiresleep>
  if(ip->valid == 0){
80102b07:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102b0a:	83 c4 10             	add    $0x10,%esp
80102b0d:	85 c0                	test   %eax,%eax
80102b0f:	74 0f                	je     80102b20 <ilock+0x40>
}
80102b11:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b14:	5b                   	pop    %ebx
80102b15:	5e                   	pop    %esi
80102b16:	5d                   	pop    %ebp
80102b17:	c3                   	ret
80102b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b1f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102b20:	8b 43 04             	mov    0x4(%ebx),%eax
80102b23:	83 ec 08             	sub    $0x8,%esp
80102b26:	c1 e8 03             	shr    $0x3,%eax
80102b29:	03 05 68 41 11 80    	add    0x80114168,%eax
80102b2f:	50                   	push   %eax
80102b30:	ff 33                	push   (%ebx)
80102b32:	e8 99 d5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102b37:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102b3a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102b3c:	8b 43 04             	mov    0x4(%ebx),%eax
80102b3f:	83 e0 07             	and    $0x7,%eax
80102b42:	c1 e0 06             	shl    $0x6,%eax
80102b45:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102b49:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102b4c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102b4f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102b53:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102b57:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102b5b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102b5f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102b63:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102b67:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102b6b:	8b 50 fc             	mov    -0x4(%eax),%edx
80102b6e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102b71:	6a 34                	push   $0x34
80102b73:	50                   	push   %eax
80102b74:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102b77:	50                   	push   %eax
80102b78:	e8 e3 38 00 00       	call   80106460 <memmove>
    brelse(bp);
80102b7d:	89 34 24             	mov    %esi,(%esp)
80102b80:	e8 6b d6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102b85:	83 c4 10             	add    $0x10,%esp
80102b88:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102b8d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102b94:	0f 85 77 ff ff ff    	jne    80102b11 <ilock+0x31>
      panic("ilock: no type");
80102b9a:	83 ec 0c             	sub    $0xc,%esp
80102b9d:	68 7f 93 10 80       	push   $0x8010937f
80102ba2:	e8 a9 d8 ff ff       	call   80100450 <panic>
    panic("ilock");
80102ba7:	83 ec 0c             	sub    $0xc,%esp
80102baa:	68 79 93 10 80       	push   $0x80109379
80102baf:	e8 9c d8 ff ff       	call   80100450 <panic>
80102bb4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bbb:	00 
80102bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bc0 <iunlock>:
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	56                   	push   %esi
80102bc4:	53                   	push   %ebx
80102bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102bc8:	85 db                	test   %ebx,%ebx
80102bca:	74 28                	je     80102bf4 <iunlock+0x34>
80102bcc:	83 ec 0c             	sub    $0xc,%esp
80102bcf:	8d 73 0c             	lea    0xc(%ebx),%esi
80102bd2:	56                   	push   %esi
80102bd3:	e8 b8 34 00 00       	call   80106090 <holdingsleep>
80102bd8:	83 c4 10             	add    $0x10,%esp
80102bdb:	85 c0                	test   %eax,%eax
80102bdd:	74 15                	je     80102bf4 <iunlock+0x34>
80102bdf:	8b 43 08             	mov    0x8(%ebx),%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	7e 0e                	jle    80102bf4 <iunlock+0x34>
  releasesleep(&ip->lock);
80102be6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102be9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bec:	5b                   	pop    %ebx
80102bed:	5e                   	pop    %esi
80102bee:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102bef:	e9 5c 34 00 00       	jmp    80106050 <releasesleep>
    panic("iunlock");
80102bf4:	83 ec 0c             	sub    $0xc,%esp
80102bf7:	68 8e 93 10 80       	push   $0x8010938e
80102bfc:	e8 4f d8 ff ff       	call   80100450 <panic>
80102c01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c08:	00 
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c10 <iput>:
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 28             	sub    $0x28,%esp
80102c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102c1c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102c1f:	57                   	push   %edi
80102c20:	e8 cb 33 00 00       	call   80105ff0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102c25:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102c28:	83 c4 10             	add    $0x10,%esp
80102c2b:	85 d2                	test   %edx,%edx
80102c2d:	74 07                	je     80102c36 <iput+0x26>
80102c2f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102c34:	74 32                	je     80102c68 <iput+0x58>
  releasesleep(&ip->lock);
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	57                   	push   %edi
80102c3a:	e8 11 34 00 00       	call   80106050 <releasesleep>
  acquire(&icache.lock);
80102c3f:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102c46:	e8 85 36 00 00       	call   801062d0 <acquire>
  ip->ref--;
80102c4b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102c4f:	83 c4 10             	add    $0x10,%esp
80102c52:	c7 45 08 00 25 11 80 	movl   $0x80112500,0x8(%ebp)
}
80102c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5c:	5b                   	pop    %ebx
80102c5d:	5e                   	pop    %esi
80102c5e:	5f                   	pop    %edi
80102c5f:	5d                   	pop    %ebp
  release(&icache.lock);
80102c60:	e9 0b 36 00 00       	jmp    80106270 <release>
80102c65:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102c68:	83 ec 0c             	sub    $0xc,%esp
80102c6b:	68 00 25 11 80       	push   $0x80112500
80102c70:	e8 5b 36 00 00       	call   801062d0 <acquire>
    int r = ip->ref;
80102c75:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102c78:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
80102c7f:	e8 ec 35 00 00       	call   80106270 <release>
    if(r == 1){
80102c84:	83 c4 10             	add    $0x10,%esp
80102c87:	83 fe 01             	cmp    $0x1,%esi
80102c8a:	75 aa                	jne    80102c36 <iput+0x26>
80102c8c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102c92:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102c95:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102c98:	89 df                	mov    %ebx,%edi
80102c9a:	89 cb                	mov    %ecx,%ebx
80102c9c:	eb 09                	jmp    80102ca7 <iput+0x97>
80102c9e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102ca0:	83 c6 04             	add    $0x4,%esi
80102ca3:	39 de                	cmp    %ebx,%esi
80102ca5:	74 19                	je     80102cc0 <iput+0xb0>
    if(ip->addrs[i]){
80102ca7:	8b 16                	mov    (%esi),%edx
80102ca9:	85 d2                	test   %edx,%edx
80102cab:	74 f3                	je     80102ca0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102cad:	8b 07                	mov    (%edi),%eax
80102caf:	e8 7c fa ff ff       	call   80102730 <bfree>
      ip->addrs[i] = 0;
80102cb4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102cba:	eb e4                	jmp    80102ca0 <iput+0x90>
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102cc0:	89 fb                	mov    %edi,%ebx
80102cc2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102cc5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102ccb:	85 c0                	test   %eax,%eax
80102ccd:	75 2d                	jne    80102cfc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102ccf:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102cd2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102cd9:	53                   	push   %ebx
80102cda:	e8 51 fd ff ff       	call   80102a30 <iupdate>
      ip->type = 0;
80102cdf:	31 c0                	xor    %eax,%eax
80102ce1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102ce5:	89 1c 24             	mov    %ebx,(%esp)
80102ce8:	e8 43 fd ff ff       	call   80102a30 <iupdate>
      ip->valid = 0;
80102ced:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102cf4:	83 c4 10             	add    $0x10,%esp
80102cf7:	e9 3a ff ff ff       	jmp    80102c36 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102cfc:	83 ec 08             	sub    $0x8,%esp
80102cff:	50                   	push   %eax
80102d00:	ff 33                	push   (%ebx)
80102d02:	e8 c9 d3 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80102d07:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102d0a:	83 c4 10             	add    $0x10,%esp
80102d0d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d16:	8d 70 5c             	lea    0x5c(%eax),%esi
80102d19:	89 cf                	mov    %ecx,%edi
80102d1b:	eb 0a                	jmp    80102d27 <iput+0x117>
80102d1d:	8d 76 00             	lea    0x0(%esi),%esi
80102d20:	83 c6 04             	add    $0x4,%esi
80102d23:	39 fe                	cmp    %edi,%esi
80102d25:	74 0f                	je     80102d36 <iput+0x126>
      if(a[j])
80102d27:	8b 16                	mov    (%esi),%edx
80102d29:	85 d2                	test   %edx,%edx
80102d2b:	74 f3                	je     80102d20 <iput+0x110>
        bfree(ip->dev, a[j]);
80102d2d:	8b 03                	mov    (%ebx),%eax
80102d2f:	e8 fc f9 ff ff       	call   80102730 <bfree>
80102d34:	eb ea                	jmp    80102d20 <iput+0x110>
    brelse(bp);
80102d36:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d39:	83 ec 0c             	sub    $0xc,%esp
80102d3c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102d3f:	50                   	push   %eax
80102d40:	e8 ab d4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102d45:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102d4b:	8b 03                	mov    (%ebx),%eax
80102d4d:	e8 de f9 ff ff       	call   80102730 <bfree>
    ip->addrs[NDIRECT] = 0;
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102d5c:	00 00 00 
80102d5f:	e9 6b ff ff ff       	jmp    80102ccf <iput+0xbf>
80102d64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6b:	00 
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d70 <iunlockput>:
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	56                   	push   %esi
80102d74:	53                   	push   %ebx
80102d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102d78:	85 db                	test   %ebx,%ebx
80102d7a:	74 34                	je     80102db0 <iunlockput+0x40>
80102d7c:	83 ec 0c             	sub    $0xc,%esp
80102d7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102d82:	56                   	push   %esi
80102d83:	e8 08 33 00 00       	call   80106090 <holdingsleep>
80102d88:	83 c4 10             	add    $0x10,%esp
80102d8b:	85 c0                	test   %eax,%eax
80102d8d:	74 21                	je     80102db0 <iunlockput+0x40>
80102d8f:	8b 43 08             	mov    0x8(%ebx),%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	7e 1a                	jle    80102db0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102d96:	83 ec 0c             	sub    $0xc,%esp
80102d99:	56                   	push   %esi
80102d9a:	e8 b1 32 00 00       	call   80106050 <releasesleep>
  iput(ip);
80102d9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102da2:	83 c4 10             	add    $0x10,%esp
}
80102da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102da8:	5b                   	pop    %ebx
80102da9:	5e                   	pop    %esi
80102daa:	5d                   	pop    %ebp
  iput(ip);
80102dab:	e9 60 fe ff ff       	jmp    80102c10 <iput>
    panic("iunlock");
80102db0:	83 ec 0c             	sub    $0xc,%esp
80102db3:	68 8e 93 10 80       	push   $0x8010938e
80102db8:	e8 93 d6 ff ff       	call   80100450 <panic>
80102dbd:	8d 76 00             	lea    0x0(%esi),%esi

80102dc0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102dc9:	8b 0a                	mov    (%edx),%ecx
80102dcb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102dce:	8b 4a 04             	mov    0x4(%edx),%ecx
80102dd1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102dd4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102dd8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102ddb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102ddf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102de3:	8b 52 58             	mov    0x58(%edx),%edx
80102de6:	89 50 10             	mov    %edx,0x10(%eax)
}
80102de9:	5d                   	pop    %ebp
80102dea:	c3                   	ret
80102deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102df0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	57                   	push   %edi
80102df4:	56                   	push   %esi
80102df5:	53                   	push   %ebx
80102df6:	83 ec 1c             	sub    $0x1c,%esp
80102df9:	8b 75 08             	mov    0x8(%ebp),%esi
80102dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dff:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102e02:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80102e07:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e0a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80102e0d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80102e10:	0f 84 aa 00 00 00    	je     80102ec0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102e16:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102e19:	8b 56 58             	mov    0x58(%esi),%edx
80102e1c:	39 fa                	cmp    %edi,%edx
80102e1e:	0f 82 bd 00 00 00    	jb     80102ee1 <readi+0xf1>
80102e24:	89 f9                	mov    %edi,%ecx
80102e26:	31 db                	xor    %ebx,%ebx
80102e28:	01 c1                	add    %eax,%ecx
80102e2a:	0f 92 c3             	setb   %bl
80102e2d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102e30:	0f 82 ab 00 00 00    	jb     80102ee1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102e36:	89 d3                	mov    %edx,%ebx
80102e38:	29 fb                	sub    %edi,%ebx
80102e3a:	39 ca                	cmp    %ecx,%edx
80102e3c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102e3f:	85 c0                	test   %eax,%eax
80102e41:	74 73                	je     80102eb6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102e43:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80102e46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102e50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102e53:	89 fa                	mov    %edi,%edx
80102e55:	c1 ea 09             	shr    $0x9,%edx
80102e58:	89 d8                	mov    %ebx,%eax
80102e5a:	e8 51 f9 ff ff       	call   801027b0 <bmap>
80102e5f:	83 ec 08             	sub    $0x8,%esp
80102e62:	50                   	push   %eax
80102e63:	ff 33                	push   (%ebx)
80102e65:	e8 66 d2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102e6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102e6d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102e72:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102e74:	89 f8                	mov    %edi,%eax
80102e76:	25 ff 01 00 00       	and    $0x1ff,%eax
80102e7b:	29 f3                	sub    %esi,%ebx
80102e7d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102e7f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102e83:	39 d9                	cmp    %ebx,%ecx
80102e85:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102e88:	83 c4 0c             	add    $0xc,%esp
80102e8b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102e8c:	01 de                	add    %ebx,%esi
80102e8e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102e90:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102e93:	50                   	push   %eax
80102e94:	ff 75 e0             	push   -0x20(%ebp)
80102e97:	e8 c4 35 00 00       	call   80106460 <memmove>
    brelse(bp);
80102e9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102e9f:	89 14 24             	mov    %edx,(%esp)
80102ea2:	e8 49 d3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102ea7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102eaa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102ead:	83 c4 10             	add    $0x10,%esp
80102eb0:	39 de                	cmp    %ebx,%esi
80102eb2:	72 9c                	jb     80102e50 <readi+0x60>
80102eb4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb9:	5b                   	pop    %ebx
80102eba:	5e                   	pop    %esi
80102ebb:	5f                   	pop    %edi
80102ebc:	5d                   	pop    %ebp
80102ebd:	c3                   	ret
80102ebe:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102ec0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102ec4:	66 83 fa 09          	cmp    $0x9,%dx
80102ec8:	77 17                	ja     80102ee1 <readi+0xf1>
80102eca:	8b 14 d5 a0 24 11 80 	mov    -0x7feedb60(,%edx,8),%edx
80102ed1:	85 d2                	test   %edx,%edx
80102ed3:	74 0c                	je     80102ee1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102ed5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102edb:	5b                   	pop    %ebx
80102edc:	5e                   	pop    %esi
80102edd:	5f                   	pop    %edi
80102ede:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102edf:	ff e2                	jmp    *%edx
      return -1;
80102ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ee6:	eb ce                	jmp    80102eb6 <readi+0xc6>
80102ee8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102eef:	00 

80102ef0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	57                   	push   %edi
80102ef4:	56                   	push   %esi
80102ef5:	53                   	push   %ebx
80102ef6:	83 ec 1c             	sub    $0x1c,%esp
80102ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80102efc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102eff:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102f02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102f07:	89 7d dc             	mov    %edi,-0x24(%ebp)
80102f0a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102f0d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80102f10:	0f 84 ba 00 00 00    	je     80102fd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102f16:	39 78 58             	cmp    %edi,0x58(%eax)
80102f19:	0f 82 ea 00 00 00    	jb     80103009 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102f1f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80102f22:	89 f2                	mov    %esi,%edx
80102f24:	01 fa                	add    %edi,%edx
80102f26:	0f 82 dd 00 00 00    	jb     80103009 <writei+0x119>
80102f2c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80102f32:	0f 87 d1 00 00 00    	ja     80103009 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102f38:	85 f6                	test   %esi,%esi
80102f3a:	0f 84 85 00 00 00    	je     80102fc5 <writei+0xd5>
80102f40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102f47:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f50:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102f53:	89 fa                	mov    %edi,%edx
80102f55:	c1 ea 09             	shr    $0x9,%edx
80102f58:	89 f0                	mov    %esi,%eax
80102f5a:	e8 51 f8 ff ff       	call   801027b0 <bmap>
80102f5f:	83 ec 08             	sub    $0x8,%esp
80102f62:	50                   	push   %eax
80102f63:	ff 36                	push   (%esi)
80102f65:	e8 66 d1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102f6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102f6d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102f70:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f75:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80102f77:	89 f8                	mov    %edi,%eax
80102f79:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f7e:	29 d3                	sub    %edx,%ebx
80102f80:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102f82:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102f86:	39 d9                	cmp    %ebx,%ecx
80102f88:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102f8b:	83 c4 0c             	add    $0xc,%esp
80102f8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102f8f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102f91:	ff 75 dc             	push   -0x24(%ebp)
80102f94:	50                   	push   %eax
80102f95:	e8 c6 34 00 00       	call   80106460 <memmove>
    log_write(bp);
80102f9a:	89 34 24             	mov    %esi,(%esp)
80102f9d:	e8 be 12 00 00       	call   80104260 <log_write>
    brelse(bp);
80102fa2:	89 34 24             	mov    %esi,(%esp)
80102fa5:	e8 46 d2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102faa:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80102fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102fb0:	83 c4 10             	add    $0x10,%esp
80102fb3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102fb6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102fb9:	39 d8                	cmp    %ebx,%eax
80102fbb:	72 93                	jb     80102f50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102fbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102fc0:	39 78 58             	cmp    %edi,0x58(%eax)
80102fc3:	72 33                	jb     80102ff8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102fc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fcb:	5b                   	pop    %ebx
80102fcc:	5e                   	pop    %esi
80102fcd:	5f                   	pop    %edi
80102fce:	5d                   	pop    %ebp
80102fcf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102fd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102fd4:	66 83 f8 09          	cmp    $0x9,%ax
80102fd8:	77 2f                	ja     80103009 <writei+0x119>
80102fda:	8b 04 c5 a4 24 11 80 	mov    -0x7feedb5c(,%eax,8),%eax
80102fe1:	85 c0                	test   %eax,%eax
80102fe3:	74 24                	je     80103009 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102fe5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102feb:	5b                   	pop    %ebx
80102fec:	5e                   	pop    %esi
80102fed:	5f                   	pop    %edi
80102fee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80102fef:	ff e0                	jmp    *%eax
80102ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80102ff8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80102ffb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80102ffe:	50                   	push   %eax
80102fff:	e8 2c fa ff ff       	call   80102a30 <iupdate>
80103004:	83 c4 10             	add    $0x10,%esp
80103007:	eb bc                	jmp    80102fc5 <writei+0xd5>
      return -1;
80103009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010300e:	eb b8                	jmp    80102fc8 <writei+0xd8>

80103010 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80103016:	6a 0e                	push   $0xe
80103018:	ff 75 0c             	push   0xc(%ebp)
8010301b:	ff 75 08             	push   0x8(%ebp)
8010301e:	e8 ad 34 00 00       	call   801064d0 <strncmp>
}
80103023:	c9                   	leave
80103024:	c3                   	ret
80103025:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010302c:	00 
8010302d:	8d 76 00             	lea    0x0(%esi),%esi

80103030 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
80103035:	53                   	push   %ebx
80103036:	83 ec 1c             	sub    $0x1c,%esp
80103039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010303c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80103041:	0f 85 85 00 00 00    	jne    801030cc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80103047:	8b 53 58             	mov    0x58(%ebx),%edx
8010304a:	31 ff                	xor    %edi,%edi
8010304c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010304f:	85 d2                	test   %edx,%edx
80103051:	74 3e                	je     80103091 <dirlookup+0x61>
80103053:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103058:	6a 10                	push   $0x10
8010305a:	57                   	push   %edi
8010305b:	56                   	push   %esi
8010305c:	53                   	push   %ebx
8010305d:	e8 8e fd ff ff       	call   80102df0 <readi>
80103062:	83 c4 10             	add    $0x10,%esp
80103065:	83 f8 10             	cmp    $0x10,%eax
80103068:	75 55                	jne    801030bf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010306a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010306f:	74 18                	je     80103089 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103071:	83 ec 04             	sub    $0x4,%esp
80103074:	8d 45 da             	lea    -0x26(%ebp),%eax
80103077:	6a 0e                	push   $0xe
80103079:	50                   	push   %eax
8010307a:	ff 75 0c             	push   0xc(%ebp)
8010307d:	e8 4e 34 00 00       	call   801064d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103082:	83 c4 10             	add    $0x10,%esp
80103085:	85 c0                	test   %eax,%eax
80103087:	74 17                	je     801030a0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103089:	83 c7 10             	add    $0x10,%edi
8010308c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010308f:	72 c7                	jb     80103058 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103091:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103094:	31 c0                	xor    %eax,%eax
}
80103096:	5b                   	pop    %ebx
80103097:	5e                   	pop    %esi
80103098:	5f                   	pop    %edi
80103099:	5d                   	pop    %ebp
8010309a:	c3                   	ret
8010309b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
801030a0:	8b 45 10             	mov    0x10(%ebp),%eax
801030a3:	85 c0                	test   %eax,%eax
801030a5:	74 05                	je     801030ac <dirlookup+0x7c>
        *poff = off;
801030a7:	8b 45 10             	mov    0x10(%ebp),%eax
801030aa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801030ac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801030b0:	8b 03                	mov    (%ebx),%eax
801030b2:	e8 79 f5 ff ff       	call   80102630 <iget>
}
801030b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ba:	5b                   	pop    %ebx
801030bb:	5e                   	pop    %esi
801030bc:	5f                   	pop    %edi
801030bd:	5d                   	pop    %ebp
801030be:	c3                   	ret
      panic("dirlookup read");
801030bf:	83 ec 0c             	sub    $0xc,%esp
801030c2:	68 a8 93 10 80       	push   $0x801093a8
801030c7:	e8 84 d3 ff ff       	call   80100450 <panic>
    panic("dirlookup not DIR");
801030cc:	83 ec 0c             	sub    $0xc,%esp
801030cf:	68 96 93 10 80       	push   $0x80109396
801030d4:	e8 77 d3 ff ff       	call   80100450 <panic>
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
801030e5:	53                   	push   %ebx
801030e6:	89 c3                	mov    %eax,%ebx
801030e8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801030eb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801030ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
801030f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801030f4:	0f 84 9e 01 00 00    	je     80103298 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801030fa:	e8 f1 1b 00 00       	call   80104cf0 <myproc>
  acquire(&icache.lock);
801030ff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103102:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103105:	68 00 25 11 80       	push   $0x80112500
8010310a:	e8 c1 31 00 00       	call   801062d0 <acquire>
  ip->ref++;
8010310f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80103113:	c7 04 24 00 25 11 80 	movl   $0x80112500,(%esp)
8010311a:	e8 51 31 00 00       	call   80106270 <release>
8010311f:	83 c4 10             	add    $0x10,%esp
80103122:	eb 07                	jmp    8010312b <namex+0x4b>
80103124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103128:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010312b:	0f b6 03             	movzbl (%ebx),%eax
8010312e:	3c 2f                	cmp    $0x2f,%al
80103130:	74 f6                	je     80103128 <namex+0x48>
  if(*path == 0)
80103132:	84 c0                	test   %al,%al
80103134:	0f 84 06 01 00 00    	je     80103240 <namex+0x160>
  while(*path != '/' && *path != 0)
8010313a:	0f b6 03             	movzbl (%ebx),%eax
8010313d:	84 c0                	test   %al,%al
8010313f:	0f 84 10 01 00 00    	je     80103255 <namex+0x175>
80103145:	89 df                	mov    %ebx,%edi
80103147:	3c 2f                	cmp    $0x2f,%al
80103149:	0f 84 06 01 00 00    	je     80103255 <namex+0x175>
8010314f:	90                   	nop
80103150:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80103154:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80103157:	3c 2f                	cmp    $0x2f,%al
80103159:	74 04                	je     8010315f <namex+0x7f>
8010315b:	84 c0                	test   %al,%al
8010315d:	75 f1                	jne    80103150 <namex+0x70>
  len = path - s;
8010315f:	89 f8                	mov    %edi,%eax
80103161:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80103163:	83 f8 0d             	cmp    $0xd,%eax
80103166:	0f 8e ac 00 00 00    	jle    80103218 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010316c:	83 ec 04             	sub    $0x4,%esp
8010316f:	6a 0e                	push   $0xe
80103171:	53                   	push   %ebx
80103172:	89 fb                	mov    %edi,%ebx
80103174:	ff 75 e4             	push   -0x1c(%ebp)
80103177:	e8 e4 32 00 00       	call   80106460 <memmove>
8010317c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010317f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103182:	75 0c                	jne    80103190 <namex+0xb0>
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103188:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010318b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010318e:	74 f8                	je     80103188 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103190:	83 ec 0c             	sub    $0xc,%esp
80103193:	56                   	push   %esi
80103194:	e8 47 f9 ff ff       	call   80102ae0 <ilock>
    if(ip->type != T_DIR){
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801031a1:	0f 85 b7 00 00 00    	jne    8010325e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801031a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031aa:	85 c0                	test   %eax,%eax
801031ac:	74 09                	je     801031b7 <namex+0xd7>
801031ae:	80 3b 00             	cmpb   $0x0,(%ebx)
801031b1:	0f 84 f7 00 00 00    	je     801032ae <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801031b7:	83 ec 04             	sub    $0x4,%esp
801031ba:	6a 00                	push   $0x0
801031bc:	ff 75 e4             	push   -0x1c(%ebp)
801031bf:	56                   	push   %esi
801031c0:	e8 6b fe ff ff       	call   80103030 <dirlookup>
801031c5:	83 c4 10             	add    $0x10,%esp
801031c8:	89 c7                	mov    %eax,%edi
801031ca:	85 c0                	test   %eax,%eax
801031cc:	0f 84 8c 00 00 00    	je     8010325e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801031d2:	8d 4e 0c             	lea    0xc(%esi),%ecx
801031d5:	83 ec 0c             	sub    $0xc,%esp
801031d8:	51                   	push   %ecx
801031d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801031dc:	e8 af 2e 00 00       	call   80106090 <holdingsleep>
801031e1:	83 c4 10             	add    $0x10,%esp
801031e4:	85 c0                	test   %eax,%eax
801031e6:	0f 84 02 01 00 00    	je     801032ee <namex+0x20e>
801031ec:	8b 56 08             	mov    0x8(%esi),%edx
801031ef:	85 d2                	test   %edx,%edx
801031f1:	0f 8e f7 00 00 00    	jle    801032ee <namex+0x20e>
  releasesleep(&ip->lock);
801031f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801031fa:	83 ec 0c             	sub    $0xc,%esp
801031fd:	51                   	push   %ecx
801031fe:	e8 4d 2e 00 00       	call   80106050 <releasesleep>
  iput(ip);
80103203:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80103206:	89 fe                	mov    %edi,%esi
  iput(ip);
80103208:	e8 03 fa ff ff       	call   80102c10 <iput>
8010320d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103210:	e9 16 ff ff ff       	jmp    8010312b <namex+0x4b>
80103215:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80103218:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010321b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
8010321e:	83 ec 04             	sub    $0x4,%esp
80103221:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103224:	50                   	push   %eax
80103225:	53                   	push   %ebx
    name[len] = 0;
80103226:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80103228:	ff 75 e4             	push   -0x1c(%ebp)
8010322b:	e8 30 32 00 00       	call   80106460 <memmove>
    name[len] = 0;
80103230:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103233:	83 c4 10             	add    $0x10,%esp
80103236:	c6 01 00             	movb   $0x0,(%ecx)
80103239:	e9 41 ff ff ff       	jmp    8010317f <namex+0x9f>
8010323e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80103240:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103243:	85 c0                	test   %eax,%eax
80103245:	0f 85 93 00 00 00    	jne    801032de <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
8010324b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324e:	89 f0                	mov    %esi,%eax
80103250:	5b                   	pop    %ebx
80103251:	5e                   	pop    %esi
80103252:	5f                   	pop    %edi
80103253:	5d                   	pop    %ebp
80103254:	c3                   	ret
  while(*path != '/' && *path != 0)
80103255:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103258:	89 df                	mov    %ebx,%edi
8010325a:	31 c0                	xor    %eax,%eax
8010325c:	eb c0                	jmp    8010321e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010325e:	83 ec 0c             	sub    $0xc,%esp
80103261:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103264:	53                   	push   %ebx
80103265:	e8 26 2e 00 00       	call   80106090 <holdingsleep>
8010326a:	83 c4 10             	add    $0x10,%esp
8010326d:	85 c0                	test   %eax,%eax
8010326f:	74 7d                	je     801032ee <namex+0x20e>
80103271:	8b 4e 08             	mov    0x8(%esi),%ecx
80103274:	85 c9                	test   %ecx,%ecx
80103276:	7e 76                	jle    801032ee <namex+0x20e>
  releasesleep(&ip->lock);
80103278:	83 ec 0c             	sub    $0xc,%esp
8010327b:	53                   	push   %ebx
8010327c:	e8 cf 2d 00 00       	call   80106050 <releasesleep>
  iput(ip);
80103281:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103284:	31 f6                	xor    %esi,%esi
  iput(ip);
80103286:	e8 85 f9 ff ff       	call   80102c10 <iput>
      return 0;
8010328b:	83 c4 10             	add    $0x10,%esp
}
8010328e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103291:	89 f0                	mov    %esi,%eax
80103293:	5b                   	pop    %ebx
80103294:	5e                   	pop    %esi
80103295:	5f                   	pop    %edi
80103296:	5d                   	pop    %ebp
80103297:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80103298:	ba 01 00 00 00       	mov    $0x1,%edx
8010329d:	b8 01 00 00 00       	mov    $0x1,%eax
801032a2:	e8 89 f3 ff ff       	call   80102630 <iget>
801032a7:	89 c6                	mov    %eax,%esi
801032a9:	e9 7d fe ff ff       	jmp    8010312b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801032ae:	83 ec 0c             	sub    $0xc,%esp
801032b1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801032b4:	53                   	push   %ebx
801032b5:	e8 d6 2d 00 00       	call   80106090 <holdingsleep>
801032ba:	83 c4 10             	add    $0x10,%esp
801032bd:	85 c0                	test   %eax,%eax
801032bf:	74 2d                	je     801032ee <namex+0x20e>
801032c1:	8b 7e 08             	mov    0x8(%esi),%edi
801032c4:	85 ff                	test   %edi,%edi
801032c6:	7e 26                	jle    801032ee <namex+0x20e>
  releasesleep(&ip->lock);
801032c8:	83 ec 0c             	sub    $0xc,%esp
801032cb:	53                   	push   %ebx
801032cc:	e8 7f 2d 00 00       	call   80106050 <releasesleep>
}
801032d1:	83 c4 10             	add    $0x10,%esp
}
801032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d7:	89 f0                	mov    %esi,%eax
801032d9:	5b                   	pop    %ebx
801032da:	5e                   	pop    %esi
801032db:	5f                   	pop    %edi
801032dc:	5d                   	pop    %ebp
801032dd:	c3                   	ret
    iput(ip);
801032de:	83 ec 0c             	sub    $0xc,%esp
801032e1:	56                   	push   %esi
      return 0;
801032e2:	31 f6                	xor    %esi,%esi
    iput(ip);
801032e4:	e8 27 f9 ff ff       	call   80102c10 <iput>
    return 0;
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	eb a0                	jmp    8010328e <namex+0x1ae>
    panic("iunlock");
801032ee:	83 ec 0c             	sub    $0xc,%esp
801032f1:	68 8e 93 10 80       	push   $0x8010938e
801032f6:	e8 55 d1 ff ff       	call   80100450 <panic>
801032fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103300 <dirlink>:
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 20             	sub    $0x20,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010330c:	6a 00                	push   $0x0
8010330e:	ff 75 0c             	push   0xc(%ebp)
80103311:	53                   	push   %ebx
80103312:	e8 19 fd ff ff       	call   80103030 <dirlookup>
80103317:	83 c4 10             	add    $0x10,%esp
8010331a:	85 c0                	test   %eax,%eax
8010331c:	75 67                	jne    80103385 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010331e:	8b 7b 58             	mov    0x58(%ebx),%edi
80103321:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103324:	85 ff                	test   %edi,%edi
80103326:	74 29                	je     80103351 <dirlink+0x51>
80103328:	31 ff                	xor    %edi,%edi
8010332a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010332d:	eb 09                	jmp    80103338 <dirlink+0x38>
8010332f:	90                   	nop
80103330:	83 c7 10             	add    $0x10,%edi
80103333:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103336:	73 19                	jae    80103351 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103338:	6a 10                	push   $0x10
8010333a:	57                   	push   %edi
8010333b:	56                   	push   %esi
8010333c:	53                   	push   %ebx
8010333d:	e8 ae fa ff ff       	call   80102df0 <readi>
80103342:	83 c4 10             	add    $0x10,%esp
80103345:	83 f8 10             	cmp    $0x10,%eax
80103348:	75 4e                	jne    80103398 <dirlink+0x98>
    if(de.inum == 0)
8010334a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010334f:	75 df                	jne    80103330 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103351:	83 ec 04             	sub    $0x4,%esp
80103354:	8d 45 da             	lea    -0x26(%ebp),%eax
80103357:	6a 0e                	push   $0xe
80103359:	ff 75 0c             	push   0xc(%ebp)
8010335c:	50                   	push   %eax
8010335d:	e8 be 31 00 00       	call   80106520 <strncpy>
  de.inum = inum;
80103362:	8b 45 10             	mov    0x10(%ebp),%eax
80103365:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103369:	6a 10                	push   $0x10
8010336b:	57                   	push   %edi
8010336c:	56                   	push   %esi
8010336d:	53                   	push   %ebx
8010336e:	e8 7d fb ff ff       	call   80102ef0 <writei>
80103373:	83 c4 20             	add    $0x20,%esp
80103376:	83 f8 10             	cmp    $0x10,%eax
80103379:	75 2a                	jne    801033a5 <dirlink+0xa5>
  return 0;
8010337b:	31 c0                	xor    %eax,%eax
}
8010337d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret
    iput(ip);
80103385:	83 ec 0c             	sub    $0xc,%esp
80103388:	50                   	push   %eax
80103389:	e8 82 f8 ff ff       	call   80102c10 <iput>
    return -1;
8010338e:	83 c4 10             	add    $0x10,%esp
80103391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103396:	eb e5                	jmp    8010337d <dirlink+0x7d>
      panic("dirlink read");
80103398:	83 ec 0c             	sub    $0xc,%esp
8010339b:	68 b7 93 10 80       	push   $0x801093b7
801033a0:	e8 ab d0 ff ff       	call   80100450 <panic>
    panic("dirlink");
801033a5:	83 ec 0c             	sub    $0xc,%esp
801033a8:	68 a3 96 10 80       	push   $0x801096a3
801033ad:	e8 9e d0 ff ff       	call   80100450 <panic>
801033b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033b9:	00 
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033c0 <namei>:

struct inode*
namei(char *path)
{
801033c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801033c1:	31 d2                	xor    %edx,%edx
{
801033c3:	89 e5                	mov    %esp,%ebp
801033c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801033c8:	8b 45 08             	mov    0x8(%ebp),%eax
801033cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801033ce:	e8 0d fd ff ff       	call   801030e0 <namex>
}
801033d3:	c9                   	leave
801033d4:	c3                   	ret
801033d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033dc:	00 
801033dd:	8d 76 00             	lea    0x0(%esi),%esi

801033e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801033e0:	55                   	push   %ebp
  return namex(path, 1, name);
801033e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801033e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801033e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801033ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801033ef:	e9 ec fc ff ff       	jmp    801030e0 <namex>
801033f4:	66 90                	xchg   %ax,%ax
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103409:	85 c0                	test   %eax,%eax
8010340b:	0f 84 b4 00 00 00    	je     801034c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103411:	8b 70 08             	mov    0x8(%eax),%esi
80103414:	89 c3                	mov    %eax,%ebx
80103416:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010341c:	0f 87 96 00 00 00    	ja     801034b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103422:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103427:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010342e:	00 
8010342f:	90                   	nop
80103430:	89 ca                	mov    %ecx,%edx
80103432:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103433:	83 e0 c0             	and    $0xffffffc0,%eax
80103436:	3c 40                	cmp    $0x40,%al
80103438:	75 f6                	jne    80103430 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010343a:	31 ff                	xor    %edi,%edi
8010343c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103441:	89 f8                	mov    %edi,%eax
80103443:	ee                   	out    %al,(%dx)
80103444:	b8 01 00 00 00       	mov    $0x1,%eax
80103449:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010344e:	ee                   	out    %al,(%dx)
8010344f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103454:	89 f0                	mov    %esi,%eax
80103456:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103457:	89 f0                	mov    %esi,%eax
80103459:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010345e:	c1 f8 08             	sar    $0x8,%eax
80103461:	ee                   	out    %al,(%dx)
80103462:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103467:	89 f8                	mov    %edi,%eax
80103469:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010346a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010346e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103473:	c1 e0 04             	shl    $0x4,%eax
80103476:	83 e0 10             	and    $0x10,%eax
80103479:	83 c8 e0             	or     $0xffffffe0,%eax
8010347c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010347d:	f6 03 04             	testb  $0x4,(%ebx)
80103480:	75 16                	jne    80103498 <idestart+0x98>
80103482:	b8 20 00 00 00       	mov    $0x20,%eax
80103487:	89 ca                	mov    %ecx,%edx
80103489:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010348a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010348d:	5b                   	pop    %ebx
8010348e:	5e                   	pop    %esi
8010348f:	5f                   	pop    %edi
80103490:	5d                   	pop    %ebp
80103491:	c3                   	ret
80103492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103498:	b8 30 00 00 00       	mov    $0x30,%eax
8010349d:	89 ca                	mov    %ecx,%edx
8010349f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801034a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801034a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801034a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801034ad:	fc                   	cld
801034ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801034b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b3:	5b                   	pop    %ebx
801034b4:	5e                   	pop    %esi
801034b5:	5f                   	pop    %edi
801034b6:	5d                   	pop    %ebp
801034b7:	c3                   	ret
    panic("incorrect blockno");
801034b8:	83 ec 0c             	sub    $0xc,%esp
801034bb:	68 cd 93 10 80       	push   $0x801093cd
801034c0:	e8 8b cf ff ff       	call   80100450 <panic>
    panic("idestart");
801034c5:	83 ec 0c             	sub    $0xc,%esp
801034c8:	68 c4 93 10 80       	push   $0x801093c4
801034cd:	e8 7e cf ff ff       	call   80100450 <panic>
801034d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034d9:	00 
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034e0 <ideinit>:
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801034e6:	68 df 93 10 80       	push   $0x801093df
801034eb:	68 a0 41 11 80       	push   $0x801141a0
801034f0:	e8 eb 2b 00 00       	call   801060e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801034f5:	58                   	pop    %eax
801034f6:	a1 24 43 11 80       	mov    0x80114324,%eax
801034fb:	5a                   	pop    %edx
801034fc:	83 e8 01             	sub    $0x1,%eax
801034ff:	50                   	push   %eax
80103500:	6a 0e                	push   $0xe
80103502:	e8 99 02 00 00       	call   801037a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103507:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010350a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010350f:	90                   	nop
80103510:	89 ca                	mov    %ecx,%edx
80103512:	ec                   	in     (%dx),%al
80103513:	83 e0 c0             	and    $0xffffffc0,%eax
80103516:	3c 40                	cmp    $0x40,%al
80103518:	75 f6                	jne    80103510 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010351f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103525:	89 ca                	mov    %ecx,%edx
80103527:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103528:	84 c0                	test   %al,%al
8010352a:	75 1e                	jne    8010354a <ideinit+0x6a>
8010352c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80103531:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103536:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010353d:	00 
8010353e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80103540:	83 e9 01             	sub    $0x1,%ecx
80103543:	74 0f                	je     80103554 <ideinit+0x74>
80103545:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103546:	84 c0                	test   %al,%al
80103548:	74 f6                	je     80103540 <ideinit+0x60>
      havedisk1 = 1;
8010354a:	c7 05 80 41 11 80 01 	movl   $0x1,0x80114180
80103551:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103554:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103559:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010355e:	ee                   	out    %al,(%dx)
}
8010355f:	c9                   	leave
80103560:	c3                   	ret
80103561:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103568:	00 
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103570 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103579:	68 a0 41 11 80       	push   $0x801141a0
8010357e:	e8 4d 2d 00 00       	call   801062d0 <acquire>

  if((b = idequeue) == 0){
80103583:	8b 1d 84 41 11 80    	mov    0x80114184,%ebx
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	85 db                	test   %ebx,%ebx
8010358e:	74 63                	je     801035f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103590:	8b 43 58             	mov    0x58(%ebx),%eax
80103593:	a3 84 41 11 80       	mov    %eax,0x80114184

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103598:	8b 33                	mov    (%ebx),%esi
8010359a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801035a0:	75 2f                	jne    801035d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801035a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801035ae:	00 
801035af:	90                   	nop
801035b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801035b1:	89 c1                	mov    %eax,%ecx
801035b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801035b6:	80 f9 40             	cmp    $0x40,%cl
801035b9:	75 f5                	jne    801035b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801035bb:	a8 21                	test   $0x21,%al
801035bd:	75 12                	jne    801035d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801035bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801035c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801035c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801035cc:	fc                   	cld
801035cd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801035cf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801035d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801035d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801035d7:	83 ce 02             	or     $0x2,%esi
801035da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801035dc:	53                   	push   %ebx
801035dd:	e8 ce 1e 00 00       	call   801054b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801035e2:	a1 84 41 11 80       	mov    0x80114184,%eax
801035e7:	83 c4 10             	add    $0x10,%esp
801035ea:	85 c0                	test   %eax,%eax
801035ec:	74 05                	je     801035f3 <ideintr+0x83>
    idestart(idequeue);
801035ee:	e8 0d fe ff ff       	call   80103400 <idestart>
    release(&idelock);
801035f3:	83 ec 0c             	sub    $0xc,%esp
801035f6:	68 a0 41 11 80       	push   $0x801141a0
801035fb:	e8 70 2c 00 00       	call   80106270 <release>

  release(&idelock);
}
80103600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103603:	5b                   	pop    %ebx
80103604:	5e                   	pop    %esi
80103605:	5f                   	pop    %edi
80103606:	5d                   	pop    %ebp
80103607:	c3                   	ret
80103608:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010360f:	00 

80103610 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
80103614:	83 ec 10             	sub    $0x10,%esp
80103617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010361a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010361d:	50                   	push   %eax
8010361e:	e8 6d 2a 00 00       	call   80106090 <holdingsleep>
80103623:	83 c4 10             	add    $0x10,%esp
80103626:	85 c0                	test   %eax,%eax
80103628:	0f 84 c3 00 00 00    	je     801036f1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010362e:	8b 03                	mov    (%ebx),%eax
80103630:	83 e0 06             	and    $0x6,%eax
80103633:	83 f8 02             	cmp    $0x2,%eax
80103636:	0f 84 a8 00 00 00    	je     801036e4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010363c:	8b 53 04             	mov    0x4(%ebx),%edx
8010363f:	85 d2                	test   %edx,%edx
80103641:	74 0d                	je     80103650 <iderw+0x40>
80103643:	a1 80 41 11 80       	mov    0x80114180,%eax
80103648:	85 c0                	test   %eax,%eax
8010364a:	0f 84 87 00 00 00    	je     801036d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 a0 41 11 80       	push   $0x801141a0
80103658:	e8 73 2c 00 00       	call   801062d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010365d:	a1 84 41 11 80       	mov    0x80114184,%eax
  b->qnext = 0;
80103662:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	85 c0                	test   %eax,%eax
8010366e:	74 60                	je     801036d0 <iderw+0xc0>
80103670:	89 c2                	mov    %eax,%edx
80103672:	8b 40 58             	mov    0x58(%eax),%eax
80103675:	85 c0                	test   %eax,%eax
80103677:	75 f7                	jne    80103670 <iderw+0x60>
80103679:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010367c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010367e:	39 1d 84 41 11 80    	cmp    %ebx,0x80114184
80103684:	74 3a                	je     801036c0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103686:	8b 03                	mov    (%ebx),%eax
80103688:	83 e0 06             	and    $0x6,%eax
8010368b:	83 f8 02             	cmp    $0x2,%eax
8010368e:	74 1b                	je     801036ab <iderw+0x9b>
    sleep(b, &idelock);
80103690:	83 ec 08             	sub    $0x8,%esp
80103693:	68 a0 41 11 80       	push   $0x801141a0
80103698:	53                   	push   %ebx
80103699:	e8 52 1d 00 00       	call   801053f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010369e:	8b 03                	mov    (%ebx),%eax
801036a0:	83 c4 10             	add    $0x10,%esp
801036a3:	83 e0 06             	and    $0x6,%eax
801036a6:	83 f8 02             	cmp    $0x2,%eax
801036a9:	75 e5                	jne    80103690 <iderw+0x80>
  }


  release(&idelock);
801036ab:	c7 45 08 a0 41 11 80 	movl   $0x801141a0,0x8(%ebp)
}
801036b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036b5:	c9                   	leave
  release(&idelock);
801036b6:	e9 b5 2b 00 00       	jmp    80106270 <release>
801036bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801036c0:	89 d8                	mov    %ebx,%eax
801036c2:	e8 39 fd ff ff       	call   80103400 <idestart>
801036c7:	eb bd                	jmp    80103686 <iderw+0x76>
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801036d0:	ba 84 41 11 80       	mov    $0x80114184,%edx
801036d5:	eb a5                	jmp    8010367c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801036d7:	83 ec 0c             	sub    $0xc,%esp
801036da:	68 0e 94 10 80       	push   $0x8010940e
801036df:	e8 6c cd ff ff       	call   80100450 <panic>
    panic("iderw: nothing to do");
801036e4:	83 ec 0c             	sub    $0xc,%esp
801036e7:	68 f9 93 10 80       	push   $0x801093f9
801036ec:	e8 5f cd ff ff       	call   80100450 <panic>
    panic("iderw: buf not locked");
801036f1:	83 ec 0c             	sub    $0xc,%esp
801036f4:	68 e3 93 10 80       	push   $0x801093e3
801036f9:	e8 52 cd ff ff       	call   80100450 <panic>
801036fe:	66 90                	xchg   %ax,%ax

80103700 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103705:	c7 05 d4 41 11 80 00 	movl   $0xfec00000,0x801141d4
8010370c:	00 c0 fe 
  ioapic->reg = reg;
8010370f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80103716:	00 00 00 
  return ioapic->data;
80103719:	8b 15 d4 41 11 80    	mov    0x801141d4,%edx
8010371f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103722:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103728:	8b 1d d4 41 11 80    	mov    0x801141d4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010372e:	0f b6 15 20 43 11 80 	movzbl 0x80114320,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103735:	c1 ee 10             	shr    $0x10,%esi
80103738:	89 f0                	mov    %esi,%eax
8010373a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010373d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80103740:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103743:	39 c2                	cmp    %eax,%edx
80103745:	74 16                	je     8010375d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	68 e4 98 10 80       	push   $0x801098e4
8010374f:	e8 8c d0 ff ff       	call   801007e0 <cprintf>
  ioapic->reg = reg;
80103754:	8b 1d d4 41 11 80    	mov    0x801141d4,%ebx
8010375a:	83 c4 10             	add    $0x10,%esp
{
8010375d:	ba 10 00 00 00       	mov    $0x10,%edx
80103762:	31 c0                	xor    %eax,%eax
80103764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80103768:	89 13                	mov    %edx,(%ebx)
8010376a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010376d:	8b 1d d4 41 11 80    	mov    0x801141d4,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80103773:	83 c0 01             	add    $0x1,%eax
80103776:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010377c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010377f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80103782:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80103785:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80103787:	8b 1d d4 41 11 80    	mov    0x801141d4,%ebx
8010378d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80103794:	39 c6                	cmp    %eax,%esi
80103796:	7d d0                	jge    80103768 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80103798:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5d                   	pop    %ebp
8010379e:	c3                   	ret
8010379f:	90                   	nop

801037a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801037a0:	55                   	push   %ebp
  ioapic->reg = reg;
801037a1:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
{
801037a7:	89 e5                	mov    %esp,%ebp
801037a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801037ac:	8d 50 20             	lea    0x20(%eax),%edx
801037af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801037b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801037b5:	8b 0d d4 41 11 80    	mov    0x801141d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801037bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801037be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801037c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801037c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801037c6:	a1 d4 41 11 80       	mov    0x801141d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801037cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801037ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801037d1:	5d                   	pop    %ebp
801037d2:	c3                   	ret
801037d3:	66 90                	xchg   %ax,%ax
801037d5:	66 90                	xchg   %ax,%ax
801037d7:	66 90                	xchg   %ax,%ax
801037d9:	66 90                	xchg   %ax,%ax
801037db:	66 90                	xchg   %ax,%ax
801037dd:	66 90                	xchg   %ax,%ax
801037df:	90                   	nop

801037e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 04             	sub    $0x4,%esp
801037e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801037ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801037f0:	75 76                	jne    80103868 <kfree+0x88>
801037f2:	81 fb 70 ee 11 80    	cmp    $0x8011ee70,%ebx
801037f8:	72 6e                	jb     80103868 <kfree+0x88>
801037fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80103800:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80103805:	77 61                	ja     80103868 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80103807:	83 ec 04             	sub    $0x4,%esp
8010380a:	68 00 10 00 00       	push   $0x1000
8010380f:	6a 01                	push   $0x1
80103811:	53                   	push   %ebx
80103812:	e8 b9 2b 00 00       	call   801063d0 <memset>

  if(kmem.use_lock)
80103817:	8b 15 14 42 11 80    	mov    0x80114214,%edx
8010381d:	83 c4 10             	add    $0x10,%esp
80103820:	85 d2                	test   %edx,%edx
80103822:	75 1c                	jne    80103840 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80103824:	a1 18 42 11 80       	mov    0x80114218,%eax
80103829:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010382b:	a1 14 42 11 80       	mov    0x80114214,%eax
  kmem.freelist = r;
80103830:	89 1d 18 42 11 80    	mov    %ebx,0x80114218
  if(kmem.use_lock)
80103836:	85 c0                	test   %eax,%eax
80103838:	75 1e                	jne    80103858 <kfree+0x78>
    release(&kmem.lock);
}
8010383a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383d:	c9                   	leave
8010383e:	c3                   	ret
8010383f:	90                   	nop
    acquire(&kmem.lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
80103843:	68 e0 41 11 80       	push   $0x801141e0
80103848:	e8 83 2a 00 00       	call   801062d0 <acquire>
8010384d:	83 c4 10             	add    $0x10,%esp
80103850:	eb d2                	jmp    80103824 <kfree+0x44>
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103858:	c7 45 08 e0 41 11 80 	movl   $0x801141e0,0x8(%ebp)
}
8010385f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103862:	c9                   	leave
    release(&kmem.lock);
80103863:	e9 08 2a 00 00       	jmp    80106270 <release>
    panic("kfree");
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	68 2c 94 10 80       	push   $0x8010942c
80103870:	e8 db cb ff ff       	call   80100450 <panic>
80103875:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010387c:	00 
8010387d:	8d 76 00             	lea    0x0(%esi),%esi

80103880 <freerange>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103885:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103888:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010388b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103891:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103897:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010389d:	39 de                	cmp    %ebx,%esi
8010389f:	72 23                	jb     801038c4 <freerange+0x44>
801038a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801038a8:	83 ec 0c             	sub    $0xc,%esp
801038ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801038b7:	50                   	push   %eax
801038b8:	e8 23 ff ff ff       	call   801037e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038bd:	83 c4 10             	add    $0x10,%esp
801038c0:	39 de                	cmp    %ebx,%esi
801038c2:	73 e4                	jae    801038a8 <freerange+0x28>
}
801038c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c7:	5b                   	pop    %ebx
801038c8:	5e                   	pop    %esi
801038c9:	5d                   	pop    %ebp
801038ca:	c3                   	ret
801038cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801038d0 <kinit2>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801038d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801038d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801038db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801038e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801038ed:	39 de                	cmp    %ebx,%esi
801038ef:	72 23                	jb     80103914 <kinit2+0x44>
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801038f8:	83 ec 0c             	sub    $0xc,%esp
801038fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103901:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103907:	50                   	push   %eax
80103908:	e8 d3 fe ff ff       	call   801037e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	39 de                	cmp    %ebx,%esi
80103912:	73 e4                	jae    801038f8 <kinit2+0x28>
  kmem.use_lock = 1;
80103914:	c7 05 14 42 11 80 01 	movl   $0x1,0x80114214
8010391b:	00 00 00 
}
8010391e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5d                   	pop    %ebp
80103924:	c3                   	ret
80103925:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010392c:	00 
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <kinit1>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
80103935:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103938:	83 ec 08             	sub    $0x8,%esp
8010393b:	68 32 94 10 80       	push   $0x80109432
80103940:	68 e0 41 11 80       	push   $0x801141e0
80103945:	e8 96 27 00 00       	call   801060e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010394a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010394d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103950:	c7 05 14 42 11 80 00 	movl   $0x0,0x80114214
80103957:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010395a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103960:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103966:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010396c:	39 de                	cmp    %ebx,%esi
8010396e:	72 1c                	jb     8010398c <kinit1+0x5c>
    kfree(p);
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103979:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010397f:	50                   	push   %eax
80103980:	e8 5b fe ff ff       	call   801037e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103985:	83 c4 10             	add    $0x10,%esp
80103988:	39 de                	cmp    %ebx,%esi
8010398a:	73 e4                	jae    80103970 <kinit1+0x40>
}
8010398c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010398f:	5b                   	pop    %ebx
80103990:	5e                   	pop    %esi
80103991:	5d                   	pop    %ebp
80103992:	c3                   	ret
80103993:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010399a:	00 
8010399b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801039a7:	a1 14 42 11 80       	mov    0x80114214,%eax
801039ac:	85 c0                	test   %eax,%eax
801039ae:	75 20                	jne    801039d0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801039b0:	8b 1d 18 42 11 80    	mov    0x80114218,%ebx
  if(r)
801039b6:	85 db                	test   %ebx,%ebx
801039b8:	74 07                	je     801039c1 <kalloc+0x21>
    kmem.freelist = r->next;
801039ba:	8b 03                	mov    (%ebx),%eax
801039bc:	a3 18 42 11 80       	mov    %eax,0x80114218
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801039c1:	89 d8                	mov    %ebx,%eax
801039c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c6:	c9                   	leave
801039c7:	c3                   	ret
801039c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039cf:	00 
    acquire(&kmem.lock);
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	68 e0 41 11 80       	push   $0x801141e0
801039d8:	e8 f3 28 00 00       	call   801062d0 <acquire>
  r = kmem.freelist;
801039dd:	8b 1d 18 42 11 80    	mov    0x80114218,%ebx
  if(kmem.use_lock)
801039e3:	a1 14 42 11 80       	mov    0x80114214,%eax
  if(r)
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	85 db                	test   %ebx,%ebx
801039ed:	74 08                	je     801039f7 <kalloc+0x57>
    kmem.freelist = r->next;
801039ef:	8b 13                	mov    (%ebx),%edx
801039f1:	89 15 18 42 11 80    	mov    %edx,0x80114218
  if(kmem.use_lock)
801039f7:	85 c0                	test   %eax,%eax
801039f9:	74 c6                	je     801039c1 <kalloc+0x21>
    release(&kmem.lock);
801039fb:	83 ec 0c             	sub    $0xc,%esp
801039fe:	68 e0 41 11 80       	push   $0x801141e0
80103a03:	e8 68 28 00 00       	call   80106270 <release>
}
80103a08:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80103a0a:	83 c4 10             	add    $0x10,%esp
}
80103a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a10:	c9                   	leave
80103a11:	c3                   	ret
80103a12:	66 90                	xchg   %ax,%ax
80103a14:	66 90                	xchg   %ax,%ax
80103a16:	66 90                	xchg   %ax,%ax
80103a18:	66 90                	xchg   %ax,%ax
80103a1a:	66 90                	xchg   %ax,%ax
80103a1c:	66 90                	xchg   %ax,%ax
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a20:	ba 64 00 00 00       	mov    $0x64,%edx
80103a25:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103a26:	a8 01                	test   $0x1,%al
80103a28:	0f 84 c2 00 00 00    	je     80103af0 <kbdgetc+0xd0>
{
80103a2e:	55                   	push   %ebp
80103a2f:	ba 60 00 00 00       	mov    $0x60,%edx
80103a34:	89 e5                	mov    %esp,%ebp
80103a36:	53                   	push   %ebx
80103a37:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103a38:	8b 1d 1c 42 11 80    	mov    0x8011421c,%ebx
  data = inb(KBDATAP);
80103a3e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103a41:	3c e0                	cmp    $0xe0,%al
80103a43:	74 5b                	je     80103aa0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103a45:	89 da                	mov    %ebx,%edx
80103a47:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80103a4a:	84 c0                	test   %al,%al
80103a4c:	78 62                	js     80103ab0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103a4e:	85 d2                	test   %edx,%edx
80103a50:	74 09                	je     80103a5b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103a52:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103a55:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103a58:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80103a5b:	0f b6 91 20 9d 10 80 	movzbl -0x7fef62e0(%ecx),%edx
  shift ^= togglecode[data];
80103a62:	0f b6 81 20 9c 10 80 	movzbl -0x7fef63e0(%ecx),%eax
  shift |= shiftcode[data];
80103a69:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103a6b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a6d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103a6f:	89 15 1c 42 11 80    	mov    %edx,0x8011421c
  c = charcode[shift & (CTL | SHIFT)][data];
80103a75:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103a78:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a7b:	8b 04 85 00 9c 10 80 	mov    -0x7fef6400(,%eax,4),%eax
80103a82:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103a86:	74 0b                	je     80103a93 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103a88:	8d 50 9f             	lea    -0x61(%eax),%edx
80103a8b:	83 fa 19             	cmp    $0x19,%edx
80103a8e:	77 48                	ja     80103ad8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103a90:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a96:	c9                   	leave
80103a97:	c3                   	ret
80103a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a9f:	00 
    shift |= E0ESC;
80103aa0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103aa3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103aa5:	89 1d 1c 42 11 80    	mov    %ebx,0x8011421c
}
80103aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aae:	c9                   	leave
80103aaf:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80103ab0:	83 e0 7f             	and    $0x7f,%eax
80103ab3:	85 d2                	test   %edx,%edx
80103ab5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103ab8:	0f b6 81 20 9d 10 80 	movzbl -0x7fef62e0(%ecx),%eax
80103abf:	83 c8 40             	or     $0x40,%eax
80103ac2:	0f b6 c0             	movzbl %al,%eax
80103ac5:	f7 d0                	not    %eax
80103ac7:	21 d8                	and    %ebx,%eax
80103ac9:	a3 1c 42 11 80       	mov    %eax,0x8011421c
    return 0;
80103ace:	31 c0                	xor    %eax,%eax
80103ad0:	eb d9                	jmp    80103aab <kbdgetc+0x8b>
80103ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103ad8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103adb:	8d 50 20             	lea    0x20(%eax),%edx
}
80103ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ae1:	c9                   	leave
      c += 'a' - 'A';
80103ae2:	83 f9 1a             	cmp    $0x1a,%ecx
80103ae5:	0f 42 c2             	cmovb  %edx,%eax
}
80103ae8:	c3                   	ret
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103af5:	c3                   	ret
80103af6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103afd:	00 
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <kbdintr>:

void
kbdintr(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103b06:	68 20 3a 10 80       	push   $0x80103a20
80103b0b:	e8 80 dc ff ff       	call   80101790 <consoleintr>
}
80103b10:	83 c4 10             	add    $0x10,%esp
80103b13:	c9                   	leave
80103b14:	c3                   	ret
80103b15:	66 90                	xchg   %ax,%ax
80103b17:	66 90                	xchg   %ax,%ax
80103b19:	66 90                	xchg   %ax,%ax
80103b1b:	66 90                	xchg   %ax,%ax
80103b1d:	66 90                	xchg   %ax,%ax
80103b1f:	90                   	nop

80103b20 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103b20:	a1 20 42 11 80       	mov    0x80114220,%eax
80103b25:	85 c0                	test   %eax,%eax
80103b27:	0f 84 c3 00 00 00    	je     80103bf0 <lapicinit+0xd0>
  lapic[index] = value;
80103b2d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103b34:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b3a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103b41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b47:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103b4e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103b51:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b54:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103b5b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103b5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b61:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103b68:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103b6b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b6e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103b75:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103b78:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103b7b:	8b 50 30             	mov    0x30(%eax),%edx
80103b7e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80103b84:	75 72                	jne    80103bf8 <lapicinit+0xd8>
  lapic[index] = value;
80103b86:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103b8d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b90:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b93:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103b9a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b9d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103ba0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103ba7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103baa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103bad:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103bb4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103bb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103bba:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103bc1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103bc4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103bc7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103bce:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103bd1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bd8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103bde:	80 e6 10             	and    $0x10,%dh
80103be1:	75 f5                	jne    80103bd8 <lapicinit+0xb8>
  lapic[index] = value;
80103be3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103bea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103bed:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103bf0:	c3                   	ret
80103bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103bf8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103bff:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c02:	8b 50 20             	mov    0x20(%eax),%edx
}
80103c05:	e9 7c ff ff ff       	jmp    80103b86 <lapicinit+0x66>
80103c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c10 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103c10:	a1 20 42 11 80       	mov    0x80114220,%eax
80103c15:	85 c0                	test   %eax,%eax
80103c17:	74 07                	je     80103c20 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103c19:	8b 40 20             	mov    0x20(%eax),%eax
80103c1c:	c1 e8 18             	shr    $0x18,%eax
80103c1f:	c3                   	ret
    return 0;
80103c20:	31 c0                	xor    %eax,%eax
}
80103c22:	c3                   	ret
80103c23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c2a:	00 
80103c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103c30:	a1 20 42 11 80       	mov    0x80114220,%eax
80103c35:	85 c0                	test   %eax,%eax
80103c37:	74 0d                	je     80103c46 <lapiceoi+0x16>
  lapic[index] = value;
80103c39:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103c40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c43:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103c46:	c3                   	ret
80103c47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c4e:	00 
80103c4f:	90                   	nop

80103c50 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103c50:	c3                   	ret
80103c51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c58:	00 
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103c60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c61:	b8 0f 00 00 00       	mov    $0xf,%eax
80103c66:	ba 70 00 00 00       	mov    $0x70,%edx
80103c6b:	89 e5                	mov    %esp,%ebp
80103c6d:	53                   	push   %ebx
80103c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c74:	ee                   	out    %al,(%dx)
80103c75:	b8 0a 00 00 00       	mov    $0xa,%eax
80103c7a:	ba 71 00 00 00       	mov    $0x71,%edx
80103c7f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103c80:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80103c82:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103c85:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103c8b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103c8d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80103c90:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103c92:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103c95:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103c98:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103c9e:	a1 20 42 11 80       	mov    0x80114220,%eax
80103ca3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103ca9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103cac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103cb3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103cb6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103cb9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103cc0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103cc3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103cc6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103ccc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103ccf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103cd5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103cd8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103cde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103ce1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103ce7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ced:	c9                   	leave
80103cee:	c3                   	ret
80103cef:	90                   	nop

80103cf0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103cf0:	55                   	push   %ebp
80103cf1:	b8 0b 00 00 00       	mov    $0xb,%eax
80103cf6:	ba 70 00 00 00       	mov    $0x70,%edx
80103cfb:	89 e5                	mov    %esp,%ebp
80103cfd:	57                   	push   %edi
80103cfe:	56                   	push   %esi
80103cff:	53                   	push   %ebx
80103d00:	83 ec 4c             	sub    $0x4c,%esp
80103d03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d04:	ba 71 00 00 00       	mov    $0x71,%edx
80103d09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103d0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d0d:	bf 70 00 00 00       	mov    $0x70,%edi
80103d12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103d15:	8d 76 00             	lea    0x0(%esi),%esi
80103d18:	31 c0                	xor    %eax,%eax
80103d1a:	89 fa                	mov    %edi,%edx
80103d1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103d22:	89 ca                	mov    %ecx,%edx
80103d24:	ec                   	in     (%dx),%al
80103d25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d28:	89 fa                	mov    %edi,%edx
80103d2a:	b8 02 00 00 00       	mov    $0x2,%eax
80103d2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d30:	89 ca                	mov    %ecx,%edx
80103d32:	ec                   	in     (%dx),%al
80103d33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d36:	89 fa                	mov    %edi,%edx
80103d38:	b8 04 00 00 00       	mov    $0x4,%eax
80103d3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d3e:	89 ca                	mov    %ecx,%edx
80103d40:	ec                   	in     (%dx),%al
80103d41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d44:	89 fa                	mov    %edi,%edx
80103d46:	b8 07 00 00 00       	mov    $0x7,%eax
80103d4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d4c:	89 ca                	mov    %ecx,%edx
80103d4e:	ec                   	in     (%dx),%al
80103d4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d52:	89 fa                	mov    %edi,%edx
80103d54:	b8 08 00 00 00       	mov    $0x8,%eax
80103d59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d5a:	89 ca                	mov    %ecx,%edx
80103d5c:	ec                   	in     (%dx),%al
80103d5d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d5f:	89 fa                	mov    %edi,%edx
80103d61:	b8 09 00 00 00       	mov    $0x9,%eax
80103d66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d67:	89 ca                	mov    %ecx,%edx
80103d69:	ec                   	in     (%dx),%al
80103d6a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d6d:	89 fa                	mov    %edi,%edx
80103d6f:	b8 0a 00 00 00       	mov    $0xa,%eax
80103d74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d75:	89 ca                	mov    %ecx,%edx
80103d77:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103d78:	84 c0                	test   %al,%al
80103d7a:	78 9c                	js     80103d18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103d7c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103d80:	89 f2                	mov    %esi,%edx
80103d82:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80103d85:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d88:	89 fa                	mov    %edi,%edx
80103d8a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103d8d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103d91:	89 75 c8             	mov    %esi,-0x38(%ebp)
80103d94:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103d97:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103d9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103d9e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103da2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103da5:	31 c0                	xor    %eax,%eax
80103da7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103da8:	89 ca                	mov    %ecx,%edx
80103daa:	ec                   	in     (%dx),%al
80103dab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dae:	89 fa                	mov    %edi,%edx
80103db0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103db3:	b8 02 00 00 00       	mov    $0x2,%eax
80103db8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103db9:	89 ca                	mov    %ecx,%edx
80103dbb:	ec                   	in     (%dx),%al
80103dbc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dbf:	89 fa                	mov    %edi,%edx
80103dc1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103dc4:	b8 04 00 00 00       	mov    $0x4,%eax
80103dc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dca:	89 ca                	mov    %ecx,%edx
80103dcc:	ec                   	in     (%dx),%al
80103dcd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dd0:	89 fa                	mov    %edi,%edx
80103dd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103dd5:	b8 07 00 00 00       	mov    $0x7,%eax
80103dda:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ddb:	89 ca                	mov    %ecx,%edx
80103ddd:	ec                   	in     (%dx),%al
80103dde:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103de1:	89 fa                	mov    %edi,%edx
80103de3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103de6:	b8 08 00 00 00       	mov    $0x8,%eax
80103deb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dec:	89 ca                	mov    %ecx,%edx
80103dee:	ec                   	in     (%dx),%al
80103def:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103df2:	89 fa                	mov    %edi,%edx
80103df4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103df7:	b8 09 00 00 00       	mov    $0x9,%eax
80103dfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dfd:	89 ca                	mov    %ecx,%edx
80103dff:	ec                   	in     (%dx),%al
80103e00:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103e03:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103e06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103e09:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103e0c:	6a 18                	push   $0x18
80103e0e:	50                   	push   %eax
80103e0f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103e12:	50                   	push   %eax
80103e13:	e8 f8 25 00 00       	call   80106410 <memcmp>
80103e18:	83 c4 10             	add    $0x10,%esp
80103e1b:	85 c0                	test   %eax,%eax
80103e1d:	0f 85 f5 fe ff ff    	jne    80103d18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103e23:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80103e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103e2a:	89 f0                	mov    %esi,%eax
80103e2c:	84 c0                	test   %al,%al
80103e2e:	75 78                	jne    80103ea8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103e30:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103e33:	89 c2                	mov    %eax,%edx
80103e35:	83 e0 0f             	and    $0xf,%eax
80103e38:	c1 ea 04             	shr    $0x4,%edx
80103e3b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e3e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e41:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103e44:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103e47:	89 c2                	mov    %eax,%edx
80103e49:	83 e0 0f             	and    $0xf,%eax
80103e4c:	c1 ea 04             	shr    $0x4,%edx
80103e4f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e52:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e55:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103e58:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103e5b:	89 c2                	mov    %eax,%edx
80103e5d:	83 e0 0f             	and    $0xf,%eax
80103e60:	c1 ea 04             	shr    $0x4,%edx
80103e63:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e66:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e69:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103e6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103e6f:	89 c2                	mov    %eax,%edx
80103e71:	83 e0 0f             	and    $0xf,%eax
80103e74:	c1 ea 04             	shr    $0x4,%edx
80103e77:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e7a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e7d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103e80:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103e83:	89 c2                	mov    %eax,%edx
80103e85:	83 e0 0f             	and    $0xf,%eax
80103e88:	c1 ea 04             	shr    $0x4,%edx
80103e8b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e8e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e91:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103e94:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103e97:	89 c2                	mov    %eax,%edx
80103e99:	83 e0 0f             	and    $0xf,%eax
80103e9c:	c1 ea 04             	shr    $0x4,%edx
80103e9f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103ea2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103ea5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103ea8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103eab:	89 03                	mov    %eax,(%ebx)
80103ead:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103eb0:	89 43 04             	mov    %eax,0x4(%ebx)
80103eb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103eb6:	89 43 08             	mov    %eax,0x8(%ebx)
80103eb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103ebc:	89 43 0c             	mov    %eax,0xc(%ebx)
80103ebf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103ec2:	89 43 10             	mov    %eax,0x10(%ebx)
80103ec5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103ec8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80103ecb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ed5:	5b                   	pop    %ebx
80103ed6:	5e                   	pop    %esi
80103ed7:	5f                   	pop    %edi
80103ed8:	5d                   	pop    %ebp
80103ed9:	c3                   	ret
80103eda:	66 90                	xchg   %ax,%ax
80103edc:	66 90                	xchg   %ax,%ax
80103ede:	66 90                	xchg   %ax,%ax

80103ee0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103ee0:	8b 0d 88 42 11 80    	mov    0x80114288,%ecx
80103ee6:	85 c9                	test   %ecx,%ecx
80103ee8:	0f 8e 8a 00 00 00    	jle    80103f78 <install_trans+0x98>
{
80103eee:	55                   	push   %ebp
80103eef:	89 e5                	mov    %esp,%ebp
80103ef1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103ef2:	31 ff                	xor    %edi,%edi
{
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103f00:	a1 74 42 11 80       	mov    0x80114274,%eax
80103f05:	83 ec 08             	sub    $0x8,%esp
80103f08:	01 f8                	add    %edi,%eax
80103f0a:	83 c0 01             	add    $0x1,%eax
80103f0d:	50                   	push   %eax
80103f0e:	ff 35 84 42 11 80    	push   0x80114284
80103f14:	e8 b7 c1 ff ff       	call   801000d0 <bread>
80103f19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103f1b:	58                   	pop    %eax
80103f1c:	5a                   	pop    %edx
80103f1d:	ff 34 bd 8c 42 11 80 	push   -0x7feebd74(,%edi,4)
80103f24:	ff 35 84 42 11 80    	push   0x80114284
  for (tail = 0; tail < log.lh.n; tail++) {
80103f2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103f2d:	e8 9e c1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103f32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103f35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103f37:	8d 46 5c             	lea    0x5c(%esi),%eax
80103f3a:	68 00 02 00 00       	push   $0x200
80103f3f:	50                   	push   %eax
80103f40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103f43:	50                   	push   %eax
80103f44:	e8 17 25 00 00       	call   80106460 <memmove>
    bwrite(dbuf);  // write dst to disk
80103f49:	89 1c 24             	mov    %ebx,(%esp)
80103f4c:	e8 5f c2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103f51:	89 34 24             	mov    %esi,(%esp)
80103f54:	e8 97 c2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103f59:	89 1c 24             	mov    %ebx,(%esp)
80103f5c:	e8 8f c2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103f61:	83 c4 10             	add    $0x10,%esp
80103f64:	39 3d 88 42 11 80    	cmp    %edi,0x80114288
80103f6a:	7f 94                	jg     80103f00 <install_trans+0x20>
  }
}
80103f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f6f:	5b                   	pop    %ebx
80103f70:	5e                   	pop    %esi
80103f71:	5f                   	pop    %edi
80103f72:	5d                   	pop    %ebp
80103f73:	c3                   	ret
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f78:	c3                   	ret
80103f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
80103f84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f87:	ff 35 74 42 11 80    	push   0x80114274
80103f8d:	ff 35 84 42 11 80    	push   0x80114284
80103f93:	e8 38 c1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103f98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103f9d:	a1 88 42 11 80       	mov    0x80114288,%eax
80103fa2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103fa5:	85 c0                	test   %eax,%eax
80103fa7:	7e 19                	jle    80103fc2 <write_head+0x42>
80103fa9:	31 d2                	xor    %edx,%edx
80103fab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103fb0:	8b 0c 95 8c 42 11 80 	mov    -0x7feebd74(,%edx,4),%ecx
80103fb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103fbb:	83 c2 01             	add    $0x1,%edx
80103fbe:	39 d0                	cmp    %edx,%eax
80103fc0:	75 ee                	jne    80103fb0 <write_head+0x30>
  }
  bwrite(buf);
80103fc2:	83 ec 0c             	sub    $0xc,%esp
80103fc5:	53                   	push   %ebx
80103fc6:	e8 e5 c1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80103fcb:	89 1c 24             	mov    %ebx,(%esp)
80103fce:	e8 1d c2 ff ff       	call   801001f0 <brelse>
}
80103fd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd6:	83 c4 10             	add    $0x10,%esp
80103fd9:	c9                   	leave
80103fda:	c3                   	ret
80103fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103fe0 <initlog>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 2c             	sub    $0x2c,%esp
80103fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80103fea:	68 37 94 10 80       	push   $0x80109437
80103fef:	68 40 42 11 80       	push   $0x80114240
80103ff4:	e8 e7 20 00 00       	call   801060e0 <initlock>
  readsb(dev, &sb);
80103ff9:	58                   	pop    %eax
80103ffa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103ffd:	5a                   	pop    %edx
80103ffe:	50                   	push   %eax
80103fff:	53                   	push   %ebx
80104000:	e8 7b e8 ff ff       	call   80102880 <readsb>
  log.start = sb.logstart;
80104005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80104008:	59                   	pop    %ecx
  log.dev = dev;
80104009:	89 1d 84 42 11 80    	mov    %ebx,0x80114284
  log.size = sb.nlog;
8010400f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80104012:	a3 74 42 11 80       	mov    %eax,0x80114274
  log.size = sb.nlog;
80104017:	89 15 78 42 11 80    	mov    %edx,0x80114278
  struct buf *buf = bread(log.dev, log.start);
8010401d:	5a                   	pop    %edx
8010401e:	50                   	push   %eax
8010401f:	53                   	push   %ebx
80104020:	e8 ab c0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80104025:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80104028:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010402b:	89 1d 88 42 11 80    	mov    %ebx,0x80114288
  for (i = 0; i < log.lh.n; i++) {
80104031:	85 db                	test   %ebx,%ebx
80104033:	7e 1d                	jle    80104052 <initlog+0x72>
80104035:	31 d2                	xor    %edx,%edx
80104037:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010403e:	00 
8010403f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80104040:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80104044:	89 0c 95 8c 42 11 80 	mov    %ecx,-0x7feebd74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010404b:	83 c2 01             	add    $0x1,%edx
8010404e:	39 d3                	cmp    %edx,%ebx
80104050:	75 ee                	jne    80104040 <initlog+0x60>
  brelse(buf);
80104052:	83 ec 0c             	sub    $0xc,%esp
80104055:	50                   	push   %eax
80104056:	e8 95 c1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010405b:	e8 80 fe ff ff       	call   80103ee0 <install_trans>
  log.lh.n = 0;
80104060:	c7 05 88 42 11 80 00 	movl   $0x0,0x80114288
80104067:	00 00 00 
  write_head(); // clear the log
8010406a:	e8 11 ff ff ff       	call   80103f80 <write_head>
}
8010406f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104072:	83 c4 10             	add    $0x10,%esp
80104075:	c9                   	leave
80104076:	c3                   	ret
80104077:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010407e:	00 
8010407f:	90                   	nop

80104080 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104086:	68 40 42 11 80       	push   $0x80114240
8010408b:	e8 40 22 00 00       	call   801062d0 <acquire>
80104090:	83 c4 10             	add    $0x10,%esp
80104093:	eb 18                	jmp    801040ad <begin_op+0x2d>
80104095:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104098:	83 ec 08             	sub    $0x8,%esp
8010409b:	68 40 42 11 80       	push   $0x80114240
801040a0:	68 40 42 11 80       	push   $0x80114240
801040a5:	e8 46 13 00 00       	call   801053f0 <sleep>
801040aa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801040ad:	a1 80 42 11 80       	mov    0x80114280,%eax
801040b2:	85 c0                	test   %eax,%eax
801040b4:	75 e2                	jne    80104098 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801040b6:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801040bb:	8b 15 88 42 11 80    	mov    0x80114288,%edx
801040c1:	83 c0 01             	add    $0x1,%eax
801040c4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801040c7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801040ca:	83 fa 1e             	cmp    $0x1e,%edx
801040cd:	7f c9                	jg     80104098 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801040cf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801040d2:	a3 7c 42 11 80       	mov    %eax,0x8011427c
      release(&log.lock);
801040d7:	68 40 42 11 80       	push   $0x80114240
801040dc:	e8 8f 21 00 00       	call   80106270 <release>
      break;
    }
  }
}
801040e1:	83 c4 10             	add    $0x10,%esp
801040e4:	c9                   	leave
801040e5:	c3                   	ret
801040e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ed:	00 
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801040f9:	68 40 42 11 80       	push   $0x80114240
801040fe:	e8 cd 21 00 00       	call   801062d0 <acquire>
  log.outstanding -= 1;
80104103:	a1 7c 42 11 80       	mov    0x8011427c,%eax
  if(log.committing)
80104108:	8b 35 80 42 11 80    	mov    0x80114280,%esi
8010410e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80104111:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104114:	89 1d 7c 42 11 80    	mov    %ebx,0x8011427c
  if(log.committing)
8010411a:	85 f6                	test   %esi,%esi
8010411c:	0f 85 22 01 00 00    	jne    80104244 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80104122:	85 db                	test   %ebx,%ebx
80104124:	0f 85 f6 00 00 00    	jne    80104220 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010412a:	c7 05 80 42 11 80 01 	movl   $0x1,0x80114280
80104131:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	68 40 42 11 80       	push   $0x80114240
8010413c:	e8 2f 21 00 00       	call   80106270 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104141:	8b 0d 88 42 11 80    	mov    0x80114288,%ecx
80104147:	83 c4 10             	add    $0x10,%esp
8010414a:	85 c9                	test   %ecx,%ecx
8010414c:	7f 42                	jg     80104190 <end_op+0xa0>
    acquire(&log.lock);
8010414e:	83 ec 0c             	sub    $0xc,%esp
80104151:	68 40 42 11 80       	push   $0x80114240
80104156:	e8 75 21 00 00       	call   801062d0 <acquire>
    log.committing = 0;
8010415b:	c7 05 80 42 11 80 00 	movl   $0x0,0x80114280
80104162:	00 00 00 
    wakeup(&log);
80104165:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
8010416c:	e8 3f 13 00 00       	call   801054b0 <wakeup>
    release(&log.lock);
80104171:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80104178:	e8 f3 20 00 00       	call   80106270 <release>
8010417d:	83 c4 10             	add    $0x10,%esp
}
80104180:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104183:	5b                   	pop    %ebx
80104184:	5e                   	pop    %esi
80104185:	5f                   	pop    %edi
80104186:	5d                   	pop    %ebp
80104187:	c3                   	ret
80104188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010418f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104190:	a1 74 42 11 80       	mov    0x80114274,%eax
80104195:	83 ec 08             	sub    $0x8,%esp
80104198:	01 d8                	add    %ebx,%eax
8010419a:	83 c0 01             	add    $0x1,%eax
8010419d:	50                   	push   %eax
8010419e:	ff 35 84 42 11 80    	push   0x80114284
801041a4:	e8 27 bf ff ff       	call   801000d0 <bread>
801041a9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801041ab:	58                   	pop    %eax
801041ac:	5a                   	pop    %edx
801041ad:	ff 34 9d 8c 42 11 80 	push   -0x7feebd74(,%ebx,4)
801041b4:	ff 35 84 42 11 80    	push   0x80114284
  for (tail = 0; tail < log.lh.n; tail++) {
801041ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801041bd:	e8 0e bf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801041c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801041c5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801041c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801041ca:	68 00 02 00 00       	push   $0x200
801041cf:	50                   	push   %eax
801041d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801041d3:	50                   	push   %eax
801041d4:	e8 87 22 00 00       	call   80106460 <memmove>
    bwrite(to);  // write the log
801041d9:	89 34 24             	mov    %esi,(%esp)
801041dc:	e8 cf bf ff ff       	call   801001b0 <bwrite>
    brelse(from);
801041e1:	89 3c 24             	mov    %edi,(%esp)
801041e4:	e8 07 c0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801041e9:	89 34 24             	mov    %esi,(%esp)
801041ec:	e8 ff bf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801041f1:	83 c4 10             	add    $0x10,%esp
801041f4:	3b 1d 88 42 11 80    	cmp    0x80114288,%ebx
801041fa:	7c 94                	jl     80104190 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801041fc:	e8 7f fd ff ff       	call   80103f80 <write_head>
    install_trans(); // Now install writes to home locations
80104201:	e8 da fc ff ff       	call   80103ee0 <install_trans>
    log.lh.n = 0;
80104206:	c7 05 88 42 11 80 00 	movl   $0x0,0x80114288
8010420d:	00 00 00 
    write_head();    // Erase the transaction from the log
80104210:	e8 6b fd ff ff       	call   80103f80 <write_head>
80104215:	e9 34 ff ff ff       	jmp    8010414e <end_op+0x5e>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	68 40 42 11 80       	push   $0x80114240
80104228:	e8 83 12 00 00       	call   801054b0 <wakeup>
  release(&log.lock);
8010422d:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80104234:	e8 37 20 00 00       	call   80106270 <release>
80104239:	83 c4 10             	add    $0x10,%esp
}
8010423c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010423f:	5b                   	pop    %ebx
80104240:	5e                   	pop    %esi
80104241:	5f                   	pop    %edi
80104242:	5d                   	pop    %ebp
80104243:	c3                   	ret
    panic("log.committing");
80104244:	83 ec 0c             	sub    $0xc,%esp
80104247:	68 3b 94 10 80       	push   $0x8010943b
8010424c:	e8 ff c1 ff ff       	call   80100450 <panic>
80104251:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104258:	00 
80104259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104260 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104267:	8b 15 88 42 11 80    	mov    0x80114288,%edx
{
8010426d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104270:	83 fa 1d             	cmp    $0x1d,%edx
80104273:	7f 7d                	jg     801042f2 <log_write+0x92>
80104275:	a1 78 42 11 80       	mov    0x80114278,%eax
8010427a:	83 e8 01             	sub    $0x1,%eax
8010427d:	39 c2                	cmp    %eax,%edx
8010427f:	7d 71                	jge    801042f2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104281:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80104286:	85 c0                	test   %eax,%eax
80104288:	7e 75                	jle    801042ff <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 40 42 11 80       	push   $0x80114240
80104292:	e8 39 20 00 00       	call   801062d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104297:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010429a:	83 c4 10             	add    $0x10,%esp
8010429d:	31 c0                	xor    %eax,%eax
8010429f:	8b 15 88 42 11 80    	mov    0x80114288,%edx
801042a5:	85 d2                	test   %edx,%edx
801042a7:	7f 0e                	jg     801042b7 <log_write+0x57>
801042a9:	eb 15                	jmp    801042c0 <log_write+0x60>
801042ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801042b0:	83 c0 01             	add    $0x1,%eax
801042b3:	39 c2                	cmp    %eax,%edx
801042b5:	74 29                	je     801042e0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801042b7:	39 0c 85 8c 42 11 80 	cmp    %ecx,-0x7feebd74(,%eax,4)
801042be:	75 f0                	jne    801042b0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801042c0:	89 0c 85 8c 42 11 80 	mov    %ecx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801042c7:	39 c2                	cmp    %eax,%edx
801042c9:	74 1c                	je     801042e7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801042cb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801042d1:	c7 45 08 40 42 11 80 	movl   $0x80114240,0x8(%ebp)
}
801042d8:	c9                   	leave
  release(&log.lock);
801042d9:	e9 92 1f 00 00       	jmp    80106270 <release>
801042de:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801042e0:	89 0c 95 8c 42 11 80 	mov    %ecx,-0x7feebd74(,%edx,4)
    log.lh.n++;
801042e7:	83 c2 01             	add    $0x1,%edx
801042ea:	89 15 88 42 11 80    	mov    %edx,0x80114288
801042f0:	eb d9                	jmp    801042cb <log_write+0x6b>
    panic("too big a transaction");
801042f2:	83 ec 0c             	sub    $0xc,%esp
801042f5:	68 4a 94 10 80       	push   $0x8010944a
801042fa:	e8 51 c1 ff ff       	call   80100450 <panic>
    panic("log_write outside of trans");
801042ff:	83 ec 0c             	sub    $0xc,%esp
80104302:	68 60 94 10 80       	push   $0x80109460
80104307:	e8 44 c1 ff ff       	call   80100450 <panic>
8010430c:	66 90                	xchg   %ax,%ax
8010430e:	66 90                	xchg   %ax,%ax

80104310 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104317:	e8 b4 09 00 00       	call   80104cd0 <cpuid>
8010431c:	89 c3                	mov    %eax,%ebx
8010431e:	e8 ad 09 00 00       	call   80104cd0 <cpuid>
80104323:	83 ec 04             	sub    $0x4,%esp
80104326:	53                   	push   %ebx
80104327:	50                   	push   %eax
80104328:	68 7b 94 10 80       	push   $0x8010947b
8010432d:	e8 ae c4 ff ff       	call   801007e0 <cprintf>
  idtinit();       // load idt register
80104332:	e8 59 36 00 00       	call   80107990 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104337:	e8 34 09 00 00       	call   80104c70 <mycpu>
8010433c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010433e:	b8 01 00 00 00       	mov    $0x1,%eax
80104343:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010434a:	e8 91 0c 00 00       	call   80104fe0 <scheduler>
8010434f:	90                   	nop

80104350 <mpenter>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104356:	e8 75 47 00 00       	call   80108ad0 <switchkvm>
  seginit();
8010435b:	e8 e0 46 00 00       	call   80108a40 <seginit>
  lapicinit();
80104360:	e8 bb f7 ff ff       	call   80103b20 <lapicinit>
  mpmain();
80104365:	e8 a6 ff ff ff       	call   80104310 <mpmain>
8010436a:	66 90                	xchg   %ax,%ax
8010436c:	66 90                	xchg   %ax,%ax
8010436e:	66 90                	xchg   %ax,%ax

80104370 <main>:
{
80104370:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104374:	83 e4 f0             	and    $0xfffffff0,%esp
80104377:	ff 71 fc             	push   -0x4(%ecx)
8010437a:	55                   	push   %ebp
8010437b:	89 e5                	mov    %esp,%ebp
8010437d:	53                   	push   %ebx
8010437e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010437f:	83 ec 08             	sub    $0x8,%esp
80104382:	68 00 00 40 80       	push   $0x80400000
80104387:	68 70 ee 11 80       	push   $0x8011ee70
8010438c:	e8 9f f5 ff ff       	call   80103930 <kinit1>
  kvmalloc();      // kernel page table
80104391:	e8 fa 4b 00 00       	call   80108f90 <kvmalloc>
  mpinit();        // detect other processors
80104396:	e8 85 01 00 00       	call   80104520 <mpinit>
  lapicinit();     // interrupt controller
8010439b:	e8 80 f7 ff ff       	call   80103b20 <lapicinit>
  seginit();       // segment descriptors
801043a0:	e8 9b 46 00 00       	call   80108a40 <seginit>
  picinit();       // disable pic
801043a5:	e8 86 03 00 00       	call   80104730 <picinit>
  ioapicinit();    // another interrupt controller
801043aa:	e8 51 f3 ff ff       	call   80103700 <ioapicinit>
  consoleinit();   // console hardware
801043af:	e8 9c ce ff ff       	call   80101250 <consoleinit>
  uartinit();      // serial port
801043b4:	e8 f7 38 00 00       	call   80107cb0 <uartinit>
  pinit();         // process table
801043b9:	e8 92 08 00 00       	call   80104c50 <pinit>
  tvinit();        // trap vectors
801043be:	e8 4d 35 00 00       	call   80107910 <tvinit>
  binit();         // buffer cache
801043c3:	e8 78 bc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801043c8:	e8 a3 dd ff ff       	call   80102170 <fileinit>
  ideinit();       // disk 
801043cd:	e8 0e f1 ff ff       	call   801034e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801043d2:	83 c4 0c             	add    $0xc,%esp
801043d5:	68 8a 00 00 00       	push   $0x8a
801043da:	68 8c c4 10 80       	push   $0x8010c48c
801043df:	68 00 70 00 80       	push   $0x80007000
801043e4:	e8 77 20 00 00       	call   80106460 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801043e9:	83 c4 10             	add    $0x10,%esp
801043ec:	69 05 24 43 11 80 b0 	imul   $0xb0,0x80114324,%eax
801043f3:	00 00 00 
801043f6:	05 40 43 11 80       	add    $0x80114340,%eax
801043fb:	3d 40 43 11 80       	cmp    $0x80114340,%eax
80104400:	76 7e                	jbe    80104480 <main+0x110>
80104402:	bb 40 43 11 80       	mov    $0x80114340,%ebx
80104407:	eb 20                	jmp    80104429 <main+0xb9>
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104410:	69 05 24 43 11 80 b0 	imul   $0xb0,0x80114324,%eax
80104417:	00 00 00 
8010441a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104420:	05 40 43 11 80       	add    $0x80114340,%eax
80104425:	39 c3                	cmp    %eax,%ebx
80104427:	73 57                	jae    80104480 <main+0x110>
    if(c == mycpu())  // We've started already.
80104429:	e8 42 08 00 00       	call   80104c70 <mycpu>
8010442e:	39 c3                	cmp    %eax,%ebx
80104430:	74 de                	je     80104410 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104432:	e8 69 f5 ff ff       	call   801039a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104437:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010443a:	c7 05 f8 6f 00 80 50 	movl   $0x80104350,0x80006ff8
80104441:	43 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104444:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010444b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010444e:	05 00 10 00 00       	add    $0x1000,%eax
80104453:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104458:	0f b6 03             	movzbl (%ebx),%eax
8010445b:	68 00 70 00 00       	push   $0x7000
80104460:	50                   	push   %eax
80104461:	e8 fa f7 ff ff       	call   80103c60 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104466:	83 c4 10             	add    $0x10,%esp
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104470:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104476:	85 c0                	test   %eax,%eax
80104478:	74 f6                	je     80104470 <main+0x100>
8010447a:	eb 94                	jmp    80104410 <main+0xa0>
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104480:	83 ec 08             	sub    $0x8,%esp
80104483:	68 00 00 00 8e       	push   $0x8e000000
80104488:	68 00 00 40 80       	push   $0x80400000
8010448d:	e8 3e f4 ff ff       	call   801038d0 <kinit2>
  userinit();      // first user process
80104492:	e8 c9 08 00 00       	call   80104d60 <userinit>
  mpmain();        // finish this processor's setup
80104497:	e8 74 fe ff ff       	call   80104310 <mpmain>
8010449c:	66 90                	xchg   %ax,%ax
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801044a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801044ab:	53                   	push   %ebx
  e = addr+len;
801044ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801044af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801044b2:	39 de                	cmp    %ebx,%esi
801044b4:	72 10                	jb     801044c6 <mpsearch1+0x26>
801044b6:	eb 50                	jmp    80104508 <mpsearch1+0x68>
801044b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044bf:	00 
801044c0:	89 fe                	mov    %edi,%esi
801044c2:	39 df                	cmp    %ebx,%edi
801044c4:	73 42                	jae    80104508 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801044c6:	83 ec 04             	sub    $0x4,%esp
801044c9:	8d 7e 10             	lea    0x10(%esi),%edi
801044cc:	6a 04                	push   $0x4
801044ce:	68 8f 94 10 80       	push   $0x8010948f
801044d3:	56                   	push   %esi
801044d4:	e8 37 1f 00 00       	call   80106410 <memcmp>
801044d9:	83 c4 10             	add    $0x10,%esp
801044dc:	85 c0                	test   %eax,%eax
801044de:	75 e0                	jne    801044c0 <mpsearch1+0x20>
801044e0:	89 f2                	mov    %esi,%edx
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801044e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801044eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801044ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801044f0:	39 fa                	cmp    %edi,%edx
801044f2:	75 f4                	jne    801044e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801044f4:	84 c0                	test   %al,%al
801044f6:	75 c8                	jne    801044c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801044f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044fb:	89 f0                	mov    %esi,%eax
801044fd:	5b                   	pop    %ebx
801044fe:	5e                   	pop    %esi
801044ff:	5f                   	pop    %edi
80104500:	5d                   	pop    %ebp
80104501:	c3                   	ret
80104502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104508:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010450b:	31 f6                	xor    %esi,%esi
}
8010450d:	5b                   	pop    %ebx
8010450e:	89 f0                	mov    %esi,%eax
80104510:	5e                   	pop    %esi
80104511:	5f                   	pop    %edi
80104512:	5d                   	pop    %ebp
80104513:	c3                   	ret
80104514:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010451b:	00 
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104529:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104530:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104537:	c1 e0 08             	shl    $0x8,%eax
8010453a:	09 d0                	or     %edx,%eax
8010453c:	c1 e0 04             	shl    $0x4,%eax
8010453f:	75 1b                	jne    8010455c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104541:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104548:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010454f:	c1 e0 08             	shl    $0x8,%eax
80104552:	09 d0                	or     %edx,%eax
80104554:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104557:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010455c:	ba 00 04 00 00       	mov    $0x400,%edx
80104561:	e8 3a ff ff ff       	call   801044a0 <mpsearch1>
80104566:	89 c3                	mov    %eax,%ebx
80104568:	85 c0                	test   %eax,%eax
8010456a:	0f 84 58 01 00 00    	je     801046c8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104570:	8b 73 04             	mov    0x4(%ebx),%esi
80104573:	85 f6                	test   %esi,%esi
80104575:	0f 84 3d 01 00 00    	je     801046b8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010457b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010457e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80104584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80104587:	6a 04                	push   $0x4
80104589:	68 94 94 10 80       	push   $0x80109494
8010458e:	50                   	push   %eax
8010458f:	e8 7c 1e 00 00       	call   80106410 <memcmp>
80104594:	83 c4 10             	add    $0x10,%esp
80104597:	85 c0                	test   %eax,%eax
80104599:	0f 85 19 01 00 00    	jne    801046b8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010459f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801045a6:	3c 01                	cmp    $0x1,%al
801045a8:	74 08                	je     801045b2 <mpinit+0x92>
801045aa:	3c 04                	cmp    $0x4,%al
801045ac:	0f 85 06 01 00 00    	jne    801046b8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801045b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801045b9:	66 85 d2             	test   %dx,%dx
801045bc:	74 22                	je     801045e0 <mpinit+0xc0>
801045be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801045c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801045c3:	31 d2                	xor    %edx,%edx
801045c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801045c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801045cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801045d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801045d4:	39 f8                	cmp    %edi,%eax
801045d6:	75 f0                	jne    801045c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801045d8:	84 d2                	test   %dl,%dl
801045da:	0f 85 d8 00 00 00    	jne    801046b8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801045e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801045e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801045ec:	a3 20 42 11 80       	mov    %eax,0x80114220
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045f1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801045f8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801045fe:	01 d7                	add    %edx,%edi
80104600:	89 fa                	mov    %edi,%edx
  ismp = 1;
80104602:	bf 01 00 00 00       	mov    $0x1,%edi
80104607:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010460e:	00 
8010460f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104610:	39 d0                	cmp    %edx,%eax
80104612:	73 19                	jae    8010462d <mpinit+0x10d>
    switch(*p){
80104614:	0f b6 08             	movzbl (%eax),%ecx
80104617:	80 f9 02             	cmp    $0x2,%cl
8010461a:	0f 84 80 00 00 00    	je     801046a0 <mpinit+0x180>
80104620:	77 6e                	ja     80104690 <mpinit+0x170>
80104622:	84 c9                	test   %cl,%cl
80104624:	74 3a                	je     80104660 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104626:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104629:	39 d0                	cmp    %edx,%eax
8010462b:	72 e7                	jb     80104614 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010462d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104630:	85 ff                	test   %edi,%edi
80104632:	0f 84 dd 00 00 00    	je     80104715 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80104638:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010463c:	74 15                	je     80104653 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010463e:	b8 70 00 00 00       	mov    $0x70,%eax
80104643:	ba 22 00 00 00       	mov    $0x22,%edx
80104648:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104649:	ba 23 00 00 00       	mov    $0x23,%edx
8010464e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010464f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104652:	ee                   	out    %al,(%dx)
  }
}
80104653:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104656:	5b                   	pop    %ebx
80104657:	5e                   	pop    %esi
80104658:	5f                   	pop    %edi
80104659:	5d                   	pop    %ebp
8010465a:	c3                   	ret
8010465b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80104660:	8b 0d 24 43 11 80    	mov    0x80114324,%ecx
80104666:	83 f9 07             	cmp    $0x7,%ecx
80104669:	7f 19                	jg     80104684 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010466b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80104671:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104675:	83 c1 01             	add    $0x1,%ecx
80104678:	89 0d 24 43 11 80    	mov    %ecx,0x80114324
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010467e:	88 9e 40 43 11 80    	mov    %bl,-0x7feebcc0(%esi)
      p += sizeof(struct mpproc);
80104684:	83 c0 14             	add    $0x14,%eax
      continue;
80104687:	eb 87                	jmp    80104610 <mpinit+0xf0>
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80104690:	83 e9 03             	sub    $0x3,%ecx
80104693:	80 f9 01             	cmp    $0x1,%cl
80104696:	76 8e                	jbe    80104626 <mpinit+0x106>
80104698:	31 ff                	xor    %edi,%edi
8010469a:	e9 71 ff ff ff       	jmp    80104610 <mpinit+0xf0>
8010469f:	90                   	nop
      ioapicid = ioapic->apicno;
801046a0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801046a4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801046a7:	88 0d 20 43 11 80    	mov    %cl,0x80114320
      continue;
801046ad:	e9 5e ff ff ff       	jmp    80104610 <mpinit+0xf0>
801046b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 99 94 10 80       	push   $0x80109499
801046c0:	e8 8b bd ff ff       	call   80100450 <panic>
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
{
801046c8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801046cd:	eb 0b                	jmp    801046da <mpinit+0x1ba>
801046cf:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801046d0:	89 f3                	mov    %esi,%ebx
801046d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801046d8:	74 de                	je     801046b8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801046da:	83 ec 04             	sub    $0x4,%esp
801046dd:	8d 73 10             	lea    0x10(%ebx),%esi
801046e0:	6a 04                	push   $0x4
801046e2:	68 8f 94 10 80       	push   $0x8010948f
801046e7:	53                   	push   %ebx
801046e8:	e8 23 1d 00 00       	call   80106410 <memcmp>
801046ed:	83 c4 10             	add    $0x10,%esp
801046f0:	85 c0                	test   %eax,%eax
801046f2:	75 dc                	jne    801046d0 <mpinit+0x1b0>
801046f4:	89 da                	mov    %ebx,%edx
801046f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046fd:	00 
801046fe:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80104700:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104703:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104706:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104708:	39 d6                	cmp    %edx,%esi
8010470a:	75 f4                	jne    80104700 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010470c:	84 c0                	test   %al,%al
8010470e:	75 c0                	jne    801046d0 <mpinit+0x1b0>
80104710:	e9 5b fe ff ff       	jmp    80104570 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104715:	83 ec 0c             	sub    $0xc,%esp
80104718:	68 18 99 10 80       	push   $0x80109918
8010471d:	e8 2e bd ff ff       	call   80100450 <panic>
80104722:	66 90                	xchg   %ax,%ax
80104724:	66 90                	xchg   %ax,%ax
80104726:	66 90                	xchg   %ax,%ax
80104728:	66 90                	xchg   %ax,%ax
8010472a:	66 90                	xchg   %ax,%ax
8010472c:	66 90                	xchg   %ax,%ax
8010472e:	66 90                	xchg   %ax,%ax

80104730 <picinit>:
80104730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104735:	ba 21 00 00 00       	mov    $0x21,%edx
8010473a:	ee                   	out    %al,(%dx)
8010473b:	ba a1 00 00 00       	mov    $0xa1,%edx
80104740:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104741:	c3                   	ret
80104742:	66 90                	xchg   %ax,%ax
80104744:	66 90                	xchg   %ax,%ax
80104746:	66 90                	xchg   %ax,%ax
80104748:	66 90                	xchg   %ax,%ax
8010474a:	66 90                	xchg   %ax,%ax
8010474c:	66 90                	xchg   %ax,%ax
8010474e:	66 90                	xchg   %ax,%ax

80104750 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	53                   	push   %ebx
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	8b 75 08             	mov    0x8(%ebp),%esi
8010475c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010475f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104765:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010476b:	e8 20 da ff ff       	call   80102190 <filealloc>
80104770:	89 06                	mov    %eax,(%esi)
80104772:	85 c0                	test   %eax,%eax
80104774:	0f 84 a5 00 00 00    	je     8010481f <pipealloc+0xcf>
8010477a:	e8 11 da ff ff       	call   80102190 <filealloc>
8010477f:	89 07                	mov    %eax,(%edi)
80104781:	85 c0                	test   %eax,%eax
80104783:	0f 84 84 00 00 00    	je     8010480d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104789:	e8 12 f2 ff ff       	call   801039a0 <kalloc>
8010478e:	89 c3                	mov    %eax,%ebx
80104790:	85 c0                	test   %eax,%eax
80104792:	0f 84 a0 00 00 00    	je     80104838 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80104798:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010479f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801047a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801047a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801047ac:	00 00 00 
  p->nwrite = 0;
801047af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801047b6:	00 00 00 
  p->nread = 0;
801047b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801047c0:	00 00 00 
  initlock(&p->lock, "pipe");
801047c3:	68 b1 94 10 80       	push   $0x801094b1
801047c8:	50                   	push   %eax
801047c9:	e8 12 19 00 00       	call   801060e0 <initlock>
  (*f0)->type = FD_PIPE;
801047ce:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801047d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801047d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801047d9:	8b 06                	mov    (%esi),%eax
801047db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801047df:	8b 06                	mov    (%esi),%eax
801047e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801047e5:	8b 06                	mov    (%esi),%eax
801047e7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801047ea:	8b 07                	mov    (%edi),%eax
801047ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801047f2:	8b 07                	mov    (%edi),%eax
801047f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801047f8:	8b 07                	mov    (%edi),%eax
801047fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801047fe:	8b 07                	mov    (%edi),%eax
80104800:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80104803:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80104805:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104808:	5b                   	pop    %ebx
80104809:	5e                   	pop    %esi
8010480a:	5f                   	pop    %edi
8010480b:	5d                   	pop    %ebp
8010480c:	c3                   	ret
  if(*f0)
8010480d:	8b 06                	mov    (%esi),%eax
8010480f:	85 c0                	test   %eax,%eax
80104811:	74 1e                	je     80104831 <pipealloc+0xe1>
    fileclose(*f0);
80104813:	83 ec 0c             	sub    $0xc,%esp
80104816:	50                   	push   %eax
80104817:	e8 34 da ff ff       	call   80102250 <fileclose>
8010481c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010481f:	8b 07                	mov    (%edi),%eax
80104821:	85 c0                	test   %eax,%eax
80104823:	74 0c                	je     80104831 <pipealloc+0xe1>
    fileclose(*f1);
80104825:	83 ec 0c             	sub    $0xc,%esp
80104828:	50                   	push   %eax
80104829:	e8 22 da ff ff       	call   80102250 <fileclose>
8010482e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104836:	eb cd                	jmp    80104805 <pipealloc+0xb5>
  if(*f0)
80104838:	8b 06                	mov    (%esi),%eax
8010483a:	85 c0                	test   %eax,%eax
8010483c:	75 d5                	jne    80104813 <pipealloc+0xc3>
8010483e:	eb df                	jmp    8010481f <pipealloc+0xcf>

80104840 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104848:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010484b:	83 ec 0c             	sub    $0xc,%esp
8010484e:	53                   	push   %ebx
8010484f:	e8 7c 1a 00 00       	call   801062d0 <acquire>
  if(writable){
80104854:	83 c4 10             	add    $0x10,%esp
80104857:	85 f6                	test   %esi,%esi
80104859:	74 65                	je     801048c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010485b:	83 ec 0c             	sub    $0xc,%esp
8010485e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104864:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010486b:	00 00 00 
    wakeup(&p->nread);
8010486e:	50                   	push   %eax
8010486f:	e8 3c 0c 00 00       	call   801054b0 <wakeup>
80104874:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104877:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010487d:	85 d2                	test   %edx,%edx
8010487f:	75 0a                	jne    8010488b <pipeclose+0x4b>
80104881:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104887:	85 c0                	test   %eax,%eax
80104889:	74 15                	je     801048a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010488b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010488e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104891:	5b                   	pop    %ebx
80104892:	5e                   	pop    %esi
80104893:	5d                   	pop    %ebp
    release(&p->lock);
80104894:	e9 d7 19 00 00       	jmp    80106270 <release>
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801048a0:	83 ec 0c             	sub    $0xc,%esp
801048a3:	53                   	push   %ebx
801048a4:	e8 c7 19 00 00       	call   80106270 <release>
    kfree((char*)p);
801048a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801048ac:	83 c4 10             	add    $0x10,%esp
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
    kfree((char*)p);
801048b5:	e9 26 ef ff ff       	jmp    801037e0 <kfree>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801048c0:	83 ec 0c             	sub    $0xc,%esp
801048c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801048c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801048d0:	00 00 00 
    wakeup(&p->nwrite);
801048d3:	50                   	push   %eax
801048d4:	e8 d7 0b 00 00       	call   801054b0 <wakeup>
801048d9:	83 c4 10             	add    $0x10,%esp
801048dc:	eb 99                	jmp    80104877 <pipeclose+0x37>
801048de:	66 90                	xchg   %ax,%ax

801048e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
801048e6:	83 ec 28             	sub    $0x28,%esp
801048e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801048ef:	53                   	push   %ebx
801048f0:	e8 db 19 00 00       	call   801062d0 <acquire>
  for(i = 0; i < n; i++){
801048f5:	83 c4 10             	add    $0x10,%esp
801048f8:	85 ff                	test   %edi,%edi
801048fa:	0f 8e ce 00 00 00    	jle    801049ce <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104900:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80104906:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104909:	89 7d 10             	mov    %edi,0x10(%ebp)
8010490c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010490f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80104912:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104915:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010491b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104921:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104927:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010492d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80104930:	0f 85 b6 00 00 00    	jne    801049ec <pipewrite+0x10c>
80104936:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104939:	eb 3b                	jmp    80104976 <pipewrite+0x96>
8010493b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104940:	e8 ab 03 00 00       	call   80104cf0 <myproc>
80104945:	8b 48 24             	mov    0x24(%eax),%ecx
80104948:	85 c9                	test   %ecx,%ecx
8010494a:	75 34                	jne    80104980 <pipewrite+0xa0>
      wakeup(&p->nread);
8010494c:	83 ec 0c             	sub    $0xc,%esp
8010494f:	56                   	push   %esi
80104950:	e8 5b 0b 00 00       	call   801054b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104955:	58                   	pop    %eax
80104956:	5a                   	pop    %edx
80104957:	53                   	push   %ebx
80104958:	57                   	push   %edi
80104959:	e8 92 0a 00 00       	call   801053f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010495e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80104964:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010496a:	83 c4 10             	add    $0x10,%esp
8010496d:	05 00 02 00 00       	add    $0x200,%eax
80104972:	39 c2                	cmp    %eax,%edx
80104974:	75 2a                	jne    801049a0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80104976:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010497c:	85 c0                	test   %eax,%eax
8010497e:	75 c0                	jne    80104940 <pipewrite+0x60>
        release(&p->lock);
80104980:	83 ec 0c             	sub    $0xc,%esp
80104983:	53                   	push   %ebx
80104984:	e8 e7 18 00 00       	call   80106270 <release>
        return -1;
80104989:	83 c4 10             	add    $0x10,%esp
8010498c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104994:	5b                   	pop    %ebx
80104995:	5e                   	pop    %esi
80104996:	5f                   	pop    %edi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801049a3:	8d 42 01             	lea    0x1(%edx),%eax
801049a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801049ac:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801049af:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801049b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801049b8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801049bc:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801049c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c3:	39 c1                	cmp    %eax,%ecx
801049c5:	0f 85 50 ff ff ff    	jne    8010491b <pipewrite+0x3b>
801049cb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801049ce:	83 ec 0c             	sub    $0xc,%esp
801049d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801049d7:	50                   	push   %eax
801049d8:	e8 d3 0a 00 00       	call   801054b0 <wakeup>
  release(&p->lock);
801049dd:	89 1c 24             	mov    %ebx,(%esp)
801049e0:	e8 8b 18 00 00       	call   80106270 <release>
  return n;
801049e5:	83 c4 10             	add    $0x10,%esp
801049e8:	89 f8                	mov    %edi,%eax
801049ea:	eb a5                	jmp    80104991 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801049ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049ef:	eb b2                	jmp    801049a3 <pipewrite+0xc3>
801049f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049f8:	00 
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a00 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	56                   	push   %esi
80104a05:	53                   	push   %ebx
80104a06:	83 ec 18             	sub    $0x18,%esp
80104a09:	8b 75 08             	mov    0x8(%ebp),%esi
80104a0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104a0f:	56                   	push   %esi
80104a10:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104a16:	e8 b5 18 00 00       	call   801062d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104a1b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104a21:	83 c4 10             	add    $0x10,%esp
80104a24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104a2a:	74 2f                	je     80104a5b <piperead+0x5b>
80104a2c:	eb 37                	jmp    80104a65 <piperead+0x65>
80104a2e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104a30:	e8 bb 02 00 00       	call   80104cf0 <myproc>
80104a35:	8b 40 24             	mov    0x24(%eax),%eax
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	0f 85 80 00 00 00    	jne    80104ac0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104a40:	83 ec 08             	sub    $0x8,%esp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	e8 a6 09 00 00       	call   801053f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104a4a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104a59:	75 0a                	jne    80104a65 <piperead+0x65>
80104a5b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80104a61:	85 d2                	test   %edx,%edx
80104a63:	75 cb                	jne    80104a30 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a68:	31 db                	xor    %ebx,%ebx
80104a6a:	85 c9                	test   %ecx,%ecx
80104a6c:	7f 26                	jg     80104a94 <piperead+0x94>
80104a6e:	eb 2c                	jmp    80104a9c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104a70:	8d 48 01             	lea    0x1(%eax),%ecx
80104a73:	25 ff 01 00 00       	and    $0x1ff,%eax
80104a78:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104a7e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104a83:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104a86:	83 c3 01             	add    $0x1,%ebx
80104a89:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104a8c:	74 0e                	je     80104a9c <piperead+0x9c>
80104a8e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80104a94:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104a9a:	75 d4                	jne    80104a70 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104a9c:	83 ec 0c             	sub    $0xc,%esp
80104a9f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104aa5:	50                   	push   %eax
80104aa6:	e8 05 0a 00 00       	call   801054b0 <wakeup>
  release(&p->lock);
80104aab:	89 34 24             	mov    %esi,(%esp)
80104aae:	e8 bd 17 00 00       	call   80106270 <release>
  return i;
80104ab3:	83 c4 10             	add    $0x10,%esp
}
80104ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ab9:	89 d8                	mov    %ebx,%eax
80104abb:	5b                   	pop    %ebx
80104abc:	5e                   	pop    %esi
80104abd:	5f                   	pop    %edi
80104abe:	5d                   	pop    %ebp
80104abf:	c3                   	ret
      release(&p->lock);
80104ac0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ac3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104ac8:	56                   	push   %esi
80104ac9:	e8 a2 17 00 00       	call   80106270 <release>
      return -1;
80104ace:	83 c4 10             	add    $0x10,%esp
}
80104ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ad4:	89 d8                	mov    %ebx,%eax
80104ad6:	5b                   	pop    %ebx
80104ad7:	5e                   	pop    %esi
80104ad8:	5f                   	pop    %edi
80104ad9:	5d                   	pop    %ebp
80104ada:	c3                   	ret
80104adb:	66 90                	xchg   %ax,%ax
80104add:	66 90                	xchg   %ax,%ax
80104adf:	90                   	nop

80104ae0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ae4:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
{
80104ae9:	83 ec 20             	sub    $0x20,%esp
  acquire(&ptable.lock);
80104aec:	68 c0 48 11 80       	push   $0x801148c0
80104af1:	e8 da 17 00 00       	call   801062d0 <acquire>
80104af6:	83 c4 10             	add    $0x10,%esp
80104af9:	eb 17                	jmp    80104b12 <allocproc+0x32>
80104afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b00:	81 c3 34 02 00 00    	add    $0x234,%ebx
80104b06:	81 fb f4 d5 11 80    	cmp    $0x8011d5f4,%ebx
80104b0c:	0f 84 c6 00 00 00    	je     80104bd8 <allocproc+0xf8>
    if(p->state == UNUSED)
80104b12:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b15:	85 c0                	test   %eax,%eax
80104b17:	75 e7                	jne    80104b00 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104b19:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->numsystemcalls=0;

  release(&ptable.lock);
80104b1e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104b21:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->numsystemcalls=0;
80104b28:	c7 83 10 02 00 00 00 	movl   $0x0,0x210(%ebx)
80104b2f:	00 00 00 
  p->pid = nextpid++;
80104b32:	89 43 10             	mov    %eax,0x10(%ebx)
80104b35:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104b38:	68 c0 48 11 80       	push   $0x801148c0
  p->pid = nextpid++;
80104b3d:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104b43:	e8 28 17 00 00       	call   80106270 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104b48:	e8 53 ee ff ff       	call   801039a0 <kalloc>
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	89 43 08             	mov    %eax,0x8(%ebx)
80104b53:	85 c0                	test   %eax,%eax
80104b55:	0f 84 96 00 00 00    	je     80104bf1 <allocproc+0x111>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104b5b:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104b61:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104b64:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104b69:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104b6c:	c7 40 14 ff 78 10 80 	movl   $0x801078ff,0x14(%eax)
  p->context = (struct context*)sp;
80104b73:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104b76:	6a 14                	push   $0x14
80104b78:	6a 00                	push   $0x0
80104b7a:	50                   	push   %eax
80104b7b:	e8 50 18 00 00       	call   801063d0 <memset>
  p->context->eip = (uint)forkret;
80104b80:	8b 43 1c             	mov    0x1c(%ebx),%eax

  p->sched_info.sjf.arrival_time = ticks;
  p->sched_info.queue = UNSET;
  p->sched_info.sjf.confidence = 50;
  p->sched_info.sjf.burst_time = 2;
  p->sched_info.sjf.process_size = p->sz;
80104b83:	31 c9                	xor    %ecx,%ecx
  p->start_time = ticks;

  return p;
80104b85:	83 c4 10             	add    $0x10,%esp
  p->sched_info.sjf.process_size = p->sz;
80104b88:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  p->context->eip = (uint)forkret;
80104b8b:	c7 40 10 00 4c 10 80 	movl   $0x80104c00,0x10(%eax)
  p->sched_info.sjf.process_size = p->sz;
80104b92:	8b 13                	mov    (%ebx),%edx
  p->sched_info.queue = UNSET;
80104b94:	c7 83 14 02 00 00 00 	movl   $0x0,0x214(%ebx)
80104b9b:	00 00 00 
  p->sched_info.sjf.arrival_time = ticks;
80104b9e:	a1 00 d6 11 80       	mov    0x8011d600,%eax
  p->sched_info.sjf.process_size = p->sz;
80104ba3:	89 55 f0             	mov    %edx,-0x10(%ebp)
80104ba6:	df 6d f0             	fildll -0x10(%ebp)
  p->sched_info.sjf.arrival_time = ticks;
80104ba9:	89 83 20 02 00 00    	mov    %eax,0x220(%ebx)
  p->start_time = ticks;
80104baf:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
80104bb2:	89 d8                	mov    %ebx,%eax
  p->sched_info.sjf.confidence = 50;
80104bb4:	c7 83 28 02 00 00 32 	movl   $0x32,0x228(%ebx)
80104bbb:	00 00 00 
  p->sched_info.sjf.burst_time = 2;
80104bbe:	c7 83 24 02 00 00 02 	movl   $0x2,0x224(%ebx)
80104bc5:	00 00 00 
  p->sched_info.sjf.process_size = p->sz;
80104bc8:	d9 9b 2c 02 00 00    	fstps  0x22c(%ebx)
}
80104bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd1:	c9                   	leave
80104bd2:	c3                   	ret
80104bd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104bdb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104bdd:	68 c0 48 11 80       	push   $0x801148c0
80104be2:	e8 89 16 00 00       	call   80106270 <release>
  return 0;
80104be7:	83 c4 10             	add    $0x10,%esp
}
80104bea:	89 d8                	mov    %ebx,%eax
80104bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bef:	c9                   	leave
80104bf0:	c3                   	ret
    p->state = UNUSED;
80104bf1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80104bf8:	31 db                	xor    %ebx,%ebx
80104bfa:	eb ee                	jmp    80104bea <allocproc+0x10a>
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c00 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c06:	68 c0 48 11 80       	push   $0x801148c0
80104c0b:	e8 60 16 00 00       	call   80106270 <release>

  if (first) {
80104c10:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104c15:	83 c4 10             	add    $0x10,%esp
80104c18:	85 c0                	test   %eax,%eax
80104c1a:	75 04                	jne    80104c20 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104c1c:	c9                   	leave
80104c1d:	c3                   	ret
80104c1e:	66 90                	xchg   %ax,%ax
    first = 0;
80104c20:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80104c27:	00 00 00 
    iinit(ROOTDEV);
80104c2a:	83 ec 0c             	sub    $0xc,%esp
80104c2d:	6a 01                	push   $0x1
80104c2f:	e8 8c dc ff ff       	call   801028c0 <iinit>
    initlog(ROOTDEV);
80104c34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c3b:	e8 a0 f3 ff ff       	call   80103fe0 <initlog>
}
80104c40:	83 c4 10             	add    $0x10,%esp
80104c43:	c9                   	leave
80104c44:	c3                   	ret
80104c45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c4c:	00 
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

80104c50 <pinit>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104c56:	68 b6 94 10 80       	push   $0x801094b6
80104c5b:	68 c0 48 11 80       	push   $0x801148c0
80104c60:	e8 7b 14 00 00       	call   801060e0 <initlock>
}
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	c9                   	leave
80104c69:	c3                   	ret
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <mycpu>:
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c75:	9c                   	pushf
80104c76:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c77:	f6 c4 02             	test   $0x2,%ah
80104c7a:	75 46                	jne    80104cc2 <mycpu+0x52>
  apicid = lapicid();
80104c7c:	e8 8f ef ff ff       	call   80103c10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104c81:	8b 35 24 43 11 80    	mov    0x80114324,%esi
80104c87:	85 f6                	test   %esi,%esi
80104c89:	7e 2a                	jle    80104cb5 <mycpu+0x45>
80104c8b:	31 d2                	xor    %edx,%edx
80104c8d:	eb 08                	jmp    80104c97 <mycpu+0x27>
80104c8f:	90                   	nop
80104c90:	83 c2 01             	add    $0x1,%edx
80104c93:	39 f2                	cmp    %esi,%edx
80104c95:	74 1e                	je     80104cb5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104c97:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104c9d:	0f b6 99 40 43 11 80 	movzbl -0x7feebcc0(%ecx),%ebx
80104ca4:	39 c3                	cmp    %eax,%ebx
80104ca6:	75 e8                	jne    80104c90 <mycpu+0x20>
}
80104ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104cab:	8d 81 40 43 11 80    	lea    -0x7feebcc0(%ecx),%eax
}
80104cb1:	5b                   	pop    %ebx
80104cb2:	5e                   	pop    %esi
80104cb3:	5d                   	pop    %ebp
80104cb4:	c3                   	ret
  panic("unknown apicid\n");
80104cb5:	83 ec 0c             	sub    $0xc,%esp
80104cb8:	68 bd 94 10 80       	push   $0x801094bd
80104cbd:	e8 8e b7 ff ff       	call   80100450 <panic>
    panic("mycpu called with interrupts enabled\n");
80104cc2:	83 ec 0c             	sub    $0xc,%esp
80104cc5:	68 38 99 10 80       	push   $0x80109938
80104cca:	e8 81 b7 ff ff       	call   80100450 <panic>
80104ccf:	90                   	nop

80104cd0 <cpuid>:
cpuid() {
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104cd6:	e8 95 ff ff ff       	call   80104c70 <mycpu>
}
80104cdb:	c9                   	leave
  return mycpu()-cpus;
80104cdc:	2d 40 43 11 80       	sub    $0x80114340,%eax
80104ce1:	c1 f8 04             	sar    $0x4,%eax
80104ce4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104cea:	c3                   	ret
80104ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104cf0 <myproc>:
myproc(void) {
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104cf7:	e8 84 14 00 00       	call   80106180 <pushcli>
  c = mycpu();
80104cfc:	e8 6f ff ff ff       	call   80104c70 <mycpu>
  p = c->proc;
80104d01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d07:	e8 c4 14 00 00       	call   801061d0 <popcli>
}
80104d0c:	89 d8                	mov    %ebx,%eax
80104d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d11:	c9                   	leave
80104d12:	c3                   	ret
80104d13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d1a:	00 
80104d1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104d20 <roundrobin>:
{
80104d20:	55                   	push   %ebp
      p = ptable.proc;
80104d21:	b9 f4 48 11 80       	mov    $0x801148f4,%ecx
{
80104d26:	89 e5                	mov    %esp,%ebp
80104d28:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p = last_scheduled;
80104d2b:	89 d0                	mov    %edx,%eax
80104d2d:	eb 05                	jmp    80104d34 <roundrobin+0x14>
80104d2f:	90                   	nop
    if (p == last_scheduled)
80104d30:	39 d0                	cmp    %edx,%eax
80104d32:	74 24                	je     80104d58 <roundrobin+0x38>
    p++;
80104d34:	05 34 02 00 00       	add    $0x234,%eax
      p = ptable.proc;
80104d39:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
80104d3e:	0f 43 c1             	cmovae %ecx,%eax
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
80104d41:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104d45:	75 e9                	jne    80104d30 <roundrobin+0x10>
80104d47:	83 b8 14 02 00 00 01 	cmpl   $0x1,0x214(%eax)
80104d4e:	75 e0                	jne    80104d30 <roundrobin+0x10>
}
80104d50:	5d                   	pop    %ebp
80104d51:	c3                   	ret
80104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
80104d58:	31 c0                	xor    %eax,%eax
}
80104d5a:	5d                   	pop    %ebp
80104d5b:	c3                   	ret
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d60 <userinit>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104d67:	e8 74 fd ff ff       	call   80104ae0 <allocproc>
80104d6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104d6e:	a3 f4 d5 11 80       	mov    %eax,0x8011d5f4
  if((p->pgdir = setupkvm()) == 0)
80104d73:	e8 98 41 00 00       	call   80108f10 <setupkvm>
80104d78:	89 43 04             	mov    %eax,0x4(%ebx)
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	0f 84 bd 00 00 00    	je     80104e40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104d83:	83 ec 04             	sub    $0x4,%esp
80104d86:	68 2c 00 00 00       	push   $0x2c
80104d8b:	68 60 c4 10 80       	push   $0x8010c460
80104d90:	50                   	push   %eax
80104d91:	e8 5a 3e 00 00       	call   80108bf0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104d96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104d99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104d9f:	6a 4c                	push   $0x4c
80104da1:	6a 00                	push   $0x0
80104da3:	ff 73 18             	push   0x18(%ebx)
80104da6:	e8 25 16 00 00       	call   801063d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104dab:	8b 43 18             	mov    0x18(%ebx),%eax
80104dae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104db3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104db6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104dbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104dbf:	8b 43 18             	mov    0x18(%ebx),%eax
80104dc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104dc6:	8b 43 18             	mov    0x18(%ebx),%eax
80104dc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104dcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104dd1:	8b 43 18             	mov    0x18(%ebx),%eax
80104dd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104dd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104ddc:	8b 43 18             	mov    0x18(%ebx),%eax
80104ddf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104de6:	8b 43 18             	mov    0x18(%ebx),%eax
80104de9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104df0:	8b 43 18             	mov    0x18(%ebx),%eax
80104df3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104dfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104dfd:	6a 10                	push   $0x10
80104dff:	68 e6 94 10 80       	push   $0x801094e6
80104e04:	50                   	push   %eax
80104e05:	e8 76 17 00 00       	call   80106580 <safestrcpy>
  p->cwd = namei("/");
80104e0a:	c7 04 24 ef 94 10 80 	movl   $0x801094ef,(%esp)
80104e11:	e8 aa e5 ff ff       	call   801033c0 <namei>
80104e16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104e19:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104e20:	e8 ab 14 00 00       	call   801062d0 <acquire>
  p->state = RUNNABLE;
80104e25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104e2c:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104e33:	e8 38 14 00 00       	call   80106270 <release>
}
80104e38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e3b:	83 c4 10             	add    $0x10,%esp
80104e3e:	c9                   	leave
80104e3f:	c3                   	ret
    panic("userinit: out of memory?");
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	68 cd 94 10 80       	push   $0x801094cd
80104e48:	e8 03 b6 ff ff       	call   80100450 <panic>
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <growproc>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
80104e55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104e58:	e8 23 13 00 00       	call   80106180 <pushcli>
  c = mycpu();
80104e5d:	e8 0e fe ff ff       	call   80104c70 <mycpu>
  p = c->proc;
80104e62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e68:	e8 63 13 00 00       	call   801061d0 <popcli>
  sz = curproc->sz;
80104e6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104e6f:	85 f6                	test   %esi,%esi
80104e71:	7f 1d                	jg     80104e90 <growproc+0x40>
  } else if(n < 0){
80104e73:	75 3b                	jne    80104eb0 <growproc+0x60>
  switchuvm(curproc);
80104e75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104e78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104e7a:	53                   	push   %ebx
80104e7b:	e8 60 3c 00 00       	call   80108ae0 <switchuvm>
  return 0;
80104e80:	83 c4 10             	add    $0x10,%esp
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e88:	5b                   	pop    %ebx
80104e89:	5e                   	pop    %esi
80104e8a:	5d                   	pop    %ebp
80104e8b:	c3                   	ret
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104e90:	83 ec 04             	sub    $0x4,%esp
80104e93:	01 c6                	add    %eax,%esi
80104e95:	56                   	push   %esi
80104e96:	50                   	push   %eax
80104e97:	ff 73 04             	push   0x4(%ebx)
80104e9a:	e8 a1 3e 00 00       	call   80108d40 <allocuvm>
80104e9f:	83 c4 10             	add    $0x10,%esp
80104ea2:	85 c0                	test   %eax,%eax
80104ea4:	75 cf                	jne    80104e75 <growproc+0x25>
      return -1;
80104ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eab:	eb d8                	jmp    80104e85 <growproc+0x35>
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104eb0:	83 ec 04             	sub    $0x4,%esp
80104eb3:	01 c6                	add    %eax,%esi
80104eb5:	56                   	push   %esi
80104eb6:	50                   	push   %eax
80104eb7:	ff 73 04             	push   0x4(%ebx)
80104eba:	e8 a1 3f 00 00       	call   80108e60 <deallocuvm>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	75 af                	jne    80104e75 <growproc+0x25>
80104ec6:	eb de                	jmp    80104ea6 <growproc+0x56>
80104ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ecf:	00 

80104ed0 <fork>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
80104ed6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104ed9:	e8 a2 12 00 00       	call   80106180 <pushcli>
  c = mycpu();
80104ede:	e8 8d fd ff ff       	call   80104c70 <mycpu>
  p = c->proc;
80104ee3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ee9:	e8 e2 12 00 00       	call   801061d0 <popcli>
  if((np = allocproc()) == 0){
80104eee:	e8 ed fb ff ff       	call   80104ae0 <allocproc>
80104ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	0f 84 d6 00 00 00    	je     80104fd4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104efe:	83 ec 08             	sub    $0x8,%esp
80104f01:	ff 33                	push   (%ebx)
80104f03:	89 c7                	mov    %eax,%edi
80104f05:	ff 73 04             	push   0x4(%ebx)
80104f08:	e8 f3 40 00 00       	call   80109000 <copyuvm>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	89 47 04             	mov    %eax,0x4(%edi)
80104f13:	85 c0                	test   %eax,%eax
80104f15:	0f 84 9a 00 00 00    	je     80104fb5 <fork+0xe5>
  np->sz = curproc->sz;
80104f1b:	8b 03                	mov    (%ebx),%eax
80104f1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104f20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104f22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104f25:	89 c8                	mov    %ecx,%eax
80104f27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104f2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80104f2f:	8b 73 18             	mov    0x18(%ebx),%esi
80104f32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104f34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104f36:	8b 40 18             	mov    0x18(%eax),%eax
80104f39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104f40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104f44:	85 c0                	test   %eax,%eax
80104f46:	74 13                	je     80104f5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104f48:	83 ec 0c             	sub    $0xc,%esp
80104f4b:	50                   	push   %eax
80104f4c:	e8 af d2 ff ff       	call   80102200 <filedup>
80104f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f54:	83 c4 10             	add    $0x10,%esp
80104f57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104f5b:	83 c6 01             	add    $0x1,%esi
80104f5e:	83 fe 10             	cmp    $0x10,%esi
80104f61:	75 dd                	jne    80104f40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104f63:	83 ec 0c             	sub    $0xc,%esp
80104f66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104f69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104f6c:	e8 3f db ff ff       	call   80102ab0 <idup>
80104f71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104f74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104f77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104f7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80104f7d:	6a 10                	push   $0x10
80104f7f:	53                   	push   %ebx
80104f80:	50                   	push   %eax
80104f81:	e8 fa 15 00 00       	call   80106580 <safestrcpy>
  pid = np->pid;
80104f86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104f89:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104f90:	e8 3b 13 00 00       	call   801062d0 <acquire>
  np->state = RUNNABLE;
80104f95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104f9c:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80104fa3:	e8 c8 12 00 00       	call   80106270 <release>
  return pid;
80104fa8:	83 c4 10             	add    $0x10,%esp
}
80104fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fae:	89 d8                	mov    %ebx,%eax
80104fb0:	5b                   	pop    %ebx
80104fb1:	5e                   	pop    %esi
80104fb2:	5f                   	pop    %edi
80104fb3:	5d                   	pop    %ebp
80104fb4:	c3                   	ret
    kfree(np->kstack);
80104fb5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104fb8:	83 ec 0c             	sub    $0xc,%esp
80104fbb:	ff 73 08             	push   0x8(%ebx)
80104fbe:	e8 1d e8 ff ff       	call   801037e0 <kfree>
    np->kstack = 0;
80104fc3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104fca:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104fcd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104fd4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fd9:	eb d0                	jmp    80104fab <fork+0xdb>
80104fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104fe0 <scheduler>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	56                   	push   %esi
80104fe5:	53                   	push   %ebx
80104fe6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104fe9:	e8 82 fc ff ff       	call   80104c70 <mycpu>
  c->proc = 0;
80104fee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104ff5:	00 00 00 
  struct cpu *c = mycpu();
80104ff8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104ffa:	8d 78 04             	lea    0x4(%eax),%edi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80105000:	fb                   	sti
    acquire(&ptable.lock);
80105001:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105004:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
    acquire(&ptable.lock);
80105009:	68 c0 48 11 80       	push   $0x801148c0
8010500e:	e8 bd 12 00 00       	call   801062d0 <acquire>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010501d:	00 
8010501e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80105020:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80105024:	75 33                	jne    80105059 <scheduler+0x79>
      switchuvm(p);
80105026:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80105029:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010502f:	53                   	push   %ebx
80105030:	e8 ab 3a 00 00       	call   80108ae0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80105035:	58                   	pop    %eax
80105036:	5a                   	pop    %edx
80105037:	ff 73 1c             	push   0x1c(%ebx)
8010503a:	57                   	push   %edi
      p->state = RUNNING;
8010503b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80105042:	e8 94 15 00 00       	call   801065db <swtch>
      switchkvm();
80105047:	e8 84 3a 00 00       	call   80108ad0 <switchkvm>
      c->proc = 0;
8010504c:	83 c4 10             	add    $0x10,%esp
8010504f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80105056:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105059:	81 c3 34 02 00 00    	add    $0x234,%ebx
8010505f:	81 fb f4 d5 11 80    	cmp    $0x8011d5f4,%ebx
80105065:	75 b9                	jne    80105020 <scheduler+0x40>
    release(&ptable.lock);
80105067:	83 ec 0c             	sub    $0xc,%esp
8010506a:	68 c0 48 11 80       	push   $0x801148c0
8010506f:	e8 fc 11 00 00       	call   80106270 <release>
    sti();
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	eb 87                	jmp    80105000 <scheduler+0x20>
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105080 <sched>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  pushcli();
80105085:	e8 f6 10 00 00       	call   80106180 <pushcli>
  c = mycpu();
8010508a:	e8 e1 fb ff ff       	call   80104c70 <mycpu>
  p = c->proc;
8010508f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105095:	e8 36 11 00 00       	call   801061d0 <popcli>
  if(!holding(&ptable.lock))
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	68 c0 48 11 80       	push   $0x801148c0
801050a2:	e8 89 11 00 00       	call   80106230 <holding>
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	85 c0                	test   %eax,%eax
801050ac:	74 4f                	je     801050fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801050ae:	e8 bd fb ff ff       	call   80104c70 <mycpu>
801050b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801050ba:	75 68                	jne    80105124 <sched+0xa4>
  if(p->state == RUNNING)
801050bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801050c0:	74 55                	je     80105117 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050c2:	9c                   	pushf
801050c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801050c4:	f6 c4 02             	test   $0x2,%ah
801050c7:	75 41                	jne    8010510a <sched+0x8a>
  intena = mycpu()->intena;
801050c9:	e8 a2 fb ff ff       	call   80104c70 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801050ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801050d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801050d7:	e8 94 fb ff ff       	call   80104c70 <mycpu>
801050dc:	83 ec 08             	sub    $0x8,%esp
801050df:	ff 70 04             	push   0x4(%eax)
801050e2:	53                   	push   %ebx
801050e3:	e8 f3 14 00 00       	call   801065db <swtch>
  mycpu()->intena = intena;
801050e8:	e8 83 fb ff ff       	call   80104c70 <mycpu>
}
801050ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801050f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801050f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5d                   	pop    %ebp
801050fc:	c3                   	ret
    panic("sched ptable.lock");
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	68 f1 94 10 80       	push   $0x801094f1
80105105:	e8 46 b3 ff ff       	call   80100450 <panic>
    panic("sched interruptible");
8010510a:	83 ec 0c             	sub    $0xc,%esp
8010510d:	68 1d 95 10 80       	push   $0x8010951d
80105112:	e8 39 b3 ff ff       	call   80100450 <panic>
    panic("sched running");
80105117:	83 ec 0c             	sub    $0xc,%esp
8010511a:	68 0f 95 10 80       	push   $0x8010950f
8010511f:	e8 2c b3 ff ff       	call   80100450 <panic>
    panic("sched locks");
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	68 03 95 10 80       	push   $0x80109503
8010512c:	e8 1f b3 ff ff       	call   80100450 <panic>
80105131:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105138:	00 
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105140 <exit>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
80105145:	53                   	push   %ebx
80105146:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105149:	e8 a2 fb ff ff       	call   80104cf0 <myproc>
  if(curproc == initproc)
8010514e:	39 05 f4 d5 11 80    	cmp    %eax,0x8011d5f4
80105154:	0f 84 07 01 00 00    	je     80105261 <exit+0x121>
8010515a:	89 c3                	mov    %eax,%ebx
8010515c:	8d 70 28             	lea    0x28(%eax),%esi
8010515f:	8d 78 68             	lea    0x68(%eax),%edi
80105162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80105168:	8b 06                	mov    (%esi),%eax
8010516a:	85 c0                	test   %eax,%eax
8010516c:	74 12                	je     80105180 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010516e:	83 ec 0c             	sub    $0xc,%esp
80105171:	50                   	push   %eax
80105172:	e8 d9 d0 ff ff       	call   80102250 <fileclose>
      curproc->ofile[fd] = 0;
80105177:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010517d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80105180:	83 c6 04             	add    $0x4,%esi
80105183:	39 f7                	cmp    %esi,%edi
80105185:	75 e1                	jne    80105168 <exit+0x28>
  begin_op();
80105187:	e8 f4 ee ff ff       	call   80104080 <begin_op>
  iput(curproc->cwd);
8010518c:	83 ec 0c             	sub    $0xc,%esp
8010518f:	ff 73 68             	push   0x68(%ebx)
80105192:	e8 79 da ff ff       	call   80102c10 <iput>
  end_op();
80105197:	e8 54 ef ff ff       	call   801040f0 <end_op>
  curproc->cwd = 0;
8010519c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801051a3:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801051aa:	e8 21 11 00 00       	call   801062d0 <acquire>
  wakeup1(curproc->parent);
801051af:	8b 53 14             	mov    0x14(%ebx),%edx
801051b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051b5:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
801051ba:	eb 10                	jmp    801051cc <exit+0x8c>
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051c0:	05 34 02 00 00       	add    $0x234,%eax
801051c5:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
801051ca:	74 1e                	je     801051ea <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
801051cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801051d0:	75 ee                	jne    801051c0 <exit+0x80>
801051d2:	3b 50 20             	cmp    0x20(%eax),%edx
801051d5:	75 e9                	jne    801051c0 <exit+0x80>
      p->state = RUNNABLE;
801051d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051de:	05 34 02 00 00       	add    $0x234,%eax
801051e3:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
801051e8:	75 e2                	jne    801051cc <exit+0x8c>
      p->parent = initproc;
801051ea:	8b 0d f4 d5 11 80    	mov    0x8011d5f4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051f0:	ba f4 48 11 80       	mov    $0x801148f4,%edx
801051f5:	eb 17                	jmp    8010520e <exit+0xce>
801051f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051fe:	00 
801051ff:	90                   	nop
80105200:	81 c2 34 02 00 00    	add    $0x234,%edx
80105206:	81 fa f4 d5 11 80    	cmp    $0x8011d5f4,%edx
8010520c:	74 3a                	je     80105248 <exit+0x108>
    if(p->parent == curproc){
8010520e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105211:	75 ed                	jne    80105200 <exit+0xc0>
      if(p->state == ZOMBIE)
80105213:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105217:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010521a:	75 e4                	jne    80105200 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010521c:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
80105221:	eb 11                	jmp    80105234 <exit+0xf4>
80105223:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105228:	05 34 02 00 00       	add    $0x234,%eax
8010522d:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
80105232:	74 cc                	je     80105200 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80105234:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105238:	75 ee                	jne    80105228 <exit+0xe8>
8010523a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010523d:	75 e9                	jne    80105228 <exit+0xe8>
      p->state = RUNNABLE;
8010523f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105246:	eb e0                	jmp    80105228 <exit+0xe8>
  curproc->state = ZOMBIE;
80105248:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010524f:	e8 2c fe ff ff       	call   80105080 <sched>
  panic("zombie exit");
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	68 3e 95 10 80       	push   $0x8010953e
8010525c:	e8 ef b1 ff ff       	call   80100450 <panic>
    panic("init exiting");
80105261:	83 ec 0c             	sub    $0xc,%esp
80105264:	68 31 95 10 80       	push   $0x80109531
80105269:	e8 e2 b1 ff ff       	call   80100450 <panic>
8010526e:	66 90                	xchg   %ax,%ax

80105270 <wait>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
  pushcli();
80105275:	e8 06 0f 00 00       	call   80106180 <pushcli>
  c = mycpu();
8010527a:	e8 f1 f9 ff ff       	call   80104c70 <mycpu>
  p = c->proc;
8010527f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105285:	e8 46 0f 00 00       	call   801061d0 <popcli>
  acquire(&ptable.lock);
8010528a:	83 ec 0c             	sub    $0xc,%esp
8010528d:	68 c0 48 11 80       	push   $0x801148c0
80105292:	e8 39 10 00 00       	call   801062d0 <acquire>
80105297:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010529a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010529c:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
801052a1:	eb 13                	jmp    801052b6 <wait+0x46>
801052a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801052a8:	81 c3 34 02 00 00    	add    $0x234,%ebx
801052ae:	81 fb f4 d5 11 80    	cmp    $0x8011d5f4,%ebx
801052b4:	74 1e                	je     801052d4 <wait+0x64>
      if(p->parent != curproc)
801052b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801052b9:	75 ed                	jne    801052a8 <wait+0x38>
      if(p->state == ZOMBIE){
801052bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801052bf:	74 5f                	je     80105320 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052c1:	81 c3 34 02 00 00    	add    $0x234,%ebx
      havekids = 1;
801052c7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052cc:	81 fb f4 d5 11 80    	cmp    $0x8011d5f4,%ebx
801052d2:	75 e2                	jne    801052b6 <wait+0x46>
    if(!havekids || curproc->killed){
801052d4:	85 c0                	test   %eax,%eax
801052d6:	0f 84 9a 00 00 00    	je     80105376 <wait+0x106>
801052dc:	8b 46 24             	mov    0x24(%esi),%eax
801052df:	85 c0                	test   %eax,%eax
801052e1:	0f 85 8f 00 00 00    	jne    80105376 <wait+0x106>
  pushcli();
801052e7:	e8 94 0e 00 00       	call   80106180 <pushcli>
  c = mycpu();
801052ec:	e8 7f f9 ff ff       	call   80104c70 <mycpu>
  p = c->proc;
801052f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801052f7:	e8 d4 0e 00 00       	call   801061d0 <popcli>
  if(p == 0)
801052fc:	85 db                	test   %ebx,%ebx
801052fe:	0f 84 89 00 00 00    	je     8010538d <wait+0x11d>
  p->chan = chan;
80105304:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105307:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010530e:	e8 6d fd ff ff       	call   80105080 <sched>
  p->chan = 0;
80105313:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010531a:	e9 7b ff ff ff       	jmp    8010529a <wait+0x2a>
8010531f:	90                   	nop
        kfree(p->kstack);
80105320:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105323:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105326:	ff 73 08             	push   0x8(%ebx)
80105329:	e8 b2 e4 ff ff       	call   801037e0 <kfree>
        p->kstack = 0;
8010532e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105335:	5a                   	pop    %edx
80105336:	ff 73 04             	push   0x4(%ebx)
80105339:	e8 52 3b 00 00       	call   80108e90 <freevm>
        p->pid = 0;
8010533e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105345:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010534c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105350:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105357:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010535e:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80105365:	e8 06 0f 00 00       	call   80106270 <release>
        return pid;
8010536a:	83 c4 10             	add    $0x10,%esp
}
8010536d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105370:	89 f0                	mov    %esi,%eax
80105372:	5b                   	pop    %ebx
80105373:	5e                   	pop    %esi
80105374:	5d                   	pop    %ebp
80105375:	c3                   	ret
      release(&ptable.lock);
80105376:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105379:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010537e:	68 c0 48 11 80       	push   $0x801148c0
80105383:	e8 e8 0e 00 00       	call   80106270 <release>
      return -1;
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	eb e0                	jmp    8010536d <wait+0xfd>
    panic("sleep");
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	68 4a 95 10 80       	push   $0x8010954a
80105395:	e8 b6 b0 ff ff       	call   80100450 <panic>
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053a0 <yield>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801053a7:	68 c0 48 11 80       	push   $0x801148c0
801053ac:	e8 1f 0f 00 00       	call   801062d0 <acquire>
  pushcli();
801053b1:	e8 ca 0d 00 00       	call   80106180 <pushcli>
  c = mycpu();
801053b6:	e8 b5 f8 ff ff       	call   80104c70 <mycpu>
  p = c->proc;
801053bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801053c1:	e8 0a 0e 00 00       	call   801061d0 <popcli>
  myproc()->state = RUNNABLE;
801053c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801053cd:	e8 ae fc ff ff       	call   80105080 <sched>
  release(&ptable.lock);
801053d2:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801053d9:	e8 92 0e 00 00       	call   80106270 <release>
}
801053de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	c9                   	leave
801053e5:	c3                   	ret
801053e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ed:	00 
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <sleep>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
801053f6:	83 ec 0c             	sub    $0xc,%esp
801053f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801053fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801053ff:	e8 7c 0d 00 00       	call   80106180 <pushcli>
  c = mycpu();
80105404:	e8 67 f8 ff ff       	call   80104c70 <mycpu>
  p = c->proc;
80105409:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010540f:	e8 bc 0d 00 00       	call   801061d0 <popcli>
  if(p == 0)
80105414:	85 db                	test   %ebx,%ebx
80105416:	0f 84 87 00 00 00    	je     801054a3 <sleep+0xb3>
  if(lk == 0)
8010541c:	85 f6                	test   %esi,%esi
8010541e:	74 76                	je     80105496 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105420:	81 fe c0 48 11 80    	cmp    $0x801148c0,%esi
80105426:	74 50                	je     80105478 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	68 c0 48 11 80       	push   $0x801148c0
80105430:	e8 9b 0e 00 00       	call   801062d0 <acquire>
    release(lk);
80105435:	89 34 24             	mov    %esi,(%esp)
80105438:	e8 33 0e 00 00       	call   80106270 <release>
  p->chan = chan;
8010543d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105440:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105447:	e8 34 fc ff ff       	call   80105080 <sched>
  p->chan = 0;
8010544c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105453:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
8010545a:	e8 11 0e 00 00       	call   80106270 <release>
    acquire(lk);
8010545f:	89 75 08             	mov    %esi,0x8(%ebp)
80105462:	83 c4 10             	add    $0x10,%esp
}
80105465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105468:	5b                   	pop    %ebx
80105469:	5e                   	pop    %esi
8010546a:	5f                   	pop    %edi
8010546b:	5d                   	pop    %ebp
    acquire(lk);
8010546c:	e9 5f 0e 00 00       	jmp    801062d0 <acquire>
80105471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105478:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010547b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105482:	e8 f9 fb ff ff       	call   80105080 <sched>
  p->chan = 0;
80105487:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010548e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105491:	5b                   	pop    %ebx
80105492:	5e                   	pop    %esi
80105493:	5f                   	pop    %edi
80105494:	5d                   	pop    %ebp
80105495:	c3                   	ret
    panic("sleep without lk");
80105496:	83 ec 0c             	sub    $0xc,%esp
80105499:	68 50 95 10 80       	push   $0x80109550
8010549e:	e8 ad af ff ff       	call   80100450 <panic>
    panic("sleep");
801054a3:	83 ec 0c             	sub    $0xc,%esp
801054a6:	68 4a 95 10 80       	push   $0x8010954a
801054ab:	e8 a0 af ff ff       	call   80100450 <panic>

801054b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 10             	sub    $0x10,%esp
801054b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801054ba:	68 c0 48 11 80       	push   $0x801148c0
801054bf:	e8 0c 0e 00 00       	call   801062d0 <acquire>
801054c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801054c7:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
801054cc:	eb 0e                	jmp    801054dc <wakeup+0x2c>
801054ce:	66 90                	xchg   %ax,%ax
801054d0:	05 34 02 00 00       	add    $0x234,%eax
801054d5:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
801054da:	74 1e                	je     801054fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801054dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801054e0:	75 ee                	jne    801054d0 <wakeup+0x20>
801054e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801054e5:	75 e9                	jne    801054d0 <wakeup+0x20>
      p->state = RUNNABLE;
801054e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801054ee:	05 34 02 00 00       	add    $0x234,%eax
801054f3:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
801054f8:	75 e2                	jne    801054dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801054fa:	c7 45 08 c0 48 11 80 	movl   $0x801148c0,0x8(%ebp)
}
80105501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105504:	c9                   	leave
  release(&ptable.lock);
80105505:	e9 66 0d 00 00       	jmp    80106270 <release>
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105510 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	53                   	push   %ebx
80105514:	83 ec 10             	sub    $0x10,%esp
80105517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010551a:	68 c0 48 11 80       	push   $0x801148c0
8010551f:	e8 ac 0d 00 00       	call   801062d0 <acquire>
80105524:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105527:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
8010552c:	eb 0e                	jmp    8010553c <kill+0x2c>
8010552e:	66 90                	xchg   %ax,%ax
80105530:	05 34 02 00 00       	add    $0x234,%eax
80105535:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
8010553a:	74 34                	je     80105570 <kill+0x60>
    if(p->pid == pid){
8010553c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010553f:	75 ef                	jne    80105530 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105541:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105545:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010554c:	75 07                	jne    80105555 <kill+0x45>
        p->state = RUNNABLE;
8010554e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105555:	83 ec 0c             	sub    $0xc,%esp
80105558:	68 c0 48 11 80       	push   $0x801148c0
8010555d:	e8 0e 0d 00 00       	call   80106270 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80105562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105565:	83 c4 10             	add    $0x10,%esp
80105568:	31 c0                	xor    %eax,%eax
}
8010556a:	c9                   	leave
8010556b:	c3                   	ret
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	68 c0 48 11 80       	push   $0x801148c0
80105578:	e8 f3 0c 00 00       	call   80106270 <release>
}
8010557d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105588:	c9                   	leave
80105589:	c3                   	ret
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105590 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
80105595:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105598:	53                   	push   %ebx
80105599:	bb 60 49 11 80       	mov    $0x80114960,%ebx
8010559e:	83 ec 3c             	sub    $0x3c,%esp
801055a1:	eb 27                	jmp    801055ca <procdump+0x3a>
801055a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	68 aa 95 10 80       	push   $0x801095aa
801055b0:	e8 2b b2 ff ff       	call   801007e0 <cprintf>
801055b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801055b8:	81 c3 34 02 00 00    	add    $0x234,%ebx
801055be:	81 fb 60 d6 11 80    	cmp    $0x8011d660,%ebx
801055c4:	0f 84 7e 00 00 00    	je     80105648 <procdump+0xb8>
    if(p->state == UNUSED)
801055ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801055cd:	85 c0                	test   %eax,%eax
801055cf:	74 e7                	je     801055b8 <procdump+0x28>
      state = "???";
801055d1:	ba 61 95 10 80       	mov    $0x80109561,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801055d6:	83 f8 05             	cmp    $0x5,%eax
801055d9:	77 11                	ja     801055ec <procdump+0x5c>
801055db:	8b 14 85 38 9e 10 80 	mov    -0x7fef61c8(,%eax,4),%edx
      state = "???";
801055e2:	b8 61 95 10 80       	mov    $0x80109561,%eax
801055e7:	85 d2                	test   %edx,%edx
801055e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801055ec:	53                   	push   %ebx
801055ed:	52                   	push   %edx
801055ee:	ff 73 a4             	push   -0x5c(%ebx)
801055f1:	68 65 95 10 80       	push   $0x80109565
801055f6:	e8 e5 b1 ff ff       	call   801007e0 <cprintf>
    if(p->state == SLEEPING){
801055fb:	83 c4 10             	add    $0x10,%esp
801055fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105602:	75 a4                	jne    801055a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010560a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010560d:	50                   	push   %eax
8010560e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105611:	8b 40 0c             	mov    0xc(%eax),%eax
80105614:	83 c0 08             	add    $0x8,%eax
80105617:	50                   	push   %eax
80105618:	e8 e3 0a 00 00       	call   80106100 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	8b 17                	mov    (%edi),%edx
80105622:	85 d2                	test   %edx,%edx
80105624:	74 82                	je     801055a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105626:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105629:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010562c:	52                   	push   %edx
8010562d:	68 a1 92 10 80       	push   $0x801092a1
80105632:	e8 a9 b1 ff ff       	call   801007e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105637:	83 c4 10             	add    $0x10,%esp
8010563a:	39 f7                	cmp    %esi,%edi
8010563c:	75 e2                	jne    80105620 <procdump+0x90>
8010563e:	e9 65 ff ff ff       	jmp    801055a8 <procdump+0x18>
80105643:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80105648:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010564b:	5b                   	pop    %ebx
8010564c:	5e                   	pop    %esi
8010564d:	5f                   	pop    %edi
8010564e:	5d                   	pop    %ebp
8010564f:	c3                   	ret

80105650 <sort_uniqe_procces>:

int sort_uniqe_procces(int pid)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
  struct proc *p;
  int i, j;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105655:	be f4 48 11 80       	mov    $0x801148f4,%esi
{
8010565a:	53                   	push   %ebx
8010565b:	83 ec 1c             	sub    $0x1c,%esp
8010565e:	8b 45 08             	mov    0x8(%ebp),%eax
80105661:	eb 17                	jmp    8010567a <sort_uniqe_procces+0x2a>
80105663:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105668:	81 c6 34 02 00 00    	add    $0x234,%esi
8010566e:	81 fe f4 d5 11 80    	cmp    $0x8011d5f4,%esi
80105674:	0f 84 aa 00 00 00    	je     80105724 <sort_uniqe_procces+0xd4>
  {
    if (p->pid == pid)
8010567a:	39 46 10             	cmp    %eax,0x10(%esi)
8010567d:	75 e9                	jne    80105668 <sort_uniqe_procces+0x18>
    {
   
      for (i = 0; i < p->numsystemcalls - 1; i++)
8010567f:	8b 86 10 02 00 00    	mov    0x210(%esi),%eax
80105685:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105688:	83 f8 01             	cmp    $0x1,%eax
8010568b:	0f 8e a0 00 00 00    	jle    80105731 <sort_uniqe_procces+0xe1>
80105691:	8d 50 ff             	lea    -0x1(%eax),%edx
80105694:	89 75 dc             	mov    %esi,-0x24(%ebp)
80105697:	8d 9e 84 00 00 00    	lea    0x84(%esi),%ebx
8010569d:	31 c9                	xor    %ecx,%ecx
8010569f:	8d bc 86 80 00 00 00 	lea    0x80(%esi,%eax,4),%edi
801056a6:	89 d6                	mov    %edx,%esi
801056a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056af:	00 
      {
        for (j = i + 1; j < p->numsystemcalls; j++)
801056b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056b3:	83 c1 01             	add    $0x1,%ecx
801056b6:	39 c1                	cmp    %eax,%ecx
801056b8:	7d 1e                	jge    801056d8 <sort_uniqe_procces+0x88>
801056ba:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801056bd:	89 d8                	mov    %ebx,%eax
801056bf:	90                   	nop
        {
          if (p->systemcalls[i] > p->systemcalls[j])
801056c0:	8b 53 fc             	mov    -0x4(%ebx),%edx
801056c3:	8b 08                	mov    (%eax),%ecx
801056c5:	39 ca                	cmp    %ecx,%edx
801056c7:	7e 05                	jle    801056ce <sort_uniqe_procces+0x7e>
          {
            
            int temp = p->systemcalls[i];
            p->systemcalls[i] = p->systemcalls[j];
801056c9:	89 4b fc             	mov    %ecx,-0x4(%ebx)
            p->systemcalls[j] = temp;
801056cc:	89 10                	mov    %edx,(%eax)
        for (j = i + 1; j < p->numsystemcalls; j++)
801056ce:	83 c0 04             	add    $0x4,%eax
801056d1:	39 f8                	cmp    %edi,%eax
801056d3:	75 eb                	jne    801056c0 <sort_uniqe_procces+0x70>
801056d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      for (i = 0; i < p->numsystemcalls - 1; i++)
801056d8:	83 c3 04             	add    $0x4,%ebx
801056db:	39 f1                	cmp    %esi,%ecx
801056dd:	75 d1                	jne    801056b0 <sort_uniqe_procces+0x60>
801056df:	8b 75 dc             	mov    -0x24(%ebp),%esi
          }
        }
      }
      for (i = 0; i < p->numsystemcalls; i++)
801056e2:	31 db                	xor    %ebx,%ebx
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      { 
        cprintf("%d ", p->systemcalls[i]);
801056e8:	83 ec 08             	sub    $0x8,%esp
801056eb:	ff b4 9e 80 00 00 00 	push   0x80(%esi,%ebx,4)
      for (i = 0; i < p->numsystemcalls; i++)
801056f2:	83 c3 01             	add    $0x1,%ebx
        cprintf("%d ", p->systemcalls[i]);
801056f5:	68 6e 95 10 80       	push   $0x8010956e
801056fa:	e8 e1 b0 ff ff       	call   801007e0 <cprintf>
      for (i = 0; i < p->numsystemcalls; i++)
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	39 9e 10 02 00 00    	cmp    %ebx,0x210(%esi)
80105708:	7f de                	jg     801056e8 <sort_uniqe_procces+0x98>
      }
      cprintf("\n");
8010570a:	83 ec 0c             	sub    $0xc,%esp
8010570d:	68 aa 95 10 80       	push   $0x801095aa
80105712:	e8 c9 b0 ff ff       	call   801007e0 <cprintf>

      return 0; 
80105717:	83 c4 10             	add    $0x10,%esp
    }
  }
  return -1;
}
8010571a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0; 
8010571d:	31 c0                	xor    %eax,%eax
}
8010571f:	5b                   	pop    %ebx
80105720:	5e                   	pop    %esi
80105721:	5f                   	pop    %edi
80105722:	5d                   	pop    %ebp
80105723:	c3                   	ret
80105724:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572c:	5b                   	pop    %ebx
8010572d:	5e                   	pop    %esi
8010572e:	5f                   	pop    %edi
8010572f:	5d                   	pop    %ebp
80105730:	c3                   	ret
      for (i = 0; i < p->numsystemcalls; i++)
80105731:	74 af                	je     801056e2 <sort_uniqe_procces+0x92>
80105733:	eb d5                	jmp    8010570a <sort_uniqe_procces+0xba>
80105735:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010573c:	00 
8010573d:	8d 76 00             	lea    0x0(%esi),%esi

80105740 <get_max_invoked>:
int get_max_invoked(int pid)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
  struct proc *p;
  int i, j;
  struct proc* target_p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105745:	be f4 48 11 80       	mov    $0x801148f4,%esi
{
8010574a:	53                   	push   %ebx
8010574b:	81 ec cc 04 00 00    	sub    $0x4cc,%esp
80105751:	8b 45 08             	mov    0x8(%ebp),%eax
80105754:	eb 1c                	jmp    80105772 <get_max_invoked+0x32>
80105756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010575d:	00 
8010575e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105760:	81 c6 34 02 00 00    	add    $0x234,%esi
80105766:	81 fe f4 d5 11 80    	cmp    $0x8011d5f4,%esi
8010576c:	0f 84 3b 01 00 00    	je     801058ad <get_max_invoked+0x16d>
  {
    if (p->pid == pid)
80105772:	39 46 10             	cmp    %eax,0x10(%esi)
80105775:	75 e9                	jne    80105760 <get_max_invoked+0x20>
    {
      target_p=p;
   
      for (i = 0; i < p->numsystemcalls - 1; i++)
80105777:	8b 86 10 02 00 00    	mov    0x210(%esi),%eax
8010577d:	89 85 30 fb ff ff    	mov    %eax,-0x4d0(%ebp)
80105783:	83 f8 01             	cmp    $0x1,%eax
80105786:	7e 60                	jle    801057e8 <get_max_invoked+0xa8>
80105788:	8d 50 ff             	lea    -0x1(%eax),%edx
8010578b:	89 b5 2c fb ff ff    	mov    %esi,-0x4d4(%ebp)
80105791:	8d 9e 84 00 00 00    	lea    0x84(%esi),%ebx
80105797:	31 c9                	xor    %ecx,%ecx
80105799:	8d bc 86 80 00 00 00 	lea    0x80(%esi,%eax,4),%edi
801057a0:	89 d6                	mov    %edx,%esi
801057a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      {
        for (j = i + 1; j < p->numsystemcalls; j++)
801057a8:	8b 85 30 fb ff ff    	mov    -0x4d0(%ebp),%eax
801057ae:	83 c1 01             	add    $0x1,%ecx
801057b1:	39 c1                	cmp    %eax,%ecx
801057b3:	7d 26                	jge    801057db <get_max_invoked+0x9b>
801057b5:	89 8d 34 fb ff ff    	mov    %ecx,-0x4cc(%ebp)
801057bb:	89 d8                	mov    %ebx,%eax
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
        {
          if (p->systemcalls[i] > p->systemcalls[j])
801057c0:	8b 53 fc             	mov    -0x4(%ebx),%edx
801057c3:	8b 08                	mov    (%eax),%ecx
801057c5:	39 ca                	cmp    %ecx,%edx
801057c7:	7e 05                	jle    801057ce <get_max_invoked+0x8e>
          {
            
            int temp = p->systemcalls[i];
            p->systemcalls[i] = p->systemcalls[j];
801057c9:	89 4b fc             	mov    %ecx,-0x4(%ebx)
            p->systemcalls[j] = temp;
801057cc:	89 10                	mov    %edx,(%eax)
        for (j = i + 1; j < p->numsystemcalls; j++)
801057ce:	83 c0 04             	add    $0x4,%eax
801057d1:	39 f8                	cmp    %edi,%eax
801057d3:	75 eb                	jne    801057c0 <get_max_invoked+0x80>
801057d5:	8b 8d 34 fb ff ff    	mov    -0x4cc(%ebp),%ecx
      for (i = 0; i < p->numsystemcalls - 1; i++)
801057db:	83 c3 04             	add    $0x4,%ebx
801057de:	39 f1                	cmp    %esi,%ecx
801057e0:	75 c6                	jne    801057a8 <get_max_invoked+0x68>
801057e2:	8b b5 2c fb ff ff    	mov    -0x4d4(%ebp),%esi
          }
        }
      }
     int count[300];
     memset(count,0,300);
801057e8:	83 ec 04             	sub    $0x4,%esp
801057eb:	8d 9d 38 fb ff ff    	lea    -0x4c8(%ebp),%ebx
801057f1:	68 2c 01 00 00       	push   $0x12c
801057f6:	6a 00                	push   $0x0
801057f8:	53                   	push   %ebx
801057f9:	e8 d2 0b 00 00       	call   801063d0 <memset>
     for(int i=0;i<300;i++){
801057fe:	89 da                	mov    %ebx,%edx
80105800:	8d 4d e8             	lea    -0x18(%ebp),%ecx
80105803:	83 c4 10             	add    $0x10,%esp
     memset(count,0,300);
80105806:	89 d8                	mov    %ebx,%eax
80105808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010580f:	00 
      count[i]=0;
80105810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     for(int i=0;i<300;i++){
80105816:	83 c0 08             	add    $0x8,%eax
      count[i]=0;
80105819:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
     for(int i=0;i<300;i++){
80105820:	39 c8                	cmp    %ecx,%eax
80105822:	75 ec                	jne    80105810 <get_max_invoked+0xd0>
     // cprintf("%d \n",count[i]);
      
     }
     
     for (int i=0;i<target_p->numsystemcalls;i++){
80105824:	8b 86 10 02 00 00    	mov    0x210(%esi),%eax
8010582a:	85 c0                	test   %eax,%eax
8010582c:	7e 1b                	jle    80105849 <get_max_invoked+0x109>
8010582e:	83 ee 80             	sub    $0xffffff80,%esi
80105831:	8d 0c 86             	lea    (%esi,%eax,4),%ecx
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count[target_p->systemcalls[i]]++;
80105838:	8b 06                	mov    (%esi),%eax
     for (int i=0;i<target_p->numsystemcalls;i++){
8010583a:	83 c6 04             	add    $0x4,%esi
      count[target_p->systemcalls[i]]++;
8010583d:	83 84 85 38 fb ff ff 	addl   $0x1,-0x4c8(%ebp,%eax,4)
80105844:	01 
     for (int i=0;i<target_p->numsystemcalls;i++){
80105845:	39 ce                	cmp    %ecx,%esi
80105847:	75 ef                	jne    80105838 <get_max_invoked+0xf8>
     }
     int max=-1;
     int max_index=-1;

     for(int i=0;i<30;i++){
80105849:	8d 73 78             	lea    0x78(%ebx),%esi
     int max=-1;
8010584c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     if(count[i]>=max && count[i]!=0){
80105858:	8b 02                	mov    (%edx),%eax
8010585a:	39 c8                	cmp    %ecx,%eax
8010585c:	7c 05                	jl     80105863 <get_max_invoked+0x123>
      max=count[i];
8010585e:	85 c0                	test   %eax,%eax
80105860:	0f 45 c8             	cmovne %eax,%ecx
     for(int i=0;i<30;i++){
80105863:	83 c2 04             	add    $0x4,%edx
80105866:	39 d6                	cmp    %edx,%esi
80105868:	75 ee                	jne    80105858 <get_max_invoked+0x118>
     }
     if(max==-1){
      cprintf("no syscall found \n");
      return -1;
     }
        for(int i=0;i<30;i++){
8010586a:	31 f6                	xor    %esi,%esi
     if(max==-1){
8010586c:	83 f9 ff             	cmp    $0xffffffff,%ecx
8010586f:	75 0f                	jne    80105880 <get_max_invoked+0x140>
80105871:	eb 59                	jmp    801058cc <get_max_invoked+0x18c>
80105873:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        for(int i=0;i<30;i++){
80105878:	83 c6 01             	add    $0x1,%esi
8010587b:	83 fe 1e             	cmp    $0x1e,%esi
8010587e:	74 21                	je     801058a1 <get_max_invoked+0x161>
     if(count[i]==max){
80105880:	39 0c b3             	cmp    %ecx,(%ebx,%esi,4)
80105883:	75 f3                	jne    80105878 <get_max_invoked+0x138>
       cprintf("num of the system call is %d and it invoked is %d \n",i,count[i]);
80105885:	83 ec 04             	sub    $0x4,%esp
80105888:	51                   	push   %ecx
80105889:	56                   	push   %esi
8010588a:	68 60 99 10 80       	push   $0x80109960
8010588f:	e8 4c af ff ff       	call   801007e0 <cprintf>
       return  i;
80105894:	83 c4 10             	add    $0x10,%esp
      return 0; 
    }
  }
  cprintf("Pid not found \n");
  return -1;
}
80105897:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010589a:	89 f0                	mov    %esi,%eax
8010589c:	5b                   	pop    %ebx
8010589d:	5e                   	pop    %esi
8010589e:	5f                   	pop    %edi
8010589f:	5d                   	pop    %ebp
801058a0:	c3                   	ret
801058a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0; 
801058a4:	31 f6                	xor    %esi,%esi
}
801058a6:	5b                   	pop    %ebx
801058a7:	89 f0                	mov    %esi,%eax
801058a9:	5e                   	pop    %esi
801058aa:	5f                   	pop    %edi
801058ab:	5d                   	pop    %ebp
801058ac:	c3                   	ret
  cprintf("Pid not found \n");
801058ad:	83 ec 0c             	sub    $0xc,%esp
  return -1;
801058b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
  cprintf("Pid not found \n");
801058b5:	68 85 95 10 80       	push   $0x80109585
801058ba:	e8 21 af ff ff       	call   801007e0 <cprintf>
  return -1;
801058bf:	83 c4 10             	add    $0x10,%esp
}
801058c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c5:	89 f0                	mov    %esi,%eax
801058c7:	5b                   	pop    %ebx
801058c8:	5e                   	pop    %esi
801058c9:	5f                   	pop    %edi
801058ca:	5d                   	pop    %ebp
801058cb:	c3                   	ret
      cprintf("no syscall found \n");
801058cc:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801058cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
      cprintf("no syscall found \n");
801058d4:	68 72 95 10 80       	push   $0x80109572
801058d9:	e8 02 af ff ff       	call   801007e0 <cprintf>
      return -1;
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	eb b4                	jmp    80105897 <get_max_invoked+0x157>
801058e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ea:	00 
801058eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801058f0 <make_create_palindrom>:


int make_create_palindrom(long long int x)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
801058f5:	53                   	push   %ebx
801058f6:	83 ec 30             	sub    $0x30,%esp
801058f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801058fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801058ff:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80105902:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  cprintf("Input number is : %d \n" , x);
80105905:	56                   	push   %esi
80105906:	53                   	push   %ebx
80105907:	68 95 95 10 80       	push   $0x80109595
8010590c:	e8 cf ae ff ff       	call   801007e0 <cprintf>
  long long int num = x;
  long long int comp = 0;
  while (x != 0)
80105911:	89 d8                	mov    %ebx,%eax
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	09 f0                	or     %esi,%eax
80105918:	0f 84 33 01 00 00    	je     80105a51 <make_create_palindrom+0x161>
  long long int num = x;
8010591e:	89 75 dc             	mov    %esi,-0x24(%ebp)
  long long int comp = 0;
80105921:	31 c9                	xor    %ecx,%ecx
  long long int num = x;
80105923:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  long long int comp = 0;
80105926:	31 db                	xor    %ebx,%ebx
80105928:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010592f:	00 
  {
    comp = comp * 10 + x % 10;
80105930:	89 c8                	mov    %ecx,%eax
80105932:	89 da                	mov    %ebx,%edx
80105934:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80105937:	c1 e0 02             	shl    $0x2,%eax
8010593a:	0f a4 ca 02          	shld   $0x2,%ecx,%edx
8010593e:	01 c1                	add    %eax,%ecx
80105940:	89 f7                	mov    %esi,%edi
80105942:	89 f0                	mov    %esi,%eax
80105944:	11 d3                	adc    %edx,%ebx
80105946:	c1 f8 1f             	sar    $0x1f,%eax
80105949:	0f a4 cb 01          	shld   $0x1,%ecx,%ebx
8010594d:	01 c9                	add    %ecx,%ecx
8010594f:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80105952:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105955:	89 4d c8             	mov    %ecx,-0x38(%ebp)
80105958:	89 c1                	mov    %eax,%ecx
8010595a:	83 e0 03             	and    $0x3,%eax
8010595d:	89 de                	mov    %ebx,%esi
8010595f:	89 da                	mov    %ebx,%edx
80105961:	83 e1 fc             	and    $0xfffffffc,%ecx
80105964:	bb cd cc cc cc       	mov    $0xcccccccd,%ebx
80105969:	0f ac fe 1c          	shrd   $0x1c,%edi,%esi
8010596d:	81 e2 ff ff ff 0f    	and    $0xfffffff,%edx
80105973:	81 e6 ff ff ff 0f    	and    $0xfffffff,%esi
80105979:	01 d6                	add    %edx,%esi
8010597b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010597e:	c1 ea 18             	shr    $0x18,%edx
80105981:	01 d6                	add    %edx,%esi
80105983:	01 c6                	add    %eax,%esi
80105985:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
8010598a:	f7 e6                	mul    %esi
8010598c:	89 d0                	mov    %edx,%eax
8010598e:	83 e2 fc             	and    $0xfffffffc,%edx
80105991:	c1 e8 02             	shr    $0x2,%eax
80105994:	01 c2                	add    %eax,%edx
80105996:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105999:	29 d6                	sub    %edx,%esi
8010599b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010599e:	01 ce                	add    %ecx,%esi
801059a0:	89 f7                	mov    %esi,%edi
801059a2:	89 75 d0             	mov    %esi,-0x30(%ebp)
801059a5:	c1 ff 1f             	sar    $0x1f,%edi
801059a8:	29 f0                	sub    %esi,%eax
801059aa:	19 fa                	sbb    %edi,%edx
801059ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
801059af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801059b5:	69 55 e0 cc cc cc cc 	imul   $0xcccccccc,-0x20(%ebp),%edx
801059bc:	69 4d e4 cd cc cc cc 	imul   $0xcccccccd,-0x1c(%ebp),%ecx
801059c3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
801059c6:	8d 34 11             	lea    (%ecx,%edx,1),%esi
801059c9:	f7 e3                	mul    %ebx
801059cb:	89 d3                	mov    %edx,%ebx
801059cd:	89 c1                	mov    %eax,%ecx
801059cf:	01 f3                	add    %esi,%ebx
801059d1:	89 df                	mov    %ebx,%edi
801059d3:	c1 ff 1f             	sar    $0x1f,%edi
801059d6:	31 f8                	xor    %edi,%eax
801059d8:	29 f8                	sub    %edi,%eax
801059da:	31 d2                	xor    %edx,%edx
801059dc:	83 e0 01             	and    $0x1,%eax
801059df:	31 fa                	xor    %edi,%edx
801059e1:	31 f8                	xor    %edi,%eax
801059e3:	29 f8                	sub    %edi,%eax
801059e5:	19 fa                	sbb    %edi,%edx
801059e7:	bf 05 00 00 00       	mov    $0x5,%edi
801059ec:	8d 34 92             	lea    (%edx,%edx,4),%esi
801059ef:	f7 e7                	mul    %edi
801059f1:	89 df                	mov    %ebx,%edi
801059f3:	01 f2                	add    %esi,%edx
801059f5:	89 fe                	mov    %edi,%esi
801059f7:	03 45 d0             	add    -0x30(%ebp),%eax
801059fa:	13 55 d4             	adc    -0x2c(%ebp),%edx
801059fd:	c1 ee 1f             	shr    $0x1f,%esi
80105a00:	31 ff                	xor    %edi,%edi
80105a02:	01 ce                	add    %ecx,%esi
80105a04:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80105a07:	11 df                	adc    %ebx,%edi
80105a09:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80105a0c:	01 c1                	add    %eax,%ecx
    x = x / 10;
    num = num * 10;
80105a0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    comp = comp * 10 + x % 10;
80105a11:	11 d3                	adc    %edx,%ebx
    num = num * 10;
80105a13:	8b 55 dc             	mov    -0x24(%ebp),%edx
    x = x / 10;
80105a16:	0f ac fe 01          	shrd   $0x1,%edi,%esi
80105a1a:	d1 ff                	sar    $1,%edi
80105a1c:	89 75 e0             	mov    %esi,-0x20(%ebp)
    num = num * 10;
80105a1f:	0f a4 c2 02          	shld   $0x2,%eax,%edx
80105a23:	c1 e0 02             	shl    $0x2,%eax
80105a26:	03 45 d8             	add    -0x28(%ebp),%eax
80105a29:	13 55 dc             	adc    -0x24(%ebp),%edx
80105a2c:	0f a4 c2 01          	shld   $0x1,%eax,%edx
80105a30:	01 c0                	add    %eax,%eax
    x = x / 10;
80105a32:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    num = num * 10;
80105a35:	89 45 d8             	mov    %eax,-0x28(%ebp)
  while (x != 0)
80105a38:	89 f0                	mov    %esi,%eax
80105a3a:	09 f8                	or     %edi,%eax
    num = num * 10;
80105a3c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  while (x != 0)
80105a3f:	0f 85 eb fe ff ff    	jne    80105930 <make_create_palindrom+0x40>
  }
  num = num + comp;
80105a45:	03 4d d8             	add    -0x28(%ebp),%ecx
80105a48:	13 5d dc             	adc    -0x24(%ebp),%ebx
80105a4b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105a4e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  cprintf("palindrom value for given input is : %d \n", num);
80105a51:	83 ec 04             	sub    $0x4,%esp
80105a54:	ff 75 e4             	push   -0x1c(%ebp)
80105a57:	ff 75 e0             	push   -0x20(%ebp)
80105a5a:	68 94 99 10 80       	push   $0x80109994
80105a5f:	e8 7c ad ff ff       	call   801007e0 <cprintf>
  return 0;
} 
80105a64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a67:	31 c0                	xor    %eax,%eax
80105a69:	5b                   	pop    %ebx
80105a6a:	5e                   	pop    %esi
80105a6b:	5f                   	pop    %edi
80105a6c:	5d                   	pop    %ebp
80105a6d:	c3                   	ret
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <num_digits>:

int num_digits(int n) {
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	56                   	push   %esi
80105a74:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a77:	53                   	push   %ebx
  int num = 0;
80105a78:	31 db                	xor    %ebx,%ebx
  while(n!= 0) {
80105a7a:	85 c9                	test   %ecx,%ecx
80105a7c:	74 1f                	je     80105a9d <num_digits+0x2d>
    n/=10;
80105a7e:	be 67 66 66 66       	mov    $0x66666667,%esi
80105a83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a88:	89 c8                	mov    %ecx,%eax
    num += 1;
80105a8a:	83 c3 01             	add    $0x1,%ebx
    n/=10;
80105a8d:	f7 ee                	imul   %esi
80105a8f:	89 c8                	mov    %ecx,%eax
80105a91:	c1 f8 1f             	sar    $0x1f,%eax
80105a94:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105a97:	89 d1                	mov    %edx,%ecx
80105a99:	29 c1                	sub    %eax,%ecx
80105a9b:	75 eb                	jne    80105a88 <num_digits+0x18>
  }
  return num;
}
80105a9d:	89 d8                	mov    %ebx,%eax
80105a9f:	5b                   	pop    %ebx
80105aa0:	5e                   	pop    %esi
80105aa1:	5d                   	pop    %ebp
80105aa2:	c3                   	ret
80105aa3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aaa:	00 
80105aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105ab0 <space>:

void space(int count)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  for(int i = 0; i < count; ++i)
80105ab8:	85 f6                	test   %esi,%esi
80105aba:	7e 1b                	jle    80105ad7 <space+0x27>
80105abc:	31 db                	xor    %ebx,%ebx
80105abe:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105ac0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105ac3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80105ac6:	68 26 96 10 80       	push   $0x80109626
80105acb:	e8 10 ad ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105ad0:	83 c4 10             	add    $0x10,%esp
80105ad3:	39 de                	cmp    %ebx,%esi
80105ad5:	75 e9                	jne    80105ac0 <space+0x10>
}
80105ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ada:	5b                   	pop    %ebx
80105adb:	5e                   	pop    %esi
80105adc:	5d                   	pop    %ebp
80105add:	c3                   	ret
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <list_all_processes_>:

int list_all_processes_(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
  struct proc *p;
  int i, j;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105ae5:	bb f4 48 11 80       	mov    $0x801148f4,%ebx
80105aea:	eb 12                	jmp    80105afe <list_all_processes_+0x1e>
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105af0:	81 c3 34 02 00 00    	add    $0x234,%ebx
80105af6:	81 fb f4 d5 11 80    	cmp    $0x8011d5f4,%ebx
80105afc:	74 72                	je     80105b70 <list_all_processes_+0x90>
  {
    if (p->pid != 0)
80105afe:	8b 43 10             	mov    0x10(%ebx),%eax
80105b01:	85 c0                	test   %eax,%eax
80105b03:	74 eb                	je     80105af0 <list_all_processes_+0x10>
    {
      cprintf("procces with pid : %d have these system calls : \n" , p->pid);
80105b05:	83 ec 08             	sub    $0x8,%esp
80105b08:	50                   	push   %eax
80105b09:	68 c0 99 10 80       	push   $0x801099c0
80105b0e:	e8 cd ac ff ff       	call   801007e0 <cprintf>
      for (i = 0; i < p->numsystemcalls - 1; i++)
80105b13:	8b 83 10 02 00 00    	mov    0x210(%ebx),%eax
80105b19:	83 c4 10             	add    $0x10,%esp
80105b1c:	83 f8 01             	cmp    $0x1,%eax
80105b1f:	7e 30                	jle    80105b51 <list_all_processes_+0x71>
80105b21:	31 f6                	xor    %esi,%esi
80105b23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      {
        cprintf("system call number %d is %d \n" , i+1 , p->systemcalls[i]);
80105b28:	8b 84 b3 80 00 00 00 	mov    0x80(%ebx,%esi,4),%eax
80105b2f:	83 ec 04             	sub    $0x4,%esp
80105b32:	83 c6 01             	add    $0x1,%esi
80105b35:	50                   	push   %eax
80105b36:	56                   	push   %esi
80105b37:	68 ac 95 10 80       	push   $0x801095ac
80105b3c:	e8 9f ac ff ff       	call   801007e0 <cprintf>
      for (i = 0; i < p->numsystemcalls - 1; i++)
80105b41:	8b 83 10 02 00 00    	mov    0x210(%ebx),%eax
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b4d:	39 d6                	cmp    %edx,%esi
80105b4f:	7c d7                	jl     80105b28 <list_all_processes_+0x48>
      }
      cprintf("sum of all system calls is : %d \n" , p->numsystemcalls);
80105b51:	83 ec 08             	sub    $0x8,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105b54:	81 c3 34 02 00 00    	add    $0x234,%ebx
      cprintf("sum of all system calls is : %d \n" , p->numsystemcalls);
80105b5a:	50                   	push   %eax
80105b5b:	68 f4 99 10 80       	push   $0x801099f4
80105b60:	e8 7b ac ff ff       	call   801007e0 <cprintf>
80105b65:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105b68:	81 fb f4 d5 11 80    	cmp    $0x8011d5f4,%ebx
80105b6e:	75 8e                	jne    80105afe <list_all_processes_+0x1e>
    }
  }
  return 0;
}
80105b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b73:	31 c0                	xor    %eax,%eax
80105b75:	5b                   	pop    %ebx
80105b76:	5e                   	pop    %esi
80105b77:	5d                   	pop    %ebp
80105b78:	c3                   	ret
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b80 <change_Q>:

int change_Q(int pid, int new_queue)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
80105b86:	83 ec 0c             	sub    $0xc,%esp
80105b89:	8b 75 0c             	mov    0xc(%ebp),%esi
80105b8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int old_queue = -1;

  if (new_queue == UNSET)
80105b8f:	85 f6                	test   %esi,%esi
80105b91:	75 0c                	jne    80105b9f <change_Q+0x1f>
  {
    if (pid == 1)
80105b93:	83 fb 01             	cmp    $0x1,%ebx
80105b96:	74 65                	je     80105bfd <change_Q+0x7d>
      new_queue = ROUND_ROBIN;
    else if (pid > 1)
80105b98:	7e 6a                	jle    80105c04 <change_Q+0x84>
      new_queue = FCFS;
80105b9a:	be 02 00 00 00       	mov    $0x2,%esi
    else
      return -1;
  }
  acquire(&ptable.lock);
80105b9f:	83 ec 0c             	sub    $0xc,%esp
  int old_queue = -1;
80105ba2:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  acquire(&ptable.lock);
80105ba7:	68 c0 48 11 80       	push   $0x801148c0
80105bac:	e8 1f 07 00 00       	call   801062d0 <acquire>
    if (p->pid == pid)
    {
      old_queue = p->sched_info.queue;
      p->sched_info.queue = new_queue;

      p->sched_info.arrival_queue_time = ticks;
80105bb1:	8b 15 00 d6 11 80    	mov    0x8011d600,%edx
80105bb7:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105bba:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
80105bbf:	90                   	nop
    if (p->pid == pid)
80105bc0:	39 58 10             	cmp    %ebx,0x10(%eax)
80105bc3:	75 12                	jne    80105bd7 <change_Q+0x57>
      old_queue = p->sched_info.queue;
80105bc5:	8b b8 14 02 00 00    	mov    0x214(%eax),%edi
      p->sched_info.arrival_queue_time = ticks;
80105bcb:	89 90 30 02 00 00    	mov    %edx,0x230(%eax)
      p->sched_info.queue = new_queue;
80105bd1:	89 b0 14 02 00 00    	mov    %esi,0x214(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105bd7:	05 34 02 00 00       	add    $0x234,%eax
80105bdc:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
80105be1:	75 dd                	jne    80105bc0 <change_Q+0x40>
    }
  }
  release(&ptable.lock);
80105be3:	83 ec 0c             	sub    $0xc,%esp
80105be6:	68 c0 48 11 80       	push   $0x801148c0
80105beb:	e8 80 06 00 00       	call   80106270 <release>
  return old_queue;
80105bf0:	83 c4 10             	add    $0x10,%esp
}
80105bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf6:	89 f8                	mov    %edi,%eax
80105bf8:	5b                   	pop    %ebx
80105bf9:	5e                   	pop    %esi
80105bfa:	5f                   	pop    %edi
80105bfb:	5d                   	pop    %ebp
80105bfc:	c3                   	ret
      new_queue = ROUND_ROBIN;
80105bfd:	be 01 00 00 00       	mov    $0x1,%esi
80105c02:	eb 9b                	jmp    80105b9f <change_Q+0x1f>
      return -1;
80105c04:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105c09:	eb e8                	jmp    80105bf3 <change_Q+0x73>
80105c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105c10 <show_process_info>:

void show_process_info()
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
80105c16:	bb 60 49 11 80       	mov    $0x80114960,%ebx
80105c1b:	83 ec 28             	sub    $0x28,%esp
      [RUNNABLE] "runnable",
      [RUNNING] "running",
      [ZOMBIE] "zombie"};

  static int columns[] = {16, 8, 9, 8, 8, 8, 9, 8};
  cprintf("Process_Name    PID     State    wait time   Confidence  burst time consequtive run  arrival\n"
80105c1e:	68 18 9a 10 80       	push   $0x80109a18
80105c23:	e8 b8 ab ff ff       	call   801007e0 <cprintf>
          "------------------------------------------------------------------------------------------------------\n");

  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105c28:	83 c4 10             	add    $0x10,%esp
80105c2b:	eb 15                	jmp    80105c42 <show_process_info+0x32>
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
80105c30:	81 c3 34 02 00 00    	add    $0x234,%ebx
80105c36:	81 fb 60 d6 11 80    	cmp    $0x8011d660,%ebx
80105c3c:	0f 84 7f 02 00 00    	je     80105ec1 <show_process_info+0x2b1>
  {
    if (p->state == UNUSED)
80105c42:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105c45:	85 c0                	test   %eax,%eax
80105c47:	74 e7                	je     80105c30 <show_process_info+0x20>

    const char *state;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "unknown state";
80105c49:	c7 45 e4 ca 95 10 80 	movl   $0x801095ca,-0x1c(%ebp)
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105c50:	83 f8 05             	cmp    $0x5,%eax
80105c53:	77 14                	ja     80105c69 <show_process_info+0x59>
80105c55:	8b 3c 85 20 9e 10 80 	mov    -0x7fef61e0(,%eax,4),%edi
      state = "unknown state";
80105c5c:	b8 ca 95 10 80       	mov    $0x801095ca,%eax
80105c61:	85 ff                	test   %edi,%edi
80105c63:	0f 45 c7             	cmovne %edi,%eax
80105c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    cprintf("%s", p->name);
80105c69:	83 ec 08             	sub    $0x8,%esp
    space(columns[0] - strlen(p->name));
80105c6c:	bf 10 00 00 00       	mov    $0x10,%edi
    cprintf("%s", p->name);
80105c71:	53                   	push   %ebx
80105c72:	68 6b 95 10 80       	push   $0x8010956b
80105c77:	e8 64 ab ff ff       	call   801007e0 <cprintf>
    space(columns[0] - strlen(p->name));
80105c7c:	89 1c 24             	mov    %ebx,(%esp)
80105c7f:	e8 3c 09 00 00       	call   801065c0 <strlen>
  for(int i = 0; i < count; ++i)
80105c84:	83 c4 10             	add    $0x10,%esp
    space(columns[0] - strlen(p->name));
80105c87:	29 c7                	sub    %eax,%edi
  for(int i = 0; i < count; ++i)
80105c89:	85 ff                	test   %edi,%edi
80105c8b:	7e 1a                	jle    80105ca7 <show_process_info+0x97>
80105c8d:	31 f6                	xor    %esi,%esi
80105c8f:	90                   	nop
    cprintf(" ");
80105c90:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105c93:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105c96:	68 26 96 10 80       	push   $0x80109626
80105c9b:	e8 40 ab ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105ca0:	83 c4 10             	add    $0x10,%esp
80105ca3:	39 f7                	cmp    %esi,%edi
80105ca5:	75 e9                	jne    80105c90 <show_process_info+0x80>

    cprintf("%d", p->pid);
80105ca7:	83 ec 08             	sub    $0x8,%esp
80105caa:	ff 73 a4             	push   -0x5c(%ebx)
80105cad:	68 d8 95 10 80       	push   $0x801095d8
80105cb2:	e8 29 ab ff ff       	call   801007e0 <cprintf>
    space(columns[1] - num_digits(p->pid));
80105cb7:	8b 4b a4             	mov    -0x5c(%ebx),%ecx
  while(n!= 0) {
80105cba:	83 c4 10             	add    $0x10,%esp
80105cbd:	85 c9                	test   %ecx,%ecx
80105cbf:	0f 84 3b 02 00 00    	je     80105f00 <show_process_info+0x2f0>
  int num = 0;
80105cc5:	31 ff                	xor    %edi,%edi
    n/=10;
80105cc7:	be 67 66 66 66       	mov    $0x66666667,%esi
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cd0:	89 c8                	mov    %ecx,%eax
    num += 1;
80105cd2:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105cd5:	f7 ee                	imul   %esi
80105cd7:	89 c8                	mov    %ecx,%eax
80105cd9:	c1 f8 1f             	sar    $0x1f,%eax
80105cdc:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105cdf:	89 d1                	mov    %edx,%ecx
80105ce1:	29 c1                	sub    %eax,%ecx
80105ce3:	75 eb                	jne    80105cd0 <show_process_info+0xc0>
    space(columns[1] - num_digits(p->pid));
80105ce5:	b8 08 00 00 00       	mov    $0x8,%eax
80105cea:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105cec:	85 c0                	test   %eax,%eax
80105cee:	7e 1f                	jle    80105d0f <show_process_info+0xff>
80105cf0:	31 f6                	xor    %esi,%esi
80105cf2:	89 c7                	mov    %eax,%edi
80105cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105cf8:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105cfb:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105cfe:	68 26 96 10 80       	push   $0x80109626
80105d03:	e8 d8 aa ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105d08:	83 c4 10             	add    $0x10,%esp
80105d0b:	39 fe                	cmp    %edi,%esi
80105d0d:	75 e9                	jne    80105cf8 <show_process_info+0xe8>

    cprintf("%s", state);
80105d0f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105d12:	83 ec 08             	sub    $0x8,%esp
80105d15:	57                   	push   %edi
80105d16:	68 6b 95 10 80       	push   $0x8010956b
80105d1b:	e8 c0 aa ff ff       	call   801007e0 <cprintf>
    space(columns[2] - strlen(state));
80105d20:	89 3c 24             	mov    %edi,(%esp)
80105d23:	bf 09 00 00 00       	mov    $0x9,%edi
80105d28:	e8 93 08 00 00       	call   801065c0 <strlen>
  for(int i = 0; i < count; ++i)
80105d2d:	83 c4 10             	add    $0x10,%esp
    space(columns[2] - strlen(state));
80105d30:	29 c7                	sub    %eax,%edi
  for(int i = 0; i < count; ++i)
80105d32:	85 ff                	test   %edi,%edi
80105d34:	7e 21                	jle    80105d57 <show_process_info+0x147>
80105d36:	31 f6                	xor    %esi,%esi
80105d38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d3f:	00 
    cprintf(" ");
80105d40:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105d43:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105d46:	68 26 96 10 80       	push   $0x80109626
80105d4b:	e8 90 aa ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105d50:	83 c4 10             	add    $0x10,%esp
80105d53:	39 f7                	cmp    %esi,%edi
80105d55:	75 e9                	jne    80105d40 <show_process_info+0x130>

    cprintf("%d", p->sched_info.sjf.confidence);
80105d57:	83 ec 08             	sub    $0x8,%esp
80105d5a:	ff b3 bc 01 00 00    	push   0x1bc(%ebx)
80105d60:	68 d8 95 10 80       	push   $0x801095d8
80105d65:	e8 76 aa ff ff       	call   801007e0 <cprintf>
    space(columns[3] - num_digits(p->sched_info.sjf.confidence));
80105d6a:	8b 8b bc 01 00 00    	mov    0x1bc(%ebx),%ecx
  while(n!= 0) {
80105d70:	83 c4 10             	add    $0x10,%esp
80105d73:	85 c9                	test   %ecx,%ecx
80105d75:	0f 84 75 01 00 00    	je     80105ef0 <show_process_info+0x2e0>
  int num = 0;
80105d7b:	31 ff                	xor    %edi,%edi
    n/=10;
80105d7d:	be 67 66 66 66       	mov    $0x66666667,%esi
80105d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d88:	89 c8                	mov    %ecx,%eax
    num += 1;
80105d8a:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105d8d:	f7 ee                	imul   %esi
80105d8f:	89 c8                	mov    %ecx,%eax
80105d91:	c1 f8 1f             	sar    $0x1f,%eax
80105d94:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105d97:	29 c2                	sub    %eax,%edx
80105d99:	89 d1                	mov    %edx,%ecx
80105d9b:	75 eb                	jne    80105d88 <show_process_info+0x178>
    space(columns[3] - num_digits(p->sched_info.sjf.confidence));
80105d9d:	b8 08 00 00 00       	mov    $0x8,%eax
80105da2:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105da4:	85 c0                	test   %eax,%eax
80105da6:	7e 1f                	jle    80105dc7 <show_process_info+0x1b7>
80105da8:	31 f6                	xor    %esi,%esi
80105daa:	89 c7                	mov    %eax,%edi
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105db0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105db3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105db6:	68 26 96 10 80       	push   $0x80109626
80105dbb:	e8 20 aa ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105dc0:	83 c4 10             	add    $0x10,%esp
80105dc3:	39 f7                	cmp    %esi,%edi
80105dc5:	75 e9                	jne    80105db0 <show_process_info+0x1a0>

    cprintf("%d", p->sched_info.sjf.burst_time);
80105dc7:	83 ec 08             	sub    $0x8,%esp
80105dca:	ff b3 b8 01 00 00    	push   0x1b8(%ebx)
80105dd0:	68 d8 95 10 80       	push   $0x801095d8
80105dd5:	e8 06 aa ff ff       	call   801007e0 <cprintf>
    space(columns[4] - num_digits(p->sched_info.sjf.burst_time));
80105dda:	8b 8b b8 01 00 00    	mov    0x1b8(%ebx),%ecx
  while(n!= 0) {
80105de0:	83 c4 10             	add    $0x10,%esp
80105de3:	85 c9                	test   %ecx,%ecx
80105de5:	0f 84 f5 00 00 00    	je     80105ee0 <show_process_info+0x2d0>
  int num = 0;
80105deb:	31 ff                	xor    %edi,%edi
    n/=10;
80105ded:	be 67 66 66 66       	mov    $0x66666667,%esi
80105df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105df8:	89 c8                	mov    %ecx,%eax
    num += 1;
80105dfa:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105dfd:	f7 ee                	imul   %esi
80105dff:	89 c8                	mov    %ecx,%eax
80105e01:	c1 f8 1f             	sar    $0x1f,%eax
80105e04:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105e07:	89 d1                	mov    %edx,%ecx
80105e09:	29 c1                	sub    %eax,%ecx
80105e0b:	75 eb                	jne    80105df8 <show_process_info+0x1e8>
    space(columns[4] - num_digits(p->sched_info.sjf.burst_time));
80105e0d:	b8 08 00 00 00       	mov    $0x8,%eax
80105e12:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105e14:	85 c0                	test   %eax,%eax
80105e16:	7e 1f                	jle    80105e37 <show_process_info+0x227>
80105e18:	31 f6                	xor    %esi,%esi
80105e1a:	89 c7                	mov    %eax,%edi
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105e20:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105e23:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105e26:	68 26 96 10 80       	push   $0x80109626
80105e2b:	e8 b0 a9 ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105e30:	83 c4 10             	add    $0x10,%esp
80105e33:	39 f7                	cmp    %esi,%edi
80105e35:	75 e9                	jne    80105e20 <show_process_info+0x210>
    // cprintf("%d", p->sched_info.sjf.priority);
    // space(columns[6] - num_digits(p->sched_info.sjf.priority));

    //wait time algorithm???

    cprintf("%d", p->sched_info.sjf.arrival_time);
80105e37:	83 ec 08             	sub    $0x8,%esp
80105e3a:	ff b3 b4 01 00 00    	push   0x1b4(%ebx)
80105e40:	68 d8 95 10 80       	push   $0x801095d8
80105e45:	e8 96 a9 ff ff       	call   801007e0 <cprintf>
    space(columns[7] - num_digits(p->sched_info.sjf.arrival_time));
80105e4a:	8b 8b b4 01 00 00    	mov    0x1b4(%ebx),%ecx
  while(n!= 0) {
80105e50:	83 c4 10             	add    $0x10,%esp
80105e53:	85 c9                	test   %ecx,%ecx
80105e55:	74 79                	je     80105ed0 <show_process_info+0x2c0>
  int num = 0;
80105e57:	31 ff                	xor    %edi,%edi
    n/=10;
80105e59:	be 67 66 66 66       	mov    $0x66666667,%esi
80105e5e:	66 90                	xchg   %ax,%ax
80105e60:	89 c8                	mov    %ecx,%eax
    num += 1;
80105e62:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105e65:	f7 ee                	imul   %esi
80105e67:	89 c8                	mov    %ecx,%eax
80105e69:	c1 f8 1f             	sar    $0x1f,%eax
80105e6c:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105e6f:	29 c2                	sub    %eax,%edx
80105e71:	89 d1                	mov    %edx,%ecx
80105e73:	75 eb                	jne    80105e60 <show_process_info+0x250>
    space(columns[7] - num_digits(p->sched_info.sjf.arrival_time));
80105e75:	b8 08 00 00 00       	mov    $0x8,%eax
80105e7a:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105e7c:	85 c0                	test   %eax,%eax
80105e7e:	7e 1f                	jle    80105e9f <show_process_info+0x28f>
80105e80:	31 f6                	xor    %esi,%esi
80105e82:	89 c7                	mov    %eax,%edi
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105e88:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105e8b:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105e8e:	68 26 96 10 80       	push   $0x80109626
80105e93:	e8 48 a9 ff ff       	call   801007e0 <cprintf>
  for(int i = 0; i < count; ++i)
80105e98:	83 c4 10             	add    $0x10,%esp
80105e9b:	39 fe                	cmp    %edi,%esi
80105e9d:	75 e9                	jne    80105e88 <show_process_info+0x278>

    cprintf("\n");
80105e9f:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105ea2:	81 c3 34 02 00 00    	add    $0x234,%ebx
    cprintf("\n");
80105ea8:	68 aa 95 10 80       	push   $0x801095aa
80105ead:	e8 2e a9 ff ff       	call   801007e0 <cprintf>
80105eb2:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105eb5:	81 fb 60 d6 11 80    	cmp    $0x8011d660,%ebx
80105ebb:	0f 85 81 fd ff ff    	jne    80105c42 <show_process_info+0x32>
  }
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    space(columns[7] - num_digits(p->sched_info.sjf.arrival_time));
80105ed0:	b8 08 00 00 00       	mov    $0x8,%eax
80105ed5:	eb a9                	jmp    80105e80 <show_process_info+0x270>
80105ed7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ede:	00 
80105edf:	90                   	nop
    space(columns[4] - num_digits(p->sched_info.sjf.burst_time));
80105ee0:	b8 08 00 00 00       	mov    $0x8,%eax
80105ee5:	e9 2e ff ff ff       	jmp    80105e18 <show_process_info+0x208>
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    space(columns[3] - num_digits(p->sched_info.sjf.confidence));
80105ef0:	b8 08 00 00 00       	mov    $0x8,%eax
80105ef5:	e9 ae fe ff ff       	jmp    80105da8 <show_process_info+0x198>
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    space(columns[1] - num_digits(p->pid));
80105f00:	b8 08 00 00 00       	mov    $0x8,%eax
80105f05:	e9 e6 fd ff ff       	jmp    80105cf0 <show_process_info+0xe0>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <set_proc_sjf_params_>:

int set_proc_sjf_params_(int pid, int burst_time, int confidence)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	57                   	push   %edi
80105f14:	56                   	push   %esi
80105f15:	53                   	push   %ebx
80105f16:	83 ec 18             	sub    $0x18,%esp
80105f19:	8b 7d 08             	mov    0x8(%ebp),%edi
80105f1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105f1f:	8b 75 10             	mov    0x10(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
80105f22:	68 c0 48 11 80       	push   $0x801148c0
80105f27:	e8 a4 03 00 00       	call   801062d0 <acquire>
80105f2c:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105f2f:	b8 f4 48 11 80       	mov    $0x801148f4,%eax
80105f34:	eb 16                	jmp    80105f4c <set_proc_sjf_params_+0x3c>
80105f36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f3d:	00 
80105f3e:	66 90                	xchg   %ax,%ax
80105f40:	05 34 02 00 00       	add    $0x234,%eax
80105f45:	3d f4 d5 11 80       	cmp    $0x8011d5f4,%eax
80105f4a:	74 44                	je     80105f90 <set_proc_sjf_params_+0x80>
  {
    if (p->pid == pid)
80105f4c:	39 78 10             	cmp    %edi,0x10(%eax)
80105f4f:	75 ef                	jne    80105f40 <set_proc_sjf_params_+0x30>
    {
      p->sched_info.sjf.burst_time = burst_time;
      p->sched_info.sjf.confidence = confidence;
      cprintf("%d %d %d %d %d \n",pid,p->sched_info.sjf.burst_time , p->sched_info.sjf.confidence,burst_time,confidence);
80105f51:	83 ec 08             	sub    $0x8,%esp
      p->sched_info.sjf.burst_time = burst_time;
80105f54:	89 98 24 02 00 00    	mov    %ebx,0x224(%eax)
      p->sched_info.sjf.confidence = confidence;
80105f5a:	89 b0 28 02 00 00    	mov    %esi,0x228(%eax)
      cprintf("%d %d %d %d %d \n",pid,p->sched_info.sjf.burst_time , p->sched_info.sjf.confidence,burst_time,confidence);
80105f60:	56                   	push   %esi
80105f61:	53                   	push   %ebx
80105f62:	56                   	push   %esi
80105f63:	53                   	push   %ebx
80105f64:	57                   	push   %edi
80105f65:	68 db 95 10 80       	push   $0x801095db
80105f6a:	e8 71 a8 ff ff       	call   801007e0 <cprintf>
      release(&ptable.lock);
80105f6f:	83 c4 14             	add    $0x14,%esp
80105f72:	68 c0 48 11 80       	push   $0x801148c0
80105f77:	e8 f4 02 00 00       	call   80106270 <release>
      return 0;
80105f7c:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
80105f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105f82:	31 c0                	xor    %eax,%eax
80105f84:	5b                   	pop    %ebx
80105f85:	5e                   	pop    %esi
80105f86:	5f                   	pop    %edi
80105f87:	5d                   	pop    %ebp
80105f88:	c3                   	ret
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	68 c0 48 11 80       	push   $0x801148c0
80105f98:	e8 d3 02 00 00       	call   80106270 <release>
  return -1;
80105f9d:	83 c4 10             	add    $0x10,%esp
80105fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa8:	5b                   	pop    %ebx
80105fa9:	5e                   	pop    %esi
80105faa:	5f                   	pop    %edi
80105fab:	5d                   	pop    %ebp
80105fac:	c3                   	ret
80105fad:	66 90                	xchg   %ax,%ax
80105faf:	90                   	nop

80105fb0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	53                   	push   %ebx
80105fb4:	83 ec 0c             	sub    $0xc,%esp
80105fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80105fba:	68 28 96 10 80       	push   $0x80109628
80105fbf:	8d 43 04             	lea    0x4(%ebx),%eax
80105fc2:	50                   	push   %eax
80105fc3:	e8 18 01 00 00       	call   801060e0 <initlock>
  lk->name = name;
80105fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80105fcb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105fd1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105fd4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80105fdb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe1:	c9                   	leave
80105fe2:	c3                   	ret
80105fe3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fea:	00 
80105feb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105ff0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	56                   	push   %esi
80105ff4:	53                   	push   %ebx
80105ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105ff8:	8d 73 04             	lea    0x4(%ebx),%esi
80105ffb:	83 ec 0c             	sub    $0xc,%esp
80105ffe:	56                   	push   %esi
80105fff:	e8 cc 02 00 00       	call   801062d0 <acquire>
  while (lk->locked) {
80106004:	8b 13                	mov    (%ebx),%edx
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 d2                	test   %edx,%edx
8010600b:	74 16                	je     80106023 <acquiresleep+0x33>
8010600d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80106010:	83 ec 08             	sub    $0x8,%esp
80106013:	56                   	push   %esi
80106014:	53                   	push   %ebx
80106015:	e8 d6 f3 ff ff       	call   801053f0 <sleep>
  while (lk->locked) {
8010601a:	8b 03                	mov    (%ebx),%eax
8010601c:	83 c4 10             	add    $0x10,%esp
8010601f:	85 c0                	test   %eax,%eax
80106021:	75 ed                	jne    80106010 <acquiresleep+0x20>
  }
  lk->locked = 1;
80106023:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80106029:	e8 c2 ec ff ff       	call   80104cf0 <myproc>
8010602e:	8b 40 10             	mov    0x10(%eax),%eax
80106031:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80106034:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106037:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010603a:	5b                   	pop    %ebx
8010603b:	5e                   	pop    %esi
8010603c:	5d                   	pop    %ebp
  release(&lk->lk);
8010603d:	e9 2e 02 00 00       	jmp    80106270 <release>
80106042:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106049:	00 
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106050 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	56                   	push   %esi
80106054:	53                   	push   %ebx
80106055:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80106058:	8d 73 04             	lea    0x4(%ebx),%esi
8010605b:	83 ec 0c             	sub    $0xc,%esp
8010605e:	56                   	push   %esi
8010605f:	e8 6c 02 00 00       	call   801062d0 <acquire>
  lk->locked = 0;
80106064:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010606a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80106071:	89 1c 24             	mov    %ebx,(%esp)
80106074:	e8 37 f4 ff ff       	call   801054b0 <wakeup>
  release(&lk->lk);
80106079:	89 75 08             	mov    %esi,0x8(%ebp)
8010607c:	83 c4 10             	add    $0x10,%esp
}
8010607f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106082:	5b                   	pop    %ebx
80106083:	5e                   	pop    %esi
80106084:	5d                   	pop    %ebp
  release(&lk->lk);
80106085:	e9 e6 01 00 00       	jmp    80106270 <release>
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106090 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	57                   	push   %edi
80106094:	31 ff                	xor    %edi,%edi
80106096:	56                   	push   %esi
80106097:	53                   	push   %ebx
80106098:	83 ec 18             	sub    $0x18,%esp
8010609b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010609e:	8d 73 04             	lea    0x4(%ebx),%esi
801060a1:	56                   	push   %esi
801060a2:	e8 29 02 00 00       	call   801062d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801060a7:	8b 03                	mov    (%ebx),%eax
801060a9:	83 c4 10             	add    $0x10,%esp
801060ac:	85 c0                	test   %eax,%eax
801060ae:	75 18                	jne    801060c8 <holdingsleep+0x38>
  release(&lk->lk);
801060b0:	83 ec 0c             	sub    $0xc,%esp
801060b3:	56                   	push   %esi
801060b4:	e8 b7 01 00 00       	call   80106270 <release>
  return r;
}
801060b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060bc:	89 f8                	mov    %edi,%eax
801060be:	5b                   	pop    %ebx
801060bf:	5e                   	pop    %esi
801060c0:	5f                   	pop    %edi
801060c1:	5d                   	pop    %ebp
801060c2:	c3                   	ret
801060c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801060c8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801060cb:	e8 20 ec ff ff       	call   80104cf0 <myproc>
801060d0:	39 58 10             	cmp    %ebx,0x10(%eax)
801060d3:	0f 94 c0             	sete   %al
801060d6:	0f b6 c0             	movzbl %al,%eax
801060d9:	89 c7                	mov    %eax,%edi
801060db:	eb d3                	jmp    801060b0 <holdingsleep+0x20>
801060dd:	66 90                	xchg   %ax,%ax
801060df:	90                   	nop

801060e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801060e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801060e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801060ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801060f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801060f9:	5d                   	pop    %ebp
801060fa:	c3                   	ret
801060fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106100 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	53                   	push   %ebx
80106104:	8b 45 08             	mov    0x8(%ebp),%eax
80106107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010610a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010610d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80106112:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80106117:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010611c:	76 10                	jbe    8010612e <getcallerpcs+0x2e>
8010611e:	eb 28                	jmp    80106148 <getcallerpcs+0x48>
80106120:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80106126:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010612c:	77 1a                	ja     80106148 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010612e:	8b 5a 04             	mov    0x4(%edx),%ebx
80106131:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80106134:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80106137:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80106139:	83 f8 0a             	cmp    $0xa,%eax
8010613c:	75 e2                	jne    80106120 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010613e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106141:	c9                   	leave
80106142:	c3                   	ret
80106143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106148:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010614b:	83 c1 28             	add    $0x28,%ecx
8010614e:	89 ca                	mov    %ecx,%edx
80106150:	29 c2                	sub    %eax,%edx
80106152:	83 e2 04             	and    $0x4,%edx
80106155:	74 11                	je     80106168 <getcallerpcs+0x68>
    pcs[i] = 0;
80106157:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010615d:	83 c0 04             	add    $0x4,%eax
80106160:	39 c1                	cmp    %eax,%ecx
80106162:	74 da                	je     8010613e <getcallerpcs+0x3e>
80106164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80106168:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010616e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106171:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106178:	39 c1                	cmp    %eax,%ecx
8010617a:	75 ec                	jne    80106168 <getcallerpcs+0x68>
8010617c:	eb c0                	jmp    8010613e <getcallerpcs+0x3e>
8010617e:	66 90                	xchg   %ax,%ax

80106180 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	53                   	push   %ebx
80106184:	83 ec 04             	sub    $0x4,%esp
80106187:	9c                   	pushf
80106188:	5b                   	pop    %ebx
  asm volatile("cli");
80106189:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010618a:	e8 e1 ea ff ff       	call   80104c70 <mycpu>
8010618f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80106195:	85 c0                	test   %eax,%eax
80106197:	74 17                	je     801061b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80106199:	e8 d2 ea ff ff       	call   80104c70 <mycpu>
8010619e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801061a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061a8:	c9                   	leave
801061a9:	c3                   	ret
801061aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801061b0:	e8 bb ea ff ff       	call   80104c70 <mycpu>
801061b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801061bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801061c1:	eb d6                	jmp    80106199 <pushcli+0x19>
801061c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061ca:	00 
801061cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801061d0 <popcli>:

void
popcli(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801061d6:	9c                   	pushf
801061d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801061d8:	f6 c4 02             	test   $0x2,%ah
801061db:	75 35                	jne    80106212 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801061dd:	e8 8e ea ff ff       	call   80104c70 <mycpu>
801061e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801061e9:	78 34                	js     8010621f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801061eb:	e8 80 ea ff ff       	call   80104c70 <mycpu>
801061f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801061f6:	85 d2                	test   %edx,%edx
801061f8:	74 06                	je     80106200 <popcli+0x30>
    sti();
}
801061fa:	c9                   	leave
801061fb:	c3                   	ret
801061fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80106200:	e8 6b ea ff ff       	call   80104c70 <mycpu>
80106205:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010620b:	85 c0                	test   %eax,%eax
8010620d:	74 eb                	je     801061fa <popcli+0x2a>
  asm volatile("sti");
8010620f:	fb                   	sti
}
80106210:	c9                   	leave
80106211:	c3                   	ret
    panic("popcli - interruptible");
80106212:	83 ec 0c             	sub    $0xc,%esp
80106215:	68 33 96 10 80       	push   $0x80109633
8010621a:	e8 31 a2 ff ff       	call   80100450 <panic>
    panic("popcli");
8010621f:	83 ec 0c             	sub    $0xc,%esp
80106222:	68 4a 96 10 80       	push   $0x8010964a
80106227:	e8 24 a2 ff ff       	call   80100450 <panic>
8010622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106230 <holding>:
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	56                   	push   %esi
80106234:	53                   	push   %ebx
80106235:	8b 75 08             	mov    0x8(%ebp),%esi
80106238:	31 db                	xor    %ebx,%ebx
  pushcli();
8010623a:	e8 41 ff ff ff       	call   80106180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010623f:	8b 06                	mov    (%esi),%eax
80106241:	85 c0                	test   %eax,%eax
80106243:	75 0b                	jne    80106250 <holding+0x20>
  popcli();
80106245:	e8 86 ff ff ff       	call   801061d0 <popcli>
}
8010624a:	89 d8                	mov    %ebx,%eax
8010624c:	5b                   	pop    %ebx
8010624d:	5e                   	pop    %esi
8010624e:	5d                   	pop    %ebp
8010624f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80106250:	8b 5e 08             	mov    0x8(%esi),%ebx
80106253:	e8 18 ea ff ff       	call   80104c70 <mycpu>
80106258:	39 c3                	cmp    %eax,%ebx
8010625a:	0f 94 c3             	sete   %bl
  popcli();
8010625d:	e8 6e ff ff ff       	call   801061d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80106262:	0f b6 db             	movzbl %bl,%ebx
}
80106265:	89 d8                	mov    %ebx,%eax
80106267:	5b                   	pop    %ebx
80106268:	5e                   	pop    %esi
80106269:	5d                   	pop    %ebp
8010626a:	c3                   	ret
8010626b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106270 <release>:
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	56                   	push   %esi
80106274:	53                   	push   %ebx
80106275:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106278:	e8 03 ff ff ff       	call   80106180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010627d:	8b 03                	mov    (%ebx),%eax
8010627f:	85 c0                	test   %eax,%eax
80106281:	75 15                	jne    80106298 <release+0x28>
  popcli();
80106283:	e8 48 ff ff ff       	call   801061d0 <popcli>
    panic("release");
80106288:	83 ec 0c             	sub    $0xc,%esp
8010628b:	68 51 96 10 80       	push   $0x80109651
80106290:	e8 bb a1 ff ff       	call   80100450 <panic>
80106295:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80106298:	8b 73 08             	mov    0x8(%ebx),%esi
8010629b:	e8 d0 e9 ff ff       	call   80104c70 <mycpu>
801062a0:	39 c6                	cmp    %eax,%esi
801062a2:	75 df                	jne    80106283 <release+0x13>
  popcli();
801062a4:	e8 27 ff ff ff       	call   801061d0 <popcli>
  lk->pcs[0] = 0;
801062a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801062b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801062b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801062bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801062c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062c5:	5b                   	pop    %ebx
801062c6:	5e                   	pop    %esi
801062c7:	5d                   	pop    %ebp
  popcli();
801062c8:	e9 03 ff ff ff       	jmp    801061d0 <popcli>
801062cd:	8d 76 00             	lea    0x0(%esi),%esi

801062d0 <acquire>:
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	53                   	push   %ebx
801062d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801062d7:	e8 a4 fe ff ff       	call   80106180 <pushcli>
  if(holding(lk))
801062dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801062df:	e8 9c fe ff ff       	call   80106180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801062e4:	8b 03                	mov    (%ebx),%eax
801062e6:	85 c0                	test   %eax,%eax
801062e8:	0f 85 b2 00 00 00    	jne    801063a0 <acquire+0xd0>
  popcli();
801062ee:	e8 dd fe ff ff       	call   801061d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801062f3:	b9 01 00 00 00       	mov    $0x1,%ecx
801062f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062ff:	00 
  while(xchg(&lk->locked, 1) != 0)
80106300:	8b 55 08             	mov    0x8(%ebp),%edx
80106303:	89 c8                	mov    %ecx,%eax
80106305:	f0 87 02             	lock xchg %eax,(%edx)
80106308:	85 c0                	test   %eax,%eax
8010630a:	75 f4                	jne    80106300 <acquire+0x30>
  __sync_synchronize();
8010630c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80106311:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106314:	e8 57 e9 ff ff       	call   80104c70 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80106319:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010631c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010631e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106321:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80106327:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010632c:	77 32                	ja     80106360 <acquire+0x90>
  ebp = (uint*)v - 2;
8010632e:	89 e8                	mov    %ebp,%eax
80106330:	eb 14                	jmp    80106346 <acquire+0x76>
80106332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106338:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010633e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80106344:	77 1a                	ja     80106360 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80106346:	8b 58 04             	mov    0x4(%eax),%ebx
80106349:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010634d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80106350:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80106352:	83 fa 0a             	cmp    $0xa,%edx
80106355:	75 e1                	jne    80106338 <acquire+0x68>
}
80106357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010635a:	c9                   	leave
8010635b:	c3                   	ret
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106360:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80106364:	83 c1 34             	add    $0x34,%ecx
80106367:	89 ca                	mov    %ecx,%edx
80106369:	29 c2                	sub    %eax,%edx
8010636b:	83 e2 04             	and    $0x4,%edx
8010636e:	74 10                	je     80106380 <acquire+0xb0>
    pcs[i] = 0;
80106370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106376:	83 c0 04             	add    $0x4,%eax
80106379:	39 c1                	cmp    %eax,%ecx
8010637b:	74 da                	je     80106357 <acquire+0x87>
8010637d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80106380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106386:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106389:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106390:	39 c1                	cmp    %eax,%ecx
80106392:	75 ec                	jne    80106380 <acquire+0xb0>
80106394:	eb c1                	jmp    80106357 <acquire+0x87>
80106396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010639d:	00 
8010639e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801063a0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801063a3:	e8 c8 e8 ff ff       	call   80104c70 <mycpu>
801063a8:	39 c3                	cmp    %eax,%ebx
801063aa:	0f 85 3e ff ff ff    	jne    801062ee <acquire+0x1e>
  popcli();
801063b0:	e8 1b fe ff ff       	call   801061d0 <popcli>
    panic("acquire");
801063b5:	83 ec 0c             	sub    $0xc,%esp
801063b8:	68 59 96 10 80       	push   $0x80109659
801063bd:	e8 8e a0 ff ff       	call   80100450 <panic>
801063c2:	66 90                	xchg   %ax,%ax
801063c4:	66 90                	xchg   %ax,%ax
801063c6:	66 90                	xchg   %ax,%ax
801063c8:	66 90                	xchg   %ax,%ax
801063ca:	66 90                	xchg   %ax,%ax
801063cc:	66 90                	xchg   %ax,%ax
801063ce:	66 90                	xchg   %ax,%ax

801063d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	57                   	push   %edi
801063d4:	8b 55 08             	mov    0x8(%ebp),%edx
801063d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801063da:	89 d0                	mov    %edx,%eax
801063dc:	09 c8                	or     %ecx,%eax
801063de:	a8 03                	test   $0x3,%al
801063e0:	75 1e                	jne    80106400 <memset+0x30>
    c &= 0xFF;
801063e2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801063e6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801063e9:	89 d7                	mov    %edx,%edi
801063eb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801063f1:	fc                   	cld
801063f2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801063f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801063f7:	89 d0                	mov    %edx,%eax
801063f9:	c9                   	leave
801063fa:	c3                   	ret
801063fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80106400:	8b 45 0c             	mov    0xc(%ebp),%eax
80106403:	89 d7                	mov    %edx,%edi
80106405:	fc                   	cld
80106406:	f3 aa                	rep stos %al,%es:(%edi)
80106408:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010640b:	89 d0                	mov    %edx,%eax
8010640d:	c9                   	leave
8010640e:	c3                   	ret
8010640f:	90                   	nop

80106410 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	56                   	push   %esi
80106414:	8b 75 10             	mov    0x10(%ebp),%esi
80106417:	8b 45 08             	mov    0x8(%ebp),%eax
8010641a:	53                   	push   %ebx
8010641b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010641e:	85 f6                	test   %esi,%esi
80106420:	74 2e                	je     80106450 <memcmp+0x40>
80106422:	01 c6                	add    %eax,%esi
80106424:	eb 14                	jmp    8010643a <memcmp+0x2a>
80106426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010642d:	00 
8010642e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80106430:	83 c0 01             	add    $0x1,%eax
80106433:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80106436:	39 f0                	cmp    %esi,%eax
80106438:	74 16                	je     80106450 <memcmp+0x40>
    if(*s1 != *s2)
8010643a:	0f b6 08             	movzbl (%eax),%ecx
8010643d:	0f b6 1a             	movzbl (%edx),%ebx
80106440:	38 d9                	cmp    %bl,%cl
80106442:	74 ec                	je     80106430 <memcmp+0x20>
      return *s1 - *s2;
80106444:	0f b6 c1             	movzbl %cl,%eax
80106447:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80106449:	5b                   	pop    %ebx
8010644a:	5e                   	pop    %esi
8010644b:	5d                   	pop    %ebp
8010644c:	c3                   	ret
8010644d:	8d 76 00             	lea    0x0(%esi),%esi
80106450:	5b                   	pop    %ebx
  return 0;
80106451:	31 c0                	xor    %eax,%eax
}
80106453:	5e                   	pop    %esi
80106454:	5d                   	pop    %ebp
80106455:	c3                   	ret
80106456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010645d:	00 
8010645e:	66 90                	xchg   %ax,%ax

80106460 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	57                   	push   %edi
80106464:	8b 55 08             	mov    0x8(%ebp),%edx
80106467:	8b 45 10             	mov    0x10(%ebp),%eax
8010646a:	56                   	push   %esi
8010646b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010646e:	39 d6                	cmp    %edx,%esi
80106470:	73 26                	jae    80106498 <memmove+0x38>
80106472:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80106475:	39 ca                	cmp    %ecx,%edx
80106477:	73 1f                	jae    80106498 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80106479:	85 c0                	test   %eax,%eax
8010647b:	74 0f                	je     8010648c <memmove+0x2c>
8010647d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80106480:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80106484:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80106487:	83 e8 01             	sub    $0x1,%eax
8010648a:	73 f4                	jae    80106480 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010648c:	5e                   	pop    %esi
8010648d:	89 d0                	mov    %edx,%eax
8010648f:	5f                   	pop    %edi
80106490:	5d                   	pop    %ebp
80106491:	c3                   	ret
80106492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80106498:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010649b:	89 d7                	mov    %edx,%edi
8010649d:	85 c0                	test   %eax,%eax
8010649f:	74 eb                	je     8010648c <memmove+0x2c>
801064a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801064a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801064a9:	39 ce                	cmp    %ecx,%esi
801064ab:	75 fb                	jne    801064a8 <memmove+0x48>
}
801064ad:	5e                   	pop    %esi
801064ae:	89 d0                	mov    %edx,%eax
801064b0:	5f                   	pop    %edi
801064b1:	5d                   	pop    %ebp
801064b2:	c3                   	ret
801064b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064ba:	00 
801064bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801064c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801064c0:	eb 9e                	jmp    80106460 <memmove>
801064c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064c9:	00 
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	53                   	push   %ebx
801064d4:	8b 55 10             	mov    0x10(%ebp),%edx
801064d7:	8b 45 08             	mov    0x8(%ebp),%eax
801064da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801064dd:	85 d2                	test   %edx,%edx
801064df:	75 16                	jne    801064f7 <strncmp+0x27>
801064e1:	eb 2d                	jmp    80106510 <strncmp+0x40>
801064e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801064e8:	3a 19                	cmp    (%ecx),%bl
801064ea:	75 12                	jne    801064fe <strncmp+0x2e>
    n--, p++, q++;
801064ec:	83 c0 01             	add    $0x1,%eax
801064ef:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801064f2:	83 ea 01             	sub    $0x1,%edx
801064f5:	74 19                	je     80106510 <strncmp+0x40>
801064f7:	0f b6 18             	movzbl (%eax),%ebx
801064fa:	84 db                	test   %bl,%bl
801064fc:	75 ea                	jne    801064e8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801064fe:	0f b6 00             	movzbl (%eax),%eax
80106501:	0f b6 11             	movzbl (%ecx),%edx
}
80106504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106507:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80106508:	29 d0                	sub    %edx,%eax
}
8010650a:	c3                   	ret
8010650b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80106513:	31 c0                	xor    %eax,%eax
}
80106515:	c9                   	leave
80106516:	c3                   	ret
80106517:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010651e:	00 
8010651f:	90                   	nop

80106520 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	57                   	push   %edi
80106524:	56                   	push   %esi
80106525:	8b 75 08             	mov    0x8(%ebp),%esi
80106528:	53                   	push   %ebx
80106529:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010652c:	89 f0                	mov    %esi,%eax
8010652e:	eb 15                	jmp    80106545 <strncpy+0x25>
80106530:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80106534:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106537:	83 c0 01             	add    $0x1,%eax
8010653a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010653e:	88 48 ff             	mov    %cl,-0x1(%eax)
80106541:	84 c9                	test   %cl,%cl
80106543:	74 13                	je     80106558 <strncpy+0x38>
80106545:	89 d3                	mov    %edx,%ebx
80106547:	83 ea 01             	sub    $0x1,%edx
8010654a:	85 db                	test   %ebx,%ebx
8010654c:	7f e2                	jg     80106530 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010654e:	5b                   	pop    %ebx
8010654f:	89 f0                	mov    %esi,%eax
80106551:	5e                   	pop    %esi
80106552:	5f                   	pop    %edi
80106553:	5d                   	pop    %ebp
80106554:	c3                   	ret
80106555:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80106558:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010655b:	83 e9 01             	sub    $0x1,%ecx
8010655e:	85 d2                	test   %edx,%edx
80106560:	74 ec                	je     8010654e <strncpy+0x2e>
80106562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80106568:	83 c0 01             	add    $0x1,%eax
8010656b:	89 ca                	mov    %ecx,%edx
8010656d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80106571:	29 c2                	sub    %eax,%edx
80106573:	85 d2                	test   %edx,%edx
80106575:	7f f1                	jg     80106568 <strncpy+0x48>
}
80106577:	5b                   	pop    %ebx
80106578:	89 f0                	mov    %esi,%eax
8010657a:	5e                   	pop    %esi
8010657b:	5f                   	pop    %edi
8010657c:	5d                   	pop    %ebp
8010657d:	c3                   	ret
8010657e:	66 90                	xchg   %ax,%ax

80106580 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	56                   	push   %esi
80106584:	8b 55 10             	mov    0x10(%ebp),%edx
80106587:	8b 75 08             	mov    0x8(%ebp),%esi
8010658a:	53                   	push   %ebx
8010658b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010658e:	85 d2                	test   %edx,%edx
80106590:	7e 25                	jle    801065b7 <safestrcpy+0x37>
80106592:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80106596:	89 f2                	mov    %esi,%edx
80106598:	eb 16                	jmp    801065b0 <safestrcpy+0x30>
8010659a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801065a0:	0f b6 08             	movzbl (%eax),%ecx
801065a3:	83 c0 01             	add    $0x1,%eax
801065a6:	83 c2 01             	add    $0x1,%edx
801065a9:	88 4a ff             	mov    %cl,-0x1(%edx)
801065ac:	84 c9                	test   %cl,%cl
801065ae:	74 04                	je     801065b4 <safestrcpy+0x34>
801065b0:	39 d8                	cmp    %ebx,%eax
801065b2:	75 ec                	jne    801065a0 <safestrcpy+0x20>
    ;
  *s = 0;
801065b4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801065b7:	89 f0                	mov    %esi,%eax
801065b9:	5b                   	pop    %ebx
801065ba:	5e                   	pop    %esi
801065bb:	5d                   	pop    %ebp
801065bc:	c3                   	ret
801065bd:	8d 76 00             	lea    0x0(%esi),%esi

801065c0 <strlen>:

int
strlen(const char *s)
{
801065c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801065c1:	31 c0                	xor    %eax,%eax
{
801065c3:	89 e5                	mov    %esp,%ebp
801065c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801065c8:	80 3a 00             	cmpb   $0x0,(%edx)
801065cb:	74 0c                	je     801065d9 <strlen+0x19>
801065cd:	8d 76 00             	lea    0x0(%esi),%esi
801065d0:	83 c0 01             	add    $0x1,%eax
801065d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801065d7:	75 f7                	jne    801065d0 <strlen+0x10>
    ;
  return n;
}
801065d9:	5d                   	pop    %ebp
801065da:	c3                   	ret

801065db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801065db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801065df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801065e3:	55                   	push   %ebp
  pushl %ebx
801065e4:	53                   	push   %ebx
  pushl %esi
801065e5:	56                   	push   %esi
  pushl %edi
801065e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801065e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801065e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801065eb:	5f                   	pop    %edi
  popl %esi
801065ec:	5e                   	pop    %esi
  popl %ebx
801065ed:	5b                   	pop    %ebx
  popl %ebp
801065ee:	5d                   	pop    %ebp
  ret
801065ef:	c3                   	ret

801065f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	53                   	push   %ebx
801065f4:	83 ec 04             	sub    $0x4,%esp
801065f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801065fa:	e8 f1 e6 ff ff       	call   80104cf0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801065ff:	8b 00                	mov    (%eax),%eax
80106601:	39 c3                	cmp    %eax,%ebx
80106603:	73 1b                	jae    80106620 <fetchint+0x30>
80106605:	8d 53 04             	lea    0x4(%ebx),%edx
80106608:	39 d0                	cmp    %edx,%eax
8010660a:	72 14                	jb     80106620 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010660c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010660f:	8b 13                	mov    (%ebx),%edx
80106611:	89 10                	mov    %edx,(%eax)
  return 0;
80106613:	31 c0                	xor    %eax,%eax
}
80106615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106618:	c9                   	leave
80106619:	c3                   	ret
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106625:	eb ee                	jmp    80106615 <fetchint+0x25>
80106627:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010662e:	00 
8010662f:	90                   	nop

80106630 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	53                   	push   %ebx
80106634:	83 ec 04             	sub    $0x4,%esp
80106637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010663a:	e8 b1 e6 ff ff       	call   80104cf0 <myproc>

  if(addr >= curproc->sz)
8010663f:	3b 18                	cmp    (%eax),%ebx
80106641:	73 2d                	jae    80106670 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80106643:	8b 55 0c             	mov    0xc(%ebp),%edx
80106646:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80106648:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010664a:	39 d3                	cmp    %edx,%ebx
8010664c:	73 22                	jae    80106670 <fetchstr+0x40>
8010664e:	89 d8                	mov    %ebx,%eax
80106650:	eb 0d                	jmp    8010665f <fetchstr+0x2f>
80106652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106658:	83 c0 01             	add    $0x1,%eax
8010665b:	39 d0                	cmp    %edx,%eax
8010665d:	73 11                	jae    80106670 <fetchstr+0x40>
    if(*s == 0)
8010665f:	80 38 00             	cmpb   $0x0,(%eax)
80106662:	75 f4                	jne    80106658 <fetchstr+0x28>
      return s - *pp;
80106664:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80106666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106669:	c9                   	leave
8010666a:	c3                   	ret
8010666b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80106673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106678:	c9                   	leave
80106679:	c3                   	ret
8010667a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106680 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	56                   	push   %esi
80106684:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106685:	e8 66 e6 ff ff       	call   80104cf0 <myproc>
8010668a:	8b 55 08             	mov    0x8(%ebp),%edx
8010668d:	8b 40 18             	mov    0x18(%eax),%eax
80106690:	8b 40 44             	mov    0x44(%eax),%eax
80106693:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106696:	e8 55 e6 ff ff       	call   80104cf0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010669b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010669e:	8b 00                	mov    (%eax),%eax
801066a0:	39 c6                	cmp    %eax,%esi
801066a2:	73 1c                	jae    801066c0 <argint+0x40>
801066a4:	8d 53 08             	lea    0x8(%ebx),%edx
801066a7:	39 d0                	cmp    %edx,%eax
801066a9:	72 15                	jb     801066c0 <argint+0x40>
  *ip = *(int*)(addr);
801066ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801066ae:	8b 53 04             	mov    0x4(%ebx),%edx
801066b1:	89 10                	mov    %edx,(%eax)
  return 0;
801066b3:	31 c0                	xor    %eax,%eax
}
801066b5:	5b                   	pop    %ebx
801066b6:	5e                   	pop    %esi
801066b7:	5d                   	pop    %ebp
801066b8:	c3                   	ret
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066c5:	eb ee                	jmp    801066b5 <argint+0x35>
801066c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801066ce:	00 
801066cf:	90                   	nop

801066d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801066d9:	e8 12 e6 ff ff       	call   80104cf0 <myproc>
801066de:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066e0:	e8 0b e6 ff ff       	call   80104cf0 <myproc>
801066e5:	8b 55 08             	mov    0x8(%ebp),%edx
801066e8:	8b 40 18             	mov    0x18(%eax),%eax
801066eb:	8b 40 44             	mov    0x44(%eax),%eax
801066ee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801066f1:	e8 fa e5 ff ff       	call   80104cf0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066f6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801066f9:	8b 00                	mov    (%eax),%eax
801066fb:	39 c7                	cmp    %eax,%edi
801066fd:	73 31                	jae    80106730 <argptr+0x60>
801066ff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106702:	39 c8                	cmp    %ecx,%eax
80106704:	72 2a                	jb     80106730 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106706:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106709:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010670c:	85 d2                	test   %edx,%edx
8010670e:	78 20                	js     80106730 <argptr+0x60>
80106710:	8b 16                	mov    (%esi),%edx
80106712:	39 d0                	cmp    %edx,%eax
80106714:	73 1a                	jae    80106730 <argptr+0x60>
80106716:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106719:	01 c3                	add    %eax,%ebx
8010671b:	39 da                	cmp    %ebx,%edx
8010671d:	72 11                	jb     80106730 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010671f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106722:	89 02                	mov    %eax,(%edx)
  return 0;
80106724:	31 c0                	xor    %eax,%eax
}
80106726:	83 c4 0c             	add    $0xc,%esp
80106729:	5b                   	pop    %ebx
8010672a:	5e                   	pop    %esi
8010672b:	5f                   	pop    %edi
8010672c:	5d                   	pop    %ebp
8010672d:	c3                   	ret
8010672e:	66 90                	xchg   %ax,%ax
    return -1;
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106735:	eb ef                	jmp    80106726 <argptr+0x56>
80106737:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010673e:	00 
8010673f:	90                   	nop

80106740 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	56                   	push   %esi
80106744:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106745:	e8 a6 e5 ff ff       	call   80104cf0 <myproc>
8010674a:	8b 55 08             	mov    0x8(%ebp),%edx
8010674d:	8b 40 18             	mov    0x18(%eax),%eax
80106750:	8b 40 44             	mov    0x44(%eax),%eax
80106753:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106756:	e8 95 e5 ff ff       	call   80104cf0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010675b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010675e:	8b 00                	mov    (%eax),%eax
80106760:	39 c6                	cmp    %eax,%esi
80106762:	73 44                	jae    801067a8 <argstr+0x68>
80106764:	8d 53 08             	lea    0x8(%ebx),%edx
80106767:	39 d0                	cmp    %edx,%eax
80106769:	72 3d                	jb     801067a8 <argstr+0x68>
  *ip = *(int*)(addr);
8010676b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010676e:	e8 7d e5 ff ff       	call   80104cf0 <myproc>
  if(addr >= curproc->sz)
80106773:	3b 18                	cmp    (%eax),%ebx
80106775:	73 31                	jae    801067a8 <argstr+0x68>
  *pp = (char*)addr;
80106777:	8b 55 0c             	mov    0xc(%ebp),%edx
8010677a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010677c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010677e:	39 d3                	cmp    %edx,%ebx
80106780:	73 26                	jae    801067a8 <argstr+0x68>
80106782:	89 d8                	mov    %ebx,%eax
80106784:	eb 11                	jmp    80106797 <argstr+0x57>
80106786:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010678d:	00 
8010678e:	66 90                	xchg   %ax,%ax
80106790:	83 c0 01             	add    $0x1,%eax
80106793:	39 d0                	cmp    %edx,%eax
80106795:	73 11                	jae    801067a8 <argstr+0x68>
    if(*s == 0)
80106797:	80 38 00             	cmpb   $0x0,(%eax)
8010679a:	75 f4                	jne    80106790 <argstr+0x50>
      return s - *pp;
8010679c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010679e:	5b                   	pop    %ebx
8010679f:	5e                   	pop    %esi
801067a0:	5d                   	pop    %ebp
801067a1:	c3                   	ret
801067a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067a8:	5b                   	pop    %ebx
    return -1;
801067a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067ae:	5e                   	pop    %esi
801067af:	5d                   	pop    %ebp
801067b0:	c3                   	ret
801067b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067b8:	00 
801067b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067c0 <syscall>:
[SYS_set_proc_sjf_params] sys_set_proc_sjf_params,
};

void
syscall(void)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	56                   	push   %esi
801067c4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801067c5:	e8 26 e5 ff ff       	call   80104cf0 <myproc>
801067ca:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801067cc:	8b 40 18             	mov    0x18(%eax),%eax
801067cf:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801067d2:	8d 46 ff             	lea    -0x1(%esi),%eax
801067d5:	83 f8 1e             	cmp    $0x1e,%eax
801067d8:	77 26                	ja     80106800 <syscall+0x40>
801067da:	8b 04 b5 60 9e 10 80 	mov    -0x7fef61a0(,%esi,4),%eax
801067e1:	85 c0                	test   %eax,%eax
801067e3:	74 1b                	je     80106800 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801067e5:	ff d0                	call   *%eax
801067e7:	89 c2                	mov    %eax,%edx
801067e9:	8b 43 18             	mov    0x18(%ebx),%eax
801067ec:	89 50 1c             	mov    %edx,0x1c(%eax)
    cprintf("%d\n" , num);
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801067ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067f2:	5b                   	pop    %ebx
801067f3:	5e                   	pop    %esi
801067f4:	5d                   	pop    %ebp
801067f5:	c3                   	ret
801067f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067fd:	00 
801067fe:	66 90                	xchg   %ax,%ax
    cprintf("%d\n" , num);
80106800:	83 ec 08             	sub    $0x8,%esp
80106803:	56                   	push   %esi
80106804:	68 8b 94 10 80       	push   $0x8010948b
80106809:	e8 d2 9f ff ff       	call   801007e0 <cprintf>
            curproc->pid, curproc->name, num);
8010680e:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106811:	56                   	push   %esi
80106812:	50                   	push   %eax
80106813:	ff 73 10             	push   0x10(%ebx)
80106816:	68 61 96 10 80       	push   $0x80109661
8010681b:	e8 c0 9f ff ff       	call   801007e0 <cprintf>
    curproc->tf->eax = -1;
80106820:	8b 43 18             	mov    0x18(%ebx),%eax
80106823:	83 c4 20             	add    $0x20,%esp
80106826:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010682d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106830:	5b                   	pop    %ebx
80106831:	5e                   	pop    %esi
80106832:	5d                   	pop    %ebp
80106833:	c3                   	ret
80106834:	66 90                	xchg   %ax,%ax
80106836:	66 90                	xchg   %ax,%ax
80106838:	66 90                	xchg   %ax,%ax
8010683a:	66 90                	xchg   %ax,%ax
8010683c:	66 90                	xchg   %ax,%ax
8010683e:	66 90                	xchg   %ax,%ax

80106840 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106845:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106848:	53                   	push   %ebx
80106849:	83 ec 34             	sub    $0x34,%esp
8010684c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010684f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106852:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106855:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80106858:	57                   	push   %edi
80106859:	50                   	push   %eax
8010685a:	e8 81 cb ff ff       	call   801033e0 <nameiparent>
8010685f:	83 c4 10             	add    $0x10,%esp
80106862:	85 c0                	test   %eax,%eax
80106864:	74 5e                	je     801068c4 <create+0x84>
    return 0;
  ilock(dp);
80106866:	83 ec 0c             	sub    $0xc,%esp
80106869:	89 c3                	mov    %eax,%ebx
8010686b:	50                   	push   %eax
8010686c:	e8 6f c2 ff ff       	call   80102ae0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80106871:	83 c4 0c             	add    $0xc,%esp
80106874:	6a 00                	push   $0x0
80106876:	57                   	push   %edi
80106877:	53                   	push   %ebx
80106878:	e8 b3 c7 ff ff       	call   80103030 <dirlookup>
8010687d:	83 c4 10             	add    $0x10,%esp
80106880:	89 c6                	mov    %eax,%esi
80106882:	85 c0                	test   %eax,%eax
80106884:	74 4a                	je     801068d0 <create+0x90>
    iunlockput(dp);
80106886:	83 ec 0c             	sub    $0xc,%esp
80106889:	53                   	push   %ebx
8010688a:	e8 e1 c4 ff ff       	call   80102d70 <iunlockput>
    ilock(ip);
8010688f:	89 34 24             	mov    %esi,(%esp)
80106892:	e8 49 c2 ff ff       	call   80102ae0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80106897:	83 c4 10             	add    $0x10,%esp
8010689a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010689f:	75 17                	jne    801068b8 <create+0x78>
801068a1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801068a6:	75 10                	jne    801068b8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801068a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ab:	89 f0                	mov    %esi,%eax
801068ad:	5b                   	pop    %ebx
801068ae:	5e                   	pop    %esi
801068af:	5f                   	pop    %edi
801068b0:	5d                   	pop    %ebp
801068b1:	c3                   	ret
801068b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801068b8:	83 ec 0c             	sub    $0xc,%esp
801068bb:	56                   	push   %esi
801068bc:	e8 af c4 ff ff       	call   80102d70 <iunlockput>
    return 0;
801068c1:	83 c4 10             	add    $0x10,%esp
}
801068c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801068c7:	31 f6                	xor    %esi,%esi
}
801068c9:	5b                   	pop    %ebx
801068ca:	89 f0                	mov    %esi,%eax
801068cc:	5e                   	pop    %esi
801068cd:	5f                   	pop    %edi
801068ce:	5d                   	pop    %ebp
801068cf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
801068d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801068d4:	83 ec 08             	sub    $0x8,%esp
801068d7:	50                   	push   %eax
801068d8:	ff 33                	push   (%ebx)
801068da:	e8 91 c0 ff ff       	call   80102970 <ialloc>
801068df:	83 c4 10             	add    $0x10,%esp
801068e2:	89 c6                	mov    %eax,%esi
801068e4:	85 c0                	test   %eax,%eax
801068e6:	0f 84 bc 00 00 00    	je     801069a8 <create+0x168>
  ilock(ip);
801068ec:	83 ec 0c             	sub    $0xc,%esp
801068ef:	50                   	push   %eax
801068f0:	e8 eb c1 ff ff       	call   80102ae0 <ilock>
  ip->major = major;
801068f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801068f9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801068fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106901:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106905:	b8 01 00 00 00       	mov    $0x1,%eax
8010690a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010690e:	89 34 24             	mov    %esi,(%esp)
80106911:	e8 1a c1 ff ff       	call   80102a30 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106916:	83 c4 10             	add    $0x10,%esp
80106919:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010691e:	74 30                	je     80106950 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80106920:	83 ec 04             	sub    $0x4,%esp
80106923:	ff 76 04             	push   0x4(%esi)
80106926:	57                   	push   %edi
80106927:	53                   	push   %ebx
80106928:	e8 d3 c9 ff ff       	call   80103300 <dirlink>
8010692d:	83 c4 10             	add    $0x10,%esp
80106930:	85 c0                	test   %eax,%eax
80106932:	78 67                	js     8010699b <create+0x15b>
  iunlockput(dp);
80106934:	83 ec 0c             	sub    $0xc,%esp
80106937:	53                   	push   %ebx
80106938:	e8 33 c4 ff ff       	call   80102d70 <iunlockput>
  return ip;
8010693d:	83 c4 10             	add    $0x10,%esp
}
80106940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106943:	89 f0                	mov    %esi,%eax
80106945:	5b                   	pop    %ebx
80106946:	5e                   	pop    %esi
80106947:	5f                   	pop    %edi
80106948:	5d                   	pop    %ebp
80106949:	c3                   	ret
8010694a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106950:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80106953:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106958:	53                   	push   %ebx
80106959:	e8 d2 c0 ff ff       	call   80102a30 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010695e:	83 c4 0c             	add    $0xc,%esp
80106961:	ff 76 04             	push   0x4(%esi)
80106964:	68 99 96 10 80       	push   $0x80109699
80106969:	56                   	push   %esi
8010696a:	e8 91 c9 ff ff       	call   80103300 <dirlink>
8010696f:	83 c4 10             	add    $0x10,%esp
80106972:	85 c0                	test   %eax,%eax
80106974:	78 18                	js     8010698e <create+0x14e>
80106976:	83 ec 04             	sub    $0x4,%esp
80106979:	ff 73 04             	push   0x4(%ebx)
8010697c:	68 98 96 10 80       	push   $0x80109698
80106981:	56                   	push   %esi
80106982:	e8 79 c9 ff ff       	call   80103300 <dirlink>
80106987:	83 c4 10             	add    $0x10,%esp
8010698a:	85 c0                	test   %eax,%eax
8010698c:	79 92                	jns    80106920 <create+0xe0>
      panic("create dots");
8010698e:	83 ec 0c             	sub    $0xc,%esp
80106991:	68 8c 96 10 80       	push   $0x8010968c
80106996:	e8 b5 9a ff ff       	call   80100450 <panic>
    panic("create: dirlink");
8010699b:	83 ec 0c             	sub    $0xc,%esp
8010699e:	68 9b 96 10 80       	push   $0x8010969b
801069a3:	e8 a8 9a ff ff       	call   80100450 <panic>
    panic("create: ialloc");
801069a8:	83 ec 0c             	sub    $0xc,%esp
801069ab:	68 7d 96 10 80       	push   $0x8010967d
801069b0:	e8 9b 9a ff ff       	call   80100450 <panic>
801069b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801069bc:	00 
801069bd:	8d 76 00             	lea    0x0(%esi),%esi

801069c0 <sys_dup>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	56                   	push   %esi
801069c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801069c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801069cb:	50                   	push   %eax
801069cc:	6a 00                	push   $0x0
801069ce:	e8 ad fc ff ff       	call   80106680 <argint>
801069d3:	83 c4 10             	add    $0x10,%esp
801069d6:	85 c0                	test   %eax,%eax
801069d8:	78 36                	js     80106a10 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801069da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801069de:	77 30                	ja     80106a10 <sys_dup+0x50>
801069e0:	e8 0b e3 ff ff       	call   80104cf0 <myproc>
801069e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801069ec:	85 f6                	test   %esi,%esi
801069ee:	74 20                	je     80106a10 <sys_dup+0x50>
  struct proc *curproc = myproc();
801069f0:	e8 fb e2 ff ff       	call   80104cf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801069f5:	31 db                	xor    %ebx,%ebx
801069f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801069fe:	00 
801069ff:	90                   	nop
    if(curproc->ofile[fd] == 0){
80106a00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106a04:	85 d2                	test   %edx,%edx
80106a06:	74 18                	je     80106a20 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80106a08:	83 c3 01             	add    $0x1,%ebx
80106a0b:	83 fb 10             	cmp    $0x10,%ebx
80106a0e:	75 f0                	jne    80106a00 <sys_dup+0x40>
}
80106a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80106a13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106a18:	89 d8                	mov    %ebx,%eax
80106a1a:	5b                   	pop    %ebx
80106a1b:	5e                   	pop    %esi
80106a1c:	5d                   	pop    %ebp
80106a1d:	c3                   	ret
80106a1e:	66 90                	xchg   %ax,%ax
  filedup(f);
80106a20:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106a23:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106a27:	56                   	push   %esi
80106a28:	e8 d3 b7 ff ff       	call   80102200 <filedup>
  return fd;
80106a2d:	83 c4 10             	add    $0x10,%esp
}
80106a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a33:	89 d8                	mov    %ebx,%eax
80106a35:	5b                   	pop    %ebx
80106a36:	5e                   	pop    %esi
80106a37:	5d                   	pop    %ebp
80106a38:	c3                   	ret
80106a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a40 <sys_read>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	56                   	push   %esi
80106a44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106a45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106a48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106a4b:	53                   	push   %ebx
80106a4c:	6a 00                	push   $0x0
80106a4e:	e8 2d fc ff ff       	call   80106680 <argint>
80106a53:	83 c4 10             	add    $0x10,%esp
80106a56:	85 c0                	test   %eax,%eax
80106a58:	78 5e                	js     80106ab8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106a5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106a5e:	77 58                	ja     80106ab8 <sys_read+0x78>
80106a60:	e8 8b e2 ff ff       	call   80104cf0 <myproc>
80106a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106a6c:	85 f6                	test   %esi,%esi
80106a6e:	74 48                	je     80106ab8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a70:	83 ec 08             	sub    $0x8,%esp
80106a73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a76:	50                   	push   %eax
80106a77:	6a 02                	push   $0x2
80106a79:	e8 02 fc ff ff       	call   80106680 <argint>
80106a7e:	83 c4 10             	add    $0x10,%esp
80106a81:	85 c0                	test   %eax,%eax
80106a83:	78 33                	js     80106ab8 <sys_read+0x78>
80106a85:	83 ec 04             	sub    $0x4,%esp
80106a88:	ff 75 f0             	push   -0x10(%ebp)
80106a8b:	53                   	push   %ebx
80106a8c:	6a 01                	push   $0x1
80106a8e:	e8 3d fc ff ff       	call   801066d0 <argptr>
80106a93:	83 c4 10             	add    $0x10,%esp
80106a96:	85 c0                	test   %eax,%eax
80106a98:	78 1e                	js     80106ab8 <sys_read+0x78>
  return fileread(f, p, n);
80106a9a:	83 ec 04             	sub    $0x4,%esp
80106a9d:	ff 75 f0             	push   -0x10(%ebp)
80106aa0:	ff 75 f4             	push   -0xc(%ebp)
80106aa3:	56                   	push   %esi
80106aa4:	e8 d7 b8 ff ff       	call   80102380 <fileread>
80106aa9:	83 c4 10             	add    $0x10,%esp
}
80106aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106aaf:	5b                   	pop    %ebx
80106ab0:	5e                   	pop    %esi
80106ab1:	5d                   	pop    %ebp
80106ab2:	c3                   	ret
80106ab3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106abd:	eb ed                	jmp    80106aac <sys_read+0x6c>
80106abf:	90                   	nop

80106ac0 <sys_write>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	56                   	push   %esi
80106ac4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106ac5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106ac8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106acb:	53                   	push   %ebx
80106acc:	6a 00                	push   $0x0
80106ace:	e8 ad fb ff ff       	call   80106680 <argint>
80106ad3:	83 c4 10             	add    $0x10,%esp
80106ad6:	85 c0                	test   %eax,%eax
80106ad8:	78 5e                	js     80106b38 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106ada:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106ade:	77 58                	ja     80106b38 <sys_write+0x78>
80106ae0:	e8 0b e2 ff ff       	call   80104cf0 <myproc>
80106ae5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ae8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106aec:	85 f6                	test   %esi,%esi
80106aee:	74 48                	je     80106b38 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106af0:	83 ec 08             	sub    $0x8,%esp
80106af3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106af6:	50                   	push   %eax
80106af7:	6a 02                	push   $0x2
80106af9:	e8 82 fb ff ff       	call   80106680 <argint>
80106afe:	83 c4 10             	add    $0x10,%esp
80106b01:	85 c0                	test   %eax,%eax
80106b03:	78 33                	js     80106b38 <sys_write+0x78>
80106b05:	83 ec 04             	sub    $0x4,%esp
80106b08:	ff 75 f0             	push   -0x10(%ebp)
80106b0b:	53                   	push   %ebx
80106b0c:	6a 01                	push   $0x1
80106b0e:	e8 bd fb ff ff       	call   801066d0 <argptr>
80106b13:	83 c4 10             	add    $0x10,%esp
80106b16:	85 c0                	test   %eax,%eax
80106b18:	78 1e                	js     80106b38 <sys_write+0x78>
  return filewrite(f, p, n);
80106b1a:	83 ec 04             	sub    $0x4,%esp
80106b1d:	ff 75 f0             	push   -0x10(%ebp)
80106b20:	ff 75 f4             	push   -0xc(%ebp)
80106b23:	56                   	push   %esi
80106b24:	e8 e7 b8 ff ff       	call   80102410 <filewrite>
80106b29:	83 c4 10             	add    $0x10,%esp
}
80106b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b2f:	5b                   	pop    %ebx
80106b30:	5e                   	pop    %esi
80106b31:	5d                   	pop    %ebp
80106b32:	c3                   	ret
80106b33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b3d:	eb ed                	jmp    80106b2c <sys_write+0x6c>
80106b3f:	90                   	nop

80106b40 <sys_close>:
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	56                   	push   %esi
80106b44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106b45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106b48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106b4b:	50                   	push   %eax
80106b4c:	6a 00                	push   $0x0
80106b4e:	e8 2d fb ff ff       	call   80106680 <argint>
80106b53:	83 c4 10             	add    $0x10,%esp
80106b56:	85 c0                	test   %eax,%eax
80106b58:	78 3e                	js     80106b98 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106b5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106b5e:	77 38                	ja     80106b98 <sys_close+0x58>
80106b60:	e8 8b e1 ff ff       	call   80104cf0 <myproc>
80106b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b68:	8d 5a 08             	lea    0x8(%edx),%ebx
80106b6b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80106b6f:	85 f6                	test   %esi,%esi
80106b71:	74 25                	je     80106b98 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106b73:	e8 78 e1 ff ff       	call   80104cf0 <myproc>
  fileclose(f);
80106b78:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106b7b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106b82:	00 
  fileclose(f);
80106b83:	56                   	push   %esi
80106b84:	e8 c7 b6 ff ff       	call   80102250 <fileclose>
  return 0;
80106b89:	83 c4 10             	add    $0x10,%esp
80106b8c:	31 c0                	xor    %eax,%eax
}
80106b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b91:	5b                   	pop    %ebx
80106b92:	5e                   	pop    %esi
80106b93:	5d                   	pop    %ebp
80106b94:	c3                   	ret
80106b95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9d:	eb ef                	jmp    80106b8e <sys_close+0x4e>
80106b9f:	90                   	nop

80106ba0 <sys_fstat>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	56                   	push   %esi
80106ba4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106ba5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106ba8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106bab:	53                   	push   %ebx
80106bac:	6a 00                	push   $0x0
80106bae:	e8 cd fa ff ff       	call   80106680 <argint>
80106bb3:	83 c4 10             	add    $0x10,%esp
80106bb6:	85 c0                	test   %eax,%eax
80106bb8:	78 46                	js     80106c00 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106bba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106bbe:	77 40                	ja     80106c00 <sys_fstat+0x60>
80106bc0:	e8 2b e1 ff ff       	call   80104cf0 <myproc>
80106bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106bcc:	85 f6                	test   %esi,%esi
80106bce:	74 30                	je     80106c00 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106bd0:	83 ec 04             	sub    $0x4,%esp
80106bd3:	6a 14                	push   $0x14
80106bd5:	53                   	push   %ebx
80106bd6:	6a 01                	push   $0x1
80106bd8:	e8 f3 fa ff ff       	call   801066d0 <argptr>
80106bdd:	83 c4 10             	add    $0x10,%esp
80106be0:	85 c0                	test   %eax,%eax
80106be2:	78 1c                	js     80106c00 <sys_fstat+0x60>
  return filestat(f, st);
80106be4:	83 ec 08             	sub    $0x8,%esp
80106be7:	ff 75 f4             	push   -0xc(%ebp)
80106bea:	56                   	push   %esi
80106beb:	e8 40 b7 ff ff       	call   80102330 <filestat>
80106bf0:	83 c4 10             	add    $0x10,%esp
}
80106bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106bf6:	5b                   	pop    %ebx
80106bf7:	5e                   	pop    %esi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c05:	eb ec                	jmp    80106bf3 <sys_fstat+0x53>
80106c07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c0e:	00 
80106c0f:	90                   	nop

80106c10 <sys_link>:
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c15:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106c18:	53                   	push   %ebx
80106c19:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c1c:	50                   	push   %eax
80106c1d:	6a 00                	push   $0x0
80106c1f:	e8 1c fb ff ff       	call   80106740 <argstr>
80106c24:	83 c4 10             	add    $0x10,%esp
80106c27:	85 c0                	test   %eax,%eax
80106c29:	0f 88 fb 00 00 00    	js     80106d2a <sys_link+0x11a>
80106c2f:	83 ec 08             	sub    $0x8,%esp
80106c32:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106c35:	50                   	push   %eax
80106c36:	6a 01                	push   $0x1
80106c38:	e8 03 fb ff ff       	call   80106740 <argstr>
80106c3d:	83 c4 10             	add    $0x10,%esp
80106c40:	85 c0                	test   %eax,%eax
80106c42:	0f 88 e2 00 00 00    	js     80106d2a <sys_link+0x11a>
  begin_op();
80106c48:	e8 33 d4 ff ff       	call   80104080 <begin_op>
  if((ip = namei(old)) == 0){
80106c4d:	83 ec 0c             	sub    $0xc,%esp
80106c50:	ff 75 d4             	push   -0x2c(%ebp)
80106c53:	e8 68 c7 ff ff       	call   801033c0 <namei>
80106c58:	83 c4 10             	add    $0x10,%esp
80106c5b:	89 c3                	mov    %eax,%ebx
80106c5d:	85 c0                	test   %eax,%eax
80106c5f:	0f 84 df 00 00 00    	je     80106d44 <sys_link+0x134>
  ilock(ip);
80106c65:	83 ec 0c             	sub    $0xc,%esp
80106c68:	50                   	push   %eax
80106c69:	e8 72 be ff ff       	call   80102ae0 <ilock>
  if(ip->type == T_DIR){
80106c6e:	83 c4 10             	add    $0x10,%esp
80106c71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106c76:	0f 84 b5 00 00 00    	je     80106d31 <sys_link+0x121>
  iupdate(ip);
80106c7c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106c7f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106c84:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106c87:	53                   	push   %ebx
80106c88:	e8 a3 bd ff ff       	call   80102a30 <iupdate>
  iunlock(ip);
80106c8d:	89 1c 24             	mov    %ebx,(%esp)
80106c90:	e8 2b bf ff ff       	call   80102bc0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106c95:	58                   	pop    %eax
80106c96:	5a                   	pop    %edx
80106c97:	57                   	push   %edi
80106c98:	ff 75 d0             	push   -0x30(%ebp)
80106c9b:	e8 40 c7 ff ff       	call   801033e0 <nameiparent>
80106ca0:	83 c4 10             	add    $0x10,%esp
80106ca3:	89 c6                	mov    %eax,%esi
80106ca5:	85 c0                	test   %eax,%eax
80106ca7:	74 5b                	je     80106d04 <sys_link+0xf4>
  ilock(dp);
80106ca9:	83 ec 0c             	sub    $0xc,%esp
80106cac:	50                   	push   %eax
80106cad:	e8 2e be ff ff       	call   80102ae0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106cb2:	8b 03                	mov    (%ebx),%eax
80106cb4:	83 c4 10             	add    $0x10,%esp
80106cb7:	39 06                	cmp    %eax,(%esi)
80106cb9:	75 3d                	jne    80106cf8 <sys_link+0xe8>
80106cbb:	83 ec 04             	sub    $0x4,%esp
80106cbe:	ff 73 04             	push   0x4(%ebx)
80106cc1:	57                   	push   %edi
80106cc2:	56                   	push   %esi
80106cc3:	e8 38 c6 ff ff       	call   80103300 <dirlink>
80106cc8:	83 c4 10             	add    $0x10,%esp
80106ccb:	85 c0                	test   %eax,%eax
80106ccd:	78 29                	js     80106cf8 <sys_link+0xe8>
  iunlockput(dp);
80106ccf:	83 ec 0c             	sub    $0xc,%esp
80106cd2:	56                   	push   %esi
80106cd3:	e8 98 c0 ff ff       	call   80102d70 <iunlockput>
  iput(ip);
80106cd8:	89 1c 24             	mov    %ebx,(%esp)
80106cdb:	e8 30 bf ff ff       	call   80102c10 <iput>
  end_op();
80106ce0:	e8 0b d4 ff ff       	call   801040f0 <end_op>
  return 0;
80106ce5:	83 c4 10             	add    $0x10,%esp
80106ce8:	31 c0                	xor    %eax,%eax
}
80106cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ced:	5b                   	pop    %ebx
80106cee:	5e                   	pop    %esi
80106cef:	5f                   	pop    %edi
80106cf0:	5d                   	pop    %ebp
80106cf1:	c3                   	ret
80106cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106cf8:	83 ec 0c             	sub    $0xc,%esp
80106cfb:	56                   	push   %esi
80106cfc:	e8 6f c0 ff ff       	call   80102d70 <iunlockput>
    goto bad;
80106d01:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106d04:	83 ec 0c             	sub    $0xc,%esp
80106d07:	53                   	push   %ebx
80106d08:	e8 d3 bd ff ff       	call   80102ae0 <ilock>
  ip->nlink--;
80106d0d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106d12:	89 1c 24             	mov    %ebx,(%esp)
80106d15:	e8 16 bd ff ff       	call   80102a30 <iupdate>
  iunlockput(ip);
80106d1a:	89 1c 24             	mov    %ebx,(%esp)
80106d1d:	e8 4e c0 ff ff       	call   80102d70 <iunlockput>
  end_op();
80106d22:	e8 c9 d3 ff ff       	call   801040f0 <end_op>
  return -1;
80106d27:	83 c4 10             	add    $0x10,%esp
    return -1;
80106d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d2f:	eb b9                	jmp    80106cea <sys_link+0xda>
    iunlockput(ip);
80106d31:	83 ec 0c             	sub    $0xc,%esp
80106d34:	53                   	push   %ebx
80106d35:	e8 36 c0 ff ff       	call   80102d70 <iunlockput>
    end_op();
80106d3a:	e8 b1 d3 ff ff       	call   801040f0 <end_op>
    return -1;
80106d3f:	83 c4 10             	add    $0x10,%esp
80106d42:	eb e6                	jmp    80106d2a <sys_link+0x11a>
    end_op();
80106d44:	e8 a7 d3 ff ff       	call   801040f0 <end_op>
    return -1;
80106d49:	eb df                	jmp    80106d2a <sys_link+0x11a>
80106d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d50 <sys_unlink>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106d55:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106d58:	53                   	push   %ebx
80106d59:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106d5c:	50                   	push   %eax
80106d5d:	6a 00                	push   $0x0
80106d5f:	e8 dc f9 ff ff       	call   80106740 <argstr>
80106d64:	83 c4 10             	add    $0x10,%esp
80106d67:	85 c0                	test   %eax,%eax
80106d69:	0f 88 54 01 00 00    	js     80106ec3 <sys_unlink+0x173>
  begin_op();
80106d6f:	e8 0c d3 ff ff       	call   80104080 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106d74:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106d77:	83 ec 08             	sub    $0x8,%esp
80106d7a:	53                   	push   %ebx
80106d7b:	ff 75 c0             	push   -0x40(%ebp)
80106d7e:	e8 5d c6 ff ff       	call   801033e0 <nameiparent>
80106d83:	83 c4 10             	add    $0x10,%esp
80106d86:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106d89:	85 c0                	test   %eax,%eax
80106d8b:	0f 84 58 01 00 00    	je     80106ee9 <sys_unlink+0x199>
  ilock(dp);
80106d91:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106d94:	83 ec 0c             	sub    $0xc,%esp
80106d97:	57                   	push   %edi
80106d98:	e8 43 bd ff ff       	call   80102ae0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106d9d:	58                   	pop    %eax
80106d9e:	5a                   	pop    %edx
80106d9f:	68 99 96 10 80       	push   $0x80109699
80106da4:	53                   	push   %ebx
80106da5:	e8 66 c2 ff ff       	call   80103010 <namecmp>
80106daa:	83 c4 10             	add    $0x10,%esp
80106dad:	85 c0                	test   %eax,%eax
80106daf:	0f 84 fb 00 00 00    	je     80106eb0 <sys_unlink+0x160>
80106db5:	83 ec 08             	sub    $0x8,%esp
80106db8:	68 98 96 10 80       	push   $0x80109698
80106dbd:	53                   	push   %ebx
80106dbe:	e8 4d c2 ff ff       	call   80103010 <namecmp>
80106dc3:	83 c4 10             	add    $0x10,%esp
80106dc6:	85 c0                	test   %eax,%eax
80106dc8:	0f 84 e2 00 00 00    	je     80106eb0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80106dce:	83 ec 04             	sub    $0x4,%esp
80106dd1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106dd4:	50                   	push   %eax
80106dd5:	53                   	push   %ebx
80106dd6:	57                   	push   %edi
80106dd7:	e8 54 c2 ff ff       	call   80103030 <dirlookup>
80106ddc:	83 c4 10             	add    $0x10,%esp
80106ddf:	89 c3                	mov    %eax,%ebx
80106de1:	85 c0                	test   %eax,%eax
80106de3:	0f 84 c7 00 00 00    	je     80106eb0 <sys_unlink+0x160>
  ilock(ip);
80106de9:	83 ec 0c             	sub    $0xc,%esp
80106dec:	50                   	push   %eax
80106ded:	e8 ee bc ff ff       	call   80102ae0 <ilock>
  if(ip->nlink < 1)
80106df2:	83 c4 10             	add    $0x10,%esp
80106df5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106dfa:	0f 8e 0a 01 00 00    	jle    80106f0a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106e00:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106e05:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106e08:	74 66                	je     80106e70 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106e0a:	83 ec 04             	sub    $0x4,%esp
80106e0d:	6a 10                	push   $0x10
80106e0f:	6a 00                	push   $0x0
80106e11:	57                   	push   %edi
80106e12:	e8 b9 f5 ff ff       	call   801063d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e17:	6a 10                	push   $0x10
80106e19:	ff 75 c4             	push   -0x3c(%ebp)
80106e1c:	57                   	push   %edi
80106e1d:	ff 75 b4             	push   -0x4c(%ebp)
80106e20:	e8 cb c0 ff ff       	call   80102ef0 <writei>
80106e25:	83 c4 20             	add    $0x20,%esp
80106e28:	83 f8 10             	cmp    $0x10,%eax
80106e2b:	0f 85 cc 00 00 00    	jne    80106efd <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80106e31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106e36:	0f 84 94 00 00 00    	je     80106ed0 <sys_unlink+0x180>
  iunlockput(dp);
80106e3c:	83 ec 0c             	sub    $0xc,%esp
80106e3f:	ff 75 b4             	push   -0x4c(%ebp)
80106e42:	e8 29 bf ff ff       	call   80102d70 <iunlockput>
  ip->nlink--;
80106e47:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106e4c:	89 1c 24             	mov    %ebx,(%esp)
80106e4f:	e8 dc bb ff ff       	call   80102a30 <iupdate>
  iunlockput(ip);
80106e54:	89 1c 24             	mov    %ebx,(%esp)
80106e57:	e8 14 bf ff ff       	call   80102d70 <iunlockput>
  end_op();
80106e5c:	e8 8f d2 ff ff       	call   801040f0 <end_op>
  return 0;
80106e61:	83 c4 10             	add    $0x10,%esp
80106e64:	31 c0                	xor    %eax,%eax
}
80106e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e69:	5b                   	pop    %ebx
80106e6a:	5e                   	pop    %esi
80106e6b:	5f                   	pop    %edi
80106e6c:	5d                   	pop    %ebp
80106e6d:	c3                   	ret
80106e6e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e70:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106e74:	76 94                	jbe    80106e0a <sys_unlink+0xba>
80106e76:	be 20 00 00 00       	mov    $0x20,%esi
80106e7b:	eb 0b                	jmp    80106e88 <sys_unlink+0x138>
80106e7d:	8d 76 00             	lea    0x0(%esi),%esi
80106e80:	83 c6 10             	add    $0x10,%esi
80106e83:	3b 73 58             	cmp    0x58(%ebx),%esi
80106e86:	73 82                	jae    80106e0a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e88:	6a 10                	push   $0x10
80106e8a:	56                   	push   %esi
80106e8b:	57                   	push   %edi
80106e8c:	53                   	push   %ebx
80106e8d:	e8 5e bf ff ff       	call   80102df0 <readi>
80106e92:	83 c4 10             	add    $0x10,%esp
80106e95:	83 f8 10             	cmp    $0x10,%eax
80106e98:	75 56                	jne    80106ef0 <sys_unlink+0x1a0>
    if(de.inum != 0)
80106e9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106e9f:	74 df                	je     80106e80 <sys_unlink+0x130>
    iunlockput(ip);
80106ea1:	83 ec 0c             	sub    $0xc,%esp
80106ea4:	53                   	push   %ebx
80106ea5:	e8 c6 be ff ff       	call   80102d70 <iunlockput>
    goto bad;
80106eaa:	83 c4 10             	add    $0x10,%esp
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106eb0:	83 ec 0c             	sub    $0xc,%esp
80106eb3:	ff 75 b4             	push   -0x4c(%ebp)
80106eb6:	e8 b5 be ff ff       	call   80102d70 <iunlockput>
  end_op();
80106ebb:	e8 30 d2 ff ff       	call   801040f0 <end_op>
  return -1;
80106ec0:	83 c4 10             	add    $0x10,%esp
    return -1;
80106ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ec8:	eb 9c                	jmp    80106e66 <sys_unlink+0x116>
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106ed0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106ed3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106ed6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80106edb:	50                   	push   %eax
80106edc:	e8 4f bb ff ff       	call   80102a30 <iupdate>
80106ee1:	83 c4 10             	add    $0x10,%esp
80106ee4:	e9 53 ff ff ff       	jmp    80106e3c <sys_unlink+0xec>
    end_op();
80106ee9:	e8 02 d2 ff ff       	call   801040f0 <end_op>
    return -1;
80106eee:	eb d3                	jmp    80106ec3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80106ef0:	83 ec 0c             	sub    $0xc,%esp
80106ef3:	68 bd 96 10 80       	push   $0x801096bd
80106ef8:	e8 53 95 ff ff       	call   80100450 <panic>
    panic("unlink: writei");
80106efd:	83 ec 0c             	sub    $0xc,%esp
80106f00:	68 cf 96 10 80       	push   $0x801096cf
80106f05:	e8 46 95 ff ff       	call   80100450 <panic>
    panic("unlink: nlink < 1");
80106f0a:	83 ec 0c             	sub    $0xc,%esp
80106f0d:	68 ab 96 10 80       	push   $0x801096ab
80106f12:	e8 39 95 ff ff       	call   80100450 <panic>
80106f17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f1e:	00 
80106f1f:	90                   	nop

80106f20 <sys_open>:

int
sys_open(void)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106f25:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106f28:	53                   	push   %ebx
80106f29:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106f2c:	50                   	push   %eax
80106f2d:	6a 00                	push   $0x0
80106f2f:	e8 0c f8 ff ff       	call   80106740 <argstr>
80106f34:	83 c4 10             	add    $0x10,%esp
80106f37:	85 c0                	test   %eax,%eax
80106f39:	0f 88 8e 00 00 00    	js     80106fcd <sys_open+0xad>
80106f3f:	83 ec 08             	sub    $0x8,%esp
80106f42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106f45:	50                   	push   %eax
80106f46:	6a 01                	push   $0x1
80106f48:	e8 33 f7 ff ff       	call   80106680 <argint>
80106f4d:	83 c4 10             	add    $0x10,%esp
80106f50:	85 c0                	test   %eax,%eax
80106f52:	78 79                	js     80106fcd <sys_open+0xad>
    return -1;

  begin_op();
80106f54:	e8 27 d1 ff ff       	call   80104080 <begin_op>

  if(omode & O_CREATE){
80106f59:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106f5d:	75 79                	jne    80106fd8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106f5f:	83 ec 0c             	sub    $0xc,%esp
80106f62:	ff 75 e0             	push   -0x20(%ebp)
80106f65:	e8 56 c4 ff ff       	call   801033c0 <namei>
80106f6a:	83 c4 10             	add    $0x10,%esp
80106f6d:	89 c6                	mov    %eax,%esi
80106f6f:	85 c0                	test   %eax,%eax
80106f71:	0f 84 7e 00 00 00    	je     80106ff5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106f77:	83 ec 0c             	sub    $0xc,%esp
80106f7a:	50                   	push   %eax
80106f7b:	e8 60 bb ff ff       	call   80102ae0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106f80:	83 c4 10             	add    $0x10,%esp
80106f83:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106f88:	0f 84 ba 00 00 00    	je     80107048 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106f8e:	e8 fd b1 ff ff       	call   80102190 <filealloc>
80106f93:	89 c7                	mov    %eax,%edi
80106f95:	85 c0                	test   %eax,%eax
80106f97:	74 23                	je     80106fbc <sys_open+0x9c>
  struct proc *curproc = myproc();
80106f99:	e8 52 dd ff ff       	call   80104cf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106f9e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106fa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106fa4:	85 d2                	test   %edx,%edx
80106fa6:	74 58                	je     80107000 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80106fa8:	83 c3 01             	add    $0x1,%ebx
80106fab:	83 fb 10             	cmp    $0x10,%ebx
80106fae:	75 f0                	jne    80106fa0 <sys_open+0x80>
    if(f)
      fileclose(f);
80106fb0:	83 ec 0c             	sub    $0xc,%esp
80106fb3:	57                   	push   %edi
80106fb4:	e8 97 b2 ff ff       	call   80102250 <fileclose>
80106fb9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	56                   	push   %esi
80106fc0:	e8 ab bd ff ff       	call   80102d70 <iunlockput>
    end_op();
80106fc5:	e8 26 d1 ff ff       	call   801040f0 <end_op>
    return -1;
80106fca:	83 c4 10             	add    $0x10,%esp
    return -1;
80106fcd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106fd2:	eb 65                	jmp    80107039 <sys_open+0x119>
80106fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106fd8:	83 ec 0c             	sub    $0xc,%esp
80106fdb:	31 c9                	xor    %ecx,%ecx
80106fdd:	ba 02 00 00 00       	mov    $0x2,%edx
80106fe2:	6a 00                	push   $0x0
80106fe4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fe7:	e8 54 f8 ff ff       	call   80106840 <create>
    if(ip == 0){
80106fec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106fef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106ff1:	85 c0                	test   %eax,%eax
80106ff3:	75 99                	jne    80106f8e <sys_open+0x6e>
      end_op();
80106ff5:	e8 f6 d0 ff ff       	call   801040f0 <end_op>
      return -1;
80106ffa:	eb d1                	jmp    80106fcd <sys_open+0xad>
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80107000:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80107003:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80107007:	56                   	push   %esi
80107008:	e8 b3 bb ff ff       	call   80102bc0 <iunlock>
  end_op();
8010700d:	e8 de d0 ff ff       	call   801040f0 <end_op>

  f->type = FD_INODE;
80107012:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80107018:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010701b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010701e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80107021:	89 d0                	mov    %edx,%eax
  f->off = 0;
80107023:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010702a:	f7 d0                	not    %eax
8010702c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010702f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80107032:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107035:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80107039:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703c:	89 d8                	mov    %ebx,%eax
8010703e:	5b                   	pop    %ebx
8010703f:	5e                   	pop    %esi
80107040:	5f                   	pop    %edi
80107041:	5d                   	pop    %ebp
80107042:	c3                   	ret
80107043:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80107048:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010704b:	85 c9                	test   %ecx,%ecx
8010704d:	0f 84 3b ff ff ff    	je     80106f8e <sys_open+0x6e>
80107053:	e9 64 ff ff ff       	jmp    80106fbc <sys_open+0x9c>
80107058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010705f:	00 

80107060 <sys_mkdir>:

int
sys_mkdir(void)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107066:	e8 15 d0 ff ff       	call   80104080 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010706b:	83 ec 08             	sub    $0x8,%esp
8010706e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107071:	50                   	push   %eax
80107072:	6a 00                	push   $0x0
80107074:	e8 c7 f6 ff ff       	call   80106740 <argstr>
80107079:	83 c4 10             	add    $0x10,%esp
8010707c:	85 c0                	test   %eax,%eax
8010707e:	78 30                	js     801070b0 <sys_mkdir+0x50>
80107080:	83 ec 0c             	sub    $0xc,%esp
80107083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107086:	31 c9                	xor    %ecx,%ecx
80107088:	ba 01 00 00 00       	mov    $0x1,%edx
8010708d:	6a 00                	push   $0x0
8010708f:	e8 ac f7 ff ff       	call   80106840 <create>
80107094:	83 c4 10             	add    $0x10,%esp
80107097:	85 c0                	test   %eax,%eax
80107099:	74 15                	je     801070b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010709b:	83 ec 0c             	sub    $0xc,%esp
8010709e:	50                   	push   %eax
8010709f:	e8 cc bc ff ff       	call   80102d70 <iunlockput>
  end_op();
801070a4:	e8 47 d0 ff ff       	call   801040f0 <end_op>
  return 0;
801070a9:	83 c4 10             	add    $0x10,%esp
801070ac:	31 c0                	xor    %eax,%eax
}
801070ae:	c9                   	leave
801070af:	c3                   	ret
    end_op();
801070b0:	e8 3b d0 ff ff       	call   801040f0 <end_op>
    return -1;
801070b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070ba:	c9                   	leave
801070bb:	c3                   	ret
801070bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070c0 <sys_mknod>:

int
sys_mknod(void)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801070c6:	e8 b5 cf ff ff       	call   80104080 <begin_op>
  if((argstr(0, &path)) < 0 ||
801070cb:	83 ec 08             	sub    $0x8,%esp
801070ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070d1:	50                   	push   %eax
801070d2:	6a 00                	push   $0x0
801070d4:	e8 67 f6 ff ff       	call   80106740 <argstr>
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	85 c0                	test   %eax,%eax
801070de:	78 60                	js     80107140 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801070e0:	83 ec 08             	sub    $0x8,%esp
801070e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070e6:	50                   	push   %eax
801070e7:	6a 01                	push   $0x1
801070e9:	e8 92 f5 ff ff       	call   80106680 <argint>
  if((argstr(0, &path)) < 0 ||
801070ee:	83 c4 10             	add    $0x10,%esp
801070f1:	85 c0                	test   %eax,%eax
801070f3:	78 4b                	js     80107140 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801070f5:	83 ec 08             	sub    $0x8,%esp
801070f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070fb:	50                   	push   %eax
801070fc:	6a 02                	push   $0x2
801070fe:	e8 7d f5 ff ff       	call   80106680 <argint>
     argint(1, &major) < 0 ||
80107103:	83 c4 10             	add    $0x10,%esp
80107106:	85 c0                	test   %eax,%eax
80107108:	78 36                	js     80107140 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010710a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010710e:	83 ec 0c             	sub    $0xc,%esp
80107111:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80107115:	ba 03 00 00 00       	mov    $0x3,%edx
8010711a:	50                   	push   %eax
8010711b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010711e:	e8 1d f7 ff ff       	call   80106840 <create>
     argint(2, &minor) < 0 ||
80107123:	83 c4 10             	add    $0x10,%esp
80107126:	85 c0                	test   %eax,%eax
80107128:	74 16                	je     80107140 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	50                   	push   %eax
8010712e:	e8 3d bc ff ff       	call   80102d70 <iunlockput>
  end_op();
80107133:	e8 b8 cf ff ff       	call   801040f0 <end_op>
  return 0;
80107138:	83 c4 10             	add    $0x10,%esp
8010713b:	31 c0                	xor    %eax,%eax
}
8010713d:	c9                   	leave
8010713e:	c3                   	ret
8010713f:	90                   	nop
    end_op();
80107140:	e8 ab cf ff ff       	call   801040f0 <end_op>
    return -1;
80107145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010714a:	c9                   	leave
8010714b:	c3                   	ret
8010714c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107150 <sys_chdir>:

int
sys_chdir(void)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	56                   	push   %esi
80107154:	53                   	push   %ebx
80107155:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80107158:	e8 93 db ff ff       	call   80104cf0 <myproc>
8010715d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010715f:	e8 1c cf ff ff       	call   80104080 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107164:	83 ec 08             	sub    $0x8,%esp
80107167:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010716a:	50                   	push   %eax
8010716b:	6a 00                	push   $0x0
8010716d:	e8 ce f5 ff ff       	call   80106740 <argstr>
80107172:	83 c4 10             	add    $0x10,%esp
80107175:	85 c0                	test   %eax,%eax
80107177:	78 77                	js     801071f0 <sys_chdir+0xa0>
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	ff 75 f4             	push   -0xc(%ebp)
8010717f:	e8 3c c2 ff ff       	call   801033c0 <namei>
80107184:	83 c4 10             	add    $0x10,%esp
80107187:	89 c3                	mov    %eax,%ebx
80107189:	85 c0                	test   %eax,%eax
8010718b:	74 63                	je     801071f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010718d:	83 ec 0c             	sub    $0xc,%esp
80107190:	50                   	push   %eax
80107191:	e8 4a b9 ff ff       	call   80102ae0 <ilock>
  if(ip->type != T_DIR){
80107196:	83 c4 10             	add    $0x10,%esp
80107199:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010719e:	75 30                	jne    801071d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	53                   	push   %ebx
801071a4:	e8 17 ba ff ff       	call   80102bc0 <iunlock>
  iput(curproc->cwd);
801071a9:	58                   	pop    %eax
801071aa:	ff 76 68             	push   0x68(%esi)
801071ad:	e8 5e ba ff ff       	call   80102c10 <iput>
  end_op();
801071b2:	e8 39 cf ff ff       	call   801040f0 <end_op>
  curproc->cwd = ip;
801071b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801071ba:	83 c4 10             	add    $0x10,%esp
801071bd:	31 c0                	xor    %eax,%eax
}
801071bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071c2:	5b                   	pop    %ebx
801071c3:	5e                   	pop    %esi
801071c4:	5d                   	pop    %ebp
801071c5:	c3                   	ret
801071c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071cd:	00 
801071ce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	53                   	push   %ebx
801071d4:	e8 97 bb ff ff       	call   80102d70 <iunlockput>
    end_op();
801071d9:	e8 12 cf ff ff       	call   801040f0 <end_op>
    return -1;
801071de:	83 c4 10             	add    $0x10,%esp
    return -1;
801071e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e6:	eb d7                	jmp    801071bf <sys_chdir+0x6f>
801071e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ef:	00 
    end_op();
801071f0:	e8 fb ce ff ff       	call   801040f0 <end_op>
    return -1;
801071f5:	eb ea                	jmp    801071e1 <sys_chdir+0x91>
801071f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071fe:	00 
801071ff:	90                   	nop

80107200 <sys_exec>:

int
sys_exec(void)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107205:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010720b:	53                   	push   %ebx
8010720c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107212:	50                   	push   %eax
80107213:	6a 00                	push   $0x0
80107215:	e8 26 f5 ff ff       	call   80106740 <argstr>
8010721a:	83 c4 10             	add    $0x10,%esp
8010721d:	85 c0                	test   %eax,%eax
8010721f:	0f 88 87 00 00 00    	js     801072ac <sys_exec+0xac>
80107225:	83 ec 08             	sub    $0x8,%esp
80107228:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010722e:	50                   	push   %eax
8010722f:	6a 01                	push   $0x1
80107231:	e8 4a f4 ff ff       	call   80106680 <argint>
80107236:	83 c4 10             	add    $0x10,%esp
80107239:	85 c0                	test   %eax,%eax
8010723b:	78 6f                	js     801072ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010723d:	83 ec 04             	sub    $0x4,%esp
80107240:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80107246:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80107248:	68 80 00 00 00       	push   $0x80
8010724d:	6a 00                	push   $0x0
8010724f:	56                   	push   %esi
80107250:	e8 7b f1 ff ff       	call   801063d0 <memset>
80107255:	83 c4 10             	add    $0x10,%esp
80107258:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010725f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107260:	83 ec 08             	sub    $0x8,%esp
80107263:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80107269:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80107270:	50                   	push   %eax
80107271:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80107277:	01 f8                	add    %edi,%eax
80107279:	50                   	push   %eax
8010727a:	e8 71 f3 ff ff       	call   801065f0 <fetchint>
8010727f:	83 c4 10             	add    $0x10,%esp
80107282:	85 c0                	test   %eax,%eax
80107284:	78 26                	js     801072ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80107286:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010728c:	85 c0                	test   %eax,%eax
8010728e:	74 30                	je     801072c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107290:	83 ec 08             	sub    $0x8,%esp
80107293:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80107296:	52                   	push   %edx
80107297:	50                   	push   %eax
80107298:	e8 93 f3 ff ff       	call   80106630 <fetchstr>
8010729d:	83 c4 10             	add    $0x10,%esp
801072a0:	85 c0                	test   %eax,%eax
801072a2:	78 08                	js     801072ac <sys_exec+0xac>
  for(i=0;; i++){
801072a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801072a7:	83 fb 20             	cmp    $0x20,%ebx
801072aa:	75 b4                	jne    80107260 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801072ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801072af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072b4:	5b                   	pop    %ebx
801072b5:	5e                   	pop    %esi
801072b6:	5f                   	pop    %edi
801072b7:	5d                   	pop    %ebp
801072b8:	c3                   	ret
801072b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801072c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801072c7:	00 00 00 00 
  return exec(path, argv);
801072cb:	83 ec 08             	sub    $0x8,%esp
801072ce:	56                   	push   %esi
801072cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801072d5:	e8 16 ab ff ff       	call   80101df0 <exec>
801072da:	83 c4 10             	add    $0x10,%esp
}
801072dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e0:	5b                   	pop    %ebx
801072e1:	5e                   	pop    %esi
801072e2:	5f                   	pop    %edi
801072e3:	5d                   	pop    %ebp
801072e4:	c3                   	ret
801072e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ec:	00 
801072ed:	8d 76 00             	lea    0x0(%esi),%esi

801072f0 <sys_pipe>:

int
sys_pipe(void)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801072f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801072f8:	53                   	push   %ebx
801072f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801072fc:	6a 08                	push   $0x8
801072fe:	50                   	push   %eax
801072ff:	6a 00                	push   $0x0
80107301:	e8 ca f3 ff ff       	call   801066d0 <argptr>
80107306:	83 c4 10             	add    $0x10,%esp
80107309:	85 c0                	test   %eax,%eax
8010730b:	0f 88 8b 00 00 00    	js     8010739c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80107311:	83 ec 08             	sub    $0x8,%esp
80107314:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107317:	50                   	push   %eax
80107318:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010731b:	50                   	push   %eax
8010731c:	e8 2f d4 ff ff       	call   80104750 <pipealloc>
80107321:	83 c4 10             	add    $0x10,%esp
80107324:	85 c0                	test   %eax,%eax
80107326:	78 74                	js     8010739c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107328:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010732b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010732d:	e8 be d9 ff ff       	call   80104cf0 <myproc>
    if(curproc->ofile[fd] == 0){
80107332:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107336:	85 f6                	test   %esi,%esi
80107338:	74 16                	je     80107350 <sys_pipe+0x60>
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80107340:	83 c3 01             	add    $0x1,%ebx
80107343:	83 fb 10             	cmp    $0x10,%ebx
80107346:	74 3d                	je     80107385 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80107348:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010734c:	85 f6                	test   %esi,%esi
8010734e:	75 f0                	jne    80107340 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80107350:	8d 73 08             	lea    0x8(%ebx),%esi
80107353:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010735a:	e8 91 d9 ff ff       	call   80104cf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010735f:	31 d2                	xor    %edx,%edx
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80107368:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010736c:	85 c9                	test   %ecx,%ecx
8010736e:	74 38                	je     801073a8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80107370:	83 c2 01             	add    $0x1,%edx
80107373:	83 fa 10             	cmp    $0x10,%edx
80107376:	75 f0                	jne    80107368 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80107378:	e8 73 d9 ff ff       	call   80104cf0 <myproc>
8010737d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107384:	00 
    fileclose(rf);
80107385:	83 ec 0c             	sub    $0xc,%esp
80107388:	ff 75 e0             	push   -0x20(%ebp)
8010738b:	e8 c0 ae ff ff       	call   80102250 <fileclose>
    fileclose(wf);
80107390:	58                   	pop    %eax
80107391:	ff 75 e4             	push   -0x1c(%ebp)
80107394:	e8 b7 ae ff ff       	call   80102250 <fileclose>
    return -1;
80107399:	83 c4 10             	add    $0x10,%esp
    return -1;
8010739c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073a1:	eb 16                	jmp    801073b9 <sys_pipe+0xc9>
801073a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801073a8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801073ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801073af:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801073b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801073b4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801073b7:	31 c0                	xor    %eax,%eax
}
801073b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bc:	5b                   	pop    %ebx
801073bd:	5e                   	pop    %esi
801073be:	5f                   	pop    %edi
801073bf:	5d                   	pop    %ebp
801073c0:	c3                   	ret
801073c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073c8:	00 
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073d0 <sys_move_file>:

int sys_move_file(void)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
  struct inode *ip_src, *dp_des, *dp_src;
  char name[DIRSIZ];
  uint off;
  struct dirent de;

  if (argstr(0, &path_src) < 0 || argstr(1, &path_des) < 0){
801073d5:	8d 45 bc             	lea    -0x44(%ebp),%eax
{
801073d8:	53                   	push   %ebx
801073d9:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path_src) < 0 || argstr(1, &path_des) < 0){
801073dc:	50                   	push   %eax
801073dd:	6a 00                	push   $0x0
801073df:	e8 5c f3 ff ff       	call   80106740 <argstr>
801073e4:	83 c4 10             	add    $0x10,%esp
801073e7:	85 c0                	test   %eax,%eax
801073e9:	0f 88 42 01 00 00    	js     80107531 <sys_move_file+0x161>
801073ef:	83 ec 08             	sub    $0x8,%esp
801073f2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801073f5:	50                   	push   %eax
801073f6:	6a 01                	push   $0x1
801073f8:	e8 43 f3 ff ff       	call   80106740 <argstr>
801073fd:	83 c4 10             	add    $0x10,%esp
80107400:	85 c0                	test   %eax,%eax
80107402:	0f 88 29 01 00 00    	js     80107531 <sys_move_file+0x161>
    return -1;
  }

  cprintf("Source path: %s\n", path_src);
80107408:	83 ec 08             	sub    $0x8,%esp
8010740b:	ff 75 bc             	push   -0x44(%ebp)
8010740e:	68 de 96 10 80       	push   $0x801096de
80107413:	e8 c8 93 ff ff       	call   801007e0 <cprintf>
  cprintf("Destination directory: %s\n", path_des);
80107418:	58                   	pop    %eax
80107419:	5a                   	pop    %edx
8010741a:	ff 75 c0             	push   -0x40(%ebp)
8010741d:	68 ef 96 10 80       	push   $0x801096ef
80107422:	e8 b9 93 ff ff       	call   801007e0 <cprintf>

  ip_src = namei(path_src);
80107427:	59                   	pop    %ecx
80107428:	ff 75 bc             	push   -0x44(%ebp)
8010742b:	e8 90 bf ff ff       	call   801033c0 <namei>
  if (ip_src == 0)
80107430:	83 c4 10             	add    $0x10,%esp
80107433:	85 c0                	test   %eax,%eax
80107435:	0f 84 3c 01 00 00    	je     80107577 <sys_move_file+0x1a7>
  {
    cprintf("Error: Source file not found\n");
    return -1;
  }
  if (ip_src->type != T_FILE)
8010743b:	66 83 78 50 02       	cmpw   $0x2,0x50(%eax)
80107440:	0f 85 fa 00 00 00    	jne    80107540 <sys_move_file+0x170>
  {
    cprintf("Error: Source is not a regular file\n");
    return -1;
  }

  begin_op();
80107446:	e8 35 cc ff ff       	call   80104080 <begin_op>
  if ((dp_src = nameiparent(path_src, name)) == 0)
8010744b:	8d 7d ca             	lea    -0x36(%ebp),%edi
8010744e:	83 ec 08             	sub    $0x8,%esp
80107451:	57                   	push   %edi
80107452:	ff 75 bc             	push   -0x44(%ebp)
80107455:	e8 86 bf ff ff       	call   801033e0 <nameiparent>
8010745a:	83 c4 10             	add    $0x10,%esp
8010745d:	89 c3                	mov    %eax,%ebx
8010745f:	85 c0                	test   %eax,%eax
80107461:	0f 84 09 01 00 00    	je     80107570 <sys_move_file+0x1a0>
  {
    end_op();
    return -1;
  }

  if ((ip_src = dirlookup(dp_src, name, &off)) == 0)
80107467:	83 ec 04             	sub    $0x4,%esp
8010746a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010746d:	50                   	push   %eax
8010746e:	57                   	push   %edi
8010746f:	53                   	push   %ebx
80107470:	e8 bb bb ff ff       	call   80103030 <dirlookup>
80107475:	83 c4 10             	add    $0x10,%esp
80107478:	89 c6                	mov    %eax,%esi
8010747a:	85 c0                	test   %eax,%eax
8010747c:	0f 84 ee 00 00 00    	je     80107570 <sys_move_file+0x1a0>
  {
    end_op();
    return -1;
  }

  if ((dp_des = namei(path_des)) == 0)
80107482:	83 ec 0c             	sub    $0xc,%esp
80107485:	ff 75 c0             	push   -0x40(%ebp)
80107488:	e8 33 bf ff ff       	call   801033c0 <namei>
8010748d:	83 c4 10             	add    $0x10,%esp
80107490:	85 c0                	test   %eax,%eax
80107492:	0f 84 d8 00 00 00    	je     80107570 <sys_move_file+0x1a0>
  {
    end_op();
    return -1;
  }

  ilock(dp_des);
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	50                   	push   %eax
8010749c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010749f:	e8 3c b6 ff ff       	call   80102ae0 <ilock>
  if (dp_des->dev != ip_src->dev || dirlink(dp_des, name, ip_src->inum) < 0)
801074a4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801074a7:	8b 06                	mov    (%esi),%eax
801074a9:	83 c4 10             	add    $0x10,%esp
801074ac:	39 02                	cmp    %eax,(%edx)
801074ae:	75 70                	jne    80107520 <sys_move_file+0x150>
801074b0:	83 ec 04             	sub    $0x4,%esp
801074b3:	ff 76 04             	push   0x4(%esi)
801074b6:	57                   	push   %edi
801074b7:	52                   	push   %edx
801074b8:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801074bb:	e8 40 be ff ff       	call   80103300 <dirlink>
801074c0:	83 c4 10             	add    $0x10,%esp
801074c3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801074c6:	85 c0                	test   %eax,%eax
801074c8:	78 56                	js     80107520 <sys_move_file+0x150>
  {
    iunlockput(dp_des);
    end_op();
    return -1;
  }
  iunlockput(dp_des);
801074ca:	83 ec 0c             	sub    $0xc,%esp

  ilock(dp_src);

  memset(&de, 0, sizeof(de));
801074cd:	8d 75 d8             	lea    -0x28(%ebp),%esi
  iunlockput(dp_des);
801074d0:	52                   	push   %edx
801074d1:	e8 9a b8 ff ff       	call   80102d70 <iunlockput>
  ilock(dp_src);
801074d6:	89 1c 24             	mov    %ebx,(%esp)
801074d9:	e8 02 b6 ff ff       	call   80102ae0 <ilock>
  memset(&de, 0, sizeof(de));
801074de:	83 c4 0c             	add    $0xc,%esp
801074e1:	6a 10                	push   $0x10
801074e3:	6a 00                	push   $0x0
801074e5:	56                   	push   %esi
801074e6:	e8 e5 ee ff ff       	call   801063d0 <memset>
  if (writei(dp_src, (char *)&de, off, sizeof(de)) != sizeof(de))
801074eb:	6a 10                	push   $0x10
801074ed:	ff 75 c4             	push   -0x3c(%ebp)
801074f0:	56                   	push   %esi
801074f1:	53                   	push   %ebx
801074f2:	e8 f9 b9 ff ff       	call   80102ef0 <writei>
801074f7:	83 c4 20             	add    $0x20,%esp
801074fa:	83 f8 10             	cmp    $0x10,%eax
801074fd:	75 59                	jne    80107558 <sys_move_file+0x188>
  {
    iunlockput(dp_src);
    end_op();
    return -1;
  }
  iunlockput(dp_src);
801074ff:	83 ec 0c             	sub    $0xc,%esp
80107502:	53                   	push   %ebx
80107503:	e8 68 b8 ff ff       	call   80102d70 <iunlockput>

  end_op();
80107508:	e8 e3 cb ff ff       	call   801040f0 <end_op>
  return 0;
8010750d:	83 c4 10             	add    $0x10,%esp
80107510:	31 c0                	xor    %eax,%eax
80107512:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp_des);
80107520:	83 ec 0c             	sub    $0xc,%esp
80107523:	52                   	push   %edx
80107524:	e8 47 b8 ff ff       	call   80102d70 <iunlockput>
    end_op();
80107529:	e8 c2 cb ff ff       	call   801040f0 <end_op>
    return -1;
8010752e:	83 c4 10             	add    $0x10,%esp
    return -1;
80107531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107536:	eb da                	jmp    80107512 <sys_move_file+0x142>
80107538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010753f:	00 
    cprintf("Error: Source is not a regular file\n");
80107540:	83 ec 0c             	sub    $0xc,%esp
80107543:	68 e0 9a 10 80       	push   $0x80109ae0
80107548:	e8 93 92 ff ff       	call   801007e0 <cprintf>
    return -1;
8010754d:	83 c4 10             	add    $0x10,%esp
80107550:	eb df                	jmp    80107531 <sys_move_file+0x161>
80107552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp_src);
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	53                   	push   %ebx
8010755c:	e8 0f b8 ff ff       	call   80102d70 <iunlockput>
    end_op();
80107561:	e8 8a cb ff ff       	call   801040f0 <end_op>
    return -1;
80107566:	83 c4 10             	add    $0x10,%esp
80107569:	eb c6                	jmp    80107531 <sys_move_file+0x161>
8010756b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    end_op();
80107570:	e8 7b cb ff ff       	call   801040f0 <end_op>
    return -1;
80107575:	eb ba                	jmp    80107531 <sys_move_file+0x161>
    cprintf("Error: Source file not found\n");
80107577:	83 ec 0c             	sub    $0xc,%esp
8010757a:	68 0a 97 10 80       	push   $0x8010970a
8010757f:	e8 5c 92 ff ff       	call   801007e0 <cprintf>
    return -1;
80107584:	83 c4 10             	add    $0x10,%esp
80107587:	eb a8                	jmp    80107531 <sys_move_file+0x161>
80107589:	66 90                	xchg   %ax,%ax
8010758b:	66 90                	xchg   %ax,%ax
8010758d:	66 90                	xchg   %ax,%ax
8010758f:	90                   	nop

80107590 <sys_fork>:

#define MAXPATH 1024 

int sys_fork(void)
{
  return fork();
80107590:	e9 3b d9 ff ff       	jmp    80104ed0 <fork>
80107595:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010759c:	00 
8010759d:	8d 76 00             	lea    0x0(%esi),%esi

801075a0 <sys_exit>:
}

int sys_exit(void)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801075a6:	e8 95 db ff ff       	call   80105140 <exit>
  return 0; // not reached
}
801075ab:	31 c0                	xor    %eax,%eax
801075ad:	c9                   	leave
801075ae:	c3                   	ret
801075af:	90                   	nop

801075b0 <sys_wait>:

int sys_wait(void)
{
  return wait();
801075b0:	e9 bb dc ff ff       	jmp    80105270 <wait>
801075b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075bc:	00 
801075bd:	8d 76 00             	lea    0x0(%esi),%esi

801075c0 <sys_kill>:
}

int sys_kill(void)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801075c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075c9:	50                   	push   %eax
801075ca:	6a 00                	push   $0x0
801075cc:	e8 af f0 ff ff       	call   80106680 <argint>
801075d1:	83 c4 10             	add    $0x10,%esp
801075d4:	85 c0                	test   %eax,%eax
801075d6:	78 18                	js     801075f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801075d8:	83 ec 0c             	sub    $0xc,%esp
801075db:	ff 75 f4             	push   -0xc(%ebp)
801075de:	e8 2d df ff ff       	call   80105510 <kill>
801075e3:	83 c4 10             	add    $0x10,%esp
}
801075e6:	c9                   	leave
801075e7:	c3                   	ret
801075e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075ef:	00 
801075f0:	c9                   	leave
    return -1;
801075f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075f6:	c3                   	ret
801075f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075fe:	00 
801075ff:	90                   	nop

80107600 <sys_getpid>:

int sys_getpid(void)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80107606:	e8 e5 d6 ff ff       	call   80104cf0 <myproc>
8010760b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010760e:	c9                   	leave
8010760f:	c3                   	ret

80107610 <sys_sbrk>:

int sys_sbrk(void)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80107614:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107617:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010761a:	50                   	push   %eax
8010761b:	6a 00                	push   $0x0
8010761d:	e8 5e f0 ff ff       	call   80106680 <argint>
80107622:	83 c4 10             	add    $0x10,%esp
80107625:	85 c0                	test   %eax,%eax
80107627:	78 27                	js     80107650 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80107629:	e8 c2 d6 ff ff       	call   80104cf0 <myproc>
  if (growproc(n) < 0)
8010762e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107631:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80107633:	ff 75 f4             	push   -0xc(%ebp)
80107636:	e8 15 d8 ff ff       	call   80104e50 <growproc>
8010763b:	83 c4 10             	add    $0x10,%esp
8010763e:	85 c0                	test   %eax,%eax
80107640:	78 0e                	js     80107650 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80107642:	89 d8                	mov    %ebx,%eax
80107644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107647:	c9                   	leave
80107648:	c3                   	ret
80107649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107650:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107655:	eb eb                	jmp    80107642 <sys_sbrk+0x32>
80107657:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010765e:	00 
8010765f:	90                   	nop

80107660 <sys_sleep>:

int sys_sleep(void)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80107664:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107667:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010766a:	50                   	push   %eax
8010766b:	6a 00                	push   $0x0
8010766d:	e8 0e f0 ff ff       	call   80106680 <argint>
80107672:	83 c4 10             	add    $0x10,%esp
80107675:	85 c0                	test   %eax,%eax
80107677:	78 64                	js     801076dd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80107679:	83 ec 0c             	sub    $0xc,%esp
8010767c:	68 20 d6 11 80       	push   $0x8011d620
80107681:	e8 4a ec ff ff       	call   801062d0 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80107686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80107689:	8b 1d 00 d6 11 80    	mov    0x8011d600,%ebx
  while (ticks - ticks0 < n)
8010768f:	83 c4 10             	add    $0x10,%esp
80107692:	85 d2                	test   %edx,%edx
80107694:	75 2b                	jne    801076c1 <sys_sleep+0x61>
80107696:	eb 58                	jmp    801076f0 <sys_sleep+0x90>
80107698:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010769f:	00 
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801076a0:	83 ec 08             	sub    $0x8,%esp
801076a3:	68 20 d6 11 80       	push   $0x8011d620
801076a8:	68 00 d6 11 80       	push   $0x8011d600
801076ad:	e8 3e dd ff ff       	call   801053f0 <sleep>
  while (ticks - ticks0 < n)
801076b2:	a1 00 d6 11 80       	mov    0x8011d600,%eax
801076b7:	83 c4 10             	add    $0x10,%esp
801076ba:	29 d8                	sub    %ebx,%eax
801076bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801076bf:	73 2f                	jae    801076f0 <sys_sleep+0x90>
    if (myproc()->killed)
801076c1:	e8 2a d6 ff ff       	call   80104cf0 <myproc>
801076c6:	8b 40 24             	mov    0x24(%eax),%eax
801076c9:	85 c0                	test   %eax,%eax
801076cb:	74 d3                	je     801076a0 <sys_sleep+0x40>
      release(&tickslock);
801076cd:	83 ec 0c             	sub    $0xc,%esp
801076d0:	68 20 d6 11 80       	push   $0x8011d620
801076d5:	e8 96 eb ff ff       	call   80106270 <release>
      return -1;
801076da:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801076dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801076e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076e5:	c9                   	leave
801076e6:	c3                   	ret
801076e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076ee:	00 
801076ef:	90                   	nop
  release(&tickslock);
801076f0:	83 ec 0c             	sub    $0xc,%esp
801076f3:	68 20 d6 11 80       	push   $0x8011d620
801076f8:	e8 73 eb ff ff       	call   80106270 <release>
}
801076fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80107700:	83 c4 10             	add    $0x10,%esp
80107703:	31 c0                	xor    %eax,%eax
}
80107705:	c9                   	leave
80107706:	c3                   	ret
80107707:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010770e:	00 
8010770f:	90                   	nop

80107710 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	53                   	push   %ebx
80107714:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107717:	68 20 d6 11 80       	push   $0x8011d620
8010771c:	e8 af eb ff ff       	call   801062d0 <acquire>
  xticks = ticks;
80107721:	8b 1d 00 d6 11 80    	mov    0x8011d600,%ebx
  release(&tickslock);
80107727:	c7 04 24 20 d6 11 80 	movl   $0x8011d620,(%esp)
8010772e:	e8 3d eb ff ff       	call   80106270 <release>
  return xticks;
}
80107733:	89 d8                	mov    %ebx,%eax
80107735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107738:	c9                   	leave
80107739:	c3                   	ret
8010773a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107740 <sys_my_syscall>:

int sys_my_syscall(void)
{
  return 0; 
}
80107740:	31 c0                	xor    %eax,%eax
80107742:	c3                   	ret
80107743:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010774a:	00 
8010774b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107750 <sys_sort_syscalls>:

int sys_sort_syscalls()
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80107756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107759:	50                   	push   %eax
8010775a:	6a 00                	push   $0x0
8010775c:	e8 1f ef ff ff       	call   80106680 <argint>
80107761:	83 c4 10             	add    $0x10,%esp
80107764:	85 c0                	test   %eax,%eax
80107766:	78 18                	js     80107780 <sys_sort_syscalls+0x30>
  {
    return -1; 
  }
  return sort_uniqe_procces(pid);
80107768:	83 ec 0c             	sub    $0xc,%esp
8010776b:	ff 75 f4             	push   -0xc(%ebp)
8010776e:	e8 dd de ff ff       	call   80105650 <sort_uniqe_procces>
80107773:	83 c4 10             	add    $0x10,%esp
} 
80107776:	c9                   	leave
80107777:	c3                   	ret
80107778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010777f:	00 
80107780:	c9                   	leave
    return -1; 
80107781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
} 
80107786:	c3                   	ret
80107787:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010778e:	00 
8010778f:	90                   	nop

80107790 <sys_get_most_invoked_syscalls>:

int sys_get_most_invoked_syscalls()
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80107796:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107799:	50                   	push   %eax
8010779a:	6a 00                	push   $0x0
8010779c:	e8 df ee ff ff       	call   80106680 <argint>
801077a1:	83 c4 10             	add    $0x10,%esp
801077a4:	85 c0                	test   %eax,%eax
801077a6:	78 18                	js     801077c0 <sys_get_most_invoked_syscalls+0x30>
  {
    return -1; 
  }
  return get_max_invoked(pid);
801077a8:	83 ec 0c             	sub    $0xc,%esp
801077ab:	ff 75 f4             	push   -0xc(%ebp)
801077ae:	e8 8d df ff ff       	call   80105740 <get_max_invoked>
801077b3:	83 c4 10             	add    $0x10,%esp
} 
801077b6:	c9                   	leave
801077b7:	c3                   	ret
801077b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801077bf:	00 
801077c0:	c9                   	leave
    return -1; 
801077c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
} 
801077c6:	c3                   	ret
801077c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801077ce:	00 
801077cf:	90                   	nop

801077d0 <sys_create_palindrom>:

int sys_create_palindrom(void){
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	83 ec 08             	sub    $0x8,%esp
  long long int num = myproc()->tf->ecx;
801077d6:	e8 15 d5 ff ff       	call   80104cf0 <myproc>
  return make_create_palindrom(num);
801077db:	83 ec 08             	sub    $0x8,%esp
  long long int num = myproc()->tf->ecx;
801077de:	31 d2                	xor    %edx,%edx
801077e0:	8b 40 18             	mov    0x18(%eax),%eax
801077e3:	8b 40 18             	mov    0x18(%eax),%eax
  return make_create_palindrom(num);
801077e6:	52                   	push   %edx
801077e7:	50                   	push   %eax
801077e8:	e8 03 e1 ff ff       	call   801058f0 <make_create_palindrom>
}
801077ed:	c9                   	leave
801077ee:	c3                   	ret
801077ef:	90                   	nop

801077f0 <sys_list_all_processes>:

int sys_list_all_processes(void)
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	83 ec 14             	sub    $0x14,%esp
  cprintf("list all of active processes : \n");
801077f6:	68 08 9b 10 80       	push   $0x80109b08
801077fb:	e8 e0 8f ff ff       	call   801007e0 <cprintf>
  return list_all_processes_();
80107800:	83 c4 10             	add    $0x10,%esp
}
80107803:	c9                   	leave
  return list_all_processes_();
80107804:	e9 d7 e2 ff ff       	jmp    80105ae0 <list_all_processes_>
80107809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107810 <sys_change_schedular_queue>:

int sys_change_schedular_queue(void)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	83 ec 20             	sub    $0x20,%esp
  int queue_number, pid;
  if(argint(0, &pid) < 0 || argint(1, &queue_number) < 0)
80107816:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107819:	50                   	push   %eax
8010781a:	6a 00                	push   $0x0
8010781c:	e8 5f ee ff ff       	call   80106680 <argint>
80107821:	83 c4 10             	add    $0x10,%esp
80107824:	85 c0                	test   %eax,%eax
80107826:	78 38                	js     80107860 <sys_change_schedular_queue+0x50>
80107828:	83 ec 08             	sub    $0x8,%esp
8010782b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010782e:	50                   	push   %eax
8010782f:	6a 01                	push   $0x1
80107831:	e8 4a ee ff ff       	call   80106680 <argint>
80107836:	83 c4 10             	add    $0x10,%esp
80107839:	85 c0                	test   %eax,%eax
8010783b:	78 23                	js     80107860 <sys_change_schedular_queue+0x50>
    return -1;

  if(queue_number < ROUND_ROBIN || queue_number > SJF)
8010783d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107840:	8d 50 ff             	lea    -0x1(%eax),%edx
80107843:	83 fa 02             	cmp    $0x2,%edx
80107846:	77 18                	ja     80107860 <sys_change_schedular_queue+0x50>
    return -1;

  return change_Q(pid, queue_number);
80107848:	83 ec 08             	sub    $0x8,%esp
8010784b:	50                   	push   %eax
8010784c:	ff 75 f4             	push   -0xc(%ebp)
8010784f:	e8 2c e3 ff ff       	call   80105b80 <change_Q>
80107854:	83 c4 10             	add    $0x10,%esp
}
80107857:	c9                   	leave
80107858:	c3                   	ret
80107859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107860:	c9                   	leave
    return -1;
80107861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107866:	c3                   	ret
80107867:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010786e:	00 
8010786f:	90                   	nop

80107870 <sys_show_process_info>:

int sys_show_process_info(void)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	83 ec 08             	sub    $0x8,%esp
  show_process_info();
80107876:	e8 95 e3 ff ff       	call   80105c10 <show_process_info>
  return 0;
}
8010787b:	31 c0                	xor    %eax,%eax
8010787d:	c9                   	leave
8010787e:	c3                   	ret
8010787f:	90                   	nop

80107880 <sys_set_proc_sjf_params>:

int sys_set_proc_sjf_params(void)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	83 ec 20             	sub    $0x20,%esp
  int pid, burst_time, confidence;
  if(argint(0, &pid) < 0 ||
80107886:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107889:	50                   	push   %eax
8010788a:	6a 00                	push   $0x0
8010788c:	e8 ef ed ff ff       	call   80106680 <argint>
80107891:	83 c4 10             	add    $0x10,%esp
80107894:	85 c0                	test   %eax,%eax
80107896:	78 48                	js     801078e0 <sys_set_proc_sjf_params+0x60>
     argint(1, &burst_time) < 0 ||
80107898:	83 ec 08             	sub    $0x8,%esp
8010789b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010789e:	50                   	push   %eax
8010789f:	6a 01                	push   $0x1
801078a1:	e8 da ed ff ff       	call   80106680 <argint>
  if(argint(0, &pid) < 0 ||
801078a6:	83 c4 10             	add    $0x10,%esp
801078a9:	85 c0                	test   %eax,%eax
801078ab:	78 33                	js     801078e0 <sys_set_proc_sjf_params+0x60>
     argint(2, &confidence) < 0
801078ad:	83 ec 08             	sub    $0x8,%esp
801078b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078b3:	50                   	push   %eax
801078b4:	6a 02                	push   $0x2
801078b6:	e8 c5 ed ff ff       	call   80106680 <argint>
     argint(1, &burst_time) < 0 ||
801078bb:	83 c4 10             	add    $0x10,%esp
801078be:	85 c0                	test   %eax,%eax
801078c0:	78 1e                	js     801078e0 <sys_set_proc_sjf_params+0x60>
    ){
    return -1;
  }
  set_proc_sjf_params_(pid, burst_time, confidence);
801078c2:	83 ec 04             	sub    $0x4,%esp
801078c5:	ff 75 f4             	push   -0xc(%ebp)
801078c8:	ff 75 f0             	push   -0x10(%ebp)
801078cb:	ff 75 ec             	push   -0x14(%ebp)
801078ce:	e8 3d e6 ff ff       	call   80105f10 <set_proc_sjf_params_>
  return 0;
801078d3:	83 c4 10             	add    $0x10,%esp
801078d6:	31 c0                	xor    %eax,%eax
801078d8:	c9                   	leave
801078d9:	c3                   	ret
801078da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078e0:	c9                   	leave
    return -1;
801078e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078e6:	c3                   	ret

801078e7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801078e7:	1e                   	push   %ds
  pushl %es
801078e8:	06                   	push   %es
  pushl %fs
801078e9:	0f a0                	push   %fs
  pushl %gs
801078eb:	0f a8                	push   %gs
  pushal
801078ed:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801078ee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801078f2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801078f4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801078f6:	54                   	push   %esp
  call trap
801078f7:	e8 c4 00 00 00       	call   801079c0 <trap>
  addl $4, %esp
801078fc:	83 c4 04             	add    $0x4,%esp

801078ff <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801078ff:	61                   	popa
  popl %gs
80107900:	0f a9                	pop    %gs
  popl %fs
80107902:	0f a1                	pop    %fs
  popl %es
80107904:	07                   	pop    %es
  popl %ds
80107905:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107906:	83 c4 08             	add    $0x8,%esp
  iret
80107909:	cf                   	iret
8010790a:	66 90                	xchg   %ax,%ax
8010790c:	66 90                	xchg   %ax,%ax
8010790e:	66 90                	xchg   %ax,%ax

80107910 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80107910:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80107911:	31 c0                	xor    %eax,%eax
{
80107913:	89 e5                	mov    %esp,%ebp
80107915:	83 ec 08             	sub    $0x8,%esp
80107918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010791f:	00 
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80107920:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80107927:	c7 04 c5 62 d6 11 80 	movl   $0x8e000008,-0x7fee299e(,%eax,8)
8010792e:	08 00 00 8e 
80107932:	66 89 14 c5 60 d6 11 	mov    %dx,-0x7fee29a0(,%eax,8)
80107939:	80 
8010793a:	c1 ea 10             	shr    $0x10,%edx
8010793d:	66 89 14 c5 66 d6 11 	mov    %dx,-0x7fee299a(,%eax,8)
80107944:	80 
  for (i = 0; i < 256; i++)
80107945:	83 c0 01             	add    $0x1,%eax
80107948:	3d 00 01 00 00       	cmp    $0x100,%eax
8010794d:	75 d1                	jne    80107920 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010794f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80107952:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107957:	c7 05 62 d8 11 80 08 	movl   $0xef000008,0x8011d862
8010795e:	00 00 ef 
  initlock(&tickslock, "time");
80107961:	68 28 97 10 80       	push   $0x80109728
80107966:	68 20 d6 11 80       	push   $0x8011d620
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010796b:	66 a3 60 d8 11 80    	mov    %ax,0x8011d860
80107971:	c1 e8 10             	shr    $0x10,%eax
80107974:	66 a3 66 d8 11 80    	mov    %ax,0x8011d866
  initlock(&tickslock, "time");
8010797a:	e8 61 e7 ff ff       	call   801060e0 <initlock>
}
8010797f:	83 c4 10             	add    $0x10,%esp
80107982:	c9                   	leave
80107983:	c3                   	ret
80107984:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010798b:	00 
8010798c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107990 <idtinit>:

void idtinit(void)
{
80107990:	55                   	push   %ebp
  pd[0] = size-1;
80107991:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107996:	89 e5                	mov    %esp,%ebp
80107998:	83 ec 10             	sub    $0x10,%esp
8010799b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010799f:	b8 60 d6 11 80       	mov    $0x8011d660,%eax
801079a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801079a8:	c1 e8 10             	shr    $0x10,%eax
801079ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801079af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801079b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801079b5:	c9                   	leave
801079b6:	c3                   	ret
801079b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079be:	00 
801079bf:	90                   	nop

801079c0 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 1c             	sub    $0x1c,%esp
801079c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
801079cc:	8b 43 30             	mov    0x30(%ebx),%eax
801079cf:	83 f8 40             	cmp    $0x40,%eax
801079d2:	0f 84 58 01 00 00    	je     80107b30 <trap+0x170>
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
801079d8:	83 e8 20             	sub    $0x20,%eax
801079db:	83 f8 1f             	cmp    $0x1f,%eax
801079de:	0f 87 7c 00 00 00    	ja     80107a60 <trap+0xa0>
801079e4:	ff 24 85 e0 9e 10 80 	jmp    *-0x7fef6120(,%eax,4)
801079eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801079f0:	e8 7b bb ff ff       	call   80103570 <ideintr>
    lapiceoi();
801079f5:	e8 36 c2 ff ff       	call   80103c30 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801079fa:	e8 f1 d2 ff ff       	call   80104cf0 <myproc>
801079ff:	85 c0                	test   %eax,%eax
80107a01:	74 1a                	je     80107a1d <trap+0x5d>
80107a03:	e8 e8 d2 ff ff       	call   80104cf0 <myproc>
80107a08:	8b 50 24             	mov    0x24(%eax),%edx
80107a0b:	85 d2                	test   %edx,%edx
80107a0d:	74 0e                	je     80107a1d <trap+0x5d>
80107a0f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107a13:	f7 d0                	not    %eax
80107a15:	a8 03                	test   $0x3,%al
80107a17:	0f 84 eb 01 00 00    	je     80107c08 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
80107a1d:	e8 ce d2 ff ff       	call   80104cf0 <myproc>
80107a22:	85 c0                	test   %eax,%eax
80107a24:	74 0f                	je     80107a35 <trap+0x75>
80107a26:	e8 c5 d2 ff ff       	call   80104cf0 <myproc>
80107a2b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107a2f:	0f 84 ab 00 00 00    	je     80107ae0 <trap+0x120>
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107a35:	e8 b6 d2 ff ff       	call   80104cf0 <myproc>
80107a3a:	85 c0                	test   %eax,%eax
80107a3c:	74 1a                	je     80107a58 <trap+0x98>
80107a3e:	e8 ad d2 ff ff       	call   80104cf0 <myproc>
80107a43:	8b 40 24             	mov    0x24(%eax),%eax
80107a46:	85 c0                	test   %eax,%eax
80107a48:	74 0e                	je     80107a58 <trap+0x98>
80107a4a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107a4e:	f7 d0                	not    %eax
80107a50:	a8 03                	test   $0x3,%al
80107a52:	0f 84 17 01 00 00    	je     80107b6f <trap+0x1af>
    exit();
}
80107a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a5b:	5b                   	pop    %ebx
80107a5c:	5e                   	pop    %esi
80107a5d:	5f                   	pop    %edi
80107a5e:	5d                   	pop    %ebp
80107a5f:	c3                   	ret
    if (myproc() == 0 || (tf->cs & 3) == 0)
80107a60:	e8 8b d2 ff ff       	call   80104cf0 <myproc>
80107a65:	8b 7b 38             	mov    0x38(%ebx),%edi
80107a68:	85 c0                	test   %eax,%eax
80107a6a:	0f 84 e2 01 00 00    	je     80107c52 <trap+0x292>
80107a70:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107a74:	0f 84 d8 01 00 00    	je     80107c52 <trap+0x292>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107a7a:	0f 20 d1             	mov    %cr2,%ecx
80107a7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107a80:	e8 4b d2 ff ff       	call   80104cd0 <cpuid>
80107a85:	8b 73 30             	mov    0x30(%ebx),%esi
80107a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107a8b:	8b 43 34             	mov    0x34(%ebx),%eax
80107a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107a91:	e8 5a d2 ff ff       	call   80104cf0 <myproc>
80107a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a99:	e8 52 d2 ff ff       	call   80104cf0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107a9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107aa1:	51                   	push   %ecx
80107aa2:	57                   	push   %edi
80107aa3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107aa6:	52                   	push   %edx
80107aa7:	ff 75 e4             	push   -0x1c(%ebp)
80107aaa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107aab:	8b 75 e0             	mov    -0x20(%ebp),%esi
80107aae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107ab1:	56                   	push   %esi
80107ab2:	ff 70 10             	push   0x10(%eax)
80107ab5:	68 84 9b 10 80       	push   $0x80109b84
80107aba:	e8 21 8d ff ff       	call   801007e0 <cprintf>
    myproc()->killed = 1;
80107abf:	83 c4 20             	add    $0x20,%esp
80107ac2:	e8 29 d2 ff ff       	call   80104cf0 <myproc>
80107ac7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107ace:	e8 1d d2 ff ff       	call   80104cf0 <myproc>
80107ad3:	85 c0                	test   %eax,%eax
80107ad5:	0f 85 28 ff ff ff    	jne    80107a03 <trap+0x43>
80107adb:	e9 3d ff ff ff       	jmp    80107a1d <trap+0x5d>
  if (myproc() && myproc()->state == RUNNING &&
80107ae0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107ae4:	0f 85 4b ff ff ff    	jne    80107a35 <trap+0x75>
    yield();
80107aea:	e8 b1 d8 ff ff       	call   801053a0 <yield>
80107aef:	e9 41 ff ff ff       	jmp    80107a35 <trap+0x75>
80107af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107af8:	8b 7b 38             	mov    0x38(%ebx),%edi
80107afb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80107aff:	e8 cc d1 ff ff       	call   80104cd0 <cpuid>
80107b04:	57                   	push   %edi
80107b05:	56                   	push   %esi
80107b06:	50                   	push   %eax
80107b07:	68 2c 9b 10 80       	push   $0x80109b2c
80107b0c:	e8 cf 8c ff ff       	call   801007e0 <cprintf>
    lapiceoi();
80107b11:	e8 1a c1 ff ff       	call   80103c30 <lapiceoi>
    break;
80107b16:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107b19:	e8 d2 d1 ff ff       	call   80104cf0 <myproc>
80107b1e:	85 c0                	test   %eax,%eax
80107b20:	0f 85 dd fe ff ff    	jne    80107a03 <trap+0x43>
80107b26:	e9 f2 fe ff ff       	jmp    80107a1d <trap+0x5d>
80107b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80107b30:	e8 bb d1 ff ff       	call   80104cf0 <myproc>
80107b35:	8b 70 24             	mov    0x24(%eax),%esi
80107b38:	85 f6                	test   %esi,%esi
80107b3a:	0f 85 d8 00 00 00    	jne    80107c18 <trap+0x258>
    if (myproc()->numsystemcalls < 100)
80107b40:	e8 ab d1 ff ff       	call   80104cf0 <myproc>
80107b45:	83 b8 10 02 00 00 63 	cmpl   $0x63,0x210(%eax)
80107b4c:	0f 8e d6 00 00 00    	jle    80107c28 <trap+0x268>
    myproc()->tf = tf;
80107b52:	e8 99 d1 ff ff       	call   80104cf0 <myproc>
80107b57:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107b5a:	e8 61 ec ff ff       	call   801067c0 <syscall>
    if (myproc()->killed)
80107b5f:	e8 8c d1 ff ff       	call   80104cf0 <myproc>
80107b64:	8b 48 24             	mov    0x24(%eax),%ecx
80107b67:	85 c9                	test   %ecx,%ecx
80107b69:	0f 84 e9 fe ff ff    	je     80107a58 <trap+0x98>
}
80107b6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b72:	5b                   	pop    %ebx
80107b73:	5e                   	pop    %esi
80107b74:	5f                   	pop    %edi
80107b75:	5d                   	pop    %ebp
      exit();
80107b76:	e9 c5 d5 ff ff       	jmp    80105140 <exit>
80107b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartintr();
80107b80:	e8 7b 02 00 00       	call   80107e00 <uartintr>
    lapiceoi();
80107b85:	e8 a6 c0 ff ff       	call   80103c30 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107b8a:	e8 61 d1 ff ff       	call   80104cf0 <myproc>
80107b8f:	85 c0                	test   %eax,%eax
80107b91:	0f 85 6c fe ff ff    	jne    80107a03 <trap+0x43>
80107b97:	e9 81 fe ff ff       	jmp    80107a1d <trap+0x5d>
80107b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107ba0:	e8 5b bf ff ff       	call   80103b00 <kbdintr>
    lapiceoi();
80107ba5:	e8 86 c0 ff ff       	call   80103c30 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80107baa:	e8 41 d1 ff ff       	call   80104cf0 <myproc>
80107baf:	85 c0                	test   %eax,%eax
80107bb1:	0f 85 4c fe ff ff    	jne    80107a03 <trap+0x43>
80107bb7:	e9 61 fe ff ff       	jmp    80107a1d <trap+0x5d>
80107bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpuid() == 0)
80107bc0:	e8 0b d1 ff ff       	call   80104cd0 <cpuid>
80107bc5:	85 c0                	test   %eax,%eax
80107bc7:	0f 85 28 fe ff ff    	jne    801079f5 <trap+0x35>
      acquire(&tickslock);
80107bcd:	83 ec 0c             	sub    $0xc,%esp
80107bd0:	68 20 d6 11 80       	push   $0x8011d620
80107bd5:	e8 f6 e6 ff ff       	call   801062d0 <acquire>
      ticks++;
80107bda:	83 05 00 d6 11 80 01 	addl   $0x1,0x8011d600
      wakeup(&ticks);
80107be1:	c7 04 24 00 d6 11 80 	movl   $0x8011d600,(%esp)
80107be8:	e8 c3 d8 ff ff       	call   801054b0 <wakeup>
      release(&tickslock);
80107bed:	c7 04 24 20 d6 11 80 	movl   $0x8011d620,(%esp)
80107bf4:	e8 77 e6 ff ff       	call   80106270 <release>
80107bf9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107bfc:	e9 f4 fd ff ff       	jmp    801079f5 <trap+0x35>
80107c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107c08:	e8 33 d5 ff ff       	call   80105140 <exit>
80107c0d:	e9 0b fe ff ff       	jmp    80107a1d <trap+0x5d>
80107c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107c18:	e8 23 d5 ff ff       	call   80105140 <exit>
80107c1d:	e9 1e ff ff ff       	jmp    80107b40 <trap+0x180>
80107c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      myproc()->systemcalls[myproc()->numsystemcalls++] = tf->eax;
80107c28:	8b 7b 1c             	mov    0x1c(%ebx),%edi
80107c2b:	e8 c0 d0 ff ff       	call   80104cf0 <myproc>
80107c30:	89 c6                	mov    %eax,%esi
80107c32:	e8 b9 d0 ff ff       	call   80104cf0 <myproc>
80107c37:	8b 90 10 02 00 00    	mov    0x210(%eax),%edx
80107c3d:	8d 4a 01             	lea    0x1(%edx),%ecx
80107c40:	89 88 10 02 00 00    	mov    %ecx,0x210(%eax)
80107c46:	89 bc 96 80 00 00 00 	mov    %edi,0x80(%esi,%edx,4)
80107c4d:	e9 00 ff ff ff       	jmp    80107b52 <trap+0x192>
80107c52:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107c55:	e8 76 d0 ff ff       	call   80104cd0 <cpuid>
80107c5a:	83 ec 0c             	sub    $0xc,%esp
80107c5d:	56                   	push   %esi
80107c5e:	57                   	push   %edi
80107c5f:	50                   	push   %eax
80107c60:	ff 73 30             	push   0x30(%ebx)
80107c63:	68 50 9b 10 80       	push   $0x80109b50
80107c68:	e8 73 8b ff ff       	call   801007e0 <cprintf>
      panic("trap");
80107c6d:	83 c4 14             	add    $0x14,%esp
80107c70:	68 2d 97 10 80       	push   $0x8010972d
80107c75:	e8 d6 87 ff ff       	call   80100450 <panic>
80107c7a:	66 90                	xchg   %ax,%ax
80107c7c:	66 90                	xchg   %ax,%ax
80107c7e:	66 90                	xchg   %ax,%ax

80107c80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107c80:	a1 60 de 11 80       	mov    0x8011de60,%eax
80107c85:	85 c0                	test   %eax,%eax
80107c87:	74 17                	je     80107ca0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107c89:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107c8e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107c8f:	a8 01                	test   $0x1,%al
80107c91:	74 0d                	je     80107ca0 <uartgetc+0x20>
80107c93:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107c98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107c99:	0f b6 c0             	movzbl %al,%eax
80107c9c:	c3                   	ret
80107c9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ca5:	c3                   	ret
80107ca6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107cad:	00 
80107cae:	66 90                	xchg   %ax,%ax

80107cb0 <uartinit>:
{
80107cb0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107cb1:	31 c9                	xor    %ecx,%ecx
80107cb3:	89 c8                	mov    %ecx,%eax
80107cb5:	89 e5                	mov    %esp,%ebp
80107cb7:	57                   	push   %edi
80107cb8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80107cbd:	56                   	push   %esi
80107cbe:	89 fa                	mov    %edi,%edx
80107cc0:	53                   	push   %ebx
80107cc1:	83 ec 1c             	sub    $0x1c,%esp
80107cc4:	ee                   	out    %al,(%dx)
80107cc5:	be fb 03 00 00       	mov    $0x3fb,%esi
80107cca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80107ccf:	89 f2                	mov    %esi,%edx
80107cd1:	ee                   	out    %al,(%dx)
80107cd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80107cd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107cdc:	ee                   	out    %al,(%dx)
80107cdd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107ce2:	89 c8                	mov    %ecx,%eax
80107ce4:	89 da                	mov    %ebx,%edx
80107ce6:	ee                   	out    %al,(%dx)
80107ce7:	b8 03 00 00 00       	mov    $0x3,%eax
80107cec:	89 f2                	mov    %esi,%edx
80107cee:	ee                   	out    %al,(%dx)
80107cef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107cf4:	89 c8                	mov    %ecx,%eax
80107cf6:	ee                   	out    %al,(%dx)
80107cf7:	b8 01 00 00 00       	mov    $0x1,%eax
80107cfc:	89 da                	mov    %ebx,%edx
80107cfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107cff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107d04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107d05:	3c ff                	cmp    $0xff,%al
80107d07:	0f 84 7c 00 00 00    	je     80107d89 <uartinit+0xd9>
  uart = 1;
80107d0d:	c7 05 60 de 11 80 01 	movl   $0x1,0x8011de60
80107d14:	00 00 00 
80107d17:	89 fa                	mov    %edi,%edx
80107d19:	ec                   	in     (%dx),%al
80107d1a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107d1f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107d20:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80107d23:	bf 32 97 10 80       	mov    $0x80109732,%edi
80107d28:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107d2d:	6a 00                	push   $0x0
80107d2f:	6a 04                	push   $0x4
80107d31:	e8 6a ba ff ff       	call   801037a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107d36:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107d3a:	83 c4 10             	add    $0x10,%esp
80107d3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80107d40:	a1 60 de 11 80       	mov    0x8011de60,%eax
80107d45:	85 c0                	test   %eax,%eax
80107d47:	74 32                	je     80107d7b <uartinit+0xcb>
80107d49:	89 f2                	mov    %esi,%edx
80107d4b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107d4c:	a8 20                	test   $0x20,%al
80107d4e:	75 21                	jne    80107d71 <uartinit+0xc1>
80107d50:	bb 80 00 00 00       	mov    $0x80,%ebx
80107d55:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80107d58:	83 ec 0c             	sub    $0xc,%esp
80107d5b:	6a 0a                	push   $0xa
80107d5d:	e8 ee be ff ff       	call   80103c50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107d62:	83 c4 10             	add    $0x10,%esp
80107d65:	83 eb 01             	sub    $0x1,%ebx
80107d68:	74 07                	je     80107d71 <uartinit+0xc1>
80107d6a:	89 f2                	mov    %esi,%edx
80107d6c:	ec                   	in     (%dx),%al
80107d6d:	a8 20                	test   $0x20,%al
80107d6f:	74 e7                	je     80107d58 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d71:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107d76:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80107d7a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107d7b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107d7f:	83 c7 01             	add    $0x1,%edi
80107d82:	88 45 e7             	mov    %al,-0x19(%ebp)
80107d85:	84 c0                	test   %al,%al
80107d87:	75 b7                	jne    80107d40 <uartinit+0x90>
}
80107d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d8c:	5b                   	pop    %ebx
80107d8d:	5e                   	pop    %esi
80107d8e:	5f                   	pop    %edi
80107d8f:	5d                   	pop    %ebp
80107d90:	c3                   	ret
80107d91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d98:	00 
80107d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107da0 <uartputc>:
  if(!uart)
80107da0:	a1 60 de 11 80       	mov    0x8011de60,%eax
80107da5:	85 c0                	test   %eax,%eax
80107da7:	74 4f                	je     80107df8 <uartputc+0x58>
{
80107da9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107daa:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107daf:	89 e5                	mov    %esp,%ebp
80107db1:	56                   	push   %esi
80107db2:	53                   	push   %ebx
80107db3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107db4:	a8 20                	test   $0x20,%al
80107db6:	75 29                	jne    80107de1 <uartputc+0x41>
80107db8:	bb 80 00 00 00       	mov    $0x80,%ebx
80107dbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80107dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80107dc8:	83 ec 0c             	sub    $0xc,%esp
80107dcb:	6a 0a                	push   $0xa
80107dcd:	e8 7e be ff ff       	call   80103c50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107dd2:	83 c4 10             	add    $0x10,%esp
80107dd5:	83 eb 01             	sub    $0x1,%ebx
80107dd8:	74 07                	je     80107de1 <uartputc+0x41>
80107dda:	89 f2                	mov    %esi,%edx
80107ddc:	ec                   	in     (%dx),%al
80107ddd:	a8 20                	test   $0x20,%al
80107ddf:	74 e7                	je     80107dc8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107de1:	8b 45 08             	mov    0x8(%ebp),%eax
80107de4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107de9:	ee                   	out    %al,(%dx)
}
80107dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ded:	5b                   	pop    %ebx
80107dee:	5e                   	pop    %esi
80107def:	5d                   	pop    %ebp
80107df0:	c3                   	ret
80107df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107df8:	c3                   	ret
80107df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e00 <uartintr>:

void
uartintr(void)
{
80107e00:	55                   	push   %ebp
80107e01:	89 e5                	mov    %esp,%ebp
80107e03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107e06:	68 80 7c 10 80       	push   $0x80107c80
80107e0b:	e8 80 99 ff ff       	call   80101790 <consoleintr>
}
80107e10:	83 c4 10             	add    $0x10,%esp
80107e13:	c9                   	leave
80107e14:	c3                   	ret

80107e15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107e15:	6a 00                	push   $0x0
  pushl $0
80107e17:	6a 00                	push   $0x0
  jmp alltraps
80107e19:	e9 c9 fa ff ff       	jmp    801078e7 <alltraps>

80107e1e <vector1>:
.globl vector1
vector1:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $1
80107e20:	6a 01                	push   $0x1
  jmp alltraps
80107e22:	e9 c0 fa ff ff       	jmp    801078e7 <alltraps>

80107e27 <vector2>:
.globl vector2
vector2:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $2
80107e29:	6a 02                	push   $0x2
  jmp alltraps
80107e2b:	e9 b7 fa ff ff       	jmp    801078e7 <alltraps>

80107e30 <vector3>:
.globl vector3
vector3:
  pushl $0
80107e30:	6a 00                	push   $0x0
  pushl $3
80107e32:	6a 03                	push   $0x3
  jmp alltraps
80107e34:	e9 ae fa ff ff       	jmp    801078e7 <alltraps>

80107e39 <vector4>:
.globl vector4
vector4:
  pushl $0
80107e39:	6a 00                	push   $0x0
  pushl $4
80107e3b:	6a 04                	push   $0x4
  jmp alltraps
80107e3d:	e9 a5 fa ff ff       	jmp    801078e7 <alltraps>

80107e42 <vector5>:
.globl vector5
vector5:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $5
80107e44:	6a 05                	push   $0x5
  jmp alltraps
80107e46:	e9 9c fa ff ff       	jmp    801078e7 <alltraps>

80107e4b <vector6>:
.globl vector6
vector6:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $6
80107e4d:	6a 06                	push   $0x6
  jmp alltraps
80107e4f:	e9 93 fa ff ff       	jmp    801078e7 <alltraps>

80107e54 <vector7>:
.globl vector7
vector7:
  pushl $0
80107e54:	6a 00                	push   $0x0
  pushl $7
80107e56:	6a 07                	push   $0x7
  jmp alltraps
80107e58:	e9 8a fa ff ff       	jmp    801078e7 <alltraps>

80107e5d <vector8>:
.globl vector8
vector8:
  pushl $8
80107e5d:	6a 08                	push   $0x8
  jmp alltraps
80107e5f:	e9 83 fa ff ff       	jmp    801078e7 <alltraps>

80107e64 <vector9>:
.globl vector9
vector9:
  pushl $0
80107e64:	6a 00                	push   $0x0
  pushl $9
80107e66:	6a 09                	push   $0x9
  jmp alltraps
80107e68:	e9 7a fa ff ff       	jmp    801078e7 <alltraps>

80107e6d <vector10>:
.globl vector10
vector10:
  pushl $10
80107e6d:	6a 0a                	push   $0xa
  jmp alltraps
80107e6f:	e9 73 fa ff ff       	jmp    801078e7 <alltraps>

80107e74 <vector11>:
.globl vector11
vector11:
  pushl $11
80107e74:	6a 0b                	push   $0xb
  jmp alltraps
80107e76:	e9 6c fa ff ff       	jmp    801078e7 <alltraps>

80107e7b <vector12>:
.globl vector12
vector12:
  pushl $12
80107e7b:	6a 0c                	push   $0xc
  jmp alltraps
80107e7d:	e9 65 fa ff ff       	jmp    801078e7 <alltraps>

80107e82 <vector13>:
.globl vector13
vector13:
  pushl $13
80107e82:	6a 0d                	push   $0xd
  jmp alltraps
80107e84:	e9 5e fa ff ff       	jmp    801078e7 <alltraps>

80107e89 <vector14>:
.globl vector14
vector14:
  pushl $14
80107e89:	6a 0e                	push   $0xe
  jmp alltraps
80107e8b:	e9 57 fa ff ff       	jmp    801078e7 <alltraps>

80107e90 <vector15>:
.globl vector15
vector15:
  pushl $0
80107e90:	6a 00                	push   $0x0
  pushl $15
80107e92:	6a 0f                	push   $0xf
  jmp alltraps
80107e94:	e9 4e fa ff ff       	jmp    801078e7 <alltraps>

80107e99 <vector16>:
.globl vector16
vector16:
  pushl $0
80107e99:	6a 00                	push   $0x0
  pushl $16
80107e9b:	6a 10                	push   $0x10
  jmp alltraps
80107e9d:	e9 45 fa ff ff       	jmp    801078e7 <alltraps>

80107ea2 <vector17>:
.globl vector17
vector17:
  pushl $17
80107ea2:	6a 11                	push   $0x11
  jmp alltraps
80107ea4:	e9 3e fa ff ff       	jmp    801078e7 <alltraps>

80107ea9 <vector18>:
.globl vector18
vector18:
  pushl $0
80107ea9:	6a 00                	push   $0x0
  pushl $18
80107eab:	6a 12                	push   $0x12
  jmp alltraps
80107ead:	e9 35 fa ff ff       	jmp    801078e7 <alltraps>

80107eb2 <vector19>:
.globl vector19
vector19:
  pushl $0
80107eb2:	6a 00                	push   $0x0
  pushl $19
80107eb4:	6a 13                	push   $0x13
  jmp alltraps
80107eb6:	e9 2c fa ff ff       	jmp    801078e7 <alltraps>

80107ebb <vector20>:
.globl vector20
vector20:
  pushl $0
80107ebb:	6a 00                	push   $0x0
  pushl $20
80107ebd:	6a 14                	push   $0x14
  jmp alltraps
80107ebf:	e9 23 fa ff ff       	jmp    801078e7 <alltraps>

80107ec4 <vector21>:
.globl vector21
vector21:
  pushl $0
80107ec4:	6a 00                	push   $0x0
  pushl $21
80107ec6:	6a 15                	push   $0x15
  jmp alltraps
80107ec8:	e9 1a fa ff ff       	jmp    801078e7 <alltraps>

80107ecd <vector22>:
.globl vector22
vector22:
  pushl $0
80107ecd:	6a 00                	push   $0x0
  pushl $22
80107ecf:	6a 16                	push   $0x16
  jmp alltraps
80107ed1:	e9 11 fa ff ff       	jmp    801078e7 <alltraps>

80107ed6 <vector23>:
.globl vector23
vector23:
  pushl $0
80107ed6:	6a 00                	push   $0x0
  pushl $23
80107ed8:	6a 17                	push   $0x17
  jmp alltraps
80107eda:	e9 08 fa ff ff       	jmp    801078e7 <alltraps>

80107edf <vector24>:
.globl vector24
vector24:
  pushl $0
80107edf:	6a 00                	push   $0x0
  pushl $24
80107ee1:	6a 18                	push   $0x18
  jmp alltraps
80107ee3:	e9 ff f9 ff ff       	jmp    801078e7 <alltraps>

80107ee8 <vector25>:
.globl vector25
vector25:
  pushl $0
80107ee8:	6a 00                	push   $0x0
  pushl $25
80107eea:	6a 19                	push   $0x19
  jmp alltraps
80107eec:	e9 f6 f9 ff ff       	jmp    801078e7 <alltraps>

80107ef1 <vector26>:
.globl vector26
vector26:
  pushl $0
80107ef1:	6a 00                	push   $0x0
  pushl $26
80107ef3:	6a 1a                	push   $0x1a
  jmp alltraps
80107ef5:	e9 ed f9 ff ff       	jmp    801078e7 <alltraps>

80107efa <vector27>:
.globl vector27
vector27:
  pushl $0
80107efa:	6a 00                	push   $0x0
  pushl $27
80107efc:	6a 1b                	push   $0x1b
  jmp alltraps
80107efe:	e9 e4 f9 ff ff       	jmp    801078e7 <alltraps>

80107f03 <vector28>:
.globl vector28
vector28:
  pushl $0
80107f03:	6a 00                	push   $0x0
  pushl $28
80107f05:	6a 1c                	push   $0x1c
  jmp alltraps
80107f07:	e9 db f9 ff ff       	jmp    801078e7 <alltraps>

80107f0c <vector29>:
.globl vector29
vector29:
  pushl $0
80107f0c:	6a 00                	push   $0x0
  pushl $29
80107f0e:	6a 1d                	push   $0x1d
  jmp alltraps
80107f10:	e9 d2 f9 ff ff       	jmp    801078e7 <alltraps>

80107f15 <vector30>:
.globl vector30
vector30:
  pushl $0
80107f15:	6a 00                	push   $0x0
  pushl $30
80107f17:	6a 1e                	push   $0x1e
  jmp alltraps
80107f19:	e9 c9 f9 ff ff       	jmp    801078e7 <alltraps>

80107f1e <vector31>:
.globl vector31
vector31:
  pushl $0
80107f1e:	6a 00                	push   $0x0
  pushl $31
80107f20:	6a 1f                	push   $0x1f
  jmp alltraps
80107f22:	e9 c0 f9 ff ff       	jmp    801078e7 <alltraps>

80107f27 <vector32>:
.globl vector32
vector32:
  pushl $0
80107f27:	6a 00                	push   $0x0
  pushl $32
80107f29:	6a 20                	push   $0x20
  jmp alltraps
80107f2b:	e9 b7 f9 ff ff       	jmp    801078e7 <alltraps>

80107f30 <vector33>:
.globl vector33
vector33:
  pushl $0
80107f30:	6a 00                	push   $0x0
  pushl $33
80107f32:	6a 21                	push   $0x21
  jmp alltraps
80107f34:	e9 ae f9 ff ff       	jmp    801078e7 <alltraps>

80107f39 <vector34>:
.globl vector34
vector34:
  pushl $0
80107f39:	6a 00                	push   $0x0
  pushl $34
80107f3b:	6a 22                	push   $0x22
  jmp alltraps
80107f3d:	e9 a5 f9 ff ff       	jmp    801078e7 <alltraps>

80107f42 <vector35>:
.globl vector35
vector35:
  pushl $0
80107f42:	6a 00                	push   $0x0
  pushl $35
80107f44:	6a 23                	push   $0x23
  jmp alltraps
80107f46:	e9 9c f9 ff ff       	jmp    801078e7 <alltraps>

80107f4b <vector36>:
.globl vector36
vector36:
  pushl $0
80107f4b:	6a 00                	push   $0x0
  pushl $36
80107f4d:	6a 24                	push   $0x24
  jmp alltraps
80107f4f:	e9 93 f9 ff ff       	jmp    801078e7 <alltraps>

80107f54 <vector37>:
.globl vector37
vector37:
  pushl $0
80107f54:	6a 00                	push   $0x0
  pushl $37
80107f56:	6a 25                	push   $0x25
  jmp alltraps
80107f58:	e9 8a f9 ff ff       	jmp    801078e7 <alltraps>

80107f5d <vector38>:
.globl vector38
vector38:
  pushl $0
80107f5d:	6a 00                	push   $0x0
  pushl $38
80107f5f:	6a 26                	push   $0x26
  jmp alltraps
80107f61:	e9 81 f9 ff ff       	jmp    801078e7 <alltraps>

80107f66 <vector39>:
.globl vector39
vector39:
  pushl $0
80107f66:	6a 00                	push   $0x0
  pushl $39
80107f68:	6a 27                	push   $0x27
  jmp alltraps
80107f6a:	e9 78 f9 ff ff       	jmp    801078e7 <alltraps>

80107f6f <vector40>:
.globl vector40
vector40:
  pushl $0
80107f6f:	6a 00                	push   $0x0
  pushl $40
80107f71:	6a 28                	push   $0x28
  jmp alltraps
80107f73:	e9 6f f9 ff ff       	jmp    801078e7 <alltraps>

80107f78 <vector41>:
.globl vector41
vector41:
  pushl $0
80107f78:	6a 00                	push   $0x0
  pushl $41
80107f7a:	6a 29                	push   $0x29
  jmp alltraps
80107f7c:	e9 66 f9 ff ff       	jmp    801078e7 <alltraps>

80107f81 <vector42>:
.globl vector42
vector42:
  pushl $0
80107f81:	6a 00                	push   $0x0
  pushl $42
80107f83:	6a 2a                	push   $0x2a
  jmp alltraps
80107f85:	e9 5d f9 ff ff       	jmp    801078e7 <alltraps>

80107f8a <vector43>:
.globl vector43
vector43:
  pushl $0
80107f8a:	6a 00                	push   $0x0
  pushl $43
80107f8c:	6a 2b                	push   $0x2b
  jmp alltraps
80107f8e:	e9 54 f9 ff ff       	jmp    801078e7 <alltraps>

80107f93 <vector44>:
.globl vector44
vector44:
  pushl $0
80107f93:	6a 00                	push   $0x0
  pushl $44
80107f95:	6a 2c                	push   $0x2c
  jmp alltraps
80107f97:	e9 4b f9 ff ff       	jmp    801078e7 <alltraps>

80107f9c <vector45>:
.globl vector45
vector45:
  pushl $0
80107f9c:	6a 00                	push   $0x0
  pushl $45
80107f9e:	6a 2d                	push   $0x2d
  jmp alltraps
80107fa0:	e9 42 f9 ff ff       	jmp    801078e7 <alltraps>

80107fa5 <vector46>:
.globl vector46
vector46:
  pushl $0
80107fa5:	6a 00                	push   $0x0
  pushl $46
80107fa7:	6a 2e                	push   $0x2e
  jmp alltraps
80107fa9:	e9 39 f9 ff ff       	jmp    801078e7 <alltraps>

80107fae <vector47>:
.globl vector47
vector47:
  pushl $0
80107fae:	6a 00                	push   $0x0
  pushl $47
80107fb0:	6a 2f                	push   $0x2f
  jmp alltraps
80107fb2:	e9 30 f9 ff ff       	jmp    801078e7 <alltraps>

80107fb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80107fb7:	6a 00                	push   $0x0
  pushl $48
80107fb9:	6a 30                	push   $0x30
  jmp alltraps
80107fbb:	e9 27 f9 ff ff       	jmp    801078e7 <alltraps>

80107fc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80107fc0:	6a 00                	push   $0x0
  pushl $49
80107fc2:	6a 31                	push   $0x31
  jmp alltraps
80107fc4:	e9 1e f9 ff ff       	jmp    801078e7 <alltraps>

80107fc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80107fc9:	6a 00                	push   $0x0
  pushl $50
80107fcb:	6a 32                	push   $0x32
  jmp alltraps
80107fcd:	e9 15 f9 ff ff       	jmp    801078e7 <alltraps>

80107fd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80107fd2:	6a 00                	push   $0x0
  pushl $51
80107fd4:	6a 33                	push   $0x33
  jmp alltraps
80107fd6:	e9 0c f9 ff ff       	jmp    801078e7 <alltraps>

80107fdb <vector52>:
.globl vector52
vector52:
  pushl $0
80107fdb:	6a 00                	push   $0x0
  pushl $52
80107fdd:	6a 34                	push   $0x34
  jmp alltraps
80107fdf:	e9 03 f9 ff ff       	jmp    801078e7 <alltraps>

80107fe4 <vector53>:
.globl vector53
vector53:
  pushl $0
80107fe4:	6a 00                	push   $0x0
  pushl $53
80107fe6:	6a 35                	push   $0x35
  jmp alltraps
80107fe8:	e9 fa f8 ff ff       	jmp    801078e7 <alltraps>

80107fed <vector54>:
.globl vector54
vector54:
  pushl $0
80107fed:	6a 00                	push   $0x0
  pushl $54
80107fef:	6a 36                	push   $0x36
  jmp alltraps
80107ff1:	e9 f1 f8 ff ff       	jmp    801078e7 <alltraps>

80107ff6 <vector55>:
.globl vector55
vector55:
  pushl $0
80107ff6:	6a 00                	push   $0x0
  pushl $55
80107ff8:	6a 37                	push   $0x37
  jmp alltraps
80107ffa:	e9 e8 f8 ff ff       	jmp    801078e7 <alltraps>

80107fff <vector56>:
.globl vector56
vector56:
  pushl $0
80107fff:	6a 00                	push   $0x0
  pushl $56
80108001:	6a 38                	push   $0x38
  jmp alltraps
80108003:	e9 df f8 ff ff       	jmp    801078e7 <alltraps>

80108008 <vector57>:
.globl vector57
vector57:
  pushl $0
80108008:	6a 00                	push   $0x0
  pushl $57
8010800a:	6a 39                	push   $0x39
  jmp alltraps
8010800c:	e9 d6 f8 ff ff       	jmp    801078e7 <alltraps>

80108011 <vector58>:
.globl vector58
vector58:
  pushl $0
80108011:	6a 00                	push   $0x0
  pushl $58
80108013:	6a 3a                	push   $0x3a
  jmp alltraps
80108015:	e9 cd f8 ff ff       	jmp    801078e7 <alltraps>

8010801a <vector59>:
.globl vector59
vector59:
  pushl $0
8010801a:	6a 00                	push   $0x0
  pushl $59
8010801c:	6a 3b                	push   $0x3b
  jmp alltraps
8010801e:	e9 c4 f8 ff ff       	jmp    801078e7 <alltraps>

80108023 <vector60>:
.globl vector60
vector60:
  pushl $0
80108023:	6a 00                	push   $0x0
  pushl $60
80108025:	6a 3c                	push   $0x3c
  jmp alltraps
80108027:	e9 bb f8 ff ff       	jmp    801078e7 <alltraps>

8010802c <vector61>:
.globl vector61
vector61:
  pushl $0
8010802c:	6a 00                	push   $0x0
  pushl $61
8010802e:	6a 3d                	push   $0x3d
  jmp alltraps
80108030:	e9 b2 f8 ff ff       	jmp    801078e7 <alltraps>

80108035 <vector62>:
.globl vector62
vector62:
  pushl $0
80108035:	6a 00                	push   $0x0
  pushl $62
80108037:	6a 3e                	push   $0x3e
  jmp alltraps
80108039:	e9 a9 f8 ff ff       	jmp    801078e7 <alltraps>

8010803e <vector63>:
.globl vector63
vector63:
  pushl $0
8010803e:	6a 00                	push   $0x0
  pushl $63
80108040:	6a 3f                	push   $0x3f
  jmp alltraps
80108042:	e9 a0 f8 ff ff       	jmp    801078e7 <alltraps>

80108047 <vector64>:
.globl vector64
vector64:
  pushl $0
80108047:	6a 00                	push   $0x0
  pushl $64
80108049:	6a 40                	push   $0x40
  jmp alltraps
8010804b:	e9 97 f8 ff ff       	jmp    801078e7 <alltraps>

80108050 <vector65>:
.globl vector65
vector65:
  pushl $0
80108050:	6a 00                	push   $0x0
  pushl $65
80108052:	6a 41                	push   $0x41
  jmp alltraps
80108054:	e9 8e f8 ff ff       	jmp    801078e7 <alltraps>

80108059 <vector66>:
.globl vector66
vector66:
  pushl $0
80108059:	6a 00                	push   $0x0
  pushl $66
8010805b:	6a 42                	push   $0x42
  jmp alltraps
8010805d:	e9 85 f8 ff ff       	jmp    801078e7 <alltraps>

80108062 <vector67>:
.globl vector67
vector67:
  pushl $0
80108062:	6a 00                	push   $0x0
  pushl $67
80108064:	6a 43                	push   $0x43
  jmp alltraps
80108066:	e9 7c f8 ff ff       	jmp    801078e7 <alltraps>

8010806b <vector68>:
.globl vector68
vector68:
  pushl $0
8010806b:	6a 00                	push   $0x0
  pushl $68
8010806d:	6a 44                	push   $0x44
  jmp alltraps
8010806f:	e9 73 f8 ff ff       	jmp    801078e7 <alltraps>

80108074 <vector69>:
.globl vector69
vector69:
  pushl $0
80108074:	6a 00                	push   $0x0
  pushl $69
80108076:	6a 45                	push   $0x45
  jmp alltraps
80108078:	e9 6a f8 ff ff       	jmp    801078e7 <alltraps>

8010807d <vector70>:
.globl vector70
vector70:
  pushl $0
8010807d:	6a 00                	push   $0x0
  pushl $70
8010807f:	6a 46                	push   $0x46
  jmp alltraps
80108081:	e9 61 f8 ff ff       	jmp    801078e7 <alltraps>

80108086 <vector71>:
.globl vector71
vector71:
  pushl $0
80108086:	6a 00                	push   $0x0
  pushl $71
80108088:	6a 47                	push   $0x47
  jmp alltraps
8010808a:	e9 58 f8 ff ff       	jmp    801078e7 <alltraps>

8010808f <vector72>:
.globl vector72
vector72:
  pushl $0
8010808f:	6a 00                	push   $0x0
  pushl $72
80108091:	6a 48                	push   $0x48
  jmp alltraps
80108093:	e9 4f f8 ff ff       	jmp    801078e7 <alltraps>

80108098 <vector73>:
.globl vector73
vector73:
  pushl $0
80108098:	6a 00                	push   $0x0
  pushl $73
8010809a:	6a 49                	push   $0x49
  jmp alltraps
8010809c:	e9 46 f8 ff ff       	jmp    801078e7 <alltraps>

801080a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801080a1:	6a 00                	push   $0x0
  pushl $74
801080a3:	6a 4a                	push   $0x4a
  jmp alltraps
801080a5:	e9 3d f8 ff ff       	jmp    801078e7 <alltraps>

801080aa <vector75>:
.globl vector75
vector75:
  pushl $0
801080aa:	6a 00                	push   $0x0
  pushl $75
801080ac:	6a 4b                	push   $0x4b
  jmp alltraps
801080ae:	e9 34 f8 ff ff       	jmp    801078e7 <alltraps>

801080b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801080b3:	6a 00                	push   $0x0
  pushl $76
801080b5:	6a 4c                	push   $0x4c
  jmp alltraps
801080b7:	e9 2b f8 ff ff       	jmp    801078e7 <alltraps>

801080bc <vector77>:
.globl vector77
vector77:
  pushl $0
801080bc:	6a 00                	push   $0x0
  pushl $77
801080be:	6a 4d                	push   $0x4d
  jmp alltraps
801080c0:	e9 22 f8 ff ff       	jmp    801078e7 <alltraps>

801080c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801080c5:	6a 00                	push   $0x0
  pushl $78
801080c7:	6a 4e                	push   $0x4e
  jmp alltraps
801080c9:	e9 19 f8 ff ff       	jmp    801078e7 <alltraps>

801080ce <vector79>:
.globl vector79
vector79:
  pushl $0
801080ce:	6a 00                	push   $0x0
  pushl $79
801080d0:	6a 4f                	push   $0x4f
  jmp alltraps
801080d2:	e9 10 f8 ff ff       	jmp    801078e7 <alltraps>

801080d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801080d7:	6a 00                	push   $0x0
  pushl $80
801080d9:	6a 50                	push   $0x50
  jmp alltraps
801080db:	e9 07 f8 ff ff       	jmp    801078e7 <alltraps>

801080e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801080e0:	6a 00                	push   $0x0
  pushl $81
801080e2:	6a 51                	push   $0x51
  jmp alltraps
801080e4:	e9 fe f7 ff ff       	jmp    801078e7 <alltraps>

801080e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801080e9:	6a 00                	push   $0x0
  pushl $82
801080eb:	6a 52                	push   $0x52
  jmp alltraps
801080ed:	e9 f5 f7 ff ff       	jmp    801078e7 <alltraps>

801080f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801080f2:	6a 00                	push   $0x0
  pushl $83
801080f4:	6a 53                	push   $0x53
  jmp alltraps
801080f6:	e9 ec f7 ff ff       	jmp    801078e7 <alltraps>

801080fb <vector84>:
.globl vector84
vector84:
  pushl $0
801080fb:	6a 00                	push   $0x0
  pushl $84
801080fd:	6a 54                	push   $0x54
  jmp alltraps
801080ff:	e9 e3 f7 ff ff       	jmp    801078e7 <alltraps>

80108104 <vector85>:
.globl vector85
vector85:
  pushl $0
80108104:	6a 00                	push   $0x0
  pushl $85
80108106:	6a 55                	push   $0x55
  jmp alltraps
80108108:	e9 da f7 ff ff       	jmp    801078e7 <alltraps>

8010810d <vector86>:
.globl vector86
vector86:
  pushl $0
8010810d:	6a 00                	push   $0x0
  pushl $86
8010810f:	6a 56                	push   $0x56
  jmp alltraps
80108111:	e9 d1 f7 ff ff       	jmp    801078e7 <alltraps>

80108116 <vector87>:
.globl vector87
vector87:
  pushl $0
80108116:	6a 00                	push   $0x0
  pushl $87
80108118:	6a 57                	push   $0x57
  jmp alltraps
8010811a:	e9 c8 f7 ff ff       	jmp    801078e7 <alltraps>

8010811f <vector88>:
.globl vector88
vector88:
  pushl $0
8010811f:	6a 00                	push   $0x0
  pushl $88
80108121:	6a 58                	push   $0x58
  jmp alltraps
80108123:	e9 bf f7 ff ff       	jmp    801078e7 <alltraps>

80108128 <vector89>:
.globl vector89
vector89:
  pushl $0
80108128:	6a 00                	push   $0x0
  pushl $89
8010812a:	6a 59                	push   $0x59
  jmp alltraps
8010812c:	e9 b6 f7 ff ff       	jmp    801078e7 <alltraps>

80108131 <vector90>:
.globl vector90
vector90:
  pushl $0
80108131:	6a 00                	push   $0x0
  pushl $90
80108133:	6a 5a                	push   $0x5a
  jmp alltraps
80108135:	e9 ad f7 ff ff       	jmp    801078e7 <alltraps>

8010813a <vector91>:
.globl vector91
vector91:
  pushl $0
8010813a:	6a 00                	push   $0x0
  pushl $91
8010813c:	6a 5b                	push   $0x5b
  jmp alltraps
8010813e:	e9 a4 f7 ff ff       	jmp    801078e7 <alltraps>

80108143 <vector92>:
.globl vector92
vector92:
  pushl $0
80108143:	6a 00                	push   $0x0
  pushl $92
80108145:	6a 5c                	push   $0x5c
  jmp alltraps
80108147:	e9 9b f7 ff ff       	jmp    801078e7 <alltraps>

8010814c <vector93>:
.globl vector93
vector93:
  pushl $0
8010814c:	6a 00                	push   $0x0
  pushl $93
8010814e:	6a 5d                	push   $0x5d
  jmp alltraps
80108150:	e9 92 f7 ff ff       	jmp    801078e7 <alltraps>

80108155 <vector94>:
.globl vector94
vector94:
  pushl $0
80108155:	6a 00                	push   $0x0
  pushl $94
80108157:	6a 5e                	push   $0x5e
  jmp alltraps
80108159:	e9 89 f7 ff ff       	jmp    801078e7 <alltraps>

8010815e <vector95>:
.globl vector95
vector95:
  pushl $0
8010815e:	6a 00                	push   $0x0
  pushl $95
80108160:	6a 5f                	push   $0x5f
  jmp alltraps
80108162:	e9 80 f7 ff ff       	jmp    801078e7 <alltraps>

80108167 <vector96>:
.globl vector96
vector96:
  pushl $0
80108167:	6a 00                	push   $0x0
  pushl $96
80108169:	6a 60                	push   $0x60
  jmp alltraps
8010816b:	e9 77 f7 ff ff       	jmp    801078e7 <alltraps>

80108170 <vector97>:
.globl vector97
vector97:
  pushl $0
80108170:	6a 00                	push   $0x0
  pushl $97
80108172:	6a 61                	push   $0x61
  jmp alltraps
80108174:	e9 6e f7 ff ff       	jmp    801078e7 <alltraps>

80108179 <vector98>:
.globl vector98
vector98:
  pushl $0
80108179:	6a 00                	push   $0x0
  pushl $98
8010817b:	6a 62                	push   $0x62
  jmp alltraps
8010817d:	e9 65 f7 ff ff       	jmp    801078e7 <alltraps>

80108182 <vector99>:
.globl vector99
vector99:
  pushl $0
80108182:	6a 00                	push   $0x0
  pushl $99
80108184:	6a 63                	push   $0x63
  jmp alltraps
80108186:	e9 5c f7 ff ff       	jmp    801078e7 <alltraps>

8010818b <vector100>:
.globl vector100
vector100:
  pushl $0
8010818b:	6a 00                	push   $0x0
  pushl $100
8010818d:	6a 64                	push   $0x64
  jmp alltraps
8010818f:	e9 53 f7 ff ff       	jmp    801078e7 <alltraps>

80108194 <vector101>:
.globl vector101
vector101:
  pushl $0
80108194:	6a 00                	push   $0x0
  pushl $101
80108196:	6a 65                	push   $0x65
  jmp alltraps
80108198:	e9 4a f7 ff ff       	jmp    801078e7 <alltraps>

8010819d <vector102>:
.globl vector102
vector102:
  pushl $0
8010819d:	6a 00                	push   $0x0
  pushl $102
8010819f:	6a 66                	push   $0x66
  jmp alltraps
801081a1:	e9 41 f7 ff ff       	jmp    801078e7 <alltraps>

801081a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801081a6:	6a 00                	push   $0x0
  pushl $103
801081a8:	6a 67                	push   $0x67
  jmp alltraps
801081aa:	e9 38 f7 ff ff       	jmp    801078e7 <alltraps>

801081af <vector104>:
.globl vector104
vector104:
  pushl $0
801081af:	6a 00                	push   $0x0
  pushl $104
801081b1:	6a 68                	push   $0x68
  jmp alltraps
801081b3:	e9 2f f7 ff ff       	jmp    801078e7 <alltraps>

801081b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801081b8:	6a 00                	push   $0x0
  pushl $105
801081ba:	6a 69                	push   $0x69
  jmp alltraps
801081bc:	e9 26 f7 ff ff       	jmp    801078e7 <alltraps>

801081c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801081c1:	6a 00                	push   $0x0
  pushl $106
801081c3:	6a 6a                	push   $0x6a
  jmp alltraps
801081c5:	e9 1d f7 ff ff       	jmp    801078e7 <alltraps>

801081ca <vector107>:
.globl vector107
vector107:
  pushl $0
801081ca:	6a 00                	push   $0x0
  pushl $107
801081cc:	6a 6b                	push   $0x6b
  jmp alltraps
801081ce:	e9 14 f7 ff ff       	jmp    801078e7 <alltraps>

801081d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801081d3:	6a 00                	push   $0x0
  pushl $108
801081d5:	6a 6c                	push   $0x6c
  jmp alltraps
801081d7:	e9 0b f7 ff ff       	jmp    801078e7 <alltraps>

801081dc <vector109>:
.globl vector109
vector109:
  pushl $0
801081dc:	6a 00                	push   $0x0
  pushl $109
801081de:	6a 6d                	push   $0x6d
  jmp alltraps
801081e0:	e9 02 f7 ff ff       	jmp    801078e7 <alltraps>

801081e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801081e5:	6a 00                	push   $0x0
  pushl $110
801081e7:	6a 6e                	push   $0x6e
  jmp alltraps
801081e9:	e9 f9 f6 ff ff       	jmp    801078e7 <alltraps>

801081ee <vector111>:
.globl vector111
vector111:
  pushl $0
801081ee:	6a 00                	push   $0x0
  pushl $111
801081f0:	6a 6f                	push   $0x6f
  jmp alltraps
801081f2:	e9 f0 f6 ff ff       	jmp    801078e7 <alltraps>

801081f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801081f7:	6a 00                	push   $0x0
  pushl $112
801081f9:	6a 70                	push   $0x70
  jmp alltraps
801081fb:	e9 e7 f6 ff ff       	jmp    801078e7 <alltraps>

80108200 <vector113>:
.globl vector113
vector113:
  pushl $0
80108200:	6a 00                	push   $0x0
  pushl $113
80108202:	6a 71                	push   $0x71
  jmp alltraps
80108204:	e9 de f6 ff ff       	jmp    801078e7 <alltraps>

80108209 <vector114>:
.globl vector114
vector114:
  pushl $0
80108209:	6a 00                	push   $0x0
  pushl $114
8010820b:	6a 72                	push   $0x72
  jmp alltraps
8010820d:	e9 d5 f6 ff ff       	jmp    801078e7 <alltraps>

80108212 <vector115>:
.globl vector115
vector115:
  pushl $0
80108212:	6a 00                	push   $0x0
  pushl $115
80108214:	6a 73                	push   $0x73
  jmp alltraps
80108216:	e9 cc f6 ff ff       	jmp    801078e7 <alltraps>

8010821b <vector116>:
.globl vector116
vector116:
  pushl $0
8010821b:	6a 00                	push   $0x0
  pushl $116
8010821d:	6a 74                	push   $0x74
  jmp alltraps
8010821f:	e9 c3 f6 ff ff       	jmp    801078e7 <alltraps>

80108224 <vector117>:
.globl vector117
vector117:
  pushl $0
80108224:	6a 00                	push   $0x0
  pushl $117
80108226:	6a 75                	push   $0x75
  jmp alltraps
80108228:	e9 ba f6 ff ff       	jmp    801078e7 <alltraps>

8010822d <vector118>:
.globl vector118
vector118:
  pushl $0
8010822d:	6a 00                	push   $0x0
  pushl $118
8010822f:	6a 76                	push   $0x76
  jmp alltraps
80108231:	e9 b1 f6 ff ff       	jmp    801078e7 <alltraps>

80108236 <vector119>:
.globl vector119
vector119:
  pushl $0
80108236:	6a 00                	push   $0x0
  pushl $119
80108238:	6a 77                	push   $0x77
  jmp alltraps
8010823a:	e9 a8 f6 ff ff       	jmp    801078e7 <alltraps>

8010823f <vector120>:
.globl vector120
vector120:
  pushl $0
8010823f:	6a 00                	push   $0x0
  pushl $120
80108241:	6a 78                	push   $0x78
  jmp alltraps
80108243:	e9 9f f6 ff ff       	jmp    801078e7 <alltraps>

80108248 <vector121>:
.globl vector121
vector121:
  pushl $0
80108248:	6a 00                	push   $0x0
  pushl $121
8010824a:	6a 79                	push   $0x79
  jmp alltraps
8010824c:	e9 96 f6 ff ff       	jmp    801078e7 <alltraps>

80108251 <vector122>:
.globl vector122
vector122:
  pushl $0
80108251:	6a 00                	push   $0x0
  pushl $122
80108253:	6a 7a                	push   $0x7a
  jmp alltraps
80108255:	e9 8d f6 ff ff       	jmp    801078e7 <alltraps>

8010825a <vector123>:
.globl vector123
vector123:
  pushl $0
8010825a:	6a 00                	push   $0x0
  pushl $123
8010825c:	6a 7b                	push   $0x7b
  jmp alltraps
8010825e:	e9 84 f6 ff ff       	jmp    801078e7 <alltraps>

80108263 <vector124>:
.globl vector124
vector124:
  pushl $0
80108263:	6a 00                	push   $0x0
  pushl $124
80108265:	6a 7c                	push   $0x7c
  jmp alltraps
80108267:	e9 7b f6 ff ff       	jmp    801078e7 <alltraps>

8010826c <vector125>:
.globl vector125
vector125:
  pushl $0
8010826c:	6a 00                	push   $0x0
  pushl $125
8010826e:	6a 7d                	push   $0x7d
  jmp alltraps
80108270:	e9 72 f6 ff ff       	jmp    801078e7 <alltraps>

80108275 <vector126>:
.globl vector126
vector126:
  pushl $0
80108275:	6a 00                	push   $0x0
  pushl $126
80108277:	6a 7e                	push   $0x7e
  jmp alltraps
80108279:	e9 69 f6 ff ff       	jmp    801078e7 <alltraps>

8010827e <vector127>:
.globl vector127
vector127:
  pushl $0
8010827e:	6a 00                	push   $0x0
  pushl $127
80108280:	6a 7f                	push   $0x7f
  jmp alltraps
80108282:	e9 60 f6 ff ff       	jmp    801078e7 <alltraps>

80108287 <vector128>:
.globl vector128
vector128:
  pushl $0
80108287:	6a 00                	push   $0x0
  pushl $128
80108289:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010828e:	e9 54 f6 ff ff       	jmp    801078e7 <alltraps>

80108293 <vector129>:
.globl vector129
vector129:
  pushl $0
80108293:	6a 00                	push   $0x0
  pushl $129
80108295:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010829a:	e9 48 f6 ff ff       	jmp    801078e7 <alltraps>

8010829f <vector130>:
.globl vector130
vector130:
  pushl $0
8010829f:	6a 00                	push   $0x0
  pushl $130
801082a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801082a6:	e9 3c f6 ff ff       	jmp    801078e7 <alltraps>

801082ab <vector131>:
.globl vector131
vector131:
  pushl $0
801082ab:	6a 00                	push   $0x0
  pushl $131
801082ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801082b2:	e9 30 f6 ff ff       	jmp    801078e7 <alltraps>

801082b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801082b7:	6a 00                	push   $0x0
  pushl $132
801082b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801082be:	e9 24 f6 ff ff       	jmp    801078e7 <alltraps>

801082c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801082c3:	6a 00                	push   $0x0
  pushl $133
801082c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801082ca:	e9 18 f6 ff ff       	jmp    801078e7 <alltraps>

801082cf <vector134>:
.globl vector134
vector134:
  pushl $0
801082cf:	6a 00                	push   $0x0
  pushl $134
801082d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801082d6:	e9 0c f6 ff ff       	jmp    801078e7 <alltraps>

801082db <vector135>:
.globl vector135
vector135:
  pushl $0
801082db:	6a 00                	push   $0x0
  pushl $135
801082dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801082e2:	e9 00 f6 ff ff       	jmp    801078e7 <alltraps>

801082e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801082e7:	6a 00                	push   $0x0
  pushl $136
801082e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801082ee:	e9 f4 f5 ff ff       	jmp    801078e7 <alltraps>

801082f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801082f3:	6a 00                	push   $0x0
  pushl $137
801082f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801082fa:	e9 e8 f5 ff ff       	jmp    801078e7 <alltraps>

801082ff <vector138>:
.globl vector138
vector138:
  pushl $0
801082ff:	6a 00                	push   $0x0
  pushl $138
80108301:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108306:	e9 dc f5 ff ff       	jmp    801078e7 <alltraps>

8010830b <vector139>:
.globl vector139
vector139:
  pushl $0
8010830b:	6a 00                	push   $0x0
  pushl $139
8010830d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108312:	e9 d0 f5 ff ff       	jmp    801078e7 <alltraps>

80108317 <vector140>:
.globl vector140
vector140:
  pushl $0
80108317:	6a 00                	push   $0x0
  pushl $140
80108319:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010831e:	e9 c4 f5 ff ff       	jmp    801078e7 <alltraps>

80108323 <vector141>:
.globl vector141
vector141:
  pushl $0
80108323:	6a 00                	push   $0x0
  pushl $141
80108325:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010832a:	e9 b8 f5 ff ff       	jmp    801078e7 <alltraps>

8010832f <vector142>:
.globl vector142
vector142:
  pushl $0
8010832f:	6a 00                	push   $0x0
  pushl $142
80108331:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108336:	e9 ac f5 ff ff       	jmp    801078e7 <alltraps>

8010833b <vector143>:
.globl vector143
vector143:
  pushl $0
8010833b:	6a 00                	push   $0x0
  pushl $143
8010833d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108342:	e9 a0 f5 ff ff       	jmp    801078e7 <alltraps>

80108347 <vector144>:
.globl vector144
vector144:
  pushl $0
80108347:	6a 00                	push   $0x0
  pushl $144
80108349:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010834e:	e9 94 f5 ff ff       	jmp    801078e7 <alltraps>

80108353 <vector145>:
.globl vector145
vector145:
  pushl $0
80108353:	6a 00                	push   $0x0
  pushl $145
80108355:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010835a:	e9 88 f5 ff ff       	jmp    801078e7 <alltraps>

8010835f <vector146>:
.globl vector146
vector146:
  pushl $0
8010835f:	6a 00                	push   $0x0
  pushl $146
80108361:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108366:	e9 7c f5 ff ff       	jmp    801078e7 <alltraps>

8010836b <vector147>:
.globl vector147
vector147:
  pushl $0
8010836b:	6a 00                	push   $0x0
  pushl $147
8010836d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108372:	e9 70 f5 ff ff       	jmp    801078e7 <alltraps>

80108377 <vector148>:
.globl vector148
vector148:
  pushl $0
80108377:	6a 00                	push   $0x0
  pushl $148
80108379:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010837e:	e9 64 f5 ff ff       	jmp    801078e7 <alltraps>

80108383 <vector149>:
.globl vector149
vector149:
  pushl $0
80108383:	6a 00                	push   $0x0
  pushl $149
80108385:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010838a:	e9 58 f5 ff ff       	jmp    801078e7 <alltraps>

8010838f <vector150>:
.globl vector150
vector150:
  pushl $0
8010838f:	6a 00                	push   $0x0
  pushl $150
80108391:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108396:	e9 4c f5 ff ff       	jmp    801078e7 <alltraps>

8010839b <vector151>:
.globl vector151
vector151:
  pushl $0
8010839b:	6a 00                	push   $0x0
  pushl $151
8010839d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801083a2:	e9 40 f5 ff ff       	jmp    801078e7 <alltraps>

801083a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801083a7:	6a 00                	push   $0x0
  pushl $152
801083a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801083ae:	e9 34 f5 ff ff       	jmp    801078e7 <alltraps>

801083b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801083b3:	6a 00                	push   $0x0
  pushl $153
801083b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801083ba:	e9 28 f5 ff ff       	jmp    801078e7 <alltraps>

801083bf <vector154>:
.globl vector154
vector154:
  pushl $0
801083bf:	6a 00                	push   $0x0
  pushl $154
801083c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801083c6:	e9 1c f5 ff ff       	jmp    801078e7 <alltraps>

801083cb <vector155>:
.globl vector155
vector155:
  pushl $0
801083cb:	6a 00                	push   $0x0
  pushl $155
801083cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801083d2:	e9 10 f5 ff ff       	jmp    801078e7 <alltraps>

801083d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801083d7:	6a 00                	push   $0x0
  pushl $156
801083d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801083de:	e9 04 f5 ff ff       	jmp    801078e7 <alltraps>

801083e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801083e3:	6a 00                	push   $0x0
  pushl $157
801083e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801083ea:	e9 f8 f4 ff ff       	jmp    801078e7 <alltraps>

801083ef <vector158>:
.globl vector158
vector158:
  pushl $0
801083ef:	6a 00                	push   $0x0
  pushl $158
801083f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801083f6:	e9 ec f4 ff ff       	jmp    801078e7 <alltraps>

801083fb <vector159>:
.globl vector159
vector159:
  pushl $0
801083fb:	6a 00                	push   $0x0
  pushl $159
801083fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108402:	e9 e0 f4 ff ff       	jmp    801078e7 <alltraps>

80108407 <vector160>:
.globl vector160
vector160:
  pushl $0
80108407:	6a 00                	push   $0x0
  pushl $160
80108409:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010840e:	e9 d4 f4 ff ff       	jmp    801078e7 <alltraps>

80108413 <vector161>:
.globl vector161
vector161:
  pushl $0
80108413:	6a 00                	push   $0x0
  pushl $161
80108415:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010841a:	e9 c8 f4 ff ff       	jmp    801078e7 <alltraps>

8010841f <vector162>:
.globl vector162
vector162:
  pushl $0
8010841f:	6a 00                	push   $0x0
  pushl $162
80108421:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108426:	e9 bc f4 ff ff       	jmp    801078e7 <alltraps>

8010842b <vector163>:
.globl vector163
vector163:
  pushl $0
8010842b:	6a 00                	push   $0x0
  pushl $163
8010842d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108432:	e9 b0 f4 ff ff       	jmp    801078e7 <alltraps>

80108437 <vector164>:
.globl vector164
vector164:
  pushl $0
80108437:	6a 00                	push   $0x0
  pushl $164
80108439:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010843e:	e9 a4 f4 ff ff       	jmp    801078e7 <alltraps>

80108443 <vector165>:
.globl vector165
vector165:
  pushl $0
80108443:	6a 00                	push   $0x0
  pushl $165
80108445:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010844a:	e9 98 f4 ff ff       	jmp    801078e7 <alltraps>

8010844f <vector166>:
.globl vector166
vector166:
  pushl $0
8010844f:	6a 00                	push   $0x0
  pushl $166
80108451:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108456:	e9 8c f4 ff ff       	jmp    801078e7 <alltraps>

8010845b <vector167>:
.globl vector167
vector167:
  pushl $0
8010845b:	6a 00                	push   $0x0
  pushl $167
8010845d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108462:	e9 80 f4 ff ff       	jmp    801078e7 <alltraps>

80108467 <vector168>:
.globl vector168
vector168:
  pushl $0
80108467:	6a 00                	push   $0x0
  pushl $168
80108469:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010846e:	e9 74 f4 ff ff       	jmp    801078e7 <alltraps>

80108473 <vector169>:
.globl vector169
vector169:
  pushl $0
80108473:	6a 00                	push   $0x0
  pushl $169
80108475:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010847a:	e9 68 f4 ff ff       	jmp    801078e7 <alltraps>

8010847f <vector170>:
.globl vector170
vector170:
  pushl $0
8010847f:	6a 00                	push   $0x0
  pushl $170
80108481:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108486:	e9 5c f4 ff ff       	jmp    801078e7 <alltraps>

8010848b <vector171>:
.globl vector171
vector171:
  pushl $0
8010848b:	6a 00                	push   $0x0
  pushl $171
8010848d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108492:	e9 50 f4 ff ff       	jmp    801078e7 <alltraps>

80108497 <vector172>:
.globl vector172
vector172:
  pushl $0
80108497:	6a 00                	push   $0x0
  pushl $172
80108499:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010849e:	e9 44 f4 ff ff       	jmp    801078e7 <alltraps>

801084a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801084a3:	6a 00                	push   $0x0
  pushl $173
801084a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801084aa:	e9 38 f4 ff ff       	jmp    801078e7 <alltraps>

801084af <vector174>:
.globl vector174
vector174:
  pushl $0
801084af:	6a 00                	push   $0x0
  pushl $174
801084b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801084b6:	e9 2c f4 ff ff       	jmp    801078e7 <alltraps>

801084bb <vector175>:
.globl vector175
vector175:
  pushl $0
801084bb:	6a 00                	push   $0x0
  pushl $175
801084bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801084c2:	e9 20 f4 ff ff       	jmp    801078e7 <alltraps>

801084c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801084c7:	6a 00                	push   $0x0
  pushl $176
801084c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801084ce:	e9 14 f4 ff ff       	jmp    801078e7 <alltraps>

801084d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801084d3:	6a 00                	push   $0x0
  pushl $177
801084d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801084da:	e9 08 f4 ff ff       	jmp    801078e7 <alltraps>

801084df <vector178>:
.globl vector178
vector178:
  pushl $0
801084df:	6a 00                	push   $0x0
  pushl $178
801084e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801084e6:	e9 fc f3 ff ff       	jmp    801078e7 <alltraps>

801084eb <vector179>:
.globl vector179
vector179:
  pushl $0
801084eb:	6a 00                	push   $0x0
  pushl $179
801084ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801084f2:	e9 f0 f3 ff ff       	jmp    801078e7 <alltraps>

801084f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801084f7:	6a 00                	push   $0x0
  pushl $180
801084f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801084fe:	e9 e4 f3 ff ff       	jmp    801078e7 <alltraps>

80108503 <vector181>:
.globl vector181
vector181:
  pushl $0
80108503:	6a 00                	push   $0x0
  pushl $181
80108505:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010850a:	e9 d8 f3 ff ff       	jmp    801078e7 <alltraps>

8010850f <vector182>:
.globl vector182
vector182:
  pushl $0
8010850f:	6a 00                	push   $0x0
  pushl $182
80108511:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108516:	e9 cc f3 ff ff       	jmp    801078e7 <alltraps>

8010851b <vector183>:
.globl vector183
vector183:
  pushl $0
8010851b:	6a 00                	push   $0x0
  pushl $183
8010851d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108522:	e9 c0 f3 ff ff       	jmp    801078e7 <alltraps>

80108527 <vector184>:
.globl vector184
vector184:
  pushl $0
80108527:	6a 00                	push   $0x0
  pushl $184
80108529:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010852e:	e9 b4 f3 ff ff       	jmp    801078e7 <alltraps>

80108533 <vector185>:
.globl vector185
vector185:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $185
80108535:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010853a:	e9 a8 f3 ff ff       	jmp    801078e7 <alltraps>

8010853f <vector186>:
.globl vector186
vector186:
  pushl $0
8010853f:	6a 00                	push   $0x0
  pushl $186
80108541:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108546:	e9 9c f3 ff ff       	jmp    801078e7 <alltraps>

8010854b <vector187>:
.globl vector187
vector187:
  pushl $0
8010854b:	6a 00                	push   $0x0
  pushl $187
8010854d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108552:	e9 90 f3 ff ff       	jmp    801078e7 <alltraps>

80108557 <vector188>:
.globl vector188
vector188:
  pushl $0
80108557:	6a 00                	push   $0x0
  pushl $188
80108559:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010855e:	e9 84 f3 ff ff       	jmp    801078e7 <alltraps>

80108563 <vector189>:
.globl vector189
vector189:
  pushl $0
80108563:	6a 00                	push   $0x0
  pushl $189
80108565:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010856a:	e9 78 f3 ff ff       	jmp    801078e7 <alltraps>

8010856f <vector190>:
.globl vector190
vector190:
  pushl $0
8010856f:	6a 00                	push   $0x0
  pushl $190
80108571:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108576:	e9 6c f3 ff ff       	jmp    801078e7 <alltraps>

8010857b <vector191>:
.globl vector191
vector191:
  pushl $0
8010857b:	6a 00                	push   $0x0
  pushl $191
8010857d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108582:	e9 60 f3 ff ff       	jmp    801078e7 <alltraps>

80108587 <vector192>:
.globl vector192
vector192:
  pushl $0
80108587:	6a 00                	push   $0x0
  pushl $192
80108589:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010858e:	e9 54 f3 ff ff       	jmp    801078e7 <alltraps>

80108593 <vector193>:
.globl vector193
vector193:
  pushl $0
80108593:	6a 00                	push   $0x0
  pushl $193
80108595:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010859a:	e9 48 f3 ff ff       	jmp    801078e7 <alltraps>

8010859f <vector194>:
.globl vector194
vector194:
  pushl $0
8010859f:	6a 00                	push   $0x0
  pushl $194
801085a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801085a6:	e9 3c f3 ff ff       	jmp    801078e7 <alltraps>

801085ab <vector195>:
.globl vector195
vector195:
  pushl $0
801085ab:	6a 00                	push   $0x0
  pushl $195
801085ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801085b2:	e9 30 f3 ff ff       	jmp    801078e7 <alltraps>

801085b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801085b7:	6a 00                	push   $0x0
  pushl $196
801085b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801085be:	e9 24 f3 ff ff       	jmp    801078e7 <alltraps>

801085c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801085c3:	6a 00                	push   $0x0
  pushl $197
801085c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801085ca:	e9 18 f3 ff ff       	jmp    801078e7 <alltraps>

801085cf <vector198>:
.globl vector198
vector198:
  pushl $0
801085cf:	6a 00                	push   $0x0
  pushl $198
801085d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801085d6:	e9 0c f3 ff ff       	jmp    801078e7 <alltraps>

801085db <vector199>:
.globl vector199
vector199:
  pushl $0
801085db:	6a 00                	push   $0x0
  pushl $199
801085dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801085e2:	e9 00 f3 ff ff       	jmp    801078e7 <alltraps>

801085e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801085e7:	6a 00                	push   $0x0
  pushl $200
801085e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801085ee:	e9 f4 f2 ff ff       	jmp    801078e7 <alltraps>

801085f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801085f3:	6a 00                	push   $0x0
  pushl $201
801085f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801085fa:	e9 e8 f2 ff ff       	jmp    801078e7 <alltraps>

801085ff <vector202>:
.globl vector202
vector202:
  pushl $0
801085ff:	6a 00                	push   $0x0
  pushl $202
80108601:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108606:	e9 dc f2 ff ff       	jmp    801078e7 <alltraps>

8010860b <vector203>:
.globl vector203
vector203:
  pushl $0
8010860b:	6a 00                	push   $0x0
  pushl $203
8010860d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108612:	e9 d0 f2 ff ff       	jmp    801078e7 <alltraps>

80108617 <vector204>:
.globl vector204
vector204:
  pushl $0
80108617:	6a 00                	push   $0x0
  pushl $204
80108619:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010861e:	e9 c4 f2 ff ff       	jmp    801078e7 <alltraps>

80108623 <vector205>:
.globl vector205
vector205:
  pushl $0
80108623:	6a 00                	push   $0x0
  pushl $205
80108625:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010862a:	e9 b8 f2 ff ff       	jmp    801078e7 <alltraps>

8010862f <vector206>:
.globl vector206
vector206:
  pushl $0
8010862f:	6a 00                	push   $0x0
  pushl $206
80108631:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108636:	e9 ac f2 ff ff       	jmp    801078e7 <alltraps>

8010863b <vector207>:
.globl vector207
vector207:
  pushl $0
8010863b:	6a 00                	push   $0x0
  pushl $207
8010863d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108642:	e9 a0 f2 ff ff       	jmp    801078e7 <alltraps>

80108647 <vector208>:
.globl vector208
vector208:
  pushl $0
80108647:	6a 00                	push   $0x0
  pushl $208
80108649:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010864e:	e9 94 f2 ff ff       	jmp    801078e7 <alltraps>

80108653 <vector209>:
.globl vector209
vector209:
  pushl $0
80108653:	6a 00                	push   $0x0
  pushl $209
80108655:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010865a:	e9 88 f2 ff ff       	jmp    801078e7 <alltraps>

8010865f <vector210>:
.globl vector210
vector210:
  pushl $0
8010865f:	6a 00                	push   $0x0
  pushl $210
80108661:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108666:	e9 7c f2 ff ff       	jmp    801078e7 <alltraps>

8010866b <vector211>:
.globl vector211
vector211:
  pushl $0
8010866b:	6a 00                	push   $0x0
  pushl $211
8010866d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108672:	e9 70 f2 ff ff       	jmp    801078e7 <alltraps>

80108677 <vector212>:
.globl vector212
vector212:
  pushl $0
80108677:	6a 00                	push   $0x0
  pushl $212
80108679:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010867e:	e9 64 f2 ff ff       	jmp    801078e7 <alltraps>

80108683 <vector213>:
.globl vector213
vector213:
  pushl $0
80108683:	6a 00                	push   $0x0
  pushl $213
80108685:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010868a:	e9 58 f2 ff ff       	jmp    801078e7 <alltraps>

8010868f <vector214>:
.globl vector214
vector214:
  pushl $0
8010868f:	6a 00                	push   $0x0
  pushl $214
80108691:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108696:	e9 4c f2 ff ff       	jmp    801078e7 <alltraps>

8010869b <vector215>:
.globl vector215
vector215:
  pushl $0
8010869b:	6a 00                	push   $0x0
  pushl $215
8010869d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801086a2:	e9 40 f2 ff ff       	jmp    801078e7 <alltraps>

801086a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801086a7:	6a 00                	push   $0x0
  pushl $216
801086a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801086ae:	e9 34 f2 ff ff       	jmp    801078e7 <alltraps>

801086b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801086b3:	6a 00                	push   $0x0
  pushl $217
801086b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801086ba:	e9 28 f2 ff ff       	jmp    801078e7 <alltraps>

801086bf <vector218>:
.globl vector218
vector218:
  pushl $0
801086bf:	6a 00                	push   $0x0
  pushl $218
801086c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801086c6:	e9 1c f2 ff ff       	jmp    801078e7 <alltraps>

801086cb <vector219>:
.globl vector219
vector219:
  pushl $0
801086cb:	6a 00                	push   $0x0
  pushl $219
801086cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801086d2:	e9 10 f2 ff ff       	jmp    801078e7 <alltraps>

801086d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801086d7:	6a 00                	push   $0x0
  pushl $220
801086d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801086de:	e9 04 f2 ff ff       	jmp    801078e7 <alltraps>

801086e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801086e3:	6a 00                	push   $0x0
  pushl $221
801086e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801086ea:	e9 f8 f1 ff ff       	jmp    801078e7 <alltraps>

801086ef <vector222>:
.globl vector222
vector222:
  pushl $0
801086ef:	6a 00                	push   $0x0
  pushl $222
801086f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801086f6:	e9 ec f1 ff ff       	jmp    801078e7 <alltraps>

801086fb <vector223>:
.globl vector223
vector223:
  pushl $0
801086fb:	6a 00                	push   $0x0
  pushl $223
801086fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108702:	e9 e0 f1 ff ff       	jmp    801078e7 <alltraps>

80108707 <vector224>:
.globl vector224
vector224:
  pushl $0
80108707:	6a 00                	push   $0x0
  pushl $224
80108709:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010870e:	e9 d4 f1 ff ff       	jmp    801078e7 <alltraps>

80108713 <vector225>:
.globl vector225
vector225:
  pushl $0
80108713:	6a 00                	push   $0x0
  pushl $225
80108715:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010871a:	e9 c8 f1 ff ff       	jmp    801078e7 <alltraps>

8010871f <vector226>:
.globl vector226
vector226:
  pushl $0
8010871f:	6a 00                	push   $0x0
  pushl $226
80108721:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108726:	e9 bc f1 ff ff       	jmp    801078e7 <alltraps>

8010872b <vector227>:
.globl vector227
vector227:
  pushl $0
8010872b:	6a 00                	push   $0x0
  pushl $227
8010872d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108732:	e9 b0 f1 ff ff       	jmp    801078e7 <alltraps>

80108737 <vector228>:
.globl vector228
vector228:
  pushl $0
80108737:	6a 00                	push   $0x0
  pushl $228
80108739:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010873e:	e9 a4 f1 ff ff       	jmp    801078e7 <alltraps>

80108743 <vector229>:
.globl vector229
vector229:
  pushl $0
80108743:	6a 00                	push   $0x0
  pushl $229
80108745:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010874a:	e9 98 f1 ff ff       	jmp    801078e7 <alltraps>

8010874f <vector230>:
.globl vector230
vector230:
  pushl $0
8010874f:	6a 00                	push   $0x0
  pushl $230
80108751:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108756:	e9 8c f1 ff ff       	jmp    801078e7 <alltraps>

8010875b <vector231>:
.globl vector231
vector231:
  pushl $0
8010875b:	6a 00                	push   $0x0
  pushl $231
8010875d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108762:	e9 80 f1 ff ff       	jmp    801078e7 <alltraps>

80108767 <vector232>:
.globl vector232
vector232:
  pushl $0
80108767:	6a 00                	push   $0x0
  pushl $232
80108769:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010876e:	e9 74 f1 ff ff       	jmp    801078e7 <alltraps>

80108773 <vector233>:
.globl vector233
vector233:
  pushl $0
80108773:	6a 00                	push   $0x0
  pushl $233
80108775:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010877a:	e9 68 f1 ff ff       	jmp    801078e7 <alltraps>

8010877f <vector234>:
.globl vector234
vector234:
  pushl $0
8010877f:	6a 00                	push   $0x0
  pushl $234
80108781:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108786:	e9 5c f1 ff ff       	jmp    801078e7 <alltraps>

8010878b <vector235>:
.globl vector235
vector235:
  pushl $0
8010878b:	6a 00                	push   $0x0
  pushl $235
8010878d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108792:	e9 50 f1 ff ff       	jmp    801078e7 <alltraps>

80108797 <vector236>:
.globl vector236
vector236:
  pushl $0
80108797:	6a 00                	push   $0x0
  pushl $236
80108799:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010879e:	e9 44 f1 ff ff       	jmp    801078e7 <alltraps>

801087a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801087a3:	6a 00                	push   $0x0
  pushl $237
801087a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801087aa:	e9 38 f1 ff ff       	jmp    801078e7 <alltraps>

801087af <vector238>:
.globl vector238
vector238:
  pushl $0
801087af:	6a 00                	push   $0x0
  pushl $238
801087b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801087b6:	e9 2c f1 ff ff       	jmp    801078e7 <alltraps>

801087bb <vector239>:
.globl vector239
vector239:
  pushl $0
801087bb:	6a 00                	push   $0x0
  pushl $239
801087bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801087c2:	e9 20 f1 ff ff       	jmp    801078e7 <alltraps>

801087c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801087c7:	6a 00                	push   $0x0
  pushl $240
801087c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801087ce:	e9 14 f1 ff ff       	jmp    801078e7 <alltraps>

801087d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801087d3:	6a 00                	push   $0x0
  pushl $241
801087d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801087da:	e9 08 f1 ff ff       	jmp    801078e7 <alltraps>

801087df <vector242>:
.globl vector242
vector242:
  pushl $0
801087df:	6a 00                	push   $0x0
  pushl $242
801087e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801087e6:	e9 fc f0 ff ff       	jmp    801078e7 <alltraps>

801087eb <vector243>:
.globl vector243
vector243:
  pushl $0
801087eb:	6a 00                	push   $0x0
  pushl $243
801087ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801087f2:	e9 f0 f0 ff ff       	jmp    801078e7 <alltraps>

801087f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801087f7:	6a 00                	push   $0x0
  pushl $244
801087f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801087fe:	e9 e4 f0 ff ff       	jmp    801078e7 <alltraps>

80108803 <vector245>:
.globl vector245
vector245:
  pushl $0
80108803:	6a 00                	push   $0x0
  pushl $245
80108805:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010880a:	e9 d8 f0 ff ff       	jmp    801078e7 <alltraps>

8010880f <vector246>:
.globl vector246
vector246:
  pushl $0
8010880f:	6a 00                	push   $0x0
  pushl $246
80108811:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108816:	e9 cc f0 ff ff       	jmp    801078e7 <alltraps>

8010881b <vector247>:
.globl vector247
vector247:
  pushl $0
8010881b:	6a 00                	push   $0x0
  pushl $247
8010881d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108822:	e9 c0 f0 ff ff       	jmp    801078e7 <alltraps>

80108827 <vector248>:
.globl vector248
vector248:
  pushl $0
80108827:	6a 00                	push   $0x0
  pushl $248
80108829:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010882e:	e9 b4 f0 ff ff       	jmp    801078e7 <alltraps>

80108833 <vector249>:
.globl vector249
vector249:
  pushl $0
80108833:	6a 00                	push   $0x0
  pushl $249
80108835:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010883a:	e9 a8 f0 ff ff       	jmp    801078e7 <alltraps>

8010883f <vector250>:
.globl vector250
vector250:
  pushl $0
8010883f:	6a 00                	push   $0x0
  pushl $250
80108841:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108846:	e9 9c f0 ff ff       	jmp    801078e7 <alltraps>

8010884b <vector251>:
.globl vector251
vector251:
  pushl $0
8010884b:	6a 00                	push   $0x0
  pushl $251
8010884d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108852:	e9 90 f0 ff ff       	jmp    801078e7 <alltraps>

80108857 <vector252>:
.globl vector252
vector252:
  pushl $0
80108857:	6a 00                	push   $0x0
  pushl $252
80108859:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010885e:	e9 84 f0 ff ff       	jmp    801078e7 <alltraps>

80108863 <vector253>:
.globl vector253
vector253:
  pushl $0
80108863:	6a 00                	push   $0x0
  pushl $253
80108865:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010886a:	e9 78 f0 ff ff       	jmp    801078e7 <alltraps>

8010886f <vector254>:
.globl vector254
vector254:
  pushl $0
8010886f:	6a 00                	push   $0x0
  pushl $254
80108871:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108876:	e9 6c f0 ff ff       	jmp    801078e7 <alltraps>

8010887b <vector255>:
.globl vector255
vector255:
  pushl $0
8010887b:	6a 00                	push   $0x0
  pushl $255
8010887d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108882:	e9 60 f0 ff ff       	jmp    801078e7 <alltraps>
80108887:	66 90                	xchg   %ax,%ax
80108889:	66 90                	xchg   %ax,%ax
8010888b:	66 90                	xchg   %ax,%ax
8010888d:	66 90                	xchg   %ax,%ax
8010888f:	90                   	nop

80108890 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108890:	55                   	push   %ebp
80108891:	89 e5                	mov    %esp,%ebp
80108893:	57                   	push   %edi
80108894:	56                   	push   %esi
80108895:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108896:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010889c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801088a2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801088a5:	39 d3                	cmp    %edx,%ebx
801088a7:	73 56                	jae    801088ff <deallocuvm.part.0+0x6f>
801088a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801088ac:	89 c6                	mov    %eax,%esi
801088ae:	89 d7                	mov    %edx,%edi
801088b0:	eb 12                	jmp    801088c4 <deallocuvm.part.0+0x34>
801088b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801088b8:	83 c2 01             	add    $0x1,%edx
801088bb:	89 d3                	mov    %edx,%ebx
801088bd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801088c0:	39 fb                	cmp    %edi,%ebx
801088c2:	73 38                	jae    801088fc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801088c4:	89 da                	mov    %ebx,%edx
801088c6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801088c9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801088cc:	a8 01                	test   $0x1,%al
801088ce:	74 e8                	je     801088b8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801088d0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801088d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801088d7:	c1 e9 0a             	shr    $0xa,%ecx
801088da:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801088e0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801088e7:	85 c0                	test   %eax,%eax
801088e9:	74 cd                	je     801088b8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801088eb:	8b 10                	mov    (%eax),%edx
801088ed:	f6 c2 01             	test   $0x1,%dl
801088f0:	75 1e                	jne    80108910 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801088f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801088f8:	39 fb                	cmp    %edi,%ebx
801088fa:	72 c8                	jb     801088c4 <deallocuvm.part.0+0x34>
801088fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801088ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108902:	89 c8                	mov    %ecx,%eax
80108904:	5b                   	pop    %ebx
80108905:	5e                   	pop    %esi
80108906:	5f                   	pop    %edi
80108907:	5d                   	pop    %ebp
80108908:	c3                   	ret
80108909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80108910:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108916:	74 26                	je     8010893e <deallocuvm.part.0+0xae>
      kfree(v);
80108918:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010891b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108921:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108924:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010892a:	52                   	push   %edx
8010892b:	e8 b0 ae ff ff       	call   801037e0 <kfree>
      *pte = 0;
80108930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80108933:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010893c:	eb 82                	jmp    801088c0 <deallocuvm.part.0+0x30>
        panic("kfree");
8010893e:	83 ec 0c             	sub    $0xc,%esp
80108941:	68 2c 94 10 80       	push   $0x8010942c
80108946:	e8 05 7b ff ff       	call   80100450 <panic>
8010894b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108950 <mappages>:
{
80108950:	55                   	push   %ebp
80108951:	89 e5                	mov    %esp,%ebp
80108953:	57                   	push   %edi
80108954:	56                   	push   %esi
80108955:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108956:	89 d3                	mov    %edx,%ebx
80108958:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010895e:	83 ec 1c             	sub    $0x1c,%esp
80108961:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108964:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108968:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010896d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108970:	8b 45 08             	mov    0x8(%ebp),%eax
80108973:	29 d8                	sub    %ebx,%eax
80108975:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108978:	eb 3f                	jmp    801089b9 <mappages+0x69>
8010897a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108980:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108982:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108987:	c1 ea 0a             	shr    $0xa,%edx
8010898a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108990:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108997:	85 c0                	test   %eax,%eax
80108999:	74 75                	je     80108a10 <mappages+0xc0>
    if(*pte & PTE_P)
8010899b:	f6 00 01             	testb  $0x1,(%eax)
8010899e:	0f 85 86 00 00 00    	jne    80108a2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801089a4:	0b 75 0c             	or     0xc(%ebp),%esi
801089a7:	83 ce 01             	or     $0x1,%esi
801089aa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801089ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089af:	39 c3                	cmp    %eax,%ebx
801089b1:	74 6d                	je     80108a20 <mappages+0xd0>
    a += PGSIZE;
801089b3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801089b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801089bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801089bf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801089c2:	89 d8                	mov    %ebx,%eax
801089c4:	c1 e8 16             	shr    $0x16,%eax
801089c7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801089ca:	8b 07                	mov    (%edi),%eax
801089cc:	a8 01                	test   $0x1,%al
801089ce:	75 b0                	jne    80108980 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801089d0:	e8 cb af ff ff       	call   801039a0 <kalloc>
801089d5:	85 c0                	test   %eax,%eax
801089d7:	74 37                	je     80108a10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801089d9:	83 ec 04             	sub    $0x4,%esp
801089dc:	68 00 10 00 00       	push   $0x1000
801089e1:	6a 00                	push   $0x0
801089e3:	50                   	push   %eax
801089e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801089e7:	e8 e4 d9 ff ff       	call   801063d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801089ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801089ef:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801089f2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801089f8:	83 c8 07             	or     $0x7,%eax
801089fb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801089fd:	89 d8                	mov    %ebx,%eax
801089ff:	c1 e8 0a             	shr    $0xa,%eax
80108a02:	25 fc 0f 00 00       	and    $0xffc,%eax
80108a07:	01 d0                	add    %edx,%eax
80108a09:	eb 90                	jmp    8010899b <mappages+0x4b>
80108a0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80108a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108a18:	5b                   	pop    %ebx
80108a19:	5e                   	pop    %esi
80108a1a:	5f                   	pop    %edi
80108a1b:	5d                   	pop    %ebp
80108a1c:	c3                   	ret
80108a1d:	8d 76 00             	lea    0x0(%esi),%esi
80108a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108a23:	31 c0                	xor    %eax,%eax
}
80108a25:	5b                   	pop    %ebx
80108a26:	5e                   	pop    %esi
80108a27:	5f                   	pop    %edi
80108a28:	5d                   	pop    %ebp
80108a29:	c3                   	ret
      panic("remap");
80108a2a:	83 ec 0c             	sub    $0xc,%esp
80108a2d:	68 3a 97 10 80       	push   $0x8010973a
80108a32:	e8 19 7a ff ff       	call   80100450 <panic>
80108a37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108a3e:	00 
80108a3f:	90                   	nop

80108a40 <seginit>:
{
80108a40:	55                   	push   %ebp
80108a41:	89 e5                	mov    %esp,%ebp
80108a43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108a46:	e8 85 c2 ff ff       	call   80104cd0 <cpuid>
  pd[0] = size-1;
80108a4b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108a50:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80108a56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80108a5a:	c7 80 b8 43 11 80 ff 	movl   $0xffff,-0x7feebc48(%eax)
80108a61:	ff 00 00 
80108a64:	c7 80 bc 43 11 80 00 	movl   $0xcf9a00,-0x7feebc44(%eax)
80108a6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108a6e:	c7 80 c0 43 11 80 ff 	movl   $0xffff,-0x7feebc40(%eax)
80108a75:	ff 00 00 
80108a78:	c7 80 c4 43 11 80 00 	movl   $0xcf9200,-0x7feebc3c(%eax)
80108a7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108a82:	c7 80 c8 43 11 80 ff 	movl   $0xffff,-0x7feebc38(%eax)
80108a89:	ff 00 00 
80108a8c:	c7 80 cc 43 11 80 00 	movl   $0xcffa00,-0x7feebc34(%eax)
80108a93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108a96:	c7 80 d0 43 11 80 ff 	movl   $0xffff,-0x7feebc30(%eax)
80108a9d:	ff 00 00 
80108aa0:	c7 80 d4 43 11 80 00 	movl   $0xcff200,-0x7feebc2c(%eax)
80108aa7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80108aaa:	05 b0 43 11 80       	add    $0x801143b0,%eax
  pd[1] = (uint)p;
80108aaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108ab3:	c1 e8 10             	shr    $0x10,%eax
80108ab6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80108aba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80108abd:	0f 01 10             	lgdtl  (%eax)
}
80108ac0:	c9                   	leave
80108ac1:	c3                   	ret
80108ac2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108ac9:	00 
80108aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108ad0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108ad0:	a1 64 de 11 80       	mov    0x8011de64,%eax
80108ad5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108ada:	0f 22 d8             	mov    %eax,%cr3
}
80108add:	c3                   	ret
80108ade:	66 90                	xchg   %ax,%ax

80108ae0 <switchuvm>:
{
80108ae0:	55                   	push   %ebp
80108ae1:	89 e5                	mov    %esp,%ebp
80108ae3:	57                   	push   %edi
80108ae4:	56                   	push   %esi
80108ae5:	53                   	push   %ebx
80108ae6:	83 ec 1c             	sub    $0x1c,%esp
80108ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80108aec:	85 f6                	test   %esi,%esi
80108aee:	0f 84 cb 00 00 00    	je     80108bbf <switchuvm+0xdf>
  if(p->kstack == 0)
80108af4:	8b 46 08             	mov    0x8(%esi),%eax
80108af7:	85 c0                	test   %eax,%eax
80108af9:	0f 84 da 00 00 00    	je     80108bd9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80108aff:	8b 46 04             	mov    0x4(%esi),%eax
80108b02:	85 c0                	test   %eax,%eax
80108b04:	0f 84 c2 00 00 00    	je     80108bcc <switchuvm+0xec>
  pushcli();
80108b0a:	e8 71 d6 ff ff       	call   80106180 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108b0f:	e8 5c c1 ff ff       	call   80104c70 <mycpu>
80108b14:	89 c3                	mov    %eax,%ebx
80108b16:	e8 55 c1 ff ff       	call   80104c70 <mycpu>
80108b1b:	89 c7                	mov    %eax,%edi
80108b1d:	e8 4e c1 ff ff       	call   80104c70 <mycpu>
80108b22:	83 c7 08             	add    $0x8,%edi
80108b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108b28:	e8 43 c1 ff ff       	call   80104c70 <mycpu>
80108b2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108b30:	ba 67 00 00 00       	mov    $0x67,%edx
80108b35:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108b3c:	83 c0 08             	add    $0x8,%eax
80108b3f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108b46:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108b4b:	83 c1 08             	add    $0x8,%ecx
80108b4e:	c1 e8 18             	shr    $0x18,%eax
80108b51:	c1 e9 10             	shr    $0x10,%ecx
80108b54:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80108b5a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108b60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108b65:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108b6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108b71:	e8 fa c0 ff ff       	call   80104c70 <mycpu>
80108b76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108b7d:	e8 ee c0 ff ff       	call   80104c70 <mycpu>
80108b82:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108b86:	8b 5e 08             	mov    0x8(%esi),%ebx
80108b89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108b8f:	e8 dc c0 ff ff       	call   80104c70 <mycpu>
80108b94:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108b97:	e8 d4 c0 ff ff       	call   80104c70 <mycpu>
80108b9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108ba0:	b8 28 00 00 00       	mov    $0x28,%eax
80108ba5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108ba8:	8b 46 04             	mov    0x4(%esi),%eax
80108bab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108bb0:	0f 22 d8             	mov    %eax,%cr3
}
80108bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108bb6:	5b                   	pop    %ebx
80108bb7:	5e                   	pop    %esi
80108bb8:	5f                   	pop    %edi
80108bb9:	5d                   	pop    %ebp
  popcli();
80108bba:	e9 11 d6 ff ff       	jmp    801061d0 <popcli>
    panic("switchuvm: no process");
80108bbf:	83 ec 0c             	sub    $0xc,%esp
80108bc2:	68 40 97 10 80       	push   $0x80109740
80108bc7:	e8 84 78 ff ff       	call   80100450 <panic>
    panic("switchuvm: no pgdir");
80108bcc:	83 ec 0c             	sub    $0xc,%esp
80108bcf:	68 6b 97 10 80       	push   $0x8010976b
80108bd4:	e8 77 78 ff ff       	call   80100450 <panic>
    panic("switchuvm: no kstack");
80108bd9:	83 ec 0c             	sub    $0xc,%esp
80108bdc:	68 56 97 10 80       	push   $0x80109756
80108be1:	e8 6a 78 ff ff       	call   80100450 <panic>
80108be6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108bed:	00 
80108bee:	66 90                	xchg   %ax,%ax

80108bf0 <inituvm>:
{
80108bf0:	55                   	push   %ebp
80108bf1:	89 e5                	mov    %esp,%ebp
80108bf3:	57                   	push   %edi
80108bf4:	56                   	push   %esi
80108bf5:	53                   	push   %ebx
80108bf6:	83 ec 1c             	sub    $0x1c,%esp
80108bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80108bfc:	8b 75 10             	mov    0x10(%ebp),%esi
80108bff:	8b 7d 0c             	mov    0xc(%ebp),%edi
80108c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108c05:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108c0b:	77 49                	ja     80108c56 <inituvm+0x66>
  mem = kalloc();
80108c0d:	e8 8e ad ff ff       	call   801039a0 <kalloc>
  memset(mem, 0, PGSIZE);
80108c12:	83 ec 04             	sub    $0x4,%esp
80108c15:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80108c1a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108c1c:	6a 00                	push   $0x0
80108c1e:	50                   	push   %eax
80108c1f:	e8 ac d7 ff ff       	call   801063d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108c24:	58                   	pop    %eax
80108c25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108c2b:	5a                   	pop    %edx
80108c2c:	6a 06                	push   $0x6
80108c2e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108c33:	31 d2                	xor    %edx,%edx
80108c35:	50                   	push   %eax
80108c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108c39:	e8 12 fd ff ff       	call   80108950 <mappages>
  memmove(mem, init, sz);
80108c3e:	89 75 10             	mov    %esi,0x10(%ebp)
80108c41:	83 c4 10             	add    $0x10,%esp
80108c44:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108c47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80108c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c4d:	5b                   	pop    %ebx
80108c4e:	5e                   	pop    %esi
80108c4f:	5f                   	pop    %edi
80108c50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108c51:	e9 0a d8 ff ff       	jmp    80106460 <memmove>
    panic("inituvm: more than a page");
80108c56:	83 ec 0c             	sub    $0xc,%esp
80108c59:	68 7f 97 10 80       	push   $0x8010977f
80108c5e:	e8 ed 77 ff ff       	call   80100450 <panic>
80108c63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108c6a:	00 
80108c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108c70 <loaduvm>:
{
80108c70:	55                   	push   %ebp
80108c71:	89 e5                	mov    %esp,%ebp
80108c73:	57                   	push   %edi
80108c74:	56                   	push   %esi
80108c75:	53                   	push   %ebx
80108c76:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108c79:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80108c7c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80108c7f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80108c85:	0f 85 a2 00 00 00    	jne    80108d2d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80108c8b:	85 ff                	test   %edi,%edi
80108c8d:	74 7d                	je     80108d0c <loaduvm+0x9c>
80108c8f:	90                   	nop
  pde = &pgdir[PDX(va)];
80108c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108c93:	8b 55 08             	mov    0x8(%ebp),%edx
80108c96:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80108c98:	89 c1                	mov    %eax,%ecx
80108c9a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108c9d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80108ca0:	f6 c1 01             	test   $0x1,%cl
80108ca3:	75 13                	jne    80108cb8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80108ca5:	83 ec 0c             	sub    $0xc,%esp
80108ca8:	68 99 97 10 80       	push   $0x80109799
80108cad:	e8 9e 77 ff ff       	call   80100450 <panic>
80108cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108cb8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108cbb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108cc1:	25 fc 0f 00 00       	and    $0xffc,%eax
80108cc6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108ccd:	85 c9                	test   %ecx,%ecx
80108ccf:	74 d4                	je     80108ca5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80108cd1:	89 fb                	mov    %edi,%ebx
80108cd3:	b8 00 10 00 00       	mov    $0x1000,%eax
80108cd8:	29 f3                	sub    %esi,%ebx
80108cda:	39 c3                	cmp    %eax,%ebx
80108cdc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108cdf:	53                   	push   %ebx
80108ce0:	8b 45 14             	mov    0x14(%ebp),%eax
80108ce3:	01 f0                	add    %esi,%eax
80108ce5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80108ce6:	8b 01                	mov    (%ecx),%eax
80108ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108ced:	05 00 00 00 80       	add    $0x80000000,%eax
80108cf2:	50                   	push   %eax
80108cf3:	ff 75 10             	push   0x10(%ebp)
80108cf6:	e8 f5 a0 ff ff       	call   80102df0 <readi>
80108cfb:	83 c4 10             	add    $0x10,%esp
80108cfe:	39 d8                	cmp    %ebx,%eax
80108d00:	75 1e                	jne    80108d20 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80108d02:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108d08:	39 fe                	cmp    %edi,%esi
80108d0a:	72 84                	jb     80108c90 <loaduvm+0x20>
}
80108d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108d0f:	31 c0                	xor    %eax,%eax
}
80108d11:	5b                   	pop    %ebx
80108d12:	5e                   	pop    %esi
80108d13:	5f                   	pop    %edi
80108d14:	5d                   	pop    %ebp
80108d15:	c3                   	ret
80108d16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108d1d:	00 
80108d1e:	66 90                	xchg   %ax,%ax
80108d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108d28:	5b                   	pop    %ebx
80108d29:	5e                   	pop    %esi
80108d2a:	5f                   	pop    %edi
80108d2b:	5d                   	pop    %ebp
80108d2c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80108d2d:	83 ec 0c             	sub    $0xc,%esp
80108d30:	68 c8 9b 10 80       	push   $0x80109bc8
80108d35:	e8 16 77 ff ff       	call   80100450 <panic>
80108d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108d40 <allocuvm>:
{
80108d40:	55                   	push   %ebp
80108d41:	89 e5                	mov    %esp,%ebp
80108d43:	57                   	push   %edi
80108d44:	56                   	push   %esi
80108d45:	53                   	push   %ebx
80108d46:	83 ec 1c             	sub    $0x1c,%esp
80108d49:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80108d4c:	85 f6                	test   %esi,%esi
80108d4e:	0f 88 98 00 00 00    	js     80108dec <allocuvm+0xac>
80108d54:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80108d56:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108d59:	0f 82 a1 00 00 00    	jb     80108e00 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d62:	05 ff 0f 00 00       	add    $0xfff,%eax
80108d67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d6c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80108d6e:	39 f0                	cmp    %esi,%eax
80108d70:	0f 83 8d 00 00 00    	jae    80108e03 <allocuvm+0xc3>
80108d76:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80108d79:	eb 44                	jmp    80108dbf <allocuvm+0x7f>
80108d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108d80:	83 ec 04             	sub    $0x4,%esp
80108d83:	68 00 10 00 00       	push   $0x1000
80108d88:	6a 00                	push   $0x0
80108d8a:	50                   	push   %eax
80108d8b:	e8 40 d6 ff ff       	call   801063d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108d90:	58                   	pop    %eax
80108d91:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108d97:	5a                   	pop    %edx
80108d98:	6a 06                	push   $0x6
80108d9a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108d9f:	89 fa                	mov    %edi,%edx
80108da1:	50                   	push   %eax
80108da2:	8b 45 08             	mov    0x8(%ebp),%eax
80108da5:	e8 a6 fb ff ff       	call   80108950 <mappages>
80108daa:	83 c4 10             	add    $0x10,%esp
80108dad:	85 c0                	test   %eax,%eax
80108daf:	78 5f                	js     80108e10 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80108db1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108db7:	39 f7                	cmp    %esi,%edi
80108db9:	0f 83 89 00 00 00    	jae    80108e48 <allocuvm+0x108>
    mem = kalloc();
80108dbf:	e8 dc ab ff ff       	call   801039a0 <kalloc>
80108dc4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108dc6:	85 c0                	test   %eax,%eax
80108dc8:	75 b6                	jne    80108d80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108dca:	83 ec 0c             	sub    $0xc,%esp
80108dcd:	68 b7 97 10 80       	push   $0x801097b7
80108dd2:	e8 09 7a ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80108dd7:	83 c4 10             	add    $0x10,%esp
80108dda:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108ddd:	74 0d                	je     80108dec <allocuvm+0xac>
80108ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108de2:	8b 45 08             	mov    0x8(%ebp),%eax
80108de5:	89 f2                	mov    %esi,%edx
80108de7:	e8 a4 fa ff ff       	call   80108890 <deallocuvm.part.0>
    return 0;
80108dec:	31 d2                	xor    %edx,%edx
}
80108dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108df1:	89 d0                	mov    %edx,%eax
80108df3:	5b                   	pop    %ebx
80108df4:	5e                   	pop    %esi
80108df5:	5f                   	pop    %edi
80108df6:	5d                   	pop    %ebp
80108df7:	c3                   	ret
80108df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108dff:	00 
    return oldsz;
80108e00:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80108e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e06:	89 d0                	mov    %edx,%eax
80108e08:	5b                   	pop    %ebx
80108e09:	5e                   	pop    %esi
80108e0a:	5f                   	pop    %edi
80108e0b:	5d                   	pop    %ebp
80108e0c:	c3                   	ret
80108e0d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108e10:	83 ec 0c             	sub    $0xc,%esp
80108e13:	68 cf 97 10 80       	push   $0x801097cf
80108e18:	e8 c3 79 ff ff       	call   801007e0 <cprintf>
  if(newsz >= oldsz)
80108e1d:	83 c4 10             	add    $0x10,%esp
80108e20:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108e23:	74 0d                	je     80108e32 <allocuvm+0xf2>
80108e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108e28:	8b 45 08             	mov    0x8(%ebp),%eax
80108e2b:	89 f2                	mov    %esi,%edx
80108e2d:	e8 5e fa ff ff       	call   80108890 <deallocuvm.part.0>
      kfree(mem);
80108e32:	83 ec 0c             	sub    $0xc,%esp
80108e35:	53                   	push   %ebx
80108e36:	e8 a5 a9 ff ff       	call   801037e0 <kfree>
      return 0;
80108e3b:	83 c4 10             	add    $0x10,%esp
    return 0;
80108e3e:	31 d2                	xor    %edx,%edx
80108e40:	eb ac                	jmp    80108dee <allocuvm+0xae>
80108e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108e48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80108e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e4e:	5b                   	pop    %ebx
80108e4f:	5e                   	pop    %esi
80108e50:	89 d0                	mov    %edx,%eax
80108e52:	5f                   	pop    %edi
80108e53:	5d                   	pop    %ebp
80108e54:	c3                   	ret
80108e55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108e5c:	00 
80108e5d:	8d 76 00             	lea    0x0(%esi),%esi

80108e60 <deallocuvm>:
{
80108e60:	55                   	push   %ebp
80108e61:	89 e5                	mov    %esp,%ebp
80108e63:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108e69:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108e6c:	39 d1                	cmp    %edx,%ecx
80108e6e:	73 10                	jae    80108e80 <deallocuvm+0x20>
}
80108e70:	5d                   	pop    %ebp
80108e71:	e9 1a fa ff ff       	jmp    80108890 <deallocuvm.part.0>
80108e76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108e7d:	00 
80108e7e:	66 90                	xchg   %ax,%ax
80108e80:	89 d0                	mov    %edx,%eax
80108e82:	5d                   	pop    %ebp
80108e83:	c3                   	ret
80108e84:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108e8b:	00 
80108e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108e90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108e90:	55                   	push   %ebp
80108e91:	89 e5                	mov    %esp,%ebp
80108e93:	57                   	push   %edi
80108e94:	56                   	push   %esi
80108e95:	53                   	push   %ebx
80108e96:	83 ec 0c             	sub    $0xc,%esp
80108e99:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108e9c:	85 f6                	test   %esi,%esi
80108e9e:	74 59                	je     80108ef9 <freevm+0x69>
  if(newsz >= oldsz)
80108ea0:	31 c9                	xor    %ecx,%ecx
80108ea2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108ea7:	89 f0                	mov    %esi,%eax
80108ea9:	89 f3                	mov    %esi,%ebx
80108eab:	e8 e0 f9 ff ff       	call   80108890 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108eb0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108eb6:	eb 0f                	jmp    80108ec7 <freevm+0x37>
80108eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108ebf:	00 
80108ec0:	83 c3 04             	add    $0x4,%ebx
80108ec3:	39 fb                	cmp    %edi,%ebx
80108ec5:	74 23                	je     80108eea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108ec7:	8b 03                	mov    (%ebx),%eax
80108ec9:	a8 01                	test   $0x1,%al
80108ecb:	74 f3                	je     80108ec0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108ecd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108ed2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108ed5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108ed8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80108edd:	50                   	push   %eax
80108ede:	e8 fd a8 ff ff       	call   801037e0 <kfree>
80108ee3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108ee6:	39 fb                	cmp    %edi,%ebx
80108ee8:	75 dd                	jne    80108ec7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108eea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80108eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ef0:	5b                   	pop    %ebx
80108ef1:	5e                   	pop    %esi
80108ef2:	5f                   	pop    %edi
80108ef3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108ef4:	e9 e7 a8 ff ff       	jmp    801037e0 <kfree>
    panic("freevm: no pgdir");
80108ef9:	83 ec 0c             	sub    $0xc,%esp
80108efc:	68 eb 97 10 80       	push   $0x801097eb
80108f01:	e8 4a 75 ff ff       	call   80100450 <panic>
80108f06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108f0d:	00 
80108f0e:	66 90                	xchg   %ax,%ax

80108f10 <setupkvm>:
{
80108f10:	55                   	push   %ebp
80108f11:	89 e5                	mov    %esp,%ebp
80108f13:	56                   	push   %esi
80108f14:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108f15:	e8 86 aa ff ff       	call   801039a0 <kalloc>
80108f1a:	85 c0                	test   %eax,%eax
80108f1c:	74 5e                	je     80108f7c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80108f1e:	83 ec 04             	sub    $0x4,%esp
80108f21:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108f23:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108f28:	68 00 10 00 00       	push   $0x1000
80108f2d:	6a 00                	push   $0x0
80108f2f:	50                   	push   %eax
80108f30:	e8 9b d4 ff ff       	call   801063d0 <memset>
80108f35:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108f38:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108f3b:	83 ec 08             	sub    $0x8,%esp
80108f3e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108f41:	8b 13                	mov    (%ebx),%edx
80108f43:	ff 73 0c             	push   0xc(%ebx)
80108f46:	50                   	push   %eax
80108f47:	29 c1                	sub    %eax,%ecx
80108f49:	89 f0                	mov    %esi,%eax
80108f4b:	e8 00 fa ff ff       	call   80108950 <mappages>
80108f50:	83 c4 10             	add    $0x10,%esp
80108f53:	85 c0                	test   %eax,%eax
80108f55:	78 19                	js     80108f70 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108f57:	83 c3 10             	add    $0x10,%ebx
80108f5a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108f60:	75 d6                	jne    80108f38 <setupkvm+0x28>
}
80108f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108f65:	89 f0                	mov    %esi,%eax
80108f67:	5b                   	pop    %ebx
80108f68:	5e                   	pop    %esi
80108f69:	5d                   	pop    %ebp
80108f6a:	c3                   	ret
80108f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108f70:	83 ec 0c             	sub    $0xc,%esp
80108f73:	56                   	push   %esi
80108f74:	e8 17 ff ff ff       	call   80108e90 <freevm>
      return 0;
80108f79:	83 c4 10             	add    $0x10,%esp
}
80108f7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80108f7f:	31 f6                	xor    %esi,%esi
}
80108f81:	89 f0                	mov    %esi,%eax
80108f83:	5b                   	pop    %ebx
80108f84:	5e                   	pop    %esi
80108f85:	5d                   	pop    %ebp
80108f86:	c3                   	ret
80108f87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108f8e:	00 
80108f8f:	90                   	nop

80108f90 <kvmalloc>:
{
80108f90:	55                   	push   %ebp
80108f91:	89 e5                	mov    %esp,%ebp
80108f93:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108f96:	e8 75 ff ff ff       	call   80108f10 <setupkvm>
80108f9b:	a3 64 de 11 80       	mov    %eax,0x8011de64
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108fa0:	05 00 00 00 80       	add    $0x80000000,%eax
80108fa5:	0f 22 d8             	mov    %eax,%cr3
}
80108fa8:	c9                   	leave
80108fa9:	c3                   	ret
80108faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108fb0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108fb0:	55                   	push   %ebp
80108fb1:	89 e5                	mov    %esp,%ebp
80108fb3:	83 ec 08             	sub    $0x8,%esp
80108fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108fbc:	89 c1                	mov    %eax,%ecx
80108fbe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108fc1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108fc4:	f6 c2 01             	test   $0x1,%dl
80108fc7:	75 17                	jne    80108fe0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108fc9:	83 ec 0c             	sub    $0xc,%esp
80108fcc:	68 fc 97 10 80       	push   $0x801097fc
80108fd1:	e8 7a 74 ff ff       	call   80100450 <panic>
80108fd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108fdd:	00 
80108fde:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80108fe0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108fe3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108fe9:	25 fc 0f 00 00       	and    $0xffc,%eax
80108fee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108ff5:	85 c0                	test   %eax,%eax
80108ff7:	74 d0                	je     80108fc9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108ff9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80108ffc:	c9                   	leave
80108ffd:	c3                   	ret
80108ffe:	66 90                	xchg   %ax,%ax

80109000 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109000:	55                   	push   %ebp
80109001:	89 e5                	mov    %esp,%ebp
80109003:	57                   	push   %edi
80109004:	56                   	push   %esi
80109005:	53                   	push   %ebx
80109006:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109009:	e8 02 ff ff ff       	call   80108f10 <setupkvm>
8010900e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109011:	85 c0                	test   %eax,%eax
80109013:	0f 84 e9 00 00 00    	je     80109102 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010901c:	85 c9                	test   %ecx,%ecx
8010901e:	0f 84 b2 00 00 00    	je     801090d6 <copyuvm+0xd6>
80109024:	31 f6                	xor    %esi,%esi
80109026:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010902d:	00 
8010902e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80109030:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80109033:	89 f0                	mov    %esi,%eax
80109035:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80109038:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010903b:	a8 01                	test   $0x1,%al
8010903d:	75 11                	jne    80109050 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010903f:	83 ec 0c             	sub    $0xc,%esp
80109042:	68 06 98 10 80       	push   $0x80109806
80109047:	e8 04 74 ff ff       	call   80100450 <panic>
8010904c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80109050:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109052:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80109057:	c1 ea 0a             	shr    $0xa,%edx
8010905a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80109060:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109067:	85 c0                	test   %eax,%eax
80109069:	74 d4                	je     8010903f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010906b:	8b 00                	mov    (%eax),%eax
8010906d:	a8 01                	test   $0x1,%al
8010906f:	0f 84 9f 00 00 00    	je     80109114 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80109075:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80109077:	25 ff 0f 00 00       	and    $0xfff,%eax
8010907c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010907f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80109085:	e8 16 a9 ff ff       	call   801039a0 <kalloc>
8010908a:	89 c3                	mov    %eax,%ebx
8010908c:	85 c0                	test   %eax,%eax
8010908e:	74 64                	je     801090f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80109090:	83 ec 04             	sub    $0x4,%esp
80109093:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80109099:	68 00 10 00 00       	push   $0x1000
8010909e:	57                   	push   %edi
8010909f:	50                   	push   %eax
801090a0:	e8 bb d3 ff ff       	call   80106460 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801090a5:	58                   	pop    %eax
801090a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801090ac:	5a                   	pop    %edx
801090ad:	ff 75 e4             	push   -0x1c(%ebp)
801090b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801090b5:	89 f2                	mov    %esi,%edx
801090b7:	50                   	push   %eax
801090b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090bb:	e8 90 f8 ff ff       	call   80108950 <mappages>
801090c0:	83 c4 10             	add    $0x10,%esp
801090c3:	85 c0                	test   %eax,%eax
801090c5:	78 21                	js     801090e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801090c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801090cd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801090d0:	0f 82 5a ff ff ff    	jb     80109030 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801090d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801090dc:	5b                   	pop    %ebx
801090dd:	5e                   	pop    %esi
801090de:	5f                   	pop    %edi
801090df:	5d                   	pop    %ebp
801090e0:	c3                   	ret
801090e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801090e8:	83 ec 0c             	sub    $0xc,%esp
801090eb:	53                   	push   %ebx
801090ec:	e8 ef a6 ff ff       	call   801037e0 <kfree>
      goto bad;
801090f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801090f4:	83 ec 0c             	sub    $0xc,%esp
801090f7:	ff 75 e0             	push   -0x20(%ebp)
801090fa:	e8 91 fd ff ff       	call   80108e90 <freevm>
  return 0;
801090ff:	83 c4 10             	add    $0x10,%esp
    return 0;
80109102:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80109109:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010910c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010910f:	5b                   	pop    %ebx
80109110:	5e                   	pop    %esi
80109111:	5f                   	pop    %edi
80109112:	5d                   	pop    %ebp
80109113:	c3                   	ret
      panic("copyuvm: page not present");
80109114:	83 ec 0c             	sub    $0xc,%esp
80109117:	68 20 98 10 80       	push   $0x80109820
8010911c:	e8 2f 73 ff ff       	call   80100450 <panic>
80109121:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109128:	00 
80109129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80109130 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109130:	55                   	push   %ebp
80109131:	89 e5                	mov    %esp,%ebp
80109133:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109136:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80109139:	89 c1                	mov    %eax,%ecx
8010913b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010913e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80109141:	f6 c2 01             	test   $0x1,%dl
80109144:	0f 84 f8 00 00 00    	je     80109242 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010914a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010914d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80109153:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80109154:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80109159:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80109160:	89 d0                	mov    %edx,%eax
80109162:	f7 d2                	not    %edx
80109164:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109169:	05 00 00 00 80       	add    $0x80000000,%eax
8010916e:	83 e2 05             	and    $0x5,%edx
80109171:	ba 00 00 00 00       	mov    $0x0,%edx
80109176:	0f 45 c2             	cmovne %edx,%eax
}
80109179:	c3                   	ret
8010917a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109180 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109180:	55                   	push   %ebp
80109181:	89 e5                	mov    %esp,%ebp
80109183:	57                   	push   %edi
80109184:	56                   	push   %esi
80109185:	53                   	push   %ebx
80109186:	83 ec 0c             	sub    $0xc,%esp
80109189:	8b 75 14             	mov    0x14(%ebp),%esi
8010918c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010918f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109192:	85 f6                	test   %esi,%esi
80109194:	75 51                	jne    801091e7 <copyout+0x67>
80109196:	e9 9d 00 00 00       	jmp    80109238 <copyout+0xb8>
8010919b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801091a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801091a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801091ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801091b2:	74 74                	je     80109228 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801091b4:	89 fb                	mov    %edi,%ebx
801091b6:	29 c3                	sub    %eax,%ebx
801091b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801091be:	39 f3                	cmp    %esi,%ebx
801091c0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801091c3:	29 f8                	sub    %edi,%eax
801091c5:	83 ec 04             	sub    $0x4,%esp
801091c8:	01 c1                	add    %eax,%ecx
801091ca:	53                   	push   %ebx
801091cb:	52                   	push   %edx
801091cc:	89 55 10             	mov    %edx,0x10(%ebp)
801091cf:	51                   	push   %ecx
801091d0:	e8 8b d2 ff ff       	call   80106460 <memmove>
    len -= n;
    buf += n;
801091d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801091d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801091de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801091e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801091e3:	29 de                	sub    %ebx,%esi
801091e5:	74 51                	je     80109238 <copyout+0xb8>
  if(*pde & PTE_P){
801091e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801091ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801091ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801091ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801091f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801091f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801091fa:	f6 c1 01             	test   $0x1,%cl
801091fd:	0f 84 46 00 00 00    	je     80109249 <copyout.cold>
  return &pgtab[PTX(va)];
80109203:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109205:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010920b:	c1 eb 0c             	shr    $0xc,%ebx
8010920e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80109214:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010921b:	89 d9                	mov    %ebx,%ecx
8010921d:	f7 d1                	not    %ecx
8010921f:	83 e1 05             	and    $0x5,%ecx
80109222:	0f 84 78 ff ff ff    	je     801091a0 <copyout+0x20>
  }
  return 0;
}
80109228:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010922b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109230:	5b                   	pop    %ebx
80109231:	5e                   	pop    %esi
80109232:	5f                   	pop    %edi
80109233:	5d                   	pop    %ebp
80109234:	c3                   	ret
80109235:	8d 76 00             	lea    0x0(%esi),%esi
80109238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010923b:	31 c0                	xor    %eax,%eax
}
8010923d:	5b                   	pop    %ebx
8010923e:	5e                   	pop    %esi
8010923f:	5f                   	pop    %edi
80109240:	5d                   	pop    %ebp
80109241:	c3                   	ret

80109242 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80109242:	a1 00 00 00 00       	mov    0x0,%eax
80109247:	0f 0b                	ud2

80109249 <copyout.cold>:
80109249:	a1 00 00 00 00       	mov    0x0,%eax
8010924e:	0f 0b                	ud2
