# ziptool v1.2 (c) 1997 Mirko Kraft (Mirko.Kraft@ixos.de)
#

# Compiler options.
#
CFLAGS ?= -O2 -g -Wall

# Installation directories
#
INSTALL_BIN_DIR = /usr/bin
INSTALL_MAN_DIR = /usr/share/man

all: ziptool

clean:
	rm -f jaztool ziptool core *.o

install: all
	chown root.root ziptool
	chmod 755 ziptool
	chmod +s ziptool
	cp ziptool $(INSTALL_BIN_DIR)
	strip $(INSTALL_BIN_DIR)/ziptool
	cd $(INSTALL_BIN_DIR); ln -sf ziptool jaztool
	cp ziptool.1.gz $(INSTALL_MAN_DIR)/man1
	cd $(INSTALL_MAN_DIR)/man1; ln -sf ziptool.1.gz jaztool.1.gz

ziptool: ziptool.c
	$(CC) $(CFLAGS) -I. -o ziptool ziptool.c

jaztool: ziptool.c
	$(CC) $(CFLAGS) -I. -o jaztool ziptool.c
