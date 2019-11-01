
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
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/n/curl

REQUIRES           = net/openssh/8.1p1
REQUIRES          += net/gnutls/3.6.10
REQUIRES          += net/ca-certificates/20191101
REQUIRES          += net/openldap-client/2.4.48
REQUIRES          += libs/libssh2/1.9.0

# ======= __END_OF_REQUIRES__ =======


version            = 7.66.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/curl/curl-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/curl-$(version)
src_dir_name       = curl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

cacert_archive     = $(SRC_PACKAGE_PATH)/packages/n/curl/cacert.pem.xz

config_dir         = $(CURDIR)/config
curl_config_in     = $(CURDIR)/config-script/curl-config.in


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CURL_PKG_NAME                = curl
CURL_PKG_VERSION             = 7.66.0
CURL_PKG_ARCH                = $(TOOLCHAIN)
CURL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CURL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CURL_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
CURL_PKG_SHORT_DESCRIPTION   = command line URL data transfer tool
CURL_PKG_URL                 = $(BUG_URL)
CURL_PKG_LICENSE             = custom
CURL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CURL_PKG_NAME)-pkg-description
CURL_PKG_DESCRIPTION_FILE_IN = $(CURL_PKG_NAME)-pkg-description.in
CURL_PKG_INSTALL_SCRIPT      = $(CURL_PKG_NAME)-pkg-install.sh

CURL_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CURL_PKG_NAME)-package

pkg_basename     = $(CURL_PKG_NAME)-$(CURL_PKG_VERSION)-$(CURL_PKG_ARCH)-$(CURL_PKG_DISTRO_NAME)-$(CURL_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(CURL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-ca-bundle=/usr/share/curl/ca-bundle.crt
extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-libidn
extra_configure_switches += --with-ssl
extra_configure_switches += --with-libssh2
extra_configure_switches += --with-gnutls
extra_configure_switches += --enable-ldap
extra_configure_switches += --with-ldap-lib
extra_configure_switches += --with-lber-lib

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CURL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install /usr/share/curl/cacert.pem =======
	@mkdir -p $(CURL_PKG)/usr/share/curl
	@xzcat $(cacert_archive) > $(CURL_PKG)/usr/share/curl/cacert.pem
	@( cd $(CURL_PKG)/usr/share/curl ; \
	   mv cacert.pem ca-bundle.crt   ; \
	   chmod 644 ca-bundle.crt       ; \
	 )
	# ======= Install Documentation =======
	@( cd $(CURL_PKG)/usr/share/man/man3 ; \
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
	@if [ -d $(CURL_PKG)/usr/share/man ]; then \
	  ( cd $(CURL_PKG)/usr/share/man ; \
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
	@mkdir -p $(CURL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(CURL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CURL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README RELEASE-NOTES \
	       $(CURL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/docs ; \
	   cp -a BUGS FAQ FEATURES KNOWN_BUGS README.md RESOURCES THANKS TODO \
	         $(CURL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(CURL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CURL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcurl.la ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(CURL_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcurl.pc ; \
	 )
	# ======= Tune development '/usr/bin/curl-config' sctipt =======
	@( cd $(CURL_PKG)/usr/bin ; \
	   sed -i "s,^prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,"            curl-config ; \
	   sed -i "s,\"/usr/share/curl,\"$(TARGET_DEST_DIR)/usr/share/curl," curl-config ; \
	   sed -i "s,test \"X/usr/lib,test \"X$(TARGET_DEST_DIR)/usr/lib,"   curl-config ; \
	   sed -i "s,a \"X/usr/lib,a \"X$(TARGET_DEST_DIR)/usr/lib,"         curl-config ; \
	   sed -i "s,L/usr/lib,L$(TARGET_DEST_DIR)/usr/lib,g"                curl-config ; \
	   sed -i "s,/usr/lib$(LIBSUFFIX)/libcurl.a,$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libcurl.a," curl-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CURL_PKG))
	# ======= Tune target '/usr/bin/curl-config' sctipt =======
	@( cd $(CURL_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g"    curl-config ; \
	   sed -i 's,$(TOOLCHAIN_PATH),/usr,g' curl-config ; \
	   sed -i 's,$(TARGET)-,,g'            curl-config ; \
	   sed -i "s, '--build=[^\']*',,g"     curl-config ; \
	   sed -i "s, '--host=[^\']*',,g"      curl-config ; \
	   sed -i "s, 'build_alias=[^\']*',,g" curl-config ; \
	   sed -i "s, 'host_alias=[^\']*',,g"  curl-config ; \
	   sed -i "s, --sysroot=[^\']*',',g"   curl-config ; \
	   sed -i 's, --sysroot=[^\"]*",",g'   curl-config ; \
	 )
	# ======= Tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libcurl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcurl.la ; \
	 )
	# ======= Tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcurl.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(CURL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(CURL_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CURL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CURL_PKG_DESCRIPTION_FILE): $(CURL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CURL_PKG_DESCRIPTION_FILE) $(CURL_PKG_INSTALL_SCRIPT)
	@cp $(CURL_PKG_DESCRIPTION_FILE) $(CURL_PKG)/.DESCRIPTION
	@cp $(CURL_PKG_INSTALL_SCRIPT) $(CURL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CURL_PKG)/.REQUIRES
	@echo "pkgname=$(CURL_PKG_NAME)"                            >  $(CURL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CURL_PKG_VERSION)"                          >> $(CURL_PKG)/.PKGINFO ; \
	 echo "arch=$(CURL_PKG_ARCH)"                               >> $(CURL_PKG)/.PKGINFO ; \
	 echo "distroname=$(CURL_PKG_DISTRO_NAME)"                  >> $(CURL_PKG)/.PKGINFO ; \
	 echo "distrover=$(CURL_PKG_DISTRO_VERSION)"                >> $(CURL_PKG)/.PKGINFO ; \
	 echo "group=$(CURL_PKG_GROUP)"                             >> $(CURL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CURL_PKG_SHORT_DESCRIPTION)\"" >> $(CURL_PKG)/.PKGINFO ; \
	 echo "url=$(CURL_PKG_URL)"                                 >> $(CURL_PKG)/.PKGINFO ; \
	 echo "license=$(CURL_PKG_LICENSE)"                         >> $(CURL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CURL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
