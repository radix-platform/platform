/* libunwind - a platform-independent unwind library

   Coyright (c) 2014 Oracle Inc.
   Contributed by:
      Jose E. Marchesi <jose.marchesi@oracle.com>

This file is part of libunwind.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  */

#include <libunwind_i.h>

#ifdef UNW_REMOTE_ONLY

PROTECTED int
unw_init_local (unw_cursor_t *cursor, ucontext_t *uc)
{
  /* XXX: empty stub.  */
  return -UNW_EINVAL;
}

#else /* !UNW_REMOTE_ONLY */

PROTECTED int
unw_init_local (unw_cursor_t *cursor, ucontext_t *uc)
{
  struct cursor *c = (struct cursor *) cursor;
  int i, ret;

  if (!tdep_init_done)
    tdep_init ();

  Debug (1, "(cursor=%p)\n", c);

  c->dwarf.as = unw_local_addr_space;
  c->dwarf.as_arg = uc;

  for (i = UNW_SPARC64_FIRST_GPREG; i <= UNW_SPARC64_LAST_GPREG; i++)
    c->dwarf.loc[i] = DWARF_REG_LOC (&c->dwarf, i);

  for (i = UNW_SPARC64_FIRST_FPREG; i <= UNW_SPARC64_LAST_FPREG; i++)
    c->dwarf.loc[i] = DWARF_FPREG_LOC (&c->dwarf, i);

  c->dwarf.loc[UNW_SPARC64_FCC0] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_FCC0);
  c->dwarf.loc[UNW_SPARC64_FCC1] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_FCC1);
  c->dwarf.loc[UNW_SPARC64_FCC2] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_FCC2);
  c->dwarf.loc[UNW_SPARC64_FCC3] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_FCC3);

  c->dwarf.loc[UNW_SPARC64_ICC] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_ICC);
  c->dwarf.loc[UNW_SPARC64_SFP] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_SFP);
  c->dwarf.loc[UNW_SPARC64_GSR] = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_GSR);

  c->dwarf.loc[UNW_SPARC64_PC]  = DWARF_REG_LOC (&c->dwarf, UNW_SPARC64_PC);

  ret = dwarf_get (&c->dwarf, c->dwarf.loc[UNW_SPARC64_PC], &c->dwarf.ip);
  if (ret < 0)
    return ret;

  ret = dwarf_get (&c->dwarf, c->dwarf.loc[UNW_SPARC64_I6], &c->dwarf.cfa);
  if (ret < 0)
    return ret;

  c->sigcontext_format = SPARC64_SCF_NONE;
  c->sigcontext_addr = 0;

  c->dwarf.args_size = 0;
  c->dwarf.ret_addr_column = 0;
  c->dwarf.stash_frames = 0;
  c->dwarf.use_prev_instr = 1;
  c->dwarf.pi_valid = 0;
  c->dwarf.pi_is_dynamic = 0;
  c->dwarf.hint = 0;
  c->dwarf.prev_rs = 0;

  return 0;
}

#endif /* !UNW_REMOTE_ONLY */
