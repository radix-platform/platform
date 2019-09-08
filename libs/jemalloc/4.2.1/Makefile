
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


SOURCE_REQUIRES    = sources/packages/l/jemalloc

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.4.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.25
else
REQUIRES           = libs/glibc/2.25-x86_32
endif
endif
REQUIRES          += dev/perl/5.22.1

# ======= __END_OF_REQUIRES__ =======


version            = 4.2.1
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/l/jemalloc/jemalloc-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/jemalloc-$(version)
src_dir_name       = jemalloc-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

config_dir         = $(CURDIR)/scripts

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
JEMALLOC_PKG_NAME                = jemalloc
JEMALLOC_PKG_VERSION             = 4.2.1
JEMALLOC_PKG_ARCH                = $(TOOLCHAIN)
JEMALLOC_PKG_DISTRO_NAME         = $(DISTRO_NAME)
JEMALLOC_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
JEMALLOC_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
JEMALLOC_PKG_SHORT_DESCRIPTION   = A memory allocator
JEMALLOC_PKG_URL                 = $(BUG_URL)
JEMALLOC_PKG_LICENSE             = custom
JEMALLOC_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(JEMALLOC_PKG_NAME)-pkg-description
JEMALLOC_PKG_DESCRIPTION_FILE_IN = $(JEMALLOC_PKG_NAME)-pkg-description.in
JEMALLOC_PKG_INSTALL_SCRIPT      = $(JEMALLOC_PKG_NAME)-pkg-install.sh

JEMALLOC_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(JEMALLOC_PKG_NAME)-package

pkg_basename     = $(JEMALLOC_PKG_NAME)-$(JEMALLOC_PKG_VERSION)-$(JEMALLOC_PKG_ARCH)-$(JEMALLOC_PKG_DISTRO_NAME)-$(JEMALLOC_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(JEMALLOC_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
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
	@cd $(SRC_DIR) && \
	  echo "$(version)" > VERSION &&   \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(JEMALLOC_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(JEMALLOC_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod a-x *.a ; \
	 )
	# ======= Install Documentation =======
	@if [ -d $(JEMALLOC_PKG)/usr/share/man ]; then \
	  ( cd $(JEMALLOC_PKG)/usr/share/man ; \
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
	@mkdir -p $(JEMALLOC_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(JEMALLOC_PKG)/usr/doc/$(src_dir_name)
	@mv $(JEMALLOC_PKG)/usr/share/doc/jemalloc $(JEMALLOC_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING INSTALL README VERSION \
	         $(JEMALLOC_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(JEMALLOC_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(JEMALLOC_PKG))
	# ======= Replace the jemalloc-config script for the target system =======
	@cp -a $(config_dir)/jemalloc-config $(JEMALLOC_PKG)/usr/bin/jemalloc-config
	@chmod a+x $(JEMALLOC_PKG)/usr/bin/jemalloc-config
	# ======= tune pkg-config *.pc search path to the target destination for development =======
	@( cd $(TARGET_DEST_DIR)/usr/lib$(LIBSUFFIX)/pkgconfig ; \
	   sed -i "s,/usr,$(TARGET_DEST_DIR)/usr,g" jemalloc.pc \
	 )
	# ======= Strip binaries =======
	@( cd $(JEMALLOC_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(JEMALLOC_PKG_DESCRIPTION_FILE): $(JEMALLOC_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(JEMALLOC_PKG_DESCRIPTION_FILE) $(JEMALLOC_PKG_INSTALL_SCRIPT)
	@cp $(JEMALLOC_PKG_DESCRIPTION_FILE) $(JEMALLOC_PKG)/.DESCRIPTION
	@cp $(JEMALLOC_PKG_INSTALL_SCRIPT) $(JEMALLOC_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(JEMALLOC_PKG)/.REQUIRES
	@echo "pkgname=$(JEMALLOC_PKG_NAME)"                            >  $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "pkgver=$(JEMALLOC_PKG_VERSION)"                          >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "arch=$(JEMALLOC_PKG_ARCH)"                               >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "distroname=$(JEMALLOC_PKG_DISTRO_NAME)"                  >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "distrover=$(JEMALLOC_PKG_DISTRO_VERSION)"                >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "group=$(JEMALLOC_PKG_GROUP)"                             >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(JEMALLOC_PKG_SHORT_DESCRIPTION)\"" >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "url=$(JEMALLOC_PKG_URL)"                                 >> $(JEMALLOC_PKG)/.PKGINFO ; \
	 echo "license=$(JEMALLOC_PKG_LICENSE)"                         >> $(JEMALLOC_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(JEMALLOC_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
