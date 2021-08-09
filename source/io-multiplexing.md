I/O 复用篇
=============================================

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


poll
---------------------------------------------

获取环境变量内容

头文件 `#include <poll.h>`

函数原型

```c
int poll(struct pollfd *fds, nfds_t nfds, int timeout);
```

- 说明：
- 返回值：
- 相关函数：restart_syscall, select, select_tut, epoll, time

示例

```c

```

执行

```shell

```


ppoll
---------------------------------------------

获取环境变量内容

头文件

```c
#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <signal.h>
#include <poll.h>
```

函数原型

```c
int ppoll(struct pollfd *fds, nfds_t nfds, 
          const struct timespec *tmo_p, const sigset_t *sigmask);
```

- 说明：
- 返回值：
- 相关函数：restart_syscall, select, select_tut, epoll, time

示例

```c

```

执行

```shell

```



epoll_create
---------------------------------------------

创建一个新的 epoll 实例

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_create(int size);
```

- 说明：创建一个新的 epoll 实例
- 返回值：
- 相关函数：close, epoll_ctl, epoll_wait, epoll

示例

```c

```

执行

```shell

```



epoll_create1
---------------------------------------------

获取环境变量内容

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_create1(int flags);
```

- 说明：
- 返回值：
- 相关函数：close, epoll_ctl, epoll_wait, epoll

示例

```c

```

执行

```shell

```



epoll_ctl
---------------------------------------------

获取环境变量内容

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
```

- 说明：
- 返回值：
- 相关函数：restart_syscall, select, select_tut, epoll, time

示例

```c

```

执行

```shell

```



epoll_wait
---------------------------------------------

获取环境变量内容

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
```

- 说明：
- 返回值：
- 相关函数：epoll_create, epoll_ctl, epoll

示例

```c

```

执行

```shell

```


epoll_pwait
---------------------------------------------

获取环境变量内容

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_pwait(int epfd, struct epoll_event *events, int maxevents, 
                int timeout, const sigset_t *sigmask);
```

- 说明：
- 返回值：
- 相关函数：epoll_create, epoll_ctl, epoll

示例

```c

```

执行

```shell

```


