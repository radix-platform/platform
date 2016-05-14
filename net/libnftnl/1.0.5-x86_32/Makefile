
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libnftnl

REQUIRES             = net/libnftnl/1.0.5
REQUIRES            += net/libmnl/1.0.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 1.0.5
tar_bz2_archive      = $(SRC_PACKAGE_PATH)/packages/n/libnftnl/libnftnl-$(version).tar.bz2
SRC_ARCHIVE          = $(tar_bz2_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libnftnl-$(version)
src_dir_name         = libnftnl-$(version)
src_done             = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir            = $(TARGET_BUILD_DIR)/build
build_target         = $(TARGET_BUILD_DIR)/.build_done
install_target       = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBNFTNL_32_PKG_NAME                = libnftnl-x32
LIBNFTNL_32_PKG_VERSION             = 1.0.5
LIBNFTNL_32_PKG_ARCH                = $(TOOLCHAIN)
LIBNFTNL_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNFTNL_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNFTNL_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBNFTNL_32_PKG_SHORT_DESCRIPTION   = kernel nf_tables subsystem interface
LIBNFTNL_32_PKG_URL                 = $(BUG_URL)
LIBNFTNL_32_PKG_LICENSE             = GPLv2
LIBNFTNL_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNFTNL_32_PKG_NAME)-pkg-description
LIBNFTNL_32_PKG_DESCRIPTION_FILE_IN = $(LIBNFTNL_32_PKG_NAME)-pkg-description.in
LIBNFTNL_32_PKG_INSTALL_SCRIPT      = $(LIBNFTNL_32_PKG_NAME)-pkg-install.sh

LIBNFTNL_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNFTNL_32_PKG_NAME)-package

pkg_basename        = $(LIBNFTNL_32_PKG_NAME)-$(LIBNFTNL_32_PKG_VERSION)-$(LIBNFTNL_32_PKG_ARCH)-$(LIBNFTNL_32_PKG_DISTRO_NAME)-$(LIBNFTNL_32_PKG_DISTRO_VERSION)

pkg_archive         = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature       = $(call sign-name,$(pkg_archive))
pkg_description     = $(call desc-name,$(pkg_archive))
products            = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS       = $(build_target)
BUILD_TARGETS      += $(install_target)

PRODUCT_TARGETS     = $(products)

ROOTFS_TARGETS      = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNFTNL_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
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
	@mkdir -p $(LIBNFTNL_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBNFTNL_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNFTNL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnftnl.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNFTNL_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnftnl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnftnl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnftnl.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNFTNL_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBNFTNL_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBNFTNL_32_PKG_DESCRIPTION_FILE): $(LIBNFTNL_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNFTNL_32_PKG_DESCRIPTION_FILE) $(LIBNFTNL_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBNFTNL_32_PKG_DESCRIPTION_FILE) $(LIBNFTNL_32_PKG)/.DESCRIPTION
	@cp $(LIBNFTNL_32_PKG_INSTALL_SCRIPT) $(LIBNFTNL_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNFTNL_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNFTNL_32_PKG_NAME)"                            >  $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNFTNL_32_PKG_VERSION)"                          >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNFTNL_32_PKG_ARCH)"                               >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNFTNL_32_PKG_DISTRO_NAME)"                  >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNFTNL_32_PKG_DISTRO_VERSION)"                >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNFTNL_32_PKG_GROUP)"                             >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNFTNL_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNFTNL_32_PKG_URL)"                                 >> $(LIBNFTNL_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNFTNL_32_PKG_LICENSE)"                         >> $(LIBNFTNL_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBNFTNL_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
