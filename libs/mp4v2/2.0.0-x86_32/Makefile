
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/mp4v2

REQUIRES           = libs/mp4v2/2.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/mp4v2/mp4v2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mp4v2-$(version)
src_dir_name       = mp4v2-$(version)
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
MP4V2_32_PKG_NAME                = mp4v2-x32
MP4V2_32_PKG_VERSION             = 2.0.0
MP4V2_32_PKG_ARCH                = $(TOOLCHAIN)
MP4V2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MP4V2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MP4V2_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
MP4V2_32_PKG_SHORT_DESCRIPTION   = The MPEG-4 library
MP4V2_32_PKG_URL                 = $(BUG_URL)
MP4V2_32_PKG_LICENSE             = MPL
MP4V2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MP4V2_32_PKG_NAME)-pkg-description
MP4V2_32_PKG_DESCRIPTION_FILE_IN = $(MP4V2_32_PKG_NAME)-pkg-description.in
MP4V2_32_PKG_INSTALL_SCRIPT      = $(MP4V2_32_PKG_NAME)-pkg-install.sh

MP4V2_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MP4V2_32_PKG_NAME)-package

pkg_basename      = $(MP4V2_32_PKG_NAME)-$(MP4V2_32_PKG_VERSION)-$(MP4V2_32_PKG_ARCH)-$(MP4V2_32_PKG_DISTRO_NAME)-$(MP4V2_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(MP4V2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --disable-gch
extra_configure_switches += --with-pic

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_BIN_RPATH)


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
	@mkdir -p $(MP4V2_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(MP4V2_32_PKG)/usr/include
	@rm -rf $(MP4V2_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MP4V2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmp4v2.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MP4V2_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmp4v2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmp4v2.la \
	 )
	# ======= Strip binaries =======
	@( cd $(MP4V2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(MP4V2_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MP4V2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MP4V2_32_PKG_DESCRIPTION_FILE): $(MP4V2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MP4V2_32_PKG_DESCRIPTION_FILE) $(MP4V2_32_PKG_INSTALL_SCRIPT)
	@cp $(MP4V2_32_PKG_DESCRIPTION_FILE) $(MP4V2_32_PKG)/.DESCRIPTION
	@cp $(MP4V2_32_PKG_INSTALL_SCRIPT) $(MP4V2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MP4V2_32_PKG)/.REQUIRES
	@echo "pkgname=$(MP4V2_32_PKG_NAME)"                            >  $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MP4V2_32_PKG_VERSION)"                          >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(MP4V2_32_PKG_ARCH)"                               >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(MP4V2_32_PKG_DISTRO_NAME)"                  >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(MP4V2_32_PKG_DISTRO_VERSION)"                >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "group=$(MP4V2_32_PKG_GROUP)"                             >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MP4V2_32_PKG_SHORT_DESCRIPTION)\"" >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "url=$(MP4V2_32_PKG_URL)"                                 >> $(MP4V2_32_PKG)/.PKGINFO ; \
	 echo "license=$(MP4V2_32_PKG_LICENSE)"                         >> $(MP4V2_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(MP4V2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
