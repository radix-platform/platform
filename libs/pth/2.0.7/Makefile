
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


SOURCE_REQUIRES    = sources/GNU/pth

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


version            = 2.0.7
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/pth/pth-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pth-$(version)
src_dir_name       = pth-$(version)
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
PTH_PKG_NAME                = pth
PTH_PKG_VERSION             = 2.0.7
PTH_PKG_ARCH                = $(TOOLCHAIN)
PTH_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PTH_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PTH_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
PTH_PKG_SHORT_DESCRIPTION   = GNU Portable Threads
PTH_PKG_URL                 = $(BUG_URL)
PTH_PKG_LICENSE             = GPLv2
PTH_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PTH_PKG_NAME)-pkg-description
PTH_PKG_DESCRIPTION_FILE_IN = $(PTH_PKG_NAME)-pkg-description.in
PTH_PKG_INSTALL_SCRIPT      = $(PTH_PKG_NAME)-pkg-install.sh

PTH_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PTH_PKG_NAME)-package

pkg_basename     = $(PTH_PKG_NAME)-$(PTH_PKG_VERSION)-$(PTH_PKG_ARCH)-$(PTH_PKG_DISTRO_NAME)-$(PTH_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PTH_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-pthread=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
# The context switching is done by SUSv2 makecontext(2)
extra_configure_switches += --with-mctx-mth=mcsc
endif


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PTH_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PTH_PKG)/usr/share/man ]; then \
	  ( cd $(PTH_PKG)/usr/share/man ; \
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
	@mkdir -p $(PTH_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PTH_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PTH_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE AUTHORS COPYING* HACKING HISTORY \
	         INSTALL NEWS PORTING README* SUPPORT TESTS THANKS USERS \
	         $(PTH_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PTH_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target pth-config file =======
	@( cd $(PTH_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" pth-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PTH_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpth.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pth-config ; \
	   sed -i "s,-L/lib,-L$(TARGET_DEST_DIR)/lib,g" pth-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PTH_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PTH_PKG_DESCRIPTION_FILE): $(PTH_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PTH_PKG_DESCRIPTION_FILE) $(PTH_PKG_INSTALL_SCRIPT)
	@cp $(PTH_PKG_DESCRIPTION_FILE) $(PTH_PKG)/.DESCRIPTION
	@cp $(PTH_PKG_INSTALL_SCRIPT) $(PTH_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PTH_PKG)/.REQUIRES
	@echo "pkgname=$(PTH_PKG_NAME)"                            >  $(PTH_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PTH_PKG_VERSION)"                          >> $(PTH_PKG)/.PKGINFO ; \
	 echo "arch=$(PTH_PKG_ARCH)"                               >> $(PTH_PKG)/.PKGINFO ; \
	 echo "distroname=$(PTH_PKG_DISTRO_NAME)"                  >> $(PTH_PKG)/.PKGINFO ; \
	 echo "distrover=$(PTH_PKG_DISTRO_VERSION)"                >> $(PTH_PKG)/.PKGINFO ; \
	 echo "group=$(PTH_PKG_GROUP)"                             >> $(PTH_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PTH_PKG_SHORT_DESCRIPTION)\"" >> $(PTH_PKG)/.PKGINFO ; \
	 echo "url=$(PTH_PKG_URL)"                                 >> $(PTH_PKG)/.PKGINFO ; \
	 echo "license=$(PTH_PKG_LICENSE)"                         >> $(PTH_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PTH_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
