
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/n/openssl

versions    = 1.0.1f 1.0.1g 1.0.1p 1.0.2d 1.0.2f
versions   += 1.0.2t
versions   += 1.1.1d

pkgname     = openssl
suffix      = tar.gz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/openssl-1.0.1f-pod.patch
patches    += $(CURDIR)/patches/openssl-1.0.1f-shlib.patch
patches    += $(CURDIR)/patches/openssl-1.0.1g-mips-O2.patch
patches    += $(CURDIR)/patches/openssl-1.0.1g-pod.patch
patches    += $(CURDIR)/patches/openssl-1.0.1g-shlib.patch
patches    += $(CURDIR)/patches/openssl-1.0.2d-mips-O2.patch
patches    += $(CURDIR)/patches/openssl-1.0.2d-shlib.patch
patches    += $(CURDIR)/patches/openssl-1.0.2f-mips-O2.patch
patches    += $(CURDIR)/patches/openssl-1.0.2f-shlib.patch
patches    += $(CURDIR)/patches/openssl-1.0.2t-versioned-symbols.patch
patches    += $(CURDIR)/patches/openssl-1.0.2t-shlib.patch
patches    += $(CURDIR)/patches/openssl-1.0.2t-pod.patch
patches    += $(CURDIR)/patches/openssl-1.0.2t-mips-O2.patch

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
	 ( cd create-1.0.1f-pod-patch               ; ./create.patch.sh ) ; \
	 ( cd create-1.0.1f-shlib-patch             ; ./create.patch.sh ) ; \
	 ( cd create-1.0.1g-mips-O2-patch           ; ./create.patch.sh ) ; \
	 ( cd create-1.0.1g-pod-patch               ; ./create.patch.sh ) ; \
	 ( cd create-1.0.1g-shlib-patch             ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2d-mips-O2-patch           ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2d-shlib-patch             ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2f-mips-O2-patch           ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2f-shlib-patch             ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2t-versioned-symbols-patch ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2t-shlib-patch             ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2t-pod-patch               ; ./create.patch.sh ) ; \
	 ( cd create-1.0.2t-mips-O2-patch           ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
