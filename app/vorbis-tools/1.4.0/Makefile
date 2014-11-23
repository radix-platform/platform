
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/vorbis-tools

REQUIRES           = app/flac/1.3.0
REQUIRES          += libs/zlib/1.2.8
REQUIRES          += libs/libao/1.1.0
REQUIRES          += libs/libvorbis/1.3.4
REQUIRES          += libs/libogg/1.3.2
REQUIRES          += net/curl/7.38.0


version            = 1.4.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/vorbis-tools/vorbis-tools-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/vorbis-tools-$(version)
src_dir_name       = vorbis-tools-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
VORBIS_TOOLS_PKG_NAME                = vorbis-tools
VORBIS_TOOLS_PKG_VERSION             = 1.4.0
VORBIS_TOOLS_PKG_ARCH                = $(TOOLCHAIN)
VORBIS_TOOLS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VORBIS_TOOLS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VORBIS_TOOLS_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
VORBIS_TOOLS_PKG_SHORT_DESCRIPTION   = Ogg Vorbis Tools
VORBIS_TOOLS_PKG_URL                 = $(BUG_URL)
VORBIS_TOOLS_PKG_LICENSE             = GPLv2
VORBIS_TOOLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VORBIS_TOOLS_PKG_NAME)-pkg-description
VORBIS_TOOLS_PKG_DESCRIPTION_FILE_IN = $(VORBIS_TOOLS_PKG_NAME)-pkg-description.in
VORBIS_TOOLS_PKG_INSTALL_SCRIPT      = $(VORBIS_TOOLS_PKG_NAME)-pkg-install.sh

VORBIS_TOOLS_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VORBIS_TOOLS_PKG_NAME)-package

pkg_basename     = $(VORBIS_TOOLS_PKG_NAME)-$(VORBIS_TOOLS_PKG_VERSION)-$(VORBIS_TOOLS_PKG_ARCH)-$(VORBIS_TOOLS_PKG_DISTRO_NAME)-$(VORBIS_TOOLS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(VORBIS_TOOLS_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""


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
	@mkdir -p $(VORBIS_TOOLS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(VORBIS_TOOLS_PKG)/usr/share/man ]; then \
	  ( cd $(VORBIS_TOOLS_PKG)/usr/share/man ; \
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
	@mkdir -p $(VORBIS_TOOLS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(VORBIS_TOOLS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(VORBIS_TOOLS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README \
	         $(VORBIS_TOOLS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@rm -f $(VORBIS_TOOLS_PKG)/usr/share/doc/$(src_dir_name)/FLAC.tag
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(VORBIS_TOOLS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(VORBIS_TOOLS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= Strip binaries =======
	@( cd $(VORBIS_TOOLS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(VORBIS_TOOLS_PKG_DESCRIPTION_FILE): $(VORBIS_TOOLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VORBIS_TOOLS_PKG_DESCRIPTION_FILE) $(VORBIS_TOOLS_PKG_INSTALL_SCRIPT)
	@cp $(VORBIS_TOOLS_PKG_DESCRIPTION_FILE) $(VORBIS_TOOLS_PKG)/.DESCRIPTION
	@cp $(VORBIS_TOOLS_PKG_INSTALL_SCRIPT) $(VORBIS_TOOLS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VORBIS_TOOLS_PKG)/.REQUIRES
	@echo "pkgname=$(VORBIS_TOOLS_PKG_NAME)"                            >  $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VORBIS_TOOLS_PKG_VERSION)"                          >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "arch=$(VORBIS_TOOLS_PKG_ARCH)"                               >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "distroname=$(VORBIS_TOOLS_PKG_DISTRO_NAME)"                  >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "distrover=$(VORBIS_TOOLS_PKG_DISTRO_VERSION)"                >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "group=$(VORBIS_TOOLS_PKG_GROUP)"                             >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VORBIS_TOOLS_PKG_SHORT_DESCRIPTION)\"" >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "url=$(VORBIS_TOOLS_PKG_URL)"                                 >> $(VORBIS_TOOLS_PKG)/.PKGINFO ; \
	 echo "license=$(VORBIS_TOOLS_PKG_LICENSE)"                         >> $(VORBIS_TOOLS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(VORBIS_TOOLS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."