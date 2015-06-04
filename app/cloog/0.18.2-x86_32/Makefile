
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/CLooG

REQUIRES           = app/cloog/0.18.2
REQUIRES          += libs/gmp/6.0.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.18.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/CLooG/cloog-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/cloog-$(version)
src_dir_name       = cloog-$(version)
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
CLOOG32_PKG_NAME                = cloog-x32
CLOOG32_PKG_VERSION             = 0.18.2
CLOOG32_PKG_ARCH                = $(TOOLCHAIN)
CLOOG32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CLOOG32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CLOOG32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
CLOOG32_PKG_SHORT_DESCRIPTION   = The Chunky Loop Generator
CLOOG32_PKG_URL                 = $(BUG_URL)
CLOOG32_PKG_LICENSE             = GPLv2
CLOOG32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CLOOG32_PKG_NAME)-pkg-description
CLOOG32_PKG_DESCRIPTION_FILE_IN = $(CLOOG32_PKG_NAME)-pkg-description.in
CLOOG32_PKG_INSTALL_SCRIPT      = $(CLOOG32_PKG_NAME)-pkg-install.sh

CLOOG32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CLOOG32_PKG_NAME)-package

pkg_basename     = $(CLOOG32_PKG_NAME)-$(CLOOG32_PKG_VERSION)-$(CLOOG32_PKG_ARCH)-$(CLOOG32_PKG_DISTRO_NAME)-$(CLOOG32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CLOOG32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --with-bits=gmp
extra_configure_switches += --with-gmp=system
extra_configure_switches += --with-isl=bundled
extra_configure_switches += --with-osl=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(CLOOG32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(CLOOG32_PKG)/usr/include
	@( cd $(CLOOG32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv cloog 32 ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CLOOG32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,-L/lib,,g" libcloog-isl.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcloog-isl.la libisl.la \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(CLOOG32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,-L/lib,,g" cloog-isl.pc ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" cloog-isl.pc isl.pc \
	 )
	# ======= change /bin directory to /bin/32 in target pkg-config *.pc files =======
	@( cd $(CLOOG32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/bin,/bin/32,g" cloog-isl.pc isl.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(CLOOG32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcloog-isl.la libisl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcloog-isl.la libisl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" cloog-isl.pc isl.pc ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" cloog-isl.pc isl.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(CLOOG32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(CLOOG32_PKG_DESCRIPTION_FILE): $(CLOOG32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CLOOG32_PKG_DESCRIPTION_FILE) $(CLOOG32_PKG_INSTALL_SCRIPT)
	@cp $(CLOOG32_PKG_DESCRIPTION_FILE) $(CLOOG32_PKG)/.DESCRIPTION
	@cp $(CLOOG32_PKG_INSTALL_SCRIPT) $(CLOOG32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CLOOG32_PKG)/.REQUIRES
	@echo "pkgname=$(CLOOG32_PKG_NAME)"                            >  $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CLOOG32_PKG_VERSION)"                          >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "arch=$(CLOOG32_PKG_ARCH)"                               >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CLOOG32_PKG_DISTRO_NAME)"                  >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CLOOG32_PKG_DISTRO_VERSION)"                >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "group=$(CLOOG32_PKG_GROUP)"                             >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CLOOG32_PKG_SHORT_DESCRIPTION)\"" >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "url=$(CLOOG32_PKG_URL)"                                 >> $(CLOOG32_PKG)/.PKGINFO ; \
	 echo "license=$(CLOOG32_PKG_LICENSE)"                         >> $(CLOOG32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CLOOG32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
