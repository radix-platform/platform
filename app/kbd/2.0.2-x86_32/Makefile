
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/kbd

REQUIRES           = app/kbd/2.0.2
REQUIRES          += libs/eglibc/2.19.1-x86_32
REQUIRES          += dev/check/0.9.13-x86_32
REQUIRES          += secure/pam/1.1.8-x86_32
REQUIRES          += secure/pam_unix2/2.9.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/kbd/kbd-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/kbd-$(version)
src_dir_name       = kbd-$(version)
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
KBD_32_PKG_NAME                = kbd-x32
KBD_32_PKG_VERSION             = 2.0.2
KBD_32_PKG_ARCH                = $(TOOLCHAIN)
KBD_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KBD_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KBD_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
KBD_32_PKG_SHORT_DESCRIPTION   = keyboard maps x86_32 library
KBD_32_PKG_URL                 = $(BUG_URL)
KBD_32_PKG_LICENSE             = LGPLv2
KBD_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KBD_32_PKG_NAME)-pkg-description
KBD_32_PKG_DESCRIPTION_FILE_IN = $(KBD_32_PKG_NAME)-pkg-description.in
KBD_32_PKG_INSTALL_SCRIPT      = $(KBD_32_PKG_NAME)-pkg-install.sh

KBD_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KBD_32_PKG_NAME)-package

pkg_basename     = $(KBD_32_PKG_NAME)-$(KBD_32_PKG_VERSION)-$(KBD_32_PKG_ARCH)-$(KBD_32_PKG_DISTRO_NAME)-$(KBD_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(KBD_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --localedir=/usr/share/locale
extra_configure_switches += --datadir=/usr/share/kbd
extra_configure_switches += --enable-libkeymap
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-nls


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Rename conflicting keymaps =======
	@( cd $(SRC_DIR) ; \
	   mv data/keymaps/i386/qwertz/cz{,-qwertz}.map         ; \
	   mv data/keymaps/i386/olpc/es{,-olpc}.map             ; \
	   mv data/keymaps/i386/olpc/pt{,-olpc}.map             ; \
	   mv data/keymaps/i386/dvorak/no{,-dvorak}.map         ; \
	   mv data/keymaps/i386/fgGIod/trf{,-fgGIod}.map        ; \
	   mv data/keymaps/i386/colemak/{en-latin9,colemak}.map ; \
	 )
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
	@mkdir -p $(KBD_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(KBD_32_PKG)/usr/bin/32
	@( cd $(KBD_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	# ======= Move loadkeys into /bin/32 directory =======
	@mkdir -p $(KBD_32_PKG)/bin/32
	@( cd $(KBD_32_PKG)/usr/bin/32 ; \
	   mv -f loadkeys ../../../bin/32 ; \
	   ln -sf ../../../bin/32/loadkeys . ; \
	 )
	@rm -rf $(KBD_32_PKG)/usr/include
	@rm -rf $(KBD_32_PKG)/usr/share
	# ======= remove target path from target libtool *.la files =======
	@( cd $(KBD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libkeymap.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(KBD_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkeymap.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libkeymap.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkeymap.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(KBD_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(KBD_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(KBD_32_PKG_DESCRIPTION_FILE): $(KBD_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KBD_32_PKG_DESCRIPTION_FILE) $(KBD_32_PKG_INSTALL_SCRIPT)
	@cp $(KBD_32_PKG_DESCRIPTION_FILE) $(KBD_32_PKG)/.DESCRIPTION
	@cp $(KBD_32_PKG_INSTALL_SCRIPT) $(KBD_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KBD_32_PKG)/.REQUIRES
	@echo "pkgname=$(KBD_32_PKG_NAME)"                            >  $(KBD_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KBD_32_PKG_VERSION)"                          >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "arch=$(KBD_32_PKG_ARCH)"                               >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(KBD_32_PKG_DISTRO_NAME)"                  >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(KBD_32_PKG_DISTRO_VERSION)"                >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "group=$(KBD_32_PKG_GROUP)"                             >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KBD_32_PKG_SHORT_DESCRIPTION)\"" >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "url=$(KBD_32_PKG_URL)"                                 >> $(KBD_32_PKG)/.PKGINFO ; \
	 echo "license=$(KBD_32_PKG_LICENSE)"                         >> $(KBD_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KBD_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
