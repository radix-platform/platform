
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


SOURCE_REQUIRES    = sources/GNU/grep

ifeq ($(__USE_BUILT_GCC_LIBS__),yes)
REQUIRES           = dev/gcc/5.3.0
else
REQUIRES           = libs/glibc/2.24
endif

# ======= __END_OF_REQUIRES__ =======


version            = 2.18
tar_xz_archive     = $(SRC_PACKAGE_PATH)/GNU/grep/grep-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/grep-$(version)
src_dir_name       = grep-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GREP_PKG_NAME                = grep
GREP_PKG_VERSION             = 2.18
GREP_PKG_ARCH                = $(TOOLCHAIN)
GREP_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GREP_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GREP_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
GREP_PKG_SHORT_DESCRIPTION   = print lines matching a pattern
GREP_PKG_URL                 = $(BUG_URL)
GREP_PKG_LICENSE             = GPLv2
GREP_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GREP_PKG_NAME)-pkg-description
GREP_PKG_DESCRIPTION_FILE_IN = $(GREP_PKG_NAME)-pkg-description.in
GREP_PKG_INSTALL_SCRIPT      = $(GREP_PKG_NAME)-pkg-install.sh

GREP_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GREP_PKG_NAME)-package

pkg_basename     = $(GREP_PKG_NAME)-$(GREP_PKG_VERSION)-$(GREP_PKG_ARCH)-$(GREP_PKG_DISTRO_NAME)-$(GREP_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(GREP_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --bindir=/bin


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
	@mkdir -p $(GREP_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@mkdir -p $(GREP_PKG)/usr/bin
	@( cd $(GREP_PKG)/usr/bin ; \
	   ln -sf ../../bin/grep . ; \
	   ln -sf ../../bin/egrep . ; \
	   ln -sf ../../bin/fgrep . \
	 )
	# ======= Install Documentation =======
	@( cd $(GREP_PKG)/usr/share/man/man1 ; \
	   rm -f egrep.1 fgrep.1 ; \
	   ln -sf grep.1 egrep.1 ; \
	   ln -sf grep.1 fgrep.1 ; \
	 )
	@rm -f $(GREP_PKG)/usr/share/info/dir
	@gzip -9 $(GREP_PKG)/usr/share/info/*
	@if [ -d $(GREP_PKG)/usr/share/man ]; then \
	  ( cd $(GREP_PKG)/usr/share/man ; \
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
	@mkdir -p $(GREP_PKG)/usr/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* \
	       $(GREP_PKG)/usr/doc/$(src_dir_name) \
	 )
	@mkdir -p $(GREP_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a AUTHORS COPYING* INSTALL NEWS README* THANKS TODO \
	       $(GREP_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r ChangeLog ]; then \
	     DOCSDIR=`echo $(GREP_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat ChangeLog | head -n 1000 > $$DOCSDIR/ChangeLog ; \
	     touch -r ChangeLog $$DOCSDIR/ChangeLog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GREP_PKG))
	# ======= Strip binaries =======
	@( cd $(GREP_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
	@touch $@

$(GREP_PKG_DESCRIPTION_FILE): $(GREP_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GREP_PKG_DESCRIPTION_FILE) $(GREP_PKG_INSTALL_SCRIPT)
	@cp $(GREP_PKG_DESCRIPTION_FILE) $(GREP_PKG)/.DESCRIPTION
	@cp $(GREP_PKG_INSTALL_SCRIPT) $(GREP_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GREP_PKG)/.REQUIRES
	@echo "pkgname=$(GREP_PKG_NAME)"                            >  $(GREP_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GREP_PKG_VERSION)"                          >> $(GREP_PKG)/.PKGINFO ; \
	 echo "arch=$(GREP_PKG_ARCH)"                               >> $(GREP_PKG)/.PKGINFO ; \
	 echo "distroname=$(GREP_PKG_DISTRO_NAME)"                  >> $(GREP_PKG)/.PKGINFO ; \
	 echo "distrover=$(GREP_PKG_DISTRO_VERSION)"                >> $(GREP_PKG)/.PKGINFO ; \
	 echo "group=$(GREP_PKG_GROUP)"                             >> $(GREP_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GREP_PKG_SHORT_DESCRIPTION)\"" >> $(GREP_PKG)/.PKGINFO ; \
	 echo "url=$(GREP_PKG_URL)"                                 >> $(GREP_PKG)/.PKGINFO ; \
	 echo "license=$(GREP_PKG_LICENSE)"                         >> $(GREP_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GREP_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
