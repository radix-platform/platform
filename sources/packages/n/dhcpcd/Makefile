
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../build-system/constants.mk


url          = $(DOWNLOAD_SERVER)/sources/packages/n/dhcpcd

versions     = 6.10.1
old_versions = 6.0.5 6.4.2
pkgname      = dhcpcd

tarballs     = $(addsuffix .tar.xz, $(addprefix $(pkgname)-, $(versions)))
old_tarballs = $(addsuffix .tar.bz2, $(addprefix $(pkgname)-, $(old_versions)))

tarballs    += $(old_tarballs)
sha1s        = $(addsuffix .sha1sum, $(tarballs))

patches      = $(CURDIR)/patches/dhcpcd-6.0.5.patch
patches     += $(CURDIR)/patches/dhcpcd-6.4.2.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


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

$(patches): $(sha1s)
	@echo -e "\n======= Create Patches =======\n" ; \
	 ( cd create-6.0.5-patch ; ./create.patch.sh ) ; \
	 ( cd create-6.4.2-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
