
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


NEED_ABS_PATH = true


include ../../build-system/constants.mk


# ======= __END_OF_REQUIRES__ =======


PKG_GROUP = base

SYSINIT_BIN_PKG_NAME                = radix-system
SYSINIT_BIN_PKG_VERSION             = 1.0.9
SYSINIT_BIN_PKG_ARCH                = $(TOOLCHAIN)
SYSINIT_BIN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SYSINIT_BIN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SYSINIT_BIN_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
SYSINIT_BIN_PKG_SHORT_DESCRIPTION   = Radix System Scripts
SYSINIT_BIN_PKG_URL                 = $(BUG_URL)
SYSINIT_BIN_PKG_LICENSE             = LGPLv2.1
SYSINIT_BIN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SYSINIT_BIN_PKG_NAME)-pkg-description
SYSINIT_BIN_PKG_DESCRIPTION_FILE_IN = $(SYSINIT_BIN_PKG_NAME)-pkg-description.in
SYSINIT_BIN_PKG_INSTALL_SCRIPT      = $(SYSINIT_BIN_PKG_NAME)-pkg-install.sh


SYSINIT_BIN_PKG = $(TARGET_BUILD_DIR)/$(SYSINIT_BIN_PKG_NAME)-package

build = $(TARGET_BUILD_DIR)/.done

pkg_basename    = $(SYSINIT_BIN_PKG_NAME)-$(SYSINIT_BIN_PKG_VERSION)-$(SYSINIT_BIN_PKG_ARCH)-$(SYSINIT_BIN_PKG_DISTRO_NAME)-$(SYSINIT_BIN_PKG_DISTRO_VERSION)

pkg_archive     = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature   = $(call sign-name,$(pkg_archive))
pkg_description = $(call desc-name,$(pkg_archive))
products        = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS   = $(build)

PRODUCT_TARGETS = $(products)

ROOTFS_TARGETS  = $(pkg_archive)


include ../../build-system/core.mk


$(build):
	@mkdir -p $(SYSINIT_BIN_PKG)/{dev,etc,home,media,proc,root,run,sys,tmp}
	@mkdir -p $(SYSINIT_BIN_PKG)/var/{log,run,tmp}
	@touch $(SYSINIT_BIN_PKG)/var/log/wtmp
	@touch $(SYSINIT_BIN_PKG)/var/run/utmp
	@( cd $(SYSINIT_BIN_PKG)/var ; \
	   ln -sf log adm ; \
	 )
	@touch $@

$(SYSINIT_BIN_PKG_DESCRIPTION_FILE): $(SYSINIT_BIN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(SYSINIT_BIN_PKG_VERSION)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(build) $(SYSINIT_BIN_PKG_DESCRIPTION_FILE) $(SYSINIT_BIN_PKG_INSTALL_SCRIPT)
	@cp $(SYSINIT_BIN_PKG_DESCRIPTION_FILE) $(SYSINIT_BIN_PKG)/.DESCRIPTION
	@cp $(SYSINIT_BIN_PKG_INSTALL_SCRIPT) $(SYSINIT_BIN_PKG)/.INSTALL
	@$(BUILD_BIN_PKG_REQUIRES) $(SYSINIT_BIN_PKG)/.REQUIRES
	@echo "pkgname=$(SYSINIT_BIN_PKG_NAME)"                            >  $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SYSINIT_BIN_PKG_VERSION)"                          >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "arch=$(SYSINIT_BIN_PKG_ARCH)"                               >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "distroname=$(SYSINIT_BIN_PKG_DISTRO_NAME)"                  >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "distrover=$(SYSINIT_BIN_PKG_DISTRO_VERSION)"                >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "group=$(SYSINIT_BIN_PKG_GROUP)"                             >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SYSINIT_BIN_PKG_SHORT_DESCRIPTION)\"" >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "url=$(SYSINIT_BIN_PKG_URL)"                                 >> $(SYSINIT_BIN_PKG)/.PKGINFO ; \
	 echo "license=$(SYSINIT_BIN_PKG_LICENSE)"                         >> $(SYSINIT_BIN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SYSINIT_BIN_PKG)  && \
	                    chown -R 0:0 .       && \
	                    chown -R 0:22 var/log/wtmp var/run/utmp && \
	                    $(MAKE_PACKAGE) --linkadd yes .."
