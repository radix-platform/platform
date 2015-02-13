
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/glu

REQUIRES           = X11/libs/mesa/10.3.4


version            = 9.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/glu/glu-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glu-$(version)
src_dir_name       = glu-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/LICENSE


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLU_PKG_NAME                = glu
GLU_PKG_VERSION             = 9.0.0
GLU_PKG_ARCH                = $(TOOLCHAIN)
GLU_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLU_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLU_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
GLU_PKG_SHORT_DESCRIPTION   = Mesa OpenGL utility library
GLU_PKG_URL                 = $(BUG_URL)
GLU_PKG_LICENSE             = LGPLv2
GLU_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLU_PKG_NAME)-pkg-description
GLU_PKG_DESCRIPTION_FILE_IN = $(GLU_PKG_NAME)-pkg-description.in
GLU_PKG_INSTALL_SCRIPT      = $(GLU_PKG_NAME)-pkg-install.sh

GLU_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLU_PKG_NAME)-package

pkg_basename     = $(GLU_PKG_NAME)-$(GLU_PKG_VERSION)-$(GLU_PKG_ARCH)-$(GLU_PKG_DISTRO_NAME)-$(GLU_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(GLU_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(GLU_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(GLU_PKG)/usr/share/man ]; then \
	  ( cd $(GLU_PKG)/usr/share/man ; \
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
	@mkdir -p $(GLU_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(GLU_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GLU_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(GLU_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLU_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GLU_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libGLU.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GLU_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libGLU.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libGLU.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" glu.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GLU_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GLU_PKG_DESCRIPTION_FILE): $(GLU_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLU_PKG_DESCRIPTION_FILE) $(GLU_PKG_INSTALL_SCRIPT)
	@cp $(GLU_PKG_DESCRIPTION_FILE) $(GLU_PKG)/.DESCRIPTION
	@cp $(GLU_PKG_INSTALL_SCRIPT) $(GLU_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLU_PKG)/.REQUIRES
	@echo "pkgname=$(GLU_PKG_NAME)"                            >  $(GLU_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLU_PKG_VERSION)"                          >> $(GLU_PKG)/.PKGINFO ; \
	 echo "arch=$(GLU_PKG_ARCH)"                               >> $(GLU_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLU_PKG_DISTRO_NAME)"                  >> $(GLU_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLU_PKG_DISTRO_VERSION)"                >> $(GLU_PKG)/.PKGINFO ; \
	 echo "group=$(GLU_PKG_GROUP)"                             >> $(GLU_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLU_PKG_SHORT_DESCRIPTION)\"" >> $(GLU_PKG)/.PKGINFO ; \
	 echo "url=$(GLU_PKG_URL)"                                 >> $(GLU_PKG)/.PKGINFO ; \
	 echo "license=$(GLU_PKG_LICENSE)"                         >> $(GLU_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLU_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
