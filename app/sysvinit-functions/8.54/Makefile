
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/sysvinit-functions

ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/popt/1.16
else
REQUIRES           = libs/popt/1.16-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version             = 8.54
tar_bz2_archive     = $(SRC_PACKAGE_PATH)/packages/a/sysvinit-functions/function-src-$(version).tar.bz2
SRC_ARCHIVE         = $(tar_bz2_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/function-src-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


FUNCTIONS_DESCRIPTION_FILE_IN = $(CURDIR)/README.functions.in
FUNCTIONS_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/README.functions


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SYSVFUNC_PKG_NAME                = sysvinit-functions
SYSVFUNC_PKG_VERSION             = 8.54
SYSVFUNC_PKG_ARCH                = $(TOOLCHAIN)
SYSVFUNC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SYSVFUNC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SYSVFUNC_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
SYSVFUNC_PKG_SHORT_DESCRIPTION   = system V init functions
SYSVFUNC_PKG_URL                 = $(BUG_URL)
SYSVFUNC_PKG_LICENSE             = GPLv2
SYSVFUNC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SYSVFUNC_PKG_NAME)-pkg-description
SYSVFUNC_PKG_DESCRIPTION_FILE_IN = $(SYSVFUNC_PKG_NAME)-pkg-description.in
SYSVFUNC_PKG_INSTALL_SCRIPT      = $(SYSVFUNC_PKG_NAME)-pkg-install.sh

SYSVFUNC_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SYSVFUNC_PKG_NAME)-package

pkg_basename     = $(SYSVFUNC_PKG_NAME)-$(SYSVFUNC_PKG_VERSION)-$(SYSVFUNC_PKG_ARCH)-$(SYSVFUNC_PKG_DISTRO_NAME)-$(SYSVFUNC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SYSVFUNC_PKG)

#
# NOTE:
#   sysvinit doesn't want to have -I$(TARGET_DEST_DIR)/usr/include in CFLAGS
#   but we have to pass the architecture dependend CFLAGS. In this case we
#   overwrite CFLAGS with ARCH_FLAGS value to remove standatd -I flags added
#   by build-system.
#
# GCC CPP documentation:
#   All directories named by ‘-isystem’ are searched after all directories
#   named by ‘-I’, no matter what their order was on the command line. If the
#   same directory is named by both ‘-I’ and ‘-isystem’, the ‘-I’ option is
#   ignored. GCC provides an informative message when this occurs if ‘-v’ is
#   used. For example, we can make use following CFLAGS:
#
#     CFLAGS = -v -isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS)
#
CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(ARCH_FLAGS) $(OPTIMISATION_FLAGS) -D_GNU_SOURCE


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(FUNCTIONS_DESCRIPTION_FILE): $(FUNCTIONS_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(install_target): $(build_target) $(FUNCTIONS_DESCRIPTION_FILE)
	@mkdir -p $(SYSVFUNC_PKG)/bin $(SYSVFUNC_PKG)/sbin $(SYSVFUNC_PKG)/usr/share/man/man{1,8}
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(SYSVFUNC_PKG)/etc/rc.d/init.d
	@cp -a $(SRC_DIR)/rc.d/init.d/functions $(SYSVFUNC_PKG)/etc/rc.d/init.d
	@cp -a $(FUNCTIONS_DESCRIPTION_FILE) $(SYSVFUNC_PKG)/etc/rc.d/init.d
	@mkdir -p $(SYSVFUNC_PKG)/etc/rc.d/rc{0,1,2,3,4,5,6}.d
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SYSVFUNC_PKG))
	# ======= Strip binaries =======
	@( cd $(SYSVFUNC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(SYSVFUNC_PKG_DESCRIPTION_FILE): $(SYSVFUNC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SYSVFUNC_PKG_DESCRIPTION_FILE) $(SYSVFUNC_PKG_INSTALL_SCRIPT)
	@cp $(SYSVFUNC_PKG_DESCRIPTION_FILE) $(SYSVFUNC_PKG)/.DESCRIPTION
	@cp $(SYSVFUNC_PKG_INSTALL_SCRIPT) $(SYSVFUNC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SYSVFUNC_PKG)/.REQUIRES
	@echo "pkgname=$(SYSVFUNC_PKG_NAME)"                            >  $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SYSVFUNC_PKG_VERSION)"                          >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "arch=$(SYSVFUNC_PKG_ARCH)"                               >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "distroname=$(SYSVFUNC_PKG_DISTRO_NAME)"                  >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "distrover=$(SYSVFUNC_PKG_DISTRO_VERSION)"                >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "group=$(SYSVFUNC_PKG_GROUP)"                             >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SYSVFUNC_PKG_SHORT_DESCRIPTION)\"" >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "url=$(SYSVFUNC_PKG_URL)"                                 >> $(SYSVFUNC_PKG)/.PKGINFO ; \
	 echo "license=$(SYSVFUNC_PKG_LICENSE)"                         >> $(SYSVFUNC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SYSVFUNC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
