
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/libffi

REQUIRES           = libs/eglibc/2.18.1


version            = 3.0.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libffi/libffi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libffi-$(version)
src_dir_name       = libffi-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_libffi32_pkg = $(TARGET_BUILD_DIR)/.libffi32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBFFI32_PKG_NAME                = libffi32
LIBFFI32_PKG_VERSION             = 3.0.13
ifeq ($(HARDWARE),$(TARGET_HOST))
LIBFFI32_PKG_ARCH                = $(shell uname -m)
else
LIBFFI32_PKG_ARCH                = $(TOOLCHAIN)
endif
LIBFFI32_PKG_DISTRO_NAME         = kxLab
LIBFFI32_PKG_DISTRO_VERSION      = 1.0
LIBFFI32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBFFI32_PKG_SHORT_DESCRIPTION   = libffi32 $(version)
LIBFFI32_PKG_URL                 = http://www.kxLab.com
LIBFFI32_PKG_LICENSE             = GPLv2
LIBFFI32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBFFI32_PKG_NAME)-pkg-description
LIBFFI32_PKG_DESCRIPTION_FILE_IN = $(LIBFFI32_PKG_NAME)-pkg-description.in
LIBFFI32_PKG_INSTALL_SCRIPT      = $(LIBFFI32_PKG_NAME)-pkg-install.sh

LIBFFI32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBFFI32_PKG_NAME)-package

pkg_basename     = $(LIBFFI32_PKG_NAME)-$(LIBFFI32_PKG_VERSION)-$(LIBFFI32_PKG_ARCH)-$(LIBFFI32_PKG_DISTRO_NAME)-$(LIBFFI32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(LIBFFI32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_libffi32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(LIBFFI32_PKG)


LIBSUFFIX =

environment        = CFLAGS="-m32 -g -O3 -march=i486 -mtune=i686"

ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
LIBSUFFIX          = 32
endif


TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBFFI32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	# libffi make suggestion about toolexeclibdir according to gcc -print-multi-os-directory
	# we shoul prevent so stupid behaviour related to x86_WIN32 target in linux
ifeq ($(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME))
	@mv $(LIBFFI32_PKG)/usr/lib/* $(LIBFFI32_PKG)/usr/lib$(LIBSUFFIX)
	@rm -rf $(LIBFFI32_PKG)/usr/lib
	@( cd $(LIBFFI32_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib32/../lib',libdir='/usr/lib32',g" libffi.la \
	 )
endif
ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
	@mv $(LIBFFI32_PKG)/usr/lib64/* $(LIBFFI32_PKG)/usr/lib$(LIBSUFFIX)
	@rm -rf $(LIBFFI32_PKG)/usr/lib64
	@( cd $(LIBFFI32_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib/../lib64',libdir='/usr/lib',g" libffi.la \
	 )
endif
	@mkdir -p $(LIBFFI32_PKG)/lib$(LIBSUFFIX)
	@( cd $(LIBFFI32_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@rm -rf $(LIBFFI32_PKG)/usr/include
	@rm -rf $(LIBFFI32_PKG)/usr/share
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBFFI32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib$(LIBSUFFIX)',libdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)',g" libffi.la \
	 )
	@(cd $(LIBFFI32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LIBFFI32_PKG_DESCRIPTION_FILE): $(LIBFFI32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_libffi32_pkg): $(install_target) $(LIBFFI32_PKG_DESCRIPTION_FILE)
	@cp $(LIBFFI32_PKG_DESCRIPTION_FILE) $(LIBFFI32_PKG)/.DESCRIPTION
	@cp $(LIBFFI32_PKG_INSTALL_SCRIPT) $(LIBFFI32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBFFI32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBFFI32_PKG_NAME)"                            >  $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBFFI32_PKG_VERSION)"                          >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBFFI32_PKG_ARCH)"                               >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBFFI32_PKG_DISTRO_NAME)"                  >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBFFI32_PKG_DISTRO_VERSION)"                >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBFFI32_PKG_GROUP)"                             >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBFFI32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBFFI32_PKG_URL)"                                 >> $(LIBFFI32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBFFI32_PKG_LICENSE)"                         >> $(LIBFFI32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBFFI32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
