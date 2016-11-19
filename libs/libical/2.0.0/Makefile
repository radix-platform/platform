
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libical

REQUIRES           = libs/icu4c/55.1

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libical/libical-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libical-$(version)
src_dir_name       = libical-$(version)
doc_dir_name       = libical-$(version)
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
LIBICAL_PKG_NAME                = libical
LIBICAL_PKG_VERSION             = 2.0.0
LIBICAL_PKG_ARCH                = $(TOOLCHAIN)
LIBICAL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBICAL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBICAL_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBICAL_PKG_SHORT_DESCRIPTION   = iCAL protocol implementation
LIBICAL_PKG_URL                 = $(BUG_URL)
LIBICAL_PKG_LICENSE             = LGPLv2.1
LIBICAL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBICAL_PKG_NAME)-pkg-description
LIBICAL_PKG_DESCRIPTION_FILE_IN = $(LIBICAL_PKG_NAME)-pkg-description.in
LIBICAL_PKG_INSTALL_SCRIPT      = $(LIBICAL_PKG_NAME)-pkg-install.sh

LIBICAL_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBICAL_PKG_NAME)-package

pkg_basename     = $(LIBICAL_PKG_NAME)-$(LIBICAL_PKG_VERSION)-$(LIBICAL_PKG_ARCH)-$(LIBICAL_PKG_DISTRO_NAME)-$(LIBICAL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBICAL_PKG)


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


configure_switches  = -DCMAKE_BUILD_TYPE='Release'

configure_switches += -DCMAKE_C_COMPILER='$(CROSS_PREFIX)gcc'
configure_switches += -DCMAKE_LINKER='$(CROSS_PREFIX)ld'
configure_switches += -DCMAKE_AR='$(CROSS_PREFIX)ar'
configure_switches += -DCMAKE_NM='$(CROSS_PREFIX)nm'
configure_switches += -DCMAKE_RANLIB='$(CROSS_PREFIX)ranlib'
configure_switches += -DCMAKE_OBJCOPY='$(CROSS_PREFIX)objcopy'
configure_switches += -DCMAKE_OBJDUMP='$(CROSS_PREFIX)objdump'
configure_switches += -DCMAKE_STRIP='$(CROSS_PREFIX)strip'

configure_switches += -DCMAKE_C_FLAGS:STRING='--sysroot=$(TARGET_DEST_DIR) $(CFLAGS) $(ARCH_FLAGS) $(ARCH_DEFS) $(HW_FLAGS) -Wno-type-limits'

configure_switches += -DCMAKE_EXE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_BIN_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lstdc++'
configure_switches += -DCMAKE_MODULE_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lstdc++'
configure_switches += -DCMAKE_SHARED_LINKER_FLAGS='--sysroot=$(TARGET_DEST_DIR) -Wl,-rpath,$(TARGET_LIB_RPATH) -L$(TARGET_DEST_DIR)/lib$(LIBSUFFIX) -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) -lstdc++'


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_JZ47XX_GLIBC))
configure_switches += -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG'
configure_switches += -DCMAKE_ASM_FLAGS_RELEASE='-O2 -DNDEBUG'
endif

configure_switches += -DCMAKE_INSTALL_PREFIX=/usr

configure_switches += -DCMAKE_INSTALL_DOCDIR='/usr/share/doc/$(doc_dir_name)'
configure_switches += -DCMAKE_INSTALL_INFODIR='/usr/share/info'
configure_switches += -DCMAKE_INSTALL_MANDIR='/usr/share/man'

configure_switches += -DCMAKE_INSTALL_SYSCONFDIR='etc'
configure_switches += -DCMAKE_INSTALL_BINDIR='bin'
configure_switches += -DCMAKE_INSTALL_LIBDIR='lib$(LIBSUFFIX)'

configure_switches += -DCMAKE_CROSSCOMPILING=True

configure_switches += -DSHARED_ONLY:BOOL=true


configure_switches += -DICU_INCLUDE_DIR:PATH=$(TARGET_DEST_DIR)/usr/include
configure_switches += -DICU_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libicuuc.so
configure_switches += -DICU_I18N_LIBRARY:FILEPATH=$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libicui18n.so


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   echo -e "\n----------------------------------------------------------------------" >> COPYING ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) ../$(src_dir_name) ; \
	 )
	@( cd $(build_dir) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) docs ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBICAL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBICAL_PKG)/usr/share/man ]; then \
	  ( cd $(LIBICAL_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBICAL_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING $(SRC_DIR)/LICENSE \
	       $(LIBICAL_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LIBICAL_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING Install.txt LICENSE ReadMe.* THANKS TODO \
	         $(LIBICAL_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(build_dir)/apidocs ; \
	   cp -ar html \
	         $(LIBICAL_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBICAL_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(LIBICAL_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libical.pc ; \
	 )
	# ======= set libdir in the pkg-config *.pc files =======
	@( cd $(LIBICAL_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/lib$$,/lib$(LIBSUFFIX),g" libical.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBICAL_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libical.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBICAL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LIBICAL_PKG_DESCRIPTION_FILE): $(LIBICAL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBICAL_PKG_DESCRIPTION_FILE) $(LIBICAL_PKG_INSTALL_SCRIPT)
	@cp $(LIBICAL_PKG_DESCRIPTION_FILE) $(LIBICAL_PKG)/.DESCRIPTION
	@cp $(LIBICAL_PKG_INSTALL_SCRIPT) $(LIBICAL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBICAL_PKG)/.REQUIRES
	@echo "pkgname=$(LIBICAL_PKG_NAME)"                            >  $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBICAL_PKG_VERSION)"                          >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBICAL_PKG_ARCH)"                               >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBICAL_PKG_DISTRO_NAME)"                  >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBICAL_PKG_DISTRO_VERSION)"                >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "group=$(LIBICAL_PKG_GROUP)"                             >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBICAL_PKG_SHORT_DESCRIPTION)\"" >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "url=$(LIBICAL_PKG_URL)"                                 >> $(LIBICAL_PKG)/.PKGINFO ; \
	 echo "license=$(LIBICAL_PKG_LICENSE)"                         >> $(LIBICAL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBICAL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
