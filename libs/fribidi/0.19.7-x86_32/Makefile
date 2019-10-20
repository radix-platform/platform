
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/fribidi

REQUIRES           = libs/fribidi/0.19.7
REQUIRES          += libs/glib2/2.63.0-x86_32

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
FRIBIDI_32_PKG_NAME                = fribidi-x32
FRIBIDI_32_PKG_VERSION             = 0.19.7
FRIBIDI_32_PKG_ARCH                = $(TOOLCHAIN)
FRIBIDI_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FRIBIDI_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FRIBIDI_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
FRIBIDI_32_PKG_SHORT_DESCRIPTION   = Unicode BiDirectional algorithm library
FRIBIDI_32_PKG_URL                 = $(BUG_URL)
FRIBIDI_32_PKG_LICENSE             = LGPLv2.1
FRIBIDI_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FRIBIDI_32_PKG_NAME)-pkg-description
FRIBIDI_32_PKG_DESCRIPTION_FILE_IN = $(FRIBIDI_32_PKG_NAME)-pkg-description.in
FRIBIDI_32_PKG_INSTALL_SCRIPT      = $(FRIBIDI_32_PKG_NAME)-pkg-install.sh

FRIBIDI_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FRIBIDI_32_PKG_NAME)-package

pkg_basename      = $(FRIBIDI_32_PKG_NAME)-$(FRIBIDI_32_PKG_VERSION)-$(FRIBIDI_32_PKG_ARCH)-$(FRIBIDI_32_PKG_DISTRO_NAME)-$(FRIBIDI_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(FRIBIDI_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --with-pic

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


CFLAGS += -Wno-deprecated-declarations -Wno-unused-but-set-variable -Wno-switch


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
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
	@mkdir -p $(FRIBIDI_32_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(FRIBIDI_32_PKG)/usr/include
	@rm -rf $(FRIBIDI_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FRIBIDI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfribidi.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FRIBIDI_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfribidi.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfribidi.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" fribidi.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FRIBIDI_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(FRIBIDI_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FRIBIDI_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FRIBIDI_32_PKG_DESCRIPTION_FILE): $(FRIBIDI_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FRIBIDI_32_PKG_DESCRIPTION_FILE) $(FRIBIDI_32_PKG_INSTALL_SCRIPT)
	@cp $(FRIBIDI_32_PKG_DESCRIPTION_FILE) $(FRIBIDI_32_PKG)/.DESCRIPTION
	@cp $(FRIBIDI_32_PKG_INSTALL_SCRIPT) $(FRIBIDI_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FRIBIDI_32_PKG)/.REQUIRES
	@echo "pkgname=$(FRIBIDI_32_PKG_NAME)"                            >  $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FRIBIDI_32_PKG_VERSION)"                          >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "arch=$(FRIBIDI_32_PKG_ARCH)"                               >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(FRIBIDI_32_PKG_DISTRO_NAME)"                  >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(FRIBIDI_32_PKG_DISTRO_VERSION)"                >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "group=$(FRIBIDI_32_PKG_GROUP)"                             >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FRIBIDI_32_PKG_SHORT_DESCRIPTION)\"" >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "url=$(FRIBIDI_32_PKG_URL)"                                 >> $(FRIBIDI_32_PKG)/.PKGINFO ; \
	 echo "license=$(FRIBIDI_32_PKG_LICENSE)"                         >> $(FRIBIDI_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FRIBIDI_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
