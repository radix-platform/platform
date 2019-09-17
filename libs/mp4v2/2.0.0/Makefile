
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


SOURCE_REQUIRES    = sources/packages/m/mp4v2

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.27
else
REQUIRES           = libs/glibc/2.27-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/mp4v2/mp4v2-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mp4v2-$(version)
src_dir_name       = mp4v2-$(version)
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
MP4V2_PKG_NAME                = mp4v2
MP4V2_PKG_VERSION             = 2.0.0
MP4V2_PKG_ARCH                = $(TOOLCHAIN)
MP4V2_PKG_DISTRO_NAME         = $(DISTRO_NAME)
MP4V2_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
MP4V2_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
MP4V2_PKG_SHORT_DESCRIPTION   = The MPEG-4 library
MP4V2_PKG_URL                 = $(BUG_URL)
MP4V2_PKG_LICENSE             = MPL
MP4V2_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(MP4V2_PKG_NAME)-pkg-description
MP4V2_PKG_DESCRIPTION_FILE_IN = $(MP4V2_PKG_NAME)-pkg-description.in
MP4V2_PKG_INSTALL_SCRIPT      = $(MP4V2_PKG_NAME)-pkg-install.sh

MP4V2_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(MP4V2_PKG_NAME)-package

pkg_basename     = $(MP4V2_PKG_NAME)-$(MP4V2_PKG_VERSION)-$(MP4V2_PKG_ARCH)-$(MP4V2_PKG_DISTRO_NAME)-$(MP4V2_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(MP4V2_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --disable-gch
extra_configure_switches += --with-pic

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_BIN_RPATH)


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
	@mkdir -p $(MP4V2_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install     $(env_sysroot)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install man $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(MP4V2_PKG)/usr/share/man ]; then \
	  ( cd $(MP4V2_PKG)/usr/share/man ; \
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
	@mkdir -p $(MP4V2_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(MP4V2_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(MP4V2_PKG)/usr/share/doc/$(src_dir_name)/doc
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README \
	         $(MP4V2_PKG)/usr/share/doc/$(src_dir_name) ; \
	   cp -a doc/*.txt \
	         $(MP4V2_PKG)/usr/share/doc/$(src_dir_name)/doc ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(MP4V2_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(MP4V2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libmp4v2.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(MP4V2_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libmp4v2.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libmp4v2.la \
	 )
	# ======= Strip binaries =======
	@( cd $(MP4V2_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(MP4V2_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(MP4V2_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(MP4V2_PKG_DESCRIPTION_FILE): $(MP4V2_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(MP4V2_PKG_DESCRIPTION_FILE) $(MP4V2_PKG_INSTALL_SCRIPT)
	@cp $(MP4V2_PKG_DESCRIPTION_FILE) $(MP4V2_PKG)/.DESCRIPTION
	@cp $(MP4V2_PKG_INSTALL_SCRIPT) $(MP4V2_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(MP4V2_PKG)/.REQUIRES
	@echo "pkgname=$(MP4V2_PKG_NAME)"                            >  $(MP4V2_PKG)/.PKGINFO ; \
	 echo "pkgver=$(MP4V2_PKG_VERSION)"                          >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "arch=$(MP4V2_PKG_ARCH)"                               >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "distroname=$(MP4V2_PKG_DISTRO_NAME)"                  >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "distrover=$(MP4V2_PKG_DISTRO_VERSION)"                >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "group=$(MP4V2_PKG_GROUP)"                             >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(MP4V2_PKG_SHORT_DESCRIPTION)\"" >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "url=$(MP4V2_PKG_URL)"                                 >> $(MP4V2_PKG)/.PKGINFO ; \
	 echo "license=$(MP4V2_PKG_LICENSE)"                         >> $(MP4V2_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(MP4V2_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
