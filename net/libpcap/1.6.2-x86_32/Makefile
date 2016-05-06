
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libpcap

REQUIRES             = net/libpcap/1.6.2
REQUIRES            += libs/libusb/1.0.20-x86_32
REQUIRES            += net/libnl3/3.2.25-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 1.6.2
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/n/libpcap/libpcap-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libpcap-$(version)
src_dir_name         = libpcap-$(version)
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
LIBPCAP_32_PKG_NAME                = libpcap-x32
LIBPCAP_32_PKG_VERSION             = 1.6.2
LIBPCAP_32_PKG_ARCH                = $(TOOLCHAIN)
LIBPCAP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBPCAP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBPCAP_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBPCAP_32_PKG_SHORT_DESCRIPTION   = packet capture library
LIBPCAP_32_PKG_URL                 = $(BUG_URL)
LIBPCAP_32_PKG_LICENSE             = BSD
LIBPCAP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBPCAP_32_PKG_NAME)-pkg-description
LIBPCAP_32_PKG_DESCRIPTION_FILE_IN = $(LIBPCAP_32_PKG_NAME)-pkg-description.in
LIBPCAP_32_PKG_INSTALL_SCRIPT      = $(LIBPCAP_32_PKG_NAME)-pkg-install.sh

LIBPCAP_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBPCAP_32_PKG_NAME)-package

pkg_basename     = $(LIBPCAP_32_PKG_NAME)-$(LIBPCAP_32_PKG_VERSION)-$(LIBPCAP_32_PKG_ARCH)-$(LIBPCAP_32_PKG_DISTRO_NAME)-$(LIBPCAP_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBPCAP_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-libnl
extra_configure_switches += --with-pcap=linux


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) shared
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBPCAP_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBPCAP_32_PKG)/usr/bin/32
	@( cd $(LIBPCAP_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(LIBPCAP_32_PKG)/usr/include
	@rm -rf $(LIBPCAP_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBPCAP_32_PKG))
	# ======= tune pcap-config script =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i 's,="/usr,="$(TARGET_DEST_DIR)/usr,g' pcap-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBPCAP_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBPCAP_32_PKG_DESCRIPTION_FILE): $(LIBPCAP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBPCAP_32_PKG_DESCRIPTION_FILE) $(LIBPCAP_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBPCAP_32_PKG_DESCRIPTION_FILE) $(LIBPCAP_32_PKG)/.DESCRIPTION
	@cp $(LIBPCAP_32_PKG_INSTALL_SCRIPT) $(LIBPCAP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBPCAP_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBPCAP_32_PKG_NAME)"                            >  $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBPCAP_32_PKG_VERSION)"                          >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBPCAP_32_PKG_ARCH)"                               >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBPCAP_32_PKG_DISTRO_NAME)"                  >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBPCAP_32_PKG_DISTRO_VERSION)"                >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBPCAP_32_PKG_GROUP)"                             >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBPCAP_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBPCAP_32_PKG_URL)"                                 >> $(LIBPCAP_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBPCAP_32_PKG_LICENSE)"                         >> $(LIBPCAP_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBPCAP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
