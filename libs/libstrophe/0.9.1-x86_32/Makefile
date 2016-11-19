
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/l/libstrophe

REQUIRES             = libs/libstrophe/0.9.1
REQUIRES             = libs/expat/2.1.1-x86_32
REQUIRES            += net/openssl/1.0.2f-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 0.9.1
tar_xz_archive       = $(SRC_PACKAGE_PATH)/packages/l/libstrophe/libstrophe-$(version).tar.xz
SRC_ARCHIVE          = $(tar_xz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libstrophe-$(version)
src_dir_name         = libstrophe-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBSTROPHE_32_PKG_NAME                = libstrophe-x32
LIBSTROPHE_32_PKG_VERSION             = 0.9.1
LIBSTROPHE_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSTROPHE_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSTROPHE_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSTROPHE_32_PKG_GROUP               = $(PKG_GROUP)
###                                    |---handy-ruler-------------------------------|
LIBSTROPHE_32_PKG_SHORT_DESCRIPTION   = An XMPP library for C
LIBSTROPHE_32_PKG_URL                 = $(BUG_URL)
LIBSTROPHE_32_PKG_LICENSE             = LGPLv2.1
LIBSTROPHE_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSTROPHE_32_PKG_NAME)-pkg-description
LIBSTROPHE_32_PKG_DESCRIPTION_FILE_IN = $(LIBSTROPHE_32_PKG_NAME)-pkg-description.in
LIBSTROPHE_32_PKG_INSTALL_SCRIPT      = $(LIBSTROPHE_32_PKG_NAME)-pkg-install.sh

LIBSTROPHE_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSTROPHE_32_PKG_NAME)-package

pkg_basename       = $(LIBSTROPHE_32_PKG_NAME)-$(LIBSTROPHE_32_PKG_VERSION)-$(LIBSTROPHE_32_PKG_ARCH)-$(LIBSTROPHE_32_PKG_DISTRO_NAME)-$(LIBSTROPHE_32_PKG_DISTRO_VERSION)

pkg_archive        = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature      = $(call sign-name,$(pkg_archive))
pkg_description    = $(call desc-name,$(pkg_archive))
products           = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS      = $(build_target)
BUILD_TARGETS     += $(install_target)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSTROPHE_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(LIBSTROPHE_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBSTROPHE_32_PKG)/usr/include
	@rm -rf $(LIBSTROPHE_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSTROPHE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libstrophe.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSTROPHE_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstrophe.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libstrophe.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstrophe.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSTROPHE_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSTROPHE_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSTROPHE_32_PKG_DESCRIPTION_FILE): $(LIBSTROPHE_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSTROPHE_32_PKG_DESCRIPTION_FILE) $(LIBSTROPHE_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSTROPHE_32_PKG_DESCRIPTION_FILE) $(LIBSTROPHE_32_PKG)/.DESCRIPTION
	@cp $(LIBSTROPHE_32_PKG_INSTALL_SCRIPT) $(LIBSTROPHE_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSTROPHE_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSTROPHE_32_PKG_NAME)"                            >  $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSTROPHE_32_PKG_VERSION)"                          >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSTROPHE_32_PKG_ARCH)"                               >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSTROPHE_32_PKG_DISTRO_NAME)"                  >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSTROPHE_32_PKG_DISTRO_VERSION)"                >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSTROPHE_32_PKG_GROUP)"                             >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSTROPHE_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSTROPHE_32_PKG_URL)"                                 >> $(LIBSTROPHE_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSTROPHE_32_PKG_LICENSE)"                         >> $(LIBSTROPHE_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSTROPHE_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
