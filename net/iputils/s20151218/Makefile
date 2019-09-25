
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


SOURCE_REQUIRES    = sources/packages/n/iputils

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/readline/6.3
REQUIRES           = secure/libcap/2.25
REQUIRES          += net/gnutls/3.4.8
REQUIRES          += net/openssl/1.0.2f
else
REQUIRES           = libs/readline/6.3-x86_32
REQUIRES           = secure/libcap/2.25-x86_32
REQUIRES          += net/gnutls/3.4.8-x86_32
REQUIRES          += net/openssl/1.0.2f-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = s20151218
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/iputils/iputils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iputils-$(version)
src_dir_name       = iputils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IPUTILS_PKG_NAME                = iputils
IPUTILS_PKG_VERSION             = s20151218
IPUTILS_PKG_ARCH                = $(TOOLCHAIN)
IPUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPUTILS_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
IPUTILS_PKG_SHORT_DESCRIPTION   = a collection of common network tools
IPUTILS_PKG_URL                 = $(BUG_URL)
IPUTILS_PKG_LICENSE             = BSD
IPUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPUTILS_PKG_NAME)-pkg-description
IPUTILS_PKG_DESCRIPTION_FILE_IN = $(IPUTILS_PKG_NAME)-pkg-description.in
IPUTILS_PKG_INSTALL_SCRIPT      = $(IPUTILS_PKG_NAME)-pkg-install.sh

IPUTILS_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPUTILS_PKG_NAME)-package

pkg_basename     = $(IPUTILS_PKG_NAME)-$(IPUTILS_PKG_VERSION)-$(IPUTILS_PKG_ARCH)-$(IPUTILS_PKG_DISTRO_NAME)-$(IPUTILS_PKG_DISTRO_VERSION)

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


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc


iputils_CFLAGS = -isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS)
iputils_environment = CFLAGS="$(iputils_CFLAGS) -DUSE_GNUTLS" LIBC_INCLUDE="$(TARGET_DEST_DIR)/usr/include"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(iputils_environment) $(MAKE)
	@cd $(SRC_DIR)/ninfod && $(BUILD_ENVIRONMENT) $(iputils_environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR)/ninfod && $(BUILD_ENVIRONMENT) $(iputils_environment) $(MAKE)
	@cd $(SRC_DIR)/doc && $(BUILD_ENVIRONMENT) $(iputils_environment) $(MAKE) -j1 man
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IPUTILS_PKG)/{bin,sbin}
	@mkdir -p $(IPUTILS_PKG)/usr/{bin,sbin}
	@mkdir -p $(IPUTILS_PKG)/usr/share/man/man8
	@mkdir -p $(IPUTILS_PKG)/usr/share/doc/$(src_dir_name)
	# ping6 source routing is deprecated by RFC5095 [for use RFC3542 the Makefile needs to be patched]
	@( cd $(SRC_DIR) ; \
	   cat arping        > $(IPUTILS_PKG)/sbin/arping         ; \
	   cat clockdiff     > $(IPUTILS_PKG)/usr/sbin/clockdiff  ; \
	   cat ninfod/ninfod > $(IPUTILS_PKG)/usr/sbin/ninfod     ; \
	   cat ping          > $(IPUTILS_PKG)/bin/ping            ; \
	   cat ping6         > $(IPUTILS_PKG)/bin/ping6           ; \
	   cat rarpd         > $(IPUTILS_PKG)/usr/sbin/rarpd      ; \
	   cat rdisc         > $(IPUTILS_PKG)/usr/sbin/rdisc      ; \
	   cat tracepath     > $(IPUTILS_PKG)/usr/bin/tracepath   ; \
	   cat tracepath6    > $(IPUTILS_PKG)/usr/bin/tracepath6  ; \
	   cat traceroute6   > $(IPUTILS_PKG)/usr/bin/traceroute6 ; \
	   chmod  755 $(IPUTILS_PKG)/sbin/arping         ; \
	   chmod  755 $(IPUTILS_PKG)/usr/sbin/clockdiff  ; \
	   chmod  755 $(IPUTILS_PKG)/usr/sbin/ninfod     ; \
	   chmod 4711 $(IPUTILS_PKG)/bin/ping       $(IPUTILS_PKG)/bin/ping6      ; \
	   chmod  755 $(IPUTILS_PKG)/usr/sbin/rarpd $(IPUTILS_PKG)/usr/sbin/rdisc ; \
	   chmod  755 $(IPUTILS_PKG)/usr/bin/tracepath*  ; \
	   chmod 4711 $(IPUTILS_PKG)/usr/bin/traceroute6 ; \
	 )
	# ======= Install Documentation =======
	@( cd $(SRC_DIR)/doc ; \
	   for page in arping clockdiff ninfod ping rarpd rdisc tracepath traceroute6 ; do \
	     cat $$page.8 | gzip -9c > $(IPUTILS_PKG)/usr/share/man/man8/$$page.8.gz ; \
	   done ; \
	 )
	@( cd $(IPUTILS_PKG)/usr/share/man/man8 ; \
	   ln -sf ping.8.gz      ping6.8.gz ; \
	   ln -sf tracepath.8.gz tracepath6.8.gz ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a RELNOTES \
	         $(IPUTILS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IPUTILS_PKG))
	# ======= Strip binaries =======
	@( cd $(IPUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(IPUTILS_PKG_DESCRIPTION_FILE): $(IPUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPUTILS_PKG_DESCRIPTION_FILE) $(IPUTILS_PKG_INSTALL_SCRIPT)
	@cp $(IPUTILS_PKG_DESCRIPTION_FILE) $(IPUTILS_PKG)/.DESCRIPTION
	@cp $(IPUTILS_PKG_INSTALL_SCRIPT) $(IPUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(IPUTILS_PKG_NAME)"                            >  $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPUTILS_PKG_VERSION)"                          >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(IPUTILS_PKG_ARCH)"                               >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPUTILS_PKG_DISTRO_NAME)"                  >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPUTILS_PKG_DISTRO_VERSION)"                >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(IPUTILS_PKG_GROUP)"                             >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(IPUTILS_PKG_URL)"                                 >> $(IPUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(IPUTILS_PKG_LICENSE)"                         >> $(IPUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IPUTILS_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
