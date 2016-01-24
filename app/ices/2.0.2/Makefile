
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


SOURCE_REQUIRES    = sources/packages/m/xiph/ices

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = libs/libxml2/2.9.1
REQUIRES          += libs/alsa-lib/1.0.28
REQUIRES          += libs/libshout/2.3.1
else
REQUIRES           = libs/libxml2/2.9.1-x86_32
REQUIRES          += libs/alsa-lib/1.0.28-x86_32
REQUIRES          += libs/libshout/2.3.1-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.2
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/ices/ices-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ices-$(version)
src_dir_name       = ices-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


ices_logrotate  = $(CURDIR)/logrotate/ices.logrotate


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICES_PKG_NAME                = ices
ICES_PKG_VERSION             = 2.0.2
ICES_PKG_ARCH                = $(TOOLCHAIN)
ICES_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICES_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICES_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
ICES_PKG_SHORT_DESCRIPTION   = streaming media server
ICES_PKG_URL                 = $(BUG_URL)
ICES_PKG_LICENSE             = GPLv2
ICES_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICES_PKG_NAME)-pkg-description
ICES_PKG_DESCRIPTION_FILE_IN = $(ICES_PKG_NAME)-pkg-description.in
ICES_PKG_INSTALL_SCRIPT      = $(ICES_PKG_NAME)-pkg-install.sh

ICES_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICES_PKG_NAME)-package

pkg_basename     = $(ICES_PKG_NAME)-$(ICES_PKG_VERSION)-$(ICES_PKG_ARCH)-$(ICES_PKG_DISTRO_NAME)-$(ICES_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ICES_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --with-xml-config=$(TARGET_DEST_DIR)/usr/bin/xml2-config
extra_configure_switches += --with-ogg=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-vorbis=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


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
	@mkdir -p $(ICES_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(ICES_PKG)/var/log/ices
	# ======= Install Documentation =======
	@if [ -d $(ICES_PKG)/usr/share/man ]; then \
	  ( cd $(ICES_PKG)/usr/share/man ; \
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
	@mkdir -p $(ICES_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(ICES_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ICES_PKG)/usr/share/doc/$(src_dir_name)/sample_configs
	@( cd $(ICES_PKG)/usr/share ; \
	   mv ices doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING README TODO \
	         $(ICES_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(ICES_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	   mv ices-*.xml ../sample_configs ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ICES_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ICES_PKG))
	# ======= Strip binaries =======
	@( cd $(ICES_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(ICES_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ICES_PKG_DESCRIPTION_FILE): $(ICES_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICES_PKG_DESCRIPTION_FILE) $(ICES_PKG_INSTALL_SCRIPT)
	@cp $(ICES_PKG_DESCRIPTION_FILE) $(ICES_PKG)/.DESCRIPTION
	@cp $(ICES_PKG_INSTALL_SCRIPT) $(ICES_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICES_PKG)/.REQUIRES
	@echo "pkgname=$(ICES_PKG_NAME)"                            >  $(ICES_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICES_PKG_VERSION)"                          >> $(ICES_PKG)/.PKGINFO ; \
	 echo "arch=$(ICES_PKG_ARCH)"                               >> $(ICES_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICES_PKG_DISTRO_NAME)"                  >> $(ICES_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICES_PKG_DISTRO_VERSION)"                >> $(ICES_PKG)/.PKGINFO ; \
	 echo "group=$(ICES_PKG_GROUP)"                             >> $(ICES_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICES_PKG_SHORT_DESCRIPTION)\"" >> $(ICES_PKG)/.PKGINFO ; \
	 echo "url=$(ICES_PKG_URL)"                                 >> $(ICES_PKG)/.PKGINFO ; \
	 echo "license=$(ICES_PKG_LICENSE)"                         >> $(ICES_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ICES_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
