
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


SOURCE_REQUIRES    = sources/packages/l/ppl

REQUIRES           = libs/gmp/6.1.0

# ======= __END_OF_REQUIRES__ =======


version            = 1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/ppl/ppl-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ppl-$(version)
src_dir_name       = ppl-$(version)
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
PPL_PKG_NAME                = ppl
PPL_PKG_VERSION             = 1.1
PPL_PKG_ARCH                = $(TOOLCHAIN)
PPL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
PPL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
PPL_PKG_GROUP               = $(PKG_GROUP)
###                          |---handy-ruler-------------------------------|
PPL_PKG_SHORT_DESCRIPTION   = The Parma Polyhedra Library
PPL_PKG_URL                 = $(BUG_URL)
PPL_PKG_LICENSE             = GPLv2
PPL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(PPL_PKG_NAME)-pkg-description
PPL_PKG_DESCRIPTION_FILE_IN = $(PPL_PKG_NAME)-pkg-description.in
PPL_PKG_INSTALL_SCRIPT      = $(PPL_PKG_NAME)-pkg-install.sh

PPL_PKG          = $(CURDIR)/$(TARGET_BUILD_DIR)/$(PPL_PKG_NAME)-package

pkg_basename     = $(PPL_PKG_NAME)-$(PPL_PKG_VERSION)-$(PPL_PKG_ARCH)-$(PPL_PKG_DISTRO_NAME)-$(PPL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(PPL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-libgmp=$(TARGET_DEST_DIR)/usr
extra_configure_switches += --enable-interfaces="c,cxx"
extra_configure_switches += --disable-optimization
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
	@mkdir -p $(PPL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(PPL_PKG)/usr/share/man ]; then \
	  ( cd $(PPL_PKG)/usr/share/man ; \
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
	@mkdir -p $(PPL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(PPL_PKG)/usr/doc/$(src_dir_name)
	rm -f $(PPL_PKG)/usr/share/doc/$(src_dir_name)/ChangeLog
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(PPL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(PPL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libppl.la libppl_c.la \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(PPL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libppl.la libppl_c.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libppl.la libppl_c.la \
	 )
	# ======= Strip binaries =======
	@( cd $(PPL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(PPL_PKG_DESCRIPTION_FILE): $(PPL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(PPL_PKG_DESCRIPTION_FILE) $(PPL_PKG_INSTALL_SCRIPT)
	@cp $(PPL_PKG_DESCRIPTION_FILE) $(PPL_PKG)/.DESCRIPTION
	@cp $(PPL_PKG_INSTALL_SCRIPT) $(PPL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(PPL_PKG)/.REQUIRES
	@echo "pkgname=$(PPL_PKG_NAME)"                            >  $(PPL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(PPL_PKG_VERSION)"                          >> $(PPL_PKG)/.PKGINFO ; \
	 echo "arch=$(PPL_PKG_ARCH)"                               >> $(PPL_PKG)/.PKGINFO ; \
	 echo "distroname=$(PPL_PKG_DISTRO_NAME)"                  >> $(PPL_PKG)/.PKGINFO ; \
	 echo "distrover=$(PPL_PKG_DISTRO_VERSION)"                >> $(PPL_PKG)/.PKGINFO ; \
	 echo "group=$(PPL_PKG_GROUP)"                             >> $(PPL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(PPL_PKG_SHORT_DESCRIPTION)\"" >> $(PPL_PKG)/.PKGINFO ; \
	 echo "url=$(PPL_PKG_URL)"                                 >> $(PPL_PKG)/.PKGINFO ; \
	 echo "license=$(PPL_PKG_LICENSE)"                         >> $(PPL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(PPL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
