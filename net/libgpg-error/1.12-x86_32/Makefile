
COMPONENT_TARGETS   += $(TARGET_PC64)

NEED_ABS_PATH        = true

COMPONENT_IS_3PP     = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = $(SRC_PACKAGE_DIR)/packages/n/libgpg-error

REQUIRES             = libs/eglibc/2.18.1


version              = 1.12
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libgpg-error/libgpg-error-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libgpg-error-$(version)
src_dir_name         = libgpg-error-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done
build_gpgerror32_pkg = $(TARGET_BUILD_DIR)/.gpgerror32_pkg_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPGERROR32_PKG_NAME                = libgpg-error32
GPGERROR32_PKG_VERSION             = 1.12
GPGERROR32_PKG_ARCH                = $(TOOLCHAIN)
GPGERROR32_PKG_DISTRO_NAME         = kxLab
GPGERROR32_PKG_DISTRO_VERSION      = 1.0
GPGERROR32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GPGERROR32_PKG_SHORT_DESCRIPTION   = libgpg-error32 $(version)
GPGERROR32_PKG_URL                 = http://www.kxLab.com
GPGERROR32_PKG_LICENSE             = GPLv2
GPGERROR32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPGERROR32_PKG_NAME)-pkg-description
GPGERROR32_PKG_DESCRIPTION_FILE_IN = $(GPGERROR32_PKG_NAME)-pkg-description.in
GPGERROR32_PKG_INSTALL_SCRIPT      = $(GPGERROR32_PKG_NAME)-pkg-install.sh

GPGERROR32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPGERROR32_PKG_NAME)-package

pkg_basename     = $(GPGERROR32_PKG_NAME)-$(GPGERROR32_PKG_VERSION)-$(GPGERROR32_PKG_ARCH)-$(GPGERROR32_PKG_DISTRO_NAME)-$(GPGERROR32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(GPGERROR32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_gpgerror32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GPGERROR32_PKG)


CC          += -m32
CXX         += -m32

# owerwrite LDFLAGS:
#
LDFLAGS      = -L$(TARGET_DEST_DIR)/lib$(MULTILIB_X86_32_SUFFIX)
LDFLAGS     += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)

ARCH_FLAGS   = -m32 -g -O3 -march=i486 -mtune=i686

TARGET32     = $(shell echo $(TARGET) | sed 's/x86_64/i486/')


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
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
	@mkdir -p $(GPGERROR32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(GPGERROR32_PKG)/usr/bin/32
	@( cd $(GPGERROR32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(GPGERROR32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(GPGERROR32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod +w lib*.so.?.*.? ; \
	   mv lib*.so.?.*.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.?.*.? . ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@rm -rf $(GPGERROR32_PKG)/usr/include
	@rm -rf $(GPGERROR32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(GPGERROR32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgpg-error.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GPGERROR32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgpg-error.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgpg-error.la  \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	  sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" gpg-error-config ; \
	  sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" gpg-error-config ; \
	 )
	@( cd $(GPGERROR32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GPGERROR32_PKG_DESCRIPTION_FILE): $(GPGERROR32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_gpgerror32_pkg): $(install_target) $(GPGERROR32_PKG_DESCRIPTION_FILE)
	@cp $(GPGERROR32_PKG_DESCRIPTION_FILE) $(GPGERROR32_PKG)/.DESCRIPTION
	@cp $(GPGERROR32_PKG_INSTALL_SCRIPT) $(GPGERROR32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPGERROR32_PKG)/.REQUIRES
	@echo "pkgname=$(GPGERROR32_PKG_NAME)"                            >  $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPGERROR32_PKG_VERSION)"                          >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "arch=$(GPGERROR32_PKG_ARCH)"                               >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPGERROR32_PKG_DISTRO_NAME)"                  >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPGERROR32_PKG_DISTRO_VERSION)"                >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "group=$(GPGERROR32_PKG_GROUP)"                             >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPGERROR32_PKG_SHORT_DESCRIPTION)\"" >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "url=$(GPGERROR32_PKG_URL)"                                 >> $(GPGERROR32_PKG)/.PKGINFO ; \
	 echo "license=$(GPGERROR32_PKG_LICENSE)"                         >> $(GPGERROR32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GPGERROR32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
