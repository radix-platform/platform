
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


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/a/gpm


ifneq ($(filter $(TOOLCHAIN),$(X86_64_EGLIBC_TOOLCHAIN_NAME) $(BUILD_TOOLCHAIN_NAME)),)
REQUIRES           = app/gpm/1.20.7-x86_32
else
REQUIRES           = app/inputattach/1.4.7
endif

version            = 1.20.7
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/gpm/gpm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gpm-$(version)
src_dir_name       = gpm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

cache_file         = $(CURDIR)/disable-emacs.cache
build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_gpm_pkg      = $(TARGET_BUILD_DIR)/.gpm_pkg_done



####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPM_PKG_NAME                = gpm
GPM_PKG_VERSION             = 1.20.7
ifeq ($(HARDWARE),$(TARGET_HOST))
GPM_PKG_ARCH                = $(shell uname -m)
else
GPM_PKG_ARCH                = $(TOOLCHAIN)
endif
GPM_PKG_DISTRO_NAME         = kxLab
GPM_PKG_DISTRO_VERSION      = 1.0
GPM_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
GPM_PKG_SHORT_DESCRIPTION   = gpm $(version)
GPM_PKG_URL                 = http://www.kxLab.com
GPM_PKG_LICENSE             = GPLv2
GPM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPM_PKG_NAME)-pkg-description
GPM_PKG_DESCRIPTION_FILE_IN = $(GPM_PKG_NAME)-pkg-description.in
GPM_PKG_INSTALL_SCRIPT      = $(GPM_PKG_NAME)-pkg-install.sh

GPM_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPM_PKG_NAME)-package

pkg_basename     = $(GPM_PKG_NAME)-$(GPM_PKG_VERSION)-$(GPM_PKG_ARCH)-$(GPM_PKG_DISTRO_NAME)-$(GPM_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GPM_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gpm_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot      = DESTDIR=$(GPM_PKG)


OPTIMIZATION_FLAGS = -O3

ifeq ($(TOOLCHAIN),$(BUILD_TOOLCHAIN_NAME))
LIBSUFFIX=64
else
LIBSUFFIX=
endif

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared
extra_configure_switches += --cache-file=$(cache_file)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@chmod a-w $(cache_file)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@chmod +w $(cache_file)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPM_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod 755 $(GPM_PKG)/usr/lib$(LIBSUFFIX)/libgpm.so.?.?.?
	@mkdir -p $(GPM_PKG)/lib$(LIBSUFFIX)
	@( cd $(GPM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@( cd $(GPM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf libgpm.so.?.?.? libgpm.so \
	 )
	@mkdir -p $(GPM_PKG)/etc/rc.d
	@( cd $(SRC_DIR)/conf ; \
	   cat gpm-root.conf > $(GPM_PKG)/etc/gpm-root.conf ; \
	   cat gpm-syn.conf > $(GPM_PKG)/etc/gpm-syn.conf ; \
	   cat gpm-twiddler.conf > $(GPM_PKG)/etc/gpm-twiddler.conf \
	 )
	@rm -f $(GPM_PKG)/usr/share/info/dir
	@gzip -9 $(GPM_PKG)/usr/share/info/*
	@if [ -d $(GPM_PKG)/usr/share/man ]; then \
	  ( cd $(GPM_PKG)/usr/share/man ; \
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
	@mkdir -p $(GPM_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(GPM_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(GPM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a MANIFEST README* TODO doc/{Announce,FAQ,HACK_GPM,README*,changelog} \
	         $(GPM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -arf doc/specs doc/support doc/todo \
	           $(GPM_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GPM_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GPM_PKG) && cp -arf * $(TARGET_DEST_DIR)
	@(cd $(GPM_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GPM_PKG_DESCRIPTION_FILE): $(GPM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gpm_pkg): $(install_target) $(GPM_PKG_DESCRIPTION_FILE)
	@cp $(GPM_PKG_DESCRIPTION_FILE) $(GPM_PKG)/.DESCRIPTION
	@cp $(GPM_PKG_INSTALL_SCRIPT) $(GPM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPM_PKG)/.REQUIRES
	@echo "pkgname=$(GPM_PKG_NAME)"                            >  $(GPM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPM_PKG_VERSION)"                          >> $(GPM_PKG)/.PKGINFO ; \
	 echo "arch=$(GPM_PKG_ARCH)"                               >> $(GPM_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPM_PKG_DISTRO_NAME)"                  >> $(GPM_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPM_PKG_DISTRO_VERSION)"                >> $(GPM_PKG)/.PKGINFO ; \
	 echo "group=$(GPM_PKG_GROUP)"                             >> $(GPM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPM_PKG_SHORT_DESCRIPTION)\"" >> $(GPM_PKG)/.PKGINFO ; \
	 echo "url=$(GPM_PKG_URL)"                                 >> $(GPM_PKG)/.PKGINFO ; \
	 echo "license=$(GPM_PKG_LICENSE)"                         >> $(GPM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GPM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
