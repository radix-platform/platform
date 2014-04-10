
COMPONENT_TARGETS   += $(TARGET_PC64)

NEED_ABS_PATH        = true

COMPONENT_IS_3PP     = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = $(SRC_PACKAGE_DIR)/packages/n/libassuan

REQUIRES             = net/libgpg-error/1.12


version              = 2.1.1
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libassuan/libassuan-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libassuan-$(version)
src_dir_name         = libassuan-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done
build_assuan32_pkg   = $(TARGET_BUILD_DIR)/.assuan32_pkg_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ASSUAN32_PKG_NAME                = libassuan32
ASSUAN32_PKG_VERSION             = 2.1.1
ASSUAN32_PKG_ARCH                = $(TOOLCHAIN)
ASSUAN32_PKG_DISTRO_NAME         = kxLab
ASSUAN32_PKG_DISTRO_VERSION      = 1.0
ASSUAN32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
ASSUAN32_PKG_SHORT_DESCRIPTION   = libassuan32 $(version)
ASSUAN32_PKG_URL                 = http://www.kxLab.com
ASSUAN32_PKG_LICENSE             = GPLv2
ASSUAN32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ASSUAN32_PKG_NAME)-pkg-description
ASSUAN32_PKG_DESCRIPTION_FILE_IN = $(ASSUAN32_PKG_NAME)-pkg-description.in
ASSUAN32_PKG_INSTALL_SCRIPT      = $(ASSUAN32_PKG_NAME)-pkg-install.sh

ASSUAN32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ASSUAN32_PKG_NAME)-package

pkg_basename     = $(ASSUAN32_PKG_NAME)-$(ASSUAN32_PKG_VERSION)-$(ASSUAN32_PKG_ARCH)-$(ASSUAN32_PKG_DISTRO_NAME)-$(ASSUAN32_PKG_DISTRO_VERSION)
pkg_basename_tgz = $(TARGET_BUILD_DIR)/$(ASSUAN32_PKG_GROUP)/$(pkg_basename).tgz


BUILD_TARGETS    = $(build_assuan32_pkg)

ROOTFS_TARGETS   = $(pkg_basename_tgz)

PRODUCT_TARGETS  = $(TARGET_BUILD_DIR)/$(PKG_GROUP)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(ASSUAN32_PKG)


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

gpg_error_config = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/gpg-error-config


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(gpg_error_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(ASSUAN32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(ASSUAN32_PKG)/usr/bin/32
	@( cd $(ASSUAN32_PKG)/usr/bin ; \
	   find . -type f | xargs mv -t 32 ; \
	 )
	@mkdir -p $(ASSUAN32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(ASSUAN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod +w lib*.so.?.*.? ; \
	   mv lib*.so.?.*.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/lib*.so.?.*.? . ; \
	   cp -a lib*.so.? ../../lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@rm -rf $(ASSUAN32_PKG)/usr/include
	@rm -rf $(ASSUAN32_PKG)/usr/share
	# remove toolchain path from target libtool *.la files
	@( cd $(ASSUAN32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libassuan.la ; \
	 )
	@( cd $(ASSUAN32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libassuan-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ASSUAN32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# tune libtool *.la search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libassuan.la  ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libassuan.la  \
	 )
	# tune pkg-config *.pc search path to the target destination for development
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	  sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" libassuan-config ; \
	  sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" libassuan-config ; \
	  sed -i "s,-I/usr,-I$(TARGET_DEST_DIR)/usr,g" libassuan-config ; \
	 )
	@( cd $(ASSUAN32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(ASSUAN32_PKG_DESCRIPTION_FILE): $(ASSUAN32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(build_assuan32_pkg): $(install_target) $(ASSUAN32_PKG_DESCRIPTION_FILE)
	@cp $(ASSUAN32_PKG_DESCRIPTION_FILE) $(ASSUAN32_PKG)/.DESCRIPTION
	@cp $(ASSUAN32_PKG_INSTALL_SCRIPT) $(ASSUAN32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ASSUAN32_PKG)/.REQUIRES
	@echo "pkgname=$(ASSUAN32_PKG_NAME)"                            >  $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ASSUAN32_PKG_VERSION)"                          >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "arch=$(ASSUAN32_PKG_ARCH)"                               >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "distroname=$(ASSUAN32_PKG_DISTRO_NAME)"                  >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "distrover=$(ASSUAN32_PKG_DISTRO_VERSION)"                >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "group=$(ASSUAN32_PKG_GROUP)"                             >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ASSUAN32_PKG_SHORT_DESCRIPTION)\"" >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "url=$(ASSUAN32_PKG_URL)"                                 >> $(ASSUAN32_PKG)/.PKGINFO ; \
	 echo "license=$(ASSUAN32_PKG_LICENSE)"                         >> $(ASSUAN32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ASSUAN32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
