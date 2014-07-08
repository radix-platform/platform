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
MAN1=	$(MAN)/man1
MAN5=	$(MAN)/man5
DIRSRC=	getty_ps-2.1.1

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

install: all
	-mv $(BIN)/getty $(BIN)/getty-
	-mv $(UUBIN)/uugetty $(UUBIN)/uugetty-
	cp -p getty $(BIN)/
	cp -p uugetty $(UUBIN)/
	-chmod 755 $(BIN)/getty $(UUBIN)/uugetty 
	-chown root:bin $(BIN)/getty $(UUBIN)/uugetty
	cp -p man/getty.1 $(MAN1)/
	-gzip -f $(MAN1)/getty.1
	cp -p man/gettydefs.5 $(MAN5)/
	-gzip -f $(MAN5)/gettydefs.5
	-chmod 644 $(MAN1)/getty.1.gz $(MAN5)/gettydefs.5.gz
	-chown root:bin $(MAN1)/getty.1.gz $(MAN5)/gettydefs.5.gz 
	-rm -f /var/man/cat1/getty.1.gz /var/man/cat5/gettydefs.5.gz

release: all clean
	rm -f getty uugetty
	(cd .. && tar czf $(DIRSRC).tar.gz $(DIRSRC))
	cp -pu $(DIRSRC).lsm ..

clean:
	rm -f *.o core *.out *~ .depend Make.Log Makefile.old
	rm -f man/*~

clobber: clean
	rm -f getty uugetty

realclean: clobber

depend:	
	$(CC) -M *.c > .depend

uumain.o: main.c
	$(CC) $(CFLAGS) -DUUGETTY -c $< -o $@

.PHONY: all test install release clean clobber realclean 

# include dependency file
ifeq (.depend,$(wildcard .depend))
include .depend
endif
