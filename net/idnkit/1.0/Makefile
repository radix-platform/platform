
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


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/idnkit

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.25
else
REQUIRES           = libs/glibc/2.25-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.0
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/n/idnkit/idnkit-$(version)-src.tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/idnkit-$(version)-src
src_dir_name       = idnkit-$(version)-src
doc_dir_name       = idnkit-$(version)
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
IDNKIT_PKG_NAME                = idnkit
IDNKIT_PKG_VERSION             = 1.0
IDNKIT_PKG_ARCH                = $(TOOLCHAIN)
IDNKIT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
IDNKIT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
IDNKIT_PKG_GROUP               = $(PKG_GROUP)
###                             |---handy-ruler-------------------------------|
IDNKIT_PKG_SHORT_DESCRIPTION   = Internationalized domain names toolkit
IDNKIT_PKG_URL                 = $(BUG_URL)
IDNKIT_PKG_LICENSE             = custom
IDNKIT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(IDNKIT_PKG_NAME)-pkg-description
IDNKIT_PKG_DESCRIPTION_FILE_IN = $(IDNKIT_PKG_NAME)-pkg-description.in
IDNKIT_PKG_INSTALL_SCRIPT      = $(IDNKIT_PKG_NAME)-pkg-install.sh

IDNKIT_PKG       = $(CURDIR)/$(TARGET_BUILD_DIR)/$(IDNKIT_PKG_NAME)-package

pkg_basename     = $(IDNKIT_PKG_NAME)-$(IDNKIT_PKG_VERSION)-$(IDNKIT_PKG_ARCH)-$(IDNKIT_PKG_DISTRO_NAME)-$(IDNKIT_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(IDNKIT_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(IDNKIT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(IDNKIT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 0755 *.la *.so.?.* ; \
	 )
	# ======= Since idnkit appears to work here without configuration =======
	# ======= files installed, we will only install these as *.sample =======
	@rm -f $(IDNKIT_PKG)/etc/*.conf
	# ======= Install Documentation =======
	@if [ -d $(IDNKIT_PKG)/usr/share/man ]; then \
	  ( cd $(IDNKIT_PKG)/usr/share/man ; \
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
	@mkdir -p $(IDNKIT_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/LICENSE.txt \
	       $(IDNKIT_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(IDNKIT_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL* LICENSE.txt NEWS README* \
	       $(IDNKIT_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(IDNKIT_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(IDNKIT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libidnkit.la libidnkitlite.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(IDNKIT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libidnkit.la libidnkitlite.la  ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libidnkit.la libidnkitlite.la  \
	 )
	# ======= Strip binaries =======
	@( cd $(IDNKIT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(IDNKIT_PKG_DESCRIPTION_FILE): $(IDNKIT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(IDNKIT_PKG_DESCRIPTION_FILE) $(IDNKIT_PKG_INSTALL_SCRIPT)
	@cp $(IDNKIT_PKG_DESCRIPTION_FILE) $(IDNKIT_PKG)/.DESCRIPTION
	@cp $(IDNKIT_PKG_INSTALL_SCRIPT) $(IDNKIT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(IDNKIT_PKG)/.REQUIRES
	@echo "pkgname=$(IDNKIT_PKG_NAME)"                            >  $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(IDNKIT_PKG_VERSION)"                          >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "arch=$(IDNKIT_PKG_ARCH)"                               >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "distroname=$(IDNKIT_PKG_DISTRO_NAME)"                  >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "distrover=$(IDNKIT_PKG_DISTRO_VERSION)"                >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "group=$(IDNKIT_PKG_GROUP)"                             >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(IDNKIT_PKG_SHORT_DESCRIPTION)\"" >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "url=$(IDNKIT_PKG_URL)"                                 >> $(IDNKIT_PKG)/.PKGINFO ; \
	 echo "license=$(IDNKIT_PKG_LICENSE)"                         >> $(IDNKIT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(IDNKIT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
