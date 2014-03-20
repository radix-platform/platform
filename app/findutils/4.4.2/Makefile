
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


SOURCE_REQUIRES     = $(SRC_PACKAGE_DIR)/GNU/findutils


REQUIRES           += libs/eglibc/2.18.1


version             = 4.4.2
tar_gz_archive      = $(SRC_PACKAGE_PATH)/GNU/findutils/findutils-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/findutils-$(version)
src_dir_name        = findutils-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done
build_findutils_pkg = $(TARGET_BUILD_DIR)/.findutils_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FINDUTILS_PKG_NAME                = findutils
FINDUTILS_PKG_VERSION             = 4.4.2
FINDUTILS_PKG_ARCH                = $(TOOLCHAIN)
FINDUTILS_PKG_DISTRO_NAME         = kxLab
FINDUTILS_PKG_DISTRO_VERSION      = 1.0
FINDUTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
FINDUTILS_PKG_SHORT_DESCRIPTION   = findutils $(version)
FINDUTILS_PKG_URL                 = http://www.kxLab.com
FINDUTILS_PKG_LICENSE             = GPLv2
FINDUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FINDUTILS_PKG_NAME)-pkg-description
FINDUTILS_PKG_DESCRIPTION_FILE_IN = $(FINDUTILS_PKG_NAME)-pkg-description.in
FINDUTILS_PKG_INSTALL_SCRIPT      = $(FINDUTILS_PKG_NAME)-pkg-install.sh

FINDUTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FINDUTILS_PKG_NAME)-package

pkg_basename     = $(FINDUTILS_PKG_NAME)-$(FINDUTILS_PKG_VERSION)-$(FINDUTILS_PKG_ARCH)-$(FINDUTILS_PKG_DISTRO_NAME)-$(FINDUTILS_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(FINDUTILS_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_findutils_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FINDUTILS_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --disable-rpath
extra_configure_switches += --disable-locate
extra_configure_switches += --without-fts

# http://savannah.gnu.org/bugs/?27299
extra_configure_switches += gl_cv_func_wcwidth_works=yes


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
	@mkdir -p $(FINDUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@rm -f $(FINDUTILS_PKG)/usr/share/info/dir
	@gzip -9 $(FINDUTILS_PKG)/usr/share/info/*
	@if [ -d $(FINDUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(FINDUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(FINDUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(FINDUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FINDUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* NEWS README* THANKS TODO \
	         $(FINDUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FINDUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(FINDUTILS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(FINDUTILS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(FINDUTILS_PKG_DESCRIPTION_FILE): $(FINDUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_findutils_pkg): $(install_target) $(FINDUTILS_PKG_DESCRIPTION_FILE)
	@cp $(FINDUTILS_PKG_DESCRIPTION_FILE) $(FINDUTILS_PKG)/.DESCRIPTION
	@cp $(FINDUTILS_PKG_INSTALL_SCRIPT) $(FINDUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FINDUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(FINDUTILS_PKG_NAME)"                            >  $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FINDUTILS_PKG_VERSION)"                          >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(FINDUTILS_PKG_ARCH)"                               >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(FINDUTILS_PKG_DISTRO_NAME)"                  >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(FINDUTILS_PKG_DISTRO_VERSION)"                >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(FINDUTILS_PKG_GROUP)"                             >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FINDUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(FINDUTILS_PKG_URL)"                                 >> $(FINDUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(FINDUTILS_PKG_LICENSE)"                         >> $(FINDUTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FINDUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
