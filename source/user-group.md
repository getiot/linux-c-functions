用户组篇
=============================================

> 用户组函数是 POSIX 标准中用于管理用户和组信息的函数集合，包括用户身份查询、组信息获取、权限验证、身份切换等操作。这些函数为程序提供了用户管理能力，是系统安全、权限控制、多用户应用和系统管理工具的核心组件。

endgrent
---------------------------------------------

关闭组文件

**头文件**

```c
#include <grp.h>
#include <sys/types.h>
```

**函数原型**

```c
void endgrent(void);
```

- 说明：`endgrent()` 用来关闭由 `getgrent()` 所打开的密码文件。
- 返回值：无
- 附加说明：
- 相关函数：getgrent，setgrent

**示例**

请参考 `getgrent()` 与 `setgrent()`。


endpwent
---------------------------------------------

关闭密码文件

**头文件**

```c
#include <pwd.h>
#include <sys/types.h>
```

**函数原型**

```c
void endpwent(void);
```

- 说明：`endpwent()` 用来关闭由 `getpwent()` 所打开的密码文件。
- 返回值：无
- 附加说明：
- 相关函数：getpwent，setpwent

**示例**

请参考 `getpwent()` 与 `setpwent()`。


endutent
---------------------------------------------

关闭 utmp 文件

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
void endutent(void);
```

- 说明：`endutent()` 用来关闭由 `getutent` 所打开的 utmp 文件。
- 返回值：无
- 附加说明：
- 相关函数：getutent，setutent

**示例**

请参考 `getutent()`。


fgetgrent
---------------------------------------------

从指定的文件来读取组格式

**头文件**

```c
#include <grp.h>
#include <stdio.h>
#include <sys/types.h>
```

**函数原型**

```c
struct group * getgrent(FILE * stream);
```

- 说明：`fgetgrent()` 会从参数 stream 指定的文件读取一行数据，然后以 group 结构将该数据返回。参数 stream 所指定的文件必须和、etc/group 相同的格式。group 结构定义请参考 `getgrent()`。
- 返回值：返回 group 结构数据，如果返回 NULL 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：fgetpwent

**示例**

```c
#include <grp.h>
#include <sys/types.h>
#include <stdio.h>

int main()
{
    struct group *data;
    FILE *stream;
    int i;
    stream = fopen("/etc/group", "r");
    while((data = fgetgrent(stream))!=0){
        i=0;
        printf("%s :%s:%d :", data->gr_name,data->gr_passwd,data->gr_gid);
        while (data->gr_mem[i])printf("%s,",data->gr_mem[i++]);
        printf("\n");
    }
    fclose(stream);
    return 0;
}
```

执行

```shell
root:x:0:root,
bin:x:1:root,bin,daemon
daemon:x:2:root,bin,daemon
sys:x:3:root,bin,adm
adm:x:4:root,adm,daemon
tty:x:5
disk:x:6:root
lp:x:7:daemon,lp
mem:x:8
kmem:x:9
wheel:x:10:root
mail:x:12:mail
news:x:13:news
uucp:x:14:uucp
man:x:15
games:x:20
gopher:x:30
dip:x:40:
ftp:x:50
nobody:x:99:
```


fgetpwent
---------------------------------------------

从指定的文件来读取密码格式

**头文件**

```c
#include <pwd.h>
#include <stdio.h>
#include <sys/types.h>
```

**函数原型**

```c
struct passwd * fgetpwent(FILE *stream);
```

- 说明：`fgetpwent()` 会从参数 stream 指定的文件读取一行数据，然后以 passwd 结构将该数据返回。参数 stream 所指定的文件必须和 /etc/passwd 相同的格式。passwd 结构定义请参考 `getpwent()`。
- 返回值：返回 passwd 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：fgetgrent

**示例**

```c
#include <pwd.h>
#include <sys/types.h>

int main()
{
    struct passwd *user;
    FILE *stream;
    stream = fopen("/etc/passwd", "r");
    while((user = fgetpwent(stream))!=0){
        printf("%s:%d:%d:%s:%s:%s\n",user->pw_name,user->pw_uid,user->pw_gid,user->pw_gecos,user->pw_dir,user->pw_shell);
    }
    return 0;
}
```

执行

```shell
root:0:0:root:/root:/bin/bash
bin:1:1:bin:/bin:
daemon:2:2:daemon:/sbin:
adm:3:4:adm:/var/adm:
lp:4:7:lp:/var/spool/lpd:
sync:5:0:sync:/sbin:/bin/sync
shutdown:6:0:shutdown:/sbin:/sbin/shutdown
halt:7:0:halt:/sbin:/sbin/halt
mail:8:12:mail:/var/spool/mail:
news:9:13:news:var/spool/news
uucp:10:14:uucp:/var/spool/uucp:
operator:11:0:operator :/root:
games:12:100:games:/usr/games:
gopher:13:30:gopher:/usr/lib/gopher-data:
ftp:14:50:FTP User:/home/ftp:
nobody:99:99:Nobody:/:
xfs:100:101:X Font Server: /etc/Xll/fs:/bin/false
gdm:42:42:/home/gdm:/bin/bash
kids:500:500: : /home/kids:/bin/bash
```


getegid
---------------------------------------------

取得有效的组识别码

**头文件**

```c
#include <unistd.h>
#include <sys/types.h>
```

**函数原型**

```c
gid_t getegid(void);
```

- 说明：`getegid()` 用来取得执行目前进程有效组识别码。有效的组识别码用来决定进程执行时组的权限。返回值返回有效的组识别码。
- 返回值：
- 附加说明：
- 相关函数：getgid，setgid，setregid

**示例**

```c
int main()
{
    printf("egid is %d\n", getegid());
}
```

执行

```shell
egid is 0 # 当使用root身份执行范例程序时
```


geteuid
---------------------------------------------

取得有效的用户识别码

**头文件**

```c
#include <unistd.h>
#include <sys/types.h>
```

**函数原型**

```c
uid_t geteuid(void)
```

- 说明：`geteuid()` 用来取得执行目前进程有效的用户识别码。有效的用户识别码用来决定进程执行的权限，借由此改变此值，进程可以获得额外的权限。倘若执行文件的 setID 位已被设置，该文件执行时，其进程的 euid 值便会设成该文件所有者的 uid。例如，执行文件 /usr/bin/passwd 的权限为 `-r-s--x--x`，其 `s` 位即为 `setID(SUID)` 位，而当任何用户在执行 passwd 时其有效的用户识别码会被设成 passwd 所有者的 uid 值，即 root 的 uid 值（0）。
- 返回值：返回有效的用户识别码。
- 附加说明：
- 相关函数：getuid，setreuid，setuid

**示例**

```c
int main()
{
    printf ("euid is %d \n",geteuid());
}
```

执行

```shell
euid is 0 # 当使用root身份执行范例程序时
```


getgid
---------------------------------------------

取得真实的组识别码

**头文件**

```c
#include <unistd.h>
#include <sys/types.h>
```

**函数原型**

```c
gid_t getgid(void);
```

- 说明：`getgid()` 用来取得执行目前进程的组识别码。
- 返回值：返回组识别码
- 附加说明：
- 相关函数：getegid，setregid，setgid

**示例**

```c
int main()
{
    printf("gid is %d\n", getgid());
}
```

执行

```shell
gid is 0 # 当使用root身份执行范例程序时
```


getgrent
---------------------------------------------

从组文件中取得账号的数据

**头文件**

```c
#include <grp.h>
#include <sys/types.h>
```

**函数原型**

```c
struct group *getgrent(void);
```

- 说明：`getgrent()` 用来从组文件（/etc/group）中读取一项组数据，该数据以 group 结构返回。第一次调用时会取得第一项组数据，之后每调用一次就会返回下一项数据，直到已无任何数据时返回 `NULL`。

  ```c
  struct group
  {
      char *gr_name;   /*组名称*/
      char *gr_passwd; /*组密码*/
      gid_t gr_gid;    /*组识别码*/
      char **gr_mem;   /*组成员账号*/
  }
  ```

- 返回值：返回 group 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。

  错误代码：

  - `ENOMEM` 内存不足，无法配置 group 结构。

- 附加说明：`getgrent()` 在第一次调用时会打开组文件，读取数据完毕后可使用 `endgrent()` 来关闭该组文件。

- 相关函数：setgrent，endgrent

**示例**

```c
#include <grp.h>
#include <sys/types.h>

int main()
{
    struct group *data;
    int i;
    while((data= getgrent())!=0){
        i=0;
        printf("%s:%s:%d:",data->gr_name,data->gr_passwd,data->gr_gid);
        while(data->gr_mem[i])
            printf("%s,",data->gr_mem[i++]);
        printf("\n");
    }
    endgrent();
    return 0;
}
```

执行

```shell
root:x:0:root,
bin:x:1:root,bin,daemon,
daemon:x:2:root,bin,daemon,
sys:x:3:root,bin,adm,
adm:x:4:root,adm,daemon
tty:x:5
disk:x:6:root
lp:x:7:daemon,lp
mem:x:8
kmem:x:9:
wheel:x:10:root
mail:x:12:mail
news:x:13:news
uucp:x:14:uucp
man:x:15:
games:x:20
gopher:x:30
dip:x:40
ftp:x:50
nobody:x:99
```


getgrgid
---------------------------------------------

从组文件中取得指定 gid 的数据

**头文件**

```c
#include <grp.h>
#include <sys/types.h>
```

**函数原型**

```c
struct group * getgrgid(gid_t gid);
```

- 说明：`getgrgid()` 用来依参数 gid 指定的组识别码逐一搜索组文件，找到时便将该组的数据以 group 结构返回。group 结构请参考 `getgrent()`。
- 返回值：返回 group 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：fgetgrent，getgrent，getgrnam

**示例**

```c
/* 取得gid＝3的组数据*/
#include <grp.h>
#include <sys/types.h>

int main()
{
    struct group *data;
    int i=0;
    data = getgrgid(3);
    printf("%s:%s:%d:",data->gr_name,data->gr_passwd,data->gr_gid);
    while(data->gr_mem[i])
        printf("%s ,",data->mem[i++]);
    printf("\n");
    return 0;
}
```

执行

```shell
sys:x:3:root,bin,adm
```


getgrnam
---------------------------------------------

从组文件中取得指定组的数据

**头文件**

```c
#include <grp.h>
#include <sys/types.h>
```

**函数原型**

```c
struct group * getgrnam(const char * name);
```

- 说明：`getgrnam()` 用来逐一搜索参数那么指定的组名称，找到时便将该组的数据以 group 结构返回。group 结构请参考 `getgrent()`。
- 返回值：返回 group 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：fgetgrent，getrent，getgruid

**示例**

```c
/* 取得adm的组数据*/
#include <grp.h>
#include <sys/types.h>

int main()
{
    struct group * data;
    int i=0;
    data = getgrnam("adm");
    printf("%s:%s:%d:",data->gr_name,data->gr_passwd,data->gr_gid);
    while(data->gr_mem[i])
        printf("%s,",data->gr_mem[i++]);
    printf("\n");
}
```

执行

```shell
adm:x:4:root,adm,daemon
```


getgroups
---------------------------------------------

取得组代码

**头文件**

```c
#include <unistd.h>
#include <sys/types.h>
```

**函数原型**

```c
int getgroups(int size, gid_t list[]);
```

- 说明：`getgroup()` 用来取得目前用户所属的组代码。参数 size 为 `list[]` 所能容纳的 `gid_t` 数目。如果参数 `size` 值为零，此函数仅会返回用户所属的组数。

- 返回值：返回组识别码，如有错误则返回-1。

  错误代码：

  - `EFAULT` 参数 list 数组地址不合法。
  - `EINVAL` 参数 size 值不足以容纳所有的组。

- 附加说明：

- 相关函数：initgroups，setgroup，getgid，setgid

**示例**

```c
#include <unistd.h>
#include <sys/types.h>

int main()
{
    gid_t list[500];
    int x,i;
    x = getgroups(0.list);
    getgroups(x,list);
    for(i=0;i<x;i++) {
        printf("%d:%d\n",i,list[i]);
    }
    return 0;
}
```

执行

```shell
0:00
1:01
2:02
3:03
4:04
5:06
6:10
```


getpw
---------------------------------------------

取得指定用户的密码文件数据

**头文件**

```c
#include <pwd.h>
#include <sys/types.h>
```

**函数原型**

```c
int getpw(uid_t uid, char *buf);
```

- 说明：`getpw()` 会从 /etc/passwd 中查找符合参数 uid 所指定的用户账号数据，找不到相关数据就返回 -1。

  所返回的 buf 字符串格式如下：

  ```bash
  账号:密码:用户识别码(uid):组识别码(gid):全名:根目录:shell
  ```

- 返回值：返回 0 表示成功，有错误发生时返回 -1。

- 附加说明：

  1. `getpw()` 会有潜在的安全性问题，请尽量使用别的函数取代。
  2. 使用 shadow 的系统已把用户密码抽出 /etc/passwd，因此使用 `getpw()` 取得的密码将为"x"。

- 相关函数：getpwent

**示例**

```c
#include <pwd.h>
#include <sys/types.h>

int main()
{
    char buffer[80];
    getpw(0,buffer);
    printf("%s\n",buffer);
    return 0;
}
```

执行

```shell
root:x:0:0:root:/root:/bin/bash
```


getpwent
---------------------------------------------

从密码文件中取得账号的数据

**头文件**

```c
#include <pwd.h>
#include <sys/types.h>
```

**函数原型**

```c
struct passwd * getpwent(void);
```

- 说明：`getpwent()` 用来从密码文件（/etc/passwd）中读取一项用户数据，该用户的数据以 passwd 结构返回。第一次调用时会取得第一位用户数据，之后每调用一次就会返回下一项数据，直到已无任何数据时返回 `NULL`。

  passwd 结构定义如下：

  ```c
  struct passwd
  {
      char * pw_name;   /*用户账号*/
      char * pw_passwd; /*用户密码*/
      uid_t  pw_uid;    /*用户识别码*/
      gid_t  pw_gid;    /*组识别码*/
      char * pw_gecos;  /*用户全名*/
      char * pw_dir;    /*家目录*/
      char * pw_shell;  /*所使用的shell路径*/
  };
  ```

- 返回值：返回 passwd 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。

- 附加说明：`getpwent()` 在第一次调用时会打开密码文件，读取数据完毕后可使用 `endpwent()` 来关闭该密码文件。错误代码 `ENOMEM` 内存不足，无法配置 passwd 结构。

- 相关函数：getpw，fgetpwent，getpwnam，getpwuid，setpwent，endpwent

**示例**

```c
#include <pwd.h>
#include <sys/types.h>

int main()
{
    struct passwd *user;
    while((user = getpwent())!=0)
    {
        printf("%s:%d:%d:%s:%s:%s\n",
               user->pw_name,user->pw_uid,user->pw_gid,
               user->pw_gecos,user->pw_dir,user->pw_shell);
    }
    endpwent();
    return 0;
}
```

执行

```shell
root:0:0:root:/root:/bin/bash
bin:1:1:bin:/bin:
daemon:2:2:daemon:/sbin:
adm:3:4:adm:/var/adm:
lp:4:7:lp:/var/spool/lpd:
sync:5:0:sync:/sbin:/bin/sync
shutdown:6:0:shutdown:/sbin:/sbin/shutdown
halt:7:0:halt:/sbin:/sbin/halt
mail:8:12:mail:/var/spool/mail:
news:9:13:news:var/spool/news
uucp:10:14:uucp:/var/spool/uucp:
operator:11:0:operator :/root:
games:12:100:games:/usr/games:
gopher:13:30:gopher:/usr/lib/gopher-data:
ftp:14:50:FTP User:/home/ftp:
nobody:99:99:Nobody:/:
xfs:100:101:X Font Server: /etc/Xll/fs:/bin/false
gdm:42:42:/home/gdm:/bin/bash
kids:500:500: : /home/kids:/bin/bash
```


getpwnam
---------------------------------------------

从密码文件中取得指定账号的数据

**头文件**

```c
#include <pwd.h>
#include <sys/types.h>
```

**函数原型**

```c
struct passwd * getpwnam(const char * name);
```

- 说明：`getpwnam()` 用来逐一搜索参数name 指定的账号名称，找到时便将该用户的数据以 passwd 结构返回。passwd 结构请参考 `getpwent()`。
- 返回值：返回 passwd 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：getpw，fgetpwent，getpwent，getpwuid

**示例**

```c
/*取得root账号的识别码和根目录*/
#include <pwd.h>
#include <sys/types.h>

int main()
{
    struct passwd *user;
    user = getpwnam("root");
    printf("name:%s\n",user->pw_name);
    printf("uid:%d\n",user->pw_uid);
    printf("home:%s\n",user->pw_dir);
    return 0;
}
```

执行

```shell
name:root
uid:0
home:/root
```


getpwuid
---------------------------------------------

从密码文件中取得指定 uid 的数据

**头文件**

```c
#include <pwd.h>
#include <sys/types.h>
```

**函数原型**

```c
struct passwd * getpwuid(uid_t uid);
```

- 说明：`getpwuid()` 用来逐一搜索参数uid 指定的用户识别码，找到时便将该用户的数据以结构返回结构请参考将该用户的数据以 passwd 结构返回。passwd 结构请参考 `getpwent()`。
- 返回值：返回 passwd 结构数据，如果返回 `NULL` 则表示已无数据，或者有错误发生。
- 附加说明：
- 相关函数：getpw，fgetpwent，getpwent，getpwnam

**示例**

```c
#include <pwd.h>
#include <sys/types.h>

int main()
{
    struct passwd *user;
    user= getpwuid(6);
    printf("name:%s\n",user->pw_name);
    printf("uid:%d\n",user->pw_uid);
    printf("home:%s\n",user->pw_dir);
    return 0;
}
```

执行

```shell
name:shutdown
uid:6
home:/sbin
```


getuid
---------------------------------------------

取得真实的用户识别码

**头文件**

```c
#include <unistd.h>
#include <sys/types.h>
```

**函数原型**

```c
uid_t getuid(void);
```

- 说明：`getuid()` 用来取得执行目前进程的用户识别码。
- 返回值：用户识别码
- 附加说明：
- 相关函数：geteuid，setreuid，setuid

**示例**

```c
int main()
{
    printf("uid is %d\n",getuid());
}
```

执行

```shell
uid is 0 # 当使用root身份执行范例程序时
```


getutent
---------------------------------------------

从 utmp 文件中取得账号登录数据

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
struct utmp *getutent(void);
```

- 说明：`getutent()` 用来从 utmp 文件（/var/run/utmp）中读取一项登录数据，该数据以 utmp 结构返回。第一次调用时会取得第一位用户数据，之后每调用一次就会返回下一项数据，直到已无任何数据时返回 `NULL`。

  utmp 结构定义如下：

  ```c
  struct utmp
  {
      short int ut_type;          /*登录类型*/
      pid_t ut_pid;               /*login进程的pid*/
      char ut_line[UT_LINESIZE];  /*登录装置名，省略了"/dev/"*/
      char ut_id[4];              /*Inittab ID*/
      char ut_user[UT_NAMESIZE];  /*登录账号*/
      char ut_host[UT_HOSTSIZE];  /*登录账号的远程主机名称*/
      struxt exit_status ut_exit; /*当类型为DEAD_PROCESS时进程的结束状态*/
      long int ut_session;        /*Sessioc ID*/
      struct timeval ut_tv;       /*时间记录*/
      int32_t ut_addr_v6[4];      /*远程主机的网络地址*/
      char __unused[20];          /*保留未使用*/
  };
  ```

  `ut_type` 有以下几种类型：

  - `EMPTY` 此为空的记录。
  - `RUN_LVL` 记录系统 run－level 的改变
  - `BOOT_TIME` 记录系统开机时间
  - `NEW_TIME` 记录系统时间改变后的时间
  - `OLD_TINE` 记录当改变系统时间时的时间。
  - `INIT_PROCESS` 记录一个由 init 衍生出来的进程。
  - `LOGIN_PROCESS` 记录 login 进程。
  - `USER_PROCESS` 记录一般进程。
  - `DEAD_PROCESS` 记录一结束的进程。
  - `ACCOUNTING` 目前尚未使用。

  `exit_status` 结构定义：

  ```c
  struct exit_status
  {
      short int e_termination; /*进程结束状态*/
      short int e_exit;        /*进程退出状态*/
  };
  ```

  `timeval` 的结构定义请参考 `gettimeofday()`。
  相关常数定义如下：

  ```c
  UT_LINESIZE 32
  UT_NAMESIZE 32
  UT_HOSTSIZE 256
  ```

- 返回值：返回 utmp 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。

- 附加说明：`getutent()` 在第一次调用时会打开 utmp 文件，读取数据完毕后可使用 `endutent()` 来关闭该 utmp 文件。

- 相关函数：getutent，getutid，getutline，setutent，endutent，pututline，utmpname

**示例**

```c
#include <utmp.h>

int main()
{
    struct utmp *u;
    while((u=getutent()))
    {
        if(u->ut_type == USER_PROCESS)
        {
            printf("%d %s %s %s \n",
                   u->ut_type,u->ut_user,u->ut_line,u->ut_host);
        }
    }
    endutent();
    return 0;
}
```

执行

```shell
# 表示有三个root账号分别登录/dev/pts/0，/dev/pts/1，/dev/pts/2
7 root pts/0
7 root pts/1
7 root pts/2
```


getutid
---------------------------------------------

从 utmp 文件中查找特定的记录

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
struct utmp *getutid(struct utmp *ut);
```

- 说明：`getutid()` 用来从目前 utmp 文件的读写位置逐一往后搜索参数 `ut` 指定的记录，如果 `ut->ut_type` 为`RUN_LVL`、`BOOT_TIME`、`NEW_TIME`、`OLD_TIME` 其中之一则查找与 `ut->ut_type` 相符的记录；若 `ut->ut_type` 为 `INIT_PROCESS`、`LOGIN_PROCESS`、`USER_PROCESS` 或 `DEAD_PROCESS` 其中之一，则查找与 `ut->ut_id` 相符的记录。找到相符的记录便将该数据以 utmp 结构返回。utmp 结构请参考 `getutent()`。
- 返回值：返回 utmp 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：getutent，getutline

**示例**

```c
#include <utmp.h>

int main()
{
    struct utmp ut,*u;
    ut.ut_type=RUN_LVL;
    while((u= getutid(&ut))) {
        printf("%d %s %s %s\n", u->ut_type,u->ut_user,u->ut_line,u->ut_host);
    }
    return 0;
}
```

执行

```shell
1 runlevel -
```


getutline
---------------------------------------------

从 utmp 文件中查找特定的记录

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
struct utmp * getutline(struct utmp *ut);
```

- 说明：`getutline()` 用来从目前 utmp 文件的读写位置逐一往后搜索 `ut_type` 为 `USER_PROCESS` 或 `LOGIN_PROCESS` 的记录，而且 `ut_line` 和 `ut->ut_line` 相符。找到相符的记录便将该数据以 utmp 结构返回，utmp 结构请参考 `getutent()`。
- 返回值：返回 `utmp` 结构数据，如果返回 `NULL` 则表示已无数据，或有错误发生。
- 附加说明：
- 相关函数：getutent，getutid，pututline

**示例**

```c
#include<utmp.h>

int main()
{
    struct utmp ut,*u;
    strcpy (ut.ut_line,"pts/1");
    while ((u=getutline(&ut))) {
        printf("%d %s %s %s \n",u->ut_type,u->ut_user,u->ut_line,u->ut_host);
    }
}
```

执行

```shell
7 root pts/1
```


initgroups
---------------------------------------------

该函数用于初始化进程的附属组访问列表。它通过读取系统组数据库（通常是 `/etc/group` 文件），若该组数据的成员中有参数 `user` 时，便将参数 `group` 组识别码加入到此数据中。

**头文件**

```c
#include <grp.h>
#include <sys/types.h>
```

**函数原型**

```c
int initgroups(const char *user, gid_t group);
```

**参数**

- `user`：指定用户的用户名，该用户必须存在。
- `group`：一个额外的组 ID，该组 ID 也会被添加到附属组列表中。

**返回值**

- 成功时返回 `0`。
- 失败时返回 `-1`，并设置 `errno`：
  - `ENOMEM`：内存不足。
  - `EPERM`：调用进程权限不足。

**使用说明**

- 该函数通常用于需要切换用户权限的场景，例如在创建子进程时，需要以特定用户的身份运行。
- 调用该函数时，需要确保当前进程有足够的权限（通常是超级用户权限），否则可能会失败。
- 如果用户所属的组数量超过系统限制（`NGROUPS_MAX`），可能会导致部分组被丢弃。

相关函数：setgrent，endgrent

**示例**

```c
#include <stdio.h>
#include <stdlib.h>
#include <grp.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
    const char *username = "testuser"; // 替换为实际存在的用户名
    gid_t group = 1000; // 替换为实际的组ID

    // 初始化附属组列表
    if (initgroups(username, group) == -1) {
        perror("initgroups failed");
        return EXIT_FAILURE;
    }

    printf("Group list initialized successfully for user: %s\n", username);
    return EXIT_SUCCESS;
}
```

编译并执行程序，如果用户 `testuser` 和组 ID `1000` 都有效，则输出如下：

```shell
Group list initialized successfully for user: testuser
```


pututline
---------------------------------------------

将 utmp 记录写入文件

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
void pututline(struct utmp *ut);
```

- 说明：pututline()用来将参数ut的utmp结构记录到utmp文件中。此函数会先用getutid()来取得正确的写入位置，如果没有找到相符的记录则会加入到utmp文件尾，utmp结构请参考getutent()。
- 返回值：无
- 附加说明：需要有写入 /var/run/utmp 的权限
- 相关函数：getutent，getutid，getutline

**示例**

```c
#include <utmp.h>

int main()
{
    struct utmp ut;
    ut.ut_type =USER_PROCESS;
    ut.ut_pid=getpid();
    strcpy(ut.ut_user,"kids");
    strcpy(ut.ut_line,"pts/1");
    strcpy(ut.ut_host,"www.gnu.org");
    pututline(&ut);
    return 0;
}
```

执行

```shell
# 执行范例后用指令who -l 观察 
root pts/0 dec9 19:20
kids pts/1 dec12 10:31(www.gnu.org)
root pts/2 dec12 13:33
```


seteuid
---------------------------------------------

设置有效的用户识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int seteuid(uid_t euid);
```

- 说明：seteuid() 用来重新设置执行目前进程的有效用户识别码。在 Linux 下，seteuid(euid) 相当于 setreuid(-1,euid)。
- 返回值：执行成功则返回0，失败则返回-1，错误代码存于errno
- 附加说明：
- 相关函数：setuid，setreuid，setfsuid

**示例**

请参考 setuid()。


setfsgid
---------------------------------------------

设置文件系统的组识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int setfsgid(uid_t fsgid);
```

- 说明：setfsgid()用来重新设置目前进程的文件系统的组识别码。一般情况下，文件系统的组识别码(fsgid)与有效的组识别码(egid)是相同的。如果是超级用户调用此函数，参数fsgid 可以为任何值，否则参数fsgid必须为real/effective/saved的组识别码之一。

- 返回值：执行成功则返回0，失败则返回-1，错误代码存于errno。

  错误代码：

  - `EPERM` 权限不够，无法完成设置。

- 附加说明：此函数为Linux特有。

- 相关函数：setuid，setreuid，seteuid，setfsuid

**示例**

```c

```

执行

```shell

```


setfsuid
---------------------------------------------

设置文件系统的用户识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int setfsuid(uid_t fsuid);
```

- 说明：setfsuid()用来重新设置目前进程的文件系统的用户识别码。一般情况下，文件系统的用户识别码(fsuid)与有效的用户识别码(euid)是相同的。如果是超级用户调用此函数，参数fsuid可以为任何值，否则参数fsuid必须为real/effective/saved的用户识别码之一。

- 返回值：执行成功则返回0，失败则返回-1，错误代码存于errno。

  错误代码：

  - `EPERM` 权限不够，无法完成设置。

- 附加说明：此函数为Linux特有

- 相关函数：setuid，setreuid，seteuid，setfsgid

**示例**

```c

```

执行

```shell

```


setgid
---------------------------------------------

设置真实的组识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int setgid(gid_t gid);
```

- 说明：setgid()用来将目前进程的真实组识别码(real gid)设成参数gid值。如果是以超级用户身份执行此调用，则real、effective与savedgid都会设成参数gid。

- 返回值：设置成功则返回0，失败则返回-1，错误代码存于errno中。

  错误代码：

  - `EPERM` 并非以超级用户身份调用，而且参数gid 并非进程的effective gid或saved gid值之一。

- 附加说明：

- 相关函数：getgid，setregid，getegid，setegid

**示例**

```c

```

执行

```shell

```


setgrent
---------------------------------------------

从头读取组文件中的组数据

**头文件**

```c
#include <grp.h>
#include <sys/types.h>
```

**函数原型**

```c
void setgrent(void);
```

- 说明：setgrent() 用来将 getgrent() 的读写地址指回组文件开头。
- 返回值：无
- 附加说明：
- 相关函数：getgrent，endgrent

**示例**

请参考 setpwent()。


setgroups
---------------------------------------------

设置组代码

**头文件**

```c
#include <grp.h>
```

**函数原型**

```c
int setgroups(size_t size, const gid_t * list);
```

- 说明：setgroups() 用来将 list 数组中所标明的组加入到目前进程的组设置中。参数size为list()的gid_t数目，最大值为 `NGROUP(32)`。

- 返回值：设置成功则返回0，如有错误则返回-1。

  错误代码：

  - `EFAULT` 参数list数组地址不合法。
  - `EPERM` 权限不足，必须是root权限
  - `EINVAL` 参数size值大于NGROUP(32)。

- 附加说明：

- 相关函数：initgroups，getgroup，getgid，setgid

**示例**

```c

```

执行

```shell

```


setpwent
---------------------------------------------

从头读取密码文件中的账号数据

**头文件**

```c
#include <pwd.h>
#include <sys/types.h>
```

**函数原型**

```c
void setpwent(void);
```

- 说明：setpwent() 用来将 getpwent() 的读写地址指回密码文件开头。
- 返回值：无
- 附加说明：
- 相关函数：getpwent，endpwent

**示例**

```c
#include <pwd.h>
#include <sys/types.h>

int main()
{
    struct passwd *user;
    int i;
    for(i=0;i<4;i++){
        user=getpwent();
        printf("%s :%d :%d :%s:%s:%s\n",
               user->pw_name,user->pw_uid,user->pw_gid,
               user->pw_gecos,user->pw_dir,user->pw_shell);
    }
    setpwent();
    user=getpwent();
    printf("%s :%d :%d :%s:%s:%s\n",
           user->pw_name,user->pw_uid,user->pw_gid,
           user->pw_gecos,user->pw_dir,user->pw_shell);
    endpwent();
    return 0;
}
```

执行

```shell
root:0:0:root:/root:/bin/bash
bin:1:1:bin:/bin
daemon:2:2:daemon:/sbin
adm:3:4:adm:/var/adm
root:0:0:root:/root:/bin/bash
```


setregid
---------------------------------------------

设置真实及有效的组识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int setregid(gid_t rgid, gid_t egid);
```

- 说明：setregid() 用来将参数 rgid 设为目前进程的真实组识别码，将参数 egid 设置为目前进程的有效组识别码。如果参数 rgid 或 egid 值为 -1，则对应的识别码不会改变。
- 返回值：执行成功则返回 0，失败则返回 -1，错误代码存于 errno。
- 附加说明：
- 相关函数：setgid，setegid，setfsgid

**示例**

```c

```

执行

```shell

```


setreuid
---------------------------------------------

设置真实及有效的用户识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int setreuid(uid_t ruid, uid_t euid);
```

- 说明：setreuid()用来将参数ruid 设为目前进程的真实用户识别码，将参数euid 设置为目前进程的有效用户识别码。如果参数ruid 或euid值为-1，则对应的识别码不会改变。
- 返回值：执行成功则返回0，失败则返回-1，错误代码存于errno。
- 附加说明：
- 相关函数：setuid，seteuid，setfsuid

**示例**

请参考 setuid()。


setuid
---------------------------------------------

设置真实的用户识别码

**头文件**

```c
#include <unistd.h>
```

**函数原型**

```c
int setuid(uid_t uid)
```

- 说明：setuid()用来重新设置执行目前进程的用户识别码。不过，要让此函数有作用，其有效的用户识别码必须为0(root)。在Linux下，当root使用setuid()来变换成其他用户识别码时，root权限会被抛弃，完全转换成该用户身份，也就是说，该进程往后将不再具有可setuid()的权利，如果只是向暂时抛弃root 权限，稍后想重新取回权限，则必须使用seteuid()。
- 返回值：执行成功则返回0，失败则返回-1，错误代码存于errno。
- 附加说明：一般在编写具setuid root的程序时，为减少此类程序带来的系统安全风险，在使用完root权限后建议马上执行setuid(getuid());来抛弃root权限。此外，进程uid和euid不一致时Linux系统将不会产生core dump。
- 相关函数：getuid，setreuid，seteuid，setfsuid

**示例**

```c

```

执行

```shell

```


setutent
---------------------------------------------

从头读取utmp 文件中的登录数据

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
void setutent(void);
```

- 说明：setutent()用来将getutent()的读写地址指回utmp文件开头。
- 返回值：无
- 附加说明：
- 相关函数：getutent，endutent

**示例**

请参考 setpwent() 或 setgrent()。


utmpname
---------------------------------------------

设置 utmp 文件路径

**头文件**

```c
#include <utmp.h>
```

**函数原型**

```c
void utmpname(const char * file);
```

- 说明：utmpname() 用来设置utmp文件的路径，以提供utmp相关函数的存取路径。如果没有使用utmpname()则默认utmp文件路径为/var/run/utmp。
- 返回值：无
- 附加说明：
- 相关函数：getutent，getutid，getutline，setutent，endutent，pututline

**示例**

```c

```

执行

```shell

```

