
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


SOURCE_REQUIRES    = sources/packages/l/libspectre

REQUIRES           = app/ghostscript/9.15
REQUIRES          += libs/cairo/1.14.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.2.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libspectre/libspectre-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libspectre-$(version)
src_dir_name       = libspectre-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBSPECTRE_PKG_NAME                = libspectre
LIBSPECTRE_PKG_VERSION             = 0.2.7
LIBSPECTRE_PKG_ARCH                = $(TOOLCHAIN)
LIBSPECTRE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSPECTRE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSPECTRE_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBSPECTRE_PKG_SHORT_DESCRIPTION   = ghostscript wrapper library
LIBSPECTRE_PKG_URL                 = $(BUG_URL)
LIBSPECTRE_PKG_LICENSE             = GPLv2
LIBSPECTRE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSPECTRE_PKG_NAME)-pkg-description
LIBSPECTRE_PKG_DESCRIPTION_FILE_IN = $(LIBSPECTRE_PKG_NAME)-pkg-description.in
LIBSPECTRE_PKG_INSTALL_SCRIPT      = $(LIBSPECTRE_PKG_NAME)-pkg-install.sh

LIBSPECTRE_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSPECTRE_PKG_NAME)-package

pkg_basename     = $(LIBSPECTRE_PKG_NAME)-$(LIBSPECTRE_PKG_VERSION)-$(LIBSPECTRE_PKG_ARCH)-$(LIBSPECTRE_PKG_DISTRO_NAME)-$(LIBSPECTRE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBSPECTRE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

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
	@mkdir -p $(LIBSPECTRE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(LIBSPECTRE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBSPECTRE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBSPECTRE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README TODO \
	         $(LIBSPECTRE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBSPECTRE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSPECTRE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libspectre.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBSPECTRE_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libspectre.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libspectre.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libspectre.pc \
	 )
	# ======= Strip Binaries =======
	@( cd $(LIBSPECTRE_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBSPECTRE_PKG_DESCRIPTION_FILE): $(LIBSPECTRE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSPECTRE_PKG_DESCRIPTION_FILE) $(LIBSPECTRE_PKG_INSTALL_SCRIPT)
	@cp $(LIBSPECTRE_PKG_DESCRIPTION_FILE) $(LIBSPECTRE_PKG)/.DESCRIPTION
	@cp $(LIBSPECTRE_PKG_INSTALL_SCRIPT) $(LIBSPECTRE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSPECTRE_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSPECTRE_PKG_NAME)"                            >  $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSPECTRE_PKG_VERSION)"                          >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSPECTRE_PKG_ARCH)"                               >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSPECTRE_PKG_DISTRO_NAME)"                  >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSPECTRE_PKG_DISTRO_VERSION)"                >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSPECTRE_PKG_GROUP)"                             >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSPECTRE_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSPECTRE_PKG_URL)"                                 >> $(LIBSPECTRE_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSPECTRE_PKG_LICENSE)"                         >> $(LIBSPECTRE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSPECTRE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
