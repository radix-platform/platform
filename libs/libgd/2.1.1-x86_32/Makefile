
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libgd

REQUIRES           = libs/libgd/2.1.1
REQUIRES          += libs/libtiff/4.0.6-x86_32
REQUIRES          += libs/libvpx/1.5.0-x86_32
REQUIRES          += libs/libpng/libpng14/1.4.19-x86_32
REQUIRES          += libs/libjpeg-turbo/1.4.2-x86_32
REQUIRES          += libs/freetype/2.6.3-x86_32
REQUIRES          += X11/libs/fontconfig/2.12.4-x86_32
REQUIRES          += X11/X.org/lib/libXpm/3.5.11-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.1.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libgd/libgd-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgd-$(version)
src_dir_name       = libgd-$(version)
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
LIBGD_32_PKG_NAME                = libgd-x32
LIBGD_32_PKG_VERSION             = 2.1.1
LIBGD_32_PKG_ARCH                = $(TOOLCHAIN)
LIBGD_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBGD_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBGD_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBGD_32_PKG_SHORT_DESCRIPTION   = GD graphic library
LIBGD_32_PKG_URL                 = $(BUG_URL)
LIBGD_32_PKG_LICENSE             = custom
LIBGD_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBGD_32_PKG_NAME)-pkg-description
LIBGD_32_PKG_DESCRIPTION_FILE_IN = $(LIBGD_32_PKG_NAME)-pkg-description.in
LIBGD_32_PKG_INSTALL_SCRIPT      = $(LIBGD_32_PKG_NAME)-pkg-install.sh

LIBGD_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBGD_32_PKG_NAME)-package

pkg_basename     = $(LIBGD_32_PKG_NAME)-$(LIBGD_32_PKG_VERSION)-$(LIBGD_32_PKG_ARCH)-$(LIBGD_32_PKG_DISTRO_NAME)-$(LIBGD_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBGD_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

major_version = $(shell echo $(version) | cut -f 1 -d '.')
minor_version = $(shell echo $(version) | cut -f 2 -d '.')
extra_version = $(shell echo $(version) | cut -f 3 -d '.')


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
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
	@mkdir -p $(LIBGD_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBGD_32_PKG)/usr/bin/32
	@( cd $(LIBGD_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@( cd $(LIBGD_32_PKG)/usr/bin/32 ; \
	   sed -i 's,@GDLIB_MAJOR@,$(major_version),g' gdlib-config ; \
	   sed -i 's,@GDLIB_MINOR@,$(minor_version),g' gdlib-config ; \
	   sed -i 's,@GDLIB_EXTRA@,$(extra_version),g' gdlib-config ; \
	 )
	@rm -rf $(LIBGD_32_PKG)/usr/include
	@rm -rf $(LIBGD_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBGD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgd.la \
	 )
	# ======= remove toolchain path from pkg-config *.pc files =======
	@( cd $(LIBGD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" gdlib.pc \
	 )
	# ======= remove toolchain path from gdlib-config file =======
	@( cd $(LIBGD_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" gdlib-config \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBGD_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgd.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgd.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gdlib.pc \
	 )
	# ======= tune LDFLAGS in gdlib-config file to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gdlib-config ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" gdlib-config \
	 )
	# =======Strip binaries =======
	@( cd $(LIBGD_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBGD_32_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBGD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBGD_32_PKG_DESCRIPTION_FILE): $(LIBGD_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBGD_32_PKG_DESCRIPTION_FILE) $(LIBGD_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBGD_32_PKG_DESCRIPTION_FILE) $(LIBGD_32_PKG)/.DESCRIPTION
	@cp $(LIBGD_32_PKG_INSTALL_SCRIPT) $(LIBGD_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBGD_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBGD_32_PKG_NAME)"                            >  $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBGD_32_PKG_VERSION)"                          >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBGD_32_PKG_ARCH)"                               >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBGD_32_PKG_DISTRO_NAME)"                  >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBGD_32_PKG_DISTRO_VERSION)"                >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBGD_32_PKG_GROUP)"                             >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBGD_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBGD_32_PKG_URL)"                                 >> $(LIBGD_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBGD_32_PKG_LICENSE)"                         >> $(LIBGD_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBGD_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
