#include <stdio.h>
#include <unistd.h>

int main()
{
    volatile int one = 1;
    while (one) {
        printf("hello\n");
        sleep(1);
    }
}
