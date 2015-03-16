
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNOME/core/atk

REQUIRES           = libs/glib2/2.40.0

# ======= __END_OF_REQUIRES__ =======


version            = 2.15.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/atk/atk-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/atk-$(version)
src_dir_name       = atk-$(version)
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
ATK_PKG_NAME                = atk
ATK_PKG_VERSION             = 2.15.1
ATK_PKG_ARCH                = $(TOOLCHAIN)
ATK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ATK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ATK_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
ATK_PKG_SHORT_DESCRIPTION   = accessibility functions library
ATK_PKG_URL                 = $(BUG_URL)
ATK_PKG_LICENSE             = LGPLv2
ATK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ATK_PKG_NAME)-pkg-description
ATK_PKG_DESCRIPTION_FILE_IN = $(ATK_PKG_NAME)-pkg-description.in
ATK_PKG_INSTALL_SCRIPT      = $(ATK_PKG_NAME)-pkg-install.sh

ATK_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ATK_PKG_NAME)-package

pkg_basename     = $(ATK_PKG_NAME)-$(ATK_PKG_VERSION)-$(ATK_PKG_ARCH)-$(ATK_PKG_DISTRO_NAME)-$(ATK_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ATK_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no

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
	@mkdir -p $(ATK_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(ATK_PKG)/usr/share/man ]; then \
	  ( cd $(ATK_PKG)/usr/share/man ; \
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
	@mkdir -p $(ATK_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(ATK_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ATK_PKG)/usr/share/gtk-doc/html/$(src_dir_name)
	@( cd $(SRC_DIR)/docs/html ; \
	   cp -a *.html *.css *.png \
	         $(ATK_PKG)/usr/share/gtk-doc/html/$(src_dir_name) ; \
	 )
	@mkdir -p $(ATK_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(ATK_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/$(src_dir_name) $(ATK_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ATK_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(ATK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libatk-?.?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(ATK_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libatk-?.?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libatk-?.?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" atk.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(ATK_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(ATK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ATK_PKG_DESCRIPTION_FILE): $(ATK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ATK_PKG_DESCRIPTION_FILE) $(ATK_PKG_INSTALL_SCRIPT)
	@cp $(ATK_PKG_DESCRIPTION_FILE) $(ATK_PKG)/.DESCRIPTION
	@cp $(ATK_PKG_INSTALL_SCRIPT) $(ATK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ATK_PKG)/.REQUIRES
	@echo "pkgname=$(ATK_PKG_NAME)"                            >  $(ATK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ATK_PKG_VERSION)"                          >> $(ATK_PKG)/.PKGINFO ; \
	 echo "arch=$(ATK_PKG_ARCH)"                               >> $(ATK_PKG)/.PKGINFO ; \
	 echo "distroname=$(ATK_PKG_DISTRO_NAME)"                  >> $(ATK_PKG)/.PKGINFO ; \
	 echo "distrover=$(ATK_PKG_DISTRO_VERSION)"                >> $(ATK_PKG)/.PKGINFO ; \
	 echo "group=$(ATK_PKG_GROUP)"                             >> $(ATK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ATK_PKG_SHORT_DESCRIPTION)\"" >> $(ATK_PKG)/.PKGINFO ; \
	 echo "url=$(ATK_PKG_URL)"                                 >> $(ATK_PKG)/.PKGINFO ; \
	 echo "license=$(ATK_PKG_LICENSE)"                         >> $(ATK_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ATK_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
