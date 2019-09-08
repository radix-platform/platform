
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/lilo

ifeq ($(HARDWARE),$(HARDWARE_PC32))
REQUIRES           = boot/kernel/x86_32/4.9.35
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = boot/kernel/x86_64/4.9.35
endif
REQUIRES          += app/lvm2/2.02.141

# ======= __END_OF_REQUIRES__ =======


version            = 24.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/lilo/lilo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lilo-$(version)
src_dir_name       = lilo-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

pixmaps            = $(CURDIR)/pixmaps
radix_bmp          = $(pixmaps)/radix-256-v1.0.bmp
radix_dat          = $(pixmaps)/radix-256-v1.0.dat

scripts            = $(CURDIR)/scripts

boot_records         = $(TARGET_BUILD_DIR)/$(HARDWARE).boot-records
install_boot_records = $(TARGET_BUILD_DIR)/.boot_records_done


####### Targets

PKG_GROUP = boot

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LILO_PKG_NAME                = lilo
LILO_PKG_VERSION             = 24.1
LILO_PKG_ARCH                = $(TOOLCHAIN)
LILO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LILO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LILO_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
LILO_PKG_SHORT_DESCRIPTION   = Linux Loader
LILO_PKG_URL                 = $(BUG_URL)
LILO_PKG_LICENSE             = custom
LILO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LILO_PKG_NAME)-pkg-description
LILO_PKG_DESCRIPTION_FILE_IN = $(LILO_PKG_NAME)-pkg-description.in
LILO_PKG_INSTALL_SCRIPT      = $(LILO_PKG_NAME)-pkg-install.sh

LILO_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LILO_PKG_NAME)-package

pkg_basename     = $(LILO_PKG_NAME)-$(LILO_PKG_VERSION)-$(LILO_PKG_ARCH)-$(LILO_PKG_DISTRO_NAME)-$(LILO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(install_boot_records)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LILO_PKG)


environment  = CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
environment += OPT="$(CFLAGS)"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(MAKE) $(environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LILO_PKG)
	@cd $(SRC_DIR) && $(MAKE) -j1 install $(env_sysroot)
	# ======= Remove intrusive debian stuff =======
	@( cd $(LILO_PKG)/boot ; \
	   rm -f *.bmp *.dat ; \
	 )
	@rm -r $(LILO_PKG)/etc/{initramfs,kernel}
	# ======= Install 256 color bitmap =======
	@cp -a $(radix_bmp) $(LILO_PKG)/boot/radix.bmp
	@cp -a $(radix_dat) $(LILO_PKG)/boot/radix.dat
	# ======= Replace liloconfig =======
	@mkdir -p $(LILO_PKG)/sbin
	@rm -f $(LILO_PKG)/usr/sbin/liloconfig $(LILO_PKG)/usr/share/man/man8/liloconfig.8
	@cp -a $(scripts)/liloconfig $(LILO_PKG)/sbin
	@chmod 0755 $(LILO_PKG)/sbin/liloconfig
	# ======= Install Documentation =======
	@if [ -d $(LILO_PKG)/usr/share/man ]; then \
	  ( cd $(LILO_PKG)/usr/share/man ; \
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
	@mkdir -p $(LILO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LILO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LILO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGELOG COPYING NEWS README TODO TOOLS lilo.lsm doc/html \
	         $(LILO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG_old ]; then \
	     DOCSDIR=`echo $(LILO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG_old | head -n 1000 > $$DOCSDIR/CHANGELOG_old ; \
	     touch -r CHANGELOG_old $$DOCSDIR/CHANGELOG_old ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LILO_PKG))
	@touch $@

$(boot_records): $(install_target)
	@$(DD) if=/dev/zero of=$@ bs=512 count=2048 conv=notrunc
	# ======= Setup empty boot-records because x86 platform uses BIOS for boot =======
	@touch $@

$(install_boot_records): $(boot_records)
	@$(BUILDSYSTEM)/install_targets         \
	   --destination=$(PRODUCTS_DEST_DIR)   \
	   --toolchain=$(TOOLCHAIN)             \
	   --hardware=$(HARDWARE)               \
	   --flavour=$(FLAVOUR)                 \
	   $^
	@touch $@

$(LILO_PKG_DESCRIPTION_FILE): $(LILO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_boot_records) $(LILO_PKG_DESCRIPTION_FILE) $(LILO_PKG_INSTALL_SCRIPT)
	@cp $(LILO_PKG_DESCRIPTION_FILE) $(LILO_PKG)/.DESCRIPTION
	@cp $(LILO_PKG_INSTALL_SCRIPT) $(LILO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LILO_PKG)/.REQUIRES
	@echo "pkgname=$(LILO_PKG_NAME)"                            >  $(LILO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LILO_PKG_VERSION)"                          >> $(LILO_PKG)/.PKGINFO ; \
	 echo "arch=$(LILO_PKG_ARCH)"                               >> $(LILO_PKG)/.PKGINFO ; \
	 echo "distroname=$(LILO_PKG_DISTRO_NAME)"                  >> $(LILO_PKG)/.PKGINFO ; \
	 echo "distrover=$(LILO_PKG_DISTRO_VERSION)"                >> $(LILO_PKG)/.PKGINFO ; \
	 echo "group=$(LILO_PKG_GROUP)"                             >> $(LILO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LILO_PKG_SHORT_DESCRIPTION)\"" >> $(LILO_PKG)/.PKGINFO ; \
	 echo "url=$(LILO_PKG_URL)"                                 >> $(LILO_PKG)/.PKGINFO ; \
	 echo "license=$(LILO_PKG_LICENSE)"                         >> $(LILO_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LILO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
