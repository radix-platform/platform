
$ cp <kernel_src_dir>/arch/arm/configs/omap2plus_defconfig <kernel_src_dir>/.config
$ cd <kernel_src_dir>/
$ ARCH=arm make menuconfig
$ ARCH=arm make oldconfig
$ cp .config <build_dir>/omap5evm.config
