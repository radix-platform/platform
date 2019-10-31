
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
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/packages/l/libedit

REQUIRES           = libs/ncurses/6.1

# ======= __END_OF_REQUIRES__ =======


version            = 20191025-3.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libedit/libedit-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libedit-$(version)
src_dir_name       = libedit-$(version)
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
LIBEDIT_PKG_NAME                = libedit
LIBEDIT_PKG_VERSION             = 20191025-3.1
LIBEDIT_PKG_ARCH                = $(TOOLCHAIN)
LIBEDIT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEDIT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEDIT_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBEDIT_PKG_SHORT_DESCRIPTION   = Command line editor library
LIBEDIT_PKG_URL                 = $(BUG_URL)
LIBEDIT_PKG_LICENSE             = BSD
LIBEDIT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEDIT_PKG_NAME)-pkg-description
LIBEDIT_PKG_DESCRIPTION_FILE_IN = $(LIBEDIT_PKG_NAME)-pkg-description.in
LIBEDIT_PKG_INSTALL_SCRIPT      = $(LIBEDIT_PKG_NAME)-pkg-install.sh

LIBEDIT_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEDIT_PKG_NAME)-package

pkg_basename     = $(LIBEDIT_PKG_NAME)-$(LIBEDIT_PKG_VERSION)-$(LIBEDIT_PKG_ARCH)-$(LIBEDIT_PKG_DISTRO_NAME)-$(LIBEDIT_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBEDIT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-widec

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
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
	@mkdir -p $(LIBEDIT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Remove files conflicting with readline: =======
	@rm -f $(LIBEDIT_PKG)/usr/share/man/man3/history.3*
	# ======= Install Documentation =======
	@if [ -d $(LIBEDIT_PKG)/usr/share/man ]; then \
	  ( cd $(LIBEDIT_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBEDIT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBEDIT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBEDIT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL THANKS \
	         $(LIBEDIT_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBEDIT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEDIT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libedit.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEDIT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libedit.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libedit.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libedit.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBEDIT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBEDIT_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBEDIT_PKG_DESCRIPTION_FILE): $(LIBEDIT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEDIT_PKG_DESCRIPTION_FILE) $(LIBEDIT_PKG_INSTALL_SCRIPT)
	@cp $(LIBEDIT_PKG_DESCRIPTION_FILE) $(LIBEDIT_PKG)/.DESCRIPTION
	@cp $(LIBEDIT_PKG_INSTALL_SCRIPT) $(LIBEDIT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEDIT_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEDIT_PKG_NAME)"                            >  $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEDIT_PKG_VERSION)"                          >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEDIT_PKG_ARCH)"                               >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEDIT_PKG_DISTRO_NAME)"                  >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEDIT_PKG_DISTRO_VERSION)"                >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEDIT_PKG_GROUP)"                             >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEDIT_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEDIT_PKG_URL)"                                 >> $(LIBEDIT_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEDIT_PKG_LICENSE)"                         >> $(LIBEDIT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBEDIT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
