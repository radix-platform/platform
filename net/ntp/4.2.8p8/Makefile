
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


SOURCE_REQUIRES    = sources/packages/n/ntp

REQUIRES           = secure/libcap/2.27
REQUIRES          += net/openssl/1.1.1d
REQUIRES          += net/net-snmp/5.7.3
REQUIRES          += net/net-snmp/5.7.3
REQUIRES          += net/libnl3/3.2.27
REQUIRES          += libs/libevent/2.1.11
REQUIRES          += app/lm_sensors/3.4.0
REQUIRES          += dev/perl/5.30.0

# ======= __END_OF_REQUIRES__ =======


version            = 4.2.8p8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/ntp/ntp-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ntp-$(version)
src_dir_name       = ntp-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

conf_dir           = $(CURDIR)/etc


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
NTP_PKG_NAME                = ntp
NTP_PKG_VERSION             = 4.2.8p8
NTP_PKG_ARCH                = $(TOOLCHAIN)
NTP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NTP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NTP_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
NTP_PKG_SHORT_DESCRIPTION   = Network Time Protocol daemon
NTP_PKG_URL                 = $(BUG_URL)
NTP_PKG_LICENSE             = custom
NTP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NTP_PKG_NAME)-pkg-description
NTP_PKG_DESCRIPTION_FILE_IN = $(NTP_PKG_NAME)-pkg-description.in
NTP_PKG_INSTALL_SCRIPT      = $(NTP_PKG_NAME)-pkg-install.sh

NTP_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NTP_PKG_NAME)-package

pkg_basename     = $(NTP_PKG_NAME)-$(NTP_PKG_VERSION)-$(NTP_PKG_ARCH)-$(NTP_PKG_DISTRO_NAME)-$(NTP_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(NTP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --htmldir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/sbin
extra_configure_switches += --sbindir=/usr/sbin

extra_configure_switches += --enable-linuxcaps
extra_configure_switches += --enable-ntp-signd

extra_configure_switches += --with-yielding-select=yes

extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-crypto

extra_configure_switches += --with-net-snmp-config=$(TARGET_DEST_DIR)/usr/bin/net-snmp-config

extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=


#
# Global Variables:
# ================
#   ARCH        - defined in dev/perl/5.22.1/Makefile
#
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH            = x86_32
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH            = x86_64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB2X) $(HARDWARE_CB3X)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_M201)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_MXV)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH            = aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_NIT6Q)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
ARCH            = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
ARCH            = mips32r2
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BAIKAL_T1)),)
ARCH            = mips32r5
endif

ARCHNAME = $(ARCH)-linux


CFLAGS += -Wno-strict-overflow


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= Add extra Perl5 CPP, LD flags =======
	@( cd $(SRC_DIR) ; \
	   for file in `find . -name "Makefile"` ; do \
	     if [ -n "`cat $$file | grep SNMP_LIBS`" ] ; then \
	       sed -i "s,^\(SNMP_CPPFLAGS =.*\),\1 -I$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/perl5/arm-linux/CORE," $$file ; \
	       sed -i "s#^\(SNMP_LIBS =.*/usr/lib$(LIBSUFFIX) \)#\1-Wl,-E -Wl,-rpath,/usr/lib$(LIBSUFFIX)/perl5/$(ARCHNAME)/CORE #" $$file ; \
	     fi ; \
	   done ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NTP_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= remove empty && unneeded dirs =======
	@rm -rf $(NTP_PKG)/usr/share/man/man8
	@rm -rf $(NTP_PKG)/usr/libexec
	# ======= Install the initial ntpd config files and scripts =======
	@mkdir -p $(NTP_PKG)/etc/{ntp,rc.d}
	@cp -a $(conf_dir)/ntp.conf     $(NTP_PKG)/etc/ntp.conf.new
	@cp -a $(conf_dir)/ntp/ntp.keys $(NTP_PKG)/etc/ntp/ntp.keys.new
	@chmod 600 $(NTP_PKG)/etc/ntp/ntp.keys.new
	@cat $(conf_dir)/rc.d/rc.ntpd > $(NTP_PKG)/etc/rc.d/rc.ntpd.new
	@chmod 644 $(NTP_PKG)/etc/rc.d/rc.ntpd.new
	@touch $(NTP_PKG)/etc/ntp/step-tickers
	# ======= Install Documentation =======
	@if [ -d $(NTP_PKG)/usr/share/man ]; then \
	  ( cd $(NTP_PKG)/usr/share/man ; \
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
	@mkdir -p $(NTP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYRIGHT \
	       $(NTP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NTP_PKG)/usr/share/doc/$(src_dir_name)/{util,ntpdate}
	@( cd $(SRC_DIR) ; \
	   cp -a COPYRIGHT NEWS README* TODO WHERE-TO-START *.y2kfixes \
	         $(NTP_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a util/README    $(NTP_PKG)/usr/share/doc/$(src_dir_name)/util    ; \
	   cp -a ntpdate/README $(NTP_PKG)/usr/share/doc/$(src_dir_name)/ntpdate ; \
	 )
	@mkdir -p $(NTP_PKG)/usr/share/doc/$(src_dir_name)/{clockstuff,scripts}
	@( cd $(SRC_DIR) ; \
	   cp -a clockstuff/README clockstuff/propdelay \
	         $(NTP_PKG)/usr/share/doc/$(src_dir_name)/clockstuff ; \
	   cp -a conf \
	         $(NTP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/scripts ; \
	   cp -a stats rc monitoring \
	         $(NTP_PKG)/usr/share/doc/$(src_dir_name)/scripts ; \
	 )
	@mkdir -p $(NTP_PKG)/usr/share/doc/$(src_dir_name)/scripts/ntpsweep
	@( cd $(SRC_DIR)/scripts/ntpsweep ; \
	   cp -a ntpsweep ntpsweep.{1,html} \
	         $(NTP_PKG)/usr/share/doc/$(src_dir_name)/scripts/ntpsweep ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NTP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NTP_PKG))
	# ======= Strip binaries =======
	@( cd $(NTP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(NTP_PKG)/usr/sbin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH" | cut -f2 -d'='` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       rpath=`echo $$rpath | sed "s,$(TARGET_DEST_DIR),,g"` ; \
	       $(CHRPATH) -r $$rpath $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(NTP_PKG_DESCRIPTION_FILE): $(NTP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NTP_PKG_DESCRIPTION_FILE) $(NTP_PKG_INSTALL_SCRIPT)
	@cp $(NTP_PKG_DESCRIPTION_FILE) $(NTP_PKG)/.DESCRIPTION
	@cp $(NTP_PKG_INSTALL_SCRIPT) $(NTP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NTP_PKG)/.REQUIRES
	@echo "pkgname=$(NTP_PKG_NAME)"                            >  $(NTP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NTP_PKG_VERSION)"                          >> $(NTP_PKG)/.PKGINFO ; \
	 echo "arch=$(NTP_PKG_ARCH)"                               >> $(NTP_PKG)/.PKGINFO ; \
	 echo "distroname=$(NTP_PKG_DISTRO_NAME)"                  >> $(NTP_PKG)/.PKGINFO ; \
	 echo "distrover=$(NTP_PKG_DISTRO_VERSION)"                >> $(NTP_PKG)/.PKGINFO ; \
	 echo "group=$(NTP_PKG_GROUP)"                             >> $(NTP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NTP_PKG_SHORT_DESCRIPTION)\"" >> $(NTP_PKG)/.PKGINFO ; \
	 echo "url=$(NTP_PKG_URL)"                                 >> $(NTP_PKG)/.PKGINFO ; \
	 echo "license=$(NTP_PKG_LICENSE)"                         >> $(NTP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NTP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
