
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/flac

REQUIRES           = app/flac/1.3.1
REQUIRES          += libs/libogg/1.3.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/flac/flac-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/flac-$(version)
src_dir_name       = flac-$(version)
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
FLAC_32_PKG_NAME                = flac-x32
FLAC_32_PKG_VERSION             = 1.3.1
FLAC_32_PKG_ARCH                = $(TOOLCHAIN)
FLAC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FLAC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FLAC_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FLAC_32_PKG_SHORT_DESCRIPTION   = Free Lossless Audio Codec
FLAC_32_PKG_URL                 = $(BUG_URL)
FLAC_32_PKG_LICENSE             = Xiph
FLAC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FLAC_32_PKG_NAME)-pkg-description
FLAC_32_PKG_DESCRIPTION_FILE_IN = $(FLAC_32_PKG_NAME)-pkg-description.in
FLAC_32_PKG_INSTALL_SCRIPT      = $(FLAC_32_PKG_NAME)-pkg-install.sh

FLAC_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FLAC_32_PKG_NAME)-package

pkg_basename     = $(FLAC_32_PKG_NAME)-$(FLAC_32_PKG_VERSION)-$(FLAC_32_PKG_ARCH)-$(FLAC_32_PKG_DISTRO_NAME)-$(FLAC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FLAC_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

extra_configure_switches += --disable-xmms-plugin
extra_configure_switches += --disable-oggtest
extra_configure_switches += --with-ogg=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --disable-rpath

ifneq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
extra_configure_switches += --disable-asm-optimizations
endif


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FLAC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(FLAC_32_PKG)/usr/include
	@rm -rf $(FLAC_32_PKG)/usr/share
	# ======= remove target path from target libtool *.la files =======
	@( cd $(FLAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libFLAC++.la libFLAC.la ; \
	   sed -i "s, -L/usr/lib,,g" libFLAC.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FLAC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libFLAC++.la libFLAC.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libFLAC++.la libFLAC.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" flac++.pc flac.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(FLAC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FLAC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FLAC_32_PKG_DESCRIPTION_FILE): $(FLAC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FLAC_32_PKG_DESCRIPTION_FILE) $(FLAC_32_PKG_INSTALL_SCRIPT)
	@cp $(FLAC_32_PKG_DESCRIPTION_FILE) $(FLAC_32_PKG)/.DESCRIPTION
	@cp $(FLAC_32_PKG_INSTALL_SCRIPT) $(FLAC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FLAC_32_PKG)/.REQUIRES
	@echo "pkgname=$(FLAC_32_PKG_NAME)"                            >  $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FLAC_32_PKG_VERSION)"                          >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FLAC_32_PKG_ARCH)"                               >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FLAC_32_PKG_DISTRO_NAME)"                  >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FLAC_32_PKG_DISTRO_VERSION)"                >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "group=$(FLAC_32_PKG_GROUP)"                             >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FLAC_32_PKG_SHORT_DESCRIPTION)\"" >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "url=$(FLAC_32_PKG_URL)"                                 >> $(FLAC_32_PKG)/.PKGINFO ; \
	 echo "license=$(FLAC_32_PKG_LICENSE)"                         >> $(FLAC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FLAC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
