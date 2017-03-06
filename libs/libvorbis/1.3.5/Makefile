
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/libvorbis

REQUIRES           = libs/libogg/1.3.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.5
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/libvorbis/libvorbis-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libvorbis-$(version)
src_dir_name       = libvorbis-$(version)
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
LIBVORBIS_PKG_NAME                = libvorbis
LIBVORBIS_PKG_VERSION             = 1.3.5
LIBVORBIS_PKG_ARCH                = $(TOOLCHAIN)
LIBVORBIS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVORBIS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVORBIS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBVORBIS_PKG_SHORT_DESCRIPTION   = Ogg Vorbis library
LIBVORBIS_PKG_URL                 = $(BUG_URL)
LIBVORBIS_PKG_LICENSE             = Xiph.org
LIBVORBIS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVORBIS_PKG_NAME)-pkg-description
LIBVORBIS_PKG_DESCRIPTION_FILE_IN = $(LIBVORBIS_PKG_NAME)-pkg-description.in
LIBVORBIS_PKG_INSTALL_SCRIPT      = $(LIBVORBIS_PKG_NAME)-pkg-install.sh

LIBVORBIS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVORBIS_PKG_NAME)-package

pkg_basename     = $(LIBVORBIS_PKG_NAME)-$(LIBVORBIS_PKG_VERSION)-$(LIBVORBIS_PKG_ARCH)-$(LIBVORBIS_PKG_DISTRO_NAME)-$(LIBVORBIS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBVORBIS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	@mkdir -p $(LIBVORBIS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBVORBIS_PKG)/usr/share/man ]; then \
	  ( cd $(LIBVORBIS_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBVORBIS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBVORBIS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBVORBIS_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(LIBVORBIS_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv libvorbis vorbisenc vorbisfile *.txt *.xml *.html *.png html ; \
	   rm -f doxygen-build.stamp ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README \
	         $(LIBVORBIS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(LIBVORBIS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBVORBIS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvorbis.la     \
	                                    libvorbisenc.la  \
	                                    libvorbisfile.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVORBIS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvorbis.la       \
	                                            libvorbisenc.la    \
	                                            libvorbisfile.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvorbis.la     \
	                                              libvorbisenc.la  \
	                                              libvorbisfile.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vorbis.pc vorbisenc.pc vorbisfile.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVORBIS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBVORBIS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBVORBIS_PKG_DESCRIPTION_FILE): $(LIBVORBIS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVORBIS_PKG_DESCRIPTION_FILE) $(LIBVORBIS_PKG_INSTALL_SCRIPT)
	@cp $(LIBVORBIS_PKG_DESCRIPTION_FILE) $(LIBVORBIS_PKG)/.DESCRIPTION
	@cp $(LIBVORBIS_PKG_INSTALL_SCRIPT) $(LIBVORBIS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVORBIS_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVORBIS_PKG_NAME)"                            >  $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVORBIS_PKG_VERSION)"                          >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVORBIS_PKG_ARCH)"                               >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVORBIS_PKG_DISTRO_NAME)"                  >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVORBIS_PKG_DISTRO_VERSION)"                >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVORBIS_PKG_GROUP)"                             >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVORBIS_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVORBIS_PKG_URL)"                                 >> $(LIBVORBIS_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVORBIS_PKG_LICENSE)"                         >> $(LIBVORBIS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBVORBIS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
