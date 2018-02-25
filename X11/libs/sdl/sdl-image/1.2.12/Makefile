
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/sdl/sdl-image

REQUIRES           = X11/libs/sdl/sdl/1.2.15
REQUIRES          += libs/libpng/libpng14/1.4.19
REQUIRES          += libs/libtiff/4.0.6

# ======= __END_OF_REQUIRES__ =======


version            = 1.2.12
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/sdl/sdl-image/SDL_image-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/SDL_image-$(version)
src_dir_name       = SDL_image-$(version)
doc_dir_name       = sdl-image-$(version)
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
SDL_IMAGE_PKG_NAME                = sdl-image
SDL_IMAGE_PKG_VERSION             = 1.2.12
SDL_IMAGE_PKG_ARCH                = $(TOOLCHAIN)
SDL_IMAGE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SDL_IMAGE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SDL_IMAGE_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
SDL_IMAGE_PKG_SHORT_DESCRIPTION   = SDL loading images library
SDL_IMAGE_PKG_URL                 = $(BUG_URL)
SDL_IMAGE_PKG_LICENSE             = custom
SDL_IMAGE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SDL_IMAGE_PKG_NAME)-pkg-description
SDL_IMAGE_PKG_DESCRIPTION_FILE_IN = $(SDL_IMAGE_PKG_NAME)-pkg-description.in
SDL_IMAGE_PKG_INSTALL_SCRIPT      = $(SDL_IMAGE_PKG_NAME)-pkg-install.sh

SDL_IMAGE_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SDL_IMAGE_PKG_NAME)-package

pkg_basename     = $(SDL_IMAGE_PKG_NAME)-$(SDL_IMAGE_PKG_VERSION)-$(SDL_IMAGE_PKG_ARCH)-$(SDL_IMAGE_PKG_DISTRO_NAME)-$(SDL_IMAGE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


env_sysroot = DESTDIR=$(SDL_IMAGE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-jpg-shared=no
extra_configure_switches += --enable-png-shared=no
extra_configure_switches += --enable-tif-shared=no

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
	@mkdir -p $(SDL_IMAGE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SDL_IMAGE_PKG)/usr/share/man ]; then \
	  ( cd $(SDL_IMAGE_PKG)/usr/share/man ; \
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
	@mkdir -p $(SDL_IMAGE_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(SDL_IMAGE_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(SDL_IMAGE_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(SDL_IMAGE_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(SDL_IMAGE_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SDL_IMAGE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libSDL_image.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SDL_IMAGE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libSDL_image.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libSDL_image.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" SDL_image.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(SDL_IMAGE_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(SDL_IMAGE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(SDL_IMAGE_PKG_DESCRIPTION_FILE): $(SDL_IMAGE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SDL_IMAGE_PKG_DESCRIPTION_FILE) $(SDL_IMAGE_PKG_INSTALL_SCRIPT)
	@cp $(SDL_IMAGE_PKG_DESCRIPTION_FILE) $(SDL_IMAGE_PKG)/.DESCRIPTION
	@cp $(SDL_IMAGE_PKG_INSTALL_SCRIPT) $(SDL_IMAGE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SDL_IMAGE_PKG)/.REQUIRES
	@echo "pkgname=$(SDL_IMAGE_PKG_NAME)"                            >  $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SDL_IMAGE_PKG_VERSION)"                          >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "arch=$(SDL_IMAGE_PKG_ARCH)"                               >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "distroname=$(SDL_IMAGE_PKG_DISTRO_NAME)"                  >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "distrover=$(SDL_IMAGE_PKG_DISTRO_VERSION)"                >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "group=$(SDL_IMAGE_PKG_GROUP)"                             >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SDL_IMAGE_PKG_SHORT_DESCRIPTION)\"" >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "url=$(SDL_IMAGE_PKG_URL)"                                 >> $(SDL_IMAGE_PKG)/.PKGINFO ; \
	 echo "license=$(SDL_IMAGE_PKG_LICENSE)"                         >> $(SDL_IMAGE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(SDL_IMAGE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
