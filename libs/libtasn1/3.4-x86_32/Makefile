
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/libtasn1

REQUIRES           = libs/eglibc/2.18.1


version            = 3.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libtasn1/libtasn1-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libtasn1-$(version)
src_dir_name       = libtasn1-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_tasn32_pkg   = $(TARGET_BUILD_DIR)/.tasn32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TASN32_PKG_NAME                = libtasn1x32
TASN32_PKG_VERSION             = 3.4
TASN32_PKG_ARCH                = $(TOOLCHAIN)
TASN32_PKG_DISTRO_NAME         = kxLab
TASN32_PKG_DISTRO_VERSION      = 1.0
TASN32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
TASN32_PKG_SHORT_DESCRIPTION   = libtasn1x32 $(version)
TASN32_PKG_URL                 = http://www.kxLab.com
TASN32_PKG_LICENSE             = GPLv2
TASN32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TASN32_PKG_NAME)-pkg-description
TASN32_PKG_DESCRIPTION_FILE_IN = $(TASN32_PKG_NAME)-pkg-description.in
TASN32_PKG_INSTALL_SCRIPT      = $(TASN32_PKG_NAME)-pkg-install.sh

TASN32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TASN32_PKG_NAME)-package

pkg_basename     = $(TASN32_PKG_NAME)-$(TASN32_PKG_VERSION)-$(TASN32_PKG_ARCH)-$(TASN32_PKG_DISTRO_NAME)-$(TASN32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(TASN32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_tasn32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(TASN32_PKG)


CC          += -m32

# owerwrite LDFLAGS:
#
LDFLAGS     = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS    += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS   = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
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
	@mkdir -p $(TASN32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(TASN32_PKG)/usr/bin/32
	@( cd $(TASN32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(TASN32_PKG)/usr/include
	@rm -rf $(TASN32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(TASN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libtasn1.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(TASN32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtasn1.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libtasn1.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtasn1.pc \
	 )
	@(cd $(TASN32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(TASN32_PKG_DESCRIPTION_FILE): $(TASN32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_tasn32_pkg): $(install_target) $(TASN32_PKG_DESCRIPTION_FILE)
	@cp $(TASN32_PKG_DESCRIPTION_FILE) $(TASN32_PKG)/.DESCRIPTION
	@cp $(TASN32_PKG_INSTALL_SCRIPT) $(TASN32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TASN32_PKG)/.REQUIRES
	@echo "pkgname=$(TASN32_PKG_NAME)"                            >  $(TASN32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TASN32_PKG_VERSION)"                          >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "arch=$(TASN32_PKG_ARCH)"                               >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "distroname=$(TASN32_PKG_DISTRO_NAME)"                  >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "distrover=$(TASN32_PKG_DISTRO_VERSION)"                >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "group=$(TASN32_PKG_GROUP)"                             >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TASN32_PKG_SHORT_DESCRIPTION)\"" >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "url=$(TASN32_PKG_URL)"                                 >> $(TASN32_PKG)/.PKGINFO ; \
	 echo "license=$(TASN32_PKG_LICENSE)"                         >> $(TASN32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TASN32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
