
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires eglibc libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


version = 2.18.1

SOURCE_REQUIRES   = $(SRC_PACKAGE_DIR)/GNU/EGLIBC/$(version)


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES          = libs/eglibc/2.18.1-x86_32
else
REQUIRES          = dev/gcc-runtime
endif

tar_bz2_archive   = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/$(version)/eglibc-$(version).tar.bz2
tar_bz2_archive_ports = $(SRC_PACKAGE_PATH)/GNU/EGLIBC/2.18.1/eglibc-ports-2.18.1.tar.bz2

SRC_ARCHIVE       = $(tar_bz2_archive)
SRC_DIR           = $(CURDIR)/eglibc-$(version)
src_dir_name      = eglibc-$(version)
src_done          = $(SRC_DIR)/.source-done

PATCHES           = PATCHES

build_dir         = $(TARGET_BUILD_DIR)/build
install_target    = $(TARGET_BUILD_DIR)/.installed


build_eglibc_pkg  = $(TARGET_BUILD_DIR)/.eglibc_pkg_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EGLIBC_PKG_NAME                = eglibc
EGLIBC_PKG_VERSION             = 2.18.1
ifeq ($(HARDWARE),$(TARGET_HOST))
EGLIBC_PKG_ARCH                = $(shell uname -m)
else
EGLIBC_PKG_ARCH                = $(TOOLCHAIN)
endif
EGLIBC_PKG_DISTRO_NAME         = kxLab
EGLIBC_PKG_DISTRO_VERSION      = 1.0
EGLIBC_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
EGLIBC_PKG_SHORT_DESCRIPTION   = eglibc $(version) header files
EGLIBC_PKG_URL                 = http://www.kxLab.com
EGLIBC_PKG_LICENSE             = GPLv2
EGLIBC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EGLIBC_PKG_NAME)-pkg-description
EGLIBC_PKG_DESCRIPTION_FILE_IN = $(EGLIBC_PKG_NAME)-pkg-description.in
EGLIBC_PKG_INSTALL_SCRIPT      = $(EGLIBC_PKG_NAME)-pkg-install.sh

EGLIBC_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EGLIBC_PKG_NAME)-package

pkg_basename     = $(EGLIBC_PKG_NAME)-$(EGLIBC_PKG_VERSION)-$(EGLIBC_PKG_ARCH)-$(EGLIBC_PKG_DISTRO_NAME)-$(EGLIBC_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(EGLIBC_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_eglibc_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


sysroot_dir  = $(EGLIBC_PKG)
env_sysroot  = install_root=$(sysroot_dir)

CFLAGS      += -g -O3


ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX    = 64
else
LIBSUFFIX    =
endif


extra_configure_switches  += --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches  += --with-headers=$(TARGET_DEST_DIR)/usr/include
extra_configure_switches  += --enable-add-ons=libidn,nptl,ports
extra_configure_switches  += --with-binutils=$(TARGET_DEST_DIR)/bin
extra_configure_switches  += --enable-kernel=2.6.36
extra_configure_switches  += --disable-profile
extra_configure_switches  += --without-gd
extra_configure_switches  += --without-cvs
extra_configure_switches  += --with-tls
extra_configure_switches  += --with-__thread


ifeq ($(TOOLCHAIN),$(DM644X_EGLIBC_TOOLCHAIN_NAME))
extra_configure_switches  += --without-fp
endif



$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	tar xjf $(tar_bz2_archive_ports) -C $(SRC_DIR)
	mv $(SRC_DIR)/eglibc-ports-2.18.1 $(SRC_DIR)/ports
	@touch $@

$(build_dir): $(src_done)
	mkdir -p $@

$(EGLIBC_PKG): $(build_dir)
	@mkdir -p $@

$(install_target): $(EGLIBC_PKG)
	echo "slibdir=/lib$(LIBSUFFIX)" >> $(build_dir)/configparms
	cd $(build_dir) && $(BUILD_ENVIRONMENT) $(env_sysroot) $(environment) ../../../$(src_dir_name)/configure \
	  --prefix=/usr                \
	  --build=$(BUILD)             \
	  --host=$(TARGET)             \
	  $(extra_configure_switches)
	cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) all install $(env_sysroot)
	rm -f $(sysroot_dir)/usr/share/info/dir
	@touch $@


$(EGLIBC_PKG_DESCRIPTION_FILE): $(EGLIBC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_eglibc_pkg): $(install_target) $(EGLIBC_PKG_DESCRIPTION_FILE)
	@mkdir -p $(EGLIBC_PKG)/usr/doc/eglibc-$(version)
	@cp -a  $(SRC_DIR)/BUGS $(SRC_DIR)/CONFORMANCE $(SRC_DIR)/COPYING*  \
	        $(SRC_DIR)/ChangeLog* $(SRC_DIR)/EGLIBC* $(SRC_DIR)/INSTALL \
	        $(SRC_DIR)/LICENSES $(SRC_DIR)/NAMESPACE $(SRC_DIR)/NEWS $(SRC_DIR)/README \
	        $(EGLIBC_PKG)/usr/doc/eglibc-$(version)
	@mkdir -p $(EGLIBC_PKG)/usr/doc/eglibc-$(version)/ports
	@cp -a  $(SRC_DIR)/ports/ChangeLog* $(SRC_DIR)/ports/README \
	        $(EGLIBC_PKG)/usr/doc/eglibc-$(version)/ports
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EGLIBC_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@( cd $(EGLIBC_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@cp $(EGLIBC_PKG_DESCRIPTION_FILE) $(EGLIBC_PKG)/.DESCRIPTION
	@cp $(EGLIBC_PKG_INSTALL_SCRIPT) $(EGLIBC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EGLIBC_PKG)/.REQUIRES
	@echo "pkgname=$(EGLIBC_PKG_NAME)"                            >  $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EGLIBC_PKG_VERSION)"                          >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "arch=$(EGLIBC_PKG_ARCH)"                               >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "distroname=$(EGLIBC_PKG_DISTRO_NAME)"                  >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "distrover=$(EGLIBC_PKG_DISTRO_VERSION)"                >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "group=$(EGLIBC_PKG_GROUP)"                             >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EGLIBC_PKG_SHORT_DESCRIPTION)\"" >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "url=$(EGLIBC_PKG_URL)"                                 >> $(EGLIBC_PKG)/.PKGINFO ; \
	 echo "license=$(EGLIBC_PKG_LICENSE)"                         >> $(EGLIBC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EGLIBC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
