
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/l/netpbm

versions    = 10.68.01 10.74.03
pkgname     = netpbm
suffix      = tar.bz2

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/netpbm-10.68.01-security-code.patch
patches    += $(CURDIR)/patches/netpbm-10.68.01-security-scripts.patch
patches    += $(CURDIR)/patches/netpbm-10.68.01-CAN-2005-2471.patch
patches    += $(CURDIR)/patches/netpbm-10.68.01-common.patch
patches    += $(CURDIR)/patches/netpbm-10.68.01-CVE-2005-2471.patch
patches    += $(CURDIR)/patches/netpbm-10.68.01-make.patch
patches    += $(CURDIR)/patches/netpbm-10.68.01-no-x11.patch
patches    += $(CURDIR)/patches/netpbm-10.74.03-security-code.patch
patches    += $(CURDIR)/patches/netpbm-10.74.03-security-scripts.patch
patches    += $(CURDIR)/patches/netpbm-10.74.03-CAN-2005-2471.patch
patches    += $(CURDIR)/patches/netpbm-10.74.03-make.patch
patches    += $(CURDIR)/patches/netpbm-10.74.03-no-x11.patch

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
	 ( cd create-10.68.01-security-code-patch    ; ./create.patch.sh ) ; \
	 ( cd create-10.68.01-security-scripts-patch ; ./create.patch.sh ) ; \
	 ( cd create-10.68.01-CAN-2005-2471-patch    ; ./create.patch.sh ) ; \
	 ( cd create-10.68.01-common-patch           ; ./create.patch.sh ) ; \
	 ( cd create-10.68.01-CVE-2005-2471-patch    ; ./create.patch.sh ) ; \
	 ( cd create-10.68.01-make-patch             ; ./create.patch.sh ) ; \
	 ( cd create-10.68.01-no-x11-patch           ; ./create.patch.sh ) ; \
	 ( cd create-10.74.03-security-code-patch    ; ./create.patch.sh ) ; \
	 ( cd create-10.74.03-security-scripts-patch ; ./create.patch.sh ) ; \
	 ( cd create-10.74.03-CAN-2005-2471-patch    ; ./create.patch.sh ) ; \
	 ( cd create-10.74.03-make-patch             ; ./create.patch.sh ) ; \
	 ( cd create-10.74.03-no-x11-patch           ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
