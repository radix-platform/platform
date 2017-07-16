
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/jemalloc

REQUIRES           = libs/jemalloc/4.2.1

# ======= __END_OF_REQUIRES__ =======


version            = 4.2.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/jemalloc/jemalloc-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/jemalloc-$(version)
src_dir_name       = jemalloc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

config_dir         = $(CURDIR)/scripts

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JEMALLOC_32_PKG_NAME                = jemalloc-x32
JEMALLOC_32_PKG_VERSION             = 4.2.1
JEMALLOC_32_PKG_ARCH                = $(TOOLCHAIN)
JEMALLOC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JEMALLOC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JEMALLOC_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
JEMALLOC_32_PKG_SHORT_DESCRIPTION   = A memory allocator
JEMALLOC_32_PKG_URL                 = $(BUG_URL)
JEMALLOC_32_PKG_LICENSE             = custom
JEMALLOC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JEMALLOC_32_PKG_NAME)-pkg-description
JEMALLOC_32_PKG_DESCRIPTION_FILE_IN = $(JEMALLOC_32_PKG_NAME)-pkg-description.in
JEMALLOC_32_PKG_INSTALL_SCRIPT      = $(JEMALLOC_32_PKG_NAME)-pkg-install.sh

JEMALLOC_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JEMALLOC_32_PKG_NAME)-package

pkg_basename     = $(JEMALLOC_32_PKG_NAME)-$(JEMALLOC_32_PKG_VERSION)-$(JEMALLOC_32_PKG_ARCH)-$(JEMALLOC_32_PKG_DISTRO_NAME)-$(JEMALLOC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(JEMALLOC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  echo "$(version)" > VERSION &&   \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JEMALLOC_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(JEMALLOC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod a-x *.a ; \
	 )
	@rm -rf $(JEMALLOC_32_PKG)/usr/include
	@rm -rf $(JEMALLOC_32_PKG)/usr/share
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JEMALLOC_32_PKG))
	# ======= Replace the jemalloc-config script for the target system =======
	@cp -a $(config_dir)/jemalloc-config $(JEMALLOC_32_PKG)/usr/bin/32/jemalloc-config
	@chmod a+x $(JEMALLOC_32_PKG)/usr/bin/32/jemalloc-config
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" jemalloc.pc \
	 )
	# =======Strip binaries =======
	@( cd $(JEMALLOC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JEMALLOC_32_PKG_DESCRIPTION_FILE): $(JEMALLOC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JEMALLOC_32_PKG_DESCRIPTION_FILE) $(JEMALLOC_32_PKG_INSTALL_SCRIPT)
	@cp $(JEMALLOC_32_PKG_DESCRIPTION_FILE) $(JEMALLOC_32_PKG)/.DESCRIPTION
	@cp $(JEMALLOC_32_PKG_INSTALL_SCRIPT) $(JEMALLOC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JEMALLOC_32_PKG)/.REQUIRES
	@echo "pkgname=$(JEMALLOC_32_PKG_NAME)"                            >  $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JEMALLOC_32_PKG_VERSION)"                          >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(JEMALLOC_32_PKG_ARCH)"                               >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(JEMALLOC_32_PKG_DISTRO_NAME)"                  >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(JEMALLOC_32_PKG_DISTRO_VERSION)"                >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "group=$(JEMALLOC_32_PKG_GROUP)"                             >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JEMALLOC_32_PKG_SHORT_DESCRIPTION)\"" >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "url=$(JEMALLOC_32_PKG_URL)"                                 >> $(JEMALLOC_32_PKG)/.PKGINFO ; \
	 echo "license=$(JEMALLOC_32_PKG_LICENSE)"                         >> $(JEMALLOC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(JEMALLOC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
