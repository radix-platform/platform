
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/libart-lgpl

REQUIRES           = libs/libart-lgpl/2.3.21

# ======= __END_OF_REQUIRES__ =======


version            = 2.3.21
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/libart-lgpl/libart_lgpl-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libart_lgpl-$(version)
src_dir_name       = libart_lgpl-$(version)
doc_dir_name       = libart-lgpl-$(version)
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
LIBART_32_PKG_NAME                = libart-lgpl-x32
LIBART_32_PKG_VERSION             = 2.3.21
LIBART_32_PKG_ARCH                = $(TOOLCHAIN)
LIBART_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBART_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBART_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBART_32_PKG_SHORT_DESCRIPTION   = high-performance 2D graphics library
LIBART_32_PKG_URL                 = $(BUG_URL)
LIBART_32_PKG_LICENSE             = LGPLv2
LIBART_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBART_32_PKG_NAME)-pkg-description
LIBART_32_PKG_DESCRIPTION_FILE_IN = $(LIBART_32_PKG_NAME)-pkg-description.in
LIBART_32_PKG_INSTALL_SCRIPT      = $(LIBART_32_PKG_NAME)-pkg-install.sh

LIBART_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBART_32_PKG_NAME)-package

pkg_basename     = $(LIBART_32_PKG_NAME)-$(LIBART_32_PKG_VERSION)-$(LIBART_32_PKG_ARCH)-$(LIBART_32_PKG_DISTRO_NAME)-$(LIBART_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBART_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


LDFLAGS += -Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBART_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBART_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBART_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libart_lgpl_2.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBART_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libart_lgpl_2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libart_lgpl_2.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libart-?.?.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libart2-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBART_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBART_32_PKG_DESCRIPTION_FILE): $(LIBART_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBART_32_PKG_DESCRIPTION_FILE) $(LIBART_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBART_32_PKG_DESCRIPTION_FILE) $(LIBART_32_PKG)/.DESCRIPTION
	@cp $(LIBART_32_PKG_INSTALL_SCRIPT) $(LIBART_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBART_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBART_32_PKG_NAME)"                            >  $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBART_32_PKG_VERSION)"                          >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBART_32_PKG_ARCH)"                               >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBART_32_PKG_DISTRO_NAME)"                  >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBART_32_PKG_DISTRO_VERSION)"                >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBART_32_PKG_GROUP)"                             >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBART_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBART_32_PKG_URL)"                                 >> $(LIBART_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBART_32_PKG_LICENSE)"                         >> $(LIBART_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBART_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
