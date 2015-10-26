
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/gsm

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.21
else
REQUIRES           = libs/glibc/2.21-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.13
arch_version       = 1.0-pl13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/gsm/gsm-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gsm-$(arch_version)
doc_dir_name       = gsm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

gsm_pc_in          = $(CURDIR)/gsm-pc/gsm.pc.in


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBGSM_PKG_NAME                = gsm
LIBGSM_PKG_VERSION             = 1.0.13
LIBGSM_PKG_ARCH                = $(TOOLCHAIN)
LIBGSM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBGSM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBGSM_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBGSM_PKG_SHORT_DESCRIPTION   = GSM 06.10 lossy speech compression
LIBGSM_PKG_URL                 = $(BUG_URL)
LIBGSM_PKG_LICENSE             = BSD-style
LIBGSM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBGSM_PKG_NAME)-pkg-description
LIBGSM_PKG_DESCRIPTION_FILE_IN = $(LIBGSM_PKG_NAME)-pkg-description.in
LIBGSM_PKG_INSTALL_SCRIPT      = $(LIBGSM_PKG_NAME)-pkg-install.sh

LIBGSM_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBGSM_PKG_NAME)-package

pkg_basename     = $(LIBGSM_PKG_NAME)-$(LIBGSM_PKG_VERSION)-$(LIBGSM_PKG_ARCH)-$(LIBGSM_PKG_DISTRO_NAME)-$(LIBGSM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


build_env    = CCFLAGS="-c -fPIC $(CFLAGS)"

install_env  = INSTALL_ROOT="$(LIBGSM_PKG)/usr"
install_env += GSM_INSTALL_LIB="$(LIBGSM_PKG)/usr/lib$(LIBSUFFIX)"
install_env += GSM_INSTALL_INC="$(LIBGSM_PKG)/usr/include/gsm"
install_env += GSM_INSTALL_MAN="$(LIBGSM_PKG)/usr/share/man/man3"
install_env += TOAST_INSTALL_BIN="$(LIBGSM_PKG)/usr/bin"
install_env += TOAST_INSTALL_MAN="$(LIBGSM_PKG)/usr/share/man/man1"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(build_env)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBGSM_PKG)/usr/bin
	@mkdir -p $(LIBGSM_PKG)/usr/include/gsm
	@mkdir -p $(LIBGSM_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(LIBGSM_PKG)/usr/share/man/man{1,3}
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(install_env) install
	@( cd $(LIBGSM_PKG)/usr/share/man/man1 ; \
	   ln -sf toast.1 tcat.1 ; \
	   ln -sf toast.1 untoast.1 ; \
	 )
	@chmod 0644 $(LIBGSM_PKG)/usr/lib$(LIBSUFFIX)/libgsm.a
	# ======= Create package config file =======
	@mkdir -p $(LIBGSM_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@sed -e "s,/lib,/lib$(LIBSUFFIX)," $(gsm_pc_in) \
	  > $(LIBGSM_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig/gsm.pc
	# ======= Install Documentation =======
	@if [ -d $(LIBGSM_PKG)/usr/share/man ]; then \
	  ( cd $(LIBGSM_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBGSM_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYRIGHT \
	       $(LIBGSM_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LIBGSM_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYRIGHT INSTALL MACHINES MANIFEST README \
	         $(LIBGSM_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBGSM_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBGSM_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gsm.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBGSM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBGSM_PKG_DESCRIPTION_FILE): $(LIBGSM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBGSM_PKG_DESCRIPTION_FILE) $(LIBGSM_PKG_INSTALL_SCRIPT)
	@cp $(LIBGSM_PKG_DESCRIPTION_FILE) $(LIBGSM_PKG)/.DESCRIPTION
	@cp $(LIBGSM_PKG_INSTALL_SCRIPT) $(LIBGSM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBGSM_PKG)/.REQUIRES
	@echo "pkgname=$(LIBGSM_PKG_NAME)"                            >  $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBGSM_PKG_VERSION)"                          >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBGSM_PKG_ARCH)"                               >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBGSM_PKG_DISTRO_NAME)"                  >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBGSM_PKG_DISTRO_VERSION)"                >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "group=$(LIBGSM_PKG_GROUP)"                             >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBGSM_PKG_SHORT_DESCRIPTION)\"" >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "url=$(LIBGSM_PKG_URL)"                                 >> $(LIBGSM_PKG)/.PKGINFO ; \
	 echo "license=$(LIBGSM_PKG_LICENSE)"                         >> $(LIBGSM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBGSM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
