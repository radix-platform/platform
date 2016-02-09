
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libmng

REQUIRES           = libs/lcms2/2.6

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libmng/libmng-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libmng-$(version)
src_dir_name       = libmng-$(version)
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
LIBMNG_PKG_NAME                = libmng
LIBMNG_PKG_VERSION             = 2.0.2
LIBMNG_PKG_ARCH                = $(TOOLCHAIN)
LIBMNG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBMNG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBMNG_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBMNG_PKG_SHORT_DESCRIPTION   = Multiple-image Network Graphics library
LIBMNG_PKG_URL                 = $(BUG_URL)
LIBMNG_PKG_LICENSE             = custom
LIBMNG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBMNG_PKG_NAME)-pkg-description
LIBMNG_PKG_DESCRIPTION_FILE_IN = $(LIBMNG_PKG_NAME)-pkg-description.in
LIBMNG_PKG_INSTALL_SCRIPT      = $(LIBMNG_PKG_NAME)-pkg-install.sh

LIBMNG_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBMNG_PKG_NAME)-package

pkg_basename     = $(LIBMNG_PKG_NAME)-$(LIBMNG_PKG_VERSION)-$(LIBMNG_PKG_ARCH)-$(LIBMNG_PKG_DISTRO_NAME)-$(LIBMNG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBMNG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; make distclean )
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
	@mkdir -p $(LIBMNG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBMNG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBMNG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBMNG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(LIBMNG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBMNG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README* doc/libmng.txt doc/*.png \
	         $(LIBMNG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LIBMNG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBMNG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmng.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBMNG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmng.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmng.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBMNG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBMNG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBMNG_PKG_DESCRIPTION_FILE): $(LIBMNG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBMNG_PKG_DESCRIPTION_FILE) $(LIBMNG_PKG_INSTALL_SCRIPT)
	@cp $(LIBMNG_PKG_DESCRIPTION_FILE) $(LIBMNG_PKG)/.DESCRIPTION
	@cp $(LIBMNG_PKG_INSTALL_SCRIPT) $(LIBMNG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBMNG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBMNG_PKG_NAME)"                            >  $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBMNG_PKG_VERSION)"                          >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBMNG_PKG_ARCH)"                               >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBMNG_PKG_DISTRO_NAME)"                  >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBMNG_PKG_DISTRO_VERSION)"                >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBMNG_PKG_GROUP)"                             >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBMNG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBMNG_PKG_URL)"                                 >> $(LIBMNG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBMNG_PKG_LICENSE)"                         >> $(LIBMNG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBMNG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
