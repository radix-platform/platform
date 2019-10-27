
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/procps-ng

REQUIRES           = app/procps-ng/3.3.15
REQUIRES          += libs/ncurses/6.1-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 3.3.15
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/procps-ng/procps-ng-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/procps-ng-$(version)
src_dir_name       = procps-ng-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PROCPS_32_PKG_NAME                = procps-ng-x32
PROCPS_32_PKG_VERSION             = 3.3.15
PROCPS_32_PKG_ARCH                = $(TOOLCHAIN)
PROCPS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PROCPS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PROCPS_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
PROCPS_32_PKG_SHORT_DESCRIPTION   = utilities for displaying process information
PROCPS_32_PKG_URL                 = $(BUG_URL)
PROCPS_32_PKG_LICENSE             = GPLv2
PROCPS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PROCPS_32_PKG_NAME)-pkg-description
PROCPS_32_PKG_DESCRIPTION_FILE_IN = $(PROCPS_32_PKG_NAME)-pkg-description.in
PROCPS_32_PKG_INSTALL_SCRIPT      = $(PROCPS_32_PKG_NAME)-pkg-install.sh

PROCPS_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PROCPS_32_PKG_NAME)-package

pkg_basename     = $(PROCPS_32_PKG_NAME)-$(PROCPS_32_PKG_VERSION)-$(PROCPS_32_PKG_ARCH)-$(PROCPS_32_PKG_DISTRO_NAME)-$(PROCPS_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(PROCPS_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --datarootdir=/usr/share
extra_configure_switches += --bindir=/bin
extra_configure_switches += --sbindir=/sbin

extra_configure_switches += --disable-silent-rules
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-watch8bit
extra_configure_switches += --enable-skill
extra_configure_switches += --enable-sigwinch
extra_configure_switches += --enable-w-from
extra_configure_switches += --disable-kill
extra_configure_switches += --without-systemd
extra_configure_switches += --disable-modern-top

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


LDFLAGS += -Wl,-rpath=/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX):/usr/lib/../lib$(MULTILIB_PPC32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PROCPS_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Move the shared library to /lib$(MULTILIB_PPC32_SUFFIX): =======
	@mkdir -p $(PROCPS_32_PKG)/lib$(MULTILIB_PPC32_SUFFIX)
	@( cd $(PROCPS_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_PPC32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_PPC32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_PPC32_SUFFIX) ; \
	 )
	@rm -rf $(PROCPS_32_PKG)/{bin,sbin}
	@rm -rf $(PROCPS_32_PKG)/usr/include
	@rm -rf $(PROCPS_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PROCPS_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libprocps.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PROCPS_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libprocps.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libprocps.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libprocps.pc ; \
	 )
	# ======= Strip Binaries =======
	@( cd $(PROCPS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(PROCPS_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(PROCPS_32_PKG_DESCRIPTION_FILE): $(PROCPS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PROCPS_32_PKG_DESCRIPTION_FILE) $(PROCPS_32_PKG_INSTALL_SCRIPT)
	@cp $(PROCPS_32_PKG_DESCRIPTION_FILE) $(PROCPS_32_PKG)/.DESCRIPTION
	@cp $(PROCPS_32_PKG_INSTALL_SCRIPT) $(PROCPS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PROCPS_32_PKG)/.REQUIRES
	@echo "pkgname=$(PROCPS_32_PKG_NAME)"                            >  $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PROCPS_32_PKG_VERSION)"                          >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PROCPS_32_PKG_ARCH)"                               >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PROCPS_32_PKG_DISTRO_NAME)"                  >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PROCPS_32_PKG_DISTRO_VERSION)"                >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "group=$(PROCPS_32_PKG_GROUP)"                             >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PROCPS_32_PKG_SHORT_DESCRIPTION)\"" >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "url=$(PROCPS_32_PKG_URL)"                                 >> $(PROCPS_32_PKG)/.PKGINFO ; \
	 echo "license=$(PROCPS_32_PKG_LICENSE)"                         >> $(PROCPS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PROCPS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
