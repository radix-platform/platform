
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


SOURCE_REQUIRES    = sources/packages/n/libnfnetlink

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


version            = 1.0.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/libnfnetlink/libnfnetlink-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/libnfnetlink-$(version)
src_dir_name       = libnfnetlink-$(version)
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
LIBNFNETLINK_PKG_NAME                = libnfnetlink
LIBNFNETLINK_PKG_VERSION             = 1.0.1
LIBNFNETLINK_PKG_ARCH                = $(TOOLCHAIN)
LIBNFNETLINK_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LIBNFNETLINK_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LIBNFNETLINK_PKG_GROUP               = $(PKG_GROUP)
###                                   |---handy-ruler-------------------------------|
LIBNFNETLINK_PKG_SHORT_DESCRIPTION   = library for netfilter
LIBNFNETLINK_PKG_URL                 = $(BUG_URL)
LIBNFNETLINK_PKG_LICENSE             = GPLv2
LIBNFNETLINK_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LIBNFNETLINK_PKG_NAME)-pkg-description
LIBNFNETLINK_PKG_DESCRIPTION_FILE_IN = $(LIBNFNETLINK_PKG_NAME)-pkg-description.in
LIBNFNETLINK_PKG_INSTALL_SCRIPT      = $(LIBNFNETLINK_PKG_NAME)-pkg-install.sh

LIBNFNETLINK_PKG = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LIBNFNETLINK_PKG_NAME)-package

pkg_basename     = $(LIBNFNETLINK_PKG_NAME)-$(LIBNFNETLINK_PKG_VERSION)-$(LIBNFNETLINK_PKG_ARCH)-$(LIBNFNETLINK_PKG_DISTRO_NAME)-$(LIBNFNETLINK_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot  = DESTDIR=$(LIBNFNETLINK_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --enable-static=yes
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(LIBNFNETLINK_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@if [ -d $(LIBNFNETLINK_PKG)/usr/share/man ]; then \
	  ( cd $(LIBNFNETLINK_PKG)/usr/share/man ; \
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
	@mkdir -p $(LIBNFNETLINK_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(LIBNFNETLINK_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(LIBNFNETLINK_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README \
	         $(LIBNFNETLINK_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(LIBNFNETLINK_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= remove toolchain path from target libtool *.la files =======
	@( cd $(LIBNFNETLINK_PKG)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,$(TARGET_DEST_DIR),,g" libnfnetlink.la ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LIBNFNETLINK_PKG))
	# ======= tune libtool *.la search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX) ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnfnetlink.la ; \
	   sed -i "s,L/lib,L$(TARGET_DEST_DIR)/lib,g" libnfnetlink.la \
	 )
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" libnfnetlink.pc ; \
	 )
	# ======= Strip binaries =======
	@( cd $(LIBNFNETLINK_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(LIBNFNETLINK_PKG_DESCRIPTION_FILE): $(LIBNFNETLINK_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LIBNFNETLINK_PKG_DESCRIPTION_FILE) $(LIBNFNETLINK_PKG_INSTALL_SCRIPT)
	@cp $(LIBNFNETLINK_PKG_DESCRIPTION_FILE) $(LIBNFNETLINK_PKG)/.DESCRIPTION
	@cp $(LIBNFNETLINK_PKG_INSTALL_SCRIPT) $(LIBNFNETLINK_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LIBNFNETLINK_PKG)/.REQUIRES
	@echo "pkgname=$(LIBNFNETLINK_PKG_NAME)"                            >  $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LIBNFNETLINK_PKG_VERSION)"                          >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "arch=$(LIBNFNETLINK_PKG_ARCH)"                               >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "distroname=$(LIBNFNETLINK_PKG_DISTRO_NAME)"                  >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "distrover=$(LIBNFNETLINK_PKG_DISTRO_VERSION)"                >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "group=$(LIBNFNETLINK_PKG_GROUP)"                             >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LIBNFNETLINK_PKG_SHORT_DESCRIPTION)\"" >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "url=$(LIBNFNETLINK_PKG_URL)"                                 >> $(LIBNFNETLINK_PKG)/.PKGINFO ; \
	 echo "license=$(LIBNFNETLINK_PKG_LICENSE)"                         >> $(LIBNFNETLINK_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LIBNFNETLINK_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
