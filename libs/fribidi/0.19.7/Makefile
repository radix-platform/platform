
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/fribidi

REQUIRES           = libs/glib2/2.48.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.19.7
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/fribidi/fribidi-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fribidi-$(version)
src_dir_name       = fribidi-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
FRIBIDI_PKG_NAME                = fribidi
FRIBIDI_PKG_VERSION             = 0.19.7
FRIBIDI_PKG_ARCH                = $(TOOLCHAIN)
FRIBIDI_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FRIBIDI_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FRIBIDI_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FRIBIDI_PKG_SHORT_DESCRIPTION   = Unicode BiDirectional algorithm library
FRIBIDI_PKG_URL                 = $(BUG_URL)
FRIBIDI_PKG_LICENSE             = LGPLv2.1
FRIBIDI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FRIBIDI_PKG_NAME)-pkg-description
FRIBIDI_PKG_DESCRIPTION_FILE_IN = $(FRIBIDI_PKG_NAME)-pkg-description.in
FRIBIDI_PKG_INSTALL_SCRIPT      = $(FRIBIDI_PKG_NAME)-pkg-install.sh

FRIBIDI_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FRIBIDI_PKG_NAME)-package

pkg_basename     = $(FRIBIDI_PKG_NAME)-$(FRIBIDI_PKG_VERSION)-$(FRIBIDI_PKG_ARCH)-$(FRIBIDI_PKG_DISTRO_NAME)-$(FRIBIDI_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FRIBIDI_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-pic

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-deprecated-declarations -Wno-unused-but-set-variable -Wno-switch


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Building Generators for build mahine =======
	@( cd $(SRC_DIR) ; \
	   ./configure CC=gcc CXX=g++ CFLAGS=-I/usr/include CXXFLAGS=-I/usr/include \
	               PKG_CONFIG_PATH=/usr/lib$(BUILD_MULTILIB_SUFFIX)/pkgconfig ; \
	   make ; \
	   cp gen.tab/gen-arabic-shaping-tab gen.tab/gen-arabic-shaping-tab-for-build ; \
	   cp      gen.tab/gen-bidi-type-tab gen.tab/gen-bidi-type-tab-for-build      ; \
	   cp   gen.tab/gen-joining-type-tab gen.tab/gen-joining-type-tab-for-build   ; \
	   cp      gen.tab/gen-mirroring-tab gen.tab/gen-mirroring-tab-for-build      ; \
	   cp    gen.tab/gen-unicode-version gen.tab/gen-unicode-version-for-build    ; \
	   make distclean ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= Copy Generators for build mahine =======
	@( cd $(SRC_DIR) ; \
	   cp gen.tab/gen-arabic-shaping-tab-for-build gen.tab/gen-arabic-shaping-tab ; \
	   cp      gen.tab/gen-bidi-type-tab-for-build gen.tab/gen-bidi-type-tab      ; \
	   cp   gen.tab/gen-joining-type-tab-for-build gen.tab/gen-joining-type-tab   ; \
	   cp      gen.tab/gen-mirroring-tab-for-build gen.tab/gen-mirroring-tab      ; \
	   cp    gen.tab/gen-unicode-version-for-build gen.tab/gen-unicode-version    ; \
	 )
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FRIBIDI_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= delete wrong man pages =======
	@( cd $(FRIBIDI_PKG)/usr/share/man/man3 ; \
	   rm -f fribidi_set_debug.3 fribidi_unicode_version.3 fribidi_version_info.3 ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(FRIBIDI_PKG)/usr/share/man ]; then \
	  ( cd $(FRIBIDI_PKG)/usr/share/man ; \
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
	@mkdir -p $(FRIBIDI_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(FRIBIDI_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FRIBIDI_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README THANKS TODO \
	         $(FRIBIDI_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FRIBIDI_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FRIBIDI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfribidi.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FRIBIDI_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfribidi.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfribidi.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" fribidi.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FRIBIDI_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FRIBIDI_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FRIBIDI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FRIBIDI_PKG_DESCRIPTION_FILE): $(FRIBIDI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FRIBIDI_PKG_DESCRIPTION_FILE) $(FRIBIDI_PKG_INSTALL_SCRIPT)
	@cp $(FRIBIDI_PKG_DESCRIPTION_FILE) $(FRIBIDI_PKG)/.DESCRIPTION
	@cp $(FRIBIDI_PKG_INSTALL_SCRIPT) $(FRIBIDI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FRIBIDI_PKG)/.REQUIRES
	@echo "pkgname=$(FRIBIDI_PKG_NAME)"                            >  $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FRIBIDI_PKG_VERSION)"                          >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "arch=$(FRIBIDI_PKG_ARCH)"                               >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "distroname=$(FRIBIDI_PKG_DISTRO_NAME)"                  >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "distrover=$(FRIBIDI_PKG_DISTRO_VERSION)"                >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "group=$(FRIBIDI_PKG_GROUP)"                             >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FRIBIDI_PKG_SHORT_DESCRIPTION)\"" >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "url=$(FRIBIDI_PKG_URL)"                                 >> $(FRIBIDI_PKG)/.PKGINFO ; \
	 echo "license=$(FRIBIDI_PKG_LICENSE)"                         >> $(FRIBIDI_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(FRIBIDI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
