
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libtirpc

REQUIRES             = net/libtirpc/1.0.1

# ======= __END_OF_REQUIRES__ =======


version              = 1.0.1
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libtirpc/libtirpc-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libtirpc-$(version)
src_dir_name         = libtirpc-$(version)
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
LIBTIRPC_32_PKG_NAME                = libtirpc-x32
LIBTIRPC_32_PKG_VERSION             = 1.0.1
LIBTIRPC_32_PKG_ARCH                = $(TOOLCHAIN)
LIBTIRPC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBTIRPC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBTIRPC_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBTIRPC_32_PKG_SHORT_DESCRIPTION   = Transport-Independent RPC library
LIBTIRPC_32_PKG_URL                 = $(BUG_URL)
LIBTIRPC_32_PKG_LICENSE             = BSD
LIBTIRPC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBTIRPC_32_PKG_NAME)-pkg-description
LIBTIRPC_32_PKG_DESCRIPTION_FILE_IN = $(LIBTIRPC_32_PKG_NAME)-pkg-description.in
LIBTIRPC_32_PKG_INSTALL_SCRIPT      = $(LIBTIRPC_32_PKG_NAME)-pkg-install.sh

LIBTIRPC_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBTIRPC_32_PKG_NAME)-package

pkg_basename     = $(LIBTIRPC_32_PKG_NAME)-$(LIBTIRPC_32_PKG_VERSION)-$(LIBTIRPC_32_PKG_ARCH)-$(LIBTIRPC_32_PKG_DISTRO_NAME)-$(LIBTIRPC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBTIRPC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-gssapi
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
	@mkdir -p $(LIBTIRPC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBTIRPC_32_PKG)/etc
	@rm -rf $(LIBTIRPC_32_PKG)/usr/include
	@rm -rf $(LIBTIRPC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBTIRPC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libtirpc.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBTIRPC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtirpc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libtirpc.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtirpc.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBTIRPC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBTIRPC_32_PKG_DESCRIPTION_FILE): $(LIBTIRPC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBTIRPC_32_PKG_DESCRIPTION_FILE) $(LIBTIRPC_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBTIRPC_32_PKG_DESCRIPTION_FILE) $(LIBTIRPC_32_PKG)/.DESCRIPTION
	@cp $(LIBTIRPC_32_PKG_INSTALL_SCRIPT) $(LIBTIRPC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBTIRPC_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBTIRPC_32_PKG_NAME)"                            >  $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBTIRPC_32_PKG_VERSION)"                          >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBTIRPC_32_PKG_ARCH)"                               >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBTIRPC_32_PKG_DISTRO_NAME)"                  >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBTIRPC_32_PKG_DISTRO_VERSION)"                >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBTIRPC_32_PKG_GROUP)"                             >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBTIRPC_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBTIRPC_32_PKG_URL)"                                 >> $(LIBTIRPC_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBTIRPC_32_PKG_LICENSE)"                         >> $(LIBTIRPC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBTIRPC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
