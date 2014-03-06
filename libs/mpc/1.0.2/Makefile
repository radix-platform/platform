
COMPONENT_TARGETS  = $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/mpc


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/mpc/1.0.2-x86_32
else
REQUIRES           = libs/gmp/5.1.3
REQUIRES           = libs/mpfr/3.1.2
endif

version            = 1.0.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/mpc/mpc-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mpc-$(version)
src_dir_name       = mpc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_mpc_pkg      = $(TARGET_BUILD_DIR)/.mpc_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MPC_PKG_NAME                = mpc
MPC_PKG_VERSION             = 1.0.2
ifeq ($(HARDWARE),$(TARGET_HOST))
MPC_PKG_ARCH                = $(shell uname -m)
else
MPC_PKG_ARCH                = $(TOOLCHAIN)
endif
MPC_PKG_DISTRO_NAME         = kxLab
MPC_PKG_DISTRO_VERSION      = 1.0
MPC_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
MPC_PKG_SHORT_DESCRIPTION   = mpc $(version)
MPC_PKG_URL                 = http://www.kxLab.com
MPC_PKG_LICENSE             = GPLv2
MPC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPC_PKG_NAME)-pkg-description
MPC_PKG_DESCRIPTION_FILE_IN = $(MPC_PKG_NAME)-pkg-description.in
MPC_PKG_INSTALL_SCRIPT      = $(MPC_PKG_NAME)-pkg-install.sh

MPC_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPC_PKG_NAME)-package

pkg_basename     = $(MPC_PKG_NAME)-$(MPC_PKG_VERSION)-$(MPC_PKG_ARCH)-$(MPC_PKG_DISTRO_NAME)-$(MPC_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(MPC_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_mpc_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(MPC_PKG)


OPTIMIZATION_FLAGS = -O3

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(MPC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(MPC_PKG)/usr/share/info/dir
	@gzip -9 $(MPC_PKG)/usr/share/info/*
	@mkdir -p $(MPC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* $(SRC_DIR)/INSTALL* \
	       $(SRC_DIR)/NEWS $(SRC_DIR)/README $(SRC_DIR)/TODO \
	       $(MPC_PKG)/usr/doc/$(src_dir_name)
	# remove toolchain path from target libtool *.la files and
	@( cd $(MPC_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libmpc.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(MPC_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpc.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpc.la \
	 )
	@(cd $(MPC_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(MPC_PKG_DESCRIPTION_FILE): $(MPC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_mpc_pkg): $(install_target) $(MPC_PKG_DESCRIPTION_FILE)
	@cp $(MPC_PKG_DESCRIPTION_FILE) $(MPC_PKG)/.DESCRIPTION
	@cp $(MPC_PKG_INSTALL_SCRIPT) $(MPC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPC_PKG)/.REQUIRES
	@echo "pkgname=$(MPC_PKG_NAME)"                            >  $(MPC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPC_PKG_VERSION)"                          >> $(MPC_PKG)/.PKGINFO ; \
	 echo "arch=$(MPC_PKG_ARCH)"                               >> $(MPC_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPC_PKG_DISTRO_NAME)"                  >> $(MPC_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPC_PKG_DISTRO_VERSION)"                >> $(MPC_PKG)/.PKGINFO ; \
	 echo "group=$(MPC_PKG_GROUP)"                             >> $(MPC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPC_PKG_SHORT_DESCRIPTION)\"" >> $(MPC_PKG)/.PKGINFO ; \
	 echo "url=$(MPC_PKG_URL)"                                 >> $(MPC_PKG)/.PKGINFO ; \
	 echo "license=$(MPC_PKG_LICENSE)"                         >> $(MPC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MPC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
