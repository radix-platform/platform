
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/libqmi

REQUIRES           = libs/zlib/1.2.8
REQUIRES          += libs/glib2/2.48.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.10.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/libqmi/libqmi-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libqmi-$(version)
src_dir_name       = libqmi-$(version)
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
LIBQMI_PKG_NAME                = libqmi
LIBQMI_PKG_VERSION             = 1.10.4
LIBQMI_PKG_ARCH                = $(TOOLCHAIN)
LIBQMI_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBQMI_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBQMI_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBQMI_PKG_SHORT_DESCRIPTION   = QMI library and utils
LIBQMI_PKG_URL                 = $(BUG_URL)
LIBQMI_PKG_LICENSE             = LGPLv2.1
LIBQMI_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBQMI_PKG_NAME)-pkg-description
LIBQMI_PKG_DESCRIPTION_FILE_IN = $(LIBQMI_PKG_NAME)-pkg-description.in
LIBQMI_PKG_INSTALL_SCRIPT      = $(LIBQMI_PKG_NAME)-pkg-install.sh

LIBQMI_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBQMI_PKG_NAME)-package

pkg_basename     = $(LIBQMI_PKG_NAME)-$(LIBQMI_PKG_VERSION)-$(LIBQMI_PKG_ARCH)-$(LIBQMI_PKG_DISTRO_NAME)-$(LIBQMI_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBQMI_PKG)


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
	@mkdir -p $(LIBQMI_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBQMI_PKG)/usr/share/man ]; then \
	  ( cd $(LIBQMI_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBQMI_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBQMI_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBQMI_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README TODO \
	         $(LIBQMI_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@mkdir -p $(LIBQMI_PKG)/usr/share/gtk-doc/html/libqmi-glib
	@cp -a $(SRC_DIR)/docs/reference/libqmi-glib/html/*.{html,png,css} $(LIBQMI_PKG)/usr/share/gtk-doc/html/libqmi-glib
	@mkdir -p $(LIBQMI_PKG)/usr/share/doc/$(src_dir_name)/html
	@ln -sf ../../../gtk-doc/html/libqmi-glib $(LIBQMI_PKG)/usr/share/doc/$(src_dir_name)/html/libqmi-glib
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBQMI_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBQMI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libqmi-glib.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBQMI_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libqmi-glib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libqmi-glib.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" qmi-glib.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBQMI_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBQMI_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBQMI_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBQMI_PKG_DESCRIPTION_FILE): $(LIBQMI_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBQMI_PKG_DESCRIPTION_FILE) $(LIBQMI_PKG_INSTALL_SCRIPT)
	@cp $(LIBQMI_PKG_DESCRIPTION_FILE) $(LIBQMI_PKG)/.DESCRIPTION
	@cp $(LIBQMI_PKG_INSTALL_SCRIPT) $(LIBQMI_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBQMI_PKG)/.REQUIRES
	@echo "pkgname=$(LIBQMI_PKG_NAME)"                            >  $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBQMI_PKG_VERSION)"                          >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBQMI_PKG_ARCH)"                               >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBQMI_PKG_DISTRO_NAME)"                  >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBQMI_PKG_DISTRO_VERSION)"                >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "group=$(LIBQMI_PKG_GROUP)"                             >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBQMI_PKG_SHORT_DESCRIPTION)\"" >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "url=$(LIBQMI_PKG_URL)"                                 >> $(LIBQMI_PKG)/.PKGINFO ; \
	 echo "license=$(LIBQMI_PKG_LICENSE)"                         >> $(LIBQMI_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBQMI_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
