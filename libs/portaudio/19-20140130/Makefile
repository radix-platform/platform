
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/portaudio

REQUIRES           = libs/eglibc/2.19.1
REQUIRES          += libs/alsa-lib/1.0.28


version            = 19-20140130
tarball_version    = v19_20140130
doc_version        = $(shell echo $(tarball_version) | cut -f 2 -d '_')
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/portaudio/pa_stable_$(tarball_version).tgz
doc_tgz_archive    = $(SRC_PACKAGE_PATH)/packages/m/portaudio/pa_stable_doxydocs_$(doc_version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/portaudio
doc_dir_name       = portaudio-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PORTAUDIO_PKG_NAME                = portaudio
PORTAUDIO_PKG_VERSION             = 19-20140130
PORTAUDIO_PKG_ARCH                = $(TOOLCHAIN)
PORTAUDIO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PORTAUDIO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PORTAUDIO_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
PORTAUDIO_PKG_SHORT_DESCRIPTION   = portable cross-platform audio API
PORTAUDIO_PKG_URL                 = $(BUG_URL)
PORTAUDIO_PKG_LICENSE             = BSD-style
PORTAUDIO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PORTAUDIO_PKG_NAME)-pkg-description
PORTAUDIO_PKG_DESCRIPTION_FILE_IN = $(PORTAUDIO_PKG_NAME)-pkg-description.in
PORTAUDIO_PKG_INSTALL_SCRIPT      = $(PORTAUDIO_PKG_NAME)-pkg-install.sh

PORTAUDIO_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PORTAUDIO_PKG_NAME)-package

pkg_basename     = $(PORTAUDIO_PKG_NAME)-$(PORTAUDIO_PKG_VERSION)-$(PORTAUDIO_PKG_ARCH)-$(PORTAUDIO_PKG_DISTRO_NAME)-$(PORTAUDIO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PORTAUDIO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-alsa
extra_configure_switches += --without-jack
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@tar xzf $(doc_tgz_archive) -C $(SRC_DIR)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PORTAUDIO_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@if [ -d $(PORTAUDIO_PKG)/usr/share/man ]; then \
	  ( cd $(PORTAUDIO_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(PORTAUDIO_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE.txt \
	       $(PORTAUDIO_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(PORTAUDIO_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE.txt README* doc/html \
	         $(PORTAUDIO_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PORTAUDIO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PORTAUDIO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libportaudio.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PORTAUDIO_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libportaudio.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libportaudio.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" portaudio-2.0.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PORTAUDIO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PORTAUDIO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PORTAUDIO_PKG_DESCRIPTION_FILE): $(PORTAUDIO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PORTAUDIO_PKG_DESCRIPTION_FILE) $(PORTAUDIO_PKG_INSTALL_SCRIPT)
	@cp $(PORTAUDIO_PKG_DESCRIPTION_FILE) $(PORTAUDIO_PKG)/.DESCRIPTION
	@cp $(PORTAUDIO_PKG_INSTALL_SCRIPT) $(PORTAUDIO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PORTAUDIO_PKG)/.REQUIRES
	@echo "pkgname=$(PORTAUDIO_PKG_NAME)"                            >  $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PORTAUDIO_PKG_VERSION)"                          >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "arch=$(PORTAUDIO_PKG_ARCH)"                               >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "distroname=$(PORTAUDIO_PKG_DISTRO_NAME)"                  >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "distrover=$(PORTAUDIO_PKG_DISTRO_VERSION)"                >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "group=$(PORTAUDIO_PKG_GROUP)"                             >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PORTAUDIO_PKG_SHORT_DESCRIPTION)\"" >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "url=$(PORTAUDIO_PKG_URL)"                                 >> $(PORTAUDIO_PKG)/.PKGINFO ; \
	 echo "license=$(PORTAUDIO_PKG_LICENSE)"                         >> $(PORTAUDIO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PORTAUDIO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
