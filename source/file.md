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

