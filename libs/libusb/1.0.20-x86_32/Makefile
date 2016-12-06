
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libusb

REQUIRES           = libs/libusb/1.0.20
REQUIRES          += libs/eudev/3.1.5-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.20
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libusb/libusb-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libusb-$(version)
src_dir_name       = libusb-$(version)
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
LIBUSB_32_PKG_NAME                = libusb-x32
LIBUSB_32_PKG_VERSION             = 1.0.20
LIBUSB_32_PKG_ARCH                = $(TOOLCHAIN)
LIBUSB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUSB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUSB_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBUSB_32_PKG_SHORT_DESCRIPTION   = USB library
LIBUSB_32_PKG_URL                 = $(BUG_URL)
LIBUSB_32_PKG_LICENSE             = GPLv2
LIBUSB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUSB_32_PKG_NAME)-pkg-description
LIBUSB_32_PKG_DESCRIPTION_FILE_IN = $(LIBUSB_32_PKG_NAME)-pkg-description.in
LIBUSB_32_PKG_INSTALL_SCRIPT      = $(LIBUSB_32_PKG_NAME)-pkg-install.sh

LIBUSB_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUSB_32_PKG_NAME)-package

pkg_basename     = $(LIBUSB_32_PKG_NAME)-$(LIBUSB_32_PKG_VERSION)-$(LIBUSB_32_PKG_ARCH)-$(LIBUSB_32_PKG_DISTRO_NAME)-$(LIBUSB_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBUSB_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	# ======= Now the libusb doesn't allow parallel building =======
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBUSB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBUSB_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUSB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libusb-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUSB_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libusb-?.?.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libusb-?.?.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libusb-?.?.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUSB_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBUSB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBUSB_32_PKG_DESCRIPTION_FILE): $(LIBUSB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUSB_32_PKG_DESCRIPTION_FILE) $(LIBUSB_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBUSB_32_PKG_DESCRIPTION_FILE) $(LIBUSB_32_PKG)/.DESCRIPTION
	@cp $(LIBUSB_32_PKG_INSTALL_SCRIPT) $(LIBUSB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUSB_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUSB_32_PKG_NAME)"                            >  $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUSB_32_PKG_VERSION)"                          >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUSB_32_PKG_ARCH)"                               >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUSB_32_PKG_DISTRO_NAME)"                  >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUSB_32_PKG_DISTRO_VERSION)"                >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUSB_32_PKG_GROUP)"                             >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUSB_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUSB_32_PKG_URL)"                                 >> $(LIBUSB_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUSB_32_PKG_LICENSE)"                         >> $(LIBUSB_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBUSB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
