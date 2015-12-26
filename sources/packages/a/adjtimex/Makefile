
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/packages/a/adjtimex

version     = 1.28
pkgname     = adjtimex
suffix      = tar.gz

tarball     = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(version)))
sha1s       = $(addsuffix .sha1sum, $(tarball))

src_29_tarball = $(addsuffix .tar.gz, $(addprefix $(pkgname)-, 1.29))

patches      = $(CURDIR)/patches/adjtimex-1.28.patch
patches     += $(CURDIR)/patches/adjtimex-1.29.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarball) $(patches) $(sha1s)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarball):
	@echo -e "\n======= Downloading $(tarball) file =======" ; \
	 echo "$(url)/$(tarball)" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1

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

$(patches): $(sha1s)
	@echo -e "\n======= Create Patches =======\n" ; \
	 ( cd create-1.28-patch ; ./create.patch.sh ) ; \
	 ( cd create-1.29-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarball) $(src_29_tarball) $(sha1s) $(patches)
