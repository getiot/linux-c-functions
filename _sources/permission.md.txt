文件权限控制篇
=============================================

access
---------------------------------------------

判断是否具有存取文件的权限

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int access(const char * pathname, int mode);
```

- 说明：access() 会检查是否可以读/写某一已存在的文件。参数 mode 有几种情况组合，`R_OK`、`W_OK`、`X_OK` 和 `F_OK`。`R_OK`、`W_OK` 与 `X_OK` 用来检查文件是否具有读取、写入和执行的权限。`F_OK` 则是用来判断该文件是否存在。由于 access() 只作权限的核查，并不理会文件形态或文件内容，因此，如果一目录表示为“可写入”，表示可以在该目录中建立新文件等操作，而非意味此目录可以被当做文件处理。例如，你会发现 DOS 的文件都具有“可执行”权限，但用 execve() 执行时则会失败。

- 返回值：若所有欲查核的权限都通过了检查则返回 0 值，表示成功，只要有一权限被禁止则返回 -1。

  错误代码：

  - `EACCESS` 参数pathname 所指定的文件不符合所要求测试的权限。
  - `EROFS` 欲测试写入权限的文件存在于只读文件系统内。
  - `EFAULT` 参数pathname指针超出可存取内存空间。
  - `EINVAL` 参数mode 不正确。
  - `ENAMETOOLONG` 参数pathname太长。
  - `ENOTDIR` 参数pathname为一目录。
  - `ENOMEM` 核心内存不足
  - `ELOOP` 参数pathname有过多符号连接问题。
  - `EIO` I/O 存取错误。

- 附加说明：使用 access() 作用户认证方面的判断要特别小心，例如在 access() 后再做 open() 的空文件可能会造成系统安全上的问题。

- 相关函数：stat，open，chmod，chown，setuid，setgid

**示例**

```c
/* 判断是否允许读取/etc/passwd */
#include <unistd.h>
int main()
{
	if (access("/etc/passwd",R_OK) == 0)
        printf("/etc/passwd can be read\n");
    return 0;
}
```

执行

```shell
/etc/passwd can be read
```


alphasort
---------------------------------------------

依字母顺序排序目录结构

**头文件**

```c
#include <dirent.h>
```

**函数原型**

```c
int alphasort(const struct dirent **a, const struct dirent **b);
```

- 说明：alphasort() 为 scandir() 最后调用 qsort() 函数时传给 qsort() 作为判断的函数，详细说明请参考 scandir() 及 qsort()。
- 返回值：参考 qsort()。
- 附加说明：
- 相关函数：scandir，qsort

**示例**

```c
/* 读取/目录下所有的目录结构，并依字母顺序排列*/
int main()
{
	struct dirent **namelist;
	int i, total;
	total = scandir("/", &namelist, 0, alphasort);
	if(total < 0) {
        perror("scandir");
    }
    else {
        for(i=0; i<total; i++)
            printf("%s\n", namelist[i]->d_name);
        printf("total = %d\n", total);
    }
}
```

执行

```shell
..
.gnome
.gnome_private
ErrorLog
Weblog
bin
boot
dev
dosc
dosd
etc
home
lib
lost+found
misc
mnt
opt
proc
root
sbin
tmp
usr
var
total = 24
```


chdir
---------------------------------------------

改变当前的工作空间（目录）

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int chdir(const char * path);
```

- 说明：chdir() 用来将当前的工作目录改变成以参数 path 所指的目录。
- 返回值：执行成功则返回 0，失败返回 -1，errno 为错误代码。
- 附加说明：
- 相关函数：getcwd，chroot

**示例**

```c
#include <unistd.h>

int main()
{
    chdir("/tmp");
    printf("current working directory: %s\n", getcwd(NULL,NULL));
    return 0;
}
```

执行

```shell
current working directory :/tmp
```


chmod
---------------------------------------------

改变文件的权限

**头文件**

```c
#include <sys/types.h>
#include <sys/stat.h>
```

**函数原型**

```c
int chmod(const char * path, mode_t mode);
```

- 说明：chmod() 会依参数 mode 权限来更改参数 path 指定文件的权限。

  参数 mode 有下列数种组合：

  - `S_ISUID` 04000 文件的（set user-id on execution）位
  - `S_ISGID` 02000 文件的（set group-id on execution）位
  - `S_ISVTX` 01000 文件的sticky位
  - `S_IRUSR`（S_IREAD） 00400 文件所有者具可读取权限
  - `S_IWUSR`（S_IWRITE）00200 文件所有者具可写入权限
  - `S_IXUSR`（S_IEXEC） 00100 文件所有者具可执行权限
  - `S_IRGRP` 00040 用户组具可读取权限
  - `S_IWGRP` 00020 用户组具可写入权限
  - `S_IXGRP` 00010 用户组具可执行权限
  - `S_IROTH` 00004 其他用户具可读取权限
  - `S_IWOTH` 00002 其他用户具可写入权限
  - `S_IXOTH` 00001 其他用户具可执行权限

  只有该文件的所有者或有效用户识别码为 0，才可以修改该文件权限。基于系统安全，如果欲将数据写入一执行文件，而该执行文件具有 `S_ISUID` 或 `S_ISGID` 权限，则这两个位会被清除。如果一目录具有 `S_ISUID` 位权限，表示在此目录下只有该文件的所有者或 root 可以删除该文件。

- 返回值：权限改变成功返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EPERM` 进程的有效用户识别码与欲修改权限的文件拥有者不同，而且也不具 root 权限。
  - `EACCESS` 参数 path 所指定的文件无法存取。
  - `EROFS` 欲写入权限的文件存在于只读文件系统内。
  - `EFAULT` 参数 path 指针超出可存取内存空间。
  - `EINVAL` 参数 mode 不正确。
  - `ENAMETOOLONG` 参数 path 太长。
  - `ENOENT` 指定的文件不存在。
  - `ENOTDIR` 参数 path 路径并非一目录。
  - `ENOMEM` 核心内存不足。
  - `ELOOP` 参数 path 有过多符号连接问题。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：fchmod，stat，open，chown

**示例**

```c
/* 将/etc/passwd 文件权限设成S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH */
#include <sys/types.h>
#include <sys/stat.h>

int main()
{
	chmod("/etc/passwd", S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
    return 0;
}
```


chown
---------------------------------------------

改变文件的所有者

**头文件**

```c
#include <sys/types.h>
#include <unistd.h>
```

**函数原型**

```c
int chown(const char * path, uid_t owner, gid_t group);
```

- 说明：chown() 会将参数 path 指定文件的所有者变更为参数 owner 代表的用户，而将该文件的组变更为参数 group组。如果参数 owner 或 group 为 -1，对应的所有者或组不会有所改变。root 与文件所有者皆可改变文件组，但所有者必须是参数 group 组的成员。当 root 用 chown() 改变文件所有者或组时，该文件若具有 `S_ISUID` 或 `S_ISGID` 权限，则会清除此权限位，此外如果具有 `S_ISGID` 权限但不具 `S_IXGRP` 位，则该文件会被强制锁定，文件模式会保留。
- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。错误代码参考 chmod()。
- 附加说明：
- 相关函数：fchown，lchown，chmod

**示例**

```c
/* 将/etc/passwd 的所有者和组都设为root */
#include <sys/types.h>
#include <unistd.h>

int main()
{
    chown("/etc/passwd", 0, 0);
    return 0;
}
```


chroot
---------------------------------------------

改变根目录

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int chroot(const char * path);
```

- 说明：chroot() 用来改变根目录为参数 path 所指定的目录。只有超级用户才允许改变根目录，子进程将继承新的根目录。

- 返回值：调用成功则返回 0，失败则返 -1，错误代码存于 errno。

  错误代码：

  - `EPERM` 权限不足，无法改变根目录。
  - `EFAULT` 参数path指针超出可存取内存空间。
  - `ENAMETOOLONG` 参数path太长。
  - `ENOTDIR` 路径中的目录存在但却非真正的目录。
  - `EACCESS` 存取目录时被拒绝
  - `ENOMEM` 核心内存不足。
  - `ELOOP` 参数path有过多符号连接问题。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：chdir

**示例**

```c
/* 将根目录改为/tmp ,并将工作目录切换至/tmp */
#include <unistd.h>

int main()
{
    chroot("/tmp");
    chdir("/");
    return 0;
}
```


closedir
---------------------------------------------

关闭目录

**头文件**

```c
#include <sys/types.h>
#include <dirent.h>
```

**函数原型**

```c
int closedir(DIR *dir);
```

- 说明：closedir() 关闭参数 dir 所指的目录流。

- 返回值：关闭成功则返回 0，失败返回 -1，错误原因存于 errno 中。

  错误代码：

  - `EBADF` 参数 dir 为无效的目录流

- 附加说明：

- 相关函数：opendir

**示例**

参考 readir()。


fchdir
---------------------------------------------

改变当前的工作目录

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int fchdir(int fd);
```

- 说明：fchdir() 用来将当前的工作目录改变成以参数 fd 所指的文件描述词。
- 返回值：成功则返回 0，失败返回 -1，errno 为错误代码。
- 附加说明：
- 相关函数：getcwd，chroot

**示例**

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main()
{
    int fd;
    fd = open("/tmp", O_RDONLY);
    fchdir(fd);
    printf("current working directory : %s \n", getcwd(NULL, NULL));
    close(fd);
    return 0;
}
```

执行

```shell
current working directory : /tmp
```


fchmod
---------------------------------------------

改变文件的权限

**头文件**

```c
#include <sys/types.h>
#include <sys/stat.h>
```

**函数原型**

```c
int fchmod(int fildes, mode_t mode);
```

- 说明：fchmod() 会依参数 mode 权限来更改参数 fildes 所指文件的权限。参数 fildes 为已打开文件的文件描述词。参数 mode 请参考 chmod()。

- 返回值：权限改变成功则返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EBADF` 参数 fildes 为无效的文件描述词。
  - `EPERM` 进程的有效用户识别码与欲修改权限的文件所有者不同，而且也不具 root 权限。
  - `EROFS` 欲写入权限的文件存在于只读文件系统内。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：chmod，stat，open，chown

**示例**

```c
#include <sys/stat.h>
#include <fcntl.h>

int main()
{
    int fd;
    fd = open ("/etc/passwd", O_RDONLY);
    fchmod(fd, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
    close(fd);
    return 0;
}
```


fchown
---------------------------------------------

改变文件的所有者

**头文件**

```c
#include <sys/types.h>
#include <unistd.h>
```

**函数原型**

```c
int fchown(int fd, uid_t owner, gid_t group);
```

- 说明：fchown() 会将参数 fd 指定文件的所有者变更为参数 owner 代表的用户，而将该文件的组变更为参数 group 组。如果参数 owner 或 group 为 -1，对映的所有者或组有所改变。参数 fd 为已打开的文件描述词。当 root 用 fchown() 改变文件所有者或组时，该文件若具 S_ISUID 或 S_ISGID 权限，则会清除此权限位。

- 返回值：成功则返回 0，失败则返回 -1，错误原因存于 errno。

  错误代码：

  - `EBADF` 参数 fd 文件描述词为无效的或该文件已关闭。
  - `EPERM` 进程的有效用户识别码与欲修改权限的文件所有者不同，而且也不具 root 权限，或是参数 owner、group 不正确。
  - `EROFS` 欲写入的文件存在于只读文件系统内。
  - `ENOENT` 指定的文件不存在。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：chown，lchown，chmod

**示例**

```c
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

int main()
{
	int fd;
	fd = open ("/etc/passwd",O_RDONLY);
	chown(fd,0,0);
	close(fd);
    return 0;
}
```


fstat
---------------------------------------------

由文件描述词取得文件状态

**头文件**

```c
#include <sys/stat.h>
#include <unistd.h>
```

**函数原型**

```c
int fstat(int fildes, struct stat *buf);
```

- 说明：fstat() 用来将参数fildes所指的文件状态，复制到参数 buf 所指的结构中 (struct stat)。fstat() 与 stat() 作用完全相同，不同处在于传入的参数为已打开的文件描述词。详细内容请参考 stat()。
- 返回值：执行成功则返回 0，失败返回 -1，错误代码存于 errno。
- 附加说明：
- 相关函数：stat，lstat，chmod，chown，readlink，utime

**示例**

```c
#include <sys/stat.h>
#include <unistd.h>
#include <fcntk.h>

int main()
{
    struct stat buf;
    int fd;
    fd = open ("/etc/passwd", O_RDONLY);
    fstat(fd, &buf);
    printf("/etc/passwd file size +%d\n ", buf.st_size);
    return 0;
}
```

执行

```shell
/etc/passwd file size = 705
```


ftruncate
---------------------------------------------

改变文件大小

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int ftruncate(int fd, off_t length);
```

- 说明：ftruncate() 会将参数fd指定的文件大小改为参数 length 指定的大小。参数 fd 为已打开的文件描述词，而且必须是以写入模式打开的文件。如果原来的文件大小比参数 length 大，则超过的部分会被删去。

- 返回值：执行成功则返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EBADF` 参数 fd 文件描述词为无效的或该文件已关闭。
  - `EINVAL` 参数 fd 为一 socket 并非文件，或是该文件并非以写入模式打开。

- 附加说明：

- 相关函数：open，truncate

**示例**

```c

```

执行

```shell

```


getcwd
---------------------------------------------

取得当前的工作目录

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
char * getcwd(char * buf, size_t size);
```

- 说明：getcwd() 会将当前的工作目录绝对路径复制到参数 buf 所指的内存空间，参数 size 为 buf 的空间大小。在调用此函数时，buf 所指的内存空间要足够大，若工作目录绝对路径的字符串长度超过参数 size 大小，则回值 NULL，errno 的值则为 `ERANGE`。倘若参数 buf 为 NULL，getcwd() 会依参数 size 的大小自动配置内存（使用 `malloc()`），如果参数 size 也为 0，则 getcwd() 会依工作目录绝对路径的字符串程度来决定所配置的内存大小，进程可以在使用完此字符串后利用 free() 来释放此空间。
- 返回值：执行成功则将结果复制到参数 buf 所指的内存空间，或是返回自动配置的字符串指针。失败返回 NULL，错误代码存于 errno。
- 附加说明：
- 相关函数：get_current_dir_name，getwd，chdir

**示例**

```c
#include <unistd.h>

int main()
{
    char buf[80];
    getcwd(buf, sizeof(buf));
    printf("current working directory : %s\n", buf);
    return 0;
}
```

执行

```shell
current working directory :/tmp
```


link
---------------------------------------------

建立文件连接

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int link (const char * oldpath, const char * newpath);
```

- 说明：link() 以参数 newpath 指定的名称来建立一个新的连接（硬连接）到参数 oldpath 所指定的已存在文件。如果参数 newpath 指定的名称为一已存在的文件则不会建立连接。

- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EXDEV` 参数 oldpath 与 newpath 不是建立在同一文件系统。
  - `EPERM` 参数 oldpath 与 newpath 所指的文件系统不支持硬连接。
  - `EROFS` 文件存在于只读文件系统内。
  - `EFAULT` 参数 oldpath 或 newpath 指针超出可存取内存空间。
  - `ENAMETOLLONG` 参数 oldpath 或 newpath 太长。
  - `ENOMEM` 核心内存不足。
  - `EEXIST` 参数 newpath 所指的文件名已存在。
  - `EMLINK` 参数 oldpath 所指的文件已达最大连接数目。
  - `ELOOP` 参数 pathname有过多符号连接问题。
  - `ENOSPC` 文件系统的剩余空间不足。
  - `EIO` I/O 存取错误。

- 附加说明：link() 所建立的硬连接无法跨越不同文件系统，如果需要请改用 symlink()。

- 相关函数：symlink，unlink

**示例**

```c
/* 建立/etc/passwd 的硬连接为pass */
#include <unistd.h>

int main()
{
    link("/etc/passwd", "pass");
    return 0;
}
```

执行

```shell

```


lstat
---------------------------------------------

由文件描述词取得文件状态

**头文件**

```c
#include <sys/stat.h>
#include <unistd.h>
```

**函数原型**

```c
int lstat (const char * file_name, struct stat * buf);
```

- 说明：lstat() 与 stat() 作用完全相同，都是取得参数 file_name 所指的文件状态，其差别在于，当文件为符号连接时，lstat() 会返回该 link 本身的状态。详细内容请参考 stat()。
- 返回值：执行成功则返回 0，失败返回 -1，错误代码存于 errno。
- 附加说明：
- 相关函数：stat，fstat，chmod，chown，readlink，utime

**示例**

```c

```

执行

```shell

```


opendir
---------------------------------------------

打开目录

**头文件**

```c
#include <sys/types.h>
#include <dirent.h>
```

**函数原型**

```c
DIR * opendir(const char * name);
```

- 说明：opendir() 用来打开参数 name 指定的目录，并返回 DIR* 形态的目录流，和 open() 类似，接下来对目录的读取和搜索都要使用此返回值。

- 返回值：成功则返回 DIR* 型态的目录流，打开失败则返回 NULL。

  错误代码：

  - `EACCESS` 权限不足。
  - `EMFILE` 已达到进程可同时打开的文件数上限。
  - `ENFILE` 已达到系统可同时打开的文件数上限。
  - `ENOTDIR` 参数 name 非真正的目录。
  - `ENOENT` 参数 name 指定的目录不存在，或是参数 name 为一空字符串。
  - `ENOMEM` 核心内存不足。

- 附加说明：

- 相关函数：open，readdir，closedir，rewinddir，seekdir，telldir，scandir

**示例**

```c

```

执行

```shell

```


readdir
---------------------------------------------

读取目录

**头文件**

```c
#include <sys/types.h>
#include <dirent.h>
```

**函数原型**

```c
struct dirent * readdir(DIR * dir);
```

- 说明：readdir() 返回参数 dir 目录流的下个目录进入点。

  结构 dirent 定义如下：

  ```c
  struct dirent
  {
      ino_t d_ino;               /* 此目录进入点的inode */
      ff_t  d_off;               /* 目录文件开头至此目录进入点的位移 */
      signed short int d_reclen; /* d_name的长度，不包含NULL字符 */
      unsigned char d_type;      /* d_name 所指的文件类型 */
      har d_name[256;            /* 文件名 */
  };
  ```

- 返回值：成功则返回下个目录进入点。有错误发生或读取到目录文件尾则返回 NULL。

  错误代码：`EBADF` 参数 dir 为无效的目录流。

- 附加说明：

- 相关函数：open，opendir，closedir，rewinddir，seekdir，telldir，scandir

**示例**

```c
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

int main()
{
    DIR * dir;
    struct dirent * ptr;
    int i;
    dir = opendir("/etc/rc.d");
    while((ptr = readdir(dir)) != NULL)
    {
        printf("d_name: %s\n", ptr->d_name);
    }
    closedir(dir);
    return 0;
}
```

执行

```shell
d_name:.
d_name:..
d_name:init.d
d_name:rc0.d
d_name:rc1.d
d_name:rc2.d
d_name:rc3.d
d_name:rc4.d
d_name:rc5.d
d_name:rc6.d
d_name:rc
d_name:rc.local
d_name:rc.sysinit
```


readlink
---------------------------------------------

取得符号连接所指的文件

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int readlink(const char * path, char * buf, size_t bufsiz);
```

- 说明：readlink() 会将参数 path 的符号连接内容存到参数 buf 所指的内存空间，返回的内容不是以 NULL 作字符串结尾，但会将字符串的字符数返回。若参数 bufsiz 小于符号连接的内容长度，过长的内容会被截断。

- 返回值：执行成功则传符号连接所指的文件路径字符串，失败则返回 -1，错误代码存于 errno。

  错误代码：

  - `EACCESS` 取文件时被拒绝，权限不够。
  - `EINVAL` 参数 bufsiz 为负数。
  - `EIO` I/O 存取错误。
  - `ELOOP` 欲打开的文件有过多符号连接问题。
  - `ENAMETOOLONG` 参数 path 的路径名称太长。
  - `ENOENT` 参数 path 所指定的文件不存在。
  - `ENOMEM` 核心内存不足。
  - `ENOTDIR` 参数 path 路径中的目录存在但却非真正的目录。

- 附加说明：

- 相关函数：stat，lstat，symlink

**示例**

```c

```

执行

```shell

```


remove
---------------------------------------------

删除文件

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
int remove(const char * pathname);
```

- 说明：remove() 会删除参数 pathname 指定的文件。如果参数 pathname 为一文件，则调用 unlink() 处理，若参数 pathname 为一目录，则调用 rmdir() 来处理。请参考 unlink() 与 rmdir()。

- 返回值：成功则返回 0，失败则返回 -1，错误原因存于 errno。

  错误代码：

  - `EROFS` 欲写入的文件存在于只读文件系统内。
  - `EFAULT` 参数 pathname 指针超出可存取内存空间。
  - `ENAMETOOLONG` 参数 pathname 太长。
  - `ENOMEM` 核心内存不足。
  - `ELOOP` 参数 pathname 有过多符号连接问题。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：link，rename，unlink

**示例**

```c

```

执行

```shell

```


rename
---------------------------------------------

更改文件名称或位置

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
int rename(const char * oldpath, const char * newpath);
```

- 说明：rename() 会将参数 oldpath 所指定的文件名称改为参数 newpath 所指的文件名称。若 newpath 所指定的文件已存在，则会被删除。
- 返回值：执行成功则返回 0，失败返回 -1，错误原因存于 errno
- 附加说明：
- 相关函数：link，unlink，symlink

**示例**

```c
/* 设计一个DOS下的rename指令rename 旧文件名新文件名*/
#include <stdio.h>

int main(int argc,char **argv)
{
    if(argc<3){
        printf("Usage: %s old_name new_name\n",argv[0]);
        return;
    }
    printf("%s=>%s",argc[1],argv[2]);
    if(rename(argv[1],argv[2]<0))
        printf("error!\n");
    else
        printf("ok!\n");
   return 0;
}
```

执行

```shell

```


rewinddir
---------------------------------------------

重设读取目录的位置为开头位置

**头文件**

```c
#include <sys/types.h>
#include <dirent.h>
```

**函数原型**

```c
void rewinddir(DIR *dir);
```

- 说明：rewinddir() 用来设置参数 dir 目录流目前的读取位置为原来开头的读取位置。

- 返回值：无

  错误代码：`EBADF` dir为无效的目录流

- 附加说明：

- 相关函数：open，opendir，closedir，telldir，seekdir，readdir，scandir

**示例**

```c
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

int main()
{
    DIR * dir;
    struct dirent *ptr;
    dir = opendir("/etc/rc.d");
    while((ptr = readdir(dir)) != NULL)
    {
        printf("d_name :%s\n", ptr->d_name);
    }
    rewinddir(dir);
    printf("readdir again!\n");
    while((ptr = readdir(dir)) != NULL)
    {
        printf("d_name: %s\n", ptr->d_name);
    }
    closedir(dir);
    return 0;
}
```

执行

```shell
d_name:.
d_name:..
d_name:init.d
d_name:rc0.d
d_name:rc1.d
d_name:rc2.d
d_name:rc3.d
d_name:rc4.d
d_name:rc5.d
d_name:rc6.d
d_name:rc
d_name:rc.local
d_name:rc.sysinit
readdir again!
d_name:.
d_name:..
d_name:init.d
d_name:rc0.d
d_name:rc1.d
d_name:rc2.d
d_name:rc3.d
d_name:rc4.d
d_name:rc5.d
d_name:rc6.d
d_name:rc
d_name:rc.local
d_name:rc.sysinit
```


seekdir
---------------------------------------------

设置下回读取目录的位置

**头文件**

```c
#include <dirent.h>
```

**函数原型**

```c
void seekdir(DIR * dir, off_t offset);
```

- 说明：seekdir() 用来设置参数 dir 目录流目前的读取位置，在调用 readdir() 时便从此新位置开始读取。参数 offset 代表距离目录文件开头的偏移量。

- 返回值：无

  错误代码：`EBADF` 参数dir为无效的目录流

- 附加说明：

- 相关函数：open，opendir，closedir，rewinddir，telldir，readdir，scandir

**示例**

```c
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

int main()
{
    DIR * dir;
    struct dirent * ptr;
    int offset, offset_5, i = 0;
    dir = opendir("/etc/rc.d");
    while((ptr = readdir(dir)) != NULL)
    {
        offset = telldir(dir);
        if(++i == 5) offset_5 = offset;
        printf("d_name :%s offset :%d \n", ptr->d_name,offset);
    }
    seekdir(dir offset_5);
    printf("Readdir again!\n");
    while((ptr = readdir(dir)) != NULL)
    {
        offset = telldir(dir);
        printf("d_name :%s offset :%d\n", ptr->d_name.offset);
    }
    closedir(dir);
    return 0;
}
```

执行

```shell
d_name : . offset :12
d_name : .. offset:24
d_name : init.d offset 40
d_name : rc0.d offset :56
d_name :rc1.d offset :72
d_name:rc2.d offset :88
d_name:rc3.d offset 104
d_name:rc4.d offset:120
d_name:rc5.d offset:136
d_name:rc6.d offset:152
d_name:rc offset 164
d_name:rc.local offset :180
d_name:rc.sysinit offset :4096
readdir again!
d_name:rc2.d offset :88
d_name:rc3.d offset 104
d_name:rc4.d offset:120
d_name:rc5.d offset:136
d_name:rc6.d offset:152
d_name:rc offset 164
d_name:rc.local offset :180
d_name:rc.sysinit offset :4096
```


stat
---------------------------------------------

取得文件状态

**头文件**

```c
#include <sys/stat.h>
#include <unistd.h>
```

**函数原型**

```c
int stat(const char * file_name, struct stat *buf);
```

- 说明：stat() 用来将参数 file_name 所指的文件状态，复制到参数 buf 所指的结构中。

  下面是 struct stat 内各参数的说明：

  ```c
  struct stat
  {
      dev_t st_dev;             /* 文件的设备编号 */
      ino_t st_ino;             /* 文件的i-node */
      mode_t st_mode;           /* 文件的类型和存取的权限 */
      nlink_t st_nlink;         /* 连到该文件的硬连接数目，刚建立的文件值为1 */
      uid_t st_uid;             /* 文件所有者的用户识别码 */
      gid_t st_gid;             /* 文件所有者的组识别码 */
      dev_t st_rdev;            /* 若此文件为装置设备文件，则为其设备编号 */
      off_t st_size;            /* 文件大小，以字节计算 */
      unsigned long st_blksize; /* 文件系统的I/O缓冲区大小 */
      unsigned long st_blocks;  /* 占用文件区块的个数，每一区块大小为512个字节 */
      time_t st_atime;          /* 文件最近一次被存取或被执行的时间 */
      time_t st_mtime;          /* 文件最后一次被修改的时间 */
      time_t st_ctime;          /* 最近一次被更改的时间 */
  };
  ```

  注意：st_atime 一般只有在用 mknod、utime、read、write 与 tructate 时改变；st_mtime 一般只有在用 mknod、utime 和 write 时才会改变；而 st_ctime 是最近一次被更改的时间，会在文件所有者、组、权限被更改时更新。

  先前所描述的 st_mode 则定义了下列数种情况：

  - `S_IFMT` 0170000 文件类型的位遮罩

  - `S_IFSOCK` 0140000 scoket

  - `S_IFLNK` 0120000 符号连接

  - `S_IFREG` 0100000 一般文件

  - `S_IFBLK` 0060000 区块装置

  - `S_IFDIR` 0040000 目录

  - `S_IFCHR` 0020000 字符装置

  - `S_IFIFO` 0010000 先进先出

  - `S_ISUID` 04000 文件的（set user-id on execution）位

  - `S_ISGID` 02000 文件的（set group-id on execution）位

  - `S_ISVTX` 01000 文件的sticky位

  - `S_IRUSR`（`S_IREAD`） 00400 文件所有者具可读取权限

  - `S_IWUSR`（`S_IWRITE`）00200 文件所有者具可写入权限

  - `S_IXUSR`（`S_IEXEC`） 00100 文件所有者具可执行权限

  - `S_IRGRP` 00040 用户组具可读取权限

  - `S_IWGRP` 00020 用户组具可写入权限

  - `S_IXGRP` 00010 用户组具可执行权限

  - `S_IROTH` 00004 其他用户具可读取权限

  - `S_IWOTH` 00002 其他用户具可写入权限

  - `S_IXOTH` 00001 其他用户具可执行权限

  上述的文件类型在POSIX 中定义了检查这些类型的宏定义

  - `S_ISLNK` （st_mode） 判断是否为符号连接

  - `S_ISREG` （st_mode） 是否为一般文件

  - `S_ISDIR` （st_mode）是否为目录

  - `S_ISCHR` （st_mode）是否为字符装置文件

  - `S_ISBLK` （s3e） 是否为先进先出

  - `S_ISSOCK` （st_mode） 是否为 socket

  若一目录具有 sticky 位（`S_ISVTX`），则表示在此目录下的文件只能被该文件所有者、此目录所有者或 root 来删除或改名。

- 返回值：执行成功则返回 0，失败返回 -1，错误代码存于 errno。

  错误代码：

  - `ENOENT` 参数 file_name 指定的文件不存在。
  - `ENOTDIR` 路径中的目录存在但却非真正的目录。
  - `ELOOP` 欲打开的文件有过多符号连接问题，上限为 16 符号连接。
  - `EFAULT` 参数 buf 为无效指针，指向无法存在的内存空间。
  - `EACCESS` 存取文件时被拒绝。
  - `ENOMEM` 核心内存不足。
  - `ENAMETOOLONG` 参数 file_name 的路径名称太长。

- 附加说明：

- 相关函数：fstat，lstat，chmod，chown，readlink，utime

**示例**

```c
#include <sys/stat.h>
#include <unistd.h>

int main()
{
    struct stat buf;
    stat ("/etc/passwd", &buf);
    printf("/etc/passwd file size = %d \n", buf.st_size);
    return 0;
}
```

执行

```shell
/etc/passwd file size = 705
```


symlink
---------------------------------------------

建立文件符号连接

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int symlink(const char * oldpath, const char * newpath);
```

- 说明：symlink() 以参数 newpath 指定的名称来建立一个新的连接（符号连接）到参数 oldpath 所指定的已存在文件。参数 oldpath 指定的文件不一定要存在，如果参数 newpath 指定的名称为一已存在的文件则不会建立连接。

- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EPERM` 参数 oldpath 与 newpath 所指的文件系统不支持符号连接。
  - `EROFS` 欲测试写入权限的文件存在于只读文件系统内。
  - `EFAULT` 参数 oldpath 或 newpath 指针超出可存取内存空间。
  - `ENAMETOOLONG` 参数 oldpath 或 newpath 太长。
  - `ENOMEM` 核心内存不足。
  - `EEXIST` 参数 newpath 所指的文件名已存在。
  - `EMLINK` 参数 oldpath 所指的文件已达到最大连接数目。
  - `ELOOP` 参数 pathname 有过多符号连接问题。
  - `ENOSPC` 文件系统的剩余空间不足。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：link，unlink

**示例**

```c
#include <unistd.h>
int main()
{
    symlink("/etc/passwd", "pass");
    return 0;
}
```

执行

```shell

```


telldir
---------------------------------------------

取得目录流的读取位置

**头文件**

```c
#include <dirent.h>
```

**函数原型**

```c
long telldir(DIR *dirp);
```

- 说明：telldir() 返回参数 dir 目录流目前的读取位置。此返回值代表距离目录文件开头的偏移量。

- 返回值：返回下个读取位置，有错误发生时返回 -1。

  错误代码：`EBADF` 参数 dir 为无效的目录流。

- 附加说明：

- 相关函数：open，opendir，closedir，rewinddir，seekdir，readdir，scandir

**示例**

```c
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

int main()
{
    DIR *dir;
    struct dirent *ptr;
    int offset;
    dir = opendir("/etc/rc.d");
    while((ptr = readdir(dir)) != NULL)
    {
        offset = telldir (dir);
        printf("d_name : %s offset :%d\n", ptr->d_name, offset);
    }
    closedir(dir);
    return 0;
}
```

执行

```shell
d_name : . offset :12
d_name : .. offset:24
d_name : init.d offset 40
d_name : rc0.d offset :56
d_name :rc1.d offset :72
d_name:rc2.d offset :88
d_name:rc3.d offset 104
d_name:rc4.d offset:120
d_name:rc5.d offset:136
d_name:rc6.d offset:152
d_name:rc offset 164
d_name:rc.local offset :180
d_name:rc.sysinit offset :4096
```


truncate
---------------------------------------------

改变文件大小

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int truncate(const char * path, off_t length);
```

- 说明：truncate() 会将参数 path 指定的文件大小改为参数 length 指定的大小。如果原来的文件大小比参数 length 大，则超过的部分会被删去。

- 返回值：执行成功则返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EACCESS` 参数 path 所指定的文件无法存取。
  - `EROFS` 欲写入的文件存在于只读文件系统内
  - `EFAULT` 参数 path 指针超出可存取内存空间
  - `EINVAL` 参数 path 包含不合法字符
  - `ENAMETOOLONG` 参数 path 太长
  - `ENOTDIR` 参数 path 路径并非一目录
  - `EISDIR` 参数 path 指向一目录
  - `ETXTBUSY` 参数 path 所指的文件为共享程序，而且正被执行中
  - `ELOOP` 参数 path 有过多符号连接问题
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：open，ftruncate

**示例**

```c

```

执行

```shell

```


umask
---------------------------------------------

设置建立新文件时的权限遮罩

**头文件**

```c
#include <sys/types.h>
#include <sys/stat.h>
```

**函数原型**

```c
mode_t umask(mode_t mask);
```

- 说明：umask() 会将系统 umask 值设成参数 mask&0777 后的值，然后将先前的 umask 值返回。在使用 open() 建立新文件时，该参数 mode 并非真正建立文件的权限，而是 (mode&~umask) 的权限值。例如，在建立文件时指定文件权限为 0666，通常 umask 值默认为 022，则该文件的真正权限则为 0666&~022=0644，也就是 rw-r--r-- 返回值此调用不会有错误值返回。
- 返回值：返回值为原先系统的 umask 值。
- 附加说明：
- 相关函数：creat，open

**示例**

```c

```

执行

```shell

```


unlink
---------------------------------------------

删除文件

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int unlink(const char * pathname);
```

- 说明：unlink() 会删除参数 pathname 指定的文件。如果该文件名为最后连接点，但有其他进程打开了此文件，则在所有关于此文件的文件描述词皆关闭后才会删除。如果参数 pathname 为一符号连接，则此连接会被删除。

- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。

  错误代码：

  - `EROFS` 文件存在于只读文件系统内。
  - `EFAULT` 参数 pathname 指针超出可存取内存空间。
  - `ENAMETOOLONG` 参数 pathname太长。
  - `ENOMEM` 核心内存不足。
  - `ELOOP` 参数 pathname 有过多符号连接问题。
  - `EIO` I/O 存取错误。

- 附加说明：

- 相关函数：link，rename，remove

**示例**

```c

```

执行

```shell

```


utime
---------------------------------------------

修改文件的存取时间和更改时间

**头文件**

```c
#include <sys/types.h>
#include <utime.h>
```

**函数原型**

```c
int utime(const char * filename, struct utimbuf * buf);
```

- 说明：utime() 用来修改参数 filename 文件所属的 inode 存取时间。如果参数 buf 为空指针（NULL），则该文件的存取时间和更改时间全部会设为目前时间。

  结构 utimbuf 定义如下：

  ```c
  struct utimbuf
  {
      time_t actime;
      time_t modtime;
  };
  ```

- 返回值：执行成功则返回 0，失败返回 -1，错误代码存于 errno。

  错误代码：

  - `EACCESS` 存取文件时被拒绝，权限不足。
  - `ENOENT` 指定的文件不存在。

- 附加说明：

- 相关函数：utimes，stat

**示例**

```c

```

执行

```shell

```


utimes
---------------------------------------------

修改文件的存取时间和更改时间

**头文件**

```c
#include <sys/types.h>
#include <utime.h>
```

**函数原型**

```c
int utimes(char * filename, struct timeval *tvp);
```

- 说明：utimes() 用来修改参数 filename 文件所属的 inode 存取时间和修改时间。

  结构 timeval 定义如下：

  ```c
  struct timeval
  {
      long tv_sec;
      long tv_usec; /* 微妙*/
  };
  ```

  参数 tvp 指向两个 timeval 结构空间，和 utime() 使用的 utimebuf 结构比较，tvp[0].tc_sec 则为 utimbuf.actime，tvp]1].tv_sec 为 utimbuf.modtime。

- 返回值：执行成功则返回 0。失败返回 -1，错误代码存于 errno。

  错误代码：

  - `EACCESS` 存取文件时被拒绝，权限不足。
  - `ENOENT` 指定的文件不存在。

- 附加说明：

- 相关函数：utime，stat

**示例**

```c

```

执行

```shell

```

