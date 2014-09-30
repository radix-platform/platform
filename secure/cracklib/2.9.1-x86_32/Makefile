
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/cracklib

REQUIRES           = secure/cracklib/2.9.1
REQUIRES          += libs/eglibc/2.19.1-x86_32
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += dev/python2/2.7.6-x86_32


version            = 2.9.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/cracklib/cracklib-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cracklib-$(version)
src_dir_name       = cracklib-$(version)
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
CRACKLIB_32_PKG_NAME                = cracklib-x32
CRACKLIB_32_PKG_VERSION             = 2.9.1
CRACKLIB_32_PKG_ARCH                = $(TOOLCHAIN)
CRACKLIB_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CRACKLIB_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CRACKLIB_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
CRACKLIB_32_PKG_SHORT_DESCRIPTION   = cracklib-x32 $(version)
CRACKLIB_32_PKG_URL                 = $(BUG_URL)
CRACKLIB_32_PKG_LICENSE             = GPLv2
CRACKLIB_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CRACKLIB_32_PKG_NAME)-pkg-description
CRACKLIB_32_PKG_DESCRIPTION_FILE_IN = $(CRACKLIB_32_PKG_NAME)-pkg-description.in
CRACKLIB_32_PKG_INSTALL_SCRIPT      = $(CRACKLIB_32_PKG_NAME)-pkg-install.sh

CRACKLIB_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CRACKLIB_32_PKG_NAME)-package

pkg_basename     = $(CRACKLIB_32_PKG_NAME)-$(CRACKLIB_32_PKG_VERSION)-$(CRACKLIB_32_PKG_ARCH)-$(CRACKLIB_32_PKG_DISTRO_NAME)-$(CRACKLIB_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(CRACKLIB_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --datadir=/var/cache
extra_configure_switches += --with-default-dict=/var/cache/cracklib/pq_dict
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@( cd $(build_dir)/python ; \
	   sed -i "/pyexecdir/s:/lib[0-9]*:/lib$(MULTILIB_X86_32_SUFFIX):"  Makefile ; \
	   sed -i "/pythondir/s:/lib[0-9]*:/lib$(MULTILIB_X86_32_SUFFIX):"  Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CRACKLIB_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(CRACKLIB_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(CRACKLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	     ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@rm -rf $(CRACKLIB_32_PKG)/usr/include
	@rm -rf $(CRACKLIB_32_PKG)/usr/sbin
	@rm -rf $(CRACKLIB_32_PKG)/usr/share
	@rm -rf $(CRACKLIB_32_PKG)/var
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CRACKLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libcrack.la \
	 )
	@( cd $(CRACKLIB_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python?.?/site-packages ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" _cracklib.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(CRACKLIB_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcrack.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcrack.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python?.?/site-packages ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _cracklib.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _cracklib.la \
	 )
	@(cd $(CRACKLIB_32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CRACKLIB_32_PKG_DESCRIPTION_FILE): $(CRACKLIB_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CRACKLIB_32_PKG_DESCRIPTION_FILE) $(CRACKLIB_32_PKG_INSTALL_SCRIPT)
	@cp $(CRACKLIB_32_PKG_DESCRIPTION_FILE) $(CRACKLIB_32_PKG)/.DESCRIPTION
	@cp $(CRACKLIB_32_PKG_INSTALL_SCRIPT) $(CRACKLIB_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CRACKLIB_32_PKG)/.REQUIRES
	@echo "pkgname=$(CRACKLIB_32_PKG_NAME)"                            >  $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CRACKLIB_32_PKG_VERSION)"                          >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CRACKLIB_32_PKG_ARCH)"                               >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CRACKLIB_32_PKG_DISTRO_NAME)"                  >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CRACKLIB_32_PKG_DISTRO_VERSION)"                >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "group=$(CRACKLIB_32_PKG_GROUP)"                             >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CRACKLIB_32_PKG_SHORT_DESCRIPTION)\"" >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "url=$(CRACKLIB_32_PKG_URL)"                                 >> $(CRACKLIB_32_PKG)/.PKGINFO ; \
	 echo "license=$(CRACKLIB_32_PKG_LICENSE)"                         >> $(CRACKLIB_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CRACKLIB_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
