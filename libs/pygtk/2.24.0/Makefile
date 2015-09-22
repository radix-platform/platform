
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/pygtk

REQUIRES           = dev/python2/2.7.6
REQUIRES          += X11/libs/gtk+2/2.24.25
REQUIRES          += X11/libs/libglade/2.6.4
REQUIRES          += libs/pygobject/2.28.6
REQUIRES          += libs/pycairo/1.8.10

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 2.24.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNOME/core/pygtk/pygtk-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pygtk-$(version)
src_dir_name       = pygtk-$(version)
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
PYGTK2_PKG_NAME                = pygtk
PYGTK2_PKG_VERSION             = 2.24.0
PYGTK2_PKG_ARCH                = $(TOOLCHAIN)
PYGTK2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYGTK2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYGTK2_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
PYGTK2_PKG_SHORT_DESCRIPTION   = GTK+ bindings for Python
PYGTK2_PKG_URL                 = $(BUG_URL)
PYGTK2_PKG_LICENSE             = LGPLv2.1
PYGTK2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYGTK2_PKG_NAME)-pkg-description
PYGTK2_PKG_DESCRIPTION_FILE_IN = $(PYGTK2_PKG_NAME)-pkg-description.in
PYGTK2_PKG_INSTALL_SCRIPT      = $(PYGTK2_PKG_NAME)-pkg-install.sh

PYGTK2_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYGTK2_PKG_NAME)-package

pkg_basename     = $(PYGTK2_PKG_NAME)-$(PYGTK2_PKG_VERSION)-$(PYGTK2_PKG_ARCH)-$(PYGTK2_PKG_DISTRO_NAME)-$(PYGTK2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PYGTK2_PKG)

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

extra_configure_switches += --enable-docs
extra_configure_switches += --disable-glibtest

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

ifneq ($(filter $(HARDWARE),$(HARDWARE_CI20)),)
LDFLAGS += -lEGL -lGLESv2
endif

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
	@mkdir -p $(PYGTK2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PYGTK2_PKG)/usr/share/man ]; then \
	  ( cd $(PYGTK2_PKG)/usr/share/man ; \
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
	@mkdir -p $(PYGTK2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PYGTK2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PYGTK2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL MAPPING NEWS README THREADS TODO \
	         $(PYGTK2_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/pygtk $(PYGTK2_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PYGTK2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PYGTK2_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gtk-2.0 ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" atk.la gtkunixprint.la pango.la pangocairo.la \
	 )
	@( cd $(PYGTK2_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gtk-2.0/gtk ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _gtk.la glade.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYGTK2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gtk-2.0 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" atk.la gtkunixprint.la pango.la pangocairo.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" atk.la gtkunixprint.la pango.la pangocairo.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/gtk-2.0/gtk ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _gtk.la glade.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _gtk.la glade.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pygtk-2.0.pc \
	 )
	# ======= tune pygtk-codegen-2.0 script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" pygtk-codegen-2.0 ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PYGTK2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PYGTK2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PYGTK2_PKG_DESCRIPTION_FILE): $(PYGTK2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYGTK2_PKG_DESCRIPTION_FILE) $(PYGTK2_PKG_INSTALL_SCRIPT)
	@cp $(PYGTK2_PKG_DESCRIPTION_FILE) $(PYGTK2_PKG)/.DESCRIPTION
	@cp $(PYGTK2_PKG_INSTALL_SCRIPT) $(PYGTK2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYGTK2_PKG)/.REQUIRES
	@echo "pkgname=$(PYGTK2_PKG_NAME)"                            >  $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYGTK2_PKG_VERSION)"                          >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "arch=$(PYGTK2_PKG_ARCH)"                               >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYGTK2_PKG_DISTRO_NAME)"                  >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYGTK2_PKG_DISTRO_VERSION)"                >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "group=$(PYGTK2_PKG_GROUP)"                             >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYGTK2_PKG_SHORT_DESCRIPTION)\"" >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "url=$(PYGTK2_PKG_URL)"                                 >> $(PYGTK2_PKG)/.PKGINFO ; \
	 echo "license=$(PYGTK2_PKG_LICENSE)"                         >> $(PYGTK2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PYGTK2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
