
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


SOURCE_REQUIRES    = sources/packages/a/db

REQUIRES           = libs/eglibc/2.19.1
REQUIRES          += dev/gcc/4.9.1


version            = 6.1.19
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/db/db-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/db-$(version)
src_dir_name       = db-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DB_PKG_NAME                = db
DB_PKG_VERSION             = 6.1.19
DB_PKG_ARCH                = $(TOOLCHAIN)
DB_PKG_DISTRO_NAME         = kxLab
DB_PKG_DISTRO_VERSION      = 1.0
DB_PKG_GROUP               = $(PKG_GROUP)
###                         |---handy-ruler-------------------------------|
DB_PKG_SHORT_DESCRIPTION   = db $(version)
DB_PKG_URL                 = $(BUG_URL)
DB_PKG_LICENSE             = AGPLv3
DB_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DB_PKG_NAME)-pkg-description
DB_PKG_DESCRIPTION_FILE_IN = $(DB_PKG_NAME)-pkg-description.in
DB_PKG_INSTALL_SCRIPT      = $(DB_PKG_NAME)-pkg-install.sh

DB_PKG           = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DB_PKG_NAME)-package

pkg_basename     = $(DB_PKG_NAME)-$(DB_PKG_VERSION)-$(DB_PKG_ARCH)-$(DB_PKG_DISTRO_NAME)-$(DB_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))


BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DB_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --enable-compat185
extra_configure_switches += --enable-cxx
extra_configure_switches += --enable-dbm
extra_configure_switches += --enable-shared
extra_configure_switches += --enable-static


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/build_unix &&  \
	  $(BUILD_ENVIRONMENT) ../dist/configure \
	  --prefix=/usr               \
	  --exec-prefix=/usr          \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR)/build_unix && $(BUILD_ENVIRONMENT) $(MAKE) LIBSO_LIBS=-lpthread
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DB_PKG)
	@cd $(SRC_DIR)/build_unix && $(BUILD_ENVIRONMENT) $(MAKE) $(env_sysroot) install
	@mkdir -p $(DB_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE \
	       $(DB_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DB_PKG)/usr/share/doc/$(src_dir_name)
	@mv $(DB_PKG)/usr/docs $(DB_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE README \
	         $(DB_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(DB_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdb-?.?.la libdb_cxx-?.?.la ; \
	   chmod 0755 *.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(DB_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdb-?.?.la libdb_cxx-?.?.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdb-?.?.la libdb_cxx-?.?.la \
	 )
	# ======= Strip binaries =======
	@(cd $(DB_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(DB_PKG_DESCRIPTION_FILE): $(DB_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DB_PKG_DESCRIPTION_FILE) $(DB_PKG_INSTALL_SCRIPT)
	@cp $(DB_PKG_DESCRIPTION_FILE) $(DB_PKG)/.DESCRIPTION
	@cp $(DB_PKG_INSTALL_SCRIPT) $(DB_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DB_PKG)/.REQUIRES
	@echo "pkgname=$(DB_PKG_NAME)"                            >  $(DB_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DB_PKG_VERSION)"                          >> $(DB_PKG)/.PKGINFO ; \
	 echo "arch=$(DB_PKG_ARCH)"                               >> $(DB_PKG)/.PKGINFO ; \
	 echo "distroname=$(DB_PKG_DISTRO_NAME)"                  >> $(DB_PKG)/.PKGINFO ; \
	 echo "distrover=$(DB_PKG_DISTRO_VERSION)"                >> $(DB_PKG)/.PKGINFO ; \
	 echo "group=$(DB_PKG_GROUP)"                             >> $(DB_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DB_PKG_SHORT_DESCRIPTION)\"" >> $(DB_PKG)/.PKGINFO ; \
	 echo "url=$(DB_PKG_URL)"                                 >> $(DB_PKG)/.PKGINFO ; \
	 echo "license=$(DB_PKG_LICENSE)"                         >> $(DB_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DB_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
