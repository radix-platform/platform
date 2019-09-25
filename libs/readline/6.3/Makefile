
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


SOURCE_REQUIRES    = sources/GNU/readline

REQUIRES           = libs/ncurses/6.0
REQUIRES          += libs/libtermcap/1.2.3

# ======= __END_OF_REQUIRES__ =======


version            = 6.3
tar_gz_archive     = $(SRC_PACKAGE_PATH)/GNU/readline/readline-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/readline-$(version)
src_dir_name       = readline-$(version)
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
READLINE_PKG_NAME                = readline
READLINE_PKG_VERSION             = 6.3
READLINE_PKG_ARCH                = $(TOOLCHAIN)
READLINE_PKG_DISTRO_NAME         = $(DISTRO_NAME)
READLINE_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
READLINE_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
READLINE_PKG_SHORT_DESCRIPTION   = line input library with editing features
READLINE_PKG_URL                 = $(BUG_URL)
READLINE_PKG_LICENSE             = GPLv2
READLINE_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(READLINE_PKG_NAME)-pkg-description
READLINE_PKG_DESCRIPTION_FILE_IN = $(READLINE_PKG_NAME)-pkg-description.in
READLINE_PKG_INSTALL_SCRIPT      = $(READLINE_PKG_NAME)-pkg-install.sh

READLINE_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(READLINE_PKG_NAME)-package

pkg_basename     = $(READLINE_PKG_NAME)-$(READLINE_PKG_VERSION)-$(READLINE_PKG_ARCH)-$(READLINE_PKG_DISTRO_NAME)-$(READLINE_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(READLINE_PKG)


extra_configure_switches  = --libdir=/usr/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --infodir=/usr/share/info
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --with-curses
extra_configure_switches += --enable-multibyte
ifeq ($(__ENABLE_STATIC__),yes)
extra_configure_switches += --enable-static=yes
else
extra_configure_switches += --enable-static=no
endif
extra_configure_switches += --enable-shared=yes


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
	@mkdir -p $(READLINE_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) -j1 install $(env_sysroot)
	@( cd $(READLINE_PKG)/usr/lib$(LIBSUFFIX) ; \
	   chmod 755 *.so.?.? ; \
	 )
	# ======= Install Documentation =======
	@rm -f $(READLINE_PKG)/usr/share/info/dir
	@gzip -9 $(READLINE_PKG)/usr/share/info/*
	@rm -rf $(READLINE_PKG)/usr/bin
	@if [ -d $(READLINE_PKG)/usr/share/man ]; then \
	  ( cd $(READLINE_PKG)/usr/share/man ; \
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
	@mkdir -p $(READLINE_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(READLINE_PKG)/usr/doc/$(src_dir_name)
	@mkdir -p $(READLINE_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CHANGES COPYING INSTALL MANIFEST NEWS README USAGE \
	         $(READLINE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR)/doc ; \
	   cp -a history.{html,pdf} readline.{html,pdf} rluserman.{html,pdf} \
	         $(READLINE_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r CHANGELOG ]; then \
	     DOCSDIR=`echo $(READLINE_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat CHANGELOG | head -n 1000 > $$DOCSDIR/CHANGELOG ; \
	     touch -r CHANGELOG $$DOCSDIR/CHANGELOG ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(READLINE_PKG))
	# ======= Strip binaries =======
	@( cd $(READLINE_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	   find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null ; \
	 )
ifeq ($(__ENABLE_STATIC__),yes)
	@( cd $(READLINE_PKG) ; \
	   find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) -g 2> /dev/null ; \
	 )
endif
	@touch $@

$(READLINE_PKG_DESCRIPTION_FILE): $(READLINE_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(READLINE_PKG_DESCRIPTION_FILE) $(READLINE_PKG_INSTALL_SCRIPT)
	@cp $(READLINE_PKG_DESCRIPTION_FILE) $(READLINE_PKG)/.DESCRIPTION
	@cp $(READLINE_PKG_INSTALL_SCRIPT) $(READLINE_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(READLINE_PKG)/.REQUIRES
	@echo "pkgname=$(READLINE_PKG_NAME)"                            >  $(READLINE_PKG)/.PKGINFO ; \
	 echo "pkgver=$(READLINE_PKG_VERSION)"                          >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "arch=$(READLINE_PKG_ARCH)"                               >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "distroname=$(READLINE_PKG_DISTRO_NAME)"                  >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "distrover=$(READLINE_PKG_DISTRO_VERSION)"                >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "group=$(READLINE_PKG_GROUP)"                             >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(READLINE_PKG_SHORT_DESCRIPTION)\"" >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "url=$(READLINE_PKG_URL)"                                 >> $(READLINE_PKG)/.PKGINFO ; \
	 echo "license=$(READLINE_PKG_LICENSE)"                         >> $(READLINE_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(READLINE_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
