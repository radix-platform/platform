
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
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


SOURCE_REQUIRES    = sources/packages/n/iptables

REQUIRES           = net/nfacct/1.0.1
ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES          += net/libpcap/1.7.4
REQUIRES          += net/libnetfilter_conntrack/1.0.5
REQUIRES          += net/libnftnl/1.0.5
else
REQUIRES          += net/libpcap/1.7.4-x86_32
REQUIRES          += net/libnetfilter_conntrack/1.0.5-x86_32
REQUIRES          += net/libnftnl/1.0.5-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/iptables/iptables-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/iptables-$(version)
src_dir_name       = iptables-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IPTABLES_PKG_NAME                = iptables
IPTABLES_PKG_VERSION             = 1.6.0
IPTABLES_PKG_ARCH                = $(TOOLCHAIN)
IPTABLES_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPTABLES_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPTABLES_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
IPTABLES_PKG_SHORT_DESCRIPTION   = IP packet filter administration tool
IPTABLES_PKG_URL                 = $(BUG_URL)
IPTABLES_PKG_LICENSE             = GPLv2
IPTABLES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPTABLES_PKG_NAME)-pkg-description
IPTABLES_PKG_DESCRIPTION_FILE_IN = $(IPTABLES_PKG_NAME)-pkg-description.in
IPTABLES_PKG_INSTALL_SCRIPT      = $(IPTABLES_PKG_NAME)-pkg-install.sh

IPTABLES_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPTABLES_PKG_NAME)-package

pkg_basename     = $(IPTABLES_PKG_NAME)-$(IPTABLES_PKG_VERSION)-$(IPTABLES_PKG_ARCH)-$(IPTABLES_PKG_DISTRO_NAME)-$(IPTABLES_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(IPTABLES_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-ipv4
extra_configure_switches += --enable-ipv6
extra_configure_switches += --enable-devel
extra_configure_switches += --enable-libipq
extra_configure_switches += --enable-bpf-compiler
extra_configure_switches += --enable-nfsynproxy
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= fix issue with finding libnetfilter_conntrack =======
	@( cd $(SRC_DIR)/iptables ; \
	   sed -i "/^LIBS =/ s/$$/ -lnetfilter_conntrack/" Makefile ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IPTABLES_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@( cd $(IPTABLES_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@( cd $(IPTABLES_PKG)/usr/share/man/man8 ; \
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
	@if [ -d $(IPTABLES_PKG)/usr/share/man ]; then \
	  ( cd $(IPTABLES_PKG)/usr/share/man ; \
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
	@mkdir -p $(IPTABLES_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(IPTABLES_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IPTABLES_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INCOMPATIBILITIES INSTALL \
	         $(IPTABLES_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IPTABLES_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IPTABLES_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libip4tc.la libip6tc.la libipq.la libiptc.la libxtables.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IPTABLES_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libip4tc.la libip6tc.la libipq.la libiptc.la libxtables.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libip4tc.la libip6tc.la libipq.la libiptc.la libxtables.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libip4tc.pc libip6tc.pc libipq.pc libiptc.pc xtables.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IPTABLES_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(IPTABLES_PKG)/usr/sbin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IPTABLES_PKG_DESCRIPTION_FILE): $(IPTABLES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPTABLES_PKG_DESCRIPTION_FILE) $(IPTABLES_PKG_INSTALL_SCRIPT)
	@cp $(IPTABLES_PKG_DESCRIPTION_FILE) $(IPTABLES_PKG)/.DESCRIPTION
	@cp $(IPTABLES_PKG_INSTALL_SCRIPT) $(IPTABLES_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPTABLES_PKG)/.REQUIRES
	@echo "pkgname=$(IPTABLES_PKG_NAME)"                            >  $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPTABLES_PKG_VERSION)"                          >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "arch=$(IPTABLES_PKG_ARCH)"                               >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPTABLES_PKG_DISTRO_NAME)"                  >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPTABLES_PKG_DISTRO_VERSION)"                >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "group=$(IPTABLES_PKG_GROUP)"                             >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPTABLES_PKG_SHORT_DESCRIPTION)\"" >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "url=$(IPTABLES_PKG_URL)"                                 >> $(IPTABLES_PKG)/.PKGINFO ; \
	 echo "license=$(IPTABLES_PKG_LICENSE)"                         >> $(IPTABLES_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IPTABLES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
