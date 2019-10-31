
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


SOURCE_REQUIRES    = sources/packages/n/gnutls

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/6.5.0
endif
REQUIRES          += libs/libidn/1.28
REQUIRES          += net/p11-kit/0.23.18.1
REQUIRES          += net/nettle/3.5.1
REQUIRES          += dev/guile/2.2.6

# ======= __END_OF_REQUIRES__ =======


version            = 3.6.10
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/n/gnutls/gnutls-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/gnutls-$(version)
src_dir_name       = gnutls-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GNUTLS_PKG_NAME                = gnutls
GNUTLS_PKG_VERSION             = 3.6.10
GNUTLS_PKG_ARCH                = $(TOOLCHAIN)
GNUTLS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GNUTLS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GNUTLS_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
GNUTLS_PKG_SHORT_DESCRIPTION   = GNU TLS library
GNUTLS_PKG_URL                 = $(BUG_URL)
GNUTLS_PKG_LICENSE             = GPLv2.1
GNUTLS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GNUTLS_PKG_NAME)-pkg-description
GNUTLS_PKG_DESCRIPTION_FILE_IN = $(GNUTLS_PKG_NAME)-pkg-description.in
GNUTLS_PKG_INSTALL_SCRIPT      = $(GNUTLS_PKG_NAME)-pkg-install.sh

GNUTLS_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GNUTLS_PKG_NAME)-package

pkg_basename     = $(GNUTLS_PKG_NAME)-$(GNUTLS_PKG_VERSION)-$(GNUTLS_PKG_ARCH)-$(GNUTLS_PKG_DISTRO_NAME)-$(GNUTLS_PKG_DISTRO_VERSION)

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


env_sysroot  = DESTDIR=$(GNUTLS_PKG)


ENABLE_GTK_DOCUMENTATION  = no

extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-openssl-compatibility
extra_configure_switches += --disable-rpath

extra_configure_switches += --enable-static=no
extra_configure_switches += --enable-shared=yes

ifeq ($(ENABLE_GTK_DOCUMENTATION),yes)
#
# same result but longer:
#
extra_configure_switches += --enable-gtk-doc
extra_configure_switches += --enable-gtk-doc-html
endif

# Тhе road to hellis paved with good intentions:
extra_configure_switches += --without-libnettle-prefix


#
#  NOTE:
# =======================================================================================
#
#  Guile compiles to bytecode for a custom virtual machine. Guile 2.2 compiles to ELF.
#  In the future they want to do native compilation. But now Guile 2.2's ELF contains
#  byte code for Guile's virtual machine.
#
#     see: https://www.gnu.org/software/guile/manual/html_node/Object-File-Format.html
#
#  The *.go shared object files should be excluded during sptrip/patch ELF procedure.
#  Currently to exclude Guile's object files we use following filter:
#
#      grep "shared object" | grep -v "no machine" | grep ELF
#                            ----------------------
#
# =======================================================================================
#


GUILE_EFFECTIVE_VERSION = 2.2

#
# Enable Guile extension if Guile 2.2 is installed on a build machile:
# -------------------------------------------------------------------
# NOTE:
#   that gnutls with Guile extension also should be installed
#   on build machine.
#
ifneq ($(wildcard /usr/lib$(BUILD_MULTILIB_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)),)
extra_configure_switches += --enable-guile
extra_configure_switches += --with-guile-site-dir=/usr/share/guile/site/$(GUILE_EFFECTIVE_VERSION)
extra_configure_switches += --with-guile-site-ccache-dir=/usr/lib$(LIBSUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache
extra_configure_switches += --with-guile-extension-dir=/usr/lib$(LIBSUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions

guile_environment  = guile_snarf=$(TARGET_DEST_DIR)/usr/bin/guile-snarf
guile_environment += GUILE_EXTENSION_DIR_FOR_BUILD=/usr/lib$(BUILD_MULTILIB_SUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)
else
extra_configure_switches += --enable-guile=no
endif


LDFLAGS += -Wl,-rpath,/lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(guile_environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	# ======= Disable parallel buildig the docunentation =======
	@( cd $(build_dir)/doc ; \
	   sed -i -e '/^all: /i\\' -e '/^all: /i.NOTPARALLEL: all\n' Makefile ; \
	 )
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) V=1 $(MAKE) $(guile_environment) -j1
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(GNUTLS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(guile_environment) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(GNUTLS_PKG)/usr/share/info/dir
	@gzip -9 $(GNUTLS_PKG)/usr/share/info/*.info*
	@if [ -d $(GNUTLS_PKG)/usr/share/man ]; then \
	  ( cd $(GNUTLS_PKG)/usr/share/man ; \
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
	@mkdir -p $(GNUTLS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/LICENSE $(SRC_DIR)/doc/COPYING* \
	       $(GNUTLS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(GNUTLS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS LICENSE doc/COPYING* INSTALL.md \
	         README.md RELEASES.md THANKS doc/gnutls-guile.html doc/gnutls.html \
	         $(GNUTLS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
ifneq ($(ENABLE_GTK_DOCUMENTATION),yes)
	@mkdir -p $(GNUTLS_PKG)/usr/share/gtk-doc/html/gnutls
	@( cd $(SRC_DIR)/doc/reference/html ; \
	   cp -a *.html *.css *.png *.devhelp2 \
	         $(GNUTLS_PKG)/usr/share/gtk-doc/html/gnutls ; \
	 )
endif
	@ln -sf ../../gtk-doc/html/gnutls $(GNUTLS_PKG)/usr/share/doc/$(src_dir_name)/html
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GNUTLS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r NEWS ]; then \
	     DOCSDIR=`echo $(GNUTLS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat NEWS | head -n 1000 > $$DOCSDIR/NEWS ; \
	     touch -r NEWS $$DOCSDIR/NEWS ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(GNUTLS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libgnutls-openssl.la libgnutls.la libgnutlsxx.la ; \
	 )
	@( cd $(GNUTLS_PKG)/usr/lib$(LIBSUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" guile-gnutls-v-?.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GNUTLS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libgnutls-openssl.la libgnutls.la libgnutlsxx.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libgnutls-openssl.la libgnutls.la libgnutlsxx.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/guile/$(GUILE_EFFECTIVE_VERSION)/extensions ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   guile-gnutls-v-?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" guile-gnutls-v-?.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" gnutls.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(GNUTLS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep -v "no machine" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(GNUTLS_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(GNUTLS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep -v "no machine" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(GNUTLS_PKG_DESCRIPTION_FILE): $(GNUTLS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GNUTLS_PKG_DESCRIPTION_FILE) $(GNUTLS_PKG_INSTALL_SCRIPT)
	@cp $(GNUTLS_PKG_DESCRIPTION_FILE) $(GNUTLS_PKG)/.DESCRIPTION
	@cp $(GNUTLS_PKG_INSTALL_SCRIPT) $(GNUTLS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GNUTLS_PKG)/.REQUIRES
	@echo "pkgname=$(GNUTLS_PKG_NAME)"                            >  $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GNUTLS_PKG_VERSION)"                          >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "arch=$(GNUTLS_PKG_ARCH)"                               >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "distroname=$(GNUTLS_PKG_DISTRO_NAME)"                  >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "distrover=$(GNUTLS_PKG_DISTRO_VERSION)"                >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "group=$(GNUTLS_PKG_GROUP)"                             >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GNUTLS_PKG_SHORT_DESCRIPTION)\"" >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "url=$(GNUTLS_PKG_URL)"                                 >> $(GNUTLS_PKG)/.PKGINFO ; \
	 echo "license=$(GNUTLS_PKG_LICENSE)"                         >> $(GNUTLS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GNUTLS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
