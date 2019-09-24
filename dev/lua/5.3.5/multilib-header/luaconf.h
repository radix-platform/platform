
/*****************************
  luaconf.h - Multilib Header
 *****************************/

#ifndef __MULTILIB__LUACONF_H__
#define __MULTILIB__LUACONF_H__

#if defined(__x86_64__)    || \
    defined(__sparc64__)   || \
    defined(__arch64__)    || \
    defined(__powerpc64__) || \
    defined (__s390x__)
#include "luaconf-64.h"
#else
#include "luaconf-32.h"
#endif

#endif /* __MULTILIB__LUACONF_H__ */
