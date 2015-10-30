
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/apps/glade2

REQUIRES           = X11/libs/gtk+2/2.24.25
REQUIRES          += X11/app/desktop-file-utils/0.22

# ======= __END_OF_REQUIRES__ =======


version            = 2.12.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNOME/apps/glade2/glade-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glade-$(version)
src_dir_name       = glade-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xapp

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLADE2_PKG_NAME                = glade2
GLADE2_PKG_VERSION             = 2.12.2
GLADE2_PKG_ARCH                = $(TOOLCHAIN)
GLADE2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLADE2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLADE2_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
GLADE2_PKG_SHORT_DESCRIPTION   = User Interface Designer for GTK+ and GNOME
GLADE2_PKG_URL                 = $(BUG_URL)
GLADE2_PKG_LICENSE             = GPLv2
GLADE2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLADE2_PKG_NAME)-pkg-description
GLADE2_PKG_DESCRIPTION_FILE_IN = $(GLADE2_PKG_NAME)-pkg-description.in
GLADE2_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(GLADE2_PKG_NAME)-pkg-install.sh
GLADE2_PKG_INSTALL_SCRIPT_IN   = $(GLADE2_PKG_NAME)-pkg-install.sh.in

GLADE2_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLADE2_PKG_NAME)-package

pkg_basename     = $(GLADE2_PKG_NAME)-$(GLADE2_PKG_VERSION)-$(GLADE2_PKG_ARCH)-$(GLADE2_PKG_DISTRO_NAME)-$(GLADE2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(GLADE2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-gnome-db
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLADE2_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(GLADE2_PKG)/usr/share/man ]; then \
	  ( cd $(GLADE2_PKG)/usr/share/man ; \
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
	@mkdir -p $(GLADE2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GLADE2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GLADE2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING FAQ INSTALL NEWS README TODO \
	         $(GLADE2_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLADE2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLADE2_PKG))
	@( cd $(GLADE2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GLADE2_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GLADE2_PKG_DESCRIPTION_FILE): $(GLADE2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(GLADE2_PKG_INSTALL_SCRIPT): $(GLADE2_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLADE2_PKG_DESCRIPTION_FILE) $(GLADE2_PKG_INSTALL_SCRIPT)
	@cp $(GLADE2_PKG_DESCRIPTION_FILE) $(GLADE2_PKG)/.DESCRIPTION
	@cp $(GLADE2_PKG_INSTALL_SCRIPT) $(GLADE2_PKG)/.INSTALL
	@chmod a+x $(GLADE2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLADE2_PKG)/.REQUIRES
	@echo "pkgname=$(GLADE2_PKG_NAME)"                            >  $(GLADE2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLADE2_PKG_VERSION)"                          >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "arch=$(GLADE2_PKG_ARCH)"                               >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLADE2_PKG_DISTRO_NAME)"                  >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLADE2_PKG_DISTRO_VERSION)"                >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "group=$(GLADE2_PKG_GROUP)"                             >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLADE2_PKG_SHORT_DESCRIPTION)\"" >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "url=$(GLADE2_PKG_URL)"                                 >> $(GLADE2_PKG)/.PKGINFO ; \
	 echo "license=$(GLADE2_PKG_LICENSE)"                         >> $(GLADE2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLADE2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
