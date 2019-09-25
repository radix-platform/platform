
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


SOURCE_REQUIRES    = sources/packages/n/dhcp

REQUIRES           = net/iproute2/3.16.0

# ======= __END_OF_REQUIRES__ =======


version            = 4.3.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/dhcp/dhcp-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dhcp-$(version)
src_dir_name       = dhcp-$(version)
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
DHCP_PKG_NAME                = dhcp
DHCP_PKG_VERSION             = 4.3.1
DHCP_PKG_ARCH                = $(TOOLCHAIN)
DHCP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DHCP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DHCP_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
DHCP_PKG_SHORT_DESCRIPTION   = DHCP server and client utilities
DHCP_PKG_URL                 = $(BUG_URL)
DHCP_PKG_LICENSE             = custom
DHCP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DHCP_PKG_NAME)-pkg-description
DHCP_PKG_DESCRIPTION_FILE_IN = $(DHCP_PKG_NAME)-pkg-description.in
DHCP_PKG_INSTALL_SCRIPT      = $(DHCP_PKG_NAME)-pkg-install.sh

DHCP_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DHCP_PKG_NAME)-package

pkg_basename     = $(DHCP_PKG_NAME)-$(DHCP_PKG_VERSION)-$(DHCP_PKG_ARCH)-$(DHCP_PKG_DISTRO_NAME)-$(DHCP_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(DHCP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-srv-lease-file=/var/state/dhcp/dhcpd.leases
extra_configure_switches += --with-srv6-lease-file=/var/state/dhcp/dhcpd6.leases
extra_configure_switches += --with-cli-lease-file=/var/state/dhcp/dhclient.leases
extra_configure_switches += --with-cli6-lease-file=/var/state/dhcp/dhclient6.leases

extra_configure_switches += --cache-file=hw.cache


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	@(cd $(SRC_DIR)/bind ; tar xzf bind.tar.gz )
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	# ======= Fix paths in manual pages =======
	@( cd $(SRC_DIR) ; \
	   sed -i \
	       -e "s,ETCDIR,/etc,g"           \
	       -e "s,DBDIR,/var/state/dhcp,g" \
	       -e "s,RUNDIR,/var/run,g"       \
	       client/*.{5,8} \
	       server/*.{5,8} \
	       doc/*/*.{5,8}  \
	 )
	# ======= Define _GNU_SOURCE to fix IPV6 =======
	@( cd $(SRC_DIR) ; \
	   sed '/^CFLAGS="$CFLAGS/ s/INGS"/INGS -D_GNU_SOURCE"/' -i configure ; \
	 )
	# ======= make bind cross compilable =======
	@( cd $(SRC_DIR)/bind ; \
	   sed '/^[\t].*(cd $${bindsrcdir} && \.\/configure/ s,./configure,@BUILD_ENVIRONMENT@ ./configure --build=@BUILD@ --host=@TARGET@ --target=@TARGET@ --with-randomdev=/dev/random,' -i Makefile ; \
	   sed 's,@BUILD_ENVIRONMENT@,CC="$(CC) --sysroot=$(TARGET_DEST_DIR)" CFLAGS="$(CFLAGS)" AS="$(AS)" AR="$(AR)" BUILD_CC=gcc,g' -i Makefile ; \
	   sed "s/@BUILD@/$(BUILD)/g" -i Makefile ; \
	   sed "s/@TARGET@/$(TARGET)/g" -i Makefile ; \
	 )
	# ======= Set configure cache with /dev/random enable =======
	@echo "ac_cv_file__dev_random=yes" > $(SRC_DIR)/hw.cache
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DHCP_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= remove DHCP libraries =======
	@rm -rf $(DHCP_PKG)/usr/{include,lib$(LIBSUFFIX)}
	# ======= move DHCP client to /sbin =======
	@mkdir -p $(DHCP_PKG)/sbin
	@mv $(DHCP_PKG)/usr/sbin/dhclient $(DHCP_PKG)/sbin
	# ======= Install the dhcient-script for Linux =======
	@cat $(SRC_DIR)/client/scripts/linux > $(DHCP_PKG)/sbin/dhclient-script
	@chmod 700 $(DHCP_PKG)/sbin/dhclient-script
	# ======= Create the initial *.leases files =======
	@mkdir -p $(DHCP_PKG)/var/state/dhcp
	@touch $(DHCP_PKG)/var/state/dhcp/dhcpd.leases.new
	@touch $(DHCP_PKG)/var/state/dhcp/dhcpd6.leases.new
	@touch $(DHCP_PKG)/var/state/dhcp/dhclient.leases.new
	@touch $(DHCP_PKG)/var/state/dhcp/dhclient6.leases.new
	# ======= Install the initial dhcpd, dhcient config files =======
	@cp -a $(conf_dir)/dhcpd.conf $(DHCP_PKG)/etc/dhcpd.conf.new
	@cp -a $(conf_dir)/dhclient.conf $(DHCP_PKG)/etc/dhclient.conf.new
	# ======= Install Documentation =======
	@if [ -d $(DHCP_PKG)/usr/share/man ]; then \
	  ( cd $(DHCP_PKG)/usr/share/man ; \
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
	@mkdir -p $(DHCP_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(DHCP_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DHCP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README RELNOTES doc/examples doc/*.{html,txt} \
	         $(DHCP_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DHCP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DHCP_PKG))
	# ======= Strip binaries =======
	@( cd $(DHCP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DHCP_PKG_DESCRIPTION_FILE): $(DHCP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DHCP_PKG_DESCRIPTION_FILE) $(DHCP_PKG_INSTALL_SCRIPT)
	@cp $(DHCP_PKG_DESCRIPTION_FILE) $(DHCP_PKG)/.DESCRIPTION
	@cp $(DHCP_PKG_INSTALL_SCRIPT) $(DHCP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DHCP_PKG)/.REQUIRES
	@echo "pkgname=$(DHCP_PKG_NAME)"                            >  $(DHCP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DHCP_PKG_VERSION)"                          >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "arch=$(DHCP_PKG_ARCH)"                               >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "distroname=$(DHCP_PKG_DISTRO_NAME)"                  >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "distrover=$(DHCP_PKG_DISTRO_VERSION)"                >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "group=$(DHCP_PKG_GROUP)"                             >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DHCP_PKG_SHORT_DESCRIPTION)\"" >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "url=$(DHCP_PKG_URL)"                                 >> $(DHCP_PKG)/.PKGINFO ; \
	 echo "license=$(DHCP_PKG_LICENSE)"                         >> $(DHCP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DHCP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
