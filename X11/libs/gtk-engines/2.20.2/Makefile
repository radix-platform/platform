
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/gtk-engines

REQUIRES           = X11/libs/gtk+2/2.24.25
REQUIRES          += dev/lua/5.3.2

# ======= __END_OF_REQUIRES__ =======


version            = 2.20.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/GNOME/core/gtk-engines/gtk-engines-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gtk-engines-$(version)
src_dir_name       = gtk-engines-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GTKENGINES_PKG_NAME                = gtk-engines
GTKENGINES_PKG_VERSION             = 2.20.2
GTKENGINES_PKG_ARCH                = $(TOOLCHAIN)
GTKENGINES_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GTKENGINES_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GTKENGINES_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
GTKENGINES_PKG_SHORT_DESCRIPTION   = commonly used GTK+ engines
GTKENGINES_PKG_URL                 = $(BUG_URL)
GTKENGINES_PKG_LICENSE             = LGPLv2.1
GTKENGINES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GTKENGINES_PKG_NAME)-pkg-description
GTKENGINES_PKG_DESCRIPTION_FILE_IN = $(GTKENGINES_PKG_NAME)-pkg-description.in
GTKENGINES_PKG_INSTALL_SCRIPT      = $(GTKENGINES_PKG_NAME)-pkg-install.sh

GTKENGINES_PKG   = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GTKENGINES_PKG_NAME)-package

pkg_basename     = $(GTKENGINES_PKG_NAME)-$(GTKENGINES_PKG_VERSION)-$(GTKENGINES_PKG_ARCH)-$(GTKENGINES_PKG_DISTRO_NAME)-$(GTKENGINES_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(GTKENGINES_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-lua
extra_configure_switches += --with-system-lua
extra_configure_switches += --enable-animation

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(GTKENGINES_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(GTKENGINES_PKG)/usr/share/man ]; then \
	  ( cd $(GTKENGINES_PKG)/usr/share/man ; \
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
	@mkdir -p $(GTKENGINES_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GTKENGINES_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GTKENGINES_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(GTKENGINES_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GTKENGINES_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GTKENGINES_PKG)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/engines ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libclearlooks.la libcrux-engine.la           \
	                                    libglide.la libhcengine.la libindustrial.la  \
	                                    libluaengine.la libmist.la libredmond95.la   \
	                                    libthinice.la                              ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GTKENGINES_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gtk-?.?/?.??.?/engines ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libclearlooks.la libcrux-engine.la           \
	                                            libglide.la libhcengine.la libindustrial.la  \
	                                            libluaengine.la libmist.la libredmond95.la   \
	                                            libthinice.la                              ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libclearlooks.la libcrux-engine.la           \
	                                              libglide.la libhcengine.la libindustrial.la  \
	                                              libluaengine.la libmist.la libredmond95.la   \
	                                              libthinice.la                              ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gtk-engines-2.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GTKENGINES_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GTKENGINES_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GTKENGINES_PKG_DESCRIPTION_FILE): $(GTKENGINES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GTKENGINES_PKG_DESCRIPTION_FILE) $(GTKENGINES_PKG_INSTALL_SCRIPT)
	@cp $(GTKENGINES_PKG_DESCRIPTION_FILE) $(GTKENGINES_PKG)/.DESCRIPTION
	@cp $(GTKENGINES_PKG_INSTALL_SCRIPT) $(GTKENGINES_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GTKENGINES_PKG)/.REQUIRES
	@echo "pkgname=$(GTKENGINES_PKG_NAME)"                            >  $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GTKENGINES_PKG_VERSION)"                          >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "arch=$(GTKENGINES_PKG_ARCH)"                               >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "distroname=$(GTKENGINES_PKG_DISTRO_NAME)"                  >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "distrover=$(GTKENGINES_PKG_DISTRO_VERSION)"                >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "group=$(GTKENGINES_PKG_GROUP)"                             >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GTKENGINES_PKG_SHORT_DESCRIPTION)\"" >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "url=$(GTKENGINES_PKG_URL)"                                 >> $(GTKENGINES_PKG)/.PKGINFO ; \
	 echo "license=$(GTKENGINES_PKG_LICENSE)"                         >> $(GTKENGINES_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GTKENGINES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
