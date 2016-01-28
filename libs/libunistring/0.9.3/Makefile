
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_VIP1830)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/libunistring

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libunistring/libunistring-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libunistring-$(version)
src_dir_name       = libunistring-$(version)
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
LIBUNISTR_PKG_NAME                = libunistring
LIBUNISTR_PKG_VERSION             = 0.9.3
LIBUNISTR_PKG_ARCH                = $(TOOLCHAIN)
LIBUNISTR_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBUNISTR_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBUNISTR_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBUNISTR_PKG_SHORT_DESCRIPTION   = GNU Unicode string library
LIBUNISTR_PKG_URL                 = $(BUG_URL)
LIBUNISTR_PKG_LICENSE             = GPLv2
LIBUNISTR_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBUNISTR_PKG_NAME)-pkg-description
LIBUNISTR_PKG_DESCRIPTION_FILE_IN = $(LIBUNISTR_PKG_NAME)-pkg-description.in
LIBUNISTR_PKG_INSTALL_SCRIPT      = $(LIBUNISTR_PKG_NAME)-pkg-install.sh

LIBUNISTR_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBUNISTR_PKG_NAME)-package

pkg_basename     = $(LIBUNISTR_PKG_NAME)-$(LIBUNISTR_PKG_VERSION)-$(LIBUNISTR_PKG_ARCH)-$(LIBUNISTR_PKG_DISTRO_NAME)-$(LIBUNISTR_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBUNISTR_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --disable-rpath
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
	@mkdir -p $(LIBUNISTR_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(LIBUNISTR_PKG)/usr/share/info/dir
	@gzip -9 $(LIBUNISTR_PKG)/usr/share/info/*
	@if [ -d $(LIBUNISTR_PKG)/usr/share/man ]; then \
	  ( cd $(LIBUNISTR_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBUNISTR_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBUNISTR_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBUNISTR_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBUNISTR_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(LIBUNISTR_PKG)/usr/share/doc/$(src_dir_name) ; \
	   find . -type f | xargs mv -t html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BUGS COPYING* DEPENDENCIES HACKING INSTALL NEWS README* THANKS \
	         $(LIBUNISTR_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBUNISTR_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBUNISTR_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libunistring.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBUNISTR_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libunistring.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libunistring.la \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBUNISTR_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBUNISTR_PKG_DESCRIPTION_FILE): $(LIBUNISTR_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBUNISTR_PKG_DESCRIPTION_FILE) $(LIBUNISTR_PKG_INSTALL_SCRIPT)
	@cp $(LIBUNISTR_PKG_DESCRIPTION_FILE) $(LIBUNISTR_PKG)/.DESCRIPTION
	@cp $(LIBUNISTR_PKG_INSTALL_SCRIPT) $(LIBUNISTR_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBUNISTR_PKG)/.REQUIRES
	@echo "pkgname=$(LIBUNISTR_PKG_NAME)"                            >  $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBUNISTR_PKG_VERSION)"                          >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBUNISTR_PKG_ARCH)"                               >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBUNISTR_PKG_DISTRO_NAME)"                  >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBUNISTR_PKG_DISTRO_VERSION)"                >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "group=$(LIBUNISTR_PKG_GROUP)"                             >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBUNISTR_PKG_SHORT_DESCRIPTION)\"" >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "url=$(LIBUNISTR_PKG_URL)"                                 >> $(LIBUNISTR_PKG)/.PKGINFO ; \
	 echo "license=$(LIBUNISTR_PKG_LICENSE)"                         >> $(LIBUNISTR_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBUNISTR_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
