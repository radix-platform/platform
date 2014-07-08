# Makefile for getty 2.0.7 distribution
#

#
# FSSTND Compliance:
#   If you want getty_ps to comply with the upcoming FSSTND document,
#   uncomment the following line.  As a result, all config files will
#   be expected in /etc/conf.* rather than /etc/default, modem locks 
#   will be created in /var/lock, and binaries will go in /sbin.
# 
# FSSTND=-DFSSTND

SHELL=	/bin/sh

#CFLAGS=	-g -fpcc-struct-return ${FSSTND}
#LFLAGS=	-g
CFLAGS+=	-O3 -fomit-frame-pointer -fpcc-struct-return ${FSSTND}
LFLAGS+=	-s

LIBS=	-ltermcap
LLIBS=	

# where things go
BIN=    /sbin
UUBIN=  /sbin
MAN=	/usr/share/man

# what are we making
SRC=	main.c funcs.c defaults.c table.c utmp2.c
OBJ=	main.o funcs.o defaults.o table.o utmp2.o
UUSRC=	uufuncs.c main.c funcs.c defaults.c table.c utmp2.c
UUOBJ=	uufuncs.o uumain.o funcs.o defaults.o table.o utmp2.o

# rules

all:	getty uugetty

getty:	$(OBJ)
	$(CC) $(LFLAGS) -o $@ $(OBJ) $(LIBS) 

uugetty: $(UUOBJ)
	$(CC) $(LFLAGS) -o $@ $(UUOBJ) $(LIBS) 

test: getty
	-mv $(BIN)/testgetty $(BIN)/testgetty-
	mv getty $(BIN)/testgetty

install:
	-mv $(BIN)/getty $(BIN)/getty-
	-mv $(UUBIN)/uugetty $(UUBIN)/uugetty-
	-cp -ip getty $(BIN)
	-cp -ip uugetty $(UUBIN)
	-chmod 755 $(BIN)/getty $(UUBIN)/uugetty
	-chgrp bin $(BIN)/getty $(UUBIN)/uugetty
	-cp -ip man/getty.1 $(MAN)/man1/
	-gzip -f $(MAN)/man1/getty.1
	-rm -f /var/man/cat1/getty.1.gz

clean:
	rm -f *.o core *.out *~ .depend Make.Log Makefile.old

clobber: clean
	rm -f getty uugetty

realclean: clobber

depend:	
	$(CC) -M *.c > .depend

uumain.o:	main.c
	$(CC) $(CFLAGS) -DUUGETTY -c main.c -o uumain.o


# include dependency file
ifeq (.depend,$(wildcard .depend))
include .depend
endif
