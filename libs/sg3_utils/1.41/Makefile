
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_M201)
COMPONENT_TARGETS += $(HARDWARE_MXV)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_DRA7XXEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/l/sg3_utils

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


version            = 1.41
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/l/sg3_utils/sg3_utils-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/sg3_utils-$(version)
src_dir_name       = sg3_utils-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
SG3_UTILS_PKG_NAME                = sg3_utils
SG3_UTILS_PKG_VERSION             = 1.41
SG3_UTILS_PKG_ARCH                = $(TOOLCHAIN)
SG3_UTILS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
SG3_UTILS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
SG3_UTILS_PKG_GROUP               = $(PKG_GROUP)
###                                |---handy-ruler-------------------------------|
SG3_UTILS_PKG_SHORT_DESCRIPTION   = utilities for the linux sg driver
SG3_UTILS_PKG_URL                 = $(BUG_URL)
SG3_UTILS_PKG_LICENSE             = GPLv2
SG3_UTILS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(SG3_UTILS_PKG_NAME)-pkg-description
SG3_UTILS_PKG_DESCRIPTION_FILE_IN = $(SG3_UTILS_PKG_NAME)-pkg-description.in
SG3_UTILS_PKG_INSTALL_SCRIPT      = $(SG3_UTILS_PKG_NAME)-pkg-install.sh

SG3_UTILS_PKG    = $(CURDIR)/$(TARGET_BUILD_DIR)/$(SG3_UTILS_PKG_NAME)-package

pkg_basename     = $(SG3_UTILS_PKG_NAME)-$(SG3_UTILS_PKG_VERSION)-$(SG3_UTILS_PKG_ARCH)-$(SG3_UTILS_PKG_DISTRO_NAME)-$(SG3_UTILS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(SG3_UTILS_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking

extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var

extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(SG3_UTILS_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(SG3_UTILS_PKG)/usr/share/man ]; then \
	  ( cd $(SG3_UTILS_PKG)/usr/share/man ; \
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
	@mkdir -p $(SG3_UTILS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/BSD_LICENSE $(SRC_DIR)/COPYING \
	       $(SG3_UTILS_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(SG3_UTILS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS BSD_LICENSE COPYING COVERAGE CREDITS INSTALL NEWS README* TODO sg3_utils.spec \
	         $(SG3_UTILS_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(SG3_UTILS_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(SG3_UTILS_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libsgutils?.la  \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(SG3_UTILS_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libsgutils?.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libsgutils?.la \
	 )
	# ======= Strip binaries =======
	@( cd $(SG3_UTILS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(SG3_UTILS_PKG_DESCRIPTION_FILE): $(SG3_UTILS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(SG3_UTILS_PKG_DESCRIPTION_FILE) $(SG3_UTILS_PKG_INSTALL_SCRIPT)
	@cp $(SG3_UTILS_PKG_DESCRIPTION_FILE) $(SG3_UTILS_PKG)/.DESCRIPTION
	@cp $(SG3_UTILS_PKG_INSTALL_SCRIPT) $(SG3_UTILS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(SG3_UTILS_PKG)/.REQUIRES
	@echo "pkgname=$(SG3_UTILS_PKG_NAME)"                            >  $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(SG3_UTILS_PKG_VERSION)"                          >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "arch=$(SG3_UTILS_PKG_ARCH)"                               >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "distroname=$(SG3_UTILS_PKG_DISTRO_NAME)"                  >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "distrover=$(SG3_UTILS_PKG_DISTRO_VERSION)"                >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "group=$(SG3_UTILS_PKG_GROUP)"                             >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(SG3_UTILS_PKG_SHORT_DESCRIPTION)\"" >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "url=$(SG3_UTILS_PKG_URL)"                                 >> $(SG3_UTILS_PKG)/.PKGINFO ; \
	 echo "license=$(SG3_UTILS_PKG_LICENSE)"                         >> $(SG3_UTILS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(SG3_UTILS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
