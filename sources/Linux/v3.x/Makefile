
COMPONENT_TARGETS = $(TARGET_HOST)


include ../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/Linux/v3.x

versions    = 3.8.5
versions   += 3.10.17

tarballs    = $(addsuffix .tar.bz2, $(addprefix linux-, $(versions)))
defconfigs  = $(subst .tar.bz2,.defconfig, $(tarballs))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(tarballs) $(sha1s)


include ../../../build-system/core.mk


.PHONY: download_clean


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
	@rm -f $(tarballs) $(sha1s)
