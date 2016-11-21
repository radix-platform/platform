
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


SOURCE_REQUIRES    = sources/packages/l/pycairo

REQUIRES           = dev/python2/2.7.11
REQUIRES          += X11/libs/cairo/1.14.6

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 1.8.10
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/pycairo/py2cairo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pycairo-$(version)
src_dir_name       = pycairo-$(version)
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
PYCAIRO_PKG_NAME                = pycairo
PYCAIRO_PKG_VERSION             = 1.8.10
PYCAIRO_PKG_ARCH                = $(TOOLCHAIN)
PYCAIRO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PYCAIRO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PYCAIRO_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
PYCAIRO_PKG_SHORT_DESCRIPTION   = Python bindings for the cairo library
PYCAIRO_PKG_URL                 = $(BUG_URL)
PYCAIRO_PKG_LICENSE             = LGPLv2.1
PYCAIRO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PYCAIRO_PKG_NAME)-pkg-description
PYCAIRO_PKG_DESCRIPTION_FILE_IN = $(PYCAIRO_PKG_NAME)-pkg-description.in
PYCAIRO_PKG_INSTALL_SCRIPT      = $(PYCAIRO_PKG_NAME)-pkg-install.sh

PYCAIRO_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PYCAIRO_PKG_NAME)-package

pkg_basename     = $(PYCAIRO_PKG_NAME)-$(PYCAIRO_PKG_VERSION)-$(PYCAIRO_PKG_ARCH)-$(PYCAIRO_PKG_DISTRO_NAME)-$(PYCAIRO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PYCAIRO_PKG)

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

extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""

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
	@mkdir -p $(PYCAIRO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PYCAIRO_PKG)/usr/share/man ]; then \
	  ( cd $(PYCAIRO_PKG)/usr/share/man ; \
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
	@mkdir -p $(PYCAIRO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(PYCAIRO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PYCAIRO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README \
	         $(PYCAIRO_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PYCAIRO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PYCAIRO_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/cairo ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _cairo.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PYCAIRO_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages/cairo ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _cairo.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _cairo.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pycairo.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(PYCAIRO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PYCAIRO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PYCAIRO_PKG_DESCRIPTION_FILE): $(PYCAIRO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PYCAIRO_PKG_DESCRIPTION_FILE) $(PYCAIRO_PKG_INSTALL_SCRIPT)
	@cp $(PYCAIRO_PKG_DESCRIPTION_FILE) $(PYCAIRO_PKG)/.DESCRIPTION
	@cp $(PYCAIRO_PKG_INSTALL_SCRIPT) $(PYCAIRO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PYCAIRO_PKG)/.REQUIRES
	@echo "pkgname=$(PYCAIRO_PKG_NAME)"                            >  $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PYCAIRO_PKG_VERSION)"                          >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "arch=$(PYCAIRO_PKG_ARCH)"                               >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "distroname=$(PYCAIRO_PKG_DISTRO_NAME)"                  >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "distrover=$(PYCAIRO_PKG_DISTRO_VERSION)"                >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "group=$(PYCAIRO_PKG_GROUP)"                             >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PYCAIRO_PKG_SHORT_DESCRIPTION)\"" >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "url=$(PYCAIRO_PKG_URL)"                                 >> $(PYCAIRO_PKG)/.PKGINFO ; \
	 echo "license=$(PYCAIRO_PKG_LICENSE)"                         >> $(PYCAIRO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PYCAIRO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
