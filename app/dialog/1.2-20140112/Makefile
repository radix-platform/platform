
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/dialog

REQUIRES           = libs/ncurses/6.0
REQUIRES          += dev/libtool/2.4.2
REQUIRES          += app/ctags/5.8

# ======= __END_OF_REQUIRES__ =======


version            = 1.2-20140112
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/dialog/dialog-$(version).tgz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/dialog-$(version)
src_dir_name       = dialog-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


dialogrc           = $(CURDIR)/config/dialogrc


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
DIALOG_PKG_NAME                = dialog
DIALOG_PKG_VERSION             = 1.2-20140112
DIALOG_PKG_ARCH                = $(TOOLCHAIN)
DIALOG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
DIALOG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
DIALOG_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
DIALOG_PKG_SHORT_DESCRIPTION   = dialog boxes for shell scripts
DIALOG_PKG_URL                 = $(BUG_URL)
DIALOG_PKG_LICENSE             = LGPLv2
DIALOG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(DIALOG_PKG_NAME)-pkg-description
DIALOG_PKG_DESCRIPTION_FILE_IN = $(DIALOG_PKG_NAME)-pkg-description.in
DIALOG_PKG_INSTALL_SCRIPT      = $(DIALOG_PKG_NAME)-pkg-install.sh

DIALOG_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(DIALOG_PKG_NAME)-package

pkg_basename     = $(DIALOG_PKG_NAME)-$(DIALOG_PKG_VERSION)-$(DIALOG_PKG_ARCH)-$(DIALOG_PKG_DISTRO_NAME)-$(DIALOG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(DIALOG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-nls
extra_configure_switches += --with-ncursesw
extra_configure_switches += --enable-widec
extra_configure_switches += --disable-rpath
extra_configure_switches += --disable-rpath-hack
extra_configure_switches += --with-libtool

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
	@cp -a $(TARGET_DEST_DIR)/usr/bin/libtool $(build_dir)
	@( cd $(build_dir) ; \
	   sed -i '/^LIBS	.*=/c LIBS		= $(LDFLAGS) -lncursesw -lm' makefile ; \
	   sed -i '/^LIBTOOL	.*=/c LIBTOOL		= ./libtool --tag=CC' makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(DIALOG_PKG)/{bin,etc}
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(DIALOG_PKG)/usr/bin ; \
	   sed -i 's,-L/usr/lib64 ,,' dialog-config ; \
	   mv dialog ../../bin       ; \
	   ln -sf ../../bin/dialog . ; \
	 )
	@cp -a $(dialogrc) $(DIALOG_PKG)/etc
	# ======= Compress man pages =======
	@if [ -d $(DIALOG_PKG)/usr/share/man ]; then \
	  ( cd $(DIALOG_PKG)/usr/share/man ; \
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
	# ======= Install Documentation =======
	@mkdir -p $(DIALOG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(DIALOG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(DIALOG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README VERSION \
	         $(DIALOG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGES ]; then \
	     DOCSDIR=`echo $(DIALOG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGES | head -n 1000 > $$DOCSDIR/CHANGES ; \
	     touch -r CHANGES $$DOCSDIR/CHANGES ; \
	   fi \
	 )
	# ======= remove target path from target libtool *.la files =======
	@( cd $(DIALOG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 0755 libdialog.la libdialog.so.??.* ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libdialog.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(DIALOG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libdialog.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libdialog.la \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" dialog-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(DIALOG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
	@touch $@

$(DIALOG_PKG_DESCRIPTION_FILE): $(DIALOG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(DIALOG_PKG_DESCRIPTION_FILE) $(DIALOG_PKG_INSTALL_SCRIPT)
	@cp $(DIALOG_PKG_DESCRIPTION_FILE) $(DIALOG_PKG)/.DESCRIPTION
	@cp $(DIALOG_PKG_INSTALL_SCRIPT) $(DIALOG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(DIALOG_PKG)/.REQUIRES
	@echo "pkgname=$(DIALOG_PKG_NAME)"                            >  $(DIALOG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(DIALOG_PKG_VERSION)"                          >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "arch=$(DIALOG_PKG_ARCH)"                               >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "distroname=$(DIALOG_PKG_DISTRO_NAME)"                  >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "distrover=$(DIALOG_PKG_DISTRO_VERSION)"                >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "group=$(DIALOG_PKG_GROUP)"                             >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(DIALOG_PKG_SHORT_DESCRIPTION)\"" >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "url=$(DIALOG_PKG_URL)"                                 >> $(DIALOG_PKG)/.PKGINFO ; \
	 echo "license=$(DIALOG_PKG_LICENSE)"                         >> $(DIALOG_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(DIALOG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
	@touch $@
