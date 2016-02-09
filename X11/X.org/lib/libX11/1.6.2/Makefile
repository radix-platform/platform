
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/X.org/lib/libX11

REQUIRES           = X11/X.org/proto/xproto/7.0.26
REQUIRES          += X11/X.org/proto/kbproto/1.0.6
REQUIRES          += X11/X.org/proto/inputproto/2.3.1
REQUIRES          += X11/X.org/proto/xextproto/7.3.0
REQUIRES          += X11/X.org/proto/xf86bigfontproto/1.2.0
REQUIRES          += X11/X.org/xcb/libxcb/1.11
REQUIRES          += X11/X.org/lib/xtrans/1.3.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.6.2
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/X.org/lib/libX11/libX11-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libX11-$(version)
src_dir_name       = libX11-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

keysym_DB          = $(CURDIR)/key-symbols/XKeysymDB

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xorg

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XORG_PKG_NAME                = libX11
XORG_PKG_VERSION             = 1.6.2
XORG_PKG_ARCH                = $(TOOLCHAIN)
XORG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XORG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XORG_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XORG_PKG_SHORT_DESCRIPTION   = Core X11 protocol client library
XORG_PKG_URL                 = $(BUG_URL)
XORG_PKG_LICENSE             = custom
XORG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XORG_PKG_NAME)-pkg-description
XORG_PKG_DESCRIPTION_FILE_IN = $(XORG_PKG_NAME)-pkg-description.in
XORG_PKG_INSTALL_SCRIPT      = $(XORG_PKG_NAME)-pkg-install.sh

XORG_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XORG_PKG_NAME)-package

pkg_basename     = $(XORG_PKG_NAME)-$(XORG_PKG_VERSION)-$(XORG_PKG_ARCH)-$(XORG_PKG_DISTRO_NAME)-$(XORG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../../build-system/core.mk


env_sysroot = DESTDIR=$(XORG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

CC_FOR_BUILD       = gcc
CFLAGS_FOR_BUILD   = -I/usr/include
CPPFLAGS_FOR_BUILD = -I/usr/include
LDFLAGS_FOR_BUILD  = -L/usr/lib64

env_build = CC_FOR_BUILD=$(CC_FOR_BUILD)             \
            CFLAGS_FOR_BUILD=$(CFLAGS_FOR_BUILD)     \
            CPPFLAGS_FOR_BUILD=$(CPPFLAGS_FOR_BUILD) \
            LDFLAGS_FOR_BUILD=$(LDFLAGS_FOR_BUILD)


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(env_build) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= Fix X11_CFLAGS for BUILD_CC =======
	@( cd $(build_dir)/src/util ; \
	   sed -i "s,^\(X11_CFLAGS = .*\)\(-I.*\),\1-I/usr/include," Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XORG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install XFree86 Key Symbols DB =======
	@mkdir -p $(XORG_PKG)/usr/share/X11
	@cp -a $(keysym_DB) $(XORG_PKG)/usr/share/X11
	# ======= Install Documentation ========
	@rm -f $(XORG_PKG)/usr/share/man/man3/XCompose.3
	@( cd $(XORG_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@( cd $(XORG_PKG)/usr/share/man/man3 ; ln -sf ../man5/Compose.5 XCompose.3 )
	@( cd $(XORG_PKG)/usr/share/man/man5 ; \
	   for file in *.5 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(XORG_PKG)/usr/share/man ]; then \
	  ( cd $(XORG_PKG)/usr/share/man ; \
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
	@mkdir -p $(XORG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(XORG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(XORG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README \
	         $(XORG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(XORG_PKG)/usr/share/doc ; \
	   ln -sf $(src_dir_name) $(XORG_PKG_NAME) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XORG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libX11.la libX11-xcb.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XORG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libX11.la libX11-xcb.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libX11.la libX11-xcb.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" x11.pc x11-xcb.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(XORG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(XORG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(XORG_PKG_DESCRIPTION_FILE): $(XORG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XORG_PKG_DESCRIPTION_FILE) $(XORG_PKG_INSTALL_SCRIPT)
	@cp $(XORG_PKG_DESCRIPTION_FILE) $(XORG_PKG)/.DESCRIPTION
	@cp $(XORG_PKG_INSTALL_SCRIPT) $(XORG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XORG_PKG)/.REQUIRES
	@echo "pkgname=$(XORG_PKG_NAME)"                            >  $(XORG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XORG_PKG_VERSION)"                          >> $(XORG_PKG)/.PKGINFO ; \
	 echo "arch=$(XORG_PKG_ARCH)"                               >> $(XORG_PKG)/.PKGINFO ; \
	 echo "distroname=$(XORG_PKG_DISTRO_NAME)"                  >> $(XORG_PKG)/.PKGINFO ; \
	 echo "distrover=$(XORG_PKG_DISTRO_VERSION)"                >> $(XORG_PKG)/.PKGINFO ; \
	 echo "group=$(XORG_PKG_GROUP)"                             >> $(XORG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XORG_PKG_SHORT_DESCRIPTION)\"" >> $(XORG_PKG)/.PKGINFO ; \
	 echo "url=$(XORG_PKG_URL)"                                 >> $(XORG_PKG)/.PKGINFO ; \
	 echo "license=$(XORG_PKG_LICENSE)"                         >> $(XORG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(XORG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
