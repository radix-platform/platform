
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/libunistring

REQUIRES           = libs/eglibc/2.18.1


version            = 0.9.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libunistring/libunistring-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libunistring-$(version)
src_dir_name       = libunistring-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_ustr32_pkg   = $(TARGET_BUILD_DIR)/.ustr32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBUNISTR32_PKG_NAME                = libunistring32
LIBUNISTR32_PKG_VERSION             = 0.9.3
LIBUNISTR32_PKG_ARCH                = $(TOOLCHAIN)
LIBUNISTR32_PKG_DISTRO_NAME         = kxLab
LIBUNISTR32_PKG_DISTRO_VERSION      = 1.0
LIBUNISTR32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBUNISTR32_PKG_SHORT_DESCRIPTION   = libunistring32 $(version)
LIBUNISTR32_PKG_URL                 = http://www.kxLab.com
LIBUNISTR32_PKG_LICENSE             = GPLv2
LIBUNISTR32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUNISTR32_PKG_NAME)-pkg-description
LIBUNISTR32_PKG_DESCRIPTION_FILE_IN = $(LIBUNISTR32_PKG_NAME)-pkg-description.in
LIBUNISTR32_PKG_INSTALL_SCRIPT      = $(LIBUNISTR32_PKG_NAME)-pkg-install.sh

LIBUNISTR32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUNISTR32_PKG_NAME)-package

pkg_basename     = $(LIBUNISTR32_PKG_NAME)-$(LIBUNISTR32_PKG_VERSION)-$(LIBUNISTR32_PKG_ARCH)-$(LIBUNISTR32_PKG_DISTRO_NAME)-$(LIBUNISTR32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(LIBUNISTR32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_ustr32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBUNISTR32_PKG)


CC          += -m32

# owerwrite LDFLAGS:
#
LDFLAGS      = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS     += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS   = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-rpath
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
	@mkdir -p $(LIBUNISTR32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBUNISTR32_PKG)/usr/include
	@rm -rf $(LIBUNISTR32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(LIBUNISTR32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libunistring.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBUNISTR32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunistring.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libunistring.la \
	 )
	@( cd $(LIBUNISTR32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBUNISTR32_PKG_DESCRIPTION_FILE): $(LIBUNISTR32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_ustr32_pkg): $(install_target) $(LIBUNISTR32_PKG_DESCRIPTION_FILE)
	@cp $(LIBUNISTR32_PKG_DESCRIPTION_FILE) $(LIBUNISTR32_PKG)/.DESCRIPTION
	@cp $(LIBUNISTR32_PKG_INSTALL_SCRIPT) $(LIBUNISTR32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUNISTR32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUNISTR32_PKG_NAME)"                            >  $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUNISTR32_PKG_VERSION)"                          >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUNISTR32_PKG_ARCH)"                               >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUNISTR32_PKG_DISTRO_NAME)"                  >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUNISTR32_PKG_DISTRO_VERSION)"                >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUNISTR32_PKG_GROUP)"                             >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUNISTR32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUNISTR32_PKG_URL)"                                 >> $(LIBUNISTR32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUNISTR32_PKG_LICENSE)"                         >> $(LIBUNISTR32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBUNISTR32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
