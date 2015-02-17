
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


SOURCE_REQUIRES    = sources/packages/l/libcaca

REQUIRES           = libs/imlib2/1.4.6
REQUIRES          += libs/slang/2.2.4
REQUIRES          += libs/ncurses/5.9
REQUIRES          += X11/libs/mesa/10.3.4
REQUIRES          += X11/libs/freeglut/2.8.1

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
LIBCACA_PKG_NAME                = libcaca
LIBCACA_PKG_VERSION             = 0.99.19
LIBCACA_PKG_ARCH                = $(TOOLCHAIN)
LIBCACA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCACA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCACA_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBCACA_PKG_SHORT_DESCRIPTION   = Colour AsCii Art library
LIBCACA_PKG_URL                 = $(BUG_URL)
LIBCACA_PKG_LICENSE             = WTFPL
LIBCACA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCACA_PKG_NAME)-pkg-description
LIBCACA_PKG_DESCRIPTION_FILE_IN = $(LIBCACA_PKG_NAME)-pkg-description.in
LIBCACA_PKG_INSTALL_SCRIPT      = $(LIBCACA_PKG_NAME)-pkg-install.sh

LIBCACA_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCACA_PKG_NAME)-package

pkg_basename     = $(LIBCACA_PKG_NAME)-$(LIBCACA_PKG_VERSION)-$(LIBCACA_PKG_ARCH)-$(LIBCACA_PKG_DISTRO_NAME)-$(LIBCACA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBCACA_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man

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
python_environment += am_cv_python_pythondir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += am_cv_python_pyexecdir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages

# ======= PYTHON_INCLUDES, PYTHON_LIBS =======
CFLAGS  += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
LDFLAGS += -L$(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/config


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
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBCACA_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBCACA_PKG)/usr/share/man ]; then \
	  ( cd $(LIBCACA_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBCACA_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBCACA_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBCACA_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* NEWS NOTES README THANKS \
	         $(LIBCACA_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBCACA_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBCACA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcaca++.la libcaca.la ; \
	 )
	@( cd $(LIBCACA_PKG)/usr/lib$(LIBSUFFIX)/caca ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgl_plugin.la libx11_plugin.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(LIBCACA_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcaca++.la libcaca.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcaca++.la libcaca.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/caca ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgl_plugin.la libx11_plugin.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgl_plugin.la libx11_plugin.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" caca++.pc caca.pc ; \
	 )
	# ======= tune caca-config script to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" caca-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCACA_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBCACA_PKG_DESCRIPTION_FILE): $(LIBCACA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCACA_PKG_DESCRIPTION_FILE) $(LIBCACA_PKG_INSTALL_SCRIPT)
	@cp $(LIBCACA_PKG_DESCRIPTION_FILE) $(LIBCACA_PKG)/.DESCRIPTION
	@cp $(LIBCACA_PKG_INSTALL_SCRIPT) $(LIBCACA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCACA_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCACA_PKG_NAME)"                            >  $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCACA_PKG_VERSION)"                          >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCACA_PKG_ARCH)"                               >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCACA_PKG_DISTRO_NAME)"                  >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCACA_PKG_DISTRO_VERSION)"                >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCACA_PKG_GROUP)"                             >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCACA_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCACA_PKG_URL)"                                 >> $(LIBCACA_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCACA_PKG_LICENSE)"                         >> $(LIBCACA_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBCACA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
