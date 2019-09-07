
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


SOURCE_REQUIRES    = sources/packages/n/libgcrypt

REQUIRES           = net/libassuan/2.1.2
REQUIRES          += net/libksba/1.3.1
REQUIRES          += libs/pth/2.0.7

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libgcrypt/libgcrypt-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libgcrypt-$(version)
src_dir_name       = libgcrypt-$(version)
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
GCRYPT_PKG_NAME                = libgcrypt
GCRYPT_PKG_VERSION             = 1.6.2
GCRYPT_PKG_ARCH                = $(TOOLCHAIN)
GCRYPT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GCRYPT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GCRYPT_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
GCRYPT_PKG_SHORT_DESCRIPTION   = General purpose crypto library
GCRYPT_PKG_URL                 = $(BUG_URL)
GCRYPT_PKG_LICENSE             = GPLv2
GCRYPT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GCRYPT_PKG_NAME)-pkg-description
GCRYPT_PKG_DESCRIPTION_FILE_IN = $(GCRYPT_PKG_NAME)-pkg-description.in
GCRYPT_PKG_INSTALL_SCRIPT      = $(GCRYPT_PKG_NAME)-pkg-install.sh

GCRYPT_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GCRYPT_PKG_NAME)-package

pkg_basename     = $(GCRYPT_PKG_NAME)-$(GCRYPT_PKG_VERSION)-$(GCRYPT_PKG_ARCH)-$(GCRYPT_PKG_DISTRO_NAME)-$(GCRYPT_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GCRYPT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

ifneq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC) $(TOOLCHAIN_I686_GLIBC)),)
extra_configure_switches += --disable-asm
endif

libs_config  = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config
libs_config += PTH_CONFIG=$(TARGET_DEST_DIR)/usr/bin/pth-config


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(libs_config) LIBS=-lpth ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GCRYPT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(GCRYPT_PKG)/lib$(LIBSUFFIX)
	@( cd $(GCRYPT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod +w lib*.so.*.*.? ; \
	   mv lib*.so.*.*.? ../../lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.*.*.? . ; \
	   cp -a lib*.so.?? ../../lib$(LIBSUFFIX) ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(GCRYPT_PKG)/usr/share/info/dir
	@gzip -9 $(GCRYPT_PKG)/usr/share/info/*
	@if [ -d $(GCRYPT_PKG)/usr/share/man ]; then \
	  ( cd $(GCRYPT_PKG)/usr/share/man ; \
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
	@mkdir -p $(GCRYPT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(GCRYPT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GCRYPT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL LICENSES NEWS README* THANKS TODO VERSION \
	         doc/DCO doc/HACKING doc/README* doc/fips-fsm.pdf doc/libgcrypt-modules.pdf \
	         $(GCRYPT_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GCRYPT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GCRYPT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgcrypt.la ; \
	 )
	@( cd $(GCRYPT_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgcrypt-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GCRYPT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgcrypt.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgcrypt.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,prefix=\"/usr,prefix=\"$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	   sed -i "s,libdir=\"/usr,libdir=\"$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	   sed -i "s,-I/usr,-I$(TARGET_DEST_DIR)/usr,g" libgcrypt-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GCRYPT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GCRYPT_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GCRYPT_PKG)/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GCRYPT_PKG_DESCRIPTION_FILE): $(GCRYPT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GCRYPT_PKG_DESCRIPTION_FILE) $(GCRYPT_PKG_INSTALL_SCRIPT)
	@cp $(GCRYPT_PKG_DESCRIPTION_FILE) $(GCRYPT_PKG)/.DESCRIPTION
	@cp $(GCRYPT_PKG_INSTALL_SCRIPT) $(GCRYPT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GCRYPT_PKG)/.REQUIRES
	@echo "pkgname=$(GCRYPT_PKG_NAME)"                            >  $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GCRYPT_PKG_VERSION)"                          >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "arch=$(GCRYPT_PKG_ARCH)"                               >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "distroname=$(GCRYPT_PKG_DISTRO_NAME)"                  >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "distrover=$(GCRYPT_PKG_DISTRO_VERSION)"                >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "group=$(GCRYPT_PKG_GROUP)"                             >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GCRYPT_PKG_SHORT_DESCRIPTION)\"" >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "url=$(GCRYPT_PKG_URL)"                                 >> $(GCRYPT_PKG)/.PKGINFO ; \
	 echo "license=$(GCRYPT_PKG_LICENSE)"                         >> $(GCRYPT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GCRYPT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
