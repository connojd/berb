## Havoc Hypervisor

Aims to use the [Bareflank](https://github.com/bareflank/hypervisor) SDK
to create a fully-functional hyperivsor.

### Supported Systems
  - Linux
  - Windows Subsystem for Linux (WSL)

### Usage
Havoc is an extension of Bareflank, so it uses Bareflank's build system. The
following example demonstrates how to create a simple guest image with havoc.

> **NOTE**: If using WSL, run `setup-wsl.sh` before running the commands below

CMake will download and decompress Linux into `${CACHE_DIR}`. Be patient, the
decompression takes a while, especially on WSL, and even with the minimal
config used, the kernel still takes a bit to compile. Note that CMake doesn't
output anything during these times. The following commands assume havoc has
been cloned into `$HOME/bareflank`.
```
cd $HOME/bareflank
git clone https://github.com/bareflank/hypervisor.git
mkdir build
cd build
cmake ../hypervisor -DCACHE_DIR=../cache -DEXTENSION=../havoc
make linux_x86_64-userspace-elf
```

Once `make` completes you can test the kernel with `qemu`:
```
qemu-system-x86_64 -kernel depends/linux/x86_64-userspace-elf/build/arch/x86_64/boot/bzImage
```

With any luck, the kernel will boot and you will see the `init` process
repeatedly saying "hello" from qemu's serial console. The source and binary for
the `init` process is under the `initramfs` directory.

### Customization
The above example can be modified to suit your needs. If you don't have an
existing image, havoc provides a mechanism to build your own. The CMake
variables of interest are:
  - `LINUX_CONFIG_IN` is the path to a kernel `.config` file. The build
    will pass this config to the kernel before `make`ing it. It may be customized
    during CMake configuration time by adding `@VAR@` to config items of
    interest, where `VAR` is a CMake variable identifier. The default
    `config/linux/tiny.config.in` only uses
    `CONFIG_INITRAMFS_SOURCE="@LINUX_INITRAMS_SOURCE@"` where
    `LINUX_INITRAMFS_SOURCE` is a CMake variable determined at configure time.
  - `LINUX_INITRAMFS_IN` is the path to a "initramfs list", which is a
     basic text file the kernel uses to generate an initramfs. Note
     that any `file` line must resolve to a full path at configure time. Please
     see `usr/gen_init_cpio.c` in the kernel tree for more details.
     The default is `config/linux/tiny.initramfs.in`.
  - `LINUX_INITRAMFS_IMAGE` is the full path to an existing initramfs to be
     embedded into the kernel. If this is set, then `LINUX_INITRAMFS_IN` will
     be ignored.
