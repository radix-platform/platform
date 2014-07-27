
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH       = true
COMPONENT_IS_3PP    = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/reiserfsprogs

REQUIRES            = app/util-linux/2.24.1


version             = 3.6.24
tar_xz_archive      = $(SRC_PACKAGE_PATH)/packages/a/reiserfsprogs/reiserfsprogs-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/reiserfsprogs-$(version)
src_dir_name        = reiserfsprogs-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
REISERFS_PKG_NAME                = reiserfsprogs
REISERFS_PKG_VERSION             = 3.6.24
REISERFS_PKG_ARCH                = $(TOOLCHAIN)
REISERFS_PKG_DISTRO_NAME         = kxLab
REISERFS_PKG_DISTRO_VERSION      = 1.0
REISERFS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
REISERFS_PKG_SHORT_DESCRIPTION   = reiserfsprogs $(version)
REISERFS_PKG_URL                 = $(BUG_URL)
REISERFS_PKG_LICENSE             = GPLv2
REISERFS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(REISERFS_PKG_NAME)-pkg-description
REISERFS_PKG_DESCRIPTION_FILE_IN = $(REISERFS_PKG_NAME)-pkg-description.in
REISERFS_PKG_INSTALL_SCRIPT      = $(REISERFS_PKG_NAME)-pkg-install.sh

REISERFS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(REISERFS_PKG_NAME)-package

pkg_basename     = $(REISERFS_PKG_NAME)-$(REISERFS_PKG_VERSION)-$(REISERFS_PKG_ARCH)-$(REISERFS_PKG_DISTRO_NAME)-$(REISERFS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(REISERFS_PKG)

extra_configure_switches  = --sbindir=/sbin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(REISERFS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(REISERFS_PKG)/usr/share/man/man8 ; \
	   ln -sf resize_reiserfs.8 resizefs.reiserfs.8 \
	 )
	@if [ -d $(REISERFS_PKG)/usr/share/man ]; then \
	  ( cd $(REISERFS_PKG)/usr/share/man ; \
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
	@mkdir -p $(REISERFS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(REISERFS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(REISERFS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING CREDITS INSTALL NEWS README \
	         $(REISERFS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(REISERFS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(REISERFS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	@(cd $(REISERFS_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(REISERFS_PKG_DESCRIPTION_FILE): $(REISERFS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(REISERFS_PKG_DESCRIPTION_FILE) $(REISERFS_PKG_INSTALL_SCRIPT)
	@cp $(REISERFS_PKG_DESCRIPTION_FILE) $(REISERFS_PKG)/.DESCRIPTION
	@cp $(REISERFS_PKG_INSTALL_SCRIPT) $(REISERFS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(REISERFS_PKG)/.REQUIRES
	@echo "pkgname=$(REISERFS_PKG_NAME)"                            >  $(REISERFS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(REISERFS_PKG_VERSION)"                          >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "arch=$(REISERFS_PKG_ARCH)"                               >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "distroname=$(REISERFS_PKG_DISTRO_NAME)"                  >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "distrover=$(REISERFS_PKG_DISTRO_VERSION)"                >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "group=$(REISERFS_PKG_GROUP)"                             >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(REISERFS_PKG_SHORT_DESCRIPTION)\"" >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "url=$(REISERFS_PKG_URL)"                                 >> $(REISERFS_PKG)/.PKGINFO ; \
	 echo "license=$(REISERFS_PKG_LICENSE)"                         >> $(REISERFS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(REISERFS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
