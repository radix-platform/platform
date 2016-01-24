
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
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/d/perl-modules/CPAN/XML-SAX-Base

REQUIRES           = dev/perl/5.22.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.08
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/d/perl-modules/CPAN/XML-SAX-Base/XML-SAX-Base-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/XML-SAX-Base-$(version)
src_dir_name       = XML-SAX-Base-$(version)
doc_dir_name       = perl-xml-sax-base-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


NO_CCACHE = 1


####### Targets

PKG_GROUP = dev
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PERL_PKG_NAME                = perl-xml-sax-base
PERL_PKG_VERSION             = 1.08
PERL_PKG_ARCH                = $(TOOLCHAIN)
PERL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PERL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PERL_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
PERL_PKG_SHORT_DESCRIPTION   = XML SAX Base
PERL_PKG_URL                 = $(BUG_URL)
PERL_PKG_LICENSE             = GPLv1
PERL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PERL_PKG_NAME)-pkg-description
PERL_PKG_DESCRIPTION_FILE_IN = $(PERL_PKG_NAME)-pkg-description.in
PERL_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(PERL_PKG_NAME)-pkg-install.sh
PERL_PKG_INSTALL_SCRIPT_IN   = $(PERL_PKG_NAME)-pkg-install.sh.in

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


include ../../../../build-system/core.mk


#
# Global Variables:
# ================
#   ARCH            - defined in dev/perl/5.22.1/Makefile
#   UNAME_R_VERSION - used Linux kernel
#
# TODO: create special global collection for filling by package Makefiles
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH            = x86_32
UNAME_R_VERSION = 4.1.15
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH            = x86_64
UNAME_R_VERSION = 4.1.15
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
ARCH            = arm
UNAME_R_VERSION = 3.4.90
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB3X)),)
ARCH            = arm
UNAME_R_VERSION = 3.4.104
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
ARCH            = arm
UNAME_R_VERSION = 3.10.37
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_VIP1830)),)
ARCH            = arm
UNAME_R_VERSION = 2.6.36
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BEAGLE)),)
ARCH            = arm
UNAME_R_VERSION = 2.6.36
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
ARCH            = arm
UNAME_R_VERSION = 3.8.13
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_B74)),)
ARCH            = mipsel
UNAME_R_VERSION = 2.6.36
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
ARCH            = mips32r2
UNAME_R_VERSION = 3.18.3
GLIBC_VERSION   = 2.22
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BT1)),)
ARCH            = mips32r5
UNAME_R_VERSION = 4.1.15
GLIBC_VERSION   = 2.22
endif


env_sysroot = DESTDIR=$(PERL_PKG)

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
perl_environment += CCDLFLAGS='-Wl,-E -Wl,-rpath,/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE'
perl_environment += FULL_AR=$(AR)
perl_environment += LIBC=$(TARGET_DEST_DIR)/lib/libc-$(GLIBC_VERSION).so
perl_environment += OSNAME=linux
perl_environment += OSVERS=$(UNAME_R_VERSION)

perl_environment += PERL5LIB=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5

#
# Module Specific Perl5 Environment:
# =================================
#


perl_local_pod = usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/perllocal.pod


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd  $(SRC_DIR) ; \
	   for file in `find . -name *.pm` ; do \
	     chmod a-x $$file ; \
	   done ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@( cd  $(SRC_DIR) ; \
	   perl Makefile.PL ; \
	 )
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(perl_environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PERL_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(perl_environment) $(env_sysroot) ; \
	 )
	@find $(PERL_PKG) -name '.packlist' -delete
	@rm -f $(PERL_PKG)/$(perl_local_pod)
	# ======= Install Documentation =======
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
	@mkdir -p $(PERL_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/README \
	       $(PERL_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(PERL_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a README \
	         $(PERL_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r Changes ]; then \
	     DOCSDIR=`echo $(PERL_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat Changes | head -n 1000 > $$DOCSDIR/Changes ; \
	     touch -r Changes $$DOCSDIR/Changes ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PERL_PKG))
	@touch $@

$(PERL_PKG_DESCRIPTION_FILE): $(PERL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(PERL_PKG_INSTALL_SCRIPT): $(PERL_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s,@PERL_LOCAL_POD@,$(perl_local_pod),g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PERL_PKG_DESCRIPTION_FILE) $(PERL_PKG_INSTALL_SCRIPT)
	@cp $(PERL_PKG_DESCRIPTION_FILE) $(PERL_PKG)/.DESCRIPTION
	@cp $(PERL_PKG_INSTALL_SCRIPT) $(PERL_PKG)/.INSTALL
	@chmod a+x $(PERL_PKG)/.INSTALL
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
