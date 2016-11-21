
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


SOURCE_REQUIRES    = sources/packages/x/xterm

REQUIRES           = libs/libtermcap/1.2.3
REQUIRES          += app/utempter/1.1.6
REQUIRES          += X11/X.org/lib/libXaw/1.0.13
REQUIRES          += X11/X.org/lib/libXft/2.3.2
REQUIRES          += X11/X.org/lib/libxkbfile/1.0.9
REQUIRES          += X11/X.org/data/xbitmaps/1.1.1
REQUIRES          += X11/X.org/app/luit/1.1.1

# ======= __END_OF_REQUIRES__ =======


version            = 313
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/xterm/xterm-$(version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xterm-$(version)
src_dir_name       = xterm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/LICENSE

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XTERM_PKG_NAME                = xterm
XTERM_PKG_VERSION             = 313
XTERM_PKG_ARCH                = $(TOOLCHAIN)
XTERM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XTERM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XTERM_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
XTERM_PKG_SHORT_DESCRIPTION   = terminal emulator for X
XTERM_PKG_URL                 = $(BUG_URL)
XTERM_PKG_LICENSE             = custom
XTERM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XTERM_PKG_NAME)-pkg-description
XTERM_PKG_DESCRIPTION_FILE_IN = $(XTERM_PKG_NAME)-pkg-description.in
XTERM_PKG_INSTALL_SCRIPT      = $(XTERM_PKG_NAME)-pkg-install.sh

XTERM_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XTERM_PKG_NAME)-package

pkg_basename     = $(XTERM_PKG_NAME)-$(XTERM_PKG_VERSION)-$(XTERM_PKG_ARCH)-$(XTERM_PKG_DISTRO_NAME)-$(XTERM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XTERM_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-app-defaults=/etc/X11/app-defaults
extra_configure_switches += --with-utempter
extra_configure_switches += --enable-luit
extra_configure_switches += --enable-wide-chars
extra_configure_switches += --enable-88-color
extra_configure_switches += --enable-256-color
extra_configure_switches += --with-icon-theme=hicolor
extra_configure_switches += --with-icondir=/usr/share/icons
extra_configure_switches += --with-pixmapdir=/usr/share/pixmaps


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XTERM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(XTERM_PKG)/usr/share/applications
	@( cd $(SRC_DIR) ; \
	   cp -a uxterm.desktop xterm.desktop \
	         $(XTERM_PKG)/usr/share/applications \
	 )
	# ======= Install Documentation =======
	@if [ -d $(XTERM_PKG)/usr/share/man ]; then \
	  ( cd $(XTERM_PKG)/usr/share/man ; \
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
	@mkdir -p $(XTERM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(XTERM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XTERM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a $(license) AAA_README_VMS.txt INSTALL MANIFEST README* THANKS \
	         $(XTERM_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XTERM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XTERM_PKG))
	# ======= Strip binaries =======
	@( cd $(XTERM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(XTERM_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(XTERM_PKG_DESCRIPTION_FILE): $(XTERM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XTERM_PKG_DESCRIPTION_FILE) $(XTERM_PKG_INSTALL_SCRIPT)
	@cp $(XTERM_PKG_DESCRIPTION_FILE) $(XTERM_PKG)/.DESCRIPTION
	@cp $(XTERM_PKG_INSTALL_SCRIPT) $(XTERM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XTERM_PKG)/.REQUIRES
	@echo "pkgname=$(XTERM_PKG_NAME)"                            >  $(XTERM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XTERM_PKG_VERSION)"                          >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "arch=$(XTERM_PKG_ARCH)"                               >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "distroname=$(XTERM_PKG_DISTRO_NAME)"                  >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "distrover=$(XTERM_PKG_DISTRO_VERSION)"                >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "group=$(XTERM_PKG_GROUP)"                             >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XTERM_PKG_SHORT_DESCRIPTION)\"" >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "url=$(XTERM_PKG_URL)"                                 >> $(XTERM_PKG)/.PKGINFO ; \
	 echo "license=$(XTERM_PKG_LICENSE)"                         >> $(XTERM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XTERM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
