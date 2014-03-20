
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/xz


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
REQUIRES           = app/xz/5.0.5-x86_32
else
REQUIRES           = libs/eglibc/2.18.1
endif

version            = 5.0.5
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/xz/xz-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xz-$(version)
src_dir_name       = xz-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_xz_pkg       = $(TARGET_BUILD_DIR)/.xz_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XZ_PKG_NAME                = xz
XZ_PKG_VERSION             = 5.0.5
XZ_PKG_ARCH                = $(TOOLCHAIN)
XZ_PKG_DISTRO_NAME         = kxLab
XZ_PKG_DISTRO_VERSION      = 1.0
XZ_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
XZ_PKG_SHORT_DESCRIPTION   = xz $(version)
XZ_PKG_URL                 = http://www.kxLab.com
XZ_PKG_LICENSE             = GPLv2
XZ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XZ_PKG_NAME)-pkg-description
XZ_PKG_DESCRIPTION_FILE_IN = $(XZ_PKG_NAME)-pkg-description.in
XZ_PKG_INSTALL_SCRIPT      = $(XZ_PKG_NAME)-pkg-install.sh

XZ_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XZ_PKG_NAME)-package

pkg_basename     = $(XZ_PKG_NAME)-$(XZ_PKG_VERSION)-$(XZ_PKG_ARCH)-$(XZ_PKG_DISTRO_NAME)-$(XZ_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(XZ_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_xz_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(XZ_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-shared
# uncomment next line to prevent building static *.a library:
# extra_configure_switches += --disable-static

#
# NOTE:
#   For 'arm' CPUs we can add following macro becaise 'arm' ports of glibs doesn't have 'elision'
#   [see $(TARGET_DEST_DIR)/usr/include/bits/pthreadtypes.h]:
#
#   CFLAGS += -D__PTHREAD_MUTEX_HAVE_ELISION=0
#
#   $(BUILD_ENVIRONMENT) ../configure
#

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
	@mkdir -p $(XZ_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@mkdir -p $(XZ_PKG)/bin
	@mv $(XZ_PKG)/usr/bin/xz $(XZ_PKG)/bin
	@( cd $(XZ_PKG)/usr/bin ; \
	  ln -sf ../../bin/xz . ; \
	 )
	@if [ -d $(XZ_PKG)/usr/share/man ]; then \
	  ( cd $(XZ_PKG)/usr/share/man ; \
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
	@mkdir -p $(XZ_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(XZ_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/INSTALL* \
	       $(XZ_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XZ_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove toolchain path from target libtool *.la files and
	@( cd $(XZ_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" liblzma.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(XZ_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblzma.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblzma.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblzma.pc \
	 )
	@(cd $(XZ_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(XZ_PKG_DESCRIPTION_FILE): $(XZ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_xz_pkg): $(install_target) $(XZ_PKG_DESCRIPTION_FILE)
	@cp $(XZ_PKG_DESCRIPTION_FILE) $(XZ_PKG)/.DESCRIPTION
	@cp $(XZ_PKG_INSTALL_SCRIPT) $(XZ_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XZ_PKG)/.REQUIRES
	@echo "pkgname=$(XZ_PKG_NAME)"                            >  $(XZ_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XZ_PKG_VERSION)"                          >> $(XZ_PKG)/.PKGINFO ; \
	 echo "arch=$(XZ_PKG_ARCH)"                               >> $(XZ_PKG)/.PKGINFO ; \
	 echo "distroname=$(XZ_PKG_DISTRO_NAME)"                  >> $(XZ_PKG)/.PKGINFO ; \
	 echo "distrover=$(XZ_PKG_DISTRO_VERSION)"                >> $(XZ_PKG)/.PKGINFO ; \
	 echo "group=$(XZ_PKG_GROUP)"                             >> $(XZ_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XZ_PKG_SHORT_DESCRIPTION)\"" >> $(XZ_PKG)/.PKGINFO ; \
	 echo "url=$(XZ_PKG_URL)"                                 >> $(XZ_PKG)/.PKGINFO ; \
	 echo "license=$(XZ_PKG_LICENSE)"                         >> $(XZ_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XZ_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
