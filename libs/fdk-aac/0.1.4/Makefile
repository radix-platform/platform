
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


SOURCE_REQUIRES    = sources/packages/m/amr/fdk-aac

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.26
else
REQUIRES           = libs/glibc/2.26-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 0.1.4
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/m/amr/fdk-aac/fdk-aac-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/fdk-aac-$(version)
src_dir_name       = fdk-aac-$(version)
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
FDK_AAC_PKG_NAME                = fdk-aac
FDK_AAC_PKG_VERSION             = 0.1.4
FDK_AAC_PKG_ARCH                = $(TOOLCHAIN)
FDK_AAC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
FDK_AAC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
FDK_AAC_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
FDK_AAC_PKG_SHORT_DESCRIPTION   = The Fraunhofer FDK AAC Codec Library
FDK_AAC_PKG_URL                 = $(BUG_URL)
FDK_AAC_PKG_LICENSE             = Fraunhofer
FDK_AAC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(FDK_AAC_PKG_NAME)-pkg-description
FDK_AAC_PKG_DESCRIPTION_FILE_IN = $(FDK_AAC_PKG_NAME)-pkg-description.in
FDK_AAC_PKG_INSTALL_SCRIPT      = $(FDK_AAC_PKG_NAME)-pkg-install.sh

FDK_AAC_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(FDK_AAC_PKG_NAME)-package

pkg_basename     = $(FDK_AAC_PKG_NAME)-$(FDK_AAC_PKG_VERSION)-$(FDK_AAC_PKG_ARCH)-$(FDK_AAC_PKG_DISTRO_NAME)-$(FDK_AAC_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(FDK_AAC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
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
	@mkdir -p $(FDK_AAC_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(FDK_AAC_PKG)/usr/share/man ]; then \
	  ( cd $(FDK_AAC_PKG)/usr/share/man ; \
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
	@mkdir -p $(FDK_AAC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/NOTICE \
	       $(FDK_AAC_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(FDK_AAC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a NOTICE documentation/aacDecoder.pdf documentation/aacEncoder.pdf \
	         $(FDK_AAC_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(FDK_AAC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(FDK_AAC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libfdk-aac.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(FDK_AAC_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libfdk-aac.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libfdk-aac.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" fdk-aac.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(FDK_AAC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(FDK_AAC_PKG_DESCRIPTION_FILE): $(FDK_AAC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(FDK_AAC_PKG_DESCRIPTION_FILE) $(FDK_AAC_PKG_INSTALL_SCRIPT)
	@cp $(FDK_AAC_PKG_DESCRIPTION_FILE) $(FDK_AAC_PKG)/.DESCRIPTION
	@cp $(FDK_AAC_PKG_INSTALL_SCRIPT) $(FDK_AAC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(FDK_AAC_PKG)/.REQUIRES
	@echo "pkgname=$(FDK_AAC_PKG_NAME)"                            >  $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(FDK_AAC_PKG_VERSION)"                          >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "arch=$(FDK_AAC_PKG_ARCH)"                               >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "distroname=$(FDK_AAC_PKG_DISTRO_NAME)"                  >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "distrover=$(FDK_AAC_PKG_DISTRO_VERSION)"                >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "group=$(FDK_AAC_PKG_GROUP)"                             >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(FDK_AAC_PKG_SHORT_DESCRIPTION)\"" >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "url=$(FDK_AAC_PKG_URL)"                                 >> $(FDK_AAC_PKG)/.PKGINFO ; \
	 echo "license=$(FDK_AAC_PKG_LICENSE)"                         >> $(FDK_AAC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(FDK_AAC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
