
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/attr

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.4.47
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/attr/attr-$(version).src.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/attr-$(version)
src_dir_name       = attr-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ATTR_PKG_NAME                = attr
ATTR_PKG_VERSION             = 2.4.47
ATTR_PKG_ARCH                = $(TOOLCHAIN)
ATTR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ATTR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ATTR_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
ATTR_PKG_SHORT_DESCRIPTION   = filesystems extended attributes tools
ATTR_PKG_URL                 = $(BUG_URL)
ATTR_PKG_LICENSE             = GPLv2
ATTR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ATTR_PKG_NAME)-pkg-description
ATTR_PKG_DESCRIPTION_FILE_IN = $(ATTR_PKG_NAME)-pkg-description.in
ATTR_PKG_INSTALL_SCRIPT      = $(ATTR_PKG_NAME)-pkg-install.sh

ATTR_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ATTR_PKG_NAME)-package

pkg_basename     = $(ATTR_PKG_NAME)-$(ATTR_PKG_VERSION)-$(ATTR_PKG_ARCH)-$(ATTR_PKG_DISTRO_NAME)-$(ATTR_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(ATTR_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --sbindir=/usr/sbin
extra_configure_switches += --bindir=/usr/bin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-shared


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --exec-prefix=/usr          \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ATTR_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-dev $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-lib $(env_sysroot)
	@mkdir -p $(ATTR_PKG)/lib$(LIBSUFFIX)
	@( cd $(ATTR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 libattr.so.?.?.? *.la ; \
	   cp -a libattr.so.? $(ATTR_PKG)/lib$(LIBSUFFIX) ; \
	   mv libattr.so.?.?.? $(ATTR_PKG)/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libattr.so.?.?.? . \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(ATTR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/COPYING* \
	       $(ATTR_PKG)/usr/doc/$(src_dir_name)
	@mv $(ATTR_PKG)/usr/share/doc/attr $(ATTR_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a doc/INSTALL \
	         $(ATTR_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(ATTR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libattr.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ATTR_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libattr.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libattr.la \
	 )
	# ======= Strip binaries =======
	@( cd $(ATTR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ATTR_PKG_DESCRIPTION_FILE): $(ATTR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ATTR_PKG_DESCRIPTION_FILE) $(ATTR_PKG_INSTALL_SCRIPT)
	@cp $(ATTR_PKG_DESCRIPTION_FILE) $(ATTR_PKG)/.DESCRIPTION
	@cp $(ATTR_PKG_INSTALL_SCRIPT) $(ATTR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ATTR_PKG)/.REQUIRES
	@echo "pkgname=$(ATTR_PKG_NAME)"                            >  $(ATTR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ATTR_PKG_VERSION)"                          >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "arch=$(ATTR_PKG_ARCH)"                               >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "distroname=$(ATTR_PKG_DISTRO_NAME)"                  >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "distrover=$(ATTR_PKG_DISTRO_VERSION)"                >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "group=$(ATTR_PKG_GROUP)"                             >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ATTR_PKG_SHORT_DESCRIPTION)\"" >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "url=$(ATTR_PKG_URL)"                                 >> $(ATTR_PKG)/.PKGINFO ; \
	 echo "license=$(ATTR_PKG_LICENSE)"                         >> $(ATTR_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ATTR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
