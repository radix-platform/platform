
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/gmp

REQUIRES           = libs/eglibc/2.18.1


version            = 5.1.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/gmp/gmp-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gmp-$(version)
src_dir_name       = gmp-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gmp32_pkg    = $(TARGET_BUILD_DIR)/.gmp32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GMP32_PKG_NAME                = gmp32
GMP32_PKG_VERSION             = 5.1.3
ifeq ($(HARDWARE),$(TARGET_HOST))
GMP32_PKG_ARCH                = $(shell uname -m)
else
GMP32_PKG_ARCH                = $(TOOLCHAIN)
endif
GMP32_PKG_DISTRO_NAME         = kxLab
GMP32_PKG_DISTRO_VERSION      = 1.0
GMP32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GMP32_PKG_SHORT_DESCRIPTION   = gmp32 $(version)
GMP32_PKG_URL                 = http://www.kxLab.com
GMP32_PKG_LICENSE             = GPLv2
GMP32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GMP32_PKG_NAME)-pkg-description
GMP32_PKG_DESCRIPTION_FILE_IN = $(GMP32_PKG_NAME)-pkg-description.in
GMP32_PKG_INSTALL_SCRIPT      = $(GMP32_PKG_NAME)-pkg-install.sh

GMP32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GMP32_PKG_NAME)-package

pkg_basename     = $(GMP32_PKG_NAME)-$(GMP32_PKG_VERSION)-$(GMP32_PKG_ARCH)-$(GMP32_PKG_DISTRO_NAME)-$(GMP32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GMP32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gmp32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(GMP32_PKG)


OPTIMIZATION_FLAGS = -O3

CPPFLAGS          += -fexceptions

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX          = 32
else
LIBSUFFIX          =
endif

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --enable-cxx
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
	@mkdir -p $(GMP32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(GMP32_PKG)/usr/include
	@rm -rf $(GMP32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(GMP32_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libgmp.la ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libgmpxx.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GMP32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgmp.la ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgmpxx.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgmp.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgmpxx.la \
	 )
	@(cd $(GMP32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GMP32_PKG_DESCRIPTION_FILE): $(GMP32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gmp32_pkg): $(install_target) $(GMP32_PKG_DESCRIPTION_FILE)
	@cp $(GMP32_PKG_DESCRIPTION_FILE) $(GMP32_PKG)/.DESCRIPTION
	@cp $(GMP32_PKG_INSTALL_SCRIPT) $(GMP32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GMP32_PKG)/.REQUIRES
	@echo "pkgname=$(GMP32_PKG_NAME)"                            >  $(GMP32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GMP32_PKG_VERSION)"                          >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "arch=$(GMP32_PKG_ARCH)"                               >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GMP32_PKG_DISTRO_NAME)"                  >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GMP32_PKG_DISTRO_VERSION)"                >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "group=$(GMP32_PKG_GROUP)"                             >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GMP32_PKG_SHORT_DESCRIPTION)\"" >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "url=$(GMP32_PKG_URL)"                                 >> $(GMP32_PKG)/.PKGINFO ; \
	 echo "license=$(GMP32_PKG_LICENSE)"                         >> $(GMP32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GMP32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
