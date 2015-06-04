
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/slang

REQUIRES           = libs/pcre/8.34
REQUIRES          += libs/libpng/libpng14/1.4.13

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/slang/slang-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/slang-$(version)
src_dir_name       = slang-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SLANG_PKG_NAME                = slang
SLANG_PKG_VERSION             = 2.2.4
SLANG_PKG_ARCH                = $(TOOLCHAIN)
SLANG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SLANG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SLANG_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
SLANG_PKG_SHORT_DESCRIPTION   = S-Lang interpreter version 2
SLANG_PKG_URL                 = $(BUG_URL)
SLANG_PKG_LICENSE             = GPLv2
SLANG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SLANG_PKG_NAME)-pkg-description
SLANG_PKG_DESCRIPTION_FILE_IN = $(SLANG_PKG_NAME)-pkg-description.in
SLANG_PKG_INSTALL_SCRIPT      = $(SLANG_PKG_NAME)-pkg-install.sh

SLANG_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SLANG_PKG_NAME)-package

pkg_basename     = $(SLANG_PKG_NAME)-$(SLANG_PKG_VERSION)-$(SLANG_PKG_ARCH)-$(SLANG_PKG_DISTRO_NAME)-$(SLANG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SLANG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --includedir=/usr/include


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 elf
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SLANG_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install     $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-elf $(env_sysroot)
	@if [ -d $(SLANG_PKG)/usr/share/man ]; then \
	  ( cd $(SLANG_PKG)/usr/share/man ; \
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
	@mkdir -p $(SLANG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(SLANG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SLANG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL* NEWS README UPGRADE.txt \
	         $(SLANG_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SLANG_PKG)/usr/share/doc ; \
	   mv slang slsh $(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r changes.txt ]; then \
	     DOCSDIR=`echo $(SLANG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat changes.txt | head -n 1000 > $$DOCSDIR/changes.txt ; \
	     touch -r changes.txt $$DOCSDIR/changes.txt ; \
	   fi \
	 )
	@( cd $(SLANG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 0755 libslang.so.?.?.?  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(SLANG_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" slang.pc \
	 )
	# ======= Set slang_load_path for development =======
	@( cd $(TARGET_DEST_DIR)/etc ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" slsh.rc \
	 )
	# ======= Strip binaries =======
	@( cd $(SLANG_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(SLANG_PKG_DESCRIPTION_FILE): $(SLANG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SLANG_PKG_DESCRIPTION_FILE) $(SLANG_PKG_INSTALL_SCRIPT)
	@cp $(SLANG_PKG_DESCRIPTION_FILE) $(SLANG_PKG)/.DESCRIPTION
	@cp $(SLANG_PKG_INSTALL_SCRIPT) $(SLANG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SLANG_PKG)/.REQUIRES
	@echo "pkgname=$(SLANG_PKG_NAME)"                            >  $(SLANG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SLANG_PKG_VERSION)"                          >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "arch=$(SLANG_PKG_ARCH)"                               >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "distroname=$(SLANG_PKG_DISTRO_NAME)"                  >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "distrover=$(SLANG_PKG_DISTRO_VERSION)"                >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "group=$(SLANG_PKG_GROUP)"                             >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SLANG_PKG_SHORT_DESCRIPTION)\"" >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "url=$(SLANG_PKG_URL)"                                 >> $(SLANG_PKG)/.PKGINFO ; \
	 echo "license=$(SLANG_PKG_LICENSE)"                         >> $(SLANG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SLANG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
