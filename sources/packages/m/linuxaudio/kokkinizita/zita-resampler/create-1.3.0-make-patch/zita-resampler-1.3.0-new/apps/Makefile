# ----------------------------------------------------------------------------
#
#  Copyright (C) 2006-2011 Fons Adriaensen <fons@linuxaudio.org>
#    
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http:#www.gnu.org/licenses/>.
#
# ----------------------------------------------------------------------------


PREFIX = /usr/local
SUFFIX := $(shell uname -m | sed -e 's/^unknown/$//' -e 's/^i.86/$//' -e 's/^x86_64/$/64/')
BINDIR = bin
LIBDIR = lib$(SUFFIX)
DISTDIR = zresample-$(VERSION)
VERSION = 0.4.0
MANDIR = /usr/share/man/man1
CPPFLAGS += -MMD -MP -DVERSION=\"$(VERSION)\"
CXXFLAGS += -O3  -ffast-math -Wall


all:	zresample zretune zresample.1.gz zretune.1.gz


ZRESAMPLE_O = zresample.o audiofile.o dither.o
zresample:	LDLIBS += -lzita-resampler -lsndfile -lpthread -lrt
zresample:	$(ZRESAMPLE_O)
	$(CXX) $(LDFLAGS) -o $@ $(ZRESAMPLE_O) $(LDLIBS)
$(ZRESAMPLE_O):
-include $(ZRESAMPLE_O:%.o=%.d)


ZRETUNE_O = zretune.o audiofile.o dither.o
zretune:	LDLIBS += -lzita-resampler -lsndfile -lpthread -lrt
zretune:	$(ZRETUNE_O)
	$(CXX) $(LDFLAGS) -o $@ $(ZRETUNE_O) $(LDLIBS)
$(ZRETUNE_O):
-include $(ZRETUNE_O:%.o=%.d)


zresample.1.gz:	zresample.1
	gzip -c zresample.1 > zresample.1.gz

zretune.1.gz:	zretune.1
	gzip -c zretune.1 > zretune.1.gz


install:	all
	install -Dm 755 zresample $(DESTDIR)$(PREFIX)/$(BINDIR)/zresample
	install -Dm 755 zretune $(DESTDIR)$(PREFIX)/$(BINDIR)/zretune
	install -Dm 644 zresample.1.gz $(DESTDIR)$(MANDIR)/zresample.1.gz
	install -Dm 644 zretune.1.gz $(DESTDIR)$(MANDIR)/zretune.1.gz

uninstall: 
	/bin/rm -f $(DESTDIR)$(PREFIX)/$(BINDIR)/zresample
	/bin/rm -f $(DESTDIR)$(PREFIX)/$(BINDIR)/zretune
	/bin/rm -f $(MANDIR)/zresample.1.gz
	/bin/rm -f $(MANDIR)/zretune.1.gz

clean:
	/bin/rm -f *~ *.o *.a *.d *.so *.gz zresample zretune

