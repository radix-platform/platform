
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/hal/drivers/omap543x/wl18xx/wl18xx

versions    = ol_r8.a8.09
versions   += ol_r8.a8.10
versions   += ol_r8.a8.10_32

tarballs    = $(addsuffix .tar.bz2, $(addprefix wl18xx-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/wl18xx-ol_r8.a8.10-build.patch
patches    += $(CURDIR)/patches/wl18xx-ol_r8.a8.10-neon-vfpv4.patch
patches    += $(CURDIR)/patches/wl18xx-ol_r8.a8.10-vfpv3-d16.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


include ../../../../../../build-system/core.mk


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
	 ( cd create-ol_r8.a8.10-build-patch ;      ./create.patch.sh ) ; \
	 ( cd create-ol_r8.a8.10-neon-vfpv4-patch ; ./create.patch.sh ) ; \
	 ( cd create-ol_r8.a8.10-vfpv3-d16-patch ;  ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
