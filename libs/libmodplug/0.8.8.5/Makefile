
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


SOURCE_REQUIRES    = sources/packages/m/libmodplug

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES           = libs/glibc/2.25
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.8.8.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libmodplug/libmodplug-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libmodplug-$(version)
src_dir_name       = libmodplug-$(version)
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
MODPLUG_PKG_NAME                = libmodplug
MODPLUG_PKG_VERSION             = 0.8.8.5
MODPLUG_PKG_ARCH                = $(TOOLCHAIN)
MODPLUG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MODPLUG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MODPLUG_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
MODPLUG_PKG_SHORT_DESCRIPTION   = A MOD playing library
MODPLUG_PKG_URL                 = $(BUG_URL)
MODPLUG_PKG_LICENSE             = custom
MODPLUG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MODPLUG_PKG_NAME)-pkg-description
MODPLUG_PKG_DESCRIPTION_FILE_IN = $(MODPLUG_PKG_NAME)-pkg-description.in
MODPLUG_PKG_INSTALL_SCRIPT      = $(MODPLUG_PKG_NAME)-pkg-install.sh

MODPLUG_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MODPLUG_PKG_NAME)-package

pkg_basename     = $(MODPLUG_PKG_NAME)-$(MODPLUG_PKG_VERSION)-$(MODPLUG_PKG_ARCH)-$(MODPLUG_PKG_DISTRO_NAME)-$(MODPLUG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MODPLUG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


CXXFLAGS += -Wno-unused-but-set-variable -Wno-unused-function -Wno-sign-compare

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
	@mkdir -p $(MODPLUG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(MODPLUG_PKG)/usr/share/man ]; then \
	  ( cd $(MODPLUG_PKG)/usr/share/man ; \
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
	@mkdir -p $(MODPLUG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(MODPLUG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MODPLUG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README TODO \
	         $(MODPLUG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MODPLUG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MODPLUG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmodplug.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MODPLUG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmodplug.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmodplug.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmodplug.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(MODPLUG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MODPLUG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MODPLUG_PKG_DESCRIPTION_FILE): $(MODPLUG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MODPLUG_PKG_DESCRIPTION_FILE) $(MODPLUG_PKG_INSTALL_SCRIPT)
	@cp $(MODPLUG_PKG_DESCRIPTION_FILE) $(MODPLUG_PKG)/.DESCRIPTION
	@cp $(MODPLUG_PKG_INSTALL_SCRIPT) $(MODPLUG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MODPLUG_PKG)/.REQUIRES
	@echo "pkgname=$(MODPLUG_PKG_NAME)"                            >  $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MODPLUG_PKG_VERSION)"                          >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "arch=$(MODPLUG_PKG_ARCH)"                               >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "distroname=$(MODPLUG_PKG_DISTRO_NAME)"                  >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "distrover=$(MODPLUG_PKG_DISTRO_VERSION)"                >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "group=$(MODPLUG_PKG_GROUP)"                             >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MODPLUG_PKG_SHORT_DESCRIPTION)\"" >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "url=$(MODPLUG_PKG_URL)"                                 >> $(MODPLUG_PKG)/.PKGINFO ; \
	 echo "license=$(MODPLUG_PKG_LICENSE)"                         >> $(MODPLUG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(MODPLUG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
