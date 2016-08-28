
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/mc

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = app/gpm/1.20.7
REQUIRES          += libs/slang/2.2.4
REQUIRES          += libs/glib2/2.40.0
else
REQUIRES           = app/gpm/1.20.7-x86_32
REQUIRES          += libs/slang/2.2.4-x86_32
REQUIRES          += libs/glib2/2.40.0-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.8.12
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/mc/mc-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mc-$(version)
src_dir_name       = mc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

profile_d          = $(CURDIR)/profile.d

WITH_SMBFS_HELPERTS = yes

#
# To enable smbfs helpers we have to use config.cache:
#
ifeq ($(WITH_SMBFS_HELPERTS),yes)
hw_cache_in        = $(CURDIR)/cross/hw.cache
hw_cache           = $(CURDIR)/$(build_dir)/hw.cache
endif


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MC_PKG_NAME                = mc
MC_PKG_VERSION             = 4.8.12
MC_PKG_ARCH                = $(TOOLCHAIN)
MC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MC_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
MC_PKG_SHORT_DESCRIPTION   = Midnight Commander file manager
MC_PKG_URL                 = $(BUG_URL)
MC_PKG_LICENSE             = GPLv3
MC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MC_PKG_NAME)-pkg-description
MC_PKG_DESCRIPTION_FILE_IN = $(MC_PKG_NAME)-pkg-description.in
MC_PKG_INSTALL_SCRIPT      = $(MC_PKG_NAME)-pkg-install.sh

MC_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MC_PKG_NAME)-package

pkg_basename     = $(MC_PKG_NAME)-$(MC_PKG_VERSION)-$(MC_PKG_ARCH)-$(MC_PKG_DISTRO_NAME)-$(MC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MC_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-extcharset
extra_configure_switches += --enable-netcode
extra_configure_switches += --enable-background
extra_configure_switches += --enable-charset
extra_configure_switches += --with-gpm-mouse
extra_configure_switches += --with-ext2undel
extra_configure_switches += --with-x=no
extra_configure_switches += --with-vfs

ifeq ($(WITH_SMBFS_HELPERTS),yes)
extra_configure_switches += --enable-vfs-smb
extra_configure_switches += --with-smb-configdir=/etc/samba
extra_configure_switches += --with-smb-codepagedir=/etc/codepages

extra_configure_switches += --cache-file=$(hw_cache)
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
ifeq ($(WITH_SMBFS_HELPERTS),yes)
	@cp -a $(hw_cache_in) $(hw_cache)
endif
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install MC wrappers =======
	@mkdir -p $(MC_PKG)/etc/profile.d
	@cp -a $(profile_d)/mc.* $(MC_PKG)/etc/profile.d
	@chmod 0755 $(MC_PKG)/etc/profile.d/*
	@mkdir -p $(MC_PKG)/usr/share/mc/bin
	@cp -a $(profile_d)/mc-wrapper.* $(MC_PKG)/usr/share/mc/bin
	@chmod 0755 $(MC_PKG)/usr/share/mc/bin/*
	# ======= Compress man pages =======
	@if [ -d $(MC_PKG)/usr/share/man ]; then \
	  ( cd $(MC_PKG)/usr/share/man ; \
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
	# ======= Install Documentation =======
	@mkdir -p $(MC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(MC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS doc/COPYING* doc/FAQ    \
	         doc/HACKING doc/INSTALL*        \
	         doc/MAINTAINERS doc/MIRRORS.txt \
	         doc/NEWS doc/README* doc/TODO   \
	         doc/keybind-migration.txt       \
	         $(MC_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MC_PKG))
	# ======= Strip binaries =======
	@( cd $(MC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(MC_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MC_PKG_DESCRIPTION_FILE): $(MC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MC_PKG_DESCRIPTION_FILE) $(MC_PKG_INSTALL_SCRIPT)
	@cp $(MC_PKG_DESCRIPTION_FILE) $(MC_PKG)/.DESCRIPTION
	@cp $(MC_PKG_INSTALL_SCRIPT) $(MC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MC_PKG)/.REQUIRES
	@echo "pkgname=$(MC_PKG_NAME)"                            >  $(MC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MC_PKG_VERSION)"                          >> $(MC_PKG)/.PKGINFO ; \
	 echo "arch=$(MC_PKG_ARCH)"                               >> $(MC_PKG)/.PKGINFO ; \
	 echo "distroname=$(MC_PKG_DISTRO_NAME)"                  >> $(MC_PKG)/.PKGINFO ; \
	 echo "distrover=$(MC_PKG_DISTRO_VERSION)"                >> $(MC_PKG)/.PKGINFO ; \
	 echo "group=$(MC_PKG_GROUP)"                             >> $(MC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MC_PKG_SHORT_DESCRIPTION)\"" >> $(MC_PKG)/.PKGINFO ; \
	 echo "url=$(MC_PKG_URL)"                                 >> $(MC_PKG)/.PKGINFO ; \
	 echo "license=$(MC_PKG_LICENSE)"                         >> $(MC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
