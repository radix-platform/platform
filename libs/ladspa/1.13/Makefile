
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


SOURCE_REQUIRES    = sources/packages/m/ladspa

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
REQUIRES          += libs/glibc/2.25
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.13
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/ladspa/ladspa-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ladspa-$(version)
src_dir_name       = ladspa-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LADSPA_PKG_NAME                = ladspa
LADSPA_PKG_VERSION             = 1.13
LADSPA_PKG_ARCH                = $(TOOLCHAIN)
LADSPA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LADSPA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LADSPA_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LADSPA_PKG_SHORT_DESCRIPTION   = Simple Plugin API
LADSPA_PKG_URL                 = $(BUG_URL)
LADSPA_PKG_LICENSE             = LGPLv2.1
LADSPA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LADSPA_PKG_NAME)-pkg-description
LADSPA_PKG_DESCRIPTION_FILE_IN = $(LADSPA_PKG_NAME)-pkg-description.in
LADSPA_PKG_INSTALL_SCRIPT      = $(LADSPA_PKG_NAME)-pkg-install.sh

LADSPA_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LADSPA_PKG_NAME)-package

pkg_basename     = $(LADSPA_PKG_NAME)-$(LADSPA_PKG_VERSION)-$(LADSPA_PKG_ARCH)-$(LADSPA_PKG_DISTRO_NAME)-$(LADSPA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LADSPA_PKG)


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR)/src ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) INSTALL_PLUGINS_DIR="/usr/lib$(LIBSUFFIX)/ladspa" \
	                                INSTALL_INCLUDE_DIR="/usr/include"      \
	                                INSTALL_BINARY_DIR="/usr/bin" targets ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LADSPA_PKG)
	@( cd $(SRC_DIR)/src ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 INSTALL_PLUGINS_DIR="/usr/lib$(LIBSUFFIX)/ladspa"      \
	                                    INSTALL_INCLUDE_DIR="/usr/include"                     \
	                                    INSTALL_BINARY_DIR="/usr/bin" $(env_sysroot) install ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(LADSPA_PKG)/usr/share/man ]; then \
	  ( cd $(LADSPA_PKG)/usr/share/man ; \
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
	@mkdir -p $(LADSPA_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/doc/COPYING \
	       $(LADSPA_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LADSPA_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a doc/COPYING README snd \
	         $(LADSPA_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/*.html \
	         $(LADSPA_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	   cp -a src/ladspa.h \
	         $(LADSPA_PKG)/usr/share/doc/$(src_dir_name)/html/ladspa.h.txt ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LADSPA_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LADSPA_PKG))
	# ======= Strip binaries =======
	@( cd $(LADSPA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(LADSPA_PKG_DESCRIPTION_FILE): $(LADSPA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LADSPA_PKG_DESCRIPTION_FILE) $(LADSPA_PKG_INSTALL_SCRIPT)
	@cp $(LADSPA_PKG_DESCRIPTION_FILE) $(LADSPA_PKG)/.DESCRIPTION
	@cp $(LADSPA_PKG_INSTALL_SCRIPT) $(LADSPA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LADSPA_PKG)/.REQUIRES
	@echo "pkgname=$(LADSPA_PKG_NAME)"                            >  $(LADSPA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LADSPA_PKG_VERSION)"                          >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "arch=$(LADSPA_PKG_ARCH)"                               >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "distroname=$(LADSPA_PKG_DISTRO_NAME)"                  >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "distrover=$(LADSPA_PKG_DISTRO_VERSION)"                >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "group=$(LADSPA_PKG_GROUP)"                             >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LADSPA_PKG_SHORT_DESCRIPTION)\"" >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "url=$(LADSPA_PKG_URL)"                                 >> $(LADSPA_PKG)/.PKGINFO ; \
	 echo "license=$(LADSPA_PKG_LICENSE)"                         >> $(LADSPA_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LADSPA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
