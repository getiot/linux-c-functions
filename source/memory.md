内存控制篇
=============================================

> 内存控制函数是 C 标准库中用于动态内存管理的核心函数集合，包括内存分配、释放、重新分配等操作。这些函数允许程序在运行时动态管理内存，是构建复杂数据结构和处理可变大小数据的基础，也是 C 语言编程中需要特别关注内存安全的重要工具。

calloc
---------------------------------------------

配置内存空间

**头文件**

```c
#include <stdlib.h>
```

**函数原型**

```c
void *calloc(size_t nmemb, size_t size);
```

- 说明：calloc() 用来配置 nmemb 个相邻的内存单位，每一单位的大小为 size，并返回指向第一个元素的指针。这和使用 `malloc(nmemb*size)` 的方式效果相同，不过，在 calloc() 配置内存时会将内存内容初始化为 0。
- 返回值：若配置成功则返回一指针，失败则返回 NULL。
- 相关函数：malloc, free, realloc, brk

**示例**

```c
/* 动态配置 10 个 struct test 空间 */
#include<stdlib.h>

struct test
{
    int a[10];
    char b[20];
}

int main()
{
    struct test *ptr = calloc(sizeof(struct test), 10);
}
```


free
---------------------------------------------

释放原先配置的内存

**头文件**

```c
#include <stdlib.h>
```

**函数原型**

```c
void free(void *ptr);
```

- 说明：参数 ptr 为指向先前由 malloc()、calloc() 或 realloc() 所返回的内存指针。调用 free() 后 ptr 所指的内存空间便会被收回。假若参数 ptr 所指的内存空间已被收回或是未知的内存地址，则调用 free() 可能会有无法预期的情况发生。若参数 ptr 为 NULL，则 free() 不会有任何作用。
- 返回值：无
- 相关函数：malloc, calloc, realloc, brk


getpagesize
---------------------------------------------

取得内存分页大小

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
size_t getpagesize(void);
```

- 说明：返回一分页的大小，单位为字节（byte）。此为系统的分页大小，不一定会和硬件分页大小相同。
- 返回值：内存分页大小。
- 附加说明：在 Intel x86 上其返回值应为 4096 bytes。
- 相关函数：sbrk

**示例**

```c
#include <unistd.h>

int main()
{
    printf("page size = %d\n", getpagesize());
}
```


malloc
---------------------------------------------

配置内存空间

**头文件**

```c
#include <stdlib.h>
```

**函数原型**

```c
void * malloc(size_t size);
```

- 说明：malloc() 用来配置内存空间，其大小由指定的 size 决定。
- 返回值：若配置成功则返回一指针，失败则返回 NULL。
- 相关函数：calloc, free, realloc, brk

**示例**

```c
void p = malloc(1024); /* 配置 1k 的内存 */
```


mmap
---------------------------------------------

建立内存映射

**头文件**

```c
#include <unistd.h>
#include <sys/mman.h>
```

**函数原型**

```c
void *mmap(void *start, size_t length, int prot, int flags, int fd, off_t offset);
```

- 说明：mmap() 用来将某个文件内容映射到内存中，对该内存区域的存取即是直接对该文件内容的读写。
- 参数：
  - 参数 **start** 指向欲对应的内存起始地址，通常设为 NULL，代表让系统自动选定地址，对应成功后该地址会返回。
  - 参数 **length** 代表将文件中多大的部分对应到内存。
  - 参数 **prot** 代表映射区域的保护方式，有下列组合：
    - `PROT_EXEC` 映射区域可被执行
    - `PROT_READ` 映射区域可被读取
    - `PROT_WRITE` 映射区域可被写入
    - `PROT_NONE` 映射区域不能存取
  - 参数 **flags** 会影响映射区域的各种特性
    - `MAP_FIXED` 如果参数 start 所指的地址无法成功建立映射时，则放弃映射，不对地址做修正。通常不鼓励用此标志。
    - `MAP_SHARED` 对映射区域的写入数据会复制回文件内，而且允许其他映射该文件的进程共享。
    - `MAP_PRIVATE` 对映射区域的写入操作会产生一个映射文件的复制，即私人的“写入时复制”（copy on write），对此区域作的任何修改都不会写回原来的文件内容。
    - `MAP_ANONYMOUS` 建立匿名映射。此时会忽略参数 fd，不涉及文件，而且映射区域无法和其他进程共享。
    - `MAP_DENYWRITE` 只允许对映射区域的写入操作，其他对文件直接写入的操作将会被拒绝。
    - `MAP_LOCKED` 将映射区域锁定住，这表示该区域不会被置换（swap）。
    - 在调用 mmap() 时必须要指定 `MAP_SHARED` 或 `MAP_PRIVATE`。
  - 参数 **fd** 为 open() 返回的文件描述符，代表欲映射到内存的文件。
  - 参数 **offset** 为文件映射的偏移量，通常设置为 0，代表从文件最前方开始对应，offset 必须是分页大小的整数倍。
- 返回值：若映射成功则返回映射区域的内存起始地址，否则返回 `MAP_FAILED` (-1)，错误原因存于 errno 中。错误代码可能如下：
  - `EBADF` 参数 fd 不是有效的文件描述符。
  - `EACCES` 存取权限有误。如果是 `MAP_PRIVATE` 情況下文件必须可读，使用 `MAP_SHARED` 则要有 `PROT_WRITE` 以及该文件要能写入。
  - `EINVAL` 参数 start、length 或 offset 有一个不合法。
  - `EAGAIN` 文件被锁住，或是有太多内存被锁住。
  - `ENOMEM` 内存不足。
- 相关函数：munmap, open

**示例**

```c
/* 利用 mmap() 来读取 /etc/passwd 文件内容 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

int main()
{
    int fd;
    void *start;
    struct stat sb;
    fd = open("/etc/passwd", O_RDONLY);  /* 打开 /etc/passwd */
    fstat(fd, &sb);  /* 取得文件大小 */
    start = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if(start == MAP_FAILED)  /* 判断是否映射成功 */
        return -1;
    printf("%s", start);
    munmap(start, sb.st_size);  /* 解除映射 */
    closed(fd);
    return 0;
}
```

执行

```shell
root : x : 0 : root : /root : /bin/bash
bin : x : 1 : 1 : bin : /bin :
daemon : x : 2 : 2 :daemon : /sbin
adm : x : 3 : 4 : adm : /var/adm :
lp : x :4 :7 : lp : /var/spool/lpd :
sync : x : 5 : 0 : sync : /sbin : bin/sync :
shutdown : x : 6 : 0 : shutdown : /sbin : /sbin/shutdown
halt : x : 7 : 0 : halt : /sbin : /sbin/halt
mail : x : 8 : 12 : mail : /var/spool/mail :
news : x :9 :13 : news : /var/spool/news :
uucp : x :10 :14 : uucp : /var/spool/uucp :
operator : x : 11 : 0 :operator : /root:
games : x : 12 :100 : games :/usr/games:
gopher : x : 13 : 30 : gopher : /usr/lib/gopher-data:
ftp : x : 14 : 50 : FTP User : /home/ftp:
nobody : x :99: 99: Nobody : /:
xfs :x :100 :101 : X Font Server : /etc/xll/fs : /bin/false
gdm : x : 42 :42 : : /home/gdm: /bin/bash
kids : x : 500 :500 :/home/kids : /bin/bash
```


munmap
---------------------------------------------

解除内存映射

**头文件**

```c
#include <unistd.h>
#include <sys/mman.h>
```

**函数原型**

```c
int munmap(void *start, size_t length);
```

- 说明：munmap() 用来取消参数 start 所指的映射内存起始地址，参数 length 则是欲取消的内存大小。当进程结束或利用 exec 相关函数来执行其他程序时，映射内存会自动解除，但关闭对应的文件描述符时不会解除映射。
- 返回值：如果解除映射成功则返回 0，否则返回 -1，错误原因存于 errno 中（错误代码 EINVAL）。
- 相关函数：mmap

**示例**

参考 [mmap()](#mmap)

