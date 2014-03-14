
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNOME/core/glib


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/glib2/2.39.4-x86_32
else
REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/libffi/3.0.13
endif

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
build_glib2_pkg    = $(TARGET_BUILD_DIR)/.glib2_pkg_done

hw_cache           = $(CURDIR)/hw.cache


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIB2_PKG_NAME                = glib2
GLIB2_PKG_VERSION             = 2.39.4
ifeq ($(HARDWARE),$(TARGET_HOST))
GLIB2_PKG_ARCH                = $(shell uname -m)
else
GLIB2_PKG_ARCH                = $(TOOLCHAIN)
endif
GLIB2_PKG_DISTRO_NAME         = kxLab
GLIB2_PKG_DISTRO_VERSION      = 1.0
GLIB2_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GLIB2_PKG_SHORT_DESCRIPTION   = glib2 $(version)
GLIB2_PKG_URL                 = http://www.kxLab.com
GLIB2_PKG_LICENSE             = GPLv2
GLIB2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-pkg-description
GLIB2_PKG_DESCRIPTION_FILE_IN = $(GLIB2_PKG_NAME)-pkg-description.in
GLIB2_PKG_INSTALL_SCRIPT      = $(GLIB2_PKG_NAME)-pkg-install.sh

GLIB2_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-package

pkg_basename     = $(GLIB2_PKG_NAME)-$(GLIB2_PKG_VERSION)-$(GLIB2_PKG_ARCH)-$(GLIB2_PKG_DISTRO_NAME)-$(GLIB2_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GLIB2_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_glib2_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(GLIB2_PKG)

OPTIMIZATION_FLAGS = -O3


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared=yes
# uncomment next line to prevent building static *.a library:
# extra_configure_switches += --disable-static

extra_configure_switches += --cache-file=$(hw_cache)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@chmod a-w $(hw_cache)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@chmod 0644 $(hw_cache)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLIB2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	exit 1
	@mkdir -p $(GLIB2_PKG)/lib$(LIBSUFFIX)
	@( cd $(GLIB2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@rm -f $(GLIB2_PKG)/usr/share/info/dir
	@gzip -9 $(GLIB2_PKG)/usr/share/info/*
	@if [ -d $(GLIB2_PKG)/usr/share/man ]; then \
	  ( cd $(GLIB2_PKG)/usr/share/man ; \
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
	@mkdir -p $(GLIB2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/README \
	       $(GLIB2_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLIB2_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GLIB2_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(GLIB2_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@


$(GLIB2_PKG_DESCRIPTION_FILE): $(GLIB2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_glib2_pkg): $(install_target) $(GLIB2_PKG_DESCRIPTION_FILE)
	@cp $(GLIB2_PKG_DESCRIPTION_FILE) $(GLIB2_PKG)/.DESCRIPTION
	@cp $(GLIB2_PKG_INSTALL_SCRIPT) $(GLIB2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIB2_PKG)/.REQUIRES
	@echo "pkgname=$(GLIB2_PKG_NAME)"                            >  $(GLIB2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIB2_PKG_VERSION)"                          >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIB2_PKG_ARCH)"                               >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIB2_PKG_DISTRO_NAME)"                  >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIB2_PKG_DISTRO_VERSION)"                >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "group=$(GLIB2_PKG_GROUP)"                             >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIB2_PKG_SHORT_DESCRIPTION)\"" >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "url=$(GLIB2_PKG_URL)"                                 >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "license=$(GLIB2_PKG_LICENSE)"                         >> $(GLIB2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLIB2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
