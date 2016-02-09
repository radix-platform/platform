
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/netkit-rwho

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.22
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-rwho/netkit-rwho-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-rwho-$(version)
src_dir_name       = netkit-rwho-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
RWHO_PKG_NAME                = netkit-rwho
RWHO_PKG_VERSION             = 0.17
RWHO_PKG_ARCH                = $(TOOLCHAIN)
RWHO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
RWHO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
RWHO_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
RWHO_PKG_SHORT_DESCRIPTION   = who is logged in on local machines
RWHO_PKG_URL                 = $(BUG_URL)
RWHO_PKG_LICENSE             = BSD
RWHO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(RWHO_PKG_NAME)-pkg-description
RWHO_PKG_DESCRIPTION_FILE_IN = $(RWHO_PKG_NAME)-pkg-description.in
RWHO_PKG_INSTALL_SCRIPT      = $(RWHO_PKG_NAME)-pkg-install.sh

RWHO_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(RWHO_PKG_NAME)-package

pkg_basename     = $(RWHO_PKG_NAME)-$(RWHO_PKG_VERSION)-$(RWHO_PKG_ARCH)-$(RWHO_PKG_DISTRO_NAME)-$(RWHO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


rwho_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
rwho_environment = CFLAGS="$(rwho_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rwho_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(rwho_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(RWHO_PKG)/usr/{bin,sbin}
	@mkdir -p $(RWHO_PKG)/usr/share/man/man{1,8}
	@mkdir -p $(RWHO_PKG)/var/spool/rwho
	@mkdir -p $(RWHO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/rwho ; \
	   cat rwho > $(RWHO_PKG)/usr/bin/rwho ; \
	   cat rwho.1 | gzip -9c > $(RWHO_PKG)/usr/share/man/man1/rwho.1.gz ; \
	 )
	@( cd $(SRC_DIR)/rwhod ; \
	   cat rwhod > $(RWHO_PKG)/usr/sbin/rwhod ; \
	   cat rwhod.8 | gzip -9c > $(RWHO_PKG)/usr/share/man/man8/rwhod.8.gz ; \
	 )
	@( cd $(SRC_DIR)/ruptime ; \
	   cat ruptime > $(RWHO_PKG)/usr/bin/ruptime ; \
	   cat ruptime.1 | gzip -9c > $(RWHO_PKG)/usr/share/man/man1/ruptime.1.gz ; \
	 )
	@chmod 755 $(RWHO_PKG)/usr/bin/*
	@chmod 755 $(RWHO_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(RWHO_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(RWHO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(RWHO_PKG))
	# ======= Strip binaries =======
	@( cd $(RWHO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(RWHO_PKG_DESCRIPTION_FILE): $(RWHO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(RWHO_PKG_DESCRIPTION_FILE) $(RWHO_PKG_INSTALL_SCRIPT)
	@cp $(RWHO_PKG_DESCRIPTION_FILE) $(RWHO_PKG)/.DESCRIPTION
	@cp $(RWHO_PKG_INSTALL_SCRIPT) $(RWHO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(RWHO_PKG)/.REQUIRES
	@echo "pkgname=$(RWHO_PKG_NAME)"                            >  $(RWHO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(RWHO_PKG_VERSION)"                          >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "arch=$(RWHO_PKG_ARCH)"                               >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "distroname=$(RWHO_PKG_DISTRO_NAME)"                  >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "distrover=$(RWHO_PKG_DISTRO_VERSION)"                >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "group=$(RWHO_PKG_GROUP)"                             >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(RWHO_PKG_SHORT_DESCRIPTION)\"" >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "url=$(RWHO_PKG_URL)"                                 >> $(RWHO_PKG)/.PKGINFO ; \
	 echo "license=$(RWHO_PKG_LICENSE)"                         >> $(RWHO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(RWHO_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
