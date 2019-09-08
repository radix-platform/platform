
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


SOURCE_REQUIRES    = sources/packages/m/openh264

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES          += libs/glibc/2.25
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/openh264/openh264-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/openh264-$(version)
src_dir_name       = openh264-$(version)
doc_dir_name       = openh264-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
OPENH264_PKG_NAME                = openh264
OPENH264_PKG_VERSION             = 1.6.0
OPENH264_PKG_ARCH                = $(TOOLCHAIN)
OPENH264_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPENH264_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPENH264_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
OPENH264_PKG_SHORT_DESCRIPTION   = Cisco H.264 implementation
OPENH264_PKG_URL                 = $(BUG_URL)
OPENH264_PKG_LICENSE             = BSD
OPENH264_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPENH264_PKG_NAME)-pkg-description
OPENH264_PKG_DESCRIPTION_FILE_IN = $(OPENH264_PKG_NAME)-pkg-description.in
OPENH264_PKG_INSTALL_SCRIPT      = $(OPENH264_PKG_NAME)-pkg-install.sh

OPENH264_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPENH264_PKG_NAME)-package

pkg_basename     = $(OPENH264_PKG_NAME)-$(OPENH264_PKG_VERSION)-$(OPENH264_PKG_ARCH)-$(OPENH264_PKG_DISTRO_NAME)-$(OPENH264_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(OPENH264_PKG)


ENABLE_X86_NASM = no


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201)      \
                            $(HARDWARE_MXV)       \
                            $(HARDWARE_NIT6Q)     \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
ARCH = arm
ARCH_INCLUDES = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH = i386
ARCH_INCLUDES = x86
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH = x86_64
ARCH_INCLUDES = x86
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
ARCH = mips
ARCH_INCLUDES =
endif


h264_environment  = OS=linux
h264_environment += ARCH=$(ARCH)

ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
ifneq ($(ENABLE_X86_NASM),yes)
h264_environment += USE_ASM=No
endif
endif

h264_environment += PREFIX=/usr
h264_environment += LIBDIR_NAME=lib$(LIBSUFFIX)
h264_environment += SHAREDLIB_DIR=/usr/lib$(LIBSUFFIX)

h264_environment += CC='$(CROSS_PREFIX)gcc'
h264_environment += CXX='$(CROSS_PREFIX)g++'
h264_environment += CCAS='$(CROSS_PREFIX)gcc'
h264_environment += LD='$(CROSS_PREFIX)ld'
h264_environment += AR='$(CROSS_PREFIX)ar'
h264_environment += STRIP='$(CROSS_PREFIX)strip'

h264_environment += SRC_PATH='$(CURDIR)/$(SRC_DIR)/'

h264_environment += CFLAGS_OPT='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC -Wno-parentheses'
h264_environment += ASMFLAGS='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) -I$(CURDIR)/$(SRC_DIR)/codec/common/$(ARCH_INCLUDES)'
h264_environment += LDFLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lpthread -lstdc++'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(h264_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(OPENH264_PKG)/usr/bin
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot) $(h264_environment)
	@( cd $(SRC_DIR) ; \
	   cp -a h264{enc,dec} $(OPENH264_PKG)/usr/bin ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(OPENH264_PKG)/usr/share/man ]; then \
	  ( cd $(OPENH264_PKG)/usr/share/man ; \
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
	@mkdir -p $(OPENH264_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/CONTRIBUTORS $(SRC_DIR)/LICENSE \
	       $(OPENH264_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OPENH264_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CONTRIBUTORS LICENSE README.md RELEASES gmpopenh264.info \
	         $(OPENH264_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(OPENH264_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(OPENH264_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" openh264.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(OPENH264_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(OPENH264_PKG_DESCRIPTION_FILE): $(OPENH264_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPENH264_PKG_DESCRIPTION_FILE) $(OPENH264_PKG_INSTALL_SCRIPT)
	@cp $(OPENH264_PKG_DESCRIPTION_FILE) $(OPENH264_PKG)/.DESCRIPTION
	@cp $(OPENH264_PKG_INSTALL_SCRIPT) $(OPENH264_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPENH264_PKG)/.REQUIRES
	@echo "pkgname=$(OPENH264_PKG_NAME)"                            >  $(OPENH264_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPENH264_PKG_VERSION)"                          >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "arch=$(OPENH264_PKG_ARCH)"                               >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPENH264_PKG_DISTRO_NAME)"                  >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPENH264_PKG_DISTRO_VERSION)"                >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "group=$(OPENH264_PKG_GROUP)"                             >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPENH264_PKG_SHORT_DESCRIPTION)\"" >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "url=$(OPENH264_PKG_URL)"                                 >> $(OPENH264_PKG)/.PKGINFO ; \
	 echo "license=$(OPENH264_PKG_LICENSE)"                         >> $(OPENH264_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(OPENH264_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
