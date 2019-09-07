
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


SOURCE_REQUIRES    = sources/packages/l/libdaemon

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.27
else
REQUIRES           = libs/glibc/2.27-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.14
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libdaemon/libdaemon-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdaemon-$(version)
src_dir_name       = libdaemon-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

hw_cache           = $(CURDIR)/$(build_dir)/hw.cache


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBDAEMON_PKG_NAME                = libdaemon
LIBDAEMON_PKG_VERSION             = 0.14
LIBDAEMON_PKG_ARCH                = $(TOOLCHAIN)
LIBDAEMON_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBDAEMON_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBDAEMON_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBDAEMON_PKG_SHORT_DESCRIPTION   = library for writing UNIX daemons
LIBDAEMON_PKG_URL                 = $(BUG_URL)
LIBDAEMON_PKG_LICENSE             = LGPLv2.1
LIBDAEMON_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBDAEMON_PKG_NAME)-pkg-description
LIBDAEMON_PKG_DESCRIPTION_FILE_IN = $(LIBDAEMON_PKG_NAME)-pkg-description.in
LIBDAEMON_PKG_INSTALL_SCRIPT      = $(LIBDAEMON_PKG_NAME)-pkg-install.sh

LIBDAEMON_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBDAEMON_PKG_NAME)-package

pkg_basename     = $(LIBDAEMON_PKG_NAME)-$(LIBDAEMON_PKG_VERSION)-$(LIBDAEMON_PKG_ARCH)-$(LIBDAEMON_PKG_DISTRO_NAME)-$(LIBDAEMON_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBDAEMON_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --disable-lynx

extra_configure_switches += --cache-file=$(hw_cache)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo "ac_cv_func_setpgrp_void=yes" > $(hw_cache)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBDAEMON_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBDAEMON_PKG)/usr/share/man ]; then \
	  ( cd $(LIBDAEMON_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBDAEMON_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(LIBDAEMON_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBDAEMON_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README \
	         $(LIBDAEMON_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ====== remove toolchain path from target libtool *.la files ======
	@( cd $(LIBDAEMON_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdaemon.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBDAEMON_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdaemon.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdaemon.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdaemon.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBDAEMON_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBDAEMON_PKG_DESCRIPTION_FILE): $(LIBDAEMON_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBDAEMON_PKG_DESCRIPTION_FILE) $(LIBDAEMON_PKG_INSTALL_SCRIPT)
	@cp $(LIBDAEMON_PKG_DESCRIPTION_FILE) $(LIBDAEMON_PKG)/.DESCRIPTION
	@cp $(LIBDAEMON_PKG_INSTALL_SCRIPT) $(LIBDAEMON_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBDAEMON_PKG)/.REQUIRES
	@echo "pkgname=$(LIBDAEMON_PKG_NAME)"                            >  $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBDAEMON_PKG_VERSION)"                          >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBDAEMON_PKG_ARCH)"                               >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBDAEMON_PKG_DISTRO_NAME)"                  >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBDAEMON_PKG_DISTRO_VERSION)"                >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "group=$(LIBDAEMON_PKG_GROUP)"                             >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBDAEMON_PKG_SHORT_DESCRIPTION)\"" >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "url=$(LIBDAEMON_PKG_URL)"                                 >> $(LIBDAEMON_PKG)/.PKGINFO ; \
	 echo "license=$(LIBDAEMON_PKG_LICENSE)"                         >> $(LIBDAEMON_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBDAEMON_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
