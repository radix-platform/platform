
COMPONENT_TARGETS   += $(TARGET_PC64)

NEED_ABS_PATH        = true

COMPONENT_IS_3PP     = true


include ../../../build-system/constants.mk


version              = 5.9

SOURCE_REQUIRES      = $(SRC_PACKAGE_DIR)/GNU/ncurses/$(version)

REQUIRES             = app/gpm/1.20.7


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

build_ncurses32_pkg  = $(TARGET_BUILD_DIR)/.ncurses32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NCURSES32_PKG_NAME                = ncurses32
NCURSES32_PKG_VERSION             = 5.9
NCURSES32_PKG_ARCH                = $(TOOLCHAIN)
NCURSES32_PKG_DISTRO_NAME         = kxLab
NCURSES32_PKG_DISTRO_VERSION      = 1.0
NCURSES32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
NCURSES32_PKG_SHORT_DESCRIPTION   = ncurses32 $(version)
NCURSES32_PKG_URL                 = http://www.kxLab.com
NCURSES32_PKG_LICENSE             = GPLv2
NCURSES32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NCURSES32_PKG_NAME)-pkg-description
NCURSES32_PKG_DESCRIPTION_FILE_IN = $(NCURSES32_PKG_NAME)-pkg-description.in
NCURSES32_PKG_INSTALL_SCRIPT      = $(NCURSES32_PKG_NAME)-pkg-install.sh

NCURSES32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NCURSES32_PKG_NAME)-package

pkg_basename     = $(NCURSES32_PKG_NAME)-$(NCURSES32_PKG_VERSION)-$(NCURSES32_PKG_ARCH)-$(NCURSES32_PKG_DISTRO_NAME)-$(NCURSES32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(NCURSES32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_ncurses32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(NCURSES32_PKG)

OPTIMIZATION_FLAGS = -O3

CC                += -m32

# owerwrite LDFLAGS:
#
LDFLAGS            = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS           += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32           = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


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
	@mkdir -p $(NCURSES32_PKG)
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
	@mkdir -p $(NCURSES32_PKG)
	@cd $(build_widec_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(NCURSES32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(NCURSES32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 755 *.so ; \
	   chmod 644 *.a ; \
	   cp -a libncurses.so.5 $(NCURSES32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   cp -a libncursesw.so.5 $(NCURSES32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libncurses.so.5.? $(NCURSES32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv libncursesw.so.5.? $(NCURSES32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libncurses.so.5.? . ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libncursesw.so.5.? . ; \
	   ln -sf libncursesw.a libcursesw.a ; \
	   ln -sf libncursesw.so.5.? libcursesw.so ; \
	 )
	@( cd $(NCURSES32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv {c,i,n,r,t}* 32 ; \
	   sed -i "s,}/bin,}/bin/32,g" 32/ncurses5-config 32/ncursesw5-config \
	 )
	@rm -rf $(NCURSES32_PKG)/usr/include
	@rm -rf $(NCURSES32_PKG)/usr/share
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(NCURSES32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" form.pc formw.pc menu.pc menuw.pc ncurses++.pc \
                                                    ncurses++w.pc ncurses.pc ncursesw.pc panel.pc panelw.pc \
	 )
	@(cd $(NCURSES32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NCURSES32_PKG_DESCRIPTION_FILE): $(NCURSES32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_ncurses32_pkg): $(install_widec_target) $(NCURSES32_PKG_DESCRIPTION_FILE)
	@cp $(NCURSES32_PKG_DESCRIPTION_FILE) $(NCURSES32_PKG)/.DESCRIPTION
	@cp $(NCURSES32_PKG_INSTALL_SCRIPT) $(NCURSES32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NCURSES32_PKG)/.REQUIRES
	@echo "pkgname=$(NCURSES32_PKG_NAME)"                            >  $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NCURSES32_PKG_VERSION)"                          >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "arch=$(NCURSES32_PKG_ARCH)"                               >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "distroname=$(NCURSES32_PKG_DISTRO_NAME)"                  >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "distrover=$(NCURSES32_PKG_DISTRO_VERSION)"                >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "group=$(NCURSES32_PKG_GROUP)"                             >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NCURSES32_PKG_SHORT_DESCRIPTION)\"" >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "url=$(NCURSES32_PKG_URL)"                                 >> $(NCURSES32_PKG)/.PKGINFO ; \
	 echo "license=$(NCURSES32_PKG_LICENSE)"                         >> $(NCURSES32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NCURSES32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
