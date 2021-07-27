终端控制篇
=============================================

getopt
---------------------------------------------

分析命令行参数

头文件 `#include <unistd.h>`

函数原型

```c
int getopt(int argc, char * const argv[], const char *optstring);
```

- 说明：getopt() 用来分析命令行参数。参数 argc 和 argv 是由 main() 传递的参数个数和内容。参数 optstring 则代表欲处理的选项字符串。此函数会返回在 argv 中下一个的选项字母，此字母会对应参数 optstring 中的字母。如果选项字符串里的字母后接着冒号 `:`，则表示还有相关的参数，全局变量 optarg 即会指向此额外参数。如果 getopt() 找不到符合的参数则会输出错误信息，并将全局变量 optopt 设为 `?` 字符，如果不希望 getopt() 输出错误信息，则只要将全局变量 opterr 设为 0 即可。
- 返回值：如果找到符合的参数则返回此参数字母，如果参数不在参数 optstring 的选项字母则返回 `?` 字符，分析结束则返回 -1。

示例

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc,char **argv)
{
    int ch;
    opterr = 0;
    while((ch = getopt(argc, argv, "a:bcde")) != -1)
    switch(ch)
    {
    case 'a':
        printf("option a:'%s'\n", optarg);
        break;
    case 'b':
        printf("option b:b\n");
        break;
    default:
        printf("other option:%c\n", ch);
    }
    printf("optopt +%c\n", optopt);
    return 0;
}
```

执行

```shell
$ ./a.out -a 12345 -b -c -d -e -f
option a:'12345'
option b:b
other option:c
other option:d
other option:e
other option:?
optopt +f
```


isatty
---------------------------------------------

判断文件描述符是否为终端机

头文件 `#include <unistd.h>`

函数原型

```c
int isatty(int desc);
```

- 说明：如果参数 desc 所代表的文件描述符为一终端机则返回 1，否则返回 0。
- 返回值：如果文件为终端机则返回 1，否则返回 0。
- 相关函数：ttyname

示例

参考 [ttyname()](#ttyname)


select
---------------------------------------------

I/O 多工机制

头文件

```c
/* According to POSIX.1-2001, POSIX.1-2008 */
#include <sys/select.h>

/* According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
```

函数原型

```c
int select(int nfds, fd_set *readfds, fd_set *writefds,
           fd_set *exceptfds, struct timeval *timeout);
```

- 说明：select() 用来等待文件描述符状态的改变。参数 nfds 代表最大的文件描述符加 1，参数 readfds、writefds 和 exceptfds 称为描述符集，是用来回传该描述符的读、写或例外的状况。底下的宏提供了处理这三种描述符集的方式：
  - `FD_CLR(inr fd, fd_set* set);` 用来清除描述符集 set 中相关 fd 的位；
  - `FD_ISSET(int fd, fd_set *set);` 用来测试描述符集 set 中相关 fd 的位是否为真；
  - `FD_SET(int fd, fd_set*set);` 用来设置描述符集 set 中相关 fd 的位；
  - `FD_ZERO(fd_set *set);` 用来清除描述符集 set 的全部位。
- 参数：timeout 为结构体 timeval，用来设置 select() 的等待时间。其结构定义如下：
  ```c
  struct timeval {
      time_t tv_sec;     /* seconds */
      time_t tv_usec;    /* microseconds */
  };
  ```
  如果参数 timeout 设为 NULL 则表示 select() 没有 timeout。
- 返回值：执行成功则返回文件描述符状态已改变的个数，如果返回 0 代表在描述符状态改变前已超过 timeout 时间，当有错误发生时则返回 -1，错误原因存于 errno，此时参数 readfds、writefds、exceptfds 和 timeout 的值变成不可预测。错误代码说明如下
  - `EBADF` 文件描述符为无效的或该文件已关闭
  - `EINTR` 此调用被信号所中断
  - `EINVAL` 参数 n 为负值
  - `ENOMEM` 内存不足

示例

常见的程序片段

```c
fs_set readset;

FD_ZERO(&readset);
FD_SET(fd, &readset);
select(fd+1, &readset, NULL, NULL, NULL);

if (FD_ISSET(fd, readset) {
    ...
}
```


ttyname
---------------------------------------------

返回一终端机名称

头文件 `#include <unistd.h>`

函数原型

```c
char * ttyname(int desc);
```

- 说明：如果参数 desc 所代表的文件描述符为一终端机，则会将此终端机名称由一字符串指针返回，否则返回 NULL。
- 返回值：如果成功则返回指向终端机名称的字符串指针，有错误情況发生时则返回 NULL。
- 相关函数：isatty

示例

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main()
{
    int fd;
    char *file = "/dev/tty";
    fd = open(file, O_RDONLY);
    printf("%s", file);
    if (isatty(fd)) {
        printf(" is a tty\n");
        printf("ttyname = %s \n", ttyname(fd));
    }
    else {
        printf(" is not a tty\n");
    }
    close(fd);
    return 0;
}
```

执行

```shell
/dev/tty is a tty
ttyname = /dev/tty
```

