
_decode:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
       // printf(1,c);

        
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
  59:	0f 85 19 01 00 00    	jne    178 <main+0x178>
    if(argc <2){
  5f:	83 ef 01             	sub    $0x1,%edi
    char* text_to_encode[argc-1];
  62:	89 e6                	mov    %esp,%esi
    if(argc <2){
  64:	0f 8e f9 00 00 00    	jle    163 <main+0x163>
  6a:	8d 41 04             	lea    0x4(%ecx),%eax
  6d:	89 f7                	mov    %esi,%edi
  6f:	8d 4c 11 04          	lea    0x4(%ecx,%edx,1),%ecx
  73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  77:	90                   	nop

    }
    else{
        for (int i=1;i<argc;i++){
            //printf(1,argv[i]);
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
            //printf(1,'\n');
        }
    }
         printf(1,'%c','\n');
  87:	83 ec 04             	sub    $0x4,%esp
  8a:	6a 0a                	push   $0xa
  8c:	68 63 25 00 00       	push   $0x2563
  91:	6a 01                	push   $0x1
  93:	e8 f8 04 00 00       	call   590 <printf>
    for (int i=0;i<argc-1;i++){
  98:	83 c4 10             	add    $0x10,%esp
  9b:	85 db                	test   %ebx,%ebx
  9d:	0f 8e 93 00 00 00    	jle    136 <main+0x136>
  a3:	31 ff                	xor    %edi,%edi
  a5:	8d 76 00             	lea    0x0(%esi),%esi
        //printf(1,text_to_encode[i]);
        //printf(1,"functions: \n");
        cesar_encode(text_to_encode[i],1);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	6a 01                	push   $0x1
  ad:	ff 34 be             	push   (%esi,%edi,4)
    for (int i=0;i<argc-1;i++){
  b0:	83 c7 01             	add    $0x1,%edi
        cesar_encode(text_to_encode[i],1);
  b3:	e8 d8 00 00 00       	call   190 <cesar_encode>
    for (int i=0;i<argc-1;i++){
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	39 fb                	cmp    %edi,%ebx
  bd:	75 e9                	jne    a8 <main+0xa8>
       // printf(1,text_to_encode[i]);
       // printf(1,'%c','\n');
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 02 02 00 00       	push   $0x202
  c7:	68 f1 08 00 00       	push   $0x8f1
  cc:	e8 a2 03 00 00       	call   473 <open>
       // printf(1,"hi \n");
        char * space=" ";
        if (fd <0){
  d1:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
  d4:	89 c7                	mov    %eax,%edi
        if (fd <0){
  d6:	85 c0                	test   %eax,%eax
  d8:	78 76                	js     150 <main+0x150>
  da:	89 75 e0             	mov    %esi,-0x20(%ebp)
  dd:	31 d2                	xor    %edx,%edx
  df:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  e2:	89 d3                	mov    %edx,%ebx
  e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
  e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  eb:	83 ec 0c             	sub    $0xc,%esp
  ee:	8b 34 98             	mov    (%eax,%ebx,4),%esi
            for (int i=0;i<argc-1;i++){
  f1:	83 c3 01             	add    $0x1,%ebx
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
  f4:	56                   	push   %esi
  f5:	e8 76 01 00 00       	call   270 <strlen>
  fa:	83 c4 0c             	add    $0xc,%esp
  fd:	50                   	push   %eax
  fe:	56                   	push   %esi
  ff:	57                   	push   %edi
 100:	e8 4e 03 00 00       	call   453 <write>
                write(fd,space,strlen(space));
 105:	c7 04 24 ef 08 00 00 	movl   $0x8ef,(%esp)
 10c:	e8 5f 01 00 00       	call   270 <strlen>
 111:	83 c4 0c             	add    $0xc,%esp
 114:	50                   	push   %eax
 115:	68 ef 08 00 00       	push   $0x8ef
 11a:	57                   	push   %edi
 11b:	e8 33 03 00 00       	call   453 <write>
            for (int i=0;i<argc-1;i++){
 120:	83 c4 10             	add    $0x10,%esp
 123:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
 126:	75 c0                	jne    e8 <main+0xe8>

            //printf(1,"hi2");


        }
        close(fd);
 128:	83 ec 0c             	sub    $0xc,%esp
 12b:	57                   	push   %edi
 12c:	e8 2a 03 00 00       	call   45b <close>
    exit();
 131:	e8 fd 02 00 00       	call   433 <exit>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 136:	50                   	push   %eax
 137:	50                   	push   %eax
 138:	68 02 02 00 00       	push   $0x202
 13d:	68 f1 08 00 00       	push   $0x8f1
 142:	e8 2c 03 00 00       	call   473 <open>
        if (fd <0){
 147:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 14a:	89 c7                	mov    %eax,%edi
        if (fd <0){
 14c:	85 c0                	test   %eax,%eax
 14e:	79 d8                	jns    128 <main+0x128>
            printf(1,"Unable to open or create file");
 150:	52                   	push   %edx
 151:	52                   	push   %edx
 152:	68 d1 08 00 00       	push   $0x8d1
 157:	6a 01                	push   $0x1
 159:	e8 32 04 00 00       	call   590 <printf>
            exit();
 15e:	e8 d0 02 00 00       	call   433 <exit>
        printf(1,"no text to encode passed");
 163:	51                   	push   %ecx
 164:	51                   	push   %ecx
 165:	68 b8 08 00 00       	push   $0x8b8
 16a:	6a 01                	push   $0x1
 16c:	e8 1f 04 00 00       	call   590 <printf>
 171:	89 f4                	mov    %esi,%esp
 173:	e9 0f ff ff ff       	jmp    87 <main+0x87>
    char* text_to_encode[argc-1];
 178:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
 17d:	e9 dd fe ff ff       	jmp    5f <main+0x5f>
 182:	66 90                	xchg   %ax,%ax
 184:	66 90                	xchg   %ax,%ax
 186:	66 90                	xchg   %ax,%ax
 188:	66 90                	xchg   %ax,%ax
 18a:	66 90                	xchg   %ax,%ax
 18c:	66 90                	xchg   %ax,%ax
 18e:	66 90                	xchg   %ax,%ax

00000190 <cesar_encode>:
void cesar_encode(char* text,int shift){
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
        text[i]=(c-shift);
 197:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
void cesar_encode(char* text,int shift){
 19b:	56                   	push   %esi
 19c:	53                   	push   %ebx
    for (int i=0;text[i]!='\0';i++)
 19d:	0f b6 02             	movzbl (%edx),%eax
 1a0:	84 c0                	test   %al,%al
 1a2:	74 37                	je     1db <cesar_encode+0x4b>
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        text[i]=(c-shift);
 1a8:	89 fb                	mov    %edi,%ebx
 1aa:	89 c1                	mov    %eax,%ecx
        if(  c>='a' && c<='z' && text[i]<'a')
 1ac:	8d 70 9f             	lea    -0x61(%eax),%esi
        text[i]=(c-shift);
 1af:	29 d9                	sub    %ebx,%ecx
        if(  c>='a' && c<='z' && text[i]<'a')
 1b1:	89 f3                	mov    %esi,%ebx
        text[i]=(c-shift);
 1b3:	88 0a                	mov    %cl,(%edx)
        if(  c>='a' && c<='z' && text[i]<'a')
 1b5:	80 fb 19             	cmp    $0x19,%bl
 1b8:	77 05                	ja     1bf <cesar_encode+0x2f>
 1ba:	80 f9 60             	cmp    $0x60,%cl
 1bd:	7e 0c                	jle    1cb <cesar_encode+0x3b>
         if( c<='Z' && c>='A' && text[i]<'A')
 1bf:	83 e8 41             	sub    $0x41,%eax
 1c2:	3c 19                	cmp    $0x19,%al
 1c4:	77 0a                	ja     1d0 <cesar_encode+0x40>
 1c6:	80 f9 40             	cmp    $0x40,%cl
 1c9:	7f 05                	jg     1d0 <cesar_encode+0x40>
        text[i]+=26;
 1cb:	83 c1 1a             	add    $0x1a,%ecx
 1ce:	88 0a                	mov    %cl,(%edx)
    for (int i=0;text[i]!='\0';i++)
 1d0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 1d4:	83 c2 01             	add    $0x1,%edx
 1d7:	84 c0                	test   %al,%al
 1d9:	75 cd                	jne    1a8 <cesar_encode+0x18>
}
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5f                   	pop    %edi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    

000001e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1e0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e1:	31 c0                	xor    %eax,%eax
{
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	53                   	push   %ebx
 1e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1f7:	83 c0 01             	add    $0x1,%eax
 1fa:	84 d2                	test   %dl,%dl
 1fc:	75 f2                	jne    1f0 <strcpy+0x10>
    ;
  return os;
}
 1fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 201:	89 c8                	mov    %ecx,%eax
 203:	c9                   	leave  
 204:	c3                   	ret    
 205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
 217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 21a:	0f b6 02             	movzbl (%edx),%eax
 21d:	84 c0                	test   %al,%al
 21f:	75 17                	jne    238 <strcmp+0x28>
 221:	eb 3a                	jmp    25d <strcmp+0x4d>
 223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 227:	90                   	nop
 228:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 22c:	83 c2 01             	add    $0x1,%edx
 22f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 232:	84 c0                	test   %al,%al
 234:	74 1a                	je     250 <strcmp+0x40>
    p++, q++;
 236:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 238:	0f b6 19             	movzbl (%ecx),%ebx
 23b:	38 c3                	cmp    %al,%bl
 23d:	74 e9                	je     228 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 23f:	29 d8                	sub    %ebx,%eax
}
 241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 244:	c9                   	leave  
 245:	c3                   	ret    
 246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 250:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 254:	31 c0                	xor    %eax,%eax
 256:	29 d8                	sub    %ebx,%eax
}
 258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 25b:	c9                   	leave  
 25c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 25d:	0f b6 19             	movzbl (%ecx),%ebx
 260:	31 c0                	xor    %eax,%eax
 262:	eb db                	jmp    23f <strcmp+0x2f>
 264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 26f:	90                   	nop

00000270 <strlen>:

uint
strlen(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 276:	80 3a 00             	cmpb   $0x0,(%edx)
 279:	74 15                	je     290 <strlen+0x20>
 27b:	31 c0                	xor    %eax,%eax
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	83 c0 01             	add    $0x1,%eax
 283:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 287:	89 c1                	mov    %eax,%ecx
 289:	75 f5                	jne    280 <strlen+0x10>
    ;
  return n;
}
 28b:	89 c8                	mov    %ecx,%eax
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    
 28f:	90                   	nop
  for(n = 0; s[n]; n++)
 290:	31 c9                	xor    %ecx,%ecx
}
 292:	5d                   	pop    %ebp
 293:	89 c8                	mov    %ecx,%eax
 295:	c3                   	ret    
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi

000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 d7                	mov    %edx,%edi
 2af:	fc                   	cld    
 2b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2b5:	89 d0                	mov    %edx,%eax
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ca:	0f b6 10             	movzbl (%eax),%edx
 2cd:	84 d2                	test   %dl,%dl
 2cf:	75 12                	jne    2e3 <strchr+0x23>
 2d1:	eb 1d                	jmp    2f0 <strchr+0x30>
 2d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d7:	90                   	nop
 2d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2dc:	83 c0 01             	add    $0x1,%eax
 2df:	84 d2                	test   %dl,%dl
 2e1:	74 0d                	je     2f0 <strchr+0x30>
    if(*s == c)
 2e3:	38 d1                	cmp    %dl,%cl
 2e5:	75 f1                	jne    2d8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2f0:	31 c0                	xor    %eax,%eax
}
 2f2:	5d                   	pop    %ebp
 2f3:	c3                   	ret    
 2f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 305:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 308:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 309:	31 db                	xor    %ebx,%ebx
{
 30b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 30e:	eb 27                	jmp    337 <gets+0x37>
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	6a 01                	push   $0x1
 315:	57                   	push   %edi
 316:	6a 00                	push   $0x0
 318:	e8 2e 01 00 00       	call   44b <read>
    if(cc < 1)
 31d:	83 c4 10             	add    $0x10,%esp
 320:	85 c0                	test   %eax,%eax
 322:	7e 1d                	jle    341 <gets+0x41>
      break;
    buf[i++] = c;
 324:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 328:	8b 55 08             	mov    0x8(%ebp),%edx
 32b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 32f:	3c 0a                	cmp    $0xa,%al
 331:	74 1d                	je     350 <gets+0x50>
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 19                	je     350 <gets+0x50>
  for(i=0; i+1 < max; ){
 337:	89 de                	mov    %ebx,%esi
 339:	83 c3 01             	add    $0x1,%ebx
 33c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 33f:	7c cf                	jl     310 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 348:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34b:	5b                   	pop    %ebx
 34c:	5e                   	pop    %esi
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    
  buf[i] = '\0';
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	89 de                	mov    %ebx,%esi
 355:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 359:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35c:	5b                   	pop    %ebx
 35d:	5e                   	pop    %esi
 35e:	5f                   	pop    %edi
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
 361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36f:	90                   	nop

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 375:	83 ec 08             	sub    $0x8,%esp
 378:	6a 00                	push   $0x0
 37a:	ff 75 08             	push   0x8(%ebp)
 37d:	e8 f1 00 00 00       	call   473 <open>
  if(fd < 0)
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	78 27                	js     3b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	push   0xc(%ebp)
 38f:	89 c3                	mov    %eax,%ebx
 391:	50                   	push   %eax
 392:	e8 f4 00 00 00       	call   48b <fstat>
  close(fd);
 397:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39a:	89 c6                	mov    %eax,%esi
  close(fd);
 39c:	e8 ba 00 00 00       	call   45b <close>
  return r;
 3a1:	83 c4 10             	add    $0x10,%esp
}
 3a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a7:	89 f0                	mov    %esi,%eax
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3b5:	eb ed                	jmp    3a4 <stat+0x34>
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	0f be 02             	movsbl (%edx),%eax
 3ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3d5:	77 1e                	ja     3f5 <atoi+0x35>
 3d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3de:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ea:	0f be 02             	movsbl (%edx),%eax
 3ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f8:	89 c8                	mov    %ecx,%eax
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 45 10             	mov    0x10(%ebp),%eax
 407:	8b 55 08             	mov    0x8(%ebp),%edx
 40a:	56                   	push   %esi
 40b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40e:	85 c0                	test   %eax,%eax
 410:	7e 13                	jle    425 <memmove+0x25>
 412:	01 d0                	add    %edx,%eax
  dst = vdst;
 414:	89 d7                	mov    %edx,%edi
 416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 420:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 421:	39 f8                	cmp    %edi,%eax
 423:	75 fb                	jne    420 <memmove+0x20>
  return vdst;
}
 425:	5e                   	pop    %esi
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    
 4d3:	66 90                	xchg   %ax,%ax
 4d5:	66 90                	xchg   %ax,%ax
 4d7:	66 90                	xchg   %ax,%ax
 4d9:	66 90                	xchg   %ax,%ax
 4db:	66 90                	xchg   %ax,%ax
 4dd:	66 90                	xchg   %ax,%ax
 4df:	90                   	nop

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 3c             	sub    $0x3c,%esp
 4e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4ec:	89 d1                	mov    %edx,%ecx
{
 4ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4f1:	85 d2                	test   %edx,%edx
 4f3:	0f 89 7f 00 00 00    	jns    578 <printint+0x98>
 4f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4fd:	74 79                	je     578 <printint+0x98>
    neg = 1;
 4ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 506:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 508:	31 db                	xor    %ebx,%ebx
 50a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 510:	89 c8                	mov    %ecx,%eax
 512:	31 d2                	xor    %edx,%edx
 514:	89 cf                	mov    %ecx,%edi
 516:	f7 75 c4             	divl   -0x3c(%ebp)
 519:	0f b6 92 5c 09 00 00 	movzbl 0x95c(%edx),%edx
 520:	89 45 c0             	mov    %eax,-0x40(%ebp)
 523:	89 d8                	mov    %ebx,%eax
 525:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 528:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 52b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 52e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 531:	76 dd                	jbe    510 <printint+0x30>
  if(neg)
 533:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 536:	85 c9                	test   %ecx,%ecx
 538:	74 0c                	je     546 <printint+0x66>
    buf[i++] = '-';
 53a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 53f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 541:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 546:	8b 7d b8             	mov    -0x48(%ebp),%edi
 549:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 54d:	eb 07                	jmp    556 <printint+0x76>
 54f:	90                   	nop
    putc(fd, buf[i]);
 550:	0f b6 13             	movzbl (%ebx),%edx
 553:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 556:	83 ec 04             	sub    $0x4,%esp
 559:	88 55 d7             	mov    %dl,-0x29(%ebp)
 55c:	6a 01                	push   $0x1
 55e:	56                   	push   %esi
 55f:	57                   	push   %edi
 560:	e8 ee fe ff ff       	call   453 <write>
  while(--i >= 0)
 565:	83 c4 10             	add    $0x10,%esp
 568:	39 de                	cmp    %ebx,%esi
 56a:	75 e4                	jne    550 <printint+0x70>
}
 56c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56f:	5b                   	pop    %ebx
 570:	5e                   	pop    %esi
 571:	5f                   	pop    %edi
 572:	5d                   	pop    %ebp
 573:	c3                   	ret    
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 578:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 57f:	eb 87                	jmp    508 <printint+0x28>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop

00000590 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 59c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 59f:	0f b6 13             	movzbl (%ebx),%edx
 5a2:	84 d2                	test   %dl,%dl
 5a4:	74 6a                	je     610 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 5a6:	8d 45 10             	lea    0x10(%ebp),%eax
 5a9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5ac:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5af:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 5b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5b4:	eb 36                	jmp    5ec <printf+0x5c>
 5b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5c3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 5c8:	83 f8 25             	cmp    $0x25,%eax
 5cb:	74 15                	je     5e2 <printf+0x52>
  write(fd, &c, 1);
 5cd:	83 ec 04             	sub    $0x4,%esp
 5d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5d3:	6a 01                	push   $0x1
 5d5:	57                   	push   %edi
 5d6:	56                   	push   %esi
 5d7:	e8 77 fe ff ff       	call   453 <write>
 5dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 5df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5e2:	0f b6 13             	movzbl (%ebx),%edx
 5e5:	83 c3 01             	add    $0x1,%ebx
 5e8:	84 d2                	test   %dl,%dl
 5ea:	74 24                	je     610 <printf+0x80>
    c = fmt[i] & 0xff;
 5ec:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 5ef:	85 c9                	test   %ecx,%ecx
 5f1:	74 cd                	je     5c0 <printf+0x30>
      }
    } else if(state == '%'){
 5f3:	83 f9 25             	cmp    $0x25,%ecx
 5f6:	75 ea                	jne    5e2 <printf+0x52>
      if(c == 'd'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	0f 84 07 01 00 00    	je     708 <printf+0x178>
 601:	83 e8 63             	sub    $0x63,%eax
 604:	83 f8 15             	cmp    $0x15,%eax
 607:	77 17                	ja     620 <printf+0x90>
 609:	ff 24 85 04 09 00 00 	jmp    *0x904(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 610:	8d 65 f4             	lea    -0xc(%ebp),%esp
 613:	5b                   	pop    %ebx
 614:	5e                   	pop    %esi
 615:	5f                   	pop    %edi
 616:	5d                   	pop    %ebp
 617:	c3                   	ret    
 618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 626:	6a 01                	push   $0x1
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 62e:	e8 20 fe ff ff       	call   453 <write>
        putc(fd, c);
 633:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 637:	83 c4 0c             	add    $0xc,%esp
 63a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 63d:	6a 01                	push   $0x1
 63f:	57                   	push   %edi
 640:	56                   	push   %esi
 641:	e8 0d fe ff ff       	call   453 <write>
        putc(fd, c);
 646:	83 c4 10             	add    $0x10,%esp
      state = 0;
 649:	31 c9                	xor    %ecx,%ecx
 64b:	eb 95                	jmp    5e2 <printf+0x52>
 64d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 650:	83 ec 0c             	sub    $0xc,%esp
 653:	b9 10 00 00 00       	mov    $0x10,%ecx
 658:	6a 00                	push   $0x0
 65a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 65d:	8b 10                	mov    (%eax),%edx
 65f:	89 f0                	mov    %esi,%eax
 661:	e8 7a fe ff ff       	call   4e0 <printint>
        ap++;
 666:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 66a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66d:	31 c9                	xor    %ecx,%ecx
 66f:	e9 6e ff ff ff       	jmp    5e2 <printf+0x52>
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 678:	8b 45 d0             	mov    -0x30(%ebp),%eax
 67b:	8b 10                	mov    (%eax),%edx
        ap++;
 67d:	83 c0 04             	add    $0x4,%eax
 680:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 683:	85 d2                	test   %edx,%edx
 685:	0f 84 8d 00 00 00    	je     718 <printf+0x188>
        while(*s != 0){
 68b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 68e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 690:	84 c0                	test   %al,%al
 692:	0f 84 4a ff ff ff    	je     5e2 <printf+0x52>
 698:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 69b:	89 d3                	mov    %edx,%ebx
 69d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6a3:	83 c3 01             	add    $0x1,%ebx
 6a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6a9:	6a 01                	push   $0x1
 6ab:	57                   	push   %edi
 6ac:	56                   	push   %esi
 6ad:	e8 a1 fd ff ff       	call   453 <write>
        while(*s != 0){
 6b2:	0f b6 03             	movzbl (%ebx),%eax
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	84 c0                	test   %al,%al
 6ba:	75 e4                	jne    6a0 <printf+0x110>
      state = 0;
 6bc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 6bf:	31 c9                	xor    %ecx,%ecx
 6c1:	e9 1c ff ff ff       	jmp    5e2 <printf+0x52>
 6c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d8:	6a 01                	push   $0x1
 6da:	e9 7b ff ff ff       	jmp    65a <printf+0xca>
 6df:	90                   	nop
        putc(fd, *ap);
 6e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6e6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
 6ea:	57                   	push   %edi
 6eb:	56                   	push   %esi
        putc(fd, *ap);
 6ec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6ef:	e8 5f fd ff ff       	call   453 <write>
        ap++;
 6f4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fb:	31 c9                	xor    %ecx,%ecx
 6fd:	e9 e0 fe ff ff       	jmp    5e2 <printf+0x52>
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 708:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 70b:	83 ec 04             	sub    $0x4,%esp
 70e:	e9 2a ff ff ff       	jmp    63d <printf+0xad>
 713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 717:	90                   	nop
          s = "(null)";
 718:	ba fc 08 00 00       	mov    $0x8fc,%edx
        while(*s != 0){
 71d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 720:	b8 28 00 00 00       	mov    $0x28,%eax
 725:	89 d3                	mov    %edx,%ebx
 727:	e9 74 ff ff ff       	jmp    6a0 <printf+0x110>
 72c:	66 90                	xchg   %ax,%ax
 72e:	66 90                	xchg   %ax,%ax

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 3c 0c 00 00       	mov    0xc3c,%eax
{
 736:	89 e5                	mov    %esp,%ebp
 738:	57                   	push   %edi
 739:	56                   	push   %esi
 73a:	53                   	push   %ebx
 73b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 73e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	89 c2                	mov    %eax,%edx
 74a:	8b 00                	mov    (%eax),%eax
 74c:	39 ca                	cmp    %ecx,%edx
 74e:	73 30                	jae    780 <free+0x50>
 750:	39 c1                	cmp    %eax,%ecx
 752:	72 04                	jb     758 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	39 c2                	cmp    %eax,%edx
 756:	72 f0                	jb     748 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 f8                	cmp    %edi,%eax
 760:	74 30                	je     792 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 765:	8b 42 04             	mov    0x4(%edx),%eax
 768:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 76b:	39 f1                	cmp    %esi,%ecx
 76d:	74 3a                	je     7a9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 76f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 771:	5b                   	pop    %ebx
  freep = p;
 772:	89 15 3c 0c 00 00    	mov    %edx,0xc3c
}
 778:	5e                   	pop    %esi
 779:	5f                   	pop    %edi
 77a:	5d                   	pop    %ebp
 77b:	c3                   	ret    
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 c2                	cmp    %eax,%edx
 782:	72 c4                	jb     748 <free+0x18>
 784:	39 c1                	cmp    %eax,%ecx
 786:	73 c0                	jae    748 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 788:	8b 73 fc             	mov    -0x4(%ebx),%esi
 78b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 78e:	39 f8                	cmp    %edi,%eax
 790:	75 d0                	jne    762 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 792:	03 70 04             	add    0x4(%eax),%esi
 795:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	8b 02                	mov    (%edx),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 79f:	8b 42 04             	mov    0x4(%edx),%eax
 7a2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7a5:	39 f1                	cmp    %esi,%ecx
 7a7:	75 c6                	jne    76f <free+0x3f>
    p->s.size += bp->s.size;
 7a9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 7ac:	89 15 3c 0c 00 00    	mov    %edx,0xc3c
    p->s.size += bp->s.size;
 7b2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7b5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7b8:	89 0a                	mov    %ecx,(%edx)
}
 7ba:	5b                   	pop    %ebx
 7bb:	5e                   	pop    %esi
 7bc:	5f                   	pop    %edi
 7bd:	5d                   	pop    %ebp
 7be:	c3                   	ret    
 7bf:	90                   	nop

000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7cc:	8b 3d 3c 0c 00 00    	mov    0xc3c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8d 70 07             	lea    0x7(%eax),%esi
 7d5:	c1 ee 03             	shr    $0x3,%esi
 7d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7db:	85 ff                	test   %edi,%edi
 7dd:	0f 84 9d 00 00 00    	je     880 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7e8:	39 f1                	cmp    %esi,%ecx
 7ea:	73 6a                	jae    856 <malloc+0x96>
 7ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7f1:	39 de                	cmp    %ebx,%esi
 7f3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7f6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 800:	eb 17                	jmp    819 <malloc+0x59>
 802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 80a:	8b 48 04             	mov    0x4(%eax),%ecx
 80d:	39 f1                	cmp    %esi,%ecx
 80f:	73 4f                	jae    860 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 811:	8b 3d 3c 0c 00 00    	mov    0xc3c,%edi
 817:	89 c2                	mov    %eax,%edx
 819:	39 d7                	cmp    %edx,%edi
 81b:	75 eb                	jne    808 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	ff 75 e4             	push   -0x1c(%ebp)
 823:	e8 93 fc ff ff       	call   4bb <sbrk>
  if(p == (char*)-1)
 828:	83 c4 10             	add    $0x10,%esp
 82b:	83 f8 ff             	cmp    $0xffffffff,%eax
 82e:	74 1c                	je     84c <malloc+0x8c>
  hp->s.size = nu;
 830:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	83 c0 08             	add    $0x8,%eax
 839:	50                   	push   %eax
 83a:	e8 f1 fe ff ff       	call   730 <free>
  return freep;
 83f:	8b 15 3c 0c 00 00    	mov    0xc3c,%edx
      if((p = morecore(nunits)) == 0)
 845:	83 c4 10             	add    $0x10,%esp
 848:	85 d2                	test   %edx,%edx
 84a:	75 bc                	jne    808 <malloc+0x48>
        return 0;
  }
}
 84c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 84f:	31 c0                	xor    %eax,%eax
}
 851:	5b                   	pop    %ebx
 852:	5e                   	pop    %esi
 853:	5f                   	pop    %edi
 854:	5d                   	pop    %ebp
 855:	c3                   	ret    
    if(p->s.size >= nunits){
 856:	89 d0                	mov    %edx,%eax
 858:	89 fa                	mov    %edi,%edx
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 860:	39 ce                	cmp    %ecx,%esi
 862:	74 4c                	je     8b0 <malloc+0xf0>
        p->s.size -= nunits;
 864:	29 f1                	sub    %esi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 86c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 86f:	89 15 3c 0c 00 00    	mov    %edx,0xc3c
}
 875:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 878:	83 c0 08             	add    $0x8,%eax
}
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 880:	c7 05 3c 0c 00 00 40 	movl   $0xc40,0xc3c
 887:	0c 00 00 
    base.s.size = 0;
 88a:	bf 40 0c 00 00       	mov    $0xc40,%edi
    base.s.ptr = freep = prevp = &base;
 88f:	c7 05 40 0c 00 00 40 	movl   $0xc40,0xc40
 896:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 899:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 89b:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8a2:	00 00 00 
    if(p->s.size >= nunits){
 8a5:	e9 42 ff ff ff       	jmp    7ec <malloc+0x2c>
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b9                	jmp    86f <malloc+0xaf>
