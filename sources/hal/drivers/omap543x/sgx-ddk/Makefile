
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/hal/drivers/omap543x/sgx-ddk

versions    = 1.9.0.11

description = sgx-ddk.txt
tarballs    = $(addsuffix .tar.bz2, $(addprefix ti_imgddk_, $(versions)))
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/fix-dos2unix.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(description) $(tarballs) $(sha1s) $(patches)


include ../../../../../build-system/core.mk


.PHONY: download_clean


$(description):
	@echo -e "\n======= Downloading $(description) file =======" ; \
	 echo "$(url)/$(description)" | xargs -n 1 -P 100 wget $(WGET_OPTIONS) -i & wait %1

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
	 ( cd create-imgddk-1.9.0.11-patch ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(description) $(tarballs) $(sha1s) $(patches)
