
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/a/xfsprogs

REQUIRES             = app/xfsprogs/4.7.0
REQUIRES            += app/util-linux/2.27.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 4.7.0
tar_gz_archive       = $(SRC_PACKAGE_PATH)/packages/a/xfsprogs/xfsprogs-$(version).tar.gz
SRC_ARCHIVE          = $(tar_gz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/xfsprogs-$(version)
src_dir_name         = xfsprogs-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XFSPROGS_32_PKG_NAME                = xfsprogs-x32
XFSPROGS_32_PKG_VERSION             = 4.7.0
XFSPROGS_32_PKG_ARCH                = $(TOOLCHAIN)
XFSPROGS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XFSPROGS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XFSPROGS_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
XFSPROGS_32_PKG_SHORT_DESCRIPTION   = XFS filesystem x86_32 libraries
XFSPROGS_32_PKG_URL                 = $(BUG_URL)
XFSPROGS_32_PKG_LICENSE             = GPLv2
XFSPROGS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XFSPROGS_32_PKG_NAME)-pkg-description
XFSPROGS_32_PKG_DESCRIPTION_FILE_IN = $(XFSPROGS_32_PKG_NAME)-pkg-description.in
XFSPROGS_32_PKG_INSTALL_SCRIPT      = $(XFSPROGS_32_PKG_NAME)-pkg-install.sh

XFSPROGS_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XFSPROGS_32_PKG_NAME)-package

pkg_basename     = $(XFSPROGS_32_PKG_NAME)-$(XFSPROGS_32_PKG_VERSION)-$(XFSPROGS_32_PKG_ARCH)-$(XFSPROGS_32_PKG_DISTRO_NAME)-$(XFSPROGS_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DIST_ROOT=$(XFSPROGS_32_PKG)

extra_configure_switches  = --libdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --libexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --bindir=/usr/sbin
extra_configure_switches += --includedir=/usr/include
extra_configure_switches += --datadir=/usr/share
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-shared=yes

environment  = BUILD_CC=gcc
environment += BUILD_CFLAGS='-I../include'

CFLAGS += -D_DEFAULT_SOURCE


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) $(environment) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XFSPROGS_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install-dev $(env_sysroot)
	@mkdir -p $(XFSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(XFSPROGS_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   chmod 755 *.la ; \
	   cp -a libhandle.so.? $(XFSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   mv *.a *.la *.so $(XFSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	 )
	@( cd $(XFSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libhandle.so.?.?.? . \
	 )
	@rm -rf $(XFSPROGS_32_PKG)/sbin
	@rm -rf $(XFSPROGS_32_PKG)/usr/include
	@rm -rf $(XFSPROGS_32_PKG)/usr/share
	# ======= remove target path from target libtool *.la files =======
	@( cd $(XFSPROGS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libhandle.la ; \
	   sed -i "s,'/lib,'/usr/lib,g" libhandle.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XFSPROGS_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libhandle.la   ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libhandle.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(XFSPROGS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(XFSPROGS_32_PKG_DESCRIPTION_FILE): $(XFSPROGS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XFSPROGS_32_PKG_DESCRIPTION_FILE) $(XFSPROGS_32_PKG_INSTALL_SCRIPT)
	@cp $(XFSPROGS_32_PKG_DESCRIPTION_FILE) $(XFSPROGS_32_PKG)/.DESCRIPTION
	@cp $(XFSPROGS_32_PKG_INSTALL_SCRIPT) $(XFSPROGS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XFSPROGS_32_PKG)/.REQUIRES
	@echo "pkgname=$(XFSPROGS_32_PKG_NAME)"                            >  $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XFSPROGS_32_PKG_VERSION)"                          >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(XFSPROGS_32_PKG_ARCH)"                               >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(XFSPROGS_32_PKG_DISTRO_NAME)"                  >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(XFSPROGS_32_PKG_DISTRO_VERSION)"                >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "group=$(XFSPROGS_32_PKG_GROUP)"                             >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XFSPROGS_32_PKG_SHORT_DESCRIPTION)\"" >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "url=$(XFSPROGS_32_PKG_URL)"                                 >> $(XFSPROGS_32_PKG)/.PKGINFO ; \
	 echo "license=$(XFSPROGS_32_PKG_LICENSE)"                         >> $(XFSPROGS_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(XFSPROGS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
