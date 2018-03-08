
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


SOURCE_REQUIRES    = sources/packages/m/xvidcore

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


version            = 1.3.4
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/m/xvidcore/xvidcore-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/xvidcore
src_dir_name       = xvidcore
doc_dir_name       = xvidcore-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
XVID_PKG_NAME                = xvidcore
XVID_PKG_VERSION             = 1.3.4
XVID_PKG_ARCH                = $(TOOLCHAIN)
XVID_PKG_DISTRO_NAME         = $(DISTRO_NAME)
XVID_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
XVID_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
XVID_PKG_SHORT_DESCRIPTION   = XviD MPEG-4 video codec
XVID_PKG_URL                 = $(BUG_URL)
XVID_PKG_LICENSE             = GPLv2
XVID_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(XVID_PKG_NAME)-pkg-description
XVID_PKG_DESCRIPTION_FILE_IN = $(XVID_PKG_NAME)-pkg-description.in
XVID_PKG_INSTALL_SCRIPT      = $(XVID_PKG_NAME)-pkg-install.sh

XVID_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(XVID_PKG_NAME)-package

pkg_basename     = $(XVID_PKG_NAME)-$(XVID_PKG_VERSION)-$(XVID_PKG_ARCH)-$(XVID_PKG_DISTRO_NAME)-$(XVID_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(XVID_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(doc_dir_name)
extra_configure_switches += --mandir=/usr/share/man


TARGET_LIB_RPATH = /lib$(LIBSUFFIX):/usr/lib$(LIBSUFFIX):/usr/lib/../lib$(LIBSUFFIX)

LDFLAGS += -Wl,-rpath,$(TARGET_LIB_RPATH)


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@( cd $(SRC_DIR) ; \
	   sed -i 's/\r//' ChangeLog ; \
	 )
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR)/build/generic && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR)/build/generic && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(XVID_PKG)
	@cd $(SRC_DIR)/build/generic && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@chmod 755 $(XVID_PKG)/usr/lib$(LIBSUFFIX)/libxvidcore.so.?.*
	# ======= Install Documentation =======
	@if [ -d $(XVID_PKG)/usr/share/man ]; then \
	  ( cd $(XVID_PKG)/usr/share/man ; \
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
	@mkdir -p $(XVID_PKG)/usr/doc/$(doc_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/LICENSE \
	       $(XVID_PKG)/usr/doc/$(doc_dir_name)
	@mkdir -p $(XVID_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS LICENSE README TODO \
	         $(XVID_PKG)/usr/share/doc/$(doc_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(XVID_PKG)/usr/share/doc/$(doc_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(XVID_PKG))
	# ======= Strip binaries =======
	@( cd $(XVID_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(XVID_PKG_DESCRIPTION_FILE): $(XVID_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(XVID_PKG_DESCRIPTION_FILE) $(XVID_PKG_INSTALL_SCRIPT)
	@cp $(XVID_PKG_DESCRIPTION_FILE) $(XVID_PKG)/.DESCRIPTION
	@cp $(XVID_PKG_INSTALL_SCRIPT) $(XVID_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(XVID_PKG)/.REQUIRES
	@echo "pkgname=$(XVID_PKG_NAME)"                            >  $(XVID_PKG)/.PKGINFO ; \
	 echo "pkgver=$(XVID_PKG_VERSION)"                          >> $(XVID_PKG)/.PKGINFO ; \
	 echo "arch=$(XVID_PKG_ARCH)"                               >> $(XVID_PKG)/.PKGINFO ; \
	 echo "distroname=$(XVID_PKG_DISTRO_NAME)"                  >> $(XVID_PKG)/.PKGINFO ; \
	 echo "distrover=$(XVID_PKG_DISTRO_VERSION)"                >> $(XVID_PKG)/.PKGINFO ; \
	 echo "group=$(XVID_PKG_GROUP)"                             >> $(XVID_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(XVID_PKG_SHORT_DESCRIPTION)\"" >> $(XVID_PKG)/.PKGINFO ; \
	 echo "url=$(XVID_PKG_URL)"                                 >> $(XVID_PKG)/.PKGINFO ; \
	 echo "license=$(XVID_PKG_LICENSE)"                         >> $(XVID_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(XVID_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
