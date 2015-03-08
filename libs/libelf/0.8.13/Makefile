
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libelf

REQUIRES           = libs/eglibc/2.19.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.8.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libelf/libelf-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libelf-$(version)
src_dir_name       = libelf-$(version)
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
LIBELF_PKG_NAME                = libelf
LIBELF_PKG_VERSION             = 0.8.13
LIBELF_PKG_ARCH                = $(TOOLCHAIN)
LIBELF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBELF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBELF_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBELF_PKG_SHORT_DESCRIPTION   = ELF object file access library
LIBELF_PKG_URL                 = $(BUG_URL)
LIBELF_PKG_LICENSE             = GPLv2
LIBELF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBELF_PKG_NAME)-pkg-description
LIBELF_PKG_DESCRIPTION_FILE_IN = $(LIBELF_PKG_NAME)-pkg-description.in
LIBELF_PKG_INSTALL_SCRIPT      = $(LIBELF_PKG_NAME)-pkg-install.sh

LIBELF_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBELF_PKG_NAME)-package

pkg_basename     = $(LIBELF_PKG_NAME)-$(LIBELF_PKG_VERSION)-$(LIBELF_PKG_ARCH)-$(LIBELF_PKG_DISTRO_NAME)-$(LIBELF_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = instroot=$(LIBELF_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-compat

extra_configure_switches += --enable-shared


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBELF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	# ======= Install Documentation =======
	@mkdir -p $(LIBELF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(LIBELF_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBELF_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* INSTALL \
	         MANIFEST README VERSION \
	         $(LIBELF_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBELF_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBELF_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libelf.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBELF_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBELF_PKG_DESCRIPTION_FILE): $(LIBELF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBELF_PKG_DESCRIPTION_FILE) $(LIBELF_PKG_INSTALL_SCRIPT)
	@cp $(LIBELF_PKG_DESCRIPTION_FILE) $(LIBELF_PKG)/.DESCRIPTION
	@cp $(LIBELF_PKG_INSTALL_SCRIPT) $(LIBELF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBELF_PKG)/.REQUIRES
	@echo "pkgname=$(LIBELF_PKG_NAME)"                            >  $(LIBELF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBELF_PKG_VERSION)"                          >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBELF_PKG_ARCH)"                               >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBELF_PKG_DISTRO_NAME)"                  >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBELF_PKG_DISTRO_VERSION)"                >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "group=$(LIBELF_PKG_GROUP)"                             >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBELF_PKG_SHORT_DESCRIPTION)\"" >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "url=$(LIBELF_PKG_URL)"                                 >> $(LIBELF_PKG)/.PKGINFO ; \
	 echo "license=$(LIBELF_PKG_LICENSE)"                         >> $(LIBELF_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBELF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
