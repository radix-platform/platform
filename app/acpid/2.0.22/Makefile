
COMPONENT_TARGETS  = $(HARDWARE_PC32)
COMPONENT_TARGETS += $(HARDWARE_PC64)


NEED_ABS_PATH      = true
COMPONENT_IS_3PP   = true


include ../../../build-system/constants.mk


SOURCE_REQUIRES    = sources/packages/a/acpid

REQUIRES           = dev/gcc/4.9.2
#
# NOTE:
# ----
#   If gcc-runtime used instead of gcc then we have to declare
#   GNU Libc dependencies in the following way:
#
#   REQUIRES           = libs/glibc/2.21
#

# ======= __END_OF_REQUIRES__ =======


version            = 2.0.22
tar_xz_archive     = $(SRC_PACKAGE_PATH)/packages/a/acpid/acpid-$(version).tar.xz
SRC_ARCHIVE        = $(tar_xz_archive)
SRC_DIR            = $(TARGET_BUILD_DIR)/acpid-$(version)
src_dir_name       = acpid-$(version)
src_done           = $(TARGET_BUILD_DIR)/.source_done

PATCHES = PATCHES

build_dir          = $(TARGET_BUILD_DIR)/build
build_target       = $(TARGET_BUILD_DIR)/.build_done
install_target     = $(TARGET_BUILD_DIR)/.install_done

config             = $(CURDIR)/etc


####### Targets

PKG_GROUP = app

#
# *PKG_NAME & *PKG_VERSION shouldn't be a reference to value.
#
ACPID_PKG_NAME                = acpid
ACPID_PKG_VERSION             = 2.0.22
ACPID_PKG_ARCH                = $(TOOLCHAIN)
ACPID_PKG_DISTRO_NAME         = $(DISTRO_NAME)
ACPID_PKG_DISTRO_VERSION      = $(DISTRO_VERSION)
ACPID_PKG_GROUP               = $(PKG_GROUP)
###                            |---handy-ruler-------------------------------|
ACPID_PKG_SHORT_DESCRIPTION   = ACPI daemon
ACPID_PKG_URL                 = $(BUG_URL)
ACPID_PKG_LICENSE             = GPLv2
ACPID_PKG_DESCRIPTION_FILE    = $(TARGET_BUILD_DIR)/$(ACPID_PKG_NAME)-pkg-description
ACPID_PKG_DESCRIPTION_FILE_IN = $(ACPID_PKG_NAME)-pkg-description.in
ACPID_PKG_INSTALL_SCRIPT      = $(ACPID_PKG_NAME)-pkg-install.sh

ACPID_PKG        = $(CURDIR)/$(TARGET_BUILD_DIR)/$(ACPID_PKG_NAME)-package

pkg_basename     = $(ACPID_PKG_NAME)-$(ACPID_PKG_VERSION)-$(ACPID_PKG_ARCH)-$(ACPID_PKG_DISTRO_NAME)-$(ACPID_PKG_DISTRO_VERSION)

pkg_archive      = $(TARGET_BUILD_DIR)/$(PKG_GROUP)/$(pkg_basename).$(pkg_arch_suffix)
pkg_signature    = $(call sign-name,$(pkg_archive))
pkg_description  = $(call desc-name,$(pkg_archive))
products         = $(call pkg-files,$(pkg_archive))

BUILD_TARGETS    = $(build_target)
BUILD_TARGETS   += $(install_target)

PRODUCT_TARGETS  = $(products)

ROOTFS_TARGETS   = $(pkg_archive)


include ../../../build-system/core.mk


env_sysroot = DESTDIR=$(ACPID_PKG)


extra_configure_switches  = --libdir=/lib$(LIBSUFFIX)
extra_configure_switches += --docdir=/usr/share/doc/$(src_dir_name)
extra_configure_switches += --mandir=/usr/share/man
extra_configure_switches += --disable-dependency-tracking
extra_configure_switches += --sysconfdir=/etc
extra_configure_switches += --localstatedir=/var


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
	@mkdir -p $(ACPID_PKG)
	@cd $(build_dir) && $(BUILD_ENVIRONMENT) $(MAKE) install $(env_sysroot)
	@mkdir -p $(ACPID_PKG)/etc/acpi/events
	@cp -a $(config)/acpi/acpi_handler.sh $(ACPID_PKG)/etc/acpi/acpi_handler.sh.new
	@chmod 0755 $(ACPID_PKG)/etc/acpi/acpi_handler.sh.new
	@cp -a $(config)/acpi/events/default $(ACPID_PKG)/etc/acpi/events/default
	@mkdir -p $(ACPID_PKG)/etc/rc.d
	@cp -a $(config)/rc.d/rc.acpid $(ACPID_PKG)/etc/rc.d/rc.acpid
	@chmod 0755 $(ACPID_PKG)/etc/rc.d/rc.acpid
	# ======= Install Documentation =======
	@if [ -d $(ACPID_PKG)/usr/share/man ]; then \
	  ( cd $(ACPID_PKG)/usr/share/man ; \
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
	@mkdir -p $(ACPID_PKG)/usr/doc/$(src_dir_name)
	@cp -a $(SRC_DIR)/COPYING \
	       $(ACPID_PKG)/usr/doc/$(src_dir_name)
	@rm -rf $(ACPID_PKG)/usr/share/doc/$(src_dir_name)
	@mkdir -p $(ACPID_PKG)/usr/share/doc/$(src_dir_name)
	@( cd $(SRC_DIR) ; \
	   cp -a COPYING README TESTPLAN TODO \
	         $(ACPID_PKG)/usr/share/doc/$(src_dir_name) \
	 )
	@( cd $(SRC_DIR) ; \
	   if [ -r Changelog ]; then \
	     DOCSDIR=`echo $(ACPID_PKG)/usr/share/doc/$(src_dir_name)` ; \
	     cat Changelog | head -n 1000 > $$DOCSDIR/Changelog ; \
	     touch -r Changelog $$DOCSDIR/Changelog ; \
	   fi \
	 )
	# ======= Install the same to $(TARGET_DEST_DIR) =======
	$(call install-into-devenv, $(ACPID_PKG))
	# ======= Strip binaries =======
	@( cd $(ACPID_PKG); \
	   find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2> /dev/null \
	 )
	@touch $@

$(ACPID_PKG_DESCRIPTION_FILE): $(ACPID_PKG_DESCRIPTION_FILE_IN)
	@cat $< | $(SED) -e "s/@VERSION@/$(version)/g" > $@

$(pkg_signature)   : $(pkg_archive) ;
$(pkg_description) : $(pkg_archive) ;

$(pkg_archive): $(install_target) $(ACPID_PKG_DESCRIPTION_FILE) $(ACPID_PKG_INSTALL_SCRIPT)
	@cp $(ACPID_PKG_DESCRIPTION_FILE) $(ACPID_PKG)/.DESCRIPTION
	@cp $(ACPID_PKG_INSTALL_SCRIPT) $(ACPID_PKG)/.INSTALL
	@$(BUILD_PKG_REQUIRES) $(ACPID_PKG)/.REQUIRES
	@echo "pkgname=$(ACPID_PKG_NAME)"                            >  $(ACPID_PKG)/.PKGINFO ; \
	 echo "pkgver=$(ACPID_PKG_VERSION)"                          >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "arch=$(ACPID_PKG_ARCH)"                               >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "distroname=$(ACPID_PKG_DISTRO_NAME)"                  >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "distrover=$(ACPID_PKG_DISTRO_VERSION)"                >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "group=$(ACPID_PKG_GROUP)"                             >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "short_description=\"$(ACPID_PKG_SHORT_DESCRIPTION)\"" >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "url=$(ACPID_PKG_URL)"                                 >> $(ACPID_PKG)/.PKGINFO ; \
	 echo "license=$(ACPID_PKG_LICENSE)"                         >> $(ACPID_PKG)/.PKGINFO
	@$(FAKEROOT) sh -c "cd $(ACPID_PKG) && chown -R root:root . && $(MAKE_PACKAGE) --linkadd yes .."
