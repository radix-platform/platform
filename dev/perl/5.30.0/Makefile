
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/perl
SOURCE_REQUIRES   += sources/packages/d/perl-cross/1.3

REQUIRES           = libs/gdbm/1.11

# ======= __END_OF_REQUIRES__ =======


version            = 5.30.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/perl/perl-$(version).tar.xz
cross_xz_archive   = $(SRC_PACKAGE_PATH)/packages/d/perl-cross/1.3/perl-cross-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
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
PERL_PKG_VERSION             = 5.30.0
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


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC)  $(TOOLCHAIN_A2X_GLIBC)    \
                             $(TOOLCHAIN_H3_GLIBC)   $(TOOLCHAIN_RK328X_GLIBC) \
                             $(TOOLCHAIN_S8XX_GLIBC) $(TOOLCHAIN_IMX6_GLIBC)   \
                             $(TOOLCHAIN_OMAP543X_GLIBC)),)
ARCH = arm
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC)     $(TOOLCHAIN_RK33XX_GLIBC) \
                             $(TOOLCHAIN_RK339X_GLIBC) $(TOOLCHAIN_S9XX_GLIBC)),)
ARCH = aarch64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC)),)
ARCH = mips32r2
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_P5600_GLIBC)),)
ARCH = mips32r5
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
ARCH = sparc64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
ARCH = ppc64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8LE_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC)),)
ARCH = ppc64le
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC)),)
ARCH = x86_32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
ARCH = x86_64
endif


env_sysroot = DESTDIR=$(PERL_PKG)


ARCHNAME    = $(ARCH)-linux

OPTIMIZATION_FLAGS += -fPIC
#
# If after all this time you still don't trust threads, comment out the variable below:
#
USE_THREADS = -Dusethreads -Duseithreads

extra_configure_switches += --mode=cross
extra_configure_switches += --sysroot=$(TARGET_DEST_DIR)
extra_configure_switches += --target-tools-prefix=$(CROSS_PREFIX)
extra_configure_switches += -Accflags=-I$(TARGET_DEST_DIR)/usr/include

extra_configure_switches += -Dinstallstyle='lib$(LIBSUFFIX)/perl5'

extra_configure_switches += -Darchname='$(ARCHNAME)'
extra_configure_switches += -Dinstallprefix='/usr'
extra_configure_switches += -Dlibpth='/usr/lib$(LIBSUFFIX) /lib$(LIBSUFFIX)'
extra_configure_switches += -Dloclibpth='/usr/lib$(LIBSUFFIX)'
extra_configure_switches += -Dlocincpth='/usr/include'

extra_configure_switches += -Doptimize='$(OPTIMIZATION_FLAGS)'
extra_configure_switches += $(USE_THREADS)

extra_configure_switches += -Dprefix='/usr'
extra_configure_switches += -Dbin='/usr/bin'
extra_configure_switches += -Dscriptdir='/usr/bin'

extra_configure_switches += -Darchlib='/usr/lib$(LIBSUFFIX)/perl5'
extra_configure_switches += -Dprivlib='/usr/share/perl5'

extra_configure_switches += -Dsiteprefix='/usr'
extra_configure_switches += -Dsitebin='/usr/bin'
extra_configure_switches += -Dsitescript='/usr/bin'
extra_configure_switches += -Dsitearch='/usr/lib$(LIBSUFFIX)/perl5/site_perl'
extra_configure_switches += -Dsitelib='/usr/share/perl5/site_perl'

extra_configure_switches += -Dvendorprefix='/usr'
extra_configure_switches += -Dvendorbin='/usr/bin'
extra_configure_switches += -Dvendorscript='/usr/bin'
extra_configure_switches += -Dvendorarch='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl'
extra_configure_switches += -Dvendorlib='/usr/share/perl5/vendor_perl'

extra_configure_switches += -Dcccdlflags='-fPIC'
extra_configure_switches += -Duseshrplib
extra_configure_switches += -Dlibperl='libperl.so'
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC)   $(TOOLCHAIN_POWER9_GLIBC)   \
                             $(TOOLCHAIN_POWER8LE_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC) \
                             $(TOOLCHAIN_R1000_GLIBC)    $(TOOLCHAIN_X86_64_GLIBC)),)
extra_configure_switches += -Duselargefiles -Duse64bitall
endif
extra_configure_switches += -Ubincompat5005
extra_configure_switches += -Uversiononly

extra_configure_switches += -Dpager='/usr/bin/less -isr'

extra_configure_switches += -Dhtml1dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += -Dhtml3dir=/usr/share/doc/perl-$(version)/html
extra_configure_switches += -Dman1dir=/usr/share/man/man1
extra_configure_switches += -Dman3dir=/usr/share/man/man3


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@tar xJf $(cross_xz_archive) -C $(TARGET_BUILD_DIR)
	$(APPLY_PATCHES)
	@cd $(SRC_DIR) && echo "installstyle='lib$(LIBSUFFIX)/perl5'" >> cnf/hints/linux
	# ======= Fix symbolic links to cross patches =======
	@( cd $(SRC_DIR)/cnf/diffs ; \
	   for file in `find . -type l` ; do \
	     target=`readlink $$file` ; \
	     ln -sf "`echo $$target | sed 's,perl-,perl5-,'`" $$file ; \
	   done \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr      \
	  --build=$(BUILD)   \
	  --target=$(TARGET) \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PERL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(PERL_PKG)/usr/bin ; \
	   mv perl perl$(version) ; \
	   ln -sf perl$(version) perl ; \
	 )
	# ======= Set Right Permissions for libperl.so =======
	@( cd $(PERL_PKG)/usr/lib$(LIBSUFFIX)/perl5 ; \
	   find . -name '*.so' -exec chmod +w {} \; ; \
	 )
	# ======= Add Profile scripts =======
	@mkdir -p $(PERL_PKG)/etc/profile.d
	@cat $(profile_dir)/perl5.csh.in | sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" > $(PERL_PKG)/etc/profile.d/perl5.csh
	@cat $(profile_dir)/perl5.sh.in  | sed "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" > $(PERL_PKG)/etc/profile.d/perl5.sh
	@chmod 0755 $(PERL_PKG)/etc/profile.d/*
	# ======= Install Documentation ======
	@( cd $(PERL_PKG)/usr/share/man/man1 ; \
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
	   cp -a AUTHORS Artistic Changes Copying INSTALL README* \
	         $(PERL_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PERL_PKG))
	# ======= Remove cross environment from target package =======
	@( cd $(PERL_PKG)/usr/lib$(LIBSUFFIX)/perl5 ; \
	   chmod +w Config.pm Config_heavy.pl ; \
	   sed -i "s,$(CROSS_PREFIX),,g"                      Config_heavy.pl ; \
	   sed -i "s,--sysroot=$(TARGET_DEST_DIR),,g"         Config_heavy.pl ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"                   Config_heavy.pl ; \
	   host=`cat Config_heavy.pl | grep '^target=' | sed "s,target='\(.*\)'$$,\1,"` ; \
	   sed -i "s,\(^build=*\).*,\1'$$host',"              Config_heavy.pl ; \
	   sed -i 's,-Dpager=\([^ ]*[ ][^ ]*\),-Dpager="\1",' Config_heavy.pl ; \
	   sed -i 's,-Dlibpth=\([^\-]*\)[ ],-Dlibpth="\1" ,'  Config_heavy.pl ; \
	   sed -i "s,--build=[^ ]*[ ],,g"                     Config_heavy.pl ; \
	   sed -i "s,--target=[^ ]*[ ],,g"                    Config_heavy.pl ; \
	   sed -i "s,--mode=cross[ ],,g"                      Config_heavy.pl ; \
	   sed -i "s,-target-tools-prefix=[ ],,g"             Config_heavy.pl ; \
	   sed -i "s,-Alddlflags=[ ],,g"                      Config_heavy.pl ; \
	   sed -i "s,$(CROSS_PREFIX),,g"                      Config.pm       ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PERL_PKG)/usr/bin ; \
	   $(STRIP) --strip-unneeded perl$(version) 2> /dev/null ; \
	 )
	@( cd $(PERL_PKG)/usr/lib$(LIBSUFFIX)/perl5 ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs chmod +w 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
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
