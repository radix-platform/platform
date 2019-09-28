
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

NOT_PARALLEL       = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/openssl

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/gmp/6.1.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.2t
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/openssl/openssl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openssl-$(version)
src_dir_name       = openssl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC) $(TOOLCHAIN_P5600_GLIBC)),)
OPT_PATCHES = PATCHES.mips32-O2
endif

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

cron_script        = $(CURDIR)/cron/certwatch


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENSSL_PKG_NAME                = openssl10
OPENSSL_PKG_VERSION             = 1.0.2t
OPENSSL_PKG_ARCH                = $(TOOLCHAIN)
OPENSSL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPENSSL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPENSSL_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
OPENSSL_PKG_SHORT_DESCRIPTION   = Secure Sockets Layer toolkit 1.0.x
OPENSSL_PKG_URL                 = $(BUG_URL)
OPENSSL_PKG_LICENSE             = GPLv2
OPENSSL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENSSL_PKG_NAME)-pkg-description
OPENSSL_PKG_DESCRIPTION_FILE_IN = $(OPENSSL_PKG_NAME)-pkg-description.in
OPENSSL_PKG_INSTALL_SCRIPT      = $(OPENSSL_PKG_NAME)-pkg-install.sh

OPENSSL_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENSSL_PKG_NAME)-package

pkg_basename     = $(OPENSSL_PKG_NAME)-$(OPENSSL_PKG_VERSION)-$(OPENSSL_PKG_ARCH)-$(OPENSSL_PKG_DISTRO_NAME)-$(OPENSSL_PKG_DISTRO_VERSION)

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


env_sysroot  = INSTALL_PREFIX=$(OPENSSL_PKG)


# These are the known patent issues with OpenSSL:
#   name |          expires
# -------+------------------------------------
# MDC-2: | 4,908,861  2007-03-13, not included
#  IDEA: | 5,214,703  2010-05-25, not included
#   RC5: | 5,724,428  2015-03-03, not included
#
# Although all of the above are expired, it's still
# probably not a good idea to include them as there
# are better algorithms to use.
#
extra_configure_switches  = --libdir=lib$(LIBSUFFIX)/openssl-1.0
extra_configure_switches += --openssldir=/etc/ssl
extra_configure_switches += no-mdc2
extra_configure_switches += no-idea
extra_configure_switches += no-rc5
extra_configure_switches += no-sse2
extra_configure_switches += no-ssl2
extra_configure_switches += no-weak-ssl-ciphers
extra_configure_switches += zlib-dynamic
extra_configure_switches += shared


ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC)),)
arch = i686
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
arch = x86_64
openssl_environment = KERNEL_BITS=64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC) $(TOOLCHAIN_A2X_GLIBC)   \
                             $(TOOLCHAIN_H3_GLIBC) $(TOOLCHAIN_RK328X_GLIBC) \
                             $(TOOLCHAIN_S8XX_GLIBC) $(TOOLCHAIN_IMX6_GLIBC) \
                             $(TOOLCHAIN_OMAP543X_GLIBC)),)
arch = arm
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC) $(TOOLCHAIN_RK33XX_GLIBC) \
                             $(TOOLCHAIN_RK339X_GLIBC) $(TOOLCHAIN_S9XX_GLIBC)),)
arch = aarch64
openssl_environment = KERNEL_BITS=64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC) $(TOOLCHAIN_P5600_GLIBC)),)
arch = mips32
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
arch = sparcv9
openssl_environment = KERNEL_BITS=64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
arch = ppc64
openssl_environment = KERNEL_BITS=64
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8LE_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC)),)
arch = ppc64le
openssl_environment = KERNEL_BITS=64
endif

openssl_environment += MACHINE=$(arch) SYSTEM=Linux


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	$(call apply-opt-patches, $(SRC_DIR))
	@( cd $(SRC_DIR) ; \
	   find . -name "*.pod" -exec sed -i "s/^\=item \([0-9]\)\(\ \|\.\|$$\)/\=item C<\1>/g" {} \; \
	 )
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC)),)
	@( cd $(SRC_DIR) ; \
	   sed -i "/linux-elf/s/fomit-frame-pointer/fomit-frame-pointer -march=i686 -mtune=i686/g" Configure ; \
	 )
endif
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(openssl_environment) ./config \
	  --prefix=/usr               \
	  $(extra_configure_switches) \
	  $(ARCH_FLAGS)               \
	  $(HW_FLAGS)
	# ======= workaround for crypto/evp/... =======
	@( cd $(SRC_DIR)/include/openssl ; \
	   ln -sf ../../crypto/idea/idea.h idea.h ; \
	   ln -sf ../../crypto/mdc2/mdc2.h mdc2.h ; \
	   ln -sf ../../crypto/rc5/rc5.h    rc5.h ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENSSL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 MANDIR=/usr/share/man install $(env_sysroot)
ifneq ($(__ENABLE_STATIC__),yes)
	@rm -f $(OPENSSL_PKG)/usr/lib$(LIBSUFFIX)/openssl-1.0/*.a
endif
	@rm -rf $(OPENSSL_PKG)/etc
	@rm -rf $(OPENSSL_PKG)/usr/share
	@mkdir -p $(OPENSSL_PKG)/usr/include/openssl-1.0
	@mv $(OPENSSL_PKG)/usr/include/openssl $(OPENSSL_PKG)/usr/include/openssl-1.0/openssl
	@mv $(OPENSSL_PKG)/usr/bin/openssl $(OPENSSL_PKG)/usr/bin/openssl-1.0
	@rm -f $(OPENSSL_PKG)/usr/bin/c_rehash
	@sed -e 's,/include$$,/include/openssl-1.0,' -i $(OPENSSL_PKG)/usr/lib$(LIBSUFFIX)/openssl-1.0/pkgconfig/*.pc
	@mkdir -p $(OPENSSL_PKG)/lib$(LIBSUFFIX)/openssl-1.0
	@( cd $(OPENSSL_PKG)/usr/lib$(LIBSUFFIX)/openssl-1.0 ; \
	   chmod +w lib*.so.?.?.? ; \
	   mv lib*.so.?.?.? ../../../lib$(LIBSUFFIX)/openssl-1.0 ; \
	   ln -sf ../../../lib$(LIBSUFFIX)/openssl-1.0/lib*.so.?.?.? . ; \
	   ln -sf libcrypto.so.?.?.? libcrypto.so.1 ; \
	   ln -sf libssl.so.?.?.? libssl.so.1 ; \
	   cp -a lib*.so.? ../../../lib$(LIBSUFFIX)/openssl-1.0 ; \
	 )
	@chmod +w $(OPENSSL_PKG)/usr/lib$(LIBSUFFIX)/openssl-1.0/engines/*.so
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OPENSSL_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/openssl-1.0/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrypto.pc libssl.pc openssl.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(OPENSSL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(OPENSSL_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(OPENSSL_PKG_DESCRIPTION_FILE): $(OPENSSL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
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
	@$(PSEUDO) sh -c "cd $(OPENSSL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
