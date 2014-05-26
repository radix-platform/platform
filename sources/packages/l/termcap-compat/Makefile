
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url           = $(DOWNLOAD_SERVER)/sources/packages/l/termcap-compat

versions      = 1.2.3
pkgname       = termcap-compat
suffix        = tar.gz

tarballs      = $(addsuffix .$(suffix), $(addprefix $(pkgname)_, $(versions)))
descriptions  = $(addsuffix .dsc, $(addprefix $(pkgname)_, $(versions)))
sha1s         = $(addsuffix .sha1sum, $(tarballs))

patches       = $(CURDIR)/patches/termcap-compat-1.2.3.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(descriptions) $(sha1s) $(patches)


include ../../../../build-system/core.mk


.PHONY: download_clean


$(tarballs):
	@echo -e "\n======= Downloading source tarballs =======" ; \
	 for tarball in $(tarballs) ; do \
	   echo "$(url)/$$tarball" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & \
	 done ; wait

$(descriptions):
	@echo -e "\n======= Downloading source descriptions =======" ; \
	 for description in $(descriptions) ; do \
	   echo "$(url)/$$description" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & \
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
	 ( cd create-termcap-1.2.3-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(descriptions) $(sha1s) $(patches)
