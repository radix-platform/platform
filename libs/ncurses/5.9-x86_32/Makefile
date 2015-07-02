
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/GNU/ncurses/5.9

REQUIRES             = libs/ncurses/5.9
REQUIRES            += app/gpm/1.20.7-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 5.9
tar_gz_archive       = $(SRC_PACKAGE_PATH)/GNU/ncurses/$(version)/ncurses-$(version).tar.gz
patch_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/ncurses/$(version)/patch-$(version)-20130504.sh.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/ncurses-$(version)
src_dir_name         = ncurses-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done

build_widec_dir      = $(TARGET_BUILD_DIR)/build-widec
build_widec_target   = $(TARGET_BUILD_DIR)/.build_widec_done
install_widec_target = $(TARGET_BUILD_DIR)/.install_widec_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NCURSES_32_PKG_NAME                = ncurses-x32
NCURSES_32_PKG_VERSION             = 5.9
NCURSES_32_PKG_ARCH                = $(TOOLCHAIN)
NCURSES_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NCURSES_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NCURSES_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
NCURSES_32_PKG_SHORT_DESCRIPTION   = CRT screen handling and optimization package
NCURSES_32_PKG_URL                 = $(BUG_URL)
NCURSES_32_PKG_LICENSE             = GPLv2
NCURSES_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NCURSES_32_PKG_NAME)-pkg-description
NCURSES_32_PKG_DESCRIPTION_FILE_IN = $(NCURSES_32_PKG_NAME)-pkg-description.in
NCURSES_32_PKG_INSTALL_SCRIPT      = $(NCURSES_32_PKG_NAME)-pkg-install.sh

NCURSES_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NCURSES_32_PKG_NAME)-package

pkg_basename     = $(NCURSES_32_PKG_NAME)-$(NCURSES_32_PKG_VERSION)-$(NCURSES_32_PKG_ARCH)-$(NCURSES_32_PKG_DISTRO_NAME)-$(NCURSES_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)
BUILD_TARGETS   += $(build_widec_target)
BUILD_TARGETS   += $(install_widec_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(NCURSES_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gpm
extra_configure_switches += --disable-termcap
extra_configure_switches += --with-normal
extra_configure_switches += --with-shared
extra_configure_switches += --enable-symlinks
extra_configure_switches += --enable-pc-files
extra_configure_switches += --with-pkg-config-libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
extra_configure_switches += --without-debug
extra_configure_switches += --without-profile
extra_configure_switches += --without-ada
extra_configure_switches += --program-suffix=""
extra_configure_switches += --program-prefix=""


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(patch_gz_archive) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@zcat $(patch_gz_archive) > $(SRC_DIR)/patch.sh
	@chmod a+x $(SRC_DIR)/patch.sh
	@( cd $(SRC_DIR) && ./patch.sh )
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
	@mkdir -p $(NCURSES_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@touch $@

$(build_widec_target): $(install_target)
	@mkdir -p $(build_widec_dir)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  --enable-widec              \
	  $(extra_configure_switches)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_widec_target): $(build_widec_target)
	@mkdir -p $(NCURSES_32_PKG)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(NCURSES_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(NCURSES_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 755 *.so ; \
	   chmod 644 *.a ; \
	   cp -a libncurses.so.5 $(NCURSES_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   cp -a libncursesw.so.5 $(NCURSES_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libncurses.so.5.? $(NCURSES_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libncursesw.so.5.? $(NCURSES_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libncurses.so.5.? . ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libncursesw.so.5.? . ; \
	   ln -sf libncursesw.a libcursesw.a ; \
	   ln -sf libncursesw.so.5.? libcursesw.so ; \
	 )
	@( cd $(NCURSES_32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv {c,i,n,r,t}* 32 ; \
	   sed -i "s,}/bin,}/bin/32,g" 32/ncurses5-config 32/ncursesw5-config \
	 )
	@rm -rf $(NCURSES_32_PKG)/usr/include
	@rm -rf $(NCURSES_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NCURSES_32_PKG))
	# ======= remove TARGET_DEST_DIR from ncurses-config scripts =======
	@( cd $(NCURSES_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" ncurses5-config ncursesw5-config \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" form.pc formw.pc menu.pc menuw.pc ncurses++.pc \
	                                            ncurses++w.pc ncurses.pc ncursesw.pc panel.pc panelw.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(NCURSES_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(NCURSES_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(NCURSES_32_PKG_DESCRIPTION_FILE): $(NCURSES_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_widec_target) $(NCURSES_32_PKG_DESCRIPTION_FILE) $(NCURSES_32_PKG_INSTALL_SCRIPT)
	@cp $(NCURSES_32_PKG_DESCRIPTION_FILE) $(NCURSES_32_PKG)/.DESCRIPTION
	@cp $(NCURSES_32_PKG_INSTALL_SCRIPT) $(NCURSES_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NCURSES_32_PKG)/.REQUIRES
	@echo "pkgname=$(NCURSES_32_PKG_NAME)"                            >  $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NCURSES_32_PKG_VERSION)"                          >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "arch=$(NCURSES_32_PKG_ARCH)"                               >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(NCURSES_32_PKG_DISTRO_NAME)"                  >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(NCURSES_32_PKG_DISTRO_VERSION)"                >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "group=$(NCURSES_32_PKG_GROUP)"                             >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NCURSES_32_PKG_SHORT_DESCRIPTION)\"" >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "url=$(NCURSES_32_PKG_URL)"                                 >> $(NCURSES_32_PKG)/.PKGINFO ; \
	 echo "license=$(NCURSES_32_PKG_LICENSE)"                         >> $(NCURSES_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NCURSES_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
