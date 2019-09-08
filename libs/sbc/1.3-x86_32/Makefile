
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/sbc

REQUIRES           = libs/sbc/1.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.3
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/sbc/sbc-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sbc-$(version)
src_dir_name       = sbc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SBC_32_PKG_NAME                = sbc-x32
SBC_32_PKG_VERSION             = 1.3
SBC_32_PKG_ARCH                = $(TOOLCHAIN)
SBC_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SBC_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SBC_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
SBC_32_PKG_SHORT_DESCRIPTION   = Bluetooth Subband Codec library
SBC_32_PKG_URL                 = $(BUG_URL)
SBC_32_PKG_LICENSE             = GPLv2
SBC_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SBC_32_PKG_NAME)-pkg-description
SBC_32_PKG_DESCRIPTION_FILE_IN = $(SBC_32_PKG_NAME)-pkg-description.in
SBC_32_PKG_INSTALL_SCRIPT      = $(SBC_32_PKG_NAME)-pkg-install.sh

SBC_32_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SBC_32_PKG_NAME)-package

pkg_basename      = $(SBC_32_PKG_NAME)-$(SBC_32_PKG_VERSION)-$(SBC_32_PKG_ARCH)-$(SBC_32_PKG_DISTRO_NAME)-$(SBC_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SBC_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --disable-tester

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SBC_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(SBC_32_PKG)/usr/include
	@rm -rf $(SBC_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SBC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsbc.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SBC_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsbc.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsbc.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sbc.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SBC_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(SBC_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SBC_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SBC_32_PKG_DESCRIPTION_FILE): $(SBC_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SBC_32_PKG_DESCRIPTION_FILE) $(SBC_32_PKG_INSTALL_SCRIPT)
	@cp $(SBC_32_PKG_DESCRIPTION_FILE) $(SBC_32_PKG)/.DESCRIPTION
	@cp $(SBC_32_PKG_INSTALL_SCRIPT) $(SBC_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SBC_32_PKG)/.REQUIRES
	@echo "pkgname=$(SBC_32_PKG_NAME)"                            >  $(SBC_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SBC_32_PKG_VERSION)"                          >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SBC_32_PKG_ARCH)"                               >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SBC_32_PKG_DISTRO_NAME)"                  >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SBC_32_PKG_DISTRO_VERSION)"                >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "group=$(SBC_32_PKG_GROUP)"                             >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SBC_32_PKG_SHORT_DESCRIPTION)\"" >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "url=$(SBC_32_PKG_URL)"                                 >> $(SBC_32_PKG)/.PKGINFO ; \
	 echo "license=$(SBC_32_PKG_LICENSE)"                         >> $(SBC_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SBC_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
