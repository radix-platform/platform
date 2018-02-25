
#include <bits/wordsize.h>

#if   __WORDSIZE == 64
#include <ppl-64.hh>
#elif __WORDSIZE == 32
#include <ppl-32.hh>
#else
#error "unexpected value for __WORDSIZE macro"
#endif
