
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/mpc

REQUIRES           = libs/mpc/1.0.2
REQUIRES          += libs/gmp/5.1.3-x86_32
REQUIRES          += libs/mpfr/3.1.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/mpc/mpc-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mpc-$(version)
src_dir_name       = mpc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
MPC_32_PKG_NAME                = mpc-x32
MPC_32_PKG_VERSION             = 1.0.2
MPC_32_PKG_ARCH                = $(TOOLCHAIN)
MPC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MPC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MPC_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
MPC_32_PKG_SHORT_DESCRIPTION   = complex floating-point library
MPC_32_PKG_URL                 = $(BUG_URL)
MPC_32_PKG_LICENSE             = GPLv2
MPC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MPC_32_PKG_NAME)-pkg-description
MPC_32_PKG_DESCRIPTION_FILE_IN = $(MPC_32_PKG_NAME)-pkg-description.in
MPC_32_PKG_INSTALL_SCRIPT      = $(MPC_32_PKG_NAME)-pkg-install.sh

MPC_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MPC_32_PKG_NAME)-package

pkg_basename     = $(MPC_32_PKG_NAME)-$(MPC_32_PKG_VERSION)-$(MPC_32_PKG_ARCH)-$(MPC_32_PKG_DISTRO_NAME)-$(MPC_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(MPC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
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
	@mkdir -p $(MPC_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(MPC_32_PKG)/usr/include
	@rm -rf $(MPC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MPC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmpc.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MPC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmpc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmpc.la \
	 )
	# ======= Strip binaries =======
	@( cd $(MPC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MPC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MPC_32_PKG_DESCRIPTION_FILE): $(MPC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MPC_32_PKG_DESCRIPTION_FILE) $(MPC_32_PKG_INSTALL_SCRIPT)
	@cp $(MPC_32_PKG_DESCRIPTION_FILE) $(MPC_32_PKG)/.DESCRIPTION
	@cp $(MPC_32_PKG_INSTALL_SCRIPT) $(MPC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MPC_32_PKG)/.REQUIRES
	@echo "pkgname=$(MPC_32_PKG_NAME)"                            >  $(MPC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MPC_32_PKG_VERSION)"                          >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(MPC_32_PKG_ARCH)"                               >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(MPC_32_PKG_DISTRO_NAME)"                  >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(MPC_32_PKG_DISTRO_VERSION)"                >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "group=$(MPC_32_PKG_GROUP)"                             >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MPC_32_PKG_SHORT_DESCRIPTION)\"" >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "url=$(MPC_32_PKG_URL)"                                 >> $(MPC_32_PKG)/.PKGINFO ; \
	 echo "license=$(MPC_32_PKG_LICENSE)"                         >> $(MPC_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(MPC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
