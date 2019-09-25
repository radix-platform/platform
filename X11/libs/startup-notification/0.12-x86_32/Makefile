
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/startup-notification

REQUIRES           = X11/libs/startup-notification/0.12
REQUIRES          += X11/X.org/lib/libX11/1.6.3-x86_32
REQUIRES          += X11/X.org/xcb/xcb-util/0.4.0-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/startup-notification/startup-notification-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/startup-notification-$(version)
src_dir_name       = startup-notification-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
STN_32_PKG_NAME                = startup-notification-x32
STN_32_PKG_VERSION             = 0.12
STN_32_PKG_ARCH                = $(TOOLCHAIN)
STN_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
STN_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
STN_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
STN_32_PKG_SHORT_DESCRIPTION   = startup notification protocol
STN_32_PKG_URL                 = $(BUG_URL)
STN_32_PKG_LICENSE             = LGPLv2
STN_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(STN_32_PKG_NAME)-pkg-description
STN_32_PKG_DESCRIPTION_FILE_IN = $(STN_32_PKG_NAME)-pkg-description.in
STN_32_PKG_INSTALL_SCRIPT      = $(STN_32_PKG_NAME)-pkg-install.sh

STN_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(STN_32_PKG_NAME)-package

pkg_basename     = $(STN_32_PKG_NAME)-$(STN_32_PKG_VERSION)-$(STN_32_PKG_ARCH)-$(STN_32_PKG_DISTRO_NAME)-$(STN_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(STN_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var/lib

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


configure_options  = lf_cv_sane_realloc=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(configure_options) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(STN_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(STN_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(STN_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libstartup-notification-?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(STN_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstartup-notification-?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libstartup-notification-?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstartup-notification-?.?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(STN_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(STN_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(STN_32_PKG_DESCRIPTION_FILE): $(STN_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(STN_32_PKG_DESCRIPTION_FILE) $(STN_32_PKG_INSTALL_SCRIPT)
	@cp $(STN_32_PKG_DESCRIPTION_FILE) $(STN_32_PKG)/.DESCRIPTION
	@cp $(STN_32_PKG_INSTALL_SCRIPT) $(STN_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(STN_32_PKG)/.REQUIRES
	@echo "pkgname=$(STN_32_PKG_NAME)"                            >  $(STN_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(STN_32_PKG_VERSION)"                          >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "arch=$(STN_32_PKG_ARCH)"                               >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(STN_32_PKG_DISTRO_NAME)"                  >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(STN_32_PKG_DISTRO_VERSION)"                >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "group=$(STN_32_PKG_GROUP)"                             >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(STN_32_PKG_SHORT_DESCRIPTION)\"" >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "url=$(STN_32_PKG_URL)"                                 >> $(STN_32_PKG)/.PKGINFO ; \
	 echo "license=$(STN_32_PKG_LICENSE)"                         >> $(STN_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(STN_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
