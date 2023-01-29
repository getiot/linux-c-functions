文件操作篇
=============================================

close
---------------------------------------------

关闭文件

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int close(int fd);
```

- 说明：当使用完文件后若已不再需要则可使用 close() 关闭该文件，调用 close() 会让数据写回磁盘，并释放该文件所占用的资源。参数 fd 为先前由 open() 或 creat() 所返回的文件描述词。
- 返回值：若文件顺利关闭则返回 0，发生错误时返回 -1。
- 附加说明：虽然在进程结束时，系统会自动关闭已打开的文件，但仍建议自行关闭文件，并确实检查返回值。
- 相关函数：open，fcntl，shutdown，unlink，fclose

**示例**

```c

```

执行

```shell

```


creat
---------------------------------------------

创建文件

**头文件**

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
```

**函数原型**

```c
int creat(const char * pathname, mode_tmode);
```

- 说明：参数 pathname 指向欲建立的文件路径字符串。creat() 相当于使用下列的调用方式调用 open()。

  ```c
  open(const char * pathname ,(O_CREAT|O_WRONLY|O_TRUNC));
  ```

  关于参数 mode 请参考 [open()](#open) 函数。

- 返回值：creat() 会返回新的文件描述词，若有错误发生则会返回 -1，并把错误代码设给 errno。

  - `EEXIST` 参数 pathname 所指的文件已存在
  - `EACCESS` 参数 pathname 所指定的文件不符合所要求测试的权限
  - `EROFS` 欲打开写入权限的文件存在于只读文件系统内
  - `EFAULT` 参数 pathname 指针超出可存取的内存空间
  - `EINVAL` 参数 mode 不正确
  - `ENAMETOOLONG` 参数 pathname 太长
  - `ENOTDIR` 参数 pathname 为一目录
  - `ENOMEM` 核心内存不足
  - `ELOOP` 参数 pathname 有过多符号连接问题
  - `EMFILE` 已达到进程可同时打开的文件数上限
  - `ENFILE` 已达到系统可同时打开的文件数上限

- 附加说明：creat() 无法建立特别的设备文件，如果需要请使用 mknod()。

- 相关函数：read，write，fcntl，close，link，stat，umask，unlink，fopen

**示例**

```c

```

执行

```shell

```


dup
---------------------------------------------

复制文件描述词

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int dup (int oldfd);
```

- 说明：dup() 用来复制参数 oldfd 所指的文件描述词，并将它返回。此新的文件描述词和参数 oldfd 指的是同一个文件，共享所有的锁定、读写位置和各项权限或旗标。例如，当利用 lseek() 对某个文件描述词作用时，另一个文件描述词的读写位置也会随着改变。不过，文件描述词之间并不共享 close-on-exec 旗标。
- 返回值：当复制成功时，则返回最小及尚未使用的文件描述词。若有错误则返回 -1，errno 会存放错误代码。错误代码 `EBADF` 参数 fd 非有效的文件描述词，或该文件已关闭。
- 附加说明：
- 相关函数：open，close，fcntl，dup2

**示例**

```c

```

执行

```shell

```


dup2
---------------------------------------------

复制文件描述词

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int dup2(int odlfd,int newfd);
```

- 说明：dup2() 用来复制参数 oldfd 所指的文件描述词，并将它拷贝至参数 newfd 后一块返回。若参数 newfd 为一已打开的文件描述词，则 newfd 所指的文件会先被关闭。dup2() 所复制的文件描述词，与原来的文件描述词共享各种文件状态，详情可参考 dup()。
- 返回值：当复制成功时，则返回最小及尚未使用的文件描述词。若有错误则返回 -1，errno 会存放错误代码。
- 附加说明：dup2() 相当于调用 `fcntl(oldfd，F_DUPFD，newfd)`；请参考 fcntl()。
- 相关函数：open，close，fcntl，dup

**示例**

```c

```

执行

```shell

```


fcntl
---------------------------------------------

文件描述词操作

**头文件**

```c
#include <unistd.h>
#include <fcntl.h>
```

**函数原型**

```c
int fcntl(int fd, int cmd, ... /* arg */ );
```

- 说明：fcntl() 用来操作文件描述词的一些特性。参数 fd 代表欲设置的文件描述词，参数 cmd 代表欲操作的指令。有以下几种情况：

  - `F_DUPFD` 用来查找大于或等于参数 arg 的最小且仍未使用的文件描述词，并且复制参数 fd 的文件描述词。执行成功则返回新复制的文件描述词。请参考 [dup2()](#dup2)。
  - `F_GETFD` 取得 close-on-exec 旗标。若此旗标的 `FD_CLOEXEC` 位为 0，代表在调用 `exec()` 相关函数时文件将不会关闭。
  - `F_SETFD` 设置 close-on-exec 旗标。该旗标以参数 arg 的 `FD_CLOEXEC` 位决定。
  - `F_GETFL` 取得文件描述词状态旗标，此旗标为 `open()` 的参数 flags。
  - `F_SETFL` 设置文件描述词状态旗标，参数 arg 为新旗标，但只允许 `O_APPEND`、`O_NONBLOCK` 和 `O_ASYNC` 位的改变，其他位的改变将不受影响。
  - `F_GETLK` 取得文件锁定的状态。
  - `F_SETLK` 设置文件锁定的状态。此时 flcok 结构的 `l_type` 值必须是 `F_RDLCK`、`F_WRLCK` 或 `F_UNLCK`。如果无法建立锁定，则返回 -1，错误代码为 `EACCES` 或 `EAGAIN`。
  - `F_SETLKW` 和 `F_SETLK` 作用相同，但是无法建立锁定时，此调用会一直等到锁定动作成功为止。若在等待锁定的过程中被信号中断时，会立即返回 -1，错误代码为 `EINTR`。

  最后一个参数可以是 flock 结构指针，其定义如下：

  ```c
  struct flcok
  {
      short int l_type;   /* 锁定的状态 */
      short int l_whence; /* 决定l_start位置 */
      off_t l_start;      /* 锁定区域的开头位置 */
      off_t l_len;        /* 锁定区域的大小 */
      pid_t l_pid;        /* 锁定动作的进程 */
  };
  ```

  其中，`l_type` 有三种状态：

  - `F_RDLCK` 建立一个供读取用的锁定
  - `F_WRLCK` 建立一个供写入用的锁定
  - `F_UNLCK` 删除之前建立的锁定

  `l_whence` 也有三种方式：

  - `SEEK_SET` 以文件开头为锁定的起始位置
  - `SEEK_CUR` 以目前文件读写位置为锁定的起始位置
  - `SEEK_END` 以文件结尾为锁定的起始位置

- 返回值：成功则返回 0，若有错误则返回 -1，错误原因存于 errno。

- 附加说明：

- 相关函数：[open](#open)，[flock](#flock)

**示例**

```c

```

执行

```shell

```


flock
---------------------------------------------

锁定文件或解除锁定

**头文件**

```c
#include <sys/file.h>
```

**函数原型**

```c
int flock(int fd,int operation);
```

- 说明：flock() 会依参数 operation 所指定的方式对参数 fd 所指的文件做各种锁定或解除锁定的动作。此函数只能锁定整个文件，无法锁定文件的某一区域。

  参数 operation有下列四种情况：

  - `LOCK_SH` 建立共享锁定。多个进程可同时对同一个文件作共享锁定。
  - `LOCK_EX` 建立互斥锁定。一个文件同时只有一个互斥锁定。
  - `LOCK_UN` 解除文件锁定状态。
  - `LOCK_NB` 无法建立锁定时，此操作可不被阻断，马上返回进程。通常与 `LOCK_SH` 或 `LOCK_EX` 做 OR 组合。

  单一文件无法同时建立共享锁定和互斥锁定，而当使用 dup() 或 fork() 时文件描述词不会继承此种锁定。

- 返回值：返回0表示成功，若有错误则返回-1，错误代码存于errno。

- 附加说明：

- 相关函数：open，fcntl

**示例**

```c

```

执行

```shell

```


fsync
---------------------------------------------

将缓冲区数据写回磁盘

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int fsync(int fd);
```

- 说明：fsync() 负责将参数 fd 所指的文件数据，由系统缓冲区写回磁盘，以确保数据同步。
- 返回值：成功则返回 0，失败返回 -1，errno 为错误代码。
- 附加说明：
- 相关函数：sync

**示例**

```c

```

执行

```shell

```


lseek
---------------------------------------------

移动文件的读写位置

**头文件**

```c
#include<sys/types.h>
#include<unistd.h>
```

**函数原型**

```c
off_t lseek(int fildes,off_t offset ,int whence);
```

- 说明：每一个已打开的文件都有一个读写位置，当打开文件时通常其读写位置是指向文件开头，若是以附加的方式打开文件（如 `O_APPEND`），则读写位置会指向文件尾。当 `read()` 或 `write()` 时，读写位置会随之增加，`lseek()` 便是用来控制该文件的读写位置。参数 fildes 为已打开的文件描述词，参数 offset 为根据参数 whence 来移动读写位置的位移数。

  参数 whence 为下列其中一种：

  - `SEEK_SET` 参数 offset 即为新的读写位置。
  - `SEEK_CUR` 以目前的读写位置往后增加 offset 个位移量。
  - `SEEK_END` 将读写位置指向文件尾后再增加 offset 个位移量。

  当 whence 值为 `SEEK_CUR` 或 `SEEK_END` 时，参数 offet 允许负值的出现。

  下列是几种特别的使用方式：

  - 欲将读写位置移到文件开头时：`lseek(int fildes,0,SEEK_SET);`
  - 欲将读写位置移到文件尾时：`lseek(int fildes，0,SEEK_END);`
  - 想要取得目前文件位置时：`lseek(int fildes，0,SEEK_CUR);`

- 返回值：当调用成功时则返回目前的读写位置，也就是距离文件开头多少个字节。若有错误则返回 -1，errno 会存放错误代码。

- 附加说明：Linux 系统不允许 `lseek()` 操作 tty 设备，此项动作会令 `lseek()` 返回 `ESPIPE`。

- 相关函数：dup，open，fseek

**示例**

```c

```

执行

```shell

```


mkstemp
---------------------------------------------

建立唯一的临时文件

**头文件**

```c
#include <stdlib.h>
```

**函数原型**

```c
int mkstemp(char * template);
```

- 说明：mkstemp() 用来建立唯一的临时文件。参数 template 所指的文件名称字符串中最后六个字符必须是 XXXXXX。`mkstemp()` 会以可读写模式和 0600 权限来打开该文件，如果该文件不存在则会建立该文件。打开该文件后其文件描述词会返回。文件顺利打开后返回可读写的文件描述词。若果文件打开失败则返回 `NULL`，并把错误代码存在 errno 中。

- 返回值：`EINVAL` 参数 template 字符串最后六个字符非 XXXXXX。`EEXIST` 无法建立临时文件。

- 附加说明：参数 template 所指的文件名称字符串必须声明为数组，如

  ```c
  char template[ ] =”template-XXXXXX”;
  ```

  千万不可以使用下列的表达方式

  ```c
  char *template = “template-XXXXXX”;
  ```

- 相关函数：mktemp

**示例**

```c
#include <stdlib.h>

int main(void)
{
    int fd;
    char template[] = "template-XXXXXX";
    fd = mkstemp(template);
    printf("template = %s\n", template);
    close(fd);
}
```

执行

```bash
template = template-lgZcbo
```


open
---------------------------------------------

打开文件

**头文件**

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
```

**函数原型**

```c
int open( const char *pathname, int flags);
int open( const char *pathname, int flags, mode_t mode);
```

- 说明：参数 pathname 指向欲打开的文件路径字符串。下列是参数 flags 所能使用的旗标：

  - `O_RDONLY` 以只读方式打开文件
  - `O_WRONLY` 以只写方式打开文件
  - `O_RDWR` 以可读写方式打开文件。上述三种旗标是互斥的，也就是不可同时使用，但可与下列的旗标利用 OR 运算符组合。
  - `O_CREAT` 若欲打开的文件不存在则自动建立该文件。
  - `O_EXCL` 如果 `O_CREAT` 也被设置，此指令会去检查文件是否存在。文件若不存在则建立该文件，否则将导致打开文件错误。此外，若 `O_CREAT` 与 `O_EXCL` 同时设置，并且欲打开的文件为符号连接，则会打开文件失败。
  - `O_NOCTTY` 如果欲打开的文件为终端机设备时，则不会将该终端机当成进程控制终端机。
  - `O_TRUNC` 若文件存在并且以可写的方式打开时，此旗标会令文件长度清为 0，而原来存于该文件的资料也会消失。
  - `O_APPEND` 当读写文件时会从文件尾开始移动，也就是所写入的数据会以附加的方式加入到文件后面。
  - `O_NONBLOCK` 以不可阻断的方式打开文件，也就是无论有无数据读取或等待，都会立即返回进程之中。
  - `O_NDELAY` 同 `O_NONBLOCK`。
  - `O_SYNC` 以同步的方式打开文件。
  - `O_NOFOLLOW` 如果参数 pathname 所指的文件为一符号连接，则会令打开文件失败。
  - `O_DIRECTORY` 如果参数 pathname 所指的文件并非为一目录，则会令打开文件失败。

  此为 Linux 2.2 以后特有的旗标，以避免一些系统安全问题。参数 mode 则有下列数种组合，只有在建立新文件时才会生效，此外真正建文件时的权限会受到 umask 值所影响，因此该文件权限应该为（mode-umaks）。

  - `S_IRWXU` 00700 权限，代表该文件所有者具有可读、可写及可执行的权限。
  - `S_IRUSR` 或 `S_IREAD`，00400权限，代表该文件所有者具有可读取的权限。
  - `S_IWUSR` 或 `S_IWRITE`，00200 权限，代表该文件所有者具有可写入的权限。
  - `S_IXUSR` 或 `S_IEXEC`，00100 权限，代表该文件所有者具有可执行的权限。
  - `S_IRWXG` 00070权限，代表该文件用户组具有可读、可写及可执行的权限。
  - `S_IRGRP` 00040 权限，代表该文件用户组具有可读的权限。
  - `S_IWGRP` 00020权限，代表该文件用户组具有可写入的权限。
  - `S_IXGRP` 00010 权限，代表该文件用户组具有可执行的权限。
  - `S_IRWXO` 00007权限，代表其他用户具有可读、可写及可执行的权限。
  - `S_IROTH` 00004 权限，代表其他用户具有可读的权限
  - `S_IWOTH` 00002权限，代表其他用户具有可写入的权限。
  - `S_IXOTH` 00001 权限，代表其他用户具有可执行的权限。

- 返回值：若所有欲核查的权限都通过了检查则返回 0 值，表示成功，只要有一个权限被禁止则返回 -1。

  错误代码：

  - `EEXIST` 参数 pathname 所指的文件已存在，却使用了 `O_CREAT` 和 `O_EXCL` 旗标。
  - `EACCESS` 参数 pathname 所指的文件不符合所要求测试的权限。
  - `EROFS` 欲测试写入权限的文件存在于只读文件系统内。
  - `EFAULT` 参数 pathname 指针超出可存取内存空间。
  - `EINVAL` 参数 mode 不正确。
  - `ENAMETOOLONG` 参数 pathname 太长。
  - `ENOTDIR` 参数 pathname 不是目录。
  - `ENOMEM` 核心内存不足。
  - `ELOOP` 参数 pathname 有过多符号连接问题。
  - `EIO` I/O 存取错误。

- 附加说明：使用 `access()` 作用户认证方面的判断要特别小心，例如在 `access()` 后再作 `open()` 空文件可能会造成系统安全上的问题。

- 相关函数：read, write, fcntl, close, link, stat, umask, unlink, fopen

**示例**

```c
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

int main()
{
    int fd,size;
    char s[] = "Linux Programmer!\n", buffer[80];
    fd = open("/tmp/temp", O_WRONLY|O_CREAT);
    write(fd, s, sizeof(s));
    close(fd);
    fd = open("/tmp/temp", O_RDONLY);
    size = read(fd, buffer, sizeof(buffer));
    close(fd);
    printf("%s", buffer);
    return 0;
}
```

执行

```bash
Linux Programmer!
```


read
---------------------------------------------

由已打开的文件读取数据

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
ssize_t read(int fd,void * buf ,size_t count);
```

- 说明：read() 会把参数 fd 所指的文件传送 count 个字节到 buf 指针所指的内存中。若参数 count 为 0，则 read() 不会有作用并返回 0。

- 返回值：返回值为实际读取到的字节数，如果返回 0，表示已到达文件尾或是无可读取的数据，此外文件读写位置会随读取到的字节移动。

  错误代码：

  - `EINTR` 此调用被信号所中断。
  - `EAGAIN` 当使用不可阻断 I/O 时（`O_NONBLOCK`），若无数据可读取则返回此值。
  - `EBADF` 参数 fd 非有效的文件描述词，或该文件已关闭。

- 附加说明：如果顺利 `read()` 会返回实际读到的字节数，最好能将返回值与参数 count 作比较，若返回的字节数比要求读取的字节数少，则有可能读到了文件尾、从管道（pipe）或终端机读取，或者是 `read()` 被信号中断了读取动作。当有错误发生时则返回 -1，错误代码存入 errno 中，而文件读写位置则无法预期。

- 相关函数：readdir，write，fcntl，close，lseek，readlink，fread

**示例**

```c

```

执行

```shell

```


sync
---------------------------------------------

将缓冲区数据写回磁盘

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int sync(void);
```

- 说明：sync() 负责将系统缓冲区数据写回磁盘，以确保数据同步。
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


write
---------------------------------------------

将数据写入已打开的文件内

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
ssize_t write (int fd,const void * buf,size_t count);
```

- 说明：write() 会把参数 buf 所指的内存写入 count 个字节到参数 fd 所指的文件内。当然，文件读写位置也会随之移动。

- 返回值：如果顺利 write() 会返回实际写入的字节数。当有错误发生时则返回 -1，错误代码存入 errno 中。

  错误代码：

  - `EINTR` 此调用被信号所中断。
  - `EAGAIN` 当使用不可阻断 I/O 时（`O_NONBLOCK`），若无数据可读取则返回此值。
  - `EADF` 参数fd非有效的文件描述词，或该文件已关闭。

- 附加说明：

- 相关函数：open，read，fcntl，close，lseek，sync，fsync，fwrite

**示例**

```c

```

执行

```shell

```

