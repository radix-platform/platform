
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP2E)
COMPONENT_TARGETS += $(HARDWARE_NANOPI_NEO)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PP)
COMPONENT_TARGETS += $(HARDWARE_ORANGE_PL2)
COMPONENT_TARGETS += $(HARDWARE_WECHIP_TX6)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
COMPONENT_TARGETS += $(HARDWARE_RK3328_CC)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_EDGE)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_P201)
COMPONENT_TARGETS += $(HARDWARE_NEXBOX_A95X)
COMPONENT_TARGETS += $(HARDWARE_ODROID_C2)
COMPONENT_TARGETS += $(HARDWARE_P212)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM)
COMPONENT_TARGETS += $(HARDWARE_Q201)
COMPONENT_TARGETS += $(HARDWARE_ENYBOX_X2)
COMPONENT_TARGETS += $(HARDWARE_KHADAS_VIM2)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)
COMPONENT_TARGETS += $(HARDWARE_MBC4_PC)
COMPONENT_TARGETS += $(HARDWARE_S824L)
COMPONENT_TARGETS += $(HARDWARE_VESNIN)
COMPONENT_TARGETS += $(HARDWARE_S824L_LSB)
COMPONENT_TARGETS += $(HARDWARE_VESNIN_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2)
COMPONENT_TARGETS += $(HARDWARE_TL2WK2_LSB)
COMPONENT_TARGETS += $(HARDWARE_TL2SV2_LSB)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/freetype

REQUIRES           = app/bzip2/1.0.6
REQUIRES          += libs/harfbuzz/0.9.36

# ======= __END_OF_REQUIRES__ =======


version            = 2.5.3
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/freetype/freetype-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/freetype-$(version)
src_dir_name       = freetype-$(version)
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
FREETYPE_PKG_NAME                = freetype
FREETYPE_PKG_VERSION             = 2.5.3
FREETYPE_PKG_ARCH                = $(TOOLCHAIN)
FREETYPE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FREETYPE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FREETYPE_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
FREETYPE_PKG_SHORT_DESCRIPTION   = High-Quality and Portable Font Engine
FREETYPE_PKG_URL                 = $(BUG_URL)
FREETYPE_PKG_LICENSE             = GPLv2
FREETYPE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FREETYPE_PKG_NAME)-pkg-description
FREETYPE_PKG_DESCRIPTION_FILE_IN = $(FREETYPE_PKG_NAME)-pkg-description.in
FREETYPE_PKG_INSTALL_SCRIPT      = $(FREETYPE_PKG_NAME)-pkg-install.sh

FREETYPE_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FREETYPE_PKG_NAME)-package

pkg_basename     = $(FREETYPE_PKG_NAME)-$(FREETYPE_PKG_VERSION)-$(FREETYPE_PKG_ARCH)-$(FREETYPE_PKG_DISTRO_NAME)-$(FREETYPE_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FREETYPE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-harfbuzz=yes
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(FREETYPE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(FREETYPE_PKG)/usr/include ; ln -sf freetype2 freetype ; )
	# ======= Install Documentation =======
	@if [ -d $(FREETYPE_PKG)/usr/share/man ]; then \
	  ( cd $(FREETYPE_PKG)/usr/share/man ; \
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
	@mkdir -p $(FREETYPE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/docs/FTL.TXT $(SRC_DIR)/docs/GPLv2.TXT $(SRC_DIR)/docs/LICENSE.TXT \
	       $(FREETYPE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR)/docs ; \
	   cp -a ../README* \
	         CHANGES CUSTOMIZE DEBUG INSTALL* \
	         PROBLEMS TODO VERSION.DLL *.txt  \
	         FTL.TXT GPLv2.TXT LICENSE.TXT    \
	         $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR)/docs/reference ; \
	   cp -a *.html $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FREETYPE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FREETYPE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfreetype.la ; \
	 )
	# ======= remove toolchain path from target freetype-config script =======
	@( cd $(FREETYPE_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" freetype-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FREETYPE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfreetype.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfreetype.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" freetype?.pc \
	 )
	# ======= tune freetype-config script search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i 's,="/usr,="$(TARGET_DEST_DIR)/usr,g' freetype-config ; \
	   sed -i 's,L/usr,L$(TARGET_DEST_DIR)/usr,g' freetype-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(FREETYPE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(FREETYPE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(FREETYPE_PKG_DESCRIPTION_FILE): $(FREETYPE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FREETYPE_PKG_DESCRIPTION_FILE) $(FREETYPE_PKG_INSTALL_SCRIPT)
	@cp $(FREETYPE_PKG_DESCRIPTION_FILE) $(FREETYPE_PKG)/.DESCRIPTION
	@cp $(FREETYPE_PKG_INSTALL_SCRIPT) $(FREETYPE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FREETYPE_PKG)/.REQUIRES
	@echo "pkgname=$(FREETYPE_PKG_NAME)"                            >  $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FREETYPE_PKG_VERSION)"                          >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "arch=$(FREETYPE_PKG_ARCH)"                               >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "distroname=$(FREETYPE_PKG_DISTRO_NAME)"                  >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "distrover=$(FREETYPE_PKG_DISTRO_VERSION)"                >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "group=$(FREETYPE_PKG_GROUP)"                             >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FREETYPE_PKG_SHORT_DESCRIPTION)\"" >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "url=$(FREETYPE_PKG_URL)"                                 >> $(FREETYPE_PKG)/.PKGINFO ; \
	 echo "license=$(FREETYPE_PKG_LICENSE)"                         >> $(FREETYPE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FREETYPE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
