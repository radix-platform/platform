
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


SOURCE_REQUIRES    = sources/packages/b/postgresql

REQUIRES           = dev/perl/5.22.1
REQUIRES          += dev/python2/2.7.11
REQUIRES          += dev/python3/3.5.1
REQUIRES          += libs/libxml2/2.9.3
REQUIRES          += libs/libxslt/1.1.28
REQUIRES          += net/openssl/1.0.2f
REQUIRES          += secure/pam_unix2/2.9.1

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

abs_build_dir       = $(CURDIR)/$(build_dir)

pg_port            = 5432
pg_uid             = 209
pg_gid             = 209

rc_postgresql_in   = $(CURDIR)/etc/rc.d/rc.postgresql.in
logrotate_in       = $(CURDIR)/etc/logrotate.d/postgresql.in
postgresql_pam     = $(CURDIR)/etc/pam.d/postgresql
setup_script_in    = $(CURDIR)/setup/setup.postgresql.in


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PGSQL_PKG_NAME                = postgresql
PGSQL_PKG_VERSION             = 9.6.0
PGSQL_PKG_ARCH                = $(TOOLCHAIN)
PGSQL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PGSQL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PGSQL_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PGSQL_PKG_SHORT_DESCRIPTION   = database management system
PGSQL_PKG_URL                 = $(BUG_URL)
PGSQL_PKG_LICENSE             = custom
PGSQL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PGSQL_PKG_NAME)-pkg-description
PGSQL_PKG_DESCRIPTION_FILE_IN = $(PGSQL_PKG_NAME)-pkg-description.in
PGSQL_PKG_INSTALL_SCRIPT      = $(PGSQL_PKG_NAME)-pkg-install.sh

PGSQL_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PGSQL_PKG_NAME)-package

pkg_basename     = $(PGSQL_PKG_NAME)-$(PGSQL_PKG_VERSION)-$(PGSQL_PKG_ARCH)-$(PGSQL_PKG_DISTRO_NAME)-$(PGSQL_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PGSQL_PKG)


#
# PERL Configuration:
#
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

ARCHNAME    = $(ARCH)-linux

extra_environment  = pgac_perl_version=5.22.1
extra_environment += perl_archlibexp='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)'
extra_environment += perl_privlibexp='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5'
extra_environment += perl_useshrplib='true'
extra_environment += perl_embed_ldflags='-L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE -Wl,-E -Wl,-rpath,/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE -lperl'


#
# Python Configuration:
#
PYTHON_MAJOR_VERSION = 3

ifeq ($(PYTHON_MAJOR_VERSION),3)
PYTHON_VERSION = 3.5

extra_environment += python_majorversion=$(PYTHON_MAJOR_VERSION)
extra_environment += python_version=$(PYTHON_VERSION)
extra_environment += python_configdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config-$(PYTHON_VERSION)m'
extra_environment += python_includespec='-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m'
extra_environment += python_libdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
extra_environment += python_enable_shared=1
extra_environment += python_libspec='-L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lpython$(PYTHON_VERSION)m'
extra_environment += python_additional_libs='-lpthread -ldl -lutil -lm'
endif

ifeq ($(PYTHON_MAJOR_VERSION),2)
PYTHON_VERSION = 2.7

extra_environment += python_majorversion=$(PYTHON_MAJOR_VERSION)
extra_environment += python_version=$(PYTHON_VERSION)
extra_environment += python_configdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)'
extra_environment += python_includespec='-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)'
extra_environment += python_libdir='$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
extra_environment += python_enable_shared=1
extra_environment += python_libspec='-L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lpython$(PYTHON_VERSION)'
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


#
# Some interesting additional modules:
#   http://www.postgresql.org/docs/9.6/static/contrib.html
#
# adminpack           - helper extension for pgAdmin
# pgcrypto            - extension for some business applications
# hstore, ltree, xml2 - useful extensions for developers
# pg_standby          - high availability helpers
# postgres_fdw        - foreign-data wrapper for access to external PostgreSQL servers
# file_fdw            - foreign-data wrapper for access to data files on filesystem
#
PG_EXTENSIONS  = adminpack pgcrypto hstore ltree xml2
PG_EXTENSIONS += pg_standby postgres_fdw file_fdw


TARGET_PERL_RPATH   = /usr/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE:/usr/lib$(LIBSUFFIX)/postgresql/$(pg_version)/lib
TARGET_PYTHON_RPATH = /usr/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)/postgresql/$(pg_version)/lib
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
	  --prefix=/usr/lib$(LIBSUFFIX)/postgresql/$(pg_version) \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@( cd $(build_dir)/contrib ; \
	   for ext in $(PG_EXTENSIONS) ; do \
	     ( cd $$ext && $(BUILD_ENVIRONMENT) $(MAKE) -j1 ) ; \
	   done ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PGSQL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(build_dir)/contrib ; \
	   for ext in $(PG_EXTENSIONS) ; do \
	     ( cd $$ext && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot) ) ; \
	   done ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-docs $(env_sysroot)
	# ======= create symlinks to binary executables =======
	@mkdir -p $(PGSQL_PKG)/usr/bin
	@( cd $(PGSQL_PKG)/usr/bin ; \
	   for i in `ls ../lib$(LIBSUFFIX)/postgresql/$(pg_version)/bin/*` ; do \
	     ln -sf $$i ; \
	   done ; \
	 )
	# ======= create symlinks to shared library for other programs =======
	@( cd $(PGSQL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for i in `ls postgresql/$(pg_version)/lib/lib*.so*` ; do \
	     ln -sf $$i ; \
	   done ; \
	 )
	# ======= create symlinks to pkg-config files for other programs =======
	@mkdir $(PGSQL_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@( cd $(PGSQL_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   for i in `ls ../postgresql/$(pg_version)/lib/pkgconfig/*.pc` ; do \
	     ln -sf $$i ; \
	   done ; \
	 )
	# ======= create database directories =======
	@mkdir -p $(PGSQL_PKG)/var/lib/pgsql/$(pg_version)/data
	# ======= install system scripts =======
	@mkdir -p $(PGSQL_PKG)/etc/rc.d
	@sed -e "s/@PG_VERSION@/$(pg_version)/" \
	     -e "s/@PKGNAME@/postgresql/" \
	     -e "s/@PG_PORT@/$(pg_port)/" \
	     -e "s/@LIBDIRSUFFIX@/$(LIBSUFFIX)/" \
	        $(rc_postgresql_in) > $(PGSQL_PKG)/etc/rc.d/rc.postgresql.new
	@mkdir -p $(PGSQL_PKG)/etc/logrotate.d
	@sed -e "s/@PG_VERSION@/$(pg_version)/" \
	     -e "s/@PKGNAME@/postgresql/" \
	        $(logrotate_in) > $(PGSQL_PKG)/etc/logrotate.d/postgresql.new
	@mkdir -p $(PGSQL_PKG)/etc/pam.d
	@cp -a $(postgresql_pam) $(PGSQL_PKG)/etc/pam.d/postgresql.new
	@mkdir -p $(PGSQL_PKG)/var/log/$(DISTRO_NAME)/setup
	@sed -e "s/@PG_VERSION@/$(pg_version)/" \
	     -e "s/@UID@/$(pg_uid)/" \
	     -e "s/@GID@/$(pg_gid)/" \
	        $(setup_script_in) > $(PGSQL_PKG)/var/log/$(DISTRO_NAME)/setup/setup.postgresql
	@chmod 0755 $(PGSQL_PKG)/var/log/$(DISTRO_NAME)/setup/setup.postgresql
	@mkdir -p $(PGSQL_PKG)/var/run/pgsql
	# ======= Install Documentation =======
	@( cd $(PGSQL_PKG)/usr/share/man/man7 ; \
	   for file in *.7 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(PGSQL_PKG)/usr/share/man ]; then \
	  ( cd $(PGSQL_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(PGSQL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYRIGHT \
	       $(PGSQL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PGSQL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYRIGHT HISTORY INSTALL README doc/TODO \
	         $(PGSQL_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PGSQL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(PGSQL_PKG)/usr/lib$(LIBSUFFIX)/postgresql/$(pg_version)/lib/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libecpg.pc    libecpg_compat.pc  \
	                                    libpgtypes.pc libpq.pc         ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PGSQL_PKG))
	# ======= tune target Makefile.global variables =======
	@( cd $(PGSQL_PKG)/usr/lib$(LIBSUFFIX)/postgresql/$(pg_version)/lib/pgxs/src ; \
	   sed -i "s,$(abs_build_dir),/usr/src/build-pgsql,g"       Makefile.global ; \
	   sed -i "s,$(BUILD),$(TARGET),g"                          Makefile.global ; \
	   sed -i "s, --sysroot=$(TARGET_DEST_DIR),,g"              Makefile.global ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"                         Makefile.global ; \
	   sed -i "s,CC=.*-gcc,CC=/usr/bin/gcc,g"                   Makefile.global ; \
	   sed -i "s,CPP = .*-gcc,CPP = /usr/bin/gcc,g"             Makefile.global ; \
	   sed -i "s,CC = .*-gcc,CC = /usr/bin/gcc,g"               Makefile.global ; \
	   sed -i "s,AR = .*-ar,AR = /usr/bin/ar,g"                 Makefile.global ; \
	   sed -i "s,LD = .*-ld,LD = /usr/bin/ld,g"                 Makefile.global ; \
	   sed -i "s,RANLIB = .*-ranlib,RANLIB = /usr/bin/ranlib,g" Makefile.global ; \
	   sed -i "s,= .*-strip,= /usr/bin/strip,g"                 Makefile.global ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/postgresql/$(pg_version)/lib/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libecpg.pc    libecpg_compat.pc  \
	                                            libpgtypes.pc libpq.pc         ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libecpg.pc    libecpg_compat.pc  \
	                                              libpgtypes.pc libpq.pc         ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PGSQL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PGSQL_PKG)/usr/lib$(LIBSUFFIX)postgresql/$(pg_version)/lib ; \
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

$(PGSQL_PKG_DESCRIPTION_FILE): $(PGSQL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PGSQL_PKG_DESCRIPTION_FILE) $(PGSQL_PKG_INSTALL_SCRIPT)
	@cp $(PGSQL_PKG_DESCRIPTION_FILE) $(PGSQL_PKG)/.DESCRIPTION
	@cp $(PGSQL_PKG_INSTALL_SCRIPT) $(PGSQL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PGSQL_PKG)/.REQUIRES
	@echo "pkgname=$(PGSQL_PKG_NAME)"                            >  $(PGSQL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PGSQL_PKG_VERSION)"                          >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "arch=$(PGSQL_PKG_ARCH)"                               >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "distroname=$(PGSQL_PKG_DISTRO_NAME)"                  >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "distrover=$(PGSQL_PKG_DISTRO_VERSION)"                >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "group=$(PGSQL_PKG_GROUP)"                             >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PGSQL_PKG_SHORT_DESCRIPTION)\"" >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "url=$(PGSQL_PKG_URL)"                                 >> $(PGSQL_PKG)/.PKGINFO ; \
	 echo "license=$(PGSQL_PKG_LICENSE)"                         >> $(PGSQL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PGSQL_PKG) && \
	                  chown -R root:root .     && \
	                  chmod 700 var/lib/pgsql  && \
	                  chown -R $(pg_uid):$(pg_gid) var/lib/pgsql  && \
	                  $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
