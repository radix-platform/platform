
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libtiff

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
endif
REQUIRES          += app/xz/5.2.2
REQUIRES          += app/jbigkit/2.1
REQUIRES          += libs/libjpeg-turbo/1.4.2

# ======= __END_OF_REQUIRES__ =======


version            = 4.0.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libtiff/tiff-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/tiff-$(version)
src_dir_name       = tiff-$(version)
doc_dir_name       = libtiff-$(version)
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
LIBTIFF_PKG_NAME                = libtiff
LIBTIFF_PKG_VERSION             = 4.0.3
LIBTIFF_PKG_ARCH                = $(TOOLCHAIN)
LIBTIFF_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBTIFF_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBTIFF_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBTIFF_PKG_SHORT_DESCRIPTION   = a library for manipulation of TIFF images
LIBTIFF_PKG_URL                 = $(BUG_URL)
LIBTIFF_PKG_LICENSE             = custom
LIBTIFF_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBTIFF_PKG_NAME)-pkg-description
LIBTIFF_PKG_DESCRIPTION_FILE_IN = $(LIBTIFF_PKG_NAME)-pkg-description.in
LIBTIFF_PKG_INSTALL_SCRIPT      = $(LIBTIFF_PKG_NAME)-pkg-install.sh

LIBTIFF_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBTIFF_PKG_NAME)-package

pkg_basename     = $(LIBTIFF_PKG_NAME)-$(LIBTIFF_PKG_VERSION)-$(LIBTIFF_PKG_ARCH)-$(LIBTIFF_PKG_DISTRO_NAME)-$(LIBTIFF_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBTIFF_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --program-prefix=""
extra_configure_switches += --program-suffix=""
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBTIFF_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(LIBTIFF_PKG)/usr/share/doc ; mv $(src_dir_name) $(doc_dir_name) )
	# ======= Install Documentation =======
	@if [ -d $(LIBTIFF_PKG)/usr/share/man ]; then \
	  ( cd $(LIBTIFF_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        if [ ! -z "`find . -type f -name "*.?"`" ]     ; then gzip -9 *.?     ; fi ; \
	        if [ ! -z "`find . -type f -name "*.?tiff"`" ] ; then gzip -9 *.?tiff ; fi ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBTIFF_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/COPYRIGHT \
	       $(LIBTIFF_PKG)/usr/doc/$(doc_dir_name)
	@( cd $(LIBTIFF_PKG)/usr/share/doc/$(doc_dir_name) ; rm -f ChangeLog )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBTIFF_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBTIFF_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libtiff.la libtiffxx.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBTIFF_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtiff.la libtiffxx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libtiff.la libtiffxx.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libtiff-?.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBTIFF_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBTIFF_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBTIFF_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBTIFF_PKG_DESCRIPTION_FILE): $(LIBTIFF_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBTIFF_PKG_DESCRIPTION_FILE) $(LIBTIFF_PKG_INSTALL_SCRIPT)
	@cp $(LIBTIFF_PKG_DESCRIPTION_FILE) $(LIBTIFF_PKG)/.DESCRIPTION
	@cp $(LIBTIFF_PKG_INSTALL_SCRIPT) $(LIBTIFF_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBTIFF_PKG)/.REQUIRES
	@echo "pkgname=$(LIBTIFF_PKG_NAME)"                            >  $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBTIFF_PKG_VERSION)"                          >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBTIFF_PKG_ARCH)"                               >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBTIFF_PKG_DISTRO_NAME)"                  >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBTIFF_PKG_DISTRO_VERSION)"                >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "group=$(LIBTIFF_PKG_GROUP)"                             >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBTIFF_PKG_SHORT_DESCRIPTION)\"" >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "url=$(LIBTIFF_PKG_URL)"                                 >> $(LIBTIFF_PKG)/.PKGINFO ; \
	 echo "license=$(LIBTIFF_PKG_LICENSE)"                         >> $(LIBTIFF_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBTIFF_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
