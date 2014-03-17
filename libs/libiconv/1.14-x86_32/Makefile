
COMPONENT_TARGETS += $(TARGET_HOST)
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/libiconv

REQUIRES           = app/gettext/0.18.3.2


version            = 1.14
tar_gz_archive    = $(SRC_PACKAGE_PATH)/GNU/libiconv/libiconv-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiconv-$(version)
src_dir_name       = libiconv-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_iconv32_pkg  = $(TARGET_BUILD_DIR)/.iconv32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICONV32_PKG_NAME                = libiconv32
ICONV32_PKG_VERSION             = 1.14
ifeq ($(HARDWARE),$(TARGET_HOST))
ICONV32_PKG_ARCH                = $(shell uname -m)
else
ICONV32_PKG_ARCH                = $(TOOLCHAIN)
endif
ICONV32_PKG_DISTRO_NAME         = kxLab
ICONV32_PKG_DISTRO_VERSION      = 1.0
ICONV32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ICONV32_PKG_SHORT_DESCRIPTION   = libiconv32 $(version)
ICONV32_PKG_URL                 = http://www.kxLab.com
ICONV32_PKG_LICENSE             = GPLv2
ICONV32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICONV32_PKG_NAME)-pkg-description
ICONV32_PKG_DESCRIPTION_FILE_IN = $(ICONV32_PKG_NAME)-pkg-description.in
ICONV32_PKG_INSTALL_SCRIPT      = $(ICONV32_PKG_NAME)-pkg-install.sh

ICONV32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICONV32_PKG_NAME)-package

pkg_basename     = $(ICONV32_PKG_NAME)-$(ICONV32_PKG_VERSION)-$(ICONV32_PKG_ARCH)-$(ICONV32_PKG_DISTRO_NAME)-$(ICONV32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(ICONV32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_iconv32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(ICONV32_PKG)


OPTIMIZATION_FLAGS = -O3

CC                += -m32
CXX               += -m32

# owerwrite LDFLAGS:
#
LDFLAGS            = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS           += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32           = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-nls
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(ICONV32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libcharset.la
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libcharset.so.?.?.?
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libiconv.la
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libiconv.so.?.?.?
	@chmod a+x $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/preloadable_libiconv.so
	@( cd $(ICONV32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv iconv 32 \
	 )
	@rm -rf $(ICONV32_PKG)/usr/include
	@rm -rf $(ICONV32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(ICONV32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libcharset.la libiconv.la \
	 )
	# Install the same to $(TARGET_DEST_DIR)
#	@mkdir -p $(TARGET_DEST_DIR)
#	@cd $(ICONV32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
#	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
#	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcharset.la libiconv.la ; \
#	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcharset.la libiconv.la \
#	 )
	@(cd $(ICONV32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@
	exit 1

$(ICONV32_PKG_DESCRIPTION_FILE): $(ICONV32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_iconv32_pkg): $(install_target) $(ICONV32_PKG_DESCRIPTION_FILE)
	@cp $(ICONV32_PKG_DESCRIPTION_FILE) $(ICONV32_PKG)/.DESCRIPTION
	@cp $(ICONV32_PKG_INSTALL_SCRIPT) $(ICONV32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICONV32_PKG)/.REQUIRES
	@echo "pkgname=$(ICONV32_PKG_NAME)"                            >  $(ICONV32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICONV32_PKG_VERSION)"                          >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "arch=$(ICONV32_PKG_ARCH)"                               >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICONV32_PKG_DISTRO_NAME)"                  >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICONV32_PKG_DISTRO_VERSION)"                >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "group=$(ICONV32_PKG_GROUP)"                             >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICONV32_PKG_SHORT_DESCRIPTION)\"" >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "url=$(ICONV32_PKG_URL)"                                 >> $(ICONV32_PKG)/.PKGINFO ; \
	 echo "license=$(ICONV32_PKG_LICENSE)"                         >> $(ICONV32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ICONV32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
