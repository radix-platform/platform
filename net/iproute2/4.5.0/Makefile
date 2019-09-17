
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


SOURCE_REQUIRES    = sources/packages/n/iproute2

REQUIRES           = net/iptables/1.6.0
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += app/db/6.1.26
else
REQUIRES          += app/db/6.1.26-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.5.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/iproute2/iproute2-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iproute2-$(version)
src_dir_name       = iproute2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IPROUTE2_PKG_NAME                = iproute2
IPROUTE2_PKG_VERSION             = 4.5.0
IPROUTE2_PKG_ARCH                = $(TOOLCHAIN)
IPROUTE2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPROUTE2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPROUTE2_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
IPROUTE2_PKG_SHORT_DESCRIPTION   = IP routing utilities
IPROUTE2_PKG_URL                 = $(BUG_URL)
IPROUTE2_PKG_LICENSE             = GPLv2
IPROUTE2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPROUTE2_PKG_NAME)-pkg-description
IPROUTE2_PKG_DESCRIPTION_FILE_IN = $(IPROUTE2_PKG_NAME)-pkg-description.in
IPROUTE2_PKG_INSTALL_SCRIPT      = $(IPROUTE2_PKG_NAME)-pkg-install.sh

IPROUTE2_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPROUTE2_PKG_NAME)-package

pkg_basename     = $(IPROUTE2_PKG_NAME)-$(IPROUTE2_PKG_VERSION)-$(IPROUTE2_PKG_ARCH)-$(IPROUTE2_PKG_DISTRO_NAME)-$(IPROUTE2_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(IPROUTE2_PKG)


configure_switches  = LIBDIR=/usr/lib$(LIBSUFFIX)
configure_switches += CONFDIR=/etc/iproute2
configure_switches += DOCDIR=/usr/share/doc/$(src_dir_name)
configure_switches += MANDIR=/usr/share/man
configure_switches += DBM_INCLUDE=/usr/include/db61
configure_switches += HOSTCC=gcc
configure_switches += CBUILD_CFLAGS=


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) CCOPTS="$(CFLAGS)" $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IPROUTE2_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install  $(configure_switches) $(env_sysroot)
	@( cd $(IPROUTE2_PKG)/usr/share/man/man8 ; \
	   for file in *.8 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	# ======= Install libnetlink.a =======
	@mkdir -p $(IPROUTE2_PKG)/usr/include
	@cp $(SRC_DIR)/lib/libnetlink.a     $(IPROUTE2_PKG)/usr/lib$(LIBSUFFIX)
	@cp $(SRC_DIR)/include/libnetlink.h $(IPROUTE2_PKG)/usr/include
	# ======= Set symlinks in /usr/sbin =======
	@mkdir -p $(IPROUTE2_PKG)/usr/sbin
	@( cd $(IPROUTE2_PKG)/usr/sbin ; \
	   for file in ../../sbin/* ; do \
	     ln -sf $$file . ; \
	   done ; \
	 )
	# ======= Prepare /etc/iproute2 files for package-install =======
	@for file in $(IPROUTE2_PKG)/etc/iproute2/* ; do \
	   mv $$file $$file.new ; \
	 done
	# ======= Install Documentation =======
	@if [ -d $(IPROUTE2_PKG)/usr/share/man ]; then \
	  ( cd $(IPROUTE2_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(IPROUTE2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(IPROUTE2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IPROUTE2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README* \
	         $(IPROUTE2_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IPROUTE2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IPROUTE2_PKG))
	# ======= Strip binaries =======
	@( cd $(IPROUTE2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(IPROUTE2_PKG_DESCRIPTION_FILE): $(IPROUTE2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPROUTE2_PKG_DESCRIPTION_FILE) $(IPROUTE2_PKG_INSTALL_SCRIPT)
	@cp $(IPROUTE2_PKG_DESCRIPTION_FILE) $(IPROUTE2_PKG)/.DESCRIPTION
	@cp $(IPROUTE2_PKG_INSTALL_SCRIPT) $(IPROUTE2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPROUTE2_PKG)/.REQUIRES
	@echo "pkgname=$(IPROUTE2_PKG_NAME)"                            >  $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPROUTE2_PKG_VERSION)"                          >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "arch=$(IPROUTE2_PKG_ARCH)"                               >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPROUTE2_PKG_DISTRO_NAME)"                  >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPROUTE2_PKG_DISTRO_VERSION)"                >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "group=$(IPROUTE2_PKG_GROUP)"                             >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPROUTE2_PKG_SHORT_DESCRIPTION)\"" >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "url=$(IPROUTE2_PKG_URL)"                                 >> $(IPROUTE2_PKG)/.PKGINFO ; \
	 echo "license=$(IPROUTE2_PKG_LICENSE)"                         >> $(IPROUTE2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IPROUTE2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
