
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


SOURCE_REQUIRES    = sources/packages/l/expat

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


version            = 2.1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/expat/expat-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/expat-$(version)
src_dir_name       = expat-$(version)
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
EXPAT_PKG_NAME                = expat
EXPAT_PKG_VERSION             = 2.1.1
EXPAT_PKG_ARCH                = $(TOOLCHAIN)
EXPAT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EXPAT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EXPAT_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
EXPAT_PKG_SHORT_DESCRIPTION   = C library for parsing XML
EXPAT_PKG_URL                 = $(BUG_URL)
EXPAT_PKG_LICENSE             = GPLv2
EXPAT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EXPAT_PKG_NAME)-pkg-description
EXPAT_PKG_DESCRIPTION_FILE_IN = $(EXPAT_PKG_NAME)-pkg-description.in
EXPAT_PKG_INSTALL_SCRIPT      = $(EXPAT_PKG_NAME)-pkg-install.sh

EXPAT_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EXPAT_PKG_NAME)-package

pkg_basename     = $(EXPAT_PKG_NAME)-$(EXPAT_PKG_VERSION)-$(EXPAT_PKG_ARCH)-$(EXPAT_PKG_DISTRO_NAME)-$(EXPAT_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(EXPAT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
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
	@mkdir -p $(EXPAT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(EXPAT_PKG)/usr/share/man ]; then \
	  ( cd $(EXPAT_PKG)/usr/share/man ; \
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
	@mkdir -p $(EXPAT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(EXPAT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(EXPAT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README doc/*.png doc/*.css doc/*.html \
	         $(EXPAT_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r Changes ]; then \
	     DOCSDIR=`echo $(EXPAT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat Changes | head -n 1000 > $$DOCSDIR/Changes ; \
	     touch -r Changes $$DOCSDIR/Changes ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(EXPAT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexpat.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(EXPAT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexpat.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexpat.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" expat.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(EXPAT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(EXPAT_PKG_DESCRIPTION_FILE): $(EXPAT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EXPAT_PKG_DESCRIPTION_FILE) $(EXPAT_PKG_INSTALL_SCRIPT)
	@cp $(EXPAT_PKG_DESCRIPTION_FILE) $(EXPAT_PKG)/.DESCRIPTION
	@cp $(EXPAT_PKG_INSTALL_SCRIPT) $(EXPAT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EXPAT_PKG)/.REQUIRES
	@echo "pkgname=$(EXPAT_PKG_NAME)"                            >  $(EXPAT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EXPAT_PKG_VERSION)"                          >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "arch=$(EXPAT_PKG_ARCH)"                               >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "distroname=$(EXPAT_PKG_DISTRO_NAME)"                  >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "distrover=$(EXPAT_PKG_DISTRO_VERSION)"                >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "group=$(EXPAT_PKG_GROUP)"                             >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EXPAT_PKG_SHORT_DESCRIPTION)\"" >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "url=$(EXPAT_PKG_URL)"                                 >> $(EXPAT_PKG)/.PKGINFO ; \
	 echo "license=$(EXPAT_PKG_LICENSE)"                         >> $(EXPAT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(EXPAT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
