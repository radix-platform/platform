
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/p11-kit

REQUIRES             = net/p11-kit/0.20.2
REQUIRES            += libs/eglibc/2.19.1-x86_32
REQUIRES            += libs/libffi/3.0.13-x86_32
REQUIRES            += libs/libtasn1/3.4-x86_32


version              = 0.20.2
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/n/p11-kit/p11-kit-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/p11-kit-$(version)
src_dir_name         = p11-kit-$(version)
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
P11KIT32_PKG_NAME                = p11-kit-x32
P11KIT32_PKG_VERSION             = 0.20.2
P11KIT32_PKG_ARCH                = $(TOOLCHAIN)
P11KIT32_PKG_DISTRO_NAME         = kxLab
P11KIT32_PKG_DISTRO_VERSION      = 1.0
P11KIT32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
P11KIT32_PKG_SHORT_DESCRIPTION   = p11-kit-x32 $(version)
P11KIT32_PKG_URL                 = http://www.kxLab.com
P11KIT32_PKG_LICENSE             = GPLv2
P11KIT32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(P11KIT32_PKG_NAME)-pkg-description
P11KIT32_PKG_DESCRIPTION_FILE_IN = $(P11KIT32_PKG_NAME)-pkg-description.in
P11KIT32_PKG_INSTALL_SCRIPT      = $(P11KIT32_PKG_NAME)-pkg-install.sh

P11KIT32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(P11KIT32_PKG_NAME)-package

pkg_basename     = $(P11KIT32_PKG_NAME)-$(P11KIT32_PKG_VERSION)-$(P11KIT32_PKG_ARCH)-$(P11KIT32_PKG_DISTRO_NAME)-$(P11KIT32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(P11KIT32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


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
	@mkdir -p $(P11KIT32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(P11KIT32_PKG)/usr/bin/32
	@( cd $(P11KIT32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(P11KIT32_PKG)/etc
	@rm -rf $(P11KIT32_PKG)/usr/include
	@rm -rf $(P11KIT32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(P11KIT32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libp11-kit.la ; \
	   sed -i "s,-L/usr/lib ,,g" libp11-kit.la ; \
	   sed -i "s,-L/lib ,,g" libp11-kit.la ; \
	 )
	@( cd $(P11KIT32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkcs11 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" p11-kit-trust.la ; \
	   sed -i "s,-L/usr/lib ,,g" p11-kit-trust.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(P11KIT32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libp11-kit.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libp11-kit.la  \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkcs11 ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" p11-kit-trust.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" p11-kit-trust.la  \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" p11-kit-1.pc \
	 )
	@( cd $(P11KIT32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(P11KIT32_PKG_DESCRIPTION_FILE): $(P11KIT32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(P11KIT32_PKG_DESCRIPTION_FILE) $(P11KIT32_PKG_INSTALL_SCRIPT)
	@cp $(P11KIT32_PKG_DESCRIPTION_FILE) $(P11KIT32_PKG)/.DESCRIPTION
	@cp $(P11KIT32_PKG_INSTALL_SCRIPT) $(P11KIT32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(P11KIT32_PKG)/.REQUIRES
	@echo "pkgname=$(P11KIT32_PKG_NAME)"                            >  $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(P11KIT32_PKG_VERSION)"                          >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "arch=$(P11KIT32_PKG_ARCH)"                               >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "distroname=$(P11KIT32_PKG_DISTRO_NAME)"                  >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "distrover=$(P11KIT32_PKG_DISTRO_VERSION)"                >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "group=$(P11KIT32_PKG_GROUP)"                             >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(P11KIT32_PKG_SHORT_DESCRIPTION)\"" >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "url=$(P11KIT32_PKG_URL)"                                 >> $(P11KIT32_PKG)/.PKGINFO ; \
	 echo "license=$(P11KIT32_PKG_LICENSE)"                         >> $(P11KIT32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(P11KIT32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
