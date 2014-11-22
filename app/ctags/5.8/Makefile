
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


SOURCE_REQUIRES     = sources/packages/a/ctags

REQUIRES            = libs/eglibc/2.19.1


version             = 5.8
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/ctags/ctags-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/ctags-$(version)
src_dir_name        = ctags-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CTAGS_PKG_NAME                = ctags
CTAGS_PKG_VERSION             = 5.8
CTAGS_PKG_ARCH                = $(TOOLCHAIN)
CTAGS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CTAGS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CTAGS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CTAGS_PKG_SHORT_DESCRIPTION   = Exuberant Ctags
CTAGS_PKG_URL                 = $(BUG_URL)
CTAGS_PKG_LICENSE             = GPLv2
CTAGS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CTAGS_PKG_NAME)-pkg-description
CTAGS_PKG_DESCRIPTION_FILE_IN = $(CTAGS_PKG_NAME)-pkg-description.in
CTAGS_PKG_INSTALL_SCRIPT      = $(CTAGS_PKG_NAME)-pkg-install.sh

CTAGS_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CTAGS_PKG_NAME)-package

pkg_basename     = $(CTAGS_PKG_NAME)-$(CTAGS_PKG_VERSION)-$(CTAGS_PKG_ARCH)-$(CTAGS_PKG_DISTRO_NAME)-$(CTAGS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CTAGS_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --bindir=/usr/bin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=                   \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CTAGS_PKG)/usr/bin
	# ======= Install binaries =======
	@cat $(build_dir)/ctags > $(CTAGS_PKG)/usr/bin/ctags
	@chmod 0755 $(CTAGS_PKG)/usr/bin/ctags
	# ======= Install man page =======
	@mkdir -p $(CTAGS_PKG)/usr/share/man/man1
	@( cd $(SRC_DIR) ; \
	   cat ctags.1 | gzip -9c > $(CTAGS_PKG)/usr/share/man/man1/ctags.1.gz ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(CTAGS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(CTAGS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CTAGS_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING FAQ INSTALL* MAINTAINERS NEWS README \
	         $(CTAGS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@cp -a $(SRC_DIR)/ctags.html $(CTAGS_PKG)/usr/share/doc/$(src_dir_name)/html
	@cp -a $(SRC_DIR)/EXTENDING.html $(CTAGS_PKG)/usr/share/doc/$(src_dir_name)/html
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(CTAGS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(CTAGS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(CTAGS_PKG_DESCRIPTION_FILE): $(CTAGS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CTAGS_PKG_DESCRIPTION_FILE) $(CTAGS_PKG_INSTALL_SCRIPT)
	@cp $(CTAGS_PKG_DESCRIPTION_FILE) $(CTAGS_PKG)/.DESCRIPTION
	@cp $(CTAGS_PKG_INSTALL_SCRIPT) $(CTAGS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CTAGS_PKG)/.REQUIRES
	@echo "pkgname=$(CTAGS_PKG_NAME)"                            >  $(CTAGS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CTAGS_PKG_VERSION)"                          >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "arch=$(CTAGS_PKG_ARCH)"                               >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "distroname=$(CTAGS_PKG_DISTRO_NAME)"                  >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "distrover=$(CTAGS_PKG_DISTRO_VERSION)"                >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "group=$(CTAGS_PKG_GROUP)"                             >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CTAGS_PKG_SHORT_DESCRIPTION)\"" >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "url=$(CTAGS_PKG_URL)"                                 >> $(CTAGS_PKG)/.PKGINFO ; \
	 echo "license=$(CTAGS_PKG_LICENSE)"                         >> $(CTAGS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CTAGS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
