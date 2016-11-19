
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/U-Boot/denx

versions    = 2015.01 2016.01

tarballs    = $(addsuffix .tar.bz2, $(addprefix u-boot-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/u-boot-2015.01-gcc5.patch
patches    += $(CURDIR)/patches/u-boot-2015.01-sun7i-logo.patch
patches    += $(CURDIR)/patches/u-boot-2015.01-sun7i-dcdc3.patch
patches    += $(CURDIR)/patches/u-boot-2016.01-omap543x.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


include ../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======" ; \
	 for tarball in $(tarballs) ; do \
	   echo "$(url)/$$tarball" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & \
	 done ; wait

$(sha1s): $(tarballs)
	@for sha in $@ ; do \
	   echo -e "\n======= Downloading '$$sha' signature =======\n" ; \
	   echo "$(url)/$$sha" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1 ; \
	   touch $$sha ; \
	   echo -e "\n======= Check the '$$sha' sha1sum =======\n" ; \
	   sha1sum --check $$sha ; ret="$$?" ; \
	   if [ "$$ret" == "1" ]; then \
	     echo -e "\n======= ERROR: Bad '$$sha' sha1sum =======\n" ; \
	     exit 1 ; \
	   fi ; \
	 done

$(patches): $(sha1s)
	@echo -e "\n======= Create Patches =======\n" ; \
	 ( cd create-2015.01-gcc5-patch        ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-sun7i-logo-patch  ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-sun7i-dcdc3-patch ; ./create.patch.sh ) ; \
	 ( cd create-2016.01-omap543x-patch    ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
