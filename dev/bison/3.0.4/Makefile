
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB2X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_NIT6Q)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/GNU/bison

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
ifneq ($(HARDWARE),$(HARDWARE_PC64))
REQUIRES           = libs/glibc/2.22
else
REQUIRES           = libs/glibc/2.22-x86_32
endif
endif

# ======= __END_OF_REQUIRES__ =======


version            = 3.0.4
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/bison/bison-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/bison-$(version)
src_dir_name       = bison-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = dev

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
BISON_PKG_NAME                = bison
BISON_PKG_VERSION             = 3.0.4
BISON_PKG_ARCH                = $(TOOLCHAIN)
BISON_PKG_DISTRO_NAME         = $(DISTRO_NAME)
BISON_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
BISON_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
BISON_PKG_SHORT_DESCRIPTION   = parser generator similar to yacc
BISON_PKG_URL                 = $(BUG_URL)
BISON_PKG_LICENSE             = BSD
BISON_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(BISON_PKG_NAME)-pkg-description
BISON_PKG_DESCRIPTION_FILE_IN = $(BISON_PKG_NAME)-pkg-description.in
BISON_PKG_INSTALL_SCRIPT      = $(BISON_PKG_NAME)-pkg-install.sh

BISON_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(BISON_PKG_NAME)-package

pkg_basename     = $(BISON_PKG_NAME)-$(BISON_PKG_VERSION)-$(BISON_PKG_ARCH)-$(BISON_PKG_DISTRO_NAME)-$(BISON_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(BISON_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --disable-rpath


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cd $(SRC_DIR) && \
	  $(BUILD_ENVIRONMENT) ./configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(BISON_PKG)
	@cd $(SRC_DIR) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	# ======= Install Documentation =======
	@rm -f $(BISON_PKG)/usr/share/info/dir
	@gzip -9 $(BISON_PKG)/usr/share/info/*
	@if [ -d $(BISON_PKG)/usr/share/man ]; then \
	  ( cd $(BISON_PKG)/usr/share/man ; \
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
	@mkdir -p $(BISON_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/AUTHORS $(SRC_DIR)/COPYING \
	       $(BISON_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(BISON_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a INSTALL PACKAGING \
	         $(BISON_PKG)/usr/share/doc/$(src_dir_name) ; \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(BISON_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(BISON_PKG))
	# ======= Strip binaries =======
	@( cd $(BISON_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null \
	 )
	@touch $@

$(BISON_PKG_DESCRIPTION_FILE): $(BISON_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(BISON_PKG_DESCRIPTION_FILE) $(BISON_PKG_INSTALL_SCRIPT)
	@cp $(BISON_PKG_DESCRIPTION_FILE) $(BISON_PKG)/.DESCRIPTION
	@cp $(BISON_PKG_INSTALL_SCRIPT) $(BISON_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(BISON_PKG)/.REQUIRES
	@echo "pkgname=$(BISON_PKG_NAME)"                            >  $(BISON_PKG)/.PKGINFO ; \
	 echo "pkgver=$(BISON_PKG_VERSION)"                          >> $(BISON_PKG)/.PKGINFO ; \
	 echo "arch=$(BISON_PKG_ARCH)"                               >> $(BISON_PKG)/.PKGINFO ; \
	 echo "distroname=$(BISON_PKG_DISTRO_NAME)"                  >> $(BISON_PKG)/.PKGINFO ; \
	 echo "distrover=$(BISON_PKG_DISTRO_VERSION)"                >> $(BISON_PKG)/.PKGINFO ; \
	 echo "group=$(BISON_PKG_GROUP)"                             >> $(BISON_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(BISON_PKG_SHORT_DESCRIPTION)\"" >> $(BISON_PKG)/.PKGINFO ; \
	 echo "url=$(BISON_PKG_URL)"                                 >> $(BISON_PKG)/.PKGINFO ; \
	 echo "license=$(BISON_PKG_LICENSE)"                         >> $(BISON_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(BISON_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
