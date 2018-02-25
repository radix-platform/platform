
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
COMPONENT_TARGETS += $(HARDWARE_BAIKAL_T1)

#
# The rest targets links staticaly with newlib or uclibc and not requires glibc libraties
#
# COMPONENT_TARGETS += $(HARDWARE_CB1N)
# COMPONENT_TARGETS += $(HARDWARE_AT91S)
# COMPONENT_TARGETS += $(HARDWARE_DM64N)
# COMPONENT_TARGETS += $(HARDWARE_L17UC)
#

NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../../build-system/constants.mk


SOURCE_REQUIRES   = sources/iana/tz

REQUIRES          = libs/glibc/2.21-i18n

# ======= __END_OF_REQUIRES__ =======


version    = 2.21
tz_version = 2015c

tar_gz_code_archive       = $(SRC_PACKAGE_PATH)/iana/tz/tzcode$(tz_version).tar.gz
tar_gz_data_archive       = $(SRC_PACKAGE_PATH)/iana/tz/tzdata$(tz_version).tar.gz


SRC_DIR           = $(TARGET_BUILD_DIR)/timezone
doc_dir_name      = zoneinfo-$(version)
src_done          = $(TARGET_BUILD_DIR)/.source-done
install_target    = $(TARGET_BUILD_DIR)/.install_done

scripts_dir       = $(CURDIR)/scripts
part_01           = $(CURDIR)/$(TARGET_BUILD_DIR)/part-01


OPTIMIZATION_FLAGS  = -O3


####### Targets

PKG_GROUP = libs

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
GLIBC_TZ_PKG_NAME                = glibc-zoneinfo
GLIBC_TZ_PKG_VERSION             = 2.21
GLIBC_TZ_PKG_ARCH                = $(TOOLCHAIN)
GLIBC_TZ_PKG_DISTRO_NAME         = $(DISTRO_NAME)
GLIBC_TZ_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
GLIBC_TZ_PKG_GROUP               = $(PKG_GROUP)
###                               |---handy-ruler-------------------------------|
GLIBC_TZ_PKG_SHORT_DESCRIPTION   = timezone database
GLIBC_TZ_PKG_URL                 = $(BUG_URL)
GLIBC_TZ_PKG_LICENSE             = public
GLIBC_TZ_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(GLIBC_TZ_PKG_NAME)-pkg-description
GLIBC_TZ_PKG_DESCRIPTION_FILE_IN = $(GLIBC_TZ_PKG_NAME)-pkg-description.in
GLIBC_TZ_PKG_INSTALL_SCRIPT      = $(GLIBC_TZ_PKG_NAME)-pkg-install.sh

GLIBC_TZ_PKG     = $(CURDIR)/$(TARGET_BUILD_DIR)/$(GLIBC_TZ_PKG_NAME)-package

pkg_basename     = $(GLIBC_TZ_PKG_NAME)-$(GLIBC_TZ_PKG_VERSION)-$(GLIBC_TZ_PKG_ARCH)-$(GLIBC_TZ_PKG_DISTRO_NAME)-$(GLIBC_TZ_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../../build-system/core.mk


ifeq ($(TOOLCHAIN),$(TOOLCHAIN_X86_64_GLIBC))
OPTIMIZATION_FLAGS += -fPIC
endif


$(src_done): $(tar_gz_code_archive) $(tar_gz_data_archive)
	@mkdir -p $(SRC_DIR)
	@tar xzf $(tar_gz_code_archive) -C $(SRC_DIR)
	@tar xzf $(tar_gz_data_archive) -C $(SRC_DIR)
	@cd $(SRC_DIR) && CWD=`pwd` sed -i "s,/usr/local,.,g" Makefile
	@cd $(SRC_DIR) && sed -i "s,/etc/$(TZDIR_BASENAME),/$(TZDIR_BASENAME),g" Makefile
	@cd $(SRC_DIR) && chmod a-x leap-seconds.list
	@touch $@

$(install_target): $(src_done)
	@mkdir -p $(GLIBC_TZ_PKG)
	@cd $(SRC_DIR) && $(MAKE)
	@cd $(SRC_DIR) && $(MAKE) -j1 install
	@mkdir -p $(GLIBC_TZ_PKG)/usr/share/zoneinfo/{posix,right}
	@cp -a $(SRC_DIR)/zoneinfo/* $(GLIBC_TZ_PKG)/usr/share/zoneinfo
	@cp -a $(SRC_DIR)/zoneinfo-posix/* $(GLIBC_TZ_PKG)/usr/share/zoneinfo/posix
	@cp -a $(SRC_DIR)/zoneinfo-leaps/* $(GLIBC_TZ_PKG)/usr/share/zoneinfo/right
	# ======= Remove PACKAGE/usr/share/zoneinfo/localtime --                =======
	# ======= the install script will create it as a link to /etc/localtime =======
	@rm -f $(GLIBC_TZ_PKG)/usr/share/zoneinfo/localtime
	# ======= timeconfig script =======
	@$(scripts_dir)/list-zones $(GLIBC_TZ_PKG)/usr/share/zoneinfo $(part_01)
	@mkdir -p $(GLIBC_TZ_PKG)/usr/sbin
	@cat $(scripts_dir)/part-00 $(part_01) $(scripts_dir)/part-02 > $(GLIBC_TZ_PKG)/usr/sbin/timeconfig
	@chmod 0755 $(GLIBC_TZ_PKG)/usr/sbin/timeconfig
	# ======= Install Documentation =======
	@cp -rf $(SRC_DIR)/man $(GLIBC_TZ_PKG)/usr/share
	@( cd $(GLIBC_TZ_PKG)/usr/share/man/man3 ; \
	   for file in *.3 ; do \
	     gzip -9 --force $$file; \
	   done )
	@( cd $(GLIBC_TZ_PKG)/usr/share/man/man5 ; \
	   for file in *.5 ; do \
	     gzip -9 --force $$file; \
	   done )
	@( cd $(GLIBC_TZ_PKG)/usr/share/man/man8 ; \
	   for file in *.8 ; do \
	     gzip -9 --force $$file; \
	   done )
	@mkdir -p $(GLIBC_TZ_PKG)/usr/share/doc/$(doc_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a CONTRIBUTING NEWS README Theory \
	         $(GLIBC_TZ_PKG)/usr/share/doc/$(doc_dir_name) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(GLIBC_TZ_PKG))
	@touch $@

$(GLIBC_TZ_PKG_DESCRIPTION_FILE): $(GLIBC_TZ_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" \
	        | $(SED) -e "s/@TZVERSION@/$(tz_version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(GLIBC_TZ_PKG_DESCRIPTION_FILE) $(GLIBC_TZ_PKG_INSTALL_SCRIPT)
	@cp $(GLIBC_TZ_PKG_DESCRIPTION_FILE) $(GLIBC_TZ_PKG)/.DESCRIPTION
	@cp $(GLIBC_TZ_PKG_INSTALL_SCRIPT) $(GLIBC_TZ_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(GLIBC_TZ_PKG)/.REQUIRES
	@echo "pkgname=$(GLIBC_TZ_PKG_NAME)"                            >  $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "pkgver=$(GLIBC_TZ_PKG_VERSION)"                          >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "arch=$(GLIBC_TZ_PKG_ARCH)"                               >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "distroname=$(GLIBC_TZ_PKG_DISTRO_NAME)"                  >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "distrover=$(GLIBC_TZ_PKG_DISTRO_VERSION)"                >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "group=$(GLIBC_TZ_PKG_GROUP)"                             >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(GLIBC_TZ_PKG_SHORT_DESCRIPTION)\"" >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "url=$(GLIBC_TZ_PKG_URL)"                                 >> $(GLIBC_TZ_PKG)/.PKGINFO ; \
	 echo "license=$(GLIBC_TZ_PKG_LICENSE)"                         >> $(GLIBC_TZ_PKG)/.PKGINFO
	@$(PSEUDO) sh -c "cd $(GLIBC_TZ_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
