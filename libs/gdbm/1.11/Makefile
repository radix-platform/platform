
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
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
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


SOURCE_REQUIRES    = sources/GNU/gdbm

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.25
else
REQUIRES           = libs/glibc/2.25-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.11
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/gdbm/gdbm-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gdbm-$(version)
src_dir_name       = gdbm-$(version)
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
GDBM_PKG_NAME                = gdbm
GDBM_PKG_VERSION             = 1.11
GDBM_PKG_ARCH                = $(TOOLCHAIN)
GDBM_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GDBM_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GDBM_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
GDBM_PKG_SHORT_DESCRIPTION   = GNU database routines
GDBM_PKG_URL                 = $(BUG_URL)
GDBM_PKG_LICENSE             = GPLv3
GDBM_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GDBM_PKG_NAME)-pkg-description
GDBM_PKG_DESCRIPTION_FILE_IN = $(GDBM_PKG_NAME)-pkg-description.in
GDBM_PKG_INSTALL_SCRIPT      = $(GDBM_PKG_NAME)-pkg-install.sh

GDBM_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GDBM_PKG_NAME)-package

pkg_basename     = $(GDBM_PKG_NAME)-$(GDBM_PKG_VERSION)-$(GDBM_PKG_ARCH)-$(GDBM_PKG_DISTRO_NAME)-$(GDBM_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GDBM_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-libgdbm-compat
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
	@mkdir -p $(GDBM_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(GDBM_PKG)/usr/include/gdbm
	@( cd $(GDBM_PKG)/usr/include/gdbm ; \
	   ln -sf ../dbm.h .  ; \
	   ln -sf ../gdbm.h . ; \
	   ln -sf ../ndbm.h . ; \
	 )
	@rm -f $(GDBM_PKG)/usr/share/info/dir
	@gzip -9 $(GDBM_PKG)/usr/share/info/*
	@if [ -d $(GDBM_PKG)/usr/share/man ]; then \
	  ( cd $(GDBM_PKG)/usr/share/man ; \
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
	@mkdir -p $(GDBM_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(GDBM_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GDBM_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING INSTALL \
	         NEWS NOTE-WARNING README THANKS   \
	         $(GDBM_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GDBM_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GDBM_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgdbm.la libgdbm_compat.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GDBM_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libgdbm.la libgdbm_compat.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgdbm.la libgdbm_compat.la \
	 )
	# ======= Strip binaries =======
	@( cd $(GDBM_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(GDBM_PKG_DESCRIPTION_FILE): $(GDBM_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GDBM_PKG_DESCRIPTION_FILE) $(GDBM_PKG_INSTALL_SCRIPT)
	@cp $(GDBM_PKG_DESCRIPTION_FILE) $(GDBM_PKG)/.DESCRIPTION
	@cp $(GDBM_PKG_INSTALL_SCRIPT) $(GDBM_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GDBM_PKG)/.REQUIRES
	@echo "pkgname=$(GDBM_PKG_NAME)"                            >  $(GDBM_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GDBM_PKG_VERSION)"                          >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "arch=$(GDBM_PKG_ARCH)"                               >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "distroname=$(GDBM_PKG_DISTRO_NAME)"                  >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "distrover=$(GDBM_PKG_DISTRO_VERSION)"                >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "group=$(GDBM_PKG_GROUP)"                             >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GDBM_PKG_SHORT_DESCRIPTION)\"" >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "url=$(GDBM_PKG_URL)"                                 >> $(GDBM_PKG)/.PKGINFO ; \
	 echo "license=$(GDBM_PKG_LICENSE)"                         >> $(GDBM_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GDBM_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
