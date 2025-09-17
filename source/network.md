网络接口篇
=============================================

accept
---------------------------------------------

接受 socket 连接

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
int accept(int sockfd, struct sockaddr *addr, int *addrlen);
```

- 说明：accept() 用来接受参数 sockfd 的 socket 连线。参数 sockfd 的 socket 必须先经 bind()、listen() 函数处理过，当有连线进来时 accept() 会返回一个新的 socket 处理代码，往后的数据传送与读取就是经由新的 socket 处理，而原来参数 sockfd 的 socket 能继续使用 accept() 来接受新的连线要求。连线成功时，参数 addr 所指的结构体会被系统填入远程主机的地址数据，参数 addrlen 为 scokaddr 的结构体长度。关于结构体 sockaddr 的定义请参考 bind()。
- 返回值：成功则返回新的 socket 处理代码，失败返回 -1，错误原因存于 errno 中。错误代码如下：
  - `EBADF` 参数 sockfd 非合法 socket 处理代码；
  - `EFAULT` 参数 addr 指针指向无法存取的内存空间；
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket；
  - `EOPNOTSUPP` 指定的 socket 并非 `SOCK_STREAM`；
  - `EPERM` 防火墙拒绝此连接；
  - `ENOBUFS` 系统的缓冲内存不足；
  - `ENOMEM` 核心内存不足。
- 相关函数：socket, bind, listen, connect

**示例**

参考 [listen()](#listen)


bind
---------------------------------------------

绑定 socket

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

- 说明：bind() 用来给参数 sockfd 的 socket 绑定一个 IP 地址，该地址由参数 addr 指向一 sockaddr 结构体，对于不同的 socket domain 定义了一个通用的数据结构。参数 addrlen 为 sockaddr 的结构长度。

  ```c
  struct sockaddr
  {
      unsigned short int sa_family;
      char sa_data[14];
  };
  ```

  sa_family 为调用 socket() 时的 domain 参数，即 AF_XXX 值；sa_data 最多使用 14 个字符长度。

  此 sockaddr 结构体会因为使用不同的 socket domain 而有不同结构定义，例如使用 AF_INET domain，其 socketaddr 结构体定义如下：

  ```c
  struct socketaddr_in
  {
      unsigned short int sin_family;
      uint16_t sin_port;
      struct in_addr sin_addr;
      unsigned char sin_zero[8];
  };
  struct in_addr
  {
      uint32_t s_addr;
  };
  ```

  其中，sin_family 即为 sa_family，sin_port 为使用的 port 编号，sin_addr.s_addr 为 IP 地址，sin_zero 未使用。

- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno 中。错误代码如下：

  - `EBADF` 参数 sockfd 非合法 socket 处理代码；
  - `EACCESS` 权限不足；
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket。

- 相关函数：socket, accept, connect, listen

**示例**

参考 [listen()](#listen)


connect
---------------------------------------------

建立 socket 连接

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

- 说明：connect() 用来将参数 sockfd 对应的 socket 连接到参数 addr 指定的网络地址。结构体 sockaddr 请参考 bind()，参数 addrlen 为 sockaddr 的结构长度。
- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno 中。错误代码如下：
  - `EBADF` 参数 sockfd 非合法 socket 处理代码；
  - `EFAULT` 参数 serv_addr 指针指向无法存取的内存空间；
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket；
  - `EISCONN` 参数 sockfd 的 socket 已是连接状态；
  - `ECONNREFUSED` 连接要求被 server 端拒绝；
  - `ETIMEDOUT` 企图连接的操作超过限定时间仍未有响应；
  - `ENETUNREACH` 无法传送数据包至指定的主机；
  - `EAFNOSUPPORT` sockaddr 结构的 sa_family 不正确；
  - `EALREADY` socket 为不可阻断且先前的连接操作还未完成。
- 相关函数：socket, bind, listen

**示例**

```c
/* 
 * 此程序将创建 TCP client，连接 TCP server，并将键盘输入的字符串传送给 server
 * TCP server 示例请参考 listen()
 */
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 12345
#define SERVER_IP "127.0.0.1"

int main()
{
    int s;
    struct sockaddr_in addr;
    char buffer[256];
    if((s = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket");
        exit(1);
    }
    /* 填写sockaddr_in结构*/
    bzero(&addr, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    /* 尝试连接 */
    if(connect(s, &addr, sizeof(addr)) < 0) {
        perror("connect");
        exit(1);
    }
    /* 接收由server端传来的信息*/
    recv(s, buffer, sizeof(buffer), 0);
    printf("%s\n", buffer);
    while(1) {
        bzero(buffer, sizeof(buffer));
        /* 从标准输入设备获取字符串 */
        read(STDIN_FILENO, buffer, sizeof(buffer));
        /* 将字符串传给server端 */
        if(send(s, buffer, sizeof(buffer), 0) < 0) {
            perror("send");
            exit(1);
        }
    }
}
```

执行

```shell
$ ./connect
Welcome to server!
hi I am client! # 键盘输入
# 按<Ctrl+C>中断程序
```


endprotoent
---------------------------------------------

结束网络协议数据的读取

**头文件**

```c
#include <netdb.h>
```

**函数原型**

```c
void endprotoent(void);
```

- 说明：endprotoent() 用来关闭由 getprotoent() 打开的文件。
- 返回值：无
- 附加说明：
- 相关函数：getprotoent，getprotobyname，getprotobynumber，setprotoent

**示例**

参考 [getprotoent()](#getprotoent)


endservent
---------------------------------------------

结束网络服务数据的读取

**头文件**

```c
#include <netdb.h>
```

**函数原型**

```c
void endservent(void);
```

- 说明：endservent() 用来关闭由 getservent() 所打开的文件。
- 返回值：无
- 相关函数：getservent，getservbyname，getservbyport，setservent

**示例**

参考 [getservent()](#getservent)


gethostbyname
---------------------------------------------

通过主机名获取主机信息。

**头文件**

```c
#include <netdb.h>
#include <sys/socket.h>
```

**函数原型**

```c
struct hostent *gethostbyname(const char *name);
```

- 说明：通过主机名获取主机信息，返回 hostent 结构体指针
- 返回值：成功返回 hostent 结构体指针，失败返回 NULL
- 附加说明：该函数已被弃用，建议使用 getaddrinfo()
- 相关函数：gethostbyaddr, getaddrinfo, getnameinfo

**hostent 结构体定义**

```c
struct hostent {
    char  *h_name;            /* official name of host */
    char **h_aliases;         /* alias list */
    int    h_addrtype;        /* host address type */
    int    h_length;          /* length of address */
    char **h_addr_list;       /* list of addresses */
};
```

**示例**

```c
#include <stdio.h>
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

int main() {
    struct hostent *host;
    char **alias;
    char **addr_list;
    
    // 获取主机信息
    host = gethostbyname("www.baidu.com");
    if (host == NULL) {
        herror("gethostbyname");
        return 1;
    }
    
    printf("主机名: %s\n", host->h_name);
    
    // 打印别名
    printf("别名: ");
    for (alias = host->h_aliases; *alias != NULL; alias++) {
        printf("%s ", *alias);
    }
    printf("\n");
    
    // 打印地址类型
    printf("地址类型: %s\n", 
           host->h_addrtype == AF_INET ? "AF_INET" : "其他");
    
    // 打印IP地址
    printf("IP 地址: ");
    for (addr_list = host->h_addr_list; *addr_list != NULL; addr_list++) {
        printf("%s ", inet_ntoa(*(struct in_addr*)*addr_list));
    }
    printf("\n");
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example
$ ./example
主机名: www.a.shifen.com
别名: www.baidu.com 
地址类型: AF_INET
IP地址: 14.215.177.38 14.215.177.39
```


getsockopt
---------------------------------------------

获取 socket 状态

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen);
```

- 说明：getsockopt() 会将参数 sockfd 所指定的 socket 状态返回。参数 optname 代表欲获取何种选项状态，而参数 optval 则指向欲保存结果的內存地址，参数 optlen 则为该空间的大小。参数 level、optname 请参考 setsockopt()。
- 返回值：成功则返回0，出错返回 -1，错误原因存于 errno。错误代码如下：
  - `EBADF` 参数 sockfd 并非合法的 socket 处理代码；
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket；
  - `ENOPROTOOPT` 参数 optname 指定的选项不正确；
  - `EFAULT` 参数 optval 指针指向无法存取的内存空间。
- 相关函数：setsockopt

**示例**

```c
#include<sys/types.h>
#include<sys/socket.h>

int main()
{
    int s, optval, optlen = sizeof(int);
    if ((s = socket(AF_INET, SOCK_STREAM, 0)) < 0)
        perror("socket");
    getsockopt(s, SOL_SOCKET, SO_TYPE, &optval, &optlen);
    printf("optval = %d\n", optval);
    close(s);
    return 0;
}
```

执行

```shell
optval = 1 # SOCK_STREAM 的定义正是此值
```


htonl
---------------------------------------------

将32位主机字节序转换成网络字节序

**头文件**

```c
#include <netinet/in.h>
```

**函数原型**

```c
unsigned long int htonl(unsigned long int hostlong);
```

- 说明：htonl() 用来将参数指定的32位 hostlong 转换成网络字节序。
- 返回值：返回对应的网络字节序。
- 相关函数：htons，ntohl，ntohs

**示例**

参考 [getservbyport()](#getservbyport) 或 [connect()](#connect)。


htons
---------------------------------------------

将16位主机字节序转换成网络字节序

**头文件**

```c
#include <netinet/in.h>
```

**函数原型**

```c
unsigned short int htons(unsigned short int hostshort);
```

- 说明：htons() 用来将参数指定的16位 hostshort 转换成网络字节序。
- 返回值：返回对应的网络字节序。
- 相关函数：htonl，ntohl，ntohs

**示例**

参考 [connect()](#connect)


inet_addr
---------------------------------------------

将网络地址转成二进制的数字

**头文件**

```c
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
```

**函数原型**

```c
unsigned long int inet_addr(const char *cp);
```

- 说明：inet_addr() 用来将参数 cp 所指的网络地址字符串转换成网络所使用的二进制数字。网络地址字符串是以数字和点组成的字符串，例如 "42.192.64.149"。
- 返回值：成功则返回对应的网络二进制的数字，失败返回 -1。
- 附加说明：
- 相关函数：inet_aton，inet_ntoa


inet_aton
---------------------------------------------

将网络地址转成网络二进制的数字

**头文件**

```c
#include <sys/scoket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
```

**函数原型**

```c
int inet_aton(const char *cp, struct in_addr *inp);
```

- 说明：inet_aton() 用来将参数 cp 所指的网络地址字符串转换成网络使用的二进制的数字，然后存于参数 inp 所指的 in_addr 结构中。结构 in_addr 定义如下：

  ```c
  struct in_addr
  {
      unsigned long int s_addr;
  };
  ```

- 返回值：成功则返回非 0 值，失败返回 0。

- 相关函数：inet_addr，inet_ntoa


inet_ntoa
---------------------------------------------

将网络二进制的数字转换成网络地址

**头文件**

```c
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
```

**函数原型**

```c
char *inet_ntoa(struct in_addr in);
```

- 说明：inet_ntoa() 用来将参数 in 所指的网络二进制的数字转换成网络地址，然后将指向此网络地址字符串的指针返回。
- 返回值：成功则返回字符串指针，失败则返回 NULL。
- 相关函数：inet_addr，inet_aton


listen
---------------------------------------------

等待 socket 连接

**头文件**

```c
#include <sys/socket.h>
```

**函数原型**

```c
int listen(int sockfd, int backlog);
```

- 说明：listen() 用来等待参数 sockfd 的 socket 连接。参数 backlog 指定同时能处理的最大连接要求，如果连接数目达此上限则 client 端将收到 `ECONNREFUSED` 的错误。listen() 并未开始接收连接，只是设置 socket 为 listen 模式，真正接收 client 端连接的是 accept()。通常 listen() 会在 socket()、bind() 之后调用，接着才调用 accept()。
- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。错误代码如下：
  - `EBADF` 参数 sockfd 非合法 socket 处理代码；
  - `EACCESS` 权限不足；
  - `EOPNOTSUPP` 指定的 socket 并未支持 listen 模式。
- 附加说明：listen() 只适用 `SOCK_STREAM` 或 `SOCK_SEQPACKET` 的 socket 类型。如果 socket 为 `AF_INET` 则参数 backlog 最大值可设至 128。
- 相关函数：socket，bind，accept，connect

**示例**

```c
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<unistd.h>

#define PORT      12345
#define MAXSOCKFD 10

int main()
{
    int sockfd, newsockfd, is_connected[MAXSOCKFD], fd;
    struct sockaddr_in addr;
    int addr_len = sizeof(struct sockaddr_in);
    fd_set readfds;
    char buffer[256];
    char msg[] = "Welcome to server!";
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket");
        exit(1);
    }
    bzero(&addr, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(sockfd, &addr, sizeof(addr)) < 0) {
        perror("connect");
        exit(1);
    }
    if (listen(sockfd, 3) < 0) {
        perror("listen");
        exit(1);
    }
    for (fd=0; fd<MAXSOCKFD; fd++)
        is_connected[fd] = 0;
    
    while (1) {
        FD_ZERO(&readfds);
        FD_SET(sockfd, &readfds);
        for(fd=0; fd<MAXSOCKFD; fd++) {
            if (is_connected[fd])
                FD_SET(fd, &readfds);
        }
        if (!select(MAXSOCKFD, &readfds, NULL, NULL, NULL))
            continue;
        
        for (fd=0; fd<MAXSOCKFD; fd++)
        {
            if (FD_ISSET(fd, &readfds)) {
                if (sockfd == fd){
                    if ((newsockfd = accept(sockfd, &addr, &addr_len)) < 0)
                        perror("accept");
                    write(newsockfd, msg, sizeof(msg));
                    is_connected[newsockfd] = 1;
                    printf("connect from %s\n", inet_ntoa(addr.sin_addr));
                } else {
                    bzero(buffer, sizeof(buffer));
                    if (read(fd, buffer, sizeof(buffer)) <= 0) {
                        printf("connect closed.\n");
                        is_connected[fd] = 0;
                        close(fd);
                    } else
                        printf("%s", buffer);
                }
            }
        }
    }
}
```

执行

```shell
$ ./listen
connect from 127.0.0.1
hi I am client
connected closed.
```


ntohl
---------------------------------------------

将32位网络字节序转换成主机字节序

**头文件**

```c
#include <netinet/in.h>
```

**函数原型**

```c
unsigned long int ntohl(unsigned long int netlong);
```

- 说明：ntohl() 用来将参数指定的32位 netlong 转换成主机字节序。
- 返回值：返回对应的主机字节序。
- 相关函数：htonl，htons，ntohs

**示例**

参考 [getservent()](#getservent)


ntohs
---------------------------------------------

将16位网络字节序转换成主机字节序

**头文件**

```c
#include <netinet/in.h>
```

**函数原型**

```c
unsigned short int ntohs(unsigned short int netshort);
```

- 说明：ntohs() 用来将参数指定的16位 netshort 转换成主机字节序。
- 返回值：返回对应的主机字节序。
- 相关函数：htonl，htons，ntohl

**示例**

参考 [getservent()](#getservent)


recv
---------------------------------------------

经 socket 接收数据

**头文件**

```c
#include<sys/types.h>
#include<sys/socket.h>
```

**函数原型**

```c
ssize_t recv(int sockfd, void *buf, size_t len, int flags);
```

- 说明：recv() 用来接收远端主机经指定的 socket 传来的数据，并把数据存到由参数 buf 指向的内存空间，参数 len 为可接收数据的最大长度。参数 flags 一般设为 0，其可用定义如下：
  - `MSG_OOB` 接收以 out-of-band 送出的数据；
  - `MSG_PEEK` 返回来的数据并不会在系统内删除，如果再调用 recv() 会返回相同的数据内容；
  - `MSG_WAITALL` 强迫接收到 len 大小的数据后才能返回，除非有错误或信号产生；
  - `MSG_NOSIGNAL` 此操作不愿被 SIGPIPE 信号中断。
- 返回值：成功则返回接收到的字符数，失败返回 -1，错误原因存于 errno 中。错误代码如下：
  - `EBADF` 参数 sockfd 非合法的 socket 处理代码
  - `EFAULT` 参数中有一指针指向无法存取的内存空间
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket
  - `EINTR` 被信号所中断
  - `EAGAIN` 此动作会令进程阻断，但参数 sockfd 为不可阻断
  - `ENOBUFS` 系统的缓冲内存不足
  - `ENOMEM` 系统内存不足
  - `EINVAL` 传给系统调用的参数不正确
- 附加说明：recv() 主要用于 TCP 通信。
- 相关函数：recvfrom，recvmsg，send，sendto，socket

**示例**

参考 [listen()](#listen)


recvfrom
---------------------------------------------

经 socket 接收数据

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags,
                 struct sockaddr *src_addr, socklen_t *addrlen);
```

- 说明：recvfrom() 用来接收远程主机经指定的 socket 传来的数据，并把数据存到由参数 buf 指向的内存空间，参数 len 为可接收数据的最大长度。参数 flags 一般设为 0，其他数值定义请参考 [`recv()`](#recv)。参数 src_addr 用来指定欲传送的网络地址，结构体 sockaddr 请参考 [`bind()`](#bind)。参数 addrlen 为 sockaddr 的结构长度。
- 返回值：成功则返回接收到的字符数，失败则返回 -1，错误原因存于 errno 中。错误代码如下：
  - `EBADF` 参数 sockfd 非合法的 socket 处理代码
  - `EFAULT` 参数中有一指针指向无法存取的内存空间
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket
  - `EINTR` 被信号所中断
  - `EAGAIN` 此动作会令进程阻断，但参数 sockfd 为不可阻断
  - `ENOBUFS` 系统的缓冲内存不足
  - `ENOMEM` 系统内存不足
  - `EINVAL` 传给系统调用的参数不正确
- 附加说明：recvfrom() 主要用于 UDP 通信。
- 相关函数：recv，recvmsg，send，sendto，socket

**示例**

```c
/*
 * 此程序创建UDP client，连接UDP server，并将键盘输入的字符串传给server
 * UDP server 示例请参考 sendto()
*/
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<sys/typs.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>

#define PORT      23456
#define SERVER_IP "127.0.0.1"

int main()
{
    int s,len;
    struct sockaddr_in addr;
    int addr_len =sizeof(struct sockaddr_in);
    char buffer[256];
    /* 建立socket*/
    if((s = socket(AF_INET,SOCK_DGRAM,0))<0){
        perror("socket");
        exit(1);
    }
    /* 填写sockaddr_in*/
    bzero(&addr,sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    while(1){
        bzero(buffer,sizeof(buffer));
        /* 从标准输入设备获取字符串 */
        len =read(STDIN_FILENO,buffer,sizeof(buffer));
        /* 将字符串传送给server端 */
        sendto(s,buffer,len,0,&addr,addr_len);
        /* 接收server端返回的字符串 */
        len = recvfrom(s,buffer,sizeof(buffer),0,&addr,&addr_len);
        printf("receive: %s", buffer);
    }
}
```

执行（先执行 udp server，再执行 udp client）

```shell
hello # 从键盘输入字符串
receive: hello # server端返回来的字符串
```


recvmsg
---------------------------------------------

经 socket 接收数据

**头文件**

```c
#include <sys/types.h>
#include <sys/socktet.h>
```

**函数原型**

```c
ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);
```

- 说明：recvmsg() 用于接收远程主机经指定的 socket 传来的数据。参数 sockfd 为已建立好连接的 socket，如果利用 UDP 协议则不需经过连接操作。参数 msg 指向欲连接的数据结构内容，参数 flags 一般设为 0，详细描述请参考 send()。关于结构 msghdr 的定义请参考 sendmsg()。
- 返回值：成功则返回接收到的字节数，失败则返回 -1，错误原因存于 errno 中。错误代码如下：
  - `EBADF` 参数 sockfd 非合法的 socket 处理代码
  - `EFAULT` 参数中有一指针指向无法存取的内存空间
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket
  - `EINTR` 被信号所中断
  - `EAGAIN` 此动作会令进程阻断，但参数 sockfd 为不可阻断
  - `ENOBUFS` 系统的缓冲内存不足
  - `ENOMEM` 系统内存不足
  - `EINVAL` 传给系统调用的参数不正确
- 相关函数：recv，recvfrom，send，sendto，sendmsg，socket

**示例**

参考 [recvfrom()](#recvfrom)


send
---------------------------------------------

经 socket 发送数据

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
ssize_t send(int sockfd, const void *buf, size_t len, int flags);
```

- 说明：send() 用来将数据由指定的 socket 传给对方主机。参数 sockfd 为已建立好连接的 socket，参数 buf 指向要发送的数据内容，参数 len 为数据长度，参数 flags 一般设为 0。flags 的其他含义如下：
  - `MSG_OOB` 传送的数据以 out-of-band 送出；
  - `MSG_DONTROUTE` 取消路由表查询；
  - `MSG_DONTWAIT` 设置为不可阻断运作；
  - `MSG_NOSIGNAL` 此动作不愿被 SIGPIPE 信号中断。
- 返回值：成功则返回实际传送出去的字节数，失败返回 -1，错误原因存于 errno。错误代码如下：
  - `EBADF` 参数 sockfd 非合法的 socket 处理代码
  - `EFAULT` 参数中有一指针指向无法存取的内存空间
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket
  - `EINTR` 被信号所中断
  - `EAGAIN` 此动作会令进程阻断，但参数 sockfd 的 socket 为不可阻断
  - `ENOBUFS` 系统的缓冲内存不足
  - `ENOMEM` 系统内存不足
  - `EINVAL` 传给系统调用的参数不正确
- 附加说明：send() 主要用于 TCP 通信。
- 相关函数：sendto，sendmsg，recv，recvfrom，socket

**示例**

参考 [connect()](#connect)


sendto
---------------------------------------------

经 socket 传送数据

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
               const struct sockaddr *dest_addr, socklen_t addrlen);
```

- 说明：sendto() 用来将数据由指定的 socket 传给对方主机。参数 sockfd 为已建立好连接的 socket，如果使用 UDP 协议则不需要经过连接操作。参数 buf 指向要发送的数据内容，参数 len 为数据长度，参数 flags 一般设为 0，详细描述请参考 send()。参数 dest_addr 用来指定欲传送的网络地址，结构体 sockaddr 请参考 bind()。参数 addrlen 为 sockaddr 的结构长度。
- 返回值：成功则返回实际传送出去的字节数，失败返回 -1，错误原因存于 errno。错误代码如下：
  - `EBADF` 参数 sockfd 非合法的 socket 处理代码
  - `EFAULT` 参数中有一指针指向无法存取的内存空间
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket
  - `EINTR` 被信号所中断
  - `EAGAIN` 此动作会令进程阻断，但参数 sockfd 的 socket 为不可阻断
  - `ENOBUFS` 系统的缓冲内存不足
  - `ENOMEM` 系统内存不足
  - `EINVAL` 传给系统调用的参数不正确
- 附加说明：sendto() 主要用于 UDP 通信。
- 相关函数：send , sendmsg,recv , recvfrom , socket

**示例**

```c
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet.in.h>
#include <arpa.inet.h>

#define PORT 2345

int main()
{
    int sockfd,len;
    struct sockaddr_in addr;
    char buffer[256];
    
    /* 建立 socket */
    if(sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("socket");
        exit(1);
    }
    /* 填写 sockaddr_in 结构体 */
    bzero(&addr, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr = hton1(INADDR_ANY);
    if (bind(sockfd, &addr, sizeof(addr)) < 0) {
        perror("connect");
        exit(1);
    }
    while(1) {
        bezro(buffer, sizeof(buffer));
        len = recvfrom(socket, buffer, sizeof(buffer), 0 , &addr, &addr_len);
        /* 显示 client 端的网络地址 */
        printf("receive from %s\n", inet_ntoa(addr.sin_addr));
        /* 将字串返回给 client 端 */
        sendto(sockfd, buffer, len, 0, &addr, addr_len);
    }
}
```


sendmsg
---------------------------------------------

经 socket 传送数据

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
```

- 说明：sendmsg() 用来将数据由指定的 socket 传给对方主机。参数 sockfd 为已建立好连接的 socket，如果使用 UDP 协议则不需要经过连接操作。参数 msg 为要发送的数据结构内容，参数 flags 一般设为 0，详细描述请参考 send()。结构体 msghdr 的定义如下：

  ```c
  struct msghdr {
      void         *msg_name;       /* Optional address */
      socklen_t     msg_namelen;    /* Size of address */
      struct iovec *msg_iov;        /* Scatter/gather array */
      size_t        msg_iovlen;     /* # elements in msg_iov */
      void         *msg_control;    /* Ancillary data, see below */
      size_t        msg_controllen; /* Ancillary data buffer len */
      int           msg_flags;      /* Flags (unused) */
  };
  ```

- 返回值：成功则返回实际传送出去的字节数，失败返回 -1，错误原因存于 errno。错误代码如下：

  - `EBADF` 参数 sockfd 非合法的 socket 处理代码
  - `EFAULT` 参数中有一指针指向无法存取的内存空间
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket
  - `EINTR` 被信号所中断
  - `EAGAIN` 此动作会令进程阻断，但参数 sockfd 的 socket 为不可阻断
  - `ENOBUFS` 系统的缓冲内存不足
  - `ENOMEM` 系统内存不足
  - `EINVAL` 传给系统调用的参数不正确

- 相关函数：send，sendto，recv，recvfrom，recvmsg，socket

**示例**

参考 [`sendto()`](#sendto)


setprotoent
---------------------------------------------

打开网络协议的数据文件

**头文件**

```c
#include <netdb.h>
```

**函数原型**

```c
void setprotoent(int stayopen);
```

- 说明：setprotoent() 用来打开 /etc/protocols， 如果参数 stayopen 值为 1，则接下来的 getprotobyname() 或 getprotobynumber() 将不会自动关闭此文件。
- 返回值：无
- 相关函数：getprotobyname, getprotobynumber, endprotoent


setservent
---------------------------------------------

打开主机网络服务的数据文件

**头文件**

```c
#include <netdb.h>
```

**函数原型**

```c
void setservent(int stayopen);
```

- 说明：setservent() 用来打开 /etc/services，如果参数 stayopen 值为1，则接下来的 getservbyname() 或 getservbyport() 将不会自动关闭文件。
- 返回值：无
- 相关函数：getservent, getservbyname, getservbyport, endservent


setsockopt
---------------------------------------------

设置 socket 状态

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
int setsockopt(int sockfd, int level, int optname,
               const void *optval, socklen_t optlen);
```

- 说明：setsockopt() 用来设置参数 sockfd 所指定的 socket 状态；参数 level 代表欲设置的网络层；一般设成 `SOL_SOCKET` 以存取 socket 层；参数 optname 代表欲设置的选项；参数 optval 代表欲设置的值，参数 optlen 则为 optval 的长度。其中， optname 有下列几种数值：
  - `SO_DEBUG` 打开或关闭排错模式；
  - `SO_REUSEADDR` 允许在 bind() 过程中本地地址可重复使用；
  - `SO_TYPE` 返回 socket 类型；
  - `SO_ERROR` 返回 socket 已发生的错误原因；
  - `SO_DONTROUTE` 送出的数据包不要利用路由设备来传输；
  - `SO_BROADCAST` 使用广播方式传送；
  - `SO_SNDBUF` 设置发送的暂存区大小；
  - `SO_RCVBUF` 设置接收的暂存区大小；
  - `SO_KEEPALIVE` 定期确定连线是否已终止；
  - `SO_OOBINLINE` 当接收到 OOB 数据时会马上送至标准输入设备；
  - `SO_LINGER` 确保数据安全且可靠地传送出去。
- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。错误代码如下：
  - `EBADF` 参数 sockfd 并非合法的 socket 处理代码；
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket；
  - `ENOPROTOOPT` 参数 optname 指定的选项不正确；
  - `EFAULT` 参数 optval 指针指向无法存取的内存空间。
- 相关函数：getsockopt

**示例**

参考 [getsockopt()](#getsockopt)


shutdown
---------------------------------------------

终止 socket 通信

**头文件**

```c
#include <sys/socket.h>
```

**函数原型**

```c
int shutdown(int sockfd, int how);
```

- 说明：shutdown() 用来终止参数 sockfd 所指定的 socket 连接；参数 how 有下列几种情况：
  - how=0 终止读取操作；
  - how=1 终止传送操作；
  - how=2 终止读取及传送操作。
- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。错误代码如下：
  - `EBADF` 参数 sockfd 并非合法的 socket 处理代码；
  - `ENOTSOCK` 参数 sockfd 为一文件描述符，非 socket；
  - `ENOTCONN` 参数 sockfd 指定的 socket 并未连接。
- 相关函数：socket，connect


socket
---------------------------------------------

建立一个 socket 通信

**头文件**

```c
#include <sys/types.h>
#include <sys/socket.h>
```

**函数原型**

```c
int socket(int domain, int type, int protocol);
```

- 说明：socket() 用来建立一个新的 socket，也就是向系统注册，通知系统建立一通信端口。参数 domain 指定使用何种地址类型，完整的定义在 /usr/include/bits/socket.h 中，下面是常见的协议：

  - `PF_UNIX` / `PF_LOCAL` / `AF_UNIX` / `AF_LOCAL` UNIX 进程通信协议
  - `PF_INET` / `AF_INET` IPv4 网络协议
  - `PF_INET6` / `AF_INET6` IPv6 网络协议
  - `PF_IPX` / `AF_IPX` IPX-Novell 协议
  - `PF_NETLINK` / `AF_NETLINK` 核心用户接口装置
  - `PF_X25` / `AF_X25` ITU-T X.25/ISO-8208 协议
  - `PF_AX25` / `AF_AX25` 业余无线 AX.25 协议
  - `PF_ATMPVC` / `AF_ATMPVC` 存取原始 ATM PVCs
  - `PF_APPLETALK` / `AF_APPLETALK` appletalk（DDP）协议
  - `PF_PACKET` / `AF_PACKET` 初级封包接口

  参数 type 有下列几种数值：

  - `SOCK_STREAM` 提供双向连续且可信赖的数据流，即 TCP。支持 OOB 机制，在所有数据传送前必须使用 connect() 来建立连接状态。
  - `SOCK_DGRAM` 使用不连续不可信赖的数据包连接，即 UDP。
  - `SOCK_SEQPACKET` 提供连续可信赖的数据包连接。
  - `SOCK_RAW` 提供原始网络协议存取。
  - `SOCK_RDM` 提供可信赖的数据包连接。
  - `SOCK_PACKET` 提供和网络驱动程序直接通信。

  参数 protocol 用来指定 socket 所使用的传输协议编号，通常不用管它，设为 0 即可。

- 返回值：成功则返回 0，失败返回 -1，错误原因存于 errno。错误代码如下：

  - `EPROTONOSUPPORT` 参数 domain 指定的类型不支持参数 type 或 protocol 指定的协议；
  - `ENFILE` 系统内存不足，无法建立新的 socket 结构；
  - `EMFILE` 进程文件表溢出，无法再建立新的 socket；
  - `EACCESS` 权限不足，无法建立 type 或 protocol 指定的协议；
  - `ENOBUFS` / `ENOMEM` 内存不足；
  - `EINVAL` 参数 domain/type/protocol 不合法。

- 相关函数：accept，bind，connect，listen

**示例**

参考 [connect()](#connect)

res_ninit
---------------------------------------------

初始化 DNS 解析器状态。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int res_ninit(res_state statp);
```

- 说明：初始化 DNS 解析器状态，设置默认的 DNS 服务器和配置
- 返回值：成功返回 0，失败返回 -1
- 附加说明：用于初始化 res_state 结构体，设置 DNS 查询参数
- 相关函数：res_nclose, res_nquery, res_nsearch

**res_state 结构体**

```c
typedef struct __res_state {
    int retrans;          /* 重传次数 */
    int retry;            /* 重试次数 */
    u_long options;       /* 解析选项 */
    int nscount;          /* 名称服务器数量 */
    struct sockaddr_in nsaddr_list[3]; /* 名称服务器地址 */
    // ... 其他字段
} res_state;
```

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("DNS 解析器初始化成功\n");
    printf("重传次数: %d\n", state.retrans);
    printf("重试次数: %d\n", state.retry);
    printf("名称服务器数量: %d\n", state.nscount);
    
    // 打印名称服务器地址
    for (int i = 0; i < state.nscount; i++) {
        printf("DNS 服务器 %d: %s\n", i + 1, 
               inet_ntoa(state.nsaddr_list[i].sin_addr));
    }
    
    // 关闭解析器
    res_nclose(&state);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
DNS 解析器初始化成功
重传次数: 2
重试次数: 3
名称服务器数量: 1
DNS 服务器 1: 127.0.0.1
```


res_nclose
---------------------------------------------

关闭 DNS 解析器状态。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
void res_nclose(res_state statp);
```

- 说明：关闭 DNS 解析器状态，释放相关资源
- 返回值：无
- 附加说明：与 res_ninit 配对使用，清理解析器状态
- 相关函数：res_ninit, res_nquery, res_nsearch

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("DNS 解析器初始化成功\n");
    printf("名称服务器数量: %d\n", state.nscount);
    
    // 打印名称服务器地址
    for (int i = 0; i < state.nscount; i++) {
        printf("DNS 服务器 %d: %s\n", i + 1, 
               inet_ntoa(state.nsaddr_list[i].sin_addr));
    }
    
    // 关闭解析器
    res_nclose(&state);
    printf("DNS 解析器已关闭\n");
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
DNS 解析器初始化成功
名称服务器数量: 1
DNS 服务器 1: 127.0.0.1
DNS 解析器已关闭
```

res_nquery
---------------------------------------------

执行 DNS 查询。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int res_nquery(res_state statp, const char *dname, int class, int type,
               u_char *answer, int anslen);
```

- 说明：执行 DNS 查询，查询指定域名的记录
- 返回值：成功返回查询结果长度，失败返回 -1
- 附加说明：dname 为域名，class 为查询类（通常为 C_IN），type 为查询类型
- 相关函数：res_ninit, res_nclose, res_nsearch

**查询类型常量**

```c
#define T_A     1    /* IPv4 地址 */
#define T_NS    2    /* 名称服务器 */
#define T_CNAME 5    /* 别名 */
#define T_MX    15   /* 邮件交换 */
#define T_TXT   16   /* 文本记录 */
#define T_AAAA  28   /* IPv6 地址 */
```

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    u_char answer[1024];
    int len;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("查询 www.baidu.com 的 A 记录...\n");
    
    // 执行 DNS 查询
    len = res_nquery(&state, "www.baidu.com", C_IN, T_A, answer, sizeof(answer));
    
    if (len == -1) {
        perror("res_nquery");
        res_nclose(&state);
        return 1;
    }
    
    printf("查询成功，返回数据长度: %d 字节\n", len);
    
    // 关闭解析器
    res_nclose(&state);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
查询 www.baidu.com 的 A 记录...
查询成功，返回数据长度: 32 字节
```

res_nsearch
---------------------------------------------

执行 DNS 搜索查询。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int res_nsearch(res_state statp, const char *dname, int class, int type,
                u_char *answer, int anslen);
```

- 说明：执行 DNS 搜索查询，支持搜索列表和默认域
- 返回值：成功返回查询结果长度，失败返回 -1
- 附加说明：与 res_nquery 类似，但支持搜索列表功能
- 相关函数：res_ninit, res_nclose, res_nquery

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    u_char answer[1024];
    int len;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("搜索查询 www 的 A 记录...\n");
    
    // 执行 DNS 搜索查询
    len = res_nsearch(&state, "www", C_IN, T_A, answer, sizeof(answer));
    
    if (len == -1) {
        perror("res_nsearch");
        res_nclose(&state);
        return 1;
    }
    
    printf("搜索查询成功，返回数据长度: %d 字节\n", len);
    
    // 关闭解析器
    res_nclose(&state);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
搜索查询 www 的 A 记录...
搜索查询成功，返回数据长度: 32 字节
```

res_nquerydomain
---------------------------------------------

在指定域中执行 DNS 查询。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int res_nquerydomain(res_state statp, const char *name, const char *domain,
                     int class, int type, u_char *answer, int anslen);
```

- 说明：在指定域中执行 DNS 查询，查询 name.domain 的记录
- 返回值：成功返回查询结果长度，失败返回 -1
- 附加说明：name 为查询名称，domain 为域名，会查询 name.domain
- 相关函数：res_ninit, res_nclose, res_nquery

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    u_char answer[1024];
    int len;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("查询 www.baidu.com 的 A 记录...\n");
    
    // 在指定域中执行 DNS 查询
    len = res_nquerydomain(&state, "www", "baidu.com", C_IN, T_A, 
                           answer, sizeof(answer));
    
    if (len == -1) {
        perror("res_nquerydomain");
        res_nclose(&state);
        return 1;
    }
    
    printf("域查询成功，返回数据长度: %d 字节\n", len);
    
    // 关闭解析器
    res_nclose(&state);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
查询 www.baidu.com 的 A 记录...
域查询成功，返回数据长度: 32 字节
```

res_nmkquery
---------------------------------------------

构造 DNS 查询包。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int res_nmkquery(res_state statp, int op, const char *dname, int class,
                 int type, const u_char *data, int datalen,
                 const u_char *newrr, u_char *buf, int buflen);
```

- 说明：构造 DNS 查询包，但不发送查询
- 返回值：成功返回查询包长度，失败返回 -1
- 附加说明：op 为操作码（通常为 QUERY），dname 为域名
- 相关函数：res_ninit, res_nclose, res_nsend

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    u_char query[1024];
    int len;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("构造 DNS 查询包...\n");
    
    // 构造 DNS 查询包
    len = res_nmkquery(&state, QUERY, "www.baidu.com", C_IN, T_A,
                       NULL, 0, NULL, query, sizeof(query));
    
    if (len == -1) {
        perror("res_nmkquery");
        res_nclose(&state);
        return 1;
    }
    
    printf("查询包构造成功，长度: %d 字节\n", len);
    
    // 关闭解析器
    res_nclose(&state);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
构造 DNS 查询包...
查询包构造成功，长度: 32 字节
```

res_nsend
---------------------------------------------

发送 DNS 查询包。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int res_nsend(res_state statp, const u_char *msg, int msglen,
              u_char *answer, int anslen);
```

- 说明：发送 DNS 查询包并接收响应
- 返回值：成功返回响应长度，失败返回 -1
- 附加说明：msg 为查询包，msglen 为查询包长度，answer 为响应缓冲区
- 相关函数：res_ninit, res_nclose, res_nmkquery

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    res_state state;
    u_char query[1024], answer[1024];
    int query_len, answer_len;
    
    // 初始化 DNS 解析器状态
    if (res_ninit(&state) == -1) {
        perror("res_ninit");
        return 1;
    }
    
    printf("构造并发送 DNS 查询...\n");
    
    // 构造 DNS 查询包
    query_len = res_nmkquery(&state, QUERY, "www.baidu.com", C_IN, T_A,
                             NULL, 0, NULL, query, sizeof(query));
    
    if (query_len == -1) {
        perror("res_nmkquery");
        res_nclose(&state);
        return 1;
    }
    
    // 发送查询包并接收响应
    answer_len = res_nsend(&state, query, query_len, answer, sizeof(answer));
    
    if (answer_len == -1) {
        perror("res_nsend");
        res_nclose(&state);
        return 1;
    }
    
    printf("查询发送成功，响应长度: %d 字节\n", answer_len);
    
    // 关闭解析器
    res_nclose(&state);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
构造并发送 DNS 查询...
查询发送成功，响应长度: 32 字节
```

dn_comp
---------------------------------------------

压缩域名。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int dn_comp(const char *exp_dn, u_char *comp_dn, int length,
            u_char **dnptrs, u_char **lastdnptr);
```

- 说明：将域名压缩为 DNS 格式，减少重复的域名部分
- 返回值：成功返回压缩后的长度，失败返回 -1
- 附加说明：exp_dn 为展开的域名，comp_dn 为压缩后的缓冲区
- 相关函数：dn_expand, res_ninit, res_nclose

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <string.h>

int main() {
    const char *domain = "www.baidu.com";
    u_char compressed[256];
    u_char *dnptrs[10];
    u_char **lastdnptr = &dnptrs[9];
    int len;
    
    printf("压缩域名: %s\n", domain);
    
    // 压缩域名
    len = dn_comp(domain, compressed, sizeof(compressed), 
                  dnptrs, lastdnptr);
    
    if (len == -1) {
        perror("dn_comp");
        return 1;
    }
    
    printf("压缩成功，长度: %d 字节\n", len);
    printf("原始长度: %zu 字节\n", strlen(domain));
    printf("压缩率: %.1f%%\n", (1.0 - (double)len / strlen(domain)) * 100);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
压缩域名: www.baidu.com
压缩成功，长度: 15 字节
原始长度: 13 字节
压缩率: -15.4%
```

dn_expand
---------------------------------------------

展开压缩的域名。

**头文件**

```c
#include <resolv.h>
```

**函数原型**

```c
int dn_expand(const u_char *msg, const u_char *eomorig,
              const u_char *comp_dn, char *exp_dn, int length);
```

- 说明：将压缩的域名展开为可读的域名格式
- 返回值：成功返回展开后的长度，失败返回 -1
- 附加说明：msg 为 DNS 消息，comp_dn 为压缩的域名，exp_dn 为展开后的缓冲区
- 相关函数：dn_comp, res_ninit, res_nclose

**示例**

```c
#include <stdio.h>
#include <resolv.h>
#include <string.h>

int main() {
    const char *domain = "www.baidu.com";
    u_char compressed[256];
    char expanded[256];
    u_char *dnptrs[10];
    u_char **lastdnptr = &dnptrs[9];
    int comp_len, exp_len;
    
    printf("原始域名: %s\n", domain);
    
    // 压缩域名
    comp_len = dn_comp(domain, compressed, sizeof(compressed), 
                       dnptrs, lastdnptr);
    
    if (comp_len == -1) {
        perror("dn_comp");
        return 1;
    }
    
    printf("压缩后长度: %d 字节\n", comp_len);
    
    // 展开域名
    exp_len = dn_expand(compressed, compressed + comp_len, compressed,
                        expanded, sizeof(expanded));
    
    if (exp_len == -1) {
        perror("dn_expand");
        return 1;
    }
    
    printf("展开后域名: %s\n", expanded);
    printf("展开后长度: %d 字节\n", exp_len);
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lresolv
$ ./example
原始域名: www.baidu.com
压缩后长度: 15 字节
展开后域名: www.baidu.com
展开后长度: 13 字节
```

