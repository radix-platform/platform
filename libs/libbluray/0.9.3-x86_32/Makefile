
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/VideoLAN/libbluray

REQUIRES           = libs/libbluray/0.9.3
REQUIRES          += X11/libs/fontconfig/2.12.4-x86_32
REQUIRES          += libs/freetype/2.6.3-x86_32
REQUIRES          += libs/libxml2/2.9.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/VideoLAN/libbluray/libbluray-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libbluray-$(version)
src_dir_name       = libbluray-$(version)
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
LIBBLURAY_32_PKG_NAME                = libbluray-x32
LIBBLURAY_32_PKG_VERSION             = 0.9.3
LIBBLURAY_32_PKG_ARCH                = $(TOOLCHAIN)
LIBBLURAY_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBBLURAY_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBBLURAY_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBBLURAY_32_PKG_SHORT_DESCRIPTION   = Library to access Blu-Ray disks
LIBBLURAY_32_PKG_URL                 = $(BUG_URL)
LIBBLURAY_32_PKG_LICENSE             = LGPLv2.1
LIBBLURAY_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBBLURAY_32_PKG_NAME)-pkg-description
LIBBLURAY_32_PKG_DESCRIPTION_FILE_IN = $(LIBBLURAY_32_PKG_NAME)-pkg-description.in
LIBBLURAY_32_PKG_INSTALL_SCRIPT      = $(LIBBLURAY_32_PKG_NAME)-pkg-install.sh

LIBBLURAY_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBBLURAY_32_PKG_NAME)-package

pkg_basename      = $(LIBBLURAY_32_PKG_NAME)-$(LIBBLURAY_32_PKG_VERSION)-$(LIBBLURAY_32_PKG_ARCH)-$(LIBBLURAY_32_PKG_DISTRO_NAME)-$(LIBBLURAY_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(LIBBLURAY_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --disable-bdjava
extra_configure_switches += --disable-bdjava-jar

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-sign-compare


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


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
	@mkdir -p $(LIBBLURAY_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(LIBBLURAY_32_PKG)/usr/include
	@rm -rf $(LIBBLURAY_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBBLURAY_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libbluray.la \
	 )
	# ======= remove toolchain path from target *.pc files =======
	@( cd $(LIBBLURAY_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libbluray.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBBLURAY_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libbluray.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libbluray.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libbluray.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBBLURAY_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBBLURAY_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBBLURAY_32_PKG_DESCRIPTION_FILE): $(LIBBLURAY_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBBLURAY_32_PKG_DESCRIPTION_FILE) $(LIBBLURAY_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBBLURAY_32_PKG_DESCRIPTION_FILE) $(LIBBLURAY_32_PKG)/.DESCRIPTION
	@cp $(LIBBLURAY_32_PKG_INSTALL_SCRIPT) $(LIBBLURAY_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBBLURAY_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBBLURAY_32_PKG_NAME)"                            >  $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBBLURAY_32_PKG_VERSION)"                          >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBBLURAY_32_PKG_ARCH)"                               >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBBLURAY_32_PKG_DISTRO_NAME)"                  >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBBLURAY_32_PKG_DISTRO_VERSION)"                >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBBLURAY_32_PKG_GROUP)"                             >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBBLURAY_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBBLURAY_32_PKG_URL)"                                 >> $(LIBBLURAY_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBBLURAY_32_PKG_LICENSE)"                         >> $(LIBBLURAY_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBBLURAY_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
