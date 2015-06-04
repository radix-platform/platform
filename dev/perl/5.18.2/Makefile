
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/perl
SOURCE_REQUIRES   += sources/packages/d/perl-cross/0.8.5

REQUIRES           = libs/gdbm/1.11

# ======= __END_OF_REQUIRES__ =======


version            = 5.18.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/perl/perl-$(version).tar.gz
cross_bz2_archive  = $(SRC_PACKAGE_PATH)/packages/d/perl-cross/0.8.5/perl-cross-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/perl-$(version)
src_dir_name       = perl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


USE_TARGET_DEST_DIR_SYSROOT = no
NO_CCACHE = 1


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PERL_PKG_NAME                = perl
PERL_PKG_VERSION             = 5.18.2
PERL_PKG_ARCH                = $(TOOLCHAIN)
PERL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PERL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PERL_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
PERL_PKG_SHORT_DESCRIPTION   = Practical Extraction and Report Language
PERL_PKG_URL                 = $(BUG_URL)
PERL_PKG_LICENSE             = GPLv1
PERL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PERL_PKG_NAME)-pkg-description
PERL_PKG_DESCRIPTION_FILE_IN = $(PERL_PKG_NAME)-pkg-description.in
PERL_PKG_INSTALL_SCRIPT      = $(PERL_PKG_NAME)-pkg-install.sh

PERL_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PERL_PKG_NAME)-package

pkg_basename     = $(PERL_PKG_NAME)-$(PERL_PKG_VERSION)-$(PERL_PKG_ARCH)-$(PERL_PKG_DISTRO_NAME)-$(PERL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PERL_PKG)


extra_configure_switches  = --mode=cross
extra_configure_switches += --target=$(TARGET)
extra_configure_switches += --target-tools-prefix=$(CROSS_PREFIX)
extra_configure_switches += --sysroot=$(TARGET_DEST_DIR)
extra_configure_switches += -A lddlflags=--sysroot=$(TARGET_DEST_DIR) -A lddlflags=-shared

extra_configure_switches += --html1dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += --html3dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += --man1dir=/usr/share/man/man1
extra_configure_switches += --man3dir=/usr/share/man/man3


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@tar xjf $(cross_bz2_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PERL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@( cd $(PERL_PKG)/usr/bin ; \
	   rm -f perl ; \
	   ln -sf perl$(version) perl ; \
	 )
	@( cd $(PERL_PKG)/usr/share/man/man1 ; \
	   rm -f pstruct.1 ; ln -sf c2ph.1 pstruct.1 ; \
	   rm -f perlthanks.1 ; ln -sf perlbug.1 perlthanks.1 ; \
	   rm -f s2p.1 ; ln -sf psed.1 s2p.1 ; \
	 )
	@if [ -d $(PERL_PKG)/usr/share/man ]; then \
	  ( cd $(PERL_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	# ======= Install Documentation ======
	@mkdir -p $(PERL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/Artistic $(SRC_DIR)/Copying \
	       $(PERL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PERL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS Artistic Changes Copying INSTALL MANIFEST README* \
	         $(PERL_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PERL_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Remove cross environment from target package =======
	@( archname=`cat $(SRC_DIR)/tconfig.sh | grep "^archname=" | sed -e "s,archname=',," | sed -e "s,',,"` ; \
	   archdir=$(PERL_PKG)/usr/lib$(LIBSUFFIX)/perl5/$(version)/$$archname   ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               $$archdir/Config_heavy.pl ; \
	   sed -i "s,--sysroot=$(TARGET_DEST_DIR),,g"  $$archdir/Config_heavy.pl ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"            $$archdir/Config_heavy.pl ; \
	   sed -i "s,$(CURDIR)/$(TARGET_BUILD_DIR),,g" $$archdir/Config_heavy.pl ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               $$archdir/Config.pm       ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PERL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PERL_PKG_DESCRIPTION_FILE): $(PERL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PERL_PKG_DESCRIPTION_FILE) $(PERL_PKG_INSTALL_SCRIPT)
	@cp $(PERL_PKG_DESCRIPTION_FILE) $(PERL_PKG)/.DESCRIPTION
	@cp $(PERL_PKG_INSTALL_SCRIPT) $(PERL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PERL_PKG)/.REQUIRES
	@echo "pkgname=$(PERL_PKG_NAME)"                            >  $(PERL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PERL_PKG_VERSION)"                          >> $(PERL_PKG)/.PKGINFO ; \
	 echo "arch=$(PERL_PKG_ARCH)"                               >> $(PERL_PKG)/.PKGINFO ; \
	 echo "distroname=$(PERL_PKG_DISTRO_NAME)"                  >> $(PERL_PKG)/.PKGINFO ; \
	 echo "distrover=$(PERL_PKG_DISTRO_VERSION)"                >> $(PERL_PKG)/.PKGINFO ; \
	 echo "group=$(PERL_PKG_GROUP)"                             >> $(PERL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PERL_PKG_SHORT_DESCRIPTION)\"" >> $(PERL_PKG)/.PKGINFO ; \
	 echo "url=$(PERL_PKG_URL)"                                 >> $(PERL_PKG)/.PKGINFO ; \
	 echo "license=$(PERL_PKG_LICENSE)"                         >> $(PERL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PERL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
