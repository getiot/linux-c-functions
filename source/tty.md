终端控制篇
=============================================

getopt
---------------------------------------------

分析命令行参数

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int getopt(int argc, char * const argv[], const char *optstring);
```

- 说明：getopt() 用来分析命令行参数。参数 argc 和 argv 是由 main() 传递的参数个数和内容。参数 optstring 则代表欲处理的选项字符串。此函数会返回在 argv 中下一个的选项字母，此字母会对应参数 optstring 中的字母。如果选项字符串里的字母后接着冒号 `:`，则表示还有相关的参数，全局变量 optarg 即会指向此额外参数。如果 getopt() 找不到符合的参数则会输出错误信息，并将全局变量 optopt 设为 `?` 字符，如果不希望 getopt() 输出错误信息，则只要将全局变量 opterr 设为 0 即可。
- 返回值：如果找到符合的参数则返回此参数字母，如果参数不在参数 optstring 的选项字母则返回 `?` 字符，分析结束则返回 -1。

**示例**

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

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int isatty(int desc);
```

- 说明：如果参数 desc 所代表的文件描述符为一终端机则返回 1，否则返回 0。
- 返回值：如果文件为终端机则返回 1，否则返回 0。
- 相关函数：ttyname

**示例**

参考 [ttyname()](#ttyname)


ttyname
---------------------------------------------

返回一终端机名称

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
char * ttyname(int desc);
```

- 说明：如果参数 desc 所代表的文件描述符为一终端机，则会将此终端机名称由一字符串指针返回，否则返回 NULL。
- 返回值：如果成功则返回指向终端机名称的字符串指针，有错误情況发生时则返回 NULL。
- 相关函数：isatty

**示例**

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

