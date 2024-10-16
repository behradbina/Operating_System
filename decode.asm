
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
  59:	0f 85 1c 01 00 00    	jne    17b <main+0x17b>
    if(argc <2){
  5f:	83 ef 01             	sub    $0x1,%edi
    char* text_to_encode[argc-1];
  62:	89 e6                	mov    %esp,%esi
    if(argc <2){
  64:	0f 8e c6 00 00 00    	jle    130 <main+0x130>
  6a:	8d 41 04             	lea    0x4(%ecx),%eax
  6d:	89 f7                	mov    %esi,%edi
  6f:	8d 4c 11 04          	lea    0x4(%ecx,%edx,1),%ecx
  73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
    for (int i=0;i<argc-1;i++){
  8a:	31 ff                	xor    %edi,%edi
         printf(1,'%c','\n');
  8c:	6a 0a                	push   $0xa
  8e:	68 63 25 00 00       	push   $0x2563
  93:	6a 01                	push   $0x1
  95:	e8 f6 04 00 00       	call   590 <printf>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	8d 76 00             	lea    0x0(%esi),%esi
        //printf(1,text_to_encode[i]);
        //printf(1,"functions: \n");
        cesar_encode(text_to_encode[i],1);
  a0:	83 ec 08             	sub    $0x8,%esp
  a3:	6a 01                	push   $0x1
  a5:	ff 34 be             	push   (%esi,%edi,4)
    for (int i=0;i<argc-1;i++){
  a8:	83 c7 01             	add    $0x1,%edi
        cesar_encode(text_to_encode[i],1);
  ab:	e8 e0 00 00 00       	call   190 <cesar_encode>
    for (int i=0;i<argc-1;i++){
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	39 fb                	cmp    %edi,%ebx
  b5:	75 e9                	jne    a0 <main+0xa0>
       // printf(1,text_to_encode[i]);
       // printf(1,'%c','\n');
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
  b7:	83 ec 08             	sub    $0x8,%esp
  ba:	68 02 02 00 00       	push   $0x202
  bf:	68 b4 08 00 00       	push   $0x8b4
  c4:	e8 ba 03 00 00       	call   483 <open>
       // printf(1,"hi \n");
        char * space=" ";
        if (fd <0){
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	85 c0                	test   %eax,%eax
  ce:	0f 88 94 00 00 00    	js     168 <main+0x168>
            printf(1,"Unable to open or create file");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
  d4:	31 ff                	xor    %edi,%edi
  d6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  d9:	89 c3                	mov    %eax,%ebx
  db:	89 75 e0             	mov    %esi,-0x20(%ebp)
  de:	89 fe                	mov    %edi,%esi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
  e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	8b 3c b0             	mov    (%eax,%esi,4),%edi
            for (int i=0;i<argc-1;i++){
  e9:	83 c6 01             	add    $0x1,%esi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
  ec:	57                   	push   %edi
  ed:	e8 9e 01 00 00       	call   290 <strlen>
  f2:	83 c4 0c             	add    $0xc,%esp
  f5:	50                   	push   %eax
  f6:	57                   	push   %edi
  f7:	53                   	push   %ebx
  f8:	e8 66 03 00 00       	call   463 <write>
                write(fd,space,strlen(space));
  fd:	c7 04 24 dd 08 00 00 	movl   $0x8dd,(%esp)
 104:	e8 87 01 00 00       	call   290 <strlen>
 109:	83 c4 0c             	add    $0xc,%esp
 10c:	50                   	push   %eax
 10d:	68 dd 08 00 00       	push   $0x8dd
 112:	53                   	push   %ebx
 113:	e8 4b 03 00 00       	call   463 <write>
            for (int i=0;i<argc-1;i++){
 118:	83 c4 10             	add    $0x10,%esp
 11b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
 11e:	75 c0                	jne    e0 <main+0xe0>
 120:	89 d9                	mov    %ebx,%ecx

            //printf(1,"hi2");


        }
        close(fd);
 122:	83 ec 0c             	sub    $0xc,%esp
 125:	51                   	push   %ecx
 126:	e8 40 03 00 00       	call   46b <close>
    exit();
 12b:	e8 13 03 00 00       	call   443 <exit>
        printf(1,"no text to encode passed");
 130:	52                   	push   %edx
 131:	52                   	push   %edx
 132:	68 9b 08 00 00       	push   $0x89b
 137:	6a 01                	push   $0x1
 139:	e8 52 04 00 00       	call   590 <printf>
         printf(1,'%c','\n');
 13e:	83 c4 0c             	add    $0xc,%esp
 141:	6a 0a                	push   $0xa
 143:	68 63 25 00 00       	push   $0x2563
 148:	6a 01                	push   $0x1
 14a:	e8 41 04 00 00       	call   590 <printf>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 14f:	59                   	pop    %ecx
 150:	5b                   	pop    %ebx
 151:	68 02 02 00 00       	push   $0x202
 156:	68 b4 08 00 00       	push   $0x8b4
 15b:	e8 23 03 00 00       	call   483 <open>
        if (fd <0){
 160:	89 f4                	mov    %esi,%esp
        int fd=open("result.txt",O_CREATE|O_RDWR);
 162:	89 c1                	mov    %eax,%ecx
        if (fd <0){
 164:	85 c0                	test   %eax,%eax
 166:	79 ba                	jns    122 <main+0x122>
            printf(1,"Unable to open or create file");
 168:	50                   	push   %eax
 169:	50                   	push   %eax
 16a:	68 bf 08 00 00       	push   $0x8bf
 16f:	6a 01                	push   $0x1
 171:	e8 1a 04 00 00       	call   590 <printf>
            exit();
 176:	e8 c8 02 00 00       	call   443 <exit>
    char* text_to_encode[argc-1];
 17b:	83 4c 04 fc 00       	orl    $0x0,-0x4(%esp,%eax,1)
 180:	e9 da fe ff ff       	jmp    5f <main+0x5f>
 185:	66 90                	xchg   %ax,%ax
 187:	66 90                	xchg   %ax,%ax
 189:	66 90                	xchg   %ax,%ax
 18b:	66 90                	xchg   %ax,%ax
 18d:	66 90                	xchg   %ax,%ax
 18f:	90                   	nop

00000190 <cesar_encode>:
void cesar_encode(char* text,int shift){
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	8b 75 08             	mov    0x8(%ebp),%esi
        text[i]=(c-shift);
 198:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
    for (int i=0;text[i]!='\0';i++)
 19c:	0f b6 16             	movzbl (%esi),%edx
 19f:	84 d2                	test   %dl,%dl
 1a1:	75 2e                	jne    1d1 <cesar_encode+0x41>
 1a3:	eb 4b                	jmp    1f0 <cesar_encode+0x60>
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
        if(  c>='a' && c<='z' && text[i]<'a')
 1a8:	3c 60                	cmp    $0x60,%al
 1aa:	7f 05                	jg     1b1 <cesar_encode+0x21>
        text[i]+=26;
 1ac:	83 c0 1a             	add    $0x1a,%eax
 1af:	88 06                	mov    %al,(%esi)
        printf(1,"%c",text[i]);
 1b1:	83 ec 04             	sub    $0x4,%esp
 1b4:	0f be c0             	movsbl %al,%eax
    for (int i=0;text[i]!='\0';i++)
 1b7:	83 c6 01             	add    $0x1,%esi
        printf(1,"%c",text[i]);
 1ba:	50                   	push   %eax
 1bb:	68 98 08 00 00       	push   $0x898
 1c0:	6a 01                	push   $0x1
 1c2:	e8 c9 03 00 00       	call   590 <printf>
    for (int i=0;text[i]!='\0';i++)
 1c7:	0f b6 16             	movzbl (%esi),%edx
 1ca:	83 c4 10             	add    $0x10,%esp
 1cd:	84 d2                	test   %dl,%dl
 1cf:	74 1f                	je     1f0 <cesar_encode+0x60>
        text[i]=(c-shift);
 1d1:	89 d0                	mov    %edx,%eax
        if(  c>='a' && c<='z' && text[i]<'a')
 1d3:	8d 4a 9f             	lea    -0x61(%edx),%ecx
        text[i]=(c-shift);
 1d6:	29 d8                	sub    %ebx,%eax
 1d8:	88 06                	mov    %al,(%esi)
        if(  c>='a' && c<='z' && text[i]<'a')
 1da:	80 f9 19             	cmp    $0x19,%cl
 1dd:	76 c9                	jbe    1a8 <cesar_encode+0x18>
         if( c<='Z' && c>='A' && text[i]<'A')
 1df:	83 ea 41             	sub    $0x41,%edx
 1e2:	80 fa 19             	cmp    $0x19,%dl
 1e5:	77 ca                	ja     1b1 <cesar_encode+0x21>
 1e7:	3c 40                	cmp    $0x40,%al
 1e9:	7f c6                	jg     1b1 <cesar_encode+0x21>
 1eb:	eb bf                	jmp    1ac <cesar_encode+0x1c>
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
}
 1f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f3:	5b                   	pop    %ebx
 1f4:	5e                   	pop    %esi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret
 1f7:	66 90                	xchg   %ax,%ax
 1f9:	66 90                	xchg   %ax,%ax
 1fb:	66 90                	xchg   %ax,%ax
 1fd:	66 90                	xchg   %ax,%ax
 1ff:	90                   	nop

00000200 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 200:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 201:	31 c0                	xor    %eax,%eax
{
 203:	89 e5                	mov    %esp,%ebp
 205:	53                   	push   %ebx
 206:	8b 4d 08             	mov    0x8(%ebp),%ecx
 209:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 210:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 214:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 217:	83 c0 01             	add    $0x1,%eax
 21a:	84 d2                	test   %dl,%dl
 21c:	75 f2                	jne    210 <strcpy+0x10>
    ;
  return os;
}
 21e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 221:	89 c8                	mov    %ecx,%eax
 223:	c9                   	leave
 224:	c3                   	ret
 225:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22c:	00 
 22d:	8d 76 00             	lea    0x0(%esi),%esi

00000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 55 08             	mov    0x8(%ebp),%edx
 237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 23a:	0f b6 02             	movzbl (%edx),%eax
 23d:	84 c0                	test   %al,%al
 23f:	75 17                	jne    258 <strcmp+0x28>
 241:	eb 3a                	jmp    27d <strcmp+0x4d>
 243:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 248:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 24c:	83 c2 01             	add    $0x1,%edx
 24f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 252:	84 c0                	test   %al,%al
 254:	74 1a                	je     270 <strcmp+0x40>
 256:	89 d9                	mov    %ebx,%ecx
 258:	0f b6 19             	movzbl (%ecx),%ebx
 25b:	38 c3                	cmp    %al,%bl
 25d:	74 e9                	je     248 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 25f:	29 d8                	sub    %ebx,%eax
}
 261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 264:	c9                   	leave
 265:	c3                   	ret
 266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26d:	00 
 26e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 270:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 274:	31 c0                	xor    %eax,%eax
 276:	29 d8                	sub    %ebx,%eax
}
 278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 27b:	c9                   	leave
 27c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 27d:	0f b6 19             	movzbl (%ecx),%ebx
 280:	31 c0                	xor    %eax,%eax
 282:	eb db                	jmp    25f <strcmp+0x2f>
 284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 28b:	00 
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <strlen>:

uint
strlen(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 296:	80 3a 00             	cmpb   $0x0,(%edx)
 299:	74 15                	je     2b0 <strlen+0x20>
 29b:	31 c0                	xor    %eax,%eax
 29d:	8d 76 00             	lea    0x0(%esi),%esi
 2a0:	83 c0 01             	add    $0x1,%eax
 2a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2a7:	89 c1                	mov    %eax,%ecx
 2a9:	75 f5                	jne    2a0 <strlen+0x10>
    ;
  return n;
}
 2ab:	89 c8                	mov    %ecx,%eax
 2ad:	5d                   	pop    %ebp
 2ae:	c3                   	ret
 2af:	90                   	nop
  for(n = 0; s[n]; n++)
 2b0:	31 c9                	xor    %ecx,%ecx
}
 2b2:	5d                   	pop    %ebp
 2b3:	89 c8                	mov    %ecx,%eax
 2b5:	c3                   	ret
 2b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bd:	00 
 2be:	66 90                	xchg   %ax,%ax

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 d7                	mov    %edx,%edi
 2cf:	fc                   	cld
 2d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2d5:	89 d0                	mov    %edx,%eax
 2d7:	c9                   	leave
 2d8:	c3                   	ret
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ea:	0f b6 10             	movzbl (%eax),%edx
 2ed:	84 d2                	test   %dl,%dl
 2ef:	75 12                	jne    303 <strchr+0x23>
 2f1:	eb 1d                	jmp    310 <strchr+0x30>
 2f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2fc:	83 c0 01             	add    $0x1,%eax
 2ff:	84 d2                	test   %dl,%dl
 301:	74 0d                	je     310 <strchr+0x30>
    if(*s == c)
 303:	38 d1                	cmp    %dl,%cl
 305:	75 f1                	jne    2f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 307:	5d                   	pop    %ebp
 308:	c3                   	ret
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 310:	31 c0                	xor    %eax,%eax
}
 312:	5d                   	pop    %ebp
 313:	c3                   	ret
 314:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 31b:	00 
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000320 <gets>:

char*
gets(char *buf, int max)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 325:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 328:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 329:	31 db                	xor    %ebx,%ebx
{
 32b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 32e:	eb 27                	jmp    357 <gets+0x37>
    cc = read(0, &c, 1);
 330:	83 ec 04             	sub    $0x4,%esp
 333:	6a 01                	push   $0x1
 335:	56                   	push   %esi
 336:	6a 00                	push   $0x0
 338:	e8 1e 01 00 00       	call   45b <read>
    if(cc < 1)
 33d:	83 c4 10             	add    $0x10,%esp
 340:	85 c0                	test   %eax,%eax
 342:	7e 1d                	jle    361 <gets+0x41>
      break;
    buf[i++] = c;
 344:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 348:	8b 55 08             	mov    0x8(%ebp),%edx
 34b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 34f:	3c 0a                	cmp    $0xa,%al
 351:	74 10                	je     363 <gets+0x43>
 353:	3c 0d                	cmp    $0xd,%al
 355:	74 0c                	je     363 <gets+0x43>
  for(i=0; i+1 < max; ){
 357:	89 df                	mov    %ebx,%edi
 359:	83 c3 01             	add    $0x1,%ebx
 35c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 35f:	7c cf                	jl     330 <gets+0x10>
 361:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 36a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36d:	5b                   	pop    %ebx
 36e:	5e                   	pop    %esi
 36f:	5f                   	pop    %edi
 370:	5d                   	pop    %ebp
 371:	c3                   	ret
 372:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 379:	00 
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <stat>:

int
stat(const char *n, struct stat *st)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 385:	83 ec 08             	sub    $0x8,%esp
 388:	6a 00                	push   $0x0
 38a:	ff 75 08             	push   0x8(%ebp)
 38d:	e8 f1 00 00 00       	call   483 <open>
  if(fd < 0)
 392:	83 c4 10             	add    $0x10,%esp
 395:	85 c0                	test   %eax,%eax
 397:	78 27                	js     3c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 399:	83 ec 08             	sub    $0x8,%esp
 39c:	ff 75 0c             	push   0xc(%ebp)
 39f:	89 c3                	mov    %eax,%ebx
 3a1:	50                   	push   %eax
 3a2:	e8 f4 00 00 00       	call   49b <fstat>
  close(fd);
 3a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3aa:	89 c6                	mov    %eax,%esi
  close(fd);
 3ac:	e8 ba 00 00 00       	call   46b <close>
  return r;
 3b1:	83 c4 10             	add    $0x10,%esp
}
 3b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3b7:	89 f0                	mov    %esi,%eax
 3b9:	5b                   	pop    %ebx
 3ba:	5e                   	pop    %esi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3c5:	eb ed                	jmp    3b4 <stat+0x34>
 3c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ce:	00 
 3cf:	90                   	nop

000003d0 <atoi>:

int
atoi(const char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d7:	0f be 02             	movsbl (%edx),%eax
 3da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3e5:	77 1e                	ja     405 <atoi+0x35>
 3e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ee:	00 
 3ef:	90                   	nop
    n = n*10 + *s++ - '0';
 3f0:	83 c2 01             	add    $0x1,%edx
 3f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3fa:	0f be 02             	movsbl (%edx),%eax
 3fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 400:	80 fb 09             	cmp    $0x9,%bl
 403:	76 eb                	jbe    3f0 <atoi+0x20>
  return n;
}
 405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 408:	89 c8                	mov    %ecx,%eax
 40a:	c9                   	leave
 40b:	c3                   	ret
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	8b 45 10             	mov    0x10(%ebp),%eax
 417:	8b 55 08             	mov    0x8(%ebp),%edx
 41a:	56                   	push   %esi
 41b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 41e:	85 c0                	test   %eax,%eax
 420:	7e 13                	jle    435 <memmove+0x25>
 422:	01 d0                	add    %edx,%eax
  dst = vdst;
 424:	89 d7                	mov    %edx,%edi
 426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42d:	00 
 42e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 430:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 431:	39 f8                	cmp    %edi,%eax
 433:	75 fb                	jne    430 <memmove+0x20>
  return vdst;
}
 435:	5e                   	pop    %esi
 436:	89 d0                	mov    %edx,%eax
 438:	5f                   	pop    %edi
 439:	5d                   	pop    %ebp
 43a:	c3                   	ret

0000043b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43b:	b8 01 00 00 00       	mov    $0x1,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <exit>:
SYSCALL(exit)
 443:	b8 02 00 00 00       	mov    $0x2,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <wait>:
SYSCALL(wait)
 44b:	b8 03 00 00 00       	mov    $0x3,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <pipe>:
SYSCALL(pipe)
 453:	b8 04 00 00 00       	mov    $0x4,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <read>:
SYSCALL(read)
 45b:	b8 05 00 00 00       	mov    $0x5,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <write>:
SYSCALL(write)
 463:	b8 10 00 00 00       	mov    $0x10,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <close>:
SYSCALL(close)
 46b:	b8 15 00 00 00       	mov    $0x15,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <kill>:
SYSCALL(kill)
 473:	b8 06 00 00 00       	mov    $0x6,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <exec>:
SYSCALL(exec)
 47b:	b8 07 00 00 00       	mov    $0x7,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <open>:
SYSCALL(open)
 483:	b8 0f 00 00 00       	mov    $0xf,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <mknod>:
SYSCALL(mknod)
 48b:	b8 11 00 00 00       	mov    $0x11,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <unlink>:
SYSCALL(unlink)
 493:	b8 12 00 00 00       	mov    $0x12,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <fstat>:
SYSCALL(fstat)
 49b:	b8 08 00 00 00       	mov    $0x8,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <link>:
SYSCALL(link)
 4a3:	b8 13 00 00 00       	mov    $0x13,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <mkdir>:
SYSCALL(mkdir)
 4ab:	b8 14 00 00 00       	mov    $0x14,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <chdir>:
SYSCALL(chdir)
 4b3:	b8 09 00 00 00       	mov    $0x9,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <dup>:
SYSCALL(dup)
 4bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <getpid>:
SYSCALL(getpid)
 4c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <sbrk>:
SYSCALL(sbrk)
 4cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <sleep>:
SYSCALL(sleep)
 4d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <uptime>:
SYSCALL(uptime)
 4db:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret
 4e3:	66 90                	xchg   %ax,%ax
 4e5:	66 90                	xchg   %ax,%ax
 4e7:	66 90                	xchg   %ax,%ax
 4e9:	66 90                	xchg   %ax,%ax
 4eb:	66 90                	xchg   %ax,%ax
 4ed:	66 90                	xchg   %ax,%ax
 4ef:	90                   	nop

000004f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4f8:	89 d1                	mov    %edx,%ecx
{
 4fa:	83 ec 3c             	sub    $0x3c,%esp
 4fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 500:	85 d2                	test   %edx,%edx
 502:	0f 89 80 00 00 00    	jns    588 <printint+0x98>
 508:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 50c:	74 7a                	je     588 <printint+0x98>
    x = -xx;
 50e:	f7 d9                	neg    %ecx
    neg = 1;
 510:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 515:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 518:	31 f6                	xor    %esi,%esi
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 520:	89 c8                	mov    %ecx,%eax
 522:	31 d2                	xor    %edx,%edx
 524:	89 f7                	mov    %esi,%edi
 526:	f7 f3                	div    %ebx
 528:	8d 76 01             	lea    0x1(%esi),%esi
 52b:	0f b6 92 40 09 00 00 	movzbl 0x940(%edx),%edx
 532:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 536:	89 ca                	mov    %ecx,%edx
 538:	89 c1                	mov    %eax,%ecx
 53a:	39 da                	cmp    %ebx,%edx
 53c:	73 e2                	jae    520 <printint+0x30>
  if(neg)
 53e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 541:	85 c0                	test   %eax,%eax
 543:	74 07                	je     54c <printint+0x5c>
    buf[i++] = '-';
 545:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 54a:	89 f7                	mov    %esi,%edi
 54c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 54f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 552:	01 df                	add    %ebx,%edi
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 558:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 55b:	83 ec 04             	sub    $0x4,%esp
 55e:	88 45 d7             	mov    %al,-0x29(%ebp)
 561:	8d 45 d7             	lea    -0x29(%ebp),%eax
 564:	6a 01                	push   $0x1
 566:	50                   	push   %eax
 567:	56                   	push   %esi
 568:	e8 f6 fe ff ff       	call   463 <write>
  while(--i >= 0)
 56d:	89 f8                	mov    %edi,%eax
 56f:	83 c4 10             	add    $0x10,%esp
 572:	83 ef 01             	sub    $0x1,%edi
 575:	39 c3                	cmp    %eax,%ebx
 577:	75 df                	jne    558 <printint+0x68>
}
 579:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57c:	5b                   	pop    %ebx
 57d:	5e                   	pop    %esi
 57e:	5f                   	pop    %edi
 57f:	5d                   	pop    %ebp
 580:	c3                   	ret
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 588:	31 c0                	xor    %eax,%eax
 58a:	eb 89                	jmp    515 <printint+0x25>
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
 599:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 59c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 59f:	0f b6 1e             	movzbl (%esi),%ebx
 5a2:	83 c6 01             	add    $0x1,%esi
 5a5:	84 db                	test   %bl,%bl
 5a7:	74 67                	je     610 <printf+0x80>
 5a9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5ac:	31 d2                	xor    %edx,%edx
 5ae:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5b1:	eb 34                	jmp    5e7 <printf+0x57>
 5b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5bb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5c0:	83 f8 25             	cmp    $0x25,%eax
 5c3:	74 18                	je     5dd <printf+0x4d>
  write(fd, &c, 1);
 5c5:	83 ec 04             	sub    $0x4,%esp
 5c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5cb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ce:	6a 01                	push   $0x1
 5d0:	50                   	push   %eax
 5d1:	57                   	push   %edi
 5d2:	e8 8c fe ff ff       	call   463 <write>
 5d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5da:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5dd:	0f b6 1e             	movzbl (%esi),%ebx
 5e0:	83 c6 01             	add    $0x1,%esi
 5e3:	84 db                	test   %bl,%bl
 5e5:	74 29                	je     610 <printf+0x80>
    c = fmt[i] & 0xff;
 5e7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5ea:	85 d2                	test   %edx,%edx
 5ec:	74 ca                	je     5b8 <printf+0x28>
      }
    } else if(state == '%'){
 5ee:	83 fa 25             	cmp    $0x25,%edx
 5f1:	75 ea                	jne    5dd <printf+0x4d>
      if(c == 'd'){
 5f3:	83 f8 25             	cmp    $0x25,%eax
 5f6:	0f 84 04 01 00 00    	je     700 <printf+0x170>
 5fc:	83 e8 63             	sub    $0x63,%eax
 5ff:	83 f8 15             	cmp    $0x15,%eax
 602:	77 1c                	ja     620 <printf+0x90>
 604:	ff 24 85 e8 08 00 00 	jmp    *0x8e8(,%eax,4)
 60b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
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
 618:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 61f:	00 
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	8d 55 e7             	lea    -0x19(%ebp),%edx
 626:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 62a:	6a 01                	push   $0x1
 62c:	52                   	push   %edx
 62d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 630:	57                   	push   %edi
 631:	e8 2d fe ff ff       	call   463 <write>
 636:	83 c4 0c             	add    $0xc,%esp
 639:	88 5d e7             	mov    %bl,-0x19(%ebp)
 63c:	6a 01                	push   $0x1
 63e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 641:	52                   	push   %edx
 642:	57                   	push   %edi
 643:	e8 1b fe ff ff       	call   463 <write>
        putc(fd, c);
 648:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64b:	31 d2                	xor    %edx,%edx
 64d:	eb 8e                	jmp    5dd <printf+0x4d>
 64f:	90                   	nop
        printint(fd, *ap, 16, 0);
 650:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	b9 10 00 00 00       	mov    $0x10,%ecx
 65b:	8b 13                	mov    (%ebx),%edx
 65d:	6a 00                	push   $0x0
 65f:	89 f8                	mov    %edi,%eax
        ap++;
 661:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 664:	e8 87 fe ff ff       	call   4f0 <printint>
        ap++;
 669:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 66c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66f:	31 d2                	xor    %edx,%edx
 671:	e9 67 ff ff ff       	jmp    5dd <printf+0x4d>
        s = (char*)*ap;
 676:	8b 45 d0             	mov    -0x30(%ebp),%eax
 679:	8b 18                	mov    (%eax),%ebx
        ap++;
 67b:	83 c0 04             	add    $0x4,%eax
 67e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 681:	85 db                	test   %ebx,%ebx
 683:	0f 84 87 00 00 00    	je     710 <printf+0x180>
        while(*s != 0){
 689:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 68c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 68e:	84 c0                	test   %al,%al
 690:	0f 84 47 ff ff ff    	je     5dd <printf+0x4d>
 696:	8d 55 e7             	lea    -0x19(%ebp),%edx
 699:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 69c:	89 de                	mov    %ebx,%esi
 69e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
 6a3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6a6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6a9:	6a 01                	push   $0x1
 6ab:	53                   	push   %ebx
 6ac:	57                   	push   %edi
 6ad:	e8 b1 fd ff ff       	call   463 <write>
        while(*s != 0){
 6b2:	0f b6 06             	movzbl (%esi),%eax
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	84 c0                	test   %al,%al
 6ba:	75 e4                	jne    6a0 <printf+0x110>
      state = 0;
 6bc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6bf:	31 d2                	xor    %edx,%edx
 6c1:	e9 17 ff ff ff       	jmp    5dd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6c6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6c9:	83 ec 0c             	sub    $0xc,%esp
 6cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d1:	8b 13                	mov    (%ebx),%edx
 6d3:	6a 01                	push   $0x1
 6d5:	eb 88                	jmp    65f <printf+0xcf>
        putc(fd, *ap);
 6d7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6da:	83 ec 04             	sub    $0x4,%esp
 6dd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6e0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6e2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6e5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
 6ea:	52                   	push   %edx
 6eb:	57                   	push   %edi
 6ec:	e8 72 fd ff ff       	call   463 <write>
        ap++;
 6f1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6f4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f7:	31 d2                	xor    %edx,%edx
 6f9:	e9 df fe ff ff       	jmp    5dd <printf+0x4d>
 6fe:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 5d e7             	mov    %bl,-0x19(%ebp)
 706:	8d 55 e7             	lea    -0x19(%ebp),%edx
 709:	6a 01                	push   $0x1
 70b:	e9 31 ff ff ff       	jmp    641 <printf+0xb1>
 710:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 715:	bb df 08 00 00       	mov    $0x8df,%ebx
 71a:	e9 77 ff ff ff       	jmp    696 <printf+0x106>
 71f:	90                   	nop

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 10 0c 00 00       	mov    0xc10,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	39 c8                	cmp    %ecx,%eax
 73c:	73 32                	jae    770 <free+0x50>
 73e:	39 d1                	cmp    %edx,%ecx
 740:	72 04                	jb     746 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	39 d0                	cmp    %edx,%eax
 744:	72 32                	jb     778 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 746:	8b 73 fc             	mov    -0x4(%ebx),%esi
 749:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74c:	39 fa                	cmp    %edi,%edx
 74e:	74 30                	je     780 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 753:	8b 50 04             	mov    0x4(%eax),%edx
 756:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 759:	39 f1                	cmp    %esi,%ecx
 75b:	74 3a                	je     797 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 75d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 75f:	5b                   	pop    %ebx
  freep = p;
 760:	a3 10 0c 00 00       	mov    %eax,0xc10
}
 765:	5e                   	pop    %esi
 766:	5f                   	pop    %edi
 767:	5d                   	pop    %ebp
 768:	c3                   	ret
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	39 d0                	cmp    %edx,%eax
 772:	72 04                	jb     778 <free+0x58>
 774:	39 d1                	cmp    %edx,%ecx
 776:	72 ce                	jb     746 <free+0x26>
{
 778:	89 d0                	mov    %edx,%eax
 77a:	eb bc                	jmp    738 <free+0x18>
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 780:	03 72 04             	add    0x4(%edx),%esi
 783:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 12                	mov    (%edx),%edx
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	75 c6                	jne    75d <free+0x3d>
    p->s.size += bp->s.size;
 797:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 79a:	a3 10 0c 00 00       	mov    %eax,0xc10
    p->s.size += bp->s.size;
 79f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7a5:	89 08                	mov    %ecx,(%eax)
}
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 15 10 0c 00 00    	mov    0xc10,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 78 07             	lea    0x7(%eax),%edi
 7c5:	c1 ef 03             	shr    $0x3,%edi
 7c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7cb:	85 d2                	test   %edx,%edx
 7cd:	0f 84 8d 00 00 00    	je     860 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
 7d8:	39 f9                	cmp    %edi,%ecx
 7da:	73 64                	jae    840 <malloc+0x90>
  if(nu < 4096)
 7dc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e1:	39 df                	cmp    %ebx,%edi
 7e3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7e6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7ed:	eb 0a                	jmp    7f9 <malloc+0x49>
 7ef:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f2:	8b 48 04             	mov    0x4(%eax),%ecx
 7f5:	39 f9                	cmp    %edi,%ecx
 7f7:	73 47                	jae    840 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f9:	89 c2                	mov    %eax,%edx
 7fb:	3b 05 10 0c 00 00    	cmp    0xc10,%eax
 801:	75 ed                	jne    7f0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	56                   	push   %esi
 807:	e8 bf fc ff ff       	call   4cb <sbrk>
  if(p == (char*)-1)
 80c:	83 c4 10             	add    $0x10,%esp
 80f:	83 f8 ff             	cmp    $0xffffffff,%eax
 812:	74 1c                	je     830 <malloc+0x80>
  hp->s.size = nu;
 814:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 817:	83 ec 0c             	sub    $0xc,%esp
 81a:	83 c0 08             	add    $0x8,%eax
 81d:	50                   	push   %eax
 81e:	e8 fd fe ff ff       	call   720 <free>
  return freep;
 823:	8b 15 10 0c 00 00    	mov    0xc10,%edx
      if((p = morecore(nunits)) == 0)
 829:	83 c4 10             	add    $0x10,%esp
 82c:	85 d2                	test   %edx,%edx
 82e:	75 c0                	jne    7f0 <malloc+0x40>
        return 0;
  }
}
 830:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 833:	31 c0                	xor    %eax,%eax
}
 835:	5b                   	pop    %ebx
 836:	5e                   	pop    %esi
 837:	5f                   	pop    %edi
 838:	5d                   	pop    %ebp
 839:	c3                   	ret
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 840:	39 cf                	cmp    %ecx,%edi
 842:	74 4c                	je     890 <malloc+0xe0>
        p->s.size -= nunits;
 844:	29 f9                	sub    %edi,%ecx
 846:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 849:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 84c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 84f:	89 15 10 0c 00 00    	mov    %edx,0xc10
}
 855:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 858:	83 c0 08             	add    $0x8,%eax
}
 85b:	5b                   	pop    %ebx
 85c:	5e                   	pop    %esi
 85d:	5f                   	pop    %edi
 85e:	5d                   	pop    %ebp
 85f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 860:	c7 05 10 0c 00 00 14 	movl   $0xc14,0xc10
 867:	0c 00 00 
    base.s.size = 0;
 86a:	b8 14 0c 00 00       	mov    $0xc14,%eax
    base.s.ptr = freep = prevp = &base;
 86f:	c7 05 14 0c 00 00 14 	movl   $0xc14,0xc14
 876:	0c 00 00 
    base.s.size = 0;
 879:	c7 05 18 0c 00 00 00 	movl   $0x0,0xc18
 880:	00 00 00 
    if(p->s.size >= nunits){
 883:	e9 54 ff ff ff       	jmp    7dc <malloc+0x2c>
 888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 88f:	00 
        prevp->s.ptr = p->s.ptr;
 890:	8b 08                	mov    (%eax),%ecx
 892:	89 0a                	mov    %ecx,(%edx)
 894:	eb b9                	jmp    84f <malloc+0x9f>
