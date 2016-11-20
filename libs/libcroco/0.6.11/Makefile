
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


SOURCE_REQUIRES    = sources/GNOME/core/libcroco

REQUIRES           = libs/glib2/2.48.0
REQUIRES          += libs/libxml2/2.9.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.6.11
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
CROCO_PKG_NAME                = libcroco
CROCO_PKG_VERSION             = 0.6.11
CROCO_PKG_ARCH                = $(TOOLCHAIN)
CROCO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CROCO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CROCO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
CROCO_PKG_SHORT_DESCRIPTION   = CSS2 parsing and manipulation library
CROCO_PKG_URL                 = $(BUG_URL)
CROCO_PKG_LICENSE             = LGPLv2
CROCO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CROCO_PKG_NAME)-pkg-description
CROCO_PKG_DESCRIPTION_FILE_IN = $(CROCO_PKG_NAME)-pkg-description.in
CROCO_PKG_INSTALL_SCRIPT      = $(CROCO_PKG_NAME)-pkg-install.sh

CROCO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CROCO_PKG_NAME)-package

pkg_basename     = $(CROCO_PKG_NAME)-$(CROCO_PKG_VERSION)-$(CROCO_PKG_ARCH)-$(CROCO_PKG_DISTRO_NAME)-$(CROCO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(CROCO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


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
	@mkdir -p $(CROCO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(CROCO_PKG)/usr/share/man ]; then \
	  ( cd $(CROCO_PKG)/usr/share/man ; \
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
	@mkdir -p $(CROCO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(CROCO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(CROCO_PKG)/usr/share/gtk-doc/html/$(src_dir_name)
	@( cd $(SRC_DIR)/docs/reference/html ; \
	   cp -a *.html *.css *.png \
	         $(CROCO_PKG)/usr/share/gtk-doc/html/$(src_dir_name) ; \
	 )
	@mkdir -p $(CROCO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README TODO \
	         $(CROCO_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/$(src_dir_name) $(CROCO_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(CROCO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(CROCO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcroco-?.?.la ; \
	 )
	@( cd $(CROCO_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" croco-?.?-config ; \
	   sed -i "s,  @GLIB2_CFLAGS@ @LIBXML2_CFLAGS@,-I/usr/include/libcroco-0.6,g" croco-?.?-config ; \
	   sed -i "s,  @GLIB2_LIBS@ @LIBXML2_LIBS@,-lcroco-0.6,g" croco-?.?-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CROCO_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcroco-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcroco-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcroco-?.?.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" croco-?.?-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(CROCO_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(CROCO_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(CROCO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(CROCO_PKG_DESCRIPTION_FILE): $(CROCO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CROCO_PKG_DESCRIPTION_FILE) $(CROCO_PKG_INSTALL_SCRIPT)
	@cp $(CROCO_PKG_DESCRIPTION_FILE) $(CROCO_PKG)/.DESCRIPTION
	@cp $(CROCO_PKG_INSTALL_SCRIPT) $(CROCO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CROCO_PKG)/.REQUIRES
	@echo "pkgname=$(CROCO_PKG_NAME)"                            >  $(CROCO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CROCO_PKG_VERSION)"                          >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "arch=$(CROCO_PKG_ARCH)"                               >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "distroname=$(CROCO_PKG_DISTRO_NAME)"                  >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "distrover=$(CROCO_PKG_DISTRO_VERSION)"                >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "group=$(CROCO_PKG_GROUP)"                             >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CROCO_PKG_SHORT_DESCRIPTION)\"" >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "url=$(CROCO_PKG_URL)"                                 >> $(CROCO_PKG)/.PKGINFO ; \
	 echo "license=$(CROCO_PKG_LICENSE)"                         >> $(CROCO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CROCO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
