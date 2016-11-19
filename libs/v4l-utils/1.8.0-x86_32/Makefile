
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/linuxtv/v4l-utils

REQUIRES           = libs/v4l-utils/1.8.0
REQUIRES          += libs/eudev/3.1.5-x86_32
REQUIRES          += libs/libjpeg-turbo/1.4.2-x86_32
REQUIRES          += X11/libs/qt5/5.4.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.8.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/linuxtv/v4l-utils/v4l-utils-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/v4l-utils-$(version)
src_dir_name       = v4l-utils-$(version)
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
V4LUTILS_32_PKG_NAME                = v4l-utils-x32
V4LUTILS_32_PKG_VERSION             = 1.8.0
V4LUTILS_32_PKG_ARCH                = $(TOOLCHAIN)
V4LUTILS_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
V4LUTILS_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
V4LUTILS_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
V4LUTILS_32_PKG_SHORT_DESCRIPTION   = libraries and utilities for video4linux
V4LUTILS_32_PKG_URL                 = $(BUG_URL)
V4LUTILS_32_PKG_LICENSE             = GPLv2
V4LUTILS_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(V4LUTILS_32_PKG_NAME)-pkg-description
V4LUTILS_32_PKG_DESCRIPTION_FILE_IN = $(V4LUTILS_32_PKG_NAME)-pkg-description.in
V4LUTILS_32_PKG_INSTALL_SCRIPT      = $(V4LUTILS_32_PKG_NAME)-pkg-install.sh

V4LUTILS_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(V4LUTILS_32_PKG_NAME)-package

pkg_basename     = $(V4LUTILS_32_PKG_NAME)-$(V4LUTILS_32_PKG_VERSION)-$(V4LUTILS_32_PKG_ARCH)-$(V4LUTILS_32_PKG_DISTRO_NAME)-$(V4LUTILS_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(V4LUTILS_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-udevdir=/lib/udev

extra_configure_switches += --disable-qv4l2

extra_configure_switches += --program-prefix=''
extra_configure_switches += --program-suffix=''

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@mkdir -p $(V4LUTILS_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(V4LUTILS_32_PKG)/etc
	@rm -rf $(V4LUTILS_32_PKG)/lib
	@rm -rf $(V4LUTILS_32_PKG)/usr/bin
	@rm -rf $(V4LUTILS_32_PKG)/usr/include
	@rm -rf $(V4LUTILS_32_PKG)/usr/share
	@rm -rf $(V4LUTILS_32_PKG)/usr/sbin
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(V4LUTILS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdvbv5.la libv4l1.la libv4l2.la   \
	                                    libv4l2rds.la libv4lconvert.la    ; \
	 )
	@( cd $(V4LUTILS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libv4l ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" v4l1compat.la v4l2convert.la ; \
	 )
	@( cd $(V4LUTILS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libv4l/plugins ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libv4l-mplane.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(V4LUTILS_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdvbv5.la libv4l1.la libv4l2.la   \
	                                            libv4l2rds.la libv4lconvert.la    ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdvbv5.la libv4l1.la libv4l2.la   \
	                                              libv4l2rds.la libv4lconvert.la    ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libv4l ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" v4l1compat.la v4l2convert.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" v4l1compat.la v4l2convert.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/libv4l/plugins ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libv4l-mplane.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libv4l-mplane.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdvbv5.pc libv4l1.pc libv4l2.pc   \
	                                            libv4l2rds.pc libv4lconvert.pc    ; \
	 )
	# =======Strip binaries =======
	@( cd $(V4LUTILS_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(V4LUTILS_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(V4LUTILS_32_PKG_DESCRIPTION_FILE): $(V4LUTILS_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(V4LUTILS_32_PKG_DESCRIPTION_FILE) $(V4LUTILS_32_PKG_INSTALL_SCRIPT)
	@cp $(V4LUTILS_32_PKG_DESCRIPTION_FILE) $(V4LUTILS_32_PKG)/.DESCRIPTION
	@cp $(V4LUTILS_32_PKG_INSTALL_SCRIPT) $(V4LUTILS_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(V4LUTILS_32_PKG)/.REQUIRES
	@echo "pkgname=$(V4LUTILS_32_PKG_NAME)"                            >  $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(V4LUTILS_32_PKG_VERSION)"                          >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "arch=$(V4LUTILS_32_PKG_ARCH)"                               >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(V4LUTILS_32_PKG_DISTRO_NAME)"                  >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(V4LUTILS_32_PKG_DISTRO_VERSION)"                >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "group=$(V4LUTILS_32_PKG_GROUP)"                             >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(V4LUTILS_32_PKG_SHORT_DESCRIPTION)\"" >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "url=$(V4LUTILS_32_PKG_URL)"                                 >> $(V4LUTILS_32_PKG)/.PKGINFO ; \
	 echo "license=$(V4LUTILS_32_PKG_LICENSE)"                         >> $(V4LUTILS_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(V4LUTILS_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
