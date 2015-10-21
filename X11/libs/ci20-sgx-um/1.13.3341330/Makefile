
COMPONENT_TARGETS  = $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/PowerVR/ci20/sgx-ddk/3.0.8

REQUIRES           = dev/gcc/4.9.2
REQUIRES          += hal/drivers/ci20/sgx-ddk/3.0.8/1.13.3341330
REQUIRES          += X11/libs/mesa/10.3.4
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXfixes/5.0.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.13.3341330
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/PowerVR/ci20/sgx-ddk/3.0.8/ci20-sgx-um-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ci20-sgx-um-$(version)
src_dir_name       = ci20-sgx-um-$(version)
doc_dir_name       = ci20-sgx-um-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/COPYING
pkgconfigs_dir     = $(CURDIR)/pkgconfigs
scripts            = $(CURDIR)/etc

PATCHES = PATCHES

install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_PKG_NAME                = ci20-sgx-um
XORG_PKG_VERSION             = 1.13.3341330
XORG_PKG_ARCH                = $(TOOLCHAIN)
XORG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XORG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XORG_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XORG_PKG_SHORT_DESCRIPTION   = PowerVR userspace drivers for X11
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


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(XORG_PKG)
	# ======= Install MIPS Creator CI20 PowerVR DDK UM =======
	@mkdir -p $(XORG_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(SRC_DIR) ; \
	   cp -a usr $(XORG_PKG) ; \
	 )
	# ======= Install pkg-config *.pc files to the target destination for development =======
	@mkdir -p $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cp -a $(pkgconfigs_dir)/egl.pc       $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cp -a $(pkgconfigs_dir)/glesv1_cm.pc $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cp -a $(pkgconfigs_dir)/glesv2.pc    $(XORG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	# ======= Install Scripts =======
	@mkdir -p $(XORG_PKG)/etc/{X11,rc.d}
	@cp -a $(scripts)/X11/xorg.conf.powervr $(XORG_PKG)/etc/X11
	@cp -a $(scripts)/rc.d/rc.powervr.example $(XORG_PKG)/etc/rc.d
	@chmod a-x $(XORG_PKG)/etc/rc.d/rc.powervr.example
	@( cd $(XORG_PKG)/etc/X11 ; \
	   ln -sf xorg.conf.powervr xorg.conf ; \
	 )
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
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(XORG_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "/usr/local/XSGX/lib" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(XORG_PKG)/usr ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "/usr/local/XSGX/lib" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
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
