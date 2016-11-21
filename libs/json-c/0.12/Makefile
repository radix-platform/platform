
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


SOURCE_REQUIRES    = sources/packages/l/json-c

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


version            = 0.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/json-c/json-c-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/json-c-$(version)
src_dir_name       = json-c-$(version)
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
JSONC_PKG_NAME                = json-c
JSONC_PKG_VERSION             = 0.12
JSONC_PKG_ARCH                = $(TOOLCHAIN)
JSONC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JSONC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JSONC_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
JSONC_PKG_SHORT_DESCRIPTION   = javascript object notation library for C
JSONC_PKG_URL                 = $(BUG_URL)
JSONC_PKG_LICENSE             = custom
JSONC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JSONC_PKG_NAME)-pkg-description
JSONC_PKG_DESCRIPTION_FILE_IN = $(JSONC_PKG_NAME)-pkg-description.in
JSONC_PKG_INSTALL_SCRIPT      = $(JSONC_PKG_NAME)-pkg-install.sh

JSONC_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JSONC_PKG_NAME)-package

pkg_basename     = $(JSONC_PKG_NAME)-$(JSONC_PKG_VERSION)-$(JSONC_PKG_ARCH)-$(JSONC_PKG_DISTRO_NAME)-$(JSONC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(JSONC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
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
	@mkdir -p $(JSONC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(JSONC_PKG)/usr/share/man ]; then \
	  ( cd $(JSONC_PKG)/usr/share/man ; \
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
	@mkdir -p $(JSONC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(JSONC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(JSONC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* RELEASE* doc/html \
	         $(JSONC_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(JSONC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(JSONC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libjson-c.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JSONC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libjson-c.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libjson-c.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" json-c.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(JSONC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JSONC_PKG_DESCRIPTION_FILE): $(JSONC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JSONC_PKG_DESCRIPTION_FILE) $(JSONC_PKG_INSTALL_SCRIPT)
	@cp $(JSONC_PKG_DESCRIPTION_FILE) $(JSONC_PKG)/.DESCRIPTION
	@cp $(JSONC_PKG_INSTALL_SCRIPT) $(JSONC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JSONC_PKG)/.REQUIRES
	@echo "pkgname=$(JSONC_PKG_NAME)"                            >  $(JSONC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JSONC_PKG_VERSION)"                          >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "arch=$(JSONC_PKG_ARCH)"                               >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "distroname=$(JSONC_PKG_DISTRO_NAME)"                  >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "distrover=$(JSONC_PKG_DISTRO_VERSION)"                >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "group=$(JSONC_PKG_GROUP)"                             >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JSONC_PKG_SHORT_DESCRIPTION)\"" >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "url=$(JSONC_PKG_URL)"                                 >> $(JSONC_PKG)/.PKGINFO ; \
	 echo "license=$(JSONC_PKG_LICENSE)"                         >> $(JSONC_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(JSONC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
