
COMPONENT_TARGETS = $(TARGET_HOST)

url         = ftp://ftp.radix.pro/sources/hal/omap/sgx-ddk

versions    = 1.9.0.11

description = sgx-ddk.txt
tarballs    = $(addsuffix .tar.bz2, $(addprefix ti_imgddk_, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(description) $(tarballs) $(sha1s)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(description):
	wget $(WGET_OPTIONS) -N $(url)/$(description)

$(tarballs):
	@echo -e "\n======= Downloading source tarballs ======="
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done

$(sha1s): %.tar.bz2.sha1sum : %.tar.bz2
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
	@rm -f $(description) $(tarballs) $(sha1s)
