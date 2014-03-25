
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/a/adjtimex

version     = 1.29
pkgname     = adjtimex
suffix      = orig.tar.gz

tarball     = $(addsuffix .$(suffix), $(addprefix $(pkgname)_, $(version)))
patch       = $(addsuffix -2.2.diff.gz, $(addprefix $(pkgname)_, $(version)))
sha1s       = $(addsuffix .sha1sum, $(tarball))

src_tarball = $(addsuffix .tar.gz, $(addprefix $(pkgname)-, $(version)))


BUILD_TARGETS = $(tarball) $(patch) $(sha1s) $(src_tarball)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarball):
	@echo -e "\n======= Downloading source tarballs =======\n"
	@wget $(WGET_OPTIONS) -N $(url)/$(tarball)

$(patch): $(tarball)
	@echo -e "\n======= Downloading patch =======\n"
	@wget $(WGET_OPTIONS) -N $(url)/$(patch)

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

$(src_tarball): $(tarball) $(patch) $(sha1s)
	@tar xzf $(tarball)
	@zcat $(patch) | patch -p0
	@tar czf $(pkgname)-$(version).tar.gz $(pkgname)-$(version)
	@rm -rf $(pkgname)-$(version)

download_clean:
	@rm -f $(src_tarball) $(tarball) $(patch) $(sha1s)
