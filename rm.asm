
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	bf 01 00 00 00       	mov    $0x1,%edi
  13:	56                   	push   %esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  1c:	8b 31                	mov    (%ecx),%esi
  1e:	83 c3 04             	add    $0x4,%ebx
  int i;

  if(argc < 2){
  21:	83 fe 01             	cmp    $0x1,%esi
  24:	7f 14                	jg     3a <main+0x3a>
  26:	eb 3a                	jmp    62 <main+0x62>
  28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  2f:	00 
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  30:	83 c7 01             	add    $0x1,%edi
  33:	83 c3 04             	add    $0x4,%ebx
  36:	39 fe                	cmp    %edi,%esi
  38:	74 23                	je     5d <main+0x5d>
    if(unlink(argv[i]) < 0){
  3a:	83 ec 0c             	sub    $0xc,%esp
  3d:	ff 33                	push   (%ebx)
  3f:	e8 cf 02 00 00       	call   313 <unlink>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	79 e5                	jns    30 <main+0x30>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  4b:	50                   	push   %eax
  4c:	ff 33                	push   (%ebx)
  4e:	68 6c 07 00 00       	push   $0x76c
  53:	6a 02                	push   $0x2
  55:	e8 f6 03 00 00       	call   450 <printf>
      break;
  5a:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  5d:	e8 61 02 00 00       	call   2c3 <exit>
    printf(2, "Usage: rm files...\n");
  62:	52                   	push   %edx
  63:	52                   	push   %edx
  64:	68 58 07 00 00       	push   $0x758
  69:	6a 02                	push   $0x2
  6b:	e8 e0 03 00 00       	call   450 <printf>
    exit();
  70:	e8 4e 02 00 00       	call   2c3 <exit>
  75:	66 90                	xchg   %ax,%ax
  77:	66 90                	xchg   %ax,%ax
  79:	66 90                	xchg   %ax,%ax
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  81:	31 c0                	xor    %eax,%eax
{
  83:	89 e5                	mov    %esp,%ebp
  85:	53                   	push   %ebx
  86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  97:	83 c0 01             	add    $0x1,%eax
  9a:	84 d2                	test   %dl,%dl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a1:	89 c8                	mov    %ecx,%eax
  a3:	c9                   	leave
  a4:	c3                   	ret
  a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ac:	00 
  ad:	8d 76 00             	lea    0x0(%esi),%esi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ba:	0f b6 02             	movzbl (%edx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 17                	jne    d8 <strcmp+0x28>
  c1:	eb 3a                	jmp    fd <strcmp+0x4d>
  c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  cc:	83 c2 01             	add    $0x1,%edx
  cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  d2:	84 c0                	test   %al,%al
  d4:	74 1a                	je     f0 <strcmp+0x40>
  d6:	89 d9                	mov    %ebx,%ecx
  d8:	0f b6 19             	movzbl (%ecx),%ebx
  db:	38 c3                	cmp    %al,%bl
  dd:	74 e9                	je     c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  df:	29 d8                	sub    %ebx,%eax
}
  e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e4:	c9                   	leave
  e5:	c3                   	ret
  e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ed:	00 
  ee:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  f4:	31 c0                	xor    %eax,%eax
  f6:	29 d8                	sub    %ebx,%eax
}
  f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  fb:	c9                   	leave
  fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  fd:	0f b6 19             	movzbl (%ecx),%ebx
 100:	31 c0                	xor    %eax,%eax
 102:	eb db                	jmp    df <strcmp+0x2f>
 104:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 10b:	00 
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c0 01             	add    $0x1,%eax
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	89 c1                	mov    %eax,%ecx
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	89 c8                	mov    %ecx,%eax
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret
 12f:	90                   	nop
  for(n = 0; s[n]; n++)
 130:	31 c9                	xor    %ecx,%ecx
}
 132:	5d                   	pop    %ebp
 133:	89 c8                	mov    %ecx,%eax
 135:	c3                   	ret
 136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13d:	00 
 13e:	66 90                	xchg   %ax,%ax

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	8b 7d fc             	mov    -0x4(%ebp),%edi
 155:	89 d0                	mov    %edx,%eax
 157:	c9                   	leave
 158:	c3                   	ret
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 12                	jne    183 <strchr+0x23>
 171:	eb 1d                	jmp    190 <strchr+0x30>
 173:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	84 d2                	test   %dl,%dl
 181:	74 0d                	je     190 <strchr+0x30>
    if(*s == c)
 183:	38 d1                	cmp    %dl,%cl
 185:	75 f1                	jne    178 <strchr+0x18>
      return (char*)s;
  return 0;
}
 187:	5d                   	pop    %ebp
 188:	c3                   	ret
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret
 194:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 19b:	00 
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1a5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 1a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1a9:	31 db                	xor    %ebx,%ebx
{
 1ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ae:	eb 27                	jmp    1d7 <gets+0x37>
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	56                   	push   %esi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 1e 01 00 00       	call   2db <read>
    if(cc < 1)
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 1d                	jle    1e1 <gets+0x41>
      break;
    buf[i++] = c;
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1cf:	3c 0a                	cmp    $0xa,%al
 1d1:	74 10                	je     1e3 <gets+0x43>
 1d3:	3c 0d                	cmp    $0xd,%al
 1d5:	74 0c                	je     1e3 <gets+0x43>
  for(i=0; i+1 < max; ){
 1d7:	89 df                	mov    %ebx,%edi
 1d9:	83 c3 01             	add    $0x1,%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7c cf                	jl     1b0 <gets+0x10>
 1e1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5f                   	pop    %edi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret
 1f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1f9:	00 
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	push   0x8(%ebp)
 20d:	e8 f1 00 00 00       	call   303 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	push   0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f4 00 00 00       	call   31b <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 ba 00 00 00       	call   2eb <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24e:	00 
 24f:	90                   	nop

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 02             	movsbl (%edx),%eax
 25a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 25d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 260:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 265:	77 1e                	ja     285 <atoi+0x35>
 267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26e:	00 
 26f:	90                   	nop
    n = n*10 + *s++ - '0';
 270:	83 c2 01             	add    $0x1,%edx
 273:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 276:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 27a:	0f be 02             	movsbl (%edx),%eax
 27d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 288:	89 c8                	mov    %ecx,%eax
 28a:	c9                   	leave
 28b:	c3                   	ret
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	8b 55 08             	mov    0x8(%ebp),%edx
 29a:	56                   	push   %esi
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ad:	00 
 2ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x20>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret

000002bb <fork>:
    int $T_SYSCALL; \
    ret
// In usys.S


SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <move_file>:
SYSCALL(move_file)
 363:	b8 1a 00 00 00       	mov    $0x1a,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <sort_syscalls>:
SYSCALL(sort_syscalls)
 36b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <create_palindrom>:
SYSCALL(create_palindrom)
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <get_most_invoked_syscalls>:
SYSCALL(get_most_invoked_syscalls) 
 37b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <list_all_processes>:
SYSCALL(list_all_processes)
 383:	b8 17 00 00 00       	mov    $0x17,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <change_schedular_queue>:
SYSCALL(change_schedular_queue)
 38b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <show_process_info>:
SYSCALL(show_process_info)
 393:	b8 1d 00 00 00       	mov    $0x1d,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <set_proc_sjf_params>:
 39b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret
 3a3:	66 90                	xchg   %ax,%ax
 3a5:	66 90                	xchg   %ax,%ax
 3a7:	66 90                	xchg   %ax,%ax
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3b8:	89 d1                	mov    %edx,%ecx
{
 3ba:	83 ec 3c             	sub    $0x3c,%esp
 3bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3c0:	85 d2                	test   %edx,%edx
 3c2:	0f 89 80 00 00 00    	jns    448 <printint+0x98>
 3c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3cc:	74 7a                	je     448 <printint+0x98>
    x = -xx;
 3ce:	f7 d9                	neg    %ecx
    neg = 1;
 3d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3d8:	31 f6                	xor    %esi,%esi
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e0:	89 c8                	mov    %ecx,%eax
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	89 f7                	mov    %esi,%edi
 3e6:	f7 f3                	div    %ebx
 3e8:	8d 76 01             	lea    0x1(%esi),%esi
 3eb:	0f b6 92 e4 07 00 00 	movzbl 0x7e4(%edx),%edx
 3f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3f6:	89 ca                	mov    %ecx,%edx
 3f8:	89 c1                	mov    %eax,%ecx
 3fa:	39 da                	cmp    %ebx,%edx
 3fc:	73 e2                	jae    3e0 <printint+0x30>
  if(neg)
 3fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 401:	85 c0                	test   %eax,%eax
 403:	74 07                	je     40c <printint+0x5c>
    buf[i++] = '-';
 405:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 40a:	89 f7                	mov    %esi,%edi
 40c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 40f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 412:	01 df                	add    %ebx,%edi
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 418:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 41b:	83 ec 04             	sub    $0x4,%esp
 41e:	88 45 d7             	mov    %al,-0x29(%ebp)
 421:	8d 45 d7             	lea    -0x29(%ebp),%eax
 424:	6a 01                	push   $0x1
 426:	50                   	push   %eax
 427:	56                   	push   %esi
 428:	e8 b6 fe ff ff       	call   2e3 <write>
  while(--i >= 0)
 42d:	89 f8                	mov    %edi,%eax
 42f:	83 c4 10             	add    $0x10,%esp
 432:	83 ef 01             	sub    $0x1,%edi
 435:	39 c3                	cmp    %eax,%ebx
 437:	75 df                	jne    418 <printint+0x68>
}
 439:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5f                   	pop    %edi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret
 441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 448:	31 c0                	xor    %eax,%eax
 44a:	eb 89                	jmp    3d5 <printint+0x25>
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 459:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 45c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 45f:	0f b6 1e             	movzbl (%esi),%ebx
 462:	83 c6 01             	add    $0x1,%esi
 465:	84 db                	test   %bl,%bl
 467:	74 67                	je     4d0 <printf+0x80>
 469:	8d 4d 10             	lea    0x10(%ebp),%ecx
 46c:	31 d2                	xor    %edx,%edx
 46e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 471:	eb 34                	jmp    4a7 <printf+0x57>
 473:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 478:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 47b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 480:	83 f8 25             	cmp    $0x25,%eax
 483:	74 18                	je     49d <printf+0x4d>
  write(fd, &c, 1);
 485:	83 ec 04             	sub    $0x4,%esp
 488:	8d 45 e7             	lea    -0x19(%ebp),%eax
 48b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 48e:	6a 01                	push   $0x1
 490:	50                   	push   %eax
 491:	57                   	push   %edi
 492:	e8 4c fe ff ff       	call   2e3 <write>
 497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 49a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 49d:	0f b6 1e             	movzbl (%esi),%ebx
 4a0:	83 c6 01             	add    $0x1,%esi
 4a3:	84 db                	test   %bl,%bl
 4a5:	74 29                	je     4d0 <printf+0x80>
    c = fmt[i] & 0xff;
 4a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4aa:	85 d2                	test   %edx,%edx
 4ac:	74 ca                	je     478 <printf+0x28>
      }
    } else if(state == '%'){
 4ae:	83 fa 25             	cmp    $0x25,%edx
 4b1:	75 ea                	jne    49d <printf+0x4d>
      if(c == 'd'){
 4b3:	83 f8 25             	cmp    $0x25,%eax
 4b6:	0f 84 04 01 00 00    	je     5c0 <printf+0x170>
 4bc:	83 e8 63             	sub    $0x63,%eax
 4bf:	83 f8 15             	cmp    $0x15,%eax
 4c2:	77 1c                	ja     4e0 <printf+0x90>
 4c4:	ff 24 85 8c 07 00 00 	jmp    *0x78c(,%eax,4)
 4cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d3:	5b                   	pop    %ebx
 4d4:	5e                   	pop    %esi
 4d5:	5f                   	pop    %edi
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret
 4d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4df:	00 
  write(fd, &c, 1);
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ea:	6a 01                	push   $0x1
 4ec:	52                   	push   %edx
 4ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4f0:	57                   	push   %edi
 4f1:	e8 ed fd ff ff       	call   2e3 <write>
 4f6:	83 c4 0c             	add    $0xc,%esp
 4f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4fc:	6a 01                	push   $0x1
 4fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 501:	52                   	push   %edx
 502:	57                   	push   %edi
 503:	e8 db fd ff ff       	call   2e3 <write>
        putc(fd, c);
 508:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50b:	31 d2                	xor    %edx,%edx
 50d:	eb 8e                	jmp    49d <printf+0x4d>
 50f:	90                   	nop
        printint(fd, *ap, 16, 0);
 510:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 513:	83 ec 0c             	sub    $0xc,%esp
 516:	b9 10 00 00 00       	mov    $0x10,%ecx
 51b:	8b 13                	mov    (%ebx),%edx
 51d:	6a 00                	push   $0x0
 51f:	89 f8                	mov    %edi,%eax
        ap++;
 521:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 524:	e8 87 fe ff ff       	call   3b0 <printint>
        ap++;
 529:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 52c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52f:	31 d2                	xor    %edx,%edx
 531:	e9 67 ff ff ff       	jmp    49d <printf+0x4d>
        s = (char*)*ap;
 536:	8b 45 d0             	mov    -0x30(%ebp),%eax
 539:	8b 18                	mov    (%eax),%ebx
        ap++;
 53b:	83 c0 04             	add    $0x4,%eax
 53e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 541:	85 db                	test   %ebx,%ebx
 543:	0f 84 87 00 00 00    	je     5d0 <printf+0x180>
        while(*s != 0){
 549:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 54c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 54e:	84 c0                	test   %al,%al
 550:	0f 84 47 ff ff ff    	je     49d <printf+0x4d>
 556:	8d 55 e7             	lea    -0x19(%ebp),%edx
 559:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 55c:	89 de                	mov    %ebx,%esi
 55e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 566:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 569:	6a 01                	push   $0x1
 56b:	53                   	push   %ebx
 56c:	57                   	push   %edi
 56d:	e8 71 fd ff ff       	call   2e3 <write>
        while(*s != 0){
 572:	0f b6 06             	movzbl (%esi),%eax
 575:	83 c4 10             	add    $0x10,%esp
 578:	84 c0                	test   %al,%al
 57a:	75 e4                	jne    560 <printf+0x110>
      state = 0;
 57c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 57f:	31 d2                	xor    %edx,%edx
 581:	e9 17 ff ff ff       	jmp    49d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 586:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 589:	83 ec 0c             	sub    $0xc,%esp
 58c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 591:	8b 13                	mov    (%ebx),%edx
 593:	6a 01                	push   $0x1
 595:	eb 88                	jmp    51f <printf+0xcf>
        putc(fd, *ap);
 597:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 59a:	83 ec 04             	sub    $0x4,%esp
 59d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 5a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 5a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 5a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5a8:	6a 01                	push   $0x1
 5aa:	52                   	push   %edx
 5ab:	57                   	push   %edi
 5ac:	e8 32 fd ff ff       	call   2e3 <write>
        ap++;
 5b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b7:	31 d2                	xor    %edx,%edx
 5b9:	e9 df fe ff ff       	jmp    49d <printf+0x4d>
 5be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5c9:	6a 01                	push   $0x1
 5cb:	e9 31 ff ff ff       	jmp    501 <printf+0xb1>
 5d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5d5:	bb 85 07 00 00       	mov    $0x785,%ebx
 5da:	e9 77 ff ff ff       	jmp    556 <printf+0x106>
 5df:	90                   	nop

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 90 0a 00 00       	mov    0xa90,%eax
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fa:	39 c8                	cmp    %ecx,%eax
 5fc:	73 32                	jae    630 <free+0x50>
 5fe:	39 d1                	cmp    %edx,%ecx
 600:	72 04                	jb     606 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	39 d0                	cmp    %edx,%eax
 604:	72 32                	jb     638 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 606:	8b 73 fc             	mov    -0x4(%ebx),%esi
 609:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60c:	39 fa                	cmp    %edi,%edx
 60e:	74 30                	je     640 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 610:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 613:	8b 50 04             	mov    0x4(%eax),%edx
 616:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 619:	39 f1                	cmp    %esi,%ecx
 61b:	74 3a                	je     657 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 61d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 61f:	5b                   	pop    %ebx
  freep = p;
 620:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 625:	5e                   	pop    %esi
 626:	5f                   	pop    %edi
 627:	5d                   	pop    %ebp
 628:	c3                   	ret
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 d0                	cmp    %edx,%eax
 632:	72 04                	jb     638 <free+0x58>
 634:	39 d1                	cmp    %edx,%ecx
 636:	72 ce                	jb     606 <free+0x26>
{
 638:	89 d0                	mov    %edx,%eax
 63a:	eb bc                	jmp    5f8 <free+0x18>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 640:	03 72 04             	add    0x4(%edx),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 10                	mov    (%eax),%edx
 648:	8b 12                	mov    (%edx),%edx
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 c6                	jne    61d <free+0x3d>
    p->s.size += bp->s.size;
 657:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 65a:	a3 90 0a 00 00       	mov    %eax,0xa90
    p->s.size += bp->s.size;
 65f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 662:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 665:	89 08                	mov    %ecx,(%eax)
}
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 67c:	8b 15 90 0a 00 00    	mov    0xa90,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	8d 78 07             	lea    0x7(%eax),%edi
 685:	c1 ef 03             	shr    $0x3,%edi
 688:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 68b:	85 d2                	test   %edx,%edx
 68d:	0f 84 8d 00 00 00    	je     720 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 695:	8b 48 04             	mov    0x4(%eax),%ecx
 698:	39 f9                	cmp    %edi,%ecx
 69a:	73 64                	jae    700 <malloc+0x90>
  if(nu < 4096)
 69c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a1:	39 df                	cmp    %ebx,%edi
 6a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6ad:	eb 0a                	jmp    6b9 <malloc+0x49>
 6af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6b2:	8b 48 04             	mov    0x4(%eax),%ecx
 6b5:	39 f9                	cmp    %edi,%ecx
 6b7:	73 47                	jae    700 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b9:	89 c2                	mov    %eax,%edx
 6bb:	3b 05 90 0a 00 00    	cmp    0xa90,%eax
 6c1:	75 ed                	jne    6b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6c3:	83 ec 0c             	sub    $0xc,%esp
 6c6:	56                   	push   %esi
 6c7:	e8 7f fc ff ff       	call   34b <sbrk>
  if(p == (char*)-1)
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d2:	74 1c                	je     6f0 <malloc+0x80>
  hp->s.size = nu;
 6d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6d7:	83 ec 0c             	sub    $0xc,%esp
 6da:	83 c0 08             	add    $0x8,%eax
 6dd:	50                   	push   %eax
 6de:	e8 fd fe ff ff       	call   5e0 <free>
  return freep;
 6e3:	8b 15 90 0a 00 00    	mov    0xa90,%edx
      if((p = morecore(nunits)) == 0)
 6e9:	83 c4 10             	add    $0x10,%esp
 6ec:	85 d2                	test   %edx,%edx
 6ee:	75 c0                	jne    6b0 <malloc+0x40>
        return 0;
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6f3:	31 c0                	xor    %eax,%eax
}
 6f5:	5b                   	pop    %ebx
 6f6:	5e                   	pop    %esi
 6f7:	5f                   	pop    %edi
 6f8:	5d                   	pop    %ebp
 6f9:	c3                   	ret
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 700:	39 cf                	cmp    %ecx,%edi
 702:	74 4c                	je     750 <malloc+0xe0>
        p->s.size -= nunits;
 704:	29 f9                	sub    %edi,%ecx
 706:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 709:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 70c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 70f:	89 15 90 0a 00 00    	mov    %edx,0xa90
}
 715:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 718:	83 c0 08             	add    $0x8,%eax
}
 71b:	5b                   	pop    %ebx
 71c:	5e                   	pop    %esi
 71d:	5f                   	pop    %edi
 71e:	5d                   	pop    %ebp
 71f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 720:	c7 05 90 0a 00 00 94 	movl   $0xa94,0xa90
 727:	0a 00 00 
    base.s.size = 0;
 72a:	b8 94 0a 00 00       	mov    $0xa94,%eax
    base.s.ptr = freep = prevp = &base;
 72f:	c7 05 94 0a 00 00 94 	movl   $0xa94,0xa94
 736:	0a 00 00 
    base.s.size = 0;
 739:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 740:	00 00 00 
    if(p->s.size >= nunits){
 743:	e9 54 ff ff ff       	jmp    69c <malloc+0x2c>
 748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 74f:	00 
        prevp->s.ptr = p->s.ptr;
 750:	8b 08                	mov    (%eax),%ecx
 752:	89 0a                	mov    %ecx,(%edx)
 754:	eb b9                	jmp    70f <malloc+0x9f>
