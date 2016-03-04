
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/icecast

ifeq ($(filter $(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC)),)
REQUIRES           = net/curl/7.38.0
REQUIRES          += libs/libxslt/1.1.28
REQUIRES          += libs/libtheora/1.1.1
REQUIRES          += libs/libvorbis/1.3.4
REQUIRES          += libs/speex/1.2rc2
else
REQUIRES           = net/curl/7.38.0-x86_32
REQUIRES          += libs/libxslt/1.1.28-x86_32
REQUIRES          += libs/libtheora/1.1.1-x86_32
REQUIRES          += libs/libvorbis/1.3.4-x86_32
REQUIRES          += libs/speex/1.2rc2-x86_32
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.4.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/icecast/icecast-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/icecast-$(version)
src_dir_name       = icecast-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done


icecast_logrotate  = $(CURDIR)/logrotate/icecast.logrotate


PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ICECAST_PKG_NAME                = icecast
ICECAST_PKG_VERSION             = 2.4.1
ICECAST_PKG_ARCH                = $(TOOLCHAIN)
ICECAST_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ICECAST_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ICECAST_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
ICECAST_PKG_SHORT_DESCRIPTION   = streaming media server
ICECAST_PKG_URL                 = $(BUG_URL)
ICECAST_PKG_LICENSE             = GPLv2
ICECAST_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ICECAST_PKG_NAME)-pkg-description
ICECAST_PKG_DESCRIPTION_FILE_IN = $(ICECAST_PKG_NAME)-pkg-description.in
ICECAST_PKG_INSTALL_SCRIPT      = $(ICECAST_PKG_NAME)-pkg-install.sh

ICECAST_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ICECAST_PKG_NAME)-package

pkg_basename     = $(ICECAST_PKG_NAME)-$(ICECAST_PKG_VERSION)-$(ICECAST_PKG_ARCH)-$(ICECAST_PKG_DISTRO_NAME)-$(ICECAST_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ICECAST_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --with-xslt-config=$(TARGET_DEST_DIR)/usr/bin/xslt-config
extra_configure_switches += --with-curl-config=$(TARGET_DEST_DIR)/usr/bin/curl-config
extra_configure_switches += --with-ogg=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-vorbis=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-theora=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-speex=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-openssl=$(TARGET_DEST_DIR)/usr

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
	@mkdir -p $(ICECAST_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mv $(ICECAST_PKG)/etc/icecast.xml $(ICECAST_PKG)/etc/icecast.xml.new
	# ======= Install logrotate script =======
	@mkdir -p $(ICECAST_PKG)/etc/logrotate.d
	@cp -a $(icecast_logrotate) $(ICECAST_PKG)/etc/logrotate.d/icecast
	@chmod 0644 $(ICECAST_PKG)/etc/logrotate.d/icecast
	@mkdir -p $(ICECAST_PKG)/var/log/icecast
	# ======= Install Documentation =======
	@if [ -d $(ICECAST_PKG)/usr/share/man ]; then \
	  ( cd $(ICECAST_PKG)/usr/share/man ; \
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
	@mkdir -p $(ICECAST_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(ICECAST_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(ICECAST_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(ICECAST_PKG)/usr/share/doc ; \
	   mv icecast $(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING HACKING NEWS README TODO \
	         $(ICECAST_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(ICECAST_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	   rm -f AUTHORS COPYING ChangeLog NEWS README TODO ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(ICECAST_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ICECAST_PKG))
	# ======= Strip binaries =======
	@( cd $(ICECAST_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(ICECAST_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(ICECAST_PKG_DESCRIPTION_FILE): $(ICECAST_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ICECAST_PKG_DESCRIPTION_FILE) $(ICECAST_PKG_INSTALL_SCRIPT)
	@cp $(ICECAST_PKG_DESCRIPTION_FILE) $(ICECAST_PKG)/.DESCRIPTION
	@cp $(ICECAST_PKG_INSTALL_SCRIPT) $(ICECAST_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ICECAST_PKG)/.REQUIRES
	@echo "pkgname=$(ICECAST_PKG_NAME)"                            >  $(ICECAST_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ICECAST_PKG_VERSION)"                          >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "arch=$(ICECAST_PKG_ARCH)"                               >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "distroname=$(ICECAST_PKG_DISTRO_NAME)"                  >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "distrover=$(ICECAST_PKG_DISTRO_VERSION)"                >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "group=$(ICECAST_PKG_GROUP)"                             >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ICECAST_PKG_SHORT_DESCRIPTION)\"" >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "url=$(ICECAST_PKG_URL)"                                 >> $(ICECAST_PKG)/.PKGINFO ; \
	 echo "license=$(ICECAST_PKG_LICENSE)"                         >> $(ICECAST_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ICECAST_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
