
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/n/openssl

versions    = 1.0.1f 1.0.1g
pkgname     = openssl
suffix      = tar.gz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(tarballs) $(sha1s)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-1.0.1f-pod-patch && ./create.patch.sh )
	@( cd create-1.0.1f-shlib-patch && ./create.patch.sh )
	@( cd create-1.0.1g-pod-patch && ./create.patch.sh )
	@( cd create-1.0.1g-shlib-patch && ./create.patch.sh )

$(sha1s): %.$(suffix).sha1sum : %.$(suffix)
	@for sha in $@ ; do \
	  echo -e "\n======= Downloading '$$sha' signature =======\n" ; \
	  wget $(WGET_OPTIONS) -N $(url)/$$sha ; \
	  touch $$sha ; \
	  echo -e "\n======= Check the '$$sha' sha1sum =======\n" ; \
	  sha1sum --check $$sha ; ret="$$?" ; \
	  if [ "$$ret" == "1" ]; then \
	    echo -e "\n======= ERROR: Bad '$$sha' sha1sum =======\n" ; \
	    exit 1 ; \
	  fi ; \
	done

download_clean:
	@rm -f $(tarballs) $(sha1s)
	@rm -f ./patches/openssl-1.0.1f-pod.patch
	@rm -f ./patches/openssl-1.0.1f-shlib.patch
	@rm -f ./patches/openssl-1.0.1g-pod.patch
	@rm -f ./patches/openssl-1.0.1g-shlib.patch
