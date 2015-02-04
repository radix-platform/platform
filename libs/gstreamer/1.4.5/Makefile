
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/gstreamer

REQUIRES           = libs/glib2/2.40.0
REQUIRES          += libs/libxml2/2.9.1


version            = 1.4.5
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/gstreamer/gstreamer-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/$(src_dir_name)
src_dir_name       = gstreamer-$(version)
doc_dir_name       = gstreamer-$(version)
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
GSTREAMER_PKG_NAME                = gstreamer
GSTREAMER_PKG_VERSION             = 1.4.5
GSTREAMER_PKG_ARCH                = $(TOOLCHAIN)
GSTREAMER_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GSTREAMER_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GSTREAMER_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
GSTREAMER_PKG_SHORT_DESCRIPTION   = streaming multimedia framework
GSTREAMER_PKG_URL                 = $(BUG_URL)
GSTREAMER_PKG_LICENSE             = LGPLv2
GSTREAMER_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GSTREAMER_PKG_NAME)-pkg-description
GSTREAMER_PKG_DESCRIPTION_FILE_IN = $(GSTREAMER_PKG_NAME)-pkg-description.in
GSTREAMER_PKG_INSTALL_SCRIPT      = $(GSTREAMER_PKG_NAME)-pkg-install.sh

GSTREAMER_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GSTREAMER_PKG_NAME)-package

pkg_basename     = $(GSTREAMER_PKG_NAME)-$(GSTREAMER_PKG_VERSION)-$(GSTREAMER_PKG_ARCH)-$(GSTREAMER_PKG_DISTRO_NAME)-$(GSTREAMER_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GSTREAMER_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --disable-debug
extra_configure_switches += --disable-gst-debug
extra_configure_switches += --enable-glib-asserts=no
extra_configure_switches += --with-package-name='gstreamer'
extra_configure_switches += --with-package-origin='http://gstreamer.freedesktop.org'

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --enable-gtk-doc=no

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@( cd $(build_dir) ; \
	   sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GSTREAMER_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(GSTREAMER_PKG)/usr/share/man ]; then \
	  ( cd $(GSTREAMER_PKG)/usr/share/man ; \
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
	@mkdir -p $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer{,-libs,-plugins}-1.0
	@( cd $(SRC_DIR)/docs/gst/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer-1.0 ; \
	 )
	@( cd $(SRC_DIR)/docs/libs/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer-libs-1.0 ; \
	 )
	@( cd $(SRC_DIR)/docs/plugins/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer-plugins-1.0 ; \
	 )
	@mkdir -p $(GSTREAMER_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GSTREAMER_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL MAINTAINERS NEWS README RELEASE \
	         $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@mkdir -p $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html
	@ln -sf ../../../gtk-doc/html/gstreamer-1.0 $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html/gstreamer-1.0
	@ln -sf ../../../gtk-doc/html/gstreamer-libs-1.0 $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html/gstreamer-libs-1.0
	@ln -sf ../../../gtk-doc/html/gstreamer-plugins-1.0 $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html/gstreamer-plugins-1.0
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GSTREAMER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstbase-?.?.la libgstcheck-?.?.la      \
	                                    libgstcontroller-?.?.la libgstnet-?.?.la  \
	                                    libgstreamer-?.?.la                     ; \
	 )
	@( cd $(GSTREAMER_PKG)/usr/lib$(LIBSUFFIX)/gstreamer-?.? ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstcoreelements.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GSTREAMER_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstbase-?.?.la libgstcheck-?.?.la      \
	                                            libgstcontroller-?.?.la libgstnet-?.?.la  \
	                                            libgstreamer-?.?.la                     ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstbase-?.?.la libgstcheck-?.?.la      \
	                                              libgstcontroller-?.?.la libgstnet-?.?.la  \
	                                              libgstreamer-?.?.la                     ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gstreamer-?.? ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstcoreelements.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstcoreelements.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gstreamer-?.?.pc gstreamer-base-?.?.pc              \
	                                            gstreamer-check-?.?.pc gstreamer-controller-?.?.pc  \
	                                            gstreamer-net-?.?.pc                              ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GSTREAMER_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GSTREAMER_PKG_DESCRIPTION_FILE): $(GSTREAMER_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GSTREAMER_PKG_DESCRIPTION_FILE) $(GSTREAMER_PKG_INSTALL_SCRIPT)
	@cp $(GSTREAMER_PKG_DESCRIPTION_FILE) $(GSTREAMER_PKG)/.DESCRIPTION
	@cp $(GSTREAMER_PKG_INSTALL_SCRIPT) $(GSTREAMER_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GSTREAMER_PKG)/.REQUIRES
	@echo "pkgname=$(GSTREAMER_PKG_NAME)"                            >  $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GSTREAMER_PKG_VERSION)"                          >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "arch=$(GSTREAMER_PKG_ARCH)"                               >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "distroname=$(GSTREAMER_PKG_DISTRO_NAME)"                  >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "distrover=$(GSTREAMER_PKG_DISTRO_VERSION)"                >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "group=$(GSTREAMER_PKG_GROUP)"                             >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GSTREAMER_PKG_SHORT_DESCRIPTION)\"" >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "url=$(GSTREAMER_PKG_URL)"                                 >> $(GSTREAMER_PKG)/.PKGINFO ; \
	 echo "license=$(GSTREAMER_PKG_LICENSE)"                         >> $(GSTREAMER_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GSTREAMER_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
