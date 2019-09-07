
COMPONENT_TARGETS  = $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/Mali/aml-mali

REQUIRES           = hal/ump/DX/5.1.1.0
REQUIRES          += X11/libs/libdrm/2.4.68
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXfixes/5.0.1

# ======= __END_OF_REQUIRES__ =======


version            = 5.1.1.0
timestamp          = 20160818
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/Mali/aml-mali/aml-mali-$(timestamp).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/aml-mali-$(timestamp)
src_dir_name       = aml-mali-$(timestamp)
doc_dir_name       = aml-mali-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/COPYING
pkgconfigs_dir     = $(CURDIR)/pkgconfigs

PATCHES = PATCHES

install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_PKG_NAME                = aml-mali
XORG_PKG_VERSION             = 5.1.1.0
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
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XORG_PKG)


AML_CPU_ARCH            = arm64
AML_GPU_VERSION         = r5p1
AML_OPENGL_MALI_DIR     = m450-X


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(XORG_PKG)/usr
	@mkdir -p $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@( cd $(SRC_DIR) ;                 \
	   cp -a include $(XORG_PKG)/usr ; \
	   cp -a lib/$(AML_CPU_ARCH)/$(AML_GPU_VERSION)/$(AML_OPENGL_MALI_DIR)/libMali.so \
	         $(XORG_PKG)/usr/lib$(LIBSUFFIX) ; \
	 )
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 lib* ; \
	   ln -sf libMali.so          libEGL.so.1.4       ; \
	   ln -sf libEGL.so.1.4       libEGL.so.1         ; \
	   ln -sf libEGL.so.1         libEGL.so           ; \
	   ln -sf libMali.so          libGLESv1_CM.so.1.1 ; \
	   ln -sf libGLESv1_CM.so.1.1 libGLESv1_CM.so.1   ; \
	   ln -sf libGLESv1_CM.so.1   libGLESv1_CM.so     ; \
	   ln -sf libMali.so          libGLESv2.so.2.0    ; \
	   ln -sf libGLESv2.so.2.0    libGLESv2.so.2      ; \
	   ln -sf libGLESv2.so.2      libGLESv2.so        ; \
	 )
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
	   cp -a $(license) \
	         $(XORG_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(XORG_PKG)/usr/share/doc ; \
	   ln -sf $(doc_dir_name) $(XORG_PKG_NAME) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XORG_PKG))
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
	@$(PSEUDO) sh -c "cd $(XORG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
