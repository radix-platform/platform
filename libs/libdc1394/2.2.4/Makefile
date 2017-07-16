
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


SOURCE_REQUIRES    = sources/packages/m/libdc1394

REQUIRES           = libs/libraw1394/2.1.2
REQUIRES          += libs/libusb/1.0.20

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libdc1394/libdc1394-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdc1394-$(version)
src_dir_name       = libdc1394-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DC1394_PKG_NAME                = libdc1394
DC1394_PKG_VERSION             = 2.2.4
DC1394_PKG_ARCH                = $(TOOLCHAIN)
DC1394_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DC1394_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DC1394_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
DC1394_PKG_SHORT_DESCRIPTION   = IIDC Camera Control Library
DC1394_PKG_URL                 = $(BUG_URL)
DC1394_PKG_LICENSE             = LGPLv2.1
DC1394_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DC1394_PKG_NAME)-pkg-description
DC1394_PKG_DESCRIPTION_FILE_IN = $(DC1394_PKG_NAME)-pkg-description.in
DC1394_PKG_INSTALL_SCRIPT      = $(DC1394_PKG_NAME)-pkg-install.sh

DC1394_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DC1394_PKG_NAME)-package

pkg_basename     = $(DC1394_PKG_NAME)-$(DC1394_PKG_VERSION)-$(DC1394_PKG_ARCH)-$(DC1394_PKG_DISTRO_NAME)-$(DC1394_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DC1394_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --htmldir=/usr/share/doc/$(src_dir_name)/html
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-doxygen-man
extra_configure_switches += --enable-doxygen-html
extra_configure_switches += --enable-doxygen-pdf

extra_configure_switches += --disable-sdltest
extra_configure_switches += --disable-examples

extra_configure_switches += --with-pic

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-enum-compare -Wno-format -Wno-deprecated-declarations


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
	@mkdir -p $(DC1394_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(DC1394_PKG)/usr/share/man ]; then \
	  ( cd $(DC1394_PKG)/usr/share/man ; \
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
	@mkdir -p $(DC1394_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(DC1394_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DC1394_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         doc/html doc/libdc1394.pdf \
	         $(DC1394_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(DC1394_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DC1394_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdc1394.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DC1394_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdc1394.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdc1394.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" libdc1394-?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DC1394_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DC1394_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DC1394_PKG_DESCRIPTION_FILE): $(DC1394_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DC1394_PKG_DESCRIPTION_FILE) $(DC1394_PKG_INSTALL_SCRIPT)
	@cp $(DC1394_PKG_DESCRIPTION_FILE) $(DC1394_PKG)/.DESCRIPTION
	@cp $(DC1394_PKG_INSTALL_SCRIPT) $(DC1394_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DC1394_PKG)/.REQUIRES
	@echo "pkgname=$(DC1394_PKG_NAME)"                            >  $(DC1394_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DC1394_PKG_VERSION)"                          >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "arch=$(DC1394_PKG_ARCH)"                               >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "distroname=$(DC1394_PKG_DISTRO_NAME)"                  >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "distrover=$(DC1394_PKG_DISTRO_VERSION)"                >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "group=$(DC1394_PKG_GROUP)"                             >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DC1394_PKG_SHORT_DESCRIPTION)\"" >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "url=$(DC1394_PKG_URL)"                                 >> $(DC1394_PKG)/.PKGINFO ; \
	 echo "license=$(DC1394_PKG_LICENSE)"                         >> $(DC1394_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DC1394_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
