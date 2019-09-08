
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_POIN2)
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
COMPONENT_TARGETS += $(HARDWARE_BT1)
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


include ../../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/m/libvdpau

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
endif
REQUIRES          += X11/X.org/lib/libXext/1.3.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/libvdpau/libvdpau-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libvdpau-$(version)
src_dir_name       = libvdpau-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

profile_dir        = $(CURDIR)/profile.d

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

####### Targets

PKG_GROUP = xlibs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LIBVDPAU_PKG_NAME                = libvdpau
LIBVDPAU_PKG_VERSION             = 1.1.1
LIBVDPAU_PKG_ARCH                = $(TOOLCHAIN)
LIBVDPAU_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBVDPAU_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBVDPAU_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBVDPAU_PKG_SHORT_DESCRIPTION   = VDPAU wrapper library
LIBVDPAU_PKG_URL                 = $(BUG_URL)
LIBVDPAU_PKG_LICENSE             = custom
LIBVDPAU_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBVDPAU_PKG_NAME)-pkg-description
LIBVDPAU_PKG_DESCRIPTION_FILE_IN = $(LIBVDPAU_PKG_NAME)-pkg-description.in
LIBVDPAU_PKG_INSTALL_SCRIPT      = $(LIBVDPAU_PKG_NAME)-pkg-install.sh

LIBVDPAU_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBVDPAU_PKG_NAME)-package

pkg_basename     = $(LIBVDPAU_PKG_NAME)-$(LIBVDPAU_PKG_VERSION)-$(LIBVDPAU_PKG_ARCH)-$(LIBVDPAU_PKG_DISTRO_NAME)-$(LIBVDPAU_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_certificate  = $(call cert-name,$(pkg_archive))
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBVDPAU_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=no


CFLAGS += -Wno-deprecated-declarations


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
	@mkdir -p $(LIBVDPAU_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mv $(LIBVDPAU_PKG)/etc/vdpau_wrapper.cfg $(LIBVDPAU_PKG)/etc/vdpau_wrapper.cfg.new
	@mkdir -p $(LIBVDPAU_PKG)/etc/profile.d
	@cp -a $(profile_dir)/vdpau.sh $(LIBVDPAU_PKG)/etc/profile.d/vdpau.sh.new
	@cp -a $(profile_dir)/vdpau.csh $(LIBVDPAU_PKG)/etc/profile.d/vdpau.csh.new
	@chmod 755 $(LIBVDPAU_PKG)/etc/profile.d/*
	# ======= Install Documentation =======
	@if [ -d $(LIBVDPAU_PKG)/usr/share/man ]; then \
	  ( cd $(LIBVDPAU_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBVDPAU_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBVDPAU_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBVDPAU_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING \
	         $(LIBVDPAU_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBVDPAU_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBVDPAU_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvdpau.la ; \
	 )
	@( cd $(LIBVDPAU_PKG)/usr/lib$(LIBSUFFIX)/vdpau ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libvdpau_trace.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBVDPAU_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libvdpau.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvdpau.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/vdpau ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libvdpau_trace.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libvdpau_trace.la ; \
	 )
	# ======= tune pkg-config *.pc but do not touch moduledir variable in vdpau.pc file =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,prefix=/usr,prefix=$(TARGET_DEST_DIR)/usr,g" vdpau.pc ; \
	   sed -i "s,libdir=/usr,libdir=$(TARGET_DEST_DIR)/usr,g" vdpau.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBVDPAU_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBVDPAU_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBVDPAU_PKG_DESCRIPTION_FILE): $(LIBVDPAU_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBVDPAU_PKG_DESCRIPTION_FILE) $(LIBVDPAU_PKG_INSTALL_SCRIPT)
	@cp $(LIBVDPAU_PKG_DESCRIPTION_FILE) $(LIBVDPAU_PKG)/.DESCRIPTION
	@cp $(LIBVDPAU_PKG_INSTALL_SCRIPT) $(LIBVDPAU_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBVDPAU_PKG)/.REQUIRES
	@echo "pkgname=$(LIBVDPAU_PKG_NAME)"                            >  $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBVDPAU_PKG_VERSION)"                          >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBVDPAU_PKG_ARCH)"                               >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBVDPAU_PKG_DISTRO_NAME)"                  >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBVDPAU_PKG_DISTRO_VERSION)"                >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "group=$(LIBVDPAU_PKG_GROUP)"                             >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBVDPAU_PKG_SHORT_DESCRIPTION)\"" >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "url=$(LIBVDPAU_PKG_URL)"                                 >> $(LIBVDPAU_PKG)/.PKGINFO ; \
	 echo "license=$(LIBVDPAU_PKG_LICENSE)"                         >> $(LIBVDPAU_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBVDPAU_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
