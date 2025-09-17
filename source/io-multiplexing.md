I/O 复用篇
=============================================

> I/O 复用（I/O Multiplexing）是一种通过单个线程同时监控多个文件描述符（如套接字）的I/O 事件的技术，以提高服务器处理大量并发连接的效率。它允许一个进程在不创建大量线程或进程的情况下，同时处理多个I/O 操作。
>
> 常见的 I/O 复用模型包括 `select`、`poll` 和 `epoll`，其中 `epoll` 是 Linux 系统中一种更高效、基于事件驱动的实现。

select
---------------------------------------------

I/O 多工机制。

**头文件**

```c
/* According to POSIX.1-2001, POSIX.1-2008 */
#include <sys/select.h>

/* According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
```

**函数原型**

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

**示例**

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

等待文件描述符上的事件。

**头文件**

```c
#include <poll.h>
```

**函数原型**

```c
int poll(struct pollfd *fds, nfds_t nfds, int timeout);
```

- 说明：等待文件描述符上的事件，比select更高效，没有文件描述符数量限制
- 返回值：成功返回就绪的文件描述符数量，超时返回0，失败返回-1
- 相关函数：select, epoll, ppoll

**pollfd 结构体**

```c
struct pollfd {
    int   fd;         /* 文件描述符 */
    short events;     /* 要监听的事件 */
    short revents;    /* 实际发生的事件 */
};
```

**事件标志**

- `POLLIN`: 有数据可读
- `POLLOUT`: 可以写入数据
- `POLLERR`: 发生错误
- `POLLHUP`: 连接被挂起
- `POLLNVAL`: 文件描述符无效

**示例**

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <poll.h>

int main() {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    struct pollfd fds[2];
    char buffer[1024];
    int nfds = 1;
    
    // 创建socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket");
        return 1;
    }
    
    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(8080);
    
    // 绑定地址
    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_fd);
        return 1;
    }
    
    // 监听连接
    if (listen(server_fd, 5) == -1) {
        perror("listen");
        close(server_fd);
        return 1;
    }
    
    printf("服务器启动，监听端口 8080...\n");
    
    // 设置poll文件描述符
    fds[0].fd = server_fd;
    fds[0].events = POLLIN;
    
    while (1) {
        // 等待事件
        int ret = poll(fds, nfds, 5000); // 5秒超时
        
        if (ret == -1) {
            perror("poll");
            break;
        } else if (ret == 0) {
            printf("等待连接中...\n");
            continue;
        }
        
        // 检查服务器socket
        if (fds[0].revents & POLLIN) {
            client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_len);
            if (client_fd == -1) {
                perror("accept");
                continue;
            }
            
            printf("客户端连接: %s:%d\n", 
                   inet_ntoa(client_addr.sin_addr), 
                   ntohs(client_addr.sin_port));
            
            // 添加客户端socket到poll
            fds[1].fd = client_fd;
            fds[1].events = POLLIN;
            nfds = 2;
        }
        
        // 检查客户端socket
        if (nfds > 1 && fds[1].revents & POLLIN) {
            memset(buffer, 0, sizeof(buffer));
            int bytes = recv(client_fd, buffer, sizeof(buffer), 0);
            if (bytes > 0) {
                printf("收到消息: %s\n", buffer);
                
                // 发送响应
                const char *response = "Hello from server!";
                send(client_fd, response, strlen(response), 0);
            } else {
                printf("客户端断开连接\n");
                close(client_fd);
                nfds = 1;
            }
        }
    }
    
    close(server_fd);
    return 0;
}
```

执行

```shell

```


ppoll
---------------------------------------------

等待文件描述符上的事件（支持信号掩码）。

**头文件**

```c
#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <signal.h>
#include <poll.h>
```

**函数原型**

```c
int ppoll(struct pollfd *fds, nfds_t nfds, 
          const struct timespec *tmo_p, const sigset_t *sigmask);
```

- 说明：类似于 poll，但允许指定信号掩码，在等待期间临时屏蔽指定信号
- 返回值：成功返回就绪的文件描述符数量，超时返回0，失败返回-1
- 附加说明：tmo_p 为 timespec 结构体，指定超时时间；sigmask 为信号掩码
- 相关函数：poll, select, epoll_pwait, sigprocmask

**timespec 结构体**

```c
struct timespec {
    time_t tv_sec;   /* 秒 */
    long   tv_nsec;  /* 纳秒 */
};
```

**示例**

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <poll.h>
#include <signal.h>
#include <time.h>

#define _GNU_SOURCE

void signal_handler(int sig) {
    printf("收到信号 %d，但被 ppoll 屏蔽\n", sig);
}

int main() {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    struct pollfd fds[2];
    struct timespec timeout;
    sigset_t sigmask;
    char buffer[1024];
    int nfds = 1;
    
    // 设置信号处理
    signal(SIGUSR1, signal_handler);
    
    // 设置信号掩码，屏蔽 SIGUSR1
    sigemptyset(&sigmask);
    sigaddset(&sigmask, SIGUSR1);
    
    // 创建socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket");
        return 1;
    }
    
    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(8080);
    
    // 绑定地址
    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_fd);
        return 1;
    }
    
    // 监听连接
    if (listen(server_fd, 5) == -1) {
        perror("listen");
        close(server_fd);
        return 1;
    }
    
    printf("服务器启动，监听端口 8080...\n");
    printf("发送 SIGUSR1 信号测试 ppoll 的信号屏蔽功能\n");
    
    // 设置poll文件描述符
    fds[0].fd = server_fd;
    fds[0].events = POLLIN;
    
    while (1) {
        // 设置超时时间为3秒
        timeout.tv_sec = 3;
        timeout.tv_nsec = 0;
        
        // 使用 ppoll 等待事件，屏蔽 SIGUSR1 信号
        int ret = ppoll(fds, nfds, &timeout, &sigmask);
        
        if (ret == -1) {
            perror("ppoll");
            break;
        } else if (ret == 0) {
            printf("等待连接中... (ppoll 超时)\n");
            continue;
        }
        
        // 检查服务器socket
        if (fds[0].revents & POLLIN) {
            client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_len);
            if (client_fd == -1) {
                perror("accept");
                continue;
            }
            
            printf("客户端连接: %s:%d\n", 
                   inet_ntoa(client_addr.sin_addr), 
                   ntohs(client_addr.sin_port));
            
            // 添加客户端socket到poll
            fds[1].fd = client_fd;
            fds[1].events = POLLIN;
            nfds = 2;
        }
        
        // 检查客户端socket
        if (nfds > 1 && fds[1].revents & POLLIN) {
            memset(buffer, 0, sizeof(buffer));
            int bytes = recv(client_fd, buffer, sizeof(buffer), 0);
            if (bytes > 0) {
                printf("收到消息: %s\n", buffer);
                
                // 发送响应
                const char *response = "Hello from ppoll server!";
                send(client_fd, response, strlen(response), 0);
            } else {
                printf("客户端断开连接\n");
                close(client_fd);
                nfds = 1;
            }
        }
    }
    
    close(server_fd);
    return 0;
}
```

执行

```shell
$ gcc -D_GNU_SOURCE example.c -o example
$ ./example &
$ kill -USR1 %1
$ ./example
服务器启动，监听端口 8080...
发送 SIGUSR1 信号测试 ppoll 的信号屏蔽功能
等待连接中... (ppoll 超时)
等待连接中... (ppoll 超时)
```



epoll_create
---------------------------------------------

创建一个新的 epoll 实例

**头文件**

```c
#include <sys/epoll.h>
```

**函数原型**

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

创建一个新的 epoll 实例。

**头文件**

```c
#include <sys/epoll.h>
```

**函数原型**

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

**示例**

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

**头文件**

```c
#include <sys/epoll.h>
```

**函数原型**

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

**示例**

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

等待 epoll 实例上的事件。

**头文件**

```c
#include <sys/epoll.h>
```

**函数原型**

```c
int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
```

- 说明：等待epoll实例上的事件，返回就绪的文件描述符
- 返回值：成功返回就绪的文件描述符数量，超时返回0，失败返回-1
- 相关函数：epoll_create, epoll_ctl, epoll_pwait

**示例**

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/epoll.h>

#define MAX_EVENTS 10

int main() {
    int server_fd, client_fd, epfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    struct epoll_event event, events[MAX_EVENTS];
    char buffer[1024];
    
    // 创建epoll实例
    epfd = epoll_create1(0);
    if (epfd == -1) {
        perror("epoll_create1");
        return 1;
    }
    
    // 创建socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket");
        close(epfd);
        return 1;
    }
    
    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(8080);
    
    // 绑定地址
    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_fd);
        close(epfd);
        return 1;
    }
    
    // 监听连接
    if (listen(server_fd, 5) == -1) {
        perror("listen");
        close(server_fd);
        close(epfd);
        return 1;
    }
    
    // 添加服务器socket到epoll
    event.events = EPOLLIN;
    event.data.fd = server_fd;
    if (epoll_ctl(epfd, EPOLL_CTL_ADD, server_fd, &event) == -1) {
        perror("epoll_ctl");
        close(server_fd);
        close(epfd);
        return 1;
    }
    
    printf("服务器启动，监听端口 8080...\n");
    
    while (1) {
        // 等待事件
        int nfds = epoll_wait(epfd, events, MAX_EVENTS, 5000); // 5秒超时
        
        if (nfds == -1) {
            perror("epoll_wait");
            break;
        } else if (nfds == 0) {
            printf("等待连接中...\n");
            continue;
        }
        
        for (int i = 0; i < nfds; i++) {
            if (events[i].data.fd == server_fd) {
                // 新连接
                client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_len);
                if (client_fd == -1) {
                    perror("accept");
                    continue;
                }
                
                printf("客户端连接: %s:%d\n", 
                       inet_ntoa(client_addr.sin_addr), 
                       ntohs(client_addr.sin_port));
                
                // 添加客户端socket到epoll
                event.events = EPOLLIN;
                event.data.fd = client_fd;
                if (epoll_ctl(epfd, EPOLL_CTL_ADD, client_fd, &event) == -1) {
                    perror("epoll_ctl");
                    close(client_fd);
                }
            } else {
                // 客户端数据
                client_fd = events[i].data.fd;
                memset(buffer, 0, sizeof(buffer));
                int bytes = recv(client_fd, buffer, sizeof(buffer), 0);
                
                if (bytes > 0) {
                    printf("收到消息: %s\n", buffer);
                    
                    // 发送响应
                    const char *response = "Hello from server!";
                    send(client_fd, response, strlen(response), 0);
                } else {
                    printf("客户端断开连接\n");
                    epoll_ctl(epfd, EPOLL_CTL_DEL, client_fd, NULL);
                    close(client_fd);
                }
            }
        }
    }
    
    close(server_fd);
    close(epfd);
    return 0;
}
```

执行

```shell

```



epoll_pwait
---------------------------------------------

等待 epoll 实例上的事件（支持信号掩码）。

**头文件**

```c
#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <sys/epoll.h>
#include <signal.h>
```

**函数原型**

```c
int epoll_pwait(int epfd, struct epoll_event *events, int maxevents, 
                int timeout, const sigset_t *sigmask);
```

- 说明：类似于 epoll_wait，但允许指定信号掩码，在等待期间临时屏蔽指定信号
- 返回值：成功返回就绪的文件描述符数量，超时返回0，失败返回-1
- 附加说明：timeout 为超时时间（毫秒），-1 表示无限等待，0 表示立即返回
- 相关函数：epoll_wait, epoll_create, epoll_ctl, sigprocmask

**示例**

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/epoll.h>
#include <signal.h>

#define _GNU_SOURCE
#define MAX_EVENTS 10

void signal_handler(int sig) {
    printf("收到信号 %d，但被 epoll_pwait 屏蔽\n", sig);
}

int main() {
    int server_fd, client_fd, epfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    struct epoll_event event, events[MAX_EVENTS];
    sigset_t sigmask;
    char buffer[1024];
    
    // 设置信号处理
    signal(SIGUSR1, signal_handler);
    
    // 设置信号掩码，屏蔽 SIGUSR1
    sigemptyset(&sigmask);
    sigaddset(&sigmask, SIGUSR1);
    
    // 创建epoll实例
    epfd = epoll_create1(0);
    if (epfd == -1) {
        perror("epoll_create1");
        return 1;
    }
    
    // 创建socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket");
        close(epfd);
        return 1;
    }
    
    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(8080);
    
    // 绑定地址
    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_fd);
        close(epfd);
        return 1;
    }
    
    // 监听连接
    if (listen(server_fd, 5) == -1) {
        perror("listen");
        close(server_fd);
        close(epfd);
        return 1;
    }
    
    // 添加服务器socket到epoll
    event.events = EPOLLIN;
    event.data.fd = server_fd;
    if (epoll_ctl(epfd, EPOLL_CTL_ADD, server_fd, &event) == -1) {
        perror("epoll_ctl");
        close(server_fd);
        close(epfd);
        return 1;
    }
    
    printf("服务器启动，监听端口 8080...\n");
    printf("发送 SIGUSR1 信号测试 epoll_pwait 的信号屏蔽功能\n");
    
    while (1) {
        // 使用 epoll_pwait 等待事件，屏蔽 SIGUSR1 信号
        int nfds = epoll_pwait(epfd, events, MAX_EVENTS, 3000, &sigmask); // 3秒超时
        
        if (nfds == -1) {
            perror("epoll_pwait");
            break;
        } else if (nfds == 0) {
            printf("等待连接中... (epoll_pwait 超时)\n");
            continue;
        }
        
        for (int i = 0; i < nfds; i++) {
            if (events[i].data.fd == server_fd) {
                // 新连接
                client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_len);
                if (client_fd == -1) {
                    perror("accept");
                    continue;
                }
                
                printf("客户端连接: %s:%d\n", 
                       inet_ntoa(client_addr.sin_addr), 
                       ntohs(client_addr.sin_port));
                
                // 添加客户端socket到epoll
                event.events = EPOLLIN;
                event.data.fd = client_fd;
                if (epoll_ctl(epfd, EPOLL_CTL_ADD, client_fd, &event) == -1) {
                    perror("epoll_ctl");
                    close(client_fd);
                }
            } else {
                // 客户端数据
                client_fd = events[i].data.fd;
                memset(buffer, 0, sizeof(buffer));
                int bytes = recv(client_fd, buffer, sizeof(buffer), 0);
                
                if (bytes > 0) {
                    printf("收到消息: %s\n", buffer);
                    
                    // 发送响应
                    const char *response = "Hello from epoll_pwait server!";
                    send(client_fd, response, strlen(response), 0);
                } else {
                    printf("客户端断开连接\n");
                    epoll_ctl(epfd, EPOLL_CTL_DEL, client_fd, NULL);
                    close(client_fd);
                }
            }
        }
    }
    
    close(server_fd);
    close(epfd);
    return 0;
}
```

执行

```shell
$ gcc -D_GNU_SOURCE example.c -o example
$ ./example &
$ kill -USR1 %1
$ ./example
服务器启动，监听端口 8080...
发送 SIGUSR1 信号测试 epoll_pwait 的信号屏蔽功能
等待连接中... (epoll_pwait 超时)
等待连接中... (epoll_pwait 超时)
```

