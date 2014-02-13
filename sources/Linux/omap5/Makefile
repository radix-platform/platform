
COMPONENT_TARGETS = $(TARGET_HOST)

url         = ftp://ftp.radix.pro/sources/Linux/omap5

versions    = 3.4-5AJ.1.2
versions   += 3.4-5AJ.1.3
versions   += 3.4-5AJ.1.4
versions   += 3.8-6AJ.1.0
versions   += 3.8-6AJ.1.1
versions   += 3.8-6AJ.1.1-RC0
versions   += 3.8-6AJ.1.2-RC3

description = android-omap5.txt
tarballs    = $(addsuffix .tar.bz2, $(addprefix linux-, $(versions)))
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
