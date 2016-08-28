
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/alsa/lib

REQUIRES           = dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.28
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/alsa/lib/alsa-lib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/alsa-lib-$(version)
src_dir_name       = alsa-lib-$(version)
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
ALSA_LIB_PKG_NAME                = alsa-lib
ALSA_LIB_PKG_VERSION             = 1.0.28
ALSA_LIB_PKG_ARCH                = $(TOOLCHAIN)
ALSA_LIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ALSA_LIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ALSA_LIB_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
ALSA_LIB_PKG_SHORT_DESCRIPTION   = Advanced Linux Sound Architecture library
ALSA_LIB_PKG_URL                 = $(BUG_URL)
ALSA_LIB_PKG_LICENSE             = LGPLv2.1
ALSA_LIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ALSA_LIB_PKG_NAME)-pkg-description
ALSA_LIB_PKG_DESCRIPTION_FILE_IN = $(ALSA_LIB_PKG_NAME)-pkg-description.in
ALSA_LIB_PKG_INSTALL_SCRIPT      = $(ALSA_LIB_PKG_NAME)-pkg-install.sh

ALSA_LIB_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ALSA_LIB_PKG_NAME)-package

pkg_basename     = $(ALSA_LIB_PKG_NAME)-$(ALSA_LIB_PKG_VERSION)-$(ALSA_LIB_PKG_ARCH)-$(ALSA_LIB_PKG_DISTRO_NAME)-$(ALSA_LIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ALSA_LIB_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-pythonincludes=-I$(TARGET_DEST_DIR)/usr/include/python2.7


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) doc
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ALSA_LIB_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(ALSA_LIB_PKG)/usr/share/man ]; then \
	  ( cd $(ALSA_LIB_PKG)/usr/share/man ; \
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
	@mkdir -p $(ALSA_LIB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(ALSA_LIB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ALSA_LIB_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL MEMORY-LEAK NOTES TODO \
	         $(ALSA_LIB_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(build_dir)/doc/doxygen ; \
	   cp -a html \
	         $(ALSA_LIB_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ALSA_LIB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ALSA_LIB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libasound.la  \
	 )
	@( cd $(ALSA_LIB_PKG)/usr/lib$(LIBSUFFIX)/alsa-lib/smixer ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" smixer-ac97.la   \
	                                    smixer-hda.la    \
	                                    smixer-python.la \
	                                    smixer-sbase.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ALSA_LIB_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasound.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libasound.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/alsa-lib/smixer ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" smixer-ac97.la     \
	                                            smixer-hda.la      \
	                                            smixer-python.la   \
	                                            smixer-sbase.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" smixer-ac97.la   \
	                                              smixer-hda.la    \
	                                              smixer-python.la \
	                                              smixer-sbase.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" alsa.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ALSA_LIB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ALSA_LIB_PKG_DESCRIPTION_FILE): $(ALSA_LIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ALSA_LIB_PKG_DESCRIPTION_FILE) $(ALSA_LIB_PKG_INSTALL_SCRIPT)
	@cp $(ALSA_LIB_PKG_DESCRIPTION_FILE) $(ALSA_LIB_PKG)/.DESCRIPTION
	@cp $(ALSA_LIB_PKG_INSTALL_SCRIPT) $(ALSA_LIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ALSA_LIB_PKG)/.REQUIRES
	@echo "pkgname=$(ALSA_LIB_PKG_NAME)"                            >  $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ALSA_LIB_PKG_VERSION)"                          >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "arch=$(ALSA_LIB_PKG_ARCH)"                               >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(ALSA_LIB_PKG_DISTRO_NAME)"                  >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(ALSA_LIB_PKG_DISTRO_VERSION)"                >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "group=$(ALSA_LIB_PKG_GROUP)"                             >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ALSA_LIB_PKG_SHORT_DESCRIPTION)\"" >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "url=$(ALSA_LIB_PKG_URL)"                                 >> $(ALSA_LIB_PKG)/.PKGINFO ; \
	 echo "license=$(ALSA_LIB_PKG_LICENSE)"                         >> $(ALSA_LIB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ALSA_LIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
