
COMPONENT_TARGETS  = $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/hal/dri2

REQUIRES           = X11/libs/libdrm/2.4.68
REQUIRES          += X11/X.org/proto/dri2proto/2.8
REQUIRES          += X11/X.org/lib/libXext/1.3.3
REQUIRES          += X11/X.org/lib/libXfixes/5.0.1

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/hal/dri2/libdri2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libdri2-$(version)
src_dir_name       = libdri2-$(version)
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
LIBDRI2_PKG_NAME                = libdri2
LIBDRI2_PKG_VERSION             = 1.0.0
LIBDRI2_PKG_ARCH                = $(TOOLCHAIN)
LIBDRI2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBDRI2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBDRI2_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBDRI2_PKG_SHORT_DESCRIPTION   = library for the DRI2 extension
LIBDRI2_PKG_URL                 = $(BUG_URL)
LIBDRI2_PKG_LICENSE             = custom
LIBDRI2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBDRI2_PKG_NAME)-pkg-description
LIBDRI2_PKG_DESCRIPTION_FILE_IN = $(LIBDRI2_PKG_NAME)-pkg-description.in
LIBDRI2_PKG_INSTALL_SCRIPT      = $(LIBDRI2_PKG_NAME)-pkg-install.sh

LIBDRI2_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBDRI2_PKG_NAME)-package

pkg_basename     = $(LIBDRI2_PKG_NAME)-$(LIBDRI2_PKG_VERSION)-$(LIBDRI2_PKG_ARCH)-$(LIBDRI2_PKG_DISTRO_NAME)-$(LIBDRI2_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBDRI2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBDRI2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBDRI2_PKG)/usr/share/man ]; then \
	  ( cd $(LIBDRI2_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBDRI2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBDRI2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBDRI2_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/README \
	       $(LIBDRI2_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBDRI2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBDRI2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdri2.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBDRI2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdri2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdri2.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dri2.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBDRI2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBDRI2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBDRI2_PKG_DESCRIPTION_FILE): $(LIBDRI2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBDRI2_PKG_DESCRIPTION_FILE) $(LIBDRI2_PKG_INSTALL_SCRIPT)
	@cp $(LIBDRI2_PKG_DESCRIPTION_FILE) $(LIBDRI2_PKG)/.DESCRIPTION
	@cp $(LIBDRI2_PKG_INSTALL_SCRIPT) $(LIBDRI2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBDRI2_PKG)/.REQUIRES
	@echo "pkgname=$(LIBDRI2_PKG_NAME)"                            >  $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBDRI2_PKG_VERSION)"                          >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBDRI2_PKG_ARCH)"                               >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBDRI2_PKG_DISTRO_NAME)"                  >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBDRI2_PKG_DISTRO_VERSION)"                >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "group=$(LIBDRI2_PKG_GROUP)"                             >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBDRI2_PKG_SHORT_DESCRIPTION)\"" >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "url=$(LIBDRI2_PKG_URL)"                                 >> $(LIBDRI2_PKG)/.PKGINFO ; \
	 echo "license=$(LIBDRI2_PKG_LICENSE)"                         >> $(LIBDRI2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBDRI2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
