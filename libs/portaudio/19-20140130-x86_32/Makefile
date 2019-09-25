
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/portaudio

REQUIRES           = libs/portaudio/19-20140130
REQUIRES          += libs/alsa-lib/1.1.1-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 19-20140130
tarball_version    = v19_20140130
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/portaudio/pa_stable_$(tarball_version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/portaudio
doc_dir_name       = portaudio-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs
#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PORTAUDIO_32_PKG_NAME                = portaudio-x32
PORTAUDIO_32_PKG_VERSION             = 19-20140130
PORTAUDIO_32_PKG_ARCH                = $(TOOLCHAIN)
PORTAUDIO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PORTAUDIO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PORTAUDIO_32_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
PORTAUDIO_32_PKG_SHORT_DESCRIPTION   = portable cross-platform audio API
PORTAUDIO_32_PKG_URL                 = $(BUG_URL)
PORTAUDIO_32_PKG_LICENSE             = BSD-style
PORTAUDIO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PORTAUDIO_32_PKG_NAME)-pkg-description
PORTAUDIO_32_PKG_DESCRIPTION_FILE_IN = $(PORTAUDIO_32_PKG_NAME)-pkg-description.in
PORTAUDIO_32_PKG_INSTALL_SCRIPT      = $(PORTAUDIO_32_PKG_NAME)-pkg-install.sh

PORTAUDIO_32_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PORTAUDIO_32_PKG_NAME)-package

pkg_basename     = $(PORTAUDIO_32_PKG_NAME)-$(PORTAUDIO_32_PKG_VERSION)-$(PORTAUDIO_32_PKG_ARCH)-$(PORTAUDIO_32_PKG_DISTRO_NAME)-$(PORTAUDIO_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(PORTAUDIO_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-alsa
extra_configure_switches += --without-jack
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PORTAUDIO_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(PORTAUDIO_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PORTAUDIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libportaudio.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PORTAUDIO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libportaudio.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libportaudio.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" portaudio-2.0.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PORTAUDIO_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PORTAUDIO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PORTAUDIO_32_PKG_DESCRIPTION_FILE): $(PORTAUDIO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PORTAUDIO_32_PKG_DESCRIPTION_FILE) $(PORTAUDIO_32_PKG_INSTALL_SCRIPT)
	@cp $(PORTAUDIO_32_PKG_DESCRIPTION_FILE) $(PORTAUDIO_32_PKG)/.DESCRIPTION
	@cp $(PORTAUDIO_32_PKG_INSTALL_SCRIPT) $(PORTAUDIO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PORTAUDIO_32_PKG)/.REQUIRES
	@echo "pkgname=$(PORTAUDIO_32_PKG_NAME)"                            >  $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PORTAUDIO_32_PKG_VERSION)"                          >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PORTAUDIO_32_PKG_ARCH)"                               >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PORTAUDIO_32_PKG_DISTRO_NAME)"                  >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PORTAUDIO_32_PKG_DISTRO_VERSION)"                >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "group=$(PORTAUDIO_32_PKG_GROUP)"                             >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PORTAUDIO_32_PKG_SHORT_DESCRIPTION)\"" >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "url=$(PORTAUDIO_32_PKG_URL)"                                 >> $(PORTAUDIO_32_PKG)/.PKGINFO ; \
	 echo "license=$(PORTAUDIO_32_PKG_LICENSE)"                         >> $(PORTAUDIO_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PORTAUDIO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
