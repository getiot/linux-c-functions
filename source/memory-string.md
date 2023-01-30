内存及字符串操作篇
=============================================

bcmp
---------------------------------------------

比较内存内容

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
int bcmp(const void *s1, const void *s2, size_t n);
```

- 说明：bcmp() 用来比较 s1 和 s2 所指的内存区间前 n 个字节，若参数 n 为 0，则返回 0。
- 返回值：若参数 s1 和 s2 所指的内存内容都完全相同则返回 0 值，否则返回非零值。
- 附加说明：建议使用 memcmp() 取代。
- 相关函数：bcmp，strcasecmp，strcmp，strcoll，strncmp，strncasecmp

**示例**

参考 [memcmp()](#memcmp)


bcopy
---------------------------------------------

拷贝内存内容

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void bcopy(const void *src, void *dest, size_t n);
```

- 说明：bcopy() 和 memcpy() 一样都是用来拷贝 src 所指的内存内容前 n 个字节到 dest 所指的地址，不过参数 src 与 dest 在传给函数时是相反的位置。
- 返回值：无
- 附加说明：建议使用 memcpy() 取代。
- 相关函数：memccpy，memcpy，memmove，strcpy，ctrncpy

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char dest[30] = "string(a)";
    char src[30]="string\0string";
    int i;
    bcopy(src, dest, 30);      /* src指针放在前面 */
    printf("bcopy(): ");
    for(i=0; i<30; i++)
        printf("%c", dest[i]);
    
    memcpy(dest, src, 30);     /* dest指针放在前面 */
    printf("\nmemcpy(): ");
    for(i=0; i<30; i++)
        printf("%c", dest[i]);
    
    return 0;
}
```

执行

```shell
bcopy(): stringstring
memcpy(): stringstring
```


bzero
---------------------------------------------

将一段内存内容全清为零

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void bzero(void *s, size_t n);
```

- 说明：bzero() 会将参数 s 所指的内存区域前 n 个字节，全部设为零值。相当于调用 `memset((void*)s, 0, size_tn)`。
- 返回值：无
- 附加说明：bzero 不是标准库函数，为了提高可移植性，建议使用 memset 取代。
- 相关函数：memset，swab

**示例**

参考 [memset()](#memset)


index
---------------------------------------------

查找字符串中第一个出现的指定字符

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *index(const char *s, int c);
```

- 说明：index() 用来找出参数 s 字符串中第一个出现的参数 c 地址，然后将该字符出现的地址返回。字符串结束字符（NULL）也视为字符串一部分。
- 返回值：如果找到指定的字符则返回该字符所在地址，否则返回 NULL。
- 相关函数：rindex，srechr，strrchr

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *s = "0123456789012345678901234567890";
    char *p;
    p = index(s, '5');
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
56789012345678901234567890
```


memccpy
---------------------------------------------

拷贝内存内容

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void *memccpy(void *dest, const void *src, int c, size_t n);
```

- 说明：memccpy() 用来拷贝 src 所指的内存内容前 n 个字节到 dest 所指的地址上。与 memcpy() 不同的是，memccpy() 会在复制时检查参数 c 是否出现，若是则返回 dest 中值为 c 的下一个字节地址。
- 返回值：返回指向 dest 中值为 c 的下一个字节指针。返回值为 0 表示在 src 所指内存前 n 个字节中没有值为 c 的字节。
- 相关函数：bcopy，memcpy，memmove，strcpy，strncpy

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char a[] = "string[a]";
    char b[] = "string(b)";
    char *c;
    c = memccpy(a, b, 'b', sizeof(b));
    printf("memccpy(): %s\n", a);
    if (c)
        printf("%s\n", c);
    return 0;
}
```

执行

```shell
memccpy(): string(b]
]
```


memchr
---------------------------------------------

在某一内存范围中查找一特定字符

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void *memchr(const void *s, int c, size_t n);
```

- 说明：memchr() 从头开始搜寻 s 所指的内存内容前 n 个字节，直到发现第一个值为 c 的字节，则返回指向该字节的指针。
- 返回值：如果找到指定的字节则返回该字节的指针，否则返回 0。
- 相关函数：index，rindex，strchr，strpbrk，strrchr，strsep，strspn，strstr

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *s = "0123456789012345678901234567890";
    char *p;
    p = memchr(s, '5', 10);
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
56789012345678901234567890
```


memcmp
---------------------------------------------

比较内存内容

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
int memcmp(const void *s1, const void *s2, size_t n);
```

- 说明：memcmp() 用来比较 s1 和 s2 所指的内存区间前 n 个字符。字符串大小的比较是以 ASCII 码表上的顺序来决定，此顺序亦为字符的值。memcmp() 首先将 s1 第一个字符值减去 s2 第一个字符的值，若差为 0 则再继续比较下个字符，若差值不为 0 则将差值返回。例如，字符串 "Ac" 和 "ba" 比较则会返回字符 'A'(65) 和 'b'(98) 的差值 (-33)。
- 返回值：若参数 s1 和 s2 所指的内存内容都完全相同则返回 0 值。s1 若大于 s2 则返回大于 0 的值。s1 若小于 s2 则返回小于 0 的值。
- 相关函数：bcmp，strcasecmp，strcmp，strcoll，strncmp，strncasecmp

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *a = "aBcDeF";
    char *b = "AbCdEf";
    char *c = "aacdef";
    char *d = "aBcDeF";
    printf("memcmp(a,b): %d\n", memcmp((void*)a, (void*) b, 6));
    printf("memcmp(a,c): %d\n", memcmp((void*)a, (void*) c, 6));
    printf("memcmp(a,d): %d\n", memcmp((void*)a, (void*) d, 6));
    return 0;
}
```

执行

```shell
memcmp(a,b): 1    # 字符串a > 字符串b，返回 1
memcmp(a,c): -1   # 字符串a < 字符串c，返回 -1
memcmp(a,d): 0    # 字符串a = 字符串d，返回 0
```


memcpy
---------------------------------------------

拷贝内存内容

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void *memcpy(void *dest, const void *src, size_t n);
```

- 说明：memcpy() 用来拷贝 src 所指的内存内容前 n 个字节到 dest 所指的内存地址上。与 strcpy() 不同的是，memcpy() 会完整地复制 n 个字节，不会因为遇到字符串结束 '\0' 而结束。
- 返回值：返回指向 dest 的指针。
- 附加说明：指针 src 和 dest 所指的内存区域不可重叠。
- 相关函数：bcopy，memccpy，memcpy，memmove，strcpy，strncpy

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
	char a[30] = "string (a)";
    char b[30] = "string\0string";
    int i;
    strcpy(a, b);
    printf("strcpy(): ");
    for(i=0; i<30; i++)
        printf("%c", a[i]);
    memcpy(a, b, 30);
    printf("\nmemcpy(): ");
    for(i=0; i<30; i++)
        printf("%c", a[i]);
    return 0;
}
```

执行

```shell
strcpy(): string(a)
memcpy(): stringstring
```


memmove
---------------------------------------------

拷贝内存内容

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void *memmove(void *dest, const void *src, size_t n);
```

- 说明：memmove() 和 memcpy() 一样都是用来拷贝 src 所指的内存内容前 n 个字节到 dest 所指的地址上。不同的是，当 src 和 dest 所指的内存区域重叠时，memmove() 仍然可以正确的处理，不过执行效率上会比使用 memcpy() 略慢些。
- 返回值：返回指向 dest 的指针。
- 附加说明：指针 src 和 dest 所指的内存区域可以重叠。
- 相关函数：bcopy，memccpy，memcpy，strcpy，strncpy

**示例**

参考 [memcpy()](#memcpy)


memset
---------------------------------------------

将一段内存空间填入某值

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
void *memset(void *s, int c, size_t n);
```

- 说明：memset() 会将参数 s 所指的内存区域前 n 个字节以参数 c 填入，然后返回指向 s 的指针。在编写程序时，若需要将某一数组作初始化，memset() 会相当方便。
- 返回值：返回指向 s 的指针。
- 附加说明：参数 c 虽声明为 int，但必须是 unsigned char，所以范围在 0 到 255 之间。
- 相关函数：bzero，swab

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char s[30];
    memset(s, 'A', sizeof(s));
    s[30] = '\0';
    printf("%s\n", s);
    return 0;
}
```

执行

```shell
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```


rindex
---------------------------------------------

查找字符串中最后一个出现的指定字符

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *rindex(const char *s, int c);
```

- 说明：rindex() 用来找出参数 s 字符串中最后一个出现的参数 c 地址，然后将该字符出现的地址返回。字符串结束字符（NULL）也视为字符串一部分。
- 返回值：如果找到指定的字符则返回该字符所在的地址，否则返回 0。
- 相关函数：index，memchr，strchr，strrchr

**示例**

```c
#include <string.h>
#include <string.h>

int main()
{
    char *s = "0123456789012345678901234567890";
    char *p;
    p = rindex(s, '5');
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
567890
```


strcasecmp
---------------------------------------------

忽略大小写比较字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
int strcasecmp(const char *s1, const char *s2);
```

- 说明：strcasecmp() 用来比较参数 s1 和 s2 字符串，比较时会自动忽略大小写的差异。
- 返回值：若参数 s1 和 s2 字符串相同则返回 0。s1 长度大于 s2 长度则返回大于 0 的值，s1 长度若小于 s2 长度则返回小于 0 的值。
- 相关函数：bcmp，memcmp，strcmp，strcoll，strncmp

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *a = "aBcDeF";
    char *b = "AbCdEf";
    if(!strcasecmp(a, b))
        printf("%s=%s\n", a, b);
    return 0;
}
```

执行

```shell
aBcDeF=AbCdEf
```


strcat
---------------------------------------------

连接两字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strcat(char *dest, const char *src);
```

- 说明：strcat() 会将参数 src 字符串拷贝到参数 dest 所指的字符串尾。第一个参数 dest 要有足够的空间来容纳要拷贝的字符串。
- 返回值：返回参数 dest 的字符串起始地址。
- 相关函数：bcopy，memccpy，memcpy，strcpy，strncpy

**示例**

```c
#include <stdio.h.>
#include <string.h.>

int main()
{
    char a[30] = "string(1)";
    char b[] = "string(2)";
    printf("before strcat() : %s\n", a);
    printf(" after strcat() : %s\n", strcat(a, b));
    return 0;
}
```

执行

```shell
before strcat() : string(1)
 after strcat() : string(1)string(2)
```


strchr
---------------------------------------------

查找字符串中第一个出现的指定字符

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strchr (const char *s, int c);
```

- 说明：strchr() 用来找出参数 s 字符串中第一个出现的参数 c 地址，然后将该字符出现的地址返回。
- 返回值：如果找到指定的字符则返回该字符所在地址，否则返回 0。
- 相关函数：index，memchr，rinex，strbrk，strsep，strspn，strstr，strtok

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *s = "0123456789012345678901234567890";
    char *p;
    p = strchr(s, '5');
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
56789012345678901234567890
```


strcmp
---------------------------------------------

比较字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
int strcmp(const char *s1, const char *s2);
```

- 说明：strcmp() 用来比较参数 s1 和 s2 字符串。字符串大小的比较是以 ASCII 码表上的顺序来决定，此顺序亦为字符的值。strcmp() 首先将 s1 第一个字符值减去 s2 第一个字符的值，若差为 0 则再继续比较下个字符，若差值不为 0 则将差值返回。例如，字符串 "Ac" 和 "ba" 比较则会返回字符 'A'(65) 和 'b'(98) 的差值 (-33)。
- 返回值：若参数 s1 和 s2 字符串相同则返回 0，s1 若大于 s2 则返回大于 0 的值，s1 若小于 s2 则返回小于 0 的值。
- 相关函数：bcmp，memcmp，strcasecmp，strncasecmp，strcoll

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *a = "aBcDeF";
    char *b = "AbCdEf";
    char *c = "aacdef";
    char *d = "aBcDeF";
    printf("strcmp(a,b) : %d\n", strcmp(a, b));
    printf("strcmp(a,c) : %d\n", strcmp(a, c));
    printf("strcmp(a,d) : %d\n", strcmp(a, d));
    return 0;
}
```

执行

```shell
strcmp(a,b) : 32
strcmp(a,c) : -31
strcmp(a,d) : 0
```


strcoll
---------------------------------------------

采用目前区域的字符排列次序来比较字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
int strcoll(const char *s1, const char *s2);
```

- 说明：strcoll() 会依环境变量 `LC_COLLATE` 所指定的文字排列次序来比较 s1 和 s2 字符串。
- 返回值：若参数 s1 和 s2 字符串相同则返回 0，s1 若大于 s2 则返回大于 0 的值，s1 若小于 s2 则返回小于 0 的值。
- 附加说明：若 `LC_COLLATE` 为 "POSIX" 或 "C"，则 strcoll() 与 strcmp() 作用完全相同。
- 相关函数：strcmp，bcmp，memcmp，strcasecmp，strncasecmp

**示例**

参考 [strcmp()](#strcmp)


strcpy
---------------------------------------------

拷贝字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strcpy(char *dest, const char *src);
```

- 说明：strcpy() 会将参数 src 字符串拷贝至参数 dest 所指的地址。
- 返回值：返回参数 dest 的字符串起始地址。
- 附加说明：如果参数 dest 所指的内存空间不够大，可能会造成缓冲溢出（buffer Overflow）的错误情况，在编写程序时请特别留意，或者用 strncpy() 来取代。
- 相关函数：bcopy，memcpy，memccpy，memmove

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char a[30]="Hello, World!";
    char b[]="你好，世界！";
    printf("before strcpy() : %s\n", a);
    printf(" after strcpy() : %s\n", strcpy(a, b));
    return 0;
}
```

执行

```shell
before strcpy() : Hello, World!
 after strcpy() : 你好，世界！
```


strcspn
---------------------------------------------

返回字符串中连续不含指定字符串内容的字符数

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
size_t strcspn(const char *s, const char *reject);
```

- 说明：strcspn() 从参数 s 字符串的开头计算连续的字符，而这些字符都完全不在参数 reject 所指的字符串中。简单地说，若 strcspn() 返回的数值为 n，则代表字符串 s 开头连续有 n 个字符都不含字符串 reject 内的字符。
- 返回值：返回字符串 s 开头连续不含字符串 reject 内的字符数目。
- 相关函数：strspn

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *str = "Linux was first developed for 386/486-based pcs.";
    printf("%d\n", strcspn(str, " "));
    printf("%d\n", strcspn(str, "/-"));
    printf("%d\n", strcspn(str, "1234567890"));
    return 0;
}
```

执行

```shell
5    # 值计算算到 " " 的出现，所以返回 "Linux" 的长度
33   # 计算到出现 "/" 或 "-"，所以返回到 "6" 的长度
30   # 计算到出现数字字符为止，所以返回 "3" 出现前的长度
```


strdup
---------------------------------------------

复制字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strdup(const char *s);
```

- 说明：strdup() 会先用 maolloc() 分配与参数 s 字符串相同的空间大小，然后将参数 s 字符串的内容复制到该内存地址，然后把该地址返回。该地址最后可以利用 free() 来释放。
- 返回值：返回一字符串指针，该指针指向复制后的新字符串地址。若返回 NULL 表示内存不足。
- 相关函数：calloc，malloc，realloc，free

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char a[]="strdup";
    char *b;
    b = strdup(a);
    printf("b[ ]=\"%s\"\n", b);
    return 0;
}
```

执行

```shell
b[ ]="strdup"
```


strlen
---------------------------------------------

返回字符串长度

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
size_t strlen (const char *s);
```

- 说明：strlen() 用来计算指定的字符串 s 的长度，不包括结束字符 '\0'。
- 返回值：返回字符串 s 的字符数。

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *str = "12345678";
    printf("str length = %d\n", strlen(str));
    return 0;
}
```

执行

```shell
str length = 8
```


strncasecmp
---------------------------------------------

忽略大小写比较字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
int strncasecmp(const char *s1, const char *s2, size_t n);
```

- 说明：strncasecmp() 用来比较参数 s1 和 s2 字符串前 n 个字符，比较时会自动忽略大小写的差异。
- 返回值：若参数 s1 和 s2 字符串相同则返回 0，s1 若大于 s2 则返回大于 0 的值，s1 若小于 s2 则返回小于 0 的值。
- 相关函数：bcmp，memcmp，strcmp，strcoll，strncmp

**示例**

```c
#include <stdio.h>
#include<string.h>

int main()
{
    char *a = "aBcDeF";
    char *b = "AbCdEf";
    if(!strncasecmp(a, b))
        printf("%s=%s\n", a, b);
    return 0;
}
```

执行

```shell
aBcDef=AbCdEf
```


strncat
---------------------------------------------

连接两字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strncat(char *dest, const char *src, size_t n);
```

- 说明：strncat() 会将参数 src 字符串拷贝 n 个字符到参数 dest 所指的字符串尾。第一个参数 dest 要有足够的空间来容纳要拷贝的字符串。
- 返回值：返回参数 dest 的字符串起始地址。
- 相关函数：bcopy，memccpy，memecpy，strcpy，strncpy

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char a[30] = "https://";
    char b[] = "getiot.tech";
    printf("before strnact() : %s\n", a);
    printf(" after strncat() : %s\n", strncat(a, b, strlen(b)+1));
    return 0;
}
```

执行

```shell
before strnact() : https://
 after strncat() : https://getiot.tech
```


strncpy
---------------------------------------------

拷贝字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strncpy(char *dest, const char *src, size_t n);
```

- 说明：strncpy() 会将参数 src 字符串拷贝前 n 个字符至参数 dest 所指的地址。
- 返回值：返回参数 dest 的字符串起始地址。
- 相关函数：bcopy，memccpy，memcpy，memmove

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char a[30]="Hello, World!";
    char b[]="你好，世界！";
    printf("before strncpy() : %s\n", a);
    printf(" after strncpy() : %s\n", strncpy(a, b, strlen(b)+1));
    /* 注意给'\0'留位置 */
    /* 否则可能出现 warning: ‘strncpy’ output truncated before terminating nul copying */
    return 0;
}
```

执行

```shell
before strncpy() : Hello, World!
 after strncpy() : 你好，世界！
```


strpbrk
---------------------------------------------

查找字符串中第一个出现的指定字符

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strpbrk(const char *s, const char *accept);
```

- 说明：strpbrk() 用来找出参数 s 字符串中最先出现存在参数 accept 字符串中的任意字符。
- 返回值：如果找到指定的字符则返回该字符所在地址，否则返回 0。
- 相关函数：index，memchr，rindex，strpbrk，strsep，strspn，strstr，strtok

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *s = "0123456789012345678901234567890";
    char *p;
    p = strpbrk(s, "a1 839"); /* 1会最先在s字符串中找到 */
    printf("%s\n", p);
    p = strpbrk(s, "4398");    /* 3会最先在s字符串中找到*/
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
123456789012345678901234567890
3456789012345678901234567890
```


strrchr
---------------------------------------------

查找字符串中最后出现的指定字符

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strrchr(const char *s, int c);
```

- 说明：strrchr() 用来找出参数 s 字符串中最后一个出现的参数 c 地址，然后将该字符出现的地址返回。
- 返回值：如果找到指定的字符则返回该字符所在地址，否则返回 0。
- 相关函数：index，memchr，rindex，strpbrk，strsep，strspn，strstr，strtok

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char *s = "0123456789012345678901234567890";
    char *p;
    p = strrchr(s, '5');
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
567890
```


strspn
---------------------------------------------

返回字符串中连续不含指定字符串内容的字符数

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
size_t strspn(const char *s, const char *accept);
```

- 说明：strspn() 从参数 s 字符串的开头计算连续的字符，而这些字符都完全是 accept 所指字符串中的字符。简单来说，若 strspn() 返回的数值为 n，则代表字符串 s 开头连续有 n 个字符都是属于字符串 accept 内的字符。
- 返回值：返回字符串 s 开头连续包含字符串 accept 内的字符数目。
- 相关函数：strcspn，strchr，strpbrk，strsep，strstr

**示例**

```c
#include <stdio.h>
#include<string.h>

int main()
{
    char *str = "Linux was first developed for 386/486-based PCs.";
    char *t1 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    printf("%d\n", strspn(str, t1));
    return 0;
}
```

执行

```shell
5    # 计算大小写字母。不包含 " "，所以返回 Linux 的长度
```


strstr
---------------------------------------------

在一字符串中查找指定的字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strstr(const char *haystack, const char *needle);
```

- 说明：strstr() 会从字符串 haystack 中搜寻字符串 needle，并将第一次出现的地址返回。
- 返回值：返回指定字符串第一次出现的地址，否则返回 0。
- 相关函数：index，memchr，rindex，strchr，strpbrk，strsep，strspn，strtok

**示例**

```c
#include <stdio.h>
#include<string.h>

int main()
{
    char * s = "012345678901234567890123456789";
    char *p;
    p = strstr(s, "901");
    printf("%s\n", p);
    return 0;
}
```

执行

```shell
901234567890123456789
```


strtok
---------------------------------------------

分隔字符串

**头文件**

```c
#include <string.h>
```

**函数原型**

```c
char *strtok(char *s, const char *delim);
```

- 说明：strtok() 用来将字符串分割成一个个片段。参数 s 指向欲分割的字符串，参数 delim 则为分割字符串，当 strtok() 在参数 s 的字符串中发现到参数 delim 的分割字符时则会将该字符改为 '\0' 字符。在第一次调用时，strtok() 必需给予参数 s 字符串，往后的调用则将参数 s 设置成 NULL。每次调用成功则返回下一个分割后的字符串指针。
- 返回值：返回下一个分割后的字符串指针，如果已无从分割则返回 NULL。
- 相关函数：index，memchr，rindex，strpbrk，strsep，strspn，strstr

**示例**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char s[] = "ab-cd : ef;gh :i-jkl;mnop;qrs-tu: vwx-y;z";
    char *delim = "-: ";
    char *p;

    printf("%s\n", s);
    printf("%s ", strtok(s, delim));
    while((p = strtok(NULL, delim)))
        printf("%s\n", p);

    return 0;
}
```

执行

```shell
ab-cd : ef;gh :i-jkl;mnop;qrs-tu: vwx-y;z
# '-' 和 ':' 字符已经被 '\0' 字符取代
ab cd
ef;gh
i
jkl;mnop;qrs
tu
vwx
y;z
```

