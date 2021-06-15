字符串转换篇
=============================================

atof
---------------------------------------------

将字符串转换成浮点型数

头文件 `#include <stdlib.h>`

函数原型

```c
double atof(const char *nptr);
```

- 说明：atof() 会扫描参数 nptr 字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，而再遇到非数字或字符串结束时 ('\0') 才结束转换，并将结果返回。参数 nptr 字符串可包含正负号、小数点或 E(e) 来表示指数部分，如 123.456 或 123e-2。
- 返回值：返回转换后的浮点型数。
- 附加说明：atof() 与使用 `strtod(nptr, (char**)NULL)` 结果相同。
- 相关函数：atoi, atol, strtod, strtol, strtoul

示例

```c
/* 将字符串 a 与字符串 b 转换成数字后相加 */
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char *a = "-100.23";
    char *b = "200e-2";
    float c;
    c = atof(a) + atof(b);
    printf("c = %.2f\n", c);
    return 0;
}
```

执行

```shell
c = -98.23
```


atoi
---------------------------------------------

将字符串转换成整型数

头文件 `#include <stdlib.h>`

函数原型

```c
int atoi(const char *nptr);
```

- 说明：atoi() 会扫描参数 nptr 字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，而再遇到非数字或字符串结束时 ('\0') 才结束转换，并将结果返回。
- 返回值：返回转换后的整型数。
- 附加说明：atoi() 与使用 `strtol(nptr, (char**)NULL, 10)` 结果相同。
- 相关函数：atof, atol, atrtod, strtol, strtoul

示例

```c
/* 将字符串 a 与字符串 b 转换成数字后相加 */
#include <stdio.h>
#include <stdlib.h>

int mian()
{
    char a[] = "-100";
    char b[] = "456";
    int c;
    c = atoi(a) + atoi(b);
    printf("c = %d\n", c);
    return 0;
}
```

执行

```shell
c = 356
```


atol
---------------------------------------------

将字符串转换成长整型数

头文件 `#include <stdlib.h>`

函数原型

```c
long atol(const char *nptr);
```

- 说明：atol() 会扫描参数 nptr 字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，而再遇到非数字或字符串结束时 ('\0') 才结束转换，并将结果返回。
- 返回值：返回转换后的长整型数。
- 附加说明：atol() 与使用 `strtol(nptr, (char**)NULL, 10)` 结果相同。
- 相关函数：atof, atoi, strtod, strtol, strtoul

示例

```c
/* 将字符串 a 与字符串 b 转换成数字后相加 */
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char a[] = "1000000000";
    char b[] = "234567890";
    long c;
    c = atol(a) + atol(b);
    printf("c = %d\n", c);
    return 0;
}
```

执行

```shell
c = 1234567890
```


gcvt
---------------------------------------------

将浮点型数转换为字符串，取四舍五入

头文件 `#include <stdlib.h>`

函数原型

```c
char *gcvt(double number, size_t ndigits, char *buf);
```

- 说明：gcvt() 用来将参数 number 转换成 ASCII 码字符串，参数 ndigits 表示显示的位数。gcvt() 与 ecvt() 和 fcvt() 不同的地方在于，gcvt() 所转换后的字符串包含小数点或正负符号。若转换陈宫，转换后的字符串会放在参数 buf 指针所指的空间。
- 返回值：返回一字符串指针，此地址即为 buf 指针。
- 相关函数：ecvt, fcvt, sprintf

示例

```c
#include <stdio.h>
#include <stdlib.h>
#define MAX 100

int main()
{
    double a = 123.45;
    double b = -1234.56;
    char buf[MAX];
    char *ptr;

    gcvt(a, 5, buf);
    printf("a value = %s\n", buf);
    ptr = gcvt(b, 6, buf);
    printf("b value = %s\n", ptr);
    return 0;
}
```

执行

```shell
a value = 123.45
b value = -1234.56
```


strtod
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


strtol
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


strtoul
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


toascii
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


tolower
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


toupper
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

