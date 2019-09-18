
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/GNU/glibc

versions    = 2.28

tarballs    = $(addsuffix .tar.xz, $(addprefix glibc-, $(versions)))

sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/glibc-2.28-i18n.patch
patches    += $(CURDIR)/patches/glibc-2.28-malloc-hooks.patch
patches    += $(CURDIR)/patches/glibc-2.28-sparc32-atomics.patch
patches    += $(CURDIR)/patches/glibc-2.28-x86-IFUNC-revert.patch
patches    += $(CURDIR)/patches/glibc-2.28-c-utf8-locale.patch
patches    += $(CURDIR)/patches/glibc-2.28-zonefile.patch
patches    += $(CURDIR)/patches/glibc-2.28-zoneinfo.patch

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
	 ( cd create-2.28-i18n-patch                ; ./create.patch.sh ) ; \
	 ( cd create-2.28-malloc-hooks-patch        ; ./create.patch.sh ) ; \
	 ( cd create-2.28-sparc32-atomics-patch     ; ./create.patch.sh ) ; \
	 ( cd create-2.28-x86-IFUNC-revert-patch    ; ./create.patch.sh ) ; \
	 ( cd create-2.28-c-utf8-locale-patch       ; ./create.patch.sh ) ; \
	 ( cd create-2.28-zonefile-patch            ; ./create.patch.sh ) ; \
	 ( cd create-2.28-zoneinfo-patch            ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
