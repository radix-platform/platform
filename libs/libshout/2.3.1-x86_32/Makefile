
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/libshout

REQUIRES           = libs/libshout/2.3.1
REQUIRES          += libs/libtheora/1.1.1-x86_32
REQUIRES          += libs/libvorbis/1.3.4-x86_32
REQUIRES          += libs/speex/1.2rc2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.3.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/libshout/libshout-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libshout-$(version)
src_dir_name       = libshout-$(version)
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
LIBSHOUT_32_PKG_NAME                = libshout-x32
LIBSHOUT_32_PKG_VERSION             = 2.3.1
LIBSHOUT_32_PKG_ARCH                = $(TOOLCHAIN)
LIBSHOUT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSHOUT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSHOUT_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
LIBSHOUT_32_PKG_SHORT_DESCRIPTION   = Library for accessing an icecast server
LIBSHOUT_32_PKG_URL                 = $(BUG_URL)
LIBSHOUT_32_PKG_LICENSE             = LGPLv2
LIBSHOUT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSHOUT_32_PKG_NAME)-pkg-description
LIBSHOUT_32_PKG_DESCRIPTION_FILE_IN = $(LIBSHOUT_32_PKG_NAME)-pkg-description.in
LIBSHOUT_32_PKG_INSTALL_SCRIPT      = $(LIBSHOUT_32_PKG_NAME)-pkg-install.sh

LIBSHOUT_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSHOUT_32_PKG_NAME)-package

pkg_basename      = $(LIBSHOUT_32_PKG_NAME)-$(LIBSHOUT_32_PKG_VERSION)-$(LIBSHOUT_32_PKG_ARCH)-$(LIBSHOUT_32_PKG_DISTRO_NAME)-$(LIBSHOUT_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSHOUT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --with-ogg=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-vorbis=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-theora=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-speex=$(TARGET_DEST_DIR)/usr

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
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	# ======= Remove -I/usr/include from SHOUT_CPPFLAGS =======
	@( cd $(build_dir) ; \
	   for file in `find . -name "Makefile"` ; do \
	     sed -i "s,-I/usr/include ,,g" $$file ; \
	   done ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBSHOUT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBSHOUT_32_PKG)/usr/include
	@rm -rf $(LIBSHOUT_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSHOUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libshout.la ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(LIBSHOUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,-I$(TARGET_DEST_DIR)/usr/include,,g" shout.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSHOUT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libshout.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libshout.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" shout.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSHOUT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSHOUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSHOUT_32_PKG_DESCRIPTION_FILE): $(LIBSHOUT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSHOUT_32_PKG_DESCRIPTION_FILE) $(LIBSHOUT_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBSHOUT_32_PKG_DESCRIPTION_FILE) $(LIBSHOUT_32_PKG)/.DESCRIPTION
	@cp $(LIBSHOUT_32_PKG_INSTALL_SCRIPT) $(LIBSHOUT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSHOUT_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSHOUT_32_PKG_NAME)"                            >  $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSHOUT_32_PKG_VERSION)"                          >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSHOUT_32_PKG_ARCH)"                               >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSHOUT_32_PKG_DISTRO_NAME)"                  >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSHOUT_32_PKG_DISTRO_VERSION)"                >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSHOUT_32_PKG_GROUP)"                             >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSHOUT_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSHOUT_32_PKG_URL)"                                 >> $(LIBSHOUT_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSHOUT_32_PKG_LICENSE)"                         >> $(LIBSHOUT_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSHOUT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
