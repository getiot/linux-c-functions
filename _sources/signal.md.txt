信号处理篇
=============================================

alarm
---------------------------------------------

设置信号传送闹钟

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
unsigned int alarm(unsigned int seconds);
```

- 说明：alarm() 用来设置信号 `SIGALRM` 在经过参数 seconds 指定的秒数后传送给目前的进程。如果参数 seconds 为 0，则之前设置的闹钟会被取消，并将剩下的时间返回。
- 返回值：返回之前闹钟的剩余秒数，如果之前未设闹钟则返回 0。
- 附加说明：
- 相关函数：signal，sleep

**示例**

```c
#include <unistd.h>
#include <signal.h>

void handler()
{
    printf("hello\n");
}

int main()
{
    int i;
    signal(SIGALRM, handler);
    alarm(5);
    
    for(i=1; i<7; i++)
    {
        printf("sleep %d ...\n",i);
        sleep(1);
    }
}
```

执行

```shell
sleep 1 ...
sleep 2 ...
sleep 3 ...
sleep 4 ...
sleep 5 ...
hello
sleep 6 ...
```


kill
---------------------------------------------

传送信号给指定的进程

**头文件**

```c
#include <sys/types.h>
#include <signal.h>
```

**函数原型**

```c
int kill(pid_t pid, int sig);
```

- 说明：kill() 可以用来送参数 sig 指定的信号给参数 pid 指定的进程。

  参数 pid 有几种情况：

  - pid>0 将信号传给进程识别码为 pid 的进程。
  - pid=0 将信号传给和目前进程相同进程组的所有进程
  - pid=-1 将信号广播传送给系统内所有的进程
  - pid<0 将信号传给进程组识别码为 pid 绝对值的所有进程

  参数 sig 代表的信号编号可参考附录 D

- 返回值：执行成功则返回 0，如果有错误则返回 -1。

  错误代码：

  - `EINVAL` 参数 sig 不合法
  - `ESRCH` 参数 pid 所指定的进程或进程组不存在
  - `EPERM` 权限不够无法传送信号给指定进程

- 附加说明：

- 相关函数：raise，signal

**示例**

```c
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    pid_t pid;
    int status;
    if(!(pid= fork()))
    {
        printf("Hi I am child process!\n");
        sleep(10);
        return;
    }
    else{
        printf("send signal to child process (%d) \n",pid);
        sleep(1);
        kill(pid ,SIGABRT);
        wait(&status);
        if(WIFSIGNALED(status))
            printf("chile process receive signal %d\n",WTERMSIG(status));
    }
    return 0;
}
```

执行

```shell
sen signal to child process(3170)
Hi I am child process!
child process receive signal 6
```


pause
---------------------------------------------

让进程暂停直到信号出现

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int pause(void);
```

- 说明：pause() 会令目前的进程暂停（进入睡眠状态），直到被信号(signal)所中断。

- 返回值：只返回-1。

  错误代码：`EINTR` 有信号到达中断了此函数。

- 附加说明：

- 相关函数：kill，signal，sleep

**示例**

```c

```

执行

```shell

```


sigaction
---------------------------------------------

查询或设置信号处理方式

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigaction(int signum,const struct sigaction *act, struct sigaction *oldact);
```

- 说明：sigaction()会依参数signum指定的信号编号来设置该信号的处理函数。参数signum可以指定SIGKILL和SIGSTOP以外的所有信号。

  如参数结构sigaction定义如下：

  ```c
  struct sigaction
  {
      void (*sa_handler) (int);
      sigset_t sa_mask;
      int sa_flags;
      void (*sa_restorer) (void);
  }
  ```

  sa_handler 此参数和 signal() 的参数 handler 相同，代表新的信号处理函数，其他意义请参考 signal()。
  sa_mask 用来设置在处理该信号时暂时将 sa_mask 指定的信号搁置。
  sa_restorer 此参数没有使用。
  sa_flags 用来设置信号处理的其他相关操作，下列的数值可用。

  OR 运算（|）组合
  `A_NOCLDSTOP`：如果参数 signum 为 `SIGCHLD`，则当子进程暂停时并不会通知父进程
  `SA_ONESHOT`/`SA_RESETHAND`:当调用新的信号处理函数前，将此信号处理方式改为系统预设的方式。
  `SA_RESTART`:被信号中断的系统调用会自行重启
  `SA_NOMASK`/`SA_NODEFER`:在处理此信号未结束前不理会此信号的再次到来。
  如果参数oldact不是 NULL 指针，则原来的信号处理方式会由此结构sigaction 返回。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EINVAL` 参数 signum 不合法， 或是试图拦截 `SIGKILL`/`SIGSTOPSIGKILL` 信号
  - `EFAULT` 参数 act，oldact 指针地址无法存取。
  - `EINTR` 此调用被中断

- 附加说明：

- 相关函数：signal，sigprocmask，sigpending，sigsuspend

**示例**

```c
#include <unistd.h>
#include <signal.h>

void show_handler(struct sigaction * act)
{
    switch (act->sa_flags)
    {
        case SIG_DFL:printf("Default action\n");break;
        case SIG_IGN:printf("Ignore the signal\n");break;
        default: printf("0x%x\n",act->sa_handler);
    }
}

int main()
{
    int i;
    struct sigaction act,oldact;
    act.sa_handler = show_handler;
    act.sa_flags = SA_ONESHOT|SA_NOMASK;
    sigaction(SIGUSR1,&act,&oldact);
    for(i=5;i<15;i++)
    {
        printf("sa_handler of signal %2d =", i);
        sigaction(i,NULL,&oldact);
    }
    return 0;
}
```

执行

```shell
sa_handler of signal 5 = Default action
sa_handler of signal 6= Default action
sa_handler of signal 7 = Default action
sa_handler of signal 8 = Default action
sa_handler of signal 9 = Default action
sa_handler of signal 10 = 0x8048400
sa_handler of signal 11 = Default action
sa_handler of signal 12 = Default action
sa_handler of signal 13 = Default action
sa_handler of signal 14 = Default action
```


sigaddset
---------------------------------------------

增加一个信号至信号集

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigaddset(sigset_t *set, int signum);
```

- 说明：sigaddset()用来将参数signum 代表的信号加入至参数set 信号集里。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数set指针地址无法存取
  - `EINVAL` 参数signum非合法的信号编号

- 附加说明：

- 相关函数：sigemptyset，sigfillset，sigdelset，sigismember

**示例**

```c

```

执行

```shell

```


sigdelset
---------------------------------------------

从信号集里删除一个信号

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigdelset(sigset_t * set, int signum);
```

- 说明：sigdelset()用来将参数signum代表的信号从参数set信号集里删除。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数 set 指针地址无法存取
  - `EINVAL` 参数 signum 非合法的信号编号

- 附加说明：

- 相关函数：sigemptyset，sigfillset，sigaddset，sigismember

**示例**

```c

```

执行

```shell

```


sigemptyset
---------------------------------------------

初始化信号集

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigemptyset(sigset_t *set);
```

- 说明：sigemptyset() 用来将参数 set 信号集初始化并清空。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数set指针地址无法存取

- 附加说明：

- 相关函数：sigaddset，sigfillset，sigdelset，sigismember

**示例**

```c

```

执行

```shell

```


sigfillset
---------------------------------------------

将所有信号加入至信号集

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigfillset(sigset_t * set);
```

- 说明：sigfillset()用来将参数set信号集初始化，然后把所有的信号加入到此信号集里。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数set指针地址无法存取

- 附加说明：

- 相关函数：sigempty，sigaddset，sigdelset，sigismember

**示例**

```c

```

执行

```shell

```


sigismember
---------------------------------------------

测试某个信号是否已加入至信号集里

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigismember(const sigset_t *set, int signum);
```

- 说明：sigismember()用来测试参数signum 代表的信号是否已加入至参数set信号集里。如果信号集里已有该信号则返回1，否则返回0。

- 返回值：信号集已有该信号则返回1，没有则返回0。如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数set指针地址无法存取
  - `EINVAL` 参数signum 非合法的信号编号

- 附加说明：

- 相关函数：sigemptyset，sigfillset，sigaddset，sigdelset

**示例**

```c

```

执行

```shell

```


signal
---------------------------------------------

设置信号处理方式

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
void (*signal(int signum, void(* handler)(int)))(int);
```

- 说明：signal()会依参数signum 指定的信号编号来设置该信号的处理函数。当指定的信号到达时就会跳转到参数handler指定的函数执行。如果参数handler不是函数指针，则必须是下列两个常数之一：

  - `SIG_IGN` 忽略参数signum指定的信号。
  - `SIG_DFL` 将参数signum 指定的信号重设为核心预设的信号处理方式。

  关于信号的编号和说明，请参考附录D

- 返回值：返回先前的信号处理函数指针，如果有错误则返回SIG_ERR(-1)。

- 附加说明：在信号发生跳转到自定的handler处理函数执行后，系统会自动将此处理函数换回原来系统预设的处理方式，如果要改变此操作请改用sigaction()。

- 相关函数：sigaction，kill，raise

**示例**

参考 alarm() 或 raise()。


sigpending
---------------------------------------------

查询被搁置的信号

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigpending(sigset_t *set);
```

- 说明：sigpending()会将被搁置的信号集合由参数set指针返回。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数 set 指针地址无法存取
  - `EINTR` 此调用被中断。

- 附加说明：

- 相关函数：signal，sigaction，sigprocmask，sigsuspend

**示例**

```c

```

执行

```shell

```


sigprocmask
---------------------------------------------

查询或设置信号遮罩

**头文件**

```c
#include <signal.h>
```

**函数原型**

```c
int sigprocmask(int how, const sigset_t *set, sigset_t * oldset);
```

- 说明：sigprocmask()可以用来改变目前的信号遮罩，其操作依参数how来决定

  - `SIG_BLOCK` 新的信号遮罩由目前的信号遮罩和参数set 指定的信号遮罩作联集
  - `SIG_UNBLOCK` 将目前的信号遮罩删除掉参数set指定的信号遮罩
  - `SIG_SETMASK` 将目前的信号遮罩设成参数set指定的信号遮罩。

  如果参数oldset不是NULL指针，那么目前的信号遮罩会由此指针返回。

- 返回值：执行成功则返回0，如果有错误则返回-1。

  错误代码：

  - `EFAULT` 参数set，oldset指针地址无法存取。
  - `EINTR` 此调用被中断

- 附加说明：

- 相关函数：signal，sigaction，sigpending，sigsuspend

**示例**

```c

```

执行

```shell

```


sleep
---------------------------------------------

让进程暂停执行一段时间

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
unsigned int sleep(unsigned int seconds);
```

- 说明：sleep()会令目前的进程暂停，直到达到参数seconds 所指定的时间，或是被信号所中断。
- 返回值：若进程暂停到参数 seconds 所指定的时间则返回0，若有信号中断则返回剩余秒数。
- 附加说明：
- 相关函数：signal，alarm

**示例**

```c

```

执行

```shell

```


ferror
---------------------------------------------

检查文件流是否有错误发生

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
int ferror(FILE *stream);
```

- 说明：ferror()用来检查参数stream所指定的文件流是否发生了错误情况，如有错误发生则返回非0值。
- 返回值：如果文件流有错误发生则返回非0值。
- 附加说明：
- 相关函数：clearerr，perror

**示例**

```c

```

执行

```shell

```


perror
---------------------------------------------

打印出错误原因信息字符串

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
void perror(const char *s);
```

- 说明：perror()用来将上一个函数发生错误的原因输出到标准错误(stderr)。参数s所指的字符串会先打印出，后面再加上错误原因字符串。此错误原因依照全局变量errno的值来决定要输出的字符串。
- 返回值：无
- 附加说明：
- 相关函数：strerror

**示例**

```c
#include <stdio.h>

int main()
{
    FILE *fp;
    fp = fopen("/tmp/noexist","r+");
    if(fp == NULL) 
        perror("fopen");
    return 0;
}
```

执行

```shell
$ ./perror_example
fopen : No such file or diretory
```


strerror
---------------------------------------------

返回错误原因的描述字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char * strerror(int errnum);
```

- 说明：strerror()用来依参数errnum的错误代码来查询其错误原因的描述字符串，然后将该字符串指针返回。
- 返回值：返回描述错误原因的字符串指针。
- 附加说明：
- 相关函数：perror

**示例**

```c
/* 显示错误代码0 至9 的错误原因描述*/
#include <string.h>

int main()
{
    int i;
    for(i=0;i<10; i++)
        printf("%d : %s\n", i, strerror(i));
    return 0;
}
```

执行

```shell
0 : Success
1 : Operation not permitted
2 : No such file or directory
3 : No such process
4 : Interrupted system call
5 : Input/output error
6 : Device not configured
7 : Argument list too long
8 : Exec format error
9 : Bad file descriptor
```


mkfifo
---------------------------------------------

建立具名管道

**头文件**

```c
#include <sys/types.h>
#include <sys/stat.h>
```

**函数原型**

```c
int mkfifo(const char * pathname, mode_t mode);
```

- 说明：mkfifo()会依参数pathname建立特殊的FIFO文件，该文件必须不存在，而参数mode为该文件的权限（mode%~umask），因此umask值也会影响到FIFO文件的权限。mkfifo()建立的 FIFO 文件其他进程都可以用读写一般文件的方式存取。

  当使用 open() 来打开FIFO文件时，`O_NONBLOCK` 旗标会有影响：

  1. 当使用O_NONBLOCK 旗标时，打开FIFO 文件来读取的操作会立刻返回，但是若还没有其他进程打开FIFO 文件来读取，则写入的操作会返回ENXIO 错误代码。
  2. 没有使用O_NONBLOCK 旗标时，打开FIFO 来读取的操作会等到其他进程打开FIFO文件来写入才正常返回。同样地，打开FIFO文件来写入的操作会等到其他进程打开FIFO 文件来读取后才正常返回。

- 返回值：若成功则返回0，否则返回-1，错误原因存于errno中。

  错误代码：

  - `EACCESS` 参数 pathname 所指定的目录路径无可执行的权限
  - `EEXIST` 参数 pathname 所指定的文件已存在。
  - `ENAMETOOLONG` 参数 pathname 的路径名称太长。
  - `ENOENT` 参数 pathname 包含的目录不存在
  - `ENOSPC` 文件系统的剩余空间不足
  - `ENOTDIR` 参数 pathname 路径中的目录存在但却非真正的目录。
  - `EROFS` 参数 pathname 指定的文件存在于只读文件系统内。

- 附加说明：

- 相关函数：pipe，popen，open，umask

**示例**

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define FIFO "GETIOT"

int main()
{
    char buffer[80];
    int fd;
    unlink(FIFO);
    mkfifo(FIFO, 0666);
    if(fork() > 0) {
        char s[ ] = "hello!\n";
        fd = open(FIFO, O_WRONLY);
        write(fd, s, sizeof(s));
        close(fd);
    }
    else {
        fd= open(FIFO, O_RDONLY);
        read(fd, buffer, 80);
        printf("%s", buffer);
        close(fd);
    }
    return 0;
}
```

执行

```shell
hello!
```


pclose
---------------------------------------------

关闭管道 I/O

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
int pclose(FILE * stream);
```

- 说明：pclose() 用来关闭由 popen 所建立的管道及文件指针。参数 stream 为先前由 popen() 所返回的文件指针。

- 返回值：返回子进程的结束状态。如果有错误则返回-1，错误原因存于errno中。

  错误代码：

  - `ECHILD` pclose()无法取得子进程的结束状态。

- 附加说明：

- 相关函数：popen

**示例**

参考 popen()。


pipe
---------------------------------------------

建立管道

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int pipe(int filedes[2]);
```

- 说明：pipe()会建立管道，并将文件描述词由参数filedes数组返回。filedes[0]为管道里的读取端，filedes[1]则为管道的写入端。

- 返回值：若成功则返回零，否则返回-1，错误原因存于errno中。

  错误代码：

  - `EMFILE` 进程已用完文件描述词最大量。
  - `ENFILE` 系统已无文件描述词可用。
  - `EFAULT` 参数filedes数组地址不合法。

- 附加说明：

- 相关函数：mkfifo，popen，read，write，fork

**示例**

```c
/* 父进程借管道将字符串"hello!\n"传给子进程并显示*/
#include <stdio.h>
#include <unistd.h>

int main()
{
    int filedes[2];
    char buffer[80];
    pipe(filedes);
    
    if (fork() > 0) {
        /* 父进程*/
        char s[ ] = "hello!\n";
        write(filedes[1], s, sizeof(s));
    }
    else {
        /*子进程*/
        read(filedes[0], buffer, 80);
        printf("%s", buffer);
    }
    return 0;
}
```

执行

```shell
$ ./pipe_example 
hello!
```


popen
---------------------------------------------

建立管道 I/O

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
FILE * popen(const char * command, const char * type);
```

- 说明：popen()会调用fork()产生子进程，然后从子进程中调用/bin/sh -c来执行参数command的指令。参数type可使用“r”代表读取，“w”代表写入。依照此type值，popen()会建立管道连到子进程的标准输出设备或标准输入设备，然后返回一个文件指针。随后进程便可利用此文件指针来读取子进程的输出设备或是写入到子进程的标准输入设备中。此外，所有使用文件指针(FILE*)操作的函数也都可以使用，除了fclose()以外。
- 返回值：若成功则返回文件指针，否则返回NULL，错误原因存于errno中。
- 附加说明：在编写具SUID/SGID权限的程序时请尽量避免使用popen()，popen()会继承环境变量，通过环境变量可能会造成系统安全的问题。
- 相关函数：pipe，mkfifo，pclose，fork，system，fopen

**示例**

```c
#include <stdio.h>

int main()
{
    FILE * fp;
    char buffer[80];
    fp = popen("cat /etc/passwd", "r");
    fgets(buffer, sizeof(buffer), fp);
    printf("%s", buffer);
    pclose(fp);
    return 0;
}
```

执行

```shell
$ ./popen_example 
root:x:0:0:root:/root:/bin/bash
```

