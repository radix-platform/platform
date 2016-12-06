
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/xdg-user-dirs

REQUIRES           = X11/app/xdg-utils/1.1.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.15
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/xdg-user-dirs/xdg-user-dirs-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xdg-user-dirs-$(version)
src_dir_name       = xdg-user-dirs-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XDGUDIRS_PKG_NAME                = xdg-user-dirs
XDGUDIRS_PKG_VERSION             = 0.15
XDGUDIRS_PKG_ARCH                = $(TOOLCHAIN)
XDGUDIRS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XDGUDIRS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XDGUDIRS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
XDGUDIRS_PKG_SHORT_DESCRIPTION   = manage XDG user directories
XDGUDIRS_PKG_URL                 = $(BUG_URL)
XDGUDIRS_PKG_LICENSE             = GPLv2
XDGUDIRS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XDGUDIRS_PKG_NAME)-pkg-description
XDGUDIRS_PKG_DESCRIPTION_FILE_IN = $(XDGUDIRS_PKG_NAME)-pkg-description.in
XDGUDIRS_PKG_INSTALL_SCRIPT      = $(XDGUDIRS_PKG_NAME)-pkg-install.sh

XDGUDIRS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XDGUDIRS_PKG_NAME)-package

pkg_basename     = $(XDGUDIRS_PKG_NAME)-$(XDGUDIRS_PKG_VERSION)-$(XDGUDIRS_PKG_ARCH)-$(XDGUDIRS_PKG_DISTRO_NAME)-$(XDGUDIRS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XDGUDIRS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-documentation


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XDGUDIRS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mv $(XDGUDIRS_PKG)/etc/xdg/user-dirs.conf     $(XDGUDIRS_PKG)/etc/xdg/user-dirs.conf.new
	@mv $(XDGUDIRS_PKG)/etc/xdg/user-dirs.defaults $(XDGUDIRS_PKG)/etc/xdg/user-dirs.defaults.new
	# ======= Install Documentation =======
	@if [ -d $(XDGUDIRS_PKG)/usr/share/man ]; then \
	  ( cd $(XDGUDIRS_PKG)/usr/share/man ; \
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
	@mkdir -p $(XDGUDIRS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(XDGUDIRS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XDGUDIRS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README \
	         $(XDGUDIRS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XDGUDIRS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XDGUDIRS_PKG))
	# ======= Strip binaries =======
	@( cd $(XDGUDIRS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(XDGUDIRS_PKG_DESCRIPTION_FILE): $(XDGUDIRS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XDGUDIRS_PKG_DESCRIPTION_FILE) $(XDGUDIRS_PKG_INSTALL_SCRIPT)
	@cp $(XDGUDIRS_PKG_DESCRIPTION_FILE) $(XDGUDIRS_PKG)/.DESCRIPTION
	@cp $(XDGUDIRS_PKG_INSTALL_SCRIPT) $(XDGUDIRS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XDGUDIRS_PKG)/.REQUIRES
	@echo "pkgname=$(XDGUDIRS_PKG_NAME)"                            >  $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XDGUDIRS_PKG_VERSION)"                          >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "arch=$(XDGUDIRS_PKG_ARCH)"                               >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "distroname=$(XDGUDIRS_PKG_DISTRO_NAME)"                  >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "distrover=$(XDGUDIRS_PKG_DISTRO_VERSION)"                >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "group=$(XDGUDIRS_PKG_GROUP)"                             >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XDGUDIRS_PKG_SHORT_DESCRIPTION)\"" >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "url=$(XDGUDIRS_PKG_URL)"                                 >> $(XDGUDIRS_PKG)/.PKGINFO ; \
	 echo "license=$(XDGUDIRS_PKG_LICENSE)"                         >> $(XDGUDIRS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(XDGUDIRS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
