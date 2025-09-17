线程管理篇
=============================================

> pthread 库是 POSIX 线程库的简称，是一个提供创建和管理线程的 API 的跨平台标准，它允许开发者在支持 POSIX 标准的操作系统上进行多线程编程。

pthread_create
---------------------------------------------


创建一个新的线程。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                   void *(*start_routine) (void *), void *arg);
```

- 说明：创建一个新的线程，新线程从 start_routine 函数开始执行
- 返回值：成功返回 0，失败返回错误码
- 附加说明：新线程与调用线程并发执行
- 相关函数：pthread_join, pthread_detach, pthread_exit

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *thread_function(void *arg) {
    int *thread_id = (int *)arg;
    printf("线程 %d 正在执行\n", *thread_id);
    sleep(2);
    printf("线程 %d 执行完毕\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // 创建第一个线程
    if (pthread_create(&thread1, NULL, thread_function, &id1) != 0) {
        perror("pthread_create");
        return 1;
    }
    
    // 创建第二个线程
    if (pthread_create(&thread2, NULL, thread_function, &id2) != 0) {
        perror("pthread_create");
        return 1;
    }
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("所有线程执行完毕\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
线程 1 正在执行
线程 2 正在执行
线程 1 执行完毕
线程 2 执行完毕
所有线程执行完毕
```


pthread_join
---------------------------------------------

等待指定线程结束并获取其返回值。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_join(pthread_t thread, void **retval);
```

- 说明：阻塞调用线程，直到指定的线程结束，并获取线程的返回值
- 返回值：成功返回 0，失败返回错误码
- 附加说明：如果线程已经结束，函数立即返回
- 相关函数：pthread_create, pthread_detach, pthread_exit

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void *worker_thread(void *arg) {
    int *work_id = (int *)arg;
    printf("工作线程 %d 开始工作\n", *work_id);
    
    // 模拟工作
    sleep(3);
    
    // 分配返回值
    int *result = malloc(sizeof(int));
    *result = *work_id * 100;
    
    printf("工作线程 %d 完成工作，结果: %d\n", *work_id, *result);
    return result;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    void *result1, *result2;
    
    // 创建线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    
    printf("主线程等待工作线程完成...\n");
    
    // 等待线程结束并获取返回值
    pthread_join(thread1, &result1);
    pthread_join(thread2, &result2);
    
    printf("线程1结果: %d\n", *(int*)result1);
    printf("线程2结果: %d\n", *(int*)result2);
    
    // 释放内存
    free(result1);
    free(result2);
    
    printf("所有工作完成\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
工作线程 1 开始工作
工作线程 2 开始工作
主线程等待工作线程完成...
工作线程 1 完成工作，结果: 100
工作线程 2 完成工作，结果: 200
线程1结果: 100
线程2结果: 200
所有工作完成
```


pthread_detach
---------------------------------------------

将线程设置为分离状态，线程结束后自动回收资源。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_detach(pthread_t thread);
```

- 说明：将指定线程设置为分离状态，分离的线程结束后会自动回收资源
- 返回值：成功返回 0，失败返回错误码
- 附加说明：分离的线程不能使用 pthread_join 等待
- 相关函数：pthread_create, pthread_join, pthread_self

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *detached_thread(void *arg) {
    int *thread_id = (int *)arg;
    printf("分离线程 %d 开始执行\n", *thread_id);
    
    // 模拟工作
    for (int i = 0; i < 5; i++) {
        printf("分离线程 %d: 工作进度 %d/5\n", *thread_id, i + 1);
        sleep(1);
    }
    
    printf("分离线程 %d 执行完毕，将自动回收\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // 创建线程
    pthread_create(&thread1, NULL, detached_thread, &id1);
    pthread_create(&thread2, NULL, detached_thread, &id2);
    
    // 将线程设置为分离状态
    pthread_detach(thread1);
    pthread_detach(thread2);
    
    printf("主线程：已设置线程为分离状态\n");
    printf("主线程：等待分离线程完成...\n");
    
    // 等待一段时间让分离线程完成
    sleep(6);
    
    printf("主线程：程序结束\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
分离线程 1 开始执行
分离线程 2 开始执行
主线程：已设置线程为分离状态
主线程：等待分离线程完成...
分离线程 1: 工作进度 1/5
分离线程 2: 工作进度 1/5
分离线程 1: 工作进度 2/5
分离线程 2: 工作进度 2/5
分离线程 1: 工作进度 3/5
分离线程 2: 工作进度 3/5
分离线程 1: 工作进度 4/5
分离线程 2: 工作进度 4/5
分离线程 1: 工作进度 5/5
分离线程 2: 工作进度 5/5
分离线程 1 执行完毕，将自动回收
分离线程 2 执行完毕，将自动回收
主线程：程序结束
```


pthread_cancel
---------------------------------------------

请求取消指定线程的执行。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_cancel(pthread_t thread);
```

- 说明：向指定线程发送取消请求，线程会在下一个取消点检查并处理取消请求
- 返回值：成功返回 0，失败返回错误码
- 附加说明：线程必须设置取消状态和类型才能被取消
- 相关函数：pthread_setcancelstate, pthread_setcanceltype, pthread_testcancel

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

void *cancellable_thread(void *arg) {
    int *thread_id = (int *)arg;
    printf("线程 %d 开始执行\n", *thread_id);
    
    // 设置线程可被取消
    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
    pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
    
    for (int i = 0; i < 10; i++) {
        // 检查取消请求
        pthread_testcancel();
        
        printf("线程 %d: 工作进度 %d/10\n", *thread_id, i + 1);
        sleep(1);
    }
    
    printf("线程 %d 正常完成\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // 创建线程
    pthread_create(&thread1, NULL, cancellable_thread, &id1);
    pthread_create(&thread2, NULL, cancellable_thread, &id2);
    
    // 等待一段时间
    sleep(3);
    
    printf("主线程：取消线程1\n");
    pthread_cancel(thread1);
    
    // 等待线程2继续执行
    sleep(2);
    
    printf("主线程：取消线程2\n");
    pthread_cancel(thread2);
    
    // 等待线程结束
    void *result1, *result2;
    pthread_join(thread1, &result1);
    pthread_join(thread2, &result2);
    
    if (result1 == PTHREAD_CANCELED) {
        printf("线程1被成功取消\n");
    }
    if (result2 == PTHREAD_CANCELED) {
        printf("线程2被成功取消\n");
    }
    
    printf("程序结束\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
线程 1 开始执行
线程 2 开始执行
线程 1: 工作进度 1/10
线程 2: 工作进度 1/10
线程 1: 工作进度 2/10
线程 2: 工作进度 2/10
线程 1: 工作进度 3/10
线程 2: 工作进度 3/10
主线程：取消线程1
线程 2: 工作进度 4/10
线程 2: 工作进度 5/10
主线程：取消线程2
线程1被成功取消
线程2被成功取消
程序结束
```


pthread_equal
---------------------------------------------

比较两个线程ID是否相等。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_equal(pthread_t t1, pthread_t t2);
```

- 说明：比较两个线程ID是否相等
- 返回值：相等返回非零值，不相等返回 0
- 附加说明：不能使用 == 操作符直接比较 pthread_t
- 相关函数：pthread_self, pthread_create

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *worker_thread(void *arg) {
    pthread_t self = pthread_self();
    int *thread_id = (int *)arg;
    
    printf("线程 %d: 我的线程ID是 %lu\n", *thread_id, (unsigned long)self);
    
    // 模拟工作
    sleep(2);
    
    printf("线程 %d 完成工作\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2, main_thread;
    int id1 = 1, id2 = 2;
    
    main_thread = pthread_self();
    printf("主线程ID: %lu\n", (unsigned long)main_thread);
    
    // 创建线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    
    // 比较线程ID
    if (pthread_equal(thread1, thread2)) {
        printf("线程1和线程2的ID相同\n");
    } else {
        printf("线程1和线程2的ID不同\n");
    }
    
    if (pthread_equal(thread1, main_thread)) {
        printf("线程1和主线程的ID相同\n");
    } else {
        printf("线程1和主线程的ID不同\n");
    }
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("程序结束\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
主线程ID: 140123456789248
线程 1: 我的线程ID是 140123456789248
线程 2: 我的线程ID是 140123456789248
线程1和线程2的ID不同
线程1和主线程的ID不同
线程 1 完成工作
线程 2 完成工作
程序结束
```


pthread_exit
---------------------------------------------

终止当前线程并返回一个值。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
void pthread_exit(void *retval);
```

- 说明：终止调用线程的执行，retval 作为线程的返回值
- 返回值：无返回值（函数不返回）
- 附加说明：相当于线程的 return 语句，但可以返回指针
- 相关函数：pthread_join, pthread_create

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void *early_exit_thread(void *arg) {
    int *thread_id = (int *)arg;
    printf("线程 %d 开始执行\n", *thread_id);
    
    // 模拟一些工作
    for (int i = 0; i < 3; i++) {
        printf("线程 %d: 工作进度 %d/5\n", *thread_id, i + 1);
        sleep(1);
    }
    
    // 提前退出线程
    printf("线程 %d 提前退出\n", *thread_id);
    
    // 分配返回值
    int *result = malloc(sizeof(int));
    *result = *thread_id * 100;
    
    pthread_exit(result);
    
    // 这行代码不会执行
    printf("这行代码不会执行\n");
    return NULL;
}

void *normal_exit_thread(void *arg) {
    int *thread_id = (int *)arg;
    printf("线程 %d 开始执行\n", *thread_id);
    
    // 完成所有工作
    for (int i = 0; i < 5; i++) {
        printf("线程 %d: 工作进度 %d/5\n", *thread_id, i + 1);
        sleep(1);
    }
    
    printf("线程 %d 正常完成\n", *thread_id);
    
    // 正常返回
    int *result = malloc(sizeof(int));
    *result = *thread_id * 200;
    return result;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    void *result1, *result2;
    
    // 创建线程
    pthread_create(&thread1, NULL, early_exit_thread, &id1);
    pthread_create(&thread2, NULL, normal_exit_thread, &id2);
    
    // 等待线程结束
    pthread_join(thread1, &result1);
    pthread_join(thread2, &result2);
    
    printf("线程1返回值: %d\n", *(int*)result1);
    printf("线程2返回值: %d\n", *(int*)result2);
    
    // 释放内存
    free(result1);
    free(result2);
    
    printf("程序结束\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
线程 1 开始执行
线程 2 开始执行
线程 1: 工作进度 1/5
线程 2: 工作进度 1/5
线程 1: 工作进度 2/5
线程 2: 工作进度 2/5
线程 1: 工作进度 3/5
线程 2: 工作进度 3/5
线程 1 提前退出
线程 2: 工作进度 4/5
线程 2: 工作进度 5/5
线程 2 正常完成
线程1返回值: 100
线程2返回值: 400
程序结束
```


pthread_self
---------------------------------------------

获取当前线程的线程ID。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
pthread_t pthread_self(void);
```

- 说明：返回调用线程的线程ID
- 返回值：当前线程的线程ID
- 附加说明：每个线程都有唯一的线程ID
- 相关函数：pthread_equal, pthread_create

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *worker_thread(void *arg) {
    pthread_t self = pthread_self();
    int *thread_id = (int *)arg;
    
    printf("工作线程 %d: 我的线程ID是 %lu\n", *thread_id, (unsigned long)self);
    
    // 模拟工作
    for (int i = 0; i < 3; i++) {
        printf("工作线程 %d: 正在处理任务 %d\n", *thread_id, i + 1);
        sleep(1);
    }
    
    printf("工作线程 %d 完成工作\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t main_thread = pthread_self();
    printf("主线程ID: %lu\n", (unsigned long)main_thread);
    
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // 创建线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    
    printf("主线程: 创建了线程1和线程2\n");
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("主线程: 所有工作线程已完成\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
主线程ID: 140123456789248
工作线程 1: 我的线程ID是 140123456789248
工作线程 2: 我的线程ID是 140123456789248
主线程: 创建了线程1和线程2
工作线程 1: 正在处理任务 1
工作线程 2: 正在处理任务 1
工作线程 1: 正在处理任务 2
工作线程 2: 正在处理任务 2
工作线程 1: 正在处理任务 3
工作线程 2: 正在处理任务 3
工作线程 1 完成工作
工作线程 2 完成工作
主线程: 所有工作线程已完成
```


pthread_attr_init
---------------------------------------------

初始化线程属性对象。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_attr_init(pthread_attr_t *attr);
```

- 说明：初始化线程属性对象，设置默认值
- 返回值：成功返回 0，失败返回错误码
- 附加说明：使用前必须初始化，使用后需要销毁
- 相关函数：pthread_attr_destroy, pthread_create

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *thread_function(void *arg) {
    int *thread_id = (int *)arg;
    printf("线程 %d 开始执行\n", *thread_id);
    sleep(2);
    printf("线程 %d 执行完毕\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    pthread_attr_t attr;
    int id1 = 1, id2 = 2;
    
    // 初始化线程属性
    if (pthread_attr_init(&attr) != 0) {
        perror("pthread_attr_init");
        return 1;
    }
    
    printf("线程属性初始化成功\n");
    
    // 使用自定义属性创建线程
    if (pthread_create(&thread1, &attr, thread_function, &id1) != 0) {
        perror("pthread_create");
        pthread_attr_destroy(&attr);
        return 1;
    }
    
    // 使用默认属性创建线程
    if (pthread_create(&thread2, NULL, thread_function, &id2) != 0) {
        perror("pthread_create");
        pthread_attr_destroy(&attr);
        return 1;
    }
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    // 销毁线程属性
    pthread_attr_destroy(&attr);
    
    printf("所有线程执行完毕\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
线程属性初始化成功
线程 1 开始执行
线程 2 开始执行
线程 1 执行完毕
线程 2 执行完毕
所有线程执行完毕
```


pthread_attr_destroy
---------------------------------------------

销毁线程属性对象。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_attr_destroy(pthread_attr_t *attr);
```

- 说明：销毁线程属性对象，释放相关资源
- 返回值：成功返回 0，失败返回错误码
- 附加说明：销毁后属性对象不能再使用，需要重新初始化
- 相关函数：pthread_attr_init, pthread_create

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *worker_thread(void *arg) {
    int *thread_id = (int *)arg;
    printf("工作线程 %d 开始执行\n", *thread_id);
    sleep(1);
    printf("工作线程 %d 执行完毕\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    pthread_attr_t attr;
    int id1 = 1, id2 = 2;
    
    // 初始化线程属性
    if (pthread_attr_init(&attr) != 0) {
        perror("pthread_attr_init");
        return 1;
    }
    
    printf("线程属性初始化成功\n");
    
    // 创建线程
    if (pthread_create(&thread1, &attr, worker_thread, &id1) != 0) {
        perror("pthread_create");
        pthread_attr_destroy(&attr);
        return 1;
    }
    
    if (pthread_create(&thread2, &attr, worker_thread, &id2) != 0) {
        perror("pthread_create");
        pthread_attr_destroy(&attr);
        return 1;
    }
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("所有线程执行完毕，准备销毁属性对象\n");
    
    // 销毁线程属性
    if (pthread_attr_destroy(&attr) != 0) {
        perror("pthread_attr_destroy");
        return 1;
    }
    
    printf("线程属性销毁成功\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
线程属性初始化成功
工作线程 1 开始执行
工作线程 2 开始执行
工作线程 1 执行完毕
工作线程 2 执行完毕
所有线程执行完毕，准备销毁属性对象
线程属性销毁成功
```


pthread_setattr_default_np
---------------------------------------------

设置线程的默认属性。

**头文件**

```c
#include <pthread.h>
```

**函数原型**

```c
int pthread_setattr_default_np(pthread_attr_t *attr);
```

- 说明：设置线程的默认属性，影响后续创建的线程
- 返回值：成功返回 0，失败返回错误码
- 附加说明：这是一个非标准函数，仅在特定系统上可用
- 相关函数：pthread_attr_init, pthread_create

**示例**

```c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void *default_thread(void *arg) {
    int *thread_id = (int *)arg;
    printf("默认属性线程 %d 开始执行\n", *thread_id);
    sleep(1);
    printf("默认属性线程 %d 执行完毕\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    pthread_attr_t attr;
    int id1 = 1, id2 = 2;
    
    // 初始化线程属性
    if (pthread_attr_init(&attr) != 0) {
        perror("pthread_attr_init");
        return 1;
    }
    
    printf("设置默认线程属性\n");
    
    // 设置默认属性（如果系统支持）
    if (pthread_setattr_default_np(&attr) != 0) {
        printf("警告：pthread_setattr_default_np 不支持，使用默认属性\n");
    } else {
        printf("默认线程属性设置成功\n");
    }
    
    // 创建线程（将使用设置的默认属性）
    if (pthread_create(&thread1, NULL, default_thread, &id1) != 0) {
        perror("pthread_create");
        pthread_attr_destroy(&attr);
        return 1;
    }
    
    if (pthread_create(&thread2, NULL, default_thread, &id2) != 0) {
        perror("pthread_create");
        pthread_attr_destroy(&attr);
        return 1;
    }
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    // 销毁线程属性
    pthread_attr_destroy(&attr);
    
    printf("所有线程执行完毕\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
设置默认线程属性
警告：pthread_setattr_default_np 不支持，使用默认属性
默认属性线程 1 开始执行
默认属性线程 2 开始执行
默认属性线程 1 执行完毕
默认属性线程 2 执行完毕
所有线程执行完毕
```


getrlimit
---------------------------------------------

获取进程资源限制。

**头文件**

```c
#include <sys/time.h>
#include <sys/resource.h>
```

**函数原型**

```c
int getrlimit(int resource, struct rlimit *rlim);
```

- 说明：获取指定资源的软限制和硬限制
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：rlimit 结构体包含 rlim_cur（软限制）和 rlim_max（硬限制）
- 相关函数：setrlimit, prlimit

**rlimit 结构体**

```c
struct rlimit {
    rlim_t rlim_cur;  /* 软限制 */
    rlim_t rlim_max;  /* 硬限制 */
};
```

**示例**

```c
#include <stdio.h>
#include <sys/resource.h>
#include <unistd.h>

void print_rlimit(int resource, const char *name) {
    struct rlimit rlim;
    
    if (getrlimit(resource, &rlim) == 0) {
        printf("%s:\n", name);
        printf("  软限制: %lu\n", (unsigned long)rlim.rlim_cur);
        printf("  硬限制: %lu\n", (unsigned long)rlim.rlim_max);
        printf("\n");
    } else {
        perror("getrlimit");
    }
}

int main() {
    printf("当前进程资源限制:\n");
    printf("==================\n");
    
    // 获取各种资源限制
    print_rlimit(RLIMIT_CPU, "CPU时间限制（秒）");
    print_rlimit(RLIMIT_FSIZE, "文件大小限制（字节）");
    print_rlimit(RLIMIT_DATA, "数据段大小限制（字节）");
    print_rlimit(RLIMIT_STACK, "栈大小限制（字节）");
    print_rlimit(RLIMIT_CORE, "核心转储文件大小限制（字节）");
    print_rlimit(RLIMIT_NOFILE, "文件描述符数量限制");
    print_rlimit(RLIMIT_AS, "虚拟内存大小限制（字节）");
    
    printf("进程ID: %d\n", getpid());
    printf("父进程ID: %d\n", getppid());
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example
$ ./example
当前进程资源限制:
==================
CPU时间限制（秒）:
  软限制: 18446744073709551615
  硬限制: 18446744073709551615

文件大小限制（字节）:
  软限制: 18446744073709551615
  硬限制: 18446744073709551615

数据段大小限制（字节）:
  软限制: 18446744073709551615
  硬限制: 18446744073709551615

栈大小限制（字节）:
  软限制: 8388608
  硬限制: 18446744073709551615

核心转储文件大小限制（字节）:
  软限制: 0
  硬限制: 18446744073709551615

文件描述符数量限制:
  软限制: 1024
  硬限制: 1048576

虚拟内存大小限制（字节）:
  软限制: 18446744073709551615
  硬限制: 18446744073709551615

进程ID: 12345
父进程ID: 1234
```


prctl
---------------------------------------------

进程控制操作。

**头文件**

```c
#include <sys/prctl.h>
```

**函数原型**

```c
int prctl(int option, unsigned long arg2, unsigned long arg3,
          unsigned long arg4, unsigned long arg5);
```

- 说明：对进程进行各种控制操作，如设置进程名、线程名等
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：这是一个Linux特有的系统调用，功能强大
- 相关函数：pthread_setname_np, getpid

**常用选项**

- `PR_SET_NAME`: 设置进程名
- `PR_GET_NAME`: 获取进程名
- `PR_SET_PDEATHSIG`: 设置父进程死亡信号
- `PR_GET_PDEATHSIG`: 获取父进程死亡信号

**示例**

```c
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>

void *thread_function(void *arg) {
    int *thread_id = (int *)arg;
    char thread_name[16];
    
    // 设置线程名
    snprintf(thread_name, sizeof(thread_name), "Worker-%d", *thread_id);
    prctl(PR_SET_NAME, (unsigned long)thread_name, 0, 0, 0);
    
    // 获取并显示线程名
    char current_name[16];
    prctl(PR_GET_NAME, (unsigned long)current_name, 0, 0, 0);
    printf("线程 %d 名称: %s\n", *thread_id, current_name);
    
    sleep(2);
    printf("线程 %d 执行完毕\n", *thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    char process_name[16];
    
    // 设置进程名
    prctl(PR_SET_NAME, (unsigned long)"MyProcess", 0, 0, 0);
    
    // 获取并显示进程名
    prctl(PR_GET_NAME, (unsigned long)process_name, 0, 0, 0);
    printf("进程名: %s\n", process_name);
    printf("进程ID: %d\n", getpid());
    
    // 创建线程
    pthread_create(&thread1, NULL, thread_function, &id1);
    pthread_create(&thread2, NULL, thread_function, &id2);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("所有线程执行完毕\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
进程名: MyProcess
进程ID: 12345
线程 1 名称: Worker-1
线程 2 名称: Worker-2
线程 1 执行完毕
线程 2 执行完毕
所有线程执行完毕
```

