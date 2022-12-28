# linux-c-functions

这是一份《Linux 常用 C 函数手册》，你可以点击 [这里](https://getiot.tech/manual/linux-c-functions/) 在线阅读。如果你在阅读过程中发现错误或者遗漏，欢迎给本仓库提交 issue 和 PR！

![](https://static.getiot.tech/The_C_Programming_Language_logo.png)



## 参考

- <https://people.cs.nctu.edu.tw/~yslin/library/linuxc/main.htm>
- <https://www.gnu.org/software/libc/manual/html_node/Function-Index.html>

## 函数

新增函数

- malloc_usable_size


## 模板

简介

头文件 `#include <stdio.h>`

函数原型

```c
int printf(const char *format, ...);
```

- 功能：
- 返回值：
- 附加说明：
- 相关函数：

示例

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

