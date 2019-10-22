
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


SOURCE_REQUIRES    = sources/GNOME/core/glib2

REQUIRES           = libs/libffi/3.2.1
REQUIRES          += libs/libelf/0.8.13
REQUIRES          += libs/pcre/8.43
REQUIRES          += app/attr/2.4.48
REQUIRES          += app/util-linux/2.34
REQUIRES          += libs/libgamin/0.1.10

# ======= __END_OF_REQUIRES__ =======


version            = 2.63.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/glib2/glib-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glib-$(version)
src_dir_name       = glib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

cross_file         = $(TARGET_BUILD_DIR)/$(TARGET)-cross


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIB2_PKG_NAME                = glib2
GLIB2_PKG_VERSION             = 2.63.0
GLIB2_PKG_ARCH                = $(TOOLCHAIN)
GLIB2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIB2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIB2_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GLIB2_PKG_SHORT_DESCRIPTION   = library of C routines
GLIB2_PKG_URL                 = $(BUG_URL)
GLIB2_PKG_LICENSE             = GPLv2
GLIB2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-pkg-description
GLIB2_PKG_DESCRIPTION_FILE_IN = $(GLIB2_PKG_NAME)-pkg-description.in
GLIB2_PKG_INSTALL_SCRIPT      = $(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-pkg-install.sh
GLIB2_PKG_INSTALL_SCRIPT_IN   = $(GLIB2_PKG_NAME)-pkg-install.sh.in

GLIB2_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIB2_PKG_NAME)-package

pkg_basename     = $(GLIB2_PKG_NAME)-$(GLIB2_PKG_VERSION)-$(GLIB2_PKG_ARCH)-$(GLIB2_PKG_DISTRO_NAME)-$(GLIB2_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GLIB2_PKG)

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


ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --default-library=both
else
extra_configure_switches += --default-library=shared
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	    -Dselinux=disabled          \
	    -Dfam=true                  \
	    -Dman=true                  \
	    -Dnls=enabled               \
	    -Dxattr=true                \
	    -Dgtk_doc=false             \
	    -Dinternal_pcre=false       \
	    -Dinstalled_tests=false     \
	    $(extra_configure_switches) \
	    --cross-file=$(cross_file) $(SRC_DIR) $(build_dir)
	@cd $(build_dir) && ninja -v
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLIB2_PKG)/etc/profile.d
	@cd $(build_dir) && $(env_sysroot) ninja install
	@cp -a $(CURDIR)/profile.d/libglib2.{csh,sh} $(GLIB2_PKG)/etc/profile.d
	@chmod 755 $(GLIB2_PKG)/etc/profile.d/*
	mv $(GLIB2_PKG)/etc/profile.d/libglib2.csh $(GLIB2_PKG)/etc/profile.d/libglib2.csh.new
	mv $(GLIB2_PKG)/etc/profile.d/libglib2.sh  $(GLIB2_PKG)/etc/profile.d/libglib2.sh.new
	# ======= Install Documentation =======
	@if [ -d $(GLIB2_PKG)/usr/share/man ]; then \
	  ( cd $(GLIB2_PKG)/usr/share/man ; \
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
	@mkdir -p $(GLIB2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GLIB2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL.in NEWS* README* \
	         $(GLIB2_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLIB2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLIB2_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gio-2.0.pc gio-unix-2.0.pc glib-2.0.pc gmodule-2.0.pc \
	                                            gmodule-export-2.0.pc gmodule-no-export-2.0.pc        \
	                                            gobject-2.0.pc gthread-2.0.pc ; \
	 )
	@( cd $(GLIB2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(GLIB2_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(GLIB2_PKG_DESCRIPTION_FILE): $(GLIB2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(GLIB2_PKG_INSTALL_SCRIPT): $(GLIB2_PKG_INSTALL_SCRIPT_IN)
	@cat $< | $(SED) -e "s,@LIBDIR@,/usr/lib$(LIBSUFFIX),g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLIB2_PKG_DESCRIPTION_FILE) $(GLIB2_PKG_INSTALL_SCRIPT)
	@cp $(GLIB2_PKG_DESCRIPTION_FILE) $(GLIB2_PKG)/.DESCRIPTION
	@cp $(GLIB2_PKG_INSTALL_SCRIPT) $(GLIB2_PKG)/.INSTALL
	@chmod a+x $(GLIB2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIB2_PKG)/.REQUIRES
	@echo "pkgname=$(GLIB2_PKG_NAME)"                            >  $(GLIB2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIB2_PKG_VERSION)"                          >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIB2_PKG_ARCH)"                               >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIB2_PKG_DISTRO_NAME)"                  >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIB2_PKG_DISTRO_VERSION)"                >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "group=$(GLIB2_PKG_GROUP)"                             >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIB2_PKG_SHORT_DESCRIPTION)\"" >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "url=$(GLIB2_PKG_URL)"                                 >> $(GLIB2_PKG)/.PKGINFO ; \
	 echo "license=$(GLIB2_PKG_LICENSE)"                         >> $(GLIB2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GLIB2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
