
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/a/eudev

versions    = 3.2.8
pkgname     = eudev
suffix      = tar.xz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/eudev-3.2.8-cdrom-id.patch
patches    += $(CURDIR)/patches/eudev-3.2.8-ids-pl.patch
patches    += $(CURDIR)/patches/eudev-3.2.8-mips.patch
patches    += $(CURDIR)/patches/eudev-3.2.8-no-kvm.patch
patches    += $(CURDIR)/patches/eudev-3.2.8-no-render.patch

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
	 ( cd create-3.2.8-cdrom-id-patch  ; ./create.patch.sh ) ; \
	 ( cd create-3.2.8-ids-pl-patch    ; ./create.patch.sh ) ; \
	 ( cd create-3.2.8-mips-patch      ; ./create.patch.sh ) ; \
	 ( cd create-3.2.8-no-kvm-patch    ; ./create.patch.sh ) ; \
	 ( cd create-3.2.8-no-render-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
