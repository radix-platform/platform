
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/ppl

REQUIRES           = libs/gmp/5.1.3


version            = 1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/ppl/ppl-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ppl-$(version)
src_dir_name       = ppl-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_ppl32_pkg    = $(TARGET_BUILD_DIR)/.ppl32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PPL32_PKG_NAME                = ppl32
PPL32_PKG_VERSION             = 1.1
PPL32_PKG_ARCH                = $(TOOLCHAIN)
PPL32_PKG_DISTRO_NAME         = kxLab
PPL32_PKG_DISTRO_VERSION      = 1.0
PPL32_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PPL32_PKG_SHORT_DESCRIPTION   = ppl32 $(version)
PPL32_PKG_URL                 = http://www.kxLab.com
PPL32_PKG_LICENSE             = GPLv2
PPL32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PPL32_PKG_NAME)-pkg-description
PPL32_PKG_DESCRIPTION_FILE_IN = $(PPL32_PKG_NAME)-pkg-description.in
PPL32_PKG_INSTALL_SCRIPT      = $(PPL32_PKG_NAME)-pkg-install.sh

PPL32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PPL32_PKG_NAME)-package

pkg_basename     = $(PPL32_PKG_NAME)-$(PPL32_PKG_VERSION)-$(PPL32_PKG_ARCH)-$(PPL32_PKG_DISTRO_NAME)-$(PPL32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(PPL32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_ppl32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot        = DESTDIR=$(PPL32_PKG)

OPTIMIZATION_FLAGS = -O3

# owerwrite LDFLAGS:
#
LDFLAGS            = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS           += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS         = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32           = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-libgmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-interfaces="c,cxx"
extra_configure_switches += --disable-optimization
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
	@mkdir -p $(PPL32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(PPL32_PKG)/usr/include
	@rm -rf $(PPL32_PKG)/usr/share
	@( cd $(PPL32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv ppl* 32 ; \
	 )
	# remove toolchain path from target libtool *.la files and
	@( cd $(PPL32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libppl.la libppl_c.la \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(PPL32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libppl.la libppl_c.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libppl.la libppl_c.la \
	 )
	@(cd $(PPL32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PPL32_PKG_DESCRIPTION_FILE): $(PPL32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_ppl32_pkg): $(install_target) $(PPL32_PKG_DESCRIPTION_FILE)
	@cp $(PPL32_PKG_DESCRIPTION_FILE) $(PPL32_PKG)/.DESCRIPTION
	@cp $(PPL32_PKG_INSTALL_SCRIPT) $(PPL32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PPL32_PKG)/.REQUIRES
	@echo "pkgname=$(PPL32_PKG_NAME)"                            >  $(PPL32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PPL32_PKG_VERSION)"                          >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "arch=$(PPL32_PKG_ARCH)"                               >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PPL32_PKG_DISTRO_NAME)"                  >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PPL32_PKG_DISTRO_VERSION)"                >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "group=$(PPL32_PKG_GROUP)"                             >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PPL32_PKG_SHORT_DESCRIPTION)\"" >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "url=$(PPL32_PKG_URL)"                                 >> $(PPL32_PKG)/.PKGINFO ; \
	 echo "license=$(PPL32_PKG_LICENSE)"                         >> $(PPL32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PPL32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
