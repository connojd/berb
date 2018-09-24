## ERB

ERB strives to provide a simple, convenient way to build guest images
for the [Bareflank hypervisor](https://github.com/bareflank/hypervisor.git).
The two main dependencies are [crosstool-ng](https://github.com/crosstool-ng/crosstool-ng)
and [buildroot](https://buildroot.org). ERB is essentially a wrapper
over those two tools that integrates with Bareflank's CMake-based build system.

### Supported Systems
  - Arch Linux
  - Ubuntu 18.04
  - Windows Subsystem for Linux (WSL)

### Usage
ERB can be used to build both a cross-compiler and/or a bootable Linux OS image.
If you already have a cross-compiler that targets your image's system, then
you can give the path to cmake with `-DCT_PREFIX_DIR="path to compiler"`.
Note that Buildroot expects to find the compiler under `${CT_PREFIX_DIR}/bin`.

The following CMake variables allow the user to configure their build:

  - `IMAGE`: select from "tiny" or "xenstore". This is the image to create.
    Tiny is a minimal linux+userspace, whereas xenstore is a minimal dom0
    with the Xen toolstack installed
  - `CT_TUPLE`: the target tuple of the cross-compiler to build. The default
    is x86_64-unknown-linux-gnu
  - `CT_PREFIX_DIR`: the *absolute* path to the prefix of the cross-compiler
  - `BUILD_TOOLS_ONLY`: only build the cross-compiler
  - `BR2_ROOTFS_OVERLAY`: a root filesystem that Buildroot will overlay onto
     the final image. This is useful to add custom-built projects to the image.
     For example, the xenstore image overlays the rootfs with the tree under
     `${XEN_BUILD_DIR}/dist/install`

If no `CT_PREFIX_DIR` is specified, then Buildroot will make its own
cross-compiler before building the image. By default, the toolchain will be
installed to `${CMAKE_BINARY_DIR}/../xtools/x86_64-unknown-linux-gnu`. This
location can then be specified to later invocations of `cmake` prior to building
guest images.

The following is a simple example to illustrate a typical workflow using ERB.
Assuming that ERB has been cloned into `$HOME/bareflank`:

```
cd $HOME/bareflank
git clone https://github.com/bareflank/hypervisor.git
mkdir build-tools
cd build-tools
cmake ../hypervisor -DCACHE_DIR=../cache -DEXTENSION=../erb -DBUILD_TOOLS_ONLY=ON
make tools
```

The above instructs ERB to build a cross-compiler. The default tuple is
`x86_64-unknown-linux-gnu`, and the toolchain will be installed to
`build-tools/../xtools/${CT_TUPLE}`. It will take around 25 minutes to build
the toolchain. Once it completes, we can build the "tiny" guest image with
our toolchain:

```
cd $HOME/bareflank
mkdir build-tiny
cd build-tiny
cmake ../hypervisor -DCACHE_DIR=../cache -DEXTENSION=../erb -DCT_PREFIX_DIR=$HOME/bareflank/xtools/<tuple>
make image
```

where \<tuple\> is the value of `${CT_TUPLE}`.
Once the image is made, you can test it out with qemu (the root password is `asdf`):

```
qemu-system-x86_64 -kernel depends/buildroot/x86_64-userspace-elf/build/tiny/arch/x86_64/boot/bzImage
```

With any luck, the kernel will boot and you will see the a process
repeatedly saying "hello" from the console. The source for that process
is found under `images/tiny/overlay`

### Customization
While there are two officially supported images (for now), you can create new ones
if you wish. ERB takes three files that are parametrized with CMake variables;
you can add or change them as needed. These files are the various '*.config.in'
under the images and tools directories:

  - `tools/x86_64-unknown-linux-gnu/crosstool.config.in` is the path to crosstool's
    `.config` file for the `x86_64-unknown-linux-gnu` tuple.
  - `images/tiny/linux.config.in` is the path to the tiny image's kernel
  - `images/tiny/buildroot.config.in` is the path to the tiny image's rootfs
  - `images/xenstore/linux.config.in` is the path to the xenstore image's kernel
  - `images/xenstore/buildroot.config.in` is the path to the xenstore image's rootfs

For every file above, ERB will replace all values of the form `@VAR@` with the
corresponding value of the `VAR` cmake variable. Other files of interest
are the "fakeroot hooks", found under each image directory. These are scripts
that Buildroot executes with the first argument being the path to the rootfs. This
allows for customizations (e.g. systemd services) prior to creating the final,
compressed image. Note that Buildroot can execute hooks at three different
stages; fakeroot is in the middle. Please see the Buildroot documentation for
more information.
