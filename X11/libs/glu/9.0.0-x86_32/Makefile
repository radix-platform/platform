
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/glu

REQUIRES           = X11/libs/glu/9.0.0

REQUIRES          += X11/libs/opengl-collection

# ======= __END_OF_REQUIRES__ =======


version            = 9.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/x/glu/glu-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/glu-$(version)
src_dir_name       = glu-$(version)
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
GLU_32_PKG_NAME                = glu-x32
GLU_32_PKG_VERSION             = 9.0.0
GLU_32_PKG_ARCH                = $(TOOLCHAIN)
GLU_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLU_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLU_32_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
GLU_32_PKG_SHORT_DESCRIPTION   = Mesa OpenGL utility library
GLU_32_PKG_URL                 = $(BUG_URL)
GLU_32_PKG_LICENSE             = LGPLv2
GLU_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLU_32_PKG_NAME)-pkg-description
GLU_32_PKG_DESCRIPTION_FILE_IN = $(GLU_32_PKG_NAME)-pkg-description.in
GLU_32_PKG_INSTALL_SCRIPT      = $(GLU_32_PKG_NAME)-pkg-install.sh

GLU_32_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLU_32_PKG_NAME)-package

pkg_basename     = $(GLU_32_PKG_NAME)-$(GLU_32_PKG_VERSION)-$(GLU_32_PKG_ARCH)-$(GLU_32_PKG_DISTRO_NAME)-$(GLU_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GLU_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


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
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GLU_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(GLU_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GLU_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libGLU.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GLU_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libGLU.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libGLU.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" glu.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GLU_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GLU_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GLU_32_PKG_DESCRIPTION_FILE): $(GLU_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLU_32_PKG_DESCRIPTION_FILE) $(GLU_32_PKG_INSTALL_SCRIPT)
	@cp $(GLU_32_PKG_DESCRIPTION_FILE) $(GLU_32_PKG)/.DESCRIPTION
	@cp $(GLU_32_PKG_INSTALL_SCRIPT) $(GLU_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLU_32_PKG)/.REQUIRES
	@echo "pkgname=$(GLU_32_PKG_NAME)"                            >  $(GLU_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLU_32_PKG_VERSION)"                          >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GLU_32_PKG_ARCH)"                               >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLU_32_PKG_DISTRO_NAME)"                  >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLU_32_PKG_DISTRO_VERSION)"                >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "group=$(GLU_32_PKG_GROUP)"                             >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLU_32_PKG_SHORT_DESCRIPTION)\"" >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "url=$(GLU_32_PKG_URL)"                                 >> $(GLU_32_PKG)/.PKGINFO ; \
	 echo "license=$(GLU_32_PKG_LICENSE)"                         >> $(GLU_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLU_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
