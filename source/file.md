文件操作篇
=============================================

close
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


creat
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


dup
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


dup2
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


fcntl
---------------------------------------------

文件描述词操作

头文件

```c
#include <unistd.h>
#include <fcntl.h>
```

函数原型

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

示例

```c

```

执行

```shell

```


flock
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


fsync
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


lseek
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


mkstemp
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


open
---------------------------------------------

简介

头文件

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
```

函数原型

```c
int open( const char *pathname, int flags);
int open( const char *pathname, int flags, mode_t mode);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：read, write, fcntl, close, link, stat, umask, unlink, fopen

示例

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

```shell
Linux Programmer!
```


read
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


sync
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```


write
---------------------------------------------

简介

头文件 `#include <.h>`

函数原型

```c

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

示例

```c

```

执行

```shell

```

