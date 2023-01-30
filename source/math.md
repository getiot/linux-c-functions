常用数学函数篇
=============================================

abs
---------------------------------------------

计算整型数的绝对值

**头文件**

```c
#include <stdlib.h>
```

**函数原型**

```c
int abs (int j);
```

- 说明：abs() 用来计算参数 j 的绝对值，然后将结果返回。
- 返回值：返回参数 j 的绝对值结果。
- 相关函数：labs, fabs

**示例**

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
    int answer;
    answer = abs(-12);
    printf("|-12| = %d\n", answer);
    return 0;
}
```

执行

```shell
|-12| = 12
```


acos
---------------------------------------------

取反余弦函数数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double acos (double x);
```

- 说明：acos() 用来计算参数x的反余弦值，然后将结果返回。参数 x 范围为 -1 至 1 之间，超过此范围则会失败。
- 返回值：返回 0 至 PI 之间的计算结果，单位为弧度，在函数库中角度均以弧度来表示。错误代码：
  - `EDOM`：参数 x 超出范围。

- 附加说明：使用 GCC 编译时请加入 `-lm`。
- 相关函数：asin , atan , atan2 , cos , sin , tan

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
    double angle;
    angle = acos(0.5);
    printf("angle = %f\n", angle);
    return 0;
}
```

执行

```bash
angle = 1.047198
```


asin
---------------------------------------------

取反正弦函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double asin (double x);
```

- 说明：asin() 用来计算参数x的反正弦值，然后将结果返回。参数 x 范围为 -1 至 1 之间，超过此范围则会失败。
- 返回值：返回 -PI/2 至 PI/2 之间的计算结果。错误代码：
  - `EDOM`：参数 x 超出范围

- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：acos , atan , atan2 , cos , sin , tan

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double angle;
	angle = asin (0.5);
	printf("angle = %f\n", angle);
    return 0;
}
```

执行

```shell
angle = 0.523599
```


atan
---------------------------------------------

取反正切函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double atan(double x);
```

- 说明：atan() 用来计算参数 x 的反正切值，然后将结果返回。
- 返回值：返回 -PI/2 至 PI/2 之间的计算结果。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：acos，asin，atan2，cos，sin，tan

示例

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double angle;
	angle =atan(1);
	printf("angle = %f\n", angle);
    return 0;
}
```

执行

```shell
angle = 1.570796
```


atan2
---------------------------------------------

取得反正切函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double atan2(double y, double x);
```

- 说明：atan2() 用来计算参数 y/x 的反正切值，然后将结果返回。
- 返回值：返回 -PI/2 至 PI/2 之间的计算结果。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：acos，asin，atan，cos，sin，tan

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double angle;
	angle = atan2(1,2);
	printf("angle = %f\n", angle);
    return 0;
}
```

执行

```shell
angle = 0.463648
```


ceil
---------------------------------------------

取不小于参数的最小整型数

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double ceil(double x);
```

- 说明：ceil() 会返回不小于参数 x 的最小整数值，结果以 double 形态返回。
- 返回值：返回不小于参数 x 的最小整数值。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：fabs

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double value[ ]={4.8,1.12,-2.2,0};
	int i;
	for (i=0;value[i]!=0;i++)
        printf("%f => %f\n",value[i],ceil(value[i]));
    return 0;
}
```

执行

```shell
4.800000 => 5.000000
1.120000 => 2.000000
-2.200000 => -2.000000
```


cos
---------------------------------------------

取余玄函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double cos(double x);
```

- 说明：cos() 用来计算参数 x 的余玄值，然后将结果返回。
- 返回值：返回 -1 至 1 之间的计算结果。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：acos，asin，atan，atan2，sin，tan

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer = cos(0.5);
	printf("cos (0.5) = %f\n",answer);
    return 0;
}
```

执行

```shell
cos(0.5) = 0.877583
```


cosh
---------------------------------------------

取双曲线余玄函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double cosh(double x);
```

- 说明：cosh() 用来计算参数 x 的双曲线余玄值，然后将结果返回。数学定义式为 (exp(x)+exp(-x))/2。
- 返回值：返回参数x的双曲线余玄值。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：sinh，tanh

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer = cosh(0.5);
	printf("cosh(0.5) = %f\n",answer);
    return 0;
}
```

执行

```shell
cosh(0.5) = 1.127626
```


exp
---------------------------------------------

计算指数

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double exp(double x);
```

- 说明：exp() 用来计算以 e 为底的 x 次方值，即 ex 值，然后将结果返回。
- 返回值：返回 e 的 x 次方计算结果。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：log，log10，pow

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer;
	answer = exp (10);
	printf("e^10 =%f\n", answer);
    return 0;
}
```

执行

```shell
e^10 = 22026.465795
```


frexp
---------------------------------------------

将浮点型数分为底数与指数

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double frexp( double x, int *exp);
```

- 说明：frexp() 用来将参数 x 的浮点型数切割成底数和指数。底数部分直接返回，指数部分则借参数 exp 指针返回，将返回值乘以 2 的 exp 次方即为 x 的值。
- 返回值：返回参数 x 的底数部分，指数部分则存于 exp 指针所指的地址。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：ldexp，modf

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	int exp;
	double fraction;
	fraction = frexp (1024, &exp);
	printf("exp = %d\n", exp);
	printf("fraction = %f\n", fraction);
    return 0;
}
```

执行

```shell
exp = 11
fraction = 0.500000 # 0.5*(2^11)=1024
```


ldexp
---------------------------------------------

计算 2 的次方值

**头文件**

```c
#include<math.h>
```

**函数原型**

```c
double ldexp(double x, int exp);
```

- 说明：ldexp() 用来将参数 x 乘上 2 的 exp 次方值，即 x*2exp。
- 返回值：返回计算结果。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：frexp

**示例**

```c
/* 计算3*(2^2)＝12 */
#include <stdio.h>
#include <math.h>

int main()
{
	int exp;
	double x,answer;
	answer = ldexp(3,2);
	printf("3*2^(2) = %f\n",answer);
    return 0;
}
```

执行

```shell
3*2^(2) = 12.000000
```


log
---------------------------------------------

计算以 e 为底的对数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double log (double x);
```

- 说明：log() 用来计算以 e 为底的 x 对数值，然后将结果返回。

- 返回值：返回参数 x 的自然对数值。

  错误代码：

  - `EDOM` 参数 x 为负数
  - `ERANGE` 参数 x 为零值，零的对数值无定义

- 附加说明：使用 GCC 编译时请加入 `-lm`

- 相关函数：exp，log10，pow

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer;
	answer = log (100);
	printf("log(100) = %f\n",answer);
    return 0;
}
```

执行

```shell
log(100) = 4.605170
```


log10
---------------------------------------------

计算以 10 为底的对数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double log10(double x);
```

- 说明：log10() 用来计算以 10 为底的x对数值，然后将结果返回。

- 返回值：返回参数 x 以 10 为底的对数值。

  错误代码：

  - `EDOM` 参数 x 为负数
  - `ERANGE` 参数 x 为零值，零的对数值无定义

- 附加说明：使用 GCC 编译时请加入 `-lm`

- 相关函数：exp，log，pow

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer;
	answer = log10(100);
	printf("log10(100) = %f\n", answer);
    return 0;
}
```

执行

```shell
log10(100) = 2.000000
```


pow
---------------------------------------------

计算次方值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double pow(double x, double y);
```

- 说明：pow() 用来计算以 x 为底的 y 次方值，即 xy 值，然后将结果返回。

- 返回值：返回 x 的 y 次方计算结果。

  错误代码：

  - `EDOM` 参数 x 为负数且参数 y 不是整数。

- 附加说明：使用 GCC 编译时请加入 `-lm`

- 相关函数：exp，log，log10

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer;
	answer =pow(2,10);
	printf("2^10 = %f\n", answer);
    return 0;
}
```

执行

```shell
2^10 = 1024.000000
```


sin
---------------------------------------------

取正玄函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double sin(double x);
```

- 说明：sin() 用来计算参数 x 的正玄值，然后将结果返回。
- 返回值：返回 -1 至 1 之间的计算结果。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：acos，asin，atan，atan2，cos，tan

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer = sin (0.5);
	printf("sin(0.5) = %f\n",answer);
    return 0;
}
```

执行

```shell
sin(0.5) = 0.479426
```


sinh
---------------------------------------------

取双曲线正玄函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double sinh( double x);
```

- 说明：sinh() 用来计算参数 x 的双曲线正玄值，然后将结果返回。数学定义式为 (exp(x)-exp(-x))/2。
- 返回值：返回参数 x 的双曲线正玄值。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：cosh，tanh

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer = sinh (0.5);
	printf("sinh(0.5) = %f\n",answer);
    return 0;
}
```

执行

```shell
sinh(0.5) = 0.521095
```


sqrt
---------------------------------------------

计算平方根值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double sqrt(double x);
```

- 说明：sqrt() 用来计算参数 x 的平方根，然后将结果返回。参数 x 必须为正数。

- 返回值：返回参数 x 的平方根值。

  错误代码：

  - `EDOM` 参数 x 为负数。

- 附加说明：使用 GCC 编译时请加入 `-lm`

- 相关函数：hypotq

**示例**

```c
/* 计算200的平方根值*/
#include <stdio.h>
#include <math.h>

int main()
{
	double root;
	root = sqrt (200);
	printf("answer is %f\n",root);
    return 0;
}
```

执行

```shell
answer is 14.142136
```


tan
---------------------------------------------

取正切函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double tan(double x);
```

- 说明：tan() 用来计算参数 x 的正切值，然后将结果返回。
- 返回值：返回参数 x 的正切值。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：atan，atan2，cos，sin

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
	double answer = tan(0.5);
	printf("tan (0.5) = %f\n",answer);
    return 0;
}
```

执行

```shell
tan(0.5) = 0.546302
```


tanh
---------------------------------------------

取双曲线正切函数值

**头文件**

```c
#include <math.h>
```

**函数原型**

```c
double tanh(double x);
```

- 说明：tanh() 用来计算参数x的双曲线正切值，然后将结果返回。数学定义式为 sinh(x)/cosh(x)。
- 返回值：返回参数 x 的双曲线正切值。
- 附加说明：使用 GCC 编译时请加入 `-lm`
- 相关函数：cosh，sinh

**示例**

```c
#include <stdio.h>
#include <math.h>

int main()
{
    double answer = tanh(0.5);
    printf("tanh(0.5) = %f\n",answer);
    return 0;
}
```

执行

```shell
tanh(0.5) = 0.462117
```

