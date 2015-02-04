
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true
NO_CCACHE          = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/b/mariadb

REQUIRES           = dev/gcc/4.9.1
REQUIRES          += libs/pcre/8.34
REQUIRES          += libs/libxml2/2.9.1
REQUIRES          += libs/libaio/0.3.110
REQUIRES          += net/openssl/1.0.1g
REQUIRES          += secure/pam_unix2/2.9.1
REQUIRES          += libs/boost/1.57.0


version            = 5.5.41
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/b/mariadb/mariadb-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mariadb-$(version)
src_dir_name       = mariadb-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

rc_mysqld          = $(CURDIR)/etc/rc.d/rc.mysqld

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MARIADB_PKG_NAME                = mariadb
MARIADB_PKG_VERSION             = 5.5.41
MARIADB_PKG_ARCH                = $(TOOLCHAIN)
MARIADB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MARIADB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MARIADB_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
MARIADB_PKG_SHORT_DESCRIPTION   = the MySQL Database Server
MARIADB_PKG_URL                 = $(BUG_URL)
MARIADB_PKG_LICENSE             = GPLv2
MARIADB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MARIADB_PKG_NAME)-pkg-description
MARIADB_PKG_DESCRIPTION_FILE_IN = $(MARIADB_PKG_NAME)-pkg-description.in
MARIADB_PKG_INSTALL_SCRIPT      = $(MARIADB_PKG_NAME)-pkg-install.sh

MARIADB_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MARIADB_PKG_NAME)-package

pkg_basename     = $(MARIADB_PKG_NAME)-$(MARIADB_PKG_VERSION)-$(MARIADB_PKG_ARCH)-$(MARIADB_PKG_DISTRO_NAME)-$(MARIADB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MARIADB_PKG)


configure_switches  = -DCMAKE_CC=$(CROSS_PREFIX)gcc
configure_switches += -DCMAKE_CXX=$(CROSS_PREFIX)g++

configure_switches += -DCMAKE_AR=$(CROSS_PREFIX)ar
configure_switches += -DCMAKE_RANLIB=$(CROSS_PREFIX)ranlib
configure_switches += -Dgcc_ar=$(CROSS_PREFIX)gcc-ar
configure_switches += -Dgcc_ranlib=$(CROSS_PREFIX)gcc-ranlib

configure_switches += -DCMAKE_LINKER=$(CROSS_PREFIX)ld

configure_switches += -DCMAKE_C_FLAGS="--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC -fno-strict-aliasing -DBIG_JOINS=1 -fomit-frame-pointer -fno-delete-null-pointer-checks"
configure_switches += -DCMAKE_CXX_FLAGS="--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC -fno-strict-aliasing -DBIG_JOINS=1 -felide-constructors -fno-rtti -fno-delete-null-pointer-checks"
configure_switches += -DWITH_MYSQLD_LDFLAGS="-pie $(LDFLAGS),-z,now"

configure_switches += -DCMAKE_C_COMPILER_ARG1=""
configure_switches += -DCMAKE_CXX_COMPILER_ARG1=""

configure_switches += -DBUILD_CONFIG=mysql_release
configure_switches += -DFEATURE_SET="community"
configure_switches += -DINSTALL_LAYOUT="RPM"
configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DINSTALL_LIBDIR="lib$(LIBSUFFIX)"
configure_switches += -DINSTALL_SCRIPTDIR=bin
configure_switches += -DINSTALL_SBINDIR=libexec
configure_switches += -DINSTALL_INCLUDEDIR=include/mysql
configure_switches += -DINSTALL_MYSQLSHAREDIR=share/mysql
configure_switches += -DINSTALL_SQLBENCHDIR=
configure_switches += -DINSTALL_MYSQLTESTDIR=share/mysql-test
configure_switches += -DINSTALL_MANDIR=share/man
configure_switches += -DINSTALL_PLUGINDIR="lib$(LIBSUFFIX)/mysql/plugin"
configure_switches += -DINSTALL_SUPPORTFILESDIR=share/mysql
configure_switches += -DINSTALL_MYSQLDATADIR="/var/lib/mysql"
configure_switches += -DINSTALL_DOCREADMEDIR="share/doc/$(src_dir_name)"
configure_switches += -DINSTALL_DOCDIR="share/doc/$(src_dir_name)"
configure_switches += -DMYSQL_DATADIR="/var/lib/mysql"
configure_switches += -DMYSQL_UNIX_ADDR="/var/run/mysql/mysql.sock"
configure_switches += -DDEFAULT_CHARSET=utf8
configure_switches += -DDEFAULT_COLLATION=utf8_general_ci
configure_switches += -DWITH_EXTRA_CHARSETS=complex
configure_switches += -DENABLED_LOCAL_INFILE=ON
configure_switches += -DWITH_EMBEDDED_SERVER=YES

configure_switches += -DWITH_JEMALLOC=NO

configure_switches += -DWITH_READLINE=ON
configure_switches += -DWITH_SSL=system
configure_switches += -DWITH_ZLIB=system
configure_switches += -DWITH_PCRE=system
configure_switches += -DUSE_ARIA_FOR_TMP_TABLES=ON
configure_switches += -DCMAKE_CROSSCOMPILING=ON

configure_switches += -DWITH_ARCHIVE_STORAGE_ENGINE=1
configure_switches += -DWITH_BLACKHOLE_STORAGE_ENGINE=1
configure_switches += -DWITH_INNOBASE_STORAGE_ENGINE=1
configure_switches += -DWITH_PARTITION_STORAGE_ENGINE=1
configure_switches += -DWITH_XTRADB_STORAGE_ENGINE=1
configure_switches += -DWITH_OQGRAPH_STORAGE_ENGINE=1
configure_switches += -DWITHOUT_TOKUDB_STORAGE_ENGINE=1
configure_switches += -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1
configure_switches += -DWITHOUT_FEDERATED_STORAGE_ENGINE=1
configure_switches += -DWITHOUT_PBXT_STORAGE_ENGINE=1

environment  = CC_FOR_BUILD=gcc
environment += CFLAGS_FOR_BUILD=-I/usr/include
environment += CXX_FOR_BUILD=g++


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(SRC_DIR)/build-machine
	@( cd $(SRC_DIR)/build-machine ; \
	   $(environment) cmake .. ; \
	   ( cd extra   ; $(MAKE) comp_err     ) ; \
	   ( cd sql     ; $(MAKE) gen_lex_hash ) ; \
	   ( cd dbug    ; $(MAKE) factorial    ) ; \
	   ( cd scripts ; $(MAKE) comp_sql     ) ; \
	 )
	@mkdir -p $(SRC_DIR)/build-$(HARDWARE)
	@( cd $(SRC_DIR)/build-$(HARDWARE) ; \
	   $(BUILD_ENVIRONMENT) $(environment) cmake $(configure_switches) .. ; \
	   \
	   cp -a ../build-machine/extra/comp_err extra/comp_err_build ; \
	   sed -i 's, \./comp_err, \./comp_err_build,g' extra/CMakeFiles/GenError.dir/build.make ; \
	   \
	   cp -a ../build-machine/sql/gen_lex_hash sql/gen_lex_hash_build ; \
	   sed -i 's, \./gen_lex_hash, \./gen_lex_hash_build,g' sql/CMakeFiles/sql.dir/build.make ; \
	   sed -i 's, \./gen_lex_hash, \./gen_lex_hash_build,g' sql/CMakeFiles/GenServerSource.dir/build.make ; \
	   \
	   cp -a ../build-machine/dbug/factorial dbug/factorial_build ; \
	   sed -i 's, \./factorial, \./factorial_build,g' dbug/CMakeFiles/t.dir/build.make ; \
	   sed -i 's, \./factorial, \./factorial_build,g' dbug/CMakeFiles/ps.dir/build.make ; \
	   \
	   cp -a ../build-machine/scripts/comp_sql scripts/comp_sql_build ; \
	   sed -i 's, $(CURDIR)/$(SRC_DIR)/build-$(HARDWARE)/scripts/comp_sql, \./comp_sql_build,g' scripts/CMakeFiles/GenFixPrivs.dir/build.make ; \
	   \
	   $(BUILD_ENVIRONMENT) $(MAKE) $(environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(MARIADB_PKG)
	@( cd $(SRC_DIR)/build-$(HARDWARE) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot) ; \
	 )
	# ======= Install System Scripts =======
	@mkdir -p $(MARIADB_PKG)/var/{lib,run}/mysql
	@chmod 0750 $(MARIADB_PKG)/var/lib/mysql
	@chmod 0755 $(MARIADB_PKG)/var/run/mysql
	@mkdir -p $(MARIADB_PKG)/etc/rc.d
	@cp -a $(rc_mysqld) $(MARIADB_PKG)/etc/rc.d/rc.mysqld.new
	@chmod 0644 $(MARIADB_PKG)/etc/rc.d/rc.mysqld.new
	@rm -rf $(MARIADB_PKG)/etc/init.d
	@install -m 644 $(SRC_DIR)/scripts/mysqlaccess.conf $(MARIADB_PKG)/etc/mysqlaccess.conf.new
	@mv $(MARIADB_PKG)/etc/my.cnf $(MARIADB_PKG)/etc/my.cnf.new
	@mv $(MARIADB_PKG)/etc/logrotate.d/mysql $(MARIADB_PKG)/etc/logrotate.d/mysql.new
	@for i in client mysql-clients server; do \
	   mv $(MARIADB_PKG)/etc/my.cnf.d/$$i.cnf $(MARIADB_PKG)/etc/my.cnf.d/$$i.cnf.new ; \
	 done
	# ======= Install Documentation =======
	@( cd $(MARIADB_PKG)/usr/share/man/man1 ; \
	   for file in *.1 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(MARIADB_PKG)/usr/share/man ]; then \
	  ( cd $(MARIADB_PKG)/usr/share/man ; \
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
	@mkdir -p $(MARIADB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(MARIADB_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* INSTALL-SOURCE KNOWN_BUGS.txt README \
	       $(MARIADB_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(MARIADB_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip Binaries =======
	@( cd $(MARIADB_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(MARIADB_PKG_DESCRIPTION_FILE): $(MARIADB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MARIADB_PKG_DESCRIPTION_FILE) $(MARIADB_PKG_INSTALL_SCRIPT)
	@cp $(MARIADB_PKG_DESCRIPTION_FILE) $(MARIADB_PKG)/.DESCRIPTION
	@cp $(MARIADB_PKG_INSTALL_SCRIPT) $(MARIADB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MARIADB_PKG)/.REQUIRES
	@echo "pkgname=$(MARIADB_PKG_NAME)"                            >  $(MARIADB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MARIADB_PKG_VERSION)"                          >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "arch=$(MARIADB_PKG_ARCH)"                               >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "distroname=$(MARIADB_PKG_DISTRO_NAME)"                  >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "distrover=$(MARIADB_PKG_DISTRO_VERSION)"                >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "group=$(MARIADB_PKG_GROUP)"                             >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MARIADB_PKG_SHORT_DESCRIPTION)\"" >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "url=$(MARIADB_PKG_URL)"                                 >> $(MARIADB_PKG)/.PKGINFO ; \
	 echo "license=$(MARIADB_PKG_LICENSE)"                         >> $(MARIADB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MARIADB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
