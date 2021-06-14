字符测试篇
=============================================

isalnum
---------------------------------------------

头文件 `#include <ctype.h>`

函数原型

```c
int isalnum (int c);
```

- 功能：检查参数 c 是否为英文字母或阿拉伯数字，在标准 C 中相当于使用 `isalpha(c) || isdigit(c)` 做测试。
- 返回值：若参数 c 为字母或数字，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数 isalpha, isdigit, islower, isupper

示例


```c
/* 找出 str 字符串中为英文字母或数字的字符 */

#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123c@#FDsP[e?";
    int i;
    for (i=0; str[i]!=0; i++ )
        if (isalnum(str[i])) 
            printf("%c is an alphanumeric character\n", str[i]);

    return 0;
}
```

执行

```shell
1 is an alphanumeric character
2 is an alphanumeric character
3 is an alphanumeric character
c is an alphanumeric character
F is an alphanumeric character
D is an alphanumeric character
s is an alphanumeric character
P is an alphanumeric character
e is an alphanumeric character
```

isalpha
---------------------------------------------

isascii
---------------------------------------------

iscntrl
---------------------------------------------

isdigit
---------------------------------------------

isgraphis
---------------------------------------------

islower
---------------------------------------------

isprint
---------------------------------------------

isspace
---------------------------------------------

ispunct
---------------------------------------------

isupper
---------------------------------------------

isxdigit
---------------------------------------------
