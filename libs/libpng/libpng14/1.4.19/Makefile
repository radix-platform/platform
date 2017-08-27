
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


SOURCE_REQUIRES    = sources/packages/l/libpng/libpng14

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/zlib/1.2.8
else
REQUIRES           = libs/zlib/1.2.8-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.19
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libpng/libpng14/libpng-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libpng-$(version)
src_dir_name       = libpng-$(version)
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
LIBPNG_PKG_NAME                = libpng14
LIBPNG_PKG_VERSION             = 1.4.19
LIBPNG_PKG_ARCH                = $(TOOLCHAIN)
LIBPNG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBPNG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBPNG_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBPNG_PKG_SHORT_DESCRIPTION   = Portable Network Graphics library
LIBPNG_PKG_URL                 = $(BUG_URL)
LIBPNG_PKG_LICENSE             = custom:libpng
LIBPNG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBPNG_PKG_NAME)-pkg-description
LIBPNG_PKG_DESCRIPTION_FILE_IN = $(LIBPNG_PKG_NAME)-pkg-description.in
LIBPNG_PKG_INSTALL_SCRIPT      = $(LIBPNG_PKG_NAME)-pkg-install.sh

LIBPNG_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBPNG_PKG_NAME)-package

pkg_basename     = $(LIBPNG_PKG_NAME)-$(LIBPNG_PKG_VERSION)-$(LIBPNG_PKG_ARCH)-$(LIBPNG_PKG_DISTRO_NAME)-$(LIBPNG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBPNG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


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
	@mkdir -p $(LIBPNG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBPNG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBPNG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBPNG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(LIBPNG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBPNG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ANNOUNCE CHANGES INSTALL LICENSE  \
	         README TODO libpng*.txt example.c \
	         $(LIBPNG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBPNG_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBPNG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpng14.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBPNG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpng14.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpng14.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpng14.pc \
	 )
	# ======= tune libpng14-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpng14-config \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBPNG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBPNG_PKG_DESCRIPTION_FILE): $(LIBPNG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBPNG_PKG_DESCRIPTION_FILE) $(LIBPNG_PKG_INSTALL_SCRIPT)
	@cp $(LIBPNG_PKG_DESCRIPTION_FILE) $(LIBPNG_PKG)/.DESCRIPTION
	@cp $(LIBPNG_PKG_INSTALL_SCRIPT) $(LIBPNG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBPNG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBPNG_PKG_NAME)"                            >  $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBPNG_PKG_VERSION)"                          >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBPNG_PKG_ARCH)"                               >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBPNG_PKG_DISTRO_NAME)"                  >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBPNG_PKG_DISTRO_VERSION)"                >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBPNG_PKG_GROUP)"                             >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBPNG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBPNG_PKG_URL)"                                 >> $(LIBPNG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBPNG_PKG_LICENSE)"                         >> $(LIBPNG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBPNG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
