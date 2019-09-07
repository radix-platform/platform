
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libwebp

REQUIRES           = libs/libwebp/0.5.0
REQUIRES          += libs/libtiff/4.0.6-x86_32
REQUIRES          += libs/libpng/libpng14/1.4.19-x86_32
REQUIRES          += libs/libjpeg-turbo/1.4.2-x86_32
REQUIRES          += libs/giflib/5.1.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.5.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libwebp/libwebp-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libwebp-$(version)
src_dir_name       = libwebp-$(version)
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
LIBWEBP_32_PKG_NAME                = libwebp-x32
LIBWEBP_32_PKG_VERSION             = 0.5.0
LIBWEBP_32_PKG_ARCH                = $(TOOLCHAIN)
LIBWEBP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBWEBP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBWEBP_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBWEBP_32_PKG_SHORT_DESCRIPTION   = WebP library and conversion tools
LIBWEBP_32_PKG_URL                 = $(BUG_URL)
LIBWEBP_32_PKG_LICENSE             = BSD
LIBWEBP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBWEBP_32_PKG_NAME)-pkg-description
LIBWEBP_32_PKG_DESCRIPTION_FILE_IN = $(LIBWEBP_32_PKG_NAME)-pkg-description.in
LIBWEBP_32_PKG_INSTALL_SCRIPT      = $(LIBWEBP_32_PKG_NAME)-pkg-install.sh

LIBWEBP_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBWEBP_32_PKG_NAME)-package

pkg_basename     = $(LIBWEBP_32_PKG_NAME)-$(LIBWEBP_32_PKG_VERSION)-$(LIBWEBP_32_PKG_ARCH)-$(LIBWEBP_32_PKG_DISTRO_NAME)-$(LIBWEBP_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBWEBP_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-swap-16bit-csp
extra_configure_switches += --enable-experimental
extra_configure_switches += --enable-libwebp{mux,demux,decoder,extras}

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(LIBWEBP_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBWEBP_32_PKG)/usr/include
	@rm -rf $(LIBWEBP_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBWEBP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libwebp.la libwebpdecoder.la     \
	                                    libwebpdemux.la libwebpextras.la \
	                                    libwebpmux.la                  ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBWEBP_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libwebp.la libwebpdecoder.la     \
	                                            libwebpdemux.la libwebpextras.la \
	                                            libwebpmux.la                  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libwebp.la libwebpdecoder.la     \
	                                              libwebpdemux.la libwebpextras.la \
	                                              libwebpmux.la                  ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libwebp.pc libwebpdecoder.pc     \
	                                            libwebpdemux.pc libwebpextras.pc \
	                                            libwebpmux.pc                  ; \
	 )
	# =======Strip binaries =======
	@( cd $(LIBWEBP_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBWEBP_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBWEBP_32_PKG_DESCRIPTION_FILE): $(LIBWEBP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBWEBP_32_PKG_DESCRIPTION_FILE) $(LIBWEBP_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBWEBP_32_PKG_DESCRIPTION_FILE) $(LIBWEBP_32_PKG)/.DESCRIPTION
	@cp $(LIBWEBP_32_PKG_INSTALL_SCRIPT) $(LIBWEBP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBWEBP_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBWEBP_32_PKG_NAME)"                            >  $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBWEBP_32_PKG_VERSION)"                          >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBWEBP_32_PKG_ARCH)"                               >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBWEBP_32_PKG_DISTRO_NAME)"                  >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBWEBP_32_PKG_DISTRO_VERSION)"                >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBWEBP_32_PKG_GROUP)"                             >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBWEBP_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBWEBP_32_PKG_URL)"                                 >> $(LIBWEBP_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBWEBP_32_PKG_LICENSE)"                         >> $(LIBWEBP_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBWEBP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
