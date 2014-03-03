
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/libffi


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/libffi/3.0.13-x86_32
else
REQUIRES           = libs/eglibc/2.18.1
endif

version            = 3.0.13
tar_gz_archive    = $(SRC_PACKAGE_PATH)/packages/l/libffi/libffi-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libffi-$(version)
src_dir_name       = libffi-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_libffi_pkg   = $(TARGET_BUILD_DIR)/.libffi_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBFFI_PKG_NAME                = libffi
LIBFFI_PKG_VERSION             = 3.0.13
ifeq ($(HARDWARE),$(TARGET_HOST))
LIBFFI_PKG_ARCH                = $(shell uname -m)
else
LIBFFI_PKG_ARCH                = $(TOOLCHAIN)
endif
LIBFFI_PKG_DISTRO_NAME         = kxLab
LIBFFI_PKG_DISTRO_VERSION      = 1.0
LIBFFI_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBFFI_PKG_SHORT_DESCRIPTION   = libffi $(version)
LIBFFI_PKG_URL                 = http://www.kxLab.com
LIBFFI_PKG_LICENSE             = GPLv2
LIBFFI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBFFI_PKG_NAME)-pkg-description
LIBFFI_PKG_DESCRIPTION_FILE_IN = $(LIBFFI_PKG_NAME)-pkg-description.in
LIBFFI_PKG_INSTALL_SCRIPT      = $(LIBFFI_PKG_NAME)-pkg-install.sh

LIBFFI_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBFFI_PKG_NAME)-package

pkg_basename     = $(LIBFFI_PKG_NAME)-$(LIBFFI_PKG_VERSION)-$(LIBFFI_PKG_ARCH)-$(LIBFFI_PKG_DISTRO_NAME)-$(LIBFFI_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(LIBFFI_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_libffi_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(LIBFFI_PKG)


ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif

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
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBFFI_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# libffi make suggestion about toolexeclibdir according to gcc -print-multi-os-directory
	# we shoul prevent so stupid behaviour related to x86_WIN32 target in linux
	@( cd $(LIBFFI_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib$(LIBSUFFIX)/../lib$(LIBSUFFIX)',libdir='/usr/lib$(LIBSUFFIX)',g" libffi.la \
	 )
	@mkdir -p $(LIBFFI_PKG)/lib$(LIBSUFFIX)
	@( cd $(LIBFFI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@rm -f $(LIBFFI_PKG)/usr/share/info/dir
	@gzip -9 $(LIBFFI_PKG)/usr/share/info/*
	@if [ -d $(LIBFFI_PKG)/usr/share/man ]; then \
	  ( cd $(LIBFFI_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBFFI_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/README \
	       $(LIBFFI_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBFFI_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBFFI_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,libdir='/usr/lib$(LIBSUFFIX)',libdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)',g" libffi.la \
	 )
	@(cd $(LIBFFI_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@


$(LIBFFI_PKG_DESCRIPTION_FILE): $(LIBFFI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@


$(build_libffi_pkg): $(install_target) $(LIBFFI_PKG_DESCRIPTION_FILE)
	@cp $(LIBFFI_PKG_DESCRIPTION_FILE) $(LIBFFI_PKG)/.DESCRIPTION
	@cp $(LIBFFI_PKG_INSTALL_SCRIPT) $(LIBFFI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBFFI_PKG)/.REQUIRES
	@echo "pkgname=$(LIBFFI_PKG_NAME)"                            >  $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBFFI_PKG_VERSION)"                          >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBFFI_PKG_ARCH)"                               >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBFFI_PKG_DISTRO_NAME)"                  >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBFFI_PKG_DISTRO_VERSION)"                >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "group=$(LIBFFI_PKG_GROUP)"                             >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBFFI_PKG_SHORT_DESCRIPTION)\"" >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "url=$(LIBFFI_PKG_URL)"                                 >> $(LIBFFI_PKG)/.PKGINFO ; \
	 echo "license=$(LIBFFI_PKG_LICENSE)"                         >> $(LIBFFI_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBFFI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
