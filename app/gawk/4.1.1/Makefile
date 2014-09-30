
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


SOURCE_REQUIRES    = sources/GNU/gawk

REQUIRES           = libs/libtermcap/1.2.3
REQUIRES          += libs/readline/6.3
REQUIRES          += libs/mpfr/3.1.2


version            = 4.1.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/gawk/gawk-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gawk-$(version)
src_dir_name       = gawk-$(version)
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
GAWK_PKG_NAME                = gawk
GAWK_PKG_VERSION             = 4.1.1
GAWK_PKG_ARCH                = $(TOOLCHAIN)
GAWK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GAWK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GAWK_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
GAWK_PKG_SHORT_DESCRIPTION   = gawk $(version)
GAWK_PKG_URL                 = $(BUG_URL)
GAWK_PKG_LICENSE             = GPLv2
GAWK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GAWK_PKG_NAME)-pkg-description
GAWK_PKG_DESCRIPTION_FILE_IN = $(GAWK_PKG_NAME)-pkg-description.in
GAWK_PKG_INSTALL_SCRIPT      = $(GAWK_PKG_NAME)-pkg-install.sh

GAWK_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GAWK_PKG_NAME)-package

pkg_basename     = $(GAWK_PKG_NAME)-$(GAWK_PKG_VERSION)-$(GAWK_PKG_ARCH)-$(GAWK_PKG_DISTRO_NAME)-$(GAWK_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GAWK_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GAWK_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) install $(env_sysroot)
	@( cd $(GAWK_PKG)/usr/bin ; \
	   rm -f gawk             ; \
	   ln -sf gawk-$(version) gawk \
	 )
	@mkdir -p $(GAWK_PKG)/bin
	@mv $(GAWK_PKG)/usr/bin/gawk* $(GAWK_PKG)/bin
	@mv $(GAWK_PKG)/usr/bin/awk $(GAWK_PKG)/bin
	@( cd $(GAWK_PKG)/usr/bin             ; \
	   ln -sf ../../bin/awk .             ; \
	   ln -sf ../../bin/gawk .            ; \
	   ln -sf ../../bin/gawk-$(version) . ; \
	 )
	@rm -f $(GAWK_PKG)/usr/share/info/dir
	@gzip -9 $(GAWK_PKG)/usr/share/info/*
	@if [ -d $(GAWK_PKG)/usr/share/man ]; then \
	  ( cd $(GAWK_PKG)/usr/share/man ; \
	    for manpagedir in `find . -type d -name "man*"` ; do \
	      ( cd $$manpagedir ; \
	        for eachpage in `find . -type l -maxdepth 1` ; do \
	          ln -s `readlink $$eachpage`.gz $$eachpage.gz ; \
	          rm $$eachpage ; \
	        done ; \
	        gzip -9 *.* ; \
	      ) \
	    done \
	  ) \
	 fi
	@mkdir -p $(GAWK_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GAWK_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GAWK_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING* INSTALL NEWS POSIX.STD README* \
	         $(GAWK_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GAWK_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(GAWK_PKG)/usr/lib$(LIBSUFFIX)/gawk ; \
	  sed -i "s,$(TARGET_DEST_DIR),,g" *.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(GAWK_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/gawk ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" *.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" *.la \
	 )
	@( cd $(GAWK_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GAWK_PKG_DESCRIPTION_FILE): $(GAWK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GAWK_PKG_DESCRIPTION_FILE) $(GAWK_PKG_INSTALL_SCRIPT)
	@cp $(GAWK_PKG_DESCRIPTION_FILE) $(GAWK_PKG)/.DESCRIPTION
	@cp $(GAWK_PKG_INSTALL_SCRIPT) $(GAWK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GAWK_PKG)/.REQUIRES
	@echo "pkgname=$(GAWK_PKG_NAME)"                            >  $(GAWK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GAWK_PKG_VERSION)"                          >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "arch=$(GAWK_PKG_ARCH)"                               >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "distroname=$(GAWK_PKG_DISTRO_NAME)"                  >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "distrover=$(GAWK_PKG_DISTRO_VERSION)"                >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "group=$(GAWK_PKG_GROUP)"                             >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GAWK_PKG_SHORT_DESCRIPTION)\"" >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "url=$(GAWK_PKG_URL)"                                 >> $(GAWK_PKG)/.PKGINFO ; \
	 echo "license=$(GAWK_PKG_LICENSE)"                         >> $(GAWK_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(GAWK_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
