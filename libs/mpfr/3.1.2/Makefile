
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


SOURCE_REQUIRES    = sources/GNU/mpfr

REQUIRES           = libs/gmp/6.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 3.1.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/mpfr/mpfr-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mpfr-$(version)
src_dir_name       = mpfr-$(version)
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
MPFR_PKG_NAME                = mpfr
MPFR_PKG_VERSION             = 3.1.2
MPFR_PKG_ARCH                = $(TOOLCHAIN)
MPFR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MPFR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MPFR_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
MPFR_PKG_SHORT_DESCRIPTION   = Floating-Point Reliable Library
MPFR_PKG_URL                 = $(BUG_URL)
MPFR_PKG_LICENSE             = GPLv2
MPFR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPFR_PKG_NAME)-pkg-description
MPFR_PKG_DESCRIPTION_FILE_IN = $(MPFR_PKG_NAME)-pkg-description.in
MPFR_PKG_INSTALL_SCRIPT      = $(MPFR_PKG_NAME)-pkg-install.sh

MPFR_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPFR_PKG_NAME)-package

pkg_basename     = $(MPFR_PKG_NAME)-$(MPFR_PKG_VERSION)-$(MPFR_PKG_ARCH)-$(MPFR_PKG_DISTRO_NAME)-$(MPFR_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MPFR_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(MPFR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(MPFR_PKG)/usr/share/info/dir
	@gzip -9 $(MPFR_PKG)/usr/share/info/*
	@if [ -d $(MPFR_PKG)/usr/share/man ]; then \
	  ( cd $(MPFR_PKG)/usr/share/man ; \
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
	@mkdir -p $(MPFR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(MPFR_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MPFR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MPFR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmpfr.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MPFR_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpfr.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpfr.la \
	 )
	# ======= Strip binaries =======
	@( cd $(MPFR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MPFR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MPFR_PKG_DESCRIPTION_FILE): $(MPFR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MPFR_PKG_DESCRIPTION_FILE) $(MPFR_PKG_INSTALL_SCRIPT)
	@cp $(MPFR_PKG_DESCRIPTION_FILE) $(MPFR_PKG)/.DESCRIPTION
	@cp $(MPFR_PKG_INSTALL_SCRIPT) $(MPFR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPFR_PKG)/.REQUIRES
	@echo "pkgname=$(MPFR_PKG_NAME)"                            >  $(MPFR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPFR_PKG_VERSION)"                          >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "arch=$(MPFR_PKG_ARCH)"                               >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPFR_PKG_DISTRO_NAME)"                  >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPFR_PKG_DISTRO_VERSION)"                >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "group=$(MPFR_PKG_GROUP)"                             >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPFR_PKG_SHORT_DESCRIPTION)\"" >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "url=$(MPFR_PKG_URL)"                                 >> $(MPFR_PKG)/.PKGINFO ; \
	 echo "license=$(MPFR_PKG_LICENSE)"                         >> $(MPFR_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MPFR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
