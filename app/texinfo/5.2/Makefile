
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/texinfo

REQUIRES           = libs/ncurses/6.0
REQUIRES          += app/gzip/1.6
REQUIRES          += app/findutils/4.4.2
REQUIRES          += app/bash/4.3
REQUIRES          += app/sed/4.2.2
REQUIRES          += dev/perl/5.22.1

# ======= __END_OF_REQUIRES__ =======


version            = 5.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/texinfo/texinfo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/texinfo-$(version)
src_dir_name       = texinfo-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
TEXINFO_PKG_NAME                = texinfo
TEXINFO_PKG_VERSION             = 5.2
TEXINFO_PKG_ARCH                = $(TOOLCHAIN)
TEXINFO_PKG_DISTRO_NAME         = $(DISTRO_NAME)
TEXINFO_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
TEXINFO_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
TEXINFO_PKG_SHORT_DESCRIPTION   = software documentation system
TEXINFO_PKG_URL                 = $(BUG_URL)
TEXINFO_PKG_LICENSE             = GPLv3
TEXINFO_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(TEXINFO_PKG_NAME)-pkg-description
TEXINFO_PKG_DESCRIPTION_FILE_IN = $(TEXINFO_PKG_NAME)-pkg-description.in
TEXINFO_PKG_INSTALL_SCRIPT      = $(TEXINFO_PKG_NAME)-pkg-install.sh

TEXINFO_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(TEXINFO_PKG_NAME)-package

pkg_basename     = $(TEXINFO_PKG_NAME)-$(TEXINFO_PKG_VERSION)-$(TEXINFO_PKG_ARCH)-$(TEXINFO_PKG_DISTRO_NAME)-$(TEXINFO_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(TEXINFO_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking


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
	@mkdir -p $(TEXINFO_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(TEXINFO_PKG)/usr/share/man/man1 ; \
	   rm -f pdftexi2dvi.1 texi2any.1 texi2pdf.1 ; \
	   ln -sf texi2dvi.1 pdftexi2dvi.1 ; \
	   ln -sf texi2dvi.1 texi2pdf.1    ; \
	   ln -sf makeinfo.1 texi2any.1    ; \
	 )
	@rm -f $(TEXINFO_PKG)/usr/share/info/dir
	@gzip -9 $(TEXINFO_PKG)/usr/share/info/*
	@if [ -d $(TEXINFO_PKG)/usr/share/man ]; then \
	  ( cd $(TEXINFO_PKG)/usr/share/man ; \
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
	@mkdir -p $(TEXINFO_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(TEXINFO_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(TEXINFO_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL* NEWS README* TODO \
	         $(TEXINFO_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(TEXINFO_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(TEXINFO_PKG))
	# ======= Strip binaries =======
	@( cd $(TEXINFO_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(TEXINFO_PKG_DESCRIPTION_FILE): $(TEXINFO_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(TEXINFO_PKG_DESCRIPTION_FILE) $(TEXINFO_PKG_INSTALL_SCRIPT)
	@cp $(TEXINFO_PKG_DESCRIPTION_FILE) $(TEXINFO_PKG)/.DESCRIPTION
	@cp $(TEXINFO_PKG_INSTALL_SCRIPT) $(TEXINFO_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(TEXINFO_PKG)/.REQUIRES
	@echo "pkgname=$(TEXINFO_PKG_NAME)"                            >  $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "pkgver=$(TEXINFO_PKG_VERSION)"                          >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "arch=$(TEXINFO_PKG_ARCH)"                               >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "distroname=$(TEXINFO_PKG_DISTRO_NAME)"                  >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "distrover=$(TEXINFO_PKG_DISTRO_VERSION)"                >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "group=$(TEXINFO_PKG_GROUP)"                             >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(TEXINFO_PKG_SHORT_DESCRIPTION)\"" >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "url=$(TEXINFO_PKG_URL)"                                 >> $(TEXINFO_PKG)/.PKGINFO ; \
	 echo "license=$(TEXINFO_PKG_LICENSE)"                         >> $(TEXINFO_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(TEXINFO_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
