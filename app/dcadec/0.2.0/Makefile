
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/dcadec

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES          += libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.2.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/dcadec/dcadec-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dcadec-$(version)
src_dir_name       = dcadec-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DCADEC_PKG_NAME                = dcadec
DCADEC_PKG_VERSION             = 0.2.0
DCADEC_PKG_ARCH                = $(TOOLCHAIN)
DCADEC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DCADEC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DCADEC_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
DCADEC_PKG_SHORT_DESCRIPTION   = DTS Coherent Acoustics decoder
DCADEC_PKG_URL                 = $(BUG_URL)
DCADEC_PKG_LICENSE             = LGPLv2.1
DCADEC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DCADEC_PKG_NAME)-pkg-description
DCADEC_PKG_DESCRIPTION_FILE_IN = $(DCADEC_PKG_NAME)-pkg-description.in
DCADEC_PKG_INSTALL_SCRIPT      = $(DCADEC_PKG_NAME)-pkg-install.sh

DCADEC_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DCADEC_PKG_NAME)-package

pkg_basename     = $(DCADEC_PKG_NAME)-$(DCADEC_PKG_VERSION)-$(DCADEC_PKG_ARCH)-$(DCADEC_PKG_DISTRO_NAME)-$(DCADEC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DCADEC_PKG)


CFLAGS += -Wno-unused-but-set-variable


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) CONFIG_SHARED=yes               \
	                                PREFIX="/usr"                   \
	                                BINDIR="/usr/bin"               \
	                                LIBDIR="/usr/lib$(LIBSUFFIX)" ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DCADEC_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 CONFIG_SHARED=yes              \
	                                    PREFIX="/usr"                  \
	                                    BINDIR="/usr/bin"              \
	                                    LIBDIR="/usr/lib$(LIBSUFFIX)"  \
	                                          $(env_sysroot) install ; \
	 )
	@mv $(DCADEC_PKG)/usr/bin/dcadec{,-hd}
	@chmod 755 $(DCADEC_PKG)/usr/lib$(LIBSUFFIX)/libdcadec.so.?.?.?
	# ======= Install Documentation =======
	@if [ -d $(DCADEC_PKG)/usr/share/man ]; then \
	  ( cd $(DCADEC_PKG)/usr/share/man ; \
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
	@mkdir -p $(DCADEC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(DCADEC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DCADEC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* README* \
	         $(DCADEC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG.md ]; then \
	     DOCSDIR=`echo $(DCADEC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG.md | head -n 1000 > $$DOCSDIR/CHANGELOG.md ; \
	     touch -r CHANGELOG.md $$DOCSDIR/CHANGELOG.md ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DCADEC_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dcadec.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(DCADEC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(DCADEC_PKG_DESCRIPTION_FILE): $(DCADEC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DCADEC_PKG_DESCRIPTION_FILE) $(DCADEC_PKG_INSTALL_SCRIPT)
	@cp $(DCADEC_PKG_DESCRIPTION_FILE) $(DCADEC_PKG)/.DESCRIPTION
	@cp $(DCADEC_PKG_INSTALL_SCRIPT) $(DCADEC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DCADEC_PKG)/.REQUIRES
	@echo "pkgname=$(DCADEC_PKG_NAME)"                            >  $(DCADEC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DCADEC_PKG_VERSION)"                          >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "arch=$(DCADEC_PKG_ARCH)"                               >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "distroname=$(DCADEC_PKG_DISTRO_NAME)"                  >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "distrover=$(DCADEC_PKG_DISTRO_VERSION)"                >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "group=$(DCADEC_PKG_GROUP)"                             >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DCADEC_PKG_SHORT_DESCRIPTION)\"" >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "url=$(DCADEC_PKG_URL)"                                 >> $(DCADEC_PKG)/.PKGINFO ; \
	 echo "license=$(DCADEC_PKG_LICENSE)"                         >> $(DCADEC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DCADEC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
