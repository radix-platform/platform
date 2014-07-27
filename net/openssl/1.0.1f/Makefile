
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/openssl

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/gmp/5.1.3


version            = 1.0.1f
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/openssl/openssl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openssl-$(version)
src_dir_name       = openssl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

cron_script        = $(CURDIR)/cron/certwatch


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENSSL_PKG_NAME                = openssl
OPENSSL_PKG_VERSION             = 1.0.1f
OPENSSL_PKG_ARCH                = $(TOOLCHAIN)
OPENSSL_PKG_DISTRO_NAME         = kxLab
OPENSSL_PKG_DISTRO_VERSION      = 1.0
OPENSSL_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
OPENSSL_PKG_SHORT_DESCRIPTION   = openssl $(version)
OPENSSL_PKG_URL                 = $(BUG_URL)
OPENSSL_PKG_LICENSE             = GPLv2
OPENSSL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENSSL_PKG_NAME)-pkg-description
OPENSSL_PKG_DESCRIPTION_FILE_IN = $(OPENSSL_PKG_NAME)-pkg-description.in
OPENSSL_PKG_INSTALL_SCRIPT      = $(OPENSSL_PKG_NAME)-pkg-install.sh

OPENSSL_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENSSL_PKG_NAME)-package

pkg_basename     = $(OPENSSL_PKG_NAME)-$(OPENSSL_PKG_VERSION)-$(OPENSSL_PKG_ARCH)-$(OPENSSL_PKG_DISTRO_NAME)-$(OPENSSL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = INSTALL_PREFIX=$(OPENSSL_PKG)


extra_configure_switches  = --libdir=lib$(LIBSUFFIX)
extra_configure_switches += --openssldir=/etc/ssl
extra_configure_switches += no-idea
extra_configure_switches += no-rc5
extra_configure_switches += no-sse2
extra_configure_switches += zlib-dynamic
extra_configure_switches += shared


ifeq ($(HARDWARE),$(HARDWARE_PC32))
arch = i486
endif
ifeq ($(HARDWARE),$(HARDWARE_PC64))
arch = x86_64
endif
ifeq ($(HARDWARE),$(HARDWARE_CB1X))
arch = arm
endif
ifeq ($(HARDWARE),$(HARDWARE_CB2X))
arch = arm
endif
ifeq ($(HARDWARE),$(HARDWARE_VIP1830))
arch = arm
endif
ifeq ($(HARDWARE),$(HARDWARE_BEAGLE))
arch = arm
endif
ifeq ($(HARDWARE),$(HARDWARE_OMAP5UEVM))
arch = arm
endif
ifeq ($(HARDWARE),$(HARDWARE_B74))
arch = mips32
endif

openssl_environment = MACHINE=$(arch) SYSTEM=Linux


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(openssl_environment) ./config \
	  --prefix=/usr               \
	  $(extra_configure_switches) \
	  $(ARCH_FLAGS)               \
	  $(HW_FLAGS)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENSSL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) MANDIR=/usr/share/man install $(env_sysroot)
	@mv $(OPENSSL_PKG)/etc/ssl/openssl.cnf $(OPENSSL_PKG)/etc/ssl/openssl.cnf.new
	# Add a cron script to warn root if a certificate is going to expire soon:
	@mkdir -p $(OPENSSL_PKG)/etc/cron.daily
	@cat $(cron_script) > $(OPENSSL_PKG)/etc/cron.daily/certwatch.new
	@chmod 755 $(OPENSSL_PKG)/etc/cron.daily/certwatch.new
	@mkdir -p $(OPENSSL_PKG)/lib$(LIBSUFFIX)
	@( cd $(OPENSSL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod +w lib*.so.?.?.? ; \
	   mv lib*.so.?.?.? ../../lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.?.?.? . ; \
	   ln -sf libcrypto.so.?.?.? libcrypto.so.1 ; \
	   ln -sf libssl.so.?.?.? libssl.so.1 ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@( cd $(OPENSSL_PKG)/usr/share/man/man1 ; mv passwd.1 ssl_passwd.1 )
	@( cd $(OPENSSL_PKG)/usr/share/man/man3 ; mv rand.3 ssl_rand.3 )
	@( cd $(OPENSSL_PKG)/usr/share/man/man3 ; mv err.3 ssl_err.3 )
	@if [ -d $(OPENSSL_PKG)/usr/share/man ]; then \
	  ( cd $(OPENSSL_PKG)/usr/share/man ; \
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
	@mkdir -p $(OPENSSL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/ACKNOWLEDGMENTS \
	       $(OPENSSL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OPENSSL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGES CHANGES.SSLeay FAQ INSTALL INSTALL.MacOS \
	         INSTALL.VMS INSTALL.W32 LICENSE NEWS README README.ENGINE doc \
	         $(OPENSSL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(OPENSSL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(OPENSSL_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrypto.pc libssl.pc openssl.pc \
	 )
	@( cd $(OPENSSL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(OPENSSL_PKG_DESCRIPTION_FILE): $(OPENSSL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPENSSL_PKG_DESCRIPTION_FILE) $(OPENSSL_PKG_INSTALL_SCRIPT)
	@cp $(OPENSSL_PKG_DESCRIPTION_FILE) $(OPENSSL_PKG)/.DESCRIPTION
	@cp $(OPENSSL_PKG_INSTALL_SCRIPT) $(OPENSSL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENSSL_PKG)/.REQUIRES
	@echo "pkgname=$(OPENSSL_PKG_NAME)"                            >  $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENSSL_PKG_VERSION)"                          >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENSSL_PKG_ARCH)"                               >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENSSL_PKG_DISTRO_NAME)"                  >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENSSL_PKG_DISTRO_VERSION)"                >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "group=$(OPENSSL_PKG_GROUP)"                             >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENSSL_PKG_SHORT_DESCRIPTION)\"" >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "url=$(OPENSSL_PKG_URL)"                                 >> $(OPENSSL_PKG)/.PKGINFO ; \
	 echo "license=$(OPENSSL_PKG_LICENSE)"                         >> $(OPENSSL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(OPENSSL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
