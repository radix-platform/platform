
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/gettext

REQUIRES           = app/gettext/0.18.3.2
#
# requires:
#   gettext (libintl)
#   glib2
#   libcroco
#   libunistring
#   libxml2
#   libncurses
#   libtermcap
#   libexpat
#   regex - probably
#

version            = 0.18.3.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/gettext/gettext-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gettext-$(version)
src_dir_name       = gettext-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

doc_dir_name       = gettext-tools-$(version)

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GETTEXT_PKG_NAME                = gettext-tools
GETTEXT_PKG_VERSION             = 0.18.3.2
GETTEXT_PKG_ARCH                = $(TOOLCHAIN)
GETTEXT_PKG_DISTRO_NAME         = kxLab
GETTEXT_PKG_DISTRO_VERSION      = 1.0
GETTEXT_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GETTEXT_PKG_SHORT_DESCRIPTION   = GNU gettext tools $(version)
GETTEXT_PKG_URL                 = $(BUG_URL)
GETTEXT_PKG_LICENSE             = GPLv2
GETTEXT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GETTEXT_PKG_NAME)-pkg-description
GETTEXT_PKG_DESCRIPTION_FILE_IN = $(GETTEXT_PKG_NAME)-pkg-description.in
GETTEXT_PKG_INSTALL_SCRIPT      = $(GETTEXT_PKG_NAME)-pkg-install.sh

GETTEXT_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GETTEXT_PKG_NAME)-package

pkg_basename     = $(GETTEXT_PKG_NAME)-$(GETTEXT_PKG_VERSION)-$(GETTEXT_PKG_ARCH)-$(GETTEXT_PKG_DISTRO_NAME)-$(GETTEXT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GETTEXT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --enable-shared


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/gettext-tools/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GETTEXT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(GETTEXT_PKG)/usr/share/info/dir
	@gzip -9 $(GETTEXT_PKG)/usr/share/info/*
	@if [ -d $(GETTEXT_PKG)/usr/share/man ]; then \
	  ( cd $(GETTEXT_PKG)/usr/share/man ; \
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
	@mkdir -p $(GETTEXT_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/gettext-tools/ABOUT-NLS \
	       $(GETTEXT_PKG)/usr/doc/$(doc_dir_name)
	# remove toolchain path from target libtool *.la files and
	@( cd $(GETTEXT_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libgettextlib.la libgettextpo.la libgettextsrc.la  \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GETTEXT_PKG) && cp -arf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgettextlib.la libgettextpo.la libgettextsrc.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgettextlib.la libgettextpo.la libgettextsrc.la \
	 )
	@(cd $(GETTEXT_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GETTEXT_PKG_DESCRIPTION_FILE): $(GETTEXT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GETTEXT_PKG_DESCRIPTION_FILE) $(GETTEXT_PKG_INSTALL_SCRIPT)
	@cp $(GETTEXT_PKG_DESCRIPTION_FILE) $(GETTEXT_PKG)/.DESCRIPTION
	@cp $(GETTEXT_PKG_INSTALL_SCRIPT) $(GETTEXT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GETTEXT_PKG)/.REQUIRES
	@echo "pkgname=$(GETTEXT_PKG_NAME)"                            >  $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GETTEXT_PKG_VERSION)"                          >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "arch=$(GETTEXT_PKG_ARCH)"                               >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "distroname=$(GETTEXT_PKG_DISTRO_NAME)"                  >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "distrover=$(GETTEXT_PKG_DISTRO_VERSION)"                >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "group=$(GETTEXT_PKG_GROUP)"                             >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GETTEXT_PKG_SHORT_DESCRIPTION)\"" >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "url=$(GETTEXT_PKG_URL)"                                 >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "license=$(GETTEXT_PKG_LICENSE)"                         >> $(GETTEXT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GETTEXT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
