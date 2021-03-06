/*  Copyright 1994,1995  Patrick Volkerding, Moorhead, Minnesota USA
    All rights reserved.

 Redistribution and use of this source code, with or without modification, is
 permitted provided that the following condition is met:

 1. Redistributions of this source code must retain the above copyright
    notice, this condition, and the following disclaimer.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <stdlib.h>
#include <stdio.h>

int main( int argc, char **argv ) {
 	int c;
	if (argc > 1) {
	        c = *argv[1];
		if (c == '-') {
			printf("Usage: fromdos < dostextfile > unixtextfile\n");
			exit(1);
		} 
	}
	c = getchar();
	while (c != EOF) {
		/* Eat any \r's... they shouldn't be here */
		while (c == '\r') c = getchar();
		if (c == EOF) break;
                putchar(c);
                c = getchar();
	} 
	return 0;
}
