
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


SOURCE_REQUIRES    = sources/packages/l/poppler

REQUIRES           = libs/poppler-data/0.4.7
REQUIRES          += X11/libs/harfbuzz/1.2.7
REQUIRES          += libs/lcms2/2.7
REQUIRES          += net/curl/7.47.0
REQUIRES          += app/openjpeg2/2.1.2
REQUIRES          += X11/libs/qt4/4.8.7
REQUIRES          += X11/libs/qt5/5.7.1

# ======= __END_OF_REQUIRES__ =======


version            = 0.45.0
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/poppler/poppler-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/poppler-$(version)
src_dir_name       = poppler-$(version)
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
POPPLER_PKG_NAME                = poppler
POPPLER_PKG_VERSION             = 0.45.0
POPPLER_PKG_ARCH                = $(TOOLCHAIN)
POPPLER_PKG_DISTRO_NAME         = $(DISTRO_NAME)
POPPLER_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
POPPLER_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
POPPLER_PKG_SHORT_DESCRIPTION   = a library for rendering PDF documents
POPPLER_PKG_URL                 = $(BUG_URL)
POPPLER_PKG_LICENSE             = GPLv2
POPPLER_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(POPPLER_PKG_NAME)-pkg-description
POPPLER_PKG_DESCRIPTION_FILE_IN = $(POPPLER_PKG_NAME)-pkg-description.in
POPPLER_PKG_INSTALL_SCRIPT      = $(POPPLER_PKG_NAME)-pkg-install.sh

POPPLER_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(POPPLER_PKG_NAME)-package

pkg_basename     = $(POPPLER_PKG_NAME)-$(POPPLER_PKG_VERSION)-$(POPPLER_PKG_ARCH)-$(POPPLER_PKG_DISTRO_NAME)-$(POPPLER_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(POPPLER_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-cairo-output
extra_configure_switches += --enable-xpdf-headers
extra_configure_switches += --enable-libjpeg
extra_configure_switches += --enable-zlib
extra_configure_switches += --enable-libcurl
extra_configure_switches += --enable-cms=lcms2
extra_configure_switches += --enable-libopenjpeg=openjpeg2
extra_configure_switches += --enable-poppler-glib
extra_configure_switches += --with-font-configuration=fontconfig

extra_configure_switches += --enable-poppler-qt4=yes
extra_configure_switches += --enable-poppler-qt5=yes

extra_configure_switches += --disable-libopenjpeg

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --enable-introspection=no
extra_configure_switches += --disable-gtk-test

environment  = MOCQT4=$(TARGET_DEST_DIR)/usr/bin/$(TARGET)-moc
environment += MOCQT52=$(TARGET_DEST_DIR)/usr/bin/$(TARGET)-qt5-moc


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


CXXFLAGS += -std=c++11


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(POPPLER_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(POPPLER_PKG)/usr/share/man ]; then \
	  ( cd $(POPPLER_PKG)/usr/share/man ; \
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
	@mkdir -p $(POPPLER_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(POPPLER_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(POPPLER_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING INSTALL NEWS README* TODO \
	         $(POPPLER_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(POPPLER_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(POPPLER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libpoppler-cpp.la libpoppler-glib.la  \
	                                    libpoppler-qt4.la libpoppler-qt5.la   \
	                                    libpoppler.la                       ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(POPPLER_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libpoppler-cpp.la libpoppler-glib.la  \
	                                            libpoppler-qt4.la libpoppler-qt5.la   \
	                                            libpoppler.la                       ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libpoppler-cpp.la libpoppler-glib.la  \
	                                              libpoppler-qt4.la libpoppler-qt5.la   \
	                                              libpoppler.la                       ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" poppler-cairo.pc poppler-cpp.pc   \
	                                            poppler-glib.pc poppler-qt4.pc    \
	                                            poppler-qt5.pc poppler-splash.pc  \
	                                            poppler.pc                      ; \
	 )
	# ======= Strip binaries =======
	@( cd $(POPPLER_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(POPPLER_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(POPPLER_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(POPPLER_PKG_DESCRIPTION_FILE): $(POPPLER_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(POPPLER_PKG_DESCRIPTION_FILE) $(POPPLER_PKG_INSTALL_SCRIPT)
	@cp $(POPPLER_PKG_DESCRIPTION_FILE) $(POPPLER_PKG)/.DESCRIPTION
	@cp $(POPPLER_PKG_INSTALL_SCRIPT) $(POPPLER_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(POPPLER_PKG)/.REQUIRES
	@echo "pkgname=$(POPPLER_PKG_NAME)"                            >  $(POPPLER_PKG)/.PKGINFO ; \
	 echo "pkgver=$(POPPLER_PKG_VERSION)"                          >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "arch=$(POPPLER_PKG_ARCH)"                               >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "distroname=$(POPPLER_PKG_DISTRO_NAME)"                  >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "distrover=$(POPPLER_PKG_DISTRO_VERSION)"                >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "group=$(POPPLER_PKG_GROUP)"                             >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(POPPLER_PKG_SHORT_DESCRIPTION)\"" >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "url=$(POPPLER_PKG_URL)"                                 >> $(POPPLER_PKG)/.PKGINFO ; \
	 echo "license=$(POPPLER_PKG_LICENSE)"                         >> $(POPPLER_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(POPPLER_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
