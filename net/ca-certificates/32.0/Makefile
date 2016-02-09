
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)
COMPONENT_TARGETS += $(HARDWARE_CB1X)
COMPONENT_TARGETS += $(HARDWARE_CB3X)
COMPONENT_TARGETS += $(HARDWARE_FFRK3288)
COMPONENT_TARGETS += $(HARDWARE_DM64X)
COMPONENT_TARGETS += $(HARDWARE_BEAGLE)
COMPONENT_TARGETS += $(HARDWARE_OMAP5UEVM)
COMPONENT_TARGETS += $(HARDWARE_B74)
COMPONENT_TARGETS += $(HARDWARE_CI20)
COMPONENT_TARGETS += $(HARDWARE_BT1)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/n/ca-certificates/cacert.org
SOURCE_REQUIRES   += sources/packages/n/ca-certificates/mozilla
SOURCE_REQUIRES   += sources/packages/n/ca-certificates/spi-inc.org


REQUIRES           = net/openssl/1.0.2f
REQUIRES          += app/dcron/4.5

# ======= __END_OF_REQUIRES__ =======


version            = 32.0
tar_bz2_archive    = $(SRC_PACKAGE_PATH)/packages/n/ca-certificates/mozilla/mozilla-certs-$(version).tar.bz2
SRC_ARCHIVE        = $(tar_bz2_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/mozilla-certs-$(version)
src_dir_name       = mozilla-certs-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source-done

cacert_archive     = $(SRC_PACKAGE_PATH)/packages/n/ca-certificates/cacert.org/cacert.tar.bz2
CASERT_SRC_DIR     = $(TARGET_BUILD_DIR)/cacert
cacert_src_done    = $(TARGET_BUILD_DIR)/.cacert-source-done

spiinc_archive     = $(SRC_PACKAGE_PATH)/packages/n/ca-certificates/spi-inc.org/spi-inc.tar.bz2
SPIINC_SRC_DIR     = $(TARGET_BUILD_DIR)/spi-inc
spiinc_src_done    = $(TARGET_BUILD_DIR)/.spiinc-source-done


PATCHES = PATCHES

build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

licenses_dir       = $(CURDIR)/licenses
sbin_dir           = $(CURDIR)/sbin
scripts_dir        = $(CURDIR)/scripts


####### Targets

PKG_GROUP = net

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
CACERTS_PKG_NAME                = ca-certificates
CACERTS_PKG_VERSION             = 32.0
CACERTS_PKG_ARCH                = $(TOOLCHAIN)
CACERTS_PKG_DISTRO_NAME         = $(DISTRO_NAME)
CACERTS_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
CACERTS_PKG_GROUP               = $(PKG_GROUP)
###                              |---handy-ruler-------------------------------|
CACERTS_PKG_SHORT_DESCRIPTION   = PEM Files of CA Certificates
CACERTS_PKG_URL                 = $(BUG_URL)
CACERTS_PKG_LICENSE             = GPLv2
CACERTS_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(CACERTS_PKG_NAME)-pkg-description
CACERTS_PKG_DESCRIPTION_FILE_IN = $(CACERTS_PKG_NAME)-pkg-description.in
CACERTS_PKG_INSTALL_SCRIPT      = $(CACERTS_PKG_NAME)-pkg-install.sh

CACERTS_PKG      = $(CURDIR)/$(TARGET_BUILD_DIR)/$(CACERTS_PKG_NAME)-package

pkg_basename     = $(CACERTS_PKG_NAME)-$(CACERTS_PKG_VERSION)-$(CACERTS_PKG_ARCH)-$(CACERTS_PKG_DISTRO_NAME)-$(CACERTS_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


####### Dependencies

$(cacert_src_done): $(cacert_archive)
	@echo "Expanding $(cacert_archive)"
	@tar xjf $(cacert_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(spiinc_src_done): $(spiinc_archive)
	@echo "Expanding $(spiinc_archive)"
	@tar xjf $(spiinc_archive) -C $(TARGET_BUILD_DIR)
	@touch $@

$(src_done): $(SRC_ARCHIVE) $(PATCHES_DEP) $(cacert_src_done) $(spiinc_src_done)
	$(UNPACK_SRC_ARCHIVE)
	$(APPLY_PATCHES)
	@touch $@

$(build_target): $(src_done)
	@cp $(scripts_dir)/make-cert.pl $(scripts_dir)/make-splitted.sh $(SRC_DIR)
	@chmod a+x $(SRC_DIR)/make-cert.pl $(SRC_DIR)/make-splitted.sh
	@( cd $(SRC_DIR) ; \
	   ./make-splitted.sh $(version) ; \
	 )
	@touch $@

$(install_target): $(build_target)
	@mkdir -p $(CACERTS_PKG)/etc/ca-certificates/update.d
	@mkdir -p $(CACERTS_PKG)/usr/sbin
	@mkdir -p $(CACERTS_PKG)/usr/share/man/man8
	@mkdir -p $(CACERTS_PKG)/usr/share/ca-certificates/cacert.org
	@mkdir -p $(CACERTS_PKG)/usr/share/ca-certificates/mozilla
	@mkdir -p $(CACERTS_PKG)/usr/share/ca-certificates/spi-inc.org
	# ======= Install certificates-$(version) =======
	@( cd $(CASERT_SRC_DIR) ; \
	   CERTSDIR="$(CACERTS_PKG)/usr/share/ca-certificates/cacert.org" ; \
	   for pem in *.crt ; do \
	     cp $$pem $$CERTSDIR/cacert.org_$$pem ; \
	   done ; \
	 )
	@( cd $(SPIINC_SRC_DIR) ; \
	   CERTSDIR="$(CACERTS_PKG)/usr/share/ca-certificates/spi-inc.org" ; \
	   for pem in *.crt ; do \
	     cp $$pem $$CERTSDIR/$$pem ; \
	   done ; \
	 )
	@( cd $(SRC_DIR)/splitted ; \
	   CERTSDIR="$(CACERTS_PKG)/usr/share/ca-certificates/mozilla" ; \
	   for pem in *.crt ; do \
	     cp $$pem $$CERTSDIR/$$pem ; \
	   done ; \
	 )
	@printf "#\n# Automatically generated by ca-certificates-$(version)\n#\n" \
	   > $(CACERTS_PKG)/etc/ca-certificates.conf.new
	@( cd $(CACERTS_PKG)/usr/share/ca-certificates ; \
	   find . -name '*.crt' | sort | cut -b3- ) \
	   >> $(CACERTS_PKG)/etc/ca-certificates.conf.new
	# ======= Install scripts =======
	@cp $(sbin_dir)/update-ca-certificates $(CACERTS_PKG)/usr/sbin
	@chmod 0755 $(CACERTS_PKG)/usr/sbin/*
	@gzip -9c $(sbin_dir)/update-ca-certificates.8 > $(CACERTS_PKG)/usr/share/man/man8/update-ca-certificates.8.gz
	# ======= Install Documentation =======
	@mkdir -p $(CACERTS_PKG)/usr/doc/ca-certificates-$(version)
	@mkdir -p $(CACERTS_PKG)/usr/share/doc/ca-certificates-$(version)
	@( cd $(licenses_dir) ; \
	   cp -a LICENSE* $(CACERTS_PKG)/usr/doc/ca-certificates-$(version) ; \
	   cp -a LICENSE* $(CACERTS_PKG)/usr/share/doc/ca-certificates-$(version) ; \
	 )
	@( cd $(sbin_dir) ; \
	   cp -a README $(CACERTS_PKG)/usr/share/doc/ca-certificates-$(version) ; \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(CACERTS_PKG))
	@touch $@

$(CACERTS_PKG_DESCRIPTION_FILE): $(CACERTS_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(CACERTS_PKG_DESCRIPTION_FILE) $(CACERTS_PKG_INSTALL_SCRIPT)
	@cp $(CACERTS_PKG_DESCRIPTION_FILE) $(CACERTS_PKG)/.DESCRIPTION
	@cp $(CACERTS_PKG_INSTALL_SCRIPT) $(CACERTS_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(CACERTS_PKG)/.REQUIRES
	@echo "pkgname=$(CACERTS_PKG_NAME)"                            >  $(CACERTS_PKG)/.PKGINFO ; \
	 echo "pkgver=$(CACERTS_PKG_VERSION)"                          >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "arch=$(CACERTS_PKG_ARCH)"                               >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "distroname=$(CACERTS_PKG_DISTRO_NAME)"                  >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "distrover=$(CACERTS_PKG_DISTRO_VERSION)"                >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "group=$(CACERTS_PKG_GROUP)"                             >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(CACERTS_PKG_SHORT_DESCRIPTION)\"" >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "url=$(CACERTS_PKG_URL)"                                 >> $(CACERTS_PKG)/.PKGINFO ; \
	 echo "license=$(CACERTS_PKG_LICENSE)"                         >> $(CACERTS_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(CACERTS_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
