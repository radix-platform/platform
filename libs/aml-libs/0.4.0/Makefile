
COMPONENT_TARGETS  = $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/amlogic/aml-libs

REQUIRES           = libs/alsa-lib/1.1.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.4.0-20160716
so_version         = $(shell echo $(version) | cut -f1 -d'-')
so_major_version   = $(shell echo $(version) | cut -f1 -d'.')
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/amlogic/aml-libs/aml-libs-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/aml-libs-$(version)
doc_dir_name       = aml-libs-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

pkgconfig_in       = $(CURDIR)/pkgconfigs/aml-libs.pc.in
license            = $(CURDIR)/license/COPYING.GPLv2


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
AML_LIBS_PKG_NAME                = aml-libs
AML_LIBS_PKG_VERSION             = 0.4.0
AML_LIBS_PKG_ARCH                = $(TOOLCHAIN)
AML_LIBS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AML_LIBS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AML_LIBS_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
AML_LIBS_PKG_SHORT_DESCRIPTION   = Amlogic media player library
AML_LIBS_PKG_URL                 = $(BUG_URL)
AML_LIBS_PKG_LICENSE             = GPLv2
AML_LIBS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AML_LIBS_PKG_NAME)-pkg-description
AML_LIBS_PKG_DESCRIPTION_FILE_IN = $(AML_LIBS_PKG_NAME)-pkg-description.in
AML_LIBS_PKG_INSTALL_SCRIPT      = $(AML_LIBS_PKG_NAME)-pkg-install.sh

AML_LIBS_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AML_LIBS_PKG_NAME)-package

pkg_basename     = $(AML_LIBS_PKG_NAME)-$(AML_LIBS_PKG_VERSION)-$(AML_LIBS_PKG_ARCH)-$(AML_LIBS_PKG_DISTRO_NAME)-$(AML_LIBS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AML_LIBS_PKG)


aml_build_environment  = PREFIX=/usr
aml_build_environment += BIN_DIR=/usr/bin
aml_build_environment += LIB_DIR=/usr/lib$(LIBSUFFIX)
aml_build_environment += HEADERS_DIR=/usr/include
aml_build_environment += FIRMWARE_DIR=/lib/firmware


CFLAGS += -Wno-implicit-function-declaration -Wno-int-conversion -Wno-strict-aliasing
CFLAGS += -Wno-incompatible-pointer-types -Wno-implicit-int -Wno-int-to-pointer-cast -Wno-missing-braces
CFLAGS += -Wno-discarded-qualifiers -Wno-unused-variable -Wno-pointer-sign -Wno-enum-compare
CFLAGS += -Wno-switch -Wno-unused-but-set-variable -Wno-unused-function -Wno-attributes
CFLAGS += -Wno-unknown-pragmas -Wno-unused-label -Wparentheses -Wno-maybe-uninitialized


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C amadec    all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C amavutils all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C amcodec   all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C example   all $(aml_build_environment) ; \
	 )
	@( cd $(SRC_DIR)/audio_codec ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libmad    all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libadpcm  all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libamr    all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libape    all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libcook   all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libfaad   all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libflac   all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C liblpcm   all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libraac   all $(aml_build_environment) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -C libpcm    all $(aml_build_environment) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(AML_LIBS_PKG)
	@( cd $(SRC_DIR) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C amadec    install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C amavutils install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C amcodec   install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C example   install $(aml_build_environment) $(env_sysroot) ; \
	 )
	@( cd $(SRC_DIR)/audio_codec ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libmad    install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libadpcm  install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libamr    install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libape    install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libcook   install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libfaad   install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libflac   install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C liblpcm   install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libraac   install $(aml_build_environment) $(env_sysroot) ; \
	   $(BUILD_ENVIRONMENT) $(MAKE) -j1 -C libpcm    install $(aml_build_environment) $(env_sysroot) ; \
	 )
	@( cd $(AML_LIBS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in *.so ; do \
	     mv $$file $${file}.$(so_version) ; \
	     ln -sf $${file}.$(so_version) $${file}.$(so_major_version) ; \
	     ln -sf $${file}.$(so_major_version) $${file} ; \
	   done ; \
	 )
	# ======= Install pkg-config file =======
	@mkdir -p $(AML_LIBS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig
	@cat $(pkgconfig_in) | $(SED) -e "s,@PREFIX@,/usr,g" \
	                     | $(SED) -e "s,@LIBDIRSUFFIX@,$(LIBSUFFIX),g" \
	                     > $(AML_LIBS_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig/aml-libs.pc
	# ======= Install Documentation =======
	@if [ -d $(AML_LIBS_PKG)/usr/share/man ]; then \
	  ( cd $(AML_LIBS_PKG)/usr/share/man ; \
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
	@mkdir -p $(AML_LIBS_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(license) \
	       $(AML_LIBS_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(AML_LIBS_PKG)/usr/share/doc/$(doc_dir_name)
	@cp -a $(license) \
	       $(AML_LIBS_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AML_LIBS_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(AML_LIBS_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" aml-libs.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(AML_LIBS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(AML_LIBS_PKG_DESCRIPTION_FILE): $(AML_LIBS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AML_LIBS_PKG_DESCRIPTION_FILE) $(AML_LIBS_PKG_INSTALL_SCRIPT)
	@cp $(AML_LIBS_PKG_DESCRIPTION_FILE) $(AML_LIBS_PKG)/.DESCRIPTION
	@cp $(AML_LIBS_PKG_INSTALL_SCRIPT) $(AML_LIBS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AML_LIBS_PKG)/.REQUIRES
	@echo "pkgname=$(AML_LIBS_PKG_NAME)"                            >  $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AML_LIBS_PKG_VERSION)"                          >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "arch=$(AML_LIBS_PKG_ARCH)"                               >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "distroname=$(AML_LIBS_PKG_DISTRO_NAME)"                  >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "distrover=$(AML_LIBS_PKG_DISTRO_VERSION)"                >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "group=$(AML_LIBS_PKG_GROUP)"                             >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AML_LIBS_PKG_SHORT_DESCRIPTION)\"" >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "url=$(AML_LIBS_PKG_URL)"                                 >> $(AML_LIBS_PKG)/.PKGINFO ; \
	 echo "license=$(AML_LIBS_PKG_LICENSE)"                         >> $(AML_LIBS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AML_LIBS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
