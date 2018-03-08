
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


SOURCE_REQUIRES    = sources/packages/l/npth

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.27
else
REQUIRES           = libs/glibc/2.27-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/npth/npth-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/npth-$(version)
src_dir_name       = npth-$(version)
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
NPTH_PKG_NAME                = npth
NPTH_PKG_VERSION             = 1.2
NPTH_PKG_ARCH                = $(TOOLCHAIN)
NPTH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
NPTH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
NPTH_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
NPTH_PKG_SHORT_DESCRIPTION   = The New GNU Portable Threads
NPTH_PKG_URL                 = $(BUG_URL)
NPTH_PKG_LICENSE             = GPLv2
NPTH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(NPTH_PKG_NAME)-pkg-description
NPTH_PKG_DESCRIPTION_FILE_IN = $(NPTH_PKG_NAME)-pkg-description.in
NPTH_PKG_INSTALL_SCRIPT      = $(NPTH_PKG_NAME)-pkg-install.sh

NPTH_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(NPTH_PKG_NAME)-package

pkg_basename     = $(NPTH_PKG_NAME)-$(NPTH_PKG_VERSION)-$(NPTH_PKG_ARCH)-$(NPTH_PKG_DISTRO_NAME)-$(NPTH_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(NPTH_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-tests
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
	@mkdir -p $(NPTH_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(NPTH_PKG)/usr/share/man ]; then \
	  ( cd $(NPTH_PKG)/usr/share/man ; \
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
	@mkdir -p $(NPTH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(NPTH_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(NPTH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* HACKING INSTALL NEWS README VERSION \
	         $(NPTH_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(NPTH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(NPTH_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnpth.la  \
	 )
	# ======= tune libs path in the target npth-config file =======
	@( cd $(NPTH_PKG)/usr/bin ; \
	   sed -i 's,^libs="-L/usr,libs="-L$${prefix},g' npth-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(NPTH_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnpth.la ; \
	 )
	# ======= tune npth-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,^prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" pth-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(NPTH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(NPTH_PKG_DESCRIPTION_FILE): $(NPTH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(NPTH_PKG_DESCRIPTION_FILE) $(NPTH_PKG_INSTALL_SCRIPT)
	@cp $(NPTH_PKG_DESCRIPTION_FILE) $(NPTH_PKG)/.DESCRIPTION
	@cp $(NPTH_PKG_INSTALL_SCRIPT) $(NPTH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(NPTH_PKG)/.REQUIRES
	@echo "pkgname=$(NPTH_PKG_NAME)"                            >  $(NPTH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(NPTH_PKG_VERSION)"                          >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "arch=$(NPTH_PKG_ARCH)"                               >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "distroname=$(NPTH_PKG_DISTRO_NAME)"                  >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "distrover=$(NPTH_PKG_DISTRO_VERSION)"                >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "group=$(NPTH_PKG_GROUP)"                             >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(NPTH_PKG_SHORT_DESCRIPTION)\"" >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "url=$(NPTH_PKG_URL)"                                 >> $(NPTH_PKG)/.PKGINFO ; \
	 echo "license=$(NPTH_PKG_LICENSE)"                         >> $(NPTH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(NPTH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
