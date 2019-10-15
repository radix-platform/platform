
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


SOURCE_REQUIRES    = sources/packages/l/libxslt

REQUIRES           = libs/libxml2/2.9.9
REQUIRES          += net/libgcrypt/1.8.5

# ======= __END_OF_REQUIRES__ =======


version            = 1.1.33
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libxslt/libxslt-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libxslt-$(version)
src_dir_name       = libxslt-$(version)
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
LIBXSLT_PKG_NAME                = libxslt
LIBXSLT_PKG_VERSION             = 1.1.33
LIBXSLT_PKG_ARCH                = $(TOOLCHAIN)
LIBXSLT_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBXSLT_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBXSLT_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBXSLT_PKG_SHORT_DESCRIPTION   = XML transformation library
LIBXSLT_PKG_URL                 = $(BUG_URL)
LIBXSLT_PKG_LICENSE             = custom
LIBXSLT_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBXSLT_PKG_NAME)-pkg-description
LIBXSLT_PKG_DESCRIPTION_FILE_IN = $(LIBXSLT_PKG_NAME)-pkg-description.in
LIBXSLT_PKG_INSTALL_SCRIPT      = $(LIBXSLT_PKG_NAME)-pkg-install.sh

LIBXSLT_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBXSLT_PKG_NAME)-package

pkg_basename     = $(LIBXSLT_PKG_NAME)-$(LIBXSLT_PKG_VERSION)-$(LIBXSLT_PKG_ARCH)-$(LIBXSLT_PKG_DISTRO_NAME)-$(LIBXSLT_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LIBXSLT_PKG)

#
# Path to Python.h
#
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


PYTHON_VERSION = 2.7

ifeq ($(PYTHON_VERSION),2.7)
WITH_PYTHON = $(PYTHON2)
python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES=$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
python_environment += PYTHON_LIBS='$(shell $(TARGET_DEST_DIR)/usr/bin/python$(PYTHON_VERSION)-config --ldflags)'
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)
endif

ifeq ($(PYTHON_VERSION),3.7)
WITH_PYTHON = $(PYTHON3)
python_environment  = PYTHON_VERSION=$(PYTHON_VERSION)
python_environment += PYTHON_SITE_PACKAGES=/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages
python_environment += PYTHON_INCLUDES='$(shell $(TARGET_DEST_DIR)/usr/bin/python$(PYTHON_VERSION)-config --includes)'
python_environment += PYTHON_LIBS='$(shell $(TARGET_DEST_DIR)/usr/bin/python$(PYTHON_VERSION)-config --ldflags)'
CFLAGS += -I$(TARGET_DEST_DIR)/usr/include/python$(PYTHON_VERSION)m
endif


libs_config  = LIBGCRYPT_CONFIG=$(TARGET_DEST_DIR)/usr/bin/libgcrypt-config
libs_config += XML_CONFIG=$(TARGET_DEST_DIR)/usr/bin/xml2-config


TARGET_BIN_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX)
TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; autoreconf -vif )
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(python_environment) $(libs_config) ../$(src_dir_name)/configure \
	  --prefix=/usr                \
	  --build=$(BUILD)             \
	  --host=$(TARGET)             \
	  --with-python=$(WITH_PYTHON) \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) $(python_environment)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LIBXSLT_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBXSLT_PKG)/usr/share/man ]; then \
	  ( cd $(LIBXSLT_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBXSLT_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(LIBXSLT_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBXSLT_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING Copyright FEATURES NEWS README TODO \
	         $(LIBXSLT_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBXSLT_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBXSLT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexslt.la libxslt.la ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" xsltConf.sh ; \
	 )
	@( cd $(LIBXSLT_PKG)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libxsltmod.la ; \
	 )
	# ======= remove toolchain path from target pkg-config *.pc files =======
	@( cd $(LIBXSLT_PKG)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libexslt.pc libxslt.pc ; \
	 )
	# ======= tune xslt-config script for runtime =======
	@( cd $(LIBXSLT_PKG)/usr/bin ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" xslt-config ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBXSLT_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libexslt.la libxslt.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libexslt.la libxslt.la ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   xsltConf.sh ; \
	 )
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/python$(PYTHON_VERSION)/site-packages ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g"   libxsltmod.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libxsltmod.la ; \
	 )
	# ======= tune pkg-config *.pc files to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libexslt.pc libxslt.pc ; \
	 )
	# ======= tune xslt-config script for development =======
	@( cd $(TARGET_DEST_DIR)/usr/bin ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" xslt-config ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBXSLT_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(LIBXSLT_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
ifneq ($(CHRPATH),)
	# ======= Set RPATH/RUNPATH for target binaries =======
	@( cd $(LIBXSLT_PKG)/usr/bin ; \
	   for file in `find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_BIN_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
	# ======= Set RPATH/RUNPATH for target shared objects =======
	@( cd $(LIBXSLT_PKG)/usr/lib$(LIBSUFFIX) ; \
	   for file in `find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs echo` ; do \
	     rpath=`$(CHRPATH) -l $$file 2> /dev/null | grep "R*PATH"` ; \
	     if echo "$$rpath" | grep -q "$(TARGET_DEST_DIR)" ; then \
	       $(CHRPATH) -r $(TARGET_LIB_RPATH) $$file 1> /dev/null 2> /dev/null ; \
	     fi ; \
	   done ; \
	 )
endif
	@touch $@

$(LIBXSLT_PKG_DESCRIPTION_FILE): $(LIBXSLT_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBXSLT_PKG_DESCRIPTION_FILE) $(LIBXSLT_PKG_INSTALL_SCRIPT)
	@cp $(LIBXSLT_PKG_DESCRIPTION_FILE) $(LIBXSLT_PKG)/.DESCRIPTION
	@cp $(LIBXSLT_PKG_INSTALL_SCRIPT) $(LIBXSLT_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBXSLT_PKG)/.REQUIRES
	@echo "pkgname=$(LIBXSLT_PKG_NAME)"                            >  $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBXSLT_PKG_VERSION)"                          >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBXSLT_PKG_ARCH)"                               >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBXSLT_PKG_DISTRO_NAME)"                  >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBXSLT_PKG_DISTRO_VERSION)"                >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "group=$(LIBXSLT_PKG_GROUP)"                             >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBXSLT_PKG_SHORT_DESCRIPTION)\"" >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "url=$(LIBXSLT_PKG_URL)"                                 >> $(LIBXSLT_PKG)/.PKGINFO ; \
	 echo "license=$(LIBXSLT_PKG_LICENSE)"                         >> $(LIBXSLT_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBXSLT_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
