
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXQ)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/kbd

REQUIRES           = dev/check/0.10.0
REQUIRES          += secure/pam_unix2/2.9.1

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.2
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/kbd/kbd-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/kbd-$(version)
src_dir_name       = kbd-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

maps_i386_qwerty   = $(CURDIR)/keymaps/i386/qwerty

####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
KBD_PKG_NAME                = kbd
KBD_PKG_VERSION             = 2.0.2
KBD_PKG_ARCH                = $(TOOLCHAIN)
KBD_PKG_DISTRO_NAME         = $(DISTRO_NAME)
KBD_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
KBD_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
KBD_PKG_SHORT_DESCRIPTION   = keyboard maps and console fonts
KBD_PKG_URL                 = $(BUG_URL)
KBD_PKG_LICENSE             = GPLv2
KBD_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(KBD_PKG_NAME)-pkg-description
KBD_PKG_DESCRIPTION_FILE_IN = $(KBD_PKG_NAME)-pkg-description.in
KBD_PKG_INSTALL_SCRIPT      = $(KBD_PKG_NAME)-pkg-install.sh

KBD_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(KBD_PKG_NAME)-package

pkg_basename     = $(KBD_PKG_NAME)-$(KBD_PKG_VERSION)-$(KBD_PKG_ARCH)-$(KBD_PKG_DISTRO_NAME)-$(KBD_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(KBD_PKG)

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --localedir=/usr/share/locale
extra_configure_switches += --datadir=/usr/share/kbd
extra_configure_switches += --enable-libkeymap
extra_configure_switches += --disable-rpath
extra_configure_switches += --enable-nls


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	# ======= Rename conflicting keymaps =======
	@( cd $(SRC_DIR) ; \
	   mv data/keymaps/i386/qwertz/cz{,-qwertz}.map         ; \
	   mv data/keymaps/i386/olpc/es{,-olpc}.map             ; \
	   mv data/keymaps/i386/olpc/pt{,-olpc}.map             ; \
	   mv data/keymaps/i386/dvorak/no{,-dvorak}.map         ; \
	   mv data/keymaps/i386/fgGIod/trf{,-fgGIod}.map        ; \
	   mv data/keymaps/i386/colemak/{en-latin9,colemak}.map ; \
	 )
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
	@mkdir -p $(KBD_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= The rhpl keyboard layout table is indexed by kbd layout names, =======
	# ======= so we need a Korean keyboard                                   =======
	@( cd $(KBD_PKG)/usr/share/kbd/keymaps/i386/qwerty ; \
	   ln -sf us.map.gz ko.map.gz ; \
	 )
	# ======= Install Russian i386/qwerty keymaps =======
	@for map in $(maps_i386_qwerty)/*.map ; do \
	   cat $$map | gzip -9c > $(KBD_PKG)/usr/share/kbd/keymaps/i386/qwerty/`basename $$map`.gz ; \
	 done
	# ======= Move loadkeys into /bin directory =======
	@mkdir -p $(KBD_PKG)/bin
	@( cd $(KBD_PKG)/usr/bin ; \
	   mv -f loadkeys ../../bin ; \
	   ln -sf ../../bin/loadkeys . ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(KBD_PKG)/usr/share/man ]; then \
	  ( cd $(KBD_PKG)/usr/share/man ; \
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
	@mkdir -p $(KBD_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(KBD_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(KBD_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING CREDITS INSTALL README docs/doc \
	         $(KBD_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(KBD_PKG)/usr/share/doc/$(src_dir_name) ; \
	   mv html libkeymap ; \
	   mv doc docs ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(KBD_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(KBD_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libkeymap.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(KBD_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkeymap.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libkeymap.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libkeymap.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(KBD_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(KBD_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(KBD_PKG_DESCRIPTION_FILE): $(KBD_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(KBD_PKG_DESCRIPTION_FILE) $(KBD_PKG_INSTALL_SCRIPT)
	@cp $(KBD_PKG_DESCRIPTION_FILE) $(KBD_PKG)/.DESCRIPTION
	@cp $(KBD_PKG_INSTALL_SCRIPT) $(KBD_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(KBD_PKG)/.REQUIRES
	@echo "pkgname=$(KBD_PKG_NAME)"                            >  $(KBD_PKG)/.PKGINFO ; \
	 echo "pkgver=$(KBD_PKG_VERSION)"                          >> $(KBD_PKG)/.PKGINFO ; \
	 echo "arch=$(KBD_PKG_ARCH)"                               >> $(KBD_PKG)/.PKGINFO ; \
	 echo "distroname=$(KBD_PKG_DISTRO_NAME)"                  >> $(KBD_PKG)/.PKGINFO ; \
	 echo "distrover=$(KBD_PKG_DISTRO_VERSION)"                >> $(KBD_PKG)/.PKGINFO ; \
	 echo "group=$(KBD_PKG_GROUP)"                             >> $(KBD_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(KBD_PKG_SHORT_DESCRIPTION)\"" >> $(KBD_PKG)/.PKGINFO ; \
	 echo "url=$(KBD_PKG_URL)"                                 >> $(KBD_PKG)/.PKGINFO ; \
	 echo "license=$(KBD_PKG_LICENSE)"                         >> $(KBD_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(KBD_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
