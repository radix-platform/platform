
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/Linux/Amlogic/M201

versions    = aml-3.10.33-20150117
versions   += aml-3.10.33-20160716

tarballs    = $(addsuffix .tar.xz, $(addprefix linux-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/linux-aml-3.10.33-20150117-headers-install.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20150117-gcc5.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20150117-m201-dtbs.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20150117-osd-xrgb.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20160716-headers-install.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20160716-gcc5.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20160716-m201-dtbs.patch
patches    += $(CURDIR)/patches/linux-aml-3.10.33-20160716-osd-xrgb.patch

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
	 ( cd create-3.10.33-20150117-headers-install-patch ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20150117-gcc5-patch            ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20150117-m201-dtbs-patch       ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20150117-osd-xrgb-patch        ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20160716-headers-install-patch ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20160716-gcc5-patch            ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20160716-m201-dtbs-patch       ; ./create.patch.sh ) ; \
	 ( cd create-3.10.33-20160716-osd-xrgb-patch        ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
