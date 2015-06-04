
Conditionalise ARM asm on !__thumb__ (if cross GCC is built --with-mode=thumb):
==============================================================================

  gmp-6.0.0-arm-conditionalise-not-thumb.patch - Conditionalise ARM asm on !__thumb__.
                                                 If toolchain generates is thumb by default then
                                                 this patch should help with the new bug, in probably
                                                 in the assembler which mistakes plain old ARM
                                                 instructions for Thumb instructions, but possibly
                                                 the compiler passes some silly options to misdirect
                                                 the assembler. Error message without this patch:

      libtool: compile:
      /usr/bin/ccache /opt/toolchain/arm-OMAP543X-linux-glibc/1.0.9/bin/arm-omap543x-linux-gnueabihf-gcc
      --sysroot=/home/kx/prog/scm/svn/platform/branches/BS-external-190/dist/.omap543x-glibc/omap5uevm
      -DHAVE_CONFIG_H -I. -I../../gcc-4.9.2/gmp -D__GMP_WITHIN_GMP -I.
      -I/home/kx/prog/scm/svn/platform/branches/BS-external-190/dist/.omap543x-glibc/omap5uevm/usr/include
      -g -O3 -march=armv7-a -mtune=cortex-a15 -mfloat-abi=hard -mfpu=neon-vfpv4 -mabi=aapcs-linux
      -fomit-frame-pointer
      -D__OMAP543X_GLIBC__=1 -D__HARDWARE__=81 -DCB2X=21 -DB74=91 -DDRA7XXEVM=82 -DFFRK3288=B1 -DVIP1830=51
      -DVIP1830N=50 -DBEAGLE=71 -DCB1N=10 -DCB2N=20 -DCB3X=31 -DPC64=02 -DOMAP5UEVM=81 -DCB1X=11 -DPC32=01
      -DAT91S=40 -DCB3N=30 -DCI20=A1 -DL17UC=60
      -c mpn/div_qr_1n_pi1.c -o mpn/div_qr_1n_pi1.o
      /tmp/ccW0BUmL.s: Assembler messages:
      /tmp/ccW0BUmL.s:186: Error: thumb conditional instruction should be in IT block -- `movcc r8,#0'
      /tmp/ccW0BUmL.s:187: Error: thumb conditional instruction should be in IT block -- `movcs r8,#-1'
      /tmp/ccW0BUmL.s:217: Error: thumb conditional instruction should be in IT block -- `movcc r8,#0'
      /tmp/ccW0BUmL.s:218: Error: thumb conditional instruction should be in IT block -- `movcs r8,#-1'
      make[6]: *** [mpn/div_qr_1n_pi1.lo] Error 1
