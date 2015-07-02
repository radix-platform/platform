
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


SOURCE_REQUIRES    = sources/packages/n/openldap

REQUIRES           = net/openssl/1.0.1g
REQUIRES          += net/cyrus-sasl/2.1.26

# ======= __END_OF_REQUIRES__ =======


version            = 2.4.39
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/openldap/openldap-$(version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openldap-$(version)
src_dir_name       = openldap-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENLDAP_PKG_NAME                = openldap-client
OPENLDAP_PKG_VERSION             = 2.4.39
OPENLDAP_PKG_ARCH                = $(TOOLCHAIN)
OPENLDAP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPENLDAP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPENLDAP_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
OPENLDAP_PKG_SHORT_DESCRIPTION   = OpenLDAP client programs
OPENLDAP_PKG_URL                 = $(BUG_URL)
OPENLDAP_PKG_LICENSE             = custom
OPENLDAP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENLDAP_PKG_NAME)-pkg-description
OPENLDAP_PKG_DESCRIPTION_FILE_IN = $(OPENLDAP_PKG_NAME)-pkg-description.in
OPENLDAP_PKG_INSTALL_SCRIPT      = $(OPENLDAP_PKG_NAME)-pkg-install.sh

OPENLDAP_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENLDAP_PKG_NAME)-package

pkg_basename     = $(OPENLDAP_PKG_NAME)-$(OPENLDAP_PKG_VERSION)-$(OPENLDAP_PKG_ARCH)-$(OPENLDAP_PKG_DISTRO_NAME)-$(OPENLDAP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(OPENLDAP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib
extra_configure_switches += --with-cyrus-sasl
extra_configure_switches += --with-tls
extra_configure_switches += --with-readline
extra_configure_switches += --with-threads
extra_configure_switches += --with-yielding_select=yes
extra_configure_switches += --enable-syslog
extra_configure_switches += --enable-ipv6
extra_configure_switches += --enable-dynamic
extra_configure_switches += --enable-local
extra_configure_switches += --enable-proctitle
extra_configure_switches += --disable-slapd
extra_configure_switches += --disable-slurpd
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) STRIP= ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@( cd $(build_dir) ; \
	   sed -i "s,#define NEED_MEMCMP_REPLACEMENT 1,/* #undef NEED_MEMCMP_REPLACEMENT */," include/portable.h ; \
	   sed -i "s,STRIP = -s,STRIP =," clients/tools/Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENLDAP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(OPENLDAP_PKG)/etc/openldap/ldap.conf.default
	@mv $(OPENLDAP_PKG)/etc/openldap/ldap.conf $(OPENLDAP_PKG)/etc/openldap/ldap.conf.new
	@echo ""                                                                         >> $(OPENLDAP_PKG)/etc/openldap/ldap.conf.new
	@echo "# In order to avoid problems with self-signed certificates using TLS:"    >> $(OPENLDAP_PKG)/etc/openldap/ldap.conf.new
	@echo "# 'TLS certificate verification: Error, self signed certificate'"         >> $(OPENLDAP_PKG)/etc/openldap/ldap.conf.new
	@echo "# See also 'man ldap.conf' or http://www.openldap.org/doc/admin/tls.html" >> $(OPENLDAP_PKG)/etc/openldap/ldap.conf.new
	@echo "TLS_REQCERT allow"                                                        >> $(OPENLDAP_PKG)/etc/openldap/ldap.conf.new
	@chmod 0755 $(OPENLDAP_PKG)/usr/lib$(LIBSUFFIX)/*.la
	@chmod 0755 $(OPENLDAP_PKG)/usr/lib$(LIBSUFFIX)/*-?.?.so.?.??.?
	# ======= Install Documentation =======
	@if [ -d $(OPENLDAP_PKG)/usr/share/man ]; then \
	  ( cd $(OPENLDAP_PKG)/usr/share/man ; \
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
	@mkdir -p $(OPENLDAP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/ANNOUNCEMENT $(SRC_DIR)/COPYRIGHT $(SRC_DIR)/LICENSE \
	       $(OPENLDAP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OPENLDAP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCEMENT COPYRIGHT INSTALL LICENSE README doc/rfc doc/install doc/guide doc/drafts \
	         $(OPENLDAP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(OPENLDAP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(OPENLDAP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liblber.la libldap.la libldap_r.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OPENLDAP_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblber.la libldap.la libldap_r.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblber.la libldap.la libldap_r.la  \
	 )
	# ======= Strip binaries =======
	@( cd $(OPENLDAP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(OPENLDAP_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(OPENLDAP_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(OPENLDAP_PKG_DESCRIPTION_FILE): $(OPENLDAP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPENLDAP_PKG_DESCRIPTION_FILE) $(OPENLDAP_PKG_INSTALL_SCRIPT)
	@cp $(OPENLDAP_PKG_DESCRIPTION_FILE) $(OPENLDAP_PKG)/.DESCRIPTION
	@cp $(OPENLDAP_PKG_INSTALL_SCRIPT) $(OPENLDAP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENLDAP_PKG)/.REQUIRES
	@echo "pkgname=$(OPENLDAP_PKG_NAME)"                            >  $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENLDAP_PKG_VERSION)"                          >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENLDAP_PKG_ARCH)"                               >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENLDAP_PKG_DISTRO_NAME)"                  >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENLDAP_PKG_DISTRO_VERSION)"                >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "group=$(OPENLDAP_PKG_GROUP)"                             >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENLDAP_PKG_SHORT_DESCRIPTION)\"" >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "url=$(OPENLDAP_PKG_URL)"                                 >> $(OPENLDAP_PKG)/.PKGINFO ; \
	 echo "license=$(OPENLDAP_PKG_LICENSE)"                         >> $(OPENLDAP_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(OPENLDAP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
