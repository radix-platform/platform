
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/dialog

REQUIRES           = app/dialog/1.2-20140112
REQUIRES          += libs/ncurses/6.1-x86_32
REQUIRES          += dev/libtool/2.4.6-x86_32
REQUIRES          += app/ctags/5.8-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2-20140112
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/dialog/dialog-$(version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dialog-$(version)
src_dir_name       = dialog-$(version)
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
DIALOG_32_PKG_NAME                = dialog-x32
DIALOG_32_PKG_VERSION             = 1.2-20140112
DIALOG_32_PKG_ARCH                = $(TOOLCHAIN)
DIALOG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DIALOG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DIALOG_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
DIALOG_32_PKG_SHORT_DESCRIPTION   = dialog boxes for shell scripts
DIALOG_32_PKG_URL                 = $(BUG_URL)
DIALOG_32_PKG_LICENSE             = LGPLv2
DIALOG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DIALOG_32_PKG_NAME)-pkg-description
DIALOG_32_PKG_DESCRIPTION_FILE_IN = $(DIALOG_32_PKG_NAME)-pkg-description.in
DIALOG_32_PKG_INSTALL_SCRIPT      = $(DIALOG_32_PKG_NAME)-pkg-install.sh

DIALOG_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DIALOG_32_PKG_NAME)-package

pkg_basename     = $(DIALOG_32_PKG_NAME)-$(DIALOG_32_PKG_VERSION)-$(DIALOG_32_PKG_ARCH)-$(DIALOG_32_PKG_DISTRO_NAME)-$(DIALOG_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(DIALOG_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --bindir=/usr/bin/32
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-nls
extra_configure_switches += --with-ncursesw
extra_configure_switches += --enable-widec
extra_configure_switches += --disable-rpath
extra_configure_switches += --disable-rpath-hack
extra_configure_switches += --with-libtool


extra_environment  = NCURSES_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/ncursesw6-config


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(extra_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cp -a $(TARGET_DEST_DIR)/usr/bin/libtool $(build_dir)
	@( cd $(build_dir) ; \
	   sed -i '/^LIBTOOL	.*=/c LIBTOOL		= ./libtool --tag=CC' makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DIALOG_32_PKG)/bin/32
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(DIALOG_32_PKG)/usr/bin/32 ; \
	   mv dialog ../../../bin/32   ; \
	   ln -sf ../../../bin/32/dialog . ; \
	 )
	@rm -rf $(DIALOG_32_PKG)/usr/include
	@rm -rf $(DIALOG_32_PKG)/usr/share
	# ====== remove target path from target libtool *.la files ======
	@( cd $(DIALOG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 0755 libdialog.la libdialog.so.??.* ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdialog.la ; \
	 )
	# ======= remove target path from dialog-config script =======
	@( cd $(DIALOG_32_PKG)/usr/bin/32 ; \
	   sed -i 's,^bindir="/usr,bindir="$${exec_prefix},g' dialog-config ; \
	   sed -i "s, -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX),,g" dialog-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DIALOG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdialog.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdialog.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i 's,^prefix="/usr,prefix="$(TARGET_DEST_DIR)/usr,g' dialog-config ; \
	   sed -i 's,^libdir="/usr,libdir="$(TARGET_DEST_DIR)/usr,g' dialog-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DIALOG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(DIALOG_32_PKG_DESCRIPTION_FILE): $(DIALOG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DIALOG_32_PKG_DESCRIPTION_FILE) $(DIALOG_32_PKG_INSTALL_SCRIPT)
	@cp $(DIALOG_32_PKG_DESCRIPTION_FILE) $(DIALOG_32_PKG)/.DESCRIPTION
	@cp $(DIALOG_32_PKG_INSTALL_SCRIPT) $(DIALOG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DIALOG_32_PKG)/.REQUIRES
	@echo "pkgname=$(DIALOG_32_PKG_NAME)"                            >  $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DIALOG_32_PKG_VERSION)"                          >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DIALOG_32_PKG_ARCH)"                               >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DIALOG_32_PKG_DISTRO_NAME)"                  >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DIALOG_32_PKG_DISTRO_VERSION)"                >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "group=$(DIALOG_32_PKG_GROUP)"                             >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DIALOG_32_PKG_SHORT_DESCRIPTION)\"" >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "url=$(DIALOG_32_PKG_URL)"                                 >> $(DIALOG_32_PKG)/.PKGINFO ; \
	 echo "license=$(DIALOG_32_PKG_LICENSE)"                         >> $(DIALOG_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DIALOG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
