
COMPONENT_TARGETS += $(HARDWARE_PC64)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/perl
SOURCE_REQUIRES   += sources/packages/d/perl-cross/0.8.5

REQUIRES           = dev/perl/5.18.2
REQUIRES          += libs/eglibc/2.19.1-x86_32
REQUIRES          += libs/gdbm/1.11-x86_32


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
PERL_32_PKG_NAME                = perl-x32
PERL_32_PKG_VERSION             = 5.18.2
PERL_32_PKG_ARCH                = $(TOOLCHAIN)
PERL_32_PKG_DISTRO_NAME         = kxLab
PERL_32_PKG_DISTRO_VERSION      = 1.0
PERL_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PERL_32_PKG_SHORT_DESCRIPTION   = perl-x32 $(version)
PERL_32_PKG_URL                 = http://www.kxLab.com
PERL_32_PKG_LICENSE             = GPLv1
PERL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PERL_32_PKG_NAME)-pkg-description
PERL_32_PKG_DESCRIPTION_FILE_IN = $(PERL_32_PKG_NAME)-pkg-description.in
PERL_32_PKG_INSTALL_SCRIPT      = $(PERL_32_PKG_NAME)-pkg-install.sh

PERL_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PERL_32_PKG_NAME)-package

pkg_basename     = $(PERL_32_PKG_NAME)-$(PERL_32_PKG_VERSION)-$(PERL_32_PKG_ARCH)-$(PERL_32_PKG_DISTRO_NAME)-$(PERL_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PERL_32_PKG)


LDFLAGS += -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCHNAME    = x86_32-linux

extra_configure_switches  = --mode=cross
extra_configure_switches += --target=$(shell echo $(TARGET) | sed 's/x86_64/i486/')
extra_configure_switches += --target-tools-prefix=$(CROSS_PREFIX)
extra_configure_switches += --sysroot=$(TARGET_DEST_DIR)
extra_configure_switches += -A lddlflags=--sysroot=$(TARGET_DEST_DIR) -A lddlflags=-melf_i386 -A lddlflags=-shared

extra_configure_switches += --html1dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += --html3dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += --man1dir=/usr/share/man/man1
extra_configure_switches += --man3dir=/usr/share/man/man3


extra_configure_switches += --set installstyle='lib$(MULTILIB_X86_32_SUFFIX)/perl5'

# -m32 for 'hostcc' & 'cc'
extra_configure_switches += -A hostccflags=-m32 -A hostldflags=-m32
extra_configure_switches += -A ccflags=-m32 -A ldflags=-m32

extra_configure_switches += --set libpth='/usr/lib$(MULTILIB_X86_32_SUFFIX) /lib$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set archname='$(ARCHNAME)'
extra_configure_switches += --set bin='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set scriptdir='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set libsdirs=' /lib$(MULTILIB_X86_32_SUFFIX) /usr/lib$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set privlib='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(version)'
extra_configure_switches += --set archlib='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(version)/$(ARCHNAME)'
extra_configure_switches += --set perlpath='/usr/bin/$(MULTILIB_X86_32_SUFFIX)/perl'


extra_configure_switches += --set sitebin='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set sitelib_stem='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl'
extra_configure_switches += --set sitelib='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl/$(version)'
extra_configure_switches += --set siteprefix='/usr'
extra_configure_switches += --set sitescript='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set sitearch='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl/$(version)/$(ARCHNAME)'
extra_configure_switches += --set sitearchexp='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl/$(version)/$(ARCHNAME)'
extra_configure_switches += --set sitebinexp='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set sitelibexp='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl/$(version)'
extra_configure_switches += --set siteprefixexp='/usr'
extra_configure_switches += --set sitescriptexp='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'

extra_configure_switches += --set installsitearch='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl/$(version)/$(ARCHNAME)'
extra_configure_switches += --set installsitebin='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'
extra_configure_switches += --set installsitelib='/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/site_perl/$(version)'
extra_configure_switches += --set installsitescript='/usr/bin/$(MULTILIB_X86_32_SUFFIX)'

extra_configure_switches += --set pager='/usr/bin/less -isr'


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
	@mkdir -p $(PERL_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@rm -rf $(PERL_32_PKG)/usr/share
	@( cd $(PERL_32_PKG)/usr/bin/32 ; \
	   rm -f perl ; \
	   ln -sf perl$(version) perl ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PERL_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Remove cross environment from target package =======
	@( cd $(PERL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(version)/$(ARCHNAME) ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               Config_heavy.pl ; \
	   sed -i "s,--sysroot=$(TARGET_DEST_DIR),,g"  Config_heavy.pl ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"            Config_heavy.pl ; \
	   sed -i "s,$(CURDIR)/$(TARGET_BUILD_DIR),,g" Config_heavy.pl ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               Config.pm       ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PERL_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PERL_32_PKG_DESCRIPTION_FILE): $(PERL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PERL_32_PKG_DESCRIPTION_FILE) $(PERL_32_PKG_INSTALL_SCRIPT)
	@cp $(PERL_32_PKG_DESCRIPTION_FILE) $(PERL_32_PKG)/.DESCRIPTION
	@cp $(PERL_32_PKG_INSTALL_SCRIPT) $(PERL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PERL_32_PKG)/.REQUIRES
	@echo "pkgname=$(PERL_32_PKG_NAME)"                            >  $(PERL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PERL_32_PKG_VERSION)"                          >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PERL_32_PKG_ARCH)"                               >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PERL_32_PKG_DISTRO_NAME)"                  >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PERL_32_PKG_DISTRO_VERSION)"                >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "group=$(PERL_32_PKG_GROUP)"                             >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PERL_32_PKG_SHORT_DESCRIPTION)\"" >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "url=$(PERL_32_PKG_URL)"                                 >> $(PERL_32_PKG)/.PKGINFO ; \
	 echo "license=$(PERL_32_PKG_LICENSE)"                         >> $(PERL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PERL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
