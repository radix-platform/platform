
all: telnet

include ../MCONFIG
include ../MRULES

ifeq ($(USE_GLIBC),1)
CFLAGS += -D_GNU_SOURCE
endif

#CFLAGS:=$(patsubst -O2, -g, $(CFLAGS))

# -DAUTHENTICATE
CFLAGS += -DUSE_TERMIO -DKLUDGELINEMODE
LIBS += $(LIBTERMCAP)

CFLAGS += -I../

LIBTELNETOBJS = genget.o

OBJS =	authenc.o commands.o main.o network.o ring.o sys_bsd.o telnet.o \
	terminal.o tn3270.o utilities.o $(LIBTELNETOBJS)

telnet: $(OBJS)
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

install: telnet
	install -s -m$(BINMODE) telnet $(INSTALLROOT)$(BINDIR)
	install -m$(MANMODE) telnet.1 $(INSTALLROOT)$(MANDIR)/man1

clean:
	rm -f *.o telnet

genget.o:	../libtelnet/genget.c
	 $(CC) $(CFLAGS) $< -c
