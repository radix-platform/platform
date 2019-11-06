
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/libnfnetlink

REQUIRES           = net/libnfnetlink/1.0.1
REQUIRES          += libs/glibc/2.28-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libnfnetlink/libnfnetlink-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libnfnetlink-$(version)
src_dir_name       = libnfnetlink-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBNFNETLINK_32_PKG_NAME                = libnfnetlink-x32
LIBNFNETLINK_32_PKG_VERSION             = 1.0.1
LIBNFNETLINK_32_PKG_ARCH                = $(TOOLCHAIN)
LIBNFNETLINK_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNFNETLINK_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNFNETLINK_32_PKG_GROUP               = $(PKG_GROUP)
###                                      |---handy-ruler-------------------------------|
LIBNFNETLINK_32_PKG_SHORT_DESCRIPTION   = library for netfilter
LIBNFNETLINK_32_PKG_URL                 = $(BUG_URL)
LIBNFNETLINK_32_PKG_LICENSE             = GPLv2
LIBNFNETLINK_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNFNETLINK_32_PKG_NAME)-pkg-description
LIBNFNETLINK_32_PKG_DESCRIPTION_FILE_IN = $(LIBNFNETLINK_32_PKG_NAME)-pkg-description.in
LIBNFNETLINK_32_PKG_INSTALL_SCRIPT      = $(LIBNFNETLINK_32_PKG_NAME)-pkg-install.sh

LIBNFNETLINK_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNFNETLINK_32_PKG_NAME)-package

pkg_basename     = $(LIBNFNETLINK_32_PKG_NAME)-$(LIBNFNETLINK_32_PKG_VERSION)-$(LIBNFNETLINK_32_PKG_ARCH)-$(LIBNFNETLINK_32_PKG_DISTRO_NAME)-$(LIBNFNETLINK_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNFNETLINK_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


LDFLAGS += -Wl,-rpath,/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(LIBNFNETLINK_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBNFNETLINK_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNFNETLINK_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnfnetlink.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNFNETLINK_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libnfnetlink.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnfnetlink.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnfnetlink.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNFNETLINK_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBNFNETLINK_32_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBNFNETLINK_32_PKG_DESCRIPTION_FILE): $(LIBNFNETLINK_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNFNETLINK_32_PKG_DESCRIPTION_FILE) $(LIBNFNETLINK_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBNFNETLINK_32_PKG_DESCRIPTION_FILE) $(LIBNFNETLINK_32_PKG)/.DESCRIPTION
	@cp $(LIBNFNETLINK_32_PKG_INSTALL_SCRIPT) $(LIBNFNETLINK_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNFNETLINK_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNFNETLINK_32_PKG_NAME)"                            >  $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNFNETLINK_32_PKG_VERSION)"                          >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNFNETLINK_32_PKG_ARCH)"                               >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNFNETLINK_32_PKG_DISTRO_NAME)"                  >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNFNETLINK_32_PKG_DISTRO_VERSION)"                >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNFNETLINK_32_PKG_GROUP)"                             >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNFNETLINK_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNFNETLINK_32_PKG_URL)"                                 >> $(LIBNFNETLINK_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNFNETLINK_32_PKG_LICENSE)"                         >> $(LIBNFNETLINK_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBNFNETLINK_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
