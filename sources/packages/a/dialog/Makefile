#
# Project Home:
# ============
# http://hightek.org/dialog/
#
# Downloads:
# =========
# ftp://ftp.us.debian.org/debian/pool/main/d/dialog/
#

COMPONENT_TARGETS = $(TARGET_HOST)

url         = ftp://ftp.radix.pro/sources/packages/a/dialog

versions    = 1.1-20120215 1.2-20130928

tarballs    = $(addsuffix .orig.tar.gz, $(addprefix dialog_, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(tarballs) $(sha1s)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-patch-1.1-20120215 && ./create.patch.sh )
	@( cd create-patch-1.2-20130928 && ./create.patch.sh )

$(sha1s): %.tar.gz.sha1sum : %.tar.gz
	@for sha in $@ ; do \
	  echo -e "\n======= Downloading '$$sha' signature =======\n" ; \
	  wget $(WGET_OPTIONS) -N $(url)/$$sha ; \
	  touch $$sha ; \
	  echo -e "\n======= Check the '$$sha' sha1sum =======\n" ; \
	  sha1sum --check $$sha ; ret="$$?" ; \
	  if [ "$$ret" == "1" ]; then \
	    echo -e "\n======= ERROR: Bad '$$sha' sha1sum =======\n" ; \
	    exit 1 ; \
	  fi ; \
	done

download_clean:
	@rm -f $(tarballs) $(sha1s)
	@rm -f ./patches/dialog-1.1-20120215.patch
	@rm -f ./patches/dialog-1.2-20130928.patch
