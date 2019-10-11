
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/util-linux

REQUIRES           = app/util-linux/2.34
REQUIRES          += libs/libcap-ng/0.7.10-ppc32
REQUIRES          += secure/pam/1.1.8-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 2.34
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/util-linux/util-linux-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/util-linux-$(version)
src_dir_name       = util-linux-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
UTILLINUX_32_PKG_NAME                = util-linux-x32
UTILLINUX_32_PKG_VERSION             = 2.34
UTILLINUX_32_PKG_ARCH                = $(TOOLCHAIN)
UTILLINUX_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
UTILLINUX_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
UTILLINUX_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
UTILLINUX_32_PKG_SHORT_DESCRIPTION   = huge collection of essential utilities
UTILLINUX_32_PKG_URL                 = $(BUG_URL)
UTILLINUX_32_PKG_LICENSE             = GPLv2
UTILLINUX_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(UTILLINUX_32_PKG_NAME)-pkg-description
UTILLINUX_32_PKG_DESCRIPTION_FILE_IN = $(UTILLINUX_32_PKG_NAME)-pkg-description.in
UTILLINUX_32_PKG_INSTALL_SCRIPT      = $(UTILLINUX_32_PKG_NAME)-pkg-install.sh

UTILLINUX_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(UTILLINUX_32_PKG_NAME)-package

pkg_basename     = $(UTILLINUX_32_PKG_NAME)-$(UTILLINUX_32_PKG_VERSION)-$(UTILLINUX_32_PKG_ARCH)-$(UTILLINUX_32_PKG_DISTRO_NAME)-$(UTILLINUX_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(UTILLINUX_32_PKG)


extra_configure_switches  = --libdir=/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-ncursesw
extra_configure_switches += --with-readline

extra_configure_switches += --with-python=3

extra_configure_switches += --enable-agetty
extra_configure_switches += --enable-cramfs
extra_configure_switches += --enable-fdformat
extra_configure_switches += --enable-kill
extra_configure_switches += --disable-last
extra_configure_switches += --enable-libmount-support-mtab
extra_configure_switches += --enable-line
extra_configure_switches += --enable-mesg
extra_configure_switches += --enable-partx
extra_configure_switches += --enable-pg
extra_configure_switches += --enable-raw
extra_configure_switches += --enable-rename
extra_configure_switches += --enable-reset
extra_configure_switches += --enable-tunelp

extra_configure_switches += --disable-login
extra_configure_switches += --disable-nologin
extra_configure_switches += --disable-sulogin
extra_configure_switches += --disable-su

extra_configure_switches += --enable-schedutils

extra_configure_switches += --enable-wall
extra_configure_switches += --enable-write
extra_configure_switches += --enable-use-tty-group
extra_configure_switches += --enable-makeinstall-chown=no

extra_configure_switches += --enable-libblkid
extra_configure_switches += --enable-libmount
extra_configure_switches += --enable-libuuid
extra_configure_switches += --disable-uuidd

extra_configure_switches += --without-systemd
extra_configure_switches += --without-systemdsystemunitdir

ifneq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --disable-static
endif

extra_configure_switches += NCURSESW6_CONFIG='$(TARGET_DEST_DIR)/usr/bin/32/ncursesw6-config'


PYTHON_VERSION=3.7

python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += am_cv_python_pythondir=/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages


TARGET_BIN_RPATH = /lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(UTILLINUX_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(UTILLINUX_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_PPC32_SUFFIX)/lib*.so.1.* . ; \
	   ln -sf libblkid.so.1.*     libblkid.so.1     ; \
	   ln -sf libfdisk.so.1.*     libfdisk.so.1     ; \
	   ln -sf libmount.so.1.*     libmount.so.1     ; \
	   ln -sf libsmartcols.so.1.* libsmartcols.so.1 ; \
	   ln -sf libuuid.so.1.*      libuuid.so.1      ; \
	   rm -f lib*.so ; \
	   ln -sf libblkid.so.1     libblkid.so     ; \
	   ln -sf libfdisk.so.1     libfdisk.so     ; \
	   ln -sf libmount.so.1     libmount.so     ; \
	   ln -sf libsmartcols.so.1 libsmartcols.so ; \
	   ln -sf libuuid.so.1      libuuid.so      ; \
	 )
	@rm -rf $(UTILLINUX_32_PKG)/bin
	@rm -rf $(UTILLINUX_32_PKG)/sbin
	@rm -rf $(UTILLINUX_32_PKG)/usr/include
	@rm -rf $(UTILLINUX_32_PKG)/usr/sbin
	@rm -rf $(UTILLINUX_32_PKG)/usr/share
	@mkdir -p $(UTILLINUX_32_PKG)/usr/bin/32
	@( cd $(UTILLINUX_32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	   find . -type l | xargs mv -t 32 ; \
	 )
	# ======= remove target dest dir from target libtool *.la files =======
	@( cd $(UTILLINUX_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libblkid.la libfdisk.la libmount.la libsmartcols.la libuuid.la \
	 )
	@( cd $(UTILLINUX_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages/libmount ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" pylibmount.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(UTILLINUX_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libblkid.la libfdisk.la libmount.la libsmartcols.la libuuid.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libblkid.la libfdisk.la libmount.la libsmartcols.la libuuid.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/python$(PYTHON_VERSION)/site-packages/libmount ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pylibmount.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" pylibmount.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" blkid.pc fdisk.pc mount.pc smartcols.pc uuid.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(UTILLINUX_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(UTILLINUX_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(UTILLINUX_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(UTILLINUX_32_PKG_DESCRIPTION_FILE): $(UTILLINUX_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(UTILLINUX_32_PKG_DESCRIPTION_FILE) $(UTILLINUX_32_PKG_INSTALL_SCRIPT)
	@cp $(UTILLINUX_32_PKG_DESCRIPTION_FILE) $(UTILLINUX_32_PKG)/.DESCRIPTION
	@cp $(UTILLINUX_32_PKG_INSTALL_SCRIPT) $(UTILLINUX_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(UTILLINUX_32_PKG)/.REQUIRES
	@echo "pkgname=$(UTILLINUX_32_PKG_NAME)"                            >  $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(UTILLINUX_32_PKG_VERSION)"                          >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "arch=$(UTILLINUX_32_PKG_ARCH)"                               >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(UTILLINUX_32_PKG_DISTRO_NAME)"                  >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(UTILLINUX_32_PKG_DISTRO_VERSION)"                >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "group=$(UTILLINUX_32_PKG_GROUP)"                             >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(UTILLINUX_32_PKG_SHORT_DESCRIPTION)\"" >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "url=$(UTILLINUX_32_PKG_URL)"                                 >> $(UTILLINUX_32_PKG)/.PKGINFO ; \
	 echo "license=$(UTILLINUX_32_PKG_LICENSE)"                         >> $(UTILLINUX_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(UTILLINUX_32_PKG)  && \
	                  chown -R root:root . && \
	                  chgrp   5 usr/bin/32/wall  && \
	                  chmod g+s usr/bin/32/wall  && \
	                  chgrp   5 usr/bin/32/write && \
	                  chmod g+s usr/bin/32/write && \
	                  $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
