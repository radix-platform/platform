
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/b/postgresql

REQUIRES           = app/postgresql/9.6.0
REQUIRES          += dev/perl/5.22.1-x86_32
REQUIRES          += dev/python2/2.7.16-x86_32
REQUIRES          += dev/python3/3.7.4-x86_32
REQUIRES          += libs/libxml2/2.9.9-x86_32
REQUIRES          += libs/libxslt/1.1.33-x86_32
REQUIRES          += net/openssl/1.1.1d-x86_32
REQUIRES          += secure/pam_unix2/2.9.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 9.6.0
pg_version         = $(shell echo $(version) | cut -f1,2 -d '.')
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/b/postgresql/postgresql-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/postgresql-$(version)
src_dir_name       = postgresql-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

abs_build_dir      = $(CURDIR)/$(build_dir)


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PGSQL_32_PKG_NAME                = postgresql-x32
PGSQL_32_PKG_VERSION             = 9.6.0
PGSQL_32_PKG_ARCH                = $(TOOLCHAIN)
PGSQL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PGSQL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PGSQL_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PGSQL_32_PKG_SHORT_DESCRIPTION   = database management system
PGSQL_32_PKG_URL                 = $(BUG_URL)
PGSQL_32_PKG_LICENSE             = custom
PGSQL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PGSQL_32_PKG_NAME)-pkg-description
PGSQL_32_PKG_DESCRIPTION_FILE_IN = $(PGSQL_32_PKG_NAME)-pkg-description.in
PGSQL_32_PKG_INSTALL_SCRIPT      = $(PGSQL_32_PKG_NAME)-pkg-install.sh

PGSQL_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PGSQL_32_PKG_NAME)-package

pkg_basename     = $(PGSQL_32_PKG_NAME)-$(PGSQL_32_PKG_VERSION)-$(PGSQL_32_PKG_ARCH)-$(PGSQL_32_PKG_DISTRO_NAME)-$(PGSQL_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(PGSQL_32_PKG)


ARCHNAME    = x86_32-linux

extra_environment  = pgac_perl_version=5.22.1
extra_environment += perl_archlibexp='$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(ARCHNAME)'
extra_environment += perl_privlibexp='$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5'
extra_environment += perl_useshrplib='true'
extra_environment += perl_embed_ldflags='-L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(ARCHNAME)/CORE -Wl,-E -Wl,-rpath,/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(ARCHNAME)/CORE -lperl'


#
# Python Configuration:
#
PYTHON_MAJOR_VERSION = 3

ifeq ($(PYTHON_MAJOR_VERSION),3)
PYTHON_VERSION = 3.5

extra_environment += python_majorversion=$(PYTHON_MAJOR_VERSION)
extra_environment += python_version=$(PYTHON_VERSION)
extra_environment += python_configdir='$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/config-$(PYTHON_VERSION)m'
extra_environment += python_includespec='-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m'
extra_environment += python_libdir='$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
extra_environment += python_enable_shared=1
extra_environment += python_libspec='-L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) -lpython$(PYTHON_VERSION)m'
extra_environment += python_additional_libs='-lpthread -ldl -lutil -lm'
endif

ifeq ($(PYTHON_MAJOR_VERSION),2)
PYTHON_VERSION = 2.7

extra_environment += python_majorversion=$(PYTHON_MAJOR_VERSION)
extra_environment += python_version=$(PYTHON_VERSION)
extra_environment += python_configdir='$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)'
extra_environment += python_includespec='-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)'
extra_environment += python_libdir='$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)'
extra_environment += python_enable_shared=1
extra_environment += python_libspec='-L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) -lpython$(PYTHON_VERSION)'
extra_environment += python_additional_libs='-lpthread -ldl -lutil -lm'
endif


#
# configure switches:
#
extra_configure_switches  = --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --sysconfdir=/etc/postgresql/$(pg_version)
extra_configure_switches += --datarootdir=/usr/share
extra_configure_switches += --datadir=/usr/share/postgresql-$(pg_version)

extra_configure_switches += --with-openssl
extra_configure_switches += --with-tcl=no
extra_configure_switches += --with-perl
extra_configure_switches += --with-python
extra_configure_switches += --with-libxml
extra_configure_switches += --with-libxslt
extra_configure_switches += --enable-thread-safety
extra_configure_switches += --with-system-tzdata=/usr/share/zoneinfo
extra_configure_switches += --enable-nls
extra_configure_switches += --with-pam


TARGET_PERL_RPATH   = /usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)/perl5/$(ARCHNAME)/CORE:/usr/lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version)/lib
TARGET_PYTHON_RPATH = /usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version)/lib
TARGET_LIB_RPATH    = $(TARGET_PYTHON_RPATH)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(extra_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr/lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version) \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PGSQL_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PGSQL_32_PKG)/usr/include
	@rm -rf $(PGSQL_32_PKG)/usr/share
	# ======= create symlinks to binary executables =======
	@mkdir -p $(PGSQL_32_PKG)/usr/bin/32
	@( cd $(PGSQL_32_PKG)/usr/bin/32 ; \
	   for i in `ls ../../lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version)/bin/*` ; do \
	     ln -sf $$i ; \
	   done ; \
	 )
	# ======= create symlinks to shared library for other programs =======
	@( cd $(PGSQL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for i in `ls postgresql/$(pg_version)/lib/lib*.so*` ; do \
	     ln -sf $$i ; \
	   done ; \
	 )
	# ======= create symlinks to pkg-config files for other programs =======
	@mkdir $(PGSQL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig
	@( cd $(PGSQL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   for i in `ls ../postgresql/$(pg_version)/lib/pkgconfig/*.pc` ; do \
	     ln -sf $$i ; \
	   done ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(PGSQL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version)/lib/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libecpg.pc    libecpg_compat.pc  \
	                                    libpgtypes.pc libpq.pc         ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PGSQL_32_PKG))
	# ======= tune target Makefile.global variables =======
	@( cd $(PGSQL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version)/lib/pgxs/src ; \
	   sed -i "s,$(abs_build_dir),/usr/src/x86_32/build-pgsql,g" Makefile.global ; \
	   sed -i "s,$(BUILD),$(TARGET32),g"                         Makefile.global ; \
	   sed -i "s, --sysroot=$(TARGET_DEST_DIR),,g"               Makefile.global ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"                          Makefile.global ; \
	   sed -i "s,CC=.*-gcc,CC=/usr/bin/gcc,g"                    Makefile.global ; \
	   sed -i "s,CPP = .*-gcc,CPP = /usr/bin/gcc,g"              Makefile.global ; \
	   sed -i "s,CC = .*-gcc,CC = /usr/bin/gcc,g"                Makefile.global ; \
	   sed -i "s,AR = .*-ar,AR = /usr/bin/ar,g"                  Makefile.global ; \
	   sed -i "s,LD = .*-ld,LD = /usr/bin/ld -melf_i386,g"       Makefile.global ; \
	   sed -i "s,RANLIB = .*-ranlib,RANLIB = /usr/bin/ranlib,g"  Makefile.global ; \
	   sed -i "s,= .*-strip,= /usr/bin/strip,g"                  Makefile.global ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/postgresql/$(pg_version)/lib/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libecpg.pc    libecpg_compat.pc  \
	                                            libpgtypes.pc libpq.pc         ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libecpg.pc    libecpg_compat.pc  \
	                                              libpgtypes.pc libpq.pc         ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PGSQL_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PGSQL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)postgresql/$(pg_version)/lib ; \
	   for file in plperl.so ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_PERL_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	   for file in plpython$(PYTHON_MAJOR_VERSION).so ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_PYTHON_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PGSQL_32_PKG_DESCRIPTION_FILE): $(PGSQL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PGSQL_32_PKG_DESCRIPTION_FILE) $(PGSQL_32_PKG_INSTALL_SCRIPT)
	@cp $(PGSQL_32_PKG_DESCRIPTION_FILE) $(PGSQL_32_PKG)/.DESCRIPTION
	@cp $(PGSQL_32_PKG_INSTALL_SCRIPT) $(PGSQL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PGSQL_32_PKG)/.REQUIRES
	@echo "pkgname=$(PGSQL_32_PKG_NAME)"                            >  $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PGSQL_32_PKG_VERSION)"                          >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PGSQL_32_PKG_ARCH)"                               >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PGSQL_32_PKG_DISTRO_NAME)"                  >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PGSQL_32_PKG_DISTRO_VERSION)"                >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "group=$(PGSQL_32_PKG_GROUP)"                             >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PGSQL_32_PKG_SHORT_DESCRIPTION)\"" >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "url=$(PGSQL_32_PKG_URL)"                                 >> $(PGSQL_32_PKG)/.PKGINFO ; \
	 echo "license=$(PGSQL_32_PKG_LICENSE)"                         >> $(PGSQL_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PGSQL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
