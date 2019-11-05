all: finger

include ../MCONFIG
include ../MRULES

finger: finger.o lprint.o net.o sprint.o util.o display.o
	$(CC) $(LDFLAGS) $^ $(LIBS) -o $@

finger.o lprint.o net.o sprint.o util.o display.o: finger.h
finger.o: ../version.h

install: finger
	install -d $(INSTALLROOT)$(BINDIR)
	install -m$(BINMODE) finger $(INSTALLROOT)$(BINDIR)
	install -d $(INSTALLROOT)$(MANDIR)/man1
	install -m$(MANMODE) finger.1 $(INSTALLROOT)$(MANDIR)/man1

clean:
	rm -f *.o finger

