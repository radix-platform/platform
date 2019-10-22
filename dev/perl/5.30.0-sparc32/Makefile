
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/perl
SOURCE_REQUIRES   += sources/packages/d/perl-cross/1.3

REQUIRES           = dev/perl/5.30.0
REQUIRES          += libs/gdbm/1.11-sparc32

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
PERL_32_PKG_NAME                = perl-x32
PERL_32_PKG_VERSION             = 5.30.0
PERL_32_PKG_ARCH                = $(TOOLCHAIN)
PERL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PERL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PERL_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PERL_32_PKG_SHORT_DESCRIPTION   = Practical Extraction and Report Language
PERL_32_PKG_URL                 = $(BUG_URL)
PERL_32_PKG_LICENSE             = GPLv1
PERL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PERL_32_PKG_NAME)-pkg-description
PERL_32_PKG_DESCRIPTION_FILE_IN = $(PERL_32_PKG_NAME)-pkg-description.in
PERL_32_PKG_INSTALL_SCRIPT      = $(PERL_32_PKG_NAME)-pkg-install.sh

PERL_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PERL_32_PKG_NAME)-package

pkg_basename     = $(PERL_32_PKG_NAME)-$(PERL_32_PKG_VERSION)-$(PERL_32_PKG_ARCH)-$(PERL_32_PKG_DISTRO_NAME)-$(PERL_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PERL_32_PKG)


ARCHNAME    = sparc32-linux

LDFLAGS += -m32 -L$(TARGET_DEST_DIR)/lib$(MULTILIB_SPARC32_SUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_SPARC32_SUFFIX)

OPTIMIZATION_FLAGS += -fPIC
#
# If after all this time you still don't trust threads, comment out the variable below:
#
USE_THREADS = -Dusethreads -Duseithreads

extra_configure_switches  = --mode=cross
extra_configure_switches += --sysroot=$(TARGET_DEST_DIR)
extra_configure_switches += --target-tools-prefix=$(CROSS_PREFIX)
extra_configure_switches += --target=$(shell echo $(TARGET) | sed 's/x86_64/i686/')
extra_configure_switches += -Accflags=-I$(TARGET_DEST_DIR)/usr/include
extra_configure_switches += -Accflags=-m32

extra_configure_switches += -Dinstallstyle='lib$(MULTILIB_SPARC32_SUFFIX)/perl5'

extra_configure_switches += -Darchname='$(ARCHNAME)'
extra_configure_switches += -Dinstallprefix='/usr'
extra_configure_switches += -Dlibpth='/usr/lib$(MULTILIB_SPARC32_SUFFIX) /lib$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dloclibpth='/usr/lib$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dlocincpth='/usr/include'

extra_configure_switches += -Doptimize='$(OPTIMIZATION_FLAGS)'
extra_configure_switches += $(USE_THREADS)

extra_configure_switches += -Dprefix='/usr'
extra_configure_switches += -Dbin='/usr/bin/$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dscriptdir='/usr/bin/$(MULTILIB_SPARC32_SUFFIX)'

extra_configure_switches += -Darchlib='/usr/lib$(MULTILIB_SPARC32_SUFFIX)/perl5'
extra_configure_switches += -Dprivlib='/usr/share/perl5'

extra_configure_switches += -Dsiteprefix='/usr'
extra_configure_switches += -Dsitebin='/usr/bin/$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dsitescript='/usr/bin/$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dsitearch='/usr/lib$(MULTILIB_SPARC32_SUFFIX)/perl5/site_perl'
extra_configure_switches += -Dsitelib='/usr/share/perl5/site_perl'

extra_configure_switches += -Dvendorprefix='/usr'
extra_configure_switches += -Dvendorbin='/usr/bin/$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dvendorscript='/usr/bin/$(MULTILIB_SPARC32_SUFFIX)'
extra_configure_switches += -Dvendorarch='/usr/lib$(MULTILIB_SPARC32_SUFFIX)/perl5/vendor_perl'
extra_configure_switches += -Dvendorlib='/usr/share/perl5/vendor_perl'

extra_configure_switches += -Dcccdlflags='-fPIC'
extra_configure_switches += -Duseshrplib
extra_configure_switches += -Dlib_ext='.so'
extra_configure_switches += -Dlibperl='libperl.so'
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
	@cd $(SRC_DIR) && echo "installstyle='lib$(MULTILIB_SPARC32_SUFFIX)/perl5'" >> cnf/hints/linux
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
	  --prefix=/usr        \
	  --build=$(BUILD)     \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PERL_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PERL_32_PKG)/usr/share
	@( cd $(PERL_32_PKG)/usr/bin/32 ; \
	   mv perl perl$(version) ; \
	   ln -sf perl$(version) perl ; \
	 )
	# ======= Set Right Permissions for libperl.so =======
	@( cd $(PERL_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/perl5 ; \
	   find . -name '*.so' -exec chmod +w {} \; ; \
	 )
	# ======= Add Profile scripts =======
	@mkdir -p $(PERL_32_PKG)/etc/profile.d
	@cat $(profile_dir)/perl5-x32.csh.in | sed "s,@LIBDIRSUFFIX@,$(MULTILIB_SPARC32_SUFFIX),g" > $(PERL_32_PKG)/etc/profile.d/perl5-x32.csh
	@cat $(profile_dir)/perl5-x32.sh.in  | sed "s,@LIBDIRSUFFIX@,$(MULTILIB_SPARC32_SUFFIX),g" > $(PERL_32_PKG)/etc/profile.d/perl5-x32.sh
	@chmod 0644 $(PERL_32_PKG)/etc/profile.d/*
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PERL_32_PKG))
	# ======= Remove cross environment from target package =======
	@( cd $(PERL_32_PKG)/usr/lib$(MULTILIB_SPARC32_SUFFIX)/perl5 ; \
	   chmod +w Config.pm Config_heavy.pl ; \
	   sed -i "s,$(CROSS_PREFIX),,g"                      Config_heavy.pl ; \
	   sed -i "s,--sysroot=$(TARGET_DEST_DIR),,g"         Config_heavy.pl ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"                   Config_heavy.pl ; \
	   sed -i "s,\(^build=*\).*,\1'$(TARGET)',"           Config_heavy.pl ; \
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
	@( cd $(PERL_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(PERL_32_PKG_DESCRIPTION_FILE): $(PERL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(PERL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
