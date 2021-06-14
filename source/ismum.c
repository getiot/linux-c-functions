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
