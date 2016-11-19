
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/libtheora

REQUIRES           = libs/libtheora/1.1.1
REQUIRES          += libs/libogg/1.3.2-x86_32
REQUIRES          += libs/libvorbis/1.3.5-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/xiph/libtheora/libtheora-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libtheora-$(version)
src_dir_name       = libtheora-$(version)
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
LIBTHEORA_32_PKG_NAME                = libtheora-x32
LIBTHEORA_32_PKG_VERSION             = 1.1.1
LIBTHEORA_32_PKG_ARCH                = $(TOOLCHAIN)
LIBTHEORA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBTHEORA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBTHEORA_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBTHEORA_32_PKG_SHORT_DESCRIPTION   = Theora video codec library
LIBTHEORA_32_PKG_URL                 = $(BUG_URL)
LIBTHEORA_32_PKG_LICENSE             = Xiph.org
LIBTHEORA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBTHEORA_32_PKG_NAME)-pkg-description
LIBTHEORA_32_PKG_DESCRIPTION_FILE_IN = $(LIBTHEORA_32_PKG_NAME)-pkg-description.in
LIBTHEORA_32_PKG_INSTALL_SCRIPT      = $(LIBTHEORA_32_PKG_NAME)-pkg-install.sh

LIBTHEORA_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBTHEORA_32_PKG_NAME)-package

pkg_basename     = $(LIBTHEORA_32_PKG_NAME)-$(LIBTHEORA_32_PKG_VERSION)-$(LIBTHEORA_32_PKG_ARCH)-$(LIBTHEORA_32_PKG_DISTRO_NAME)-$(LIBTHEORA_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBTHEORA_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-sdltest
extra_configure_switches += --disable-examples

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(LIBTHEORA_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBTHEORA_32_PKG)/usr/include
	@rm -rf $(LIBTHEORA_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBTHEORA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libtheora.la      \
	                                    libtheoradec.la   \
	                                    libtheoraenc.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBTHEORA_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtheora.la      \
	                                            libtheoradec.la   \
	                                            libtheoraenc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libtheora.la      \
	                                              libtheoradec.la   \
	                                              libtheoraenc.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" theora.pc theoradec.pc theoraenc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBTHEORA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBTHEORA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBTHEORA_32_PKG_DESCRIPTION_FILE): $(LIBTHEORA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBTHEORA_32_PKG_DESCRIPTION_FILE) $(LIBTHEORA_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBTHEORA_32_PKG_DESCRIPTION_FILE) $(LIBTHEORA_32_PKG)/.DESCRIPTION
	@cp $(LIBTHEORA_32_PKG_INSTALL_SCRIPT) $(LIBTHEORA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBTHEORA_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBTHEORA_32_PKG_NAME)"                            >  $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBTHEORA_32_PKG_VERSION)"                          >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBTHEORA_32_PKG_ARCH)"                               >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBTHEORA_32_PKG_DISTRO_NAME)"                  >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBTHEORA_32_PKG_DISTRO_VERSION)"                >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBTHEORA_32_PKG_GROUP)"                             >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBTHEORA_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBTHEORA_32_PKG_URL)"                                 >> $(LIBTHEORA_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBTHEORA_32_PKG_LICENSE)"                         >> $(LIBTHEORA_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBTHEORA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
