
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


SOURCE_REQUIRES    = sources/GNU/guile

REQUIRES           = libs/libffi/3.2.1
REQUIRES          += libs/gmp/6.1.0
REQUIRES          += libs/readline/6.3
REQUIRES          += dev/libtool/2.4.6
REQUIRES          += libs/libunistring/0.9.6
REQUIRES          += libs/gc/7.4.2

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.9
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/guile/guile-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/guile-$(version)
src_dir_name       = guile-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GUILE_PKG_NAME                = guile
GUILE_PKG_VERSION             = 2.0.9
GUILE_PKG_ARCH                = $(TOOLCHAIN)
GUILE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GUILE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GUILE_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
GUILE_PKG_SHORT_DESCRIPTION   = GNU extension language library
GUILE_PKG_URL                 = $(BUG_URL)
GUILE_PKG_LICENSE             = GPLv2
GUILE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GUILE_PKG_NAME)-pkg-description
GUILE_PKG_DESCRIPTION_FILE_IN = $(GUILE_PKG_NAME)-pkg-description.in
GUILE_PKG_INSTALL_SCRIPT      = $(GUILE_PKG_NAME)-pkg-install.sh

GUILE_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GUILE_PKG_NAME)-package

pkg_basename     = $(GUILE_PKG_NAME)-$(GUILE_PKG_VERSION)-$(GUILE_PKG_ARCH)-$(GUILE_PKG_DISTRO_NAME)-$(GUILE_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GUILE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-threads
extra_configure_switches += --disable-error-on-warning
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

# Тhе road to hellis paved with good intentions:
extra_configure_switches += --without-libltdl-prefix
extra_configure_switches += --without-libgmp-prefix
extra_configure_switches += --without-libreadline-prefix


GUILE_LOAD_PATH   = ../../$(src_dir_name)/module
guile_environment = GUILE_LOAD_PATH=$(GUILE_LOAD_PATH)


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(guile_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GUILE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(GUILE_PKG)/usr/share/info/dir
	@gzip -9 $(GUILE_PKG)/usr/share/info/*
	@if [ -d $(GUILE_PKG)/usr/share/man ]; then \
	  ( cd $(GUILE_PKG)/usr/share/man ; \
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
	@mkdir -p $(GUILE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(GUILE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GUILE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* GUILE-VERSION \
	         HACKING INSTALL LICENSE NEWS README* THANKS \
	         $(GUILE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GUILE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GUILE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libguile-?.?.la libguilereadline-v-??.la \
	 )
	@( cd $(GUILE_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" guile-?.?.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GUILE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libguile-?.?.la libguilereadline-v-??.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libguile-?.?.la libguilereadline-v-??.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" guile-?.?.pc ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" guile-?.?.pc \
	 )
	# ======= tune guile-snarf for target system =======
	@( cd $(GUILE_PKG)/usr/bin ; \
	   sed -i "s,\"/opt/toolchain/.*\",\"gcc -m32 -E\",g" guile-snarf ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GUILE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GUILE_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GUILE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GUILE_PKG_DESCRIPTION_FILE): $(GUILE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GUILE_PKG_DESCRIPTION_FILE) $(GUILE_PKG_INSTALL_SCRIPT)
	@cp $(GUILE_PKG_DESCRIPTION_FILE) $(GUILE_PKG)/.DESCRIPTION
	@cp $(GUILE_PKG_INSTALL_SCRIPT) $(GUILE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GUILE_PKG)/.REQUIRES
	@echo "pkgname=$(GUILE_PKG_NAME)"                            >  $(GUILE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GUILE_PKG_VERSION)"                          >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "arch=$(GUILE_PKG_ARCH)"                               >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "distroname=$(GUILE_PKG_DISTRO_NAME)"                  >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "distrover=$(GUILE_PKG_DISTRO_VERSION)"                >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "group=$(GUILE_PKG_GROUP)"                             >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GUILE_PKG_SHORT_DESCRIPTION)\"" >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "url=$(GUILE_PKG_URL)"                                 >> $(GUILE_PKG)/.PKGINFO ; \
	 echo "license=$(GUILE_PKG_LICENSE)"                         >> $(GUILE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GUILE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
