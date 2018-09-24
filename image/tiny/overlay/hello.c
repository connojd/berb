#include <string.h>
#include <stdint.h>
#include <stdio.h>

#define STRLEN 4096

char *msg[5] = {"hello", "darkness", "my", "old", "friend"};

void set_str(char *str)
{
    static uint64_t i = 0;
    memset(str, 0, STRLEN);
    sprintf(str, "%s\n", msg[i++ % 5]);
}

int main()
{
    char str[4096];

    while (1) {
        set_str(str);
        __asm__ volatile(
            "xorq %%rax, %%rax\n\t"
            "xorq %%rbx, %%rbx\n\t"
            "movq %0, %%rax\n\t"
            "movq %1, %%rbx\n\t"
            "vmcall\n\t"
            :
            : "g"(str), "g"(STRLEN)
            :
        );
    }
}
