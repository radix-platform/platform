
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/GNU/gcc

version     = 4.9.1
pkgname     = gcc
suffix      = tar.bz2

tarball     = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(version)))
sha1s       = $(addsuffix .sha1sum, $(tarball))

patches     = $(CURDIR)/patches/gcc-4.9.1-gmp-inside.patch
patches    += $(CURDIR)/patches/gcc-4.9.1-fixinc-gmp-inside.patch
patches    += $(CURDIR)/patches/gcc-4.9.1-fixinc-gmp-outside.patch
patches    += $(CURDIR)/patches/gcc-4.9.1-x86_64-multilib.patch
patches    += $(CURDIR)/patches/gcc-4.9.1-backtrace.patch
patches    += $(CURDIR)/patches/gcc-4.9.1-doc.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarball) $(sha1s) $(patches)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarball):
	@echo -e "\n======= Downloading source tarballs =======\n" ; \
	 echo "$(url)/$(pkgname)-$(version)/$(tarball)" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1

$(sha1s): $(tarball)
	@echo -e "\n======= Downloading '$@' signature =======\n" ; \
	 echo "$(url)/$(pkgname)-$(version)/$@" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1 ; \
	 touch $@ ; \
	 echo -e "\n======= Check the '$@' sha1sum =======\n" ; \
	 ( sha1sum --check $@ ; ret="$$?" ; \
	   if [ "$$ret" == "1" ]; then \
	     echo -e "\n======= ERROR: Bad '$@' sha1sum =======\n" ; \
	     exit 1 ; \
	   fi ; \
	 )

$(patches): $(sha1s)
	@echo -e "\n======= Create Patches =======\n" ; \
	 ( cd create-4.9.1-gmp-inside-patch ;         ./create.patch.sh ) ; \
	 ( cd create-4.9.1-fixinc-gmp-inside-patch ;  ./create.patch.sh ) ; \
	 ( cd create-4.9.1-fixinc-gmp-outside-patch ; ./create.patch.sh ) ; \
	 ( cd create-4.9.1-x86_64-multilib-patch ;    ./create.patch.sh ) ; \
	 ( cd create-4.9.1-backtrace-patch ;          ./create.patch.sh ) ; \
	 ( cd create-4.9.1-doc-patch ;                ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarball) $(sha1s) $(patches)
