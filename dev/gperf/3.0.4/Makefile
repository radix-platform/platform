
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


SOURCE_REQUIRES    = sources/GNU/gperf

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.25
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.0.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/gperf/gperf-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gperf-$(version)
src_dir_name       = gperf-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPERF_PKG_NAME                = gperf
GPERF_PKG_VERSION             = 3.0.4
GPERF_PKG_ARCH                = $(TOOLCHAIN)
GPERF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPERF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPERF_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GPERF_PKG_SHORT_DESCRIPTION   = perfect hash function generator
GPERF_PKG_URL                 = $(BUG_URL)
GPERF_PKG_LICENSE             = GPLv3
GPERF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPERF_PKG_NAME)-pkg-description
GPERF_PKG_DESCRIPTION_FILE_IN = $(GPERF_PKG_NAME)-pkg-description.in
GPERF_PKG_INSTALL_SCRIPT      = $(GPERF_PKG_NAME)-pkg-install.sh

GPERF_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPERF_PKG_NAME)-package

pkg_basename     = $(GPERF_PKG_NAME)-$(GPERF_PKG_VERSION)-$(GPERF_PKG_ARCH)-$(GPERF_PKG_DISTRO_NAME)-$(GPERF_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GPERF_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc


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
	@mkdir -p $(GPERF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(GPERF_PKG)/usr/share/info/dir
	@gzip -9 $(GPERF_PKG)/usr/share/info/*
	@if [ -d $(GPERF_PKG)/usr/share/man ]; then \
	  ( cd $(GPERF_PKG)/usr/share/man ; \
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
	@mkdir -p $(GPERF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GPERF_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GPERF_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(GPERF_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv gperf.html html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* \
	         $(GPERF_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GPERF_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GPERF_PKG))
	# ======= Strip binaries =======
	@( cd $(GPERF_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(GPERF_PKG_DESCRIPTION_FILE): $(GPERF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPERF_PKG_DESCRIPTION_FILE) $(GPERF_PKG_INSTALL_SCRIPT)
	@cp $(GPERF_PKG_DESCRIPTION_FILE) $(GPERF_PKG)/.DESCRIPTION
	@cp $(GPERF_PKG_INSTALL_SCRIPT) $(GPERF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPERF_PKG)/.REQUIRES
	@echo "pkgname=$(GPERF_PKG_NAME)"                            >  $(GPERF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPERF_PKG_VERSION)"                          >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "arch=$(GPERF_PKG_ARCH)"                               >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPERF_PKG_DISTRO_NAME)"                  >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPERF_PKG_DISTRO_VERSION)"                >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "group=$(GPERF_PKG_GROUP)"                             >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPERF_PKG_SHORT_DESCRIPTION)\"" >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "url=$(GPERF_PKG_URL)"                                 >> $(GPERF_PKG)/.PKGINFO ; \
	 echo "license=$(GPERF_PKG_LICENSE)"                         >> $(GPERF_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GPERF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
