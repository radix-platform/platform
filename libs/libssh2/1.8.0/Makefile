
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


SOURCE_REQUIRES    = sources/packages/l/libssh2

REQUIRES          += net/openssl/1.0.2f

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libssh2/libssh2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libssh2-$(version)
src_dir_name       = libssh2-$(version)
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
LIBSSH2_PKG_NAME                = libssh2
LIBSSH2_PKG_VERSION             = 1.8.0
LIBSSH2_PKG_ARCH                = $(TOOLCHAIN)
LIBSSH2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSSH2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSSH2_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBSSH2_PKG_SHORT_DESCRIPTION   = SSH2 library
LIBSSH2_PKG_URL                 = $(BUG_URL)
LIBSSH2_PKG_LICENSE             = BSD
LIBSSH2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSSH2_PKG_NAME)-pkg-description
LIBSSH2_PKG_DESCRIPTION_FILE_IN = $(LIBSSH2_PKG_NAME)-pkg-description.in
LIBSSH2_PKG_INSTALL_SCRIPT      = $(LIBSSH2_PKG_NAME)-pkg-install.sh

LIBSSH2_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSSH2_PKG_NAME)-package

pkg_basename     = $(LIBSSH2_PKG_NAME)-$(LIBSSH2_PKG_VERSION)-$(LIBSSH2_PKG_ARCH)-$(LIBSSH2_PKG_DISTRO_NAME)-$(LIBSSH2_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBSSH2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --with-openssl
extra_configure_switches += --with-libssl-prefix=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --with-libz
extra_configure_switches += --with-libz-prefix=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --disable-rpath

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


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
	@mkdir -p $(LIBSSH2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBSSH2_PKG)/usr/share/man ]; then \
	  ( cd $(LIBSSH2_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBSSH2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/docs/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBSSH2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBSSH2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a docs/AUTHORS docs/BINDINGS COPYING NEWS README* docs/SECURITY.md docs/TODO \
	         $(LIBSSH2_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBSSH2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSSH2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libssh2.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSSH2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libssh2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libssh2.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libssh2.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSSH2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBSSH2_PKG_DESCRIPTION_FILE): $(LIBSSH2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSSH2_PKG_DESCRIPTION_FILE) $(LIBSSH2_PKG_INSTALL_SCRIPT)
	@cp $(LIBSSH2_PKG_DESCRIPTION_FILE) $(LIBSSH2_PKG)/.DESCRIPTION
	@cp $(LIBSSH2_PKG_INSTALL_SCRIPT) $(LIBSSH2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSSH2_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSSH2_PKG_NAME)"                            >  $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSSH2_PKG_VERSION)"                          >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSSH2_PKG_ARCH)"                               >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSSH2_PKG_DISTRO_NAME)"                  >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSSH2_PKG_DISTRO_VERSION)"                >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSSH2_PKG_GROUP)"                             >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSSH2_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSSH2_PKG_URL)"                                 >> $(LIBSSH2_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSSH2_PKG_LICENSE)"                         >> $(LIBSSH2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSSH2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
