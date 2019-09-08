
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/gmp

REQUIRES           = libs/gmp/6.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 6.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNU/gmp/gmp-$(version)a.tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gmp-$(version)
src_dir_name       = gmp-$(version)
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
GMP_32_PKG_NAME                = gmp-x32
GMP_32_PKG_VERSION             = 6.0.0
GMP_32_PKG_ARCH                = $(TOOLCHAIN)
GMP_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GMP_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GMP_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
GMP_32_PKG_SHORT_DESCRIPTION   = GNU multiple precision arithmetic library
GMP_32_PKG_URL                 = $(BUG_URL)
GMP_32_PKG_LICENSE             = GPLv2
GMP_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GMP_32_PKG_NAME)-pkg-description
GMP_32_PKG_DESCRIPTION_FILE_IN = $(GMP_32_PKG_NAME)-pkg-description.in
GMP_32_PKG_INSTALL_SCRIPT      = $(GMP_32_PKG_NAME)-pkg-install.sh

GMP_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GMP_32_PKG_NAME)-package

pkg_basename     = $(GMP_32_PKG_NAME)-$(GMP_32_PKG_VERSION)-$(GMP_32_PKG_ARCH)-$(GMP_32_PKG_DISTRO_NAME)-$(GMP_32_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(GMP_32_PKG)

CPPFLAGS   += -fexceptions

extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --with-gnu-ld
extra_configure_switches += --enable-cxx
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
	@mkdir -p $(GMP_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GMP_32_PKG)/usr/include
	@rm -rf $(GMP_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GMP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgmp.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgmpxx.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GMP_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgmp.la ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgmpxx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgmp.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgmpxx.la \
	 )
	# ======= Strip binaries =======
	@( cd $(GMP_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GMP_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GMP_32_PKG_DESCRIPTION_FILE): $(GMP_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GMP_32_PKG_DESCRIPTION_FILE) $(GMP_32_PKG_INSTALL_SCRIPT)
	@cp $(GMP_32_PKG_DESCRIPTION_FILE) $(GMP_32_PKG)/.DESCRIPTION
	@cp $(GMP_32_PKG_INSTALL_SCRIPT) $(GMP_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GMP_32_PKG)/.REQUIRES
	@echo "pkgname=$(GMP_32_PKG_NAME)"                            >  $(GMP_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GMP_32_PKG_VERSION)"                          >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GMP_32_PKG_ARCH)"                               >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GMP_32_PKG_DISTRO_NAME)"                  >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GMP_32_PKG_DISTRO_VERSION)"                >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "group=$(GMP_32_PKG_GROUP)"                             >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GMP_32_PKG_SHORT_DESCRIPTION)\"" >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "url=$(GMP_32_PKG_URL)"                                 >> $(GMP_32_PKG)/.PKGINFO ; \
	 echo "license=$(GMP_32_PKG_LICENSE)"                         >> $(GMP_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GMP_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
