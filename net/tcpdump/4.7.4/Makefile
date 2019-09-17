
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


SOURCE_REQUIRES    = sources/packages/n/tcpdump

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = net/libpcap/1.7.4
REQUIRES          += net/openssl/1.0.2f
else
REQUIRES           = net/libpcap/1.7.4-x86_32
REQUIRES          += net/openssl/1.0.2f-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.7.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/tcpdump/tcpdump-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/tcpdump-$(version)
src_dir_name       = tcpdump-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TCPDUMP_PKG_NAME                = tcpdump
TCPDUMP_PKG_VERSION             = 4.7.4
TCPDUMP_PKG_ARCH                = $(TOOLCHAIN)
TCPDUMP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TCPDUMP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TCPDUMP_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
TCPDUMP_PKG_SHORT_DESCRIPTION   = network monitoring tool
TCPDUMP_PKG_URL                 = $(BUG_URL)
TCPDUMP_PKG_LICENSE             = BSD
TCPDUMP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TCPDUMP_PKG_NAME)-pkg-description
TCPDUMP_PKG_DESCRIPTION_FILE_IN = $(TCPDUMP_PKG_NAME)-pkg-description.in
TCPDUMP_PKG_INSTALL_SCRIPT      = $(TCPDUMP_PKG_NAME)-pkg-install.sh

TCPDUMP_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TCPDUMP_PKG_NAME)-package

pkg_basename     = $(TCPDUMP_PKG_NAME)-$(TCPDUMP_PKG_VERSION)-$(TCPDUMP_PKG_ARCH)-$(TCPDUMP_PKG_DISTRO_NAME)-$(TCPDUMP_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(TCPDUMP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-pcap=linux

tcpdump_environment = td_cv_buggygetaddrinfo=no PCAP_CONFIG=$(TARGET_DEST_DIR)/usr/bin/pcap-config


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(tcpdump_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TCPDUMP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(TCPDUMP_PKG)/usr/sbin ; \
	   rm -f tcpdump ; \
	   ln -sf tcpdump.$(version) tcpdump ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(TCPDUMP_PKG)/usr/share/man ]; then \
	  ( cd $(TCPDUMP_PKG)/usr/share/man ; \
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
	@mkdir -p $(TCPDUMP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CREDITS $(SRC_DIR)/LICENSE \
	       $(TCPDUMP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TCPDUMP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CREDITS INSTALL.txt LICENSE README* Readme* VERSION \
	         $(TCPDUMP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(TCPDUMP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TCPDUMP_PKG))
	# ======= Strip binaries =======
	@( cd $(TCPDUMP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(TCPDUMP_PKG)/usr/sbin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(TCPDUMP_PKG_DESCRIPTION_FILE): $(TCPDUMP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TCPDUMP_PKG_DESCRIPTION_FILE) $(TCPDUMP_PKG_INSTALL_SCRIPT)
	@cp $(TCPDUMP_PKG_DESCRIPTION_FILE) $(TCPDUMP_PKG)/.DESCRIPTION
	@cp $(TCPDUMP_PKG_INSTALL_SCRIPT) $(TCPDUMP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TCPDUMP_PKG)/.REQUIRES
	@echo "pkgname=$(TCPDUMP_PKG_NAME)"                            >  $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TCPDUMP_PKG_VERSION)"                          >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "arch=$(TCPDUMP_PKG_ARCH)"                               >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "distroname=$(TCPDUMP_PKG_DISTRO_NAME)"                  >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "distrover=$(TCPDUMP_PKG_DISTRO_VERSION)"                >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "group=$(TCPDUMP_PKG_GROUP)"                             >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TCPDUMP_PKG_SHORT_DESCRIPTION)\"" >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "url=$(TCPDUMP_PKG_URL)"                                 >> $(TCPDUMP_PKG)/.PKGINFO ; \
	 echo "license=$(TCPDUMP_PKG_LICENSE)"                         >> $(TCPDUMP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TCPDUMP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
