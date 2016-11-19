
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/pango

REQUIRES           = libs/pango/1.36.8
REQUIRES          += libs/harfbuzz/1.2.7-x86_32
REQUIRES          += libs/libthai/0.1.24-x86_32
REQUIRES          += X11/X.org/lib/libXft/2.3.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 1.36.8
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/pango/pango-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pango-$(version)
src_dir_name       = pango-$(version)
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
PANGO_32_PKG_NAME                = pango-x32
PANGO_32_PKG_VERSION             = 1.36.8
PANGO_32_PKG_ARCH                = $(TOOLCHAIN)
PANGO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PANGO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PANGO_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
PANGO_32_PKG_SHORT_DESCRIPTION   = library for layout and rendering of text
PANGO_32_PKG_URL                 = $(BUG_URL)
PANGO_32_PKG_LICENSE             = GPLv2
PANGO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PANGO_32_PKG_NAME)-pkg-description
PANGO_32_PKG_DESCRIPTION_FILE_IN = $(PANGO_32_PKG_NAME)-pkg-description.in
PANGO_32_PKG_INSTALL_SCRIPT      = $(PANGO_32_PKG_NAME)-pkg-install.sh

PANGO_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PANGO_32_PKG_NAME)-package

pkg_basename     = $(PANGO_32_PKG_NAME)-$(PANGO_32_PKG_VERSION)-$(PANGO_32_PKG_ARCH)-$(PANGO_32_PKG_DISTRO_NAME)-$(PANGO_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(PANGO_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

#
# NOTE: bindir=/usr/bun is correct! See installation process below.
#
extra_configure_switches += --bindir=/usr/bin

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --with-xft
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --with-included-modules=basic-fc

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@rm -f $(SRC_DIR)/pango-view/pango-view.1.in
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
	@mkdir -p $(PANGO_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(PANGO_32_PKG)/etc/pango/$(TARGET32)
	@touch $(PANGO_32_PKG)/etc/pango/$(TARGET32)/pango.modules
	@mkdir -p $(PANGO_32_PKG)/usr/bin/32
	@( cd $(PANGO_32_PKG)/usr/bin ; \
	   mv pango-querymodules pango-querymodules-32 ; \
	   mv pango-view 32 ; \
	 )
	@rm -rf $(PANGO_32_PKG)/usr/include
	@rm -rf $(PANGO_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PANGO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpango-?.?.la libpangocairo-?.?.la    \
	                                    libpangoft2-?.?.la libpangoxft-?.?.la ; \
	 )
	@( cd $(PANGO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pango/?.?.?/modules ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" pango-arabic-lang.la pango-indic-lang.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PANGO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpango-?.?.la libpangocairo-?.?.la    \
	                                            libpangoft2-?.?.la libpangoxft-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpango-?.?.la libpangocairo-?.?.la    \
	                                              libpangoft2-?.?.la libpangoxft-?.?.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pango/?.?.?/modules ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pango-arabic-lang.la pango-indic-lang.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" pango-arabic-lang.la pango-indic-lang.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pango.pc pangocairo.pc    \
	                                            pangoft2.pc pangoxft.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PANGO_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(PANGO_32_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PANGO_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PANGO_32_PKG_DESCRIPTION_FILE): $(PANGO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PANGO_32_PKG_DESCRIPTION_FILE) $(PANGO_32_PKG_INSTALL_SCRIPT)
	@cp $(PANGO_32_PKG_DESCRIPTION_FILE) $(PANGO_32_PKG)/.DESCRIPTION
	@cp $(PANGO_32_PKG_INSTALL_SCRIPT) $(PANGO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PANGO_32_PKG)/.REQUIRES
	@echo "pkgname=$(PANGO_32_PKG_NAME)"                            >  $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PANGO_32_PKG_VERSION)"                          >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(PANGO_32_PKG_ARCH)"                               >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(PANGO_32_PKG_DISTRO_NAME)"                  >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(PANGO_32_PKG_DISTRO_VERSION)"                >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "group=$(PANGO_32_PKG_GROUP)"                             >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PANGO_32_PKG_SHORT_DESCRIPTION)\"" >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "url=$(PANGO_32_PKG_URL)"                                 >> $(PANGO_32_PKG)/.PKGINFO ; \
	 echo "license=$(PANGO_32_PKG_LICENSE)"                         >> $(PANGO_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PANGO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
