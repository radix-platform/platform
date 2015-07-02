
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/fontconfig

REQUIRES           = X11/libs/fontconfig/2.11.1
REQUIRES          += libs/expat/2.1.0-x86_32
REQUIRES          += env/freetype/2.5.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.11.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/fontconfig/fontconfig-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fontconfig-$(version)
src_dir_name       = fontconfig-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FONTCFG_32_PKG_NAME                = fontconfig-x32
FONTCFG_32_PKG_VERSION             = 2.11.1
FONTCFG_32_PKG_ARCH                = $(TOOLCHAIN)
FONTCFG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FONTCFG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FONTCFG_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
FONTCFG_32_PKG_SHORT_DESCRIPTION   = Font library and tools
FONTCFG_32_PKG_URL                 = $(BUG_URL)
FONTCFG_32_PKG_LICENSE             = custom
FONTCFG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FONTCFG_32_PKG_NAME)-pkg-description
FONTCFG_32_PKG_DESCRIPTION_FILE_IN = $(FONTCFG_32_PKG_NAME)-pkg-description.in
FONTCFG_32_PKG_INSTALL_SCRIPT      = $(FONTCFG_32_PKG_NAME)-pkg-install.sh

FONTCFG_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FONTCFG_32_PKG_NAME)-package

pkg_basename     = $(FONTCFG_32_PKG_NAME)-$(FONTCFG_32_PKG_VERSION)-$(FONTCFG_32_PKG_ARCH)-$(FONTCFG_32_PKG_DISTRO_NAME)-$(FONTCFG_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(FONTCFG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-templatedir=/etc/fonts/conf.avai
extra_configure_switches += --with-baseconfigdir=/etc/fonts
extra_configure_switches += --with-configdir=/etc/fonts/conf.d
extra_configure_switches += --with-xmldir=/etc/fonts
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
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
	# ======= trick the Makefile.am developers =======
	@( cd $(build_dir)/doc ; \
	   gcc -c -o edit-sgml.o $(CURDIR)/$(SRC_DIR)/doc/edit-sgml.c ; \
	   gcc -o edit-sgml edit-sgml.o ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FONTCFG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(FONTCFG_32_PKG)/usr/bin/32
	@( cd $(FONTCFG_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(FONTCFG_32_PKG)/etc
	@rm -rf $(FONTCFG_32_PKG)/usr/include
	@rm -rf $(FONTCFG_32_PKG)/usr/share
	@rm -rf $(FONTCFG_32_PKG)/var
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FONTCFG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfontconfig.la  \
	 )
	@( cd $(FONTCFG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" fontconfig.pc  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FONTCFG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfontconfig.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfontconfig.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" fontconfig.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(FONTCFG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FONTCFG_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FONTCFG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FONTCFG_32_PKG_DESCRIPTION_FILE): $(FONTCFG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FONTCFG_32_PKG_DESCRIPTION_FILE) $(FONTCFG_32_PKG_INSTALL_SCRIPT)
	@cp $(FONTCFG_32_PKG_DESCRIPTION_FILE) $(FONTCFG_32_PKG)/.DESCRIPTION
	@cp $(FONTCFG_32_PKG_INSTALL_SCRIPT) $(FONTCFG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FONTCFG_32_PKG)/.REQUIRES
	@echo "pkgname=$(FONTCFG_32_PKG_NAME)"                            >  $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FONTCFG_32_PKG_VERSION)"                          >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FONTCFG_32_PKG_ARCH)"                               >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FONTCFG_32_PKG_DISTRO_NAME)"                  >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FONTCFG_32_PKG_DISTRO_VERSION)"                >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "group=$(FONTCFG_32_PKG_GROUP)"                             >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FONTCFG_32_PKG_SHORT_DESCRIPTION)\"" >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "url=$(FONTCFG_32_PKG_URL)"                                 >> $(FONTCFG_32_PKG)/.PKGINFO ; \
	 echo "license=$(FONTCFG_32_PKG_LICENSE)"                         >> $(FONTCFG_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FONTCFG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
