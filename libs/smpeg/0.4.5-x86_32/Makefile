
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/smpeg

REQUIRES           = libs/smpeg/0.4.5
REQUIRES          += X11/libs/sdl/sdl/1.2.15-x86_32
REQUIRES          += X11/libs/glu/9.0.0-x86_32
REQUIRES          += X11/libs/gtk+2/2.24.25-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 0.4.5
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/smpeg/smpeg-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/smpeg-$(version)
src_dir_name       = smpeg-$(version)
doc_dir_name       = smpeg-$(version)
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
SMPEG_32_PKG_NAME                = smpeg-x32
SMPEG_32_PKG_VERSION             = 0.4.5
SMPEG_32_PKG_ARCH                = $(TOOLCHAIN)
SMPEG_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SMPEG_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SMPEG_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
SMPEG_32_PKG_SHORT_DESCRIPTION   = SDL MPEG Player Library
SMPEG_32_PKG_URL                 = $(BUG_URL)
SMPEG_32_PKG_LICENSE             = LGPLv2.1
SMPEG_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SMPEG_32_PKG_NAME)-pkg-description
SMPEG_32_PKG_DESCRIPTION_FILE_IN = $(SMPEG_32_PKG_NAME)-pkg-description.in
SMPEG_32_PKG_INSTALL_SCRIPT      = $(SMPEG_32_PKG_NAME)-pkg-install.sh

SMPEG_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SMPEG_32_PKG_NAME)-package

pkg_basename     = $(SMPEG_32_PKG_NAME)-$(SMPEG_32_PKG_VERSION)-$(SMPEG_32_PKG_ARCH)-$(SMPEG_32_PKG_DISTRO_NAME)-$(SMPEG_32_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(SMPEG_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-pic

extra_configure_switches += --disable-sdltest
extra_configure_switches += --enable-gtk-player
extra_configure_switches += --disable-gtktest
extra_configure_switches += --enable-opengl-player

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


extra_environment  = SDL_CONFIG=$(TARGET_DEST_DIR)/usr/bin/32/sdl-config


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(extra_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SMPEG_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(SMPEG_32_PKG)/usr/include
	@rm -rf $(SMPEG_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SMPEG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsmpeg.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SMPEG_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsmpeg.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsmpeg.la ; \
	 )
	# ======= tune libmicmod-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" smpeg-config ; \
	   sed -i "s,L/usr,L$(TARGET_DEST_DIR)/usr,g" smpeg-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SMPEG_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(SMPEG_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SMPEG_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SMPEG_32_PKG_DESCRIPTION_FILE): $(SMPEG_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SMPEG_32_PKG_DESCRIPTION_FILE) $(SMPEG_32_PKG_INSTALL_SCRIPT)
	@cp $(SMPEG_32_PKG_DESCRIPTION_FILE) $(SMPEG_32_PKG)/.DESCRIPTION
	@cp $(SMPEG_32_PKG_INSTALL_SCRIPT) $(SMPEG_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SMPEG_32_PKG)/.REQUIRES
	@echo "pkgname=$(SMPEG_32_PKG_NAME)"                            >  $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SMPEG_32_PKG_VERSION)"                          >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SMPEG_32_PKG_ARCH)"                               >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SMPEG_32_PKG_DISTRO_NAME)"                  >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SMPEG_32_PKG_DISTRO_VERSION)"                >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "group=$(SMPEG_32_PKG_GROUP)"                             >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SMPEG_32_PKG_SHORT_DESCRIPTION)\"" >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "url=$(SMPEG_32_PKG_URL)"                                 >> $(SMPEG_32_PKG)/.PKGINFO ; \
	 echo "license=$(SMPEG_32_PKG_LICENSE)"                         >> $(SMPEG_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SMPEG_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
