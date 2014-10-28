
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


SOURCE_REQUIRES    = sources/GNU/autoconf-archive

REQUIRES           = app/bash/4.3
REQUIRES          += dev/m4/1.4.17
REQUIRES          += dev/automake/1.14


version            = 2014.02.28
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/autoconf-archive/autoconf-archive-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/autoconf-archive-$(version)
src_dir_name       = autoconf-archive-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AC_ARCHIVE_PKG_NAME                = autoconf-archive
AC_ARCHIVE_PKG_VERSION             = 2014.02.28
AC_ARCHIVE_PKG_ARCH                = $(TOOLCHAIN)
AC_ARCHIVE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AC_ARCHIVE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AC_ARCHIVE_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
AC_ARCHIVE_PKG_SHORT_DESCRIPTION   = macros for GNU Autoconf
AC_ARCHIVE_PKG_URL                 = $(BUG_URL)
AC_ARCHIVE_PKG_LICENSE             = GPLv3
AC_ARCHIVE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AC_ARCHIVE_PKG_NAME)-pkg-description
AC_ARCHIVE_PKG_DESCRIPTION_FILE_IN = $(AC_ARCHIVE_PKG_NAME)-pkg-description.in
AC_ARCHIVE_PKG_INSTALL_SCRIPT      = $(AC_ARCHIVE_PKG_NAME)-pkg-install.sh

AC_ARCHIVE_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AC_ARCHIVE_PKG_NAME)-package

pkg_basename     = $(AC_ARCHIVE_PKG_NAME)-$(AC_ARCHIVE_PKG_VERSION)-$(AC_ARCHIVE_PKG_ARCH)-$(AC_ARCHIVE_PKG_DISTRO_NAME)-$(AC_ARCHIVE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AC_ARCHIVE_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man


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
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AC_ARCHIVE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(AC_ARCHIVE_PKG)/usr/share ; rm -rf autoconf-archive )
	@rm -f $(AC_ARCHIVE_PKG)/usr/share/info/dir
	@gzip -9 $(AC_ARCHIVE_PKG)/usr/share/info/*
	@if [ -d $(AC_ARCHIVE_PKG)/usr/share/man ]; then \
	  ( cd $(AC_ARCHIVE_PKG)/usr/share/man ; \
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
	@mkdir -p $(AC_ARCHIVE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(AC_ARCHIVE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(AC_ARCHIVE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README TODO \
	         $(AC_ARCHIVE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AC_ARCHIVE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(AC_ARCHIVE_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@touch $@

$(AC_ARCHIVE_PKG_DESCRIPTION_FILE): $(AC_ARCHIVE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AC_ARCHIVE_PKG_DESCRIPTION_FILE) $(AC_ARCHIVE_PKG_INSTALL_SCRIPT)
	@cp $(AC_ARCHIVE_PKG_DESCRIPTION_FILE) $(AC_ARCHIVE_PKG)/.DESCRIPTION
	@cp $(AC_ARCHIVE_PKG_INSTALL_SCRIPT) $(AC_ARCHIVE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AC_ARCHIVE_PKG)/.REQUIRES
	@echo "pkgname=$(AC_ARCHIVE_PKG_NAME)"                            >  $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AC_ARCHIVE_PKG_VERSION)"                          >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "arch=$(AC_ARCHIVE_PKG_ARCH)"                               >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "distroname=$(AC_ARCHIVE_PKG_DISTRO_NAME)"                  >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "distrover=$(AC_ARCHIVE_PKG_DISTRO_VERSION)"                >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "group=$(AC_ARCHIVE_PKG_GROUP)"                             >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AC_ARCHIVE_PKG_SHORT_DESCRIPTION)\"" >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "url=$(AC_ARCHIVE_PKG_URL)"                                 >> $(AC_ARCHIVE_PKG)/.PKGINFO ; \
	 echo "license=$(AC_ARCHIVE_PKG_LICENSE)"                         >> $(AC_ARCHIVE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AC_ARCHIVE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
