
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


SOURCE_REQUIRES    = sources/GNU/tar

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.26
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/tar/tar-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/tar-$(version)
src_dir_name       = tar-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

man_pages_dir      = $(CURDIR)/man

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TAR_PKG_NAME                = tar
TAR_PKG_VERSION             = 1.26
TAR_PKG_ARCH                = $(TOOLCHAIN)
TAR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TAR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TAR_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
TAR_PKG_SHORT_DESCRIPTION   = archiving utility
TAR_PKG_URL                 = $(BUG_URL)
TAR_PKG_LICENSE             = GPLv2
TAR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TAR_PKG_NAME)-pkg-description
TAR_PKG_DESCRIPTION_FILE_IN = $(TAR_PKG_NAME)-pkg-description.in
TAR_PKG_INSTALL_SCRIPT      = $(TAR_PKG_NAME)-pkg-install.sh

TAR_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TAR_PKG_NAME)-package

pkg_basename     = $(TAR_PKG_NAME)-$(TAR_PKG_VERSION)-$(TAR_PKG_ARCH)-$(TAR_PKG_DISTRO_NAME)-$(TAR_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(TAR_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-backup-scripts


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TAR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(TAR_PKG)/bin
	@mv $(TAR_PKG)/usr/bin/tar $(TAR_PKG)/bin
	@( cd $(TAR_PKG)/usr/bin ; ln -sf ../../bin/tar . )
	@( cd $(TAR_PKG)/bin ; ln -sf tar tar-$(version) )
	# ======= Support "historic" rmt locations =======
	@mkdir -p $(TAR_PKG)/{etc,sbin}
	@( cd $(TAR_PKG)/etc           ; \
	   ln -sf ../usr/libexec/rmt . ; \
	   cd $(TAR_PKG)/sbin          ; \
	   ln -sf ../usr/libexec/rmt . ; \
	 )
	# ======= Install Documentation =======
	@mkdir -p $(TAR_PKG)/usr/share/man/man{1,8}
	@cat $(man_pages_dir)/tar.1 > $(TAR_PKG)/usr/share/man/man1/tar.1
	@cat $(man_pages_dir)/rmt.8 > $(TAR_PKG)/usr/share/man/man8/rmt.8
	@rm -f $(TAR_PKG)/usr/share/info/dir
	@gzip -9 $(TAR_PKG)/usr/share/info/*
	@if [ -d $(TAR_PKG)/usr/share/man ]; then \
	  ( cd $(TAR_PKG)/usr/share/man ; \
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
	@mkdir -p $(TAR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(TAR_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TAR_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING* INSTALL NEWS README THANKS TODO \
	         $(TAR_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(TAR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TAR_PKG))
	# ======= Strip binaries =======
	@( cd $(TAR_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(TAR_PKG_DESCRIPTION_FILE): $(TAR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TAR_PKG_DESCRIPTION_FILE) $(TAR_PKG_INSTALL_SCRIPT)
	@cp $(TAR_PKG_DESCRIPTION_FILE) $(TAR_PKG)/.DESCRIPTION
	@cp $(TAR_PKG_INSTALL_SCRIPT) $(TAR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TAR_PKG)/.REQUIRES
	@echo "pkgname=$(TAR_PKG_NAME)"                            >  $(TAR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TAR_PKG_VERSION)"                          >> $(TAR_PKG)/.PKGINFO ; \
	 echo "arch=$(TAR_PKG_ARCH)"                               >> $(TAR_PKG)/.PKGINFO ; \
	 echo "distroname=$(TAR_PKG_DISTRO_NAME)"                  >> $(TAR_PKG)/.PKGINFO ; \
	 echo "distrover=$(TAR_PKG_DISTRO_VERSION)"                >> $(TAR_PKG)/.PKGINFO ; \
	 echo "group=$(TAR_PKG_GROUP)"                             >> $(TAR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TAR_PKG_SHORT_DESCRIPTION)\"" >> $(TAR_PKG)/.PKGINFO ; \
	 echo "url=$(TAR_PKG_URL)"                                 >> $(TAR_PKG)/.PKGINFO ; \
	 echo "license=$(TAR_PKG_LICENSE)"                         >> $(TAR_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TAR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
