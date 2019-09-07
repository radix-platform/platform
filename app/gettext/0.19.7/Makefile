
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


SOURCE_REQUIRES    = sources/GNU/gettext

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.27
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.19.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/gettext/gettext-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gettext-$(version)
src_dir_name       = gettext-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GETTEXT_PKG_NAME                = gettext
GETTEXT_PKG_VERSION             = 0.19.7
GETTEXT_PKG_ARCH                = $(TOOLCHAIN)
GETTEXT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GETTEXT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GETTEXT_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GETTEXT_PKG_SHORT_DESCRIPTION   = internationalization framework
GETTEXT_PKG_URL                 = $(BUG_URL)
GETTEXT_PKG_LICENSE             = GPLv3
GETTEXT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GETTEXT_PKG_NAME)-pkg-description
GETTEXT_PKG_DESCRIPTION_FILE_IN = $(GETTEXT_PKG_NAME)-pkg-description.in
GETTEXT_PKG_INSTALL_SCRIPT      = $(GETTEXT_PKG_NAME)-pkg-install.sh

GETTEXT_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GETTEXT_PKG_NAME)-package

pkg_basename     = $(GETTEXT_PKG_NAME)-$(GETTEXT_PKG_VERSION)-$(GETTEXT_PKG_ARCH)-$(GETTEXT_PKG_DISTRO_NAME)-$(GETTEXT_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GETTEXT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-shared


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/gettext-runtime/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GETTEXT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(GETTEXT_PKG)/usr/share/info/dir
	@gzip -9 $(GETTEXT_PKG)/usr/share/info/*
	@( cd $(GETTEXT_PKG)/usr/share/man/man3 ; \
	   rm -f dcgettext.3 dgettext.3 dcngettext.3 dngettext.3 ; \
	   ln -sf gettext.3 dcgettext.3 ; \
	   ln -sf gettext.3 dgettext.3 ; \
	   ln -sf ngettext.3 dcngettext.3 ; \
	   ln -sf ngettext.3 dngettext.3 \
	 )
	@if [ -d $(GETTEXT_PKG)/usr/share/man ]; then \
	  ( cd $(GETTEXT_PKG)/usr/share/man ; \
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
	@mkdir -p $(GETTEXT_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING \
	         $(GETTEXT_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(GETTEXT_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(GETTEXT_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv *.html csharpdoc javadoc2 html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING DEPENDENCIES HACKING INSTALL NEWS PACKAGING README* THANKS \
	         $(GETTEXT_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GETTEXT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GETTEXT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libasprintf.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GETTEXT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasprintf.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libasprintf.la \
	 )
	# ======= Strip binaries =======
	@( cd $(GETTEXT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GETTEXT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GETTEXT_PKG_DESCRIPTION_FILE): $(GETTEXT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GETTEXT_PKG_DESCRIPTION_FILE) $(GETTEXT_PKG_INSTALL_SCRIPT)
	@cp $(GETTEXT_PKG_DESCRIPTION_FILE) $(GETTEXT_PKG)/.DESCRIPTION
	@cp $(GETTEXT_PKG_INSTALL_SCRIPT) $(GETTEXT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GETTEXT_PKG)/.REQUIRES
	@echo "pkgname=$(GETTEXT_PKG_NAME)"                            >  $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GETTEXT_PKG_VERSION)"                          >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "arch=$(GETTEXT_PKG_ARCH)"                               >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "distroname=$(GETTEXT_PKG_DISTRO_NAME)"                  >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "distrover=$(GETTEXT_PKG_DISTRO_VERSION)"                >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "group=$(GETTEXT_PKG_GROUP)"                             >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GETTEXT_PKG_SHORT_DESCRIPTION)\"" >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "url=$(GETTEXT_PKG_URL)"                                 >> $(GETTEXT_PKG)/.PKGINFO ; \
	 echo "license=$(GETTEXT_PKG_LICENSE)"                         >> $(GETTEXT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GETTEXT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
