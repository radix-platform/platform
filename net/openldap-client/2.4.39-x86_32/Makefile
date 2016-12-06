
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/openldap

REQUIRES             = net/openldap-client/2.4.39
REQUIRES            += net/openssl/1.0.2f-x86_32
REQUIRES            += net/cyrus-sasl/2.1.26-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 2.4.39
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/n/openldap/openldap-$(version).tgz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/openldap-$(version)
src_dir_name         = openldap-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENLDAP_32_PKG_NAME                = openldap-client-x32
OPENLDAP_32_PKG_VERSION             = 2.4.39
OPENLDAP_32_PKG_ARCH                = $(TOOLCHAIN)
OPENLDAP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPENLDAP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPENLDAP_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
OPENLDAP_32_PKG_SHORT_DESCRIPTION   = OpenLDAP client programs
OPENLDAP_32_PKG_URL                 = $(BUG_URL)
OPENLDAP_32_PKG_LICENSE             = custom
OPENLDAP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENLDAP_32_PKG_NAME)-pkg-description
OPENLDAP_32_PKG_DESCRIPTION_FILE_IN = $(OPENLDAP_32_PKG_NAME)-pkg-description.in
OPENLDAP_32_PKG_INSTALL_SCRIPT      = $(OPENLDAP_32_PKG_NAME)-pkg-install.sh

OPENLDAP_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENLDAP_32_PKG_NAME)-package

pkg_basename     = $(OPENLDAP_32_PKG_NAME)-$(OPENLDAP_32_PKG_VERSION)-$(OPENLDAP_32_PKG_ARCH)-$(OPENLDAP_32_PKG_DISTRO_NAME)-$(OPENLDAP_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(OPENLDAP_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
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


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@( cd $(build_dir) ; \
	   sed -i "s,#define NEED_MEMCMP_REPLACEMENT 1,/* #undef NEED_MEMCMP_REPLACEMENT */," include/portable.h ; \
	   sed -i "s,STRIP = -s,STRIP =," clients/tools/Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENLDAP_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@chmod 0755 $(OPENLDAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*.la
	@chmod 0755 $(OPENLDAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/*-?.?.so.?.??.?
	@mkdir -p $(OPENLDAP_32_PKG)/usr/bin/32
	@( cd $(OPENLDAP_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	@rm -rf $(OPENLDAP_32_PKG)/etc
	@rm -rf $(OPENLDAP_32_PKG)/usr/include
	@rm -rf $(OPENLDAP_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(OPENLDAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" liblber.la libldap.la libldap_r.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OPENLDAP_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" liblber.la libldap.la libldap_r.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" liblber.la libldap.la libldap_r.la  \
	 )
	# ======= Strip binaries =======
	@( cd $(OPENLDAP_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(OPENLDAP_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(OPENLDAP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(OPENLDAP_32_PKG_DESCRIPTION_FILE): $(OPENLDAP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPENLDAP_32_PKG_DESCRIPTION_FILE) $(OPENLDAP_32_PKG_INSTALL_SCRIPT)
	@cp $(OPENLDAP_32_PKG_DESCRIPTION_FILE) $(OPENLDAP_32_PKG)/.DESCRIPTION
	@cp $(OPENLDAP_32_PKG_INSTALL_SCRIPT) $(OPENLDAP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENLDAP_32_PKG)/.REQUIRES
	@echo "pkgname=$(OPENLDAP_32_PKG_NAME)"                            >  $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENLDAP_32_PKG_VERSION)"                          >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENLDAP_32_PKG_ARCH)"                               >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENLDAP_32_PKG_DISTRO_NAME)"                  >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENLDAP_32_PKG_DISTRO_VERSION)"                >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "group=$(OPENLDAP_32_PKG_GROUP)"                             >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENLDAP_32_PKG_SHORT_DESCRIPTION)\"" >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "url=$(OPENLDAP_32_PKG_URL)"                                 >> $(OPENLDAP_32_PKG)/.PKGINFO ; \
	 echo "license=$(OPENLDAP_32_PKG_LICENSE)"                         >> $(OPENLDAP_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OPENLDAP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
