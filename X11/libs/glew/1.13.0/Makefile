
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/glew

REQUIRES           = X11/libs/glu/9.0.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.13.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/glew/glew-$(version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glew-$(version)
src_dir_name       = glew-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLEW_PKG_NAME                = glew
GLEW_PKG_VERSION             = 1.13.0
GLEW_PKG_ARCH                = $(TOOLCHAIN)
GLEW_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLEW_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLEW_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
GLEW_PKG_SHORT_DESCRIPTION   = OpenGL Extension Wrangler Library
GLEW_PKG_URL                 = $(BUG_URL)
GLEW_PKG_LICENSE             = custom
GLEW_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLEW_PKG_NAME)-pkg-description
GLEW_PKG_DESCRIPTION_FILE_IN = $(GLEW_PKG_NAME)-pkg-description.in
GLEW_PKG_INSTALL_SCRIPT      = $(GLEW_PKG_NAME)-pkg-install.sh

GLEW_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLEW_PKG_NAME)-package

pkg_basename     = $(GLEW_PKG_NAME)-$(GLEW_PKG_VERSION)-$(GLEW_PKG_ARCH)-$(GLEW_PKG_DISTRO_NAME)-$(GLEW_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(GLEW_PKG)


configure_options  = CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
configure_options += LD="$(CC) --sysroot=$(TARGET_DEST_DIR)"
configure_options += POPT="$(CFLAGS)"
configure_options += LDFLAGS.EXTRA="$(LDFLAGS) -lGLU"
configure_options += GLEW_NO_GLU="false"
configure_options += STRIP=""
configure_options += BINDIR="/usr/bin"
configure_options += LIBDIR="/usr/lib$(LIBSUFFIX)"
configure_options += INCDIR="/usr/include/GL"


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i "s,-DGLEW_NO_GLU,,g" Makefile ; \
	   sed -i "s,-s ,,g" Makefile ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) $(configure_options)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLEW_PKG)
	@cd $(SRC_DIR) && $(MAKE) $(BUILD_ENVIRONMENT) install.all  $(configure_options) $(env_sysroot)
	@( cd $(GLEW_PKG)/usr/lib$(LIBSUFFIX) ; chmod a+x libGLEW.so.?.??.? libGLEWmx.so.?.??.? )
	# ======= Install Documentation =======
	@if [ -d $(GLEW_PKG)/usr/share/man ]; then \
	  ( cd $(GLEW_PKG)/usr/share/man ; \
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
	@mkdir -p $(GLEW_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/LICENSE.txt \
	       $(GLEW_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GLEW_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   cp -a LICENSE.txt README.txt TODO.txt \
	         $(GLEW_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/*.{html,css,jpg,png,txt} \
	         $(GLEW_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GLEW_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLEW_PKG))
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" glew.pc glewmx.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GLEW_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GLEW_PKG_DESCRIPTION_FILE): $(GLEW_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLEW_PKG_DESCRIPTION_FILE) $(GLEW_PKG_INSTALL_SCRIPT)
	@cp $(GLEW_PKG_DESCRIPTION_FILE) $(GLEW_PKG)/.DESCRIPTION
	@cp $(GLEW_PKG_INSTALL_SCRIPT) $(GLEW_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLEW_PKG)/.REQUIRES
	@echo "pkgname=$(GLEW_PKG_NAME)"                            >  $(GLEW_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLEW_PKG_VERSION)"                          >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "arch=$(GLEW_PKG_ARCH)"                               >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLEW_PKG_DISTRO_NAME)"                  >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLEW_PKG_DISTRO_VERSION)"                >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "group=$(GLEW_PKG_GROUP)"                             >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLEW_PKG_SHORT_DESCRIPTION)\"" >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "url=$(GLEW_PKG_URL)"                                 >> $(GLEW_PKG)/.PKGINFO ; \
	 echo "license=$(GLEW_PKG_LICENSE)"                         >> $(GLEW_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLEW_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
