
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


version     = 5.9

url         = $(DOWNLOAD_SERVER)/sources/GNU/ncurses/$(version)

pkgname     = ncurses
suffix      = tar.gz

tarballs    = $(addsuffix .$(suffix), $(addprefix $(pkgname)-, $(version)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

dates       = 20130504
nc-patches  = $(addsuffix .sh.gz, $(addprefix patch-$(version)-, $(dates)))

patches     = $(CURDIR)/patches/ncurses-5.9-mkhashsize.patch
patches    += $(CURDIR)/patches/ncurses-5.9-cross.patch
patches    += $(CURDIR)/patches/ncurses-5.9-gcc-5.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(nc-patches) $(patches)


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

$(nc-patches):
	@echo -e "\n======= Downloading patches for $(pkgname)-$(version) =======\n" ; \
	 for patch in $(nc-patches) ; do \
	   echo "$(url)/$$patch" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & \
	 done ; wait

$(patches): $(sha1s) $(nc-patches)
	@echo -e "\n======= Create Patches =======\n" ; \
	 ( cd create-5.9-mkhashsize-patch ; ./create.patch.sh ) ; \
	 ( cd create-5.9-cross-patch ;      ./create.patch.sh ) ; \
	 ( cd create-5.9-gcc-5-patch ;      ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(nc-patches) $(patches)
