
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


SOURCE_REQUIRES    = sources/packages/n/p11-kit

REQUIRES           = libs/libffi/3.2.1
REQUIRES          += libs/libtasn1/3.4

# ======= __END_OF_REQUIRES__ =======


version            = 0.20.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/p11-kit/p11-kit-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/p11-kit-$(version)
src_dir_name       = p11-kit-$(version)
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
P11KIT_PKG_NAME                = p11-kit
P11KIT_PKG_VERSION             = 0.20.2
P11KIT_PKG_ARCH                = $(TOOLCHAIN)
P11KIT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
P11KIT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
P11KIT_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
P11KIT_PKG_SHORT_DESCRIPTION   = PKCS 11 toolkit
P11KIT_PKG_URL                 = $(BUG_URL)
P11KIT_PKG_LICENSE             = GPLv2
P11KIT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(P11KIT_PKG_NAME)-pkg-description
P11KIT_PKG_DESCRIPTION_FILE_IN = $(P11KIT_PKG_NAME)-pkg-description.in
P11KIT_PKG_INSTALL_SCRIPT      = $(P11KIT_PKG_NAME)-pkg-install.sh

P11KIT_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(P11KIT_PKG_NAME)-package

pkg_basename     = $(P11KIT_PKG_NAME)-$(P11KIT_PKG_VERSION)-$(P11KIT_PKG_ARCH)-$(P11KIT_PKG_DISTRO_NAME)-$(P11KIT_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(P11KIT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-doc
extra_configure_switches += --enable-doc-html


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	# ======= Disable parallel buildig p11-kit docunentation =======
	@( cd $(build_dir)/doc/manual ; \
	   sed -i '/all: all-am/i.NOTPARALLEL: all\n' Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(P11KIT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(P11KIT_PKG)/etc/pkcs11/modules
	# ======= Install Documentation =======
	@if [ -d $(P11KIT_PKG)/usr/share/man ]; then \
	  ( cd $(P11KIT_PKG)/usr/share/man ; \
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
	@mkdir -p $(P11KIT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(P11KIT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(P11KIT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING NEWS README \
	         $(P11KIT_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/p11-kit $(P11KIT_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(P11KIT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(P11KIT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libp11-kit.la ; \
	 )
	@( cd $(P11KIT_PKG)/usr/lib$(LIBSUFFIX)/pkcs11 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" p11-kit-trust.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(P11KIT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libp11-kit.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libp11-kit.la  \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkcs11 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" p11-kit-trust.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" p11-kit-trust.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" p11-kit-1.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(P11KIT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(P11KIT_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(P11KIT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(P11KIT_PKG_DESCRIPTION_FILE): $(P11KIT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(P11KIT_PKG_DESCRIPTION_FILE) $(P11KIT_PKG_INSTALL_SCRIPT)
	@cp $(P11KIT_PKG_DESCRIPTION_FILE) $(P11KIT_PKG)/.DESCRIPTION
	@cp $(P11KIT_PKG_INSTALL_SCRIPT) $(P11KIT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(P11KIT_PKG)/.REQUIRES
	@echo "pkgname=$(P11KIT_PKG_NAME)"                            >  $(P11KIT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(P11KIT_PKG_VERSION)"                          >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "arch=$(P11KIT_PKG_ARCH)"                               >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "distroname=$(P11KIT_PKG_DISTRO_NAME)"                  >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "distrover=$(P11KIT_PKG_DISTRO_VERSION)"                >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "group=$(P11KIT_PKG_GROUP)"                             >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(P11KIT_PKG_SHORT_DESCRIPTION)\"" >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "url=$(P11KIT_PKG_URL)"                                 >> $(P11KIT_PKG)/.PKGINFO ; \
	 echo "license=$(P11KIT_PKG_LICENSE)"                         >> $(P11KIT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(P11KIT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
