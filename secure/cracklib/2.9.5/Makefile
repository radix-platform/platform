
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


SOURCE_REQUIRES    = sources/packages/l/cracklib

REQUIRES           = dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 2.9.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/cracklib/cracklib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cracklib-$(version)
src_dir_name       = cracklib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

config_file        = $(CURDIR)/conf/cracklib.conf
cron_dir           = $(CURDIR)/cron
scripts_dir        = $(CURDIR)/scripts
man_pages_dir      = $(CURDIR)/man

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CRACKLIB_PKG_NAME                = cracklib
CRACKLIB_PKG_VERSION             = 2.9.5
CRACKLIB_PKG_ARCH                = $(TOOLCHAIN)
CRACKLIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CRACKLIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CRACKLIB_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
CRACKLIB_PKG_SHORT_DESCRIPTION   = password-quality library
CRACKLIB_PKG_URL                 = $(BUG_URL)
CRACKLIB_PKG_LICENSE             = LGPLv2
CRACKLIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CRACKLIB_PKG_NAME)-pkg-description
CRACKLIB_PKG_DESCRIPTION_FILE_IN = $(CRACKLIB_PKG_NAME)-pkg-description.in
CRACKLIB_PKG_INSTALL_SCRIPT      = $(CRACKLIB_PKG_NAME)-pkg-install.sh

CRACKLIB_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CRACKLIB_PKG_NAME)-package

pkg_basename     = $(CRACKLIB_PKG_NAME)-$(CRACKLIB_PKG_VERSION)-$(CRACKLIB_PKG_ARCH)-$(CRACKLIB_PKG_DISTRO_NAME)-$(CRACKLIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CRACKLIB_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --datadir=/var/cache
extra_configure_switches += --with-default-dict=/var/cache/cracklib/pq_dict
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@( cd $(build_dir)/python ; \
	   sed -i "/pyexecdir/s:/lib[0-9]*:/lib$(LIBSUFFIX):"  Makefile ; \
	   sed -i "/pythondir/s:/lib[0-9]*:/lib$(LIBSUFFIX):"  Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CRACKLIB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(CRACKLIB_PKG)/lib$(LIBSUFFIX)
	@( cd $(CRACKLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@mkdir -p $(CRACKLIB_PKG)/var/cache/cracklib
	# ======= install cracklib config file =======
	@mkdir -p $(CRACKLIB_PKG)/etc/cracklib
	@cp -a $(config_file) $(CRACKLIB_PKG)/etc/cracklib
	# ======= install update-cracklib script =======
	@mkdir -p $(CRACKLIB_PKG)/usr/sbin
	@cp -a $(scripts_dir)/update-cracklib $(CRACKLIB_PKG)/usr/sbin
	@chmod 0755 $(CRACKLIB_PKG)/usr/sbin/update-cracklib
	# ======= install cron.daily script =======
	@mkdir -p $(CRACKLIB_PKG)/etc/cron.daily
	@cp -a $(cron_dir)/cracklib $(CRACKLIB_PKG)/etc/cron.daily/cracklib
	@chmod 0755 $(CRACKLIB_PKG)/etc/cron.daily/cracklib
	# ======= install words =======
	@mkdir -p $(CRACKLIB_PKG)/usr/share/dict
	@gzip -9 $(CRACKLIB_PKG)/var/cache/cracklib/cracklib-small
	@( cd $(CRACKLIB_PKG)/usr/share/dict ; \
	   ln -sf ../../../var/cache/cracklib/cracklib-small.gz cracklib.gz ; \
	 )
	# ======= man pages =======
	@mkdir -p $(CRACKLIB_PKG)/usr/share/man/man8
	@cp -a $(man_pages_dir)/*.8 $(CRACKLIB_PKG)/usr/share/man/man8
	@( cd $(CRACKLIB_PKG)/usr/share/man/man8 ; \
	   ln -sf cracklib-format.8 cracklib-packer.8 ; \
	   ln -sf cracklib-format.8 cracklib-unpacker.8 ; \
	 )
	@if [ -d $(CRACKLIB_PKG)/usr/share/man ]; then \
	  ( cd $(CRACKLIB_PKG)/usr/share/man ; \
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
	@mkdir -p $(CRACKLIB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING.LIB \
	       $(CRACKLIB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CRACKLIB_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING.LIB INSTALL NEWS README* \
	         $(CRACKLIB_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CRACKLIB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CRACKLIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcrack.la \
	 )
	@( cd $(CRACKLIB_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _cracklib.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CRACKLIB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrack.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcrack.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _cracklib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _cracklib.la \
	 )
	# ======= Strip binaries =======
	@( cd $(CRACKLIB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CRACKLIB_PKG_DESCRIPTION_FILE): $(CRACKLIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CRACKLIB_PKG_DESCRIPTION_FILE) $(CRACKLIB_PKG_INSTALL_SCRIPT)
	@cp $(CRACKLIB_PKG_DESCRIPTION_FILE) $(CRACKLIB_PKG)/.DESCRIPTION
	@cp $(CRACKLIB_PKG_INSTALL_SCRIPT) $(CRACKLIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CRACKLIB_PKG)/.REQUIRES
	@echo "pkgname=$(CRACKLIB_PKG_NAME)"                            >  $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CRACKLIB_PKG_VERSION)"                          >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "arch=$(CRACKLIB_PKG_ARCH)"                               >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(CRACKLIB_PKG_DISTRO_NAME)"                  >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(CRACKLIB_PKG_DISTRO_VERSION)"                >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "group=$(CRACKLIB_PKG_GROUP)"                             >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CRACKLIB_PKG_SHORT_DESCRIPTION)\"" >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "url=$(CRACKLIB_PKG_URL)"                                 >> $(CRACKLIB_PKG)/.PKGINFO ; \
	 echo "license=$(CRACKLIB_PKG_LICENSE)"                         >> $(CRACKLIB_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CRACKLIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
