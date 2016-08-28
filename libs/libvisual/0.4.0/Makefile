
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libvisual

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.23
else
REQUIRES           = libs/glibc/2.23-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.4.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/libvisual/libvisual-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libvisual-$(version)
src_dir_name       = libvisual-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBVISUAL_PKG_NAME                = libvisual
LIBVISUAL_PKG_VERSION             = 0.4.0
LIBVISUAL_PKG_ARCH                = $(TOOLCHAIN)
LIBVISUAL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVISUAL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVISUAL_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBVISUAL_PKG_SHORT_DESCRIPTION   = audio visualization library
LIBVISUAL_PKG_URL                 = $(BUG_URL)
LIBVISUAL_PKG_LICENSE             = LGPLv2
LIBVISUAL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVISUAL_PKG_NAME)-pkg-description
LIBVISUAL_PKG_DESCRIPTION_FILE_IN = $(LIBVISUAL_PKG_NAME)-pkg-description.in
LIBVISUAL_PKG_INSTALL_SCRIPT      = $(LIBVISUAL_PKG_NAME)-pkg-install.sh

LIBVISUAL_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVISUAL_PKG_NAME)-package

pkg_basename     = $(LIBVISUAL_PKG_NAME)-$(LIBVISUAL_PKG_VERSION)-$(LIBVISUAL_PKG_ARCH)-$(LIBVISUAL_PKG_DISTRO_NAME)-$(LIBVISUAL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBVISUAL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --disable-rpath

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBVISUAL_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBVISUAL_PKG)/usr/share/man ]; then \
	  ( cd $(LIBVISUAL_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBVISUAL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBVISUAL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBVISUAL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README TODO \
	         $(LIBVISUAL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBVISUAL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBVISUAL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvisual-?.?.la ; \
	   sed -i "s,-L$(CURDIR)/$(SRC_DIR)/libvisual ,,g" libvisual-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVISUAL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvisual-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvisual-?.?.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvisual-?.?.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVISUAL_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBVISUAL_PKG_DESCRIPTION_FILE): $(LIBVISUAL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVISUAL_PKG_DESCRIPTION_FILE) $(LIBVISUAL_PKG_INSTALL_SCRIPT)
	@cp $(LIBVISUAL_PKG_DESCRIPTION_FILE) $(LIBVISUAL_PKG)/.DESCRIPTION
	@cp $(LIBVISUAL_PKG_INSTALL_SCRIPT) $(LIBVISUAL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVISUAL_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVISUAL_PKG_NAME)"                            >  $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVISUAL_PKG_VERSION)"                          >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVISUAL_PKG_ARCH)"                               >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVISUAL_PKG_DISTRO_NAME)"                  >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVISUAL_PKG_DISTRO_VERSION)"                >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVISUAL_PKG_GROUP)"                             >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVISUAL_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVISUAL_PKG_URL)"                                 >> $(LIBVISUAL_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVISUAL_PKG_LICENSE)"                         >> $(LIBVISUAL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBVISUAL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
