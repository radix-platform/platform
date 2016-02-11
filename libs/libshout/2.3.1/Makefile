
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/xiph/libshout

REQUIRES           = libs/libtheora/1.1.1
REQUIRES          += libs/libvorbis/1.3.4
REQUIRES          += libs/speex/1.2rc2

# ======= __END_OF_REQUIRES__ =======


version            = 2.3.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/xiph/libshout/libshout-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libshout-$(version)
src_dir_name       = libshout-$(version)
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
LIBSHOUT_PKG_NAME                = libshout
LIBSHOUT_PKG_VERSION             = 2.3.1
LIBSHOUT_PKG_ARCH                = $(TOOLCHAIN)
LIBSHOUT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSHOUT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSHOUT_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBSHOUT_PKG_SHORT_DESCRIPTION   = Library for accessing an icecast server
LIBSHOUT_PKG_URL                 = $(BUG_URL)
LIBSHOUT_PKG_LICENSE             = LGPLv2
LIBSHOUT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSHOUT_PKG_NAME)-pkg-description
LIBSHOUT_PKG_DESCRIPTION_FILE_IN = $(LIBSHOUT_PKG_NAME)-pkg-description.in
LIBSHOUT_PKG_INSTALL_SCRIPT      = $(LIBSHOUT_PKG_NAME)-pkg-install.sh

LIBSHOUT_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSHOUT_PKG_NAME)-package

pkg_basename     = $(LIBSHOUT_PKG_NAME)-$(LIBSHOUT_PKG_VERSION)-$(LIBSHOUT_PKG_ARCH)-$(LIBSHOUT_PKG_DISTRO_NAME)-$(LIBSHOUT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBSHOUT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --with-ogg=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-vorbis=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-theora=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --with-speex=$(TARGET_DEST_DIR)/usr

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	# ======= Remove -I/usr/include from SHOUT_CPPFLAGS =======
	@( cd $(build_dir) ; \
	   for file in `find . -name "Makefile"` ; do \
	     sed -i "s,-I/usr/include ,,g" $$file ; \
	   done ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBSHOUT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBSHOUT_PKG)/usr/share/man ]; then \
	  ( cd $(LIBSHOUT_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBSHOUT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBSHOUT_PKG)/usr/doc/$(src_dir_name)
	@( cd $(LIBSHOUT_PKG)/usr/share/doc ; \
	   mv libshout $(src_dir_name) ; \
	 )
	@( cd $(LIBSHOUT_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mkdir -p examples ; \
	   mv *.c examples ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL \
	         $(LIBSHOUT_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBSHOUT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSHOUT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libshout.la ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(LIBSHOUT_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,-I$(TARGET_DEST_DIR)/usr/include,,g" shout.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSHOUT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	  sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libshout.la ; \
	  sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libshout.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" shout.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSHOUT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSHOUT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSHOUT_PKG_DESCRIPTION_FILE): $(LIBSHOUT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSHOUT_PKG_DESCRIPTION_FILE) $(LIBSHOUT_PKG_INSTALL_SCRIPT)
	@cp $(LIBSHOUT_PKG_DESCRIPTION_FILE) $(LIBSHOUT_PKG)/.DESCRIPTION
	@cp $(LIBSHOUT_PKG_INSTALL_SCRIPT) $(LIBSHOUT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSHOUT_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSHOUT_PKG_NAME)"                            >  $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSHOUT_PKG_VERSION)"                          >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSHOUT_PKG_ARCH)"                               >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSHOUT_PKG_DISTRO_NAME)"                  >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSHOUT_PKG_DISTRO_VERSION)"                >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSHOUT_PKG_GROUP)"                             >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSHOUT_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSHOUT_PKG_URL)"                                 >> $(LIBSHOUT_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSHOUT_PKG_LICENSE)"                         >> $(LIBSHOUT_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(LIBSHOUT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
