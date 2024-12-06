
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 55 02 00 00       	call   26b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 df 02 00 00       	call   303 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 47 02 00 00       	call   273 <exit>
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  30:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  31:	31 c0                	xor    %eax,%eax
{
  33:	89 e5                	mov    %esp,%ebp
  35:	53                   	push   %ebx
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  47:	83 c0 01             	add    $0x1,%eax
  4a:	84 d2                	test   %dl,%dl
  4c:	75 f2                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  51:	89 c8                	mov    %ecx,%eax
  53:	c9                   	leave
  54:	c3                   	ret
  55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  5c:	00 
  5d:	8d 76 00             	lea    0x0(%esi),%esi

00000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 55 08             	mov    0x8(%ebp),%edx
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  6a:	0f b6 02             	movzbl (%edx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	75 17                	jne    88 <strcmp+0x28>
  71:	eb 3a                	jmp    ad <strcmp+0x4d>
  73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  78:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  7c:	83 c2 01             	add    $0x1,%edx
  7f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  82:	84 c0                	test   %al,%al
  84:	74 1a                	je     a0 <strcmp+0x40>
  86:	89 d9                	mov    %ebx,%ecx
  88:	0f b6 19             	movzbl (%ecx),%ebx
  8b:	38 c3                	cmp    %al,%bl
  8d:	74 e9                	je     78 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  8f:	29 d8                	sub    %ebx,%eax
}
  91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  94:	c9                   	leave
  95:	c3                   	ret
  96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  9d:	00 
  9e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  a4:	31 c0                	xor    %eax,%eax
  a6:	29 d8                	sub    %ebx,%eax
}
  a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ab:	c9                   	leave
  ac:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	31 c0                	xor    %eax,%eax
  b2:	eb db                	jmp    8f <strcmp+0x2f>
  b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  bb:	00 
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	89 c1                	mov    %eax,%ecx
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	89 c8                	mov    %ecx,%eax
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret
  df:	90                   	nop
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	5d                   	pop    %ebp
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c3                   	ret
  e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ed:	00 
  ee:	66 90                	xchg   %ax,%ax

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	8b 7d fc             	mov    -0x4(%ebp),%edi
 105:	89 d0                	mov    %edx,%eax
 107:	c9                   	leave
 108:	c3                   	ret
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	75 12                	jne    133 <strchr+0x23>
 121:	eb 1d                	jmp    140 <strchr+0x30>
 123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 128:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 12c:	83 c0 01             	add    $0x1,%eax
 12f:	84 d2                	test   %dl,%dl
 131:	74 0d                	je     140 <strchr+0x30>
    if(*s == c)
 133:	38 d1                	cmp    %dl,%cl
 135:	75 f1                	jne    128 <strchr+0x18>
      return (char*)s;
  return 0;
}
 137:	5d                   	pop    %ebp
 138:	c3                   	ret
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 140:	31 c0                	xor    %eax,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret
 144:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 14b:	00 
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 155:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 158:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 159:	31 db                	xor    %ebx,%ebx
{
 15b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 15e:	eb 27                	jmp    187 <gets+0x37>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	56                   	push   %esi
 166:	6a 00                	push   $0x0
 168:	e8 1e 01 00 00       	call   28b <read>
    if(cc < 1)
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	7e 1d                	jle    191 <gets+0x41>
      break;
    buf[i++] = c;
 174:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 178:	8b 55 08             	mov    0x8(%ebp),%edx
 17b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 17f:	3c 0a                	cmp    $0xa,%al
 181:	74 10                	je     193 <gets+0x43>
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 0c                	je     193 <gets+0x43>
  for(i=0; i+1 < max; ){
 187:	89 df                	mov    %ebx,%edi
 189:	83 c3 01             	add    $0x1,%ebx
 18c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18f:	7c cf                	jl     160 <gets+0x10>
 191:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 19a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19d:	5b                   	pop    %ebx
 19e:	5e                   	pop    %esi
 19f:	5f                   	pop    %edi
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret
 1a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1a9:	00 
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	6a 00                	push   $0x0
 1ba:	ff 75 08             	push   0x8(%ebp)
 1bd:	e8 f1 00 00 00       	call   2b3 <open>
  if(fd < 0)
 1c2:	83 c4 10             	add    $0x10,%esp
 1c5:	85 c0                	test   %eax,%eax
 1c7:	78 27                	js     1f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	ff 75 0c             	push   0xc(%ebp)
 1cf:	89 c3                	mov    %eax,%ebx
 1d1:	50                   	push   %eax
 1d2:	e8 f4 00 00 00       	call   2cb <fstat>
  close(fd);
 1d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1da:	89 c6                	mov    %eax,%esi
  close(fd);
 1dc:	e8 ba 00 00 00       	call   29b <close>
  return r;
 1e1:	83 c4 10             	add    $0x10,%esp
}
 1e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1e7:	89 f0                	mov    %esi,%eax
 1e9:	5b                   	pop    %ebx
 1ea:	5e                   	pop    %esi
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f5:	eb ed                	jmp    1e4 <stat+0x34>
 1f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1fe:	00 
 1ff:	90                   	nop

00000200 <atoi>:

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	0f be 02             	movsbl (%edx),%eax
 20a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 20d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 210:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 215:	77 1e                	ja     235 <atoi+0x35>
 217:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21e:	00 
 21f:	90                   	nop
    n = n*10 + *s++ - '0';
 220:	83 c2 01             	add    $0x1,%edx
 223:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 226:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 22a:	0f be 02             	movsbl (%edx),%eax
 22d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 230:	80 fb 09             	cmp    $0x9,%bl
 233:	76 eb                	jbe    220 <atoi+0x20>
  return n;
}
 235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 238:	89 c8                	mov    %ecx,%eax
 23a:	c9                   	leave
 23b:	c3                   	ret
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 45 10             	mov    0x10(%ebp),%eax
 247:	8b 55 08             	mov    0x8(%ebp),%edx
 24a:	56                   	push   %esi
 24b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 c0                	test   %eax,%eax
 250:	7e 13                	jle    265 <memmove+0x25>
 252:	01 d0                	add    %edx,%eax
  dst = vdst;
 254:	89 d7                	mov    %edx,%edi
 256:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25d:	00 
 25e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 260:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 261:	39 f8                	cmp    %edi,%eax
 263:	75 fb                	jne    260 <memmove+0x20>
  return vdst;
}
 265:	5e                   	pop    %esi
 266:	89 d0                	mov    %edx,%eax
 268:	5f                   	pop    %edi
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret

0000026b <fork>:
    int $T_SYSCALL; \
    ret
// In usys.S


SYSCALL(fork)
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <exit>:
SYSCALL(exit)
 273:	b8 02 00 00 00       	mov    $0x2,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <wait>:
SYSCALL(wait)
 27b:	b8 03 00 00 00       	mov    $0x3,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <pipe>:
SYSCALL(pipe)
 283:	b8 04 00 00 00       	mov    $0x4,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <read>:
SYSCALL(read)
 28b:	b8 05 00 00 00       	mov    $0x5,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <write>:
SYSCALL(write)
 293:	b8 10 00 00 00       	mov    $0x10,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <close>:
SYSCALL(close)
 29b:	b8 15 00 00 00       	mov    $0x15,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <kill>:
SYSCALL(kill)
 2a3:	b8 06 00 00 00       	mov    $0x6,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <exec>:
SYSCALL(exec)
 2ab:	b8 07 00 00 00       	mov    $0x7,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <open>:
SYSCALL(open)
 2b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <mknod>:
SYSCALL(mknod)
 2bb:	b8 11 00 00 00       	mov    $0x11,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <unlink>:
SYSCALL(unlink)
 2c3:	b8 12 00 00 00       	mov    $0x12,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <fstat>:
SYSCALL(fstat)
 2cb:	b8 08 00 00 00       	mov    $0x8,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <link>:
SYSCALL(link)
 2d3:	b8 13 00 00 00       	mov    $0x13,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <mkdir>:
SYSCALL(mkdir)
 2db:	b8 14 00 00 00       	mov    $0x14,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <chdir>:
SYSCALL(chdir)
 2e3:	b8 09 00 00 00       	mov    $0x9,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <dup>:
SYSCALL(dup)
 2eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <getpid>:
SYSCALL(getpid)
 2f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <sbrk>:
SYSCALL(sbrk)
 2fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <sleep>:
SYSCALL(sleep)
 303:	b8 0d 00 00 00       	mov    $0xd,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <uptime>:
SYSCALL(uptime)
 30b:	b8 0e 00 00 00       	mov    $0xe,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <move_file>:
SYSCALL(move_file)
 313:	b8 1a 00 00 00       	mov    $0x1a,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <sort_syscalls>:
SYSCALL(sort_syscalls)
 31b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <create_palindrom>:
SYSCALL(create_palindrom)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <get_most_invoked_syscalls>:
SYSCALL(get_most_invoked_syscalls) 
 32b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <list_all_processes>:
SYSCALL(list_all_processes)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <change_schedular_queue>:
SYSCALL(change_schedular_queue)
 33b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <show_process_info>:
SYSCALL(show_process_info)
 343:	b8 1d 00 00 00       	mov    $0x1d,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <set_proc_sjf_params>:
 34b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret
 353:	66 90                	xchg   %ax,%ax
 355:	66 90                	xchg   %ax,%ax
 357:	66 90                	xchg   %ax,%ax
 359:	66 90                	xchg   %ax,%ax
 35b:	66 90                	xchg   %ax,%ax
 35d:	66 90                	xchg   %ax,%ax
 35f:	90                   	nop

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 368:	89 d1                	mov    %edx,%ecx
{
 36a:	83 ec 3c             	sub    $0x3c,%esp
 36d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 370:	85 d2                	test   %edx,%edx
 372:	0f 89 80 00 00 00    	jns    3f8 <printint+0x98>
 378:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 37c:	74 7a                	je     3f8 <printint+0x98>
    x = -xx;
 37e:	f7 d9                	neg    %ecx
    neg = 1;
 380:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 385:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 388:	31 f6                	xor    %esi,%esi
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 390:	89 c8                	mov    %ecx,%eax
 392:	31 d2                	xor    %edx,%edx
 394:	89 f7                	mov    %esi,%edi
 396:	f7 f3                	div    %ebx
 398:	8d 76 01             	lea    0x1(%esi),%esi
 39b:	0f b6 92 68 07 00 00 	movzbl 0x768(%edx),%edx
 3a2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3a6:	89 ca                	mov    %ecx,%edx
 3a8:	89 c1                	mov    %eax,%ecx
 3aa:	39 da                	cmp    %ebx,%edx
 3ac:	73 e2                	jae    390 <printint+0x30>
  if(neg)
 3ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3b1:	85 c0                	test   %eax,%eax
 3b3:	74 07                	je     3bc <printint+0x5c>
    buf[i++] = '-';
 3b5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3ba:	89 f7                	mov    %esi,%edi
 3bc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3bf:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3c2:	01 df                	add    %ebx,%edi
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3c8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 3cb:	83 ec 04             	sub    $0x4,%esp
 3ce:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3d4:	6a 01                	push   $0x1
 3d6:	50                   	push   %eax
 3d7:	56                   	push   %esi
 3d8:	e8 b6 fe ff ff       	call   293 <write>
  while(--i >= 0)
 3dd:	89 f8                	mov    %edi,%eax
 3df:	83 c4 10             	add    $0x10,%esp
 3e2:	83 ef 01             	sub    $0x1,%edi
 3e5:	39 c3                	cmp    %eax,%ebx
 3e7:	75 df                	jne    3c8 <printint+0x68>
}
 3e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5f                   	pop    %edi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3f8:	31 c0                	xor    %eax,%eax
 3fa:	eb 89                	jmp    385 <printint+0x25>
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 40c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 40f:	0f b6 1e             	movzbl (%esi),%ebx
 412:	83 c6 01             	add    $0x1,%esi
 415:	84 db                	test   %bl,%bl
 417:	74 67                	je     480 <printf+0x80>
 419:	8d 4d 10             	lea    0x10(%ebp),%ecx
 41c:	31 d2                	xor    %edx,%edx
 41e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 421:	eb 34                	jmp    457 <printf+0x57>
 423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 428:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 42b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 430:	83 f8 25             	cmp    $0x25,%eax
 433:	74 18                	je     44d <printf+0x4d>
  write(fd, &c, 1);
 435:	83 ec 04             	sub    $0x4,%esp
 438:	8d 45 e7             	lea    -0x19(%ebp),%eax
 43b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 43e:	6a 01                	push   $0x1
 440:	50                   	push   %eax
 441:	57                   	push   %edi
 442:	e8 4c fe ff ff       	call   293 <write>
 447:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 44a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 44d:	0f b6 1e             	movzbl (%esi),%ebx
 450:	83 c6 01             	add    $0x1,%esi
 453:	84 db                	test   %bl,%bl
 455:	74 29                	je     480 <printf+0x80>
    c = fmt[i] & 0xff;
 457:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 45a:	85 d2                	test   %edx,%edx
 45c:	74 ca                	je     428 <printf+0x28>
      }
    } else if(state == '%'){
 45e:	83 fa 25             	cmp    $0x25,%edx
 461:	75 ea                	jne    44d <printf+0x4d>
      if(c == 'd'){
 463:	83 f8 25             	cmp    $0x25,%eax
 466:	0f 84 04 01 00 00    	je     570 <printf+0x170>
 46c:	83 e8 63             	sub    $0x63,%eax
 46f:	83 f8 15             	cmp    $0x15,%eax
 472:	77 1c                	ja     490 <printf+0x90>
 474:	ff 24 85 10 07 00 00 	jmp    *0x710(,%eax,4)
 47b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 480:	8d 65 f4             	lea    -0xc(%ebp),%esp
 483:	5b                   	pop    %ebx
 484:	5e                   	pop    %esi
 485:	5f                   	pop    %edi
 486:	5d                   	pop    %ebp
 487:	c3                   	ret
 488:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48f:	00 
  write(fd, &c, 1);
 490:	83 ec 04             	sub    $0x4,%esp
 493:	8d 55 e7             	lea    -0x19(%ebp),%edx
 496:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 49a:	6a 01                	push   $0x1
 49c:	52                   	push   %edx
 49d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4a0:	57                   	push   %edi
 4a1:	e8 ed fd ff ff       	call   293 <write>
 4a6:	83 c4 0c             	add    $0xc,%esp
 4a9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4ac:	6a 01                	push   $0x1
 4ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4b1:	52                   	push   %edx
 4b2:	57                   	push   %edi
 4b3:	e8 db fd ff ff       	call   293 <write>
        putc(fd, c);
 4b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4bb:	31 d2                	xor    %edx,%edx
 4bd:	eb 8e                	jmp    44d <printf+0x4d>
 4bf:	90                   	nop
        printint(fd, *ap, 16, 0);
 4c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4c3:	83 ec 0c             	sub    $0xc,%esp
 4c6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4cb:	8b 13                	mov    (%ebx),%edx
 4cd:	6a 00                	push   $0x0
 4cf:	89 f8                	mov    %edi,%eax
        ap++;
 4d1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 4d4:	e8 87 fe ff ff       	call   360 <printint>
        ap++;
 4d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4df:	31 d2                	xor    %edx,%edx
 4e1:	e9 67 ff ff ff       	jmp    44d <printf+0x4d>
        s = (char*)*ap;
 4e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4e9:	8b 18                	mov    (%eax),%ebx
        ap++;
 4eb:	83 c0 04             	add    $0x4,%eax
 4ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4f1:	85 db                	test   %ebx,%ebx
 4f3:	0f 84 87 00 00 00    	je     580 <printf+0x180>
        while(*s != 0){
 4f9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 4fc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 4fe:	84 c0                	test   %al,%al
 500:	0f 84 47 ff ff ff    	je     44d <printf+0x4d>
 506:	8d 55 e7             	lea    -0x19(%ebp),%edx
 509:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 50c:	89 de                	mov    %ebx,%esi
 50e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 510:	83 ec 04             	sub    $0x4,%esp
 513:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 516:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 519:	6a 01                	push   $0x1
 51b:	53                   	push   %ebx
 51c:	57                   	push   %edi
 51d:	e8 71 fd ff ff       	call   293 <write>
        while(*s != 0){
 522:	0f b6 06             	movzbl (%esi),%eax
 525:	83 c4 10             	add    $0x10,%esp
 528:	84 c0                	test   %al,%al
 52a:	75 e4                	jne    510 <printf+0x110>
      state = 0;
 52c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 52f:	31 d2                	xor    %edx,%edx
 531:	e9 17 ff ff ff       	jmp    44d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 536:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 539:	83 ec 0c             	sub    $0xc,%esp
 53c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 541:	8b 13                	mov    (%ebx),%edx
 543:	6a 01                	push   $0x1
 545:	eb 88                	jmp    4cf <printf+0xcf>
        putc(fd, *ap);
 547:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 54a:	83 ec 04             	sub    $0x4,%esp
 54d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 550:	8b 03                	mov    (%ebx),%eax
        ap++;
 552:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 555:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 558:	6a 01                	push   $0x1
 55a:	52                   	push   %edx
 55b:	57                   	push   %edi
 55c:	e8 32 fd ff ff       	call   293 <write>
        ap++;
 561:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 564:	83 c4 10             	add    $0x10,%esp
      state = 0;
 567:	31 d2                	xor    %edx,%edx
 569:	e9 df fe ff ff       	jmp    44d <printf+0x4d>
 56e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	88 5d e7             	mov    %bl,-0x19(%ebp)
 576:	8d 55 e7             	lea    -0x19(%ebp),%edx
 579:	6a 01                	push   $0x1
 57b:	e9 31 ff ff ff       	jmp    4b1 <printf+0xb1>
 580:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 585:	bb 08 07 00 00       	mov    $0x708,%ebx
 58a:	e9 77 ff ff ff       	jmp    506 <printf+0x106>
 58f:	90                   	nop

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	a1 04 0a 00 00       	mov    0xa04,%eax
{
 596:	89 e5                	mov    %esp,%ebp
 598:	57                   	push   %edi
 599:	56                   	push   %esi
 59a:	53                   	push   %ebx
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 59e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5aa:	39 c8                	cmp    %ecx,%eax
 5ac:	73 32                	jae    5e0 <free+0x50>
 5ae:	39 d1                	cmp    %edx,%ecx
 5b0:	72 04                	jb     5b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b2:	39 d0                	cmp    %edx,%eax
 5b4:	72 32                	jb     5e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5bc:	39 fa                	cmp    %edi,%edx
 5be:	74 30                	je     5f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5c3:	8b 50 04             	mov    0x4(%eax),%edx
 5c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5c9:	39 f1                	cmp    %esi,%ecx
 5cb:	74 3a                	je     607 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5cd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5cf:	5b                   	pop    %ebx
  freep = p;
 5d0:	a3 04 0a 00 00       	mov    %eax,0xa04
}
 5d5:	5e                   	pop    %esi
 5d6:	5f                   	pop    %edi
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e0:	39 d0                	cmp    %edx,%eax
 5e2:	72 04                	jb     5e8 <free+0x58>
 5e4:	39 d1                	cmp    %edx,%ecx
 5e6:	72 ce                	jb     5b6 <free+0x26>
{
 5e8:	89 d0                	mov    %edx,%eax
 5ea:	eb bc                	jmp    5a8 <free+0x18>
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 5f0:	03 72 04             	add    0x4(%edx),%esi
 5f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5f6:	8b 10                	mov    (%eax),%edx
 5f8:	8b 12                	mov    (%edx),%edx
 5fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5fd:	8b 50 04             	mov    0x4(%eax),%edx
 600:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 603:	39 f1                	cmp    %esi,%ecx
 605:	75 c6                	jne    5cd <free+0x3d>
    p->s.size += bp->s.size;
 607:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 60a:	a3 04 0a 00 00       	mov    %eax,0xa04
    p->s.size += bp->s.size;
 60f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 612:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 615:	89 08                	mov    %ecx,(%eax)
}
 617:	5b                   	pop    %ebx
 618:	5e                   	pop    %esi
 619:	5f                   	pop    %edi
 61a:	5d                   	pop    %ebp
 61b:	c3                   	ret
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 62c:	8b 15 04 0a 00 00    	mov    0xa04,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 632:	8d 78 07             	lea    0x7(%eax),%edi
 635:	c1 ef 03             	shr    $0x3,%edi
 638:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 63b:	85 d2                	test   %edx,%edx
 63d:	0f 84 8d 00 00 00    	je     6d0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 643:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 645:	8b 48 04             	mov    0x4(%eax),%ecx
 648:	39 f9                	cmp    %edi,%ecx
 64a:	73 64                	jae    6b0 <malloc+0x90>
  if(nu < 4096)
 64c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 651:	39 df                	cmp    %ebx,%edi
 653:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 656:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 65d:	eb 0a                	jmp    669 <malloc+0x49>
 65f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 660:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 662:	8b 48 04             	mov    0x4(%eax),%ecx
 665:	39 f9                	cmp    %edi,%ecx
 667:	73 47                	jae    6b0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 669:	89 c2                	mov    %eax,%edx
 66b:	3b 05 04 0a 00 00    	cmp    0xa04,%eax
 671:	75 ed                	jne    660 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 673:	83 ec 0c             	sub    $0xc,%esp
 676:	56                   	push   %esi
 677:	e8 7f fc ff ff       	call   2fb <sbrk>
  if(p == (char*)-1)
 67c:	83 c4 10             	add    $0x10,%esp
 67f:	83 f8 ff             	cmp    $0xffffffff,%eax
 682:	74 1c                	je     6a0 <malloc+0x80>
  hp->s.size = nu;
 684:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 687:	83 ec 0c             	sub    $0xc,%esp
 68a:	83 c0 08             	add    $0x8,%eax
 68d:	50                   	push   %eax
 68e:	e8 fd fe ff ff       	call   590 <free>
  return freep;
 693:	8b 15 04 0a 00 00    	mov    0xa04,%edx
      if((p = morecore(nunits)) == 0)
 699:	83 c4 10             	add    $0x10,%esp
 69c:	85 d2                	test   %edx,%edx
 69e:	75 c0                	jne    660 <malloc+0x40>
        return 0;
  }
}
 6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6a3:	31 c0                	xor    %eax,%eax
}
 6a5:	5b                   	pop    %ebx
 6a6:	5e                   	pop    %esi
 6a7:	5f                   	pop    %edi
 6a8:	5d                   	pop    %ebp
 6a9:	c3                   	ret
 6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6b0:	39 cf                	cmp    %ecx,%edi
 6b2:	74 4c                	je     700 <malloc+0xe0>
        p->s.size -= nunits;
 6b4:	29 f9                	sub    %edi,%ecx
 6b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6bf:	89 15 04 0a 00 00    	mov    %edx,0xa04
}
 6c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6c8:	83 c0 08             	add    $0x8,%eax
}
 6cb:	5b                   	pop    %ebx
 6cc:	5e                   	pop    %esi
 6cd:	5f                   	pop    %edi
 6ce:	5d                   	pop    %ebp
 6cf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6d0:	c7 05 04 0a 00 00 08 	movl   $0xa08,0xa04
 6d7:	0a 00 00 
    base.s.size = 0;
 6da:	b8 08 0a 00 00       	mov    $0xa08,%eax
    base.s.ptr = freep = prevp = &base;
 6df:	c7 05 08 0a 00 00 08 	movl   $0xa08,0xa08
 6e6:	0a 00 00 
    base.s.size = 0;
 6e9:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 6f0:	00 00 00 
    if(p->s.size >= nunits){
 6f3:	e9 54 ff ff ff       	jmp    64c <malloc+0x2c>
 6f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ff:	00 
        prevp->s.ptr = p->s.ptr;
 700:	8b 08                	mov    (%eax),%ecx
 702:	89 0a                	mov    %ecx,(%edx)
 704:	eb b9                	jmp    6bf <malloc+0x9f>
