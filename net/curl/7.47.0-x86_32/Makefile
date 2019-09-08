
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/curl

REQUIRES             = net/curl/7.47.0
REQUIRES            += net/openssh/7.2p1
REQUIRES            += net/gnutls/3.4.8-x86_32
REQUIRES            += net/openldap-client/2.4.43-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 7.47.0
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/curl/curl-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/curl-$(version)
src_dir_name         = curl-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

curl_config_in       = $(CURDIR)/config-script/curl-config.in

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CURL_32_PKG_NAME                = curl-x32
CURL_32_PKG_VERSION             = 7.47.0
CURL_32_PKG_ARCH                = $(TOOLCHAIN)
CURL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CURL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CURL_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
CURL_32_PKG_SHORT_DESCRIPTION   = command line URL data transfer tool
CURL_32_PKG_URL                 = $(BUG_URL)
CURL_32_PKG_LICENSE             = custom
CURL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CURL_32_PKG_NAME)-pkg-description
CURL_32_PKG_DESCRIPTION_FILE_IN = $(CURL_32_PKG_NAME)-pkg-description.in
CURL_32_PKG_INSTALL_SCRIPT      = $(CURL_32_PKG_NAME)-pkg-install.sh

CURL_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CURL_32_PKG_NAME)-package

pkg_basename     = $(CURL_32_PKG_NAME)-$(CURL_32_PKG_VERSION)-$(CURL_32_PKG_ARCH)-$(CURL_32_PKG_DISTRO_NAME)-$(CURL_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(CURL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-ca-bundle=/usr/share/curl/ca-bundle.crt
extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-libidn
extra_configure_switches += --with-ssl
extra_configure_switches += --with-gnutls
extra_configure_switches += --enable-ldap
extra_configure_switches += --with-ldap-lib
extra_configure_switches += --with-lber-lib
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CURL_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Save curlbuild.h =======
	@for header in curlbuild ; do \
	  cp -a $(CURL_32_PKG)/usr/include/curl/$$header.h $(TARGET_BUILD_DIR) ; \
	 done
	@rm -rf $(CURL_32_PKG)/usr/include
	@rm -rf $(CURL_32_PKG)/usr/share
	# ======= Restore curlbuild-32.h =======
	@mkdir -p $(CURL_32_PKG)/usr/include/curl
	@for header in curlbuild ; do \
	  cp -a $(TARGET_BUILD_DIR)/$$header.h $(CURL_32_PKG)/usr/include/curl/$$header-32.h ; \
	 done
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CURL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcurl.la ; \
	 )
	@( cd $(CURL_32_PKG)/usr/bin/32 ; \
	   sed -i "s,^prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr," curl-config ; \
	   sed -i "s,/usr/lib$(MULTILIB_X86_32_SUFFIX)/libcurl.a,$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libcurl.a," curl-config ; \
	   sed -i "s,L/usr/lib,L$(TARGET_DEST_DIR)/usr/lib,g" curl-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CURL_32_PKG))
	# ======= Install target '/usr/bin/curl-congig' sctipt =======
	@cat $(curl_config_in) | $(SED) -e "s/@LIBSUFFIX@/$(MULTILIB_X86_32_SUFFIX)/g" > $(CURL_32_PKG)/usr/bin/32/curl-config
	@chmod 0755 $(CURL_32_PKG)/usr/bin/32/curl-config
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcurl.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcurl.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcurl.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(CURL_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CURL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CURL_32_PKG_DESCRIPTION_FILE): $(CURL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CURL_32_PKG_DESCRIPTION_FILE) $(CURL_32_PKG_INSTALL_SCRIPT)
	@cp $(CURL_32_PKG_DESCRIPTION_FILE) $(CURL_32_PKG)/.DESCRIPTION
	@cp $(CURL_32_PKG_INSTALL_SCRIPT) $(CURL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CURL_32_PKG)/.REQUIRES
	@echo "pkgname=$(CURL_32_PKG_NAME)"                            >  $(CURL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CURL_32_PKG_VERSION)"                          >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CURL_32_PKG_ARCH)"                               >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CURL_32_PKG_DISTRO_NAME)"                  >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CURL_32_PKG_DISTRO_VERSION)"                >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "group=$(CURL_32_PKG_GROUP)"                             >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CURL_32_PKG_SHORT_DESCRIPTION)\"" >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "url=$(CURL_32_PKG_URL)"                                 >> $(CURL_32_PKG)/.PKGINFO ; \
	 echo "license=$(CURL_32_PKG_LICENSE)"                         >> $(CURL_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CURL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
