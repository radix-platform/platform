
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/glib2

REQUIRES           = libs/glib2/2.63.0
REQUIRES          += libs/libffi/3.2.1-ppc32
REQUIRES          += libs/libelf/0.8.13-ppc32
REQUIRES          += libs/pcre/8.43-ppc32
REQUIRES          += app/attr/2.4.48-ppc32
REQUIRES          += app/util-linux/2.34-ppc32
REQUIRES          += libs/libgamin/0.1.10-ppc32

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

cross_file         = $(TARGET_BUILD_DIR)/$(TARGET32)-cross


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIB2_32_PKG_NAME                = glib2-x32
GLIB2_32_PKG_VERSION             = 2.63.0
GLIB2_32_PKG_ARCH                = $(TOOLCHAIN)
GLIB2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIB2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIB2_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GLIB2_32_PKG_SHORT_DESCRIPTION   = library of C routines
GLIB2_32_PKG_URL                 = $(BUG_URL)
GLIB2_32_PKG_LICENSE             = GPLv2
GLIB2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIB2_32_PKG_NAME)-pkg-description
GLIB2_32_PKG_DESCRIPTION_FILE_IN = $(GLIB2_32_PKG_NAME)-pkg-description.in
GLIB2_32_PKG_INSTALL_SCRIPT      = $(GLIB2_32_PKG_NAME)-pkg-install.sh

GLIB2_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIB2_32_PKG_NAME)-package

pkg_basename     = $(GLIB2_32_PKG_NAME)-$(GLIB2_32_PKG_VERSION)-$(GLIB2_32_PKG_ARCH)-$(GLIB2_32_PKG_DISTRO_NAME)-$(GLIB2_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GLIB2_32_PKG)


cpu_name = ppc
endian   = big


ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --default-library=both
else
extra_configure_switches += --default-library=shared
endif


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
	@echo "c_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) $(CFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']"              >> $(cross_file)
	@echo "c_link_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) -m32 $(LDFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']"   >> $(cross_file)
	@echo "cpp_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) $(CFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']"            >> $(cross_file)
	@echo "cpp_link_args = ['`echo -n "--sysroot=$(TARGET_DEST_DIR) -m32 $(LDFLAGS)" | tr -s ' ' | sed "s/ /', '/g"`']" >> $(cross_file)
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
	@echo "libdir = 'lib$(MULTILIB_PPC32_SUFFIX)'"      >> $(cross_file)
	@echo "libexecdir = '/usr/libexec'"                 >> $(cross_file)
	@echo "bindir = '/usr/bin/32'"                      >> $(cross_file)
	@echo "sbindir = '/usr/sbin'"                       >> $(cross_file)
	@echo "includedir = '/usr/include'"                 >> $(cross_file)
	@echo "datadir = '/usr/share'"                      >> $(cross_file)
	@echo "mandir = '/usr/share/man'"                   >> $(cross_file)
	@echo "sysconfdir = '/etc'"                         >> $(cross_file)
	@echo "localstatedir = '/var'"                      >> $(cross_file)
	@PKG_CONFIG_PATH=/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig \
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ninja -v
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLIB2_32_PKG)
	@cd $(build_dir) && $(env_sysroot) ninja install
	@rm -rf $(GLIB2_32_PKG)/usr/include
	@rm -rf $(GLIB2_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLIB2_32_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gio-2.0.pc gio-unix-2.0.pc glib-2.0.pc gmodule-2.0.pc \
	                                            gmodule-export-2.0.pc gmodule-no-export-2.0.pc        \
	                                            gobject-2.0.pc gthread-2.0.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GLIB2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(GLIB2_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(GLIB2_32_PKG_DESCRIPTION_FILE): $(GLIB2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLIB2_32_PKG_DESCRIPTION_FILE) $(GLIB2_32_PKG_INSTALL_SCRIPT)
	@cp $(GLIB2_32_PKG_DESCRIPTION_FILE) $(GLIB2_32_PKG)/.DESCRIPTION
	@cp $(GLIB2_32_PKG_INSTALL_SCRIPT) $(GLIB2_32_PKG)/.INSTALL
	@chmod a+x $(GLIB2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIB2_32_PKG)/.REQUIRES
	@echo "pkgname=$(GLIB2_32_PKG_NAME)"                            >  $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIB2_32_PKG_VERSION)"                          >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIB2_32_PKG_ARCH)"                               >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIB2_32_PKG_DISTRO_NAME)"                  >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIB2_32_PKG_DISTRO_VERSION)"                >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "group=$(GLIB2_32_PKG_GROUP)"                             >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIB2_32_PKG_SHORT_DESCRIPTION)\"" >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "url=$(GLIB2_32_PKG_URL)"                                 >> $(GLIB2_32_PKG)/.PKGINFO ; \
	 echo "license=$(GLIB2_32_PKG_LICENSE)"                         >> $(GLIB2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GLIB2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
