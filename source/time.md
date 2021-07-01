日期时间篇
=============================================

asctime
---------------------------------------------

将时间和日期以字符串格式表示

头文件 `#include <time.h>`

函数原型

```c
char *asctime(const struct tm *tm);
```

- 说明：asctime() 将参数 tm 所指的 tm 结构体中的信息转换成真实世界所使用的时间日期表示方法，然后将结果以字符串形式返回。此函数已经由时区转换成当地时间，字符串格式为 "Mon Apr  6 05:20:01 1992\n"。若再调用相关的时间日期函数，此字符串可能会被破坏。此函数与 ctime 不同之处在于传入的参数是不同的结构体。
- 返回值：返回一字符串表示目前当地的时间日期。
- 相关函数：time，ctime，gmtime，localtime

示例

```c
#include <stdio.h>
#include <time.h>

int main()
{
    time_t timep;
    time(&timep);
    printf("%s", asctime(gmtime(&timep)));
    return 0;
}
```

执行

```shell
Sun Jun 20 05:01:21 2021
```


clock_gettime
---------------------------------------------

将时间和日期以字符串格式表示

头文件 `#include <time.h>`

函数原型

```c
int clock_gettime(clockid_t clk_id, struct timespec *tp);
```

- 说明：
- 返回值：
- 相关函数：time, date, gettimeofday

示例

```c
#include <stdio.h>
#include <time.h>

struct timespec ts;
if (clock_gettime(CLOCK_REALTIME, &ts) == -1)
{
    /* handle error */
    return -1;
}
```

执行

```shell

```


ctime
---------------------------------------------

将时间和日期以字符串格式表示

头文件 `#include <time.h>`

函数原型

```c
char *ctime(const time_t *timep);
```

- 说明：ctime() 将参数 timep 所指的 time_t 结构中的信息转换成真实世界所使用的时间日期表示方法，然后将结果以字符串形式返回。此函数已经由时区转换成当地时间，字符串格式为 "Mon Apr  6 05:20:01 1992\n"。若再调用相关的时间日期函数，此字符串可能会被破坏。
- 返回值：返回一字符串表示目前当地的时间日期。
- 相关函数：time，asctime，gmtime，localtime

示例

```c
#include <stdio.h>
#include <time.h>

int main()
{
    time_t timep;
    time(&timep);
    printf("%s", ctime(&timep));
    return 0;
}
```

执行

```shell
Sun Jun 20 13:09:17 2021
```


gettimeofday
---------------------------------------------

获取目前的时间

头文件 `#include <sys/time.h>`

函数原型

```c
int gettimeofday(struct timeval *tv, struct timezone *tz);
```

- 说明：gettimeofday() 会把目前的时间由 tv 所指的结构返回，当地时区的信息则放到 tz 所指的结构中。

  timeval 结构体定义：

  ```c
  struct timeval {
      long tv_sec;   /* 秒 */
      long tv_usec;  /* 微秒 */
  };
  ```

  timezone 结构体定义：

  ```c
  struct timezone {
      int tz_minuteswest;  /* 和格林尼治时间差了多少分钟 */
      int tz_dsttime;      /* 时间的修正方式 */
  };
  ```

  上述两个结构体都定义在 /usr/include/sys/time.h，其中 tz_dsttime 所代表的状态如下：

  ```c
  DST_NONE    /* 不使用 */
  DST_USA     /* 美国 */
  DST_AUST    /* 澳洲 */
  DST_WET     /* 西欧 */
  DST_MET     /* 中欧 */
  DST_EET     /* 东欧 */
  DST_CAN     /* 加拿大 */
  DST_GB      /* 英国 */
  DST_RUM     /* 罗马尼亚 */
  DST_TUR     /* 土耳其 */
  DST_AUSTALT /* 澳洲（1986年以后）*/
  ```

- 返回值：成功则返回 0，失败返回 -1，错误代码存于 errno。

- 附加说明：EFAULT 表示指针 tv 和 tz 所指的内存空间超出存取权限。

- 相关函数：time，ctime，ftime，settimeofday

示例

```c
#include <stdio.h>
#include <sys/time.h>

int main()
{
    struct timeval tv;
    struct timezone tz;
    gettimeofday(&tv, &tz);
    printf("tv_sec: %ld\n", tv.tv_sec) ;
    printf("tv_usec: %ld\n", tv.tv_usec);
    printf("tz_minuteswest: %d\n", tz.tz_minuteswest);
    printf("tz_dsttime: %d\n", tz.tz_dsttime);
    return 0;
}
```

执行

```shell
tv_sec: 1624167233
tv_usec: 499533
tz_minuteswest: 0
tz_dsttime: 0
```


gmtime
---------------------------------------------

获取目前的时间和日期

头文件 `#include <time.h>`

函数原型

```c
struct tm *gmtime(const time_t *timep);
```

- 说明：gmtime() 将参数 timep 所指的 time_t 结构中的信息转换成真实世界所使用的时间日期表示方法，然后将结果由结构 tm 返回。

  结构体 tm 的定义为：

  ```c
  struct tm
  {
      int tm_sec;    /* 代表目前秒数，正常范围为0-59，但允许至61秒 */
      int tm_min;    /* 代表目前分数，范围0-59 */
      int tm_hour;   /* 从午夜算起的时数，范围为0-23 */
      int tm_mday;   /* 目前月份的日数，范围01-31 */
      int tm_mon;    /* 代表目前月份，从一月算起，范围从0-11 */
      int tm_year;   /* 从1990年算起至今的年数 */
      int tm_wday;   /* 一星期的日数，从星期一算起，范围为0-6 */
      int tm_yday;   /* 从今年1月1日算起至今的天数，范围为0-365 */
      int tm_isdst;  /* 日光节约时间（夏令时）的标志 */
  };
  ```

  此函数返回的时间日期未经时区转换，而是 UTC 时间。

- 返回值：返回结构 tm 代表目前 UTC 时间。

- 相关函数：time,asctime,ctime,localtime

示例

```c
#include <stdio.h>
#include <time.h>

int main()
{
    char *wday[] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
    time_t timep;
    struct tm *p;
    time(&timep);
    p = gmtime(&timep);
    printf("%d-%02d-%02d ", (1900 + p->tm_year), (1 + p->tm_mon), p->tm_mday);
    printf("%s %02d:%02d:%02d\n", wday[p->tm_wday], p->tm_hour, p->tm_min, p->tm_sec);
    return 0;
}
```

执行

```shell
2021-06-20 Sun 05:46:51
```


localtime
---------------------------------------------

获取当地目前时间和日期

头文件 `#include <time.h>`

函数原型

```c
struct tm *localtime(const time_t *timep);
```

- 说明：localtime() 将参数 timep 所指的 time_t 结构中的信息转换成真实世界所使用的时间日期表示方法，然后将结果以 tm 结构体形式返回（结构体 tm 的定义请参考 gmtime）。此函数已经由时区转换成当地时间。
- 返回值：返回结构体 tm 代表目前的当地时间。
- 相关函数：time, asctime, ctime, gmtime

示例

```c
#include <stdio.h>
#include <time.h>

int main()
{
    char *wday[] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
    time_t timep;
    struct tm *p;
    time(&timep);
    p = localtime(&timep);  /* 获取当地时间 */
    printf("%d-%02d-%02d ", (1900 + p->tm_year), (1 + p->tm_mon), p->tm_mday);
    printf("%s %02d:%02d:%02d\n", wday[p->tm_wday], p->tm_hour, p->tm_min, p->tm_sec);
    return 0;
}
```

执行

```shell
2021-06-20 Sun 13:53:23
```


mktime
---------------------------------------------

将时间结构数据转换成经过的秒数

头文件 `#include <time.h>`

函数原型

```c
time_t mktime(struct tm *tm);
```

- 说明：mktime() 用来将参数 tm 所指的 tm 结构数据转换成从公元 1970年1月1日0时0分0秒算起至今的 UTC 时间所经过的秒数。
- 返回值：返回经过的秒数。
- 相关函数：time，asctime，gmtime，localtime

示例

```c
/* 用 time()取得时间（秒数），利用 localtime() 转换成 struct tm 
 * 再利用 mktine() 将 struct tm 转换成原来的秒数
 */
#include <stdio.h>
#include <time.h>

int main()
{
    time_t timep;
    struct tm *p;
    time(&timep);
    printf("time() : %ld \n", timep);
    p = localtime(&timep);
    timep = mktime(p);
    printf("time()->localtime()->mktime() : %ld\n", timep);
    return 0;
}
```

执行

```shell
time() : 1624168857
time()->localtime()->mktime() : 1624168857
```


settimeofday
---------------------------------------------

设置目前时间

头文件 `#include <sys/time.h>`

函数原型

```c
int settimeofday(const struct timeval *tv, const struct timezone *tz);
```

- 说明：settimeofday() 会把目前时间设成由 tv 所指的结构信息，当地时区信息则设成 tz 所指的结构。详细的说明请参考 gettimeofday()。注意，只有 root 权限才能使用此函数修改时间。
- 返回值：成功则返回 0，失败返回 -1，错误代码存于 errno。错误代码如下：
  - `EPERM` 权限不够，并非由 root 权限调用 settimeofday()；
  - `EINVAL` 时区或某个数据是不正确的，无法正确设置时间。
- 附加说明：
- 相关函数：time，ctime，ftime，gettimeofday


time
---------------------------------------------

获取目前的时间

头文件 `#include <time.h>`

函数原型

```c
time_t time(time_t *tloc);
```

- 说明：此函数会返回从公元 1970年1月1日0时0分0秒算起至今的 UTC 时间所经过的秒数。如果 tloc 并非空指针的话，此函数也会将返回值存到 tloc 指针所指的内存。
- 返回值：成功则返回描述，失败则返回 ((time_t)-1) 值，错误原因存于 errno 中。
- 相关函数：ctime，ftime，gettimeofday

示例

```c
#include <stdio.h>
#include <time.h>

int main()
{
    int seconds = time((time_t*)NULL);
    printf("%d\n", seconds);
    return 0;
}
```

执行

```shell
1624169441
```

