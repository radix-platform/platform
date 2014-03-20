
COMPONENT_TARGETS  += $(TARGET_PC32)
COMPONENT_TARGETS  += $(TARGET_PC64)
COMPONENT_TARGETS  += $(TARGET_CB1X)
COMPONENT_TARGETS  += $(TARGET_VIP1830)
COMPONENT_TARGETS  += $(TARGET_BEAGLE)
COMPONENT_TARGETS  += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS  += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS  += $(TARGET_CB1N)
# COMPONENT_TARGETS  += $(TARGET_GUARD)
# COMPONENT_TARGETS  += $(TARGET_VIP1830N)
# COMPONENT_TARGETS  += $(TARGET_L17UC)
#


NEED_ABS_PATH       = true

COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/GNU/diffutils


REQUIRES           += libs/eglibc/2.18.1


version             = 3.3
tar_xz_archive      = $(SRC_PACKAGE_PATH)/GNU/diffutils/diffutils-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/diffutils-$(version)
src_dir_name        = diffutils-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_diffutils_pkg = $(TARGET_BUILD_DIR)/.diffutils_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DIFFUTILS_PKG_NAME                = diffutils
DIFFUTILS_PKG_VERSION             = 3.3
DIFFUTILS_PKG_ARCH                = $(TOOLCHAIN)
DIFFUTILS_PKG_DISTRO_NAME         = kxLab
DIFFUTILS_PKG_DISTRO_VERSION      = 1.0
DIFFUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
DIFFUTILS_PKG_SHORT_DESCRIPTION   = diffutils $(version)
DIFFUTILS_PKG_URL                 = http://www.kxLab.com
DIFFUTILS_PKG_LICENSE             = GPLv2
DIFFUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DIFFUTILS_PKG_NAME)-pkg-description
DIFFUTILS_PKG_DESCRIPTION_FILE_IN = $(DIFFUTILS_PKG_NAME)-pkg-description.in
DIFFUTILS_PKG_INSTALL_SCRIPT      = $(DIFFUTILS_PKG_NAME)-pkg-install.sh

DIFFUTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DIFFUTILS_PKG_NAME)-package

pkg_basename     = $(DIFFUTILS_PKG_NAME)-$(DIFFUTILS_PKG_VERSION)-$(DIFFUTILS_PKG_ARCH)-$(DIFFUTILS_PKG_DISTRO_NAME)-$(DIFFUTILS_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(DIFFUTILS_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_diffutils_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DIFFUTILS_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --disable-rpath
extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# prevent regeneration of this man page
	@touch $(SRC_DIR)/man/sdiff.1
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
	@mkdir -p $(DIFFUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@rm -f $(DIFFUTILS_PKG)/usr/share/info/dir
	@gzip -9 $(DIFFUTILS_PKG)/usr/share/info/*
	@if [ -d $(DIFFUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(DIFFUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(DIFFUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DIFFUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DIFFUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL NEWS README* THANKS TODO \
	         $(DIFFUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DIFFUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(DIFFUTILS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(DIFFUTILS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DIFFUTILS_PKG_DESCRIPTION_FILE): $(DIFFUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_diffutils_pkg): $(install_target) $(DIFFUTILS_PKG_DESCRIPTION_FILE)
	@cp $(DIFFUTILS_PKG_DESCRIPTION_FILE) $(DIFFUTILS_PKG)/.DESCRIPTION
	@cp $(DIFFUTILS_PKG_INSTALL_SCRIPT) $(DIFFUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DIFFUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(DIFFUTILS_PKG_NAME)"                            >  $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DIFFUTILS_PKG_VERSION)"                          >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(DIFFUTILS_PKG_ARCH)"                               >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(DIFFUTILS_PKG_DISTRO_NAME)"                  >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(DIFFUTILS_PKG_DISTRO_VERSION)"                >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(DIFFUTILS_PKG_GROUP)"                             >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DIFFUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(DIFFUTILS_PKG_URL)"                                 >> $(DIFFUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(DIFFUTILS_PKG_LICENSE)"                         >> $(DIFFUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DIFFUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
