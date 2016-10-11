
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/l/libasyncns

REQUIRES             = libs/libasyncns/0.8

# ======= __END_OF_REQUIRES__ =======


version              = 0.8
tar_xz_archive       = $(SRC_PACKAGE_PATH)/packages/l/libasyncns/libasyncns-$(version).tar.xz
SRC_ARCHIVE          = $(tar_xz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libasyncns-$(version)
src_dir_name         = libasyncns-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBASYNCNS_32_PKG_NAME                = libasyncns-x32
LIBASYNCNS_32_PKG_VERSION             = 0.8
LIBASYNCNS_32_PKG_ARCH                = $(TOOLCHAIN)
LIBASYNCNS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBASYNCNS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBASYNCNS_32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBASYNCNS_32_PKG_SHORT_DESCRIPTION   = asynchronous name query library
LIBASYNCNS_32_PKG_URL                 = $(BUG_URL)
LIBASYNCNS_32_PKG_LICENSE             = LGPLv2.1
LIBASYNCNS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBASYNCNS_32_PKG_NAME)-pkg-description
LIBASYNCNS_32_PKG_DESCRIPTION_FILE_IN = $(LIBASYNCNS_32_PKG_NAME)-pkg-description.in
LIBASYNCNS_32_PKG_INSTALL_SCRIPT      = $(LIBASYNCNS_32_PKG_NAME)-pkg-install.sh

LIBASYNCNS_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBASYNCNS_32_PKG_NAME)-package

pkg_basename       = $(LIBASYNCNS_32_PKG_NAME)-$(LIBASYNCNS_32_PKG_VERSION)-$(LIBASYNCNS_32_PKG_ARCH)-$(LIBASYNCNS_32_PKG_DISTRO_NAME)-$(LIBASYNCNS_32_PKG_DISTRO_VERSION)

pkg_archive        = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature      = $(call sign-name,$(pkg_archive))
pkg_description    = $(call desc-name,$(pkg_archive))
products           = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS      = $(build_target)
BUILD_TARGETS     += $(install_target)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBASYNCNS_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Ensure correct libdir is specified by pkg-config database =======
	@( cd $(SRC_DIR) ; \
	   sed -i.back -e "/^libdir/c libdir=$$\{exec_prefix\}\/lib$(MULTILIB_X86_32_SUFFIX)" libasyncns.pc.in ; \
	 )
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
	@mkdir -p $(LIBASYNCNS_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBASYNCNS_32_PKG)/usr/include
	@rm -rf $(LIBASYNCNS_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBASYNCNS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libasyncns.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBASYNCNS_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasyncns.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libasyncns.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasyncns.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBASYNCNS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBASYNCNS_32_PKG_DESCRIPTION_FILE): $(LIBASYNCNS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBASYNCNS_32_PKG_DESCRIPTION_FILE) $(LIBASYNCNS_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBASYNCNS_32_PKG_DESCRIPTION_FILE) $(LIBASYNCNS_32_PKG)/.DESCRIPTION
	@cp $(LIBASYNCNS_32_PKG_INSTALL_SCRIPT) $(LIBASYNCNS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBASYNCNS_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBASYNCNS_32_PKG_NAME)"                            >  $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBASYNCNS_32_PKG_VERSION)"                          >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBASYNCNS_32_PKG_ARCH)"                               >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBASYNCNS_32_PKG_DISTRO_NAME)"                  >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBASYNCNS_32_PKG_DISTRO_VERSION)"                >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBASYNCNS_32_PKG_GROUP)"                             >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBASYNCNS_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBASYNCNS_32_PKG_URL)"                                 >> $(LIBASYNCNS_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBASYNCNS_32_PKG_LICENSE)"                         >> $(LIBASYNCNS_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBASYNCNS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
