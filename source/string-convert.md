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

int main()
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

- 说明：gcvt() 用来将参数 number 转换成 ASCII 码字符串，参数 ndigits 表示显示的位数。gcvt() 与 ecvt() 和 fcvt() 不同的地方在于，gcvt() 所转换后的字符串包含小数点或正负符号。若转换成功，转换后的字符串会放在参数 buf 指针所指的空间。
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

将字符串转换成浮点数

头文件 `#include <stdlib.h>`

函数原型

```c
double strtod(const char *nptr, char **endptr);
```

- 说明：strtod() 会扫描参数 nptr 字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，而再遇到非数字或字符串结束时 ('\0') 才结束转换，并将结果返回。若 endptr 不为 NULL，则会将遇到不合条件而终止的 nptr 中的字符指针由 endptr 传回。参数 nptr 字符串可包含正负号、小数点或 E(e) 来表示指数部分，如 123.456 或 123e-2。
- 返回值：返回转换后的浮点型数。
- 附加说明：参考 [atof()](#atof)。
- 相关函数：atoi, atol, strtod, strtol, strtoul

示例

```c
/* 将字符串 a、b、c 分別转换成浮点型数字 */
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char a[] = "1000000000";
    char b[] = "123.456";
    char c[] = "123e-2";
    printf("a = %f\n", strtod(a, NULL));
    printf("b = %f\n", strtod(b, NULL));
    printf("c = %f\n", strtod(c, NULL));
    return 0;
}
```

执行

```shell
a = 1000000000.000000
b = 123.456000
c = 1.230000
```


strtol
---------------------------------------------

将字符串转换成长整型数

头文件 `#include <stdlib.h>`

函数原型

```c
long int strtol(const char *nptr, char **endptr, int base);
```

- 说明：strtol() 会将参数 nptr 字符串根据参数 base 来转换成长整型数。参数 base 代表采用的进制方式，范围从 2 至 36，或 0。如 base 值为 10 则采用十进制，若 base 值为 16 则采用十六进制等。当 base 值为 0 时则默认采用十进制做转换，但如果遇到如'0x'前置字符则会使用十六进制做转换。一开始 strtol() 会扫描参数 nptr 字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，再遇到非数字或字符串结束时 ('\0') 结束转换，并将结果返回。若参数 endptr 不为 NULL，则会将遇到不合条件而终止的 nptr 中的字符指针由 endptr 返回。
- 返回值：返回转换后的长整型数，否则返回 ERANGE 并将错误代码存入 errno 中。
- 附加说明：ERANGE 指定的转换字符串超出合法范围。
- 相关函数：atof, atoi, atol, strtod, strtoul

示例

```c
/* 将字符串 a、b、c 分別采用 10、2、16 进制转换成数字 */
#include <stdio.h>
#include <stdlib.h>

int main()
{
    char a[] = "1000000000";
    char b[] = "1000000000";
    char c[] = "ffff";
    printf("a = %ld\n", strtol(a, NULL, 10));
    printf("b = %ld\n", strtol(b, NULL, 2));
    printf("c = %ld\n", strtol(c, NULL, 16));
    return 0;
}
```

执行

```shell
a = 1000000000
b = 512
c = 65535
```


strtoul
---------------------------------------------

将字符串转换成无符号长整型数

头文件 `#include <stdlib.h>`

函数原型

```c
unsigned long int strtoul(const char *nptr, char **endptr, int base);
```

- 说明：strtoul() 会将参数 nptr 字符串根据参数 base 来转换成长整型数。参数 base 代表采用的进制方式，范围从 2 至 36，或 0。如 base 值为 10 则采用十进制，若 base 值为 16 则采用十六进制等。当 base 值为 0 时则默认采用十进制做转换，但如果遇到如'0x'前置字符则会使用十六进制做转换。一开始 strtol() 会扫描参数 nptr 字符串，跳过前面的空格字符，直到遇上数字或正负符号才开始做转换，再遇到非数字或字符串结束时 ('\0') 结束转换，并将结果返回。若参数 endptr 不为 NULL，则会将遇到不合条件而终止的 nptr 中的字符指针由 endptr 返回。
- 返回值：返回转换后的无符号长整型数，否则返回 ERANGE 并将错误代码存入 errno 中。
- 附加说明：ERANGE 指定的转换字符串超出合法范围。
- 相关函数：atof, atoi, atol, strtod, strtol

示例

參考 [strtol()](#strtol)


toascii
---------------------------------------------

将整型数转换成合法的 ASCII 码字符

头文件 `#include <ctype.h>`

函数原型

```c
int toascii(int c);
```

- 说明：toascii() 会将参数 c 转换成 7 位的 unsigned char 值，第八位则会被清除，此字符即会被转成 ASCII 码字符。
- 返回值：将转换成功的 ASCII 码字符值返回。
- 相关函数：isascii, toupper, tolower

示例

```c
#include <stdio.h>
#include <ctype.h>

int main()
{
    int a = 212;
    char b;
    printf("before toascii () : a value = %d(%c)\n", a, a);
    b = toascii(a);
    printf("after toascii() : a value = %d(%c)\n", b, b);
    return 0;
}
```

执行

```shell
before toascii () : a value = 212(▒)
after toascii() : a value = 84(T)
```


tolower
---------------------------------------------

将大写字母转换成小写字母

头文件 `#include <ctype.h>`

函数原型

```c
int tolower(int c);
```

- 说明：若参数 c 为大写字母则将该对应的小写字母返回。
- 返回值：返回转换后的小写字母，若不需转换则将参数 c 值返回。
- 相关函数：isalpha, toupper

示例

```c
/* 将 s 字符串内的大写字母转换成小写字母 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char s[] = "aBcDeFgH12345;!#$";
    int i;
    printf("before tolower() : %s\n", s);
    for(i=0; i<sizeof(s); i++)
        s[i] = tolower(s[i]);
    printf(" after tolower() : %s\n", s);
    return 0;
}
```

执行

```shell
before tolower() : aBcDeFgH12345;!#$
 after tolower() : abcdefgh12345;!#$
```


toupper
---------------------------------------------

将小写字母转换成大写字母

头文件 `#include <ctype.h>`

函数原型

```c
int toupper(int c);
```

- 说明：若参数 c 为小写字母则将其对应的大写字母返回。
- 返回值：返回转换后的大写字母，若不需转换则将参数 c 值返回。
- 相关函数：isalpha, tolower

示例

```c
/* 将 s 字符串内的小写字母转换成大写字母 */
#include <stdio.h>
#include <ctype.h>

int main()
{
    char s[] = "aBcDeFgH12345;!#$";
    int i;
    printf("before toupper() : %s\n", s);
    for(i=0; i<sizeof(s); i++)
        s[i] = toupper(s[i]);
    printf(" after toupper() : %s\n", s);
    return 0;
}
```

执行

```shell
before toupper() : aBcDeFgH12345;!#$
 after toupper() : ABCDEFGH12345;!#$
```

