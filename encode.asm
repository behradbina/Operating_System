
_encode:     file format elf32-i386


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
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
    char* text_to_encode[argc-1];
  19:	8d 78 ff             	lea    -0x1(%eax),%edi
  1c:	8d 0c bd 00 00 00 00 	lea    0x0(,%edi,4),%ecx
  23:	89 7d e0             	mov    %edi,-0x20(%ebp)
  26:	8d 51 0f             	lea    0xf(%ecx),%edx
  29:	89 d7                	mov    %edx,%edi
  2b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  31:	83 e7 f0             	and    $0xfffffff0,%edi
  34:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  37:	89 e7                	mov    %esp,%edi
  39:	29 d7                	sub    %edx,%edi
  3b:	39 fc                	cmp    %edi,%esp
  3d:	74 12                	je     51 <main+0x51>
  3f:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  45:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  4c:	00 
  4d:	39 fc                	cmp    %edi,%esp
  4f:	75 ee                	jne    3f <main+0x3f>
  51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  54:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  5a:	29 d4                	sub    %edx,%esp
  5c:	85 d2                	test   %edx,%edx
  5e:	0f 85 7d 01 00 00    	jne    1e1 <main+0x1e1>
    if(argc <2){
  64:	83 e8 01             	sub    $0x1,%eax
    char* text_to_encode[argc-1];
  67:	89 65 dc             	mov    %esp,-0x24(%ebp)
    if(argc <2){
  6a:	0f 8e 5b 01 00 00    	jle    1cb <main+0x1cb>
  70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  73:	8d 43 04             	lea    0x4(%ebx),%eax
  76:	8d 4c 0b 04          	lea    0x4(%ebx,%ecx,1),%ecx
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    }
    else{
        for (int i=1;i<argc;i++){
            //printf(1,argv[i]);
            text_to_encode[i-1]=argv[i];
  80:	8b 18                	mov    (%eax),%ebx
        for (int i=1;i<argc;i++){
  82:	83 c0 04             	add    $0x4,%eax
  85:	83 c2 04             	add    $0x4,%edx
            text_to_encode[i-1]=argv[i];
  88:	89 5a fc             	mov    %ebx,-0x4(%edx)
        for (int i=1;i<argc;i++){
  8b:	39 c1                	cmp    %eax,%ecx
  8d:	75 f1                	jne    80 <main+0x80>
            //printf(1,'\n');
        }
    }
        // printf(1,'%c','\n');
    for (int i=0;i<argc-1;i++){
  8f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  92:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  99:	85 c9                	test   %ecx,%ecx
  9b:	0f 8e fd 00 00 00    	jle    19e <main+0x19e>
  a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        //printf(1,text_to_encode[i]);
        //printf(1,"functions: \n");
        cesar_encode(text_to_encode[i],1);
  a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  ae:	8b 1c b8             	mov    (%eax,%edi,4),%ebx
    for (int i=0;text[i]!='\0';i++)
  b1:	0f be 0b             	movsbl (%ebx),%ecx
  b4:	84 c9                	test   %cl,%cl
  b6:	75 4a                	jne    102 <main+0x102>
  b8:	eb 66                	jmp    120 <main+0x120>
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(c>='A' && c<='Z'){
  c0:	8d 41 bf             	lea    -0x41(%ecx),%eax
  c3:	3c 19                	cmp    $0x19,%al
  c5:	77 47                	ja     10e <main+0x10e>
  c7:	bf 41 00 00 00       	mov    $0x41,%edi
  cc:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
  d1:	be 41 00 00 00       	mov    $0x41,%esi
        text[i]=(c-base+shift)%26+base;
  d6:	29 c1                	sub    %eax,%ecx
  d8:	ba 4f ec c4 4e       	mov    $0x4ec4ec4f,%edx
  dd:	83 c3 01             	add    $0x1,%ebx
  e0:	83 c1 01             	add    $0x1,%ecx
  e3:	89 c8                	mov    %ecx,%eax
  e5:	f7 ea                	imul   %edx
  e7:	89 c8                	mov    %ecx,%eax
  e9:	c1 f8 1f             	sar    $0x1f,%eax
  ec:	c1 fa 03             	sar    $0x3,%edx
  ef:	29 c2                	sub    %eax,%edx
  f1:	6b d2 1a             	imul   $0x1a,%edx,%edx
  f4:	29 d1                	sub    %edx,%ecx
  f6:	01 f9                	add    %edi,%ecx
  f8:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
  fb:	0f be 0b             	movsbl (%ebx),%ecx
  fe:	84 c9                	test   %cl,%cl
 100:	74 1e                	je     120 <main+0x120>
        if (c>='a' && c<='z'){
 102:	8d 41 9f             	lea    -0x61(%ecx),%eax
 105:	3c 19                	cmp    $0x19,%al
 107:	77 b7                	ja     c0 <main+0xc0>
        base='a';}
 109:	be 61 00 00 00       	mov    $0x61,%esi
        text[i]=(c-base+shift)%26+base;
 10e:	89 f0                	mov    %esi,%eax
 110:	89 f7                	mov    %esi,%edi
 112:	0f be c0             	movsbl %al,%eax
 115:	eb bf                	jmp    d6 <main+0xd6>
 117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11e:	66 90                	xchg   %ax,%ax
    for (int i=0;i<argc-1;i++){
 120:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 127:	39 45 e0             	cmp    %eax,-0x20(%ebp)
 12a:	0f 85 78 ff ff ff    	jne    a8 <main+0xa8>
        //printf(1,text_to_encode[i]);
       // printf(1,'%c','\n');
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
 130:	83 ec 08             	sub    $0x8,%esp
 133:	31 ff                	xor    %edi,%edi
 135:	68 02 02 00 00       	push   $0x202
 13a:	68 81 09 00 00       	push   $0x981
 13f:	e8 bf 03 00 00       	call   503 <open>
       // printf(1,"hi \n");
        char * space=" ";
        if (fd <0){
 144:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 147:	89 c3                	mov    %eax,%ebx
        if (fd <0){
 149:	85 c0                	test   %eax,%eax
 14b:	78 6b                	js     1b8 <main+0x1b8>
 14d:	8d 76 00             	lea    0x0(%esi),%esi
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 150:	8b 45 dc             	mov    -0x24(%ebp),%eax
 153:	83 ec 0c             	sub    $0xc,%esp
 156:	8b 34 b8             	mov    (%eax,%edi,4),%esi
            for (int i=0;i<argc-1;i++){
 159:	83 c7 01             	add    $0x1,%edi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 15c:	56                   	push   %esi
 15d:	e8 9e 01 00 00       	call   300 <strlen>
 162:	83 c4 0c             	add    $0xc,%esp
 165:	50                   	push   %eax
 166:	56                   	push   %esi
 167:	53                   	push   %ebx
 168:	e8 76 03 00 00       	call   4e3 <write>
                write(fd,space,strlen(space));
 16d:	c7 04 24 7f 09 00 00 	movl   $0x97f,(%esp)
 174:	e8 87 01 00 00       	call   300 <strlen>
 179:	83 c4 0c             	add    $0xc,%esp
 17c:	50                   	push   %eax
 17d:	68 7f 09 00 00       	push   $0x97f
 182:	53                   	push   %ebx
 183:	e8 5b 03 00 00       	call   4e3 <write>
            for (int i=0;i<argc-1;i++){
 188:	83 c4 10             	add    $0x10,%esp
 18b:	39 7d e0             	cmp    %edi,-0x20(%ebp)
 18e:	75 c0                	jne    150 <main+0x150>

            //printf(1,"hi2");


        }
        close(fd);
 190:	83 ec 0c             	sub    $0xc,%esp
 193:	53                   	push   %ebx
 194:	e8 52 03 00 00       	call   4eb <close>
    exit();
 199:	e8 25 03 00 00       	call   4c3 <exit>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 19e:	50                   	push   %eax
 19f:	50                   	push   %eax
 1a0:	68 02 02 00 00       	push   $0x202
 1a5:	68 81 09 00 00       	push   $0x981
 1aa:	e8 54 03 00 00       	call   503 <open>
        if (fd <0){
 1af:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 1b2:	89 c3                	mov    %eax,%ebx
        if (fd <0){
 1b4:	85 c0                	test   %eax,%eax
 1b6:	79 d8                	jns    190 <main+0x190>
            printf(1,"Unable to open or create file");
 1b8:	52                   	push   %edx
 1b9:	52                   	push   %edx
 1ba:	68 61 09 00 00       	push   $0x961
 1bf:	6a 01                	push   $0x1
 1c1:	e8 5a 04 00 00       	call   620 <printf>
            exit();
 1c6:	e8 f8 02 00 00       	call   4c3 <exit>
        printf(1,"no text to encode passed");
 1cb:	53                   	push   %ebx
 1cc:	53                   	push   %ebx
 1cd:	68 48 09 00 00       	push   $0x948
 1d2:	6a 01                	push   $0x1
 1d4:	e8 47 04 00 00       	call   620 <printf>
 1d9:	83 c4 10             	add    $0x10,%esp
 1dc:	e9 ae fe ff ff       	jmp    8f <main+0x8f>
    char* text_to_encode[argc-1];
 1e1:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
 1e6:	e9 79 fe ff ff       	jmp    64 <main+0x64>
 1eb:	66 90                	xchg   %ax,%ax
 1ed:	66 90                	xchg   %ax,%ax
 1ef:	90                   	nop

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
 1fe:	75 4a                	jne    24a <cesar_encode+0x5a>
 200:	eb 5e                	jmp    260 <cesar_encode+0x70>
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(c>='A' && c<='Z'){
 208:	8d 41 bf             	lea    -0x41(%ecx),%eax
 20b:	3c 19                	cmp    $0x19,%al
 20d:	77 47                	ja     256 <cesar_encode+0x66>
 20f:	be 41 00 00 00       	mov    $0x41,%esi
 214:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
 219:	bf 41 00 00 00       	mov    $0x41,%edi
        text[i]=(c-base+shift)%26+base;
 21e:	29 c1                	sub    %eax,%ecx
 220:	03 4d 0c             	add    0xc(%ebp),%ecx
 223:	ba 4f ec c4 4e       	mov    $0x4ec4ec4f,%edx
 228:	83 c3 01             	add    $0x1,%ebx
 22b:	89 c8                	mov    %ecx,%eax
 22d:	f7 ea                	imul   %edx
 22f:	89 c8                	mov    %ecx,%eax
 231:	c1 f8 1f             	sar    $0x1f,%eax
 234:	c1 fa 03             	sar    $0x3,%edx
 237:	29 c2                	sub    %eax,%edx
 239:	6b d2 1a             	imul   $0x1a,%edx,%edx
 23c:	29 d1                	sub    %edx,%ecx
 23e:	01 f1                	add    %esi,%ecx
 240:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
 243:	0f be 0b             	movsbl (%ebx),%ecx
 246:	84 c9                	test   %cl,%cl
 248:	74 16                	je     260 <cesar_encode+0x70>
        if (c>='a' && c<='z'){
 24a:	8d 41 9f             	lea    -0x61(%ecx),%eax
 24d:	3c 19                	cmp    $0x19,%al
 24f:	77 b7                	ja     208 <cesar_encode+0x18>
        base='a';}
 251:	bf 61 00 00 00       	mov    $0x61,%edi
        text[i]=(c-base+shift)%26+base;
 256:	89 f8                	mov    %edi,%eax
 258:	89 fe                	mov    %edi,%esi
 25a:	0f be c0             	movsbl %al,%eax
 25d:	eb bf                	jmp    21e <cesar_encode+0x2e>
 25f:	90                   	nop
}
 260:	5b                   	pop    %ebx
 261:	5e                   	pop    %esi
 262:	5f                   	pop    %edi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret    
 265:	66 90                	xchg   %ax,%ax
 267:	66 90                	xchg   %ax,%ax
 269:	66 90                	xchg   %ax,%ax
 26b:	66 90                	xchg   %ax,%ax
 26d:	66 90                	xchg   %ax,%ax
 26f:	90                   	nop

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 270:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 271:	31 c0                	xor    %eax,%eax
{
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	8b 4d 08             	mov    0x8(%ebp),%ecx
 279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 280:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 284:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 287:	83 c0 01             	add    $0x1,%eax
 28a:	84 d2                	test   %dl,%dl
 28c:	75 f2                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 28e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 291:	89 c8                	mov    %ecx,%eax
 293:	c9                   	leave  
 294:	c3                   	ret    
 295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	75 17                	jne    2c8 <strcmp+0x28>
 2b1:	eb 3a                	jmp    2ed <strcmp+0x4d>
 2b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b7:	90                   	nop
 2b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2c2:	84 c0                	test   %al,%al
 2c4:	74 1a                	je     2e0 <strcmp+0x40>
    p++, q++;
 2c6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 2c8:	0f b6 19             	movzbl (%ecx),%ebx
 2cb:	38 c3                	cmp    %al,%bl
 2cd:	74 e9                	je     2b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2cf:	29 d8                	sub    %ebx,%eax
}
 2d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d4:	c9                   	leave  
 2d5:	c3                   	ret    
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 2e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2e4:	31 c0                	xor    %eax,%eax
 2e6:	29 d8                	sub    %ebx,%eax
}
 2e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 2ed:	0f b6 19             	movzbl (%ecx),%ebx
 2f0:	31 c0                	xor    %eax,%eax
 2f2:	eb db                	jmp    2cf <strcmp+0x2f>
 2f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <strlen>:

uint
strlen(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 306:	80 3a 00             	cmpb   $0x0,(%edx)
 309:	74 15                	je     320 <strlen+0x20>
 30b:	31 c0                	xor    %eax,%eax
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	83 c0 01             	add    $0x1,%eax
 313:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 317:	89 c1                	mov    %eax,%ecx
 319:	75 f5                	jne    310 <strlen+0x10>
    ;
  return n;
}
 31b:	89 c8                	mov    %ecx,%eax
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    
 31f:	90                   	nop
  for(n = 0; s[n]; n++)
 320:	31 c9                	xor    %ecx,%ecx
}
 322:	5d                   	pop    %ebp
 323:	89 c8                	mov    %ecx,%eax
 325:	c3                   	ret    
 326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi

00000330 <memset>:

void*
memset(void *dst, int c, uint n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 337:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 d7                	mov    %edx,%edi
 33f:	fc                   	cld    
 340:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 342:	8b 7d fc             	mov    -0x4(%ebp),%edi
 345:	89 d0                	mov    %edx,%eax
 347:	c9                   	leave  
 348:	c3                   	ret    
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <strchr>:

char*
strchr(const char *s, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 35a:	0f b6 10             	movzbl (%eax),%edx
 35d:	84 d2                	test   %dl,%dl
 35f:	75 12                	jne    373 <strchr+0x23>
 361:	eb 1d                	jmp    380 <strchr+0x30>
 363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 367:	90                   	nop
 368:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 36c:	83 c0 01             	add    $0x1,%eax
 36f:	84 d2                	test   %dl,%dl
 371:	74 0d                	je     380 <strchr+0x30>
    if(*s == c)
 373:	38 d1                	cmp    %dl,%cl
 375:	75 f1                	jne    368 <strchr+0x18>
      return (char*)s;
  return 0;
}
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 380:	31 c0                	xor    %eax,%eax
}
 382:	5d                   	pop    %ebp
 383:	c3                   	ret    
 384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 38f:	90                   	nop

00000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 395:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 398:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 399:	31 db                	xor    %ebx,%ebx
{
 39b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 39e:	eb 27                	jmp    3c7 <gets+0x37>
    cc = read(0, &c, 1);
 3a0:	83 ec 04             	sub    $0x4,%esp
 3a3:	6a 01                	push   $0x1
 3a5:	57                   	push   %edi
 3a6:	6a 00                	push   $0x0
 3a8:	e8 2e 01 00 00       	call   4db <read>
    if(cc < 1)
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	85 c0                	test   %eax,%eax
 3b2:	7e 1d                	jle    3d1 <gets+0x41>
      break;
    buf[i++] = c;
 3b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
 3bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3bf:	3c 0a                	cmp    $0xa,%al
 3c1:	74 1d                	je     3e0 <gets+0x50>
 3c3:	3c 0d                	cmp    $0xd,%al
 3c5:	74 19                	je     3e0 <gets+0x50>
  for(i=0; i+1 < max; ){
 3c7:	89 de                	mov    %ebx,%esi
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cf:	7c cf                	jl     3a0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3db:	5b                   	pop    %ebx
 3dc:	5e                   	pop    %esi
 3dd:	5f                   	pop    %edi
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    
  buf[i] = '\0';
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	89 de                	mov    %ebx,%esi
 3e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 3e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5f                   	pop    %edi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

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
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax

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
 467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46e:	66 90                	xchg   %ax,%ax
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
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
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
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

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
 563:	66 90                	xchg   %ax,%ax
 565:	66 90                	xchg   %ax,%ax
 567:	66 90                	xchg   %ax,%ax
 569:	66 90                	xchg   %ax,%ax
 56b:	66 90                	xchg   %ax,%ax
 56d:	66 90                	xchg   %ax,%ax
 56f:	90                   	nop

00000570 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 3c             	sub    $0x3c,%esp
 579:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 57c:	89 d1                	mov    %edx,%ecx
{
 57e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 581:	85 d2                	test   %edx,%edx
 583:	0f 89 7f 00 00 00    	jns    608 <printint+0x98>
 589:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 58d:	74 79                	je     608 <printint+0x98>
    neg = 1;
 58f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 596:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 598:	31 db                	xor    %ebx,%ebx
 59a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5a0:	89 c8                	mov    %ecx,%eax
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	89 cf                	mov    %ecx,%edi
 5a6:	f7 75 c4             	divl   -0x3c(%ebp)
 5a9:	0f b6 92 ec 09 00 00 	movzbl 0x9ec(%edx),%edx
 5b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5b3:	89 d8                	mov    %ebx,%eax
 5b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5c1:	76 dd                	jbe    5a0 <printint+0x30>
  if(neg)
 5c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5c6:	85 c9                	test   %ecx,%ecx
 5c8:	74 0c                	je     5d6 <printint+0x66>
    buf[i++] = '-';
 5ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5dd:	eb 07                	jmp    5e6 <printint+0x76>
 5df:	90                   	nop
    putc(fd, buf[i]);
 5e0:	0f b6 13             	movzbl (%ebx),%edx
 5e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5e6:	83 ec 04             	sub    $0x4,%esp
 5e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5ec:	6a 01                	push   $0x1
 5ee:	56                   	push   %esi
 5ef:	57                   	push   %edi
 5f0:	e8 ee fe ff ff       	call   4e3 <write>
  while(--i >= 0)
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	39 de                	cmp    %ebx,%esi
 5fa:	75 e4                	jne    5e0 <printint+0x70>
}
 5fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ff:	5b                   	pop    %ebx
 600:	5e                   	pop    %esi
 601:	5f                   	pop    %edi
 602:	5d                   	pop    %ebp
 603:	c3                   	ret    
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 608:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 60f:	eb 87                	jmp    598 <printint+0x28>
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop

00000620 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 629:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 62c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 62f:	0f b6 13             	movzbl (%ebx),%edx
 632:	84 d2                	test   %dl,%dl
 634:	74 6a                	je     6a0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 636:	8d 45 10             	lea    0x10(%ebp),%eax
 639:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 63c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 63f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 641:	89 45 d0             	mov    %eax,-0x30(%ebp)
 644:	eb 36                	jmp    67c <printf+0x5c>
 646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64d:	8d 76 00             	lea    0x0(%esi),%esi
 650:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 653:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	74 15                	je     672 <printf+0x52>
  write(fd, &c, 1);
 65d:	83 ec 04             	sub    $0x4,%esp
 660:	88 55 e7             	mov    %dl,-0x19(%ebp)
 663:	6a 01                	push   $0x1
 665:	57                   	push   %edi
 666:	56                   	push   %esi
 667:	e8 77 fe ff ff       	call   4e3 <write>
 66c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 66f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 672:	0f b6 13             	movzbl (%ebx),%edx
 675:	83 c3 01             	add    $0x1,%ebx
 678:	84 d2                	test   %dl,%dl
 67a:	74 24                	je     6a0 <printf+0x80>
    c = fmt[i] & 0xff;
 67c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 67f:	85 c9                	test   %ecx,%ecx
 681:	74 cd                	je     650 <printf+0x30>
      }
    } else if(state == '%'){
 683:	83 f9 25             	cmp    $0x25,%ecx
 686:	75 ea                	jne    672 <printf+0x52>
      if(c == 'd'){
 688:	83 f8 25             	cmp    $0x25,%eax
 68b:	0f 84 07 01 00 00    	je     798 <printf+0x178>
 691:	83 e8 63             	sub    $0x63,%eax
 694:	83 f8 15             	cmp    $0x15,%eax
 697:	77 17                	ja     6b0 <printf+0x90>
 699:	ff 24 85 94 09 00 00 	jmp    *0x994(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a3:	5b                   	pop    %ebx
 6a4:	5e                   	pop    %esi
 6a5:	5f                   	pop    %edi
 6a6:	5d                   	pop    %ebp
 6a7:	c3                   	ret    
 6a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
  write(fd, &c, 1);
 6b0:	83 ec 04             	sub    $0x4,%esp
 6b3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 6b6:	6a 01                	push   $0x1
 6b8:	57                   	push   %edi
 6b9:	56                   	push   %esi
 6ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6be:	e8 20 fe ff ff       	call   4e3 <write>
        putc(fd, c);
 6c3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 6c7:	83 c4 0c             	add    $0xc,%esp
 6ca:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6cd:	6a 01                	push   $0x1
 6cf:	57                   	push   %edi
 6d0:	56                   	push   %esi
 6d1:	e8 0d fe ff ff       	call   4e3 <write>
        putc(fd, c);
 6d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d9:	31 c9                	xor    %ecx,%ecx
 6db:	eb 95                	jmp    672 <printf+0x52>
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6e8:	6a 00                	push   $0x0
 6ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	89 f0                	mov    %esi,%eax
 6f1:	e8 7a fe ff ff       	call   570 <printint>
        ap++;
 6f6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6fa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fd:	31 c9                	xor    %ecx,%ecx
 6ff:	e9 6e ff ff ff       	jmp    672 <printf+0x52>
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 708:	8b 45 d0             	mov    -0x30(%ebp),%eax
 70b:	8b 10                	mov    (%eax),%edx
        ap++;
 70d:	83 c0 04             	add    $0x4,%eax
 710:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 713:	85 d2                	test   %edx,%edx
 715:	0f 84 8d 00 00 00    	je     7a8 <printf+0x188>
        while(*s != 0){
 71b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 71e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 720:	84 c0                	test   %al,%al
 722:	0f 84 4a ff ff ff    	je     672 <printf+0x52>
 728:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 72b:	89 d3                	mov    %edx,%ebx
 72d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
          s++;
 733:	83 c3 01             	add    $0x1,%ebx
 736:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 739:	6a 01                	push   $0x1
 73b:	57                   	push   %edi
 73c:	56                   	push   %esi
 73d:	e8 a1 fd ff ff       	call   4e3 <write>
        while(*s != 0){
 742:	0f b6 03             	movzbl (%ebx),%eax
 745:	83 c4 10             	add    $0x10,%esp
 748:	84 c0                	test   %al,%al
 74a:	75 e4                	jne    730 <printf+0x110>
      state = 0;
 74c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 74f:	31 c9                	xor    %ecx,%ecx
 751:	e9 1c ff ff ff       	jmp    672 <printf+0x52>
 756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 760:	83 ec 0c             	sub    $0xc,%esp
 763:	b9 0a 00 00 00       	mov    $0xa,%ecx
 768:	6a 01                	push   $0x1
 76a:	e9 7b ff ff ff       	jmp    6ea <printf+0xca>
 76f:	90                   	nop
        putc(fd, *ap);
 770:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 773:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 776:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 778:	6a 01                	push   $0x1
 77a:	57                   	push   %edi
 77b:	56                   	push   %esi
        putc(fd, *ap);
 77c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 77f:	e8 5f fd ff ff       	call   4e3 <write>
        ap++;
 784:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 788:	83 c4 10             	add    $0x10,%esp
      state = 0;
 78b:	31 c9                	xor    %ecx,%ecx
 78d:	e9 e0 fe ff ff       	jmp    672 <printf+0x52>
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 798:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 79b:	83 ec 04             	sub    $0x4,%esp
 79e:	e9 2a ff ff ff       	jmp    6cd <printf+0xad>
 7a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7a7:	90                   	nop
          s = "(null)";
 7a8:	ba 8c 09 00 00       	mov    $0x98c,%edx
        while(*s != 0){
 7ad:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7b0:	b8 28 00 00 00       	mov    $0x28,%eax
 7b5:	89 d3                	mov    %edx,%ebx
 7b7:	e9 74 ff ff ff       	jmp    730 <printf+0x110>
 7bc:	66 90                	xchg   %ax,%ax
 7be:	66 90                	xchg   %ax,%ax

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	a1 cc 0c 00 00       	mov    0xccc,%eax
{
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	57                   	push   %edi
 7c9:	56                   	push   %esi
 7ca:	53                   	push   %ebx
 7cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7d8:	89 c2                	mov    %eax,%edx
 7da:	8b 00                	mov    (%eax),%eax
 7dc:	39 ca                	cmp    %ecx,%edx
 7de:	73 30                	jae    810 <free+0x50>
 7e0:	39 c1                	cmp    %eax,%ecx
 7e2:	72 04                	jb     7e8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	39 c2                	cmp    %eax,%edx
 7e6:	72 f0                	jb     7d8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ee:	39 f8                	cmp    %edi,%eax
 7f0:	74 30                	je     822 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7f5:	8b 42 04             	mov    0x4(%edx),%eax
 7f8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7fb:	39 f1                	cmp    %esi,%ecx
 7fd:	74 3a                	je     839 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ff:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 801:	5b                   	pop    %ebx
  freep = p;
 802:	89 15 cc 0c 00 00    	mov    %edx,0xccc
}
 808:	5e                   	pop    %esi
 809:	5f                   	pop    %edi
 80a:	5d                   	pop    %ebp
 80b:	c3                   	ret    
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	39 c2                	cmp    %eax,%edx
 812:	72 c4                	jb     7d8 <free+0x18>
 814:	39 c1                	cmp    %eax,%ecx
 816:	73 c0                	jae    7d8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 818:	8b 73 fc             	mov    -0x4(%ebx),%esi
 81b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81e:	39 f8                	cmp    %edi,%eax
 820:	75 d0                	jne    7f2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 822:	03 70 04             	add    0x4(%eax),%esi
 825:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	8b 02                	mov    (%edx),%eax
 82a:	8b 00                	mov    (%eax),%eax
 82c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 82f:	8b 42 04             	mov    0x4(%edx),%eax
 832:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 835:	39 f1                	cmp    %esi,%ecx
 837:	75 c6                	jne    7ff <free+0x3f>
    p->s.size += bp->s.size;
 839:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 83c:	89 15 cc 0c 00 00    	mov    %edx,0xccc
    p->s.size += bp->s.size;
 842:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 845:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 848:	89 0a                	mov    %ecx,(%edx)
}
 84a:	5b                   	pop    %ebx
 84b:	5e                   	pop    %esi
 84c:	5f                   	pop    %edi
 84d:	5d                   	pop    %ebp
 84e:	c3                   	ret    
 84f:	90                   	nop

00000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 85c:	8b 3d cc 0c 00 00    	mov    0xccc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	8d 70 07             	lea    0x7(%eax),%esi
 865:	c1 ee 03             	shr    $0x3,%esi
 868:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 86b:	85 ff                	test   %edi,%edi
 86d:	0f 84 9d 00 00 00    	je     910 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 873:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 875:	8b 4a 04             	mov    0x4(%edx),%ecx
 878:	39 f1                	cmp    %esi,%ecx
 87a:	73 6a                	jae    8e6 <malloc+0x96>
 87c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 881:	39 de                	cmp    %ebx,%esi
 883:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 886:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 88d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 890:	eb 17                	jmp    8a9 <malloc+0x59>
 892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 89a:	8b 48 04             	mov    0x4(%eax),%ecx
 89d:	39 f1                	cmp    %esi,%ecx
 89f:	73 4f                	jae    8f0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a1:	8b 3d cc 0c 00 00    	mov    0xccc,%edi
 8a7:	89 c2                	mov    %eax,%edx
 8a9:	39 d7                	cmp    %edx,%edi
 8ab:	75 eb                	jne    898 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8ad:	83 ec 0c             	sub    $0xc,%esp
 8b0:	ff 75 e4             	push   -0x1c(%ebp)
 8b3:	e8 93 fc ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 8b8:	83 c4 10             	add    $0x10,%esp
 8bb:	83 f8 ff             	cmp    $0xffffffff,%eax
 8be:	74 1c                	je     8dc <malloc+0x8c>
  hp->s.size = nu;
 8c0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8c3:	83 ec 0c             	sub    $0xc,%esp
 8c6:	83 c0 08             	add    $0x8,%eax
 8c9:	50                   	push   %eax
 8ca:	e8 f1 fe ff ff       	call   7c0 <free>
  return freep;
 8cf:	8b 15 cc 0c 00 00    	mov    0xccc,%edx
      if((p = morecore(nunits)) == 0)
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	85 d2                	test   %edx,%edx
 8da:	75 bc                	jne    898 <malloc+0x48>
        return 0;
  }
}
 8dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8df:	31 c0                	xor    %eax,%eax
}
 8e1:	5b                   	pop    %ebx
 8e2:	5e                   	pop    %esi
 8e3:	5f                   	pop    %edi
 8e4:	5d                   	pop    %ebp
 8e5:	c3                   	ret    
    if(p->s.size >= nunits){
 8e6:	89 d0                	mov    %edx,%eax
 8e8:	89 fa                	mov    %edi,%edx
 8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8f0:	39 ce                	cmp    %ecx,%esi
 8f2:	74 4c                	je     940 <malloc+0xf0>
        p->s.size -= nunits;
 8f4:	29 f1                	sub    %esi,%ecx
 8f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8fc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 8ff:	89 15 cc 0c 00 00    	mov    %edx,0xccc
}
 905:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 908:	83 c0 08             	add    $0x8,%eax
}
 90b:	5b                   	pop    %ebx
 90c:	5e                   	pop    %esi
 90d:	5f                   	pop    %edi
 90e:	5d                   	pop    %ebp
 90f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 cc 0c 00 00 d0 	movl   $0xcd0,0xccc
 917:	0c 00 00 
    base.s.size = 0;
 91a:	bf d0 0c 00 00       	mov    $0xcd0,%edi
    base.s.ptr = freep = prevp = &base;
 91f:	c7 05 d0 0c 00 00 d0 	movl   $0xcd0,0xcd0
 926:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 92b:	c7 05 d4 0c 00 00 00 	movl   $0x0,0xcd4
 932:	00 00 00 
    if(p->s.size >= nunits){
 935:	e9 42 ff ff ff       	jmp    87c <malloc+0x2c>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 940:	8b 08                	mov    (%eax),%ecx
 942:	89 0a                	mov    %ecx,(%edx)
 944:	eb b9                	jmp    8ff <malloc+0xaf>
