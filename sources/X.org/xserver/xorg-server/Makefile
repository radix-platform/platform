
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/X.org/xserver/xorg-server

versions    = 1.12.2 1.16.2 1.16.4 1.18.3
pkgname     = xorg-server
suffix      = tar.bz2

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/xorg-server-1.12.2-black.patch
patches    += $(CURDIR)/patches/xorg-server-1.16.2-black.patch
patches    += $(CURDIR)/patches/xorg-server-1.16.4-black.patch
patches    += $(CURDIR)/patches/xorg-server-1.18.3-black.patch
patches    += $(CURDIR)/patches/xorg-server-1.18.3-mouse-kbd-layout.patch

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
	 ( cd create-1.12.2-black-patch            ; ./create.patch.sh ) ; \
	 ( cd create-1.16.2-black-patch            ; ./create.patch.sh ) ; \
	 ( cd create-1.16.4-black-patch            ; ./create.patch.sh ) ; \
	 ( cd create-1.18.3-black-patch            ; ./create.patch.sh ) ; \
	 ( cd create-1.18.3-mouse-kbd-layout-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
