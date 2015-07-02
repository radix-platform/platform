
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/GNU/readline

REQUIRES             = libs/readline/6.3
REQUIRES            += libs/ncurses/5.9-x86_32
REQUIRES            += libs/libtermcap/1.2.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 6.3
tar_gz_archive       = $(SRC_PACKAGE_PATH)/GNU/readline/readline-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/readline-$(version)
src_dir_name         = readline-$(version)
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
READLINE32_PKG_NAME                = readline-x32
READLINE32_PKG_VERSION             = 6.3
READLINE32_PKG_ARCH                = $(TOOLCHAIN)
READLINE32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
READLINE32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
READLINE32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
READLINE32_PKG_SHORT_DESCRIPTION   = line input library with editing features
READLINE32_PKG_URL                 = $(BUG_URL)
READLINE32_PKG_LICENSE             = GPLv2
READLINE32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(READLINE32_PKG_NAME)-pkg-description
READLINE32_PKG_DESCRIPTION_FILE_IN = $(READLINE32_PKG_NAME)-pkg-description.in
READLINE32_PKG_INSTALL_SCRIPT      = $(READLINE32_PKG_NAME)-pkg-install.sh

READLINE32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(READLINE32_PKG_NAME)-package

pkg_basename     = $(READLINE32_PKG_NAME)-$(READLINE32_PKG_VERSION)-$(READLINE32_PKG_ARCH)-$(READLINE32_PKG_DISTRO_NAME)-$(READLINE32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(READLINE32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-curses
extra_configure_switches += --enable-multibyte
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) static shared
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(READLINE32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(READLINE32_PKG)/usr/bin
	@rm -rf $(READLINE32_PKG)/usr/include
	@rm -rf $(READLINE32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(READLINE32_PKG))
	# ======= Strip binaries =======
	@( cd $(READLINE32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(READLINE32_PKG_DESCRIPTION_FILE): $(READLINE32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(READLINE32_PKG_DESCRIPTION_FILE) $(READLINE32_PKG_INSTALL_SCRIPT)
	@cp $(READLINE32_PKG_DESCRIPTION_FILE) $(READLINE32_PKG)/.DESCRIPTION
	@cp $(READLINE32_PKG_INSTALL_SCRIPT) $(READLINE32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(READLINE32_PKG)/.REQUIRES
	@echo "pkgname=$(READLINE32_PKG_NAME)"                            >  $(READLINE32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(READLINE32_PKG_VERSION)"                          >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "arch=$(READLINE32_PKG_ARCH)"                               >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "distroname=$(READLINE32_PKG_DISTRO_NAME)"                  >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "distrover=$(READLINE32_PKG_DISTRO_VERSION)"                >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "group=$(READLINE32_PKG_GROUP)"                             >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(READLINE32_PKG_SHORT_DESCRIPTION)\"" >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "url=$(READLINE32_PKG_URL)"                                 >> $(READLINE32_PKG)/.PKGINFO ; \
	 echo "license=$(READLINE32_PKG_LICENSE)"                         >> $(READLINE32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(READLINE32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
