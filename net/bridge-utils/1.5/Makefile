
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/bridge-utils

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.22
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/bridge-utils/bridge-utils-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bridge-utils-$(version)
src_dir_name       = bridge-utils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BRCTL_PKG_NAME                = bridge-utils
BRCTL_PKG_VERSION             = 1.5
BRCTL_PKG_ARCH                = $(TOOLCHAIN)
BRCTL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BRCTL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BRCTL_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
BRCTL_PKG_SHORT_DESCRIPTION   = network Ethernet bridging utilities
BRCTL_PKG_URL                 = $(BUG_URL)
BRCTL_PKG_LICENSE             = GPLv2
BRCTL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BRCTL_PKG_NAME)-pkg-description
BRCTL_PKG_DESCRIPTION_FILE_IN = $(BRCTL_PKG_NAME)-pkg-description.in
BRCTL_PKG_INSTALL_SCRIPT      = $(BRCTL_PKG_NAME)-pkg-install.sh

BRCTL_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BRCTL_PKG_NAME)-package

pkg_basename     = $(BRCTL_PKG_NAME)-$(BRCTL_PKG_VERSION)-$(BRCTL_PKG_ARCH)-$(BRCTL_PKG_DISTRO_NAME)-$(BRCTL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(BRCTL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --with-linux-headers=$(TARGET_DEST_DIR)/usr/include


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   autoreconf -i ; rm -rf autom4te.cache )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BRCTL_PKG)/usr/lib$(LIBSUFFIX)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install libbridge.a =======
	@cp -a $(SRC_DIR)/libbridge/libbridge.a $(BRCTL_PKG)/usr/lib$(LIBSUFFIX)
	@mkdir -p $(BRCTL_PKG)/sbin
	@mv $(BRCTL_PKG)/usr/sbin/brctl $(BRCTL_PKG)/sbin/brctl
	@( cd $(BRCTL_PKG)/usr/sbin ; ln -sf ../../sbin/brctl brctl )
	# ======= Install Documentation =======
	@if [ -d $(BRCTL_PKG)/usr/share/man ]; then \
	  ( cd $(BRCTL_PKG)/usr/share/man ; \
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
	@mkdir -p $(BRCTL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(BRCTL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BRCTL_PKG)/usr/share/doc/$(src_dir_name)/doc
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README THANKS TODO \
	         $(BRCTL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a doc/{FAQ,FIREWALL,HOWTO,PROJECTS,SMPNOTES,WISHLIST} \
	         $(BRCTL_PKG)/usr/share/doc/$(src_dir_name)/doc ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BRCTL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BRCTL_PKG))
	# ======= Strip binaries =======
	@( cd $(BRCTL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BRCTL_PKG_DESCRIPTION_FILE): $(BRCTL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BRCTL_PKG_DESCRIPTION_FILE) $(BRCTL_PKG_INSTALL_SCRIPT)
	@cp $(BRCTL_PKG_DESCRIPTION_FILE) $(BRCTL_PKG)/.DESCRIPTION
	@cp $(BRCTL_PKG_INSTALL_SCRIPT) $(BRCTL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BRCTL_PKG)/.REQUIRES
	@echo "pkgname=$(BRCTL_PKG_NAME)"                            >  $(BRCTL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BRCTL_PKG_VERSION)"                          >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "arch=$(BRCTL_PKG_ARCH)"                               >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "distroname=$(BRCTL_PKG_DISTRO_NAME)"                  >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "distrover=$(BRCTL_PKG_DISTRO_VERSION)"                >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "group=$(BRCTL_PKG_GROUP)"                             >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BRCTL_PKG_SHORT_DESCRIPTION)\"" >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "url=$(BRCTL_PKG_URL)"                                 >> $(BRCTL_PKG)/.PKGINFO ; \
	 echo "license=$(BRCTL_PKG_LICENSE)"                         >> $(BRCTL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BRCTL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
