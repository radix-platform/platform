
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/libdrm

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
REQUIRES          += X11/X.org/lib/libpciaccess/0.13.2
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.4.64
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/libdrm/libdrm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdrm-$(version)
src_dir_name       = libdrm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/COPYING

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBDRM_PKG_NAME                = libdrm
LIBDRM_PKG_VERSION             = 2.4.64
LIBDRM_PKG_ARCH                = $(TOOLCHAIN)
LIBDRM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBDRM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBDRM_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBDRM_PKG_SHORT_DESCRIPTION   = Direct Rendering library
LIBDRM_PKG_URL                 = $(BUG_URL)
LIBDRM_PKG_LICENSE             = custom
LIBDRM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBDRM_PKG_NAME)-pkg-description
LIBDRM_PKG_DESCRIPTION_FILE_IN = $(LIBDRM_PKG_NAME)-pkg-description.in
LIBDRM_PKG_INSTALL_SCRIPT      = $(LIBDRM_PKG_NAME)-pkg-install.sh

LIBDRM_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBDRM_PKG_NAME)-package

pkg_basename     = $(LIBDRM_PKG_NAME)-$(LIBDRM_PKG_VERSION)-$(LIBDRM_PKG_ARCH)-$(LIBDRM_PKG_DISTRO_NAME)-$(LIBDRM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBDRM_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --enable-udev
extra_configure_switches += --enable-omap-experimental-api
extra_configure_switches += --enable-exynos-experimental-api
extra_configure_switches += --enable-cairo-tests=no

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
	@mkdir -p $(LIBDRM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@( cd $(LIBDRM_PKG)/usr/share/man/man7 ; \
	   for file in *.7 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(LIBDRM_PKG)/usr/share/man ]; then \
	  ( cd $(LIBDRM_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBDRM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(LIBDRM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBDRM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a $(license) README \
	         $(LIBDRM_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBDRM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBDRM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdrm.la          \
	                                    libdrm_exynos.la   \
	                                    libdrm_nouveau.la  \
	                                    libdrm_omap.la     \
	                                    libdrm_radeon.la   \
	                                    libkms.la        ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
	@( cd $(LIBDRM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdrm_intel.la ; \
	 )
endif
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBDRM_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdrm.la          \
	                                            libdrm_exynos.la   \
	                                            libdrm_nouveau.la  \
	                                            libdrm_omap.la     \
	                                            libdrm_radeon.la   \
	                                            libkms.la        ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdrm.la          \
	                                              libdrm_exynos.la   \
	                                              libdrm_nouveau.la  \
	                                              libdrm_omap.la     \
	                                              libdrm_radeon.la   \
	                                              libkms.la        ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdrm_intel.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdrm_intel.la ; \
	 )
endif
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdrm.pc          \
	                                            libdrm_exynos.pc   \
	                                            libdrm_nouveau.pc  \
	                                            libdrm_omap.pc     \
	                                            libdrm_radeon.pc   \
	                                            libkms.pc        ; \
	 )
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64) $(HARDWARE_PC32)),)
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdrm_intel.pc ; \
	 )
endif
	# ======= Strip binaries =======
	@( cd $(LIBDRM_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBDRM_PKG_DESCRIPTION_FILE): $(LIBDRM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBDRM_PKG_DESCRIPTION_FILE) $(LIBDRM_PKG_INSTALL_SCRIPT)
	@cp $(LIBDRM_PKG_DESCRIPTION_FILE) $(LIBDRM_PKG)/.DESCRIPTION
	@cp $(LIBDRM_PKG_INSTALL_SCRIPT) $(LIBDRM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBDRM_PKG)/.REQUIRES
	@echo "pkgname=$(LIBDRM_PKG_NAME)"                            >  $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBDRM_PKG_VERSION)"                          >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBDRM_PKG_ARCH)"                               >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBDRM_PKG_DISTRO_NAME)"                  >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBDRM_PKG_DISTRO_VERSION)"                >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "group=$(LIBDRM_PKG_GROUP)"                             >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBDRM_PKG_SHORT_DESCRIPTION)\"" >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "url=$(LIBDRM_PKG_URL)"                                 >> $(LIBDRM_PKG)/.PKGINFO ; \
	 echo "license=$(LIBDRM_PKG_LICENSE)"                         >> $(LIBDRM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBDRM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
