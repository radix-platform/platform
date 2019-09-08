
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/VideoLAN/x264

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES          += libs/glibc/2.25
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.148.20160920
short_version      = $(shell echo $(version) | cut -f 1,2 -d '.').x
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/VideoLAN/x264/x264-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/x264-$(version)
src_dir_name       = x264-$(version)
doc_dir_name       = libx264-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBX264_PKG_NAME                = libx264
LIBX264_PKG_VERSION             = 0.148.20160920
LIBX264_PKG_ARCH                = $(TOOLCHAIN)
LIBX264_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBX264_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBX264_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBX264_PKG_SHORT_DESCRIPTION   = H.264/MPEG-4 AVC encoder library
LIBX264_PKG_URL                 = $(BUG_URL)
LIBX264_PKG_LICENSE             = GPLv2
LIBX264_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBX264_PKG_NAME)-pkg-description
LIBX264_PKG_DESCRIPTION_FILE_IN = $(LIBX264_PKG_NAME)-pkg-description.in
LIBX264_PKG_INSTALL_SCRIPT      = $(LIBX264_PKG_NAME)-pkg-install.sh

LIBX264_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBX264_PKG_NAME)-package

pkg_basename     = $(LIBX264_PKG_NAME)-$(LIBX264_PKG_VERSION)-$(LIBX264_PKG_ARCH)-$(LIBX264_PKG_DISTRO_NAME)-$(LIBX264_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBX264_PKG)


ENABLE_X86_YASM = yes


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --bindir=/usr/bin

extra_configure_switches += --disable-cli
extra_configure_switches += --disable-opencl

extra_configure_switches += --bit-depth='8'
extra_configure_switches += --chroma-format=all

extra_configure_switches += --enable-pic

extra_configure_switches += --disable-avs
extra_configure_switches += --disable-swscale
extra_configure_switches += --disable-lavf
extra_configure_switches += --disable-ffms
extra_configure_switches += --disable-gpac
extra_configure_switches += --disable-lsmash

extra_configure_switches += --enable-shared


ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
extra_configure_switches += --disable-asm
endif

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
ifeq ($(ENABLE_X86_YASM),yes)
extra_x86_environment  = AS=/usr/bin/yasm
else
extra_configure_switches += --disable-asm
endif
endif


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(extra_x86_environment) ./configure \
	  --prefix=/usr               \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBX264_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBX264_PKG)/usr/share/man ]; then \
	  ( cd $(LIBX264_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBX264_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBX264_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBX264_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING doc/*.txt \
	         $(LIBX264_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBX264_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBX264_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" x264.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBX264_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LIBX264_PKG_DESCRIPTION_FILE): $(LIBX264_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(short_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBX264_PKG_DESCRIPTION_FILE) $(LIBX264_PKG_INSTALL_SCRIPT)
	@cp $(LIBX264_PKG_DESCRIPTION_FILE) $(LIBX264_PKG)/.DESCRIPTION
	@cp $(LIBX264_PKG_INSTALL_SCRIPT) $(LIBX264_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBX264_PKG)/.REQUIRES
	@echo "pkgname=$(LIBX264_PKG_NAME)"                            >  $(LIBX264_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBX264_PKG_VERSION)"                          >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBX264_PKG_ARCH)"                               >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBX264_PKG_DISTRO_NAME)"                  >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBX264_PKG_DISTRO_VERSION)"                >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "group=$(LIBX264_PKG_GROUP)"                             >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBX264_PKG_SHORT_DESCRIPTION)\"" >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "url=$(LIBX264_PKG_URL)"                                 >> $(LIBX264_PKG)/.PKGINFO ; \
	 echo "license=$(LIBX264_PKG_LICENSE)"                         >> $(LIBX264_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBX264_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
