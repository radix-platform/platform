
If you build gmp/mpfr/mpc inside of gcc source tree; then you have to apply following patches:

  gcc-4.8.2-fixinc-gmp-inside.patch
  gcc-4.8.2-gmp-inside.patch

If you use system installed gmp/mpfr/mpc/cloog, then you have to apply other patches:

  gcc-4.8.2-fixinc-gmp-outside.patch
  gcc-4.8.2-x86_64-multilib.patch
