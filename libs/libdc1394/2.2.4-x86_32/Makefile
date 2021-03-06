
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libdc1394

REQUIRES           = libs/libdc1394/2.2.4
REQUIRES          += libs/libraw1394/2.1.2-x86_32
REQUIRES          += libs/libusb/1.0.20-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.2.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/libdc1394/libdc1394-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdc1394-$(version)
src_dir_name       = libdc1394-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DC1394_32_PKG_NAME                = libdc1394-x32
DC1394_32_PKG_VERSION             = 2.2.4
DC1394_32_PKG_ARCH                = $(TOOLCHAIN)
DC1394_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DC1394_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DC1394_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
DC1394_32_PKG_SHORT_DESCRIPTION   = IIDC Camera Control Library
DC1394_32_PKG_URL                 = $(BUG_URL)
DC1394_32_PKG_LICENSE             = LGPLv2.1
DC1394_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DC1394_32_PKG_NAME)-pkg-description
DC1394_32_PKG_DESCRIPTION_FILE_IN = $(DC1394_32_PKG_NAME)-pkg-description.in
DC1394_32_PKG_INSTALL_SCRIPT      = $(DC1394_32_PKG_NAME)-pkg-install.sh

DC1394_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DC1394_32_PKG_NAME)-package

pkg_basename      = $(DC1394_32_PKG_NAME)-$(DC1394_32_PKG_VERSION)-$(DC1394_32_PKG_ARCH)-$(DC1394_32_PKG_DISTRO_NAME)-$(DC1394_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(DC1394_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --htmldir=/usr/share/doc/$(src_dir_name)/html
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --disable-doxygen-doc

extra_configure_switches += --disable-sdltest
extra_configure_switches += --disable-examples

extra_configure_switches += --with-pic

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-enum-compare -Wno-format -Wno-deprecated-declarations


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DC1394_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(DC1394_32_PKG)/usr/include
	@rm -rf $(DC1394_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(DC1394_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdc1394.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DC1394_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdc1394.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdc1394.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" libdc1394-?.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DC1394_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(DC1394_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(DC1394_32_PKG_DESCRIPTION_FILE): $(DC1394_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DC1394_32_PKG_DESCRIPTION_FILE) $(DC1394_32_PKG_INSTALL_SCRIPT)
	@cp $(DC1394_32_PKG_DESCRIPTION_FILE) $(DC1394_32_PKG)/.DESCRIPTION
	@cp $(DC1394_32_PKG_INSTALL_SCRIPT) $(DC1394_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DC1394_32_PKG)/.REQUIRES
	@echo "pkgname=$(DC1394_32_PKG_NAME)"                            >  $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DC1394_32_PKG_VERSION)"                          >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "arch=$(DC1394_32_PKG_ARCH)"                               >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(DC1394_32_PKG_DISTRO_NAME)"                  >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(DC1394_32_PKG_DISTRO_VERSION)"                >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "group=$(DC1394_32_PKG_GROUP)"                             >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DC1394_32_PKG_SHORT_DESCRIPTION)\"" >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "url=$(DC1394_32_PKG_URL)"                                 >> $(DC1394_32_PKG)/.PKGINFO ; \
	 echo "license=$(DC1394_32_PKG_LICENSE)"                         >> $(DC1394_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(DC1394_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
