
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/ieee1394/libiec61883

REQUIRES           = libs/libiec61883/1.2.0
REQUIRES          += libs/libraw1394/2.1.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/ieee1394/libiec61883/libiec61883-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiec61883-$(version)
src_dir_name       = libiec61883-$(version)
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
IEC61883_32_PKG_NAME                = libiec61883-x32
IEC61883_32_PKG_VERSION             = 1.2.0
IEC61883_32_PKG_ARCH                = $(TOOLCHAIN)
IEC61883_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IEC61883_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IEC61883_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
IEC61883_32_PKG_SHORT_DESCRIPTION   = IEC 61883 implementation
IEC61883_32_PKG_URL                 = $(BUG_URL)
IEC61883_32_PKG_LICENSE             = LGPLv2.1
IEC61883_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IEC61883_32_PKG_NAME)-pkg-description
IEC61883_32_PKG_DESCRIPTION_FILE_IN = $(IEC61883_32_PKG_NAME)-pkg-description.in
IEC61883_32_PKG_INSTALL_SCRIPT      = $(IEC61883_32_PKG_NAME)-pkg-install.sh

IEC61883_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IEC61883_32_PKG_NAME)-package

pkg_basename      = $(IEC61883_32_PKG_NAME)-$(IEC61883_32_PKG_VERSION)-$(IEC61883_32_PKG_ARCH)-$(IEC61883_32_PKG_DISTRO_NAME)-$(IEC61883_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IEC61883_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(IEC61883_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(IEC61883_32_PKG)/usr/include
	@rm -rf $(IEC61883_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IEC61883_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libiec61883.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IEC61883_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiec61883.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libiec61883.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiec61883.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(IEC61883_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(IEC61883_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(IEC61883_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IEC61883_32_PKG_DESCRIPTION_FILE): $(IEC61883_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IEC61883_32_PKG_DESCRIPTION_FILE) $(IEC61883_32_PKG_INSTALL_SCRIPT)
	@cp $(IEC61883_32_PKG_DESCRIPTION_FILE) $(IEC61883_32_PKG)/.DESCRIPTION
	@cp $(IEC61883_32_PKG_INSTALL_SCRIPT) $(IEC61883_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IEC61883_32_PKG)/.REQUIRES
	@echo "pkgname=$(IEC61883_32_PKG_NAME)"                            >  $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IEC61883_32_PKG_VERSION)"                          >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "arch=$(IEC61883_32_PKG_ARCH)"                               >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(IEC61883_32_PKG_DISTRO_NAME)"                  >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(IEC61883_32_PKG_DISTRO_VERSION)"                >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "group=$(IEC61883_32_PKG_GROUP)"                             >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IEC61883_32_PKG_SHORT_DESCRIPTION)\"" >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "url=$(IEC61883_32_PKG_URL)"                                 >> $(IEC61883_32_PKG)/.PKGINFO ; \
	 echo "license=$(IEC61883_32_PKG_LICENSE)"                         >> $(IEC61883_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IEC61883_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
