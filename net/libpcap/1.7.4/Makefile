
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
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


SOURCE_REQUIRES    = sources/packages/n/libpcap

REQUIRES           = libs/libusb/1.0.20
REQUIRES          += net/libnl3/3.2.27
REQUIRES          += app/dbus/1.11.2
REQUIRES          += net/bluez/5.42

# ======= __END_OF_REQUIRES__ =======


version            = 1.7.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/libpcap/libpcap-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libpcap-$(version)
src_dir_name       = libpcap-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBPCAP_PKG_NAME                = libpcap
LIBPCAP_PKG_VERSION             = 1.7.4
LIBPCAP_PKG_ARCH                = $(TOOLCHAIN)
LIBPCAP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBPCAP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBPCAP_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBPCAP_PKG_SHORT_DESCRIPTION   = packet capture library
LIBPCAP_PKG_URL                 = $(BUG_URL)
LIBPCAP_PKG_LICENSE             = BSD
LIBPCAP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBPCAP_PKG_NAME)-pkg-description
LIBPCAP_PKG_DESCRIPTION_FILE_IN = $(LIBPCAP_PKG_NAME)-pkg-description.in
LIBPCAP_PKG_INSTALL_SCRIPT      = $(LIBPCAP_PKG_NAME)-pkg-install.sh

LIBPCAP_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBPCAP_PKG_NAME)-package

pkg_basename     = $(LIBPCAP_PKG_NAME)-$(LIBPCAP_PKG_VERSION)-$(LIBPCAP_PKG_ARCH)-$(LIBPCAP_PKG_DISTRO_NAME)-$(LIBPCAP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBPCAP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-libnl
extra_configure_switches += --with-pcap=linux

extra_configure_switches += --enable-usb
extra_configure_switches += --enable-bluetooth
extra_configure_switches += --enable-canusb
extra_configure_switches += --enable-can
extra_configure_switches += --enable-dbus


CFLAGS  += -I$(TARGET_DEST_DIR)/usr/include/libnl3


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) shared
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBPCAP_PKG)/usr/bin
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBPCAP_PKG)/usr/include/net
	@( cd $(LIBPCAP_PKG)/usr/include/net ; \
	   ln -sf ../pcap-bpf.h bpf.h ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(LIBPCAP_PKG)/usr/share/man ]; then \
	  ( cd $(LIBPCAP_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        if [ ! -z "`find . -type f -name "*.?"`" ] ; then gzip -9 *.? ; fi ; \
	        if [ ! -z "`find . -type f -name "*.?pcap"`" ] ; then gzip -9 *.?pcap ; fi ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBPCAP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CREDITS $(SRC_DIR)/LICENSE \
	       $(LIBPCAP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBPCAP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CREDITS INSTALL.txt LICENSE README* TODO VERSION \
	         $(LIBPCAP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LIBPCAP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove devenv dir from pcap-config script =======
	@( cd $(LIBPCAP_PKG)/usr/bin ; \
	   sed -i 's,$(TARGET_DEST_DIR)/usr,$${prefix},g' pcap-config ; \
	   sed -i 's,-Lyes/lib/.libs ,,g'                 pcap-config ; \
	   sed -i 's,^libdir="/usr,libdir="$${prefix},g'  pcap-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBPCAP_PKG))
	# ======= tune pcap-config script =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i 's,="/usr,="$(TARGET_DEST_DIR)/usr,g' pcap-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBPCAP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBPCAP_PKG_DESCRIPTION_FILE): $(LIBPCAP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBPCAP_PKG_DESCRIPTION_FILE) $(LIBPCAP_PKG_INSTALL_SCRIPT)
	@cp $(LIBPCAP_PKG_DESCRIPTION_FILE) $(LIBPCAP_PKG)/.DESCRIPTION
	@cp $(LIBPCAP_PKG_INSTALL_SCRIPT) $(LIBPCAP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBPCAP_PKG)/.REQUIRES
	@echo "pkgname=$(LIBPCAP_PKG_NAME)"                            >  $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBPCAP_PKG_VERSION)"                          >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBPCAP_PKG_ARCH)"                               >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBPCAP_PKG_DISTRO_NAME)"                  >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBPCAP_PKG_DISTRO_VERSION)"                >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "group=$(LIBPCAP_PKG_GROUP)"                             >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBPCAP_PKG_SHORT_DESCRIPTION)\"" >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "url=$(LIBPCAP_PKG_URL)"                                 >> $(LIBPCAP_PKG)/.PKGINFO ; \
	 echo "license=$(LIBPCAP_PKG_LICENSE)"                         >> $(LIBPCAP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBPCAP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
