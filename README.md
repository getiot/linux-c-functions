# linux-c-functions

这是一份开源的《Linux 常用 C 函数参考手册》中文版，文档托管在 [GetIoT.tech](https://getiot.tech) 网站，你可以点击 [这里](https://getiot.tech/manual/linux-c-functions/) 在线阅读。如果你在阅读过程中发现错误或者遗漏，欢迎给本仓库提交 issue 和 PR！示例代码均可在 [linux-c](https://github.com/getiot/linux-c) 仓库找到。

![](images/linux-c-functions-screeshot-v2-01.jpg)

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

## 如何参与

linux-c-functions 文档系统的目录结构很简单，所有文档均放置在 source 目录中，source 目录的大致结构和简要说明如下。

```bash
source
├── conf.py      # 文档配置文件
├── index.rst    # 文档首页（包含目录信息）
├── about.rst    # 关于页面
├── **.md        # 函数分类页面
├── _static      # 静态资源目录
└── _templates   # 模板资源目录
```

source 目录下包含多个 .md 文档，每个文档是一个大类的 C 函数。

```bash
char.md            file.md             memory.md         process.md         time.md
data-structure.md  io-multiplexing.md  memory-string.md  pthreads.md        tty.md
env.md             ipcs.md             network.md        signal.md          user-group.md
file-content.md    math.md             permission.md     string-convert.md
```

你可以找到其中的某个函数进行修改，对于不存在的函数，你可以新增。如果找不到想要的分类，可以在提 issue 讨论。

## 如何构建

Sphinx 文档系统支持本地构建、部署，这里以 Ubuntu 为例（其他 Linux 发行版、MacOS 或 Windows 也行），介绍如何构建出可在本地访问的 linux-c-functions 在线文档。

首先需要安装 Python3、Git、Make 等基础软件。

```bash
sudo apt install git
sudo apt install make
sudo apt install python3
sudo apt install python3-pip 
```

然后安装最新版本的 Sphinx 及依赖。

```bash
pip3 install -U Sphinx
```

为了完成本示例，还需要安装以下软件包。

```bash
pip3 install sphinx-autobuild
pip3 install sphinx_rtd_theme
pip3 install recommonmark
pip3 install sphinx_markdown_tables
```

安装完成后，系统会增加一些 `sphinx-` 开头的命令。

```bash
sphinx-apidoc    sphinx-autobuild    sphinx-autogen    sphinx-build    sphinx-quickstart
```

在工程目录下执行下面命令，生成 HTML 网页并启动本地测试 Web Server，默认端口为 8000。（推荐开发环境使用）

```bash
sphinx-autobuild source build/html
```

或者直接执行 `make html` 构建。

现在，在浏览器输入 `127.0.0.1:8000` 即可访问。

发布版本推荐使用如下命令构建：

```bash
sphinx-build -b html source build/html
```

