
COMPONENT_TARGETS  = $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/Mali/sunxi-mali

REQUIRES           = hal/dri2/1.0.0
REQUIRES          += hal/ump/DX/3.0.4.0
REQUIRES          += X11/libs/libdrm/2.4.58
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXfixes/5.0.1

# ======= __END_OF_REQUIRES__ =======


version            = 3.0.4.0
timestamp          = 20140326
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/hal/Mali/sunxi-mali/sunxi-mali-$(timestamp).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sunxi-mali-$(timestamp)
src_dir_name       = sunxi-mali-$(timestamp)
doc_dir_name       = sunxi-mali-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/COPYING
pkgconfigs_dir     = $(CURDIR)/pkgconfigs
examples           = $(CURDIR)/examples

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xorg

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_PKG_NAME                = sunxi-mali
XORG_PKG_VERSION             = 3.0.4.0
XORG_PKG_ARCH                = $(TOOLCHAIN)
XORG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XORG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XORG_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XORG_PKG_SHORT_DESCRIPTION   = Mali userspace driver for X11
XORG_PKG_URL                 = $(BUG_URL)
XORG_PKG_LICENSE             = custom
XORG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XORG_PKG_NAME)-pkg-description
XORG_PKG_DESCRIPTION_FILE_IN = $(XORG_PKG_NAME)-pkg-description.in
XORG_PKG_INSTALL_SCRIPT      = $(XORG_PKG_NAME)-pkg-install.sh

XORG_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XORG_PKG_NAME)-package

pkg_basename     = $(XORG_PKG_NAME)-$(XORG_PKG_VERSION)-$(XORG_PKG_ARCH)-$(XORG_PKG_DISTRO_NAME)-$(XORG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XORG_PKG)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i "s,lib/,lib$(LIBSUFFIX)/," Makefile.setup ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(MAKE) config VERSION=r3p0 ABI=armhf EGL_TYPE=x11 ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XORG_PKG)/usr/include
	@mkdir -p $(XORG_PKG)/usr/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && $(MAKE) install $(env_sysroot)
	@chmod a+x $(XORG_PKG)/usr/lib$(LIBSUFFIX)/libMali.so
	# ======= Install pkg-config *.pc files to the target destination for development =======
	@mkdir -p $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cp -a $(pkgconfigs_dir)/egl.pc       $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cp -a $(pkgconfigs_dir)/glesv1_cm.pc $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cp -a $(pkgconfigs_dir)/glesv2.pc    $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	# ======= Install Documentation =======
	@mkdir -p $(XORG_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(license) \
	       $(XORG_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(XORG_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a $(license) $(examples) README config.mk \
	         $(XORG_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(XORG_PKG)/usr/share/doc ; \
	   ln -sf $(doc_dir_name) $(XORG_PKG_NAME) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(XORG_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" egl.pc          \
	                                            glesv1_cm.pc    \
	                                            glesv2.pc     ; \
	 )
	@touch $@

$(XORG_PKG_DESCRIPTION_FILE): $(XORG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XORG_PKG_DESCRIPTION_FILE) $(XORG_PKG_INSTALL_SCRIPT)
	@cp $(XORG_PKG_DESCRIPTION_FILE) $(XORG_PKG)/.DESCRIPTION
	@cp $(XORG_PKG_INSTALL_SCRIPT) $(XORG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XORG_PKG)/.REQUIRES
	@echo "pkgname=$(XORG_PKG_NAME)"                            >  $(XORG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XORG_PKG_VERSION)"                          >> $(XORG_PKG)/.PKGINFO ; \
	 echo "arch=$(XORG_PKG_ARCH)"                               >> $(XORG_PKG)/.PKGINFO ; \
	 echo "distroname=$(XORG_PKG_DISTRO_NAME)"                  >> $(XORG_PKG)/.PKGINFO ; \
	 echo "distrover=$(XORG_PKG_DISTRO_VERSION)"                >> $(XORG_PKG)/.PKGINFO ; \
	 echo "group=$(XORG_PKG_GROUP)"                             >> $(XORG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XORG_PKG_SHORT_DESCRIPTION)\"" >> $(XORG_PKG)/.PKGINFO ; \
	 echo "url=$(XORG_PKG_URL)"                                 >> $(XORG_PKG)/.PKGINFO ; \
	 echo "license=$(XORG_PKG_LICENSE)"                         >> $(XORG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XORG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
