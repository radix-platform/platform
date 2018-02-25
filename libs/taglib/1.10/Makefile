
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
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
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


SOURCE_REQUIRES    = sources/packages/m/taglib

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.26
else
REQUIRES           = libs/glibc/2.26-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/taglib/taglib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/taglib-$(version)
src_dir_name       = taglib-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TAGLIB_PKG_NAME                = taglib
TAGLIB_PKG_VERSION             = 1.10
TAGLIB_PKG_ARCH                = $(TOOLCHAIN)
TAGLIB_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TAGLIB_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TAGLIB_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
TAGLIB_PKG_SHORT_DESCRIPTION   = audio meta-data library
TAGLIB_PKG_URL                 = $(BUG_URL)
TAGLIB_PKG_LICENSE             = LGPLv2.1
TAGLIB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TAGLIB_PKG_NAME)-pkg-description
TAGLIB_PKG_DESCRIPTION_FILE_IN = $(TAGLIB_PKG_NAME)-pkg-description.in
TAGLIB_PKG_INSTALL_SCRIPT      = $(TAGLIB_PKG_NAME)-pkg-install.sh

TAGLIB_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TAGLIB_PKG_NAME)-package

pkg_basename     = $(TAGLIB_PKG_NAME)-$(TAGLIB_PKG_VERSION)-$(TAGLIB_PKG_ARCH)-$(TAGLIB_PKG_DISTRO_NAME)-$(TAGLIB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(TAGLIB_PKG)


configure_switches  = CXX=$(CC)
configure_switches += -DCMAKE_INSTALL_PREFIX=/usr
configure_switches += -DCMAKE_BUILD_TYPE=Release
configure_switches += -DLIB_SUFFIX="$(LIBSUFFIX)"
configure_switches += -DWITH_MP4=ON
configure_switches += -DWITH_ASF=ON


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) cmake $(configure_switches) . ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) VERBOSE=1 $(MAKE)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) docs
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(TAGLIB_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@if [ -d $(TAGLIB_PKG)/usr/share/man ]; then \
	  ( cd $(TAGLIB_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(TAGLIB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(TAGLIB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TAGLIB_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS doc/taglib.png doc/html \
	         $(TAGLIB_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(TAGLIB_PKG)/usr/share/doc/$(src_dir_name)/html ; rm -f *.dot *.md5 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(TAGLIB_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TAGLIB_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" taglib.pc taglib_c.pc \
	 )
	# ======= tune taglib-config script the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" taglib-config \
	 )
	# ======= Strip binaries =======
	@( cd $(TAGLIB_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(TAGLIB_PKG_DESCRIPTION_FILE): $(TAGLIB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TAGLIB_PKG_DESCRIPTION_FILE) $(TAGLIB_PKG_INSTALL_SCRIPT)
	@cp $(TAGLIB_PKG_DESCRIPTION_FILE) $(TAGLIB_PKG)/.DESCRIPTION
	@cp $(TAGLIB_PKG_INSTALL_SCRIPT) $(TAGLIB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TAGLIB_PKG)/.REQUIRES
	@echo "pkgname=$(TAGLIB_PKG_NAME)"                            >  $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TAGLIB_PKG_VERSION)"                          >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "arch=$(TAGLIB_PKG_ARCH)"                               >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "distroname=$(TAGLIB_PKG_DISTRO_NAME)"                  >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "distrover=$(TAGLIB_PKG_DISTRO_VERSION)"                >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "group=$(TAGLIB_PKG_GROUP)"                             >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TAGLIB_PKG_SHORT_DESCRIPTION)\"" >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "url=$(TAGLIB_PKG_URL)"                                 >> $(TAGLIB_PKG)/.PKGINFO ; \
	 echo "license=$(TAGLIB_PKG_LICENSE)"                         >> $(TAGLIB_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(TAGLIB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
