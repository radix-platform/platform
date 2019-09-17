
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


SOURCE_REQUIRES    = sources/packages/l/libcap

REQUIRES           = app/attr/2.4.47
REQUIRES          += secure/pam/1.1.8

# ======= __END_OF_REQUIRES__ =======


version            = 2.25
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libcap/libcap-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcap-$(version)
src_dir_name       = libcap-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBCAP_PKG_NAME                = libcap
LIBCAP_PKG_VERSION             = 2.25
LIBCAP_PKG_ARCH                = $(TOOLCHAIN)
LIBCAP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCAP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCAP_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBCAP_PKG_SHORT_DESCRIPTION   = get/set POSIX capabilities
LIBCAP_PKG_URL                 = $(BUG_URL)
LIBCAP_PKG_LICENSE             = GPLv2
LIBCAP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCAP_PKG_NAME)-pkg-description
LIBCAP_PKG_DESCRIPTION_FILE_IN = $(LIBCAP_PKG_NAME)-pkg-description.in
LIBCAP_PKG_INSTALL_SCRIPT      = $(LIBCAP_PKG_NAME)-pkg-install.sh

LIBCAP_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCAP_PKG_NAME)-package

pkg_basename     = $(LIBCAP_PKG_NAME)-$(LIBCAP_PKG_VERSION)-$(LIBCAP_PKG_ARCH)-$(LIBCAP_PKG_DISTRO_NAME)-$(LIBCAP_PKG_DISTRO_VERSION)

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


env_sysroot = FAKEROOT=$(LIBCAP_PKG)


BUILD_PAM_MODULE    = yes

configure_switches  = lib=lib$(LIBSUFFIX)
configure_switches += DYNAMIC=yes
configure_switches += RAISE_SETFCAP=no
configure_switches += BUILD_CC=gcc
configure_switches += PAM_CAP=$(BUILD_PAM_MODULE)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   sed -i.orig "s/^\(DEBUG =\).*/\1 $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS)/" Make.Rules ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBCAP_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(configure_switches) $(env_sysroot)
	@chmod 0755 $(LIBCAP_PKG)/lib$(LIBSUFFIX)/libcap.so.?.??
ifeq ($(BUILD_PAM_MODULE),yes)
	@mv $(LIBCAP_PKG)/lib$(LIBSUFFIX)/security $(LIBCAP_PKG)/usr/lib$(LIBSUFFIX)
endif
	@mkdir -p $(LIBCAP_PKG)/usr/sbin
	@( cd $(SRC_DIR)/contrib ; \
	   for file in pcaps4convenience pcaps4server pcaps4suid0 ; do \
	     install -m 0755 -D $$file $(LIBCAP_PKG)/usr/sbin/$$file ; \
	   done ; \
	 )
	# ======= Install Documentation =======
	@( cd $(LIBCAP_PKG)/usr/share/man/man3 ; \
	   rm -f cap_clear_flag.3 cap_compare.3 cap_get_flag.3 cap_set_flag.3 ; \
	   ln -sf cap_clear.3 cap_clear_flag.3 ; \
	   ln -sf cap_clear.3 cap_compare.3    ; \
	   ln -sf cap_clear.3 cap_get_flag.3   ; \
	   ln -sf cap_clear.3 cap_set_flag.3   ; \
	   rm -f cap_copy_int.3 cap_size.3      ; \
	   ln -sf cap_copy_ext.3 cap_copy_int.3 ; \
	   ln -sf cap_copy_ext.3 cap_size.3     ; \
	   rm -f cap_drop_bound.3 cap_get_bound.3 cap_get_pid.3 cap_set_proc.3 capgetp.3 capsetp.3 ; \
	   ln -sf cap_get_proc.3 cap_drop_bound.3 ; \
	   ln -sf cap_get_proc.3 cap_get_bound.3  ; \
	   ln -sf cap_get_proc.3 cap_get_pid.3    ; \
	   ln -sf cap_get_proc.3 cap_set_proc.3   ; \
	   ln -sf cap_get_proc.3 capgetp.3        ; \
	   ln -sf cap_get_proc.3 capsetp.3        ; \
	   rm -f cap_dup.3 cap_free.3   ; \
	   ln -sf cap_init.3 cap_dup.3  ; \
	   ln -sf cap_init.3 cap_free.3 ; \
	   rm -f cap_from_name.3 cap_to_name.3 cap_to_text.3 ; \
	   ln -sf cap_from_text.3 cap_from_name.3 ; \
	   ln -sf cap_from_text.3 cap_to_name.3   ; \
	   ln -sf cap_from_text.3 cap_to_text.3   ; \
	   rm -f cap_get_fd.3 cap_set_fd.3 cap_set_file.3 ; \
	   ln -sf cap_get_file.3 cap_get_fd.3   ; \
	   ln -sf cap_get_file.3 cap_set_fd.3   ; \
	   ln -sf cap_get_file.3 cap_set_file.3 ; \
	 )
	@if [ -d $(LIBCAP_PKG)/usr/share/man ]; then \
	  ( cd $(LIBCAP_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBCAP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/License $(SRC_DIR)/README \
	       $(LIBCAP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBCAP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a License README pgp.keys.asc doc/capability.notes progs/quicktest.sh \
	         $(LIBCAP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG ]; then \
	     DOCSDIR=`echo $(LIBCAP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG | head -n 1000 > $$DOCSDIR/CHANGELOG ; \
	     touch -r CHANGELOG $$DOCSDIR/CHANGELOG ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBCAP_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcap.pc ; \
	   sed -i "s,/lib,$(TARGET_DEST_DIR)/lib,g" libcap.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCAP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBCAP_PKG_DESCRIPTION_FILE): $(LIBCAP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCAP_PKG_DESCRIPTION_FILE) $(LIBCAP_PKG_INSTALL_SCRIPT)
	@cp $(LIBCAP_PKG_DESCRIPTION_FILE) $(LIBCAP_PKG)/.DESCRIPTION
	@cp $(LIBCAP_PKG_INSTALL_SCRIPT) $(LIBCAP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCAP_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCAP_PKG_NAME)"                            >  $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCAP_PKG_VERSION)"                          >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCAP_PKG_ARCH)"                               >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCAP_PKG_DISTRO_NAME)"                  >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCAP_PKG_DISTRO_VERSION)"                >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCAP_PKG_GROUP)"                             >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCAP_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCAP_PKG_URL)"                                 >> $(LIBCAP_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCAP_PKG_LICENSE)"                         >> $(LIBCAP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBCAP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
