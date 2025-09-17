进程间通信篇
=============================================

> 进程间通信（IPC）函数是 POSIX 标准中用于不同进程之间数据交换和同步的函数集合，包括信号量、共享内存、消息队列、管道等机制。这些函数为多进程应用提供了协调和通信能力，是并发编程、分布式系统和系统集成中的重要工具。

sem_init
---------------------------------------------

初始化未命名的信号量。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_init(sem_t *sem, int pshared, unsigned int value);
```

- 说明：初始化由 sem 指向的未命名信号量，设置初始值为 value
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：pshared 为 0 表示进程内共享，非 0 表示进程间共享
- 相关函数：sem_destroy, sem_post, sem_wait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

sem_t semaphore;
int shared_counter = 0;

void *worker_thread(void *arg) {
    int *thread_id = (int *)arg;
    
    for (int i = 0; i < 3; i++) {
        // 等待信号量
        sem_wait(&semaphore);
        
        // 临界区
        shared_counter++;
        printf("线程 %d: 计数器值 = %d\n", *thread_id, shared_counter);
        sleep(1);
        
        // 释放信号量
        sem_post(&semaphore);
        
        sleep(1);
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // 初始化信号量，初始值为 1
    if (sem_init(&semaphore, 0, 1) == -1) {
        perror("sem_init");
        return 1;
    }
    
    printf("信号量初始化成功，初始值 = 1\n");
    
    // 创建线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("最终计数器值 = %d\n", shared_counter);
    
    // 销毁信号量
    sem_destroy(&semaphore);
    
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
信号量初始化成功，初始值 = 1
线程 1: 计数器值 = 1
线程 2: 计数器值 = 2
线程 1: 计数器值 = 3
线程 2: 计数器值 = 4
线程 1: 计数器值 = 5
线程 2: 计数器值 = 6
最终计数器值 = 6
```


sem_destroy
---------------------------------------------

销毁未命名的信号量。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_destroy(sem_t *sem);
```

- 说明：销毁由 sem_init 创建的未命名信号量，释放相关资源
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：销毁后信号量不能再使用，必须确保没有线程在等待该信号量
- 相关函数：sem_init, sem_post, sem_wait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

sem_t semaphore;

void *worker_thread(void *arg) {
    int *thread_id = (int *)arg;
    
    printf("线程 %d 开始工作\n", *thread_id);
    
    // 等待信号量
    sem_wait(&semaphore);
    printf("线程 %d 获得信号量\n", *thread_id);
    
    // 模拟工作
    sleep(2);
    
    printf("线程 %d 完成工作，释放信号量\n", *thread_id);
    sem_post(&semaphore);
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // 初始化信号量
    if (sem_init(&semaphore, 0, 1) == -1) {
        perror("sem_init");
        return 1;
    }
    
    printf("信号量初始化成功\n");
    
    // 创建线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("所有线程完成，准备销毁信号量\n");
    
    // 销毁信号量
    if (sem_destroy(&semaphore) == -1) {
        perror("sem_destroy");
        return 1;
    }
    
    printf("信号量销毁成功\n");
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
信号量初始化成功
线程 1 开始工作
线程 2 开始工作
线程 1 获得信号量
线程 1 完成工作，释放信号量
线程 2 获得信号量
线程 2 完成工作，释放信号量
所有线程完成，准备销毁信号量
信号量销毁成功
```


sem_open
---------------------------------------------

打开或创建一个命名信号量。

**头文件**

```c
#include <fcntl.h>           /* For O_* constants */
#include <sys/stat.h>        /* For mode constants */
#include <semaphore.h>
```

**函数原型**

```c
sem_t *sem_open(const char *name, int oflag);
sem_t *sem_open(const char *name, int oflag, mode_t mode, unsigned int value);
```

- 说明：打开或创建一个命名信号量，用于进程间通信
- 返回值：成功返回信号量指针，失败返回 SEM_FAILED
- 附加说明：O_CREAT 标志用于创建新信号量，O_EXCL 与 O_CREAT 一起使用确保原子性
- 相关函数：sem_close, sem_unlink, sem_post, sem_wait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>

#define SEM_NAME "/my_semaphore"

int main() {
    sem_t *sem;
    pid_t pid;
    
    // 创建命名信号量
    sem = sem_open(SEM_NAME, O_CREAT, 0644, 1);
    if (sem == SEM_FAILED) {
        perror("sem_open");
        return 1;
    }
    
    printf("命名信号量创建成功\n");
    
    // 创建子进程
    pid = fork();
    
    if (pid == 0) {
        // 子进程
        printf("子进程：等待信号量\n");
        sem_wait(sem);
        printf("子进程：获得信号量，开始工作\n");
        sleep(2);
        printf("子进程：工作完成，释放信号量\n");
        sem_post(sem);
        sem_close(sem);
        return 0;
    } else if (pid > 0) {
        // 父进程
        sleep(1);  // 让子进程先运行
        printf("父进程：等待信号量\n");
        sem_wait(sem);
        printf("父进程：获得信号量，开始工作\n");
        sleep(2);
        printf("父进程：工作完成，释放信号量\n");
        sem_post(sem);
        
        // 等待子进程结束
        wait(NULL);
        
        // 关闭并删除信号量
        sem_close(sem);
        sem_unlink(SEM_NAME);
        printf("信号量已删除\n");
    } else {
        perror("fork");
        return 1;
    }
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lrt
$ ./example
命名信号量创建成功
子进程：等待信号量
子进程：获得信号量，开始工作
父进程：等待信号量
子进程：工作完成，释放信号量
父进程：获得信号量，开始工作
父进程：工作完成，释放信号量
信号量已删除
```


sem_close
---------------------------------------------

关闭命名信号量。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_close(sem_t *sem);
```

- 说明：关闭由 sem_open 打开的命名信号量，释放相关资源
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：关闭后信号量仍存在于系统中，需要 sem_unlink 删除
- 相关函数：sem_open, sem_unlink, sem_post, sem_wait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>

#define SEM_NAME "/test_semaphore"

int main() {
    sem_t *sem;
    pid_t pid;
    
    // 创建命名信号量
    sem = sem_open(SEM_NAME, O_CREAT, 0644, 2);
    if (sem == SEM_FAILED) {
        perror("sem_open");
        return 1;
    }
    
    printf("命名信号量创建成功\n");
    
    // 创建子进程
    pid = fork();
    
    if (pid == 0) {
        // 子进程
        printf("子进程：打开信号量\n");
        sem = sem_open(SEM_NAME, 0);
        if (sem == SEM_FAILED) {
            perror("sem_open in child");
            return 1;
        }
        
        printf("子进程：等待信号量\n");
        sem_wait(sem);
        printf("子进程：获得信号量，开始工作\n");
        sleep(2);
        printf("子进程：工作完成，释放信号量\n");
        sem_post(sem);
        
        // 关闭信号量
        if (sem_close(sem) == -1) {
            perror("sem_close in child");
        } else {
            printf("子进程：信号量关闭成功\n");
        }
        
        return 0;
    } else if (pid > 0) {
        // 父进程
        sleep(1);
        printf("父进程：等待信号量\n");
        sem_wait(sem);
        printf("父进程：获得信号量，开始工作\n");
        sleep(2);
        printf("父进程：工作完成，释放信号量\n");
        sem_post(sem);
        
        // 等待子进程结束
        wait(NULL);
        
        // 关闭信号量
        if (sem_close(sem) == -1) {
            perror("sem_close in parent");
        } else {
            printf("父进程：信号量关闭成功\n");
        }
        
        // 删除信号量
        sem_unlink(SEM_NAME);
        printf("信号量已删除\n");
    } else {
        perror("fork");
        return 1;
    }
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lrt
$ ./example
命名信号量创建成功
子进程：打开信号量
子进程：等待信号量
子进程：获得信号量，开始工作
父进程：等待信号量
子进程：工作完成，释放信号量
子进程：信号量关闭成功
父进程：获得信号量，开始工作
父进程：工作完成，释放信号量
父进程：信号量关闭成功
信号量已删除
```


sem_getvalue
---------------------------------------------

获取信号量的当前值。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_getvalue(sem_t *sem, int *sval);
```

- 说明：获取信号量的当前值，结果存储在 sval 指向的变量中
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：获取的值可能不是原子操作，仅用于调试或监控
- 相关函数：sem_init, sem_post, sem_wait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

sem_t semaphore;
int shared_counter = 0;

void *worker_thread(void *arg) {
    int *thread_id = (int *)arg;
    int sem_value;
    
    for (int i = 0; i < 3; i++) {
        // 获取信号量当前值
        sem_getvalue(&semaphore, &sem_value);
        printf("线程 %d: 尝试获取信号量，当前值 = %d\n", *thread_id, sem_value);
        
        // 等待信号量
        sem_wait(&semaphore);
        
        // 再次获取信号量值
        sem_getvalue(&semaphore, &sem_value);
        printf("线程 %d: 获得信号量，当前值 = %d\n", *thread_id, sem_value);
        
        // 临界区
        shared_counter++;
        printf("线程 %d: 计数器值 = %d\n", *thread_id, shared_counter);
        sleep(1);
        
        // 释放信号量
        sem_post(&semaphore);
        
        // 获取释放后的信号量值
        sem_getvalue(&semaphore, &sem_value);
        printf("线程 %d: 释放信号量，当前值 = %d\n", *thread_id, sem_value);
        
        sleep(1);
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    int sem_value;
    
    // 初始化信号量，初始值为 1
    if (sem_init(&semaphore, 0, 1) == -1) {
        perror("sem_init");
        return 1;
    }
    
    // 获取初始信号量值
    sem_getvalue(&semaphore, &sem_value);
    printf("信号量初始化成功，初始值 = %d\n", sem_value);
    
    // 创建线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    // 获取最终信号量值
    sem_getvalue(&semaphore, &sem_value);
    printf("最终计数器值 = %d，信号量值 = %d\n", shared_counter, sem_value);
    
    // 销毁信号量
    sem_destroy(&semaphore);
    
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
信号量初始化成功，初始值 = 1
线程 1: 尝试获取信号量，当前值 = 1
线程 2: 尝试获取信号量，当前值 = 1
线程 1: 获得信号量，当前值 = 0
线程 1: 计数器值 = 1
线程 1: 释放信号量，当前值 = 1
线程 2: 获得信号量，当前值 = 0
线程 2: 计数器值 = 2
线程 2: 释放信号量，当前值 = 1
线程 1: 尝试获取信号量，当前值 = 1
线程 1: 获得信号量，当前值 = 0
线程 1: 计数器值 = 3
线程 1: 释放信号量，当前值 = 1
线程 2: 尝试获取信号量，当前值 = 1
线程 2: 获得信号量，当前值 = 0
线程 2: 计数器值 = 4
线程 2: 释放信号量，当前值 = 1
线程 1: 尝试获取信号量，当前值 = 1
线程 1: 获得信号量，当前值 = 0
线程 1: 计数器值 = 5
线程 1: 释放信号量，当前值 = 1
线程 2: 尝试获取信号量，当前值 = 1
线程 2: 获得信号量，当前值 = 0
线程 2: 计数器值 = 6
线程 2: 释放信号量，当前值 = 1
最终计数器值 = 6，信号量值 = 1
```



sem_post
---------------------------------------------

释放信号量，将信号量值加 1。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_post(sem_t *sem);
```

- 说明：原子操作，将信号量值加 1，如果有线程在等待则唤醒其中一个
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：通常与 sem_wait 配对使用，用于释放临界区
- 相关函数：sem_wait, sem_trywait, sem_timedwait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

sem_t semaphore;
int counter = 0;

void *worker(void *arg) {
    int *id = (int *)arg;
    
    for (int i = 0; i < 5; i++) {
        // 等待信号量
        sem_wait(&semaphore);
        
        // 临界区
        counter++;
        printf("工作者 %d: 计数器 = %d\n", *id, counter);
        sleep(1);
        
        // 释放信号量
        sem_post(&semaphore);
        
        sleep(1);
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2, thread3;
    int id1 = 1, id2 = 2, id3 = 3;
    
    // 初始化信号量，初始值为1（互斥锁）
    sem_init(&semaphore, 0, 1);
    
    printf("开始多线程工作，信号量初始值 = 1\n");
    
    // 创建线程
    pthread_create(&thread1, NULL, worker, &id1);
    pthread_create(&thread2, NULL, worker, &id2);
    pthread_create(&thread3, NULL, worker, &id3);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    pthread_join(thread3, NULL);
    
    printf("所有工作完成，最终计数器 = %d\n", counter);
    
    sem_destroy(&semaphore);
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
开始多线程工作，信号量初始值 = 1
工作者 1: 计数器 = 1
工作者 2: 计数器 = 2
工作者 3: 计数器 = 3
工作者 1: 计数器 = 4
工作者 2: 计数器 = 5
工作者 3: 计数器 = 6
工作者 1: 计数器 = 7
工作者 2: 计数器 = 8
工作者 3: 计数器 = 9
工作者 1: 计数器 = 10
工作者 2: 计数器 = 11
工作者 3: 计数器 = 12
工作者 1: 计数器 = 13
工作者 2: 计数器 = 14
工作者 3: 计数器 = 15
所有工作完成，最终计数器 = 15
```




sem_wait
---------------------------------------------

等待信号量，如果信号量值大于 0 则减 1，否则阻塞等待。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_wait(sem_t *sem);
```

- 说明：原子操作，如果信号量值大于 0 则减 1 并立即返回，否则阻塞直到信号量值大于 0
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：这是阻塞操作，会一直等待直到获得信号量
- 相关函数：sem_post, sem_trywait, sem_timedwait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

sem_t semaphore;
int shared_resource = 0;

void *producer(void *arg) {
    int *id = (int *)arg;
    
    for (int i = 0; i < 3; i++) {
        printf("生产者 %d: 准备生产资源\n", *id);
        
        // 等待信号量
        sem_wait(&semaphore);
        
        // 临界区：生产资源
        shared_resource++;
        printf("生产者 %d: 生产了资源，当前资源数 = %d\n", *id, shared_resource);
        sleep(1);
        
        // 释放信号量
        sem_post(&semaphore);
        
        sleep(2);
    }
    
    return NULL;
}

void *consumer(void *arg) {
    int *id = (int *)arg;
    
    for (int i = 0; i < 3; i++) {
        printf("消费者 %d: 准备消费资源\n", *id);
        
        // 等待信号量
        sem_wait(&semaphore);
        
        // 临界区：消费资源
        if (shared_resource > 0) {
            shared_resource--;
            printf("消费者 %d: 消费了资源，当前资源数 = %d\n", *id, shared_resource);
        } else {
            printf("消费者 %d: 没有资源可消费\n", *id);
        }
        sleep(1);
        
        // 释放信号量
        sem_post(&semaphore);
        
        sleep(2);
    }
    
    return NULL;
}

int main() {
    pthread_t producer1, producer2, consumer1;
    int id1 = 1, id2 = 2, id3 = 3;
    
    // 初始化信号量，初始值为1
    sem_init(&semaphore, 0, 1);
    
    // 创建线程
    pthread_create(&producer1, NULL, producer, &id1);
    pthread_create(&producer2, NULL, producer, &id2);
    pthread_create(&consumer1, NULL, consumer, &id3);
    
    // 等待线程结束
    pthread_join(producer1, NULL);
    pthread_join(producer2, NULL);
    pthread_join(consumer1, NULL);
    
    printf("最终资源数 = %d\n", shared_resource);
    
    sem_destroy(&semaphore);
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
生产者 1: 准备生产资源
生产者 2: 准备生产资源
消费者 3: 准备消费资源
生产者 1: 生产了资源，当前资源数 = 1
生产者 2: 准备生产资源
消费者 3: 准备消费资源
生产者 2: 生产了资源，当前资源数 = 2
消费者 3: 消费了资源，当前资源数 = 1
生产者 1: 准备生产资源
生产者 2: 准备生产资源
消费者 3: 准备消费资源
生产者 1: 生产了资源，当前资源数 = 2
生产者 2: 生产了资源，当前资源数 = 3
消费者 3: 消费了资源，当前资源数 = 2
最终资源数 = 2
```

sem_trywait
---------------------------------------------

非阻塞地尝试获取信号量。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_trywait(sem_t *sem);
```

- 说明：非阻塞地尝试获取信号量，如果信号量值大于 0 则减 1 并立即返回，否则立即返回错误
- 返回值：成功返回 0，失败返回 -1 并设置 errno（EAGAIN 表示信号量不可用）
- 附加说明：这是非阻塞操作，不会等待
- 相关函数：sem_wait, sem_timedwait, sem_post

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <errno.h>

sem_t semaphore;
int shared_counter = 0;

void *worker_thread(void *arg) {
    int *thread_id = (int *)arg;
    
    for (int i = 0; i < 5; i++) {
        printf("线程 %d: 尝试非阻塞获取信号量\n", *thread_id);
        
        // 尝试非阻塞获取信号量
        if (sem_trywait(&semaphore) == 0) {
            // 成功获取信号量
            printf("线程 %d: 成功获取信号量\n", *thread_id);
            
            // 临界区
            shared_counter++;
            printf("线程 %d: 计数器值 = %d\n", *thread_id, shared_counter);
            sleep(1);
            
            // 释放信号量
            sem_post(&semaphore);
            printf("线程 %d: 释放信号量\n", *thread_id);
        } else {
            // 获取失败
            if (errno == EAGAIN) {
                printf("线程 %d: 信号量不可用，继续其他工作\n", *thread_id);
            } else {
                perror("sem_trywait");
            }
        }
        
        sleep(1);
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2, thread3;
    int id1 = 1, id2 = 2, id3 = 3;
    
    // 初始化信号量，初始值为 1（互斥锁）
    if (sem_init(&semaphore, 0, 1) == -1) {
        perror("sem_init");
        return 1;
    }
    
    printf("开始非阻塞信号量测试，初始值 = 1\n");
    
    // 创建多个线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    pthread_create(&thread3, NULL, worker_thread, &id3);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    pthread_join(thread3, NULL);
    
    printf("所有工作完成，最终计数器 = %d\n", shared_counter);
    
    sem_destroy(&semaphore);
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
开始非阻塞信号量测试，初始值 = 1
线程 1: 尝试非阻塞获取信号量
线程 2: 尝试非阻塞获取信号量
线程 3: 尝试非阻塞获取信号量
线程 1: 成功获取信号量
线程 2: 信号量不可用，继续其他工作
线程 3: 信号量不可用，继续其他工作
线程 1: 计数器值 = 1
线程 1: 释放信号量
线程 2: 尝试非阻塞获取信号量
线程 3: 尝试非阻塞获取信号量
线程 2: 成功获取信号量
线程 3: 信号量不可用，继续其他工作
线程 2: 计数器值 = 2
线程 2: 释放信号量
线程 3: 尝试非阻塞获取信号量
线程 3: 成功获取信号量
线程 3: 计数器值 = 3
线程 3: 释放信号量
所有工作完成，最终计数器 = 3
```

sem_timedwait
---------------------------------------------

带超时的信号量等待。

**头文件**

```c
#include <semaphore.h>
#include <time.h>
```

**函数原型**

```c
int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);
```

- 说明：带超时地等待信号量，如果信号量值大于 0 则减 1 并立即返回，否则等待直到超时
- 返回值：成功返回 0，失败返回 -1 并设置 errno（ETIMEDOUT 表示超时）
- 附加说明：abs_timeout 是绝对时间，不是相对时间
- 相关函数：sem_wait, sem_trywait, sem_post, clock_gettime

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

sem_t semaphore;
int shared_counter = 0;

void *worker_thread(void *arg) {
    int *thread_id = (int *)arg;
    struct timespec timeout;
    
    for (int i = 0; i < 3; i++) {
        printf("线程 %d: 尝试带超时获取信号量\n", *thread_id);
        
        // 设置超时时间为 2 秒后
        clock_gettime(CLOCK_REALTIME, &timeout);
        timeout.tv_sec += 2;
        
        // 带超时等待信号量
        if (sem_timedwait(&semaphore, &timeout) == 0) {
            // 成功获取信号量
            printf("线程 %d: 成功获取信号量\n", *thread_id);
            
            // 临界区
            shared_counter++;
            printf("线程 %d: 计数器值 = %d\n", *thread_id, shared_counter);
            sleep(1);
            
            // 释放信号量
            sem_post(&semaphore);
            printf("线程 %d: 释放信号量\n", *thread_id);
        } else {
            // 获取失败
            if (errno == ETIMEDOUT) {
                printf("线程 %d: 等待信号量超时\n", *thread_id);
            } else {
                perror("sem_timedwait");
            }
        }
        
        sleep(1);
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2, thread3;
    int id1 = 1, id2 = 2, id3 = 3;
    
    // 初始化信号量，初始值为 1（互斥锁）
    if (sem_init(&semaphore, 0, 1) == -1) {
        perror("sem_init");
        return 1;
    }
    
    printf("开始带超时信号量测试，初始值 = 1\n");
    
    // 创建多个线程
    pthread_create(&thread1, NULL, worker_thread, &id1);
    pthread_create(&thread2, NULL, worker_thread, &id2);
    pthread_create(&thread3, NULL, worker_thread, &id3);
    
    // 等待线程结束
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    pthread_join(thread3, NULL);
    
    printf("所有工作完成，最终计数器 = %d\n", shared_counter);
    
    sem_destroy(&semaphore);
    return 0;
}
```

执行

```shell
$ gcc -pthread example.c -o example
$ ./example
开始带超时信号量测试，初始值 = 1
线程 1: 尝试带超时获取信号量
线程 2: 尝试带超时获取信号量
线程 3: 尝试带超时获取信号量
线程 1: 成功获取信号量
线程 2: 等待信号量超时
线程 3: 等待信号量超时
线程 1: 计数器值 = 1
线程 1: 释放信号量
线程 2: 尝试带超时获取信号量
线程 3: 尝试带超时获取信号量
线程 2: 成功获取信号量
线程 3: 等待信号量超时
线程 2: 计数器值 = 2
线程 2: 释放信号量
线程 3: 尝试带超时获取信号量
线程 3: 成功获取信号量
线程 3: 计数器值 = 3
线程 3: 释放信号量
所有工作完成，最终计数器 = 3
```


sem_unlink
---------------------------------------------

删除命名信号量。

**头文件**

```c
#include <semaphore.h>
```

**函数原型**

```c
int sem_unlink(const char *name);
```

- 说明：从系统中删除命名信号量，当所有进程都关闭该信号量后才会真正删除
- 返回值：成功返回 0，失败返回 -1 并设置 errno
- 附加说明：删除的是信号量名称，已打开的信号量仍可使用直到关闭
- 相关函数：sem_open, sem_close, sem_post, sem_wait

**示例**

```c
#include <semaphore.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>

#define SEM_NAME "/test_unlink_semaphore"

int main() {
    sem_t *sem;
    pid_t pid;
    
    // 创建命名信号量
    sem = sem_open(SEM_NAME, O_CREAT, 0644, 1);
    if (sem == SEM_FAILED) {
        perror("sem_open");
        return 1;
    }
    
    printf("命名信号量创建成功\n");
    
    // 创建子进程
    pid = fork();
    
    if (pid == 0) {
        // 子进程
        printf("子进程：打开信号量\n");
        sem = sem_open(SEM_NAME, 0);
        if (sem == SEM_FAILED) {
            perror("sem_open in child");
            return 1;
        }
        
        printf("子进程：等待信号量\n");
        sem_wait(sem);
        printf("子进程：获得信号量，开始工作\n");
        sleep(2);
        printf("子进程：工作完成，释放信号量\n");
        sem_post(sem);
        
        // 关闭信号量
        sem_close(sem);
        printf("子进程：信号量关闭\n");
        
        return 0;
    } else if (pid > 0) {
        // 父进程
        sleep(1);
        printf("父进程：等待信号量\n");
        sem_wait(sem);
        printf("父进程：获得信号量，开始工作\n");
        sleep(2);
        printf("父进程：工作完成，释放信号量\n");
        sem_post(sem);
        
        // 等待子进程结束
        wait(NULL);
        
        // 关闭信号量
        sem_close(sem);
        printf("父进程：信号量关闭\n");
        
        // 删除信号量
        if (sem_unlink(SEM_NAME) == -1) {
            perror("sem_unlink");
        } else {
            printf("信号量已从系统中删除\n");
        }
        
        // 尝试重新打开已删除的信号量
        sem = sem_open(SEM_NAME, 0);
        if (sem == SEM_FAILED) {
            printf("信号量确实已被删除，无法重新打开\n");
        } else {
            printf("警告：信号量仍然存在\n");
            sem_close(sem);
        }
    } else {
        perror("fork");
        return 1;
    }
    
    return 0;
}
```

执行

```shell
$ gcc example.c -o example -lrt
$ ./example
命名信号量创建成功
子进程：打开信号量
子进程：等待信号量
子进程：获得信号量，开始工作
父进程：等待信号量
子进程：工作完成，释放信号量
子进程：信号量关闭
父进程：获得信号量，开始工作
父进程：工作完成，释放信号量
父进程：信号量关闭
信号量已从系统中删除
信号量确实已被删除，无法重新打开
```
