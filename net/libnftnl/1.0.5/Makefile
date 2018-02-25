
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


SOURCE_REQUIRES    = sources/packages/n/libnftnl

REQUIRES           = net/libmnl/1.0.3

# ======= __END_OF_REQUIRES__ =======


version            = 1.0.5
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libnftnl/libnftnl-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libnftnl-$(version)
src_dir_name       = libnftnl-$(version)
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
LIBNFTNL_PKG_NAME                = libnftnl
LIBNFTNL_PKG_VERSION             = 1.0.5
LIBNFTNL_PKG_ARCH                = $(TOOLCHAIN)
LIBNFTNL_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNFTNL_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNFTNL_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBNFTNL_PKG_SHORT_DESCRIPTION   = kernel nf_tables subsystem interface
LIBNFTNL_PKG_URL                 = $(BUG_URL)
LIBNFTNL_PKG_LICENSE             = GPLv2
LIBNFTNL_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNFTNL_PKG_NAME)-pkg-description
LIBNFTNL_PKG_DESCRIPTION_FILE_IN = $(LIBNFTNL_PKG_NAME)-pkg-description.in
LIBNFTNL_PKG_INSTALL_SCRIPT      = $(LIBNFTNL_PKG_NAME)-pkg-install.sh

LIBNFTNL_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNFTNL_PKG_NAME)-package

pkg_basename     = $(LIBNFTNL_PKG_NAME)-$(LIBNFTNL_PKG_VERSION)-$(LIBNFTNL_PKG_ARCH)-$(LIBNFTNL_PKG_DISTRO_NAME)-$(LIBNFTNL_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNFTNL_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBNFTNL_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBNFTNL_PKG)/usr/share/man ]; then \
	  ( cd $(LIBNFTNL_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBNFTNL_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBNFTNL_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBNFTNL_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING \
	         $(LIBNFTNL_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBNFTNL_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNFTNL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnftnl.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNFTNL_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnftnl.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnftnl.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnftnl.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNFTNL_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBNFTNL_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBNFTNL_PKG_DESCRIPTION_FILE): $(LIBNFTNL_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNFTNL_PKG_DESCRIPTION_FILE) $(LIBNFTNL_PKG_INSTALL_SCRIPT)
	@cp $(LIBNFTNL_PKG_DESCRIPTION_FILE) $(LIBNFTNL_PKG)/.DESCRIPTION
	@cp $(LIBNFTNL_PKG_INSTALL_SCRIPT) $(LIBNFTNL_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNFTNL_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNFTNL_PKG_NAME)"                            >  $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNFTNL_PKG_VERSION)"                          >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNFTNL_PKG_ARCH)"                               >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNFTNL_PKG_DISTRO_NAME)"                  >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNFTNL_PKG_DISTRO_VERSION)"                >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNFTNL_PKG_GROUP)"                             >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNFTNL_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNFTNL_PKG_URL)"                                 >> $(LIBNFTNL_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNFTNL_PKG_LICENSE)"                         >> $(LIBNFTNL_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBNFTNL_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
