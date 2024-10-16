
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
  5c:	0f 85 73 01 00 00    	jne    1d5 <main+0x1d5>
    if(argc <2){
  62:	83 ea 01             	sub    $0x1,%edx
    char* text_to_encode[argc-1];
  65:	89 65 dc             	mov    %esp,-0x24(%ebp)
    if(argc <2){
  68:	0f 8e 2c 01 00 00    	jle    19a <main+0x19a>
  6e:	8b 75 dc             	mov    -0x24(%ebp),%esi
  71:	8d 51 04             	lea    0x4(%ecx),%edx
  74:	8d 44 39 04          	lea    0x4(%ecx,%edi,1),%eax
  78:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  7b:	89 f1                	mov    %esi,%ecx
  7d:	8d 76 00             	lea    0x0(%esi),%esi

    }
    else{
        for (int i=1;i<argc;i++){
            //printf(1,argv[i]);
            text_to_encode[i-1]=argv[i];
  80:	8b 32                	mov    (%edx),%esi
        for (int i=1;i<argc;i++){
  82:	83 c2 04             	add    $0x4,%edx
  85:	83 c1 04             	add    $0x4,%ecx
            text_to_encode[i-1]=argv[i];
  88:	89 71 fc             	mov    %esi,-0x4(%ecx)
        for (int i=1;i<argc;i++){
  8b:	39 d0                	cmp    %edx,%eax
  8d:	75 f1                	jne    80 <main+0x80>
            //printf(1,'\n');
        }
    }
        // printf(1,'%c','\n');
    for (int i=0;i<argc-1;i++){
  8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  92:	8d 34 38             	lea    (%eax,%edi,1),%esi
  95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  98:	89 75 e0             	mov    %esi,-0x20(%ebp)
  9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        //printf(1,text_to_encode[i]);
        //printf(1,"functions: \n");
        cesar_encode(text_to_encode[i],1);
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
  b5:	0f 87 d5 00 00 00    	ja     190 <main+0x190>
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
  d4:	83 c1 01             	add    $0x1,%ecx
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
 113:	83 c0 04             	add    $0x4,%eax
 116:	39 45 e0             	cmp    %eax,-0x20(%ebp)
 119:	75 85                	jne    a0 <main+0xa0>
        //printf(1,text_to_encode[i]);
       // printf(1,'%c','\n');
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 02 02 00 00       	push   $0x202
 123:	68 21 09 00 00       	push   $0x921
 128:	e8 c6 03 00 00       	call   4f3 <open>
       // printf(1,"hi \n");
        char * space=" ";
        if (fd <0){
 12d:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 130:	89 c7                	mov    %eax,%edi
        if (fd <0){
 132:	85 c0                	test   %eax,%eax
 134:	0f 88 88 00 00 00    	js     1c2 <main+0x1c2>
            printf(1,"Unable to open or create file");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
 13a:	31 f6                	xor    %esi,%esi
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 140:	8b 45 dc             	mov    -0x24(%ebp),%eax
 143:	83 ec 0c             	sub    $0xc,%esp
 146:	8b 1c b0             	mov    (%eax,%esi,4),%ebx
            for (int i=0;i<argc-1;i++){
 149:	83 c6 01             	add    $0x1,%esi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 14c:	53                   	push   %ebx
 14d:	e8 ae 01 00 00       	call   300 <strlen>
 152:	83 c4 0c             	add    $0xc,%esp
 155:	50                   	push   %eax
 156:	53                   	push   %ebx
 157:	57                   	push   %edi
 158:	e8 76 03 00 00       	call   4d3 <write>
                write(fd,space,strlen(space));
 15d:	c7 04 24 4a 09 00 00 	movl   $0x94a,(%esp)
 164:	e8 97 01 00 00       	call   300 <strlen>
 169:	83 c4 0c             	add    $0xc,%esp
 16c:	50                   	push   %eax
 16d:	68 4a 09 00 00       	push   $0x94a
 172:	57                   	push   %edi
 173:	e8 5b 03 00 00       	call   4d3 <write>
            for (int i=0;i<argc-1;i++){
 178:	83 c4 10             	add    $0x10,%esp
 17b:	39 75 d8             	cmp    %esi,-0x28(%ebp)
 17e:	75 c0                	jne    140 <main+0x140>

            //printf(1,"hi2");


        }
        close(fd);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	57                   	push   %edi
 184:	e8 52 03 00 00       	call   4db <close>
    exit();
 189:	e8 25 03 00 00       	call   4b3 <exit>
 18e:	66 90                	xchg   %ax,%ax
        text[i]=(c-base+shift)%26+base;
 190:	0f be c3             	movsbl %bl,%eax
 193:	89 de                	mov    %ebx,%esi
 195:	e9 30 ff ff ff       	jmp    ca <main+0xca>
        printf(1,"no text to encode passed");
 19a:	52                   	push   %edx
 19b:	52                   	push   %edx
 19c:	68 08 09 00 00       	push   $0x908
 1a1:	6a 01                	push   $0x1
 1a3:	e8 58 04 00 00       	call   600 <printf>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 1a8:	59                   	pop    %ecx
 1a9:	5b                   	pop    %ebx
 1aa:	68 02 02 00 00       	push   $0x202
 1af:	68 21 09 00 00       	push   $0x921
 1b4:	e8 3a 03 00 00       	call   4f3 <open>
        if (fd <0){
 1b9:	83 c4 10             	add    $0x10,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 1bc:	89 c7                	mov    %eax,%edi
        if (fd <0){
 1be:	85 c0                	test   %eax,%eax
 1c0:	79 be                	jns    180 <main+0x180>
            printf(1,"Unable to open or create file");
 1c2:	50                   	push   %eax
 1c3:	50                   	push   %eax
 1c4:	68 2c 09 00 00       	push   $0x92c
 1c9:	6a 01                	push   $0x1
 1cb:	e8 30 04 00 00       	call   600 <printf>
            exit();
 1d0:	e8 de 02 00 00       	call   4b3 <exit>
    char* text_to_encode[argc-1];
 1d5:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
 1da:	e9 83 fe ff ff       	jmp    62 <main+0x62>
 1df:	90                   	nop

000001e0 <cesar_encode>:
void cesar_encode(char* text,int shift){
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	53                   	push   %ebx
 1e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (int i=0;text[i]!='\0';i++)
 1e9:	0f be 0b             	movsbl (%ebx),%ecx
 1ec:	84 c9                	test   %cl,%cl
 1ee:	75 48                	jne    238 <cesar_encode+0x58>
 1f0:	eb 5e                	jmp    250 <cesar_encode+0x70>
 1f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(c>='A' && c<='Z'){
 1f8:	8d 41 bf             	lea    -0x41(%ecx),%eax
 1fb:	3c 19                	cmp    $0x19,%al
 1fd:	77 59                	ja     258 <cesar_encode+0x78>
 1ff:	be 41 00 00 00       	mov    $0x41,%esi
 204:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
 209:	bf 41 00 00 00       	mov    $0x41,%edi
        text[i]=(c-base+shift)%26+base;
 20e:	29 c1                	sub    %eax,%ecx
 210:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 215:	03 4d 0c             	add    0xc(%ebp),%ecx
    for (int i=0;text[i]!='\0';i++)
 218:	83 c3 01             	add    $0x1,%ebx
        text[i]=(c-base+shift)%26+base;
 21b:	f7 e9                	imul   %ecx
 21d:	89 c8                	mov    %ecx,%eax
 21f:	c1 f8 1f             	sar    $0x1f,%eax
 222:	c1 fa 03             	sar    $0x3,%edx
 225:	29 c2                	sub    %eax,%edx
 227:	6b d2 1a             	imul   $0x1a,%edx,%edx
 22a:	29 d1                	sub    %edx,%ecx
 22c:	01 f1                	add    %esi,%ecx
 22e:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
 231:	0f be 0b             	movsbl (%ebx),%ecx
 234:	84 c9                	test   %cl,%cl
 236:	74 18                	je     250 <cesar_encode+0x70>
        if (c>='a' && c<='z'){
 238:	8d 41 9f             	lea    -0x61(%ecx),%eax
 23b:	3c 19                	cmp    $0x19,%al
 23d:	77 b9                	ja     1f8 <cesar_encode+0x18>
 23f:	be 61 00 00 00       	mov    $0x61,%esi
 244:	b8 61 00 00 00       	mov    $0x61,%eax
        base='a';}
 249:	bf 61 00 00 00       	mov    $0x61,%edi
 24e:	eb be                	jmp    20e <cesar_encode+0x2e>
}
 250:	5b                   	pop    %ebx
 251:	5e                   	pop    %esi
 252:	5f                   	pop    %edi
 253:	5d                   	pop    %ebp
 254:	c3                   	ret
 255:	8d 76 00             	lea    0x0(%esi),%esi
        text[i]=(c-base+shift)%26+base;
 258:	89 f8                	mov    %edi,%eax
 25a:	89 fe                	mov    %edi,%esi
 25c:	0f be c0             	movsbl %al,%eax
 25f:	eb ad                	jmp    20e <cesar_encode+0x2e>
 261:	66 90                	xchg   %ax,%ax
 263:	66 90                	xchg   %ax,%ax
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
 295:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29c:	00 
 29d:	8d 76 00             	lea    0x0(%esi),%esi

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
 2b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2c2:	84 c0                	test   %al,%al
 2c4:	74 1a                	je     2e0 <strcmp+0x40>
 2c6:	89 d9                	mov    %ebx,%ecx
 2c8:	0f b6 19             	movzbl (%ecx),%ebx
 2cb:	38 c3                	cmp    %al,%bl
 2cd:	74 e9                	je     2b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2cf:	29 d8                	sub    %ebx,%eax
}
 2d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d4:	c9                   	leave
 2d5:	c3                   	ret
 2d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2dd:	00 
 2de:	66 90                	xchg   %ax,%ax
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
 2f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2fb:	00 
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
 326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32d:	00 
 32e:	66 90                	xchg   %ax,%ax

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
 363:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
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
 384:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38b:	00 
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
 395:	8d 75 e7             	lea    -0x19(%ebp),%esi
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
 3a5:	56                   	push   %esi
 3a6:	6a 00                	push   $0x0
 3a8:	e8 1e 01 00 00       	call   4cb <read>
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
 3c1:	74 10                	je     3d3 <gets+0x43>
 3c3:	3c 0d                	cmp    $0xd,%al
 3c5:	74 0c                	je     3d3 <gets+0x43>
  for(i=0; i+1 < max; ){
 3c7:	89 df                	mov    %ebx,%edi
 3c9:	83 c3 01             	add    $0x1,%ebx
 3cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cf:	7c cf                	jl     3a0 <gets+0x10>
 3d1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 3da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3dd:	5b                   	pop    %ebx
 3de:	5e                   	pop    %esi
 3df:	5f                   	pop    %edi
 3e0:	5d                   	pop    %ebp
 3e1:	c3                   	ret
 3e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3e9:	00 
 3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f5:	83 ec 08             	sub    $0x8,%esp
 3f8:	6a 00                	push   $0x0
 3fa:	ff 75 08             	push   0x8(%ebp)
 3fd:	e8 f1 00 00 00       	call   4f3 <open>
  if(fd < 0)
 402:	83 c4 10             	add    $0x10,%esp
 405:	85 c0                	test   %eax,%eax
 407:	78 27                	js     430 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 409:	83 ec 08             	sub    $0x8,%esp
 40c:	ff 75 0c             	push   0xc(%ebp)
 40f:	89 c3                	mov    %eax,%ebx
 411:	50                   	push   %eax
 412:	e8 f4 00 00 00       	call   50b <fstat>
  close(fd);
 417:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 41a:	89 c6                	mov    %eax,%esi
  close(fd);
 41c:	e8 ba 00 00 00       	call   4db <close>
  return r;
 421:	83 c4 10             	add    $0x10,%esp
}
 424:	8d 65 f8             	lea    -0x8(%ebp),%esp
 427:	89 f0                	mov    %esi,%eax
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret
 42d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 430:	be ff ff ff ff       	mov    $0xffffffff,%esi
 435:	eb ed                	jmp    424 <stat+0x34>
 437:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 43e:	00 
 43f:	90                   	nop

00000440 <atoi>:

int
atoi(const char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 447:	0f be 02             	movsbl (%edx),%eax
 44a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 44d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 450:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 455:	77 1e                	ja     475 <atoi+0x35>
 457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 45e:	00 
 45f:	90                   	nop
    n = n*10 + *s++ - '0';
 460:	83 c2 01             	add    $0x1,%edx
 463:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 466:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 46a:	0f be 02             	movsbl (%edx),%eax
 46d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 eb                	jbe    460 <atoi+0x20>
  return n;
}
 475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 478:	89 c8                	mov    %ecx,%eax
 47a:	c9                   	leave
 47b:	c3                   	ret
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000480 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	8b 45 10             	mov    0x10(%ebp),%eax
 487:	8b 55 08             	mov    0x8(%ebp),%edx
 48a:	56                   	push   %esi
 48b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 c0                	test   %eax,%eax
 490:	7e 13                	jle    4a5 <memmove+0x25>
 492:	01 d0                	add    %edx,%eax
  dst = vdst;
 494:	89 d7                	mov    %edx,%edi
 496:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 49d:	00 
 49e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4a1:	39 f8                	cmp    %edi,%eax
 4a3:	75 fb                	jne    4a0 <memmove+0x20>
  return vdst;
}
 4a5:	5e                   	pop    %esi
 4a6:	89 d0                	mov    %edx,%eax
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret

000004ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ab:	b8 01 00 00 00       	mov    $0x1,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <exit>:
SYSCALL(exit)
 4b3:	b8 02 00 00 00       	mov    $0x2,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <wait>:
SYSCALL(wait)
 4bb:	b8 03 00 00 00       	mov    $0x3,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <pipe>:
SYSCALL(pipe)
 4c3:	b8 04 00 00 00       	mov    $0x4,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <read>:
SYSCALL(read)
 4cb:	b8 05 00 00 00       	mov    $0x5,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <write>:
SYSCALL(write)
 4d3:	b8 10 00 00 00       	mov    $0x10,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <close>:
SYSCALL(close)
 4db:	b8 15 00 00 00       	mov    $0x15,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <kill>:
SYSCALL(kill)
 4e3:	b8 06 00 00 00       	mov    $0x6,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <exec>:
SYSCALL(exec)
 4eb:	b8 07 00 00 00       	mov    $0x7,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <open>:
SYSCALL(open)
 4f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <mknod>:
SYSCALL(mknod)
 4fb:	b8 11 00 00 00       	mov    $0x11,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <unlink>:
SYSCALL(unlink)
 503:	b8 12 00 00 00       	mov    $0x12,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <fstat>:
SYSCALL(fstat)
 50b:	b8 08 00 00 00       	mov    $0x8,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <link>:
SYSCALL(link)
 513:	b8 13 00 00 00       	mov    $0x13,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <mkdir>:
SYSCALL(mkdir)
 51b:	b8 14 00 00 00       	mov    $0x14,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <chdir>:
SYSCALL(chdir)
 523:	b8 09 00 00 00       	mov    $0x9,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <dup>:
SYSCALL(dup)
 52b:	b8 0a 00 00 00       	mov    $0xa,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <getpid>:
SYSCALL(getpid)
 533:	b8 0b 00 00 00       	mov    $0xb,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <sbrk>:
SYSCALL(sbrk)
 53b:	b8 0c 00 00 00       	mov    $0xc,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <sleep>:
SYSCALL(sleep)
 543:	b8 0d 00 00 00       	mov    $0xd,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <uptime>:
SYSCALL(uptime)
 54b:	b8 0e 00 00 00       	mov    $0xe,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret
 553:	66 90                	xchg   %ax,%ax
 555:	66 90                	xchg   %ax,%ax
 557:	66 90                	xchg   %ax,%ax
 559:	66 90                	xchg   %ax,%ax
 55b:	66 90                	xchg   %ax,%ax
 55d:	66 90                	xchg   %ax,%ax
 55f:	90                   	nop

00000560 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 568:	89 d1                	mov    %edx,%ecx
{
 56a:	83 ec 3c             	sub    $0x3c,%esp
 56d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 570:	85 d2                	test   %edx,%edx
 572:	0f 89 80 00 00 00    	jns    5f8 <printint+0x98>
 578:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 57c:	74 7a                	je     5f8 <printint+0x98>
    x = -xx;
 57e:	f7 d9                	neg    %ecx
    neg = 1;
 580:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 585:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 588:	31 f6                	xor    %esi,%esi
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 590:	89 c8                	mov    %ecx,%eax
 592:	31 d2                	xor    %edx,%edx
 594:	89 f7                	mov    %esi,%edi
 596:	f7 f3                	div    %ebx
 598:	8d 76 01             	lea    0x1(%esi),%esi
 59b:	0f b6 92 ac 09 00 00 	movzbl 0x9ac(%edx),%edx
 5a2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5a6:	89 ca                	mov    %ecx,%edx
 5a8:	89 c1                	mov    %eax,%ecx
 5aa:	39 da                	cmp    %ebx,%edx
 5ac:	73 e2                	jae    590 <printint+0x30>
  if(neg)
 5ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5b1:	85 c0                	test   %eax,%eax
 5b3:	74 07                	je     5bc <printint+0x5c>
    buf[i++] = '-';
 5b5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 5ba:	89 f7                	mov    %esi,%edi
 5bc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 5bf:	8b 75 c0             	mov    -0x40(%ebp),%esi
 5c2:	01 df                	add    %ebx,%edi
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 5c8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 5cb:	83 ec 04             	sub    $0x4,%esp
 5ce:	88 45 d7             	mov    %al,-0x29(%ebp)
 5d1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 5d4:	6a 01                	push   $0x1
 5d6:	50                   	push   %eax
 5d7:	56                   	push   %esi
 5d8:	e8 f6 fe ff ff       	call   4d3 <write>
  while(--i >= 0)
 5dd:	89 f8                	mov    %edi,%eax
 5df:	83 c4 10             	add    $0x10,%esp
 5e2:	83 ef 01             	sub    $0x1,%edi
 5e5:	39 c3                	cmp    %eax,%ebx
 5e7:	75 df                	jne    5c8 <printint+0x68>
}
 5e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ec:	5b                   	pop    %ebx
 5ed:	5e                   	pop    %esi
 5ee:	5f                   	pop    %edi
 5ef:	5d                   	pop    %ebp
 5f0:	c3                   	ret
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5f8:	31 c0                	xor    %eax,%eax
 5fa:	eb 89                	jmp    585 <printint+0x25>
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000600 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 609:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 60c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 60f:	0f b6 1e             	movzbl (%esi),%ebx
 612:	83 c6 01             	add    $0x1,%esi
 615:	84 db                	test   %bl,%bl
 617:	74 67                	je     680 <printf+0x80>
 619:	8d 4d 10             	lea    0x10(%ebp),%ecx
 61c:	31 d2                	xor    %edx,%edx
 61e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 621:	eb 34                	jmp    657 <printf+0x57>
 623:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 628:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 62b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 630:	83 f8 25             	cmp    $0x25,%eax
 633:	74 18                	je     64d <printf+0x4d>
  write(fd, &c, 1);
 635:	83 ec 04             	sub    $0x4,%esp
 638:	8d 45 e7             	lea    -0x19(%ebp),%eax
 63b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 63e:	6a 01                	push   $0x1
 640:	50                   	push   %eax
 641:	57                   	push   %edi
 642:	e8 8c fe ff ff       	call   4d3 <write>
 647:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 64a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 64d:	0f b6 1e             	movzbl (%esi),%ebx
 650:	83 c6 01             	add    $0x1,%esi
 653:	84 db                	test   %bl,%bl
 655:	74 29                	je     680 <printf+0x80>
    c = fmt[i] & 0xff;
 657:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 65a:	85 d2                	test   %edx,%edx
 65c:	74 ca                	je     628 <printf+0x28>
      }
    } else if(state == '%'){
 65e:	83 fa 25             	cmp    $0x25,%edx
 661:	75 ea                	jne    64d <printf+0x4d>
      if(c == 'd'){
 663:	83 f8 25             	cmp    $0x25,%eax
 666:	0f 84 04 01 00 00    	je     770 <printf+0x170>
 66c:	83 e8 63             	sub    $0x63,%eax
 66f:	83 f8 15             	cmp    $0x15,%eax
 672:	77 1c                	ja     690 <printf+0x90>
 674:	ff 24 85 54 09 00 00 	jmp    *0x954(,%eax,4)
 67b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 680:	8d 65 f4             	lea    -0xc(%ebp),%esp
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret
 688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 68f:	00 
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
 693:	8d 55 e7             	lea    -0x19(%ebp),%edx
 696:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 69a:	6a 01                	push   $0x1
 69c:	52                   	push   %edx
 69d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6a0:	57                   	push   %edi
 6a1:	e8 2d fe ff ff       	call   4d3 <write>
 6a6:	83 c4 0c             	add    $0xc,%esp
 6a9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6ac:	6a 01                	push   $0x1
 6ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6b1:	52                   	push   %edx
 6b2:	57                   	push   %edi
 6b3:	e8 1b fe ff ff       	call   4d3 <write>
        putc(fd, c);
 6b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bb:	31 d2                	xor    %edx,%edx
 6bd:	eb 8e                	jmp    64d <printf+0x4d>
 6bf:	90                   	nop
        printint(fd, *ap, 16, 0);
 6c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6c3:	83 ec 0c             	sub    $0xc,%esp
 6c6:	b9 10 00 00 00       	mov    $0x10,%ecx
 6cb:	8b 13                	mov    (%ebx),%edx
 6cd:	6a 00                	push   $0x0
 6cf:	89 f8                	mov    %edi,%eax
        ap++;
 6d1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 6d4:	e8 87 fe ff ff       	call   560 <printint>
        ap++;
 6d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 67 ff ff ff       	jmp    64d <printf+0x4d>
        s = (char*)*ap;
 6e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6e9:	8b 18                	mov    (%eax),%ebx
        ap++;
 6eb:	83 c0 04             	add    $0x4,%eax
 6ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6f1:	85 db                	test   %ebx,%ebx
 6f3:	0f 84 87 00 00 00    	je     780 <printf+0x180>
        while(*s != 0){
 6f9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6fc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6fe:	84 c0                	test   %al,%al
 700:	0f 84 47 ff ff ff    	je     64d <printf+0x4d>
 706:	8d 55 e7             	lea    -0x19(%ebp),%edx
 709:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 70c:	89 de                	mov    %ebx,%esi
 70e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 716:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 719:	6a 01                	push   $0x1
 71b:	53                   	push   %ebx
 71c:	57                   	push   %edi
 71d:	e8 b1 fd ff ff       	call   4d3 <write>
        while(*s != 0){
 722:	0f b6 06             	movzbl (%esi),%eax
 725:	83 c4 10             	add    $0x10,%esp
 728:	84 c0                	test   %al,%al
 72a:	75 e4                	jne    710 <printf+0x110>
      state = 0;
 72c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 72f:	31 d2                	xor    %edx,%edx
 731:	e9 17 ff ff ff       	jmp    64d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 736:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 739:	83 ec 0c             	sub    $0xc,%esp
 73c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 741:	8b 13                	mov    (%ebx),%edx
 743:	6a 01                	push   $0x1
 745:	eb 88                	jmp    6cf <printf+0xcf>
        putc(fd, *ap);
 747:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 74a:	83 ec 04             	sub    $0x4,%esp
 74d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 750:	8b 03                	mov    (%ebx),%eax
        ap++;
 752:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 755:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 758:	6a 01                	push   $0x1
 75a:	52                   	push   %edx
 75b:	57                   	push   %edi
 75c:	e8 72 fd ff ff       	call   4d3 <write>
        ap++;
 761:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 764:	83 c4 10             	add    $0x10,%esp
      state = 0;
 767:	31 d2                	xor    %edx,%edx
 769:	e9 df fe ff ff       	jmp    64d <printf+0x4d>
 76e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 770:	83 ec 04             	sub    $0x4,%esp
 773:	88 5d e7             	mov    %bl,-0x19(%ebp)
 776:	8d 55 e7             	lea    -0x19(%ebp),%edx
 779:	6a 01                	push   $0x1
 77b:	e9 31 ff ff ff       	jmp    6b1 <printf+0xb1>
 780:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 785:	bb 4c 09 00 00       	mov    $0x94c,%ebx
 78a:	e9 77 ff ff ff       	jmp    706 <printf+0x106>
 78f:	90                   	nop

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	a1 84 0c 00 00       	mov    0xc84,%eax
{
 796:	89 e5                	mov    %esp,%ebp
 798:	57                   	push   %edi
 799:	56                   	push   %esi
 79a:	53                   	push   %ebx
 79b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 79e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	39 c8                	cmp    %ecx,%eax
 7ac:	73 32                	jae    7e0 <free+0x50>
 7ae:	39 d1                	cmp    %edx,%ecx
 7b0:	72 04                	jb     7b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	39 d0                	cmp    %edx,%eax
 7b4:	72 32                	jb     7e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7bc:	39 fa                	cmp    %edi,%edx
 7be:	74 30                	je     7f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7c3:	8b 50 04             	mov    0x4(%eax),%edx
 7c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c9:	39 f1                	cmp    %esi,%ecx
 7cb:	74 3a                	je     807 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7cd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7cf:	5b                   	pop    %ebx
  freep = p;
 7d0:	a3 84 0c 00 00       	mov    %eax,0xc84
}
 7d5:	5e                   	pop    %esi
 7d6:	5f                   	pop    %edi
 7d7:	5d                   	pop    %ebp
 7d8:	c3                   	ret
 7d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 d0                	cmp    %edx,%eax
 7e2:	72 04                	jb     7e8 <free+0x58>
 7e4:	39 d1                	cmp    %edx,%ecx
 7e6:	72 ce                	jb     7b6 <free+0x26>
{
 7e8:	89 d0                	mov    %edx,%eax
 7ea:	eb bc                	jmp    7a8 <free+0x18>
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7f0:	03 72 04             	add    0x4(%edx),%esi
 7f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 12                	mov    (%edx),%edx
 7fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 803:	39 f1                	cmp    %esi,%ecx
 805:	75 c6                	jne    7cd <free+0x3d>
    p->s.size += bp->s.size;
 807:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 80a:	a3 84 0c 00 00       	mov    %eax,0xc84
    p->s.size += bp->s.size;
 80f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 812:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 815:	89 08                	mov    %ecx,(%eax)
}
 817:	5b                   	pop    %ebx
 818:	5e                   	pop    %esi
 819:	5f                   	pop    %edi
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 829:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 82c:	8b 15 84 0c 00 00    	mov    0xc84,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	8d 78 07             	lea    0x7(%eax),%edi
 835:	c1 ef 03             	shr    $0x3,%edi
 838:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 83b:	85 d2                	test   %edx,%edx
 83d:	0f 84 8d 00 00 00    	je     8d0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 843:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 845:	8b 48 04             	mov    0x4(%eax),%ecx
 848:	39 f9                	cmp    %edi,%ecx
 84a:	73 64                	jae    8b0 <malloc+0x90>
  if(nu < 4096)
 84c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 851:	39 df                	cmp    %ebx,%edi
 853:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 856:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 85d:	eb 0a                	jmp    869 <malloc+0x49>
 85f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 862:	8b 48 04             	mov    0x4(%eax),%ecx
 865:	39 f9                	cmp    %edi,%ecx
 867:	73 47                	jae    8b0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 869:	89 c2                	mov    %eax,%edx
 86b:	3b 05 84 0c 00 00    	cmp    0xc84,%eax
 871:	75 ed                	jne    860 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 873:	83 ec 0c             	sub    $0xc,%esp
 876:	56                   	push   %esi
 877:	e8 bf fc ff ff       	call   53b <sbrk>
  if(p == (char*)-1)
 87c:	83 c4 10             	add    $0x10,%esp
 87f:	83 f8 ff             	cmp    $0xffffffff,%eax
 882:	74 1c                	je     8a0 <malloc+0x80>
  hp->s.size = nu;
 884:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 887:	83 ec 0c             	sub    $0xc,%esp
 88a:	83 c0 08             	add    $0x8,%eax
 88d:	50                   	push   %eax
 88e:	e8 fd fe ff ff       	call   790 <free>
  return freep;
 893:	8b 15 84 0c 00 00    	mov    0xc84,%edx
      if((p = morecore(nunits)) == 0)
 899:	83 c4 10             	add    $0x10,%esp
 89c:	85 d2                	test   %edx,%edx
 89e:	75 c0                	jne    860 <malloc+0x40>
        return 0;
  }
}
 8a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8a3:	31 c0                	xor    %eax,%eax
}
 8a5:	5b                   	pop    %ebx
 8a6:	5e                   	pop    %esi
 8a7:	5f                   	pop    %edi
 8a8:	5d                   	pop    %ebp
 8a9:	c3                   	ret
 8aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8b0:	39 cf                	cmp    %ecx,%edi
 8b2:	74 4c                	je     900 <malloc+0xe0>
        p->s.size -= nunits;
 8b4:	29 f9                	sub    %edi,%ecx
 8b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8bf:	89 15 84 0c 00 00    	mov    %edx,0xc84
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
 8d0:	c7 05 84 0c 00 00 88 	movl   $0xc88,0xc84
 8d7:	0c 00 00 
    base.s.size = 0;
 8da:	b8 88 0c 00 00       	mov    $0xc88,%eax
    base.s.ptr = freep = prevp = &base;
 8df:	c7 05 88 0c 00 00 88 	movl   $0xc88,0xc88
 8e6:	0c 00 00 
    base.s.size = 0;
 8e9:	c7 05 8c 0c 00 00 00 	movl   $0x0,0xc8c
 8f0:	00 00 00 
    if(p->s.size >= nunits){
 8f3:	e9 54 ff ff ff       	jmp    84c <malloc+0x2c>
 8f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8ff:	00 
        prevp->s.ptr = p->s.ptr;
 900:	8b 08                	mov    (%eax),%ecx
 902:	89 0a                	mov    %ecx,(%edx)
 904:	eb b9                	jmp    8bf <malloc+0x9f>
