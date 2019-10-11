
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


SOURCE_REQUIRES    = sources/packages/l/libcap-ng

REQUIRES           = dev/python2/2.7.16
REQUIRES          += dev/python3/3.7.4

# ======= __END_OF_REQUIRES__ =======


version            = 0.7.10
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libcap-ng/libcap-ng-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libcap-ng-$(version)
src_dir_name       = libcap-ng-$(version)
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
LIBCAPNG_PKG_NAME                = libcap-ng
LIBCAPNG_PKG_VERSION             = 0.7.10
LIBCAPNG_PKG_ARCH                = $(TOOLCHAIN)
LIBCAPNG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBCAPNG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBCAPNG_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
LIBCAPNG_PKG_SHORT_DESCRIPTION   = capabilities library and utilities
LIBCAPNG_PKG_URL                 = $(BUG_URL)
LIBCAPNG_PKG_LICENSE             = GPLv2
LIBCAPNG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBCAPNG_PKG_NAME)-pkg-description
LIBCAPNG_PKG_DESCRIPTION_FILE_IN = $(LIBCAPNG_PKG_NAME)-pkg-description.in
LIBCAPNG_PKG_INSTALL_SCRIPT      = $(LIBCAPNG_PKG_NAME)-pkg-install.sh

LIBCAPNG_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBCAPNG_PKG_NAME)-package

pkg_basename     = $(LIBCAPNG_PKG_NAME)-$(LIBCAPNG_PKG_VERSION)-$(LIBCAPNG_PKG_ARCH)-$(LIBCAPNG_PKG_DISTRO_NAME)-$(LIBCAPNG_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBCAPNG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --with-python
extra_configure_switches += --with-python3
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


PYTHON_VERSION = 2.7

python_config  = PYTHON=$(PYTHON2)
python_config += am_cv_python_version=$(PYTHON_VERSION)
python_config += am_cv_python_platform=linux2
python_config += am_cv_python_pythondir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_config += am_cv_python_pyexecdir=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_config += PYINCLUDEDIR=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)

#
# PYTHON3 configuring by python3-config script:
#
PYTHON3_VERSION = 3.7

python_config  += PYTHON3=$(PYTHON3)
python_config  += PATH=$(TARGET_DEST_DIR)/usr/bin:$(PATH)
python_config  += PYTHON3_DIR=/usr/lib$(LIBSUFFIX)/python$(PYTHON3_VERSION)/site-packages
python_config  += PYTHON3_EXECDIR=/usr/lib$(LIBSUFFIX)/python$(PYTHON3_VERSION)/site-packages


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   find . -exec touch -t 201903190437.43 {} \; \
	 )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) $(python_config) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBCAPNG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(python_environment) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(LIBCAPNG_PKG)/lib$(LIBSUFFIX)
	@( cd $(LIBCAPNG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   cp -a libcap-ng.so.0  $(LIBCAPNG_PKG)/lib$(LIBSUFFIX) ; \
	   mv libcap-ng.so.0.?.? $(LIBCAPNG_PKG)/lib$(LIBSUFFIX) ; \
	   ln -sf ../../lib$(LIBSUFFIX)/libcap-ng.so.0.?.? . ; \
	   ln -sf libcap-ng.so.0.?.? libcap-ng.so ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(LIBCAPNG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBCAPNG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBCAPNG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING* $(SRC_DIR)/LICENSE \
	       $(LIBCAPNG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBCAPNG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* LICENSE NEWS README* TODO \
	         $(LIBCAPNG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBCAPNG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBCAPNG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcap-ng.la ; \
	 )
	@( cd $(LIBCAPNG_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _capng.la ; \
	 )
	@( cd $(LIBCAPNG_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON3_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" _capng.la ; \
	 )
	# ======= remove TARGET_DEST_DIR from pkg-config *.pc files =======
	@( cd $(LIBCAPNG_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libcap-ng.pc ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBCAPNG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libcap-ng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libcap-ng.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _capng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _capng.la ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON3_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" _capng.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" _capng.la ; \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,=/usr,=$(TARGET_DEST_DIR)/usr,g" libcap-ng.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBCAPNG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBCAPNG_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(LIBCAPNG_PKG_DESCRIPTION_FILE): $(LIBCAPNG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBCAPNG_PKG_DESCRIPTION_FILE) $(LIBCAPNG_PKG_INSTALL_SCRIPT)
	@cp $(LIBCAPNG_PKG_DESCRIPTION_FILE) $(LIBCAPNG_PKG)/.DESCRIPTION
	@cp $(LIBCAPNG_PKG_INSTALL_SCRIPT) $(LIBCAPNG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBCAPNG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBCAPNG_PKG_NAME)"                            >  $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBCAPNG_PKG_VERSION)"                          >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBCAPNG_PKG_ARCH)"                               >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBCAPNG_PKG_DISTRO_NAME)"                  >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBCAPNG_PKG_DISTRO_VERSION)"                >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBCAPNG_PKG_GROUP)"                             >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBCAPNG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBCAPNG_PKG_URL)"                                 >> $(LIBCAPNG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBCAPNG_PKG_LICENSE)"                         >> $(LIBCAPNG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBCAPNG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
