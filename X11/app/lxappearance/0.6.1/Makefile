
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/lxappearance

REQUIRES           = X11/libs/gtk+2/2.24.25

# ======= __END_OF_REQUIRES__ =======


version            = 0.6.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/lxappearance/lxappearance-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lxappearance-$(version)
src_dir_name       = lxappearance-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LXAPP_PKG_NAME                = lxappearance
LXAPP_PKG_VERSION             = 0.6.1
LXAPP_PKG_ARCH                = $(TOOLCHAIN)
LXAPP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LXAPP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LXAPP_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
LXAPP_PKG_SHORT_DESCRIPTION   = desktop-independent theme switcher for GTK+
LXAPP_PKG_URL                 = $(BUG_URL)
LXAPP_PKG_LICENSE             = GPLv2
LXAPP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LXAPP_PKG_NAME)-pkg-description
LXAPP_PKG_DESCRIPTION_FILE_IN = $(LXAPP_PKG_NAME)-pkg-description.in
LXAPP_PKG_INSTALL_SCRIPT      = $(LXAPP_PKG_NAME)-pkg-install.sh

LXAPP_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LXAPP_PKG_NAME)-package

pkg_basename     = $(LXAPP_PKG_NAME)-$(LXAPP_PKG_VERSION)-$(LXAPP_PKG_ARCH)-$(LXAPP_PKG_DISTRO_NAME)-$(LXAPP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LXAPP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-man
extra_configure_switches += --with-xml-catalog=/etc/xml/catalog

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
	@mkdir -p $(LXAPP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LXAPP_PKG)/usr/share/man ]; then \
	  ( cd $(LXAPP_PKG)/usr/share/man ; \
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
	@mkdir -p $(LXAPP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LXAPP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LXAPP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README \
	         $(LXAPP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LXAPP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LXAPP_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lxappearance.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LXAPP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LXAPP_PKG_DESCRIPTION_FILE): $(LXAPP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LXAPP_PKG_DESCRIPTION_FILE) $(LXAPP_PKG_INSTALL_SCRIPT)
	@cp $(LXAPP_PKG_DESCRIPTION_FILE) $(LXAPP_PKG)/.DESCRIPTION
	@cp $(LXAPP_PKG_INSTALL_SCRIPT) $(LXAPP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LXAPP_PKG)/.REQUIRES
	@echo "pkgname=$(LXAPP_PKG_NAME)"                            >  $(LXAPP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LXAPP_PKG_VERSION)"                          >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "arch=$(LXAPP_PKG_ARCH)"                               >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "distroname=$(LXAPP_PKG_DISTRO_NAME)"                  >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "distrover=$(LXAPP_PKG_DISTRO_VERSION)"                >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "group=$(LXAPP_PKG_GROUP)"                             >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LXAPP_PKG_SHORT_DESCRIPTION)\"" >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "url=$(LXAPP_PKG_URL)"                                 >> $(LXAPP_PKG)/.PKGINFO ; \
	 echo "license=$(LXAPP_PKG_LICENSE)"                         >> $(LXAPP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LXAPP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
