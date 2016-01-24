
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/whois

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/libidn/1.28
else
REQUIRES           = libs/libidn/1.28-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 5.2.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/whois/whois-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/whois-$(version)
src_dir_name       = whois-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
WHOIS_PKG_NAME                = whois
WHOIS_PKG_VERSION             = 5.2.1
WHOIS_PKG_ARCH                = $(TOOLCHAIN)
WHOIS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
WHOIS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
WHOIS_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
WHOIS_PKG_SHORT_DESCRIPTION   = whois directory client
WHOIS_PKG_URL                 = $(BUG_URL)
WHOIS_PKG_LICENSE             = GPLv2
WHOIS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(WHOIS_PKG_NAME)-pkg-description
WHOIS_PKG_DESCRIPTION_FILE_IN = $(WHOIS_PKG_NAME)-pkg-description.in
WHOIS_PKG_INSTALL_SCRIPT      = $(WHOIS_PKG_NAME)-pkg-install.sh

WHOIS_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(WHOIS_PKG_NAME)-package

pkg_basename     = $(WHOIS_PKG_NAME)-$(WHOIS_PKG_VERSION)-$(WHOIS_PKG_ARCH)-$(WHOIS_PKG_DISTRO_NAME)-$(WHOIS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = BASEDIR=$(WHOIS_PKG)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) HAVE_LIBIDN=y
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(WHOIS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install install-pos $(env_sysroot)
	# ======= remove mkpasswd stuff =======
	@find $(WHOIS_PKG) -iname "mkpasswd*" -exec rm -f {} \;
	# ======= Install Documentation =======
	@if [ -d $(WHOIS_PKG)/usr/share/man ]; then \
	  ( cd $(WHOIS_PKG)/usr/share/man ; \
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
	@mkdir -p $(WHOIS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(WHOIS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(WHOIS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(WHOIS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(WHOIS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(WHOIS_PKG))
	# ======= Strip binaries =======
	@( cd $(WHOIS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(WHOIS_PKG_DESCRIPTION_FILE): $(WHOIS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(WHOIS_PKG_DESCRIPTION_FILE) $(WHOIS_PKG_INSTALL_SCRIPT)
	@cp $(WHOIS_PKG_DESCRIPTION_FILE) $(WHOIS_PKG)/.DESCRIPTION
	@cp $(WHOIS_PKG_INSTALL_SCRIPT) $(WHOIS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(WHOIS_PKG)/.REQUIRES
	@echo "pkgname=$(WHOIS_PKG_NAME)"                            >  $(WHOIS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(WHOIS_PKG_VERSION)"                          >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "arch=$(WHOIS_PKG_ARCH)"                               >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "distroname=$(WHOIS_PKG_DISTRO_NAME)"                  >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "distrover=$(WHOIS_PKG_DISTRO_VERSION)"                >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "group=$(WHOIS_PKG_GROUP)"                             >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(WHOIS_PKG_SHORT_DESCRIPTION)\"" >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "url=$(WHOIS_PKG_URL)"                                 >> $(WHOIS_PKG)/.PKGINFO ; \
	 echo "license=$(WHOIS_PKG_LICENSE)"                         >> $(WHOIS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(WHOIS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
