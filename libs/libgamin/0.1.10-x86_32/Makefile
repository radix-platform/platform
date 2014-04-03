
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/gamin

REQUIRES           = libs/eglibc/2.18.1


version            = 0.1.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/gamin/gamin-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gamin-$(version)
src_dir_name       = gamin-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gamin32_pkg  = $(TARGET_BUILD_DIR)/.gamin32_pkg_done

hw_cache           = $(CURDIR)/cross/hw.cache


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GAMIN32_PKG_NAME                = libgamin32
GAMIN32_PKG_VERSION             = 0.1.10
GAMIN32_PKG_ARCH                = $(TOOLCHAIN)
GAMIN32_PKG_DISTRO_NAME         = kxLab
GAMIN32_PKG_DISTRO_VERSION      = 1.0
GAMIN32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GAMIN32_PKG_SHORT_DESCRIPTION   = libgamin32 $(version)
GAMIN32_PKG_URL                 = http://www.kxLab.com
GAMIN32_PKG_LICENSE             = GPLv2
GAMIN32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GAMIN32_PKG_NAME)-pkg-description
GAMIN32_PKG_DESCRIPTION_FILE_IN = $(GAMIN32_PKG_NAME)-pkg-description.in
GAMIN32_PKG_INSTALL_SCRIPT      = $(GAMIN32_PKG_NAME)-pkg-install.sh

GAMIN32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GAMIN32_PKG_NAME)-package

pkg_basename     = $(GAMIN32_PKG_NAME)-$(GAMIN32_PKG_VERSION)-$(GAMIN32_PKG_ARCH)-$(GAMIN32_PKG_DISTRO_NAME)-$(GAMIN32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GAMIN32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gamin32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GAMIN32_PKG)


# owerwrite LDFLAGS:
#
LDFLAGS     = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS    += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS  = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32    = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --disable-server

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-inotify
extra_configure_switches += --disable-dnotify

extra_configure_switches += --cache-file=$(hw_cache)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@chmod a-w $(hw_cache)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@chmod +w $(hw_cache)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GAMIN32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(GAMIN32_PKG)/usr/include
	# remove toolchain path from target libtool *.la files and
	@( cd $(GAMIN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libfam.la ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libgamin-1.la  \
	 )
	@( cd $(GAMIN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" _gamin.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GAMIN32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfam.la ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgamin-1.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfam.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgamin-1.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python2.7/site-packages ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _gamin.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _gamin.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gamin.pc ; \
	 )
	@(cd $(GAMIN32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GAMIN32_PKG_DESCRIPTION_FILE): $(GAMIN32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gamin32_pkg): $(install_target) $(GAMIN32_PKG_DESCRIPTION_FILE)
	@cp $(GAMIN32_PKG_DESCRIPTION_FILE) $(GAMIN32_PKG)/.DESCRIPTION
	@cp $(GAMIN32_PKG_INSTALL_SCRIPT) $(GAMIN32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GAMIN32_PKG)/.REQUIRES
	@echo "pkgname=$(GAMIN32_PKG_NAME)"                            >  $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GAMIN32_PKG_VERSION)"                          >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "arch=$(GAMIN32_PKG_ARCH)"                               >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GAMIN32_PKG_DISTRO_NAME)"                  >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GAMIN32_PKG_DISTRO_VERSION)"                >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "group=$(GAMIN32_PKG_GROUP)"                             >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GAMIN32_PKG_SHORT_DESCRIPTION)\"" >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "url=$(GAMIN32_PKG_URL)"                                 >> $(GAMIN32_PKG)/.PKGINFO ; \
	 echo "license=$(GAMIN32_PKG_LICENSE)"                         >> $(GAMIN32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GAMIN32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
