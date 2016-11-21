
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


SOURCE_REQUIRES    = sources/packages/a/lm_sensors

REQUIRES           = app/sysfsutils/2.1.0
REQUIRES          += dev/perl/5.22.1

# ======= __END_OF_REQUIRES__ =======


version            = 3.3.5
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/lm_sensors/lm_sensors-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lm_sensors-$(version)
src_dir_name       = lm_sensors-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LMSENS_PKG_NAME                = lm_sensors
LMSENS_PKG_VERSION             = 3.3.5
LMSENS_PKG_ARCH                = $(TOOLCHAIN)
LMSENS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LMSENS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LMSENS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LMSENS_PKG_SHORT_DESCRIPTION   = hardware monitoring package
LMSENS_PKG_URL                 = $(BUG_URL)
LMSENS_PKG_LICENSE             = GPLv2
LMSENS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LMSENS_PKG_NAME)-pkg-description
LMSENS_PKG_DESCRIPTION_FILE_IN = $(LMSENS_PKG_NAME)-pkg-description.in
LMSENS_PKG_INSTALL_SCRIPT      = $(LMSENS_PKG_NAME)-pkg-install.sh

LMSENS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LMSENS_PKG_NAME)-package

pkg_basename     = $(LMSENS_PKG_NAME)-$(LMSENS_PKG_VERSION)-$(LMSENS_PKG_ARCH)-$(LMSENS_PKG_DISTRO_NAME)-$(LMSENS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LMSENS_PKG)


lmsens_environment     = CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
lmsens_environment    += RANLIB="$(RANLIB)"

lmsens_environment    += CFLAGS="$(ARCH_FLAGS)"
lmsens_environment    += CPPFLAGS="$(ARCH_DEFS) $(HW_FLAGS)"

lmsens_environment    += LIBDIR=/usr/lib$(LIBSUFFIX)
lmsens_environment    += EXLDFLAGS="-Wl,-rpath,/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)"

lmsens_environment    += PREFIX=/usr
lmsens_environment    += ETCDIR=/etc
lmsens_environment    += BINDIR=/usr/bin
lmsens_environment    += SBINDIR=/usr/sbin
lmsens_environment    += MANDIR=/usr/share/man

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
lmsens_environment    += MACHINE="i386"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
lmsens_environment    += MACHINE="x86_64"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
lmsens_environment    += MACHINE="arm"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
lmsens_environment    += MACHINE="arm"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)),)
lmsens_environment    += MACHINE="arm"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
lmsens_environment    += MACHINE="arm"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_OMAP5UEVM)),)
lmsens_environment    += MACHINE="arm"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
lmsens_environment    += MACHINE="mips"
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BT1)),)
lmsens_environment    += MACHINE="mips"
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	# ======= build lm_sensors =======
	@( cd $(SRC_DIR) ; \
	   $(MAKE) user $(lmsens_environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LMSENS_PKG)
	# ======= install lm_sensors =======
	@( cd $(SRC_DIR) ; \
	   $(MAKE) user_install $(lmsens_environment) $(env_sysroot) ; \
	 )
	@mv $(LMSENS_PKG)/etc/sensors3.conf $(LMSENS_PKG)/etc/sensors3.conf.new
	# ======= Install Documentation =======
	@if [ -d $(LMSENS_PKG)/usr/share/man ]; then \
	  ( cd $(LMSENS_PKG)/usr/share/man ; \
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
	@mkdir -p $(LMSENS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(LMSENS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LMSENS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CONTRIBUTORS COPYING* INSTALL README \
	         doc/donations doc/fan-divisors            \
	         doc/fancontrol.txt doc/libsensors-API.txt \
	         doc/progs doc/svn doc/temperature-sensors \
	         doc/vid \
	         $(LMSENS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LMSENS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LMSENS_PKG))
	# ======= Strip binaries =======
	@( cd $(LMSENS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LMSENS_PKG_DESCRIPTION_FILE): $(LMSENS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LMSENS_PKG_DESCRIPTION_FILE) $(LMSENS_PKG_INSTALL_SCRIPT)
	@cp $(LMSENS_PKG_DESCRIPTION_FILE) $(LMSENS_PKG)/.DESCRIPTION
	@cp $(LMSENS_PKG_INSTALL_SCRIPT) $(LMSENS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LMSENS_PKG)/.REQUIRES
	@echo "pkgname=$(LMSENS_PKG_NAME)"                            >  $(LMSENS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LMSENS_PKG_VERSION)"                          >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "arch=$(LMSENS_PKG_ARCH)"                               >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "distroname=$(LMSENS_PKG_DISTRO_NAME)"                  >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "distrover=$(LMSENS_PKG_DISTRO_VERSION)"                >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "group=$(LMSENS_PKG_GROUP)"                             >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LMSENS_PKG_SHORT_DESCRIPTION)\"" >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "url=$(LMSENS_PKG_URL)"                                 >> $(LMSENS_PKG)/.PKGINFO ; \
	 echo "license=$(LMSENS_PKG_LICENSE)"                         >> $(LMSENS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LMSENS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
