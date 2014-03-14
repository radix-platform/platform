
COMPONENT_TARGETS  = $(TARGET_HOST)
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/ppl


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = libs/ppl/1.1-x86_32
else
REQUIRES           = libs/gmp/5.1.3
endif

version            = 1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/ppl/ppl-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ppl-$(version)
src_dir_name       = ppl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_ppl_pkg      = $(TARGET_BUILD_DIR)/.ppl_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PPL_PKG_NAME                = ppl
PPL_PKG_VERSION             = 1.1
ifeq ($(HARDWARE),$(TARGET_HOST))
PPL_PKG_ARCH                = $(shell uname -m)
else
PPL_PKG_ARCH                = $(TOOLCHAIN)
endif
PPL_PKG_DISTRO_NAME         = kxLab
PPL_PKG_DISTRO_VERSION      = 1.0
PPL_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
PPL_PKG_SHORT_DESCRIPTION   = ppl $(version)
PPL_PKG_URL                 = http://www.kxLab.com
PPL_PKG_LICENSE             = GPLv2
PPL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PPL_PKG_NAME)-pkg-description
PPL_PKG_DESCRIPTION_FILE_IN = $(PPL_PKG_NAME)-pkg-description.in
PPL_PKG_INSTALL_SCRIPT      = $(PPL_PKG_NAME)-pkg-install.sh

PPL_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PPL_PKG_NAME)-package

pkg_basename     = $(PPL_PKG_NAME)-$(PPL_PKG_VERSION)-$(PPL_PKG_ARCH)-$(PPL_PKG_DISTRO_NAME)-$(PPL_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(PPL_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_ppl_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(PPL_PKG)

OPTIMIZATION_FLAGS = -O3


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-libgmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-interfaces="c,cxx"
extra_configure_switches += --disable-optimization
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
	@mkdir -p $(PPL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@if [ -d $(PPL_PKG)/usr/share/man ]; then \
	  ( cd $(PPL_PKG)/usr/share/man ; \
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
	@mkdir -p $(PPL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(PPL_PKG)/usr/doc/$(src_dir_name)
	rm -f $(PPL_PKG)/usr/share/doc/$(src_dir_name)/ChangeLog
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PPL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove toolchain path from target libtool *.la files and
	@( cd $(PPL_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libppl.la libppl_c.la \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PPL_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libppl.la libppl_c.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libppl.la libppl_c.la \
	 )
	@(cd $(PPL_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PPL_PKG_DESCRIPTION_FILE): $(PPL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_ppl_pkg): $(install_target) $(PPL_PKG_DESCRIPTION_FILE)
	@cp $(PPL_PKG_DESCRIPTION_FILE) $(PPL_PKG)/.DESCRIPTION
	@cp $(PPL_PKG_INSTALL_SCRIPT) $(PPL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PPL_PKG)/.REQUIRES
	@echo "pkgname=$(PPL_PKG_NAME)"                            >  $(PPL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PPL_PKG_VERSION)"                          >> $(PPL_PKG)/.PKGINFO ; \
	 echo "arch=$(PPL_PKG_ARCH)"                               >> $(PPL_PKG)/.PKGINFO ; \
	 echo "distroname=$(PPL_PKG_DISTRO_NAME)"                  >> $(PPL_PKG)/.PKGINFO ; \
	 echo "distrover=$(PPL_PKG_DISTRO_VERSION)"                >> $(PPL_PKG)/.PKGINFO ; \
	 echo "group=$(PPL_PKG_GROUP)"                             >> $(PPL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PPL_PKG_SHORT_DESCRIPTION)\"" >> $(PPL_PKG)/.PKGINFO ; \
	 echo "url=$(PPL_PKG_URL)"                                 >> $(PPL_PKG)/.PKGINFO ; \
	 echo "license=$(PPL_PKG_LICENSE)"                         >> $(PPL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PPL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
