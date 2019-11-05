/*
 * Copyright (c) 1989 The Regents of the University of California.
 * All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Tony Nardo of the Johns Hopkins University/Applied Physics Lab.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <inttypes.h>
#include "finger.h"

#define HAVE_WCHAR_H 1
#define HAVE_MBRTOWC 1
#define HAVE_WCWIDTH 1

#if defined(HAVE_WCHAR_H) && defined(HAVE_MBRTOWC) && defined(HAVE_WCWIDTH)
#include <wchar.h>
#include <wctype.h>
#include <assert.h>
#endif

int
getscreenwidth(void)
{

#if defined(TIOCGWINSZ)
	struct winsize ws;
	if (ioctl(STDIN_FILENO, TIOCGWINSZ, &ws) < 0 || ws.ws_col==0) {
		return 80;
	}
	return ws.ws_col;

#elif defined(TIOCGSIZE)
	struct ttysize ts;
	if (ioctl(STDIN_FILENO, TIOCGSIZE, &ts) < 0 || ts.ts_cols==0) {
		return 80;
	}
	return ts.ts_cols;

#else
	const char *e = getenv("COLUMNS");
	int col = e ? atoi(e) : 0;
	if (col==0) col = 80;
	return col;
#endif
}

int
is8bit(void)
{
	static int cache=-1;
	struct termios tios;
	if (cache>=0) return cache;

	if (tcgetattr(STDIN_FILENO, &tios)<0) {
		/* assume 8-bit; it's 1999 now, not 1972 */
		cache = 1;
	}
	else {
		cache = (tios.c_cflag & CSIZE)==CS8;
	}
	return cache;
}

/************/

static int send_crs=0;

void
set_crmode(void)
{
	send_crs = 1;
}

static
void
fxputc(FILE *f, int ch)
{
	/* drop any sign */
	ch = ch&0xff;

	/* on 7-bit terminals, strip high bit */
	if (!is8bit()) ch &= 0x7f; 

	/* 
	 * Assume anything that isn't a control character is printable.
	 * We can't count on locale stuff to tell us what's printable 
	 * because we might be looking at someone who uses different
	 * locale settings or is on the other side of the planet. So,
	 * strip 0-31, 127, 128-159, and 255. Note that not stripping
	 * 128-159 is asking for trouble, as 155 (M-esc) is interpreted
	 * as esc-[ by most terminals. Hopefully this won't break anyone's
	 * charset.
	 * 
	 * It would be nice if we could set the terminal to display in the
	 * right charset, but we have no way to know what it is. feh.
	 */
	
	if (((ch&0x7f) >= 32 && (ch&0x7f) != 0x7f) || ch=='\t') {
		putc(ch, f);
		return;
	}

	if (ch=='\n') {
		if (send_crs) putc('\r', f);
		putc('\n', f);
		return;
	}

	if (ch&0x80) {
		putc('M', f);
		putc('-', f);
		ch &= 0x7f;
	}

	putc('^', f);
	if (ch==0x7f) putc('?', f);
	else putc(ch+'@', f);
}

void
xputc(int ch)
{
	fxputc(stdout, ch);
}

static int has_locale = 0;

void
set_haslocale (void)
{
	has_locale = 1;
}

#if defined(HAVE_WCHAR_H) && defined(HAVE_MBRTOWC) && defined(HAVE_WCWIDTH)
static int verifymultibyte(const char *buf) {
	mbstate_t state;
	wchar_t nextchar;
	size_t bytesconsumed;
	char *eop, *op;
	(void)memset(&state, 0, sizeof(mbstate_t));

	eop = (char *) (buf + strlen(buf));
	op = (char *) buf;
	while (op < eop) {
		bytesconsumed = mbrtowc(&nextchar, op, eop - op, &state);
		if (bytesconsumed == (size_t)(-1) ||
		    bytesconsumed == (size_t)(-2)) {
			return 0;
		}
		op += bytesconsumed;
	}

	return 1;
}

#define OCTALIFY(n, o) \
	*(n)++ = '\\', \
	*(n)++ = (((uint32_t)*(o) >> 6) & 3) + '0', \
	*(n)++ = (((uint32_t)*(o) >> 3) & 7) + '0', \
	*(n)++ = (((uint32_t)*(o) >> 0) & 7) + '0', \
	(o)++

#endif

static void fxputs(FILE *f, const char *buf) {
	int widechars;

#if defined(HAVE_WCHAR_H) && defined(HAVE_MBRTOWC) && defined(HAVE_WCWIDTH)
	if (has_locale)
		widechars = verifymultibyte (buf);
	else
		widechars = 0;
#else
	widechars = 0;
#endif

	/* on 7-bit terminals, without wide-chars support, or string
	 * isn't parseable, print char * by char */
	if (!is8bit() || !widechars) {
		unsigned int i;
		char ch;
		for (i = 0; i < strlen (buf); i++) {
			ch = buf[i];
			fxputc(f, ch);
		}
		return;
	}

#if defined(HAVE_WCHAR_H) && defined(HAVE_MBRTOWC) && defined(HAVE_WCWIDTH)
	{
		mbstate_t state;
		wchar_t nextchar;
		size_t bytesconsumed;
		char *eop, *op, buffer[256];
		(void)memset(&state, 0, sizeof(mbstate_t));
		char* op1;
		eop = (char *) (buf + strlen(buf));
		op = (char *) buf;
		op1 = op;
		while (op < eop) {
			bytesconsumed = mbrtowc(&nextchar, op,
					eop - op, &state);
			/* This isn't supposed to happen as we verified the
			 * string before hand */
			assert(bytesconsumed != (size_t)(-1) && bytesconsumed != (size_t)(-2));

			if (iswprint(nextchar)) {
				(void)memcpy(buffer, op, bytesconsumed);
				buffer[bytesconsumed] = '\0';
				op += bytesconsumed;
			} else if (bytesconsumed == 1) {
				op++;
			} else {
				char *tmp;
				tmp = buffer;
				buffer[bytesconsumed] = '\0';
				while (bytesconsumed-- > 0) {
					OCTALIFY(tmp, op);
				}
			}
		}
		fprintf(f,"%s",op1);
	}
#endif
}

int xprintf(const char *fmt, ...) {
	char buf[1024];
	va_list ap;
	
	va_start(ap, fmt);
	vsnprintf(buf, sizeof(buf), fmt, ap);
	va_end(ap);
	
	fxputs(stdout, buf);
	
	return strlen(buf);
}

int eprintf(const char *fmt, ...) {
	char buf[1024];
	va_list ap;
	
	va_start(ap, fmt);
	vsnprintf(buf, sizeof(buf), fmt, ap);
	va_end(ap);

	fxputs(stderr, buf);
	
	return strlen(buf);
}
