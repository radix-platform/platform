
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/m/xiph/libogg

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.25
else
REQUIRES           = libs/glibc/2.25-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/libogg/libogg-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libogg-$(version)
src_dir_name       = libogg-$(version)
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
LIBOGG_PKG_NAME                = libogg
LIBOGG_PKG_VERSION             = 1.3.2
LIBOGG_PKG_ARCH                = $(TOOLCHAIN)
LIBOGG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBOGG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBOGG_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBOGG_PKG_SHORT_DESCRIPTION   = Ogg Bitstream library
LIBOGG_PKG_URL                 = $(BUG_URL)
LIBOGG_PKG_LICENSE             = Xiph.org
LIBOGG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBOGG_PKG_NAME)-pkg-description
LIBOGG_PKG_DESCRIPTION_FILE_IN = $(LIBOGG_PKG_NAME)-pkg-description.in
LIBOGG_PKG_INSTALL_SCRIPT      = $(LIBOGG_PKG_NAME)-pkg-install.sh

LIBOGG_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBOGG_PKG_NAME)-package

pkg_basename     = $(LIBOGG_PKG_NAME)-$(LIBOGG_PKG_VERSION)-$(LIBOGG_PKG_ARCH)-$(LIBOGG_PKG_DISTRO_NAME)-$(LIBOGG_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBOGG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBOGG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBOGG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBOGG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBOGG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBOGG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBOGG_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(LIBOGG_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv libogg *.txt *.html *.png html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README \
	         $(LIBOGG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LIBOGG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBOGG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libogg.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBOGG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libogg.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libogg.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" ogg.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBOGG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBOGG_PKG_DESCRIPTION_FILE): $(LIBOGG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBOGG_PKG_DESCRIPTION_FILE) $(LIBOGG_PKG_INSTALL_SCRIPT)
	@cp $(LIBOGG_PKG_DESCRIPTION_FILE) $(LIBOGG_PKG)/.DESCRIPTION
	@cp $(LIBOGG_PKG_INSTALL_SCRIPT) $(LIBOGG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBOGG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBOGG_PKG_NAME)"                            >  $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBOGG_PKG_VERSION)"                          >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBOGG_PKG_ARCH)"                               >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBOGG_PKG_DISTRO_NAME)"                  >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBOGG_PKG_DISTRO_VERSION)"                >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBOGG_PKG_GROUP)"                             >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBOGG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBOGG_PKG_URL)"                                 >> $(LIBOGG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBOGG_PKG_LICENSE)"                         >> $(LIBOGG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBOGG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
