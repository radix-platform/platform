
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/bluez

REQUIRES           = app/eudev/3.1.5
REQUIRES          += app/dbus/1.11.2
REQUIRES          += libs/glib2/2.48.0
REQUIRES          += libs/libical/2.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 5.42
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/bluez/bluez-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bluez-$(version)
src_dir_name       = bluez-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


uart_config        = $(CURDIR)/etc/bluetooth/uart.conf
default_config     = $(CURDIR)/etc/default/bluetooth
rc_bluetooth       = $(CURDIR)/etc/rc.d/rc.bluetooth
usb_modprobe       = $(CURDIR)/lib/modprobe.d/btusb.conf


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BLUEZ_PKG_NAME                = bluez
BLUEZ_PKG_VERSION             = 5.42
BLUEZ_PKG_ARCH                = $(TOOLCHAIN)
BLUEZ_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BLUEZ_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BLUEZ_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
BLUEZ_PKG_SHORT_DESCRIPTION   = Bluetooth libraries and utilities
BLUEZ_PKG_URL                 = $(BUG_URL)
BLUEZ_PKG_LICENSE             = GPLv2
BLUEZ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BLUEZ_PKG_NAME)-pkg-description
BLUEZ_PKG_DESCRIPTION_FILE_IN = $(BLUEZ_PKG_NAME)-pkg-description.in
BLUEZ_PKG_INSTALL_SCRIPT      = $(BLUEZ_PKG_NAME)-pkg-install.sh

BLUEZ_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BLUEZ_PKG_NAME)-package

pkg_basename     = $(BLUEZ_PKG_NAME)-$(BLUEZ_PKG_VERSION)-$(BLUEZ_PKG_ARCH)-$(BLUEZ_PKG_DISTRO_NAME)-$(BLUEZ_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BLUEZ_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

#
# NOTE: we have to overwrite variables from DevEnv dbus-1.pc
#
extra_configure_switches += --with-dbusconfdir=/etc
extra_configure_switches += --with-dbussessionbusdir=/usr/share/dbus-1/services
extra_configure_switches += --with-dbussystembusdir=/usr/share/dbus-1/system-services

extra_configure_switches += --disable-systemd

extra_configure_switches += --enable-sixaxis
extra_configure_switches += --enable-experimental
extra_configure_switches += --enable-library

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC))
extra_environment  = LIBS="-lrt -lpthread -lm -lstdc++"
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -vif ; \
	   sed -i -e 's|-lreadline|\0 -lncursesw|g' Makefile.{in,tools} ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(extra_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BLUEZ_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install system scripts =======
	@mkdir -p $(BLUEZ_PKG)/lib/modprobe.d
	@cp -a $(usb_modprobe) $(BLUEZ_PKG)/lib/modprobe.d/btusb.conf
	@chmod 644 $(BLUEZ_PKG)/lib/modprobe.d/btusb.conf
	@mkdir -p $(BLUEZ_PKG)/etc/bluetooth
	@cp -a $(uart_config) $(BLUEZ_PKG)/etc/bluetooth/uart.conf.new
	@mkdir -p $(BLUEZ_PKG)/etc/default
	@cp -a $(default_config) $(BLUEZ_PKG)/etc/default/bluetooth.new
	@mkdir -p $(BLUEZ_PKG)/etc/rc.d
	@cp -a $(rc_bluetooth) $(BLUEZ_PKG)/etc/rc.d/rc.bluetooth.new
	@chmod 755 $(BLUEZ_PKG)/etc/rc.d/rc.bluetooth.new
	@( cd $(SRC_DIR) ; \
	   cat src/main.conf                     > $(BLUEZ_PKG)/etc/bluetooth/main.conf.new      ; \
	   cat profiles/input/input.conf         > $(BLUEZ_PKG)/etc/bluetooth/input.conf.new     ; \
	   cat profiles/network/network.conf     > $(BLUEZ_PKG)/etc/bluetooth/network.conf.new   ; \
	   cat profiles/proximity/proximity.conf > $(BLUEZ_PKG)/etc/bluetooth/proximity.conf.new ; \
	 )
	@mv $(BLUEZ_PKG)/etc/dbus-1/system.d/bluetooth.conf $(BLUEZ_PKG)/etc/dbus-1/system.d/bluetooth.conf.new
	# ======= Add bluetoothd symlink to /usr/sbin =======
	@mkdir -p $(BLUEZ_PKG)/usr/sbin
	@ln -sf ../libexec/bluetooth/bluetoothd $(BLUEZ_PKG)/usr/sbin
	# ======= Install Documentation =======
	@if [ -d $(BLUEZ_PKG)/usr/share/man ]; then \
	  ( cd $(BLUEZ_PKG)/usr/share/man ; \
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
	@mkdir -p $(BLUEZ_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(BLUEZ_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BLUEZ_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL README TODO \
	         $(BLUEZ_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BLUEZ_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(BLUEZ_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libbluetooth.la ; \
	 )
	@( cd $(BLUEZ_PKG)/usr/lib$(LIBSUFFIX)/bluetooth/plugins ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" sixaxis.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BLUEZ_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libbluetooth.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libbluetooth.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/bluetooth/plugins ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sixaxis.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" sixaxis.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" bluez.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(BLUEZ_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(BLUEZ_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(BLUEZ_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(BLUEZ_PKG_DESCRIPTION_FILE): $(BLUEZ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BLUEZ_PKG_DESCRIPTION_FILE) $(BLUEZ_PKG_INSTALL_SCRIPT)
	@cp $(BLUEZ_PKG_DESCRIPTION_FILE) $(BLUEZ_PKG)/.DESCRIPTION
	@cp $(BLUEZ_PKG_INSTALL_SCRIPT) $(BLUEZ_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BLUEZ_PKG)/.REQUIRES
	@echo "pkgname=$(BLUEZ_PKG_NAME)"                            >  $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BLUEZ_PKG_VERSION)"                          >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "arch=$(BLUEZ_PKG_ARCH)"                               >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "distroname=$(BLUEZ_PKG_DISTRO_NAME)"                  >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "distrover=$(BLUEZ_PKG_DISTRO_VERSION)"                >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "group=$(BLUEZ_PKG_GROUP)"                             >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BLUEZ_PKG_SHORT_DESCRIPTION)\"" >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "url=$(BLUEZ_PKG_URL)"                                 >> $(BLUEZ_PKG)/.PKGINFO ; \
	 echo "license=$(BLUEZ_PKG_LICENSE)"                         >> $(BLUEZ_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(BLUEZ_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
