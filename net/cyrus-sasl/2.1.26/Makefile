
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/cyrus-sasl

REQUIRES           = libs/gdbm/1.11
REQUIRES          += net/openssl/1.0.2d

# ======= __END_OF_REQUIRES__ =======


version            = 2.1.26
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/cyrus-sasl/cyrus-sasl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cyrus-sasl-$(version)
src_dir_name       = cyrus-sasl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

rc_saslauthd       = $(CURDIR)/etc/rc.d/rc.saslauthd


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SASL_PKG_NAME                = cyrus-sasl
SASL_PKG_VERSION             = 2.1.26
SASL_PKG_ARCH                = $(TOOLCHAIN)
SASL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SASL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SASL_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
SASL_PKG_SHORT_DESCRIPTION   = Simple Authentication and Security Layer
SASL_PKG_URL                 = $(BUG_URL)
SASL_PKG_LICENSE             = custom
SASL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SASL_PKG_NAME)-pkg-description
SASL_PKG_DESCRIPTION_FILE_IN = $(SASL_PKG_NAME)-pkg-description.in
SASL_PKG_INSTALL_SCRIPT      = $(SASL_PKG_NAME)-pkg-install.sh

SASL_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SASL_PKG_NAME)-package

pkg_basename     = $(SASL_PKG_NAME)-$(SASL_PKG_VERSION)-$(SASL_PKG_ARCH)-$(SASL_PKG_DISTRO_NAME)-$(SASL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SASL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-plugindir=/usr/lib$(LIBSUFFIX)/sasl2
extra_configure_switches += --with-configdir=/etc/sasl2
extra_configure_switches += --enable-login
extra_configure_switches += --disable-anon
extra_configure_switches += --without-ldap
extra_configure_switches += --with-saslauthd
extra_configure_switches += --with-gdbm
extra_configure_switches += --with-dblib=gdbm
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

sasl_environment = sasldir=/usr/lib$(LIBSUFFIX)/sasl2


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Patch makemd5 headers generator according to target machine capacity =======
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@sed -i "s,CC = @CC@,CC = gcc,"         $(SRC_DIR)/include/Makefile.in
	@sed -i "s,CFLAGS = @CFLAGS@,CFLAGS =," $(SRC_DIR)/include/Makefile.in
	@sed -i "s,CPP = @CPP@,CPP = gcc,"      $(SRC_DIR)/include/Makefile.in
	@sed -i "s,LDFLAGS = @LDFLAGS@,LDFLAGS = -L/lib$(BUILD_MULTILIB_SUFFIX) -L/usr/lib$(BUILD_MULTILIB_SUFFIX)," \
	                                        $(SRC_DIR)/include/Makefile.in
else
	@sed -i "s,CC = @CC@,CC = gcc -m32,"    $(SRC_DIR)/include/Makefile.in
	@sed -i "s,CFLAGS = @CFLAGS@,CFLAGS =," $(SRC_DIR)/include/Makefile.in
	@sed -i "s,CPP = @CPP@,CPP = gcc -m32," $(SRC_DIR)/include/Makefile.in
	@sed -i "s,LDFLAGS = @LDFLAGS@,LDFLAGS = -L/lib$(BUILD_MULTILIB_X86_32_SUFFIX) -L/usr/lib$(BUILD_MULTILIB_X86_32_SUFFIX)," \
	                                        $(SRC_DIR)/include/Makefile.in
endif
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(sasl_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 $(sasl_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SASL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(sasl_environment) $(env_sysroot)
	@mkdir -p $(SASL_PKG)/var/state/saslauthd
	@mkdir -p $(SASL_PKG)/etc/rc.d
	@cp -a $(rc_saslauthd) $(SASL_PKG)/etc/rc.d/rc.saslauthd.new
	# ======= Install Documentation =======
	@if [ -d $(SASL_PKG)/usr/share/man ]; then \
	  ( cd $(SASL_PKG)/usr/share/man ; \
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
	@mkdir -p $(SASL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(SASL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SASL_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL* NEWS README \
	         $(SASL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   cp -a *.html *.txt *.fig \
	         $(SASL_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SASL_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	   chmod 0644 *.html *.txt *.fig  ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SASL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SASL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsasl2.la ; \
	 )
	@( cd $(SASL_PKG)/usr/lib$(LIBSUFFIX)/sasl2 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcrammd5.la libdigestmd5.la liblogin.la libotp.la \
	                                    libplain.la libsasldb.la libscram.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SASL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsasl2.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsasl2.la  \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/sasl2 ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrammd5.la libdigestmd5.la liblogin.la libotp.la   \
	                                           libplain.la libsasldb.la libscram.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcrammd5.la libdigestmd5.la liblogin.la libotp.la \
	                                             libplain.la libsasldb.la libscram.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsasl2.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SASL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SASL_PKG_DESCRIPTION_FILE): $(SASL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SASL_PKG_DESCRIPTION_FILE) $(SASL_PKG_INSTALL_SCRIPT)
	@cp $(SASL_PKG_DESCRIPTION_FILE) $(SASL_PKG)/.DESCRIPTION
	@cp $(SASL_PKG_INSTALL_SCRIPT) $(SASL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SASL_PKG)/.REQUIRES
	@echo "pkgname=$(SASL_PKG_NAME)"                            >  $(SASL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SASL_PKG_VERSION)"                          >> $(SASL_PKG)/.PKGINFO ; \
	 echo "arch=$(SASL_PKG_ARCH)"                               >> $(SASL_PKG)/.PKGINFO ; \
	 echo "distroname=$(SASL_PKG_DISTRO_NAME)"                  >> $(SASL_PKG)/.PKGINFO ; \
	 echo "distrover=$(SASL_PKG_DISTRO_VERSION)"                >> $(SASL_PKG)/.PKGINFO ; \
	 echo "group=$(SASL_PKG_GROUP)"                             >> $(SASL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SASL_PKG_SHORT_DESCRIPTION)\"" >> $(SASL_PKG)/.PKGINFO ; \
	 echo "url=$(SASL_PKG_URL)"                                 >> $(SASL_PKG)/.PKGINFO ; \
	 echo "license=$(SASL_PKG_LICENSE)"                         >> $(SASL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SASL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
