
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 d8 07 00 00       	push   $0x7d8
  19:	e8 65 03 00 00       	call   383 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 a7 00 00 00    	js     d0 <main+0xd0>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 88 03 00 00       	call   3bb <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 7c 03 00 00       	call   3bb <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 e0 07 00 00       	push   $0x7e0
  50:	6a 01                	push   $0x1
  52:	e8 79 04 00 00       	call   4d0 <printf>
    printf(1, "Team Members:Marziyeh Mousavi, Behrad Binayi, Mehrad liviyan\n");
  57:	58                   	pop    %eax
  58:	5a                   	pop    %edx
  59:	68 30 08 00 00       	push   $0x830
  5e:	6a 01                	push   $0x1
  60:	e8 6b 04 00 00       	call   4d0 <printf>
    pid = fork();
  65:	e8 d1 02 00 00       	call   33b <fork>
    if(pid < 0){
  6a:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  6d:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  6f:	85 c0                	test   %eax,%eax
  71:	78 26                	js     99 <main+0x99>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  73:	74 37                	je     ac <main+0xac>
  75:	8d 76 00             	lea    0x0(%esi),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  78:	e8 ce 02 00 00       	call   34b <wait>
  7d:	85 c0                	test   %eax,%eax
  7f:	78 c7                	js     48 <main+0x48>
  81:	39 c3                	cmp    %eax,%ebx
  83:	74 c3                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 1f 08 00 00       	push   $0x81f
  8d:	6a 01                	push   $0x1
  8f:	e8 3c 04 00 00       	call   4d0 <printf>
  94:	83 c4 10             	add    $0x10,%esp
  97:	eb df                	jmp    78 <main+0x78>
      printf(1, "init: fork failed\n");
  99:	53                   	push   %ebx
  9a:	53                   	push   %ebx
  9b:	68 f3 07 00 00       	push   $0x7f3
  a0:	6a 01                	push   $0x1
  a2:	e8 29 04 00 00       	call   4d0 <printf>
      exit();
  a7:	e8 97 02 00 00       	call   343 <exit>
      exec("sh", argv);
  ac:	50                   	push   %eax
  ad:	50                   	push   %eax
  ae:	68 68 0b 00 00       	push   $0xb68
  b3:	68 06 08 00 00       	push   $0x806
  b8:	e8 be 02 00 00       	call   37b <exec>
      printf(1, "init: exec sh failed\n");
  bd:	5a                   	pop    %edx
  be:	59                   	pop    %ecx
  bf:	68 09 08 00 00       	push   $0x809
  c4:	6a 01                	push   $0x1
  c6:	e8 05 04 00 00       	call   4d0 <printf>
      exit();
  cb:	e8 73 02 00 00       	call   343 <exit>
    mknod("console", 1, 1);
  d0:	51                   	push   %ecx
  d1:	6a 01                	push   $0x1
  d3:	6a 01                	push   $0x1
  d5:	68 d8 07 00 00       	push   $0x7d8
  da:	e8 ac 02 00 00       	call   38b <mknod>
    open("console", O_RDWR);
  df:	5b                   	pop    %ebx
  e0:	58                   	pop    %eax
  e1:	6a 02                	push   $0x2
  e3:	68 d8 07 00 00       	push   $0x7d8
  e8:	e8 96 02 00 00       	call   383 <open>
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	e9 34 ff ff ff       	jmp    29 <main+0x29>
  f5:	66 90                	xchg   %ax,%ax
  f7:	66 90                	xchg   %ax,%ax
  f9:	66 90                	xchg   %ax,%ax
  fb:	66 90                	xchg   %ax,%ax
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 101:	31 c0                	xor    %eax,%eax
{
 103:	89 e5                	mov    %esp,%ebp
 105:	53                   	push   %ebx
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 110:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 114:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	84 d2                	test   %dl,%dl
 11c:	75 f2                	jne    110 <strcpy+0x10>
    ;
  return os;
}
 11e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 121:	89 c8                	mov    %ecx,%eax
 123:	c9                   	leave
 124:	c3                   	ret
 125:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12c:	00 
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 55 08             	mov    0x8(%ebp),%edx
 137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 13a:	0f b6 02             	movzbl (%edx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 17                	jne    158 <strcmp+0x28>
 141:	eb 3a                	jmp    17d <strcmp+0x4d>
 143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 148:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 14c:	83 c2 01             	add    $0x1,%edx
 14f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 152:	84 c0                	test   %al,%al
 154:	74 1a                	je     170 <strcmp+0x40>
 156:	89 d9                	mov    %ebx,%ecx
 158:	0f b6 19             	movzbl (%ecx),%ebx
 15b:	38 c3                	cmp    %al,%bl
 15d:	74 e9                	je     148 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 15f:	29 d8                	sub    %ebx,%eax
}
 161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 164:	c9                   	leave
 165:	c3                   	ret
 166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 16d:	00 
 16e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 170:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 174:	31 c0                	xor    %eax,%eax
 176:	29 d8                	sub    %ebx,%eax
}
 178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 17b:	c9                   	leave
 17c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 17d:	0f b6 19             	movzbl (%ecx),%ebx
 180:	31 c0                	xor    %eax,%eax
 182:	eb db                	jmp    15f <strcmp+0x2f>
 184:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 18b:	00 
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <strlen>:

uint
strlen(const char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 3a 00             	cmpb   $0x0,(%edx)
 199:	74 15                	je     1b0 <strlen+0x20>
 19b:	31 c0                	xor    %eax,%eax
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	83 c0 01             	add    $0x1,%eax
 1a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1a7:	89 c1                	mov    %eax,%ecx
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	89 c8                	mov    %ecx,%eax
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret
 1af:	90                   	nop
  for(n = 0; s[n]; n++)
 1b0:	31 c9                	xor    %ecx,%ecx
}
 1b2:	5d                   	pop    %ebp
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	c3                   	ret
 1b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bd:	00 
 1be:	66 90                	xchg   %ax,%ax

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	c9                   	leave
 1d8:	c3                   	ret
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 12                	jne    203 <strchr+0x23>
 1f1:	eb 1d                	jmp    210 <strchr+0x30>
 1f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1fc:	83 c0 01             	add    $0x1,%eax
 1ff:	84 d2                	test   %dl,%dl
 201:	74 0d                	je     210 <strchr+0x30>
    if(*s == c)
 203:	38 d1                	cmp    %dl,%cl
 205:	75 f1                	jne    1f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 207:	5d                   	pop    %ebp
 208:	c3                   	ret
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 210:	31 c0                	xor    %eax,%eax
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret
 214:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21b:	00 
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 225:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 228:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 229:	31 db                	xor    %ebx,%ebx
{
 22b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 22e:	eb 27                	jmp    257 <gets+0x37>
    cc = read(0, &c, 1);
 230:	83 ec 04             	sub    $0x4,%esp
 233:	6a 01                	push   $0x1
 235:	56                   	push   %esi
 236:	6a 00                	push   $0x0
 238:	e8 1e 01 00 00       	call   35b <read>
    if(cc < 1)
 23d:	83 c4 10             	add    $0x10,%esp
 240:	85 c0                	test   %eax,%eax
 242:	7e 1d                	jle    261 <gets+0x41>
      break;
    buf[i++] = c;
 244:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 10                	je     263 <gets+0x43>
 253:	3c 0d                	cmp    $0xd,%al
 255:	74 0c                	je     263 <gets+0x43>
  for(i=0; i+1 < max; ){
 257:	89 df                	mov    %ebx,%edi
 259:	83 c3 01             	add    $0x1,%ebx
 25c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25f:	7c cf                	jl     230 <gets+0x10>
 261:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 26a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26d:	5b                   	pop    %ebx
 26e:	5e                   	pop    %esi
 26f:	5f                   	pop    %edi
 270:	5d                   	pop    %ebp
 271:	c3                   	ret
 272:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 279:	00 
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <stat>:

int
stat(const char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	push   0x8(%ebp)
 28d:	e8 f1 00 00 00       	call   383 <open>
  if(fd < 0)
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	78 27                	js     2c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	push   0xc(%ebp)
 29f:	89 c3                	mov    %eax,%ebx
 2a1:	50                   	push   %eax
 2a2:	e8 f4 00 00 00       	call   39b <fstat>
  close(fd);
 2a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2aa:	89 c6                	mov    %eax,%esi
  close(fd);
 2ac:	e8 ba 00 00 00       	call   36b <close>
  return r;
 2b1:	83 c4 10             	add    $0x10,%esp
}
 2b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c5:	eb ed                	jmp    2b4 <stat+0x34>
 2c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ce:	00 
 2cf:	90                   	nop

000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 02             	movsbl (%edx),%eax
 2da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2e5:	77 1e                	ja     305 <atoi+0x35>
 2e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ee:	00 
 2ef:	90                   	nop
    n = n*10 + *s++ - '0';
 2f0:	83 c2 01             	add    $0x1,%edx
 2f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2fa:	0f be 02             	movsbl (%edx),%eax
 2fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
  return n;
}
 305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 308:	89 c8                	mov    %ecx,%eax
 30a:	c9                   	leave
 30b:	c3                   	ret
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	8b 45 10             	mov    0x10(%ebp),%eax
 317:	8b 55 08             	mov    0x8(%ebp),%edx
 31a:	56                   	push   %esi
 31b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 c0                	test   %eax,%eax
 320:	7e 13                	jle    335 <memmove+0x25>
 322:	01 d0                	add    %edx,%eax
  dst = vdst;
 324:	89 d7                	mov    %edx,%edi
 326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32d:	00 
 32e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 330:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 331:	39 f8                	cmp    %edi,%eax
 333:	75 fb                	jne    330 <memmove+0x20>
  return vdst;
}
 335:	5e                   	pop    %esi
 336:	89 d0                	mov    %edx,%eax
 338:	5f                   	pop    %edi
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret

0000033b <fork>:
    int $T_SYSCALL; \
    ret
// In usys.S


SYSCALL(fork)
 33b:	b8 01 00 00 00       	mov    $0x1,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <exit>:
SYSCALL(exit)
 343:	b8 02 00 00 00       	mov    $0x2,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <wait>:
SYSCALL(wait)
 34b:	b8 03 00 00 00       	mov    $0x3,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <pipe>:
SYSCALL(pipe)
 353:	b8 04 00 00 00       	mov    $0x4,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <read>:
SYSCALL(read)
 35b:	b8 05 00 00 00       	mov    $0x5,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <write>:
SYSCALL(write)
 363:	b8 10 00 00 00       	mov    $0x10,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <close>:
SYSCALL(close)
 36b:	b8 15 00 00 00       	mov    $0x15,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <kill>:
SYSCALL(kill)
 373:	b8 06 00 00 00       	mov    $0x6,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <exec>:
SYSCALL(exec)
 37b:	b8 07 00 00 00       	mov    $0x7,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <open>:
SYSCALL(open)
 383:	b8 0f 00 00 00       	mov    $0xf,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <mknod>:
SYSCALL(mknod)
 38b:	b8 11 00 00 00       	mov    $0x11,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <unlink>:
SYSCALL(unlink)
 393:	b8 12 00 00 00       	mov    $0x12,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <fstat>:
SYSCALL(fstat)
 39b:	b8 08 00 00 00       	mov    $0x8,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <link>:
SYSCALL(link)
 3a3:	b8 13 00 00 00       	mov    $0x13,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <mkdir>:
SYSCALL(mkdir)
 3ab:	b8 14 00 00 00       	mov    $0x14,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <chdir>:
SYSCALL(chdir)
 3b3:	b8 09 00 00 00       	mov    $0x9,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <dup>:
SYSCALL(dup)
 3bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <getpid>:
SYSCALL(getpid)
 3c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <sbrk>:
SYSCALL(sbrk)
 3cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <sleep>:
SYSCALL(sleep)
 3d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <uptime>:
SYSCALL(uptime)
 3db:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <move_file>:
SYSCALL(move_file)
 3e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <sort_syscalls>:
SYSCALL(sort_syscalls)
 3eb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <create_palindrom>:
SYSCALL(create_palindrom)
 3f3:	b8 16 00 00 00       	mov    $0x16,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <get_most_invoked_syscalls>:
SYSCALL(get_most_invoked_syscalls) 
 3fb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <list_all_processes>:
SYSCALL(list_all_processes)
 403:	b8 17 00 00 00       	mov    $0x17,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <change_schedular_queue>:
SYSCALL(change_schedular_queue)
 40b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <show_process_info>:
SYSCALL(show_process_info)
 413:	b8 1d 00 00 00       	mov    $0x1d,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <set_proc_sjf_params>:
 41b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret
 423:	66 90                	xchg   %ax,%ax
 425:	66 90                	xchg   %ax,%ax
 427:	66 90                	xchg   %ax,%ax
 429:	66 90                	xchg   %ax,%ax
 42b:	66 90                	xchg   %ax,%ax
 42d:	66 90                	xchg   %ax,%ax
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 438:	89 d1                	mov    %edx,%ecx
{
 43a:	83 ec 3c             	sub    $0x3c,%esp
 43d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 440:	85 d2                	test   %edx,%edx
 442:	0f 89 80 00 00 00    	jns    4c8 <printint+0x98>
 448:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 44c:	74 7a                	je     4c8 <printint+0x98>
    x = -xx;
 44e:	f7 d9                	neg    %ecx
    neg = 1;
 450:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 455:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 458:	31 f6                	xor    %esi,%esi
 45a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 460:	89 c8                	mov    %ecx,%eax
 462:	31 d2                	xor    %edx,%edx
 464:	89 f7                	mov    %esi,%edi
 466:	f7 f3                	div    %ebx
 468:	8d 76 01             	lea    0x1(%esi),%esi
 46b:	0f b6 92 c8 08 00 00 	movzbl 0x8c8(%edx),%edx
 472:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 476:	89 ca                	mov    %ecx,%edx
 478:	89 c1                	mov    %eax,%ecx
 47a:	39 da                	cmp    %ebx,%edx
 47c:	73 e2                	jae    460 <printint+0x30>
  if(neg)
 47e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 481:	85 c0                	test   %eax,%eax
 483:	74 07                	je     48c <printint+0x5c>
    buf[i++] = '-';
 485:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 48a:	89 f7                	mov    %esi,%edi
 48c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 48f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 492:	01 df                	add    %ebx,%edi
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 498:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 49b:	83 ec 04             	sub    $0x4,%esp
 49e:	88 45 d7             	mov    %al,-0x29(%ebp)
 4a1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 4a4:	6a 01                	push   $0x1
 4a6:	50                   	push   %eax
 4a7:	56                   	push   %esi
 4a8:	e8 b6 fe ff ff       	call   363 <write>
  while(--i >= 0)
 4ad:	89 f8                	mov    %edi,%eax
 4af:	83 c4 10             	add    $0x10,%esp
 4b2:	83 ef 01             	sub    $0x1,%edi
 4b5:	39 c3                	cmp    %eax,%ebx
 4b7:	75 df                	jne    498 <printint+0x68>
}
 4b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bc:	5b                   	pop    %ebx
 4bd:	5e                   	pop    %esi
 4be:	5f                   	pop    %edi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4c8:	31 c0                	xor    %eax,%eax
 4ca:	eb 89                	jmp    455 <printint+0x25>
 4cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 4dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 4df:	0f b6 1e             	movzbl (%esi),%ebx
 4e2:	83 c6 01             	add    $0x1,%esi
 4e5:	84 db                	test   %bl,%bl
 4e7:	74 67                	je     550 <printf+0x80>
 4e9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ec:	31 d2                	xor    %edx,%edx
 4ee:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 4f1:	eb 34                	jmp    527 <printf+0x57>
 4f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 4f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4fb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 500:	83 f8 25             	cmp    $0x25,%eax
 503:	74 18                	je     51d <printf+0x4d>
  write(fd, &c, 1);
 505:	83 ec 04             	sub    $0x4,%esp
 508:	8d 45 e7             	lea    -0x19(%ebp),%eax
 50b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 50e:	6a 01                	push   $0x1
 510:	50                   	push   %eax
 511:	57                   	push   %edi
 512:	e8 4c fe ff ff       	call   363 <write>
 517:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 51a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 51d:	0f b6 1e             	movzbl (%esi),%ebx
 520:	83 c6 01             	add    $0x1,%esi
 523:	84 db                	test   %bl,%bl
 525:	74 29                	je     550 <printf+0x80>
    c = fmt[i] & 0xff;
 527:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 52a:	85 d2                	test   %edx,%edx
 52c:	74 ca                	je     4f8 <printf+0x28>
      }
    } else if(state == '%'){
 52e:	83 fa 25             	cmp    $0x25,%edx
 531:	75 ea                	jne    51d <printf+0x4d>
      if(c == 'd'){
 533:	83 f8 25             	cmp    $0x25,%eax
 536:	0f 84 04 01 00 00    	je     640 <printf+0x170>
 53c:	83 e8 63             	sub    $0x63,%eax
 53f:	83 f8 15             	cmp    $0x15,%eax
 542:	77 1c                	ja     560 <printf+0x90>
 544:	ff 24 85 70 08 00 00 	jmp    *0x870(,%eax,4)
 54b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 550:	8d 65 f4             	lea    -0xc(%ebp),%esp
 553:	5b                   	pop    %ebx
 554:	5e                   	pop    %esi
 555:	5f                   	pop    %edi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret
 558:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 55f:	00 
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	8d 55 e7             	lea    -0x19(%ebp),%edx
 566:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 56a:	6a 01                	push   $0x1
 56c:	52                   	push   %edx
 56d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 570:	57                   	push   %edi
 571:	e8 ed fd ff ff       	call   363 <write>
 576:	83 c4 0c             	add    $0xc,%esp
 579:	88 5d e7             	mov    %bl,-0x19(%ebp)
 57c:	6a 01                	push   $0x1
 57e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 581:	52                   	push   %edx
 582:	57                   	push   %edi
 583:	e8 db fd ff ff       	call   363 <write>
        putc(fd, c);
 588:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58b:	31 d2                	xor    %edx,%edx
 58d:	eb 8e                	jmp    51d <printf+0x4d>
 58f:	90                   	nop
        printint(fd, *ap, 16, 0);
 590:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 593:	83 ec 0c             	sub    $0xc,%esp
 596:	b9 10 00 00 00       	mov    $0x10,%ecx
 59b:	8b 13                	mov    (%ebx),%edx
 59d:	6a 00                	push   $0x0
 59f:	89 f8                	mov    %edi,%eax
        ap++;
 5a1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 5a4:	e8 87 fe ff ff       	call   430 <printint>
        ap++;
 5a9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5af:	31 d2                	xor    %edx,%edx
 5b1:	e9 67 ff ff ff       	jmp    51d <printf+0x4d>
        s = (char*)*ap;
 5b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5b9:	8b 18                	mov    (%eax),%ebx
        ap++;
 5bb:	83 c0 04             	add    $0x4,%eax
 5be:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5c1:	85 db                	test   %ebx,%ebx
 5c3:	0f 84 87 00 00 00    	je     650 <printf+0x180>
        while(*s != 0){
 5c9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5cc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5ce:	84 c0                	test   %al,%al
 5d0:	0f 84 47 ff ff ff    	je     51d <printf+0x4d>
 5d6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5d9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5dc:	89 de                	mov    %ebx,%esi
 5de:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 5e6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5e9:	6a 01                	push   $0x1
 5eb:	53                   	push   %ebx
 5ec:	57                   	push   %edi
 5ed:	e8 71 fd ff ff       	call   363 <write>
        while(*s != 0){
 5f2:	0f b6 06             	movzbl (%esi),%eax
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	84 c0                	test   %al,%al
 5fa:	75 e4                	jne    5e0 <printf+0x110>
      state = 0;
 5fc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 5ff:	31 d2                	xor    %edx,%edx
 601:	e9 17 ff ff ff       	jmp    51d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 606:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 609:	83 ec 0c             	sub    $0xc,%esp
 60c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 611:	8b 13                	mov    (%ebx),%edx
 613:	6a 01                	push   $0x1
 615:	eb 88                	jmp    59f <printf+0xcf>
        putc(fd, *ap);
 617:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 61a:	83 ec 04             	sub    $0x4,%esp
 61d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 620:	8b 03                	mov    (%ebx),%eax
        ap++;
 622:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 625:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 628:	6a 01                	push   $0x1
 62a:	52                   	push   %edx
 62b:	57                   	push   %edi
 62c:	e8 32 fd ff ff       	call   363 <write>
        ap++;
 631:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 634:	83 c4 10             	add    $0x10,%esp
      state = 0;
 637:	31 d2                	xor    %edx,%edx
 639:	e9 df fe ff ff       	jmp    51d <printf+0x4d>
 63e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
 643:	88 5d e7             	mov    %bl,-0x19(%ebp)
 646:	8d 55 e7             	lea    -0x19(%ebp),%edx
 649:	6a 01                	push   $0x1
 64b:	e9 31 ff ff ff       	jmp    581 <printf+0xb1>
 650:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 655:	bb 28 08 00 00       	mov    $0x828,%ebx
 65a:	e9 77 ff ff ff       	jmp    5d6 <printf+0x106>
 65f:	90                   	nop

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 70 0b 00 00       	mov    0xb70,%eax
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 66e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	39 c8                	cmp    %ecx,%eax
 67c:	73 32                	jae    6b0 <free+0x50>
 67e:	39 d1                	cmp    %edx,%ecx
 680:	72 04                	jb     686 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 682:	39 d0                	cmp    %edx,%eax
 684:	72 32                	jb     6b8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 686:	8b 73 fc             	mov    -0x4(%ebx),%esi
 689:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 68c:	39 fa                	cmp    %edi,%edx
 68e:	74 30                	je     6c0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 693:	8b 50 04             	mov    0x4(%eax),%edx
 696:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 699:	39 f1                	cmp    %esi,%ecx
 69b:	74 3a                	je     6d7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 69d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 69f:	5b                   	pop    %ebx
  freep = p;
 6a0:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 6a5:	5e                   	pop    %esi
 6a6:	5f                   	pop    %edi
 6a7:	5d                   	pop    %ebp
 6a8:	c3                   	ret
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	39 d0                	cmp    %edx,%eax
 6b2:	72 04                	jb     6b8 <free+0x58>
 6b4:	39 d1                	cmp    %edx,%ecx
 6b6:	72 ce                	jb     686 <free+0x26>
{
 6b8:	89 d0                	mov    %edx,%eax
 6ba:	eb bc                	jmp    678 <free+0x18>
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6c0:	03 72 04             	add    0x4(%edx),%esi
 6c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 12                	mov    (%edx),%edx
 6ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6cd:	8b 50 04             	mov    0x4(%eax),%edx
 6d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d3:	39 f1                	cmp    %esi,%ecx
 6d5:	75 c6                	jne    69d <free+0x3d>
    p->s.size += bp->s.size;
 6d7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6da:	a3 70 0b 00 00       	mov    %eax,0xb70
    p->s.size += bp->s.size;
 6df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6e5:	89 08                	mov    %ecx,(%eax)
}
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6fc:	8b 15 70 0b 00 00    	mov    0xb70,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8d 78 07             	lea    0x7(%eax),%edi
 705:	c1 ef 03             	shr    $0x3,%edi
 708:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 70b:	85 d2                	test   %edx,%edx
 70d:	0f 84 8d 00 00 00    	je     7a0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 715:	8b 48 04             	mov    0x4(%eax),%ecx
 718:	39 f9                	cmp    %edi,%ecx
 71a:	73 64                	jae    780 <malloc+0x90>
  if(nu < 4096)
 71c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 721:	39 df                	cmp    %ebx,%edi
 723:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 726:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 72d:	eb 0a                	jmp    739 <malloc+0x49>
 72f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 730:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 732:	8b 48 04             	mov    0x4(%eax),%ecx
 735:	39 f9                	cmp    %edi,%ecx
 737:	73 47                	jae    780 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 739:	89 c2                	mov    %eax,%edx
 73b:	3b 05 70 0b 00 00    	cmp    0xb70,%eax
 741:	75 ed                	jne    730 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 743:	83 ec 0c             	sub    $0xc,%esp
 746:	56                   	push   %esi
 747:	e8 7f fc ff ff       	call   3cb <sbrk>
  if(p == (char*)-1)
 74c:	83 c4 10             	add    $0x10,%esp
 74f:	83 f8 ff             	cmp    $0xffffffff,%eax
 752:	74 1c                	je     770 <malloc+0x80>
  hp->s.size = nu;
 754:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 757:	83 ec 0c             	sub    $0xc,%esp
 75a:	83 c0 08             	add    $0x8,%eax
 75d:	50                   	push   %eax
 75e:	e8 fd fe ff ff       	call   660 <free>
  return freep;
 763:	8b 15 70 0b 00 00    	mov    0xb70,%edx
      if((p = morecore(nunits)) == 0)
 769:	83 c4 10             	add    $0x10,%esp
 76c:	85 d2                	test   %edx,%edx
 76e:	75 c0                	jne    730 <malloc+0x40>
        return 0;
  }
}
 770:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 773:	31 c0                	xor    %eax,%eax
}
 775:	5b                   	pop    %ebx
 776:	5e                   	pop    %esi
 777:	5f                   	pop    %edi
 778:	5d                   	pop    %ebp
 779:	c3                   	ret
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 780:	39 cf                	cmp    %ecx,%edi
 782:	74 4c                	je     7d0 <malloc+0xe0>
        p->s.size -= nunits;
 784:	29 f9                	sub    %edi,%ecx
 786:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 789:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 78c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 78f:	89 15 70 0b 00 00    	mov    %edx,0xb70
}
 795:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 798:	83 c0 08             	add    $0x8,%eax
}
 79b:	5b                   	pop    %ebx
 79c:	5e                   	pop    %esi
 79d:	5f                   	pop    %edi
 79e:	5d                   	pop    %ebp
 79f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 7a0:	c7 05 70 0b 00 00 74 	movl   $0xb74,0xb70
 7a7:	0b 00 00 
    base.s.size = 0;
 7aa:	b8 74 0b 00 00       	mov    $0xb74,%eax
    base.s.ptr = freep = prevp = &base;
 7af:	c7 05 74 0b 00 00 74 	movl   $0xb74,0xb74
 7b6:	0b 00 00 
    base.s.size = 0;
 7b9:	c7 05 78 0b 00 00 00 	movl   $0x0,0xb78
 7c0:	00 00 00 
    if(p->s.size >= nunits){
 7c3:	e9 54 ff ff ff       	jmp    71c <malloc+0x2c>
 7c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7cf:	00 
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 08                	mov    (%eax),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
 7d4:	eb b9                	jmp    78f <malloc+0x9f>
