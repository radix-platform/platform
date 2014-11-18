
COMPONENT_TARGETS    = $(HARDWARE_PC64)

NEED_ABS_PATH        = true
COMPONENT_IS_3PP     = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES      = sources/packages/n/libqmi

REQUIRES             = net/libqmi/1.10.4
REQUIRES            += libs/libffi/3.0.13-x86_32
REQUIRES            += libs/pcre/8.34-x86_32
REQUIRES            += libs/glib2/2.40.0-x86_32


version              = 1.10.4
tar_xz_archive       = $(SRC_PACKAGE_PATH)/packages/n/libqmi/libqmi-$(version).tar.xz
SRC_ARCHIVE          = $(tar_xz_archive)
SRC_DIR              = $(TARGET_BUILD_DIR)/libqmi-$(version)
src_dir_name         = libqmi-$(version)
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
LIBQMI_32_PKG_NAME                = libqmi-x32
LIBQMI_32_PKG_VERSION             = 1.10.4
LIBQMI_32_PKG_ARCH                = $(TOOLCHAIN)
LIBQMI_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBQMI_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBQMI_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBQMI_32_PKG_SHORT_DESCRIPTION   = QMI library
LIBQMI_32_PKG_URL                 = $(BUG_URL)
LIBQMI_32_PKG_LICENSE             = LGPLv2.1
LIBQMI_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBQMI_32_PKG_NAME)-pkg-description
LIBQMI_32_PKG_DESCRIPTION_FILE_IN = $(LIBQMI_32_PKG_NAME)-pkg-description.in
LIBQMI_32_PKG_INSTALL_SCRIPT      = $(LIBQMI_32_PKG_NAME)-pkg-install.sh

LIBQMI_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBQMI_32_PKG_NAME)-package

pkg_basename     = $(LIBQMI_32_PKG_NAME)-$(LIBQMI_32_PKG_VERSION)-$(LIBQMI_32_PKG_ARCH)-$(LIBQMI_32_PKG_DISTRO_NAME)-$(LIBQMI_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBQMI_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-gtk-doc-html=no
extra_configure_switches += --enable-gtk-doc-pdf=no
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
	@mkdir -p $(LIBQMI_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBQMI_32_PKG)/usr/bin
	@rm -rf $(LIBQMI_32_PKG)/usr/include
	@rm -rf $(LIBQMI_32_PKG)/usr/libexec
	@rm -rf $(LIBQMI_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBQMI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libqmi-glib.la ; \
	   sed -i "s,-L/usr/lib32 -L/usr/lib32,-L/usr/lib32,g" libqmi-glib.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBQMI_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libqmi-glib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libqmi-glib.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" qmi-glib.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBQMI_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBQMI_32_PKG_DESCRIPTION_FILE): $(LIBQMI_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBQMI_32_PKG_DESCRIPTION_FILE) $(LIBQMI_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBQMI_32_PKG_DESCRIPTION_FILE) $(LIBQMI_32_PKG)/.DESCRIPTION
	@cp $(LIBQMI_32_PKG_INSTALL_SCRIPT) $(LIBQMI_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBQMI_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBQMI_32_PKG_NAME)"                            >  $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBQMI_32_PKG_VERSION)"                          >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBQMI_32_PKG_ARCH)"                               >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBQMI_32_PKG_DISTRO_NAME)"                  >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBQMI_32_PKG_DISTRO_VERSION)"                >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBQMI_32_PKG_GROUP)"                             >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBQMI_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBQMI_32_PKG_URL)"                                 >> $(LIBQMI_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBQMI_32_PKG_LICENSE)"                         >> $(LIBQMI_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBQMI_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
