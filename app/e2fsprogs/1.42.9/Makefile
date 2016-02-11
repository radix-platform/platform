
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES     = sources/packages/a/e2fsprogs

REQUIRES            = app/util-linux/2.27.1

# ======= __END_OF_REQUIRES__ =======


version             = 1.42.9
tar_xz_archive      = $(SRC_PACKAGE_PATH)/packages/a/e2fsprogs/e2fsprogs-$(version).tar.xz
SRC_ARCHIVE         = $(tar_xz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/e2fsprogs-$(version)
src_dir_name        = e2fsprogs-$(version)
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
E2FSPROGS_PKG_NAME                = e2fsprogs
E2FSPROGS_PKG_VERSION             = 1.42.9
E2FSPROGS_PKG_ARCH                = $(TOOLCHAIN)
E2FSPROGS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
E2FSPROGS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
E2FSPROGS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
E2FSPROGS_PKG_SHORT_DESCRIPTION   = ext2 and ext3 filesystems utilities
E2FSPROGS_PKG_URL                 = $(BUG_URL)
E2FSPROGS_PKG_LICENSE             = GPLv2
E2FSPROGS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(E2FSPROGS_PKG_NAME)-pkg-description
E2FSPROGS_PKG_DESCRIPTION_FILE_IN = $(E2FSPROGS_PKG_NAME)-pkg-description.in
E2FSPROGS_PKG_INSTALL_SCRIPT      = $(E2FSPROGS_PKG_NAME)-pkg-install.sh

E2FSPROGS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(E2FSPROGS_PKG_NAME)-package

pkg_basename     = $(E2FSPROGS_PKG_NAME)-$(E2FSPROGS_PKG_VERSION)-$(E2FSPROGS_PKG_ARCH)-$(E2FSPROGS_PKG_DISTRO_NAME)-$(E2FSPROGS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(E2FSPROGS_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --bindir=/usr/bin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --enable-elf-shlibs
extra_configure_switches += --disable-libblkid
extra_configure_switches += --disable-libuuid
extra_configure_switches += --disable-uuidd
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=                   \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(E2FSPROGS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-libs $(env_sysroot)
	@mv $(E2FSPROGS_PKG)/etc/mke2fs.conf $(E2FSPROGS_PKG)/etc/mke2fs.conf.new
	@mkdir -p $(E2FSPROGS_PKG)/usr/lib$(LIBSUFFIX)
	@mv $(E2FSPROGS_PKG)/lib$(LIBSUFFIX)/pkgconfig \
	    $(E2FSPROGS_PKG)/lib$(LIBSUFFIX)/*.so \
	    $(E2FSPROGS_PKG)/usr/lib$(LIBSUFFIX)
	@( cd $(E2FSPROGS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for i in *.so ; do \
	     ln -sf ../../lib$(LIBSUFFIX)/`readlink $$i` $$i ; \
	   done \
	 )
	# ======= Since fsck is now part of util-linux, let's prefer that version: =======
	@if [ -r $(E2FSPROGS_PKG)/sbin/fsck ] ; then \
	   mv $(E2FSPROGS_PKG)/sbin/fsck $(E2FSPROGS_PKG)/sbin/fsck-e2fsprogs ; \
	 fi
	@if [ -r $(E2FSPROGS_PKG)/usr/share/man/man8/fsck.8 ] ; then \
	   mv $(E2FSPROGS_PKG)/usr/share/man/man8/fsck.8 $(E2FSPROGS_PKG)/usr/share/man/man8/fsck-e2fsprogs.8 ; \
	 fi
	@( cd $(E2FSPROGS_PKG)/sbin ; \
	   rm -f mkfs.ext2 mkfs.ext3 mkfs.ext4 mkfs.ext4dev fsck.ext2 fsck.ext3 fsck.ext4 fsck.ext4dev e2label ; \
	   ln -sf mke2fs mkfs.ext2 ; \
	   ln -sf mke2fs mkfs.ext3 ; \
	   ln -sf mke2fs mkfs.ext4 ; \
	   ln -sf mke2fs mkfs.ext4dev ; \
	   ln -sf tune2fs e2label ; \
	   echo '#!/bin/sh' >  fsck.ext2 ; \
	   echo ''          >> fsck.ext2 ; \
	   echo 'exec /sbin/e2fsck -C 0 $$*' >> fsck.ext2 ; \
	   chmod 0755 fsck.ext2 ; \
	   cp -a fsck.ext2 fsck.ext3  ; \
	   cp -a fsck.ext2 fsck.ext4  ; \
	   cp -a fsck.ext2 fsck.ext4dev \
	 )
	# ======= Install Documentation =======
	@( cd $(E2FSPROGS_PKG)/usr/share/man/man8 ; \
	   rm -f fsck.ext2.8 fsck.ext3.8 mkfs.ext2.8 mkfs.ext3.8 mkfs.ext4.8 mkfs.ext4dev.8 ; \
	   ln -sf e2fsck.8 fsck.ext2.8  ; \
	   ln -sf e2fsck.8 fsck.ext3.8  ; \
	   ln -sf e2fsck.8 fsck.ext4.8  ; \
	   ln -sf e2fsck.8 fsck.ext4dev.8 ; \
	   ln -sf mke2fs.8 mkfs.ext2.8  ; \
	   ln -sf mke2fs.8 mkfs.ext3.8  ; \
	   ln -sf mke2fs.8 mkfs.ext4.8  ; \
	   ln -sf mke2fs.8 mkfs.ext4dev.8 \
	 )
	@( cd $(E2FSPROGS_PKG)/usr/share/man/man5 ; \
	   sed -i "s,ext2 \- the third,ext3 \- the third,g" ext4.5 ext3.5 ext2.5 ; \
	 )
	@if [ -d $(E2FSPROGS_PKG)/usr/share/man ]; then \
	  ( cd $(E2FSPROGS_PKG)/usr/share/man ; \
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
	@mkdir -p $(E2FSPROGS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(E2FSPROGS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(E2FSPROGS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* INSTALL INSTALL.elfbin README* RELEASE-NOTES SHLIBS e2fsprogs.lsm \
	         $(E2FSPROGS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(E2FSPROGS_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" com_err.pc e2p.pc ext2fs.pc quota.pc ss.pc ; \
	   sed -i "s,^prefix=,prefix=$(TARGET_DEST_DIR),g" com_err.pc e2p.pc ext2fs.pc quota.pc ss.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(E2FSPROGS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(E2FSPROGS_PKG_DESCRIPTION_FILE): $(E2FSPROGS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(E2FSPROGS_PKG_DESCRIPTION_FILE) $(E2FSPROGS_PKG_INSTALL_SCRIPT)
	@cp $(E2FSPROGS_PKG_DESCRIPTION_FILE) $(E2FSPROGS_PKG)/.DESCRIPTION
	@cp $(E2FSPROGS_PKG_INSTALL_SCRIPT) $(E2FSPROGS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(E2FSPROGS_PKG)/.REQUIRES
	@echo "pkgname=$(E2FSPROGS_PKG_NAME)"                            >  $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(E2FSPROGS_PKG_VERSION)"                          >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "arch=$(E2FSPROGS_PKG_ARCH)"                               >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "distroname=$(E2FSPROGS_PKG_DISTRO_NAME)"                  >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "distrover=$(E2FSPROGS_PKG_DISTRO_VERSION)"                >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "group=$(E2FSPROGS_PKG_GROUP)"                             >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(E2FSPROGS_PKG_SHORT_DESCRIPTION)\"" >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "url=$(E2FSPROGS_PKG_URL)"                                 >> $(E2FSPROGS_PKG)/.PKGINFO ; \
	 echo "license=$(E2FSPROGS_PKG_LICENSE)"                         >> $(E2FSPROGS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(E2FSPROGS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
