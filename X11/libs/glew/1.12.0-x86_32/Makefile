
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/glew

REQUIRES           = X11/libs/glew/1.12.0
REQUIRES          += X11/libs/glu/9.0.0-x86_32


version            = 1.12.0
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
GLEW_32_PKG_NAME                = glew-x32
GLEW_32_PKG_VERSION             = 1.12.0
GLEW_32_PKG_ARCH                = $(TOOLCHAIN)
GLEW_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLEW_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLEW_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GLEW_32_PKG_SHORT_DESCRIPTION   = OpenGL Extension Wrangler Library
GLEW_32_PKG_URL                 = $(BUG_URL)
GLEW_32_PKG_LICENSE             = custom
GLEW_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLEW_32_PKG_NAME)-pkg-description
GLEW_32_PKG_DESCRIPTION_FILE_IN = $(GLEW_32_PKG_NAME)-pkg-description.in
GLEW_32_PKG_INSTALL_SCRIPT      = $(GLEW_32_PKG_NAME)-pkg-install.sh

GLEW_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLEW_32_PKG_NAME)-package

pkg_basename     = $(GLEW_32_PKG_NAME)-$(GLEW_32_PKG_VERSION)-$(GLEW_32_PKG_ARCH)-$(GLEW_32_PKG_DISTRO_NAME)-$(GLEW_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GLEW_32_PKG)


configure_options  = CC="$(CC) --sysroot=$(TARGET_DEST_DIR)"
configure_options += LD="$(CC) --sysroot=$(TARGET_DEST_DIR)"
configure_options += POPT="$(CFLAGS)"
configure_options += LDFLAGS.EXTRA="$(LDFLAGS) -lGLU"
configure_options += GLEW_NO_GLU="false"
configure_options += STRIP=""
configure_options += BINDIR="/usr/bin/32"
configure_options += LIBDIR="/usr/lib$(MULTILIB_X86_32_SUFFIX)"
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
	@mkdir -p $(GLEW_32_PKG)
	@cd $(SRC_DIR) && $(MAKE) $(BUILD_ENVIRONMENT) install.all  $(configure_options) $(env_sysroot)
	@( cd $(GLEW_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; chmod a+x libGLEW.so.?.??.? libGLEWmx.so.?.??.? )
	@rm -rf $(GLEW_32_PKG)/usr/include
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GLEW_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" glew.pc glewmx.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GLEW_32_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GLEW_32_PKG_DESCRIPTION_FILE): $(GLEW_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLEW_32_PKG_DESCRIPTION_FILE) $(GLEW_32_PKG_INSTALL_SCRIPT)
	@cp $(GLEW_32_PKG_DESCRIPTION_FILE) $(GLEW_32_PKG)/.DESCRIPTION
	@cp $(GLEW_32_PKG_INSTALL_SCRIPT) $(GLEW_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLEW_32_PKG)/.REQUIRES
	@echo "pkgname=$(GLEW_32_PKG_NAME)"                            >  $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLEW_32_PKG_VERSION)"                          >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GLEW_32_PKG_ARCH)"                               >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLEW_32_PKG_DISTRO_NAME)"                  >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLEW_32_PKG_DISTRO_VERSION)"                >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "group=$(GLEW_32_PKG_GROUP)"                             >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLEW_32_PKG_SHORT_DESCRIPTION)\"" >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "url=$(GLEW_32_PKG_URL)"                                 >> $(GLEW_32_PKG)/.PKGINFO ; \
	 echo "license=$(GLEW_32_PKG_LICENSE)"                         >> $(GLEW_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLEW_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
