
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/libinput

REQUIRES           = libs/eudev/3.1.5
REQUIRES          += X11/libs/libevdev/1.5.1
REQUIRES          += X11/libs/mtdev/1.1.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/libinput/libinput-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libinput-$(version)
src_dir_name       = libinput-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBINPUT_PKG_NAME                = libinput
LIBINPUT_PKG_VERSION             = 1.3.0
LIBINPUT_PKG_ARCH                = $(TOOLCHAIN)
LIBINPUT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBINPUT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBINPUT_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBINPUT_PKG_SHORT_DESCRIPTION   = input devices handler
LIBINPUT_PKG_URL                 = $(BUG_URL)
LIBINPUT_PKG_LICENSE             = custom
LIBINPUT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBINPUT_PKG_NAME)-pkg-description
LIBINPUT_PKG_DESCRIPTION_FILE_IN = $(LIBINPUT_PKG_NAME)-pkg-description.in
LIBINPUT_PKG_INSTALL_SCRIPT      = $(LIBINPUT_PKG_NAME)-pkg-install.sh

LIBINPUT_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBINPUT_PKG_NAME)-package

pkg_basename     = $(LIBINPUT_PKG_NAME)-$(LIBINPUT_PKG_VERSION)-$(LIBINPUT_PKG_ARCH)-$(LIBINPUT_PKG_DISTRO_NAME)-$(LIBINPUT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBINPUT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --with-udev-dir=/lib/udev

extra_configure_switches += --enable-event-gui=no
extra_configure_switches += --enable-libwacom=no
extra_configure_switches += --enable-tests=no

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


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
	@mkdir -p $(LIBINPUT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBINPUT_PKG)/usr/share/man ]; then \
	  ( cd $(LIBINPUT_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBINPUT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBINPUT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBINPUT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README* $(CURDIR)/$(build_dir)/doc/html \
	         $(LIBINPUT_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/*.svg \
	         $(LIBINPUT_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBINPUT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBINPUT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libinput.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBINPUT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libinput.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libinput.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libinput.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBINPUT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBINPUT_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBINPUT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBINPUT_PKG_DESCRIPTION_FILE): $(LIBINPUT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBINPUT_PKG_DESCRIPTION_FILE) $(LIBINPUT_PKG_INSTALL_SCRIPT)
	@cp $(LIBINPUT_PKG_DESCRIPTION_FILE) $(LIBINPUT_PKG)/.DESCRIPTION
	@cp $(LIBINPUT_PKG_INSTALL_SCRIPT) $(LIBINPUT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBINPUT_PKG)/.REQUIRES
	@echo "pkgname=$(LIBINPUT_PKG_NAME)"                            >  $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBINPUT_PKG_VERSION)"                          >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBINPUT_PKG_ARCH)"                               >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBINPUT_PKG_DISTRO_NAME)"                  >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBINPUT_PKG_DISTRO_VERSION)"                >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "group=$(LIBINPUT_PKG_GROUP)"                             >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBINPUT_PKG_SHORT_DESCRIPTION)\"" >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "url=$(LIBINPUT_PKG_URL)"                                 >> $(LIBINPUT_PKG)/.PKGINFO ; \
	 echo "license=$(LIBINPUT_PKG_LICENSE)"                         >> $(LIBINPUT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBINPUT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
