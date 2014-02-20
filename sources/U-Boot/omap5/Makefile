
COMPONENT_TARGETS = $(TARGET_HOST)


include ../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/U-Boot/omap5

versions    = 6AJ.1.2-RC3

description = u-boot-omap.txt
tarballs    = $(addsuffix .tar.bz2, $(addprefix u-boot-omap-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(description) $(tarballs) $(sha1s)


include ../../../build-system/core.mk


.PHONY: download_clean


$(description):
	wget $(WGET_OPTIONS) -N $(url)/$(description)

$(tarballs):
	@echo -e "\n======= Downloading source tarballs ======="
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-6AJ.1.2-RC3-patch && ./create.patch.sh )

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
	@rm -f ./patches/u-boot-omap-6AJ.1.2-RC3.patch
