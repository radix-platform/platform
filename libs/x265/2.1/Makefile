
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/x265

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES          += libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/x265/x265-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/x265-$(version)
src_dir_name       = x265-$(version)
doc_dir_name       = x265-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_12bit        = $(TARGET_BUILD_DIR)/build-12
build_10bit        = $(TARGET_BUILD_DIR)/build-10

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
X265_PKG_NAME                = x265
X265_PKG_VERSION             = 2.1
X265_PKG_ARCH                = $(TOOLCHAIN)
X265_PKG_DISTRO_NAME         = $(DISTRO_NAME)
X265_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
X265_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
X265_PKG_SHORT_DESCRIPTION   = Open Source H265/HEVC video encoder
X265_PKG_URL                 = $(BUG_URL)
X265_PKG_LICENSE             = GPLv2
X265_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(X265_PKG_NAME)-pkg-description
X265_PKG_DESCRIPTION_FILE_IN = $(X265_PKG_NAME)-pkg-description.in
X265_PKG_INSTALL_SCRIPT      = $(X265_PKG_NAME)-pkg-install.sh

X265_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(X265_PKG_NAME)-package

pkg_basename     = $(X265_PKG_NAME)-$(X265_PKG_VERSION)-$(X265_PKG_ARCH)-$(X265_PKG_DISTRO_NAME)-$(X265_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(X265_PKG)


ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X)      \
                            $(HARDWARE_CB2X)      \
                            $(HARDWARE_CB3X)      \
                            $(HARDWARE_FFRK3288)  \
                            $(HARDWARE_M201) $(HARDWARE_MXV) \
                            $(HARDWARE_NIT6Q)     \
                            $(HARDWARE_OMAP5UEVM) \
                            $(HARDWARE_DRA7XXEVM)),)
ARCH_ALIAS = armv7l
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH_ALIAS = aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH_ALIAS = x86
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH_ALIAS = x86_64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BT1)),)
ARCH_ALIAS = mipsel
endif


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


configure_switches  = -DCMAKE_BUILD_TYPE='Release'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_CXX_COMPILER='$(CROSS_PREFIX)g++'

ifeq ($(filter $(HARDWARE),$(HARDWARE_PC32) \
                           $(HARDWARE_PC64) \
                           $(HARDWARE_CI20) \
                           $(HARDWARE_BT1)),)
configure_switches += -DCMAKE_ASM_COMPILER='$(CROSS_PREFIX)gcc'
endif

configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC'
configure_switches += -DCMAKE_CXX_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC'


ifeq ($(filter $(HARDWARE),$(HARDWARE_PC32) \
                           $(HARDWARE_PC64) \
                           $(HARDWARE_CI20) \
                           $(HARDWARE_BT1)),)
configure_switches += -DCMAKE_ASM_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -fPIC'
endif

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)'


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
configure_switches += -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG'
endif

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DBIN_INSTALL_DIR='bin'
configure_switches += -DLIB_INSTALL_DIR='lib$(LIBSUFFIX)'

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DCMAKE_SYSTEM_NAME='Linux'
configure_switches += -DCMAKE_SYSTEM_PROCESSOR=$(ARCH_ALIAS)
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32) $(HARDWARE_PC64)),)
configure_switches += -DDISABLE_X86_YASM=True
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
configure_switches += -DENABLE_ASSEMBLY='OFF'
endif

configure_switches += -DENABLE_LIBNUMA='FALSE'


configure_12bit_switches += -DHIGH_BIT_DEPTH='TRUE'
configure_12bit_switches += -DMAIN12='TRUE'
configure_12bit_switches += -DEXPORT_C_API='FALSE'
configure_12bit_switches += -DENABLE_CLI='FALSE'
configure_12bit_switches += -DENABLE_SHARED='FALSE'

configure_10bit_switches += -DHIGH_BIT_DEPTH='TRUE'
configure_10bit_switches += -DEXPORT_C_API='FALSE'
configure_10bit_switches += -DENABLE_CLI='FALSE'
configure_10bit_switches += -DENABLE_SHARED='FALSE'

configure_08bit_switches += -DENABLE_SHARED='TRUE'
configure_08bit_switches += -DEXTRA_LIB='x265_main10.a;x265_main12.a'
configure_08bit_switches += -DEXTRA_LINK_FLAGS='-L.'
configure_08bit_switches += -DLINKED_10BIT='TRUE'
configure_08bit_switches += -DLINKED_12BIT='TRUE'


configure_shared_switch  += -DENABLE_SHARED='TRUE'


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
	@mkdir -p $(build_12bit)
	@( cd $(build_12bit) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches)        \
	                              $(configure_12bit_switches)  \
	                              ../$(src_dir_name)/source  ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
	@mkdir -p $(build_10bit)
	@( cd $(build_10bit) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches)        \
	                              $(configure_10bit_switches)  \
	                              ../$(src_dir_name)/source  ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
	@( cd $(build_dir) ; \
	   ln -sf ../$(notdir $(build_12bit))/libx265.a libx265_main12.a ; \
	   ln -sf ../$(notdir $(build_10bit))/libx265.a libx265_main10.a ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches)        \
	                              $(configure_08bit_switches)  \
	                              $(configure_shared_switch)   \
	                              ../$(src_dir_name)/source  ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
else
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches)        \
	                              $(configure_shared_switch)   \
	                              ../$(src_dir_name)/source  ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	 )
endif
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(X265_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(X265_PKG)/usr/share/man ]; then \
	  ( cd $(X265_PKG)/usr/share/man ; \
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
	@mkdir -p $(X265_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(X265_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(X265_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(X265_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(X265_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(X265_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" x265.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(X265_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(X265_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(X265_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(X265_PKG_DESCRIPTION_FILE): $(X265_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(X265_PKG_DESCRIPTION_FILE) $(X265_PKG_INSTALL_SCRIPT)
	@cp $(X265_PKG_DESCRIPTION_FILE) $(X265_PKG)/.DESCRIPTION
	@cp $(X265_PKG_INSTALL_SCRIPT) $(X265_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(X265_PKG)/.REQUIRES
	@echo "pkgname=$(X265_PKG_NAME)"                            >  $(X265_PKG)/.PKGINFO ; \
	 echo "pkgver=$(X265_PKG_VERSION)"                          >> $(X265_PKG)/.PKGINFO ; \
	 echo "arch=$(X265_PKG_ARCH)"                               >> $(X265_PKG)/.PKGINFO ; \
	 echo "distroname=$(X265_PKG_DISTRO_NAME)"                  >> $(X265_PKG)/.PKGINFO ; \
	 echo "distrover=$(X265_PKG_DISTRO_VERSION)"                >> $(X265_PKG)/.PKGINFO ; \
	 echo "group=$(X265_PKG_GROUP)"                             >> $(X265_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(X265_PKG_SHORT_DESCRIPTION)\"" >> $(X265_PKG)/.PKGINFO ; \
	 echo "url=$(X265_PKG_URL)"                                 >> $(X265_PKG)/.PKGINFO ; \
	 echo "license=$(X265_PKG_LICENSE)"                         >> $(X265_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(X265_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
