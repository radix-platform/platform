
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


SOURCE_REQUIRES    = sources/packages/m/zvbi

REQUIRES           = libs/libpng/libpng14/1.4.19
REQUIRES          += X11/X.org/lib/libX11/1.6.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.2.35
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/zvbi/zvbi-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/zvbi-$(version)
src_dir_name       = zvbi-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ZVBI_PKG_NAME                = zvbi
ZVBI_PKG_VERSION             = 0.2.35
ZVBI_PKG_ARCH                = $(TOOLCHAIN)
ZVBI_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ZVBI_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ZVBI_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
ZVBI_PKG_SHORT_DESCRIPTION   = The Zapping VBI library
ZVBI_PKG_URL                 = $(BUG_URL)
ZVBI_PKG_LICENSE             = GPLv2
ZVBI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ZVBI_PKG_NAME)-pkg-description
ZVBI_PKG_DESCRIPTION_FILE_IN = $(ZVBI_PKG_NAME)-pkg-description.in
ZVBI_PKG_INSTALL_SCRIPT      = $(ZVBI_PKG_NAME)-pkg-install.sh

ZVBI_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ZVBI_PKG_NAME)-package

pkg_basename     = $(ZVBI_PKG_NAME)-$(ZVBI_PKG_VERSION)-$(ZVBI_PKG_ARCH)-$(ZVBI_PKG_DISTRO_NAME)-$(ZVBI_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ZVBI_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --sbindir=/usr/sbin

extra_configure_switches += --enable-v4l
extra_configure_switches += --enable-dvb

extra_configure_switches += --with-pic
extra_configure_switches += --with-x

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-aggressive-loop-optimizations


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ZVBI_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(ZVBI_PKG)/usr/share/man ]; then \
	  ( cd $(ZVBI_PKG)/usr/share/man ; \
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
	@mkdir -p $(ZVBI_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(ZVBI_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ZVBI_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README TODO \
	         doc/html \
	         $(ZVBI_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ZVBI_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ZVBI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libzvbi-chains.la libzvbi.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ZVBI_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libzvbi-chains.la libzvbi.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libzvbi-chains.la libzvbi.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" zvbi-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ZVBI_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(ZVBI_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(ZVBI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ZVBI_PKG_DESCRIPTION_FILE): $(ZVBI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ZVBI_PKG_DESCRIPTION_FILE) $(ZVBI_PKG_INSTALL_SCRIPT)
	@cp $(ZVBI_PKG_DESCRIPTION_FILE) $(ZVBI_PKG)/.DESCRIPTION
	@cp $(ZVBI_PKG_INSTALL_SCRIPT) $(ZVBI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ZVBI_PKG)/.REQUIRES
	@echo "pkgname=$(ZVBI_PKG_NAME)"                            >  $(ZVBI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ZVBI_PKG_VERSION)"                          >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "arch=$(ZVBI_PKG_ARCH)"                               >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "distroname=$(ZVBI_PKG_DISTRO_NAME)"                  >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "distrover=$(ZVBI_PKG_DISTRO_VERSION)"                >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "group=$(ZVBI_PKG_GROUP)"                             >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ZVBI_PKG_SHORT_DESCRIPTION)\"" >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "url=$(ZVBI_PKG_URL)"                                 >> $(ZVBI_PKG)/.PKGINFO ; \
	 echo "license=$(ZVBI_PKG_LICENSE)"                         >> $(ZVBI_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(ZVBI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
