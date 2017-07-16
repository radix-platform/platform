
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/sdl/sdl-net

REQUIRES           = X11/libs/sdl/sdl-net/1.2.8
REQUIRES          += X11/libs/sdl/sdl/1.2.15-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.8
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/sdl/sdl-net/SDL_net-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/SDL_net-$(version)
src_dir_name       = SDL_net-$(version)
doc_dir_name       = sdl-net-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SDL_NET_32_PKG_NAME                = sdl-net-x32
SDL_NET_32_PKG_VERSION             = 1.2.8
SDL_NET_32_PKG_ARCH                = $(TOOLCHAIN)
SDL_NET_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SDL_NET_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SDL_NET_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
SDL_NET_32_PKG_SHORT_DESCRIPTION   = SDL portable network library
SDL_NET_32_PKG_URL                 = $(BUG_URL)
SDL_NET_32_PKG_LICENSE             = custom
SDL_NET_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SDL_NET_32_PKG_NAME)-pkg-description
SDL_NET_32_PKG_DESCRIPTION_FILE_IN = $(SDL_NET_32_PKG_NAME)-pkg-description.in
SDL_NET_32_PKG_INSTALL_SCRIPT      = $(SDL_NET_32_PKG_NAME)-pkg-install.sh

SDL_NET_32_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SDL_NET_32_PKG_NAME)-package

pkg_basename     = $(SDL_NET_32_PKG_NAME)-$(SDL_NET_32_PKG_VERSION)-$(SDL_NET_32_PKG_ARCH)-$(SDL_NET_32_PKG_DISTRO_NAME)-$(SDL_NET_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(SDL_NET_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-pic

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SDL_NET_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(SDL_NET_32_PKG)/usr/include
	@rm -rf $(SDL_NET_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SDL_NET_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libSDL_net.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SDL_NET_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libSDL_net.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libSDL_net.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" SDL_net.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SDL_NET_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SDL_NET_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SDL_NET_32_PKG_DESCRIPTION_FILE): $(SDL_NET_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SDL_NET_32_PKG_DESCRIPTION_FILE) $(SDL_NET_32_PKG_INSTALL_SCRIPT)
	@cp $(SDL_NET_32_PKG_DESCRIPTION_FILE) $(SDL_NET_32_PKG)/.DESCRIPTION
	@cp $(SDL_NET_32_PKG_INSTALL_SCRIPT) $(SDL_NET_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SDL_NET_32_PKG)/.REQUIRES
	@echo "pkgname=$(SDL_NET_32_PKG_NAME)"                            >  $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SDL_NET_32_PKG_VERSION)"                          >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "arch=$(SDL_NET_32_PKG_ARCH)"                               >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(SDL_NET_32_PKG_DISTRO_NAME)"                  >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(SDL_NET_32_PKG_DISTRO_VERSION)"                >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "group=$(SDL_NET_32_PKG_GROUP)"                             >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SDL_NET_32_PKG_SHORT_DESCRIPTION)\"" >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "url=$(SDL_NET_32_PKG_URL)"                                 >> $(SDL_NET_32_PKG)/.PKGINFO ; \
	 echo "license=$(SDL_NET_32_PKG_LICENSE)"                         >> $(SDL_NET_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SDL_NET_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
