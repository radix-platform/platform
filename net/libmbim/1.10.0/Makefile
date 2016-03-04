
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/libmbim

REQUIRES           = libs/eudev/3.1.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.10.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/libmbim/libmbim-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libmbim-$(version)
src_dir_name       = libmbim-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBMBIM_PKG_NAME                = libmbim
LIBMBIM_PKG_VERSION             = 1.10.0
LIBMBIM_PKG_ARCH                = $(TOOLCHAIN)
LIBMBIM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBMBIM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBMBIM_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBMBIM_PKG_SHORT_DESCRIPTION   = MBIM library and utils
LIBMBIM_PKG_URL                 = $(BUG_URL)
LIBMBIM_PKG_LICENSE             = LGPLv2.1
LIBMBIM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBMBIM_PKG_NAME)-pkg-description
LIBMBIM_PKG_DESCRIPTION_FILE_IN = $(LIBMBIM_PKG_NAME)-pkg-description.in
LIBMBIM_PKG_INSTALL_SCRIPT      = $(LIBMBIM_PKG_NAME)-pkg-install.sh

LIBMBIM_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBMBIM_PKG_NAME)-package

pkg_basename     = $(LIBMBIM_PKG_NAME)-$(LIBMBIM_PKG_VERSION)-$(LIBMBIM_PKG_ARCH)-$(LIBMBIM_PKG_DISTRO_NAME)-$(LIBMBIM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBMBIM_PKG)


ENABLE_GTK_DOCUMENTATION  = yes

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-gtk-doc=no
extra_configure_switches += --enable-gtk-doc-html=no
extra_configure_switches += --enable-gtk-doc-pdf=no
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBMBIM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBMBIM_PKG)/usr/share/man ]; then \
	  ( cd $(LIBMBIM_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBMBIM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBMBIM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBMBIM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README \
	         $(LIBMBIM_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@mkdir -p $(LIBMBIM_PKG)/usr/share/gtk-doc/html/libmbim-glib
	@cp -a $(SRC_DIR)/docs/reference/libmbim-glib/html/*.{html,png,css} $(LIBMBIM_PKG)/usr/share/gtk-doc/html/libmbim-glib
	@mkdir -p $(LIBMBIM_PKG)/usr/share/doc/$(src_dir_name)/html
	@ln -sf ../../../gtk-doc/html/libmbim-glib $(LIBMBIM_PKG)/usr/share/doc/$(src_dir_name)/html/libmbim-glib
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBMBIM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBMBIM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmbim-glib.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBMBIM_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmbim-glib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmbim-glib.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" mbim-glib.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBMBIM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBMBIM_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBMBIM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBMBIM_PKG_DESCRIPTION_FILE): $(LIBMBIM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBMBIM_PKG_DESCRIPTION_FILE) $(LIBMBIM_PKG_INSTALL_SCRIPT)
	@cp $(LIBMBIM_PKG_DESCRIPTION_FILE) $(LIBMBIM_PKG)/.DESCRIPTION
	@cp $(LIBMBIM_PKG_INSTALL_SCRIPT) $(LIBMBIM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBMBIM_PKG)/.REQUIRES
	@echo "pkgname=$(LIBMBIM_PKG_NAME)"                            >  $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBMBIM_PKG_VERSION)"                          >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBMBIM_PKG_ARCH)"                               >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBMBIM_PKG_DISTRO_NAME)"                  >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBMBIM_PKG_DISTRO_VERSION)"                >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "group=$(LIBMBIM_PKG_GROUP)"                             >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBMBIM_PKG_SHORT_DESCRIPTION)\"" >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "url=$(LIBMBIM_PKG_URL)"                                 >> $(LIBMBIM_PKG)/.PKGINFO ; \
	 echo "license=$(LIBMBIM_PKG_LICENSE)"                         >> $(LIBMBIM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBMBIM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
