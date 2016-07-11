
If you build gmp/mpfr/mpc inside of gcc source tree; then you have to apply following patches:

  gcc-4.9.2-fixinc-gmp-inside.patch
  gcc-4.9.2-gmp-inside.patch

If you use system installed gmp/mpfr/mpc/cloog, then you have to apply other patches:

  gcc-4.9.2-fixinc-gmp-outside.patch
  gcc-4.9.2-x86_64-multilib.patch


Ada CCACHE:
==========
  gcc-4.9.2-ccache-ada.patch - gnatmake/gnatlink not correct parses --GCC="..." options
                               If you will use --GCC="ccache gcc --someflags" then these
                               utilites deside that CC=ccache and CFLAGS="gcc --someflags".
                               This patch created especialy for building ada/tools without
                               ccache in case when whole build system uses ccache as well.
                               If you applay this patch then you have to export two variables
                               from your Makefile (which builds GCC):

                                 export GCC_FOR_GNAT      = $(CROSS_COMPILE)gcc --sysroot=$(TARGET_DEST_DIR)
                                 export GCC_LINK_FOR_GNAT = $(CROSS_COMPILE)g++ --sysroot=$(TARGET_DEST_DIR)

                               without $(CCACHE) before $(CROSS_COMPILE)gcc/g++ .
