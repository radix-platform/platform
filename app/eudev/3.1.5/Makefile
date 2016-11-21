
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/eudev

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/eudev/3.1.5
else
REQUIRES           = libs/eudev/3.1.5-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.1.5
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/eudev/eudev-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/eudev-$(version)
src_dir_name       = eudev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

config_dir         = $(CURDIR)/config


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EUDEV_PKG_NAME                = eudev
EUDEV_PKG_VERSION             = 3.1.5
EUDEV_PKG_ARCH                = $(TOOLCHAIN)
EUDEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EUDEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EUDEV_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
EUDEV_PKG_SHORT_DESCRIPTION   = dynamic device directory system
EUDEV_PKG_URL                 = $(BUG_URL)
EUDEV_PKG_LICENSE             = GPLv2
EUDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EUDEV_PKG_NAME)-pkg-description
EUDEV_PKG_DESCRIPTION_FILE_IN = $(EUDEV_PKG_NAME)-pkg-description.in
EUDEV_PKG_INSTALL_SCRIPT      = $(EUDEV_PKG_NAME)-pkg-install.sh

EUDEV_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EUDEV_PKG_NAME)-package

pkg_basename     = $(EUDEV_PKG_NAME)-$(EUDEV_PKG_VERSION)-$(EUDEV_PKG_ARCH)-$(EUDEV_PKG_DISTRO_NAME)-$(EUDEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(EUDEV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --with-rootprefix=/
extra_configure_switches += --with-rootlibdir=/lib$(LIBSUFFIX)
extra_configure_switches += --with-rootlibexecdir=/lib/udev
extra_configure_switches += --with-rootrundir=/run

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --libexecdir=/lib

extra_configure_switches += --with-usb-ids-path=/usr/share/hwdata
extra_configure_switches += --with-pci-ids-path=/usr/share/hwdata

extra_configure_switches += --enable-hwdb
extra_configure_switches += --enable-rule-generator
extra_configure_switches += --enable-split-usr
extra_configure_switches += --enable-kmod
extra_configure_switches += --enable-manpages
extra_configure_switches += --disable-selinux

extra_configure_switches += --enable-static
extra_configure_switches += --with-gnu-ld


LDFLAGS += -Wl,-rpath,/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)

TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   ./autogen.sh ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(EUDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(EUDEV_PKG)/usr/sbin
	mv $(EUDEV_PKG)/sbin/update-udev-ids.pl $(EUDEV_PKG)/usr/sbin/update-udev-ids.pl
	@( cd $(EUDEV_PKG)/usr/sbin ; ln -sf update-udev-ids.pl update-udev-ids )
	@( cd $(EUDEV_PKG)/sbin ; ln -sf ../usr/sbin/update-udev-ids . )
	# ======= remove libraries installed by libs/eudev package ======
	@rm -rf $(EUDEV_PKG)/lib$(LIBSUFFIX)/libudev.*
	@rm -rf $(EUDEV_PKG)/usr/lib$(LIBSUFFIX)
	@rm -rf $(EUDEV_PKG)/usr/include
	# ======= change mode of script in udev libexec (--libexec=/lib) directory =======
	@chmod a+x $(EUDEV_PKG)/lib/udev/rule_generator.functions
	@( cd $(EUDEV_PKG)/sbin ; ln -sf ../lib/udev/scsi_id scsi_id )
	# ======= Move system installed hwdb files under /lib =======
	@mkdir -p $(EUDEV_PKG)/lib/udev/hwdb.d
	@mv $(EUDEV_PKG)/etc/udev/hwdb.d/* $(EUDEV_PKG)/lib/udev/hwdb.d
	@ln -sf ../../sbin/udevd $(EUDEV_PKG)/lib/udev/udevd
	@mkdir -p $(EUDEV_PKG)/run \
	          $(EUDEV_PKG)/{etc,lib}/modprobe.d \
	          $(EUDEV_PKG)/etc/rc.d \
	          $(EUDEV_PKG)/etc/udev/rules.d \
	          $(EUDEV_PKG)/lib/firmware
	@cp -a $(config_dir)/udev.conf $(EUDEV_PKG)/etc/udev/udev.conf
	# ======= Copy custom rules =======
	@cp -a $(config_dir)/rules.d/* $(EUDEV_PKG)/lib/udev/rules.d
	# ======= Copy the init script and module-init-tools stuff =======
	@cp -a $(config_dir)/rc.d/rc.udev.new  $(EUDEV_PKG)/etc/rc.d/rc.udev.new
	@cp -a $(config_dir)/modprobe.d/*.conf $(EUDEV_PKG)/lib/modprobe.d
	@cp -a $(config_dir)/modprobe.d/README $(EUDEV_PKG)/etc/modprobe.d
	# ======= Change access mode of files and directories =======
	@find $(EUDEV_PKG)/etc $(EUDEV_PKG)/lib/modprobe.d -type f -exec chmod 644 {} \;
	@find $(EUDEV_PKG)/etc -type d -exec chmod 755 {} \;
	@chmod 0755 $(EUDEV_PKG)/etc/rc.d/rc.udev.new
	@chmod 0755 $(EUDEV_PKG)/lib/udev/*
	# ======= Add extra device directory to the package that udev doesn't make =======
	@mkdir -p $(EUDEV_PKG)/lib/udev/devices
	# ======= Support locally added additional devices found in this directory =======
	@mkdir -p $(EUDEV_PKG)/etc/udev/devices
	# ======= Gzip man pages =======
	@if [ -d $(EUDEV_PKG)/usr/share/man ]; then \
	  ( cd $(EUDEV_PKG)/usr/share/man ; \
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
	@mkdir -p $(EUDEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(EUDEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(EUDEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(EUDEV_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(EUDEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EUDEV_PKG))
	# ======= tune pkg-config *.pc in /usr/share/pkgconfig/udev.pc file =======
	# ======= but do not touch udevdir variable                         =======
	@( cd $(TARGET_DEST_DIR)/usr/share/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" udev.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(EUDEV_PKG)/sbin ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(EUDEV_PKG)/sbin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(EUDEV_PKG_DESCRIPTION_FILE): $(EUDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EUDEV_PKG_DESCRIPTION_FILE) $(EUDEV_PKG_INSTALL_SCRIPT)
	@cp $(EUDEV_PKG_DESCRIPTION_FILE) $(EUDEV_PKG)/.DESCRIPTION
	@cp $(EUDEV_PKG_INSTALL_SCRIPT) $(EUDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EUDEV_PKG)/.REQUIRES
	@echo "pkgname=$(EUDEV_PKG_NAME)"                            >  $(EUDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EUDEV_PKG_VERSION)"                          >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(EUDEV_PKG_ARCH)"                               >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(EUDEV_PKG_DISTRO_NAME)"                  >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(EUDEV_PKG_DISTRO_VERSION)"                >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "group=$(EUDEV_PKG_GROUP)"                             >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EUDEV_PKG_SHORT_DESCRIPTION)\"" >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "url=$(EUDEV_PKG_URL)"                                 >> $(EUDEV_PKG)/.PKGINFO ; \
	 echo "license=$(EUDEV_PKG_LICENSE)"                         >> $(EUDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EUDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
