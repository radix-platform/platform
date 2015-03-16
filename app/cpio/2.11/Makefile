
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/cpio

REQUIRES           = libs/eglibc/2.19.1
REQUIRES          += app/tar/1.27.1

# ======= __END_OF_REQUIRES__ =======


version            = 2.11
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/cpio/cpio-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cpio-$(version)
src_dir_name       = cpio-$(version)
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
CPIO_PKG_NAME                = cpio
CPIO_PKG_VERSION             = 2.11
CPIO_PKG_ARCH                = $(TOOLCHAIN)
CPIO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CPIO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CPIO_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
CPIO_PKG_SHORT_DESCRIPTION   = backup and archiving utility
CPIO_PKG_URL                 = $(BUG_URL)
CPIO_PKG_LICENSE             = GPLv2
CPIO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CPIO_PKG_NAME)-pkg-description
CPIO_PKG_DESCRIPTION_FILE_IN = $(CPIO_PKG_NAME)-pkg-description.in
CPIO_PKG_INSTALL_SCRIPT      = $(CPIO_PKG_NAME)-pkg-install.sh

CPIO_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CPIO_PKG_NAME)-package

pkg_basename     = $(CPIO_PKG_NAME)-$(CPIO_PKG_VERSION)-$(CPIO_PKG_ARCH)-$(CPIO_PKG_DISTRO_NAME)-$(CPIO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CPIO_PKG) INSTALL="install -p"


extra_configure_switches  = --bindir=/bin
extra_configure_switches += --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --enable-mt
extra_configure_switches += --with-rmt=/sbin/rmt


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
	@mkdir -p $(CPIO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@rmdir $(CPIO_PKG)/usr/libexec
	# ======= Do not clash with the 'mt' which is part of tar: =======
	@mv $(CPIO_PKG)/bin/mt{,-GNU}
	@mv $(CPIO_PKG)/usr/share/man/man1/mt{,-GNU}.1
	@rm -f $(CPIO_PKG)/usr/share/info/dir
	@gzip -9 $(CPIO_PKG)/usr/share/info/*
	@if [ -d $(CPIO_PKG)/usr/share/man ]; then \
	  ( cd $(CPIO_PKG)/usr/share/man ; \
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
	@mkdir -p $(CPIO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(CPIO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CPIO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING* INSTALL NEWS README* THANKS TODO \
	         $(CPIO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CPIO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(CPIO_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(CPIO_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(CPIO_PKG_DESCRIPTION_FILE): $(CPIO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CPIO_PKG_DESCRIPTION_FILE) $(CPIO_PKG_INSTALL_SCRIPT)
	@cp $(CPIO_PKG_DESCRIPTION_FILE) $(CPIO_PKG)/.DESCRIPTION
	@cp $(CPIO_PKG_INSTALL_SCRIPT) $(CPIO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CPIO_PKG)/.REQUIRES
	@echo "pkgname=$(CPIO_PKG_NAME)"                            >  $(CPIO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CPIO_PKG_VERSION)"                          >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "arch=$(CPIO_PKG_ARCH)"                               >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "distroname=$(CPIO_PKG_DISTRO_NAME)"                  >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "distrover=$(CPIO_PKG_DISTRO_VERSION)"                >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "group=$(CPIO_PKG_GROUP)"                             >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CPIO_PKG_SHORT_DESCRIPTION)\"" >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "url=$(CPIO_PKG_URL)"                                 >> $(CPIO_PKG)/.PKGINFO ; \
	 echo "license=$(CPIO_PKG_LICENSE)"                         >> $(CPIO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CPIO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
