
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


SOURCE_REQUIRES    = sources/packages/m/libass

REQUIRES           = X11/libs/fontconfig/2.12.4
REQUIRES          += X11/libs/harfbuzz/1.2.7
REQUIRES          += libs/fribidi/0.19.7

# ======= __END_OF_REQUIRES__ =======


version            = 0.13.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libass/libass-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libass-$(version)
src_dir_name       = libass-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBASS_PKG_NAME                = libass
LIBASS_PKG_VERSION             = 0.13.3
LIBASS_PKG_ARCH                = $(TOOLCHAIN)
LIBASS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBASS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBASS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBASS_PKG_SHORT_DESCRIPTION   = Subtitle renderer for the ASS/SSA
LIBASS_PKG_URL                 = $(BUG_URL)
LIBASS_PKG_LICENSE             = MIT
LIBASS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBASS_PKG_NAME)-pkg-description
LIBASS_PKG_DESCRIPTION_FILE_IN = $(LIBASS_PKG_NAME)-pkg-description.in
LIBASS_PKG_INSTALL_SCRIPT      = $(LIBASS_PKG_NAME)-pkg-install.sh

LIBASS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBASS_PKG_NAME)-package

pkg_basename     = $(LIBASS_PKG_NAME)-$(LIBASS_PKG_VERSION)-$(LIBASS_PKG_ARCH)-$(LIBASS_PKG_DISTRO_NAME)-$(LIBASS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBASS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-fontconfig
extra_configure_switches += --enable-harfbuzz

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	@mkdir -p $(LIBASS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBASS_PKG)/usr/share/man ]; then \
	  ( cd $(LIBASS_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBASS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBASS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBASS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README.md \
	         $(LIBASS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBASS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBASS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libass.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBASS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libass.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libass.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libass.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBASS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBASS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBASS_PKG_DESCRIPTION_FILE): $(LIBASS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBASS_PKG_DESCRIPTION_FILE) $(LIBASS_PKG_INSTALL_SCRIPT)
	@cp $(LIBASS_PKG_DESCRIPTION_FILE) $(LIBASS_PKG)/.DESCRIPTION
	@cp $(LIBASS_PKG_INSTALL_SCRIPT) $(LIBASS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBASS_PKG)/.REQUIRES
	@echo "pkgname=$(LIBASS_PKG_NAME)"                            >  $(LIBASS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBASS_PKG_VERSION)"                          >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBASS_PKG_ARCH)"                               >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBASS_PKG_DISTRO_NAME)"                  >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBASS_PKG_DISTRO_VERSION)"                >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "group=$(LIBASS_PKG_GROUP)"                             >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBASS_PKG_SHORT_DESCRIPTION)\"" >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "url=$(LIBASS_PKG_URL)"                                 >> $(LIBASS_PKG)/.PKGINFO ; \
	 echo "license=$(LIBASS_PKG_LICENSE)"                         >> $(LIBASS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBASS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
