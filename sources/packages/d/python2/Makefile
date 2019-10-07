
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/d/python2

versions    = 2.7.11 2.7.16
pkgname     = Python
suffix      = tar.xz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/Python-2.7.11-cross.patch
patches    += $(CURDIR)/patches/Python-2.7.11-cross32.patch
patches    += $(CURDIR)/patches/Python-2.7.11-x86_32.patch
patches    += $(CURDIR)/patches/Python-2.7.11-readline.patch
patches    += $(CURDIR)/patches/Python-2.7.16-cross.patch
patches    += $(CURDIR)/patches/Python-2.7.16-cross32.patch
patches    += $(CURDIR)/patches/Python-2.7.16-compat32.patch
patches    += $(CURDIR)/patches/Python-2.7.16-readline.patch

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
	 ( cd create-2.7.11-readline-patch ; ./create.patch.sh ) ; \
	 ( cd create-2.7.11-x86_32-patch ;   ./create.patch.sh ) ; \
	 ( cd create-2.7.11-cross32-patch ;  ./create.patch.sh ) ; \
	 ( cd create-2.7.11-cross-patch ;    ./create.patch.sh ) ; \
	 ( cd create-2.7.16-readline-patch ; ./create.patch.sh ) ; \
	 ( cd create-2.7.16-compat32-patch ; ./create.patch.sh ) ; \
	 ( cd create-2.7.16-cross32-patch ;  ./create.patch.sh ) ; \
	 ( cd create-2.7.16-cross-patch ;    ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
