
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


SOURCE_REQUIRES    = sources/packages/l/libxml2

REQUIRES           = dev/python2/2.7.11

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 2.9.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libxml2/libxml2-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libxml2-$(version)
src_dir_name       = libxml2-$(version)
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
LIBXML2_PKG_NAME                = libxml2
LIBXML2_PKG_VERSION             = 2.9.1
LIBXML2_PKG_ARCH                = $(TOOLCHAIN)
LIBXML2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBXML2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBXML2_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBXML2_PKG_SHORT_DESCRIPTION   = XML parser library
LIBXML2_PKG_URL                 = $(BUG_URL)
LIBXML2_PKG_LICENSE             = custom
LIBXML2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBXML2_PKG_NAME)-pkg-description
LIBXML2_PKG_DESCRIPTION_FILE_IN = $(LIBXML2_PKG_NAME)-pkg-description.in
LIBXML2_PKG_INSTALL_SCRIPT      = $(LIBXML2_PKG_NAME)-pkg-install.sh

LIBXML2_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBXML2_PKG_NAME)-package

pkg_basename     = $(LIBXML2_PKG_NAME)-$(LIBXML2_PKG_VERSION)-$(LIBXML2_PKG_ARCH)-$(LIBXML2_PKG_DISTRO_NAME)-$(LIBXML2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBXML2_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_LIBS=-L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch -t 201401010000.00 $(SRC_DIR)/*
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
	@mkdir -p $(LIBXML2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBXML2_PKG)/usr/share/man ]; then \
	  ( cd $(LIBXML2_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBXML2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBXML2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBXML2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* TODO* \
	         $(LIBXML2_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBXML2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBXML2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxml2.la  \
	 )
	@( cd $(LIBXML2_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxml2mod.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBXML2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libxml2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxml2.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libxml2mod.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxml2mod.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libxml-2.0.pc \
	 )
	# ======= tune xml2-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g"     xml2-config ; \
	   sed -i "s,prefix/lib,prefix/lib$(LIBSUFFIX),g" xml2-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBXML2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBXML2_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBXML2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBXML2_PKG_DESCRIPTION_FILE): $(LIBXML2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBXML2_PKG_DESCRIPTION_FILE) $(LIBXML2_PKG_INSTALL_SCRIPT)
	@cp $(LIBXML2_PKG_DESCRIPTION_FILE) $(LIBXML2_PKG)/.DESCRIPTION
	@cp $(LIBXML2_PKG_INSTALL_SCRIPT) $(LIBXML2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBXML2_PKG)/.REQUIRES
	@echo "pkgname=$(LIBXML2_PKG_NAME)"                            >  $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBXML2_PKG_VERSION)"                          >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBXML2_PKG_ARCH)"                               >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBXML2_PKG_DISTRO_NAME)"                  >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBXML2_PKG_DISTRO_VERSION)"                >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "group=$(LIBXML2_PKG_GROUP)"                             >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBXML2_PKG_SHORT_DESCRIPTION)\"" >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "url=$(LIBXML2_PKG_URL)"                                 >> $(LIBXML2_PKG)/.PKGINFO ; \
	 echo "license=$(LIBXML2_PKG_LICENSE)"                         >> $(LIBXML2_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBXML2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
