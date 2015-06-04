
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/mega-nerd/libsamplerate

REQUIRES           = libs/libsamplerate/0.1.8
REQUIRES          += libs/libsndfile/1.0.25-x86_32

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
LIBSAMPLERATE_32_PKG_NAME                = libsamplerate-x32
LIBSAMPLERATE_32_PKG_VERSION             = 0.1.8
LIBSAMPLERATE_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSAMPLERATE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSAMPLERATE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSAMPLERATE_32_PKG_GROUP               = $(PKG_GROUP)
###                                       |---handy-ruler-------------------------------|
LIBSAMPLERATE_32_PKG_SHORT_DESCRIPTION   = Sample Rate Converter for audio
LIBSAMPLERATE_32_PKG_URL                 = $(BUG_URL)
LIBSAMPLERATE_32_PKG_LICENSE             = GPLv2
LIBSAMPLERATE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSAMPLERATE_32_PKG_NAME)-pkg-description
LIBSAMPLERATE_32_PKG_DESCRIPTION_FILE_IN = $(LIBSAMPLERATE_32_PKG_NAME)-pkg-description.in
LIBSAMPLERATE_32_PKG_INSTALL_SCRIPT      = $(LIBSAMPLERATE_32_PKG_NAME)-pkg-install.sh

LIBSAMPLERATE_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSAMPLERATE_32_PKG_NAME)-package

pkg_basename         = $(LIBSAMPLERATE_32_PKG_NAME)-$(LIBSAMPLERATE_32_PKG_VERSION)-$(LIBSAMPLERATE_32_PKG_ARCH)-$(LIBSAMPLERATE_32_PKG_DISTRO_NAME)-$(LIBSAMPLERATE_32_PKG_DISTRO_VERSION)

pkg_archive          = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature        = $(call sign-name,$(pkg_archive))
pkg_description      = $(call desc-name,$(pkg_archive))
products             = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS        = $(build_target)
BUILD_TARGETS       += $(install_target)

PRODUCT_TARGETS      = $(products)

ROOTFS_TARGETS       = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSAMPLERATE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-fftw
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBSAMPLERATE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(LIBSAMPLERATE_32_PKG)/usr/bin/32
	@( cd $(LIBSAMPLERATE_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBSAMPLERATE_32_PKG)/usr/include
	@rm -rf $(LIBSAMPLERATE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSAMPLERATE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsamplerate.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBSAMPLERATE_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsamplerate.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsamplerate.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" samplerate.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSAMPLERATE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBSAMPLERATE_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSAMPLERATE_32_PKG_DESCRIPTION_FILE): $(LIBSAMPLERATE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSAMPLERATE_32_PKG_DESCRIPTION_FILE) $(LIBSAMPLERATE_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSAMPLERATE_32_PKG_DESCRIPTION_FILE) $(LIBSAMPLERATE_32_PKG)/.DESCRIPTION
	@cp $(LIBSAMPLERATE_32_PKG_INSTALL_SCRIPT) $(LIBSAMPLERATE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSAMPLERATE_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSAMPLERATE_32_PKG_NAME)"                            >  $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSAMPLERATE_32_PKG_VERSION)"                          >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSAMPLERATE_32_PKG_ARCH)"                               >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSAMPLERATE_32_PKG_DISTRO_NAME)"                  >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSAMPLERATE_32_PKG_DISTRO_VERSION)"                >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSAMPLERATE_32_PKG_GROUP)"                             >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSAMPLERATE_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSAMPLERATE_32_PKG_URL)"                                 >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSAMPLERATE_32_PKG_LICENSE)"                         >> $(LIBSAMPLERATE_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSAMPLERATE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
