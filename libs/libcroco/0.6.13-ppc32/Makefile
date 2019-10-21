
COMPONENT_TARGETS  = $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_PPC32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/libcroco

REQUIRES           = libs/libcroco/0.6.13
REQUIRES          += libs/glib2/2.63.0-ppc32
REQUIRES          += libs/libxml2/2.9.9-ppc32

# ======= __END_OF_REQUIRES__ =======


version            = 0.6.13
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/libcroco/libcroco-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcroco-$(version)
src_dir_name       = libcroco-$(version)
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
CROCO_32_PKG_NAME                = libcroco-x32
CROCO_32_PKG_VERSION             = 0.6.13
CROCO_32_PKG_ARCH                = $(TOOLCHAIN)
CROCO_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CROCO_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CROCO_32_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
CROCO_32_PKG_SHORT_DESCRIPTION   = CSS2 parsing and manipulation library
CROCO_32_PKG_URL                 = $(BUG_URL)
CROCO_32_PKG_LICENSE             = LGPLv2
CROCO_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CROCO_32_PKG_NAME)-pkg-description
CROCO_32_PKG_DESCRIPTION_FILE_IN = $(CROCO_32_PKG_NAME)-pkg-description.in
CROCO_32_PKG_INSTALL_SCRIPT      = $(CROCO_32_PKG_NAME)-pkg-install.sh

CROCO_32_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CROCO_32_PKG_NAME)-package

pkg_basename     = $(CROCO_32_PKG_NAME)-$(CROCO_32_PKG_VERSION)-$(CROCO_32_PKG_ARCH)-$(CROCO_32_PKG_DISTRO_NAME)-$(CROCO_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(CROCO_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_PPC32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --enable-gtk-doc=no

ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


TARGET_RPATH = /lib$(MULTILIB_PPC32_SUFFIX):/usr/lib$(MULTILIB_PPC32_SUFFIX)


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
	@mkdir -p $(CROCO_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(CROCO_32_PKG)/usr/include
	@rm -rf $(CROCO_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CROCO_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcroco-?.?.la ; \
	 )
	@( cd $(CROCO_32_PKG)/usr/bin/32 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" croco-?.?-config ; \
	   sed -i "s,@GLIB2_CFLAGS@ @LIBXML2_CFLAGS@,-I/usr/include/libcroco-0.6,g" croco-?.?-config ; \
	   sed -i "s,@GLIB2_LIBS@ @LIBXML2_LIBS@,-lcroco-0.6,g" croco-?.?-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CROCO_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcroco-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcroco-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_PPC32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcroco-?.?.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" croco-?.?-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(CROCO_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(CROCO_32_PKG); \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(CROCO_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CROCO_32_PKG)/usr/lib$(MULTILIB_PPC32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CROCO_32_PKG_DESCRIPTION_FILE): $(CROCO_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CROCO_32_PKG_DESCRIPTION_FILE) $(CROCO_32_PKG_INSTALL_SCRIPT)
	@cp $(CROCO_32_PKG_DESCRIPTION_FILE) $(CROCO_32_PKG)/.DESCRIPTION
	@cp $(CROCO_32_PKG_INSTALL_SCRIPT) $(CROCO_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CROCO_32_PKG)/.REQUIRES
	@echo "pkgname=$(CROCO_32_PKG_NAME)"                            >  $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CROCO_32_PKG_VERSION)"                          >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "arch=$(CROCO_32_PKG_ARCH)"                               >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(CROCO_32_PKG_DISTRO_NAME)"                  >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(CROCO_32_PKG_DISTRO_VERSION)"                >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "group=$(CROCO_32_PKG_GROUP)"                             >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CROCO_32_PKG_SHORT_DESCRIPTION)\"" >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "url=$(CROCO_32_PKG_URL)"                                 >> $(CROCO_32_PKG)/.PKGINFO ; \
	 echo "license=$(CROCO_32_PKG_LICENSE)"                         >> $(CROCO_32_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(CROCO_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
