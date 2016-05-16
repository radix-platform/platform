
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/x/freeglut

REQUIRES           = X11/libs/freeglut/2.8.1
REQUIRES          += X11/libs/glu/9.0.0-x86_32
REQUIRES          += X11/X.org/lib/libXi/1.7.6-x86_32
REQUIRES          += X11/X.org/lib/libXrandr/1.4.2-x86_32

# ======= __END_OF_REQUIRES__ =======


version            = 2.8.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/x/freeglut/freeglut-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/freeglut-$(version)
src_dir_name       = freeglut-$(version)
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
GLUT_32_PKG_NAME                = freeglut-x32
GLUT_32_PKG_VERSION             = 2.8.1
GLUT_32_PKG_ARCH                = $(TOOLCHAIN)
GLUT_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLUT_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLUT_32_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
GLUT_32_PKG_SHORT_DESCRIPTION   = alternative GLUT library
GLUT_32_PKG_URL                 = $(BUG_URL)
GLUT_32_PKG_LICENSE             = MIT
GLUT_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLUT_32_PKG_NAME)-pkg-description
GLUT_32_PKG_DESCRIPTION_FILE_IN = $(GLUT_32_PKG_NAME)-pkg-description.in
GLUT_32_PKG_INSTALL_SCRIPT      = $(GLUT_32_PKG_NAME)-pkg-install.sh

GLUT_32_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLUT_32_PKG_NAME)-package

pkg_basename     = $(GLUT_32_PKG_NAME)-$(GLUT_32_PKG_VERSION)-$(GLUT_32_PKG_ARCH)-$(GLUT_32_PKG_DISTRO_NAME)-$(GLUT_32_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot  = DESTDIR=$(GLUT_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --disable-dependency-tracking

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
	@mkdir -p $(GLUT_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -rf $(GLUT_32_PKG)/usr/include
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GLUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libglut.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLUT_32_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libglut.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libglut.la ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GLUT_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GLUT_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GLUT_32_PKG_DESCRIPTION_FILE): $(GLUT_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLUT_32_PKG_DESCRIPTION_FILE) $(GLUT_32_PKG_INSTALL_SCRIPT)
	@cp $(GLUT_32_PKG_DESCRIPTION_FILE) $(GLUT_32_PKG)/.DESCRIPTION
	@cp $(GLUT_32_PKG_INSTALL_SCRIPT) $(GLUT_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLUT_32_PKG)/.REQUIRES
	@echo "pkgname=$(GLUT_32_PKG_NAME)"                            >  $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLUT_32_PKG_VERSION)"                          >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "arch=$(GLUT_32_PKG_ARCH)"                               >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLUT_32_PKG_DISTRO_NAME)"                  >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLUT_32_PKG_DISTRO_VERSION)"                >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "group=$(GLUT_32_PKG_GROUP)"                             >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLUT_32_PKG_SHORT_DESCRIPTION)\"" >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "url=$(GLUT_32_PKG_URL)"                                 >> $(GLUT_32_PKG)/.PKGINFO ; \
	 echo "license=$(GLUT_32_PKG_LICENSE)"                         >> $(GLUT_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GLUT_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
