
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libmbim

REQUIRES             = net/libmbim/1.12.4
REQUIRES            += libs/libgudev/230-x86_32

# ======= __END_OF_REQUIRES__ =======


version              = 1.12.4
tar_xz_archive       = $(SRC_PACKAGE_PATH)/packages/n/libmbim/libmbim-$(version).tar.xz
SRC_ARCHIVE          = $(tar_xz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libmbim-$(version)
src_dir_name         = libmbim-$(version)
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
LIBMBIM_32_PKG_NAME                = libmbim-x32
LIBMBIM_32_PKG_VERSION             = 1.12.4
LIBMBIM_32_PKG_ARCH                = $(TOOLCHAIN)
LIBMBIM_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBMBIM_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBMBIM_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBMBIM_32_PKG_SHORT_DESCRIPTION   = MBIM library
LIBMBIM_32_PKG_URL                 = $(BUG_URL)
LIBMBIM_32_PKG_LICENSE             = LGPLv2.1
LIBMBIM_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBMBIM_32_PKG_NAME)-pkg-description
LIBMBIM_32_PKG_DESCRIPTION_FILE_IN = $(LIBMBIM_32_PKG_NAME)-pkg-description.in
LIBMBIM_32_PKG_INSTALL_SCRIPT      = $(LIBMBIM_32_PKG_NAME)-pkg-install.sh

LIBMBIM_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBMBIM_32_PKG_NAME)-package

pkg_basename     = $(LIBMBIM_32_PKG_NAME)-$(LIBMBIM_32_PKG_VERSION)-$(LIBMBIM_32_PKG_ARCH)-$(LIBMBIM_32_PKG_DISTRO_NAME)-$(LIBMBIM_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBMBIM_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-gtk-doc-html=no
extra_configure_switches += --enable-gtk-doc-pdf=no
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
	@mkdir -p $(LIBMBIM_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBMBIM_32_PKG)/usr/bin
	@rm -rf $(LIBMBIM_32_PKG)/usr/include
	@rm -rf $(LIBMBIM_32_PKG)/usr/libexec
	@rm -rf $(LIBMBIM_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBMBIM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmbim-glib.la ; \
	   sed -i "s,-L/usr/lib32 -L/usr/lib32,-L/usr/lib32,g" libmbim-glib.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBMBIM_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmbim-glib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmbim-glib.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" mbim-glib.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBMBIM_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBMBIM_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBMBIM_32_PKG_DESCRIPTION_FILE): $(LIBMBIM_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBMBIM_32_PKG_DESCRIPTION_FILE) $(LIBMBIM_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBMBIM_32_PKG_DESCRIPTION_FILE) $(LIBMBIM_32_PKG)/.DESCRIPTION
	@cp $(LIBMBIM_32_PKG_INSTALL_SCRIPT) $(LIBMBIM_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBMBIM_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBMBIM_32_PKG_NAME)"                            >  $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBMBIM_32_PKG_VERSION)"                          >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBMBIM_32_PKG_ARCH)"                               >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBMBIM_32_PKG_DISTRO_NAME)"                  >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBMBIM_32_PKG_DISTRO_VERSION)"                >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBMBIM_32_PKG_GROUP)"                             >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBMBIM_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBMBIM_32_PKG_URL)"                                 >> $(LIBMBIM_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBMBIM_32_PKG_LICENSE)"                         >> $(LIBMBIM_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBMBIM_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
