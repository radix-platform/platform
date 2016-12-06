
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/X.org/proto/inputproto

REQUIRES           = X11/X.org/doc/xorg-sgml-doctools/1.11

# ======= __END_OF_REQUIRES__ =======


version            = 2.3.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/X.org/proto/inputproto/inputproto-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/inputproto-$(version)
src_dir_name       = inputproto-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xorg

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_PKG_NAME                = inputproto
XORG_PKG_VERSION             = 2.3.2
XORG_PKG_ARCH                = $(TOOLCHAIN)
XORG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XORG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XORG_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XORG_PKG_SHORT_DESCRIPTION   = X11 Input PROTO
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


include ../../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XORG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


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
	@mkdir -p $(XORG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(XORG_PKG)/usr/share/man ]; then \
	  ( cd $(XORG_PKG)/usr/share/man ; \
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
	@mkdir -p $(XORG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(XORG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XORG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README \
	         $(XORG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(XORG_PKG)/usr/share/doc ; \
	   ln -sf $(src_dir_name) $(XORG_PKG_NAME) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XORG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XORG_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" inputproto.pc \
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
	@$(PSEUDO) sh -c "cd $(XORG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
