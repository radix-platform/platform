
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


SOURCE_REQUIRES    = sources/packages/a/hplip

REQUIRES           = app/foomatic-db-engine/20150616
REQUIRES          += app/sane/backends/1.0.25

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 3.15.9
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/hplip/hplip-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/hplip-$(version)
src_dir_name       = hplip-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
HPLIP_PKG_NAME                = hplip
HPLIP_PKG_VERSION             = 3.15.9
HPLIP_PKG_ARCH                = $(TOOLCHAIN)
HPLIP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HPLIP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HPLIP_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
HPLIP_PKG_SHORT_DESCRIPTION   = HP print support
HPLIP_PKG_URL                 = $(BUG_URL)
HPLIP_PKG_LICENSE             = GPLv2
HPLIP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HPLIP_PKG_NAME)-pkg-description
HPLIP_PKG_DESCRIPTION_FILE_IN = $(HPLIP_PKG_NAME)-pkg-description.in
HPLIP_PKG_INSTALL_SCRIPT      = $(HPLIP_PKG_NAME)-pkg-install.sh

HPLIP_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HPLIP_PKG_NAME)-package

pkg_basename     = $(HPLIP_PKG_NAME)-$(HPLIP_PKG_VERSION)-$(HPLIP_PKG_ARCH)-$(HPLIP_PKG_DISTRO_NAME)-$(HPLIP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(HPLIP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


extra_configure_switches += --with-cupsbackenddir=/usr/lib$(LIBSUFFIX)/cups/backend
extra_configure_switches += --with-cupsfilterdir=/usr/lib$(LIBSUFFIX)/cups/filter
extra_configure_switches += --with-docdir=/usr/share/doc/hplip-$(version)
extra_configure_switches += --with-hpppddir=/usr/share/cups/model/HP
extra_configure_switches += --with-drvdir=/usr/share/cups/drv/hp

extra_configure_switches += --enable-hpijs-install
extra_configure_switches += --enable-hpcups-install
extra_configure_switches += --enable-new-hpcups

extra_configure_switches += --enable-shadow-build
extra_configure_switches += --enable-scan-build
extra_configure_switches += --enable-gui-build
extra_configure_switches += --enable-fax-build
extra_configure_switches += --enable-pp-build

extra_configure_switches += --enable-network-build=yes
extra_configure_switches += --enable-qt4
extra_configure_switches += --enable-policykit

extra_configure_switches += --enable-udev_sysfs_rules

extra_configure_switches += --enable-foomatic-rip-hplip-install
extra_configure_switches += --disable-foomatic-ppd-install
extra_configure_switches += --enable-foomatic-drv-install
extra_configure_switches += --enable-cups-ppd-install
extra_configure_switches += --enable-cups-drv-install


python_environment += am_cv_python_version=$(PYTHON_VERSION)
python_environment += am_cv_python_platform=linux2
python_environment += PYTHONINCLUDEDIR=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += am_cv_python_pyexecdir='/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages'
python_environment += am_cv_python_pythondir='/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages'


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(HPLIP_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot) rulesdir=/lib/udev/rules.d
	# ======= remove /etc/sane.d/dll.conf cause it is already set in sane-backends package =======
	@rm -rf $(HPLIP_PKG)/etc/sane.d
	# ======= Install Documentation =======
	@if [ -d $(HPLIP_PKG)/usr/share/man ]; then \
	  ( cd $(HPLIP_PKG)/usr/share/man ; \
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
	@mkdir -p $(HPLIP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(HPLIP_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(HPLIP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(HPLIP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libhpip.la libhpipp.la libhpmud.la ; \
	 )
	@( cd $(HPLIP_PKG)/usr/lib$(LIBSUFFIX)/sane ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsane-hpaio.la ; \
	 )
	@( cd $(HPLIP_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" cupsext.la hpmudext.la pcardext.la scanext.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(HPLIP_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libhpip.la libhpipp.la libhpmud.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libhpip.la libhpipp.la libhpmud.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/sane ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsane-hpaio.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsane-hpaio.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cupsext.la hpmudext.la pcardext.la scanext.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cupsext.la hpmudext.la pcardext.la scanext.la ; \
	 )
	# ======= Strip Binaries =======
	@( cd $(HPLIP_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(HPLIP_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(HPLIP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(HPLIP_PKG_DESCRIPTION_FILE): $(HPLIP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HPLIP_PKG_DESCRIPTION_FILE) $(HPLIP_PKG_INSTALL_SCRIPT)
	@cp $(HPLIP_PKG_DESCRIPTION_FILE) $(HPLIP_PKG)/.DESCRIPTION
	@cp $(HPLIP_PKG_INSTALL_SCRIPT) $(HPLIP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HPLIP_PKG)/.REQUIRES
	@echo "pkgname=$(HPLIP_PKG_NAME)"                            >  $(HPLIP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HPLIP_PKG_VERSION)"                          >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "arch=$(HPLIP_PKG_ARCH)"                               >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "distroname=$(HPLIP_PKG_DISTRO_NAME)"                  >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "distrover=$(HPLIP_PKG_DISTRO_VERSION)"                >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "group=$(HPLIP_PKG_GROUP)"                             >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HPLIP_PKG_SHORT_DESCRIPTION)\"" >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "url=$(HPLIP_PKG_URL)"                                 >> $(HPLIP_PKG)/.PKGINFO ; \
	 echo "license=$(HPLIP_PKG_LICENSE)"                         >> $(HPLIP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(HPLIP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
