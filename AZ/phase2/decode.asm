
_decode:     file format elf32-i386


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
  16:	8b 49 04             	mov    0x4(%ecx),%ecx
    int flag=0;
    char* text_to_encode[argc-1];
  19:	8d 5f ff             	lea    -0x1(%edi),%ebx
  1c:	8d 14 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edx
  23:	8d 42 0f             	lea    0xf(%edx),%eax
  26:	89 c6                	mov    %eax,%esi
  28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  2d:	83 e6 f0             	and    $0xfffffff0,%esi
  30:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  33:	89 e6                	mov    %esp,%esi
  35:	29 c6                	sub    %eax,%esi
  37:	39 f4                	cmp    %esi,%esp
  39:	74 12                	je     4d <main+0x4d>
  3b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  41:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  48:	00 
  49:	39 f4                	cmp    %esi,%esp
  4b:	75 ee                	jne    3b <main+0x3b>
  4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  50:	25 ff 0f 00 00       	and    $0xfff,%eax
  55:	29 c4                	sub    %eax,%esp
  57:	85 c0                	test   %eax,%eax
  59:	0f 85 20 01 00 00    	jne    17f <main+0x17f>
    if(argc <2){
  5f:	83 ef 01             	sub    $0x1,%edi
    char* text_to_encode[argc-1];
  62:	89 e6                	mov    %esp,%esi
    if(argc <2){
  64:	0f 8e f2 00 00 00    	jle    15c <main+0x15c>
  6a:	8d 41 04             	lea    0x4(%ecx),%eax
  6d:	89 f7                	mov    %esi,%edi
  6f:	8d 4c 11 04          	lea    0x4(%ecx,%edx,1),%ecx
  73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  77:	90                   	nop
    }
    else{
        flag=1;
        for (int i=1;i<argc;i++){

            text_to_encode[i-1]=argv[i];
  78:	8b 10                	mov    (%eax),%edx
        for (int i=1;i<argc;i++){
  7a:	83 c0 04             	add    $0x4,%eax
  7d:	83 c7 04             	add    $0x4,%edi
            text_to_encode[i-1]=argv[i];
  80:	89 57 fc             	mov    %edx,-0x4(%edi)
        for (int i=1;i<argc;i++){
  83:	39 c8                	cmp    %ecx,%eax
  85:	75 f1                	jne    78 <main+0x78>

        }
    }
         printf(1,'%c','\n');
  87:	83 ec 04             	sub    $0x4,%esp
  8a:	6a 0a                	push   $0xa
  8c:	68 63 25 00 00       	push   $0x2563
  91:	6a 01                	push   $0x1
  93:	e8 48 05 00 00       	call   5e0 <printf>
         if (flag){for (int i=0;i<argc-1;i++){
  98:	83 c4 10             	add    $0x10,%esp
  9b:	85 db                	test   %ebx,%ebx
  9d:	0f 8e e6 00 00 00    	jle    189 <main+0x189>
  a3:	31 ff                	xor    %edi,%edi
  a5:	8d 76 00             	lea    0x0(%esi),%esi

        cesar_decode(text_to_encode[i],15);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 0f                	push   $0xf
  ad:	ff 34 be             	push   (%esi,%edi,4)
         if (flag){for (int i=0;i<argc-1;i++){
  b0:	83 c7 01             	add    $0x1,%edi
        cesar_decode(text_to_encode[i],15);
  b3:	e8 08 01 00 00       	call   1c0 <cesar_decode>
         if (flag){for (int i=0;i<argc-1;i++){
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	39 fb                	cmp    %edi,%ebx
  bd:	75 e9                	jne    a8 <main+0xa8>

        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
  bf:	52                   	push   %edx
  c0:	52                   	push   %edx
  c1:	68 02 02 00 00       	push   $0x202
  c6:	68 43 09 00 00       	push   $0x943
  cb:	e8 d3 03 00 00       	call   4a3 <open>

        char * space=" ";
        char * next_line="\n";
        if (fd <0){
  d0:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
  d3:	89 c7                	mov    %eax,%edi
        if (fd <0){
  d5:	85 c0                	test   %eax,%eax
  d7:	0f 88 c6 00 00 00    	js     1a3 <main+0x1a3>
  dd:	89 75 e0             	mov    %esi,-0x20(%ebp)
  e0:	31 d2                	xor    %edx,%edx
  e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  e5:	89 d3                	mov    %edx,%ebx
  e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ee:	66 90                	xchg   %ax,%ax
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
  f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f3:	83 ec 0c             	sub    $0xc,%esp
  f6:	8b 34 98             	mov    (%eax,%ebx,4),%esi
            for (int i=0;i<argc-1;i++){
  f9:	83 c3 01             	add    $0x1,%ebx
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
  fc:	56                   	push   %esi
  fd:	e8 9e 01 00 00       	call   2a0 <strlen>
 102:	83 c4 0c             	add    $0xc,%esp
 105:	50                   	push   %eax
 106:	56                   	push   %esi
 107:	57                   	push   %edi
 108:	e8 76 03 00 00       	call   483 <write>
                write(fd,space,strlen(space));
 10d:	c7 04 24 41 09 00 00 	movl   $0x941,(%esp)
 114:	e8 87 01 00 00       	call   2a0 <strlen>
 119:	83 c4 0c             	add    $0xc,%esp
 11c:	50                   	push   %eax
 11d:	68 41 09 00 00       	push   $0x941
 122:	57                   	push   %edi
 123:	e8 5b 03 00 00       	call   483 <write>
            for (int i=0;i<argc-1;i++){
 128:	83 c4 10             	add    $0x10,%esp
 12b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
 12e:	75 c0                	jne    f0 <main+0xf0>
            }

            write(fd,next_line,strlen(next_line));
 130:	83 ec 0c             	sub    $0xc,%esp
 133:	68 21 09 00 00       	push   $0x921
 138:	e8 63 01 00 00       	call   2a0 <strlen>
 13d:	83 c4 0c             	add    $0xc,%esp
 140:	50                   	push   %eax
 141:	68 21 09 00 00       	push   $0x921
 146:	57                   	push   %edi
 147:	e8 37 03 00 00       	call   483 <write>


        }
        close(fd);}
 14c:	89 3c 24             	mov    %edi,(%esp)
 14f:	e8 37 03 00 00       	call   48b <close>
 154:	83 c4 10             	add    $0x10,%esp
    
    exit();
 157:	e8 07 03 00 00       	call   463 <exit>
        printf(1,"no text to decode passed \n");
 15c:	53                   	push   %ebx
 15d:	53                   	push   %ebx
 15e:	68 08 09 00 00       	push   $0x908
 163:	6a 01                	push   $0x1
 165:	e8 76 04 00 00       	call   5e0 <printf>
         printf(1,'%c','\n');
 16a:	83 c4 0c             	add    $0xc,%esp
 16d:	6a 0a                	push   $0xa
 16f:	68 63 25 00 00       	push   $0x2563
 174:	6a 01                	push   $0x1
 176:	e8 65 04 00 00       	call   5e0 <printf>
 17b:	89 f4                	mov    %esi,%esp
 17d:	eb d8                	jmp    157 <main+0x157>
    char* text_to_encode[argc-1];
 17f:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
 184:	e9 d6 fe ff ff       	jmp    5f <main+0x5f>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 189:	50                   	push   %eax
 18a:	50                   	push   %eax
 18b:	68 02 02 00 00       	push   $0x202
 190:	68 43 09 00 00       	push   $0x943
 195:	e8 09 03 00 00       	call   4a3 <open>
        if (fd <0){
 19a:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 19d:	89 c7                	mov    %eax,%edi
        if (fd <0){
 19f:	85 c0                	test   %eax,%eax
 1a1:	79 8d                	jns    130 <main+0x130>
            printf(1,"Unable to open or create file");
 1a3:	51                   	push   %ecx
 1a4:	51                   	push   %ecx
 1a5:	68 23 09 00 00       	push   $0x923
 1aa:	6a 01                	push   $0x1
 1ac:	e8 2f 04 00 00       	call   5e0 <printf>
            exit();
 1b1:	e8 ad 02 00 00       	call   463 <exit>
 1b6:	66 90                	xchg   %ax,%ax
 1b8:	66 90                	xchg   %ax,%ax
 1ba:	66 90                	xchg   %ax,%ax
 1bc:	66 90                	xchg   %ax,%ax
 1be:	66 90                	xchg   %ax,%ax

000001c0 <cesar_decode>:
void cesar_decode(char* text,int shift){
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
        text[i]=(c-shift);
 1c7:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
void cesar_decode(char* text,int shift){
 1cb:	56                   	push   %esi
 1cc:	53                   	push   %ebx
    for (int i=0;text[i]!='\0';i++)
 1cd:	0f b6 02             	movzbl (%edx),%eax
 1d0:	84 c0                	test   %al,%al
 1d2:	74 37                	je     20b <cesar_decode+0x4b>
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        text[i]=(c-shift);
 1d8:	89 fb                	mov    %edi,%ebx
 1da:	89 c1                	mov    %eax,%ecx
        if(  c>='a' && c<='z' && text[i]<'a')
 1dc:	8d 70 9f             	lea    -0x61(%eax),%esi
        text[i]=(c-shift);
 1df:	29 d9                	sub    %ebx,%ecx
        if(  c>='a' && c<='z' && text[i]<'a')
 1e1:	89 f3                	mov    %esi,%ebx
        text[i]=(c-shift);
 1e3:	88 0a                	mov    %cl,(%edx)
        if(  c>='a' && c<='z' && text[i]<'a')
 1e5:	80 fb 19             	cmp    $0x19,%bl
 1e8:	77 05                	ja     1ef <cesar_decode+0x2f>
 1ea:	80 f9 60             	cmp    $0x60,%cl
 1ed:	7e 0c                	jle    1fb <cesar_decode+0x3b>
         if( c<='Z' && c>='A' && text[i]<'A')
 1ef:	83 e8 41             	sub    $0x41,%eax
 1f2:	3c 19                	cmp    $0x19,%al
 1f4:	77 0a                	ja     200 <cesar_decode+0x40>
 1f6:	80 f9 40             	cmp    $0x40,%cl
 1f9:	7f 05                	jg     200 <cesar_decode+0x40>
        text[i]+=26;
 1fb:	83 c1 1a             	add    $0x1a,%ecx
 1fe:	88 0a                	mov    %cl,(%edx)
    for (int i=0;text[i]!='\0';i++)
 200:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 204:	83 c2 01             	add    $0x1,%edx
 207:	84 c0                	test   %al,%al
 209:	75 cd                	jne    1d8 <cesar_decode+0x18>
}
 20b:	5b                   	pop    %ebx
 20c:	5e                   	pop    %esi
 20d:	5f                   	pop    %edi
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    

00000210 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 210:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 211:	31 c0                	xor    %eax,%eax
{
 213:	89 e5                	mov    %esp,%ebp
 215:	53                   	push   %ebx
 216:	8b 4d 08             	mov    0x8(%ebp),%ecx
 219:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 220:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 224:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 227:	83 c0 01             	add    $0x1,%eax
 22a:	84 d2                	test   %dl,%dl
 22c:	75 f2                	jne    220 <strcpy+0x10>
    ;
  return os;
}
 22e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 231:	89 c8                	mov    %ecx,%eax
 233:	c9                   	leave  
 234:	c3                   	ret    
 235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 55 08             	mov    0x8(%ebp),%edx
 247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 24a:	0f b6 02             	movzbl (%edx),%eax
 24d:	84 c0                	test   %al,%al
 24f:	75 17                	jne    268 <strcmp+0x28>
 251:	eb 3a                	jmp    28d <strcmp+0x4d>
 253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 257:	90                   	nop
 258:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 25c:	83 c2 01             	add    $0x1,%edx
 25f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 262:	84 c0                	test   %al,%al
 264:	74 1a                	je     280 <strcmp+0x40>
    p++, q++;
 266:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 268:	0f b6 19             	movzbl (%ecx),%ebx
 26b:	38 c3                	cmp    %al,%bl
 26d:	74 e9                	je     258 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 26f:	29 d8                	sub    %ebx,%eax
}
 271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 274:	c9                   	leave  
 275:	c3                   	ret    
 276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 280:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 284:	31 c0                	xor    %eax,%eax
 286:	29 d8                	sub    %ebx,%eax
}
 288:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 28b:	c9                   	leave  
 28c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 28d:	0f b6 19             	movzbl (%ecx),%ebx
 290:	31 c0                	xor    %eax,%eax
 292:	eb db                	jmp    26f <strcmp+0x2f>
 294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop

000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2a6:	80 3a 00             	cmpb   $0x0,(%edx)
 2a9:	74 15                	je     2c0 <strlen+0x20>
 2ab:	31 c0                	xor    %eax,%eax
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
 2b0:	83 c0 01             	add    $0x1,%eax
 2b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2b7:	89 c1                	mov    %eax,%ecx
 2b9:	75 f5                	jne    2b0 <strlen+0x10>
    ;
  return n;
}
 2bb:	89 c8                	mov    %ecx,%eax
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    
 2bf:	90                   	nop
  for(n = 0; s[n]; n++)
 2c0:	31 c9                	xor    %ecx,%ecx
}
 2c2:	5d                   	pop    %ebp
 2c3:	89 c8                	mov    %ecx,%eax
 2c5:	c3                   	ret    
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi

000002d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2da:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dd:	89 d7                	mov    %edx,%edi
 2df:	fc                   	cld    
 2e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2e5:	89 d0                	mov    %edx,%eax
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <strchr>:

char*
strchr(const char *s, char c)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2fa:	0f b6 10             	movzbl (%eax),%edx
 2fd:	84 d2                	test   %dl,%dl
 2ff:	75 12                	jne    313 <strchr+0x23>
 301:	eb 1d                	jmp    320 <strchr+0x30>
 303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 307:	90                   	nop
 308:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 30c:	83 c0 01             	add    $0x1,%eax
 30f:	84 d2                	test   %dl,%dl
 311:	74 0d                	je     320 <strchr+0x30>
    if(*s == c)
 313:	38 d1                	cmp    %dl,%cl
 315:	75 f1                	jne    308 <strchr+0x18>
      return (char*)s;
  return 0;
}
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 320:	31 c0                	xor    %eax,%eax
}
 322:	5d                   	pop    %ebp
 323:	c3                   	ret    
 324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop

00000330 <gets>:

char*
gets(char *buf, int max)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 335:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 338:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 339:	31 db                	xor    %ebx,%ebx
{
 33b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 33e:	eb 27                	jmp    367 <gets+0x37>
    cc = read(0, &c, 1);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	6a 01                	push   $0x1
 345:	57                   	push   %edi
 346:	6a 00                	push   $0x0
 348:	e8 2e 01 00 00       	call   47b <read>
    if(cc < 1)
 34d:	83 c4 10             	add    $0x10,%esp
 350:	85 c0                	test   %eax,%eax
 352:	7e 1d                	jle    371 <gets+0x41>
      break;
    buf[i++] = c;
 354:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 358:	8b 55 08             	mov    0x8(%ebp),%edx
 35b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 35f:	3c 0a                	cmp    $0xa,%al
 361:	74 1d                	je     380 <gets+0x50>
 363:	3c 0d                	cmp    $0xd,%al
 365:	74 19                	je     380 <gets+0x50>
  for(i=0; i+1 < max; ){
 367:	89 de                	mov    %ebx,%esi
 369:	83 c3 01             	add    $0x1,%ebx
 36c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 36f:	7c cf                	jl     340 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 378:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37b:	5b                   	pop    %ebx
 37c:	5e                   	pop    %esi
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    
  buf[i] = '\0';
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	89 de                	mov    %ebx,%esi
 385:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 389:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38c:	5b                   	pop    %ebx
 38d:	5e                   	pop    %esi
 38e:	5f                   	pop    %edi
 38f:	5d                   	pop    %ebp
 390:	c3                   	ret    
 391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop

000003a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	56                   	push   %esi
 3a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a5:	83 ec 08             	sub    $0x8,%esp
 3a8:	6a 00                	push   $0x0
 3aa:	ff 75 08             	push   0x8(%ebp)
 3ad:	e8 f1 00 00 00       	call   4a3 <open>
  if(fd < 0)
 3b2:	83 c4 10             	add    $0x10,%esp
 3b5:	85 c0                	test   %eax,%eax
 3b7:	78 27                	js     3e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	ff 75 0c             	push   0xc(%ebp)
 3bf:	89 c3                	mov    %eax,%ebx
 3c1:	50                   	push   %eax
 3c2:	e8 f4 00 00 00       	call   4bb <fstat>
  close(fd);
 3c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ca:	89 c6                	mov    %eax,%esi
  close(fd);
 3cc:	e8 ba 00 00 00       	call   48b <close>
  return r;
 3d1:	83 c4 10             	add    $0x10,%esp
}
 3d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3d7:	89 f0                	mov    %esi,%eax
 3d9:	5b                   	pop    %ebx
 3da:	5e                   	pop    %esi
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3e5:	eb ed                	jmp    3d4 <stat+0x34>
 3e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f7:	0f be 02             	movsbl (%edx),%eax
 3fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 400:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 405:	77 1e                	ja     425 <atoi+0x35>
 407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 410:	83 c2 01             	add    $0x1,%edx
 413:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 416:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 41a:	0f be 02             	movsbl (%edx),%eax
 41d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 420:	80 fb 09             	cmp    $0x9,%bl
 423:	76 eb                	jbe    410 <atoi+0x20>
  return n;
}
 425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 428:	89 c8                	mov    %ecx,%eax
 42a:	c9                   	leave  
 42b:	c3                   	ret    
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	8b 45 10             	mov    0x10(%ebp),%eax
 437:	8b 55 08             	mov    0x8(%ebp),%edx
 43a:	56                   	push   %esi
 43b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43e:	85 c0                	test   %eax,%eax
 440:	7e 13                	jle    455 <memmove+0x25>
 442:	01 d0                	add    %edx,%eax
  dst = vdst;
 444:	89 d7                	mov    %edx,%edi
 446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 450:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 451:	39 f8                	cmp    %edi,%eax
 453:	75 fb                	jne    450 <memmove+0x20>
  return vdst;
}
 455:	5e                   	pop    %esi
 456:	89 d0                	mov    %edx,%eax
 458:	5f                   	pop    %edi
 459:	5d                   	pop    %ebp
 45a:	c3                   	ret    

0000045b <fork>:
    int $T_SYSCALL; \
    ret
// In usys.S


SYSCALL(fork)
 45b:	b8 01 00 00 00       	mov    $0x1,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <exit>:
SYSCALL(exit)
 463:	b8 02 00 00 00       	mov    $0x2,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <wait>:
SYSCALL(wait)
 46b:	b8 03 00 00 00       	mov    $0x3,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <pipe>:
SYSCALL(pipe)
 473:	b8 04 00 00 00       	mov    $0x4,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <read>:
SYSCALL(read)
 47b:	b8 05 00 00 00       	mov    $0x5,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <write>:
SYSCALL(write)
 483:	b8 10 00 00 00       	mov    $0x10,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <close>:
SYSCALL(close)
 48b:	b8 15 00 00 00       	mov    $0x15,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <kill>:
SYSCALL(kill)
 493:	b8 06 00 00 00       	mov    $0x6,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <exec>:
SYSCALL(exec)
 49b:	b8 07 00 00 00       	mov    $0x7,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <open>:
SYSCALL(open)
 4a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <mknod>:
SYSCALL(mknod)
 4ab:	b8 11 00 00 00       	mov    $0x11,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <unlink>:
SYSCALL(unlink)
 4b3:	b8 12 00 00 00       	mov    $0x12,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <fstat>:
SYSCALL(fstat)
 4bb:	b8 08 00 00 00       	mov    $0x8,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <link>:
SYSCALL(link)
 4c3:	b8 13 00 00 00       	mov    $0x13,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mkdir>:
SYSCALL(mkdir)
 4cb:	b8 14 00 00 00       	mov    $0x14,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <chdir>:
SYSCALL(chdir)
 4d3:	b8 09 00 00 00       	mov    $0x9,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <dup>:
SYSCALL(dup)
 4db:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getpid>:
SYSCALL(getpid)
 4e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <sbrk>:
SYSCALL(sbrk)
 4eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <sleep>:
SYSCALL(sleep)
 4f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <uptime>:
SYSCALL(uptime)
 4fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <move_file>:
SYSCALL(move_file)
 503:	b8 1a 00 00 00       	mov    $0x1a,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <sort_syscalls>:
SYSCALL(sort_syscalls)
 50b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <create_palindrom>:
SYSCALL(create_palindrom)
 513:	b8 16 00 00 00       	mov    $0x16,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <get_most_invoked_syscalls>:
SYSCALL(get_most_invoked_syscalls) 
 51b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    
 523:	66 90                	xchg   %ax,%ax
 525:	66 90                	xchg   %ax,%ax
 527:	66 90                	xchg   %ax,%ax
 529:	66 90                	xchg   %ax,%ax
 52b:	66 90                	xchg   %ax,%ax
 52d:	66 90                	xchg   %ax,%ax
 52f:	90                   	nop

00000530 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 3c             	sub    $0x3c,%esp
 539:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 53c:	89 d1                	mov    %edx,%ecx
{
 53e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 541:	85 d2                	test   %edx,%edx
 543:	0f 89 7f 00 00 00    	jns    5c8 <printint+0x98>
 549:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 54d:	74 79                	je     5c8 <printint+0x98>
    neg = 1;
 54f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 556:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 558:	31 db                	xor    %ebx,%ebx
 55a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 560:	89 c8                	mov    %ecx,%eax
 562:	31 d2                	xor    %edx,%edx
 564:	89 cf                	mov    %ecx,%edi
 566:	f7 75 c4             	divl   -0x3c(%ebp)
 569:	0f b6 92 b0 09 00 00 	movzbl 0x9b0(%edx),%edx
 570:	89 45 c0             	mov    %eax,-0x40(%ebp)
 573:	89 d8                	mov    %ebx,%eax
 575:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 578:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 57b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 57e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 581:	76 dd                	jbe    560 <printint+0x30>
  if(neg)
 583:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 586:	85 c9                	test   %ecx,%ecx
 588:	74 0c                	je     596 <printint+0x66>
    buf[i++] = '-';
 58a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 58f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 591:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 596:	8b 7d b8             	mov    -0x48(%ebp),%edi
 599:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 59d:	eb 07                	jmp    5a6 <printint+0x76>
 59f:	90                   	nop
    putc(fd, buf[i]);
 5a0:	0f b6 13             	movzbl (%ebx),%edx
 5a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5ac:	6a 01                	push   $0x1
 5ae:	56                   	push   %esi
 5af:	57                   	push   %edi
 5b0:	e8 ce fe ff ff       	call   483 <write>
  while(--i >= 0)
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	39 de                	cmp    %ebx,%esi
 5ba:	75 e4                	jne    5a0 <printint+0x70>
}
 5bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5e                   	pop    %esi
 5c1:	5f                   	pop    %edi
 5c2:	5d                   	pop    %ebp
 5c3:	c3                   	ret    
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5cf:	eb 87                	jmp    558 <printint+0x28>
 5d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 5ec:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 5ef:	0f b6 13             	movzbl (%ebx),%edx
 5f2:	84 d2                	test   %dl,%dl
 5f4:	74 6a                	je     660 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 5f6:	8d 45 10             	lea    0x10(%ebp),%eax
 5f9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5fc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5ff:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 601:	89 45 d0             	mov    %eax,-0x30(%ebp)
 604:	eb 36                	jmp    63c <printf+0x5c>
 606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
 610:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 613:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 618:	83 f8 25             	cmp    $0x25,%eax
 61b:	74 15                	je     632 <printf+0x52>
  write(fd, &c, 1);
 61d:	83 ec 04             	sub    $0x4,%esp
 620:	88 55 e7             	mov    %dl,-0x19(%ebp)
 623:	6a 01                	push   $0x1
 625:	57                   	push   %edi
 626:	56                   	push   %esi
 627:	e8 57 fe ff ff       	call   483 <write>
 62c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 62f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 632:	0f b6 13             	movzbl (%ebx),%edx
 635:	83 c3 01             	add    $0x1,%ebx
 638:	84 d2                	test   %dl,%dl
 63a:	74 24                	je     660 <printf+0x80>
    c = fmt[i] & 0xff;
 63c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 63f:	85 c9                	test   %ecx,%ecx
 641:	74 cd                	je     610 <printf+0x30>
      }
    } else if(state == '%'){
 643:	83 f9 25             	cmp    $0x25,%ecx
 646:	75 ea                	jne    632 <printf+0x52>
      if(c == 'd'){
 648:	83 f8 25             	cmp    $0x25,%eax
 64b:	0f 84 07 01 00 00    	je     758 <printf+0x178>
 651:	83 e8 63             	sub    $0x63,%eax
 654:	83 f8 15             	cmp    $0x15,%eax
 657:	77 17                	ja     670 <printf+0x90>
 659:	ff 24 85 58 09 00 00 	jmp    *0x958(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 660:	8d 65 f4             	lea    -0xc(%ebp),%esp
 663:	5b                   	pop    %ebx
 664:	5e                   	pop    %esi
 665:	5f                   	pop    %edi
 666:	5d                   	pop    %ebp
 667:	c3                   	ret    
 668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop
  write(fd, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
 673:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 676:	6a 01                	push   $0x1
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 67e:	e8 00 fe ff ff       	call   483 <write>
        putc(fd, c);
 683:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 687:	83 c4 0c             	add    $0xc,%esp
 68a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 68d:	6a 01                	push   $0x1
 68f:	57                   	push   %edi
 690:	56                   	push   %esi
 691:	e8 ed fd ff ff       	call   483 <write>
        putc(fd, c);
 696:	83 c4 10             	add    $0x10,%esp
      state = 0;
 699:	31 c9                	xor    %ecx,%ecx
 69b:	eb 95                	jmp    632 <printf+0x52>
 69d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6a0:	83 ec 0c             	sub    $0xc,%esp
 6a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6a8:	6a 00                	push   $0x0
 6aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	89 f0                	mov    %esi,%eax
 6b1:	e8 7a fe ff ff       	call   530 <printint>
        ap++;
 6b6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bd:	31 c9                	xor    %ecx,%ecx
 6bf:	e9 6e ff ff ff       	jmp    632 <printf+0x52>
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6cb:	8b 10                	mov    (%eax),%edx
        ap++;
 6cd:	83 c0 04             	add    $0x4,%eax
 6d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6d3:	85 d2                	test   %edx,%edx
 6d5:	0f 84 8d 00 00 00    	je     768 <printf+0x188>
        while(*s != 0){
 6db:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 6de:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 6e0:	84 c0                	test   %al,%al
 6e2:	0f 84 4a ff ff ff    	je     632 <printf+0x52>
 6e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6eb:	89 d3                	mov    %edx,%ebx
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6f3:	83 c3 01             	add    $0x1,%ebx
 6f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f9:	6a 01                	push   $0x1
 6fb:	57                   	push   %edi
 6fc:	56                   	push   %esi
 6fd:	e8 81 fd ff ff       	call   483 <write>
        while(*s != 0){
 702:	0f b6 03             	movzbl (%ebx),%eax
 705:	83 c4 10             	add    $0x10,%esp
 708:	84 c0                	test   %al,%al
 70a:	75 e4                	jne    6f0 <printf+0x110>
      state = 0;
 70c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 70f:	31 c9                	xor    %ecx,%ecx
 711:	e9 1c ff ff ff       	jmp    632 <printf+0x52>
 716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	e9 7b ff ff ff       	jmp    6aa <printf+0xca>
 72f:	90                   	nop
        putc(fd, *ap);
 730:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 736:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 738:	6a 01                	push   $0x1
 73a:	57                   	push   %edi
 73b:	56                   	push   %esi
        putc(fd, *ap);
 73c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 73f:	e8 3f fd ff ff       	call   483 <write>
        ap++;
 744:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 748:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74b:	31 c9                	xor    %ecx,%ecx
 74d:	e9 e0 fe ff ff       	jmp    632 <printf+0x52>
 752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 758:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 75b:	83 ec 04             	sub    $0x4,%esp
 75e:	e9 2a ff ff ff       	jmp    68d <printf+0xad>
 763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 767:	90                   	nop
          s = "(null)";
 768:	ba 4e 09 00 00       	mov    $0x94e,%edx
        while(*s != 0){
 76d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 770:	b8 28 00 00 00       	mov    $0x28,%eax
 775:	89 d3                	mov    %edx,%ebx
 777:	e9 74 ff ff ff       	jmp    6f0 <printf+0x110>
 77c:	66 90                	xchg   %ax,%ax
 77e:	66 90                	xchg   %ax,%ax

00000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 781:	a1 90 0c 00 00       	mov    0xc90,%eax
{
 786:	89 e5                	mov    %esp,%ebp
 788:	57                   	push   %edi
 789:	56                   	push   %esi
 78a:	53                   	push   %ebx
 78b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 78e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 798:	89 c2                	mov    %eax,%edx
 79a:	8b 00                	mov    (%eax),%eax
 79c:	39 ca                	cmp    %ecx,%edx
 79e:	73 30                	jae    7d0 <free+0x50>
 7a0:	39 c1                	cmp    %eax,%ecx
 7a2:	72 04                	jb     7a8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	39 c2                	cmp    %eax,%edx
 7a6:	72 f0                	jb     798 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ae:	39 f8                	cmp    %edi,%eax
 7b0:	74 30                	je     7e2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b5:	8b 42 04             	mov    0x4(%edx),%eax
 7b8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7bb:	39 f1                	cmp    %esi,%ecx
 7bd:	74 3a                	je     7f9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7bf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7c1:	5b                   	pop    %ebx
  freep = p;
 7c2:	89 15 90 0c 00 00    	mov    %edx,0xc90
}
 7c8:	5e                   	pop    %esi
 7c9:	5f                   	pop    %edi
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret    
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	39 c2                	cmp    %eax,%edx
 7d2:	72 c4                	jb     798 <free+0x18>
 7d4:	39 c1                	cmp    %eax,%ecx
 7d6:	73 c0                	jae    798 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 7d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7de:	39 f8                	cmp    %edi,%eax
 7e0:	75 d0                	jne    7b2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 7e2:	03 70 04             	add    0x4(%eax),%esi
 7e5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	8b 02                	mov    (%edx),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ef:	8b 42 04             	mov    0x4(%edx),%eax
 7f2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7f5:	39 f1                	cmp    %esi,%ecx
 7f7:	75 c6                	jne    7bf <free+0x3f>
    p->s.size += bp->s.size;
 7f9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 7fc:	89 15 90 0c 00 00    	mov    %edx,0xc90
    p->s.size += bp->s.size;
 802:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 805:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 808:	89 0a                	mov    %ecx,(%edx)
}
 80a:	5b                   	pop    %ebx
 80b:	5e                   	pop    %esi
 80c:	5f                   	pop    %edi
 80d:	5d                   	pop    %ebp
 80e:	c3                   	ret    
 80f:	90                   	nop

00000810 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	57                   	push   %edi
 814:	56                   	push   %esi
 815:	53                   	push   %ebx
 816:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 819:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 81c:	8b 3d 90 0c 00 00    	mov    0xc90,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	8d 70 07             	lea    0x7(%eax),%esi
 825:	c1 ee 03             	shr    $0x3,%esi
 828:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 82b:	85 ff                	test   %edi,%edi
 82d:	0f 84 9d 00 00 00    	je     8d0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 833:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 835:	8b 4a 04             	mov    0x4(%edx),%ecx
 838:	39 f1                	cmp    %esi,%ecx
 83a:	73 6a                	jae    8a6 <malloc+0x96>
 83c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 841:	39 de                	cmp    %ebx,%esi
 843:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 846:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 84d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 850:	eb 17                	jmp    869 <malloc+0x59>
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 85a:	8b 48 04             	mov    0x4(%eax),%ecx
 85d:	39 f1                	cmp    %esi,%ecx
 85f:	73 4f                	jae    8b0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 861:	8b 3d 90 0c 00 00    	mov    0xc90,%edi
 867:	89 c2                	mov    %eax,%edx
 869:	39 d7                	cmp    %edx,%edi
 86b:	75 eb                	jne    858 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 86d:	83 ec 0c             	sub    $0xc,%esp
 870:	ff 75 e4             	push   -0x1c(%ebp)
 873:	e8 73 fc ff ff       	call   4eb <sbrk>
  if(p == (char*)-1)
 878:	83 c4 10             	add    $0x10,%esp
 87b:	83 f8 ff             	cmp    $0xffffffff,%eax
 87e:	74 1c                	je     89c <malloc+0x8c>
  hp->s.size = nu;
 880:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 883:	83 ec 0c             	sub    $0xc,%esp
 886:	83 c0 08             	add    $0x8,%eax
 889:	50                   	push   %eax
 88a:	e8 f1 fe ff ff       	call   780 <free>
  return freep;
 88f:	8b 15 90 0c 00 00    	mov    0xc90,%edx
      if((p = morecore(nunits)) == 0)
 895:	83 c4 10             	add    $0x10,%esp
 898:	85 d2                	test   %edx,%edx
 89a:	75 bc                	jne    858 <malloc+0x48>
        return 0;
  }
}
 89c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 89f:	31 c0                	xor    %eax,%eax
}
 8a1:	5b                   	pop    %ebx
 8a2:	5e                   	pop    %esi
 8a3:	5f                   	pop    %edi
 8a4:	5d                   	pop    %ebp
 8a5:	c3                   	ret    
    if(p->s.size >= nunits){
 8a6:	89 d0                	mov    %edx,%eax
 8a8:	89 fa                	mov    %edi,%edx
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8b0:	39 ce                	cmp    %ecx,%esi
 8b2:	74 4c                	je     900 <malloc+0xf0>
        p->s.size -= nunits;
 8b4:	29 f1                	sub    %esi,%ecx
 8b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8bc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 8bf:	89 15 90 0c 00 00    	mov    %edx,0xc90
}
 8c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8c8:	83 c0 08             	add    $0x8,%eax
}
 8cb:	5b                   	pop    %ebx
 8cc:	5e                   	pop    %esi
 8cd:	5f                   	pop    %edi
 8ce:	5d                   	pop    %ebp
 8cf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 8d0:	c7 05 90 0c 00 00 94 	movl   $0xc94,0xc90
 8d7:	0c 00 00 
    base.s.size = 0;
 8da:	bf 94 0c 00 00       	mov    $0xc94,%edi
    base.s.ptr = freep = prevp = &base;
 8df:	c7 05 94 0c 00 00 94 	movl   $0xc94,0xc94
 8e6:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 8eb:	c7 05 98 0c 00 00 00 	movl   $0x0,0xc98
 8f2:	00 00 00 
    if(p->s.size >= nunits){
 8f5:	e9 42 ff ff ff       	jmp    83c <malloc+0x2c>
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 900:	8b 08                	mov    (%eax),%ecx
 902:	89 0a                	mov    %ecx,(%edx)
 904:	eb b9                	jmp    8bf <malloc+0xaf>
