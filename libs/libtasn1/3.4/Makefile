
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/GNU/libtasn1


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME)),)
REQUIRES           = libs/libtasn1/3.4-x86_32
else
REQUIRES           = libs/eglibc/2.18.1
endif

version            = 3.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libtasn1/libtasn1-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libtasn1-$(version)
src_dir_name       = libtasn1-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_tasn_pkg     = $(TARGET_BUILD_DIR)/.tasn_pkg_done



####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TASN_PKG_NAME                = libtasn1
TASN_PKG_VERSION             = 3.4
TASN_PKG_ARCH                = $(TOOLCHAIN)
TASN_PKG_DISTRO_NAME         = kxLab
TASN_PKG_DISTRO_VERSION      = 1.0
TASN_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
TASN_PKG_SHORT_DESCRIPTION   = libtasn1 $(version)
TASN_PKG_URL                 = http://www.kxLab.com
TASN_PKG_LICENSE             = GPLv2
TASN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TASN_PKG_NAME)-pkg-description
TASN_PKG_DESCRIPTION_FILE_IN = $(TASN_PKG_NAME)-pkg-description.in
TASN_PKG_INSTALL_SCRIPT      = $(TASN_PKG_NAME)-pkg-install.sh

TASN_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TASN_PKG_NAME)-package

pkg_basename     = $(TASN_PKG_NAME)-$(TASN_PKG_VERSION)-$(TASN_PKG_ARCH)-$(TASN_PKG_DISTRO_NAME)-$(TASN_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(TASN_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_tasn_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(TASN_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
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
	@mkdir -p $(TASN_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -f $(TASN_PKG)/usr/share/info/dir
	@gzip -9 $(TASN_PKG)/usr/share/info/*
	@if [ -d $(TASN_PKG)/usr/share/man ]; then \
	  ( cd $(TASN_PKG)/usr/share/man ; \
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
	@mkdir -p $(TASN_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TASN_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(TASN_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TASN_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* NEWS README* THANKS \
	         $(TASN_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(TASN_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# remove toolchain path from target libtool *.la files
	@( cd $(TASN_PKG)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libtasn1.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(TASN_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtasn1.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libtasn1.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtasn1.pc \
	 )
	@(cd $(TASN_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(TASN_PKG_DESCRIPTION_FILE): $(TASN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_tasn_pkg): $(install_target) $(TASN_PKG_DESCRIPTION_FILE)
	@cp $(TASN_PKG_DESCRIPTION_FILE) $(TASN_PKG)/.DESCRIPTION
	@cp $(TASN_PKG_INSTALL_SCRIPT) $(TASN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TASN_PKG)/.REQUIRES
	@echo "pkgname=$(TASN_PKG_NAME)"                            >  $(TASN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TASN_PKG_VERSION)"                          >> $(TASN_PKG)/.PKGINFO ; \
	 echo "arch=$(TASN_PKG_ARCH)"                               >> $(TASN_PKG)/.PKGINFO ; \
	 echo "distroname=$(TASN_PKG_DISTRO_NAME)"                  >> $(TASN_PKG)/.PKGINFO ; \
	 echo "distrover=$(TASN_PKG_DISTRO_VERSION)"                >> $(TASN_PKG)/.PKGINFO ; \
	 echo "group=$(TASN_PKG_GROUP)"                             >> $(TASN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TASN_PKG_SHORT_DESCRIPTION)\"" >> $(TASN_PKG)/.PKGINFO ; \
	 echo "url=$(TASN_PKG_URL)"                                 >> $(TASN_PKG)/.PKGINFO ; \
	 echo "license=$(TASN_PKG_LICENSE)"                         >> $(TASN_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TASN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
