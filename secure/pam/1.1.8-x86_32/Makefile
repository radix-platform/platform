
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/s/Linux-PAM

REQUIRES           = secure/pam/1.1.8
REQUIRES          += secure/cracklib/2.9.1-x86_32
REQUIRES          += dev/flex/2.5.39-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.8
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/s/Linux-PAM/Linux-PAM-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/Linux-PAM-$(version)
src_dir_name       = Linux-PAM-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PAM_32_PKG_NAME                = pam-x32
PAM_32_PKG_VERSION             = 1.1.8
PAM_32_PKG_ARCH                = $(TOOLCHAIN)
PAM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PAM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PAM_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PAM_32_PKG_SHORT_DESCRIPTION   = Pluggable Authentication Modules for Linux
PAM_32_PKG_URL                 = $(BUG_URL)
PAM_32_PKG_LICENSE             = BSD
PAM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PAM_32_PKG_NAME)-pkg-description
PAM_32_PKG_DESCRIPTION_FILE_IN = $(PAM_32_PKG_NAME)-pkg-description.in
PAM_32_PKG_INSTALL_SCRIPT      = $(PAM_32_PKG_NAME)-pkg-install.sh

PAM_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PAM_32_PKG_NAME)-package

pkg_basename     = $(PAM_32_PKG_NAME)-$(PAM_32_PKG_VERSION)-$(PAM_32_PKG_ARCH)-$(PAM_32_PKG_DISTRO_NAME)-$(PAM_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


CC_FOR_BUILD  = gcc
BUILD_CFLAGS  = -I/usr/include
BUILD_LDFLAGS = -L/usr/lib64

env_build = CC_FOR_BUILD=$(CC_FOR_BUILD)   \
            BUILD_CFLAGS=$(BUILD_CFLAGS)   \
            BUILD_LDFLAGS=$(BUILD_LDFLAGS)


env_sysroot  = DESTDIR=$(PAM_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --includedir=/usr/include/security
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib
extra_configure_switches += --enable-nis
extra_configure_switches += --disable-prelude
extra_configure_switches += --disable-selinux
extra_configure_switches += --disable-audit
extra_configure_switches += --disable-db
extra_configure_switches += --enable-isadir=../../lib$(MULTILIB_X86_32_SUFFIX)/security
extra_configure_switches += --without-libiconv-prefix
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(env_build) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PAM_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod -v 4755 $(PAM_32_PKG)/sbin/unix_chkpwd
	@mkdir -p $(PAM_32_PKG)/sbin/32
	@( cd $(PAM_32_PKG)/sbin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(PAM_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(PAM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@( cd $(PAM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/security ; \
	   ln -sf pam_unix.so pam_unix_acct.so    ; \
	   ln -sf pam_unix.so pam_unix_auth.so    ; \
	   ln -sf pam_unix.so pam_unix_passwd.so  ; \
	   ln -sf pam_unix.so pam_unix_session.so ; \
	 )
	@rm -rf $(PAM_32_PKG)/etc
	@rm -rf $(PAM_32_PKG)/usr/doc
	@rm -rf $(PAM_32_PKG)/usr/include
	@rm -rf $(PAM_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PAM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpam.la libpam_misc.la libpamc.la \
	 )
	@( cd $(PAM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/security ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" pam_*.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PAM_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpam.la libpam_misc.la libpamc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpam.la libpam_misc.la libpamc.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/security ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pam_*.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" pam_*.la \
	 )
	# ======= Strip binaries =======
	@( cd $(PAM_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PAM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/security ; \
	   rpath=`$(CHRPATH) -l pam_cracklib.so 2> /dev/null | grep "R*PATH"` ; \
	   if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	     $(CHRPATH) -r $(TARGET_RPATH) pam_cracklib.so 1> /dev/null 2> /dev/null ; \
	   fi ; \
	 )
endif
	@touch $@

$(PAM_32_PKG_DESCRIPTION_FILE): $(PAM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PAM_32_PKG_DESCRIPTION_FILE) $(PAM_32_PKG_INSTALL_SCRIPT)
	@cp $(PAM_32_PKG_DESCRIPTION_FILE) $(PAM_32_PKG)/.DESCRIPTION
	@cp $(PAM_32_PKG_INSTALL_SCRIPT) $(PAM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PAM_32_PKG)/.REQUIRES
	@echo "pkgname=$(PAM_32_PKG_NAME)"                            >  $(PAM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PAM_32_PKG_VERSION)"                          >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PAM_32_PKG_ARCH)"                               >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PAM_32_PKG_DISTRO_NAME)"                  >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PAM_32_PKG_DISTRO_VERSION)"                >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "group=$(PAM_32_PKG_GROUP)"                             >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PAM_32_PKG_SHORT_DESCRIPTION)\"" >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "url=$(PAM_32_PKG_URL)"                                 >> $(PAM_32_PKG)/.PKGINFO ; \
	 echo "license=$(PAM_32_PKG_LICENSE)"                         >> $(PAM_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PAM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
