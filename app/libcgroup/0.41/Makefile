
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/libcgroup

REQUIRES           = libs/eglibc/2.19.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.41
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/libcgroup/libcgroup-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcgroup-$(version)
src_dir_name       = libcgroup-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBCGROUP_PKG_NAME                = libcgroup
LIBCGROUP_PKG_VERSION             = 0.41
LIBCGROUP_PKG_ARCH                = $(TOOLCHAIN)
LIBCGROUP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCGROUP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCGROUP_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBCGROUP_PKG_SHORT_DESCRIPTION   = kernel control groups library and utilities
LIBCGROUP_PKG_URL                 = $(BUG_URL)
LIBCGROUP_PKG_LICENSE             = LGPLv2
LIBCGROUP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCGROUP_PKG_NAME)-pkg-description
LIBCGROUP_PKG_DESCRIPTION_FILE_IN = $(LIBCGROUP_PKG_NAME)-pkg-description.in
LIBCGROUP_PKG_INSTALL_SCRIPT      = $(LIBCGROUP_PKG_NAME)-pkg-install.sh

LIBCGROUP_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCGROUP_PKG_NAME)-package

pkg_basename     = $(LIBCGROUP_PKG_NAME)-$(LIBCGROUP_PKG_VERSION)-$(LIBCGROUP_PKG_ARCH)-$(LIBCGROUP_PKG_DISTRO_NAME)-$(LIBCGROUP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk

#
# NOTE:
#
#   The flag 'AM_LIBTOOLFLAGS=--no-warn' used for skipping warning message
#   about 'libcgroup.la' which not installed into '/usr/lib' directory on the build
#   machine. We don't like to see stupid messages during cross build process.
#

env_sysroot = DESTDIR=$(LIBCGROUP_PKG) AM_LIBTOOLFLAGS=--no-warn


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-pam

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
	@mkdir -p $(LIBCGROUP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# If this directory is empty, do not include it in the package:
	@if [ -d $(LIBCGROUP_PKG)/usr/lib$(LIBSUFFIX)/security ]; then \
	   rmdir $(LIBCGROUP_PKG)/usr/lib$(LIBSUFFIX)/security 2> /dev/null ; \
	 fi
	# ======= Install init scripts: =======
	mkdir -p $(LIBCGROUP_PKG)/etc/rc.d
	@( cd $(build_dir) ; \
	   cp -a scripts/init.d/cgconfig $(LIBCGROUP_PKG)/etc/rc.d/rc.cgconfig.new ; \
	   cp -a scripts/init.d/cgred $(LIBCGROUP_PKG)/etc/rc.d/rc.cgred.new ; \
	   chmod 644 $(LIBCGROUP_PKG)/etc/rc.d/* ; \
	 )
	# ======= Install sample config files: =======
	@mkdir -p $(LIBCGROUP_PKG)/usr/share/doc/$(src_dir_name)/samples
	( cd $(SRC_DIR)/samples ; \
	  for conffile in cgconfig.conf cgred.conf cgrules.conf cgsnapshot_blacklist.conf ; do \
	    cp -a $$conffile $(LIBCGROUP_PKG)/etc/$$conffile.new ; \
	    cp -a $$conffile $(LIBCGROUP_PKG)/usr/share/doc/$(src_dir_name)/samples ; \
	  done ; \
	)
	# ======= pack manpages =======
	@if [ -d $(LIBCGROUP_PKG)/usr/share/man ]; then \
	  ( cd $(LIBCGROUP_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBCGROUP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBCGROUP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBCGROUP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README* \
	         $(LIBCGROUP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBCGROUP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcgroup.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBCGROUP_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcgroup.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcgroup.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcgroup.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCGROUP_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBCGROUP_PKG_DESCRIPTION_FILE): $(LIBCGROUP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCGROUP_PKG_DESCRIPTION_FILE) $(LIBCGROUP_PKG_INSTALL_SCRIPT)
	@cp $(LIBCGROUP_PKG_DESCRIPTION_FILE) $(LIBCGROUP_PKG)/.DESCRIPTION
	@cp $(LIBCGROUP_PKG_INSTALL_SCRIPT) $(LIBCGROUP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCGROUP_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCGROUP_PKG_NAME)"                            >  $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCGROUP_PKG_VERSION)"                          >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCGROUP_PKG_ARCH)"                               >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCGROUP_PKG_DISTRO_NAME)"                  >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCGROUP_PKG_DISTRO_VERSION)"                >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCGROUP_PKG_GROUP)"                             >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCGROUP_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCGROUP_PKG_URL)"                                 >> $(LIBCGROUP_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCGROUP_PKG_LICENSE)"                         >> $(LIBCGROUP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBCGROUP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
