
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


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
	@echo -e "\n======= Downloading $(tarball) file =======" ; \
	 echo "$(url)/$(tarball)" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1

$(patch): $(tarball)
	@echo -e "\n======= Downloading $(patch) file =======" ; \
	 echo "$(url)/$(patch)" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1

$(sha1s): $(tarball)
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

.NOTPARALLEL: $(src_tarball)

$(src_tarball): $(tarball) $(patch) $(sha1s)
	@tar xzf $(tarball)
	@zcat $(patch) | patch -p0 > /dev/null 2>&1
	@tar czf $(pkgname)-$(version).tar.gz $(pkgname)-$(version)
	@rm -rf $(pkgname)-$(version)

download_clean:
	@rm -f $(src_tarball) $(tarball) $(patch) $(sha1s)
