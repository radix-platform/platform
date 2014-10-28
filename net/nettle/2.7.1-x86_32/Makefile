
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/nettle

REQUIRES             = net/nettle/2.7.1
REQUIRES            += libs/gmp/5.1.3-x86_32


version              = 2.7.1
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/n/nettle/nettle-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/nettle-$(version)
src_dir_name         = nettle-$(version)
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
NETTLE32_PKG_NAME                = nettle-x32
NETTLE32_PKG_VERSION             = 2.7.1
NETTLE32_PKG_ARCH                = $(TOOLCHAIN)
NETTLE32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NETTLE32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NETTLE32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
NETTLE32_PKG_SHORT_DESCRIPTION   = small cryptographic library
NETTLE32_PKG_URL                 = $(BUG_URL)
NETTLE32_PKG_LICENSE             = GPLv2
NETTLE32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NETTLE32_PKG_NAME)-pkg-description
NETTLE32_PKG_DESCRIPTION_FILE_IN = $(NETTLE32_PKG_NAME)-pkg-description.in
NETTLE32_PKG_INSTALL_SCRIPT      = $(NETTLE32_PKG_NAME)-pkg-install.sh

NETTLE32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NETTLE32_PKG_NAME)-package

pkg_basename     = $(NETTLE32_PKG_NAME)-$(NETTLE32_PKG_VERSION)-$(NETTLE32_PKG_ARCH)-$(NETTLE32_PKG_DISTRO_NAME)-$(NETTLE32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(NETTLE32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
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
	@mkdir -p $(NETTLE32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod a+x $(NETTLE32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.?.?
	@mkdir -p $(NETTLE32_PKG)/usr/bin/32
	@( cd $(NETTLE32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(NETTLE32_PKG)/usr/include
	@rm -rf $(NETTLE32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(NETTLE32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" hogweed.pc ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" nettle.pc ; \
	 )
	@( cd $(NETTLE32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NETTLE32_PKG_DESCRIPTION_FILE): $(NETTLE32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NETTLE32_PKG_DESCRIPTION_FILE) $(NETTLE32_PKG_INSTALL_SCRIPT)
	@cp $(NETTLE32_PKG_DESCRIPTION_FILE) $(NETTLE32_PKG)/.DESCRIPTION
	@cp $(NETTLE32_PKG_INSTALL_SCRIPT) $(NETTLE32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NETTLE32_PKG)/.REQUIRES
	@echo "pkgname=$(NETTLE32_PKG_NAME)"                            >  $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NETTLE32_PKG_VERSION)"                          >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "arch=$(NETTLE32_PKG_ARCH)"                               >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "distroname=$(NETTLE32_PKG_DISTRO_NAME)"                  >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "distrover=$(NETTLE32_PKG_DISTRO_VERSION)"                >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "group=$(NETTLE32_PKG_GROUP)"                             >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NETTLE32_PKG_SHORT_DESCRIPTION)\"" >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "url=$(NETTLE32_PKG_URL)"                                 >> $(NETTLE32_PKG)/.PKGINFO ; \
	 echo "license=$(NETTLE32_PKG_LICENSE)"                         >> $(NETTLE32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NETTLE32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
