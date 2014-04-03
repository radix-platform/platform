
COMPONENT_TARGETS += $(TARGET_PC64)

NEED_ABS_PATH      = true

COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = $(SRC_PACKAGE_DIR)/packages/l/expat

REQUIRES           = libs/eglibc/2.18.1


version            = 2.1.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/expat/expat-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/expat-$(version)
src_dir_name       = expat-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done
build_expat32_pkg  = $(TARGET_BUILD_DIR)/.expat32_pkg_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
EXPAT32_PKG_NAME                = expat32
EXPAT32_PKG_VERSION             = 2.1.0
EXPAT32_PKG_ARCH                = $(TOOLCHAIN)
EXPAT32_PKG_DISTRO_NAME         = kxLab
EXPAT32_PKG_DISTRO_VERSION      = 1.0
EXPAT32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
EXPAT32_PKG_SHORT_DESCRIPTION   = expat32 $(version)
EXPAT32_PKG_URL                 = http://www.kxLab.com
EXPAT32_PKG_LICENSE             = GPLv2
EXPAT32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(EXPAT32_PKG_NAME)-pkg-description
EXPAT32_PKG_DESCRIPTION_FILE_IN = $(EXPAT32_PKG_NAME)-pkg-description.in
EXPAT32_PKG_INSTALL_SCRIPT      = $(EXPAT32_PKG_NAME)-pkg-install.sh

EXPAT32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(EXPAT32_PKG_NAME)-package

pkg_basename     = $(EXPAT32_PKG_NAME)-$(EXPAT32_PKG_VERSION)-$(EXPAT32_PKG_ARCH)-$(EXPAT32_PKG_DISTRO_NAME)-$(EXPAT32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(EXPAT32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_expat32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(EXPAT32_PKG)


CC          += -m32
CXX         += -m32

# owerwrite LDFLAGS:
#
LDFLAGS      = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS     += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS   = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(EXPAT32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@( cd $(EXPAT32_PKG)/usr/bin ; \
	   mkdir 32 ; \
	   mv xmlwf 32 \
	 )
	@rm -rf $(EXPAT32_PKG)/usr/include
	@rm -rf $(EXPAT32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files and
	@( cd $(EXPAT32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" libexpat.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(EXPAT32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexpat.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexpat.la \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" expat.pc \
	 )
	@(cd $(EXPAT32_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(EXPAT32_PKG_DESCRIPTION_FILE): $(EXPAT32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_expat32_pkg): $(install_target) $(EXPAT32_PKG_DESCRIPTION_FILE)
	@cp $(EXPAT32_PKG_DESCRIPTION_FILE) $(EXPAT32_PKG)/.DESCRIPTION
	@cp $(EXPAT32_PKG_INSTALL_SCRIPT) $(EXPAT32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(EXPAT32_PKG)/.REQUIRES
	@echo "pkgname=$(EXPAT32_PKG_NAME)"                            >  $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(EXPAT32_PKG_VERSION)"                          >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "arch=$(EXPAT32_PKG_ARCH)"                               >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "distroname=$(EXPAT32_PKG_DISTRO_NAME)"                  >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "distrover=$(EXPAT32_PKG_DISTRO_VERSION)"                >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "group=$(EXPAT32_PKG_GROUP)"                             >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(EXPAT32_PKG_SHORT_DESCRIPTION)\"" >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "url=$(EXPAT32_PKG_URL)"                                 >> $(EXPAT32_PKG)/.PKGINFO ; \
	 echo "license=$(EXPAT32_PKG_LICENSE)"                         >> $(EXPAT32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(EXPAT32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
