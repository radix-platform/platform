
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/opus

REQUIRES           = libs/eglibc/2.19.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/opus/opus-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/opus-$(version)
src_dir_name       = opus-$(version)
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
OPUS_PKG_NAME                = opus
OPUS_PKG_VERSION             = 1.1
OPUS_PKG_ARCH                = $(TOOLCHAIN)
OPUS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
OPUS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
OPUS_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
OPUS_PKG_SHORT_DESCRIPTION   = Interactive Audio Codec
OPUS_PKG_URL                 = $(BUG_URL)
OPUS_PKG_LICENSE             = Xiph.org
OPUS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(OPUS_PKG_NAME)-pkg-description
OPUS_PKG_DESCRIPTION_FILE_IN = $(OPUS_PKG_NAME)-pkg-description.in
OPUS_PKG_INSTALL_SCRIPT      = $(OPUS_PKG_NAME)-pkg-install.sh

OPUS_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(OPUS_PKG_NAME)-package

pkg_basename     = $(OPUS_PKG_NAME)-$(OPUS_PKG_VERSION)-$(OPUS_PKG_ARCH)-$(OPUS_PKG_DISTRO_NAME)-$(OPUS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(OPUS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-custom-modes
extra_configure_switches += --enable-float-approx
extra_configure_switches += --enable-fuzzing
extra_configure_switches += --disable-extra-programs
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
	@mkdir -p $(OPUS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@if [ -d $(OPUS_PKG)/usr/share/man ]; then \
	  ( cd $(OPUS_PKG)/usr/share/man ; \
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
	@mkdir -p $(OPUS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(OPUS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(OPUS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL README doc/trivial_example.c \
	         $(OPUS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(OPUS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(OPUS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libopus.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(OPUS_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libopus.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libopus.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" opus.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(OPUS_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(OPUS_PKG_DESCRIPTION_FILE): $(OPUS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(OPUS_PKG_DESCRIPTION_FILE) $(OPUS_PKG_INSTALL_SCRIPT)
	@cp $(OPUS_PKG_DESCRIPTION_FILE) $(OPUS_PKG)/.DESCRIPTION
	@cp $(OPUS_PKG_INSTALL_SCRIPT) $(OPUS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(OPUS_PKG)/.REQUIRES
	@echo "pkgname=$(OPUS_PKG_NAME)"                            >  $(OPUS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(OPUS_PKG_VERSION)"                          >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "arch=$(OPUS_PKG_ARCH)"                               >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "distroname=$(OPUS_PKG_DISTRO_NAME)"                  >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "distrover=$(OPUS_PKG_DISTRO_VERSION)"                >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "group=$(OPUS_PKG_GROUP)"                             >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(OPUS_PKG_SHORT_DESCRIPTION)\"" >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "url=$(OPUS_PKG_URL)"                                 >> $(OPUS_PKG)/.PKGINFO ; \
	 echo "license=$(OPUS_PKG_LICENSE)"                         >> $(OPUS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(OPUS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
