
_encode:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    

        
    }
}
int main(int argc,char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 11                	mov    (%ecx),%edx
  16:	8b 49 04             	mov    0x4(%ecx),%ecx
    char* text_to_encode[argc-1];
  19:	8d 42 ff             	lea    -0x1(%edx),%eax
  1c:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  23:	89 45 d8             	mov    %eax,-0x28(%ebp)
  26:	8d 47 0f             	lea    0xf(%edi),%eax
  29:	89 c6                	mov    %eax,%esi
  2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  30:	83 e6 f0             	and    $0xfffffff0,%esi
  33:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  36:	89 e6                	mov    %esp,%esi
  38:	29 c6                	sub    %eax,%esi
  3a:	39 f4                	cmp    %esi,%esp
  3c:	74 12                	je     50 <main+0x50>
  3e:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  44:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  4b:	00 
  4c:	39 f4                	cmp    %esi,%esp
  4e:	75 ee                	jne    3e <main+0x3e>
  50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  53:	25 ff 0f 00 00       	and    $0xfff,%eax
  58:	29 c4                	sub    %eax,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	0f 85 6b 01 00 00    	jne    1cd <main+0x1cd>
    int flag=0;
    if(argc <2){
  62:	83 ea 01             	sub    $0x1,%edx
    char* text_to_encode[argc-1];
  65:	89 65 e0             	mov    %esp,-0x20(%ebp)
    if(argc <2){
  68:	0f 8e 4c 01 00 00    	jle    1ba <main+0x1ba>
  6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  71:	8d 51 04             	lea    0x4(%ecx),%edx
  74:	8d 74 39 04          	lea    0x4(%ecx,%edi,1),%esi
  78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  7b:	89 c1                	mov    %eax,%ecx
  7d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    else{
        flag=1;
        for (int i=1;i<argc;i++){

            text_to_encode[i-1]=argv[i];
  80:	8b 02                	mov    (%edx),%eax
        for (int i=1;i<argc;i++){
  82:	83 c2 04             	add    $0x4,%edx
  85:	83 c1 04             	add    $0x4,%ecx
            text_to_encode[i-1]=argv[i];
  88:	89 41 fc             	mov    %eax,-0x4(%ecx)
        for (int i=1;i<argc;i++){
  8b:	39 d6                	cmp    %edx,%esi
  8d:	75 f1                	jne    80 <main+0x80>
  8f:	8b 75 e0             	mov    -0x20(%ebp),%esi
  92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  95:	01 fe                	add    %edi,%esi
  97:	89 75 dc             	mov    %esi,-0x24(%ebp)
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
    if(flag){
        for (int i=0;i<argc-1;i++){


        cesar_encode(text_to_encode[i],15);
  a0:	8b 38                	mov    (%eax),%edi
    for (int i=0;text[i]!='\0';i++)
  a2:	0f be 0f             	movsbl (%edi),%ecx
  a5:	84 c9                	test   %cl,%cl
  a7:	74 6a                	je     113 <main+0x113>
  a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ac:	eb 46                	jmp    f4 <main+0xf4>
  ae:	66 90                	xchg   %ax,%ax
        if(c>='A' && c<='Z'){
  b0:	8d 41 bf             	lea    -0x41(%ecx),%eax
  b3:	3c 19                	cmp    $0x19,%al
  b5:	0f 87 f5 00 00 00    	ja     1b0 <main+0x1b0>
  bb:	be 41 00 00 00       	mov    $0x41,%esi
  c0:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
  c5:	bb 41 00 00 00       	mov    $0x41,%ebx
        text[i]=(c-base+shift)%26+base;
  ca:	29 c1                	sub    %eax,%ecx
  cc:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
    for (int i=0;text[i]!='\0';i++)
  d1:	83 c7 01             	add    $0x1,%edi
        text[i]=(c-base+shift)%26+base;
  d4:	83 c1 0f             	add    $0xf,%ecx
  d7:	f7 e9                	imul   %ecx
  d9:	89 c8                	mov    %ecx,%eax
  db:	c1 f8 1f             	sar    $0x1f,%eax
  de:	c1 fa 03             	sar    $0x3,%edx
  e1:	29 c2                	sub    %eax,%edx
  e3:	6b d2 1a             	imul   $0x1a,%edx,%edx
  e6:	29 d1                	sub    %edx,%ecx
  e8:	01 f1                	add    %esi,%ecx
  ea:	88 4f ff             	mov    %cl,-0x1(%edi)
    for (int i=0;text[i]!='\0';i++)
  ed:	0f be 0f             	movsbl (%edi),%ecx
  f0:	84 c9                	test   %cl,%cl
  f2:	74 1c                	je     110 <main+0x110>
        if (c>='a' && c<='z'){
  f4:	8d 41 9f             	lea    -0x61(%ecx),%eax
  f7:	3c 19                	cmp    $0x19,%al
  f9:	77 b5                	ja     b0 <main+0xb0>
  fb:	be 61 00 00 00       	mov    $0x61,%esi
 100:	b8 61 00 00 00       	mov    $0x61,%eax
        base='a';}
 105:	bb 61 00 00 00       	mov    $0x61,%ebx
 10a:	eb be                	jmp    ca <main+0xca>
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        for (int i=0;i<argc-1;i++){
 113:	8b 75 dc             	mov    -0x24(%ebp),%esi
 116:	83 c0 04             	add    $0x4,%eax
 119:	39 f0                	cmp    %esi,%eax
 11b:	75 83                	jne    a0 <main+0xa0>
  
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
 11d:	52                   	push   %edx
            printf(1,"Unable to open or create file \n");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
 11e:	31 f6                	xor    %esi,%esi
        int fd=open("result.txt",O_CREATE|O_RDWR);
 120:	52                   	push   %edx
 121:	89 f7                	mov    %esi,%edi
 123:	68 02 02 00 00       	push   $0x202
 128:	68 72 09 00 00       	push   $0x972
 12d:	e8 d1 03 00 00       	call   503 <open>
        if (fd <0){
 132:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 135:	89 c3                	mov    %eax,%ebx
        if (fd <0){
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 98 00 00 00    	js     1d7 <main+0x1d7>
 13f:	90                   	nop
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 140:	8b 45 e0             	mov    -0x20(%ebp),%eax
 143:	83 ec 0c             	sub    $0xc,%esp
 146:	8b 34 b8             	mov    (%eax,%edi,4),%esi
            for (int i=0;i<argc-1;i++){
 149:	83 c7 01             	add    $0x1,%edi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 14c:	56                   	push   %esi
 14d:	e8 be 01 00 00       	call   310 <strlen>
 152:	83 c4 0c             	add    $0xc,%esp
 155:	50                   	push   %eax
 156:	56                   	push   %esi
 157:	53                   	push   %ebx
 158:	e8 86 03 00 00       	call   4e3 <write>
                write(fd,space,strlen(space));
 15d:	c7 04 24 7d 09 00 00 	movl   $0x97d,(%esp)
 164:	e8 a7 01 00 00       	call   310 <strlen>
 169:	83 c4 0c             	add    $0xc,%esp
 16c:	50                   	push   %eax
 16d:	68 7d 09 00 00       	push   $0x97d
 172:	53                   	push   %ebx
 173:	e8 6b 03 00 00       	call   4e3 <write>
            for (int i=0;i<argc-1;i++){
 178:	83 c4 10             	add    $0x10,%esp
 17b:	39 7d d8             	cmp    %edi,-0x28(%ebp)
 17e:	75 c0                	jne    140 <main+0x140>
            }



            write(fd,next_line,strlen(next_line));
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	68 70 09 00 00       	push   $0x970
 188:	e8 83 01 00 00       	call   310 <strlen>
 18d:	83 c4 0c             	add    $0xc,%esp
 190:	50                   	push   %eax
 191:	68 70 09 00 00       	push   $0x970
 196:	53                   	push   %ebx
 197:	e8 47 03 00 00       	call   4e3 <write>
        }
        close(fd);
 19c:	89 1c 24             	mov    %ebx,(%esp)
 19f:	e8 47 03 00 00       	call   4eb <close>
 1a4:	83 c4 10             	add    $0x10,%esp

    }
    
    exit();
 1a7:	e8 17 03 00 00       	call   4c3 <exit>
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        text[i]=(c-base+shift)%26+base;
 1b0:	0f be c3             	movsbl %bl,%eax
 1b3:	89 de                	mov    %ebx,%esi
 1b5:	e9 10 ff ff ff       	jmp    ca <main+0xca>
        printf(1,"no text to encode passed\n");
 1ba:	51                   	push   %ecx
 1bb:	51                   	push   %ecx
 1bc:	68 58 09 00 00       	push   $0x958
 1c1:	6a 01                	push   $0x1
 1c3:	e8 88 04 00 00       	call   650 <printf>
 1c8:	83 c4 10             	add    $0x10,%esp
 1cb:	eb da                	jmp    1a7 <main+0x1a7>
    char* text_to_encode[argc-1];
 1cd:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
 1d2:	e9 8b fe ff ff       	jmp    62 <main+0x62>
            printf(1,"Unable to open or create file \n");
 1d7:	50                   	push   %eax
 1d8:	50                   	push   %eax
 1d9:	68 88 09 00 00       	push   $0x988
 1de:	6a 01                	push   $0x1
 1e0:	e8 6b 04 00 00       	call   650 <printf>
            exit();
 1e5:	e8 d9 02 00 00       	call   4c3 <exit>
 1ea:	66 90                	xchg   %ax,%ax
 1ec:	66 90                	xchg   %ax,%ax
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <cesar_encode>:
void cesar_encode(char* text,int shift){
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
 1f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (int i=0;text[i]!='\0';i++)
 1f9:	0f be 0b             	movsbl (%ebx),%ecx
 1fc:	84 c9                	test   %cl,%cl
 1fe:	75 48                	jne    248 <cesar_encode+0x58>
 200:	eb 5e                	jmp    260 <cesar_encode+0x70>
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(c>='A' && c<='Z'){
 208:	8d 41 bf             	lea    -0x41(%ecx),%eax
 20b:	3c 19                	cmp    $0x19,%al
 20d:	77 59                	ja     268 <cesar_encode+0x78>
 20f:	be 41 00 00 00       	mov    $0x41,%esi
 214:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
 219:	bf 41 00 00 00       	mov    $0x41,%edi
        text[i]=(c-base+shift)%26+base;
 21e:	29 c1                	sub    %eax,%ecx
 220:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 225:	03 4d 0c             	add    0xc(%ebp),%ecx
    for (int i=0;text[i]!='\0';i++)
 228:	83 c3 01             	add    $0x1,%ebx
        text[i]=(c-base+shift)%26+base;
 22b:	f7 e9                	imul   %ecx
 22d:	89 c8                	mov    %ecx,%eax
 22f:	c1 f8 1f             	sar    $0x1f,%eax
 232:	c1 fa 03             	sar    $0x3,%edx
 235:	29 c2                	sub    %eax,%edx
 237:	6b d2 1a             	imul   $0x1a,%edx,%edx
 23a:	29 d1                	sub    %edx,%ecx
 23c:	01 f1                	add    %esi,%ecx
 23e:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
 241:	0f be 0b             	movsbl (%ebx),%ecx
 244:	84 c9                	test   %cl,%cl
 246:	74 18                	je     260 <cesar_encode+0x70>
        if (c>='a' && c<='z'){
 248:	8d 41 9f             	lea    -0x61(%ecx),%eax
 24b:	3c 19                	cmp    $0x19,%al
 24d:	77 b9                	ja     208 <cesar_encode+0x18>
 24f:	be 61 00 00 00       	mov    $0x61,%esi
 254:	b8 61 00 00 00       	mov    $0x61,%eax
        base='a';}
 259:	bf 61 00 00 00       	mov    $0x61,%edi
 25e:	eb be                	jmp    21e <cesar_encode+0x2e>
}
 260:	5b                   	pop    %ebx
 261:	5e                   	pop    %esi
 262:	5f                   	pop    %edi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret
 265:	8d 76 00             	lea    0x0(%esi),%esi
        text[i]=(c-base+shift)%26+base;
 268:	89 f8                	mov    %edi,%eax
 26a:	89 fe                	mov    %edi,%esi
 26c:	0f be c0             	movsbl %al,%eax
 26f:	eb ad                	jmp    21e <cesar_encode+0x2e>
 271:	66 90                	xchg   %ax,%ax
 273:	66 90                	xchg   %ax,%ax
 275:	66 90                	xchg   %ax,%ax
 277:	66 90                	xchg   %ax,%ax
 279:	66 90                	xchg   %ax,%ax
 27b:	66 90                	xchg   %ax,%ax
 27d:	66 90                	xchg   %ax,%ax
 27f:	90                   	nop

00000280 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 280:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 281:	31 c0                	xor    %eax,%eax
{
 283:	89 e5                	mov    %esp,%ebp
 285:	53                   	push   %ebx
 286:	8b 4d 08             	mov    0x8(%ebp),%ecx
 289:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 290:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 294:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 297:	83 c0 01             	add    $0x1,%eax
 29a:	84 d2                	test   %dl,%dl
 29c:	75 f2                	jne    290 <strcpy+0x10>
    ;
  return os;
}
 29e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a1:	89 c8                	mov    %ecx,%eax
 2a3:	c9                   	leave
 2a4:	c3                   	ret
 2a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ac:	00 
 2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
 2b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2ba:	0f b6 02             	movzbl (%edx),%eax
 2bd:	84 c0                	test   %al,%al
 2bf:	75 17                	jne    2d8 <strcmp+0x28>
 2c1:	eb 3a                	jmp    2fd <strcmp+0x4d>
 2c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2cc:	83 c2 01             	add    $0x1,%edx
 2cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2d2:	84 c0                	test   %al,%al
 2d4:	74 1a                	je     2f0 <strcmp+0x40>
 2d6:	89 d9                	mov    %ebx,%ecx
 2d8:	0f b6 19             	movzbl (%ecx),%ebx
 2db:	38 c3                	cmp    %al,%bl
 2dd:	74 e9                	je     2c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2df:	29 d8                	sub    %ebx,%eax
}
 2e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e4:	c9                   	leave
 2e5:	c3                   	ret
 2e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ed:	00 
 2ee:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 2f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2f4:	31 c0                	xor    %eax,%eax
 2f6:	29 d8                	sub    %ebx,%eax
}
 2f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2fb:	c9                   	leave
 2fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 2fd:	0f b6 19             	movzbl (%ecx),%ebx
 300:	31 c0                	xor    %eax,%eax
 302:	eb db                	jmp    2df <strcmp+0x2f>
 304:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 30b:	00 
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <strlen>:

uint
strlen(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 316:	80 3a 00             	cmpb   $0x0,(%edx)
 319:	74 15                	je     330 <strlen+0x20>
 31b:	31 c0                	xor    %eax,%eax
 31d:	8d 76 00             	lea    0x0(%esi),%esi
 320:	83 c0 01             	add    $0x1,%eax
 323:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 327:	89 c1                	mov    %eax,%ecx
 329:	75 f5                	jne    320 <strlen+0x10>
    ;
  return n;
}
 32b:	89 c8                	mov    %ecx,%eax
 32d:	5d                   	pop    %ebp
 32e:	c3                   	ret
 32f:	90                   	nop
  for(n = 0; s[n]; n++)
 330:	31 c9                	xor    %ecx,%ecx
}
 332:	5d                   	pop    %ebp
 333:	89 c8                	mov    %ecx,%eax
 335:	c3                   	ret
 336:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 33d:	00 
 33e:	66 90                	xchg   %ax,%ax

00000340 <memset>:

void*
memset(void *dst, int c, uint n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 347:	8b 4d 10             	mov    0x10(%ebp),%ecx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 d7                	mov    %edx,%edi
 34f:	fc                   	cld
 350:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 352:	8b 7d fc             	mov    -0x4(%ebp),%edi
 355:	89 d0                	mov    %edx,%eax
 357:	c9                   	leave
 358:	c3                   	ret
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 36a:	0f b6 10             	movzbl (%eax),%edx
 36d:	84 d2                	test   %dl,%dl
 36f:	75 12                	jne    383 <strchr+0x23>
 371:	eb 1d                	jmp    390 <strchr+0x30>
 373:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 378:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 37c:	83 c0 01             	add    $0x1,%eax
 37f:	84 d2                	test   %dl,%dl
 381:	74 0d                	je     390 <strchr+0x30>
    if(*s == c)
 383:	38 d1                	cmp    %dl,%cl
 385:	75 f1                	jne    378 <strchr+0x18>
      return (char*)s;
  return 0;
}
 387:	5d                   	pop    %ebp
 388:	c3                   	ret
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 390:	31 c0                	xor    %eax,%eax
}
 392:	5d                   	pop    %ebp
 393:	c3                   	ret
 394:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 39b:	00 
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <gets>:

char*
gets(char *buf, int max)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3a5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 3a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3a9:	31 db                	xor    %ebx,%ebx
{
 3ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3ae:	eb 27                	jmp    3d7 <gets+0x37>
    cc = read(0, &c, 1);
 3b0:	83 ec 04             	sub    $0x4,%esp
 3b3:	6a 01                	push   $0x1
 3b5:	56                   	push   %esi
 3b6:	6a 00                	push   $0x0
 3b8:	e8 1e 01 00 00       	call   4db <read>
    if(cc < 1)
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	85 c0                	test   %eax,%eax
 3c2:	7e 1d                	jle    3e1 <gets+0x41>
      break;
    buf[i++] = c;
 3c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3c8:	8b 55 08             	mov    0x8(%ebp),%edx
 3cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3cf:	3c 0a                	cmp    $0xa,%al
 3d1:	74 10                	je     3e3 <gets+0x43>
 3d3:	3c 0d                	cmp    $0xd,%al
 3d5:	74 0c                	je     3e3 <gets+0x43>
  for(i=0; i+1 < max; ){
 3d7:	89 df                	mov    %ebx,%edi
 3d9:	83 c3 01             	add    $0x1,%ebx
 3dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3df:	7c cf                	jl     3b0 <gets+0x10>
 3e1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 3ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ed:	5b                   	pop    %ebx
 3ee:	5e                   	pop    %esi
 3ef:	5f                   	pop    %edi
 3f0:	5d                   	pop    %ebp
 3f1:	c3                   	ret
 3f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3f9:	00 
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 f1 00 00 00       	call   503 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	push   0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f4 00 00 00       	call   51b <fstat>
  close(fd);
 427:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	e8 ba 00 00 00       	call   4eb <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 44e:	00 
 44f:	90                   	nop

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f be 02             	movsbl (%edx),%eax
 45a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 45d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 460:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 465:	77 1e                	ja     485 <atoi+0x35>
 467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 46e:	00 
 46f:	90                   	nop
    n = n*10 + *s++ - '0';
 470:	83 c2 01             	add    $0x1,%edx
 473:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 476:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 47a:	0f be 02             	movsbl (%edx),%eax
 47d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 488:	89 c8                	mov    %ecx,%eax
 48a:	c9                   	leave
 48b:	c3                   	ret
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	8b 45 10             	mov    0x10(%ebp),%eax
 497:	8b 55 08             	mov    0x8(%ebp),%edx
 49a:	56                   	push   %esi
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	85 c0                	test   %eax,%eax
 4a0:	7e 13                	jle    4b5 <memmove+0x25>
 4a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4a4:	89 d7                	mov    %edx,%edi
 4a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4ad:	00 
 4ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4b1:	39 f8                	cmp    %edi,%eax
 4b3:	75 fb                	jne    4b0 <memmove+0x20>
  return vdst;
}
 4b5:	5e                   	pop    %esi
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret

000004bb <fork>:
    int $T_SYSCALL; \
    ret
// In usys.S


SYSCALL(fork)
 4bb:	b8 01 00 00 00       	mov    $0x1,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <exit>:
SYSCALL(exit)
 4c3:	b8 02 00 00 00       	mov    $0x2,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <wait>:
SYSCALL(wait)
 4cb:	b8 03 00 00 00       	mov    $0x3,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <pipe>:
SYSCALL(pipe)
 4d3:	b8 04 00 00 00       	mov    $0x4,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <read>:
SYSCALL(read)
 4db:	b8 05 00 00 00       	mov    $0x5,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <write>:
SYSCALL(write)
 4e3:	b8 10 00 00 00       	mov    $0x10,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <close>:
SYSCALL(close)
 4eb:	b8 15 00 00 00       	mov    $0x15,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <kill>:
SYSCALL(kill)
 4f3:	b8 06 00 00 00       	mov    $0x6,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <exec>:
SYSCALL(exec)
 4fb:	b8 07 00 00 00       	mov    $0x7,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <open>:
SYSCALL(open)
 503:	b8 0f 00 00 00       	mov    $0xf,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <mknod>:
SYSCALL(mknod)
 50b:	b8 11 00 00 00       	mov    $0x11,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <unlink>:
SYSCALL(unlink)
 513:	b8 12 00 00 00       	mov    $0x12,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <fstat>:
SYSCALL(fstat)
 51b:	b8 08 00 00 00       	mov    $0x8,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <link>:
SYSCALL(link)
 523:	b8 13 00 00 00       	mov    $0x13,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <mkdir>:
SYSCALL(mkdir)
 52b:	b8 14 00 00 00       	mov    $0x14,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <chdir>:
SYSCALL(chdir)
 533:	b8 09 00 00 00       	mov    $0x9,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <dup>:
SYSCALL(dup)
 53b:	b8 0a 00 00 00       	mov    $0xa,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <getpid>:
SYSCALL(getpid)
 543:	b8 0b 00 00 00       	mov    $0xb,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <sbrk>:
SYSCALL(sbrk)
 54b:	b8 0c 00 00 00       	mov    $0xc,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <sleep>:
SYSCALL(sleep)
 553:	b8 0d 00 00 00       	mov    $0xd,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <uptime>:
SYSCALL(uptime)
 55b:	b8 0e 00 00 00       	mov    $0xe,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <move_file>:
SYSCALL(move_file)
 563:	b8 1a 00 00 00       	mov    $0x1a,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <sort_syscalls>:
SYSCALL(sort_syscalls)
 56b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <create_palindrom>:
SYSCALL(create_palindrom)
 573:	b8 16 00 00 00       	mov    $0x16,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <get_most_invoked_syscalls>:
SYSCALL(get_most_invoked_syscalls) 
 57b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <list_all_processes>:
SYSCALL(list_all_processes)
 583:	b8 17 00 00 00       	mov    $0x17,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <change_schedular_queue>:
SYSCALL(change_schedular_queue)
 58b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <show_process_info>:
SYSCALL(show_process_info)
 593:	b8 1d 00 00 00       	mov    $0x1d,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <set_proc_sjf_params>:
 59b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret
 5a3:	66 90                	xchg   %ax,%ax
 5a5:	66 90                	xchg   %ax,%ax
 5a7:	66 90                	xchg   %ax,%ax
 5a9:	66 90                	xchg   %ax,%ax
 5ab:	66 90                	xchg   %ax,%ax
 5ad:	66 90                	xchg   %ax,%ax
 5af:	90                   	nop

000005b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5b8:	89 d1                	mov    %edx,%ecx
{
 5ba:	83 ec 3c             	sub    $0x3c,%esp
 5bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5c0:	85 d2                	test   %edx,%edx
 5c2:	0f 89 80 00 00 00    	jns    648 <printint+0x98>
 5c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5cc:	74 7a                	je     648 <printint+0x98>
    x = -xx;
 5ce:	f7 d9                	neg    %ecx
    neg = 1;
 5d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5d8:	31 f6                	xor    %esi,%esi
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5e0:	89 c8                	mov    %ecx,%eax
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	89 f7                	mov    %esi,%edi
 5e6:	f7 f3                	div    %ebx
 5e8:	8d 76 01             	lea    0x1(%esi),%esi
 5eb:	0f b6 92 00 0a 00 00 	movzbl 0xa00(%edx),%edx
 5f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5f6:	89 ca                	mov    %ecx,%edx
 5f8:	89 c1                	mov    %eax,%ecx
 5fa:	39 da                	cmp    %ebx,%edx
 5fc:	73 e2                	jae    5e0 <printint+0x30>
  if(neg)
 5fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 601:	85 c0                	test   %eax,%eax
 603:	74 07                	je     60c <printint+0x5c>
    buf[i++] = '-';
 605:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 60a:	89 f7                	mov    %esi,%edi
 60c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 60f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 612:	01 df                	add    %ebx,%edi
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 618:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 61b:	83 ec 04             	sub    $0x4,%esp
 61e:	88 45 d7             	mov    %al,-0x29(%ebp)
 621:	8d 45 d7             	lea    -0x29(%ebp),%eax
 624:	6a 01                	push   $0x1
 626:	50                   	push   %eax
 627:	56                   	push   %esi
 628:	e8 b6 fe ff ff       	call   4e3 <write>
  while(--i >= 0)
 62d:	89 f8                	mov    %edi,%eax
 62f:	83 c4 10             	add    $0x10,%esp
 632:	83 ef 01             	sub    $0x1,%edi
 635:	39 c3                	cmp    %eax,%ebx
 637:	75 df                	jne    618 <printint+0x68>
}
 639:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63c:	5b                   	pop    %ebx
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 648:	31 c0                	xor    %eax,%eax
 64a:	eb 89                	jmp    5d5 <printint+0x25>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000650 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 659:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 65c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 65f:	0f b6 1e             	movzbl (%esi),%ebx
 662:	83 c6 01             	add    $0x1,%esi
 665:	84 db                	test   %bl,%bl
 667:	74 67                	je     6d0 <printf+0x80>
 669:	8d 4d 10             	lea    0x10(%ebp),%ecx
 66c:	31 d2                	xor    %edx,%edx
 66e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 671:	eb 34                	jmp    6a7 <printf+0x57>
 673:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 678:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 67b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 680:	83 f8 25             	cmp    $0x25,%eax
 683:	74 18                	je     69d <printf+0x4d>
  write(fd, &c, 1);
 685:	83 ec 04             	sub    $0x4,%esp
 688:	8d 45 e7             	lea    -0x19(%ebp),%eax
 68b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 68e:	6a 01                	push   $0x1
 690:	50                   	push   %eax
 691:	57                   	push   %edi
 692:	e8 4c fe ff ff       	call   4e3 <write>
 697:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 69a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 69d:	0f b6 1e             	movzbl (%esi),%ebx
 6a0:	83 c6 01             	add    $0x1,%esi
 6a3:	84 db                	test   %bl,%bl
 6a5:	74 29                	je     6d0 <printf+0x80>
    c = fmt[i] & 0xff;
 6a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6aa:	85 d2                	test   %edx,%edx
 6ac:	74 ca                	je     678 <printf+0x28>
      }
    } else if(state == '%'){
 6ae:	83 fa 25             	cmp    $0x25,%edx
 6b1:	75 ea                	jne    69d <printf+0x4d>
      if(c == 'd'){
 6b3:	83 f8 25             	cmp    $0x25,%eax
 6b6:	0f 84 04 01 00 00    	je     7c0 <printf+0x170>
 6bc:	83 e8 63             	sub    $0x63,%eax
 6bf:	83 f8 15             	cmp    $0x15,%eax
 6c2:	77 1c                	ja     6e0 <printf+0x90>
 6c4:	ff 24 85 a8 09 00 00 	jmp    *0x9a8(,%eax,4)
 6cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5f                   	pop    %edi
 6d6:	5d                   	pop    %ebp
 6d7:	c3                   	ret
 6d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6df:	00 
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ea:	6a 01                	push   $0x1
 6ec:	52                   	push   %edx
 6ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6f0:	57                   	push   %edi
 6f1:	e8 ed fd ff ff       	call   4e3 <write>
 6f6:	83 c4 0c             	add    $0xc,%esp
 6f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6fc:	6a 01                	push   $0x1
 6fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 701:	52                   	push   %edx
 702:	57                   	push   %edi
 703:	e8 db fd ff ff       	call   4e3 <write>
        putc(fd, c);
 708:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70b:	31 d2                	xor    %edx,%edx
 70d:	eb 8e                	jmp    69d <printf+0x4d>
 70f:	90                   	nop
        printint(fd, *ap, 16, 0);
 710:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 713:	83 ec 0c             	sub    $0xc,%esp
 716:	b9 10 00 00 00       	mov    $0x10,%ecx
 71b:	8b 13                	mov    (%ebx),%edx
 71d:	6a 00                	push   $0x0
 71f:	89 f8                	mov    %edi,%eax
        ap++;
 721:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 724:	e8 87 fe ff ff       	call   5b0 <printint>
        ap++;
 729:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 72c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72f:	31 d2                	xor    %edx,%edx
 731:	e9 67 ff ff ff       	jmp    69d <printf+0x4d>
        s = (char*)*ap;
 736:	8b 45 d0             	mov    -0x30(%ebp),%eax
 739:	8b 18                	mov    (%eax),%ebx
        ap++;
 73b:	83 c0 04             	add    $0x4,%eax
 73e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 741:	85 db                	test   %ebx,%ebx
 743:	0f 84 87 00 00 00    	je     7d0 <printf+0x180>
        while(*s != 0){
 749:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 74c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 74e:	84 c0                	test   %al,%al
 750:	0f 84 47 ff ff ff    	je     69d <printf+0x4d>
 756:	8d 55 e7             	lea    -0x19(%ebp),%edx
 759:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 75c:	89 de                	mov    %ebx,%esi
 75e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
 763:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 766:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 769:	6a 01                	push   $0x1
 76b:	53                   	push   %ebx
 76c:	57                   	push   %edi
 76d:	e8 71 fd ff ff       	call   4e3 <write>
        while(*s != 0){
 772:	0f b6 06             	movzbl (%esi),%eax
 775:	83 c4 10             	add    $0x10,%esp
 778:	84 c0                	test   %al,%al
 77a:	75 e4                	jne    760 <printf+0x110>
      state = 0;
 77c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 17 ff ff ff       	jmp    69d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 786:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 789:	83 ec 0c             	sub    $0xc,%esp
 78c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 791:	8b 13                	mov    (%ebx),%edx
 793:	6a 01                	push   $0x1
 795:	eb 88                	jmp    71f <printf+0xcf>
        putc(fd, *ap);
 797:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 79a:	83 ec 04             	sub    $0x4,%esp
 79d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
 7aa:	52                   	push   %edx
 7ab:	57                   	push   %edi
 7ac:	e8 32 fd ff ff       	call   4e3 <write>
        ap++;
 7b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7b7:	31 d2                	xor    %edx,%edx
 7b9:	e9 df fe ff ff       	jmp    69d <printf+0x4d>
 7be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7c9:	6a 01                	push   $0x1
 7cb:	e9 31 ff ff ff       	jmp    701 <printf+0xb1>
 7d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7d5:	bb 7f 09 00 00       	mov    $0x97f,%ebx
 7da:	e9 77 ff ff ff       	jmp    756 <printf+0x106>
 7df:	90                   	nop

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 d8 0c 00 00       	mov    0xcd8,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	39 c8                	cmp    %ecx,%eax
 7fc:	73 32                	jae    830 <free+0x50>
 7fe:	39 d1                	cmp    %edx,%ecx
 800:	72 04                	jb     806 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	39 d0                	cmp    %edx,%eax
 804:	72 32                	jb     838 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 806:	8b 73 fc             	mov    -0x4(%ebx),%esi
 809:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80c:	39 fa                	cmp    %edi,%edx
 80e:	74 30                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 819:	39 f1                	cmp    %esi,%ecx
 81b:	74 3a                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 81d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 81f:	5b                   	pop    %ebx
  freep = p;
 820:	a3 d8 0c 00 00       	mov    %eax,0xcd8
}
 825:	5e                   	pop    %esi
 826:	5f                   	pop    %edi
 827:	5d                   	pop    %ebp
 828:	c3                   	ret
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 d0                	cmp    %edx,%eax
 832:	72 04                	jb     838 <free+0x58>
 834:	39 d1                	cmp    %edx,%ecx
 836:	72 ce                	jb     806 <free+0x26>
{
 838:	89 d0                	mov    %edx,%eax
 83a:	eb bc                	jmp    7f8 <free+0x18>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 c6                	jne    81d <free+0x3d>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 d8 0c 00 00       	mov    %eax,0xcd8
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 865:	89 08                	mov    %ecx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 15 d8 0c 00 00    	mov    0xcd8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 78 07             	lea    0x7(%eax),%edi
 885:	c1 ef 03             	shr    $0x3,%edi
 888:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 88b:	85 d2                	test   %edx,%edx
 88d:	0f 84 8d 00 00 00    	je     920 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 895:	8b 48 04             	mov    0x4(%eax),%ecx
 898:	39 f9                	cmp    %edi,%ecx
 89a:	73 64                	jae    900 <malloc+0x90>
  if(nu < 4096)
 89c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a1:	39 df                	cmp    %ebx,%edi
 8a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8ad:	eb 0a                	jmp    8b9 <malloc+0x49>
 8af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b2:	8b 48 04             	mov    0x4(%eax),%ecx
 8b5:	39 f9                	cmp    %edi,%ecx
 8b7:	73 47                	jae    900 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b9:	89 c2                	mov    %eax,%edx
 8bb:	3b 05 d8 0c 00 00    	cmp    0xcd8,%eax
 8c1:	75 ed                	jne    8b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8c3:	83 ec 0c             	sub    $0xc,%esp
 8c6:	56                   	push   %esi
 8c7:	e8 7f fc ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 8cc:	83 c4 10             	add    $0x10,%esp
 8cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d2:	74 1c                	je     8f0 <malloc+0x80>
  hp->s.size = nu;
 8d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8d7:	83 ec 0c             	sub    $0xc,%esp
 8da:	83 c0 08             	add    $0x8,%eax
 8dd:	50                   	push   %eax
 8de:	e8 fd fe ff ff       	call   7e0 <free>
  return freep;
 8e3:	8b 15 d8 0c 00 00    	mov    0xcd8,%edx
      if((p = morecore(nunits)) == 0)
 8e9:	83 c4 10             	add    $0x10,%esp
 8ec:	85 d2                	test   %edx,%edx
 8ee:	75 c0                	jne    8b0 <malloc+0x40>
        return 0;
  }
}
 8f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8f3:	31 c0                	xor    %eax,%eax
}
 8f5:	5b                   	pop    %ebx
 8f6:	5e                   	pop    %esi
 8f7:	5f                   	pop    %edi
 8f8:	5d                   	pop    %ebp
 8f9:	c3                   	ret
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 900:	39 cf                	cmp    %ecx,%edi
 902:	74 4c                	je     950 <malloc+0xe0>
        p->s.size -= nunits;
 904:	29 f9                	sub    %edi,%ecx
 906:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 909:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 90c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 90f:	89 15 d8 0c 00 00    	mov    %edx,0xcd8
}
 915:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 918:	83 c0 08             	add    $0x8,%eax
}
 91b:	5b                   	pop    %ebx
 91c:	5e                   	pop    %esi
 91d:	5f                   	pop    %edi
 91e:	5d                   	pop    %ebp
 91f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 920:	c7 05 d8 0c 00 00 dc 	movl   $0xcdc,0xcd8
 927:	0c 00 00 
    base.s.size = 0;
 92a:	b8 dc 0c 00 00       	mov    $0xcdc,%eax
    base.s.ptr = freep = prevp = &base;
 92f:	c7 05 dc 0c 00 00 dc 	movl   $0xcdc,0xcdc
 936:	0c 00 00 
    base.s.size = 0;
 939:	c7 05 e0 0c 00 00 00 	movl   $0x0,0xce0
 940:	00 00 00 
    if(p->s.size >= nunits){
 943:	e9 54 ff ff ff       	jmp    89c <malloc+0x2c>
 948:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 94f:	00 
        prevp->s.ptr = p->s.ptr;
 950:	8b 08                	mov    (%eax),%ecx
 952:	89 0a                	mov    %ecx,(%edx)
 954:	eb b9                	jmp    90f <malloc+0x9f>
