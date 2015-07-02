
#include <stdlib.h>
#include <stdio.h>

int main()
{
#if FLAVOUR == 32
   printf( "\nHello, World! (for build machine x86_32 compat)\n\n" );
#else
   printf( "\nHello, World!\n\n" );
#endif
   return( 0 );
}
