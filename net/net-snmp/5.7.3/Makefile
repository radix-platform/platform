
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/net-snmp

REQUIRES           = net/tcp_wrappers/7.6
REQUIRES          += net/libnl/1.1.4
REQUIRES          += net/libnl3/3.2.27
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += app/lm_sensors/3.4.0
else
REQUIRES          += app/lm_sensors/3.4.0-x86_32
endif
REQUIRES          += net/openssl/1.0.2f
REQUIRES          += app/pciutils/3.4.1
REQUIRES          += dev/perl/5.22.1
REQUIRES          += dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======


version            = 5.7.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/net-snmp/net-snmp-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/net-snmp-$(version)
src_dir_name       = net-snmp-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

snmpd_conf         = $(CURDIR)/etc/snmp/snmpd.conf
rc_snmpd           = $(CURDIR)/etc/rc.d/rc.snmpd


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NSNMP_PKG_NAME                = net-snmp
NSNMP_PKG_VERSION             = 5.7.3
NSNMP_PKG_ARCH                = $(TOOLCHAIN)
NSNMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NSNMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NSNMP_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
NSNMP_PKG_SHORT_DESCRIPTION   = Simple Network Management Protocol tools
NSNMP_PKG_URL                 = $(BUG_URL)
NSNMP_PKG_LICENSE             = custom
NSNMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NSNMP_PKG_NAME)-pkg-description
NSNMP_PKG_DESCRIPTION_FILE_IN = $(NSNMP_PKG_NAME)-pkg-description.in
NSNMP_PKG_INSTALL_SCRIPT      = $(NSNMP_PKG_NAME)-pkg-install.sh

NSNMP_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NSNMP_PKG_NAME)-package

pkg_basename     = $(NSNMP_PKG_NAME)-$(NSNMP_PKG_VERSION)-$(NSNMP_PKG_ARCH)-$(NSNMP_PKG_DISTRO_NAME)-$(NSNMP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(NSNMP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc/snmp
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes
extra_configure_switches += --program-suffix=
extra_configure_switches += --program-prefix=
extra_configure_switches += --enable-ipv6
extra_configure_switches += --disable-debugging
extra_configure_switches += --enable-static=no
extra_configure_switches += --with-libwrap
extra_configure_switches += --with-default-snmp-version=3
extra_configure_switches += --with-sys-contact="root@example.org"
extra_configure_switches += --with-sys-location="unknown"
extra_configure_switches += --with-logfile="/var/log/snmpd.log"
extra_configure_switches += --with-persistent-directory="/var/lib/net-snmp"
extra_configure_switches += --without-rpm
extra_configure_switches += --with-mib-modules="ucd-snmp/lmsensorsMib"


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) INSTALLDIRS=vendor
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NSNMP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install INSTALLDIRS=vendor $(env_sysroot)
	@mkdir -p $(NSNMP_PKG)/var/lib/net-snmp
	@mkdir -p $(NSNMP_PKG)/etc/snmp
	@cat $(snmpd_conf) > $(NSNMP_PKG)/etc/snmp/snmpd.conf.new
	@mkdir -p $(NSNMP_PKG)/etc/rc.d
	@cat $(rc_snmpd) > $(NSNMP_PKG)/etc/rc.d/rc.snmpd.new
	# ======= Install Documentation =======
	@( cd $(NSNMP_PKG)/usr/share/man/man1 ; \
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
	@( cd $(NSNMP_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(NSNMP_PKG)/usr/share/man ]; then \
	  ( cd $(NSNMP_PKG)/usr/share/man ; \
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
	@mkdir -p $(NSNMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(NSNMP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NSNMP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AGENT.txt COPYING CodingStyle EXAMPLE.conf.def \
	         FAQ INSTALL NEWS PORTING README* TODO doc/rfc  \
	         $(NSNMP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NSNMP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(NSNMP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(NSNMP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnetsnmp.la libnetsnmpagent.la       \
	                                    libnetsnmphelpers.la libnetsnmpmibs.la \
	                                    libnetsnmptrapd.la ; \
	 )
	# ======= remove toolchain path from target config scripts =======
	@( cd $(NSNMP_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" net-snmp-config net-snmp-create-v3-user ; \
	 )
	# ======= also remove OPTIMIZATION to not create problems to other people =======
	@( cd $(NSNMP_PKG)/usr/bin ; \
	   sed -i "s, -O[0-3sg],,g" net-snmp-config ; \
	   sed -i "s, -O[ ], ,g"    net-snmp-config ; \
	   sed -i "s, -Ofast,,g"    net-snmp-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NSNMP_PKG))
	# ======= tune 'net-snmp-config' script for target rootfs =======
	@( cd $(NSNMP_PKG)/usr/bin ; \
	   sed -i "s,$(BUILD),$(TARGET),g"        net-snmp-config ; \
	   sed -i "s,$(CCACHE)$(CROSS_PREFIX),,g" net-snmp-config ; \
	   sed -i "s, --sysroot=,,g"              net-snmp-config ; \
	 )
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnetsnmp.la libnetsnmpagent.la       \
	                                           libnetsnmphelpers.la libnetsnmpmibs.la \
	                                           libnetsnmptrapd.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnetsnmp.la libnetsnmpagent.la       \
	                                             libnetsnmphelpers.la libnetsnmpmibs.la \
	                                             libnetsnmptrapd.la ; \
	 )
	# ======= tune 'net-snmp-config' script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,^prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" net-snmp-config ; \
	   sed -i "s,^libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" net-snmp-config ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g"              net-snmp-config ; \
	   sed -i "s,L/usr,L$(TARGET_DEST_DIR)/usr,g"              net-snmp-config ; \
	   sed -i "s,I/usr,I$(TARGET_DEST_DIR)/usr,g"              net-snmp-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(NSNMP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(NSNMP_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(NSNMP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(NSNMP_PKG_DESCRIPTION_FILE): $(NSNMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NSNMP_PKG_DESCRIPTION_FILE) $(NSNMP_PKG_INSTALL_SCRIPT)
	@cp $(NSNMP_PKG_DESCRIPTION_FILE) $(NSNMP_PKG)/.DESCRIPTION
	@cp $(NSNMP_PKG_INSTALL_SCRIPT) $(NSNMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NSNMP_PKG)/.REQUIRES
	@echo "pkgname=$(NSNMP_PKG_NAME)"                            >  $(NSNMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NSNMP_PKG_VERSION)"                          >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "arch=$(NSNMP_PKG_ARCH)"                               >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(NSNMP_PKG_DISTRO_NAME)"                  >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(NSNMP_PKG_DISTRO_VERSION)"                >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "group=$(NSNMP_PKG_GROUP)"                             >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NSNMP_PKG_SHORT_DESCRIPTION)\"" >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "url=$(NSNMP_PKG_URL)"                                 >> $(NSNMP_PKG)/.PKGINFO ; \
	 echo "license=$(NSNMP_PKG_LICENSE)"                         >> $(NSNMP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NSNMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
