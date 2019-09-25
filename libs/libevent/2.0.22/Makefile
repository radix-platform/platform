
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


SOURCE_REQUIRES    = sources/packages/l/libevent

REQUIRES           = net/openssl/1.0.2f

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.22
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libevent/libevent-$(version)-stable.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libevent-$(version)-stable
src_dir_name       = libevent-$(version)-stable
doc_dir_name       = libevent-$(version)
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
LIBEVENT_PKG_NAME                = libevent
LIBEVENT_PKG_VERSION             = 2.0.22
LIBEVENT_PKG_ARCH                = $(TOOLCHAIN)
LIBEVENT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEVENT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEVENT_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBEVENT_PKG_SHORT_DESCRIPTION   = event loop library
LIBEVENT_PKG_URL                 = $(BUG_URL)
LIBEVENT_PKG_LICENSE             = BSD
LIBEVENT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEVENT_PKG_NAME)-pkg-description
LIBEVENT_PKG_DESCRIPTION_FILE_IN = $(LIBEVENT_PKG_NAME)-pkg-description.in
LIBEVENT_PKG_INSTALL_SCRIPT      = $(LIBEVENT_PKG_NAME)-pkg-install.sh

LIBEVENT_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEVENT_PKG_NAME)-package

pkg_basename     = $(LIBEVENT_PKG_NAME)-$(LIBEVENT_PKG_VERSION)-$(LIBEVENT_PKG_ARCH)-$(LIBEVENT_PKG_DISTRO_NAME)-$(LIBEVENT_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBEVENT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-static


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
	@mkdir -p $(LIBEVENT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@mkdir -p $(LIBEVENT_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(LIBEVENT_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LIBEVENT_PKG)/usr/share/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE $(SRC_DIR)/README \
	       $(LIBEVENT_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBEVENT_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEVENT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libevent.la          \
	                                    libevent_core.la     \
	                                    libevent_extra.la    \
	                                    libevent_openssl.la  \
	                                    libevent_pthreads.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEVENT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libevent.la            \
	                                            libevent_core.la       \
	                                            libevent_extra.la      \
	                                            libevent_openssl.la    \
	                                            libevent_pthreads.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libevent.la          \
	                                              libevent_core.la     \
	                                              libevent_extra.la    \
	                                              libevent_openssl.la  \
	                                              libevent_pthreads.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libevent.pc          \
	                                            libevent_openssl.pc  \
	                                            libevent_pthreads.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBEVENT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBEVENT_PKG_DESCRIPTION_FILE): $(LIBEVENT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEVENT_PKG_DESCRIPTION_FILE) $(LIBEVENT_PKG_INSTALL_SCRIPT)
	@cp $(LIBEVENT_PKG_DESCRIPTION_FILE) $(LIBEVENT_PKG)/.DESCRIPTION
	@cp $(LIBEVENT_PKG_INSTALL_SCRIPT) $(LIBEVENT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEVENT_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEVENT_PKG_NAME)"                            >  $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEVENT_PKG_VERSION)"                          >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEVENT_PKG_ARCH)"                               >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEVENT_PKG_DISTRO_NAME)"                  >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEVENT_PKG_DISTRO_VERSION)"                >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEVENT_PKG_GROUP)"                             >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEVENT_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEVENT_PKG_URL)"                                 >> $(LIBEVENT_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEVENT_PKG_LICENSE)"                         >> $(LIBEVENT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBEVENT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
