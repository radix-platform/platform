
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


SOURCE_REQUIRES    = sources/packages/n/libtirpc

ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.26
else
REQUIRES           = libs/glibc/2.26-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libtirpc/libtirpc-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libtirpc-$(version)
src_dir_name       = libtirpc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBTIRPC_PKG_NAME                = libtirpc
LIBTIRPC_PKG_VERSION             = 1.0.1
LIBTIRPC_PKG_ARCH                = $(TOOLCHAIN)
LIBTIRPC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBTIRPC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBTIRPC_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBTIRPC_PKG_SHORT_DESCRIPTION   = Transport-Independent RPC library
LIBTIRPC_PKG_URL                 = $(BUG_URL)
LIBTIRPC_PKG_LICENSE             = BSD
LIBTIRPC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBTIRPC_PKG_NAME)-pkg-description
LIBTIRPC_PKG_DESCRIPTION_FILE_IN = $(LIBTIRPC_PKG_NAME)-pkg-description.in
LIBTIRPC_PKG_INSTALL_SCRIPT      = $(LIBTIRPC_PKG_NAME)-pkg-install.sh

LIBTIRPC_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBTIRPC_PKG_NAME)-package

pkg_basename     = $(LIBTIRPC_PKG_NAME)-$(LIBTIRPC_PKG_VERSION)-$(LIBTIRPC_PKG_ARCH)-$(LIBTIRPC_PKG_DISTRO_NAME)-$(LIBTIRPC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBTIRPC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-gssapi
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBTIRPC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LIBTIRPC_PKG)/etc ; mv netconfig netconfig.new )
	# ======= Install Documentation =======
	@if [ -d $(LIBTIRPC_PKG)/usr/share/man ]; then \
	  ( cd $(LIBTIRPC_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.* ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBTIRPC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBTIRPC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBTIRPC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL NEWS README THANKS TODO VERSION \
	         $(LIBTIRPC_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBTIRPC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBTIRPC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libtirpc.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBTIRPC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtirpc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libtirpc.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtirpc.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBTIRPC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBTIRPC_PKG_DESCRIPTION_FILE): $(LIBTIRPC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBTIRPC_PKG_DESCRIPTION_FILE) $(LIBTIRPC_PKG_INSTALL_SCRIPT)
	@cp $(LIBTIRPC_PKG_DESCRIPTION_FILE) $(LIBTIRPC_PKG)/.DESCRIPTION
	@cp $(LIBTIRPC_PKG_INSTALL_SCRIPT) $(LIBTIRPC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBTIRPC_PKG)/.REQUIRES
	@echo "pkgname=$(LIBTIRPC_PKG_NAME)"                            >  $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBTIRPC_PKG_VERSION)"                          >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBTIRPC_PKG_ARCH)"                               >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBTIRPC_PKG_DISTRO_NAME)"                  >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBTIRPC_PKG_DISTRO_VERSION)"                >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "group=$(LIBTIRPC_PKG_GROUP)"                             >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBTIRPC_PKG_SHORT_DESCRIPTION)\"" >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "url=$(LIBTIRPC_PKG_URL)"                                 >> $(LIBTIRPC_PKG)/.PKGINFO ; \
	 echo "license=$(LIBTIRPC_PKG_LICENSE)"                         >> $(LIBTIRPC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBTIRPC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
