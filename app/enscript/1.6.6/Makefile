
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


SOURCE_REQUIRES    = sources/GNU/enscript

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
REQUIRES           = libs/glibc/2.21
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/enscript/enscript-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/enscript-$(version)
src_dir_name       = enscript-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ENSCRIPT_PKG_NAME                = enscript
ENSCRIPT_PKG_VERSION             = 1.6.6
ENSCRIPT_PKG_ARCH                = $(TOOLCHAIN)
ENSCRIPT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ENSCRIPT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ENSCRIPT_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
ENSCRIPT_PKG_SHORT_DESCRIPTION   = text files to PostScript converter
ENSCRIPT_PKG_URL                 = $(BUG_URL)
ENSCRIPT_PKG_LICENSE             = GPLv3
ENSCRIPT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ENSCRIPT_PKG_NAME)-pkg-description
ENSCRIPT_PKG_DESCRIPTION_FILE_IN = $(ENSCRIPT_PKG_NAME)-pkg-description.in
ENSCRIPT_PKG_INSTALL_SCRIPT      = $(ENSCRIPT_PKG_NAME)-pkg-install.sh

ENSCRIPT_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ENSCRIPT_PKG_NAME)-package

pkg_basename     = $(ENSCRIPT_PKG_NAME)-$(ENSCRIPT_PKG_VERSION)-$(ENSCRIPT_PKG_ARCH)-$(ENSCRIPT_PKG_DISTRO_NAME)-$(ENSCRIPT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ENSCRIPT_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-media=A4
extra_configure_switches += --disable-dependency-tracking


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
	@mkdir -p $(ENSCRIPT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@( cd $(ENSCRIPT_PKG)/etc ; \
	   mv enscript.cfg enscript.cfg.new ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(ENSCRIPT_PKG)/usr/share/info/dir
	@gzip -9 $(ENSCRIPT_PKG)/usr/share/info/*
	@if [ -d $(ENSCRIPT_PKG)/usr/share/man ]; then \
	  ( cd $(ENSCRIPT_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.* ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(ENSCRIPT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(ENSCRIPT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ENSCRIPT_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL NEWS README* THANKS TODO \
	         $(ENSCRIPT_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a docs/FAQ.html \
	         $(ENSCRIPT_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ENSCRIPT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ENSCRIPT_PKG))
	# ======= Strip binaries =======
	@( cd $(ENSCRIPT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ENSCRIPT_PKG_DESCRIPTION_FILE): $(ENSCRIPT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ENSCRIPT_PKG_DESCRIPTION_FILE) $(ENSCRIPT_PKG_INSTALL_SCRIPT)
	@cp $(ENSCRIPT_PKG_DESCRIPTION_FILE) $(ENSCRIPT_PKG)/.DESCRIPTION
	@cp $(ENSCRIPT_PKG_INSTALL_SCRIPT) $(ENSCRIPT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ENSCRIPT_PKG)/.REQUIRES
	@echo "pkgname=$(ENSCRIPT_PKG_NAME)"                            >  $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ENSCRIPT_PKG_VERSION)"                          >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "arch=$(ENSCRIPT_PKG_ARCH)"                               >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "distroname=$(ENSCRIPT_PKG_DISTRO_NAME)"                  >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "distrover=$(ENSCRIPT_PKG_DISTRO_VERSION)"                >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "group=$(ENSCRIPT_PKG_GROUP)"                             >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ENSCRIPT_PKG_SHORT_DESCRIPTION)\"" >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "url=$(ENSCRIPT_PKG_URL)"                                 >> $(ENSCRIPT_PKG)/.PKGINFO ; \
	 echo "license=$(ENSCRIPT_PKG_LICENSE)"                         >> $(ENSCRIPT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ENSCRIPT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
