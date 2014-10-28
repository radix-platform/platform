
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


SOURCE_REQUIRES    = sources/packages/a/gpm

REQUIRES           = app/inputattach/1.4.7


version            = 1.20.7
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/a/gpm/gpm-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gpm-$(version)
src_dir_name       = gpm-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

cache_file_in      = $(CURDIR)/disable-emacs.cache
cache_file         = $(CURDIR)/$(SRC_DIR)/disable-emacs.cache


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GPM_PKG_NAME                = gpm
GPM_PKG_VERSION             = 1.20.7
GPM_PKG_ARCH                = $(TOOLCHAIN)
GPM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GPM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GPM_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
GPM_PKG_SHORT_DESCRIPTION   = general purpose mouse server
GPM_PKG_URL                 = $(BUG_URL)
GPM_PKG_LICENSE             = GPLv2
GPM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GPM_PKG_NAME)-pkg-description
GPM_PKG_DESCRIPTION_FILE_IN = $(GPM_PKG_NAME)-pkg-description.in
GPM_PKG_INSTALL_SCRIPT      = $(GPM_PKG_NAME)-pkg-install.sh

GPM_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GPM_PKG_NAME)-package

pkg_basename     = $(GPM_PKG_NAME)-$(GPM_PKG_VERSION)-$(GPM_PKG_ARCH)-$(GPM_PKG_DISTRO_NAME)-$(GPM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GPM_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --enable-shared
extra_configure_switches += --cache-file=$(cache_file)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cp -a $(cache_file_in) $(cache_file)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GPM_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@chmod 755 $(GPM_PKG)/usr/lib$(LIBSUFFIX)/libgpm.so.?.?.?
	@mkdir -p $(GPM_PKG)/lib$(LIBSUFFIX)
	@( cd $(GPM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in lib*.so.?.* ; do \
	     mv $$file ../../lib$(LIBSUFFIX) ; \
	     ln -sf ../../lib$(LIBSUFFIX)/$$file . ; \
	   done ; \
	   cp -a lib*.so.? ../../lib$(LIBSUFFIX) ; \
	 )
	@( cd $(GPM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   ln -sf libgpm.so.?.?.? libgpm.so \
	 )
	@mkdir -p $(GPM_PKG)/etc/rc.d
	@( cd $(SRC_DIR)/conf ; \
	   cat gpm-root.conf > $(GPM_PKG)/etc/gpm-root.conf ; \
	   cat gpm-syn.conf > $(GPM_PKG)/etc/gpm-syn.conf ; \
	   cat gpm-twiddler.conf > $(GPM_PKG)/etc/gpm-twiddler.conf \
	 )
	@rm -f $(GPM_PKG)/usr/share/info/dir
	@gzip -9 $(GPM_PKG)/usr/share/info/*
	@if [ -d $(GPM_PKG)/usr/share/man ]; then \
	  ( cd $(GPM_PKG)/usr/share/man ; \
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
	@mkdir -p $(GPM_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(GPM_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(GPM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a MANIFEST README* TODO doc/{Announce,FAQ,HACK_GPM,README*,changelog} \
	         $(GPM_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -arf doc/specs doc/support doc/todo \
	           $(GPM_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GPM_PKG)/usr/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# Install the same to $(TARGET_DEST_DIR)
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GPM_PKG) && cp -arf * $(TARGET_DEST_DIR)
	@(cd $(GPM_PKG); \
	  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GPM_PKG_DESCRIPTION_FILE): $(GPM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GPM_PKG_DESCRIPTION_FILE) $(GPM_PKG_INSTALL_SCRIPT)
	@cp $(GPM_PKG_DESCRIPTION_FILE) $(GPM_PKG)/.DESCRIPTION
	@cp $(GPM_PKG_INSTALL_SCRIPT) $(GPM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GPM_PKG)/.REQUIRES
	@echo "pkgname=$(GPM_PKG_NAME)"                            >  $(GPM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GPM_PKG_VERSION)"                          >> $(GPM_PKG)/.PKGINFO ; \
	 echo "arch=$(GPM_PKG_ARCH)"                               >> $(GPM_PKG)/.PKGINFO ; \
	 echo "distroname=$(GPM_PKG_DISTRO_NAME)"                  >> $(GPM_PKG)/.PKGINFO ; \
	 echo "distrover=$(GPM_PKG_DISTRO_VERSION)"                >> $(GPM_PKG)/.PKGINFO ; \
	 echo "group=$(GPM_PKG_GROUP)"                             >> $(GPM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GPM_PKG_SHORT_DESCRIPTION)\"" >> $(GPM_PKG)/.PKGINFO ; \
	 echo "url=$(GPM_PKG_URL)"                                 >> $(GPM_PKG)/.PKGINFO ; \
	 echo "license=$(GPM_PKG_LICENSE)"                         >> $(GPM_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GPM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
