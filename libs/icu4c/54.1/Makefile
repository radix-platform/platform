
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


SOURCE_REQUIRES    = sources/packages/l/icu4c

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.24
else
REQUIRES           = libs/glibc/2.24-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 54.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/icu4c/icu4c-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/icu4c-$(version)
src_dir_name       = icu4c-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_host_dir     = $(TARGET_BUILD_DIR)/build_host
build_target_dir   = $(TARGET_BUILD_DIR)/build_target

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICU4C_PKG_NAME                = icu4c
ICU4C_PKG_VERSION             = 54.1
ICU4C_PKG_ARCH                = $(TOOLCHAIN)
ICU4C_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICU4C_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICU4C_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
ICU4C_PKG_SHORT_DESCRIPTION   = International Components for Unicode
ICU4C_PKG_URL                 = $(BUG_URL)
ICU4C_PKG_LICENSE             = ICU
ICU4C_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICU4C_PKG_NAME)-pkg-description
ICU4C_PKG_DESCRIPTION_FILE_IN = $(ICU4C_PKG_NAME)-pkg-description.in
ICU4C_PKG_INSTALL_SCRIPT      = $(ICU4C_PKG_NAME)-pkg-install.sh

ICU4C_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICU4C_PKG_NAME)-package

pkg_basename     = $(ICU4C_PKG_NAME)-$(ICU4C_PKG_VERSION)-$(ICU4C_PKG_ARCH)-$(ICU4C_PKG_DISTRO_NAME)-$(ICU4C_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ICU4C_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-samples
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

extra_configure_switches += --with-cross-build=$(CURDIR)/$(build_host_dir)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR)/source/config ; \
	   sed -i "s,^LDFLAGSICUDT,#LDFLAGSICUDT," mh-linux ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_host_dir)
	@mkdir -p $(build_target_dir)
	@cd $(build_host_dir) && $(CURDIR)/$(SRC_DIR)/source/runConfigureICU Linux
	@cd $(build_host_dir) && $(MAKE)
	@cd $(build_target_dir) && \
	  $(BUILD_ENVIRONMENT) $(CURDIR)/$(SRC_DIR)/source/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_target_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ICU4C_PKG)
	@cd $(build_target_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(ICU4C_PKG)/usr/share/man ]; then \
	  ( cd $(ICU4C_PKG)/usr/share/man ; \
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
	@mkdir -p $(ICU4C_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/license.html $(SRC_DIR)/icu4c.css \
	       $(ICU4C_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ICU4C_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a *.html *.css \
	         $(ICU4C_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= change permissions of *.a files =======
	@( cd $(ICU4C_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 0644 *.a ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ICU4C_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" icu-i18n.pc icu-io.pc icu-le.pc icu-lx.pc icu-uc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ICU4C_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ICU4C_PKG_DESCRIPTION_FILE): $(ICU4C_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICU4C_PKG_DESCRIPTION_FILE) $(ICU4C_PKG_INSTALL_SCRIPT)
	@cp $(ICU4C_PKG_DESCRIPTION_FILE) $(ICU4C_PKG)/.DESCRIPTION
	@cp $(ICU4C_PKG_INSTALL_SCRIPT) $(ICU4C_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICU4C_PKG)/.REQUIRES
	@echo "pkgname=$(ICU4C_PKG_NAME)"                            >  $(ICU4C_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICU4C_PKG_VERSION)"                          >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "arch=$(ICU4C_PKG_ARCH)"                               >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICU4C_PKG_DISTRO_NAME)"                  >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICU4C_PKG_DISTRO_VERSION)"                >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "group=$(ICU4C_PKG_GROUP)"                             >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICU4C_PKG_SHORT_DESCRIPTION)\"" >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "url=$(ICU4C_PKG_URL)"                                 >> $(ICU4C_PKG)/.PKGINFO ; \
	 echo "license=$(ICU4C_PKG_LICENSE)"                         >> $(ICU4C_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ICU4C_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
