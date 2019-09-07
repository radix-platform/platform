
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
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


SOURCE_REQUIRES    = sources/packages/n/tcp_wrappers

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.27
endif

# ======= __END_OF_REQUIRES__ =======


version            = 7.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/tcp_wrappers/tcp_wrappers_$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/tcp_wrappers_$(version)
src_dir_name       = tcp_wrappers_$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TCP_WRAP_PKG_NAME                = tcp_wrappers
TCP_WRAP_PKG_VERSION             = 7.6
TCP_WRAP_PKG_ARCH                = $(TOOLCHAIN)
TCP_WRAP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TCP_WRAP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TCP_WRAP_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
TCP_WRAP_PKG_SHORT_DESCRIPTION   = TCP/IP daemon wrapper library and utilities
TCP_WRAP_PKG_URL                 = $(BUG_URL)
TCP_WRAP_PKG_LICENSE             = GPLv2
TCP_WRAP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TCP_WRAP_PKG_NAME)-pkg-description
TCP_WRAP_PKG_DESCRIPTION_FILE_IN = $(TCP_WRAP_PKG_NAME)-pkg-description.in
TCP_WRAP_PKG_INSTALL_SCRIPT      = $(TCP_WRAP_PKG_NAME)-pkg-install.sh

TCP_WRAP_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TCP_WRAP_PKG_NAME)-package

pkg_basename     = $(TCP_WRAP_PKG_NAME)-$(TCP_WRAP_PKG_VERSION)-$(TCP_WRAP_PKG_ARCH)-$(TCP_WRAP_PKG_DISTRO_NAME)-$(TCP_WRAP_PKG_DISTRO_VERSION)

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


tcp_wrappers_environment = CFLAGS="-isystem $(TARGET_DEST_DIR)/usr/include $(OPTIMIZATION_FLAGS) $(ARCH_FLAGS) $(HW_FLAGS) -DHAVE_STRERROR"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(tcp_wrappers_environment) \
	                  $(MAKE) MAJOR=0 MINOR=0 REL=0 REAL_DAEMON_DIR=/usr/sbin linux
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TCP_WRAP_PKG)/usr/include
	@mkdir -p $(TCP_WRAP_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(TCP_WRAP_PKG)/usr/sbin
	# ======= Install Documentation =======
	@mkdir -p $(TCP_WRAP_PKG)/usr/share/man/man{3,5,8}
	@mkdir -p $(TCP_WRAP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cat safe_finger > $(TCP_WRAP_PKG)/usr/sbin/safe_finger ; \
	   cat tcpd        > $(TCP_WRAP_PKG)/usr/sbin/tcpd        ; \
	   cat tcpdchk     > $(TCP_WRAP_PKG)/usr/sbin/tcpdchk     ; \
	   cat tcpdmatch   > $(TCP_WRAP_PKG)/usr/sbin/tcpdmatch   ; \
	   cat try-from    > $(TCP_WRAP_PKG)/usr/sbin/try-from    ; \
	   chmod 755 $(TCP_WRAP_PKG)/usr/sbin/* ; \
	   cat libwrap.a > $(TCP_WRAP_PKG)/usr/lib$(LIBSUFFIX)/libwrap.a ; \
	   cp -a libwrap.so* $(TCP_WRAP_PKG)/usr/lib$(LIBSUFFIX)         ; \
	   cat tcpd.h > $(TCP_WRAP_PKG)/usr/include/tcpd.h ; \
	   cat hosts_access.3  | gzip -9c > $(TCP_WRAP_PKG)/usr/share/man/man3/hosts_access.3.gz  ; \
	   cat hosts_access.5  | gzip -9c > $(TCP_WRAP_PKG)/usr/share/man/man5/hosts_access.5.gz  ; \
	   cat hosts_options.5 | gzip -9c > $(TCP_WRAP_PKG)/usr/share/man/man5/hosts_options.5.gz ; \
	   cat tcpd.8          | gzip -9c > $(TCP_WRAP_PKG)/usr/share/man/man8/tcpd.8.gz          ; \
	   cat tcpdchk.8       | gzip -9c > $(TCP_WRAP_PKG)/usr/share/man/man8/tcpdchk.8.gz       ; \
	   cat tcpdmatch.8     | gzip -9c > $(TCP_WRAP_PKG)/usr/share/man/man8/tcpdmatch.8.gz     ; \
	   cp -a BLURB CHANGES DISCLAIMER README* \
	         $(TCP_WRAP_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TCP_WRAP_PKG))
	# ======= Strip binaries =======
	@( cd $(TCP_WRAP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(TCP_WRAP_PKG_DESCRIPTION_FILE): $(TCP_WRAP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TCP_WRAP_PKG_DESCRIPTION_FILE) $(TCP_WRAP_PKG_INSTALL_SCRIPT)
	@cp $(TCP_WRAP_PKG_DESCRIPTION_FILE) $(TCP_WRAP_PKG)/.DESCRIPTION
	@cp $(TCP_WRAP_PKG_INSTALL_SCRIPT) $(TCP_WRAP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TCP_WRAP_PKG)/.REQUIRES
	@echo "pkgname=$(TCP_WRAP_PKG_NAME)"                            >  $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TCP_WRAP_PKG_VERSION)"                          >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "arch=$(TCP_WRAP_PKG_ARCH)"                               >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "distroname=$(TCP_WRAP_PKG_DISTRO_NAME)"                  >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "distrover=$(TCP_WRAP_PKG_DISTRO_VERSION)"                >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "group=$(TCP_WRAP_PKG_GROUP)"                             >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TCP_WRAP_PKG_SHORT_DESCRIPTION)\"" >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "url=$(TCP_WRAP_PKG_URL)"                                 >> $(TCP_WRAP_PKG)/.PKGINFO ; \
	 echo "license=$(TCP_WRAP_PKG_LICENSE)"                         >> $(TCP_WRAP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TCP_WRAP_PKG)  && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
