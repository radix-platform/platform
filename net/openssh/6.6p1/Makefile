
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


SOURCE_REQUIRES    = sources/packages/n/openssh

REQUIRES           = net/tcp_wrappers/7.6
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += net/openssl/1.0.2f
else
REQUIRES          += net/openssl/1.0.2f-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 6.6p1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/openssh/openssh-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openssh-$(version)
src_dir_name       = openssh-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

sshd_script_dir    = $(CURDIR)/config/rc.d


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENSSH_PKG_NAME                = openssh
OPENSSH_PKG_VERSION             = 6.6p1
OPENSSH_PKG_ARCH                = $(TOOLCHAIN)
OPENSSH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPENSSH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPENSSH_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
OPENSSH_PKG_SHORT_DESCRIPTION   = Secure Shell daemon and clients
OPENSSH_PKG_URL                 = $(BUG_URL)
OPENSSH_PKG_LICENSE             = GPLv2
OPENSSH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENSSH_PKG_NAME)-pkg-description
OPENSSH_PKG_DESCRIPTION_FILE_IN = $(OPENSSH_PKG_NAME)-pkg-description.in
OPENSSH_PKG_INSTALL_SCRIPT      = $(OPENSSH_PKG_NAME)-pkg-install.sh

OPENSSH_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENSSH_PKG_NAME)-package

pkg_basename     = $(OPENSSH_PKG_NAME)-$(OPENSSH_PKG_VERSION)-$(OPENSSH_PKG_ARCH)-$(OPENSSH_PKG_DISTRO_NAME)-$(OPENSSH_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(OPENSSH_PKG)


# To awoid errors when GCC options such as -Wl,-z,relro passed to LD
# we are using GCC as linker (implemented into patch):
#LD = $(CC_LINKER)


extra_configure_switches  = --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc/ssh
extra_configure_switches += --disable-strip
extra_configure_switches += --without-pam
extra_configure_switches += --without-rpath
extra_configure_switches += --with-md5-passwords
extra_configure_switches += --with-tcp-wrappers
extra_configure_switches += --with-default-path=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
extra_configure_switches += --with-privsep-path=/var/empty
extra_configure_switches += --with-privsep-user=sshd


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENSSH_PKG)/etc/rc.d
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(OPENSSH_PKG)/var/empty
	@chmod 755 $(OPENSSH_PKG)/var/empty
	@( cd $(SRC_DIR)/contrib ; \
	   cp -a ssh-copy-id $(OPENSSH_PKG)/usr/bin/ssh-copy-id ; \
	   chmod 755 $(OPENSSH_PKG)/usr/bin/ssh-copy-id ; \
	   cat ssh-copy-id.1 | gzip -9c > $(OPENSSH_PKG)/usr/share/man/man1/ssh-copy-id.1.gz ; \
	 )
	@( cd $(OPENSSH_PKG) ; \
	   rm -f etc/ssh/ssh_host_dsa_key     ; \
	   rm -f etc/ssh/ssh_host_dsa_key.pub ; \
	   rm -f etc/ssh/ssh_host_rsa_key     ; \
	   rm -f etc/ssh/ssh_host_rsa_key.pub ; \
	   rm -f etc/ssh/ssh_host_key         ; \
	   rm -f etc/ssh/ssh_host_key.pub     ; \
	   mv etc/ssh/ssh_config  etc/ssh/ssh_config.new  ; \
	   mv etc/ssh/sshd_config etc/ssh/sshd_config.new ; \
	 )
	@cat $(sshd_script_dir)/rc.sshd > $(OPENSSH_PKG)/etc/rc.d/rc.sshd.new
	@chmod 755 $(OPENSSH_PKG)/etc/rc.d/rc.sshd.new
	# ======= Install Documentation =======
	@if [ -d $(OPENSSH_PKG)/usr/share/man ]; then \
	  ( cd $(OPENSSH_PKG)/usr/share/man ; \
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
	@mkdir -p $(OPENSSH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CREDITS $(SRC_DIR)/LICENCE \
	       $(OPENSSH_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OPENSSH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CREDITS INSTALL LICENCE OVERVIEW PROTOCOL* README* TODO \
	         $(OPENSSH_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(OPENSSH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OPENSSH_PKG))
	# ======= Strip binaries =======
	@( cd $(OPENSSH_PKG) ; \
	   find . | xargs file | grep -e "executable" -e "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(OPENSSH_PKG_DESCRIPTION_FILE): $(OPENSSH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPENSSH_PKG_DESCRIPTION_FILE) $(OPENSSH_PKG_INSTALL_SCRIPT)
	@cp $(OPENSSH_PKG_DESCRIPTION_FILE) $(OPENSSH_PKG)/.DESCRIPTION
	@cp $(OPENSSH_PKG_INSTALL_SCRIPT) $(OPENSSH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENSSH_PKG)/.REQUIRES
	@echo "pkgname=$(OPENSSH_PKG_NAME)"                            >  $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENSSH_PKG_VERSION)"                          >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENSSH_PKG_ARCH)"                               >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENSSH_PKG_DISTRO_NAME)"                  >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENSSH_PKG_DISTRO_VERSION)"                >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "group=$(OPENSSH_PKG_GROUP)"                             >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENSSH_PKG_SHORT_DESCRIPTION)\"" >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "url=$(OPENSSH_PKG_URL)"                                 >> $(OPENSSH_PKG)/.PKGINFO ; \
	 echo "license=$(OPENSSH_PKG_LICENSE)"                         >> $(OPENSSH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OPENSSH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
