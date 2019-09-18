
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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


SOURCE_REQUIRES    = sources/packages/a/chrpath

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
REQUIRES           = libs/glibc/2.28
endif

# ======= __END_OF_REQUIRES__ =======


version             = 0.16
tar_gz_archive      = $(SRC_PACKAGE_PATH)/packages/a/chrpath/chrpath-$(version).tar.gz
SRC_ARCHIVE         = $(tar_gz_archive)
SRC_DIR             = $(TARGET_BUILD_DIR)/chrpath-$(version)
src_dir_name        = chrpath-$(version)
src_done            = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir           = $(TARGET_BUILD_DIR)/build
build_target        = $(TARGET_BUILD_DIR)/.build_done
install_target      = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CHRPATH_PKG_NAME                = chrpath
CHRPATH_PKG_VERSION             = 0.16
CHRPATH_PKG_ARCH                = $(TOOLCHAIN)
CHRPATH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CHRPATH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CHRPATH_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
CHRPATH_PKG_SHORT_DESCRIPTION   = Change the RPATH or RUNPATH of ELF binaries
CHRPATH_PKG_URL                 = $(BUG_URL)
CHRPATH_PKG_LICENSE             = GPLv2
CHRPATH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CHRPATH_PKG_NAME)-pkg-description
CHRPATH_PKG_DESCRIPTION_FILE_IN = $(CHRPATH_PKG_NAME)-pkg-description.in
CHRPATH_PKG_INSTALL_SCRIPT      = $(CHRPATH_PKG_NAME)-pkg-install.sh

CHRPATH_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CHRPATH_PKG_NAME)-package

pkg_basename     = $(CHRPATH_PKG_NAME)-$(CHRPATH_PKG_VERSION)-$(CHRPATH_PKG_ARCH)-$(CHRPATH_PKG_DISTRO_NAME)-$(CHRPATH_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(CHRPATH_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CHRPATH_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot) docdir=/usr/share/doc/$(src_dir_name)
	# ======= Install Documentation =======
	@if [ -d $(CHRPATH_PKG)/usr/share/man ]; then \
	  ( cd $(CHRPATH_PKG)/usr/share/man ; \
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
	@mkdir -p $(CHRPATH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(CHRPATH_PKG)/usr/doc/$(src_dir_name)
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CHRPATH_PKG))
	# ======= Strip binaries =======
	@( cd $(CHRPATH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(CHRPATH_PKG_DESCRIPTION_FILE): $(CHRPATH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CHRPATH_PKG_DESCRIPTION_FILE) $(CHRPATH_PKG_INSTALL_SCRIPT)
	@cp $(CHRPATH_PKG_DESCRIPTION_FILE) $(CHRPATH_PKG)/.DESCRIPTION
	@cp $(CHRPATH_PKG_INSTALL_SCRIPT) $(CHRPATH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CHRPATH_PKG)/.REQUIRES
	@echo "pkgname=$(CHRPATH_PKG_NAME)"                            >  $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CHRPATH_PKG_VERSION)"                          >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "arch=$(CHRPATH_PKG_ARCH)"                               >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "distroname=$(CHRPATH_PKG_DISTRO_NAME)"                  >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "distrover=$(CHRPATH_PKG_DISTRO_VERSION)"                >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "group=$(CHRPATH_PKG_GROUP)"                             >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CHRPATH_PKG_SHORT_DESCRIPTION)\"" >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "url=$(CHRPATH_PKG_URL)"                                 >> $(CHRPATH_PKG)/.PKGINFO ; \
	 echo "license=$(CHRPATH_PKG_LICENSE)"                         >> $(CHRPATH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CHRPATH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
