#define _GNU_SOURCE

#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <sched.h>
#include <sys/sysinfo.h>
#include <sys/types.h>

#define STRLEN 4096

char *msg[5] = {"hello", "darkness", "my", "old", "friend"};

int set_affinity(long int core)
{
    cpu_set_t mask;
    struct sysinfo info;
    sysinfo(&info);

    CPU_ZERO(&mask);
    CPU_SET(core, &mask);

    if (sched_setaffinity(0, sizeof(mask), &mask) != 0)
        return -1;

    return 0;
}

void set_str(char *str)
{
    static uint64_t i = 0;
    memset(str, 0, STRLEN);
    sprintf(str, "%s\n", msg[i++ % 5]);
}

void vmcall_write(char *str, long int core)
{
    while (1) {
        printf("core %d says: ", core);
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

void vmcall_write_parent(char *str0)
{
    if(set_affinity(0)) {
        printf("Failed to parent affinity to core 0\n");
        return;
    }

    vmcall_write(str0, 0);
}

void vmcall_write_child(char *str1)
{
    if(set_affinity(1)) {
        printf("Failed to set child affinity to core 1\n");
        return;
    }

    vmcall_write(str1, 1);
}

int main()
{
    char str0[4096];
    char str1[4096];

    int pid = fork();
    if (pid == 0) {
        vmcall_write_parent(str0);
    } else {
        vmcall_write_child(str1);
    }

    return 1;
}
