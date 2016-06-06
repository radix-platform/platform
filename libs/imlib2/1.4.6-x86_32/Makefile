
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/imlib2

REQUIRES           = libs/imlib2/1.4.6
REQUIRES          += libs/libtiff/4.0.6-x86_32
REQUIRES          += libs/giflib/5.1.3-x86_32
REQUIRES          += libs/libjpeg-turbo/1.4.2-x86_32
REQUIRES          += libs/libid3tag/0.15.1b-x86_32
REQUIRES          += X11/libs/harfbuzz/0.9.36-x86_32
REQUIRES          += X11/X.org/lib/libXt/1.1.5-x86_32
REQUIRES          += X11/X.org/lib/libXext/1.3.3-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.4.6
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/imlib2/imlib2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/imlib2-$(version)
src_dir_name       = imlib2-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
IMLIB2_32_PKG_NAME                = imlib2-x32
IMLIB2_32_PKG_VERSION             = 1.4.6
IMLIB2_32_PKG_ARCH                = $(TOOLCHAIN)
IMLIB2_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IMLIB2_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IMLIB2_32_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
IMLIB2_32_PKG_SHORT_DESCRIPTION   = image manipulation library
IMLIB2_32_PKG_URL                 = $(BUG_URL)
IMLIB2_32_PKG_LICENSE             = BSD
IMLIB2_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IMLIB2_32_PKG_NAME)-pkg-description
IMLIB2_32_PKG_DESCRIPTION_FILE_IN = $(IMLIB2_32_PKG_NAME)-pkg-description.in
IMLIB2_32_PKG_INSTALL_SCRIPT      = $(IMLIB2_32_PKG_NAME)-pkg-install.sh

IMLIB2_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IMLIB2_32_PKG_NAME)-package

pkg_basename      = $(IMLIB2_32_PKG_NAME)-$(IMLIB2_32_PKG_VERSION)-$(IMLIB2_32_PKG_ARCH)-$(IMLIB2_32_PKG_DISTRO_NAME)-$(IMLIB2_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IMLIB2_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc/imlib2

extra_configure_switches += --enable-mmx

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i "s, @my_libs@,,"                            imlib2-config.in ; \
	   sed -i "s,@prefix@/include,$$\{prefix\}/include,g" imlib2-config.in ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(IMLIB2_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(IMLIB2_32_PKG)/usr/include
	@rm -rf $(IMLIB2_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IMLIB2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libImlib2.la \
	 )
	@( cd $(IMLIB2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/imlib2/filters ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" bumpmap.la colormod.la testfilter.la \
	 )
	@( cd $(IMLIB2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/imlib2/loaders ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" argb.la bmp.la bz2.la  \
	                                    gif.la id3.la jpeg.la  \
	                                    lbm.la png.la pnm.la   \
	                                    tga.la tiff.la xpm.la  \
	                                    zlib.la              ; \
	 )
	# ======= remove toolchain path from target imlib *.pc files =======
	@( cd $(IMLIB2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" imlib2.pc \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IMLIB2_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libImlib2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libImlib2.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/imlib2/filters ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" bumpmap.la colormod.la testfilter.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" bumpmap.la colormod.la testfilter.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/imlib2/loaders ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" argb.la bmp.la bz2.la  \
	                                            gif.la id3.la jpeg.la  \
	                                            lbm.la png.la pnm.la   \
	                                            tga.la tiff.la xpm.la  \
	                                            zlib.la              ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" argb.la bmp.la bz2.la  \
	                                              gif.la id3.la jpeg.la  \
	                                              lbm.la png.la pnm.la   \
	                                              tga.la tiff.la xpm.la  \
	                                              zlib.la              ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   imlib2.pc ; \
	 )
	# ======= tune imlib2-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" imlib-config ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g"           imlib-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IMLIB2_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(IMLIB2_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(IMLIB2_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IMLIB2_32_PKG_DESCRIPTION_FILE): $(IMLIB2_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IMLIB2_32_PKG_DESCRIPTION_FILE) $(IMLIB2_32_PKG_INSTALL_SCRIPT)
	@cp $(IMLIB2_32_PKG_DESCRIPTION_FILE) $(IMLIB2_32_PKG)/.DESCRIPTION
	@cp $(IMLIB2_32_PKG_INSTALL_SCRIPT) $(IMLIB2_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IMLIB2_32_PKG)/.REQUIRES
	@echo "pkgname=$(IMLIB2_32_PKG_NAME)"                            >  $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IMLIB2_32_PKG_VERSION)"                          >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "arch=$(IMLIB2_32_PKG_ARCH)"                               >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(IMLIB2_32_PKG_DISTRO_NAME)"                  >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(IMLIB2_32_PKG_DISTRO_VERSION)"                >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "group=$(IMLIB2_32_PKG_GROUP)"                             >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IMLIB2_32_PKG_SHORT_DESCRIPTION)\"" >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "url=$(IMLIB2_32_PKG_URL)"                                 >> $(IMLIB2_32_PKG)/.PKGINFO ; \
	 echo "license=$(IMLIB2_32_PKG_LICENSE)"                         >> $(IMLIB2_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(IMLIB2_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
