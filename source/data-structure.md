数据结构及算法篇
=============================================

crypt
---------------------------------------------

将密码或数据编码

头文件 `#include <crypt.h>`

函数原型

```c
char *crypt(const char *key, const char *salt);
```

- 说明：crypt() 将使用 Data Encryption Standard(DES) 演算法将参数 key 所指的字符串加以编码，key 字符串长度仅取前 8 个字符，超过此长度的字符没有意义。参数 salt 为两个字符组成的字符串，由 a-z、A-Z、0-9，"." 和 "/" 所组成，用来决定使用 4096 种不同内建表格的哪一个。函数执行成功后会返回指向编码过的字符串指针，参数 key 所指的字符串不会有所更动。编码过的字符串长度为 13 个字符，前两个字符为参数 salt 代表的字符串。
- 返回值：返回一个指向 NULL 结尾的密码字符串。
- 附加说明：使用 GCC 编译时需加 -lcrypt。
- 相关函数：getpass

示例

```c
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main()
{
    char passwd[13];
    char *key;
    char slat[2];
    key = getpass("Input First Password: ");
    slat[0] = key[0];
    slat[1] = key[1];
    strcpy(passwd, crypt(key, slat));
    key = getpass("Input Second Password: ");
    slat[0] = passwd[0];
    slat[1] = passwd[1];
    printf("After crypt(), 1st passwd: %s\n", passwd);
    printf("After crypt(), 2nd passwd: %s\n", crypt(key, slat));
    return 0;
}
```

执行

```shell
Input First Password:   # 输入test，编码后存于passwd数组
Input Second Password:  # 输入test，密码相同编码后也会相同
After crypt(), 1st passwd: teH0wLIpW0gyQ
After crypt(), 2nd passwd: teH0wLIpW0gyQ
```


bsearch
---------------------------------------------

二元搜索

头文件 `#include <stdlib.h>`

函数原型

```c
void *bsearch(const void *key, const void *base, size_t nmemb,
              size_tsize, int (*compar)(const void*,const void*));
```

- 说明：bsearch() 利用二元搜索从排好序的数组中查找数据。参数 key 指向欲查找的关键数据，参数 base 指向要被搜索的数组开头地址，参数 nmemb 代表数组中的元素数量，每一元素的大小则由参数 size 决定，最后一项参数 compar 为一函数指针，这个函数用来判断两个元素之间的大小关系，若传给 compar 的第一个参数所指的元素数据大于第二个参数所指的元素数据则必须回传大于 0 的值，两个元素数据相等则回传 0。
- 返回值：找到关键数据则返回找到的地址，如果在数组中找不到关键数据则返回 NULL。
- 相关函数：qsort

示例

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define NMEMB 5
#define SIZE 10

int compar(const void *a, const void *b)
{
    return (strcmp((char *)a, (char *)b));
}

int main()
{
    char data[50][SIZE] = {"linux","freebsd","solaris","sunos","windows"};
    char key[80], *base, *offset;
    int i, nmemb=NMEMB, size=SIZE;
    while(1) {
        printf("> ");
        fgets(key,sizeof(key), stdin);
        key[strlen(key)-1] = '\0';
        if (!strcmp(key, "exit"))
            break;
        if (!strcmp(key, "list")) {
            for(i=0; i<nmemb; i++)
                printf("%s\n", data[i]);
            continue;
        }
        base = data[0];
        qsort(base, nmemb, size, compar);
        offset = (char *)bsearch(key, base, nmemb, size, compar);
        if (offset == NULL) {
            printf("%s not found!\n", key);
            strcpy(data[nmemb++], key);
            printf("Add %s to data array\n", key);
        } else {
            printf("found: %s \n", offset);
        }
    }
}
```

执行

```shell
> hello                   # 输入 hello 字符串
hello not found!          # 找不到 hello 字符串
Add hello to data array   # 将 hello 字符串加入到数组
> list                    # 列出所有数据
freebsd
linux
solaris
sunos
windows
hello
> hello                   # 再次搜索 hello 字符串
found: hello
```


lfind
---------------------------------------------

线性搜索

头文件 `#include <search.h>`

函数原型

```c
void *lfind (const void *key, const void *base, size_t *nmemb,
             size_t size, int(*compar)(const void *, const void *));
```

- 说明：lfind() 利用线性搜索在数组中从头至尾一项项查找数据。参数 key 指向欲查找的关键数据，参数 base 指向要被搜索的数组开头地址，参数 nmemb 代表数组中的元素数量，每一元素的大小则由参数 size 决定，最后一项参数 compar 为一函数指针，这个函数用来判断两个元素是否相同，若传给 compar 的第一个参数所指的元素数据和第二个参数所指的元素数据相同时则返回 0，两个元素数据不相同则返回非 0 值。lfind() 与 lsearch() 的不同点在于，当找不到关键数据时 lfind() 仅会返回 NULL，而不会主动把该笔数据加入数组尾端。
- 返回值：找到关键数据则返回找到的该笔元素的地址，如果在数组中找不到关键数据则返回空指针 NULL。
- 相关函数：lsearch

示例

参考 [lsearch()](#lsearch)


lsearch
---------------------------------------------

线性搜索

头文件 `#include <search.h>`

函数原型

```c
void *lsearch(const void *key, const void *base, size_t *nmemb,
              size_t size, int (* compar)(const void *, const void *));
```

- 说明：lsearch() 利用线性搜索在数组中从头至尾一项项查找数据。参数 key 指向欲查找的关键数据，参数 base 指向要被搜索的数组开头地址，参数 nmemb 代表数组中的元素数量，每一元素的大小则由参数 size 决定，最后一项参数 compar 为一函数指针，这个函数用来判断两个元素是否相同，若传给 compar 的第一个参数所指的元素数据和第二个参数所指的元素数据相同时则返回 0，两个元素数据不相同则返回非 0 值。如果 lsearch() 找不到关键数据时会主动把该项数据加入数组里。
- 返回值：找到关键数据则返回找到的该笔元素的地址，如果在数组中找不到关键数据则将此关键数据加入数组，再把加入数组后的地址返回。
- 相关函数：lfind

示例

```c
#include <stdio.h>
#include <string.h>
#include <search.h>
#define NMEMB 50
#define SIZE 10

int compar (const void *a, const void *b)
{
    return (strcmp((char *) a, (char *) b));
}

int main()
{
    char data[NMEMB][SIZE] = {"linux","freebsd","solaris","sunos","windows"};
    char key[80], *base, *offset;
    long unsigned int nmemb=NMEMB, size=SIZE;
    for (int i=1; i<5; i++) {
        fgets(key, sizeof(key), stdin);
        key[strlen(key)-1] = '\0';
        base = data[0];
        offset = (char *)lfind(key, base, &nmemb, size, compar);
        if (offset == NULL){
            printf("%s not found!\n", key);
            offset = (char *) lsearch(key, base, &nmemb, size, compar);
            printf("Add %s to data array\n", offset);
        } else {
            printf("found : %s \n", offset);
        }
    }
}
```

执行

```shell
linux
found:linux
os/2
os/2 not found!
add os/2 to data array
os/2
found:os/2
```


qsort
---------------------------------------------

利用快速排序法排列数组

头文件 `#include <stdlib.h>`

函数原型

```c
void qsort(void *base, size_t nmemb, size_t size, 
           int ( * compar)(const void *, const void *));
```

- 说明：参数 base 指向欲排序的数组开头地址，参数 nmemb 代表数组中的元素数量，每一元素的大小则由参数 size 决定，最后一项参数 compar 为一函数指针，这个函数用来判断两个元素间的大小关系，若传给 compar 的第一个参数所指的元素数据大于第二个参数所指的元素数据则必须返回大于零的值，两个元素数据相等则返回 0。
- 返回值：无
- 相关函数：bsearch

示例

```c
#include <stdio.h>
#include <stdlib.h>
#define NMEMB 7

int compar (const void *a, const void *b)
{
    int *aa = (int *) a, *bb = (int *)b;
    if( *aa > *bb) return 1;
    if( *aa == *bb) return 0;
    if( *aa < *bb) return -1;
}

int main( )
{
    int base[NMEMB] = {3, 102, 5, -2, 98, 52, 18};
    int i;
    for ( i=0; i<NMEMB;i++)
        printf("%d ", base[i]);
    printf("\n");
    qsort(base, NMEMB, sizeof(int), compar);
    for(i=0; i<NMEMB; i++)
        printf("%d ", base[i]);
    printf("\n");
}
```

执行

```shell
3 102 5 -2 98 52 18
-2 3 5 18 52 98 102
```


rand
---------------------------------------------

产生随机数

头文件 `#include <stdlib.h>`

函数原型

```c
int rand(void);
```

- 说明：rand() 会返回一随机数值，范围在 0 至 RAND_MAX 之间。在调用此函数产生随机数前，必须先利用 srand() 设好随机数种子，如果未设随机数种子，rand() 在调用时会自动设随机数种子为 1。关于随机数粽子请参考 srand()。
- 返回值：返回 0 至 RAND_MAX 之间的随机数值，RAND_MAX 定义在 stdlib.h，其值为 2147483647。
- 相关函数：srand，random，srandom

示例

```c
/* 产生介于1到10的随机数值，本示例未设置随机数种子，完整的随机数产生请参考 srand() */
#include <stdio.h>
#include <stdlib.h>

int main()
{
    int i, j;
    for(i=0; i<10; i++) {
        j = 1+(int)(10.0*rand()/(RAND_MAX+1.0));
        printf("%d ", j);
    }
}
```

执行

```shell
9 4 8 8 10 2 4 8 3 6
9 4 8 8 10 2 4 8 3 6
```


srand
---------------------------------------------

设置随机数种子

头文件 `#include <stdlib.h>`

函数原型

```c
void srand (unsigned int seed);
```

- 说明：srand()用來設置rand()產生隨機數時的隨機數種子。參數seed必須是個整數，通常可以利用geypid()或time(0)的返回值來當做seed。如果每次seed都設相同值，rand()所產生的隨機數值每次就會一樣。
- 返回值：无
- 相关函数：rand，random srandom

示例

```c
/* 产生介于1到10之间的随机数值，本示例与执行结果可与 rand() 参照 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
    int i,j;
    srand((int)time(0));
    for(i=0; i<10; i++) {
        j=1+(int)(10.0*rand()/(RAND_MAX+1.0));
        printf("%d ", j);
    }
}
```

执行

```shell
5 8 8 8 10 2 10 8 9 9
2 9 7 4 10 3 2 10 8 7
```

