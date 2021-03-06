
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


SOURCE_REQUIRES    = sources/packages/l/libstrophe

REQUIRES           = libs/expat/2.1.1
REQUIRES          += net/openssl/1.0.2f

# ======= __END_OF_REQUIRES__ =======


version            = 0.9.1
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libstrophe/libstrophe-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libstrophe-$(version)
src_dir_name       = libstrophe-$(version)
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
LIBSTROPHE_PKG_NAME                = libstrophe
LIBSTROPHE_PKG_VERSION             = 0.9.1
LIBSTROPHE_PKG_ARCH                = $(TOOLCHAIN)
LIBSTROPHE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBSTROPHE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBSTROPHE_PKG_GROUP               = $(PKG_GROUP)
###                                 |---handy-ruler-------------------------------|
LIBSTROPHE_PKG_SHORT_DESCRIPTION   = An XMPP library for C
LIBSTROPHE_PKG_URL                 = $(BUG_URL)
LIBSTROPHE_PKG_LICENSE             = GPLv3
LIBSTROPHE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBSTROPHE_PKG_NAME)-pkg-description
LIBSTROPHE_PKG_DESCRIPTION_FILE_IN = $(LIBSTROPHE_PKG_NAME)-pkg-description.in
LIBSTROPHE_PKG_INSTALL_SCRIPT      = $(LIBSTROPHE_PKG_NAME)-pkg-install.sh

LIBSTROPHE_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBSTROPHE_PKG_NAME)-package

pkg_basename       = $(LIBSTROPHE_PKG_NAME)-$(LIBSTROPHE_PKG_VERSION)-$(LIBSTROPHE_PKG_ARCH)-$(LIBSTROPHE_PKG_DISTRO_NAME)-$(LIBSTROPHE_PKG_DISTRO_VERSION)

pkg_archive        = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature      = $(call sign-name,$(pkg_archive))
pkg_description    = $(call desc-name,$(pkg_archive))
products           = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS      = $(build_target)
BUILD_TARGETS     += $(install_target)

PRODUCT_TARGETS    = $(products)

ROOTFS_TARGETS     = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBSTROPHE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
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
	@mkdir -p $(LIBSTROPHE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBSTROPHE_PKG)/usr/share/man ]; then \
	  ( cd $(LIBSTROPHE_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBSTROPHE_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING GPL-LICENSE.txt LICENSE.txt MIT-LICENSE.txt \
	       $(LIBSTROPHE_PKG)/usr/doc/$(src_dir_name) ; \
	 )
	@mkdir -p $(LIBSTROPHE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING GPL-LICENSE.txt LICENSE.txt MIT-LICENSE.txt \
	         README README.markdown \
	         $(LIBSTROPHE_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog -a -s ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBSTROPHE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBSTROPHE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libstrophe.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBSTROPHE_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstrophe.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libstrophe.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libstrophe.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBSTROPHE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBSTROPHE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBSTROPHE_PKG_DESCRIPTION_FILE): $(LIBSTROPHE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBSTROPHE_PKG_DESCRIPTION_FILE) $(LIBSTROPHE_PKG_INSTALL_SCRIPT)
	@cp $(LIBSTROPHE_PKG_DESCRIPTION_FILE) $(LIBSTROPHE_PKG)/.DESCRIPTION
	@cp $(LIBSTROPHE_PKG_INSTALL_SCRIPT) $(LIBSTROPHE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBSTROPHE_PKG)/.REQUIRES
	@echo "pkgname=$(LIBSTROPHE_PKG_NAME)"                            >  $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBSTROPHE_PKG_VERSION)"                          >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBSTROPHE_PKG_ARCH)"                               >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBSTROPHE_PKG_DISTRO_NAME)"                  >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBSTROPHE_PKG_DISTRO_VERSION)"                >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "group=$(LIBSTROPHE_PKG_GROUP)"                             >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBSTROPHE_PKG_SHORT_DESCRIPTION)\"" >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "url=$(LIBSTROPHE_PKG_URL)"                                 >> $(LIBSTROPHE_PKG)/.PKGINFO ; \
	 echo "license=$(LIBSTROPHE_PKG_LICENSE)"                         >> $(LIBSTROPHE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBSTROPHE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
