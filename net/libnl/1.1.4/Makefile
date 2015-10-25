
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/libnl

REQUIRES           = dev/gcc/4.9.2
#
# NOTE:
# ----
#   If gcc-runtime used instead of gcc then we have to declare
#   GNU Libc dependencies in the following way:
#
#   REQUIRES           = libs/glibc/2.21
#   ifeq ($(HARDWARE),$(HARDWARE_PC64))
#   REQUIRES          += libs/glibc/2.21-x86_32
#   endif
#

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/libnl/libnl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libnl-$(version)
src_dir_name       = libnl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBNL_PKG_NAME                = libnl
LIBNL_PKG_VERSION             = 1.1.4
LIBNL_PKG_ARCH                = $(TOOLCHAIN)
LIBNL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNL_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
LIBNL_PKG_SHORT_DESCRIPTION   = netlink socket library
LIBNL_PKG_URL                 = $(BUG_URL)
LIBNL_PKG_LICENSE             = LGPLv2.1
LIBNL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNL_PKG_NAME)-pkg-description
LIBNL_PKG_DESCRIPTION_FILE_IN = $(LIBNL_PKG_NAME)-pkg-description.in
LIBNL_PKG_INSTALL_SCRIPT      = $(LIBNL_PKG_NAME)-pkg-install.sh

LIBNL_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNL_PKG_NAME)-package

pkg_basename     = $(LIBNL_PKG_NAME)-$(LIBNL_PKG_VERSION)-$(LIBNL_PKG_ARCH)-$(LIBNL_PKG_DISTRO_NAME)-$(LIBNL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


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
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) gendoc
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBNL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBNL_PKG)/usr/share/man ]; then \
	  ( cd $(LIBNL_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBNL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBNL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBNL_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/README \
	       $(LIBNL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR)/doc ; \
	   cp -a html \
	         $(LIBNL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBNL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNL_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnl-1.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBNL_PKG_DESCRIPTION_FILE): $(LIBNL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNL_PKG_DESCRIPTION_FILE) $(LIBNL_PKG_INSTALL_SCRIPT)
	@cp $(LIBNL_PKG_DESCRIPTION_FILE) $(LIBNL_PKG)/.DESCRIPTION
	@cp $(LIBNL_PKG_INSTALL_SCRIPT) $(LIBNL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNL_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNL_PKG_NAME)"                            >  $(LIBNL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNL_PKG_VERSION)"                          >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNL_PKG_ARCH)"                               >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNL_PKG_DISTRO_NAME)"                  >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNL_PKG_DISTRO_VERSION)"                >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNL_PKG_GROUP)"                             >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNL_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNL_PKG_URL)"                                 >> $(LIBNL_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNL_PKG_LICENSE)"                         >> $(LIBNL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBNL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
