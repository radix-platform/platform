
COMPONENT_TARGETS += $(TARGET_PC32)
COMPONENT_TARGETS += $(TARGET_PC64)
COMPONENT_TARGETS += $(TARGET_CB1X)
COMPONENT_TARGETS += $(TARGET_VIP1830)
COMPONENT_TARGETS += $(TARGET_BEAGLE)
COMPONENT_TARGETS += $(TARGET_OMAP5UEVM)
COMPONENT_TARGETS += $(TARGET_B74)

#
# The rest targets links staticaly with newlib or uclibc and not requires xz libraties
#
# COMPONENT_TARGETS += $(TARGET_CB1N)
# COMPONENT_TARGETS += $(TARGET_GUARD)
# COMPONENT_TARGETS += $(TARGET_VIP1830N)
# COMPONENT_TARGETS += $(TARGET_L17UC)
#


NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/popt


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
REQUIRES           = libs/popt/1.16-x86_32
else
REQUIRES           = libs/eglibc/2.18.1
endif

version            = 1.16
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/popt/popt-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/popt-$(version)
src_dir_name       = popt-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_popt_pkg     = $(TARGET_BUILD_DIR)/.popt_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
POPT_PKG_NAME                = popt
POPT_PKG_VERSION             = 1.16
POPT_PKG_ARCH                = $(TOOLCHAIN)
POPT_PKG_DISTRO_NAME         = kxLab
POPT_PKG_DISTRO_VERSION      = 1.0
POPT_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
POPT_PKG_SHORT_DESCRIPTION   = popt $(version)
POPT_PKG_URL                 = http://www.kxLab.com
POPT_PKG_LICENSE             = GPLv2
POPT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(POPT_PKG_NAME)-pkg-description
POPT_PKG_DESCRIPTION_FILE_IN = $(POPT_PKG_NAME)-pkg-description.in
POPT_PKG_INSTALL_SCRIPT      = $(POPT_PKG_NAME)-pkg-install.sh

POPT_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(POPT_PKG_NAME)-package

pkg_basename     = $(POPT_PKG_NAME)-$(POPT_PKG_VERSION)-$(POPT_PKG_ARCH)-$(POPT_PKG_DISTRO_NAME)-$(POPT_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(POPT_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_popt_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(POPT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(POPT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(POPT_PKG)/lib$(LIBSUFFIX)
	@( cd $(POPT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	  done ; \
	  cp -a lib*.so.? ../../lib$(LIBSUFFIX) \
	 )
	@( if [ ! -z "$(LIBSUFFIX)" ] ; then \
	     cd $(POPT_PKG)/usr ; \
	     mv lib/pkgconfig lib$(LIBSUFFIX) ; \
	     rm -rf lib ; \
	   fi \
	 )
	@if [ -d $(POPT_PKG)/usr/share/man ]; then \
	  ( cd $(POPT_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(POPT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(POPT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(POPT_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CHANGES $(SRC_DIR)/COPYING $(SRC_DIR)/README \
	       $(POPT_PKG)/usr/share/doc/$(src_dir_name)
	# remove toolchain path from target libtool *.la files and
	@( cd $(POPT_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libpopt.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(POPT_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpopt.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpopt.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" popt.pc \
	 )
	@(cd $(POPT_PKG); \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(POPT_PKG_DESCRIPTION_FILE): $(POPT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_popt_pkg): $(install_target) $(POPT_PKG_DESCRIPTION_FILE)
	@cp $(POPT_PKG_DESCRIPTION_FILE) $(POPT_PKG)/.DESCRIPTION
	@cp $(POPT_PKG_INSTALL_SCRIPT) $(POPT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(POPT_PKG)/.REQUIRES
	@echo "pkgname=$(POPT_PKG_NAME)"                            >  $(POPT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(POPT_PKG_VERSION)"                          >> $(POPT_PKG)/.PKGINFO ; \
	 echo "arch=$(POPT_PKG_ARCH)"                               >> $(POPT_PKG)/.PKGINFO ; \
	 echo "distroname=$(POPT_PKG_DISTRO_NAME)"                  >> $(POPT_PKG)/.PKGINFO ; \
	 echo "distrover=$(POPT_PKG_DISTRO_VERSION)"                >> $(POPT_PKG)/.PKGINFO ; \
	 echo "group=$(POPT_PKG_GROUP)"                             >> $(POPT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(POPT_PKG_SHORT_DESCRIPTION)\"" >> $(POPT_PKG)/.PKGINFO ; \
	 echo "url=$(POPT_PKG_URL)"                                 >> $(POPT_PKG)/.PKGINFO ; \
	 echo "license=$(POPT_PKG_LICENSE)"                         >> $(POPT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(POPT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
