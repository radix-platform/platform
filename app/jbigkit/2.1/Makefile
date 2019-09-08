
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


SOURCE_REQUIRES    = sources/packages/a/jbigkit

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


version            = 2.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/jbigkit/jbigkit-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/jbigkit-$(version)
src_dir_name       = jbigkit-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JBIGKIT_PKG_NAME                = jbigkit
JBIGKIT_PKG_VERSION             = 2.1
JBIGKIT_PKG_ARCH                = $(TOOLCHAIN)
JBIGKIT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JBIGKIT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JBIGKIT_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
JBIGKIT_PKG_SHORT_DESCRIPTION   = lossless image compression library
JBIGKIT_PKG_URL                 = $(BUG_URL)
JBIGKIT_PKG_LICENSE             = GPLv2
JBIGKIT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JBIGKIT_PKG_NAME)-pkg-description
JBIGKIT_PKG_DESCRIPTION_FILE_IN = $(JBIGKIT_PKG_NAME)-pkg-description.in
JBIGKIT_PKG_INSTALL_SCRIPT      = $(JBIGKIT_PKG_NAME)-pkg-install.sh

JBIGKIT_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JBIGKIT_PKG_NAME)-package

pkg_basename     = $(JBIGKIT_PKG_NAME)-$(JBIGKIT_PKG_VERSION)-$(JBIGKIT_PKG_ARCH)-$(JBIGKIT_PKG_DISTRO_NAME)-$(JBIGKIT_PKG_DISTRO_VERSION)

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


CFLAGS += -fPIC -W -Wall -Wno-unused-result -I../libjbig


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JBIGKIT_PKG)/usr/bin
	@mkdir -p $(JBIGKIT_PKG)/usr/include
	@mkdir -p $(JBIGKIT_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(JBIGKIT_PKG)/usr/share/man/man1
	@( cd $(SRC_DIR)/libjbig ; \
	   cp -a libjbig.a libjbig85.a $(JBIGKIT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   cp -a jbig.h jbig_ar.h jbig85.h $(JBIGKIT_PKG)/usr/include ; \
	 )
	@( cd $(SRC_DIR)/pbmtools ; \
	   cp -a jbgtopbm pbmtojbg jbgtopbm85 pbmtojbg85 $(JBIGKIT_PKG)/usr/bin ; \
	   for file in *.1 ; do \
	     cat $$file | gzip -9c > $(JBIGKIT_PKG)/usr/share/man/man1/$$file.gz ; \
	   done ; \
	 )
	@chmod 0755 $(JBIGKIT_PKG)/usr/bin/*
	@chmod 0644 $(JBIGKIT_PKG)/usr/lib$(LIBSUFFIX)/*
	@chmod 0644 $(JBIGKIT_PKG)/usr/include/*
	# ======= Install Documentation =======
	@mkdir -p $(JBIGKIT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(JBIGKIT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(JBIGKIT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE CHANGES COPYING INSTALL TODO \
	         $(JBIGKIT_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JBIGKIT_PKG))
	# ======= Strip binaries =======
	@( cd $(JBIGKIT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JBIGKIT_PKG_DESCRIPTION_FILE): $(JBIGKIT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JBIGKIT_PKG_DESCRIPTION_FILE) $(JBIGKIT_PKG_INSTALL_SCRIPT)
	@cp $(JBIGKIT_PKG_DESCRIPTION_FILE) $(JBIGKIT_PKG)/.DESCRIPTION
	@cp $(JBIGKIT_PKG_INSTALL_SCRIPT) $(JBIGKIT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JBIGKIT_PKG)/.REQUIRES
	@echo "pkgname=$(JBIGKIT_PKG_NAME)"                            >  $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JBIGKIT_PKG_VERSION)"                          >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "arch=$(JBIGKIT_PKG_ARCH)"                               >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "distroname=$(JBIGKIT_PKG_DISTRO_NAME)"                  >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "distrover=$(JBIGKIT_PKG_DISTRO_VERSION)"                >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "group=$(JBIGKIT_PKG_GROUP)"                             >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JBIGKIT_PKG_SHORT_DESCRIPTION)\"" >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "url=$(JBIGKIT_PKG_URL)"                                 >> $(JBIGKIT_PKG)/.PKGINFO ; \
	 echo "license=$(JBIGKIT_PKG_LICENSE)"                         >> $(JBIGKIT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(JBIGKIT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
