
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


SOURCE_REQUIRES    = sources/packages/l/libjpeg-turbo

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.24
else
REQUIRES           = libs/glibc/2.24-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 1.3.1
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/l/libjpeg-turbo/libjpeg-turbo-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libjpeg-turbo-$(version)
src_dir_name       = libjpeg-turbo-$(version)
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
LIBJPEG_PKG_NAME                = libjpeg-turbo
LIBJPEG_PKG_VERSION             = 1.3.1
LIBJPEG_PKG_ARCH                = $(TOOLCHAIN)
LIBJPEG_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBJPEG_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBJPEG_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
LIBJPEG_PKG_SHORT_DESCRIPTION   = JPEG image codec
LIBJPEG_PKG_URL                 = $(BUG_URL)
LIBJPEG_PKG_LICENSE             = BSD
LIBJPEG_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBJPEG_PKG_NAME)-pkg-description
LIBJPEG_PKG_DESCRIPTION_FILE_IN = $(LIBJPEG_PKG_NAME)-pkg-description.in
LIBJPEG_PKG_INSTALL_SCRIPT      = $(LIBJPEG_PKG_NAME)-pkg-install.sh

LIBJPEG_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBJPEG_PKG_NAME)-package

pkg_basename     = $(LIBJPEG_PKG_NAME)-$(LIBJPEG_PKG_VERSION)-$(LIBJPEG_PKG_ARCH)-$(LIBJPEG_PKG_DISTRO_NAME)-$(LIBJPEG_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(LIBJPEG_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --with-jpeg8
extra_configure_switches += --enable-shared=yes
extra_configure_switches += --enable-static=yes


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
	@mkdir -p $(LIBJPEG_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(SRC_DIR) ; chmod a-x *.txt )
	# ======= Install Documentation =======
	@if [ -d $(LIBJPEG_PKG)/usr/share/man ]; then \
	  ( cd $(LIBJPEG_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBJPEG_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/README* \
	       $(LIBJPEG_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBJPEG_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(LIBJPEG_PKG)/usr/share/doc ; \
	   mv README *.{c,txt} $(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   cp -a BUILDING.txt \
	         $(LIBJPEG_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog.txt ]; then \
	     DOCSDIR=`echo $(LIBJPEG_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog.txt | head -n 1000 > $$DOCSDIR/ChangeLog.txt ; \
	     touch -r ChangeLog.txt $$DOCSDIR/ChangeLog.txt ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBJPEG_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libjpeg.la libturbojpeg.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBJPEG_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libjpeg.la libturbojpeg.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libjpeg.la libturbojpeg.la \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBJPEG_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBJPEG_PKG_DESCRIPTION_FILE): $(LIBJPEG_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBJPEG_PKG_DESCRIPTION_FILE) $(LIBJPEG_PKG_INSTALL_SCRIPT)
	@cp $(LIBJPEG_PKG_DESCRIPTION_FILE) $(LIBJPEG_PKG)/.DESCRIPTION
	@cp $(LIBJPEG_PKG_INSTALL_SCRIPT) $(LIBJPEG_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBJPEG_PKG)/.REQUIRES
	@echo "pkgname=$(LIBJPEG_PKG_NAME)"                            >  $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBJPEG_PKG_VERSION)"                          >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBJPEG_PKG_ARCH)"                               >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBJPEG_PKG_DISTRO_NAME)"                  >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBJPEG_PKG_DISTRO_VERSION)"                >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "group=$(LIBJPEG_PKG_GROUP)"                             >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBJPEG_PKG_SHORT_DESCRIPTION)\"" >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "url=$(LIBJPEG_PKG_URL)"                                 >> $(LIBJPEG_PKG)/.PKGINFO ; \
	 echo "license=$(LIBJPEG_PKG_LICENSE)"                         >> $(LIBJPEG_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBJPEG_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
