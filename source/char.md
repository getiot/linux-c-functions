字符测试篇
=============================================

isalnum
---------------------------------------------

测试字符是否为英文或数字

头文件 `#include <ctype.h>`

函数原型

```c
int isalnum(int c);
```

- 功能：检查参数 c 是否为英文字母或阿拉伯数字，在标准 C 中相当于使用 `isalpha(c) || isdigit(c)` 做测试。
- 返回值：若参数 c 为字母或数字，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数： isalpha, isdigit, islower, isupper

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

测试字符是否为英文字母

头文件 `#include <ctype.h>`

函数原型

```c
int isalpha(int c);
```

- 功能：检查参数 c 是否为英文字母，在标准 c 中相当于使用 `isupper(c) || islower(c)` 做测试。
- 返回值：若参数 c 为英文字母，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isalnum, islower, isupper


示例

```c
/* 找出 str 字符串中为英文字母的字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123c@#FDsP[e?";
    int i;
    for (i=0; str[i]!=0; i++)
        if(isalpha(str[i])) 
            printf(“%c is an alphanumeric character\n”, str[i]);
    
    return 0;
}
```

执行

```shell
c is an alphanumeric character
F is an alphanumeric character
D is an alphanumeric character
s is an alphanumeric character
P is an alphanumeric character
e is an alphanumeric character
```

isascii
---------------------------------------------

测试字符串是否为 ASCII 码字符

头文件 `#include <ctype.h>`

函数原型

```c
int isascii(int c);
```

- 功能：检查参数 c 是否为 ASCII 码字符，也就是判断 c 的范围是否在 0 到 127 之间。
- 返回值：若参数 c 为 ASCII 码字符，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：iscntrl

示例

```c
/* 判断 int i 是否具有对应的 ASCII 码字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    int i;
    for(i=125; i<130; i++)
        if(isascii(i))
            printf("%d is an ascii character: %c\n", i, i);
        else
            printf("%d is not an ascii character\n", i);
    
    return 0;
}
```

执行

```shell
125 is an ascii character:}
126 is an ascii character:~
127 is an ascii character:
128 is not an ascii character
129 is not an ascii character
```


iscntrl
---------------------------------------------

测试字符是否为 ASCII 码的控制字符

头文件 `#include <ctype.h>`

函数原型

```c
int iscntrl(int c);
```

- 功能：检查参数 c 是否为 ASCII 控制码，也就是判断 c 的范围是否在 0 到 30 之间。
- 返回值：若参数 c 为 ASCII 控制码，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isascii


isdigit
---------------------------------------------

测试字符是否为阿拉伯数字

头文件 `#include <ctype.h>`

函数原型

```c
int isdigit(int c);
```

- 功能：检查参数 c 是否为阿拉伯数字 0 到 9。
- 返回值：若参数 c 为阿拉伯数字，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isxdigit

示例

```c
/* 找出str字符串中为阿拉伯数字的字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123@#FDsP[e?";
    int i;
    for(i=0; str[i]!=0; i++)
        if(isdigit(str[i]))
            printf("%c is an digit character\n", str[i]);
    
    return 0;
}
```

执行

```shell
1 is an digit character
2 is an digit character
3 is an digit character
```


isgraphis
---------------------------------------------

测试字符是否为可打印字符

头文件 `#include <ctype.h>`

函数原型

```c
int isgraph(int c);
```

- 功能：检查参数 c 是否为可打印字符，若 c 所对应的 ASCII 码可打印，且非空格字符则返回 `TRUE`。
- 返回值：若参数 c 为可打印字符，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isprint

示例

```c
/* 判断 str 字符串中哪些为可打印字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "a5 @;";
    int i;
    for(i=0; str[i]!=0; i++)
        if(isgraph(str[i])) 
            printf("str[%d] is printable character: %d\n", i, str[i]);

    return 0;
}
```

执行

```shell
str[0] is printable character: a
str[1] is printable character: 5
str[3] is printable character: @
str[4] is printable character: ;
```


islower
---------------------------------------------

测试字符是否为小写字母

头文件 `#include <ctype.h>`

函数原型

```c
int islower(int c);
```

- 功能：检查参数 c 是否为小写英文字母。
- 返回值：若参数 c 为小写英文字母，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isalpha, isupper

示例

```c
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123c@#FDsP[e?";
    int i;
    for(i=0; str[i]!=0; i++)
        if(islower(str[i]))
            printf("%c is a lower-case character\n", str[i]);
    
    return 0;
}
```

执行

```shell
c is a lower-case character
s is a lower-case character
e is a lower-case character
```


isprint
---------------------------------------------

测试字符是否为可打印字符

头文件 `#include <ctype.h>`

函数原型

```c
int isprint(int c);
```

- 功能：检查参数 c 是否为可打印字符，若 c 所对应的 ASCII 码可打印，且非空格字符则返回 `TRUE`。
- 返回值：若参数 c 为可打印字符，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isgraph

示例

```c
/* 判断 str 字符串中哪些为可打印字符包含空格字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "a5 @;";
    int i;
    for(i=0; str[i]!=0; i++)
        if(isprint(str[i]))
            printf("str[%d] is printable character: %d\n", i, str[i]);
    
    return 0;
}
```

执行

```shell
str[0] is printable character: a
str[1] is printable character: 5
str[2] is printable character:
str[3] is printable character: @
str[4] is printable character: ;
```


isspace
---------------------------------------------

测试字符是否为空格字符

头文件 `#include <ctype.h>`

函数原型

```c
int isspace(int c);
```

- 功能：检查参数 c 是否为空格字符，也就是判断是否为空格 ('')、定位字符 ('\t')、CR ('\r')、换行 ('\n')、垂直定位字符 ('\v') 或翻页 ('\f') 的情況。
- 返回值：若参数 c 为空格字符，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isgraph

示例

```c
/* 将字符串 str[] 中内含的空格字符找出，并显示空格字符的 ASCII 码 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str = "123c @# FD\tsP[e?\n";
    int i;
    for(i=0; str[i]!=0; i++)
        if(isspace(str[i]))
            printf("str[%d] is a white-space character: %d\n", i, str[i]);

    return 0;
}
```

执行

```shell
str[4] is a white-space character: 32
str[7] is a white-space character: 32
str[10] is a white-space character: 9
str[16] is a white-space character: 10
```


ispunct
---------------------------------------------

测试字符是否为标点符号或特殊符号

头文件 `#include <ctype.h>`

函数原型

```c
int ispunct(int c);
```

- 功能：检查参数 c 是否为标点符号或特殊符号。返回 `TRUE` 也就是代表参数 c 为非空格、非数字和非英文字母。
- 返回值：若参数 c 为标点符号或特殊符号，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isspace, isdigit, isalpha

示例

```c
/* 列出字符串 str 中的标点符号或特殊符号 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123c@ #FDsP[e?";
    int i;
    for(i=0; str[i]!=0; i++)
        if(ispunct(str[i]))
            printf("%c\n", str[i]);
    
    return 0;
}
```

执行

```shell
@#[?
```


isupper
---------------------------------------------

测试字符是否为大写英文字母

头文件 `#include <ctype.h>`

函数原型

```c
int isupper(int c);
```

- 功能：检查参数 c 是否为大写英文字母。
- 返回值：若参数 c 为大写英文字母，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isalpha, islower

示例

```c
/* 找出字符串 str 中为大写英文字母的字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123c@#FDsP[e?";
    int i;
    for(i=0; str[i]!=0; i++)
        if(isupper(str[i]))
            printf("%c is an uppercase character\n", str[i]);

    return 0;
}
```

执行

```shell
F is an uppercase character
D is an uppercase character
P is an uppercase character
```


isxdigit
---------------------------------------------

测试字符是否为十六进制数字

头文件 `#include <ctype.h>`

函数原型

```c
int isxdigit(int c);
```

- 功能：检查参数 c 是否为十六进制数字，只要 c 为下列其中一个情况则返回 `TRUE`。十六进制数字：0123456789ABCDEF。
- 返回值：若参数 c 为十六进制数字，则返回 `TRUE`，否则返回 `NULL`。
- 附加说明：此为宏定义，非真正函数。
- 相关函数：isalnum, isdigit

示例

```c
/* 找出字符串 str 中为十六进制数字的字符 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char str[] = "123c@#FDsP[e?";
    int i;
    for(i=0; str[i]!=0; i++)
        if(isxdigit(str[i]))
            printf("%c is a hexadecimal digits\n", str[i]);

    return 0;
}
```

执行

```shell
1 is a hexadecimal digits
2 is a hexadecimal digits
3 is a hexadecimal digits
c is a hexadecimal digits
F is a hexadecimal digits
D is a hexadecimal digits
e is a hexadecimal digits
```
