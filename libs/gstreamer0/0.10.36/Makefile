
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
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


SOURCE_REQUIRES    = sources/packages/x/gstreamer
SOURCE_REQUIRES   += sources/hal/omap543x/glsdk/gstreamer0.10

REQUIRES           = libs/glib2/2.48.0
REQUIRES          += libs/libxml2/2.9.3

# ======= __END_OF_REQUIRES__ =======


version            = 0.10.36
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
tar_xz_archive     = $(SRC_PACKAGE_PATH)/hal/omap543x/glsdk/gstreamer0.10/gstreamer-ti-$(version).tar.xz
else
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/x/gstreamer/gstreamer-$(version).tar.xz
endif
SRC_ARCHIVE        = $(tar_xz_archive)

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
src_dir_name       = gstreamer-ti-$(version)
else
src_dir_name       = gstreamer-$(version)
endif
SRC_DIR            = $(TARGET_BUILD_DIR)/$(src_dir_name)

doc_dir_name       = gstreamer0-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
PATCHES = PATCHES.omap543x
else
PATCHES = PATCHES
endif

BISON_MAJOR_VERSION = $(shell bison --version | grep ^bison | sed 's/^.* //g' | cut -f 1 -d'.' )

ifeq ($(BISON_MAJOR_VERSION),3)
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
PATCHES = PATCHES.omap543x.bison3
else
OPT_PATCHES = PATCHES.bison3
endif
endif

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GSTREAMER_PKG_NAME                = gstreamer0
GSTREAMER_PKG_VERSION             = 0.10.36
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
extra_configure_switches += --disable-dependency-tracking

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


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
ifeq ($(BISON_MAJOR_VERSION),3)
	$(call apply-opt-patches, $(SRC_DIR))
endif
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
	@( cd $(SRC_DIR) ; ./autogen.sh ; make distclean )
endif
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
	@mkdir -p $(GSTREAMER_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
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
ifneq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
	# ======= TI GLSDK gstreamer doesn't have HTML Documentation =======
else
	@mkdir -p $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer{,-libs,-plugins}-0.10
	@( cd $(SRC_DIR)/docs/gst/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer-0.10 ; \
	 )
	@( cd $(SRC_DIR)/docs/libs/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer-libs-0.10 ; \
	 )
	@( cd $(SRC_DIR)/docs/plugins/html ; \
	   cp -a *.html *.css *.png \
	         $(GSTREAMER_PKG)/usr/share/gtk-doc/html/gstreamer-plugins-0.10 ; \
	 )
endif
	@mkdir -p $(GSTREAMER_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GSTREAMER_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL MAINTAINERS NEWS README RELEASE \
	         $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
ifeq ($(filter $(HARDWARE),$(HARDWARE_OMAP5UEVM) $(HARDWARE_DRA7XXEVM)),)
	@mkdir -p $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html
	@ln -sf ../../../gtk-doc/html/gstreamer-0.10 $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html/gstreamer-0.10
	@ln -sf ../../../gtk-doc/html/gstreamer-libs-0.10 $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html/gstreamer-libs-0.10
	@ln -sf ../../../gtk-doc/html/gstreamer-plugins-0.10 $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)/html/gstreamer-plugins-0.10
endif
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GSTREAMER_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GSTREAMER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstbase-?.??.la libgstcheck-?.??.la               \
	                                    libgstcontroller-?.??.la libgstdataprotocol-?.??.la  \
	                                    libgstnet-?.??.la libgstreamer-?.??.la             ; \
	 )
	@( cd $(GSTREAMER_PKG)/usr/lib$(LIBSUFFIX)/gstreamer-?.?? ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgstcoreelements.la libgstcoreindexers.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GSTREAMER_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstbase-?.??.la libgstcheck-?.??.la               \
	                                            libgstcontroller-?.??.la libgstdataprotocol-?.??.la  \
	                                            libgstnet-?.??.la libgstreamer-?.??.la             ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstbase-?.??.la libgstcheck-?.??.la               \
	                                              libgstcontroller-?.??.la libgstdataprotocol-?.??.la  \
	                                              libgstnet-?.??.la libgstreamer-?.??.la             ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gstreamer-?.?? ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgstcoreelements.la libgstcoreindexers.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgstcoreelements.la libgstcoreindexers.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gstreamer-?.??.pc gstreamer-base-?.??.pc               \
	                                            gstreamer-check-?.??.pc gstreamer-controller-?.??.pc   \
	                                            gstreamer-dataprotocol-?.??.pc gstreamer-net-?.??.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GSTREAMER_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GSTREAMER_PKG)/usr ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GSTREAMER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
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
	@$(PSEUDO) sh -c "cd $(GSTREAMER_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
