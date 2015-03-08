
COMPONENT_TARGETS  = $(HARDWARE_PC64)

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true

CREATE_X86_32_PACKAGE = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/libcaca

REQUIRES           = libs/imlib2/1.4.6
REQUIRES          += libs/slang/2.2.4-x86_32
REQUIRES          += libs/ncurses/5.9-x86_32
REQUIRES          += X11/libs/mesa/10.3.4-x86_32
REQUIRES          += X11/libs/freeglut/2.8.1-x86_32

# ======= __END_OF_REQUIRES__ =======

PYTHON_VERSION = 2.7


version            = 0.99.beta19
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libcaca/libcaca-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcaca-$(version)
src_dir_name       = libcaca-$(version)
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
LIBCACA_32_PKG_NAME                = libcaca-x32
LIBCACA_32_PKG_VERSION             = 0.99.19
LIBCACA_32_PKG_ARCH                = $(TOOLCHAIN)
LIBCACA_32_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCACA_32_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCACA_32_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBCACA_32_PKG_SHORT_DESCRIPTION   = Colour AsCii Art library
LIBCACA_32_PKG_URL                 = $(BUG_URL)
LIBCACA_32_PKG_LICENSE             = WTFPL
LIBCACA_32_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCACA_32_PKG_NAME)-pkg-description
LIBCACA_32_PKG_DESCRIPTION_FILE_IN = $(LIBCACA_32_PKG_NAME)-pkg-description.in
LIBCACA_32_PKG_INSTALL_SCRIPT      = $(LIBCACA_32_PKG_NAME)-pkg-install.sh

LIBCACA_32_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCACA_32_PKG_NAME)-package

pkg_basename      = $(LIBCACA_32_PKG_NAME)-$(LIBCACA_32_PKG_VERSION)-$(LIBCACA_32_PKG_ARCH)-$(LIBCACA_32_PKG_DISTRO_NAME)-$(LIBCACA_32_PKG_DISTRO_VERSION)

pkg_archive       = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature     = $(call sign-name,$(pkg_archive))
pkg_description   = $(call desc-name,$(pkg_archive))
products          = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS     = $(build_target)
BUILD_TARGETS    += $(install_target)

PRODUCT_TARGETS   = $(products)

ROOTFS_TARGETS    = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBCACA_32_PKG)


extra_configure_switches  = --libdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

extra_configure_switches += --bindir=/usr/bin/32

extra_configure_switches += --sysconfdir=/etc

extra_configure_switches += --enable-slang
extra_configure_switches += --enable-ncurses
extra_configure_switches += --enable-x11
extra_configure_switches += --enable-gl
extra_configure_switches += --enable-plugins
extra_configure_switches += --enable-network
extra_configure_switches += --enable-imlib2

extra_configure_switches += --disable-ruby
extra_configure_switches += --disable-csharp
extra_configure_switches += --disable-java
extra_configure_switches += --disable-doc

extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


python_environment  = am_cv_python_version=$(PYTHON_VERSION)
python_environment += am_cv_python_platform=linux2
python_environment += am_cv_python_pythondir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/site-packages

# ======= PYTHON_INCLUDES, PYTHON_LIBS =======
CFLAGS  += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
LDFLAGS += -L$(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/python$(PYTHON_VERSION)/config


TARGET_BIN_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX)
TARGET_LIB_RPATH = /lib$(MULTILIB_X86_32_SUFFIX):/usr/lib$(MULTILIB_X86_32_SUFFIX):/usr/lib/../lib$(MULTILIB_X86_32_SUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET32)          \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBCACA_32_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@rm -rf $(LIBCACA_32_PKG)/usr/include
	@rm -rf $(LIBCACA_32_PKG)/usr/share
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBCACA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcaca++.la libcaca.la ; \
	 )
	@( cd $(LIBCACA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX)/caca ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgl_plugin.la libx11_plugin.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBCACA_32_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcaca++.la libcaca.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcaca++.la libcaca.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/caca ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgl_plugin.la libx11_plugin.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgl_plugin.la libx11_plugin.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(MULTILIB_X86_32_SUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" caca++.pc caca.pc ; \
	 )
	# ======= tune imlib2-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin/32 ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" caca-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCACA_32_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBCACA_32_PKG)/usr/bin/32 ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBCACA_32_PKG)/usr/lib$(MULTILIB_X86_32_SUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBCACA_32_PKG_DESCRIPTION_FILE): $(LIBCACA_32_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCACA_32_PKG_DESCRIPTION_FILE) $(LIBCACA_32_PKG_INSTALL_SCRIPT)
	@cp $(LIBCACA_32_PKG_DESCRIPTION_FILE) $(LIBCACA_32_PKG)/.DESCRIPTION
	@cp $(LIBCACA_32_PKG_INSTALL_SCRIPT) $(LIBCACA_32_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCACA_32_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCACA_32_PKG_NAME)"                            >  $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCACA_32_PKG_VERSION)"                          >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCACA_32_PKG_ARCH)"                               >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCACA_32_PKG_DISTRO_NAME)"                  >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCACA_32_PKG_DISTRO_VERSION)"                >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCACA_32_PKG_GROUP)"                             >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCACA_32_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCACA_32_PKG_URL)"                                 >> $(LIBCACA_32_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCACA_32_PKG_LICENSE)"                         >> $(LIBCACA_32_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBCACA_32_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
