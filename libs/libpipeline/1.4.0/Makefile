
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


SOURCE_REQUIRES    = sources/packages/l/libpipeline

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.24
else
REQUIRES           = libs/glibc/2.24-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libpipeline/libpipeline-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libpipeline-$(version)
src_dir_name       = libpipeline-$(version)
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
PIPELINE_PKG_NAME                = libpipeline
PIPELINE_PKG_VERSION             = 1.4.0
PIPELINE_PKG_ARCH                = $(TOOLCHAIN)
PIPELINE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PIPELINE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PIPELINE_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PIPELINE_PKG_SHORT_DESCRIPTION   = pipeline manipulation library
PIPELINE_PKG_URL                 = $(BUG_URL)
PIPELINE_PKG_LICENSE             = GPLv3
PIPELINE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PIPELINE_PKG_NAME)-pkg-description
PIPELINE_PKG_DESCRIPTION_FILE_IN = $(PIPELINE_PKG_NAME)-pkg-description.in
PIPELINE_PKG_INSTALL_SCRIPT      = $(PIPELINE_PKG_NAME)-pkg-install.sh

PIPELINE_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PIPELINE_PKG_NAME)-package

pkg_basename     = $(PIPELINE_PKG_NAME)-$(PIPELINE_PKG_VERSION)-$(PIPELINE_PKG_ARCH)-$(PIPELINE_PKG_DISTRO_NAME)-$(PIPELINE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PIPELINE_PKG)


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
	@mkdir -p $(PIPELINE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PIPELINE_PKG)/usr/share/man ]; then \
	  ( cd $(PIPELINE_PKG)/usr/share/man ; \
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
	@mkdir -p $(PIPELINE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(PIPELINE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PIPELINE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL NEWS README TODO \
	         $(PIPELINE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PIPELINE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PIPELINE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpipeline.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PIPELINE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpipeline.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpipeline.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpipeline.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PIPELINE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PIPELINE_PKG_DESCRIPTION_FILE): $(PIPELINE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PIPELINE_PKG_DESCRIPTION_FILE) $(PIPELINE_PKG_INSTALL_SCRIPT)
	@cp $(PIPELINE_PKG_DESCRIPTION_FILE) $(PIPELINE_PKG)/.DESCRIPTION
	@cp $(PIPELINE_PKG_INSTALL_SCRIPT) $(PIPELINE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PIPELINE_PKG)/.REQUIRES
	@echo "pkgname=$(PIPELINE_PKG_NAME)"                            >  $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PIPELINE_PKG_VERSION)"                          >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "arch=$(PIPELINE_PKG_ARCH)"                               >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "distroname=$(PIPELINE_PKG_DISTRO_NAME)"                  >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "distrover=$(PIPELINE_PKG_DISTRO_VERSION)"                >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "group=$(PIPELINE_PKG_GROUP)"                             >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PIPELINE_PKG_SHORT_DESCRIPTION)\"" >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "url=$(PIPELINE_PKG_URL)"                                 >> $(PIPELINE_PKG)/.PKGINFO ; \
	 echo "license=$(PIPELINE_PKG_LICENSE)"                         >> $(PIPELINE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PIPELINE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
