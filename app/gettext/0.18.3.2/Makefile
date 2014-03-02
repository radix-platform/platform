
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/gettext


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
#REQUIRES           = app/xz/5.0.5-x86_32
else
#REQUIRES           = libs/eglibc/2.18.1
endif

version            = 0.18.3.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/gettext/gettext-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gettext-$(version)
src_dir_name       = gettext-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gettext_pkg  = $(TARGET_BUILD_DIR)/.gettext_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GETTEXT_PKG_NAME                = gettext
GETTEXT_PKG_VERSION             = 0.18.3.2
ifeq ($(HARDWARE),$(TARGET_HOST))
GETTEXT_PKG_ARCH                = $(shell uname -m)
else
GETTEXT_PKG_ARCH                = $(TOOLCHAIN)
endif
GETTEXT_PKG_DISTRO_NAME         = kxLab
GETTEXT_PKG_DISTRO_VERSION      = 1.0
GETTEXT_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GETTEXT_PKG_SHORT_DESCRIPTION   = GNU gettext $(version)
GETTEXT_PKG_URL                 = http://www.kxLab.com
GETTEXT_PKG_LICENSE             = GPLv2
GETTEXT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GETTEXT_PKG_NAME)-pkg-description
GETTEXT_PKG_DESCRIPTION_FILE_IN = $(GETTEXT_PKG_NAME)-pkg-description.in
GETTEXT_PKG_INSTALL_SCRIPT      = $(GETTEXT_PKG_NAME)-pkg-install.sh

GETTEXT_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GETTEXT_PKG_NAME)-package

pkg_basename     = $(GETTEXT_PKG_NAME)-$(GETTEXT_PKG_VERSION)-$(GETTEXT_PKG_ARCH)-$(GETTEXT_PKG_DISTRO_NAME)-$(GETTEXT_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GETTEXT_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gettext_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(GETTEXT_PKG)


ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
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
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GETTEXT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(GETTEXT_PKG)/usr/share/info/dir
	@gzip -9 $(GETTEXT_PKG)/usr/share/info/*
	@mkdir -p $(GETTEXT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/DEPENDENCIES \
	       $(SRC_DIR)/HACKING $(SRC_DIR)/INSTALL $(SRC_DIR)/NEWS $(SRC_DIR)/PACKAGING \
	       $(SRC_DIR)/README* $(SRC_DIR)/THANKS $(SRC_DIR)/gettext-tools/ABOUT-NLS \
	       $(GETTEXT_PKG)/usr/doc/$(src_dir_name)
	@if [ -d $(GETTEXT_PKG)/usr/share/man ]; then \
	  ( cd $(GETTEXT_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@cp -a $(SRC_DIR)/ChangeLog $(SRC_DIR)/INSTALL* \
	       $(GETTEXT_PKG)/usr/doc/$(src_dir_name)
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GETTEXT_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(GETTEXT_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@
	exit 1

$(GETTEXT_PKG_DESCRIPTION_FILE): $(GETTEXT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gettext_pkg): $(install_target) $(GETTEXT_PKG_DESCRIPTION_FILE)
	@cp $(GETTEXT_PKG_DESCRIPTION_FILE) $(GETTEXT_PKG)/.DESCRIPTION
	@cp $(GETTEXT_PKG_INSTALL_SCRIPT) $(GETTEXT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GETTEXT_PKG)/.REQUIRES
	@echo "pkgname=$(GETTEXT_PKG_NAME)"                            >  $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GETTEXT_PKG_VERSION)"                          >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "arch=$(GETTEXT_PKG_ARCH)"                               >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "distroname=$(GETTEXT_PKG_DISTRO_NAME)"                  >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "distrover=$(GETTEXT_PKG_DISTRO_VERSION)"                >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "group=$(GETTEXT_PKG_GROUP)"                             >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GETTEXT_PKG_SHORT_DESCRIPTION)\"" >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "url=$(GETTEXT_PKG_URL)"                                 >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "license=$(GETTEXT_PKG_LICENSE)"                         >> $(GETTEXT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GETTEXT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
