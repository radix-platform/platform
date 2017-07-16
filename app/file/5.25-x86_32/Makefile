
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/file

REQUIRES           = app/file/5.25

# ======= __END_OF_REQUIRES__ =======


version            = 5.25
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/file/file-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/file-$(version)
src_dir_name       = file-$(version)
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
FILE_32_PKG_NAME                = file-x32
FILE_32_PKG_VERSION             = 5.25
FILE_32_PKG_ARCH                = $(TOOLCHAIN)
FILE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FILE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FILE_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FILE_32_PKG_SHORT_DESCRIPTION   = utility to determine file type
FILE_32_PKG_URL                 = $(BUG_URL)
FILE_32_PKG_LICENSE             = GPLv2
FILE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FILE_32_PKG_NAME)-pkg-description
FILE_32_PKG_DESCRIPTION_FILE_IN = $(FILE_32_PKG_NAME)-pkg-description.in
FILE_32_PKG_INSTALL_SCRIPT      = $(FILE_32_PKG_NAME)-pkg-install.sh

FILE_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FILE_32_PKG_NAME)-package

pkg_basename     = $(FILE_32_PKG_NAME)-$(FILE_32_PKG_VERSION)-$(FILE_32_PKG_ARCH)-$(FILE_32_PKG_DISTRO_NAME)-$(FILE_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FILE_32_PKG)

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --datadir=/etc
extra_configure_switches += --enable-fsect-man5
extra_configure_switches += --enable-static


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Build native 'file' for creating magic.mgc =======
	@( cd $(SRC_DIR) ; \
	   cp -a `which libtool` . ; \
	   autoreconf -i ; \
	   ./configure --prefix=/usr ; \
	   make ; \
	   mkdir -p host ; \
	   cp -a ./src/.libs/file ./src/.libs/libmagic.so* ./host ; \
	   make distclean ; \
	   rm -rf ./autom4te.cache config.h.in~ \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FILE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(FILE_32_PKG)/etc
	@rm -rf $(FILE_32_PKG)/usr/include
	@rm -rf $(FILE_32_PKG)/usr/share
	# ======= remove target path from target libtool *.la files =======
	@( cd $(FILE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmagic.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FILE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmagic.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmagic.la \
	 )
	# ======= Strip binaries =======
	@( cd $(FILE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(FILE_32_PKG_DESCRIPTION_FILE): $(FILE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FILE_32_PKG_DESCRIPTION_FILE) $(FILE_32_PKG_INSTALL_SCRIPT)
	@cp $(FILE_32_PKG_DESCRIPTION_FILE) $(FILE_32_PKG)/.DESCRIPTION
	@cp $(FILE_32_PKG_INSTALL_SCRIPT) $(FILE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FILE_32_PKG)/.REQUIRES
	@echo "pkgname=$(FILE_32_PKG_NAME)"                            >  $(FILE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FILE_32_PKG_VERSION)"                          >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FILE_32_PKG_ARCH)"                               >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FILE_32_PKG_DISTRO_NAME)"                  >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FILE_32_PKG_DISTRO_VERSION)"                >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "group=$(FILE_32_PKG_GROUP)"                             >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FILE_32_PKG_SHORT_DESCRIPTION)\"" >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "url=$(FILE_32_PKG_URL)"                                 >> $(FILE_32_PKG)/.PKGINFO ; \
	 echo "license=$(FILE_32_PKG_LICENSE)"                         >> $(FILE_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FILE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
