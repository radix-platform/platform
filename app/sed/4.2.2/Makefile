
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/sed

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.2.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/sed/sed-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sed-$(version)
src_dir_name       = sed-$(version)
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
SED_PKG_NAME                = sed
SED_PKG_VERSION             = 4.2.2
SED_PKG_ARCH                = $(TOOLCHAIN)
SED_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SED_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SED_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
SED_PKG_SHORT_DESCRIPTION   = stream editor
SED_PKG_URL                 = $(BUG_URL)
SED_PKG_LICENSE             = GPLv2
SED_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SED_PKG_NAME)-pkg-description
SED_PKG_DESCRIPTION_FILE_IN = $(SED_PKG_NAME)-pkg-description.in
SED_PKG_INSTALL_SCRIPT      = $(SED_PKG_NAME)-pkg-install.sh

SED_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SED_PKG_NAME)-package

pkg_basename     = $(SED_PKG_NAME)-$(SED_PKG_VERSION)-$(SED_PKG_ARCH)-$(SED_PKG_DISTRO_NAME)-$(SED_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SED_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


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
	@mkdir -p $(SED_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -f $(SED_PKG)/usr/share/info/dir
	@gzip -9 $(SED_PKG)/usr/share/info/*
	@mkdir -p $(SED_PKG)/bin
	@mv $(SED_PKG)/usr/bin/sed $(SED_PKG)/bin
	@( cd $(SED_PKG)/usr/bin ; ln -sf ../../bin/sed . )
	# ======= Install Documentation =======
	@if [ -d $(SED_PKG)/usr/share/man ]; then \
	  ( cd $(SED_PKG)/usr/share/man ; \
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
	@mkdir -p $(SED_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* \
	       $(SED_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(SED_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGS COPYING* INSTALL NEWS README* THANKS \
	       $(SED_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SED_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SED_PKG))
	# ======= Strip binaries =======
	@( cd $(SED_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(SED_PKG_DESCRIPTION_FILE): $(SED_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SED_PKG_DESCRIPTION_FILE) $(SED_PKG_INSTALL_SCRIPT)
	@cp $(SED_PKG_DESCRIPTION_FILE) $(SED_PKG)/.DESCRIPTION
	@cp $(SED_PKG_INSTALL_SCRIPT) $(SED_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SED_PKG)/.REQUIRES
	@echo "pkgname=$(SED_PKG_NAME)"                            >  $(SED_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SED_PKG_VERSION)"                          >> $(SED_PKG)/.PKGINFO ; \
	 echo "arch=$(SED_PKG_ARCH)"                               >> $(SED_PKG)/.PKGINFO ; \
	 echo "distroname=$(SED_PKG_DISTRO_NAME)"                  >> $(SED_PKG)/.PKGINFO ; \
	 echo "distrover=$(SED_PKG_DISTRO_VERSION)"                >> $(SED_PKG)/.PKGINFO ; \
	 echo "group=$(SED_PKG_GROUP)"                             >> $(SED_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SED_PKG_SHORT_DESCRIPTION)\"" >> $(SED_PKG)/.PKGINFO ; \
	 echo "url=$(SED_PKG_URL)"                                 >> $(SED_PKG)/.PKGINFO ; \
	 echo "license=$(SED_PKG_LICENSE)"                         >> $(SED_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SED_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
