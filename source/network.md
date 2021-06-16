网络接口篇
=============================================

accept
---------------------------------------------

接受 socket 连接

头文件

```c
#include <sys/types.h>
#include <sys/socket.h>
```

函数原型

```c
int accept(int s, struct sockaddr *addr, int *addrlen);
```

- 说明：accept() 用来接受参数 s 的 socket 连线。参数 s 的 socket 必须先经 bind()、listen() 函数处理过，当有连线进来时 accept() 会返回一个新的 socket 处理代码，往后的数据传送与读取就是经由新的 socket 处理，而原来参数 s 的 socket 能继续使用 accept() 来接受新的连线要求。连线成功时，参数 addr 所指的结构体会被系统填入远程主机的地址数据，参数 addrlen 为 scokaddr 的结构体长度。关于结构体 sockaddr 的定义请参考 bind()。
- 返回值：成功则返回新的 socket 处理代码，失败返回 -1，错误原因存于 errno 中。错误代码如下：
  - `EBADF` 参数 s 非合法 socket 处理代码。
  - `EFAULT` 参数 addr 指针指向无法存取的内存空间。
  - `ENOTSOCK` 参数 s 为一文件描述符，非 socket。
  - `EOPNOTSUPP` 指定的 socket 并非 `SOCK_STREAM`。
  - `EPERM` 防火墙拒绝此连线。
  - `ENOBUFS` 系统的缓冲内存不足。
  - `ENOMEM` 核心内存不足。
- 相关函数：socket, bind, listen, connect

示例

参考 [listen()](#listen)


bind
---------------------------------------------

绑定 socket

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
bind（對socket定位）
相關函數
socket，accept，connect，listen
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int bind(int sockfd,struct sockaddr * my_addr,int addrlen);
函數說明
bind()用來設置給參數sockfd的socket一個名稱。此名稱由參數my_addr指向一sockaddr結構，對於不同的socket domain定義了一個通用的數據結構
struct sockaddr
{
unsigned short int sa_family;
char sa_data[14];
};
sa_family 為調用socket（）時的domain參數，即AF_xxxx值。
sa_data 最多使用14個字符長度。
此sockaddr結構會因使用不同的socket domain而有不同結構定義，例如使用AF_INET domain，其socketaddr結構定義便為
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
sin_family 即為sa_family
sin_port 為使用的port編號
sin_addr.s_addr 為IP 地址
sin_zero 未使用。
參數
addrlen為sockaddr的結構長度。
返回值
成功則返回0，失敗返回-1，錯誤原因存於errno中。
錯誤代碼
EBADF 參數sockfd 非合法socket處理代碼。
EACCESS 權限不足
ENOTSOCK 參數sockfd為一文件描述詞，非socket。
範例
參考listen()
```


connect
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
connect（建立socket連線）
相關函數
socket，bind，listen
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int connect (int sockfd,struct sockaddr * serv_addr,int addrlen);
函數說明
connect()用來將參數sockfd 的socket 連至參數serv_addr 指定的網絡地址。結構sockaddr請參考bind()。參數addrlen為sockaddr的結構長度。
返回值
成功則返回0，失敗返回-1，錯誤原因存於errno中。
錯誤代碼
EBADF 參數sockfd 非合法socket處理代碼
EFAULT 參數serv_addr指針指向無法存取的內存空間
ENOTSOCK 參數sockfd為一文件描述詞，非socket。
EISCONN 參數sockfd的socket已是連線狀態
ECONNREFUSED 連線要求被server端拒絕。
ETIMEDOUT 企圖連線的操作超過限定時間仍未有響應。
ENETUNREACH 無法傳送數據包至指定的主機。
EAFNOSUPPORT sockaddr結構的sa_family不正確。
EALREADY socket為不可阻斷且先前的連線操作還未完成。
範例
/* 利用socket的TCP client
此程序會連線TCP server，並將鍵盤輸入的字符串傳送給server。
TCP server範例請參考listen（）。
*/
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#define PORT 1234
#define SERVER_IP “127.0.0.1”
main()
{
int s;
struct sockaddr_in addr;
char buffer[256];
if((s = socket(AF_INET,SOCK_STREAM,0))<0){
perror(“socket”);
exit(1);
}
/* 填寫sockaddr_in結構*/
bzero(&addr,sizeof(addr));
addr.sin_family = AF_INET;
addr.sin_port=htons(PORT);
addr.sin_addr.s_addr = inet_addr(SERVER_IP);
/* 嘗試連線*/
if(connect(s,&addr,sizeof(addr))<0){
perror(“connect”);
exit(1);
}
/* 接收由server端傳來的信息*/
recv(s,buffer,sizeof(buffer),0);
printf(“%s\n”,buffer);
while(1){
bzero(buffer,sizeof(buffer));
/* 從標準輸入設備取得字符串*/
read(STDIN_FILENO,buffer,sizeof(buffer));
/* 將字符串傳給server端*/
if(send(s,buffer,sizeof(buffer),0)<0){
perror(“send”);
exit(1);
}
}
}
執行
$ ./connect
Welcome to server!
hi I am client! /*鍵盤輸入*/
/*<Ctrl+C>中斷程序*/
```


endprotoent
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
endprotoent（結束網絡協議數據的讀取）
相關函數
getprotoent，getprotobyname，getprotobynumber，setprotoent
表頭文件
#include<netdb.h>
定義函數
void endprotoent(void);
函數說明
endprotoent()用來關閉由getprotoent()打開的文件。
返回值

範例
參考getprotoent()
```


endservent
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
endservent（結束網絡服務數據的讀取）
相關函數
getservent，getservbyname，getservbyport，setservent
表頭文件
#include<netdb.h>
定義函數
void endservent(void);
函數說明
endservent()用來關閉由getservent()所打開的文件。
返回值

範例
參考getservent()。
```


getsockopt
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
getsockopt（取得socket狀態）
相關函數
setsockopt
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int getsockopt(int s,int level,int optname,void* optval,socklen_t* optlen);
函數說明
getsockopt()會將參數s所指定的socket狀態返回。參數optname代表欲取得何種選項狀態，而參數optval則指向欲保存結果的內存地址，參數optlen則為該空間的大小。參數level、optname請參考setsockopt()。
返回值
成功則返回0，若有錯誤則返回-1，錯誤原因存於errno
錯誤代碼
EBADF 參數s 並非合法的socket處理代碼
ENOTSOCK 參數s為一文件描述詞，非socket
ENOPROTOOPT 參數optname指定的選項不正確
EFAULT 參數optval指針指向無法存取的內存空間
範例
#include<sys/types.h>
#include<sys/socket.h>
main()
{
int s,optval,optlen = sizeof(int);
if((s = socket(AF_INET,SOCK_STREAM,0))<0) perror(“socket”);
getsockopt(s,SOL_SOCKET,SO_TYPE,&optval,&optlen);
printf(“optval = %d\n”,optval);
close(s);}
執行
optval = 1 /*SOCK_STREAM的定義正是此值*/
```


htonl
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
htonl（將32位主機字符順序轉換成網絡字符順序）
相關函數
htons，ntohl，ntohs
表頭文件
#include<netinet/in.h>
定義函數
unsigned long int htonl(unsigned long int hostlong);
函數說明
htonl（）用來將參數指定的32位hostlong 轉換成網絡字符順序。
返回值
返回對應的網絡字符順序。
範例
參考getservbyport()或connect()。
```


htons
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
htons（將16位主機字符順序轉換成網絡字符順序）
相關函數
htonl，ntohl，ntohs
表頭文件
#include<netinet/in.h>
定義函數
unsigned short int htons(unsigned short int hostshort);
函數說明
htons()用來將參數指定的16位hostshort轉換成網絡字符順序。
返回值
返回對應的網絡字符順序。
範例
參考connect()。
```


inet_addr
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
inet_addr（將網絡地址轉成二進制的數字）
相關函數
inet_aton，inet_ntoa
表頭文件
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
定義函數
unsigned long int inet_addr(const char *cp);
函數說明
inet_addr()用來將參數cp所指的網絡地址字符串轉換成網絡所使用的二進制數字。網絡地址字符串是以數字和點組成的字符串，例如:“163.13.132.68”。
返回值
成功則返回對應的網絡二進制的數字，失敗返回-1。
```


inet_aton
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
inet_aton（將網絡地址轉成網絡二進制的數字）
相關函數
inet_addr，inet_ntoa
表頭文件
#include<sys/scoket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
定義函數
int inet_aton(const char * cp,struct in_addr *inp);
函數說明
inet_aton()用來將參數cp所指的網絡地址字符串轉換成網絡使用的二進制的數字，然後存於參數inp所指的in_addr結構中。
結構in_addr定義如下
struct in_addr
{
unsigned long int s_addr;
};
返回值
成功則返回非0值，失敗則返回0。
```


inet_ntoa
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
inet_ntoa（將網絡二進制的數字轉換成網絡地址）
相關函數
inet_addr，inet_aton
表頭文件
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
定義函數
char * inet_ntoa(struct in_addr in);
函數說明
inet_ntoa()用來將參數in所指的網絡二進制的數字轉換成網絡地址，然後將指向此網絡地址字符串的指針返回。
返回值
成功則返回字符串指針，失敗則返回NULL。
```


listen
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
listen（等待連接）
相關函數
socket，bind，accept，connect
表頭文件
#include<sys/socket.h>
定義函數
int listen(int s,int backlog);
函數說明
listen()用來等待參數s 的socket連線。參數backlog指定同時能處理的最大連接要求，如果連接數目達此上限則client端將收到ECONNREFUSED的錯誤。Listen()並未開始接收連線，只是設置socket為listen模式，真正接收client端連線的是accept()。通常listen()會在socket()，bind()之後調用，接著才調用accept()。
返回值
成功則返回0，失敗返回-1，錯誤原因存於errno
附加說明
listen()只適用SOCK_STREAM或SOCK_SEQPACKET的socket類型。如果socket為AF_INET則參數backlog 最大值可設至128。
錯誤代碼
EBADF 參數sockfd非合法socket處理代碼
EACCESS 權限不足
EOPNOTSUPP 指定的socket並未支援listen模式。
範例
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<unistd.h>
#define PORT 1234
#define MAXSOCKFD 10
main()
{
int sockfd,newsockfd,is_connected[MAXSOCKFD],fd;
struct sockaddr_in addr;
int addr_len = sizeof(struct sockaddr_in);
fd_set readfds;
char buffer[256];
char msg[ ] =”Welcome to server!”;
if ((sockfd = socket(AF_INET,SOCK_STREAM,0))<0){
perror(“socket”);
exit(1);
}
bzero(&addr,sizeof(addr));
addr.sin_family =AF_INET;
addr.sin_port = htons(PORT);
addr.sin_addr.s_addr = htonl(INADDR_ANY);
if(bind(sockfd,&addr,sizeof(addr))<0){
perror(“connect”);
exit(1);
}
if(listen(sockfd,3)<0){
perror(“listen”);
exit(1);
}
for(fd=0;fd<MAXSOCKFD;fd++)
is_connected[fd]=0;
while(1){
FD_ZERO(&readfds);
FD_SET(sockfd,&readfds);
for(fd=0;fd<MAXSOCKFD;fd++)
if(is_connected[fd]) FD_SET(fd,&readfds);
if(!select(MAXSOCKFD,&readfds,NULL,NULL,NULL))continue;
for(fd=0;fd<MAXSOCKFD;fd++)
if(FD_ISSET(fd,&readfds)){
if(sockfd = =fd){
if((newsockfd = accept (sockfd,&addr,&addr_len))<0)
perror(“accept”);
write(newsockfd,msg,sizeof(msg));
is_connected[newsockfd] =1;
printf(“cnnect from %s\n”,inet_ntoa(addr.sin_addr));
}else{
bzero(buffer,sizeof(buffer));
if(read(fd,buffer,sizeof(buffer))<=0){
printf(“connect closed.\n”);
is_connected[fd]=0;
close(fd);
}else
printf(“%s”,buffer);
}
}
}
}
執行
$ ./listen
connect from 127.0.0.1
hi I am client
connected closed.
```


ntohl
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
ntohl（將32位網絡字符順序轉換成主機字符順序）
相關函數
htonl，htons，ntohs
表頭文件
#include<netinet/in.h>
定義函數
unsigned long int ntohl(unsigned long int netlong);
函數說明
ntohl()用來將參數指定的32位netlong轉換成主機字符順序。
返回值
返回對應的主機字符順序。
範例
參考getservent()。
```


ntohs
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
ntohs（將16位網絡字符順序轉換成主機字符順序）
相關函數
htonl，htons，ntohl
表頭文件
#include<netinet/in.h>
定義函數
unsigned short int ntohs(unsigned short int netshort);
函數說明
ntohs()用來將參數指定的16位netshort轉換成主機字符順序。
返回值
返回對應的主機順序。
範例
參考getservent()。
```


recv
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
recv（經socket接收數據）
相關函數
recvfrom，recvmsg，send，sendto，socket
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int recv(int s,void *buf,int len,unsigned int flags);
函數說明
recv()用來接收遠端主機經指定的socket傳來的數據，並把數據存到由參數buf 指向的內存空間，參數len為可接收數據的最大長度。
參數
flags一般設0。其他數值定義如下:
MSG_OOB 接收以out-of-band 送出的數據。
MSG_PEEK 返回來的數據並不會在系統內刪除，如果再調用recv()會返回相同的數據內容。
MSG_WAITALL強迫接收到len大小的數據後才能返回，除非有錯誤或信號產生。
MSG_NOSIGNAL此操作不願被SIGPIPE信號中斷返回值成功則返回接收到的字符數，失敗返回-1，錯誤原因存於errno中。
錯誤代碼
EBADF 參數s非合法的socket處理代碼
EFAULT 參數中有一指針指向無法存取的內存空間
ENOTSOCK 參數s為一文件描述詞，非socket。
EINTR 被信號所中斷
EAGAIN 此動作會令進程阻斷，但參數s的socket為不可阻斷
ENOBUFS 系統的緩衝內存不足。
ENOMEM 核心內存不足
EINVAL 傳給系統調用的參數不正確。
範例
參考listen()。
```


recvfrom
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
recvfrom（經socket接收數據）
相關函數
recv，recvmsg，send，sendto，socket
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int recvfrom(int s,void *buf,int len,unsigned int flags ,struct sockaddr *from ,int *fromlen);
函數說明
recv()用來接收遠程主機經指定的socket 傳來的數據，並把數據存到由參數buf 指向的內存空間，參數len 為可接收數據的最大長度。參數flags 一般設0，其他數值定義請參考recv()。參數from用來指定欲傳送的網絡地址，結構sockaddr 請參考bind()。參數fromlen為sockaddr的結構長度。
返回值
成功則返回接收到的字符數，失敗則返回-1，錯誤原因存於errno中。
錯誤代碼
EBADF 參數s非合法的socket處理代碼
EFAULT 參數中有一指針指向無法存取的內存空間。
ENOTSOCK 參數s為一文件描述詞，非socket。
EINTR 被信號所中斷。
EAGAIN 此動作會令進程阻斷，但參數s的socket為不可阻斷。
ENOBUFS 系統的緩衝內存不足
ENOMEM 核心內存不足
EINVAL 傳給系統調用的參數不正確。
範例
/*利用socket的UDP client
此程序會連線UDP server，並將鍵盤輸入的字符串傳給server。
UDP server 範例請參考sendto（）。
*/
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<sys/typs.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#define PORT 2345
#define SERVER_IP “127.0.0.1”
main()
{
int s,len;
struct sockaddr_in addr;
int addr_len =sizeof(struct sockaddr_in);
char buffer[256];
/* 建立socket*/
if((s = socket(AF_INET,SOCK_DGRAM,0))<0){
perror(“socket”);
exit(1);
}
/* 填寫sockaddr_in*/
bzero(&addr,sizeof(addr));
addr.sin_family = AF_INET;
addr.sin_port = htons(PORT);
addr.sin_addr.s_addr = inet_addr(SERVER_IP);
while(1){
bzero(buffer,sizeof(buffer));
/* 從標準輸入設備取得字符串*/
len =read(STDIN_FILENO,buffer,sizeof(buffer));
/* 將字符串傳送給server端*/
sendto(s,buffer,len,0,&addr,addr_len);
/* 接收server端返回的字符串*/
len = recvfrom(s,buffer,sizeof(buffer),0,&addr,&addr_len);
printf(“receive: %s”,buffer);
}
}
執行
(先執行udp server 再執行udp client)
hello /*從鍵盤輸入字符串*/
receive: hello /*server端返回來的字符串*/
```


recvmsg
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
recvmsg（經socket接收數據）
相關函數
recv，recvfrom，send，sendto，sendmsg，socket
表頭文件
#include<sys/types.h>
#include<sys/socktet.h>
定義函數
int recvmsg(int s,struct msghdr *msg,unsigned int flags);
函數說明
recvmsg()用來接收遠程主機經指定的socket傳來的數據。參數s為已建立好連線的socket，如果利用UDP協議則不需經過連線操作。參數msg指向欲連線的數據結構內容，參數flags一般設0，詳細描述請參考send()。關於結構msghdr的定義請參考sendmsg()。
返回值
成功則返回接收到的字符數，失敗則返回-1，錯誤原因存於errno中。
錯誤代碼
EBADF 參數s非合法的socket處理代碼。
EFAULT 參數中有一指針指向無法存取的內存空間
ENOTSOCK 參數s為一文件描述詞，非socket。
EINTR 被信號所中斷。
EAGAIN 此操作會令進程阻斷，但參數s的socket為不可阻斷。
ENOBUFS 系統的緩衝內存不足
ENOMEM 核心內存不足
EINVAL 傳給系統調用的參數不正確。
範例
參考recvfrom()。
```


send
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
send（經socket傳送數據）
相關函數
sendto，sendmsg，recv，recvfrom，socket
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int send(int s,const void * msg,int len,unsigned int falgs);
函數說明
send()用來將數據由指定的socket 傳給對方主機。參數s為已建立好連接的socket。參數msg指向欲連線的數據內容，參數len則為數據長度。參數flags一般設0，其他數值定義如下
MSG_OOB 傳送的數據以out-of-band 送出。
MSG_DONTROUTE 取消路由表查詢
MSG_DONTWAIT 設置為不可阻斷運作
MSG_NOSIGNAL 此動作不願被SIGPIPE 信號中斷。
返回值
成功則返回實際傳送出去的字符數，失敗返回-1。錯誤原因存於errno
錯誤代碼
EBADF 參數s 非合法的socket處理代碼。
EFAULT 參數中有一指針指向無法存取的內存空間
ENOTSOCK 參數s為一文件描述詞，非socket。
EINTR 被信號所中斷。
EAGAIN 此操作會令進程阻斷，但參數s的socket為不可阻斷。
ENOBUFS 系統的緩衝內存不足
ENOMEM 核心內存不足
EINVAL 傳給系統調用的參數不正確。
範例
參考connect()
```


sendmsg
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
sendmsg（經socket傳送數據）
相關函數
send，sendto，recv，recvfrom，recvmsg，socket
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int sendmsg(int s,const strcut msghdr *msg,unsigned int flags);
函數說明
sendmsg()用來將數據由指定的socket傳給對方主機。參數s為已建立好連線的socket，如果利用UDP協議則不需經過連線操作。參數msg 指向欲連線的數據結構內容，參數flags一般默認為0，詳細描述請參考send()。
結構msghdr定義如下
struct msghdr
{
void *msg_name; /*Address to send to /receive from . */
socklen_t msg_namelen; /* Length of addres data */
strcut iovec * msg_iov; /* Vector of data to send/receive into */
size_t msg_iovlen; /* Number of elements in the vector */
void * msg_control; /* Ancillary dat */
size_t msg_controllen; /* Ancillary data buffer length */
int msg_flags; /* Flags on received message */
};
返回值
成功則返回實際傳送出去的字符數，失敗返回-1，錯誤原因存於errno
錯誤代碼
EBADF 參數s 非合法的socket處理代碼。
EFAULT 參數中有一指針指向無法存取的內存空間
ENOTSOCK 參數s為一文件描述詞，非socket。
EINTR 被信號所中斷。
EAGAIN 此操作會令進程阻斷，但參數s的socket為不可阻斷。
ENOBUFS 系統的緩衝內存不足
ENOMEM 核心內存不足
EINVAL 傳給系統調用的參數不正確。
範例
參考sendto()。
```


sendto
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
sendto（經socket傳送數據）
相關函數
send , sendmsg,recv , recvfrom , socket
表頭文件
#include < sys/types.h >
#include < sys/socket.h >
定義函數
int sendto ( int s , const void * msg, int len, unsigned int flags, const
struct sockaddr * to , int tolen ) ;
函數說明
sendto() 用來將數據由指定的socket傳給對方主機。參數s為已建好連線的socket,如果利用UDP協議則不需經過連線操作。參數msg指向欲連線的數據內容，參數flags 一般設0，詳細描述請參考send()。參數to用來指定欲傳送的網絡地址，結構sockaddr請參考bind()。參數tolen為sockaddr的結果長度。
返回值
成功則返回實際傳送出去的字符數，失敗返回－1，錯誤原因存於errno 中。
錯誤代碼
EBADF 參數s非法的socket處理代碼。
EFAULT 參數中有一指針指向無法存取的內存空間。
WNOTSOCK canshu s為一文件描述詞，非socket。
EINTR 被信號所中斷。
EAGAIN 此動作會令進程阻斷，但參數s的soket為補課阻斷的。
ENOBUFS 系統的緩衝內存不足。
EINVAL 傳給系統調用的參數不正確。
範例
#include < sys/types.h >
#include < sys/socket.h >
# include <netinet.in.h>
#include <arpa.inet.h>
#define PORT 2345 /*使用的port*/
main(){
int sockfd,len;
struct sockaddr_in addr;
char buffer[256];
/*建立socket*/
if(sockfd=socket (AF_INET,SOCK_DGRAM,0))<0){
perror (“socket”);
exit(1);
}
/*填寫sockaddr_in 結構*/
bzero ( &addr, sizeof(addr) );
addr.sin_family=AF_INET;
addr.sin_port=htons(PORT);
addr.sin_addr=hton1(INADDR_ANY) ;
if (bind(sockfd, &addr, sizeof(addr))<0){
perror(“connect”);
exit(1);
}
while(1){
bezro(buffer,sizeof(buffer));
len = recvfrom(socket,buffer,sizeof(buffer), 0 , &addr &addr_len);
/*顯示client端的網絡地址*/
printf(“receive from %s\n “ , inet_ntoa( addr.sin_addr));
/*將字串返回給client端*/
sendto(sockfd,buffer,len,0,&addr,addr_len);”
}
}
執行
請參考recvfrom()
```


setprotoent
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
setprotoent（打開網絡協議的數據文件）
相關函數
getprotobyname, getprotobynumber, endprotoent
表頭文件
#include <netdb.h>
定義函數
void setprotoent (int stayopen);
函數說明
setprotoent()用來打開/etc/protocols， 如果參數stayopen值為1，則接下來的getprotobyname()或getprotobynumber()將不會自動關閉此文件。
```


setservent
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
setservent（打開主機網絡服務的數據文件）
相關函數
getservent, getservbyname, getservbyport, endservent
表頭文件
#include < netdb.h >
定義函數
void setservent (int stayopen);
函數說明
setservent()用來打開/etc/services，如果參數stayopen值為1，則接下來的getservbyname()或getservbyport()將補回自動關閉文件。
```


setsockopt
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
setsockopt（設置socket狀態）
相關函數
getsockopt
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int setsockopt(int s,int level,int optname,const void * optval,,socklen_toptlen);
函數說明
setsockopt()用來設置參數s所指定的socket狀態。參數level代表欲設置的網絡層，一般設成SOL_SOCKET以存取socket層。參數optname代表欲設置的選項，有下列幾種數值:
SO_DEBUG 打開或關閉排錯模式
SO_REUSEADDR 允許在bind（）過程中本地地址可重複使用
SO_TYPE 返回socket形態。
SO_ERROR 返回socket已發生的錯誤原因
SO_DONTROUTE 送出的數據包不要利用路由設備來傳輸。
SO_BROADCAST 使用廣播方式傳送
SO_SNDBUF 設置送出的暫存區大小
SO_RCVBUF 設置接收的暫存區大小
SO_KEEPALIVE 定期確定連線是否已終止。
SO_OOBINLINE 當接收到OOB 數據時會馬上送至標準輸入設備
SO_LINGER 確保數據安全且可靠的傳送出去。
參數
optval代表欲設置的值，參數optlen則為optval的長度。
返回值
成功則返回0，若有錯誤則返回-1，錯誤原因存於errno。
附加說明
EBADF 參數s並非合法的socket處理代碼
ENOTSOCK 參數s為一文件描述詞，非socket
ENOPROTOOPT 參數optname指定的選項不正確。
EFAULT 參數optval指針指向無法存取的內存空間。
範例
參考getsockopt()。
```


shutdown
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
shutdown（終止socket通信）
相關函數
socket，connect
表頭文件
#include<sys/socket.h>
定義函數
int shutdown(int s,int how);
函數說明
shutdown()用來終止參數s所指定的socket連線。參數s是連線中的socket處理代碼，參數how有下列幾種情況:
how=0 終止讀取操作。
how=1 終止傳送操作
how=2 終止讀取及傳送操作
返回值
成功則返回0，失敗返回-1，錯誤原因存於errno。
錯誤代碼
EBADF 參數s不是有效的socket處理代碼
ENOTSOCK 參數s為一文件描述詞，非socket
ENOTCONN 參數s指定的socket並未連線
```


socket
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
socket（建立一個socket通信）
相關函數
accept，bind，connect，listen
表頭文件
#include<sys/types.h>
#include<sys/socket.h>
定義函數
int socket(int domain,int type,int protocol);
函數說明
socket()用來建立一個新的socket，也就是向系統註冊，通知系統建立一通信端口。參數domain 指定使用何種的地址類型，完整的定義在/usr/include/bits/socket.h 內，底下是常見的協議:
PF_UNIX/PF_LOCAL/AF_UNIX/AF_LOCAL UNIX 進程通信協議
PF_INET?AF_INET Ipv4網絡協議
PF_INET6/AF_INET6 Ipv6 網絡協議
PF_IPX/AF_IPX IPX-Novell協議
PF_NETLINK/AF_NETLINK 核心用戶接口裝置
PF_X25/AF_X25 ITU-T X.25/ISO-8208 協議
PF_AX25/AF_AX25 業餘無線AX.25協議
PF_ATMPVC/AF_ATMPVC 存取原始ATM PVCs
PF_APPLETALK/AF_APPLETALK appletalk（DDP）協議
PF_PACKET/AF_PACKET 初級封包接口
參數
type有下列幾種數值:
SOCK_STREAM 提供雙向連續且可信賴的數據流，即TCP。支持
OOB 機制，在所有數據傳送前必須使用connect()來建立連線狀態。
SOCK_DGRAM 使用不連續不可信賴的數據包連接
SOCK_SEQPACKET 提供連續可信賴的數據包連接
SOCK_RAW 提供原始網絡協議存取
SOCK_RDM 提供可信賴的數據包連接
SOCK_PACKET 提供和網絡驅動程序直接通信。
protocol用來指定socket所使用的傳輸協議編號，通常此參考不用管它，設為0即可。
返回值
成功則返回socket處理代碼，失敗返回-1。
錯誤代碼
EPROTONOSUPPORT 參數domain指定的類型不支持參數type或protocol指定的協議
ENFILE 核心內存不足，無法建立新的socket結構
EMFILE 進程文件表溢出，無法再建立新的socket
EACCESS 權限不足，無法建立type或protocol指定的協議
ENOBUFS/ENOMEM 內存不足
EINVAL 參數domain/type/protocol不合法
範例
參考connect()。
```

