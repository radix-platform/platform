
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


SOURCE_REQUIRES    = sources/GNU/which

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.26
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.20
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/which/which-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/which-$(version)
src_dir_name       = which-$(version)
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
WHICH_PKG_NAME                = which
WHICH_PKG_VERSION             = 2.20
WHICH_PKG_ARCH                = $(TOOLCHAIN)
WHICH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WHICH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WHICH_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
WHICH_PKG_SHORT_DESCRIPTION   = shows the full path to shell commands
WHICH_PKG_URL                 = $(BUG_URL)
WHICH_PKG_LICENSE             = GPLv3
WHICH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WHICH_PKG_NAME)-pkg-description
WHICH_PKG_DESCRIPTION_FILE_IN = $(WHICH_PKG_NAME)-pkg-description.in
WHICH_PKG_INSTALL_SCRIPT      = $(WHICH_PKG_NAME)-pkg-install.sh

WHICH_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WHICH_PKG_NAME)-package

pkg_basename     = $(WHICH_PKG_NAME)-$(WHICH_PKG_VERSION)-$(WHICH_PKG_ARCH)-$(WHICH_PKG_DISTRO_NAME)-$(WHICH_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(WHICH_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += --disable-iberty
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
	@mkdir -p $(WHICH_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(WHICH_PKG)/bin
	@mv $(WHICH_PKG)/usr/bin/which $(WHICH_PKG)/bin
	@( cd $(WHICH_PKG)/usr/bin ; \
	   ln -sf ../../bin/which . ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(WHICH_PKG)/usr/share/info/dir
	@gzip -9 $(WHICH_PKG)/usr/share/info/*
	@if [ -d $(WHICH_PKG)/usr/share/man ]; then \
	  ( cd $(WHICH_PKG)/usr/share/man ; \
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
	@mkdir -p $(WHICH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(WHICH_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WHICH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING EXAMPLES INSTALL NEWS README* \
	         $(WHICH_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WHICH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WHICH_PKG))
	# ======= Strip binaries =======
	@( cd $(WHICH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(WHICH_PKG_DESCRIPTION_FILE): $(WHICH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WHICH_PKG_DESCRIPTION_FILE) $(WHICH_PKG_INSTALL_SCRIPT)
	@cp $(WHICH_PKG_DESCRIPTION_FILE) $(WHICH_PKG)/.DESCRIPTION
	@cp $(WHICH_PKG_INSTALL_SCRIPT) $(WHICH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WHICH_PKG)/.REQUIRES
	@echo "pkgname=$(WHICH_PKG_NAME)"                            >  $(WHICH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WHICH_PKG_VERSION)"                          >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "arch=$(WHICH_PKG_ARCH)"                               >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "distroname=$(WHICH_PKG_DISTRO_NAME)"                  >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "distrover=$(WHICH_PKG_DISTRO_VERSION)"                >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "group=$(WHICH_PKG_GROUP)"                             >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WHICH_PKG_SHORT_DESCRIPTION)\"" >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "url=$(WHICH_PKG_URL)"                                 >> $(WHICH_PKG)/.PKGINFO ; \
	 echo "license=$(WHICH_PKG_LICENSE)"                         >> $(WHICH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(WHICH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
