
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/libassuan

REQUIRES           = net/libgpg-error/1.12


version            = 2.1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libassuan/libassuan-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libassuan-$(version)
src_dir_name       = libassuan-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ASSUAN_PKG_NAME                = libassuan
ASSUAN_PKG_VERSION             = 2.1.1
ASSUAN_PKG_ARCH                = $(TOOLCHAIN)
ASSUAN_PKG_DISTRO_NAME         = kxLab
ASSUAN_PKG_DISTRO_VERSION      = 1.0
ASSUAN_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
ASSUAN_PKG_SHORT_DESCRIPTION   = libassuan $(version)
ASSUAN_PKG_URL                 = http://www.kxLab.com
ASSUAN_PKG_LICENSE             = GPLv2
ASSUAN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ASSUAN_PKG_NAME)-pkg-description
ASSUAN_PKG_DESCRIPTION_FILE_IN = $(ASSUAN_PKG_NAME)-pkg-description.in
ASSUAN_PKG_INSTALL_SCRIPT      = $(ASSUAN_PKG_NAME)-pkg-install.sh

ASSUAN_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ASSUAN_PKG_NAME)-package

pkg_basename     = $(ASSUAN_PKG_NAME)-$(ASSUAN_PKG_VERSION)-$(ASSUAN_PKG_ARCH)-$(ASSUAN_PKG_DISTRO_NAME)-$(ASSUAN_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ASSUAN_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

gpg_error_config = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(gpg_error_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ASSUAN_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(ASSUAN_PKG)/lib$(LIBSUFFIX)
	@( cd $(ASSUAN_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod +w lib*.so.?.*.? ; \
	   mv lib*.so.?.*.? ../../lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.?.*.? . ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@rm -f $(ASSUAN_PKG)/usr/share/info/dir
	@gzip -9 $(ASSUAN_PKG)/usr/share/info/*
	@mkdir -p $(ASSUAN_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(ASSUAN_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ASSUAN_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README* THANKS VERSION doc/HACKING \
	         $(ASSUAN_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ASSUAN_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove toolchain path from target libtool *.la files
	@( cd $(ASSUAN_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libassuan.la ; \
	 )
	@( cd $(ASSUAN_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libassuan-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ASSUAN_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libassuan.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libassuan.la  \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	  sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" libassuan-config ; \
	  sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" libassuan-config ; \
	  sed -i "s,-I/usr,-I$(TARGET_DEST_DIR)/usr,g" libassuan-config ; \
	 )
	@( cd $(ASSUAN_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ASSUAN_PKG_DESCRIPTION_FILE): $(ASSUAN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ASSUAN_PKG_DESCRIPTION_FILE) $(ASSUAN_PKG_INSTALL_SCRIPT)
	@cp $(ASSUAN_PKG_DESCRIPTION_FILE) $(ASSUAN_PKG)/.DESCRIPTION
	@cp $(ASSUAN_PKG_INSTALL_SCRIPT) $(ASSUAN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ASSUAN_PKG)/.REQUIRES
	@echo "pkgname=$(ASSUAN_PKG_NAME)"                            >  $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ASSUAN_PKG_VERSION)"                          >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "arch=$(ASSUAN_PKG_ARCH)"                               >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "distroname=$(ASSUAN_PKG_DISTRO_NAME)"                  >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "distrover=$(ASSUAN_PKG_DISTRO_VERSION)"                >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "group=$(ASSUAN_PKG_GROUP)"                             >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ASSUAN_PKG_SHORT_DESCRIPTION)\"" >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "url=$(ASSUAN_PKG_URL)"                                 >> $(ASSUAN_PKG)/.PKGINFO ; \
	 echo "license=$(ASSUAN_PKG_LICENSE)"                         >> $(ASSUAN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ASSUAN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."