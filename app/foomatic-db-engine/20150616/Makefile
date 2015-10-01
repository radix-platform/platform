
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/foomatic-db-engine

REQUIRES           = app/foomatic-db/20150904
REQUIRES          += dev/perl-modules/perl-clone/0.38
REQUIRES          += dev/perl-modules/perl-dbi/1.634
REQUIRES          += dev/perl-modules/perl-xml-libxml/2.0122

# ======= __END_OF_REQUIRES__ =======


version            = 20150616
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/foomatic-db-engine/foomatic-db-engine-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/foomatic-db-engine-$(version)
src_dir_name       = foomatic-db-engine-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FODB_ENGINE_PKG_NAME                = foomatic-db-engine
FODB_ENGINE_PKG_VERSION             = 20150616
FODB_ENGINE_PKG_ARCH                = $(TOOLCHAIN)
FODB_ENGINE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FODB_ENGINE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FODB_ENGINE_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
FODB_ENGINE_PKG_SHORT_DESCRIPTION   = Foomatic Database Engine
FODB_ENGINE_PKG_URL                 = $(BUG_URL)
FODB_ENGINE_PKG_LICENSE             = GPLv2
FODB_ENGINE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FODB_ENGINE_PKG_NAME)-pkg-description
FODB_ENGINE_PKG_DESCRIPTION_FILE_IN = $(FODB_ENGINE_PKG_NAME)-pkg-description.in
FODB_ENGINE_PKG_INSTALL_SCRIPT      = $(FODB_ENGINE_PKG_NAME)-pkg-install.sh

FODB_ENGINE_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FODB_ENGINE_PKG_NAME)-package

pkg_basename     = $(FODB_ENGINE_PKG_NAME)-$(FODB_ENGINE_PKG_VERSION)-$(FODB_ENGINE_PKG_ARCH)-$(FODB_ENGINE_PKG_DISTRO_NAME)-$(FODB_ENGINE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


#
# Global Variables:
# ================
#   ARCH            - defined in dev/perl/2.18.2/Makefile
#   UNAME_R_VERSION - used Linux kernel
#
# TODO: create special global collection for filling by package Makefiles
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH            = x86_32
UNAME_R_VERSION = 3.10.17
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH            = x86_64
UNAME_R_VERSION = 3.10.17
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
ARCH            = arm
UNAME_R_VERSION = 3.4.90
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB3X)),)
ARCH            = arm
UNAME_R_VERSION = 3.4.104
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
ARCH            = arm
UNAME_R_VERSION = 3.10.37
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_VIP1830)),)
ARCH            = arm
UNAME_R_VERSION = 2.6.36
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BEAGLE)),)
ARCH            = arm
UNAME_R_VERSION = 2.6.36
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
ARCH            = arm
UNAME_R_VERSION = 3.8.13
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_B74)),)
ARCH            = mipsel
UNAME_R_VERSION = 2.6.36
GLIBC_VERSION   = 2.21
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
ARCH            = mips32r2
UNAME_R_VERSION = 3.0.8
GLIBC_VERSION   = 2.21
endif


env_sysroot = DESTDIR=$(FODB_ENGINE_PKG)

ARCHNAME    = $(ARCH)-linux

#
# Common Perl5 Environment:
# ========================
#
perl_environment  = INSTALLDIRS=vendor

perl_environment += PERL_LIB='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5'
perl_environment += PERL_ARCHLIB='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)'
perl_environment += PERL_INC='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE'

perl_environment += SITELIBEXP='/usr/lib$(LIBSUFFIX)/perl5/site_perl'
perl_environment += SITEARCHEXP='/usr/lib$(LIBSUFFIX)/perl5/site_perl/$(ARCHNAME)'
perl_environment += VENDORLIBEXP='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl'
perl_environment += VENDORARCHEXP='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl/$(ARCHNAME)'

perl_environment += PERLPREFIX='/usr'
perl_environment += INSTALLPRIVLIB='/usr/lib$(LIBSUFFIX)/perl5'
perl_environment += INSTALLARCHLIB='/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)'

perl_environment += SITEPREFIX='/usr'
perl_environment += INSTALLSITELIB='/usr/lib$(LIBSUFFIX)/perl5/site_perl'
perl_environment += INSTALLSITEARCH='/usr/lib$(LIBSUFFIX)/perl5/site_perl/$(ARCHNAME)'

perl_environment += VENDORPREFIX='/usr'
perl_environment += INSTALLVENDORLIB='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl'
perl_environment += INSTALLVENDORARCH='/usr/lib$(LIBSUFFIX)/perl5/vendor_perl/$(ARCHNAME)'

perl_environment += INSTALLBIN='/usr/bin'
perl_environment += INSTALLSITEBIN='/usr/bin/site_perl'
perl_environment += INSTALLVENDORBIN='/usr/bin/vendor_perl'

perl_environment += INSTALLSCRIPT='/usr/bin'
perl_environment += INSTALLSITESCRIPT='/usr/bin/site_perl'
perl_environment += INSTALLVENDORSCRIPT='/usr/bin/vendor_perl'

perl_environment += INSTALLMAN1DIR='/usr/share/man/man1'
perl_environment += INSTALLSITEMAN1DIR='/usr/share/man/man1'
perl_environment += INSTALLVENDORMAN1DIR='/usr/share/man/man1'

perl_environment += INSTALLMAN3DIR='/usr/share/man/man3'
perl_environment += INSTALLSITEMAN3DIR='/usr/share/man/man3'
perl_environment += INSTALLVENDORMAN3DIR='/usr/share/man/man3'

#
# HW Specific Perl5 Environment:
# =============================
#
perl_environment += AR=$(AR)
perl_environment += CC='$(CC) --sysroot=$(TARGET_DEST_DIR) $(ARCH_OPTIMIZATION) $(ARCH_FLAGS) $(ARCH_DEFS)'
perl_environment += LD='$(LD) --sysroot=$(TARGET_DEST_DIR)'
perl_environment += LDFLAGS='--sysroot=$(TARGET_DEST_DIR) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
perl_environment += CCCDLFLAGS='-fPIC'
perl_environment += CCDLFLAGS='-Wl,-E -Wl,-rpath,/usr/lib$(LIBSUFFIX)/perl5/CORE'
perl_environment += FULL_AR=$(AR)
perl_environment += LIBC=$(TARGET_DEST_DIR)/lib/libc-$(GLIBC_VERSION).so
perl_environment += OSNAME=linux
perl_environment += OSVERS=$(UNAME_R_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


perl_configure_environment = PERL_INSTALLDIRS=vendor


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(perl_configure_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(perl_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FODB_ENGINE_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(perl_environment) $(env_sysroot) install
	@find $(FODB_ENGINE_PKG) -name '.packlist' -delete
	@( cd $(FODB_ENGINE_PKG)/usr/lib$(LIBSUFFIX)/cups/driver ; \
	   rm -f foomatic ; \
	   ln -sf ../../../bin/foomatic-ppdfile foomatic ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(FODB_ENGINE_PKG)/usr/share/man ]; then \
	  ( cd $(FODB_ENGINE_PKG)/usr/share/man ; \
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
	@mkdir -p $(FODB_ENGINE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(FODB_ENGINE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FODB_ENGINE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README TODO USAGE \
	         $(FODB_ENGINE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(FODB_ENGINE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FODB_ENGINE_PKG))
	@touch $@

$(FODB_ENGINE_PKG_DESCRIPTION_FILE): $(FODB_ENGINE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FODB_ENGINE_PKG_DESCRIPTION_FILE) $(FODB_ENGINE_PKG_INSTALL_SCRIPT)
	@cp $(FODB_ENGINE_PKG_DESCRIPTION_FILE) $(FODB_ENGINE_PKG)/.DESCRIPTION
	@cp $(FODB_ENGINE_PKG_INSTALL_SCRIPT) $(FODB_ENGINE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FODB_ENGINE_PKG)/.REQUIRES
	@echo "pkgname=$(FODB_ENGINE_PKG_NAME)"                            >  $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FODB_ENGINE_PKG_VERSION)"                          >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "arch=$(FODB_ENGINE_PKG_ARCH)"                               >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "distroname=$(FODB_ENGINE_PKG_DISTRO_NAME)"                  >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "distrover=$(FODB_ENGINE_PKG_DISTRO_VERSION)"                >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "group=$(FODB_ENGINE_PKG_GROUP)"                             >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FODB_ENGINE_PKG_SHORT_DESCRIPTION)\"" >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "url=$(FODB_ENGINE_PKG_URL)"                                 >> $(FODB_ENGINE_PKG)/.PKGINFO ; \
	 echo "license=$(FODB_ENGINE_PKG_LICENSE)"                         >> $(FODB_ENGINE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FODB_ENGINE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
