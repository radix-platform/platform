
WARNINGS = -Wall -W -Wpointer-arith -Wbad-function-cast -Wcast-qual \
           -Wstrict-prototypes -Wmissing-prototypes \
           -Wmissing-declarations -Wnested-externs -Winline -Wcast-align

CFLAGS += -g $(WARNINGS)

all: netdate

netdate: netdate.o

install: netdate
	install -s netdate /usr/sbin/
	install -m 0644 netdate.8 /usr/man/man8/

clean:
	rm -f netdate *~ *.o core

