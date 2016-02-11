
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/pinentry

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/ncurses/5.9
REQUIRES          += secure/libcap/2.24
else
REQUIRES           = libs/ncurses/5.9-x86_32
REQUIRES          += secure/libcap/2.24-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.8.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/pinentry/pinentry-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pinentry-$(version)
src_dir_name       = pinentry-$(version)
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
PINENTRY_PKG_NAME                = pinentry
PINENTRY_PKG_VERSION             = 0.8.4
PINENTRY_PKG_ARCH                = $(TOOLCHAIN)
PINENTRY_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PINENTRY_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PINENTRY_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PINENTRY_PKG_SHORT_DESCRIPTION   = PIN Entry dialogs
PINENTRY_PKG_URL                 = $(BUG_URL)
PINENTRY_PKG_LICENSE             = GPLv2
PINENTRY_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PINENTRY_PKG_NAME)-pkg-description
PINENTRY_PKG_DESCRIPTION_FILE_IN = $(PINENTRY_PKG_NAME)-pkg-description.in
PINENTRY_PKG_INSTALL_SCRIPT      = $(PINENTRY_PKG_NAME)-pkg-install.sh

PINENTRY_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PINENTRY_PKG_NAME)-package

pkg_basename     = $(PINENTRY_PKG_NAME)-$(PINENTRY_PKG_VERSION)-$(PINENTRY_PKG_ARCH)-$(PINENTRY_PKG_DISTRO_NAME)-$(PINENTRY_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PINENTRY_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-pinentry-gtk=no
extra_configure_switches += --enable-pinentry-curses
extra_configure_switches += --enable-fallback-curses
extra_configure_switches += --enable-pinentry-gtk2=no
extra_configure_switches += --enable-pinentry-qt4=no
extra_configure_switches += --disable-rpath


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PINENTRY_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(PINENTRY_PKG)/usr/share/info/dir
	@gzip -9 $(PINENTRY_PKG)/usr/share/info/*
	@if [ -d $(PINENTRY_PKG)/usr/share/man ]; then \
	  ( cd $(PINENTRY_PKG)/usr/share/man ; \
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
	@mkdir -p $(PINENTRY_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PINENTRY_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PINENTRY_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* THANKS TODO VERSION doc/HACKING \
	         $(PINENTRY_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PINENTRY_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PINENTRY_PKG))
	# ======= Strip binaries =======
	@( cd $(PINENTRY_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PINENTRY_PKG_DESCRIPTION_FILE): $(PINENTRY_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PINENTRY_PKG_DESCRIPTION_FILE) $(PINENTRY_PKG_INSTALL_SCRIPT)
	@cp $(PINENTRY_PKG_DESCRIPTION_FILE) $(PINENTRY_PKG)/.DESCRIPTION
	@cp $(PINENTRY_PKG_INSTALL_SCRIPT) $(PINENTRY_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PINENTRY_PKG)/.REQUIRES
	@echo "pkgname=$(PINENTRY_PKG_NAME)"                            >  $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PINENTRY_PKG_VERSION)"                          >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "arch=$(PINENTRY_PKG_ARCH)"                               >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "distroname=$(PINENTRY_PKG_DISTRO_NAME)"                  >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "distrover=$(PINENTRY_PKG_DISTRO_VERSION)"                >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "group=$(PINENTRY_PKG_GROUP)"                             >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PINENTRY_PKG_SHORT_DESCRIPTION)\"" >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "url=$(PINENTRY_PKG_URL)"                                 >> $(PINENTRY_PKG)/.PKGINFO ; \
	 echo "license=$(PINENTRY_PKG_LICENSE)"                         >> $(PINENTRY_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PINENTRY_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
