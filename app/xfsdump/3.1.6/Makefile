
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/xfsdump

REQUIRES           = libs/ncurses/6.0
REQUIRES          += app/util-linux/2.27.1
REQUIRES          += app/attr/2.4.47
REQUIRES          += app/xfsprogs/4.3.0
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += libs/dmapi/2.2.12
else
REQUIRES          += libs/dmapi/2.2.12-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.1.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/xfsdump/xfsdump-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xfsdump-$(version)
src_dir_name       = xfsdump-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XFSDUMP_PKG_NAME                = xfsdump
XFSDUMP_PKG_VERSION             = 3.1.6
XFSDUMP_PKG_ARCH                = $(TOOLCHAIN)
XFSDUMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XFSDUMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XFSDUMP_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
XFSDUMP_PKG_SHORT_DESCRIPTION   = backup tools for the XFS filesystem
XFSDUMP_PKG_URL                 = $(BUG_URL)
XFSDUMP_PKG_LICENSE             = GPLv2
XFSDUMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XFSDUMP_PKG_NAME)-pkg-description
XFSDUMP_PKG_DESCRIPTION_FILE_IN = $(XFSDUMP_PKG_NAME)-pkg-description.in
XFSDUMP_PKG_INSTALL_SCRIPT      = $(XFSDUMP_PKG_NAME)-pkg-install.sh

XFSDUMP_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XFSDUMP_PKG_NAME)-package

pkg_basename     = $(XFSDUMP_PKG_NAME)-$(XFSDUMP_PKG_VERSION)-$(XFSDUMP_PKG_ARCH)-$(XFSDUMP_PKG_DISTRO_NAME)-$(XFSDUMP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(XFSDUMP_PKG)


extra_configure_switches  = --sbindir=/usr/sbin
extra_configure_switches += --bindir=/usr/sbin
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XFSDUMP_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(XFSDUMP_PKG)/usr/sbin ; \
	   if [ -L xfsdump ] ; then \
	     rm -f xfsdump ; ln -sf ../../sbin/xfsdump . ; \
	   fi ; \
	   if [ -L xfsrestore ] ; then \
	     rm -f xfsrestore ; ln -sf ../../sbin/xfsrestore . ; \
	   fi \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(XFSDUMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/COPYING* \
	       $(XFSDUMP_PKG)/usr/doc/$(src_dir_name)
	@mv $(XFSDUMP_PKG)/usr/share/doc/xfsdump $(XFSDUMP_PKG)/usr/share/doc/$(src_dir_name)
	@mkdir -p $(XFSDUMP_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a doc/INSTALL doc/xfsdump_ts.txt \
	         $(XFSDUMP_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/*.gif doc/*.html \
	         $(XFSDUMP_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XFSDUMP_PKG))
	# ======= Strip binaries =======
	@( cd $(XFSDUMP_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(XFSDUMP_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(XFSDUMP_PKG_DESCRIPTION_FILE): $(XFSDUMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XFSDUMP_PKG_DESCRIPTION_FILE) $(XFSDUMP_PKG_INSTALL_SCRIPT)
	@cp $(XFSDUMP_PKG_DESCRIPTION_FILE) $(XFSDUMP_PKG)/.DESCRIPTION
	@cp $(XFSDUMP_PKG_INSTALL_SCRIPT) $(XFSDUMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XFSDUMP_PKG)/.REQUIRES
	@echo "pkgname=$(XFSDUMP_PKG_NAME)"                            >  $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XFSDUMP_PKG_VERSION)"                          >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "arch=$(XFSDUMP_PKG_ARCH)"                               >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(XFSDUMP_PKG_DISTRO_NAME)"                  >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(XFSDUMP_PKG_DISTRO_VERSION)"                >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "group=$(XFSDUMP_PKG_GROUP)"                             >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XFSDUMP_PKG_SHORT_DESCRIPTION)\"" >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "url=$(XFSDUMP_PKG_URL)"                                 >> $(XFSDUMP_PKG)/.PKGINFO ; \
	 echo "license=$(XFSDUMP_PKG_LICENSE)"                         >> $(XFSDUMP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XFSDUMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
