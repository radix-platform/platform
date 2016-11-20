
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/mikmod/lib

REQUIRES           = libs/alsa-lib/1.1.1
REQUIRES          += app/esound/0.2.41

# ======= __END_OF_REQUIRES__ =======


version            = 3.1.20
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/mikmod/lib/libmikmod-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libmikmod-$(version)
src_dir_name       = libmikmod-$(version)
doc_dir_name       = libmikmod-$(version)
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
LIBMIKMOD_PKG_NAME                = libmikmod
LIBMIKMOD_PKG_VERSION             = 3.1.20
LIBMIKMOD_PKG_ARCH                = $(TOOLCHAIN)
LIBMIKMOD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBMIKMOD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBMIKMOD_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
LIBMIKMOD_PKG_SHORT_DESCRIPTION   = A portable sound library
LIBMIKMOD_PKG_URL                 = $(BUG_URL)
LIBMIKMOD_PKG_LICENSE             = LGPLv2.1
LIBMIKMOD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBMIKMOD_PKG_NAME)-pkg-description
LIBMIKMOD_PKG_DESCRIPTION_FILE_IN = $(LIBMIKMOD_PKG_NAME)-pkg-description.in
LIBMIKMOD_PKG_INSTALL_SCRIPT      = $(LIBMIKMOD_PKG_NAME)-pkg-install.sh

LIBMIKMOD_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBMIKMOD_PKG_NAME)-package

pkg_basename     = $(LIBMIKMOD_PKG_NAME)-$(LIBMIKMOD_PKG_VERSION)-$(LIBMIKMOD_PKG_ARCH)-$(LIBMIKMOD_PKG_DISTRO_NAME)-$(LIBMIKMOD_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBMIKMOD_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --with-pic

extra_configure_switches += --enable-alsa
extra_configure_switches += --enable-esd

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


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
	@mkdir -p $(LIBMIKMOD_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@rm -f $(LIBMIKMOD_PKG)/usr/share/info/dir
	@gzip -9 $(LIBMIKMOD_PKG)/usr/share/info/*
	# ======= Install Documentation =======
	@if [ -d $(LIBMIKMOD_PKG)/usr/share/man ]; then \
	  ( cd $(LIBMIKMOD_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.? ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(LIBMIKMOD_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBMIKMOD_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(LIBMIKMOD_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README TODO \
	         $(LIBMIKMOD_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBMIKMOD_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libmikmod-config script =======
	@( cd $(LIBMIKMOD_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmikmod-config ; \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBMIKMOD_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmikmod.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBMIKMOD_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmikmod.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmikmod.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmikmod.pc ; \
	 )
	# ======= tune libmicmod-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" libmikmod-config ; \
	   sed -i "s,L/usr,L$(TARGET_DEST_DIR)/usr,g" libmikmod-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBMIKMOD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBMIKMOD_PKG_DESCRIPTION_FILE): $(LIBMIKMOD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBMIKMOD_PKG_DESCRIPTION_FILE) $(LIBMIKMOD_PKG_INSTALL_SCRIPT)
	@cp $(LIBMIKMOD_PKG_DESCRIPTION_FILE) $(LIBMIKMOD_PKG)/.DESCRIPTION
	@cp $(LIBMIKMOD_PKG_INSTALL_SCRIPT) $(LIBMIKMOD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBMIKMOD_PKG)/.REQUIRES
	@echo "pkgname=$(LIBMIKMOD_PKG_NAME)"                            >  $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBMIKMOD_PKG_VERSION)"                          >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBMIKMOD_PKG_ARCH)"                               >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBMIKMOD_PKG_DISTRO_NAME)"                  >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBMIKMOD_PKG_DISTRO_VERSION)"                >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "group=$(LIBMIKMOD_PKG_GROUP)"                             >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBMIKMOD_PKG_SHORT_DESCRIPTION)\"" >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "url=$(LIBMIKMOD_PKG_URL)"                                 >> $(LIBMIKMOD_PKG)/.PKGINFO ; \
	 echo "license=$(LIBMIKMOD_PKG_LICENSE)"                         >> $(LIBMIKMOD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBMIKMOD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
