
COMPONENT_TARGETS = $(HARDWARE_NOARCH)


include ../../../build-system/constants.mk


url         = $(DOWNLOAD_SERVER)/sources/iana/tz

versions    = 2013i
versions   += 2015a
versions   += 2015c
versions   += 2015g
versions   += 2016a
versions   += 2016i
versions   += 2017b
versions   += 2018c

tarballs    = $(sort \
                $(shell \
                  for tarball in $(addsuffix .tar.gz, $(addprefix tz+, $(versions))) ; do \
                    echo -n "`echo "$$tarball" | sed -e 's/+/code/g'` " ; \
                    echo -n "`echo "$$tarball" | sed -e 's/+/data/g'` " ; \
                  done ) \
               )
sha1s       = $(addsuffix .sha1sum, $(tarballs))

patches     = $(CURDIR)/patches/glibc-2.21-tzcode-2015a.patch
patches    += $(CURDIR)/patches/glibc-2.21-tzcode-2015c.patch
patches    += $(CURDIR)/patches/glibc-2.22-tzcode-2015g.patch
patches    += $(CURDIR)/patches/glibc-2.23-tzcode-2016a.patch
patches    += $(CURDIR)/patches/glibc-2.24-tzcode-2016i.patch
patches    += $(CURDIR)/patches/glibc-2.25-tzcode-2017b.patch
patches    += $(CURDIR)/patches/glibc-2.26-tzcode-2018c.patch
patches    += $(CURDIR)/patches/tzcode-2018c-version.patch

.NOTPARALLEL: $(patches)


BUILD_TARGETS = $(tarballs) $(sha1s) $(patches)


include ../../../build-system/core.mk


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
	 ( cd create-2015a-glibc-2.21-patch ; ./create.patch.sh ) ; \
	 ( cd create-2015c-glibc-2.21-patch ; ./create.patch.sh ) ; \
	 ( cd create-2015g-glibc-2.22-patch ; ./create.patch.sh ) ; \
	 ( cd create-2016a-glibc-2.23-patch ; ./create.patch.sh ) ; \
	 ( cd create-2016i-glibc-2.24-patch ; ./create.patch.sh ) ; \
	 ( cd create-2017b-glibc-2.25-patch ; ./create.patch.sh ) ; \
	 ( cd create-2018c-glibc-2.26-patch ; ./create.patch.sh ) ; \
	 ( cd create-2018c-version-patch    ; ./create.patch.sh ) ; \
	 echo -e "\n"

download_clean:
	@rm -f $(tarballs) $(sha1s) $(patches)
