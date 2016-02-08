
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libvpx

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/4.9.2
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.21
else
REQUIRES           = libs/glibc/2.21-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libvpx/libvpx-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libvpx-$(version)
src_dir_name       = libvpx-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBVPX_PKG_NAME                = libvpx
LIBVPX_PKG_VERSION             = 1.4.0
LIBVPX_PKG_ARCH                = $(TOOLCHAIN)
LIBVPX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVPX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVPX_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBVPX_PKG_SHORT_DESCRIPTION   = The WebM VP8 Codec SDK
LIBVPX_PKG_URL                 = $(BUG_URL)
LIBVPX_PKG_LICENSE             = BSD
LIBVPX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVPX_PKG_NAME)-pkg-description
LIBVPX_PKG_DESCRIPTION_FILE_IN = $(LIBVPX_PKG_NAME)-pkg-description.in
LIBVPX_PKG_INSTALL_SCRIPT      = $(LIBVPX_PKG_NAME)-pkg-install.sh

LIBVPX_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVPX_PKG_NAME)-package

pkg_basename     = $(LIBVPX_PKG_NAME)-$(LIBVPX_PKG_VERSION)-$(LIBVPX_PKG_ARCH)-$(LIBVPX_PKG_DISTRO_NAME)-$(LIBVPX_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_DIR="$(LIBVPX_PKG)/usr"


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)

extra_configure_switches += --as=auto

extra_configure_switches += --enable-vp8
extra_configure_switches += --enable-vp9
extra_configure_switches += --enable-runtime-cpu-detect
extra_configure_switches += --enable-postproc
extra_configure_switches += --enable-pic
extra_configure_switches += --disable-install-docs
extra_configure_switches += --disable-install-srcs
extra_configure_switches += --enable-shared


configure_environment  = LD="$(CC) --sysroot=$(TARGET_DEST_DIR)"
configure_environment += CROSS=$(CROSS_PREFIX)


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
target_platform = x86-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
target_platform = x86_64-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)),)
target_platform = armv7-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB3X)),)
target_platform = armv7-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_FFRK3288)),)
target_platform = armv7-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_DM64X)),)
target_platform = armv5te-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_BEAGLE)),)
target_platform = armv7-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM)),)
target_platform = armv7-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_B74)),)
target_platform = mips32-linux-gcc
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
target_platform = mips32r2-linux-gcc
endif


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(configure_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --target=$(target_platform) \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBVPX_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBVPX_PKG)/usr/share/man ]; then \
	  ( cd $(LIBVPX_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBVPX_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/LICENSE $(SRC_DIR)/PATENTS \
	       $(LIBVPX_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBVPX_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS LICENSE PATENTS README \
	         $(LIBVPX_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG ]; then \
	     DOCSDIR=`echo $(LIBVPX_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG | head -n 1000 > $$DOCSDIR/CHANGELOG ; \
	     touch -r CHANGELOG $$DOCSDIR/CHANGELOG ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVPX_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vpx.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVPX_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBVPX_PKG_DESCRIPTION_FILE): $(LIBVPX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVPX_PKG_DESCRIPTION_FILE) $(LIBVPX_PKG_INSTALL_SCRIPT)
	@cp $(LIBVPX_PKG_DESCRIPTION_FILE) $(LIBVPX_PKG)/.DESCRIPTION
	@cp $(LIBVPX_PKG_INSTALL_SCRIPT) $(LIBVPX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVPX_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVPX_PKG_NAME)"                            >  $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVPX_PKG_VERSION)"                          >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVPX_PKG_ARCH)"                               >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVPX_PKG_DISTRO_NAME)"                  >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVPX_PKG_DISTRO_VERSION)"                >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVPX_PKG_GROUP)"                             >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVPX_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVPX_PKG_URL)"                                 >> $(LIBVPX_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVPX_PKG_LICENSE)"                         >> $(LIBVPX_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBVPX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
