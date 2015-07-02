
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


SOURCE_REQUIRES    = sources/packages/d/check

REQUIRES           = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/check/check-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/check-$(version)
src_dir_name       = check-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CHECK_PKG_NAME                = check
CHECK_PKG_VERSION             = 0.9.13
CHECK_PKG_ARCH                = $(TOOLCHAIN)
CHECK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CHECK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CHECK_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CHECK_PKG_SHORT_DESCRIPTION   = The unit testing framework for C
CHECK_PKG_URL                 = $(BUG_URL)
CHECK_PKG_LICENSE             = LGPLv2
CHECK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CHECK_PKG_NAME)-pkg-description
CHECK_PKG_DESCRIPTION_FILE_IN = $(CHECK_PKG_NAME)-pkg-description.in
CHECK_PKG_INSTALL_SCRIPT      = $(CHECK_PKG_NAME)-pkg-install.sh

CHECK_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CHECK_PKG_NAME)-package

pkg_basename     = $(CHECK_PKG_NAME)-$(CHECK_PKG_VERSION)-$(CHECK_PKG_ARCH)-$(CHECK_PKG_DISTRO_NAME)-$(CHECK_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CHECK_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(CHECK_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(CHECK_PKG)/usr/share/info/dir
	@gzip -9 $(CHECK_PKG)/usr/share/info/*
	@if [ -d $(CHECK_PKG)/usr/share/man ]; then \
	  ( cd $(CHECK_PKG)/usr/share/man ; \
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
	@mkdir -p $(CHECK_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(CHECK_PKG)/usr/doc/$(src_dir_name)
	@( cd $(CHECK_PKG)/usr/share/doc ; mv check $(src_dir_name) )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS INSTALL THANKS TODO \
	         $(CHECK_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@rm -f $(CHECK_PKG)/usr/share/doc/$(src_dir_name)/ChangeLog*
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CHECK_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CHECK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcheck.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CHECK_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcheck.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcheck.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" check.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(CHECK_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CHECK_PKG_DESCRIPTION_FILE): $(CHECK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CHECK_PKG_DESCRIPTION_FILE) $(CHECK_PKG_INSTALL_SCRIPT)
	@cp $(CHECK_PKG_DESCRIPTION_FILE) $(CHECK_PKG)/.DESCRIPTION
	@cp $(CHECK_PKG_INSTALL_SCRIPT) $(CHECK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CHECK_PKG)/.REQUIRES
	@echo "pkgname=$(CHECK_PKG_NAME)"                            >  $(CHECK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CHECK_PKG_VERSION)"                          >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "arch=$(CHECK_PKG_ARCH)"                               >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "distroname=$(CHECK_PKG_DISTRO_NAME)"                  >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "distrover=$(CHECK_PKG_DISTRO_VERSION)"                >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "group=$(CHECK_PKG_GROUP)"                             >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CHECK_PKG_SHORT_DESCRIPTION)\"" >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "url=$(CHECK_PKG_URL)"                                 >> $(CHECK_PKG)/.PKGINFO ; \
	 echo "license=$(CHECK_PKG_LICENSE)"                         >> $(CHECK_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CHECK_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
