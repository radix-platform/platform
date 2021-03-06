
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/alsa/lib

REQUIRES           = libs/alsa-lib/1.0.28
REQUIRES          += dev/python2/2.7.11-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.28
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/alsa/lib/alsa-lib-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/alsa-lib-$(version)
src_dir_name       = alsa-lib-$(version)
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
ALSA_LIB_32_PKG_NAME                = alsa-lib-x32
ALSA_LIB_32_PKG_VERSION             = 1.0.28
ALSA_LIB_32_PKG_ARCH                = $(TOOLCHAIN)
ALSA_LIB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ALSA_LIB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ALSA_LIB_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
ALSA_LIB_32_PKG_SHORT_DESCRIPTION   = Advanced Linux Sound Architecture library
ALSA_LIB_32_PKG_URL                 = $(BUG_URL)
ALSA_LIB_32_PKG_LICENSE             = LGPLv2.1
ALSA_LIB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ALSA_LIB_32_PKG_NAME)-pkg-description
ALSA_LIB_32_PKG_DESCRIPTION_FILE_IN = $(ALSA_LIB_32_PKG_NAME)-pkg-description.in
ALSA_LIB_32_PKG_INSTALL_SCRIPT      = $(ALSA_LIB_32_PKG_NAME)-pkg-install.sh

ALSA_LIB_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ALSA_LIB_32_PKG_NAME)-package

pkg_basename     = $(ALSA_LIB_32_PKG_NAME)-$(ALSA_LIB_32_PKG_VERSION)-$(ALSA_LIB_32_PKG_ARCH)-$(ALSA_LIB_32_PKG_DISTRO_NAME)-$(ALSA_LIB_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ALSA_LIB_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-pythonincludes=-I$(TARGET_DEST_DIR)/usr/include/python2.7


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ALSA_LIB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(ALSA_LIB_32_PKG)/usr/bin/32
	@( cd $(ALSA_LIB_32_PKG)/usr/bin ; mv aserver 32 )
	@rm -rf $(ALSA_LIB_32_PKG)/usr/include
	@rm -rf $(ALSA_LIB_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ALSA_LIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libasound.la  \
	 )
	@( cd $(ALSA_LIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/alsa-lib/smixer ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" smixer-ac97.la   \
	                                    smixer-hda.la    \
	                                    smixer-python.la \
	                                    smixer-sbase.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ALSA_LIB_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libasound.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libasound.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/alsa-lib/smixer ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" smixer-ac97.la     \
	                                            smixer-hda.la      \
	                                            smixer-python.la   \
	                                            smixer-sbase.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" smixer-ac97.la   \
	                                              smixer-hda.la    \
	                                              smixer-python.la \
	                                              smixer-sbase.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" alsa.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(ALSA_LIB_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(ALSA_LIB_32_PKG_DESCRIPTION_FILE): $(ALSA_LIB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ALSA_LIB_32_PKG_DESCRIPTION_FILE) $(ALSA_LIB_32_PKG_INSTALL_SCRIPT)
	@cp $(ALSA_LIB_32_PKG_DESCRIPTION_FILE) $(ALSA_LIB_32_PKG)/.DESCRIPTION
	@cp $(ALSA_LIB_32_PKG_INSTALL_SCRIPT) $(ALSA_LIB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ALSA_LIB_32_PKG)/.REQUIRES
	@echo "pkgname=$(ALSA_LIB_32_PKG_NAME)"                            >  $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ALSA_LIB_32_PKG_VERSION)"                          >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(ALSA_LIB_32_PKG_ARCH)"                               >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ALSA_LIB_32_PKG_DISTRO_NAME)"                  >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ALSA_LIB_32_PKG_DISTRO_VERSION)"                >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "group=$(ALSA_LIB_32_PKG_GROUP)"                             >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ALSA_LIB_32_PKG_SHORT_DESCRIPTION)\"" >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "url=$(ALSA_LIB_32_PKG_URL)"                                 >> $(ALSA_LIB_32_PKG)/.PKGINFO ; \
	 echo "license=$(ALSA_LIB_32_PKG_LICENSE)"                         >> $(ALSA_LIB_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ALSA_LIB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
