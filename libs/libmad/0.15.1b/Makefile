
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


SOURCE_REQUIRES    = sources/packages/m/mad/libmad

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.15.1b
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/mad/libmad/libmad-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libmad-$(version)
src_dir_name       = libmad-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

mad_pc_in          = $(CURDIR)/mad-pc/mad.pc.in


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBMAD_PKG_NAME                = libmad
LIBMAD_PKG_VERSION             = 0.15.1b
LIBMAD_PKG_ARCH                = $(TOOLCHAIN)
LIBMAD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBMAD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBMAD_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBMAD_PKG_SHORT_DESCRIPTION   = high-quality MPEG audio library
LIBMAD_PKG_URL                 = $(BUG_URL)
LIBMAD_PKG_LICENSE             = GPLv2
LIBMAD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBMAD_PKG_NAME)-pkg-description
LIBMAD_PKG_DESCRIPTION_FILE_IN = $(LIBMAD_PKG_NAME)-pkg-description.in
LIBMAD_PKG_INSTALL_SCRIPT      = $(LIBMAD_PKG_NAME)-pkg-install.sh

LIBMAD_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBMAD_PKG_NAME)-package

pkg_basename     = $(LIBMAD_PKG_NAME)-$(LIBMAD_PKG_VERSION)-$(LIBMAD_PKG_ARCH)-$(LIBMAD_PKG_DISTRO_NAME)-$(LIBMAD_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBMAD_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

#
# ARCH-specific fixed-point math routines
# (one of: intel, arm, mips, sparc, ppc, 64bit, default)
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
extra_configure_switches += --enable-fpm=intel
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += --enable-fpm=64bit
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB3X)),)
extra_configure_switches += --enable-fpm=arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
extra_configure_switches += --enable-fpm=arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_DM64X)),)
extra_configure_switches += --enable-fpm=arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BEAGLE)),)
extra_configure_switches += --enable-fpm=arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
extra_configure_switches += --enable-fpm=arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_B74)),)
extra_configure_switches += --enable-fpm=mips
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
extra_configure_switches += --enable-fpm=mips
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BT1)),)
extra_configure_switches += --enable-fpm=mips
endif


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
	@mkdir -p $(LIBMAD_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Create package config file =======
	@mkdir -p $(LIBMAD_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@sed -e "s,/lib,/lib$(LIBSUFFIX)," $(mad_pc_in) \
	  > $(LIBMAD_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig/mad.pc
	# ======= Install Documentation =======
	@if [ -d $(LIBMAD_PKG)/usr/share/man ]; then \
	  ( cd $(LIBMAD_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBMAD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/COPYRIGHT \
	       $(LIBMAD_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBMAD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING COPYRIGHT CREDITS INSTALL README TODO VERSION \
	         $(LIBMAD_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LIBMAD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBMAD_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmad.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBMAD_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmad.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmad.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" mad.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBMAD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBMAD_PKG_DESCRIPTION_FILE): $(LIBMAD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBMAD_PKG_DESCRIPTION_FILE) $(LIBMAD_PKG_INSTALL_SCRIPT)
	@cp $(LIBMAD_PKG_DESCRIPTION_FILE) $(LIBMAD_PKG)/.DESCRIPTION
	@cp $(LIBMAD_PKG_INSTALL_SCRIPT) $(LIBMAD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBMAD_PKG)/.REQUIRES
	@echo "pkgname=$(LIBMAD_PKG_NAME)"                            >  $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBMAD_PKG_VERSION)"                          >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBMAD_PKG_ARCH)"                               >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBMAD_PKG_DISTRO_NAME)"                  >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBMAD_PKG_DISTRO_VERSION)"                >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "group=$(LIBMAD_PKG_GROUP)"                             >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBMAD_PKG_SHORT_DESCRIPTION)\"" >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "url=$(LIBMAD_PKG_URL)"                                 >> $(LIBMAD_PKG)/.PKGINFO ; \
	 echo "license=$(LIBMAD_PKG_LICENSE)"                         >> $(LIBMAD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBMAD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
