
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


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/audiofile

REQUIRES           = dev/gcc/4.9.2
REQUIRES          += libs/alsa-lib/1.0.28
REQUIRES          += app/flac/1.3.0

# ======= __END_OF_REQUIRES__ =======


version            = 0.3.6
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/audiofile/audiofile-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/audiofile-$(version)
src_dir_name       = audiofile-$(version)
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
AUDIOFILE_PKG_NAME                = audiofile
AUDIOFILE_PKG_VERSION             = 0.3.6
AUDIOFILE_PKG_ARCH                = $(TOOLCHAIN)
AUDIOFILE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
AUDIOFILE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
AUDIOFILE_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
AUDIOFILE_PKG_SHORT_DESCRIPTION   = audio support library
AUDIOFILE_PKG_URL                 = $(BUG_URL)
AUDIOFILE_PKG_LICENSE             = LGPLv2.1
AUDIOFILE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(AUDIOFILE_PKG_NAME)-pkg-description
AUDIOFILE_PKG_DESCRIPTION_FILE_IN = $(AUDIOFILE_PKG_NAME)-pkg-description.in
AUDIOFILE_PKG_INSTALL_SCRIPT      = $(AUDIOFILE_PKG_NAME)-pkg-install.sh

AUDIOFILE_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(AUDIOFILE_PKG_NAME)-package

pkg_basename     = $(AUDIOFILE_PKG_NAME)-$(AUDIOFILE_PKG_VERSION)-$(AUDIOFILE_PKG_ARCH)-$(AUDIOFILE_PKG_DISTRO_NAME)-$(AUDIOFILE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(AUDIOFILE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --program-prefix=
extra_configure_switches += --program-suffix=
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_RPATH = /lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


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
	@mkdir -p $(AUDIOFILE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	# ======= Install Documentation =======
	@( cd $(XORG_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do                                \
	     ln=`head -n 1 $$file` ;                           \
	     if [ "`echo $$ln | grep '^\.so '`" != "" ] ; then \
	       origin=`echo $$ln | cut -f 2 -d ' '` ;          \
	       origin=`basename $$origin` ;                    \
	       rm -f $$file ;                                  \
	       ln -sf $$origin $$file ;                        \
	     fi ;                                              \
	   done ;                                              \
	 )
	@if [ -d $(AUDIOFILE_PKG)/usr/share/man ]; then \
	  ( cd $(AUDIOFILE_PKG)/usr/share/man ; \
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
	@mkdir -p $(AUDIOFILE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(AUDIOFILE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(AUDIOFILE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ACKNOWLEDGEMENTS AUTHORS COPYING* INSTALL NEWS NOTES README TODO \
	         $(AUDIOFILE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(AUDIOFILE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(AUDIOFILE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libaudiofile.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	@mkdir -p $(TARGET_DEST_DIR)
	@cd $(AUDIOFILE_PKG) && cp -rf * $(TARGET_DEST_DIR)
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libaudiofile.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libaudiofile.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" audiofile.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(AUDIOFILE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(AUDIOFILE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(AUDIOFILE_PKG_DESCRIPTION_FILE): $(AUDIOFILE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(AUDIOFILE_PKG_DESCRIPTION_FILE) $(AUDIOFILE_PKG_INSTALL_SCRIPT)
	@cp $(AUDIOFILE_PKG_DESCRIPTION_FILE) $(AUDIOFILE_PKG)/.DESCRIPTION
	@cp $(AUDIOFILE_PKG_INSTALL_SCRIPT) $(AUDIOFILE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(AUDIOFILE_PKG)/.REQUIRES
	@echo "pkgname=$(AUDIOFILE_PKG_NAME)"                            >  $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(AUDIOFILE_PKG_VERSION)"                          >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "arch=$(AUDIOFILE_PKG_ARCH)"                               >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "distroname=$(AUDIOFILE_PKG_DISTRO_NAME)"                  >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "distrover=$(AUDIOFILE_PKG_DISTRO_VERSION)"                >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "group=$(AUDIOFILE_PKG_GROUP)"                             >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(AUDIOFILE_PKG_SHORT_DESCRIPTION)\"" >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "url=$(AUDIOFILE_PKG_URL)"                                 >> $(AUDIOFILE_PKG)/.PKGINFO ; \
	 echo "license=$(AUDIOFILE_PKG_LICENSE)"                         >> $(AUDIOFILE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(AUDIOFILE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
