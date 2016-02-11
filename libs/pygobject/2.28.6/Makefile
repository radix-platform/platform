
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/pygobject

REQUIRES           = dev/python2/2.7.11
REQUIRES          += libs/glib2/2.40.0

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 2.28.6
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/pygobject/pygobject-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pygobject-$(version)
src_dir_name       = pygobject-$(version)
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
PYGOBJ2_PKG_NAME                = pygobject
PYGOBJ2_PKG_VERSION             = 2.28.6
PYGOBJ2_PKG_ARCH                = $(TOOLCHAIN)
PYGOBJ2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYGOBJ2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYGOBJ2_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PYGOBJ2_PKG_SHORT_DESCRIPTION   = GObject bindings for Python
PYGOBJ2_PKG_URL                 = $(BUG_URL)
PYGOBJ2_PKG_LICENSE             = LGPLv2.1
PYGOBJ2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYGOBJ2_PKG_NAME)-pkg-description
PYGOBJ2_PKG_DESCRIPTION_FILE_IN = $(PYGOBJ2_PKG_NAME)-pkg-description.in
PYGOBJ2_PKG_INSTALL_SCRIPT      = $(PYGOBJ2_PKG_NAME)-pkg-install.sh

PYGOBJ2_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYGOBJ2_PKG_NAME)-package

pkg_basename     = $(PYGOBJ2_PKG_NAME)-$(PYGOBJ2_PKG_VERSION)-$(PYGOBJ2_PKG_ARCH)-$(PYGOBJ2_PKG_DISTRO_NAME)-$(PYGOBJ2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PYGOBJ2_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-docs

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


python_environment  = am_cv_python_version=$(PYTHON_VERSION)
python_environment += am_cv_python_platform=linux2
python_environment += PYTHON_INCLUDES=-I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += am_cv_python_pythondir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PYGOBJ2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PYGOBJ2_PKG)/usr/share/man ]; then \
	  ( cd $(PYGOBJ2_PKG)/usr/share/man ; \
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
	@mkdir -p $(PYGOBJ2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PYGOBJ2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PYGOBJ2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(PYGOBJ2_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/pygobject $(PYGOBJ2_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PYGOBJ2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PYGOBJ2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpyglib-2.0-python.la \
	 )
	@( cd $(PYGOBJ2_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/glib ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _glib.la \
	 )
	@( cd $(PYGOBJ2_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gobject ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _gobject.la \
	 )
	@( cd $(PYGOBJ2_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gtk-2.0/gio ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _gio.la unix.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYGOBJ2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpyglib-2.0-python.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpyglib-2.0-python.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/glib ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _glib.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _glib.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gobject ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _gobject.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _gobject.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gtk-2.0/gio ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _gio.la unix.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _gio.la unix.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pygobject-2.0.pc \
	 )
	# ======= tune pygobject-codegen-2.0 script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" pygobject-codegen-2.0 ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PYGOBJ2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PYGOBJ2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PYGOBJ2_PKG_DESCRIPTION_FILE): $(PYGOBJ2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYGOBJ2_PKG_DESCRIPTION_FILE) $(PYGOBJ2_PKG_INSTALL_SCRIPT)
	@cp $(PYGOBJ2_PKG_DESCRIPTION_FILE) $(PYGOBJ2_PKG)/.DESCRIPTION
	@cp $(PYGOBJ2_PKG_INSTALL_SCRIPT) $(PYGOBJ2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYGOBJ2_PKG)/.REQUIRES
	@echo "pkgname=$(PYGOBJ2_PKG_NAME)"                            >  $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYGOBJ2_PKG_VERSION)"                          >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "arch=$(PYGOBJ2_PKG_ARCH)"                               >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYGOBJ2_PKG_DISTRO_NAME)"                  >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYGOBJ2_PKG_DISTRO_VERSION)"                >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "group=$(PYGOBJ2_PKG_GROUP)"                             >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYGOBJ2_PKG_SHORT_DESCRIPTION)\"" >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "url=$(PYGOBJ2_PKG_URL)"                                 >> $(PYGOBJ2_PKG)/.PKGINFO ; \
	 echo "license=$(PYGOBJ2_PKG_LICENSE)"                         >> $(PYGOBJ2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PYGOBJ2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
