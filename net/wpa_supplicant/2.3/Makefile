
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/wpa_supplicant

REQUIRES           = app/dbus/1.8.10
REQUIRES          += libs/ncurses/5.9
REQUIRES          += libs/readline/6.3
REQUIRES          += net/libnl3/3.2.25
REQUIRES          += net/openssl/1.0.1g

# ======= __END_OF_REQUIRES__ =======


version            = 2.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/wpa_supplicant/wpa_supplicant-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/wpa_supplicant-$(version)
src_dir_name       = wpa_supplicant-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

config_dir         = $(CURDIR)/config
dot_config         = $(config_dir)/dot.config

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WPASUP_PKG_NAME                = wpa_supplicant
WPASUP_PKG_VERSION             = 2.3
WPASUP_PKG_ARCH                = $(TOOLCHAIN)
WPASUP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WPASUP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WPASUP_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
WPASUP_PKG_SHORT_DESCRIPTION   = WPA/WPA2/IEEE 802.1X Supplicant
WPASUP_PKG_URL                 = $(BUG_URL)
WPASUP_PKG_LICENSE             = BSD
WPASUP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WPASUP_PKG_NAME)-pkg-description
WPASUP_PKG_DESCRIPTION_FILE_IN = $(WPASUP_PKG_NAME)-pkg-description.in
WPASUP_PKG_INSTALL_SCRIPT      = $(WPASUP_PKG_NAME)-pkg-install.sh

WPASUP_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WPASUP_PKG_NAME)-package

pkg_basename     = $(WPASUP_PKG_NAME)-$(WPASUP_PKG_VERSION)-$(WPASUP_PKG_ARCH)-$(WPASUP_PKG_DISTRO_NAME)-$(WPASUP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(WPASUP_PKG)


configure_switches  = BINDIR=/usr/sbin
configure_switches += LIBDIR=/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@ cat $(dot_config) > $(SRC_DIR)/wpa_supplicant/.config
	@cd $(SRC_DIR)/wpa_supplicant && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WPASUP_PKG)/usr/sbin
	@mkdir -p $(WPASUP_PKG)/etc/dbus-1/system.d
	@mkdir -p $(WPASUP_PKG)/etc/logrotate.d
	@mkdir -p $(WPASUP_PKG)/usr/share/dbus-1/system-services
	@( cd $(SRC_DIR)/wpa_supplicant ; \
	   mv wpa_supplicant.conf wpa_supplicant.conf.sample ; \
	   mv wpa_supplicant_template.conf wpa_supplicant_template.conf.sample ; \
	   cp -a wpa_supplicant wpa_passphrase wpa_cli $(WPASUP_PKG)/usr/sbin ; \
	   cp -a dbus/dbus-wpa_supplicant.conf \
	         $(WPASUP_PKG)/etc/dbus-1/system.d/dbus-wpa_supplicant.conf ; \
	   install -m644 dbus/*.service $(WPASUP_PKG)/usr/share/dbus-1/system-services ; \
	   cat $(config_dir)/wpa_supplicant.logrotate > $(WPASUP_PKG)/etc/logrotate.d/wpa_supplicant.new ; \
	   cat $(config_dir)/wpa_supplicant.conf > $(WPASUP_PKG)/etc/wpa_supplicant.conf.new ; \
	   chmod 600 $(WPASUP_PKG)/etc/wpa_supplicant.conf.new ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR)/wpa_supplicant ; \
	   for m in 5 8; do \
	     mkdir -p $(WPASUP_PKG)/usr/share/man/man$${m} ; \
	     cp doc/docbook/*.$${m} $(WPASUP_PKG)/usr/share/man/man$${m} ; \
	   done ; \
	   rm -f $(WPASUP_PKG)/usr/share/man/man8/wpa_gui.8 ; \
	 )
	@if [ -d $(WPASUP_PKG)/usr/share/man ]; then \
	  ( cd $(WPASUP_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(WPASUP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CONTRIBUTIONS $(SRC_DIR)/COPYING $(SRC_DIR)/README \
	       $(WPASUP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WPASUP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/wpa_supplicant ; \
	   cp -a ../CONTRIBUTIONS ../COPYING README README-{HS20,P2P,WPS} examples *.txt *.sample \
	         $(WPASUP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/wpa_supplicant ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WPASUP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(WPASUP_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(WPASUP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(WPASUP_PKG_DESCRIPTION_FILE): $(WPASUP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WPASUP_PKG_DESCRIPTION_FILE) $(WPASUP_PKG_INSTALL_SCRIPT)
	@cp $(WPASUP_PKG_DESCRIPTION_FILE) $(WPASUP_PKG)/.DESCRIPTION
	@cp $(WPASUP_PKG_INSTALL_SCRIPT) $(WPASUP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WPASUP_PKG)/.REQUIRES
	@echo "pkgname=$(WPASUP_PKG_NAME)"                            >  $(WPASUP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WPASUP_PKG_VERSION)"                          >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "arch=$(WPASUP_PKG_ARCH)"                               >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "distroname=$(WPASUP_PKG_DISTRO_NAME)"                  >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "distrover=$(WPASUP_PKG_DISTRO_VERSION)"                >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "group=$(WPASUP_PKG_GROUP)"                             >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WPASUP_PKG_SHORT_DESCRIPTION)\"" >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "url=$(WPASUP_PKG_URL)"                                 >> $(WPASUP_PKG)/.PKGINFO ; \
	 echo "license=$(WPASUP_PKG_LICENSE)"                         >> $(WPASUP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(WPASUP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
