
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../../build-system/constants.mk


url           = $(DOWNLOAD_SERVER)/sources/Linux/TI/omap5/glsdk

versions      = 3.8.13-20131223 3.8.13-20140222
versions     += 3.14.57-20151211

tarballs      = $(addsuffix .tar.xz, $(addprefix linux-glsdk-, $(versions)))
defconfigs    = $(subst .tar.xz,.defconfig, $(tarballs))
sha1s         = $(addsuffix .sha1sum, $(tarballs))

patches       = $(CURDIR)/patches/linux-glsdk-3.8.13-20131223-memset.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-gcc5.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-hdr-inst.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-l1-cache.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-memset.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-memset-3.12.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-neon-vfpv4.patch
patches      += $(CURDIR)/patches/linux-glsdk-3.8.13-20140222-vfpv3-d16.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(defconfigs) $(sha1s) $(patches)


include ../../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======" ; \
	 for tarball in $(tarballs) ; do \
	   echo "$(url)/$$tarball" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & \
	 done ; wait

$(defconfigs): $(tarballs)
	@echo -e "\n======= Downloading default config files =======" ; \
	 for defconfig in $(defconfigs) ; do \
	  echo "$(url)/$$defconfig" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & \
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
	 ( cd create-3.8.13-20131223-memset-patch       ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-gcc5-patch         ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-hdr-inst-patch     ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-l1-cache-patch     ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-memset-patch       ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-memset-3.12-patch  ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-neon-vfpv4-patch   ; ./create.patch.sh ) ; \
	 ( cd create-3.8.13-20140222-vfpv3-d16-patch    ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(defconfigs) $(sha1s) $(patches)
