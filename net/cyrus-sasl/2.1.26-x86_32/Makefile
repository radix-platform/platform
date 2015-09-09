
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/cyrus-sasl

REQUIRES             = net/cyrus-sasl/2.1.26
REQUIRES            += libs/gdbm/1.11-x86_32
REQUIRES            += net/openssl/1.0.2d-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 2.1.26
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/n/cyrus-sasl/cyrus-sasl-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/cyrus-sasl-$(version)
src_dir_name         = cyrus-sasl-$(version)
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
SASL_32_PKG_NAME                = cyrus-sasl-x32
SASL_32_PKG_VERSION             = 2.1.26
SASL_32_PKG_ARCH                = $(TOOLCHAIN)
SASL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SASL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SASL_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
SASL_32_PKG_SHORT_DESCRIPTION   = Simple Authentication and Security Layer
SASL_32_PKG_URL                 = $(BUG_URL)
SASL_32_PKG_LICENSE             = custom
SASL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SASL_32_PKG_NAME)-pkg-description
SASL_32_PKG_DESCRIPTION_FILE_IN = $(SASL_32_PKG_NAME)-pkg-description.in
SASL_32_PKG_INSTALL_SCRIPT      = $(SASL_32_PKG_NAME)-pkg-install.sh

SASL_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SASL_32_PKG_NAME)-package

pkg_basename     = $(SASL_32_PKG_NAME)-$(SASL_32_PKG_VERSION)-$(SASL_32_PKG_ARCH)-$(SASL_32_PKG_DISTRO_NAME)-$(SASL_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SASL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-plugindir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/sasl2
extra_configure_switches += --with-configdir=/etc/sasl2
extra_configure_switches += --enable-login
extra_configure_switches += --disable-anon
extra_configure_switches += --without-ldap
extra_configure_switches += --with-saslauthd
extra_configure_switches += --with-gdbm
extra_configure_switches += --with-dblib=gdbm
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

sasl_environment = sasldir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/sasl2


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Patch makemd5 headers generator according to target machine capacity =======
	@sed -i "s,CC = @CC@,CC = gcc -m32,"    $(SRC_DIR)/include/Makefile.in
	@sed -i "s,CFLAGS = @CFLAGS@,CFLAGS =," $(SRC_DIR)/include/Makefile.in
	@sed -i "s,CPP = @CPP@,CPP = gcc -m32," $(SRC_DIR)/include/Makefile.in
	@sed -i "s,LDFLAGS = @LDFLAGS@,LDFLAGS = -L/lib$(BUILD_MULTILIB_X86_32_SUFFIX) -L/usr/lib$(BUILD_MULTILIB_X86_32_SUFFIX)," \
	                                        $(SRC_DIR)/include/Makefile.in
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(sasl_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(sasl_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SASL_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(sasl_environment) install $(env_sysroot)
	@mkdir -p $(SASL_32_PKG)/usr/sbin/32
	@( cd $(SASL_32_PKG)/usr/sbin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@rm -rf $(SASL_32_PKG)/usr/include
	@rm -rf $(SASL_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SASL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsasl2.la ; \
	 )
	@( cd $(SASL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/sasl2 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcrammd5.la libdigestmd5.la liblogin.la libotp.la \
	                                    libplain.la libsasldb.la libscram.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SASL_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsasl2.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsasl2.la  \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/sasl2 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrammd5.la libdigestmd5.la liblogin.la libotp.la   \
	                                            libplain.la libsasldb.la libscram.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcrammd5.la libdigestmd5.la liblogin.la libotp.la \
	                                              libplain.la libsasldb.la libscram.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsasl2.pc ; \
	 )
	@( cd $(SASL_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SASL_32_PKG_DESCRIPTION_FILE): $(SASL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SASL_32_PKG_DESCRIPTION_FILE) $(SASL_32_PKG_INSTALL_SCRIPT)
	@cp $(SASL_32_PKG_DESCRIPTION_FILE) $(SASL_32_PKG)/.DESCRIPTION
	@cp $(SASL_32_PKG_INSTALL_SCRIPT) $(SASL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SASL_32_PKG)/.REQUIRES
	@echo "pkgname=$(SASL_32_PKG_NAME)"                            >  $(SASL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SASL_32_PKG_VERSION)"                          >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SASL_32_PKG_ARCH)"                               >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SASL_32_PKG_DISTRO_NAME)"                  >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SASL_32_PKG_DISTRO_VERSION)"                >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "group=$(SASL_32_PKG_GROUP)"                             >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SASL_32_PKG_SHORT_DESCRIPTION)\"" >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "url=$(SASL_32_PKG_URL)"                                 >> $(SASL_32_PKG)/.PKGINFO ; \
	 echo "license=$(SASL_32_PKG_LICENSE)"                         >> $(SASL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SASL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
