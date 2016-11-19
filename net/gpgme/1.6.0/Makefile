
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/gpgme

REQUIRES           = net/gnupg/1.4.20
REQUIRES          += net/gnupg2/2.1.12

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/gpgme/gpgme-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gpgme-$(version)
src_dir_name       = gpgme-$(version)
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
GPGME_PKG_NAME                = gpgme
GPGME_PKG_VERSION             = 1.6.0
GPGME_PKG_ARCH                = $(TOOLCHAIN)
GPGME_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPGME_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPGME_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GPGME_PKG_SHORT_DESCRIPTION   = GnuPG Made Easy
GPGME_PKG_URL                 = $(BUG_URL)
GPGME_PKG_LICENSE             = GPLv2
GPGME_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPGME_PKG_NAME)-pkg-description
GPGME_PKG_DESCRIPTION_FILE_IN = $(GPGME_PKG_NAME)-pkg-description.in
GPGME_PKG_INSTALL_SCRIPT      = $(GPGME_PKG_NAME)-pkg-install.sh

GPGME_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPGME_PKG_NAME)-package

pkg_basename     = $(GPGME_PKG_NAME)-$(GPGME_PKG_VERSION)-$(GPGME_PKG_ARCH)-$(GPGME_PKG_DISTRO_NAME)-$(GPGME_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GPGME_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --cache-file=hw.cache

libs_config  = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config
libs_config += LIBASSUAN_CONFIG=$(TARGET_DEST_DIR)/usr/bin/libassuan-config


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   echo "ac_cv_have_decl_ttyname_r=yes"  >> hw.cache ; \
	   echo "ac_cv_func_ttyname_r=yes"       >> hw.cache ; \
	   echo "ac_cv_func_timegm=yes"          >> hw.cache ; \
	   echo "ac_cv_func_fopencookie=yes"     >> hw.cache ; \
	   echo "ac_cv_func_funopen=no"          >> hw.cache ; \
	   echo "ac_cv_func_stpcpy=yes"          >> hw.cache ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(libs_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPGME_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(GPGME_PKG)/usr/share/info/dir
	@gzip -9 $(GPGME_PKG)/usr/share/info/*
	@if [ -d $(GPGME_PKG)/usr/share/man ]; then \
	  ( cd $(GPGME_PKG)/usr/share/man ; \
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
	@mkdir -p $(GPGME_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(GPGME_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GPGME_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README THANKS TODO VERSION doc/DCO doc/HACKING \
	         $(GPGME_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GPGME_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GPGME_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgpgme-pthread.la libgpgme.la ; \
	 )
	@( cd $(GPGME_PKG)/usr/bin ; \
	   sed -i 's,$(TARGET_DEST_DIR)/usr,$${prefix},g' gpgme-config ; \
	   sed -i 's,^libs="-L/usr,libs="-L$${prefix},g'  gpgme-config ; \
	   sed -i 's,@GPG@,/usr/bin/gpg,g'     gpgme-config ; \
	   sed -i 's,@GPGSM@,/usr/bin/gpgsm,g' gpgme-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPGME_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgpgme-pthread.la libgpgme.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgpgme-pthread.la libgpgme.la \
	 )
	# ======= tune gpgme-config file for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" gpgme-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GPGME_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GPGME_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GPGME_PKG_DESCRIPTION_FILE): $(GPGME_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPGME_PKG_DESCRIPTION_FILE) $(GPGME_PKG_INSTALL_SCRIPT)
	@cp $(GPGME_PKG_DESCRIPTION_FILE) $(GPGME_PKG)/.DESCRIPTION
	@cp $(GPGME_PKG_INSTALL_SCRIPT) $(GPGME_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPGME_PKG)/.REQUIRES
	@echo "pkgname=$(GPGME_PKG_NAME)"                            >  $(GPGME_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPGME_PKG_VERSION)"                          >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "arch=$(GPGME_PKG_ARCH)"                               >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPGME_PKG_DISTRO_NAME)"                  >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPGME_PKG_DISTRO_VERSION)"                >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "group=$(GPGME_PKG_GROUP)"                             >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPGME_PKG_SHORT_DESCRIPTION)\"" >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "url=$(GPGME_PKG_URL)"                                 >> $(GPGME_PKG)/.PKGINFO ; \
	 echo "license=$(GPGME_PKG_LICENSE)"                         >> $(GPGME_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GPGME_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
