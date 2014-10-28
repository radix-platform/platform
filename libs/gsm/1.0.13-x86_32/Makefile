
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/gsm

REQUIRES           = libs/gsm/1.0.13
REQUIRES          += libs/eglibc/2.19.1-x86_32


version            = 1.0.13
arch_version       = 1.0-pl13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/gsm/gsm-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gsm-$(arch_version)
doc_dir_name       = gsm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

gsm_pc_in          = $(CURDIR)/gsm-pc/gsm.pc.in


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBGSM_32_PKG_NAME                = gsm-x32
LIBGSM_32_PKG_VERSION             = 1.0.13
LIBGSM_32_PKG_ARCH                = $(TOOLCHAIN)
LIBGSM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBGSM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBGSM_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBGSM_32_PKG_SHORT_DESCRIPTION   = GSM 06.10 lossy speech compression
LIBGSM_32_PKG_URL                 = $(BUG_URL)
LIBGSM_32_PKG_LICENSE             = BSD-style
LIBGSM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBGSM_32_PKG_NAME)-pkg-description
LIBGSM_32_PKG_DESCRIPTION_FILE_IN = $(LIBGSM_32_PKG_NAME)-pkg-description.in
LIBGSM_32_PKG_INSTALL_SCRIPT      = $(LIBGSM_32_PKG_NAME)-pkg-install.sh

LIBGSM_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBGSM_32_PKG_NAME)-package

pkg_basename     = $(LIBGSM_32_PKG_NAME)-$(LIBGSM_32_PKG_VERSION)-$(LIBGSM_32_PKG_ARCH)-$(LIBGSM_32_PKG_DISTRO_NAME)-$(LIBGSM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


build_env    = CCFLAGS="-c -fPIC $(CFLAGS)"

install_env  = INSTALL_ROOT="$(LIBGSM_32_PKG)/usr"
install_env += GSM_INSTALL_LIB="$(LIBGSM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)"
install_env += GSM_INSTALL_INC="$(LIBGSM_32_PKG)/usr/include/gsm"
install_env += GSM_INSTALL_MAN="$(LIBGSM_32_PKG)/usr/share/man/man3"
install_env += TOAST_INSTALL_BIN="$(LIBGSM_32_PKG)/usr/bin/32"
install_env += TOAST_INSTALL_MAN="$(LIBGSM_32_PKG)/usr/share/man/man1"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(build_env)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBGSM_32_PKG)/usr/bin/32
	@mkdir -p $(LIBGSM_32_PKG)/usr/include/gsm
	@mkdir -p $(LIBGSM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@mkdir -p $(LIBGSM_32_PKG)/usr/share/man/man{1,3}
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(install_env) install
	@chmod 0644 $(LIBGSM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libgsm.a
	# ======= Create package config file =======
	@mkdir -p $(LIBGSM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
	@sed -e "s,/lib,/lib$(MULTILIB_X86_32_SUFFIX)," $(gsm_pc_in) \
	  > $(LIBGSM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig/gsm.pc
	@rm -rf $(LIBGSM_32_PKG)/usr/include
	@rm -rf $(LIBGSM_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBGSM_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gsm.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBGSM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBGSM_32_PKG_DESCRIPTION_FILE): $(LIBGSM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBGSM_32_PKG_DESCRIPTION_FILE) $(LIBGSM_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBGSM_32_PKG_DESCRIPTION_FILE) $(LIBGSM_32_PKG)/.DESCRIPTION
	@cp $(LIBGSM_32_PKG_INSTALL_SCRIPT) $(LIBGSM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBGSM_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBGSM_32_PKG_NAME)"                            >  $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBGSM_32_PKG_VERSION)"                          >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBGSM_32_PKG_ARCH)"                               >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBGSM_32_PKG_DISTRO_NAME)"                  >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBGSM_32_PKG_DISTRO_VERSION)"                >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBGSM_32_PKG_GROUP)"                             >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBGSM_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBGSM_32_PKG_URL)"                                 >> $(LIBGSM_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBGSM_32_PKG_LICENSE)"                         >> $(LIBGSM_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBGSM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
