
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/x/qt5

versions    = 5.4.0 5.4.2 5.7.0 5.7.1
pkgname     = qt-everywhere-opensource-src
suffix      = tar.xz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/qt5-5.4.0-configure.patch
patches    += $(CURDIR)/patches/qt5-5.4.0-gcc-4.9.2.patch
patches    += $(CURDIR)/patches/qt5-5.4.0-gcc-5.0-webkit.patch
patches    += $(CURDIR)/patches/qt5-5.4.0-mips-dsp.patch
patches    += $(CURDIR)/patches/qt5-5.4.0-eglfs.patch

patches    += $(CURDIR)/patches/qt5-5.4.2-configure.patch
patches    += $(CURDIR)/patches/qt5-5.4.2-webkit-aarch64.patch
patches    += $(CURDIR)/patches/qt5-5.4.2-webkit-arm-softfp.patch

patches    += $(CURDIR)/patches/qt5-5.7.0-mips32r5.patch
patches    += $(CURDIR)/patches/qt5-5.7.0-arm-neon-thumb.patch
patches    += $(CURDIR)/patches/qt5-5.7.0-ffmpeg-no-armv6.patch
patches    += $(CURDIR)/patches/qt5-5.7.0-ffmpeg-no-thumb.patch

patches    += $(CURDIR)/patches/qt5-5.7.1-mips32r5.patch
patches    += $(CURDIR)/patches/qt5-5.7.1-arm-neon-thumb.patch
patches    += $(CURDIR)/patches/qt5-5.7.1-ffmpeg-no-armv6.patch
patches    += $(CURDIR)/patches/qt5-5.7.1-ffmpeg-no-thumb.patch

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
	 ( cd create-5.4.0-configure-patch         ; ./create.patch.sh ) ; \
	 ( cd create-5.4.0-gcc-4.9.2-patch         ; ./create.patch.sh ) ; \
	 ( cd create-5.4.0-gcc-5.0-webkit-patch    ; ./create.patch.sh ) ; \
	 ( cd create-5.4.0-mips-dsp-patch          ; ./create.patch.sh ) ; \
	 ( cd create-5.4.0-eglfs-patch             ; ./create.patch.sh ) ; \
	 ( cd create-5.4.2-configure-patch         ; ./create.patch.sh ) ; \
	 ( cd create-5.4.2-webkit-aarch64-patch    ; ./create.patch.sh ) ; \
	 ( cd create-5.4.2-webkit-arm-softfp-patch ; ./create.patch.sh ) ; \
	 ( cd create-5.7.0-mips32r5-patch          ; ./create.patch.sh ) ; \
	 ( cd create-5.7.0-arm-neon-thumb-patch    ; ./create.patch.sh ) ; \
	 ( cd create-5.7.0-ffmpeg-no-armv6-patch   ; ./create.patch.sh ) ; \
	 ( cd create-5.7.0-ffmpeg-no-thumb-patch   ; ./create.patch.sh ) ; \
	 ( cd create-5.7.1-mips32r5-patch          ; ./create.patch.sh ) ; \
	 ( cd create-5.7.1-arm-neon-thumb-patch    ; ./create.patch.sh ) ; \
	 ( cd create-5.7.1-ffmpeg-no-armv6-patch   ; ./create.patch.sh ) ; \
	 ( cd create-5.7.1-ffmpeg-no-thumb-patch   ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
