
COMPONENT_TARGETS = $(TARGET_NOARCH)


include ../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/Linux/omap5-glsdk

versions    = 3.8.y-20131223
versions   += 3.8.y-20140222

description = omap5-glsdk.txt
tarballs    = $(addsuffix .tar.bz2, $(addprefix linux-glsdk-, $(versions)))
defconfigs  = $(subst .tar.bz2,.defconfig, $(tarballs))
sha1s       = $(addsuffix .sha1sum, $(tarballs))


BUILD_TARGETS = $(description) $(tarballs) $(defconfigs) $(sha1s)


include ../../../build-system/core.mk


.PHONY: download_clean


$(description):
	wget $(WGET_OPTIONS) -N $(url)/$(description)

$(tarballs):
	@echo -e "\n======= Downloading source tarballs ======="
	@for tarball in $(tarballs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$tarball ; \
	done
	@echo -e "\n======= Create Patches =======\n"
	@( cd create-3.8.y-20131223-memset-patch && ./create.patch.sh )
	@( cd create-3.8.y-20140222-hdr-inst-patch && ./create.patch.sh )
	@( cd create-3.8.y-20140222-memset-patch && ./create.patch.sh )

$(defconfigs):
	@echo -e "\n======= Downloading default config files ======="
	@for defconfig in $(defconfigs) ; do \
	  wget $(WGET_OPTIONS) -N $(url)/$$defconfig ; \
	done

$(sha1s): %.tar.bz2.sha1sum : %.tar.bz2
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
	@rm -f $(description) $(tarballs) $(defconfigs) $(sha1s)
	@rm -f patches/linux-glsdk-3.8.y-20131223-memset.patch
	@rm -f patches/linux-glsdk-3.8.y-20140222-hdr-inst.patch
	@rm -f patches/linux-glsdk-3.8.y-20140222-memset.patch
