
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


SOURCE_REQUIRES    = sources/packages/m/libexif

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.25
else
REQUIRES           = libs/glibc/2.25-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.6.21
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libexif/libexif-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libexif-$(version)
src_dir_name       = libexif-$(version)
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
LIBEXIF_PKG_NAME                = libexif
LIBEXIF_PKG_VERSION             = 0.6.21
LIBEXIF_PKG_ARCH                = $(TOOLCHAIN)
LIBEXIF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBEXIF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBEXIF_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBEXIF_PKG_SHORT_DESCRIPTION   = Library for easy access to EXIF data
LIBEXIF_PKG_URL                 = $(BUG_URL)
LIBEXIF_PKG_LICENSE             = LGPLv2.1
LIBEXIF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBEXIF_PKG_NAME)-pkg-description
LIBEXIF_PKG_DESCRIPTION_FILE_IN = $(LIBEXIF_PKG_NAME)-pkg-description.in
LIBEXIF_PKG_INSTALL_SCRIPT      = $(LIBEXIF_PKG_NAME)-pkg-install.sh

LIBEXIF_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBEXIF_PKG_NAME)-package

pkg_basename     = $(LIBEXIF_PKG_NAME)-$(LIBEXIF_PKG_VERSION)-$(LIBEXIF_PKG_ARCH)-$(LIBEXIF_PKG_DISTRO_NAME)-$(LIBEXIF_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBEXIF_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --with-doc-dir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBEXIF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBEXIF_PKG)/usr/share/man ]; then \
	  ( cd $(LIBEXIF_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBEXIF_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBEXIF_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBEXIF_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL README-Win32.txt \
	         $(LIBEXIF_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBEXIF_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBEXIF_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexif.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBEXIF_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexif.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexif.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexif.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBEXIF_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBEXIF_PKG_DESCRIPTION_FILE): $(LIBEXIF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBEXIF_PKG_DESCRIPTION_FILE) $(LIBEXIF_PKG_INSTALL_SCRIPT)
	@cp $(LIBEXIF_PKG_DESCRIPTION_FILE) $(LIBEXIF_PKG)/.DESCRIPTION
	@cp $(LIBEXIF_PKG_INSTALL_SCRIPT) $(LIBEXIF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBEXIF_PKG)/.REQUIRES
	@echo "pkgname=$(LIBEXIF_PKG_NAME)"                            >  $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBEXIF_PKG_VERSION)"                          >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBEXIF_PKG_ARCH)"                               >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBEXIF_PKG_DISTRO_NAME)"                  >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBEXIF_PKG_DISTRO_VERSION)"                >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "group=$(LIBEXIF_PKG_GROUP)"                             >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBEXIF_PKG_SHORT_DESCRIPTION)\"" >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "url=$(LIBEXIF_PKG_URL)"                                 >> $(LIBEXIF_PKG)/.PKGINFO ; \
	 echo "license=$(LIBEXIF_PKG_LICENSE)"                         >> $(LIBEXIF_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBEXIF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
