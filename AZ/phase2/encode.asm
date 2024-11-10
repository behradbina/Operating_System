
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
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 51 04             	mov    0x4(%ecx),%edx
    char* text_to_encode[argc-1];
  19:	8d 47 ff             	lea    -0x1(%edi),%eax
  1c:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  23:	89 45 dc             	mov    %eax,-0x24(%ebp)
  26:	8d 43 0f             	lea    0xf(%ebx),%eax
  29:	89 c1                	mov    %eax,%ecx
  2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  30:	83 e1 f0             	and    $0xfffffff0,%ecx
  33:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  36:	89 e1                	mov    %esp,%ecx
  38:	29 c1                	sub    %eax,%ecx
  3a:	39 cc                	cmp    %ecx,%esp
  3c:	74 12                	je     50 <main+0x50>
  3e:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  44:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  4b:	00 
  4c:	39 cc                	cmp    %ecx,%esp
  4e:	75 ee                	jne    3e <main+0x3e>
  50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  53:	25 ff 0f 00 00       	and    $0xfff,%eax
  58:	29 c4                	sub    %eax,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	0f 85 5d 01 00 00    	jne    1bf <main+0x1bf>
    int flag=0;
    if(argc <2){
  62:	83 ef 01             	sub    $0x1,%edi
    char* text_to_encode[argc-1];
  65:	89 65 d8             	mov    %esp,-0x28(%ebp)
    if(argc <2){
  68:	0f 8e 3e 01 00 00    	jle    1ac <main+0x1ac>
  6e:	8b 7d d8             	mov    -0x28(%ebp),%edi
  71:	8d 42 04             	lea    0x4(%edx),%eax
  74:	8d 4c 1a 04          	lea    0x4(%edx,%ebx,1),%ecx
  78:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  7b:	89 fa                	mov    %edi,%edx
  7d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    else{
        flag=1;
        for (int i=1;i<argc;i++){

            text_to_encode[i-1]=argv[i];
  80:	8b 38                	mov    (%eax),%edi
        for (int i=1;i<argc;i++){
  82:	83 c0 04             	add    $0x4,%eax
  85:	83 c2 04             	add    $0x4,%edx
            text_to_encode[i-1]=argv[i];
  88:	89 7a fc             	mov    %edi,-0x4(%edx)
        for (int i=1;i<argc;i++){
  8b:	39 c8                	cmp    %ecx,%eax
  8d:	75 f1                	jne    80 <main+0x80>
    
        }
    }
    if(flag){
        for (int i=0;i<argc-1;i++){
  8f:	8b 7d dc             	mov    -0x24(%ebp),%edi
  92:	85 ff                	test   %edi,%edi
  94:	0f 8e 2f 01 00 00    	jle    1c9 <main+0x1c9>
  9a:	03 5d d8             	add    -0x28(%ebp),%ebx
  9d:	89 5d e0             	mov    %ebx,-0x20(%ebp)


        cesar_encode(text_to_encode[i],15);
  a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a3:	8b 18                	mov    (%eax),%ebx
    for (int i=0;text[i]!='\0';i++)
  a5:	0f be 0b             	movsbl (%ebx),%ecx
  a8:	84 c9                	test   %cl,%cl
  aa:	75 46                	jne    f2 <main+0xf2>
  ac:	eb 62                	jmp    110 <main+0x110>
  ae:	66 90                	xchg   %ax,%ax
        if(c>='A' && c<='Z'){
  b0:	8d 41 bf             	lea    -0x41(%ecx),%eax
  b3:	3c 19                	cmp    $0x19,%al
  b5:	77 47                	ja     fe <main+0xfe>
  b7:	bf 41 00 00 00       	mov    $0x41,%edi
  bc:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
  c1:	be 41 00 00 00       	mov    $0x41,%esi
        text[i]=(c-base+shift)%26+base;
  c6:	29 c1                	sub    %eax,%ecx
  c8:	ba 4f ec c4 4e       	mov    $0x4ec4ec4f,%edx
  cd:	83 c3 01             	add    $0x1,%ebx
  d0:	83 c1 0f             	add    $0xf,%ecx
  d3:	89 c8                	mov    %ecx,%eax
  d5:	f7 ea                	imul   %edx
  d7:	89 c8                	mov    %ecx,%eax
  d9:	c1 f8 1f             	sar    $0x1f,%eax
  dc:	c1 fa 03             	sar    $0x3,%edx
  df:	29 c2                	sub    %eax,%edx
  e1:	6b d2 1a             	imul   $0x1a,%edx,%edx
  e4:	29 d1                	sub    %edx,%ecx
  e6:	01 f9                	add    %edi,%ecx
  e8:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
  eb:	0f be 0b             	movsbl (%ebx),%ecx
  ee:	84 c9                	test   %cl,%cl
  f0:	74 1e                	je     110 <main+0x110>
        if (c>='a' && c<='z'){
  f2:	8d 41 9f             	lea    -0x61(%ecx),%eax
  f5:	3c 19                	cmp    $0x19,%al
  f7:	77 b7                	ja     b0 <main+0xb0>
        base='a';}
  f9:	be 61 00 00 00       	mov    $0x61,%esi
        text[i]=(c-base+shift)%26+base;
  fe:	89 f0                	mov    %esi,%eax
 100:	89 f7                	mov    %esi,%edi
 102:	0f be c0             	movsbl %al,%eax
 105:	eb bf                	jmp    c6 <main+0xc6>
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax
        for (int i=0;i<argc-1;i++){
 110:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 117:	39 45 e0             	cmp    %eax,-0x20(%ebp)
 11a:	75 84                	jne    a0 <main+0xa0>
  
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
 11c:	52                   	push   %edx
 11d:	52                   	push   %edx
 11e:	68 02 02 00 00       	push   $0x202
 123:	68 94 09 00 00       	push   $0x994
 128:	e8 e6 03 00 00       	call   513 <open>

        char * space=" ";
        char * next_line="\n";
        if (fd <0){
 12d:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 130:	89 c3                	mov    %eax,%ebx
        if (fd <0){
 132:	85 c0                	test   %eax,%eax
 134:	0f 88 a9 00 00 00    	js     1e3 <main+0x1e3>
 13a:	31 ff                	xor    %edi,%edi
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 140:	8b 45 d8             	mov    -0x28(%ebp),%eax
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
 158:	e8 96 03 00 00       	call   4f3 <write>
                write(fd,space,strlen(space));
 15d:	c7 04 24 92 09 00 00 	movl   $0x992,(%esp)
 164:	e8 a7 01 00 00       	call   310 <strlen>
 169:	83 c4 0c             	add    $0xc,%esp
 16c:	50                   	push   %eax
 16d:	68 92 09 00 00       	push   $0x992
 172:	53                   	push   %ebx
 173:	e8 7b 03 00 00       	call   4f3 <write>
            for (int i=0;i<argc-1;i++){
 178:	83 c4 10             	add    $0x10,%esp
 17b:	39 7d dc             	cmp    %edi,-0x24(%ebp)
 17e:	75 c0                	jne    140 <main+0x140>
            }



            write(fd,next_line,strlen(next_line));
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	68 90 09 00 00       	push   $0x990
 188:	e8 83 01 00 00       	call   310 <strlen>
 18d:	83 c4 0c             	add    $0xc,%esp
 190:	50                   	push   %eax
 191:	68 90 09 00 00       	push   $0x990
 196:	53                   	push   %ebx
 197:	e8 57 03 00 00       	call   4f3 <write>
        }
        close(fd);
 19c:	89 1c 24             	mov    %ebx,(%esp)
 19f:	e8 57 03 00 00       	call   4fb <close>
 1a4:	83 c4 10             	add    $0x10,%esp

    }
    
    exit();
 1a7:	e8 27 03 00 00       	call   4d3 <exit>
        printf(1,"no text to encode passed\n");
 1ac:	50                   	push   %eax
 1ad:	50                   	push   %eax
 1ae:	68 78 09 00 00       	push   $0x978
 1b3:	6a 01                	push   $0x1
 1b5:	e8 96 04 00 00       	call   650 <printf>
 1ba:	83 c4 10             	add    $0x10,%esp
 1bd:	eb e8                	jmp    1a7 <main+0x1a7>
    char* text_to_encode[argc-1];
 1bf:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
 1c4:	e9 99 fe ff ff       	jmp    62 <main+0x62>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 1c9:	50                   	push   %eax
 1ca:	50                   	push   %eax
 1cb:	68 02 02 00 00       	push   $0x202
 1d0:	68 94 09 00 00       	push   $0x994
 1d5:	e8 39 03 00 00       	call   513 <open>
        if (fd <0){
 1da:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 1dd:	89 c3                	mov    %eax,%ebx
        if (fd <0){
 1df:	85 c0                	test   %eax,%eax
 1e1:	79 9d                	jns    180 <main+0x180>
            printf(1,"Unable to open or create file \n");
 1e3:	51                   	push   %ecx
 1e4:	51                   	push   %ecx
 1e5:	68 a0 09 00 00       	push   $0x9a0
 1ea:	6a 01                	push   $0x1
 1ec:	e8 5f 04 00 00       	call   650 <printf>
            exit();
 1f1:	e8 dd 02 00 00       	call   4d3 <exit>
 1f6:	66 90                	xchg   %ax,%ax
 1f8:	66 90                	xchg   %ax,%ax
 1fa:	66 90                	xchg   %ax,%ax
 1fc:	66 90                	xchg   %ax,%ax
 1fe:	66 90                	xchg   %ax,%ax

00000200 <cesar_encode>:
void cesar_encode(char* text,int shift){
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
 206:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (int i=0;text[i]!='\0';i++)
 209:	0f be 0b             	movsbl (%ebx),%ecx
 20c:	84 c9                	test   %cl,%cl
 20e:	75 4a                	jne    25a <cesar_encode+0x5a>
 210:	eb 5e                	jmp    270 <cesar_encode+0x70>
 212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(c>='A' && c<='Z'){
 218:	8d 41 bf             	lea    -0x41(%ecx),%eax
 21b:	3c 19                	cmp    $0x19,%al
 21d:	77 47                	ja     266 <cesar_encode+0x66>
 21f:	be 41 00 00 00       	mov    $0x41,%esi
 224:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
 229:	bf 41 00 00 00       	mov    $0x41,%edi
        text[i]=(c-base+shift)%26+base;
 22e:	29 c1                	sub    %eax,%ecx
 230:	03 4d 0c             	add    0xc(%ebp),%ecx
 233:	ba 4f ec c4 4e       	mov    $0x4ec4ec4f,%edx
 238:	83 c3 01             	add    $0x1,%ebx
 23b:	89 c8                	mov    %ecx,%eax
 23d:	f7 ea                	imul   %edx
 23f:	89 c8                	mov    %ecx,%eax
 241:	c1 f8 1f             	sar    $0x1f,%eax
 244:	c1 fa 03             	sar    $0x3,%edx
 247:	29 c2                	sub    %eax,%edx
 249:	6b d2 1a             	imul   $0x1a,%edx,%edx
 24c:	29 d1                	sub    %edx,%ecx
 24e:	01 f1                	add    %esi,%ecx
 250:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
 253:	0f be 0b             	movsbl (%ebx),%ecx
 256:	84 c9                	test   %cl,%cl
 258:	74 16                	je     270 <cesar_encode+0x70>
        if (c>='a' && c<='z'){
 25a:	8d 41 9f             	lea    -0x61(%ecx),%eax
 25d:	3c 19                	cmp    $0x19,%al
 25f:	77 b7                	ja     218 <cesar_encode+0x18>
        base='a';}
 261:	bf 61 00 00 00       	mov    $0x61,%edi
        text[i]=(c-base+shift)%26+base;
 266:	89 f8                	mov    %edi,%eax
 268:	89 fe                	mov    %edi,%esi
 26a:	0f be c0             	movsbl %al,%eax
 26d:	eb bf                	jmp    22e <cesar_encode+0x2e>
 26f:	90                   	nop
}
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    
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
 2a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
 2c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c7:	90                   	nop
 2c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2cc:	83 c2 01             	add    $0x1,%edx
 2cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2d2:	84 c0                	test   %al,%al
 2d4:	74 1a                	je     2f0 <strcmp+0x40>
    p++, q++;
 2d6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 2d8:	0f b6 19             	movzbl (%ecx),%ebx
 2db:	38 c3                	cmp    %al,%bl
 2dd:	74 e9                	je     2c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2df:	29 d8                	sub    %ebx,%eax
}
 2e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    
 2e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
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
 304:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 30f:	90                   	nop

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
 336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33d:	8d 76 00             	lea    0x0(%esi),%esi

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
 373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 377:	90                   	nop
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
 394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop

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
 3a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
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
 3b5:	57                   	push   %edi
 3b6:	6a 00                	push   $0x0
 3b8:	e8 2e 01 00 00       	call   4eb <read>
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
 3d1:	74 1d                	je     3f0 <gets+0x50>
 3d3:	3c 0d                	cmp    $0xd,%al
 3d5:	74 19                	je     3f0 <gets+0x50>
  for(i=0; i+1 < max; ){
 3d7:	89 de                	mov    %ebx,%esi
 3d9:	83 c3 01             	add    $0x1,%ebx
 3dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3df:	7c cf                	jl     3b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3eb:	5b                   	pop    %ebx
 3ec:	5e                   	pop    %esi
 3ed:	5f                   	pop    %edi
 3ee:	5d                   	pop    %ebp
 3ef:	c3                   	ret    
  buf[i] = '\0';
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	89 de                	mov    %ebx,%esi
 3f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 3f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fc:	5b                   	pop    %ebx
 3fd:	5e                   	pop    %esi
 3fe:	5f                   	pop    %edi
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret    
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop

00000410 <stat>:

int
stat(const char *n, struct stat *st)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 415:	83 ec 08             	sub    $0x8,%esp
 418:	6a 00                	push   $0x0
 41a:	ff 75 08             	push   0x8(%ebp)
 41d:	e8 f1 00 00 00       	call   513 <open>
  if(fd < 0)
 422:	83 c4 10             	add    $0x10,%esp
 425:	85 c0                	test   %eax,%eax
 427:	78 27                	js     450 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	ff 75 0c             	push   0xc(%ebp)
 42f:	89 c3                	mov    %eax,%ebx
 431:	50                   	push   %eax
 432:	e8 f4 00 00 00       	call   52b <fstat>
  close(fd);
 437:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 43a:	89 c6                	mov    %eax,%esi
  close(fd);
 43c:	e8 ba 00 00 00       	call   4fb <close>
  return r;
 441:	83 c4 10             	add    $0x10,%esp
}
 444:	8d 65 f8             	lea    -0x8(%ebp),%esp
 447:	89 f0                	mov    %esi,%eax
 449:	5b                   	pop    %ebx
 44a:	5e                   	pop    %esi
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret    
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 450:	be ff ff ff ff       	mov    $0xffffffff,%esi
 455:	eb ed                	jmp    444 <stat+0x34>
 457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45e:	66 90                	xchg   %ax,%ax

00000460 <atoi>:

int
atoi(const char *s)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	53                   	push   %ebx
 464:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 467:	0f be 02             	movsbl (%edx),%eax
 46a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 46d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 470:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 475:	77 1e                	ja     495 <atoi+0x35>
 477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 480:	83 c2 01             	add    $0x1,%edx
 483:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 486:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 48a:	0f be 02             	movsbl (%edx),%eax
 48d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 490:	80 fb 09             	cmp    $0x9,%bl
 493:	76 eb                	jbe    480 <atoi+0x20>
  return n;
}
 495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 498:	89 c8                	mov    %ecx,%eax
 49a:	c9                   	leave  
 49b:	c3                   	ret    
 49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	8b 45 10             	mov    0x10(%ebp),%eax
 4a7:	8b 55 08             	mov    0x8(%ebp),%edx
 4aa:	56                   	push   %esi
 4ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ae:	85 c0                	test   %eax,%eax
 4b0:	7e 13                	jle    4c5 <memmove+0x25>
 4b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4b4:	89 d7                	mov    %edx,%edi
 4b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4c1:	39 f8                	cmp    %edi,%eax
 4c3:	75 fb                	jne    4c0 <memmove+0x20>
  return vdst;
}
 4c5:	5e                   	pop    %esi
 4c6:	89 d0                	mov    %edx,%eax
 4c8:	5f                   	pop    %edi
 4c9:	5d                   	pop    %ebp
 4ca:	c3                   	ret    

000004cb <fork>:
    int $T_SYSCALL; \
    ret
// In usys.S


SYSCALL(fork)
 4cb:	b8 01 00 00 00       	mov    $0x1,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <exit>:
SYSCALL(exit)
 4d3:	b8 02 00 00 00       	mov    $0x2,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <wait>:
SYSCALL(wait)
 4db:	b8 03 00 00 00       	mov    $0x3,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <pipe>:
SYSCALL(pipe)
 4e3:	b8 04 00 00 00       	mov    $0x4,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <read>:
SYSCALL(read)
 4eb:	b8 05 00 00 00       	mov    $0x5,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <write>:
SYSCALL(write)
 4f3:	b8 10 00 00 00       	mov    $0x10,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <close>:
SYSCALL(close)
 4fb:	b8 15 00 00 00       	mov    $0x15,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <kill>:
SYSCALL(kill)
 503:	b8 06 00 00 00       	mov    $0x6,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <exec>:
SYSCALL(exec)
 50b:	b8 07 00 00 00       	mov    $0x7,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <open>:
SYSCALL(open)
 513:	b8 0f 00 00 00       	mov    $0xf,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <mknod>:
SYSCALL(mknod)
 51b:	b8 11 00 00 00       	mov    $0x11,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <unlink>:
SYSCALL(unlink)
 523:	b8 12 00 00 00       	mov    $0x12,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <fstat>:
SYSCALL(fstat)
 52b:	b8 08 00 00 00       	mov    $0x8,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <link>:
SYSCALL(link)
 533:	b8 13 00 00 00       	mov    $0x13,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <mkdir>:
SYSCALL(mkdir)
 53b:	b8 14 00 00 00       	mov    $0x14,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <chdir>:
SYSCALL(chdir)
 543:	b8 09 00 00 00       	mov    $0x9,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <dup>:
SYSCALL(dup)
 54b:	b8 0a 00 00 00       	mov    $0xa,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <getpid>:
SYSCALL(getpid)
 553:	b8 0b 00 00 00       	mov    $0xb,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <sbrk>:
SYSCALL(sbrk)
 55b:	b8 0c 00 00 00       	mov    $0xc,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <sleep>:
SYSCALL(sleep)
 563:	b8 0d 00 00 00       	mov    $0xd,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <uptime>:
SYSCALL(uptime)
 56b:	b8 0e 00 00 00       	mov    $0xe,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <move_file>:
SYSCALL(move_file)
 573:	b8 1a 00 00 00       	mov    $0x1a,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <sort_syscalls>:
SYSCALL(sort_syscalls)
 57b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <create_palindrom>:
SYSCALL(create_palindrom)
 583:	b8 16 00 00 00       	mov    $0x16,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <get_most_invoked_syscalls>:
SYSCALL(get_most_invoked_syscalls) 
 58b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    
 593:	66 90                	xchg   %ax,%ax
 595:	66 90                	xchg   %ax,%ax
 597:	66 90                	xchg   %ax,%ax
 599:	66 90                	xchg   %ax,%ax
 59b:	66 90                	xchg   %ax,%ax
 59d:	66 90                	xchg   %ax,%ax
 59f:	90                   	nop

000005a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 3c             	sub    $0x3c,%esp
 5a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5ac:	89 d1                	mov    %edx,%ecx
{
 5ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5b1:	85 d2                	test   %edx,%edx
 5b3:	0f 89 7f 00 00 00    	jns    638 <printint+0x98>
 5b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5bd:	74 79                	je     638 <printint+0x98>
    neg = 1;
 5bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5c8:	31 db                	xor    %ebx,%ebx
 5ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5d0:	89 c8                	mov    %ecx,%eax
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	89 cf                	mov    %ecx,%edi
 5d6:	f7 75 c4             	divl   -0x3c(%ebp)
 5d9:	0f b6 92 20 0a 00 00 	movzbl 0xa20(%edx),%edx
 5e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5e3:	89 d8                	mov    %ebx,%eax
 5e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5f1:	76 dd                	jbe    5d0 <printint+0x30>
  if(neg)
 5f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5f6:	85 c9                	test   %ecx,%ecx
 5f8:	74 0c                	je     606 <printint+0x66>
    buf[i++] = '-';
 5fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 601:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 606:	8b 7d b8             	mov    -0x48(%ebp),%edi
 609:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 60d:	eb 07                	jmp    616 <printint+0x76>
 60f:	90                   	nop
    putc(fd, buf[i]);
 610:	0f b6 13             	movzbl (%ebx),%edx
 613:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 616:	83 ec 04             	sub    $0x4,%esp
 619:	88 55 d7             	mov    %dl,-0x29(%ebp)
 61c:	6a 01                	push   $0x1
 61e:	56                   	push   %esi
 61f:	57                   	push   %edi
 620:	e8 ce fe ff ff       	call   4f3 <write>
  while(--i >= 0)
 625:	83 c4 10             	add    $0x10,%esp
 628:	39 de                	cmp    %ebx,%esi
 62a:	75 e4                	jne    610 <printint+0x70>
}
 62c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62f:	5b                   	pop    %ebx
 630:	5e                   	pop    %esi
 631:	5f                   	pop    %edi
 632:	5d                   	pop    %ebp
 633:	c3                   	ret    
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 638:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 63f:	eb 87                	jmp    5c8 <printint+0x28>
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop

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
 659:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 65c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 65f:	0f b6 13             	movzbl (%ebx),%edx
 662:	84 d2                	test   %dl,%dl
 664:	74 6a                	je     6d0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 666:	8d 45 10             	lea    0x10(%ebp),%eax
 669:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 66c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 66f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 671:	89 45 d0             	mov    %eax,-0x30(%ebp)
 674:	eb 36                	jmp    6ac <printf+0x5c>
 676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67d:	8d 76 00             	lea    0x0(%esi),%esi
 680:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 683:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 688:	83 f8 25             	cmp    $0x25,%eax
 68b:	74 15                	je     6a2 <printf+0x52>
  write(fd, &c, 1);
 68d:	83 ec 04             	sub    $0x4,%esp
 690:	88 55 e7             	mov    %dl,-0x19(%ebp)
 693:	6a 01                	push   $0x1
 695:	57                   	push   %edi
 696:	56                   	push   %esi
 697:	e8 57 fe ff ff       	call   4f3 <write>
 69c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 69f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6a2:	0f b6 13             	movzbl (%ebx),%edx
 6a5:	83 c3 01             	add    $0x1,%ebx
 6a8:	84 d2                	test   %dl,%dl
 6aa:	74 24                	je     6d0 <printf+0x80>
    c = fmt[i] & 0xff;
 6ac:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 6af:	85 c9                	test   %ecx,%ecx
 6b1:	74 cd                	je     680 <printf+0x30>
      }
    } else if(state == '%'){
 6b3:	83 f9 25             	cmp    $0x25,%ecx
 6b6:	75 ea                	jne    6a2 <printf+0x52>
      if(c == 'd'){
 6b8:	83 f8 25             	cmp    $0x25,%eax
 6bb:	0f 84 07 01 00 00    	je     7c8 <printf+0x178>
 6c1:	83 e8 63             	sub    $0x63,%eax
 6c4:	83 f8 15             	cmp    $0x15,%eax
 6c7:	77 17                	ja     6e0 <printf+0x90>
 6c9:	ff 24 85 c8 09 00 00 	jmp    *0x9c8(,%eax,4)
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
 6d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 6e6:	6a 01                	push   $0x1
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ee:	e8 00 fe ff ff       	call   4f3 <write>
        putc(fd, c);
 6f3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 6f7:	83 c4 0c             	add    $0xc,%esp
 6fa:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6fd:	6a 01                	push   $0x1
 6ff:	57                   	push   %edi
 700:	56                   	push   %esi
 701:	e8 ed fd ff ff       	call   4f3 <write>
        putc(fd, c);
 706:	83 c4 10             	add    $0x10,%esp
      state = 0;
 709:	31 c9                	xor    %ecx,%ecx
 70b:	eb 95                	jmp    6a2 <printf+0x52>
 70d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 10 00 00 00       	mov    $0x10,%ecx
 718:	6a 00                	push   $0x0
 71a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 71d:	8b 10                	mov    (%eax),%edx
 71f:	89 f0                	mov    %esi,%eax
 721:	e8 7a fe ff ff       	call   5a0 <printint>
        ap++;
 726:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 72a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72d:	31 c9                	xor    %ecx,%ecx
 72f:	e9 6e ff ff ff       	jmp    6a2 <printf+0x52>
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 738:	8b 45 d0             	mov    -0x30(%ebp),%eax
 73b:	8b 10                	mov    (%eax),%edx
        ap++;
 73d:	83 c0 04             	add    $0x4,%eax
 740:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 743:	85 d2                	test   %edx,%edx
 745:	0f 84 8d 00 00 00    	je     7d8 <printf+0x188>
        while(*s != 0){
 74b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 74e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 750:	84 c0                	test   %al,%al
 752:	0f 84 4a ff ff ff    	je     6a2 <printf+0x52>
 758:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 75b:	89 d3                	mov    %edx,%ebx
 75d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
          s++;
 763:	83 c3 01             	add    $0x1,%ebx
 766:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 769:	6a 01                	push   $0x1
 76b:	57                   	push   %edi
 76c:	56                   	push   %esi
 76d:	e8 81 fd ff ff       	call   4f3 <write>
        while(*s != 0){
 772:	0f b6 03             	movzbl (%ebx),%eax
 775:	83 c4 10             	add    $0x10,%esp
 778:	84 c0                	test   %al,%al
 77a:	75 e4                	jne    760 <printf+0x110>
      state = 0;
 77c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 77f:	31 c9                	xor    %ecx,%ecx
 781:	e9 1c ff ff ff       	jmp    6a2 <printf+0x52>
 786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	b9 0a 00 00 00       	mov    $0xa,%ecx
 798:	6a 01                	push   $0x1
 79a:	e9 7b ff ff ff       	jmp    71a <printf+0xca>
 79f:	90                   	nop
        putc(fd, *ap);
 7a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 7a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7a6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
 7aa:	57                   	push   %edi
 7ab:	56                   	push   %esi
        putc(fd, *ap);
 7ac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7af:	e8 3f fd ff ff       	call   4f3 <write>
        ap++;
 7b4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7bb:	31 c9                	xor    %ecx,%ecx
 7bd:	e9 e0 fe ff ff       	jmp    6a2 <printf+0x52>
 7c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 7c8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 7cb:	83 ec 04             	sub    $0x4,%esp
 7ce:	e9 2a ff ff ff       	jmp    6fd <printf+0xad>
 7d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7d7:	90                   	nop
          s = "(null)";
 7d8:	ba c0 09 00 00       	mov    $0x9c0,%edx
        while(*s != 0){
 7dd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7e0:	b8 28 00 00 00       	mov    $0x28,%eax
 7e5:	89 d3                	mov    %edx,%ebx
 7e7:	e9 74 ff ff ff       	jmp    760 <printf+0x110>
 7ec:	66 90                	xchg   %ax,%ax
 7ee:	66 90                	xchg   %ax,%ax

000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	a1 00 0d 00 00       	mov    0xd00,%eax
{
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	57                   	push   %edi
 7f9:	56                   	push   %esi
 7fa:	53                   	push   %ebx
 7fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 808:	89 c2                	mov    %eax,%edx
 80a:	8b 00                	mov    (%eax),%eax
 80c:	39 ca                	cmp    %ecx,%edx
 80e:	73 30                	jae    840 <free+0x50>
 810:	39 c1                	cmp    %eax,%ecx
 812:	72 04                	jb     818 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 814:	39 c2                	cmp    %eax,%edx
 816:	72 f0                	jb     808 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 818:	8b 73 fc             	mov    -0x4(%ebx),%esi
 81b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81e:	39 f8                	cmp    %edi,%eax
 820:	74 30                	je     852 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 825:	8b 42 04             	mov    0x4(%edx),%eax
 828:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 82b:	39 f1                	cmp    %esi,%ecx
 82d:	74 3a                	je     869 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 82f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 831:	5b                   	pop    %ebx
  freep = p;
 832:	89 15 00 0d 00 00    	mov    %edx,0xd00
}
 838:	5e                   	pop    %esi
 839:	5f                   	pop    %edi
 83a:	5d                   	pop    %ebp
 83b:	c3                   	ret    
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	39 c2                	cmp    %eax,%edx
 842:	72 c4                	jb     808 <free+0x18>
 844:	39 c1                	cmp    %eax,%ecx
 846:	73 c0                	jae    808 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 848:	8b 73 fc             	mov    -0x4(%ebx),%esi
 84b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 84e:	39 f8                	cmp    %edi,%eax
 850:	75 d0                	jne    822 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 852:	03 70 04             	add    0x4(%eax),%esi
 855:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	8b 02                	mov    (%edx),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 85f:	8b 42 04             	mov    0x4(%edx),%eax
 862:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 865:	39 f1                	cmp    %esi,%ecx
 867:	75 c6                	jne    82f <free+0x3f>
    p->s.size += bp->s.size;
 869:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 86c:	89 15 00 0d 00 00    	mov    %edx,0xd00
    p->s.size += bp->s.size;
 872:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 875:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 878:	89 0a                	mov    %ecx,(%edx)
}
 87a:	5b                   	pop    %ebx
 87b:	5e                   	pop    %esi
 87c:	5f                   	pop    %edi
 87d:	5d                   	pop    %ebp
 87e:	c3                   	ret    
 87f:	90                   	nop

00000880 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	57                   	push   %edi
 884:	56                   	push   %esi
 885:	53                   	push   %ebx
 886:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 889:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 88c:	8b 3d 00 0d 00 00    	mov    0xd00,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 892:	8d 70 07             	lea    0x7(%eax),%esi
 895:	c1 ee 03             	shr    $0x3,%esi
 898:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 89b:	85 ff                	test   %edi,%edi
 89d:	0f 84 9d 00 00 00    	je     940 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8a5:	8b 4a 04             	mov    0x4(%edx),%ecx
 8a8:	39 f1                	cmp    %esi,%ecx
 8aa:	73 6a                	jae    916 <malloc+0x96>
 8ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8b1:	39 de                	cmp    %ebx,%esi
 8b3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8b6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8c0:	eb 17                	jmp    8d9 <malloc+0x59>
 8c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ca:	8b 48 04             	mov    0x4(%eax),%ecx
 8cd:	39 f1                	cmp    %esi,%ecx
 8cf:	73 4f                	jae    920 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d1:	8b 3d 00 0d 00 00    	mov    0xd00,%edi
 8d7:	89 c2                	mov    %eax,%edx
 8d9:	39 d7                	cmp    %edx,%edi
 8db:	75 eb                	jne    8c8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8dd:	83 ec 0c             	sub    $0xc,%esp
 8e0:	ff 75 e4             	push   -0x1c(%ebp)
 8e3:	e8 73 fc ff ff       	call   55b <sbrk>
  if(p == (char*)-1)
 8e8:	83 c4 10             	add    $0x10,%esp
 8eb:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ee:	74 1c                	je     90c <malloc+0x8c>
  hp->s.size = nu;
 8f0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8f3:	83 ec 0c             	sub    $0xc,%esp
 8f6:	83 c0 08             	add    $0x8,%eax
 8f9:	50                   	push   %eax
 8fa:	e8 f1 fe ff ff       	call   7f0 <free>
  return freep;
 8ff:	8b 15 00 0d 00 00    	mov    0xd00,%edx
      if((p = morecore(nunits)) == 0)
 905:	83 c4 10             	add    $0x10,%esp
 908:	85 d2                	test   %edx,%edx
 90a:	75 bc                	jne    8c8 <malloc+0x48>
        return 0;
  }
}
 90c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 90f:	31 c0                	xor    %eax,%eax
}
 911:	5b                   	pop    %ebx
 912:	5e                   	pop    %esi
 913:	5f                   	pop    %edi
 914:	5d                   	pop    %ebp
 915:	c3                   	ret    
    if(p->s.size >= nunits){
 916:	89 d0                	mov    %edx,%eax
 918:	89 fa                	mov    %edi,%edx
 91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 920:	39 ce                	cmp    %ecx,%esi
 922:	74 4c                	je     970 <malloc+0xf0>
        p->s.size -= nunits;
 924:	29 f1                	sub    %esi,%ecx
 926:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 929:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 92c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 92f:	89 15 00 0d 00 00    	mov    %edx,0xd00
}
 935:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 938:	83 c0 08             	add    $0x8,%eax
}
 93b:	5b                   	pop    %ebx
 93c:	5e                   	pop    %esi
 93d:	5f                   	pop    %edi
 93e:	5d                   	pop    %ebp
 93f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 00 0d 00 00 04 	movl   $0xd04,0xd00
 947:	0d 00 00 
    base.s.size = 0;
 94a:	bf 04 0d 00 00       	mov    $0xd04,%edi
    base.s.ptr = freep = prevp = &base;
 94f:	c7 05 04 0d 00 00 04 	movl   $0xd04,0xd04
 956:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 959:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 95b:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 962:	00 00 00 
    if(p->s.size >= nunits){
 965:	e9 42 ff ff ff       	jmp    8ac <malloc+0x2c>
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 970:	8b 08                	mov    (%eax),%ecx
 972:	89 0a                	mov    %ecx,(%edx)
 974:	eb b9                	jmp    92f <malloc+0xaf>
