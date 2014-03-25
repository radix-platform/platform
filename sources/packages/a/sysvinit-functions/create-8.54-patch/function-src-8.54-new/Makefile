
CFLAGS ?= -O2 -Wall -D_GNU_SOURCE

PROGS        = usleep initlog fstab-decode consoletype
INITLOG_OBJS = initlog.o process.o
USLEEP_OBJS  = usleep.o

mandir = /usr/share/man

all:	$(PROGS)

clean:
	rm -f $(PROGS) *.o

install:
	mkdir -p $(DESTDIR)/bin $(DESTDIR)/sbin $(DESTDIR)$(mandir)/man{1,8}
	install -m 755 usleep $(DESTDIR)/bin/usleep
	install -m 755 fstab-decode $(DESTDIR)/sbin/fstab-decode
	install -m 755 initlog $(DESTDIR)/sbin/initlog
	install -m 755 consoletype $(DESTDIR)/sbin/consoletype
	install -m 644 initlog.1 $(DESTDIR)$(mandir)/man1
	install -m 644 usleep.1 $(DESTDIR)$(mandir)/man1
	install -m 644 fstab-decode.8 $(DESTDIR)$(mandir)/man8
	install -m 644 consoletype.1 $(DESTDIR)$(mandir)/man1

initlog: $(INITLOG_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(INITLOG_OBJS) -Wl,-Bstatic -lpopt -Wl,-Bdynamic

usleep: $(USLEEP_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(USLEEP_OBJS) -Wl,-Bstatic -lpopt -Wl,-Bdynamic

