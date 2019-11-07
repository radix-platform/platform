
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

REQUIRES           = libs/libidn2/2.2.0
REQUIRES          += secure/libcap/2.27
REQUIRES          += net/openssl/1.1.1d

# ======= __END_OF_REQUIRES__ =======


version            = s20190709
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/iputils/iputils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iputils-$(version)
src_dir_name       = iputils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

cross_file         = $(TARGET_BUILD_DIR)/$(TARGET)-cross


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IPUTILS_PKG_NAME                = iputils
IPUTILS_PKG_VERSION             = s20190709
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


env_sysroot = DESTDIR=$(IPUTILS_PKG)

#
# https://mesonbuild.com/Reference-tables.html :
# =============================================
#
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_A1X_GLIBC)  $(TOOLCHAIN_A2X_GLIBC)    \
                             $(TOOLCHAIN_H3_GLIBC)   $(TOOLCHAIN_RK328X_GLIBC) \
                             $(TOOLCHAIN_S8XX_GLIBC) $(TOOLCHAIN_IMX6_GLIBC)   \
                             $(TOOLCHAIN_OMAP543X_GLIBC)),)
cpu_name = arm
endian   = little
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_H5_GLIBC)     $(TOOLCHAIN_RK33XX_GLIBC) \
                             $(TOOLCHAIN_RK339X_GLIBC) $(TOOLCHAIN_S9XX_GLIBC)),)
cpu_name = aarch64
endian   = little
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC) $(TOOLCHAIN_P5600_GLIBC)),)
cpu_name = mips
endian   = little
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_R1000_GLIBC)),)
cpu_name = sparc64
endian   = big
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8_GLIBC) $(TOOLCHAIN_POWER9_GLIBC)),)
cpu_name = ppc64
endian   = big
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_POWER8LE_GLIBC) $(TOOLCHAIN_POWER9LE_GLIBC)),)
cpu_name = ppc64
endian   = little
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_I686_GLIBC)),)
cpu_name = x86
endian   = little
endif
ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
cpu_name = x86_64
endian   = little
endif

extra_configure_switches  = -DBUILD_TRACEROUTE6=true
extra_configure_switches += -DBUILD_RARPD=true


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@echo ""                                            >  $(cross_file)
	@echo "[build_machine]"                             >> $(cross_file)
	@echo "system = '$(shell uname -s | tr 'L' 'l')'"   >> $(cross_file)
	@echo "cpu_family = '$(shell uname -m)'"            >> $(cross_file)
	@echo "cpu = '$(shell uname -m)'"                   >> $(cross_file)
	@echo "endian = '$(shell lscpu | grep Endian | tr -s ' ' | cut -f3 -d' ' | tr 'L' 'l')'" >> $(cross_file)
	@echo ""                                            >> $(cross_file)
	@echo "[host_machine]"                              >> $(cross_file)
	@echo "system = 'linux'"                            >> $(cross_file)
	@echo "cpu_family = '$(cpu_name)'"                  >> $(cross_file)
	@echo "cpu = '$(cpu_name)'"                         >> $(cross_file)
	@echo "endian = '$(endian)'"                        >> $(cross_file)
	@echo ""                                            >> $(cross_file)
	@echo "[target_machine]"                            >> $(cross_file)
	@echo "system = 'linux'"                            >> $(cross_file)
	@echo "cpu_family = '$(cpu_name)'"                  >> $(cross_file)
	@echo "cpu = '$(cpu_name)'"                         >> $(cross_file)
	@echo "endian = '$(endian)'"                        >> $(cross_file)
	@echo ""                                            >> $(cross_file)
	@echo "[properties]"                                >> $(cross_file)
	@echo "c_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) $(CFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']"         >> $(cross_file)
	@echo "c_link_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) $(LDFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']"   >> $(cross_file)
	@echo "cpp_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) $(CFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']"       >> $(cross_file)
	@echo "cpp_link_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) $(LDFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']" >> $(cross_file)
	@echo "sys_root = '$(TARGET_DEST_DIR)'"             >> $(cross_file)
	@echo ""                                            >> $(cross_file)
	@echo "[binaries]"                                  >> $(cross_file)
	@echo "c = '$(TOOLCHAIN_PATH)/bin/$(TARGET)-gcc'"   >> $(cross_file)
	@echo "cpp = '$(TOOLCHAIN_PATH)/bin/$(TARGET)-g++'" >> $(cross_file)
	@echo "ar = '$(AR)'"                                >> $(cross_file)
	@echo "strip = '$(STRIP)'"                          >> $(cross_file)
	@echo "pkgconfig = 'pkg-config'"                    >> $(cross_file)
	@echo ""                                            >> $(cross_file)
	@echo "[paths]"                                     >> $(cross_file)
	@echo "prefix = '/usr'"                             >> $(cross_file)
	@echo "libdir = 'lib$(LIBSUFFIX)'"                  >> $(cross_file)
	@echo "libexecdir = '/usr/libexec'"                 >> $(cross_file)
	@echo "bindir = '/usr/bin'"                         >> $(cross_file)
	@echo "sbindir = '/usr/sbin'"                       >> $(cross_file)
	@echo "includedir = '/usr/include'"                 >> $(cross_file)
	@echo "datadir = '/usr/share'"                      >> $(cross_file)
	@echo "mandir = '/usr/share/man'"                   >> $(cross_file)
	@echo "sysconfdir = '/etc'"                         >> $(cross_file)
	@echo "localstatedir = '/var'"                      >> $(cross_file)
	@PKG_CONFIG_PATH= \
	   meson --buildtype=release    \
	    $(extra_configure_switches) \
	    --cross-file=$(cross_file) $(SRC_DIR) $(build_dir)
	@cd $(build_dir) && ninja -v
	@touch $@

$(install_target): $(build_target)
	# ======= Install Binaries =======
	# ======= cd $(build_dir) && DESTDIR=$(subst $(CURDIR)/,,$(IPUTILS_PKG)) ninja install =======
	@mkdir -p $(IPUTILS_PKG)/{bin,sbin}
	@mkdir -p $(IPUTILS_PKG)/usr/{bin,sbin}
	@mkdir -p $(IPUTILS_PKG)/usr/share/man/man8
	@mkdir -p $(IPUTILS_PKG)/usr/{,share}/doc/$(src_dir_name)
	@( cd $(build_dir) ; \
	   cat arping        > $(IPUTILS_PKG)/sbin/arping         ; \
	   cat clockdiff     > $(IPUTILS_PKG)/usr/sbin/clockdiff  ; \
	   cat ninfod/ninfod > $(IPUTILS_PKG)/usr/sbin/ninfod     ; \
	   cat ping          > $(IPUTILS_PKG)/bin/ping            ; \
	   cat rarpd         > $(IPUTILS_PKG)/usr/sbin/rarpd      ; \
	   cat rdisc         > $(IPUTILS_PKG)/usr/sbin/rdisc      ; \
	   cat tracepath     > $(IPUTILS_PKG)/usr/bin/tracepath   ; \
	   cat traceroute6   > $(IPUTILS_PKG)/usr/bin/traceroute6 ; \
	   chmod  755 $(IPUTILS_PKG)/sbin/arping         ; \
	   chmod  755 $(IPUTILS_PKG)/usr/sbin/clockdiff  ; \
	   chmod  755 $(IPUTILS_PKG)/usr/sbin/ninfod     ; \
	   chmod 4711 $(IPUTILS_PKG)/bin/ping            ; \
	   chmod  755 $(IPUTILS_PKG)/usr/sbin/rarpd $(IPUTILS_PKG)/usr/sbin/rdisc ; \
	   chmod  755 $(IPUTILS_PKG)/usr/bin/tracepath   ; \
	   chmod 4711 $(IPUTILS_PKG)/usr/bin/traceroute6 ; \
	 )
	@( cd $(IPUTILS_PKG)/bin ; ln -sf ping ping6 )
	@( cd $(IPUTILS_PKG)/usr/bin ; ln -sf tracepath tracepath6 )
	# ======= Install Documentation =======
	@( cd $(build_dir)/doc ; \
	   for page in arping clockdiff ninfod ping rarpd rdisc tracepath traceroute6 ; do \
	     cat $$page.8 | gzip -9c > $(IPUTILS_PKG)/usr/share/man/man8/$$page.8.gz ; \
	   done ; \
	 )
	@( cd $(IPUTILS_PKG)/usr/share/man/man8 ; \
	   ln -sf ping.8.gz      ping6.8.gz ; \
	   ln -sf tracepath.8.gz tracepath6.8.gz ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE \
	         $(IPUTILS_PKG)/usr/doc/$(src_dir_name) ; \
	   cp -a LICENSE README* Documentation/LICENSE* Documentation/README.maintainer \
	         $(IPUTILS_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a ninfod/COPYING \
	         $(IPUTILS_PKG)/usr/share/doc/$(src_dir_name)/COPYING.ninfod ; \
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
