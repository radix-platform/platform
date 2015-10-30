
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/libcgroup

REQUIRES           = app/libcgroup/0.41

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
CGROUP_32_PKG_NAME                = libcgroup-x32
CGROUP_32_PKG_VERSION             = 0.41
CGROUP_32_PKG_ARCH                = $(TOOLCHAIN)
CGROUP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CGROUP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CGROUP_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
CGROUP_32_PKG_SHORT_DESCRIPTION   = kernel control groups library and utilities
CGROUP_32_PKG_URL                 = $(BUG_URL)
CGROUP_32_PKG_LICENSE             = LGPLv2
CGROUP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CGROUP_32_PKG_NAME)-pkg-description
CGROUP_32_PKG_DESCRIPTION_FILE_IN = $(CGROUP_32_PKG_NAME)-pkg-description.in
CGROUP_32_PKG_INSTALL_SCRIPT      = $(CGROUP_32_PKG_NAME)-pkg-install.sh

CGROUP_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CGROUP_32_PKG_NAME)-package

pkg_basename     = $(CGROUP_32_PKG_NAME)-$(CGROUP_32_PKG_VERSION)-$(CGROUP_32_PKG_ARCH)-$(CGROUP_32_PKG_DISTRO_NAME)-$(CGROUP_32_PKG_DISTRO_VERSION)

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

env_sysroot  = DESTDIR=$(CGROUP_32_PKG) AM_LIBTOOLFLAGS=--no-warn


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CGROUP_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(CGROUP_32_PKG)/etc
	@rm -rf $(CGROUP_32_PKG)/usr/include
	@rm -rf $(CGROUP_32_PKG)/usr/share
	@mkdir -p $(CGROUP_32_PKG)/usr/bin/32
	@( cd $(CGROUP_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(CGROUP_32_PKG)/usr/sbin/32
	@( cd $(CGROUP_32_PKG)/usr/sbin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CGROUP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcgroup.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CGROUP_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcgroup.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcgroup.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcgroup.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(CGROUP_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CGROUP_32_PKG_DESCRIPTION_FILE): $(CGROUP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CGROUP_32_PKG_DESCRIPTION_FILE) $(CGROUP_32_PKG_INSTALL_SCRIPT)
	@cp $(CGROUP_32_PKG_DESCRIPTION_FILE) $(CGROUP_32_PKG)/.DESCRIPTION
	@cp $(CGROUP_32_PKG_INSTALL_SCRIPT) $(CGROUP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CGROUP_32_PKG)/.REQUIRES
	@echo "pkgname=$(CGROUP_32_PKG_NAME)"                            >  $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CGROUP_32_PKG_VERSION)"                          >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CGROUP_32_PKG_ARCH)"                               >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CGROUP_32_PKG_DISTRO_NAME)"                  >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CGROUP_32_PKG_DISTRO_VERSION)"                >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "group=$(CGROUP_32_PKG_GROUP)"                             >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CGROUP_32_PKG_SHORT_DESCRIPTION)\"" >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "url=$(CGROUP_32_PKG_URL)"                                 >> $(CGROUP_32_PKG)/.PKGINFO ; \
	 echo "license=$(CGROUP_32_PKG_LICENSE)"                         >> $(CGROUP_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CGROUP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
