
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/libksba

REQUIRES           = net/libgpg-error/1.16

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libksba/libksba-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libksba-$(version)
src_dir_name       = libksba-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KSBA_PKG_NAME                = libksba
KSBA_PKG_VERSION             = 1.3.0
KSBA_PKG_ARCH                = $(TOOLCHAIN)
KSBA_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KSBA_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KSBA_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
KSBA_PKG_SHORT_DESCRIPTION   = X.509 \& CMS library for S/MIME and TLS
KSBA_PKG_URL                 = $(BUG_URL)
KSBA_PKG_LICENSE             = GPLv2
KSBA_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KSBA_PKG_NAME)-pkg-description
KSBA_PKG_DESCRIPTION_FILE_IN = $(KSBA_PKG_NAME)-pkg-description.in
KSBA_PKG_INSTALL_SCRIPT      = $(KSBA_PKG_NAME)-pkg-install.sh

KSBA_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KSBA_PKG_NAME)-package

pkg_basename     = $(KSBA_PKG_NAME)-$(KSBA_PKG_VERSION)-$(KSBA_PKG_ARCH)-$(KSBA_PKG_DISTRO_NAME)-$(KSBA_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(KSBA_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes

gpg_error_config = GPG_ERROR_CONFIG=$(TARGET_DEST_DIR)/usr/bin/gpg-error-config


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(gpg_error_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(KSBA_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(KSBA_PKG)/lib$(LIBSUFFIX)
	@( cd $(KSBA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod +w lib*.so.?.*.? ; \
	   mv lib*.so.?.*.? ../../lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/lib*.so.?.*.? . ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(KSBA_PKG)/usr/share/info/dir
	@gzip -9 $(KSBA_PKG)/usr/share/info/*
	@mkdir -p $(KSBA_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(KSBA_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(KSBA_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README* THANKS VERSION doc/HACKING \
	         $(KSBA_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(KSBA_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(KSBA_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libksba.la ; \
	 )
	@( cd $(KSBA_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" ksba-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(KSBA_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libksba.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libksba.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" ksba-config ; \
	   sed -i "s,-L/usr,-L$(TARGET_DEST_DIR)/usr,g" ksba-config ; \
	   sed -i "s,-I/usr,-I$(TARGET_DEST_DIR)/usr,g" ksba-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(KSBA_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(KSBA_PKG)/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(KSBA_PKG_DESCRIPTION_FILE): $(KSBA_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KSBA_PKG_DESCRIPTION_FILE) $(KSBA_PKG_INSTALL_SCRIPT)
	@cp $(KSBA_PKG_DESCRIPTION_FILE) $(KSBA_PKG)/.DESCRIPTION
	@cp $(KSBA_PKG_INSTALL_SCRIPT) $(KSBA_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KSBA_PKG)/.REQUIRES
	@echo "pkgname=$(KSBA_PKG_NAME)"                            >  $(KSBA_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KSBA_PKG_VERSION)"                          >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "arch=$(KSBA_PKG_ARCH)"                               >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "distroname=$(KSBA_PKG_DISTRO_NAME)"                  >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "distrover=$(KSBA_PKG_DISTRO_VERSION)"                >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "group=$(KSBA_PKG_GROUP)"                             >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KSBA_PKG_SHORT_DESCRIPTION)\"" >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "url=$(KSBA_PKG_URL)"                                 >> $(KSBA_PKG)/.PKGINFO ; \
	 echo "license=$(KSBA_PKG_LICENSE)"                         >> $(KSBA_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(KSBA_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
