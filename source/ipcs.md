进程间通信篇
=============================================

sem_init
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_init(sem_t *sem, int pshared, unsigned int value);
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


sem_destroy
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_destroy(sem_t *sem);
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


sem_open
---------------------------------------------

简介

头文件

```c
#include <fcntl.h>           /* For O_* constants */
#include <sys/stat.h>        /* For mode constants */
#include <semaphore.h>
```

函数原型

```c
sem_t *sem_open(const char *name, int oflag);
sem_t *sem_open(const char *name, int oflag, mode_t mode, unsigned int value);
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


sem_close
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_close(sem_t *sem);
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


sem_getvalue
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_getvalue(sem_t *sem, int *sval);
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



sem_post
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_post(sem_t *sem);
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


sem_overview
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_init(sem_t *sem, int pshared, unsigned int value);
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


sem_wait
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_wait(sem_t *sem);
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

sem_trywait
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_trywait(sem_t *sem);
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

sem_timedwait
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);
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


sem_unlink
---------------------------------------------

简介

头文件 `#include <semaphore.h>`

函数原型

```c
int sem_unlink(const char *name);
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
