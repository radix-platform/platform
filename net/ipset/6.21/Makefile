
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


SOURCE_REQUIRES    = sources/packages/n/ipset

REQUIRES           = net/libmnl/1.0.3

# ======= __END_OF_REQUIRES__ =======


version            = 6.21
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/ipset/ipset-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/ipset-$(version)
src_dir_name       = ipset-$(version)
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
IPSET_PKG_NAME                = ipset
IPSET_PKG_VERSION             = 6.21
IPSET_PKG_ARCH                = $(TOOLCHAIN)
IPSET_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IPSET_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IPSET_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
IPSET_PKG_SHORT_DESCRIPTION   = administration tool for kernel IP sets
IPSET_PKG_URL                 = $(BUG_URL)
IPSET_PKG_LICENSE             = GPLv2
IPSET_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IPSET_PKG_NAME)-pkg-description
IPSET_PKG_DESCRIPTION_FILE_IN = $(IPSET_PKG_NAME)-pkg-description.in
IPSET_PKG_INSTALL_SCRIPT      = $(IPSET_PKG_NAME)-pkg-install.sh

IPSET_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IPSET_PKG_NAME)-package

pkg_basename     = $(IPSET_PKG_NAME)-$(IPSET_PKG_VERSION)-$(IPSET_PKG_ARCH)-$(IPSET_PKG_DISTRO_NAME)-$(IPSET_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IPSET_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
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
	@mkdir -p $(IPSET_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(IPSET_PKG)/usr/share/man ]; then \
	  ( cd $(IPSET_PKG)/usr/share/man ; \
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
	@mkdir -p $(IPSET_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(IPSET_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(IPSET_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING ChangeLog.ippool INSTALL README UPGRADE \
	         $(IPSET_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IPSET_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IPSET_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libipset.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IPSET_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libipset.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libipset.la  \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libipset.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(IPSET_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(IPSET_PKG)/usr/sbin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(IPSET_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(IPSET_PKG_DESCRIPTION_FILE): $(IPSET_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IPSET_PKG_DESCRIPTION_FILE) $(IPSET_PKG_INSTALL_SCRIPT)
	@cp $(IPSET_PKG_DESCRIPTION_FILE) $(IPSET_PKG)/.DESCRIPTION
	@cp $(IPSET_PKG_INSTALL_SCRIPT) $(IPSET_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IPSET_PKG)/.REQUIRES
	@echo "pkgname=$(IPSET_PKG_NAME)"                            >  $(IPSET_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IPSET_PKG_VERSION)"                          >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "arch=$(IPSET_PKG_ARCH)"                               >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "distroname=$(IPSET_PKG_DISTRO_NAME)"                  >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "distrover=$(IPSET_PKG_DISTRO_VERSION)"                >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "group=$(IPSET_PKG_GROUP)"                             >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IPSET_PKG_SHORT_DESCRIPTION)\"" >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "url=$(IPSET_PKG_URL)"                                 >> $(IPSET_PKG)/.PKGINFO ; \
	 echo "license=$(IPSET_PKG_LICENSE)"                         >> $(IPSET_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IPSET_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
