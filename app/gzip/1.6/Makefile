
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


SOURCE_REQUIRES    = sources/GNU/gzip

REQUIRES           = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version            = 1.6
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/gzip/gzip-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gzip-$(version)
src_dir_name       = gzip-$(version)
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
GZIP_PKG_NAME                = gzip
GZIP_PKG_VERSION             = 1.6
GZIP_PKG_ARCH                = $(TOOLCHAIN)
GZIP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GZIP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GZIP_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
GZIP_PKG_SHORT_DESCRIPTION   = file compression utility
GZIP_PKG_URL                 = $(BUG_URL)
GZIP_PKG_LICENSE             = GPLv2
GZIP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GZIP_PKG_NAME)-pkg-description
GZIP_PKG_DESCRIPTION_FILE_IN = $(GZIP_PKG_NAME)-pkg-description.in
GZIP_PKG_INSTALL_SCRIPT      = $(GZIP_PKG_NAME)-pkg-install.sh

GZIP_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GZIP_PKG_NAME)-package

pkg_basename     = $(GZIP_PKG_NAME)-$(GZIP_PKG_VERSION)-$(GZIP_PKG_ARCH)-$(GZIP_PKG_DISTRO_NAME)-$(GZIP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GZIP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --bindir=/bin
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info


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
	@mkdir -p $(GZIP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@rm -f $(GZIP_PKG)/usr/share/info/dir
	@gzip -9 $(GZIP_PKG)/usr/share/info/*
	# ======= Uncomment next line if you will use 'uncompress' from ncommpress package =======
	@rm -f $(GZIP_PKG)/bin/uncompress
	@mkdir -p $(GZIP_PKG)/usr/bin
	@( cd $(GZIP_PKG)/bin ; \
	   for file in * ; do \
	     ( cd $(GZIP_PKG)/usr/bin ; ln -sf ../../bin/$$file . ) \
	   done \
	 )
	@( cd $(GZIP_PKG)/usr/share/man/man1 ; \
	   rm -f gunzip.1 zcat.1 zcmp.1 ; \
	   ln -sf gzip.1 gunzip.1 ; \
	   ln -sf gzip.1 zcat.1 ; \
	   ln -sf zdiff.1 zcmp.1 \
	 )
	@if [ -d $(GZIP_PKG)/usr/share/man ]; then \
	  ( cd $(GZIP_PKG)/usr/share/man ; \
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
	@mkdir -p $(GZIP_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	       $(GZIP_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(GZIP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* THANKS TODO \
	       $(GZIP_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GZIP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GZIP_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(GZIP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GZIP_PKG_DESCRIPTION_FILE): $(GZIP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GZIP_PKG_DESCRIPTION_FILE) $(GZIP_PKG_INSTALL_SCRIPT)
	@cp $(GZIP_PKG_DESCRIPTION_FILE) $(GZIP_PKG)/.DESCRIPTION
	@cp $(GZIP_PKG_INSTALL_SCRIPT) $(GZIP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GZIP_PKG)/.REQUIRES
	@echo "pkgname=$(GZIP_PKG_NAME)"                            >  $(GZIP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GZIP_PKG_VERSION)"                          >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "arch=$(GZIP_PKG_ARCH)"                               >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "distroname=$(GZIP_PKG_DISTRO_NAME)"                  >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "distrover=$(GZIP_PKG_DISTRO_VERSION)"                >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "group=$(GZIP_PKG_GROUP)"                             >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GZIP_PKG_SHORT_DESCRIPTION)\"" >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "url=$(GZIP_PKG_URL)"                                 >> $(GZIP_PKG)/.PKGINFO ; \
	 echo "license=$(GZIP_PKG_LICENSE)"                         >> $(GZIP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GZIP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
