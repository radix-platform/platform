
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/mpc

REQUIRES           = libs/gmp/5.1.3
REQUIRES          += libs/mpfr/3.1.2


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
build_mpc32_pkg    = $(TARGET_BUILD_DIR)/.mpc32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MPC32_PKG_NAME                = mpc32
MPC32_PKG_VERSION             = 1.0.2
ifeq ($(HARDWARE),$(TARGET_HOST))
MPC32_PKG_ARCH                = $(shell uname -m)
else
MPC32_PKG_ARCH                = $(TOOLCHAIN)
endif
MPC32_PKG_DISTRO_NAME         = kxLab
MPC32_PKG_DISTRO_VERSION      = 1.0
MPC32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
MPC32_PKG_SHORT_DESCRIPTION   = mpc32 $(version)
MPC32_PKG_URL                 = http://www.kxLab.com
MPC32_PKG_LICENSE             = GPLv2
MPC32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPC32_PKG_NAME)-pkg-description
MPC32_PKG_DESCRIPTION_FILE_IN = $(MPC32_PKG_NAME)-pkg-description.in
MPC32_PKG_INSTALL_SCRIPT      = $(MPC32_PKG_NAME)-pkg-install.sh

MPC32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPC32_PKG_NAME)-package

pkg_basename     = $(MPC32_PKG_NAME)-$(MPC32_PKG_VERSION)-$(MPC32_PKG_ARCH)-$(MPC32_PKG_DISTRO_NAME)-$(MPC32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(MPC32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_mpc32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(MPC32_PKG)

OPTIMIZATION_FLAGS = -O3

# owerwrite LDFLAGS:
#
LDFLAGS            = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS           += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32           = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MPC32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(MPC32_PKG)/usr/include
	@rm -rf $(MPC32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(MPC32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libmpc.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(MPC32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpc.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpc.la \
	 )
	@(cd $(MPC32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(MPC32_PKG_DESCRIPTION_FILE): $(MPC32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_mpc32_pkg): $(install_target) $(MPC32_PKG_DESCRIPTION_FILE)
	@cp $(MPC32_PKG_DESCRIPTION_FILE) $(MPC32_PKG)/.DESCRIPTION
	@cp $(MPC32_PKG_INSTALL_SCRIPT) $(MPC32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPC32_PKG)/.REQUIRES
	@echo "pkgname=$(MPC32_PKG_NAME)"                            >  $(MPC32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPC32_PKG_VERSION)"                          >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "arch=$(MPC32_PKG_ARCH)"                               >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPC32_PKG_DISTRO_NAME)"                  >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPC32_PKG_DISTRO_VERSION)"                >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "group=$(MPC32_PKG_GROUP)"                             >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPC32_PKG_SHORT_DESCRIPTION)\"" >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "url=$(MPC32_PKG_URL)"                                 >> $(MPC32_PKG)/.PKGINFO ; \
	 echo "license=$(MPC32_PKG_LICENSE)"                         >> $(MPC32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MPC32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
