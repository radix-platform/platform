
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/U-Boot/TI/omap5/glsdk

versions    = 2013.04-20140216
versions   += 2014.07-20150216
versions   += 2014.07-20151209
versions   += 2014.07-20160225

tarballs    = $(addsuffix .tar.xz, $(addprefix u-boot-omap-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/u-boot-omap-2013.04-20140216-gcc5.patch
patches    += $(CURDIR)/patches/u-boot-omap-2014.07-20150216-gcc5.patch
patches    += $(CURDIR)/patches/u-boot-omap-2014.07-20151209-gcc5.patch
patches    += $(CURDIR)/patches/u-boot-omap-2014.07-20160225-gcc5.patch
patches    += $(CURDIR)/patches/u-boot-omap-2014.07-20160225-omap5uevm.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


include ../../../../../build-system/core.mk


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
	 ( cd create-2013.04-20140216-gcc5-patch      ;  ./create.patch.sh ) ; \
	 ( cd create-2014.07-20150216-gcc5-patch      ;  ./create.patch.sh ) ; \
	 ( cd create-2014.07-20151209-gcc5-patch      ;  ./create.patch.sh ) ; \
	 ( cd create-2014.07-20160225-gcc5-patch      ;  ./create.patch.sh ) ; \
	 ( cd create-2014.07-20160225-omap5uevm-patch ;  ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
