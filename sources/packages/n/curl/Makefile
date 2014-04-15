
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/n/curl

cacert_url  = http://curl.haxx.se/ca

versions    = 7.31.0 7.36.0
pkgname     = curl
suffix      = tar.bz2
cacert      = cacert.pem.bz2

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(tarballs) $(sha1s) $(cacert)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done

$(sha1s): %.$(suffix).sha1sum : %.$(suffix)
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

$(cacert):
	@echo -e "\n======= Downloading $(cacert) tarball =======\n"
	@wget -N $(cacert_url)/cacert.pem ; bzip2 -9 cacert.pem ; rm -f cacert.pem

download_clean:
	@rm -f $(tarballs) $(sha1s) $(cacert)
