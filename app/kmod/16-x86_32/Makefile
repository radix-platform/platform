
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/kmod

REQUIRES           = app/kmod/22
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += app/xz/5.2.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 16
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/kmod/kmod-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/kmod-$(version)
src_dir_name       = kmod-$(version)
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
KMOD_32_PKG_NAME                = kmod-x32
KMOD_32_PKG_VERSION             = 16
KMOD_32_PKG_ARCH                = $(TOOLCHAIN)
KMOD_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KMOD_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KMOD_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
KMOD_32_PKG_SHORT_DESCRIPTION   = kernel module x86_32 library
KMOD_32_PKG_URL                 = $(BUG_URL)
KMOD_32_PKG_LICENSE             = GPLv2
KMOD_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KMOD_32_PKG_NAME)-pkg-description
KMOD_32_PKG_DESCRIPTION_FILE_IN = $(KMOD_32_PKG_NAME)-pkg-description.in
KMOD_32_PKG_INSTALL_SCRIPT      = $(KMOD_32_PKG_NAME)-pkg-install.sh

KMOD_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KMOD_32_PKG_NAME)-package

pkg_basename     = $(KMOD_32_PKG_NAME)-$(KMOD_32_PKG_VERSION)-$(KMOD_32_PKG_ARCH)-$(KMOD_32_PKG_DISTRO_NAME)-$(KMOD_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(KMOD_32_PKG)


extra_configure_switches  = --libdir=/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --bindir=/sbin
extra_configure_switches += --sbindir=/sbin
extra_configure_switches += --with-xz
extra_configure_switches += --with-zlib


TARGET_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
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
	@mkdir -p $(KMOD_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(KMOD_32_PKG)/sbin
	@rm -rf $(KMOD_32_PKG)/usr/include
	@rm -rf $(KMOD_32_PKG)/usr/share
	@mkdir -p $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@mv $(KMOD_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@mv $(KMOD_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/{*.so,*.la} $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@cp -a $(KMOD_32_PKG)/lib$(MULTILIB_X86_32_SUFFIX)/libkmod.so.2 $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)
	@( cd $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	  ln -sf ../../lib$(MULTILIB_X86_32_SUFFIX)/libkmod.so.2.2.6 libkmod.so.2.2.6 ; \
	  sed -i "s,libdir='/lib,libdir='/usr/lib,g" libkmod.la ; \
	  sed -i "s,libdir=/lib,libdir=/usr/lib,g" pkgconfig/libkmod.pc \
	 )
	# remove toolchain path from target libtool *.la files
	@( cd $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libkmod.la  \
	 )
	# ======= remove -L/lib, -L/usr/lib options from target libtool *.la files =======
	@( cd $(KMOD_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,-L/usr/lib ,,g" libkmod.la ; \
	   sed -i "s,-L/lib ,,g" libkmod.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(KMOD_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkmod.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libkmod.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkmod.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(KMOD_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(KMOD_32_PKG) ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(KMOD_32_PKG) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(KMOD_32_PKG_DESCRIPTION_FILE): $(KMOD_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KMOD_32_PKG_DESCRIPTION_FILE) $(KMOD_32_PKG_INSTALL_SCRIPT)
	@cp $(KMOD_32_PKG_DESCRIPTION_FILE) $(KMOD_32_PKG)/.DESCRIPTION
	@cp $(KMOD_32_PKG_INSTALL_SCRIPT) $(KMOD_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KMOD_32_PKG)/.REQUIRES
	@echo "pkgname=$(KMOD_32_PKG_NAME)"                            >  $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KMOD_32_PKG_VERSION)"                          >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "arch=$(KMOD_32_PKG_ARCH)"                               >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(KMOD_32_PKG_DISTRO_NAME)"                  >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(KMOD_32_PKG_DISTRO_VERSION)"                >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "group=$(KMOD_32_PKG_GROUP)"                             >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KMOD_32_PKG_SHORT_DESCRIPTION)\"" >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "url=$(KMOD_32_PKG_URL)"                                 >> $(KMOD_32_PKG)/.PKGINFO ; \
	 echo "license=$(KMOD_32_PKG_LICENSE)"                         >> $(KMOD_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(KMOD_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
