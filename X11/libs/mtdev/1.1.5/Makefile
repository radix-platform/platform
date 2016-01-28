
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/mtdev

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.5
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/mtdev/mtdev-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mtdev-$(version)
src_dir_name       = mtdev-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MTDEV_PKG_NAME                = mtdev
MTDEV_PKG_VERSION             = 1.1.5
MTDEV_PKG_ARCH                = $(TOOLCHAIN)
MTDEV_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MTDEV_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MTDEV_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
MTDEV_PKG_SHORT_DESCRIPTION   = Multitouch Protocol Translation Library
MTDEV_PKG_URL                 = $(BUG_URL)
MTDEV_PKG_LICENSE             = custom
MTDEV_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MTDEV_PKG_NAME)-pkg-description
MTDEV_PKG_DESCRIPTION_FILE_IN = $(MTDEV_PKG_NAME)-pkg-description.in
MTDEV_PKG_INSTALL_SCRIPT      = $(MTDEV_PKG_NAME)-pkg-install.sh

MTDEV_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MTDEV_PKG_NAME)-package

pkg_basename     = $(MTDEV_PKG_NAME)-$(MTDEV_PKG_VERSION)-$(MTDEV_PKG_ARCH)-$(MTDEV_PKG_DISTRO_NAME)-$(MTDEV_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(MTDEV_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

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
	@mkdir -p $(MTDEV_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(MTDEV_PKG)/usr/share/man ]; then \
	  ( cd $(MTDEV_PKG)/usr/share/man ; \
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
	@mkdir -p $(MTDEV_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(MTDEV_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MTDEV_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README \
	         $(MTDEV_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MTDEV_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MTDEV_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmtdev.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MTDEV_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmtdev.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmtdev.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" mtdev.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(MTDEV_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(MTDEV_PKG_DESCRIPTION_FILE): $(MTDEV_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MTDEV_PKG_DESCRIPTION_FILE) $(MTDEV_PKG_INSTALL_SCRIPT)
	@cp $(MTDEV_PKG_DESCRIPTION_FILE) $(MTDEV_PKG)/.DESCRIPTION
	@cp $(MTDEV_PKG_INSTALL_SCRIPT) $(MTDEV_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MTDEV_PKG)/.REQUIRES
	@echo "pkgname=$(MTDEV_PKG_NAME)"                            >  $(MTDEV_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MTDEV_PKG_VERSION)"                          >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "arch=$(MTDEV_PKG_ARCH)"                               >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "distroname=$(MTDEV_PKG_DISTRO_NAME)"                  >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "distrover=$(MTDEV_PKG_DISTRO_VERSION)"                >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "group=$(MTDEV_PKG_GROUP)"                             >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MTDEV_PKG_SHORT_DESCRIPTION)\"" >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "url=$(MTDEV_PKG_URL)"                                 >> $(MTDEV_PKG)/.PKGINFO ; \
	 echo "license=$(MTDEV_PKG_LICENSE)"                         >> $(MTDEV_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MTDEV_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
