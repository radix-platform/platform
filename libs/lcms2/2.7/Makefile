
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


SOURCE_REQUIRES    = sources/packages/l/lcms2

REQUIRES           = libs/libtiff/4.0.6

# ======= __END_OF_REQUIRES__ =======


version            = 2.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/lcms2/lcms2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/lcms2-$(version)
src_dir_name       = lcms2-$(version)
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
LCMS2_PKG_NAME                = lcms2
LCMS2_PKG_VERSION             = 2.7
LCMS2_PKG_ARCH                = $(TOOLCHAIN)
LCMS2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LCMS2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LCMS2_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
LCMS2_PKG_SHORT_DESCRIPTION   = LCMS Color Management Library
LCMS2_PKG_URL                 = $(BUG_URL)
LCMS2_PKG_LICENSE             = MIT
LCMS2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LCMS2_PKG_NAME)-pkg-description
LCMS2_PKG_DESCRIPTION_FILE_IN = $(LCMS2_PKG_NAME)-pkg-description.in
LCMS2_PKG_INSTALL_SCRIPT      = $(LCMS2_PKG_NAME)-pkg-install.sh

LCMS2_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LCMS2_PKG_NAME)-package

pkg_basename     = $(LCMS2_PKG_NAME)-$(LCMS2_PKG_VERSION)-$(LCMS2_PKG_ARCH)-$(LCMS2_PKG_DISTRO_NAME)-$(LCMS2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LCMS2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


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
	@mkdir -p $(LCMS2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LCMS2_PKG)/usr/share/man ]; then \
	  ( cd $(LCMS2_PKG)/usr/share/man ; \
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
	@mkdir -p $(LCMS2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LCMS2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LCMS2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   chmod 0644 doc/*.pdf ; \
	   cp -a AUTHORS COPYING INSTALL README.1ST doc/*.pdf \
	         $(LCMS2_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LCMS2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LCMS2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liblcms2.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LCMS2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblcms2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblcms2.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" lcms2.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LCMS2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LCMS2_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LCMS2_PKG_DESCRIPTION_FILE): $(LCMS2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LCMS2_PKG_DESCRIPTION_FILE) $(LCMS2_PKG_INSTALL_SCRIPT)
	@cp $(LCMS2_PKG_DESCRIPTION_FILE) $(LCMS2_PKG)/.DESCRIPTION
	@cp $(LCMS2_PKG_INSTALL_SCRIPT) $(LCMS2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LCMS2_PKG)/.REQUIRES
	@echo "pkgname=$(LCMS2_PKG_NAME)"                            >  $(LCMS2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LCMS2_PKG_VERSION)"                          >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "arch=$(LCMS2_PKG_ARCH)"                               >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "distroname=$(LCMS2_PKG_DISTRO_NAME)"                  >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "distrover=$(LCMS2_PKG_DISTRO_VERSION)"                >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "group=$(LCMS2_PKG_GROUP)"                             >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LCMS2_PKG_SHORT_DESCRIPTION)\"" >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "url=$(LCMS2_PKG_URL)"                                 >> $(LCMS2_PKG)/.PKGINFO ; \
	 echo "license=$(LCMS2_PKG_LICENSE)"                         >> $(LCMS2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LCMS2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
