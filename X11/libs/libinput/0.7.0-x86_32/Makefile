
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/libinput

REQUIRES           = X11/libs/libinput/0.7.0
REQUIRES          += libs/eudev/1.9-x86_32
REQUIRES          += X11/libs/libevdev/1.3.2-x86_32
REQUIRES          += X11/libs/mtdev/1.1.5-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.7.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/libinput/libinput-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libinput-$(version)
src_dir_name       = libinput-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBINPUT_32_PKG_NAME                = libinput-x32
LIBINPUT_32_PKG_VERSION             = 0.7.0
LIBINPUT_32_PKG_ARCH                = $(TOOLCHAIN)
LIBINPUT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBINPUT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBINPUT_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBINPUT_32_PKG_SHORT_DESCRIPTION   = input devices handler
LIBINPUT_32_PKG_URL                 = $(BUG_URL)
LIBINPUT_32_PKG_LICENSE             = custom
LIBINPUT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBINPUT_32_PKG_NAME)-pkg-description
LIBINPUT_32_PKG_DESCRIPTION_FILE_IN = $(LIBINPUT_32_PKG_NAME)-pkg-description.in
LIBINPUT_32_PKG_INSTALL_SCRIPT      = $(LIBINPUT_32_PKG_NAME)-pkg-install.sh

LIBINPUT_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBINPUT_32_PKG_NAME)-package

pkg_basename     = $(LIBINPUT_32_PKG_NAME)-$(LIBINPUT_32_PKG_VERSION)-$(LIBINPUT_32_PKG_ARCH)-$(LIBINPUT_32_PKG_DISTRO_NAME)-$(LIBINPUT_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBINPUT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --enable-event-gui=no

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBINPUT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBINPUT_32_PKG)/usr/include
	@rm -rf $(LIBINPUT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBINPUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libinput.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBINPUT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libinput.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libinput.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libinput.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBINPUT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBINPUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBINPUT_32_PKG_DESCRIPTION_FILE): $(LIBINPUT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBINPUT_32_PKG_DESCRIPTION_FILE) $(LIBINPUT_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBINPUT_32_PKG_DESCRIPTION_FILE) $(LIBINPUT_32_PKG)/.DESCRIPTION
	@cp $(LIBINPUT_32_PKG_INSTALL_SCRIPT) $(LIBINPUT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBINPUT_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBINPUT_32_PKG_NAME)"                            >  $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBINPUT_32_PKG_VERSION)"                          >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBINPUT_32_PKG_ARCH)"                               >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBINPUT_32_PKG_DISTRO_NAME)"                  >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBINPUT_32_PKG_DISTRO_VERSION)"                >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBINPUT_32_PKG_GROUP)"                             >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBINPUT_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBINPUT_32_PKG_URL)"                                 >> $(LIBINPUT_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBINPUT_32_PKG_LICENSE)"                         >> $(LIBINPUT_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBINPUT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
