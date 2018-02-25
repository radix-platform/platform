
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


SOURCE_REQUIRES    = sources/packages/m/mpg123

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += libs/alsa-oss/1.0.28
REQUIRES          += app/esound/0.2.41

# ======= __END_OF_REQUIRES__ =======


version            = 1.20.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/mpg123/mpg123-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mpg123-$(version)
src_dir_name       = mpg123-$(version)
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
MPG123_PKG_NAME                = mpg123
MPG123_PKG_VERSION             = 1.20.1
MPG123_PKG_ARCH                = $(TOOLCHAIN)
MPG123_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MPG123_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MPG123_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
MPG123_PKG_SHORT_DESCRIPTION   = MPEG 1.0/2.0/2.5 audio player
MPG123_PKG_URL                 = $(BUG_URL)
MPG123_PKG_LICENSE             = LGPLv2.1
MPG123_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPG123_PKG_NAME)-pkg-description
MPG123_PKG_DESCRIPTION_FILE_IN = $(MPG123_PKG_NAME)-pkg-description.in
MPG123_PKG_INSTALL_SCRIPT      = $(MPG123_PKG_NAME)-pkg-install.sh

MPG123_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPG123_PKG_NAME)-package

pkg_basename     = $(MPG123_PKG_NAME)-$(MPG123_PKG_VERSION)-$(MPG123_PKG_ARCH)-$(MPG123_PKG_DISTRO_NAME)-$(MPG123_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MPG123_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --with-default-audio=alsa

# NOTE:
#   in this stage we have only alsa and esound.
#   Additional available output plugins are:
#
#      portaudio, pulse, sdl
#
extra_configure_switches += --with-audio=alsa,oss,esd

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
extra_configure_switches += --with-cpu=x86
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += --with-cpu=x86-64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
extra_configure_switches += --with-cpu=neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
extra_configure_switches += --with-cpu=neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)),)
extra_configure_switches += --with-cpu=neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
extra_configure_switches += --with-cpu=aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
extra_configure_switches += --with-cpu=neon
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
extra_configure_switches += --with-cpu=arm_fpu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
extra_configure_switches += --with-cpu=generic_fpu
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
extra_configure_switches += --with-cpu=generic_fpu
endif


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
	@mkdir -p $(MPG123_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(MPG123_PKG)/usr/share/man ]; then \
	  ( cd $(MPG123_PKG)/usr/share/man ; \
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
	@mkdir -p $(MPG123_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(MPG123_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MPG123_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS* README TODO \
	         $(MPG123_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   cp -a examples ACCURACY BENCHMARKING BUGS CONTACT \
	         LARGEFILE LICENSE PATENTS README.* ROAD_TO_LGPL \
	         THANKS libmpg123_speed.txt \
	         $(MPG123_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a TODO $(MPG123_PKG)/usr/share/doc/$(src_dir_name)/TODO.libmpg123 \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MPG123_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MPG123_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmpg123.la  \
	 )
	@( cd $(MPG123_PKG)/usr/lib$(LIBSUFFIX)/mpg123 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" output_alsa.la  \
	                                    output_dummy.la \
	                                    output_esd.la   \
	                                    output_oss.la   \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MPG123_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpg123.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpg123.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/mpg123 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" output_alsa.la    \
	                                            output_dummy.la   \
	                                            output_esd.la     \
	                                            output_oss.la   ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" output_alsa.la  \
	                                              output_dummy.la \
	                                              output_esd.la   \
	                                              output_oss.la   \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpg123.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(MPG123_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(MPG123_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MPG123_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MPG123_PKG_DESCRIPTION_FILE): $(MPG123_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MPG123_PKG_DESCRIPTION_FILE) $(MPG123_PKG_INSTALL_SCRIPT)
	@cp $(MPG123_PKG_DESCRIPTION_FILE) $(MPG123_PKG)/.DESCRIPTION
	@cp $(MPG123_PKG_INSTALL_SCRIPT) $(MPG123_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPG123_PKG)/.REQUIRES
	@echo "pkgname=$(MPG123_PKG_NAME)"                            >  $(MPG123_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPG123_PKG_VERSION)"                          >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "arch=$(MPG123_PKG_ARCH)"                               >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPG123_PKG_DISTRO_NAME)"                  >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPG123_PKG_DISTRO_VERSION)"                >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "group=$(MPG123_PKG_GROUP)"                             >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPG123_PKG_SHORT_DESCRIPTION)\"" >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "url=$(MPG123_PKG_URL)"                                 >> $(MPG123_PKG)/.PKGINFO ; \
	 echo "license=$(MPG123_PKG_LICENSE)"                         >> $(MPG123_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(MPG123_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
