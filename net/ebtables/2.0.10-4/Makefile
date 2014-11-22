
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/ebtables

REQUIRES           = app/bash/4.3
REQUIRES          += dev/perl/5.18.2


version            = 2.0.10-4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/ebtables/ebtables-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ebtables-$(version)
src_dir_name       = ebtables-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EBTABLES_PKG_NAME                = ebtables
EBTABLES_PKG_VERSION             = 2.0.10-4
EBTABLES_PKG_ARCH                = $(TOOLCHAIN)
EBTABLES_PKG_DISTRO_NAME         = $(DISTRO_NAME)
EBTABLES_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
EBTABLES_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
EBTABLES_PKG_SHORT_DESCRIPTION   = Ethernet frame filtering on a Linux bridge
EBTABLES_PKG_URL                 = $(BUG_URL)
EBTABLES_PKG_LICENSE             = GPLv2
EBTABLES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EBTABLES_PKG_NAME)-pkg-description
EBTABLES_PKG_DESCRIPTION_FILE_IN = $(EBTABLES_PKG_NAME)-pkg-description.in
EBTABLES_PKG_INSTALL_SCRIPT      = $(EBTABLES_PKG_NAME)-pkg-install.sh

EBTABLES_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EBTABLES_PKG_NAME)-package

pkg_basename     = $(EBTABLES_PKG_NAME)-$(EBTABLES_PKG_VERSION)-$(EBTABLES_PKG_ARCH)-$(EBTABLES_PKG_DISTRO_NAME)-$(EBTABLES_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(EBTABLES_PKG)

configure_switches  = LIBDIR=/usr/lib$(LIBSUFFIX)
configure_switches += MANDIR=/usr/share/man
configure_switches += BINDIR=/usr/sbin
configure_switches += ETCDIR=/etc
configure_switches += INITDIR=/etc/rc.d/init.d
configure_switches += SYSCONFIGDIR=/etc/sysconfig

#
# Do not use KERNEL_INCLUDES for old kernels which doesn't have IPv6
#
ifeq ($(filter $(HARDWARE),$(HARDWARE_VIP1830) $(HARDWARE_BEAGLE) $(HARDWARE_B74)),)
configure_switches += KERNEL_INCLUDES=$(TARGET_DEST_DIR)/usr/include
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_switches)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(EBTABLES_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(configure_switches) $(env_sysroot)
	@mv $(EBTABLES_PKG)/etc/ethertypes $(EBTABLES_PKG)/etc/ethertypes.new
	# ======= Remove Red Hat junk =======
	@rm -rf $(EBTABLES_PKG)/etc/rc.d $(EBTABLES_PKG)/etc/sysconfig
	# ======= Install Documentation =======
	@if [ -d $(EBTABLES_PKG)/usr/share/man ]; then \
	  ( cd $(EBTABLES_PKG)/usr/share/man ; \
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
	@mkdir -p $(EBTABLES_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(EBTABLES_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(EBTABLES_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL THANKS \
	         $(EBTABLES_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(EBTABLES_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EBTABLES_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(EBTABLES_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(EBTABLES_PKG_DESCRIPTION_FILE): $(EBTABLES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(EBTABLES_PKG_DESCRIPTION_FILE) $(EBTABLES_PKG_INSTALL_SCRIPT)
	@cp $(EBTABLES_PKG_DESCRIPTION_FILE) $(EBTABLES_PKG)/.DESCRIPTION
	@cp $(EBTABLES_PKG_INSTALL_SCRIPT) $(EBTABLES_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EBTABLES_PKG)/.REQUIRES
	@echo "pkgname=$(EBTABLES_PKG_NAME)"                            >  $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EBTABLES_PKG_VERSION)"                          >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "arch=$(EBTABLES_PKG_ARCH)"                               >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "distroname=$(EBTABLES_PKG_DISTRO_NAME)"                  >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "distrover=$(EBTABLES_PKG_DISTRO_VERSION)"                >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "group=$(EBTABLES_PKG_GROUP)"                             >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EBTABLES_PKG_SHORT_DESCRIPTION)\"" >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "url=$(EBTABLES_PKG_URL)"                                 >> $(EBTABLES_PKG)/.PKGINFO ; \
	 echo "license=$(EBTABLES_PKG_LICENSE)"                         >> $(EBTABLES_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EBTABLES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
