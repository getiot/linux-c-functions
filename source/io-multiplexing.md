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

| 参数     | 描述                                                         |
| :------- | :----------------------------------------------------------- |
| size     | 用来告诉内核要监听的 socket 数目一共有多少个，<br/>但从 Linux 2.6.8 开始，size 参数就被忽略，只要大于零即可。 |
| **返回** |                                                              |
| ≥0       | 执行成功返回一个非负整数的文件描述符，作为创建好的 epoll 句柄。 |
| -1       | 执行失败，返回 -1，错误信息可以通过 errno 获得。             |

- 相关函数：epoll_create1, close, epoll_ctl, epoll_wait, epoll



epoll_create1
---------------------------------------------

创建一个新的 epoll 实例

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_create1(int flags);
```

| 参数     | 描述                                                         |
| :------- | :----------------------------------------------------------- |
| flags    | `EPOLL_CLOEXEC` ：在新文件描述符上设置 close-on-exec (`FD_CLOEXEC`) 标志。 |
| **返回** |                                                              |
| ≥0       | 执行成功返回一个非负整数的文件描述符，作为创建好的 epoll 句柄。 |
| -1       | 执行失败，返回 -1，错误信息可以通过 errno 获得。             |

- 说明：当其参数 flags 为 0 时，除了丢弃过时的 size 参数之外，它的效果与 `epoll_create` 一样。
- 相关函数：epoll_create, close, epoll_ctl, epoll_wait, epoll

示例

```c
int main (int argc, char *argv[])
{
    int efd;
    
    efd = epoll_create1 (0);
    if (efd == -1) {
        perror ("epoll_create");
        abort ();
    }
    
    return 0;
}
```



epoll_ctl
---------------------------------------------

这个系统调用用于操作 epoll 函数所生成的实例（该实例由 epfd 指向），向 fd 实施 op 操作。

头文件 `#include <sys/epoll.h>`

函数原型

```c
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
```

| 参数     | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| epfd     | 由 epoll 调用产生的文件描述符                                |
| op       | 操作的类型，具体包含：<br/>- `EPOLL_CTL_ADD` ：注册新的 fd 到 epfd 中；<br/>- `EPOLL_CTL_MOD` ：修改已经注册的 fd 的监听事件；<br/>- `EPOLL_CTL_DEL` ：从 epfd 中删除一个 fd。 |
| fd       | op 实施的对象（需要监听的 fd）                               |
| event    | event 可以是以下几个宏的集合：<br/>- `EPOLLIN` ：表示对应的文件描述符可以读（包括对端 socket 正常关闭）；<br/>- `EPOLLOUT` ：表示对应的文件描述符可以写；<br/>- `EPOLLPRI` ：表示对应的文件描述符有紧急的数据可读（这里应该表示有带外数据到来）；<br/>- `EPOLLERR` ：表示对应的文件描述符发生错误；<br/>- `EPOLLHUP` ：表示对应的文件描述符被挂断；<br/>- `EPOLLET` ：将 epoll 设为边缘触发（ET）模式，这是相对于水平触发（LT）模式来说的；<br/>- `EPOLLONESHOT` ：只监听一次事件，当监听完这次事件之后，如果还需要继续监听这个 socket 的话，需要再次把这个 socket 加入到 epoll 队列里。 |
| **返回** |                                                              |
| 0        | 成功                                                         |
| -1       | 失败，错误信息可以通过 errno 获得                            |

epoll_event 结构体

```c
typedef union epoll_data {
    void        *ptr;
    int          fd;
    uint32_t     u32;
    uint64_t     u64;
} epoll_data_t;

struct epoll_event {
    uint32_t     events;      /* Epoll events */
    epoll_data_t data;        /* User data variable */
};
```

- 相关函数：epoll_create, epoll_wait, poll, epoll

示例

```c
int example(int sfd, int efd)
{
    int ret;
    struct epoll_event event;
    
    event.data.fd = sfd;
    event.events = EPOLLIN | EPOLLET;
    ret = epoll_ctl (efd, EPOLL_CTL_ADD, sfd, &event);
    if (ret == -1) {
        perror ("epoll_ctl");
        return -1;
    }
    return 0;
}
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

