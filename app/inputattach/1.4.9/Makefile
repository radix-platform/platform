
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


SOURCE_REQUIRES    = sources/packages/a/linuxconsole

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


version            = 1.4.9
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/linuxconsole/linuxconsoletools-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/linuxconsoletools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
INPUTATTACH_PKG_NAME                = inputattach
INPUTATTACH_PKG_VERSION             = 1.4.9
INPUTATTACH_PKG_ARCH                = $(TOOLCHAIN)
INPUTATTACH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
INPUTATTACH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
INPUTATTACH_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
INPUTATTACH_PKG_SHORT_DESCRIPTION   = utility for legacy serial devices
INPUTATTACH_PKG_URL                 = $(BUG_URL)
INPUTATTACH_PKG_LICENSE             = GPLv2
INPUTATTACH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(INPUTATTACH_PKG_NAME)-pkg-description
INPUTATTACH_PKG_DESCRIPTION_FILE_IN = $(INPUTATTACH_PKG_NAME)-pkg-description.in
INPUTATTACH_PKG_INSTALL_SCRIPT      = $(INPUTATTACH_PKG_NAME)-pkg-install.sh

INPUTATTACH_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(INPUTATTACH_PKG_NAME)-package

pkg_basename     = $(INPUTATTACH_PKG_NAME)-$(INPUTATTACH_PKG_VERSION)-$(INPUTATTACH_PKG_ARCH)-$(INPUTATTACH_PKG_DISTRO_NAME)-$(INPUTATTACH_PKG_DISTRO_VERSION)

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



####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/utils && $(BUILD_ENVIRONMENT) $(CC) inputattach.c -o inputattach
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(INPUTATTACH_PKG)/usr/bin
	@cd $(SRC_DIR)/utils && cp -a inputattach $(INPUTATTACH_PKG)/usr/bin
	@chmod 755 $(INPUTATTACH_PKG)/usr/bin/*
	# ======= Install Documentation =======
	@mkdir -p $(INPUTATTACH_PKG)/usr/share/man/man1
	@cd $(SRC_DIR)/docs && cp -a inputattach.1 $(INPUTATTACH_PKG)/usr/share/man/man1
	@chmod 644 $(INPUTATTACH_PKG)/usr/share/man/man1/inputattach.1
	@if [ -d $(INPUTATTACH_PKG)/usr/share/man ]; then \
	  ( cd $(INPUTATTACH_PKG)/usr/share/man ; \
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
	@mkdir -p $(INPUTATTACH_PKG)/usr/doc/inputattach-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(INPUTATTACH_PKG)/usr/doc/inputattach-$(version) \
	 )
	@mkdir -p $(INPUTATTACH_PKG)/usr/share/doc/inputattach-$(version)
	@( cd $(SRC_DIR) ; \
	   cp -a NEWS README utils/serio-ids.h \
	         $(INPUTATTACH_PKG)/usr/share/doc/inputattach-$(version) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(INPUTATTACH_PKG))
	# ======= Strip binaries =======
	@( cd $(INPUTATTACH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(INPUTATTACH_PKG_DESCRIPTION_FILE): $(INPUTATTACH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(INPUTATTACH_PKG_DESCRIPTION_FILE) $(INPUTATTACH_PKG_INSTALL_SCRIPT)
	@cp $(INPUTATTACH_PKG_DESCRIPTION_FILE) $(INPUTATTACH_PKG)/.DESCRIPTION
	@cp $(INPUTATTACH_PKG_INSTALL_SCRIPT) $(INPUTATTACH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(INPUTATTACH_PKG)/.REQUIRES
	@echo "pkgname=$(INPUTATTACH_PKG_NAME)"                            >  $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(INPUTATTACH_PKG_VERSION)"                          >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "arch=$(INPUTATTACH_PKG_ARCH)"                               >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "distroname=$(INPUTATTACH_PKG_DISTRO_NAME)"                  >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "distrover=$(INPUTATTACH_PKG_DISTRO_VERSION)"                >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "group=$(INPUTATTACH_PKG_GROUP)"                             >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(INPUTATTACH_PKG_SHORT_DESCRIPTION)\"" >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "url=$(INPUTATTACH_PKG_URL)"                                 >> $(INPUTATTACH_PKG)/.PKGINFO ; \
	 echo "license=$(INPUTATTACH_PKG_LICENSE)"                         >> $(INPUTATTACH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(INPUTATTACH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
