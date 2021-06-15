环境变量篇
=============================================

getenv
---------------------------------------------

获取环境变量内容

头文件 `#include <stdlib.h>`

函数原型

```c
char * getenv(const char *name);
```

- 说明：getenv() 用来获取参数 name 环境变量的内容。参数 name 为环境变量的名称，如果该变量存在则会返回指向该内容的指针。环境变量的格式为 name=value。
- 返回值：执行成功则返回指向该内容的指针，找不到符合的环境变量名称则返回 NULL。
- 相关函数：putenv, setenv, unsetenv

示例

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char *p;
    if((p = getenv("USER")))
        printf("USER=%s\n", p);
    return 0;
}
```

执行

```shell
USER=root
```


putenv
---------------------------------------------

改变或增加环境变量

头文件 `#include <stdlib.h>`

函数原型

```c
int putenv(const char * string);
```

- 说明：putenv() 用来改变或增加环境变量的内容。参数 string 的格式为 name=value，如果该换变量原先存在，则变量内容会依参数 string 改变，否则此参数内容会成为新的环境变量。
- 返回值：执行成功则返回 0，有错误发生则返回错误代码，例如 ENOMEM 表示内存不足，无法配置新的环境变量空间。
- 相关函数：getenv, setenv, unsetenv

示例

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char *p;
    if((p = getenv("USER")))
        printf("USER=%s\n", p);
    putenv("USER=test");
    printf("USER=%s\n", getenv("USER"));
    return 0;
}
```

执行

```shell
USER=root
USER=test
```


setenv
---------------------------------------------

改变或增加环境变量

头文件 `#include <stdlib.h>`

函数原型

```c
int setenv(const char *name, const char *value, int overwrite);
```

- 说明：setenv() 用来改变或增加环境变量的内容。参数 name 为环境变量名称字符串。value 则为变量内容，参数 overwrite 用来决定是否要改变已存在的环境变量。如果 overwrite 不为 0，而该环境变量原已有内容，则原内容会被改为参数 value 所指的变量内容。如果 overwrite 为 0，且该环境变量已有内容，则参数 value 会被忽略。
- 返回值：执行成功则返回 0，有错误发生则返回错误代码，例如 ENOMEM 表示内存不足，无法配置新的环境变量空间。
- 相关函数：getenv, putenv, unsetenv

示例

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char * p;
    if((p = getenv("USER")))
        printf("USER=%s\n", p);
    setenv("USER", "test", 1);
    printf("USER=%s\n", getenv("USER"));
    unsetenv("USER");
    printf("USER=%s\n", getenv("USER"));
    return 0;
}
```

执行

```shell
USER=root
USER=test
USER=(null)
```

