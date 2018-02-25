
#include <bits/wordsize.h>

#if   __WORDSIZE == 64
#include <gmp-64.h>
#elif __WORDSIZE == 32
#include <gmp-32.h>
#else
#error "unexpected value for __WORDSIZE macro"
#endif
