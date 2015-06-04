
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libaio

REQUIRES           = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version            = 0.3.110
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libaio/libaio-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libaio-$(version)
src_dir_name       = libaio-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBAIO_PKG_NAME                = libaio
LIBAIO_PKG_VERSION             = 0.3.110
LIBAIO_PKG_ARCH                = $(TOOLCHAIN)
LIBAIO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBAIO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBAIO_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBAIO_PKG_SHORT_DESCRIPTION   = asynchronous I/O library
LIBAIO_PKG_URL                 = $(BUG_URL)
LIBAIO_PKG_LICENSE             = LGPLv2
LIBAIO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBAIO_PKG_NAME)-pkg-description
LIBAIO_PKG_DESCRIPTION_FILE_IN = $(LIBAIO_PKG_NAME)-pkg-description.in
LIBAIO_PKG_INSTALL_SCRIPT      = $(LIBAIO_PKG_NAME)-pkg-install.sh

LIBAIO_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBAIO_PKG_NAME)-package

pkg_basename     = $(LIBAIO_PKG_NAME)-$(LIBAIO_PKG_VERSION)-$(LIBAIO_PKG_ARCH)-$(LIBAIO_PKG_DISTRO_NAME)-$(LIBAIO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = prefix=$(LIBAIO_PKG)/usr libdir=$(LIBAIO_PKG)/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBAIO_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@mkdir -p $(LIBAIO_PKG)/lib$(LIBSUFFIX)
	@( cd $(LIBAIO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(LIBAIO_PKG)/usr/share/man/man3
	@( cd $(SRC_DIR)/man ; \
	   cp -a *.3 \
	         $(LIBAIO_PKG)/usr/share/man/man3 \
	 )
	@if [ -d $(LIBAIO_PKG)/usr/share/man ]; then \
	  ( cd $(LIBAIO_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBAIO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBAIO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBAIO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL TODO \
	         $(LIBAIO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBAIO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBAIO_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(LIBAIO_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBAIO_PKG_DESCRIPTION_FILE): $(LIBAIO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBAIO_PKG_DESCRIPTION_FILE) $(LIBAIO_PKG_INSTALL_SCRIPT)
	@cp $(LIBAIO_PKG_DESCRIPTION_FILE) $(LIBAIO_PKG)/.DESCRIPTION
	@cp $(LIBAIO_PKG_INSTALL_SCRIPT) $(LIBAIO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBAIO_PKG)/.REQUIRES
	@echo "pkgname=$(LIBAIO_PKG_NAME)"                            >  $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBAIO_PKG_VERSION)"                          >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBAIO_PKG_ARCH)"                               >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBAIO_PKG_DISTRO_NAME)"                  >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBAIO_PKG_DISTRO_VERSION)"                >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "group=$(LIBAIO_PKG_GROUP)"                             >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBAIO_PKG_SHORT_DESCRIPTION)\"" >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "url=$(LIBAIO_PKG_URL)"                                 >> $(LIBAIO_PKG)/.PKGINFO ; \
	 echo "license=$(LIBAIO_PKG_LICENSE)"                         >> $(LIBAIO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBAIO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
