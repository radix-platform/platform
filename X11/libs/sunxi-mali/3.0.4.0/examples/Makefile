
CFLAGS ?= -Wall -I./eglut

all: es2gears-x11-mali

es2gears-x11-mali: es2gears.c
	gcc $(CFLAGS) -o $@ es2gears.c eglut/eglut.c eglut/eglut_x11.c -lMali -lUMP -lX11 -lc -lm

clean:
	rm -f es2gears-x11-mali
