
_test:     file format elf32-i386


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
  19:	8d 70 ff             	lea    -0x1(%eax),%esi
  1c:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
  23:	89 75 e0             	mov    %esi,-0x20(%ebp)
  26:	8d 51 0f             	lea    0xf(%ecx),%edx
  29:	89 d6                	mov    %edx,%esi
  2b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  31:	83 e6 f0             	and    $0xfffffff0,%esi
  34:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  37:	89 e6                	mov    %esp,%esi
  39:	29 d6                	sub    %edx,%esi
  3b:	39 f4                	cmp    %esi,%esp
  3d:	74 12                	je     51 <main+0x51>
  3f:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  45:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  4c:	00 
  4d:	39 f4                	cmp    %esi,%esp
  4f:	75 ee                	jne    3f <main+0x3f>
  51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  54:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  5a:	29 d4                	sub    %edx,%esp
  5c:	85 d2                	test   %edx,%edx
  5e:	0f 85 f2 01 00 00    	jne    256 <main+0x256>
    if(argc <2){
  64:	83 e8 01             	sub    $0x1,%eax
    char* text_to_encode[argc-1];
  67:	89 65 e4             	mov    %esp,-0x1c(%ebp)
    if(argc <2){
  6a:	0f 8e 8c 01 00 00    	jle    1fc <main+0x1fc>
  70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
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
  8b:	39 c8                	cmp    %ecx,%eax
  8d:	75 f1                	jne    80 <main+0x80>
            //printf(1,'\n');
        }
    }
         printf(1,'%c','\n');
  8f:	83 ec 04             	sub    $0x4,%esp
    for (int i=0;i<argc-1;i++){
  92:	31 db                	xor    %ebx,%ebx
         printf(1,'%c','\n');
  94:	6a 0a                	push   $0xa
  96:	68 63 25 00 00       	push   $0x2563
  9b:	6a 01                	push   $0x1
  9d:	e8 de 05 00 00       	call   680 <printf>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	8d 76 00             	lea    0x0(%esi),%esi
        //printf(1,text_to_encode[i]);
        printf(1,"functions: \n");
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	68 b1 09 00 00       	push   $0x9b1
  b0:	6a 01                	push   $0x1
  b2:	e8 c9 05 00 00       	call   680 <printf>
        cesar_encode(text_to_encode[i],1);
  b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for (int i=0;text[i]!='\0';i++)
  ba:	83 c4 10             	add    $0x10,%esp
        cesar_encode(text_to_encode[i],1);
  bd:	8b 04 98             	mov    (%eax,%ebx,4),%eax
    for (int i=0;text[i]!='\0';i++)
  c0:	0f be 08             	movsbl (%eax),%ecx
  c3:	89 c6                	mov    %eax,%esi
  c5:	84 c9                	test   %cl,%cl
  c7:	74 75                	je     13e <main+0x13e>
  c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  cc:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  cf:	eb 4b                	jmp    11c <main+0x11c>
  d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(c>='A' && c<='Z'){
  d8:	8d 41 bf             	lea    -0x41(%ecx),%eax
  db:	3c 19                	cmp    $0x19,%al
  dd:	0f 87 0d 01 00 00    	ja     1f0 <main+0x1f0>
  e3:	bb 41 00 00 00       	mov    $0x41,%ebx
  e8:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
  ed:	bf 41 00 00 00       	mov    $0x41,%edi
        text[i]=(c-base+shift)%26+base;
  f2:	29 c1                	sub    %eax,%ecx
  f4:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
    for (int i=0;text[i]!='\0';i++)
  f9:	83 c6 01             	add    $0x1,%esi
        text[i]=(c-base+shift)%26+base;
  fc:	83 c1 01             	add    $0x1,%ecx
  ff:	f7 e9                	imul   %ecx
 101:	89 c8                	mov    %ecx,%eax
 103:	c1 f8 1f             	sar    $0x1f,%eax
 106:	c1 fa 03             	sar    $0x3,%edx
 109:	29 c2                	sub    %eax,%edx
 10b:	6b d2 1a             	imul   $0x1a,%edx,%edx
 10e:	29 d1                	sub    %edx,%ecx
 110:	01 cb                	add    %ecx,%ebx
 112:	88 5e ff             	mov    %bl,-0x1(%esi)
    for (int i=0;text[i]!='\0';i++)
 115:	0f be 0e             	movsbl (%esi),%ecx
 118:	84 c9                	test   %cl,%cl
 11a:	74 1c                	je     138 <main+0x138>
        if (c>='a' && c<='z'){
 11c:	8d 41 9f             	lea    -0x61(%ecx),%eax
 11f:	3c 19                	cmp    $0x19,%al
 121:	77 b5                	ja     d8 <main+0xd8>
 123:	bb 61 00 00 00       	mov    $0x61,%ebx
 128:	b8 61 00 00 00       	mov    $0x61,%eax
        base='a';}
 12d:	bf 61 00 00 00       	mov    $0x61,%edi
 132:	eb be                	jmp    f2 <main+0xf2>
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 138:	8b 45 dc             	mov    -0x24(%ebp),%eax
 13b:	8b 5d d8             	mov    -0x28(%ebp),%ebx
        printf(1,text_to_encode[i]);
 13e:	83 ec 08             	sub    $0x8,%esp
    for (int i=0;i<argc-1;i++){
 141:	83 c3 01             	add    $0x1,%ebx
        printf(1,text_to_encode[i]);
 144:	50                   	push   %eax
 145:	6a 01                	push   $0x1
 147:	e8 34 05 00 00       	call   680 <printf>
        printf(1,'%c','\n');
 14c:	83 c4 0c             	add    $0xc,%esp
 14f:	6a 0a                	push   $0xa
 151:	68 63 25 00 00       	push   $0x2563
 156:	6a 01                	push   $0x1
 158:	e8 23 05 00 00       	call   680 <printf>
    for (int i=0;i<argc-1;i++){
 15d:	83 c4 10             	add    $0x10,%esp
 160:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
 163:	0f 85 3f ff ff ff    	jne    a8 <main+0xa8>
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
 169:	83 ec 08             	sub    $0x8,%esp
            printf(1,"Unable to open or create file");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
 16c:	31 f6                	xor    %esi,%esi
        int fd=open("result.txt",O_CREATE|O_RDWR);
 16e:	68 02 02 00 00       	push   $0x202
 173:	89 f7                	mov    %esi,%edi
 175:	68 a1 09 00 00       	push   $0x9a1
 17a:	e8 f4 03 00 00       	call   573 <open>
        printf(1,"hi \n");
 17f:	5a                   	pop    %edx
 180:	59                   	pop    %ecx
 181:	68 ac 09 00 00       	push   $0x9ac
 186:	6a 01                	push   $0x1
        int fd=open("result.txt",O_CREATE|O_RDWR);
 188:	89 c3                	mov    %eax,%ebx
        printf(1,"hi \n");
 18a:	e8 f1 04 00 00       	call   680 <printf>
        if (fd <0){
 18f:	83 c4 10             	add    $0x10,%esp
 192:	85 db                	test   %ebx,%ebx
 194:	0f 88 a9 00 00 00    	js     243 <main+0x243>
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 1a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	8b 34 b8             	mov    (%eax,%edi,4),%esi
            for (int i=0;i<argc-1;i++){
 1a9:	83 c7 01             	add    $0x1,%edi
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
 1ac:	56                   	push   %esi
 1ad:	e8 ce 01 00 00       	call   380 <strlen>
 1b2:	83 c4 0c             	add    $0xc,%esp
 1b5:	50                   	push   %eax
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	e8 96 03 00 00       	call   553 <write>
                write(fd,space,strlen(space));
 1bd:	c7 04 24 dc 09 00 00 	movl   $0x9dc,(%esp)
 1c4:	e8 b7 01 00 00       	call   380 <strlen>
 1c9:	83 c4 0c             	add    $0xc,%esp
 1cc:	50                   	push   %eax
 1cd:	68 dc 09 00 00       	push   $0x9dc
 1d2:	53                   	push   %ebx
 1d3:	e8 7b 03 00 00       	call   553 <write>
            for (int i=0;i<argc-1;i++){
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	39 7d e0             	cmp    %edi,-0x20(%ebp)
 1de:	75 c0                	jne    1a0 <main+0x1a0>

            //printf(1,"hi2");


        }
        close(fd);
 1e0:	83 ec 0c             	sub    $0xc,%esp
 1e3:	53                   	push   %ebx
 1e4:	e8 72 03 00 00       	call   55b <close>
    exit();
 1e9:	e8 45 03 00 00       	call   533 <exit>
 1ee:	66 90                	xchg   %ax,%ax
        text[i]=(c-base+shift)%26+base;
 1f0:	89 f8                	mov    %edi,%eax
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	0f be c0             	movsbl %al,%eax
 1f7:	e9 f6 fe ff ff       	jmp    f2 <main+0xf2>
        printf(1,"no text to encode passed");
 1fc:	53                   	push   %ebx
 1fd:	53                   	push   %ebx
 1fe:	68 88 09 00 00       	push   $0x988
 203:	6a 01                	push   $0x1
 205:	e8 76 04 00 00       	call   680 <printf>
         printf(1,'%c','\n');
 20a:	83 c4 0c             	add    $0xc,%esp
 20d:	6a 0a                	push   $0xa
 20f:	68 63 25 00 00       	push   $0x2563
 214:	6a 01                	push   $0x1
 216:	e8 65 04 00 00       	call   680 <printf>
        int fd=open("result.txt",O_CREATE|O_RDWR);
 21b:	5e                   	pop    %esi
 21c:	5f                   	pop    %edi
 21d:	68 02 02 00 00       	push   $0x202
 222:	68 a1 09 00 00       	push   $0x9a1
 227:	e8 47 03 00 00       	call   573 <open>
 22c:	89 c3                	mov    %eax,%ebx
        printf(1,"hi \n");
 22e:	58                   	pop    %eax
 22f:	5a                   	pop    %edx
 230:	68 ac 09 00 00       	push   $0x9ac
 235:	6a 01                	push   $0x1
 237:	e8 44 04 00 00       	call   680 <printf>
        if (fd <0){
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	85 db                	test   %ebx,%ebx
 241:	79 9d                	jns    1e0 <main+0x1e0>
            printf(1,"Unable to open or create file");
 243:	50                   	push   %eax
 244:	50                   	push   %eax
 245:	68 be 09 00 00       	push   $0x9be
 24a:	6a 01                	push   $0x1
 24c:	e8 2f 04 00 00       	call   680 <printf>
            exit();
 251:	e8 dd 02 00 00       	call   533 <exit>
    char* text_to_encode[argc-1];
 256:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
 25b:	e9 04 fe ff ff       	jmp    64 <main+0x64>

00000260 <cesar_encode>:
void cesar_encode(char* text,int shift){
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	56                   	push   %esi
 265:	53                   	push   %ebx
 266:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (int i=0;text[i]!='\0';i++)
 269:	0f be 0b             	movsbl (%ebx),%ecx
 26c:	84 c9                	test   %cl,%cl
 26e:	75 48                	jne    2b8 <cesar_encode+0x58>
 270:	eb 5e                	jmp    2d0 <cesar_encode+0x70>
 272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(c>='A' && c<='Z'){
 278:	8d 41 bf             	lea    -0x41(%ecx),%eax
 27b:	3c 19                	cmp    $0x19,%al
 27d:	77 59                	ja     2d8 <cesar_encode+0x78>
 27f:	be 41 00 00 00       	mov    $0x41,%esi
 284:	b8 41 00 00 00       	mov    $0x41,%eax
        base='A';}
 289:	bf 41 00 00 00       	mov    $0x41,%edi
        text[i]=(c-base+shift)%26+base;
 28e:	29 c1                	sub    %eax,%ecx
 290:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 295:	03 4d 0c             	add    0xc(%ebp),%ecx
    for (int i=0;text[i]!='\0';i++)
 298:	83 c3 01             	add    $0x1,%ebx
        text[i]=(c-base+shift)%26+base;
 29b:	f7 e9                	imul   %ecx
 29d:	89 c8                	mov    %ecx,%eax
 29f:	c1 f8 1f             	sar    $0x1f,%eax
 2a2:	c1 fa 03             	sar    $0x3,%edx
 2a5:	29 c2                	sub    %eax,%edx
 2a7:	6b d2 1a             	imul   $0x1a,%edx,%edx
 2aa:	29 d1                	sub    %edx,%ecx
 2ac:	01 f1                	add    %esi,%ecx
 2ae:	88 4b ff             	mov    %cl,-0x1(%ebx)
    for (int i=0;text[i]!='\0';i++)
 2b1:	0f be 0b             	movsbl (%ebx),%ecx
 2b4:	84 c9                	test   %cl,%cl
 2b6:	74 18                	je     2d0 <cesar_encode+0x70>
        if (c>='a' && c<='z'){
 2b8:	8d 41 9f             	lea    -0x61(%ecx),%eax
 2bb:	3c 19                	cmp    $0x19,%al
 2bd:	77 b9                	ja     278 <cesar_encode+0x18>
 2bf:	be 61 00 00 00       	mov    $0x61,%esi
 2c4:	b8 61 00 00 00       	mov    $0x61,%eax
        base='a';}
 2c9:	bf 61 00 00 00       	mov    $0x61,%edi
 2ce:	eb be                	jmp    28e <cesar_encode+0x2e>
}
 2d0:	5b                   	pop    %ebx
 2d1:	5e                   	pop    %esi
 2d2:	5f                   	pop    %edi
 2d3:	5d                   	pop    %ebp
 2d4:	c3                   	ret
 2d5:	8d 76 00             	lea    0x0(%esi),%esi
        text[i]=(c-base+shift)%26+base;
 2d8:	89 f8                	mov    %edi,%eax
 2da:	89 fe                	mov    %edi,%esi
 2dc:	0f be c0             	movsbl %al,%eax
 2df:	eb ad                	jmp    28e <cesar_encode+0x2e>
 2e1:	66 90                	xchg   %ax,%ax
 2e3:	66 90                	xchg   %ax,%ax
 2e5:	66 90                	xchg   %ax,%ax
 2e7:	66 90                	xchg   %ax,%ax
 2e9:	66 90                	xchg   %ax,%ax
 2eb:	66 90                	xchg   %ax,%ax
 2ed:	66 90                	xchg   %ax,%ax
 2ef:	90                   	nop

000002f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f1:	31 c0                	xor    %eax,%eax
{
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	53                   	push   %ebx
 2f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 300:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 304:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 307:	83 c0 01             	add    $0x1,%eax
 30a:	84 d2                	test   %dl,%dl
 30c:	75 f2                	jne    300 <strcpy+0x10>
    ;
  return os;
}
 30e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 311:	89 c8                	mov    %ecx,%eax
 313:	c9                   	leave
 314:	c3                   	ret
 315:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 31c:	00 
 31d:	8d 76 00             	lea    0x0(%esi),%esi

00000320 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 55 08             	mov    0x8(%ebp),%edx
 327:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 32a:	0f b6 02             	movzbl (%edx),%eax
 32d:	84 c0                	test   %al,%al
 32f:	75 17                	jne    348 <strcmp+0x28>
 331:	eb 3a                	jmp    36d <strcmp+0x4d>
 333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 338:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 33c:	83 c2 01             	add    $0x1,%edx
 33f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 342:	84 c0                	test   %al,%al
 344:	74 1a                	je     360 <strcmp+0x40>
 346:	89 d9                	mov    %ebx,%ecx
 348:	0f b6 19             	movzbl (%ecx),%ebx
 34b:	38 c3                	cmp    %al,%bl
 34d:	74 e9                	je     338 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 34f:	29 d8                	sub    %ebx,%eax
}
 351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 354:	c9                   	leave
 355:	c3                   	ret
 356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35d:	00 
 35e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 360:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 364:	31 c0                	xor    %eax,%eax
 366:	29 d8                	sub    %ebx,%eax
}
 368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 36b:	c9                   	leave
 36c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 36d:	0f b6 19             	movzbl (%ecx),%ebx
 370:	31 c0                	xor    %eax,%eax
 372:	eb db                	jmp    34f <strcmp+0x2f>
 374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37b:	00 
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <strlen>:

uint
strlen(const char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 386:	80 3a 00             	cmpb   $0x0,(%edx)
 389:	74 15                	je     3a0 <strlen+0x20>
 38b:	31 c0                	xor    %eax,%eax
 38d:	8d 76 00             	lea    0x0(%esi),%esi
 390:	83 c0 01             	add    $0x1,%eax
 393:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 397:	89 c1                	mov    %eax,%ecx
 399:	75 f5                	jne    390 <strlen+0x10>
    ;
  return n;
}
 39b:	89 c8                	mov    %ecx,%eax
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret
 39f:	90                   	nop
  for(n = 0; s[n]; n++)
 3a0:	31 c9                	xor    %ecx,%ecx
}
 3a2:	5d                   	pop    %ebp
 3a3:	89 c8                	mov    %ecx,%eax
 3a5:	c3                   	ret
 3a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ad:	00 
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	89 d7                	mov    %edx,%edi
 3bf:	fc                   	cld
 3c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3c5:	89 d0                	mov    %edx,%eax
 3c7:	c9                   	leave
 3c8:	c3                   	ret
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <strchr>:

char*
strchr(const char *s, char c)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3da:	0f b6 10             	movzbl (%eax),%edx
 3dd:	84 d2                	test   %dl,%dl
 3df:	75 12                	jne    3f3 <strchr+0x23>
 3e1:	eb 1d                	jmp    400 <strchr+0x30>
 3e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3ec:	83 c0 01             	add    $0x1,%eax
 3ef:	84 d2                	test   %dl,%dl
 3f1:	74 0d                	je     400 <strchr+0x30>
    if(*s == c)
 3f3:	38 d1                	cmp    %dl,%cl
 3f5:	75 f1                	jne    3e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3f7:	5d                   	pop    %ebp
 3f8:	c3                   	ret
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 400:	31 c0                	xor    %eax,%eax
}
 402:	5d                   	pop    %ebp
 403:	c3                   	ret
 404:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 40b:	00 
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <gets>:

char*
gets(char *buf, int max)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 415:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 418:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 419:	31 db                	xor    %ebx,%ebx
{
 41b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 41e:	eb 27                	jmp    447 <gets+0x37>
    cc = read(0, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	6a 01                	push   $0x1
 425:	56                   	push   %esi
 426:	6a 00                	push   $0x0
 428:	e8 1e 01 00 00       	call   54b <read>
    if(cc < 1)
 42d:	83 c4 10             	add    $0x10,%esp
 430:	85 c0                	test   %eax,%eax
 432:	7e 1d                	jle    451 <gets+0x41>
      break;
    buf[i++] = c;
 434:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 438:	8b 55 08             	mov    0x8(%ebp),%edx
 43b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 43f:	3c 0a                	cmp    $0xa,%al
 441:	74 10                	je     453 <gets+0x43>
 443:	3c 0d                	cmp    $0xd,%al
 445:	74 0c                	je     453 <gets+0x43>
  for(i=0; i+1 < max; ){
 447:	89 df                	mov    %ebx,%edi
 449:	83 c3 01             	add    $0x1,%ebx
 44c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 44f:	7c cf                	jl     420 <gets+0x10>
 451:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 45a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45d:	5b                   	pop    %ebx
 45e:	5e                   	pop    %esi
 45f:	5f                   	pop    %edi
 460:	5d                   	pop    %ebp
 461:	c3                   	ret
 462:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 469:	00 
 46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000470 <stat>:

int
stat(const char *n, struct stat *st)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	56                   	push   %esi
 474:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 475:	83 ec 08             	sub    $0x8,%esp
 478:	6a 00                	push   $0x0
 47a:	ff 75 08             	push   0x8(%ebp)
 47d:	e8 f1 00 00 00       	call   573 <open>
  if(fd < 0)
 482:	83 c4 10             	add    $0x10,%esp
 485:	85 c0                	test   %eax,%eax
 487:	78 27                	js     4b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 489:	83 ec 08             	sub    $0x8,%esp
 48c:	ff 75 0c             	push   0xc(%ebp)
 48f:	89 c3                	mov    %eax,%ebx
 491:	50                   	push   %eax
 492:	e8 f4 00 00 00       	call   58b <fstat>
  close(fd);
 497:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 49a:	89 c6                	mov    %eax,%esi
  close(fd);
 49c:	e8 ba 00 00 00       	call   55b <close>
  return r;
 4a1:	83 c4 10             	add    $0x10,%esp
}
 4a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4a7:	89 f0                	mov    %esi,%eax
 4a9:	5b                   	pop    %ebx
 4aa:	5e                   	pop    %esi
 4ab:	5d                   	pop    %ebp
 4ac:	c3                   	ret
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4b5:	eb ed                	jmp    4a4 <stat+0x34>
 4b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4be:	00 
 4bf:	90                   	nop

000004c0 <atoi>:

int
atoi(const char *s)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	53                   	push   %ebx
 4c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4c7:	0f be 02             	movsbl (%edx),%eax
 4ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4d5:	77 1e                	ja     4f5 <atoi+0x35>
 4d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4de:	00 
 4df:	90                   	nop
    n = n*10 + *s++ - '0';
 4e0:	83 c2 01             	add    $0x1,%edx
 4e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ea:	0f be 02             	movsbl (%edx),%eax
 4ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4f0:	80 fb 09             	cmp    $0x9,%bl
 4f3:	76 eb                	jbe    4e0 <atoi+0x20>
  return n;
}
 4f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f8:	89 c8                	mov    %ecx,%eax
 4fa:	c9                   	leave
 4fb:	c3                   	ret
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	8b 45 10             	mov    0x10(%ebp),%eax
 507:	8b 55 08             	mov    0x8(%ebp),%edx
 50a:	56                   	push   %esi
 50b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 50e:	85 c0                	test   %eax,%eax
 510:	7e 13                	jle    525 <memmove+0x25>
 512:	01 d0                	add    %edx,%eax
  dst = vdst;
 514:	89 d7                	mov    %edx,%edi
 516:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 51d:	00 
 51e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 520:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 521:	39 f8                	cmp    %edi,%eax
 523:	75 fb                	jne    520 <memmove+0x20>
  return vdst;
}
 525:	5e                   	pop    %esi
 526:	89 d0                	mov    %edx,%eax
 528:	5f                   	pop    %edi
 529:	5d                   	pop    %ebp
 52a:	c3                   	ret

0000052b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52b:	b8 01 00 00 00       	mov    $0x1,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <exit>:
SYSCALL(exit)
 533:	b8 02 00 00 00       	mov    $0x2,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <wait>:
SYSCALL(wait)
 53b:	b8 03 00 00 00       	mov    $0x3,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <pipe>:
SYSCALL(pipe)
 543:	b8 04 00 00 00       	mov    $0x4,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <read>:
SYSCALL(read)
 54b:	b8 05 00 00 00       	mov    $0x5,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <write>:
SYSCALL(write)
 553:	b8 10 00 00 00       	mov    $0x10,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <close>:
SYSCALL(close)
 55b:	b8 15 00 00 00       	mov    $0x15,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <kill>:
SYSCALL(kill)
 563:	b8 06 00 00 00       	mov    $0x6,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <exec>:
SYSCALL(exec)
 56b:	b8 07 00 00 00       	mov    $0x7,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <open>:
SYSCALL(open)
 573:	b8 0f 00 00 00       	mov    $0xf,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <mknod>:
SYSCALL(mknod)
 57b:	b8 11 00 00 00       	mov    $0x11,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <unlink>:
SYSCALL(unlink)
 583:	b8 12 00 00 00       	mov    $0x12,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <fstat>:
SYSCALL(fstat)
 58b:	b8 08 00 00 00       	mov    $0x8,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <link>:
SYSCALL(link)
 593:	b8 13 00 00 00       	mov    $0x13,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <mkdir>:
SYSCALL(mkdir)
 59b:	b8 14 00 00 00       	mov    $0x14,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <chdir>:
SYSCALL(chdir)
 5a3:	b8 09 00 00 00       	mov    $0x9,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <dup>:
SYSCALL(dup)
 5ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <getpid>:
SYSCALL(getpid)
 5b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <sbrk>:
SYSCALL(sbrk)
 5bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <sleep>:
SYSCALL(sleep)
 5c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <uptime>:
SYSCALL(uptime)
 5cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret
 5d3:	66 90                	xchg   %ax,%ax
 5d5:	66 90                	xchg   %ax,%ax
 5d7:	66 90                	xchg   %ax,%ax
 5d9:	66 90                	xchg   %ax,%ax
 5db:	66 90                	xchg   %ax,%ax
 5dd:	66 90                	xchg   %ax,%ax
 5df:	90                   	nop

000005e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5e8:	89 d1                	mov    %edx,%ecx
{
 5ea:	83 ec 3c             	sub    $0x3c,%esp
 5ed:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5f0:	85 d2                	test   %edx,%edx
 5f2:	0f 89 80 00 00 00    	jns    678 <printint+0x98>
 5f8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5fc:	74 7a                	je     678 <printint+0x98>
    x = -xx;
 5fe:	f7 d9                	neg    %ecx
    neg = 1;
 600:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 605:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 608:	31 f6                	xor    %esi,%esi
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 610:	89 c8                	mov    %ecx,%eax
 612:	31 d2                	xor    %edx,%edx
 614:	89 f7                	mov    %esi,%edi
 616:	f7 f3                	div    %ebx
 618:	8d 76 01             	lea    0x1(%esi),%esi
 61b:	0f b6 92 40 0a 00 00 	movzbl 0xa40(%edx),%edx
 622:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 626:	89 ca                	mov    %ecx,%edx
 628:	89 c1                	mov    %eax,%ecx
 62a:	39 da                	cmp    %ebx,%edx
 62c:	73 e2                	jae    610 <printint+0x30>
  if(neg)
 62e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 631:	85 c0                	test   %eax,%eax
 633:	74 07                	je     63c <printint+0x5c>
    buf[i++] = '-';
 635:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 63a:	89 f7                	mov    %esi,%edi
 63c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 63f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 642:	01 df                	add    %ebx,%edi
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 648:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 64b:	83 ec 04             	sub    $0x4,%esp
 64e:	88 45 d7             	mov    %al,-0x29(%ebp)
 651:	8d 45 d7             	lea    -0x29(%ebp),%eax
 654:	6a 01                	push   $0x1
 656:	50                   	push   %eax
 657:	56                   	push   %esi
 658:	e8 f6 fe ff ff       	call   553 <write>
  while(--i >= 0)
 65d:	89 f8                	mov    %edi,%eax
 65f:	83 c4 10             	add    $0x10,%esp
 662:	83 ef 01             	sub    $0x1,%edi
 665:	39 c3                	cmp    %eax,%ebx
 667:	75 df                	jne    648 <printint+0x68>
}
 669:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66c:	5b                   	pop    %ebx
 66d:	5e                   	pop    %esi
 66e:	5f                   	pop    %edi
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 678:	31 c0                	xor    %eax,%eax
 67a:	eb 89                	jmp    605 <printint+0x25>
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 689:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 68c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 68f:	0f b6 1e             	movzbl (%esi),%ebx
 692:	83 c6 01             	add    $0x1,%esi
 695:	84 db                	test   %bl,%bl
 697:	74 67                	je     700 <printf+0x80>
 699:	8d 4d 10             	lea    0x10(%ebp),%ecx
 69c:	31 d2                	xor    %edx,%edx
 69e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 6a1:	eb 34                	jmp    6d7 <printf+0x57>
 6a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 6a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6ab:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6b0:	83 f8 25             	cmp    $0x25,%eax
 6b3:	74 18                	je     6cd <printf+0x4d>
  write(fd, &c, 1);
 6b5:	83 ec 04             	sub    $0x4,%esp
 6b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6bb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6be:	6a 01                	push   $0x1
 6c0:	50                   	push   %eax
 6c1:	57                   	push   %edi
 6c2:	e8 8c fe ff ff       	call   553 <write>
 6c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6ca:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6cd:	0f b6 1e             	movzbl (%esi),%ebx
 6d0:	83 c6 01             	add    $0x1,%esi
 6d3:	84 db                	test   %bl,%bl
 6d5:	74 29                	je     700 <printf+0x80>
    c = fmt[i] & 0xff;
 6d7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6da:	85 d2                	test   %edx,%edx
 6dc:	74 ca                	je     6a8 <printf+0x28>
      }
    } else if(state == '%'){
 6de:	83 fa 25             	cmp    $0x25,%edx
 6e1:	75 ea                	jne    6cd <printf+0x4d>
      if(c == 'd'){
 6e3:	83 f8 25             	cmp    $0x25,%eax
 6e6:	0f 84 04 01 00 00    	je     7f0 <printf+0x170>
 6ec:	83 e8 63             	sub    $0x63,%eax
 6ef:	83 f8 15             	cmp    $0x15,%eax
 6f2:	77 1c                	ja     710 <printf+0x90>
 6f4:	ff 24 85 e8 09 00 00 	jmp    *0x9e8(,%eax,4)
 6fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 700:	8d 65 f4             	lea    -0xc(%ebp),%esp
 703:	5b                   	pop    %ebx
 704:	5e                   	pop    %esi
 705:	5f                   	pop    %edi
 706:	5d                   	pop    %ebp
 707:	c3                   	ret
 708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 70f:	00 
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	8d 55 e7             	lea    -0x19(%ebp),%edx
 716:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 71a:	6a 01                	push   $0x1
 71c:	52                   	push   %edx
 71d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 720:	57                   	push   %edi
 721:	e8 2d fe ff ff       	call   553 <write>
 726:	83 c4 0c             	add    $0xc,%esp
 729:	88 5d e7             	mov    %bl,-0x19(%ebp)
 72c:	6a 01                	push   $0x1
 72e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 731:	52                   	push   %edx
 732:	57                   	push   %edi
 733:	e8 1b fe ff ff       	call   553 <write>
        putc(fd, c);
 738:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73b:	31 d2                	xor    %edx,%edx
 73d:	eb 8e                	jmp    6cd <printf+0x4d>
 73f:	90                   	nop
        printint(fd, *ap, 16, 0);
 740:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 743:	83 ec 0c             	sub    $0xc,%esp
 746:	b9 10 00 00 00       	mov    $0x10,%ecx
 74b:	8b 13                	mov    (%ebx),%edx
 74d:	6a 00                	push   $0x0
 74f:	89 f8                	mov    %edi,%eax
        ap++;
 751:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 754:	e8 87 fe ff ff       	call   5e0 <printint>
        ap++;
 759:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 75c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 75f:	31 d2                	xor    %edx,%edx
 761:	e9 67 ff ff ff       	jmp    6cd <printf+0x4d>
        s = (char*)*ap;
 766:	8b 45 d0             	mov    -0x30(%ebp),%eax
 769:	8b 18                	mov    (%eax),%ebx
        ap++;
 76b:	83 c0 04             	add    $0x4,%eax
 76e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 771:	85 db                	test   %ebx,%ebx
 773:	0f 84 87 00 00 00    	je     800 <printf+0x180>
        while(*s != 0){
 779:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 77c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 77e:	84 c0                	test   %al,%al
 780:	0f 84 47 ff ff ff    	je     6cd <printf+0x4d>
 786:	8d 55 e7             	lea    -0x19(%ebp),%edx
 789:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78c:	89 de                	mov    %ebx,%esi
 78e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
 793:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 796:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 799:	6a 01                	push   $0x1
 79b:	53                   	push   %ebx
 79c:	57                   	push   %edi
 79d:	e8 b1 fd ff ff       	call   553 <write>
        while(*s != 0){
 7a2:	0f b6 06             	movzbl (%esi),%eax
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	84 c0                	test   %al,%al
 7aa:	75 e4                	jne    790 <printf+0x110>
      state = 0;
 7ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 7af:	31 d2                	xor    %edx,%edx
 7b1:	e9 17 ff ff ff       	jmp    6cd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 7b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7b9:	83 ec 0c             	sub    $0xc,%esp
 7bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7c1:	8b 13                	mov    (%ebx),%edx
 7c3:	6a 01                	push   $0x1
 7c5:	eb 88                	jmp    74f <printf+0xcf>
        putc(fd, *ap);
 7c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7ca:	83 ec 04             	sub    $0x4,%esp
 7cd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7d0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7d2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7d5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7d8:	6a 01                	push   $0x1
 7da:	52                   	push   %edx
 7db:	57                   	push   %edi
 7dc:	e8 72 fd ff ff       	call   553 <write>
        ap++;
 7e1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7e7:	31 d2                	xor    %edx,%edx
 7e9:	e9 df fe ff ff       	jmp    6cd <printf+0x4d>
 7ee:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7f0:	83 ec 04             	sub    $0x4,%esp
 7f3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7f9:	6a 01                	push   $0x1
 7fb:	e9 31 ff ff ff       	jmp    731 <printf+0xb1>
 800:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 805:	bb de 09 00 00       	mov    $0x9de,%ebx
 80a:	e9 77 ff ff ff       	jmp    786 <printf+0x106>
 80f:	90                   	nop

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 18 0d 00 00       	mov    0xd18,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	39 c8                	cmp    %ecx,%eax
 82c:	73 32                	jae    860 <free+0x50>
 82e:	39 d1                	cmp    %edx,%ecx
 830:	72 04                	jb     836 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	39 d0                	cmp    %edx,%eax
 834:	72 32                	jb     868 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 836:	8b 73 fc             	mov    -0x4(%ebx),%esi
 839:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83c:	39 fa                	cmp    %edi,%edx
 83e:	74 30                	je     870 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 843:	8b 50 04             	mov    0x4(%eax),%edx
 846:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 849:	39 f1                	cmp    %esi,%ecx
 84b:	74 3a                	je     887 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 84d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 84f:	5b                   	pop    %ebx
  freep = p;
 850:	a3 18 0d 00 00       	mov    %eax,0xd18
}
 855:	5e                   	pop    %esi
 856:	5f                   	pop    %edi
 857:	5d                   	pop    %ebp
 858:	c3                   	ret
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 d0                	cmp    %edx,%eax
 862:	72 04                	jb     868 <free+0x58>
 864:	39 d1                	cmp    %edx,%ecx
 866:	72 ce                	jb     836 <free+0x26>
{
 868:	89 d0                	mov    %edx,%eax
 86a:	eb bc                	jmp    828 <free+0x18>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 870:	03 72 04             	add    0x4(%edx),%esi
 873:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 12                	mov    (%edx),%edx
 87a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 50 04             	mov    0x4(%eax),%edx
 880:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 883:	39 f1                	cmp    %esi,%ecx
 885:	75 c6                	jne    84d <free+0x3d>
    p->s.size += bp->s.size;
 887:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 88a:	a3 18 0d 00 00       	mov    %eax,0xd18
    p->s.size += bp->s.size;
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 892:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 895:	89 08                	mov    %ecx,(%eax)
}
 897:	5b                   	pop    %ebx
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 15 18 0d 00 00    	mov    0xd18,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 78 07             	lea    0x7(%eax),%edi
 8b5:	c1 ef 03             	shr    $0x3,%edi
 8b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8bb:	85 d2                	test   %edx,%edx
 8bd:	0f 84 8d 00 00 00    	je     950 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8c5:	8b 48 04             	mov    0x4(%eax),%ecx
 8c8:	39 f9                	cmp    %edi,%ecx
 8ca:	73 64                	jae    930 <malloc+0x90>
  if(nu < 4096)
 8cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d1:	39 df                	cmp    %ebx,%edi
 8d3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8d6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8dd:	eb 0a                	jmp    8e9 <malloc+0x49>
 8df:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8e2:	8b 48 04             	mov    0x4(%eax),%ecx
 8e5:	39 f9                	cmp    %edi,%ecx
 8e7:	73 47                	jae    930 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e9:	89 c2                	mov    %eax,%edx
 8eb:	3b 05 18 0d 00 00    	cmp    0xd18,%eax
 8f1:	75 ed                	jne    8e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8f3:	83 ec 0c             	sub    $0xc,%esp
 8f6:	56                   	push   %esi
 8f7:	e8 bf fc ff ff       	call   5bb <sbrk>
  if(p == (char*)-1)
 8fc:	83 c4 10             	add    $0x10,%esp
 8ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 902:	74 1c                	je     920 <malloc+0x80>
  hp->s.size = nu;
 904:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 907:	83 ec 0c             	sub    $0xc,%esp
 90a:	83 c0 08             	add    $0x8,%eax
 90d:	50                   	push   %eax
 90e:	e8 fd fe ff ff       	call   810 <free>
  return freep;
 913:	8b 15 18 0d 00 00    	mov    0xd18,%edx
      if((p = morecore(nunits)) == 0)
 919:	83 c4 10             	add    $0x10,%esp
 91c:	85 d2                	test   %edx,%edx
 91e:	75 c0                	jne    8e0 <malloc+0x40>
        return 0;
  }
}
 920:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 923:	31 c0                	xor    %eax,%eax
}
 925:	5b                   	pop    %ebx
 926:	5e                   	pop    %esi
 927:	5f                   	pop    %edi
 928:	5d                   	pop    %ebp
 929:	c3                   	ret
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 930:	39 cf                	cmp    %ecx,%edi
 932:	74 4c                	je     980 <malloc+0xe0>
        p->s.size -= nunits;
 934:	29 f9                	sub    %edi,%ecx
 936:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 939:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 93c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 93f:	89 15 18 0d 00 00    	mov    %edx,0xd18
}
 945:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 948:	83 c0 08             	add    $0x8,%eax
}
 94b:	5b                   	pop    %ebx
 94c:	5e                   	pop    %esi
 94d:	5f                   	pop    %edi
 94e:	5d                   	pop    %ebp
 94f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 950:	c7 05 18 0d 00 00 1c 	movl   $0xd1c,0xd18
 957:	0d 00 00 
    base.s.size = 0;
 95a:	b8 1c 0d 00 00       	mov    $0xd1c,%eax
    base.s.ptr = freep = prevp = &base;
 95f:	c7 05 1c 0d 00 00 1c 	movl   $0xd1c,0xd1c
 966:	0d 00 00 
    base.s.size = 0;
 969:	c7 05 20 0d 00 00 00 	movl   $0x0,0xd20
 970:	00 00 00 
    if(p->s.size >= nunits){
 973:	e9 54 ff ff ff       	jmp    8cc <malloc+0x2c>
 978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 97f:	00 
        prevp->s.ptr = p->s.ptr;
 980:	8b 08                	mov    (%eax),%ecx
 982:	89 0a                	mov    %ecx,(%edx)
 984:	eb b9                	jmp    93f <malloc+0x9f>
