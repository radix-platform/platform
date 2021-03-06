
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/ieee1394/libiec61883

REQUIRES           = libs/libraw1394/2.1.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/ieee1394/libiec61883/libiec61883-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libiec61883-$(version)
src_dir_name       = libiec61883-$(version)
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
IEC61883_PKG_NAME                = libiec61883
IEC61883_PKG_VERSION             = 1.2.0
IEC61883_PKG_ARCH                = $(TOOLCHAIN)
IEC61883_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IEC61883_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IEC61883_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
IEC61883_PKG_SHORT_DESCRIPTION   = IEC 61883 implementation
IEC61883_PKG_URL                 = $(BUG_URL)
IEC61883_PKG_LICENSE             = LGPLv2.1
IEC61883_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IEC61883_PKG_NAME)-pkg-description
IEC61883_PKG_DESCRIPTION_FILE_IN = $(IEC61883_PKG_NAME)-pkg-description.in
IEC61883_PKG_INSTALL_SCRIPT      = $(IEC61883_PKG_NAME)-pkg-install.sh

IEC61883_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IEC61883_PKG_NAME)-package

pkg_basename     = $(IEC61883_PKG_NAME)-$(IEC61883_PKG_VERSION)-$(IEC61883_PKG_ARCH)-$(IEC61883_PKG_DISTRO_NAME)-$(IEC61883_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(IEC61883_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IEC61883_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(IEC61883_PKG)/usr/share/man ]; then \
	  ( cd $(IEC61883_PKG)/usr/share/man ; \
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
	@mkdir -p $(IEC61883_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(IEC61883_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IEC61883_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(IEC61883_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IEC61883_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ====== remove toolchain path from target libtool *.la files ======
	@( cd $(IEC61883_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libiec61883.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IEC61883_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiec61883.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libiec61883.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libiec61883.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(IEC61883_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(IEC61883_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(IEC61883_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IEC61883_PKG_DESCRIPTION_FILE): $(IEC61883_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IEC61883_PKG_DESCRIPTION_FILE) $(IEC61883_PKG_INSTALL_SCRIPT)
	@cp $(IEC61883_PKG_DESCRIPTION_FILE) $(IEC61883_PKG)/.DESCRIPTION
	@cp $(IEC61883_PKG_INSTALL_SCRIPT) $(IEC61883_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IEC61883_PKG)/.REQUIRES
	@echo "pkgname=$(IEC61883_PKG_NAME)"                            >  $(IEC61883_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IEC61883_PKG_VERSION)"                          >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "arch=$(IEC61883_PKG_ARCH)"                               >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "distroname=$(IEC61883_PKG_DISTRO_NAME)"                  >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "distrover=$(IEC61883_PKG_DISTRO_VERSION)"                >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "group=$(IEC61883_PKG_GROUP)"                             >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IEC61883_PKG_SHORT_DESCRIPTION)\"" >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "url=$(IEC61883_PKG_URL)"                                 >> $(IEC61883_PKG)/.PKGINFO ; \
	 echo "license=$(IEC61883_PKG_LICENSE)"                         >> $(IEC61883_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IEC61883_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
