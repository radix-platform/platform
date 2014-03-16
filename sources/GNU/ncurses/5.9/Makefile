
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../../build-system/constants.mk


version     = 5.9

url         = $(DOWNLOAD_SERVER)/sources/GNU/ncurses/$(version)

pkgname     = ncurses
suffix      = tar.gz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(version)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

dates       = 20130504
patches     = $(addsuffix .sh.gz, $(addprefix patch-$(version)-, $(dates)))


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
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

$(patches):
	@echo -e "\n======= Downloading patches for $(pkgname)-$(version) =======\n"
	@for patch in $(patches) ; do \
	  wget -N $(url)/$$patch ; \
	done
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-5.9-mkhashsize-patch && ./create.patch.sh )
	@( cd create-5.9-cross-patch && ./create.patch.sh )

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
	@rm -f ./patches/ncurses-5.9-mkhashsize.patch
	@rm -f ./patches/ncurses-5.9-cross.patch
