
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/l/sdl/sdl

versions    = 1.2.15
pkgname     = SDL
suffix      = tar.gz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/SDL-1.2.15-bypass-gamma.patch
patches    += $(CURDIR)/patches/SDL-1.2.15-disable-mmx.patch
patches    += $(CURDIR)/patches/SDL-1.2.15-joystick-axis.patch
patches    += $(CURDIR)/patches/SDL-1.2.15-x11-XData32.patch
patches    += $(CURDIR)/patches/SDL-1.2.15-x11-events.patch
patches    += $(CURDIR)/patches/SDL-1.2.15-x11-grab.patch
patches    += $(CURDIR)/patches/SDL-1.2.15-automake.patch

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
	 ( cd create-1.2.15-bypass-gamma-patch  ; ./create.patch.sh ) ; \
	 ( cd create-1.2.15-disable-mmx-patch   ; ./create.patch.sh ) ; \
	 ( cd create-1.2.15-joystick-axis-patch ; ./create.patch.sh ) ; \
	 ( cd create-1.2.15-x11-XData32-patch   ; ./create.patch.sh ) ; \
	 ( cd create-1.2.15-x11-events-patch    ; ./create.patch.sh ) ; \
	 ( cd create-1.2.15-x11-grab-patch      ; ./create.patch.sh ) ; \
	 ( cd create-1.2.15-automake-patch      ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
