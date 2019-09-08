
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


SOURCE_REQUIRES    = sources/packages/n/iptraf-ng

REQUIRES           = libs/ncurses/6.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/iptraf-ng/iptraf-ng-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iptraf-ng-$(version)
src_dir_name       = iptraf-ng-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IPTRAF_PKG_NAME                = iptraf-ng
IPTRAF_PKG_VERSION             = 1.1.4
IPTRAF_PKG_ARCH                = $(TOOLCHAIN)
IPTRAF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPTRAF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPTRAF_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
IPTRAF_PKG_SHORT_DESCRIPTION   = console-based network monitoring program
IPTRAF_PKG_URL                 = $(BUG_URL)
IPTRAF_PKG_LICENSE             = GPLv2
IPTRAF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPTRAF_PKG_NAME)-pkg-description
IPTRAF_PKG_DESCRIPTION_FILE_IN = $(IPTRAF_PKG_NAME)-pkg-description.in
IPTRAF_PKG_INSTALL_SCRIPT      = $(IPTRAF_PKG_NAME)-pkg-install.sh

IPTRAF_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPTRAF_PKG_NAME)-package

pkg_basename     = $(IPTRAF_PKG_NAME)-$(IPTRAF_PKG_VERSION)-$(IPTRAF_PKG_ARCH)-$(IPTRAF_PKG_DISTRO_NAME)-$(IPTRAF_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(IPTRAF_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sbindir=/usr/sbin
extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-lib=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)
extra_configure_switches += --with-ncurses

extra_environment  = NCURSES_CFLAGS="$(shell $(TARGET_DEST_DIR)/usr/bin/ncursesw6-config --cflags)"
extra_environment += NCURSES_LDFLAGS="$(shell $(TARGET_DEST_DIR)/usr/bin/ncursesw6-config --libs) -lpanel"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(extra_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IPTRAF_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(IPTRAF_PKG)/usr/sbin ; \
	   ln -sf iptraf-ng iptraf   ; \
	   ln -sf rvnamed-ng rvnamed ; \
	 )
	@( cd $(IPTRAF_PKG)/usr/share/man/man8 ; \
	   ln -sf iptraf-ng.8 iptraf.8   ; \
	   ln -sf rvnamed-ng.8 rvnamed.8 ; \
	 )
	@mkdir -p $(IPTRAF_PKG)/var/lib/iptraf-ng
	@mkdir -p $(IPTRAF_PKG)/var/run/iptraf-ng
	@mkdir -p $(IPTRAF_PKG)/var/lock/iptraf-ng
	@mkdir -p $(IPTRAF_PKG)/var/log/iptraf-ng
	@mkdir -p $(IPTRAF_PKG)/etc/logrotate.d
	@( cd $(SRC_DIR) ; \
	   cat iptraf-ng-logrotate.conf | sed 's/iptraf/iptraf-ng/g' > $(IPTRAF_PKG)/etc/logrotate.d/iptraf-ng ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(IPTRAF_PKG)/usr/share/man ]; then \
	  ( cd $(IPTRAF_PKG)/usr/share/man ; \
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
	@mkdir -p $(IPTRAF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/LICENSE \
	       $(IPTRAF_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IPTRAF_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS FAQ INSTALL LICENSE README* RELEASE-NOTES \
	         Documentation \
	         $(IPTRAF_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(IPTRAF_PKG)/usr/share/doc/$(src_dir_name)/Documentation ; \
	   rm -f Makefile *.{aux,dvi,rtf,sgml,template} version* ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(IPTRAF_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IPTRAF_PKG))
	# ======= Strip binaries =======
	@( cd $(IPTRAF_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(IPTRAF_PKG_DESCRIPTION_FILE): $(IPTRAF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPTRAF_PKG_DESCRIPTION_FILE) $(IPTRAF_PKG_INSTALL_SCRIPT)
	@cp $(IPTRAF_PKG_DESCRIPTION_FILE) $(IPTRAF_PKG)/.DESCRIPTION
	@cp $(IPTRAF_PKG_INSTALL_SCRIPT) $(IPTRAF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPTRAF_PKG)/.REQUIRES
	@echo "pkgname=$(IPTRAF_PKG_NAME)"                            >  $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPTRAF_PKG_VERSION)"                          >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "arch=$(IPTRAF_PKG_ARCH)"                               >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPTRAF_PKG_DISTRO_NAME)"                  >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPTRAF_PKG_DISTRO_VERSION)"                >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "group=$(IPTRAF_PKG_GROUP)"                             >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPTRAF_PKG_SHORT_DESCRIPTION)\"" >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "url=$(IPTRAF_PKG_URL)"                                 >> $(IPTRAF_PKG)/.PKGINFO ; \
	 echo "license=$(IPTRAF_PKG_LICENSE)"                         >> $(IPTRAF_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IPTRAF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
