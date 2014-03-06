
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNOME/core/glib

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/libffi/3.0.13


version            = 2.39.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/glib/glib-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glib-$(version)
src_dir_name       = glib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_glib2x32_pkg = $(TARGET_BUILD_DIR)/.glib2x32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIB2_32_PKG_NAME                = glib2x32
GLIB2_32_PKG_VERSION             = 2.39.4
ifeq ($(HARDWARE),$(TARGET_HOST))
GLIB2_32_PKG_ARCH                = $(shell uname -m)
else
GLIB2_32_PKG_ARCH                = $(TOOLCHAIN)
endif
GLIB2_32_PKG_DISTRO_NAME         = kxLab
GLIB2_32_PKG_DISTRO_VERSION      = 1.0
GLIB2_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GLIB2_32_PKG_SHORT_DESCRIPTION   = glib2x32 $(version)
GLIB2_32_PKG_URL                 = http://www.kxLab.com
GLIB2_32_PKG_LICENSE             = GPLv2
GLIB2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIB2_32_PKG_NAME)-pkg-description
GLIB2_32_PKG_DESCRIPTION_FILE_IN = $(GLIB2_32_PKG_NAME)-pkg-description.in
GLIB2_32_PKG_INSTALL_SCRIPT      = $(GLIB2_32_PKG_NAME)-pkg-install.sh

GLIB2_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIB2_32_PKG_NAME)-package

pkg_basename     = $(GLIB2_32_PKG_NAME)-$(GLIB2_32_PKG_VERSION)-$(GLIB2_32_PKG_ARCH)-$(GLIB2_32_PKG_DISTRO_NAME)-$(GLIB2_32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GLIB2_32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_glib2x32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(GLIB2_32_PKG)


OPTIMIZATION_FLAGS = -O3

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
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared
# uncomment next line to prevent building static *.a library:
# extra_configure_switches += --disable-static


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
	@mkdir -p $(GLIB2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	exit 1
	# libffi make suggestion about toolexeclibdir according to gcc -print-multi-os-directory
	# we shoul prevent so stupid behaviour related to x86_WIN32 target in linux
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
	@mv $(GLIB2_32_PKG)/usr/lib/* $(GLIB2_32_PKG)/usr/lib$(LIBSUFFIX)
	@rm -rf $(GLIB2_32_PKG)/usr/lib
	@( cd $(GLIB2_32_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib32/../lib',libdir='/usr/lib32',g" libffi.la \
	 )
endif
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@mv $(GLIB2_32_PKG)/usr/lib64/* $(GLIB2_32_PKG)/usr/lib$(LIBSUFFIX)
	@rm -rf $(GLIB2_32_PKG)/usr/lib64
	@( cd $(GLIB2_32_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib/../lib64',libdir='/usr/lib',g" libffi.la \
	 )
endif
	@mkdir -p $(GLIB2_32_PKG)/lib$(LIBSUFFIX)
	@( cd $(GLIB2_32_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@rm -rf $(GLIB2_32_PKG)/usr/include
	@rm -rf $(GLIB2_32_PKG)/usr/share
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GLIB2_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(GLIB2_32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GLIB2_32_PKG_DESCRIPTION_FILE): $(GLIB2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_glib2x32_pkg): $(install_target) $(GLIB2_32_PKG_DESCRIPTION_FILE)
	@cp $(GLIB2_32_PKG_DESCRIPTION_FILE) $(GLIB2_32_PKG)/.DESCRIPTION
	@cp $(GLIB2_32_PKG_INSTALL_SCRIPT) $(GLIB2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIB2_32_PKG)/.REQUIRES
	@echo "pkgname=$(GLIB2_32_PKG_NAME)"                            >  $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIB2_32_PKG_VERSION)"                          >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIB2_32_PKG_ARCH)"                               >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIB2_32_PKG_DISTRO_NAME)"                  >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIB2_32_PKG_DISTRO_VERSION)"                >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "group=$(GLIB2_32_PKG_GROUP)"                             >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIB2_32_PKG_SHORT_DESCRIPTION)\"" >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "url=$(GLIB2_32_PKG_URL)"                                 >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "license=$(GLIB2_32_PKG_LICENSE)"                         >> $(GLIB2_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLIB2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
