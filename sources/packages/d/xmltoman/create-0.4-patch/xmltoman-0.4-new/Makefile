PREFIX=/usr
PACKAGE=xmltoman
VERSION=0.4
DISTNAME=$(PACKAGE)-$(VERSION)
DISTFILES= COPYING Makefile README xml/ xmlmantohtml xmltoman xmltoman.css xmltoman.dtd xmltoman.xsl

all: xmltoman.1 xmlmantohtml.1

xmltoman.1: xml/xmltoman.1.xml
	./xmltoman $< > $@

xmlmantohtml.1: xml/xmlmantohtml.1.xml
	./xmltoman $< > $@

install:
	install -D xmltoman $(DESTDIR)/$(PREFIX)/bin/xmltoman
	install -D xmlmantohtml $(DESTDIR)/$(PREFIX)/bin/xmlmantohtml
	install -D -m 0644 xmltoman.dtd $(DESTDIR)/$(PREFIX)/share/xmltoman/xmltoman.dtd
	install -D -m 0644 xmltoman.css $(DESTDIR)/$(PREFIX)/share/xmltoman/xmltoman.css
	install -D -m 0644 xmltoman.xsl $(DESTDIR)/$(PREFIX)/share/xmltoman/xmltoman.xsl

dist:
	[ -d $(DISTNAME) ] && rm -rf $(DISTNAME) || true
	mkdir $(DISTNAME)
	cp -aR $(DISTFILES) $(DISTNAME)
	tar zcvf $(DISTNAME).tar.gz $(DISTNAME)
	rm -rf $(DISTNAME)

clean:
	rm -f *~ *.1 xml/*~


