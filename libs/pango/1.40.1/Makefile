
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/pango

REQUIRES           = libs/harfbuzz/1.2.7
REQUIRES          += libs/libthai/0.1.24
REQUIRES          += X11/X.org/lib/libXft/2.3.2

# ======= __END_OF_REQUIRES__ =======


version            = 1.40.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/pango/pango-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/pango-$(version)
src_dir_name       = pango-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

update_script_in   = $(CURDIR)/update-modules/update-pango-querymodules.in

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
PANGO_PKG_NAME                = pango
PANGO_PKG_VERSION             = 1.40.1
PANGO_PKG_ARCH                = $(TOOLCHAIN)
PANGO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PANGO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PANGO_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
PANGO_PKG_SHORT_DESCRIPTION   = library for layout and rendering of text
PANGO_PKG_URL                 = $(BUG_URL)
PANGO_PKG_LICENSE             = GPLv2
PANGO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PANGO_PKG_NAME)-pkg-description
PANGO_PKG_DESCRIPTION_FILE_IN = $(PANGO_PKG_NAME)-pkg-description.in
PANGO_PKG_INSTALL_SCRIPT      = $(PANGO_PKG_NAME)-pkg-install.sh

PANGO_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PANGO_PKG_NAME)-package

pkg_basename     = $(PANGO_PKG_NAME)-$(PANGO_PKG_VERSION)-$(PANGO_PKG_ARCH)-$(PANGO_PKG_DISTRO_NAME)-$(PANGO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PANGO_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --with-xft
extra_configure_switches += --localstatedir=/var

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
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  --target=$(TARGET)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(PANGO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PANGO_PKG)/usr/share/man ]; then \
	  ( cd $(PANGO_PKG)/usr/share/man ; \
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
	@mkdir -p $(PANGO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(PANGO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(PANGO_PKG)/usr/share/gtk-doc/html/$(src_dir_name)
	@( cd $(SRC_DIR)/docs/html ; \
	   cp -a *.html *.css *.png *.gif \
	         $(PANGO_PKG)/usr/share/gtk-doc/html/$(src_dir_name) ; \
	 )
	@mkdir -p $(PANGO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING INSTALL MAINTAINERS NEWS README* THANKS \
	         $(PANGO_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/$(src_dir_name) $(PANGO_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PANGO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PANGO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpango-?.?.la libpangocairo-?.?.la    \
	                                    libpangoft2-?.?.la libpangoxft-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PANGO_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpango-?.?.la libpangocairo-?.?.la    \
	                                            libpangoft2-?.?.la libpangoxft-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpango-?.?.la libpangocairo-?.?.la    \
	                                              libpangoft2-?.?.la libpangoxft-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" pango.pc pangocairo.pc    \
	                                            pangoft2.pc pangoxft.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(PANGO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(PANGO_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(PANGO_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(PANGO_PKG_DESCRIPTION_FILE): $(PANGO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PANGO_PKG_DESCRIPTION_FILE) $(PANGO_PKG_INSTALL_SCRIPT)
	@cp $(PANGO_PKG_DESCRIPTION_FILE) $(PANGO_PKG)/.DESCRIPTION
	@cp $(PANGO_PKG_INSTALL_SCRIPT) $(PANGO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PANGO_PKG)/.REQUIRES
	@echo "pkgname=$(PANGO_PKG_NAME)"                            >  $(PANGO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PANGO_PKG_VERSION)"                          >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "arch=$(PANGO_PKG_ARCH)"                               >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "distroname=$(PANGO_PKG_DISTRO_NAME)"                  >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "distrover=$(PANGO_PKG_DISTRO_VERSION)"                >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "group=$(PANGO_PKG_GROUP)"                             >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PANGO_PKG_SHORT_DESCRIPTION)\"" >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "url=$(PANGO_PKG_URL)"                                 >> $(PANGO_PKG)/.PKGINFO ; \
	 echo "license=$(PANGO_PKG_LICENSE)"                         >> $(PANGO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(PANGO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
