
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


SOURCE_REQUIRES    = sources/packages/m/wavpack

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


version            = 4.75.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/wavpack/wavpack-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/wavpack-$(version)
src_dir_name       = wavpack-$(version)
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
WAVPACK_PKG_NAME                = wavpack
WAVPACK_PKG_VERSION             = 4.75.2
WAVPACK_PKG_ARCH                = $(TOOLCHAIN)
WAVPACK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WAVPACK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WAVPACK_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
WAVPACK_PKG_SHORT_DESCRIPTION   = A lossless WAV file compressor
WAVPACK_PKG_URL                 = $(BUG_URL)
WAVPACK_PKG_LICENSE             = BSD
WAVPACK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WAVPACK_PKG_NAME)-pkg-description
WAVPACK_PKG_DESCRIPTION_FILE_IN = $(WAVPACK_PKG_NAME)-pkg-description.in
WAVPACK_PKG_INSTALL_SCRIPT      = $(WAVPACK_PKG_NAME)-pkg-install.sh

WAVPACK_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WAVPACK_PKG_NAME)-package

pkg_basename     = $(WAVPACK_PKG_NAME)-$(WAVPACK_PKG_VERSION)-$(WAVPACK_PKG_ARCH)-$(WAVPACK_PKG_DISTRO_NAME)-$(WAVPACK_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(WAVPACK_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += --enable-mmx
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
	@mkdir -p $(WAVPACK_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(WAVPACK_PKG)/usr/share/man ]; then \
	  ( cd $(WAVPACK_PKG)/usr/share/man ; \
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
	@mkdir -p $(WAVPACK_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(WAVPACK_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WAVPACK_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README \
	         $(WAVPACK_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WAVPACK_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(WAVPACK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libwavpack.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WAVPACK_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libwavpack.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libwavpack.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" wavpack.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(WAVPACK_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(WAVPACK_PKG_DESCRIPTION_FILE): $(WAVPACK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WAVPACK_PKG_DESCRIPTION_FILE) $(WAVPACK_PKG_INSTALL_SCRIPT)
	@cp $(WAVPACK_PKG_DESCRIPTION_FILE) $(WAVPACK_PKG)/.DESCRIPTION
	@cp $(WAVPACK_PKG_INSTALL_SCRIPT) $(WAVPACK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WAVPACK_PKG)/.REQUIRES
	@echo "pkgname=$(WAVPACK_PKG_NAME)"                            >  $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WAVPACK_PKG_VERSION)"                          >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "arch=$(WAVPACK_PKG_ARCH)"                               >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "distroname=$(WAVPACK_PKG_DISTRO_NAME)"                  >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "distrover=$(WAVPACK_PKG_DISTRO_VERSION)"                >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "group=$(WAVPACK_PKG_GROUP)"                             >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WAVPACK_PKG_SHORT_DESCRIPTION)\"" >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "url=$(WAVPACK_PKG_URL)"                                 >> $(WAVPACK_PKG)/.PKGINFO ; \
	 echo "license=$(WAVPACK_PKG_LICENSE)"                         >> $(WAVPACK_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(WAVPACK_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
