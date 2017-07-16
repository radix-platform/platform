
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/U-Boot/Khadas/S905X

versions    = 2015.01-20170107

tarballs    = $(addsuffix .tar.xz, $(addprefix u-boot-khadas-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-gcc5.patch
patches    += $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-git.patch
patches    += $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-fw-cross.patch
patches    += $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-bmp32.patch
patches    += $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-mmcboot.patch
patches    += $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-partitions.patch
patches    += $(CURDIR)/patches/u-boot-khadas-2015.01-20170107-ddr-saradc.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


include ../../../../build-system/core.mk


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
	 ( cd create-2015.01-20170107-gcc5-patch       ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-20170107-git-patch        ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-20170107-fw-cross-patch   ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-20170107-bmp32-patch      ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-20170107-mmcboot-patch    ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-20170107-partitions-patch ; ./create.patch.sh ) ; \
	 ( cd create-2015.01-20170107-ddr-saradc-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
