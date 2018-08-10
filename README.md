## Havoc Hypervisor

Aims to use the [Bareflank](https://github.com/bareflank/hypervisor) SDK
to create a fully-functional hyperivsor.

### Usage
Only GCC on Linux is supported at the moment. Havoc is an extension of
Bareflank, so it uses Bareflank's build system. The following example
demonstrates how to create a simple guest image with havoc.

```
mkdir -p $HOME/bareflank/initramfs/usr
cd $HOME/bareflank/initramfs/usr
```

Now create a `hello.c` to run as our init process; something like
```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    while (1) {
        printf("hello\n");
        sleep(1);
    }
}
```

Compile `hello.c` in `initramfs/usr` with
```
gcc -static hello.c -o hello
```

Now clone `havoc` and `hypervisor` to build the image. Note that even with the
minimal config used, the kernel still takes a bit to compile. If make appears
to be hung, run `top` to see if gcc is running. If it is then it should
complete in a reasonable amount of time. If it's not running, that's a bug.
```
cd $HOME/bareflank
git clone https://github.com/bareflank/hypervisor.git
git clone https://github.com/connojd/havoc.git
mkdir build
cd build
cmake ../hypervisor -DEXTENSION=../havoc -DLINUX_INITRAMFS_ROOT=$HOME/bareflank/initramfs/
make linux_x86_64-userspace-elf
```

Once `make` completes you should be able to test out the kernel with qemu:
```
qemu-system-x86_64 -kernel depends/linux/x86_64-userspace-elf/build/arch/x86_64/boot/bzImage
```

With any luck, the kernel will boot and you will see hello.c in action
on qemu's serial console.

### Customization
The above example can be modified to suit your needs. For example, if you
already have an initramfs image, you can set the `LINUX_INITRAMFS_IMAGE` CMake
variable to the path of the image.

If you don't have an existing image, havoc provides a mechanism to build
your own. The CMake variables of interest are
  - `LINUX_CONFIG_IN` is the path to a kernel `.config` file. The build
    will pass this config to the kernel before making it. It may be customized
    during CMake configuration time by adding @VAR@ to config items of
    interest, where VAR is a CMake variable identifier. The default
    `tiny.config.in` uses `CONFIG_INITRAMFS_SOURCE="@LINUX_INITRAMS_SOURCE"`
    where `LINUX_INITRAMFS_SOURCE` is determined at configure time.
  - `LINUX_INITRAMFS_IN` is the path to a "initramfs list", which is a
     basic text file the kernel uses to generate an initramfs. Note
     that any `file` line in this file must resolve to a full path
     at configure time.
