
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libunwind

REQUIRES          += app/xz/5.2.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libunwind/libunwind-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libunwind-$(version)
src_dir_name       = libunwind-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
OPT_PATCHES = PATCHES.aarch64
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBUNWIND_PKG_NAME                = libunwind
LIBUNWIND_PKG_VERSION             = 1.2
LIBUNWIND_PKG_ARCH                = $(TOOLCHAIN)
LIBUNWIND_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUNWIND_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUNWIND_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBUNWIND_PKG_SHORT_DESCRIPTION   = platform-independent unwind API
LIBUNWIND_PKG_URL                 = $(BUG_URL)
LIBUNWIND_PKG_LICENSE             = BSD
LIBUNWIND_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUNWIND_PKG_NAME)-pkg-description
LIBUNWIND_PKG_DESCRIPTION_FILE_IN = $(LIBUNWIND_PKG_NAME)-pkg-description.in
LIBUNWIND_PKG_INSTALL_SCRIPT      = $(LIBUNWIND_PKG_NAME)-pkg-install.sh

LIBUNWIND_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUNWIND_PKG_NAME)-package

pkg_basename     = $(LIBUNWIND_PKG_NAME)-$(LIBUNWIND_PKG_VERSION)-$(LIBUNWIND_PKG_ARCH)-$(LIBUNWIND_PKG_DISTRO_NAME)-$(LIBUNWIND_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBUNWIND_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-documentation

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


ifneq ($(filter $(HARDWARE),$(HARDWARE_PC32)),)
ARCH = x86
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_PC64)),)
ARCH = x86_64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CB2X) $(HARDWARE_CB3X) \
                            $(HARDWARE_FFRK3288)                               \
                            $(HARDWARE_M201) $(HARDWARE_MXV)                   \
                            $(HARDWARE_NIT6Q)                                  \
                            $(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
ARCH = arm
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                                             $(HARDWARE_ODROID_C2)   \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
ARCH = aarch64
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20) $(HARDWARE_BAIKAL_T1)),)
ARCH = mips
endif


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifeq ($(TOOLCHAIN),$(TOOLCHAIN_S9XX_GLIBC))
	$(call apply-opt-patches, $(SRC_DIR))
endif
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
	@mkdir -p $(LIBUNWIND_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(LIBUNWIND_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBUNWIND_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBUNWIND_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README TODO \
	         $(LIBUNWIND_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBUNWIND_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUNWIND_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libunwind-$(ARCH).la libunwind-coredump.la  \
	                                    libunwind-ptrace.la  libunwind-setjmp.la    \
	                                    libunwind.la                              ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUNWIND_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunwind-$(ARCH).la libunwind-coredump.la  \
	                                            libunwind-ptrace.la  libunwind-setjmp.la    \
	                                            libunwind.la                              ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libunwind-$(ARCH).la libunwind-coredump.la  \
	                                              libunwind-ptrace.la  libunwind-setjmp.la    \
	                                              libunwind.la                              ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunwind-coredump.pc libunwind-generic.pc  \
	                                            libunwind-ptrace.pc   libunwind-setjmp.pc   \
	                                            libunwind.pc                              ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUNWIND_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBUNWIND_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBUNWIND_PKG_DESCRIPTION_FILE): $(LIBUNWIND_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUNWIND_PKG_DESCRIPTION_FILE) $(LIBUNWIND_PKG_INSTALL_SCRIPT)
	@cp $(LIBUNWIND_PKG_DESCRIPTION_FILE) $(LIBUNWIND_PKG)/.DESCRIPTION
	@cp $(LIBUNWIND_PKG_INSTALL_SCRIPT) $(LIBUNWIND_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUNWIND_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUNWIND_PKG_NAME)"                            >  $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUNWIND_PKG_VERSION)"                          >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUNWIND_PKG_ARCH)"                               >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUNWIND_PKG_DISTRO_NAME)"                  >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUNWIND_PKG_DISTRO_VERSION)"                >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUNWIND_PKG_GROUP)"                             >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUNWIND_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUNWIND_PKG_URL)"                                 >> $(LIBUNWIND_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUNWIND_PKG_LICENSE)"                         >> $(LIBUNWIND_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBUNWIND_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
