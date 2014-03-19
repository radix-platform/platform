
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/GNU/gcc

version     = 4.8.2
pkgname     = gcc
suffix      = tar.bz2

tarball     = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(version)))
sha1s       = $(addsuffix .sha1sum, $(tarball))


BUILD_TARGETS = $(tarball) $(sha1s)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarball):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@wget $(WGET_OPTIONS) -N $(url)/$(pkgname)-$(version)/$(tarball)
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-4.8.2-gmp-inside-patch && ./create.patch.sh )
	@( cd create-4.8.2-fixinc-gmp-inside-patch && ./create.patch.sh )
	@( cd create-4.8.2-fixinc-gmp-outside-patch && ./create.patch.sh )
	@( cd create-4.8.2-x86_64-multilib-patch && ./create.patch.sh )

$(sha1s): %.$(suffix).sha1sum : %.$(suffix)
	@echo -e "\n======= Downloading '$@' signature =======\n"
	@wget $(WGET_OPTIONS) -N $(url)/$(pkgname)-$(version)/$@
	@touch $@
	@echo -e "\n======= Check the '$@' sha1sum =======\n"
	@( sha1sum --check $@ ; ret="$$?" ; \
	   if [ "$$ret" == "1" ]; then \
	     echo -e "\n======= ERROR: Bad '$@' sha1sum =======\n" ; \
	     exit 1 ; \
	   fi ; \
	 )

download_clean:
	@rm -f $(tarball) $(sha1s)
	@rm -f ./patches/gcc-4.8.2-gmp-inside.patch
	@rm -f ./patches/gcc-4.8.2-fixinc-gmp-inside.patch
	@rm -f ./patches/gcc-4.8.2-fixinc-gmp-outside.patch
	@rm -f ./patches/gcc-4.8.2-x86_64-multilib.patch
