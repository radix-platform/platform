
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/perl
SOURCE_REQUIRES   += sources/packages/d/perl-cross/1.0.2

REQUIRES           = libs/gdbm/1.11

# ======= __END_OF_REQUIRES__ =======


version            = 5.22.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/perl/perl-$(version).tar.gz
cross_bz2_archive  = $(SRC_PACKAGE_PATH)/packages/d/perl-cross/1.0.2/perl-cross-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/perl-$(version)
src_dir_name       = perl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


profile_dir        = $(CURDIR)/profile.d


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
PERL_PKG_VERSION             = 5.22.1
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
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH = x86_32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH = x86_64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201) $(HARDWARE_MXV)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH = aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
ARCH = mips32r2
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
ARCH = mips32r5
endif


env_sysroot = DESTDIR=$(PERL_PKG)

ARCHNAME    = $(ARCH)-linux

extra_configure_switches  = --mode=cross
extra_configure_switches += --target=$(TARGET)
extra_configure_switches += --target-tools-prefix=$(CROSS_PREFIX)
extra_configure_switches += --sysroot=$(TARGET_DEST_DIR)
extra_configure_switches += -A lddlflags=--sysroot=$(TARGET_DEST_DIR) -A lddlflags=-shared

extra_configure_switches += --set archname='$(ARCHNAME)'
extra_configure_switches += --set libpth='/usr/lib$(LIBSUFFIX) /lib$(LIBSUFFIX)'

extra_configure_switches += --set bin='/usr/bin'
extra_configure_switches += --set scriptdir='/usr/bin'
extra_configure_switches += --set libsdirs=' /lib$(LIBSUFFIX) /usr/lib$(LIBSUFFIX)'

extra_configure_switches += --set privlib='/usr/lib$(LIBSUFFIX)/perl5'
extra_configure_switches += --set archlib='/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)'

extra_configure_switches += --set siteprefix='/usr'
extra_configure_switches += --set sitebin='/usr/bin/site_perl'
extra_configure_switches += --set sitescript='/usr/bin/site_perl'
extra_configure_switches += --set sitelib='/usr/lib$(LIBSUFFIX)/perl5/site_perl'
extra_configure_switches += --set sitearch='/usr/lib$(LIBSUFFIX)/perl5/site_perl/$(ARCHNAME)'

extra_configure_switches += --set vendorprefix='/usr'
extra_configure_switches += --set vendorbin='/usr/bin/vendor_perl'
extra_configure_switches += --set vendorscript='/usr/bin/vendor_perl'
extra_configure_switches += --set vendorlib='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl'
extra_configure_switches += --set vendorarch='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl/$(ARCHNAME)'

extra_configure_switches += --set cccdlflags='-fPIC'
extra_configure_switches += -D useshrplib
extra_configure_switches += --set libperl='libperl.so'
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += -D uselargefiles -D use64bitall
endif

extra_configure_switches += --set pager='/usr/bin/less -isr'

extra_configure_switches += --html1dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += --html3dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += --man1dir=/usr/share/man/man1
extra_configure_switches += --man3dir=/usr/share/man/man3


TARGET_BIN_RPATH = /usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE


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
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(PERL_PKG)/usr/bin ; \
	   rm -f perl ; \
	   ln -sf perl$(version) perl ; \
	 )
	# ======= Set Right Permissions for libperl.so  =======
	@( cd $(PERL_PKG)/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE ; \
	   chmod 0755 libperl.so ; \
	 )
	# ======= Add Profile scripts =======
	@mkdir -p $(PERL_PKG)/etc/profile.d
	@cat $(profile_dir)/perl5.csh.in | sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" > $(PERL_PKG)/etc/profile.d/perl5.csh
	@cat $(profile_dir)/perl5.sh.in  | sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" > $(PERL_PKG)/etc/profile.d/perl5.sh
	@chmod 0755 $(PERL_PKG)/etc/profile.d/*
	# ======= Install Documentation ======
	@( cd $(PERL_PKG)/usr/share/man/man1 ; \
	   rm -f pstruct.1 ; ln -sf c2ph.1 pstruct.1 ; \
	   rm -f perlthanks.1 ; ln -sf perlbug.1 perlthanks.1 ; \
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
	@mkdir -p $(PERL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/Artistic $(SRC_DIR)/Copying \
	       $(PERL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PERL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS Artistic Changes Copying INSTALL MANIFEST README* \
	         $(PERL_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PERL_PKG))
	# ======= Remove cross environment from target package =======
	@( cd $(PERL_PKG)/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME) ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               Config_heavy.pl ; \
	   sed -i "s,--sysroot=$(TARGET_DEST_DIR),,g"  Config_heavy.pl ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"            Config_heavy.pl ; \
	   sed -i "s,$(CURDIR)/$(TARGET_BUILD_DIR),,g" Config_heavy.pl ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               Config.pm       ; \
	   sed -i "s,$(CROSS_PREFIX),,g"               CORE/config.h   ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PERL_PKG)/usr/bin ; \
	   $(STRIP) --strip-unneeded perl$(version) 2> /dev/null ; \
	 )
	@( cd $(PERL_PKG)//usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME) ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs chmod +w 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target perl$(version) binary =======
	@( cd $(PERL_PKG)/usr/bin ; \
	   rpath=`$(CHRPATH) -l perl$(version) 2> /dev/null | grep "R*PATH"` ; \
	   if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	     $(CHRPATH) -r $(TARGET_BIN_RPATH) perl$(version) 1> /dev/null 2> /dev/null ; \
	   fi ; \
	 )
endif
	@touch $@

$(PERL_PKG_DESCRIPTION_FILE): $(PERL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(PERL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
