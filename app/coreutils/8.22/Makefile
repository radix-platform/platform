
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/coreutils

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif

# ======= __END_OF_REQUIRES__ =======


version            = 8.22
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/coreutils/coreutils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/coreutils-$(version)
src_dir_name       = coreutils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

man_pages_dir      = $(CURDIR)/man-pages

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
PATCHES = PATCHES
else
PATCHES = PATCHES.noman
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
COREUTILS_PKG_NAME                = coreutils
COREUTILS_PKG_VERSION             = 8.22
COREUTILS_PKG_ARCH                = $(TOOLCHAIN)
COREUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
COREUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
COREUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
COREUTILS_PKG_SHORT_DESCRIPTION   = core GNU utilities
COREUTILS_PKG_URL                 = $(BUG_URL)
COREUTILS_PKG_LICENSE             = GPLv2
COREUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(COREUTILS_PKG_NAME)-pkg-description
COREUTILS_PKG_DESCRIPTION_FILE_IN = $(COREUTILS_PKG_NAME)-pkg-description.in
COREUTILS_PKG_INSTALL_SCRIPT      = $(COREUTILS_PKG_NAME)-pkg-install.sh

COREUTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(COREUTILS_PKG_NAME)-package

pkg_basename     = $(COREUTILS_PKG_NAME)-$(COREUTILS_PKG_VERSION)-$(COREUTILS_PKG_ARCH)-$(COREUTILS_PKG_DISTRO_NAME)-$(COREUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(COREUTILS_PKG)


environment  = FORCE_UNSAFE_CONFIGURE=1
environment += DEFAULT_POSIX2_VERSION=199209

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-rpath
extra_configure_switches += --bindir=/bin
extra_configure_switches += --without-gmp


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
#	@( cd $(SRC_DIR) ; \
#	   find . -exec touch -t 201403171037.43 {} \; \
#	 )
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(COREUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
ifeq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
	@mkdir -p $(COREUTILS_PKG)/usr/share/man
	@( cd $(COREUTILS_PKG)/usr/share/man ; \
	   tar xzf $(man_pages_dir)/man1-$(version) \
	 )
endif
	@rm -rf $(COREUTILS_PKG)/usr/share/locale/*/LC_TIME
	@mkdir -p $(COREUTILS_PKG)/bin $(COREUTILS_PKG)/usr/bin
	@( cd $(COREUTILS_PKG)/bin ; mv mktemp mktemp-gnu )
	@( cd $(COREUTILS_PKG)/usr/bin ; \
	   for file in ../../bin/* ; do \
	     ln -sf $$file . ; \
	   done \
	 )
	@mkdir -p $(COREUTILS_PKG)/etc/profile.d
	@cat $(CURDIR)/dir-colors/DIR_COLORS > $(COREUTILS_PKG)/etc/DIR_COLORS.new
	@cp -a $(CURDIR)/dir-colors/coreutils-dircolors.* $(COREUTILS_PKG)/etc/profile.d
	@chmod 0755 $(COREUTILS_PKG)/etc/profile.d/coreutils-dircolors.*
	@( cd $(COREUTILS_PKG)/bin ; ln -sf install ginstall )
	@( cd $(COREUTILS_PKG)/usr/bin ; ln -sf ../../bin/ginstall ginstall )
	@( cd $(COREUTILS_PKG)/usr/share/man/man1 ; mv mktemp.1 mktemp-gnu.1 )
	@( cd $(COREUTILS_PKG)/usr/share/man/man1 ; ln -sf install.1 ginstall.1 )
	# ======= Remove 'hostname', 'kill', 'su', 'uptime' =======
	@for dupe in hostname kill su uptime ; do \
	  rm -f $(COREUTILS_PKG)/bin/$$dupe $(COREUTILS_PKG)/usr/bin/$$dupe \
	        $(COREUTILS_PKG)/usr/sbin/$$dupe $(COREUTILS_PKG)/usr/share/man/man?/$$dupe.* ; \
	 done
	# ======= Install Documentation =======
	@rm -f $(COREUTILS_PKG)/usr/share/info/dir
	@gzip -9 $(COREUTILS_PKG)/usr/share/info/*
	@if [ -d $(COREUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(COREUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(COREUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(COREUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(COREUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL NEWS README THANKS THANKS-* TODO \
	         $(COREUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(COREUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(COREUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(COREUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(COREUTILS_PKG_DESCRIPTION_FILE): $(COREUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(COREUTILS_PKG_DESCRIPTION_FILE) $(COREUTILS_PKG_INSTALL_SCRIPT)
	@cp $(COREUTILS_PKG_DESCRIPTION_FILE) $(COREUTILS_PKG)/.DESCRIPTION
	@cp $(COREUTILS_PKG_INSTALL_SCRIPT) $(COREUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(COREUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(COREUTILS_PKG_NAME)"                            >  $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(COREUTILS_PKG_VERSION)"                          >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(COREUTILS_PKG_ARCH)"                               >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(COREUTILS_PKG_DISTRO_NAME)"                  >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(COREUTILS_PKG_DISTRO_VERSION)"                >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(COREUTILS_PKG_GROUP)"                             >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(COREUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(COREUTILS_PKG_URL)"                                 >> $(COREUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(COREUTILS_PKG_LICENSE)"                         >> $(COREUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(COREUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
