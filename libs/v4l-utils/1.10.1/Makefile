
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


SOURCE_REQUIRES    = sources/packages/m/linuxtv/v4l-utils

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += app/sysfsutils/2.1.0
REQUIRES          += libs/eudev/3.1.5
REQUIRES          += libs/libjpeg-turbo/1.4.2
REQUIRES          += X11/libs/qt5/5.7.1
REQUIRES          += X11/libs/glu/9.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.10.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/linuxtv/v4l-utils/v4l-utils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/v4l-utils-$(version)
src_dir_name       = v4l-utils-$(version)
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
V4LUTILS_PKG_NAME                = v4l-utils
V4LUTILS_PKG_VERSION             = 1.10.1
V4LUTILS_PKG_ARCH                = $(TOOLCHAIN)
V4LUTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
V4LUTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
V4LUTILS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
V4LUTILS_PKG_SHORT_DESCRIPTION   = libraries and utilities for video4linux
V4LUTILS_PKG_URL                 = $(BUG_URL)
V4LUTILS_PKG_LICENSE             = GPLv2
V4LUTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(V4LUTILS_PKG_NAME)-pkg-description
V4LUTILS_PKG_DESCRIPTION_FILE_IN = $(V4LUTILS_PKG_NAME)-pkg-description.in
V4LUTILS_PKG_INSTALL_SCRIPT      = $(V4LUTILS_PKG_NAME)-pkg-install.sh

V4LUTILS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(V4LUTILS_PKG_NAME)-package

pkg_basename     = $(V4LUTILS_PKG_NAME)-$(V4LUTILS_PKG_VERSION)-$(V4LUTILS_PKG_ARCH)-$(V4LUTILS_PKG_DISTRO_NAME)-$(V4LUTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(V4LUTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-udevdir=/lib/udev

ifneq ($(filter $(HARDWARE),$(HARDWARE_CB1X) $(HARDWARE_CI20)        \
                            $(HARDWARE_M201) $(HARDWARE_MXV)         \
                            $(HARDWARE_P201) $(HARDWARE_NEXBOX_A95X) \
                            $(HARDWARE_P212) $(HARDWARE_KHADAS_VIM)  \
                            $(HARDWARE_Q201) $(HARDWARE_ENYBOX_X2)),)
#
# Graphical Qt v4l2 control panel:
# ===============================
#  This utility is available when Qt5 is configured with desktop OpenGL
#  (i.e. with -opengl without any engine as argument) only. If Qt5 is
#  configured with -opengl es2 then qv4l2 utility is not available.
#
extra_configure_switches += --disable-qv4l2
endif

extra_configure_switches += --program-prefix=''
extra_configure_switches += --program-suffix=''

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


qt5_environment  = MOC=$(TARGET_DEST_DIR)/usr/lib/qt5/bin/$(TARGET)-qt5-moc
qt5_environment += RCC=$(TARGET_DEST_DIR)/usr/lib/qt5/bin/$(TARGET)-qt5-rcc
qt5_environment += UIC=$(TARGET_DEST_DIR)/usr/lib/qt5/bin/$(TARGET)-qt5-uic


CXXFLAGS += -std=c++11


TARGET_QT5_RPATH = /usr/lib$(LIBSUFFIX)/qt5/lib:/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(qt5_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(V4LUTILS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(build_dir) && $(MAKE) -j1 doxygen-pdf
	@mv $(V4LUTILS_PKG)/etc/rc_maps.cfg $(V4LUTILS_PKG)/etc/rc_maps.cfg.new
	# ======= Install Documentation =======
	@if [ -d $(V4LUTILS_PKG)/usr/share/man ]; then \
	  ( cd $(V4LUTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(V4LUTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING* \
	       $(V4LUTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(V4LUTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING* INSTALL README* TODO* \
	         $(V4LUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(build_dir) ; \
	   cp -a doxygen-doc/*.pdf doxygen-doc/html \
	         $(V4LUTILS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(V4LUTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(V4LUTILS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdvbv5.la libv4l1.la libv4l2.la   \
	                                    libv4l2rds.la libv4lconvert.la    ; \
	 )
	@( cd $(V4LUTILS_PKG)/usr/lib$(LIBSUFFIX)/libv4l ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" v4l1compat.la v4l2convert.la ; \
	 )
	@( cd $(V4LUTILS_PKG)/usr/lib$(LIBSUFFIX)/libv4l/plugins ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libv4l-mplane.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(V4LUTILS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdvbv5.la libv4l1.la libv4l2.la   \
	                                            libv4l2rds.la libv4lconvert.la    ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdvbv5.la libv4l1.la libv4l2.la   \
	                                              libv4l2rds.la libv4lconvert.la    ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libv4l ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" v4l1compat.la v4l2convert.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" v4l1compat.la v4l2convert.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/libv4l/plugins ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libv4l-mplane.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libv4l-mplane.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdvbv5.pc libv4l1.pc libv4l2.pc   \
	                                            libv4l2rds.pc libv4lconvert.pc    ; \
	 )
	# ======= Strip binaries =======
	@( cd $(V4LUTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(V4LUTILS_PKG)/usr/bin ; \
	   for file in qv4l2 ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_QT5_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(V4LUTILS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(V4LUTILS_PKG_DESCRIPTION_FILE): $(V4LUTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(V4LUTILS_PKG_DESCRIPTION_FILE) $(V4LUTILS_PKG_INSTALL_SCRIPT)
	@cp $(V4LUTILS_PKG_DESCRIPTION_FILE) $(V4LUTILS_PKG)/.DESCRIPTION
	@cp $(V4LUTILS_PKG_INSTALL_SCRIPT) $(V4LUTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(V4LUTILS_PKG)/.REQUIRES
	@echo "pkgname=$(V4LUTILS_PKG_NAME)"                            >  $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(V4LUTILS_PKG_VERSION)"                          >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(V4LUTILS_PKG_ARCH)"                               >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(V4LUTILS_PKG_DISTRO_NAME)"                  >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(V4LUTILS_PKG_DISTRO_VERSION)"                >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "group=$(V4LUTILS_PKG_GROUP)"                             >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(V4LUTILS_PKG_SHORT_DESCRIPTION)\"" >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "url=$(V4LUTILS_PKG_URL)"                                 >> $(V4LUTILS_PKG)/.PKGINFO ; \
	 echo "license=$(V4LUTILS_PKG_LICENSE)"                         >> $(V4LUTILS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(V4LUTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
