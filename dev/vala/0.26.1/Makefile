
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


SOURCE_REQUIRES    = sources/GNOME/core/vala

REQUIRES           = libs/glib2/2.40.0
REQUIRES          += libs/libxslt/1.1.28


version            = 0.26.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNOME/core/vala/vala-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/vala-$(version)
src_dir_name       = vala-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
VALA_PKG_NAME                = vala
VALA_PKG_VERSION             = 0.26.1
VALA_PKG_ARCH                = $(TOOLCHAIN)
VALA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
VALA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
VALA_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
VALA_PKG_SHORT_DESCRIPTION   = Vala Compiler for GObject
VALA_PKG_URL                 = $(BUG_URL)
VALA_PKG_LICENSE             = LGPLv2.1
VALA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(VALA_PKG_NAME)-pkg-description
VALA_PKG_DESCRIPTION_FILE_IN = $(VALA_PKG_NAME)-pkg-description.in
VALA_PKG_INSTALL_SCRIPT      = $(VALA_PKG_NAME)-pkg-install.sh

VALA_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(VALA_PKG_NAME)-package

pkg_basename     = $(VALA_PKG_NAME)-$(VALA_PKG_VERSION)-$(VALA_PKG_ARCH)-$(VALA_PKG_DISTRO_NAME)-$(VALA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(VALA_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(VALA_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(VALA_PKG)/usr/share/man ]; then \
	  ( cd $(VALA_PKG)/usr/share/man ; \
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
	@mkdir -p $(VALA_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(VALA_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(VALA_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL MAINTAINERS NEWS README THANKS \
	         $(VALA_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../devhelp/books/vala-$(shell echo $(version) | cut -f1,2 -d'.')\
	           $(VALA_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(VALA_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(VALA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvala-?.??.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(VALA_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvala-?.??.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvala-?.??.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvala-?.??.pc vapigen-?.??.pc ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" vala-gen-introspect-?.?? ; \
	 )
	# ======= Strip binaries =======
	@( cd $(VALA_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(VALA_PKG_DESCRIPTION_FILE): $(VALA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(VALA_PKG_DESCRIPTION_FILE) $(VALA_PKG_INSTALL_SCRIPT)
	@cp $(VALA_PKG_DESCRIPTION_FILE) $(VALA_PKG)/.DESCRIPTION
	@cp $(VALA_PKG_INSTALL_SCRIPT) $(VALA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(VALA_PKG)/.REQUIRES
	@echo "pkgname=$(VALA_PKG_NAME)"                            >  $(VALA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(VALA_PKG_VERSION)"                          >> $(VALA_PKG)/.PKGINFO ; \
	 echo "arch=$(VALA_PKG_ARCH)"                               >> $(VALA_PKG)/.PKGINFO ; \
	 echo "distroname=$(VALA_PKG_DISTRO_NAME)"                  >> $(VALA_PKG)/.PKGINFO ; \
	 echo "distrover=$(VALA_PKG_DISTRO_VERSION)"                >> $(VALA_PKG)/.PKGINFO ; \
	 echo "group=$(VALA_PKG_GROUP)"                             >> $(VALA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(VALA_PKG_SHORT_DESCRIPTION)\"" >> $(VALA_PKG)/.PKGINFO ; \
	 echo "url=$(VALA_PKG_URL)"                                 >> $(VALA_PKG)/.PKGINFO ; \
	 echo "license=$(VALA_PKG_LICENSE)"                         >> $(VALA_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(VALA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
