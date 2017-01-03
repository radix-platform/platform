
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/x/qt4

versions    = 4.8.6 4.8.7
pkgname     = qt-everywhere-opensource-src
suffix      = tar.gz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/qt4-4.8.6.patch
patches    += $(CURDIR)/patches/qt4-4.8.6-CVE-2014-0190.patch
patches    += $(CURDIR)/patches/qt4-4.8.6-systemtrayicon.patch
patches    += $(CURDIR)/patches/qt4-4.8.6-webkit-NEON-Thumb2.patch

patches    += $(CURDIR)/patches/qt4-4.8.7-aarch64.patch

patches    += $(CURDIR)/patches/qt4-4.8.7-clipboard-delay.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-cups.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-disable-sslv3.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-event-loop.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-moc-boost.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-mysql.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-settings.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-systemtrayicon.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-webkit-NEON-Thumb2.patch
patches    += $(CURDIR)/patches/qt4-4.8.7-webkit-werror.patch


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
	 ( cd create-4.8.6-patch                    ; ./create.patch.sh ) ; \
	 ( cd create-4.8.6-CVE-2014-0190-patch      ; ./create.patch.sh ) ; \
	 ( cd create-4.8.6-systemtrayicon-patch     ; ./create.patch.sh ) ; \
	 ( cd create-4.8.6-webkit-NEON-Thumb2-patch ; ./create.patch.sh ) ; \
	 \
	 ( cd create-4.8.7-aarch64-patch            ; ./create.patch.sh ) ; \
	 \
	 ( cd create-4.8.7-clipboard-delay-patch    ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-cups-patch               ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-disable-sslv3-patch      ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-event-loop-patch         ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-moc-boost-patch          ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-mysql-patch              ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-settings-patch           ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-systemtrayicon-patch     ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-webkit-NEON-Thumb2-patch ; ./create.patch.sh ) ; \
	 ( cd create-4.8.7-webkit-werror-patch      ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
