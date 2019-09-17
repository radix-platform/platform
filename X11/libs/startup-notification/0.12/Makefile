
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/startup-notification

REQUIRES           = X11/X.org/lib/libX11/1.6.3
REQUIRES          += X11/X.org/xcb/xcb-util/0.4.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/startup-notification/startup-notification-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/startup-notification-$(version)
src_dir_name       = startup-notification-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/LICENSE


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
STN_PKG_NAME                = startup-notification
STN_PKG_VERSION             = 0.12
STN_PKG_ARCH                = $(TOOLCHAIN)
STN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
STN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
STN_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
STN_PKG_SHORT_DESCRIPTION   = startup notification protocol
STN_PKG_URL                 = $(BUG_URL)
STN_PKG_LICENSE             = LGPLv2
STN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(STN_PKG_NAME)-pkg-description
STN_PKG_DESCRIPTION_FILE_IN = $(STN_PKG_NAME)-pkg-description.in
STN_PKG_INSTALL_SCRIPT      = $(STN_PKG_NAME)-pkg-install.sh

STN_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(STN_PKG_NAME)-package

pkg_basename     = $(STN_PKG_NAME)-$(STN_PKG_VERSION)-$(STN_PKG_ARCH)-$(STN_PKG_DISTRO_NAME)-$(STN_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(STN_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


configure_options  = lf_cv_sane_realloc=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(configure_options) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(STN_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(STN_PKG)/usr/share/man ]; then \
	  ( cd $(STN_PKG)/usr/share/man ; \
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
	@mkdir -p $(STN_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(STN_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(STN_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS doc/startup-notification.txt \
	         $(STN_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(STN_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(STN_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libstartup-notification-?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(STN_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstartup-notification-?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libstartup-notification-?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstartup-notification-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(STN_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(STN_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(STN_PKG_DESCRIPTION_FILE): $(STN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(STN_PKG_DESCRIPTION_FILE) $(STN_PKG_INSTALL_SCRIPT)
	@cp $(STN_PKG_DESCRIPTION_FILE) $(STN_PKG)/.DESCRIPTION
	@cp $(STN_PKG_INSTALL_SCRIPT) $(STN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(STN_PKG)/.REQUIRES
	@echo "pkgname=$(STN_PKG_NAME)"                            >  $(STN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(STN_PKG_VERSION)"                          >> $(STN_PKG)/.PKGINFO ; \
	 echo "arch=$(STN_PKG_ARCH)"                               >> $(STN_PKG)/.PKGINFO ; \
	 echo "distroname=$(STN_PKG_DISTRO_NAME)"                  >> $(STN_PKG)/.PKGINFO ; \
	 echo "distrover=$(STN_PKG_DISTRO_VERSION)"                >> $(STN_PKG)/.PKGINFO ; \
	 echo "group=$(STN_PKG_GROUP)"                             >> $(STN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(STN_PKG_SHORT_DESCRIPTION)\"" >> $(STN_PKG)/.PKGINFO ; \
	 echo "url=$(STN_PKG_URL)"                                 >> $(STN_PKG)/.PKGINFO ; \
	 echo "license=$(STN_PKG_LICENSE)"                         >> $(STN_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(STN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
