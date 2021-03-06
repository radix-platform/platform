
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
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


SOURCE_REQUIRES    = sources/packages/m/sox

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += dev/libtool/2.4.6
REQUIRES          += app/file/5.28
REQUIRES          += libs/libpng/libpng14/1.4.19
REQUIRES          += libs/libao/1.2.0
REQUIRES          += libs/lame/3.99.5
REQUIRES          += libs/libid3tag/0.15.1b
REQUIRES          += libs/libmad/0.15.1b
REQUIRES          += libs/libsndfile/1.0.26
REQUIRES          += libs/opencore-amr/0.1.3
REQUIRES          += libs/wavpack/4.75.2
REQUIRES          += libs/gsm/1.0.13

# ======= __END_OF_REQUIRES__ =======


version            = 14.4.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/sox/sox-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sox-$(version)
src_dir_name       = sox-$(version)
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
SOX_PKG_NAME                = sox
SOX_PKG_VERSION             = 14.4.1
SOX_PKG_ARCH                = $(TOOLCHAIN)
SOX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SOX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SOX_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
SOX_PKG_SHORT_DESCRIPTION   = universal sound sample translator
SOX_PKG_URL                 = $(BUG_URL)
SOX_PKG_LICENSE             = GPLv2
SOX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SOX_PKG_NAME)-pkg-description
SOX_PKG_DESCRIPTION_FILE_IN = $(SOX_PKG_NAME)-pkg-description.in
SOX_PKG_INSTALL_SCRIPT      = $(SOX_PKG_NAME)-pkg-install.sh

SOX_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SOX_PKG_NAME)-package

pkg_basename     = $(SOX_PKG_NAME)-$(SOX_PKG_VERSION)-$(SOX_PKG_ARCH)-$(SOX_PKG_DISTRO_NAME)-$(SOX_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SOX_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-distro=Radix
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
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
	@mkdir -p $(SOX_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SOX_PKG)/usr/share/man ]; then \
	  ( cd $(SOX_PKG)/usr/share/man ; \
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
	@mkdir -p $(SOX_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SOX_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SOX_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL LICENSE* NEWS README \
	         $(SOX_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@rm -f $(SOX_PKG)/usr/share/doc/$(src_dir_name)/FLAC.tag
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SOX_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(SOX_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsox.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SOX_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsox.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsox.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sox.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(SOX_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(SOX_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SOX_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SOX_PKG_DESCRIPTION_FILE): $(SOX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SOX_PKG_DESCRIPTION_FILE) $(SOX_PKG_INSTALL_SCRIPT)
	@cp $(SOX_PKG_DESCRIPTION_FILE) $(SOX_PKG)/.DESCRIPTION
	@cp $(SOX_PKG_INSTALL_SCRIPT) $(SOX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SOX_PKG)/.REQUIRES
	@echo "pkgname=$(SOX_PKG_NAME)"                            >  $(SOX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SOX_PKG_VERSION)"                          >> $(SOX_PKG)/.PKGINFO ; \
	 echo "arch=$(SOX_PKG_ARCH)"                               >> $(SOX_PKG)/.PKGINFO ; \
	 echo "distroname=$(SOX_PKG_DISTRO_NAME)"                  >> $(SOX_PKG)/.PKGINFO ; \
	 echo "distrover=$(SOX_PKG_DISTRO_VERSION)"                >> $(SOX_PKG)/.PKGINFO ; \
	 echo "group=$(SOX_PKG_GROUP)"                             >> $(SOX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SOX_PKG_SHORT_DESCRIPTION)\"" >> $(SOX_PKG)/.PKGINFO ; \
	 echo "url=$(SOX_PKG_URL)"                                 >> $(SOX_PKG)/.PKGINFO ; \
	 echo "license=$(SOX_PKG_LICENSE)"                         >> $(SOX_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SOX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
