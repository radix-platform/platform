
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/harfbuzz

REQUIRES           = dev/gcc/4.9.1
REQUIRES          += libs/glib2/2.40.0
REQUIRES          += libs/libpng/libpng14/1.4.13
REQUIRES          += libs/icu4c/54.1
REQUIRES          += X11/libs/cairo/1.14.0
REQUIRES          += libs/libffi/3.0.13
REQUIRES          += libs/zlib/1.2.8
REQUIRES          += app/bzip2/1.0.6
# NOTE: We should not require final freetipe to avoid a cycle in the dependency tree:
REQUIRES          += env/freetype/2.5.3


version            = 0.9.36
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/harfbuzz/harfbuzz-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/harfbuzz-$(version)
src_dir_name       = harfbuzz-$(version)
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
HARFBUZZ_PKG_NAME                = harfbuzz
HARFBUZZ_PKG_VERSION             = 0.9.36
HARFBUZZ_PKG_ARCH                = $(TOOLCHAIN)
HARFBUZZ_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HARFBUZZ_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HARFBUZZ_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
HARFBUZZ_PKG_SHORT_DESCRIPTION   = OpenType text shaping engine
HARFBUZZ_PKG_URL                 = $(BUG_URL)
HARFBUZZ_PKG_LICENSE             = MIT
HARFBUZZ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HARFBUZZ_PKG_NAME)-pkg-description
HARFBUZZ_PKG_DESCRIPTION_FILE_IN = $(HARFBUZZ_PKG_NAME)-pkg-description.in
HARFBUZZ_PKG_INSTALL_SCRIPT      = $(HARFBUZZ_PKG_NAME)-pkg-install.sh

HARFBUZZ_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HARFBUZZ_PKG_NAME)-package

pkg_basename     = $(HARFBUZZ_PKG_NAME)-$(HARFBUZZ_PKG_VERSION)-$(HARFBUZZ_PKG_ARCH)-$(HARFBUZZ_PKG_DISTRO_NAME)-$(HARFBUZZ_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_UPGRADE_TARGETS = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(HARFBUZZ_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --with-glib=yes
extra_configure_switches += --with-gobject=yes
extra_configure_switches += --enable-introspection=no
extra_configure_switches += --with-freetype=yes
extra_configure_switches += --with-icu=yes
extra_configure_switches += --with-cairo=yes
extra_configure_switches += --with-graphite2=no
extra_configure_switches += --with-uniscribe=no
extra_configure_switches += --with-coretext=no


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
	@mkdir -p $(HARFBUZZ_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@if [ -d $(HARFBUZZ_PKG)/usr/share/man ]; then \
	  ( cd $(HARFBUZZ_PKG)/usr/share/man ; \
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
	@mkdir -p $(HARFBUZZ_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(HARFBUZZ_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(HARFBUZZ_PKG)/usr/share/gtk-doc/html/$(src_dir_name)
	@( cd $(SRC_DIR)/docs/reference/html ; \
	   cp -a *.html *.css *.png \
	         $(HARFBUZZ_PKG)/usr/share/gtk-doc/html/$(src_dir_name) ; \
	 )
	@mkdir -p $(HARFBUZZ_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README THANKS TODO \
	         $(HARFBUZZ_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/$(src_dir_name) $(HARFBUZZ_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(HARFBUZZ_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(HARFBUZZ_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libharfbuzz.la          \
	                                    libharfbuzz-gobject.la  \
	                                    libharfbuzz-icu.la    ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(HARFBUZZ_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libharfbuzz.la          \
	                                            libharfbuzz-gobject.la  \
	                                            libharfbuzz-icu.la    ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libharfbuzz.la          \
	                                              libharfbuzz-gobject.la  \
	                                              libharfbuzz-icu.la    ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" harfbuzz.pc          \
	                                            harfbuzz-gobject.pc  \
	                                            harfbuzz-icu.pc    ; \
	 )
	# ======= Strip binaries =======
	@( cd $(HARFBUZZ_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(HARFBUZZ_PKG_DESCRIPTION_FILE): $(HARFBUZZ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HARFBUZZ_PKG_DESCRIPTION_FILE) $(HARFBUZZ_PKG_INSTALL_SCRIPT)
	@cp $(HARFBUZZ_PKG_DESCRIPTION_FILE) $(HARFBUZZ_PKG)/.DESCRIPTION
	@cp $(HARFBUZZ_PKG_INSTALL_SCRIPT) $(HARFBUZZ_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HARFBUZZ_PKG)/.REQUIRES
	@echo "pkgname=$(HARFBUZZ_PKG_NAME)"                            >  $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HARFBUZZ_PKG_VERSION)"                          >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "arch=$(HARFBUZZ_PKG_ARCH)"                               >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "distroname=$(HARFBUZZ_PKG_DISTRO_NAME)"                  >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "distrover=$(HARFBUZZ_PKG_DISTRO_VERSION)"                >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "group=$(HARFBUZZ_PKG_GROUP)"                             >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HARFBUZZ_PKG_SHORT_DESCRIPTION)\"" >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "url=$(HARFBUZZ_PKG_URL)"                                 >> $(HARFBUZZ_PKG)/.PKGINFO ; \
	 echo "license=$(HARFBUZZ_PKG_LICENSE)"                         >> $(HARFBUZZ_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(HARFBUZZ_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."