
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
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
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


SOURCE_REQUIRES    = sources/packages/m/alsa/utils

REQUIRES           = app/procps/3.2.8
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += libs/alsa-lib/1.0.28
REQUIRES          += libs/libsamplerate/0.1.8
REQUIRES          += app/pciutils/3.4.1
REQUIRES          += libs/ncurses/6.0
REQUIRES          += app/dialog/1.2-20140112
else
REQUIRES          += libs/alsa-lib/1.0.28-x86_32
REQUIRES          += libs/libsamplerate/0.1.8-x86_32
REQUIRES          += app/pciutils/3.4.1-x86_32
REQUIRES          += libs/ncurses/6.0-x86_32
REQUIRES          += app/dialog/1.2-20140112-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.28
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/alsa/utils/alsa-utils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/alsa-utils-$(version)
src_dir_name       = alsa-utils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

conf_dir           = $(CURDIR)/etc
panda5_conf_dir    = $(CURDIR)/panda5-conf


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ALSA_UTILS_PKG_NAME                = alsa-utils
ALSA_UTILS_PKG_VERSION             = 1.0.28
ALSA_UTILS_PKG_ARCH                = $(TOOLCHAIN)
ALSA_UTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ALSA_UTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ALSA_UTILS_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
ALSA_UTILS_PKG_SHORT_DESCRIPTION   = Advanced Linux Sound Architecture utilities
ALSA_UTILS_PKG_URL                 = $(BUG_URL)
ALSA_UTILS_PKG_LICENSE             = GPLv2
ALSA_UTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ALSA_UTILS_PKG_NAME)-pkg-description
ALSA_UTILS_PKG_DESCRIPTION_FILE_IN = $(ALSA_UTILS_PKG_NAME)-pkg-description.in
ALSA_UTILS_PKG_INSTALL_SCRIPT      = $(ALSA_UTILS_PKG_NAME)-pkg-install.sh

ALSA_UTILS_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ALSA_UTILS_PKG_NAME)-package

pkg_basename     = $(ALSA_UTILS_PKG_NAME)-$(ALSA_UTILS_PKG_VERSION)-$(ALSA_UTILS_PKG_ARCH)-$(ALSA_UTILS_PKG_DISTRO_NAME)-$(ALSA_UTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ALSA_UTILS_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-udev-rules-dir=/lib/udev/rules.d
extra_configure_switches += --disable-alsaconf


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
	@mkdir -p $(ALSA_UTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(ALSA_UTILS_PKG)/etc/rc.d
	# ======= Install /etc/rc.d/rc.alsa script =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
	@cp $(conf_dir)/rc.d/rc.alsa-$(HARDWARE) $(ALSA_UTILS_PKG)/etc/rc.d/rc.alsa.new
else
	@cp $(conf_dir)/rc.d/rc.alsa $(ALSA_UTILS_PKG)/etc/rc.d/rc.alsa.new
endif
	@chmod 0755 $(ALSA_UTILS_PKG)/etc/rc.d/rc.alsa.new
	@cp $(conf_dir)/rc.d/rc.alsa-oss $(ALSA_UTILS_PKG)/etc/rc.d/rc.alsa-oss.new
	@chmod 0644 $(ALSA_UTILS_PKG)/etc/rc.d/rc.alsa-oss.new
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
	# ======= Install Panda5 asound.conf =======
	@mkdir -p $(ALSA_UTILS_PKG)/etc
	@cp $(panda5_conf_dir)/asound-hdmi.conf $(ALSA_UTILS_PKG)/etc/asound-hdmi.conf
	@chmod 0644 $(ALSA_UTILS_PKG)/etc/asound-hdmi.conf
	@cp $(panda5_conf_dir)/asound-panda5.conf $(ALSA_UTILS_PKG)/etc/asound-panda5.conf
	@chmod 0644 $(ALSA_UTILS_PKG)/etc/asound-panda5.conf
	@( cd $(ALSA_UTILS_PKG)/etc ; \
	   ln -sf asound-panda5.conf asound.conf ; \
	 )
endif
	# ======= Install Documentation =======
	@if [ -d $(ALSA_UTILS_PKG)/usr/share/man ]; then \
	  ( cd $(ALSA_UTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(ALSA_UTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(ALSA_UTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ALSA_UTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS COPYING INSTALL README TODO \
	         seq/aconnect/README.aconnect \
	         seq/aseqnet/README.aseqnet \
	         $(ALSA_UTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ALSA_UTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ALSA_UTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(ALSA_UTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ALSA_UTILS_PKG_DESCRIPTION_FILE): $(ALSA_UTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ALSA_UTILS_PKG_DESCRIPTION_FILE) $(ALSA_UTILS_PKG_INSTALL_SCRIPT)
	@cp $(ALSA_UTILS_PKG_DESCRIPTION_FILE) $(ALSA_UTILS_PKG)/.DESCRIPTION
	@cp $(ALSA_UTILS_PKG_INSTALL_SCRIPT) $(ALSA_UTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ALSA_UTILS_PKG)/.REQUIRES
	@echo "pkgname=$(ALSA_UTILS_PKG_NAME)"                            >  $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ALSA_UTILS_PKG_VERSION)"                          >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(ALSA_UTILS_PKG_ARCH)"                               >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(ALSA_UTILS_PKG_DISTRO_NAME)"                  >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(ALSA_UTILS_PKG_DISTRO_VERSION)"                >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "group=$(ALSA_UTILS_PKG_GROUP)"                             >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ALSA_UTILS_PKG_SHORT_DESCRIPTION)\"" >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "url=$(ALSA_UTILS_PKG_URL)"                                 >> $(ALSA_UTILS_PKG)/.PKGINFO ; \
	 echo "license=$(ALSA_UTILS_PKG_LICENSE)"                         >> $(ALSA_UTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ALSA_UTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
