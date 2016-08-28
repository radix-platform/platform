
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/mozilla-nspr

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.23
else
REQUIRES           = libs/glibc/2.23-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 4.12
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/mozilla-nspr/nspr-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/nspr-$(version)
src_dir_name       = nspr-$(version)
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
NSPR_PKG_NAME                = nspr
NSPR_PKG_VERSION             = 4.12
NSPR_PKG_ARCH                = $(TOOLCHAIN)
NSPR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NSPR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NSPR_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
NSPR_PKG_SHORT_DESCRIPTION   = Netscape Portable Runtime
NSPR_PKG_URL                 = $(BUG_URL)
NSPR_PKG_LICENSE             = MPLv2
NSPR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NSPR_PKG_NAME)-pkg-description
NSPR_PKG_DESCRIPTION_FILE_IN = $(NSPR_PKG_NAME)-pkg-description.in
NSPR_PKG_INSTALL_SCRIPT      = $(NSPR_PKG_NAME)-pkg-install.sh

NSPR_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NSPR_PKG_NAME)-package

pkg_basename     = $(NSPR_PKG_NAME)-$(NSPR_PKG_VERSION)-$(NSPR_PKG_ARCH)-$(NSPR_PKG_DISTRO_NAME)-$(NSPR_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(NSPR_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-strip=no

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
extra_configure_switches += --enable-64bit=yes
endif

extra_configure_switches += --enable-ipv6
extra_configure_switches += --with-mozilla
extra_configure_switches += --with-pthreads

nspr_environment  = HOST_CC=gcc
nspr_environment += HOST_CFLAGS="-I. -I/usr/include -g -O2"
nspr_environment += HOST_LDFLAGS=


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(nspr_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(nspr_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(NSPR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(NSPR_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(NSPR_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NSPR_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE \
	         $(NSPR_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NSPR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove executable attribute of static libraries =======
	@( cd $(NSPR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod a-x *.a ; \
	 )
	@( cd $(NSPR_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   ln -sf nspr.pc mozilla-nspr.pc ; \
	 )
	# ======= tune nspr-config for target system =======
	@( cd $(NSPR_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" nspr-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NSPR_PKG))
	# ======= tune nspr-config to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"     nspr-config ; \
	   sed -i "s,-L/lib,-L$(TARGET_DEST_DIR)/lib,g" nspr-config ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" nspr.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(NSPR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NSPR_PKG_DESCRIPTION_FILE): $(NSPR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NSPR_PKG_DESCRIPTION_FILE) $(NSPR_PKG_INSTALL_SCRIPT)
	@cp $(NSPR_PKG_DESCRIPTION_FILE) $(NSPR_PKG)/.DESCRIPTION
	@cp $(NSPR_PKG_INSTALL_SCRIPT) $(NSPR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NSPR_PKG)/.REQUIRES
	@echo "pkgname=$(NSPR_PKG_NAME)"                            >  $(NSPR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NSPR_PKG_VERSION)"                          >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "arch=$(NSPR_PKG_ARCH)"                               >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "distroname=$(NSPR_PKG_DISTRO_NAME)"                  >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "distrover=$(NSPR_PKG_DISTRO_VERSION)"                >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "group=$(NSPR_PKG_GROUP)"                             >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NSPR_PKG_SHORT_DESCRIPTION)\"" >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "url=$(NSPR_PKG_URL)"                                 >> $(NSPR_PKG)/.PKGINFO ; \
	 echo "license=$(NSPR_PKG_LICENSE)"                         >> $(NSPR_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(NSPR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
