# linux-c-functions

这是一份开源的《Linux 常用 C 函数参考手册》中文版，文档托管在 [GetIoT.tech](https://getiot.tech) 网站，你可以点击 [这里](https://getiot.tech/manual/linux-c-functions/) 在线阅读。如果你在阅读过程中发现错误或者遗漏，欢迎给本仓库提交 issue 和 PR！示例代码均可在 [linux-c](https://github.com/getiot/linux-c) 仓库找到。

![](https://static.getiot.tech/The_C_Programming_Language_logo.png)

## 目录

- [字符测试篇](source/char.md)
- [字符串转换篇](source/string-convert.md)
- [内存控制篇](source/memory.md)
- [日期时间篇](source/time.md)
- [内存及字符串操作篇](source/memory-string.md)
- [常用数学函数篇](source/math.md)
- [用户组篇](source/user-group.md)
- [数据结构及算法篇](source/data-structure.md)
- [文件操作篇](source/file.md)
- [文件内容操作篇](source/file-content.md)
- [进程操作篇](source/process.md)
- [进程间通信篇](source/process.md)
- [线程管理篇](source/pthreads.md)
- [文件权限控制篇](source/permission.md)
- [信号处理篇](source/signal.md)
- [网络接口篇](source/network.md)
- [I/O 复用篇](source/io-multiplexing.md)
- [环境变量篇](source/env.md)
- [终端控制篇](source/tty.md)

## 函数

新增函数

- malloc_usable_size


## 模板

简介

**头文件**

```c
#include <stdio.h>
```

**函数原型**

```c
int printf(const char *format, ...);
```

- 功能：
- 返回值：
- 附加说明：
- 相关函数：

**示例**

```c
int main(void)
{
    printf("Hello, World!\n");
    return 0;
}
```

执行

```bash
Hello, World!
```

