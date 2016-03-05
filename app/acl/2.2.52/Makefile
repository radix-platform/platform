
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/acl

REQUIRES           = app/attr/2.4.47

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.52
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/acl/acl-$(version).src.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/acl-$(version)
src_dir_name       = acl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ACL_PKG_NAME                = acl
ACL_PKG_VERSION             = 2.2.52
ACL_PKG_ARCH                = $(TOOLCHAIN)
ACL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ACL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ACL_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
ACL_PKG_SHORT_DESCRIPTION   = POSIX Access Control Lists tool
ACL_PKG_URL                 = $(BUG_URL)
ACL_PKG_LICENSE             = GPLv2
ACL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ACL_PKG_NAME)-pkg-description
ACL_PKG_DESCRIPTION_FILE_IN = $(ACL_PKG_NAME)-pkg-description.in
ACL_PKG_INSTALL_SCRIPT      = $(ACL_PKG_NAME)-pkg-install.sh

ACL_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ACL_PKG_NAME)-package

pkg_basename     = $(ACL_PKG_NAME)-$(ACL_PKG_VERSION)-$(ACL_PKG_ARCH)-$(ACL_PKG_DISTRO_NAME)-$(ACL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(ACL_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --sbindir=/usr/sbin
extra_configure_switches += --bindir=/usr/bin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-shared


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --exec-prefix=/usr          \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ACL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-dev $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-lib $(env_sysroot)
	@mkdir -p $(ACL_PKG)/lib$(LIBSUFFIX)
	@( cd $(ACL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 libacl.so.?.?.? *.la ; \
	   cp -a libacl.so.? $(ACL_PKG)/lib$(LIBSUFFIX) ; \
	   mv libacl.so.?.?.? $(ACL_PKG)/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libacl.so.?.?.? . \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(ACL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/COPYING* \
	       $(ACL_PKG)/usr/doc/$(src_dir_name)
	@mv $(ACL_PKG)/usr/share/doc/acl $(ACL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a doc/INSTALL doc/TODO doc/extensions.txt doc/libacl.txt \
	         $(ACL_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(ACL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libacl.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ACL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libacl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libacl.la \
	 )
	# ======= Strip binaries =======
	@( cd $(ACL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(ACL_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(ACL_PKG)/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ACL_PKG_DESCRIPTION_FILE): $(ACL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ACL_PKG_DESCRIPTION_FILE) $(ACL_PKG_INSTALL_SCRIPT)
	@cp $(ACL_PKG_DESCRIPTION_FILE) $(ACL_PKG)/.DESCRIPTION
	@cp $(ACL_PKG_INSTALL_SCRIPT) $(ACL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ACL_PKG)/.REQUIRES
	@echo "pkgname=$(ACL_PKG_NAME)"                            >  $(ACL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ACL_PKG_VERSION)"                          >> $(ACL_PKG)/.PKGINFO ; \
	 echo "arch=$(ACL_PKG_ARCH)"                               >> $(ACL_PKG)/.PKGINFO ; \
	 echo "distroname=$(ACL_PKG_DISTRO_NAME)"                  >> $(ACL_PKG)/.PKGINFO ; \
	 echo "distrover=$(ACL_PKG_DISTRO_VERSION)"                >> $(ACL_PKG)/.PKGINFO ; \
	 echo "group=$(ACL_PKG_GROUP)"                             >> $(ACL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ACL_PKG_SHORT_DESCRIPTION)\"" >> $(ACL_PKG)/.PKGINFO ; \
	 echo "url=$(ACL_PKG_URL)"                                 >> $(ACL_PKG)/.PKGINFO ; \
	 echo "license=$(ACL_PKG_LICENSE)"                         >> $(ACL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ACL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
