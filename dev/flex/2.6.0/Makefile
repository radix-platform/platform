
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


SOURCE_REQUIRES    = sources/packages/d/flex

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


version            = 2.6.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/d/flex/flex-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/flex-$(version)
src_dir_name       = flex-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FLEX_PKG_NAME                = flex
FLEX_PKG_VERSION             = 2.6.0
FLEX_PKG_ARCH                = $(TOOLCHAIN)
FLEX_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FLEX_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FLEX_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
FLEX_PKG_SHORT_DESCRIPTION   = fast lexical analyzer generator
FLEX_PKG_URL                 = $(BUG_URL)
FLEX_PKG_LICENSE             = BSD
FLEX_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FLEX_PKG_NAME)-pkg-description
FLEX_PKG_DESCRIPTION_FILE_IN = $(FLEX_PKG_NAME)-pkg-description.in
FLEX_PKG_INSTALL_SCRIPT      = $(FLEX_PKG_NAME)-pkg-install.sh

FLEX_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FLEX_PKG_NAME)-package

pkg_basename     = $(FLEX_PKG_NAME)-$(FLEX_PKG_VERSION)-$(FLEX_PKG_ARCH)-$(FLEX_PKG_DISTRO_NAME)-$(FLEX_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FLEX_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath


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
	# ======= Disable tests when cross-compile =======
	@( cd $(build_dir) ; \
	   sed -i.back '/^[\t]tests \\/d' Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FLEX_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(FLEX_PKG)/usr/bin ; \
	   ln -sf flex lex ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(FLEX_PKG)/usr/share/info/dir
	@gzip -9 $(FLEX_PKG)/usr/share/info/*
	@if [ -d $(FLEX_PKG)/usr/share/man ]; then \
	  ( cd $(FLEX_PKG)/usr/share/man ; \
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
	@mkdir -p $(FLEX_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(FLEX_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FLEX_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL THANKS TODO \
	         $(FLEX_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FLEX_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FLEX_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfl.la libfl_pic.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FLEX_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfl.la libfl_pic.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfl.la libfl_pic.la \
	 )
	# ======= Strip binaries =======
	@( cd $(FLEX_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(FLEX_PKG_DESCRIPTION_FILE): $(FLEX_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FLEX_PKG_DESCRIPTION_FILE) $(FLEX_PKG_INSTALL_SCRIPT)
	@cp $(FLEX_PKG_DESCRIPTION_FILE) $(FLEX_PKG)/.DESCRIPTION
	@cp $(FLEX_PKG_INSTALL_SCRIPT) $(FLEX_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FLEX_PKG)/.REQUIRES
	@echo "pkgname=$(FLEX_PKG_NAME)"                            >  $(FLEX_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FLEX_PKG_VERSION)"                          >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "arch=$(FLEX_PKG_ARCH)"                               >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "distroname=$(FLEX_PKG_DISTRO_NAME)"                  >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "distrover=$(FLEX_PKG_DISTRO_VERSION)"                >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "group=$(FLEX_PKG_GROUP)"                             >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FLEX_PKG_SHORT_DESCRIPTION)\"" >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "url=$(FLEX_PKG_URL)"                                 >> $(FLEX_PKG)/.PKGINFO ; \
	 echo "license=$(FLEX_PKG_LICENSE)"                         >> $(FLEX_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FLEX_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
