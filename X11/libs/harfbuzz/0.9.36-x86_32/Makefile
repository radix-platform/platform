
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/harfbuzz

REQUIRES           = libs/harfbuzz/0.9.36
REQUIRES          += libs/glib2/2.40.0-x86_32
REQUIRES          += libs/libpng/libpng14/1.4.13-x86_32
REQUIRES          += libs/icu4c/54.1-x86_32
REQUIRES          += X11/libs/cairo/1.14.0-x86_32
REQUIRES          += libs/libffi/3.0.13-x86_32
REQUIRES          += libs/zlib/1.2.8-x86_32
REQUIRES          += app/bzip2/1.0.6-x86_32
# NOTE (about 'env/freetype/2.5.3-x86_32'):
#       We should not require final freetipe to avoid a cycle
#       in the dependency tree desctibed in package requires,
#       also we can skip 'env/freetype' dependency because
#       'freetype' will be installed by 'cairo' request:
#
#       REQUIRES          += env/freetype/2.5.3-x86_32
#

# ======= __END_OF_REQUIRES__ =======


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
HARFBUZZ_32_PKG_NAME                = harfbuzz-x32
HARFBUZZ_32_PKG_VERSION             = 0.9.36
HARFBUZZ_32_PKG_ARCH                = $(TOOLCHAIN)
HARFBUZZ_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
HARFBUZZ_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
HARFBUZZ_32_PKG_GROUP               = $(PKG_GROUP)
###                                  |---handy-ruler-------------------------------|
HARFBUZZ_32_PKG_SHORT_DESCRIPTION   = OpenType text shaping engine
HARFBUZZ_32_PKG_URL                 = $(BUG_URL)
HARFBUZZ_32_PKG_LICENSE             = MIT
HARFBUZZ_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(HARFBUZZ_32_PKG_NAME)-pkg-description
HARFBUZZ_32_PKG_DESCRIPTION_FILE_IN = $(HARFBUZZ_32_PKG_NAME)-pkg-description.in
HARFBUZZ_32_PKG_INSTALL_SCRIPT      = $(HARFBUZZ_32_PKG_NAME)-pkg-install.sh

HARFBUZZ_32_PKG  = $(CURDIR)/$(TARGET_BUILD_DIR)/$(HARFBUZZ_32_PKG_NAME)-package

pkg_basename     = $(HARFBUZZ_32_PKG_NAME)-$(HARFBUZZ_32_PKG_VERSION)-$(HARFBUZZ_32_PKG_ARCH)-$(HARFBUZZ_32_PKG_DISTRO_NAME)-$(HARFBUZZ_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_UPDATE_TARGETS = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(HARFBUZZ_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --with-glib=yes
extra_configure_switches += --with-gobject=yes
extra_configure_switches += --enable-introspection=no
extra_configure_switches += --with-freetype=yes
extra_configure_switches += --with-icu=yes
extra_configure_switches += --with-cairo=yes
extra_configure_switches += --with-graphite2=no
extra_configure_switches += --with-uniscribe=no
extra_configure_switches += --with-coretext=no


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(HARFBUZZ_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(HARFBUZZ_32_PKG)/usr/include
	@rm -rf $(HARFBUZZ_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(HARFBUZZ_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libharfbuzz.la          \
	                                    libharfbuzz-gobject.la  \
	                                    libharfbuzz-icu.la    ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(HARFBUZZ_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libharfbuzz.la          \
	                                            libharfbuzz-gobject.la  \
	                                            libharfbuzz-icu.la    ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libharfbuzz.la          \
	                                              libharfbuzz-gobject.la  \
	                                              libharfbuzz-icu.la    ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" harfbuzz.pc          \
	                                            harfbuzz-gobject.pc  \
	                                            harfbuzz-icu.pc    ; \
	 )
	# ======= Strip binaries =======
	@( cd $(HARFBUZZ_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(HARFBUZZ_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(HARFBUZZ_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(HARFBUZZ_32_PKG_DESCRIPTION_FILE): $(HARFBUZZ_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(HARFBUZZ_32_PKG_DESCRIPTION_FILE) $(HARFBUZZ_32_PKG_INSTALL_SCRIPT)
	@cp $(HARFBUZZ_32_PKG_DESCRIPTION_FILE) $(HARFBUZZ_32_PKG)/.DESCRIPTION
	@cp $(HARFBUZZ_32_PKG_INSTALL_SCRIPT) $(HARFBUZZ_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(HARFBUZZ_32_PKG)/.REQUIRES
	@echo "pkgname=$(HARFBUZZ_32_PKG_NAME)"                            >  $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(HARFBUZZ_32_PKG_VERSION)"                          >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "arch=$(HARFBUZZ_32_PKG_ARCH)"                               >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(HARFBUZZ_32_PKG_DISTRO_NAME)"                  >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(HARFBUZZ_32_PKG_DISTRO_VERSION)"                >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "group=$(HARFBUZZ_32_PKG_GROUP)"                             >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(HARFBUZZ_32_PKG_SHORT_DESCRIPTION)\"" >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "url=$(HARFBUZZ_32_PKG_URL)"                                 >> $(HARFBUZZ_32_PKG)/.PKGINFO ; \
	 echo "license=$(HARFBUZZ_32_PKG_LICENSE)"                         >> $(HARFBUZZ_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(HARFBUZZ_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
