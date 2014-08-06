
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/Linux/sunxi/sunxi-3.4

versions    = 3.4-20140514

description = linux-sunxi.txt
tarballs    = $(addsuffix .tar.bz2, $(addprefix linux-sunxi-, $(versions)))
defconfigs  = $(subst .tar.bz2,.defconfig, $(tarballs))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/linux-sunxi-3.4-20140514-a1x-vfp.patch
patches    += $(CURDIR)/patches/linux-sunxi-3.4-20140514-snd.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(description) $(tarballs) $(defconfigs) $(sha1s) $(patches)


include ../../../build-system/core.mk


.PHONY: download_clean


$(description):
	@echo -e "\n======= Downloading $(description) file =======" ; \
	 echo "$(url)/$(description)" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1

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
	 ( cd create-3.4-20140514-a1x-vfp-patch ; ./create.patch.sh ) ; \
	 ( cd create-3.4-20140514-snd-patch     ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(description) $(tarballs) $(defconfigs) $(sha1s) $(patches)
