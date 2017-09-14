
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


SOURCE_REQUIRES    = sources/GNOME/core/libart-lgpl

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


version            = 2.3.21
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/libart-lgpl/libart_lgpl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libart_lgpl-$(version)
src_dir_name       = libart_lgpl-$(version)
doc_dir_name       = libart-lgpl-$(version)
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
LIBART_PKG_NAME                = libart-lgpl
LIBART_PKG_VERSION             = 2.3.21
LIBART_PKG_ARCH                = $(TOOLCHAIN)
LIBART_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBART_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBART_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBART_PKG_SHORT_DESCRIPTION   = high-performance 2D graphics library
LIBART_PKG_URL                 = $(BUG_URL)
LIBART_PKG_LICENSE             = LGPLv2
LIBART_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBART_PKG_NAME)-pkg-description
LIBART_PKG_DESCRIPTION_FILE_IN = $(LIBART_PKG_NAME)-pkg-description.in
LIBART_PKG_INSTALL_SCRIPT      = $(LIBART_PKG_NAME)-pkg-install.sh

LIBART_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBART_PKG_NAME)-package

pkg_basename     = $(LIBART_PKG_NAME)-$(LIBART_PKG_VERSION)-$(LIBART_PKG_ARCH)-$(LIBART_PKG_DISTRO_NAME)-$(LIBART_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBART_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBART_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBART_PKG)/usr/share/man ]; then \
	  ( cd $(LIBART_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBART_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBART_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LIBART_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING NEWS README \
	         $(LIBART_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBART_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBART_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libart_lgpl_2.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBART_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libart_lgpl_2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libart_lgpl_2.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libart-?.?.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libart2-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBART_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBART_PKG_DESCRIPTION_FILE): $(LIBART_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBART_PKG_DESCRIPTION_FILE) $(LIBART_PKG_INSTALL_SCRIPT)
	@cp $(LIBART_PKG_DESCRIPTION_FILE) $(LIBART_PKG)/.DESCRIPTION
	@cp $(LIBART_PKG_INSTALL_SCRIPT) $(LIBART_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBART_PKG)/.REQUIRES
	@echo "pkgname=$(LIBART_PKG_NAME)"                            >  $(LIBART_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBART_PKG_VERSION)"                          >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBART_PKG_ARCH)"                               >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBART_PKG_DISTRO_NAME)"                  >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBART_PKG_DISTRO_VERSION)"                >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "group=$(LIBART_PKG_GROUP)"                             >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBART_PKG_SHORT_DESCRIPTION)\"" >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "url=$(LIBART_PKG_URL)"                                 >> $(LIBART_PKG)/.PKGINFO ; \
	 echo "license=$(LIBART_PKG_LICENSE)"                         >> $(LIBART_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBART_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
