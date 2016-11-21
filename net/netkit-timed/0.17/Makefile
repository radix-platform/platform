
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/netkit-timed

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.17
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/netkit-timed/netkit-timed-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/netkit-timed-$(version)
src_dir_name       = netkit-timed-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TIMED_PKG_NAME                = netkit-timed
TIMED_PKG_VERSION             = 0.17
TIMED_PKG_ARCH                = $(TOOLCHAIN)
TIMED_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TIMED_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TIMED_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
TIMED_PKG_SHORT_DESCRIPTION   = time server daemon
TIMED_PKG_URL                 = $(BUG_URL)
TIMED_PKG_LICENSE             = BSD
TIMED_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TIMED_PKG_NAME)-pkg-description
TIMED_PKG_DESCRIPTION_FILE_IN = $(TIMED_PKG_NAME)-pkg-description.in
TIMED_PKG_INSTALL_SCRIPT      = $(TIMED_PKG_NAME)-pkg-install.sh

TIMED_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TIMED_PKG_NAME)-package

pkg_basename     = $(TIMED_PKG_NAME)-$(TIMED_PKG_VERSION)-$(TIMED_PKG_ARCH)-$(TIMED_PKG_DISTRO_NAME)-$(TIMED_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


timed_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
timed_environment = CFLAGS="$(timed_CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(timed_environment) ./configure --prefix=/usr
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(timed_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TIMED_PKG)/usr/sbin
	@mkdir -p $(TIMED_PKG)/usr/share/man/man8
	@mkdir -p $(TIMED_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/timed/timed ; \
	   cat timed > $(TIMED_PKG)/usr/sbin/in.timed ; \
	   cat timed.8 | gzip -9c > $(TIMED_PKG)/usr/share/man/man8/in.timed.8.gz ; \
	 )
	@( cd $(SRC_DIR)/timed/timedc ; \
	   cat timedc > $(TIMED_PKG)/usr/sbin/timedc ; \
	   cat timedc.8 | gzip -9c > $(TIMED_PKG)/usr/share/man/man8/timedc.8.gz ; \
	 )
	@chmod 755 $(TIMED_PKG)/usr/sbin/*
	# ======= Install Documentation =======
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(TIMED_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(TIMED_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TIMED_PKG))
	# ======= Strip binaries =======
	@( cd $(TIMED_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(TIMED_PKG_DESCRIPTION_FILE): $(TIMED_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TIMED_PKG_DESCRIPTION_FILE) $(TIMED_PKG_INSTALL_SCRIPT)
	@cp $(TIMED_PKG_DESCRIPTION_FILE) $(TIMED_PKG)/.DESCRIPTION
	@cp $(TIMED_PKG_INSTALL_SCRIPT) $(TIMED_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TIMED_PKG)/.REQUIRES
	@echo "pkgname=$(TIMED_PKG_NAME)"                            >  $(TIMED_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TIMED_PKG_VERSION)"                          >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "arch=$(TIMED_PKG_ARCH)"                               >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "distroname=$(TIMED_PKG_DISTRO_NAME)"                  >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "distrover=$(TIMED_PKG_DISTRO_VERSION)"                >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "group=$(TIMED_PKG_GROUP)"                             >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TIMED_PKG_SHORT_DESCRIPTION)\"" >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "url=$(TIMED_PKG_URL)"                                 >> $(TIMED_PKG)/.PKGINFO ; \
	 echo "license=$(TIMED_PKG_LICENSE)"                         >> $(TIMED_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TIMED_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
