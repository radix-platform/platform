
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libmnl

REQUIRES             = net/libmnl/1.0.3
REQUIRES            += libs/eglibc/2.19.1-x86_32


version              = 1.0.3
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libmnl/libmnl-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libmnl-$(version)
src_dir_name         = libmnl-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBMNL_32_PKG_NAME                = libmnl-x32
LIBMNL_32_PKG_VERSION             = 1.0.3
LIBMNL_32_PKG_ARCH                = $(TOOLCHAIN)
LIBMNL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBMNL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBMNL_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBMNL_32_PKG_SHORT_DESCRIPTION   = Netlink developers user-space library
LIBMNL_32_PKG_URL                 = $(BUG_URL)
LIBMNL_32_PKG_LICENSE             = LGPLv2.1
LIBMNL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBMNL_32_PKG_NAME)-pkg-description
LIBMNL_32_PKG_DESCRIPTION_FILE_IN = $(LIBMNL_32_PKG_NAME)-pkg-description.in
LIBMNL_32_PKG_INSTALL_SCRIPT      = $(LIBMNL_32_PKG_NAME)-pkg-install.sh

LIBMNL_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBMNL_32_PKG_NAME)-package

pkg_basename     = $(LIBMNL_32_PKG_NAME)-$(LIBMNL_32_PKG_VERSION)-$(LIBMNL_32_PKG_ARCH)-$(LIBMNL_32_PKG_DISTRO_NAME)-$(LIBMNL_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBMNL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBMNL_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBMNL_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBMNL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmnl.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBMNL_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmnl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmnl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmnl.pc ; \
	 )
	@( cd $(LIBMNL_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBMNL_32_PKG_DESCRIPTION_FILE): $(LIBMNL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBMNL_32_PKG_DESCRIPTION_FILE) $(LIBMNL_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBMNL_32_PKG_DESCRIPTION_FILE) $(LIBMNL_32_PKG)/.DESCRIPTION
	@cp $(LIBMNL_32_PKG_INSTALL_SCRIPT) $(LIBMNL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBMNL_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBMNL_32_PKG_NAME)"                            >  $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBMNL_32_PKG_VERSION)"                          >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBMNL_32_PKG_ARCH)"                               >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBMNL_32_PKG_DISTRO_NAME)"                  >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBMNL_32_PKG_DISTRO_VERSION)"                >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBMNL_32_PKG_GROUP)"                             >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBMNL_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBMNL_32_PKG_URL)"                                 >> $(LIBMNL_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBMNL_32_PKG_LICENSE)"                         >> $(LIBMNL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBMNL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
