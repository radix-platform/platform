
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../../build-system/constants.mk


url           = $(DOWNLOAD_SERVER)/sources/packages/l/termcap-compat

versions      = 1.2.3
pkgname       = termcap-compat
suffix        = tar.gz

tarballs      = $(addsuffix .$(suffix), $(addprefix $(pkgname)_, $(versions)))
descriptions  = $(addsuffix .dsc, $(addprefix $(pkgname)_, $(versions)))
sha1s         = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(tarballs) $(descriptions) $(sha1s)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-termcap-1.2.3-patch && ./create.patch.sh )

$(descriptions):
	@echo -e "\n======= Downloading source descriptions =======\n"
	@for description in $(descriptions) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$description ; \
	done

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
	@rm -f $(tarballs) $(descriptions) $(sha1s)
	@rm -f ./patches/termcap-compat-1.2.3.patch
