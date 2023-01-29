线程管理篇
=============================================

pthread_create
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                   void *(*start_routine) (void *), void *arg);

```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_join
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_join(pthread_t thread, void **retval);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_detach
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_detach(pthread_t thread);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_cancel
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_cancel(pthread_t thread);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_equal
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_equal(pthread_t t1, pthread_t t2);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_exit
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
void pthread_exit(void *retval);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_self
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
pthread_t pthread_self(void);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_attr_init
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_attr_init(pthread_attr_t *attr);
int pthread_attr_destroy(pthread_attr_t *attr);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_attr_destroy
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_attr_destroy(pthread_attr_t *attr);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


pthread_setattr_default_np
---------------------------------------------

简介

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_setattr_default_np(pthread_attr_t *attr);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


getrlimit
---------------------------------------------

简介

**头文件**

```c
#include <sys/time.h>
#include <sys/resource.h>
```

**函数原型**

```c
int getrlimit(int resource, struct rlimit *rlim);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```


prctl
---------------------------------------------

简介

**头文件**

```c
#include <sys/prctl.h>
```

**函数原型**

```c
int prctl(int option, unsigned long arg2, unsigned long arg3,
          unsigned long arg4, unsigned long arg5);
```

- 说明：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c

```

执行

```shell

```

