
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/sdl/sdl

REQUIRES           = libs/alsa-lib/1.1.1
REQUIRES          += libs/pulseaudio/9.0
REQUIRES          += app/esound/0.2.41
REQUIRES          += X11/X.org/lib/libXrandr/1.5.0
REQUIRES          += libs/aalib/1.4.0

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.15
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/sdl/sdl/SDL-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/SDL-$(version)
src_dir_name       = SDL-$(version)
doc_dir_name       = sdl-$(version)
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
SDL_PKG_NAME                = sdl
SDL_PKG_VERSION             = 1.2.15
SDL_PKG_ARCH                = $(TOOLCHAIN)
SDL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SDL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SDL_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
SDL_PKG_SHORT_DESCRIPTION   = Simple DirectMedia Layer library
SDL_PKG_URL                 = $(BUG_URL)
SDL_PKG_LICENSE             = LGPLv2.1
SDL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SDL_PKG_NAME)-pkg-description
SDL_PKG_DESCRIPTION_FILE_IN = $(SDL_PKG_NAME)-pkg-description.in
SDL_PKG_INSTALL_SCRIPT      = $(SDL_PKG_NAME)-pkg-install.sh

SDL_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SDL_PKG_NAME)-package

pkg_basename     = $(SDL_PKG_NAME)-$(SDL_PKG_VERSION)-$(SDL_PKG_ARCH)-$(SDL_PKG_DISTRO_NAME)-$(SDL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


env_sysroot = DESTDIR=$(SDL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --with-x
extra_configure_switches += --disable-arts
extra_configure_switches += --disable-nasm
extra_configure_switches += --enable-alsa
extra_configure_switches += --enable-esd
extra_configure_switches += --enable-video-aalib

extra_configure_switches += --disable-rpath
extra_configure_switches += --disable-x11-shared

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SDL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SDL_PKG)/usr/share/man ]; then \
	  ( cd $(SDL_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.?  ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(SDL_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/CREDITS \
	       $(SDL_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(SDL_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING CREDITS INSTALL README TODO \
	         docs/html docs/images docs/index.html \
	         $(SDL_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SDL_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= tune library path in the sdl-config script =======
	@( cd $(SDL_PKG)/usr/bin ; \
	   sed -i 's,-L/usr,-L$${prefix},g' sdl-config ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SDL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libSDL.la libSDLmain.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SDL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libSDL.la libSDLmain.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libSDL.la libSDLmain.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sdl.pc ; \
	 )
	# ======= tune prefix for development in the sdl-config script =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" sdl-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SDL_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SDL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SDL_PKG_DESCRIPTION_FILE): $(SDL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SDL_PKG_DESCRIPTION_FILE) $(SDL_PKG_INSTALL_SCRIPT)
	@cp $(SDL_PKG_DESCRIPTION_FILE) $(SDL_PKG)/.DESCRIPTION
	@cp $(SDL_PKG_INSTALL_SCRIPT) $(SDL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SDL_PKG)/.REQUIRES
	@echo "pkgname=$(SDL_PKG_NAME)"                            >  $(SDL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SDL_PKG_VERSION)"                          >> $(SDL_PKG)/.PKGINFO ; \
	 echo "arch=$(SDL_PKG_ARCH)"                               >> $(SDL_PKG)/.PKGINFO ; \
	 echo "distroname=$(SDL_PKG_DISTRO_NAME)"                  >> $(SDL_PKG)/.PKGINFO ; \
	 echo "distrover=$(SDL_PKG_DISTRO_VERSION)"                >> $(SDL_PKG)/.PKGINFO ; \
	 echo "group=$(SDL_PKG_GROUP)"                             >> $(SDL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SDL_PKG_SHORT_DESCRIPTION)\"" >> $(SDL_PKG)/.PKGINFO ; \
	 echo "url=$(SDL_PKG_URL)"                                 >> $(SDL_PKG)/.PKGINFO ; \
	 echo "license=$(SDL_PKG_LICENSE)"                         >> $(SDL_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SDL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
