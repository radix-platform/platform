
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
COMPONENT_TARGETS += $(HARDWARE_OKMX6DL_C)
COMPONENT_TARGETS += $(HARDWARE_OKMX6Q_C)
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


SOURCE_REQUIRES    = sources/GNU/libidn

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.28
else
REQUIRES           = libs/glibc/2.28-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.28
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/libidn/libidn-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libidn-$(version)
src_dir_name       = libidn-$(version)
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
LIBIDN_PKG_NAME                = libidn
LIBIDN_PKG_VERSION             = 1.28
LIBIDN_PKG_ARCH                = $(TOOLCHAIN)
LIBIDN_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBIDN_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBIDN_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
LIBIDN_PKG_SHORT_DESCRIPTION   = GNU Internationalized Domain Name library
LIBIDN_PKG_URL                 = $(BUG_URL)
LIBIDN_PKG_LICENSE             = GPLv2
LIBIDN_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBIDN_PKG_NAME)-pkg-description
LIBIDN_PKG_DESCRIPTION_FILE_IN = $(LIBIDN_PKG_NAME)-pkg-description.in
LIBIDN_PKG_INSTALL_SCRIPT      = $(LIBIDN_PKG_NAME)-pkg-install.sh

LIBIDN_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBIDN_PKG_NAME)-package

pkg_basename     = $(LIBIDN_PKG_NAME)-$(LIBIDN_PKG_VERSION)-$(LIBIDN_PKG_ARCH)-$(LIBIDN_PKG_DISTRO_NAME)-$(LIBIDN_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBIDN_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes

extra_configure_switches += --enable-gtk-doc
extra_configure_switches += --enable-gtk-doc-html
extra_configure_switches += ac_cv_path_GTKDOC_CHECK=/usr/bin/gtkdoc-check
extra_configure_switches += ac_cv_path_GTKDOC_REBASE=/usr/bin/gtkdoc-rebase
extra_configure_switches += ac_cv_path_GTKDOC_MKPDF=/usr/bin/gtkdoc-mkpdf


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
	@mkdir -p $(LIBIDN_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(LIBIDN_PKG)/usr/share/info/dir
	@gzip -9 $(LIBIDN_PKG)/usr/share/info/*.info
	@if [ -d $(LIBIDN_PKG)/usr/share/man ]; then \
	  ( cd $(LIBIDN_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBIDN_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* \
	       $(LIBIDN_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBIDN_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a ABOUT-NLS AUTHORS COPYING* FAQ HACKING INSTALL NEWS README* THANKS TODO \
	         contrib doc/libidn.html doc/libidn.pdf doc/*.png \
	         $(LIBIDN_PKG)/usr/share/doc/$(src_dir_name) ; \
	   ln -sf ../../gtk-doc/html/libidn $(LIBIDN_PKG)/usr/share/doc/$(src_dir_name)/html ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBIDN_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBIDN_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libidn.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBIDN_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libidn.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libidn.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libidn.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBIDN_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBIDN_PKG_DESCRIPTION_FILE): $(LIBIDN_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBIDN_PKG_DESCRIPTION_FILE) $(LIBIDN_PKG_INSTALL_SCRIPT)
	@cp $(LIBIDN_PKG_DESCRIPTION_FILE) $(LIBIDN_PKG)/.DESCRIPTION
	@cp $(LIBIDN_PKG_INSTALL_SCRIPT) $(LIBIDN_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBIDN_PKG)/.REQUIRES
	@echo "pkgname=$(LIBIDN_PKG_NAME)"                            >  $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBIDN_PKG_VERSION)"                          >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBIDN_PKG_ARCH)"                               >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBIDN_PKG_DISTRO_NAME)"                  >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBIDN_PKG_DISTRO_VERSION)"                >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "group=$(LIBIDN_PKG_GROUP)"                             >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBIDN_PKG_SHORT_DESCRIPTION)\"" >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "url=$(LIBIDN_PKG_URL)"                                 >> $(LIBIDN_PKG)/.PKGINFO ; \
	 echo "license=$(LIBIDN_PKG_LICENSE)"                         >> $(LIBIDN_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBIDN_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
