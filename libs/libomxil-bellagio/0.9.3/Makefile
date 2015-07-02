
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/OpenMAX/libomxil-bellagio

REQUIRES           = libs/glibc/2.21

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/OpenMAX/libomxil-bellagio/libomxil-bellagio-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libomxil-bellagio-$(version)
src_dir_name       = libomxil-bellagio-$(version)
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
OMXIL_PKG_NAME                = libomxil-bellagio
OMXIL_PKG_VERSION             = 0.9.3
OMXIL_PKG_ARCH                = $(TOOLCHAIN)
OMXIL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OMXIL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OMXIL_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
OMXIL_PKG_SHORT_DESCRIPTION   = Khronos OpenMAX IL API
OMXIL_PKG_URL                 = $(BUG_URL)
OMXIL_PKG_LICENSE             = LGPLv2.1
OMXIL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OMXIL_PKG_NAME)-pkg-description
OMXIL_PKG_DESCRIPTION_FILE_IN = $(OMXIL_PKG_NAME)-pkg-description.in
OMXIL_PKG_INSTALL_SCRIPT      = $(OMXIL_PKG_NAME)-pkg-install.sh

OMXIL_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OMXIL_PKG_NAME)-package

pkg_basename     = $(OMXIL_PKG_NAME)-$(OMXIL_PKG_VERSION)-$(OMXIL_PKG_ARCH)-$(OMXIL_PKG_DISTRO_NAME)-$(OMXIL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(OMXIL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -fi ; rm -rf autom4te.cache *~ ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure ac_cv_func_malloc_0_nonnull=yes \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OMXIL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(OMXIL_PKG)/usr/share/man ]; then \
	  ( cd $(OMXIL_PKG)/usr/share/man ; \
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
	@mkdir -p $(OMXIL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(OMXIL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OMXIL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(OMXIL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(OMXIL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(OMXIL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libomxil-bellagio.la               \
	                                    omxloaders/libomxdynamicloader.la  \
	                                    bellagio/libomxaudio_effects.la    \
	                                    bellagio/libomxclocksrc.la         \
	                                    bellagio/libomxvideosched.la     ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OMXIL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libomxil-bellagio.la               \
	                                            omxloaders/libomxdynamicloader.la  \
	                                            bellagio/libomxaudio_effects.la    \
	                                            bellagio/libomxclocksrc.la         \
	                                            bellagio/libomxvideosched.la     ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libomxil-bellagio.la               \
	                                              omxloaders/libomxdynamicloader.la  \
	                                              bellagio/libomxaudio_effects.la    \
	                                              bellagio/libomxclocksrc.la         \
	                                              bellagio/libomxvideosched.la     ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libomxil-bellagio.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(OMXIL_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(OMXIL_PKG_DESCRIPTION_FILE): $(OMXIL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OMXIL_PKG_DESCRIPTION_FILE) $(OMXIL_PKG_INSTALL_SCRIPT)
	@cp $(OMXIL_PKG_DESCRIPTION_FILE) $(OMXIL_PKG)/.DESCRIPTION
	@cp $(OMXIL_PKG_INSTALL_SCRIPT) $(OMXIL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OMXIL_PKG)/.REQUIRES
	@echo "pkgname=$(OMXIL_PKG_NAME)"                            >  $(OMXIL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OMXIL_PKG_VERSION)"                          >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "arch=$(OMXIL_PKG_ARCH)"                               >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "distroname=$(OMXIL_PKG_DISTRO_NAME)"                  >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "distrover=$(OMXIL_PKG_DISTRO_VERSION)"                >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "group=$(OMXIL_PKG_GROUP)"                             >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OMXIL_PKG_SHORT_DESCRIPTION)\"" >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "url=$(OMXIL_PKG_URL)"                                 >> $(OMXIL_PKG)/.PKGINFO ; \
	 echo "license=$(OMXIL_PKG_LICENSE)"                         >> $(OMXIL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(OMXIL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
