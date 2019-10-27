
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


SOURCE_REQUIRES    = sources/packages/a/less

REQUIRES           = libs/ncurses/6.1

# ======= __END_OF_REQUIRES__ =======


version            = 551
tar_gz_archive     = $(SRC_PACKAGE_PATH)/packages/a/less/less-$(version).tar.gz
SRC_ARCHIVE        = $(tar_gz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/less-$(version)
src_dir_name       = less-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

lesspipe           = $(CURDIR)/scripts/lesspipe.sh

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
LESS_PKG_NAME                = less
LESS_PKG_VERSION             = 551
LESS_PKG_ARCH                = $(TOOLCHAIN)
LESS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
LESS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
LESS_PKG_GROUP               = $(PKG_GROUP)
###                           |---handy-ruler-------------------------------|
LESS_PKG_SHORT_DESCRIPTION   = file pager
LESS_PKG_URL                 = $(BUG_URL)
LESS_PKG_LICENSE             = GPLv3
LESS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(LESS_PKG_NAME)-pkg-description
LESS_PKG_DESCRIPTION_FILE_IN = $(LESS_PKG_NAME)-pkg-description.in
LESS_PKG_INSTALL_SCRIPT      = $(LESS_PKG_NAME)-pkg-install.sh

LESS_PKG         = $(CURDIR)/$(TARGET_BUILD_DIR)/$(LESS_PKG_NAME)-package

pkg_basename     = $(LESS_PKG_NAME)-$(LESS_PKG_VERSION)-$(LESS_PKG_ARCH)-$(LESS_PKG_DISTRO_NAME)-$(LESS_PKG_DISTRO_VERSION)

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


env_sysroot = DESTDIR=$(LESS_PKG)

extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --sysconfdir=/etc


####### Dependencies

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@mkdir -p $(build_dir)
	@cd $(build_dir) && \
	  $(BUILD_ENVIRONMENT) $(environment) ../$(src_dir_name)/configure \
	  --prefix=/usr               \
	  --build=$(BUILD)            \
	  --host=$(TARGET)            \
	  $(extra_configure_switches)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE)
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(LESS_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(environment) $(MAKE) -j1 install $(env_sysroot)
	@cp -a $(lesspipe) $(LESS_PKG)/usr/bin/lesspipe.sh
	@chmod 755 $(LESS_PKG)/usr/bin/lesspipe.sh
	# ======= Install Documentation =======
	@if [ -d $(LESS_PKG)/usr/share/man ]; then \
	  ( cd $(LESS_PKG)/usr/share/man ; \
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
	@mkdir -p $(LESS_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING $(SRC_DIR)/LICENSE \
	       $(LESS_PKG)/usr/doc/$(src_dir_name)
	@chmod a-x $(LESS_PKG)/usr/doc/$(src_dir_name)/*
	@mkdir -p $(LESS_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING LICENSE NEWS README \
	         $(LESS_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@chmod 0644 $(LESS_PKG)/usr/share/doc/$(src_dir_name)/*
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(LESS_PKG))
	# ======= Strip binaries =======
	@( cd $(LESS_PKG) ; \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(LESS_PKG_DESCRIPTION_FILE): $(LESS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_certificate) : $(pkg_archive) ;
$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(LESS_PKG_DESCRIPTION_FILE) $(LESS_PKG_INSTALL_SCRIPT)
	@cp $(LESS_PKG_DESCRIPTION_FILE) $(LESS_PKG)/.DESCRIPTION
	@cp $(LESS_PKG_INSTALL_SCRIPT) $(LESS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(LESS_PKG)/.REQUIRES
	@echo "pkgname=$(LESS_PKG_NAME)"                            >  $(LESS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(LESS_PKG_VERSION)"                          >> $(LESS_PKG)/.PKGINFO ; \
	 echo "arch=$(LESS_PKG_ARCH)"                               >> $(LESS_PKG)/.PKGINFO ; \
	 echo "distroname=$(LESS_PKG_DISTRO_NAME)"                  >> $(LESS_PKG)/.PKGINFO ; \
	 echo "distrover=$(LESS_PKG_DISTRO_VERSION)"                >> $(LESS_PKG)/.PKGINFO ; \
	 echo "group=$(LESS_PKG_GROUP)"                             >> $(LESS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(LESS_PKG_SHORT_DESCRIPTION)\"" >> $(LESS_PKG)/.PKGINFO ; \
	 echo "url=$(LESS_PKG_URL)"                                 >> $(LESS_PKG)/.PKGINFO ; \
	 echo "license=$(LESS_PKG_LICENSE)"                         >> $(LESS_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(LESS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) -J --linkadd=yes $(GNUPG_OPTIONS) -m -d .. ."
