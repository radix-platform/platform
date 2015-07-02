
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <hello.h>

void print_msg( char *s )
{
   void *libc_handle = (void *)0;
   int (*printf_call)(const char *format, ...);
   char *error;

   /******************************************
      /lib/libc.so.6   - 32bit GNU C Library
      /lib64/libc.so.6 - 64bit GNU C Library
    ******************************************/
#if __HARDWARE__ ==  PC32
   libc_handle = dlopen( "/lib/libc.so.6", RTLD_LAZY );
#else
   libc_handle = dlopen( "/lib64/libc.so.6", RTLD_LAZY );
#endif
   if( !libc_handle )
   {
     fprintf( stderr, "ERROR: %s\n", dlerror() );
     exit( 1 );
   }

   printf_call = dlsym( libc_handle, "printf" );
   if( (error = dlerror()) != NULL )
   {
     fprintf( stderr, "ERROR: %s\n", error );
     exit( 1 );
   }

#if defined( __FLAVOUR__ )
   if( !strcmp( "de", __FLAVOUR__ ) )
   {
      (*printf_call)( "\n%s: Hallo, %s!\n\n", __FLAVOUR__, s );
   }
   else if( !strcmp( "fr", __FLAVOUR__ ) )
   {
      (*printf_call)( "\n%s: Bonjour, %s!\n\n", __FLAVOUR__, s );
   }
   else
   {
      (*printf_call)( "\n%s: Hello, %s!\n\n", "unknown", s );
   }
#else
   (*printf_call)( "\nHello, %s!\n\n", s );
#endif

   dlclose( libc_handle );

   return;
}
