
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/udev


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
REQUIRES           = app/udev/182-x86_32
else
REQUIRES           = app/kmod/16
REQUIRES          += libs/pcre/8.34
REQUIRES          += app/util-linux/2.24.1
REQUIRES          += libs/glib2/2.40.0
REQUIRES          += app/usbutils/007
REQUIRES          += app/pciutils/3.2.1
endif

version            = 182
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/udev/udev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/udev-$(version)
src_dir_name       = udev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_udev_pkg     = $(TARGET_BUILD_DIR)/.udev_pkg_done

config_dir         = $(CURDIR)/config


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UDEV_PKG_NAME                = udev
UDEV_PKG_VERSION             = 182
UDEV_PKG_ARCH                = $(TOOLCHAIN)
UDEV_PKG_DISTRO_NAME         = kxLab
UDEV_PKG_DISTRO_VERSION      = 1.0
UDEV_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
UDEV_PKG_SHORT_DESCRIPTION   = udev $(version)
UDEV_PKG_URL                 = http://www.kxLab.com
UDEV_PKG_LICENSE             = GPLv2
UDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UDEV_PKG_NAME)-pkg-description
UDEV_PKG_DESCRIPTION_FILE_IN = $(UDEV_PKG_NAME)-pkg-description.in
UDEV_PKG_INSTALL_SCRIPT      = $(UDEV_PKG_NAME)-pkg-install.sh

UDEV_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UDEV_PKG_NAME)-package

pkg_basename     = $(UDEV_PKG_NAME)-$(UDEV_PKG_VERSION)-$(UDEV_PKG_ARCH)-$(UDEV_PKG_DISTRO_NAME)-$(UDEV_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(UDEV_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_udev_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(UDEV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --with-rootlibdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --with-rootprefix=/
extra_configure_switches += --with-firmware-path=/lib/firmware/updates:/lib/firmware
extra_configure_switches += --with-usb-ids-path=/usr/share/hwdata
extra_configure_switches += --with-pci-ids-path=/usr/share/hwdata
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --libexecdir=/lib
extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-floppy
extra_configure_switches += --enable-static
extra_configure_switches += --enable-rule_generator
extra_configure_switches += --with-systemdsystemunitdir=no


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) LIBS=-lrt ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(UDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= change mode of script in udev libexec (--libexec=/lib) directory =======
	@chmod a+x $(UDEV_PKG)/lib/udev/rule_generator.functions
	@( cd $(UDEV_PKG)/sbin ; ln -sf ../lib/udev/scsi_id scsi_id )
	@mv $(UDEV_PKG)/lib/udev/udevd $(UDEV_PKG)/sbin
	@ln -sf ../../sbin/udevd $(UDEV_PKG)/lib/udev/udevd
	@mkdir -p $(UDEV_PKG)/run \
	          $(UDEV_PKG)/{etc,lib}/modprobe.d \
	          $(UDEV_PKG)/etc/rc.d \
	          $(UDEV_PKG)/etc/udev/rules.d \
	          $(UDEV_PKG)/lib/firmware
	@cp -a $(config_dir)/udev.conf $(UDEV_PKG)/etc/udev/udev.conf
	# ======= Copy custom rules =======
	@cp -a $(config_dir)/rules.d/* $(UDEV_PKG)/lib/udev/rules.d
	# ======= Copy the init script and module-init-tools stuff =======
	@cp -a $(config_dir)/rc.d/rc.udev.new  $(UDEV_PKG)/etc/rc.d/rc.udev.new
	@cp -a $(config_dir)/modprobe.d/*.conf $(UDEV_PKG)/lib/modprobe.d
	@cp -a $(config_dir)/modprobe.d/README $(UDEV_PKG)/etc/modprobe.d
	@cp -a $(config_dir)/lib/udev/devices/MAKE-FIXED-DEVICES $(UDEV_PKG)/lib/udev/devices
	# ======= Change access mode of files and directories =======
	@find $(UDEV_PKG)/etc $(UDEV_PKG)/lib/modprobe.d -type f -exec chmod 644 {} \;
	@find $(UDEV_PKG)/etc -type d -exec chmod 755 {} \;
	@chmod 0755 $(UDEV_PKG)/etc/rc.d/rc.udev.new
	@chmod 0755 $(UDEV_PKG)/lib/udev/*
	# ======= move udev.pc file =======
	@mv $(UDEV_PKG)/usr/share/pkgconfig/udev.pc $(UDEV_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@rm -rf $(UDEV_PKG)/usr/share/pkgconfig
	@ln -sf ../lib$(LIBSUFFIX)/pkgconfig $(UDEV_PKG)/usr/share/pkgconfig
	# ======= Gzip man pages =======
	@if [ -d $(UDEV_PKG)/usr/share/man ]; then \
	  ( cd $(UDEV_PKG)/usr/share/man ; \
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
	@mkdir -p $(UDEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(UDEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(UDEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL NEWS README TODO \
	         $(UDEV_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(UDEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target destination path from target libtool *.la files =======
	@( cd $(UDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libgudev-?.?.la libudev.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(UDEV_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgudev-?.?.la libudev.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgudev-?.?.la libudev.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gudev-?.?.pc libudev.pc ; \
	  sed -i "s,/lib,$(TARGET_DEST_DIR)/lib,g" udev.pc \
	 )
	@(cd $(UDEV_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(UDEV_PKG_DESCRIPTION_FILE): $(UDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_udev_pkg): $(install_target) $(UDEV_PKG_DESCRIPTION_FILE)
	@cp $(UDEV_PKG_DESCRIPTION_FILE) $(UDEV_PKG)/.DESCRIPTION
	@cp $(UDEV_PKG_INSTALL_SCRIPT) $(UDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UDEV_PKG)/.REQUIRES
	@echo "pkgname=$(UDEV_PKG_NAME)"                            >  $(UDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UDEV_PKG_VERSION)"                          >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(UDEV_PKG_ARCH)"                               >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(UDEV_PKG_DISTRO_NAME)"                  >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(UDEV_PKG_DISTRO_VERSION)"                >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "group=$(UDEV_PKG_GROUP)"                             >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UDEV_PKG_SHORT_DESCRIPTION)\"" >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "url=$(UDEV_PKG_URL)"                                 >> $(UDEV_PKG)/.PKGINFO ; \
	 echo "license=$(UDEV_PKG_LICENSE)"                         >> $(UDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(UDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
