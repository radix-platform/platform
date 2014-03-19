
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/CLooG


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
REQUIRES           = app/cloog/0.18.2-x86_32
else
REQUIRES           = libs/gmp/5.1.3
endif

version            = 0.18.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/CLooG/cloog-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cloog-$(version)
src_dir_name       = cloog-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_cloog_pkg    = $(TARGET_BUILD_DIR)/.cloog_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CLOOG_PKG_NAME                = cloog
CLOOG_PKG_VERSION             = 0.18.2
CLOOG_PKG_ARCH                = $(TOOLCHAIN)
CLOOG_PKG_DISTRO_NAME         = kxLab
CLOOG_PKG_DISTRO_VERSION      = 1.0
CLOOG_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CLOOG_PKG_SHORT_DESCRIPTION   = cloog $(version)
CLOOG_PKG_URL                 = http://www.kxLab.com
CLOOG_PKG_LICENSE             = GPLv2
CLOOG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CLOOG_PKG_NAME)-pkg-description
CLOOG_PKG_DESCRIPTION_FILE_IN = $(CLOOG_PKG_NAME)-pkg-description.in
CLOOG_PKG_INSTALL_SCRIPT      = $(CLOOG_PKG_NAME)-pkg-install.sh

CLOOG_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CLOOG_PKG_NAME)-package

pkg_basename     = $(CLOOG_PKG_NAME)-$(CLOOG_PKG_VERSION)-$(CLOOG_PKG_ARCH)-$(CLOOG_PKG_DISTRO_NAME)-$(CLOOG_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(CLOOG_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_cloog_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(CLOOG_PKG)


OPTIMIZATION_FLAGS = -O3


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-bits=gmp
extra_configure_switches += --with-gmp=system
extra_configure_switches += --with-isl=bundled
extra_configure_switches += --with-osl=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes



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
	@mkdir -p $(CLOOG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(CLOOG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/README \
	       $(CLOOG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CLOOG_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CLOOG_HEAD $(SRC_DIR)/README $(SRC_DIR)/doc/TODO $(SRC_DIR)/doc/cloog.pdf \
	       $(CLOOG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CLOOG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove toolchain path from target libtool *.la files
	@( cd $(CLOOG_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,-L/lib,,g" libcloog-isl.la ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libcloog-isl.la libisl.la \
	 )
	# remove toolchain path from target pkg-config *.pc files
	@( cd $(CLOOG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,-L/lib,,g" cloog-isl.pc ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" cloog-isl.pc isl.pc \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(CLOOG_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcloog-isl.la libisl.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcloog-isl.la libisl.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cloog-isl.pc isl.pc ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cloog-isl.pc isl.pc \
	 )
	@(cd $(CLOOG_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CLOOG_PKG_DESCRIPTION_FILE): $(CLOOG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_cloog_pkg): $(install_target) $(CLOOG_PKG_DESCRIPTION_FILE)
	@cp $(CLOOG_PKG_DESCRIPTION_FILE) $(CLOOG_PKG)/.DESCRIPTION
	@cp $(CLOOG_PKG_INSTALL_SCRIPT) $(CLOOG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CLOOG_PKG)/.REQUIRES
	@echo "pkgname=$(CLOOG_PKG_NAME)"                            >  $(CLOOG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CLOOG_PKG_VERSION)"                          >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "arch=$(CLOOG_PKG_ARCH)"                               >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "distroname=$(CLOOG_PKG_DISTRO_NAME)"                  >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "distrover=$(CLOOG_PKG_DISTRO_VERSION)"                >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "group=$(CLOOG_PKG_GROUP)"                             >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CLOOG_PKG_SHORT_DESCRIPTION)\"" >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "url=$(CLOOG_PKG_URL)"                                 >> $(CLOOG_PKG)/.PKGINFO ; \
	 echo "license=$(CLOOG_PKG_LICENSE)"                         >> $(CLOOG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CLOOG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
