
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/mpfr


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/mpfr/3.1.2-x86_32
else
REQUIRES           = libs/gmp/5.1.3
endif

version            = 3.1.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/mpfr/mpfr-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mpfr-$(version)
src_dir_name       = mpfr-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_mpfr_pkg     = $(TARGET_BUILD_DIR)/.mpfr_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MPFR_PKG_NAME                = mpfr
MPFR_PKG_VERSION             = 3.1.2
ifeq ($(HARDWARE),$(TARGET_HOST))
MPFR_PKG_ARCH                = $(shell uname -m)
else
MPFR_PKG_ARCH                = $(TOOLCHAIN)
endif
MPFR_PKG_DISTRO_NAME         = kxLab
MPFR_PKG_DISTRO_VERSION      = 1.0
MPFR_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
MPFR_PKG_SHORT_DESCRIPTION   = mpfr $(version)
MPFR_PKG_URL                 = http://www.kxLab.com
MPFR_PKG_LICENSE             = GPLv2
MPFR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPFR_PKG_NAME)-pkg-description
MPFR_PKG_DESCRIPTION_FILE_IN = $(MPFR_PKG_NAME)-pkg-description.in
MPFR_PKG_INSTALL_SCRIPT      = $(MPFR_PKG_NAME)-pkg-install.sh

MPFR_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPFR_PKG_NAME)-package

pkg_basename     = $(MPFR_PKG_NAME)-$(MPFR_PKG_VERSION)-$(MPFR_PKG_ARCH)-$(MPFR_PKG_DISTRO_NAME)-$(MPFR_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(MPFR_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_mpfr_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(MPFR_PKG)


OPTIMIZATION_FLAGS = -O3

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(MPFR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(MPFR_PKG)/usr/share/info/dir
	@gzip -9 $(MPFR_PKG)/usr/share/info/*
	@if [ -d $(MPFR_PKG)/usr/share/man ]; then \
	  ( cd $(MPFR_PKG)/usr/share/man ; \
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
	@mkdir -p $(MPFR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(MPFR_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MPFR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove toolchain path from target libtool *.la files and
	@( cd $(MPFR_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libmpfr.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(MPFR_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpfr.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpfr.la \
	 )
	@(cd $(MPFR_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(MPFR_PKG_DESCRIPTION_FILE): $(MPFR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_mpfr_pkg): $(install_target) $(MPFR_PKG_DESCRIPTION_FILE)
	@cp $(MPFR_PKG_DESCRIPTION_FILE) $(MPFR_PKG)/.DESCRIPTION
	@cp $(MPFR_PKG_INSTALL_SCRIPT) $(MPFR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPFR_PKG)/.REQUIRES
	@echo "pkgname=$(MPFR_PKG_NAME)"                            >  $(MPFR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPFR_PKG_VERSION)"                          >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "arch=$(MPFR_PKG_ARCH)"                               >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPFR_PKG_DISTRO_NAME)"                  >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPFR_PKG_DISTRO_VERSION)"                >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "group=$(MPFR_PKG_GROUP)"                             >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPFR_PKG_SHORT_DESCRIPTION)\"" >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "url=$(MPFR_PKG_URL)"                                 >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "license=$(MPFR_PKG_LICENSE)"                         >> $(MPFR_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MPFR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
