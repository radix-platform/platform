
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/mega-nerd/libsamplerate

REQUIRES           = libs/libsndfile/1.0.25

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/mega-nerd/libsamplerate/libsamplerate-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libsamplerate-$(version)
src_dir_name       = libsamplerate-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBSAMPLERATE_PKG_NAME                = libsamplerate
LIBSAMPLERATE_PKG_VERSION             = 0.1.8
LIBSAMPLERATE_PKG_ARCH                = $(TOOLCHAIN)
LIBSAMPLERATE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSAMPLERATE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSAMPLERATE_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBSAMPLERATE_PKG_SHORT_DESCRIPTION   = Sample Rate Converter for audio
LIBSAMPLERATE_PKG_URL                 = $(BUG_URL)
LIBSAMPLERATE_PKG_LICENSE             = GPLv2
LIBSAMPLERATE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSAMPLERATE_PKG_NAME)-pkg-description
LIBSAMPLERATE_PKG_DESCRIPTION_FILE_IN = $(LIBSAMPLERATE_PKG_NAME)-pkg-description.in
LIBSAMPLERATE_PKG_INSTALL_SCRIPT      = $(LIBSAMPLERATE_PKG_NAME)-pkg-install.sh

LIBSAMPLERATE_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSAMPLERATE_PKG_NAME)-package

pkg_basename      = $(LIBSAMPLERATE_PKG_NAME)-$(LIBSAMPLERATE_PKG_VERSION)-$(LIBSAMPLERATE_PKG_ARCH)-$(LIBSAMPLERATE_PKG_DISTRO_NAME)-$(LIBSAMPLERATE_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBSAMPLERATE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-fftw
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBSAMPLERATE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBSAMPLERATE_PKG)/usr/share/man ]; then \
	  ( cd $(LIBSAMPLERATE_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBSAMPLERATE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBSAMPLERATE_PKG)/usr/doc/$(src_dir_name)
	@( cd $(LIBSAMPLERATE_PKG)/usr/share/doc ; mv libsamplerate0-dev $(src_dir_name) )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(LIBSAMPLERATE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBSAMPLERATE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSAMPLERATE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsamplerate.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSAMPLERATE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsamplerate.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsamplerate.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" samplerate.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSAMPLERATE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBSAMPLERATE_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSAMPLERATE_PKG_DESCRIPTION_FILE): $(LIBSAMPLERATE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSAMPLERATE_PKG_DESCRIPTION_FILE) $(LIBSAMPLERATE_PKG_INSTALL_SCRIPT)
	@cp $(LIBSAMPLERATE_PKG_DESCRIPTION_FILE) $(LIBSAMPLERATE_PKG)/.DESCRIPTION
	@cp $(LIBSAMPLERATE_PKG_INSTALL_SCRIPT) $(LIBSAMPLERATE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSAMPLERATE_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSAMPLERATE_PKG_NAME)"                            >  $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSAMPLERATE_PKG_VERSION)"                          >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSAMPLERATE_PKG_ARCH)"                               >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSAMPLERATE_PKG_DISTRO_NAME)"                  >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSAMPLERATE_PKG_DISTRO_VERSION)"                >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSAMPLERATE_PKG_GROUP)"                             >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSAMPLERATE_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSAMPLERATE_PKG_URL)"                                 >> $(LIBSAMPLERATE_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSAMPLERATE_PKG_LICENSE)"                         >> $(LIBSAMPLERATE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSAMPLERATE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
