
COMPONENT_TARGETS = $(TARGET_HOST)


include ../../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/hal/omap/wl18xx/compat

versions    = ol_r8.a8.09
versions   += ol_r8.a8.10

tarballs    = $(addsuffix .tar.bz2, $(addprefix compat-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(description) $(tarballs) $(sha1s)


include ../../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs ======="
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done
	@echo -e "\n======= Create Patches =======\n"
#	@( cd create-ol_r8.a8.10-patch && ./create.patch.sh )

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
#	@rm -f ./patches/version-ol_r8.a8.10.patch
