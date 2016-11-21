
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/b/sqlite/2014

REQUIRES           = libs/readline/6.3

# ======= __END_OF_REQUIRES__ =======


version            = 3.8.7.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/b/sqlite/2014/sqlite-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sqlite-$(version)
src_dir_name       = sqlite-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

license            = $(CURDIR)/license/COPYRIGHT

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SQLITE_PKG_NAME                = sqlite
SQLITE_PKG_VERSION             = 3.8.7.1
SQLITE_PKG_ARCH                = $(TOOLCHAIN)
SQLITE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SQLITE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SQLITE_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
SQLITE_PKG_SHORT_DESCRIPTION   = self contained database engine
SQLITE_PKG_URL                 = $(BUG_URL)
SQLITE_PKG_LICENSE             = public
SQLITE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SQLITE_PKG_NAME)-pkg-description
SQLITE_PKG_DESCRIPTION_FILE_IN = $(SQLITE_PKG_NAME)-pkg-description.in
SQLITE_PKG_INSTALL_SCRIPT      = $(SQLITE_PKG_NAME)-pkg-install.sh

SQLITE_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SQLITE_PKG_NAME)-package

pkg_basename     = $(SQLITE_PKG_NAME)-$(SQLITE_PKG_VERSION)-$(SQLITE_PKG_ARCH)-$(SQLITE_PKG_DISTRO_NAME)-$(SQLITE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SQLITE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-readline=yes
extra_configure_switches += --enable-threadsafe=yes
extra_configure_switches += --enable-dynamic-extensions=yes

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(SQLITE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SQLITE_PKG)/usr/share/man ]; then \
	  ( cd $(SQLITE_PKG)/usr/share/man ; \
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
	@mkdir -p $(SQLITE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(license) \
	       $(SQLITE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SQLITE_PKG)/usr/share/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/INSTALL $(SRC_DIR)/README \
	       $(SQLITE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SQLITE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SQLITE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsqlite?.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SQLITE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsqlite?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsqlite?.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" sqlite?.pc \
	 )
	# ======= Strip Binaries =======
	@( cd $(SQLITE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SQLITE_PKG_DESCRIPTION_FILE): $(SQLITE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SQLITE_PKG_DESCRIPTION_FILE) $(SQLITE_PKG_INSTALL_SCRIPT)
	@cp $(SQLITE_PKG_DESCRIPTION_FILE) $(SQLITE_PKG)/.DESCRIPTION
	@cp $(SQLITE_PKG_INSTALL_SCRIPT) $(SQLITE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SQLITE_PKG)/.REQUIRES
	@echo "pkgname=$(SQLITE_PKG_NAME)"                            >  $(SQLITE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SQLITE_PKG_VERSION)"                          >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "arch=$(SQLITE_PKG_ARCH)"                               >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "distroname=$(SQLITE_PKG_DISTRO_NAME)"                  >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "distrover=$(SQLITE_PKG_DISTRO_VERSION)"                >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "group=$(SQLITE_PKG_GROUP)"                             >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SQLITE_PKG_SHORT_DESCRIPTION)\"" >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "url=$(SQLITE_PKG_URL)"                                 >> $(SQLITE_PKG)/.PKGINFO ; \
	 echo "license=$(SQLITE_PKG_LICENSE)"                         >> $(SQLITE_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SQLITE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
