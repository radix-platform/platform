
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
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/linuxdoc-tools/xmlto

REQUIRES           = libs/libxslt/1.1.28
REQUIRES          += share/docbook-xsl/1.78.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.0.26
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/linuxdoc-tools/xmlto/xmlto-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xmlto-$(version)
src_dir_name       = xmlto-$(version)
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
XMLTO_PKG_NAME                = xmlto
XMLTO_PKG_VERSION             = 0.0.26
XMLTO_PKG_ARCH                = $(TOOLCHAIN)
XMLTO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XMLTO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XMLTO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
XMLTO_PKG_SHORT_DESCRIPTION   = Utility for converting XML files
XMLTO_PKG_URL                 = $(BUG_URL)
XMLTO_PKG_LICENSE             = GPLv2
XMLTO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XMLTO_PKG_NAME)-pkg-description
XMLTO_PKG_DESCRIPTION_FILE_IN = $(XMLTO_PKG_NAME)-pkg-description.in
XMLTO_PKG_INSTALL_SCRIPT      = $(XMLTO_PKG_NAME)-pkg-install.sh

XMLTO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XMLTO_PKG_NAME)-package

pkg_basename     = $(XMLTO_PKG_NAME)-$(XMLTO_PKG_VERSION)-$(XMLTO_PKG_ARCH)-$(XMLTO_PKG_DISTRO_NAME)-$(XMLTO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(XMLTO_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
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
	@mkdir -p $(XMLTO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(XMLTO_PKG)/usr/share/man ]; then \
	  ( cd $(XMLTO_PKG)/usr/share/man ; \
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
	@mkdir -p $(XMLTO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(XMLTO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XMLTO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING FAQ INSTALL NEWS README THANKS \
	         $(XMLTO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XMLTO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XMLTO_PKG))
	# ======= Strip binaries =======
	@( cd $(XMLTO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(XMLTO_PKG_DESCRIPTION_FILE): $(XMLTO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XMLTO_PKG_DESCRIPTION_FILE) $(XMLTO_PKG_INSTALL_SCRIPT)
	@cp $(XMLTO_PKG_DESCRIPTION_FILE) $(XMLTO_PKG)/.DESCRIPTION
	@cp $(XMLTO_PKG_INSTALL_SCRIPT) $(XMLTO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XMLTO_PKG)/.REQUIRES
	@echo "pkgname=$(XMLTO_PKG_NAME)"                            >  $(XMLTO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XMLTO_PKG_VERSION)"                          >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "arch=$(XMLTO_PKG_ARCH)"                               >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "distroname=$(XMLTO_PKG_DISTRO_NAME)"                  >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "distrover=$(XMLTO_PKG_DISTRO_VERSION)"                >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "group=$(XMLTO_PKG_GROUP)"                             >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XMLTO_PKG_SHORT_DESCRIPTION)\"" >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "url=$(XMLTO_PKG_URL)"                                 >> $(XMLTO_PKG)/.PKGINFO ; \
	 echo "license=$(XMLTO_PKG_LICENSE)"                         >> $(XMLTO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XMLTO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
